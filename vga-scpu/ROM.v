`timescale 1ns / 1ps

module ROM(
    input  [29:0]  a,
    output reg [31:0] spo
);

    always @(*) begin
        case(a)
            10'd0 : spo = 32'hff010113;
            10'd1 : spo = 32'h00112623;
            10'd2 : spo = 32'h00812423;
            10'd3 : spo = 32'h01010413;
            10'd4 : spo = 32'h40000113;
            10'd5 : spo = 32'h068000ef;
            10'd6 : spo = 32'h0000006f;
            10'd7 : spo = 32'hfe010113;
            10'd8 : spo = 32'h00112e23;
            10'd9 : spo = 32'h00812c23;
            10'd10 : spo = 32'h00e12a23;
            10'd11 : spo = 32'h00f12823;
            10'd12 : spo = 32'h02010413;
            10'd13 : spo = 32'ha00007b7;
            10'd14 : spo = 32'h00878793;
            10'd15 : spo = 32'hfef42623;
            10'd16 : spo = 32'hfec42783;
            10'd17 : spo = 32'h0007a783;
            10'd18 : spo = 32'hfef405a3;
            10'd19 : spo = 32'he00007b7;
            10'd20 : spo = 32'hfef42223;
            10'd21 : spo = 32'hfeb44703;
            10'd22 : spo = 32'hfe442783;
            10'd23 : spo = 32'h00e7a023;
            10'd24 : spo = 32'h00000013;
            10'd25 : spo = 32'h01c12083;
            10'd26 : spo = 32'h01812403;
            10'd27 : spo = 32'h01412703;
            10'd28 : spo = 32'h01012783;
            10'd29 : spo = 32'h02010113;
            10'd30 : spo = 32'h30200073;
            10'd31 : spo = 32'hfe010113;
            10'd32 : spo = 32'h00112e23;
            10'd33 : spo = 32'h00812c23;
            10'd34 : spo = 32'h02010413;
            10'd35 : spo = 32'he00007b7;
            10'd36 : spo = 32'hfef42623;
            10'd37 : spo = 32'hfec42783;
            10'd38 : spo = 32'h87654737;
            10'd39 : spo = 32'h32170713;
            10'd40 : spo = 32'h00e7a023;
            10'd41 : spo = 32'h0000006f;
            10'd42 : spo = 32'hFFDFF06F;
            // 10'd43 : spo = 32'h7f90006f;
            // 10'd44 : spo = 32'h7f50006f;
            // 10'd45 : spo = 32'h7f10006f;
            // 10'd46 : spo = 32'h7ed0006f;
            default : spo = 32'hFFDFF06F; // NOP
        endcase
    end

endmodule
