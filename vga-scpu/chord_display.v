`timescale 1ns / 1ps

// =============================================================================
// chord_display — chord detection + text generation
//
// Detection: compresses 21 white keys into 7 pitch classes, then checks for
// every-other-white-key patterns:
//   triad  (3 notes): root, +2, +4
//   seventh (4 notes): root, +2, +4, +6
//   ninth   (5 notes): root, +2, +4, +6, +1
//
// Quality is derived from the root's position on the white-key scale:
//   C,F → major    D,E,A → minor    G → dominant    B → diminished
//
// Priority: 9th > 7th > triad.  Only the most-complete chord is reported.
//
// Display: 2-line text region (9 chars × 2 rows)
//   Row 0: "CHORD:   "
//   Row 1: "X ???    "  (quality suffix varies by kind + root)
// =============================================================================

module chord_display (
    input [20:0] key_state,
    input [4:0]  ch_cc,
    input        ch_row,
    output       chord_valid,
    output [2:0] chord_root,
    output [1:0] chord_kind,   // 0=triad, 1=seventh, 2=ninth
    output [7:0] ch_ascii
);

// ---------------------------------------------------------------------------
// Pitch class compression: 21 white keys → 7 pitch classes
// ---------------------------------------------------------------------------
wire [6:0] pc;
assign pc[0] = key_state[0] | key_state[7]  | key_state[14]; // C
assign pc[1] = key_state[1] | key_state[8]  | key_state[15]; // D
assign pc[2] = key_state[2] | key_state[9]  | key_state[16]; // E
assign pc[3] = key_state[3] | key_state[10] | key_state[17]; // F
assign pc[4] = key_state[4] | key_state[11] | key_state[18]; // G
assign pc[5] = key_state[5] | key_state[12] | key_state[19]; // A
assign pc[6] = key_state[6] | key_state[13] | key_state[20]; // B

// ---------------------------------------------------------------------------
// Every-other-white-key patterns (3 / 4 / 5 notes)
// ---------------------------------------------------------------------------
wire [6:0] triad, seventh, ninth;

assign triad[0] = pc[0] & pc[2] & pc[4];                 // C-E-G
assign triad[1] = pc[1] & pc[3] & pc[5];                 // D-F-A
assign triad[2] = pc[2] & pc[4] & pc[6];                 // E-G-B
assign triad[3] = pc[3] & pc[5] & pc[0];                 // F-A-C
assign triad[4] = pc[4] & pc[6] & pc[1];                 // G-B-D
assign triad[5] = pc[5] & pc[0] & pc[2];                 // A-C-E
assign triad[6] = pc[6] & pc[1] & pc[3];                 // B-D-F

assign seventh[0] = triad[0] & pc[6];                    // C-E-G-B
assign seventh[1] = triad[1] & pc[0];                    // D-F-A-C
assign seventh[2] = triad[2] & pc[1];                    // E-G-B-D
assign seventh[3] = triad[3] & pc[2];                    // F-A-C-E
assign seventh[4] = triad[4] & pc[3];                    // G-B-D-F
assign seventh[5] = triad[5] & pc[4];                    // A-C-E-G
assign seventh[6] = triad[6] & pc[5];                    // B-D-F-A

assign ninth[0] = seventh[0] & pc[1];                    // C-E-G-B-D
assign ninth[1] = seventh[1] & pc[2];                    // D-F-A-C-E
assign ninth[2] = seventh[2] & pc[3];                    // E-G-B-D-F
assign ninth[3] = seventh[3] & pc[4];                    // F-A-C-E-G
assign ninth[4] = seventh[4] & pc[5];                    // G-B-D-F-A
assign ninth[5] = seventh[5] & pc[6];                    // A-C-E-G-B
assign ninth[6] = seventh[6] & pc[0];                    // B-D-F-A-C

// ---------------------------------------------------------------------------
// Priority encoder: 9th > 7th > triad
// ---------------------------------------------------------------------------
wire any_triad   = |triad;
wire any_seventh = |seventh;
wire any_ninth   = |ninth;

assign chord_valid = any_triad;

assign chord_kind = any_ninth   ? 2'd2 :
                    any_seventh ? 2'd1 : 2'd0;

// Root selection: only consider the highest-priority kind that matches.
// Priority: ninth > seventh > triad.  Within a kind, use the first match.
function automatic [2:0] find_root;
    input [6:0] n, s, t;
    reg [2:0] r;
    integer i;
    begin
        r = 3'd0;
        if (|n) begin
            for (i = 0; i < 7; i = i + 1)
                if (n[i]) r = i[2:0];
        end else if (|s) begin
            for (i = 0; i < 7; i = i + 1)
                if (s[i]) r = i[2:0];
        end else begin
            for (i = 0; i < 7; i = i + 1)
                if (t[i]) r = i[2:0];
        end
        find_root = r;
    end
endfunction

assign chord_root = find_root(ninth, seventh, triad);

// ---------------------------------------------------------------------------
// Quality helpers (combinational)
// ---------------------------------------------------------------------------
wire is_root_maj = (chord_root == 3'd0) || (chord_root == 3'd3);  // C, F
wire is_root_dom = (chord_root == 3'd4);                           // G
wire is_root_min = (chord_root == 3'd1) || (chord_root == 3'd2)
                 || (chord_root == 3'd5);                          // D, E, A
wire is_root_dim = (chord_root == 3'd6);                           // B

// ---------------------------------------------------------------------------
// Root note → ASCII letter
// ---------------------------------------------------------------------------
function [7:0] root_ch;
    input [2:0] r;
    begin
        case (r)
            3'd0: root_ch = "C";  3'd1: root_ch = "D";
            3'd2: root_ch = "E";  3'd3: root_ch = "F";
            3'd4: root_ch = "G";  3'd5: root_ch = "A";
            3'd6: root_ch = "B";  default: root_ch = "?";
        endcase
    end
endfunction

// ---------------------------------------------------------------------------
// Character generator
// ---------------------------------------------------------------------------
reg [7:0] ch_ascii;
always @(*) begin
    if (ch_row) begin
        // Row 1 — chord quality line
        if (!chord_valid) begin
            // "  ---    "
            case (ch_cc)
                5'd2: ch_ascii = "-";
                5'd3: ch_ascii = "-";
                5'd4: ch_ascii = "-";
                default: ch_ascii = " ";
            endcase
        end else begin
            case (ch_cc)
                // ---- column 0: root letter ----
                5'd0: ch_ascii = root_ch(chord_root);

                // ---- columns 2+ : quality suffix ----
                5'd2: case (chord_kind)
                    2'd0: ch_ascii = is_root_dim ? "d" : "m";
                    2'd1: ch_ascii = is_root_dom ? "7" : "m";          // 7/maj7/m7/m7b5
                    2'd2: ch_ascii = is_root_dom ? "9" : "m";          // 9/maj9/m9/m9b5
                    default: ch_ascii = " ";
                endcase

                5'd3: case (chord_kind)
                    2'd0: ch_ascii = is_root_dim ? "i" : is_root_min ? "i" : is_root_maj ? "a" : " ";
                    2'd1: ch_ascii = is_root_dom ? " " : is_root_min ? "7" : is_root_dim ? "7" : "a";
                    2'd2: ch_ascii = is_root_dom ? " " : is_root_min ? "9" : is_root_dim ? "9" : "a";
                    default: ch_ascii = " ";
                endcase

                5'd4: case (chord_kind)
                    2'd0: ch_ascii = is_root_dim ? "m" : is_root_min ? "n" : is_root_maj ? "j" : " ";
                    2'd1: ch_ascii = is_root_dom ? " " : is_root_min ? " " : is_root_dim ? "b" : "j";
                    2'd2: ch_ascii = is_root_dom ? " " : is_root_min ? " " : is_root_dim ? "b" : "j";
                    default: ch_ascii = " ";
                endcase

                5'd5: case (chord_kind)
                    2'd1: ch_ascii = is_root_dom ? " " : is_root_min ? " " : is_root_dim ? "5" : "7";
                    2'd2: ch_ascii = is_root_dom ? " " : is_root_min ? " " : is_root_dim ? "5" : "9";
                    default: ch_ascii = " ";
                endcase

                default: ch_ascii = " ";
            endcase
        end

    end else begin
        // Row 0 — "CHORD:   "
        case (ch_cc)
            5'd0: ch_ascii = "C";
            5'd1: ch_ascii = "H";
            5'd2: ch_ascii = "O";
            5'd3: ch_ascii = "R";
            5'd4: ch_ascii = "D";
            5'd5: ch_ascii = ":";
            default: ch_ascii = " ";
        endcase
    end
end

endmodule
