`timescale 1ns / 1ps

module adsr (
    input clk,
    input rst,
    input gate,               // 按键触发信号 (1=按下, 0=松开)
    
    // ADSR 参数控制
    input [15:0] attack_step, // Attack 递增速度 (值越大越快)
    input [15:0] decay_step,  // Decay 递减速度
    input [15:0] sustain_lvl, // Sustain 维持音量电平 (0~65535)
    input [15:0] release_step,// Release 递减速度

    output [7:0] env_out      // 输出给音频引擎的音量乘数 (0~255)
);

    // ---- 1ms Tick 发生器 (假设系统时钟 100MHz) ----
    // 包络不需要在 100MHz 下更新，1ms 更新一次足够平滑
    reg [16:0] tick_cnt;
    wire tick = (tick_cnt >= 17'd100_000);
    
    always @(posedge clk) begin
        if (rst || tick) tick_cnt <= 0;
        else             tick_cnt <= tick_cnt + 1;
    end

    // ---- ADSR 状态机 ----
    localparam IDLE    = 3'd0;
    localparam ATTACK  = 3'd1;
    localparam DECAY   = 3'd2;
    localparam SUSTAIN = 3'd3;
    localparam RELEASE = 3'd4;

    reg [2:0]  state;
    reg [16:0] env_acc; // 17位累加器，防止溢出，最大值为 65535 (16'hFFFF)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state   <= IDLE;
            env_acc <= 17'd0;
        end else if (tick) begin
            // 无论处于什么状态，一旦按键松开，立刻进入 Release 阶段
            if (!gate && state != IDLE && state != RELEASE) begin
                state <= RELEASE;
            end 
            // 无论处于什么状态，一旦按键按下且当前是空闲，进入 Attack 阶段
            else if (gate && state == IDLE) begin
                state <= ATTACK;
            end 
            else begin
                case (state)
                    IDLE: begin
                        env_acc <= 17'd0;
                    end

                    ATTACK: begin
                        if (env_acc + attack_step >= 17'hFFFF) begin
                            env_acc <= 17'hFFFF;
                            state   <= DECAY;
                        end else begin
                            env_acc <= env_acc + attack_step;
                        end
                    end

                    DECAY: begin
                        if (env_acc <= sustain_lvl + decay_step) begin
                            env_acc <= sustain_lvl;
                            state   <= SUSTAIN;
                        end else begin
                            env_acc <= env_acc - decay_step;
                        end
                    end

                    SUSTAIN: begin
                        env_acc <= sustain_lvl;
                        // 等待 gate 拉低 (在上面的 if 判断中处理)
                    end

                    RELEASE: begin
                        if (env_acc <= release_step) begin
                            env_acc <= 17'd0;
                            state   <= IDLE;
                        end else begin
                            env_acc <= env_acc - release_step;
                        end
                    end
                endcase
            end
        end
    end

    // 取高 8 位作为输出乘数 (0~255)
    assign env_out = env_acc[15:8];

endmodule