# SCPU-Pipeline
基本流水线架构的CPU.

# 怎么测试中断?(3.31 Ver)
在你的testac.coe最后加上如下代码:
```asm
addi x2,  x2,  -8      
sw   x5,  4(x2)        
sw   x6,  0(x2)        
lui  x5,  0x0           
addi x5,  x5,  0x500   
lw   x6,  0(x5)         # x6 = mem[0x500]
addi x6,  x6,  1        
sw   x6,  0(x5)         # mem[0x500] = x6
lw   x6,  0(x2)
lw   x5,  4(x2)
addi x2,  x2,  8       
mret       
```
机器码如下:
```asm
ff810113
00512223
00612023
000002b7
50028293
0002a303
00130313
0062a023
00012303
00412283
00810113
30200073
```
中断服务程序在0xa78,执行的就是上面的代码.`RAM[0x500]`存放的是中断的执行次数.
## Hint
如果你使用*Icarus Verilog*,那么你需要解决`Counter`模块对中断带来的BUG.在一个always块里写:
```verilog
force uut.U9_Counter_x.counter0_OUT = 1'b0;  // 强制counter不触发
```
或者,如果你的计时器中断正确写好了,你也得写这个:
```verilog
force uut.U9_Counter_x.counter_ch = 2'b0;//这个channel被SPIO驱动了,我们没有办法在仿真里验证.同时,代码里不能有对counter赋值的语句
```
# TIMELINE-BACKUP
- 3.27 验收了单周期CPU
- 发现在连续的JAL指令会出现bug,原因出自跳转确认被放置在了EX/MEM阶段.解决办法是在ID/EX特判一下JAL(没错,我单周期判断JAL是通过branch & RegDest的信号判断的而不是单独传一个JAL信号)
- 发现在第六关会出现JALR跳转错误的bug,导致第六关被运行了多次.原因是没有处理lw和jalr存在的冒险,忘记写旁路了.解决办法是
```verilog
assign jump_target = (ID_EX_rd1 + ID_EX_imm) & ~32'b1;//old
assign jump_target = (forward_A_val + ID_EX_imm) & ~32'b1;//new
```
- 3.28 成功实现流水线并PUSH.
- 3.30 实现了在Mac上跑*Icarus Verilog*仿真,不需要vivado那么冗长的仿真步骤了.具体操作:替换`blk_mem_gen_4`和`dist_mem_gen_2`为.v文件,并运行`iverilog -o sim.out *.v && vvp sim.out`.
- 3.30 增加了2bit(不带BTB的)动态预测.预测正确率:hit=46664 miss=11550 rate=80%
- 3.31 增加了中断(maybe???)
- 4.4 实现了`RISCV-GNU-TOOLS`工具链的安装,开始自己写代码汇编
- 4.7 实现了VGA模块和PS2模块(也许).

# Acknowledge
- thx [Zoomy](https://github.com/zoomy14112/SingleCPU)

- thx [337](https://yisz.top)