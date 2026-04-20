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
        // ★ 核心：写使能有效时，直接锁存vram_addr的低14位作为按键状态
        key_state <= vram_addr[13:0];
    end
    else begin
        key_state <= key_state;
end
end

// 回读接口：返回当前按键状态的低2位（用于软件确认/调试）
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
        3'd0: begin  // UNISON: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "U"; 4'h1: current_char_ascii = "N";
                4'h2: current_char_ascii = "I"; 4'h3: current_char_ascii = "S";
                4'h4: current_char_ascii = "O"; 4'h5: current_char_ascii = "N";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd1: begin  // DETUNE: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "D"; 4'h1: current_char_ascii = "E";
                4'h2: current_char_ascii = "T"; 4'h3: current_char_ascii = "U";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd2: begin  // LOUDNESS: ***
            case (char_col_idx)
                4'h0: current_char_ascii = "L"; 4'h1: current_char_ascii = "O";
                4'h2: current_char_ascii = "U"; 4'h3: current_char_ascii = "D";
                4'h4: current_char_ascii = "N"; 4'h5: current_char_ascii = "E";
                4'h6: current_char_ascii = "S"; 4'h7: current_char_ascii = "S";
                4'h8: current_char_ascii = ":"; default: current_char_ascii = "*";
            endcase
        end
        3'd3: begin  // WAVETABLE: ***
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

// ★ 请确保在Vivado中已创建font_rom IP核并加载font_ascii_8_8.coe
font_rom your_font_unit (
    .a(font_rom_addr),
    .spo(font_row_data)
);

wire pixel_on_font = in_text_area && font_row_data[3'd7 - txt_local_x[2:0]];

// =============================================================================
// 5. 和弦可视化逻辑 (原有逻辑，完全保留)
// =============================================================================
localparam CHORD_X_START = 10'd50;
localparam CHORD_X_END   = 10'd300;
localparam BASE_Y        = 9'd300;
localparam NOTE_GAP      = 9'd15;

wire [8:0] y_c4 = BASE_Y;
wire [8:0] y_e4 = BASE_Y - NOTE_GAP * 4;
wire [8:0] y_g4 = BASE_Y - NOTE_GAP * 7;
wire [8:0] y_b4 = BASE_Y - NOTE_GAP * 11;
wire [8:0] y_d5 = BASE_Y - NOTE_GAP * 14;

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
// 6. ★ 14音符按键指示器 (水平排列，位置独立不干扰原有逻辑)
// =============================================================================
localparam KEY_Y_BASE     = 9'd220;   // 按键指示器基准Y坐标（文字下方，和弦线上方）
localparam KEY_MARKER_W   = 5'd14;    // 每个按键标记宽度(像素)
localparam KEY_MARKER_H   = 5'd10;    // 每个按键标记高度(像素)
localparam KEY_START_X    = 10'd55;   // 第一个按键(C4)起始X坐标

// 计算当前像素对应哪个音符索引 (0~13)
wire [3:0] note_idx = (col >= KEY_START_X && col < KEY_START_X + 14 * KEY_MARKER_W) ? 
                      (col - KEY_START_X) / KEY_MARKER_W : 4'hF;

// 计算在按键标记内的局部坐标
wire [4:0] local_kx = col - (KEY_START_X + note_idx * KEY_MARKER_W);
wire [4:0] local_ky = row - (KEY_Y_BASE - KEY_MARKER_H);

// 判断是否在某个按键标记矩形区域内
wire in_key_area = (note_idx < 4'd14) && 
                   (local_kx < KEY_MARKER_W) && 
                   (local_ky < KEY_MARKER_H) &&
                   (row >= KEY_Y_BASE - KEY_MARKER_H + 1) && 
                   (row <= KEY_Y_BASE);

// ★ 核心绘制逻辑: 在按键区域内 + 对应位为1 = 绘制黑色实心矩形
wire draw_key_marker = in_key_area && key_state[note_idx];

// =============================================================================
// 7. 最终颜色混合 (优先级: 消隐 > 字体 > 按键标记 > 和弦线 > 背景)
// =============================================================================
reg [3:0] r_out, g_out, b_out;

always @(*) begin
    if (!active) begin
        // 消隐区域: 黑色
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (pixel_on_font) begin
        // 参数文字: 黑色
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (draw_key_marker) begin
        // ★ 按下的按键标记: 黑色实心矩形（用户指定）
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (on_chord) begin
        // 和弦参考线: 黑色（原有逻辑）
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else begin
        // 背景: 中灰色
        r_out = 4'h8; g_out = 4'h8; b_out = 4'h8;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule