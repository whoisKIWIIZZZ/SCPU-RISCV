
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	4b9000ef          	jal	cec <main>
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
  dc:	fff70713          	addi	a4,a4,-1 # 1fffff <__global_pointer$+0x1fdafb>
  e0:	00e6f733          	and	a4,a3,a4
  e4:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffdafc>
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
 3e0:	0007c783          	lbu	a5,0(a5) # 1000000 <__global_pointer$+0xffdafc>
 3e4:	0ff7f793          	zext.b	a5,a5
 3e8:	00078713          	mv	a4,a5
 3ec:	020007b7          	lui	a5,0x2000
 3f0:	00f767b3          	or	a5,a4,a5
 3f4:	fef42623          	sw	a5,-20(s0)
 3f8:	1640006f          	j	55c <write_seg+0x2dc>
 3fc:	18800793          	li	a5,392
 400:	0007c783          	lbu	a5,0(a5) # 2000000 <__global_pointer$+0x1ffdafc>
 404:	0ff7f793          	zext.b	a5,a5
 408:	00078713          	mv	a4,a5
 40c:	030007b7          	lui	a5,0x3000
 410:	00f767b3          	or	a5,a4,a5
 414:	fef42623          	sw	a5,-20(s0)
 418:	1440006f          	j	55c <write_seg+0x2dc>
 41c:	18c00793          	li	a5,396
 420:	0007c783          	lbu	a5,0(a5) # 3000000 <__global_pointer$+0x2ffdafc>
 424:	0ff7f793          	zext.b	a5,a5
 428:	00078713          	mv	a4,a5
 42c:	040007b7          	lui	a5,0x4000
 430:	00f767b3          	or	a5,a4,a5
 434:	fef42623          	sw	a5,-20(s0)
 438:	1240006f          	j	55c <write_seg+0x2dc>
 43c:	19000793          	li	a5,400
 440:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffdafc>
 444:	0ff7f793          	zext.b	a5,a5
 448:	00078713          	mv	a4,a5
 44c:	050007b7          	lui	a5,0x5000
 450:	00f767b3          	or	a5,a4,a5
 454:	fef42623          	sw	a5,-20(s0)
 458:	1040006f          	j	55c <write_seg+0x2dc>
 45c:	1a400793          	li	a5,420
 460:	0007c783          	lbu	a5,0(a5) # 5000000 <__global_pointer$+0x4ffdafc>
 464:	0ff7f793          	zext.b	a5,a5
 468:	00078713          	mv	a4,a5
 46c:	060007b7          	lui	a5,0x6000
 470:	00f767b3          	or	a5,a4,a5
 474:	fef42623          	sw	a5,-20(s0)
 478:	0e40006f          	j	55c <write_seg+0x2dc>
 47c:	1a800793          	li	a5,424
 480:	0007c783          	lbu	a5,0(a5) # 6000000 <__global_pointer$+0x5ffdafc>
 484:	0ff7f793          	zext.b	a5,a5
 488:	00078713          	mv	a4,a5
 48c:	070007b7          	lui	a5,0x7000
 490:	00f767b3          	or	a5,a4,a5
 494:	fef42623          	sw	a5,-20(s0)
 498:	0c40006f          	j	55c <write_seg+0x2dc>
 49c:	1ac00793          	li	a5,428
 4a0:	0007c783          	lbu	a5,0(a5) # 7000000 <__global_pointer$+0x6ffdafc>
 4a4:	0ff7f793          	zext.b	a5,a5
 4a8:	00078713          	mv	a4,a5
 4ac:	080007b7          	lui	a5,0x8000
 4b0:	00f767b3          	or	a5,a4,a5
 4b4:	fef42623          	sw	a5,-20(s0)
 4b8:	0a40006f          	j	55c <write_seg+0x2dc>
 4bc:	1b000793          	li	a5,432
 4c0:	0007c783          	lbu	a5,0(a5) # 8000000 <__global_pointer$+0x7ffdafc>
 4c4:	0ff7f793          	zext.b	a5,a5
 4c8:	00078713          	mv	a4,a5
 4cc:	090007b7          	lui	a5,0x9000
 4d0:	00f767b3          	or	a5,a4,a5
 4d4:	fef42623          	sw	a5,-20(s0)
 4d8:	0840006f          	j	55c <write_seg+0x2dc>
 4dc:	19400793          	li	a5,404
 4e0:	0007c783          	lbu	a5,0(a5) # 9000000 <__global_pointer$+0x8ffdafc>
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	00078713          	mv	a4,a5
 4ec:	0a0007b7          	lui	a5,0xa000
 4f0:	00f767b3          	or	a5,a4,a5
 4f4:	fef42623          	sw	a5,-20(s0)
 4f8:	0640006f          	j	55c <write_seg+0x2dc>
 4fc:	19800793          	li	a5,408
 500:	0007c783          	lbu	a5,0(a5) # a000000 <__global_pointer$+0x9ffdafc>
 504:	0ff7f793          	zext.b	a5,a5
 508:	00078713          	mv	a4,a5
 50c:	0b0007b7          	lui	a5,0xb000
 510:	00f767b3          	or	a5,a4,a5
 514:	fef42623          	sw	a5,-20(s0)
 518:	0440006f          	j	55c <write_seg+0x2dc>
 51c:	19c00793          	li	a5,412
 520:	0007c783          	lbu	a5,0(a5) # b000000 <__global_pointer$+0xaffdafc>
 524:	0ff7f793          	zext.b	a5,a5
 528:	00078713          	mv	a4,a5
 52c:	0c0007b7          	lui	a5,0xc000
 530:	00f767b3          	or	a5,a4,a5
 534:	fef42623          	sw	a5,-20(s0)
 538:	0240006f          	j	55c <write_seg+0x2dc>
 53c:	1a000793          	li	a5,416
 540:	0007c783          	lbu	a5,0(a5) # c000000 <__global_pointer$+0xbffdafc>
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
 5d0:	0007a783          	lw	a5,0(a5) # d000000 <__global_pointer$+0xcffdafc>
 5d4:	faf42623          	sw	a5,-84(s0)
 5d8:	a00007b7          	lui	a5,0xa0000
 5dc:	f8f42a23          	sw	a5,-108(s0)
 5e0:	f9442783          	lw	a5,-108(s0)
 5e4:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffdafc>
 5e8:	f8f409a3          	sb	a5,-109(s0)
 5ec:	f9344703          	lbu	a4,-109(s0)
 5f0:	0f000793          	li	a5,240
 5f4:	00f71a63          	bne	a4,a5,608 <handler+0x88>
 5f8:	17000793          	li	a5,368
 5fc:	00100713          	li	a4,1
 600:	00e78023          	sb	a4,0(a5)
 604:	4a80006f          	j	aac <handler+0x52c>
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
 660:	08f70663          	beq	a4,a5,6ec <handler+0x16c>
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
 6cc:	fac42783          	lw	a5,-84(s0)
 6d0:	0087d713          	srli	a4,a5,0x8
 6d4:	f9344783          	lbu	a5,-109(s0)
 6d8:	00f767b3          	or	a5,a4,a5
 6dc:	00078593          	mv	a1,a5
 6e0:	e0000537          	lui	a0,0xe0000
 6e4:	959ff0ef          	jal	3c <write>
 6e8:	3b40006f          	j	a9c <handler+0x51c>
 6ec:	17000793          	li	a5,368
 6f0:	0007c783          	lbu	a5,0(a5)
 6f4:	0ff7f793          	zext.b	a5,a5
 6f8:	3a079263          	bnez	a5,a9c <handler+0x51c>
 6fc:	fa042023          	sw	zero,-96(s0)
 700:	f8042e23          	sw	zero,-100(s0)
 704:	f8042c23          	sw	zero,-104(s0)
 708:	f9344783          	lbu	a5,-109(s0)
 70c:	04d00713          	li	a4,77
 710:	32e78a63          	beq	a5,a4,a44 <handler+0x4c4>
 714:	04d00713          	li	a4,77
 718:	34f74a63          	blt	a4,a5,a6c <handler+0x4ec>
 71c:	04600713          	li	a4,70
 720:	28e78263          	beq	a5,a4,9a4 <handler+0x424>
 724:	04600713          	li	a4,70
 728:	34f74263          	blt	a4,a5,a6c <handler+0x4ec>
 72c:	04500713          	li	a4,69
 730:	28e78e63          	beq	a5,a4,9cc <handler+0x44c>
 734:	04500713          	li	a4,69
 738:	32f74a63          	blt	a4,a5,a6c <handler+0x4ec>
 73c:	04400713          	li	a4,68
 740:	2ce78e63          	beq	a5,a4,a1c <handler+0x49c>
 744:	04400713          	li	a4,68
 748:	32f74263          	blt	a4,a5,a6c <handler+0x4ec>
 74c:	04300713          	li	a4,67
 750:	2ae78263          	beq	a5,a4,9f4 <handler+0x474>
 754:	04300713          	li	a4,67
 758:	30f74a63          	blt	a4,a5,a6c <handler+0x4ec>
 75c:	03e00713          	li	a4,62
 760:	20e78e63          	beq	a5,a4,97c <handler+0x3fc>
 764:	03e00713          	li	a4,62
 768:	30f74263          	blt	a4,a5,a6c <handler+0x4ec>
 76c:	03d00713          	li	a4,61
 770:	1ee78263          	beq	a5,a4,954 <handler+0x3d4>
 774:	03d00713          	li	a4,61
 778:	2ef74a63          	blt	a4,a5,a6c <handler+0x4ec>
 77c:	03600713          	li	a4,54
 780:	1ae78663          	beq	a5,a4,92c <handler+0x3ac>
 784:	03600713          	li	a4,54
 788:	2ef74263          	blt	a4,a5,a6c <handler+0x4ec>
 78c:	02e00713          	li	a4,46
 790:	14e78663          	beq	a5,a4,8dc <handler+0x35c>
 794:	02e00713          	li	a4,46
 798:	2cf74a63          	blt	a4,a5,a6c <handler+0x4ec>
 79c:	02600713          	li	a4,38
 7a0:	0ae78863          	beq	a5,a4,850 <handler+0x2d0>
 7a4:	02600713          	li	a4,38
 7a8:	2cf74263          	blt	a4,a5,a6c <handler+0x4ec>
 7ac:	02500713          	li	a4,37
 7b0:	0ee78663          	beq	a5,a4,89c <handler+0x31c>
 7b4:	02500713          	li	a4,37
 7b8:	2af74a63          	blt	a4,a5,a6c <handler+0x4ec>
 7bc:	01600713          	li	a4,22
 7c0:	00e78863          	beq	a5,a4,7d0 <handler+0x250>
 7c4:	01e00713          	li	a4,30
 7c8:	04e78463          	beq	a5,a4,810 <handler+0x290>
 7cc:	2a00006f          	j	a6c <handler+0x4ec>
 7d0:	18000793          	li	a5,384
 7d4:	0007c703          	lbu	a4,0(a5)
 7d8:	0ff77713          	zext.b	a4,a4
 7dc:	00170713          	addi	a4,a4,1
 7e0:	0ff77713          	zext.b	a4,a4
 7e4:	00e78023          	sb	a4,0(a5)
 7e8:	18000793          	li	a5,384
 7ec:	0007c783          	lbu	a5,0(a5)
 7f0:	0ff7f713          	zext.b	a4,a5
 7f4:	00400793          	li	a5,4
 7f8:	00e7f663          	bgeu	a5,a4,804 <handler+0x284>
 7fc:	18000793          	li	a5,384
 800:	00078023          	sb	zero,0(a5)
 804:	00100793          	li	a5,1
 808:	faf42023          	sw	a5,-96(s0)
 80c:	2600006f          	j	a6c <handler+0x4ec>
 810:	18400793          	li	a5,388
 814:	0007c703          	lbu	a4,0(a5)
 818:	0ff77713          	zext.b	a4,a4
 81c:	00170713          	addi	a4,a4,1
 820:	0ff77713          	zext.b	a4,a4
 824:	00e78023          	sb	a4,0(a5)
 828:	18400793          	li	a5,388
 82c:	0007c783          	lbu	a5,0(a5)
 830:	0ff7f713          	zext.b	a4,a5
 834:	18400793          	li	a5,388
 838:	00f77713          	andi	a4,a4,15
 83c:	0ff77713          	zext.b	a4,a4
 840:	00e78023          	sb	a4,0(a5)
 844:	00100793          	li	a5,1
 848:	faf42023          	sw	a5,-96(s0)
 84c:	2200006f          	j	a6c <handler+0x4ec>
 850:	18800793          	li	a5,392
 854:	0007c783          	lbu	a5,0(a5)
 858:	0ff7f713          	zext.b	a4,a5
 85c:	00700793          	li	a5,7
 860:	00e7fa63          	bgeu	a5,a4,874 <handler+0x2f4>
 864:	18800793          	li	a5,392
 868:	00100713          	li	a4,1
 86c:	00e78023          	sb	a4,0(a5)
 870:	0200006f          	j	890 <handler+0x310>
 874:	18800793          	li	a5,392
 878:	0007c783          	lbu	a5,0(a5)
 87c:	0ff7f713          	zext.b	a4,a5
 880:	18800793          	li	a5,392
 884:	00171713          	slli	a4,a4,0x1
 888:	0ff77713          	zext.b	a4,a4
 88c:	00e78023          	sb	a4,0(a5)
 890:	00100793          	li	a5,1
 894:	faf42023          	sw	a5,-96(s0)
 898:	1d40006f          	j	a6c <handler+0x4ec>
 89c:	18c00793          	li	a5,396
 8a0:	0007c703          	lbu	a4,0(a5)
 8a4:	0ff77713          	zext.b	a4,a4
 8a8:	00170713          	addi	a4,a4,1
 8ac:	0ff77713          	zext.b	a4,a4
 8b0:	00e78023          	sb	a4,0(a5)
 8b4:	18c00793          	li	a5,396
 8b8:	0007c783          	lbu	a5,0(a5)
 8bc:	0ff7f713          	zext.b	a4,a5
 8c0:	18c00793          	li	a5,396
 8c4:	00f77713          	andi	a4,a4,15
 8c8:	0ff77713          	zext.b	a4,a4
 8cc:	00e78023          	sb	a4,0(a5)
 8d0:	00100793          	li	a5,1
 8d4:	faf42023          	sw	a5,-96(s0)
 8d8:	1940006f          	j	a6c <handler+0x4ec>
 8dc:	19000793          	li	a5,400
 8e0:	0007c703          	lbu	a4,0(a5)
 8e4:	0ff77713          	zext.b	a4,a4
 8e8:	00170713          	addi	a4,a4,1
 8ec:	0ff77713          	zext.b	a4,a4
 8f0:	00e78023          	sb	a4,0(a5)
 8f4:	19000793          	li	a5,400
 8f8:	0007c783          	lbu	a5,0(a5)
 8fc:	0ff7f713          	zext.b	a4,a5
 900:	19000793          	li	a5,400
 904:	01f77713          	andi	a4,a4,31
 908:	0ff77713          	zext.b	a4,a4
 90c:	00e78023          	sb	a4,0(a5)
 910:	19000793          	li	a5,400
 914:	0007c783          	lbu	a5,0(a5)
 918:	0ff7f793          	zext.b	a5,a5
 91c:	00078593          	mv	a1,a5
 920:	b3000537          	lui	a0,0xb3000
 924:	f18ff0ef          	jal	3c <write>
 928:	1440006f          	j	a6c <handler+0x4ec>
 92c:	1a400793          	li	a5,420
 930:	0007c783          	lbu	a5,0(a5)
 934:	0ff7f713          	zext.b	a4,a5
 938:	1a400793          	li	a5,420
 93c:	01070713          	addi	a4,a4,16
 940:	0ff77713          	zext.b	a4,a4
 944:	00e78023          	sb	a4,0(a5)
 948:	00100793          	li	a5,1
 94c:	f8f42c23          	sw	a5,-104(s0)
 950:	11c0006f          	j	a6c <handler+0x4ec>
 954:	1a800793          	li	a5,424
 958:	0007c783          	lbu	a5,0(a5)
 95c:	0ff7f713          	zext.b	a4,a5
 960:	1a800793          	li	a5,424
 964:	01070713          	addi	a4,a4,16
 968:	0ff77713          	zext.b	a4,a4
 96c:	00e78023          	sb	a4,0(a5)
 970:	00100793          	li	a5,1
 974:	f8f42c23          	sw	a5,-104(s0)
 978:	0f40006f          	j	a6c <handler+0x4ec>
 97c:	1ac00793          	li	a5,428
 980:	0007c783          	lbu	a5,0(a5)
 984:	0ff7f713          	zext.b	a4,a5
 988:	1ac00793          	li	a5,428
 98c:	00870713          	addi	a4,a4,8
 990:	0ff77713          	zext.b	a4,a4
 994:	00e78023          	sb	a4,0(a5)
 998:	00100793          	li	a5,1
 99c:	f8f42c23          	sw	a5,-104(s0)
 9a0:	0cc0006f          	j	a6c <handler+0x4ec>
 9a4:	1b000793          	li	a5,432
 9a8:	0007c783          	lbu	a5,0(a5)
 9ac:	0ff7f713          	zext.b	a4,a5
 9b0:	1b000793          	li	a5,432
 9b4:	01070713          	addi	a4,a4,16
 9b8:	0ff77713          	zext.b	a4,a4
 9bc:	00e78023          	sb	a4,0(a5)
 9c0:	00100793          	li	a5,1
 9c4:	f8f42c23          	sw	a5,-104(s0)
 9c8:	0a40006f          	j	a6c <handler+0x4ec>
 9cc:	19400793          	li	a5,404
 9d0:	0007c783          	lbu	a5,0(a5)
 9d4:	0ff7f713          	zext.b	a4,a5
 9d8:	19400793          	li	a5,404
 9dc:	01070713          	addi	a4,a4,16
 9e0:	0ff77713          	zext.b	a4,a4
 9e4:	00e78023          	sb	a4,0(a5)
 9e8:	00100793          	li	a5,1
 9ec:	f8f42e23          	sw	a5,-100(s0)
 9f0:	07c0006f          	j	a6c <handler+0x4ec>
 9f4:	19800793          	li	a5,408
 9f8:	0007c783          	lbu	a5,0(a5)
 9fc:	0ff7f713          	zext.b	a4,a5
 a00:	19800793          	li	a5,408
 a04:	01070713          	addi	a4,a4,16
 a08:	0ff77713          	zext.b	a4,a4
 a0c:	00e78023          	sb	a4,0(a5)
 a10:	00100793          	li	a5,1
 a14:	f8f42e23          	sw	a5,-100(s0)
 a18:	0540006f          	j	a6c <handler+0x4ec>
 a1c:	19c00793          	li	a5,412
 a20:	0007c783          	lbu	a5,0(a5)
 a24:	0ff7f713          	zext.b	a4,a5
 a28:	19c00793          	li	a5,412
 a2c:	01070713          	addi	a4,a4,16
 a30:	0ff77713          	zext.b	a4,a4
 a34:	00e78023          	sb	a4,0(a5)
 a38:	00100793          	li	a5,1
 a3c:	f8f42e23          	sw	a5,-100(s0)
 a40:	02c0006f          	j	a6c <handler+0x4ec>
 a44:	1a000793          	li	a5,416
 a48:	0007c783          	lbu	a5,0(a5)
 a4c:	0ff7f713          	zext.b	a4,a5
 a50:	1a000793          	li	a5,416
 a54:	01070713          	addi	a4,a4,16
 a58:	0ff77713          	zext.b	a4,a4
 a5c:	00e78023          	sb	a4,0(a5)
 a60:	00100793          	li	a5,1
 a64:	f8f42e23          	sw	a5,-100(s0)
 a68:	00000013          	nop
 a6c:	fa042783          	lw	a5,-96(s0)
 a70:	00078463          	beqz	a5,a78 <handler+0x4f8>
 a74:	e88ff0ef          	jal	fc <write_ctrl>
 a78:	f9c42783          	lw	a5,-100(s0)
 a7c:	00078463          	beqz	a5,a84 <handler+0x504>
 a80:	f00ff0ef          	jal	180 <write_adsr>
 a84:	f9842783          	lw	a5,-104(s0)
 a88:	00078463          	beqz	a5,a90 <handler+0x510>
 a8c:	f74ff0ef          	jal	200 <write_piano>
 a90:	f9344783          	lbu	a5,-109(s0)
 a94:	00078513          	mv	a0,a5
 a98:	fe8ff0ef          	jal	280 <write_seg>
 a9c:	17000793          	li	a5,368
 aa0:	00078023          	sb	zero,0(a5)
 aa4:	fac42503          	lw	a0,-84(s0)
 aa8:	e14ff0ef          	jal	bc <update_keys>
 aac:	06c12083          	lw	ra,108(sp)
 ab0:	06812283          	lw	t0,104(sp)
 ab4:	06412303          	lw	t1,100(sp)
 ab8:	06012383          	lw	t2,96(sp)
 abc:	05c12403          	lw	s0,92(sp)
 ac0:	05812503          	lw	a0,88(sp)
 ac4:	05412583          	lw	a1,84(sp)
 ac8:	05012603          	lw	a2,80(sp)
 acc:	04c12683          	lw	a3,76(sp)
 ad0:	04812703          	lw	a4,72(sp)
 ad4:	04412783          	lw	a5,68(sp)
 ad8:	04012803          	lw	a6,64(sp)
 adc:	03c12883          	lw	a7,60(sp)
 ae0:	03812e03          	lw	t3,56(sp)
 ae4:	03412e83          	lw	t4,52(sp)
 ae8:	03012f03          	lw	t5,48(sp)
 aec:	02c12f83          	lw	t6,44(sp)
 af0:	07010113          	addi	sp,sp,112
 af4:	30200073          	mret

00000af8 <init>:
 af8:	ff010113          	addi	sp,sp,-16
 afc:	00112623          	sw	ra,12(sp)
 b00:	00812423          	sw	s0,8(sp)
 b04:	01010413          	addi	s0,sp,16
 b08:	01a00593          	li	a1,26
 b0c:	10000513          	li	a0,256
 b10:	d2cff0ef          	jal	3c <write>
 b14:	02200593          	li	a1,34
 b18:	10400513          	li	a0,260
 b1c:	d20ff0ef          	jal	3c <write>
 b20:	02100593          	li	a1,33
 b24:	10800513          	li	a0,264
 b28:	d14ff0ef          	jal	3c <write>
 b2c:	02a00593          	li	a1,42
 b30:	10c00513          	li	a0,268
 b34:	d08ff0ef          	jal	3c <write>
 b38:	03200593          	li	a1,50
 b3c:	11000513          	li	a0,272
 b40:	cfcff0ef          	jal	3c <write>
 b44:	03100593          	li	a1,49
 b48:	11400513          	li	a0,276
 b4c:	cf0ff0ef          	jal	3c <write>
 b50:	03a00593          	li	a1,58
 b54:	11800513          	li	a0,280
 b58:	ce4ff0ef          	jal	3c <write>
 b5c:	01c00593          	li	a1,28
 b60:	11c00513          	li	a0,284
 b64:	cd8ff0ef          	jal	3c <write>
 b68:	01b00593          	li	a1,27
 b6c:	12000513          	li	a0,288
 b70:	cccff0ef          	jal	3c <write>
 b74:	02300593          	li	a1,35
 b78:	12400513          	li	a0,292
 b7c:	cc0ff0ef          	jal	3c <write>
 b80:	02b00593          	li	a1,43
 b84:	12800513          	li	a0,296
 b88:	cb4ff0ef          	jal	3c <write>
 b8c:	03400593          	li	a1,52
 b90:	12c00513          	li	a0,300
 b94:	ca8ff0ef          	jal	3c <write>
 b98:	03300593          	li	a1,51
 b9c:	13000513          	li	a0,304
 ba0:	c9cff0ef          	jal	3c <write>
 ba4:	03b00593          	li	a1,59
 ba8:	13400513          	li	a0,308
 bac:	c90ff0ef          	jal	3c <write>
 bb0:	01500593          	li	a1,21
 bb4:	13800513          	li	a0,312
 bb8:	c84ff0ef          	jal	3c <write>
 bbc:	01d00593          	li	a1,29
 bc0:	13c00513          	li	a0,316
 bc4:	c78ff0ef          	jal	3c <write>
 bc8:	02400593          	li	a1,36
 bcc:	14000513          	li	a0,320
 bd0:	c6cff0ef          	jal	3c <write>
 bd4:	02d00593          	li	a1,45
 bd8:	14400513          	li	a0,324
 bdc:	c60ff0ef          	jal	3c <write>
 be0:	02c00593          	li	a1,44
 be4:	14800513          	li	a0,328
 be8:	c54ff0ef          	jal	3c <write>
 bec:	03500593          	li	a1,53
 bf0:	14c00513          	li	a0,332
 bf4:	c48ff0ef          	jal	3c <write>
 bf8:	03c00593          	li	a1,60
 bfc:	15000513          	li	a0,336
 c00:	c3cff0ef          	jal	3c <write>
 c04:	18000793          	li	a5,384
 c08:	00078023          	sb	zero,0(a5)
 c0c:	18400793          	li	a5,388
 c10:	00800713          	li	a4,8
 c14:	00e78023          	sb	a4,0(a5)
 c18:	18800793          	li	a5,392
 c1c:	00400713          	li	a4,4
 c20:	00e78023          	sb	a4,0(a5)
 c24:	18c00793          	li	a5,396
 c28:	00700713          	li	a4,7
 c2c:	00e78023          	sb	a4,0(a5)
 c30:	19000793          	li	a5,400
 c34:	01000713          	li	a4,16
 c38:	00e78023          	sb	a4,0(a5)
 c3c:	19400793          	li	a5,404
 c40:	01400713          	li	a4,20
 c44:	00e78023          	sb	a4,0(a5)
 c48:	19800793          	li	a5,408
 c4c:	06400713          	li	a4,100
 c50:	00e78023          	sb	a4,0(a5)
 c54:	19c00793          	li	a5,412
 c58:	fff00713          	li	a4,-1
 c5c:	00e78023          	sb	a4,0(a5)
 c60:	1a000793          	li	a5,416
 c64:	06400713          	li	a4,100
 c68:	00e78023          	sb	a4,0(a5)
 c6c:	1a400793          	li	a5,420
 c70:	f8000713          	li	a4,-128
 c74:	00e78023          	sb	a4,0(a5)
 c78:	1a800793          	li	a5,424
 c7c:	fc800713          	li	a4,-56
 c80:	00e78023          	sb	a4,0(a5)
 c84:	1ac00793          	li	a5,428
 c88:	01000713          	li	a4,16
 c8c:	00e78023          	sb	a4,0(a5)
 c90:	1b000793          	li	a5,432
 c94:	f8000713          	li	a4,-128
 c98:	00e78023          	sb	a4,0(a5)
 c9c:	00000593          	li	a1,0
 ca0:	16000513          	li	a0,352
 ca4:	b98ff0ef          	jal	3c <write>
 ca8:	00000593          	li	a1,0
 cac:	b0000537          	lui	a0,0xb0000
 cb0:	b8cff0ef          	jal	3c <write>
 cb4:	c48ff0ef          	jal	fc <write_ctrl>
 cb8:	cc8ff0ef          	jal	180 <write_adsr>
 cbc:	19000793          	li	a5,400
 cc0:	0007c783          	lbu	a5,0(a5)
 cc4:	0ff7f793          	zext.b	a5,a5
 cc8:	00078593          	mv	a1,a5
 ccc:	b3000537          	lui	a0,0xb3000
 cd0:	b6cff0ef          	jal	3c <write>
 cd4:	d2cff0ef          	jal	200 <write_piano>
 cd8:	00000013          	nop
 cdc:	00c12083          	lw	ra,12(sp)
 ce0:	00812403          	lw	s0,8(sp)
 ce4:	01010113          	addi	sp,sp,16
 ce8:	00008067          	ret

00000cec <main>:
 cec:	ff010113          	addi	sp,sp,-16
 cf0:	00112623          	sw	ra,12(sp)
 cf4:	00812423          	sw	s0,8(sp)
 cf8:	01010413          	addi	s0,sp,16
 cfc:	dfdff0ef          	jal	af8 <init>
 d00:	0000006f          	j	d00 <main+0x14>
