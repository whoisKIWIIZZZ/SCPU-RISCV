`timescale 1ns / 1ps
module tb();

reg  clk, rst;
wire HSYNC, VSYNC;
wire [3:0] R, G, B;

main uut(
    .clk  (clk),
    .rst  (rst),
    .HSYNC(HSYNC),
    .VSYNC(VSYNC),
    .R(R), .G(G), .B(B)
);

initial begin clk=0; forever #5 clk=~clk; end

integer fp;
integer pixel_count;
integer frame_count;
reg [255:0] filename;

// initial begin
//     rst         = 1;
//     frame_count = 0;
//     #200;
//     rst = 0;

//     // 等3帧稳定（一帧约16.8ms=16800000ns）
//    // #50_400_000;

//     // 抓12帧：空棋盘1帧 + 每手棋1帧（共10手）+ 结束1帧
//     repeat(12) begin
//         frame_count = frame_count + 1;
//         pixel_count = 0;

//         @(negedge VSYNC);

//         $sformat(filename, "./frame%04d.ppm", frame_count);
//         fp = $fopen(filename, "w");
//         $fwrite(fp, "P3\n640 480\n15\n");

//         repeat(800*525) begin
//             @(posedge uut.clk25);
//             if(uut.active)
//                 $fwrite(fp, "%0d %0d %0d\n", R, G, B);
//         end

//         $fclose(fp);
//         $display("第%0d帧完成，step=%0d", frame_count, uut.step);

//         // 等60帧（1秒）再抓下一帧
//         repeat(59) @(negedge VSYNC);
//     end

//     $display("全部完成");
//     $finish;
// end

// initial begin
//     #10_000_000_000;
//     $display("超时");
//     $finish;
// end

initial begin
    rst         = 1;
    frame_count = 0;
    #200;
    rst = 0;

    repeat(3) @(negedge VSYNC);

    repeat(15) begin
        frame_count = frame_count + 1;
        pixel_count = 0;

        // 强制设置step，不需要等60帧
        force uut.step = frame_count - 1;

        @(negedge VSYNC);

        $sformat(filename, "./frame%04d.ppm", frame_count);
        fp = $fopen(filename, "w");
        $fwrite(fp, "P3\n640 480\n15\n");

        repeat(800*525) begin
            @(posedge uut.clk25);
            if(uut.active)
                $fwrite(fp, "%0d %0d %0d\n", R, G, B);
        end

        $fclose(fp);
        $display("第%0d帧完成，step=%0d", frame_count, uut.step);
    end

    release uut.step;
    $display("全部完成");
    $finish;
end

// 超时只需要12帧的抓取时间，不需要等待
initial begin
    #3_000_000_000;   // 3秒足够
    $display("超时");
    $finish;
end
endmodule