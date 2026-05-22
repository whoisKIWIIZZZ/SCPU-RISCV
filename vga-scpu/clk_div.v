`timescale 1ns / 1ps
module clk_div(
    input clk,
    input rst,
    input SW2,
    output reg [31:0] clkdiv,
    output Clk_CPU
);

    always @(posedge clk or posedge rst) begin
        if (rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1'b1;
    end

    // Divided clock via toggle FF → BUFG (clean, low-skew global clock)
    // SW2=1: 100MHz / 16 = 6.25MHz
    // SW2=0: 100MHz / 64 = 1.5625MHz
    reg clk_toggle;
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_toggle <= 0;
        else if (SW2 ? (clkdiv[22:0] == 23'b11111111111111111111111) : (clkdiv[0] == 1'b11))
            clk_toggle <= ~clk_toggle;
    end

    BUFG u_bufg_cpu (.I(clk_toggle), .O(Clk_CPU));

endmodule
