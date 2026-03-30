`timescale 1ns/1ps
module simulate();
reg clk;
reg rstn;
reg [4:0] btn_i;
reg [15:0] sw_i;
wire [15:0] led_o;
wire [7:0] disp_an_o;
wire [7:0] disp_seg_o;
main uut(
        .btn_i(btn_i),
        .clk(clk),
        .sw_i(sw_i),
        .rstn(rstn),
        .led_o(led_o),
        .disp_an_o(disp_an_o),
        .disp_seg_o(disp_seg_o)
    );
initial begin
        clk=0;
forever #5 clk=~clk;
end
integer i;
integer cycles;
integer displayFlag;
integer ending;
integer StartTimes;

// ===== 新增 =====
integer predict_hit;
integer predict_miss;
// ================

initial begin
        btn_i=5'b0;
        sw_i=16'b0;
        displayFlag=0;
        StartTimes=0;
        ending=0;
        rstn=0;

        // ===== 新增 =====
        predict_hit=0;
        predict_miss=0;
        // ================

#100;
        rstn=1;
        cycles=50000000;
for(i=0;i<cycles;i=i+1)
begin
#10;
if(uut.PC_out==32'h00000218)
begin
#500
$display("Simulation terminated at PC: 0x%h", uut.PC_out);
$finish;
end
else if(ending)
begin
#100
$display("Simulation ended normally");
$finish;
end
end
$display("Simulation Finished.");
$finish;
end
always @(posedge uut.Clk_CPU)
begin
    // ===== 新增：命中率统计 =====
    if(uut.U1_SCPU.ID_EX_Branch) begin
        if(uut.U1_SCPU.mispredicted)
            predict_miss = predict_miss + 1;
        else
            predict_hit = predict_hit + 1;
    end
    // ============================

if(displayFlag)
$display(
"PC: 0x%h | x1: 0x%h,x2: 0x%h,x10:0x%h, x14:0x%h,x15:0x%h,pcstall=0x%h",
                uut.U1_SCPU.ID_EX_PC,
                uut.U1_SCPU.u_rf.rf[1],
                uut.U1_SCPU.u_rf.rf[2],
                uut.U1_SCPU.u_rf.rf[10],
                uut.U1_SCPU.u_rf.rf[14],
                uut.U1_SCPU.u_rf.rf[15],
                uut.U1_SCPU.pc_stall
            );
if(uut.PC_out==32'h00000248)
$display("jump into Section 1.");
if(uut.PC_out==32'h000002d8)
$display("jump into Section 2.");
if(uut.PC_out==32'h00000420)
$display("jump into Section 3.");
if(uut.PC_out==32'h00000494)
$display("jump into Section 4.");
if(uut.PC_out==32'h00000658)
$display("jump into Section 5.");
if(uut.PC_out==32'h00000a24) begin
$display("jump into Section 6.");
end
if(uut.PC_out==32'h0000008c)
begin
    $display("Congratulations! All sections passed.");

    // ===== 新增：打印命中率 =====
    $display("[PREDICT STAT] hit=%0d miss=%0d rate=%0d%%",
        predict_hit,
        predict_miss,
        (predict_hit + predict_miss > 0) ?
            predict_hit * 100 / (predict_hit + predict_miss) : 0
    );
    // ============================

    ending=1;
end
end
endmodule