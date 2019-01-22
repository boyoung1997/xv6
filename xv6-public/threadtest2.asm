
_threadtest2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stridetest2",
};

int
main(int argc, char *argv[])
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 30             	sub    $0x30,%esp
  int i;
  int ret;
  int pid;
  int start = 0;
       9:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
      10:	00 
  int end = NTEST-1;
      11:	c7 44 24 24 0e 00 00 	movl   $0xe,0x24(%esp)
      18:	00 
  if (argc >= 2)
      19:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
      1d:	7e 14                	jle    33 <main+0x33>
    start = atoi(argv[1]);
      1f:	8b 45 0c             	mov    0xc(%ebp),%eax
      22:	83 c0 04             	add    $0x4,%eax
      25:	8b 00                	mov    (%eax),%eax
      27:	89 04 24             	mov    %eax,(%esp)
      2a:	e8 7d 15 00 00       	call   15ac <atoi>
      2f:	89 44 24 28          	mov    %eax,0x28(%esp)
  if (argc >= 3)
      33:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
      37:	7e 14                	jle    4d <main+0x4d>
    end = atoi(argv[2]);
      39:	8b 45 0c             	mov    0xc(%ebp),%eax
      3c:	83 c0 08             	add    $0x8,%eax
      3f:	8b 00                	mov    (%eax),%eax
      41:	89 04 24             	mov    %eax,(%esp)
      44:	e8 63 15 00 00       	call   15ac <atoi>
      49:	89 44 24 24          	mov    %eax,0x24(%esp)

  for (i = start; i <= end; i++){
      4d:	8b 44 24 28          	mov    0x28(%esp),%eax
      51:	89 44 24 2c          	mov    %eax,0x2c(%esp)
      55:	e9 93 01 00 00       	jmp    1ed <main+0x1ed>
    printf(1,"%d. %s start\n", i, testname[i]);
      5a:	8b 44 24 2c          	mov    0x2c(%esp),%eax
      5e:	8b 04 85 40 24 00 00 	mov    0x2440(,%eax,4),%eax
      65:	89 44 24 0c          	mov    %eax,0xc(%esp)
      69:	8b 44 24 2c          	mov    0x2c(%esp),%eax
      6d:	89 44 24 08          	mov    %eax,0x8(%esp)
      71:	c7 44 24 04 63 1c 00 	movl   $0x1c63,0x4(%esp)
      78:	00 
      79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      80:	e8 79 17 00 00       	call   17fe <printf>
    if (pipe(gpipe) < 0){
      85:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
      8c:	e8 bd 15 00 00       	call   164e <pipe>
      91:	85 c0                	test   %eax,%eax
      93:	79 19                	jns    ae <main+0xae>
      printf(1,"pipe panic\n");
      95:	c7 44 24 04 71 1c 00 	movl   $0x1c71,0x4(%esp)
      9c:	00 
      9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      a4:	e8 55 17 00 00       	call   17fe <printf>
      exit();
      a9:	e8 90 15 00 00       	call   163e <exit>
    }
    ret = 0;
      ae:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
      b5:	00 

    if ((pid = fork()) < 0){
      b6:	e8 7b 15 00 00       	call   1636 <fork>
      bb:	89 44 24 20          	mov    %eax,0x20(%esp)
      bf:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
      c4:	79 19                	jns    df <main+0xdf>
      printf(1,"fork panic\n");
      c6:	c7 44 24 04 7d 1c 00 	movl   $0x1c7d,0x4(%esp)
      cd:	00 
      ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      d5:	e8 24 17 00 00       	call   17fe <printf>
      exit();
      da:	e8 5f 15 00 00       	call   163e <exit>
    }
    if (pid == 0){
      df:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
      e4:	75 4d                	jne    133 <main+0x133>
      close(gpipe[0]);
      e6:	a1 a0 24 00 00       	mov    0x24a0,%eax
      eb:	89 04 24             	mov    %eax,(%esp)
      ee:	e8 73 15 00 00       	call   1666 <close>
      ret = testfunc[i]();
      f3:	8b 44 24 2c          	mov    0x2c(%esp),%eax
      f7:	8b 04 85 00 24 00 00 	mov    0x2400(,%eax,4),%eax
      fe:	ff d0                	call   *%eax
     100:	89 44 24 1c          	mov    %eax,0x1c(%esp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
     104:	a1 a4 24 00 00       	mov    0x24a4,%eax
     109:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
     110:	00 
     111:	8d 54 24 1c          	lea    0x1c(%esp),%edx
     115:	89 54 24 04          	mov    %edx,0x4(%esp)
     119:	89 04 24             	mov    %eax,(%esp)
     11c:	e8 3d 15 00 00       	call   165e <write>
      close(gpipe[1]);
     121:	a1 a4 24 00 00       	mov    0x24a4,%eax
     126:	89 04 24             	mov    %eax,(%esp)
     129:	e8 38 15 00 00       	call   1666 <close>
      exit();
     12e:	e8 0b 15 00 00       	call   163e <exit>
    } else{
      close(gpipe[1]);
     133:	a1 a4 24 00 00       	mov    0x24a4,%eax
     138:	89 04 24             	mov    %eax,(%esp)
     13b:	e8 26 15 00 00       	call   1666 <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
     140:	e8 01 15 00 00       	call   1646 <wait>
     145:	83 f8 ff             	cmp    $0xffffffff,%eax
     148:	74 2a                	je     174 <main+0x174>
     14a:	a1 a0 24 00 00       	mov    0x24a0,%eax
     14f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
     156:	00 
     157:	8d 54 24 1c          	lea    0x1c(%esp),%edx
     15b:	89 54 24 04          	mov    %edx,0x4(%esp)
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 ef 14 00 00       	call   1656 <read>
     167:	83 f8 ff             	cmp    $0xffffffff,%eax
     16a:	74 08                	je     174 <main+0x174>
     16c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     170:	85 c0                	test   %eax,%eax
     172:	74 30                	je     1a4 <main+0x1a4>
        printf(1,"%d. %s panic\n", i, testname[i]);
     174:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     178:	8b 04 85 40 24 00 00 	mov    0x2440(,%eax,4),%eax
     17f:	89 44 24 0c          	mov    %eax,0xc(%esp)
     183:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     187:	89 44 24 08          	mov    %eax,0x8(%esp)
     18b:	c7 44 24 04 89 1c 00 	movl   $0x1c89,0x4(%esp)
     192:	00 
     193:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     19a:	e8 5f 16 00 00       	call   17fe <printf>
        exit();
     19f:	e8 9a 14 00 00       	call   163e <exit>
      }
      close(gpipe[0]);
     1a4:	a1 a0 24 00 00       	mov    0x24a0,%eax
     1a9:	89 04 24             	mov    %eax,(%esp)
     1ac:	e8 b5 14 00 00       	call   1666 <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
     1b1:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     1b5:	8b 04 85 40 24 00 00 	mov    0x2440(,%eax,4),%eax
     1bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
     1c0:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     1c4:	89 44 24 08          	mov    %eax,0x8(%esp)
     1c8:	c7 44 24 04 97 1c 00 	movl   $0x1c97,0x4(%esp)
     1cf:	00 
     1d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1d7:	e8 22 16 00 00       	call   17fe <printf>
    sleep(100);
     1dc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     1e3:	e8 ee 14 00 00       	call   16d6 <sleep>
  if (argc >= 2)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  for (i = start; i <= end; i++){
     1e8:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
     1ed:	8b 44 24 2c          	mov    0x2c(%esp),%eax
     1f1:	3b 44 24 24          	cmp    0x24(%esp),%eax
     1f5:	0f 8e 5f fe ff ff    	jle    5a <main+0x5a>
      close(gpipe[0]);
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
    sleep(100);
  }
  exit();
     1fb:	e8 3e 14 00 00       	call   163e <exit>

00000200 <nop>:
}

// ============================================================================
void nop(){ }
     200:	55                   	push   %ebp
     201:	89 e5                	mov    %esp,%ebp
     203:	5d                   	pop    %ebp
     204:	c3                   	ret    

00000205 <racingthreadmain>:

void*
racingthreadmain(void *arg)
{
     205:	55                   	push   %ebp
     206:	89 e5                	mov    %esp,%ebp
     208:	83 ec 28             	sub    $0x28,%esp
  int tid = (int) arg;
     20b:	8b 45 08             	mov    0x8(%ebp),%eax
     20e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  int tmp;
  for (i = 0; i < 10000000; i++){
     211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     218:	eb 1d                	jmp    237 <racingthreadmain+0x32>
    tmp = gcnt;
     21a:	a1 9c 24 00 00       	mov    0x249c,%eax
     21f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    tmp++;
     222:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    nop();
     226:	e8 d5 ff ff ff       	call   200 <nop>
    gcnt = tmp;
     22b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     22e:	a3 9c 24 00 00       	mov    %eax,0x249c
racingthreadmain(void *arg)
{
  int tid = (int) arg;
  int i;
  int tmp;
  for (i = 0; i < 10000000; i++){
     233:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     237:	81 7d f4 7f 96 98 00 	cmpl   $0x98967f,-0xc(%ebp)
     23e:	7e da                	jle    21a <racingthreadmain+0x15>
    tmp = gcnt;
    tmp++;
    nop();
    gcnt = tmp;
  }
  thread_exit((void *)(tid+1));
     240:	8b 45 f0             	mov    -0x10(%ebp),%eax
     243:	83 c0 01             	add    $0x1,%eax
     246:	89 04 24             	mov    %eax,(%esp)
     249:	e8 c0 14 00 00       	call   170e <thread_exit>

0000024e <racingtest>:
}

int
racingtest(void)
{
     24e:	55                   	push   %ebp
     24f:	89 e5                	mov    %esp,%ebp
     251:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
     254:	c7 05 9c 24 00 00 00 	movl   $0x0,0x249c
     25b:	00 00 00 
  
  for (i = 0; i < NUM_THREAD; i++){
     25e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     265:	eb 48                	jmp    2af <racingtest+0x61>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
     267:	8b 45 f4             	mov    -0xc(%ebp),%eax
     26a:	8d 55 cc             	lea    -0x34(%ebp),%edx
     26d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     270:	c1 e1 02             	shl    $0x2,%ecx
     273:	01 ca                	add    %ecx,%edx
     275:	89 44 24 08          	mov    %eax,0x8(%esp)
     279:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
     280:	00 
     281:	89 14 24             	mov    %edx,(%esp)
     284:	e8 7d 14 00 00       	call   1706 <thread_create>
     289:	85 c0                	test   %eax,%eax
     28b:	74 1e                	je     2ab <racingtest+0x5d>
      printf(1, "panic at thread_create\n");
     28d:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     294:	00 
     295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     29c:	e8 5d 15 00 00       	call   17fe <printf>
      return -1;
     2a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2a6:	e9 81 00 00 00       	jmp    32c <racingtest+0xde>
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
     2ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     2af:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     2b3:	7e b2                	jle    267 <racingtest+0x19>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     2b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     2bc:	eb 46                	jmp    304 <racingtest+0xb6>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     2be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     2c5:	8d 55 c8             	lea    -0x38(%ebp),%edx
     2c8:	89 54 24 04          	mov    %edx,0x4(%esp)
     2cc:	89 04 24             	mov    %eax,(%esp)
     2cf:	e8 42 14 00 00       	call   1716 <thread_join>
     2d4:	85 c0                	test   %eax,%eax
     2d6:	75 0d                	jne    2e5 <racingtest+0x97>
     2d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
     2db:	8b 55 f4             	mov    -0xc(%ebp),%edx
     2de:	83 c2 01             	add    $0x1,%edx
     2e1:	39 d0                	cmp    %edx,%eax
     2e3:	74 1b                	je     300 <racingtest+0xb2>
      printf(1, "panic at thread_join\n");
     2e5:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     2ec:	00 
     2ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2f4:	e8 05 15 00 00       	call   17fe <printf>
      return -1;
     2f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     2fe:	eb 2c                	jmp    32c <racingtest+0xde>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     300:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     304:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     308:	7e b4                	jle    2be <racingtest+0x70>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
     30a:	a1 9c 24 00 00       	mov    0x249c,%eax
     30f:	89 44 24 08          	mov    %eax,0x8(%esp)
     313:	c7 44 24 04 d4 1c 00 	movl   $0x1cd4,0x4(%esp)
     31a:	00 
     31b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     322:	e8 d7 14 00 00       	call   17fe <printf>
  return 0;
     327:	b8 00 00 00 00       	mov    $0x0,%eax
}
     32c:	c9                   	leave  
     32d:	c3                   	ret    

0000032e <basicthreadmain>:

// ============================================================================
void*
basicthreadmain(void *arg)
{
     32e:	55                   	push   %ebp
     32f:	89 e5                	mov    %esp,%ebp
     331:	83 ec 28             	sub    $0x28,%esp
  int tid = (int) arg;
     334:	8b 45 08             	mov    0x8(%ebp),%eax
     337:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  for (i = 0; i < 100000000; i++){
     33a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     341:	eb 45                	jmp    388 <basicthreadmain+0x5a>
    if (i % 20000000 == 0){
     343:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     346:	ba 6b ca 5f 6b       	mov    $0x6b5fca6b,%edx
     34b:	89 c8                	mov    %ecx,%eax
     34d:	f7 ea                	imul   %edx
     34f:	c1 fa 17             	sar    $0x17,%edx
     352:	89 c8                	mov    %ecx,%eax
     354:	c1 f8 1f             	sar    $0x1f,%eax
     357:	29 c2                	sub    %eax,%edx
     359:	89 d0                	mov    %edx,%eax
     35b:	69 c0 00 2d 31 01    	imul   $0x1312d00,%eax,%eax
     361:	29 c1                	sub    %eax,%ecx
     363:	89 c8                	mov    %ecx,%eax
     365:	85 c0                	test   %eax,%eax
     367:	75 1b                	jne    384 <basicthreadmain+0x56>
      printf(1, "%d", tid);
     369:	8b 45 f0             	mov    -0x10(%ebp),%eax
     36c:	89 44 24 08          	mov    %eax,0x8(%esp)
     370:	c7 44 24 04 d8 1c 00 	movl   $0x1cd8,0x4(%esp)
     377:	00 
     378:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     37f:	e8 7a 14 00 00       	call   17fe <printf>
void*
basicthreadmain(void *arg)
{
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
     384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     388:	81 7d f4 ff e0 f5 05 	cmpl   $0x5f5e0ff,-0xc(%ebp)
     38f:	7e b2                	jle    343 <basicthreadmain+0x15>
    if (i % 20000000 == 0){
      printf(1, "%d", tid);
    }
  }
  thread_exit((void *)(tid+1));
     391:	8b 45 f0             	mov    -0x10(%ebp),%eax
     394:	83 c0 01             	add    $0x1,%eax
     397:	89 04 24             	mov    %eax,(%esp)
     39a:	e8 6f 13 00 00       	call   170e <thread_exit>

0000039f <basictest>:
}

int
basictest(void)
{
     39f:	55                   	push   %ebp
     3a0:	89 e5                	mov    %esp,%ebp
     3a2:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
     3a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3ac:	eb 45                	jmp    3f3 <basictest+0x54>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
     3ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3b1:	8d 55 cc             	lea    -0x34(%ebp),%edx
     3b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     3b7:	c1 e1 02             	shl    $0x2,%ecx
     3ba:	01 ca                	add    %ecx,%edx
     3bc:	89 44 24 08          	mov    %eax,0x8(%esp)
     3c0:	c7 44 24 04 2e 03 00 	movl   $0x32e,0x4(%esp)
     3c7:	00 
     3c8:	89 14 24             	mov    %edx,(%esp)
     3cb:	e8 36 13 00 00       	call   1706 <thread_create>
     3d0:	85 c0                	test   %eax,%eax
     3d2:	74 1b                	je     3ef <basictest+0x50>
      printf(1, "panic at thread_create\n");
     3d4:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     3db:	00 
     3dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3e3:	e8 16 14 00 00       	call   17fe <printf>
      return -1;
     3e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     3ed:	eb 78                	jmp    467 <basictest+0xc8>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
     3ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3f3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     3f7:	7e b5                	jle    3ae <basictest+0xf>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     3f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     400:	eb 46                	jmp    448 <basictest+0xa9>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
     402:	8b 45 f4             	mov    -0xc(%ebp),%eax
     405:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     409:	8d 55 c8             	lea    -0x38(%ebp),%edx
     40c:	89 54 24 04          	mov    %edx,0x4(%esp)
     410:	89 04 24             	mov    %eax,(%esp)
     413:	e8 fe 12 00 00       	call   1716 <thread_join>
     418:	85 c0                	test   %eax,%eax
     41a:	75 0d                	jne    429 <basictest+0x8a>
     41c:	8b 45 c8             	mov    -0x38(%ebp),%eax
     41f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     422:	83 c2 01             	add    $0x1,%edx
     425:	39 d0                	cmp    %edx,%eax
     427:	74 1b                	je     444 <basictest+0xa5>
      printf(1, "panic at thread_join\n");
     429:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     430:	00 
     431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     438:	e8 c1 13 00 00       	call   17fe <printf>
      return -1;
     43d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     442:	eb 23                	jmp    467 <basictest+0xc8>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     444:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     448:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     44c:	7e b4                	jle    402 <basictest+0x63>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     44e:	c7 44 24 04 db 1c 00 	movl   $0x1cdb,0x4(%esp)
     455:	00 
     456:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     45d:	e8 9c 13 00 00       	call   17fe <printf>
  return 0;
     462:	b8 00 00 00 00       	mov    $0x0,%eax
}
     467:	c9                   	leave  
     468:	c3                   	ret    

00000469 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
     469:	55                   	push   %ebp
     46a:	89 e5                	mov    %esp,%ebp
     46c:	83 ec 28             	sub    $0x28,%esp
  int val = (int)arg;
     46f:	8b 45 08             	mov    0x8(%ebp),%eax
     472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sleep(200);
     475:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
     47c:	e8 55 12 00 00       	call   16d6 <sleep>
  printf(1, "thread_exit...\n");
     481:	c7 44 24 04 dd 1c 00 	movl   $0x1cdd,0x4(%esp)
     488:	00 
     489:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     490:	e8 69 13 00 00       	call   17fe <printf>
  thread_exit((void *)(val*2));
     495:	8b 45 f4             	mov    -0xc(%ebp),%eax
     498:	01 c0                	add    %eax,%eax
     49a:	89 04 24             	mov    %eax,(%esp)
     49d:	e8 6c 12 00 00       	call   170e <thread_exit>

000004a2 <jointest1>:
}

int
jointest1(void)
{
     4a2:	55                   	push   %ebp
     4a3:	89 e5                	mov    %esp,%ebp
     4a5:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     4a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     4af:	eb 4b                	jmp    4fc <jointest1+0x5a>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
     4b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4b7:	8d 4a ff             	lea    -0x1(%edx),%ecx
     4ba:	8d 55 cc             	lea    -0x34(%ebp),%edx
     4bd:	c1 e1 02             	shl    $0x2,%ecx
     4c0:	01 ca                	add    %ecx,%edx
     4c2:	89 44 24 08          	mov    %eax,0x8(%esp)
     4c6:	c7 44 24 04 69 04 00 	movl   $0x469,0x4(%esp)
     4cd:	00 
     4ce:	89 14 24             	mov    %edx,(%esp)
     4d1:	e8 30 12 00 00       	call   1706 <thread_create>
     4d6:	85 c0                	test   %eax,%eax
     4d8:	74 1e                	je     4f8 <jointest1+0x56>
      printf(1, "panic at thread_create\n");
     4da:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     4e1:	00 
     4e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4e9:	e8 10 13 00 00       	call   17fe <printf>
      return -1;
     4ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     4f3:	e9 8e 00 00 00       	jmp    586 <jointest1+0xe4>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     4f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     4fc:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
     500:	7e af                	jle    4b1 <jointest1+0xf>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
     502:	c7 44 24 04 ed 1c 00 	movl   $0x1ced,0x4(%esp)
     509:	00 
     50a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     511:	e8 e8 12 00 00       	call   17fe <printf>
  for (i = 1; i <= NUM_THREAD; i++){
     516:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     51d:	eb 48                	jmp    567 <jointest1+0xc5>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     51f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     522:	83 e8 01             	sub    $0x1,%eax
     525:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     529:	8d 55 c8             	lea    -0x38(%ebp),%edx
     52c:	89 54 24 04          	mov    %edx,0x4(%esp)
     530:	89 04 24             	mov    %eax,(%esp)
     533:	e8 de 11 00 00       	call   1716 <thread_join>
     538:	85 c0                	test   %eax,%eax
     53a:	75 0c                	jne    548 <jointest1+0xa6>
     53c:	8b 45 c8             	mov    -0x38(%ebp),%eax
     53f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     542:	01 d2                	add    %edx,%edx
     544:	39 d0                	cmp    %edx,%eax
     546:	74 1b                	je     563 <jointest1+0xc1>
      printf(1, "panic at thread_join\n");
     548:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     54f:	00 
     550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     557:	e8 a2 12 00 00       	call   17fe <printf>
      return -1;
     55c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     561:	eb 23                	jmp    586 <jointest1+0xe4>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
     563:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     567:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
     56b:	7e b2                	jle    51f <jointest1+0x7d>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     56d:	c7 44 24 04 db 1c 00 	movl   $0x1cdb,0x4(%esp)
     574:	00 
     575:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     57c:	e8 7d 12 00 00       	call   17fe <printf>
  return 0;
     581:	b8 00 00 00 00       	mov    $0x0,%eax
}
     586:	c9                   	leave  
     587:	c3                   	ret    

00000588 <jointest2>:

int
jointest2(void)
{
     588:	55                   	push   %ebp
     589:	89 e5                	mov    %esp,%ebp
     58b:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     58e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     595:	eb 4b                	jmp    5e2 <jointest2+0x5a>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
     597:	8b 45 f4             	mov    -0xc(%ebp),%eax
     59a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     59d:	8d 4a ff             	lea    -0x1(%edx),%ecx
     5a0:	8d 55 cc             	lea    -0x34(%ebp),%edx
     5a3:	c1 e1 02             	shl    $0x2,%ecx
     5a6:	01 ca                	add    %ecx,%edx
     5a8:	89 44 24 08          	mov    %eax,0x8(%esp)
     5ac:	c7 44 24 04 69 04 00 	movl   $0x469,0x4(%esp)
     5b3:	00 
     5b4:	89 14 24             	mov    %edx,(%esp)
     5b7:	e8 4a 11 00 00       	call   1706 <thread_create>
     5bc:	85 c0                	test   %eax,%eax
     5be:	74 1e                	je     5de <jointest2+0x56>
      printf(1, "panic at thread_create\n");
     5c0:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     5c7:	00 
     5c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5cf:	e8 2a 12 00 00       	call   17fe <printf>
      return -1;
     5d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5d9:	e9 9a 00 00 00       	jmp    678 <jointest2+0xf0>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
     5de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     5e2:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
     5e6:	7e af                	jle    597 <jointest2+0xf>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
     5e8:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
     5ef:	e8 e2 10 00 00       	call   16d6 <sleep>
  printf(1, "thread_join!!!\n");
     5f4:	c7 44 24 04 ed 1c 00 	movl   $0x1ced,0x4(%esp)
     5fb:	00 
     5fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     603:	e8 f6 11 00 00       	call   17fe <printf>
  for (i = 1; i <= NUM_THREAD; i++){
     608:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     60f:	eb 48                	jmp    659 <jointest2+0xd1>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	83 e8 01             	sub    $0x1,%eax
     617:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     61b:	8d 55 c8             	lea    -0x38(%ebp),%edx
     61e:	89 54 24 04          	mov    %edx,0x4(%esp)
     622:	89 04 24             	mov    %eax,(%esp)
     625:	e8 ec 10 00 00       	call   1716 <thread_join>
     62a:	85 c0                	test   %eax,%eax
     62c:	75 0c                	jne    63a <jointest2+0xb2>
     62e:	8b 45 c8             	mov    -0x38(%ebp),%eax
     631:	8b 55 f4             	mov    -0xc(%ebp),%edx
     634:	01 d2                	add    %edx,%edx
     636:	39 d0                	cmp    %edx,%eax
     638:	74 1b                	je     655 <jointest2+0xcd>
      printf(1, "panic at thread_join\n");
     63a:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     641:	00 
     642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     649:	e8 b0 11 00 00       	call   17fe <printf>
      return -1;
     64e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     653:	eb 23                	jmp    678 <jointest2+0xf0>
      return -1;
    }
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
     655:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     659:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
     65d:	7e b2                	jle    611 <jointest2+0x89>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
     65f:	c7 44 24 04 db 1c 00 	movl   $0x1cdb,0x4(%esp)
     666:	00 
     667:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     66e:	e8 8b 11 00 00       	call   17fe <printf>
  return 0;
     673:	b8 00 00 00 00       	mov    $0x0,%eax
}
     678:	c9                   	leave  
     679:	c3                   	ret    

0000067a <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
     67a:	55                   	push   %ebp
     67b:	89 e5                	mov    %esp,%ebp
     67d:	83 ec 18             	sub    $0x18,%esp
  thread_exit(0);
     680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     687:	e8 82 10 00 00       	call   170e <thread_exit>

0000068c <stresstest>:
}

int
stresstest(void)
{
     68c:	55                   	push   %ebp
     68d:	89 e5                	mov    %esp,%ebp
     68f:	83 ec 58             	sub    $0x58,%esp
  const int nstress = 35000;
     692:	c7 45 ec b8 88 00 00 	movl   $0x88b8,-0x14(%ebp)
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
     699:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     6a0:	e9 e1 00 00 00       	jmp    786 <stresstest+0xfa>
    if (n % 1000 == 0)
     6a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     6a8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
     6ad:	89 c8                	mov    %ecx,%eax
     6af:	f7 ea                	imul   %edx
     6b1:	c1 fa 06             	sar    $0x6,%edx
     6b4:	89 c8                	mov    %ecx,%eax
     6b6:	c1 f8 1f             	sar    $0x1f,%eax
     6b9:	29 c2                	sub    %eax,%edx
     6bb:	89 d0                	mov    %edx,%eax
     6bd:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
     6c3:	29 c1                	sub    %eax,%ecx
     6c5:	89 c8                	mov    %ecx,%eax
     6c7:	85 c0                	test   %eax,%eax
     6c9:	75 1b                	jne    6e6 <stresstest+0x5a>
      printf(1, "%d\n", n);
     6cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6ce:	89 44 24 08          	mov    %eax,0x8(%esp)
     6d2:	c7 44 24 04 d4 1c 00 	movl   $0x1cd4,0x4(%esp)
     6d9:	00 
     6da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6e1:	e8 18 11 00 00       	call   17fe <printf>
    for (i = 0; i < NUM_THREAD; i++){
     6e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     6ed:	eb 45                	jmp    734 <stresstest+0xa8>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
     6ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f2:	8d 55 c4             	lea    -0x3c(%ebp),%edx
     6f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     6f8:	c1 e1 02             	shl    $0x2,%ecx
     6fb:	01 ca                	add    %ecx,%edx
     6fd:	89 44 24 08          	mov    %eax,0x8(%esp)
     701:	c7 44 24 04 7a 06 00 	movl   $0x67a,0x4(%esp)
     708:	00 
     709:	89 14 24             	mov    %edx,(%esp)
     70c:	e8 f5 0f 00 00       	call   1706 <thread_create>
     711:	85 c0                	test   %eax,%eax
     713:	74 1b                	je     730 <stresstest+0xa4>
        printf(1, "panic at thread_create\n");
     715:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     71c:	00 
     71d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     724:	e8 d5 10 00 00       	call   17fe <printf>
        return -1;
     729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     72e:	eb 7b                	jmp    7ab <stresstest+0x11f>
  void *retval;

  for (n = 1; n <= nstress; n++){
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
     730:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     734:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     738:	7e b5                	jle    6ef <stresstest+0x63>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     73a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     741:	eb 39                	jmp    77c <stresstest+0xf0>
      if (thread_join(threads[i], &retval) != 0){
     743:	8b 45 f4             	mov    -0xc(%ebp),%eax
     746:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
     74a:	8d 55 c0             	lea    -0x40(%ebp),%edx
     74d:	89 54 24 04          	mov    %edx,0x4(%esp)
     751:	89 04 24             	mov    %eax,(%esp)
     754:	e8 bd 0f 00 00       	call   1716 <thread_join>
     759:	85 c0                	test   %eax,%eax
     75b:	74 1b                	je     778 <stresstest+0xec>
        printf(1, "panic at thread_join\n");
     75d:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     764:	00 
     765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     76c:	e8 8d 10 00 00       	call   17fe <printf>
        return -1;
     771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     776:	eb 33                	jmp    7ab <stresstest+0x11f>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     778:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     77c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     780:	7e c1                	jle    743 <stresstest+0xb7>
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
     782:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     786:	8b 45 f0             	mov    -0x10(%ebp),%eax
     789:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     78c:	0f 8e 13 ff ff ff    	jle    6a5 <stresstest+0x19>
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
  }
  printf(1, "\n");
     792:	c7 44 24 04 db 1c 00 	movl   $0x1cdb,0x4(%esp)
     799:	00 
     79a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7a1:	e8 58 10 00 00       	call   17fe <printf>
  return 0;
     7a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7ab:	c9                   	leave  
     7ac:	c3                   	ret    

000007ad <exitthreadmain>:

// ============================================================================

void*
exitthreadmain(void *arg)
{
     7ad:	55                   	push   %ebp
     7ae:	89 e5                	mov    %esp,%ebp
     7b0:	83 ec 28             	sub    $0x28,%esp
  int i;
  if ((int)arg == 1){
     7b3:	8b 45 08             	mov    0x8(%ebp),%eax
     7b6:	83 f8 01             	cmp    $0x1,%eax
     7b9:	75 2c                	jne    7e7 <exitthreadmain+0x3a>
    while(1){
      printf(1, "thread_exit ...\n");
     7bb:	c7 44 24 04 fd 1c 00 	movl   $0x1cfd,0x4(%esp)
     7c2:	00 
     7c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7ca:	e8 2f 10 00 00       	call   17fe <printf>
      for (i = 0; i < 5000000; i++);
     7cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7d6:	eb 04                	jmp    7dc <exitthreadmain+0x2f>
     7d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7dc:	81 7d f4 3f 4b 4c 00 	cmpl   $0x4c4b3f,-0xc(%ebp)
     7e3:	7e f3                	jle    7d8 <exitthreadmain+0x2b>
    }
     7e5:	eb d4                	jmp    7bb <exitthreadmain+0xe>
  } else if ((int)arg == 2){
     7e7:	8b 45 08             	mov    0x8(%ebp),%eax
     7ea:	83 f8 02             	cmp    $0x2,%eax
     7ed:	75 05                	jne    7f4 <exitthreadmain+0x47>
    exit();
     7ef:	e8 4a 0e 00 00       	call   163e <exit>
  }
  thread_exit(0);
     7f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     7fb:	e8 0e 0f 00 00       	call   170e <thread_exit>

00000800 <exittest1>:
}

int
exittest1(void)
{
     800:	55                   	push   %ebp
     801:	89 e5                	mov    %esp,%ebp
     803:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  
  for (i = 0; i < NUM_THREAD; i++){
     806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     80d:	eb 46                	jmp    855 <exittest1+0x55>
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
     80f:	8d 45 cc             	lea    -0x34(%ebp),%eax
     812:	8b 55 f4             	mov    -0xc(%ebp),%edx
     815:	c1 e2 02             	shl    $0x2,%edx
     818:	01 d0                	add    %edx,%eax
     81a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     821:	00 
     822:	c7 44 24 04 ad 07 00 	movl   $0x7ad,0x4(%esp)
     829:	00 
     82a:	89 04 24             	mov    %eax,(%esp)
     82d:	e8 d4 0e 00 00       	call   1706 <thread_create>
     832:	85 c0                	test   %eax,%eax
     834:	74 1b                	je     851 <exittest1+0x51>
      printf(1, "panic at thread_create\n");
     836:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     83d:	00 
     83e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     845:	e8 b4 0f 00 00       	call   17fe <printf>
      return -1;
     84a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     84f:	eb 1b                	jmp    86c <exittest1+0x6c>
exittest1(void)
{
  thread_t threads[NUM_THREAD];
  int i;
  
  for (i = 0; i < NUM_THREAD; i++){
     851:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     855:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     859:	7e b4                	jle    80f <exittest1+0xf>
    if (thread_create(&threads[i], exitthreadmain, (void*)1) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(1);
     85b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     862:	e8 6f 0e 00 00       	call   16d6 <sleep>
  return 0;
     867:	b8 00 00 00 00       	mov    $0x0,%eax
}
     86c:	c9                   	leave  
     86d:	c3                   	ret    

0000086e <exittest2>:

int
exittest2(void)
{
     86e:	55                   	push   %ebp
     86f:	89 e5                	mov    %esp,%ebp
     871:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
     874:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     87b:	eb 46                	jmp    8c3 <exittest2+0x55>
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
     87d:	8d 45 cc             	lea    -0x34(%ebp),%eax
     880:	8b 55 f4             	mov    -0xc(%ebp),%edx
     883:	c1 e2 02             	shl    $0x2,%edx
     886:	01 d0                	add    %edx,%eax
     888:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
     88f:	00 
     890:	c7 44 24 04 ad 07 00 	movl   $0x7ad,0x4(%esp)
     897:	00 
     898:	89 04 24             	mov    %eax,(%esp)
     89b:	e8 66 0e 00 00       	call   1706 <thread_create>
     8a0:	85 c0                	test   %eax,%eax
     8a2:	74 1b                	je     8bf <exittest2+0x51>
      printf(1, "panic at thread_create\n");
     8a4:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     8ab:	00 
     8ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8b3:	e8 46 0f 00 00       	call   17fe <printf>
      return -1;
     8b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     8bd:	eb 0c                	jmp    8cb <exittest2+0x5d>
exittest2(void)
{
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
     8bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8c3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     8c7:	7e b4                	jle    87d <exittest2+0xf>
    if (thread_create(&threads[i], exitthreadmain, (void*)2) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  while(1);
     8c9:	eb fe                	jmp    8c9 <exittest2+0x5b>
  return 0;
}
     8cb:	c9                   	leave  
     8cc:	c3                   	ret    

000008cd <forkthreadmain>:

// ============================================================================

void*
forkthreadmain(void *arg)
{
     8cd:	55                   	push   %ebp
     8ce:	89 e5                	mov    %esp,%ebp
     8d0:	83 ec 28             	sub    $0x28,%esp
  int pid;
  if ((pid = fork()) == -1){
     8d3:	e8 5e 0d 00 00       	call   1636 <fork>
     8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
     8db:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     8df:	75 19                	jne    8fa <forkthreadmain+0x2d>
    printf(1, "panic at fork in forktest\n");
     8e1:	c7 44 24 04 0e 1d 00 	movl   $0x1d0e,0x4(%esp)
     8e8:	00 
     8e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8f0:	e8 09 0f 00 00       	call   17fe <printf>
    exit();
     8f5:	e8 44 0d 00 00       	call   163e <exit>
  } else if (pid == 0){
     8fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8fe:	75 19                	jne    919 <forkthreadmain+0x4c>
    printf(1, "child\n");
     900:	c7 44 24 04 29 1d 00 	movl   $0x1d29,0x4(%esp)
     907:	00 
     908:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     90f:	e8 ea 0e 00 00       	call   17fe <printf>
    exit();
     914:	e8 25 0d 00 00       	call   163e <exit>
  } else{
    printf(1, "parent\n");
     919:	c7 44 24 04 30 1d 00 	movl   $0x1d30,0x4(%esp)
     920:	00 
     921:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     928:	e8 d1 0e 00 00       	call   17fe <printf>
    if (wait() == -1){
     92d:	e8 14 0d 00 00       	call   1646 <wait>
     932:	83 f8 ff             	cmp    $0xffffffff,%eax
     935:	75 19                	jne    950 <forkthreadmain+0x83>
      printf(1, "panic at wait in forktest\n");
     937:	c7 44 24 04 38 1d 00 	movl   $0x1d38,0x4(%esp)
     93e:	00 
     93f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     946:	e8 b3 0e 00 00       	call   17fe <printf>
      exit();
     94b:	e8 ee 0c 00 00       	call   163e <exit>
    }
  }
  thread_exit(0);
     950:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     957:	e8 b2 0d 00 00       	call   170e <thread_exit>

0000095c <forktest>:
}

int
forktest(void)
{
     95c:	55                   	push   %ebp
     95d:	89 e5                	mov    %esp,%ebp
     95f:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     969:	eb 46                	jmp    9b1 <forktest+0x55>
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
     96b:	8d 45 cc             	lea    -0x34(%ebp),%eax
     96e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     971:	c1 e2 02             	shl    $0x2,%edx
     974:	01 d0                	add    %edx,%eax
     976:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     97d:	00 
     97e:	c7 44 24 04 cd 08 00 	movl   $0x8cd,0x4(%esp)
     985:	00 
     986:	89 04 24             	mov    %eax,(%esp)
     989:	e8 78 0d 00 00       	call   1706 <thread_create>
     98e:	85 c0                	test   %eax,%eax
     990:	74 1b                	je     9ad <forktest+0x51>
      printf(1, "panic at thread_create\n");
     992:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     999:	00 
     99a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9a1:	e8 58 0e 00 00       	call   17fe <printf>
      return -1;
     9a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     9ab:	eb 57                	jmp    a04 <forktest+0xa8>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     9ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9b1:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     9b5:	7e b4                	jle    96b <forktest+0xf>
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     9b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9be:	eb 39                	jmp    9f9 <forktest+0x9d>
    if (thread_join(threads[i], &retval) != 0){
     9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     9c7:	8d 55 c8             	lea    -0x38(%ebp),%edx
     9ca:	89 54 24 04          	mov    %edx,0x4(%esp)
     9ce:	89 04 24             	mov    %eax,(%esp)
     9d1:	e8 40 0d 00 00       	call   1716 <thread_join>
     9d6:	85 c0                	test   %eax,%eax
     9d8:	74 1b                	je     9f5 <forktest+0x99>
      printf(1, "panic at thread_join\n");
     9da:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     9e1:	00 
     9e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9e9:	e8 10 0e 00 00       	call   17fe <printf>
      return -1;
     9ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     9f3:	eb 0f                	jmp    a04 <forktest+0xa8>
    if (thread_create(&threads[i], forkthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     9f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9f9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     9fd:	7e c1                	jle    9c0 <forktest+0x64>
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  return 0;
     9ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a04:	c9                   	leave  
     a05:	c3                   	ret    

00000a06 <execthreadmain>:

// ============================================================================

void*
execthreadmain(void *arg)
{
     a06:	55                   	push   %ebp
     a07:	89 e5                	mov    %esp,%ebp
     a09:	83 ec 28             	sub    $0x28,%esp
  char *args[3] = {"echo", "echo is executed!", 0}; 
     a0c:	c7 45 ec 53 1d 00 00 	movl   $0x1d53,-0x14(%ebp)
     a13:	c7 45 f0 58 1d 00 00 	movl   $0x1d58,-0x10(%ebp)
     a1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  sleep(1);
     a21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a28:	e8 a9 0c 00 00       	call   16d6 <sleep>
  exec("echo", args);
     a2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
     a30:	89 44 24 04          	mov    %eax,0x4(%esp)
     a34:	c7 04 24 53 1d 00 00 	movl   $0x1d53,(%esp)
     a3b:	e8 36 0c 00 00       	call   1676 <exec>

  printf(1, "panic at execthreadmain\n");
     a40:	c7 44 24 04 6a 1d 00 	movl   $0x1d6a,0x4(%esp)
     a47:	00 
     a48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a4f:	e8 aa 0d 00 00       	call   17fe <printf>
  exit();
     a54:	e8 e5 0b 00 00       	call   163e <exit>

00000a59 <exectest>:
}

int
exectest(void)
{
     a59:	55                   	push   %ebp
     a5a:	89 e5                	mov    %esp,%ebp
     a5c:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     a5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a66:	eb 46                	jmp    aae <exectest+0x55>
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
     a68:	8d 45 cc             	lea    -0x34(%ebp),%eax
     a6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a6e:	c1 e2 02             	shl    $0x2,%edx
     a71:	01 d0                	add    %edx,%eax
     a73:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a7a:	00 
     a7b:	c7 44 24 04 06 0a 00 	movl   $0xa06,0x4(%esp)
     a82:	00 
     a83:	89 04 24             	mov    %eax,(%esp)
     a86:	e8 7b 0c 00 00       	call   1706 <thread_create>
     a8b:	85 c0                	test   %eax,%eax
     a8d:	74 1b                	je     aaa <exectest+0x51>
      printf(1, "panic at thread_create\n");
     a8f:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     a96:	00 
     a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a9e:	e8 5b 0d 00 00       	call   17fe <printf>
      return -1;
     aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     aa8:	eb 6b                	jmp    b15 <exectest+0xbc>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     aaa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     aae:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ab2:	7e b4                	jle    a68 <exectest+0xf>
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     abb:	eb 39                	jmp    af6 <exectest+0x9d>
    if (thread_join(threads[i], &retval) != 0){
     abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     ac4:	8d 55 c8             	lea    -0x38(%ebp),%edx
     ac7:	89 54 24 04          	mov    %edx,0x4(%esp)
     acb:	89 04 24             	mov    %eax,(%esp)
     ace:	e8 43 0c 00 00       	call   1716 <thread_join>
     ad3:	85 c0                	test   %eax,%eax
     ad5:	74 1b                	je     af2 <exectest+0x99>
      printf(1, "panic at thread_join\n");
     ad7:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     ade:	00 
     adf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ae6:	e8 13 0d 00 00       	call   17fe <printf>
      return -1;
     aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     af0:	eb 23                	jmp    b15 <exectest+0xbc>
    if (thread_create(&threads[i], execthreadmain, (void*)0) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     af2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     af6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     afa:	7e c1                	jle    abd <exectest+0x64>
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1, "panic at exectest\n");
     afc:	c7 44 24 04 83 1d 00 	movl   $0x1d83,0x4(%esp)
     b03:	00 
     b04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b0b:	e8 ee 0c 00 00       	call   17fe <printf>
  return 0;
     b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b15:	c9                   	leave  
     b16:	c3                   	ret    

00000b17 <sbrkthreadmain>:

// ============================================================================

void*
sbrkthreadmain(void *arg)
{
     b17:	55                   	push   %ebp
     b18:	89 e5                	mov    %esp,%ebp
     b1a:	83 ec 28             	sub    $0x28,%esp
  int tid = (int)arg;
     b1d:	8b 45 08             	mov    0x8(%ebp),%eax
     b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char *oldbrk;
  char *end;
  char *c;
  oldbrk = sbrk(1000);
     b23:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
     b2a:	e8 9f 0b 00 00       	call   16ce <sbrk>
     b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  end = oldbrk + 1000;
     b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b35:	05 e8 03 00 00       	add    $0x3e8,%eax
     b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for (c = oldbrk; c < end; c++){
     b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b43:	eb 11                	jmp    b56 <sbrkthreadmain+0x3f>
    *c = tid+1;
     b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b48:	83 c0 01             	add    $0x1,%eax
     b4b:	89 c2                	mov    %eax,%edx
     b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b50:	88 10                	mov    %dl,(%eax)
  char *oldbrk;
  char *end;
  char *c;
  oldbrk = sbrk(1000);
  end = oldbrk + 1000;
  for (c = oldbrk; c < end; c++){
     b52:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b59:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     b5c:	72 e7                	jb     b45 <sbrkthreadmain+0x2e>
    *c = tid+1;
  }
  sleep(1);
     b5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b65:	e8 6c 0b 00 00       	call   16d6 <sleep>
  for (c = oldbrk; c < end; c++){
     b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     b70:	eb 30                	jmp    ba2 <sbrkthreadmain+0x8b>
    if (*c != tid+1){
     b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b75:	0f b6 00             	movzbl (%eax),%eax
     b78:	0f be c0             	movsbl %al,%eax
     b7b:	8b 55 f0             	mov    -0x10(%ebp),%edx
     b7e:	83 c2 01             	add    $0x1,%edx
     b81:	39 d0                	cmp    %edx,%eax
     b83:	74 19                	je     b9e <sbrkthreadmain+0x87>
      printf(1, "panic at sbrkthreadmain\n");
     b85:	c7 44 24 04 96 1d 00 	movl   $0x1d96,0x4(%esp)
     b8c:	00 
     b8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b94:	e8 65 0c 00 00       	call   17fe <printf>
      exit();
     b99:	e8 a0 0a 00 00       	call   163e <exit>
  end = oldbrk + 1000;
  for (c = oldbrk; c < end; c++){
    *c = tid+1;
  }
  sleep(1);
  for (c = oldbrk; c < end; c++){
     b9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ba5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     ba8:	72 c8                	jb     b72 <sbrkthreadmain+0x5b>
    if (*c != tid+1){
      printf(1, "panic at sbrkthreadmain\n");
      exit();
    }
  }
  thread_exit(0);
     baa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     bb1:	e8 58 0b 00 00       	call   170e <thread_exit>

00000bb6 <sbrktest>:
}

int
sbrktest(void)
{
     bb6:	55                   	push   %ebp
     bb7:	89 e5                	mov    %esp,%ebp
     bb9:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     bbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bc3:	eb 45                	jmp    c0a <sbrktest+0x54>
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
     bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc8:	8d 55 cc             	lea    -0x34(%ebp),%edx
     bcb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     bce:	c1 e1 02             	shl    $0x2,%ecx
     bd1:	01 ca                	add    %ecx,%edx
     bd3:	89 44 24 08          	mov    %eax,0x8(%esp)
     bd7:	c7 44 24 04 17 0b 00 	movl   $0xb17,0x4(%esp)
     bde:	00 
     bdf:	89 14 24             	mov    %edx,(%esp)
     be2:	e8 1f 0b 00 00       	call   1706 <thread_create>
     be7:	85 c0                	test   %eax,%eax
     be9:	74 1b                	je     c06 <sbrktest+0x50>
      printf(1, "panic at thread_create\n");
     beb:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     bf2:	00 
     bf3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     bfa:	e8 ff 0b 00 00       	call   17fe <printf>
      return -1;
     bff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c04:	eb 57                	jmp    c5d <sbrktest+0xa7>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     c06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c0a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     c0e:	7e b5                	jle    bc5 <sbrktest+0xf>
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c17:	eb 39                	jmp    c52 <sbrktest+0x9c>
    if (thread_join(threads[i], &retval) != 0){
     c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c1c:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     c20:	8d 55 c8             	lea    -0x38(%ebp),%edx
     c23:	89 54 24 04          	mov    %edx,0x4(%esp)
     c27:	89 04 24             	mov    %eax,(%esp)
     c2a:	e8 e7 0a 00 00       	call   1716 <thread_join>
     c2f:	85 c0                	test   %eax,%eax
     c31:	74 1b                	je     c4e <sbrktest+0x98>
      printf(1, "panic at thread_join\n");
     c33:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     c3a:	00 
     c3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c42:	e8 b7 0b 00 00       	call   17fe <printf>
      return -1;
     c47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c4c:	eb 0f                	jmp    c5d <sbrktest+0xa7>
    if (thread_create(&threads[i], sbrkthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     c4e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     c52:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     c56:	7e c1                	jle    c19 <sbrktest+0x63>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  return 0;
     c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c5d:	c9                   	leave  
     c5e:	c3                   	ret    

00000c5f <killthreadmain>:

// ============================================================================

void*
killthreadmain(void *arg)
{
     c5f:	55                   	push   %ebp
     c60:	89 e5                	mov    %esp,%ebp
     c62:	83 ec 18             	sub    $0x18,%esp
  kill(getpid());
     c65:	e8 54 0a 00 00       	call   16be <getpid>
     c6a:	89 04 24             	mov    %eax,(%esp)
     c6d:	e8 fc 09 00 00       	call   166e <kill>
  while(1);
     c72:	eb fe                	jmp    c72 <killthreadmain+0x13>

00000c74 <killtest>:
}

int
killtest(void)
{
     c74:	55                   	push   %ebp
     c75:	89 e5                	mov    %esp,%ebp
     c77:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c81:	eb 45                	jmp    cc8 <killtest+0x54>
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
     c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c86:	8d 55 cc             	lea    -0x34(%ebp),%edx
     c89:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c8c:	c1 e1 02             	shl    $0x2,%ecx
     c8f:	01 ca                	add    %ecx,%edx
     c91:	89 44 24 08          	mov    %eax,0x8(%esp)
     c95:	c7 44 24 04 5f 0c 00 	movl   $0xc5f,0x4(%esp)
     c9c:	00 
     c9d:	89 14 24             	mov    %edx,(%esp)
     ca0:	e8 61 0a 00 00       	call   1706 <thread_create>
     ca5:	85 c0                	test   %eax,%eax
     ca7:	74 1b                	je     cc4 <killtest+0x50>
      printf(1, "panic at thread_create\n");
     ca9:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     cb0:	00 
     cb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cb8:	e8 41 0b 00 00       	call   17fe <printf>
      return -1;
     cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cc2:	eb 54                	jmp    d18 <killtest+0xa4>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
     cc4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cc8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ccc:	7e b5                	jle    c83 <killtest+0xf>
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     cce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cd5:	eb 39                	jmp    d10 <killtest+0x9c>
    if (thread_join(threads[i], &retval) != 0){
     cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cda:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
     cde:	8d 55 c8             	lea    -0x38(%ebp),%edx
     ce1:	89 54 24 04          	mov    %edx,0x4(%esp)
     ce5:	89 04 24             	mov    %eax,(%esp)
     ce8:	e8 29 0a 00 00       	call   1716 <thread_join>
     ced:	85 c0                	test   %eax,%eax
     cef:	74 1b                	je     d0c <killtest+0x98>
      printf(1, "panic at thread_join\n");
     cf1:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     cf8:	00 
     cf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d00:	e8 f9 0a 00 00       	call   17fe <printf>
      return -1;
     d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d0a:	eb 0c                	jmp    d18 <killtest+0xa4>
    if (thread_create(&threads[i], killthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
     d0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d10:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     d14:	7e c1                	jle    cd7 <killtest+0x63>
    if (thread_join(threads[i], &retval) != 0){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  while(1);
     d16:	eb fe                	jmp    d16 <killtest+0xa2>
  return 0;
}
     d18:	c9                   	leave  
     d19:	c3                   	ret    

00000d1a <pipethreadmain>:

// ============================================================================

void*
pipethreadmain(void *arg)
{
     d1a:	55                   	push   %ebp
     d1b:	89 e5                	mov    %esp,%ebp
     d1d:	83 ec 28             	sub    $0x28,%esp
  int type = ((int*)arg)[0];
     d20:	8b 45 08             	mov    0x8(%ebp),%eax
     d23:	8b 00                	mov    (%eax),%eax
     d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int *fd = (int*)arg+1;
     d28:	8b 45 08             	mov    0x8(%ebp),%eax
     d2b:	83 c0 04             	add    $0x4,%eax
     d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  int input;
  for (i = -5; i <= 5; i++){
     d31:	c7 45 ec fb ff ff ff 	movl   $0xfffffffb,-0x14(%ebp)
     d38:	eb 56                	jmp    d90 <pipethreadmain+0x76>
    if (type){
     d3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d3e:	74 28                	je     d68 <pipethreadmain+0x4e>
      read(fd[0], &input, sizeof(int));
     d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d43:	8b 00                	mov    (%eax),%eax
     d45:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
     d4c:	00 
     d4d:	8d 55 e8             	lea    -0x18(%ebp),%edx
     d50:	89 54 24 04          	mov    %edx,0x4(%esp)
     d54:	89 04 24             	mov    %eax,(%esp)
     d57:	e8 fa 08 00 00       	call   1656 <read>
      __sync_fetch_and_add(&gcnt, input);
     d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d5f:	f0 01 05 9c 24 00 00 	lock add %eax,0x249c
     d66:	eb 1f                	jmp    d87 <pipethreadmain+0x6d>
      //gcnt += input;
    } else{
      write(fd[1], &i, sizeof(int));
     d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d6b:	83 c0 04             	add    $0x4,%eax
     d6e:	8b 00                	mov    (%eax),%eax
     d70:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
     d77:	00 
     d78:	8d 55 ec             	lea    -0x14(%ebp),%edx
     d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
     d7f:	89 04 24             	mov    %eax,(%esp)
     d82:	e8 d7 08 00 00       	call   165e <write>
{
  int type = ((int*)arg)[0];
  int *fd = (int*)arg+1;
  int i;
  int input;
  for (i = -5; i <= 5; i++){
     d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d8a:	83 c0 01             	add    $0x1,%eax
     d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d93:	83 f8 05             	cmp    $0x5,%eax
     d96:	7e a2                	jle    d3a <pipethreadmain+0x20>
      //gcnt += input;
    } else{
      write(fd[1], &i, sizeof(int));
    }
  }
  thread_exit(0);
     d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     d9f:	e8 6a 09 00 00       	call   170e <thread_exit>

00000da4 <pipetest>:
}

int
pipetest(void)
{
     da4:	55                   	push   %ebp
     da5:	89 e5                	mov    %esp,%ebp
     da7:	83 ec 68             	sub    $0x68,%esp
  int fd[2];
  int i;
  void *retval;
  int pid;

  if (pipe(fd) < 0){
     daa:	8d 45 b4             	lea    -0x4c(%ebp),%eax
     dad:	89 04 24             	mov    %eax,(%esp)
     db0:	e8 99 08 00 00       	call   164e <pipe>
     db5:	85 c0                	test   %eax,%eax
     db7:	79 1e                	jns    dd7 <pipetest+0x33>
    printf(1, "panic at pipe in pipetest\n");
     db9:	c7 44 24 04 af 1d 00 	movl   $0x1daf,0x4(%esp)
     dc0:	00 
     dc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dc8:	e8 31 0a 00 00       	call   17fe <printf>
    return -1;
     dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dd2:	e9 1c 02 00 00       	jmp    ff3 <pipetest+0x24f>
  }
  arg[1] = fd[0];
     dd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     dda:	89 45 c0             	mov    %eax,-0x40(%ebp)
  arg[2] = fd[1];
     ddd:	8b 45 b8             	mov    -0x48(%ebp),%eax
     de0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if ((pid = fork()) < 0){
     de3:	e8 4e 08 00 00       	call   1636 <fork>
     de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
     deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     def:	79 1e                	jns    e0f <pipetest+0x6b>
      printf(1, "panic at fork in pipetest\n");
     df1:	c7 44 24 04 ca 1d 00 	movl   $0x1dca,0x4(%esp)
     df8:	00 
     df9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e00:	e8 f9 09 00 00       	call   17fe <printf>
      return -1;
     e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e0a:	e9 e4 01 00 00       	jmp    ff3 <pipetest+0x24f>
  } else if (pid == 0){
     e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e13:	0f 85 c4 00 00 00    	jne    edd <pipetest+0x139>
    close(fd[0]);
     e19:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     e1c:	89 04 24             	mov    %eax,(%esp)
     e1f:	e8 42 08 00 00       	call   1666 <close>
    arg[0] = 0;
     e24:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    for (i = 0; i < NUM_THREAD; i++){
     e2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e32:	eb 48                	jmp    e7c <pipetest+0xd8>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     e34:	8d 45 c8             	lea    -0x38(%ebp),%eax
     e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e3a:	c1 e2 02             	shl    $0x2,%edx
     e3d:	01 c2                	add    %eax,%edx
     e3f:	8d 45 bc             	lea    -0x44(%ebp),%eax
     e42:	89 44 24 08          	mov    %eax,0x8(%esp)
     e46:	c7 44 24 04 1a 0d 00 	movl   $0xd1a,0x4(%esp)
     e4d:	00 
     e4e:	89 14 24             	mov    %edx,(%esp)
     e51:	e8 b0 08 00 00       	call   1706 <thread_create>
     e56:	85 c0                	test   %eax,%eax
     e58:	74 1e                	je     e78 <pipetest+0xd4>
        printf(1, "panic at thread_create\n");
     e5a:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     e61:	00 
     e62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e69:	e8 90 09 00 00       	call   17fe <printf>
        return -1;
     e6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e73:	e9 7b 01 00 00       	jmp    ff3 <pipetest+0x24f>
      printf(1, "panic at fork in pipetest\n");
      return -1;
  } else if (pid == 0){
    close(fd[0]);
    arg[0] = 0;
    for (i = 0; i < NUM_THREAD; i++){
     e78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     e7c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     e80:	7e b2                	jle    e34 <pipetest+0x90>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     e82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e89:	eb 3c                	jmp    ec7 <pipetest+0x123>
      if (thread_join(threads[i], &retval) != 0){
     e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e8e:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
     e92:	8d 55 b0             	lea    -0x50(%ebp),%edx
     e95:	89 54 24 04          	mov    %edx,0x4(%esp)
     e99:	89 04 24             	mov    %eax,(%esp)
     e9c:	e8 75 08 00 00       	call   1716 <thread_join>
     ea1:	85 c0                	test   %eax,%eax
     ea3:	74 1e                	je     ec3 <pipetest+0x11f>
        printf(1, "panic at thread_join\n");
     ea5:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     eac:	00 
     ead:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     eb4:	e8 45 09 00 00       	call   17fe <printf>
        return -1;
     eb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ebe:	e9 30 01 00 00       	jmp    ff3 <pipetest+0x24f>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     ec3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ec7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     ecb:	7e be                	jle    e8b <pipetest+0xe7>
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
    close(fd[1]);
     ecd:	8b 45 b8             	mov    -0x48(%ebp),%eax
     ed0:	89 04 24             	mov    %eax,(%esp)
     ed3:	e8 8e 07 00 00       	call   1666 <close>
    exit();
     ed8:	e8 61 07 00 00       	call   163e <exit>
  } else{
    close(fd[1]);
     edd:	8b 45 b8             	mov    -0x48(%ebp),%eax
     ee0:	89 04 24             	mov    %eax,(%esp)
     ee3:	e8 7e 07 00 00       	call   1666 <close>
    arg[0] = 1;
     ee8:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    gcnt = 0;
     eef:	c7 05 9c 24 00 00 00 	movl   $0x0,0x249c
     ef6:	00 00 00 
    for (i = 0; i < NUM_THREAD; i++){
     ef9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f00:	eb 48                	jmp    f4a <pipetest+0x1a6>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
     f02:	8d 45 c8             	lea    -0x38(%ebp),%eax
     f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
     f08:	c1 e2 02             	shl    $0x2,%edx
     f0b:	01 c2                	add    %eax,%edx
     f0d:	8d 45 bc             	lea    -0x44(%ebp),%eax
     f10:	89 44 24 08          	mov    %eax,0x8(%esp)
     f14:	c7 44 24 04 1a 0d 00 	movl   $0xd1a,0x4(%esp)
     f1b:	00 
     f1c:	89 14 24             	mov    %edx,(%esp)
     f1f:	e8 e2 07 00 00       	call   1706 <thread_create>
     f24:	85 c0                	test   %eax,%eax
     f26:	74 1e                	je     f46 <pipetest+0x1a2>
        printf(1, "panic at thread_create\n");
     f28:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
     f2f:	00 
     f30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f37:	e8 c2 08 00 00       	call   17fe <printf>
        return -1;
     f3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f41:	e9 ad 00 00 00       	jmp    ff3 <pipetest+0x24f>
    exit();
  } else{
    close(fd[1]);
    arg[0] = 1;
    gcnt = 0;
    for (i = 0; i < NUM_THREAD; i++){
     f46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f4a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     f4e:	7e b2                	jle    f02 <pipetest+0x15e>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     f50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f57:	eb 39                	jmp    f92 <pipetest+0x1ee>
      if (thread_join(threads[i], &retval) != 0){
     f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f5c:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
     f60:	8d 55 b0             	lea    -0x50(%ebp),%edx
     f63:	89 54 24 04          	mov    %edx,0x4(%esp)
     f67:	89 04 24             	mov    %eax,(%esp)
     f6a:	e8 a7 07 00 00       	call   1716 <thread_join>
     f6f:	85 c0                	test   %eax,%eax
     f71:	74 1b                	je     f8e <pipetest+0x1ea>
        printf(1, "panic at thread_join\n");
     f73:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
     f7a:	00 
     f7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f82:	e8 77 08 00 00       	call   17fe <printf>
        return -1;
     f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     f8c:	eb 65                	jmp    ff3 <pipetest+0x24f>
      if (thread_create(&threads[i], pipethreadmain, (void*)arg) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
     f8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     f92:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     f96:	7e c1                	jle    f59 <pipetest+0x1b5>
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
    close(fd[0]);
     f98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     f9b:	89 04 24             	mov    %eax,(%esp)
     f9e:	e8 c3 06 00 00       	call   1666 <close>
  }
  if (wait() == -1){
     fa3:	e8 9e 06 00 00       	call   1646 <wait>
     fa8:	83 f8 ff             	cmp    $0xffffffff,%eax
     fab:	75 1b                	jne    fc8 <pipetest+0x224>
    printf(1, "panic at wait in pipetest\n");
     fad:	c7 44 24 04 e5 1d 00 	movl   $0x1de5,0x4(%esp)
     fb4:	00 
     fb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fbc:	e8 3d 08 00 00       	call   17fe <printf>
    return -1;
     fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fc6:	eb 2b                	jmp    ff3 <pipetest+0x24f>
  }
  if (gcnt != 0)
     fc8:	a1 9c 24 00 00       	mov    0x249c,%eax
     fcd:	85 c0                	test   %eax,%eax
     fcf:	74 1d                	je     fee <pipetest+0x24a>
    printf(1,"panic at validation in pipetest : %d\n", gcnt);
     fd1:	a1 9c 24 00 00       	mov    0x249c,%eax
     fd6:	89 44 24 08          	mov    %eax,0x8(%esp)
     fda:	c7 44 24 04 00 1e 00 	movl   $0x1e00,0x4(%esp)
     fe1:	00 
     fe2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fe9:	e8 10 08 00 00       	call   17fe <printf>

  return 0;
     fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ff3:	c9                   	leave  
     ff4:	c3                   	ret    

00000ff5 <sleepthreadmain>:

// ============================================================================

void*
sleepthreadmain(void *arg)
{
     ff5:	55                   	push   %ebp
     ff6:	89 e5                	mov    %esp,%ebp
     ff8:	83 ec 18             	sub    $0x18,%esp
  sleep(1000000);
     ffb:	c7 04 24 40 42 0f 00 	movl   $0xf4240,(%esp)
    1002:	e8 cf 06 00 00       	call   16d6 <sleep>
  thread_exit(0);
    1007:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    100e:	e8 fb 06 00 00       	call   170e <thread_exit>

00001013 <sleeptest>:
}

int
sleeptest(void)
{
    1013:	55                   	push   %ebp
    1014:	89 e5                	mov    %esp,%ebp
    1016:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
    1019:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1020:	eb 45                	jmp    1067 <sleeptest+0x54>
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
    1022:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1025:	8d 55 cc             	lea    -0x34(%ebp),%edx
    1028:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    102b:	c1 e1 02             	shl    $0x2,%ecx
    102e:	01 ca                	add    %ecx,%edx
    1030:	89 44 24 08          	mov    %eax,0x8(%esp)
    1034:	c7 44 24 04 f5 0f 00 	movl   $0xff5,0x4(%esp)
    103b:	00 
    103c:	89 14 24             	mov    %edx,(%esp)
    103f:	e8 c2 06 00 00       	call   1706 <thread_create>
    1044:	85 c0                	test   %eax,%eax
    1046:	74 1b                	je     1063 <sleeptest+0x50>
        printf(1, "panic at thread_create\n");
    1048:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
    104f:	00 
    1050:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1057:	e8 a2 07 00 00       	call   17fe <printf>
        return -1;
    105c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1061:	eb 1b                	jmp    107e <sleeptest+0x6b>
sleeptest(void)
{
  thread_t threads[NUM_THREAD];
  int i;

  for (i = 0; i < NUM_THREAD; i++){
    1063:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1067:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    106b:	7e b5                	jle    1022 <sleeptest+0xf>
    if (thread_create(&threads[i], sleepthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
    }
  }
  sleep(10);
    106d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
    1074:	e8 5d 06 00 00       	call   16d6 <sleep>
  return 0;
    1079:	b8 00 00 00 00       	mov    $0x0,%eax
}
    107e:	c9                   	leave  
    107f:	c3                   	ret    

00001080 <stridethreadmain>:

// ============================================================================

void*
stridethreadmain(void *arg)
{
    1080:	55                   	push   %ebp
    1081:	89 e5                	mov    %esp,%ebp
    1083:	83 ec 28             	sub    $0x28,%esp
  int *flag = (int*)arg;
    1086:	8b 45 08             	mov    0x8(%ebp),%eax
    1089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int t;
  while(*flag){
    108c:	eb 27                	jmp    10b5 <stridethreadmain+0x35>
    while(*flag == 1){
    108e:	eb 1b                	jmp    10ab <stridethreadmain+0x2b>
      for (t = 0; t < 5; t++);
    1090:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1097:	eb 04                	jmp    109d <stridethreadmain+0x1d>
    1099:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    109d:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
    10a1:	7e f6                	jle    1099 <stridethreadmain+0x19>
      __sync_fetch_and_add(&gcnt, 1);
    10a3:	f0 83 05 9c 24 00 00 	lock addl $0x1,0x249c
    10aa:	01 
stridethreadmain(void *arg)
{
  int *flag = (int*)arg;
  int t;
  while(*flag){
    while(*flag == 1){
    10ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10ae:	8b 00                	mov    (%eax),%eax
    10b0:	83 f8 01             	cmp    $0x1,%eax
    10b3:	74 db                	je     1090 <stridethreadmain+0x10>
void*
stridethreadmain(void *arg)
{
  int *flag = (int*)arg;
  int t;
  while(*flag){
    10b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b8:	8b 00                	mov    (%eax),%eax
    10ba:	85 c0                	test   %eax,%eax
    10bc:	75 d0                	jne    108e <stridethreadmain+0xe>
    while(*flag == 1){
      for (t = 0; t < 5; t++);
      __sync_fetch_and_add(&gcnt, 1);
    }
  }
  thread_exit(0);
    10be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10c5:	e8 44 06 00 00       	call   170e <thread_exit>

000010ca <stridetest1>:
}

int
stridetest1(void)
{
    10ca:	55                   	push   %ebp
    10cb:	89 e5                	mov    %esp,%ebp
    10cd:	83 ec 58             	sub    $0x58,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
    10d0:	c7 05 9c 24 00 00 00 	movl   $0x0,0x249c
    10d7:	00 00 00 
  flag = 2;
    10da:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
  if ((pid = fork()) == -1){
    10e1:	e8 50 05 00 00       	call   1636 <fork>
    10e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    10e9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    10ed:	75 19                	jne    1108 <stridetest1+0x3e>
    printf(1, "panic at fork in forktest\n");
    10ef:	c7 44 24 04 0e 1d 00 	movl   $0x1d0e,0x4(%esp)
    10f6:	00 
    10f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fe:	e8 fb 06 00 00       	call   17fe <printf>
    exit();
    1103:	e8 36 05 00 00       	call   163e <exit>
  } else if (pid == 0){
    1108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    110c:	75 0e                	jne    111c <stridetest1+0x52>
    set_cpu_share(50);
    110e:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
    1115:	e8 e4 05 00 00       	call   16fe <set_cpu_share>
    111a:	eb 0c                	jmp    1128 <stridetest1+0x5e>
  } else{
    set_cpu_share(10);
    111c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
    1123:	e8 d6 05 00 00       	call   16fe <set_cpu_share>
  }

  for (i = 0; i < NUM_THREAD; i++){
    1128:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    112f:	eb 48                	jmp    1179 <stridetest1+0xaf>
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
    1131:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1134:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1137:	c1 e2 02             	shl    $0x2,%edx
    113a:	01 c2                	add    %eax,%edx
    113c:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    113f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1143:	c7 44 24 04 80 10 00 	movl   $0x1080,0x4(%esp)
    114a:	00 
    114b:	89 14 24             	mov    %edx,(%esp)
    114e:	e8 b3 05 00 00       	call   1706 <thread_create>
    1153:	85 c0                	test   %eax,%eax
    1155:	74 1e                	je     1175 <stridetest1+0xab>
      printf(1, "panic at thread_create\n");
    1157:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
    115e:	00 
    115f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1166:	e8 93 06 00 00       	call   17fe <printf>
      return -1;
    116b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1170:	e9 d9 00 00 00       	jmp    124e <stridetest1+0x184>
    set_cpu_share(50);
  } else{
    set_cpu_share(10);
  }

  for (i = 0; i < NUM_THREAD; i++){
    1175:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1179:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    117d:	7e b2                	jle    1131 <stridetest1+0x67>
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  flag = 1;
    117f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  sleep(500);
    1186:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    118d:	e8 44 05 00 00       	call   16d6 <sleep>
  flag = 0;
    1192:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  for (i = 0; i < NUM_THREAD; i++){
    1199:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11a0:	eb 39                	jmp    11db <stridetest1+0x111>
    if (thread_join(threads[i], &retval) != 0){
    11a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11a5:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    11a9:	8d 55 c0             	lea    -0x40(%ebp),%edx
    11ac:	89 54 24 04          	mov    %edx,0x4(%esp)
    11b0:	89 04 24             	mov    %eax,(%esp)
    11b3:	e8 5e 05 00 00       	call   1716 <thread_join>
    11b8:	85 c0                	test   %eax,%eax
    11ba:	74 1b                	je     11d7 <stridetest1+0x10d>
      printf(1, "panic at thread_join\n");
    11bc:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
    11c3:	00 
    11c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11cb:	e8 2e 06 00 00       	call   17fe <printf>
      return -1;
    11d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11d5:	eb 77                	jmp    124e <stridetest1+0x184>
    }
  }
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    11d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    11db:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11df:	7e c1                	jle    11a2 <stridetest1+0xd8>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
    11e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11e5:	75 22                	jne    1209 <stridetest1+0x13f>
    printf(1, "50% : %d\n", gcnt);
    11e7:	a1 9c 24 00 00       	mov    0x249c,%eax
    11ec:	89 44 24 08          	mov    %eax,0x8(%esp)
    11f0:	c7 44 24 04 26 1e 00 	movl   $0x1e26,0x4(%esp)
    11f7:	00 
    11f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11ff:	e8 fa 05 00 00       	call   17fe <printf>
    exit();
    1204:	e8 35 04 00 00       	call   163e <exit>
  } else{
    printf(1, "10% : %d\n", gcnt);
    1209:	a1 9c 24 00 00       	mov    0x249c,%eax
    120e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1212:	c7 44 24 04 30 1e 00 	movl   $0x1e30,0x4(%esp)
    1219:	00 
    121a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1221:	e8 d8 05 00 00       	call   17fe <printf>
    if (wait() == -1){
    1226:	e8 1b 04 00 00       	call   1646 <wait>
    122b:	83 f8 ff             	cmp    $0xffffffff,%eax
    122e:	75 19                	jne    1249 <stridetest1+0x17f>
      printf(1, "panic at wait in forktest\n");
    1230:	c7 44 24 04 38 1d 00 	movl   $0x1d38,0x4(%esp)
    1237:	00 
    1238:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    123f:	e8 ba 05 00 00       	call   17fe <printf>
      exit();
    1244:	e8 f5 03 00 00       	call   163e <exit>
    }
  }

  return 0;
    1249:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124e:	c9                   	leave  
    124f:	c3                   	ret    

00001250 <stridetest2>:

int
stridetest2(void)
{
    1250:	55                   	push   %ebp
    1251:	89 e5                	mov    %esp,%ebp
    1253:	83 ec 58             	sub    $0x58,%esp
  int i;
  int pid;
  int flag;
  void *retval;

  gcnt = 0;
    1256:	c7 05 9c 24 00 00 00 	movl   $0x0,0x249c
    125d:	00 00 00 
  flag = 2;
    1260:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
  if ((pid = fork()) == -1){
    1267:	e8 ca 03 00 00       	call   1636 <fork>
    126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    126f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
    1273:	75 19                	jne    128e <stridetest2+0x3e>
    printf(1, "panic at fork in forktest\n");
    1275:	c7 44 24 04 0e 1d 00 	movl   $0x1d0e,0x4(%esp)
    127c:	00 
    127d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1284:	e8 75 05 00 00       	call   17fe <printf>
    exit();
    1289:	e8 b0 03 00 00       	call   163e <exit>
  }

  for (i = 0; i < NUM_THREAD; i++){
    128e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1295:	eb 48                	jmp    12df <stridetest2+0x8f>
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
    1297:	8d 45 c8             	lea    -0x38(%ebp),%eax
    129a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    129d:	c1 e2 02             	shl    $0x2,%edx
    12a0:	01 c2                	add    %eax,%edx
    12a2:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    12a5:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a9:	c7 44 24 04 80 10 00 	movl   $0x1080,0x4(%esp)
    12b0:	00 
    12b1:	89 14 24             	mov    %edx,(%esp)
    12b4:	e8 4d 04 00 00       	call   1706 <thread_create>
    12b9:	85 c0                	test   %eax,%eax
    12bb:	74 1e                	je     12db <stridetest2+0x8b>
      printf(1, "panic at thread_create\n");
    12bd:	c7 44 24 04 a6 1c 00 	movl   $0x1ca6,0x4(%esp)
    12c4:	00 
    12c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12cc:	e8 2d 05 00 00       	call   17fe <printf>
      return -1;
    12d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12d6:	e9 f9 00 00 00       	jmp    13d4 <stridetest2+0x184>
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
    exit();
  }

  for (i = 0; i < NUM_THREAD; i++){
    12db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    12df:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    12e3:	7e b2                	jle    1297 <stridetest2+0x47>
    if (thread_create(&threads[i], stridethreadmain, (void*)&flag) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  if (pid == 0){
    12e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    12e9:	75 0e                	jne    12f9 <stridetest2+0xa9>
    set_cpu_share(60);
    12eb:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
    12f2:	e8 07 04 00 00       	call   16fe <set_cpu_share>
    12f7:	eb 0c                	jmp    1305 <stridetest2+0xb5>
  } else{
    set_cpu_share(20);
    12f9:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
    1300:	e8 f9 03 00 00       	call   16fe <set_cpu_share>
  }
  flag = 1;
    1305:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  sleep(500);
    130c:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    1313:	e8 be 03 00 00       	call   16d6 <sleep>
  flag = 0;
    1318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  for (i = 0; i < NUM_THREAD; i++){
    131f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1326:	eb 39                	jmp    1361 <stridetest2+0x111>
    if (thread_join(threads[i], &retval) != 0){
    1328:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132b:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    132f:	8d 55 c0             	lea    -0x40(%ebp),%edx
    1332:	89 54 24 04          	mov    %edx,0x4(%esp)
    1336:	89 04 24             	mov    %eax,(%esp)
    1339:	e8 d8 03 00 00       	call   1716 <thread_join>
    133e:	85 c0                	test   %eax,%eax
    1340:	74 1b                	je     135d <stridetest2+0x10d>
      printf(1, "panic at thread_join\n");
    1342:	c7 44 24 04 be 1c 00 	movl   $0x1cbe,0x4(%esp)
    1349:	00 
    134a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1351:	e8 a8 04 00 00       	call   17fe <printf>
      return -1;
    1356:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    135b:	eb 77                	jmp    13d4 <stridetest2+0x184>
    set_cpu_share(20);
  }
  flag = 1;
  sleep(500);
  flag = 0;
  for (i = 0; i < NUM_THREAD; i++){
    135d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1361:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1365:	7e c1                	jle    1328 <stridetest2+0xd8>
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }

  if (pid == 0){
    1367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    136b:	75 22                	jne    138f <stridetest2+0x13f>
    printf(1, "60% : %d\n", gcnt);
    136d:	a1 9c 24 00 00       	mov    0x249c,%eax
    1372:	89 44 24 08          	mov    %eax,0x8(%esp)
    1376:	c7 44 24 04 3a 1e 00 	movl   $0x1e3a,0x4(%esp)
    137d:	00 
    137e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1385:	e8 74 04 00 00       	call   17fe <printf>
    exit();
    138a:	e8 af 02 00 00       	call   163e <exit>
  } else{
    printf(1, "20% : %d\n", gcnt);
    138f:	a1 9c 24 00 00       	mov    0x249c,%eax
    1394:	89 44 24 08          	mov    %eax,0x8(%esp)
    1398:	c7 44 24 04 44 1e 00 	movl   $0x1e44,0x4(%esp)
    139f:	00 
    13a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13a7:	e8 52 04 00 00       	call   17fe <printf>
    if (wait() == -1){
    13ac:	e8 95 02 00 00       	call   1646 <wait>
    13b1:	83 f8 ff             	cmp    $0xffffffff,%eax
    13b4:	75 19                	jne    13cf <stridetest2+0x17f>
      printf(1, "panic at wait in forktest\n");
    13b6:	c7 44 24 04 38 1d 00 	movl   $0x1d38,0x4(%esp)
    13bd:	00 
    13be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13c5:	e8 34 04 00 00       	call   17fe <printf>
      exit();
    13ca:	e8 6f 02 00 00       	call   163e <exit>
    }
  }

  return 0;
    13cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13d4:	c9                   	leave  
    13d5:	c3                   	ret    

000013d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    13d6:	55                   	push   %ebp
    13d7:	89 e5                	mov    %esp,%ebp
    13d9:	57                   	push   %edi
    13da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    13db:	8b 4d 08             	mov    0x8(%ebp),%ecx
    13de:	8b 55 10             	mov    0x10(%ebp),%edx
    13e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e4:	89 cb                	mov    %ecx,%ebx
    13e6:	89 df                	mov    %ebx,%edi
    13e8:	89 d1                	mov    %edx,%ecx
    13ea:	fc                   	cld    
    13eb:	f3 aa                	rep stos %al,%es:(%edi)
    13ed:	89 ca                	mov    %ecx,%edx
    13ef:	89 fb                	mov    %edi,%ebx
    13f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
    13f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    13f7:	5b                   	pop    %ebx
    13f8:	5f                   	pop    %edi
    13f9:	5d                   	pop    %ebp
    13fa:	c3                   	ret    

000013fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    13fb:	55                   	push   %ebp
    13fc:	89 e5                	mov    %esp,%ebp
    13fe:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1401:	8b 45 08             	mov    0x8(%ebp),%eax
    1404:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1407:	90                   	nop
    1408:	8b 45 08             	mov    0x8(%ebp),%eax
    140b:	8d 50 01             	lea    0x1(%eax),%edx
    140e:	89 55 08             	mov    %edx,0x8(%ebp)
    1411:	8b 55 0c             	mov    0xc(%ebp),%edx
    1414:	8d 4a 01             	lea    0x1(%edx),%ecx
    1417:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    141a:	0f b6 12             	movzbl (%edx),%edx
    141d:	88 10                	mov    %dl,(%eax)
    141f:	0f b6 00             	movzbl (%eax),%eax
    1422:	84 c0                	test   %al,%al
    1424:	75 e2                	jne    1408 <strcpy+0xd>
    ;
  return os;
    1426:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1429:	c9                   	leave  
    142a:	c3                   	ret    

0000142b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    142b:	55                   	push   %ebp
    142c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    142e:	eb 08                	jmp    1438 <strcmp+0xd>
    p++, q++;
    1430:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1434:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1438:	8b 45 08             	mov    0x8(%ebp),%eax
    143b:	0f b6 00             	movzbl (%eax),%eax
    143e:	84 c0                	test   %al,%al
    1440:	74 10                	je     1452 <strcmp+0x27>
    1442:	8b 45 08             	mov    0x8(%ebp),%eax
    1445:	0f b6 10             	movzbl (%eax),%edx
    1448:	8b 45 0c             	mov    0xc(%ebp),%eax
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	38 c2                	cmp    %al,%dl
    1450:	74 de                	je     1430 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1452:	8b 45 08             	mov    0x8(%ebp),%eax
    1455:	0f b6 00             	movzbl (%eax),%eax
    1458:	0f b6 d0             	movzbl %al,%edx
    145b:	8b 45 0c             	mov    0xc(%ebp),%eax
    145e:	0f b6 00             	movzbl (%eax),%eax
    1461:	0f b6 c0             	movzbl %al,%eax
    1464:	29 c2                	sub    %eax,%edx
    1466:	89 d0                	mov    %edx,%eax
}
    1468:	5d                   	pop    %ebp
    1469:	c3                   	ret    

0000146a <strlen>:

uint
strlen(char *s)
{
    146a:	55                   	push   %ebp
    146b:	89 e5                	mov    %esp,%ebp
    146d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1477:	eb 04                	jmp    147d <strlen+0x13>
    1479:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1480:	8b 45 08             	mov    0x8(%ebp),%eax
    1483:	01 d0                	add    %edx,%eax
    1485:	0f b6 00             	movzbl (%eax),%eax
    1488:	84 c0                	test   %al,%al
    148a:	75 ed                	jne    1479 <strlen+0xf>
    ;
  return n;
    148c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    148f:	c9                   	leave  
    1490:	c3                   	ret    

00001491 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1491:	55                   	push   %ebp
    1492:	89 e5                	mov    %esp,%ebp
    1494:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1497:	8b 45 10             	mov    0x10(%ebp),%eax
    149a:	89 44 24 08          	mov    %eax,0x8(%esp)
    149e:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a5:	8b 45 08             	mov    0x8(%ebp),%eax
    14a8:	89 04 24             	mov    %eax,(%esp)
    14ab:	e8 26 ff ff ff       	call   13d6 <stosb>
  return dst;
    14b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14b3:	c9                   	leave  
    14b4:	c3                   	ret    

000014b5 <strchr>:

char*
strchr(const char *s, char c)
{
    14b5:	55                   	push   %ebp
    14b6:	89 e5                	mov    %esp,%ebp
    14b8:	83 ec 04             	sub    $0x4,%esp
    14bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    14be:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    14c1:	eb 14                	jmp    14d7 <strchr+0x22>
    if(*s == c)
    14c3:	8b 45 08             	mov    0x8(%ebp),%eax
    14c6:	0f b6 00             	movzbl (%eax),%eax
    14c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
    14cc:	75 05                	jne    14d3 <strchr+0x1e>
      return (char*)s;
    14ce:	8b 45 08             	mov    0x8(%ebp),%eax
    14d1:	eb 13                	jmp    14e6 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    14d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    14d7:	8b 45 08             	mov    0x8(%ebp),%eax
    14da:	0f b6 00             	movzbl (%eax),%eax
    14dd:	84 c0                	test   %al,%al
    14df:	75 e2                	jne    14c3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    14e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    14e6:	c9                   	leave  
    14e7:	c3                   	ret    

000014e8 <gets>:

char*
gets(char *buf, int max)
{
    14e8:	55                   	push   %ebp
    14e9:	89 e5                	mov    %esp,%ebp
    14eb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    14f5:	eb 4c                	jmp    1543 <gets+0x5b>
    cc = read(0, &c, 1);
    14f7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14fe:	00 
    14ff:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1502:	89 44 24 04          	mov    %eax,0x4(%esp)
    1506:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    150d:	e8 44 01 00 00       	call   1656 <read>
    1512:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1519:	7f 02                	jg     151d <gets+0x35>
      break;
    151b:	eb 31                	jmp    154e <gets+0x66>
    buf[i++] = c;
    151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1520:	8d 50 01             	lea    0x1(%eax),%edx
    1523:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1526:	89 c2                	mov    %eax,%edx
    1528:	8b 45 08             	mov    0x8(%ebp),%eax
    152b:	01 c2                	add    %eax,%edx
    152d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1531:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1533:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1537:	3c 0a                	cmp    $0xa,%al
    1539:	74 13                	je     154e <gets+0x66>
    153b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    153f:	3c 0d                	cmp    $0xd,%al
    1541:	74 0b                	je     154e <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1546:	83 c0 01             	add    $0x1,%eax
    1549:	3b 45 0c             	cmp    0xc(%ebp),%eax
    154c:	7c a9                	jl     14f7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    154e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1551:	8b 45 08             	mov    0x8(%ebp),%eax
    1554:	01 d0                	add    %edx,%eax
    1556:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1559:	8b 45 08             	mov    0x8(%ebp),%eax
}
    155c:	c9                   	leave  
    155d:	c3                   	ret    

0000155e <stat>:

int
stat(char *n, struct stat *st)
{
    155e:	55                   	push   %ebp
    155f:	89 e5                	mov    %esp,%ebp
    1561:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1564:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    156b:	00 
    156c:	8b 45 08             	mov    0x8(%ebp),%eax
    156f:	89 04 24             	mov    %eax,(%esp)
    1572:	e8 07 01 00 00       	call   167e <open>
    1577:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    157a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157e:	79 07                	jns    1587 <stat+0x29>
    return -1;
    1580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1585:	eb 23                	jmp    15aa <stat+0x4c>
  r = fstat(fd, st);
    1587:	8b 45 0c             	mov    0xc(%ebp),%eax
    158a:	89 44 24 04          	mov    %eax,0x4(%esp)
    158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1591:	89 04 24             	mov    %eax,(%esp)
    1594:	e8 fd 00 00 00       	call   1696 <fstat>
    1599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    159c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    159f:	89 04 24             	mov    %eax,(%esp)
    15a2:	e8 bf 00 00 00       	call   1666 <close>
  return r;
    15a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    15aa:	c9                   	leave  
    15ab:	c3                   	ret    

000015ac <atoi>:

int
atoi(const char *s)
{
    15ac:	55                   	push   %ebp
    15ad:	89 e5                	mov    %esp,%ebp
    15af:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    15b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    15b9:	eb 25                	jmp    15e0 <atoi+0x34>
    n = n*10 + *s++ - '0';
    15bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
    15be:	89 d0                	mov    %edx,%eax
    15c0:	c1 e0 02             	shl    $0x2,%eax
    15c3:	01 d0                	add    %edx,%eax
    15c5:	01 c0                	add    %eax,%eax
    15c7:	89 c1                	mov    %eax,%ecx
    15c9:	8b 45 08             	mov    0x8(%ebp),%eax
    15cc:	8d 50 01             	lea    0x1(%eax),%edx
    15cf:	89 55 08             	mov    %edx,0x8(%ebp)
    15d2:	0f b6 00             	movzbl (%eax),%eax
    15d5:	0f be c0             	movsbl %al,%eax
    15d8:	01 c8                	add    %ecx,%eax
    15da:	83 e8 30             	sub    $0x30,%eax
    15dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    15e0:	8b 45 08             	mov    0x8(%ebp),%eax
    15e3:	0f b6 00             	movzbl (%eax),%eax
    15e6:	3c 2f                	cmp    $0x2f,%al
    15e8:	7e 0a                	jle    15f4 <atoi+0x48>
    15ea:	8b 45 08             	mov    0x8(%ebp),%eax
    15ed:	0f b6 00             	movzbl (%eax),%eax
    15f0:	3c 39                	cmp    $0x39,%al
    15f2:	7e c7                	jle    15bb <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    15f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    15f7:	c9                   	leave  
    15f8:	c3                   	ret    

000015f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    15f9:	55                   	push   %ebp
    15fa:	89 e5                	mov    %esp,%ebp
    15fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    15ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1602:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1605:	8b 45 0c             	mov    0xc(%ebp),%eax
    1608:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    160b:	eb 17                	jmp    1624 <memmove+0x2b>
    *dst++ = *src++;
    160d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1610:	8d 50 01             	lea    0x1(%eax),%edx
    1613:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1616:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1619:	8d 4a 01             	lea    0x1(%edx),%ecx
    161c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    161f:	0f b6 12             	movzbl (%edx),%edx
    1622:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1624:	8b 45 10             	mov    0x10(%ebp),%eax
    1627:	8d 50 ff             	lea    -0x1(%eax),%edx
    162a:	89 55 10             	mov    %edx,0x10(%ebp)
    162d:	85 c0                	test   %eax,%eax
    162f:	7f dc                	jg     160d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1631:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1634:	c9                   	leave  
    1635:	c3                   	ret    

00001636 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1636:	b8 01 00 00 00       	mov    $0x1,%eax
    163b:	cd 40                	int    $0x40
    163d:	c3                   	ret    

0000163e <exit>:
SYSCALL(exit)
    163e:	b8 02 00 00 00       	mov    $0x2,%eax
    1643:	cd 40                	int    $0x40
    1645:	c3                   	ret    

00001646 <wait>:
SYSCALL(wait)
    1646:	b8 03 00 00 00       	mov    $0x3,%eax
    164b:	cd 40                	int    $0x40
    164d:	c3                   	ret    

0000164e <pipe>:
SYSCALL(pipe)
    164e:	b8 04 00 00 00       	mov    $0x4,%eax
    1653:	cd 40                	int    $0x40
    1655:	c3                   	ret    

00001656 <read>:
SYSCALL(read)
    1656:	b8 05 00 00 00       	mov    $0x5,%eax
    165b:	cd 40                	int    $0x40
    165d:	c3                   	ret    

0000165e <write>:
SYSCALL(write)
    165e:	b8 10 00 00 00       	mov    $0x10,%eax
    1663:	cd 40                	int    $0x40
    1665:	c3                   	ret    

00001666 <close>:
SYSCALL(close)
    1666:	b8 15 00 00 00       	mov    $0x15,%eax
    166b:	cd 40                	int    $0x40
    166d:	c3                   	ret    

0000166e <kill>:
SYSCALL(kill)
    166e:	b8 06 00 00 00       	mov    $0x6,%eax
    1673:	cd 40                	int    $0x40
    1675:	c3                   	ret    

00001676 <exec>:
SYSCALL(exec)
    1676:	b8 07 00 00 00       	mov    $0x7,%eax
    167b:	cd 40                	int    $0x40
    167d:	c3                   	ret    

0000167e <open>:
SYSCALL(open)
    167e:	b8 0f 00 00 00       	mov    $0xf,%eax
    1683:	cd 40                	int    $0x40
    1685:	c3                   	ret    

00001686 <mknod>:
SYSCALL(mknod)
    1686:	b8 11 00 00 00       	mov    $0x11,%eax
    168b:	cd 40                	int    $0x40
    168d:	c3                   	ret    

0000168e <unlink>:
SYSCALL(unlink)
    168e:	b8 12 00 00 00       	mov    $0x12,%eax
    1693:	cd 40                	int    $0x40
    1695:	c3                   	ret    

00001696 <fstat>:
SYSCALL(fstat)
    1696:	b8 08 00 00 00       	mov    $0x8,%eax
    169b:	cd 40                	int    $0x40
    169d:	c3                   	ret    

0000169e <link>:
SYSCALL(link)
    169e:	b8 13 00 00 00       	mov    $0x13,%eax
    16a3:	cd 40                	int    $0x40
    16a5:	c3                   	ret    

000016a6 <mkdir>:
SYSCALL(mkdir)
    16a6:	b8 14 00 00 00       	mov    $0x14,%eax
    16ab:	cd 40                	int    $0x40
    16ad:	c3                   	ret    

000016ae <chdir>:
SYSCALL(chdir)
    16ae:	b8 09 00 00 00       	mov    $0x9,%eax
    16b3:	cd 40                	int    $0x40
    16b5:	c3                   	ret    

000016b6 <dup>:
SYSCALL(dup)
    16b6:	b8 0a 00 00 00       	mov    $0xa,%eax
    16bb:	cd 40                	int    $0x40
    16bd:	c3                   	ret    

000016be <getpid>:
SYSCALL(getpid)
    16be:	b8 0b 00 00 00       	mov    $0xb,%eax
    16c3:	cd 40                	int    $0x40
    16c5:	c3                   	ret    

000016c6 <getppid>:
SYSCALL(getppid)
    16c6:	b8 17 00 00 00       	mov    $0x17,%eax
    16cb:	cd 40                	int    $0x40
    16cd:	c3                   	ret    

000016ce <sbrk>:
SYSCALL(sbrk)
    16ce:	b8 0c 00 00 00       	mov    $0xc,%eax
    16d3:	cd 40                	int    $0x40
    16d5:	c3                   	ret    

000016d6 <sleep>:
SYSCALL(sleep)
    16d6:	b8 0d 00 00 00       	mov    $0xd,%eax
    16db:	cd 40                	int    $0x40
    16dd:	c3                   	ret    

000016de <uptime>:
SYSCALL(uptime)
    16de:	b8 0e 00 00 00       	mov    $0xe,%eax
    16e3:	cd 40                	int    $0x40
    16e5:	c3                   	ret    

000016e6 <my_syscall>:
SYSCALL(my_syscall)
    16e6:	b8 16 00 00 00       	mov    $0x16,%eax
    16eb:	cd 40                	int    $0x40
    16ed:	c3                   	ret    

000016ee <yield>:
SYSCALL(yield)
    16ee:	b8 18 00 00 00       	mov    $0x18,%eax
    16f3:	cd 40                	int    $0x40
    16f5:	c3                   	ret    

000016f6 <getlev>:
SYSCALL(getlev)
    16f6:	b8 19 00 00 00       	mov    $0x19,%eax
    16fb:	cd 40                	int    $0x40
    16fd:	c3                   	ret    

000016fe <set_cpu_share>:
SYSCALL(set_cpu_share)
    16fe:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1703:	cd 40                	int    $0x40
    1705:	c3                   	ret    

00001706 <thread_create>:
SYSCALL(thread_create)
    1706:	b8 1b 00 00 00       	mov    $0x1b,%eax
    170b:	cd 40                	int    $0x40
    170d:	c3                   	ret    

0000170e <thread_exit>:
SYSCALL(thread_exit)
    170e:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1713:	cd 40                	int    $0x40
    1715:	c3                   	ret    

00001716 <thread_join>:
SYSCALL(thread_join)
    1716:	b8 1d 00 00 00       	mov    $0x1d,%eax
    171b:	cd 40                	int    $0x40
    171d:	c3                   	ret    

0000171e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    171e:	55                   	push   %ebp
    171f:	89 e5                	mov    %esp,%ebp
    1721:	83 ec 18             	sub    $0x18,%esp
    1724:	8b 45 0c             	mov    0xc(%ebp),%eax
    1727:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    172a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1731:	00 
    1732:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1735:	89 44 24 04          	mov    %eax,0x4(%esp)
    1739:	8b 45 08             	mov    0x8(%ebp),%eax
    173c:	89 04 24             	mov    %eax,(%esp)
    173f:	e8 1a ff ff ff       	call   165e <write>
}
    1744:	c9                   	leave  
    1745:	c3                   	ret    

00001746 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1746:	55                   	push   %ebp
    1747:	89 e5                	mov    %esp,%ebp
    1749:	56                   	push   %esi
    174a:	53                   	push   %ebx
    174b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    174e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1755:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1759:	74 17                	je     1772 <printint+0x2c>
    175b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    175f:	79 11                	jns    1772 <printint+0x2c>
    neg = 1;
    1761:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1768:	8b 45 0c             	mov    0xc(%ebp),%eax
    176b:	f7 d8                	neg    %eax
    176d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1770:	eb 06                	jmp    1778 <printint+0x32>
  } else {
    x = xx;
    1772:	8b 45 0c             	mov    0xc(%ebp),%eax
    1775:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    177f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1782:	8d 41 01             	lea    0x1(%ecx),%eax
    1785:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1788:	8b 5d 10             	mov    0x10(%ebp),%ebx
    178b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    178e:	ba 00 00 00 00       	mov    $0x0,%edx
    1793:	f7 f3                	div    %ebx
    1795:	89 d0                	mov    %edx,%eax
    1797:	0f b6 80 7c 24 00 00 	movzbl 0x247c(%eax),%eax
    179e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    17a2:	8b 75 10             	mov    0x10(%ebp),%esi
    17a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17a8:	ba 00 00 00 00       	mov    $0x0,%edx
    17ad:	f7 f6                	div    %esi
    17af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    17b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17b6:	75 c7                	jne    177f <printint+0x39>
  if(neg)
    17b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17bc:	74 10                	je     17ce <printint+0x88>
    buf[i++] = '-';
    17be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c1:	8d 50 01             	lea    0x1(%eax),%edx
    17c4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    17c7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    17cc:	eb 1f                	jmp    17ed <printint+0xa7>
    17ce:	eb 1d                	jmp    17ed <printint+0xa7>
    putc(fd, buf[i]);
    17d0:	8d 55 dc             	lea    -0x24(%ebp),%edx
    17d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d6:	01 d0                	add    %edx,%eax
    17d8:	0f b6 00             	movzbl (%eax),%eax
    17db:	0f be c0             	movsbl %al,%eax
    17de:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e2:	8b 45 08             	mov    0x8(%ebp),%eax
    17e5:	89 04 24             	mov    %eax,(%esp)
    17e8:	e8 31 ff ff ff       	call   171e <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    17ed:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    17f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17f5:	79 d9                	jns    17d0 <printint+0x8a>
    putc(fd, buf[i]);
}
    17f7:	83 c4 30             	add    $0x30,%esp
    17fa:	5b                   	pop    %ebx
    17fb:	5e                   	pop    %esi
    17fc:	5d                   	pop    %ebp
    17fd:	c3                   	ret    

000017fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    17fe:	55                   	push   %ebp
    17ff:	89 e5                	mov    %esp,%ebp
    1801:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1804:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    180b:	8d 45 0c             	lea    0xc(%ebp),%eax
    180e:	83 c0 04             	add    $0x4,%eax
    1811:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1814:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    181b:	e9 7c 01 00 00       	jmp    199c <printf+0x19e>
    c = fmt[i] & 0xff;
    1820:	8b 55 0c             	mov    0xc(%ebp),%edx
    1823:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1826:	01 d0                	add    %edx,%eax
    1828:	0f b6 00             	movzbl (%eax),%eax
    182b:	0f be c0             	movsbl %al,%eax
    182e:	25 ff 00 00 00       	and    $0xff,%eax
    1833:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1836:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    183a:	75 2c                	jne    1868 <printf+0x6a>
      if(c == '%'){
    183c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1840:	75 0c                	jne    184e <printf+0x50>
        state = '%';
    1842:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1849:	e9 4a 01 00 00       	jmp    1998 <printf+0x19a>
      } else {
        putc(fd, c);
    184e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1851:	0f be c0             	movsbl %al,%eax
    1854:	89 44 24 04          	mov    %eax,0x4(%esp)
    1858:	8b 45 08             	mov    0x8(%ebp),%eax
    185b:	89 04 24             	mov    %eax,(%esp)
    185e:	e8 bb fe ff ff       	call   171e <putc>
    1863:	e9 30 01 00 00       	jmp    1998 <printf+0x19a>
      }
    } else if(state == '%'){
    1868:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    186c:	0f 85 26 01 00 00    	jne    1998 <printf+0x19a>
      if(c == 'd'){
    1872:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1876:	75 2d                	jne    18a5 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1878:	8b 45 e8             	mov    -0x18(%ebp),%eax
    187b:	8b 00                	mov    (%eax),%eax
    187d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1884:	00 
    1885:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    188c:	00 
    188d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1891:	8b 45 08             	mov    0x8(%ebp),%eax
    1894:	89 04 24             	mov    %eax,(%esp)
    1897:	e8 aa fe ff ff       	call   1746 <printint>
        ap++;
    189c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18a0:	e9 ec 00 00 00       	jmp    1991 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    18a5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    18a9:	74 06                	je     18b1 <printf+0xb3>
    18ab:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    18af:	75 2d                	jne    18de <printf+0xe0>
        printint(fd, *ap, 16, 0);
    18b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18b4:	8b 00                	mov    (%eax),%eax
    18b6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18bd:	00 
    18be:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18c5:	00 
    18c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ca:	8b 45 08             	mov    0x8(%ebp),%eax
    18cd:	89 04 24             	mov    %eax,(%esp)
    18d0:	e8 71 fe ff ff       	call   1746 <printint>
        ap++;
    18d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18d9:	e9 b3 00 00 00       	jmp    1991 <printf+0x193>
      } else if(c == 's'){
    18de:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    18e2:	75 45                	jne    1929 <printf+0x12b>
        s = (char*)*ap;
    18e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18e7:	8b 00                	mov    (%eax),%eax
    18e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    18ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    18f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18f4:	75 09                	jne    18ff <printf+0x101>
          s = "(null)";
    18f6:	c7 45 f4 4e 1e 00 00 	movl   $0x1e4e,-0xc(%ebp)
        while(*s != 0){
    18fd:	eb 1e                	jmp    191d <printf+0x11f>
    18ff:	eb 1c                	jmp    191d <printf+0x11f>
          putc(fd, *s);
    1901:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1904:	0f b6 00             	movzbl (%eax),%eax
    1907:	0f be c0             	movsbl %al,%eax
    190a:	89 44 24 04          	mov    %eax,0x4(%esp)
    190e:	8b 45 08             	mov    0x8(%ebp),%eax
    1911:	89 04 24             	mov    %eax,(%esp)
    1914:	e8 05 fe ff ff       	call   171e <putc>
          s++;
    1919:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1920:	0f b6 00             	movzbl (%eax),%eax
    1923:	84 c0                	test   %al,%al
    1925:	75 da                	jne    1901 <printf+0x103>
    1927:	eb 68                	jmp    1991 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1929:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    192d:	75 1d                	jne    194c <printf+0x14e>
        putc(fd, *ap);
    192f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1932:	8b 00                	mov    (%eax),%eax
    1934:	0f be c0             	movsbl %al,%eax
    1937:	89 44 24 04          	mov    %eax,0x4(%esp)
    193b:	8b 45 08             	mov    0x8(%ebp),%eax
    193e:	89 04 24             	mov    %eax,(%esp)
    1941:	e8 d8 fd ff ff       	call   171e <putc>
        ap++;
    1946:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    194a:	eb 45                	jmp    1991 <printf+0x193>
      } else if(c == '%'){
    194c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1950:	75 17                	jne    1969 <printf+0x16b>
        putc(fd, c);
    1952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1955:	0f be c0             	movsbl %al,%eax
    1958:	89 44 24 04          	mov    %eax,0x4(%esp)
    195c:	8b 45 08             	mov    0x8(%ebp),%eax
    195f:	89 04 24             	mov    %eax,(%esp)
    1962:	e8 b7 fd ff ff       	call   171e <putc>
    1967:	eb 28                	jmp    1991 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1969:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1970:	00 
    1971:	8b 45 08             	mov    0x8(%ebp),%eax
    1974:	89 04 24             	mov    %eax,(%esp)
    1977:	e8 a2 fd ff ff       	call   171e <putc>
        putc(fd, c);
    197c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    197f:	0f be c0             	movsbl %al,%eax
    1982:	89 44 24 04          	mov    %eax,0x4(%esp)
    1986:	8b 45 08             	mov    0x8(%ebp),%eax
    1989:	89 04 24             	mov    %eax,(%esp)
    198c:	e8 8d fd ff ff       	call   171e <putc>
      }
      state = 0;
    1991:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1998:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    199c:	8b 55 0c             	mov    0xc(%ebp),%edx
    199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19a2:	01 d0                	add    %edx,%eax
    19a4:	0f b6 00             	movzbl (%eax),%eax
    19a7:	84 c0                	test   %al,%al
    19a9:	0f 85 71 fe ff ff    	jne    1820 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    19af:	c9                   	leave  
    19b0:	c3                   	ret    

000019b1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    19b1:	55                   	push   %ebp
    19b2:	89 e5                	mov    %esp,%ebp
    19b4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    19b7:	8b 45 08             	mov    0x8(%ebp),%eax
    19ba:	83 e8 08             	sub    $0x8,%eax
    19bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19c0:	a1 98 24 00 00       	mov    0x2498,%eax
    19c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19c8:	eb 24                	jmp    19ee <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19cd:	8b 00                	mov    (%eax),%eax
    19cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19d2:	77 12                	ja     19e6 <free+0x35>
    19d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19da:	77 24                	ja     1a00 <free+0x4f>
    19dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19df:	8b 00                	mov    (%eax),%eax
    19e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19e4:	77 1a                	ja     1a00 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e9:	8b 00                	mov    (%eax),%eax
    19eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19f4:	76 d4                	jbe    19ca <free+0x19>
    19f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f9:	8b 00                	mov    (%eax),%eax
    19fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19fe:	76 ca                	jbe    19ca <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1a00:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a03:	8b 40 04             	mov    0x4(%eax),%eax
    1a06:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a10:	01 c2                	add    %eax,%edx
    1a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a15:	8b 00                	mov    (%eax),%eax
    1a17:	39 c2                	cmp    %eax,%edx
    1a19:	75 24                	jne    1a3f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a1e:	8b 50 04             	mov    0x4(%eax),%edx
    1a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a24:	8b 00                	mov    (%eax),%eax
    1a26:	8b 40 04             	mov    0x4(%eax),%eax
    1a29:	01 c2                	add    %eax,%edx
    1a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a2e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a34:	8b 00                	mov    (%eax),%eax
    1a36:	8b 10                	mov    (%eax),%edx
    1a38:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a3b:	89 10                	mov    %edx,(%eax)
    1a3d:	eb 0a                	jmp    1a49 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a42:	8b 10                	mov    (%eax),%edx
    1a44:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a47:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a4c:	8b 40 04             	mov    0x4(%eax),%eax
    1a4f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a59:	01 d0                	add    %edx,%eax
    1a5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a5e:	75 20                	jne    1a80 <free+0xcf>
    p->s.size += bp->s.size;
    1a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a63:	8b 50 04             	mov    0x4(%eax),%edx
    1a66:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a69:	8b 40 04             	mov    0x4(%eax),%eax
    1a6c:	01 c2                	add    %eax,%edx
    1a6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a71:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1a74:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a77:	8b 10                	mov    (%eax),%edx
    1a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a7c:	89 10                	mov    %edx,(%eax)
    1a7e:	eb 08                	jmp    1a88 <free+0xd7>
  } else
    p->s.ptr = bp;
    1a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a83:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1a86:	89 10                	mov    %edx,(%eax)
  freep = p;
    1a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a8b:	a3 98 24 00 00       	mov    %eax,0x2498
}
    1a90:	c9                   	leave  
    1a91:	c3                   	ret    

00001a92 <morecore>:

static Header*
morecore(uint nu)
{
    1a92:	55                   	push   %ebp
    1a93:	89 e5                	mov    %esp,%ebp
    1a95:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a98:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a9f:	77 07                	ja     1aa8 <morecore+0x16>
    nu = 4096;
    1aa1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1aa8:	8b 45 08             	mov    0x8(%ebp),%eax
    1aab:	c1 e0 03             	shl    $0x3,%eax
    1aae:	89 04 24             	mov    %eax,(%esp)
    1ab1:	e8 18 fc ff ff       	call   16ce <sbrk>
    1ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1ab9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1abd:	75 07                	jne    1ac6 <morecore+0x34>
    return 0;
    1abf:	b8 00 00 00 00       	mov    $0x0,%eax
    1ac4:	eb 22                	jmp    1ae8 <morecore+0x56>
  hp = (Header*)p;
    1ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1acf:	8b 55 08             	mov    0x8(%ebp),%edx
    1ad2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ad8:	83 c0 08             	add    $0x8,%eax
    1adb:	89 04 24             	mov    %eax,(%esp)
    1ade:	e8 ce fe ff ff       	call   19b1 <free>
  return freep;
    1ae3:	a1 98 24 00 00       	mov    0x2498,%eax
}
    1ae8:	c9                   	leave  
    1ae9:	c3                   	ret    

00001aea <malloc>:

void*
malloc(uint nbytes)
{
    1aea:	55                   	push   %ebp
    1aeb:	89 e5                	mov    %esp,%ebp
    1aed:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1af0:	8b 45 08             	mov    0x8(%ebp),%eax
    1af3:	83 c0 07             	add    $0x7,%eax
    1af6:	c1 e8 03             	shr    $0x3,%eax
    1af9:	83 c0 01             	add    $0x1,%eax
    1afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1aff:	a1 98 24 00 00       	mov    0x2498,%eax
    1b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b0b:	75 23                	jne    1b30 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1b0d:	c7 45 f0 90 24 00 00 	movl   $0x2490,-0x10(%ebp)
    1b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b17:	a3 98 24 00 00       	mov    %eax,0x2498
    1b1c:	a1 98 24 00 00       	mov    0x2498,%eax
    1b21:	a3 90 24 00 00       	mov    %eax,0x2490
    base.s.size = 0;
    1b26:	c7 05 94 24 00 00 00 	movl   $0x0,0x2494
    1b2d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b33:	8b 00                	mov    (%eax),%eax
    1b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b3b:	8b 40 04             	mov    0x4(%eax),%eax
    1b3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b41:	72 4d                	jb     1b90 <malloc+0xa6>
      if(p->s.size == nunits)
    1b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b46:	8b 40 04             	mov    0x4(%eax),%eax
    1b49:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b4c:	75 0c                	jne    1b5a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b51:	8b 10                	mov    (%eax),%edx
    1b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b56:	89 10                	mov    %edx,(%eax)
    1b58:	eb 26                	jmp    1b80 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b5d:	8b 40 04             	mov    0x4(%eax),%eax
    1b60:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1b63:	89 c2                	mov    %eax,%edx
    1b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b68:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b6e:	8b 40 04             	mov    0x4(%eax),%eax
    1b71:	c1 e0 03             	shl    $0x3,%eax
    1b74:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b7d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b83:	a3 98 24 00 00       	mov    %eax,0x2498
      return (void*)(p + 1);
    1b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8b:	83 c0 08             	add    $0x8,%eax
    1b8e:	eb 38                	jmp    1bc8 <malloc+0xde>
    }
    if(p == freep)
    1b90:	a1 98 24 00 00       	mov    0x2498,%eax
    1b95:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b98:	75 1b                	jne    1bb5 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b9d:	89 04 24             	mov    %eax,(%esp)
    1ba0:	e8 ed fe ff ff       	call   1a92 <morecore>
    1ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1bac:	75 07                	jne    1bb5 <malloc+0xcb>
        return 0;
    1bae:	b8 00 00 00 00       	mov    $0x0,%eax
    1bb3:	eb 13                	jmp    1bc8 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1bbe:	8b 00                	mov    (%eax),%eax
    1bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1bc3:	e9 70 ff ff ff       	jmp    1b38 <malloc+0x4e>
}
    1bc8:	c9                   	leave  
    1bc9:	c3                   	ret    
