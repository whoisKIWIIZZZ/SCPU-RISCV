`timescale 1ns / 1ps

// =============================================================================
// sine.v — Quarter-wave symmetric sine ROM LUT
// =============================================================================
//   8-bit phase in, 6-bit unsigned sine out (0~63, centered at 32)
//   64-entry quarter-wave table × 4 quadrants = 256 effective entries
//   Resource: ~6 LUT6 per instance
// =============================================================================

module sine_lut (
    input  [7:0] phase,
    output [5:0] sine_out
);

    // quarter-wave table: 64 entries, amplitude 0~31
    // qtable[i] = round(31 * sin(pi/2 * i/64))
    reg [5:0] qtable [0:63];

    // quadrant: phase[7:6]
    // Q0 (00): forward addr,  32 + qval  (rising  0 -> pi/2)
    // Q1 (01): reverse addr,  32 + qval  (falling pi/2 -> pi)
    // Q2 (10): forward addr,  32 - qval  (falling pi -> 3pi/2)
    // Q3 (11): reverse addr,  32 - qval  (rising  3pi/2 -> 2pi)

    wire [1:0] quadrant = phase[7:6];
    wire [5:0] addr = quadrant[0] ? ~phase[5:0] : phase[5:0];
    wire [5:0] qval = qtable[addr];
    wire [6:0] sum  = {1'b0, 6'd32} + {1'b0, qval};
    wire [6:0] diff = {1'b0, 6'd32} - {1'b0, qval};

    assign sine_out = quadrant[1] ? diff[5:0] : sum[5:0];

    // LUT initialization
    integer i;
    initial begin
        qtable[ 0] = 6'd 0; qtable[ 1] = 6'd 1; qtable[ 2] = 6'd 2; qtable[ 3] = 6'd 2;
        qtable[ 4] = 6'd 3; qtable[ 5] = 6'd 4; qtable[ 6] = 6'd 5; qtable[ 7] = 6'd 5;
        qtable[ 8] = 6'd 6; qtable[ 9] = 6'd 7; qtable[10] = 6'd 8; qtable[11] = 6'd 8;
        qtable[12] = 6'd 9; qtable[13] = 6'd10; qtable[14] = 6'd10; qtable[15] = 6'd11;
        qtable[16] = 6'd12; qtable[17] = 6'd13; qtable[18] = 6'd13; qtable[19] = 6'd14;
        qtable[20] = 6'd15; qtable[21] = 6'd15; qtable[22] = 6'd16; qtable[23] = 6'd17;
        qtable[24] = 6'd17; qtable[25] = 6'd18; qtable[26] = 6'd18; qtable[27] = 6'd19;
        qtable[28] = 6'd20; qtable[29] = 6'd20; qtable[30] = 6'd21; qtable[31] = 6'd21;
        qtable[32] = 6'd22; qtable[33] = 6'd22; qtable[34] = 6'd23; qtable[35] = 6'd23;
        qtable[36] = 6'd24; qtable[37] = 6'd24; qtable[38] = 6'd25; qtable[39] = 6'd25;
        qtable[40] = 6'd26; qtable[41] = 6'd26; qtable[42] = 6'd27; qtable[43] = 6'd27;
        qtable[44] = 6'd27; qtable[45] = 6'd28; qtable[46] = 6'd28; qtable[47] = 6'd28;
        qtable[48] = 6'd29; qtable[49] = 6'd29; qtable[50] = 6'd29; qtable[51] = 6'd29;
        qtable[52] = 6'd30; qtable[53] = 6'd30; qtable[54] = 6'd30; qtable[55] = 6'd30;
        qtable[56] = 6'd30; qtable[57] = 6'd31; qtable[58] = 6'd31; qtable[59] = 6'd31;
        qtable[60] = 6'd31; qtable[61] = 6'd31; qtable[62] = 6'd31; qtable[63] = 6'd31;
    end

endmodule
