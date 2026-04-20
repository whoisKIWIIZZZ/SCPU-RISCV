
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	10c000ef          	jal	140 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <wait>:
  3c:	fe010113          	addi	sp,sp,-32
  40:	00112e23          	sw	ra,28(sp)
  44:	00812c23          	sw	s0,24(sp)
  48:	02010413          	addi	s0,sp,32
  4c:	fea42623          	sw	a0,-20(s0)
  50:	00000013          	nop
  54:	fec42783          	lw	a5,-20(s0)
  58:	fff78713          	addi	a4,a5,-1
  5c:	fee42623          	sw	a4,-20(s0)
  60:	fe079ae3          	bnez	a5,54 <wait+0x18>
  64:	00000013          	nop
  68:	00000013          	nop
  6c:	01c12083          	lw	ra,28(sp)
  70:	01812403          	lw	s0,24(sp)
  74:	02010113          	addi	sp,sp,32
  78:	00008067          	ret

0000007c <update_keys>:
  7c:	fe010113          	addi	sp,sp,-32
  80:	00112e23          	sw	ra,28(sp)
  84:	00812c23          	sw	s0,24(sp)
  88:	02010413          	addi	s0,sp,32
  8c:	00050793          	mv	a5,a0
  90:	fef41723          	sh	a5,-18(s0)
  94:	fee45683          	lhu	a3,-18(s0)
  98:	c00007b7          	lui	a5,0xc0000
  9c:	00004737          	lui	a4,0x4
  a0:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x2677>
  a4:	00e6f733          	and	a4,a3,a4
  a8:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe678>
  ac:	00000013          	nop
  b0:	01c12083          	lw	ra,28(sp)
  b4:	01812403          	lw	s0,24(sp)
  b8:	02010113          	addi	sp,sp,32
  bc:	00008067          	ret

000000c0 <read_keys_low2>:
  c0:	fe010113          	addi	sp,sp,-32
  c4:	00112e23          	sw	ra,28(sp)
  c8:	00812c23          	sw	s0,24(sp)
  cc:	02010413          	addi	s0,sp,32
  d0:	c00007b7          	lui	a5,0xc0000
  d4:	0007a783          	lw	a5,0(a5) # c0000000 <__global_pointer$+0xbfffe678>
  d8:	fef42623          	sw	a5,-20(s0)
  dc:	fec42783          	lw	a5,-20(s0)
  e0:	0ff7f793          	zext.b	a5,a5
  e4:	0037f793          	andi	a5,a5,3
  e8:	0ff7f793          	zext.b	a5,a5
  ec:	00078513          	mv	a0,a5
  f0:	01c12083          	lw	ra,28(sp)
  f4:	01812403          	lw	s0,24(sp)
  f8:	02010113          	addi	sp,sp,32
  fc:	00008067          	ret

00000100 <write>:
 100:	fd010113          	addi	sp,sp,-48
 104:	02112623          	sw	ra,44(sp)
 108:	02812423          	sw	s0,40(sp)
 10c:	03010413          	addi	s0,sp,48
 110:	fca42e23          	sw	a0,-36(s0)
 114:	fcb42c23          	sw	a1,-40(s0)
 118:	fdc42783          	lw	a5,-36(s0)
 11c:	fef42623          	sw	a5,-20(s0)
 120:	fec42783          	lw	a5,-20(s0)
 124:	fd842703          	lw	a4,-40(s0)
 128:	00e7a023          	sw	a4,0(a5)
 12c:	00000013          	nop
 130:	02c12083          	lw	ra,44(sp)
 134:	02812403          	lw	s0,40(sp)
 138:	03010113          	addi	sp,sp,48
 13c:	00008067          	ret

00000140 <main>:
 140:	fe010113          	addi	sp,sp,-32
 144:	00112e23          	sw	ra,28(sp)
 148:	00812c23          	sw	s0,24(sp)
 14c:	02010413          	addi	s0,sp,32
 150:	fe042623          	sw	zero,-20(s0)
 154:	09100513          	li	a0,145
 158:	f25ff0ef          	jal	7c <update_keys>
 15c:	004c57b7          	lui	a5,0x4c5
 160:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c31b8>
 164:	ed9ff0ef          	jal	3c <wait>
 168:	00000513          	li	a0,0
 16c:	f11ff0ef          	jal	7c <update_keys>
 170:	004c57b7          	lui	a5,0x4c5
 174:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c31b8>
 178:	ec5ff0ef          	jal	3c <wait>
 17c:	12200513          	li	a0,290
 180:	efdff0ef          	jal	7c <update_keys>
 184:	fd1ff06f          	j	154 <main+0x14>
