`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/05 18:57:00
// Design Name: 
// Module Name: ALUcontrol
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


module ALUcontrol(
        input [3:0] instr,
        input [1:0] ALUOp,
        output reg [3:0] ALUoperation
    );
    always @* begin
        case(ALUOp)
            2'b00: begin
                ALUoperation = 4'b0000;
            end
            2'b01: begin
                ALUoperation = 4'b0001;
            end
            2'b10: begin
                case(instr)
                    4'b0000: ALUoperation = 4'b0000;
                    4'b1000: ALUoperation = 4'b0001;
                    4'b0001: ALUoperation = 4'b0101;
                    4'b0100: ALUoperation = 4'b0100;
                    4'b0101: ALUoperation = 4'b0110;
                    4'b1101: ALUoperation = 4'b0111;
                    4'b0110: ALUoperation = 4'b0011;
                    4'b0111: ALUoperation = 4'b0010;
                    default: ALUoperation = 4'b0000;
                endcase
            end
            2'b11: begin
                case(instr[2:0])
                    3'b000: ALUoperation = 4'b0000;
                    3'b001: ALUoperation = 4'b0101;
                    3'b100: ALUoperation = 4'b0100;
                    3'b101: begin
                        if (instr[3] == 1'b0) ALUoperation = 4'b0110;
                        else ALUoperation = 4'b0111;
                    end
                    3'b110: ALUoperation = 4'b0011;
                    3'b111: ALUoperation = 4'b0010;
                    default: ALUoperation = 4'b0000;
                endcase
            end
            default: ALUoperation = 4'b0000;
        endcase
    end
endmodule
