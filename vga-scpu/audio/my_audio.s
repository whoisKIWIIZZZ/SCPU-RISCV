
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	2c4000ef          	jal	2f8 <main>
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
  a0:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffe476>
  a4:	f8f40fa3          	sb	a5,-97(s0)
  a8:	f9f44703          	lbu	a4,-97(s0)
  ac:	0f000793          	li	a5,240
  b0:	00f71a63          	bne	a4,a5,c4 <handler+0x88>
  b4:	08000793          	li	a5,128
  b8:	00100713          	li	a4,1
  bc:	00e78023          	sb	a4,0(a5)
  c0:	0e80006f          	j	1a8 <handler+0x16c>
  c4:	e00007b7          	lui	a5,0xe0000
  c8:	f8f42c23          	sw	a5,-104(s0)
  cc:	f9f44703          	lbu	a4,-97(s0)
  d0:	f9842783          	lw	a5,-104(s0)
  d4:	00e7a023          	sw	a4,0(a5) # e0000000 <__global_pointer$+0xdfffe476>
  d8:	fff00793          	li	a5,-1
  dc:	faf42423          	sw	a5,-88(s0)
  e0:	fa042223          	sw	zero,-92(s0)
  e4:	0380006f          	j	11c <handler+0xe0>
  e8:	fa442783          	lw	a5,-92(s0)
  ec:	00279793          	slli	a5,a5,0x2
  f0:	08478793          	addi	a5,a5,132
  f4:	0007a783          	lw	a5,0(a5)
  f8:	0ff7f793          	zext.b	a5,a5
  fc:	f9f44703          	lbu	a4,-97(s0)
 100:	00f71863          	bne	a4,a5,110 <handler+0xd4>
 104:	fa442783          	lw	a5,-92(s0)
 108:	faf42423          	sw	a5,-88(s0)
 10c:	01c0006f          	j	128 <handler+0xec>
 110:	fa442783          	lw	a5,-92(s0)
 114:	00178793          	addi	a5,a5,1
 118:	faf42223          	sw	a5,-92(s0)
 11c:	fa442703          	lw	a4,-92(s0)
 120:	00d00793          	li	a5,13
 124:	fce7d2e3          	bge	a5,a4,e8 <handler+0xac>
 128:	fa842703          	lw	a4,-88(s0)
 12c:	fff00793          	li	a5,-1
 130:	06f70263          	beq	a4,a5,194 <handler+0x158>
 134:	08000793          	li	a5,128
 138:	0007c783          	lbu	a5,0(a5)
 13c:	0ff7f793          	zext.b	a5,a5
 140:	02078a63          	beqz	a5,174 <handler+0x138>
 144:	fa842783          	lw	a5,-88(s0)
 148:	00100713          	li	a4,1
 14c:	00f717b3          	sll	a5,a4,a5
 150:	01079793          	slli	a5,a5,0x10
 154:	0107d793          	srli	a5,a5,0x10
 158:	fff7c793          	not	a5,a5
 15c:	01079793          	slli	a5,a5,0x10
 160:	0107d793          	srli	a5,a5,0x10
 164:	fae45703          	lhu	a4,-82(s0)
 168:	00e7f7b3          	and	a5,a5,a4
 16c:	faf41723          	sh	a5,-82(s0)
 170:	0240006f          	j	194 <handler+0x158>
 174:	fa842783          	lw	a5,-88(s0)
 178:	00100713          	li	a4,1
 17c:	00f717b3          	sll	a5,a4,a5
 180:	01079793          	slli	a5,a5,0x10
 184:	0107d793          	srli	a5,a5,0x10
 188:	fae45703          	lhu	a4,-82(s0)
 18c:	00e7e7b3          	or	a5,a5,a4
 190:	faf41723          	sh	a5,-82(s0)
 194:	08000793          	li	a5,128
 198:	00078023          	sb	zero,0(a5)
 19c:	fae45783          	lhu	a5,-82(s0)
 1a0:	00078513          	mv	a0,a5
 1a4:	0d0000ef          	jal	274 <update_keys>
 1a8:	06c12083          	lw	ra,108(sp)
 1ac:	06812283          	lw	t0,104(sp)
 1b0:	06412303          	lw	t1,100(sp)
 1b4:	06012383          	lw	t2,96(sp)
 1b8:	05c12403          	lw	s0,92(sp)
 1bc:	05812503          	lw	a0,88(sp)
 1c0:	05412583          	lw	a1,84(sp)
 1c4:	05012603          	lw	a2,80(sp)
 1c8:	04c12683          	lw	a3,76(sp)
 1cc:	04812703          	lw	a4,72(sp)
 1d0:	04412783          	lw	a5,68(sp)
 1d4:	04012803          	lw	a6,64(sp)
 1d8:	03c12883          	lw	a7,60(sp)
 1dc:	03812e03          	lw	t3,56(sp)
 1e0:	03412e83          	lw	t4,52(sp)
 1e4:	03012f03          	lw	t5,48(sp)
 1e8:	02c12f83          	lw	t6,44(sp)
 1ec:	07010113          	addi	sp,sp,112
 1f0:	30200073          	mret

000001f4 <write>:
 1f4:	fd010113          	addi	sp,sp,-48
 1f8:	02112623          	sw	ra,44(sp)
 1fc:	02812423          	sw	s0,40(sp)
 200:	03010413          	addi	s0,sp,48
 204:	fca42e23          	sw	a0,-36(s0)
 208:	fcb42c23          	sw	a1,-40(s0)
 20c:	fdc42783          	lw	a5,-36(s0)
 210:	fef42623          	sw	a5,-20(s0)
 214:	fec42783          	lw	a5,-20(s0)
 218:	fd842703          	lw	a4,-40(s0)
 21c:	00e7a023          	sw	a4,0(a5)
 220:	00000013          	nop
 224:	02c12083          	lw	ra,44(sp)
 228:	02812403          	lw	s0,40(sp)
 22c:	03010113          	addi	sp,sp,48
 230:	00008067          	ret

00000234 <wait>:
 234:	fe010113          	addi	sp,sp,-32
 238:	00112e23          	sw	ra,28(sp)
 23c:	00812c23          	sw	s0,24(sp)
 240:	02010413          	addi	s0,sp,32
 244:	fea42623          	sw	a0,-20(s0)
 248:	00000013          	nop
 24c:	fec42783          	lw	a5,-20(s0)
 250:	fff78713          	addi	a4,a5,-1
 254:	fee42623          	sw	a4,-20(s0)
 258:	fe079ae3          	bnez	a5,24c <wait+0x18>
 25c:	00000013          	nop
 260:	00000013          	nop
 264:	01c12083          	lw	ra,28(sp)
 268:	01812403          	lw	s0,24(sp)
 26c:	02010113          	addi	sp,sp,32
 270:	00008067          	ret

00000274 <update_keys>:
 274:	fe010113          	addi	sp,sp,-32
 278:	00112e23          	sw	ra,28(sp)
 27c:	00812c23          	sw	s0,24(sp)
 280:	02010413          	addi	s0,sp,32
 284:	00050793          	mv	a5,a0
 288:	fef41723          	sh	a5,-18(s0)
 28c:	fee45683          	lhu	a3,-18(s0)
 290:	c00007b7          	lui	a5,0xc0000
 294:	00004737          	lui	a4,0x4
 298:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x2475>
 29c:	00e6f733          	and	a4,a3,a4
 2a0:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe476>
 2a4:	00000013          	nop
 2a8:	01c12083          	lw	ra,28(sp)
 2ac:	01812403          	lw	s0,24(sp)
 2b0:	02010113          	addi	sp,sp,32
 2b4:	00008067          	ret

000002b8 <read_keys_low2>:
 2b8:	fe010113          	addi	sp,sp,-32
 2bc:	00112e23          	sw	ra,28(sp)
 2c0:	00812c23          	sw	s0,24(sp)
 2c4:	02010413          	addi	s0,sp,32
 2c8:	c00007b7          	lui	a5,0xc0000
 2cc:	0007a783          	lw	a5,0(a5) # c0000000 <__global_pointer$+0xbfffe476>
 2d0:	fef42623          	sw	a5,-20(s0)
 2d4:	fec42783          	lw	a5,-20(s0)
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	0037f793          	andi	a5,a5,3
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	00078513          	mv	a0,a5
 2e8:	01c12083          	lw	ra,28(sp)
 2ec:	01812403          	lw	s0,24(sp)
 2f0:	02010113          	addi	sp,sp,32
 2f4:	00008067          	ret

000002f8 <main>:
 2f8:	fd010113          	addi	sp,sp,-48
 2fc:	02112623          	sw	ra,44(sp)
 300:	02812423          	sw	s0,40(sp)
 304:	03010413          	addi	s0,sp,48
 308:	37c00793          	li	a5,892
 30c:	0007a683          	lw	a3,0(a5)
 310:	0047a703          	lw	a4,4(a5)
 314:	fcd42e23          	sw	a3,-36(s0)
 318:	fee42023          	sw	a4,-32(s0)
 31c:	0087a703          	lw	a4,8(a5)
 320:	fee42223          	sw	a4,-28(s0)
 324:	00c7d783          	lhu	a5,12(a5)
 328:	fef41423          	sh	a5,-24(s0)
 32c:	fe042623          	sw	zero,-20(s0)
 330:	0380006f          	j	368 <main+0x70>
 334:	fec42783          	lw	a5,-20(s0)
 338:	00279793          	slli	a5,a5,0x2
 33c:	08478713          	addi	a4,a5,132
 340:	fec42783          	lw	a5,-20(s0)
 344:	ff078793          	addi	a5,a5,-16
 348:	008787b3          	add	a5,a5,s0
 34c:	fec7c783          	lbu	a5,-20(a5)
 350:	00078593          	mv	a1,a5
 354:	00070513          	mv	a0,a4
 358:	e9dff0ef          	jal	1f4 <write>
 35c:	fec42783          	lw	a5,-20(s0)
 360:	00178793          	addi	a5,a5,1
 364:	fef42623          	sw	a5,-20(s0)
 368:	fec42703          	lw	a4,-20(s0)
 36c:	00d00793          	li	a5,13
 370:	fce7d2e3          	bge	a5,a4,334 <main+0x3c>
 374:	00000013          	nop
 378:	0000006f          	j	378 <main+0x80>
