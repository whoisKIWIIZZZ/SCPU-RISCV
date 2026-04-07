`timescale 1ns/1ps
module main(btn_i, clk, sw_i, rstn, led_o, disp_an_o, disp_seg_o,
            VGA_HSYNC, VGA_VSYNC, VGA_R, VGA_G, VGA_B,PS2C,PS2D);  // 新增

    input [4:0] btn_i;
    input clk;
    input [15:0] sw_i;
    input rstn;
    output [15:0] led_o;
    output [7:0] disp_an_o;
    output [7:0] disp_seg_o;
    output        VGA_HSYNC;
    output        VGA_VSYNC;
    output [3:0]  VGA_R;
    output [3:0]  VGA_G;
    output [3:0]  VGA_B;
    inout PS2C;
inout PS2D;
wire [31:0] counter_out;
 wire [31:0] ROM_output;    
    wire [4:0] BTN_out;
    wire [15:0] SW_out;
        wire        ps2_ready;
    Enter U10_Enter(
        .clk(clk),
        .BTN(btn_i),
        .SW(sw_i),
        .BTN_out(BTN_out),
        .SW_out(SW_out)
    );


// 新增内部连线

wire [7:0]  ps2_key;
wire        ps2_rd;
wire [31:0] ps2_scancode;
    wire Clk_CPU;
    wire [31:0] clkdiv;
    clk_div U8_clk_div(
        .SW2(SW_out[2]),
        .clk(clk),
        .rst(~rstn),
        .Clk_CPU(Clk_CPU),
        .clkdiv(clkdiv)
    );

    wire GPIOf0000000_we;
    wire [31:0] Peripheral_in;
    wire [15:0] LED_out;
    wire [1:0] counter_set;
    SPIO U7_SPIO(
        .EN(GPIOf0000000_we),
        .P_Data(Peripheral_in),
        .clk(~Clk_CPU),
        .rst(~rstn),
        .LED_out(LED_out),
        .counter_set(counter_set),
        .led(led_o)
    );

    wire counter_we;
    wire counter0_OUT;
    wire counter1_OUT;
    wire counter2_OUT;
    Counter_x U9_Counter_x(
        .clk(~Clk_CPU),
        .clk0(clkdiv[0]),
        .clk1(clkdiv[10]),
        .clk2(clkdiv[12]),
        .counter_ch(counter_set),
        .counter_val(Peripheral_in),
        .counter_we(counter_we),
        .rst(~rstn),
        .counter0_OUT(counter0_OUT),
        .counter1_OUT(counter1_OUT),
        .counter2_OUT(counter2_OUT),
        .counter_out(counter_out)
    );

    wire [31:0] Addr_out;
    wire [31:0] Data_write;
    wire [2:0] dm_ctrl;
    wire mem_w;
    wire [31:0] Data_read;
    wire [3:0] wea_mem;
    wire [31:0] Data_write_to_dm;
    wire [31:0] Cpu_data4bus;
    dm_controller U3_dm_controller(
        .Addr_in(Addr_out),
        .Data_read_from_dm(Cpu_data4bus),
        .Data_write(Data_write),
        .dm_ctrl(dm_ctrl),
        .mem_w(mem_w),
        .Data_read(Data_read),
        .Data_write_to_dm(Data_write_to_dm),
        .wea_mem(wea_mem)
    );

    wire CPU_MIO;
    wire MIO_ready=1'b1;
    wire [31:0] Data_out;
    wire [31:0] PC_out;
    SCPU U1_SCPU(
        .Data_in(Data_read),
        .INT( ps2_ready),
        .MIO_ready(MIO_ready),
        .clk(Clk_CPU),
        .inst_in(ROM_output),
        .reset(~rstn),
        .Addr_out(Addr_out),
        .CPU_MIO(CPU_MIO),
        .Data_out(Data_out),
        .PC_out(PC_out),
        .dm_ctrl(dm_ctrl),
        .mem_w(mem_w)
    );

    wire [9:0] addra;
    wire [31:0] douta;
    blk_mem_gen_4 U3_RAM_B(
        .addra(addra),
        .clka(~clk),
        .dina(Data_write_to_dm),
        .wea(wea_mem),
        .douta(douta)
    );
    wire        vram_we;
    wire [9:0]  vram_addr;
    wire [1:0]  vram_dout;

    
    wire GPIOe0000000_we;
    MIO_BUS U4_MIO_BUS(
        .BTN(BTN_out),
        .Cpu_data2bus(Data_out),
        .PC(PC_out),
        .SW(SW_out),
        .addr_bus(Addr_out),
        .clk(clk),
        .counter_out(counter_out),
        .counter0_out(counter0_OUT),
        .counter1_out(counter1_OUT),
        .counter2_out(counter2_OUT),
        .led_out(LED_out),
        .mem_w(mem_w),
        .ram_data_out(douta),
        .rst(~rstn),
        .Cpu_data4bus(Cpu_data4bus),
        .GPIOe0000000_we(GPIOe0000000_we),
        .GPIOf0000000_we(GPIOf0000000_we),
        .Peripheral_in(Peripheral_in),
        .counter_we(counter_we),
        .ram_addr(addra),
        .ram_data_in(Data_write),
        .vram_we  (vram_we),
        .vram_addr(vram_addr),
        .vram_dout(vram_dout),
        .ps2_ready(ps2_ready),
        .ps2_key(ps2_key)
    );

   
    dist_mem_gen_2 U2_ROM_D(
        .a({PC_out[11:2]}),
        .spo(ROM_output)
    );

    wire [31:0] Disp_num;
    wire [7:0] LE_out;
    wire [7:0] point_out;
    Multi_8CH32 U5_Multi_8CH32(
        .EN(GPIOe0000000_we),
        .LES(64'hffff_ffff_ffff_ffff),
        .Switch(SW_out[7:5]),
        .clk(~Clk_CPU),
        .data0(Peripheral_in),
        .data1({{2'b0},PC_out[31:2]}),
        .data2(ROM_output),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(Cpu_data4bus),
        .data7(PC_out),
        .point_in({32'b0,clkdiv}),
        .rst(~rstn),
        .Disp_num(Disp_num),
        .LE_out(LE_out),
        .point_out(point_out)
    );

    SSeg7 U6_SSeg7(
        .Hexs(Disp_num),
        .LES(LE_out),
        .SW0(SW_out[0]),
        .clk(clk),
        .flash(clkdiv[10]),
        .point(point_out),
        .rst(~rstn),
        .seg_an(disp_an_o),
        .seg_sout(disp_seg_o)
    );

    // =============================================================================
    // VRAM：19x19棋盘状态，每格2bit，CPU通过地址0xC0000000~写入
    // 地址计算：offset = (row*19 + col) * 4
    // =============================================================================
    // wire vram_we;
    // wire [9:0] vram_addr;
    wire [1:0] vram_din;

    // VRAM写使能：地址高4位=0xC时命中
    assign vram_we   = mem_w && (Addr_out[31:28] == 4'hC);
    // VRAM地址：取偏移部分，除以4得到格子索引（0~360）
    assign vram_addr = Addr_out[11:2];      // 低10位，去掉字节偏移
    // 写入数据：只取低2bit（00空/01黑/10白）
    assign vram_din  = Data_out[1:0];

    VGA_top U_VGA(
        .clk      (clk),           // 100MHz直接给VGA，内部自己分频
        .rst      (~rstn),
        .vram_we  (vram_we),
        .vram_addr(vram_addr),
        .vram_din (Data_out[1:0]),
        .vram_dout(vram_dout),
        .HSYNC    (VGA_HSYNC),
        .VSYNC    (VGA_VSYNC),
        .R        (VGA_R),
        .G        (VGA_G),
        .B        (VGA_B)
    );


// ps2_rd：CPU读PS2数据时拉高
// 地址0xF0000008时触发读
assign ps2_rd = (Addr_out == 32'hF0000008) && !mem_w;

// 实例化PS2IO
PS2IO U_PS2(
    .io_read_clk(Clk_CPU),
    .clk        (clk),
    .rst        (~rstn),
    .PS2C       (PS2C),
    .PS2D       (PS2D),
    .RD         (ps2_rd),
    .testkey    (),
    .Scancode   (ps2_scancode),
    .key        (ps2_key),
    .PS2Ready   (ps2_ready)
);
endmodule