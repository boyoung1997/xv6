
_hugefiletest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 04 00 00    	sub    $0x430,%esp
  int fd, i, j; 
  int r;
  int total;
  char *path = (argc > 1) ? argv[1] : "hugefile";
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 08                	jle    1a <main+0x1a>
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
  15:	8b 40 04             	mov    0x4(%eax),%eax
  18:	eb 05                	jmp    1f <main+0x1f>
  1a:	b8 fe 0c 00 00       	mov    $0xcfe,%eax
  1f:	89 84 24 20 04 00 00 	mov    %eax,0x420(%esp)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  26:	c7 44 24 04 07 0d 00 	movl   $0xd07,0x4(%esp)
  2d:	00 
  2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  35:	e8 f8 08 00 00       	call   932 <printf>
  const int sz = sizeof(data);
  3a:	c7 84 24 1c 04 00 00 	movl   $0x200,0x41c(%esp)
  41:	00 02 00 00 
  for (i = 0; i < sz; i++) {
  45:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
  4c:	00 00 00 00 
  50:	eb 2c                	jmp    7e <main+0x7e>
      data[i] = i % 128;
  52:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  59:	99                   	cltd   
  5a:	c1 ea 19             	shr    $0x19,%edx
  5d:	01 d0                	add    %edx,%eax
  5f:	83 e0 7f             	and    $0x7f,%eax
  62:	29 d0                	sub    %edx,%eax
  64:	8d 8c 24 14 02 00 00 	lea    0x214(%esp),%ecx
  6b:	8b 94 24 2c 04 00 00 	mov    0x42c(%esp),%edx
  72:	01 ca                	add    %ecx,%edx
  74:	88 02                	mov    %al,(%edx)
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
  76:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
  7d:	01 
  7e:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  85:	3b 84 24 1c 04 00 00 	cmp    0x41c(%esp),%eax
  8c:	7c c4                	jl     52 <main+0x52>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  8e:	c7 44 24 04 1e 0d 00 	movl   $0xd1e,0x4(%esp)
  95:	00 
  96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9d:	e8 90 08 00 00       	call   932 <printf>
  fd = open(path, O_CREATE | O_RDWR);
  a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  a9:	00 
  aa:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
  b1:	89 04 24             	mov    %eax,(%esp)
  b4:	e8 f9 06 00 00       	call   7b2 <open>
  b9:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
  for(i = 0; i < 1024; i++){
  c0:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
  c7:	00 00 00 00 
  cb:	e9 ab 00 00 00       	jmp    17b <main+0x17b>
    if (i % 100 == 0){
  d0:	8b 8c 24 2c 04 00 00 	mov    0x42c(%esp),%ecx
  d7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  dc:	89 c8                	mov    %ecx,%eax
  de:	f7 ea                	imul   %edx
  e0:	c1 fa 05             	sar    $0x5,%edx
  e3:	89 c8                	mov    %ecx,%eax
  e5:	c1 f8 1f             	sar    $0x1f,%eax
  e8:	29 c2                	sub    %eax,%edx
  ea:	89 d0                	mov    %edx,%eax
  ec:	6b c0 64             	imul   $0x64,%eax,%eax
  ef:	29 c1                	sub    %eax,%ecx
  f1:	89 c8                	mov    %ecx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	75 22                	jne    119 <main+0x119>
      printf(1, "%d bytes written\n", i * 512);
  f7:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
  fe:	c1 e0 09             	shl    $0x9,%eax
 101:	89 44 24 08          	mov    %eax,0x8(%esp)
 105:	c7 44 24 04 2e 0d 00 	movl   $0xd2e,0x4(%esp)
 10c:	00 
 10d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 114:	e8 19 08 00 00       	call   932 <printf>
    }
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
 119:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 120:	00 
 121:	8d 84 24 14 02 00 00 	lea    0x214(%esp),%eax
 128:	89 44 24 04          	mov    %eax,0x4(%esp)
 12c:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 133:	89 04 24             	mov    %eax,(%esp)
 136:	e8 57 06 00 00       	call   792 <write>
 13b:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 142:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 149:	00 02 00 00 
 14d:	74 24                	je     173 <main+0x173>
      printf(1, "write returned %d : failed\n", r);
 14f:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 156:	89 44 24 08          	mov    %eax,0x8(%esp)
 15a:	c7 44 24 04 40 0d 00 	movl   $0xd40,0x4(%esp)
 161:	00 
 162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 169:	e8 c4 07 00 00       	call   932 <printf>
      exit();
 16e:	e8 ff 05 00 00       	call   772 <exit>
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 1024; i++){
 173:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 17a:	01 
 17b:	81 bc 24 2c 04 00 00 	cmpl   $0x3ff,0x42c(%esp)
 182:	ff 03 00 00 
 186:	0f 8e 44 ff ff ff    	jle    d0 <main+0xd0>
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
      printf(1, "write returned %d : failed\n", r);
      exit();
    }
  }
  printf(1, "%d bytes written\n", 1024 * 512);
 18c:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 193:	00 
 194:	c7 44 24 04 2e 0d 00 	movl   $0xd2e,0x4(%esp)
 19b:	00 
 19c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a3:	e8 8a 07 00 00       	call   932 <printf>
  close(fd);
 1a8:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 1af:	89 04 24             	mov    %eax,(%esp)
 1b2:	e8 e3 05 00 00       	call   79a <close>

  printf(1, "2. read test\n");
 1b7:	c7 44 24 04 5c 0d 00 	movl   $0xd5c,0x4(%esp)
 1be:	00 
 1bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c6:	e8 67 07 00 00       	call   932 <printf>
  fd = open(path, O_RDONLY);
 1cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d2:	00 
 1d3:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 d0 05 00 00       	call   7b2 <open>
 1e2:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
  for (i = 0; i < 1024; i++){
 1e9:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
 1f0:	00 00 00 00 
 1f4:	e9 0d 01 00 00       	jmp    306 <main+0x306>
    if (i % 100 == 0){
 1f9:	8b 8c 24 2c 04 00 00 	mov    0x42c(%esp),%ecx
 200:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 205:	89 c8                	mov    %ecx,%eax
 207:	f7 ea                	imul   %edx
 209:	c1 fa 05             	sar    $0x5,%edx
 20c:	89 c8                	mov    %ecx,%eax
 20e:	c1 f8 1f             	sar    $0x1f,%eax
 211:	29 c2                	sub    %eax,%edx
 213:	89 d0                	mov    %edx,%eax
 215:	6b c0 64             	imul   $0x64,%eax,%eax
 218:	29 c1                	sub    %eax,%ecx
 21a:	89 c8                	mov    %ecx,%eax
 21c:	85 c0                	test   %eax,%eax
 21e:	75 22                	jne    242 <main+0x242>
      printf(1, "%d bytes read\n", i * 512);
 220:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
 227:	c1 e0 09             	shl    $0x9,%eax
 22a:	89 44 24 08          	mov    %eax,0x8(%esp)
 22e:	c7 44 24 04 6a 0d 00 	movl   $0xd6a,0x4(%esp)
 235:	00 
 236:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 23d:	e8 f0 06 00 00       	call   932 <printf>
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
 242:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 249:	00 
 24a:	8d 44 24 14          	lea    0x14(%esp),%eax
 24e:	89 44 24 04          	mov    %eax,0x4(%esp)
 252:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 259:	89 04 24             	mov    %eax,(%esp)
 25c:	e8 29 05 00 00       	call   78a <read>
 261:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 268:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 26f:	00 02 00 00 
 273:	74 24                	je     299 <main+0x299>
      printf(1, "read returned %d : failed\n", r);
 275:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 27c:	89 44 24 08          	mov    %eax,0x8(%esp)
 280:	c7 44 24 04 79 0d 00 	movl   $0xd79,0x4(%esp)
 287:	00 
 288:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 28f:	e8 9e 06 00 00       	call   932 <printf>
      exit();
 294:	e8 d9 04 00 00       	call   772 <exit>
    }
    for (j = 0; j < sz; j++) {
 299:	c7 84 24 28 04 00 00 	movl   $0x0,0x428(%esp)
 2a0:	00 00 00 00 
 2a4:	eb 48                	jmp    2ee <main+0x2ee>
      if (buf[j] != data[j]) {
 2a6:	8d 54 24 14          	lea    0x14(%esp),%edx
 2aa:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2b1:	01 d0                	add    %edx,%eax
 2b3:	0f b6 10             	movzbl (%eax),%edx
 2b6:	8d 8c 24 14 02 00 00 	lea    0x214(%esp),%ecx
 2bd:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2c4:	01 c8                	add    %ecx,%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	38 c2                	cmp    %al,%dl
 2cb:	74 19                	je     2e6 <main+0x2e6>
        printf(1, "data inconsistency detected\n");
 2cd:	c7 44 24 04 94 0d 00 	movl   $0xd94,0x4(%esp)
 2d4:	00 
 2d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2dc:	e8 51 06 00 00       	call   932 <printf>
        exit();
 2e1:	e8 8c 04 00 00       	call   772 <exit>
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
      printf(1, "read returned %d : failed\n", r);
      exit();
    }
    for (j = 0; j < sz; j++) {
 2e6:	83 84 24 28 04 00 00 	addl   $0x1,0x428(%esp)
 2ed:	01 
 2ee:	8b 84 24 28 04 00 00 	mov    0x428(%esp),%eax
 2f5:	3b 84 24 1c 04 00 00 	cmp    0x41c(%esp),%eax
 2fc:	7c a8                	jl     2a6 <main+0x2a6>
  printf(1, "%d bytes written\n", 1024 * 512);
  close(fd);

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < 1024; i++){
 2fe:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 305:	01 
 306:	81 bc 24 2c 04 00 00 	cmpl   $0x3ff,0x42c(%esp)
 30d:	ff 03 00 00 
 311:	0f 8e e2 fe ff ff    	jle    1f9 <main+0x1f9>
        printf(1, "data inconsistency detected\n");
        exit();
      }
    }
  }
  printf(1, "%d bytes read\n", 1024 * 512);
 317:	c7 44 24 08 00 00 08 	movl   $0x80000,0x8(%esp)
 31e:	00 
 31f:	c7 44 24 04 6a 0d 00 	movl   $0xd6a,0x4(%esp)
 326:	00 
 327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32e:	e8 ff 05 00 00       	call   932 <printf>
  close(fd);
 333:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 33a:	89 04 24             	mov    %eax,(%esp)
 33d:	e8 58 04 00 00       	call   79a <close>

  printf(1, "3. stress test\n");
 342:	c7 44 24 04 b1 0d 00 	movl   $0xdb1,0x4(%esp)
 349:	00 
 34a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 351:	e8 dc 05 00 00       	call   932 <printf>
  total = 0;
 356:	c7 84 24 24 04 00 00 	movl   $0x0,0x424(%esp)
 35d:	00 00 00 00 
  for (i = 0; i < 20; i++) {
 361:	c7 84 24 2c 04 00 00 	movl   $0x0,0x42c(%esp)
 368:	00 00 00 00 
 36c:	e9 86 01 00 00       	jmp    4f7 <main+0x4f7>
    printf(1, "stress test...%d \n", i);
 371:	8b 84 24 2c 04 00 00 	mov    0x42c(%esp),%eax
 378:	89 44 24 08          	mov    %eax,0x8(%esp)
 37c:	c7 44 24 04 c1 0d 00 	movl   $0xdc1,0x4(%esp)
 383:	00 
 384:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38b:	e8 a2 05 00 00       	call   932 <printf>
    if(unlink(path) < 0){
 390:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 23 04 00 00       	call   7c2 <unlink>
 39f:	85 c0                	test   %eax,%eax
 3a1:	79 24                	jns    3c7 <main+0x3c7>
      printf(1, "rm: %s failed to delete\n", path);
 3a3:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 3aa:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ae:	c7 44 24 04 d4 0d 00 	movl   $0xdd4,0x4(%esp)
 3b5:	00 
 3b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3bd:	e8 70 05 00 00       	call   932 <printf>
      exit();
 3c2:	e8 ab 03 00 00       	call   772 <exit>
    }
    
    fd = open(path, O_CREATE | O_RDWR);
 3c7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
 3ce:	00 
 3cf:	8b 84 24 20 04 00 00 	mov    0x420(%esp),%eax
 3d6:	89 04 24             	mov    %eax,(%esp)
 3d9:	e8 d4 03 00 00       	call   7b2 <open>
 3de:	89 84 24 18 04 00 00 	mov    %eax,0x418(%esp)
      for(j = 0; j < 1024; j++){
 3e5:	c7 84 24 28 04 00 00 	movl   $0x0,0x428(%esp)
 3ec:	00 00 00 00 
 3f0:	e9 bb 00 00 00       	jmp    4b0 <main+0x4b0>
        if (j % 100 == 0){
 3f5:	8b 8c 24 28 04 00 00 	mov    0x428(%esp),%ecx
 3fc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 401:	89 c8                	mov    %ecx,%eax
 403:	f7 ea                	imul   %edx
 405:	c1 fa 05             	sar    $0x5,%edx
 408:	89 c8                	mov    %ecx,%eax
 40a:	c1 f8 1f             	sar    $0x1f,%eax
 40d:	29 c2                	sub    %eax,%edx
 40f:	89 d0                	mov    %edx,%eax
 411:	6b c0 64             	imul   $0x64,%eax,%eax
 414:	29 c1                	sub    %eax,%ecx
 416:	89 c8                	mov    %ecx,%eax
 418:	85 c0                	test   %eax,%eax
 41a:	75 1f                	jne    43b <main+0x43b>
          printf(1, "%d bytes totally written\n", total);
 41c:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 423:	89 44 24 08          	mov    %eax,0x8(%esp)
 427:	c7 44 24 04 ed 0d 00 	movl   $0xded,0x4(%esp)
 42e:	00 
 42f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 436:	e8 f7 04 00 00       	call   932 <printf>
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
 43b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 442:	00 
 443:	8d 84 24 14 02 00 00 	lea    0x214(%esp),%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 455:	89 04 24             	mov    %eax,(%esp)
 458:	e8 35 03 00 00       	call   792 <write>
 45d:	89 84 24 14 04 00 00 	mov    %eax,0x414(%esp)
 464:	81 bc 24 14 04 00 00 	cmpl   $0x200,0x414(%esp)
 46b:	00 02 00 00 
 46f:	74 24                	je     495 <main+0x495>
          printf(1, "write returned %d : failed\n", r);
 471:	8b 84 24 14 04 00 00 	mov    0x414(%esp),%eax
 478:	89 44 24 08          	mov    %eax,0x8(%esp)
 47c:	c7 44 24 04 40 0d 00 	movl   $0xd40,0x4(%esp)
 483:	00 
 484:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 48b:	e8 a2 04 00 00       	call   932 <printf>
          exit();
 490:	e8 dd 02 00 00       	call   772 <exit>
        }
        total += sizeof(data);
 495:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 49c:	05 00 02 00 00       	add    $0x200,%eax
 4a1:	89 84 24 24 04 00 00 	mov    %eax,0x424(%esp)
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    
    fd = open(path, O_CREATE | O_RDWR);
      for(j = 0; j < 1024; j++){
 4a8:	83 84 24 28 04 00 00 	addl   $0x1,0x428(%esp)
 4af:	01 
 4b0:	81 bc 24 28 04 00 00 	cmpl   $0x3ff,0x428(%esp)
 4b7:	ff 03 00 00 
 4bb:	0f 8e 34 ff ff ff    	jle    3f5 <main+0x3f5>
          printf(1, "write returned %d : failed\n", r);
          exit();
        }
        total += sizeof(data);
      }
      printf(1, "%d bytes written\n", total);
 4c1:	8b 84 24 24 04 00 00 	mov    0x424(%esp),%eax
 4c8:	89 44 24 08          	mov    %eax,0x8(%esp)
 4cc:	c7 44 24 04 2e 0d 00 	movl   $0xd2e,0x4(%esp)
 4d3:	00 
 4d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4db:	e8 52 04 00 00       	call   932 <printf>
    close(fd);
 4e0:	8b 84 24 18 04 00 00 	mov    0x418(%esp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 ab 02 00 00       	call   79a <close>
  printf(1, "%d bytes read\n", 1024 * 512);
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
 4ef:	83 84 24 2c 04 00 00 	addl   $0x1,0x42c(%esp)
 4f6:	01 
 4f7:	83 bc 24 2c 04 00 00 	cmpl   $0x13,0x42c(%esp)
 4fe:	13 
 4ff:	0f 8e 6c fe ff ff    	jle    371 <main+0x371>
      }
      printf(1, "%d bytes written\n", total);
    close(fd);
  }

  exit();
 505:	e8 68 02 00 00       	call   772 <exit>

0000050a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 50a:	55                   	push   %ebp
 50b:	89 e5                	mov    %esp,%ebp
 50d:	57                   	push   %edi
 50e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 50f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 512:	8b 55 10             	mov    0x10(%ebp),%edx
 515:	8b 45 0c             	mov    0xc(%ebp),%eax
 518:	89 cb                	mov    %ecx,%ebx
 51a:	89 df                	mov    %ebx,%edi
 51c:	89 d1                	mov    %edx,%ecx
 51e:	fc                   	cld    
 51f:	f3 aa                	rep stos %al,%es:(%edi)
 521:	89 ca                	mov    %ecx,%edx
 523:	89 fb                	mov    %edi,%ebx
 525:	89 5d 08             	mov    %ebx,0x8(%ebp)
 528:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 52b:	5b                   	pop    %ebx
 52c:	5f                   	pop    %edi
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret    

0000052f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 53b:	90                   	nop
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	8d 50 01             	lea    0x1(%eax),%edx
 542:	89 55 08             	mov    %edx,0x8(%ebp)
 545:	8b 55 0c             	mov    0xc(%ebp),%edx
 548:	8d 4a 01             	lea    0x1(%edx),%ecx
 54b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 54e:	0f b6 12             	movzbl (%edx),%edx
 551:	88 10                	mov    %dl,(%eax)
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	84 c0                	test   %al,%al
 558:	75 e2                	jne    53c <strcpy+0xd>
    ;
  return os;
 55a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55d:	c9                   	leave  
 55e:	c3                   	ret    

0000055f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 55f:	55                   	push   %ebp
 560:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 562:	eb 08                	jmp    56c <strcmp+0xd>
    p++, q++;
 564:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 568:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	84 c0                	test   %al,%al
 574:	74 10                	je     586 <strcmp+0x27>
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	0f b6 10             	movzbl (%eax),%edx
 57c:	8b 45 0c             	mov    0xc(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	38 c2                	cmp    %al,%dl
 584:	74 de                	je     564 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	0f b6 00             	movzbl (%eax),%eax
 58c:	0f b6 d0             	movzbl %al,%edx
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	0f b6 c0             	movzbl %al,%eax
 598:	29 c2                	sub    %eax,%edx
 59a:	89 d0                	mov    %edx,%eax
}
 59c:	5d                   	pop    %ebp
 59d:	c3                   	ret    

0000059e <strlen>:

uint
strlen(char *s)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 5a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5ab:	eb 04                	jmp    5b1 <strlen+0x13>
 5ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 5b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	01 d0                	add    %edx,%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	84 c0                	test   %al,%al
 5be:	75 ed                	jne    5ad <strlen+0xf>
    ;
  return n;
 5c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5c3:	c9                   	leave  
 5c4:	c3                   	ret    

000005c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5c5:	55                   	push   %ebp
 5c6:	89 e5                	mov    %esp,%ebp
 5c8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 5cb:	8b 45 10             	mov    0x10(%ebp),%eax
 5ce:	89 44 24 08          	mov    %eax,0x8(%esp)
 5d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	89 04 24             	mov    %eax,(%esp)
 5df:	e8 26 ff ff ff       	call   50a <stosb>
  return dst;
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    

000005e9 <strchr>:

char*
strchr(const char *s, char c)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 04             	sub    $0x4,%esp
 5ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 5f5:	eb 14                	jmp    60b <strchr+0x22>
    if(*s == c)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 600:	75 05                	jne    607 <strchr+0x1e>
      return (char*)s;
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	eb 13                	jmp    61a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 607:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	75 e2                	jne    5f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 615:	b8 00 00 00 00       	mov    $0x0,%eax
}
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <gets>:

char*
gets(char *buf, int max)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 629:	eb 4c                	jmp    677 <gets+0x5b>
    cc = read(0, &c, 1);
 62b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 632:	00 
 633:	8d 45 ef             	lea    -0x11(%ebp),%eax
 636:	89 44 24 04          	mov    %eax,0x4(%esp)
 63a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 641:	e8 44 01 00 00       	call   78a <read>
 646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 649:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64d:	7f 02                	jg     651 <gets+0x35>
      break;
 64f:	eb 31                	jmp    682 <gets+0x66>
    buf[i++] = c;
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65a:	89 c2                	mov    %eax,%edx
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 665:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 667:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 66b:	3c 0a                	cmp    $0xa,%al
 66d:	74 13                	je     682 <gets+0x66>
 66f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 673:	3c 0d                	cmp    $0xd,%al
 675:	74 0b                	je     682 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	83 c0 01             	add    $0x1,%eax
 67d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 680:	7c a9                	jl     62b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 682:	8b 55 f4             	mov    -0xc(%ebp),%edx
 685:	8b 45 08             	mov    0x8(%ebp),%eax
 688:	01 d0                	add    %edx,%eax
 68a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <stat>:

int
stat(char *n, struct stat *st)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 698:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 69f:	00 
 6a0:	8b 45 08             	mov    0x8(%ebp),%eax
 6a3:	89 04 24             	mov    %eax,(%esp)
 6a6:	e8 07 01 00 00       	call   7b2 <open>
 6ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b2:	79 07                	jns    6bb <stat+0x29>
    return -1;
 6b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6b9:	eb 23                	jmp    6de <stat+0x4c>
  r = fstat(fd, st);
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	89 04 24             	mov    %eax,(%esp)
 6c8:	e8 fd 00 00 00       	call   7ca <fstat>
 6cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	89 04 24             	mov    %eax,(%esp)
 6d6:	e8 bf 00 00 00       	call   79a <close>
  return r;
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6de:	c9                   	leave  
 6df:	c3                   	ret    

000006e0 <atoi>:

int
atoi(const char *s)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6ed:	eb 25                	jmp    714 <atoi+0x34>
    n = n*10 + *s++ - '0';
 6ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6f2:	89 d0                	mov    %edx,%eax
 6f4:	c1 e0 02             	shl    $0x2,%eax
 6f7:	01 d0                	add    %edx,%eax
 6f9:	01 c0                	add    %eax,%eax
 6fb:	89 c1                	mov    %eax,%ecx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	8d 50 01             	lea    0x1(%eax),%edx
 703:	89 55 08             	mov    %edx,0x8(%ebp)
 706:	0f b6 00             	movzbl (%eax),%eax
 709:	0f be c0             	movsbl %al,%eax
 70c:	01 c8                	add    %ecx,%eax
 70e:	83 e8 30             	sub    $0x30,%eax
 711:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	0f b6 00             	movzbl (%eax),%eax
 71a:	3c 2f                	cmp    $0x2f,%al
 71c:	7e 0a                	jle    728 <atoi+0x48>
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	0f b6 00             	movzbl (%eax),%eax
 724:	3c 39                	cmp    $0x39,%al
 726:	7e c7                	jle    6ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 733:	8b 45 08             	mov    0x8(%ebp),%eax
 736:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 739:	8b 45 0c             	mov    0xc(%ebp),%eax
 73c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 73f:	eb 17                	jmp    758 <memmove+0x2b>
    *dst++ = *src++;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8d 50 01             	lea    0x1(%eax),%edx
 747:	89 55 fc             	mov    %edx,-0x4(%ebp)
 74a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 74d:	8d 4a 01             	lea    0x1(%edx),%ecx
 750:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 753:	0f b6 12             	movzbl (%edx),%edx
 756:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 758:	8b 45 10             	mov    0x10(%ebp),%eax
 75b:	8d 50 ff             	lea    -0x1(%eax),%edx
 75e:	89 55 10             	mov    %edx,0x10(%ebp)
 761:	85 c0                	test   %eax,%eax
 763:	7f dc                	jg     741 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 765:	8b 45 08             	mov    0x8(%ebp),%eax
}
 768:	c9                   	leave  
 769:	c3                   	ret    

0000076a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 76a:	b8 01 00 00 00       	mov    $0x1,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <exit>:
SYSCALL(exit)
 772:	b8 02 00 00 00       	mov    $0x2,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <wait>:
SYSCALL(wait)
 77a:	b8 03 00 00 00       	mov    $0x3,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <pipe>:
SYSCALL(pipe)
 782:	b8 04 00 00 00       	mov    $0x4,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <read>:
SYSCALL(read)
 78a:	b8 05 00 00 00       	mov    $0x5,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <write>:
SYSCALL(write)
 792:	b8 10 00 00 00       	mov    $0x10,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <close>:
SYSCALL(close)
 79a:	b8 15 00 00 00       	mov    $0x15,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <kill>:
SYSCALL(kill)
 7a2:	b8 06 00 00 00       	mov    $0x6,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <exec>:
SYSCALL(exec)
 7aa:	b8 07 00 00 00       	mov    $0x7,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <open>:
SYSCALL(open)
 7b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <mknod>:
SYSCALL(mknod)
 7ba:	b8 11 00 00 00       	mov    $0x11,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <unlink>:
SYSCALL(unlink)
 7c2:	b8 12 00 00 00       	mov    $0x12,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <fstat>:
SYSCALL(fstat)
 7ca:	b8 08 00 00 00       	mov    $0x8,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <link>:
SYSCALL(link)
 7d2:	b8 13 00 00 00       	mov    $0x13,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <mkdir>:
SYSCALL(mkdir)
 7da:	b8 14 00 00 00       	mov    $0x14,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <chdir>:
SYSCALL(chdir)
 7e2:	b8 09 00 00 00       	mov    $0x9,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <dup>:
SYSCALL(dup)
 7ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <getpid>:
SYSCALL(getpid)
 7f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <getppid>:
SYSCALL(getppid)
 7fa:	b8 17 00 00 00       	mov    $0x17,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <sbrk>:
SYSCALL(sbrk)
 802:	b8 0c 00 00 00       	mov    $0xc,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <sleep>:
SYSCALL(sleep)
 80a:	b8 0d 00 00 00       	mov    $0xd,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <uptime>:
SYSCALL(uptime)
 812:	b8 0e 00 00 00       	mov    $0xe,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <my_syscall>:
SYSCALL(my_syscall)
 81a:	b8 16 00 00 00       	mov    $0x16,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <yield>:
SYSCALL(yield)
 822:	b8 18 00 00 00       	mov    $0x18,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <getlev>:
SYSCALL(getlev)
 82a:	b8 19 00 00 00       	mov    $0x19,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <set_cpu_share>:
SYSCALL(set_cpu_share)
 832:	b8 1a 00 00 00       	mov    $0x1a,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <thread_create>:
SYSCALL(thread_create)
 83a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <thread_exit>:
SYSCALL(thread_exit)
 842:	b8 1c 00 00 00       	mov    $0x1c,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <thread_join>:
SYSCALL(thread_join)
 84a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 852:	55                   	push   %ebp
 853:	89 e5                	mov    %esp,%ebp
 855:	83 ec 18             	sub    $0x18,%esp
 858:	8b 45 0c             	mov    0xc(%ebp),%eax
 85b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 85e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 865:	00 
 866:	8d 45 f4             	lea    -0xc(%ebp),%eax
 869:	89 44 24 04          	mov    %eax,0x4(%esp)
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	89 04 24             	mov    %eax,(%esp)
 873:	e8 1a ff ff ff       	call   792 <write>
}
 878:	c9                   	leave  
 879:	c3                   	ret    

0000087a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 87a:	55                   	push   %ebp
 87b:	89 e5                	mov    %esp,%ebp
 87d:	56                   	push   %esi
 87e:	53                   	push   %ebx
 87f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 882:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 889:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 88d:	74 17                	je     8a6 <printint+0x2c>
 88f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 893:	79 11                	jns    8a6 <printint+0x2c>
    neg = 1;
 895:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 89c:	8b 45 0c             	mov    0xc(%ebp),%eax
 89f:	f7 d8                	neg    %eax
 8a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8a4:	eb 06                	jmp    8ac <printint+0x32>
  } else {
    x = xx;
 8a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8b6:	8d 41 01             	lea    0x1(%ecx),%eax
 8b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c2:	ba 00 00 00 00       	mov    $0x0,%edx
 8c7:	f7 f3                	div    %ebx
 8c9:	89 d0                	mov    %edx,%eax
 8cb:	0f b6 80 54 10 00 00 	movzbl 0x1054(%eax),%eax
 8d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 8d6:	8b 75 10             	mov    0x10(%ebp),%esi
 8d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8dc:	ba 00 00 00 00       	mov    $0x0,%edx
 8e1:	f7 f6                	div    %esi
 8e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8ea:	75 c7                	jne    8b3 <printint+0x39>
  if(neg)
 8ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f0:	74 10                	je     902 <printint+0x88>
    buf[i++] = '-';
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8d 50 01             	lea    0x1(%eax),%edx
 8f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 900:	eb 1f                	jmp    921 <printint+0xa7>
 902:	eb 1d                	jmp    921 <printint+0xa7>
    putc(fd, buf[i]);
 904:	8d 55 dc             	lea    -0x24(%ebp),%edx
 907:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90a:	01 d0                	add    %edx,%eax
 90c:	0f b6 00             	movzbl (%eax),%eax
 90f:	0f be c0             	movsbl %al,%eax
 912:	89 44 24 04          	mov    %eax,0x4(%esp)
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	89 04 24             	mov    %eax,(%esp)
 91c:	e8 31 ff ff ff       	call   852 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 921:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 929:	79 d9                	jns    904 <printint+0x8a>
    putc(fd, buf[i]);
}
 92b:	83 c4 30             	add    $0x30,%esp
 92e:	5b                   	pop    %ebx
 92f:	5e                   	pop    %esi
 930:	5d                   	pop    %ebp
 931:	c3                   	ret    

00000932 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 932:	55                   	push   %ebp
 933:	89 e5                	mov    %esp,%ebp
 935:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 938:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 93f:	8d 45 0c             	lea    0xc(%ebp),%eax
 942:	83 c0 04             	add    $0x4,%eax
 945:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 94f:	e9 7c 01 00 00       	jmp    ad0 <printf+0x19e>
    c = fmt[i] & 0xff;
 954:	8b 55 0c             	mov    0xc(%ebp),%edx
 957:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95a:	01 d0                	add    %edx,%eax
 95c:	0f b6 00             	movzbl (%eax),%eax
 95f:	0f be c0             	movsbl %al,%eax
 962:	25 ff 00 00 00       	and    $0xff,%eax
 967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 96a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 96e:	75 2c                	jne    99c <printf+0x6a>
      if(c == '%'){
 970:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 974:	75 0c                	jne    982 <printf+0x50>
        state = '%';
 976:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 97d:	e9 4a 01 00 00       	jmp    acc <printf+0x19a>
      } else {
        putc(fd, c);
 982:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 985:	0f be c0             	movsbl %al,%eax
 988:	89 44 24 04          	mov    %eax,0x4(%esp)
 98c:	8b 45 08             	mov    0x8(%ebp),%eax
 98f:	89 04 24             	mov    %eax,(%esp)
 992:	e8 bb fe ff ff       	call   852 <putc>
 997:	e9 30 01 00 00       	jmp    acc <printf+0x19a>
      }
    } else if(state == '%'){
 99c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9a0:	0f 85 26 01 00 00    	jne    acc <printf+0x19a>
      if(c == 'd'){
 9a6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9aa:	75 2d                	jne    9d9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 9ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9af:	8b 00                	mov    (%eax),%eax
 9b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 9b8:	00 
 9b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 9c0:	00 
 9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c5:	8b 45 08             	mov    0x8(%ebp),%eax
 9c8:	89 04 24             	mov    %eax,(%esp)
 9cb:	e8 aa fe ff ff       	call   87a <printint>
        ap++;
 9d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9d4:	e9 ec 00 00 00       	jmp    ac5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 9d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9dd:	74 06                	je     9e5 <printf+0xb3>
 9df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9e3:	75 2d                	jne    a12 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 9e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e8:	8b 00                	mov    (%eax),%eax
 9ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 9f1:	00 
 9f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 9f9:	00 
 9fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 9fe:	8b 45 08             	mov    0x8(%ebp),%eax
 a01:	89 04 24             	mov    %eax,(%esp)
 a04:	e8 71 fe ff ff       	call   87a <printint>
        ap++;
 a09:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a0d:	e9 b3 00 00 00       	jmp    ac5 <printf+0x193>
      } else if(c == 's'){
 a12:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a16:	75 45                	jne    a5d <printf+0x12b>
        s = (char*)*ap;
 a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1b:	8b 00                	mov    (%eax),%eax
 a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a20:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a28:	75 09                	jne    a33 <printf+0x101>
          s = "(null)";
 a2a:	c7 45 f4 07 0e 00 00 	movl   $0xe07,-0xc(%ebp)
        while(*s != 0){
 a31:	eb 1e                	jmp    a51 <printf+0x11f>
 a33:	eb 1c                	jmp    a51 <printf+0x11f>
          putc(fd, *s);
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	0f b6 00             	movzbl (%eax),%eax
 a3b:	0f be c0             	movsbl %al,%eax
 a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a42:	8b 45 08             	mov    0x8(%ebp),%eax
 a45:	89 04 24             	mov    %eax,(%esp)
 a48:	e8 05 fe ff ff       	call   852 <putc>
          s++;
 a4d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a54:	0f b6 00             	movzbl (%eax),%eax
 a57:	84 c0                	test   %al,%al
 a59:	75 da                	jne    a35 <printf+0x103>
 a5b:	eb 68                	jmp    ac5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a5d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a61:	75 1d                	jne    a80 <printf+0x14e>
        putc(fd, *ap);
 a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a66:	8b 00                	mov    (%eax),%eax
 a68:	0f be c0             	movsbl %al,%eax
 a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a6f:	8b 45 08             	mov    0x8(%ebp),%eax
 a72:	89 04 24             	mov    %eax,(%esp)
 a75:	e8 d8 fd ff ff       	call   852 <putc>
        ap++;
 a7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a7e:	eb 45                	jmp    ac5 <printf+0x193>
      } else if(c == '%'){
 a80:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a84:	75 17                	jne    a9d <printf+0x16b>
        putc(fd, c);
 a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a89:	0f be c0             	movsbl %al,%eax
 a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a90:	8b 45 08             	mov    0x8(%ebp),%eax
 a93:	89 04 24             	mov    %eax,(%esp)
 a96:	e8 b7 fd ff ff       	call   852 <putc>
 a9b:	eb 28                	jmp    ac5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a9d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 aa4:	00 
 aa5:	8b 45 08             	mov    0x8(%ebp),%eax
 aa8:	89 04 24             	mov    %eax,(%esp)
 aab:	e8 a2 fd ff ff       	call   852 <putc>
        putc(fd, c);
 ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ab3:	0f be c0             	movsbl %al,%eax
 ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
 aba:	8b 45 08             	mov    0x8(%ebp),%eax
 abd:	89 04 24             	mov    %eax,(%esp)
 ac0:	e8 8d fd ff ff       	call   852 <putc>
      }
      state = 0;
 ac5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 acc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
 ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad6:	01 d0                	add    %edx,%eax
 ad8:	0f b6 00             	movzbl (%eax),%eax
 adb:	84 c0                	test   %al,%al
 add:	0f 85 71 fe ff ff    	jne    954 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ae3:	c9                   	leave  
 ae4:	c3                   	ret    

00000ae5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ae5:	55                   	push   %ebp
 ae6:	89 e5                	mov    %esp,%ebp
 ae8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	83 e8 08             	sub    $0x8,%eax
 af1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 af4:	a1 70 10 00 00       	mov    0x1070,%eax
 af9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 afc:	eb 24                	jmp    b22 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b01:	8b 00                	mov    (%eax),%eax
 b03:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b06:	77 12                	ja     b1a <free+0x35>
 b08:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b0e:	77 24                	ja     b34 <free+0x4f>
 b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b13:	8b 00                	mov    (%eax),%eax
 b15:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b18:	77 1a                	ja     b34 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1d:	8b 00                	mov    (%eax),%eax
 b1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b22:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b25:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b28:	76 d4                	jbe    afe <free+0x19>
 b2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2d:	8b 00                	mov    (%eax),%eax
 b2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b32:	76 ca                	jbe    afe <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b37:	8b 40 04             	mov    0x4(%eax),%eax
 b3a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b41:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b44:	01 c2                	add    %eax,%edx
 b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b49:	8b 00                	mov    (%eax),%eax
 b4b:	39 c2                	cmp    %eax,%edx
 b4d:	75 24                	jne    b73 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b52:	8b 50 04             	mov    0x4(%eax),%edx
 b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b58:	8b 00                	mov    (%eax),%eax
 b5a:	8b 40 04             	mov    0x4(%eax),%eax
 b5d:	01 c2                	add    %eax,%edx
 b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b62:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b68:	8b 00                	mov    (%eax),%eax
 b6a:	8b 10                	mov    (%eax),%edx
 b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b6f:	89 10                	mov    %edx,(%eax)
 b71:	eb 0a                	jmp    b7d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b76:	8b 10                	mov    (%eax),%edx
 b78:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b7b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b80:	8b 40 04             	mov    0x4(%eax),%eax
 b83:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8d:	01 d0                	add    %edx,%eax
 b8f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b92:	75 20                	jne    bb4 <free+0xcf>
    p->s.size += bp->s.size;
 b94:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b97:	8b 50 04             	mov    0x4(%eax),%edx
 b9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9d:	8b 40 04             	mov    0x4(%eax),%eax
 ba0:	01 c2                	add    %eax,%edx
 ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ba8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bab:	8b 10                	mov    (%eax),%edx
 bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb0:	89 10                	mov    %edx,(%eax)
 bb2:	eb 08                	jmp    bbc <free+0xd7>
  } else
    p->s.ptr = bp;
 bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 bba:	89 10                	mov    %edx,(%eax)
  freep = p;
 bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bbf:	a3 70 10 00 00       	mov    %eax,0x1070
}
 bc4:	c9                   	leave  
 bc5:	c3                   	ret    

00000bc6 <morecore>:

static Header*
morecore(uint nu)
{
 bc6:	55                   	push   %ebp
 bc7:	89 e5                	mov    %esp,%ebp
 bc9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bcc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 bd3:	77 07                	ja     bdc <morecore+0x16>
    nu = 4096;
 bd5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 bdc:	8b 45 08             	mov    0x8(%ebp),%eax
 bdf:	c1 e0 03             	shl    $0x3,%eax
 be2:	89 04 24             	mov    %eax,(%esp)
 be5:	e8 18 fc ff ff       	call   802 <sbrk>
 bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 bed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 bf1:	75 07                	jne    bfa <morecore+0x34>
    return 0;
 bf3:	b8 00 00 00 00       	mov    $0x0,%eax
 bf8:	eb 22                	jmp    c1c <morecore+0x56>
  hp = (Header*)p;
 bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c03:	8b 55 08             	mov    0x8(%ebp),%edx
 c06:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0c:	83 c0 08             	add    $0x8,%eax
 c0f:	89 04 24             	mov    %eax,(%esp)
 c12:	e8 ce fe ff ff       	call   ae5 <free>
  return freep;
 c17:	a1 70 10 00 00       	mov    0x1070,%eax
}
 c1c:	c9                   	leave  
 c1d:	c3                   	ret    

00000c1e <malloc>:

void*
malloc(uint nbytes)
{
 c1e:	55                   	push   %ebp
 c1f:	89 e5                	mov    %esp,%ebp
 c21:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c24:	8b 45 08             	mov    0x8(%ebp),%eax
 c27:	83 c0 07             	add    $0x7,%eax
 c2a:	c1 e8 03             	shr    $0x3,%eax
 c2d:	83 c0 01             	add    $0x1,%eax
 c30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c33:	a1 70 10 00 00       	mov    0x1070,%eax
 c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c3f:	75 23                	jne    c64 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c41:	c7 45 f0 68 10 00 00 	movl   $0x1068,-0x10(%ebp)
 c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c4b:	a3 70 10 00 00       	mov    %eax,0x1070
 c50:	a1 70 10 00 00       	mov    0x1070,%eax
 c55:	a3 68 10 00 00       	mov    %eax,0x1068
    base.s.size = 0;
 c5a:	c7 05 6c 10 00 00 00 	movl   $0x0,0x106c
 c61:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c67:	8b 00                	mov    (%eax),%eax
 c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6f:	8b 40 04             	mov    0x4(%eax),%eax
 c72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c75:	72 4d                	jb     cc4 <malloc+0xa6>
      if(p->s.size == nunits)
 c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7a:	8b 40 04             	mov    0x4(%eax),%eax
 c7d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c80:	75 0c                	jne    c8e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c85:	8b 10                	mov    (%eax),%edx
 c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c8a:	89 10                	mov    %edx,(%eax)
 c8c:	eb 26                	jmp    cb4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c91:	8b 40 04             	mov    0x4(%eax),%eax
 c94:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c97:	89 c2                	mov    %eax,%edx
 c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca2:	8b 40 04             	mov    0x4(%eax),%eax
 ca5:	c1 e0 03             	shl    $0x3,%eax
 ca8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cae:	8b 55 ec             	mov    -0x14(%ebp),%edx
 cb1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb7:	a3 70 10 00 00       	mov    %eax,0x1070
      return (void*)(p + 1);
 cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbf:	83 c0 08             	add    $0x8,%eax
 cc2:	eb 38                	jmp    cfc <malloc+0xde>
    }
    if(p == freep)
 cc4:	a1 70 10 00 00       	mov    0x1070,%eax
 cc9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ccc:	75 1b                	jne    ce9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 cd1:	89 04 24             	mov    %eax,(%esp)
 cd4:	e8 ed fe ff ff       	call   bc6 <morecore>
 cd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ce0:	75 07                	jne    ce9 <malloc+0xcb>
        return 0;
 ce2:	b8 00 00 00 00       	mov    $0x0,%eax
 ce7:	eb 13                	jmp    cfc <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf2:	8b 00                	mov    (%eax),%eax
 cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 cf7:	e9 70 ff ff ff       	jmp    c6c <malloc+0x4e>
}
 cfc:	c9                   	leave  
 cfd:	c3                   	ret    
