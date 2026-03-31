`timescale 1ns/1ps
module simulate();
reg clk;
reg rstn;
reg [4:0] btn_i;
reg [15:0] sw_i;
wire [15:0] led_o;
wire [7:0] disp_an_o;
wire [7:0] disp_seg_o;
main uut(
    .btn_i(btn_i),
    .clk(clk),
    .sw_i(sw_i),
    .rstn(rstn),
    .led_o(led_o),
    .disp_an_o(disp_an_o),
    .disp_seg_o(disp_seg_o)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;
integer cycles;
integer displayFlag;
integer ending;
integer StartTimes;
integer predict_hit;
integer predict_miss;

// ===== 新增：中断计数 =====
integer int_trigger_count;   // 触发了几次中断
integer int_return_count;    // 返回了几次
// ==========================

initial begin
    btn_i  = 5'b0;
    sw_i   = 16'b0;
    displayFlag       = 0;
    StartTimes        = 0;
    ending            = 0;
    rstn              = 0;
    predict_hit       = 0;
    predict_miss      = 0;
    int_trigger_count = 0;
    int_return_count  = 0;

    #100;
    rstn = 1;

    cycles = 50000000;
    for (i = 0; i < cycles; i = i + 1) begin
        #10;
        if (uut.PC_out == 32'h00000218) begin
            #500;
            $display("Simulation terminated at PC: 0x%h", uut.PC_out);
            $finish;
        end
        else if (ending) begin
            #100;
            $display("Simulation ended normally");
            $finish;
        end
    end
    $display("Simulation Finished.");
    $finish;
end

// ===== 新增：多次触发中断 =====
// 复位结束后每隔2000ns触发一次，共触发3次
initial begin
    wait(rstn == 1);   
         // 等复位结束
             force uut.U9_Counter_x.counter0      = 33'h0;        // 计数器清零
    force uut.U9_Counter_x.counter0_Lock = 32'h000F; // 设置一个很大的初值
    force uut.U9_Counter_x.M0            = 1'b1;         // 触发加载初值
    #10;
    release uut.U9_Counter_x.counter0;
    release uut.U9_Counter_x.counter0_Lock;
    release uut.U9_Counter_x.M0;
    //force uut.U9_Counter_x.counter0_OUT = 1'b0;  // 强制counter不触发
    repeat(1000) begin
        #15000;//wtf hack value
        $display("Triggering interrupt...");
        force uut.U1_SCPU.INT = 1'b1;
        $display("Interrupt triggered.");
        #1;
        force uut.U1_SCPU.INT = 1'b0;
        release uut.U1_SCPU.INT;
        int_trigger_count = int_trigger_count + 1;
        $display("[INT] 第%0d次中断触发，时刻=%0t ns，PC=0x%h",
            int_trigger_count, $time, uut.PC_out);
    end
end
// ==============================

always @(posedge uut.Clk_CPU) begin
 force uut.U9_Counter_x.counter0_OUT = 1'b0;  // 强制counter不触发
// if(uut.U1_SCPU.INT !== uut.U9_Counter_x.counter0_OUT)
//     $display("[DEBUG] INT和counter0_OUT不一致");
// if(uut.U1_SCPU.int_req)
//     $display("[DEBUG] int_req=%b ie=%b pc_stall=%b int_taken=%b,INT = %b",
//         uut.U1_SCPU.int_req,
//         uut.U1_SCPU.ie,
//         uut.U1_SCPU.pc_stall,
//         uut.U1_SCPU.int_taken,
//         uut.U1_SCPU.INT);
//     // 预测命中率统计
    if (uut.U1_SCPU.ID_EX_Branch) begin
        if (uut.U1_SCPU.mispredicted)
            predict_miss = predict_miss + 1;
        else
            predict_hit  = predict_hit  + 1;
    end

    // ===== 新增：监控中断进入和返回 =====
    // int_taken拉高：CPU接受中断，跳往0x004
    if (uut.U1_SCPU.int_taken) begin
        int_return_count = int_return_count;   // 占位，下方统计返回
        $display("[INT] CPU接受中断，保存mepc=0x%h，跳转至0x00000004，PC=0x%h",
            uut.U1_SCPU.mepc, uut.PC_out);
    end

    // PC到达mret指令地址（0x030）：中断即将返回
    if (uut.PC_out == 32'h00000aa0) begin
        int_return_count = int_return_count + 1;
        $display("[INT] 第%0d次中断返回，mem[0x500]=0x%h（中断计数器）",
            int_return_count,
            uut.U3_RAM_B.douta   // 直接读RAM输出，需要先让地址对准
        );
    end
    // =====================================
   // $display(uut.U9_Counter_x.counter0);
    if (displayFlag)
        $display(
            "PC: 0x%h | mepc:0x%h,x1:0x%h x2:0x%h x10:0x%h x14:0x%h x15:0x%h pcstall=%b",
            uut.U1_SCPU.ID_EX_PC,
            uut.U1_SCPU.mepc,
            uut.U1_SCPU.u_rf.rf[1],
            uut.U1_SCPU.u_rf.rf[2],
            uut.U1_SCPU.u_rf.rf[10],
            uut.U1_SCPU.u_rf.rf[14],
            uut.U1_SCPU.u_rf.rf[15],
            uut.U1_SCPU.pc_stall
        );

    if (uut.PC_out == 32'h00000248) $display("jump into Section 1.");
    if (uut.PC_out == 32'h000002d8) $display("jump into Section 2.");
    if (uut.PC_out == 32'h00000420) $display("jump into Section 3.");
    if (uut.PC_out == 32'h00000494) $display("jump into Section 4.");
    if (uut.PC_out == 32'h00000658) $display("jump into Section 5.");
    if (uut.PC_out == 32'h00000a24) $display("jump into Section 6.");

    if (uut.PC_out == 32'h0000008c) begin
        $display("Congratulations! All sections passed.");
        $display("[PREDICT STAT] hit=%0d miss=%0d rate=%0d%%",
            predict_hit,
            predict_miss,
            (predict_hit + predict_miss > 0) ?
                predict_hit * 100 / (predict_hit + predict_miss) : 0
        );
        $display("[INT STAT] 触发=%0d次 返回=%0d次",
            int_trigger_count, int_return_count);
        ending = 1;
    end
end

endmodule