
_user_app:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char*argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
    __asm__("int $128");
   3:	cd 80                	int    $0x80
    return 0;
   5:	b8 00 00 00 00       	mov    $0x0,%eax
}
   a:	5d                   	pop    %ebp
   b:	c3                   	ret    

0000000c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
   c:	55                   	push   %ebp
   d:	89 e5                	mov    %esp,%ebp
   f:	57                   	push   %edi
  10:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  14:	8b 55 10             	mov    0x10(%ebp),%edx
  17:	8b 45 0c             	mov    0xc(%ebp),%eax
  1a:	89 cb                	mov    %ecx,%ebx
  1c:	89 df                	mov    %ebx,%edi
  1e:	89 d1                	mov    %edx,%ecx
  20:	fc                   	cld    
  21:	f3 aa                	rep stos %al,%es:(%edi)
  23:	89 ca                	mov    %ecx,%edx
  25:	89 fb                	mov    %edi,%ebx
  27:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  2d:	5b                   	pop    %ebx
  2e:	5f                   	pop    %edi
  2f:	5d                   	pop    %ebp
  30:	c3                   	ret    

00000031 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  31:	55                   	push   %ebp
  32:	89 e5                	mov    %esp,%ebp
  34:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  37:	8b 45 08             	mov    0x8(%ebp),%eax
  3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  3d:	90                   	nop
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 01             	lea    0x1(%eax),%edx
  44:	89 55 08             	mov    %edx,0x8(%ebp)
  47:	8b 55 0c             	mov    0xc(%ebp),%edx
  4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  4d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  50:	0f b6 12             	movzbl (%edx),%edx
  53:	88 10                	mov    %dl,(%eax)
  55:	0f b6 00             	movzbl (%eax),%eax
  58:	84 c0                	test   %al,%al
  5a:	75 e2                	jne    3e <strcpy+0xd>
    ;
  return os;
  5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  5f:	c9                   	leave  
  60:	c3                   	ret    

00000061 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  61:	55                   	push   %ebp
  62:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  64:	eb 08                	jmp    6e <strcmp+0xd>
    p++, q++;
  66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  6e:	8b 45 08             	mov    0x8(%ebp),%eax
  71:	0f b6 00             	movzbl (%eax),%eax
  74:	84 c0                	test   %al,%al
  76:	74 10                	je     88 <strcmp+0x27>
  78:	8b 45 08             	mov    0x8(%ebp),%eax
  7b:	0f b6 10             	movzbl (%eax),%edx
  7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  81:	0f b6 00             	movzbl (%eax),%eax
  84:	38 c2                	cmp    %al,%dl
  86:	74 de                	je     66 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	0f b6 00             	movzbl (%eax),%eax
  8e:	0f b6 d0             	movzbl %al,%edx
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	0f b6 00             	movzbl (%eax),%eax
  97:	0f b6 c0             	movzbl %al,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
}
  9e:	5d                   	pop    %ebp
  9f:	c3                   	ret    

000000a0 <strlen>:

uint
strlen(char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ad:	eb 04                	jmp    b3 <strlen+0x13>
  af:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  b6:	8b 45 08             	mov    0x8(%ebp),%eax
  b9:	01 d0                	add    %edx,%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	84 c0                	test   %al,%al
  c0:	75 ed                	jne    af <strlen+0xf>
    ;
  return n;
  c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  cd:	8b 45 10             	mov    0x10(%ebp),%eax
  d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	89 04 24             	mov    %eax,(%esp)
  e1:	e8 26 ff ff ff       	call   c <stosb>
  return dst;
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <strchr>:

char*
strchr(const char *s, char c)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 ec 04             	sub    $0x4,%esp
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f7:	eb 14                	jmp    10d <strchr+0x22>
    if(*s == c)
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 102:	75 05                	jne    109 <strchr+0x1e>
      return (char*)s;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	eb 13                	jmp    11c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 109:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	84 c0                	test   %al,%al
 115:	75 e2                	jne    f9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 117:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11c:	c9                   	leave  
 11d:	c3                   	ret    

0000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	55                   	push   %ebp
 11f:	89 e5                	mov    %esp,%ebp
 121:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 124:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12b:	eb 4c                	jmp    179 <gets+0x5b>
    cc = read(0, &c, 1);
 12d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 134:	00 
 135:	8d 45 ef             	lea    -0x11(%ebp),%eax
 138:	89 44 24 04          	mov    %eax,0x4(%esp)
 13c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 143:	e8 44 01 00 00       	call   28c <read>
 148:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14f:	7f 02                	jg     153 <gets+0x35>
      break;
 151:	eb 31                	jmp    184 <gets+0x66>
    buf[i++] = c;
 153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 156:	8d 50 01             	lea    0x1(%eax),%edx
 159:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15c:	89 c2                	mov    %eax,%edx
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	01 c2                	add    %eax,%edx
 163:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 167:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 169:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16d:	3c 0a                	cmp    $0xa,%al
 16f:	74 13                	je     184 <gets+0x66>
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	3c 0d                	cmp    $0xd,%al
 177:	74 0b                	je     184 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 179:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17c:	83 c0 01             	add    $0x1,%eax
 17f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 182:	7c a9                	jl     12d <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 184:	8b 55 f4             	mov    -0xc(%ebp),%edx
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	01 d0                	add    %edx,%eax
 18c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <stat>:

int
stat(char *n, struct stat *st)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a1:	00 
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	89 04 24             	mov    %eax,(%esp)
 1a8:	e8 07 01 00 00       	call   2b4 <open>
 1ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b4:	79 07                	jns    1bd <stat+0x29>
    return -1;
 1b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bb:	eb 23                	jmp    1e0 <stat+0x4c>
  r = fstat(fd, st);
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	89 04 24             	mov    %eax,(%esp)
 1ca:	e8 fd 00 00 00       	call   2cc <fstat>
 1cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 bf 00 00 00       	call   29c <close>
  return r;
 1dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1ef:	eb 25                	jmp    216 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	89 d0                	mov    %edx,%eax
 1f6:	c1 e0 02             	shl    $0x2,%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	01 c0                	add    %eax,%eax
 1fd:	89 c1                	mov    %eax,%ecx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	8d 50 01             	lea    0x1(%eax),%edx
 205:	89 55 08             	mov    %edx,0x8(%ebp)
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	0f be c0             	movsbl %al,%eax
 20e:	01 c8                	add    %ecx,%eax
 210:	83 e8 30             	sub    $0x30,%eax
 213:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	3c 2f                	cmp    $0x2f,%al
 21e:	7e 0a                	jle    22a <atoi+0x48>
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	3c 39                	cmp    $0x39,%al
 228:	7e c7                	jle    1f1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22d:	c9                   	leave  
 22e:	c3                   	ret    

0000022f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 241:	eb 17                	jmp    25a <memmove+0x2b>
    *dst++ = *src++;
 243:	8b 45 fc             	mov    -0x4(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 24f:	8d 4a 01             	lea    0x1(%edx),%ecx
 252:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 255:	0f b6 12             	movzbl (%edx),%edx
 258:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25a:	8b 45 10             	mov    0x10(%ebp),%eax
 25d:	8d 50 ff             	lea    -0x1(%eax),%edx
 260:	89 55 10             	mov    %edx,0x10(%ebp)
 263:	85 c0                	test   %eax,%eax
 265:	7f dc                	jg     243 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26a:	c9                   	leave  
 26b:	c3                   	ret    

0000026c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26c:	b8 01 00 00 00       	mov    $0x1,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <exit>:
SYSCALL(exit)
 274:	b8 02 00 00 00       	mov    $0x2,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <wait>:
SYSCALL(wait)
 27c:	b8 03 00 00 00       	mov    $0x3,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <pipe>:
SYSCALL(pipe)
 284:	b8 04 00 00 00       	mov    $0x4,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <read>:
SYSCALL(read)
 28c:	b8 05 00 00 00       	mov    $0x5,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <write>:
SYSCALL(write)
 294:	b8 10 00 00 00       	mov    $0x10,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <close>:
SYSCALL(close)
 29c:	b8 15 00 00 00       	mov    $0x15,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <kill>:
SYSCALL(kill)
 2a4:	b8 06 00 00 00       	mov    $0x6,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <exec>:
SYSCALL(exec)
 2ac:	b8 07 00 00 00       	mov    $0x7,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <open>:
SYSCALL(open)
 2b4:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <mknod>:
SYSCALL(mknod)
 2bc:	b8 11 00 00 00       	mov    $0x11,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <unlink>:
SYSCALL(unlink)
 2c4:	b8 12 00 00 00       	mov    $0x12,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <fstat>:
SYSCALL(fstat)
 2cc:	b8 08 00 00 00       	mov    $0x8,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <link>:
SYSCALL(link)
 2d4:	b8 13 00 00 00       	mov    $0x13,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <mkdir>:
SYSCALL(mkdir)
 2dc:	b8 14 00 00 00       	mov    $0x14,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <chdir>:
SYSCALL(chdir)
 2e4:	b8 09 00 00 00       	mov    $0x9,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <dup>:
SYSCALL(dup)
 2ec:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <getpid>:
SYSCALL(getpid)
 2f4:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <getppid>:
SYSCALL(getppid)
 2fc:	b8 17 00 00 00       	mov    $0x17,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sbrk>:
SYSCALL(sbrk)
 304:	b8 0c 00 00 00       	mov    $0xc,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <sleep>:
SYSCALL(sleep)
 30c:	b8 0d 00 00 00       	mov    $0xd,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <uptime>:
SYSCALL(uptime)
 314:	b8 0e 00 00 00       	mov    $0xe,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <my_syscall>:
SYSCALL(my_syscall)
 31c:	b8 16 00 00 00       	mov    $0x16,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <yield>:
SYSCALL(yield)
 324:	b8 18 00 00 00       	mov    $0x18,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <getlev>:
SYSCALL(getlev)
 32c:	b8 19 00 00 00       	mov    $0x19,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <set_cpu_share>:
SYSCALL(set_cpu_share)
 334:	b8 1a 00 00 00       	mov    $0x1a,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <thread_create>:
SYSCALL(thread_create)
 33c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <thread_exit>:
SYSCALL(thread_exit)
 344:	b8 1c 00 00 00       	mov    $0x1c,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <thread_join>:
SYSCALL(thread_join)
 34c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 18             	sub    $0x18,%esp
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 360:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 367:	00 
 368:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36b:	89 44 24 04          	mov    %eax,0x4(%esp)
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 1a ff ff ff       	call   294 <write>
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	56                   	push   %esi
 380:	53                   	push   %ebx
 381:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38f:	74 17                	je     3a8 <printint+0x2c>
 391:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 395:	79 11                	jns    3a8 <printint+0x2c>
    neg = 1;
 397:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	f7 d8                	neg    %eax
 3a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a6:	eb 06                	jmp    3ae <printint+0x32>
  } else {
    x = xx;
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b8:	8d 41 01             	lea    0x1(%ecx),%eax
 3bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f3                	div    %ebx
 3cb:	89 d0                	mov    %edx,%eax
 3cd:	0f b6 80 50 0a 00 00 	movzbl 0xa50(%eax),%eax
 3d4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d8:	8b 75 10             	mov    0x10(%ebp),%esi
 3db:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f6                	div    %esi
 3e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ec:	75 c7                	jne    3b5 <printint+0x39>
  if(neg)
 3ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f2:	74 10                	je     404 <printint+0x88>
    buf[i++] = '-';
 3f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 402:	eb 1f                	jmp    423 <printint+0xa7>
 404:	eb 1d                	jmp    423 <printint+0xa7>
    putc(fd, buf[i]);
 406:	8d 55 dc             	lea    -0x24(%ebp),%edx
 409:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40c:	01 d0                	add    %edx,%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	0f be c0             	movsbl %al,%eax
 414:	89 44 24 04          	mov    %eax,0x4(%esp)
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	89 04 24             	mov    %eax,(%esp)
 41e:	e8 31 ff ff ff       	call   354 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 423:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42b:	79 d9                	jns    406 <printint+0x8a>
    putc(fd, buf[i]);
}
 42d:	83 c4 30             	add    $0x30,%esp
 430:	5b                   	pop    %ebx
 431:	5e                   	pop    %esi
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    

00000434 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 441:	8d 45 0c             	lea    0xc(%ebp),%eax
 444:	83 c0 04             	add    $0x4,%eax
 447:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 451:	e9 7c 01 00 00       	jmp    5d2 <printf+0x19e>
    c = fmt[i] & 0xff;
 456:	8b 55 0c             	mov    0xc(%ebp),%edx
 459:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45c:	01 d0                	add    %edx,%eax
 45e:	0f b6 00             	movzbl (%eax),%eax
 461:	0f be c0             	movsbl %al,%eax
 464:	25 ff 00 00 00       	and    $0xff,%eax
 469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 470:	75 2c                	jne    49e <printf+0x6a>
      if(c == '%'){
 472:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 476:	75 0c                	jne    484 <printf+0x50>
        state = '%';
 478:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47f:	e9 4a 01 00 00       	jmp    5ce <printf+0x19a>
      } else {
        putc(fd, c);
 484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	89 44 24 04          	mov    %eax,0x4(%esp)
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	89 04 24             	mov    %eax,(%esp)
 494:	e8 bb fe ff ff       	call   354 <putc>
 499:	e9 30 01 00 00       	jmp    5ce <printf+0x19a>
      }
    } else if(state == '%'){
 49e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a2:	0f 85 26 01 00 00    	jne    5ce <printf+0x19a>
      if(c == 'd'){
 4a8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ac:	75 2d                	jne    4db <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b1:	8b 00                	mov    (%eax),%eax
 4b3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ba:	00 
 4bb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c2:	00 
 4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	89 04 24             	mov    %eax,(%esp)
 4cd:	e8 aa fe ff ff       	call   37c <printint>
        ap++;
 4d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d6:	e9 ec 00 00 00       	jmp    5c7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4db:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4df:	74 06                	je     4e7 <printf+0xb3>
 4e1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e5:	75 2d                	jne    514 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ea:	8b 00                	mov    (%eax),%eax
 4ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f3:	00 
 4f4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4fb:	00 
 4fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	89 04 24             	mov    %eax,(%esp)
 506:	e8 71 fe ff ff       	call   37c <printint>
        ap++;
 50b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50f:	e9 b3 00 00 00       	jmp    5c7 <printf+0x193>
      } else if(c == 's'){
 514:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 518:	75 45                	jne    55f <printf+0x12b>
        s = (char*)*ap;
 51a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51d:	8b 00                	mov    (%eax),%eax
 51f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52a:	75 09                	jne    535 <printf+0x101>
          s = "(null)";
 52c:	c7 45 f4 00 08 00 00 	movl   $0x800,-0xc(%ebp)
        while(*s != 0){
 533:	eb 1e                	jmp    553 <printf+0x11f>
 535:	eb 1c                	jmp    553 <printf+0x11f>
          putc(fd, *s);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	0f be c0             	movsbl %al,%eax
 540:	89 44 24 04          	mov    %eax,0x4(%esp)
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 05 fe ff ff       	call   354 <putc>
          s++;
 54f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	84 c0                	test   %al,%al
 55b:	75 da                	jne    537 <printf+0x103>
 55d:	eb 68                	jmp    5c7 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 563:	75 1d                	jne    582 <printf+0x14e>
        putc(fd, *ap);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 d8 fd ff ff       	call   354 <putc>
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	eb 45                	jmp    5c7 <printf+0x193>
      } else if(c == '%'){
 582:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 586:	75 17                	jne    59f <printf+0x16b>
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 b7 fd ff ff       	call   354 <putc>
 59d:	eb 28                	jmp    5c7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a6:	00 
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 a2 fd ff ff       	call   354 <putc>
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 8d fd ff ff       	call   354 <putc>
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	0f 85 71 fe ff ff    	jne    456 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e5:	c9                   	leave  
 5e6:	c3                   	ret    

000005e7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e7:	55                   	push   %ebp
 5e8:	89 e5                	mov    %esp,%ebp
 5ea:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	83 e8 08             	sub    $0x8,%eax
 5f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f6:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 5fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fe:	eb 24                	jmp    624 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 608:	77 12                	ja     61c <free+0x35>
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 610:	77 24                	ja     636 <free+0x4f>
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61a:	77 1a                	ja     636 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	89 45 fc             	mov    %eax,-0x4(%ebp)
 624:	8b 45 f8             	mov    -0x8(%ebp),%eax
 627:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62a:	76 d4                	jbe    600 <free+0x19>
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 634:	76 ca                	jbe    600 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	8b 40 04             	mov    0x4(%eax),%eax
 63c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	01 c2                	add    %eax,%edx
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	39 c2                	cmp    %eax,%edx
 64f:	75 24                	jne    675 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	8b 50 04             	mov    0x4(%eax),%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	8b 40 04             	mov    0x4(%eax),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	8b 10                	mov    (%eax),%edx
 66e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 671:	89 10                	mov    %edx,(%eax)
 673:	eb 0a                	jmp    67f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 40 04             	mov    0x4(%eax),%eax
 685:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	01 d0                	add    %edx,%eax
 691:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 694:	75 20                	jne    6b6 <free+0xcf>
    p->s.size += bp->s.size;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 50 04             	mov    0x4(%eax),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	01 c2                	add    %eax,%edx
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
 6b4:	eb 08                	jmp    6be <free+0xd7>
  } else
    p->s.ptr = bp;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	a3 6c 0a 00 00       	mov    %eax,0xa6c
}
 6c6:	c9                   	leave  
 6c7:	c3                   	ret    

000006c8 <morecore>:

static Header*
morecore(uint nu)
{
 6c8:	55                   	push   %ebp
 6c9:	89 e5                	mov    %esp,%ebp
 6cb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ce:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d5:	77 07                	ja     6de <morecore+0x16>
    nu = 4096;
 6d7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	c1 e0 03             	shl    $0x3,%eax
 6e4:	89 04 24             	mov    %eax,(%esp)
 6e7:	e8 18 fc ff ff       	call   304 <sbrk>
 6ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f3:	75 07                	jne    6fc <morecore+0x34>
    return 0;
 6f5:	b8 00 00 00 00       	mov    $0x0,%eax
 6fa:	eb 22                	jmp    71e <morecore+0x56>
  hp = (Header*)p;
 6fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 702:	8b 45 f0             	mov    -0x10(%ebp),%eax
 705:	8b 55 08             	mov    0x8(%ebp),%edx
 708:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70e:	83 c0 08             	add    $0x8,%eax
 711:	89 04 24             	mov    %eax,(%esp)
 714:	e8 ce fe ff ff       	call   5e7 <free>
  return freep;
 719:	a1 6c 0a 00 00       	mov    0xa6c,%eax
}
 71e:	c9                   	leave  
 71f:	c3                   	ret    

00000720 <malloc>:

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	83 c0 07             	add    $0x7,%eax
 72c:	c1 e8 03             	shr    $0x3,%eax
 72f:	83 c0 01             	add    $0x1,%eax
 732:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 735:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 73a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 741:	75 23                	jne    766 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 743:	c7 45 f0 64 0a 00 00 	movl   $0xa64,-0x10(%ebp)
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	a3 6c 0a 00 00       	mov    %eax,0xa6c
 752:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 757:	a3 64 0a 00 00       	mov    %eax,0xa64
    base.s.size = 0;
 75c:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 763:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 777:	72 4d                	jb     7c6 <malloc+0xa6>
      if(p->s.size == nunits)
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	75 0c                	jne    790 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 10                	mov    (%eax),%edx
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	89 10                	mov    %edx,(%eax)
 78e:	eb 26                	jmp    7b6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	2b 45 ec             	sub    -0x14(%ebp),%eax
 799:	89 c2                	mov    %eax,%edx
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	c1 e0 03             	shl    $0x3,%eax
 7aa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	a3 6c 0a 00 00       	mov    %eax,0xa6c
      return (void*)(p + 1);
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	83 c0 08             	add    $0x8,%eax
 7c4:	eb 38                	jmp    7fe <malloc+0xde>
    }
    if(p == freep)
 7c6:	a1 6c 0a 00 00       	mov    0xa6c,%eax
 7cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ce:	75 1b                	jne    7eb <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d3:	89 04 24             	mov    %eax,(%esp)
 7d6:	e8 ed fe ff ff       	call   6c8 <morecore>
 7db:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e2:	75 07                	jne    7eb <malloc+0xcb>
        return 0;
 7e4:	b8 00 00 00 00       	mov    $0x0,%eax
 7e9:	eb 13                	jmp    7fe <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f9:	e9 70 ff ff ff       	jmp    76e <malloc+0x4e>
}
 7fe:	c9                   	leave  
 7ff:	c3                   	ret    
