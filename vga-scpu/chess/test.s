
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000040 <start>:
  40:	ff010113          	addi	sp,sp,-16
  44:	00112623          	sw	ra,12(sp)
  48:	00812423          	sw	s0,8(sp)
  4c:	01010413          	addi	s0,sp,16
  50:	40000113          	li	sp,1024
  54:	2fc000ef          	jal	350 <main>
  58:	0000006f          	j	58 <start+0x18>

0000005c <write>:
  5c:	fd010113          	addi	sp,sp,-48
  60:	02112623          	sw	ra,44(sp)
  64:	02812423          	sw	s0,40(sp)
  68:	03010413          	addi	s0,sp,48
  6c:	fca42e23          	sw	a0,-36(s0)
  70:	fcb42c23          	sw	a1,-40(s0)
  74:	fdc42783          	lw	a5,-36(s0)
  78:	fef42623          	sw	a5,-20(s0)
  7c:	fec42783          	lw	a5,-20(s0)
  80:	fd842703          	lw	a4,-40(s0)
  84:	00e7a023          	sw	a4,0(a5)
  88:	00000013          	nop
  8c:	02c12083          	lw	ra,44(sp)
  90:	02812403          	lw	s0,40(sp)
  94:	03010113          	addi	sp,sp,48
  98:	00008067          	ret

0000009c <store_move_to_ram>:
  9c:	fd010113          	addi	sp,sp,-48
  a0:	02112623          	sw	ra,44(sp)
  a4:	02812423          	sw	s0,40(sp)
  a8:	03010413          	addi	s0,sp,48
  ac:	fca42e23          	sw	a0,-36(s0)
  b0:	fcb42c23          	sw	a1,-40(s0)
  b4:	fcc42a23          	sw	a2,-44(s0)
  b8:	fcd42823          	sw	a3,-48(s0)
  bc:	41000793          	li	a5,1040
  c0:	fef42623          	sw	a5,-20(s0)
  c4:	fdc42703          	lw	a4,-36(s0)
  c8:	00070793          	mv	a5,a4
  cc:	00179793          	slli	a5,a5,0x1
  d0:	00e787b3          	add	a5,a5,a4
  d4:	00279793          	slli	a5,a5,0x2
  d8:	00078713          	mv	a4,a5
  dc:	fec42783          	lw	a5,-20(s0)
  e0:	00e787b3          	add	a5,a5,a4
  e4:	fd842703          	lw	a4,-40(s0)
  e8:	00e7a023          	sw	a4,0(a5)
  ec:	fdc42703          	lw	a4,-36(s0)
  f0:	00070793          	mv	a5,a4
  f4:	00179793          	slli	a5,a5,0x1
  f8:	00e787b3          	add	a5,a5,a4
  fc:	00279793          	slli	a5,a5,0x2
 100:	00078713          	mv	a4,a5
 104:	fec42783          	lw	a5,-20(s0)
 108:	00e787b3          	add	a5,a5,a4
 10c:	fd442703          	lw	a4,-44(s0)
 110:	00e7a223          	sw	a4,4(a5)
 114:	fdc42703          	lw	a4,-36(s0)
 118:	00070793          	mv	a5,a4
 11c:	00179793          	slli	a5,a5,0x1
 120:	00e787b3          	add	a5,a5,a4
 124:	00279793          	slli	a5,a5,0x2
 128:	00078713          	mv	a4,a5
 12c:	fec42783          	lw	a5,-20(s0)
 130:	00e787b3          	add	a5,a5,a4
 134:	fd042703          	lw	a4,-48(s0)
 138:	00e7a423          	sw	a4,8(a5)
 13c:	00000013          	nop
 140:	02c12083          	lw	ra,44(sp)
 144:	02812403          	lw	s0,40(sp)
 148:	03010113          	addi	sp,sp,48
 14c:	00008067          	ret

00000150 <set_piece>:
 150:	fd010113          	addi	sp,sp,-48
 154:	02112623          	sw	ra,44(sp)
 158:	02812423          	sw	s0,40(sp)
 15c:	03010413          	addi	s0,sp,48
 160:	fca42e23          	sw	a0,-36(s0)
 164:	fcb42c23          	sw	a1,-40(s0)
 168:	fcc42a23          	sw	a2,-44(s0)
 16c:	fdc42703          	lw	a4,-36(s0)
 170:	00070793          	mv	a5,a4
 174:	00279793          	slli	a5,a5,0x2
 178:	00e787b3          	add	a5,a5,a4
 17c:	00279793          	slli	a5,a5,0x2
 180:	40e78733          	sub	a4,a5,a4
 184:	fd842783          	lw	a5,-40(s0)
 188:	00f70733          	add	a4,a4,a5
 18c:	f00007b7          	lui	a5,0xf0000
 190:	00f707b3          	add	a5,a4,a5
 194:	00279793          	slli	a5,a5,0x2
 198:	fef42623          	sw	a5,-20(s0)
 19c:	fec42783          	lw	a5,-20(s0)
 1a0:	fd442703          	lw	a4,-44(s0)
 1a4:	00e7a023          	sw	a4,0(a5) # f0000000 <__global_pointer$+0xefffe384>
 1a8:	00000013          	nop
 1ac:	02c12083          	lw	ra,44(sp)
 1b0:	02812403          	lw	s0,40(sp)
 1b4:	03010113          	addi	sp,sp,48
 1b8:	00008067          	ret

000001bc <keyboard_interrupt>:
 1bc:	f9010113          	addi	sp,sp,-112
 1c0:	06112623          	sw	ra,108(sp)
 1c4:	06512423          	sw	t0,104(sp)
 1c8:	06612223          	sw	t1,100(sp)
 1cc:	06712023          	sw	t2,96(sp)
 1d0:	04812e23          	sw	s0,92(sp)
 1d4:	04a12c23          	sw	a0,88(sp)
 1d8:	04b12a23          	sw	a1,84(sp)
 1dc:	04c12823          	sw	a2,80(sp)
 1e0:	04d12623          	sw	a3,76(sp)
 1e4:	04e12423          	sw	a4,72(sp)
 1e8:	04f12223          	sw	a5,68(sp)
 1ec:	05012023          	sw	a6,64(sp)
 1f0:	03112e23          	sw	a7,60(sp)
 1f4:	03c12c23          	sw	t3,56(sp)
 1f8:	03d12a23          	sw	t4,52(sp)
 1fc:	03e12823          	sw	t5,48(sp)
 200:	03f12623          	sw	t6,44(sp)
 204:	07010413          	addi	s0,sp,112
 208:	f00007b7          	lui	a5,0xf0000
 20c:	00878793          	addi	a5,a5,8 # f0000008 <__global_pointer$+0xefffe38c>
 210:	0007a783          	lw	a5,0(a5)
 214:	faf407a3          	sb	a5,-81(s0)
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00078593          	mv	a1,a5
 220:	e0000537          	lui	a0,0xe0000
 224:	e39ff0ef          	jal	5c <write>
 228:	faf44703          	lbu	a4,-81(s0)
 22c:	02900793          	li	a5,41
 230:	0cf71863          	bne	a4,a5,300 <keyboard_interrupt+0x144>
 234:	000f8713          	mv	a4,t6
 238:	000017b7          	lui	a5,0x1
 23c:	47c7a783          	lw	a5,1148(a5) # 147c <__DATA_BEGIN__>
 240:	0cf77063          	bgeu	a4,a5,300 <keyboard_interrupt+0x144>
 244:	41000793          	li	a5,1040
 248:	faf42423          	sw	a5,-88(s0)
 24c:	000f8713          	mv	a4,t6
 250:	00070793          	mv	a5,a4
 254:	00179793          	slli	a5,a5,0x1
 258:	00e787b3          	add	a5,a5,a4
 25c:	00279793          	slli	a5,a5,0x2
 260:	00078713          	mv	a4,a5
 264:	fa842783          	lw	a5,-88(s0)
 268:	00e787b3          	add	a5,a5,a4
 26c:	0007a783          	lw	a5,0(a5)
 270:	faf42223          	sw	a5,-92(s0)
 274:	000f8713          	mv	a4,t6
 278:	00070793          	mv	a5,a4
 27c:	00179793          	slli	a5,a5,0x1
 280:	00e787b3          	add	a5,a5,a4
 284:	00279793          	slli	a5,a5,0x2
 288:	00078713          	mv	a4,a5
 28c:	fa842783          	lw	a5,-88(s0)
 290:	00e787b3          	add	a5,a5,a4
 294:	0047a783          	lw	a5,4(a5)
 298:	faf42023          	sw	a5,-96(s0)
 29c:	000f8713          	mv	a4,t6
 2a0:	00070793          	mv	a5,a4
 2a4:	00179793          	slli	a5,a5,0x1
 2a8:	00e787b3          	add	a5,a5,a4
 2ac:	00279793          	slli	a5,a5,0x2
 2b0:	00078713          	mv	a4,a5
 2b4:	fa842783          	lw	a5,-88(s0)
 2b8:	00e787b3          	add	a5,a5,a4
 2bc:	0087a783          	lw	a5,8(a5)
 2c0:	f8f42e23          	sw	a5,-100(s0)
 2c4:	f9c42603          	lw	a2,-100(s0)
 2c8:	fa042583          	lw	a1,-96(s0)
 2cc:	fa442503          	lw	a0,-92(s0)
 2d0:	e81ff0ef          	jal	150 <set_piece>
 2d4:	fa442783          	lw	a5,-92(s0)
 2d8:	00479713          	slli	a4,a5,0x4
 2dc:	fa042783          	lw	a5,-96(s0)
 2e0:	00f767b3          	or	a5,a4,a5
 2e4:	f8f42c23          	sw	a5,-104(s0)
 2e8:	f9842583          	lw	a1,-104(s0)
 2ec:	e0000537          	lui	a0,0xe0000
 2f0:	d6dff0ef          	jal	5c <write>
 2f4:	000f8793          	mv	a5,t6
 2f8:	00178793          	addi	a5,a5,1
 2fc:	00078f93          	mv	t6,a5
 300:	00000013          	nop
 304:	06c12083          	lw	ra,108(sp)
 308:	06812283          	lw	t0,104(sp)
 30c:	06412303          	lw	t1,100(sp)
 310:	06012383          	lw	t2,96(sp)
 314:	05c12403          	lw	s0,92(sp)
 318:	05812503          	lw	a0,88(sp)
 31c:	05412583          	lw	a1,84(sp)
 320:	05012603          	lw	a2,80(sp)
 324:	04c12683          	lw	a3,76(sp)
 328:	04812703          	lw	a4,72(sp)
 32c:	04412783          	lw	a5,68(sp)
 330:	04012803          	lw	a6,64(sp)
 334:	03c12883          	lw	a7,60(sp)
 338:	03812e03          	lw	t3,56(sp)
 33c:	03412e83          	lw	t4,52(sp)
 340:	03012f03          	lw	t5,48(sp)
 344:	02c12f83          	lw	t6,44(sp)
 348:	07010113          	addi	sp,sp,112
 34c:	30200073          	mret

00000350 <main>:
 350:	ff010113          	addi	sp,sp,-16
 354:	00112623          	sw	ra,12(sp)
 358:	00812423          	sw	s0,8(sp)
 35c:	01010413          	addi	s0,sp,16
 360:	00000f93          	li	t6,0
 364:	00100693          	li	a3,1
 368:	00300613          	li	a2,3
 36c:	00300593          	li	a1,3
 370:	00000513          	li	a0,0
 374:	d29ff0ef          	jal	9c <store_move_to_ram>
 378:	00200693          	li	a3,2
 37c:	00200613          	li	a2,2
 380:	00200593          	li	a1,2
 384:	00100513          	li	a0,1
 388:	d15ff0ef          	jal	9c <store_move_to_ram>
 38c:	00100693          	li	a3,1
 390:	00300613          	li	a2,3
 394:	00200593          	li	a1,2
 398:	00200513          	li	a0,2
 39c:	d01ff0ef          	jal	9c <store_move_to_ram>
 3a0:	00200693          	li	a3,2
 3a4:	00200613          	li	a2,2
 3a8:	00300593          	li	a1,3
 3ac:	00300513          	li	a0,3
 3b0:	cedff0ef          	jal	9c <store_move_to_ram>
 3b4:	00100693          	li	a3,1
 3b8:	00200613          	li	a2,2
 3bc:	00400593          	li	a1,4
 3c0:	00400513          	li	a0,4
 3c4:	cd9ff0ef          	jal	9c <store_move_to_ram>
 3c8:	00200693          	li	a3,2
 3cc:	00100613          	li	a2,1
 3d0:	00400593          	li	a1,4
 3d4:	00500513          	li	a0,5
 3d8:	cc5ff0ef          	jal	9c <store_move_to_ram>
 3dc:	00100693          	li	a3,1
 3e0:	00200613          	li	a2,2
 3e4:	00500593          	li	a1,5
 3e8:	00600513          	li	a0,6
 3ec:	cb1ff0ef          	jal	9c <store_move_to_ram>
 3f0:	00200693          	li	a3,2
 3f4:	00100613          	li	a2,1
 3f8:	00500593          	li	a1,5
 3fc:	00700513          	li	a0,7
 400:	c9dff0ef          	jal	9c <store_move_to_ram>
 404:	00100693          	li	a3,1
 408:	00200613          	li	a2,2
 40c:	00600593          	li	a1,6
 410:	00800513          	li	a0,8
 414:	c89ff0ef          	jal	9c <store_move_to_ram>
 418:	00200693          	li	a3,2
 41c:	00300613          	li	a2,3
 420:	00100593          	li	a1,1
 424:	00900513          	li	a0,9
 428:	c75ff0ef          	jal	9c <store_move_to_ram>
 42c:	00100693          	li	a3,1
 430:	00400613          	li	a2,4
 434:	00100593          	li	a1,1
 438:	00a00513          	li	a0,10
 43c:	c61ff0ef          	jal	9c <store_move_to_ram>
 440:	00200693          	li	a3,2
 444:	00200613          	li	a2,2
 448:	00100593          	li	a1,1
 44c:	00b00513          	li	a0,11
 450:	c4dff0ef          	jal	9c <store_move_to_ram>
 454:	00100693          	li	a3,1
 458:	00500613          	li	a2,5
 45c:	00200593          	li	a1,2
 460:	00c00513          	li	a0,12
 464:	c39ff0ef          	jal	9c <store_move_to_ram>
 468:	000017b7          	lui	a5,0x1
 46c:	00d00713          	li	a4,13
 470:	46e7ae23          	sw	a4,1148(a5) # 147c <__DATA_BEGIN__>
 474:	00000013          	nop
 478:	ffdff06f          	j	474 <main+0x124>
