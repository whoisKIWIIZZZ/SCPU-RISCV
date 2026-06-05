#!/usr/bin/env python3
"""
coe2dat.py — 将 Xilinx COE 文件转换为 DAT 文件

COE 格式示例:
    memory_initialization_radix=16;
    memory_initialization_vector=
    DEAD, BEEF,
    1234, 5678;

DAT 输出格式（每行一个十六进制值，不带前缀）:
    DEAD
    BEEF
    1234
    5678

用法:
    python coe2dat.py input.coe output.dat
    python coe2dat.py input.coe            # 输出到 input.dat
"""

import sys
import re
from pathlib import Path


def parse_coe(coe_text: str) -> tuple[int, list[str]]:
    """解析 COE 文件，返回 (进制, 数值字符串列表)"""

    # 去掉注释（; 之前如果是行注释用 -- 或 // 开头的行）
    lines = []
    for line in coe_text.splitlines():
        stripped = line.strip()
        if stripped.startswith("--") or stripped.startswith("//"):
            continue
        lines.append(stripped)
    text = " ".join(lines)

    # 解析 radix
    radix_match = re.search(r"memory_initialization_radix\s*=\s*(\d+)\s*;", text, re.IGNORECASE)
    if not radix_match:
        raise ValueError("未找到 memory_initialization_radix 字段")
    radix = int(radix_match.group(1))
    if radix not in (2, 8, 10, 16):
        raise ValueError(f"不支持的进制: {radix}")

    # 解析 vector 数据块
    vec_match = re.search(r"memory_initialization_vector\s*=\s*(.*?)\s*;", text, re.IGNORECASE | re.DOTALL)
    if not vec_match:
        raise ValueError("未找到 memory_initialization_vector 字段")

    raw_values = vec_match.group(1)
    # 以逗号或空白分割，过滤空字符串
    values = [v.strip() for v in re.split(r"[,\s]+", raw_values) if v.strip()]

    return radix, values


def convert_to_hex(values: list[str], radix: int) -> list[str]:
    """将任意进制字符串列表转换为大写十六进制字符串列表，保留前导零"""
    if radix == 16:
        # 直接用原始字符串推算位宽，保留前导零
        width = max(len(v) for v in values)
        hex_values = []
        for v in values:
            num = int(v, 16)
            hex_values.append(format(num, f"0{width}X"))
    else:
        # 非16进制：先转换，再按最大值位宽对齐
        nums = [int(v, radix) for v in values]
        max_num = max(nums) if nums else 0
        # 计算需要几位十六进制
        width = max(len(format(max_num, "X")), 1)
        hex_values = [format(n, f"0{width}X") for n in nums]
    return hex_values


def coe_to_dat(input_path: str, output_path: str | None = None) -> Path:
    input_file = Path(input_path)
    if not input_file.exists():
        raise FileNotFoundError(f"找不到输入文件: {input_path}")

    if output_path is None:
        output_file = input_file.with_suffix(".dat")
    else:
        output_file = Path(output_path)

    coe_text = input_file.read_text(encoding="utf-8", errors="replace")

    radix, values = parse_coe(coe_text)
    print(f"  进制: {radix}")
    print(f"  数据条数: {len(values)}")

    hex_values = convert_to_hex(values, radix)

    output_file.write_text("\n".join(hex_values) + "\n", encoding="utf-8")
    print(f"  已写入: {output_file}  ({len(hex_values)} 行)")
    return output_file


def main():
    if len(sys.argv) < 2:
        print("用法: python coe2dat.py <input.coe> [output.dat]")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) >= 3 else None

    try:
        result = coe_to_dat(input_path, output_path)
        print(f"转换成功 → {result}")
    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()