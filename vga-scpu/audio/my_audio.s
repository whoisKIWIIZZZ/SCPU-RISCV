
./test:     file format elf32-littleriscv


Disassembly of section .text:

00000020 <Entry>:
  20:	ff010113          	addi	sp,sp,-16
  24:	00112623          	sw	ra,12(sp)
  28:	00812423          	sw	s0,8(sp)
  2c:	01010413          	addi	s0,sp,16
  30:	40000113          	li	sp,1024
  34:	401000ef          	jal	c34 <main>
  38:	0000006f          	j	38 <Entry+0x18>

0000003c <wait>:
  3c:	fe010113          	addi	sp,sp,-32
  40:	00112e23          	sw	ra,28(sp)
  44:	00812c23          	sw	s0,24(sp)
  48:	02010413          	addi	s0,sp,32
  4c:	fea42623          	sw	a0,-20(s0)
  50:	00000013          	nop
  54:	fec42783          	lw	a5,-20(s0)
  58:	fff78713          	addi	a4,a5,-1
  5c:	fee42623          	sw	a4,-20(s0)
  60:	fe079ae3          	bnez	a5,54 <wait+0x18>
  64:	00000013          	nop
  68:	00000013          	nop
  6c:	01c12083          	lw	ra,28(sp)
  70:	01812403          	lw	s0,24(sp)
  74:	02010113          	addi	sp,sp,32
  78:	00008067          	ret

0000007c <write>:
  7c:	fd010113          	addi	sp,sp,-48
  80:	02112623          	sw	ra,44(sp)
  84:	02812423          	sw	s0,40(sp)
  88:	03010413          	addi	s0,sp,48
  8c:	fca42e23          	sw	a0,-36(s0)
  90:	fcb42c23          	sw	a1,-40(s0)
  94:	fdc42783          	lw	a5,-36(s0)
  98:	fef42623          	sw	a5,-20(s0)
  9c:	fec42783          	lw	a5,-20(s0)
  a0:	fd842703          	lw	a4,-40(s0)
  a4:	00e7a023          	sw	a4,0(a5)
  a8:	00000013          	nop
  ac:	02c12083          	lw	ra,44(sp)
  b0:	02812403          	lw	s0,40(sp)
  b4:	03010113          	addi	sp,sp,48
  b8:	00008067          	ret

000000bc <read>:
  bc:	fd010113          	addi	sp,sp,-48
  c0:	02112623          	sw	ra,44(sp)
  c4:	02812423          	sw	s0,40(sp)
  c8:	03010413          	addi	s0,sp,48
  cc:	fca42e23          	sw	a0,-36(s0)
  d0:	fcb42c23          	sw	a1,-40(s0)
  d4:	fdc42783          	lw	a5,-36(s0)
  d8:	fef42623          	sw	a5,-20(s0)
  dc:	fec42783          	lw	a5,-20(s0)
  e0:	0007a703          	lw	a4,0(a5)
  e4:	fd842783          	lw	a5,-40(s0)
  e8:	00e7a023          	sw	a4,0(a5)
  ec:	00000013          	nop
  f0:	02c12083          	lw	ra,44(sp)
  f4:	02812403          	lw	s0,40(sp)
  f8:	03010113          	addi	sp,sp,48
  fc:	00008067          	ret

00000100 <keyboard_interrupt>:
 100:	fa010113          	addi	sp,sp,-96
 104:	04112e23          	sw	ra,92(sp)
 108:	04512c23          	sw	t0,88(sp)
 10c:	04612a23          	sw	t1,84(sp)
 110:	04712823          	sw	t2,80(sp)
 114:	04812623          	sw	s0,76(sp)
 118:	04a12423          	sw	a0,72(sp)
 11c:	04b12223          	sw	a1,68(sp)
 120:	04c12023          	sw	a2,64(sp)
 124:	02d12e23          	sw	a3,60(sp)
 128:	02e12c23          	sw	a4,56(sp)
 12c:	02f12a23          	sw	a5,52(sp)
 130:	03012823          	sw	a6,48(sp)
 134:	03112623          	sw	a7,44(sp)
 138:	03c12423          	sw	t3,40(sp)
 13c:	03d12223          	sw	t4,36(sp)
 140:	03e12023          	sw	t5,32(sp)
 144:	01f12e23          	sw	t6,28(sp)
 148:	06010413          	addi	s0,sp,96
 14c:	00100793          	li	a5,1
 150:	faf42423          	sw	a5,-88(s0)
 154:	fa840793          	addi	a5,s0,-88
 158:	00078593          	mv	a1,a5
 15c:	06000513          	li	a0,96
 160:	f5dff0ef          	jal	bc <read>
 164:	00800793          	li	a5,8
 168:	faf407a3          	sb	a5,-81(s0)
 16c:	faf44703          	lbu	a4,-81(s0)
 170:	04e00793          	li	a5,78
 174:	04f71063          	bne	a4,a5,1b4 <keyboard_interrupt+0xb4>
 178:	fa842703          	lw	a4,-88(s0)
 17c:	00200793          	li	a5,2
 180:	02e7fa63          	bgeu	a5,a4,1b4 <keyboard_interrupt+0xb4>
 184:	fa842783          	lw	a5,-88(s0)
 188:	fff78793          	addi	a5,a5,-1
 18c:	01f7f793          	andi	a5,a5,31
 190:	faf42423          	sw	a5,-88(s0)
 194:	fa842783          	lw	a5,-88(s0)
 198:	00078593          	mv	a1,a5
 19c:	06000513          	li	a0,96
 1a0:	eddff0ef          	jal	7c <write>
 1a4:	fa842783          	lw	a5,-88(s0)
 1a8:	00078593          	mv	a1,a5
 1ac:	d1000537          	lui	a0,0xd1000
 1b0:	ecdff0ef          	jal	7c <write>
 1b4:	00000013          	nop
 1b8:	05c12083          	lw	ra,92(sp)
 1bc:	05812283          	lw	t0,88(sp)
 1c0:	05412303          	lw	t1,84(sp)
 1c4:	05012383          	lw	t2,80(sp)
 1c8:	04c12403          	lw	s0,76(sp)
 1cc:	04812503          	lw	a0,72(sp)
 1d0:	04412583          	lw	a1,68(sp)
 1d4:	04012603          	lw	a2,64(sp)
 1d8:	03c12683          	lw	a3,60(sp)
 1dc:	03812703          	lw	a4,56(sp)
 1e0:	03412783          	lw	a5,52(sp)
 1e4:	03012803          	lw	a6,48(sp)
 1e8:	02c12883          	lw	a7,44(sp)
 1ec:	02812e03          	lw	t3,40(sp)
 1f0:	02412e83          	lw	t4,36(sp)
 1f4:	02012f03          	lw	t5,32(sp)
 1f8:	01c12f83          	lw	t6,28(sp)
 1fc:	06010113          	addi	sp,sp,96
 200:	30200073          	mret

00000204 <song>:
 204:	ff010113          	addi	sp,sp,-16
 208:	00112623          	sw	ra,12(sp)
 20c:	00812423          	sw	s0,8(sp)
 210:	01010413          	addi	s0,sp,16
 214:	000537b7          	lui	a5,0x53
 218:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 21c:	b0000537          	lui	a0,0xb0000
 220:	e5dff0ef          	jal	7c <write>
 224:	004c57b7          	lui	a5,0x4c5
 228:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 22c:	e11ff0ef          	jal	3c <wait>
 230:	000427b7          	lui	a5,0x42
 234:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 238:	b0000537          	lui	a0,0xb0000
 23c:	e41ff0ef          	jal	7c <write>
 240:	002627b7          	lui	a5,0x262
 244:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 248:	df5ff0ef          	jal	3c <wait>
 24c:	000377b7          	lui	a5,0x37
 250:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 254:	b0000537          	lui	a0,0xb0000
 258:	e25ff0ef          	jal	7c <write>
 25c:	0055d7b7          	lui	a5,0x55d
 260:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 264:	dd9ff0ef          	jal	3c <wait>
 268:	0004a7b7          	lui	a5,0x4a
 26c:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 270:	b0000537          	lui	a0,0xb0000
 274:	e09ff0ef          	jal	7c <write>
 278:	0068e7b7          	lui	a5,0x68e
 27c:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 280:	dbdff0ef          	jal	3c <wait>
 284:	000587b7          	lui	a5,0x58
 288:	14578593          	addi	a1,a5,325 # 58145 <__global_pointer$+0x55cf5>
 28c:	b0000537          	lui	a0,0xb0000
 290:	dedff0ef          	jal	7c <write>
 294:	004c57b7          	lui	a5,0x4c5
 298:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 29c:	da1ff0ef          	jal	3c <wait>
 2a0:	000537b7          	lui	a5,0x53
 2a4:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 2a8:	b0000537          	lui	a0,0xb0000
 2ac:	dd1ff0ef          	jal	7c <write>
 2b0:	00e4e7b7          	lui	a5,0xe4e
 2b4:	1c078513          	addi	a0,a5,448 # e4e1c0 <__global_pointer$+0xe4bd70>
 2b8:	d85ff0ef          	jal	3c <wait>
 2bc:	0002a7b7          	lui	a5,0x2a
 2c0:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 2c4:	b0000537          	lui	a0,0xb0000
 2c8:	db5ff0ef          	jal	7c <write>
 2cc:	002627b7          	lui	a5,0x262
 2d0:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 2d4:	d69ff0ef          	jal	3c <wait>
 2d8:	0002c7b7          	lui	a5,0x2c
 2dc:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 2e0:	b0000537          	lui	a0,0xb0000
 2e4:	d99ff0ef          	jal	7c <write>
 2e8:	002627b7          	lui	a5,0x262
 2ec:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 2f0:	d4dff0ef          	jal	3c <wait>
 2f4:	000317b7          	lui	a5,0x31
 2f8:	6ed78593          	addi	a1,a5,1773 # 316ed <__global_pointer$+0x2f29d>
 2fc:	b0000537          	lui	a0,0xb0000
 300:	d7dff0ef          	jal	7c <write>
 304:	002627b7          	lui	a5,0x262
 308:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 30c:	d31ff0ef          	jal	3c <wait>
 310:	000377b7          	lui	a5,0x37
 314:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 318:	b0000537          	lui	a0,0xb0000
 31c:	d61ff0ef          	jal	7c <write>
 320:	002627b7          	lui	a5,0x262
 324:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 328:	d15ff0ef          	jal	3c <wait>
 32c:	000537b7          	lui	a5,0x53
 330:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 334:	b0000537          	lui	a0,0xb0000
 338:	d45ff0ef          	jal	7c <write>
 33c:	004787b7          	lui	a5,0x478
 340:	68c78513          	addi	a0,a5,1676 # 47868c <__global_pointer$+0x47623c>
 344:	cf9ff0ef          	jal	3c <wait>
 348:	00000593          	li	a1,0
 34c:	b0000537          	lui	a0,0xb0000
 350:	d2dff0ef          	jal	7c <write>
 354:	0004c7b7          	lui	a5,0x4c
 358:	4b478513          	addi	a0,a5,1204 # 4c4b4 <__global_pointer$+0x4a064>
 35c:	ce1ff0ef          	jal	3c <wait>
 360:	000427b7          	lui	a5,0x42
 364:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 368:	b0000537          	lui	a0,0xb0000
 36c:	d11ff0ef          	jal	7c <write>
 370:	002fb7b7          	lui	a5,0x2fb
 374:	f0878513          	addi	a0,a5,-248 # 2faf08 <__global_pointer$+0x2f8ab8>
 378:	cc5ff0ef          	jal	3c <wait>
 37c:	000377b7          	lui	a5,0x37
 380:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 384:	b0000537          	lui	a0,0xb0000
 388:	cf5ff0ef          	jal	7c <write>
 38c:	0055d7b7          	lui	a5,0x55d
 390:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 394:	ca9ff0ef          	jal	3c <wait>
 398:	0004a7b7          	lui	a5,0x4a
 39c:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 3a0:	b0000537          	lui	a0,0xb0000
 3a4:	cd9ff0ef          	jal	7c <write>
 3a8:	0068e7b7          	lui	a5,0x68e
 3ac:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 3b0:	c8dff0ef          	jal	3c <wait>
 3b4:	0002c7b7          	lui	a5,0x2c
 3b8:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 3bc:	b0000537          	lui	a0,0xb0000
 3c0:	cbdff0ef          	jal	7c <write>
 3c4:	00fcc7b7          	lui	a5,0xfcc
 3c8:	94478513          	addi	a0,a5,-1724 # fcb944 <__global_pointer$+0xfc94f4>
 3cc:	c71ff0ef          	jal	3c <wait>
 3d0:	0002a7b7          	lui	a5,0x2a
 3d4:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 3d8:	b0000537          	lui	a0,0xb0000
 3dc:	ca1ff0ef          	jal	7c <write>
 3e0:	002627b7          	lui	a5,0x262
 3e4:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 3e8:	c55ff0ef          	jal	3c <wait>
 3ec:	00000593          	li	a1,0
 3f0:	b0000537          	lui	a0,0xb0000
 3f4:	c89ff0ef          	jal	7c <write>
 3f8:	002627b7          	lui	a5,0x262
 3fc:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 400:	c3dff0ef          	jal	3c <wait>
 404:	000377b7          	lui	a5,0x37
 408:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 40c:	b0000537          	lui	a0,0xb0000
 410:	c6dff0ef          	jal	7c <write>
 414:	002627b7          	lui	a5,0x262
 418:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 41c:	c21ff0ef          	jal	3c <wait>
 420:	0002a7b7          	lui	a5,0x2a
 424:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 428:	b0000537          	lui	a0,0xb0000
 42c:	c51ff0ef          	jal	7c <write>
 430:	002627b7          	lui	a5,0x262
 434:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 438:	c05ff0ef          	jal	3c <wait>
 43c:	0002c7b7          	lui	a5,0x2c
 440:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 444:	b0000537          	lui	a0,0xb0000
 448:	c35ff0ef          	jal	7c <write>
 44c:	002627b7          	lui	a5,0x262
 450:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 454:	be9ff0ef          	jal	3c <wait>
 458:	000427b7          	lui	a5,0x42
 45c:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 460:	b0000537          	lui	a0,0xb0000
 464:	c19ff0ef          	jal	7c <write>
 468:	002627b7          	lui	a5,0x262
 46c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 470:	bcdff0ef          	jal	3c <wait>
 474:	0002c7b7          	lui	a5,0x2c
 478:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 47c:	b0000537          	lui	a0,0xb0000
 480:	bfdff0ef          	jal	7c <write>
 484:	004c57b7          	lui	a5,0x4c5
 488:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 48c:	bb1ff0ef          	jal	3c <wait>
 490:	0002a7b7          	lui	a5,0x2a
 494:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 498:	b0000537          	lui	a0,0xb0000
 49c:	be1ff0ef          	jal	7c <write>
 4a0:	002fb7b7          	lui	a5,0x2fb
 4a4:	f0878513          	addi	a0,a5,-248 # 2faf08 <__global_pointer$+0x2f8ab8>
 4a8:	b95ff0ef          	jal	3c <wait>
 4ac:	0002c7b7          	lui	a5,0x2c
 4b0:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 4b4:	b0000537          	lui	a0,0xb0000
 4b8:	bc5ff0ef          	jal	7c <write>
 4bc:	0055d7b7          	lui	a5,0x55d
 4c0:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 4c4:	b79ff0ef          	jal	3c <wait>
 4c8:	0004a7b7          	lui	a5,0x4a
 4cc:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 4d0:	b0000537          	lui	a0,0xb0000
 4d4:	ba9ff0ef          	jal	7c <write>
 4d8:	0068e7b7          	lui	a5,0x68e
 4dc:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 4e0:	b5dff0ef          	jal	3c <wait>
 4e4:	000427b7          	lui	a5,0x42
 4e8:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 4ec:	b0000537          	lui	a0,0xb0000
 4f0:	b8dff0ef          	jal	7c <write>
 4f4:	007277b7          	lui	a5,0x727
 4f8:	0e078513          	addi	a0,a5,224 # 7270e0 <__global_pointer$+0x724c90>
 4fc:	b41ff0ef          	jal	3c <wait>
 500:	000377b7          	lui	a5,0x37
 504:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 508:	b0000537          	lui	a0,0xb0000
 50c:	b71ff0ef          	jal	7c <write>
 510:	002627b7          	lui	a5,0x262
 514:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 518:	b25ff0ef          	jal	3c <wait>
 51c:	000427b7          	lui	a5,0x42
 520:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 524:	b0000537          	lui	a0,0xb0000
 528:	b55ff0ef          	jal	7c <write>
 52c:	002627b7          	lui	a5,0x262
 530:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 534:	b09ff0ef          	jal	3c <wait>
 538:	000317b7          	lui	a5,0x31
 53c:	6ed78593          	addi	a1,a5,1773 # 316ed <__global_pointer$+0x2f29d>
 540:	b0000537          	lui	a0,0xb0000
 544:	b39ff0ef          	jal	7c <write>
 548:	002627b7          	lui	a5,0x262
 54c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 550:	aedff0ef          	jal	3c <wait>
 554:	000377b7          	lui	a5,0x37
 558:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 55c:	b0000537          	lui	a0,0xb0000
 560:	b1dff0ef          	jal	7c <write>
 564:	002627b7          	lui	a5,0x262
 568:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 56c:	ad1ff0ef          	jal	3c <wait>
 570:	000537b7          	lui	a5,0x53
 574:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 578:	b0000537          	lui	a0,0xb0000
 57c:	b01ff0ef          	jal	7c <write>
 580:	002627b7          	lui	a5,0x262
 584:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 588:	ab5ff0ef          	jal	3c <wait>
 58c:	000587b7          	lui	a5,0x58
 590:	14578593          	addi	a1,a5,325 # 58145 <__global_pointer$+0x55cf5>
 594:	b0000537          	lui	a0,0xb0000
 598:	ae5ff0ef          	jal	7c <write>
 59c:	004c57b7          	lui	a5,0x4c5
 5a0:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 5a4:	a99ff0ef          	jal	3c <wait>
 5a8:	000427b7          	lui	a5,0x42
 5ac:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 5b0:	b0000537          	lui	a0,0xb0000
 5b4:	ac9ff0ef          	jal	7c <write>
 5b8:	002627b7          	lui	a5,0x262
 5bc:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 5c0:	a7dff0ef          	jal	3c <wait>
 5c4:	000377b7          	lui	a5,0x37
 5c8:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 5cc:	b0000537          	lui	a0,0xb0000
 5d0:	aadff0ef          	jal	7c <write>
 5d4:	0055d7b7          	lui	a5,0x55d
 5d8:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 5dc:	a61ff0ef          	jal	3c <wait>
 5e0:	0004a7b7          	lui	a5,0x4a
 5e4:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 5e8:	b0000537          	lui	a0,0xb0000
 5ec:	a91ff0ef          	jal	7c <write>
 5f0:	0068e7b7          	lui	a5,0x68e
 5f4:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 5f8:	a45ff0ef          	jal	3c <wait>
 5fc:	000427b7          	lui	a5,0x42
 600:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 604:	b0000537          	lui	a0,0xb0000
 608:	a75ff0ef          	jal	7c <write>
 60c:	004c57b7          	lui	a5,0x4c5
 610:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 614:	a29ff0ef          	jal	3c <wait>
 618:	000377b7          	lui	a5,0x37
 61c:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 620:	b0000537          	lui	a0,0xb0000
 624:	a59ff0ef          	jal	7c <write>
 628:	002627b7          	lui	a5,0x262
 62c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 630:	a0dff0ef          	jal	3c <wait>
 634:	000377b7          	lui	a5,0x37
 638:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 63c:	b0000537          	lui	a0,0xb0000
 640:	a3dff0ef          	jal	7c <write>
 644:	004787b7          	lui	a5,0x478
 648:	68c78513          	addi	a0,a5,1676 # 47868c <__global_pointer$+0x47623c>
 64c:	9f1ff0ef          	jal	3c <wait>
 650:	0004a7b7          	lui	a5,0x4a
 654:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 658:	b0000537          	lui	a0,0xb0000
 65c:	a21ff0ef          	jal	7c <write>
 660:	004c57b7          	lui	a5,0x4c5
 664:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 668:	9d5ff0ef          	jal	3c <wait>
 66c:	000537b7          	lui	a5,0x53
 670:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 674:	b0000537          	lui	a0,0xb0000
 678:	a05ff0ef          	jal	7c <write>
 67c:	002627b7          	lui	a5,0x262
 680:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 684:	9b9ff0ef          	jal	3c <wait>
 688:	0004a7b7          	lui	a5,0x4a
 68c:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 690:	b0000537          	lui	a0,0xb0000
 694:	9e9ff0ef          	jal	7c <write>
 698:	004c57b7          	lui	a5,0x4c5
 69c:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 6a0:	99dff0ef          	jal	3c <wait>
 6a4:	000537b7          	lui	a5,0x53
 6a8:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 6ac:	b0000537          	lui	a0,0xb0000
 6b0:	9cdff0ef          	jal	7c <write>
 6b4:	004c57b7          	lui	a5,0x4c5
 6b8:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 6bc:	981ff0ef          	jal	3c <wait>
 6c0:	000427b7          	lui	a5,0x42
 6c4:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 6c8:	b0000537          	lui	a0,0xb0000
 6cc:	9b1ff0ef          	jal	7c <write>
 6d0:	002627b7          	lui	a5,0x262
 6d4:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 6d8:	965ff0ef          	jal	3c <wait>
 6dc:	000377b7          	lui	a5,0x37
 6e0:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 6e4:	b0000537          	lui	a0,0xb0000
 6e8:	995ff0ef          	jal	7c <write>
 6ec:	0055d7b7          	lui	a5,0x55d
 6f0:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 6f4:	949ff0ef          	jal	3c <wait>
 6f8:	0004a7b7          	lui	a5,0x4a
 6fc:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 700:	b0000537          	lui	a0,0xb0000
 704:	979ff0ef          	jal	7c <write>
 708:	0042c7b7          	lui	a5,0x42c
 70c:	1d878513          	addi	a0,a5,472 # 42c1d8 <__global_pointer$+0x429d88>
 710:	92dff0ef          	jal	3c <wait>
 714:	000537b7          	lui	a5,0x53
 718:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 71c:	b0000537          	lui	a0,0xb0000
 720:	95dff0ef          	jal	7c <write>
 724:	002627b7          	lui	a5,0x262
 728:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 72c:	911ff0ef          	jal	3c <wait>
 730:	0002a7b7          	lui	a5,0x2a
 734:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 738:	b0000537          	lui	a0,0xb0000
 73c:	941ff0ef          	jal	7c <write>
 740:	002627b7          	lui	a5,0x262
 744:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 748:	8f5ff0ef          	jal	3c <wait>
 74c:	0002c7b7          	lui	a5,0x2c
 750:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 754:	b0000537          	lui	a0,0xb0000
 758:	925ff0ef          	jal	7c <write>
 75c:	002627b7          	lui	a5,0x262
 760:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 764:	8d9ff0ef          	jal	3c <wait>
 768:	000317b7          	lui	a5,0x31
 76c:	6ed78593          	addi	a1,a5,1773 # 316ed <__global_pointer$+0x2f29d>
 770:	b0000537          	lui	a0,0xb0000
 774:	909ff0ef          	jal	7c <write>
 778:	002627b7          	lui	a5,0x262
 77c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 780:	8bdff0ef          	jal	3c <wait>
 784:	000377b7          	lui	a5,0x37
 788:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 78c:	b0000537          	lui	a0,0xb0000
 790:	8edff0ef          	jal	7c <write>
 794:	002627b7          	lui	a5,0x262
 798:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 79c:	8a1ff0ef          	jal	3c <wait>
 7a0:	0004a7b7          	lui	a5,0x4a
 7a4:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 7a8:	b0000537          	lui	a0,0xb0000
 7ac:	8d1ff0ef          	jal	7c <write>
 7b0:	002627b7          	lui	a5,0x262
 7b4:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 7b8:	885ff0ef          	jal	3c <wait>
 7bc:	000427b7          	lui	a5,0x42
 7c0:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 7c4:	b0000537          	lui	a0,0xb0000
 7c8:	8b5ff0ef          	jal	7c <write>
 7cc:	003947b7          	lui	a5,0x394
 7d0:	87078513          	addi	a0,a5,-1936 # 393870 <__global_pointer$+0x391420>
 7d4:	869ff0ef          	jal	3c <wait>
 7d8:	00000593          	li	a1,0
 7dc:	b0000537          	lui	a0,0xb0000
 7e0:	89dff0ef          	jal	7c <write>
 7e4:	001317b7          	lui	a5,0x131
 7e8:	2d078513          	addi	a0,a5,720 # 1312d0 <__global_pointer$+0x12ee80>
 7ec:	851ff0ef          	jal	3c <wait>
 7f0:	000427b7          	lui	a5,0x42
 7f4:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 7f8:	b0000537          	lui	a0,0xb0000
 7fc:	881ff0ef          	jal	7c <write>
 800:	002627b7          	lui	a5,0x262
 804:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 808:	835ff0ef          	jal	3c <wait>
 80c:	000537b7          	lui	a5,0x53
 810:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 814:	b0000537          	lui	a0,0xb0000
 818:	865ff0ef          	jal	7c <write>
 81c:	004787b7          	lui	a5,0x478
 820:	68c78513          	addi	a0,a5,1676 # 47868c <__global_pointer$+0x47623c>
 824:	819ff0ef          	jal	3c <wait>
 828:	00000593          	li	a1,0
 82c:	b0000537          	lui	a0,0xb0000
 830:	84dff0ef          	jal	7c <write>
 834:	0004c7b7          	lui	a5,0x4c
 838:	4b478513          	addi	a0,a5,1204 # 4c4b4 <__global_pointer$+0x4a064>
 83c:	801ff0ef          	jal	3c <wait>
 840:	000427b7          	lui	a5,0x42
 844:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 848:	b0000537          	lui	a0,0xb0000
 84c:	831ff0ef          	jal	7c <write>
 850:	002fb7b7          	lui	a5,0x2fb
 854:	f0878513          	addi	a0,a5,-248 # 2faf08 <__global_pointer$+0x2f8ab8>
 858:	fe4ff0ef          	jal	3c <wait>
 85c:	000377b7          	lui	a5,0x37
 860:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 864:	b0000537          	lui	a0,0xb0000
 868:	815ff0ef          	jal	7c <write>
 86c:	0055d7b7          	lui	a5,0x55d
 870:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 874:	fc8ff0ef          	jal	3c <wait>
 878:	000427b7          	lui	a5,0x42
 87c:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 880:	b0000537          	lui	a0,0xb0000
 884:	ff8ff0ef          	jal	7c <write>
 888:	00f0d7b7          	lui	a5,0xf0d
 88c:	d8278513          	addi	a0,a5,-638 # f0cd82 <__global_pointer$+0xf0a932>
 890:	facff0ef          	jal	3c <wait>
 894:	0004a7b7          	lui	a5,0x4a
 898:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 89c:	b0000537          	lui	a0,0xb0000
 8a0:	fdcff0ef          	jal	7c <write>
 8a4:	0042c7b7          	lui	a5,0x42c
 8a8:	1d878513          	addi	a0,a5,472 # 42c1d8 <__global_pointer$+0x429d88>
 8ac:	f90ff0ef          	jal	3c <wait>
 8b0:	0002c7b7          	lui	a5,0x2c
 8b4:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 8b8:	b0000537          	lui	a0,0xb0000
 8bc:	fc0ff0ef          	jal	7c <write>
 8c0:	007737b7          	lui	a5,0x773
 8c4:	59478513          	addi	a0,a5,1428 # 773594 <__global_pointer$+0x771144>
 8c8:	f74ff0ef          	jal	3c <wait>
 8cc:	00000593          	li	a1,0
 8d0:	b0000537          	lui	a0,0xb0000
 8d4:	fa8ff0ef          	jal	7c <write>
 8d8:	0004c7b7          	lui	a5,0x4c
 8dc:	4b478513          	addi	a0,a5,1204 # 4c4b4 <__global_pointer$+0x4a064>
 8e0:	f5cff0ef          	jal	3c <wait>
 8e4:	0002a7b7          	lui	a5,0x2a
 8e8:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 8ec:	b0000537          	lui	a0,0xb0000
 8f0:	f8cff0ef          	jal	7c <write>
 8f4:	002627b7          	lui	a5,0x262
 8f8:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 8fc:	f40ff0ef          	jal	3c <wait>
 900:	0002c7b7          	lui	a5,0x2c
 904:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 908:	b0000537          	lui	a0,0xb0000
 90c:	f70ff0ef          	jal	7c <write>
 910:	002627b7          	lui	a5,0x262
 914:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 918:	f24ff0ef          	jal	3c <wait>
 91c:	000377b7          	lui	a5,0x37
 920:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 924:	b0000537          	lui	a0,0xb0000
 928:	f54ff0ef          	jal	7c <write>
 92c:	002627b7          	lui	a5,0x262
 930:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 934:	f08ff0ef          	jal	3c <wait>
 938:	0002a7b7          	lui	a5,0x2a
 93c:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 940:	b0000537          	lui	a0,0xb0000
 944:	f38ff0ef          	jal	7c <write>
 948:	002627b7          	lui	a5,0x262
 94c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 950:	eecff0ef          	jal	3c <wait>
 954:	000257b7          	lui	a5,0x25
 958:	08678593          	addi	a1,a5,134 # 25086 <__global_pointer$+0x22c36>
 95c:	b0000537          	lui	a0,0xb0000
 960:	f1cff0ef          	jal	7c <write>
 964:	002627b7          	lui	a5,0x262
 968:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 96c:	ed0ff0ef          	jal	3c <wait>
 970:	000217b7          	lui	a5,0x21
 974:	fe178593          	addi	a1,a5,-31 # 20fe1 <__global_pointer$+0x1eb91>
 978:	b0000537          	lui	a0,0xb0000
 97c:	f00ff0ef          	jal	7c <write>
 980:	002627b7          	lui	a5,0x262
 984:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 988:	eb4ff0ef          	jal	3c <wait>
 98c:	0002c7b7          	lui	a5,0x2c
 990:	0a278593          	addi	a1,a5,162 # 2c0a2 <__global_pointer$+0x29c52>
 994:	b0000537          	lui	a0,0xb0000
 998:	ee4ff0ef          	jal	7c <write>
 99c:	004c57b7          	lui	a5,0x4c5
 9a0:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 9a4:	e98ff0ef          	jal	3c <wait>
 9a8:	0002a7b7          	lui	a5,0x2a
 9ac:	91678593          	addi	a1,a5,-1770 # 29916 <__global_pointer$+0x274c6>
 9b0:	b0000537          	lui	a0,0xb0000
 9b4:	ec8ff0ef          	jal	7c <write>
 9b8:	002fb7b7          	lui	a5,0x2fb
 9bc:	f0878513          	addi	a0,a5,-248 # 2faf08 <__global_pointer$+0x2f8ab8>
 9c0:	e7cff0ef          	jal	3c <wait>
 9c4:	000427b7          	lui	a5,0x42
 9c8:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 9cc:	b0000537          	lui	a0,0xb0000
 9d0:	eacff0ef          	jal	7c <write>
 9d4:	0055d7b7          	lui	a5,0x55d
 9d8:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 9dc:	e60ff0ef          	jal	3c <wait>
 9e0:	000377b7          	lui	a5,0x37
 9e4:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 9e8:	b0000537          	lui	a0,0xb0000
 9ec:	e90ff0ef          	jal	7c <write>
 9f0:	0068e7b7          	lui	a5,0x68e
 9f4:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 9f8:	e44ff0ef          	jal	3c <wait>
 9fc:	000427b7          	lui	a5,0x42
 a00:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 a04:	b0000537          	lui	a0,0xb0000
 a08:	e74ff0ef          	jal	7c <write>
 a0c:	007277b7          	lui	a5,0x727
 a10:	0e078513          	addi	a0,a5,224 # 7270e0 <__global_pointer$+0x724c90>
 a14:	e28ff0ef          	jal	3c <wait>
 a18:	000377b7          	lui	a5,0x37
 a1c:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 a20:	b0000537          	lui	a0,0xb0000
 a24:	e58ff0ef          	jal	7c <write>
 a28:	002627b7          	lui	a5,0x262
 a2c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 a30:	e0cff0ef          	jal	3c <wait>
 a34:	000427b7          	lui	a5,0x42
 a38:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 a3c:	b0000537          	lui	a0,0xb0000
 a40:	e3cff0ef          	jal	7c <write>
 a44:	002627b7          	lui	a5,0x262
 a48:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 a4c:	df0ff0ef          	jal	3c <wait>
 a50:	000317b7          	lui	a5,0x31
 a54:	6ed78593          	addi	a1,a5,1773 # 316ed <__global_pointer$+0x2f29d>
 a58:	b0000537          	lui	a0,0xb0000
 a5c:	e20ff0ef          	jal	7c <write>
 a60:	002627b7          	lui	a5,0x262
 a64:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 a68:	dd4ff0ef          	jal	3c <wait>
 a6c:	000377b7          	lui	a5,0x37
 a70:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 a74:	b0000537          	lui	a0,0xb0000
 a78:	e04ff0ef          	jal	7c <write>
 a7c:	002627b7          	lui	a5,0x262
 a80:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 a84:	db8ff0ef          	jal	3c <wait>
 a88:	000537b7          	lui	a5,0x53
 a8c:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 a90:	b0000537          	lui	a0,0xb0000
 a94:	de8ff0ef          	jal	7c <write>
 a98:	002627b7          	lui	a5,0x262
 a9c:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 aa0:	d9cff0ef          	jal	3c <wait>
 aa4:	000587b7          	lui	a5,0x58
 aa8:	14578593          	addi	a1,a5,325 # 58145 <__global_pointer$+0x55cf5>
 aac:	b0000537          	lui	a0,0xb0000
 ab0:	dccff0ef          	jal	7c <write>
 ab4:	0052a7b7          	lui	a5,0x52a
 ab8:	6da78513          	addi	a0,a5,1754 # 52a6da <__global_pointer$+0x52828a>
 abc:	d80ff0ef          	jal	3c <wait>
 ac0:	000427b7          	lui	a5,0x42
 ac4:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 ac8:	b0000537          	lui	a0,0xb0000
 acc:	db0ff0ef          	jal	7c <write>
 ad0:	002627b7          	lui	a5,0x262
 ad4:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 ad8:	d64ff0ef          	jal	3c <wait>
 adc:	000377b7          	lui	a5,0x37
 ae0:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 ae4:	b0000537          	lui	a0,0xb0000
 ae8:	d94ff0ef          	jal	7c <write>
 aec:	0055d7b7          	lui	a5,0x55d
 af0:	4a878513          	addi	a0,a5,1192 # 55d4a8 <__global_pointer$+0x55b058>
 af4:	d48ff0ef          	jal	3c <wait>
 af8:	0004a7b7          	lui	a5,0x4a
 afc:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 b00:	b0000537          	lui	a0,0xb0000
 b04:	d78ff0ef          	jal	7c <write>
 b08:	0068e7b7          	lui	a5,0x68e
 b0c:	77878513          	addi	a0,a5,1912 # 68e778 <__global_pointer$+0x68c328>
 b10:	d2cff0ef          	jal	3c <wait>
 b14:	000427b7          	lui	a5,0x42
 b18:	fc278593          	addi	a1,a5,-62 # 41fc2 <__global_pointer$+0x3fb72>
 b1c:	b0000537          	lui	a0,0xb0000
 b20:	d5cff0ef          	jal	7c <write>
 b24:	004c57b7          	lui	a5,0x4c5
 b28:	b4078513          	addi	a0,a5,-1216 # 4c4b40 <__global_pointer$+0x4c26f0>
 b2c:	d10ff0ef          	jal	3c <wait>
 b30:	000377b7          	lui	a5,0x37
 b34:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 b38:	b0000537          	lui	a0,0xb0000
 b3c:	d40ff0ef          	jal	7c <write>
 b40:	001317b7          	lui	a5,0x131
 b44:	2d078513          	addi	a0,a5,720 # 1312d0 <__global_pointer$+0x12ee80>
 b48:	cf4ff0ef          	jal	3c <wait>
 b4c:	00000593          	li	a1,0
 b50:	b0000537          	lui	a0,0xb0000
 b54:	d28ff0ef          	jal	7c <write>
 b58:	001317b7          	lui	a5,0x131
 b5c:	2d078513          	addi	a0,a5,720 # 1312d0 <__global_pointer$+0x12ee80>
 b60:	cdcff0ef          	jal	3c <wait>
 b64:	000377b7          	lui	a5,0x37
 b68:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 b6c:	b0000537          	lui	a0,0xb0000
 b70:	d0cff0ef          	jal	7c <write>
 b74:	002167b7          	lui	a5,0x216
 b78:	0ec78513          	addi	a0,a5,236 # 2160ec <__global_pointer$+0x213c9c>
 b7c:	cc0ff0ef          	jal	3c <wait>
 b80:	00000593          	li	a1,0
 b84:	b0000537          	lui	a0,0xb0000
 b88:	cf4ff0ef          	jal	7c <write>
 b8c:	0004c7b7          	lui	a5,0x4c
 b90:	4b478513          	addi	a0,a5,1204 # 4c4b4 <__global_pointer$+0x4a064>
 b94:	ca8ff0ef          	jal	3c <wait>
 b98:	000317b7          	lui	a5,0x31
 b9c:	6ed78593          	addi	a1,a5,1773 # 316ed <__global_pointer$+0x2f29d>
 ba0:	b0000537          	lui	a0,0xb0000
 ba4:	cd8ff0ef          	jal	7c <write>
 ba8:	002627b7          	lui	a5,0x262
 bac:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 bb0:	c8cff0ef          	jal	3c <wait>
 bb4:	000377b7          	lui	a5,0x37
 bb8:	7c978593          	addi	a1,a5,1993 # 377c9 <__global_pointer$+0x35379>
 bbc:	b0000537          	lui	a0,0xb0000
 bc0:	cbcff0ef          	jal	7c <write>
 bc4:	002627b7          	lui	a5,0x262
 bc8:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 bcc:	c70ff0ef          	jal	3c <wait>
 bd0:	0004a7b7          	lui	a5,0x4a
 bd4:	10d78593          	addi	a1,a5,269 # 4a10d <__global_pointer$+0x47cbd>
 bd8:	b0000537          	lui	a0,0xb0000
 bdc:	ca0ff0ef          	jal	7c <write>
 be0:	002627b7          	lui	a5,0x262
 be4:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 be8:	c54ff0ef          	jal	3c <wait>
 bec:	00000593          	li	a1,0
 bf0:	b0000537          	lui	a0,0xb0000
 bf4:	c88ff0ef          	jal	7c <write>
 bf8:	0026f7b7          	lui	a5,0x26f
 bfc:	11378513          	addi	a0,a5,275 # 26f113 <__global_pointer$+0x26ccc3>
 c00:	c3cff0ef          	jal	3c <wait>
 c04:	000537b7          	lui	a5,0x53
 c08:	22c78593          	addi	a1,a5,556 # 5322c <__global_pointer$+0x50ddc>
 c0c:	b0000537          	lui	a0,0xb0000
 c10:	c6cff0ef          	jal	7c <write>
 c14:	002627b7          	lui	a5,0x262
 c18:	5a078513          	addi	a0,a5,1440 # 2625a0 <__global_pointer$+0x260150>
 c1c:	c20ff0ef          	jal	3c <wait>
 c20:	00000013          	nop
 c24:	00c12083          	lw	ra,12(sp)
 c28:	00812403          	lw	s0,8(sp)
 c2c:	01010113          	addi	sp,sp,16
 c30:	00008067          	ret

00000c34 <main>:
 c34:	fe010113          	addi	sp,sp,-32
 c38:	00112e23          	sw	ra,28(sp)
 c3c:	00812c23          	sw	s0,24(sp)
 c40:	02010413          	addi	s0,sp,32
 c44:	fe042623          	sw	zero,-20(s0)
 c48:	dbcff0ef          	jal	204 <song>
 c4c:	ffdff06f          	j	c48 <main+0x14>
