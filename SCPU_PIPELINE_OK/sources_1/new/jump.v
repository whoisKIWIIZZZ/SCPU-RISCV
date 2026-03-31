`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/05 19:32:58
// Design Name: 
// Module Name: jump
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


module jump(
        input Zero, Negative, Overflow, Carry,
        input [2:0] funct3,
        output reg jump_taken
    );
    always @* begin
        case (funct3)
            3'b000: jump_taken = Zero;   //BEQ
            3'b001: jump_taken = ~Zero;   //BNE
            3'b100: jump_taken = Negative ^ Overflow; //BLT
            3'b101: jump_taken = ~(Negative ^ Overflow); //BGE
            3'b110: jump_taken = Carry; //BLTU
            3'b111: jump_taken = ~Carry; //BGEU
            default: jump_taken = 1'b0;
        endcase
    end
endmodule
