`timescale 1ns / 1ps
module audio #(
    parameter MAX_VOICES = 8
)(
    input clk,
    input rst,
    input audio_we,
    input [31:0] audio_in,

    // 新增控制接口
    input [31:0] unison_in,
    input        unison_we,
    input [31:0] detune_in,
    input        detune_we,

    output AUD_PWM,
    output AUD_SD
);

// ---- 音频频率寄存器 ----
reg [31:0] audio_reg;
always @(posedge clk or posedge rst) begin
    if (rst)           audio_reg <= 32'd0;
    else if (audio_we) audio_reg <= audio_in;
end

// ---- 控制寄存器：锁存 CPU 写入 ----
reg [3:0] unison_count;
reg [3:0] detune_shift;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        unison_count <= 4'd4;
        detune_shift <= 4'd6;
    end else begin
        if (unison_we) unison_count <= unison_in[3:0];
        if (detune_we) detune_shift <= detune_in[3:0];
    end
end

// ---- PWM 载波（10位） ----
reg [9:0] pwm_cnt;
always @(posedge clk or posedge rst) begin
    if (rst) pwm_cnt <= 10'd0;
    else     pwm_cnt <= pwm_cnt + 1'b1;
end

// ---- 参数化振荡器阵列 ----
// voice 0：基准频率，不失谐
// voice i：audio_reg + (audio_reg >> (detune_shift + i - 1))
// detune_shift 越小 → 偏移越大 → 失谐越明显

wire [31:0] lim [0:MAX_VOICES-1];
reg  [31:0] cnt [0:MAX_VOICES-1];
reg         out [0:MAX_VOICES-1];

genvar i;
generate
    for (i = 0; i < MAX_VOICES; i = i + 1) begin : voice_gen
        // 失谐量计算：i=0 不偏移，i>0 按 detune_shift+i-1 右移
        wire [3:0] shift_val = detune_shift + i - 1;

        assign lim[i] = (i == 0)
            ? audio_reg
            : audio_reg + (audio_reg >> shift_val);

        always @(posedge clk or posedge rst) begin
            if (rst) begin
                cnt[i] <= 32'd0;
                out[i] <= 1'b0;
            end else if (audio_reg > 0 && i < unison_count) begin
                // 激活路：正常计数翻转
                if (cnt[i] >= (lim[i] >> 1)) begin
                    cnt[i] <= 32'd0;
                    out[i] <= ~out[i];
                end else begin
                    cnt[i] <= cnt[i] + 1;
                end
            end else begin
                // 未激活路：清零，不发声
                cnt[i] <= 32'd0;
                out[i] <= 1'b0;
            end
        end
    end
endgenerate

// ---- 动态混音器 ----
// 每路振幅 = 1024 / unison_count，查找表保证总幅度恒定
reg [9:0] per_voice_amp;
always @(*) begin
    case (unison_count)
        4'd1:    per_voice_amp = 10'd1023;
        4'd2:    per_voice_amp = 10'd511;
        4'd3:    per_voice_amp = 10'd341;
        4'd4:    per_voice_amp = 10'd255;
        4'd5:    per_voice_amp = 10'd204;
        4'd6:    per_voice_amp = 10'd170;
        4'd7:    per_voice_amp = 10'd146;
        4'd8:    per_voice_amp = 10'd127;
        default: per_voice_amp = 10'd255;
    endcase
end

// 累加所有激活路（组合逻辑，综合为加法树）
reg [12:0] mix_sum;
integer j;
always @(*) begin
    mix_sum = 13'd0;
    for (j = 0; j < MAX_VOICES; j = j + 1) begin
        if (j < unison_count)
            mix_sum = mix_sum + (out[j] ? {3'b0, per_voice_amp} : 13'd0);
    end
end

assign AUD_PWM = (pwm_cnt < mix_sum[9:0]) ? 1'b1 : 1'b0;

// ---- AUD_SD：有音频信号时使能，静默超时后关闭 ----
reg        SD_out;
reg [31:0] counter;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        SD_out  <= 1'b0;
        counter <= 32'h0;
    end else if (audio_we) begin
        SD_out  <= 1'b1;
        counter <= 32'h0;
    end else if (counter[25]) begin
        SD_out  <= 1'b0;
    end else begin
        counter <= counter + 1'b1;
    end
end
assign AUD_SD = SD_out;

endmodule