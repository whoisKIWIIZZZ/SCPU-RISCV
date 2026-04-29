
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	491000ef          	jal	cc4 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <write>:
  3c:	fd010113          	addi	sp,sp,-48
  40:	02112623          	sw	ra,44(sp)
  44:	02812423          	sw	s0,40(sp)
  48:	03010413          	addi	s0,sp,48
  4c:	fca42e23          	sw	a0,-36(s0)
  50:	fcb42c23          	sw	a1,-40(s0)
  54:	fdc42783          	lw	a5,-36(s0)
  58:	fef42623          	sw	a5,-20(s0)
  5c:	fec42783          	lw	a5,-20(s0)
  60:	fd842703          	lw	a4,-40(s0)
  64:	00e7a023          	sw	a4,0(a5)
  68:	00000013          	nop
  6c:	02c12083          	lw	ra,44(sp)
  70:	02812403          	lw	s0,40(sp)
  74:	03010113          	addi	sp,sp,48
  78:	00008067          	ret

0000007c <wait>:
  7c:	fe010113          	addi	sp,sp,-32
  80:	00112e23          	sw	ra,28(sp)
  84:	00812c23          	sw	s0,24(sp)
  88:	02010413          	addi	s0,sp,32
  8c:	fea42623          	sw	a0,-20(s0)
  90:	00000013          	nop
  94:	fec42783          	lw	a5,-20(s0)
  98:	fff78713          	addi	a4,a5,-1
  9c:	fee42623          	sw	a4,-20(s0)
  a0:	fe079ae3          	bnez	a5,94 <wait+0x18>
  a4:	00000013          	nop
  a8:	00000013          	nop
  ac:	01c12083          	lw	ra,28(sp)
  b0:	01812403          	lw	s0,24(sp)
  b4:	02010113          	addi	sp,sp,32
  b8:	00008067          	ret

000000bc <update_keys>:
  bc:	fe010113          	addi	sp,sp,-32
  c0:	00112e23          	sw	ra,28(sp)
  c4:	00812c23          	sw	s0,24(sp)
  c8:	02010413          	addi	s0,sp,32
  cc:	fea42623          	sw	a0,-20(s0)
  d0:	c00007b7          	lui	a5,0xc0000
  d4:	fec42683          	lw	a3,-20(s0)
  d8:	00200737          	lui	a4,0x200
  dc:	fff70713          	addi	a4,a4,-1 # 1fffff <__global_pointer$+0x1fdb23>
  e0:	00e6f733          	and	a4,a3,a4
  e4:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffdb24>
  e8:	00000013          	nop
  ec:	01c12083          	lw	ra,28(sp)
  f0:	01812403          	lw	s0,24(sp)
  f4:	02010113          	addi	sp,sp,32
  f8:	00008067          	ret

000000fc <write_ctrl>:
  fc:	fe010113          	addi	sp,sp,-32
 100:	00112e23          	sw	ra,28(sp)
 104:	00812c23          	sw	s0,24(sp)
 108:	02010413          	addi	s0,sp,32
 10c:	18000793          	li	a5,384
 110:	0007c783          	lbu	a5,0(a5)
 114:	0ff7f793          	zext.b	a5,a5
 118:	01a79713          	slli	a4,a5,0x1a
 11c:	18c00793          	li	a5,396
 120:	0007c783          	lbu	a5,0(a5)
 124:	0ff7f793          	zext.b	a5,a5
 128:	01679793          	slli	a5,a5,0x16
 12c:	00f76733          	or	a4,a4,a5
 130:	18800793          	li	a5,392
 134:	0007c783          	lbu	a5,0(a5)
 138:	0ff7f793          	zext.b	a5,a5
 13c:	01279793          	slli	a5,a5,0x12
 140:	00f76733          	or	a4,a4,a5
 144:	18400793          	li	a5,388
 148:	0007c783          	lbu	a5,0(a5)
 14c:	0ff7f793          	zext.b	a5,a5
 150:	00e79793          	slli	a5,a5,0xe
 154:	00f767b3          	or	a5,a4,a5
 158:	fef42623          	sw	a5,-20(s0)
 15c:	fec42783          	lw	a5,-20(s0)
 160:	00078593          	mv	a1,a5
 164:	b1000537          	lui	a0,0xb1000
 168:	ed5ff0ef          	jal	3c <write>
 16c:	00000013          	nop
 170:	01c12083          	lw	ra,28(sp)
 174:	01812403          	lw	s0,24(sp)
 178:	02010113          	addi	sp,sp,32
 17c:	00008067          	ret

00000180 <write_adsr>:
 180:	fe010113          	addi	sp,sp,-32
 184:	00112e23          	sw	ra,28(sp)
 188:	00812c23          	sw	s0,24(sp)
 18c:	02010413          	addi	s0,sp,32
 190:	19400793          	li	a5,404
 194:	0007c783          	lbu	a5,0(a5)
 198:	0ff7f793          	zext.b	a5,a5
 19c:	01879713          	slli	a4,a5,0x18
 1a0:	19800793          	li	a5,408
 1a4:	0007c783          	lbu	a5,0(a5)
 1a8:	0ff7f793          	zext.b	a5,a5
 1ac:	01079793          	slli	a5,a5,0x10
 1b0:	00f76733          	or	a4,a4,a5
 1b4:	19c00793          	li	a5,412
 1b8:	0007c783          	lbu	a5,0(a5)
 1bc:	0ff7f793          	zext.b	a5,a5
 1c0:	00879793          	slli	a5,a5,0x8
 1c4:	00f767b3          	or	a5,a4,a5
 1c8:	1a000713          	li	a4,416
 1cc:	00074703          	lbu	a4,0(a4)
 1d0:	0ff77713          	zext.b	a4,a4
 1d4:	00e7e7b3          	or	a5,a5,a4
 1d8:	fef42623          	sw	a5,-20(s0)
 1dc:	fec42783          	lw	a5,-20(s0)
 1e0:	00078593          	mv	a1,a5
 1e4:	b2000537          	lui	a0,0xb2000
 1e8:	e55ff0ef          	jal	3c <write>
 1ec:	00000013          	nop
 1f0:	01c12083          	lw	ra,28(sp)
 1f4:	01812403          	lw	s0,24(sp)
 1f8:	02010113          	addi	sp,sp,32
 1fc:	00008067          	ret

00000200 <write_piano>:
 200:	fe010113          	addi	sp,sp,-32
 204:	00112e23          	sw	ra,28(sp)
 208:	00812c23          	sw	s0,24(sp)
 20c:	02010413          	addi	s0,sp,32
 210:	1a400793          	li	a5,420
 214:	0007c783          	lbu	a5,0(a5)
 218:	0ff7f793          	zext.b	a5,a5
 21c:	01879713          	slli	a4,a5,0x18
 220:	1a800793          	li	a5,424
 224:	0007c783          	lbu	a5,0(a5)
 228:	0ff7f793          	zext.b	a5,a5
 22c:	01079793          	slli	a5,a5,0x10
 230:	00f76733          	or	a4,a4,a5
 234:	1ac00793          	li	a5,428
 238:	0007c783          	lbu	a5,0(a5)
 23c:	0ff7f793          	zext.b	a5,a5
 240:	00879793          	slli	a5,a5,0x8
 244:	00f767b3          	or	a5,a4,a5
 248:	1b000713          	li	a4,432
 24c:	00074703          	lbu	a4,0(a4)
 250:	0ff77713          	zext.b	a4,a4
 254:	00e7e7b3          	or	a5,a5,a4
 258:	fef42623          	sw	a5,-20(s0)
 25c:	fec42783          	lw	a5,-20(s0)
 260:	00078593          	mv	a1,a5
 264:	b4000537          	lui	a0,0xb4000
 268:	dd5ff0ef          	jal	3c <write>
 26c:	00000013          	nop
 270:	01c12083          	lw	ra,28(sp)
 274:	01812403          	lw	s0,24(sp)
 278:	02010113          	addi	sp,sp,32
 27c:	00008067          	ret

00000280 <write_seg>:
 280:	fd010113          	addi	sp,sp,-48
 284:	02112623          	sw	ra,44(sp)
 288:	02812423          	sw	s0,40(sp)
 28c:	03010413          	addi	s0,sp,48
 290:	fca42e23          	sw	a0,-36(s0)
 294:	fe042623          	sw	zero,-20(s0)
 298:	fdc42703          	lw	a4,-36(s0)
 29c:	04d00793          	li	a5,77
 2a0:	28f70e63          	beq	a4,a5,53c <write_seg+0x2bc>
 2a4:	fdc42703          	lw	a4,-36(s0)
 2a8:	04d00793          	li	a5,77
 2ac:	2ae7c863          	blt	a5,a4,55c <write_seg+0x2dc>
 2b0:	fdc42703          	lw	a4,-36(s0)
 2b4:	04600793          	li	a5,70
 2b8:	20f70263          	beq	a4,a5,4bc <write_seg+0x23c>
 2bc:	fdc42703          	lw	a4,-36(s0)
 2c0:	04600793          	li	a5,70
 2c4:	28e7cc63          	blt	a5,a4,55c <write_seg+0x2dc>
 2c8:	fdc42703          	lw	a4,-36(s0)
 2cc:	04500793          	li	a5,69
 2d0:	20f70663          	beq	a4,a5,4dc <write_seg+0x25c>
 2d4:	fdc42703          	lw	a4,-36(s0)
 2d8:	04500793          	li	a5,69
 2dc:	28e7c063          	blt	a5,a4,55c <write_seg+0x2dc>
 2e0:	fdc42703          	lw	a4,-36(s0)
 2e4:	04400793          	li	a5,68
 2e8:	22f70a63          	beq	a4,a5,51c <write_seg+0x29c>
 2ec:	fdc42703          	lw	a4,-36(s0)
 2f0:	04400793          	li	a5,68
 2f4:	26e7c463          	blt	a5,a4,55c <write_seg+0x2dc>
 2f8:	fdc42703          	lw	a4,-36(s0)
 2fc:	04300793          	li	a5,67
 300:	1ef70e63          	beq	a4,a5,4fc <write_seg+0x27c>
 304:	fdc42703          	lw	a4,-36(s0)
 308:	04300793          	li	a5,67
 30c:	24e7c863          	blt	a5,a4,55c <write_seg+0x2dc>
 310:	fdc42703          	lw	a4,-36(s0)
 314:	03e00793          	li	a5,62
 318:	18f70263          	beq	a4,a5,49c <write_seg+0x21c>
 31c:	fdc42703          	lw	a4,-36(s0)
 320:	03e00793          	li	a5,62
 324:	22e7cc63          	blt	a5,a4,55c <write_seg+0x2dc>
 328:	fdc42703          	lw	a4,-36(s0)
 32c:	03d00793          	li	a5,61
 330:	14f70663          	beq	a4,a5,47c <write_seg+0x1fc>
 334:	fdc42703          	lw	a4,-36(s0)
 338:	03d00793          	li	a5,61
 33c:	22e7c063          	blt	a5,a4,55c <write_seg+0x2dc>
 340:	fdc42703          	lw	a4,-36(s0)
 344:	03600793          	li	a5,54
 348:	10f70a63          	beq	a4,a5,45c <write_seg+0x1dc>
 34c:	fdc42703          	lw	a4,-36(s0)
 350:	03600793          	li	a5,54
 354:	20e7c463          	blt	a5,a4,55c <write_seg+0x2dc>
 358:	fdc42703          	lw	a4,-36(s0)
 35c:	02e00793          	li	a5,46
 360:	0cf70e63          	beq	a4,a5,43c <write_seg+0x1bc>
 364:	fdc42703          	lw	a4,-36(s0)
 368:	02e00793          	li	a5,46
 36c:	1ee7c863          	blt	a5,a4,55c <write_seg+0x2dc>
 370:	fdc42703          	lw	a4,-36(s0)
 374:	02600793          	li	a5,38
 378:	08f70263          	beq	a4,a5,3fc <write_seg+0x17c>
 37c:	fdc42703          	lw	a4,-36(s0)
 380:	02600793          	li	a5,38
 384:	1ce7cc63          	blt	a5,a4,55c <write_seg+0x2dc>
 388:	fdc42703          	lw	a4,-36(s0)
 38c:	02500793          	li	a5,37
 390:	08f70663          	beq	a4,a5,41c <write_seg+0x19c>
 394:	fdc42703          	lw	a4,-36(s0)
 398:	02500793          	li	a5,37
 39c:	1ce7c063          	blt	a5,a4,55c <write_seg+0x2dc>
 3a0:	fdc42703          	lw	a4,-36(s0)
 3a4:	01600793          	li	a5,22
 3a8:	00f70a63          	beq	a4,a5,3bc <write_seg+0x13c>
 3ac:	fdc42703          	lw	a4,-36(s0)
 3b0:	01e00793          	li	a5,30
 3b4:	02f70463          	beq	a4,a5,3dc <write_seg+0x15c>
 3b8:	1a40006f          	j	55c <write_seg+0x2dc>
 3bc:	18000793          	li	a5,384
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	0ff7f793          	zext.b	a5,a5
 3c8:	00078713          	mv	a4,a5
 3cc:	010007b7          	lui	a5,0x1000
 3d0:	00f767b3          	or	a5,a4,a5
 3d4:	fef42623          	sw	a5,-20(s0)
 3d8:	1840006f          	j	55c <write_seg+0x2dc>
 3dc:	18400793          	li	a5,388
 3e0:	0007c783          	lbu	a5,0(a5) # 1000000 <__global_pointer$+0xffdb24>
 3e4:	0ff7f793          	zext.b	a5,a5
 3e8:	00078713          	mv	a4,a5
 3ec:	020007b7          	lui	a5,0x2000
 3f0:	00f767b3          	or	a5,a4,a5
 3f4:	fef42623          	sw	a5,-20(s0)
 3f8:	1640006f          	j	55c <write_seg+0x2dc>
 3fc:	18800793          	li	a5,392
 400:	0007c783          	lbu	a5,0(a5) # 2000000 <__global_pointer$+0x1ffdb24>
 404:	0ff7f793          	zext.b	a5,a5
 408:	00078713          	mv	a4,a5
 40c:	030007b7          	lui	a5,0x3000
 410:	00f767b3          	or	a5,a4,a5
 414:	fef42623          	sw	a5,-20(s0)
 418:	1440006f          	j	55c <write_seg+0x2dc>
 41c:	18c00793          	li	a5,396
 420:	0007c783          	lbu	a5,0(a5) # 3000000 <__global_pointer$+0x2ffdb24>
 424:	0ff7f793          	zext.b	a5,a5
 428:	00078713          	mv	a4,a5
 42c:	040007b7          	lui	a5,0x4000
 430:	00f767b3          	or	a5,a4,a5
 434:	fef42623          	sw	a5,-20(s0)
 438:	1240006f          	j	55c <write_seg+0x2dc>
 43c:	19000793          	li	a5,400
 440:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffdb24>
 444:	0ff7f793          	zext.b	a5,a5
 448:	00078713          	mv	a4,a5
 44c:	050007b7          	lui	a5,0x5000
 450:	00f767b3          	or	a5,a4,a5
 454:	fef42623          	sw	a5,-20(s0)
 458:	1040006f          	j	55c <write_seg+0x2dc>
 45c:	1a400793          	li	a5,420
 460:	0007c783          	lbu	a5,0(a5) # 5000000 <__global_pointer$+0x4ffdb24>
 464:	0ff7f793          	zext.b	a5,a5
 468:	00078713          	mv	a4,a5
 46c:	060007b7          	lui	a5,0x6000
 470:	00f767b3          	or	a5,a4,a5
 474:	fef42623          	sw	a5,-20(s0)
 478:	0e40006f          	j	55c <write_seg+0x2dc>
 47c:	1a800793          	li	a5,424
 480:	0007c783          	lbu	a5,0(a5) # 6000000 <__global_pointer$+0x5ffdb24>
 484:	0ff7f793          	zext.b	a5,a5
 488:	00078713          	mv	a4,a5
 48c:	070007b7          	lui	a5,0x7000
 490:	00f767b3          	or	a5,a4,a5
 494:	fef42623          	sw	a5,-20(s0)
 498:	0c40006f          	j	55c <write_seg+0x2dc>
 49c:	1ac00793          	li	a5,428
 4a0:	0007c783          	lbu	a5,0(a5) # 7000000 <__global_pointer$+0x6ffdb24>
 4a4:	0ff7f793          	zext.b	a5,a5
 4a8:	00078713          	mv	a4,a5
 4ac:	080007b7          	lui	a5,0x8000
 4b0:	00f767b3          	or	a5,a4,a5
 4b4:	fef42623          	sw	a5,-20(s0)
 4b8:	0a40006f          	j	55c <write_seg+0x2dc>
 4bc:	1b000793          	li	a5,432
 4c0:	0007c783          	lbu	a5,0(a5) # 8000000 <__global_pointer$+0x7ffdb24>
 4c4:	0ff7f793          	zext.b	a5,a5
 4c8:	00078713          	mv	a4,a5
 4cc:	090007b7          	lui	a5,0x9000
 4d0:	00f767b3          	or	a5,a4,a5
 4d4:	fef42623          	sw	a5,-20(s0)
 4d8:	0840006f          	j	55c <write_seg+0x2dc>
 4dc:	19400793          	li	a5,404
 4e0:	0007c783          	lbu	a5,0(a5) # 9000000 <__global_pointer$+0x8ffdb24>
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	00078713          	mv	a4,a5
 4ec:	0a0007b7          	lui	a5,0xa000
 4f0:	00f767b3          	or	a5,a4,a5
 4f4:	fef42623          	sw	a5,-20(s0)
 4f8:	0640006f          	j	55c <write_seg+0x2dc>
 4fc:	19800793          	li	a5,408
 500:	0007c783          	lbu	a5,0(a5) # a000000 <__global_pointer$+0x9ffdb24>
 504:	0ff7f793          	zext.b	a5,a5
 508:	00078713          	mv	a4,a5
 50c:	0b0007b7          	lui	a5,0xb000
 510:	00f767b3          	or	a5,a4,a5
 514:	fef42623          	sw	a5,-20(s0)
 518:	0440006f          	j	55c <write_seg+0x2dc>
 51c:	19c00793          	li	a5,412
 520:	0007c783          	lbu	a5,0(a5) # b000000 <__global_pointer$+0xaffdb24>
 524:	0ff7f793          	zext.b	a5,a5
 528:	00078713          	mv	a4,a5
 52c:	0c0007b7          	lui	a5,0xc000
 530:	00f767b3          	or	a5,a4,a5
 534:	fef42623          	sw	a5,-20(s0)
 538:	0240006f          	j	55c <write_seg+0x2dc>
 53c:	1a000793          	li	a5,416
 540:	0007c783          	lbu	a5,0(a5) # c000000 <__global_pointer$+0xbffdb24>
 544:	0ff7f793          	zext.b	a5,a5
 548:	00078713          	mv	a4,a5
 54c:	0d0007b7          	lui	a5,0xd000
 550:	00f767b3          	or	a5,a4,a5
 554:	fef42623          	sw	a5,-20(s0)
 558:	00000013          	nop
 55c:	fec42783          	lw	a5,-20(s0)
 560:	00078593          	mv	a1,a5
 564:	e0000537          	lui	a0,0xe0000
 568:	ad5ff0ef          	jal	3c <write>
 56c:	00000013          	nop
 570:	02c12083          	lw	ra,44(sp)
 574:	02812403          	lw	s0,40(sp)
 578:	03010113          	addi	sp,sp,48
 57c:	00008067          	ret

00000580 <handler>:
 580:	f9010113          	addi	sp,sp,-112
 584:	06112623          	sw	ra,108(sp)
 588:	06512423          	sw	t0,104(sp)
 58c:	06612223          	sw	t1,100(sp)
 590:	06712023          	sw	t2,96(sp)
 594:	04812e23          	sw	s0,92(sp)
 598:	04a12c23          	sw	a0,88(sp)
 59c:	04b12a23          	sw	a1,84(sp)
 5a0:	04c12823          	sw	a2,80(sp)
 5a4:	04d12623          	sw	a3,76(sp)
 5a8:	04e12423          	sw	a4,72(sp)
 5ac:	04f12223          	sw	a5,68(sp)
 5b0:	05012023          	sw	a6,64(sp)
 5b4:	03112e23          	sw	a7,60(sp)
 5b8:	03c12c23          	sw	t3,56(sp)
 5bc:	03d12a23          	sw	t4,52(sp)
 5c0:	03e12823          	sw	t5,48(sp)
 5c4:	03f12623          	sw	t6,44(sp)
 5c8:	07010413          	addi	s0,sp,112
 5cc:	16000793          	li	a5,352
 5d0:	0007a783          	lw	a5,0(a5) # d000000 <__global_pointer$+0xcffdb24>
 5d4:	faf42623          	sw	a5,-84(s0)
 5d8:	a00007b7          	lui	a5,0xa0000
 5dc:	f8f42a23          	sw	a5,-108(s0)
 5e0:	f9442783          	lw	a5,-108(s0)
 5e4:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffdb24>
 5e8:	f8f409a3          	sb	a5,-109(s0)
 5ec:	f9344703          	lbu	a4,-109(s0)
 5f0:	0f000793          	li	a5,240
 5f4:	00f71a63          	bne	a4,a5,608 <handler+0x88>
 5f8:	17000793          	li	a5,368
 5fc:	00100713          	li	a4,1
 600:	00e78023          	sb	a4,0(a5)
 604:	48c0006f          	j	a90 <handler+0x510>
 608:	fff00793          	li	a5,-1
 60c:	faf42423          	sw	a5,-88(s0)
 610:	fa042223          	sw	zero,-92(s0)
 614:	0380006f          	j	64c <handler+0xcc>
 618:	fa442783          	lw	a5,-92(s0)
 61c:	00279793          	slli	a5,a5,0x2
 620:	10078793          	addi	a5,a5,256
 624:	0007a783          	lw	a5,0(a5)
 628:	0ff7f793          	zext.b	a5,a5
 62c:	f9344703          	lbu	a4,-109(s0)
 630:	00f71863          	bne	a4,a5,640 <handler+0xc0>
 634:	fa442783          	lw	a5,-92(s0)
 638:	faf42423          	sw	a5,-88(s0)
 63c:	01c0006f          	j	658 <handler+0xd8>
 640:	fa442783          	lw	a5,-92(s0)
 644:	00178793          	addi	a5,a5,1
 648:	faf42223          	sw	a5,-92(s0)
 64c:	fa442703          	lw	a4,-92(s0)
 650:	01400793          	li	a5,20
 654:	fce7d2e3          	bge	a5,a4,618 <handler+0x98>
 658:	fa842703          	lw	a4,-88(s0)
 65c:	fff00793          	li	a5,-1
 660:	06f70863          	beq	a4,a5,6d0 <handler+0x150>
 664:	17000793          	li	a5,368
 668:	0007c783          	lbu	a5,0(a5)
 66c:	0ff7f793          	zext.b	a5,a5
 670:	02078263          	beqz	a5,694 <handler+0x114>
 674:	fa842783          	lw	a5,-88(s0)
 678:	00100713          	li	a4,1
 67c:	00f717b3          	sll	a5,a4,a5
 680:	fff7c793          	not	a5,a5
 684:	fac42703          	lw	a4,-84(s0)
 688:	00f777b3          	and	a5,a4,a5
 68c:	faf42623          	sw	a5,-84(s0)
 690:	01c0006f          	j	6ac <handler+0x12c>
 694:	fa842783          	lw	a5,-88(s0)
 698:	00100713          	li	a4,1
 69c:	00f717b3          	sll	a5,a4,a5
 6a0:	fac42703          	lw	a4,-84(s0)
 6a4:	00f767b3          	or	a5,a4,a5
 6a8:	faf42623          	sw	a5,-84(s0)
 6ac:	fac42783          	lw	a5,-84(s0)
 6b0:	00078593          	mv	a1,a5
 6b4:	16000513          	li	a0,352
 6b8:	985ff0ef          	jal	3c <write>
 6bc:	fac42783          	lw	a5,-84(s0)
 6c0:	00078593          	mv	a1,a5
 6c4:	b0000537          	lui	a0,0xb0000
 6c8:	975ff0ef          	jal	3c <write>
 6cc:	3b40006f          	j	a80 <handler+0x500>
 6d0:	17000793          	li	a5,368
 6d4:	0007c783          	lbu	a5,0(a5)
 6d8:	0ff7f793          	zext.b	a5,a5
 6dc:	3a079263          	bnez	a5,a80 <handler+0x500>
 6e0:	fa042023          	sw	zero,-96(s0)
 6e4:	f8042e23          	sw	zero,-100(s0)
 6e8:	f8042c23          	sw	zero,-104(s0)
 6ec:	f9344783          	lbu	a5,-109(s0)
 6f0:	04d00713          	li	a4,77
 6f4:	32e78a63          	beq	a5,a4,a28 <handler+0x4a8>
 6f8:	04d00713          	li	a4,77
 6fc:	34f74a63          	blt	a4,a5,a50 <handler+0x4d0>
 700:	04600713          	li	a4,70
 704:	28e78263          	beq	a5,a4,988 <handler+0x408>
 708:	04600713          	li	a4,70
 70c:	34f74263          	blt	a4,a5,a50 <handler+0x4d0>
 710:	04500713          	li	a4,69
 714:	28e78e63          	beq	a5,a4,9b0 <handler+0x430>
 718:	04500713          	li	a4,69
 71c:	32f74a63          	blt	a4,a5,a50 <handler+0x4d0>
 720:	04400713          	li	a4,68
 724:	2ce78e63          	beq	a5,a4,a00 <handler+0x480>
 728:	04400713          	li	a4,68
 72c:	32f74263          	blt	a4,a5,a50 <handler+0x4d0>
 730:	04300713          	li	a4,67
 734:	2ae78263          	beq	a5,a4,9d8 <handler+0x458>
 738:	04300713          	li	a4,67
 73c:	30f74a63          	blt	a4,a5,a50 <handler+0x4d0>
 740:	03e00713          	li	a4,62
 744:	20e78e63          	beq	a5,a4,960 <handler+0x3e0>
 748:	03e00713          	li	a4,62
 74c:	30f74263          	blt	a4,a5,a50 <handler+0x4d0>
 750:	03d00713          	li	a4,61
 754:	1ee78263          	beq	a5,a4,938 <handler+0x3b8>
 758:	03d00713          	li	a4,61
 75c:	2ef74a63          	blt	a4,a5,a50 <handler+0x4d0>
 760:	03600713          	li	a4,54
 764:	1ae78663          	beq	a5,a4,910 <handler+0x390>
 768:	03600713          	li	a4,54
 76c:	2ef74263          	blt	a4,a5,a50 <handler+0x4d0>
 770:	02e00713          	li	a4,46
 774:	14e78663          	beq	a5,a4,8c0 <handler+0x340>
 778:	02e00713          	li	a4,46
 77c:	2cf74a63          	blt	a4,a5,a50 <handler+0x4d0>
 780:	02600713          	li	a4,38
 784:	0ae78863          	beq	a5,a4,834 <handler+0x2b4>
 788:	02600713          	li	a4,38
 78c:	2cf74263          	blt	a4,a5,a50 <handler+0x4d0>
 790:	02500713          	li	a4,37
 794:	0ee78663          	beq	a5,a4,880 <handler+0x300>
 798:	02500713          	li	a4,37
 79c:	2af74a63          	blt	a4,a5,a50 <handler+0x4d0>
 7a0:	01600713          	li	a4,22
 7a4:	00e78863          	beq	a5,a4,7b4 <handler+0x234>
 7a8:	01e00713          	li	a4,30
 7ac:	04e78463          	beq	a5,a4,7f4 <handler+0x274>
 7b0:	2a00006f          	j	a50 <handler+0x4d0>
 7b4:	18000793          	li	a5,384
 7b8:	0007c703          	lbu	a4,0(a5)
 7bc:	0ff77713          	zext.b	a4,a4
 7c0:	00170713          	addi	a4,a4,1
 7c4:	0ff77713          	zext.b	a4,a4
 7c8:	00e78023          	sb	a4,0(a5)
 7cc:	18000793          	li	a5,384
 7d0:	0007c783          	lbu	a5,0(a5)
 7d4:	0ff7f713          	zext.b	a4,a5
 7d8:	00400793          	li	a5,4
 7dc:	00e7f663          	bgeu	a5,a4,7e8 <handler+0x268>
 7e0:	18000793          	li	a5,384
 7e4:	00078023          	sb	zero,0(a5)
 7e8:	00100793          	li	a5,1
 7ec:	faf42023          	sw	a5,-96(s0)
 7f0:	2600006f          	j	a50 <handler+0x4d0>
 7f4:	18400793          	li	a5,388
 7f8:	0007c703          	lbu	a4,0(a5)
 7fc:	0ff77713          	zext.b	a4,a4
 800:	00170713          	addi	a4,a4,1
 804:	0ff77713          	zext.b	a4,a4
 808:	00e78023          	sb	a4,0(a5)
 80c:	18400793          	li	a5,388
 810:	0007c783          	lbu	a5,0(a5)
 814:	0ff7f713          	zext.b	a4,a5
 818:	18400793          	li	a5,388
 81c:	00f77713          	andi	a4,a4,15
 820:	0ff77713          	zext.b	a4,a4
 824:	00e78023          	sb	a4,0(a5)
 828:	00100793          	li	a5,1
 82c:	faf42023          	sw	a5,-96(s0)
 830:	2200006f          	j	a50 <handler+0x4d0>
 834:	18800793          	li	a5,392
 838:	0007c783          	lbu	a5,0(a5)
 83c:	0ff7f713          	zext.b	a4,a5
 840:	00700793          	li	a5,7
 844:	00e7fa63          	bgeu	a5,a4,858 <handler+0x2d8>
 848:	18800793          	li	a5,392
 84c:	00100713          	li	a4,1
 850:	00e78023          	sb	a4,0(a5)
 854:	0200006f          	j	874 <handler+0x2f4>
 858:	18800793          	li	a5,392
 85c:	0007c783          	lbu	a5,0(a5)
 860:	0ff7f713          	zext.b	a4,a5
 864:	18800793          	li	a5,392
 868:	00171713          	slli	a4,a4,0x1
 86c:	0ff77713          	zext.b	a4,a4
 870:	00e78023          	sb	a4,0(a5)
 874:	00100793          	li	a5,1
 878:	faf42023          	sw	a5,-96(s0)
 87c:	1d40006f          	j	a50 <handler+0x4d0>
 880:	18c00793          	li	a5,396
 884:	0007c703          	lbu	a4,0(a5)
 888:	0ff77713          	zext.b	a4,a4
 88c:	00170713          	addi	a4,a4,1
 890:	0ff77713          	zext.b	a4,a4
 894:	00e78023          	sb	a4,0(a5)
 898:	18c00793          	li	a5,396
 89c:	0007c783          	lbu	a5,0(a5)
 8a0:	0ff7f713          	zext.b	a4,a5
 8a4:	18c00793          	li	a5,396
 8a8:	00f77713          	andi	a4,a4,15
 8ac:	0ff77713          	zext.b	a4,a4
 8b0:	00e78023          	sb	a4,0(a5)
 8b4:	00100793          	li	a5,1
 8b8:	faf42023          	sw	a5,-96(s0)
 8bc:	1940006f          	j	a50 <handler+0x4d0>
 8c0:	19000793          	li	a5,400
 8c4:	0007c703          	lbu	a4,0(a5)
 8c8:	0ff77713          	zext.b	a4,a4
 8cc:	00170713          	addi	a4,a4,1
 8d0:	0ff77713          	zext.b	a4,a4
 8d4:	00e78023          	sb	a4,0(a5)
 8d8:	19000793          	li	a5,400
 8dc:	0007c783          	lbu	a5,0(a5)
 8e0:	0ff7f713          	zext.b	a4,a5
 8e4:	19000793          	li	a5,400
 8e8:	01f77713          	andi	a4,a4,31
 8ec:	0ff77713          	zext.b	a4,a4
 8f0:	00e78023          	sb	a4,0(a5)
 8f4:	19000793          	li	a5,400
 8f8:	0007c783          	lbu	a5,0(a5)
 8fc:	0ff7f793          	zext.b	a5,a5
 900:	00078593          	mv	a1,a5
 904:	b3000537          	lui	a0,0xb3000
 908:	f34ff0ef          	jal	3c <write>
 90c:	1440006f          	j	a50 <handler+0x4d0>
 910:	1a400793          	li	a5,420
 914:	0007c783          	lbu	a5,0(a5)
 918:	0ff7f713          	zext.b	a4,a5
 91c:	1a400793          	li	a5,420
 920:	01070713          	addi	a4,a4,16
 924:	0ff77713          	zext.b	a4,a4
 928:	00e78023          	sb	a4,0(a5)
 92c:	00100793          	li	a5,1
 930:	f8f42c23          	sw	a5,-104(s0)
 934:	11c0006f          	j	a50 <handler+0x4d0>
 938:	1a800793          	li	a5,424
 93c:	0007c783          	lbu	a5,0(a5)
 940:	0ff7f713          	zext.b	a4,a5
 944:	1a800793          	li	a5,424
 948:	01070713          	addi	a4,a4,16
 94c:	0ff77713          	zext.b	a4,a4
 950:	00e78023          	sb	a4,0(a5)
 954:	00100793          	li	a5,1
 958:	f8f42c23          	sw	a5,-104(s0)
 95c:	0f40006f          	j	a50 <handler+0x4d0>
 960:	1ac00793          	li	a5,428
 964:	0007c783          	lbu	a5,0(a5)
 968:	0ff7f713          	zext.b	a4,a5
 96c:	1ac00793          	li	a5,428
 970:	00870713          	addi	a4,a4,8
 974:	0ff77713          	zext.b	a4,a4
 978:	00e78023          	sb	a4,0(a5)
 97c:	00100793          	li	a5,1
 980:	f8f42c23          	sw	a5,-104(s0)
 984:	0cc0006f          	j	a50 <handler+0x4d0>
 988:	1b000793          	li	a5,432
 98c:	0007c783          	lbu	a5,0(a5)
 990:	0ff7f713          	zext.b	a4,a5
 994:	1b000793          	li	a5,432
 998:	01070713          	addi	a4,a4,16
 99c:	0ff77713          	zext.b	a4,a4
 9a0:	00e78023          	sb	a4,0(a5)
 9a4:	00100793          	li	a5,1
 9a8:	f8f42c23          	sw	a5,-104(s0)
 9ac:	0a40006f          	j	a50 <handler+0x4d0>
 9b0:	19400793          	li	a5,404
 9b4:	0007c783          	lbu	a5,0(a5)
 9b8:	0ff7f713          	zext.b	a4,a5
 9bc:	19400793          	li	a5,404
 9c0:	01070713          	addi	a4,a4,16
 9c4:	0ff77713          	zext.b	a4,a4
 9c8:	00e78023          	sb	a4,0(a5)
 9cc:	00100793          	li	a5,1
 9d0:	f8f42e23          	sw	a5,-100(s0)
 9d4:	07c0006f          	j	a50 <handler+0x4d0>
 9d8:	19800793          	li	a5,408
 9dc:	0007c783          	lbu	a5,0(a5)
 9e0:	0ff7f713          	zext.b	a4,a5
 9e4:	19800793          	li	a5,408
 9e8:	01070713          	addi	a4,a4,16
 9ec:	0ff77713          	zext.b	a4,a4
 9f0:	00e78023          	sb	a4,0(a5)
 9f4:	00100793          	li	a5,1
 9f8:	f8f42e23          	sw	a5,-100(s0)
 9fc:	0540006f          	j	a50 <handler+0x4d0>
 a00:	19c00793          	li	a5,412
 a04:	0007c783          	lbu	a5,0(a5)
 a08:	0ff7f713          	zext.b	a4,a5
 a0c:	19c00793          	li	a5,412
 a10:	01070713          	addi	a4,a4,16
 a14:	0ff77713          	zext.b	a4,a4
 a18:	00e78023          	sb	a4,0(a5)
 a1c:	00100793          	li	a5,1
 a20:	f8f42e23          	sw	a5,-100(s0)
 a24:	02c0006f          	j	a50 <handler+0x4d0>
 a28:	1a000793          	li	a5,416
 a2c:	0007c783          	lbu	a5,0(a5)
 a30:	0ff7f713          	zext.b	a4,a5
 a34:	1a000793          	li	a5,416
 a38:	01070713          	addi	a4,a4,16
 a3c:	0ff77713          	zext.b	a4,a4
 a40:	00e78023          	sb	a4,0(a5)
 a44:	00100793          	li	a5,1
 a48:	f8f42e23          	sw	a5,-100(s0)
 a4c:	00000013          	nop
 a50:	fa042783          	lw	a5,-96(s0)
 a54:	00078463          	beqz	a5,a5c <handler+0x4dc>
 a58:	ea4ff0ef          	jal	fc <write_ctrl>
 a5c:	f9c42783          	lw	a5,-100(s0)
 a60:	00078463          	beqz	a5,a68 <handler+0x4e8>
 a64:	f1cff0ef          	jal	180 <write_adsr>
 a68:	f9842783          	lw	a5,-104(s0)
 a6c:	00078463          	beqz	a5,a74 <handler+0x4f4>
 a70:	f90ff0ef          	jal	200 <write_piano>
 a74:	f9344783          	lbu	a5,-109(s0)
 a78:	00078513          	mv	a0,a5
 a7c:	805ff0ef          	jal	280 <write_seg>
 a80:	17000793          	li	a5,368
 a84:	00078023          	sb	zero,0(a5)
 a88:	fac42503          	lw	a0,-84(s0)
 a8c:	e30ff0ef          	jal	bc <update_keys>
 a90:	06c12083          	lw	ra,108(sp)
 a94:	06812283          	lw	t0,104(sp)
 a98:	06412303          	lw	t1,100(sp)
 a9c:	06012383          	lw	t2,96(sp)
 aa0:	05c12403          	lw	s0,92(sp)
 aa4:	05812503          	lw	a0,88(sp)
 aa8:	05412583          	lw	a1,84(sp)
 aac:	05012603          	lw	a2,80(sp)
 ab0:	04c12683          	lw	a3,76(sp)
 ab4:	04812703          	lw	a4,72(sp)
 ab8:	04412783          	lw	a5,68(sp)
 abc:	04012803          	lw	a6,64(sp)
 ac0:	03c12883          	lw	a7,60(sp)
 ac4:	03812e03          	lw	t3,56(sp)
 ac8:	03412e83          	lw	t4,52(sp)
 acc:	03012f03          	lw	t5,48(sp)
 ad0:	02c12f83          	lw	t6,44(sp)
 ad4:	07010113          	addi	sp,sp,112
 ad8:	30200073          	mret

00000adc <init>:
 adc:	ff010113          	addi	sp,sp,-16
 ae0:	00112623          	sw	ra,12(sp)
 ae4:	00812423          	sw	s0,8(sp)
 ae8:	01010413          	addi	s0,sp,16
 aec:	01a00593          	li	a1,26
 af0:	10000513          	li	a0,256
 af4:	d48ff0ef          	jal	3c <write>
 af8:	02200593          	li	a1,34
 afc:	10400513          	li	a0,260
 b00:	d3cff0ef          	jal	3c <write>
 b04:	02100593          	li	a1,33
 b08:	10800513          	li	a0,264
 b0c:	d30ff0ef          	jal	3c <write>
 b10:	02a00593          	li	a1,42
 b14:	10c00513          	li	a0,268
 b18:	d24ff0ef          	jal	3c <write>
 b1c:	03200593          	li	a1,50
 b20:	11000513          	li	a0,272
 b24:	d18ff0ef          	jal	3c <write>
 b28:	03100593          	li	a1,49
 b2c:	11400513          	li	a0,276
 b30:	d0cff0ef          	jal	3c <write>
 b34:	03a00593          	li	a1,58
 b38:	11800513          	li	a0,280
 b3c:	d00ff0ef          	jal	3c <write>
 b40:	01c00593          	li	a1,28
 b44:	11c00513          	li	a0,284
 b48:	cf4ff0ef          	jal	3c <write>
 b4c:	01b00593          	li	a1,27
 b50:	12000513          	li	a0,288
 b54:	ce8ff0ef          	jal	3c <write>
 b58:	02300593          	li	a1,35
 b5c:	12400513          	li	a0,292
 b60:	cdcff0ef          	jal	3c <write>
 b64:	02b00593          	li	a1,43
 b68:	12800513          	li	a0,296
 b6c:	cd0ff0ef          	jal	3c <write>
 b70:	03400593          	li	a1,52
 b74:	12c00513          	li	a0,300
 b78:	cc4ff0ef          	jal	3c <write>
 b7c:	03300593          	li	a1,51
 b80:	13000513          	li	a0,304
 b84:	cb8ff0ef          	jal	3c <write>
 b88:	03b00593          	li	a1,59
 b8c:	13400513          	li	a0,308
 b90:	cacff0ef          	jal	3c <write>
 b94:	01500593          	li	a1,21
 b98:	13800513          	li	a0,312
 b9c:	ca0ff0ef          	jal	3c <write>
 ba0:	01d00593          	li	a1,29
 ba4:	13c00513          	li	a0,316
 ba8:	c94ff0ef          	jal	3c <write>
 bac:	02400593          	li	a1,36
 bb0:	14000513          	li	a0,320
 bb4:	c88ff0ef          	jal	3c <write>
 bb8:	02d00593          	li	a1,45
 bbc:	14400513          	li	a0,324
 bc0:	c7cff0ef          	jal	3c <write>
 bc4:	02c00593          	li	a1,44
 bc8:	14800513          	li	a0,328
 bcc:	c70ff0ef          	jal	3c <write>
 bd0:	03500593          	li	a1,53
 bd4:	14c00513          	li	a0,332
 bd8:	c64ff0ef          	jal	3c <write>
 bdc:	03c00593          	li	a1,60
 be0:	15000513          	li	a0,336
 be4:	c58ff0ef          	jal	3c <write>
 be8:	18000793          	li	a5,384
 bec:	00078023          	sb	zero,0(a5)
 bf0:	18400793          	li	a5,388
 bf4:	00800713          	li	a4,8
 bf8:	00e78023          	sb	a4,0(a5)
 bfc:	18800793          	li	a5,392
 c00:	00400713          	li	a4,4
 c04:	00e78023          	sb	a4,0(a5)
 c08:	18c00793          	li	a5,396
 c0c:	00700713          	li	a4,7
 c10:	00e78023          	sb	a4,0(a5)
 c14:	19000793          	li	a5,400
 c18:	01000713          	li	a4,16
 c1c:	00e78023          	sb	a4,0(a5)
 c20:	19400793          	li	a5,404
 c24:	01400713          	li	a4,20
 c28:	00e78023          	sb	a4,0(a5)
 c2c:	19800793          	li	a5,408
 c30:	06400713          	li	a4,100
 c34:	00e78023          	sb	a4,0(a5)
 c38:	19c00793          	li	a5,412
 c3c:	fff00713          	li	a4,-1
 c40:	00e78023          	sb	a4,0(a5)
 c44:	1a000793          	li	a5,416
 c48:	06400713          	li	a4,100
 c4c:	00e78023          	sb	a4,0(a5)
 c50:	1a400793          	li	a5,420
 c54:	f8000713          	li	a4,-128
 c58:	00e78023          	sb	a4,0(a5)
 c5c:	1a800793          	li	a5,424
 c60:	fc800713          	li	a4,-56
 c64:	00e78023          	sb	a4,0(a5)
 c68:	1ac00793          	li	a5,428
 c6c:	01000713          	li	a4,16
 c70:	00e78023          	sb	a4,0(a5)
 c74:	1b000793          	li	a5,432
 c78:	f8000713          	li	a4,-128
 c7c:	00e78023          	sb	a4,0(a5)
 c80:	00000593          	li	a1,0
 c84:	b0000537          	lui	a0,0xb0000
 c88:	bb4ff0ef          	jal	3c <write>
 c8c:	c70ff0ef          	jal	fc <write_ctrl>
 c90:	cf0ff0ef          	jal	180 <write_adsr>
 c94:	19000793          	li	a5,400
 c98:	0007c783          	lbu	a5,0(a5)
 c9c:	0ff7f793          	zext.b	a5,a5
 ca0:	00078593          	mv	a1,a5
 ca4:	b3000537          	lui	a0,0xb3000
 ca8:	b94ff0ef          	jal	3c <write>
 cac:	d54ff0ef          	jal	200 <write_piano>
 cb0:	00000013          	nop
 cb4:	00c12083          	lw	ra,12(sp)
 cb8:	00812403          	lw	s0,8(sp)
 cbc:	01010113          	addi	sp,sp,16
 cc0:	00008067          	ret

00000cc4 <main>:
 cc4:	ff010113          	addi	sp,sp,-16
 cc8:	00112623          	sw	ra,12(sp)
 ccc:	00812423          	sw	s0,8(sp)
 cd0:	01010413          	addi	s0,sp,16
 cd4:	e09ff0ef          	jal	adc <init>
 cd8:	0000006f          	j	cd8 <main+0x14>
