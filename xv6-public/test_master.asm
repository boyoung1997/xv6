
_test_master:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  {NAME_CHILD_MLFQ, "1", 0},
};

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int i;

  for (i = 0; i < CNT_CHILD; i++) {
   9:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  10:	00 
  11:	e9 83 00 00 00       	jmp    99 <main+0x99>
    pid = fork();
  16:	e8 09 03 00 00       	call   324 <fork>
  1b:	89 44 24 18          	mov    %eax,0x18(%esp)
    if (pid > 0) {
  1f:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  24:	7e 07                	jle    2d <main+0x2d>
main(int argc, char *argv[])
{
  int pid;
  int i;

  for (i = 0; i < CNT_CHILD; i++) {
  26:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  2b:	eb 6c                	jmp    99 <main+0x99>
    pid = fork();
    if (pid > 0) {
      // parent
      continue;
    } else if (pid == 0) {
  2d:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  32:	75 4c                	jne    80 <main+0x80>
      // child
      exec(child_argv[i][0], child_argv[i]);
  34:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  38:	89 d0                	mov    %edx,%eax
  3a:	01 c0                	add    %eax,%eax
  3c:	01 d0                	add    %edx,%eax
  3e:	c1 e0 02             	shl    $0x2,%eax
  41:	8d 88 60 0b 00 00    	lea    0xb60(%eax),%ecx
  47:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  4b:	89 d0                	mov    %edx,%eax
  4d:	01 c0                	add    %eax,%eax
  4f:	01 d0                	add    %edx,%eax
  51:	c1 e0 02             	shl    $0x2,%eax
  54:	05 60 0b 00 00       	add    $0xb60,%eax
  59:	8b 00                	mov    (%eax),%eax
  5b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  5f:	89 04 24             	mov    %eax,(%esp)
  62:	e8 fd 02 00 00       	call   364 <exec>
      printf(1, "exec failed!!\n");
  67:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  76:	e8 71 04 00 00       	call   4ec <printf>
      exit();
  7b:	e8 ac 02 00 00       	call   32c <exit>
    } else {
      printf(1, "fork failed!!\n");
  80:	c7 44 24 04 e7 08 00 	movl   $0x8e7,0x4(%esp)
  87:	00 
  88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8f:	e8 58 04 00 00       	call   4ec <printf>
      exit();
  94:	e8 93 02 00 00       	call   32c <exit>
main(int argc, char *argv[])
{
  int pid;
  int i;

  for (i = 0; i < CNT_CHILD; i++) {
  99:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
  9e:	0f 8e 72 ff ff ff    	jle    16 <main+0x16>
      printf(1, "fork failed!!\n");
      exit();
    }
  }
  
  for (i = 0; i < CNT_CHILD; i++) {
  a4:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  ab:	00 
  ac:	eb 0a                	jmp    b8 <main+0xb8>
    wait();
  ae:	e8 81 02 00 00       	call   334 <wait>
      printf(1, "fork failed!!\n");
      exit();
    }
  }
  
  for (i = 0; i < CNT_CHILD; i++) {
  b3:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  b8:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
  bd:	7e ef                	jle    ae <main+0xae>
    wait();
  }

  exit();
  bf:	e8 68 02 00 00       	call   32c <exit>

000000c4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	57                   	push   %edi
  c8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  cc:	8b 55 10             	mov    0x10(%ebp),%edx
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	89 cb                	mov    %ecx,%ebx
  d4:	89 df                	mov    %ebx,%edi
  d6:	89 d1                	mov    %edx,%ecx
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  db:	89 ca                	mov    %ecx,%edx
  dd:	89 fb                	mov    %edi,%ebx
  df:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e5:	5b                   	pop    %ebx
  e6:	5f                   	pop    %edi
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    

000000e9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f5:	90                   	nop
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	8d 50 01             	lea    0x1(%eax),%edx
  fc:	89 55 08             	mov    %edx,0x8(%ebp)
  ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 102:	8d 4a 01             	lea    0x1(%edx),%ecx
 105:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 108:	0f b6 12             	movzbl (%edx),%edx
 10b:	88 10                	mov    %dl,(%eax)
 10d:	0f b6 00             	movzbl (%eax),%eax
 110:	84 c0                	test   %al,%al
 112:	75 e2                	jne    f6 <strcpy+0xd>
    ;
  return os;
 114:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 117:	c9                   	leave  
 118:	c3                   	ret    

00000119 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 11c:	eb 08                	jmp    126 <strcmp+0xd>
    p++, q++;
 11e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 122:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	84 c0                	test   %al,%al
 12e:	74 10                	je     140 <strcmp+0x27>
 130:	8b 45 08             	mov    0x8(%ebp),%eax
 133:	0f b6 10             	movzbl (%eax),%edx
 136:	8b 45 0c             	mov    0xc(%ebp),%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	38 c2                	cmp    %al,%dl
 13e:	74 de                	je     11e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	0f b6 d0             	movzbl %al,%edx
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	0f b6 c0             	movzbl %al,%eax
 152:	29 c2                	sub    %eax,%edx
 154:	89 d0                	mov    %edx,%eax
}
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    

00000158 <strlen>:

uint
strlen(char *s)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 165:	eb 04                	jmp    16b <strlen+0x13>
 167:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	01 d0                	add    %edx,%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	75 ed                	jne    167 <strlen+0xf>
    ;
  return n;
 17a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17d:	c9                   	leave  
 17e:	c3                   	ret    

0000017f <memset>:

void*
memset(void *dst, int c, uint n)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 185:	8b 45 10             	mov    0x10(%ebp),%eax
 188:	89 44 24 08          	mov    %eax,0x8(%esp)
 18c:	8b 45 0c             	mov    0xc(%ebp),%eax
 18f:	89 44 24 04          	mov    %eax,0x4(%esp)
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	89 04 24             	mov    %eax,(%esp)
 199:	e8 26 ff ff ff       	call   c4 <stosb>
  return dst;
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a1:	c9                   	leave  
 1a2:	c3                   	ret    

000001a3 <strchr>:

char*
strchr(const char *s, char c)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 04             	sub    $0x4,%esp
 1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ac:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1af:	eb 14                	jmp    1c5 <strchr+0x22>
    if(*s == c)
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ba:	75 05                	jne    1c1 <strchr+0x1e>
      return (char*)s;
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	eb 13                	jmp    1d4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	84 c0                	test   %al,%al
 1cd:	75 e2                	jne    1b1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e3:	eb 4c                	jmp    231 <gets+0x5b>
    cc = read(0, &c, 1);
 1e5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ec:	00 
 1ed:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1fb:	e8 44 01 00 00       	call   344 <read>
 200:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 203:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 207:	7f 02                	jg     20b <gets+0x35>
      break;
 209:	eb 31                	jmp    23c <gets+0x66>
    buf[i++] = c;
 20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	89 55 f4             	mov    %edx,-0xc(%ebp)
 214:	89 c2                	mov    %eax,%edx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	01 c2                	add    %eax,%edx
 21b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 21f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 221:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 225:	3c 0a                	cmp    $0xa,%al
 227:	74 13                	je     23c <gets+0x66>
 229:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22d:	3c 0d                	cmp    $0xd,%al
 22f:	74 0b                	je     23c <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	83 c0 01             	add    $0x1,%eax
 237:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23a:	7c a9                	jl     1e5 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 23c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	01 d0                	add    %edx,%eax
 244:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24a:	c9                   	leave  
 24b:	c3                   	ret    

0000024c <stat>:

int
stat(char *n, struct stat *st)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 252:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 259:	00 
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	89 04 24             	mov    %eax,(%esp)
 260:	e8 07 01 00 00       	call   36c <open>
 265:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 26c:	79 07                	jns    275 <stat+0x29>
    return -1;
 26e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 273:	eb 23                	jmp    298 <stat+0x4c>
  r = fstat(fd, st);
 275:	8b 45 0c             	mov    0xc(%ebp),%eax
 278:	89 44 24 04          	mov    %eax,0x4(%esp)
 27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27f:	89 04 24             	mov    %eax,(%esp)
 282:	e8 fd 00 00 00       	call   384 <fstat>
 287:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 bf 00 00 00       	call   354 <close>
  return r;
 295:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <atoi>:

int
atoi(const char *s)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2a7:	eb 25                	jmp    2ce <atoi+0x34>
    n = n*10 + *s++ - '0';
 2a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ac:	89 d0                	mov    %edx,%eax
 2ae:	c1 e0 02             	shl    $0x2,%eax
 2b1:	01 d0                	add    %edx,%eax
 2b3:	01 c0                	add    %eax,%eax
 2b5:	89 c1                	mov    %eax,%ecx
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	8d 50 01             	lea    0x1(%eax),%edx
 2bd:	89 55 08             	mov    %edx,0x8(%ebp)
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	0f be c0             	movsbl %al,%eax
 2c6:	01 c8                	add    %ecx,%eax
 2c8:	83 e8 30             	sub    $0x30,%eax
 2cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	3c 2f                	cmp    $0x2f,%al
 2d6:	7e 0a                	jle    2e2 <atoi+0x48>
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	3c 39                	cmp    $0x39,%al
 2e0:	7e c7                	jle    2a9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2f9:	eb 17                	jmp    312 <memmove+0x2b>
    *dst++ = *src++;
 2fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2fe:	8d 50 01             	lea    0x1(%eax),%edx
 301:	89 55 fc             	mov    %edx,-0x4(%ebp)
 304:	8b 55 f8             	mov    -0x8(%ebp),%edx
 307:	8d 4a 01             	lea    0x1(%edx),%ecx
 30a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 30d:	0f b6 12             	movzbl (%edx),%edx
 310:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 312:	8b 45 10             	mov    0x10(%ebp),%eax
 315:	8d 50 ff             	lea    -0x1(%eax),%edx
 318:	89 55 10             	mov    %edx,0x10(%ebp)
 31b:	85 c0                	test   %eax,%eax
 31d:	7f dc                	jg     2fb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 322:	c9                   	leave  
 323:	c3                   	ret    

00000324 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 324:	b8 01 00 00 00       	mov    $0x1,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <exit>:
SYSCALL(exit)
 32c:	b8 02 00 00 00       	mov    $0x2,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <wait>:
SYSCALL(wait)
 334:	b8 03 00 00 00       	mov    $0x3,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <pipe>:
SYSCALL(pipe)
 33c:	b8 04 00 00 00       	mov    $0x4,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <read>:
SYSCALL(read)
 344:	b8 05 00 00 00       	mov    $0x5,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <write>:
SYSCALL(write)
 34c:	b8 10 00 00 00       	mov    $0x10,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <close>:
SYSCALL(close)
 354:	b8 15 00 00 00       	mov    $0x15,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <kill>:
SYSCALL(kill)
 35c:	b8 06 00 00 00       	mov    $0x6,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <exec>:
SYSCALL(exec)
 364:	b8 07 00 00 00       	mov    $0x7,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <open>:
SYSCALL(open)
 36c:	b8 0f 00 00 00       	mov    $0xf,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <mknod>:
SYSCALL(mknod)
 374:	b8 11 00 00 00       	mov    $0x11,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <unlink>:
SYSCALL(unlink)
 37c:	b8 12 00 00 00       	mov    $0x12,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <fstat>:
SYSCALL(fstat)
 384:	b8 08 00 00 00       	mov    $0x8,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <link>:
SYSCALL(link)
 38c:	b8 13 00 00 00       	mov    $0x13,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <mkdir>:
SYSCALL(mkdir)
 394:	b8 14 00 00 00       	mov    $0x14,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <chdir>:
SYSCALL(chdir)
 39c:	b8 09 00 00 00       	mov    $0x9,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <dup>:
SYSCALL(dup)
 3a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <getpid>:
SYSCALL(getpid)
 3ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <getppid>:
SYSCALL(getppid)
 3b4:	b8 17 00 00 00       	mov    $0x17,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <sbrk>:
SYSCALL(sbrk)
 3bc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <sleep>:
SYSCALL(sleep)
 3c4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <uptime>:
SYSCALL(uptime)
 3cc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <my_syscall>:
SYSCALL(my_syscall)
 3d4:	b8 16 00 00 00       	mov    $0x16,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <yield>:
SYSCALL(yield)
 3dc:	b8 18 00 00 00       	mov    $0x18,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <getlev>:
SYSCALL(getlev)
 3e4:	b8 19 00 00 00       	mov    $0x19,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <set_cpu_share>:
SYSCALL(set_cpu_share)
 3ec:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <thread_create>:
SYSCALL(thread_create)
 3f4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <thread_exit>:
SYSCALL(thread_exit)
 3fc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <thread_join>:
SYSCALL(thread_join)
 404:	b8 1d 00 00 00       	mov    $0x1d,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 18             	sub    $0x18,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 418:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41f:	00 
 420:	8d 45 f4             	lea    -0xc(%ebp),%eax
 423:	89 44 24 04          	mov    %eax,0x4(%esp)
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	89 04 24             	mov    %eax,(%esp)
 42d:	e8 1a ff ff ff       	call   34c <write>
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	56                   	push   %esi
 438:	53                   	push   %ebx
 439:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 443:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 447:	74 17                	je     460 <printint+0x2c>
 449:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44d:	79 11                	jns    460 <printint+0x2c>
    neg = 1;
 44f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 456:	8b 45 0c             	mov    0xc(%ebp),%eax
 459:	f7 d8                	neg    %eax
 45b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45e:	eb 06                	jmp    466 <printint+0x32>
  } else {
    x = xx;
 460:	8b 45 0c             	mov    0xc(%ebp),%eax
 463:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 466:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 470:	8d 41 01             	lea    0x1(%ecx),%eax
 473:	89 45 f4             	mov    %eax,-0xc(%ebp)
 476:	8b 5d 10             	mov    0x10(%ebp),%ebx
 479:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47c:	ba 00 00 00 00       	mov    $0x0,%edx
 481:	f7 f3                	div    %ebx
 483:	89 d0                	mov    %edx,%eax
 485:	0f b6 80 90 0b 00 00 	movzbl 0xb90(%eax),%eax
 48c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 490:	8b 75 10             	mov    0x10(%ebp),%esi
 493:	8b 45 ec             	mov    -0x14(%ebp),%eax
 496:	ba 00 00 00 00       	mov    $0x0,%edx
 49b:	f7 f6                	div    %esi
 49d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a4:	75 c7                	jne    46d <printint+0x39>
  if(neg)
 4a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4aa:	74 10                	je     4bc <printint+0x88>
    buf[i++] = '-';
 4ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4af:	8d 50 01             	lea    0x1(%eax),%edx
 4b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ba:	eb 1f                	jmp    4db <printint+0xa7>
 4bc:	eb 1d                	jmp    4db <printint+0xa7>
    putc(fd, buf[i]);
 4be:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	0f b6 00             	movzbl (%eax),%eax
 4c9:	0f be c0             	movsbl %al,%eax
 4cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	89 04 24             	mov    %eax,(%esp)
 4d6:	e8 31 ff ff ff       	call   40c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4db:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e3:	79 d9                	jns    4be <printint+0x8a>
    putc(fd, buf[i]);
}
 4e5:	83 c4 30             	add    $0x30,%esp
 4e8:	5b                   	pop    %ebx
 4e9:	5e                   	pop    %esi
 4ea:	5d                   	pop    %ebp
 4eb:	c3                   	ret    

000004ec <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f9:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fc:	83 c0 04             	add    $0x4,%eax
 4ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 509:	e9 7c 01 00 00       	jmp    68a <printf+0x19e>
    c = fmt[i] & 0xff;
 50e:	8b 55 0c             	mov    0xc(%ebp),%edx
 511:	8b 45 f0             	mov    -0x10(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	0f be c0             	movsbl %al,%eax
 51c:	25 ff 00 00 00       	and    $0xff,%eax
 521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 524:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 528:	75 2c                	jne    556 <printf+0x6a>
      if(c == '%'){
 52a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52e:	75 0c                	jne    53c <printf+0x50>
        state = '%';
 530:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 537:	e9 4a 01 00 00       	jmp    686 <printf+0x19a>
      } else {
        putc(fd, c);
 53c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	89 44 24 04          	mov    %eax,0x4(%esp)
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 04 24             	mov    %eax,(%esp)
 54c:	e8 bb fe ff ff       	call   40c <putc>
 551:	e9 30 01 00 00       	jmp    686 <printf+0x19a>
      }
    } else if(state == '%'){
 556:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 55a:	0f 85 26 01 00 00    	jne    686 <printf+0x19a>
      if(c == 'd'){
 560:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 564:	75 2d                	jne    593 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 572:	00 
 573:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 57a:	00 
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 aa fe ff ff       	call   434 <printint>
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	e9 ec 00 00 00       	jmp    67f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 593:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 597:	74 06                	je     59f <printf+0xb3>
 599:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59d:	75 2d                	jne    5cc <printf+0xe0>
        printint(fd, *ap, 16, 0);
 59f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ab:	00 
 5ac:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5b3:	00 
 5b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	89 04 24             	mov    %eax,(%esp)
 5be:	e8 71 fe ff ff       	call   434 <printint>
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c7:	e9 b3 00 00 00       	jmp    67f <printf+0x193>
      } else if(c == 's'){
 5cc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d0:	75 45                	jne    617 <printf+0x12b>
        s = (char*)*ap;
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e2:	75 09                	jne    5ed <printf+0x101>
          s = "(null)";
 5e4:	c7 45 f4 f6 08 00 00 	movl   $0x8f6,-0xc(%ebp)
        while(*s != 0){
 5eb:	eb 1e                	jmp    60b <printf+0x11f>
 5ed:	eb 1c                	jmp    60b <printf+0x11f>
          putc(fd, *s);
 5ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f2:	0f b6 00             	movzbl (%eax),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fc:	8b 45 08             	mov    0x8(%ebp),%eax
 5ff:	89 04 24             	mov    %eax,(%esp)
 602:	e8 05 fe ff ff       	call   40c <putc>
          s++;
 607:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60e:	0f b6 00             	movzbl (%eax),%eax
 611:	84 c0                	test   %al,%al
 613:	75 da                	jne    5ef <printf+0x103>
 615:	eb 68                	jmp    67f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 617:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61b:	75 1d                	jne    63a <printf+0x14e>
        putc(fd, *ap);
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 d8 fd ff ff       	call   40c <putc>
        ap++;
 634:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 638:	eb 45                	jmp    67f <printf+0x193>
      } else if(c == '%'){
 63a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63e:	75 17                	jne    657 <printf+0x16b>
        putc(fd, c);
 640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 643:	0f be c0             	movsbl %al,%eax
 646:	89 44 24 04          	mov    %eax,0x4(%esp)
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
 64d:	89 04 24             	mov    %eax,(%esp)
 650:	e8 b7 fd ff ff       	call   40c <putc>
 655:	eb 28                	jmp    67f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 657:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 65e:	00 
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	89 04 24             	mov    %eax,(%esp)
 665:	e8 a2 fd ff ff       	call   40c <putc>
        putc(fd, c);
 66a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66d:	0f be c0             	movsbl %al,%eax
 670:	89 44 24 04          	mov    %eax,0x4(%esp)
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 8d fd ff ff       	call   40c <putc>
      }
      state = 0;
 67f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 686:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 68a:	8b 55 0c             	mov    0xc(%ebp),%edx
 68d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	84 c0                	test   %al,%al
 697:	0f 85 71 fe ff ff    	jne    50e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 69d:	c9                   	leave  
 69e:	c3                   	ret    

0000069f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	83 e8 08             	sub    $0x8,%eax
 6ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ae:	a1 ac 0b 00 00       	mov    0xbac,%eax
 6b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b6:	eb 24                	jmp    6dc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c0:	77 12                	ja     6d4 <free+0x35>
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c8:	77 24                	ja     6ee <free+0x4f>
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d2:	77 1a                	ja     6ee <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e2:	76 d4                	jbe    6b8 <free+0x19>
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ec:	76 ca                	jbe    6b8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 40 04             	mov    0x4(%eax),%eax
 6f4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	01 c2                	add    %eax,%edx
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	39 c2                	cmp    %eax,%edx
 707:	75 24                	jne    72d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	8b 50 04             	mov    0x4(%eax),%edx
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	01 c2                	add    %eax,%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	8b 10                	mov    (%eax),%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	89 10                	mov    %edx,(%eax)
 72b:	eb 0a                	jmp    737 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	01 d0                	add    %edx,%eax
 749:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 74c:	75 20                	jne    76e <free+0xcf>
    p->s.size += bp->s.size;
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 50 04             	mov    0x4(%eax),%edx
 754:	8b 45 f8             	mov    -0x8(%ebp),%eax
 757:	8b 40 04             	mov    0x4(%eax),%eax
 75a:	01 c2                	add    %eax,%edx
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
 76c:	eb 08                	jmp    776 <free+0xd7>
  } else
    p->s.ptr = bp;
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 55 f8             	mov    -0x8(%ebp),%edx
 774:	89 10                	mov    %edx,(%eax)
  freep = p;
 776:	8b 45 fc             	mov    -0x4(%ebp),%eax
 779:	a3 ac 0b 00 00       	mov    %eax,0xbac
}
 77e:	c9                   	leave  
 77f:	c3                   	ret    

00000780 <morecore>:

static Header*
morecore(uint nu)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 786:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 78d:	77 07                	ja     796 <morecore+0x16>
    nu = 4096;
 78f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 796:	8b 45 08             	mov    0x8(%ebp),%eax
 799:	c1 e0 03             	shl    $0x3,%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 18 fc ff ff       	call   3bc <sbrk>
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ab:	75 07                	jne    7b4 <morecore+0x34>
    return 0;
 7ad:	b8 00 00 00 00       	mov    $0x0,%eax
 7b2:	eb 22                	jmp    7d6 <morecore+0x56>
  hp = (Header*)p;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	8b 55 08             	mov    0x8(%ebp),%edx
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	83 c0 08             	add    $0x8,%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 ce fe ff ff       	call   69f <free>
  return freep;
 7d1:	a1 ac 0b 00 00       	mov    0xbac,%eax
}
 7d6:	c9                   	leave  
 7d7:	c3                   	ret    

000007d8 <malloc>:

void*
malloc(uint nbytes)
{
 7d8:	55                   	push   %ebp
 7d9:	89 e5                	mov    %esp,%ebp
 7db:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	83 c0 07             	add    $0x7,%eax
 7e4:	c1 e8 03             	shr    $0x3,%eax
 7e7:	83 c0 01             	add    $0x1,%eax
 7ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ed:	a1 ac 0b 00 00       	mov    0xbac,%eax
 7f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f9:	75 23                	jne    81e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7fb:	c7 45 f0 a4 0b 00 00 	movl   $0xba4,-0x10(%ebp)
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	a3 ac 0b 00 00       	mov    %eax,0xbac
 80a:	a1 ac 0b 00 00       	mov    0xbac,%eax
 80f:	a3 a4 0b 00 00       	mov    %eax,0xba4
    base.s.size = 0;
 814:	c7 05 a8 0b 00 00 00 	movl   $0x0,0xba8
 81b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82f:	72 4d                	jb     87e <malloc+0xa6>
      if(p->s.size == nunits)
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83a:	75 0c                	jne    848 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 f0             	mov    -0x10(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
 846:	eb 26                	jmp    86e <malloc+0x96>
      else {
        p->s.size -= nunits;
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 851:	89 c2                	mov    %eax,%edx
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	c1 e0 03             	shl    $0x3,%eax
 862:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	a3 ac 0b 00 00       	mov    %eax,0xbac
      return (void*)(p + 1);
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	83 c0 08             	add    $0x8,%eax
 87c:	eb 38                	jmp    8b6 <malloc+0xde>
    }
    if(p == freep)
 87e:	a1 ac 0b 00 00       	mov    0xbac,%eax
 883:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 886:	75 1b                	jne    8a3 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 888:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88b:	89 04 24             	mov    %eax,(%esp)
 88e:	e8 ed fe ff ff       	call   780 <morecore>
 893:	89 45 f4             	mov    %eax,-0xc(%ebp)
 896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89a:	75 07                	jne    8a3 <malloc+0xcb>
        return 0;
 89c:	b8 00 00 00 00       	mov    $0x0,%eax
 8a1:	eb 13                	jmp    8b6 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b1:	e9 70 ff ff ff       	jmp    826 <malloc+0x4e>
}
 8b6:	c9                   	leave  
 8b7:	c3                   	ret    
