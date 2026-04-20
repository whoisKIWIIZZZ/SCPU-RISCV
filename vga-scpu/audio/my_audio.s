
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	304000ef          	jal	338 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <handler>:
  3c:	f9010113          	addi	sp,sp,-112
  40:	06112623          	sw	ra,108(sp)
  44:	06512423          	sw	t0,104(sp)
  48:	06612223          	sw	t1,100(sp)
  4c:	06712023          	sw	t2,96(sp)
  50:	04812e23          	sw	s0,92(sp)
  54:	04a12c23          	sw	a0,88(sp)
  58:	04b12a23          	sw	a1,84(sp)
  5c:	04c12823          	sw	a2,80(sp)
  60:	04d12623          	sw	a3,76(sp)
  64:	04e12423          	sw	a4,72(sp)
  68:	04f12223          	sw	a5,68(sp)
  6c:	05012023          	sw	a6,64(sp)
  70:	03112e23          	sw	a7,60(sp)
  74:	03c12c23          	sw	t3,56(sp)
  78:	03d12a23          	sw	t4,52(sp)
  7c:	03e12823          	sw	t5,48(sp)
  80:	03f12623          	sw	t6,44(sp)
  84:	07010413          	addi	s0,sp,112
  88:	0a000793          	li	a5,160
  8c:	0007d783          	lhu	a5,0(a5)
  90:	faf41723          	sh	a5,-82(s0)
  94:	a00007b7          	lui	a5,0xa0000
  98:	faf42023          	sw	a5,-96(s0)
  9c:	fa042783          	lw	a5,-96(s0)
  a0:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffe4a6>
  a4:	f8f40fa3          	sb	a5,-97(s0)
  a8:	f9f44703          	lbu	a4,-97(s0)
  ac:	0f000793          	li	a5,240
  b0:	00f71a63          	bne	a4,a5,c4 <handler+0x88>
  b4:	08000793          	li	a5,128
  b8:	00100713          	li	a4,1
  bc:	00e78023          	sb	a4,0(a5)
  c0:	0e40006f          	j	1a4 <handler+0x168>
  c4:	e00007b7          	lui	a5,0xe0000
  c8:	f8f42c23          	sw	a5,-104(s0)
  cc:	f9f44703          	lbu	a4,-97(s0)
  d0:	f9842783          	lw	a5,-104(s0)
  d4:	00e7a023          	sw	a4,0(a5) # e0000000 <__global_pointer$+0xdfffe4a6>
  d8:	fff00793          	li	a5,-1
  dc:	faf42423          	sw	a5,-88(s0)
  e0:	fa042223          	sw	zero,-92(s0)
  e4:	0340006f          	j	118 <handler+0xdc>
  e8:	34c00713          	li	a4,844
  ec:	fa442783          	lw	a5,-92(s0)
  f0:	00f707b3          	add	a5,a4,a5
  f4:	0007c783          	lbu	a5,0(a5)
  f8:	f9f44703          	lbu	a4,-97(s0)
  fc:	00f71863          	bne	a4,a5,10c <handler+0xd0>
 100:	fa442783          	lw	a5,-92(s0)
 104:	faf42423          	sw	a5,-88(s0)
 108:	01c0006f          	j	124 <handler+0xe8>
 10c:	fa442783          	lw	a5,-92(s0)
 110:	00178793          	addi	a5,a5,1
 114:	faf42223          	sw	a5,-92(s0)
 118:	fa442703          	lw	a4,-92(s0)
 11c:	00d00793          	li	a5,13
 120:	fce7d4e3          	bge	a5,a4,e8 <handler+0xac>
 124:	fa842703          	lw	a4,-88(s0)
 128:	fff00793          	li	a5,-1
 12c:	06f70263          	beq	a4,a5,190 <handler+0x154>
 130:	08000793          	li	a5,128
 134:	0007c783          	lbu	a5,0(a5)
 138:	0ff7f793          	zext.b	a5,a5
 13c:	02078a63          	beqz	a5,170 <handler+0x134>
 140:	fa842783          	lw	a5,-88(s0)
 144:	00100713          	li	a4,1
 148:	00f717b3          	sll	a5,a4,a5
 14c:	01079793          	slli	a5,a5,0x10
 150:	0107d793          	srli	a5,a5,0x10
 154:	fff7c793          	not	a5,a5
 158:	01079793          	slli	a5,a5,0x10
 15c:	0107d793          	srli	a5,a5,0x10
 160:	fae45703          	lhu	a4,-82(s0)
 164:	00e7f7b3          	and	a5,a5,a4
 168:	faf41723          	sh	a5,-82(s0)
 16c:	0240006f          	j	190 <handler+0x154>
 170:	fa842783          	lw	a5,-88(s0)
 174:	00100713          	li	a4,1
 178:	00f717b3          	sll	a5,a4,a5
 17c:	01079793          	slli	a5,a5,0x10
 180:	0107d793          	srli	a5,a5,0x10
 184:	fae45703          	lhu	a4,-82(s0)
 188:	00e7e7b3          	or	a5,a5,a4
 18c:	faf41723          	sh	a5,-82(s0)
 190:	08000793          	li	a5,128
 194:	00078023          	sb	zero,0(a5)
 198:	fae45783          	lhu	a5,-82(s0)
 19c:	00078513          	mv	a0,a5
 1a0:	090000ef          	jal	230 <update_keys>
 1a4:	06c12083          	lw	ra,108(sp)
 1a8:	06812283          	lw	t0,104(sp)
 1ac:	06412303          	lw	t1,100(sp)
 1b0:	06012383          	lw	t2,96(sp)
 1b4:	05c12403          	lw	s0,92(sp)
 1b8:	05812503          	lw	a0,88(sp)
 1bc:	05412583          	lw	a1,84(sp)
 1c0:	05012603          	lw	a2,80(sp)
 1c4:	04c12683          	lw	a3,76(sp)
 1c8:	04812703          	lw	a4,72(sp)
 1cc:	04412783          	lw	a5,68(sp)
 1d0:	04012803          	lw	a6,64(sp)
 1d4:	03c12883          	lw	a7,60(sp)
 1d8:	03812e03          	lw	t3,56(sp)
 1dc:	03412e83          	lw	t4,52(sp)
 1e0:	03012f03          	lw	t5,48(sp)
 1e4:	02c12f83          	lw	t6,44(sp)
 1e8:	07010113          	addi	sp,sp,112
 1ec:	30200073          	mret

000001f0 <wait>:
 1f0:	fe010113          	addi	sp,sp,-32
 1f4:	00112e23          	sw	ra,28(sp)
 1f8:	00812c23          	sw	s0,24(sp)
 1fc:	02010413          	addi	s0,sp,32
 200:	fea42623          	sw	a0,-20(s0)
 204:	00000013          	nop
 208:	fec42783          	lw	a5,-20(s0)
 20c:	fff78713          	addi	a4,a5,-1
 210:	fee42623          	sw	a4,-20(s0)
 214:	fe079ae3          	bnez	a5,208 <wait+0x18>
 218:	00000013          	nop
 21c:	00000013          	nop
 220:	01c12083          	lw	ra,28(sp)
 224:	01812403          	lw	s0,24(sp)
 228:	02010113          	addi	sp,sp,32
 22c:	00008067          	ret

00000230 <update_keys>:
 230:	fe010113          	addi	sp,sp,-32
 234:	00112e23          	sw	ra,28(sp)
 238:	00812c23          	sw	s0,24(sp)
 23c:	02010413          	addi	s0,sp,32
 240:	00050793          	mv	a5,a0
 244:	fef41723          	sh	a5,-18(s0)
 248:	fee45683          	lhu	a3,-18(s0)
 24c:	c00007b7          	lui	a5,0xc0000
 250:	00004737          	lui	a4,0x4
 254:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x24a5>
 258:	00e6f733          	and	a4,a3,a4
 25c:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe4a6>
 260:	00000013          	nop
 264:	01c12083          	lw	ra,28(sp)
 268:	01812403          	lw	s0,24(sp)
 26c:	02010113          	addi	sp,sp,32
 270:	00008067          	ret

00000274 <read_keys_low2>:
 274:	fe010113          	addi	sp,sp,-32
 278:	00112e23          	sw	ra,28(sp)
 27c:	00812c23          	sw	s0,24(sp)
 280:	02010413          	addi	s0,sp,32
 284:	c00007b7          	lui	a5,0xc0000
 288:	0007a783          	lw	a5,0(a5) # c0000000 <__global_pointer$+0xbfffe4a6>
 28c:	fef42623          	sw	a5,-20(s0)
 290:	fec42783          	lw	a5,-20(s0)
 294:	0ff7f793          	zext.b	a5,a5
 298:	0037f793          	andi	a5,a5,3
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	00078513          	mv	a0,a5
 2a4:	01c12083          	lw	ra,28(sp)
 2a8:	01812403          	lw	s0,24(sp)
 2ac:	02010113          	addi	sp,sp,32
 2b0:	00008067          	ret

000002b4 <write>:
 2b4:	fd010113          	addi	sp,sp,-48
 2b8:	02112623          	sw	ra,44(sp)
 2bc:	02812423          	sw	s0,40(sp)
 2c0:	03010413          	addi	s0,sp,48
 2c4:	fca42e23          	sw	a0,-36(s0)
 2c8:	fcb42c23          	sw	a1,-40(s0)
 2cc:	fdc42783          	lw	a5,-36(s0)
 2d0:	fef42623          	sw	a5,-20(s0)
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	fd842703          	lw	a4,-40(s0)
 2dc:	00e7a023          	sw	a4,0(a5)
 2e0:	00000013          	nop
 2e4:	02c12083          	lw	ra,44(sp)
 2e8:	02812403          	lw	s0,40(sp)
 2ec:	03010113          	addi	sp,sp,48
 2f0:	00008067          	ret

000002f4 <read>:
 2f4:	fd010113          	addi	sp,sp,-48
 2f8:	02112623          	sw	ra,44(sp)
 2fc:	02812423          	sw	s0,40(sp)
 300:	03010413          	addi	s0,sp,48
 304:	fca42e23          	sw	a0,-36(s0)
 308:	fcb42c23          	sw	a1,-40(s0)
 30c:	fdc42783          	lw	a5,-36(s0)
 310:	fef42623          	sw	a5,-20(s0)
 314:	fec42783          	lw	a5,-20(s0)
 318:	0007a703          	lw	a4,0(a5)
 31c:	fd842783          	lw	a5,-40(s0)
 320:	00e7a023          	sw	a4,0(a5)
 324:	00000013          	nop
 328:	02c12083          	lw	ra,44(sp)
 32c:	02812403          	lw	s0,40(sp)
 330:	03010113          	addi	sp,sp,48
 334:	00008067          	ret

00000338 <main>:
 338:	ff010113          	addi	sp,sp,-16
 33c:	00112623          	sw	ra,12(sp)
 340:	00812423          	sw	s0,8(sp)
 344:	01010413          	addi	s0,sp,16
 348:	0000006f          	j	348 <main+0x10>
