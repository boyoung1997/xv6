
_my_userapp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    char *buf = "Hello xv6!";
   9:	c7 44 24 1c 36 08 00 	movl   $0x836,0x1c(%esp)
  10:	00 
    int ret_val;
    ret_val = my_syscall(buf);
  11:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  15:	89 04 24             	mov    %eax,(%esp)
  18:	e8 35 03 00 00       	call   352 <my_syscall>
  1d:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1, "Return value : 0x%x\n", ret_val);
  21:	8b 44 24 18          	mov    0x18(%esp),%eax
  25:	89 44 24 08          	mov    %eax,0x8(%esp)
  29:	c7 44 24 04 41 08 00 	movl   $0x841,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 2d 04 00 00       	call   46a <printf>
    exit();
  3d:	e8 68 02 00 00       	call   2aa <exit>

00000042 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	57                   	push   %edi
  46:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4a:	8b 55 10             	mov    0x10(%ebp),%edx
  4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  50:	89 cb                	mov    %ecx,%ebx
  52:	89 df                	mov    %ebx,%edi
  54:	89 d1                	mov    %edx,%ecx
  56:	fc                   	cld    
  57:	f3 aa                	rep stos %al,%es:(%edi)
  59:	89 ca                	mov    %ecx,%edx
  5b:	89 fb                	mov    %edi,%ebx
  5d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  60:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  63:	5b                   	pop    %ebx
  64:	5f                   	pop    %edi
  65:	5d                   	pop    %ebp
  66:	c3                   	ret    

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6d:	8b 45 08             	mov    0x8(%ebp),%eax
  70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  73:	90                   	nop
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8d 50 01             	lea    0x1(%eax),%edx
  7a:	89 55 08             	mov    %edx,0x8(%ebp)
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  80:	8d 4a 01             	lea    0x1(%edx),%ecx
  83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  86:	0f b6 12             	movzbl (%edx),%edx
  89:	88 10                	mov    %dl,(%eax)
  8b:	0f b6 00             	movzbl (%eax),%eax
  8e:	84 c0                	test   %al,%al
  90:	75 e2                	jne    74 <strcpy+0xd>
    ;
  return os;
  92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  95:	c9                   	leave  
  96:	c3                   	ret    

00000097 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9a:	eb 08                	jmp    a4 <strcmp+0xd>
    p++, q++;
  9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	74 10                	je     be <strcmp+0x27>
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	38 c2                	cmp    %al,%dl
  bc:	74 de                	je     9c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	0f b6 d0             	movzbl %al,%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	0f b6 c0             	movzbl %al,%eax
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
}
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    

000000d6 <strlen>:

uint
strlen(char *s)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e3:	eb 04                	jmp    e9 <strlen+0x13>
  e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	84 c0                	test   %al,%al
  f6:	75 ed                	jne    e5 <strlen+0xf>
    ;
  return n;
  f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <memset>:

void*
memset(void *dst, int c, uint n)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 103:	8b 45 10             	mov    0x10(%ebp),%eax
 106:	89 44 24 08          	mov    %eax,0x8(%esp)
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 44 24 04          	mov    %eax,0x4(%esp)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 04 24             	mov    %eax,(%esp)
 117:	e8 26 ff ff ff       	call   42 <stosb>
  return dst;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <strchr>:

char*
strchr(const char *s, char c)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 04             	sub    $0x4,%esp
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12d:	eb 14                	jmp    143 <strchr+0x22>
    if(*s == c)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	3a 45 fc             	cmp    -0x4(%ebp),%al
 138:	75 05                	jne    13f <strchr+0x1e>
      return (char*)s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	eb 13                	jmp    152 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 13f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	75 e2                	jne    12f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 14d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 161:	eb 4c                	jmp    1af <gets+0x5b>
    cc = read(0, &c, 1);
 163:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 16a:	00 
 16b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16e:	89 44 24 04          	mov    %eax,0x4(%esp)
 172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 179:	e8 44 01 00 00       	call   2c2 <read>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 185:	7f 02                	jg     189 <gets+0x35>
      break;
 187:	eb 31                	jmp    1ba <gets+0x66>
    buf[i++] = c;
 189:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18c:	8d 50 01             	lea    0x1(%eax),%edx
 18f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 192:	89 c2                	mov    %eax,%edx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	01 c2                	add    %eax,%edx
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	3c 0a                	cmp    $0xa,%al
 1a5:	74 13                	je     1ba <gets+0x66>
 1a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ab:	3c 0d                	cmp    $0xd,%al
 1ad:	74 0b                	je     1ba <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b8:	7c a9                	jl     163 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	01 d0                	add    %edx,%eax
 1c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <stat>:

int
stat(char *n, struct stat *st)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d7:	00 
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 07 01 00 00       	call   2ea <open>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ea:	79 07                	jns    1f3 <stat+0x29>
    return -1;
 1ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f1:	eb 23                	jmp    216 <stat+0x4c>
  r = fstat(fd, st);
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 fd 00 00 00       	call   302 <fstat>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 208:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20b:	89 04 24             	mov    %eax,(%esp)
 20e:	e8 bf 00 00 00       	call   2d2 <close>
  return r;
 213:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	eb 25                	jmp    24c <atoi+0x34>
    n = n*10 + *s++ - '0';
 227:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22a:	89 d0                	mov    %edx,%eax
 22c:	c1 e0 02             	shl    $0x2,%eax
 22f:	01 d0                	add    %edx,%eax
 231:	01 c0                	add    %eax,%eax
 233:	89 c1                	mov    %eax,%ecx
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 08             	mov    %edx,0x8(%ebp)
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	0f be c0             	movsbl %al,%eax
 244:	01 c8                	add    %ecx,%eax
 246:	83 e8 30             	sub    $0x30,%eax
 249:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	3c 2f                	cmp    $0x2f,%al
 254:	7e 0a                	jle    260 <atoi+0x48>
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	3c 39                	cmp    $0x39,%al
 25e:	7e c7                	jle    227 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 277:	eb 17                	jmp    290 <memmove+0x2b>
    *dst++ = *src++;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27c:	8d 50 01             	lea    0x1(%eax),%edx
 27f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 282:	8b 55 f8             	mov    -0x8(%ebp),%edx
 285:	8d 4a 01             	lea    0x1(%edx),%ecx
 288:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 28b:	0f b6 12             	movzbl (%edx),%edx
 28e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 290:	8b 45 10             	mov    0x10(%ebp),%eax
 293:	8d 50 ff             	lea    -0x1(%eax),%edx
 296:	89 55 10             	mov    %edx,0x10(%ebp)
 299:	85 c0                	test   %eax,%eax
 29b:	7f dc                	jg     279 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a2:	b8 01 00 00 00       	mov    $0x1,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exit>:
SYSCALL(exit)
 2aa:	b8 02 00 00 00       	mov    $0x2,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <wait>:
SYSCALL(wait)
 2b2:	b8 03 00 00 00       	mov    $0x3,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <pipe>:
SYSCALL(pipe)
 2ba:	b8 04 00 00 00       	mov    $0x4,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <read>:
SYSCALL(read)
 2c2:	b8 05 00 00 00       	mov    $0x5,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <write>:
SYSCALL(write)
 2ca:	b8 10 00 00 00       	mov    $0x10,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <close>:
SYSCALL(close)
 2d2:	b8 15 00 00 00       	mov    $0x15,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <kill>:
SYSCALL(kill)
 2da:	b8 06 00 00 00       	mov    $0x6,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exec>:
SYSCALL(exec)
 2e2:	b8 07 00 00 00       	mov    $0x7,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <open>:
SYSCALL(open)
 2ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mknod>:
SYSCALL(mknod)
 2f2:	b8 11 00 00 00       	mov    $0x11,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <unlink>:
SYSCALL(unlink)
 2fa:	b8 12 00 00 00       	mov    $0x12,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <fstat>:
SYSCALL(fstat)
 302:	b8 08 00 00 00       	mov    $0x8,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <link>:
SYSCALL(link)
 30a:	b8 13 00 00 00       	mov    $0x13,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <mkdir>:
SYSCALL(mkdir)
 312:	b8 14 00 00 00       	mov    $0x14,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <chdir>:
SYSCALL(chdir)
 31a:	b8 09 00 00 00       	mov    $0x9,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <dup>:
SYSCALL(dup)
 322:	b8 0a 00 00 00       	mov    $0xa,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getpid>:
SYSCALL(getpid)
 32a:	b8 0b 00 00 00       	mov    $0xb,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getppid>:
SYSCALL(getppid)
 332:	b8 17 00 00 00       	mov    $0x17,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
SYSCALL(sbrk)
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
SYSCALL(sleep)
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
SYSCALL(uptime)
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <my_syscall>:
SYSCALL(my_syscall)
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <yield>:
SYSCALL(yield)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getlev>:
SYSCALL(getlev)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <set_cpu_share>:
SYSCALL(set_cpu_share)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <thread_create>:
SYSCALL(thread_create)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <thread_exit>:
SYSCALL(thread_exit)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <thread_join>:
SYSCALL(thread_join)
 382:	b8 1d 00 00 00       	mov    $0x1d,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 18             	sub    $0x18,%esp
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 396:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39d:	00 
 39e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 1a ff ff ff       	call   2ca <write>
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	56                   	push   %esi
 3b6:	53                   	push   %ebx
 3b7:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c5:	74 17                	je     3de <printint+0x2c>
 3c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3cb:	79 11                	jns    3de <printint+0x2c>
    neg = 1;
 3cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d7:	f7 d8                	neg    %eax
 3d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3dc:	eb 06                	jmp    3e4 <printint+0x32>
  } else {
    x = xx;
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3eb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3ee:	8d 41 01             	lea    0x1(%ecx),%eax
 3f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fa:	ba 00 00 00 00       	mov    $0x0,%edx
 3ff:	f7 f3                	div    %ebx
 401:	89 d0                	mov    %edx,%eax
 403:	0f b6 80 a4 0a 00 00 	movzbl 0xaa4(%eax),%eax
 40a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 40e:	8b 75 10             	mov    0x10(%ebp),%esi
 411:	8b 45 ec             	mov    -0x14(%ebp),%eax
 414:	ba 00 00 00 00       	mov    $0x0,%edx
 419:	f7 f6                	div    %esi
 41b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 422:	75 c7                	jne    3eb <printint+0x39>
  if(neg)
 424:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 428:	74 10                	je     43a <printint+0x88>
    buf[i++] = '-';
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	8d 50 01             	lea    0x1(%eax),%edx
 430:	89 55 f4             	mov    %edx,-0xc(%ebp)
 433:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 438:	eb 1f                	jmp    459 <printint+0xa7>
 43a:	eb 1d                	jmp    459 <printint+0xa7>
    putc(fd, buf[i]);
 43c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 442:	01 d0                	add    %edx,%eax
 444:	0f b6 00             	movzbl (%eax),%eax
 447:	0f be c0             	movsbl %al,%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 31 ff ff ff       	call   38a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 459:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 45d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 461:	79 d9                	jns    43c <printint+0x8a>
    putc(fd, buf[i]);
}
 463:	83 c4 30             	add    $0x30,%esp
 466:	5b                   	pop    %ebx
 467:	5e                   	pop    %esi
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    

0000046a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 470:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 477:	8d 45 0c             	lea    0xc(%ebp),%eax
 47a:	83 c0 04             	add    $0x4,%eax
 47d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 480:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 487:	e9 7c 01 00 00       	jmp    608 <printf+0x19e>
    c = fmt[i] & 0xff;
 48c:	8b 55 0c             	mov    0xc(%ebp),%edx
 48f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 492:	01 d0                	add    %edx,%eax
 494:	0f b6 00             	movzbl (%eax),%eax
 497:	0f be c0             	movsbl %al,%eax
 49a:	25 ff 00 00 00       	and    $0xff,%eax
 49f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a6:	75 2c                	jne    4d4 <printf+0x6a>
      if(c == '%'){
 4a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ac:	75 0c                	jne    4ba <printf+0x50>
        state = '%';
 4ae:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b5:	e9 4a 01 00 00       	jmp    604 <printf+0x19a>
      } else {
        putc(fd, c);
 4ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	89 04 24             	mov    %eax,(%esp)
 4ca:	e8 bb fe ff ff       	call   38a <putc>
 4cf:	e9 30 01 00 00       	jmp    604 <printf+0x19a>
      }
    } else if(state == '%'){
 4d4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d8:	0f 85 26 01 00 00    	jne    604 <printf+0x19a>
      if(c == 'd'){
 4de:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e2:	75 2d                	jne    511 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e7:	8b 00                	mov    (%eax),%eax
 4e9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f0:	00 
 4f1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f8:	00 
 4f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	89 04 24             	mov    %eax,(%esp)
 503:	e8 aa fe ff ff       	call   3b2 <printint>
        ap++;
 508:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50c:	e9 ec 00 00 00       	jmp    5fd <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 511:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 515:	74 06                	je     51d <printf+0xb3>
 517:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51b:	75 2d                	jne    54a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 51d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 520:	8b 00                	mov    (%eax),%eax
 522:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 529:	00 
 52a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 531:	00 
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 71 fe ff ff       	call   3b2 <printint>
        ap++;
 541:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 545:	e9 b3 00 00 00       	jmp    5fd <printf+0x193>
      } else if(c == 's'){
 54a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 54e:	75 45                	jne    595 <printf+0x12b>
        s = (char*)*ap;
 550:	8b 45 e8             	mov    -0x18(%ebp),%eax
 553:	8b 00                	mov    (%eax),%eax
 555:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 560:	75 09                	jne    56b <printf+0x101>
          s = "(null)";
 562:	c7 45 f4 56 08 00 00 	movl   $0x856,-0xc(%ebp)
        while(*s != 0){
 569:	eb 1e                	jmp    589 <printf+0x11f>
 56b:	eb 1c                	jmp    589 <printf+0x11f>
          putc(fd, *s);
 56d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 05 fe ff ff       	call   38a <putc>
          s++;
 585:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	0f b6 00             	movzbl (%eax),%eax
 58f:	84 c0                	test   %al,%al
 591:	75 da                	jne    56d <printf+0x103>
 593:	eb 68                	jmp    5fd <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 595:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 599:	75 1d                	jne    5b8 <printf+0x14e>
        putc(fd, *ap);
 59b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 d8 fd ff ff       	call   38a <putc>
        ap++;
 5b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b6:	eb 45                	jmp    5fd <printf+0x193>
      } else if(c == '%'){
 5b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bc:	75 17                	jne    5d5 <printf+0x16b>
        putc(fd, c);
 5be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c1:	0f be c0             	movsbl %al,%eax
 5c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 b7 fd ff ff       	call   38a <putc>
 5d3:	eb 28                	jmp    5fd <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5dc:	00 
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	89 04 24             	mov    %eax,(%esp)
 5e3:	e8 a2 fd ff ff       	call   38a <putc>
        putc(fd, c);
 5e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	89 04 24             	mov    %eax,(%esp)
 5f8:	e8 8d fd ff ff       	call   38a <putc>
      }
      state = 0;
 5fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 604:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	84 c0                	test   %al,%al
 615:	0f 85 71 fe ff ff    	jne    48c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61b:	c9                   	leave  
 61c:	c3                   	ret    

0000061d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61d:	55                   	push   %ebp
 61e:	89 e5                	mov    %esp,%ebp
 620:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	83 e8 08             	sub    $0x8,%eax
 629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	a1 c0 0a 00 00       	mov    0xac0,%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	eb 24                	jmp    65a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63e:	77 12                	ja     652 <free+0x35>
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 646:	77 24                	ja     66c <free+0x4f>
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 650:	77 1a                	ja     66c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	76 d4                	jbe    636 <free+0x19>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	76 ca                	jbe    636 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 c2                	cmp    %eax,%edx
 685:	75 24                	jne    6ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	01 c2                	add    %eax,%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 0a                	jmp    6b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	01 d0                	add    %edx,%eax
 6c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ca:	75 20                	jne    6ec <free+0xcf>
    p->s.size += bp->s.size;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 50 04             	mov    0x4(%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 10                	mov    (%eax),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 10                	mov    %edx,(%eax)
 6ea:	eb 08                	jmp    6f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <morecore>:

static Header*
morecore(uint nu)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 704:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70b:	77 07                	ja     714 <morecore+0x16>
    nu = 4096;
 70d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	c1 e0 03             	shl    $0x3,%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 18 fc ff ff       	call   33a <sbrk>
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 725:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 729:	75 07                	jne    732 <morecore+0x34>
    return 0;
 72b:	b8 00 00 00 00       	mov    $0x0,%eax
 730:	eb 22                	jmp    754 <morecore+0x56>
  hp = (Header*)p;
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	8b 55 08             	mov    0x8(%ebp),%edx
 73e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	83 c0 08             	add    $0x8,%eax
 747:	89 04 24             	mov    %eax,(%esp)
 74a:	e8 ce fe ff ff       	call   61d <free>
  return freep;
 74f:	a1 c0 0a 00 00       	mov    0xac0,%eax
}
 754:	c9                   	leave  
 755:	c3                   	ret    

00000756 <malloc>:

void*
malloc(uint nbytes)
{
 756:	55                   	push   %ebp
 757:	89 e5                	mov    %esp,%ebp
 759:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	83 c0 07             	add    $0x7,%eax
 762:	c1 e8 03             	shr    $0x3,%eax
 765:	83 c0 01             	add    $0x1,%eax
 768:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76b:	a1 c0 0a 00 00       	mov    0xac0,%eax
 770:	89 45 f0             	mov    %eax,-0x10(%ebp)
 773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 777:	75 23                	jne    79c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 779:	c7 45 f0 b8 0a 00 00 	movl   $0xab8,-0x10(%ebp)
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	a3 c0 0a 00 00       	mov    %eax,0xac0
 788:	a1 c0 0a 00 00       	mov    0xac0,%eax
 78d:	a3 b8 0a 00 00       	mov    %eax,0xab8
    base.s.size = 0;
 792:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 799:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ad:	72 4d                	jb     7fc <malloc+0xa6>
      if(p->s.size == nunits)
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b8:	75 0c                	jne    7c6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 10                	mov    (%eax),%edx
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	89 10                	mov    %edx,(%eax)
 7c4:	eb 26                	jmp    7ec <malloc+0x96>
      else {
        p->s.size -= nunits;
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7cf:	89 c2                	mov    %eax,%edx
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	8b 40 04             	mov    0x4(%eax),%eax
 7dd:	c1 e0 03             	shl    $0x3,%eax
 7e0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	a3 c0 0a 00 00       	mov    %eax,0xac0
      return (void*)(p + 1);
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	83 c0 08             	add    $0x8,%eax
 7fa:	eb 38                	jmp    834 <malloc+0xde>
    }
    if(p == freep)
 7fc:	a1 c0 0a 00 00       	mov    0xac0,%eax
 801:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 804:	75 1b                	jne    821 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 806:	8b 45 ec             	mov    -0x14(%ebp),%eax
 809:	89 04 24             	mov    %eax,(%esp)
 80c:	e8 ed fe ff ff       	call   6fe <morecore>
 811:	89 45 f4             	mov    %eax,-0xc(%ebp)
 814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 818:	75 07                	jne    821 <malloc+0xcb>
        return 0;
 81a:	b8 00 00 00 00       	mov    $0x0,%eax
 81f:	eb 13                	jmp    834 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	89 45 f0             	mov    %eax,-0x10(%ebp)
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 82f:	e9 70 ff ff ff       	jmp    7a4 <malloc+0x4e>
}
 834:	c9                   	leave  
 835:	c3                   	ret    
