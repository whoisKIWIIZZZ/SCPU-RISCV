`timescale 1ns / 1ps
module VGA_Scan(input clk, rst,
                output[8:0]row,
                output[9:0]col,
                output Active,
                output reg HSYNC,
                output reg VSYNC
                );

reg[9:0]HCount;
reg[9:0]VCount;
reg HActive=0, VActive=0;

localparam HSC=10'd95, HBP=10'd143, HACT=10'd783, HFP=10'd799;
always@(posedge clk or posedge rst) begin
    if(rst)begin HCount<=0; HSYNC<=0; HActive<=0; end
    else begin
        HCount <= HCount + 10'h1;
        case(HCount)
            HSC:  HSYNC   <= 1;
            HBP:  HActive <= 1;
            HACT: HActive <= 0;
            HFP:  begin HCount<=10'h0; HSYNC<=0; end
            default: ;
        endcase
    end
end

localparam VSC=10'd1, VBP=10'd35, VACT=10'd515, VFP=10'd524;
always@(posedge clk or posedge rst) begin
    if(rst)begin VCount<=0; VSYNC<=0; VActive<=0; end
    else begin
        if(HCount==10'd799)begin
            if(VCount==10'd524) VCount<=10'h0;
            else VCount<=VCount+10'h1;
            case(VCount)
                VSC:  VSYNC   <= 1;
                VBP:  VActive <= 1;
                VACT: VActive <= 0;
                VFP:  VSYNC   <= 0;
                default: ;
            endcase
        end
    end
end

assign Active = HActive & VActive;
assign col    = HCount - 10'd144;
assign row    = VCount - 10'd36;

endmodule