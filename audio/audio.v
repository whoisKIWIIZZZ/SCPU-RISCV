`timescale 1ns / 1ps

module audio #(
    parameter MAX_VOICES = 8
)(
    input clk,
    input rst,
    input gate, 

    // 振荡器参数
    input [31:0] freq_step_base,
    input [3:0]  unison_count,
    input [3:0]  detune_shift,
    
    // ADSR 参数
    input [15:0] env_a,
    input [15:0] env_d,
    input [15:0] env_s,
    input [15:0] env_r,

    // 新增：滤波器截止频率
    input [4:0]  filter_cutoff,

    // 新增：音量调节开关
    input volume_up,
    input volume_down,

    output [9:0] mix_out
);

// ---- ADSR 与 混音逻辑 (保留不变) ----
wire [7:0] envelope_gain; 
adsr env_gen (
    .clk(clk), .rst(rst), .gate(gate),
    .attack_step(env_a), .decay_step(env_d), .sustain_lvl(env_s), .release_step(env_r),
    .env_out(envelope_gain)
);

reg [9:0] per_voice_amp;
always @(*) begin
    // (省略原有 switch case 代码，保持原样)
    case (unison_count)
        4'd1: per_voice_amp = 10'd1023;
        4'd2: per_voice_amp = 10'd511;
        // ... (保持原样即可) ...
        default: per_voice_amp = 10'd255;
    endcase
end

wire [31:0] step_size [0:MAX_VOICES-1];
reg  [31:0] phase_acc [0:MAX_VOICES-1];
wire        sq_wave   [0:MAX_VOICES-1];

genvar i;
generate
    for (i = 0; i < MAX_VOICES; i = i + 1) begin : voice_gen
        wire [3:0] shift_val = detune_shift + i - 1;
        assign step_size[i] = (i == 0) ? freq_step_base : freq_step_base + (freq_step_base >> shift_val);
        always @(posedge clk or posedge rst) begin
            if (rst) phase_acc[i] <= 32'd0;
            else if (i < unison_count) phase_acc[i] <= phase_acc[i] + step_size[i];
            else phase_acc[i] <= 32'd0;
        end
        assign sq_wave[i] = phase_acc[i][31];
    end
endgenerate

reg [10:0] mix_sum_raw; 
integer j;

// 新增：响度调节寄存器
reg [3:0] volume_level;

// 音量调节逻辑
always @(posedge clk or posedge rst) begin
    if (rst) begin
        volume_level <= 4'd3; // 默认音量为中等
    end else begin
        if (volume_up)   volume_level <= (volume_level < 4'd15) ? volume_level + 1 : volume_level;
        if (volume_down) volume_level <= (volume_level > 4'd0)  ? volume_level - 1 : volume_level;
    end
end

// 修改动态混音器逻辑，加入音量调节
reg [9:0] adjusted_amp;
always @(*) begin
    adjusted_amp = (per_voice_amp * volume_level) >> 3; // 音量范围 0~15，缩放到 0~1023
end

// 更新混音逻辑
always @(*) begin
    mix_sum_raw = 11'd0;
    for (j = 0; j < MAX_VOICES; j = j + 1) begin
        if (j < unison_count) mix_sum_raw = mix_sum_raw + (sq_wave[j] ? {1'b0, adjusted_amp} : 11'd0);
    end
end

// ---- VCA (保持不变) ----
wire [18:0] amplified_signal = mix_sum_raw * envelope_gain;
wire [9:0]  vca_out = amplified_signal[17:8];

// ---- 新增：LPF 低通滤波器 ----
lpf filter_inst (
    .clk(clk),
    .rst(rst),
    .audio_in(vca_out),
    .cutoff_val(filter_cutoff),
    .audio_out(mix_out) // 滤波结果直接作为最终输出
);

endmodule