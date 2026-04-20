`timescale 1ns / 1ps
module VGA_top(
    input         clk,        // 100MHz
    input         rst,
    // CPU写VRAM接口
    input         vram_we,
    input  [9:0]  vram_addr,
    input  [1:0]  vram_din,
    // CPU读VRAM接口
    output [1:0]  vram_dout,
    // VGA输出
    output        HSYNC,
    output        VSYNC,
    output [3:0]  R,
    output [3:0]  G,
    output [3:0]  B,
    // 测试台可访问的信号
    output        pixel_clk,
    output        pixel_active,
    output [9:0]  pixel_col,
    output [8:0]  pixel_row,
    output        pixel_in_board,
    output        pixel_on_line
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
// VRAM：19x19=361格，每格2bit
// 00=空 01=黑子 10=白子
// =============================================================================
reg [1:0] vram [0:360];

integer vi;
initial begin
    for (vi = 0; vi <= 360; vi = vi + 1)
        vram[vi] = 2'b00;
end

// CPU写
always @(posedge clk) begin
    if (vram_we && vram_addr <= 10'd360)
        vram[vram_addr] <= vram_din;
end

// CPU读
assign vram_dout = (vram_addr <= 10'd360) ? vram[vram_addr] : 2'b00;

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
// 最近交叉点计算（修正版）
// =============================================================================
wire [4:0] dist_cx = rx;
wire [4:0] dist_nx = CELL[4:0] - rx;
wire [4:0] dist_cy = ry;
wire [4:0] dist_ny = CELL[4:0] - ry;

wire [4:0] near_gx = (dist_cx <= dist_nx) ? gx : gx + 5'd1;
wire [4:0] near_gy = (dist_cy <= dist_ny) ? gy : gy + 5'd1;
wire [4:0] dist_x  = (dist_cx <= dist_nx) ? dist_cx : dist_nx;
wire [4:0] dist_y  = (dist_cy <= dist_ny) ? dist_cy : dist_ny;

// =============================================================================
// 星位
// =============================================================================
wire star_col = (near_gx==5'd3)||(near_gx==5'd9)||(near_gx==5'd15);
wire star_row = (near_gy==5'd3)||(near_gy==5'd9)||(near_gy==5'd15);
wire on_star  = in_grid && star_col && star_row &&
                (dist_x<=5'd2) && (dist_y<=5'd2);

// =============================================================================
// VRAM查询：当前像素对应格子的棋子状态
// =============================================================================
wire [9:0] stone_idx = {5'b0, near_gy} * 10'd19 + {5'b0, near_gx};
wire [1:0] stone_val = (in_grid && stone_idx <= 10'd360) ?
                        vram[stone_idx] : 2'b00;

wire pixel_has_stone  = (stone_val != 2'b00);
wire pixel_is_black   = (stone_val == 2'b01);
wire pixel_is_white   = (stone_val == 2'b10);

// 棋子圆形范围：八边形近似
wire in_stone = in_grid && pixel_has_stone &&
                (dist_x <= 5'd7) && (dist_y <= 5'd7) &&
                (dist_x + dist_y <= 5'd10);

// =============================================================================
// 像素颜色输出
// =============================================================================
reg [3:0] r_reg, g_reg, b_reg;

always @(*) begin
    if (!active) begin
        r_reg = 4'h0; g_reg = 4'h0; b_reg = 4'h0;
    end
    else if (in_stone) begin
        if (pixel_is_black) begin
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

assign pixel_clk       = clk25;
assign pixel_active    = active;
assign pixel_col       = col;
assign pixel_row       = row;
assign pixel_in_board  = in_board_area;
assign pixel_on_line   = on_line;

endmodule