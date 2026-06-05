`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/21 09:00:37
// Design Name: 
// Module Name: alu
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


module alu(
    input signed [31:0] A, B,
    input [3:0] ALUOp,
    output reg signed [31:0] C,
    output reg Zero, Neg, Of, Cy
);

    always @(*) begin

        C = 32'd0;
        Zero = 1'b0;
        Neg = 1'b0;
        Of = 1'b0;
        Cy = 1'b0;

        case(ALUOp)
            4'b0000: begin // ADD
                C = A + B;
                Of = (A[31] == B[31]) && (C[31] != A[31]);
                Cy = (C < A);
            end
            4'b0001: begin 
                C = A - B;
                Of = (A[31] != B[31]) && (C[31] != A[31]);
                Cy = (($unsigned(A) < $unsigned(B)));
            end
            4'b0010: C = A & B;          
            4'b0011: C = A | B;          
            4'b0100: C = A ^ B;          
            4'b0101: C = A << B;         
            4'b0110: C = A >> B;         
            4'b0111: C = A >>> B;        
            default: C = 32'd0;
        endcase

        Zero = (C == 32'd0);
        Neg = C[31];
    end

endmodule     