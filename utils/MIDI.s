
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	591000ef          	jal	dc4 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <read>:
  3c:	fd010113          	addi	sp,sp,-48
  40:	02112623          	sw	ra,44(sp)
  44:	02812423          	sw	s0,40(sp)
  48:	03010413          	addi	s0,sp,48
  4c:	fca42e23          	sw	a0,-36(s0)
  50:	fcb42c23          	sw	a1,-40(s0)
  54:	fdc42783          	lw	a5,-36(s0)
  58:	fef42623          	sw	a5,-20(s0)
  5c:	fec42783          	lw	a5,-20(s0)
  60:	0007a703          	lw	a4,0(a5)
  64:	fd842783          	lw	a5,-40(s0)
  68:	00e7a023          	sw	a4,0(a5)
  6c:	00000013          	nop
  70:	02c12083          	lw	ra,44(sp)
  74:	02812403          	lw	s0,40(sp)
  78:	03010113          	addi	sp,sp,48
  7c:	00008067          	ret

00000080 <write>:
  80:	fd010113          	addi	sp,sp,-48
  84:	02112623          	sw	ra,44(sp)
  88:	02812423          	sw	s0,40(sp)
  8c:	03010413          	addi	s0,sp,48
  90:	fca42e23          	sw	a0,-36(s0)
  94:	fcb42c23          	sw	a1,-40(s0)
  98:	fdc42783          	lw	a5,-36(s0)
  9c:	fef42623          	sw	a5,-20(s0)
  a0:	fec42783          	lw	a5,-20(s0)
  a4:	fd842703          	lw	a4,-40(s0)
  a8:	00e7a023          	sw	a4,0(a5)
  ac:	00000013          	nop
  b0:	02c12083          	lw	ra,44(sp)
  b4:	02812403          	lw	s0,40(sp)
  b8:	03010113          	addi	sp,sp,48
  bc:	00008067          	ret

000000c0 <wait>:
  c0:	fe010113          	addi	sp,sp,-32
  c4:	00112e23          	sw	ra,28(sp)
  c8:	00812c23          	sw	s0,24(sp)
  cc:	02010413          	addi	s0,sp,32
  d0:	fea42623          	sw	a0,-20(s0)
  d4:	fec42783          	lw	a5,-20(s0)
  d8:	fff78793          	addi	a5,a5,-1
  dc:	fe079ee3          	bnez	a5,d8 <wait+0x18>
  e0:	fef42623          	sw	a5,-20(s0)
  e4:	00000013          	nop
  e8:	01c12083          	lw	ra,28(sp)
  ec:	01812403          	lw	s0,24(sp)
  f0:	02010113          	addi	sp,sp,32
  f4:	00008067          	ret

000000f8 <update_keys>:
  f8:	fe010113          	addi	sp,sp,-32
  fc:	00112e23          	sw	ra,28(sp)
 100:	00812c23          	sw	s0,24(sp)
 104:	02010413          	addi	s0,sp,32
 108:	fea42623          	sw	a0,-20(s0)
 10c:	c00007b7          	lui	a5,0xc0000
 110:	fec42683          	lw	a3,-20(s0)
 114:	00200737          	lui	a4,0x200
 118:	fff70713          	addi	a4,a4,-1 # 1fffff <__global_pointer$+0x1fda23>
 11c:	00e6f733          	and	a4,a3,a4
 120:	00e7a023          	sw	a4,0(a5) # c0000000 <__global_pointer$+0xbfffda24>
 124:	00000013          	nop
 128:	01c12083          	lw	ra,28(sp)
 12c:	01812403          	lw	s0,24(sp)
 130:	02010113          	addi	sp,sp,32
 134:	00008067          	ret

00000138 <write_ctrl>:
 138:	fe010113          	addi	sp,sp,-32
 13c:	00112e23          	sw	ra,28(sp)
 140:	00812c23          	sw	s0,24(sp)
 144:	02010413          	addi	s0,sp,32
 148:	18000793          	li	a5,384
 14c:	0007c783          	lbu	a5,0(a5)
 150:	0ff7f793          	zext.b	a5,a5
 154:	01a79713          	slli	a4,a5,0x1a
 158:	18c00793          	li	a5,396
 15c:	0007c783          	lbu	a5,0(a5)
 160:	0ff7f793          	zext.b	a5,a5
 164:	01679793          	slli	a5,a5,0x16
 168:	00f76733          	or	a4,a4,a5
 16c:	18800793          	li	a5,392
 170:	0007c783          	lbu	a5,0(a5)
 174:	0ff7f793          	zext.b	a5,a5
 178:	01279793          	slli	a5,a5,0x12
 17c:	00f76733          	or	a4,a4,a5
 180:	18400793          	li	a5,388
 184:	0007c783          	lbu	a5,0(a5)
 188:	0ff7f793          	zext.b	a5,a5
 18c:	00e79793          	slli	a5,a5,0xe
 190:	00f767b3          	or	a5,a4,a5
 194:	fef42623          	sw	a5,-20(s0)
 198:	fec42783          	lw	a5,-20(s0)
 19c:	00078593          	mv	a1,a5
 1a0:	b1000537          	lui	a0,0xb1000
 1a4:	eddff0ef          	jal	80 <write>
 1a8:	00000013          	nop
 1ac:	01c12083          	lw	ra,28(sp)
 1b0:	01812403          	lw	s0,24(sp)
 1b4:	02010113          	addi	sp,sp,32
 1b8:	00008067          	ret

000001bc <write_adsr>:
 1bc:	fe010113          	addi	sp,sp,-32
 1c0:	00112e23          	sw	ra,28(sp)
 1c4:	00812c23          	sw	s0,24(sp)
 1c8:	02010413          	addi	s0,sp,32
 1cc:	19400793          	li	a5,404
 1d0:	0007c783          	lbu	a5,0(a5)
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	01879713          	slli	a4,a5,0x18
 1dc:	19800793          	li	a5,408
 1e0:	0007c783          	lbu	a5,0(a5)
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	01079793          	slli	a5,a5,0x10
 1ec:	00f76733          	or	a4,a4,a5
 1f0:	19c00793          	li	a5,412
 1f4:	0007c783          	lbu	a5,0(a5)
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	00879793          	slli	a5,a5,0x8
 200:	00f767b3          	or	a5,a4,a5
 204:	1a000713          	li	a4,416
 208:	00074703          	lbu	a4,0(a4)
 20c:	0ff77713          	zext.b	a4,a4
 210:	00e7e7b3          	or	a5,a5,a4
 214:	fef42623          	sw	a5,-20(s0)
 218:	fec42783          	lw	a5,-20(s0)
 21c:	00078593          	mv	a1,a5
 220:	b2000537          	lui	a0,0xb2000
 224:	e5dff0ef          	jal	80 <write>
 228:	00000013          	nop
 22c:	01c12083          	lw	ra,28(sp)
 230:	01812403          	lw	s0,24(sp)
 234:	02010113          	addi	sp,sp,32
 238:	00008067          	ret

0000023c <write_piano>:
 23c:	fe010113          	addi	sp,sp,-32
 240:	00112e23          	sw	ra,28(sp)
 244:	00812c23          	sw	s0,24(sp)
 248:	02010413          	addi	s0,sp,32
 24c:	1a400793          	li	a5,420
 250:	0007c783          	lbu	a5,0(a5)
 254:	0ff7f793          	zext.b	a5,a5
 258:	01879713          	slli	a4,a5,0x18
 25c:	1a800793          	li	a5,424
 260:	0007c783          	lbu	a5,0(a5)
 264:	0ff7f793          	zext.b	a5,a5
 268:	01079793          	slli	a5,a5,0x10
 26c:	00f76733          	or	a4,a4,a5
 270:	1ac00793          	li	a5,428
 274:	0007c783          	lbu	a5,0(a5)
 278:	0ff7f793          	zext.b	a5,a5
 27c:	00879793          	slli	a5,a5,0x8
 280:	00f767b3          	or	a5,a4,a5
 284:	1b000713          	li	a4,432
 288:	00074703          	lbu	a4,0(a4)
 28c:	0ff77713          	zext.b	a4,a4
 290:	00e7e7b3          	or	a5,a5,a4
 294:	fef42623          	sw	a5,-20(s0)
 298:	fec42783          	lw	a5,-20(s0)
 29c:	00078593          	mv	a1,a5
 2a0:	b4000537          	lui	a0,0xb4000
 2a4:	dddff0ef          	jal	80 <write>
 2a8:	00000013          	nop
 2ac:	01c12083          	lw	ra,28(sp)
 2b0:	01812403          	lw	s0,24(sp)
 2b4:	02010113          	addi	sp,sp,32
 2b8:	00008067          	ret

000002bc <write_seg>:
 2bc:	fd010113          	addi	sp,sp,-48
 2c0:	02112623          	sw	ra,44(sp)
 2c4:	02812423          	sw	s0,40(sp)
 2c8:	03010413          	addi	s0,sp,48
 2cc:	fca42e23          	sw	a0,-36(s0)
 2d0:	fe042623          	sw	zero,-20(s0)
 2d4:	fdc42703          	lw	a4,-36(s0)
 2d8:	04d00793          	li	a5,77
 2dc:	28f70e63          	beq	a4,a5,578 <write_seg+0x2bc>
 2e0:	fdc42703          	lw	a4,-36(s0)
 2e4:	04d00793          	li	a5,77
 2e8:	2ae7c863          	blt	a5,a4,598 <write_seg+0x2dc>
 2ec:	fdc42703          	lw	a4,-36(s0)
 2f0:	04600793          	li	a5,70
 2f4:	20f70263          	beq	a4,a5,4f8 <write_seg+0x23c>
 2f8:	fdc42703          	lw	a4,-36(s0)
 2fc:	04600793          	li	a5,70
 300:	28e7cc63          	blt	a5,a4,598 <write_seg+0x2dc>
 304:	fdc42703          	lw	a4,-36(s0)
 308:	04500793          	li	a5,69
 30c:	20f70663          	beq	a4,a5,518 <write_seg+0x25c>
 310:	fdc42703          	lw	a4,-36(s0)
 314:	04500793          	li	a5,69
 318:	28e7c063          	blt	a5,a4,598 <write_seg+0x2dc>
 31c:	fdc42703          	lw	a4,-36(s0)
 320:	04400793          	li	a5,68
 324:	22f70a63          	beq	a4,a5,558 <write_seg+0x29c>
 328:	fdc42703          	lw	a4,-36(s0)
 32c:	04400793          	li	a5,68
 330:	26e7c463          	blt	a5,a4,598 <write_seg+0x2dc>
 334:	fdc42703          	lw	a4,-36(s0)
 338:	04300793          	li	a5,67
 33c:	1ef70e63          	beq	a4,a5,538 <write_seg+0x27c>
 340:	fdc42703          	lw	a4,-36(s0)
 344:	04300793          	li	a5,67
 348:	24e7c863          	blt	a5,a4,598 <write_seg+0x2dc>
 34c:	fdc42703          	lw	a4,-36(s0)
 350:	03e00793          	li	a5,62
 354:	18f70263          	beq	a4,a5,4d8 <write_seg+0x21c>
 358:	fdc42703          	lw	a4,-36(s0)
 35c:	03e00793          	li	a5,62
 360:	22e7cc63          	blt	a5,a4,598 <write_seg+0x2dc>
 364:	fdc42703          	lw	a4,-36(s0)
 368:	03d00793          	li	a5,61
 36c:	14f70663          	beq	a4,a5,4b8 <write_seg+0x1fc>
 370:	fdc42703          	lw	a4,-36(s0)
 374:	03d00793          	li	a5,61
 378:	22e7c063          	blt	a5,a4,598 <write_seg+0x2dc>
 37c:	fdc42703          	lw	a4,-36(s0)
 380:	03600793          	li	a5,54
 384:	10f70a63          	beq	a4,a5,498 <write_seg+0x1dc>
 388:	fdc42703          	lw	a4,-36(s0)
 38c:	03600793          	li	a5,54
 390:	20e7c463          	blt	a5,a4,598 <write_seg+0x2dc>
 394:	fdc42703          	lw	a4,-36(s0)
 398:	02e00793          	li	a5,46
 39c:	0cf70e63          	beq	a4,a5,478 <write_seg+0x1bc>
 3a0:	fdc42703          	lw	a4,-36(s0)
 3a4:	02e00793          	li	a5,46
 3a8:	1ee7c863          	blt	a5,a4,598 <write_seg+0x2dc>
 3ac:	fdc42703          	lw	a4,-36(s0)
 3b0:	02600793          	li	a5,38
 3b4:	08f70263          	beq	a4,a5,438 <write_seg+0x17c>
 3b8:	fdc42703          	lw	a4,-36(s0)
 3bc:	02600793          	li	a5,38
 3c0:	1ce7cc63          	blt	a5,a4,598 <write_seg+0x2dc>
 3c4:	fdc42703          	lw	a4,-36(s0)
 3c8:	02500793          	li	a5,37
 3cc:	08f70663          	beq	a4,a5,458 <write_seg+0x19c>
 3d0:	fdc42703          	lw	a4,-36(s0)
 3d4:	02500793          	li	a5,37
 3d8:	1ce7c063          	blt	a5,a4,598 <write_seg+0x2dc>
 3dc:	fdc42703          	lw	a4,-36(s0)
 3e0:	01600793          	li	a5,22
 3e4:	00f70a63          	beq	a4,a5,3f8 <write_seg+0x13c>
 3e8:	fdc42703          	lw	a4,-36(s0)
 3ec:	01e00793          	li	a5,30
 3f0:	02f70463          	beq	a4,a5,418 <write_seg+0x15c>
 3f4:	1a40006f          	j	598 <write_seg+0x2dc>
 3f8:	18000793          	li	a5,384
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	0ff7f793          	zext.b	a5,a5
 404:	00078713          	mv	a4,a5
 408:	010007b7          	lui	a5,0x1000
 40c:	00f767b3          	or	a5,a4,a5
 410:	fef42623          	sw	a5,-20(s0)
 414:	1840006f          	j	598 <write_seg+0x2dc>
 418:	18400793          	li	a5,388
 41c:	0007c783          	lbu	a5,0(a5) # 1000000 <__global_pointer$+0xffda24>
 420:	0ff7f793          	zext.b	a5,a5
 424:	00078713          	mv	a4,a5
 428:	020007b7          	lui	a5,0x2000
 42c:	00f767b3          	or	a5,a4,a5
 430:	fef42623          	sw	a5,-20(s0)
 434:	1640006f          	j	598 <write_seg+0x2dc>
 438:	18800793          	li	a5,392
 43c:	0007c783          	lbu	a5,0(a5) # 2000000 <__global_pointer$+0x1ffda24>
 440:	0ff7f793          	zext.b	a5,a5
 444:	00078713          	mv	a4,a5
 448:	030007b7          	lui	a5,0x3000
 44c:	00f767b3          	or	a5,a4,a5
 450:	fef42623          	sw	a5,-20(s0)
 454:	1440006f          	j	598 <write_seg+0x2dc>
 458:	18c00793          	li	a5,396
 45c:	0007c783          	lbu	a5,0(a5) # 3000000 <__global_pointer$+0x2ffda24>
 460:	0ff7f793          	zext.b	a5,a5
 464:	00078713          	mv	a4,a5
 468:	040007b7          	lui	a5,0x4000
 46c:	00f767b3          	or	a5,a4,a5
 470:	fef42623          	sw	a5,-20(s0)
 474:	1240006f          	j	598 <write_seg+0x2dc>
 478:	19000793          	li	a5,400
 47c:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffda24>
 480:	0ff7f793          	zext.b	a5,a5
 484:	00078713          	mv	a4,a5
 488:	050007b7          	lui	a5,0x5000
 48c:	00f767b3          	or	a5,a4,a5
 490:	fef42623          	sw	a5,-20(s0)
 494:	1040006f          	j	598 <write_seg+0x2dc>
 498:	1a400793          	li	a5,420
 49c:	0007c783          	lbu	a5,0(a5) # 5000000 <__global_pointer$+0x4ffda24>
 4a0:	0ff7f793          	zext.b	a5,a5
 4a4:	00078713          	mv	a4,a5
 4a8:	060007b7          	lui	a5,0x6000
 4ac:	00f767b3          	or	a5,a4,a5
 4b0:	fef42623          	sw	a5,-20(s0)
 4b4:	0e40006f          	j	598 <write_seg+0x2dc>
 4b8:	1a800793          	li	a5,424
 4bc:	0007c783          	lbu	a5,0(a5) # 6000000 <__global_pointer$+0x5ffda24>
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	00078713          	mv	a4,a5
 4c8:	070007b7          	lui	a5,0x7000
 4cc:	00f767b3          	or	a5,a4,a5
 4d0:	fef42623          	sw	a5,-20(s0)
 4d4:	0c40006f          	j	598 <write_seg+0x2dc>
 4d8:	1ac00793          	li	a5,428
 4dc:	0007c783          	lbu	a5,0(a5) # 7000000 <__global_pointer$+0x6ffda24>
 4e0:	0ff7f793          	zext.b	a5,a5
 4e4:	00078713          	mv	a4,a5
 4e8:	080007b7          	lui	a5,0x8000
 4ec:	00f767b3          	or	a5,a4,a5
 4f0:	fef42623          	sw	a5,-20(s0)
 4f4:	0a40006f          	j	598 <write_seg+0x2dc>
 4f8:	1b000793          	li	a5,432
 4fc:	0007c783          	lbu	a5,0(a5) # 8000000 <__global_pointer$+0x7ffda24>
 500:	0ff7f793          	zext.b	a5,a5
 504:	00078713          	mv	a4,a5
 508:	090007b7          	lui	a5,0x9000
 50c:	00f767b3          	or	a5,a4,a5
 510:	fef42623          	sw	a5,-20(s0)
 514:	0840006f          	j	598 <write_seg+0x2dc>
 518:	19400793          	li	a5,404
 51c:	0007c783          	lbu	a5,0(a5) # 9000000 <__global_pointer$+0x8ffda24>
 520:	0ff7f793          	zext.b	a5,a5
 524:	00078713          	mv	a4,a5
 528:	0a0007b7          	lui	a5,0xa000
 52c:	00f767b3          	or	a5,a4,a5
 530:	fef42623          	sw	a5,-20(s0)
 534:	0640006f          	j	598 <write_seg+0x2dc>
 538:	19800793          	li	a5,408
 53c:	0007c783          	lbu	a5,0(a5) # a000000 <__global_pointer$+0x9ffda24>
 540:	0ff7f793          	zext.b	a5,a5
 544:	00078713          	mv	a4,a5
 548:	0b0007b7          	lui	a5,0xb000
 54c:	00f767b3          	or	a5,a4,a5
 550:	fef42623          	sw	a5,-20(s0)
 554:	0440006f          	j	598 <write_seg+0x2dc>
 558:	19c00793          	li	a5,412
 55c:	0007c783          	lbu	a5,0(a5) # b000000 <__global_pointer$+0xaffda24>
 560:	0ff7f793          	zext.b	a5,a5
 564:	00078713          	mv	a4,a5
 568:	0c0007b7          	lui	a5,0xc000
 56c:	00f767b3          	or	a5,a4,a5
 570:	fef42623          	sw	a5,-20(s0)
 574:	0240006f          	j	598 <write_seg+0x2dc>
 578:	1a000793          	li	a5,416
 57c:	0007c783          	lbu	a5,0(a5) # c000000 <__global_pointer$+0xbffda24>
 580:	0ff7f793          	zext.b	a5,a5
 584:	00078713          	mv	a4,a5
 588:	0d0007b7          	lui	a5,0xd000
 58c:	00f767b3          	or	a5,a4,a5
 590:	fef42623          	sw	a5,-20(s0)
 594:	00000013          	nop
 598:	fec42783          	lw	a5,-20(s0)
 59c:	00078593          	mv	a1,a5
 5a0:	e0000537          	lui	a0,0xe0000
 5a4:	addff0ef          	jal	80 <write>
 5a8:	00000013          	nop
 5ac:	02c12083          	lw	ra,44(sp)
 5b0:	02812403          	lw	s0,40(sp)
 5b4:	03010113          	addi	sp,sp,48
 5b8:	00008067          	ret

000005bc <handler>:
 5bc:	f9010113          	addi	sp,sp,-112
 5c0:	06112623          	sw	ra,108(sp)
 5c4:	06512423          	sw	t0,104(sp)
 5c8:	06612223          	sw	t1,100(sp)
 5cc:	06712023          	sw	t2,96(sp)
 5d0:	04812e23          	sw	s0,92(sp)
 5d4:	04a12c23          	sw	a0,88(sp)
 5d8:	04b12a23          	sw	a1,84(sp)
 5dc:	04c12823          	sw	a2,80(sp)
 5e0:	04d12623          	sw	a3,76(sp)
 5e4:	04e12423          	sw	a4,72(sp)
 5e8:	04f12223          	sw	a5,68(sp)
 5ec:	05012023          	sw	a6,64(sp)
 5f0:	03112e23          	sw	a7,60(sp)
 5f4:	03c12c23          	sw	t3,56(sp)
 5f8:	03d12a23          	sw	t4,52(sp)
 5fc:	03e12823          	sw	t5,48(sp)
 600:	03f12623          	sw	t6,44(sp)
 604:	07010413          	addi	s0,sp,112
 608:	16000793          	li	a5,352
 60c:	0007a783          	lw	a5,0(a5) # d000000 <__global_pointer$+0xcffda24>
 610:	faf42623          	sw	a5,-84(s0)
 614:	a00007b7          	lui	a5,0xa0000
 618:	f8f42a23          	sw	a5,-108(s0)
 61c:	f9442783          	lw	a5,-108(s0)
 620:	0007a783          	lw	a5,0(a5) # a0000000 <__global_pointer$+0x9fffda24>
 624:	f8f409a3          	sb	a5,-109(s0)
 628:	f9344703          	lbu	a4,-109(s0)
 62c:	0f000793          	li	a5,240
 630:	00f71a63          	bne	a4,a5,644 <handler+0x88>
 634:	17000793          	li	a5,368
 638:	00100713          	li	a4,1
 63c:	00e78023          	sb	a4,0(a5)
 640:	5240006f          	j	b64 <handler+0x5a8>
 644:	f9344703          	lbu	a4,-109(s0)
 648:	0e000793          	li	a5,224
 64c:	00f71a63          	bne	a4,a5,660 <handler+0xa4>
 650:	17100793          	li	a5,369
 654:	00100713          	li	a4,1
 658:	00e78023          	sb	a4,0(a5)
 65c:	5080006f          	j	b64 <handler+0x5a8>
 660:	fff00793          	li	a5,-1
 664:	faf42423          	sw	a5,-88(s0)
 668:	fa042223          	sw	zero,-92(s0)
 66c:	0380006f          	j	6a4 <handler+0xe8>
 670:	fa442783          	lw	a5,-92(s0)
 674:	00279793          	slli	a5,a5,0x2
 678:	10078793          	addi	a5,a5,256
 67c:	0007a783          	lw	a5,0(a5)
 680:	0ff7f793          	zext.b	a5,a5
 684:	f9344703          	lbu	a4,-109(s0)
 688:	00f71863          	bne	a4,a5,698 <handler+0xdc>
 68c:	fa442783          	lw	a5,-92(s0)
 690:	faf42423          	sw	a5,-88(s0)
 694:	01c0006f          	j	6b0 <handler+0xf4>
 698:	fa442783          	lw	a5,-92(s0)
 69c:	00178793          	addi	a5,a5,1
 6a0:	faf42223          	sw	a5,-92(s0)
 6a4:	fa442703          	lw	a4,-92(s0)
 6a8:	01400793          	li	a5,20
 6ac:	fce7d2e3          	bge	a5,a4,670 <handler+0xb4>
 6b0:	fa842703          	lw	a4,-88(s0)
 6b4:	fff00793          	li	a5,-1
 6b8:	08f70863          	beq	a4,a5,748 <handler+0x18c>
 6bc:	17100793          	li	a5,369
 6c0:	0007c783          	lbu	a5,0(a5)
 6c4:	0ff7f793          	zext.b	a5,a5
 6c8:	02079863          	bnez	a5,6f8 <handler+0x13c>
 6cc:	17000793          	li	a5,368
 6d0:	0007c783          	lbu	a5,0(a5)
 6d4:	0ff7f793          	zext.b	a5,a5
 6d8:	02079063          	bnez	a5,6f8 <handler+0x13c>
 6dc:	fa842783          	lw	a5,-88(s0)
 6e0:	00100713          	li	a4,1
 6e4:	00f717b3          	sll	a5,a4,a5
 6e8:	fac42703          	lw	a4,-84(s0)
 6ec:	00f767b3          	or	a5,a4,a5
 6f0:	faf42623          	sw	a5,-84(s0)
 6f4:	0200006f          	j	714 <handler+0x158>
 6f8:	fa842783          	lw	a5,-88(s0)
 6fc:	00100713          	li	a4,1
 700:	00f717b3          	sll	a5,a4,a5
 704:	fff7c793          	not	a5,a5
 708:	fac42703          	lw	a4,-84(s0)
 70c:	00f777b3          	and	a5,a4,a5
 710:	faf42623          	sw	a5,-84(s0)
 714:	fac42783          	lw	a5,-84(s0)
 718:	00078593          	mv	a1,a5
 71c:	16000513          	li	a0,352
 720:	961ff0ef          	jal	80 <write>
 724:	fac42783          	lw	a5,-84(s0)
 728:	00078593          	mv	a1,a5
 72c:	b0000537          	lui	a0,0xb0000
 730:	951ff0ef          	jal	80 <write>
 734:	fac42783          	lw	a5,-84(s0)
 738:	00078593          	mv	a1,a5
 73c:	e0000537          	lui	a0,0xe0000
 740:	941ff0ef          	jal	80 <write>
 744:	4080006f          	j	b4c <handler+0x590>
 748:	17000793          	li	a5,368
 74c:	0007c783          	lbu	a5,0(a5)
 750:	0ff7f793          	zext.b	a5,a5
 754:	3e079c63          	bnez	a5,b4c <handler+0x590>
 758:	17100793          	li	a5,369
 75c:	0007c783          	lbu	a5,0(a5)
 760:	0ff7f793          	zext.b	a5,a5
 764:	3e079463          	bnez	a5,b4c <handler+0x590>
 768:	fa042023          	sw	zero,-96(s0)
 76c:	f8042e23          	sw	zero,-100(s0)
 770:	f8042c23          	sw	zero,-104(s0)
 774:	f9344783          	lbu	a5,-109(s0)
 778:	05a00713          	li	a4,90
 77c:	36e78e63          	beq	a5,a4,af8 <handler+0x53c>
 780:	05a00713          	li	a4,90
 784:	38f74c63          	blt	a4,a5,b1c <handler+0x560>
 788:	04d00713          	li	a4,77
 78c:	34e78263          	beq	a5,a4,ad0 <handler+0x514>
 790:	04d00713          	li	a4,77
 794:	38f74463          	blt	a4,a5,b1c <handler+0x560>
 798:	04600713          	li	a4,70
 79c:	28e78a63          	beq	a5,a4,a30 <handler+0x474>
 7a0:	04600713          	li	a4,70
 7a4:	36f74c63          	blt	a4,a5,b1c <handler+0x560>
 7a8:	04500713          	li	a4,69
 7ac:	2ae78663          	beq	a5,a4,a58 <handler+0x49c>
 7b0:	04500713          	li	a4,69
 7b4:	36f74463          	blt	a4,a5,b1c <handler+0x560>
 7b8:	04400713          	li	a4,68
 7bc:	2ee78663          	beq	a5,a4,aa8 <handler+0x4ec>
 7c0:	04400713          	li	a4,68
 7c4:	34f74c63          	blt	a4,a5,b1c <handler+0x560>
 7c8:	04300713          	li	a4,67
 7cc:	2ae78a63          	beq	a5,a4,a80 <handler+0x4c4>
 7d0:	04300713          	li	a4,67
 7d4:	34f74463          	blt	a4,a5,b1c <handler+0x560>
 7d8:	03e00713          	li	a4,62
 7dc:	22e78663          	beq	a5,a4,a08 <handler+0x44c>
 7e0:	03e00713          	li	a4,62
 7e4:	32f74c63          	blt	a4,a5,b1c <handler+0x560>
 7e8:	03d00713          	li	a4,61
 7ec:	1ee78a63          	beq	a5,a4,9e0 <handler+0x424>
 7f0:	03d00713          	li	a4,61
 7f4:	32f74463          	blt	a4,a5,b1c <handler+0x560>
 7f8:	03600713          	li	a4,54
 7fc:	1ae78e63          	beq	a5,a4,9b8 <handler+0x3fc>
 800:	03600713          	li	a4,54
 804:	30f74c63          	blt	a4,a5,b1c <handler+0x560>
 808:	02e00713          	li	a4,46
 80c:	14e78e63          	beq	a5,a4,968 <handler+0x3ac>
 810:	02e00713          	li	a4,46
 814:	30f74463          	blt	a4,a5,b1c <handler+0x560>
 818:	02900713          	li	a4,41
 81c:	2ee78e63          	beq	a5,a4,b18 <handler+0x55c>
 820:	02900713          	li	a4,41
 824:	2ef74c63          	blt	a4,a5,b1c <handler+0x560>
 828:	02600713          	li	a4,38
 82c:	0ae78863          	beq	a5,a4,8dc <handler+0x320>
 830:	02600713          	li	a4,38
 834:	2ef74463          	blt	a4,a5,b1c <handler+0x560>
 838:	02500713          	li	a4,37
 83c:	0ee78663          	beq	a5,a4,928 <handler+0x36c>
 840:	02500713          	li	a4,37
 844:	2cf74c63          	blt	a4,a5,b1c <handler+0x560>
 848:	01600713          	li	a4,22
 84c:	00e78863          	beq	a5,a4,85c <handler+0x2a0>
 850:	01e00713          	li	a4,30
 854:	04e78463          	beq	a5,a4,89c <handler+0x2e0>
 858:	2c40006f          	j	b1c <handler+0x560>
 85c:	18000793          	li	a5,384
 860:	0007c703          	lbu	a4,0(a5)
 864:	0ff77713          	zext.b	a4,a4
 868:	00170713          	addi	a4,a4,1
 86c:	0ff77713          	zext.b	a4,a4
 870:	00e78023          	sb	a4,0(a5)
 874:	18000793          	li	a5,384
 878:	0007c783          	lbu	a5,0(a5)
 87c:	0ff7f713          	zext.b	a4,a5
 880:	00400793          	li	a5,4
 884:	00e7f663          	bgeu	a5,a4,890 <handler+0x2d4>
 888:	18000793          	li	a5,384
 88c:	00078023          	sb	zero,0(a5)
 890:	00100793          	li	a5,1
 894:	faf42023          	sw	a5,-96(s0)
 898:	2840006f          	j	b1c <handler+0x560>
 89c:	18400793          	li	a5,388
 8a0:	0007c703          	lbu	a4,0(a5)
 8a4:	0ff77713          	zext.b	a4,a4
 8a8:	00170713          	addi	a4,a4,1
 8ac:	0ff77713          	zext.b	a4,a4
 8b0:	00e78023          	sb	a4,0(a5)
 8b4:	18400793          	li	a5,388
 8b8:	0007c783          	lbu	a5,0(a5)
 8bc:	0ff7f713          	zext.b	a4,a5
 8c0:	18400793          	li	a5,388
 8c4:	00f77713          	andi	a4,a4,15
 8c8:	0ff77713          	zext.b	a4,a4
 8cc:	00e78023          	sb	a4,0(a5)
 8d0:	00100793          	li	a5,1
 8d4:	faf42023          	sw	a5,-96(s0)
 8d8:	2440006f          	j	b1c <handler+0x560>
 8dc:	18800793          	li	a5,392
 8e0:	0007c783          	lbu	a5,0(a5)
 8e4:	0ff7f713          	zext.b	a4,a5
 8e8:	00700793          	li	a5,7
 8ec:	00e7fa63          	bgeu	a5,a4,900 <handler+0x344>
 8f0:	18800793          	li	a5,392
 8f4:	00100713          	li	a4,1
 8f8:	00e78023          	sb	a4,0(a5)
 8fc:	0200006f          	j	91c <handler+0x360>
 900:	18800793          	li	a5,392
 904:	0007c783          	lbu	a5,0(a5)
 908:	0ff7f713          	zext.b	a4,a5
 90c:	18800793          	li	a5,392
 910:	00171713          	slli	a4,a4,0x1
 914:	0ff77713          	zext.b	a4,a4
 918:	00e78023          	sb	a4,0(a5)
 91c:	00100793          	li	a5,1
 920:	faf42023          	sw	a5,-96(s0)
 924:	1f80006f          	j	b1c <handler+0x560>
 928:	18c00793          	li	a5,396
 92c:	0007c703          	lbu	a4,0(a5)
 930:	0ff77713          	zext.b	a4,a4
 934:	00170713          	addi	a4,a4,1
 938:	0ff77713          	zext.b	a4,a4
 93c:	00e78023          	sb	a4,0(a5)
 940:	18c00793          	li	a5,396
 944:	0007c783          	lbu	a5,0(a5)
 948:	0ff7f713          	zext.b	a4,a5
 94c:	18c00793          	li	a5,396
 950:	00f77713          	andi	a4,a4,15
 954:	0ff77713          	zext.b	a4,a4
 958:	00e78023          	sb	a4,0(a5)
 95c:	00100793          	li	a5,1
 960:	faf42023          	sw	a5,-96(s0)
 964:	1b80006f          	j	b1c <handler+0x560>
 968:	19000793          	li	a5,400
 96c:	0007c703          	lbu	a4,0(a5)
 970:	0ff77713          	zext.b	a4,a4
 974:	00170713          	addi	a4,a4,1
 978:	0ff77713          	zext.b	a4,a4
 97c:	00e78023          	sb	a4,0(a5)
 980:	19000793          	li	a5,400
 984:	0007c783          	lbu	a5,0(a5)
 988:	0ff7f713          	zext.b	a4,a5
 98c:	19000793          	li	a5,400
 990:	01f77713          	andi	a4,a4,31
 994:	0ff77713          	zext.b	a4,a4
 998:	00e78023          	sb	a4,0(a5)
 99c:	19000793          	li	a5,400
 9a0:	0007c783          	lbu	a5,0(a5)
 9a4:	0ff7f793          	zext.b	a5,a5
 9a8:	00078593          	mv	a1,a5
 9ac:	b3000537          	lui	a0,0xb3000
 9b0:	ed0ff0ef          	jal	80 <write>
 9b4:	1680006f          	j	b1c <handler+0x560>
 9b8:	1a400793          	li	a5,420
 9bc:	0007c783          	lbu	a5,0(a5)
 9c0:	0ff7f713          	zext.b	a4,a5
 9c4:	1a400793          	li	a5,420
 9c8:	01070713          	addi	a4,a4,16
 9cc:	0ff77713          	zext.b	a4,a4
 9d0:	00e78023          	sb	a4,0(a5)
 9d4:	00100793          	li	a5,1
 9d8:	f8f42c23          	sw	a5,-104(s0)
 9dc:	1400006f          	j	b1c <handler+0x560>
 9e0:	1a800793          	li	a5,424
 9e4:	0007c783          	lbu	a5,0(a5)
 9e8:	0ff7f713          	zext.b	a4,a5
 9ec:	1a800793          	li	a5,424
 9f0:	01070713          	addi	a4,a4,16
 9f4:	0ff77713          	zext.b	a4,a4
 9f8:	00e78023          	sb	a4,0(a5)
 9fc:	00100793          	li	a5,1
 a00:	f8f42c23          	sw	a5,-104(s0)
 a04:	1180006f          	j	b1c <handler+0x560>
 a08:	1ac00793          	li	a5,428
 a0c:	0007c783          	lbu	a5,0(a5)
 a10:	0ff7f713          	zext.b	a4,a5
 a14:	1ac00793          	li	a5,428
 a18:	00870713          	addi	a4,a4,8
 a1c:	0ff77713          	zext.b	a4,a4
 a20:	00e78023          	sb	a4,0(a5)
 a24:	00100793          	li	a5,1
 a28:	f8f42c23          	sw	a5,-104(s0)
 a2c:	0f00006f          	j	b1c <handler+0x560>
 a30:	1b000793          	li	a5,432
 a34:	0007c783          	lbu	a5,0(a5)
 a38:	0ff7f713          	zext.b	a4,a5
 a3c:	1b000793          	li	a5,432
 a40:	01070713          	addi	a4,a4,16
 a44:	0ff77713          	zext.b	a4,a4
 a48:	00e78023          	sb	a4,0(a5)
 a4c:	00100793          	li	a5,1
 a50:	f8f42c23          	sw	a5,-104(s0)
 a54:	0c80006f          	j	b1c <handler+0x560>
 a58:	19400793          	li	a5,404
 a5c:	0007c783          	lbu	a5,0(a5)
 a60:	0ff7f713          	zext.b	a4,a5
 a64:	19400793          	li	a5,404
 a68:	01070713          	addi	a4,a4,16
 a6c:	0ff77713          	zext.b	a4,a4
 a70:	00e78023          	sb	a4,0(a5)
 a74:	00100793          	li	a5,1
 a78:	f8f42e23          	sw	a5,-100(s0)
 a7c:	0a00006f          	j	b1c <handler+0x560>
 a80:	19800793          	li	a5,408
 a84:	0007c783          	lbu	a5,0(a5)
 a88:	0ff7f713          	zext.b	a4,a5
 a8c:	19800793          	li	a5,408
 a90:	01070713          	addi	a4,a4,16
 a94:	0ff77713          	zext.b	a4,a4
 a98:	00e78023          	sb	a4,0(a5)
 a9c:	00100793          	li	a5,1
 aa0:	f8f42e23          	sw	a5,-100(s0)
 aa4:	0780006f          	j	b1c <handler+0x560>
 aa8:	19c00793          	li	a5,412
 aac:	0007c783          	lbu	a5,0(a5)
 ab0:	0ff7f713          	zext.b	a4,a5
 ab4:	19c00793          	li	a5,412
 ab8:	01070713          	addi	a4,a4,16
 abc:	0ff77713          	zext.b	a4,a4
 ac0:	00e78023          	sb	a4,0(a5)
 ac4:	00100793          	li	a5,1
 ac8:	f8f42e23          	sw	a5,-100(s0)
 acc:	0500006f          	j	b1c <handler+0x560>
 ad0:	1a000793          	li	a5,416
 ad4:	0007c783          	lbu	a5,0(a5)
 ad8:	0ff7f713          	zext.b	a4,a5
 adc:	1a000793          	li	a5,416
 ae0:	01070713          	addi	a4,a4,16
 ae4:	0ff77713          	zext.b	a4,a4
 ae8:	00e78023          	sb	a4,0(a5)
 aec:	00100793          	li	a5,1
 af0:	f8f42e23          	sw	a5,-100(s0)
 af4:	0280006f          	j	b1c <handler+0x560>
 af8:	1b400793          	li	a5,436
 afc:	00100713          	li	a4,1
 b00:	00e78023          	sb	a4,0(a5)
 b04:	008b57b7          	lui	a5,0x8b5
 b08:	17978593          	addi	a1,a5,377 # 8b5179 <__global_pointer$+0x8b2b9d>
 b0c:	e0000537          	lui	a0,0xe0000
 b10:	d70ff0ef          	jal	80 <write>
 b14:	0080006f          	j	b1c <handler+0x560>
 b18:	00000013          	nop
 b1c:	fa042783          	lw	a5,-96(s0)
 b20:	00078463          	beqz	a5,b28 <handler+0x56c>
 b24:	e14ff0ef          	jal	138 <write_ctrl>
 b28:	f9c42783          	lw	a5,-100(s0)
 b2c:	00078463          	beqz	a5,b34 <handler+0x578>
 b30:	e8cff0ef          	jal	1bc <write_adsr>
 b34:	f9842783          	lw	a5,-104(s0)
 b38:	00078463          	beqz	a5,b40 <handler+0x584>
 b3c:	f00ff0ef          	jal	23c <write_piano>
 b40:	f9344783          	lbu	a5,-109(s0)
 b44:	00078513          	mv	a0,a5
 b48:	f74ff0ef          	jal	2bc <write_seg>
 b4c:	17000793          	li	a5,368
 b50:	00078023          	sb	zero,0(a5)
 b54:	17100793          	li	a5,369
 b58:	00078023          	sb	zero,0(a5)
 b5c:	fac42503          	lw	a0,-84(s0)
 b60:	d98ff0ef          	jal	f8 <update_keys>
 b64:	06c12083          	lw	ra,108(sp)
 b68:	06812283          	lw	t0,104(sp)
 b6c:	06412303          	lw	t1,100(sp)
 b70:	06012383          	lw	t2,96(sp)
 b74:	05c12403          	lw	s0,92(sp)
 b78:	05812503          	lw	a0,88(sp)
 b7c:	05412583          	lw	a1,84(sp)
 b80:	05012603          	lw	a2,80(sp)
 b84:	04c12683          	lw	a3,76(sp)
 b88:	04812703          	lw	a4,72(sp)
 b8c:	04412783          	lw	a5,68(sp)
 b90:	04012803          	lw	a6,64(sp)
 b94:	03c12883          	lw	a7,60(sp)
 b98:	03812e03          	lw	t3,56(sp)
 b9c:	03412e83          	lw	t4,52(sp)
 ba0:	03012f03          	lw	t5,48(sp)
 ba4:	02c12f83          	lw	t6,44(sp)
 ba8:	07010113          	addi	sp,sp,112
 bac:	30200073          	mret

00000bb0 <init>:
 bb0:	ff010113          	addi	sp,sp,-16
 bb4:	00112623          	sw	ra,12(sp)
 bb8:	00812423          	sw	s0,8(sp)
 bbc:	01010413          	addi	s0,sp,16
 bc0:	01a00593          	li	a1,26
 bc4:	10000513          	li	a0,256
 bc8:	cb8ff0ef          	jal	80 <write>
 bcc:	02200593          	li	a1,34
 bd0:	10400513          	li	a0,260
 bd4:	cacff0ef          	jal	80 <write>
 bd8:	02100593          	li	a1,33
 bdc:	10800513          	li	a0,264
 be0:	ca0ff0ef          	jal	80 <write>
 be4:	02a00593          	li	a1,42
 be8:	10c00513          	li	a0,268
 bec:	c94ff0ef          	jal	80 <write>
 bf0:	03200593          	li	a1,50
 bf4:	11000513          	li	a0,272
 bf8:	c88ff0ef          	jal	80 <write>
 bfc:	03100593          	li	a1,49
 c00:	11400513          	li	a0,276
 c04:	c7cff0ef          	jal	80 <write>
 c08:	03a00593          	li	a1,58
 c0c:	11800513          	li	a0,280
 c10:	c70ff0ef          	jal	80 <write>
 c14:	01c00593          	li	a1,28
 c18:	11c00513          	li	a0,284
 c1c:	c64ff0ef          	jal	80 <write>
 c20:	01b00593          	li	a1,27
 c24:	12000513          	li	a0,288
 c28:	c58ff0ef          	jal	80 <write>
 c2c:	02300593          	li	a1,35
 c30:	12400513          	li	a0,292
 c34:	c4cff0ef          	jal	80 <write>
 c38:	02b00593          	li	a1,43
 c3c:	12800513          	li	a0,296
 c40:	c40ff0ef          	jal	80 <write>
 c44:	03400593          	li	a1,52
 c48:	12c00513          	li	a0,300
 c4c:	c34ff0ef          	jal	80 <write>
 c50:	03300593          	li	a1,51
 c54:	13000513          	li	a0,304
 c58:	c28ff0ef          	jal	80 <write>
 c5c:	03b00593          	li	a1,59
 c60:	13400513          	li	a0,308
 c64:	c1cff0ef          	jal	80 <write>
 c68:	01500593          	li	a1,21
 c6c:	13800513          	li	a0,312
 c70:	c10ff0ef          	jal	80 <write>
 c74:	01d00593          	li	a1,29
 c78:	13c00513          	li	a0,316
 c7c:	c04ff0ef          	jal	80 <write>
 c80:	02400593          	li	a1,36
 c84:	14000513          	li	a0,320
 c88:	bf8ff0ef          	jal	80 <write>
 c8c:	02d00593          	li	a1,45
 c90:	14400513          	li	a0,324
 c94:	becff0ef          	jal	80 <write>
 c98:	02c00593          	li	a1,44
 c9c:	14800513          	li	a0,328
 ca0:	be0ff0ef          	jal	80 <write>
 ca4:	03500593          	li	a1,53
 ca8:	14c00513          	li	a0,332
 cac:	bd4ff0ef          	jal	80 <write>
 cb0:	03c00593          	li	a1,60
 cb4:	15000513          	li	a0,336
 cb8:	bc8ff0ef          	jal	80 <write>
 cbc:	18000793          	li	a5,384
 cc0:	00078023          	sb	zero,0(a5)
 cc4:	18400793          	li	a5,388
 cc8:	00800713          	li	a4,8
 ccc:	00e78023          	sb	a4,0(a5)
 cd0:	18800793          	li	a5,392
 cd4:	00400713          	li	a4,4
 cd8:	00e78023          	sb	a4,0(a5)
 cdc:	18c00793          	li	a5,396
 ce0:	00700713          	li	a4,7
 ce4:	00e78023          	sb	a4,0(a5)
 ce8:	19000793          	li	a5,400
 cec:	01000713          	li	a4,16
 cf0:	00e78023          	sb	a4,0(a5)
 cf4:	19400793          	li	a5,404
 cf8:	01400713          	li	a4,20
 cfc:	00e78023          	sb	a4,0(a5)
 d00:	19800793          	li	a5,408
 d04:	06400713          	li	a4,100
 d08:	00e78023          	sb	a4,0(a5)
 d0c:	19c00793          	li	a5,412
 d10:	fff00713          	li	a4,-1
 d14:	00e78023          	sb	a4,0(a5)
 d18:	1a000793          	li	a5,416
 d1c:	06400713          	li	a4,100
 d20:	00e78023          	sb	a4,0(a5)
 d24:	1a400793          	li	a5,420
 d28:	f8000713          	li	a4,-128
 d2c:	00e78023          	sb	a4,0(a5)
 d30:	1a800793          	li	a5,424
 d34:	fc800713          	li	a4,-56
 d38:	00e78023          	sb	a4,0(a5)
 d3c:	1ac00793          	li	a5,428
 d40:	01000713          	li	a4,16
 d44:	00e78023          	sb	a4,0(a5)
 d48:	1b000793          	li	a5,432
 d4c:	f8000713          	li	a4,-128
 d50:	00e78023          	sb	a4,0(a5)
 d54:	17000793          	li	a5,368
 d58:	00078023          	sb	zero,0(a5)
 d5c:	17100793          	li	a5,369
 d60:	00078023          	sb	zero,0(a5)
 d64:	1b400793          	li	a5,436
 d68:	00078023          	sb	zero,0(a5)
 d6c:	00800793          	li	a5,8
 d70:	00078023          	sb	zero,0(a5)
 d74:	00000593          	li	a1,0
 d78:	16000513          	li	a0,352
 d7c:	b04ff0ef          	jal	80 <write>
 d80:	00000593          	li	a1,0
 d84:	b0000537          	lui	a0,0xb0000
 d88:	af8ff0ef          	jal	80 <write>
 d8c:	bacff0ef          	jal	138 <write_ctrl>
 d90:	c2cff0ef          	jal	1bc <write_adsr>
 d94:	19000793          	li	a5,400
 d98:	0007c783          	lbu	a5,0(a5)
 d9c:	0ff7f793          	zext.b	a5,a5
 da0:	00078593          	mv	a1,a5
 da4:	b3000537          	lui	a0,0xb3000
 da8:	ad8ff0ef          	jal	80 <write>
 dac:	c90ff0ef          	jal	23c <write_piano>
 db0:	00000013          	nop
 db4:	00c12083          	lw	ra,12(sp)
 db8:	00812403          	lw	s0,8(sp)
 dbc:	01010113          	addi	sp,sp,16
 dc0:	00008067          	ret

00000dc4 <main>:
 dc4:	ff010113          	addi	sp,sp,-16
 dc8:	00112623          	sw	ra,12(sp)
 dcc:	00812423          	sw	s0,8(sp)
 dd0:	01010413          	addi	s0,sp,16
 dd4:	dddff0ef          	jal	bb0 <init>
 dd8:	0000006f          	j	dd8 <main+0x14>
