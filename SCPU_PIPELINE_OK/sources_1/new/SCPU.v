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
wire [2:0]  dm_ctrl_wire;

wire [31:0] rd1, rd2, reg_data;
wire [31:0] alu_res;
wire [31:0] alu_A, alu_B;          
wire [31:0] rd1_mux, rd2_mux;
wire        Zero, Neg, Of, Cy;
wire        jump_taken;

reg  [31:0] PC;
wire [31:0] next_PC;
wire        pc_stall;             

always @(posedge clk or posedge reset) begin
    if (reset)
        PC <= 32'h00000000;
    else if (!pc_stall)            
        PC <= next_PC;
end

assign PC_out = PC;


wire [63:0] IF_ID_in, IF_ID_out;
wire [31:0] IF_ID_instruction, IF_ID_PC;

assign IF_ID_in = {inst_in, PC};

wire is_jump;
wire branch_taken;
wire flush_IF_ID;
wire stall_IF_ID;                 

assign flush_IF_ID = (is_jump | mispredicted | is_predict_taken) & !pc_stall;

GRE_array #(.WIDTH(64)) IF_ID(
    .clk(clk),
    .rst(reset),
    .write_enable(!stall_IF_ID),   
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

wire MEM_WB_RegWrite;
wire [4:0]  MEM_WB_rd;
wire [31:0] reg_data_final;
wire ID_branch_taken; //predict one

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

assign is_predict_taken = ID_branch_taken & Branch;

wire [164:0] ID_EX_in, ID_EX_out;
wire         flush_ID_EX;
wire         stall_ID_EX;          
wire         is_jal;

assign flush_ID_EX = (is_jump | mispredicted) & !pc_stall;
assign is_jal = Branch & RegDst;
assign ID_EX_in = stall_ID_EX ? 165'b0 : {
    is_predict_taken,is_jal,Jump, Branch, RegWrite, ALUsrc, MemWrite, MemRead, MemtoReg, RegDst,  // [162:155]
    dm_ctrl_id,                                                             // [154:152]
    ALUoperation, AUIPC, LUI,                                              // [151:146]
    funct3,                                                                 // [145:143]
    rs1, rs2, rd,                                                           // [142:128]
    rd1, rd2, imm, IF_ID_PC                                               // [127:0]
};

GRE_array #(.WIDTH(165)) ID_EX(
    .clk(clk),
    .rst(reset),
    .write_enable(1'b1),
    .flush(flush_ID_EX),          
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
wire iD_EX_predict;

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

wire [103:0] MEM_WB_in, MEM_WB_out;

wire MEM_WB_MemtoReg, MEM_WB_RegDst;
wire [31:0] MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4;

assign {MEM_WB_RegWrite, MEM_WB_MemtoReg, MEM_WB_RegDst,
        MEM_WB_Data_in, MEM_WB_alu_res, MEM_WB_pc_plus_4,
        MEM_WB_rd} = MEM_WB_out;


wire [31:0] reg_data_tmp;
mux u_mux2(.x(MEM_WB_alu_res),  .y(MEM_WB_Data_in),   .signal(MEM_WB_MemtoReg), .z(reg_data_tmp));
mux u_mux5(.x(reg_data_tmp),    .y(MEM_WB_pc_plus_4), .signal(MEM_WB_RegDst),   .z(reg_data_final));


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

assign pc_stall    = ID_EX_MemRead &&
                     ((ID_EX_rd == rs1) || (ID_EX_rd == rs2)) &&
                     (ID_EX_rd != 5'b0);

assign stall_IF_ID = pc_stall;
assign stall_ID_EX = pc_stall;

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

assign branch_taken = ID_EX_Branch & (jump_taken | ID_EX_is_jal);
wire [31:0] branch_target;
assign branch_target = ID_EX_PC + ID_EX_imm;
assign is_jump = ID_EX_Jump;
wire [31:0] jump_target;
assign jump_target = (forward_A_val + ID_EX_imm) & ~32'b1;
wire [31:0] PC_plus_4;
assign PC_plus_4 = PC + 32'd4;

wire [31:0] id_branch_target;
assign id_branch_target = IF_ID_PC + imm;  
assign mispredicted = ID_EX_Branch & (branch_taken != ID_EX_predict);
wire [31:0] correct_pc;
assign correct_pc = branch_taken ? branch_target : (ID_EX_PC + 32'd4);

wire [31:0] pc_after_predict;
mux u_mux_predict(
    .x(PC_plus_4),
    .y(id_branch_target),
    .signal(is_predict_taken),   
    .z(pc_after_predict)
);
wire [31:0] pc_after_correct;
mux u_mux_correct(
    .x(pc_after_predict),
    .y(correct_pc),
    .signal(mispredicted),
    .z(pc_after_correct)
);
mux u_mux_jump(
    .x(pc_after_correct),
    .y(jump_target),
    .signal(is_jump),
    .z(next_PC)
);

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

assign Addr_out = EX_MEM_alu_res;
assign Data_out = EX_MEM_rd2_stored;
assign mem_w    = EX_MEM_MemWrite;
assign dm_ctrl  = EX_MEM_dm_ctrl;
assign CPU_MIO  = (Addr_out[31:16] != 16'b0);

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
predict u_predict(
    .clk(clk),
    .reset(reset),
    .ID_EX_PC(ID_EX_PC),
    .ID_EX_Branch(ID_EX_Branch),
    .IF_ID_PC(IF_ID_PC),
    .branch_taken(branch_taken),
    .predict_jump(ID_branch_taken)
);

endmodule