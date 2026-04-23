`timescale 1ns / 1ps

// =============================================================================
// VGA_top — Redesigned Display
//
// Layout (640x480):
//   Top-left   (x:10~160, y:8~72)   : Labels (UNION/DETUNE/LOUDNESS/WAVETABLE/ROOT)
//   Left-lower (x:10~90,  y:240~460): 14 note lines + note name labels
//   Center     (x:180~460,y:160~320): Animated soft RGB gradient band
//   Bottom-right                    : "kiwiizzz & zoomy" text
// =============================================================================

module VGA_top(
    input         clk,
    input         rst,
    input         vram_we,
    input  [13:0] vram_addr,
    input  [1:0]  vram_din,
    output [1:0]  vram_dout,
    output        HSYNC,
    output        VSYNC,
    output [3:0]  R,
    output [3:0]  G,
    output [3:0]  B,
    output        pixel_clk
);

// =============================================================================
// 1. Clock: 100MHz -> 25MHz
// =============================================================================
reg [1:0] clk_div;
always @(posedge clk or posedge rst) begin
    if (rst) clk_div <= 0;
    else     clk_div <= clk_div + 1;
end
wire clk25 = clk_div[1];
assign pixel_clk = clk25;

// =============================================================================
// 2. Frame counter for animation (increments each vsync ~60Hz)
//    Used to drive the flowing gradient offset
// =============================================================================
reg [9:0] frame_cnt;  // 0..1023, wraps
wire      vsync_w;

always @(posedge clk25 or posedge rst) begin
    if (rst) frame_cnt <= 0;
    else if (vsync_w) frame_cnt <= frame_cnt + 1;
end

// =============================================================================
// 3. VGA Scan
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
    .VSYNC (vsync_w)
);
assign VSYNC = vsync_w;

// =============================================================================
// 4. Key state latch
// =============================================================================
reg [13:0] key_state;
always @(posedge clk) begin
    if (rst)       key_state <= 14'b0;
    else if (vram_we) key_state <= vram_addr[13:0];
end
assign vram_dout = key_state[1:0];

// =============================================================================
// 5. Font ROM
// =============================================================================
// We reuse font_rom with 11-bit address {ascii[7:0], row[2:0]}
// =============================================================================

// Helper wires set per-region
reg  [7:0] query_char;
wire [10:0] font_addr = {query_char, 3'b000};  // We'll compute row offset differently

// We need multiple font lookups per pixel; we'll do it combinatorially by region.
// Macro: given ascii and y_in_char[2:0], address = {ascii, y_in_char}
// We instantiate one font ROM and MUX the address.

reg  [10:0] font_rom_addr_mux;
wire [7:0]  font_row_data_mux;

font_rom u_font(
    .a  (font_rom_addr_mux),
    .spo(font_row_data_mux)
);

// =============================================================================
// 6. TOP-LEFT TEXT AREA
//    5 rows of text:
//      Row0: "UNION   :"
//      Row1: "DETUNE  :"
//      Row2: "LOUDNESS:"
//      Row3: "WAVETABLE:"
//      Row4: "ROOT    : C"
//
//    Region: x in [10, 10+16*10)=[10,170), y in [8, 8+8*5)=[8,48)
//    Each char cell: 8px wide, 8px tall  (font is 8x8)
// =============================================================================
localparam TXT_X0 = 10'd10;
localparam TXT_Y0 = 9'd8;

wire in_text_area = (col >= TXT_X0) && (col < TXT_X0 + 10'd160) &&
                    (row >= TXT_Y0) && (row < TXT_Y0 + 9'd40);

wire [9:0] txt_local_x = col - TXT_X0;
wire [8:0] txt_local_y = row - TXT_Y0;

wire [3:0] txt_char_col = txt_local_x[6:3];   // col / 8
wire [2:0] txt_char_row = txt_local_y[4:3];   // row / 8  (0..4)
wire [2:0] txt_pix_y    = txt_local_y[2:0];
wire [2:0] txt_pix_x    = txt_local_x[2:0];

// Lookup ASCII for top-left text
reg [7:0] tl_ascii;
always @(*) begin
    tl_ascii = 8'h20; // space default
    case (txt_char_row)
        3'd0: case (txt_char_col) // UNION   :
            4'h0: tl_ascii = "U"; 4'h1: tl_ascii = "N";
            4'h2: tl_ascii = "I"; 4'h3: tl_ascii = "O";
            4'h4: tl_ascii = "N"; 4'h5: tl_ascii = " ";
            4'h6: tl_ascii = " "; 4'h7: tl_ascii = " ";
            4'h8: tl_ascii = ":"; default: tl_ascii = " ";
        endcase
        3'd1: case (txt_char_col) // DETUNE  :
            4'h0: tl_ascii = "D"; 4'h1: tl_ascii = "E";
            4'h2: tl_ascii = "T"; 4'h3: tl_ascii = "U";
            4'h4: tl_ascii = "N"; 4'h5: tl_ascii = "E";
            4'h6: tl_ascii = " "; 4'h7: tl_ascii = " ";
            4'h8: tl_ascii = ":"; default: tl_ascii = " ";
        endcase
        3'd2: case (txt_char_col) // LOUDNESS:
            4'h0: tl_ascii = "L"; 4'h1: tl_ascii = "O";
            4'h2: tl_ascii = "U"; 4'h3: tl_ascii = "D";
            4'h4: tl_ascii = "N"; 4'h5: tl_ascii = "E";
            4'h6: tl_ascii = "S"; 4'h7: tl_ascii = "S";
            4'h8: tl_ascii = ":"; default: tl_ascii = " ";
        endcase
        3'd3: case (txt_char_col) // WAVETABLE:
            4'h0: tl_ascii = "W"; 4'h1: tl_ascii = "A";
            4'h2: tl_ascii = "V"; 4'h3: tl_ascii = "E";
            4'h4: tl_ascii = "T"; 4'h5: tl_ascii = "A";
            4'h6: tl_ascii = "B"; 4'h7: tl_ascii = "L";
            4'h8: tl_ascii = "E"; 4'h9: tl_ascii = ":";
            default: tl_ascii = " ";
        endcase
        3'd4: case (txt_char_col) // ROOT    : C
            4'h0: tl_ascii = "R"; 4'h1: tl_ascii = "O";
            4'h2: tl_ascii = "O"; 4'h3: tl_ascii = "T";
            4'h4: tl_ascii = " "; 4'h5: tl_ascii = " ";
            4'h6: tl_ascii = " "; 4'h7: tl_ascii = " ";
            4'h8: tl_ascii = ":"; 4'h9: tl_ascii = " ";
            4'hA: tl_ascii = "C";
            default: tl_ascii = " ";
        endcase
        default: tl_ascii = " ";
    endcase
end

// =============================================================================
// 7. NOTE LINES + LABELS (lower-left)
//    14 notes: C4 C#4 D4 D#4 E4 F4 F#4 G4 G#4 A4 A#4 B4 C5 C#5
//    Line X range: [10, 90]  (80px wide)
//    Label X range: [93, 93+5*8=133)  i.e. 5 char wide max
//    BASE_Y = 450 (bottom), NOTE_GAP = 14
//    i=0 => C4 at y=450, i=13 => C#5 at y=450-13*14=268
// =============================================================================
localparam LINE_X0    = 10'd10;
localparam LINE_X1    = 10'd90;
localparam LABEL_X0   = 10'd95;
localparam NOTE_BASE_Y = 9'd450;
localparam NOTE_GAP    = 9'd14;

// Note names — each up to 4 chars, padded with spaces
// 0:C4  1:C#4  2:D4  3:D#4  4:E4  5:F4  6:F#4
// 7:G4  8:G#4  9:A4  10:A#4  11:B4  12:C5  13:C#5
// We'll display the short form: C, C#, D, D#, E, F, F#, G, G#, A, A#, B, C, C#
// Max 2 chars

// Is current pixel in label area?
// Label region: x in [LABEL_X0, LABEL_X0+24), y around each note line
wire in_label_x = (col >= LABEL_X0) && (col < LABEL_X0 + 10'd24);

// For any note i, label y band: [note_y - 4, note_y + 4) i.e. 8px tall
// We check each note
// Compute note y for current row
// To avoid 14 subtractions, we use the row and check if it maps to a note

// Note line and label drawing
wire [13:0] note_line_hit;
wire [13:0] note_label_hit;  // which note's label covers this pixel

// For labels: which char within the label?
reg [7:0]  label_char0 [0:13]; // first char
reg [7:0]  label_char1 [0:13]; // second char (or space)

initial begin
    label_char0[0]  = "C"; label_char1[0]  = " ";
    label_char0[1]  = "C"; label_char1[1]  = "#";
    label_char0[2]  = "D"; label_char1[2]  = " ";
    label_char0[3]  = "D"; label_char1[3]  = "#";
    label_char0[4]  = "E"; label_char1[4]  = " ";
    label_char0[5]  = "F"; label_char1[5]  = " ";
    label_char0[6]  = "F"; label_char1[6]  = "#";
    label_char0[7]  = "G"; label_char1[7]  = " ";
    label_char0[8]  = "G"; label_char1[8]  = "#";
    label_char0[9]  = "A"; label_char1[9]  = " ";
    label_char0[10] = "A"; label_char1[10] = "#";
    label_char0[11] = "B"; label_char1[11] = " ";
    label_char0[12] = "C"; label_char1[12] = "5";  // C5
    label_char0[13] = "C"; label_char1[13] = "#";  // C#5
end

// We'll do a priority-encoded lookup for note label rendering
reg [3:0]  active_note_idx;
reg        in_any_label;
reg [8:0]  active_note_y;
reg        in_any_line;

integer ii;
always @(*) begin
    in_any_label    = 0;
    in_any_line     = 0;
    active_note_idx = 0;
    active_note_y   = 0;

    for (ii = 0; ii < 14; ii = ii + 1) begin
        // note y = NOTE_BASE_Y - ii * NOTE_GAP
        // Use parameter-like expression
    end

    // Manual unroll for synthesis safety
    // i=0: y=450
    if ((row >= 9'd446) && (row <= 9'd451)) begin
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd450 || row == 9'd451);
        active_note_idx = 0; active_note_y = 9'd450;
    end
    if ((row >= 9'd432) && (row <= 9'd437)) begin // i=1 y=436
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd436 || row == 9'd437);
        active_note_idx = 1; active_note_y = 9'd436;
    end
    if ((row >= 9'd418) && (row <= 9'd423)) begin // i=2 y=422
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd422 || row == 9'd423);
        active_note_idx = 2; active_note_y = 9'd422;
    end
    if ((row >= 9'd404) && (row <= 9'd409)) begin // i=3 y=408
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd408 || row == 9'd409);
        active_note_idx = 3; active_note_y = 9'd408;
    end
    if ((row >= 9'd390) && (row <= 9'd395)) begin // i=4 y=394
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd394 || row == 9'd395);
        active_note_idx = 4; active_note_y = 9'd394;
    end
    if ((row >= 9'd376) && (row <= 9'd381)) begin // i=5 y=380
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd380 || row == 9'd381);
        active_note_idx = 5; active_note_y = 9'd380;
    end
    if ((row >= 9'd362) && (row <= 9'd367)) begin // i=6 y=366
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd366 || row == 9'd367);
        active_note_idx = 6; active_note_y = 9'd366;
    end
    if ((row >= 9'd348) && (row <= 9'd353)) begin // i=7 y=352
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd352 || row == 9'd353);
        active_note_idx = 7; active_note_y = 9'd352;
    end
    if ((row >= 9'd334) && (row <= 9'd339)) begin // i=8 y=338
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd338 || row == 9'd339);
        active_note_idx = 8; active_note_y = 9'd338;
    end
    if ((row >= 9'd320) && (row <= 9'd325)) begin // i=9 y=324
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd324 || row == 9'd325);
        active_note_idx = 9; active_note_y = 9'd324;
    end
    if ((row >= 9'd306) && (row <= 9'd311)) begin // i=10 y=310
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd310 || row == 9'd311);
        active_note_idx = 10; active_note_y = 9'd310;
    end
    if ((row >= 9'd292) && (row <= 9'd297)) begin // i=11 y=296
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd296 || row == 9'd297);
        active_note_idx = 11; active_note_y = 9'd296;
    end
    if ((row >= 9'd278) && (row <= 9'd283)) begin // i=12 y=282
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd282 || row == 9'd283);
        active_note_idx = 12; active_note_y = 9'd282;
    end
    if ((row >= 9'd264) && (row <= 9'd269)) begin // i=13 y=268
        in_any_label = in_label_x;
        in_any_line  = (col >= LINE_X0 && col <= LINE_X1) && (row == 9'd268 || row == 9'd269);
        active_note_idx = 13; active_note_y = 9'd268;
    end
end

// Key state for the active note line
wire draw_note_line = in_any_line && key_state[active_note_idx];

// Label pixel:  col offset from LABEL_X0
// char 0: col in [LABEL_X0, LABEL_X0+8)
// char 1: col in [LABEL_X0+8, LABEL_X0+16)
wire [9:0] lbl_col_off = col - LABEL_X0;
wire [8:0] lbl_row_off = (active_note_y >= row) ? (active_note_y - row) : (row - active_note_y);
// Center the 8px-tall glyph at note_y: pix_y = row - (note_y - 4)
wire [2:0] lbl_pix_y = row[2:0]; // just use low bits for font row
wire [2:0] lbl_pix_x = lbl_col_off[2:0];
wire       lbl_char_sel = lbl_col_off[3]; // 0=first char, 1=second char

reg [7:0] lbl_ascii;
always @(*) begin
    if (!lbl_char_sel)
        lbl_ascii = label_char0[active_note_idx];
    else
        lbl_ascii = label_char1[active_note_idx];
end

wire [7:0] lbl_font_row;
// We need a second font ROM read... but we only have one.
// We'll time-multiplex by using the same ROM but checking carefully.
// Since both text area and label area are in different pixel columns,
// we pick which address to drive:

// =============================================================================
// 8. BOTTOM-RIGHT WATERMARK
//    "kiwiizzz & zoomy"  — 18 chars
//    Region: x in [640-18*8-4, 636] = [492,636), y in [468, 476)
//    i.e. col >= 492, row >= 468
// =============================================================================
localparam WM_X0 = 10'd492;
localparam WM_Y0 = 9'd468;

wire in_wm_area = (col >= WM_X0) && (col < WM_X0 + 10'd144) &&
                  (row >= WM_Y0) && (row < WM_Y0 + 9'd8);

wire [9:0] wm_col_off = col - WM_X0;
wire [3:0] wm_char_col = wm_col_off[6:3]; // char index 0..17
wire [2:0] wm_pix_x    = wm_col_off[2:0];
wire [2:0] wm_pix_y    = row[2:0];

reg [7:0] wm_ascii;
always @(*) begin
    case (wm_char_col)
        4'h0: wm_ascii = "k"; 4'h1: wm_ascii = "i";
        4'h2: wm_ascii = "w"; 4'h3: wm_ascii = "i";
        4'h4: wm_ascii = "i"; 4'h5: wm_ascii = "z";
        4'h6: wm_ascii = "z"; 4'h7: wm_ascii = "z";
        4'h8: wm_ascii = " "; 4'h9: wm_ascii = "&";
        4'hA: wm_ascii = " "; 4'hB: wm_ascii = "z";
        4'hC: wm_ascii = "o"; 4'hD: wm_ascii = "o";
        4'hE: wm_ascii = "m"; 4'hF: wm_ascii = "y";
        default: wm_ascii = " ";
    endcase
end

// =============================================================================
// 9. Soft Animated RGB Gradient Band (center)
//    Region: x in [180, 460], y in [160, 320]  (280x160 px)
//    Gradient: hue = f(col, frame_cnt)  — slow horizontal rainbow
//    Softness: vertical gaussian-like fade at top/bottom edges (16px)
//    Colors computed from hue via HSV->RGB approximation in integer
// =============================================================================
localparam GRAD_X0 = 10'd180;
localparam GRAD_X1 = 10'd460;
localparam GRAD_Y0 = 9'd160;
localparam GRAD_Y1 = 9'd320;

wire in_grad_area = (col >= GRAD_X0) && (col <= GRAD_X1) &&
                    (row >= GRAD_Y0) && (row <= GRAD_Y1);

wire [9:0] grad_col_off = col - GRAD_X0;
wire [8:0] grad_row_off = row - GRAD_Y0;

// Hue: 0..255 mapped across 280px width + frame_cnt scroll
// hue = (grad_col_off * 255 / 280 + frame_cnt*2) mod 256
// Approximate col*255/280 ≈ col * 233 >> 8   (233/256 ≈ 0.910 vs 255/280=0.911 ✓)
wire [9:0] hue_base  = (grad_col_off * 10'd233) >> 8;  // 0..232
wire [9:0] hue_scrolled = hue_base + {frame_cnt[7:0], 1'b0}; // add 2*frame_cnt
wire [7:0] hue = hue_scrolled[7:0];  // mod 256

// HSV->RGB: S=1, V=1, hue 0..255
// sector = hue[7:5] (0..7, but only 0..5 valid for 360deg; we'll wrap hue as 0..191=360deg)
// Simpler: use smooth sinusoidal per-channel
// R = sin(hue*pi/128 + 0)   -> approximate with triangle wave
// G = sin(hue*pi/128 + 85)  (120deg offset)
// B = sin(hue*pi/128 + 171) (240deg offset)
// Triangle wave for sin: 0..64->0..255, 64..192->255..0, 192..255->0..255

function [7:0] tri_wave;
    input [7:0] phase; // 0..255
    reg [8:0] p;
    begin
        p = phase;
        if (p < 9'd64)       tri_wave = p[7:0] << 2;           // 0->0, 63->252
        else if (p < 9'd192) tri_wave = 8'd255 - ((p - 9'd64) << 1); // 64->255, 191->1
        else                 tri_wave = (p - 9'd192) << 2;     // 192->0, 255->252
    end
endfunction

wire [7:0] r_hue = tri_wave(hue);
wire [7:0] g_hue = tri_wave(hue + 8'd85);
wire [7:0] b_hue = tri_wave(hue + 8'd171);

// Vertical soft fade: edges (top 20px, bottom 20px) fade to dark
// alpha = 0..15 (4-bit), we scale by multiplying rgb >> (fade_shift)
wire [8:0] gy = grad_row_off;        // 0..160
wire [8:0] gy_from_bot = 9'd160 - gy;
wire [8:0] gy_min = (gy < gy_from_bot) ? gy : gy_from_bot;  // distance to nearest edge

// Remap: gy_min 0..20 -> alpha 0..15, saturate at 15 for gy_min>=20
wire [3:0] fade_alpha = (gy_min >= 9'd20) ? 4'hF :
                        (gy_min >= 9'd17) ? 4'hE :
                        (gy_min >= 9'd14) ? 4'hC :
                        (gy_min >= 9'd11) ? 4'hA :
                        (gy_min >= 9'd8)  ? 4'h8 :
                        (gy_min >= 9'd5)  ? 4'h5 :
                        (gy_min >= 9'd2)  ? 4'h3 :
                                            4'h1;

// Scale: r_final = r_hue * fade_alpha / 15 -> top 4 bits as VGA R[3:0]
// r_hue[7:0] * fade[3:0] = 12-bit product; top 4 bits after /15 ≈ >> 4 (since alpha/15 ≈ 1)
// Simplified: output = {r_hue[7:4]} with dim = r_hue[7:4] * fade_alpha >> 3
wire [7:0] r_grad_full = (r_hue * {4'b0, fade_alpha}) >> 4;  // 0..15
wire [7:0] g_grad_full = (g_hue * {4'b0, fade_alpha}) >> 4;
wire [7:0] b_grad_full = (b_hue * {4'b0, fade_alpha}) >> 4;

wire [3:0] r_grad = r_grad_full[3:0];
wire [3:0] g_grad = g_grad_full[3:0];
wire [3:0] b_grad = b_grad_full[3:0];

// =============================================================================
// 10. Font ROM MUX  — priority:
//     in_wm_area      -> watermark font
//     in_label area   -> note label font
//     in_text_area    -> top-left label font
// =============================================================================
always @(*) begin
    if (in_wm_area)
        font_rom_addr_mux = {wm_ascii, wm_pix_y};
    else if (in_any_label && in_label_x)
        font_rom_addr_mux = {lbl_ascii, lbl_pix_y};
    else
        font_rom_addr_mux = {tl_ascii, txt_pix_y};
end

wire txt_pixel_on  = in_text_area  && font_row_data_mux[3'd7 - txt_pix_x];
wire lbl_pixel_on  = in_any_label && in_label_x && font_row_data_mux[3'd7 - lbl_pix_x];
wire wm_pixel_on   = in_wm_area   && font_row_data_mux[3'd7 - wm_pix_x];

// Note label only shown for lit notes or always? Show always (gray) for inactive, bright for active
wire draw_lbl      = lbl_pixel_on;

// =============================================================================
// 11. Final color composition
//     Priority: blanking > font/labels > note lines > gradient > background
// =============================================================================
reg [3:0] r_out, g_out, b_out;

always @(*) begin
    if (!active) begin
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    else if (wm_pixel_on) begin
        // Watermark: dim white
        r_out = 4'h7; g_out = 4'h7; b_out = 4'h7;
    end
    else if (txt_pixel_on) begin
        // Top-left labels: white
        r_out = 4'hF; g_out = 4'hF; b_out = 4'hF;
    end
    else if (draw_note_line) begin
        // Pressed note line: bright accent (cyan)
        r_out = 4'h0; g_out = 4'hF; b_out = 4'hF;
    end
    else if (in_any_line && !key_state[active_note_idx]) begin
        // Unpressed note line: dim gray
        r_out = 4'h5; g_out = 4'h5; b_out = 4'h5;
    end
    else if (draw_lbl) begin
        // Note labels: light gray if inactive, white if active note
        if (key_state[active_note_idx]) begin
            r_out = 4'hF; g_out = 4'hF; b_out = 4'hF;
        end else begin
            r_out = 4'h7; g_out = 4'h7; b_out = 4'h7;
        end
    end
    else if (in_grad_area) begin
        r_out = r_grad; g_out = g_grad; b_out = b_grad;
    end
    else begin
        // Dark background
        r_out = 4'h1; g_out = 4'h1; b_out = 4'h2;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule