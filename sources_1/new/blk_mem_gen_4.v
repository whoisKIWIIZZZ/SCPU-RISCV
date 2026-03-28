module blk_mem_gen_4(
    input clka,
    input [9:0] addra,
    input [31:0] dina,
    input [3:0] wea,
    output reg [31:0] douta
);
    reg [31:0] mem [0:1023];
    
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'h00000000;
        mem[0]  = 32'hf0000000;
        mem[1]  = 32'h000002AB;
        mem[2]  = 32'h80000000;
        mem[3]  = 32'h0000003F;
        mem[4]  = 32'h00000001;
        mem[5]  = 32'hFFF70000;
        mem[6]  = 32'h0000FFFF;
        mem[7]  = 32'h80000000;
        mem[8]  = 32'h00000000;
        mem[9]  = 32'h11111111;
        mem[10] = 32'h22222222;
        mem[11] = 32'h33333333;
        mem[12] = 32'h44444444;
        mem[13] = 32'h55555555;
        mem[14] = 32'h66666666;
        mem[15] = 32'h77777777;
        mem[16] = 32'h88888888;
        mem[17] = 32'h99999999;
        mem[18] = 32'haaaaaaaa;
        mem[19] = 32'hbbbbbbbb;
        mem[20] = 32'hcccccccc;
        mem[21] = 32'hdddddddd;
        mem[22] = 32'heeeeeeee;
        mem[23] = 32'hffffffff;
        mem[24] = 32'h557EF7E0;
        mem[25] = 32'hD7BDFBD9;
        mem[26] = 32'hD7DBFDB9;
        mem[27] = 32'hDFCFFCFB;
        mem[28] = 32'hDFCFBFFF;
        mem[29] = 32'hF7F3DFFF;
        mem[30] = 32'hFFFFDF3D;
        mem[31] = 32'hFFFF9DB9;
        mem[32] = 32'hFFFFBCFB;
        mem[33] = 32'hDFCFFCFB;
        mem[34] = 32'hDFCFBFFF;
        mem[35] = 32'hD7DB9FFF;
        mem[36] = 32'hD7DBFDB9;
        mem[37] = 32'hD7BDFBD9;
        mem[38] = 32'hFFFF07E0;
        mem[39] = 32'h007E0FFF;
        mem[40] = 32'h03bdf020;
        mem[41] = 32'h03def820;
        mem[42] = 32'h08002300;
    end
    
    always @(posedge clka) begin
        if (wea[0]) mem[addra] <= dina;
        douta <= mem[addra];
    end
endmodule