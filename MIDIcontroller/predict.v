`timescale 1ns / 1ps
module predict(
    input         clk,
    input         reset,
    input  [31:0] ID_EX_PC,      
    input         EX_wea,      
    input  [31:0] IF_ID_PC,     
    input         EX_jump,   
    output        predict_jump 
);
//2bit
reg [1:0] counter [0:63];
wire [5:0] lookup_idx = IF_ID_PC[7:2];   
assign predict_jump = counter[lookup_idx][1];  

wire [5:0] update_idx = ID_EX_PC[7:2];

integer i;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 64; i = i + 1)
            counter[i] <= 2'b01;    // 复位为弱不跳转
    end
    else if (EX_wea) begin
        if (EX_jump) begin
            if (counter[update_idx] != 2'b11)
                counter[update_idx] <= counter[update_idx] + 1;
        end
        else begin
            if (counter[update_idx] != 2'b00)
                counter[update_idx] <= counter[update_idx] - 1;
        end
    end
end

endmodule