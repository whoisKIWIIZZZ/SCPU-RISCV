`timescale 1ns / 1ps

module lpf (
    input clk,
    input rst,
    input      [9:0] audio_in,    // 来自 VCA 的原始音频
    input      [4:0] cutoff_val,  // 截止频率控制 (0~16)
    output     [9:0] audio_out    // 滤波后的音频
);

    // 为了在 100MHz 下能滤除极低频，我们需要极高精度的内部寄存器
    // 采用 10位整数 + 16位小数 = 26位
    reg signed [26:0] y_prev;
    
    // 扩展输入为带符号数
    wire signed [11:0] x_int = {2'b00, audio_in}; 
    
    // 提取当前寄存器的整数部分
    wire signed [11:0] y_int = y_prev[26:16];
    
    // 计算差值: (x[n] - y[n-1])
    wire signed [12:0] diff = x_int - y_int;
    
    // 符号扩展到 27 位，保证算术左移时的符号安全
    wire signed [26:0] diff_ext = {{14{diff[12]}}, diff};
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y_prev <= 27'd0;
        end else begin
            if (cutoff_val >= 16) begin
                // Bypass 旁通模式：完全不滤波
                y_prev <= {x_int[9:0], 16'd0};
            end else begin
                // y[n] = y[n-1] + (diff * (2^cutoff_val) / 2^16)
                // 通过算术左移改变截止频率，值越小，移位越少，滤波越重
                y_prev <= y_prev + (diff_ext <<< cutoff_val);
            end
        end
    end
    
    // 截取整数部分输出，并防止负数下溢
    assign audio_out = (y_prev[26]) ? 10'd0 : y_prev[25:16];

endmodule