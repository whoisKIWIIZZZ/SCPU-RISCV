
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000040 <start>:
  40:	ff010113          	addi	sp,sp,-16
  44:	00112623          	sw	ra,12(sp)
  48:	00812423          	sw	s0,8(sp)
  4c:	01010413          	addi	s0,sp,16
  50:	40000113          	li	sp,1024
  54:	434000ef          	jal	488 <main>
  58:	0000006f          	j	58 <start+0x18>

0000005c <store_move_to_ram>:
  5c:	fd010113          	addi	sp,sp,-48
  60:	02112623          	sw	ra,44(sp)
  64:	02812423          	sw	s0,40(sp)
  68:	03010413          	addi	s0,sp,48
  6c:	fca42e23          	sw	a0,-36(s0)
  70:	fcb42c23          	sw	a1,-40(s0)
  74:	fcc42a23          	sw	a2,-44(s0)
  78:	fcd42823          	sw	a3,-48(s0)
  7c:	000017b7          	lui	a5,0x1
  80:	fef42623          	sw	a5,-20(s0)
  84:	fdc42703          	lw	a4,-36(s0)
  88:	00070793          	mv	a5,a4
  8c:	00179793          	slli	a5,a5,0x1
  90:	00e787b3          	add	a5,a5,a4
  94:	00279793          	slli	a5,a5,0x2
  98:	00078713          	mv	a4,a5
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	00e787b3          	add	a5,a5,a4
  a4:	fd842703          	lw	a4,-40(s0)
  a8:	00e7a023          	sw	a4,0(a5) # 1000 <main+0xb78>
  ac:	fdc42703          	lw	a4,-36(s0)
  b0:	00070793          	mv	a5,a4
  b4:	00179793          	slli	a5,a5,0x1
  b8:	00e787b3          	add	a5,a5,a4
  bc:	00279793          	slli	a5,a5,0x2
  c0:	00078713          	mv	a4,a5
  c4:	fec42783          	lw	a5,-20(s0)
  c8:	00e787b3          	add	a5,a5,a4
  cc:	fd442703          	lw	a4,-44(s0)
  d0:	00e7a223          	sw	a4,4(a5)
  d4:	fdc42703          	lw	a4,-36(s0)
  d8:	00070793          	mv	a5,a4
  dc:	00179793          	slli	a5,a5,0x1
  e0:	00e787b3          	add	a5,a5,a4
  e4:	00279793          	slli	a5,a5,0x2
  e8:	00078713          	mv	a4,a5
  ec:	fec42783          	lw	a5,-20(s0)
  f0:	00e787b3          	add	a5,a5,a4
  f4:	fd042703          	lw	a4,-48(s0)
  f8:	00e7a423          	sw	a4,8(a5)
  fc:	00000013          	nop
 100:	02c12083          	lw	ra,44(sp)
 104:	02812403          	lw	s0,40(sp)
 108:	03010113          	addi	sp,sp,48
 10c:	00008067          	ret

00000110 <set_piece>:
 110:	fd010113          	addi	sp,sp,-48
 114:	02112623          	sw	ra,44(sp)
 118:	02812423          	sw	s0,40(sp)
 11c:	03010413          	addi	s0,sp,48
 120:	fca42e23          	sw	a0,-36(s0)
 124:	fcb42c23          	sw	a1,-40(s0)
 128:	fcc42a23          	sw	a2,-44(s0)
 12c:	fdc42703          	lw	a4,-36(s0)
 130:	00070793          	mv	a5,a4
 134:	00279793          	slli	a5,a5,0x2
 138:	00e787b3          	add	a5,a5,a4
 13c:	00279793          	slli	a5,a5,0x2
 140:	40e78733          	sub	a4,a5,a4
 144:	fd842783          	lw	a5,-40(s0)
 148:	00f70733          	add	a4,a4,a5
 14c:	f00007b7          	lui	a5,0xf0000
 150:	00f707b3          	add	a5,a4,a5
 154:	00279793          	slli	a5,a5,0x2
 158:	fef42623          	sw	a5,-20(s0)
 15c:	fec42783          	lw	a5,-20(s0)
 160:	fd442703          	lw	a4,-44(s0)
 164:	00e7a023          	sw	a4,0(a5) # f0000000 <__global_pointer$+0xefffe244>
 168:	00000013          	nop
 16c:	02c12083          	lw	ra,44(sp)
 170:	02812403          	lw	s0,40(sp)
 174:	03010113          	addi	sp,sp,48
 178:	00008067          	ret

0000017c <timer_interrupt_handler>:
 17c:	fa010113          	addi	sp,sp,-96
 180:	04112e23          	sw	ra,92(sp)
 184:	04512c23          	sw	t0,88(sp)
 188:	04612a23          	sw	t1,84(sp)
 18c:	04712823          	sw	t2,80(sp)
 190:	04812623          	sw	s0,76(sp)
 194:	04a12423          	sw	a0,72(sp)
 198:	04b12223          	sw	a1,68(sp)
 19c:	04c12023          	sw	a2,64(sp)
 1a0:	02d12e23          	sw	a3,60(sp)
 1a4:	02e12c23          	sw	a4,56(sp)
 1a8:	02f12a23          	sw	a5,52(sp)
 1ac:	03012823          	sw	a6,48(sp)
 1b0:	03112623          	sw	a7,44(sp)
 1b4:	03c12423          	sw	t3,40(sp)
 1b8:	03d12223          	sw	t4,36(sp)
 1bc:	03e12023          	sw	t5,32(sp)
 1c0:	01f12e23          	sw	t6,28(sp)
 1c4:	06010413          	addi	s0,sp,96
 1c8:	000017b7          	lui	a5,0x1
 1cc:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 1d0:	0007a703          	lw	a4,0(a5)
 1d4:	000017b7          	lui	a5,0x1
 1d8:	5bc7a783          	lw	a5,1468(a5) # 15bc <__DATA_BEGIN__>
 1dc:	0cf77463          	bgeu	a4,a5,2a4 <timer_interrupt_handler+0x128>
 1e0:	000017b7          	lui	a5,0x1
 1e4:	faf42623          	sw	a5,-84(s0)
 1e8:	000017b7          	lui	a5,0x1
 1ec:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 1f0:	0007a703          	lw	a4,0(a5)
 1f4:	00070793          	mv	a5,a4
 1f8:	00179793          	slli	a5,a5,0x1
 1fc:	00e787b3          	add	a5,a5,a4
 200:	00279793          	slli	a5,a5,0x2
 204:	00078713          	mv	a4,a5
 208:	fac42783          	lw	a5,-84(s0)
 20c:	00e787b3          	add	a5,a5,a4
 210:	0007a783          	lw	a5,0(a5)
 214:	faf42423          	sw	a5,-88(s0)
 218:	000017b7          	lui	a5,0x1
 21c:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 220:	0007a703          	lw	a4,0(a5)
 224:	00070793          	mv	a5,a4
 228:	00179793          	slli	a5,a5,0x1
 22c:	00e787b3          	add	a5,a5,a4
 230:	00279793          	slli	a5,a5,0x2
 234:	00078713          	mv	a4,a5
 238:	fac42783          	lw	a5,-84(s0)
 23c:	00e787b3          	add	a5,a5,a4
 240:	0047a783          	lw	a5,4(a5)
 244:	faf42223          	sw	a5,-92(s0)
 248:	000017b7          	lui	a5,0x1
 24c:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 250:	0007a703          	lw	a4,0(a5)
 254:	00070793          	mv	a5,a4
 258:	00179793          	slli	a5,a5,0x1
 25c:	00e787b3          	add	a5,a5,a4
 260:	00279793          	slli	a5,a5,0x2
 264:	00078713          	mv	a4,a5
 268:	fac42783          	lw	a5,-84(s0)
 26c:	00e787b3          	add	a5,a5,a4
 270:	0087a783          	lw	a5,8(a5)
 274:	faf42023          	sw	a5,-96(s0)
 278:	fa042603          	lw	a2,-96(s0)
 27c:	fa442583          	lw	a1,-92(s0)
 280:	fa842503          	lw	a0,-88(s0)
 284:	e8dff0ef          	jal	110 <set_piece>
 288:	000017b7          	lui	a5,0x1
 28c:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 290:	0007a703          	lw	a4,0(a5)
 294:	000017b7          	lui	a5,0x1
 298:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 29c:	00170713          	addi	a4,a4,1
 2a0:	00e7a023          	sw	a4,0(a5)
 2a4:	00000013          	nop
 2a8:	05c12083          	lw	ra,92(sp)
 2ac:	05812283          	lw	t0,88(sp)
 2b0:	05412303          	lw	t1,84(sp)
 2b4:	05012383          	lw	t2,80(sp)
 2b8:	04c12403          	lw	s0,76(sp)
 2bc:	04812503          	lw	a0,72(sp)
 2c0:	04412583          	lw	a1,68(sp)
 2c4:	04012603          	lw	a2,64(sp)
 2c8:	03c12683          	lw	a3,60(sp)
 2cc:	03812703          	lw	a4,56(sp)
 2d0:	03412783          	lw	a5,52(sp)
 2d4:	03012803          	lw	a6,48(sp)
 2d8:	02c12883          	lw	a7,44(sp)
 2dc:	02812e03          	lw	t3,40(sp)
 2e0:	02412e83          	lw	t4,36(sp)
 2e4:	02012f03          	lw	t5,32(sp)
 2e8:	01c12f83          	lw	t6,28(sp)
 2ec:	06010113          	addi	sp,sp,96
 2f0:	30200073          	mret

000002f4 <keyboard_interrupt>:
 2f4:	f9010113          	addi	sp,sp,-112
 2f8:	06112623          	sw	ra,108(sp)
 2fc:	06512423          	sw	t0,104(sp)
 300:	06612223          	sw	t1,100(sp)
 304:	06712023          	sw	t2,96(sp)
 308:	04812e23          	sw	s0,92(sp)
 30c:	04a12c23          	sw	a0,88(sp)
 310:	04b12a23          	sw	a1,84(sp)
 314:	04c12823          	sw	a2,80(sp)
 318:	04d12623          	sw	a3,76(sp)
 31c:	04e12423          	sw	a4,72(sp)
 320:	04f12223          	sw	a5,68(sp)
 324:	05012023          	sw	a6,64(sp)
 328:	03112e23          	sw	a7,60(sp)
 32c:	03c12c23          	sw	t3,56(sp)
 330:	03d12a23          	sw	t4,52(sp)
 334:	03e12823          	sw	t5,48(sp)
 338:	03f12623          	sw	t6,44(sp)
 33c:	07010413          	addi	s0,sp,112
 340:	f00007b7          	lui	a5,0xf0000
 344:	00878793          	addi	a5,a5,8 # f0000008 <__global_pointer$+0xefffe24c>
 348:	0007a783          	lw	a5,0(a5)
 34c:	faf407a3          	sb	a5,-81(s0)
 350:	faf44703          	lbu	a4,-81(s0)
 354:	02900793          	li	a5,41
 358:	0ef71063          	bne	a4,a5,438 <keyboard_interrupt+0x144>
 35c:	000017b7          	lui	a5,0x1
 360:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 364:	0007a703          	lw	a4,0(a5)
 368:	000017b7          	lui	a5,0x1
 36c:	5bc7a783          	lw	a5,1468(a5) # 15bc <__DATA_BEGIN__>
 370:	0cf77463          	bgeu	a4,a5,438 <keyboard_interrupt+0x144>
 374:	000017b7          	lui	a5,0x1
 378:	faf42423          	sw	a5,-88(s0)
 37c:	000017b7          	lui	a5,0x1
 380:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 384:	0007a703          	lw	a4,0(a5)
 388:	00070793          	mv	a5,a4
 38c:	00179793          	slli	a5,a5,0x1
 390:	00e787b3          	add	a5,a5,a4
 394:	00279793          	slli	a5,a5,0x2
 398:	00078713          	mv	a4,a5
 39c:	fa842783          	lw	a5,-88(s0)
 3a0:	00e787b3          	add	a5,a5,a4
 3a4:	0007a783          	lw	a5,0(a5)
 3a8:	faf42223          	sw	a5,-92(s0)
 3ac:	000017b7          	lui	a5,0x1
 3b0:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 3b4:	0007a703          	lw	a4,0(a5)
 3b8:	00070793          	mv	a5,a4
 3bc:	00179793          	slli	a5,a5,0x1
 3c0:	00e787b3          	add	a5,a5,a4
 3c4:	00279793          	slli	a5,a5,0x2
 3c8:	00078713          	mv	a4,a5
 3cc:	fa842783          	lw	a5,-88(s0)
 3d0:	00e787b3          	add	a5,a5,a4
 3d4:	0047a783          	lw	a5,4(a5)
 3d8:	faf42023          	sw	a5,-96(s0)
 3dc:	000017b7          	lui	a5,0x1
 3e0:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 3e4:	0007a703          	lw	a4,0(a5)
 3e8:	00070793          	mv	a5,a4
 3ec:	00179793          	slli	a5,a5,0x1
 3f0:	00e787b3          	add	a5,a5,a4
 3f4:	00279793          	slli	a5,a5,0x2
 3f8:	00078713          	mv	a4,a5
 3fc:	fa842783          	lw	a5,-88(s0)
 400:	00e787b3          	add	a5,a5,a4
 404:	0087a783          	lw	a5,8(a5)
 408:	f8f42e23          	sw	a5,-100(s0)
 40c:	f9c42603          	lw	a2,-100(s0)
 410:	fa042583          	lw	a1,-96(s0)
 414:	fa442503          	lw	a0,-92(s0)
 418:	cf9ff0ef          	jal	110 <set_piece>
 41c:	000017b7          	lui	a5,0x1
 420:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 424:	0007a703          	lw	a4,0(a5)
 428:	000017b7          	lui	a5,0x1
 42c:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 430:	00170713          	addi	a4,a4,1
 434:	00e7a023          	sw	a4,0(a5)
 438:	00000013          	nop
 43c:	06c12083          	lw	ra,108(sp)
 440:	06812283          	lw	t0,104(sp)
 444:	06412303          	lw	t1,100(sp)
 448:	06012383          	lw	t2,96(sp)
 44c:	05c12403          	lw	s0,92(sp)
 450:	05812503          	lw	a0,88(sp)
 454:	05412583          	lw	a1,84(sp)
 458:	05012603          	lw	a2,80(sp)
 45c:	04c12683          	lw	a3,76(sp)
 460:	04812703          	lw	a4,72(sp)
 464:	04412783          	lw	a5,68(sp)
 468:	04012803          	lw	a6,64(sp)
 46c:	03c12883          	lw	a7,60(sp)
 470:	03812e03          	lw	t3,56(sp)
 474:	03412e83          	lw	t4,52(sp)
 478:	03012f03          	lw	t5,48(sp)
 47c:	02c12f83          	lw	t6,44(sp)
 480:	07010113          	addi	sp,sp,112
 484:	30200073          	mret

00000488 <main>:
 488:	ff010113          	addi	sp,sp,-16
 48c:	00112623          	sw	ra,12(sp)
 490:	00812423          	sw	s0,8(sp)
 494:	01010413          	addi	s0,sp,16
 498:	000017b7          	lui	a5,0x1
 49c:	f0078793          	addi	a5,a5,-256 # f00 <main+0xa78>
 4a0:	0007a023          	sw	zero,0(a5)
 4a4:	00100693          	li	a3,1
 4a8:	00300613          	li	a2,3
 4ac:	00300593          	li	a1,3
 4b0:	00000513          	li	a0,0
 4b4:	ba9ff0ef          	jal	5c <store_move_to_ram>
 4b8:	00200693          	li	a3,2
 4bc:	00200613          	li	a2,2
 4c0:	00200593          	li	a1,2
 4c4:	00100513          	li	a0,1
 4c8:	b95ff0ef          	jal	5c <store_move_to_ram>
 4cc:	00100693          	li	a3,1
 4d0:	00300613          	li	a2,3
 4d4:	00200593          	li	a1,2
 4d8:	00200513          	li	a0,2
 4dc:	b81ff0ef          	jal	5c <store_move_to_ram>
 4e0:	00200693          	li	a3,2
 4e4:	00200613          	li	a2,2
 4e8:	00300593          	li	a1,3
 4ec:	00300513          	li	a0,3
 4f0:	b6dff0ef          	jal	5c <store_move_to_ram>
 4f4:	00100693          	li	a3,1
 4f8:	00200613          	li	a2,2
 4fc:	00400593          	li	a1,4
 500:	00400513          	li	a0,4
 504:	b59ff0ef          	jal	5c <store_move_to_ram>
 508:	00200693          	li	a3,2
 50c:	00100613          	li	a2,1
 510:	00400593          	li	a1,4
 514:	00500513          	li	a0,5
 518:	b45ff0ef          	jal	5c <store_move_to_ram>
 51c:	00100693          	li	a3,1
 520:	00200613          	li	a2,2
 524:	00500593          	li	a1,5
 528:	00600513          	li	a0,6
 52c:	b31ff0ef          	jal	5c <store_move_to_ram>
 530:	00200693          	li	a3,2
 534:	00100613          	li	a2,1
 538:	00500593          	li	a1,5
 53c:	00700513          	li	a0,7
 540:	b1dff0ef          	jal	5c <store_move_to_ram>
 544:	00100693          	li	a3,1
 548:	00200613          	li	a2,2
 54c:	00600593          	li	a1,6
 550:	00800513          	li	a0,8
 554:	b09ff0ef          	jal	5c <store_move_to_ram>
 558:	00200693          	li	a3,2
 55c:	00300613          	li	a2,3
 560:	00100593          	li	a1,1
 564:	00900513          	li	a0,9
 568:	af5ff0ef          	jal	5c <store_move_to_ram>
 56c:	00100693          	li	a3,1
 570:	00400613          	li	a2,4
 574:	00100593          	li	a1,1
 578:	00a00513          	li	a0,10
 57c:	ae1ff0ef          	jal	5c <store_move_to_ram>
 580:	00200693          	li	a3,2
 584:	00200613          	li	a2,2
 588:	00100593          	li	a1,1
 58c:	00b00513          	li	a0,11
 590:	acdff0ef          	jal	5c <store_move_to_ram>
 594:	00100693          	li	a3,1
 598:	00500613          	li	a2,5
 59c:	00200593          	li	a1,2
 5a0:	00c00513          	li	a0,12
 5a4:	ab9ff0ef          	jal	5c <store_move_to_ram>
 5a8:	000017b7          	lui	a5,0x1
 5ac:	00d00713          	li	a4,13
 5b0:	5ae7ae23          	sw	a4,1468(a5) # 15bc <__DATA_BEGIN__>
 5b4:	00000013          	nop
 5b8:	ffdff06f          	j	5b4 <main+0x12c>
