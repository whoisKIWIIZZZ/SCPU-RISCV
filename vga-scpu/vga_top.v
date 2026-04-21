`timescale 1ns / 1ps

module VGA_top(
    input         clk,        // 100MHz 主时钟
    input         rst,        // 高电平复位
    input         vram_we,    // 写使能：mem_w && (addr_bus[31:28]==4'hC)
    input  [13:0] vram_addr,  // ★ 14位地址直接作为14位按键状态数据
    input  [1:0]  vram_din,   // Cpu_data2bus[1:0]，本设计未使用（保留接口兼容）
    output [1:0]  vram_dout,  // 回读按键状态低2位（调试用）
    // VGA 接口
    output        HSYNC,
    output        VSYNC,
    output [3:0]  R,
    output [3:0]  G,
    output [3:0]  B,
    // 其他接口
    output        pixel_clk
);

// =============================================================================
// 1. 时钟分频 (100MHz -> 25MHz)
// =============================================================================
reg [1:0] clk_div;
always @(posedge clk or posedge rst) begin
    if (rst) clk_div <= 0;
    else     clk_div <= clk_div + 1;
end
wire clk25 = clk_div[1];
assign pixel_clk = clk25;

// =============================================================================
// 2. VGA 扫描实例化
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
// 3. ★ 按键状态锁存：vram_addr[13:0] 直接作为14位按键状态
//    bit0=C4, bit1=C#4, bit2=D4, ..., bit13=C#5
//    1=按下(绘制黑色标记), 0=未按下(不绘制)
// =============================================================================
reg [13:0] key_state;

always @(posedge clk) begin
    if (rst) begin
        key_state <= 14'b0;
    end else if (vram_we) begin
        key_state <= vram_addr[13:0];
    end else begin
        key_state <= key_state;
    end
end

assign vram_dout = key_state[1:0];

// =============================================================================
// 4. 字符显示逻辑 (原有逻辑，完全保留)
// =============================================================================
wire [9:0] txt_local_x = col - 10'd16;
wire [8:0] txt_local_y = row - 9'd16;
wire in_text_area = (col >= 16 && col < 144) && (row >= 16 && row < 80);

wire [3:0] char_col_idx = txt_local_x[6:3];
wire [2:0] char_row_idx = txt_local_y[5:3];

reg [7:0] current_char_ascii;

always @(*) begin
    case (char_row_idx)
        3'd0: begin
            case (char_col_idx)
                4'h0: current_char_ascii = "U"; 4'h1: current_char_ascii = "N";
                4'h2: current_char_ascii = "I"; 4'h3: current_char_ascii = "S";
                4'h4: current_char_ascii = "O"; 4'h5: current_char_ascii = "N";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd1: begin
            case (char_col_idx)
                4'h0: current_char_ascii = "D"; 4'h1: current_char_ascii = "E";
                4'h2: current_char_ascii = "T"; 4'h3: current_char_ascii = "U";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd2: begin
            case (char_col_idx)
                4'h0: current_char_ascii = "L"; 4'h1: current_char_ascii = "O";
                4'h2: current_char_ascii = "U"; 4'h3: current_char_ascii = "D";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = "S"; 4'h7: current_char_ascii = "S";
                4'h8: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd3: begin
            case (char_col_idx)
                4'h0: current_char_ascii = "W"; 4'h1: current_char_ascii = "A";
                4'h2: current_char_ascii = "V"; 4'h3: current_char_ascii = "E";
                4'h4: current_char_ascii = "T"; 4'h5: current_char_ascii = "A";
                4'h6: current_char_ascii = "B"; 4'h7: current_char_ascii = "L";
                4'h8: current_char_ascii = "E"; 4'h9: current_char_ascii = ":";
                default: current_char_ascii = "*";
            endcase
        end
        default: current_char_ascii = " ";
    endcase
end

wire [10:0] font_rom_addr = {current_char_ascii, txt_local_y[2:0]};
wire [7:0]  font_row_data;

font_rom your_font_unit (
    .a(font_rom_addr),
    .spo(font_row_data)
);

wire pixel_on_font = in_text_area && font_row_data[3'd7 - txt_local_x[2:0]];

// =============================================================================
// 5. ★ 14音符动态水平线显示
//    取代原静态和弦线逻辑：14条水平线竖直均匀分布
//    X范围缩短为 KEY_X_START ~ KEY_X_END
//    Y范围：以BASE_Y为底，向上按NOTE_GAP均匀分布
//    仅当对应 key_state[i] == 1 时才绘制第 i 条线
// =============================================================================
localparam KEY_X_START  = 10'd50;   // 线段起始X（比原CHORD_X_START相同）
localparam KEY_X_END    = 10'd180;  // 线段终止X（比原CHORD_X_END缩短）
localparam BASE_Y       = 9'd350;   // 最低音(bit0, C4)所在Y坐标
localparam NOTE_GAP     = 9'd10;    // 相邻音符之间的Y间距（向上）

// 判断当前像素是否在线段X范围内
wire in_key_x = (col >= KEY_X_START && col <= KEY_X_END);

// 对每个音符i，其Y坐标 = BASE_Y - i * NOTE_GAP
// 共14条线，i = 0(C4) 在最底，i = 13(C#5) 在最顶
// Y范围：BASE_Y ~ BASE_Y - 13*NOTE_GAP = 350 ~ 220

// 用组合逻辑逐一判断当前 row 是否命中某条激活的线
// 线宽为2像素（row == y_i 或 row == y_i+1）
wire [13:0] line_hit;
genvar gi;
generate
    for (gi = 0; gi < 14; gi = gi + 1) begin : gen_line
        wire [8:0] line_y = BASE_Y - gi * NOTE_GAP;
        assign line_hit[gi] = key_state[gi] &&
                               in_key_x &&
                               (row >= line_y) && (row <= line_y + 1);
    end
endgenerate

wire draw_key_line = |line_hit;

// =============================================================================
// 6. 最终颜色混合 (优先级: 消隐 > 字体 > 动态音符线 > 背景)
// =============================================================================
reg [3:0] r_out, g_out, b_out;

always @(*) begin
    if (!active) begin
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (pixel_on_font) begin
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (draw_key_line) begin
        // ★ 按下的音符线：黑色
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else begin
        // 背景：中灰色
        r_out = 4'h8; g_out = 4'h8; b_out = 4'h8;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule