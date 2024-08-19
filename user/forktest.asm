
user/_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  printf(1, "fork test OK\n");
}

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
   6:	e8 2d 00 00 00       	call   38 <forktest>
  exit();
   b:	e8 c7 02 00 00       	call   2d7 <exit>

00000010 <printf>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
  14:	83 ec 10             	sub    $0x10,%esp
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
  1a:	53                   	push   %ebx
  1b:	e8 44 01 00 00       	call   164 <strlen>
  20:	83 c4 0c             	add    $0xc,%esp
  23:	50                   	push   %eax
  24:	53                   	push   %ebx
  25:	ff 75 08             	push   0x8(%ebp)
  28:	e8 ca 02 00 00       	call   2f7 <write>
}
  2d:	83 c4 10             	add    $0x10,%esp
  30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  33:	c9                   	leave  
  34:	c3                   	ret    
  35:	8d 76 00             	lea    0x0(%esi),%esi

00000038 <forktest>:
{
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	53                   	push   %ebx
  3c:	83 ec 10             	sub    $0x10,%esp
  write(fd, s, strlen(s));
  3f:	68 78 03 00 00       	push   $0x378
  44:	e8 1b 01 00 00       	call   164 <strlen>
  49:	83 c4 0c             	add    $0xc,%esp
  4c:	50                   	push   %eax
  4d:	68 78 03 00 00       	push   $0x378
  52:	6a 01                	push   $0x1
  54:	e8 9e 02 00 00       	call   2f7 <write>
  59:	83 c4 10             	add    $0x10,%esp
  for(n=0; n<N; n++){
  5c:	31 db                	xor    %ebx,%ebx
  5e:	eb 0b                	jmp    6b <forktest+0x33>
    if(pid == 0)
  60:	74 4c                	je     ae <forktest+0x76>
  for(n=0; n<N; n++){
  62:	43                   	inc    %ebx
  63:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  69:	74 7d                	je     e8 <forktest+0xb0>
    pid = fork();
  6b:	e8 5f 02 00 00       	call   2cf <fork>
    if(pid < 0)
  70:	85 c0                	test   %eax,%eax
  72:	79 ec                	jns    60 <forktest+0x28>
  for(; n > 0; n--){
  74:	85 db                	test   %ebx,%ebx
  76:	74 0c                	je     84 <forktest+0x4c>
    if(wait() < 0){
  78:	e8 62 02 00 00       	call   2df <wait>
  7d:	85 c0                	test   %eax,%eax
  7f:	78 32                	js     b3 <forktest+0x7b>
  for(; n > 0; n--){
  81:	4b                   	dec    %ebx
  82:	75 f4                	jne    78 <forktest+0x40>
  if(wait() != -1){
  84:	e8 56 02 00 00       	call   2df <wait>
  89:	40                   	inc    %eax
  8a:	75 49                	jne    d5 <forktest+0x9d>
  write(fd, s, strlen(s));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	68 aa 03 00 00       	push   $0x3aa
  94:	e8 cb 00 00 00       	call   164 <strlen>
  99:	83 c4 0c             	add    $0xc,%esp
  9c:	50                   	push   %eax
  9d:	68 aa 03 00 00       	push   $0x3aa
  a2:	6a 01                	push   $0x1
  a4:	e8 4e 02 00 00       	call   2f7 <write>
}
  a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  ac:	c9                   	leave  
  ad:	c3                   	ret    
      exit();
  ae:	e8 24 02 00 00       	call   2d7 <exit>
  write(fd, s, strlen(s));
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	68 83 03 00 00       	push   $0x383
  bb:	e8 a4 00 00 00       	call   164 <strlen>
  c0:	83 c4 0c             	add    $0xc,%esp
  c3:	50                   	push   %eax
  c4:	68 83 03 00 00       	push   $0x383
  c9:	6a 01                	push   $0x1
  cb:	e8 27 02 00 00       	call   2f7 <write>
      exit();
  d0:	e8 02 02 00 00       	call   2d7 <exit>
    printf(1, "wait got too many\n");
  d5:	52                   	push   %edx
  d6:	52                   	push   %edx
  d7:	68 97 03 00 00       	push   $0x397
  dc:	6a 01                	push   $0x1
  de:	e8 2d ff ff ff       	call   10 <printf>
    exit();
  e3:	e8 ef 01 00 00       	call   2d7 <exit>
    printf(1, "fork claimed to work N times!\n", N);
  e8:	50                   	push   %eax
  e9:	68 e8 03 00 00       	push   $0x3e8
  ee:	68 b8 03 00 00       	push   $0x3b8
  f3:	6a 01                	push   $0x1
  f5:	e8 16 ff ff ff       	call   10 <printf>
    exit();
  fa:	e8 d8 01 00 00       	call   2d7 <exit>
  ff:	90                   	nop

00000100 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 10a:	31 c0                	xor    %eax,%eax
 10c:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 10f:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 112:	40                   	inc    %eax
 113:	84 d2                	test   %dl,%dl
 115:	75 f5                	jne    10c <strcpy+0xc>
    ;
  return os;
}
 117:	89 c8                	mov    %ecx,%eax
 119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 11c:	c9                   	leave  
 11d:	c3                   	ret    
 11e:	66 90                	xchg   %ax,%ax

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	84 c0                	test   %al,%al
 12f:	75 10                	jne    141 <strcmp+0x21>
 131:	eb 2a                	jmp    15d <strcmp+0x3d>
 133:	90                   	nop
    p++, q++;
 134:	42                   	inc    %edx
 135:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 138:	0f b6 02             	movzbl (%edx),%eax
 13b:	84 c0                	test   %al,%al
 13d:	74 11                	je     150 <strcmp+0x30>
    p++, q++;
 13f:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
 141:	0f b6 0b             	movzbl (%ebx),%ecx
 144:	38 c1                	cmp    %al,%cl
 146:	74 ec                	je     134 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 148:	29 c8                	sub    %ecx,%eax
}
 14a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 14d:	c9                   	leave  
 14e:	c3                   	ret    
 14f:	90                   	nop
  return (uchar)*p - (uchar)*q;
 150:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 154:	31 c0                	xor    %eax,%eax
 156:	29 c8                	sub    %ecx,%eax
}
 158:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 15b:	c9                   	leave  
 15c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 15d:	0f b6 0b             	movzbl (%ebx),%ecx
 160:	31 c0                	xor    %eax,%eax
 162:	eb e4                	jmp    148 <strcmp+0x28>

00000164 <strlen>:

uint
strlen(const char *s)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 16a:	80 3a 00             	cmpb   $0x0,(%edx)
 16d:	74 15                	je     184 <strlen+0x20>
 16f:	31 c0                	xor    %eax,%eax
 171:	8d 76 00             	lea    0x0(%esi),%esi
 174:	40                   	inc    %eax
 175:	89 c1                	mov    %eax,%ecx
 177:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 17b:	75 f7                	jne    174 <strlen+0x10>
    ;
  return n;
}
 17d:	89 c8                	mov    %ecx,%eax
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 184:	31 c9                	xor    %ecx,%ecx
}
 186:	89 c8                	mov    %ecx,%eax
 188:	5d                   	pop    %ebp
 189:	c3                   	ret    
 18a:	66 90                	xchg   %ax,%ax

0000018c <memset>:

void*
memset(void *dst, int c, uint n)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 190:	8b 7d 08             	mov    0x8(%ebp),%edi
 193:	8b 4d 10             	mov    0x10(%ebp),%ecx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	fc                   	cld    
 19a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1ad:	8a 10                	mov    (%eax),%dl
 1af:	84 d2                	test   %dl,%dl
 1b1:	75 0c                	jne    1bf <strchr+0x1b>
 1b3:	eb 13                	jmp    1c8 <strchr+0x24>
 1b5:	8d 76 00             	lea    0x0(%esi),%esi
 1b8:	40                   	inc    %eax
 1b9:	8a 10                	mov    (%eax),%dl
 1bb:	84 d2                	test   %dl,%dl
 1bd:	74 09                	je     1c8 <strchr+0x24>
    if(*s == c)
 1bf:	38 d1                	cmp    %dl,%cl
 1c1:	75 f5                	jne    1b8 <strchr+0x14>
      return (char*)s;
  return 0;
}
 1c3:	5d                   	pop    %ebp
 1c4:	c3                   	ret    
 1c5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1c8:	31 c0                	xor    %eax,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	57                   	push   %edi
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1d7:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1da:	eb 24                	jmp    200 <gets+0x34>
    cc = read(0, &c, 1);
 1dc:	50                   	push   %eax
 1dd:	6a 01                	push   $0x1
 1df:	57                   	push   %edi
 1e0:	6a 00                	push   $0x0
 1e2:	e8 08 01 00 00       	call   2ef <read>
    if(cc < 1)
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	85 c0                	test   %eax,%eax
 1ec:	7e 1c                	jle    20a <gets+0x3e>
      break;
    buf[i++] = c;
 1ee:	8a 45 e7             	mov    -0x19(%ebp),%al
 1f1:	8b 55 08             	mov    0x8(%ebp),%edx
 1f4:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1f8:	3c 0a                	cmp    $0xa,%al
 1fa:	74 20                	je     21c <gets+0x50>
 1fc:	3c 0d                	cmp    $0xd,%al
 1fe:	74 1c                	je     21c <gets+0x50>
  for(i=0; i+1 < max; ){
 200:	89 de                	mov    %ebx,%esi
 202:	8d 5b 01             	lea    0x1(%ebx),%ebx
 205:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 208:	7c d2                	jl     1dc <gets+0x10>
      break;
  }
  buf[i] = '\0';
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 211:	8d 65 f4             	lea    -0xc(%ebp),%esp
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
 219:	8d 76 00             	lea    0x0(%esi),%esi
 21c:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 225:	8d 65 f4             	lea    -0xc(%ebp),%esp
 228:	5b                   	pop    %ebx
 229:	5e                   	pop    %esi
 22a:	5f                   	pop    %edi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi

00000230 <stat>:

int
stat(const char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 235:	83 ec 08             	sub    $0x8,%esp
 238:	6a 00                	push   $0x0
 23a:	ff 75 08             	push   0x8(%ebp)
 23d:	e8 d5 00 00 00       	call   317 <open>
  if(fd < 0)
 242:	83 c4 10             	add    $0x10,%esp
 245:	85 c0                	test   %eax,%eax
 247:	78 27                	js     270 <stat+0x40>
 249:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 24b:	83 ec 08             	sub    $0x8,%esp
 24e:	ff 75 0c             	push   0xc(%ebp)
 251:	50                   	push   %eax
 252:	e8 d8 00 00 00       	call   32f <fstat>
 257:	89 c6                	mov    %eax,%esi
  close(fd);
 259:	89 1c 24             	mov    %ebx,(%esp)
 25c:	e8 9e 00 00 00       	call   2ff <close>
  return r;
 261:	83 c4 10             	add    $0x10,%esp
}
 264:	89 f0                	mov    %esi,%eax
 266:	8d 65 f8             	lea    -0x8(%ebp),%esp
 269:	5b                   	pop    %ebx
 26a:	5e                   	pop    %esi
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 270:	be ff ff ff ff       	mov    $0xffffffff,%esi
 275:	eb ed                	jmp    264 <stat+0x34>
 277:	90                   	nop

00000278 <atoi>:

int
atoi(const char *s)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	53                   	push   %ebx
 27c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27f:	0f be 01             	movsbl (%ecx),%eax
 282:	8d 50 d0             	lea    -0x30(%eax),%edx
 285:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 288:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 28d:	77 16                	ja     2a5 <atoi+0x2d>
 28f:	90                   	nop
    n = n*10 + *s++ - '0';
 290:	41                   	inc    %ecx
 291:	8d 14 92             	lea    (%edx,%edx,4),%edx
 294:	01 d2                	add    %edx,%edx
 296:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 29a:	0f be 01             	movsbl (%ecx),%eax
 29d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2a0:	80 fb 09             	cmp    $0x9,%bl
 2a3:	76 eb                	jbe    290 <atoi+0x18>
  return n;
}
 2a5:	89 d0                	mov    %edx,%eax
 2a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	57                   	push   %edi
 2b0:	56                   	push   %esi
 2b1:	8b 55 08             	mov    0x8(%ebp),%edx
 2b4:	8b 75 0c             	mov    0xc(%ebp),%esi
 2b7:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7e 0b                	jle    2c9 <memmove+0x1d>
 2be:	01 d0                	add    %edx,%eax
  dst = vdst;
 2c0:	89 d7                	mov    %edx,%edi
 2c2:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2c4:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2c5:	39 f8                	cmp    %edi,%eax
 2c7:	75 fb                	jne    2c4 <memmove+0x18>
  return vdst;
}
 2c9:	89 d0                	mov    %edx,%eax
 2cb:	5e                   	pop    %esi
 2cc:	5f                   	pop    %edi
 2cd:	5d                   	pop    %ebp
 2ce:	c3                   	ret    

000002cf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cf:	b8 01 00 00 00       	mov    $0x1,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <exit>:
SYSCALL(exit)
 2d7:	b8 02 00 00 00       	mov    $0x2,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <wait>:
SYSCALL(wait)
 2df:	b8 03 00 00 00       	mov    $0x3,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <pipe>:
SYSCALL(pipe)
 2e7:	b8 04 00 00 00       	mov    $0x4,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <read>:
SYSCALL(read)
 2ef:	b8 05 00 00 00       	mov    $0x5,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <write>:
SYSCALL(write)
 2f7:	b8 10 00 00 00       	mov    $0x10,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <close>:
SYSCALL(close)
 2ff:	b8 15 00 00 00       	mov    $0x15,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <kill>:
SYSCALL(kill)
 307:	b8 06 00 00 00       	mov    $0x6,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exec>:
SYSCALL(exec)
 30f:	b8 07 00 00 00       	mov    $0x7,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <open>:
SYSCALL(open)
 317:	b8 0f 00 00 00       	mov    $0xf,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <mknod>:
SYSCALL(mknod)
 31f:	b8 11 00 00 00       	mov    $0x11,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <unlink>:
SYSCALL(unlink)
 327:	b8 12 00 00 00       	mov    $0x12,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <fstat>:
SYSCALL(fstat)
 32f:	b8 08 00 00 00       	mov    $0x8,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <link>:
SYSCALL(link)
 337:	b8 13 00 00 00       	mov    $0x13,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <mkdir>:
SYSCALL(mkdir)
 33f:	b8 14 00 00 00       	mov    $0x14,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <chdir>:
SYSCALL(chdir)
 347:	b8 09 00 00 00       	mov    $0x9,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <dup>:
SYSCALL(dup)
 34f:	b8 0a 00 00 00       	mov    $0xa,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <getpid>:
SYSCALL(getpid)
 357:	b8 0b 00 00 00       	mov    $0xb,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sbrk>:
SYSCALL(sbrk)
 35f:	b8 0c 00 00 00       	mov    $0xc,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sleep>:
SYSCALL(sleep)
 367:	b8 0d 00 00 00       	mov    $0xd,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <uptime>:
 36f:	b8 0e 00 00 00       	mov    $0xe,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    
