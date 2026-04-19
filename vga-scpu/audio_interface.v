`timescale 1ns / 1ps

module audio_interface (
    input clk,
    input rst,
    
    // CPU接口
    input        reg_we,        // 写使能
    input [7:0] reg_addr,      // 寄存器地址
    input [31:0] reg_wdata,   // 写数据
    
    // 音频输出
    output AUD_PWM,
    output AUD_SD
);

    // 地址映射
    localparam ADDR_SLOT0_GATE = 8'h00;
    localparam ADDR_SLOT0_FREQ = 8'h01;
    localparam ADDR_SLOT1_GATE = 8'h02;
    localparam ADDR_SLOT1_FREQ = 8'h03;
    localparam ADDR_SLOT2_GATE = 8'h04;
    localparam ADDR_SLOT2_FREQ = 8'h05;
    localparam ADDR_SLOT3_GATE = 8'h06;
    localparam ADDR_SLOT3_FREQ = 8'h07;
    localparam ADDR_SLOT4_GATE = 8'h08;
    localparam ADDR_SLOT4_FREQ = 8'h09;
    localparam ADDR_SLOT5_GATE = 8'h0A;
    localparam ADDR_SLOT5_FREQ = 8'h0B;
    localparam ADDR_SLOT6_GATE = 8'h0C;
    localparam ADDR_SLOT6_FREQ = 8'h0D;
    localparam ADDR_SLOT7_GATE = 8'h0E;
    localparam ADDR_SLOT7_FREQ = 8'h0F;
    
    localparam ADDR_ENV_A = 8'h10;
    localparam ADDR_ENV_D = 8'h11;
    localparam ADDR_ENV_S = 8'h12;
    localparam ADDR_ENV_R = 8'h13;
    localparam ADDR_FILTER = 8'h14;
    localparam ADDR_VOLUME = 8'h15;
    localparam ADDR_UNISON = 8'h16;
    localparam ADDR_DETUNE = 8'h17;
    
    // 寄存器文件
    reg [31:0] reg_file [0:31];
    
    // 内部输出信号
    wire [7:0] slot_gates;
    wire [255:0] slot_freqs;
    wire [15:0] env_a, env_d, env_s, env_r;
    wire [4:0] filter_cutoff;
    wire [3:0] volume;
    wire [3:0] unison;
    wire [3:0] detune;
    
    // 寄存器写操作
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_file[ADDR_SLOT0_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT0_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT1_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT1_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT2_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT2_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT3_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT3_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT4_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT4_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT5_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT5_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT6_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT6_FREQ] <= 32'd0;
            reg_file[ADDR_SLOT7_GATE][7:0] <= 8'h00;
            reg_file[ADDR_SLOT7_FREQ] <= 32'd0;
            reg_file[ADDR_ENV_A] <= 16'd5000;
            reg_file[ADDR_ENV_D] <= 16'd100;
            reg_file[ADDR_ENV_S] <= 16'hFFFF;
            reg_file[ADDR_ENV_R] <= 16'd100;
            reg_file[ADDR_FILTER] <= 5'd4;
            reg_file[ADDR_VOLUME][3:0] <= 4'd8;
            reg_file[ADDR_UNISON][3:0] <= 4'd4;
            reg_file[ADDR_DETUNE][3:0] <= 4'd7;
        end else if (reg_we) begin
            case (reg_addr)
                ADDR_SLOT0_GATE: reg_file[ADDR_SLOT0_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT0_FREQ: reg_file[ADDR_SLOT0_FREQ] <= reg_wdata;
                ADDR_SLOT1_GATE: reg_file[ADDR_SLOT1_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT1_FREQ: reg_file[ADDR_SLOT1_FREQ] <= reg_wdata;
                ADDR_SLOT2_GATE: reg_file[ADDR_SLOT2_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT2_FREQ: reg_file[ADDR_SLOT2_FREQ] <= reg_wdata;
                ADDR_SLOT3_GATE: reg_file[ADDR_SLOT3_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT3_FREQ: reg_file[ADDR_SLOT3_FREQ] <= reg_wdata;
                ADDR_SLOT4_GATE: reg_file[ADDR_SLOT4_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT4_FREQ: reg_file[ADDR_SLOT4_FREQ] <= reg_wdata;
                ADDR_SLOT5_GATE: reg_file[ADDR_SLOT5_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT5_FREQ: reg_file[ADDR_SLOT5_FREQ] <= reg_wdata;
                ADDR_SLOT6_GATE: reg_file[ADDR_SLOT6_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT6_FREQ: reg_file[ADDR_SLOT6_FREQ] <= reg_wdata;
                ADDR_SLOT7_GATE: reg_file[ADDR_SLOT7_GATE][7:0] <= reg_wdata[7:0];
                ADDR_SLOT7_FREQ: reg_file[ADDR_SLOT7_FREQ] <= reg_wdata;
                ADDR_ENV_A:   reg_file[ADDR_ENV_A][15:0] <= reg_wdata[15:0];
                ADDR_ENV_D:   reg_file[ADDR_ENV_D][15:0] <= reg_wdata[15:0];
                ADDR_ENV_S:   reg_file[ADDR_ENV_S][15:0] <= reg_wdata[15:0];
                ADDR_ENV_R:   reg_file[ADDR_ENV_R][15:0] <= reg_wdata[15:0];
                ADDR_FILTER:  reg_file[ADDR_FILTER][4:0] <= reg_wdata[4:0];
                //ADDR_VOLUME:  reg_file[ADDR_VOLUME][3:0] <= reg_wdata[3:0];
                ADDR_UNISON:  reg_file[ADDR_UNISON][3:0] <= reg_wdata[3:0];
                ADDR_DETUNE: reg_file[ADDR_DETUNE][3:0] <= reg_wdata[3:0];
            endcase
        end
    end
    
    assign slot_gates = reg_file[ADDR_SLOT0_GATE][7:0];
    assign slot_freqs = {
        reg_file[ADDR_SLOT7_FREQ],
        reg_file[ADDR_SLOT6_FREQ],
        reg_file[ADDR_SLOT5_FREQ],
        reg_file[ADDR_SLOT4_FREQ],
        reg_file[ADDR_SLOT3_FREQ],
        reg_file[ADDR_SLOT2_FREQ],
        reg_file[ADDR_SLOT1_FREQ],
        reg_file[ADDR_SLOT0_FREQ]
    };
    assign env_a = reg_file[ADDR_ENV_A][15:0];
    assign env_d = reg_file[ADDR_ENV_D][15:0];
    assign env_s = reg_file[ADDR_ENV_S][15:0];
    assign env_r = reg_file[ADDR_ENV_R][15:0];
    assign filter_cutoff = reg_file[ADDR_FILTER][4:0];
    assign volume = reg_file[ADDR_VOLUME][3:0];
    assign unison = reg_file[ADDR_UNISON][3:0];
    assign detune = reg_file[ADDR_DETUNE][3:0];
    
    // 例化audio核心
    wire [9:0] mix_out;
    audio #(
        .MAX_SLOTS(8)
    ) synth_core (
        .clk(clk),
        .rst(rst),
        .slot_gates(slot_gates),
        .slot_freqs(slot_freqs),
        .env_a(env_a),
        .env_d(env_d),
        .env_s(env_s),
        .env_r(env_r),
        .filter_cutoff(filter_cutoff),
        .volume(volume),
        .unison(unison),
        .detune(detune),
        .mix_out(mix_out)
    );
    
    // PWM输出
    reg [9:0] pwm_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) pwm_cnt <= 10'd0;
        else     pwm_cnt <= pwm_cnt + 1'b1;
    end
    
    assign AUD_PWM = (pwm_cnt < mix_out) ? 1'b1 : 1'b0;
    assign AUD_SD = 1'b1;

endmodule