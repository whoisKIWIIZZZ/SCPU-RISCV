`timescale 1ns / 1ps

module VGA_top(
    input         clk,        // 100MHz 主时钟
    input         rst,        // 高电平复位
    input         vram_we,
    input  [9:0]  vram_addr,
    input  [1:0]  vram_din,
    output [1:0]  vram_dout,
    // VGA 接口
    output         HSYNC,
    output         VSYNC,
    output [3:0]  R,
    output [3:0]  G,
    output [3:0]  B,
    // 其他接口（保留原有的定义以便兼容）
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
// 3. 字符显示逻辑 (基于 font_ascii_8_8.coe)
// =============================================================================
// 设定显示区域：左上角 (16, 16) 开始
wire [9:0] txt_local_x = col - 10'd16;
wire [8:0] txt_local_y = row - 9'd16;
// 每个字 8x8，我们显示 4 行，每行最多 16 个字符
wire in_text_area = (col >= 16 && col < 144) && (row >= 16 && row < 80);

wire [3:0] char_col_idx = txt_local_x[6:3]; // 横向第几个字
wire [2:0] char_row_idx = txt_local_y[5:3]; // 纵向第几行 (0-7)

reg [7:0] current_char_ascii;

// 定义要显示的文字内容
always @(*) begin
    case (char_row_idx)
        3'd0: begin // 第一行: UNISON: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "U"; 4'h1: current_char_ascii = "N";
                4'h2: current_char_ascii = "I"; 4'h3: current_char_ascii = "S";
                4'h4: current_char_ascii = "O"; 4'h5: current_char_ascii = "N";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd1: begin // 第二行: DETUNE: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "D"; 4'h1: current_char_ascii = "E";
                4'h2: current_char_ascii = "T"; 4'h3: current_char_ascii = "U";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd2: begin // 第三行: LOUDNESS: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "L"; 4'h1: current_char_ascii = "O";
                4'h2: current_char_ascii = "U"; 4'h3: current_char_ascii = "D";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = "S"; 4'h7: current_char_ascii = "S";
                4'h8: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd3: begin // 第四行: WAVETABLE: ***
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

// 索引 ROM：(ASCII * 8) + 字符内行偏移
wire [10:0] font_rom_addr = {current_char_ascii, txt_local_y[2:0]};
wire [7:0]  font_row_data;

// 请在 Vivado 中创建名为 font_rom 的 IP 核并载入你的 COE
font_rom your_font_unit (
    .a(font_rom_addr),
    .spo(font_row_data)
);

// 根据 X 坐标的低 3 位提取具体的像素点 (注意 COE 通常是左高右低，所以用 7 - idx)
wire pixel_on_font = in_text_area && font_row_data[3'd7 - txt_local_x[2:0]];

// =============================================================================
// 4. 和弦可视化逻辑 (Cmaj9: C4, E4, G4, B4, D5)
// =============================================================================
localparam CHORD_X_START = 10'd50;
localparam CHORD_X_END   = 10'd300;
localparam BASE_Y        = 9'd300; // 设置在屏幕偏下方
localparam NOTE_GAP      = 9'd15;

// 计算音符 Y 坐标
wire [8:0] y_c4 = BASE_Y;
wire [8:0] y_e4 = BASE_Y - NOTE_GAP * 4;
wire [8:0] y_g4 = BASE_Y - NOTE_GAP * 7;
wire [8:0] y_b4 = BASE_Y - NOTE_GAP * 11;
wire [8:0] y_d5 = BASE_Y - NOTE_GAP * 14;

// 判定是否在横线上 (线宽 3 像素)
function is_on_line;
    input [8:0] curr_y;
    input [8:0] target_y;
    begin
        is_on_line = (curr_y >= target_y - 1) && (curr_y <= target_y + 1);
    end
endfunction

wire in_chord_x = (col >= CHORD_X_START && col <= CHORD_X_END);
wire on_chord = in_chord_x && (
                is_on_line(row, y_c4) || is_on_line(row, y_e4) || 
                is_on_line(row, y_g4) || is_on_line(row, y_b4) || 
                is_on_line(row, y_d5));

// =============================================================================
// 5. 最终颜色混合
// =============================================================================
reg [3:0] r_out, g_out, b_out;

always @(*) begin
    if (!active) begin
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (pixel_on_font) begin
        // 参数文字颜色：黑色
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (on_chord) begin
        // 和弦线段颜色：黑色
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else begin
        // 背景颜色：中灰色
        r_out = 4'h8; g_out = 4'h8; b_out = 4'h8;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule