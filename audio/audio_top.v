`timescale 1ns / 1ps

module audio_top (
    input clk,
    input rst,
    
    // 板载物理交互接口
    // input       btn_play,    // 按下相当于按下琴键
    // input [2:0] sw_note,     // 选择音高 (C4 到 C5)
    // input [1:0] sw_unison,   // 选择同音数量 (1/2/4/8)
    // input [1:0] sw_detune,   // 选择失谐程度 (极小/小/中/大)
    input [15:0] sw_i,
    // 物理输出
    output AUD_PWM,
    output AUD_SD,
    
    // 音量调节开关
);

    wire btn_play;
    wire [2:0] sw_note;
    wire [1:0] sw_unison, sw_detune, sw_env_type, sw_filter;
    assign btn_play = sw_i[15];
    assign [2:0] sw_note = sw_i[2:0];
    assign [1:0] sw_unison = sw_i[5:4];
    assign [1:0] sw_detune = sw_i[7:6];
    assign [1:0] sw_env_type = sw_i[9:8];
    assign [1:0] sw_filter = sw_i[11:10];
    wire volume_up, volume_down;
    assign volume_up = sw_i[13];
    assign volume_down = sw_i[14];≈
    reg [31:0] target_step;
    reg [3:0]  unison_val;
    reg [3:0]  detune_val;

    // 音符 -> 相位步进值 (基于 100MHz 时钟计算)
    always @(*) begin
        case(sw_note)
            3'd0: target_step = 32'd11236; // C4 (261.6 Hz)
            3'd1: target_step = 32'd12612; // D4 (293.7 Hz)
            3'd2: target_step = 32'd14157; // E4 (329.6 Hz)
            3'd3: target_step = 32'd14999; // F4 (349.2 Hz)
            3'd4: target_step = 32'd16836; // G4 (392.0 Hz)
            3'd5: target_step = 32'd18898; // A4 (440.0 Hz)
            3'd6: target_step = 32'd21212; // B4 (493.9 Hz)
            3'd7: target_step = 32'd22473; // C5 (523.3 Hz)
        endcase
    end

    // Unison 开关 -> 实际通道数
    always @(*) begin
        case(sw_unison)
            2'd0: unison_val = 4'd1;
            2'd1: unison_val = 4'd2;
            2'd2: unison_val = 4'd4;
            2'd3: unison_val = 4'd8;
        endcase
    end

    // Detune 开关 -> 右移位数 (值越小，失谐越大)
    always @(*) begin
        case(sw_detune)
            2'd0: detune_val = 4'd9; // 几乎不失谐 (频率微调)
            2'd1: detune_val = 4'd7; // 轻微失谐
            2'd2: detune_val = 4'd6; // 中度失谐
            2'd3: detune_val = 4'd4; // 严重失谐 (电音感)
        endcase
    end

    // ---- 2. 播放控制 ----
    // 只有在按下播放键时，才把频率步进值传给引擎；否则传 0 静音
    wire [31:0] current_step = btn_play ? target_step : 32'd0;

    // ---- 3. 例化核心音频引擎 ----
    reg [15:0] a_step, d_step, s_lvl, r_step;

    always @(*) begin
        case(sw_env_type)
            // 00: 电子琴 (Organ) - 秒开秒关
            2'd0: begin 
                a_step = 16'd5000;  // 极快攻击
                d_step = 16'd0;     // 无衰减
                s_lvl  = 16'hFFFF;  // 100% 维持
                r_step = 16'd5000;  // 极快释放
            end
            // 01: 拨弦 (Pluck / Guitar) - 快速敲击，自然消散
            2'd1: begin
                a_step = 16'd5000;  // 极快攻击
                d_step = 16'd100;   // 缓慢衰减
                s_lvl  = 16'd0;     // 无维持 (按住最终也会没声音)
                r_step = 16'd100;   // 慢释放
            end
            // 10: 提琴/合成器铺底 (Pad) - 渐入渐出
            2'd2: begin
                a_step = 16'd50;    // 极慢攻击 (渐入)
                d_step = 16'd0;
                s_lvl  = 16'hFFFF;  // 100% 维持
                r_step = 16'd50;    // 慢释放 (渐出)
            end
            // 11: 铜管/领奏 (Brass/Lead) - 强力起音后回落到正常音量
            2'd3: begin
                a_step = 16'd2000;  // 较快攻击
                d_step = 16'd300;   // 快速回落
                s_lvl  = 16'd32768; // 维持在 50% 音量
                r_step = 16'd500;   // 较快释放
            end
        endcase
    end

    // ---- 例化核心音频引擎 ----
    reg [4:0] filter_val;
    always @(*) begin
        case(sw_filter)
            2'd3: filter_val = 5'd16; // 旁通 (Bypass) - 尖锐的经典方波
            2'd2: filter_val = 5'd4;  // 约 4kHz - 明亮但去除了刺耳的高频
            2'd1: filter_val = 5'd2;  // 约 1kHz - 温暖，适合 Pad 或低沉的琴声
            2'd0: filter_val = 5'd0;  // 约 240Hz - 极致沉闷，适合 Sub Bass
        endcase
    end

    // ---- 例化核心音频引擎 ----
    wire [9:0] mix_out;

    audio #(
        .MAX_VOICES(8)
    ) synth_core (
        .clk(clk),
        .rst(rst),
        .gate(btn_play),
        .freq_step_base(btn_play ? target_step : 32'd0),
        .unison_count(unison_val),
        .detune_shift(detune_val),
        .env_a(a_step), .env_d(d_step), .env_s(s_lvl), .env_r(r_step),
        
        // 传入滤波器控制信号
        .filter_cutoff(filter_val),
        
        // 连接音量调节开关信号
        .volume_up(volume_up),
        .volume_down(volume_down),
        
        .mix_out(mix_out)
    );

    // ---- PWM 发生器 ----
    reg [9:0] pwm_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) pwm_cnt <= 10'd0;
        else     pwm_cnt <= pwm_cnt + 1'b1;
    end

    assign AUD_PWM = (pwm_cnt < mix_out) ? 1'b1 : 1'b0;

    // ---- 功放使能控制 (AUD_SD) ----
    // 因为现在有了 Release (尾音)，即使 btn_play 松开，声音也不会立刻停止！
    // 我们最简单的方法是：常开功放 (给高电平)。如果你的板子上有底噪，我们可以后续再做优化。
    assign AUD_SD = 1'b1; 

endmodule