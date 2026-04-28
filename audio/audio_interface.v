`timescale 1ns / 1ps

// =============================================================================
// audio_interface.v  —  Simplified register interface
// =============================================================================
//
// CPU writes to 4 register addresses:
//
//  Address 0x00  [Main control word]
//  ┌──────┬──────────┬────────┬────────┬────────┬────────────────┐
//  │ 31:29│  28:26   │ 25:22  │ 21:18  │ 17:14  │    13:0        │
//  │ (res)│waveform  │ detune │ unison │ volume │  key_bitmap    │
//  └──────┴──────────┴────────┴────────┴────────┴────────────────┘
//    waveform: 000=square, 001=triangle, 010=sawtooth, 011=sine, 100=piano
//    key_bitmap: bit i = 1 means note i is pressed
//      bit 0=C4, 1=C#4, 2=D4, 3=D#4, 4=E4, 5=F4, 6=F#4, 7=G4
//      bit 8=G#4, 9=A4, 10=A#4, 11=B4, 12=C5, 13=(reserved)
//    volume: 4-bit 0-15 (default 8)
//    unison: 4-bit voice count 1-8 (default 4)
//    detune: 4-bit detune offset (default 7)
//
//  Address 0x01  [ADSR word]
//  ┌──────────┬──────────┬──────────┬──────────┐
//  │  31:24   │  23:16   │  15:8    │   7:0    │
//  │  attack  │  decay   │ sustain  │ release  │
//  └──────────┴──────────┴──────────┴──────────┘
//    attack/decay/release: larger = faster (step = val * 256)
//    sustain: 0=mute, 255=full volume (level = val * 256)
//    defaults: A=20, D=100, S=255, R=100
//
//  Address 0x02  [Filter word]
//  ┌──────────────────────────┬──────┐
//  │          31:5            │  4:0 │
//  │          (reserved)      │cutoff│
//  └──────────────────────────┴──────┘
//
//  Address 0x03  [Piano word]
//  ┌──────────┬──────────┬──────────┬──────────┐
//  │  31:24   │  23:16   │  15:8    │   7:0    │
//  │  attack  │  body    │  tail    │  noise   │
//  └──────────┴──────────┴──────────┴──────────┘
//    attack: crossfade step per ms (default 128 = ~2ms)
//    body:   body hold time in ms (default 200)
//    tail:   decay step per ms (default 16 = ~16ms tail)
//    noise:  noise level during attack (default 128)
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
    output AUD_SD
);

// ---------------------------------------------------------------------------
// Address constants
// ---------------------------------------------------------------------------
localparam ADDR_CTRL  = 8'h00;   // main control: key_bitmap + volume + unison + detune + waveform
localparam ADDR_ADSR  = 8'h01;   // ADSR packed word
localparam ADDR_FILT  = 8'h02;   // filter cutoff
localparam ADDR_PIANO = 8'h03;   // piano parameters

// ---------------------------------------------------------------------------
// C4-C5 frequency step values (32-bit phase accumulator, 100MHz clock)
// phase_step = round(f * 2^32 / 100_000_000)
// ---------------------------------------------------------------------------
wire [31:0] NOTE_FREQ [0:12];
assign NOTE_FREQ[ 0] = 32'd11239; // C4   261.63 Hz
assign NOTE_FREQ[ 1] = 32'd11910; // C#4  277.18 Hz
assign NOTE_FREQ[ 2] = 32'd12620; // D4   293.66 Hz
assign NOTE_FREQ[ 3] = 32'd13369; // D#4  311.13 Hz
assign NOTE_FREQ[ 4] = 32'd14163; // E4   329.63 Hz
assign NOTE_FREQ[ 5] = 32'd15009; // F4   349.23 Hz
assign NOTE_FREQ[ 6] = 32'd15898; // F#4  369.99 Hz
assign NOTE_FREQ[ 7] = 32'd16860; // G4   392.00 Hz
assign NOTE_FREQ[ 8] = 32'd17870; // G#4  415.30 Hz
assign NOTE_FREQ[ 9] = 32'd18924; // A4   440.00 Hz
assign NOTE_FREQ[10] = 32'd20055; // A#4  466.16 Hz
assign NOTE_FREQ[11] = 32'd21234; // B4   493.88 Hz
assign NOTE_FREQ[12] = 32'd22478; // C5   523.25 Hz

// ---------------------------------------------------------------------------
// Registers
// ---------------------------------------------------------------------------
reg [31:0] reg_ctrl;  // main control word
reg [31:0] reg_adsr;  // ADSR word
reg [4:0]  reg_filt;  // filter cutoff
reg [31:0] reg_piano; // piano parameters

always @(posedge clk or posedge rst) begin
    if (rst) begin
        //               wf     detune  unison  volume  key_bitmap
        reg_ctrl  <= {3'b0, 3'd0,  4'd7,  4'd4,  4'd8,  14'd0};
        //               A       D       S       R
        reg_adsr  <= {8'd20, 8'd100, 8'd255, 8'd100};
        reg_filt  <= 5'd16;  // bypass by default
        //               attack  body    tail    noise
        reg_piano <= {8'd128, 8'd200, 8'd16,  8'd128};
    end else if (reg_we) begin
        case (reg_addr)
            ADDR_CTRL:  reg_ctrl  <= reg_wdata;
            ADDR_ADSR:  reg_adsr  <= reg_wdata;
            ADDR_FILT:  reg_filt  <= reg_wdata[4:0];
            ADDR_PIANO: reg_piano <= reg_wdata;
            default: ;
        endcase
    end
end

// ---------------------------------------------------------------------------
// Unpack main control word
// ---------------------------------------------------------------------------
wire [13:0] key_bitmap   = reg_ctrl[13:0];
wire [3:0]  volume       = reg_ctrl[17:14];
wire [3:0]  unison       = reg_ctrl[21:18];
wire [3:0]  detune       = reg_ctrl[25:22];
wire [2:0]  waveform_sel = reg_ctrl[28:26];

// ---------------------------------------------------------------------------
// Unpack ADSR (8-bit to 16-bit: step = val * 256, sustain level = val * 256)
// ---------------------------------------------------------------------------
wire [15:0] env_a = {reg_adsr[31:24], 8'd0}; // attack_step
wire [15:0] env_d = {reg_adsr[23:16], 8'd0}; // decay_step
wire [15:0] env_s = {reg_adsr[15: 8], 8'd0}; // sustain_lvl
wire [15:0] env_r = {reg_adsr[ 7: 0], 8'd0}; // release_step

// ---------------------------------------------------------------------------
// Unpack piano parameters (8-bit each)
// ---------------------------------------------------------------------------
wire [7:0] piano_attack = reg_piano[31:24];
wire [7:0] piano_body   = reg_piano[23:16];
wire [7:0] piano_tail   = reg_piano[15: 8];
wire [7:0] piano_noise  = reg_piano[ 7: 0];

// ---------------------------------------------------------------------------
// Map key_bitmap to slot_gates and slot_freqs
// Up to 8 slots, assigned in order of key_bitmap low-to-high bits
// ---------------------------------------------------------------------------
reg [3:0]  slot_note [0:7];
reg        slot_gate_r [0:7];
integer    si, ni;

always @(*) begin
    for (si = 0; si < 8; si = si + 1) begin
        slot_gate_r[si] = 1'b0;
        slot_note[si]   = 4'd0;
    end
    si = 0;
    for (ni = 0; ni < 13; ni = ni + 1) begin
        if (key_bitmap[ni] && si < 8) begin
            slot_gate_r[si] = 1'b1;
            slot_note[si]   = ni[3:0];
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
