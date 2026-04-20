module font_rom(
    input  [9:0]  a,          // ★ 修正: 10位地址 = 128字符×8行 = 1024深度
    output reg [7:0] spo      // ★ 修正: 8位输出 = 8像素宽的字模行
);

    // 定义字体ROM数组: 1024个条目 × 8位
    reg [7:0] font_mem [0:1023];
    
    // ★ 仿真时初始化: 读取十六进制.dat文件
    initial begin
        $readmemh("font_ascii.dat", font_mem);
    end
    
    // 同步读输出
    always @(posedge a) begin  // 或总是组合逻辑: always @(*)
        spo <= font_mem[a];
    end

endmodule