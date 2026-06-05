  module piano_table (
      input  clk,
      input  [7:0] phase,
      input  [1:0] table_sel_a,
      input  [1:0] table_sel_b,
      output [9:0] sample_a,
      output [9:0] sample_b
  );
      wire [1:0] ts_a = (table_sel_a == 2'd3) ? 2'd0 : table_sel_a;
      wire [1:0] ts_b = (table_sel_b == 2'd3) ? 2'd0 : table_sel_b;
      wire [9:0] addr_a = {ts_a, phase};
      wire [9:0] addr_b = {ts_b, phase};

      wire [15:0] douta, doutb;

      piano_rom u_rom (
          .clka  (clk),
          .addra (addr_a),
          .douta (douta),
          .clkb  (clk),
          .addrb (addr_b),
          .doutb (doutb)
      );

      assign sample_a = douta[9:0];
      assign sample_b = doutb[9:0];
  endmodule