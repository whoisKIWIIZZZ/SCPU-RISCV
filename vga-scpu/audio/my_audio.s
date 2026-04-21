
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	2d4000ef          	jal	308 <main>
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
  a0:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffe43c>
  a4:	f8f40fa3          	sb	a5,-97(s0)
  a8:	f9f44703          	lbu	a4,-97(s0)
  ac:	0f000793          	li	a5,240
  b0:	00f71a63          	bne	a4,a5,c4 <handler+0x88>
  b4:	08000793          	li	a5,128
  b8:	00100713          	li	a4,1
  bc:	00e78023          	sb	a4,0(a5)
  c0:	0f80006f          	j	1b8 <handler+0x17c>
  c4:	e00007b7          	lui	a5,0xe0000
  c8:	f8f42c23          	sw	a5,-104(s0)
  cc:	f9f44703          	lbu	a4,-97(s0)
  d0:	f9842783          	lw	a5,-104(s0)
  d4:	00e7a023          	sw	a4,0(a5) # e0000000 <__global_pointer$+0xdfffe43c>
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
 1a0:	064000ef          	jal	204 <write>
 1a4:	08000793          	li	a5,128
 1a8:	00078023          	sb	zero,0(a5)
 1ac:	fae45783          	lhu	a5,-82(s0)
 1b0:	00078513          	mv	a0,a5
 1b4:	0d0000ef          	jal	284 <update_keys>
 1b8:	06c12083          	lw	ra,108(sp)
 1bc:	06812283          	lw	t0,104(sp)
 1c0:	06412303          	lw	t1,100(sp)
 1c4:	06012383          	lw	t2,96(sp)
 1c8:	05c12403          	lw	s0,92(sp)
 1cc:	05812503          	lw	a0,88(sp)
 1d0:	05412583          	lw	a1,84(sp)
 1d4:	05012603          	lw	a2,80(sp)
 1d8:	04c12683          	lw	a3,76(sp)
 1dc:	04812703          	lw	a4,72(sp)
 1e0:	04412783          	lw	a5,68(sp)
 1e4:	04012803          	lw	a6,64(sp)
 1e8:	03c12883          	lw	a7,60(sp)
 1ec:	03812e03          	lw	t3,56(sp)
 1f0:	03412e83          	lw	t4,52(sp)
 1f4:	03012f03          	lw	t5,48(sp)
 1f8:	02c12f83          	lw	t6,44(sp)
 1fc:	07010113          	addi	sp,sp,112
 200:	30200073          	mret

00000204 <write>:
 204:	fd010113          	addi	sp,sp,-48
 208:	02112623          	sw	ra,44(sp)
 20c:	02812423          	sw	s0,40(sp)
 210:	03010413          	addi	s0,sp,48
 214:	fca42e23          	sw	a0,-36(s0)
 218:	fcb42c23          	sw	a1,-40(s0)
 21c:	fdc42783          	lw	a5,-36(s0)
 220:	fef42623          	sw	a5,-20(s0)
 224:	fec42783          	lw	a5,-20(s0)
 228:	fd842703          	lw	a4,-40(s0)
 22c:	00e7a023          	sw	a4,0(a5)
 230:	00000013          	nop
 234:	02c12083          	lw	ra,44(sp)
 238:	02812403          	lw	s0,40(sp)
 23c:	03010113          	addi	sp,sp,48
 240:	00008067          	ret

00000244 <wait>:
 244:	fe010113          	addi	sp,sp,-32
 248:	00112e23          	sw	ra,28(sp)
 24c:	00812c23          	sw	s0,24(sp)
 250:	02010413          	addi	s0,sp,32
 254:	fea42623          	sw	a0,-20(s0)
 258:	00000013          	nop
 25c:	fec42783          	lw	a5,-20(s0)
 260:	fff78713          	addi	a4,a5,-1
 264:	fee42623          	sw	a4,-20(s0)
 268:	fe079ae3          	bnez	a5,25c <wait+0x18>
 26c:	00000013          	nop
 270:	00000013          	nop
 274:	01c12083          	lw	ra,28(sp)
 278:	01812403          	lw	s0,24(sp)
 27c:	02010113          	addi	sp,sp,32
 280:	00008067          	ret

00000284 <update_keys>:
 284:	fe010113          	addi	sp,sp,-32
 288:	00112e23          	sw	ra,28(sp)
 28c:	00812c23          	sw	s0,24(sp)
 290:	02010413          	addi	s0,sp,32
 294:	00050793          	mv	a5,a0
 298:	fef41723          	sh	a5,-18(s0)
 29c:	fee45683          	lhu	a3,-18(s0)
 2a0:	c00007b7          	lui	a5,0xc0000
 2a4:	00004737          	lui	a4,0x4
 2a8:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x243b>
 2ac:	00e6f733          	and	a4,a3,a4
 2b0:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe43c>
 2b4:	00000013          	nop
 2b8:	01c12083          	lw	ra,28(sp)
 2bc:	01812403          	lw	s0,24(sp)
 2c0:	02010113          	addi	sp,sp,32
 2c4:	00008067          	ret

000002c8 <read_keys_low2>:
 2c8:	fe010113          	addi	sp,sp,-32
 2cc:	00112e23          	sw	ra,28(sp)
 2d0:	00812c23          	sw	s0,24(sp)
 2d4:	02010413          	addi	s0,sp,32
 2d8:	c00007b7          	lui	a5,0xc0000
 2dc:	0007a783          	lw	a5,0(a5) # c0000000 <__global_pointer$+0xbfffe43c>
 2e0:	fef42623          	sw	a5,-20(s0)
 2e4:	fec42783          	lw	a5,-20(s0)
 2e8:	0ff7f793          	zext.b	a5,a5
 2ec:	0037f793          	andi	a5,a5,3
 2f0:	0ff7f793          	zext.b	a5,a5
 2f4:	00078513          	mv	a0,a5
 2f8:	01c12083          	lw	ra,28(sp)
 2fc:	01812403          	lw	s0,24(sp)
 300:	02010113          	addi	sp,sp,32
 304:	00008067          	ret

00000308 <main>:
 308:	ff010113          	addi	sp,sp,-16
 30c:	00112623          	sw	ra,12(sp)
 310:	00812423          	sw	s0,8(sp)
 314:	01010413          	addi	s0,sp,16
 318:	01a00593          	li	a1,26
 31c:	08400513          	li	a0,132
 320:	ee5ff0ef          	jal	204 <write>
 324:	02200593          	li	a1,34
 328:	08800513          	li	a0,136
 32c:	ed9ff0ef          	jal	204 <write>
 330:	02100593          	li	a1,33
 334:	08c00513          	li	a0,140
 338:	ecdff0ef          	jal	204 <write>
 33c:	02a00593          	li	a1,42
 340:	09000513          	li	a0,144
 344:	ec1ff0ef          	jal	204 <write>
 348:	03200593          	li	a1,50
 34c:	09400513          	li	a0,148
 350:	eb5ff0ef          	jal	204 <write>
 354:	03100593          	li	a1,49
 358:	09800513          	li	a0,152
 35c:	ea9ff0ef          	jal	204 <write>
 360:	03a00593          	li	a1,58
 364:	09c00513          	li	a0,156
 368:	e9dff0ef          	jal	204 <write>
 36c:	01c00593          	li	a1,28
 370:	0a000513          	li	a0,160
 374:	e91ff0ef          	jal	204 <write>
 378:	01b00593          	li	a1,27
 37c:	0a400513          	li	a0,164
 380:	e85ff0ef          	jal	204 <write>
 384:	02300593          	li	a1,35
 388:	0a800513          	li	a0,168
 38c:	e79ff0ef          	jal	204 <write>
 390:	02b00593          	li	a1,43
 394:	0ac00513          	li	a0,172
 398:	e6dff0ef          	jal	204 <write>
 39c:	03400593          	li	a1,52
 3a0:	0b000513          	li	a0,176
 3a4:	e61ff0ef          	jal	204 <write>
 3a8:	03300593          	li	a1,51
 3ac:	0b400513          	li	a0,180
 3b0:	e55ff0ef          	jal	204 <write>
 3b4:	03b00593          	li	a1,59
 3b8:	0b800513          	li	a0,184
 3bc:	e49ff0ef          	jal	204 <write>
 3c0:	0000006f          	j	3c0 <main+0xb8>
