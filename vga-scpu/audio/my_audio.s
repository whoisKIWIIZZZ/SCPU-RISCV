
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	500000ef          	jal	534 <main>
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
  8c:	0007a783          	lw	a5,0(a5)
  90:	faf42623          	sw	a5,-84(s0)
  94:	a00007b7          	lui	a5,0xa0000
  98:	faf42023          	sw	a5,-96(s0)
  9c:	fa042783          	lw	a5,-96(s0)
  a0:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffe25c>
  a4:	f8f40fa3          	sb	a5,-97(s0)
  a8:	f9f44703          	lbu	a4,-97(s0)
  ac:	01200793          	li	a5,18
  b0:	00f71863          	bne	a4,a5,c0 <handler+0x84>
  b4:	08000793          	li	a5,128
  b8:	00100713          	li	a4,1
  bc:	00e78023          	sb	a4,0(a5)
  c0:	f9f44703          	lbu	a4,-97(s0)
  c4:	05900793          	li	a5,89
  c8:	00f71863          	bne	a4,a5,d8 <handler+0x9c>
  cc:	08000793          	li	a5,128
  d0:	00100713          	li	a4,1
  d4:	00e78023          	sb	a4,0(a5)
  d8:	f9f44703          	lbu	a4,-97(s0)
  dc:	0f000793          	li	a5,240
  e0:	00f71a63          	bne	a4,a5,f4 <handler+0xb8>
  e4:	07c00793          	li	a5,124
  e8:	00100713          	li	a4,1
  ec:	00e78023          	sb	a4,0(a5)
  f0:	2180006f          	j	308 <handler+0x2cc>
  f4:	e00007b7          	lui	a5,0xe0000
  f8:	f8f42c23          	sw	a5,-104(s0)
  fc:	f9f44703          	lbu	a4,-97(s0)
 100:	f9842783          	lw	a5,-104(s0)
 104:	00e7a023          	sw	a4,0(a5) # e0000000 <__global_pointer$+0xdfffe25c>
 108:	f9f44703          	lbu	a4,-97(s0)
 10c:	01600793          	li	a5,22
 110:	0af71263          	bne	a4,a5,1b4 <handler+0x178>
 114:	07c00793          	li	a5,124
 118:	0007c783          	lbu	a5,0(a5)
 11c:	0ff7f793          	zext.b	a5,a5
 120:	08079a63          	bnez	a5,1b4 <handler+0x178>
 124:	07000793          	li	a5,112
 128:	0007c703          	lbu	a4,0(a5)
 12c:	0ff77713          	zext.b	a4,a4
 130:	00170713          	addi	a4,a4,1
 134:	0ff77713          	zext.b	a4,a4
 138:	00e78023          	sb	a4,0(a5)
 13c:	0200006f          	j	15c <handler+0x120>
 140:	07000793          	li	a5,112
 144:	0007c783          	lbu	a5,0(a5)
 148:	0ff7f713          	zext.b	a4,a5
 14c:	07000793          	li	a5,112
 150:	ffb70713          	addi	a4,a4,-5
 154:	0ff77713          	zext.b	a4,a4
 158:	00e78023          	sb	a4,0(a5)
 15c:	07000793          	li	a5,112
 160:	0007c783          	lbu	a5,0(a5)
 164:	0ff7f713          	zext.b	a4,a5
 168:	00400793          	li	a5,4
 16c:	fce7eae3          	bltu	a5,a4,140 <handler+0x104>
 170:	07000793          	li	a5,112
 174:	0007c783          	lbu	a5,0(a5)
 178:	0ff7f793          	zext.b	a5,a5
 17c:	01a79713          	slli	a4,a5,0x1a
 180:	fac42683          	lw	a3,-84(s0)
 184:	000047b7          	lui	a5,0x4
 188:	fff78793          	addi	a5,a5,-1 # 3fff <__global_pointer$+0x225b>
 18c:	00f6f7b3          	and	a5,a3,a5
 190:	00f76733          	or	a4,a4,a5
 194:	01d207b7          	lui	a5,0x1d20
 198:	00f767b3          	or	a5,a4,a5
 19c:	f8f42a23          	sw	a5,-108(s0)
 1a0:	f9442783          	lw	a5,-108(s0)
 1a4:	00078593          	mv	a1,a5
 1a8:	b0000537          	lui	a0,0xb0000
 1ac:	1a8000ef          	jal	354 <write>
 1b0:	1580006f          	j	308 <handler+0x2cc>
 1b4:	fff00793          	li	a5,-1
 1b8:	faf42423          	sw	a5,-88(s0)
 1bc:	fa042223          	sw	zero,-92(s0)
 1c0:	0380006f          	j	1f8 <handler+0x1bc>
 1c4:	fa442783          	lw	a5,-92(s0)
 1c8:	00279793          	slli	a5,a5,0x2
 1cc:	08478793          	addi	a5,a5,132 # 1d20084 <__global_pointer$+0x1d1e2e0>
 1d0:	0007a783          	lw	a5,0(a5)
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	f9f44703          	lbu	a4,-97(s0)
 1dc:	00f71863          	bne	a4,a5,1ec <handler+0x1b0>
 1e0:	fa442783          	lw	a5,-92(s0)
 1e4:	faf42423          	sw	a5,-88(s0)
 1e8:	01c0006f          	j	204 <handler+0x1c8>
 1ec:	fa442783          	lw	a5,-92(s0)
 1f0:	00178793          	addi	a5,a5,1
 1f4:	faf42223          	sw	a5,-92(s0)
 1f8:	fa442703          	lw	a4,-92(s0)
 1fc:	00e00793          	li	a5,14
 200:	fce7d2e3          	bge	a5,a4,1c4 <handler+0x188>
 204:	08000793          	li	a5,128
 208:	0007c783          	lbu	a5,0(a5)
 20c:	0ff7f793          	zext.b	a5,a5
 210:	02078463          	beqz	a5,238 <handler+0x1fc>
 214:	07c00793          	li	a5,124
 218:	0007c783          	lbu	a5,0(a5)
 21c:	0ff7f793          	zext.b	a5,a5
 220:	00078c63          	beqz	a5,238 <handler+0x1fc>
 224:	07c00793          	li	a5,124
 228:	00078023          	sb	zero,0(a5)
 22c:	08000793          	li	a5,128
 230:	00078023          	sb	zero,0(a5)
 234:	0d40006f          	j	308 <handler+0x2cc>
 238:	fa842703          	lw	a4,-88(s0)
 23c:	fff00793          	li	a5,-1
 240:	06f70463          	beq	a4,a5,2a8 <handler+0x26c>
 244:	08000793          	li	a5,128
 248:	0007c783          	lbu	a5,0(a5)
 24c:	0ff7f793          	zext.b	a5,a5
 250:	00078863          	beqz	a5,260 <handler+0x224>
 254:	fa842783          	lw	a5,-88(s0)
 258:	00c78793          	addi	a5,a5,12
 25c:	faf42423          	sw	a5,-88(s0)
 260:	07c00793          	li	a5,124
 264:	0007c783          	lbu	a5,0(a5)
 268:	0ff7f793          	zext.b	a5,a5
 26c:	02078263          	beqz	a5,290 <handler+0x254>
 270:	fa842783          	lw	a5,-88(s0)
 274:	00100713          	li	a4,1
 278:	00f717b3          	sll	a5,a4,a5
 27c:	fff7c793          	not	a5,a5
 280:	fac42703          	lw	a4,-84(s0)
 284:	00f777b3          	and	a5,a4,a5
 288:	faf42623          	sw	a5,-84(s0)
 28c:	01c0006f          	j	2a8 <handler+0x26c>
 290:	fa842783          	lw	a5,-88(s0)
 294:	00100713          	li	a4,1
 298:	00f717b3          	sll	a5,a4,a5
 29c:	fac42703          	lw	a4,-84(s0)
 2a0:	00f767b3          	or	a5,a4,a5
 2a4:	faf42623          	sw	a5,-84(s0)
 2a8:	07c00793          	li	a5,124
 2ac:	00078023          	sb	zero,0(a5)
 2b0:	07000793          	li	a5,112
 2b4:	0007c783          	lbu	a5,0(a5)
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	01a79713          	slli	a4,a5,0x1a
 2c0:	fac42683          	lw	a3,-84(s0)
 2c4:	000047b7          	lui	a5,0x4
 2c8:	fff78793          	addi	a5,a5,-1 # 3fff <__global_pointer$+0x225b>
 2cc:	00f6f7b3          	and	a5,a3,a5
 2d0:	00f76733          	or	a4,a4,a5
 2d4:	01d207b7          	lui	a5,0x1d20
 2d8:	00f767b3          	or	a5,a4,a5
 2dc:	f8f42823          	sw	a5,-112(s0)
 2e0:	f9042783          	lw	a5,-112(s0)
 2e4:	00078593          	mv	a1,a5
 2e8:	b0000537          	lui	a0,0xb0000
 2ec:	068000ef          	jal	354 <write>
 2f0:	f9042783          	lw	a5,-112(s0)
 2f4:	00078593          	mv	a1,a5
 2f8:	0c000513          	li	a0,192
 2fc:	058000ef          	jal	354 <write>
 300:	fac42503          	lw	a0,-84(s0)
 304:	0d0000ef          	jal	3d4 <update_keys>
 308:	06c12083          	lw	ra,108(sp)
 30c:	06812283          	lw	t0,104(sp)
 310:	06412303          	lw	t1,100(sp)
 314:	06012383          	lw	t2,96(sp)
 318:	05c12403          	lw	s0,92(sp)
 31c:	05812503          	lw	a0,88(sp)
 320:	05412583          	lw	a1,84(sp)
 324:	05012603          	lw	a2,80(sp)
 328:	04c12683          	lw	a3,76(sp)
 32c:	04812703          	lw	a4,72(sp)
 330:	04412783          	lw	a5,68(sp)
 334:	04012803          	lw	a6,64(sp)
 338:	03c12883          	lw	a7,60(sp)
 33c:	03812e03          	lw	t3,56(sp)
 340:	03412e83          	lw	t4,52(sp)
 344:	03012f03          	lw	t5,48(sp)
 348:	02c12f83          	lw	t6,44(sp)
 34c:	07010113          	addi	sp,sp,112
 350:	30200073          	mret

00000354 <write>:
 354:	fd010113          	addi	sp,sp,-48
 358:	02112623          	sw	ra,44(sp)
 35c:	02812423          	sw	s0,40(sp)
 360:	03010413          	addi	s0,sp,48
 364:	fca42e23          	sw	a0,-36(s0)
 368:	fcb42c23          	sw	a1,-40(s0)
 36c:	fdc42783          	lw	a5,-36(s0)
 370:	fef42623          	sw	a5,-20(s0)
 374:	fec42783          	lw	a5,-20(s0)
 378:	fd842703          	lw	a4,-40(s0)
 37c:	00e7a023          	sw	a4,0(a5) # 1d20000 <__global_pointer$+0x1d1e25c>
 380:	00000013          	nop
 384:	02c12083          	lw	ra,44(sp)
 388:	02812403          	lw	s0,40(sp)
 38c:	03010113          	addi	sp,sp,48
 390:	00008067          	ret

00000394 <wait>:
 394:	fe010113          	addi	sp,sp,-32
 398:	00112e23          	sw	ra,28(sp)
 39c:	00812c23          	sw	s0,24(sp)
 3a0:	02010413          	addi	s0,sp,32
 3a4:	fea42623          	sw	a0,-20(s0)
 3a8:	00000013          	nop
 3ac:	fec42783          	lw	a5,-20(s0)
 3b0:	fff78713          	addi	a4,a5,-1
 3b4:	fee42623          	sw	a4,-20(s0)
 3b8:	fe079ae3          	bnez	a5,3ac <wait+0x18>
 3bc:	00000013          	nop
 3c0:	00000013          	nop
 3c4:	01c12083          	lw	ra,28(sp)
 3c8:	01812403          	lw	s0,24(sp)
 3cc:	02010113          	addi	sp,sp,32
 3d0:	00008067          	ret

000003d4 <update_keys>:
 3d4:	fe010113          	addi	sp,sp,-32
 3d8:	00112e23          	sw	ra,28(sp)
 3dc:	00812c23          	sw	s0,24(sp)
 3e0:	02010413          	addi	s0,sp,32
 3e4:	fea42623          	sw	a0,-20(s0)
 3e8:	c00007b7          	lui	a5,0xc0000
 3ec:	fec42683          	lw	a3,-20(s0)
 3f0:	00004737          	lui	a4,0x4
 3f4:	fff70713          	addi	a4,a4,-1 # 3fff <__global_pointer$+0x225b>
 3f8:	00e6f733          	and	a4,a3,a4
 3fc:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffe25c>
 400:	00000013          	nop
 404:	01c12083          	lw	ra,28(sp)
 408:	01812403          	lw	s0,24(sp)
 40c:	02010113          	addi	sp,sp,32
 410:	00008067          	ret

00000414 <init>:
 414:	ff010113          	addi	sp,sp,-16
 418:	00112623          	sw	ra,12(sp)
 41c:	00812423          	sw	s0,8(sp)
 420:	01010413          	addi	s0,sp,16
 424:	01a00593          	li	a1,26
 428:	08400513          	li	a0,132
 42c:	f29ff0ef          	jal	354 <write>
 430:	02200593          	li	a1,34
 434:	08800513          	li	a0,136
 438:	f1dff0ef          	jal	354 <write>
 43c:	02100593          	li	a1,33
 440:	08c00513          	li	a0,140
 444:	f11ff0ef          	jal	354 <write>
 448:	02a00593          	li	a1,42
 44c:	09000513          	li	a0,144
 450:	f05ff0ef          	jal	354 <write>
 454:	03200593          	li	a1,50
 458:	09400513          	li	a0,148
 45c:	ef9ff0ef          	jal	354 <write>
 460:	03100593          	li	a1,49
 464:	09800513          	li	a0,152
 468:	eedff0ef          	jal	354 <write>
 46c:	03a00593          	li	a1,58
 470:	09c00513          	li	a0,156
 474:	ee1ff0ef          	jal	354 <write>
 478:	01c00593          	li	a1,28
 47c:	0a000513          	li	a0,160
 480:	ed5ff0ef          	jal	354 <write>
 484:	01b00593          	li	a1,27
 488:	0a400513          	li	a0,164
 48c:	ec9ff0ef          	jal	354 <write>
 490:	02300593          	li	a1,35
 494:	0a800513          	li	a0,168
 498:	ebdff0ef          	jal	354 <write>
 49c:	02b00593          	li	a1,43
 4a0:	0ac00513          	li	a0,172
 4a4:	eb1ff0ef          	jal	354 <write>
 4a8:	03400593          	li	a1,52
 4ac:	0b000513          	li	a0,176
 4b0:	ea5ff0ef          	jal	354 <write>
 4b4:	03300593          	li	a1,51
 4b8:	0b400513          	li	a0,180
 4bc:	e99ff0ef          	jal	354 <write>
 4c0:	03b00593          	li	a1,59
 4c4:	0b800513          	li	a0,184
 4c8:	e8dff0ef          	jal	354 <write>
 4cc:	01500593          	li	a1,21
 4d0:	0bc00513          	li	a0,188
 4d4:	e81ff0ef          	jal	354 <write>
 4d8:	01d00593          	li	a1,29
 4dc:	0c000513          	li	a0,192
 4e0:	e75ff0ef          	jal	354 <write>
 4e4:	02400593          	li	a1,36
 4e8:	0c400513          	li	a0,196
 4ec:	e69ff0ef          	jal	354 <write>
 4f0:	02d00593          	li	a1,45
 4f4:	0c800513          	li	a0,200
 4f8:	e5dff0ef          	jal	354 <write>
 4fc:	02c00593          	li	a1,44
 500:	0cc00513          	li	a0,204
 504:	e51ff0ef          	jal	354 <write>
 508:	03500593          	li	a1,53
 50c:	0d000513          	li	a0,208
 510:	e45ff0ef          	jal	354 <write>
 514:	03c00593          	li	a1,60
 518:	0d400513          	li	a0,212
 51c:	e39ff0ef          	jal	354 <write>
 520:	00000013          	nop
 524:	00c12083          	lw	ra,12(sp)
 528:	00812403          	lw	s0,8(sp)
 52c:	01010113          	addi	sp,sp,16
 530:	00008067          	ret

00000534 <main>:
 534:	fe010113          	addi	sp,sp,-32
 538:	00112e23          	sw	ra,28(sp)
 53c:	00812c23          	sw	s0,24(sp)
 540:	02010413          	addi	s0,sp,32
 544:	ed1ff0ef          	jal	414 <init>
 548:	07000793          	li	a5,112
 54c:	0007c783          	lbu	a5,0(a5)
 550:	0ff7f793          	zext.b	a5,a5
 554:	01a79713          	slli	a4,a5,0x1a
 558:	01d207b7          	lui	a5,0x1d20
 55c:	00f767b3          	or	a5,a4,a5
 560:	fef42623          	sw	a5,-20(s0)
 564:	fec42783          	lw	a5,-20(s0)
 568:	00078593          	mv	a1,a5
 56c:	b0000537          	lui	a0,0xb0000
 570:	de5ff0ef          	jal	354 <write>
 574:	146507b7          	lui	a5,0x14650
 578:	f6478593          	addi	a1,a5,-156 # 1464ff64 <__global_pointer$+0x1464e1c0>
 57c:	b1000537          	lui	a0,0xb1000
 580:	dd5ff0ef          	jal	354 <write>
 584:	01000593          	li	a1,16
 588:	b2000537          	lui	a0,0xb2000
 58c:	dc9ff0ef          	jal	354 <write>
 590:	80c817b7          	lui	a5,0x80c81
 594:	08078593          	addi	a1,a5,128 # 80c81080 <__global_pointer$+0x80c7f2dc>
 598:	b3000537          	lui	a0,0xb3000
 59c:	db9ff0ef          	jal	354 <write>
 5a0:	0000006f          	j	5a0 <main+0x6c>
