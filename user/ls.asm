
user/_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 1e                	jle    3c <main+0x3c>
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	90                   	nop
    ls(argv[i]);
  24:	83 ec 0c             	sub    $0xc,%esp
  27:	ff 34 9f             	push   (%edi,%ebx,4)
  2a:	e8 b1 00 00 00       	call   e0 <ls>
  for(i=1; i<argc; i++)
  2f:	43                   	inc    %ebx
  30:	83 c4 10             	add    $0x10,%esp
  33:	39 de                	cmp    %ebx,%esi
  35:	75 ed                	jne    24 <main+0x24>
  exit();
  37:	e8 8f 04 00 00       	call   4cb <exit>
    ls(".");
  3c:	83 ec 0c             	sub    $0xc,%esp
  3f:	68 20 09 00 00       	push   $0x920
  44:	e8 97 00 00 00       	call   e0 <ls>
    exit();
  49:	e8 7d 04 00 00       	call   4cb <exit>
  4e:	66 90                	xchg   %ax,%ax

00000050 <fmtname>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	56                   	push   %esi
  5c:	e8 f7 02 00 00       	call   358 <strlen>
  61:	83 c4 10             	add    $0x10,%esp
  64:	01 f0                	add    %esi,%eax
  66:	89 c3                	mov    %eax,%ebx
  68:	73 0b                	jae    75 <fmtname+0x25>
  6a:	eb 0e                	jmp    7a <fmtname+0x2a>
  6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  6f:	39 c6                	cmp    %eax,%esi
  71:	77 08                	ja     7b <fmtname+0x2b>
  73:	89 c3                	mov    %eax,%ebx
  75:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  78:	75 f2                	jne    6c <fmtname+0x1c>
  p++;
  7a:	43                   	inc    %ebx
  if(strlen(p) >= DIRSIZ)
  7b:	83 ec 0c             	sub    $0xc,%esp
  7e:	53                   	push   %ebx
  7f:	e8 d4 02 00 00       	call   358 <strlen>
  84:	83 c4 10             	add    $0x10,%esp
  87:	83 f8 0d             	cmp    $0xd,%eax
  8a:	77 4a                	ja     d6 <fmtname+0x86>
  memmove(buf, p, strlen(p));
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	53                   	push   %ebx
  90:	e8 c3 02 00 00       	call   358 <strlen>
  95:	83 c4 0c             	add    $0xc,%esp
  98:	50                   	push   %eax
  99:	53                   	push   %ebx
  9a:	68 98 09 00 00       	push   $0x998
  9f:	e8 fc 03 00 00       	call   4a0 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  a4:	89 1c 24             	mov    %ebx,(%esp)
  a7:	e8 ac 02 00 00       	call   358 <strlen>
  ac:	89 c6                	mov    %eax,%esi
  ae:	89 1c 24             	mov    %ebx,(%esp)
  b1:	e8 a2 02 00 00       	call   358 <strlen>
  b6:	83 c4 0c             	add    $0xc,%esp
  b9:	ba 0e 00 00 00       	mov    $0xe,%edx
  be:	29 f2                	sub    %esi,%edx
  c0:	52                   	push   %edx
  c1:	6a 20                	push   $0x20
  c3:	05 98 09 00 00       	add    $0x998,%eax
  c8:	50                   	push   %eax
  c9:	e8 b2 02 00 00       	call   380 <memset>
  return buf;
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	bb 98 09 00 00       	mov    $0x998,%ebx
}
  d6:	89 d8                	mov    %ebx,%eax
  d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  db:	5b                   	pop    %ebx
  dc:	5e                   	pop    %esi
  dd:	5d                   	pop    %ebp
  de:	c3                   	ret    
  df:	90                   	nop

000000e0 <ls>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	57                   	push   %edi
  e4:	56                   	push   %esi
  e5:	53                   	push   %ebx
  e6:	81 ec 64 02 00 00    	sub    $0x264,%esp
  ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
  ef:	6a 00                	push   $0x0
  f1:	57                   	push   %edi
  f2:	e8 14 04 00 00       	call   50b <open>
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	0f 88 82 01 00 00    	js     284 <ls+0x1a4>
 102:	89 c3                	mov    %eax,%ebx
  if(fstat(fd, &st) < 0){
 104:	83 ec 08             	sub    $0x8,%esp
 107:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 10d:	56                   	push   %esi
 10e:	50                   	push   %eax
 10f:	e8 0f 04 00 00       	call   523 <fstat>
 114:	83 c4 10             	add    $0x10,%esp
 117:	85 c0                	test   %eax,%eax
 119:	0f 88 99 01 00 00    	js     2b8 <ls+0x1d8>
  switch(st.type){
 11f:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 125:	66 83 f8 01          	cmp    $0x1,%ax
 129:	74 59                	je     184 <ls+0xa4>
 12b:	66 83 f8 02          	cmp    $0x2,%ax
 12f:	74 17                	je     148 <ls+0x68>
  close(fd);
 131:	83 ec 0c             	sub    $0xc,%esp
 134:	53                   	push   %ebx
 135:	e8 b9 03 00 00       	call   4f3 <close>
 13a:	83 c4 10             	add    $0x10,%esp
}
 13d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 140:	5b                   	pop    %ebx
 141:	5e                   	pop    %esi
 142:	5f                   	pop    %edi
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    
 145:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 148:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 14e:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 154:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 15a:	83 ec 0c             	sub    $0xc,%esp
 15d:	57                   	push   %edi
 15e:	e8 ed fe ff ff       	call   50 <fmtname>
 163:	59                   	pop    %ecx
 164:	5f                   	pop    %edi
 165:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 16b:	52                   	push   %edx
 16c:	56                   	push   %esi
 16d:	6a 02                	push   $0x2
 16f:	50                   	push   %eax
 170:	68 00 09 00 00       	push   $0x900
 175:	6a 01                	push   $0x1
 177:	e8 78 04 00 00       	call   5f4 <printf>
    break;
 17c:	83 c4 20             	add    $0x20,%esp
 17f:	eb b0                	jmp    131 <ls+0x51>
 181:	8d 76 00             	lea    0x0(%esi),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	57                   	push   %edi
 188:	e8 cb 01 00 00       	call   358 <strlen>
 18d:	83 c0 10             	add    $0x10,%eax
 190:	83 c4 10             	add    $0x10,%esp
 193:	3d 00 02 00 00       	cmp    $0x200,%eax
 198:	0f 87 02 01 00 00    	ja     2a0 <ls+0x1c0>
    strcpy(buf, path);
 19e:	83 ec 08             	sub    $0x8,%esp
 1a1:	57                   	push   %edi
 1a2:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1a8:	57                   	push   %edi
 1a9:	e8 46 01 00 00       	call   2f4 <strcpy>
    p = buf+strlen(buf);
 1ae:	89 3c 24             	mov    %edi,(%esp)
 1b1:	e8 a2 01 00 00       	call   358 <strlen>
 1b6:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
 1b9:	89 8d a8 fd ff ff    	mov    %ecx,-0x258(%ebp)
    *p++ = '/';
 1bf:	8d 44 07 01          	lea    0x1(%edi,%eax,1),%eax
 1c3:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 1c9:	c6 01 2f             	movb   $0x2f,(%ecx)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	90                   	nop
 1d0:	50                   	push   %eax
 1d1:	6a 10                	push   $0x10
 1d3:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1d9:	50                   	push   %eax
 1da:	53                   	push   %ebx
 1db:	e8 03 03 00 00       	call   4e3 <read>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	83 f8 10             	cmp    $0x10,%eax
 1e6:	0f 85 45 ff ff ff    	jne    131 <ls+0x51>
      if(de.inum == 0)
 1ec:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 1f3:	00 
 1f4:	74 da                	je     1d0 <ls+0xf0>
      memmove(p, de.name, DIRSIZ);
 1f6:	50                   	push   %eax
 1f7:	6a 0e                	push   $0xe
 1f9:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 1ff:	50                   	push   %eax
 200:	ff b5 a4 fd ff ff    	push   -0x25c(%ebp)
 206:	e8 95 02 00 00       	call   4a0 <memmove>
      p[DIRSIZ] = 0;
 20b:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 211:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 215:	58                   	pop    %eax
 216:	5a                   	pop    %edx
 217:	56                   	push   %esi
 218:	57                   	push   %edi
 219:	e8 06 02 00 00       	call   424 <stat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	85 c0                	test   %eax,%eax
 223:	0f 88 b3 00 00 00    	js     2dc <ls+0x1fc>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 229:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 22f:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 235:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 23b:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 241:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 248:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	57                   	push   %edi
 252:	e8 f9 fd ff ff       	call   50 <fmtname>
 257:	5a                   	pop    %edx
 258:	59                   	pop    %ecx
 259:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 25f:	51                   	push   %ecx
 260:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 266:	52                   	push   %edx
 267:	ff b5 b4 fd ff ff    	push   -0x24c(%ebp)
 26d:	50                   	push   %eax
 26e:	68 00 09 00 00       	push   $0x900
 273:	6a 01                	push   $0x1
 275:	e8 7a 03 00 00       	call   5f4 <printf>
 27a:	83 c4 20             	add    $0x20,%esp
 27d:	e9 4e ff ff ff       	jmp    1d0 <ls+0xf0>
 282:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot open %s\n", path);
 284:	50                   	push   %eax
 285:	57                   	push   %edi
 286:	68 d8 08 00 00       	push   $0x8d8
 28b:	6a 02                	push   $0x2
 28d:	e8 62 03 00 00       	call   5f4 <printf>
    return;
 292:	83 c4 10             	add    $0x10,%esp
}
 295:	8d 65 f4             	lea    -0xc(%ebp),%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "ls: path too long\n");
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	68 0d 09 00 00       	push   $0x90d
 2a8:	6a 01                	push   $0x1
 2aa:	e8 45 03 00 00       	call   5f4 <printf>
      break;
 2af:	83 c4 10             	add    $0x10,%esp
 2b2:	e9 7a fe ff ff       	jmp    131 <ls+0x51>
 2b7:	90                   	nop
    printf(2, "ls: cannot stat %s\n", path);
 2b8:	50                   	push   %eax
 2b9:	57                   	push   %edi
 2ba:	68 ec 08 00 00       	push   $0x8ec
 2bf:	6a 02                	push   $0x2
 2c1:	e8 2e 03 00 00       	call   5f4 <printf>
    close(fd);
 2c6:	89 1c 24             	mov    %ebx,(%esp)
 2c9:	e8 25 02 00 00       	call   4f3 <close>
    return;
 2ce:	83 c4 10             	add    $0x10,%esp
}
 2d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d4:	5b                   	pop    %ebx
 2d5:	5e                   	pop    %esi
 2d6:	5f                   	pop    %edi
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, "ls: cannot stat %s\n", buf);
 2dc:	50                   	push   %eax
 2dd:	57                   	push   %edi
 2de:	68 ec 08 00 00       	push   $0x8ec
 2e3:	6a 01                	push   $0x1
 2e5:	e8 0a 03 00 00       	call   5f4 <printf>
        continue;
 2ea:	83 c4 10             	add    $0x10,%esp
 2ed:	e9 de fe ff ff       	jmp    1d0 <ls+0xf0>
 2f2:	66 90                	xchg   %ax,%ax

000002f4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	53                   	push   %ebx
 2f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fe:	31 c0                	xor    %eax,%eax
 300:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 303:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 306:	40                   	inc    %eax
 307:	84 d2                	test   %dl,%dl
 309:	75 f5                	jne    300 <strcpy+0xc>
    ;
  return os;
}
 30b:	89 c8                	mov    %ecx,%eax
 30d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 310:	c9                   	leave  
 311:	c3                   	ret    
 312:	66 90                	xchg   %ax,%ax

00000314 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	8b 55 08             	mov    0x8(%ebp),%edx
 31b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 31e:	0f b6 02             	movzbl (%edx),%eax
 321:	84 c0                	test   %al,%al
 323:	75 10                	jne    335 <strcmp+0x21>
 325:	eb 2a                	jmp    351 <strcmp+0x3d>
 327:	90                   	nop
    p++, q++;
 328:	42                   	inc    %edx
 329:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 32c:	0f b6 02             	movzbl (%edx),%eax
 32f:	84 c0                	test   %al,%al
 331:	74 11                	je     344 <strcmp+0x30>
    p++, q++;
 333:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
 335:	0f b6 0b             	movzbl (%ebx),%ecx
 338:	38 c1                	cmp    %al,%cl
 33a:	74 ec                	je     328 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 33c:	29 c8                	sub    %ecx,%eax
}
 33e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 341:	c9                   	leave  
 342:	c3                   	ret    
 343:	90                   	nop
  return (uchar)*p - (uchar)*q;
 344:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 348:	31 c0                	xor    %eax,%eax
 34a:	29 c8                	sub    %ecx,%eax
}
 34c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 34f:	c9                   	leave  
 350:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 351:	0f b6 0b             	movzbl (%ebx),%ecx
 354:	31 c0                	xor    %eax,%eax
 356:	eb e4                	jmp    33c <strcmp+0x28>

00000358 <strlen>:

uint
strlen(const char *s)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 35e:	80 3a 00             	cmpb   $0x0,(%edx)
 361:	74 15                	je     378 <strlen+0x20>
 363:	31 c0                	xor    %eax,%eax
 365:	8d 76 00             	lea    0x0(%esi),%esi
 368:	40                   	inc    %eax
 369:	89 c1                	mov    %eax,%ecx
 36b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 36f:	75 f7                	jne    368 <strlen+0x10>
    ;
  return n;
}
 371:	89 c8                	mov    %ecx,%eax
 373:	5d                   	pop    %ebp
 374:	c3                   	ret    
 375:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 378:	31 c9                	xor    %ecx,%ecx
}
 37a:	89 c8                	mov    %ecx,%eax
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    
 37e:	66 90                	xchg   %ax,%ax

00000380 <memset>:

void*
memset(void *dst, int c, uint n)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 384:	8b 7d 08             	mov    0x8(%ebp),%edi
 387:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	fc                   	cld    
 38e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8b 7d fc             	mov    -0x4(%ebp),%edi
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <strchr>:

char*
strchr(const char *s, char c)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 3a1:	8a 10                	mov    (%eax),%dl
 3a3:	84 d2                	test   %dl,%dl
 3a5:	75 0c                	jne    3b3 <strchr+0x1b>
 3a7:	eb 13                	jmp    3bc <strchr+0x24>
 3a9:	8d 76 00             	lea    0x0(%esi),%esi
 3ac:	40                   	inc    %eax
 3ad:	8a 10                	mov    (%eax),%dl
 3af:	84 d2                	test   %dl,%dl
 3b1:	74 09                	je     3bc <strchr+0x24>
    if(*s == c)
 3b3:	38 d1                	cmp    %dl,%cl
 3b5:	75 f5                	jne    3ac <strchr+0x14>
      return (char*)s;
  return 0;
}
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    
 3b9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3bc:	31 c0                	xor    %eax,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	53                   	push   %ebx
 3c6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 3cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3ce:	eb 24                	jmp    3f4 <gets+0x34>
    cc = read(0, &c, 1);
 3d0:	50                   	push   %eax
 3d1:	6a 01                	push   $0x1
 3d3:	57                   	push   %edi
 3d4:	6a 00                	push   $0x0
 3d6:	e8 08 01 00 00       	call   4e3 <read>
    if(cc < 1)
 3db:	83 c4 10             	add    $0x10,%esp
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 1c                	jle    3fe <gets+0x3e>
      break;
    buf[i++] = c;
 3e2:	8a 45 e7             	mov    -0x19(%ebp),%al
 3e5:	8b 55 08             	mov    0x8(%ebp),%edx
 3e8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3ec:	3c 0a                	cmp    $0xa,%al
 3ee:	74 20                	je     410 <gets+0x50>
 3f0:	3c 0d                	cmp    $0xd,%al
 3f2:	74 1c                	je     410 <gets+0x50>
  for(i=0; i+1 < max; ){
 3f4:	89 de                	mov    %ebx,%esi
 3f6:	8d 5b 01             	lea    0x1(%ebx),%ebx
 3f9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3fc:	7c d2                	jl     3d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 405:	8d 65 f4             	lea    -0xc(%ebp),%esp
 408:	5b                   	pop    %ebx
 409:	5e                   	pop    %esi
 40a:	5f                   	pop    %edi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
 410:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 419:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41c:	5b                   	pop    %ebx
 41d:	5e                   	pop    %esi
 41e:	5f                   	pop    %edi
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	8d 76 00             	lea    0x0(%esi),%esi

00000424 <stat>:

int
stat(const char *n, struct stat *st)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	56                   	push   %esi
 428:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	6a 00                	push   $0x0
 42e:	ff 75 08             	push   0x8(%ebp)
 431:	e8 d5 00 00 00       	call   50b <open>
  if(fd < 0)
 436:	83 c4 10             	add    $0x10,%esp
 439:	85 c0                	test   %eax,%eax
 43b:	78 27                	js     464 <stat+0x40>
 43d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 43f:	83 ec 08             	sub    $0x8,%esp
 442:	ff 75 0c             	push   0xc(%ebp)
 445:	50                   	push   %eax
 446:	e8 d8 00 00 00       	call   523 <fstat>
 44b:	89 c6                	mov    %eax,%esi
  close(fd);
 44d:	89 1c 24             	mov    %ebx,(%esp)
 450:	e8 9e 00 00 00       	call   4f3 <close>
  return r;
 455:	83 c4 10             	add    $0x10,%esp
}
 458:	89 f0                	mov    %esi,%eax
 45a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 45d:	5b                   	pop    %ebx
 45e:	5e                   	pop    %esi
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 464:	be ff ff ff ff       	mov    $0xffffffff,%esi
 469:	eb ed                	jmp    458 <stat+0x34>
 46b:	90                   	nop

0000046c <atoi>:

int
atoi(const char *s)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	53                   	push   %ebx
 470:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 473:	0f be 01             	movsbl (%ecx),%eax
 476:	8d 50 d0             	lea    -0x30(%eax),%edx
 479:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 47c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 481:	77 16                	ja     499 <atoi+0x2d>
 483:	90                   	nop
    n = n*10 + *s++ - '0';
 484:	41                   	inc    %ecx
 485:	8d 14 92             	lea    (%edx,%edx,4),%edx
 488:	01 d2                	add    %edx,%edx
 48a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 48e:	0f be 01             	movsbl (%ecx),%eax
 491:	8d 58 d0             	lea    -0x30(%eax),%ebx
 494:	80 fb 09             	cmp    $0x9,%bl
 497:	76 eb                	jbe    484 <atoi+0x18>
  return n;
}
 499:	89 d0                	mov    %edx,%eax
 49b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 49e:	c9                   	leave  
 49f:	c3                   	ret    

000004a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	8b 55 08             	mov    0x8(%ebp),%edx
 4a8:	8b 75 0c             	mov    0xc(%ebp),%esi
 4ab:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ae:	85 c0                	test   %eax,%eax
 4b0:	7e 0b                	jle    4bd <memmove+0x1d>
 4b2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4b4:	89 d7                	mov    %edx,%edi
 4b6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4b8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4b9:	39 f8                	cmp    %edi,%eax
 4bb:	75 fb                	jne    4b8 <memmove+0x18>
  return vdst;
}
 4bd:	89 d0                	mov    %edx,%eax
 4bf:	5e                   	pop    %esi
 4c0:	5f                   	pop    %edi
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    

000004c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4c3:	b8 01 00 00 00       	mov    $0x1,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <exit>:
SYSCALL(exit)
 4cb:	b8 02 00 00 00       	mov    $0x2,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <wait>:
SYSCALL(wait)
 4d3:	b8 03 00 00 00       	mov    $0x3,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <pipe>:
SYSCALL(pipe)
 4db:	b8 04 00 00 00       	mov    $0x4,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <read>:
SYSCALL(read)
 4e3:	b8 05 00 00 00       	mov    $0x5,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <write>:
SYSCALL(write)
 4eb:	b8 10 00 00 00       	mov    $0x10,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <close>:
SYSCALL(close)
 4f3:	b8 15 00 00 00       	mov    $0x15,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <kill>:
SYSCALL(kill)
 4fb:	b8 06 00 00 00       	mov    $0x6,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <exec>:
SYSCALL(exec)
 503:	b8 07 00 00 00       	mov    $0x7,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <open>:
SYSCALL(open)
 50b:	b8 0f 00 00 00       	mov    $0xf,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <mknod>:
SYSCALL(mknod)
 513:	b8 11 00 00 00       	mov    $0x11,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <unlink>:
SYSCALL(unlink)
 51b:	b8 12 00 00 00       	mov    $0x12,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <fstat>:
SYSCALL(fstat)
 523:	b8 08 00 00 00       	mov    $0x8,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <link>:
SYSCALL(link)
 52b:	b8 13 00 00 00       	mov    $0x13,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <mkdir>:
SYSCALL(mkdir)
 533:	b8 14 00 00 00       	mov    $0x14,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <chdir>:
SYSCALL(chdir)
 53b:	b8 09 00 00 00       	mov    $0x9,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <dup>:
SYSCALL(dup)
 543:	b8 0a 00 00 00       	mov    $0xa,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <getpid>:
SYSCALL(getpid)
 54b:	b8 0b 00 00 00       	mov    $0xb,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <sbrk>:
SYSCALL(sbrk)
 553:	b8 0c 00 00 00       	mov    $0xc,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <sleep>:
SYSCALL(sleep)
 55b:	b8 0d 00 00 00       	mov    $0xd,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <uptime>:
 563:	b8 0e 00 00 00       	mov    $0xe,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    
 56b:	90                   	nop

0000056c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	57                   	push   %edi
 570:	56                   	push   %esi
 571:	53                   	push   %ebx
 572:	83 ec 3c             	sub    $0x3c,%esp
 575:	89 45 bc             	mov    %eax,-0x44(%ebp)
 578:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 57b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 57d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 580:	85 db                	test   %ebx,%ebx
 582:	74 04                	je     588 <printint+0x1c>
 584:	85 d2                	test   %edx,%edx
 586:	78 68                	js     5f0 <printint+0x84>
  neg = 0;
 588:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 58f:	31 ff                	xor    %edi,%edi
 591:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 594:	89 c8                	mov    %ecx,%eax
 596:	31 d2                	xor    %edx,%edx
 598:	f7 75 c4             	divl   -0x3c(%ebp)
 59b:	89 fb                	mov    %edi,%ebx
 59d:	8d 7f 01             	lea    0x1(%edi),%edi
 5a0:	8a 92 84 09 00 00    	mov    0x984(%edx),%dl
 5a6:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 5aa:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 5ad:	89 c1                	mov    %eax,%ecx
 5af:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5b2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 5b5:	76 dd                	jbe    594 <printint+0x28>
  if(neg)
 5b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5ba:	85 c9                	test   %ecx,%ecx
 5bc:	74 09                	je     5c7 <printint+0x5b>
    buf[i++] = '-';
 5be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 5c3:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 5c5:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 5c7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 5cb:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5ce:	eb 03                	jmp    5d3 <printint+0x67>
    putc(fd, buf[i]);
 5d0:	8a 13                	mov    (%ebx),%dl
 5d2:	4b                   	dec    %ebx
 5d3:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 5d6:	50                   	push   %eax
 5d7:	6a 01                	push   $0x1
 5d9:	56                   	push   %esi
 5da:	57                   	push   %edi
 5db:	e8 0b ff ff ff       	call   4eb <write>
  while(--i >= 0)
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	39 de                	cmp    %ebx,%esi
 5e5:	75 e9                	jne    5d0 <printint+0x64>
}
 5e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ea:	5b                   	pop    %ebx
 5eb:	5e                   	pop    %esi
 5ec:	5f                   	pop    %edi
 5ed:	5d                   	pop    %ebp
 5ee:	c3                   	ret    
 5ef:	90                   	nop
    x = -xx;
 5f0:	f7 d9                	neg    %ecx
 5f2:	eb 9b                	jmp    58f <printint+0x23>

000005f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	56                   	push   %esi
 5f9:	53                   	push   %ebx
 5fa:	83 ec 2c             	sub    $0x2c,%esp
 5fd:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 600:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 603:	8a 13                	mov    (%ebx),%dl
 605:	84 d2                	test   %dl,%dl
 607:	74 64                	je     66d <printf+0x79>
 609:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 60a:	8d 45 10             	lea    0x10(%ebp),%eax
 60d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 610:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 612:	8d 7d e7             	lea    -0x19(%ebp),%edi
 615:	eb 24                	jmp    63b <printf+0x47>
 617:	90                   	nop
 618:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 61b:	83 f8 25             	cmp    $0x25,%eax
 61e:	74 40                	je     660 <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 620:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 623:	50                   	push   %eax
 624:	6a 01                	push   $0x1
 626:	57                   	push   %edi
 627:	56                   	push   %esi
 628:	e8 be fe ff ff       	call   4eb <write>
        putc(fd, c);
 62d:	83 c4 10             	add    $0x10,%esp
 630:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 633:	43                   	inc    %ebx
 634:	8a 53 ff             	mov    -0x1(%ebx),%dl
 637:	84 d2                	test   %dl,%dl
 639:	74 32                	je     66d <printf+0x79>
    c = fmt[i] & 0xff;
 63b:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 63e:	85 c9                	test   %ecx,%ecx
 640:	74 d6                	je     618 <printf+0x24>
      }
    } else if(state == '%'){
 642:	83 f9 25             	cmp    $0x25,%ecx
 645:	75 ec                	jne    633 <printf+0x3f>
      if(c == 'd'){
 647:	83 f8 25             	cmp    $0x25,%eax
 64a:	0f 84 e4 00 00 00    	je     734 <printf+0x140>
 650:	83 e8 63             	sub    $0x63,%eax
 653:	83 f8 15             	cmp    $0x15,%eax
 656:	77 20                	ja     678 <printf+0x84>
 658:	ff 24 85 2c 09 00 00 	jmp    *0x92c(,%eax,4)
 65f:	90                   	nop
        state = '%';
 660:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 665:	43                   	inc    %ebx
 666:	8a 53 ff             	mov    -0x1(%ebx),%dl
 669:	84 d2                	test   %dl,%dl
 66b:	75 ce                	jne    63b <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 66d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 670:	5b                   	pop    %ebx
 671:	5e                   	pop    %esi
 672:	5f                   	pop    %edi
 673:	5d                   	pop    %ebp
 674:	c3                   	ret    
 675:	8d 76 00             	lea    0x0(%esi),%esi
 678:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 67b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 67f:	50                   	push   %eax
 680:	6a 01                	push   $0x1
 682:	57                   	push   %edi
 683:	56                   	push   %esi
 684:	e8 62 fe ff ff       	call   4eb <write>
        putc(fd, c);
 689:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 68c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 68f:	83 c4 0c             	add    $0xc,%esp
 692:	6a 01                	push   $0x1
 694:	57                   	push   %edi
 695:	56                   	push   %esi
 696:	e8 50 fe ff ff       	call   4eb <write>
        putc(fd, c);
 69b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69e:	31 c9                	xor    %ecx,%ecx
 6a0:	eb 91                	jmp    633 <printf+0x3f>
 6a2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6a4:	83 ec 0c             	sub    $0xc,%esp
 6a7:	6a 00                	push   $0x0
 6a9:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	89 f0                	mov    %esi,%eax
 6b5:	e8 b2 fe ff ff       	call   56c <printint>
        ap++;
 6ba:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6c1:	31 c9                	xor    %ecx,%ecx
        ap++;
 6c3:	e9 6b ff ff ff       	jmp    633 <printf+0x3f>
        s = (char*)*ap;
 6c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6cb:	8b 10                	mov    (%eax),%edx
        ap++;
 6cd:	83 c0 04             	add    $0x4,%eax
 6d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6d3:	85 d2                	test   %edx,%edx
 6d5:	74 69                	je     740 <printf+0x14c>
        while(*s != 0){
 6d7:	8a 02                	mov    (%edx),%al
 6d9:	84 c0                	test   %al,%al
 6db:	74 71                	je     74e <printf+0x15a>
 6dd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6e0:	89 d3                	mov    %edx,%ebx
 6e2:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 6e4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e7:	50                   	push   %eax
 6e8:	6a 01                	push   $0x1
 6ea:	57                   	push   %edi
 6eb:	56                   	push   %esi
 6ec:	e8 fa fd ff ff       	call   4eb <write>
          s++;
 6f1:	43                   	inc    %ebx
        while(*s != 0){
 6f2:	8a 03                	mov    (%ebx),%al
 6f4:	83 c4 10             	add    $0x10,%esp
 6f7:	84 c0                	test   %al,%al
 6f9:	75 e9                	jne    6e4 <printf+0xf0>
      state = 0;
 6fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 6fe:	31 c9                	xor    %ecx,%ecx
 700:	e9 2e ff ff ff       	jmp    633 <printf+0x3f>
 705:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 708:	83 ec 0c             	sub    $0xc,%esp
 70b:	6a 01                	push   $0x1
 70d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 712:	eb 9a                	jmp    6ae <printf+0xba>
        putc(fd, *ap);
 714:	8b 45 d0             	mov    -0x30(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 71c:	51                   	push   %ecx
 71d:	6a 01                	push   $0x1
 71f:	57                   	push   %edi
 720:	56                   	push   %esi
 721:	e8 c5 fd ff ff       	call   4eb <write>
        ap++;
 726:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 72a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72d:	31 c9                	xor    %ecx,%ecx
 72f:	e9 ff fe ff ff       	jmp    633 <printf+0x3f>
        putc(fd, c);
 734:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 737:	52                   	push   %edx
 738:	e9 55 ff ff ff       	jmp    692 <printf+0x9e>
 73d:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 740:	ba 22 09 00 00       	mov    $0x922,%edx
        while(*s != 0){
 745:	b0 28                	mov    $0x28,%al
 747:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 74a:	89 d3                	mov    %edx,%ebx
 74c:	eb 96                	jmp    6e4 <printf+0xf0>
      state = 0;
 74e:	31 c9                	xor    %ecx,%ecx
 750:	e9 de fe ff ff       	jmp    633 <printf+0x3f>
 755:	66 90                	xchg   %ax,%ax
 757:	90                   	nop

00000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	57                   	push   %edi
 75c:	56                   	push   %esi
 75d:	53                   	push   %ebx
 75e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 761:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	a1 a8 09 00 00       	mov    0x9a8,%eax
 769:	8d 76 00             	lea    0x0(%esi),%esi
 76c:	89 c2                	mov    %eax,%edx
 76e:	8b 00                	mov    (%eax),%eax
 770:	39 ca                	cmp    %ecx,%edx
 772:	73 2c                	jae    7a0 <free+0x48>
 774:	39 c1                	cmp    %eax,%ecx
 776:	72 04                	jb     77c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	39 c2                	cmp    %eax,%edx
 77a:	72 f0                	jb     76c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 77f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 782:	39 f8                	cmp    %edi,%eax
 784:	74 2c                	je     7b2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 789:	8b 42 04             	mov    0x4(%edx),%eax
 78c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 78f:	39 f1                	cmp    %esi,%ecx
 791:	74 36                	je     7c9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 793:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 795:	89 15 a8 09 00 00    	mov    %edx,0x9a8
}
 79b:	5b                   	pop    %ebx
 79c:	5e                   	pop    %esi
 79d:	5f                   	pop    %edi
 79e:	5d                   	pop    %ebp
 79f:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 c2                	cmp    %eax,%edx
 7a2:	72 c8                	jb     76c <free+0x14>
 7a4:	39 c1                	cmp    %eax,%ecx
 7a6:	73 c4                	jae    76c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ae:	39 f8                	cmp    %edi,%eax
 7b0:	75 d4                	jne    786 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 7b2:	03 70 04             	add    0x4(%eax),%esi
 7b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	8b 02                	mov    (%edx),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7bf:	8b 42 04             	mov    0x4(%edx),%eax
 7c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7c5:	39 f1                	cmp    %esi,%ecx
 7c7:	75 ca                	jne    793 <free+0x3b>
    p->s.size += bp->s.size;
 7c9:	03 43 fc             	add    -0x4(%ebx),%eax
 7cc:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7cf:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7d2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 7d4:	89 15 a8 09 00 00    	mov    %edx,0x9a8
}
 7da:	5b                   	pop    %ebx
 7db:	5e                   	pop    %esi
 7dc:	5f                   	pop    %edi
 7dd:	5d                   	pop    %ebp
 7de:	c3                   	ret    
 7df:	90                   	nop

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ec:	8d 70 07             	lea    0x7(%eax),%esi
 7ef:	c1 ee 03             	shr    $0x3,%esi
 7f2:	46                   	inc    %esi
  if((prevp = freep) == 0){
 7f3:	8b 3d a8 09 00 00    	mov    0x9a8,%edi
 7f9:	85 ff                	test   %edi,%edi
 7fb:	0f 84 a3 00 00 00    	je     8a4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 801:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 803:	8b 4a 04             	mov    0x4(%edx),%ecx
 806:	39 f1                	cmp    %esi,%ecx
 808:	73 68                	jae    872 <malloc+0x92>
 80a:	89 f3                	mov    %esi,%ebx
 80c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 812:	0f 82 80 00 00 00    	jb     898 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 818:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 81f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 822:	eb 11                	jmp    835 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 826:	8b 48 04             	mov    0x4(%eax),%ecx
 829:	39 f1                	cmp    %esi,%ecx
 82b:	73 4b                	jae    878 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82d:	8b 3d a8 09 00 00    	mov    0x9a8,%edi
 833:	89 c2                	mov    %eax,%edx
 835:	39 d7                	cmp    %edx,%edi
 837:	75 eb                	jne    824 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 839:	83 ec 0c             	sub    $0xc,%esp
 83c:	ff 75 e4             	push   -0x1c(%ebp)
 83f:	e8 0f fd ff ff       	call   553 <sbrk>
  if(p == (char*)-1)
 844:	83 c4 10             	add    $0x10,%esp
 847:	83 f8 ff             	cmp    $0xffffffff,%eax
 84a:	74 1c                	je     868 <malloc+0x88>
  hp->s.size = nu;
 84c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 84f:	83 ec 0c             	sub    $0xc,%esp
 852:	83 c0 08             	add    $0x8,%eax
 855:	50                   	push   %eax
 856:	e8 fd fe ff ff       	call   758 <free>
  return freep;
 85b:	8b 15 a8 09 00 00    	mov    0x9a8,%edx
      if((p = morecore(nunits)) == 0)
 861:	83 c4 10             	add    $0x10,%esp
 864:	85 d2                	test   %edx,%edx
 866:	75 bc                	jne    824 <malloc+0x44>
        return 0;
 868:	31 c0                	xor    %eax,%eax
  }
}
 86a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 86d:	5b                   	pop    %ebx
 86e:	5e                   	pop    %esi
 86f:	5f                   	pop    %edi
 870:	5d                   	pop    %ebp
 871:	c3                   	ret    
    if(p->s.size >= nunits){
 872:	89 d0                	mov    %edx,%eax
 874:	89 fa                	mov    %edi,%edx
 876:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 878:	39 ce                	cmp    %ecx,%esi
 87a:	74 54                	je     8d0 <malloc+0xf0>
        p->s.size -= nunits;
 87c:	29 f1                	sub    %esi,%ecx
 87e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 881:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 884:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 887:	89 15 a8 09 00 00    	mov    %edx,0x9a8
      return (void*)(p + 1);
 88d:	83 c0 08             	add    $0x8,%eax
}
 890:	8d 65 f4             	lea    -0xc(%ebp),%esp
 893:	5b                   	pop    %ebx
 894:	5e                   	pop    %esi
 895:	5f                   	pop    %edi
 896:	5d                   	pop    %ebp
 897:	c3                   	ret    
 898:	bb 00 10 00 00       	mov    $0x1000,%ebx
 89d:	e9 76 ff ff ff       	jmp    818 <malloc+0x38>
 8a2:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8a4:	c7 05 a8 09 00 00 ac 	movl   $0x9ac,0x9a8
 8ab:	09 00 00 
 8ae:	c7 05 ac 09 00 00 ac 	movl   $0x9ac,0x9ac
 8b5:	09 00 00 
    base.s.size = 0;
 8b8:	c7 05 b0 09 00 00 00 	movl   $0x0,0x9b0
 8bf:	00 00 00 
 8c2:	bf ac 09 00 00       	mov    $0x9ac,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c7:	89 fa                	mov    %edi,%edx
 8c9:	e9 3c ff ff ff       	jmp    80a <malloc+0x2a>
 8ce:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 8d0:	8b 08                	mov    (%eax),%ecx
 8d2:	89 0a                	mov    %ecx,(%edx)
 8d4:	eb b1                	jmp    887 <malloc+0xa7>
