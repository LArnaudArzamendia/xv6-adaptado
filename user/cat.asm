
user/_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 54                	jle    73 <main+0x73>
  1f:	83 c3 04             	add    $0x4,%ebx
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  22:	be 01 00 00 00       	mov    $0x1,%esi
  27:	90                   	nop
    if((fd = open(argv[i], 0)) < 0){
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	6a 00                	push   $0x0
  2d:	ff 33                	push   (%ebx)
  2f:	e8 d3 02 00 00       	call   307 <open>
  34:	89 c7                	mov    %eax,%edi
  36:	83 c4 10             	add    $0x10,%esp
  39:	85 c0                	test   %eax,%eax
  3b:	78 22                	js     5f <main+0x5f>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	50                   	push   %eax
  41:	e8 3e 00 00 00       	call   84 <cat>
    close(fd);
  46:	89 3c 24             	mov    %edi,(%esp)
  49:	e8 a1 02 00 00       	call   2ef <close>
  for(i = 1; i < argc; i++){
  4e:	46                   	inc    %esi
  4f:	83 c3 04             	add    $0x4,%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  58:	75 ce                	jne    28 <main+0x28>
  }
  exit();
  5a:	e8 68 02 00 00       	call   2c7 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  5f:	50                   	push   %eax
  60:	ff 33                	push   (%ebx)
  62:	68 f7 06 00 00       	push   $0x6f7
  67:	6a 01                	push   $0x1
  69:	e8 82 03 00 00       	call   3f0 <printf>
      exit();
  6e:	e8 54 02 00 00       	call   2c7 <exit>
    cat(0);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	6a 00                	push   $0x0
  78:	e8 07 00 00 00       	call   84 <cat>
    exit();
  7d:	e8 45 02 00 00       	call   2c7 <exit>
  82:	66 90                	xchg   %ax,%ax

00000084 <cat>:
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	56                   	push   %esi
  88:	53                   	push   %ebx
  89:	8b 75 08             	mov    0x8(%ebp),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  8c:	eb 17                	jmp    a5 <cat+0x21>
  8e:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  90:	51                   	push   %ecx
  91:	53                   	push   %ebx
  92:	68 80 07 00 00       	push   $0x780
  97:	6a 01                	push   $0x1
  99:	e8 49 02 00 00       	call   2e7 <write>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	39 d8                	cmp    %ebx,%eax
  a3:	75 23                	jne    c8 <cat+0x44>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  a5:	52                   	push   %edx
  a6:	68 00 02 00 00       	push   $0x200
  ab:	68 80 07 00 00       	push   $0x780
  b0:	56                   	push   %esi
  b1:	e8 29 02 00 00       	call   2df <read>
  b6:	89 c3                	mov    %eax,%ebx
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	85 c0                	test   %eax,%eax
  bd:	7f d1                	jg     90 <cat+0xc>
  if(n < 0){
  bf:	75 1b                	jne    dc <cat+0x58>
}
  c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  c4:	5b                   	pop    %ebx
  c5:	5e                   	pop    %esi
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
      printf(1, "cat: write error\n");
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	68 d4 06 00 00       	push   $0x6d4
  d0:	6a 01                	push   $0x1
  d2:	e8 19 03 00 00       	call   3f0 <printf>
      exit();
  d7:	e8 eb 01 00 00       	call   2c7 <exit>
    printf(1, "cat: read error\n");
  dc:	50                   	push   %eax
  dd:	50                   	push   %eax
  de:	68 e6 06 00 00       	push   $0x6e6
  e3:	6a 01                	push   $0x1
  e5:	e8 06 03 00 00       	call   3f0 <printf>
    exit();
  ea:	e8 d8 01 00 00       	call   2c7 <exit>
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	31 c0                	xor    %eax,%eax
  fc:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  ff:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 102:	40                   	inc    %eax
 103:	84 d2                	test   %dl,%dl
 105:	75 f5                	jne    fc <strcpy+0xc>
    ;
  return os;
}
 107:	89 c8                	mov    %ecx,%eax
 109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 10c:	c9                   	leave  
 10d:	c3                   	ret    
 10e:	66 90                	xchg   %ax,%ax

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 55 08             	mov    0x8(%ebp),%edx
 117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 11a:	0f b6 02             	movzbl (%edx),%eax
 11d:	84 c0                	test   %al,%al
 11f:	75 10                	jne    131 <strcmp+0x21>
 121:	eb 2a                	jmp    14d <strcmp+0x3d>
 123:	90                   	nop
    p++, q++;
 124:	42                   	inc    %edx
 125:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 128:	0f b6 02             	movzbl (%edx),%eax
 12b:	84 c0                	test   %al,%al
 12d:	74 11                	je     140 <strcmp+0x30>
    p++, q++;
 12f:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
 131:	0f b6 0b             	movzbl (%ebx),%ecx
 134:	38 c1                	cmp    %al,%cl
 136:	74 ec                	je     124 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 138:	29 c8                	sub    %ecx,%eax
}
 13a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 13d:	c9                   	leave  
 13e:	c3                   	ret    
 13f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 140:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 144:	31 c0                	xor    %eax,%eax
 146:	29 c8                	sub    %ecx,%eax
}
 148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14b:	c9                   	leave  
 14c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 14d:	0f b6 0b             	movzbl (%ebx),%ecx
 150:	31 c0                	xor    %eax,%eax
 152:	eb e4                	jmp    138 <strcmp+0x28>

00000154 <strlen>:

uint
strlen(const char *s)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 15a:	80 3a 00             	cmpb   $0x0,(%edx)
 15d:	74 15                	je     174 <strlen+0x20>
 15f:	31 c0                	xor    %eax,%eax
 161:	8d 76 00             	lea    0x0(%esi),%esi
 164:	40                   	inc    %eax
 165:	89 c1                	mov    %eax,%ecx
 167:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 16b:	75 f7                	jne    164 <strlen+0x10>
    ;
  return n;
}
 16d:	89 c8                	mov    %ecx,%eax
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 174:	31 c9                	xor    %ecx,%ecx
}
 176:	89 c8                	mov    %ecx,%eax
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    
 17a:	66 90                	xchg   %ax,%ax

0000017c <memset>:

void*
memset(void *dst, int c, uint n)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 180:	8b 7d 08             	mov    0x8(%ebp),%edi
 183:	8b 4d 10             	mov    0x10(%ebp),%ecx
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	fc                   	cld    
 18a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 192:	c9                   	leave  
 193:	c3                   	ret    

00000194 <strchr>:

char*
strchr(const char *s, char c)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 19d:	8a 10                	mov    (%eax),%dl
 19f:	84 d2                	test   %dl,%dl
 1a1:	75 0c                	jne    1af <strchr+0x1b>
 1a3:	eb 13                	jmp    1b8 <strchr+0x24>
 1a5:	8d 76 00             	lea    0x0(%esi),%esi
 1a8:	40                   	inc    %eax
 1a9:	8a 10                	mov    (%eax),%dl
 1ab:	84 d2                	test   %dl,%dl
 1ad:	74 09                	je     1b8 <strchr+0x24>
    if(*s == c)
 1af:	38 d1                	cmp    %dl,%cl
 1b1:	75 f5                	jne    1a8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1b8:	31 c0                	xor    %eax,%eax
}
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret    

000001bc <gets>:

char*
gets(char *buf, int max)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1c7:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1ca:	eb 24                	jmp    1f0 <gets+0x34>
    cc = read(0, &c, 1);
 1cc:	50                   	push   %eax
 1cd:	6a 01                	push   $0x1
 1cf:	57                   	push   %edi
 1d0:	6a 00                	push   $0x0
 1d2:	e8 08 01 00 00       	call   2df <read>
    if(cc < 1)
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	85 c0                	test   %eax,%eax
 1dc:	7e 1c                	jle    1fa <gets+0x3e>
      break;
    buf[i++] = c;
 1de:	8a 45 e7             	mov    -0x19(%ebp),%al
 1e1:	8b 55 08             	mov    0x8(%ebp),%edx
 1e4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1e8:	3c 0a                	cmp    $0xa,%al
 1ea:	74 20                	je     20c <gets+0x50>
 1ec:	3c 0d                	cmp    $0xd,%al
 1ee:	74 1c                	je     20c <gets+0x50>
  for(i=0; i+1 < max; ){
 1f0:	89 de                	mov    %ebx,%esi
 1f2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1f5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1f8:	7c d2                	jl     1cc <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 201:	8d 65 f4             	lea    -0xc(%ebp),%esp
 204:	5b                   	pop    %ebx
 205:	5e                   	pop    %esi
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    
 209:	8d 76 00             	lea    0x0(%esi),%esi
 20c:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 215:	8d 65 f4             	lea    -0xc(%ebp),%esp
 218:	5b                   	pop    %ebx
 219:	5e                   	pop    %esi
 21a:	5f                   	pop    %edi
 21b:	5d                   	pop    %ebp
 21c:	c3                   	ret    
 21d:	8d 76 00             	lea    0x0(%esi),%esi

00000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	push   0x8(%ebp)
 22d:	e8 d5 00 00 00       	call   307 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 27                	js     260 <stat+0x40>
 239:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	ff 75 0c             	push   0xc(%ebp)
 241:	50                   	push   %eax
 242:	e8 d8 00 00 00       	call   31f <fstat>
 247:	89 c6                	mov    %eax,%esi
  close(fd);
 249:	89 1c 24             	mov    %ebx,(%esp)
 24c:	e8 9e 00 00 00       	call   2ef <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	89 f0                	mov    %esi,%eax
 256:	8d 65 f8             	lea    -0x8(%ebp),%esp
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb ed                	jmp    254 <stat+0x34>
 267:	90                   	nop

00000268 <atoi>:

int
atoi(const char *s)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	53                   	push   %ebx
 26c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26f:	0f be 01             	movsbl (%ecx),%eax
 272:	8d 50 d0             	lea    -0x30(%eax),%edx
 275:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 278:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 27d:	77 16                	ja     295 <atoi+0x2d>
 27f:	90                   	nop
    n = n*10 + *s++ - '0';
 280:	41                   	inc    %ecx
 281:	8d 14 92             	lea    (%edx,%edx,4),%edx
 284:	01 d2                	add    %edx,%edx
 286:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 28a:	0f be 01             	movsbl (%ecx),%eax
 28d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 290:	80 fb 09             	cmp    $0x9,%bl
 293:	76 eb                	jbe    280 <atoi+0x18>
  return n;
}
 295:	89 d0                	mov    %edx,%eax
 297:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	57                   	push   %edi
 2a0:	56                   	push   %esi
 2a1:	8b 55 08             	mov    0x8(%ebp),%edx
 2a4:	8b 75 0c             	mov    0xc(%ebp),%esi
 2a7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2aa:	85 c0                	test   %eax,%eax
 2ac:	7e 0b                	jle    2b9 <memmove+0x1d>
 2ae:	01 d0                	add    %edx,%eax
  dst = vdst;
 2b0:	89 d7                	mov    %edx,%edi
 2b2:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2b4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b5:	39 f8                	cmp    %edi,%eax
 2b7:	75 fb                	jne    2b4 <memmove+0x18>
  return vdst;
}
 2b9:	89 d0                	mov    %edx,%eax
 2bb:	5e                   	pop    %esi
 2bc:	5f                   	pop    %edi
 2bd:	5d                   	pop    %ebp
 2be:	c3                   	ret    

000002bf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bf:	b8 01 00 00 00       	mov    $0x1,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <exit>:
SYSCALL(exit)
 2c7:	b8 02 00 00 00       	mov    $0x2,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <wait>:
SYSCALL(wait)
 2cf:	b8 03 00 00 00       	mov    $0x3,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <pipe>:
SYSCALL(pipe)
 2d7:	b8 04 00 00 00       	mov    $0x4,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <read>:
SYSCALL(read)
 2df:	b8 05 00 00 00       	mov    $0x5,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <write>:
SYSCALL(write)
 2e7:	b8 10 00 00 00       	mov    $0x10,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <close>:
SYSCALL(close)
 2ef:	b8 15 00 00 00       	mov    $0x15,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <kill>:
SYSCALL(kill)
 2f7:	b8 06 00 00 00       	mov    $0x6,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <exec>:
SYSCALL(exec)
 2ff:	b8 07 00 00 00       	mov    $0x7,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <open>:
SYSCALL(open)
 307:	b8 0f 00 00 00       	mov    $0xf,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <mknod>:
SYSCALL(mknod)
 30f:	b8 11 00 00 00       	mov    $0x11,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <unlink>:
SYSCALL(unlink)
 317:	b8 12 00 00 00       	mov    $0x12,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <fstat>:
SYSCALL(fstat)
 31f:	b8 08 00 00 00       	mov    $0x8,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <link>:
SYSCALL(link)
 327:	b8 13 00 00 00       	mov    $0x13,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <mkdir>:
SYSCALL(mkdir)
 32f:	b8 14 00 00 00       	mov    $0x14,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <chdir>:
SYSCALL(chdir)
 337:	b8 09 00 00 00       	mov    $0x9,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <dup>:
SYSCALL(dup)
 33f:	b8 0a 00 00 00       	mov    $0xa,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <getpid>:
SYSCALL(getpid)
 347:	b8 0b 00 00 00       	mov    $0xb,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sbrk>:
SYSCALL(sbrk)
 34f:	b8 0c 00 00 00       	mov    $0xc,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <sleep>:
SYSCALL(sleep)
 357:	b8 0d 00 00 00       	mov    $0xd,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <uptime>:
 35f:	b8 0e 00 00 00       	mov    $0xe,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    
 367:	90                   	nop

00000368 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 3c             	sub    $0x3c,%esp
 371:	89 45 bc             	mov    %eax,-0x44(%ebp)
 374:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 377:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 379:	8b 5d 08             	mov    0x8(%ebp),%ebx
 37c:	85 db                	test   %ebx,%ebx
 37e:	74 04                	je     384 <printint+0x1c>
 380:	85 d2                	test   %edx,%edx
 382:	78 68                	js     3ec <printint+0x84>
  neg = 0;
 384:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 38b:	31 ff                	xor    %edi,%edi
 38d:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 c8                	mov    %ecx,%eax
 392:	31 d2                	xor    %edx,%edx
 394:	f7 75 c4             	divl   -0x3c(%ebp)
 397:	89 fb                	mov    %edi,%ebx
 399:	8d 7f 01             	lea    0x1(%edi),%edi
 39c:	8a 92 6c 07 00 00    	mov    0x76c(%edx),%dl
 3a2:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 3a6:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 3a9:	89 c1                	mov    %eax,%ecx
 3ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3ae:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 3b1:	76 dd                	jbe    390 <printint+0x28>
  if(neg)
 3b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3b6:	85 c9                	test   %ecx,%ecx
 3b8:	74 09                	je     3c3 <printint+0x5b>
    buf[i++] = '-';
 3ba:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 3bf:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3c1:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 3c3:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3c7:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3ca:	eb 03                	jmp    3cf <printint+0x67>
    putc(fd, buf[i]);
 3cc:	8a 13                	mov    (%ebx),%dl
 3ce:	4b                   	dec    %ebx
 3cf:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3d2:	50                   	push   %eax
 3d3:	6a 01                	push   $0x1
 3d5:	56                   	push   %esi
 3d6:	57                   	push   %edi
 3d7:	e8 0b ff ff ff       	call   2e7 <write>
  while(--i >= 0)
 3dc:	83 c4 10             	add    $0x10,%esp
 3df:	39 de                	cmp    %ebx,%esi
 3e1:	75 e9                	jne    3cc <printint+0x64>
}
 3e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3e6:	5b                   	pop    %ebx
 3e7:	5e                   	pop    %esi
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    
 3eb:	90                   	nop
    x = -xx;
 3ec:	f7 d9                	neg    %ecx
 3ee:	eb 9b                	jmp    38b <printint+0x23>

000003f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 2c             	sub    $0x2c,%esp
 3f9:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ff:	8a 13                	mov    (%ebx),%dl
 401:	84 d2                	test   %dl,%dl
 403:	74 64                	je     469 <printf+0x79>
 405:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 406:	8d 45 10             	lea    0x10(%ebp),%eax
 409:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 40c:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 40e:	8d 7d e7             	lea    -0x19(%ebp),%edi
 411:	eb 24                	jmp    437 <printf+0x47>
 413:	90                   	nop
 414:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 417:	83 f8 25             	cmp    $0x25,%eax
 41a:	74 40                	je     45c <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 41c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 41f:	50                   	push   %eax
 420:	6a 01                	push   $0x1
 422:	57                   	push   %edi
 423:	56                   	push   %esi
 424:	e8 be fe ff ff       	call   2e7 <write>
        putc(fd, c);
 429:	83 c4 10             	add    $0x10,%esp
 42c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 42f:	43                   	inc    %ebx
 430:	8a 53 ff             	mov    -0x1(%ebx),%dl
 433:	84 d2                	test   %dl,%dl
 435:	74 32                	je     469 <printf+0x79>
    c = fmt[i] & 0xff;
 437:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 43a:	85 c9                	test   %ecx,%ecx
 43c:	74 d6                	je     414 <printf+0x24>
      }
    } else if(state == '%'){
 43e:	83 f9 25             	cmp    $0x25,%ecx
 441:	75 ec                	jne    42f <printf+0x3f>
      if(c == 'd'){
 443:	83 f8 25             	cmp    $0x25,%eax
 446:	0f 84 e4 00 00 00    	je     530 <printf+0x140>
 44c:	83 e8 63             	sub    $0x63,%eax
 44f:	83 f8 15             	cmp    $0x15,%eax
 452:	77 20                	ja     474 <printf+0x84>
 454:	ff 24 85 14 07 00 00 	jmp    *0x714(,%eax,4)
 45b:	90                   	nop
        state = '%';
 45c:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 461:	43                   	inc    %ebx
 462:	8a 53 ff             	mov    -0x1(%ebx),%dl
 465:	84 d2                	test   %dl,%dl
 467:	75 ce                	jne    437 <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 469:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46c:	5b                   	pop    %ebx
 46d:	5e                   	pop    %esi
 46e:	5f                   	pop    %edi
 46f:	5d                   	pop    %ebp
 470:	c3                   	ret    
 471:	8d 76 00             	lea    0x0(%esi),%esi
 474:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 477:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 47b:	50                   	push   %eax
 47c:	6a 01                	push   $0x1
 47e:	57                   	push   %edi
 47f:	56                   	push   %esi
 480:	e8 62 fe ff ff       	call   2e7 <write>
        putc(fd, c);
 485:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 488:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 48b:	83 c4 0c             	add    $0xc,%esp
 48e:	6a 01                	push   $0x1
 490:	57                   	push   %edi
 491:	56                   	push   %esi
 492:	e8 50 fe ff ff       	call   2e7 <write>
        putc(fd, c);
 497:	83 c4 10             	add    $0x10,%esp
      state = 0;
 49a:	31 c9                	xor    %ecx,%ecx
 49c:	eb 91                	jmp    42f <printf+0x3f>
 49e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4a0:	83 ec 0c             	sub    $0xc,%esp
 4a3:	6a 00                	push   $0x0
 4a5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4ad:	8b 10                	mov    (%eax),%edx
 4af:	89 f0                	mov    %esi,%eax
 4b1:	e8 b2 fe ff ff       	call   368 <printint>
        ap++;
 4b6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 4ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4bd:	31 c9                	xor    %ecx,%ecx
        ap++;
 4bf:	e9 6b ff ff ff       	jmp    42f <printf+0x3f>
        s = (char*)*ap;
 4c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4c7:	8b 10                	mov    (%eax),%edx
        ap++;
 4c9:	83 c0 04             	add    $0x4,%eax
 4cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4cf:	85 d2                	test   %edx,%edx
 4d1:	74 69                	je     53c <printf+0x14c>
        while(*s != 0){
 4d3:	8a 02                	mov    (%edx),%al
 4d5:	84 c0                	test   %al,%al
 4d7:	74 71                	je     54a <printf+0x15a>
 4d9:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4dc:	89 d3                	mov    %edx,%ebx
 4de:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 4e0:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4e3:	50                   	push   %eax
 4e4:	6a 01                	push   $0x1
 4e6:	57                   	push   %edi
 4e7:	56                   	push   %esi
 4e8:	e8 fa fd ff ff       	call   2e7 <write>
          s++;
 4ed:	43                   	inc    %ebx
        while(*s != 0){
 4ee:	8a 03                	mov    (%ebx),%al
 4f0:	83 c4 10             	add    $0x10,%esp
 4f3:	84 c0                	test   %al,%al
 4f5:	75 e9                	jne    4e0 <printf+0xf0>
      state = 0;
 4f7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 4fa:	31 c9                	xor    %ecx,%ecx
 4fc:	e9 2e ff ff ff       	jmp    42f <printf+0x3f>
 501:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 504:	83 ec 0c             	sub    $0xc,%esp
 507:	6a 01                	push   $0x1
 509:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50e:	eb 9a                	jmp    4aa <printf+0xba>
        putc(fd, *ap);
 510:	8b 45 d0             	mov    -0x30(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 518:	51                   	push   %ecx
 519:	6a 01                	push   $0x1
 51b:	57                   	push   %edi
 51c:	56                   	push   %esi
 51d:	e8 c5 fd ff ff       	call   2e7 <write>
        ap++;
 522:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 526:	83 c4 10             	add    $0x10,%esp
      state = 0;
 529:	31 c9                	xor    %ecx,%ecx
 52b:	e9 ff fe ff ff       	jmp    42f <printf+0x3f>
        putc(fd, c);
 530:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 533:	52                   	push   %edx
 534:	e9 55 ff ff ff       	jmp    48e <printf+0x9e>
 539:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 53c:	ba 0c 07 00 00       	mov    $0x70c,%edx
        while(*s != 0){
 541:	b0 28                	mov    $0x28,%al
 543:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 546:	89 d3                	mov    %edx,%ebx
 548:	eb 96                	jmp    4e0 <printf+0xf0>
      state = 0;
 54a:	31 c9                	xor    %ecx,%ecx
 54c:	e9 de fe ff ff       	jmp    42f <printf+0x3f>
 551:	66 90                	xchg   %ax,%ax
 553:	90                   	nop

00000554 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	56                   	push   %esi
 559:	53                   	push   %ebx
 55a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 55d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 560:	a1 80 09 00 00       	mov    0x980,%eax
 565:	8d 76 00             	lea    0x0(%esi),%esi
 568:	89 c2                	mov    %eax,%edx
 56a:	8b 00                	mov    (%eax),%eax
 56c:	39 ca                	cmp    %ecx,%edx
 56e:	73 2c                	jae    59c <free+0x48>
 570:	39 c1                	cmp    %eax,%ecx
 572:	72 04                	jb     578 <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 574:	39 c2                	cmp    %eax,%edx
 576:	72 f0                	jb     568 <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 578:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57e:	39 f8                	cmp    %edi,%eax
 580:	74 2c                	je     5ae <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 582:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 585:	8b 42 04             	mov    0x4(%edx),%eax
 588:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 58b:	39 f1                	cmp    %esi,%ecx
 58d:	74 36                	je     5c5 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 58f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 591:	89 15 80 09 00 00    	mov    %edx,0x980
}
 597:	5b                   	pop    %ebx
 598:	5e                   	pop    %esi
 599:	5f                   	pop    %edi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59c:	39 c2                	cmp    %eax,%edx
 59e:	72 c8                	jb     568 <free+0x14>
 5a0:	39 c1                	cmp    %eax,%ecx
 5a2:	73 c4                	jae    568 <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 5a4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5a7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5aa:	39 f8                	cmp    %edi,%eax
 5ac:	75 d4                	jne    582 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5ae:	03 70 04             	add    0x4(%eax),%esi
 5b1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5b4:	8b 02                	mov    (%edx),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5bb:	8b 42 04             	mov    0x4(%edx),%eax
 5be:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5c1:	39 f1                	cmp    %esi,%ecx
 5c3:	75 ca                	jne    58f <free+0x3b>
    p->s.size += bp->s.size;
 5c5:	03 43 fc             	add    -0x4(%ebx),%eax
 5c8:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5cb:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5ce:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5d0:	89 15 80 09 00 00    	mov    %edx,0x980
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5f                   	pop    %edi
 5d9:	5d                   	pop    %ebp
 5da:	c3                   	ret    
 5db:	90                   	nop

000005dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	57                   	push   %edi
 5e0:	56                   	push   %esi
 5e1:	53                   	push   %ebx
 5e2:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	8d 70 07             	lea    0x7(%eax),%esi
 5eb:	c1 ee 03             	shr    $0x3,%esi
 5ee:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5ef:	8b 3d 80 09 00 00    	mov    0x980,%edi
 5f5:	85 ff                	test   %edi,%edi
 5f7:	0f 84 a3 00 00 00    	je     6a0 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fd:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 5ff:	8b 4a 04             	mov    0x4(%edx),%ecx
 602:	39 f1                	cmp    %esi,%ecx
 604:	73 68                	jae    66e <malloc+0x92>
 606:	89 f3                	mov    %esi,%ebx
 608:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 60e:	0f 82 80 00 00 00    	jb     694 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 614:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 61b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 61e:	eb 11                	jmp    631 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 620:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 622:	8b 48 04             	mov    0x4(%eax),%ecx
 625:	39 f1                	cmp    %esi,%ecx
 627:	73 4b                	jae    674 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 629:	8b 3d 80 09 00 00    	mov    0x980,%edi
 62f:	89 c2                	mov    %eax,%edx
 631:	39 d7                	cmp    %edx,%edi
 633:	75 eb                	jne    620 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 635:	83 ec 0c             	sub    $0xc,%esp
 638:	ff 75 e4             	push   -0x1c(%ebp)
 63b:	e8 0f fd ff ff       	call   34f <sbrk>
  if(p == (char*)-1)
 640:	83 c4 10             	add    $0x10,%esp
 643:	83 f8 ff             	cmp    $0xffffffff,%eax
 646:	74 1c                	je     664 <malloc+0x88>
  hp->s.size = nu;
 648:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 64b:	83 ec 0c             	sub    $0xc,%esp
 64e:	83 c0 08             	add    $0x8,%eax
 651:	50                   	push   %eax
 652:	e8 fd fe ff ff       	call   554 <free>
  return freep;
 657:	8b 15 80 09 00 00    	mov    0x980,%edx
      if((p = morecore(nunits)) == 0)
 65d:	83 c4 10             	add    $0x10,%esp
 660:	85 d2                	test   %edx,%edx
 662:	75 bc                	jne    620 <malloc+0x44>
        return 0;
 664:	31 c0                	xor    %eax,%eax
  }
}
 666:	8d 65 f4             	lea    -0xc(%ebp),%esp
 669:	5b                   	pop    %ebx
 66a:	5e                   	pop    %esi
 66b:	5f                   	pop    %edi
 66c:	5d                   	pop    %ebp
 66d:	c3                   	ret    
    if(p->s.size >= nunits){
 66e:	89 d0                	mov    %edx,%eax
 670:	89 fa                	mov    %edi,%edx
 672:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 674:	39 ce                	cmp    %ecx,%esi
 676:	74 54                	je     6cc <malloc+0xf0>
        p->s.size -= nunits;
 678:	29 f1                	sub    %esi,%ecx
 67a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 67d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 680:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 683:	89 15 80 09 00 00    	mov    %edx,0x980
      return (void*)(p + 1);
 689:	83 c0 08             	add    $0x8,%eax
}
 68c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68f:	5b                   	pop    %ebx
 690:	5e                   	pop    %esi
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    
 694:	bb 00 10 00 00       	mov    $0x1000,%ebx
 699:	e9 76 ff ff ff       	jmp    614 <malloc+0x38>
 69e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 6a0:	c7 05 80 09 00 00 84 	movl   $0x984,0x980
 6a7:	09 00 00 
 6aa:	c7 05 84 09 00 00 84 	movl   $0x984,0x984
 6b1:	09 00 00 
    base.s.size = 0;
 6b4:	c7 05 88 09 00 00 00 	movl   $0x0,0x988
 6bb:	00 00 00 
 6be:	bf 84 09 00 00       	mov    $0x984,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c3:	89 fa                	mov    %edi,%edx
 6c5:	e9 3c ff ff ff       	jmp    606 <malloc+0x2a>
 6ca:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6cc:	8b 08                	mov    (%eax),%ecx
 6ce:	89 0a                	mov    %ecx,(%edx)
 6d0:	eb b1                	jmp    683 <malloc+0xa7>
