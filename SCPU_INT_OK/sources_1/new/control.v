`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/05 09:43:44
// Design Name: 
// Module Name: control
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

`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100

module control(
        input [31:0] instruction,
        output reg RegWrite, ALUsrc, MemWrite, MemtoReg, MemRead, Branch, Jump, RegDest,AUIPC,LUI,
        output reg [1:0] ALUOp,
        output reg [2:0] DMType
    );
    always @* begin
        RegWrite = 1'b0;
        ALUsrc   = 1'b0;
        MemWrite = 1'b0;
        MemtoReg = 1'b0;
        MemRead  = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        RegDest  = 1'b0;
        AUIPC    = 1'b0;
        LUI      = 1'b0;
        ALUOp    = 2'b00;
        DMType   = 3'b000; 
        case(instruction[6:0])
            7'b0110011: begin // R
                RegWrite = 1;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b10;
                AUIPC = 0;
                LUI =0;
            end
            7'b0000011: begin // lw
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 1;
                MemRead = 1;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b00;
                AUIPC = 0;
                LUI =0;
                DMType = (instruction[14:12] == 3'b010) ? `dm_word :
                         (instruction[14:12] == 3'b001) ? `dm_halfword :
                         (instruction[14:12] == 3'b101) ? `dm_halfword_unsigned :
                         (instruction[14:12] == 3'b000) ? `dm_byte :
                         (instruction[14:12] == 3'b100) ? `dm_byte_unsigned : `dm_word;
            end
            7'b0010011: begin // I
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b11;
                AUIPC = 0;
                LUI =0;
               
            end
            7'b0100011: begin // S
                RegWrite = 0;
                ALUsrc = 1;
                MemWrite = 1;
                MemtoReg = 1;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b00;
                AUIPC = 0;
                LUI =0;
                 DMType = (instruction[14:12] == 3'b010) ? `dm_word :
                            (instruction[14:12] == 3'b001) ? `dm_halfword :
                            (instruction[14:12] == 3'b101) ? `dm_halfword_unsigned :
                            (instruction[14:12] == 3'b000) ? `dm_byte :
                            (instruction[14:12] == 3'b100) ? `dm_byte_unsigned : `dm_word;
            end
            7'b1100011: begin // B
                RegWrite = 0;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 1;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b01;
                AUIPC = 0;
                LUI =0;
            end
            7'b1100111: begin // JALR
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 1;
                RegDest = 1;
                ALUOp = 2'b00;
                AUIPC = 0;
            end
            7'b1101111: begin // JAL
                RegWrite = 1;
                ALUsrc = 0;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 1;
                Jump = 0;
                RegDest = 1;
                ALUOp = 2'b00;
                AUIPC = 0;
            end
            7'b0010111: begin // AUIPC
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b00;
                AUIPC = 1;
                LUI =0;
            end
            7'b0110111: begin // LUI
                RegWrite = 1;
                ALUsrc = 1;
                MemWrite = 0;
                MemtoReg = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                RegDest = 0;
                ALUOp = 2'b00;
                AUIPC = 0;
                LUI =1;
            end
        endcase
    end
endmodule

