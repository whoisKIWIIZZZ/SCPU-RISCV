`timescale 1ns / 1ps

// =============================================================================
// audio_interface.v  —  简化寄存器接口版本
// =============================================================================
//
// CPU 只需写两个寄存器地址：
// 0000000000001
//  地址 0x00  [主控字]
// 0000 
//  ┌──────┬──────────┬────────┬────────┬────────┬────────────────┐
//  │ 31:28│  27:26   │ 25:22  │ 21:18  │ 17:14  │    13:0        │
//  │ (保留)│waveform  │ detune │ unison │ volume │  key_bitmap    │
//  └──────┴──────────┴────────┴────────┴────────┴────────────────┘
//    waveform: 00=square, 01=triangle, 10=sawtooth, 11=sine(预留)
//    key_bitmap: bit i = 1 表示第 i 个半音被按下
//      bit 0 = C4,  bit 1 = C#4, bit 2 = D4,  bit 3 = D#4,
//      bit 4 = E4,  bit 5 = F4,  bit 6 = F#4, bit 7 = G4,
//      bit 8 = G#4, bit 9 = A4,  bit10 = A#4, bit11 = B4,
//      bit12 = C5,  bit13 = (保留)
//    volume:  4bit，0~15（默认8）
//    unison:  4bit，同时发音的voice数，1~8（默认4）
//    detune:  4bit，detune偏移量（默认7）
//
//  地址 0x01  [ADSR字]
//  ┌──────────┬──────────┬──────────┬──────────┐
//  │  31:24   │  23:16   │  15:8    │   7:0    │
//  │  attack  │  decay   │ sustain  │ release  │
//  └──────────┴──────────┴──────────┴──────────┘
//    每段 8bit（0~255），内部线性映射到 adsr 模块所需的 16bit 步进值/电平。
//    attack/decay/release: 值越大速度越快（步进 = val * 256）
//    sustain: 0=静音，255=全音量保持（电平 = val * 256）
//    默认值：A=20(~250ms), D=100, S=255(全保持), R=100
//
//  地址 0x02  [filter字]（可选，不写则用默认值）
//  ┌──────────────────────────┬──────┐
//  │          31:5            │  4:0 │
//  │          (保留)           │cutoff│
//  └──────────────────────────┴──────┘
//
// =============================================================================

module audio_interface (
    input clk,
    input rst,

    // CPU接口（简化为3个地址）
    input        reg_we,
    input  [7:0] reg_addr,
    input [31:0] reg_wdata,

    // 音频输出
    output AUD_PWM,
    output AUD_SD
);

// ---------------------------------------------------------------------------
// 地址常量
// ---------------------------------------------------------------------------
localparam ADDR_CTRL  = 8'h00;   // 主控字：key_bitmap + volume + unison + detune
localparam ADDR_ADSR  = 8'h01;   // ADSR 打包字
localparam ADDR_FILT  = 8'h02;   // filter cutoff

// ---------------------------------------------------------------------------
// C4 ~ C5 的频率步进值（32位相位累加器，时钟 100MHz，2^32/100MHz * f）
// phase_step = round(f * 2^32 / 100_000_000)
// C4=261.63, C#4=277.18, D4=293.66, D#4=311.13, E4=329.63
// F4=349.23, F#4=369.99, G4=392.00, G#4=415.30, A4=440.00
// A#4=466.16, B4=493.88, C5=523.25
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
// 寄存器
// ---------------------------------------------------------------------------
reg [31:0] reg_ctrl; // 主控字
reg [31:0] reg_adsr; // ADSR字
reg [4:0]  reg_filt; // filter cutoff

always @(posedge clk or posedge rst) begin
    if (rst) begin
        //               detune  unison  volume  key_bitmap
        reg_ctrl <= {5'b0, 4'd7, 4'd4,  4'd8,  14'd0};
        //               A       D       S       R
        reg_adsr <= {8'd20, 8'd100, 8'd255, 8'd100};
        reg_filt <= 5'd16;  // bypass by default, let harmonics through
    end else if (reg_we) begin
        case (reg_addr)
            ADDR_CTRL: reg_ctrl <= {reg_ctrl[31:14],reg_wdata[13:0]};
            ADDR_ADSR: reg_adsr <= reg_wdata;
            ADDR_FILT: reg_filt <= reg_wdata[4:0];
            default: ;
        endcase
    end
end

// ---------------------------------------------------------------------------
// 解包主控字
// ---------------------------------------------------------------------------
wire [13:0] key_bitmap   = reg_ctrl[13:0];
wire [3:0]  volume       = reg_ctrl[17:14];
wire [3:0]  unison       = reg_ctrl[21:18];
wire [3:0]  detune       = reg_ctrl[25:22];
wire [1:0]  waveform_sel = reg_ctrl[27:26];

// ---------------------------------------------------------------------------
// 解包 ADSR（8bit -> 16bit：步进 = val*256，sustain电平 = val*256）
// ---------------------------------------------------------------------------
wire [15:0] env_a = {reg_adsr[31:24], 8'd0}; // attack_step
wire [15:0] env_d = {reg_adsr[23:16], 8'd0}; // decay_step
wire [15:0] env_s = {reg_adsr[15: 8], 8'd0}; // sustain_lvl
wire [15:0] env_r = {reg_adsr[ 7: 0], 8'd0}; // release_step

// ---------------------------------------------------------------------------
// 将 key_bitmap 映射为 slot_gates 和 slot_freqs
// 最多 8 个 slot，按 key_bitmap 低位到高位依次分配给活跃的音符
// ---------------------------------------------------------------------------
// 第一步：找出所有被按下的音符，依次填入 slot
// （组合逻辑，Verilog 中用 for 循环实现优先级编码器）

reg [3:0]  slot_note [0:7];   // 每个slot对应哪个音符(0~12)
reg        slot_gate_r [0:7]; // 每个slot是否激活
integer    si, ni;

always @(*) begin
    // 初始化
    for (si = 0; si < 13; si = si + 1) begin
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

// 拼成audio核心需要的打包格式
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
// 例化 audio 核心
// ---------------------------------------------------------------------------
wire [9:0] mix_out;
audio #(
    .MAX_SLOTS(8)
) synth_core (
    .clk         (clk),
    .rst         (rst),
    .slot_gates  (slot_gates),
    .slot_freqs  (slot_freqs),
    .env_a       (env_a),
    .env_d       (env_d),
    .env_s       (env_s),
    .env_r       (env_r),
    .filter_cutoff(reg_filt),
    .volume      (volume),
    .unison      (unison),
    .detune       (detune),
    .waveform_sel (waveform_sel),
    .mix_out      (mix_out)
);

// ---------------------------------------------------------------------------
// PWM 输出
// ---------------------------------------------------------------------------
reg [9:0] pwm_cnt;
always @(posedge clk or posedge rst) begin
    if (rst) pwm_cnt <= 10'd0;
    else     pwm_cnt <= pwm_cnt + 1'b1;
end

assign AUD_PWM = (pwm_cnt < mix_out) ? 1'b1 : 1'b0;
assign AUD_SD  = 1'b1;

endmodule