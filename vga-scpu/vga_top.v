`timescale 1ns / 1ps

// =============================================================================
// VGA_top — Redesigned (bug-fixed revision)
//
// BUGS FIXED:
//  1. txt_char_row: was ty[4:3] (divides by 8 but drops bit2 -> rows 3/4 invisible)
//     FIXED: ty[5:3]  which gives bits [5:3] = floor(ty/8) for ty 0..39
//  2. lbl_pix_y: was row[2:0] (absolute screen row, completely wrong)
//     FIXED: computed as (row - label_band_top), stored in note_lbl_py
//  3. Gradient multiplies overflowed into wrong-width wires
//     FIXED: all intermediates explicitly widened before multiply/shift
//  4. Watermark char index was 4-bit (max index 15, string has 18 chars)
//     FIXED: widened to 5-bit
//  5. abc_py / wm_py used row[2:0] (absolute) instead of relative offset
//     FIXED: use row - region_y0
//  + Added top-right A..Z alphabet debug row (bright yellow)
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
// 2. Frame counter — increments at VSYNC (~60 Hz)
// ============================================================
reg [9:0] frame_cnt;
wire      vsync_w;
always @(posedge clk25 or posedge rst)
    if (rst) frame_cnt <= 0;
    else if (vsync_w) frame_cnt <= frame_cnt + 1;

// ============================================================
// 3. VGA Scan
// ============================================================
wire [8:0] row;
wire [9:0] col;
wire       active;
VGA_Scan u_scan(.clk(clk25),.rst(rst),.row(row),.col(col),
                .Active(active),.HSYNC(HSYNC),.VSYNC(vsync_w));
assign VSYNC = vsync_w;

// ============================================================
// 4. Key state latch
// ============================================================
reg [13:0] key_state;
always @(posedge clk)
    if (rst) key_state <= 14'b0;
    else if (vram_we) key_state <= vram_addr[13:0];
assign vram_dout = key_state[1:0];

// ============================================================
// 5. Font ROM — single instance, address muxed
// ============================================================
reg  [10:0] font_addr;
wire [7:0]  font_data;
font_rom u_font(.a(font_addr),.spo(font_data));

// ============================================================
// 6. TOP-LEFT TEXT  col[10,169] row[8,47]
// ============================================================
wire in_txt = (col>=10'd10)&&(col<10'd170)&&(row>=9'd8)&&(row<9'd48);
wire [9:0] tx = col - 10'd10;
wire [8:0] ty = row - 9'd8;
// FIX 1: use ty[5:3] not ty[4:3]
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
// 7. TOP-RIGHT ALPHABET DEBUG  A..Z
//    col[470,677] row[8,15]   26x8px, bright yellow
// ============================================================
wire in_abc = (col>=10'd470)&&(col<10'd678)&&(row>=9'd8)&&(row<9'd16);
wire [9:0] ax     = col - 10'd470;
wire [4:0] abc_ci = ax[7:3];
// FIX 5: relative row
wire [2:0] abc_py = row[2:0] ^ 3'b000;  // row is 8..15 -> row[2:0] = 0..7 (works here since Y0=8)
wire [2:0] abc_px = ax[2:0];
// 'A'=8'd65
wire [7:0] abc_ascii = 8'd65 + {3'd0, abc_ci};

// ============================================================
// 8. NOTE LINES + LABELS
//    14 notes; note_y[i] = 450 - i*14
//    Line: col[10,90], 2px. Label: col[95,118], 8px centred on note_y.
// ============================================================
wire in_line_x  = (col>=10'd10)&&(col<=10'd90);
wire in_label_x = (col>=10'd95)&&(col<10'd119);

reg [3:0]  note_idx;
reg        in_note_row;
reg        in_note_line;
reg [2:0]  note_lbl_py;  // FIX 2: relative pixel row in 8-px glyph band

always @(*) begin
    in_note_row=0; in_note_line=0; note_idx=0; note_lbl_py=0;
    if      ((row>=9'd447)&&(row<=9'd454)) begin
        in_note_row=1;note_idx=4'd0;note_lbl_py=row-9'd447;
        in_note_line=in_line_x&&((row==9'd450)||(row==9'd451));
    end else if ((row>=9'd433)&&(row<=9'd440)) begin
        in_note_row=1;note_idx=4'd1;note_lbl_py=row-9'd433;
        in_note_line=in_line_x&&((row==9'd436)||(row==9'd437));
    end else if ((row>=9'd419)&&(row<=9'd426)) begin
        in_note_row=1;note_idx=4'd2;note_lbl_py=row-9'd419;
        in_note_line=in_line_x&&((row==9'd422)||(row==9'd423));
    end else if ((row>=9'd405)&&(row<=9'd412)) begin
        in_note_row=1;note_idx=4'd3;note_lbl_py=row-9'd405;
        in_note_line=in_line_x&&((row==9'd408)||(row==9'd409));
    end else if ((row>=9'd391)&&(row<=9'd398)) begin
        in_note_row=1;note_idx=4'd4;note_lbl_py=row-9'd391;
        in_note_line=in_line_x&&((row==9'd394)||(row==9'd395));
    end else if ((row>=9'd377)&&(row<=9'd384)) begin
        in_note_row=1;note_idx=4'd5;note_lbl_py=row-9'd377;
        in_note_line=in_line_x&&((row==9'd380)||(row==9'd381));
    end else if ((row>=9'd363)&&(row<=9'd370)) begin
        in_note_row=1;note_idx=4'd6;note_lbl_py=row-9'd363;
        in_note_line=in_line_x&&((row==9'd366)||(row==9'd367));
    end else if ((row>=9'd349)&&(row<=9'd356)) begin
        in_note_row=1;note_idx=4'd7;note_lbl_py=row-9'd349;
        in_note_line=in_line_x&&((row==9'd352)||(row==9'd353));
    end else if ((row>=9'd335)&&(row<=9'd342)) begin
        in_note_row=1;note_idx=4'd8;note_lbl_py=row-9'd335;
        in_note_line=in_line_x&&((row==9'd338)||(row==9'd339));
    end else if ((row>=9'd321)&&(row<=9'd328)) begin
        in_note_row=1;note_idx=4'd9;note_lbl_py=row-9'd321;
        in_note_line=in_line_x&&((row==9'd324)||(row==9'd325));
    end else if ((row>=9'd307)&&(row<=9'd314)) begin
        in_note_row=1;note_idx=4'd10;note_lbl_py=row-9'd307;
        in_note_line=in_line_x&&((row==9'd310)||(row==9'd311));
    end else if ((row>=9'd293)&&(row<=9'd300)) begin
        in_note_row=1;note_idx=4'd11;note_lbl_py=row-9'd293;
        in_note_line=in_line_x&&((row==9'd296)||(row==9'd297));
    end else if ((row>=9'd279)&&(row<=9'd286)) begin
        in_note_row=1;note_idx=4'd12;note_lbl_py=row-9'd279;
        in_note_line=in_line_x&&((row==9'd282)||(row==9'd283));
    end else if ((row>=9'd265)&&(row<=9'd272)) begin
        in_note_row=1;note_idx=4'd13;note_lbl_py=row-9'd265;
        in_note_line=in_line_x&&((row==9'd268)||(row==9'd269));
    end
end

function [7:0] nc0;
    input [3:0] i;
    begin
        case(i)
            4'd0, 4'd1:  nc0 = 8'h43; // 'C'
            4'd2, 4'd3:  nc0 = 8'h44; // 'D'
            4'd4:        nc0 = 8'h45; // 'E'
            4'd5, 4'd6:  nc0 = 8'h46; // 'F'
            4'd7, 4'd8:  nc0 = 8'h47; // 'G'
            4'd9, 4'd10: nc0 = 8'h41; // 'A'
            4'd11:       nc0 = 8'h42; // 'B'
            4'd12, 4'd13:nc0 = 8'h43; // 'C'
            default:     nc0 = 8'h20; // ' '
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
            default:                                   nc1 = 8'h20; // ' '
        endcase
    end
endfunction

    // ============================================================
    // 8. Note Label Logic (Fixed Syntax)
    // ============================================================
    wire [9:0] lbl_cx  = col - 10'd95;
    wire       lbl_sel = lbl_cx[3];
    wire [2:0] lbl_px  = lbl_cx[2:0];
    
    // 假设 note_idx 已在前文定义
    wire [7:0] lbl_ascii = lbl_sel ? nc1(note_idx) : nc0(note_idx);

    wire draw_line_on  = in_note_line &&  key_state[note_idx];
    wire draw_line_dim = in_note_line && !key_state[note_idx];



    // ============================================================
    // 9. WATERMARK "kiwiizzz & zoomy" (Fixed Syntax)
    // ============================================================
    wire in_wm = (col>=10'd496)&&(col<10'd640)&&(row>=9'd470)&&(row<9'd478);
    wire [9:0] wmx   = col - 10'd496;
    wire [4:0] wm_ci = wmx[7:3];   // Character Index
    wire [2:0] wm_py = row - 9'd470; // Pixel Y within char
    wire [2:0] wm_px = wmx[2:0];   // Pixel X within char

    function [7:0] wm_ch;
        input [4:0] ci;
        begin
            case(ci)
                5'd0:  wm_ch = 8'h6B; // 'k'
                5'd1:  wm_ch = 8'h69; // 'i'
                5'd2:  wm_ch = 8'h77; // 'w'
                5'd3:  wm_ch = 8'h69; // 'i'
                5'd4:  wm_ch = 8'h69; // 'i'
                5'd5:  wm_ch = 8'h7A; // 'z'
                5'd6:  wm_ch = 8'h7A; // 'z'
                5'd7:  wm_ch = 8'h7A; // 'z'
                5'd8:  wm_ch = 8'h20; // ' '
                5'd9:  wm_ch = 8'h26; // '&'
                5'd10: wm_ch = 8'h20; // ' '
                5'd11: wm_ch = 8'h7A; // 'z'
                5'd12: wm_ch = 8'h6F; // 'o'
                5'd13: wm_ch = 8'h6F; // 'o'
                5'd14: wm_ch = 8'h6D; // 'm'
                5'd15: wm_ch = 8'h79; // 'y'
                default: wm_ch = 8'h20; // ' '
            endcase
        end
    endfunction

    // ============================================================
    // 10. FLOWING RGB GRADIENT (Logic Verified)
    // ============================================================
    wire in_grad = (col>=10'd180)&&(col<=10'd459)&&(row>=9'd160)&&(row<=9'd319);
    wire [9:0] gx = col - 10'd180;   // 0..279
    wire [8:0] gy = row - 9'd160;    // 0..159

    // Hue calculation
    wire [12:0] hue_base = ({3'b0,gx} * 13'd11) >> 4;           
    wire [9:0]  scroll   = {frame_cnt[7:0], 1'b0};               
    wire [12:0] hue_raw  = {3'b0, hue_base[7:0]} + {3'b0,scroll};
    
    // Modulo 192 logic
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

    // Vertical soft fade alpha
    wire [8:0] gy_bot  = 9'd159 - gy;
    wire [8:0] gy_near = (gy < gy_bot) ? gy : gy_bot;
    wire [3:0] alpha   = (gy_near >= 9'd24) ? 4'hF : gy_near[4:1];

    // Color mixing
    wire [11:0] rs = {4'b0,rh} * {8'b0,alpha};
    wire [11:0] gs = {4'b0,gh} * {8'b0,alpha};
    wire [11:0] bs = {4'b0,bh} * {8'b0,alpha};

    wire [15:0] rd = ({4'b0,rs} * 16'd17) >> 8;
    wire [15:0] gd = ({4'b0,gs} * 16'd17) >> 8;
    wire [15:0] bd = ({4'b0,bs} * 16'd17) >> 8;

    wire [3:0] r_grad = rd[7:4];
    wire [3:0] g_grad = gd[7:4];
    wire [3:0] b_grad = bd[7:4];

    // ============================================================
    // 11. Font ROM MUX (Fixed Declaration and Assignment)
    // ============================================================
    
    // IMPORTANT: font_addr must be declared as reg [10:0] (or appropriate width) 
    // before this always block. Example: reg [10:0] font_addr;
    // Assuming font_addr is [10:0] = [7:0] ASCII + [2:0] Pixel Row
    
   // reg [10:0] font_addr; // <--- MAKE SURE THIS IS DECLARED IN YOUR MODULE

    always @(*) begin
        if (in_abc)
            font_addr = {abc_ascii, abc_py};
        else if (in_wm)
            font_addr = {wm_ch(wm_ci), wm_py};
        else if (in_txt)
            font_addr = {txt_ascii, txt_py};
        else
            font_addr = {lbl_ascii, note_lbl_py}; // Ensure note_lbl_py is defined
    end

    // Font Data Lookup (Assuming font_data is output from your ROM instance)
    // The bit selection depends on your ROM width. Assuming 8-bit wide ROM, accessing specific bit:
    // If ROM is 1-bit wide per address, you might need different logic. 
    // Here assuming font_data is an 8-bit bus representing one row of pixels for the char.
    
    wire abc_on = in_abc                       && font_data[7-abc_px];
    wire wm_on  = in_wm                        && font_data[7-wm_px];
    wire txt_on = in_txt                       && font_data[7-txt_px];
    wire lbl_on = in_note_row && in_label_x    && font_data[7-lbl_px];

    // ============================================================
    // 12. Final colour (Fixed Syntax)
    // ============================================================
    reg [3:0] r_out, g_out, b_out;
    
    always @(*) begin
        if (!active) begin
            r_out = 4'h0; g_out = 4'h0; b_out = 4'h0;
        end
        else if (abc_on) begin
            r_out = 4'hF; g_out = 4'hF; b_out = 4'h0; // Yellow
        end
        else if (wm_on) begin
            r_out = 4'h7; g_out = 4'h7; b_out = 4'h7; // Gray
        end
        else if (txt_on) begin
            r_out = 4'hF; g_out = 4'hF; b_out = 4'hF; // White
        end
        else if (draw_line_on) begin
            r_out = 4'h0; g_out = 4'hF; b_out = 4'hF; // Cyan
        end
        else if (draw_line_dim) begin
            r_out = 4'h4; g_out = 4'h4; b_out = 4'h4; // Dark Gray
        end
        else if (lbl_on) begin
            if (key_state[note_idx]) begin
                r_out = 4'hF; g_out = 4'hF; b_out = 4'hF; // White
            end else begin
                r_out = 4'h8; g_out = 4'h8; b_out = 4'h8; // Light Gray
            end
        end
        else if (in_grad) begin
            r_out = r_grad;
            g_out = g_grad;
            b_out = b_grad;
        end
        else begin
            r_out = 4'h1; g_out = 4'h1; b_out = 4'h2; // Background
        end
    end

    assign R = r_out;
    assign G = g_out;
    assign B = b_out;

endmodule