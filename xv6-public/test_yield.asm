
_test_yield:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp

    int pid;
    pid = fork();
   9:	e8 db 02 00 00       	call   2e9 <fork>
   e:	89 44 24 1c          	mov    %eax,0x1c(%esp)

    while(1){
        if(pid>0){
  12:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  17:	7e 27                	jle    40 <main+0x40>
            printf(1, "Child\n");
  19:	c7 44 24 04 7d 08 00 	movl   $0x87d,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 84 04 00 00       	call   4b1 <printf>
            yield();
  2d:	e8 6f 03 00 00       	call   3a1 <yield>
            sleep(1);
  32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  39:	e8 4b 03 00 00       	call   389 <sleep>
  3e:	eb 47                	jmp    87 <main+0x87>
        }
        else if(pid==0){
  40:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  45:	75 27                	jne    6e <main+0x6e>
            printf(1, "Parent\n");
  47:	c7 44 24 04 84 08 00 	movl   $0x884,0x4(%esp)
  4e:	00 
  4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  56:	e8 56 04 00 00       	call   4b1 <printf>
            yield();
  5b:	e8 41 03 00 00       	call   3a1 <yield>
            sleep(1);
  60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  67:	e8 1d 03 00 00       	call   389 <sleep>
  6c:	eb 19                	jmp    87 <main+0x87>
        }
        else{
            printf(1, "Fork error\n");
  6e:	c7 44 24 04 8c 08 00 	movl   $0x88c,0x4(%esp)
  75:	00 
  76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7d:	e8 2f 04 00 00       	call   4b1 <printf>
            exit();
  82:	e8 6a 02 00 00       	call   2f1 <exit>
        }

     }
  87:	eb 89                	jmp    12 <main+0x12>

00000089 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  8c:	57                   	push   %edi
  8d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  91:	8b 55 10             	mov    0x10(%ebp),%edx
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	89 cb                	mov    %ecx,%ebx
  99:	89 df                	mov    %ebx,%edi
  9b:	89 d1                	mov    %edx,%ecx
  9d:	fc                   	cld    
  9e:	f3 aa                	rep stos %al,%es:(%edi)
  a0:	89 ca                	mov    %ecx,%edx
  a2:	89 fb                	mov    %edi,%ebx
  a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
  a7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  aa:	5b                   	pop    %ebx
  ab:	5f                   	pop    %edi
  ac:	5d                   	pop    %ebp
  ad:	c3                   	ret    

000000ae <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ae:	55                   	push   %ebp
  af:	89 e5                	mov    %esp,%ebp
  b1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ba:	90                   	nop
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	8d 50 01             	lea    0x1(%eax),%edx
  c1:	89 55 08             	mov    %edx,0x8(%ebp)
  c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  cd:	0f b6 12             	movzbl (%edx),%edx
  d0:	88 10                	mov    %dl,(%eax)
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 e2                	jne    bb <strcpy+0xd>
    ;
  return os;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <strcmp>:

int
strcmp(const char *p, const char *q)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e1:	eb 08                	jmp    eb <strcmp+0xd>
    p++, q++;
  e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	84 c0                	test   %al,%al
  f3:	74 10                	je     105 <strcmp+0x27>
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	0f b6 00             	movzbl (%eax),%eax
 101:	38 c2                	cmp    %al,%dl
 103:	74 de                	je     e3 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	0f b6 d0             	movzbl %al,%edx
 10e:	8b 45 0c             	mov    0xc(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	0f b6 c0             	movzbl %al,%eax
 117:	29 c2                	sub    %eax,%edx
 119:	89 d0                	mov    %edx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 04                	jmp    130 <strlen+0x13>
 12c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 130:	8b 55 fc             	mov    -0x4(%ebp),%edx
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	01 d0                	add    %edx,%eax
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	84 c0                	test   %al,%al
 13d:	75 ed                	jne    12c <strlen+0xf>
    ;
  return n;
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 14a:	8b 45 10             	mov    0x10(%ebp),%eax
 14d:	89 44 24 08          	mov    %eax,0x8(%esp)
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	89 44 24 04          	mov    %eax,0x4(%esp)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	89 04 24             	mov    %eax,(%esp)
 15e:	e8 26 ff ff ff       	call   89 <stosb>
  return dst;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
}
 166:	c9                   	leave  
 167:	c3                   	ret    

00000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 174:	eb 14                	jmp    18a <strchr+0x22>
    if(*s == c)
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17f:	75 05                	jne    186 <strchr+0x1e>
      return (char*)s;
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	eb 13                	jmp    199 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	84 c0                	test   %al,%al
 192:	75 e2                	jne    176 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 194:	b8 00 00 00 00       	mov    $0x0,%eax
}
 199:	c9                   	leave  
 19a:	c3                   	ret    

0000019b <gets>:

char*
gets(char *buf, int max)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a8:	eb 4c                	jmp    1f6 <gets+0x5b>
    cc = read(0, &c, 1);
 1aa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b1:	00 
 1b2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c0:	e8 44 01 00 00       	call   309 <read>
 1c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cc:	7f 02                	jg     1d0 <gets+0x35>
      break;
 1ce:	eb 31                	jmp    201 <gets+0x66>
    buf[i++] = c;
 1d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d3:	8d 50 01             	lea    0x1(%eax),%edx
 1d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d9:	89 c2                	mov    %eax,%edx
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	01 c2                	add    %eax,%edx
 1e0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ea:	3c 0a                	cmp    $0xa,%al
 1ec:	74 13                	je     201 <gets+0x66>
 1ee:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f2:	3c 0d                	cmp    $0xd,%al
 1f4:	74 0b                	je     201 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f9:	83 c0 01             	add    $0x1,%eax
 1fc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ff:	7c a9                	jl     1aa <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 201:	8b 55 f4             	mov    -0xc(%ebp),%edx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	01 d0                	add    %edx,%eax
 209:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <stat>:

int
stat(char *n, struct stat *st)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 217:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21e:	00 
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	89 04 24             	mov    %eax,(%esp)
 225:	e8 07 01 00 00       	call   331 <open>
 22a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 22d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 231:	79 07                	jns    23a <stat+0x29>
    return -1;
 233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 238:	eb 23                	jmp    25d <stat+0x4c>
  r = fstat(fd, st);
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 44 24 04          	mov    %eax,0x4(%esp)
 241:	8b 45 f4             	mov    -0xc(%ebp),%eax
 244:	89 04 24             	mov    %eax,(%esp)
 247:	e8 fd 00 00 00       	call   349 <fstat>
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 24f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 252:	89 04 24             	mov    %eax,(%esp)
 255:	e8 bf 00 00 00       	call   319 <close>
  return r;
 25a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 25d:	c9                   	leave  
 25e:	c3                   	ret    

0000025f <atoi>:

int
atoi(const char *s)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 265:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26c:	eb 25                	jmp    293 <atoi+0x34>
    n = n*10 + *s++ - '0';
 26e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 271:	89 d0                	mov    %edx,%eax
 273:	c1 e0 02             	shl    $0x2,%eax
 276:	01 d0                	add    %edx,%eax
 278:	01 c0                	add    %eax,%eax
 27a:	89 c1                	mov    %eax,%ecx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	8d 50 01             	lea    0x1(%eax),%edx
 282:	89 55 08             	mov    %edx,0x8(%ebp)
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	0f be c0             	movsbl %al,%eax
 28b:	01 c8                	add    %ecx,%eax
 28d:	83 e8 30             	sub    $0x30,%eax
 290:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 2f                	cmp    $0x2f,%al
 29b:	7e 0a                	jle    2a7 <atoi+0x48>
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 39                	cmp    $0x39,%al
 2a5:	7e c7                	jle    26e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2be:	eb 17                	jmp    2d7 <memmove+0x2b>
    *dst++ = *src++;
 2c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c3:	8d 50 01             	lea    0x1(%eax),%edx
 2c6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2cf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d2:	0f b6 12             	movzbl (%edx),%edx
 2d5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d7:	8b 45 10             	mov    0x10(%ebp),%eax
 2da:	8d 50 ff             	lea    -0x1(%eax),%edx
 2dd:	89 55 10             	mov    %edx,0x10(%ebp)
 2e0:	85 c0                	test   %eax,%eax
 2e2:	7f dc                	jg     2c0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exit>:
SYSCALL(exit)
 2f1:	b8 02 00 00 00       	mov    $0x2,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <wait>:
SYSCALL(wait)
 2f9:	b8 03 00 00 00       	mov    $0x3,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <pipe>:
SYSCALL(pipe)
 301:	b8 04 00 00 00       	mov    $0x4,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <read>:
SYSCALL(read)
 309:	b8 05 00 00 00       	mov    $0x5,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <write>:
SYSCALL(write)
 311:	b8 10 00 00 00       	mov    $0x10,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <close>:
SYSCALL(close)
 319:	b8 15 00 00 00       	mov    $0x15,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <kill>:
SYSCALL(kill)
 321:	b8 06 00 00 00       	mov    $0x6,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exec>:
SYSCALL(exec)
 329:	b8 07 00 00 00       	mov    $0x7,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <open>:
SYSCALL(open)
 331:	b8 0f 00 00 00       	mov    $0xf,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mknod>:
SYSCALL(mknod)
 339:	b8 11 00 00 00       	mov    $0x11,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <unlink>:
SYSCALL(unlink)
 341:	b8 12 00 00 00       	mov    $0x12,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <fstat>:
SYSCALL(fstat)
 349:	b8 08 00 00 00       	mov    $0x8,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <link>:
SYSCALL(link)
 351:	b8 13 00 00 00       	mov    $0x13,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <mkdir>:
SYSCALL(mkdir)
 359:	b8 14 00 00 00       	mov    $0x14,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <chdir>:
SYSCALL(chdir)
 361:	b8 09 00 00 00       	mov    $0x9,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <dup>:
SYSCALL(dup)
 369:	b8 0a 00 00 00       	mov    $0xa,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <getpid>:
SYSCALL(getpid)
 371:	b8 0b 00 00 00       	mov    $0xb,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getppid>:
SYSCALL(getppid)
 379:	b8 17 00 00 00       	mov    $0x17,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sbrk>:
SYSCALL(sbrk)
 381:	b8 0c 00 00 00       	mov    $0xc,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sleep>:
SYSCALL(sleep)
 389:	b8 0d 00 00 00       	mov    $0xd,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <uptime>:
SYSCALL(uptime)
 391:	b8 0e 00 00 00       	mov    $0xe,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <my_syscall>:
SYSCALL(my_syscall)
 399:	b8 16 00 00 00       	mov    $0x16,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <yield>:
SYSCALL(yield)
 3a1:	b8 18 00 00 00       	mov    $0x18,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <getlev>:
SYSCALL(getlev)
 3a9:	b8 19 00 00 00       	mov    $0x19,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <set_cpu_share>:
SYSCALL(set_cpu_share)
 3b1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <thread_create>:
SYSCALL(thread_create)
 3b9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <thread_exit>:
SYSCALL(thread_exit)
 3c1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <thread_join>:
SYSCALL(thread_join)
 3c9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d1:	55                   	push   %ebp
 3d2:	89 e5                	mov    %esp,%ebp
 3d4:	83 ec 18             	sub    $0x18,%esp
 3d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3da:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e4:	00 
 3e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	89 04 24             	mov    %eax,(%esp)
 3f2:	e8 1a ff ff ff       	call   311 <write>
}
 3f7:	c9                   	leave  
 3f8:	c3                   	ret    

000003f9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f9:	55                   	push   %ebp
 3fa:	89 e5                	mov    %esp,%ebp
 3fc:	56                   	push   %esi
 3fd:	53                   	push   %ebx
 3fe:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 401:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 408:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40c:	74 17                	je     425 <printint+0x2c>
 40e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 412:	79 11                	jns    425 <printint+0x2c>
    neg = 1;
 414:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	f7 d8                	neg    %eax
 420:	89 45 ec             	mov    %eax,-0x14(%ebp)
 423:	eb 06                	jmp    42b <printint+0x32>
  } else {
    x = xx;
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 432:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 435:	8d 41 01             	lea    0x1(%ecx),%eax
 438:	89 45 f4             	mov    %eax,-0xc(%ebp)
 43b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 f3                	div    %ebx
 448:	89 d0                	mov    %edx,%eax
 44a:	0f b6 80 e4 0a 00 00 	movzbl 0xae4(%eax),%eax
 451:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 455:	8b 75 10             	mov    0x10(%ebp),%esi
 458:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45b:	ba 00 00 00 00       	mov    $0x0,%edx
 460:	f7 f6                	div    %esi
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
 465:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 469:	75 c7                	jne    432 <printint+0x39>
  if(neg)
 46b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46f:	74 10                	je     481 <printint+0x88>
    buf[i++] = '-';
 471:	8b 45 f4             	mov    -0xc(%ebp),%eax
 474:	8d 50 01             	lea    0x1(%eax),%edx
 477:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 47f:	eb 1f                	jmp    4a0 <printint+0xa7>
 481:	eb 1d                	jmp    4a0 <printint+0xa7>
    putc(fd, buf[i]);
 483:	8d 55 dc             	lea    -0x24(%ebp),%edx
 486:	8b 45 f4             	mov    -0xc(%ebp),%eax
 489:	01 d0                	add    %edx,%eax
 48b:	0f b6 00             	movzbl (%eax),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 31 ff ff ff       	call   3d1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4a0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a8:	79 d9                	jns    483 <printint+0x8a>
    putc(fd, buf[i]);
}
 4aa:	83 c4 30             	add    $0x30,%esp
 4ad:	5b                   	pop    %ebx
 4ae:	5e                   	pop    %esi
 4af:	5d                   	pop    %ebp
 4b0:	c3                   	ret    

000004b1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4be:	8d 45 0c             	lea    0xc(%ebp),%eax
 4c1:	83 c0 04             	add    $0x4,%eax
 4c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ce:	e9 7c 01 00 00       	jmp    64f <printf+0x19e>
    c = fmt[i] & 0xff;
 4d3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d9:	01 d0                	add    %edx,%eax
 4db:	0f b6 00             	movzbl (%eax),%eax
 4de:	0f be c0             	movsbl %al,%eax
 4e1:	25 ff 00 00 00       	and    $0xff,%eax
 4e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ed:	75 2c                	jne    51b <printf+0x6a>
      if(c == '%'){
 4ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4f3:	75 0c                	jne    501 <printf+0x50>
        state = '%';
 4f5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4fc:	e9 4a 01 00 00       	jmp    64b <printf+0x19a>
      } else {
        putc(fd, c);
 501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 504:	0f be c0             	movsbl %al,%eax
 507:	89 44 24 04          	mov    %eax,0x4(%esp)
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	89 04 24             	mov    %eax,(%esp)
 511:	e8 bb fe ff ff       	call   3d1 <putc>
 516:	e9 30 01 00 00       	jmp    64b <printf+0x19a>
      }
    } else if(state == '%'){
 51b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 51f:	0f 85 26 01 00 00    	jne    64b <printf+0x19a>
      if(c == 'd'){
 525:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 529:	75 2d                	jne    558 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 52b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52e:	8b 00                	mov    (%eax),%eax
 530:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 537:	00 
 538:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 53f:	00 
 540:	89 44 24 04          	mov    %eax,0x4(%esp)
 544:	8b 45 08             	mov    0x8(%ebp),%eax
 547:	89 04 24             	mov    %eax,(%esp)
 54a:	e8 aa fe ff ff       	call   3f9 <printint>
        ap++;
 54f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 553:	e9 ec 00 00 00       	jmp    644 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 558:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 55c:	74 06                	je     564 <printf+0xb3>
 55e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 562:	75 2d                	jne    591 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 564:	8b 45 e8             	mov    -0x18(%ebp),%eax
 567:	8b 00                	mov    (%eax),%eax
 569:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 570:	00 
 571:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 578:	00 
 579:	89 44 24 04          	mov    %eax,0x4(%esp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 04 24             	mov    %eax,(%esp)
 583:	e8 71 fe ff ff       	call   3f9 <printint>
        ap++;
 588:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58c:	e9 b3 00 00 00       	jmp    644 <printf+0x193>
      } else if(c == 's'){
 591:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 595:	75 45                	jne    5dc <printf+0x12b>
        s = (char*)*ap;
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 59f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a7:	75 09                	jne    5b2 <printf+0x101>
          s = "(null)";
 5a9:	c7 45 f4 98 08 00 00 	movl   $0x898,-0xc(%ebp)
        while(*s != 0){
 5b0:	eb 1e                	jmp    5d0 <printf+0x11f>
 5b2:	eb 1c                	jmp    5d0 <printf+0x11f>
          putc(fd, *s);
 5b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b7:	0f b6 00             	movzbl (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 05 fe ff ff       	call   3d1 <putc>
          s++;
 5cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d3:	0f b6 00             	movzbl (%eax),%eax
 5d6:	84 c0                	test   %al,%al
 5d8:	75 da                	jne    5b4 <printf+0x103>
 5da:	eb 68                	jmp    644 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e0:	75 1d                	jne    5ff <printf+0x14e>
        putc(fd, *ap);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	0f be c0             	movsbl %al,%eax
 5ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	89 04 24             	mov    %eax,(%esp)
 5f4:	e8 d8 fd ff ff       	call   3d1 <putc>
        ap++;
 5f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5fd:	eb 45                	jmp    644 <printf+0x193>
      } else if(c == '%'){
 5ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 603:	75 17                	jne    61c <printf+0x16b>
        putc(fd, c);
 605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 b7 fd ff ff       	call   3d1 <putc>
 61a:	eb 28                	jmp    644 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 61c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 623:	00 
 624:	8b 45 08             	mov    0x8(%ebp),%eax
 627:	89 04 24             	mov    %eax,(%esp)
 62a:	e8 a2 fd ff ff       	call   3d1 <putc>
        putc(fd, c);
 62f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 632:	0f be c0             	movsbl %al,%eax
 635:	89 44 24 04          	mov    %eax,0x4(%esp)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 8d fd ff ff       	call   3d1 <putc>
      }
      state = 0;
 644:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 64f:	8b 55 0c             	mov    0xc(%ebp),%edx
 652:	8b 45 f0             	mov    -0x10(%ebp),%eax
 655:	01 d0                	add    %edx,%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	84 c0                	test   %al,%al
 65c:	0f 85 71 fe ff ff    	jne    4d3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 662:	c9                   	leave  
 663:	c3                   	ret    

00000664 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	83 e8 08             	sub    $0x8,%eax
 670:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	a1 00 0b 00 00       	mov    0xb00,%eax
 678:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67b:	eb 24                	jmp    6a1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 685:	77 12                	ja     699 <free+0x35>
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68d:	77 24                	ja     6b3 <free+0x4f>
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	77 1a                	ja     6b3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a7:	76 d4                	jbe    67d <free+0x19>
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b1:	76 ca                	jbe    67d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 40 04             	mov    0x4(%eax),%eax
 6b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	01 c2                	add    %eax,%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	39 c2                	cmp    %eax,%edx
 6cc:	75 24                	jne    6f2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	8b 50 04             	mov    0x4(%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	8b 00                	mov    (%eax),%eax
 6e9:	8b 10                	mov    (%eax),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	89 10                	mov    %edx,(%eax)
 6f0:	eb 0a                	jmp    6fc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 40 04             	mov    0x4(%eax),%eax
 702:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	01 d0                	add    %edx,%eax
 70e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 711:	75 20                	jne    733 <free+0xcf>
    p->s.size += bp->s.size;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 50 04             	mov    0x4(%eax),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	8b 40 04             	mov    0x4(%eax),%eax
 71f:	01 c2                	add    %eax,%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	8b 10                	mov    (%eax),%edx
 72c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72f:	89 10                	mov    %edx,(%eax)
 731:	eb 08                	jmp    73b <free+0xd7>
  } else
    p->s.ptr = bp;
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 55 f8             	mov    -0x8(%ebp),%edx
 739:	89 10                	mov    %edx,(%eax)
  freep = p;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 743:	c9                   	leave  
 744:	c3                   	ret    

00000745 <morecore>:

static Header*
morecore(uint nu)
{
 745:	55                   	push   %ebp
 746:	89 e5                	mov    %esp,%ebp
 748:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 752:	77 07                	ja     75b <morecore+0x16>
    nu = 4096;
 754:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	c1 e0 03             	shl    $0x3,%eax
 761:	89 04 24             	mov    %eax,(%esp)
 764:	e8 18 fc ff ff       	call   381 <sbrk>
 769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 76c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 770:	75 07                	jne    779 <morecore+0x34>
    return 0;
 772:	b8 00 00 00 00       	mov    $0x0,%eax
 777:	eb 22                	jmp    79b <morecore+0x56>
  hp = (Header*)p;
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	8b 55 08             	mov    0x8(%ebp),%edx
 785:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	83 c0 08             	add    $0x8,%eax
 78e:	89 04 24             	mov    %eax,(%esp)
 791:	e8 ce fe ff ff       	call   664 <free>
  return freep;
 796:	a1 00 0b 00 00       	mov    0xb00,%eax
}
 79b:	c9                   	leave  
 79c:	c3                   	ret    

0000079d <malloc>:

void*
malloc(uint nbytes)
{
 79d:	55                   	push   %ebp
 79e:	89 e5                	mov    %esp,%ebp
 7a0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a3:	8b 45 08             	mov    0x8(%ebp),%eax
 7a6:	83 c0 07             	add    $0x7,%eax
 7a9:	c1 e8 03             	shr    $0x3,%eax
 7ac:	83 c0 01             	add    $0x1,%eax
 7af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7b2:	a1 00 0b 00 00       	mov    0xb00,%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7be:	75 23                	jne    7e3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 45 f0 f8 0a 00 00 	movl   $0xaf8,-0x10(%ebp)
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	a3 00 0b 00 00       	mov    %eax,0xb00
 7cf:	a1 00 0b 00 00       	mov    0xb00,%eax
 7d4:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    base.s.size = 0;
 7d9:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 7e0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f4:	72 4d                	jb     843 <malloc+0xa6>
      if(p->s.size == nunits)
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ff:	75 0c                	jne    80d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 10                	mov    (%eax),%edx
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	89 10                	mov    %edx,(%eax)
 80b:	eb 26                	jmp    833 <malloc+0x96>
      else {
        p->s.size -= nunits;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	2b 45 ec             	sub    -0x14(%ebp),%eax
 816:	89 c2                	mov    %eax,%edx
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	8b 40 04             	mov    0x4(%eax),%eax
 824:	c1 e0 03             	shl    $0x3,%eax
 827:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 830:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	a3 00 0b 00 00       	mov    %eax,0xb00
      return (void*)(p + 1);
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	83 c0 08             	add    $0x8,%eax
 841:	eb 38                	jmp    87b <malloc+0xde>
    }
    if(p == freep)
 843:	a1 00 0b 00 00       	mov    0xb00,%eax
 848:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 84b:	75 1b                	jne    868 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 84d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 ed fe ff ff       	call   745 <morecore>
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 07                	jne    868 <malloc+0xcb>
        return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 13                	jmp    87b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 876:	e9 70 ff ff ff       	jmp    7eb <malloc+0x4e>
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    
