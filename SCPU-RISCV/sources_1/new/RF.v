`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/07 09:49:58
// Design Name: 
// Module Name: RF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RF(
    input clk, //100MHZ CLK
    input [15:0] sw_i,
    input rst, //reset signal
    input RFWr, //Rfwrite = mem2reg input [15:0] sw_i, //sw_i[15]---sw_i[0]
    input [4:0] A1, A2, A3, // Register Num
    input [31:0] WD, //Write data
    output [31:0] RD1, RD2 //Data output port   ��������

    );


    integer i;
    reg[31:0] rf[31:0];
    always@(negedge clk or posedge rst) begin

       if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 32'h00010000*i+i; //  0;
      rf[0] <= 0; // x0 always 0
      rf[1] <=0;
      rf[2] <=32'h0000080;
end
        //写RD
        else if(RFWr && (A3 != 5'b0))begin 
            rf[A3]<=WD;
        end

    end

    assign RD1 = rf[A1];
    assign RD2 = rf[A2];


endmodule

