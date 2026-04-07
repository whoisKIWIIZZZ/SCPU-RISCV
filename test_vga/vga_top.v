`timescale 1ns / 1ps
module main(
    input  clk,
    input  rst,
    output HSYNC,
    output VSYNC,
    output [3:0] R,
    output [3:0] G,
    output [3:0] B
);

// =============================================================================
// 25MHz分频
// =============================================================================
reg [1:0] clk_div;
always @(posedge clk or posedge rst) begin
    if (rst) clk_div <= 0;
    else     clk_div <= clk_div + 1;
end
wire clk25 = clk_div[1];

// =============================================================================
// VGA扫描
// =============================================================================
wire [8:0] row;
wire [9:0] col;
wire       active;

VGA_Scan u_scan(
    .clk   (clk25),
    .rst   (rst),
    .row   (row),
    .col   (col),
    .Active(active),
    .HSYNC (HSYNC),
    .VSYNC (VSYNC)
);

// =============================================================================
// 帧计数器（25MHz，每帧800*525周期=420000，60fps）
// 用于驱动动画：每60帧落一子
// =============================================================================
reg [19:0] frame_pixel_cnt;  // 帧内像素计数
reg [31:0] frame_cnt;        // 总帧数
reg        frame_tick;       // 每帧脉冲

always @(posedge clk25 or posedge rst) begin
    if (rst) begin
        frame_pixel_cnt <= 0;
        frame_cnt       <= 0;
        frame_tick      <= 0;
    end else begin
        frame_tick <= 0;
        if (frame_pixel_cnt == 20'd419999) begin
            frame_pixel_cnt <= 0;
            frame_cnt       <= frame_cnt + 1;
            frame_tick      <= 1;
        end else begin
            frame_pixel_cnt <= frame_pixel_cnt + 1;
        end
    end
end

// =============================================================================
// 棋步控制：每60帧（1秒）落一子，共10手
// step=0：只显示空棋盘
// step=1：显示黑1
// ...
// step=10：显示全部10手
// =============================================================================
reg [3:0] step;  // 当前显示到第几手（0~10）

always @(posedge clk25 or posedge rst) begin
    if (rst) begin
        step <= 0;
    end else if (frame_tick && step < 4'd10) begin
        step <= step + 1;
    end
end

// =============================================================================
// 棋子数据：10手定式
// 黑点三三后外势定式
// 坐标格式：{col[4:0], row[4:0]}，棋盘格坐标（0~18）
// 奇数手=黑，偶数手=白
// =============================================================================
// 棋子颜色：1=黑，0=白
// 落子坐标（棋盘格，左上角为0,0）
reg [4:0] stone_col [0:12];
reg [4:0] stone_row [0:12];
reg       stone_color [0:12];   // 1=黑 0=白

initial begin
    // 手1：黑，星位 (3,3)
    stone_col[0]=5'd3;  stone_row[0]=5'd3;  stone_color[0]=1'b1;
    // 手2：白，三三 (2,2)
    stone_col[1]=5'd2;  stone_row[1]=5'd2;  stone_color[1]=1'b0;
    // 手3：黑，挡 (2,3)
    stone_col[2]=5'd2;  stone_row[2]=5'd3;  stone_color[2]=1'b1;
    // 手4：白，挡 (3,2)
    stone_col[3]=5'd3;  stone_row[3]=5'd2;  stone_color[3]=1'b0;
    // 手5：黑，长 (4,2)
    stone_col[4]=5'd4;  stone_row[4]=5'd2;  stone_color[4]=1'b1;
    // 手6：白，立 (4,1)
    stone_col[5]=5'd4;  stone_row[5]=5'd1;  stone_color[5]=1'b0;
    // 手7：黑，扳 (5,2)
    stone_col[6]=5'd5;  stone_row[6]=5'd2;  stone_color[6]=1'b1;
    // 手8：白，虎 (2,0)
    stone_col[7]=5'd5;  stone_row[7]=5'd1;  stone_color[7]=1'b0;
    // 手9：黑，长 (0,2)
    stone_col[8]=5'd6;  stone_row[8]=5'd2;  stone_color[8]=1'b1;
    // 手10：白，接 (2,4)
    stone_col[9]=5'd1;  stone_row[9]=5'd3;  stone_color[9]=1'b0;
    stone_col[10]=5'd1;  stone_row[10]=5'd4;  stone_color[10]=1'b1;
    stone_col[11]=5'd1;  stone_row[11]=5'd2;  stone_color[11]=1'b0;
    stone_col[12]=5'd2;  stone_row[12]=5'd5;  stone_color[12]=1'b1;
end

// =============================================================================
// 棋盘参数
// =============================================================================
localparam BOARD_LEFT   = 10'd122;
localparam BOARD_TOP    = 9'd42;
localparam CELL         = 10'd22;
localparam BOARD_SIZE   = 10'd396;
localparam BOARD_RIGHT  = BOARD_LEFT + BOARD_SIZE;
localparam BOARD_BOTTOM = BOARD_TOP  + BOARD_SIZE;

// =============================================================================
// 当前像素位置计算
// =============================================================================
wire in_board_area = (col >= BOARD_LEFT - 10'd8) && (col <= BOARD_RIGHT  + 10'd8) &&
                     (row >= BOARD_TOP  - 9'd8)  && (row <= BOARD_BOTTOM + 9'd8);

wire in_grid = (col >= BOARD_LEFT) && (col <= BOARD_RIGHT) &&
               (row >= BOARD_TOP)  && (row <= BOARD_BOTTOM);

wire [9:0] dx = col - BOARD_LEFT;
wire [9:0] dy = row - BOARD_TOP;

wire [4:0] gx = dx / CELL;
wire [4:0] gy = dy / CELL;
wire [4:0] rx = dx - gx * CELL;
wire [4:0] ry = dy - gy * CELL;

wire on_hline = in_grid && (ry == 5'd0);
wire on_vline = in_grid && (rx == 5'd0);
wire on_line  = on_hline || on_vline;

// =============================================================================
// 星位（修正版）
// =============================================================================
wire [4:0] dist_cx = rx;
wire [4:0] dist_nx = CELL[4:0] - rx;
wire [4:0] dist_cy = ry;
wire [4:0] dist_ny = CELL[4:0] - ry;

wire [4:0] near_gx = (dist_cx <= dist_nx) ? gx : gx + 5'd1;
wire [4:0] near_gy = (dist_cy <= dist_ny) ? gy : gy + 5'd1;
wire [4:0] dist_x  = (dist_cx <= dist_nx) ? dist_cx : dist_nx;
wire [4:0] dist_y  = (dist_cy <= dist_ny) ? dist_cy : dist_ny;

wire star_col = (near_gx==5'd3)||(near_gx==5'd9)||(near_gx==5'd15);
wire star_row = (near_gy==5'd3)||(near_gy==5'd9)||(near_gy==5'd15);
wire on_star  = in_grid && star_col && star_row && (dist_x<=5'd2) && (dist_y<=5'd2);

// =============================================================================
// 棋子渲染
// 对每个已落的棋子，判断当前像素是否在棋子圆形范围内
// 棋子半径：8像素
// 用矩形近似圆形：dist_x<=7 && dist_y<=7 && dist_x+dist_y<=10
// =============================================================================
reg        pixel_has_stone;
reg        pixel_stone_color;   // 1=黑 0=白
reg        pixel_is_last;       // 是否是最后一手（用于标记）

integer k;
always @(*) begin
    pixel_has_stone   = 0;
    pixel_stone_color = 0;
    pixel_is_last     = 0;
    for (k = 0; k < 13; k = k+1) begin
        if (k < step) begin
            // 当前格坐标和棋子坐标相同，且在圆形范围内
            if (near_gx == stone_col[k] && near_gy == stone_row[k] &&
                dist_x <= 5'd7 && dist_y <= 5'd7 &&
                (dist_x + dist_y) <= 5'd10) begin
                pixel_has_stone   = 1;
                pixel_stone_color = stone_color[k];
                pixel_is_last     = (k == step - 1);
            end
        end
    end
end

// =============================================================================
// 最后一手标记：白色小点（黑子上）或黑色小点（白子上）
// =============================================================================
wire last_mark = pixel_is_last && (dist_x <= 5'd1) && (dist_y <= 5'd1);

// =============================================================================
// 像素颜色输出
// =============================================================================
reg [3:0] r_reg, g_reg, b_reg;

always @(*) begin
    if (!active) begin
        r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
    end
    else if (in_grid && pixel_has_stone) begin
        if (last_mark) begin
            // 最后一手标记：对比色小点
            if (pixel_stone_color) begin
                // 黑子上画白点
                r_reg = 4'hF; g_reg = 4'hF; b_reg = 4'hF;
            end else begin
                // 白子上画黑点
                r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
            end
        end else if (pixel_stone_color) begin
            // 黑子
            r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
        end else begin
            // 白子：浅灰
            r_reg = 4'hD; g_reg = 4'hD; b_reg = 4'hD;
        end
    end
    else if (on_star) begin
        r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
    end
    else if (on_line) begin
        r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
    end
    else if (in_board_area) begin
        // 棋盘木质背景：土黄
        r_reg = 4'hE; g_reg = 4'hB; b_reg = 4'h5;
    end
    else begin
        // 屏幕背景：深灰
        r_reg = 4'h3; g_reg = 4'h3; b_reg = 4'h3;
    end
end

assign R = r_reg;
assign G = g_reg;
assign B = b_reg;

endmodule