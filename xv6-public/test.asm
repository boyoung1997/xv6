
_test:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
    printf(1,"My pid is %d\n", getpid());
   9:	e8 22 03 00 00       	call   330 <getpid>
   e:	89 44 24 08          	mov    %eax,0x8(%esp)
  12:	c7 44 24 04 3c 08 00 	movl   $0x83c,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 4a 04 00 00       	call   470 <printf>
    printf(1,"My ppid is %d\n", getppid());
  26:	e8 0d 03 00 00       	call   338 <getppid>
  2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  2f:	c7 44 24 04 4a 08 00 	movl   $0x84a,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 2d 04 00 00       	call   470 <printf>
    exit();
  43:	e8 68 02 00 00       	call   2b0 <exit>

00000048 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	57                   	push   %edi
  4c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  50:	8b 55 10             	mov    0x10(%ebp),%edx
  53:	8b 45 0c             	mov    0xc(%ebp),%eax
  56:	89 cb                	mov    %ecx,%ebx
  58:	89 df                	mov    %ebx,%edi
  5a:	89 d1                	mov    %edx,%ecx
  5c:	fc                   	cld    
  5d:	f3 aa                	rep stos %al,%es:(%edi)
  5f:	89 ca                	mov    %ecx,%edx
  61:	89 fb                	mov    %edi,%ebx
  63:	89 5d 08             	mov    %ebx,0x8(%ebp)
  66:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  69:	5b                   	pop    %ebx
  6a:	5f                   	pop    %edi
  6b:	5d                   	pop    %ebp
  6c:	c3                   	ret    

0000006d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  73:	8b 45 08             	mov    0x8(%ebp),%eax
  76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  79:	90                   	nop
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8d 50 01             	lea    0x1(%eax),%edx
  80:	89 55 08             	mov    %edx,0x8(%ebp)
  83:	8b 55 0c             	mov    0xc(%ebp),%edx
  86:	8d 4a 01             	lea    0x1(%edx),%ecx
  89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8c:	0f b6 12             	movzbl (%edx),%edx
  8f:	88 10                	mov    %dl,(%eax)
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	84 c0                	test   %al,%al
  96:	75 e2                	jne    7a <strcpy+0xd>
    ;
  return os;
  98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9b:	c9                   	leave  
  9c:	c3                   	ret    

0000009d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a0:	eb 08                	jmp    aa <strcmp+0xd>
    p++, q++;
  a2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  aa:	8b 45 08             	mov    0x8(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	84 c0                	test   %al,%al
  b2:	74 10                	je     c4 <strcmp+0x27>
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	0f b6 10             	movzbl (%eax),%edx
  ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	38 c2                	cmp    %al,%dl
  c2:	74 de                	je     a2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	0f b6 d0             	movzbl %al,%edx
  cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	0f b6 c0             	movzbl %al,%eax
  d6:	29 c2                	sub    %eax,%edx
  d8:	89 d0                	mov    %edx,%eax
}
  da:	5d                   	pop    %ebp
  db:	c3                   	ret    

000000dc <strlen>:

uint
strlen(char *s)
{
  dc:	55                   	push   %ebp
  dd:	89 e5                	mov    %esp,%ebp
  df:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e9:	eb 04                	jmp    ef <strlen+0x13>
  eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	01 d0                	add    %edx,%eax
  f7:	0f b6 00             	movzbl (%eax),%eax
  fa:	84 c0                	test   %al,%al
  fc:	75 ed                	jne    eb <strlen+0xf>
    ;
  return n;
  fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <memset>:

void*
memset(void *dst, int c, uint n)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 109:	8b 45 10             	mov    0x10(%ebp),%eax
 10c:	89 44 24 08          	mov    %eax,0x8(%esp)
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	89 44 24 04          	mov    %eax,0x4(%esp)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	89 04 24             	mov    %eax,(%esp)
 11d:	e8 26 ff ff ff       	call   48 <stosb>
  return dst;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <strchr>:

char*
strchr(const char *s, char c)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 04             	sub    $0x4,%esp
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 133:	eb 14                	jmp    149 <strchr+0x22>
    if(*s == c)
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 13e:	75 05                	jne    145 <strchr+0x1e>
      return (char*)s;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	eb 13                	jmp    158 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 145:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	84 c0                	test   %al,%al
 151:	75 e2                	jne    135 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 153:	b8 00 00 00 00       	mov    $0x0,%eax
}
 158:	c9                   	leave  
 159:	c3                   	ret    

0000015a <gets>:

char*
gets(char *buf, int max)
{
 15a:	55                   	push   %ebp
 15b:	89 e5                	mov    %esp,%ebp
 15d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 167:	eb 4c                	jmp    1b5 <gets+0x5b>
    cc = read(0, &c, 1);
 169:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 170:	00 
 171:	8d 45 ef             	lea    -0x11(%ebp),%eax
 174:	89 44 24 04          	mov    %eax,0x4(%esp)
 178:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 17f:	e8 44 01 00 00       	call   2c8 <read>
 184:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 18b:	7f 02                	jg     18f <gets+0x35>
      break;
 18d:	eb 31                	jmp    1c0 <gets+0x66>
    buf[i++] = c;
 18f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 192:	8d 50 01             	lea    0x1(%eax),%edx
 195:	89 55 f4             	mov    %edx,-0xc(%ebp)
 198:	89 c2                	mov    %eax,%edx
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	01 c2                	add    %eax,%edx
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 13                	je     1c0 <gets+0x66>
 1ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b1:	3c 0d                	cmp    $0xd,%al
 1b3:	74 0b                	je     1c0 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1be:	7c a9                	jl     169 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	01 d0                	add    %edx,%eax
 1c8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <stat>:

int
stat(char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1dd:	00 
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 07 01 00 00       	call   2f0 <open>
 1e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f0:	79 07                	jns    1f9 <stat+0x29>
    return -1;
 1f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f7:	eb 23                	jmp    21c <stat+0x4c>
  r = fstat(fd, st);
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 200:	8b 45 f4             	mov    -0xc(%ebp),%eax
 203:	89 04 24             	mov    %eax,(%esp)
 206:	e8 fd 00 00 00       	call   308 <fstat>
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 bf 00 00 00       	call   2d8 <close>
  return r;
 219:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <atoi>:

int
atoi(const char *s)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 224:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22b:	eb 25                	jmp    252 <atoi+0x34>
    n = n*10 + *s++ - '0';
 22d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 230:	89 d0                	mov    %edx,%eax
 232:	c1 e0 02             	shl    $0x2,%eax
 235:	01 d0                	add    %edx,%eax
 237:	01 c0                	add    %eax,%eax
 239:	89 c1                	mov    %eax,%ecx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8d 50 01             	lea    0x1(%eax),%edx
 241:	89 55 08             	mov    %edx,0x8(%ebp)
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	0f be c0             	movsbl %al,%eax
 24a:	01 c8                	add    %ecx,%eax
 24c:	83 e8 30             	sub    $0x30,%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	3c 2f                	cmp    $0x2f,%al
 25a:	7e 0a                	jle    266 <atoi+0x48>
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	3c 39                	cmp    $0x39,%al
 264:	7e c7                	jle    22d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 266:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 27d:	eb 17                	jmp    296 <memmove+0x2b>
    *dst++ = *src++;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 fc             	mov    %edx,-0x4(%ebp)
 288:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28b:	8d 4a 01             	lea    0x1(%edx),%ecx
 28e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 291:	0f b6 12             	movzbl (%edx),%edx
 294:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	8b 45 10             	mov    0x10(%ebp),%eax
 299:	8d 50 ff             	lea    -0x1(%eax),%edx
 29c:	89 55 10             	mov    %edx,0x10(%ebp)
 29f:	85 c0                	test   %eax,%eax
 2a1:	7f dc                	jg     27f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a8:	b8 01 00 00 00       	mov    $0x1,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exit>:
SYSCALL(exit)
 2b0:	b8 02 00 00 00       	mov    $0x2,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <wait>:
SYSCALL(wait)
 2b8:	b8 03 00 00 00       	mov    $0x3,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <pipe>:
SYSCALL(pipe)
 2c0:	b8 04 00 00 00       	mov    $0x4,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <read>:
SYSCALL(read)
 2c8:	b8 05 00 00 00       	mov    $0x5,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <write>:
SYSCALL(write)
 2d0:	b8 10 00 00 00       	mov    $0x10,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <close>:
SYSCALL(close)
 2d8:	b8 15 00 00 00       	mov    $0x15,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <kill>:
SYSCALL(kill)
 2e0:	b8 06 00 00 00       	mov    $0x6,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <exec>:
SYSCALL(exec)
 2e8:	b8 07 00 00 00       	mov    $0x7,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <open>:
SYSCALL(open)
 2f0:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <mknod>:
SYSCALL(mknod)
 2f8:	b8 11 00 00 00       	mov    $0x11,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <unlink>:
SYSCALL(unlink)
 300:	b8 12 00 00 00       	mov    $0x12,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <fstat>:
SYSCALL(fstat)
 308:	b8 08 00 00 00       	mov    $0x8,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <link>:
SYSCALL(link)
 310:	b8 13 00 00 00       	mov    $0x13,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <mkdir>:
SYSCALL(mkdir)
 318:	b8 14 00 00 00       	mov    $0x14,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <chdir>:
SYSCALL(chdir)
 320:	b8 09 00 00 00       	mov    $0x9,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <dup>:
SYSCALL(dup)
 328:	b8 0a 00 00 00       	mov    $0xa,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <getpid>:
SYSCALL(getpid)
 330:	b8 0b 00 00 00       	mov    $0xb,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <getppid>:
SYSCALL(getppid)
 338:	b8 17 00 00 00       	mov    $0x17,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <sbrk>:
SYSCALL(sbrk)
 340:	b8 0c 00 00 00       	mov    $0xc,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <sleep>:
SYSCALL(sleep)
 348:	b8 0d 00 00 00       	mov    $0xd,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <uptime>:
SYSCALL(uptime)
 350:	b8 0e 00 00 00       	mov    $0xe,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <my_syscall>:
SYSCALL(my_syscall)
 358:	b8 16 00 00 00       	mov    $0x16,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <yield>:
SYSCALL(yield)
 360:	b8 18 00 00 00       	mov    $0x18,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <getlev>:
SYSCALL(getlev)
 368:	b8 19 00 00 00       	mov    $0x19,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <set_cpu_share>:
SYSCALL(set_cpu_share)
 370:	b8 1a 00 00 00       	mov    $0x1a,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <thread_create>:
SYSCALL(thread_create)
 378:	b8 1b 00 00 00       	mov    $0x1b,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <thread_exit>:
SYSCALL(thread_exit)
 380:	b8 1c 00 00 00       	mov    $0x1c,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <thread_join>:
SYSCALL(thread_join)
 388:	b8 1d 00 00 00       	mov    $0x1d,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 18             	sub    $0x18,%esp
 396:	8b 45 0c             	mov    0xc(%ebp),%eax
 399:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 39c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a3:	00 
 3a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	89 04 24             	mov    %eax,(%esp)
 3b1:	e8 1a ff ff ff       	call   2d0 <write>
}
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    

000003b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	56                   	push   %esi
 3bc:	53                   	push   %ebx
 3bd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cb:	74 17                	je     3e4 <printint+0x2c>
 3cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d1:	79 11                	jns    3e4 <printint+0x2c>
    neg = 1;
 3d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	f7 d8                	neg    %eax
 3df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e2:	eb 06                	jmp    3ea <printint+0x32>
  } else {
    x = xx;
 3e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f4:	8d 41 01             	lea    0x1(%ecx),%eax
 3f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 f3                	div    %ebx
 407:	89 d0                	mov    %edx,%eax
 409:	0f b6 80 a4 0a 00 00 	movzbl 0xaa4(%eax),%eax
 410:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 414:	8b 75 10             	mov    0x10(%ebp),%esi
 417:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41a:	ba 00 00 00 00       	mov    $0x0,%edx
 41f:	f7 f6                	div    %esi
 421:	89 45 ec             	mov    %eax,-0x14(%ebp)
 424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 428:	75 c7                	jne    3f1 <printint+0x39>
  if(neg)
 42a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42e:	74 10                	je     440 <printint+0x88>
    buf[i++] = '-';
 430:	8b 45 f4             	mov    -0xc(%ebp),%eax
 433:	8d 50 01             	lea    0x1(%eax),%edx
 436:	89 55 f4             	mov    %edx,-0xc(%ebp)
 439:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 43e:	eb 1f                	jmp    45f <printint+0xa7>
 440:	eb 1d                	jmp    45f <printint+0xa7>
    putc(fd, buf[i]);
 442:	8d 55 dc             	lea    -0x24(%ebp),%edx
 445:	8b 45 f4             	mov    -0xc(%ebp),%eax
 448:	01 d0                	add    %edx,%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	0f be c0             	movsbl %al,%eax
 450:	89 44 24 04          	mov    %eax,0x4(%esp)
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	89 04 24             	mov    %eax,(%esp)
 45a:	e8 31 ff ff ff       	call   390 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 467:	79 d9                	jns    442 <printint+0x8a>
    putc(fd, buf[i]);
}
 469:	83 c4 30             	add    $0x30,%esp
 46c:	5b                   	pop    %ebx
 46d:	5e                   	pop    %esi
 46e:	5d                   	pop    %ebp
 46f:	c3                   	ret    

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 476:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47d:	8d 45 0c             	lea    0xc(%ebp),%eax
 480:	83 c0 04             	add    $0x4,%eax
 483:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 486:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48d:	e9 7c 01 00 00       	jmp    60e <printf+0x19e>
    c = fmt[i] & 0xff;
 492:	8b 55 0c             	mov    0xc(%ebp),%edx
 495:	8b 45 f0             	mov    -0x10(%ebp),%eax
 498:	01 d0                	add    %edx,%eax
 49a:	0f b6 00             	movzbl (%eax),%eax
 49d:	0f be c0             	movsbl %al,%eax
 4a0:	25 ff 00 00 00       	and    $0xff,%eax
 4a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ac:	75 2c                	jne    4da <printf+0x6a>
      if(c == '%'){
 4ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b2:	75 0c                	jne    4c0 <printf+0x50>
        state = '%';
 4b4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bb:	e9 4a 01 00 00       	jmp    60a <printf+0x19a>
      } else {
        putc(fd, c);
 4c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c3:	0f be c0             	movsbl %al,%eax
 4c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	89 04 24             	mov    %eax,(%esp)
 4d0:	e8 bb fe ff ff       	call   390 <putc>
 4d5:	e9 30 01 00 00       	jmp    60a <printf+0x19a>
      }
    } else if(state == '%'){
 4da:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4de:	0f 85 26 01 00 00    	jne    60a <printf+0x19a>
      if(c == 'd'){
 4e4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e8:	75 2d                	jne    517 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ed:	8b 00                	mov    (%eax),%eax
 4ef:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f6:	00 
 4f7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fe:	00 
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 aa fe ff ff       	call   3b8 <printint>
        ap++;
 50e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 512:	e9 ec 00 00 00       	jmp    603 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 517:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51b:	74 06                	je     523 <printf+0xb3>
 51d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 521:	75 2d                	jne    550 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 523:	8b 45 e8             	mov    -0x18(%ebp),%eax
 526:	8b 00                	mov    (%eax),%eax
 528:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52f:	00 
 530:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 537:	00 
 538:	89 44 24 04          	mov    %eax,0x4(%esp)
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 71 fe ff ff       	call   3b8 <printint>
        ap++;
 547:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54b:	e9 b3 00 00 00       	jmp    603 <printf+0x193>
      } else if(c == 's'){
 550:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 554:	75 45                	jne    59b <printf+0x12b>
        s = (char*)*ap;
 556:	8b 45 e8             	mov    -0x18(%ebp),%eax
 559:	8b 00                	mov    (%eax),%eax
 55b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 566:	75 09                	jne    571 <printf+0x101>
          s = "(null)";
 568:	c7 45 f4 59 08 00 00 	movl   $0x859,-0xc(%ebp)
        while(*s != 0){
 56f:	eb 1e                	jmp    58f <printf+0x11f>
 571:	eb 1c                	jmp    58f <printf+0x11f>
          putc(fd, *s);
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 05 fe ff ff       	call   390 <putc>
          s++;
 58b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	84 c0                	test   %al,%al
 597:	75 da                	jne    573 <printf+0x103>
 599:	eb 68                	jmp    603 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59f:	75 1d                	jne    5be <printf+0x14e>
        putc(fd, *ap);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	89 04 24             	mov    %eax,(%esp)
 5b3:	e8 d8 fd ff ff       	call   390 <putc>
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	eb 45                	jmp    603 <printf+0x193>
      } else if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 17                	jne    5db <printf+0x16b>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 b7 fd ff ff       	call   390 <putc>
 5d9:	eb 28                	jmp    603 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e2:	00 
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 a2 fd ff ff       	call   390 <putc>
        putc(fd, c);
 5ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 8d fd ff ff       	call   390 <putc>
      }
      state = 0;
 603:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60e:	8b 55 0c             	mov    0xc(%ebp),%edx
 611:	8b 45 f0             	mov    -0x10(%ebp),%eax
 614:	01 d0                	add    %edx,%eax
 616:	0f b6 00             	movzbl (%eax),%eax
 619:	84 c0                	test   %al,%al
 61b:	0f 85 71 fe ff ff    	jne    492 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 621:	c9                   	leave  
 622:	c3                   	ret    

00000623 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 623:	55                   	push   %ebp
 624:	89 e5                	mov    %esp,%ebp
 626:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	83 e8 08             	sub    $0x8,%eax
 62f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 632:	a1 c0 0a 00 00       	mov    0xac0,%eax
 637:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63a:	eb 24                	jmp    660 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 644:	77 12                	ja     658 <free+0x35>
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64c:	77 24                	ja     672 <free+0x4f>
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 656:	77 1a                	ja     672 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	76 d4                	jbe    63c <free+0x19>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	76 ca                	jbe    63c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	8b 40 04             	mov    0x4(%eax),%eax
 678:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	01 c2                	add    %eax,%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	39 c2                	cmp    %eax,%edx
 68b:	75 24                	jne    6b1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	8b 40 04             	mov    0x4(%eax),%eax
 69b:	01 c2                	add    %eax,%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	8b 00                	mov    (%eax),%eax
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	89 10                	mov    %edx,(%eax)
 6af:	eb 0a                	jmp    6bb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 40 04             	mov    0x4(%eax),%eax
 6c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	01 d0                	add    %edx,%eax
 6cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d0:	75 20                	jne    6f2 <free+0xcf>
    p->s.size += bp->s.size;
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	01 c2                	add    %eax,%edx
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e9:	8b 10                	mov    (%eax),%edx
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	89 10                	mov    %edx,(%eax)
 6f0:	eb 08                	jmp    6fa <free+0xd7>
  } else
    p->s.ptr = bp;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f8:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 702:	c9                   	leave  
 703:	c3                   	ret    

00000704 <morecore>:

static Header*
morecore(uint nu)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 711:	77 07                	ja     71a <morecore+0x16>
    nu = 4096;
 713:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	c1 e0 03             	shl    $0x3,%eax
 720:	89 04 24             	mov    %eax,(%esp)
 723:	e8 18 fc ff ff       	call   340 <sbrk>
 728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72f:	75 07                	jne    738 <morecore+0x34>
    return 0;
 731:	b8 00 00 00 00       	mov    $0x0,%eax
 736:	eb 22                	jmp    75a <morecore+0x56>
  hp = (Header*)p;
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	8b 55 08             	mov    0x8(%ebp),%edx
 744:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74a:	83 c0 08             	add    $0x8,%eax
 74d:	89 04 24             	mov    %eax,(%esp)
 750:	e8 ce fe ff ff       	call   623 <free>
  return freep;
 755:	a1 c0 0a 00 00       	mov    0xac0,%eax
}
 75a:	c9                   	leave  
 75b:	c3                   	ret    

0000075c <malloc>:

void*
malloc(uint nbytes)
{
 75c:	55                   	push   %ebp
 75d:	89 e5                	mov    %esp,%ebp
 75f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 762:	8b 45 08             	mov    0x8(%ebp),%eax
 765:	83 c0 07             	add    $0x7,%eax
 768:	c1 e8 03             	shr    $0x3,%eax
 76b:	83 c0 01             	add    $0x1,%eax
 76e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 771:	a1 c0 0a 00 00       	mov    0xac0,%eax
 776:	89 45 f0             	mov    %eax,-0x10(%ebp)
 779:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77d:	75 23                	jne    7a2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 77f:	c7 45 f0 b8 0a 00 00 	movl   $0xab8,-0x10(%ebp)
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	a3 c0 0a 00 00       	mov    %eax,0xac0
 78e:	a1 c0 0a 00 00       	mov    0xac0,%eax
 793:	a3 b8 0a 00 00       	mov    %eax,0xab8
    base.s.size = 0;
 798:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 79f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b3:	72 4d                	jb     802 <malloc+0xa6>
      if(p->s.size == nunits)
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7be:	75 0c                	jne    7cc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 10                	mov    (%eax),%edx
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	89 10                	mov    %edx,(%eax)
 7ca:	eb 26                	jmp    7f2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d5:	89 c2                	mov    %eax,%edx
 7d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	c1 e0 03             	shl    $0x3,%eax
 7e6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f5:	a3 c0 0a 00 00       	mov    %eax,0xac0
      return (void*)(p + 1);
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	83 c0 08             	add    $0x8,%eax
 800:	eb 38                	jmp    83a <malloc+0xde>
    }
    if(p == freep)
 802:	a1 c0 0a 00 00       	mov    0xac0,%eax
 807:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80a:	75 1b                	jne    827 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 80c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80f:	89 04 24             	mov    %eax,(%esp)
 812:	e8 ed fe ff ff       	call   704 <morecore>
 817:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81e:	75 07                	jne    827 <malloc+0xcb>
        return 0;
 820:	b8 00 00 00 00       	mov    $0x0,%eax
 825:	eb 13                	jmp    83a <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 835:	e9 70 ff ff ff       	jmp    7aa <malloc+0x4e>
}
 83a:	c9                   	leave  
 83b:	c3                   	ret    
