
user/_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 41                	jle    5f <main+0x5f>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	43                   	inc    %ebx
  24:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  28:	39 f3                	cmp    %esi,%ebx
  2a:	74 1e                	je     4a <main+0x4a>
  2c:	68 48 06 00 00       	push   $0x648
  31:	50                   	push   %eax
  32:	68 4a 06 00 00       	push   $0x64a
  37:	6a 01                	push   $0x1
  39:	e8 26 03 00 00       	call   364 <printf>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	43                   	inc    %ebx
  42:	8b 44 9f fc          	mov    -0x4(%edi,%ebx,4),%eax
  46:	39 f3                	cmp    %esi,%ebx
  48:	75 e2                	jne    2c <main+0x2c>
  4a:	68 4f 06 00 00       	push   $0x64f
  4f:	50                   	push   %eax
  50:	68 4a 06 00 00       	push   $0x64a
  55:	6a 01                	push   $0x1
  57:	e8 08 03 00 00       	call   364 <printf>
  5c:	83 c4 10             	add    $0x10,%esp
  exit();
  5f:	e8 d7 01 00 00       	call   23b <exit>

00000064 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	53                   	push   %ebx
  68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	31 c0                	xor    %eax,%eax
  70:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  73:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  76:	40                   	inc    %eax
  77:	84 d2                	test   %dl,%dl
  79:	75 f5                	jne    70 <strcpy+0xc>
    ;
  return os;
}
  7b:	89 c8                	mov    %ecx,%eax
  7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80:	c9                   	leave  
  81:	c3                   	ret    
  82:	66 90                	xchg   %ax,%ax

00000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	8b 55 08             	mov    0x8(%ebp),%edx
  8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  8e:	0f b6 02             	movzbl (%edx),%eax
  91:	84 c0                	test   %al,%al
  93:	75 10                	jne    a5 <strcmp+0x21>
  95:	eb 2a                	jmp    c1 <strcmp+0x3d>
  97:	90                   	nop
    p++, q++;
  98:	42                   	inc    %edx
  99:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  9c:	0f b6 02             	movzbl (%edx),%eax
  9f:	84 c0                	test   %al,%al
  a1:	74 11                	je     b4 <strcmp+0x30>
    p++, q++;
  a3:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
  a5:	0f b6 0b             	movzbl (%ebx),%ecx
  a8:	38 c1                	cmp    %al,%cl
  aa:	74 ec                	je     98 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ac:	29 c8                	sub    %ecx,%eax
}
  ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b1:	c9                   	leave  
  b2:	c3                   	ret    
  b3:	90                   	nop
  return (uchar)*p - (uchar)*q;
  b4:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  b8:	31 c0                	xor    %eax,%eax
  ba:	29 c8                	sub    %ecx,%eax
}
  bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  bf:	c9                   	leave  
  c0:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  c1:	0f b6 0b             	movzbl (%ebx),%ecx
  c4:	31 c0                	xor    %eax,%eax
  c6:	eb e4                	jmp    ac <strcmp+0x28>

000000c8 <strlen>:

uint
strlen(const char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  ce:	80 3a 00             	cmpb   $0x0,(%edx)
  d1:	74 15                	je     e8 <strlen+0x20>
  d3:	31 c0                	xor    %eax,%eax
  d5:	8d 76 00             	lea    0x0(%esi),%esi
  d8:	40                   	inc    %eax
  d9:	89 c1                	mov    %eax,%ecx
  db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  df:	75 f7                	jne    d8 <strlen+0x10>
    ;
  return n;
}
  e1:	89 c8                	mov    %ecx,%eax
  e3:	5d                   	pop    %ebp
  e4:	c3                   	ret    
  e5:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  e8:	31 c9                	xor    %ecx,%ecx
}
  ea:	89 c8                	mov    %ecx,%eax
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
  ee:	66 90                	xchg   %ax,%ax

000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	fc                   	cld    
  fe:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 100:	8b 45 08             	mov    0x8(%ebp),%eax
 103:	8b 7d fc             	mov    -0x4(%ebp),%edi
 106:	c9                   	leave  
 107:	c3                   	ret    

00000108 <strchr>:

char*
strchr(const char *s, char c)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	75 0c                	jne    123 <strchr+0x1b>
 117:	eb 13                	jmp    12c <strchr+0x24>
 119:	8d 76 00             	lea    0x0(%esi),%esi
 11c:	40                   	inc    %eax
 11d:	8a 10                	mov    (%eax),%dl
 11f:	84 d2                	test   %dl,%dl
 121:	74 09                	je     12c <strchr+0x24>
    if(*s == c)
 123:	38 d1                	cmp    %dl,%cl
 125:	75 f5                	jne    11c <strchr+0x14>
      return (char*)s;
  return 0;
}
 127:	5d                   	pop    %ebp
 128:	c3                   	ret    
 129:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 12c:	31 c0                	xor    %eax,%eax
}
 12e:	5d                   	pop    %ebp
 12f:	c3                   	ret    

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
 135:	53                   	push   %ebx
 136:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 139:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 13b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 13e:	eb 24                	jmp    164 <gets+0x34>
    cc = read(0, &c, 1);
 140:	50                   	push   %eax
 141:	6a 01                	push   $0x1
 143:	57                   	push   %edi
 144:	6a 00                	push   $0x0
 146:	e8 08 01 00 00       	call   253 <read>
    if(cc < 1)
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	85 c0                	test   %eax,%eax
 150:	7e 1c                	jle    16e <gets+0x3e>
      break;
    buf[i++] = c;
 152:	8a 45 e7             	mov    -0x19(%ebp),%al
 155:	8b 55 08             	mov    0x8(%ebp),%edx
 158:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 15c:	3c 0a                	cmp    $0xa,%al
 15e:	74 20                	je     180 <gets+0x50>
 160:	3c 0d                	cmp    $0xd,%al
 162:	74 1c                	je     180 <gets+0x50>
  for(i=0; i+1 < max; ){
 164:	89 de                	mov    %ebx,%esi
 166:	8d 5b 01             	lea    0x1(%ebx),%ebx
 169:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 16c:	7c d2                	jl     140 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 175:	8d 65 f4             	lea    -0xc(%ebp),%esp
 178:	5b                   	pop    %ebx
 179:	5e                   	pop    %esi
 17a:	5f                   	pop    %edi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 189:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18c:	5b                   	pop    %ebx
 18d:	5e                   	pop    %esi
 18e:	5f                   	pop    %edi
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	8d 76 00             	lea    0x0(%esi),%esi

00000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	56                   	push   %esi
 198:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	6a 00                	push   $0x0
 19e:	ff 75 08             	push   0x8(%ebp)
 1a1:	e8 d5 00 00 00       	call   27b <open>
  if(fd < 0)
 1a6:	83 c4 10             	add    $0x10,%esp
 1a9:	85 c0                	test   %eax,%eax
 1ab:	78 27                	js     1d4 <stat+0x40>
 1ad:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	ff 75 0c             	push   0xc(%ebp)
 1b5:	50                   	push   %eax
 1b6:	e8 d8 00 00 00       	call   293 <fstat>
 1bb:	89 c6                	mov    %eax,%esi
  close(fd);
 1bd:	89 1c 24             	mov    %ebx,(%esp)
 1c0:	e8 9e 00 00 00       	call   263 <close>
  return r;
 1c5:	83 c4 10             	add    $0x10,%esp
}
 1c8:	89 f0                	mov    %esi,%eax
 1ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1cd:	5b                   	pop    %ebx
 1ce:	5e                   	pop    %esi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    
 1d1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1d4:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d9:	eb ed                	jmp    1c8 <stat+0x34>
 1db:	90                   	nop

000001dc <atoi>:

int
atoi(const char *s)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	53                   	push   %ebx
 1e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e3:	0f be 01             	movsbl (%ecx),%eax
 1e6:	8d 50 d0             	lea    -0x30(%eax),%edx
 1e9:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1ec:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1f1:	77 16                	ja     209 <atoi+0x2d>
 1f3:	90                   	nop
    n = n*10 + *s++ - '0';
 1f4:	41                   	inc    %ecx
 1f5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1f8:	01 d2                	add    %edx,%edx
 1fa:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1fe:	0f be 01             	movsbl (%ecx),%eax
 201:	8d 58 d0             	lea    -0x30(%eax),%ebx
 204:	80 fb 09             	cmp    $0x9,%bl
 207:	76 eb                	jbe    1f4 <atoi+0x18>
  return n;
}
 209:	89 d0                	mov    %edx,%eax
 20b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
 215:	8b 55 08             	mov    0x8(%ebp),%edx
 218:	8b 75 0c             	mov    0xc(%ebp),%esi
 21b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 21e:	85 c0                	test   %eax,%eax
 220:	7e 0b                	jle    22d <memmove+0x1d>
 222:	01 d0                	add    %edx,%eax
  dst = vdst;
 224:	89 d7                	mov    %edx,%edi
 226:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 228:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 229:	39 f8                	cmp    %edi,%eax
 22b:	75 fb                	jne    228 <memmove+0x18>
  return vdst;
}
 22d:	89 d0                	mov    %edx,%eax
 22f:	5e                   	pop    %esi
 230:	5f                   	pop    %edi
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 233:	b8 01 00 00 00       	mov    $0x1,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <exit>:
SYSCALL(exit)
 23b:	b8 02 00 00 00       	mov    $0x2,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <wait>:
SYSCALL(wait)
 243:	b8 03 00 00 00       	mov    $0x3,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <pipe>:
SYSCALL(pipe)
 24b:	b8 04 00 00 00       	mov    $0x4,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <read>:
SYSCALL(read)
 253:	b8 05 00 00 00       	mov    $0x5,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <write>:
SYSCALL(write)
 25b:	b8 10 00 00 00       	mov    $0x10,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <close>:
SYSCALL(close)
 263:	b8 15 00 00 00       	mov    $0x15,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <kill>:
SYSCALL(kill)
 26b:	b8 06 00 00 00       	mov    $0x6,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exec>:
SYSCALL(exec)
 273:	b8 07 00 00 00       	mov    $0x7,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <open>:
SYSCALL(open)
 27b:	b8 0f 00 00 00       	mov    $0xf,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <mknod>:
SYSCALL(mknod)
 283:	b8 11 00 00 00       	mov    $0x11,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <unlink>:
SYSCALL(unlink)
 28b:	b8 12 00 00 00       	mov    $0x12,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <fstat>:
SYSCALL(fstat)
 293:	b8 08 00 00 00       	mov    $0x8,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <link>:
SYSCALL(link)
 29b:	b8 13 00 00 00       	mov    $0x13,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <mkdir>:
SYSCALL(mkdir)
 2a3:	b8 14 00 00 00       	mov    $0x14,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <chdir>:
SYSCALL(chdir)
 2ab:	b8 09 00 00 00       	mov    $0x9,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <dup>:
SYSCALL(dup)
 2b3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <getpid>:
SYSCALL(getpid)
 2bb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <sbrk>:
SYSCALL(sbrk)
 2c3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <sleep>:
SYSCALL(sleep)
 2cb:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <uptime>:
 2d3:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    
 2db:	90                   	nop

000002dc <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2dc:	55                   	push   %ebp
 2dd:	89 e5                	mov    %esp,%ebp
 2df:	57                   	push   %edi
 2e0:	56                   	push   %esi
 2e1:	53                   	push   %ebx
 2e2:	83 ec 3c             	sub    $0x3c,%esp
 2e5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2e8:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2eb:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2f0:	85 db                	test   %ebx,%ebx
 2f2:	74 04                	je     2f8 <printint+0x1c>
 2f4:	85 d2                	test   %edx,%edx
 2f6:	78 68                	js     360 <printint+0x84>
  neg = 0;
 2f8:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2ff:	31 ff                	xor    %edi,%edi
 301:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 304:	89 c8                	mov    %ecx,%eax
 306:	31 d2                	xor    %edx,%edx
 308:	f7 75 c4             	divl   -0x3c(%ebp)
 30b:	89 fb                	mov    %edi,%ebx
 30d:	8d 7f 01             	lea    0x1(%edi),%edi
 310:	8a 92 b0 06 00 00    	mov    0x6b0(%edx),%dl
 316:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 31a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 31d:	89 c1                	mov    %eax,%ecx
 31f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 322:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 325:	76 dd                	jbe    304 <printint+0x28>
  if(neg)
 327:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32a:	85 c9                	test   %ecx,%ecx
 32c:	74 09                	je     337 <printint+0x5b>
    buf[i++] = '-';
 32e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 333:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 335:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 337:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 33b:	8b 7d bc             	mov    -0x44(%ebp),%edi
 33e:	eb 03                	jmp    343 <printint+0x67>
    putc(fd, buf[i]);
 340:	8a 13                	mov    (%ebx),%dl
 342:	4b                   	dec    %ebx
 343:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 346:	50                   	push   %eax
 347:	6a 01                	push   $0x1
 349:	56                   	push   %esi
 34a:	57                   	push   %edi
 34b:	e8 0b ff ff ff       	call   25b <write>
  while(--i >= 0)
 350:	83 c4 10             	add    $0x10,%esp
 353:	39 de                	cmp    %ebx,%esi
 355:	75 e9                	jne    340 <printint+0x64>
}
 357:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35a:	5b                   	pop    %ebx
 35b:	5e                   	pop    %esi
 35c:	5f                   	pop    %edi
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    
 35f:	90                   	nop
    x = -xx;
 360:	f7 d9                	neg    %ecx
 362:	eb 9b                	jmp    2ff <printint+0x23>

00000364 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	56                   	push   %esi
 369:	53                   	push   %ebx
 36a:	83 ec 2c             	sub    $0x2c,%esp
 36d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 373:	8a 13                	mov    (%ebx),%dl
 375:	84 d2                	test   %dl,%dl
 377:	74 64                	je     3dd <printf+0x79>
 379:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 37a:	8d 45 10             	lea    0x10(%ebp),%eax
 37d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 380:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 382:	8d 7d e7             	lea    -0x19(%ebp),%edi
 385:	eb 24                	jmp    3ab <printf+0x47>
 387:	90                   	nop
 388:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 38b:	83 f8 25             	cmp    $0x25,%eax
 38e:	74 40                	je     3d0 <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 390:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 393:	50                   	push   %eax
 394:	6a 01                	push   $0x1
 396:	57                   	push   %edi
 397:	56                   	push   %esi
 398:	e8 be fe ff ff       	call   25b <write>
        putc(fd, c);
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 3a3:	43                   	inc    %ebx
 3a4:	8a 53 ff             	mov    -0x1(%ebx),%dl
 3a7:	84 d2                	test   %dl,%dl
 3a9:	74 32                	je     3dd <printf+0x79>
    c = fmt[i] & 0xff;
 3ab:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 3ae:	85 c9                	test   %ecx,%ecx
 3b0:	74 d6                	je     388 <printf+0x24>
      }
    } else if(state == '%'){
 3b2:	83 f9 25             	cmp    $0x25,%ecx
 3b5:	75 ec                	jne    3a3 <printf+0x3f>
      if(c == 'd'){
 3b7:	83 f8 25             	cmp    $0x25,%eax
 3ba:	0f 84 e4 00 00 00    	je     4a4 <printf+0x140>
 3c0:	83 e8 63             	sub    $0x63,%eax
 3c3:	83 f8 15             	cmp    $0x15,%eax
 3c6:	77 20                	ja     3e8 <printf+0x84>
 3c8:	ff 24 85 58 06 00 00 	jmp    *0x658(,%eax,4)
 3cf:	90                   	nop
        state = '%';
 3d0:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 3d5:	43                   	inc    %ebx
 3d6:	8a 53 ff             	mov    -0x1(%ebx),%dl
 3d9:	84 d2                	test   %dl,%dl
 3db:	75 ce                	jne    3ab <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e0:	5b                   	pop    %ebx
 3e1:	5e                   	pop    %esi
 3e2:	5f                   	pop    %edi
 3e3:	5d                   	pop    %ebp
 3e4:	c3                   	ret    
 3e5:	8d 76 00             	lea    0x0(%esi),%esi
 3e8:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 3eb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3ef:	50                   	push   %eax
 3f0:	6a 01                	push   $0x1
 3f2:	57                   	push   %edi
 3f3:	56                   	push   %esi
 3f4:	e8 62 fe ff ff       	call   25b <write>
        putc(fd, c);
 3f9:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 3fc:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3ff:	83 c4 0c             	add    $0xc,%esp
 402:	6a 01                	push   $0x1
 404:	57                   	push   %edi
 405:	56                   	push   %esi
 406:	e8 50 fe ff ff       	call   25b <write>
        putc(fd, c);
 40b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40e:	31 c9                	xor    %ecx,%ecx
 410:	eb 91                	jmp    3a3 <printf+0x3f>
 412:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 414:	83 ec 0c             	sub    $0xc,%esp
 417:	6a 00                	push   $0x0
 419:	b9 10 00 00 00       	mov    $0x10,%ecx
 41e:	8b 45 d0             	mov    -0x30(%ebp),%eax
 421:	8b 10                	mov    (%eax),%edx
 423:	89 f0                	mov    %esi,%eax
 425:	e8 b2 fe ff ff       	call   2dc <printint>
        ap++;
 42a:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 42e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 431:	31 c9                	xor    %ecx,%ecx
        ap++;
 433:	e9 6b ff ff ff       	jmp    3a3 <printf+0x3f>
        s = (char*)*ap;
 438:	8b 45 d0             	mov    -0x30(%ebp),%eax
 43b:	8b 10                	mov    (%eax),%edx
        ap++;
 43d:	83 c0 04             	add    $0x4,%eax
 440:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 443:	85 d2                	test   %edx,%edx
 445:	74 69                	je     4b0 <printf+0x14c>
        while(*s != 0){
 447:	8a 02                	mov    (%edx),%al
 449:	84 c0                	test   %al,%al
 44b:	74 71                	je     4be <printf+0x15a>
 44d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 450:	89 d3                	mov    %edx,%ebx
 452:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 454:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 457:	50                   	push   %eax
 458:	6a 01                	push   $0x1
 45a:	57                   	push   %edi
 45b:	56                   	push   %esi
 45c:	e8 fa fd ff ff       	call   25b <write>
          s++;
 461:	43                   	inc    %ebx
        while(*s != 0){
 462:	8a 03                	mov    (%ebx),%al
 464:	83 c4 10             	add    $0x10,%esp
 467:	84 c0                	test   %al,%al
 469:	75 e9                	jne    454 <printf+0xf0>
      state = 0;
 46b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 46e:	31 c9                	xor    %ecx,%ecx
 470:	e9 2e ff ff ff       	jmp    3a3 <printf+0x3f>
 475:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 478:	83 ec 0c             	sub    $0xc,%esp
 47b:	6a 01                	push   $0x1
 47d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 482:	eb 9a                	jmp    41e <printf+0xba>
        putc(fd, *ap);
 484:	8b 45 d0             	mov    -0x30(%ebp),%eax
 487:	8b 00                	mov    (%eax),%eax
 489:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 48c:	51                   	push   %ecx
 48d:	6a 01                	push   $0x1
 48f:	57                   	push   %edi
 490:	56                   	push   %esi
 491:	e8 c5 fd ff ff       	call   25b <write>
        ap++;
 496:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 49a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 49d:	31 c9                	xor    %ecx,%ecx
 49f:	e9 ff fe ff ff       	jmp    3a3 <printf+0x3f>
        putc(fd, c);
 4a4:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 4a7:	52                   	push   %edx
 4a8:	e9 55 ff ff ff       	jmp    402 <printf+0x9e>
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 4b0:	ba 51 06 00 00       	mov    $0x651,%edx
        while(*s != 0){
 4b5:	b0 28                	mov    $0x28,%al
 4b7:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4ba:	89 d3                	mov    %edx,%ebx
 4bc:	eb 96                	jmp    454 <printf+0xf0>
      state = 0;
 4be:	31 c9                	xor    %ecx,%ecx
 4c0:	e9 de fe ff ff       	jmp    3a3 <printf+0x3f>
 4c5:	66 90                	xchg   %ax,%ax
 4c7:	90                   	nop

000004c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c8:	55                   	push   %ebp
 4c9:	89 e5                	mov    %esp,%ebp
 4cb:	57                   	push   %edi
 4cc:	56                   	push   %esi
 4cd:	53                   	push   %ebx
 4ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d4:	a1 c4 06 00 00       	mov    0x6c4,%eax
 4d9:	8d 76 00             	lea    0x0(%esi),%esi
 4dc:	89 c2                	mov    %eax,%edx
 4de:	8b 00                	mov    (%eax),%eax
 4e0:	39 ca                	cmp    %ecx,%edx
 4e2:	73 2c                	jae    510 <free+0x48>
 4e4:	39 c1                	cmp    %eax,%ecx
 4e6:	72 04                	jb     4ec <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e8:	39 c2                	cmp    %eax,%edx
 4ea:	72 f0                	jb     4dc <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4ec:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4ef:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4f2:	39 f8                	cmp    %edi,%eax
 4f4:	74 2c                	je     522 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4f6:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4f9:	8b 42 04             	mov    0x4(%edx),%eax
 4fc:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4ff:	39 f1                	cmp    %esi,%ecx
 501:	74 36                	je     539 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 503:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 505:	89 15 c4 06 00 00    	mov    %edx,0x6c4
}
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 510:	39 c2                	cmp    %eax,%edx
 512:	72 c8                	jb     4dc <free+0x14>
 514:	39 c1                	cmp    %eax,%ecx
 516:	73 c4                	jae    4dc <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 518:	8b 73 fc             	mov    -0x4(%ebx),%esi
 51b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 51e:	39 f8                	cmp    %edi,%eax
 520:	75 d4                	jne    4f6 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 522:	03 70 04             	add    0x4(%eax),%esi
 525:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 528:	8b 02                	mov    (%edx),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 52f:	8b 42 04             	mov    0x4(%edx),%eax
 532:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 535:	39 f1                	cmp    %esi,%ecx
 537:	75 ca                	jne    503 <free+0x3b>
    p->s.size += bp->s.size;
 539:	03 43 fc             	add    -0x4(%ebx),%eax
 53c:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 53f:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 542:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 544:	89 15 c4 06 00 00    	mov    %edx,0x6c4
}
 54a:	5b                   	pop    %ebx
 54b:	5e                   	pop    %esi
 54c:	5f                   	pop    %edi
 54d:	5d                   	pop    %ebp
 54e:	c3                   	ret    
 54f:	90                   	nop

00000550 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	8d 70 07             	lea    0x7(%eax),%esi
 55f:	c1 ee 03             	shr    $0x3,%esi
 562:	46                   	inc    %esi
  if((prevp = freep) == 0){
 563:	8b 3d c4 06 00 00    	mov    0x6c4,%edi
 569:	85 ff                	test   %edi,%edi
 56b:	0f 84 a3 00 00 00    	je     614 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 571:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 573:	8b 4a 04             	mov    0x4(%edx),%ecx
 576:	39 f1                	cmp    %esi,%ecx
 578:	73 68                	jae    5e2 <malloc+0x92>
 57a:	89 f3                	mov    %esi,%ebx
 57c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 582:	0f 82 80 00 00 00    	jb     608 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 588:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 58f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 592:	eb 11                	jmp    5a5 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 594:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 596:	8b 48 04             	mov    0x4(%eax),%ecx
 599:	39 f1                	cmp    %esi,%ecx
 59b:	73 4b                	jae    5e8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 59d:	8b 3d c4 06 00 00    	mov    0x6c4,%edi
 5a3:	89 c2                	mov    %eax,%edx
 5a5:	39 d7                	cmp    %edx,%edi
 5a7:	75 eb                	jne    594 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 5a9:	83 ec 0c             	sub    $0xc,%esp
 5ac:	ff 75 e4             	push   -0x1c(%ebp)
 5af:	e8 0f fd ff ff       	call   2c3 <sbrk>
  if(p == (char*)-1)
 5b4:	83 c4 10             	add    $0x10,%esp
 5b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ba:	74 1c                	je     5d8 <malloc+0x88>
  hp->s.size = nu;
 5bc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5bf:	83 ec 0c             	sub    $0xc,%esp
 5c2:	83 c0 08             	add    $0x8,%eax
 5c5:	50                   	push   %eax
 5c6:	e8 fd fe ff ff       	call   4c8 <free>
  return freep;
 5cb:	8b 15 c4 06 00 00    	mov    0x6c4,%edx
      if((p = morecore(nunits)) == 0)
 5d1:	83 c4 10             	add    $0x10,%esp
 5d4:	85 d2                	test   %edx,%edx
 5d6:	75 bc                	jne    594 <malloc+0x44>
        return 0;
 5d8:	31 c0                	xor    %eax,%eax
  }
}
 5da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5dd:	5b                   	pop    %ebx
 5de:	5e                   	pop    %esi
 5df:	5f                   	pop    %edi
 5e0:	5d                   	pop    %ebp
 5e1:	c3                   	ret    
    if(p->s.size >= nunits){
 5e2:	89 d0                	mov    %edx,%eax
 5e4:	89 fa                	mov    %edi,%edx
 5e6:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5e8:	39 ce                	cmp    %ecx,%esi
 5ea:	74 54                	je     640 <malloc+0xf0>
        p->s.size -= nunits;
 5ec:	29 f1                	sub    %esi,%ecx
 5ee:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5f4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 5f7:	89 15 c4 06 00 00    	mov    %edx,0x6c4
      return (void*)(p + 1);
 5fd:	83 c0 08             	add    $0x8,%eax
}
 600:	8d 65 f4             	lea    -0xc(%ebp),%esp
 603:	5b                   	pop    %ebx
 604:	5e                   	pop    %esi
 605:	5f                   	pop    %edi
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    
 608:	bb 00 10 00 00       	mov    $0x1000,%ebx
 60d:	e9 76 ff ff ff       	jmp    588 <malloc+0x38>
 612:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 614:	c7 05 c4 06 00 00 c8 	movl   $0x6c8,0x6c4
 61b:	06 00 00 
 61e:	c7 05 c8 06 00 00 c8 	movl   $0x6c8,0x6c8
 625:	06 00 00 
    base.s.size = 0;
 628:	c7 05 cc 06 00 00 00 	movl   $0x0,0x6cc
 62f:	00 00 00 
 632:	bf c8 06 00 00       	mov    $0x6c8,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 637:	89 fa                	mov    %edi,%edx
 639:	e9 3c ff ff ff       	jmp    57a <malloc+0x2a>
 63e:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 640:	8b 08                	mov    (%eax),%ecx
 642:	89 0a                	mov    %ecx,(%edx)
 644:	eb b1                	jmp    5f7 <malloc+0xa7>
