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
    input [1:0] waveform_sel,

    output [9:0] mix_out
);

wire [31:0] slot_freq [0:MAX_SLOTS-1];
genvar gi;
generate
    for (gi = 0; gi < MAX_SLOTS; gi = gi + 1) begin : freq_assign
        assign slot_freq[gi] = slot_freqs[gi*32 +: 32];
    end
endgenerate

wire [9:0] slot_outs [0:MAX_SLOTS-1];

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
        
        wire [3:0] voice_wave [0:MAX_VOICES-1];
        genvar wv;
        for (wv = 0; wv < MAX_VOICES; wv = wv + 1) begin : wave_gen
            wire [31:0] ph = phase_acc[wv];
            wire [3:0] w_square   = ph[31] ? 4'd15 : 4'd0;
            wire [3:0] w_triangle = ph[31] ? ~ph[30:27] : ph[30:27];
            wire [3:0] w_saw      = ph[31:28];
            wire [3:0] w_sine     = w_triangle; // placeholder, LUT-based sine TBD
            assign voice_wave[wv] = (waveform_sel == 2'd0) ? w_square   :
                                    (waveform_sel == 2'd1) ? w_triangle :
                                    (waveform_sel == 2'd2) ? w_saw      :
                                                              w_sine;
        end

        integer k;
        always @(*) begin
            voice_sum = 10'd0;
            for (k = 0; k < MAX_VOICES; k = k + 1) begin
                if (k < voice_count) begin
                    voice_sum = voice_sum + {6'd0, voice_wave[k]};
                end
            end
        end
        // if (i == 0) begin
        //     always @(posedge clk) begin
        //         if (slot_gates[i])
        //             $display("Time: %t | Slot 0 Env: %d | Sum: %d | voice_count:%d|phase_acc:%h", $time, env_out, voice_sum,env_gen.env_acc,phase_acc[0]);
        //     end
        // end
        wire [23:0] prod = {voice_sum, 6'd0} * {9'd0, env_out};
        assign voice_out = prod[22:13];
        assign slot_outs[i] = voice_out;
    end
endgenerate

reg [13:0] mix_sum;
integer j;
always @(*) begin
    mix_sum = 14'd0;
    for (j = 0; j < MAX_SLOTS; j = j + 1) begin
        mix_sum = mix_sum + slot_outs[j];
    end
end

wire [22:0] mix_scaled = mix_sum * {10'b0, volume, 3'b0};
wire [9:0] vca_out = mix_scaled[22:13];

lpf filter_inst (
    .clk(clk),
    .rst(rst),
    .audio_in(vca_out),
    .cutoff_val(filter_cutoff),
    .audio_out(mix_out)
);

endmodule