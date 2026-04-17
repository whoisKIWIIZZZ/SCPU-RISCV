`timescale 1ns / 1ps

module audio_top (
    input clk,
    input rst,
    
    input [15:0] sw_i,
    output AUD_PWM,
    output AUD_SD
);

    wire btn_play;
    wire [1:0] sw_unison, sw_detune, sw_env_type, sw_filter;
    assign btn_play = sw_i[15];
    wire [3:0] sw_note;
    assign [3:0] sw_note = sw_i[3:0];
    assign [1:0] sw_unison = sw_i[5:4];
    assign [1:0] sw_detune = sw_i[7:6];
    assign [1:0] sw_env_type = sw_i[9:8];
    assign [1:0] sw_filter = sw_i[11:10];
    wire volume_up, volume_down;
    assign volume_up = sw_i[13];
    assign volume_down = sw_i[14];
    reg [31:0] target_step;
    reg [3:0]  unison_val;
    reg [3:0]  detune_val;

    always @(*) begin
        case(sw_note)
            4'd0: target_step = 32'd11236;  // C4
            4'd1: target_step = 32'd11898;  // C#4
            4'd2: target_step = 32'd12612;  // D4
            4'd3: target_step = 32'd13356;  // D#4
            4'd4: target_step = 32'd14157;  // E4
            4'd5: target_step = 32'd14999;  // F4
            4'd6: target_step = 32'd15893;  // F#4
            4'd7: target_step = 32'd16836;  // G4
            4'd8: target_step = 32'd17846;  // G#4
            4'd9: target_step = 32'd18898;  // A4
            4'd10: target_step = 32'd20010;  // A#4
            4'd11: target_step = 32'd21212;  // B4
            4'd12: target_step = 32'd22473;  // C5
            4'd13: target_step = 32'd23801;  // C#5
            4'd14: target_step = 32'd25223;  // D5
            4'd15: target_step = 32'd0;  // reserved
        endcase
    end

    always @(*) begin
        case(sw_unison)
            2'd0: unison_val = 4'd1;
            2'd1: unison_val = 4'd2;
            2'd2: unison_val = 4'd4;
            2'd3: unison_val = 4'd8;
        endcase
    end

    always @(*) begin
        case(sw_detune)
            2'd0: detune_val = 4'd9;
            2'd1: detune_val = 4'd7;
            2'd2: detune_val = 4'd6;
            2'd3: detune_val = 4'd4;
        endcase
    end

    wire [31:0] current_step = btn_play ? target_step : 32'd0;

    reg [15:0] a_step, d_step, s_lvl, r_step;

    always @(*) begin
        case(sw_env_type)
            2'd0: begin 
                a_step = 16'd5000;
                d_step = 16'd0;
                s_lvl  = 16'hFFFF;
                r_step = 16'd5000;
            end
            2'd1: begin
                a_step = 16'd5000;
                d_step = 16'd100;
                s_lvl  = 16'd0;
                r_step = 16'd100;
            end
            2'd2: begin
                a_step = 16'd50;
                d_step = 16'd0;
                s_lvl  = 16'hFFFF;
                r_step = 16'd50;
            end
            2'd3: begin
                a_step = 16'd2000;
                d_step = 16'd300;
                s_lvl  = 16'd32768;
                r_step = 16'd500;
            end
        endcase
    end

    reg [4:0] filter_val;
    always @(*) begin
        case(sw_filter)
            2'd3: filter_val = 5'd16;
            2'd2: filter_val = 5'd4;
            2'd1: filter_val = 5'd2;
            2'd0: filter_val = 5'd0;
        endcase
    end

    wire [7:0] slot_gates;
    wire [255:0] slot_freqs;
    
    wire test_mode = (sw_note == 4'hF);
    
    assign slot_gates[0] = test_mode ? btn_play : btn_play;
    assign slot_gates[1] = test_mode ? btn_play : 1'b0;
    assign slot_gates[2] = test_mode ? btn_play : 1'b0;
    assign slot_gates[3] = test_mode ? btn_play : 1'b0;
    assign slot_gates[4] = test_mode ? btn_play : 1'b0;
    assign slot_gates[5] = test_mode ? 1'b0 : 1'b0;
    assign slot_gates[6] = test_mode ? 1'b0 : 1'b0;
    assign slot_gates[7] = test_mode ? 1'b0 : 1'b0;
    
    assign slot_freqs[0*32 +: 32] = test_mode ? 32'd11236 : current_step;  // C4
    assign slot_freqs[1*32 +: 32] = test_mode ? 32'd14157 : 32'd0;  // E4
    assign slot_freqs[2*32 +: 32] = test_mode ? 32'd16836 : 32'd0;  // G4
    assign slot_freqs[3*32 +: 32] = test_mode ? 32'd21212 : 32'd0;  // B4
    assign slot_freqs[4*32 +: 32] = test_mode ? 32'd25223 : 32'd0;  // D5
    assign slot_freqs[5*32 +: 32] = 32'd0;
    assign slot_freqs[6*32 +: 32] = 32'd0;
    assign slot_freqs[7*32 +: 32] = 32'd0;

    wire [9:0] mix_out;

    audio #(
        .MAX_SLOTS(8)
    ) synth_core (
        .clk(clk),
        .rst(rst),
        .slot_gates(slot_gates),
        .slot_freqs(slot_freqs),
        .env_a(a_step),
        .env_d(d_step),
        .env_s(s_lvl),
        .env_r(r_step),
        .filter_cutoff(filter_val),
        .volume_up(volume_up),
        .volume_down(volume_down),
        .mix_out(mix_out)
    );

    reg [9:0] pwm_cnt;
    always @(posedge clk or posedge rst) begin
        if (rst) pwm_cnt <= 10'd0;
        else     pwm_cnt <= pwm_cnt + 1'b1;
    end

    assign AUD_PWM = (pwm_cnt < mix_out) ? 1'b1 : 1'b0;

    assign AUD_SD = 1'b1; 

    endmodule