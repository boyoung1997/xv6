
_test_stride:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define LIFETIME        1000        // (ticks)
#define COUNT_PERIOD    1000000     // (iteration)

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 30             	sub    $0x30,%esp
  uint i;
  int cnt = 0;
   9:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  10:	00 
  int cpu_share;
  uint start_tick;
  uint curr_tick;

  if (argc < 2) {
  11:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  15:	7f 19                	jg     30 <main+0x30>
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
  17:	c7 44 24 04 e0 08 00 	movl   $0x8e0,0x4(%esp)
  1e:	00 
  1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  26:	e8 e6 04 00 00       	call   511 <printf>
    exit();
  2b:	e8 21 03 00 00       	call   351 <exit>
  }

  cpu_share = atoi(argv[1]);
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 04 24             	mov    %eax,(%esp)
  3b:	e8 7f 02 00 00       	call   2bf <atoi>
  40:	89 44 24 24          	mov    %eax,0x24(%esp)

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
  44:	8b 44 24 24          	mov    0x24(%esp),%eax
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 c1 03 00 00       	call   411 <set_cpu_share>
  50:	85 c0                	test   %eax,%eax
  52:	79 19                	jns    6d <main+0x6d>
    printf(1, "cannot set cpu share\n");
  54:	c7 44 24 04 07 09 00 	movl   $0x907,0x4(%esp)
  5b:	00 
  5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  63:	e8 a9 04 00 00       	call   511 <printf>
    exit();
  68:	e8 e4 02 00 00       	call   351 <exit>
  }

  // Get start time
  start_tick = uptime();
  6d:	e8 7f 03 00 00       	call   3f1 <uptime>
  72:	89 44 24 20          	mov    %eax,0x20(%esp)

  i = 0;
  76:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  7d:	00 
  while (1) {
    i++;
  7e:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
    // Prevent code optimization
    __sync_synchronize();
  83:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    if (i == COUNT_PERIOD) {
  88:	81 7c 24 2c 40 42 0f 	cmpl   $0xf4240,0x2c(%esp)
  8f:	00 
  90:	75 55                	jne    e7 <main+0xe7>
      cnt++;
  92:	83 44 24 28 01       	addl   $0x1,0x28(%esp)
      // Get current time
      curr_tick = uptime();
  97:	e8 55 03 00 00       	call   3f1 <uptime>
  9c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
      if (curr_tick - start_tick > LIFETIME) {
  a0:	8b 44 24 20          	mov    0x20(%esp),%eax
  a4:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  a8:	29 c2                	sub    %eax,%edx
  aa:	89 d0                	mov    %edx,%eax
  ac:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  b1:	76 2a                	jbe    dd <main+0xdd>
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
  b3:	8b 44 24 28          	mov    0x28(%esp),%eax
  b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  bb:	8b 44 24 24          	mov    0x24(%esp),%eax
  bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  c3:	c7 44 24 04 1d 09 00 	movl   $0x91d,0x4(%esp)
  ca:	00 
  cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d2:	e8 3a 04 00 00       	call   511 <printf>
        break;
  d7:	90                   	nop
      }
      i = 0;
    }
  }

  exit();
  d8:	e8 74 02 00 00       	call   351 <exit>
      if (curr_tick - start_tick > LIFETIME) {
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
        break;
      }
      i = 0;
  dd:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  e4:	00 
    }
  }
  e5:	eb 97                	jmp    7e <main+0x7e>
  e7:	eb 95                	jmp    7e <main+0x7e>

000000e9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f1:	8b 55 10             	mov    0x10(%ebp),%edx
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	89 cb                	mov    %ecx,%ebx
  f9:	89 df                	mov    %ebx,%edi
  fb:	89 d1                	mov    %edx,%ecx
  fd:	fc                   	cld    
  fe:	f3 aa                	rep stos %al,%es:(%edi)
 100:	89 ca                	mov    %ecx,%edx
 102:	89 fb                	mov    %edi,%ebx
 104:	89 5d 08             	mov    %ebx,0x8(%ebp)
 107:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 10a:	5b                   	pop    %ebx
 10b:	5f                   	pop    %edi
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 11a:	90                   	nop
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8d 50 01             	lea    0x1(%eax),%edx
 121:	89 55 08             	mov    %edx,0x8(%ebp)
 124:	8b 55 0c             	mov    0xc(%ebp),%edx
 127:	8d 4a 01             	lea    0x1(%edx),%ecx
 12a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 12d:	0f b6 12             	movzbl (%edx),%edx
 130:	88 10                	mov    %dl,(%eax)
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 e2                	jne    11b <strcpy+0xd>
    ;
  return os;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 141:	eb 08                	jmp    14b <strcmp+0xd>
    p++, q++;
 143:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 147:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	84 c0                	test   %al,%al
 153:	74 10                	je     165 <strcmp+0x27>
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 10             	movzbl (%eax),%edx
 15b:	8b 45 0c             	mov    0xc(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	38 c2                	cmp    %al,%dl
 163:	74 de                	je     143 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	0f b6 d0             	movzbl %al,%edx
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f b6 c0             	movzbl %al,%eax
 177:	29 c2                	sub    %eax,%edx
 179:	89 d0                	mov    %edx,%eax
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <strlen>:

uint
strlen(char *s)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18a:	eb 04                	jmp    190 <strlen+0x13>
 18c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 190:	8b 55 fc             	mov    -0x4(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 ed                	jne    18c <strlen+0xf>
    ;
  return n;
 19f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1aa:	8b 45 10             	mov    0x10(%ebp),%eax
 1ad:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	89 04 24             	mov    %eax,(%esp)
 1be:	e8 26 ff ff ff       	call   e9 <stosb>
  return dst;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d4:	eb 14                	jmp    1ea <strchr+0x22>
    if(*s == c)
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1df:	75 05                	jne    1e6 <strchr+0x1e>
      return (char*)s;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	eb 13                	jmp    1f9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	84 c0                	test   %al,%al
 1f2:	75 e2                	jne    1d6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <gets>:

char*
gets(char *buf, int max)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 208:	eb 4c                	jmp    256 <gets+0x5b>
    cc = read(0, &c, 1);
 20a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 211:	00 
 212:	8d 45 ef             	lea    -0x11(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 220:	e8 44 01 00 00       	call   369 <read>
 225:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 228:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 22c:	7f 02                	jg     230 <gets+0x35>
      break;
 22e:	eb 31                	jmp    261 <gets+0x66>
    buf[i++] = c;
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	8d 50 01             	lea    0x1(%eax),%edx
 236:	89 55 f4             	mov    %edx,-0xc(%ebp)
 239:	89 c2                	mov    %eax,%edx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	01 c2                	add    %eax,%edx
 240:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 244:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 246:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24a:	3c 0a                	cmp    $0xa,%al
 24c:	74 13                	je     261 <gets+0x66>
 24e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 252:	3c 0d                	cmp    $0xd,%al
 254:	74 0b                	je     261 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	83 c0 01             	add    $0x1,%eax
 25c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25f:	7c a9                	jl     20a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 261:	8b 55 f4             	mov    -0xc(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <stat>:

int
stat(char *n, struct stat *st)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 277:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 27e:	00 
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	89 04 24             	mov    %eax,(%esp)
 285:	e8 07 01 00 00       	call   391 <open>
 28a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 291:	79 07                	jns    29a <stat+0x29>
    return -1;
 293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 298:	eb 23                	jmp    2bd <stat+0x4c>
  r = fstat(fd, st);
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a4:	89 04 24             	mov    %eax,(%esp)
 2a7:	e8 fd 00 00 00       	call   3a9 <fstat>
 2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b2:	89 04 24             	mov    %eax,(%esp)
 2b5:	e8 bf 00 00 00       	call   379 <close>
  return r;
 2ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <atoi>:

int
atoi(const char *s)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cc:	eb 25                	jmp    2f3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d1:	89 d0                	mov    %edx,%eax
 2d3:	c1 e0 02             	shl    $0x2,%eax
 2d6:	01 d0                	add    %edx,%eax
 2d8:	01 c0                	add    %eax,%eax
 2da:	89 c1                	mov    %eax,%ecx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	89 55 08             	mov    %edx,0x8(%ebp)
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	0f be c0             	movsbl %al,%eax
 2eb:	01 c8                	add    %ecx,%eax
 2ed:	83 e8 30             	sub    $0x30,%eax
 2f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 2f                	cmp    $0x2f,%al
 2fb:	7e 0a                	jle    307 <atoi+0x48>
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	3c 39                	cmp    $0x39,%al
 305:	7e c7                	jle    2ce <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 307:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30a:	c9                   	leave  
 30b:	c3                   	ret    

0000030c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31e:	eb 17                	jmp    337 <memmove+0x2b>
    *dst++ = *src++;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
 323:	8d 50 01             	lea    0x1(%eax),%edx
 326:	89 55 fc             	mov    %edx,-0x4(%ebp)
 329:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32c:	8d 4a 01             	lea    0x1(%edx),%ecx
 32f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 332:	0f b6 12             	movzbl (%edx),%edx
 335:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 337:	8b 45 10             	mov    0x10(%ebp),%eax
 33a:	8d 50 ff             	lea    -0x1(%eax),%edx
 33d:	89 55 10             	mov    %edx,0x10(%ebp)
 340:	85 c0                	test   %eax,%eax
 342:	7f dc                	jg     320 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 349:	b8 01 00 00 00       	mov    $0x1,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <exit>:
SYSCALL(exit)
 351:	b8 02 00 00 00       	mov    $0x2,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <wait>:
SYSCALL(wait)
 359:	b8 03 00 00 00       	mov    $0x3,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <pipe>:
SYSCALL(pipe)
 361:	b8 04 00 00 00       	mov    $0x4,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <read>:
SYSCALL(read)
 369:	b8 05 00 00 00       	mov    $0x5,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <write>:
SYSCALL(write)
 371:	b8 10 00 00 00       	mov    $0x10,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <close>:
SYSCALL(close)
 379:	b8 15 00 00 00       	mov    $0x15,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <kill>:
SYSCALL(kill)
 381:	b8 06 00 00 00       	mov    $0x6,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <exec>:
SYSCALL(exec)
 389:	b8 07 00 00 00       	mov    $0x7,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <open>:
SYSCALL(open)
 391:	b8 0f 00 00 00       	mov    $0xf,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <mknod>:
SYSCALL(mknod)
 399:	b8 11 00 00 00       	mov    $0x11,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <unlink>:
SYSCALL(unlink)
 3a1:	b8 12 00 00 00       	mov    $0x12,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <fstat>:
SYSCALL(fstat)
 3a9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <link>:
SYSCALL(link)
 3b1:	b8 13 00 00 00       	mov    $0x13,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mkdir>:
SYSCALL(mkdir)
 3b9:	b8 14 00 00 00       	mov    $0x14,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <chdir>:
SYSCALL(chdir)
 3c1:	b8 09 00 00 00       	mov    $0x9,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <dup>:
SYSCALL(dup)
 3c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getpid>:
SYSCALL(getpid)
 3d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <getppid>:
SYSCALL(getppid)
 3d9:	b8 17 00 00 00       	mov    $0x17,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <sbrk>:
SYSCALL(sbrk)
 3e1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <sleep>:
SYSCALL(sleep)
 3e9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <uptime>:
SYSCALL(uptime)
 3f1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <my_syscall>:
SYSCALL(my_syscall)
 3f9:	b8 16 00 00 00       	mov    $0x16,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <yield>:
SYSCALL(yield)
 401:	b8 18 00 00 00       	mov    $0x18,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <getlev>:
SYSCALL(getlev)
 409:	b8 19 00 00 00       	mov    $0x19,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <set_cpu_share>:
SYSCALL(set_cpu_share)
 411:	b8 1a 00 00 00       	mov    $0x1a,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <thread_create>:
SYSCALL(thread_create)
 419:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <thread_exit>:
SYSCALL(thread_exit)
 421:	b8 1c 00 00 00       	mov    $0x1c,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <thread_join>:
SYSCALL(thread_join)
 429:	b8 1d 00 00 00       	mov    $0x1d,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 18             	sub    $0x18,%esp
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 43d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 444:	00 
 445:	8d 45 f4             	lea    -0xc(%ebp),%eax
 448:	89 44 24 04          	mov    %eax,0x4(%esp)
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	89 04 24             	mov    %eax,(%esp)
 452:	e8 1a ff ff ff       	call   371 <write>
}
 457:	c9                   	leave  
 458:	c3                   	ret    

00000459 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 459:	55                   	push   %ebp
 45a:	89 e5                	mov    %esp,%ebp
 45c:	56                   	push   %esi
 45d:	53                   	push   %ebx
 45e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 461:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 468:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46c:	74 17                	je     485 <printint+0x2c>
 46e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 472:	79 11                	jns    485 <printint+0x2c>
    neg = 1;
 474:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 47b:	8b 45 0c             	mov    0xc(%ebp),%eax
 47e:	f7 d8                	neg    %eax
 480:	89 45 ec             	mov    %eax,-0x14(%ebp)
 483:	eb 06                	jmp    48b <printint+0x32>
  } else {
    x = xx;
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 48b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 492:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 495:	8d 41 01             	lea    0x1(%ecx),%eax
 498:	89 45 f4             	mov    %eax,-0xc(%ebp)
 49b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a1:	ba 00 00 00 00       	mov    $0x0,%edx
 4a6:	f7 f3                	div    %ebx
 4a8:	89 d0                	mov    %edx,%eax
 4aa:	0f b6 80 80 0b 00 00 	movzbl 0xb80(%eax),%eax
 4b1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b5:	8b 75 10             	mov    0x10(%ebp),%esi
 4b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bb:	ba 00 00 00 00       	mov    $0x0,%edx
 4c0:	f7 f6                	div    %esi
 4c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c9:	75 c7                	jne    492 <printint+0x39>
  if(neg)
 4cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cf:	74 10                	je     4e1 <printint+0x88>
    buf[i++] = '-';
 4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d4:	8d 50 01             	lea    0x1(%eax),%edx
 4d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4da:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4df:	eb 1f                	jmp    500 <printint+0xa7>
 4e1:	eb 1d                	jmp    500 <printint+0xa7>
    putc(fd, buf[i]);
 4e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	0f b6 00             	movzbl (%eax),%eax
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 31 ff ff ff       	call   431 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 500:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 508:	79 d9                	jns    4e3 <printint+0x8a>
    putc(fd, buf[i]);
}
 50a:	83 c4 30             	add    $0x30,%esp
 50d:	5b                   	pop    %ebx
 50e:	5e                   	pop    %esi
 50f:	5d                   	pop    %ebp
 510:	c3                   	ret    

00000511 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 517:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 51e:	8d 45 0c             	lea    0xc(%ebp),%eax
 521:	83 c0 04             	add    $0x4,%eax
 524:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 527:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 52e:	e9 7c 01 00 00       	jmp    6af <printf+0x19e>
    c = fmt[i] & 0xff;
 533:	8b 55 0c             	mov    0xc(%ebp),%edx
 536:	8b 45 f0             	mov    -0x10(%ebp),%eax
 539:	01 d0                	add    %edx,%eax
 53b:	0f b6 00             	movzbl (%eax),%eax
 53e:	0f be c0             	movsbl %al,%eax
 541:	25 ff 00 00 00       	and    $0xff,%eax
 546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 549:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54d:	75 2c                	jne    57b <printf+0x6a>
      if(c == '%'){
 54f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 553:	75 0c                	jne    561 <printf+0x50>
        state = '%';
 555:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 55c:	e9 4a 01 00 00       	jmp    6ab <printf+0x19a>
      } else {
        putc(fd, c);
 561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 564:	0f be c0             	movsbl %al,%eax
 567:	89 44 24 04          	mov    %eax,0x4(%esp)
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	89 04 24             	mov    %eax,(%esp)
 571:	e8 bb fe ff ff       	call   431 <putc>
 576:	e9 30 01 00 00       	jmp    6ab <printf+0x19a>
      }
    } else if(state == '%'){
 57b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 57f:	0f 85 26 01 00 00    	jne    6ab <printf+0x19a>
      if(c == 'd'){
 585:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 589:	75 2d                	jne    5b8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 597:	00 
 598:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 59f:	00 
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 aa fe ff ff       	call   459 <printint>
        ap++;
 5af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b3:	e9 ec 00 00 00       	jmp    6a4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5b8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5bc:	74 06                	je     5c4 <printf+0xb3>
 5be:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c2:	75 2d                	jne    5f1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c7:	8b 00                	mov    (%eax),%eax
 5c9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5d0:	00 
 5d1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5d8:	00 
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	89 04 24             	mov    %eax,(%esp)
 5e3:	e8 71 fe ff ff       	call   459 <printint>
        ap++;
 5e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ec:	e9 b3 00 00 00       	jmp    6a4 <printf+0x193>
      } else if(c == 's'){
 5f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5f5:	75 45                	jne    63c <printf+0x12b>
        s = (char*)*ap;
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 607:	75 09                	jne    612 <printf+0x101>
          s = "(null)";
 609:	c7 45 f4 34 09 00 00 	movl   $0x934,-0xc(%ebp)
        while(*s != 0){
 610:	eb 1e                	jmp    630 <printf+0x11f>
 612:	eb 1c                	jmp    630 <printf+0x11f>
          putc(fd, *s);
 614:	8b 45 f4             	mov    -0xc(%ebp),%eax
 617:	0f b6 00             	movzbl (%eax),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	89 44 24 04          	mov    %eax,0x4(%esp)
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	89 04 24             	mov    %eax,(%esp)
 627:	e8 05 fe ff ff       	call   431 <putc>
          s++;
 62c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 630:	8b 45 f4             	mov    -0xc(%ebp),%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	84 c0                	test   %al,%al
 638:	75 da                	jne    614 <printf+0x103>
 63a:	eb 68                	jmp    6a4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 640:	75 1d                	jne    65f <printf+0x14e>
        putc(fd, *ap);
 642:	8b 45 e8             	mov    -0x18(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	0f be c0             	movsbl %al,%eax
 64a:	89 44 24 04          	mov    %eax,0x4(%esp)
 64e:	8b 45 08             	mov    0x8(%ebp),%eax
 651:	89 04 24             	mov    %eax,(%esp)
 654:	e8 d8 fd ff ff       	call   431 <putc>
        ap++;
 659:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65d:	eb 45                	jmp    6a4 <printf+0x193>
      } else if(c == '%'){
 65f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 663:	75 17                	jne    67c <printf+0x16b>
        putc(fd, c);
 665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 668:	0f be c0             	movsbl %al,%eax
 66b:	89 44 24 04          	mov    %eax,0x4(%esp)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 b7 fd ff ff       	call   431 <putc>
 67a:	eb 28                	jmp    6a4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 683:	00 
 684:	8b 45 08             	mov    0x8(%ebp),%eax
 687:	89 04 24             	mov    %eax,(%esp)
 68a:	e8 a2 fd ff ff       	call   431 <putc>
        putc(fd, c);
 68f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 692:	0f be c0             	movsbl %al,%eax
 695:	89 44 24 04          	mov    %eax,0x4(%esp)
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	89 04 24             	mov    %eax,(%esp)
 69f:	e8 8d fd ff ff       	call   431 <putc>
      }
      state = 0;
 6a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6af:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b5:	01 d0                	add    %edx,%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	84 c0                	test   %al,%al
 6bc:	0f 85 71 fe ff ff    	jne    533 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c2:	c9                   	leave  
 6c3:	c3                   	ret    

000006c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
 6c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ca:	8b 45 08             	mov    0x8(%ebp),%eax
 6cd:	83 e8 08             	sub    $0x8,%eax
 6d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d3:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 6d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6db:	eb 24                	jmp    701 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e5:	77 12                	ja     6f9 <free+0x35>
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 24                	ja     713 <free+0x4f>
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f7:	77 1a                	ja     713 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 701:	8b 45 f8             	mov    -0x8(%ebp),%eax
 704:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 707:	76 d4                	jbe    6dd <free+0x19>
 709:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 711:	76 ca                	jbe    6dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	8b 40 04             	mov    0x4(%eax),%eax
 719:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	39 c2                	cmp    %eax,%edx
 72c:	75 24                	jne    752 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	8b 50 04             	mov    0x4(%eax),%edx
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	01 c2                	add    %eax,%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	8b 10                	mov    (%eax),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	89 10                	mov    %edx,(%eax)
 750:	eb 0a                	jmp    75c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 10                	mov    (%eax),%edx
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	01 d0                	add    %edx,%eax
 76e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 771:	75 20                	jne    793 <free+0xcf>
    p->s.size += bp->s.size;
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 50 04             	mov    0x4(%eax),%edx
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	01 c2                	add    %eax,%edx
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	89 10                	mov    %edx,(%eax)
 791:	eb 08                	jmp    79b <free+0xd7>
  } else
    p->s.ptr = bp;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 55 f8             	mov    -0x8(%ebp),%edx
 799:	89 10                	mov    %edx,(%eax)
  freep = p;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <morecore>:

static Header*
morecore(uint nu)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b2:	77 07                	ja     7bb <morecore+0x16>
    nu = 4096;
 7b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7bb:	8b 45 08             	mov    0x8(%ebp),%eax
 7be:	c1 e0 03             	shl    $0x3,%eax
 7c1:	89 04 24             	mov    %eax,(%esp)
 7c4:	e8 18 fc ff ff       	call   3e1 <sbrk>
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d0:	75 07                	jne    7d9 <morecore+0x34>
    return 0;
 7d2:	b8 00 00 00 00       	mov    $0x0,%eax
 7d7:	eb 22                	jmp    7fb <morecore+0x56>
  hp = (Header*)p;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	8b 55 08             	mov    0x8(%ebp),%edx
 7e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7eb:	83 c0 08             	add    $0x8,%eax
 7ee:	89 04 24             	mov    %eax,(%esp)
 7f1:	e8 ce fe ff ff       	call   6c4 <free>
  return freep;
 7f6:	a1 9c 0b 00 00       	mov    0xb9c,%eax
}
 7fb:	c9                   	leave  
 7fc:	c3                   	ret    

000007fd <malloc>:

void*
malloc(uint nbytes)
{
 7fd:	55                   	push   %ebp
 7fe:	89 e5                	mov    %esp,%ebp
 800:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 803:	8b 45 08             	mov    0x8(%ebp),%eax
 806:	83 c0 07             	add    $0x7,%eax
 809:	c1 e8 03             	shr    $0x3,%eax
 80c:	83 c0 01             	add    $0x1,%eax
 80f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 812:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 817:	89 45 f0             	mov    %eax,-0x10(%ebp)
 81a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81e:	75 23                	jne    843 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 820:	c7 45 f0 94 0b 00 00 	movl   $0xb94,-0x10(%ebp)
 827:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82a:	a3 9c 0b 00 00       	mov    %eax,0xb9c
 82f:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 834:	a3 94 0b 00 00       	mov    %eax,0xb94
    base.s.size = 0;
 839:	c7 05 98 0b 00 00 00 	movl   $0x0,0xb98
 840:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	8b 00                	mov    (%eax),%eax
 848:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 854:	72 4d                	jb     8a3 <malloc+0xa6>
      if(p->s.size == nunits)
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	8b 40 04             	mov    0x4(%eax),%eax
 85c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85f:	75 0c                	jne    86d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 10                	mov    (%eax),%edx
 866:	8b 45 f0             	mov    -0x10(%ebp),%eax
 869:	89 10                	mov    %edx,(%eax)
 86b:	eb 26                	jmp    893 <malloc+0x96>
      else {
        p->s.size -= nunits;
 86d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	2b 45 ec             	sub    -0x14(%ebp),%eax
 876:	89 c2                	mov    %eax,%edx
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	c1 e0 03             	shl    $0x3,%eax
 887:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 890:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	a3 9c 0b 00 00       	mov    %eax,0xb9c
      return (void*)(p + 1);
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	eb 38                	jmp    8db <malloc+0xde>
    }
    if(p == freep)
 8a3:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 8a8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ab:	75 1b                	jne    8c8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b0:	89 04 24             	mov    %eax,(%esp)
 8b3:	e8 ed fe ff ff       	call   7a5 <morecore>
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bf:	75 07                	jne    8c8 <malloc+0xcb>
        return 0;
 8c1:	b8 00 00 00 00       	mov    $0x0,%eax
 8c6:	eb 13                	jmp    8db <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	8b 00                	mov    (%eax),%eax
 8d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d6:	e9 70 ff ff ff       	jmp    84b <malloc+0x4e>
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    
