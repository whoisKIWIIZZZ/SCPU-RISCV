`timescale 1ns / 1ps

// =============================================================================
// lpf.v — First-order IIR lowpass filter (full-precision feedback)
// =============================================================================
//   Fixed-point format: 27-bit signed, 16 fractional bits (Q11.16)
//   y[n] = y[n-1] + (2^cutoff / 2^16) * (x[n] - y[n-1])
//   Full-precision diff avoids deadband/limit-cycle at extreme oversampling.
//
//   f_c ≈ f_clk * 2^cutoff / (2π * 2^16)
//   cutoff=0: ~243Hz, cutoff=4: ~3.9kHz, cutoff=8: ~62kHz, cutoff=15: ~8MHz
//   cutoff>=16: bypass
// =============================================================================

module lpf (
    input             clk,
    input             rst,
    input      [9:0]  audio_in,
    input      [4:0]  cutoff_val,
    output     [9:0]  audio_out
);

    // ---- full-precision state: audio_in scaled by 2^16 ----
    // format: 27-bit signed, 16 fractional bits
    // max positive value: 1023 * 65536 = 67,043,328 (safe under 2^26-1)
    reg signed [26:0] y;

    // input in same fixed-point format: {sign, audio_in, 16'd0}
    wire signed [26:0] x_scaled = {1'b0, audio_in, 16'd0};

    // full-precision error (no truncation → no deadband)
    wire signed [27:0] diff = x_scaled - y;

    // update = diff * (2^cutoff / 2^16) = diff >>> (16 - cutoff)
    wire [4:0] shift = 5'd16 - cutoff_val;
    wire signed [26:0] update = diff >>> shift;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 27'd0;
        end else if (cutoff_val >= 5'd16) begin
            y <= x_scaled;
        end else begin
            y <= y + update;
        end
    end

    // extract integer part for 10-bit unsigned output
    assign audio_out = (y[26]) ? 10'd0 : y[25:16];

endmodule
