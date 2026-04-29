`timescale 1ns / 1ps

// =============================================================================
// audio_interface.v  —  Register interface for CPU-driven audio synthesizer
// =============================================================================
//
// Register map (5 words, addr[3:0]):
//
//  Address 0x00  [Note bitmap]   — which white keys are pressed
//  ┌──────────────────────┬─────────────────────────────────────────┐
//  │       31:21          │                 20:0                    │
//  │     (reserved)       │             key_bitmap                  │
//  └──────────────────────┴─────────────────────────────────────────┘
//    bit  0 = C4     bit  1 = D4     bit  2 = E4     bit  3 = F4
//    bit  4 = G4     bit  5 = A4     bit  6 = B4     bit  7 = C5
//    bit  8 = D5     bit  9 = E5     bit 10 = F5     bit 11 = G5
//    bit 12 = A5     bit 13 = B5     bit 14 = C6     bit 15 = D6
//    bit 16 = E6     bit 17 = F6     bit 18 = G6     bit 19 = A6
//    bit 20 = B6
//
//  Address 0x01  [Synthesis control]
//  ┌──────┬──────────┬────────┬────────┬────────┬────────────────────┐
//  │ 31:29│  28:26   │ 25:22  │ 21:18  │ 17:14  │       13:0         │
//  │ (res)│waveform  │ detune │ unison │ volume │     (reserved)     │
//  └──────┴──────────┴────────┴────────┴────────┴────────────────────┘
//    waveform: 000=square, 001=triangle, 010=sawtooth, 011=sine, 100=piano
//    detune:   4-bit, larger = more detune spread (default 7)
//    unison:   4-bit voice count 1-8 (default 4)
//    volume:   4-bit 0-15 (default 8)
//
//  Address 0x02  [ADSR]
//  ┌──────────┬──────────┬──────────┬──────────┐
//  │  31:24   │  23:16   │  15:8    │   7:0    │
//  │  attack  │  decay   │ sustain  │ release  │
//  └──────────┴──────────┴──────────┴──────────┘
//
//  Address 0x03  [Filter]
//  ┌────────────────────────────────────┬──────┐
//  │               31:5                 │  4:0 │
//  │            (reserved)              │cutoff│
//  └────────────────────────────────────┴──────┘
//
//  Address 0x04  [Piano]
//  ┌──────────┬──────────┬──────────┬──────────┐
//  │  31:24   │  23:16   │  15:8    │   7:0    │
//  │  attack  │  body    │  tail    │  noise   │
//  └──────────┴──────────┴──────────┴──────────┘
//
// =============================================================================

module audio_interface (
    input clk,
    input rst,

    // CPU interface
    input        reg_we,
    input  [7:0] reg_addr,
    input [31:0] reg_wdata,

    // Audio output
    output AUD_PWM,
    output AUD_SD,

    // Monitor outputs (to VGA)
    output [2:0]  mon_waveform,
    output [3:0]  mon_volume,
    output [3:0]  mon_unison,
    output [3:0]  mon_detune,
    output [4:0]  mon_filter,
    output [4:0]  mon_root
);

// ---------------------------------------------------------------------------
// Address constants
// ---------------------------------------------------------------------------
localparam ADDR_NOTE  = 8'h00;   // note bitmap
localparam ADDR_CTRL  = 8'h01;   // waveform + detune + unison + volume
localparam ADDR_ADSR  = 8'h02;   // ADSR packed word
localparam ADDR_FILT  = 8'h03;   // filter cutoff
localparam ADDR_PIANO = 8'h04;   // piano parameters

// ---------------------------------------------------------------------------
// C4-B6 white-key frequency step values (32-bit, 100MHz clock)
// phase_step = round(freq * 2^32 / 100_000_000)
// ---------------------------------------------------------------------------
wire [31:0] NOTE_FREQ [0:20];
assign NOTE_FREQ[ 0] = 32'd11237; // C4   261.63 Hz
assign NOTE_FREQ[ 1] = 32'd12613; // D4   293.66 Hz
assign NOTE_FREQ[ 2] = 32'd14158; // E4   329.63 Hz
assign NOTE_FREQ[ 3] = 32'd14999; // F4   349.23 Hz
assign NOTE_FREQ[ 4] = 32'd16836; // G4   392.00 Hz
assign NOTE_FREQ[ 5] = 32'd18898; // A4   440.00 Hz
assign NOTE_FREQ[ 6] = 32'd21212; // B4   493.88 Hz
assign NOTE_FREQ[ 7] = 32'd22473; // C5   523.25 Hz
assign NOTE_FREQ[ 8] = 32'd25226; // D5   587.33 Hz
assign NOTE_FREQ[ 9] = 32'd28315; // E5   659.25 Hz
assign NOTE_FREQ[10] = 32'd29999; // F5   698.46 Hz
assign NOTE_FREQ[11] = 32'd33672; // G5   783.99 Hz
assign NOTE_FREQ[12] = 32'd37796; // A5   880.00 Hz
assign NOTE_FREQ[13] = 32'd42424; // B5   987.77 Hz
assign NOTE_FREQ[14] = 32'd44947; // C6   1046.50 Hz
assign NOTE_FREQ[15] = 32'd50451; // D6   1174.66 Hz
assign NOTE_FREQ[16] = 32'd56630; // E6   1318.51 Hz
assign NOTE_FREQ[17] = 32'd59997; // F6   1396.91 Hz
assign NOTE_FREQ[18] = 32'd67344; // G6   1567.98 Hz
assign NOTE_FREQ[19] = 32'd75591; // A6   1760.00 Hz
assign NOTE_FREQ[20] = 32'd84848; // B6   1975.53 Hz

// ---------------------------------------------------------------------------
// Registers
// ---------------------------------------------------------------------------
reg [31:0] reg_note;  // key_bitmap[20:0]
reg [31:0] reg_ctrl;  // waveform + detune + unison + volume
reg [31:0] reg_adsr;  // ADSR
reg [4:0]  reg_filt;  // filter cutoff
reg [31:0] reg_piano; // piano parameters

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // bit 5 = A4 (440 Hz) active by default for quick test
        reg_note  <= {11'd0, 21'h000020};
        //            wf   detune unison volume
        reg_ctrl  <= {3'b0, 3'd0, 4'd7, 4'd4, 4'd8, 14'd0};
        //            A    D    S    R
        reg_adsr  <= {8'd20, 8'd100, 8'd255, 8'd100};
        reg_filt  <= 5'd16;
        //            attack body  tail  noise
        reg_piano <= {8'd128, 8'd200, 8'd16, 8'd128};
    end else if (reg_we) begin
        case (reg_addr)
            ADDR_NOTE:  reg_note  <= reg_wdata;
            ADDR_CTRL:  reg_ctrl  <= reg_wdata;
            ADDR_ADSR:  reg_adsr  <= reg_wdata;
            ADDR_FILT:  reg_filt  <= reg_wdata[4:0];
            ADDR_PIANO: reg_piano <= reg_wdata;
            default: ;
        endcase
    end
end

// ---------------------------------------------------------------------------
// Unpack note bitmap
// ---------------------------------------------------------------------------
wire [20:0] key_bitmap = reg_note[20:0];

// ---------------------------------------------------------------------------
// Unpack synthesis control
// ---------------------------------------------------------------------------
wire [2:0]  waveform_sel = reg_ctrl[28:26];
wire [3:0]  detune       = reg_ctrl[25:22];
wire [3:0]  unison       = reg_ctrl[21:18];
wire [3:0]  volume       = reg_ctrl[17:14];

// ---------------------------------------------------------------------------
// Unpack ADSR (8-bit to 16-bit: step = val * 256, sustain level = val * 256)
// ---------------------------------------------------------------------------
wire [15:0] env_a = {reg_adsr[31:24], 8'd0};
wire [15:0] env_d = {reg_adsr[23:16], 8'd0};
wire [15:0] env_s = {reg_adsr[15: 8], 8'd0};
wire [15:0] env_r = {reg_adsr[ 7: 0], 8'd0};

// ---------------------------------------------------------------------------
// Unpack piano parameters
// ---------------------------------------------------------------------------
wire [7:0] piano_attack = reg_piano[31:24];
wire [7:0] piano_body   = reg_piano[23:16];
wire [7:0] piano_tail   = reg_piano[15: 8];
wire [7:0] piano_noise  = reg_piano[ 7: 0];

// ---------------------------------------------------------------------------
// Monitor outputs (to VGA)
// ---------------------------------------------------------------------------
assign mon_waveform = waveform_sel;
assign mon_volume   = volume;
assign mon_unison   = unison;
assign mon_detune   = detune;
assign mon_filter   = reg_filt;

// mon_root: lowest set bit in key_bitmap (0..20), 0 when none active
assign mon_root = key_bitmap[0]  ? 5'd0  :
                  key_bitmap[1]  ? 5'd1  :
                  key_bitmap[2]  ? 5'd2  :
                  key_bitmap[3]  ? 5'd3  :
                  key_bitmap[4]  ? 5'd4  :
                  key_bitmap[5]  ? 5'd5  :
                  key_bitmap[6]  ? 5'd6  :
                  key_bitmap[7]  ? 5'd7  :
                  key_bitmap[8]  ? 5'd8  :
                  key_bitmap[9]  ? 5'd9  :
                  key_bitmap[10] ? 5'd10 :
                  key_bitmap[11] ? 5'd11 :
                  key_bitmap[12] ? 5'd12 :
                  key_bitmap[13] ? 5'd13 :
                  key_bitmap[14] ? 5'd14 :
                  key_bitmap[15] ? 5'd15 :
                  key_bitmap[16] ? 5'd16 :
                  key_bitmap[17] ? 5'd17 :
                  key_bitmap[18] ? 5'd18 :
                  key_bitmap[19] ? 5'd19 :
                  key_bitmap[20] ? 5'd20 : 5'd0;

// ---------------------------------------------------------------------------
// Map key_bitmap to 8 synthesis slots (priority encoder, low bit first)
// ---------------------------------------------------------------------------
reg        slot_gate_r [0:7];
reg [4:0]  slot_note   [0:7];    // 5-bit to index 21 notes
integer    si, ni;

always @(*) begin
    for (si = 0; si < 8; si = si + 1) begin
        slot_gate_r[si] = 1'b0;
        slot_note[si]   = 5'd0;
    end
    si = 0;
    for (ni = 0; ni < 21; ni = ni + 1) begin
        if (key_bitmap[ni] && si < 8) begin
            slot_gate_r[si] = 1'b1;
            slot_note[si]   = ni[4:0];
            si = si + 1;
        end
    end
end

// Pack into audio core format
wire [7:0] slot_gates;
wire [255:0] slot_freqs;

genvar g;
generate
    for (g = 0; g < 8; g = g + 1) begin : slot_pack
        assign slot_gates[g] = slot_gate_r[g];
        assign slot_freqs[g*32 +: 32] = NOTE_FREQ[slot_note[g]];
    end
endgenerate

// ---------------------------------------------------------------------------
// Audio core instantiation
// ---------------------------------------------------------------------------
wire [9:0] mix_out;
audio #(
    .MAX_SLOTS(8)
) synth_core (
    .clk          (clk),
    .rst          (rst),
    .slot_gates   (slot_gates),
    .slot_freqs   (slot_freqs),
    .env_a        (env_a),
    .env_d        (env_d),
    .env_s        (env_s),
    .env_r        (env_r),
    .filter_cutoff(reg_filt),
    .volume       (volume),
    .unison       (unison),
    .detune       (detune),
    .waveform_sel (waveform_sel),
    .piano_attack (piano_attack),
    .piano_body   (piano_body),
    .piano_tail   (piano_tail),
    .piano_noise  (piano_noise),
    .mix_out      (mix_out)
);

// ---------------------------------------------------------------------------
// PWM output
// ---------------------------------------------------------------------------
reg [9:0] pwm_cnt;
always @(posedge clk or posedge rst) begin
    if (rst) pwm_cnt <= 10'd0;
    else     pwm_cnt <= pwm_cnt + 1'b1;
end

assign AUD_PWM = (pwm_cnt < mix_out) ? 1'b1 : 1'b0;
assign AUD_SD  = 1'b1;

endmodule
