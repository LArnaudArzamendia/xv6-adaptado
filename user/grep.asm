
user/_grep:     file format elf32-i386


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
  16:	89 45 e0             	mov    %eax,-0x20(%ebp)
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int fd, i;
  char *pattern;

  if(argc <= 1){
  1c:	48                   	dec    %eax
  1d:	7e 65                	jle    84 <main+0x84>
    printf(2, "usage: grep pattern [file ...]\n");
    exit();
  }
  pattern = argv[1];
  1f:	8b 7b 04             	mov    0x4(%ebx),%edi

  if(argc <= 2){
  22:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  26:	74 6f                	je     97 <main+0x97>
  28:	83 c3 08             	add    $0x8,%ebx
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
  2b:	be 02 00 00 00       	mov    $0x2,%esi
  30:	eb 26                	jmp    58 <main+0x58>
  32:	66 90                	xchg   %ax,%ax
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "grep: cannot open %s\n", argv[i]);
      exit();
    }
    grep(pattern, fd);
  34:	83 ec 08             	sub    $0x8,%esp
  37:	50                   	push   %eax
  38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  3b:	57                   	push   %edi
  3c:	e8 53 01 00 00       	call   194 <grep>
    close(fd);
  41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 b7 04 00 00       	call   503 <close>
  for(i = 2; i < argc; i++){
  4c:	46                   	inc    %esi
  4d:	83 c3 04             	add    $0x4,%ebx
  50:	83 c4 10             	add    $0x10,%esp
  53:	39 75 e0             	cmp    %esi,-0x20(%ebp)
  56:	7e 27                	jle    7f <main+0x7f>
    if((fd = open(argv[i], 0)) < 0){
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	6a 00                	push   $0x0
  5d:	ff 33                	push   (%ebx)
  5f:	e8 b7 04 00 00       	call   51b <open>
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 c0                	test   %eax,%eax
  69:	79 c9                	jns    34 <main+0x34>
      printf(1, "grep: cannot open %s\n", argv[i]);
  6b:	50                   	push   %eax
  6c:	ff 33                	push   (%ebx)
  6e:	68 08 09 00 00       	push   $0x908
  73:	6a 01                	push   $0x1
  75:	e8 8a 05 00 00       	call   604 <printf>
      exit();
  7a:	e8 5c 04 00 00       	call   4db <exit>
  }
  exit();
  7f:	e8 57 04 00 00       	call   4db <exit>
    printf(2, "usage: grep pattern [file ...]\n");
  84:	51                   	push   %ecx
  85:	51                   	push   %ecx
  86:	68 e8 08 00 00       	push   $0x8e8
  8b:	6a 02                	push   $0x2
  8d:	e8 72 05 00 00       	call   604 <printf>
    exit();
  92:	e8 44 04 00 00       	call   4db <exit>
    grep(pattern, 0);
  97:	52                   	push   %edx
  98:	52                   	push   %edx
  99:	6a 00                	push   $0x0
  9b:	57                   	push   %edi
  9c:	e8 f3 00 00 00       	call   194 <grep>
    exit();
  a1:	e8 35 04 00 00       	call   4db <exit>
  a6:	66 90                	xchg   %ax,%ax

000000a8 <matchhere>:
  return 0;
}

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	56                   	push   %esi
  ad:	53                   	push   %ebx
  ae:	83 ec 0c             	sub    $0xc,%esp
  b1:	8b 75 08             	mov    0x8(%ebp),%esi
  b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '\0')
  b7:	8a 16                	mov    (%esi),%dl
  b9:	84 d2                	test   %dl,%dl
  bb:	74 57                	je     114 <matchhere+0x6c>
    return 1;
  if(re[1] == '*')
  bd:	8a 46 01             	mov    0x1(%esi),%al
  c0:	3c 2a                	cmp    $0x2a,%al
  c2:	74 23                	je     e7 <matchhere+0x3f>
    return matchstar(re[0], re+2, text);
  if(re[0] == '$' && re[1] == '\0')
    return *text == '\0';
  c4:	8a 0b                	mov    (%ebx),%cl
  if(re[0] == '$' && re[1] == '\0')
  c6:	80 fa 24             	cmp    $0x24,%dl
  c9:	74 59                	je     124 <matchhere+0x7c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  cb:	84 c9                	test   %cl,%cl
  cd:	74 69                	je     138 <matchhere+0x90>
  cf:	80 fa 2e             	cmp    $0x2e,%dl
  d2:	74 04                	je     d8 <matchhere+0x30>
  d4:	38 ca                	cmp    %cl,%dl
  d6:	75 60                	jne    138 <matchhere+0x90>
    return matchhere(re+1, text+1);
  d8:	43                   	inc    %ebx
  d9:	46                   	inc    %esi
  if(re[0] == '\0')
  da:	84 c0                	test   %al,%al
  dc:	74 36                	je     114 <matchhere+0x6c>
{
  de:	88 c2                	mov    %al,%dl
  if(re[1] == '*')
  e0:	8a 46 01             	mov    0x1(%esi),%al
  e3:	3c 2a                	cmp    $0x2a,%al
  e5:	75 dd                	jne    c4 <matchhere+0x1c>
    return matchstar(re[0], re+2, text);
  e7:	83 c6 02             	add    $0x2,%esi
  ea:	0f be fa             	movsbl %dl,%edi
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
  ed:	eb 12                	jmp    101 <matchhere+0x59>
  ef:	90                   	nop
{
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  f0:	0f be 0b             	movsbl (%ebx),%ecx
  f3:	84 c9                	test   %cl,%cl
  f5:	74 22                	je     119 <matchhere+0x71>
  f7:	43                   	inc    %ebx
  f8:	39 cf                	cmp    %ecx,%edi
  fa:	74 05                	je     101 <matchhere+0x59>
  fc:	83 ff 2e             	cmp    $0x2e,%edi
  ff:	75 18                	jne    119 <matchhere+0x71>
    if(matchhere(re, text))
 101:	83 ec 08             	sub    $0x8,%esp
 104:	53                   	push   %ebx
 105:	56                   	push   %esi
 106:	e8 9d ff ff ff       	call   a8 <matchhere>
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	85 c0                	test   %eax,%eax
 110:	74 de                	je     f0 <matchhere+0x48>
 112:	66 90                	xchg   %ax,%ax
    return 1;
 114:	b8 01 00 00 00       	mov    $0x1,%eax
}
 119:	8d 65 f4             	lea    -0xc(%ebp),%esp
 11c:	5b                   	pop    %ebx
 11d:	5e                   	pop    %esi
 11e:	5f                   	pop    %edi
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	8d 76 00             	lea    0x0(%esi),%esi
  if(re[0] == '$' && re[1] == '\0')
 124:	84 c0                	test   %al,%al
 126:	74 1a                	je     142 <matchhere+0x9a>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 128:	84 c9                	test   %cl,%cl
 12a:	74 0c                	je     138 <matchhere+0x90>
 12c:	80 f9 24             	cmp    $0x24,%cl
 12f:	75 07                	jne    138 <matchhere+0x90>
    return matchhere(re+1, text+1);
 131:	43                   	inc    %ebx
 132:	46                   	inc    %esi
{
 133:	88 c2                	mov    %al,%dl
 135:	eb a9                	jmp    e0 <matchhere+0x38>
 137:	90                   	nop
  return 0;
 138:	31 c0                	xor    %eax,%eax
}
 13a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13d:	5b                   	pop    %ebx
 13e:	5e                   	pop    %esi
 13f:	5f                   	pop    %edi
 140:	5d                   	pop    %ebp
 141:	c3                   	ret    
    return *text == '\0';
 142:	31 c0                	xor    %eax,%eax
 144:	84 c9                	test   %cl,%cl
 146:	0f 94 c0             	sete   %al
 149:	eb ce                	jmp    119 <matchhere+0x71>
 14b:	90                   	nop

0000014c <match>:
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	56                   	push   %esi
 150:	53                   	push   %ebx
 151:	8b 5d 08             	mov    0x8(%ebp),%ebx
 154:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(re[0] == '^')
 157:	80 3b 5e             	cmpb   $0x5e,(%ebx)
 15a:	75 0b                	jne    167 <match+0x1b>
 15c:	eb 26                	jmp    184 <match+0x38>
 15e:	66 90                	xchg   %ax,%ax
  }while(*text++ != '\0');
 160:	46                   	inc    %esi
 161:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 165:	74 16                	je     17d <match+0x31>
    if(matchhere(re, text))
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	56                   	push   %esi
 16b:	53                   	push   %ebx
 16c:	e8 37 ff ff ff       	call   a8 <matchhere>
 171:	83 c4 10             	add    $0x10,%esp
 174:	85 c0                	test   %eax,%eax
 176:	74 e8                	je     160 <match+0x14>
      return 1;
 178:	b8 01 00 00 00       	mov    $0x1,%eax
}
 17d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 180:	5b                   	pop    %ebx
 181:	5e                   	pop    %esi
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
    return matchhere(re+1, text);
 184:	43                   	inc    %ebx
 185:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
 188:	8d 65 f8             	lea    -0x8(%ebp),%esp
 18b:	5b                   	pop    %ebx
 18c:	5e                   	pop    %esi
 18d:	5d                   	pop    %ebp
    return matchhere(re+1, text);
 18e:	e9 15 ff ff ff       	jmp    a8 <matchhere>
 193:	90                   	nop

00000194 <grep>:
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
 19a:	83 ec 1c             	sub    $0x1c,%esp
 19d:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 1a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    return matchhere(re+1, text);
 1a7:	8d 47 01             	lea    0x1(%edi),%eax
 1aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
 1ad:	8d 76 00             	lea    0x0(%esi),%esi
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 1b0:	50                   	push   %eax
 1b1:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 1b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 1b9:	29 c8                	sub    %ecx,%eax
 1bb:	50                   	push   %eax
 1bc:	8d 81 a0 09 00 00    	lea    0x9a0(%ecx),%eax
 1c2:	50                   	push   %eax
 1c3:	ff 75 0c             	push   0xc(%ebp)
 1c6:	e8 28 03 00 00       	call   4f3 <read>
 1cb:	83 c4 10             	add    $0x10,%esp
 1ce:	85 c0                	test   %eax,%eax
 1d0:	0f 8e d5 00 00 00    	jle    2ab <grep+0x117>
    m += n;
 1d6:	01 45 dc             	add    %eax,-0x24(%ebp)
 1d9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
    buf[m] = '\0';
 1dc:	c6 81 a0 09 00 00 00 	movb   $0x0,0x9a0(%ecx)
    p = buf;
 1e3:	c7 45 e4 a0 09 00 00 	movl   $0x9a0,-0x1c(%ebp)
 1ea:	66 90                	xchg   %ax,%ax
    while((q = strchr(p, '\n')) != 0){
 1ec:	83 ec 08             	sub    $0x8,%esp
 1ef:	6a 0a                	push   $0xa
 1f1:	ff 75 e4             	push   -0x1c(%ebp)
 1f4:	e8 af 01 00 00       	call   3a8 <strchr>
 1f9:	89 c3                	mov    %eax,%ebx
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	85 c0                	test   %eax,%eax
 200:	74 66                	je     268 <grep+0xd4>
      *q = 0;
 202:	c6 03 00             	movb   $0x0,(%ebx)
        write(1, p, q+1 - p);
 205:	8d 43 01             	lea    0x1(%ebx),%eax
 208:	89 45 e0             	mov    %eax,-0x20(%ebp)
 20b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  if(re[0] == '^')
 20e:	80 3f 5e             	cmpb   $0x5e,(%edi)
 211:	75 0c                	jne    21f <grep+0x8b>
 213:	eb 3b                	jmp    250 <grep+0xbc>
 215:	8d 76 00             	lea    0x0(%esi),%esi
  }while(*text++ != '\0');
 218:	46                   	inc    %esi
 219:	80 7e ff 00          	cmpb   $0x0,-0x1(%esi)
 21d:	74 29                	je     248 <grep+0xb4>
    if(matchhere(re, text))
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	56                   	push   %esi
 223:	57                   	push   %edi
 224:	e8 7f fe ff ff       	call   a8 <matchhere>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	85 c0                	test   %eax,%eax
 22e:	74 e8                	je     218 <grep+0x84>
        *q = '\n';
 230:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 233:	56                   	push   %esi
 234:	8b 45 e0             	mov    -0x20(%ebp),%eax
 237:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 23a:	29 d0                	sub    %edx,%eax
 23c:	50                   	push   %eax
 23d:	52                   	push   %edx
 23e:	6a 01                	push   $0x1
 240:	e8 b6 02 00 00       	call   4fb <write>
 245:	83 c4 10             	add    $0x10,%esp
      p = q+1;
 248:	8b 45 e0             	mov    -0x20(%ebp),%eax
 24b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 24e:	eb 9c                	jmp    1ec <grep+0x58>
    return matchhere(re+1, text);
 250:	83 ec 08             	sub    $0x8,%esp
 253:	56                   	push   %esi
 254:	ff 75 d8             	push   -0x28(%ebp)
 257:	e8 4c fe ff ff       	call   a8 <matchhere>
 25c:	83 c4 10             	add    $0x10,%esp
      if(match(pattern, p)){
 25f:	85 c0                	test   %eax,%eax
 261:	74 e5                	je     248 <grep+0xb4>
 263:	eb cb                	jmp    230 <grep+0x9c>
 265:	8d 76 00             	lea    0x0(%esi),%esi
    if(p == buf)
 268:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 26b:	81 fa a0 09 00 00    	cmp    $0x9a0,%edx
 271:	74 2c                	je     29f <grep+0x10b>
    if(m > 0){
 273:	8b 4d dc             	mov    -0x24(%ebp),%ecx
 276:	85 c9                	test   %ecx,%ecx
 278:	0f 8e 32 ff ff ff    	jle    1b0 <grep+0x1c>
      m -= p - buf;
 27e:	89 d0                	mov    %edx,%eax
 280:	2d a0 09 00 00       	sub    $0x9a0,%eax
 285:	29 c1                	sub    %eax,%ecx
 287:	89 4d dc             	mov    %ecx,-0x24(%ebp)
      memmove(buf, p, m);
 28a:	53                   	push   %ebx
 28b:	51                   	push   %ecx
 28c:	52                   	push   %edx
 28d:	68 a0 09 00 00       	push   $0x9a0
 292:	e8 19 02 00 00       	call   4b0 <memmove>
 297:	83 c4 10             	add    $0x10,%esp
 29a:	e9 11 ff ff ff       	jmp    1b0 <grep+0x1c>
      m = 0;
 29f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 2a6:	e9 05 ff ff ff       	jmp    1b0 <grep+0x1c>
}
 2ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	90                   	nop

000002b4 <matchstar>:
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	57                   	push   %edi
 2b8:	56                   	push   %esi
 2b9:	53                   	push   %ebx
 2ba:	83 ec 0c             	sub    $0xc,%esp
 2bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
 2c0:	8b 75 0c             	mov    0xc(%ebp),%esi
 2c3:	8b 7d 10             	mov    0x10(%ebp),%edi
 2c6:	66 90                	xchg   %ax,%ax
    if(matchhere(re, text))
 2c8:	83 ec 08             	sub    $0x8,%esp
 2cb:	57                   	push   %edi
 2cc:	56                   	push   %esi
 2cd:	e8 d6 fd ff ff       	call   a8 <matchhere>
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	85 c0                	test   %eax,%eax
 2d7:	75 1b                	jne    2f4 <matchstar+0x40>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2d9:	0f be 17             	movsbl (%edi),%edx
 2dc:	84 d2                	test   %dl,%dl
 2de:	74 0a                	je     2ea <matchstar+0x36>
 2e0:	47                   	inc    %edi
 2e1:	39 da                	cmp    %ebx,%edx
 2e3:	74 e3                	je     2c8 <matchstar+0x14>
 2e5:	83 fb 2e             	cmp    $0x2e,%ebx
 2e8:	74 de                	je     2c8 <matchstar+0x14>
}
 2ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ed:	5b                   	pop    %ebx
 2ee:	5e                   	pop    %esi
 2ef:	5f                   	pop    %edi
 2f0:	5d                   	pop    %ebp
 2f1:	c3                   	ret    
 2f2:	66 90                	xchg   %ax,%ax
      return 1;
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
 2f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fc:	5b                   	pop    %ebx
 2fd:	5e                   	pop    %esi
 2fe:	5f                   	pop    %edi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	66 90                	xchg   %ax,%ax
 303:	90                   	nop

00000304 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	53                   	push   %ebx
 308:	8b 4d 08             	mov    0x8(%ebp),%ecx
 30b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 30e:	31 c0                	xor    %eax,%eax
 310:	8a 14 03             	mov    (%ebx,%eax,1),%dl
 313:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 316:	40                   	inc    %eax
 317:	84 d2                	test   %dl,%dl
 319:	75 f5                	jne    310 <strcpy+0xc>
    ;
  return os;
}
 31b:	89 c8                	mov    %ecx,%eax
 31d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 320:	c9                   	leave  
 321:	c3                   	ret    
 322:	66 90                	xchg   %ax,%ax

00000324 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	53                   	push   %ebx
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
 32e:	0f b6 02             	movzbl (%edx),%eax
 331:	84 c0                	test   %al,%al
 333:	75 10                	jne    345 <strcmp+0x21>
 335:	eb 2a                	jmp    361 <strcmp+0x3d>
 337:	90                   	nop
    p++, q++;
 338:	42                   	inc    %edx
 339:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(*p && *p == *q)
 33c:	0f b6 02             	movzbl (%edx),%eax
 33f:	84 c0                	test   %al,%al
 341:	74 11                	je     354 <strcmp+0x30>
    p++, q++;
 343:	89 cb                	mov    %ecx,%ebx
  while(*p && *p == *q)
 345:	0f b6 0b             	movzbl (%ebx),%ecx
 348:	38 c1                	cmp    %al,%cl
 34a:	74 ec                	je     338 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 34c:	29 c8                	sub    %ecx,%eax
}
 34e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 351:	c9                   	leave  
 352:	c3                   	ret    
 353:	90                   	nop
  return (uchar)*p - (uchar)*q;
 354:	0f b6 4b 01          	movzbl 0x1(%ebx),%ecx
 358:	31 c0                	xor    %eax,%eax
 35a:	29 c8                	sub    %ecx,%eax
}
 35c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 35f:	c9                   	leave  
 360:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 361:	0f b6 0b             	movzbl (%ebx),%ecx
 364:	31 c0                	xor    %eax,%eax
 366:	eb e4                	jmp    34c <strcmp+0x28>

00000368 <strlen>:

uint
strlen(const char *s)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 36e:	80 3a 00             	cmpb   $0x0,(%edx)
 371:	74 15                	je     388 <strlen+0x20>
 373:	31 c0                	xor    %eax,%eax
 375:	8d 76 00             	lea    0x0(%esi),%esi
 378:	40                   	inc    %eax
 379:	89 c1                	mov    %eax,%ecx
 37b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 37f:	75 f7                	jne    378 <strlen+0x10>
    ;
  return n;
}
 381:	89 c8                	mov    %ecx,%eax
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    
 385:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 388:	31 c9                	xor    %ecx,%ecx
}
 38a:	89 c8                	mov    %ecx,%eax
 38c:	5d                   	pop    %ebp
 38d:	c3                   	ret    
 38e:	66 90                	xchg   %ax,%ax

00000390 <memset>:

void*
memset(void *dst, int c, uint n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 394:	8b 7d 08             	mov    0x8(%ebp),%edi
 397:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	fc                   	cld    
 39e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <strchr>:

char*
strchr(const char *s, char c)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 3b1:	8a 10                	mov    (%eax),%dl
 3b3:	84 d2                	test   %dl,%dl
 3b5:	75 0c                	jne    3c3 <strchr+0x1b>
 3b7:	eb 13                	jmp    3cc <strchr+0x24>
 3b9:	8d 76 00             	lea    0x0(%esi),%esi
 3bc:	40                   	inc    %eax
 3bd:	8a 10                	mov    (%eax),%dl
 3bf:	84 d2                	test   %dl,%dl
 3c1:	74 09                	je     3cc <strchr+0x24>
    if(*s == c)
 3c3:	38 d1                	cmp    %dl,%cl
 3c5:	75 f5                	jne    3bc <strchr+0x14>
      return (char*)s;
  return 0;
}
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
 3c9:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
 3cc:	31 c0                	xor    %eax,%eax
}
 3ce:	5d                   	pop    %ebp
 3cf:	c3                   	ret    

000003d0 <gets>:

char*
gets(char *buf, int max)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d9:	31 db                	xor    %ebx,%ebx
    cc = read(0, &c, 1);
 3db:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3de:	eb 24                	jmp    404 <gets+0x34>
    cc = read(0, &c, 1);
 3e0:	50                   	push   %eax
 3e1:	6a 01                	push   $0x1
 3e3:	57                   	push   %edi
 3e4:	6a 00                	push   $0x0
 3e6:	e8 08 01 00 00       	call   4f3 <read>
    if(cc < 1)
 3eb:	83 c4 10             	add    $0x10,%esp
 3ee:	85 c0                	test   %eax,%eax
 3f0:	7e 1c                	jle    40e <gets+0x3e>
      break;
    buf[i++] = c;
 3f2:	8a 45 e7             	mov    -0x19(%ebp),%al
 3f5:	8b 55 08             	mov    0x8(%ebp),%edx
 3f8:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3fc:	3c 0a                	cmp    $0xa,%al
 3fe:	74 20                	je     420 <gets+0x50>
 400:	3c 0d                	cmp    $0xd,%al
 402:	74 1c                	je     420 <gets+0x50>
  for(i=0; i+1 < max; ){
 404:	89 de                	mov    %ebx,%esi
 406:	8d 5b 01             	lea    0x1(%ebx),%ebx
 409:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 40c:	7c d2                	jl     3e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 415:	8d 65 f4             	lea    -0xc(%ebp),%esp
 418:	5b                   	pop    %ebx
 419:	5e                   	pop    %esi
 41a:	5f                   	pop    %edi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	89 de                	mov    %ebx,%esi
  buf[i] = '\0';
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 429:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42c:	5b                   	pop    %ebx
 42d:	5e                   	pop    %esi
 42e:	5f                   	pop    %edi
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d 76 00             	lea    0x0(%esi),%esi

00000434 <stat>:

int
stat(const char *n, struct stat *st)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	56                   	push   %esi
 438:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	6a 00                	push   $0x0
 43e:	ff 75 08             	push   0x8(%ebp)
 441:	e8 d5 00 00 00       	call   51b <open>
  if(fd < 0)
 446:	83 c4 10             	add    $0x10,%esp
 449:	85 c0                	test   %eax,%eax
 44b:	78 27                	js     474 <stat+0x40>
 44d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 44f:	83 ec 08             	sub    $0x8,%esp
 452:	ff 75 0c             	push   0xc(%ebp)
 455:	50                   	push   %eax
 456:	e8 d8 00 00 00       	call   533 <fstat>
 45b:	89 c6                	mov    %eax,%esi
  close(fd);
 45d:	89 1c 24             	mov    %ebx,(%esp)
 460:	e8 9e 00 00 00       	call   503 <close>
  return r;
 465:	83 c4 10             	add    $0x10,%esp
}
 468:	89 f0                	mov    %esi,%eax
 46a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 46d:	5b                   	pop    %ebx
 46e:	5e                   	pop    %esi
 46f:	5d                   	pop    %ebp
 470:	c3                   	ret    
 471:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 474:	be ff ff ff ff       	mov    $0xffffffff,%esi
 479:	eb ed                	jmp    468 <stat+0x34>
 47b:	90                   	nop

0000047c <atoi>:

int
atoi(const char *s)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	53                   	push   %ebx
 480:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 483:	0f be 01             	movsbl (%ecx),%eax
 486:	8d 50 d0             	lea    -0x30(%eax),%edx
 489:	80 fa 09             	cmp    $0x9,%dl
  n = 0;
 48c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 491:	77 16                	ja     4a9 <atoi+0x2d>
 493:	90                   	nop
    n = n*10 + *s++ - '0';
 494:	41                   	inc    %ecx
 495:	8d 14 92             	lea    (%edx,%edx,4),%edx
 498:	01 d2                	add    %edx,%edx
 49a:	8d 54 02 d0          	lea    -0x30(%edx,%eax,1),%edx
  while('0' <= *s && *s <= '9')
 49e:	0f be 01             	movsbl (%ecx),%eax
 4a1:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4a4:	80 fb 09             	cmp    $0x9,%bl
 4a7:	76 eb                	jbe    494 <atoi+0x18>
  return n;
}
 4a9:	89 d0                	mov    %edx,%eax
 4ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	8b 55 08             	mov    0x8(%ebp),%edx
 4b8:	8b 75 0c             	mov    0xc(%ebp),%esi
 4bb:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 c0                	test   %eax,%eax
 4c0:	7e 0b                	jle    4cd <memmove+0x1d>
 4c2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4c4:	89 d7                	mov    %edx,%edi
 4c6:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 4c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4c9:	39 f8                	cmp    %edi,%eax
 4cb:	75 fb                	jne    4c8 <memmove+0x18>
  return vdst;
}
 4cd:	89 d0                	mov    %edx,%eax
 4cf:	5e                   	pop    %esi
 4d0:	5f                   	pop    %edi
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    

000004d3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d3:	b8 01 00 00 00       	mov    $0x1,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <exit>:
SYSCALL(exit)
 4db:	b8 02 00 00 00       	mov    $0x2,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <wait>:
SYSCALL(wait)
 4e3:	b8 03 00 00 00       	mov    $0x3,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <pipe>:
SYSCALL(pipe)
 4eb:	b8 04 00 00 00       	mov    $0x4,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <read>:
SYSCALL(read)
 4f3:	b8 05 00 00 00       	mov    $0x5,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <write>:
SYSCALL(write)
 4fb:	b8 10 00 00 00       	mov    $0x10,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <close>:
SYSCALL(close)
 503:	b8 15 00 00 00       	mov    $0x15,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <kill>:
SYSCALL(kill)
 50b:	b8 06 00 00 00       	mov    $0x6,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <exec>:
SYSCALL(exec)
 513:	b8 07 00 00 00       	mov    $0x7,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <open>:
SYSCALL(open)
 51b:	b8 0f 00 00 00       	mov    $0xf,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <mknod>:
SYSCALL(mknod)
 523:	b8 11 00 00 00       	mov    $0x11,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <unlink>:
SYSCALL(unlink)
 52b:	b8 12 00 00 00       	mov    $0x12,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <fstat>:
SYSCALL(fstat)
 533:	b8 08 00 00 00       	mov    $0x8,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <link>:
SYSCALL(link)
 53b:	b8 13 00 00 00       	mov    $0x13,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <mkdir>:
SYSCALL(mkdir)
 543:	b8 14 00 00 00       	mov    $0x14,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <chdir>:
SYSCALL(chdir)
 54b:	b8 09 00 00 00       	mov    $0x9,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <dup>:
SYSCALL(dup)
 553:	b8 0a 00 00 00       	mov    $0xa,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <getpid>:
SYSCALL(getpid)
 55b:	b8 0b 00 00 00       	mov    $0xb,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <sbrk>:
SYSCALL(sbrk)
 563:	b8 0c 00 00 00       	mov    $0xc,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <sleep>:
SYSCALL(sleep)
 56b:	b8 0d 00 00 00       	mov    $0xd,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <uptime>:
 573:	b8 0e 00 00 00       	mov    $0xe,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    
 57b:	90                   	nop

0000057c <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 57c:	55                   	push   %ebp
 57d:	89 e5                	mov    %esp,%ebp
 57f:	57                   	push   %edi
 580:	56                   	push   %esi
 581:	53                   	push   %ebx
 582:	83 ec 3c             	sub    $0x3c,%esp
 585:	89 45 bc             	mov    %eax,-0x44(%ebp)
 588:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 58b:	89 d1                	mov    %edx,%ecx
  if(sgn && xx < 0){
 58d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 590:	85 db                	test   %ebx,%ebx
 592:	74 04                	je     598 <printint+0x1c>
 594:	85 d2                	test   %edx,%edx
 596:	78 68                	js     600 <printint+0x84>
  neg = 0;
 598:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 59f:	31 ff                	xor    %edi,%edi
 5a1:	8d 75 d7             	lea    -0x29(%ebp),%esi
  do{
    buf[i++] = digits[x % base];
 5a4:	89 c8                	mov    %ecx,%eax
 5a6:	31 d2                	xor    %edx,%edx
 5a8:	f7 75 c4             	divl   -0x3c(%ebp)
 5ab:	89 fb                	mov    %edi,%ebx
 5ad:	8d 7f 01             	lea    0x1(%edi),%edi
 5b0:	8a 92 80 09 00 00    	mov    0x980(%edx),%dl
 5b6:	88 54 1e 01          	mov    %dl,0x1(%esi,%ebx,1)
  }while((x /= base) != 0);
 5ba:	89 4d c0             	mov    %ecx,-0x40(%ebp)
 5bd:	89 c1                	mov    %eax,%ecx
 5bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5c2:	3b 45 c0             	cmp    -0x40(%ebp),%eax
 5c5:	76 dd                	jbe    5a4 <printint+0x28>
  if(neg)
 5c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5ca:	85 c9                	test   %ecx,%ecx
 5cc:	74 09                	je     5d7 <printint+0x5b>
    buf[i++] = '-';
 5ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    buf[i++] = digits[x % base];
 5d3:	89 fb                	mov    %edi,%ebx
    buf[i++] = '-';
 5d5:	b2 2d                	mov    $0x2d,%dl

  while(--i >= 0)
 5d7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
 5db:	8b 7d bc             	mov    -0x44(%ebp),%edi
 5de:	eb 03                	jmp    5e3 <printint+0x67>
    putc(fd, buf[i]);
 5e0:	8a 13                	mov    (%ebx),%dl
 5e2:	4b                   	dec    %ebx
 5e3:	88 55 d7             	mov    %dl,-0x29(%ebp)
  write(fd, &c, 1);
 5e6:	50                   	push   %eax
 5e7:	6a 01                	push   $0x1
 5e9:	56                   	push   %esi
 5ea:	57                   	push   %edi
 5eb:	e8 0b ff ff ff       	call   4fb <write>
  while(--i >= 0)
 5f0:	83 c4 10             	add    $0x10,%esp
 5f3:	39 de                	cmp    %ebx,%esi
 5f5:	75 e9                	jne    5e0 <printint+0x64>
}
 5f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5fa:	5b                   	pop    %ebx
 5fb:	5e                   	pop    %esi
 5fc:	5f                   	pop    %edi
 5fd:	5d                   	pop    %ebp
 5fe:	c3                   	ret    
 5ff:	90                   	nop
    x = -xx;
 600:	f7 d9                	neg    %ecx
 602:	eb 9b                	jmp    59f <printint+0x23>

00000604 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	57                   	push   %edi
 608:	56                   	push   %esi
 609:	53                   	push   %ebx
 60a:	83 ec 2c             	sub    $0x2c,%esp
 60d:	8b 75 08             	mov    0x8(%ebp),%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 610:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 613:	8a 13                	mov    (%ebx),%dl
 615:	84 d2                	test   %dl,%dl
 617:	74 64                	je     67d <printf+0x79>
 619:	43                   	inc    %ebx
  ap = (uint*)(void*)&fmt + 1;
 61a:	8d 45 10             	lea    0x10(%ebp),%eax
 61d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  state = 0;
 620:	31 c9                	xor    %ecx,%ecx
  write(fd, &c, 1);
 622:	8d 7d e7             	lea    -0x19(%ebp),%edi
 625:	eb 24                	jmp    64b <printf+0x47>
 627:	90                   	nop
 628:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 62b:	83 f8 25             	cmp    $0x25,%eax
 62e:	74 40                	je     670 <printf+0x6c>
        state = '%';
      } else {
        putc(fd, c);
 630:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 633:	50                   	push   %eax
 634:	6a 01                	push   $0x1
 636:	57                   	push   %edi
 637:	56                   	push   %esi
 638:	e8 be fe ff ff       	call   4fb <write>
        putc(fd, c);
 63d:	83 c4 10             	add    $0x10,%esp
 640:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  for(i = 0; fmt[i]; i++){
 643:	43                   	inc    %ebx
 644:	8a 53 ff             	mov    -0x1(%ebx),%dl
 647:	84 d2                	test   %dl,%dl
 649:	74 32                	je     67d <printf+0x79>
    c = fmt[i] & 0xff;
 64b:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 64e:	85 c9                	test   %ecx,%ecx
 650:	74 d6                	je     628 <printf+0x24>
      }
    } else if(state == '%'){
 652:	83 f9 25             	cmp    $0x25,%ecx
 655:	75 ec                	jne    643 <printf+0x3f>
      if(c == 'd'){
 657:	83 f8 25             	cmp    $0x25,%eax
 65a:	0f 84 e4 00 00 00    	je     744 <printf+0x140>
 660:	83 e8 63             	sub    $0x63,%eax
 663:	83 f8 15             	cmp    $0x15,%eax
 666:	77 20                	ja     688 <printf+0x84>
 668:	ff 24 85 28 09 00 00 	jmp    *0x928(,%eax,4)
 66f:	90                   	nop
        state = '%';
 670:	b9 25 00 00 00       	mov    $0x25,%ecx
  for(i = 0; fmt[i]; i++){
 675:	43                   	inc    %ebx
 676:	8a 53 ff             	mov    -0x1(%ebx),%dl
 679:	84 d2                	test   %dl,%dl
 67b:	75 ce                	jne    64b <printf+0x47>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 67d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 680:	5b                   	pop    %ebx
 681:	5e                   	pop    %esi
 682:	5f                   	pop    %edi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    
 685:	8d 76 00             	lea    0x0(%esi),%esi
 688:	88 55 d4             	mov    %dl,-0x2c(%ebp)
        putc(fd, '%');
 68b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 68f:	50                   	push   %eax
 690:	6a 01                	push   $0x1
 692:	57                   	push   %edi
 693:	56                   	push   %esi
 694:	e8 62 fe ff ff       	call   4fb <write>
        putc(fd, c);
 699:	8a 55 d4             	mov    -0x2c(%ebp),%dl
 69c:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 69f:	83 c4 0c             	add    $0xc,%esp
 6a2:	6a 01                	push   $0x1
 6a4:	57                   	push   %edi
 6a5:	56                   	push   %esi
 6a6:	e8 50 fe ff ff       	call   4fb <write>
        putc(fd, c);
 6ab:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ae:	31 c9                	xor    %ecx,%ecx
 6b0:	eb 91                	jmp    643 <printf+0x3f>
 6b2:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6b4:	83 ec 0c             	sub    $0xc,%esp
 6b7:	6a 00                	push   $0x0
 6b9:	b9 10 00 00 00       	mov    $0x10,%ecx
 6be:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6c1:	8b 10                	mov    (%eax),%edx
 6c3:	89 f0                	mov    %esi,%eax
 6c5:	e8 b2 fe ff ff       	call   57c <printint>
        ap++;
 6ca:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 6ce:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d1:	31 c9                	xor    %ecx,%ecx
        ap++;
 6d3:	e9 6b ff ff ff       	jmp    643 <printf+0x3f>
        s = (char*)*ap;
 6d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6db:	8b 10                	mov    (%eax),%edx
        ap++;
 6dd:	83 c0 04             	add    $0x4,%eax
 6e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6e3:	85 d2                	test   %edx,%edx
 6e5:	74 69                	je     750 <printf+0x14c>
        while(*s != 0){
 6e7:	8a 02                	mov    (%edx),%al
 6e9:	84 c0                	test   %al,%al
 6eb:	74 71                	je     75e <printf+0x15a>
 6ed:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 6f0:	89 d3                	mov    %edx,%ebx
 6f2:	66 90                	xchg   %ax,%ax
          putc(fd, *s);
 6f4:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f7:	50                   	push   %eax
 6f8:	6a 01                	push   $0x1
 6fa:	57                   	push   %edi
 6fb:	56                   	push   %esi
 6fc:	e8 fa fd ff ff       	call   4fb <write>
          s++;
 701:	43                   	inc    %ebx
        while(*s != 0){
 702:	8a 03                	mov    (%ebx),%al
 704:	83 c4 10             	add    $0x10,%esp
 707:	84 c0                	test   %al,%al
 709:	75 e9                	jne    6f4 <printf+0xf0>
      state = 0;
 70b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 70e:	31 c9                	xor    %ecx,%ecx
 710:	e9 2e ff ff ff       	jmp    643 <printf+0x3f>
 715:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	6a 01                	push   $0x1
 71d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 722:	eb 9a                	jmp    6be <printf+0xba>
        putc(fd, *ap);
 724:	8b 45 d0             	mov    -0x30(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 72c:	51                   	push   %ecx
 72d:	6a 01                	push   $0x1
 72f:	57                   	push   %edi
 730:	56                   	push   %esi
 731:	e8 c5 fd ff ff       	call   4fb <write>
        ap++;
 736:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 73a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 73d:	31 c9                	xor    %ecx,%ecx
 73f:	e9 ff fe ff ff       	jmp    643 <printf+0x3f>
        putc(fd, c);
 744:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 747:	52                   	push   %edx
 748:	e9 55 ff ff ff       	jmp    6a2 <printf+0x9e>
 74d:	8d 76 00             	lea    0x0(%esi),%esi
          s = "(null)";
 750:	ba 1e 09 00 00       	mov    $0x91e,%edx
        while(*s != 0){
 755:	b0 28                	mov    $0x28,%al
 757:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 75a:	89 d3                	mov    %edx,%ebx
 75c:	eb 96                	jmp    6f4 <printf+0xf0>
      state = 0;
 75e:	31 c9                	xor    %ecx,%ecx
 760:	e9 de fe ff ff       	jmp    643 <printf+0x3f>
 765:	66 90                	xchg   %ax,%ax
 767:	90                   	nop

00000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	55                   	push   %ebp
 769:	89 e5                	mov    %esp,%ebp
 76b:	57                   	push   %edi
 76c:	56                   	push   %esi
 76d:	53                   	push   %ebx
 76e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 771:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	a1 a0 0d 00 00       	mov    0xda0,%eax
 779:	8d 76 00             	lea    0x0(%esi),%esi
 77c:	89 c2                	mov    %eax,%edx
 77e:	8b 00                	mov    (%eax),%eax
 780:	39 ca                	cmp    %ecx,%edx
 782:	73 2c                	jae    7b0 <free+0x48>
 784:	39 c1                	cmp    %eax,%ecx
 786:	72 04                	jb     78c <free+0x24>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	39 c2                	cmp    %eax,%edx
 78a:	72 f0                	jb     77c <free+0x14>
      break;
  if(bp + bp->s.size == p->s.ptr){
 78c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 78f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 792:	39 f8                	cmp    %edi,%eax
 794:	74 2c                	je     7c2 <free+0x5a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 799:	8b 42 04             	mov    0x4(%edx),%eax
 79c:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 79f:	39 f1                	cmp    %esi,%ecx
 7a1:	74 36                	je     7d9 <free+0x71>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a3:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
 7a5:	89 15 a0 0d 00 00    	mov    %edx,0xda0
}
 7ab:	5b                   	pop    %ebx
 7ac:	5e                   	pop    %esi
 7ad:	5f                   	pop    %edi
 7ae:	5d                   	pop    %ebp
 7af:	c3                   	ret    
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	39 c2                	cmp    %eax,%edx
 7b2:	72 c8                	jb     77c <free+0x14>
 7b4:	39 c1                	cmp    %eax,%ecx
 7b6:	73 c4                	jae    77c <free+0x14>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7be:	39 f8                	cmp    %edi,%eax
 7c0:	75 d4                	jne    796 <free+0x2e>
    bp->s.size += p->s.ptr->s.size;
 7c2:	03 70 04             	add    0x4(%eax),%esi
 7c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	8b 02                	mov    (%edx),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 7cf:	8b 42 04             	mov    0x4(%edx),%eax
 7d2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 7d5:	39 f1                	cmp    %esi,%ecx
 7d7:	75 ca                	jne    7a3 <free+0x3b>
    p->s.size += bp->s.size;
 7d9:	03 43 fc             	add    -0x4(%ebx),%eax
 7dc:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 7df:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 7e2:	89 0a                	mov    %ecx,(%edx)
  freep = p;
 7e4:	89 15 a0 0d 00 00    	mov    %edx,0xda0
}
 7ea:	5b                   	pop    %ebx
 7eb:	5e                   	pop    %esi
 7ec:	5f                   	pop    %edi
 7ed:	5d                   	pop    %ebp
 7ee:	c3                   	ret    
 7ef:	90                   	nop

000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	55                   	push   %ebp
 7f1:	89 e5                	mov    %esp,%ebp
 7f3:	57                   	push   %edi
 7f4:	56                   	push   %esi
 7f5:	53                   	push   %ebx
 7f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f9:	8b 45 08             	mov    0x8(%ebp),%eax
 7fc:	8d 70 07             	lea    0x7(%eax),%esi
 7ff:	c1 ee 03             	shr    $0x3,%esi
 802:	46                   	inc    %esi
  if((prevp = freep) == 0){
 803:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 809:	85 ff                	test   %edi,%edi
 80b:	0f 84 a3 00 00 00    	je     8b4 <malloc+0xc4>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 811:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 813:	8b 4a 04             	mov    0x4(%edx),%ecx
 816:	39 f1                	cmp    %esi,%ecx
 818:	73 68                	jae    882 <malloc+0x92>
 81a:	89 f3                	mov    %esi,%ebx
 81c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 822:	0f 82 80 00 00 00    	jb     8a8 <malloc+0xb8>
  p = sbrk(nu * sizeof(Header));
 828:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 82f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 832:	eb 11                	jmp    845 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 836:	8b 48 04             	mov    0x4(%eax),%ecx
 839:	39 f1                	cmp    %esi,%ecx
 83b:	73 4b                	jae    888 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83d:	8b 3d a0 0d 00 00    	mov    0xda0,%edi
 843:	89 c2                	mov    %eax,%edx
 845:	39 d7                	cmp    %edx,%edi
 847:	75 eb                	jne    834 <malloc+0x44>
  p = sbrk(nu * sizeof(Header));
 849:	83 ec 0c             	sub    $0xc,%esp
 84c:	ff 75 e4             	push   -0x1c(%ebp)
 84f:	e8 0f fd ff ff       	call   563 <sbrk>
  if(p == (char*)-1)
 854:	83 c4 10             	add    $0x10,%esp
 857:	83 f8 ff             	cmp    $0xffffffff,%eax
 85a:	74 1c                	je     878 <malloc+0x88>
  hp->s.size = nu;
 85c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 85f:	83 ec 0c             	sub    $0xc,%esp
 862:	83 c0 08             	add    $0x8,%eax
 865:	50                   	push   %eax
 866:	e8 fd fe ff ff       	call   768 <free>
  return freep;
 86b:	8b 15 a0 0d 00 00    	mov    0xda0,%edx
      if((p = morecore(nunits)) == 0)
 871:	83 c4 10             	add    $0x10,%esp
 874:	85 d2                	test   %edx,%edx
 876:	75 bc                	jne    834 <malloc+0x44>
        return 0;
 878:	31 c0                	xor    %eax,%eax
  }
}
 87a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 87d:	5b                   	pop    %ebx
 87e:	5e                   	pop    %esi
 87f:	5f                   	pop    %edi
 880:	5d                   	pop    %ebp
 881:	c3                   	ret    
    if(p->s.size >= nunits){
 882:	89 d0                	mov    %edx,%eax
 884:	89 fa                	mov    %edi,%edx
 886:	66 90                	xchg   %ax,%ax
      if(p->s.size == nunits)
 888:	39 ce                	cmp    %ecx,%esi
 88a:	74 54                	je     8e0 <malloc+0xf0>
        p->s.size -= nunits;
 88c:	29 f1                	sub    %esi,%ecx
 88e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 891:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 894:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 897:	89 15 a0 0d 00 00    	mov    %edx,0xda0
      return (void*)(p + 1);
 89d:	83 c0 08             	add    $0x8,%eax
}
 8a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8a3:	5b                   	pop    %ebx
 8a4:	5e                   	pop    %esi
 8a5:	5f                   	pop    %edi
 8a6:	5d                   	pop    %ebp
 8a7:	c3                   	ret    
 8a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ad:	e9 76 ff ff ff       	jmp    828 <malloc+0x38>
 8b2:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8b4:	c7 05 a0 0d 00 00 a4 	movl   $0xda4,0xda0
 8bb:	0d 00 00 
 8be:	c7 05 a4 0d 00 00 a4 	movl   $0xda4,0xda4
 8c5:	0d 00 00 
    base.s.size = 0;
 8c8:	c7 05 a8 0d 00 00 00 	movl   $0x0,0xda8
 8cf:	00 00 00 
 8d2:	bf a4 0d 00 00       	mov    $0xda4,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d7:	89 fa                	mov    %edi,%edx
 8d9:	e9 3c ff ff ff       	jmp    81a <malloc+0x2a>
 8de:	66 90                	xchg   %ax,%ax
        prevp->s.ptr = p->s.ptr;
 8e0:	8b 08                	mov    (%eax),%ecx
 8e2:	89 0a                	mov    %ecx,(%edx)
 8e4:	eb b1                	jmp    897 <malloc+0xa7>
