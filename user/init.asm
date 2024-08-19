
user/_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 c8 06 00 00       	push   $0x6c8
  19:	e8 dd 02 00 00       	call   2fb <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 93 00 00 00    	js     bc <main+0xbc>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 00 03 00 00       	call   333 <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 f4 02 00 00       	call   333 <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	66 90                	xchg   %ax,%ax

  for(;;){
    printf(1, "init: starting sh\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 d0 06 00 00       	push   $0x6d0
  4c:	6a 01                	push   $0x1
  4e:	e8 91 03 00 00       	call   3e4 <printf>
    pid = fork();
  53:	e8 5b 02 00 00       	call   2b3 <fork>
  58:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	85 c0                	test   %eax,%eax
  5f:	78 24                	js     85 <main+0x85>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  61:	74 35                	je     98 <main+0x98>
  63:	90                   	nop
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  64:	e8 5a 02 00 00       	call   2c3 <wait>
  69:	85 c0                	test   %eax,%eax
  6b:	78 d7                	js     44 <main+0x44>
  6d:	39 c3                	cmp    %eax,%ebx
  6f:	74 d3                	je     44 <main+0x44>
      printf(1, "zombie!\n");
  71:	83 ec 08             	sub    $0x8,%esp
  74:	68 0f 07 00 00       	push   $0x70f
  79:	6a 01                	push   $0x1
  7b:	e8 64 03 00 00       	call   3e4 <printf>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb df                	jmp    64 <main+0x64>
      printf(1, "init: fork failed\n");
  85:	53                   	push   %ebx
  86:	53                   	push   %ebx
  87:	68 e3 06 00 00       	push   $0x6e3
  8c:	6a 01                	push   $0x1
  8e:	e8 51 03 00 00       	call   3e4 <printf>
      exit();
  93:	e8 23 02 00 00       	call   2bb <exit>
      exec("sh", argv);
  98:	50                   	push   %eax
  99:	50                   	push   %eax
  9a:	68 8c 07 00 00       	push   $0x78c
  9f:	68 f6 06 00 00       	push   $0x6f6
  a4:	e8 4a 02 00 00       	call   2f3 <exec>
      printf(1, "init: exec sh failed\n");
  a9:	5a                   	pop    %edx
  aa:	59                   	pop    %ecx
  ab:	68 f9 06 00 00       	push   $0x6f9
  b0:	6a 01                	push   $0x1
  b2:	e8 2d 03 00 00       	call   3e4 <printf>
      exit();
  b7:	e8 ff 01 00 00       	call   2bb <exit>
    mknod("console", 1, 1);
  bc:	50                   	push   %eax
  bd:	6a 01                	push   $0x1
  bf:	6a 01                	push   $0x1
  c1:	68 c8 06 00 00       	push   $0x6c8
  c6:	e8 38 02 00 00       	call   303 <mknod>
    open("console", O_RDWR);
  cb:	58                   	pop    %eax
  cc:	5a                   	pop    %edx
  cd:	6a 02                	push   $0x2
  cf:	68 c8 06 00 00       	push   $0x6c8
  d4:	e8 22 02 00 00       	call   2fb <open>
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	e9 48 ff ff ff       	jmp    29 <main+0x29>
  e1:	66 90                	xchg   %ax,%ax
  e3:	90                   	nop

000000e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	53                   	push   %ebx
  e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ee:	31 c0                	xor    %eax,%eax
  f0:	8a 14 03             	mov    (%ebx,%eax,1),%dl
  f3:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  f6:	40                   	inc    %eax
  f7:	84 d2                	test   %dl,%dl
  f9:	75 f5                	jne    f0 <strcpy+0xc>
    ;
  return os;
}
  fb:	89 c8                	mov    %ecx,%eax
  fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 100:	c9                   	leave  
 101:	c3                   	ret    
 102:	66 90                	xchg   %ax,%ax

00000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	53                   	push   %ebx
 108:	8b 55 08             	mov    0x8(%ebp),%edx
 10b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 10e:	0f b6 02             	movzbl (%edx),%eax
 111:	84 c0                	test   %al,%al
 113:	75 10                	jne    125 <strcmp+0x21>
 115:	eb 2a                	jmp    141 <strcmp+0x3d>
 117:	90                   	nop
    p++, q++;
 118:	42                   	inc    %edx
 119:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 11c:	0f b6 02             	movzbl (%edx),%eax
 11f:	84 c0                	test   %al,%al
 121:	74 11                	je     134 <strcmp+0x30>
    p++, q++;
 123:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
 125:	0f b6 0b             	movzbl (%ebx),%ecx
 128:	38 c1                	cmp    %al,%cl
 12a:	74 ec                	je     118 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 12c:	29 c8                	sub    %ecx,%eax
}
 12e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 131:	c9                   	leave  
 132:	c3                   	ret    
 133:	90                   	nop
  return (uchar)*p - (uchar)*q;
 134:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 138:	31 c0                	xor    %eax,%eax
 13a:	29 c8                	sub    %ecx,%eax
}
 13c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 13f:	c9                   	leave  
 140:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 141:	0f b6 0b             	movzbl (%ebx),%ecx
 144:	31 c0                	xor    %eax,%eax
 146:	eb e4                	jmp    12c <strcmp+0x28>

00000148 <strlen>:

uint
strlen(const char *s)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 14e:	80 3a 00             	cmpb   $0x0,(%edx)
 151:	74 15                	je     168 <strlen+0x20>
 153:	31 c0                	xor    %eax,%eax
 155:	8d 76 00             	lea    0x0(%esi),%esi
 158:	40                   	inc    %eax
 159:	89 c1                	mov    %eax,%ecx
 15b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 15f:	75 f7                	jne    158 <strlen+0x10>
    ;
  return n;
}
 161:	89 c8                	mov    %ecx,%eax
 163:	5d                   	pop    %ebp
 164:	c3                   	ret    
 165:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 168:	31 c9                	xor    %ecx,%ecx
}
 16a:	89 c8                	mov    %ecx,%eax
 16c:	5d                   	pop    %ebp
 16d:	c3                   	ret    
 16e:	66 90                	xchg   %ax,%ax

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 174:	8b 7d 08             	mov    0x8(%ebp),%edi
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	fc                   	cld    
 17e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	8b 7d fc             	mov    -0x4(%ebp),%edi
 186:	c9                   	leave  
 187:	c3                   	ret    

00000188 <strchr>:

char*
strchr(const char *s, char c)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 191:	8a 10                	mov    (%eax),%dl
 193:	84 d2                	test   %dl,%dl
 195:	75 0c                	jne    1a3 <strchr+0x1b>
 197:	eb 13                	jmp    1ac <strchr+0x24>
 199:	8d 76 00             	lea    0x0(%esi),%esi
 19c:	40                   	inc    %eax
 19d:	8a 10                	mov    (%eax),%dl
 19f:	84 d2                	test   %dl,%dl
 1a1:	74 09                	je     1ac <strchr+0x24>
    if(*s == c)
 1a3:	38 d1                	cmp    %dl,%cl
 1a5:	75 f5                	jne    19c <strchr+0x14>
      return (char*)s;
  return 0;
}
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 1ac:	31 c0                	xor    %eax,%eax
}
 1ae:	5d                   	pop    %ebp
 1af:	c3                   	ret    

000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	56                   	push   %esi
 1b5:	53                   	push   %ebx
 1b6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 1bb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1be:	eb 24                	jmp    1e4 <gets+0x34>
    cc = read(0, &c, 1);
 1c0:	50                   	push   %eax
 1c1:	6a 01                	push   $0x1
 1c3:	57                   	push   %edi
 1c4:	6a 00                	push   $0x0
 1c6:	e8 08 01 00 00       	call   2d3 <read>
    if(cc < 1)
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	85 c0                	test   %eax,%eax
 1d0:	7e 1c                	jle    1ee <gets+0x3e>
      break;
    buf[i++] = c;
 1d2:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d5:	8b 55 08             	mov    0x8(%ebp),%edx
 1d8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 20                	je     200 <gets+0x50>
 1e0:	3c 0d                	cmp    $0xd,%al
 1e2:	74 1c                	je     200 <gets+0x50>
  for(i=0; i+1 < max; ){
 1e4:	89 de                	mov    %ebx,%esi
 1e6:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1e9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ec:	7c d2                	jl     1c0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f8:	5b                   	pop    %ebx
 1f9:	5e                   	pop    %esi
 1fa:	5f                   	pop    %edi
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
 200:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 209:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5f                   	pop    %edi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    
 211:	8d 76 00             	lea    0x0(%esi),%esi

00000214 <stat>:

int
stat(const char *n, struct stat *st)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	56                   	push   %esi
 218:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	6a 00                	push   $0x0
 21e:	ff 75 08             	push   0x8(%ebp)
 221:	e8 d5 00 00 00       	call   2fb <open>
  if(fd < 0)
 226:	83 c4 10             	add    $0x10,%esp
 229:	85 c0                	test   %eax,%eax
 22b:	78 27                	js     254 <stat+0x40>
 22d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22f:	83 ec 08             	sub    $0x8,%esp
 232:	ff 75 0c             	push   0xc(%ebp)
 235:	50                   	push   %eax
 236:	e8 d8 00 00 00       	call   313 <fstat>
 23b:	89 c6                	mov    %eax,%esi
  close(fd);
 23d:	89 1c 24             	mov    %ebx,(%esp)
 240:	e8 9e 00 00 00       	call   2e3 <close>
  return r;
 245:	83 c4 10             	add    $0x10,%esp
}
 248:	89 f0                	mov    %esi,%eax
 24a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 24d:	5b                   	pop    %ebx
 24e:	5e                   	pop    %esi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 254:	be ff ff ff ff       	mov    $0xffffffff,%esi
 259:	eb ed                	jmp    248 <stat+0x34>
 25b:	90                   	nop

0000025c <atoi>:

int
atoi(const char *s)
{
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	53                   	push   %ebx
 260:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 263:	0f be 01             	movsbl (%ecx),%eax
 266:	8d 50 d0             	lea    -0x30(%eax),%edx
 269:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 26c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 271:	77 16                	ja     289 <atoi+0x2d>
 273:	90                   	nop
    n = n*10 + *s++ - '0';
 274:	41                   	inc    %ecx
 275:	8d 14 92             	lea    (%edx,%edx,4),%edx
 278:	01 d2                	add    %edx,%edx
 27a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 27e:	0f be 01             	movsbl (%ecx),%eax
 281:	8d 58 d0             	lea    -0x30(%eax),%ebx
 284:	80 fb 09             	cmp    $0x9,%bl
 287:	76 eb                	jbe    274 <atoi+0x18>
  return n;
}
 289:	89 d0                	mov    %edx,%eax
 28b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 28e:	c9                   	leave  
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	56                   	push   %esi
 295:	8b 55 08             	mov    0x8(%ebp),%edx
 298:	8b 75 0c             	mov    0xc(%ebp),%esi
 29b:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 0b                	jle    2ad <memmove+0x1d>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 2a8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2a9:	39 f8                	cmp    %edi,%eax
 2ab:	75 fb                	jne    2a8 <memmove+0x18>
  return vdst;
}
 2ad:	89 d0                	mov    %edx,%eax
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b3:	b8 01 00 00 00       	mov    $0x1,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <exit>:
SYSCALL(exit)
 2bb:	b8 02 00 00 00       	mov    $0x2,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <wait>:
SYSCALL(wait)
 2c3:	b8 03 00 00 00       	mov    $0x3,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <pipe>:
SYSCALL(pipe)
 2cb:	b8 04 00 00 00       	mov    $0x4,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <read>:
SYSCALL(read)
 2d3:	b8 05 00 00 00       	mov    $0x5,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <write>:
SYSCALL(write)
 2db:	b8 10 00 00 00       	mov    $0x10,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <close>:
SYSCALL(close)
 2e3:	b8 15 00 00 00       	mov    $0x15,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <kill>:
SYSCALL(kill)
 2eb:	b8 06 00 00 00       	mov    $0x6,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <exec>:
SYSCALL(exec)
 2f3:	b8 07 00 00 00       	mov    $0x7,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <open>:
SYSCALL(open)
 2fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <mknod>:
SYSCALL(mknod)
 303:	b8 11 00 00 00       	mov    $0x11,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <unlink>:
SYSCALL(unlink)
 30b:	b8 12 00 00 00       	mov    $0x12,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <fstat>:
SYSCALL(fstat)
 313:	b8 08 00 00 00       	mov    $0x8,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <link>:
SYSCALL(link)
 31b:	b8 13 00 00 00       	mov    $0x13,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <mkdir>:
SYSCALL(mkdir)
 323:	b8 14 00 00 00       	mov    $0x14,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <chdir>:
SYSCALL(chdir)
 32b:	b8 09 00 00 00       	mov    $0x9,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <dup>:
SYSCALL(dup)
 333:	b8 0a 00 00 00       	mov    $0xa,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <getpid>:
SYSCALL(getpid)
 33b:	b8 0b 00 00 00       	mov    $0xb,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sbrk>:
SYSCALL(sbrk)
 343:	b8 0c 00 00 00       	mov    $0xc,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sleep>:
SYSCALL(sleep)
 34b:	b8 0d 00 00 00       	mov    $0xd,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <uptime>:
 353:	b8 0e 00 00 00       	mov    $0xe,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    
 35b:	90                   	nop

0000035c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	57                   	push   %edi
 360:	56                   	push   %esi
 361:	53                   	push   %ebx
 362:	83 ec 3c             	sub    $0x3c,%esp
 365:	89 45 bc             	mov    %eax,-0x44(%ebp)
 368:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 36b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 36d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 370:	85 db                	test   %ebx,%ebx
 372:	74 04                	je     378 <printint+0x1c>
 374:	85 d2                	test   %edx,%edx
 376:	78 68                	js     3e0 <printint+0x84>
  neg = 0;
 378:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37f:	31 ff                	xor    %edi,%edi
 381:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 384:	89 c8                	mov    %ecx,%eax
 386:	31 d2                	xor    %edx,%edx
 388:	f7 75 c4             	divl   -0x3c(%ebp)
 38b:	89 fb                	mov    %edi,%ebx
 38d:	8d 7f 01             	lea    0x1(%edi),%edi
 390:	8a 92 78 07 00 00    	mov    0x778(%edx),%dl
 396:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 39a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3a2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 3a5:	76 dd                	jbe    384 <printint+0x28>
  if(neg)
 3a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3aa:	85 c9                	test   %ecx,%ecx
 3ac:	74 09                	je     3b7 <printint+0x5b>
    buf[i++] = '-';
 3ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 3b3:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 3b5:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 3b7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 3bb:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3be:	eb 03                	jmp    3c3 <printint+0x67>
    putc(fd, buf[i]);
 3c0:	8a 13                	mov    (%ebx),%dl
 3c2:	4b                   	dec    %ebx
 3c3:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 3c6:	50                   	push   %eax
 3c7:	6a 01                	push   $0x1
 3c9:	56                   	push   %esi
 3ca:	57                   	push   %edi
 3cb:	e8 0b ff ff ff       	call   2db <write>
  while(--i >= 0)
 3d0:	83 c4 10             	add    $0x10,%esp
 3d3:	39 de                	cmp    %ebx,%esi
 3d5:	75 e9                	jne    3c0 <printint+0x64>
}
 3d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3da:	5b                   	pop    %ebx
 3db:	5e                   	pop    %esi
 3dc:	5f                   	pop    %edi
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop
    x = -xx;
 3e0:	f7 d9                	neg    %ecx
 3e2:	eb 9b                	jmp    37f <printint+0x23>

000003e4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	56                   	push   %esi
 3e9:	53                   	push   %ebx
 3ea:	83 ec 2c             	sub    $0x2c,%esp
 3ed:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3f3:	8a 13                	mov    (%ebx),%dl
 3f5:	84 d2                	test   %dl,%dl
 3f7:	74 64                	je     45d <printf+0x79>
 3f9:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 3fa:	8d 45 10             	lea    0x10(%ebp),%eax
 3fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 400:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 402:	8d 7d e7             	lea    -0x19(%ebp),%edi
 405:	eb 24                	jmp    42b <printf+0x47>
 407:	90                   	nop
 408:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 40b:	83 f8 25             	cmp    $0x25,%eax
 40e:	74 40                	je     450 <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 410:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 413:	50                   	push   %eax
 414:	6a 01                	push   $0x1
 416:	57                   	push   %edi
 417:	56                   	push   %esi
 418:	e8 be fe ff ff       	call   2db <write>
        putc(fd, c);
 41d:	83 c4 10             	add    $0x10,%esp
 420:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 423:	43                   	inc    %ebx
 424:	8a 53 ff             	mov    -0x1(%ebx),%dl
 427:	84 d2                	test   %dl,%dl
 429:	74 32                	je     45d <printf+0x79>
    c = fmt[i] & 0xff;
 42b:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 42e:	85 c9                	test   %ecx,%ecx
 430:	74 d6                	je     408 <printf+0x24>
      }
    } else if(state == '%'){
 432:	83 f9 25             	cmp    $0x25,%ecx
 435:	75 ec                	jne    423 <printf+0x3f>
      if(c == 'd'){
 437:	83 f8 25             	cmp    $0x25,%eax
 43a:	0f 84 e4 00 00 00    	je     524 <printf+0x140>
 440:	83 e8 63             	sub    $0x63,%eax
 443:	83 f8 15             	cmp    $0x15,%eax
 446:	77 20                	ja     468 <printf+0x84>
 448:	ff 24 85 20 07 00 00 	jmp    *0x720(,%eax,4)
 44f:	90                   	nop
        state = '%';
 450:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 455:	43                   	inc    %ebx
 456:	8a 53 ff             	mov    -0x1(%ebx),%dl
 459:	84 d2                	test   %dl,%dl
 45b:	75 ce                	jne    42b <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 45d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 460:	5b                   	pop    %ebx
 461:	5e                   	pop    %esi
 462:	5f                   	pop    %edi
 463:	5d                   	pop    %ebp
 464:	c3                   	ret    
 465:	8d 76 00             	lea    0x0(%esi),%esi
 468:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 46b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 46f:	50                   	push   %eax
 470:	6a 01                	push   $0x1
 472:	57                   	push   %edi
 473:	56                   	push   %esi
 474:	e8 62 fe ff ff       	call   2db <write>
        putc(fd, c);
 479:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 47c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 47f:	83 c4 0c             	add    $0xc,%esp
 482:	6a 01                	push   $0x1
 484:	57                   	push   %edi
 485:	56                   	push   %esi
 486:	e8 50 fe ff ff       	call   2db <write>
        putc(fd, c);
 48b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 48e:	31 c9                	xor    %ecx,%ecx
 490:	eb 91                	jmp    423 <printf+0x3f>
 492:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 494:	83 ec 0c             	sub    $0xc,%esp
 497:	6a 00                	push   $0x0
 499:	b9 10 00 00 00       	mov    $0x10,%ecx
 49e:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4a1:	8b 10                	mov    (%eax),%edx
 4a3:	89 f0                	mov    %esi,%eax
 4a5:	e8 b2 fe ff ff       	call   35c <printint>
        ap++;
 4aa:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 4ae:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4b1:	31 c9                	xor    %ecx,%ecx
        ap++;
 4b3:	e9 6b ff ff ff       	jmp    423 <printf+0x3f>
        s = (char*)*ap;
 4b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4bb:	8b 10                	mov    (%eax),%edx
        ap++;
 4bd:	83 c0 04             	add    $0x4,%eax
 4c0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4c3:	85 d2                	test   %edx,%edx
 4c5:	74 69                	je     530 <printf+0x14c>
        while(*s != 0){
 4c7:	8a 02                	mov    (%edx),%al
 4c9:	84 c0                	test   %al,%al
 4cb:	74 71                	je     53e <printf+0x15a>
 4cd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 4d0:	89 d3                	mov    %edx,%ebx
 4d2:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 4d4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 4d7:	50                   	push   %eax
 4d8:	6a 01                	push   $0x1
 4da:	57                   	push   %edi
 4db:	56                   	push   %esi
 4dc:	e8 fa fd ff ff       	call   2db <write>
          s++;
 4e1:	43                   	inc    %ebx
        while(*s != 0){
 4e2:	8a 03                	mov    (%ebx),%al
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	84 c0                	test   %al,%al
 4e9:	75 e9                	jne    4d4 <printf+0xf0>
      state = 0;
 4eb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 4ee:	31 c9                	xor    %ecx,%ecx
 4f0:	e9 2e ff ff ff       	jmp    423 <printf+0x3f>
 4f5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	6a 01                	push   $0x1
 4fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 502:	eb 9a                	jmp    49e <printf+0xba>
        putc(fd, *ap);
 504:	8b 45 d0             	mov    -0x30(%ebp),%eax
 507:	8b 00                	mov    (%eax),%eax
 509:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 50c:	51                   	push   %ecx
 50d:	6a 01                	push   $0x1
 50f:	57                   	push   %edi
 510:	56                   	push   %esi
 511:	e8 c5 fd ff ff       	call   2db <write>
        ap++;
 516:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 51a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51d:	31 c9                	xor    %ecx,%ecx
 51f:	e9 ff fe ff ff       	jmp    423 <printf+0x3f>
        putc(fd, c);
 524:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 527:	52                   	push   %edx
 528:	e9 55 ff ff ff       	jmp    482 <printf+0x9e>
 52d:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 530:	ba 18 07 00 00       	mov    $0x718,%edx
        while(*s != 0){
 535:	b0 28                	mov    $0x28,%al
 537:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 53a:	89 d3                	mov    %edx,%ebx
 53c:	eb 96                	jmp    4d4 <printf+0xf0>
      state = 0;
 53e:	31 c9                	xor    %ecx,%ecx
 540:	e9 de fe ff ff       	jmp    423 <printf+0x3f>
 545:	66 90                	xchg   %ax,%ax
 547:	90                   	nop

00000548 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 548:	55                   	push   %ebp
 549:	89 e5                	mov    %esp,%ebp
 54b:	57                   	push   %edi
 54c:	56                   	push   %esi
 54d:	53                   	push   %ebx
 54e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 551:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 554:	a1 94 07 00 00       	mov    0x794,%eax
 559:	8d 76 00             	lea    0x0(%esi),%esi
 55c:	89 c2                	mov    %eax,%edx
 55e:	8b 00                	mov    (%eax),%eax
 560:	39 ca                	cmp    %ecx,%edx
 562:	73 2c                	jae    590 <free+0x48>
 564:	39 c1                	cmp    %eax,%ecx
 566:	72 04                	jb     56c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 568:	39 c2                	cmp    %eax,%edx
 56a:	72 f0                	jb     55c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 56c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 572:	39 f8                	cmp    %edi,%eax
 574:	74 2c                	je     5a2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 576:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 579:	8b 42 04             	mov    0x4(%edx),%eax
 57c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 57f:	39 f1                	cmp    %esi,%ecx
 581:	74 36                	je     5b9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 583:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 585:	89 15 94 07 00 00    	mov    %edx,0x794
}
 58b:	5b                   	pop    %ebx
 58c:	5e                   	pop    %esi
 58d:	5f                   	pop    %edi
 58e:	5d                   	pop    %ebp
 58f:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 590:	39 c2                	cmp    %eax,%edx
 592:	72 c8                	jb     55c <free+0x14>
 594:	39 c1                	cmp    %eax,%ecx
 596:	73 c4                	jae    55c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 598:	8b 73 fc             	mov    -0x4(%ebx),%esi
 59b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 59e:	39 f8                	cmp    %edi,%eax
 5a0:	75 d4                	jne    576 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 5a2:	03 70 04             	add    0x4(%eax),%esi
 5a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a8:	8b 02                	mov    (%edx),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 5af:	8b 42 04             	mov    0x4(%edx),%eax
 5b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 5b5:	39 f1                	cmp    %esi,%ecx
 5b7:	75 ca                	jne    583 <free+0x3b>
    p->s.size += bp->s.size;
 5b9:	03 43 fc             	add    -0x4(%ebx),%eax
 5bc:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 5bf:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 5c2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 5c4:	89 15 94 07 00 00    	mov    %edx,0x794
}
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5f                   	pop    %edi
 5cd:	5d                   	pop    %ebp
 5ce:	c3                   	ret    
 5cf:	90                   	nop

000005d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	8d 70 07             	lea    0x7(%eax),%esi
 5df:	c1 ee 03             	shr    $0x3,%esi
 5e2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 5e3:	8b 3d 94 07 00 00    	mov    0x794,%edi
 5e9:	85 ff                	test   %edi,%edi
 5eb:	0f 84 a3 00 00 00    	je     694 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 5f3:	8b 4a 04             	mov    0x4(%edx),%ecx
 5f6:	39 f1                	cmp    %esi,%ecx
 5f8:	73 68                	jae    662 <malloc+0x92>
 5fa:	89 f3                	mov    %esi,%ebx
 5fc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 602:	0f 82 80 00 00 00    	jb     688 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 608:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 60f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 612:	eb 11                	jmp    625 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 614:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 616:	8b 48 04             	mov    0x4(%eax),%ecx
 619:	39 f1                	cmp    %esi,%ecx
 61b:	73 4b                	jae    668 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 61d:	8b 3d 94 07 00 00    	mov    0x794,%edi
 623:	89 c2                	mov    %eax,%edx
 625:	39 d7                	cmp    %edx,%edi
 627:	75 eb                	jne    614 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 629:	83 ec 0c             	sub    $0xc,%esp
 62c:	ff 75 e4             	push   -0x1c(%ebp)
 62f:	e8 0f fd ff ff       	call   343 <sbrk>
  if(p == (char*)-1)
 634:	83 c4 10             	add    $0x10,%esp
 637:	83 f8 ff             	cmp    $0xffffffff,%eax
 63a:	74 1c                	je     658 <malloc+0x88>
  hp->s.size = nu;
 63c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 63f:	83 ec 0c             	sub    $0xc,%esp
 642:	83 c0 08             	add    $0x8,%eax
 645:	50                   	push   %eax
 646:	e8 fd fe ff ff       	call   548 <free>
  return freep;
 64b:	8b 15 94 07 00 00    	mov    0x794,%edx
      if((p = morecore(nunits)) == 0)
 651:	83 c4 10             	add    $0x10,%esp
 654:	85 d2                	test   %edx,%edx
 656:	75 bc                	jne    614 <malloc+0x44>
        return 0;
 658:	31 c0                	xor    %eax,%eax
  }
}
 65a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65d:	5b                   	pop    %ebx
 65e:	5e                   	pop    %esi
 65f:	5f                   	pop    %edi
 660:	5d                   	pop    %ebp
 661:	c3                   	ret    
    if(p->s.size >= nunits){
 662:	89 d0                	mov    %edx,%eax
 664:	89 fa                	mov    %edi,%edx
 666:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 668:	39 ce                	cmp    %ecx,%esi
 66a:	74 54                	je     6c0 <malloc+0xf0>
        p->s.size -= nunits;
 66c:	29 f1                	sub    %esi,%ecx
 66e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 671:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 674:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 677:	89 15 94 07 00 00    	mov    %edx,0x794
      return (void*)(p + 1);
 67d:	83 c0 08             	add    $0x8,%eax
}
 680:	8d 65 f4             	lea    -0xc(%ebp),%esp
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    
 688:	bb 00 10 00 00       	mov    $0x1000,%ebx
 68d:	e9 76 ff ff ff       	jmp    608 <malloc+0x38>
 692:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 694:	c7 05 94 07 00 00 98 	movl   $0x798,0x794
 69b:	07 00 00 
 69e:	c7 05 98 07 00 00 98 	movl   $0x798,0x798
 6a5:	07 00 00 
    base.s.size = 0;
 6a8:	c7 05 9c 07 00 00 00 	movl   $0x0,0x79c
 6af:	00 00 00 
 6b2:	bf 98 07 00 00       	mov    $0x798,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b7:	89 fa                	mov    %edi,%edx
 6b9:	e9 3c ff ff ff       	jmp    5fa <malloc+0x2a>
 6be:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 6c0:	8b 08                	mov    (%eax),%ecx
 6c2:	89 0a                	mov    %ecx,(%edx)
 6c4:	eb b1                	jmp    677 <malloc+0xa7>
