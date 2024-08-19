
user/_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 26                	jle    44 <main+0x44>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	90                   	nop
    kill(atoi(argv[i]));
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 34 9f             	push   (%edi,%ebx,4)
  2a:	e8 a1 01 00 00       	call   1d0 <atoi>
  2f:	89 04 24             	mov    %eax,(%esp)
  32:	e8 28 02 00 00       	call   25f <kill>
  for(i=1; i<argc; i++)
  37:	43                   	inc    %ebx
  38:	83 c4 10             	add    $0x10,%esp
  3b:	39 de                	cmp    %ebx,%esi
  3d:	75 e5                	jne    24 <main+0x24>
  exit();
  3f:	e8 eb 01 00 00       	call   22f <exit>
    printf(2, "usage: kill pid...\n");
  44:	50                   	push   %eax
  45:	50                   	push   %eax
  46:	68 3c 06 00 00       	push   $0x63c
  4b:	6a 02                	push   $0x2
  4d:	e8 06 03 00 00       	call   358 <printf>
    exit();
  52:	e8 d8 01 00 00       	call   22f <exit>
  57:	90                   	nop

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	53                   	push   %ebx
  5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  5f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  62:	31 c0                	xor    %eax,%eax
  64:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  67:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  6a:	40                   	inc    %eax
  6b:	84 d2                	test   %dl,%dl
  6d:	75 f5                	jne    64 <strcpy+0xc>
    ;
  return os;
}
  6f:	89 c8                	mov    %ecx,%eax
  71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  74:	c9                   	leave  
  75:	c3                   	ret    
  76:	66 90                	xchg   %ax,%ax

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	53                   	push   %ebx
  7c:	8b 55 08             	mov    0x8(%ebp),%edx
  7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  82:	0f b6 02             	movzbl (%edx),%eax
  85:	84 c0                	test   %al,%al
  87:	75 10                	jne    99 <strcmp+0x21>
  89:	eb 2a                	jmp    b5 <strcmp+0x3d>
  8b:	90                   	nop
    p++, q++;
  8c:	42                   	inc    %edx
  8d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
  90:	0f b6 02             	movzbl (%edx),%eax
  93:	84 c0                	test   %al,%al
  95:	74 11                	je     a8 <strcmp+0x30>
    p++, q++;
  97:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
  99:	0f b6 0b             	movzbl (%ebx),%ecx
  9c:	38 c1                	cmp    %al,%cl
  9e:	74 ec                	je     8c <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a0:	29 c8                	sub    %ecx,%eax
}
  a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a5:	c9                   	leave  
  a6:	c3                   	ret    
  a7:	90                   	nop
  return (uchar)*p - (uchar)*q;
  a8:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
  ac:	31 c0                	xor    %eax,%eax
  ae:	29 c8                	sub    %ecx,%eax
}
  b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b3:	c9                   	leave  
  b4:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  b5:	0f b6 0b             	movzbl (%ebx),%ecx
  b8:	31 c0                	xor    %eax,%eax
  ba:	eb e4                	jmp    a0 <strcmp+0x28>

000000bc <strlen>:

uint
strlen(const char *s)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  c2:	80 3a 00             	cmpb   $0x0,(%edx)
  c5:	74 15                	je     dc <strlen+0x20>
  c7:	31 c0                	xor    %eax,%eax
  c9:	8d 76 00             	lea    0x0(%esi),%esi
  cc:	40                   	inc    %eax
  cd:	89 c1                	mov    %eax,%ecx
  cf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  d3:	75 f7                	jne    cc <strlen+0x10>
    ;
  return n;
}
  d5:	89 c8                	mov    %ecx,%eax
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    
  d9:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  dc:	31 c9                	xor    %ecx,%ecx
}
  de:	89 c8                	mov    %ecx,%eax
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    
  e2:	66 90                	xchg   %ax,%ax

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e8:	8b 7d 08             	mov    0x8(%ebp),%edi
  eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  f1:	fc                   	cld    
  f2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <strchr>:

char*
strchr(const char *s, char c)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	8b 45 08             	mov    0x8(%ebp),%eax
 102:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 105:	8a 10                	mov    (%eax),%dl
 107:	84 d2                	test   %dl,%dl
 109:	75 0c                	jne    117 <strchr+0x1b>
 10b:	eb 13                	jmp    120 <strchr+0x24>
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	40                   	inc    %eax
 111:	8a 10                	mov    (%eax),%dl
 113:	84 d2                	test   %dl,%dl
 115:	74 09                	je     120 <strchr+0x24>
    if(*s == c)
 117:	38 d1                	cmp    %dl,%cl
 119:	75 f5                	jne    110 <strchr+0x14>
      return (char*)s;
  return 0;
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 120:	31 c0                	xor    %eax,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	56                   	push   %esi
 129:	53                   	push   %ebx
 12a:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12d:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 12f:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 132:	eb 24                	jmp    158 <gets+0x34>
    cc = read(0, &c, 1);
 134:	50                   	push   %eax
 135:	6a 01                	push   $0x1
 137:	57                   	push   %edi
 138:	6a 00                	push   $0x0
 13a:	e8 08 01 00 00       	call   247 <read>
    if(cc < 1)
 13f:	83 c4 10             	add    $0x10,%esp
 142:	85 c0                	test   %eax,%eax
 144:	7e 1c                	jle    162 <gets+0x3e>
      break;
    buf[i++] = c;
 146:	8a 45 e7             	mov    -0x19(%ebp),%al
 149:	8b 55 08             	mov    0x8(%ebp),%edx
 14c:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 150:	3c 0a                	cmp    $0xa,%al
 152:	74 20                	je     174 <gets+0x50>
 154:	3c 0d                	cmp    $0xd,%al
 156:	74 1c                	je     174 <gets+0x50>
  for(i=0; i+1 < max; ){
 158:	89 de                	mov    %ebx,%esi
 15a:	8d 5b 01             	lea    0x1(%ebx),%ebx
 15d:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 160:	7c d2                	jl     134 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 169:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16c:	5b                   	pop    %ebx
 16d:	5e                   	pop    %esi
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	8d 76 00             	lea    0x0(%esi),%esi
 174:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 17d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5f                   	pop    %edi
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    
 185:	8d 76 00             	lea    0x0(%esi),%esi

00000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	56                   	push   %esi
 18c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18d:	83 ec 08             	sub    $0x8,%esp
 190:	6a 00                	push   $0x0
 192:	ff 75 08             	push   0x8(%ebp)
 195:	e8 d5 00 00 00       	call   26f <open>
  if(fd < 0)
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	85 c0                	test   %eax,%eax
 19f:	78 27                	js     1c8 <stat+0x40>
 1a1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	ff 75 0c             	push   0xc(%ebp)
 1a9:	50                   	push   %eax
 1aa:	e8 d8 00 00 00       	call   287 <fstat>
 1af:	89 c6                	mov    %eax,%esi
  close(fd);
 1b1:	89 1c 24             	mov    %ebx,(%esp)
 1b4:	e8 9e 00 00 00       	call   257 <close>
  return r;
 1b9:	83 c4 10             	add    $0x10,%esp
}
 1bc:	89 f0                	mov    %esi,%eax
 1be:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c1:	5b                   	pop    %ebx
 1c2:	5e                   	pop    %esi
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cd:	eb ed                	jmp    1bc <stat+0x34>
 1cf:	90                   	nop

000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d7:	0f be 01             	movsbl (%ecx),%eax
 1da:	8d 50 d0             	lea    -0x30(%eax),%edx
 1dd:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 1e0:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1e5:	77 16                	ja     1fd <atoi+0x2d>
 1e7:	90                   	nop
    n = n*10 + *s++ - '0';
 1e8:	41                   	inc    %ecx
 1e9:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1ec:	01 d2                	add    %edx,%edx
 1ee:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 1f2:	0f be 01             	movsbl (%ecx),%eax
 1f5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1f8:	80 fb 09             	cmp    $0x9,%bl
 1fb:	76 eb                	jbe    1e8 <atoi+0x18>
  return n;
}
 1fd:	89 d0                	mov    %edx,%eax
 1ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 202:	c9                   	leave  
 203:	c3                   	ret    

00000204 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	56                   	push   %esi
 209:	8b 55 08             	mov    0x8(%ebp),%edx
 20c:	8b 75 0c             	mov    0xc(%ebp),%esi
 20f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 212:	85 c0                	test   %eax,%eax
 214:	7e 0b                	jle    221 <memmove+0x1d>
 216:	01 d0                	add    %edx,%eax
  dst = vdst;
 218:	89 d7                	mov    %edx,%edi
 21a:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 21c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 21d:	39 f8                	cmp    %edi,%eax
 21f:	75 fb                	jne    21c <memmove+0x18>
  return vdst;
}
 221:	89 d0                	mov    %edx,%eax
 223:	5e                   	pop    %esi
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    

00000227 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 227:	b8 01 00 00 00       	mov    $0x1,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <exit>:
SYSCALL(exit)
 22f:	b8 02 00 00 00       	mov    $0x2,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <wait>:
SYSCALL(wait)
 237:	b8 03 00 00 00       	mov    $0x3,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <pipe>:
SYSCALL(pipe)
 23f:	b8 04 00 00 00       	mov    $0x4,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <read>:
SYSCALL(read)
 247:	b8 05 00 00 00       	mov    $0x5,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <write>:
SYSCALL(write)
 24f:	b8 10 00 00 00       	mov    $0x10,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <close>:
SYSCALL(close)
 257:	b8 15 00 00 00       	mov    $0x15,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <kill>:
SYSCALL(kill)
 25f:	b8 06 00 00 00       	mov    $0x6,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <exec>:
SYSCALL(exec)
 267:	b8 07 00 00 00       	mov    $0x7,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <open>:
SYSCALL(open)
 26f:	b8 0f 00 00 00       	mov    $0xf,%eax
 274:	cd 40                	int    $0x40
 276:	c3                   	ret    

00000277 <mknod>:
SYSCALL(mknod)
 277:	b8 11 00 00 00       	mov    $0x11,%eax
 27c:	cd 40                	int    $0x40
 27e:	c3                   	ret    

0000027f <unlink>:
SYSCALL(unlink)
 27f:	b8 12 00 00 00       	mov    $0x12,%eax
 284:	cd 40                	int    $0x40
 286:	c3                   	ret    

00000287 <fstat>:
SYSCALL(fstat)
 287:	b8 08 00 00 00       	mov    $0x8,%eax
 28c:	cd 40                	int    $0x40
 28e:	c3                   	ret    

0000028f <link>:
SYSCALL(link)
 28f:	b8 13 00 00 00       	mov    $0x13,%eax
 294:	cd 40                	int    $0x40
 296:	c3                   	ret    

00000297 <mkdir>:
SYSCALL(mkdir)
 297:	b8 14 00 00 00       	mov    $0x14,%eax
 29c:	cd 40                	int    $0x40
 29e:	c3                   	ret    

0000029f <chdir>:
SYSCALL(chdir)
 29f:	b8 09 00 00 00       	mov    $0x9,%eax
 2a4:	cd 40                	int    $0x40
 2a6:	c3                   	ret    

000002a7 <dup>:
SYSCALL(dup)
 2a7:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <getpid>:
SYSCALL(getpid)
 2af:	b8 0b 00 00 00       	mov    $0xb,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <sbrk>:
SYSCALL(sbrk)
 2b7:	b8 0c 00 00 00       	mov    $0xc,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <sleep>:
SYSCALL(sleep)
 2bf:	b8 0d 00 00 00       	mov    $0xd,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <uptime>:
 2c7:	b8 0e 00 00 00       	mov    $0xe,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    
 2cf:	90                   	nop

000002d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	53                   	push   %ebx
 2d6:	83 ec 3c             	sub    $0x3c,%esp
 2d9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 2dc:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 2df:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 2e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2e4:	85 db                	test   %ebx,%ebx
 2e6:	74 04                	je     2ec <printint+0x1c>
 2e8:	85 d2                	test   %edx,%edx
 2ea:	78 68                	js     354 <printint+0x84>
  neg = 0;
 2ec:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2f3:	31 ff                	xor    %edi,%edi
 2f5:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 2f8:	89 c8                	mov    %ecx,%eax
 2fa:	31 d2                	xor    %edx,%edx
 2fc:	f7 75 c4             	divl   -0x3c(%ebp)
 2ff:	89 fb                	mov    %edi,%ebx
 301:	8d 7f 01             	lea    0x1(%edi),%edi
 304:	8a 92 b0 06 00 00    	mov    0x6b0(%edx),%dl
 30a:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 30e:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 311:	89 c1                	mov    %eax,%ecx
 313:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 316:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 319:	76 dd                	jbe    2f8 <printint+0x28>
  if(neg)
 31b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31e:	85 c9                	test   %ecx,%ecx
 320:	74 09                	je     32b <printint+0x5b>
    buf[i++] = '-';
 322:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 327:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 329:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 32b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 32f:	8b 7d bc             	mov    -0x44(%ebp),%edi
 332:	eb 03                	jmp    337 <printint+0x67>
    putc(fd, buf[i]);
 334:	8a 13                	mov    (%ebx),%dl
 336:	4b                   	dec    %ebx
 337:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 33a:	50                   	push   %eax
 33b:	6a 01                	push   $0x1
 33d:	56                   	push   %esi
 33e:	57                   	push   %edi
 33f:	e8 0b ff ff ff       	call   24f <write>
  while(--i >= 0)
 344:	83 c4 10             	add    $0x10,%esp
 347:	39 de                	cmp    %ebx,%esi
 349:	75 e9                	jne    334 <printint+0x64>
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	90                   	nop
    x = -xx;
 354:	f7 d9                	neg    %ecx
 356:	eb 9b                	jmp    2f3 <printint+0x23>

00000358 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	57                   	push   %edi
 35c:	56                   	push   %esi
 35d:	53                   	push   %ebx
 35e:	83 ec 2c             	sub    $0x2c,%esp
 361:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 364:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 367:	8a 13                	mov    (%ebx),%dl
 369:	84 d2                	test   %dl,%dl
 36b:	74 64                	je     3d1 <printf+0x79>
 36d:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 36e:	8d 45 10             	lea    0x10(%ebp),%eax
 371:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 374:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 376:	8d 7d e7             	lea    -0x19(%ebp),%edi
 379:	eb 24                	jmp    39f <printf+0x47>
 37b:	90                   	nop
 37c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 37f:	83 f8 25             	cmp    $0x25,%eax
 382:	74 40                	je     3c4 <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 384:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 387:	50                   	push   %eax
 388:	6a 01                	push   $0x1
 38a:	57                   	push   %edi
 38b:	56                   	push   %esi
 38c:	e8 be fe ff ff       	call   24f <write>
        putc(fd, c);
 391:	83 c4 10             	add    $0x10,%esp
 394:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 397:	43                   	inc    %ebx
 398:	8a 53 ff             	mov    -0x1(%ebx),%dl
 39b:	84 d2                	test   %dl,%dl
 39d:	74 32                	je     3d1 <printf+0x79>
    c = fmt[i] & 0xff;
 39f:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 3a2:	85 c9                	test   %ecx,%ecx
 3a4:	74 d6                	je     37c <printf+0x24>
      }
    } else if(state == '%'){
 3a6:	83 f9 25             	cmp    $0x25,%ecx
 3a9:	75 ec                	jne    397 <printf+0x3f>
      if(c == 'd'){
 3ab:	83 f8 25             	cmp    $0x25,%eax
 3ae:	0f 84 e4 00 00 00    	je     498 <printf+0x140>
 3b4:	83 e8 63             	sub    $0x63,%eax
 3b7:	83 f8 15             	cmp    $0x15,%eax
 3ba:	77 20                	ja     3dc <printf+0x84>
 3bc:	ff 24 85 58 06 00 00 	jmp    *0x658(,%eax,4)
 3c3:	90                   	nop
        state = '%';
 3c4:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 3c9:	43                   	inc    %ebx
 3ca:	8a 53 ff             	mov    -0x1(%ebx),%dl
 3cd:	84 d2                	test   %dl,%dl
 3cf:	75 ce                	jne    39f <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 3d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d4:	5b                   	pop    %ebx
 3d5:	5e                   	pop    %esi
 3d6:	5f                   	pop    %edi
 3d7:	5d                   	pop    %ebp
 3d8:	c3                   	ret    
 3d9:	8d 76 00             	lea    0x0(%esi),%esi
 3dc:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 3df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 3e3:	50                   	push   %eax
 3e4:	6a 01                	push   $0x1
 3e6:	57                   	push   %edi
 3e7:	56                   	push   %esi
 3e8:	e8 62 fe ff ff       	call   24f <write>
        putc(fd, c);
 3ed:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 3f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 3f3:	83 c4 0c             	add    $0xc,%esp
 3f6:	6a 01                	push   $0x1
 3f8:	57                   	push   %edi
 3f9:	56                   	push   %esi
 3fa:	e8 50 fe ff ff       	call   24f <write>
        putc(fd, c);
 3ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 402:	31 c9                	xor    %ecx,%ecx
 404:	eb 91                	jmp    397 <printf+0x3f>
 406:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 408:	83 ec 0c             	sub    $0xc,%esp
 40b:	6a 00                	push   $0x0
 40d:	b9 10 00 00 00       	mov    $0x10,%ecx
 412:	8b 45 d0             	mov    -0x30(%ebp),%eax
 415:	8b 10                	mov    (%eax),%edx
 417:	89 f0                	mov    %esi,%eax
 419:	e8 b2 fe ff ff       	call   2d0 <printint>
        ap++;
 41e:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 422:	83 c4 10             	add    $0x10,%esp
      state = 0;
 425:	31 c9                	xor    %ecx,%ecx
        ap++;
 427:	e9 6b ff ff ff       	jmp    397 <printf+0x3f>
        s = (char*)*ap;
 42c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 42f:	8b 10                	mov    (%eax),%edx
        ap++;
 431:	83 c0 04             	add    $0x4,%eax
 434:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 437:	85 d2                	test   %edx,%edx
 439:	74 69                	je     4a4 <printf+0x14c>
        while(*s != 0){
 43b:	8a 02                	mov    (%edx),%al
 43d:	84 c0                	test   %al,%al
 43f:	74 71                	je     4b2 <printf+0x15a>
 441:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 444:	89 d3                	mov    %edx,%ebx
 446:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 448:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 44b:	50                   	push   %eax
 44c:	6a 01                	push   $0x1
 44e:	57                   	push   %edi
 44f:	56                   	push   %esi
 450:	e8 fa fd ff ff       	call   24f <write>
          s++;
 455:	43                   	inc    %ebx
        while(*s != 0){
 456:	8a 03                	mov    (%ebx),%al
 458:	83 c4 10             	add    $0x10,%esp
 45b:	84 c0                	test   %al,%al
 45d:	75 e9                	jne    448 <printf+0xf0>
      state = 0;
 45f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 462:	31 c9                	xor    %ecx,%ecx
 464:	e9 2e ff ff ff       	jmp    397 <printf+0x3f>
 469:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 46c:	83 ec 0c             	sub    $0xc,%esp
 46f:	6a 01                	push   $0x1
 471:	b9 0a 00 00 00       	mov    $0xa,%ecx
 476:	eb 9a                	jmp    412 <printf+0xba>
        putc(fd, *ap);
 478:	8b 45 d0             	mov    -0x30(%ebp),%eax
 47b:	8b 00                	mov    (%eax),%eax
 47d:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 480:	51                   	push   %ecx
 481:	6a 01                	push   $0x1
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	e8 c5 fd ff ff       	call   24f <write>
        ap++;
 48a:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 48e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 491:	31 c9                	xor    %ecx,%ecx
 493:	e9 ff fe ff ff       	jmp    397 <printf+0x3f>
        putc(fd, c);
 498:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 49b:	52                   	push   %edx
 49c:	e9 55 ff ff ff       	jmp    3f6 <printf+0x9e>
 4a1:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 4a4:	ba 50 06 00 00       	mov    $0x650,%edx
        while(*s != 0){
 4a9:	b0 28                	mov    $0x28,%al
 4ab:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4ae:	89 d3                	mov    %edx,%ebx
 4b0:	eb 96                	jmp    448 <printf+0xf0>
      state = 0;
 4b2:	31 c9                	xor    %ecx,%ecx
 4b4:	e9 de fe ff ff       	jmp    397 <printf+0x3f>
 4b9:	66 90                	xchg   %ax,%ax
 4bb:	90                   	nop

000004bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	57                   	push   %edi
 4c0:	56                   	push   %esi
 4c1:	53                   	push   %ebx
 4c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4c5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4c8:	a1 c4 06 00 00       	mov    0x6c4,%eax
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	89 c2                	mov    %eax,%edx
 4d2:	8b 00                	mov    (%eax),%eax
 4d4:	39 ca                	cmp    %ecx,%edx
 4d6:	73 2c                	jae    504 <free+0x48>
 4d8:	39 c1                	cmp    %eax,%ecx
 4da:	72 04                	jb     4e0 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4dc:	39 c2                	cmp    %eax,%edx
 4de:	72 f0                	jb     4d0 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4e3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4e6:	39 f8                	cmp    %edi,%eax
 4e8:	74 2c                	je     516 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 4ea:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 4ed:	8b 42 04             	mov    0x4(%edx),%eax
 4f0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 4f3:	39 f1                	cmp    %esi,%ecx
 4f5:	74 36                	je     52d <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 4f7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 4f9:	89 15 c4 06 00 00    	mov    %edx,0x6c4
}
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 504:	39 c2                	cmp    %eax,%edx
 506:	72 c8                	jb     4d0 <free+0x14>
 508:	39 c1                	cmp    %eax,%ecx
 50a:	73 c4                	jae    4d0 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 50c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 50f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 512:	39 f8                	cmp    %edi,%eax
 514:	75 d4                	jne    4ea <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 516:	03 70 04             	add    0x4(%eax),%esi
 519:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 51c:	8b 02                	mov    (%edx),%eax
 51e:	8b 00                	mov    (%eax),%eax
 520:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 523:	8b 42 04             	mov    0x4(%edx),%eax
 526:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 529:	39 f1                	cmp    %esi,%ecx
 52b:	75 ca                	jne    4f7 <free+0x3b>
    p->s.size += bp->s.size;
 52d:	03 43 fc             	add    -0x4(%ebx),%eax
 530:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 533:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 536:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 538:	89 15 c4 06 00 00    	mov    %edx,0x6c4
}
 53e:	5b                   	pop    %ebx
 53f:	5e                   	pop    %esi
 540:	5f                   	pop    %edi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
 543:	90                   	nop

00000544 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	57                   	push   %edi
 548:	56                   	push   %esi
 549:	53                   	push   %ebx
 54a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	8d 70 07             	lea    0x7(%eax),%esi
 553:	c1 ee 03             	shr    $0x3,%esi
 556:	46                   	inc    %esi
  if((prevp = freep) == 0){
 557:	8b 3d c4 06 00 00    	mov    0x6c4,%edi
 55d:	85 ff                	test   %edi,%edi
 55f:	0f 84 a3 00 00 00    	je     608 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 565:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 567:	8b 4a 04             	mov    0x4(%edx),%ecx
 56a:	39 f1                	cmp    %esi,%ecx
 56c:	73 68                	jae    5d6 <malloc+0x92>
 56e:	89 f3                	mov    %esi,%ebx
 570:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 576:	0f 82 80 00 00 00    	jb     5fc <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 57c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 586:	eb 11                	jmp    599 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 588:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 58a:	8b 48 04             	mov    0x4(%eax),%ecx
 58d:	39 f1                	cmp    %esi,%ecx
 58f:	73 4b                	jae    5dc <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 591:	8b 3d c4 06 00 00    	mov    0x6c4,%edi
 597:	89 c2                	mov    %eax,%edx
 599:	39 d7                	cmp    %edx,%edi
 59b:	75 eb                	jne    588 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 59d:	83 ec 0c             	sub    $0xc,%esp
 5a0:	ff 75 e4             	push   -0x1c(%ebp)
 5a3:	e8 0f fd ff ff       	call   2b7 <sbrk>
  if(p == (char*)-1)
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	83 f8 ff             	cmp    $0xffffffff,%eax
 5ae:	74 1c                	je     5cc <malloc+0x88>
  hp->s.size = nu;
 5b0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5b3:	83 ec 0c             	sub    $0xc,%esp
 5b6:	83 c0 08             	add    $0x8,%eax
 5b9:	50                   	push   %eax
 5ba:	e8 fd fe ff ff       	call   4bc <free>
  return freep;
 5bf:	8b 15 c4 06 00 00    	mov    0x6c4,%edx
      if((p = morecore(nunits)) == 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	85 d2                	test   %edx,%edx
 5ca:	75 bc                	jne    588 <malloc+0x44>
        return 0;
 5cc:	31 c0                	xor    %eax,%eax
  }
}
 5ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d1:	5b                   	pop    %ebx
 5d2:	5e                   	pop    %esi
 5d3:	5f                   	pop    %edi
 5d4:	5d                   	pop    %ebp
 5d5:	c3                   	ret    
    if(p->s.size >= nunits){
 5d6:	89 d0                	mov    %edx,%eax
 5d8:	89 fa                	mov    %edi,%edx
 5da:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 5dc:	39 ce                	cmp    %ecx,%esi
 5de:	74 54                	je     634 <malloc+0xf0>
        p->s.size -= nunits;
 5e0:	29 f1                	sub    %esi,%ecx
 5e2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5e5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5e8:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 5eb:	89 15 c4 06 00 00    	mov    %edx,0x6c4
      return (void*)(p + 1);
 5f1:	83 c0 08             	add    $0x8,%eax
}
 5f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
 5fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 601:	e9 76 ff ff ff       	jmp    57c <malloc+0x38>
 606:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 608:	c7 05 c4 06 00 00 c8 	movl   $0x6c8,0x6c4
 60f:	06 00 00 
 612:	c7 05 c8 06 00 00 c8 	movl   $0x6c8,0x6c8
 619:	06 00 00 
    base.s.size = 0;
 61c:	c7 05 cc 06 00 00 00 	movl   $0x0,0x6cc
 623:	00 00 00 
 626:	bf c8 06 00 00       	mov    $0x6c8,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62b:	89 fa                	mov    %edi,%edx
 62d:	e9 3c ff ff ff       	jmp    56e <malloc+0x2a>
 632:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 634:	8b 08                	mov    (%eax),%ecx
 636:	89 0a                	mov    %ecx,(%edx)
 638:	eb b1                	jmp    5eb <malloc+0xa7>
