`timescale 1ns / 1ps

// =============================================================================
// VGA_top — Refactored
//
// Layout:
//   Top-left     col[ 10, 169] row[  8,  47] — text labels
//   Top-right    col[470, 677] row[  8,  15] — alphabet debug
//   Centre       col[112, 527] row[220, 251] — dynamic MIDI key history
//   Bottom-left  col[  0, 319] row[280, 479] — flowing RGB gradient
//   Bottom-right col[496, 639] row[470, 477] — watermark
//
// Bugs fixed:
//  1. Gradient flow: frame_cnt sampled vsync level (high ~418k cycles/frame),
//     so the scroll value was essentially random per pixel — no coherent flow.
//     FIX: edge-detect vsync rising edge → true once-per-frame anim_cnt.
//  2. Gradient black artifacts: vertical alpha faded to 0 at region edges,
//     outputting (0,0,0) instead of blending to background (1,1,2).
//     FIX: blend gradient colour with background by alpha.
//  3. MIDI display was static — a VRAM-driven bitmap with no time ordering.
//     FIX: FIFO history of key‑press events displayed left (oldest) to
//     right (newest); when the row is full new presses push out the oldest.
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

// ============================================================
// 1. 100MHz -> 25MHz
// ============================================================
reg [1:0] clk_div;
always @(posedge clk or posedge rst)
    if (rst) clk_div <= 0; else clk_div <= clk_div + 1;
wire clk25 = clk_div[1];
assign pixel_clk = clk25;

// ============================================================
// 2. Frame sync — true once-per-frame pulse
//    VSYNC is high for ~523 lines (level, not pulse).
//    Edge-detect the rising edge to get a 1‑clk25 strobe.
// ============================================================
reg        vsync_d;
wire       vsync_rise;
always @(posedge clk25 or posedge rst)
    if (rst) vsync_d <= 0; else vsync_d <= VSYNC;
assign vsync_rise = VSYNC && !vsync_d;

reg [7:0] anim_cnt;
always @(posedge clk25 or posedge rst)
    if (rst) anim_cnt <= 0;
    else if (vsync_rise) anim_cnt <= anim_cnt + 1;

// ============================================================
// 3. VGA Scan
// ============================================================
wire [8:0] row;
wire [9:0] col;
wire       active;
VGA_Scan u_scan(.clk(clk25),.rst(rst),.row(row),.col(col),
                .Active(active),.HSYNC(HSYNC),.VSYNC(VSYNC));

// ============================================================
// 4. Key state latch + edge detection
// ============================================================
reg [13:0] key_state;
always @(posedge clk)
    if (rst) key_state <= 14'b0;
    else if (vram_we) key_state <= vram_addr[13:0];
assign vram_dout = key_state[1:0];

// Previous key_state for edge detection
reg [13:0] prev_key;
always @(posedge clk25)
    if (rst) prev_key <= 14'b0;
    else if (vsync_rise) prev_key <= key_state;

wire [13:0] new_presses = key_state & ~prev_key;  // 0→1 edges this frame

// Priority encoder: lowest-indexed new press (0..13)
wire [3:0] first_new;
assign first_new = new_presses[0]  ? 4'd0  :
                   new_presses[1]  ? 4'd1  :
                   new_presses[2]  ? 4'd2  :
                   new_presses[3]  ? 4'd3  :
                   new_presses[4]  ? 4'd4  :
                   new_presses[5]  ? 4'd5  :
                   new_presses[6]  ? 4'd6  :
                   new_presses[7]  ? 4'd7  :
                   new_presses[8]  ? 4'd8  :
                   new_presses[9]  ? 4'd9  :
                   new_presses[10] ? 4'd10 :
                   new_presses[11] ? 4'd11 :
                   new_presses[12] ? 4'd12 :
                   new_presses[13] ? 4'd13 : 4'd0;

wire any_new = |new_presses;

// ============================================================
// 5. Key-press history FIFO  (13 slots, oldest @ idx 0)
// ============================================================
reg [3:0]  hist_note [0:12];
reg [12:0] hist_valid;
integer    hi;

always @(posedge clk25 or posedge rst) begin
    if (rst) begin
        for (hi = 0; hi < 13; hi = hi + 1) begin
            hist_note[hi] <= 4'd0;
        end
        hist_valid <= 13'b0;
    end else if (vsync_rise && any_new) begin
        // shift left: idx 0..11 ← idx 1..12
        for (hi = 0; hi < 12; hi = hi + 1) begin
            hist_note[hi] <= hist_note[hi+1];
        end
        hist_note[12] <= first_new;
        hist_valid    <= {hist_valid[11:0], 1'b1};
    end
end

// ============================================================
// 6. Font ROM
// ============================================================
reg  [9:0] font_addr;
wire [7:0] font_data;
font_rom u_font(.a(font_addr),.spo(font_data));

// ============================================================
// 7. TOP-LEFT TEXT  col[10,169] row[8,47]
// ============================================================
wire in_txt = (col>=10'd10)&&(col<10'd170)&&(row>=9'd8)&&(row<9'd48);
wire [9:0] tx = col - 10'd10;
wire [8:0] ty = row - 9'd8;
wire [2:0] txt_crow = ty[5:3];
wire [4:0] txt_ccol = tx[7:3];
wire [2:0] txt_py   = ty[2:0];
wire [2:0] txt_px   = tx[2:0];

reg [7:0] txt_ascii;
always @(*) begin
    txt_ascii = 8'h20;
    case (txt_crow)
        3'd0: case (txt_ccol)
            5'd0:txt_ascii="U"; 5'd1:txt_ascii="N"; 5'd2:txt_ascii="I";
            5'd3:txt_ascii="O"; 5'd4:txt_ascii="N"; 5'd9:txt_ascii=":";
            default:txt_ascii=" ";
        endcase
        3'd1: case (txt_ccol)
            5'd0:txt_ascii="D"; 5'd1:txt_ascii="E"; 5'd2:txt_ascii="T";
            5'd3:txt_ascii="U"; 5'd4:txt_ascii="N"; 5'd5:txt_ascii="E";
            5'd9:txt_ascii=":"; default:txt_ascii=" ";
        endcase
        3'd2: case (txt_ccol)
            5'd0:txt_ascii="L"; 5'd1:txt_ascii="O"; 5'd2:txt_ascii="U";
            5'd3:txt_ascii="D"; 5'd4:txt_ascii="N"; 5'd5:txt_ascii="E";
            5'd6:txt_ascii="S"; 5'd7:txt_ascii="S"; 5'd9:txt_ascii=":";
            default:txt_ascii=" ";
        endcase
        3'd3: case (txt_ccol)
            5'd0:txt_ascii="W"; 5'd1:txt_ascii="A"; 5'd2:txt_ascii="V";
            5'd3:txt_ascii="E"; 5'd4:txt_ascii="T"; 5'd5:txt_ascii="A";
            5'd6:txt_ascii="B"; 5'd7:txt_ascii="L"; 5'd8:txt_ascii="E";
            5'd9:txt_ascii=":"; default:txt_ascii=" ";
        endcase
        3'd4: case (txt_ccol)
            5'd0:txt_ascii="R"; 5'd1:txt_ascii="O"; 5'd2:txt_ascii="O";
            5'd3:txt_ascii="T"; 5'd9:txt_ascii=":"; 5'd11:txt_ascii="C";
            default:txt_ascii=" ";
        endcase
        default: txt_ascii=" ";
    endcase
end

// ============================================================
// 8. TOP-RIGHT ALPHABET DEBUG  A..Z
//    col[470,677] row[8,15]   26x8px, bright yellow
// ============================================================
wire in_abc = (col>=10'd470)&&(col<10'd678)&&(row>=9'd8)&&(row<9'd16);
wire [9:0] ax     = col - 10'd470;
wire [4:0] abc_ci = ax[7:3];
wire [2:0] abc_py = row[2:0];
wire [2:0] abc_px = ax[2:0];
wire [7:0] abc_ascii = 8'd65 + {3'd0, abc_ci};

// ============================================================
// 9. WATERMARK  "kiwiizzz & zoomy"
//    col[496,639] row[470,477]
// ============================================================
wire in_wm = (col>=10'd496)&&(col<10'd640)&&(row>=9'd470)&&(row<9'd478);
wire [9:0] wmx   = col - 10'd496;
wire [4:0] wm_ci = wmx[7:3];
wire [2:0] wm_py = row - 9'd470;
wire [2:0] wm_px = wmx[2:0];

function [7:0] wm_ch;
    input [4:0] ci;
    begin
        case(ci)
            5'd0:  wm_ch = 8'h6B;
            5'd1:  wm_ch = 8'h69;
            5'd2:  wm_ch = 8'h77;
            5'd3:  wm_ch = 8'h69;
            5'd4:  wm_ch = 8'h69;
            5'd5:  wm_ch = 8'h7A;
            5'd6:  wm_ch = 8'h7A;
            5'd7:  wm_ch = 8'h7A;
            5'd8:  wm_ch = 8'h20;
            5'd9:  wm_ch = 8'h26;
            5'd10: wm_ch = 8'h20;
            5'd11: wm_ch = 8'h7A;
            5'd12: wm_ch = 8'h6F;
            5'd13: wm_ch = 8'h6F;
            5'd14: wm_ch = 8'h6D;
            5'd15: wm_ch = 8'h79;
            default: wm_ch = 8'h20;
        endcase
    end
endfunction

// ============================================================
// 10. FLOWING RGB GRADIENT  (bottom-left)
//     col[0,319] row[280,479]  320×200
// ============================================================
wire in_grad = (col>=10'd0)&&(col<10'd320)&&(row>=9'd280)&&(row<9'd480);
wire [9:0] gx = col;             // 0..319
wire [8:0] gy = row - 9'd280;    // 0..199

// Hue: horizontal position + frame animation → flowing colours
wire [12:0] hue_base = ({3'b0, gx} * 13'd11) >> 4;
wire [7:0]  scroll   = anim_cnt;                  // 0..255, ~4.3 s cycle
wire [12:0] hue_raw  = {5'b0, hue_base[7:0]} + {5'b0, scroll};
// Modulo 192  (6 sectors × 32)
wire [9:0]  h0 = hue_raw[9:0];
wire [9:0]  h1 = (h0 >= 10'd384) ? h0 - 10'd384 : h0;
wire [9:0]  h2 = (h1 >= 10'd192) ? h1 - 10'd192 : h1;
wire [7:0]  hue6 = h2[7:0];

wire [2:0] sector  = hue6[7:5];
wire [7:0] ramp_up = {hue6[4:0], 3'b000};
wire [7:0] ramp_dn = 8'd248 - {hue6[4:0], 3'b000};

reg [7:0] rh, gh, bh;
always @(*) begin
    case (sector)
        3'd0: begin rh=8'hF8; gh=ramp_up; bh=8'h00; end
        3'd1: begin rh=ramp_dn; gh=8'hF8; bh=8'h00; end
        3'd2: begin rh=8'h00; gh=8'hF8; bh=ramp_up; end
        3'd3: begin rh=8'h00; gh=ramp_dn; bh=8'hF8; end
        3'd4: begin rh=ramp_up; gh=8'h00; bh=8'hF8; end
        3'd5: begin rh=8'hF8; gh=8'h00; bh=ramp_dn; end
        default: begin rh=0; gh=0; bh=0; end
    endcase
end

// Vertical alpha: 0 at top/bottom edges, 15 in the middle
wire [8:0] gy_bot  = 9'd199 - gy;
wire [8:0] gy_near = (gy < gy_bot) ? gy : gy_bot;
wire [3:0] alpha   = (gy_near >= 9'd24) ? 4'hF :
                     (gy_near <= 9'd1)  ? 4'h1 : gy_near[4:1];

// Blend gradient hue with background (1,1,2) by alpha
//   out = (hue4 * alpha + bg * (16 - alpha)) / 16
wire [3:0] r_hue4 = rh[7:4];
wire [3:0] g_hue4 = gh[7:4];
wire [3:0] b_hue4 = bh[7:4];

wire [7:0] r_blend = (r_hue4 * alpha) + (4'h1 * (5'd16 - {1'b0, alpha}));
wire [7:0] g_blend = (g_hue4 * alpha) + (4'h1 * (5'd16 - {1'b0, alpha}));
wire [7:0] b_blend = (b_hue4 * alpha) + (4'h2 * (5'd16 - {1'b0, alpha}));

wire [3:0] r_grad = r_blend[7:4];
wire [3:0] g_grad = g_blend[7:4];
wire [3:0] b_grad = b_blend[7:4];

// ============================================================
// 11. DYNAMIC MIDI KEY HISTORY  (centre)
//     col[112,527] row[220,251]   13 slots × 32 px
//
//     Each slot: 32×32 px.  Two 8×8 characters centred
//     horizontally (sx=4..11 left, sx=20..27 right) at
//     cy=8..15.  Valid slot = white text; empty = background.
// ============================================================
wire in_midi = (col>=10'd112)&&(col<10'd528)&&(row>=9'd220)&&(row<9'd252);
wire [9:0] midi_cx = col - 10'd112;   // 0..415
wire [8:0] midi_cy = row - 9'd220;    // 0..31

// Which slot (0..12) and sub‑slot pixel position
wire [3:0] midi_slot = midi_cx[8:5];  // floor(cx/32)
wire [4:0] midi_sx   = midi_cx[4:0];  // 0..31 within slot

// Character regions within a 32‑px slot
wire midi_char_left  = (midi_sx >= 5'd4) && (midi_sx < 5'd12);
wire midi_char_right = (midi_sx >= 5'd20) && (midi_sx < 5'd28);
wire in_midi_char    = midi_char_left || midi_char_right;
wire midi_char_sel   = midi_char_right;  // 0=left, 1=right
wire in_midi_char_row = (midi_cy >= 9'd8) && (midi_cy < 9'd16);
wire[4:0] tmp = midi_sx - 5'd4;
wire[4:0] tt = (midi_sx - 5'd20);
// Pixel column within the 8‑px character
wire [2:0] midi_px = midi_char_left  ? tmp[2:0]  :tt[2:0];
wire [2:0] midi_py = midi_cy[2:0];

// Note index for the slot being scanned
wire [3:0]  midi_note  = hist_note[midi_slot];
wire        midi_valid = hist_valid[midi_slot];

// Note‑label functions (same as the original note labels)
function [7:0] nc0;
    input [3:0] i;
    begin
        case(i)
            4'd0, 4'd1:  nc0 = 8'h43; // C
            4'd2, 4'd3:  nc0 = 8'h44; // D
            4'd4:        nc0 = 8'h45; // E
            4'd5, 4'd6:  nc0 = 8'h46; // F
            4'd7, 4'd8:  nc0 = 8'h47; // G
            4'd9, 4'd10: nc0 = 8'h41; // A
            4'd11:       nc0 = 8'h42; // B
            4'd12, 4'd13:nc0 = 8'h43; // C
            default:     nc0 = 8'h20;
        endcase
    end
endfunction

function [7:0] nc1;
    input [3:0] i;
    begin
        case(i)
            4'd0, 4'd2, 4'd4, 4'd5, 4'd7, 4'd9, 4'd11: nc1 = 8'h20; // ' '
            4'd1, 4'd3, 4'd6, 4'd8, 4'd10, 4'd13:      nc1 = 8'h23; // '#'
            4'd12:                                     nc1 = 8'h35; // '5'
            default:                                   nc1 = 8'h20;
        endcase
    end
endfunction

wire [7:0] midi_ascii = midi_char_sel ? nc1(midi_note) : nc0(midi_note);

// ============================================================
// 12. Font ROM address MUX
// ============================================================
always @(*) begin
    if (in_abc)
        font_addr = {abc_ascii, abc_py};
    else if (in_wm)
        font_addr = {wm_ch(wm_ci), wm_py};
    else if (in_txt)
        font_addr = {txt_ascii, txt_py};
    else if (in_midi && in_midi_char && in_midi_char_row && midi_valid)
        font_addr = {midi_ascii, midi_py};
    else
        font_addr = {8'h20, 3'b0};  // space
end

// Font pixel on/off
wire abc_on  = in_abc                     && font_data[7-abc_px];
wire wm_on   = in_wm                      && font_data[7-wm_px];
wire txt_on  = in_txt                     && font_data[7-txt_px];
wire midi_on = in_midi && in_midi_char && in_midi_char_row
               && midi_valid              && font_data[7-midi_px];

// ============================================================
// 13. Final colour output
// ============================================================
reg [3:0] r_out, g_out, b_out;

always @(*) begin
    if (!active) begin
        r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
    end
    // Alphabet debug row (yellow)
    else if (abc_on) begin
        r_out = 4'hF; g_out = 4'hF; b_out = 4'h0;
    end
    // Watermark (grey)
    else if (wm_on) begin
        r_out = 4'h7; g_out = 4'h7; b_out = 4'h7;
    end
    // Top-left text (white)
    else if (txt_on) begin
        r_out = 4'hF; g_out = 4'hF; b_out = 4'hF;
    end
    // MIDI history — white text, brighter for newer entries
    else if (midi_on) begin
        // Brightness fades with slot position (0=oldest, 12=newest)
        case (midi_slot)
            4'd12:     begin r_out=4'hF; g_out=4'hF; b_out=4'hF; end
            4'd11:     begin r_out=4'hE; g_out=4'hE; b_out=4'hE; end
            4'd10:     begin r_out=4'hD; g_out=4'hD; b_out=4'hD; end
            4'd9:      begin r_out=4'hC; g_out=4'hC; b_out=4'hC; end
            4'd8:      begin r_out=4'hB; g_out=4'hB; b_out=4'hB; end
            4'd7:      begin r_out=4'hA; g_out=4'hA; b_out=4'hA; end
            4'd6:      begin r_out=4'h9; g_out=4'h9; b_out=4'h9; end
            4'd5:      begin r_out=4'h8; g_out=4'h8; b_out=4'h8; end
            4'd4:      begin r_out=4'h7; g_out=4'h7; b_out=4'h7; end
            4'd3:      begin r_out=4'h6; g_out=4'h6; b_out=4'h6; end
            4'd2:      begin r_out=4'h5; g_out=4'h5; b_out=4'h5; end
            4'd1:      begin r_out=4'h4; g_out=4'h4; b_out=4'h4; end
            default:   begin r_out=4'h3; g_out=4'h3; b_out=4'h3; end
        endcase
    end
    // Flowing RGB gradient
    else if (in_grad) begin
        r_out = r_grad;
        g_out = g_grad;
        b_out = b_grad;
    end
    // Background (dark blue)
    else begin
        r_out = 4'h1; g_out = 4'h1; b_out = 4'h2;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule
