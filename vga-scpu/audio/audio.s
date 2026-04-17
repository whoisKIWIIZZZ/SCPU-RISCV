
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	170000ef          	jal	1a4 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <delay>:
  3c:	fe010113          	addi	sp,sp,-32
  40:	00112e23          	sw	ra,28(sp)
  44:	00812c23          	sw	s0,24(sp)
  48:	02010413          	addi	s0,sp,32
  4c:	fea42623          	sw	a0,-20(s0)
  50:	0080006f          	j	58 <delay+0x1c>
  54:	00000013          	nop
  58:	fec42783          	lw	a5,-20(s0)
  5c:	fff78713          	addi	a4,a5,-1
  60:	fee42623          	sw	a4,-20(s0)
  64:	fe0798e3          	bnez	a5,54 <delay+0x18>
  68:	00000013          	nop
  6c:	00000013          	nop
  70:	01c12083          	lw	ra,28(sp)
  74:	01812403          	lw	s0,24(sp)
  78:	02010113          	addi	sp,sp,32
  7c:	00008067          	ret

00000080 <song>:
  80:	ff010113          	addi	sp,sp,-16
  84:	00112623          	sw	ra,12(sp)
  88:	00812423          	sw	s0,8(sp)
  8c:	01010413          	addi	s0,sp,16
  90:	b00007b7          	lui	a5,0xb0000
  94:	00478793          	addi	a5,a5,4 # b0000004 <__global_pointer$+0xafffe638>
  98:	00003737          	lui	a4,0x3
  9c:	be470713          	addi	a4,a4,-1052 # 2be4 <__global_pointer$+0x1218>
  a0:	00e7a023          	sw	a4,0(a5)
  a4:	b00007b7          	lui	a5,0xb0000
  a8:	00c78793          	addi	a5,a5,12 # b000000c <__global_pointer$+0xafffe640>
  ac:	00003737          	lui	a4,0x3
  b0:	74d70713          	addi	a4,a4,1869 # 374d <__global_pointer$+0x1d81>
  b4:	00e7a023          	sw	a4,0(a5)
  b8:	b00007b7          	lui	a5,0xb0000
  bc:	01478793          	addi	a5,a5,20 # b0000014 <__global_pointer$+0xafffe648>
  c0:	00004737          	lui	a4,0x4
  c4:	1c470713          	addi	a4,a4,452 # 41c4 <__global_pointer$+0x27f8>
  c8:	00e7a023          	sw	a4,0(a5)
  cc:	b00007b7          	lui	a5,0xb0000
  d0:	01c78793          	addi	a5,a5,28 # b000001c <__global_pointer$+0xafffe650>
  d4:	00005737          	lui	a4,0x5
  d8:	2dc70713          	addi	a4,a4,732 # 52dc <__global_pointer$+0x3910>
  dc:	00e7a023          	sw	a4,0(a5)
  e0:	b00007b7          	lui	a5,0xb0000
  e4:	02478793          	addi	a5,a5,36 # b0000024 <__global_pointer$+0xafffe658>
  e8:	00006737          	lui	a4,0x6
  ec:	28770713          	addi	a4,a4,647 # 6287 <__global_pointer$+0x48bb>
  f0:	00e7a023          	sw	a4,0(a5)
  f4:	b00007b7          	lui	a5,0xb0000
  f8:	00100713          	li	a4,1
  fc:	00e7a023          	sw	a4,0(a5) # b0000000 <__global_pointer$+0xafffe634>
 100:	b00007b7          	lui	a5,0xb0000
 104:	00878793          	addi	a5,a5,8 # b0000008 <__global_pointer$+0xafffe63c>
 108:	00100713          	li	a4,1
 10c:	00e7a023          	sw	a4,0(a5)
 110:	b00007b7          	lui	a5,0xb0000
 114:	01078793          	addi	a5,a5,16 # b0000010 <__global_pointer$+0xafffe644>
 118:	00100713          	li	a4,1
 11c:	00e7a023          	sw	a4,0(a5)
 120:	b00007b7          	lui	a5,0xb0000
 124:	01878793          	addi	a5,a5,24 # b0000018 <__global_pointer$+0xafffe64c>
 128:	00100713          	li	a4,1
 12c:	00e7a023          	sw	a4,0(a5)
 130:	b00007b7          	lui	a5,0xb0000
 134:	02078793          	addi	a5,a5,32 # b0000020 <__global_pointer$+0xafffe654>
 138:	00100713          	li	a4,1
 13c:	00e7a023          	sw	a4,0(a5)
 140:	000f47b7          	lui	a5,0xf4
 144:	24078513          	addi	a0,a5,576 # f4240 <__global_pointer$+0xf2874>
 148:	ef5ff0ef          	jal	3c <delay>
 14c:	b00007b7          	lui	a5,0xb0000
 150:	0007a023          	sw	zero,0(a5) # b0000000 <__global_pointer$+0xafffe634>
 154:	b00007b7          	lui	a5,0xb0000
 158:	00878793          	addi	a5,a5,8 # b0000008 <__global_pointer$+0xafffe63c>
 15c:	0007a023          	sw	zero,0(a5)
 160:	b00007b7          	lui	a5,0xb0000
 164:	01078793          	addi	a5,a5,16 # b0000010 <__global_pointer$+0xafffe644>
 168:	0007a023          	sw	zero,0(a5)
 16c:	b00007b7          	lui	a5,0xb0000
 170:	01878793          	addi	a5,a5,24 # b0000018 <__global_pointer$+0xafffe64c>
 174:	0007a023          	sw	zero,0(a5)
 178:	b00007b7          	lui	a5,0xb0000
 17c:	02078793          	addi	a5,a5,32 # b0000020 <__global_pointer$+0xafffe654>
 180:	0007a023          	sw	zero,0(a5)
 184:	0007a7b7          	lui	a5,0x7a
 188:	12078513          	addi	a0,a5,288 # 7a120 <__global_pointer$+0x78754>
 18c:	eb1ff0ef          	jal	3c <delay>
 190:	00000013          	nop
 194:	00c12083          	lw	ra,12(sp)
 198:	00812403          	lw	s0,8(sp)
 19c:	01010113          	addi	sp,sp,16
 1a0:	00008067          	ret

000001a4 <main>:
 1a4:	ff010113          	addi	sp,sp,-16
 1a8:	00112623          	sw	ra,12(sp)
 1ac:	00812423          	sw	s0,8(sp)
 1b0:	01010413          	addi	s0,sp,16
 1b4:	b00007b7          	lui	a5,0xb0000
 1b8:	05478793          	addi	a5,a5,84 # b0000054 <__global_pointer$+0xafffe688>
 1bc:	00800713          	li	a4,8
 1c0:	00e7a023          	sw	a4,0(a5)
 1c4:	ebdff0ef          	jal	80 <song>
 1c8:	ffdff06f          	j	1c4 <main+0x20>
