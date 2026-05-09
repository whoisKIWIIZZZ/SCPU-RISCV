`timescale 1ns / 1ps

// =============================================================================
// VGA_top — Piano Roll Edition  (clean rewrite)
//
// Changes vs original:
//   1. Piano keyboard → scrolling MIDI piano roll (ring buffer, 256 time steps)
//   2. Gradient: correct hue density, pastel palette, smooth vertical alpha
//   3. Text labels use 1x font (8x8px per char) → 5 rows fit in 40px
//
// Screen layout
//   col[  8, 320] row[  4,  44]  text labels        (1x font, 8px/row x 5)
//   col[  8, 200] row[ 44,  52]  ADDR hex display   (1x font, 8px/row)
//   col[ 47, 559] row[190, 310]  piano roll         (256 cols x 2px, 21 rows x 5px)
//   col[560, 632] row[190, 206]  chord display      (1x font, 2 rows)
//   col[559, 640] row[190, 310]  roll right margin  (dark fill)
//   col[  0, 320] row[320, 480]  flowing gradient
//   col[384, 640] row[462, 478]  watermark          (2x font, unchanged)
//
// Piano Roll details
//   - 21 SRL shift-registers, one per key (256 bits each, ~8 LUTs/key)
//   - On vsync_rise: shift key_state[k] into bit 0; oldest bit 255 drops off
//   - Display: roll_sh[roll_key][~roll_dcol] — dcol=255→bit0 (newest)
//   - Pitch axis: key 20 at top, key 0 at bottom; 5px/key; 21x5=105px
//   - Playhead: 2-px wide bright-white column at dcol=255 (rightmost)
//
// =============================================================================

module VGA_top(
    input         clk,
    input         rst,
    input         vram_we,
    input  [20:0] vram_addr,
    input  [1:0]  vram_din,
    output [1:0]  vram_dout,
    output        HSYNC,
    output        VSYNC,
    output [3:0]  R,
    output [3:0]  G,
    output [3:0]  B,
    output        pixel_clk,

    input [2:0]  mon_waveform,
    input [3:0]  mon_volume,
    input [3:0]  mon_unison,
    input [3:0]  mon_detune,
    input [4:0]  mon_filter,
    input [4:0]  mon_root
);

// ============================================================
// 1.  100 MHz -> 25 MHz pixel clock
// ============================================================
reg [1:0] clk_div;
always @(posedge clk or posedge rst)
    if (rst) clk_div <= 2'd0;
    else     clk_div <= clk_div + 2'd1;
wire clk25 = clk_div[1];
assign pixel_clk = clk25;

// ============================================================
// 2.  VGA scan generator
// ============================================================
wire [8:0] row;
wire [9:0] col;
wire       active;
VGA_Scan u_scan(
    .clk(clk25), .rst(rst),
    .row(row), .col(col),
    .Active(active), .HSYNC(HSYNC), .VSYNC(VSYNC)
);

// ============================================================
// 3.  VSYNC rising-edge strobe (1 clk25 pulse per frame)
// ============================================================
reg  vsync_d;
always @(posedge clk25 or posedge rst)
    if (rst) vsync_d <= 1'b0;
    else     vsync_d <= VSYNC;
wire vsync_rise = VSYNC & ~vsync_d;

// ============================================================
// 4.  Key state latch  (CDC-safe capture from CPU domain)
//
//     vram_we is a level signal from MIO_BUS (CPU clock domain).
//     Strategy: capture vram_addr immediately when vram_we is high,
//     hold the captured value, then commit to key_state after the
//     synchronized we passes through 2 FFs.  This tolerates short
//     write pulses because the data is latched on the first cycle
//     where vram_we is sampled high.
// ============================================================
reg        vram_we_s1, vram_we_s2;
reg [20:0] vram_addr_held;

always @(posedge clk25 or posedge rst) begin
    if (rst) begin
        vram_we_s1     <= 1'b0;
        vram_we_s2     <= 1'b0;
        vram_addr_held <= 21'b0;
    end else begin
        vram_we_s1 <= vram_we;
        vram_we_s2 <= vram_we_s1;
        // Latch data immediately while we is high (same-cycle capture)
        if (vram_we)
            vram_addr_held <= vram_addr[20:0];
    end
end

reg [20:0] key_state;
always @(posedge clk25 or posedge rst)
    if (rst) key_state <= 21'b0;
    else if (vram_we_s2) key_state <= vram_addr_held;
assign vram_dout = key_state[1:0];

// ============================================================
// 5.  Gradient animation speed (popcount)
// ============================================================
wire [4:0] active_keys =
    key_state[ 0]+key_state[ 1]+key_state[ 2]+key_state[ 3]+key_state[ 4]+
    key_state[ 5]+key_state[ 6]+key_state[ 7]+key_state[ 8]+key_state[ 9]+
    key_state[10]+key_state[11]+key_state[12]+key_state[13]+key_state[14]+
    key_state[15]+key_state[16]+key_state[17]+key_state[18]+key_state[19]+
    key_state[20];

wire [2:0] speed_inc =
    (active_keys == 5'd0) ? 3'd0 :
    (active_keys <= 5'd3) ? 3'd1 :
    (active_keys <= 5'd5) ? 3'd2 : 3'd4;

reg [2:0] speed_inc_r;
always @(posedge clk25 or posedge rst)
    if (rst) speed_inc_r <= 3'd0;
    else     speed_inc_r <= speed_inc;

// anim_cnt in [0,191], seamless modulo-192
reg [7:0] anim_cnt;
always @(posedge clk25 or posedge rst) begin
    if (rst) anim_cnt <= 8'd0;
    else if (vsync_rise) begin
        if (anim_cnt + {5'b0,speed_inc_r} >= 8'd192)
            anim_cnt <= anim_cnt + {5'b0,speed_inc_r} - 8'd192;
        else
            anim_cnt <= anim_cnt + {5'b0,speed_inc_r};
    end
end

// ============================================================
// 6.  Piano Roll — 21 SRL shift registers (no reset, no addr mux)
//
//     Each key has a 256-bit shift register.  On vsync_rise, shift
//     key_state[k] into bit 0; all bits shift left (0→1→…→255 drops).
//     Bit 0 = newest frame, bit 255 = oldest (256 frames ago).
//
//     Display read: roll_sh[roll_key][~roll_dcol]
//       dcol=255 (playhead) → inv=0  → bit 0  (newest)
//       dcol=0   (leftmost) → inv=255 → bit 255 (oldest)
//
//     Vivado maps 256-bit shift regs to SRL32 chains (~8 LUTs each).
//     No reset → no reset fanout, no 5376:1 mux, no write-address calc.
// ============================================================
reg [255:0] roll_sh [0:20];

integer rk;
always @(posedge clk25) begin
    if (vsync_rise) begin
        for (rk = 0; rk < 21; rk = rk + 1)
            roll_sh[rk] <= {roll_sh[rk][254:0], key_state[rk]};
    end
end

// ============================================================
// 7.  Piano Roll render
//
//     Screen region: col[47,559)  row[190,310)
//     X: 256 frames x 2px = 512px  starting col 47
//     Y: key 20 at top, key 0 at bottom; 5px/key; 21x5=105px active
//        spare 15px dark bar at bottom of region
// ============================================================
localparam [9:0] RX0 = 10'd47;
localparam [9:0] RX1 = 10'd559;   // 47 + 512
localparam [8:0] RY0 = 9'd190;
localparam [8:0] RY1 = 9'd310;

wire in_roll_band = (row >= RY0) & (row < RY1);
wire in_roll      = in_roll_band & (col >= RX0) & (col < RX1);

wire [9:0] roll_dx   = col - RX0;         // 0..511 px
wire [7:0] roll_dcol = roll_dx[8:1];      // 0..255  (divide by 2)
wire [8:0] roll_dy   = row - RY0;         // 0..119 px

// Key index: top 105px = 21 keys x 5px.  key = (104 - dy) / 5
wire        in_keys  = (roll_dy <= 9'd104);
wire [8:0]  roll_fl  = 9'd104 - roll_dy;          // 0..104
wire [17:0] rd5      = {9'b0,roll_fl} * 9'd205;
wire [4:0]  roll_key = rd5[14:10];                 // 0..20

// Read direct from SRL shift register: bit 0=newest, bit 255=oldest
// dcol=255 (playhead) → ~dcol=0 → bit 0;  dcol=0 → ~dcol=255 → bit 255
wire roll_bit = roll_sh[roll_key][~roll_dcol];

// Playhead: rightmost column (dcol==255)
wire roll_is_head = (roll_dcol == 8'd255);

// Horizontal gap: 1px separator between keys (4px active + 1px gap per key)
wire [8:0] rk5      = ({4'b0,roll_key}<<2) + {4'b0,roll_key};  // roll_key*5
wire [8:0] roll_rem  = roll_fl - rk5;          // 0..4 within each 5px key band
wire       roll_gap  = in_keys & (roll_rem == 9'd4);  // 5th pixel = gap

// ============================================================
// 8.  Font ROM
// ============================================================
reg  [9:0] font_addr;
wire [7:0] font_data;
font_rom u_font(.a(font_addr), .spo(font_data));

// ============================================================
// 9.  Text labels  col[8,320]  row[4,44]   1x font, 8px/row
//     5 rows x 8px = 40px.  Clean bit-slicing, no multiply.
// ============================================================
wire in_txt = (col >= 10'd8) & (col < 10'd320) & (row >= 9'd4) & (row < 9'd44);
wire [9:0] tx      = col - 10'd8;
wire [8:0] ty      = row - 9'd4;        // 0..39
wire [4:0] txt_cc  = tx[7:3];           // char col = tx/8
wire [2:0] txt_px  = tx[2:0];           // pixel x within glyph
wire [2:0] txt_py  = ty[2:0];           // pixel y within glyph
wire [2:0] txt_row_c = ty[5:3];         // char row = ty/8  (0..4)

    function [7:0] digit_ch;
        input [3:0] v;
        begin
            case(v)
                4'd0:digit_ch="0"; 4'd1:digit_ch="1"; 4'd2:digit_ch="2";
                4'd3:digit_ch="3"; 4'd4:digit_ch="4"; 4'd5:digit_ch="5";
                4'd6:digit_ch="6"; 4'd7:digit_ch="7"; 4'd8:digit_ch="8";
                4'd9:digit_ch="9"; default:digit_ch="?";
            endcase
        end
    endfunction

    function [7:0] ones_31;
        input [4:0] v;
        reg   [4:0] r;
        begin
            if      (v>=5'd30) r=v-5'd30;
            else if (v>=5'd20) r=v-5'd20;
            else if (v>=5'd10) r=v-5'd10;
            else               r=v;
            ones_31=digit_ch(r[3:0]);
        end
    endfunction

    function [7:0] tens_31;
        input [4:0] v;
        begin
            if      (v>=5'd30) tens_31="3";
            else if (v>=5'd20) tens_31="2";
            else if (v>=5'd10) tens_31="1";
            else               tens_31=" ";
        end
    endfunction

    function [2:0] note_pos;
        input [4:0] idx;
        begin
            if      (idx<5'd7)  note_pos=idx[2:0];
            else if (idx<5'd14) note_pos=idx[2:0]-3'd7;
            else                note_pos=idx[2:0]-3'd7-3'd7;
        end
    endfunction

    function [7:0] note_letter;
        input [4:0] idx;
        begin
            case(note_pos(idx))
                3'd0:note_letter="C"; 3'd1:note_letter="D";
                3'd2:note_letter="E"; 3'd3:note_letter="F";
                3'd4:note_letter="G"; 3'd5:note_letter="A";
                3'd6:note_letter="B"; default:note_letter="?";
            endcase
        end
    endfunction

    function [7:0] note_octave;
        input [4:0] idx;
        begin
            if      (idx<5'd7)  note_octave="4";
            else if (idx<5'd14) note_octave="5";
            else                note_octave="6";
        end
    endfunction

reg [7:0] txt_ascii;
always @(*) begin
    txt_ascii = 8'h20;
    case (txt_row_c)
        3'd0: case(txt_cc)
            5'd0:txt_ascii="U"; 5'd1:txt_ascii="N"; 5'd2:txt_ascii="I";
            5'd3:txt_ascii="O"; 5'd4:txt_ascii="N"; 5'd9:txt_ascii=":";
            5'd10:txt_ascii=digit_ch(mon_unison);
            default:txt_ascii=" ";
        endcase
        3'd1: case(txt_cc)
            5'd0:txt_ascii="D"; 5'd1:txt_ascii="E"; 5'd2:txt_ascii="T";
            5'd3:txt_ascii="U"; 5'd4:txt_ascii="N"; 5'd5:txt_ascii="E";
            5'd9:txt_ascii=":";
            5'd10:txt_ascii=tens_31({1'b0,mon_detune});
            5'd11:txt_ascii=ones_31({1'b0,mon_detune});
            default:txt_ascii=" ";
        endcase
        3'd2: case(txt_cc)
            5'd0:txt_ascii="L"; 5'd1:txt_ascii="O"; 5'd2:txt_ascii="U";
            5'd3:txt_ascii="D"; 5'd4:txt_ascii="N"; 5'd5:txt_ascii="E";
            5'd6:txt_ascii="S"; 5'd7:txt_ascii="S"; 5'd9:txt_ascii=":";
            5'd10:txt_ascii=tens_31({1'b0,mon_volume});
            5'd11:txt_ascii=ones_31({1'b0,mon_volume});
            default:txt_ascii=" ";
        endcase
        3'd3: case(txt_cc)
            5'd0:txt_ascii="W"; 5'd1:txt_ascii="A"; 5'd2:txt_ascii="V";
            5'd3:txt_ascii="E"; 5'd4:txt_ascii="T"; 5'd5:txt_ascii="A";
            5'd6:txt_ascii="B"; 5'd7:txt_ascii="L"; 5'd8:txt_ascii="E";
            5'd9:txt_ascii=":";
            5'd10: case(mon_waveform)
                3'd0:txt_ascii="S"; 3'd1:txt_ascii="T";
                3'd2:txt_ascii="S"; 3'd3:txt_ascii="S";
                3'd4:txt_ascii="P"; default:txt_ascii=" ";
            endcase
            5'd11: case(mon_waveform)
                3'd0:txt_ascii="Q"; 3'd1:txt_ascii="R";
                3'd2:txt_ascii="A"; 3'd3:txt_ascii="I";
                3'd4:txt_ascii="I"; default:txt_ascii=" ";
            endcase
            5'd12: case(mon_waveform)
                3'd0:txt_ascii="U"; 3'd1:txt_ascii="I";
                3'd2:txt_ascii="W"; 3'd3:txt_ascii="N";
                3'd4:txt_ascii="A"; default:txt_ascii=" ";
            endcase
            5'd13: case(mon_waveform)
                3'd0:txt_ascii="A"; 3'd3:txt_ascii="E";
                3'd4:txt_ascii="N"; default:txt_ascii=" ";
            endcase
            5'd14: case(mon_waveform)
                3'd0:txt_ascii="R"; 3'd4:txt_ascii="O";
                default:txt_ascii=" ";
            endcase
            5'd15: case(mon_waveform)
                3'd0:txt_ascii="E"; default:txt_ascii=" ";
            endcase
            default:txt_ascii=" ";
        endcase
        3'd4: case(txt_cc)
            5'd0:txt_ascii="R"; 5'd1:txt_ascii="O"; 5'd2:txt_ascii="O";
            5'd3:txt_ascii="T"; 5'd9:txt_ascii=":";
            5'd10:txt_ascii=note_letter(mon_root);
            5'd11:txt_ascii=note_octave(mon_root);
            5'd13:txt_ascii="F"; 5'd14:txt_ascii=":";
            5'd15:txt_ascii=tens_31(mon_filter);
            5'd16:txt_ascii=ones_31(mon_filter);
            default:txt_ascii=" ";
        endcase
        default: txt_ascii=" ";
    endcase
end

// ============================================================
// 10. ADDR hex display  col[8,200]  row[44,52]   1x font, 8px/row
// ============================================================
wire in_addr = (col >= 10'd8) & (col < 10'd200)
             & (row >= 9'd44) & (row < 9'd52);
wire [9:0] addr_rx      = col - 10'd8;
wire [4:0] addr_ci      = addr_rx[6:3];           // char index (8px wide)
wire [2:0] addr_px_bit  = addr_rx[2:0];           // pixel x in glyph
wire [8:0] addr_row_off = row - 9'd44;
wire [2:0] addr_py_c    = addr_row_off[2:0];      // pixel y in glyph (0..7)

function [7:0] hex_ch;
    input [3:0] n;
    begin
        case(n)
            4'h0:hex_ch="0"; 4'h1:hex_ch="1"; 4'h2:hex_ch="2"; 4'h3:hex_ch="3";
            4'h4:hex_ch="4"; 4'h5:hex_ch="5"; 4'h6:hex_ch="6"; 4'h7:hex_ch="7";
            4'h8:hex_ch="8"; 4'h9:hex_ch="9"; 4'ha:hex_ch="A"; 4'hb:hex_ch="B";
            4'hc:hex_ch="C"; 4'hd:hex_ch="D"; 4'he:hex_ch="E"; 4'hf:hex_ch="F";
        endcase
    end
endfunction

reg [7:0] addr_ascii;
always @(*) begin
    case(addr_ci)
        5'd0: addr_ascii="A";
        5'd1: addr_ascii="D";
        5'd2: addr_ascii="D";
        5'd3: addr_ascii="R";
        5'd4: addr_ascii=":";
        5'd5: addr_ascii=" ";
        5'd6: addr_ascii=hex_ch({3'b0,key_state[20]});
        5'd7: addr_ascii=hex_ch(key_state[19:16]);
        5'd8: addr_ascii=hex_ch(key_state[15:12]);
        5'd9: addr_ascii=hex_ch(key_state[11:8]);
        5'd10:addr_ascii=hex_ch(key_state[7:4]);
        5'd11:addr_ascii=hex_ch(key_state[3:0]);
        default:addr_ascii=" ";
    endcase
end

// ============================================================
// 11. Chord display region + submodule
// ============================================================
wire in_chord = (col >= 10'd560) & (col < 10'd632) & (row >= 9'd190) & (row < 9'd206);
wire [9:0] ch_x      = col - 10'd560;
wire [4:0] ch_cc     = ch_x[7:3];
wire [2:0] ch_px     = ch_x[2:0];
wire [8:0] ch_y      = row - 9'd190;
wire [2:0] ch_py     = ch_y[2:0];
wire       ch_row    = ch_y[3];

wire       chord_valid;
wire [2:0] chord_root;
wire [1:0] chord_kind;
wire [7:0] ch_ascii;

chord_display u_chord (
    .key_state   (key_state),
    .ch_cc       (ch_cc),
    .ch_row      (ch_row),
    .chord_valid (chord_valid),
    .chord_root  (chord_root),
    .chord_kind  (chord_kind),
    .ch_ascii    (ch_ascii)
);

// ============================================================
// 12. Watermark  col[384,640]  row[462,478]   2x font (unchanged)
// ============================================================
wire in_wm = (col>=10'd384)&(col<10'd640)&(row>=9'd462)&(row<9'd478);
wire [9:0] wmx   = col - 10'd384;
wire [4:0] wm_ci = wmx[8:4];
wire [8:0] wm_ry = row - 9'd462;
wire [2:0] wm_py = wm_ry[3:1];
wire [2:0] wm_px = wmx[3:1];

function [7:0] wm_ch;
    input [4:0] ci;
    begin
        case(ci)
            5'd0: wm_ch=8'h6B; 5'd1: wm_ch=8'h69; 5'd2: wm_ch=8'h77;
            5'd3: wm_ch=8'h69; 5'd4: wm_ch=8'h69; 5'd5: wm_ch=8'h7A;
            5'd6: wm_ch=8'h7A; 5'd7: wm_ch=8'h7A; 5'd8: wm_ch=8'h20;
            5'd9: wm_ch=8'h26; 5'd10:wm_ch=8'h20; 5'd11:wm_ch=8'h7A;
            5'd12:wm_ch=8'h6F; 5'd13:wm_ch=8'h6F;
            5'd14:wm_ch=8'h6D; 5'd15:wm_ch=8'h79;
            default:wm_ch=8'h20;
        endcase
    end
endfunction

// ============================================================
// 12. Flowing gradient  col[0,320]  row[320,480]  (fixed)
// ============================================================
wire in_grad = (col < 10'd320) & (row >= 9'd320) & (row < 9'd480);
wire [9:0] gx = col;
wire [8:0] gy = row - 9'd320;   // 0..159

// Hue base: 320px -> ~115 hue units (~0.6 colour wheels)
// gx * 123 >> 8 approximates gx * 115/320  (error < 0.4%)
wire [16:0] hb17   = {7'b0,gx} * 8'd123;
wire [7:0]  hue_base = hb17[15:8];

// Add scroll; clamp to [0,191]
wire [8:0] hue_raw = {1'b0,hue_base} + {1'b0,anim_cnt};
wire [7:0] hue6    = (hue_raw >= 9'd192) ? hue_raw[7:0] - 8'd192 : hue_raw[7:0];

wire [2:0] sector  = hue6[7:5];
wire [7:0] ramp_up = {hue6[4:0],3'b000};
wire [7:0] ramp_dn = 8'd248 - {hue6[4:0],3'b000};

// Pastel: output = 0x60 + raw/2  (floor 0x60, ceil ~0xD4)
wire [7:0] rup_p = 8'h60 + {1'b0,ramp_up[7:1]};
wire [7:0] rdn_p = 8'h60 + {1'b0,ramp_dn[7:1]};

reg [7:0] rh, gh, bh;
always @(*) begin
    case(sector)
        3'd0: begin rh=8'hD0; gh=rup_p;  bh=8'h60; end
        3'd1: begin rh=rdn_p;  gh=8'hD0; bh=8'h60; end
        3'd2: begin rh=8'h60; gh=8'hD0;  bh=rup_p; end
        3'd3: begin rh=8'h60; gh=rdn_p;  bh=8'hD0; end
        3'd4: begin rh=rup_p;  gh=8'h60; bh=8'hD0; end
        3'd5: begin rh=8'hD0; gh=8'h60;  bh=rdn_p; end
        default: begin rh=8'h90; gh=8'h90; bh=8'h90; end
    endcase
end

// Smooth vertical alpha (sin^2 step approximation)
wire [8:0] gy_bot  = 9'd159 - gy;
wire [8:0] gy_near = (gy <= gy_bot) ? gy : gy_bot;
wire [3:0] alpha   =
    (gy_near >= 9'd20) ? 4'hF :
    (gy_near >= 9'd14) ? 4'hD :
    (gy_near >= 9'd9)  ? 4'hA :
    (gy_near >= 9'd5)  ? 4'h7 :
    (gy_near >= 9'd2)  ? 4'h4 : 4'h1;

wire [7:0] r_blend = (rh[7:4] * alpha) + (4'h1 * (5'd16 - {1'b0,alpha}));
wire [7:0] g_blend = (gh[7:4] * alpha) + (4'h1 * (5'd16 - {1'b0,alpha}));
wire [7:0] b_blend = (bh[7:4] * alpha) + (4'h2 * (5'd16 - {1'b0,alpha}));

wire [3:0] r_grad = r_blend[7:4];
wire [3:0] g_grad = g_blend[7:4];
wire [3:0] b_grad = b_blend[7:4];

// ============================================================
// 13. Font ROM address mux
// ============================================================
always @(*) begin
    if      (in_chord) font_addr = {ch_ascii,         ch_py       };
    else if (in_wm)    font_addr = {wm_ch(wm_ci),     wm_py       };
    else if (in_txt)   font_addr = {txt_ascii,        txt_py      };
    else if (in_addr)  font_addr = {addr_ascii,       addr_py_c   };
    else               font_addr = {8'h20,            3'b0        };
end

wire chord_on = in_chord & font_data[7 - ch_px];
wire wm_on    = in_wm    & font_data[7 - wm_px];
wire txt_on   = in_txt   & font_data[7 - txt_px];
wire addr_on  = in_addr  & font_data[7 - addr_px_bit];

// ============================================================
// 14. Final pixel output
// ============================================================
reg [3:0] r_out, g_out, b_out;

// Roll background (warm dark grey)
localparam [3:0] RBR=4'h3, RBG=4'h2, RBB=4'h2;

always @(*) begin
    if (!active) begin
        r_out=4'h0; g_out=4'h0; b_out=4'h0;

    end else if (chord_on) begin
        r_out=4'hF; g_out=4'hC; b_out=4'h0;      // gold chord text

    end else if (wm_on) begin
        r_out=4'h7; g_out=4'h7; b_out=4'h7;      // grey watermark

    end else if (txt_on) begin
        r_out=4'hF; g_out=4'hF; b_out=4'hF;      // white labels

    end else if (addr_on) begin
        r_out=4'h0; g_out=4'hF; b_out=4'h4;      // green addr text

    // ---- Piano roll row band (col 0..639) ----
    end else if (in_roll_band) begin
        if (in_roll & in_keys) begin
            if (roll_is_head) begin
                r_out=4'hF; g_out=4'hF; b_out=4'hF;      // playhead white
            end else if (roll_bit) begin
                r_out=4'hF; g_out=4'hA; b_out=4'h0;      // note amber
            end else if (roll_gap) begin
                r_out=4'h1; g_out=4'h1; b_out=4'h1;      // gap dark
            end else begin
                r_out=RBR; g_out=RBG; b_out=RBB;          // bg
            end
        end else begin
            r_out=RBR; g_out=RBG; b_out=RBB;              // spare/margin
        end

    // ---- Gradient ----
    end else if (in_grad) begin
        r_out=r_grad; g_out=g_grad; b_out=b_grad;

    // ---- Dark background ----
    end else begin
        r_out=4'h2; g_out=4'h1; b_out=4'h1;
    end
end

assign R = r_out;
assign G = g_out;
assign B = b_out;

endmodule