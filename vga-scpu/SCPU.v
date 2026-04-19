module SCPU(
    input         clk,
    input         reset,
    input         MIO_ready,
    input  [31:0] inst_in,
    input  [31:0] Data_in,
    output        mem_w,
    output [31:0] PC_out,
    output [31:0] Addr_out,
    output [31:0] Data_out,
    output [2:0]  dm_ctrl,
    output        CPU_MIO,
    input         INT,
    output [31:0] mret
);

// =============================================================================
// 基本信号声明
// =============================================================================
wire is_predict_taken;
wire mispredicted;
wire [31:0] instruction;
wire [6:0]  opcode;
wire [4:0]  rs1, rs2, rd;
wire [2:0]  funct3;
wire signed [31:0] imm;

wire RegWrite, ALUsrc, MemWrite, MemRead, MemtoReg;
wire Branch, Jump, RegDst, AUIPC, LUI;
wire [1:0]  ALUOp;
wire [3:0]  ALUoperation;

wire [31:0] rd1, rd2;
wire [31:0] alu_res;
wire [31:0] alu_A, alu_B;
wire        Zero, Neg, Of, Cy;
wire        jump_taken;

// =============================================================================
// 中断相关寄存器和信号
// =============================================================================
reg  [31:0] mepc;          // 保存中断返回地址
reg         ie;            // 中断使能（1=开中断）
reg         int_req;       // 中断请求锁存

wire        int_taken;     // 本周期接受中断
wire        is_mret;       // 当前IF/ID阶段是mret指令
wire [63:0] IF_ID_in, IF_ID_out;
wire [31:0] IF_ID_instruction, IF_ID_PC;
reg  [31:0] PC;
wire [31:0] next_PC;
wire        pc_stall;

// mret指令编码固定为32'h30200073
assign is_mret = (IF_ID_instruction == 32'h30200073);

// 中断接受条件：有中断请求 & 中断使能 & 流水线没有stall
assign int_taken = int_req & ie & !pc_stall;

// 中断请求锁存：INT上升沿锁存，int_taken时清除
always @(posedge clk or posedge reset) begin
    if (reset)
        int_req <= 1'b0;
    else if (INT && !int_taken)
        int_req <= 1'b1;
    else if (int_taken)
        int_req <= 1'b0;
end

// mepc：中断发生时保存当前IF阶段PC（即将执行的指令地址）
always @(posedge clk or posedge reset) begin
    if (reset)
        mepc <= 32'h0;
    else if (int_taken)
        mepc <= PC;        // 保存当前PC，中断返回后从这里继续
end

// ie：中断发生时关中断，mret时重新开中断
always @(posedge clk or posedge reset) begin
    if (reset)
        ie <= 1'b1;        // 复位后默认开中断
    else if (int_taken)
        ie <= 1'b0;        // 进入中断服务程序，关中断防止嵌套
    else if (is_mret)
        ie <= 1'b1;        // mret返回，重新开中断
end

// =============================================================================
// PC 寄存器
// =============================================================================

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 32'h00000000;
    else if (!pc_stall)
        PC <= next_PC;
end

assign PC_out = PC;

// =============================================================================
// IF/ID 流水线寄存器
// =============================================================================


assign IF_ID_in = {inst_in, PC};

wire is_jump;
wire branch_taken;
wire flush_IF_ID;
wire if_id_stall;

// 中断发生时也要flush IF/ID
assign flush_IF_ID = (is_jump | mispredicted | is_predict_taken | int_taken) & !pc_stall;

GRE_array #(.WIDTH(64)) IF_ID(
    .clk(clk),
    .rst(reset),
    .write_enable(!if_id_stall),
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
// 控制单元 & ALU 控制
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
// 寄存器堆
// =============================================================================
wire MEM_WB_RegWrite;
wire [4:0]  MEM_WB_rd;
wire [31:0] reg_data_final;
wire        ID_branch_taken;

RF u_rf(
    .clk(clk),
    .sw_i(16'b0),
    .rst(reset),
    .RFWr(MEM_WB_RegWrite),
    .A1(rs1), .A2(rs2), .A3(MEM_WB_rd),
    .WD(reg_data_final),
    .RD1(rd1), .RD2(rd2)
);

immgen u_immgen(.instruction(IF_ID_instruction), .imm(imm));

// 预测器实例化


assign is_predict_taken = Branch & ID_branch_taken;

// =============================================================================
// ID/EX 流水线寄存器
// [164]      is_predict_taken
// [163]      is_jal
// [162]      Jump
// [161]      Branch
// [160]      RegWrite
// [159]      ALUsrc
// [158]      MemWrite
// [157]      MemRead
// [156]      MemtoReg
// [155]      RegDst
// [154:152]  dm_ctrl
// [151:148]  ALUoperation
// [147]      AUIPC
// [146]      LUI
// [145:143]  funct3
// [142:138]  rs1
// [137:133]  rs2
// [132:128]  rd
// [127:96]   rd1
// [95:64]    rd2
// [63:32]    imm
// [31:0]     PC
// =============================================================================
wire [164:0] ID_EX_in, ID_EX_out;
wire         flush_ID_EX;
wire         id_ex_bubble;
wire         is_jal;

// 中断发生时也要flush ID/EX
assign flush_ID_EX  = (is_jump | mispredicted | int_taken) & !pc_stall;
assign is_jal       = Branch & RegDst;
assign id_ex_bubble = pc_stall;

assign ID_EX_in = id_ex_bubble ? 165'b0 : {
    is_predict_taken,
    is_jal, Jump, Branch, RegWrite, ALUsrc, MemWrite, MemRead,
    MemtoReg, RegDst,
    dm_ctrl_id,
    ALUoperation, AUIPC, LUI,
    funct3,
    rs1, rs2, rd,
    rd1, rd2, imm, IF_ID_PC
};

GRE_array #(.WIDTH(165)) ID_EX(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(flush_ID_EX),
    .in(ID_EX_in),
    .out(ID_EX_out)
);

wire ID_EX_predict;
wire ID_EX_is_jal, ID_EX_Jump, ID_EX_Branch, ID_EX_RegWrite, ID_EX_ALUsrc;
wire ID_EX_MemWrite, ID_EX_MemRead, ID_EX_MemtoReg, ID_EX_RegDst;
wire ID_EX_AUIPC, ID_EX_LUI;
wire [2:0]  ID_EX_dm_ctrl;
wire [3:0]  ID_EX_ALUoperation;
wire [2:0]  ID_EX_funct3;
wire [4:0]  ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
wire [31:0] ID_EX_rd1, ID_EX_rd2, ID_EX_imm, ID_EX_PC;

assign ID_EX_predict      = ID_EX_out[164];
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
// EX/MEM 流水线寄存器（提前声明）
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
// MEM/WB 流水线寄存器（提前声明）
// =============================================================================
wire [103:0] MEM_WB_in, MEM_WB_out;

wire MEM_WB_MemtoReg, MEM_WB_RegDst;
wire [31:0] MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4;

assign {MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_RegDst,
        MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4,
        MEM_WB_rd} = MEM_WB_out;

wire [31:0] reg_data_tmp;
mux u_mux2(.x(MEM_WB_alu_res),  .y(MEM_WB_Data_in),   .signal(MEM_WB_MemtoReg), .z(reg_data_tmp));
mux u_mux5(.x(reg_data_tmp),    .y(MEM_WB_pc_plus_4), .signal(MEM_WB_RegDst),   .z(reg_data_final));

// =============================================================================
// Forwarding Unit
// =============================================================================
reg [1:0] ForwardA, ForwardB;

always @(*) begin
    if (EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs1))
        ForwardA = 2'b10;
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs1))
        ForwardA = 2'b01;
    else
        ForwardA = 2'b00;

    if (EX_MEM_RegWrite && (EX_MEM_rd != 5'b0) && (EX_MEM_rd == ID_EX_rs2))
        ForwardB = 2'b10;
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 5'b0) && (MEM_WB_rd == ID_EX_rs2))
        ForwardB = 2'b01;
    else
        ForwardB = 2'b00;
end

reg [31:0] forward_A_val, forward_B_val;
always @(*) begin
    case (ForwardA)
        2'b10:   forward_A_val = EX_MEM_alu_res;
        2'b01:   forward_A_val = reg_data_final;
        default: forward_A_val = ID_EX_rd1;
    endcase
    case (ForwardB)
        2'b10:   forward_B_val = EX_MEM_alu_res;
        2'b01:   forward_B_val = reg_data_final;
        default: forward_B_val = ID_EX_rd2;
    endcase
end

// =============================================================================
// Hazard Detection Unit
// =============================================================================
assign pc_stall     = ID_EX_MemRead &&
                      ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)) &&
                      (ID_EX_rd != 5'b0);
assign if_id_stall  = pc_stall;

// =============================================================================
// EX 阶段
// =============================================================================
wire [31:0] rd1_lui_out, alu_A_pre, alu_B_pre;

mux u_mux_lui(.x(forward_A_val), .y(32'b0),    .signal(ID_EX_LUI),   .z(rd1_lui_out));
mux u_muxA   (.x(rd1_lui_out),   .y(ID_EX_PC), .signal(ID_EX_AUIPC), .z(alu_A_pre));
mux u_mux1   (.x(forward_B_val), .y(ID_EX_imm),.signal(ID_EX_ALUsrc),.z(alu_B_pre));

assign alu_A = alu_A_pre;
assign alu_B = alu_B_pre;

alu u_alu(
    .A(alu_A), .B(alu_B), .ALUOp(ID_EX_ALUoperation),
    .C(alu_res), .Zero(Zero), .Neg(Neg), .Of(Of), .Cy(Cy)
);

jump u_jump(
    .Zero(Zero), .Negative(Neg), .Overflow(Of), .Carry(Cy),
    .funct3(ID_EX_funct3),
    .jump_taken(jump_taken)
);

// =============================================================================
// PC 选择逻辑
// 优先级（高→低）：
//   1. int_taken  → 中断向量 0x00000a78
//   2. is_mret    → mepc（中断返回）
//   3. is_jump    → jump_target（JALR/JAL）
//   4. mispredicted → correct_pc（预测纠错）
//   5. is_predict_taken → id_branch_target（预测跳转）
//   6. 默认 → PC+4
// =============================================================================
assign branch_taken  = ID_EX_Branch & (jump_taken | ID_EX_is_jal);
wire [31:0] branch_target;
assign branch_target = ID_EX_PC + ID_EX_imm;
assign is_jump       = ID_EX_Jump;
wire [31:0] jump_target;
assign jump_target   = (forward_A_val + ID_EX_imm) & ~32'b1;
wire [31:0] PC_plus_4;
assign PC_plus_4     = PC + 32'd4;

wire [31:0] id_branch_target;
assign id_branch_target = IF_ID_PC + imm;

assign mispredicted  = ID_EX_Branch & (branch_taken != ID_EX_predict);

wire [31:0] correct_pc;
assign correct_pc    = branch_taken ? branch_target : (ID_EX_PC + 32'd4);

// 第一级：预测
wire [31:0] pc_after_predict;
mux u_mux_predict(
    .x(PC_plus_4),
    .y(id_branch_target),
    .signal(is_predict_taken),
    .z(pc_after_predict)
);

// 第二级：预测纠错
wire [31:0] pc_after_correct;
mux u_mux_correct(
    .x(pc_after_predict),
    .y(correct_pc),
    .signal(mispredicted),
    .z(pc_after_correct)
);

// 第三级：无条件跳转
wire [31:0] pc_after_jump;
mux u_mux_jump(
    .x(pc_after_correct),
    .y(jump_target),
    .signal(is_jump),
    .z(pc_after_jump)
);

// 第四级：mret返回（覆盖普通跳转）
wire [31:0] pc_after_mret;
mux u_mux_mret(
    .x(pc_after_jump),
    .y(mepc),
    .signal(is_mret),
    .z(pc_after_mret)
);

// 第五级：中断跳转（最高优先级，覆盖一切）
mux u_mux_int(
    .x(pc_after_mret),
    .y(32'h0000001c),      // 中断向量地址，ROM里这里放中断处理程序
    .signal(int_taken),
    .z(next_PC)
);

// =============================================================================
// EX/MEM 流水线寄存器
// =============================================================================
assign EX_MEM_in = {
    ID_EX_RegWrite, ID_EX_MemtoReg, ID_EX_RegDst,
    ID_EX_MemWrite, ID_EX_dm_ctrl,
    alu_res,
    forward_B_val,
    ID_EX_PC + 32'd4,
    ID_EX_rd
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
// MEM 阶段
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
    EX_MEM_RegWrite, EX_MEM_MemtoReg, EX_MEM_RegDst,
    Data_in,
    EX_MEM_alu_res,
    EX_MEM_pc_plus_4,
    EX_MEM_rd
};

predict u_predict(
    .clk(clk),
    .reset(reset),
    .ID_EX_PC(ID_EX_PC),
    .EX_wea(ID_EX_Branch),
    .IF_ID_PC(IF_ID_PC),
    .EX_jump(branch_taken),
    .predict_jump(ID_branch_taken)
);
GRE_array #(.WIDTH(104)) MEM_WB_reg(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(1'b0),
    .in(MEM_WB_in),
    .out(MEM_WB_out)
);
assign mret = mepc;
endmodule