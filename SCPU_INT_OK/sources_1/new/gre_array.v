module GRE_array #(parameter WIDTH=100)(
    input clk,rst,write_enable,flush,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 0;
    end else if (flush) begin
        out <= 0;
    end else if (write_enable) begin
        out <= in;
    end
end
endmodule