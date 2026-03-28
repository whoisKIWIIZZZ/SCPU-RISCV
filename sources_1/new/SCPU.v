// =============================================================================
// SCPU.v  —  5-stage Pipelined RISC-V CPU
// 修复清单：
//   FIX 1: IF_ID flush 由 1'b0 改为 (is_jump | branch_taken)
//   FIX 2: ID_EX 新增 funct3 打包传递，避免阶段 mismatch
//   FIX 3: ID_EX 的 ALUsrc 重复打包 bug 已修正
//   FIX 4: 新增 Forwarding Unit（EX-EX 和 MEM-EX 转发）
//   FIX 5: 新增 Hazard Detection Unit（Load-Use stall）
//   FIX 6: 多跳转时同时 flush IF/ID 和 ID/EX（各一周期）
// =============================================================================

module SCPU(
    input         clk,
    input         reset,
    input         MIO_ready,
    input  [31:0] inst_in,    // 指令输入（来自指令存储器）
    input  [31:0] Data_in,    // 数据输入（来自数据存储器）
    output        mem_w,
    output [31:0] PC_out,     // PC 输出
    output [31:0] Addr_out,   // 地址总线
    output [31:0] Data_out,   // 数据总线
    output [2:0]  dm_ctrl,
    output        CPU_MIO,
    input         INT
);

// =============================================================================
// 基本信号声明
// =============================================================================
wire [31:0] instruction;
wire [6:0]  opcode;
wire [4:0]  rs1, rs2, rd;
wire [2:0]  funct3;
wire signed [31:0] imm;

wire RegWrite, ALUsrc, MemWrite, MemRead, MemtoReg;
wire Branch, Jump, RegDst, AUIPC, LUI;
wire [1:0]  ALUOp;
wire [3:0]  ALUoperation;
wire [2:0]  dm_ctrl_wire;

wire [31:0] rd1, rd2, reg_data;
wire [31:0] alu_res;
wire [31:0] alu_A, alu_B;          // ALU 实际输入（forwarding 后）
wire [31:0] rd1_mux, rd2_mux;
wire        Zero, Neg, Of, Cy;
wire        jump_taken;

// =============================================================================
// PC 寄存器
// =============================================================================
reg  [31:0] PC;
wire [31:0] next_PC;
wire        pc_stall;               // FIX 5: Load-Use stall 时冻结 PC

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 32'h00000000;
    else if (!pc_stall)             // FIX 5
        PC <= next_PC;
end

assign PC_out = PC;

// =============================================================================
// IF/ID 流水线寄存器
// FIX 6: flush = is_jump | branch_taken  (跳转确认在 EX，需立刻冲刷 IF/ID)
// FIX 5: stall 时 write_enable = 0，保持 IF/ID 内容
// =============================================================================
wire [63:0] IF_ID_in, IF_ID_out;
wire [31:0] IF_ID_instruction, IF_ID_PC;

assign IF_ID_in = {inst_in, PC};

wire is_jump;
wire branch_taken;
wire flush_IF_ID;
wire if_id_stall;                   // FIX 5

assign flush_IF_ID = (is_jump | branch_taken)& !pc_stall;  // FIX 1 / FIX 6

GRE_array #(.WIDTH(64)) IF_ID(
    .clk(clk),
    .rst(reset),
    .write_enable(!if_id_stall),    // FIX 5: stall 时保持
    .flush(flush_IF_ID),
    .in(IF_ID_in),
    .out(IF_ID_out)
);

assign IF_ID_PC          = IF_ID_out[31:0];
assign IF_ID_instruction = IF_ID_out[63:32];

assign instruction = IF_ID_instruction;
assign opcode      = IF_ID_instruction[6:0];
assign rs1         = IF_ID_instruction[19:15];
assign rs2         = IF_ID_instruction[24:20];
assign rd          = IF_ID_instruction[11:7];
assign funct3      = IF_ID_instruction[14:12];

// =============================================================================
// 控制单元 & ALU 控制（ID 阶段）
// =============================================================================
wire [2:0] dm_ctrl_id;

control u_control(
    .instruction(IF_ID_instruction),
    .RegWrite(RegWrite),  .ALUsrc(ALUsrc),
    .MemWrite(MemWrite),  .MemRead(MemRead),
    .MemtoReg(MemtoReg),  .Branch(Branch),
    .Jump(Jump),          .RegDest(RegDst),
    .ALUOp(ALUOp),        .AUIPC(AUIPC),
    .LUI(LUI),            .DMType(dm_ctrl_id)
);

ALUcontrol u_ALUcontrol(
    .instr({IF_ID_instruction[30], funct3}),
    .ALUOp(ALUOp),
    .ALUoperation(ALUoperation)
);

// =============================================================================
// 寄存器堆（写回在 WB 阶段）
// =============================================================================
wire MEM_WB_RegWrite;
wire [4:0]  MEM_WB_rd;
wire [31:0] reg_data_final;

RF u_rf(
    .clk(clk),
    .sw_i(32'b0),
    .rst(reset),
    .RFWr(MEM_WB_RegWrite),
    .A1(rs1), .A2(rs2), .A3(MEM_WB_rd),
    .WD(reg_data_final),
    .RD1(rd1), .RD2(rd2)
);

immgen u_immgen(.instruction(IF_ID_instruction), .imm(imm));

// =============================================================================
// ID/EX 流水线寄存器
// FIX 4/5: Load-Use stall 时插入 bubble（控制信号全零）
// FIX 6:   跳转时 flush_ID_EX = 1（与 flush_IF_ID 同周期）
//
// 位宽分配（共 163 位，同原设计）：
//   [162]      Jump
//   [161]      Branch
//   [160]      RegWrite
//   [159]      ALUsrc
//   [158]      MemWrite
//   [157]      MemRead
//   [156]      MemtoReg
//   [155]      RegDst
//   [154:152]  dm_ctrl  (3位)
//   [151:148]  ALUoperation (4位)
//   [147]      AUIPC
//   [146]      LUI
//   [145:143]  funct3   (3位)
//   [142:138]  rs1      (5位)
//   [137:133]  rs2      (5位)
//   [132:128]  rd       (5位)
//   [127:96]   rd1      (32位)
//   [95:64]    rd2      (32位)
//   [63:32]    imm      (32位)
//   [31:0]     PC       (32位)
// =============================================================================
wire [163:0] ID_EX_in, ID_EX_out;
wire         flush_ID_EX;
wire         id_ex_bubble;          // FIX 5: load-use stall 时插入 bubble
wire         is_jal;

// FIX 6: 跳转时同时 flush IF/ID 和 ID/EX
assign flush_ID_EX = (is_jump | branch_taken)& !pc_stall;
assign is_jal = Branch & RegDst;
// FIX 5: load-use stall 时，ID/EX 写入全零 bubble（控制信号清零）
assign ID_EX_in = id_ex_bubble ? 164'b0 : {
    is_jal,Jump, Branch, RegWrite, ALUsrc, MemWrite, MemRead, MemtoReg, RegDst,  // [162:155]
    dm_ctrl_id,                                                             // [154:152]
    ALUoperation, AUIPC, LUI,                                              // [151:146]
    funct3,                                                                 // [145:143]
    rs1, rs2, rd,                                                           // [142:128]
    rd1, rd2, imm, IF_ID_PC                                               // [127:0]
};

GRE_array #(.WIDTH(164)) ID_EX(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(flush_ID_EX),            // FIX 6
    .in(ID_EX_in),
    .out(ID_EX_out)
);

wire ID_EX_is_jal,ID_EX_Jump, ID_EX_Branch, ID_EX_RegWrite, ID_EX_ALUsrc;
wire ID_EX_MemWrite, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_RegDst;
wire ID_EX_AUIPC, ID_EX_LUI;
wire [2:0]  ID_EX_dm_ctrl;
wire [3:0]  ID_EX_ALUoperation;
wire [2:0]  ID_EX_funct3;
wire [4:0]  ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
wire [31:0] ID_EX_rd1, ID_EX_rd2, ID_EX_imm, ID_EX_PC;

assign ID_EX_is_jal       = ID_EX_out[163];
assign ID_EX_Jump         = ID_EX_out[162];
assign ID_EX_Branch       = ID_EX_out[161];
assign ID_EX_RegWrite     = ID_EX_out[160];
assign ID_EX_ALUsrc       = ID_EX_out[159];
assign ID_EX_MemWrite     = ID_EX_out[158];
assign ID_EX_MemRead      = ID_EX_out[157];
assign ID_EX_MemtoReg     = ID_EX_out[156];
assign ID_EX_RegDst       = ID_EX_out[155];
assign ID_EX_dm_ctrl      = ID_EX_out[154:152];
assign ID_EX_ALUoperation = ID_EX_out[151:148];
assign ID_EX_AUIPC        = ID_EX_out[147];
assign ID_EX_LUI          = ID_EX_out[146];
assign ID_EX_funct3       = ID_EX_out[145:143];
assign ID_EX_rs1          = ID_EX_out[142:138];
assign ID_EX_rs2          = ID_EX_out[137:133];
assign ID_EX_rd           = ID_EX_out[132:128];
assign ID_EX_rd1          = ID_EX_out[127:96];
assign ID_EX_rd2          = ID_EX_out[95:64];
assign ID_EX_imm          = ID_EX_out[63:32];
assign ID_EX_PC           = ID_EX_out[31:0];

// =============================================================================
// EX/MEM 流水线寄存器（提前声明，供 Forwarding Unit 使用）
// =============================================================================
wire [107:0] EX_MEM_in, EX_MEM_out;

wire EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_RegDst;
wire EX_MEM_MemWrite;
wire [2:0]  EX_MEM_dm_ctrl;
wire [31:0] EX_MEM_alu_res, EX_MEM_rd2_stored, EX_MEM_pc_plus_4;
wire [4:0]  EX_MEM_rd;

assign {EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_RegDst,
        EX_MEM_MemWrite, EX_MEM_dm_ctrl,
        EX_MEM_alu_res, EX_MEM_rd2_stored, EX_MEM_pc_plus_4,
        EX_MEM_rd} = EX_MEM_out;

// =============================================================================
// MEM/WB 流水线寄存器（提前声明，供 Forwarding Unit 使用）
// =============================================================================
wire [103:0] MEM_WB_in, MEM_WB_out;

wire MEM_WB_MemtoReg, MEM_WB_RegDst;
wire [31:0] MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4;

assign {MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_RegDst,
        MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4,
        MEM_WB_rd} = MEM_WB_out;

// WB 阶段写回数据（需要在 Forwarding 前确定）
wire [31:0] reg_data_tmp;
mux u_mux2(.x(MEM_WB_alu_res),  .y(MEM_WB_Data_in),   .signal(MEM_WB_MemtoReg), .z(reg_data_tmp));
mux u_mux5(.x(reg_data_tmp),    .y(MEM_WB_pc_plus_4), .signal(MEM_WB_RegDst),   .z(reg_data_final));

// =============================================================================
// FIX 4: Forwarding Unit
//
// ForwardA/ForwardB 编码：
//   2'b00 = 使用寄存器堆读出值（ID/EX.rd1 / ID/EX.rd2）
//   2'b10 = EX-EX 转发（来自 EX/MEM.alu_res）
//   2'b01 = MEM-EX 转发（来自 WB 阶段写回数据）
//
// EX-EX 优先于 MEM-EX（EX/MEM 的结果更新）
// =============================================================================
reg [1:0] ForwardA, ForwardB;

always @(*) begin
    // ---- ForwardA（针对 rs1）----
    // EX-EX: EX/MEM 阶段要写回 & 目标非 x0 & 与 rs1 匹配
    if (EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs1))
        ForwardA = 2'b10;
    // MEM-EX: MEM/WB 阶段要写回 & 目标非 x0 & 与 rs1 匹配 & EX/MEM 没命中
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs1))
        ForwardA = 2'b01;
    else
        ForwardA = 2'b00;

    // ---- ForwardB（针对 rs2）----
    if (EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs2))
        ForwardB = 2'b10;
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs2))
        ForwardB = 2'b01;
    else
        ForwardB = 2'b00;
end

// Forwarding MUX：为 ALU 的 A 输入选择正确数据
reg [31:0] forward_A_val, forward_B_val;
always @(*) begin
    case (ForwardA)
        2'b10:   forward_A_val = EX_MEM_alu_res;    // EX-EX 转发
        2'b01:   forward_A_val = reg_data_final;     // MEM-EX 转发（WB 写回值）
        default: forward_A_val = ID_EX_rd1;          // 寄存器堆正常读值
    endcase
    case (ForwardB)
        2'b10:   forward_B_val = EX_MEM_alu_res;
        2'b01:   forward_B_val = reg_data_final;
        default: forward_B_val = ID_EX_rd2;
    endcase
end

// =============================================================================
// FIX 5: Hazard Detection Unit（Load-Use 冒险）
//
// 检测条件：
//   ID/EX 是 load 指令（MemRead 有效）
//   且 ID/EX.rd 与当前 IF/ID 指令的 rs1 或 rs2 相同
// 处理方式：
//   1. 冻结 PC（pc_stall = 1）
//   2. 冻结 IF/ID 寄存器（if_id_stall = 1）
//   3. 向 ID/EX 插入 bubble（id_ex_bubble = 1）
// =============================================================================
assign pc_stall    = ID_EX_MemRead &&
                     ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)) &&
                     (ID_EX_rd != 5'b0);

assign if_id_stall = pc_stall;
assign id_ex_bubble = pc_stall;

// =============================================================================
// EX 阶段：LUI/AUIPC MUX → ALU
// =============================================================================
wire [31:0] rd1_lui_out, alu_A_pre, alu_B_pre;

// LUI：将 rs1 替换为 0（imm 直接加 0）
mux u_mux_lui(.x(forward_A_val), .y(32'b0),    .signal(ID_EX_LUI),   .z(rd1_lui_out));
// AUIPC：将操作数 A 换为 PC
mux u_muxA   (.x(rd1_lui_out),   .y(ID_EX_PC), .signal(ID_EX_AUIPC), .z(alu_A_pre));
// ALUsrc：选择立即数还是寄存器作为操作数 B
mux u_mux1   (.x(forward_B_val), .y(ID_EX_imm),.signal(ID_EX_ALUsrc),.z(alu_B_pre));

assign alu_A = alu_A_pre;
assign alu_B = alu_B_pre;

alu u_alu(
    .A(alu_A), .B(alu_B), .ALUOp(ID_EX_ALUoperation),
    .C(alu_res), .Zero(Zero), .Neg(Neg), .Of(Of), .Cy(Cy)
);

// FIX 2: 使用 ID_EX_funct3（EX 阶段），不再用 IF/ID 阶段的 funct3
jump u_jump(
    .Zero(Zero), .Negative(Neg), .Overflow(Of), .Carry(Cy),
    .funct3(ID_EX_funct3),
    .jump_taken(jump_taken)
);

// =============================================================================
// PC 选择逻辑（EX 阶段确认跳转/分支）
// =============================================================================
assign branch_taken  = ID_EX_Branch & (jump_taken| ID_EX_is_jal);

wire [31:0] branch_target;
assign branch_target = ID_EX_PC + ID_EX_imm;

assign is_jump = ID_EX_Jump;

wire [31:0] jump_target;
assign jump_target = (forward_A_val + ID_EX_imm) & ~32'b1;   // JALR: (rs1+imm)&~1; JAL 时 rd1 已为 PC
 
wire [31:0] PC_plus_4;
assign PC_plus_4 = PC + 32'd4;

wire [31:0] branch_jump_pc;
mux u_mux_branch(
    .x(PC_plus_4),
    .y(branch_target),
    .signal(branch_taken),
    .z(branch_jump_pc)
);

mux u_mux_jump(
    .x(branch_jump_pc),
    .y(jump_target),
    .signal(is_jump),
    .z(next_PC)
);

// =============================================================================
// EX/MEM 流水线寄存器
// =============================================================================
assign EX_MEM_in = {
    ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_RegDst,  // [107:105]
    ID_EX_MemWrite, ID_EX_dm_ctrl,                  // [104:101]
    alu_res,                                         // [100:69]
    forward_B_val,                                   // [68:37] 用转发后的 rd2（store 数据）
    ID_EX_PC + 32'd4,                               // [36:5]  PC+4（JAL 写回）
    ID_EX_rd                                         // [4:0]
};

GRE_array #(.WIDTH(108)) EX_MEM_reg(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(1'b0),
    .in(EX_MEM_in),
    .out(EX_MEM_out)
);

// =============================================================================
// MEM 阶段：输出地址 & 写信号
// =============================================================================
assign Addr_out = EX_MEM_alu_res;
assign Data_out = EX_MEM_rd2_stored;
assign mem_w    = EX_MEM_MemWrite;
assign dm_ctrl  = EX_MEM_dm_ctrl;
assign CPU_MIO  = (Addr_out[31:16] != 16'b0);

// =============================================================================
// MEM/WB 流水线寄存器
// =============================================================================
assign MEM_WB_in = {
    EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_RegDst,  // [103:101]
    Data_in,                                             // [100:69]
    EX_MEM_alu_res,                                      // [68:37]
    EX_MEM_pc_plus_4,                                    // [36:5]
    EX_MEM_rd                                            // [4:0]
};

GRE_array #(.WIDTH(104)) MEM_WB_reg(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(1'b0),
    .in(MEM_WB_in),
    .out(MEM_WB_out)
);

// reg_data_final 已在前面定义并连接（WB 写回数据）
// u_mux2 和 u_mux5 也已在前面实例化

endmodule