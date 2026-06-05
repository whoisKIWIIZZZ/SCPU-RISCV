`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/05 09:46:43
// Design Name: 
// Module Name: immgen
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


module immgen(
        input [31:0] instruction,
        output reg [31:0] imm
    );
    reg[19:0] up20;
    always @* begin
        imm = 32'b0;
        case(instruction[31])
            1'b0: up20 = 20'b0;
            1'b1: up20 = 20'hFFFFF;
        endcase
        case(instruction[6:0])
            7'b0110011: begin // R
                imm = 32'b0;
            end
            7'b0000011: begin // lw
                imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0010011: begin // I type
               imm = (instruction[13:12] != 2'b01) ? 
             {{20{instruction[31]}}, instruction[31:20]} : 
             {27'b0, instruction[24:20]};
            end
            7'b1100111: begin // JALR
                 imm = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0100011: begin // sw
                imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            7'b1100011: begin // Branch
                imm = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            7'b0110111: begin // LUI
                imm = { instruction[31:12],12'b0};
            end
            7'b0010111: begin // AUIPC
                imm = { instruction[31:12],12'b0};
            end
            7'b1101111: begin // JAL
                imm = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
        endcase
    end
endmodule
