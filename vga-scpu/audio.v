`timescale 1ns / 1ps
module audio(
    input clk,
    input rst,
    input audio_we,
    input [31:0] audio_in,
    output AUD_PWM,
    output AUD_SD
);
    reg [31:0] audio_reg;
    always @(posedge clk or posedge rst) begin
        if(rst) audio_reg <= 32'd0;
        else if(audio_we) audio_reg <= audio_in;
    end

    // --- 1. PWM 载波 (缩减到 10位，提高载波频率，确保更容易驱动) ---
    reg [9:0] pwm_cnt;
    always @(posedge clk or posedge rst) begin
        if(rst) pwm_cnt <= 10'd0;
        else pwm_cnt <= pwm_cnt + 1'b1;
    end

    // --- 2. 四路微失谐振荡器 ---
    reg [31:0] cnt0, cnt1, cnt2, cnt3;
    reg out0, out1, out2, out3;

    // 调整失谐量：这里用较大的偏移，确保你能听出区别
    wire [31:0] lim0 = audio_reg;
    wire [31:0] lim1 = audio_reg + (audio_reg >> 6); // 偏移约 1.5%
    wire [31:0] lim2 = audio_reg - (audio_reg >> 7); // 偏移约 0.8%
    wire [31:0] lim3 = audio_reg + (audio_reg >> 8); // 偏移约 0.4%

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            {cnt0, cnt1, cnt2, cnt3} <= 128'd0;
            {out0, out1, out2, out3} <= 4'b0;
        end else if(audio_reg > 0) begin
            // 分别计数翻转
            if(cnt0 >= (lim0 >> 1)) begin cnt0 <= 0; out0 <= ~out0; end else cnt0 <= cnt0 + 1;
            if(cnt1 >= (lim1 >> 1)) begin cnt1 <= 0; out1 <= ~out1; end else cnt1 <= cnt1 + 1;
            if(cnt2 >= (lim2 >> 1)) begin cnt2 <= 0; out2 <= ~out2; end else cnt2 <= cnt2 + 1;
            if(cnt3 >= (lim3 >> 1)) begin cnt3 <= 0; out3 <= ~out3; end else cnt3 <= cnt3 + 1;
        end
    end

    // --- 3. 混音器 ---
    // 每个通道贡献 255 的值，4路加起来最大 1020 (小于 10'd1024)
    wire [9:0] mix_sum = (out0 ? 10'd255 : 10'd0) + 
                         (out1 ? 10'd255 : 10'd0) + 
                         (out2 ? 10'd255 : 10'd0) + 
                         (out3 ? 10'd255 : 10'd0);

    // 重点：这里改回 1'b1 和 1'b0，不再用 1'bz
    assign AUD_PWM = (pwm_cnt < mix_sum) ? 1'b1 : 1'b0;

    // --- 4. 强制开启 AUD_SD ---
    // 有些开发板如果这个引脚不持续给 1，功放芯片会进入休眠
    assign AUD_SD = 1'b1; 

endmodule