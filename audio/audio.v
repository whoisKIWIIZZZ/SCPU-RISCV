`timescale 1ns / 1ps

module audio #(
    parameter MAX_SLOTS = 8
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

    input volume_up,
    input volume_down,

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
        wire sq_wave;
        wire [7:0] env_out;
        
        reg [31:0] phase_acc;
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                phase_acc <= 32'd0;
            end else if (slot_gates[i]) begin
                phase_acc <= phase_acc + slot_freq[i];
            end else begin
                phase_acc <= 32'd0;
            end
        end
        assign sq_wave = phase_acc[31];
        
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
        
        wire [16:0] prod = {sq_wave, 9'd0} * {9'd0, env_out};
        assign slot_outs[i] = prod[15:6];
    end
endgenerate

reg [3:0] volume_level;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        volume_level <= 4'd3;
    end else begin
        if (volume_up) volume_level <= (volume_level < 4'd15) ? volume_level + 1 : volume_level;
        if (volume_down) volume_level <= (volume_level > 4'd0) ? volume_level - 1 : volume_level;
    end
end

reg [13:0] mix_sum;
integer j;
always @(*) begin
    mix_sum = 14'd0;
    for (j = 0; j < MAX_SLOTS; j = j + 1) begin
        mix_sum = mix_sum + slot_outs[j];
    end
end

wire [13:0] mix_scaled = mix_sum * {1'b0, volume_level, 3'b0};
wire [9:0] vca_out = mix_scaled[13:4];

lpf filter_inst (
    .clk(clk),
    .rst(rst),
    .audio_in(vca_out),
    .cutoff_val(filter_cutoff),
    .audio_out(mix_out)
);

endmodule