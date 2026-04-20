`timescale 1ns/1ps
module simulate();

reg clk;
reg rstn;
reg [4:0]  btn_i;
reg [15:0] sw_i;
wire [15:0] led_o;
wire [7:0]  disp_an_o;
wire [7:0]  disp_seg_o;
wire HSYNC, VSYNC;
wire [3:0] R, G, B;

// PS2仿真信号
reg PS2C_reg, PS2D_reg;
wire PS2C;
wire PS2D;
pullup(PS2C);
pullup(PS2D);
// 模拟开漏输出：1->释放总线(z), 0->拉低总线(0)
assign PS2C = PS2C_reg ? 1'bz : 1'b0;
assign PS2D = PS2D_reg ? 1'bz : 1'b0;

main uut(
    .btn_i      (btn_i),
    .clk        (clk),
    .sw_i       (sw_i),
    .rstn       (rstn),
    .led_o      (led_o),
    .disp_an_o  (disp_an_o),
    .disp_seg_o (disp_seg_o),
    .VGA_HSYNC  (HSYNC),
    .VGA_VSYNC  (VSYNC),
    .VGA_R      (R),
    .VGA_G      (G),
    .VGA_B      (B),
    .PS2C       (PS2C),
    .PS2D       (PS2D)
);

// 时钟生成：100MHz
initial begin clk = 0; forever #5 clk = ~clk; end

// 统计与监控变量
integer predict_hit, predict_miss;
integer int_trigger_count, int_return_count;
integer frame_count, pixel_count;
reg [255:0] ppm_filename;
integer ppm_fp;

// =============================================================================
// PS2发送字节核心 Task (优化版)
// =============================================================================
task ps2_send_byte;
    input [7:0] data;
    integer j;
    reg parity;
    begin
        parity = 1; // 奇校验初始值
        for(j = 0; j < 8; j = j+1)
            parity = parity ^ data[j];

        // 确保起始状态总线为高
        PS2C_reg = 1; PS2D_reg = 1; 
        #50007; // 增加非整数延迟，彻底避开 clk 上升沿

        // --- 起始位 ---
        PS2D_reg = 0;
        #20007; PS2C_reg = 0; #20007; PS2C_reg = 1;

        // --- 8个数据位 (LSB First) ---
        for(j = 0; j < 8; j = j+1) begin
            #10007; // 数据建立时间
            PS2D_reg = data[j];
            #10007; PS2C_reg = 0; #20007; PS2C_reg = 1;
        end

        // --- 奇校验位 ---
        #10007;
        PS2D_reg = parity;
        #10007; PS2C_reg = 0; #20007; PS2C_reg = 1;

        // --- 停止位 ---
        #10007;
        PS2D_reg = 1;
        #10007; PS2C_reg = 0; #20007; PS2C_reg = 1;

        #50007; // 帧间空闲
        $display("[PS2] 发送字节 0x%h 完成，时刻=%0t", data, $time);
    end
endtask

// =============================================================================
// 主仿真流程
// =============================================================================
initial begin
//    $dumpfile("wave.vcd");   // 指定输出文件名
//    $dumpvars(0, simulate); // 0 = 转储所有层级的信号
    // 初始化信号
    btn_i             = 5'b0;
    sw_i              = 16'b0;
    predict_hit       = 0;
    predict_miss      = 0;
    int_trigger_count = 0;
    int_return_count  = 0;
    frame_count       = 0;
    PS2C_reg          = 1;
    PS2D_reg          = 1;
    rstn              = 0;
     force uut.U9_Counter_x.counter_ch = 2'b0;
    #100; // 异步复位一段时间
    rstn = 1;
    //#1000000000000;

    // 屏蔽干扰
   
    
    // $display("--- 开始发送 PS2 扫描码 ---");

    // 模拟按下 'A' (0x1C)
    // ps2_send_byte(8'h29);
    // //#10_000_000;
    // ps2_send_byte(8'hF0);
    // ps2_send_byte(8'h29);
    // ps2_send_byte(8'h29);
    // ps2_send_byte(8'hF0);
    // ps2_send_byte(8'h29);
    // //#30_000_000;
    // // 模拟按下 'B' (0x32)
    // ps2_send_byte(8'h32);
    // ps2_send_byte(8'hF0);
    // ps2_send_byte(8'h32);
    //  #30_000_000;
    // ps2_send_byte(8'h29);
    // ps2_send_byte(8'hF0);
    // ps2_send_byte(8'h29);
    // #30_000_000;
    //     ps2_send_byte(8'h29);
    // ps2_send_byte(8'hF0);
    // ps2_send_byte(8'h29);
    #30_000_000;

    // // 运行一段时间观察中断和 VGA 抓帧
    #150_000_000;
    
    $display("Simulation ended normally");
    $finish;
end

// =============================================================================
// CPU 状态实时监控 (保持原有显示逻辑)
// =============================================================================
always @(posedge uut.clk) begin
    //$display("pc:0x%h|x1:0x%h|key:0x%b|0x%h",uut.U1_SCPU.u_rf.rf[15],uut.U1_SCPU.ID_EX_PC,uut.U_VGA.key_state,uut.U4_MIO_BUS.vram_we);
    // if(uut.U3_RAM_B.RAM[1030])
    //      $display("yes");
    //$display("pc:0x%h,X31:0x%h,x15:0x%h,mepc:0x%h", uut.U1_SCPU.ID_EX_PC, uut.U1_SCPU.u_rf.rf[31],uut.U1_SCPU.u_rf.rf[15],uut.U1_SCPU.mepc);
    // $display("PC:0x%h|Ready:0x%h|ready:%h|get_rd:0x%h|RD:0x%h",uut.U1_SCPU.ID_EX_PC,uut.U_PS2.ps2_kbd.PS2_shift,uut.U_PS2.ps2_kbd.ready,uut.U_PS2.get_RD,uut.U_PS2.RD);
    // 中断监控
    if (uut.U1_SCPU.int_taken) begin
        int_trigger_count = int_trigger_count + 1;
        $display("[INT] 触发! PC=0x%h, PS2_Ready=%b", uut.PC_out, uut.U_PS2.PS2Ready);
    end

    // 这里的 PC 显示有助于调试状态机跳转
    if ($time % 10000 == 0) begin
       // $display("Time:%0t | PC:0x%h | PS2_Shift:%h", 
                // $time, uut.PC_out, uut.U_PS2.ps2_kbd.PS2_shift);
    end
end
// always @(posedge uut.U_PS2.PS2Ready) begin
//     $display("!!! SUCCESS: Keyboard Ready! Received Data = 0x%h", uut.U_PS2.ps2_kbd.data);
// end

// =============================================================================
// 原有的 PPM 抓帧逻辑 (VSYNC 触发)
// =============================================================================
always @(negedge VSYNC) begin
    if (rstn && frame_count < 5) begin // 减少抓帧数量加快仿真
        frame_count = frame_count + 1;
        pixel_count = 0;
        $sformat(ppm_filename, "./frame_%0d.ppm", frame_count);
        ppm_fp = $fopen(ppm_filename, "w");
        $fwrite(ppm_fp, "P3\n640 480\n255\n");
        repeat(800*525) begin
            @(posedge uut.U_VGA.clk25);
            if (uut.U_VGA.active) begin
                $fwrite(ppm_fp, "%0d %0d %0d\n", R*17, G*17, B*17);
                pixel_count = pixel_count + 1;
            end
        end
        $fclose(ppm_fp);
        $display("[VGA] 抓帧 %0d 完成", frame_count);
    end
end

endmodule