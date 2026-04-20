import re

def coe_to_verilog(coe_filename, v_filename):
    try:
        with open(coe_filename, 'r') as f:
            content = f.read()

        # 使用正则匹配所有的 8 位 16 进制字符
        # 考虑到 coe 可能包含 "memory_initialization_vector=" 等表头，我们只提取 8 位 16 进制数
        hex_data = re.findall(r'[0-9a-fA-F]{8}', content)

        with open(v_filename, 'w') as f:
            # 写入文件头
            f.write("`timescale 1ns / 1ps\n\n")
            f.write("module ROM(\n")
            f.write("    input  [9:0]  a,\n")
            f.write("    output reg [31:0] spo\n")
            f.write(");\n\n")
            
            f.write("    always @(*) begin\n")
            f.write("        case(a)\n")

            # 遍历数据并生成 case 语句
            for i, data in enumerate(hex_data):
                # a 为地址索引，对应 PC = 4i
                f.write(f"            10'd{i} : spo = 32'h{data.lower()};\n")

            # 默认情况（NOP 或 0）
            f.write("            default : spo = 32'h00000013; // NOP\n")
            f.write("        endcase\n")
            f.write("    end\n\n")
            f.write("endmodule\n")

        print(f"成功！Verilog 文件已生成: {v_filename}")
        print(f"共处理指令数: {len(hex_data)}")

    except FileNotFoundError:
        print("错误：找不到指定的 .coe 文件。")

# 执行转换
coe_to_verilog('./audio/ysz.coe', './ROM.v')