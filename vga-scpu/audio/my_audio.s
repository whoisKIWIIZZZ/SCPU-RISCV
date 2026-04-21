
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	370000ef          	jal	3a4 <main>
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
  88:	0c000793          	li	a5,192
  8c:	0007d783          	lhu	a5,0(a5)
  90:	faf41723          	sh	a5,-82(s0)
  94:	a00007b7          	lui	a5,0xa0000
  98:	faf42023          	sw	a5,-96(s0)
  9c:	fa042783          	lw	a5,-96(s0)
  a0:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffe438>
  a4:	f8f40fa3          	sb	a5,-97(s0)
  a8:	f9f44703          	lbu	a4,-97(s0)
  ac:	0f000793          	li	a5,240
  b0:	00f71a63          	bne	a4,a5,c4 <handler+0x88>
  b4:	08000793          	li	a5,128
  b8:	00100713          	li	a4,1
  bc:	00e78023          	sb	a4,0(a5)
  c0:	1080006f          	j	1c8 <handler+0x18c>
  c4:	e00007b7          	lui	a5,0xe0000
  c8:	f8f42c23          	sw	a5,-104(s0)
  cc:	f9f44703          	lbu	a4,-97(s0)
  d0:	f9842783          	lw	a5,-104(s0)
  d4:	00e7a023          	sw	a4,0(a5) # e0000000 <__global_pointer$+0xdfffe438>
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
 194:	fae45783          	lhu	a5,-82(s0)
 198:	00078593          	mv	a1,a5
 19c:	0c000513          	li	a0,192
 1a0:	074000ef          	jal	214 <write>
 1a4:	08000793          	li	a5,128
 1a8:	00078023          	sb	zero,0(a5)
 1ac:	fae45783          	lhu	a5,-82(s0)
 1b0:	00078593          	mv	a1,a5
 1b4:	b0000537          	lui	a0,0xb0000
 1b8:	05c000ef          	jal	214 <write>
 1bc:	fae45783          	lhu	a5,-82(s0)
 1c0:	00078513          	mv	a0,a5
 1c4:	0d0000ef          	jal	294 <update_keys>
 1c8:	06c12083          	lw	ra,108(sp)
 1cc:	06812283          	lw	t0,104(sp)
 1d0:	06412303          	lw	t1,100(sp)
 1d4:	06012383          	lw	t2,96(sp)
 1d8:	05c12403          	lw	s0,92(sp)
 1dc:	05812503          	lw	a0,88(sp)
 1e0:	05412583          	lw	a1,84(sp)
 1e4:	05012603          	lw	a2,80(sp)
 1e8:	04c12683          	lw	a3,76(sp)
 1ec:	04812703          	lw	a4,72(sp)
 1f0:	04412783          	lw	a5,68(sp)
 1f4:	04012803          	lw	a6,64(sp)
 1f8:	03c12883          	lw	a7,60(sp)
 1fc:	03812e03          	lw	t3,56(sp)
 200:	03412e83          	lw	t4,52(sp)
 204:	03012f03          	lw	t5,48(sp)
 208:	02c12f83          	lw	t6,44(sp)
 20c:	07010113          	addi	sp,sp,112
 210:	30200073          	mret

00000214 <write>:
 214:	fd010113          	addi	sp,sp,-48
 218:	02112623          	sw	ra,44(sp)
 21c:	02812423          	sw	s0,40(sp)
 220:	03010413          	addi	s0,sp,48
 224:	fca42e23          	sw	a0,-36(s0)
 228:	fcb42c23          	sw	a1,-40(s0)
 22c:	fdc42783          	lw	a5,-36(s0)
 230:	fef42623          	sw	a5,-20(s0)
 234:	fec42783          	lw	a5,-20(s0)
 238:	fd842703          	lw	a4,-40(s0)
 23c:	00e7a023          	sw	a4,0(a5)
 240:	00000013          	nop
 244:	02c12083          	lw	ra,44(sp)
 248:	02812403          	lw	s0,40(sp)
 24c:	03010113          	addi	sp,sp,48
 250:	00008067          	ret

00000254 <wait>:
 254:	fe010113          	addi	sp,sp,-32
 258:	00112e23          	sw	ra,28(sp)
 25c:	00812c23          	sw	s0,24(sp)
 260:	02010413          	addi	s0,sp,32
 264:	fea42623          	sw	a0,-20(s0)
 268:	00000013          	nop
 26c:	fec42783          	lw	a5,-20(s0)
 270:	fff78713          	addi	a4,a5,-1
 274:	fee42623          	sw	a4,-20(s0)
 278:	fe079ae3          	bnez	a5,26c <wait+0x18>
 27c:	00000013          	nop
 280:	00000013          	nop
 284:	01c12083          	lw	ra,28(sp)
 288:	01812403          	lw	s0,24(sp)
 28c:	02010113          	addi	sp,sp,32
 290:	00008067          	ret

00000294 <update_keys>:
 294:	fe010113          	addi	sp,sp,-32
 298:	00112e23          	sw	ra,28(sp)
 29c:	00812c23          	sw	s0,24(sp)
 2a0:	02010413          	addi	s0,sp,32
 2a4:	00050793          	mv	a5,a0
 2a8:	fef41723          	sh	a5,-18(s0)
 2ac:	fee45683          	lhu	a3,-18(s0)
 2b0:	c00007b7          	lui	a5,0xc0000
 2b4:	00004737          	lui	a4,0x4
 2b8:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x2437>
 2bc:	00e6f733          	and	a4,a3,a4
 2c0:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe438>
 2c4:	00000013          	nop
 2c8:	01c12083          	lw	ra,28(sp)
 2cc:	01812403          	lw	s0,24(sp)
 2d0:	02010113          	addi	sp,sp,32
 2d4:	00008067          	ret

000002d8 <init>:
 2d8:	ff010113          	addi	sp,sp,-16
 2dc:	00112623          	sw	ra,12(sp)
 2e0:	00812423          	sw	s0,8(sp)
 2e4:	01010413          	addi	s0,sp,16
 2e8:	01a00593          	li	a1,26
 2ec:	08400513          	li	a0,132
 2f0:	f25ff0ef          	jal	214 <write>
 2f4:	02200593          	li	a1,34
 2f8:	08800513          	li	a0,136
 2fc:	f19ff0ef          	jal	214 <write>
 300:	02100593          	li	a1,33
 304:	08c00513          	li	a0,140
 308:	f0dff0ef          	jal	214 <write>
 30c:	02a00593          	li	a1,42
 310:	09000513          	li	a0,144
 314:	f01ff0ef          	jal	214 <write>
 318:	03200593          	li	a1,50
 31c:	09400513          	li	a0,148
 320:	ef5ff0ef          	jal	214 <write>
 324:	03100593          	li	a1,49
 328:	09800513          	li	a0,152
 32c:	ee9ff0ef          	jal	214 <write>
 330:	03a00593          	li	a1,58
 334:	09c00513          	li	a0,156
 338:	eddff0ef          	jal	214 <write>
 33c:	01c00593          	li	a1,28
 340:	0a000513          	li	a0,160
 344:	ed1ff0ef          	jal	214 <write>
 348:	01b00593          	li	a1,27
 34c:	0a400513          	li	a0,164
 350:	ec5ff0ef          	jal	214 <write>
 354:	02300593          	li	a1,35
 358:	0a800513          	li	a0,168
 35c:	eb9ff0ef          	jal	214 <write>
 360:	02b00593          	li	a1,43
 364:	0ac00513          	li	a0,172
 368:	eadff0ef          	jal	214 <write>
 36c:	03400593          	li	a1,52
 370:	0b000513          	li	a0,176
 374:	ea1ff0ef          	jal	214 <write>
 378:	03300593          	li	a1,51
 37c:	0b400513          	li	a0,180
 380:	e95ff0ef          	jal	214 <write>
 384:	03b00593          	li	a1,59
 388:	0b800513          	li	a0,184
 38c:	e89ff0ef          	jal	214 <write>
 390:	00000013          	nop
 394:	00c12083          	lw	ra,12(sp)
 398:	00812403          	lw	s0,8(sp)
 39c:	01010113          	addi	sp,sp,16
 3a0:	00008067          	ret

000003a4 <main>:
 3a4:	ff010113          	addi	sp,sp,-16
 3a8:	00112623          	sw	ra,12(sp)
 3ac:	00812423          	sw	s0,8(sp)
 3b0:	01010413          	addi	s0,sp,16
 3b4:	f25ff0ef          	jal	2d8 <init>
 3b8:	00900593          	li	a1,9
 3bc:	b0000537          	lui	a0,0xb0000
 3c0:	e55ff0ef          	jal	214 <write>
 3c4:	0000006f          	j	3c4 <main+0x20>
