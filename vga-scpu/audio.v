`timescale 1ns / 1ps

module audio #(
    parameter MAX_SLOTS = 8,
    parameter MAX_VOICES = 8
)(
    input clk,
    input rst,

    input [MAX_SLOTS-1:0] slot_gates,
    input [32*MAX_SLOTS-1:0] slot_freqs,

    input [15:0] env_a,
    input [15:0] env_d,
    input [15:0] env_s,
    input [15:0] env_r,

    input [4:0] filter_cutoff,
    input [3:0] volume,
    input [3:0] unison,
    input [3:0] detune,
    input [2:0] waveform_sel,

    // Piano parameters
    input [7:0] piano_attack,
    input [7:0] piano_body,
    input [7:0] piano_tail,
    input [7:0] piano_noise,

    output [9:0] mix_out
);

localparam WF_PIANO = 3'd4;

wire [31:0] slot_freq [0:MAX_SLOTS-1];
genvar gi;
generate
    for (gi = 0; gi < MAX_SLOTS; gi = gi + 1) begin : freq_assign
        assign slot_freq[gi] = slot_freqs[gi*32 +: 32];
    end
endgenerate

// =========================================================================
// Normal synthesis path
// =========================================================================
wire [9:0] normal_slot_out [0:MAX_SLOTS-1];

genvar i;
generate
    for (i = 0; i < MAX_SLOTS; i = i + 1) begin : slot_gen
        wire [9:0] voice_out;
        reg [9:0] voice_sum;

        wire [3:0] voice_count = slot_gates[i] ? unison : 4'd0;

        reg [31:0] phase_acc [0:MAX_VOICES-1];
        reg [31:0] step_size [0:MAX_VOICES-1];
        genvar v;
        for (v = 0; v < MAX_VOICES; v = v + 1) begin : voice_gen
            wire [3:0] shift_val = detune + v;
            always @(*) begin
                step_size[v] = (v == 0) ? slot_freq[i] : slot_freq[i] + (slot_freq[i] >> shift_val);
            end
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    phase_acc[v] <= 32'd0;
                end else if (slot_gates[i]) begin
                    if (v < voice_count) begin
                        phase_acc[v] <= phase_acc[v] + step_size[v];
                    end else begin
                        phase_acc[v] <= 32'd0;
                    end
                end else begin
                    phase_acc[v] <= 32'd0;
                end
            end
        end

        wire [7:0] env_out;
        adsr env_gen (
            .clk(clk),
            .rst(rst),
            .gate(slot_gates[i]),
            .attack_step(env_a),
            .decay_step(env_d),
            .sustain_lvl(env_s),
            .release_step(env_r),
            .env_out(env_out)
        );

        wire [5:0] voice_wave [0:MAX_VOICES-1];
        genvar wv;
        for (wv = 0; wv < MAX_VOICES; wv = wv + 1) begin : wave_gen
            wire [31:0] ph = phase_acc[wv];
            wire [5:0] w_square   = ph[31] ? 6'd63 : 6'd0;
            wire [5:0] w_triangle = ph[31] ? ~ph[30:25] : ph[30:25];
            wire [5:0] w_saw      = ph[31:26];
            wire [5:0] w_sine;
            sine_lut sine_i (.phase(ph[31:24]), .sine_out(w_sine));
            assign voice_wave[wv] = (waveform_sel == 3'd0) ? w_square   :
                                    (waveform_sel == 3'd1) ? w_triangle :
                                    (waveform_sel == 3'd2) ? w_saw      :
                                    (waveform_sel == 3'd3) ? w_sine     :
                                                              w_square;
        end

        integer k;
        always @(*) begin
            voice_sum = 10'd0;
            for (k = 0; k < MAX_VOICES; k = k + 1) begin
                if (k < voice_count) begin
                    voice_sum = voice_sum + {4'd0, voice_wave[k]};
                end
            end
        end

        wire [23:0] prod = {voice_sum, 3'd0} * {9'd0, env_out};
        assign voice_out = prod[19:10];
        assign normal_slot_out[i] = voice_out;
    end
endgenerate

// =========================================================================
// Piano synthesis path
// =========================================================================

// ---- piano_env per slot ----
wire [7:0] pe_env      [0:MAX_SLOTS-1];
wire [7:0] pe_cf_weight [0:MAX_SLOTS-1];
wire [1:0] pe_table_a  [0:MAX_SLOTS-1];
wire [1:0] pe_table_b  [0:MAX_SLOTS-1];
wire       pe_noise_en  [0:MAX_SLOTS-1];
wire [7:0] pe_noise_gain[0:MAX_SLOTS-1];

genvar pi;
generate
    for (pi = 0; pi < MAX_SLOTS; pi = pi + 1) begin : piano_env_gen
        piano_env pe (
            .clk(clk),
            .rst(rst),
            .gate(slot_gates[pi]),
            .attack_rate(piano_attack),
            .body_hold(piano_body),
            .tail_rate(piano_tail),
            .noise_level(piano_noise),
            .env_out(pe_env[pi]),
            .cf_weight(pe_cf_weight[pi]),
            .table_sel_a(pe_table_a[pi]),
            .table_sel_b(pe_table_b[pi]),
            .noise_en(pe_noise_en[pi]),
            .noise_gain(pe_noise_gain[pi])
        );
    end
endgenerate

// ---- piano phase accumulators (flat arrays, indexed as [slot*MAX_VOICES+voice]) ----
reg [31:0] pp_phase [0:(MAX_SLOTS*MAX_VOICES)-1];

integer pp_s, pp_v;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (pp_s = 0; pp_s < MAX_SLOTS; pp_s = pp_s + 1) begin
            for (pp_v = 0; pp_v < MAX_VOICES; pp_v = pp_v + 1) begin
                pp_phase[pp_s * MAX_VOICES + pp_v] <= 32'd0;
            end
        end
    end else begin
        for (pp_s = 0; pp_s < MAX_SLOTS; pp_s = pp_s + 1) begin
            for (pp_v = 0; pp_v < MAX_VOICES; pp_v = pp_v + 1) begin
                if (slot_gates[pp_s] && pp_v < unison) begin
                    pp_phase[pp_s * MAX_VOICES + pp_v] <=
                        pp_phase[pp_s * MAX_VOICES + pp_v] +
                        ((pp_v == 0) ? slot_freq[pp_s] :
                         slot_freq[pp_s] + (slot_freq[pp_s] >> (detune + pp_v)));
                end else begin
                    pp_phase[pp_s * MAX_VOICES + pp_v] <= 32'd0;
                end
            end
        end
    end
end

// ---- LFSR noise (16-bit, maximal length) ----
reg [15:0] lfsr;
always @(posedge clk or posedge rst) begin
    if (rst) lfsr <= 16'hACE1;
    else     lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[14] ^ lfsr[12] ^ lfsr[3]};
end

// ---- TDM sequencer (cycles 0 to MAX_SLOTS*MAX_VOICES-1) ----
localparam TDM_MAX = MAX_SLOTS * MAX_VOICES;
reg [$clog2(TDM_MAX)-1:0] p_tdm;

always @(posedge clk or posedge rst) begin
    if (rst) p_tdm <= 0;
    else     p_tdm <= (p_tdm == TDM_MAX - 1) ? 0 : p_tdm + 1;
end

wire [$clog2(MAX_SLOTS)-1:0]  tdm_slot  = p_tdm[$clog2(TDM_MAX)-1:$clog2(MAX_VOICES)];
wire [$clog2(MAX_VOICES)-1:0] tdm_voice = p_tdm[$clog2(MAX_VOICES)-1:0];

// TDM: select current voice's phase and envelope values
wire [31:0] tdm_phase = pp_phase[tdm_slot * MAX_VOICES + tdm_voice];
wire [7:0]  tdm_cf_weight = pe_cf_weight[tdm_slot];
wire [1:0]  tdm_table_a   = pe_table_a[tdm_slot];
wire [1:0]  tdm_table_b   = pe_table_b[tdm_slot];
wire        tdm_noise_en   = pe_noise_en[tdm_slot];
wire [7:0]  tdm_noise_gain = pe_noise_gain[tdm_slot];

// ---- shared piano_table ----
wire [9:0] pt_samp_a, pt_samp_b;
piano_table pt (
    .phase(tdm_phase[31:24]),
    .table_sel_a(tdm_table_a),
    .table_sel_b(tdm_table_b),
    .sample_a(pt_samp_a),
    .sample_b(pt_samp_b)
);

// ---- crossfade: sample_a * (1-w) + sample_b * w ----
wire [17:0] cf_mul_a = pt_samp_a * (10'd255 - {2'd0, tdm_cf_weight});
wire [17:0] cf_mul_b = pt_samp_b * {2'd0, tdm_cf_weight};
wire [10:0] cf_sum   = {1'b0, cf_mul_a[17:8]} + {1'b0, cf_mul_b[17:8]};

// ---- noise injection (attack phase only) ----
wire [9:0]  noise_raw = lfsr[9:0];
wire [17:0] noise_mul = noise_raw * {10'd0, tdm_noise_gain};
wire [9:0]  noise_add = noise_mul[17:8];
wire [10:0] voice_sample = tdm_noise_en ? (cf_sum + {1'b0, noise_add}) : cf_sum;

// ---- per-slot accumulators (blocking accum + non-blocking output latch) ----
reg [13:0] p_accum [0:MAX_SLOTS-1];
reg [9:0]  piano_slot_out [0:MAX_SLOTS-1];

// combinational envelope scaling (used by latch logic below)
wire [21:0] p_env_prod [0:MAX_SLOTS-1];
wire [9:0]  p_slot_sat [0:MAX_SLOTS-1];
genvar eps;
generate
    for (eps = 0; eps < MAX_SLOTS; eps = eps + 1) begin : env_scale_gen
        assign p_env_prod[eps] = {8'd0, p_accum[eps]} * {14'd0, pe_env[eps]};
        assign p_slot_sat[eps] = (p_env_prod[eps] >= 22'h200000) ? 10'd1023 : p_env_prod[eps][20:11];
    end
endgenerate

wire p_cycle_start = (p_tdm == 0);

integer pa_s;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (pa_s = 0; pa_s < MAX_SLOTS; pa_s = pa_s + 1) begin
            p_accum[pa_s]        <= 14'd0;
            piano_slot_out[pa_s] <= 10'd0;
        end
    end else begin
        if (p_cycle_start) begin
            // Latch previous round's accumulation (p_accum has full 64-voice sum)
            for (pa_s = 0; pa_s < MAX_SLOTS; pa_s = pa_s + 1) begin
                if (slot_gates[pa_s] && unison > 0)
                    piano_slot_out[pa_s] <= p_slot_sat[pa_s];
                else
                    piano_slot_out[pa_s] <= 10'd0;
                p_accum[pa_s] <= 14'd0;
            end
            // Seed slot 0 voice 0 (overrides p_accum[0] reset above; NB last-wins)
            if (slot_gates[0] && unison > 0)
                p_accum[0] <= {4'd0, voice_sample[9:0]};
        end else begin
            if (slot_gates[tdm_slot] && tdm_voice < unison)
                p_accum[tdm_slot] <= p_accum[tdm_slot] + {4'd0, voice_sample[9:0]};
        end
    end
end

// ---- slot output mux ----
wire [9:0] slot_outs [0:MAX_SLOTS-1];
genvar sm;
generate
    for (sm = 0; sm < MAX_SLOTS; sm = sm + 1) begin : slot_mux
        assign slot_outs[sm] = (waveform_sel == WF_PIANO)
            ? piano_slot_out[sm] : normal_slot_out[sm];
    end
endgenerate

// =========================================================================
// Mixer + VCA + LPF
// =========================================================================
reg [13:0] mix_sum;
integer j;
always @(*) begin
    mix_sum = 14'd0;
    for (j = 0; j < MAX_SLOTS; j = j + 1) begin
        mix_sum = mix_sum + slot_outs[j];
    end
end

wire [22:0] mix_scaled = mix_sum * {10'b0, volume, 3'b0};  // volume * 8
wire [9:0] vca_out = (|mix_scaled[22:19]) ? 10'd1023 : mix_scaled[18:9];

reg [9:0] vca_out_reg;
always @(posedge clk or posedge rst) begin
    if (rst) vca_out_reg <= 10'd0;
    else     vca_out_reg <= vca_out;
end

lpf filter_inst (
    .clk(clk),
    .rst(rst),
    .audio_in(vca_out_reg),
    .cutoff_val(filter_cutoff),
    .audio_out(mix_out)
);

endmodule
