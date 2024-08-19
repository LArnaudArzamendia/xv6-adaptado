
kernel/kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc a0 5e 11 80       	mov    $0x80115ea0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 24 2c 10 80       	mov    $0x80102c24,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 80 6a 10 80       	push   $0x80106a80
80100040:	68 20 a5 10 80       	push   $0x8010a520
80100045:	e8 fa 3d 00 00       	call   80103e44 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
80100051:	ec 10 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
8010005b:	ec 10 80 
8010005e:	83 c4 10             	add    $0x10,%esp
80100061:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100066:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
8010006b:	eb 05                	jmp    80100072 <binit+0x3e>
8010006d:	8d 76 00             	lea    0x0(%esi),%esi
80100070:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100072:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100075:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010007c:	83 ec 08             	sub    $0x8,%esp
8010007f:	68 87 6a 10 80       	push   $0x80106a87
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	50                   	push   %eax
80100088:	e8 a7 3c 00 00       	call   80103d34 <initsleeplock>
    bcache.head.next->prev = b;
8010008d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100092:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100095:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009b:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a1:	89 d8                	mov    %ebx,%eax
801000a3:	83 c4 10             	add    $0x10,%esp
801000a6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000ac:	75 c2                	jne    80100070 <binit+0x3c>
  }
}
801000ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	90                   	nop

801000b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	57                   	push   %edi
801000b8:	56                   	push   %esi
801000b9:	53                   	push   %ebx
801000ba:	83 ec 18             	sub    $0x18,%esp
801000bd:	8b 75 08             	mov    0x8(%ebp),%esi
801000c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 2f 3f 00 00       	call   80103ffc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cd:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000d3:	83 c4 10             	add    $0x10,%esp
801000d6:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000dc:	75 0d                	jne    801000eb <bread+0x37>
801000de:	eb 1c                	jmp    801000fc <bread+0x48>
801000e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000e3:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000e9:	74 11                	je     801000fc <bread+0x48>
    if(b->dev == dev && b->blockno == blockno){
801000eb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000ee:	75 f0                	jne    801000e0 <bread+0x2c>
801000f0:	3b 7b 08             	cmp    0x8(%ebx),%edi
801000f3:	75 eb                	jne    801000e0 <bread+0x2c>
      b->refcnt++;
801000f5:	ff 43 4c             	incl   0x4c(%ebx)
      release(&bcache.lock);
801000f8:	eb 3c                	jmp    80100136 <bread+0x82>
801000fa:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000fc:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100102:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100108:	75 0d                	jne    80100117 <bread+0x63>
8010010a:	eb 6a                	jmp    80100176 <bread+0xc2>
8010010c:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010010f:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100115:	74 5f                	je     80100176 <bread+0xc2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100117:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010011a:	85 c0                	test   %eax,%eax
8010011c:	75 ee                	jne    8010010c <bread+0x58>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 e9                	jne    8010010c <bread+0x58>
      b->dev = dev;
80100123:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	83 ec 0c             	sub    $0xc,%esp
80100139:	68 20 a5 10 80       	push   $0x8010a520
8010013e:	e8 59 3e 00 00       	call   80103f9c <release>
      acquiresleep(&b->lock);
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	89 04 24             	mov    %eax,(%esp)
80100149:	e8 1a 3c 00 00       	call   80103d68 <acquiresleep>
      return b;
8010014e:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100151:	f6 03 02             	testb  $0x2,(%ebx)
80100154:	74 0a                	je     80100160 <bread+0xac>
    iderw(b);
  }
  return b;
}
80100156:	89 d8                	mov    %ebx,%eax
80100158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010015b:	5b                   	pop    %ebx
8010015c:	5e                   	pop    %esi
8010015d:	5f                   	pop    %edi
8010015e:	5d                   	pop    %ebp
8010015f:	c3                   	ret    
    iderw(b);
80100160:	83 ec 0c             	sub    $0xc,%esp
80100163:	53                   	push   %ebx
80100164:	e8 a7 1e 00 00       	call   80102010 <iderw>
80100169:	83 c4 10             	add    $0x10,%esp
}
8010016c:	89 d8                	mov    %ebx,%eax
8010016e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100171:	5b                   	pop    %ebx
80100172:	5e                   	pop    %esi
80100173:	5f                   	pop    %edi
80100174:	5d                   	pop    %ebp
80100175:	c3                   	ret    
  panic("bget: no buffers");
80100176:	83 ec 0c             	sub    $0xc,%esp
80100179:	68 8e 6a 10 80       	push   $0x80106a8e
8010017e:	e8 b5 01 00 00       	call   80100338 <panic>
80100183:	90                   	nop

80100184 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100184:	55                   	push   %ebp
80100185:	89 e5                	mov    %esp,%ebp
80100187:	53                   	push   %ebx
80100188:	83 ec 10             	sub    $0x10,%esp
8010018b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010018e:	8d 43 0c             	lea    0xc(%ebx),%eax
80100191:	50                   	push   %eax
80100192:	e8 61 3c 00 00       	call   80103df8 <holdingsleep>
80100197:	83 c4 10             	add    $0x10,%esp
8010019a:	85 c0                	test   %eax,%eax
8010019c:	74 0f                	je     801001ad <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
8010019e:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001a7:	c9                   	leave  
  iderw(b);
801001a8:	e9 63 1e 00 00       	jmp    80102010 <iderw>
    panic("bwrite");
801001ad:	83 ec 0c             	sub    $0xc,%esp
801001b0:	68 9f 6a 10 80       	push   $0x80106a9f
801001b5:	e8 7e 01 00 00       	call   80100338 <panic>
801001ba:	66 90                	xchg   %ax,%ax

801001bc <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001bc:	55                   	push   %ebp
801001bd:	89 e5                	mov    %esp,%ebp
801001bf:	56                   	push   %esi
801001c0:	53                   	push   %ebx
801001c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c4:	8d 73 0c             	lea    0xc(%ebx),%esi
801001c7:	83 ec 0c             	sub    $0xc,%esp
801001ca:	56                   	push   %esi
801001cb:	e8 28 3c 00 00       	call   80103df8 <holdingsleep>
801001d0:	83 c4 10             	add    $0x10,%esp
801001d3:	85 c0                	test   %eax,%eax
801001d5:	74 64                	je     8010023b <brelse+0x7f>
    panic("brelse");

  releasesleep(&b->lock);
801001d7:	83 ec 0c             	sub    $0xc,%esp
801001da:	56                   	push   %esi
801001db:	e8 dc 3b 00 00       	call   80103dbc <releasesleep>

  acquire(&bcache.lock);
801001e0:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801001e7:	e8 10 3e 00 00       	call   80103ffc <acquire>
  b->refcnt--;
801001ec:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001ef:	48                   	dec    %eax
801001f0:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001f3:	83 c4 10             	add    $0x10,%esp
801001f6:	85 c0                	test   %eax,%eax
801001f8:	75 2f                	jne    80100229 <brelse+0x6d>
    // no one is waiting for it.
    b->next->prev = b->prev;
801001fa:	8b 43 54             	mov    0x54(%ebx),%eax
801001fd:	8b 53 50             	mov    0x50(%ebx),%edx
80100200:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100203:	8b 43 50             	mov    0x50(%ebx),%eax
80100206:	8b 53 54             	mov    0x54(%ebx),%edx
80100209:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010020c:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100211:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100214:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
8010021b:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100220:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100223:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100229:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100230:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100233:	5b                   	pop    %ebx
80100234:	5e                   	pop    %esi
80100235:	5d                   	pop    %ebp
  release(&bcache.lock);
80100236:	e9 61 3d 00 00       	jmp    80103f9c <release>
    panic("brelse");
8010023b:	83 ec 0c             	sub    $0xc,%esp
8010023e:	68 a6 6a 10 80       	push   $0x80106aa6
80100243:	e8 f0 00 00 00       	call   80100338 <panic>

80100248 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100248:	55                   	push   %ebp
80100249:	89 e5                	mov    %esp,%ebp
8010024b:	57                   	push   %edi
8010024c:	56                   	push   %esi
8010024d:	53                   	push   %ebx
8010024e:	83 ec 18             	sub    $0x18,%esp
80100251:	8b 7d 08             	mov    0x8(%ebp),%edi
80100254:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100257:	57                   	push   %edi
80100258:	e8 2b 14 00 00       	call   80101688 <iunlock>
  target = n;
8010025d:	89 de                	mov    %ebx,%esi
  acquire(&cons.lock);
8010025f:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100266:	e8 91 3d 00 00       	call   80103ffc <acquire>
  while(n > 0){
8010026b:	83 c4 10             	add    $0x10,%esp
8010026e:	85 db                	test   %ebx,%ebx
80100270:	0f 8e 93 00 00 00    	jle    80100309 <consoleread+0xc1>
    while(input.r == input.w){
80100276:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010027b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100281:	74 27                	je     801002aa <consoleread+0x62>
80100283:	eb 57                	jmp    801002dc <consoleread+0x94>
80100285:	8d 76 00             	lea    0x0(%esi),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100288:	83 ec 08             	sub    $0x8,%esp
8010028b:	68 20 ef 10 80       	push   $0x8010ef20
80100290:	68 00 ef 10 80       	push   $0x8010ef00
80100295:	e8 62 38 00 00       	call   80103afc <sleep>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a8:	75 32                	jne    801002dc <consoleread+0x94>
      if(myproc()->killed){
801002aa:	e8 fd 31 00 00       	call   801034ac <myproc>
801002af:	8b 40 24             	mov    0x24(%eax),%eax
801002b2:	85 c0                	test   %eax,%eax
801002b4:	74 d2                	je     80100288 <consoleread+0x40>
        release(&cons.lock);
801002b6:	83 ec 0c             	sub    $0xc,%esp
801002b9:	68 20 ef 10 80       	push   $0x8010ef20
801002be:	e8 d9 3c 00 00       	call   80103f9c <release>
        ilock(ip);
801002c3:	89 3c 24             	mov    %edi,(%esp)
801002c6:	e8 f5 12 00 00       	call   801015c0 <ilock>
        return -1;
801002cb:	83 c4 10             	add    $0x10,%esp
801002ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002d6:	5b                   	pop    %ebx
801002d7:	5e                   	pop    %esi
801002d8:	5f                   	pop    %edi
801002d9:	5d                   	pop    %ebp
801002da:	c3                   	ret    
801002db:	90                   	nop
    c = input.buf[input.r++ % INPUT_BUF];
801002dc:	8d 50 01             	lea    0x1(%eax),%edx
801002df:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	83 e2 7f             	and    $0x7f,%edx
801002ea:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
801002f1:	80 f9 04             	cmp    $0x4,%cl
801002f4:	74 37                	je     8010032d <consoleread+0xe5>
    *dst++ = c;
801002f6:	ff 45 0c             	incl   0xc(%ebp)
801002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fc:	88 48 ff             	mov    %cl,-0x1(%eax)
    --n;
801002ff:	4b                   	dec    %ebx
    if(c == '\n')
80100300:	83 f9 0a             	cmp    $0xa,%ecx
80100303:	0f 85 65 ff ff ff    	jne    8010026e <consoleread+0x26>
  release(&cons.lock);
80100309:	83 ec 0c             	sub    $0xc,%esp
8010030c:	68 20 ef 10 80       	push   $0x8010ef20
80100311:	e8 86 3c 00 00       	call   80103f9c <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 12 00 00       	call   801015c0 <ilock>
  return target - n;
8010031e:	89 f0                	mov    %esi,%eax
80100320:	29 d8                	sub    %ebx,%eax
80100322:	83 c4 10             	add    $0x10,%esp
}
80100325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100328:	5b                   	pop    %ebx
80100329:	5e                   	pop    %esi
8010032a:	5f                   	pop    %edi
8010032b:	5d                   	pop    %ebp
8010032c:	c3                   	ret    
      if(n < target){
8010032d:	39 f3                	cmp    %esi,%ebx
8010032f:	73 d8                	jae    80100309 <consoleread+0xc1>
        input.r--;
80100331:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100336:	eb d1                	jmp    80100309 <consoleread+0xc1>

80100338 <panic>:
{
80100338:	55                   	push   %ebp
80100339:	89 e5                	mov    %esp,%ebp
8010033b:	56                   	push   %esi
8010033c:	53                   	push   %ebx
8010033d:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100340:	fa                   	cli    
  cons.locking = 0;
80100341:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100348:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010034b:	e8 34 22 00 00       	call   80102584 <lapicid>
80100350:	83 ec 08             	sub    $0x8,%esp
80100353:	50                   	push   %eax
80100354:	68 ad 6a 10 80       	push   $0x80106aad
80100359:	e8 be 02 00 00       	call   8010061c <cprintf>
  cprintf(s);
8010035e:	58                   	pop    %eax
8010035f:	ff 75 08             	push   0x8(%ebp)
80100362:	e8 b5 02 00 00       	call   8010061c <cprintf>
  cprintf("\n");
80100367:	c7 04 24 d7 73 10 80 	movl   $0x801073d7,(%esp)
8010036e:	e8 a9 02 00 00       	call   8010061c <cprintf>
  getcallerpcs(&s, pcs);
80100373:	5a                   	pop    %edx
80100374:	59                   	pop    %ecx
80100375:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100378:	53                   	push   %ebx
80100379:	8d 45 08             	lea    0x8(%ebp),%eax
8010037c:	50                   	push   %eax
8010037d:	e8 de 3a 00 00       	call   80103e60 <getcallerpcs>
  for(i=0; i<10; i++)
80100382:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100385:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100388:	83 ec 08             	sub    $0x8,%esp
8010038b:	ff 33                	push   (%ebx)
8010038d:	68 c1 6a 10 80       	push   $0x80106ac1
80100392:	e8 85 02 00 00       	call   8010061c <cprintf>
  for(i=0; i<10; i++)
80100397:	83 c3 04             	add    $0x4,%ebx
8010039a:	83 c4 10             	add    $0x10,%esp
8010039d:	39 f3                	cmp    %esi,%ebx
8010039f:	75 e7                	jne    80100388 <panic+0x50>
  panicked = 1; // freeze other CPU
801003a1:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003a8:	00 00 00 
  for(;;)
801003ab:	eb fe                	jmp    801003ab <panic+0x73>
801003ad:	8d 76 00             	lea    0x0(%esi),%esi

801003b0 <consputc.part.0>:
consputc(int c)
801003b0:	55                   	push   %ebp
801003b1:	89 e5                	mov    %esp,%ebp
801003b3:	57                   	push   %edi
801003b4:	56                   	push   %esi
801003b5:	53                   	push   %ebx
801003b6:	83 ec 1c             	sub    $0x1c,%esp
801003b9:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003bb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003c0:	0f 84 ce 00 00 00    	je     80100494 <consputc.part.0+0xe4>
    uartputc(c);
801003c6:	83 ec 0c             	sub    $0xc,%esp
801003c9:	50                   	push   %eax
801003ca:	e8 b9 50 00 00       	call   80105488 <uartputc>
801003cf:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d2:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003d7:	b0 0e                	mov    $0xe,%al
801003d9:	89 fa                	mov    %edi,%edx
801003db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003dc:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003e1:	89 ca                	mov    %ecx,%edx
801003e3:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003e4:	0f b6 d8             	movzbl %al,%ebx
801003e7:	c1 e3 08             	shl    $0x8,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ea:	b0 0f                	mov    $0xf,%al
801003ec:	89 fa                	mov    %edi,%edx
801003ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003ef:	89 ca                	mov    %ecx,%edx
801003f1:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003f2:	0f b6 c8             	movzbl %al,%ecx
801003f5:	09 d9                	or     %ebx,%ecx
  if(c == '\n')
801003f7:	83 fe 0a             	cmp    $0xa,%esi
801003fa:	0f 84 84 00 00 00    	je     80100484 <consputc.part.0+0xd4>
  else if(c == BACKSPACE){
80100400:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100406:	74 6c                	je     80100474 <consputc.part.0+0xc4>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100408:	8d 59 01             	lea    0x1(%ecx),%ebx
8010040b:	89 f0                	mov    %esi,%eax
8010040d:	0f b6 f0             	movzbl %al,%esi
80100410:	81 ce 00 07 00 00    	or     $0x700,%esi
80100416:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
8010041d:	80 
  if(pos < 0 || pos > 25*80)
8010041e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100424:	0f 8f ee 00 00 00    	jg     80100518 <consputc.part.0+0x168>
  if((pos/80) >= 24){  // Scroll up.
8010042a:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100430:	0f 8f 8a 00 00 00    	jg     801004c0 <consputc.part.0+0x110>
  outb(CRTPORT+1, pos>>8);
80100436:	0f b6 c7             	movzbl %bh,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  outb(CRTPORT+1, pos);
8010043c:	89 de                	mov    %ebx,%esi
  crt[pos] = ' ' | 0x0700;
8010043e:	01 db                	add    %ebx,%ebx
80100440:	8d bb 00 80 0b 80    	lea    -0x7ff48000(%ebx),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010044b:	b0 0e                	mov    $0xe,%al
8010044d:	89 da                	mov    %ebx,%edx
8010044f:	ee                   	out    %al,(%dx)
80100450:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100455:	8a 45 e4             	mov    -0x1c(%ebp),%al
80100458:	89 ca                	mov    %ecx,%edx
8010045a:	ee                   	out    %al,(%dx)
8010045b:	b0 0f                	mov    $0xf,%al
8010045d:	89 da                	mov    %ebx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	89 f0                	mov    %esi,%eax
80100462:	89 ca                	mov    %ecx,%edx
80100464:	ee                   	out    %al,(%dx)
80100465:	66 c7 07 20 07       	movw   $0x720,(%edi)
}
8010046a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010046d:	5b                   	pop    %ebx
8010046e:	5e                   	pop    %esi
8010046f:	5f                   	pop    %edi
80100470:	5d                   	pop    %ebp
80100471:	c3                   	ret    
80100472:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
80100474:	85 c9                	test   %ecx,%ecx
80100476:	0f 84 8c 00 00 00    	je     80100508 <consputc.part.0+0x158>
8010047c:	8d 59 ff             	lea    -0x1(%ecx),%ebx
8010047f:	eb 9d                	jmp    8010041e <consputc.part.0+0x6e>
80100481:	8d 76 00             	lea    0x0(%esi),%esi
    pos += 80 - pos%80;
80100484:	bb 50 00 00 00       	mov    $0x50,%ebx
80100489:	89 c8                	mov    %ecx,%eax
8010048b:	99                   	cltd   
8010048c:	f7 fb                	idiv   %ebx
8010048e:	29 d3                	sub    %edx,%ebx
80100490:	01 cb                	add    %ecx,%ebx
80100492:	eb 8a                	jmp    8010041e <consputc.part.0+0x6e>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100494:	83 ec 0c             	sub    $0xc,%esp
80100497:	6a 08                	push   $0x8
80100499:	e8 ea 4f 00 00       	call   80105488 <uartputc>
8010049e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004a5:	e8 de 4f 00 00       	call   80105488 <uartputc>
801004aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b1:	e8 d2 4f 00 00       	call   80105488 <uartputc>
801004b6:	83 c4 10             	add    $0x10,%esp
801004b9:	e9 14 ff ff ff       	jmp    801003d2 <consputc.part.0+0x22>
801004be:	66 90                	xchg   %ax,%ax
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004c0:	50                   	push   %eax
801004c1:	68 60 0e 00 00       	push   $0xe60
801004c6:	68 a0 80 0b 80       	push   $0x800b80a0
801004cb:	68 00 80 0b 80       	push   $0x800b8000
801004d0:	e8 53 3c 00 00       	call   80104128 <memmove>
    pos -= 80;
801004d5:	8d 73 b0             	lea    -0x50(%ebx),%esi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d8:	8d 84 1b 60 ff ff ff 	lea    -0xa0(%ebx,%ebx,1),%eax
801004df:	8d b8 00 80 0b 80    	lea    -0x7ff48000(%eax),%edi
801004e5:	83 c4 0c             	add    $0xc,%esp
801004e8:	b8 80 07 00 00       	mov    $0x780,%eax
801004ed:	29 f0                	sub    %esi,%eax
801004ef:	01 c0                	add    %eax,%eax
801004f1:	50                   	push   %eax
801004f2:	6a 00                	push   $0x0
801004f4:	57                   	push   %edi
801004f5:	e8 aa 3b 00 00       	call   801040a4 <memset>
  outb(CRTPORT+1, pos);
801004fa:	83 c4 10             	add    $0x10,%esp
801004fd:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
80100501:	e9 40 ff ff ff       	jmp    80100446 <consputc.part.0+0x96>
80100506:	66 90                	xchg   %ax,%ax
80100508:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
8010050d:	31 f6                	xor    %esi,%esi
8010050f:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100513:	e9 2e ff ff ff       	jmp    80100446 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100518:	83 ec 0c             	sub    $0xc,%esp
8010051b:	68 c5 6a 10 80       	push   $0x80106ac5
80100520:	e8 13 fe ff ff       	call   80100338 <panic>
80100525:	8d 76 00             	lea    0x0(%esi),%esi

80100528 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100528:	55                   	push   %ebp
80100529:	89 e5                	mov    %esp,%ebp
8010052b:	57                   	push   %edi
8010052c:	56                   	push   %esi
8010052d:	53                   	push   %ebx
8010052e:	83 ec 18             	sub    $0x18,%esp
80100531:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;

  iunlock(ip);
80100534:	ff 75 08             	push   0x8(%ebp)
80100537:	e8 4c 11 00 00       	call   80101688 <iunlock>
  acquire(&cons.lock);
8010053c:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100543:	e8 b4 3a 00 00       	call   80103ffc <acquire>
  for(i = 0; i < n; i++)
80100548:	83 c4 10             	add    $0x10,%esp
8010054b:	85 db                	test   %ebx,%ebx
8010054d:	7e 23                	jle    80100572 <consolewrite+0x4a>
8010054f:	8b 75 0c             	mov    0xc(%ebp),%esi
80100552:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
    consputc(buf[i] & 0xff);
80100555:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
80100558:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010055e:	85 d2                	test   %edx,%edx
80100560:	74 06                	je     80100568 <consolewrite+0x40>
  asm volatile("cli");
80100562:	fa                   	cli    
    for(;;)
80100563:	eb fe                	jmp    80100563 <consolewrite+0x3b>
80100565:	8d 76 00             	lea    0x0(%esi),%esi
80100568:	e8 43 fe ff ff       	call   801003b0 <consputc.part.0>
  for(i = 0; i < n; i++)
8010056d:	46                   	inc    %esi
8010056e:	39 f7                	cmp    %esi,%edi
80100570:	75 e3                	jne    80100555 <consolewrite+0x2d>
  release(&cons.lock);
80100572:	83 ec 0c             	sub    $0xc,%esp
80100575:	68 20 ef 10 80       	push   $0x8010ef20
8010057a:	e8 1d 3a 00 00       	call   80103f9c <release>
  ilock(ip);
8010057f:	58                   	pop    %eax
80100580:	ff 75 08             	push   0x8(%ebp)
80100583:	e8 38 10 00 00       	call   801015c0 <ilock>

  return n;
}
80100588:	89 d8                	mov    %ebx,%eax
8010058a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010058d:	5b                   	pop    %ebx
8010058e:	5e                   	pop    %esi
8010058f:	5f                   	pop    %edi
80100590:	5d                   	pop    %ebp
80100591:	c3                   	ret    
80100592:	66 90                	xchg   %ax,%ax

80100594 <printint>:
{
80100594:	55                   	push   %ebp
80100595:	89 e5                	mov    %esp,%ebp
80100597:	57                   	push   %edi
80100598:	56                   	push   %esi
80100599:	53                   	push   %ebx
8010059a:	83 ec 2c             	sub    $0x2c,%esp
8010059d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005a0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005a3:	85 c9                	test   %ecx,%ecx
801005a5:	74 04                	je     801005ab <printint+0x17>
801005a7:	85 c0                	test   %eax,%eax
801005a9:	78 63                	js     8010060e <printint+0x7a>
    x = xx;
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  i = 0;
801005b4:	31 f6                	xor    %esi,%esi
801005b6:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
801005b8:	89 c8                	mov    %ecx,%eax
801005ba:	31 d2                	xor    %edx,%edx
801005bc:	f7 75 d4             	divl   -0x2c(%ebp)
801005bf:	89 f3                	mov    %esi,%ebx
801005c1:	8d 76 01             	lea    0x1(%esi),%esi
801005c4:	8a 92 f0 6a 10 80    	mov    -0x7fef9510(%edx),%dl
801005ca:	88 54 1d d8          	mov    %dl,-0x28(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005ce:	89 cf                	mov    %ecx,%edi
801005d0:	89 c1                	mov    %eax,%ecx
801005d2:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
801005d5:	73 e1                	jae    801005b8 <printint+0x24>
  if(sign)
801005d7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005da:	85 c9                	test   %ecx,%ecx
801005dc:	74 09                	je     801005e7 <printint+0x53>
    buf[i++] = '-';
801005de:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
801005e3:	89 f3                	mov    %esi,%ebx
    buf[i++] = '-';
801005e5:	b2 2d                	mov    $0x2d,%dl
  while(--i >= 0)
801005e7:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
801005eb:	0f be c2             	movsbl %dl,%eax
  if(panicked){
801005ee:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801005f4:	85 d2                	test   %edx,%edx
801005f6:	74 04                	je     801005fc <printint+0x68>
801005f8:	fa                   	cli    
    for(;;)
801005f9:	eb fe                	jmp    801005f9 <printint+0x65>
801005fb:	90                   	nop
801005fc:	e8 af fd ff ff       	call   801003b0 <consputc.part.0>
  while(--i >= 0)
80100601:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100604:	39 c3                	cmp    %eax,%ebx
80100606:	74 0c                	je     80100614 <printint+0x80>
    consputc(buf[i]);
80100608:	0f be 03             	movsbl (%ebx),%eax
8010060b:	4b                   	dec    %ebx
8010060c:	eb e0                	jmp    801005ee <printint+0x5a>
    x = -xx;
8010060e:	f7 d8                	neg    %eax
80100610:	89 c1                	mov    %eax,%ecx
80100612:	eb a0                	jmp    801005b4 <printint+0x20>
}
80100614:	83 c4 2c             	add    $0x2c,%esp
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret    

8010061c <cprintf>:
{
8010061c:	55                   	push   %ebp
8010061d:	89 e5                	mov    %esp,%ebp
8010061f:	57                   	push   %edi
80100620:	56                   	push   %esi
80100621:	53                   	push   %ebx
80100622:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100625:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
8010062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
8010062d:	85 c0                	test   %eax,%eax
8010062f:	0f 85 17 01 00 00    	jne    8010074c <cprintf+0x130>
  if (fmt == 0)
80100635:	8b 75 08             	mov    0x8(%ebp),%esi
80100638:	85 f6                	test   %esi,%esi
8010063a:	0f 84 94 01 00 00    	je     801007d4 <cprintf+0x1b8>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100640:	0f b6 06             	movzbl (%esi),%eax
80100643:	85 c0                	test   %eax,%eax
80100645:	74 57                	je     8010069e <cprintf+0x82>
  argp = (uint*)(void*)(&fmt + 1);
80100647:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064a:	31 db                	xor    %ebx,%ebx
    if(c != '%'){
8010064c:	83 f8 25             	cmp    $0x25,%eax
8010064f:	0f 85 bf 00 00 00    	jne    80100714 <cprintf+0xf8>
    c = fmt[++i] & 0xff;
80100655:	43                   	inc    %ebx
80100656:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
8010065a:	85 d2                	test   %edx,%edx
8010065c:	74 40                	je     8010069e <cprintf+0x82>
    switch(c){
8010065e:	83 fa 70             	cmp    $0x70,%edx
80100661:	0f 84 86 00 00 00    	je     801006ed <cprintf+0xd1>
80100667:	7f 4b                	jg     801006b4 <cprintf+0x98>
80100669:	83 fa 25             	cmp    $0x25,%edx
8010066c:	0f 84 b2 00 00 00    	je     80100724 <cprintf+0x108>
80100672:	83 fa 64             	cmp    $0x64,%edx
80100675:	0f 85 e6 00 00 00    	jne    80100761 <cprintf+0x145>
      printint(*argp++, 10, 1);
8010067b:	8d 47 04             	lea    0x4(%edi),%eax
8010067e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100681:	b9 01 00 00 00       	mov    $0x1,%ecx
80100686:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068b:	8b 07                	mov    (%edi),%eax
8010068d:	e8 02 ff ff ff       	call   80100594 <printint>
80100692:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100695:	43                   	inc    %ebx
80100696:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
8010069a:	85 c0                	test   %eax,%eax
8010069c:	75 ae                	jne    8010064c <cprintf+0x30>
  if(locking)
8010069e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006a1:	85 c0                	test   %eax,%eax
801006a3:	0f 85 0e 01 00 00    	jne    801007b7 <cprintf+0x19b>
}
801006a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006ac:	5b                   	pop    %ebx
801006ad:	5e                   	pop    %esi
801006ae:	5f                   	pop    %edi
801006af:	5d                   	pop    %ebp
801006b0:	c3                   	ret    
801006b1:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801006b4:	83 fa 73             	cmp    $0x73,%edx
801006b7:	75 2f                	jne    801006e8 <cprintf+0xcc>
      if((s = (char*)*argp++) == 0)
801006b9:	8d 47 04             	lea    0x4(%edi),%eax
801006bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006bf:	8b 3f                	mov    (%edi),%edi
801006c1:	85 ff                	test   %edi,%edi
801006c3:	0f 84 d3 00 00 00    	je     8010079c <cprintf+0x180>
      for(; *s; s++)
801006c9:	0f be 07             	movsbl (%edi),%eax
801006cc:	84 c0                	test   %al,%al
801006ce:	0f 84 f8 00 00 00    	je     801007cc <cprintf+0x1b0>
  if(panicked){
801006d4:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801006da:	85 d2                	test   %edx,%edx
801006dc:	0f 84 a6 00 00 00    	je     80100788 <cprintf+0x16c>
801006e2:	fa                   	cli    
    for(;;)
801006e3:	eb fe                	jmp    801006e3 <cprintf+0xc7>
801006e5:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801006e8:	83 fa 78             	cmp    $0x78,%edx
801006eb:	75 74                	jne    80100761 <cprintf+0x145>
      printint(*argp++, 16, 0);
801006ed:	8d 47 04             	lea    0x4(%edi),%eax
801006f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f3:	31 c9                	xor    %ecx,%ecx
801006f5:	ba 10 00 00 00       	mov    $0x10,%edx
801006fa:	8b 07                	mov    (%edi),%eax
801006fc:	e8 93 fe ff ff       	call   80100594 <printint>
80100701:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100704:	43                   	inc    %ebx
80100705:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 3b ff ff ff    	jne    8010064c <cprintf+0x30>
80100711:	eb 8b                	jmp    8010069e <cprintf+0x82>
80100713:	90                   	nop
  if(panicked){
80100714:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
8010071a:	85 c9                	test   %ecx,%ecx
8010071c:	74 14                	je     80100732 <cprintf+0x116>
8010071e:	fa                   	cli    
    for(;;)
8010071f:	eb fe                	jmp    8010071f <cprintf+0x103>
80100721:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100724:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 66                	jne    80100793 <cprintf+0x177>
8010072d:	b8 25 00 00 00       	mov    $0x25,%eax
80100732:	e8 79 fc ff ff       	call   801003b0 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100737:	43                   	inc    %ebx
80100738:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
8010073c:	85 c0                	test   %eax,%eax
8010073e:	0f 85 08 ff ff ff    	jne    8010064c <cprintf+0x30>
80100744:	e9 55 ff ff ff       	jmp    8010069e <cprintf+0x82>
80100749:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&cons.lock);
8010074c:	83 ec 0c             	sub    $0xc,%esp
8010074f:	68 20 ef 10 80       	push   $0x8010ef20
80100754:	e8 a3 38 00 00       	call   80103ffc <acquire>
80100759:	83 c4 10             	add    $0x10,%esp
8010075c:	e9 d4 fe ff ff       	jmp    80100635 <cprintf+0x19>
  if(panicked){
80100761:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100767:	85 c9                	test   %ecx,%ecx
80100769:	75 2d                	jne    80100798 <cprintf+0x17c>
8010076b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010076e:	b8 25 00 00 00       	mov    $0x25,%eax
80100773:	e8 38 fc ff ff       	call   801003b0 <consputc.part.0>
80100778:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010077e:	85 d2                	test   %edx,%edx
80100780:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100783:	74 26                	je     801007ab <cprintf+0x18f>
80100785:	fa                   	cli    
    for(;;)
80100786:	eb fe                	jmp    80100786 <cprintf+0x16a>
80100788:	e8 23 fc ff ff       	call   801003b0 <consputc.part.0>
      for(; *s; s++)
8010078d:	47                   	inc    %edi
8010078e:	e9 36 ff ff ff       	jmp    801006c9 <cprintf+0xad>
80100793:	fa                   	cli    
    for(;;)
80100794:	eb fe                	jmp    80100794 <cprintf+0x178>
80100796:	66 90                	xchg   %ax,%ax
80100798:	fa                   	cli    
80100799:	eb fe                	jmp    80100799 <cprintf+0x17d>
8010079b:	90                   	nop
        s = "(null)";
8010079c:	bf d8 6a 10 80       	mov    $0x80106ad8,%edi
      for(; *s; s++)
801007a1:	b8 28 00 00 00       	mov    $0x28,%eax
801007a6:	e9 29 ff ff ff       	jmp    801006d4 <cprintf+0xb8>
801007ab:	89 d0                	mov    %edx,%eax
801007ad:	e8 fe fb ff ff       	call   801003b0 <consputc.part.0>
801007b2:	e9 de fe ff ff       	jmp    80100695 <cprintf+0x79>
    release(&cons.lock);
801007b7:	83 ec 0c             	sub    $0xc,%esp
801007ba:	68 20 ef 10 80       	push   $0x8010ef20
801007bf:	e8 d8 37 00 00       	call   80103f9c <release>
801007c4:	83 c4 10             	add    $0x10,%esp
}
801007c7:	e9 dd fe ff ff       	jmp    801006a9 <cprintf+0x8d>
      if((s = (char*)*argp++) == 0)
801007cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801007cf:	e9 c1 fe ff ff       	jmp    80100695 <cprintf+0x79>
    panic("null fmt");
801007d4:	83 ec 0c             	sub    $0xc,%esp
801007d7:	68 df 6a 10 80       	push   $0x80106adf
801007dc:	e8 57 fb ff ff       	call   80100338 <panic>
801007e1:	8d 76 00             	lea    0x0(%esi),%esi

801007e4 <consoleintr>:
{
801007e4:	55                   	push   %ebp
801007e5:	89 e5                	mov    %esp,%ebp
801007e7:	57                   	push   %edi
801007e8:	56                   	push   %esi
801007e9:	53                   	push   %ebx
801007ea:	83 ec 28             	sub    $0x28,%esp
801007ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
801007f0:	68 20 ef 10 80       	push   $0x8010ef20
801007f5:	e8 02 38 00 00       	call   80103ffc <acquire>
  while((c = getc()) >= 0){
801007fa:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
801007fd:	31 f6                	xor    %esi,%esi
  while((c = getc()) >= 0){
801007ff:	eb 1a                	jmp    8010081b <consoleintr+0x37>
80100801:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100804:	83 f8 08             	cmp    $0x8,%eax
80100807:	0f 84 eb 00 00 00    	je     801008f8 <consoleintr+0x114>
8010080d:	83 f8 10             	cmp    $0x10,%eax
80100810:	0f 85 3e 01 00 00    	jne    80100954 <consoleintr+0x170>
80100816:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010081b:	ff d7                	call   *%edi
8010081d:	85 c0                	test   %eax,%eax
8010081f:	0f 88 13 01 00 00    	js     80100938 <consoleintr+0x154>
    switch(c){
80100825:	83 f8 15             	cmp    $0x15,%eax
80100828:	0f 84 92 00 00 00    	je     801008c0 <consoleintr+0xdc>
8010082e:	7e d4                	jle    80100804 <consoleintr+0x20>
80100830:	83 f8 7f             	cmp    $0x7f,%eax
80100833:	0f 84 bf 00 00 00    	je     801008f8 <consoleintr+0x114>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100839:	8b 1d 08 ef 10 80    	mov    0x8010ef08,%ebx
8010083f:	89 da                	mov    %ebx,%edx
80100841:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100847:	83 fa 7f             	cmp    $0x7f,%edx
8010084a:	77 cf                	ja     8010081b <consoleintr+0x37>
  if(panicked){
8010084c:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
80100852:	8d 4b 01             	lea    0x1(%ebx),%ecx
80100855:	83 e3 7f             	and    $0x7f,%ebx
80100858:	89 0d 08 ef 10 80    	mov    %ecx,0x8010ef08
        c = (c == '\r') ? '\n' : c;
8010085e:	83 f8 0d             	cmp    $0xd,%eax
80100861:	0f 84 18 01 00 00    	je     8010097f <consoleintr+0x19b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100867:	88 83 80 ee 10 80    	mov    %al,-0x7fef1180(%ebx)
  if(panicked){
8010086d:	85 d2                	test   %edx,%edx
8010086f:	0f 85 15 01 00 00    	jne    8010098a <consoleintr+0x1a6>
80100875:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100878:	e8 33 fb ff ff       	call   801003b0 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100880:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
80100886:	83 f8 0a             	cmp    $0xa,%eax
80100889:	74 18                	je     801008a3 <consoleintr+0xbf>
8010088b:	83 f8 04             	cmp    $0x4,%eax
8010088e:	74 13                	je     801008a3 <consoleintr+0xbf>
80100890:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100895:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
8010089b:	39 ca                	cmp    %ecx,%edx
8010089d:	0f 85 78 ff ff ff    	jne    8010081b <consoleintr+0x37>
          input.w = input.e;
801008a3:	89 0d 04 ef 10 80    	mov    %ecx,0x8010ef04
          wakeup(&input.r);
801008a9:	83 ec 0c             	sub    $0xc,%esp
801008ac:	68 00 ef 10 80       	push   $0x8010ef00
801008b1:	e8 02 33 00 00       	call   80103bb8 <wakeup>
801008b6:	83 c4 10             	add    $0x10,%esp
801008b9:	e9 5d ff ff ff       	jmp    8010081b <consoleintr+0x37>
801008be:	66 90                	xchg   %ax,%ax
      while(input.e != input.w &&
801008c0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008c5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801008cb:	0f 84 4a ff ff ff    	je     8010081b <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008d1:	48                   	dec    %eax
801008d2:	89 c2                	mov    %eax,%edx
801008d4:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008d7:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801008de:	0f 84 37 ff ff ff    	je     8010081b <consoleintr+0x37>
        input.e--;
801008e4:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
801008e9:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801008ef:	85 d2                	test   %edx,%edx
801008f1:	74 29                	je     8010091c <consoleintr+0x138>
801008f3:	fa                   	cli    
    for(;;)
801008f4:	eb fe                	jmp    801008f4 <consoleintr+0x110>
801008f6:	66 90                	xchg   %ax,%ax
      if(input.e != input.w){
801008f8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801008fd:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100903:	0f 84 12 ff ff ff    	je     8010081b <consoleintr+0x37>
        input.e--;
80100909:	48                   	dec    %eax
8010090a:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010090f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100914:	85 c0                	test   %eax,%eax
80100916:	74 4c                	je     80100964 <consoleintr+0x180>
80100918:	fa                   	cli    
    for(;;)
80100919:	eb fe                	jmp    80100919 <consoleintr+0x135>
8010091b:	90                   	nop
8010091c:	b8 00 01 00 00       	mov    $0x100,%eax
80100921:	e8 8a fa ff ff       	call   801003b0 <consputc.part.0>
      while(input.e != input.w &&
80100926:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010092b:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100931:	75 9e                	jne    801008d1 <consoleintr+0xed>
80100933:	e9 e3 fe ff ff       	jmp    8010081b <consoleintr+0x37>
  release(&cons.lock);
80100938:	83 ec 0c             	sub    $0xc,%esp
8010093b:	68 20 ef 10 80       	push   $0x8010ef20
80100940:	e8 57 36 00 00       	call   80103f9c <release>
  if(doprocdump) {
80100945:	83 c4 10             	add    $0x10,%esp
80100948:	85 f6                	test   %esi,%esi
8010094a:	75 27                	jne    80100973 <consoleintr+0x18f>
}
8010094c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010094f:	5b                   	pop    %ebx
80100950:	5e                   	pop    %esi
80100951:	5f                   	pop    %edi
80100952:	5d                   	pop    %ebp
80100953:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100954:	85 c0                	test   %eax,%eax
80100956:	0f 84 bf fe ff ff    	je     8010081b <consoleintr+0x37>
8010095c:	e9 d8 fe ff ff       	jmp    80100839 <consoleintr+0x55>
80100961:	8d 76 00             	lea    0x0(%esi),%esi
80100964:	b8 00 01 00 00       	mov    $0x100,%eax
80100969:	e8 42 fa ff ff       	call   801003b0 <consputc.part.0>
8010096e:	e9 a8 fe ff ff       	jmp    8010081b <consoleintr+0x37>
}
80100973:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100976:	5b                   	pop    %ebx
80100977:	5e                   	pop    %esi
80100978:	5f                   	pop    %edi
80100979:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
8010097a:	e9 09 33 00 00       	jmp    80103c88 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010097f:	c6 83 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ebx)
  if(panicked){
80100986:	85 d2                	test   %edx,%edx
80100988:	74 06                	je     80100990 <consoleintr+0x1ac>
8010098a:	fa                   	cli    
    for(;;)
8010098b:	eb fe                	jmp    8010098b <consoleintr+0x1a7>
8010098d:	8d 76 00             	lea    0x0(%esi),%esi
80100990:	b8 0a 00 00 00       	mov    $0xa,%eax
80100995:	e8 16 fa ff ff       	call   801003b0 <consputc.part.0>
          input.w = input.e;
8010099a:	8b 0d 08 ef 10 80    	mov    0x8010ef08,%ecx
801009a0:	e9 fe fe ff ff       	jmp    801008a3 <consoleintr+0xbf>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi

801009a8 <consoleinit>:

void
consoleinit(void)
{
801009a8:	55                   	push   %ebp
801009a9:	89 e5                	mov    %esp,%ebp
801009ab:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009ae:	68 e8 6a 10 80       	push   $0x80106ae8
801009b3:	68 20 ef 10 80       	push   $0x8010ef20
801009b8:	e8 87 34 00 00       	call   80103e44 <initlock>

  devsw[CONSOLE].write = consolewrite;
801009bd:	c7 05 0c f9 10 80 28 	movl   $0x80100528,0x8010f90c
801009c4:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009c7:	c7 05 08 f9 10 80 48 	movl   $0x80100248,0x8010f908
801009ce:	02 10 80 
  cons.locking = 1;
801009d1:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
801009d8:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009db:	58                   	pop    %eax
801009dc:	5a                   	pop    %edx
801009dd:	6a 00                	push   $0x0
801009df:	6a 01                	push   $0x1
801009e1:	e8 ae 17 00 00       	call   80102194 <ioapicenable>
}
801009e6:	83 c4 10             	add    $0x10,%esp
801009e9:	c9                   	leave  
801009ea:	c3                   	ret    
801009eb:	90                   	nop

801009ec <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009ec:	55                   	push   %ebp
801009ed:	89 e5                	mov    %esp,%ebp
801009ef:	57                   	push   %edi
801009f0:	56                   	push   %esi
801009f1:	53                   	push   %ebx
801009f2:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009f8:	e8 af 2a 00 00       	call   801034ac <myproc>
801009fd:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a03:	e8 60 1f 00 00       	call   80102968 <begin_op>

  if((ip = namei(path)) == 0){
80100a08:	83 ec 0c             	sub    $0xc,%esp
80100a0b:	ff 75 08             	push   0x8(%ebp)
80100a0e:	e8 21 14 00 00       	call   80101e34 <namei>
80100a13:	83 c4 10             	add    $0x10,%esp
80100a16:	85 c0                	test   %eax,%eax
80100a18:	0f 84 da 02 00 00    	je     80100cf8 <exec+0x30c>
80100a1e:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a20:	83 ec 0c             	sub    $0xc,%esp
80100a23:	50                   	push   %eax
80100a24:	e8 97 0b 00 00       	call   801015c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a29:	6a 34                	push   $0x34
80100a2b:	6a 00                	push   $0x0
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	50                   	push   %eax
80100a34:	53                   	push   %ebx
80100a35:	e8 52 0e 00 00       	call   8010188c <readi>
80100a3a:	83 c4 20             	add    $0x20,%esp
80100a3d:	83 f8 34             	cmp    $0x34,%eax
80100a40:	74 1e                	je     80100a60 <exec+0x74>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	53                   	push   %ebx
80100a46:	e8 c5 0d 00 00       	call   80101810 <iunlockput>
    end_op();
80100a4b:	e8 80 1f 00 00       	call   801029d0 <end_op>
80100a50:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5b:	5b                   	pop    %ebx
80100a5c:	5e                   	pop    %esi
80100a5d:	5f                   	pop    %edi
80100a5e:	5d                   	pop    %ebp
80100a5f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 d6                	jne    80100a42 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 03 5b 00 00       	call   80106574 <setupkvm>
80100a71:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a77:	85 c0                	test   %eax,%eax
80100a79:	74 c7                	je     80100a42 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a7b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a81:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a88:	00 
80100a89:	0f 84 88 02 00 00    	je     80100d17 <exec+0x32b>
  sz = 0;
80100a8f:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a91:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80100a98:	00 00 00 
80100a9b:	e9 84 00 00 00       	jmp    80100b24 <exec+0x138>
    if(ph.type != ELF_PROG_LOAD)
80100aa0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa7:	75 61                	jne    80100b0a <exec+0x11e>
    if(ph.memsz < ph.filesz)
80100aa9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aaf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab5:	0f 82 85 00 00 00    	jb     80100b40 <exec+0x154>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100abb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ac1:	72 7d                	jb     80100b40 <exec+0x154>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100ac3:	51                   	push   %ecx
80100ac4:	50                   	push   %eax
80100ac5:	57                   	push   %edi
80100ac6:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100acc:	e8 ef 58 00 00       	call   801063c0 <allocuvm>
80100ad1:	89 c7                	mov    %eax,%edi
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	85 c0                	test   %eax,%eax
80100ad8:	74 66                	je     80100b40 <exec+0x154>
    if(ph.vaddr % PGSIZE != 0)
80100ada:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae0:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ae5:	75 59                	jne    80100b40 <exec+0x154>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ae7:	83 ec 0c             	sub    $0xc,%esp
80100aea:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100af0:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100af6:	53                   	push   %ebx
80100af7:	50                   	push   %eax
80100af8:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100afe:	e8 e1 57 00 00       	call   801062e4 <loaduvm>
80100b03:	83 c4 20             	add    $0x20,%esp
80100b06:	85 c0                	test   %eax,%eax
80100b08:	78 36                	js     80100b40 <exec+0x154>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b0a:	ff 85 f4 fe ff ff    	incl   -0x10c(%ebp)
80100b10:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100b16:	83 c6 20             	add    $0x20,%esi
80100b19:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b20:	39 c8                	cmp    %ecx,%eax
80100b22:	7e 34                	jle    80100b58 <exec+0x16c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b24:	6a 20                	push   $0x20
80100b26:	56                   	push   %esi
80100b27:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b2d:	50                   	push   %eax
80100b2e:	53                   	push   %ebx
80100b2f:	e8 58 0d 00 00       	call   8010188c <readi>
80100b34:	83 c4 10             	add    $0x10,%esp
80100b37:	83 f8 20             	cmp    $0x20,%eax
80100b3a:	0f 84 60 ff ff ff    	je     80100aa0 <exec+0xb4>
    freevm(pgdir);
80100b40:	83 ec 0c             	sub    $0xc,%esp
80100b43:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b49:	e8 b6 59 00 00       	call   80106504 <freevm>
  if(ip){
80100b4e:	83 c4 10             	add    $0x10,%esp
80100b51:	e9 ec fe ff ff       	jmp    80100a42 <exec+0x56>
80100b56:	66 90                	xchg   %ax,%ax
  sz = PGROUNDUP(sz);
80100b58:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b5e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b64:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b6a:	83 ec 0c             	sub    $0xc,%esp
80100b6d:	53                   	push   %ebx
80100b6e:	e8 9d 0c 00 00       	call   80101810 <iunlockput>
  end_op();
80100b73:	e8 58 1e 00 00       	call   801029d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b78:	83 c4 0c             	add    $0xc,%esp
80100b7b:	56                   	push   %esi
80100b7c:	57                   	push   %edi
80100b7d:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b83:	56                   	push   %esi
80100b84:	e8 37 58 00 00       	call   801063c0 <allocuvm>
80100b89:	89 c7                	mov    %eax,%edi
80100b8b:	83 c4 10             	add    $0x10,%esp
80100b8e:	85 c0                	test   %eax,%eax
80100b90:	0f 84 8a 00 00 00    	je     80100c20 <exec+0x234>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b96:	83 ec 08             	sub    $0x8,%esp
80100b99:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b9f:	50                   	push   %eax
80100ba0:	56                   	push   %esi
80100ba1:	e8 5e 5a 00 00       	call   80106604 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ba9:	8b 00                	mov    (%eax),%eax
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	89 fb                	mov    %edi,%ebx
80100bb0:	31 f6                	xor    %esi,%esi
80100bb2:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bb8:	85 c0                	test   %eax,%eax
80100bba:	0f 84 81 00 00 00    	je     80100c41 <exec+0x255>
80100bc0:	89 bd f4 fe ff ff    	mov    %edi,-0x10c(%ebp)
80100bc6:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bcc:	eb 1f                	jmp    80100bed <exec+0x201>
80100bce:	66 90                	xchg   %ax,%ax
    ustack[3+argc] = sp;
80100bd0:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bd6:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bdd:	46                   	inc    %esi
80100bde:	8b 45 0c             	mov    0xc(%ebp),%eax
80100be1:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100be4:	85 c0                	test   %eax,%eax
80100be6:	74 53                	je     80100c3b <exec+0x24f>
    if(argc >= MAXARG)
80100be8:	83 fe 20             	cmp    $0x20,%esi
80100beb:	74 33                	je     80100c20 <exec+0x234>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bed:	83 ec 0c             	sub    $0xc,%esp
80100bf0:	50                   	push   %eax
80100bf1:	e8 36 36 00 00       	call   8010422c <strlen>
80100bf6:	29 c3                	sub    %eax,%ebx
80100bf8:	4b                   	dec    %ebx
80100bf9:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bfc:	5a                   	pop    %edx
80100bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c00:	ff 34 b0             	push   (%eax,%esi,4)
80100c03:	e8 24 36 00 00       	call   8010422c <strlen>
80100c08:	40                   	inc    %eax
80100c09:	50                   	push   %eax
80100c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0d:	ff 34 b0             	push   (%eax,%esi,4)
80100c10:	53                   	push   %ebx
80100c11:	57                   	push   %edi
80100c12:	e8 91 5b 00 00       	call   801067a8 <copyout>
80100c17:	83 c4 20             	add    $0x20,%esp
80100c1a:	85 c0                	test   %eax,%eax
80100c1c:	79 b2                	jns    80100bd0 <exec+0x1e4>
80100c1e:	66 90                	xchg   %ax,%ax
    freevm(pgdir);
80100c20:	83 ec 0c             	sub    $0xc,%esp
80100c23:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c29:	e8 d6 58 00 00       	call   80106504 <freevm>
80100c2e:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c36:	e9 1d fe ff ff       	jmp    80100a58 <exec+0x6c>
80100c3b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
  ustack[3+argc] = 0;
80100c41:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c48:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100c4c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c53:	ff ff ff 
  ustack[1] = argc;
80100c56:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c5c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c63:	89 d9                	mov    %ebx,%ecx
80100c65:	29 c1                	sub    %eax,%ecx
80100c67:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c6d:	83 c0 0c             	add    $0xc,%eax
80100c70:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c72:	50                   	push   %eax
80100c73:	52                   	push   %edx
80100c74:	53                   	push   %ebx
80100c75:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100c7b:	e8 28 5b 00 00       	call   801067a8 <copyout>
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	85 c0                	test   %eax,%eax
80100c85:	78 99                	js     80100c20 <exec+0x234>
  for(last=s=path; *s; s++)
80100c87:	8b 45 08             	mov    0x8(%ebp),%eax
80100c8a:	8a 00                	mov    (%eax),%al
80100c8c:	8b 55 08             	mov    0x8(%ebp),%edx
80100c8f:	84 c0                	test   %al,%al
80100c91:	74 12                	je     80100ca5 <exec+0x2b9>
80100c93:	89 d1                	mov    %edx,%ecx
80100c95:	8d 76 00             	lea    0x0(%esi),%esi
      last = s+1;
80100c98:	41                   	inc    %ecx
    if(*s == '/')
80100c99:	3c 2f                	cmp    $0x2f,%al
80100c9b:	75 02                	jne    80100c9f <exec+0x2b3>
      last = s+1;
80100c9d:	89 ca                	mov    %ecx,%edx
  for(last=s=path; *s; s++)
80100c9f:	8a 01                	mov    (%ecx),%al
80100ca1:	84 c0                	test   %al,%al
80100ca3:	75 f3                	jne    80100c98 <exec+0x2ac>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ca5:	50                   	push   %eax
80100ca6:	6a 10                	push   $0x10
80100ca8:	52                   	push   %edx
80100ca9:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100caf:	89 f0                	mov    %esi,%eax
80100cb1:	83 c0 6c             	add    $0x6c,%eax
80100cb4:	50                   	push   %eax
80100cb5:	e8 3e 35 00 00       	call   801041f8 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100cba:	89 f0                	mov    %esi,%eax
80100cbc:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->pgdir = pgdir;
80100cbf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100cc5:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100cc8:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100cca:	89 c7                	mov    %eax,%edi
80100ccc:	8b 40 18             	mov    0x18(%eax),%eax
80100ccf:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cd5:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cd8:	8b 47 18             	mov    0x18(%edi),%eax
80100cdb:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100cde:	89 3c 24             	mov    %edi,(%esp)
80100ce1:	e8 8e 54 00 00       	call   80106174 <switchuvm>
  freevm(oldpgdir);
80100ce6:	89 34 24             	mov    %esi,(%esp)
80100ce9:	e8 16 58 00 00       	call   80106504 <freevm>
  return 0;
80100cee:	83 c4 10             	add    $0x10,%esp
80100cf1:	31 c0                	xor    %eax,%eax
80100cf3:	e9 60 fd ff ff       	jmp    80100a58 <exec+0x6c>
    end_op();
80100cf8:	e8 d3 1c 00 00       	call   801029d0 <end_op>
    cprintf("exec: fail\n");
80100cfd:	83 ec 0c             	sub    $0xc,%esp
80100d00:	68 01 6b 10 80       	push   $0x80106b01
80100d05:	e8 12 f9 ff ff       	call   8010061c <cprintf>
    return -1;
80100d0a:	83 c4 10             	add    $0x10,%esp
80100d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d12:	e9 41 fd ff ff       	jmp    80100a58 <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d17:	be 00 20 00 00       	mov    $0x2000,%esi
80100d1c:	31 ff                	xor    %edi,%edi
80100d1e:	e9 47 fe ff ff       	jmp    80100b6a <exec+0x17e>
80100d23:	90                   	nop

80100d24 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d24:	55                   	push   %ebp
80100d25:	89 e5                	mov    %esp,%ebp
80100d27:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d2a:	68 0d 6b 10 80       	push   $0x80106b0d
80100d2f:	68 60 ef 10 80       	push   $0x8010ef60
80100d34:	e8 0b 31 00 00       	call   80103e44 <initlock>
}
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	c9                   	leave  
80100d3d:	c3                   	ret    
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 24             	sub    $0x24,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d46:	68 60 ef 10 80       	push   $0x8010ef60
80100d4b:	e8 ac 32 00 00       	call   80103ffc <acquire>
80100d50:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d53:	b8 94 ef 10 80       	mov    $0x8010ef94,%eax
80100d58:	eb 0c                	jmp    80100d66 <filealloc+0x26>
80100d5a:	66 90                	xchg   %ax,%ax
80100d5c:	83 c0 18             	add    $0x18,%eax
80100d5f:	3d f4 f8 10 80       	cmp    $0x8010f8f4,%eax
80100d64:	74 26                	je     80100d8c <filealloc+0x4c>
    if(f->ref == 0){
80100d66:	8b 50 04             	mov    0x4(%eax),%edx
80100d69:	85 d2                	test   %edx,%edx
80100d6b:	75 ef                	jne    80100d5c <filealloc+0x1c>
      f->ref = 1;
80100d6d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
80100d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
      release(&ftable.lock);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	68 60 ef 10 80       	push   $0x8010ef60
80100d7f:	e8 18 32 00 00       	call   80103f9c <release>
      return f;
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d8a:	c9                   	leave  
80100d8b:	c3                   	ret    
  release(&ftable.lock);
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	68 60 ef 10 80       	push   $0x8010ef60
80100d94:	e8 03 32 00 00       	call   80103f9c <release>
  return 0;
80100d99:	83 c4 10             	add    $0x10,%esp
80100d9c:	31 c0                	xor    %eax,%eax
}
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    

80100da0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
80100da4:	83 ec 10             	sub    $0x10,%esp
80100da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100daa:	68 60 ef 10 80       	push   $0x8010ef60
80100daf:	e8 48 32 00 00       	call   80103ffc <acquire>
  if(f->ref < 1)
80100db4:	8b 43 04             	mov    0x4(%ebx),%eax
80100db7:	83 c4 10             	add    $0x10,%esp
80100dba:	85 c0                	test   %eax,%eax
80100dbc:	7e 18                	jle    80100dd6 <filedup+0x36>
    panic("filedup");
  f->ref++;
80100dbe:	40                   	inc    %eax
80100dbf:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dc2:	83 ec 0c             	sub    $0xc,%esp
80100dc5:	68 60 ef 10 80       	push   $0x8010ef60
80100dca:	e8 cd 31 00 00       	call   80103f9c <release>
  return f;
}
80100dcf:	89 d8                	mov    %ebx,%eax
80100dd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd4:	c9                   	leave  
80100dd5:	c3                   	ret    
    panic("filedup");
80100dd6:	83 ec 0c             	sub    $0xc,%esp
80100dd9:	68 14 6b 10 80       	push   $0x80106b14
80100dde:	e8 55 f5 ff ff       	call   80100338 <panic>
80100de3:	90                   	nop

80100de4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	57                   	push   %edi
80100de8:	56                   	push   %esi
80100de9:	53                   	push   %ebx
80100dea:	83 ec 28             	sub    $0x28,%esp
80100ded:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100df0:	68 60 ef 10 80       	push   $0x8010ef60
80100df5:	e8 02 32 00 00       	call   80103ffc <acquire>
  if(f->ref < 1)
80100dfa:	8b 57 04             	mov    0x4(%edi),%edx
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	85 d2                	test   %edx,%edx
80100e02:	0f 8e 8d 00 00 00    	jle    80100e95 <fileclose+0xb1>
    panic("fileclose");
  if(--f->ref > 0){
80100e08:	4a                   	dec    %edx
80100e09:	89 57 04             	mov    %edx,0x4(%edi)
80100e0c:	75 3a                	jne    80100e48 <fileclose+0x64>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e0e:	8b 1f                	mov    (%edi),%ebx
80100e10:	8a 47 09             	mov    0x9(%edi),%al
80100e13:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e16:	8b 77 0c             	mov    0xc(%edi),%esi
80100e19:	8b 47 10             	mov    0x10(%edi),%eax
80100e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
80100e1f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100e25:	83 ec 0c             	sub    $0xc,%esp
80100e28:	68 60 ef 10 80       	push   $0x8010ef60
80100e2d:	e8 6a 31 00 00       	call   80103f9c <release>

  if(ff.type == FD_PIPE)
80100e32:	83 c4 10             	add    $0x10,%esp
80100e35:	83 fb 01             	cmp    $0x1,%ebx
80100e38:	74 42                	je     80100e7c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e3a:	83 fb 02             	cmp    $0x2,%ebx
80100e3d:	74 1d                	je     80100e5c <fileclose+0x78>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e42:	5b                   	pop    %ebx
80100e43:	5e                   	pop    %esi
80100e44:	5f                   	pop    %edi
80100e45:	5d                   	pop    %ebp
80100e46:	c3                   	ret    
80100e47:	90                   	nop
    release(&ftable.lock);
80100e48:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e52:	5b                   	pop    %ebx
80100e53:	5e                   	pop    %esi
80100e54:	5f                   	pop    %edi
80100e55:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e56:	e9 41 31 00 00       	jmp    80103f9c <release>
80100e5b:	90                   	nop
    begin_op();
80100e5c:	e8 07 1b 00 00       	call   80102968 <begin_op>
    iput(ff.ip);
80100e61:	83 ec 0c             	sub    $0xc,%esp
80100e64:	ff 75 e0             	push   -0x20(%ebp)
80100e67:	e8 60 08 00 00       	call   801016cc <iput>
    end_op();
80100e6c:	83 c4 10             	add    $0x10,%esp
}
80100e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e72:	5b                   	pop    %ebx
80100e73:	5e                   	pop    %esi
80100e74:	5f                   	pop    %edi
80100e75:	5d                   	pop    %ebp
    end_op();
80100e76:	e9 55 1b 00 00       	jmp    801029d0 <end_op>
80100e7b:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100e7c:	83 ec 08             	sub    $0x8,%esp
80100e7f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100e83:	50                   	push   %eax
80100e84:	56                   	push   %esi
80100e85:	e8 fa 21 00 00       	call   80103084 <pipeclose>
80100e8a:	83 c4 10             	add    $0x10,%esp
}
80100e8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e90:	5b                   	pop    %ebx
80100e91:	5e                   	pop    %esi
80100e92:	5f                   	pop    %edi
80100e93:	5d                   	pop    %ebp
80100e94:	c3                   	ret    
    panic("fileclose");
80100e95:	83 ec 0c             	sub    $0xc,%esp
80100e98:	68 1c 6b 10 80       	push   $0x80106b1c
80100e9d:	e8 96 f4 ff ff       	call   80100338 <panic>
80100ea2:	66 90                	xchg   %ax,%ax

80100ea4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ea4:	55                   	push   %ebp
80100ea5:	89 e5                	mov    %esp,%ebp
80100ea7:	53                   	push   %ebx
80100ea8:	53                   	push   %ebx
80100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eac:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eaf:	75 2b                	jne    80100edc <filestat+0x38>
    ilock(f->ip);
80100eb1:	83 ec 0c             	sub    $0xc,%esp
80100eb4:	ff 73 10             	push   0x10(%ebx)
80100eb7:	e8 04 07 00 00       	call   801015c0 <ilock>
    stati(f->ip, st);
80100ebc:	58                   	pop    %eax
80100ebd:	5a                   	pop    %edx
80100ebe:	ff 75 0c             	push   0xc(%ebp)
80100ec1:	ff 73 10             	push   0x10(%ebx)
80100ec4:	e8 97 09 00 00       	call   80101860 <stati>
    iunlock(f->ip);
80100ec9:	59                   	pop    %ecx
80100eca:	ff 73 10             	push   0x10(%ebx)
80100ecd:	e8 b6 07 00 00       	call   80101688 <iunlock>
    return 0;
80100ed2:	83 c4 10             	add    $0x10,%esp
80100ed5:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eda:	c9                   	leave  
80100edb:	c3                   	ret    
  return -1;
80100edc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ee1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee4:	c9                   	leave  
80100ee5:	c3                   	ret    
80100ee6:	66 90                	xchg   %ax,%ax

80100ee8 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ee8:	55                   	push   %ebp
80100ee9:	89 e5                	mov    %esp,%ebp
80100eeb:	57                   	push   %edi
80100eec:	56                   	push   %esi
80100eed:	53                   	push   %ebx
80100eee:	83 ec 1c             	sub    $0x1c,%esp
80100ef1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ef4:	8b 75 0c             	mov    0xc(%ebp),%esi
80100ef7:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100efa:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100efe:	74 60                	je     80100f60 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f00:	8b 03                	mov    (%ebx),%eax
80100f02:	83 f8 01             	cmp    $0x1,%eax
80100f05:	74 45                	je     80100f4c <fileread+0x64>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f07:	83 f8 02             	cmp    $0x2,%eax
80100f0a:	75 5b                	jne    80100f67 <fileread+0x7f>
    ilock(f->ip);
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	ff 73 10             	push   0x10(%ebx)
80100f12:	e8 a9 06 00 00       	call   801015c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f17:	57                   	push   %edi
80100f18:	ff 73 14             	push   0x14(%ebx)
80100f1b:	56                   	push   %esi
80100f1c:	ff 73 10             	push   0x10(%ebx)
80100f1f:	e8 68 09 00 00       	call   8010188c <readi>
80100f24:	83 c4 20             	add    $0x20,%esp
80100f27:	85 c0                	test   %eax,%eax
80100f29:	7e 03                	jle    80100f2e <fileread+0x46>
      f->off += r;
80100f2b:	01 43 14             	add    %eax,0x14(%ebx)
80100f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iunlock(f->ip);
80100f31:	83 ec 0c             	sub    $0xc,%esp
80100f34:	ff 73 10             	push   0x10(%ebx)
80100f37:	e8 4c 07 00 00       	call   80101688 <iunlock>
    return r;
80100f3c:	83 c4 10             	add    $0x10,%esp
80100f3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f45:	5b                   	pop    %ebx
80100f46:	5e                   	pop    %esi
80100f47:	5f                   	pop    %edi
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	66 90                	xchg   %ax,%ax
    return piperead(f->pipe, addr, n);
80100f4c:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f4f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f55:	5b                   	pop    %ebx
80100f56:	5e                   	pop    %esi
80100f57:	5f                   	pop    %edi
80100f58:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100f59:	e9 ae 22 00 00       	jmp    8010320c <piperead>
80100f5e:	66 90                	xchg   %ax,%ax
    return -1;
80100f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f65:	eb db                	jmp    80100f42 <fileread+0x5a>
  panic("fileread");
80100f67:	83 ec 0c             	sub    $0xc,%esp
80100f6a:	68 26 6b 10 80       	push   $0x80106b26
80100f6f:	e8 c4 f3 ff ff       	call   80100338 <panic>

80100f74 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f74:	55                   	push   %ebp
80100f75:	89 e5                	mov    %esp,%ebp
80100f77:	57                   	push   %edi
80100f78:	56                   	push   %esi
80100f79:	53                   	push   %ebx
80100f7a:	83 ec 1c             	sub    $0x1c,%esp
80100f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f80:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f83:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f86:	8b 45 10             	mov    0x10(%ebp),%eax
80100f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100f8c:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100f90:	0f 84 ae 00 00 00    	je     80101044 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100f96:	8b 03                	mov    (%ebx),%eax
80100f98:	83 f8 01             	cmp    $0x1,%eax
80100f9b:	0f 84 c2 00 00 00    	je     80101063 <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fa1:	83 f8 02             	cmp    $0x2,%eax
80100fa4:	0f 85 cb 00 00 00    	jne    80101075 <filewrite+0x101>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100faa:	31 ff                	xor    %edi,%edi
    while(i < n){
80100fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100faf:	85 c0                	test   %eax,%eax
80100fb1:	7f 2c                	jg     80100fdf <filewrite+0x6b>
80100fb3:	e9 9c 00 00 00       	jmp    80101054 <filewrite+0xe0>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100fb8:	01 43 14             	add    %eax,0x14(%ebx)
80100fbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
80100fc1:	ff 73 10             	push   0x10(%ebx)
80100fc4:	e8 bf 06 00 00       	call   80101688 <iunlock>
      end_op();
80100fc9:	e8 02 1a 00 00       	call   801029d0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80100fce:	83 c4 10             	add    $0x10,%esp
80100fd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100fd4:	39 c6                	cmp    %eax,%esi
80100fd6:	75 5f                	jne    80101037 <filewrite+0xc3>
        panic("short filewrite");
      i += r;
80100fd8:	01 f7                	add    %esi,%edi
    while(i < n){
80100fda:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80100fdd:	7e 75                	jle    80101054 <filewrite+0xe0>
      int n1 = n - i;
80100fdf:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100fe2:	29 fe                	sub    %edi,%esi
80100fe4:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80100fea:	7e 05                	jle    80100ff1 <filewrite+0x7d>
80100fec:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80100ff1:	e8 72 19 00 00       	call   80102968 <begin_op>
      ilock(f->ip);
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	ff 73 10             	push   0x10(%ebx)
80100ffc:	e8 bf 05 00 00       	call   801015c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101001:	56                   	push   %esi
80101002:	ff 73 14             	push   0x14(%ebx)
80101005:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101008:	01 f8                	add    %edi,%eax
8010100a:	50                   	push   %eax
8010100b:	ff 73 10             	push   0x10(%ebx)
8010100e:	e8 71 09 00 00       	call   80101984 <writei>
80101013:	83 c4 20             	add    $0x20,%esp
80101016:	85 c0                	test   %eax,%eax
80101018:	7f 9e                	jg     80100fb8 <filewrite+0x44>
8010101a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      iunlock(f->ip);
8010101d:	83 ec 0c             	sub    $0xc,%esp
80101020:	ff 73 10             	push   0x10(%ebx)
80101023:	e8 60 06 00 00       	call   80101688 <iunlock>
      end_op();
80101028:	e8 a3 19 00 00       	call   801029d0 <end_op>
      if(r < 0)
8010102d:	83 c4 10             	add    $0x10,%esp
80101030:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101033:	85 c0                	test   %eax,%eax
80101035:	75 0d                	jne    80101044 <filewrite+0xd0>
        panic("short filewrite");
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 2f 6b 10 80       	push   $0x80106b2f
8010103f:	e8 f4 f2 ff ff       	call   80100338 <panic>
    }
    return i == n ? n : -1;
80101044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101049:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104c:	5b                   	pop    %ebx
8010104d:	5e                   	pop    %esi
8010104e:	5f                   	pop    %edi
8010104f:	5d                   	pop    %ebp
80101050:	c3                   	ret    
80101051:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
80101054:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101057:	75 eb                	jne    80101044 <filewrite+0xd0>
80101059:	89 f8                	mov    %edi,%eax
}
8010105b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105e:	5b                   	pop    %ebx
8010105f:	5e                   	pop    %esi
80101060:	5f                   	pop    %edi
80101061:	5d                   	pop    %ebp
80101062:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101063:	8b 43 0c             	mov    0xc(%ebx),%eax
80101066:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106c:	5b                   	pop    %ebx
8010106d:	5e                   	pop    %esi
8010106e:	5f                   	pop    %edi
8010106f:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101070:	e9 a7 20 00 00       	jmp    8010311c <pipewrite>
  panic("filewrite");
80101075:	83 ec 0c             	sub    $0xc,%esp
80101078:	68 35 6b 10 80       	push   $0x80106b35
8010107d:	e8 b6 f2 ff ff       	call   80100338 <panic>
80101082:	66 90                	xchg   %ax,%ax

80101084 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101084:	55                   	push   %ebp
80101085:	89 e5                	mov    %esp,%ebp
80101087:	56                   	push   %esi
80101088:	53                   	push   %ebx
80101089:	89 c1                	mov    %eax,%ecx
8010108b:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
8010108d:	83 ec 08             	sub    $0x8,%esp
80101090:	89 d0                	mov    %edx,%eax
80101092:	c1 e8 0c             	shr    $0xc,%eax
80101095:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010109b:	50                   	push   %eax
8010109c:	51                   	push   %ecx
8010109d:	e8 12 f0 ff ff       	call   801000b4 <bread>
801010a2:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
801010a4:	89 d9                	mov    %ebx,%ecx
801010a6:	83 e1 07             	and    $0x7,%ecx
801010a9:	b8 01 00 00 00       	mov    $0x1,%eax
801010ae:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801010b0:	c1 fb 03             	sar    $0x3,%ebx
801010b3:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801010b9:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801010be:	83 c4 10             	add    $0x10,%esp
801010c1:	85 c1                	test   %eax,%ecx
801010c3:	74 23                	je     801010e8 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801010c5:	f7 d0                	not    %eax
801010c7:	21 c8                	and    %ecx,%eax
801010c9:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801010cd:	83 ec 0c             	sub    $0xc,%esp
801010d0:	56                   	push   %esi
801010d1:	e8 4e 1a 00 00       	call   80102b24 <log_write>
  brelse(bp);
801010d6:	89 34 24             	mov    %esi,(%esp)
801010d9:	e8 de f0 ff ff       	call   801001bc <brelse>
}
801010de:	83 c4 10             	add    $0x10,%esp
801010e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801010e4:	5b                   	pop    %ebx
801010e5:	5e                   	pop    %esi
801010e6:	5d                   	pop    %ebp
801010e7:	c3                   	ret    
    panic("freeing free block");
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	68 3f 6b 10 80       	push   $0x80106b3f
801010f0:	e8 43 f2 ff ff       	call   80100338 <panic>
801010f5:	8d 76 00             	lea    0x0(%esi),%esi

801010f8 <balloc>:
{
801010f8:	55                   	push   %ebp
801010f9:	89 e5                	mov    %esp,%ebp
801010fb:	57                   	push   %edi
801010fc:	56                   	push   %esi
801010fd:	53                   	push   %ebx
801010fe:	83 ec 1c             	sub    $0x1c,%esp
80101101:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101104:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
8010110a:	85 c9                	test   %ecx,%ecx
8010110c:	74 7e                	je     8010118c <balloc+0x94>
8010110e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101115:	83 ec 08             	sub    $0x8,%esp
80101118:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010111b:	89 f0                	mov    %esi,%eax
8010111d:	c1 f8 0c             	sar    $0xc,%eax
80101120:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101126:	50                   	push   %eax
80101127:	ff 75 d8             	push   -0x28(%ebp)
8010112a:	e8 85 ef ff ff       	call   801000b4 <bread>
8010112f:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101131:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101136:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101139:	83 c4 10             	add    $0x10,%esp
8010113c:	31 c0                	xor    %eax,%eax
8010113e:	eb 29                	jmp    80101169 <balloc+0x71>
      m = 1 << (bi % 8);
80101140:	89 c1                	mov    %eax,%ecx
80101142:	83 e1 07             	and    $0x7,%ecx
80101145:	bf 01 00 00 00       	mov    $0x1,%edi
8010114a:	d3 e7                	shl    %cl,%edi
8010114c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114f:	89 c1                	mov    %eax,%ecx
80101151:	c1 f9 03             	sar    $0x3,%ecx
80101154:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101159:	89 fa                	mov    %edi,%edx
8010115b:	85 7d e4             	test   %edi,-0x1c(%ebp)
8010115e:	74 3c                	je     8010119c <balloc+0xa4>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101160:	40                   	inc    %eax
80101161:	46                   	inc    %esi
80101162:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101167:	74 05                	je     8010116e <balloc+0x76>
80101169:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010116c:	77 d2                	ja     80101140 <balloc+0x48>
    brelse(bp);
8010116e:	83 ec 0c             	sub    $0xc,%esp
80101171:	53                   	push   %ebx
80101172:	e8 45 f0 ff ff       	call   801001bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101177:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
8010117e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101181:	83 c4 10             	add    $0x10,%esp
80101184:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010118a:	77 89                	ja     80101115 <balloc+0x1d>
  panic("balloc: out of blocks");
8010118c:	83 ec 0c             	sub    $0xc,%esp
8010118f:	68 52 6b 10 80       	push   $0x80106b52
80101194:	e8 9f f1 ff ff       	call   80100338 <panic>
80101199:	8d 76 00             	lea    0x0(%esi),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
8010119c:	0b 55 e4             	or     -0x1c(%ebp),%edx
8010119f:	88 54 0b 5c          	mov    %dl,0x5c(%ebx,%ecx,1)
        log_write(bp);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	53                   	push   %ebx
801011a7:	e8 78 19 00 00       	call   80102b24 <log_write>
        brelse(bp);
801011ac:	89 1c 24             	mov    %ebx,(%esp)
801011af:	e8 08 f0 ff ff       	call   801001bc <brelse>
  bp = bread(dev, bno);
801011b4:	58                   	pop    %eax
801011b5:	5a                   	pop    %edx
801011b6:	56                   	push   %esi
801011b7:	ff 75 d8             	push   -0x28(%ebp)
801011ba:	e8 f5 ee ff ff       	call   801000b4 <bread>
801011bf:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011c1:	83 c4 0c             	add    $0xc,%esp
801011c4:	68 00 02 00 00       	push   $0x200
801011c9:	6a 00                	push   $0x0
801011cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ce:	50                   	push   %eax
801011cf:	e8 d0 2e 00 00       	call   801040a4 <memset>
  log_write(bp);
801011d4:	89 1c 24             	mov    %ebx,(%esp)
801011d7:	e8 48 19 00 00       	call   80102b24 <log_write>
  brelse(bp);
801011dc:	89 1c 24             	mov    %ebx,(%esp)
801011df:	e8 d8 ef ff ff       	call   801001bc <brelse>
}
801011e4:	89 f0                	mov    %esi,%eax
801011e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011e9:	5b                   	pop    %ebx
801011ea:	5e                   	pop    %esi
801011eb:	5f                   	pop    %edi
801011ec:	5d                   	pop    %ebp
801011ed:	c3                   	ret    
801011ee:	66 90                	xchg   %ax,%ax

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	83 ec 28             	sub    $0x28,%esp
801011f9:	89 c7                	mov    %eax,%edi
801011fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011fe:	68 60 f9 10 80       	push   $0x8010f960
80101203:	e8 f4 2d 00 00       	call   80103ffc <acquire>
80101208:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
8010120b:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120d:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 13                	jmp    8010122a <iget+0x3a>
80101217:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101218:	39 3b                	cmp    %edi,(%ebx)
8010121a:	74 64                	je     80101280 <iget+0x90>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101222:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101228:	73 22                	jae    8010124c <iget+0x5c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010122a:	8b 43 08             	mov    0x8(%ebx),%eax
8010122d:	85 c0                	test   %eax,%eax
8010122f:	7f e7                	jg     80101218 <iget+0x28>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101231:	85 f6                	test   %esi,%esi
80101233:	75 e7                	jne    8010121c <iget+0x2c>
80101235:	85 c0                	test   %eax,%eax
80101237:	75 6c                	jne    801012a5 <iget+0xb5>
80101239:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123b:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101241:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101247:	72 e1                	jb     8010122a <iget+0x3a>
80101249:	8d 76 00             	lea    0x0(%esi),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010124c:	85 f6                	test   %esi,%esi
8010124e:	74 73                	je     801012c3 <iget+0xd3>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101250:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101252:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101255:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010125c:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101263:	83 ec 0c             	sub    $0xc,%esp
80101266:	68 60 f9 10 80       	push   $0x8010f960
8010126b:	e8 2c 2d 00 00       	call   80103f9c <release>

  return ip;
80101270:	83 c4 10             	add    $0x10,%esp
}
80101273:	89 f0                	mov    %esi,%eax
80101275:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101278:	5b                   	pop    %ebx
80101279:	5e                   	pop    %esi
8010127a:	5f                   	pop    %edi
8010127b:	5d                   	pop    %ebp
8010127c:	c3                   	ret    
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101280:	39 53 04             	cmp    %edx,0x4(%ebx)
80101283:	75 97                	jne    8010121c <iget+0x2c>
      ip->ref++;
80101285:	40                   	inc    %eax
80101286:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	68 60 f9 10 80       	push   $0x8010f960
80101291:	e8 06 2d 00 00       	call   80103f9c <release>
      return ip;
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	89 de                	mov    %ebx,%esi
}
8010129b:	89 f0                	mov    %esi,%eax
8010129d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a0:	5b                   	pop    %ebx
801012a1:	5e                   	pop    %esi
801012a2:	5f                   	pop    %edi
801012a3:	5d                   	pop    %ebp
801012a4:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012a5:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ab:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801012b1:	73 10                	jae    801012c3 <iget+0xd3>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b3:	8b 43 08             	mov    0x8(%ebx),%eax
801012b6:	85 c0                	test   %eax,%eax
801012b8:	0f 8f 5a ff ff ff    	jg     80101218 <iget+0x28>
801012be:	e9 72 ff ff ff       	jmp    80101235 <iget+0x45>
    panic("iget: no inodes");
801012c3:	83 ec 0c             	sub    $0xc,%esp
801012c6:	68 68 6b 10 80       	push   $0x80106b68
801012cb:	e8 68 f0 ff ff       	call   80100338 <panic>

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	83 ec 1c             	sub    $0x1c,%esp
801012d9:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	76 7c                	jbe    8010135c <bmap+0x8c>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e0:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012e3:	83 fb 7f             	cmp    $0x7f,%ebx
801012e6:	0f 87 8e 00 00 00    	ja     8010137a <bmap+0xaa>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012ec:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012f2:	85 c0                	test   %eax,%eax
801012f4:	74 56                	je     8010134c <bmap+0x7c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012f6:	83 ec 08             	sub    $0x8,%esp
801012f9:	50                   	push   %eax
801012fa:	ff 36                	push   (%esi)
801012fc:	e8 b3 ed ff ff       	call   801000b4 <bread>
80101301:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101303:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
80101307:	8b 03                	mov    (%ebx),%eax
80101309:	83 c4 10             	add    $0x10,%esp
8010130c:	85 c0                	test   %eax,%eax
8010130e:	74 1c                	je     8010132c <bmap+0x5c>
80101310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
80101316:	57                   	push   %edi
80101317:	e8 a0 ee ff ff       	call   801001bc <brelse>
8010131c:	83 c4 10             	add    $0x10,%esp
8010131f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101322:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101325:	5b                   	pop    %ebx
80101326:	5e                   	pop    %esi
80101327:	5f                   	pop    %edi
80101328:	5d                   	pop    %ebp
80101329:	c3                   	ret    
8010132a:	66 90                	xchg   %ax,%ax
      a[bn] = addr = balloc(ip->dev);
8010132c:	8b 06                	mov    (%esi),%eax
8010132e:	e8 c5 fd ff ff       	call   801010f8 <balloc>
80101333:	89 03                	mov    %eax,(%ebx)
80101335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      log_write(bp);
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	57                   	push   %edi
8010133c:	e8 e3 17 00 00       	call   80102b24 <log_write>
80101341:	83 c4 10             	add    $0x10,%esp
80101344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101347:	eb c7                	jmp    80101310 <bmap+0x40>
80101349:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010134c:	8b 06                	mov    (%esi),%eax
8010134e:	e8 a5 fd ff ff       	call   801010f8 <balloc>
80101353:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101359:	eb 9b                	jmp    801012f6 <bmap+0x26>
8010135b:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
8010135c:	8d 5a 14             	lea    0x14(%edx),%ebx
8010135f:	8b 44 98 0c          	mov    0xc(%eax,%ebx,4),%eax
80101363:	85 c0                	test   %eax,%eax
80101365:	75 bb                	jne    80101322 <bmap+0x52>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101367:	8b 06                	mov    (%esi),%eax
80101369:	e8 8a fd ff ff       	call   801010f8 <balloc>
8010136e:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	5b                   	pop    %ebx
80101376:	5e                   	pop    %esi
80101377:	5f                   	pop    %edi
80101378:	5d                   	pop    %ebp
80101379:	c3                   	ret    
  panic("bmap: out of range");
8010137a:	83 ec 0c             	sub    $0xc,%esp
8010137d:	68 78 6b 10 80       	push   $0x80106b78
80101382:	e8 b1 ef ff ff       	call   80100338 <panic>
80101387:	90                   	nop

80101388 <readsb>:
{
80101388:	55                   	push   %ebp
80101389:	89 e5                	mov    %esp,%ebp
8010138b:	56                   	push   %esi
8010138c:	53                   	push   %ebx
8010138d:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101390:	83 ec 08             	sub    $0x8,%esp
80101393:	6a 01                	push   $0x1
80101395:	ff 75 08             	push   0x8(%ebp)
80101398:	e8 17 ed ff ff       	call   801000b4 <bread>
8010139d:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010139f:	83 c4 0c             	add    $0xc,%esp
801013a2:	6a 1c                	push   $0x1c
801013a4:	8d 40 5c             	lea    0x5c(%eax),%eax
801013a7:	50                   	push   %eax
801013a8:	56                   	push   %esi
801013a9:	e8 7a 2d 00 00       	call   80104128 <memmove>
  brelse(bp);
801013ae:	83 c4 10             	add    $0x10,%esp
801013b1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013b7:	5b                   	pop    %ebx
801013b8:	5e                   	pop    %esi
801013b9:	5d                   	pop    %ebp
  brelse(bp);
801013ba:	e9 fd ed ff ff       	jmp    801001bc <brelse>
801013bf:	90                   	nop

801013c0 <iinit>:
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	53                   	push   %ebx
801013c4:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801013c7:	68 8b 6b 10 80       	push   $0x80106b8b
801013cc:	68 60 f9 10 80       	push   $0x8010f960
801013d1:	e8 6e 2a 00 00       	call   80103e44 <initlock>
  for(i = 0; i < NINODE; i++) {
801013d6:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801013db:	83 c4 10             	add    $0x10,%esp
801013de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	68 92 6b 10 80       	push   $0x80106b92
801013e8:	53                   	push   %ebx
801013e9:	e8 46 29 00 00       	call   80103d34 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801013ee:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f4:	83 c4 10             	add    $0x10,%esp
801013f7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801013fd:	75 e1                	jne    801013e0 <iinit+0x20>
  bp = bread(dev, 1);
801013ff:	83 ec 08             	sub    $0x8,%esp
80101402:	6a 01                	push   $0x1
80101404:	ff 75 08             	push   0x8(%ebp)
80101407:	e8 a8 ec ff ff       	call   801000b4 <bread>
8010140c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010140e:	83 c4 0c             	add    $0xc,%esp
80101411:	6a 1c                	push   $0x1c
80101413:	8d 40 5c             	lea    0x5c(%eax),%eax
80101416:	50                   	push   %eax
80101417:	68 b4 15 11 80       	push   $0x801115b4
8010141c:	e8 07 2d 00 00       	call   80104128 <memmove>
  brelse(bp);
80101421:	89 1c 24             	mov    %ebx,(%esp)
80101424:	e8 93 ed ff ff       	call   801001bc <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101429:	ff 35 cc 15 11 80    	push   0x801115cc
8010142f:	ff 35 c8 15 11 80    	push   0x801115c8
80101435:	ff 35 c4 15 11 80    	push   0x801115c4
8010143b:	ff 35 c0 15 11 80    	push   0x801115c0
80101441:	ff 35 bc 15 11 80    	push   0x801115bc
80101447:	ff 35 b8 15 11 80    	push   0x801115b8
8010144d:	ff 35 b4 15 11 80    	push   0x801115b4
80101453:	68 f8 6b 10 80       	push   $0x80106bf8
80101458:	e8 bf f1 ff ff       	call   8010061c <cprintf>
}
8010145d:	83 c4 30             	add    $0x30,%esp
80101460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101463:	c9                   	leave  
80101464:	c3                   	ret    
80101465:	8d 76 00             	lea    0x0(%esi),%esi

80101468 <ialloc>:
{
80101468:	55                   	push   %ebp
80101469:	89 e5                	mov    %esp,%ebp
8010146b:	57                   	push   %edi
8010146c:	56                   	push   %esi
8010146d:	53                   	push   %ebx
8010146e:	83 ec 1c             	sub    $0x1c,%esp
80101471:	8b 75 08             	mov    0x8(%ebp),%esi
80101474:	8b 45 0c             	mov    0xc(%ebp),%eax
80101477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010147a:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
80101481:	0f 86 84 00 00 00    	jbe    8010150b <ialloc+0xa3>
80101487:	bf 01 00 00 00       	mov    $0x1,%edi
8010148c:	eb 17                	jmp    801014a5 <ialloc+0x3d>
8010148e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101490:	83 ec 0c             	sub    $0xc,%esp
80101493:	53                   	push   %ebx
80101494:	e8 23 ed ff ff       	call   801001bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101499:	47                   	inc    %edi
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801014a3:	73 66                	jae    8010150b <ialloc+0xa3>
    bp = bread(dev, IBLOCK(inum, sb));
801014a5:	83 ec 08             	sub    $0x8,%esp
801014a8:	89 f8                	mov    %edi,%eax
801014aa:	c1 e8 03             	shr    $0x3,%eax
801014ad:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801014b3:	50                   	push   %eax
801014b4:	56                   	push   %esi
801014b5:	e8 fa eb ff ff       	call   801000b4 <bread>
801014ba:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801014bc:	89 f8                	mov    %edi,%eax
801014be:	83 e0 07             	and    $0x7,%eax
801014c1:	c1 e0 06             	shl    $0x6,%eax
801014c4:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801014c8:	83 c4 10             	add    $0x10,%esp
801014cb:	66 83 39 00          	cmpw   $0x0,(%ecx)
801014cf:	75 bf                	jne    80101490 <ialloc+0x28>
      memset(dip, 0, sizeof(*dip));
801014d1:	50                   	push   %eax
801014d2:	6a 40                	push   $0x40
801014d4:	6a 00                	push   $0x0
801014d6:	51                   	push   %ecx
801014d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801014da:	e8 c5 2b 00 00       	call   801040a4 <memset>
      dip->type = type;
801014df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801014e5:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801014e8:	89 1c 24             	mov    %ebx,(%esp)
801014eb:	e8 34 16 00 00       	call   80102b24 <log_write>
      brelse(bp);
801014f0:	89 1c 24             	mov    %ebx,(%esp)
801014f3:	e8 c4 ec ff ff       	call   801001bc <brelse>
      return iget(dev, inum);
801014f8:	83 c4 10             	add    $0x10,%esp
801014fb:	89 fa                	mov    %edi,%edx
801014fd:	89 f0                	mov    %esi,%eax
}
801014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101502:	5b                   	pop    %ebx
80101503:	5e                   	pop    %esi
80101504:	5f                   	pop    %edi
80101505:	5d                   	pop    %ebp
      return iget(dev, inum);
80101506:	e9 e5 fc ff ff       	jmp    801011f0 <iget>
  panic("ialloc: no inodes");
8010150b:	83 ec 0c             	sub    $0xc,%esp
8010150e:	68 98 6b 10 80       	push   $0x80106b98
80101513:	e8 20 ee ff ff       	call   80100338 <panic>

80101518 <iupdate>:
{
80101518:	55                   	push   %ebp
80101519:	89 e5                	mov    %esp,%ebp
8010151b:	56                   	push   %esi
8010151c:	53                   	push   %ebx
8010151d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101520:	83 ec 08             	sub    $0x8,%esp
80101523:	8b 43 04             	mov    0x4(%ebx),%eax
80101526:	c1 e8 03             	shr    $0x3,%eax
80101529:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010152f:	50                   	push   %eax
80101530:	ff 33                	push   (%ebx)
80101532:	e8 7d eb ff ff       	call   801000b4 <bread>
80101537:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101539:	8b 43 04             	mov    0x4(%ebx),%eax
8010153c:	83 e0 07             	and    $0x7,%eax
8010153f:	c1 e0 06             	shl    $0x6,%eax
80101542:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101546:	8b 53 50             	mov    0x50(%ebx),%edx
80101549:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010154c:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101550:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101554:	8b 53 54             	mov    0x54(%ebx),%edx
80101557:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010155b:	66 8b 53 56          	mov    0x56(%ebx),%dx
8010155f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101563:	8b 53 58             	mov    0x58(%ebx),%edx
80101566:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101569:	83 c4 0c             	add    $0xc,%esp
8010156c:	6a 34                	push   $0x34
8010156e:	83 c3 5c             	add    $0x5c,%ebx
80101571:	53                   	push   %ebx
80101572:	83 c0 0c             	add    $0xc,%eax
80101575:	50                   	push   %eax
80101576:	e8 ad 2b 00 00       	call   80104128 <memmove>
  log_write(bp);
8010157b:	89 34 24             	mov    %esi,(%esp)
8010157e:	e8 a1 15 00 00       	call   80102b24 <log_write>
  brelse(bp);
80101583:	83 c4 10             	add    $0x10,%esp
80101586:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101589:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010158c:	5b                   	pop    %ebx
8010158d:	5e                   	pop    %esi
8010158e:	5d                   	pop    %ebp
  brelse(bp);
8010158f:	e9 28 ec ff ff       	jmp    801001bc <brelse>

80101594 <idup>:
{
80101594:	55                   	push   %ebp
80101595:	89 e5                	mov    %esp,%ebp
80101597:	53                   	push   %ebx
80101598:	83 ec 10             	sub    $0x10,%esp
8010159b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010159e:	68 60 f9 10 80       	push   $0x8010f960
801015a3:	e8 54 2a 00 00       	call   80103ffc <acquire>
  ip->ref++;
801015a8:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
801015ab:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801015b2:	e8 e5 29 00 00       	call   80103f9c <release>
}
801015b7:	89 d8                	mov    %ebx,%eax
801015b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015bc:	c9                   	leave  
801015bd:	c3                   	ret    
801015be:	66 90                	xchg   %ax,%ax

801015c0 <ilock>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015c8:	85 db                	test   %ebx,%ebx
801015ca:	0f 84 a9 00 00 00    	je     80101679 <ilock+0xb9>
801015d0:	8b 53 08             	mov    0x8(%ebx),%edx
801015d3:	85 d2                	test   %edx,%edx
801015d5:	0f 8e 9e 00 00 00    	jle    80101679 <ilock+0xb9>
  acquiresleep(&ip->lock);
801015db:	83 ec 0c             	sub    $0xc,%esp
801015de:	8d 43 0c             	lea    0xc(%ebx),%eax
801015e1:	50                   	push   %eax
801015e2:	e8 81 27 00 00       	call   80103d68 <acquiresleep>
  if(ip->valid == 0){
801015e7:	83 c4 10             	add    $0x10,%esp
801015ea:	8b 43 4c             	mov    0x4c(%ebx),%eax
801015ed:	85 c0                	test   %eax,%eax
801015ef:	74 07                	je     801015f8 <ilock+0x38>
}
801015f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f4:	5b                   	pop    %ebx
801015f5:	5e                   	pop    %esi
801015f6:	5d                   	pop    %ebp
801015f7:	c3                   	ret    
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
801015fe:	c1 e8 03             	shr    $0x3,%eax
80101601:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101607:	50                   	push   %eax
80101608:	ff 33                	push   (%ebx)
8010160a:	e8 a5 ea ff ff       	call   801000b4 <bread>
8010160f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101611:	8b 43 04             	mov    0x4(%ebx),%eax
80101614:	83 e0 07             	and    $0x7,%eax
80101617:	c1 e0 06             	shl    $0x6,%eax
8010161a:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010161e:	8b 10                	mov    (%eax),%edx
80101620:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101624:	66 8b 50 02          	mov    0x2(%eax),%dx
80101628:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010162c:	8b 50 04             	mov    0x4(%eax),%edx
8010162f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101633:	66 8b 50 06          	mov    0x6(%eax),%dx
80101637:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010163b:	8b 50 08             	mov    0x8(%eax),%edx
8010163e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101641:	83 c4 0c             	add    $0xc,%esp
80101644:	6a 34                	push   $0x34
80101646:	83 c0 0c             	add    $0xc,%eax
80101649:	50                   	push   %eax
8010164a:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010164d:	50                   	push   %eax
8010164e:	e8 d5 2a 00 00       	call   80104128 <memmove>
    brelse(bp);
80101653:	89 34 24             	mov    %esi,(%esp)
80101656:	e8 61 eb ff ff       	call   801001bc <brelse>
    ip->valid = 1;
8010165b:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101662:	83 c4 10             	add    $0x10,%esp
80101665:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010166a:	75 85                	jne    801015f1 <ilock+0x31>
      panic("ilock: no type");
8010166c:	83 ec 0c             	sub    $0xc,%esp
8010166f:	68 b0 6b 10 80       	push   $0x80106bb0
80101674:	e8 bf ec ff ff       	call   80100338 <panic>
    panic("ilock");
80101679:	83 ec 0c             	sub    $0xc,%esp
8010167c:	68 aa 6b 10 80       	push   $0x80106baa
80101681:	e8 b2 ec ff ff       	call   80100338 <panic>
80101686:	66 90                	xchg   %ax,%ax

80101688 <iunlock>:
{
80101688:	55                   	push   %ebp
80101689:	89 e5                	mov    %esp,%ebp
8010168b:	56                   	push   %esi
8010168c:	53                   	push   %ebx
8010168d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101690:	85 db                	test   %ebx,%ebx
80101692:	74 28                	je     801016bc <iunlock+0x34>
80101694:	8d 73 0c             	lea    0xc(%ebx),%esi
80101697:	83 ec 0c             	sub    $0xc,%esp
8010169a:	56                   	push   %esi
8010169b:	e8 58 27 00 00       	call   80103df8 <holdingsleep>
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	85 c0                	test   %eax,%eax
801016a5:	74 15                	je     801016bc <iunlock+0x34>
801016a7:	8b 43 08             	mov    0x8(%ebx),%eax
801016aa:	85 c0                	test   %eax,%eax
801016ac:	7e 0e                	jle    801016bc <iunlock+0x34>
  releasesleep(&ip->lock);
801016ae:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801016b7:	e9 00 27 00 00       	jmp    80103dbc <releasesleep>
    panic("iunlock");
801016bc:	83 ec 0c             	sub    $0xc,%esp
801016bf:	68 bf 6b 10 80       	push   $0x80106bbf
801016c4:	e8 6f ec ff ff       	call   80100338 <panic>
801016c9:	8d 76 00             	lea    0x0(%esi),%esi

801016cc <iput>:
{
801016cc:	55                   	push   %ebp
801016cd:	89 e5                	mov    %esp,%ebp
801016cf:	57                   	push   %edi
801016d0:	56                   	push   %esi
801016d1:	53                   	push   %ebx
801016d2:	83 ec 28             	sub    $0x28,%esp
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016d8:	8d 73 0c             	lea    0xc(%ebx),%esi
801016db:	56                   	push   %esi
801016dc:	e8 87 26 00 00       	call   80103d68 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016e1:	83 c4 10             	add    $0x10,%esp
801016e4:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016e7:	85 c0                	test   %eax,%eax
801016e9:	74 07                	je     801016f2 <iput+0x26>
801016eb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016f0:	74 2e                	je     80101720 <iput+0x54>
  releasesleep(&ip->lock);
801016f2:	83 ec 0c             	sub    $0xc,%esp
801016f5:	56                   	push   %esi
801016f6:	e8 c1 26 00 00       	call   80103dbc <releasesleep>
  acquire(&icache.lock);
801016fb:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101702:	e8 f5 28 00 00       	call   80103ffc <acquire>
  ip->ref--;
80101707:	ff 4b 08             	decl   0x8(%ebx)
  release(&icache.lock);
8010170a:	83 c4 10             	add    $0x10,%esp
8010170d:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101717:	5b                   	pop    %ebx
80101718:	5e                   	pop    %esi
80101719:	5f                   	pop    %edi
8010171a:	5d                   	pop    %ebp
  release(&icache.lock);
8010171b:	e9 7c 28 00 00       	jmp    80103f9c <release>
    acquire(&icache.lock);
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	68 60 f9 10 80       	push   $0x8010f960
80101728:	e8 cf 28 00 00       	call   80103ffc <acquire>
    int r = ip->ref;
8010172d:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101730:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101737:	e8 60 28 00 00       	call   80103f9c <release>
    if(r == 1){
8010173c:	83 c4 10             	add    $0x10,%esp
8010173f:	4f                   	dec    %edi
80101740:	75 b0                	jne    801016f2 <iput+0x26>
80101742:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80101745:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
8010174b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8010174e:	89 fe                	mov    %edi,%esi
80101750:	89 c7                	mov    %eax,%edi
80101752:	eb 07                	jmp    8010175b <iput+0x8f>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101754:	83 c6 04             	add    $0x4,%esi
80101757:	39 fe                	cmp    %edi,%esi
80101759:	74 15                	je     80101770 <iput+0xa4>
    if(ip->addrs[i]){
8010175b:	8b 16                	mov    (%esi),%edx
8010175d:	85 d2                	test   %edx,%edx
8010175f:	74 f3                	je     80101754 <iput+0x88>
      bfree(ip->dev, ip->addrs[i]);
80101761:	8b 03                	mov    (%ebx),%eax
80101763:	e8 1c f9 ff ff       	call   80101084 <bfree>
      ip->addrs[i] = 0;
80101768:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010176e:	eb e4                	jmp    80101754 <iput+0x88>
    }
  }

  if(ip->addrs[NDIRECT]){
80101770:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101773:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101779:	85 c0                	test   %eax,%eax
8010177b:	75 2d                	jne    801017aa <iput+0xde>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010177d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	53                   	push   %ebx
80101788:	e8 8b fd ff ff       	call   80101518 <iupdate>
      ip->type = 0;
8010178d:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101793:	89 1c 24             	mov    %ebx,(%esp)
80101796:	e8 7d fd ff ff       	call   80101518 <iupdate>
      ip->valid = 0;
8010179b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801017a2:	83 c4 10             	add    $0x10,%esp
801017a5:	e9 48 ff ff ff       	jmp    801016f2 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801017aa:	83 ec 08             	sub    $0x8,%esp
801017ad:	50                   	push   %eax
801017ae:	ff 33                	push   (%ebx)
801017b0:	e8 ff e8 ff ff       	call   801000b4 <bread>
801017b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801017b8:	8d 78 5c             	lea    0x5c(%eax),%edi
801017bb:	05 5c 02 00 00       	add    $0x25c,%eax
801017c0:	83 c4 10             	add    $0x10,%esp
801017c3:	89 75 e0             	mov    %esi,-0x20(%ebp)
801017c6:	89 fe                	mov    %edi,%esi
801017c8:	89 c7                	mov    %eax,%edi
801017ca:	eb 07                	jmp    801017d3 <iput+0x107>
801017cc:	83 c6 04             	add    $0x4,%esi
801017cf:	39 f7                	cmp    %esi,%edi
801017d1:	74 0f                	je     801017e2 <iput+0x116>
      if(a[j])
801017d3:	8b 16                	mov    (%esi),%edx
801017d5:	85 d2                	test   %edx,%edx
801017d7:	74 f3                	je     801017cc <iput+0x100>
        bfree(ip->dev, a[j]);
801017d9:	8b 03                	mov    (%ebx),%eax
801017db:	e8 a4 f8 ff ff       	call   80101084 <bfree>
801017e0:	eb ea                	jmp    801017cc <iput+0x100>
    brelse(bp);
801017e2:	8b 75 e0             	mov    -0x20(%ebp),%esi
801017e5:	83 ec 0c             	sub    $0xc,%esp
801017e8:	ff 75 e4             	push   -0x1c(%ebp)
801017eb:	e8 cc e9 ff ff       	call   801001bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801017f0:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801017f6:	8b 03                	mov    (%ebx),%eax
801017f8:	e8 87 f8 ff ff       	call   80101084 <bfree>
    ip->addrs[NDIRECT] = 0;
801017fd:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101804:	00 00 00 
80101807:	83 c4 10             	add    $0x10,%esp
8010180a:	e9 6e ff ff ff       	jmp    8010177d <iput+0xb1>
8010180f:	90                   	nop

80101810 <iunlockput>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	74 34                	je     80101850 <iunlockput+0x40>
8010181c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	56                   	push   %esi
80101823:	e8 d0 25 00 00       	call   80103df8 <holdingsleep>
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 c0                	test   %eax,%eax
8010182d:	74 21                	je     80101850 <iunlockput+0x40>
8010182f:	8b 43 08             	mov    0x8(%ebx),%eax
80101832:	85 c0                	test   %eax,%eax
80101834:	7e 1a                	jle    80101850 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101836:	83 ec 0c             	sub    $0xc,%esp
80101839:	56                   	push   %esi
8010183a:	e8 7d 25 00 00       	call   80103dbc <releasesleep>
  iput(ip);
8010183f:	83 c4 10             	add    $0x10,%esp
80101842:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101845:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101848:	5b                   	pop    %ebx
80101849:	5e                   	pop    %esi
8010184a:	5d                   	pop    %ebp
  iput(ip);
8010184b:	e9 7c fe ff ff       	jmp    801016cc <iput>
    panic("iunlock");
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	68 bf 6b 10 80       	push   $0x80106bbf
80101858:	e8 db ea ff ff       	call   80100338 <panic>
8010185d:	8d 76 00             	lea    0x0(%esi),%esi

80101860 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	8b 55 08             	mov    0x8(%ebp),%edx
80101866:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101869:	8b 0a                	mov    (%edx),%ecx
8010186b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010186e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101871:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101874:	8b 4a 50             	mov    0x50(%edx),%ecx
80101877:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010187a:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010187e:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101882:	8b 52 58             	mov    0x58(%edx),%edx
80101885:	89 50 10             	mov    %edx,0x10(%eax)
}
80101888:	5d                   	pop    %ebp
80101889:	c3                   	ret    
8010188a:	66 90                	xchg   %ax,%ax

8010188c <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010188c:	55                   	push   %ebp
8010188d:	89 e5                	mov    %esp,%ebp
8010188f:	57                   	push   %edi
80101890:	56                   	push   %esi
80101891:	53                   	push   %ebx
80101892:	83 ec 1c             	sub    $0x1c,%esp
80101895:	8b 7d 08             	mov    0x8(%ebp),%edi
80101898:	8b 45 0c             	mov    0xc(%ebp),%eax
8010189b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010189e:	8b 45 10             	mov    0x10(%ebp),%eax
801018a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801018a4:	8b 45 14             	mov    0x14(%ebp),%eax
801018a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801018aa:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
801018af:	0f 84 a3 00 00 00    	je     80101958 <readi+0xcc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801018b5:	8b 47 58             	mov    0x58(%edi),%eax
801018b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801018bb:	39 c3                	cmp    %eax,%ebx
801018bd:	0f 87 b9 00 00 00    	ja     8010197c <readi+0xf0>
801018c3:	89 da                	mov    %ebx,%edx
801018c5:	31 c9                	xor    %ecx,%ecx
801018c7:	03 55 e4             	add    -0x1c(%ebp),%edx
801018ca:	0f 92 c1             	setb   %cl
801018cd:	89 ce                	mov    %ecx,%esi
801018cf:	0f 82 a7 00 00 00    	jb     8010197c <readi+0xf0>
    return -1;
  if(off + n > ip->size)
801018d5:	39 d0                	cmp    %edx,%eax
801018d7:	72 77                	jb     80101950 <readi+0xc4>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018d9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801018dc:	85 db                	test   %ebx,%ebx
801018de:	74 65                	je     80101945 <readi+0xb9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801018e3:	89 da                	mov    %ebx,%edx
801018e5:	c1 ea 09             	shr    $0x9,%edx
801018e8:	89 f8                	mov    %edi,%eax
801018ea:	e8 e1 f9 ff ff       	call   801012d0 <bmap>
801018ef:	83 ec 08             	sub    $0x8,%esp
801018f2:	50                   	push   %eax
801018f3:	ff 37                	push   (%edi)
801018f5:	e8 ba e7 ff ff       	call   801000b4 <bread>
801018fa:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801018fc:	89 d8                	mov    %ebx,%eax
801018fe:	25 ff 01 00 00       	and    $0x1ff,%eax
80101903:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101906:	29 f1                	sub    %esi,%ecx
80101908:	bb 00 02 00 00       	mov    $0x200,%ebx
8010190d:	29 c3                	sub    %eax,%ebx
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	39 cb                	cmp    %ecx,%ebx
80101914:	76 02                	jbe    80101918 <readi+0x8c>
80101916:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101918:	51                   	push   %ecx
80101919:	53                   	push   %ebx
8010191a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
8010191e:	89 55 d8             	mov    %edx,-0x28(%ebp)
80101921:	50                   	push   %eax
80101922:	ff 75 dc             	push   -0x24(%ebp)
80101925:	e8 fe 27 00 00       	call   80104128 <memmove>
    brelse(bp);
8010192a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010192d:	89 14 24             	mov    %edx,(%esp)
80101930:	e8 87 e8 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101935:	01 de                	add    %ebx,%esi
80101937:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010193a:	01 5d dc             	add    %ebx,-0x24(%ebp)
8010193d:	83 c4 10             	add    $0x10,%esp
80101940:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101943:	77 9b                	ja     801018e0 <readi+0x54>
  }
  return n;
80101945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101948:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010194b:	5b                   	pop    %ebx
8010194c:	5e                   	pop    %esi
8010194d:	5f                   	pop    %edi
8010194e:	5d                   	pop    %ebp
8010194f:	c3                   	ret    
    n = ip->size - off;
80101950:	29 d8                	sub    %ebx,%eax
80101952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101955:	eb 82                	jmp    801018d9 <readi+0x4d>
80101957:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101958:	0f bf 47 52          	movswl 0x52(%edi),%eax
8010195c:	66 83 f8 09          	cmp    $0x9,%ax
80101960:	77 1a                	ja     8010197c <readi+0xf0>
80101962:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101969:	85 c0                	test   %eax,%eax
8010196b:	74 0f                	je     8010197c <readi+0xf0>
    return devsw[ip->major].read(ip, dst, n);
8010196d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101970:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101973:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101976:	5b                   	pop    %ebx
80101977:	5e                   	pop    %esi
80101978:	5f                   	pop    %edi
80101979:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010197a:	ff e0                	jmp    *%eax
      return -1;
8010197c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101981:	eb c5                	jmp    80101948 <readi+0xbc>
80101983:	90                   	nop

80101984 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101984:	55                   	push   %ebp
80101985:	89 e5                	mov    %esp,%ebp
80101987:	57                   	push   %edi
80101988:	56                   	push   %esi
80101989:	53                   	push   %ebx
8010198a:	83 ec 1c             	sub    $0x1c,%esp
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101993:	8b 75 0c             	mov    0xc(%ebp),%esi
80101996:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101999:	8b 75 10             	mov    0x10(%ebp),%esi
8010199c:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010199f:	8b 75 14             	mov    0x14(%ebp),%esi
801019a2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a5:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801019aa:	0f 84 b0 00 00 00    	je     80101a60 <writei+0xdc>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801019b0:	8b 75 d8             	mov    -0x28(%ebp),%esi
801019b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019b6:	3b 46 58             	cmp    0x58(%esi),%eax
801019b9:	0f 87 dc 00 00 00    	ja     80101a9b <writei+0x117>
801019bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019c2:	31 c9                	xor    %ecx,%ecx
801019c4:	01 d0                	add    %edx,%eax
801019c6:	0f 92 c1             	setb   %cl
801019c9:	89 ce                	mov    %ecx,%esi
801019cb:	0f 82 ca 00 00 00    	jb     80101a9b <writei+0x117>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801019d1:	3d 00 18 01 00       	cmp    $0x11800,%eax
801019d6:	0f 87 bf 00 00 00    	ja     80101a9b <writei+0x117>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019dc:	85 d2                	test   %edx,%edx
801019de:	74 75                	je     80101a55 <writei+0xd1>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801019e3:	89 da                	mov    %ebx,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	8b 7d d8             	mov    -0x28(%ebp),%edi
801019eb:	89 f8                	mov    %edi,%eax
801019ed:	e8 de f8 ff ff       	call   801012d0 <bmap>
801019f2:	83 ec 08             	sub    $0x8,%esp
801019f5:	50                   	push   %eax
801019f6:	ff 37                	push   (%edi)
801019f8:	e8 b7 e6 ff ff       	call   801000b4 <bread>
801019fd:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801019ff:	89 d8                	mov    %ebx,%eax
80101a01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a06:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a09:	29 f1                	sub    %esi,%ecx
80101a0b:	bb 00 02 00 00       	mov    $0x200,%ebx
80101a10:	29 c3                	sub    %eax,%ebx
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	39 cb                	cmp    %ecx,%ebx
80101a17:	76 02                	jbe    80101a1b <writei+0x97>
80101a19:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a1b:	52                   	push   %edx
80101a1c:	53                   	push   %ebx
80101a1d:	ff 75 dc             	push   -0x24(%ebp)
80101a20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101a24:	50                   	push   %eax
80101a25:	e8 fe 26 00 00       	call   80104128 <memmove>
    log_write(bp);
80101a2a:	89 3c 24             	mov    %edi,(%esp)
80101a2d:	e8 f2 10 00 00       	call   80102b24 <log_write>
    brelse(bp);
80101a32:	89 3c 24             	mov    %edi,(%esp)
80101a35:	e8 82 e7 ff ff       	call   801001bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a3a:	01 de                	add    %ebx,%esi
80101a3c:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80101a48:	77 96                	ja     801019e0 <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
80101a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4d:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101a50:	3b 70 58             	cmp    0x58(%eax),%esi
80101a53:	77 2f                	ja     80101a84 <writei+0x100>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101a55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
80101a5f:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 31                	ja     80101a9b <writei+0x117>
80101a6a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 26                	je     80101a9b <writei+0x117>
    return devsw[ip->major].write(ip, src, n);
80101a75:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101a7f:	ff e0                	jmp    *%eax
80101a81:	8d 76 00             	lea    0x0(%esi),%esi
    ip->size = off;
80101a84:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a87:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101a8a:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a8d:	83 ec 0c             	sub    $0xc,%esp
80101a90:	50                   	push   %eax
80101a91:	e8 82 fa ff ff       	call   80101518 <iupdate>
80101a96:	83 c4 10             	add    $0x10,%esp
80101a99:	eb ba                	jmp    80101a55 <writei+0xd1>
      return -1;
80101a9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aa0:	eb b6                	jmp    80101a58 <writei+0xd4>
80101aa2:	66 90                	xchg   %ax,%ax

80101aa4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101aa4:	55                   	push   %ebp
80101aa5:	89 e5                	mov    %esp,%ebp
80101aa7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101aaa:	6a 0e                	push   $0xe
80101aac:	ff 75 0c             	push   0xc(%ebp)
80101aaf:	ff 75 08             	push   0x8(%ebp)
80101ab2:	e8 c1 26 00 00       	call   80104178 <strncmp>
}
80101ab7:	c9                   	leave  
80101ab8:	c3                   	ret    
80101ab9:	8d 76 00             	lea    0x0(%esi),%esi

80101abc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101abc:	55                   	push   %ebp
80101abd:	89 e5                	mov    %esp,%ebp
80101abf:	57                   	push   %edi
80101ac0:	56                   	push   %esi
80101ac1:	53                   	push   %ebx
80101ac2:	83 ec 1c             	sub    $0x1c,%esp
80101ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ac8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101acd:	75 7d                	jne    80101b4c <dirlookup+0x90>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101acf:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101ad2:	85 c9                	test   %ecx,%ecx
80101ad4:	74 3d                	je     80101b13 <dirlookup+0x57>
80101ad6:	31 ff                	xor    %edi,%edi
80101ad8:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101adb:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101adc:	6a 10                	push   $0x10
80101ade:	57                   	push   %edi
80101adf:	56                   	push   %esi
80101ae0:	53                   	push   %ebx
80101ae1:	e8 a6 fd ff ff       	call   8010188c <readi>
80101ae6:	83 c4 10             	add    $0x10,%esp
80101ae9:	83 f8 10             	cmp    $0x10,%eax
80101aec:	75 51                	jne    80101b3f <dirlookup+0x83>
      panic("dirlookup read");
    if(de.inum == 0)
80101aee:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101af3:	74 16                	je     80101b0b <dirlookup+0x4f>
  return strncmp(s, t, DIRSIZ);
80101af5:	52                   	push   %edx
80101af6:	6a 0e                	push   $0xe
80101af8:	8d 45 da             	lea    -0x26(%ebp),%eax
80101afb:	50                   	push   %eax
80101afc:	ff 75 0c             	push   0xc(%ebp)
80101aff:	e8 74 26 00 00       	call   80104178 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101b04:	83 c4 10             	add    $0x10,%esp
80101b07:	85 c0                	test   %eax,%eax
80101b09:	74 15                	je     80101b20 <dirlookup+0x64>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b0b:	83 c7 10             	add    $0x10,%edi
80101b0e:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101b11:	72 c9                	jb     80101adc <dirlookup+0x20>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101b13:	31 c0                	xor    %eax,%eax
}
80101b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b18:	5b                   	pop    %ebx
80101b19:	5e                   	pop    %esi
80101b1a:	5f                   	pop    %edi
80101b1b:	5d                   	pop    %ebp
80101b1c:	c3                   	ret    
80101b1d:	8d 76 00             	lea    0x0(%esi),%esi
      if(poff)
80101b20:	8b 45 10             	mov    0x10(%ebp),%eax
80101b23:	85 c0                	test   %eax,%eax
80101b25:	74 05                	je     80101b2c <dirlookup+0x70>
        *poff = off;
80101b27:	8b 45 10             	mov    0x10(%ebp),%eax
80101b2a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101b2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101b30:	8b 03                	mov    (%ebx),%eax
80101b32:	e8 b9 f6 ff ff       	call   801011f0 <iget>
}
80101b37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b3a:	5b                   	pop    %ebx
80101b3b:	5e                   	pop    %esi
80101b3c:	5f                   	pop    %edi
80101b3d:	5d                   	pop    %ebp
80101b3e:	c3                   	ret    
      panic("dirlookup read");
80101b3f:	83 ec 0c             	sub    $0xc,%esp
80101b42:	68 d9 6b 10 80       	push   $0x80106bd9
80101b47:	e8 ec e7 ff ff       	call   80100338 <panic>
    panic("dirlookup not DIR");
80101b4c:	83 ec 0c             	sub    $0xc,%esp
80101b4f:	68 c7 6b 10 80       	push   $0x80106bc7
80101b54:	e8 df e7 ff ff       	call   80100338 <panic>
80101b59:	8d 76 00             	lea    0x0(%esi),%esi

80101b5c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101b5c:	55                   	push   %ebp
80101b5d:	89 e5                	mov    %esp,%ebp
80101b5f:	57                   	push   %edi
80101b60:	56                   	push   %esi
80101b61:	53                   	push   %ebx
80101b62:	83 ec 1c             	sub    $0x1c,%esp
80101b65:	89 c3                	mov    %eax,%ebx
80101b67:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b6a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101b6d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101b70:	0f 84 42 01 00 00    	je     80101cb8 <namex+0x15c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b76:	e8 31 19 00 00       	call   801034ac <myproc>
80101b7b:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101b7e:	83 ec 0c             	sub    $0xc,%esp
80101b81:	68 60 f9 10 80       	push   $0x8010f960
80101b86:	e8 71 24 00 00       	call   80103ffc <acquire>
  ip->ref++;
80101b8b:	ff 46 08             	incl   0x8(%esi)
  release(&icache.lock);
80101b8e:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101b95:	e8 02 24 00 00       	call   80103f9c <release>
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	eb 02                	jmp    80101ba1 <namex+0x45>
80101b9f:	90                   	nop
    path++;
80101ba0:	43                   	inc    %ebx
  while(*path == '/')
80101ba1:	8a 03                	mov    (%ebx),%al
80101ba3:	3c 2f                	cmp    $0x2f,%al
80101ba5:	74 f9                	je     80101ba0 <namex+0x44>
  if(*path == 0)
80101ba7:	84 c0                	test   %al,%al
80101ba9:	0f 84 ed 00 00 00    	je     80101c9c <namex+0x140>
  while(*path != '/' && *path != 0)
80101baf:	8a 03                	mov    (%ebx),%al
80101bb1:	89 df                	mov    %ebx,%edi
80101bb3:	3c 2f                	cmp    $0x2f,%al
80101bb5:	75 0c                	jne    80101bc3 <namex+0x67>
80101bb7:	e9 f5 00 00 00       	jmp    80101cb1 <namex+0x155>
    path++;
80101bbc:	47                   	inc    %edi
  while(*path != '/' && *path != 0)
80101bbd:	8a 07                	mov    (%edi),%al
80101bbf:	3c 2f                	cmp    $0x2f,%al
80101bc1:	74 04                	je     80101bc7 <namex+0x6b>
80101bc3:	84 c0                	test   %al,%al
80101bc5:	75 f5                	jne    80101bbc <namex+0x60>
  len = path - s;
80101bc7:	89 f8                	mov    %edi,%eax
80101bc9:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101bcb:	83 f8 0d             	cmp    $0xd,%eax
80101bce:	0f 8e a4 00 00 00    	jle    80101c78 <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101bd4:	51                   	push   %ecx
80101bd5:	6a 0e                	push   $0xe
80101bd7:	53                   	push   %ebx
80101bd8:	ff 75 e4             	push   -0x1c(%ebp)
80101bdb:	e8 48 25 00 00       	call   80104128 <memmove>
80101be0:	83 c4 10             	add    $0x10,%esp
80101be3:	89 fb                	mov    %edi,%ebx
  while(*path == '/')
80101be5:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101be8:	75 08                	jne    80101bf2 <namex+0x96>
80101bea:	66 90                	xchg   %ax,%ax
    path++;
80101bec:	43                   	inc    %ebx
  while(*path == '/')
80101bed:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101bf0:	74 fa                	je     80101bec <namex+0x90>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101bf2:	83 ec 0c             	sub    $0xc,%esp
80101bf5:	56                   	push   %esi
80101bf6:	e8 c5 f9 ff ff       	call   801015c0 <ilock>
    if(ip->type != T_DIR){
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101c03:	0f 85 c5 00 00 00    	jne    80101cce <namex+0x172>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101c09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101c0c:	85 c0                	test   %eax,%eax
80101c0e:	74 09                	je     80101c19 <namex+0xbd>
80101c10:	80 3b 00             	cmpb   $0x0,(%ebx)
80101c13:	0f 84 1a 01 00 00    	je     80101d33 <namex+0x1d7>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101c19:	50                   	push   %eax
80101c1a:	6a 00                	push   $0x0
80101c1c:	ff 75 e4             	push   -0x1c(%ebp)
80101c1f:	56                   	push   %esi
80101c20:	e8 97 fe ff ff       	call   80101abc <dirlookup>
80101c25:	89 c7                	mov    %eax,%edi
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c27:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101c2a:	83 c4 10             	add    $0x10,%esp
80101c2d:	85 c0                	test   %eax,%eax
80101c2f:	0f 84 db 00 00 00    	je     80101d10 <namex+0x1b4>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c35:	83 ec 0c             	sub    $0xc,%esp
80101c38:	52                   	push   %edx
80101c39:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101c3c:	e8 b7 21 00 00       	call   80103df8 <holdingsleep>
80101c41:	83 c4 10             	add    $0x10,%esp
80101c44:	85 c0                	test   %eax,%eax
80101c46:	0f 84 2a 01 00 00    	je     80101d76 <namex+0x21a>
80101c4c:	8b 46 08             	mov    0x8(%esi),%eax
80101c4f:	85 c0                	test   %eax,%eax
80101c51:	0f 8e 1f 01 00 00    	jle    80101d76 <namex+0x21a>
  releasesleep(&ip->lock);
80101c57:	83 ec 0c             	sub    $0xc,%esp
80101c5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101c5d:	52                   	push   %edx
80101c5e:	e8 59 21 00 00       	call   80103dbc <releasesleep>
  iput(ip);
80101c63:	89 34 24             	mov    %esi,(%esp)
80101c66:	e8 61 fa ff ff       	call   801016cc <iput>
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	89 fe                	mov    %edi,%esi
  while(*path == '/')
80101c70:	e9 2c ff ff ff       	jmp    80101ba1 <namex+0x45>
80101c75:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101c78:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101c7b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
80101c7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
    memmove(name, s, len);
80101c81:	52                   	push   %edx
80101c82:	50                   	push   %eax
80101c83:	53                   	push   %ebx
80101c84:	ff 75 e4             	push   -0x1c(%ebp)
80101c87:	e8 9c 24 00 00       	call   80104128 <memmove>
    name[len] = 0;
80101c8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101c8f:	c6 02 00             	movb   $0x0,(%edx)
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	89 fb                	mov    %edi,%ebx
80101c97:	e9 49 ff ff ff       	jmp    80101be5 <namex+0x89>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101c9c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80101c9f:	85 db                	test   %ebx,%ebx
80101ca1:	0f 85 bc 00 00 00    	jne    80101d63 <namex+0x207>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ca7:	89 f0                	mov    %esi,%eax
80101ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cac:	5b                   	pop    %ebx
80101cad:	5e                   	pop    %esi
80101cae:	5f                   	pop    %edi
80101caf:	5d                   	pop    %ebp
80101cb0:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101cb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cb4:	31 c0                	xor    %eax,%eax
80101cb6:	eb c6                	jmp    80101c7e <namex+0x122>
    ip = iget(ROOTDEV, ROOTINO);
80101cb8:	ba 01 00 00 00       	mov    $0x1,%edx
80101cbd:	b8 01 00 00 00       	mov    $0x1,%eax
80101cc2:	e8 29 f5 ff ff       	call   801011f0 <iget>
80101cc7:	89 c6                	mov    %eax,%esi
80101cc9:	e9 d3 fe ff ff       	jmp    80101ba1 <namex+0x45>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101cce:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101cd1:	83 ec 0c             	sub    $0xc,%esp
80101cd4:	53                   	push   %ebx
80101cd5:	e8 1e 21 00 00       	call   80103df8 <holdingsleep>
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	85 c0                	test   %eax,%eax
80101cdf:	0f 84 91 00 00 00    	je     80101d76 <namex+0x21a>
80101ce5:	8b 56 08             	mov    0x8(%esi),%edx
80101ce8:	85 d2                	test   %edx,%edx
80101cea:	0f 8e 86 00 00 00    	jle    80101d76 <namex+0x21a>
  releasesleep(&ip->lock);
80101cf0:	83 ec 0c             	sub    $0xc,%esp
80101cf3:	53                   	push   %ebx
80101cf4:	e8 c3 20 00 00       	call   80103dbc <releasesleep>
  iput(ip);
80101cf9:	89 34 24             	mov    %esi,(%esp)
80101cfc:	e8 cb f9 ff ff       	call   801016cc <iput>
      return 0;
80101d01:	83 c4 10             	add    $0x10,%esp
80101d04:	31 f6                	xor    %esi,%esi
}
80101d06:	89 f0                	mov    %esi,%eax
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
80101d0f:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d10:	83 ec 0c             	sub    $0xc,%esp
80101d13:	52                   	push   %edx
80101d14:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d17:	e8 dc 20 00 00       	call   80103df8 <holdingsleep>
80101d1c:	83 c4 10             	add    $0x10,%esp
80101d1f:	85 c0                	test   %eax,%eax
80101d21:	74 53                	je     80101d76 <namex+0x21a>
80101d23:	8b 46 08             	mov    0x8(%esi),%eax
80101d26:	85 c0                	test   %eax,%eax
80101d28:	7e 4c                	jle    80101d76 <namex+0x21a>
  releasesleep(&ip->lock);
80101d2a:	83 ec 0c             	sub    $0xc,%esp
80101d2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d30:	52                   	push   %edx
80101d31:	eb c1                	jmp    80101cf4 <namex+0x198>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d33:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101d36:	83 ec 0c             	sub    $0xc,%esp
80101d39:	53                   	push   %ebx
80101d3a:	e8 b9 20 00 00       	call   80103df8 <holdingsleep>
80101d3f:	83 c4 10             	add    $0x10,%esp
80101d42:	85 c0                	test   %eax,%eax
80101d44:	74 30                	je     80101d76 <namex+0x21a>
80101d46:	8b 46 08             	mov    0x8(%esi),%eax
80101d49:	85 c0                	test   %eax,%eax
80101d4b:	7e 29                	jle    80101d76 <namex+0x21a>
  releasesleep(&ip->lock);
80101d4d:	83 ec 0c             	sub    $0xc,%esp
80101d50:	53                   	push   %ebx
80101d51:	e8 66 20 00 00       	call   80103dbc <releasesleep>
}
80101d56:	83 c4 10             	add    $0x10,%esp
}
80101d59:	89 f0                	mov    %esi,%eax
80101d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5e:	5b                   	pop    %ebx
80101d5f:	5e                   	pop    %esi
80101d60:	5f                   	pop    %edi
80101d61:	5d                   	pop    %ebp
80101d62:	c3                   	ret    
    iput(ip);
80101d63:	83 ec 0c             	sub    $0xc,%esp
80101d66:	56                   	push   %esi
80101d67:	e8 60 f9 ff ff       	call   801016cc <iput>
    return 0;
80101d6c:	83 c4 10             	add    $0x10,%esp
80101d6f:	31 f6                	xor    %esi,%esi
80101d71:	e9 31 ff ff ff       	jmp    80101ca7 <namex+0x14b>
    panic("iunlock");
80101d76:	83 ec 0c             	sub    $0xc,%esp
80101d79:	68 bf 6b 10 80       	push   $0x80106bbf
80101d7e:	e8 b5 e5 ff ff       	call   80100338 <panic>
80101d83:	90                   	nop

80101d84 <dirlink>:
{
80101d84:	55                   	push   %ebp
80101d85:	89 e5                	mov    %esp,%ebp
80101d87:	57                   	push   %edi
80101d88:	56                   	push   %esi
80101d89:	53                   	push   %ebx
80101d8a:	83 ec 20             	sub    $0x20,%esp
80101d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101d90:	6a 00                	push   $0x0
80101d92:	ff 75 0c             	push   0xc(%ebp)
80101d95:	53                   	push   %ebx
80101d96:	e8 21 fd ff ff       	call   80101abc <dirlookup>
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	85 c0                	test   %eax,%eax
80101da0:	75 65                	jne    80101e07 <dirlink+0x83>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101da5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101da8:	85 ff                	test   %edi,%edi
80101daa:	74 29                	je     80101dd5 <dirlink+0x51>
80101dac:	31 ff                	xor    %edi,%edi
80101dae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101db1:	eb 09                	jmp    80101dbc <dirlink+0x38>
80101db3:	90                   	nop
80101db4:	83 c7 10             	add    $0x10,%edi
80101db7:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dba:	73 19                	jae    80101dd5 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101dbc:	6a 10                	push   $0x10
80101dbe:	57                   	push   %edi
80101dbf:	56                   	push   %esi
80101dc0:	53                   	push   %ebx
80101dc1:	e8 c6 fa ff ff       	call   8010188c <readi>
80101dc6:	83 c4 10             	add    $0x10,%esp
80101dc9:	83 f8 10             	cmp    $0x10,%eax
80101dcc:	75 4c                	jne    80101e1a <dirlink+0x96>
    if(de.inum == 0)
80101dce:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101dd3:	75 df                	jne    80101db4 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101dd5:	50                   	push   %eax
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	push   0xc(%ebp)
80101ddb:	8d 45 da             	lea    -0x26(%ebp),%eax
80101dde:	50                   	push   %eax
80101ddf:	e8 d0 23 00 00       	call   801041b4 <strncpy>
  de.inum = inum;
80101de4:	8b 45 10             	mov    0x10(%ebp),%eax
80101de7:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101deb:	6a 10                	push   $0x10
80101ded:	57                   	push   %edi
80101dee:	56                   	push   %esi
80101def:	53                   	push   %ebx
80101df0:	e8 8f fb ff ff       	call   80101984 <writei>
80101df5:	83 c4 20             	add    $0x20,%esp
80101df8:	83 f8 10             	cmp    $0x10,%eax
80101dfb:	75 2a                	jne    80101e27 <dirlink+0xa3>
  return 0;
80101dfd:	31 c0                	xor    %eax,%eax
}
80101dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e02:	5b                   	pop    %ebx
80101e03:	5e                   	pop    %esi
80101e04:	5f                   	pop    %edi
80101e05:	5d                   	pop    %ebp
80101e06:	c3                   	ret    
    iput(ip);
80101e07:	83 ec 0c             	sub    $0xc,%esp
80101e0a:	50                   	push   %eax
80101e0b:	e8 bc f8 ff ff       	call   801016cc <iput>
    return -1;
80101e10:	83 c4 10             	add    $0x10,%esp
80101e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e18:	eb e5                	jmp    80101dff <dirlink+0x7b>
      panic("dirlink read");
80101e1a:	83 ec 0c             	sub    $0xc,%esp
80101e1d:	68 e8 6b 10 80       	push   $0x80106be8
80101e22:	e8 11 e5 ff ff       	call   80100338 <panic>
    panic("dirlink");
80101e27:	83 ec 0c             	sub    $0xc,%esp
80101e2a:	68 be 71 10 80       	push   $0x801071be
80101e2f:	e8 04 e5 ff ff       	call   80100338 <panic>

80101e34 <namei>:

struct inode*
namei(char *path)
{
80101e34:	55                   	push   %ebp
80101e35:	89 e5                	mov    %esp,%ebp
80101e37:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e3a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e3d:	31 d2                	xor    %edx,%edx
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	e8 15 fd ff ff       	call   80101b5c <namex>
}
80101e47:	c9                   	leave  
80101e48:	c3                   	ret    
80101e49:	8d 76 00             	lea    0x0(%esi),%esi

80101e4c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101e4c:	55                   	push   %ebp
80101e4d:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101e52:	ba 01 00 00 00       	mov    $0x1,%edx
80101e57:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101e5a:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101e5b:	e9 fc fc ff ff       	jmp    80101b5c <namex>

80101e60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101e69:	85 c0                	test   %eax,%eax
80101e6b:	0f 84 99 00 00 00    	je     80101f0a <idestart+0xaa>
80101e71:	89 c3                	mov    %eax,%ebx
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101e73:	8b 70 08             	mov    0x8(%eax),%esi
80101e76:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80101e7c:	77 7f                	ja     80101efd <idestart+0x9d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e7e:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101e83:	90                   	nop
80101e84:	89 ca                	mov    %ecx,%edx
80101e86:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e87:	83 e0 c0             	and    $0xffffffc0,%eax
80101e8a:	3c 40                	cmp    $0x40,%al
80101e8c:	75 f6                	jne    80101e84 <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e8e:	31 ff                	xor    %edi,%edi
80101e90:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101e95:	89 f8                	mov    %edi,%eax
80101e97:	ee                   	out    %al,(%dx)
80101e98:	b0 01                	mov    $0x1,%al
80101e9a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101e9f:	ee                   	out    %al,(%dx)
80101ea0:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101ea5:	89 f0                	mov    %esi,%eax
80101ea7:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ea8:	89 f0                	mov    %esi,%eax
80101eaa:	c1 f8 08             	sar    $0x8,%eax
80101ead:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101eb2:	ee                   	out    %al,(%dx)
80101eb3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101eb8:	89 f8                	mov    %edi,%eax
80101eba:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ebb:	8a 43 04             	mov    0x4(%ebx),%al
80101ebe:	c1 e0 04             	shl    $0x4,%eax
80101ec1:	83 e0 10             	and    $0x10,%eax
80101ec4:	83 c8 e0             	or     $0xffffffe0,%eax
80101ec7:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ecc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ecd:	f6 03 04             	testb  $0x4,(%ebx)
80101ed0:	75 0e                	jne    80101ee0 <idestart+0x80>
80101ed2:	b0 20                	mov    $0x20,%al
80101ed4:	89 ca                	mov    %ecx,%edx
80101ed6:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eda:	5b                   	pop    %ebx
80101edb:	5e                   	pop    %esi
80101edc:	5f                   	pop    %edi
80101edd:	5d                   	pop    %ebp
80101ede:	c3                   	ret    
80101edf:	90                   	nop
80101ee0:	b0 30                	mov    $0x30,%al
80101ee2:	89 ca                	mov    %ecx,%edx
80101ee4:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101ee5:	8d 73 5c             	lea    0x5c(%ebx),%esi
  asm volatile("cld; rep outsl" :
80101ee8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101eed:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ef2:	fc                   	cld    
80101ef3:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef8:	5b                   	pop    %ebx
80101ef9:	5e                   	pop    %esi
80101efa:	5f                   	pop    %edi
80101efb:	5d                   	pop    %ebp
80101efc:	c3                   	ret    
    panic("incorrect blockno");
80101efd:	83 ec 0c             	sub    $0xc,%esp
80101f00:	68 54 6c 10 80       	push   $0x80106c54
80101f05:	e8 2e e4 ff ff       	call   80100338 <panic>
    panic("idestart");
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	68 4b 6c 10 80       	push   $0x80106c4b
80101f12:	e8 21 e4 ff ff       	call   80100338 <panic>
80101f17:	90                   	nop

80101f18 <ideinit>:
{
80101f18:	55                   	push   %ebp
80101f19:	89 e5                	mov    %esp,%ebp
80101f1b:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101f1e:	68 66 6c 10 80       	push   $0x80106c66
80101f23:	68 00 16 11 80       	push   $0x80111600
80101f28:	e8 17 1f 00 00       	call   80103e44 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101f2d:	58                   	pop    %eax
80101f2e:	5a                   	pop    %edx
80101f2f:	a1 84 17 11 80       	mov    0x80111784,%eax
80101f34:	48                   	dec    %eax
80101f35:	50                   	push   %eax
80101f36:	6a 0e                	push   $0xe
80101f38:	e8 57 02 00 00       	call   80102194 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f3d:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f40:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f45:	8d 76 00             	lea    0x0(%esi),%esi
80101f48:	ec                   	in     (%dx),%al
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	b0 f0                	mov    $0xf0,%al
80101f52:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f57:	ee                   	out    %al,(%dx)
80101f58:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f5d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f62:	eb 03                	jmp    80101f67 <ideinit+0x4f>
  for(i=0; i<1000; i++){
80101f64:	49                   	dec    %ecx
80101f65:	74 0f                	je     80101f76 <ideinit+0x5e>
80101f67:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101f68:	84 c0                	test   %al,%al
80101f6a:	74 f8                	je     80101f64 <ideinit+0x4c>
      havedisk1 = 1;
80101f6c:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101f73:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f76:	b0 e0                	mov    $0xe0,%al
80101f78:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f7d:	ee                   	out    %al,(%dx)
}
80101f7e:	c9                   	leave  
80101f7f:	c3                   	ret    

80101f80 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101f80:	55                   	push   %ebp
80101f81:	89 e5                	mov    %esp,%ebp
80101f83:	57                   	push   %edi
80101f84:	56                   	push   %esi
80101f85:	53                   	push   %ebx
80101f86:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101f89:	68 00 16 11 80       	push   $0x80111600
80101f8e:	e8 69 20 00 00       	call   80103ffc <acquire>

  if((b = idequeue) == 0){
80101f93:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101f99:	83 c4 10             	add    $0x10,%esp
80101f9c:	85 db                	test   %ebx,%ebx
80101f9e:	74 5b                	je     80101ffb <ideintr+0x7b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101fa0:	8b 43 58             	mov    0x58(%ebx),%eax
80101fa3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101fa8:	8b 33                	mov    (%ebx),%esi
80101faa:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101fb0:	75 27                	jne    80101fd9 <ideintr+0x59>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb7:	90                   	nop
80101fb8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fb9:	88 c1                	mov    %al,%cl
80101fbb:	83 e1 c0             	and    $0xffffffc0,%ecx
80101fbe:	80 f9 40             	cmp    $0x40,%cl
80101fc1:	75 f5                	jne    80101fb8 <ideintr+0x38>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101fc3:	a8 21                	test   $0x21,%al
80101fc5:	75 12                	jne    80101fd9 <ideintr+0x59>
    insl(0x1f0, b->data, BSIZE/4);
80101fc7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101fca:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fcf:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd4:	fc                   	cld    
80101fd5:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101fd7:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80101fd9:	83 e6 fb             	and    $0xfffffffb,%esi
80101fdc:	83 ce 02             	or     $0x2,%esi
80101fdf:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80101fe1:	83 ec 0c             	sub    $0xc,%esp
80101fe4:	53                   	push   %ebx
80101fe5:	e8 ce 1b 00 00       	call   80103bb8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101fea:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101fef:	83 c4 10             	add    $0x10,%esp
80101ff2:	85 c0                	test   %eax,%eax
80101ff4:	74 05                	je     80101ffb <ideintr+0x7b>
    idestart(idequeue);
80101ff6:	e8 65 fe ff ff       	call   80101e60 <idestart>
    release(&idelock);
80101ffb:	83 ec 0c             	sub    $0xc,%esp
80101ffe:	68 00 16 11 80       	push   $0x80111600
80102003:	e8 94 1f 00 00       	call   80103f9c <release>

  release(&idelock);
}
80102008:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5f                   	pop    %edi
8010200e:	5d                   	pop    %ebp
8010200f:	c3                   	ret    

80102010 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	53                   	push   %ebx
80102014:	83 ec 10             	sub    $0x10,%esp
80102017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010201a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010201d:	50                   	push   %eax
8010201e:	e8 d5 1d 00 00       	call   80103df8 <holdingsleep>
80102023:	83 c4 10             	add    $0x10,%esp
80102026:	85 c0                	test   %eax,%eax
80102028:	0f 84 b7 00 00 00    	je     801020e5 <iderw+0xd5>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010202e:	8b 03                	mov    (%ebx),%eax
80102030:	83 e0 06             	and    $0x6,%eax
80102033:	83 f8 02             	cmp    $0x2,%eax
80102036:	0f 84 9c 00 00 00    	je     801020d8 <iderw+0xc8>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010203c:	8b 53 04             	mov    0x4(%ebx),%edx
8010203f:	85 d2                	test   %edx,%edx
80102041:	74 09                	je     8010204c <iderw+0x3c>
80102043:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102048:	85 c0                	test   %eax,%eax
8010204a:	74 7f                	je     801020cb <iderw+0xbb>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010204c:	83 ec 0c             	sub    $0xc,%esp
8010204f:	68 00 16 11 80       	push   $0x80111600
80102054:	e8 a3 1f 00 00       	call   80103ffc <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102059:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102060:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	85 c0                	test   %eax,%eax
8010206a:	74 58                	je     801020c4 <iderw+0xb4>
8010206c:	89 c2                	mov    %eax,%edx
8010206e:	8b 40 58             	mov    0x58(%eax),%eax
80102071:	85 c0                	test   %eax,%eax
80102073:	75 f7                	jne    8010206c <iderw+0x5c>
80102075:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102078:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010207a:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102080:	74 36                	je     801020b8 <iderw+0xa8>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102082:	8b 03                	mov    (%ebx),%eax
80102084:	83 e0 06             	and    $0x6,%eax
80102087:	83 f8 02             	cmp    $0x2,%eax
8010208a:	74 1b                	je     801020a7 <iderw+0x97>
    sleep(b, &idelock);
8010208c:	83 ec 08             	sub    $0x8,%esp
8010208f:	68 00 16 11 80       	push   $0x80111600
80102094:	53                   	push   %ebx
80102095:	e8 62 1a 00 00       	call   80103afc <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010209a:	8b 03                	mov    (%ebx),%eax
8010209c:	83 e0 06             	and    $0x6,%eax
8010209f:	83 c4 10             	add    $0x10,%esp
801020a2:	83 f8 02             	cmp    $0x2,%eax
801020a5:	75 e5                	jne    8010208c <iderw+0x7c>
  }


  release(&idelock);
801020a7:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801020ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020b1:	c9                   	leave  
  release(&idelock);
801020b2:	e9 e5 1e 00 00       	jmp    80103f9c <release>
801020b7:	90                   	nop
    idestart(b);
801020b8:	89 d8                	mov    %ebx,%eax
801020ba:	e8 a1 fd ff ff       	call   80101e60 <idestart>
801020bf:	eb c1                	jmp    80102082 <iderw+0x72>
801020c1:	8d 76 00             	lea    0x0(%esi),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020c4:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801020c9:	eb ad                	jmp    80102078 <iderw+0x68>
    panic("iderw: ide disk 1 not present");
801020cb:	83 ec 0c             	sub    $0xc,%esp
801020ce:	68 95 6c 10 80       	push   $0x80106c95
801020d3:	e8 60 e2 ff ff       	call   80100338 <panic>
    panic("iderw: nothing to do");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 80 6c 10 80       	push   $0x80106c80
801020e0:	e8 53 e2 ff ff       	call   80100338 <panic>
    panic("iderw: buf not locked");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 6a 6c 10 80       	push   $0x80106c6a
801020ed:	e8 46 e2 ff ff       	call   80100338 <panic>
801020f2:	66 90                	xchg   %ax,%ax

801020f4 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801020f4:	55                   	push   %ebp
801020f5:	89 e5                	mov    %esp,%ebp
801020f7:	56                   	push   %esi
801020f8:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801020f9:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102100:	00 c0 fe 
  ioapic->reg = reg;
80102103:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010210a:	00 00 00 
  return ioapic->data;
8010210d:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80102113:	8b 72 10             	mov    0x10(%edx),%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102116:	c1 ee 10             	shr    $0x10,%esi
80102119:	89 f0                	mov    %esi,%eax
8010211b:	0f b6 f0             	movzbl %al,%esi
  ioapic->reg = reg;
8010211e:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102124:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010212a:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010212d:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  id = ioapicread(REG_ID) >> 24;
80102134:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102137:	39 c2                	cmp    %eax,%edx
80102139:	74 16                	je     80102151 <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010213b:	83 ec 0c             	sub    $0xc,%esp
8010213e:	68 b4 6c 10 80       	push   $0x80106cb4
80102143:	e8 d4 e4 ff ff       	call   8010061c <cprintf>
  ioapic->reg = reg;
80102148:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	83 c6 21             	add    $0x21,%esi
{
80102154:	ba 10 00 00 00       	mov    $0x10,%edx
80102159:	b8 20 00 00 00       	mov    $0x20,%eax
8010215e:	66 90                	xchg   %ax,%ax

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102160:	89 c3                	mov    %eax,%ebx
80102162:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->reg = reg;
80102168:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
8010216a:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102170:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102173:	8d 5a 01             	lea    0x1(%edx),%ebx
80102176:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102178:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010217e:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102185:	40                   	inc    %eax
80102186:	83 c2 02             	add    $0x2,%edx
80102189:	39 f0                	cmp    %esi,%eax
8010218b:	75 d3                	jne    80102160 <ioapicinit+0x6c>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010218d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5d                   	pop    %ebp
80102193:	c3                   	ret    

80102194 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010219a:	8d 50 20             	lea    0x20(%eax),%edx
8010219d:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801021a1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021a7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021a9:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
801021af:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801021b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801021b5:	c1 e2 18             	shl    $0x18,%edx
801021b8:	40                   	inc    %eax
  ioapic->reg = reg;
801021b9:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801021bb:	a1 34 16 11 80       	mov    0x80111634,%eax
801021c0:	89 50 10             	mov    %edx,0x10(%eax)
}
801021c3:	5d                   	pop    %ebp
801021c4:	c3                   	ret    
801021c5:	66 90                	xchg   %ax,%ax
801021c7:	90                   	nop

801021c8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801021c8:	55                   	push   %ebp
801021c9:	89 e5                	mov    %esp,%ebp
801021cb:	53                   	push   %ebx
801021cc:	53                   	push   %ebx
801021cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801021d0:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801021d6:	75 70                	jne    80102248 <kfree+0x80>
801021d8:	81 fb a0 5e 11 80    	cmp    $0x80115ea0,%ebx
801021de:	72 68                	jb     80102248 <kfree+0x80>
801021e0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801021e6:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801021eb:	77 5b                	ja     80102248 <kfree+0x80>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801021ed:	52                   	push   %edx
801021ee:	68 00 10 00 00       	push   $0x1000
801021f3:	6a 01                	push   $0x1
801021f5:	53                   	push   %ebx
801021f6:	e8 a9 1e 00 00       	call   801040a4 <memset>

  if(kmem.use_lock)
801021fb:	83 c4 10             	add    $0x10,%esp
801021fe:	8b 0d 74 16 11 80    	mov    0x80111674,%ecx
80102204:	85 c9                	test   %ecx,%ecx
80102206:	75 1c                	jne    80102224 <kfree+0x5c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102208:	a1 78 16 11 80       	mov    0x80111678,%eax
8010220d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
8010220f:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102215:	a1 74 16 11 80       	mov    0x80111674,%eax
8010221a:	85 c0                	test   %eax,%eax
8010221c:	75 1a                	jne    80102238 <kfree+0x70>
    release(&kmem.lock);
}
8010221e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102221:	c9                   	leave  
80102222:	c3                   	ret    
80102223:	90                   	nop
    acquire(&kmem.lock);
80102224:	83 ec 0c             	sub    $0xc,%esp
80102227:	68 40 16 11 80       	push   $0x80111640
8010222c:	e8 cb 1d 00 00       	call   80103ffc <acquire>
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	eb d2                	jmp    80102208 <kfree+0x40>
80102236:	66 90                	xchg   %ax,%ax
    release(&kmem.lock);
80102238:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010223f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102242:	c9                   	leave  
    release(&kmem.lock);
80102243:	e9 54 1d 00 00       	jmp    80103f9c <release>
    panic("kfree");
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	68 e6 6c 10 80       	push   $0x80106ce6
80102250:	e8 e3 e0 ff ff       	call   80100338 <panic>
80102255:	8d 76 00             	lea    0x0(%esi),%esi

80102258 <freerange>:
{
80102258:	55                   	push   %ebp
80102259:	89 e5                	mov    %esp,%ebp
8010225b:	56                   	push   %esi
8010225c:	53                   	push   %ebx
8010225d:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102260:	8b 45 08             	mov    0x8(%ebp),%eax
80102263:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102269:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010226f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102275:	39 de                	cmp    %ebx,%esi
80102277:	72 1f                	jb     80102298 <freerange+0x40>
80102279:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
8010227c:	83 ec 0c             	sub    $0xc,%esp
8010227f:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102285:	50                   	push   %eax
80102286:	e8 3d ff ff ff       	call   801021c8 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010228b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102291:	83 c4 10             	add    $0x10,%esp
80102294:	39 f3                	cmp    %esi,%ebx
80102296:	76 e4                	jbe    8010227c <freerange+0x24>
}
80102298:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010229b:	5b                   	pop    %ebx
8010229c:	5e                   	pop    %esi
8010229d:	5d                   	pop    %ebp
8010229e:	c3                   	ret    
8010229f:	90                   	nop

801022a0 <kinit2>:
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	56                   	push   %esi
801022a4:	53                   	push   %ebx
801022a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801022a8:	8b 45 08             	mov    0x8(%ebp),%eax
801022ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801022b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022bd:	39 de                	cmp    %ebx,%esi
801022bf:	72 1f                	jb     801022e0 <kinit2+0x40>
801022c1:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801022cd:	50                   	push   %eax
801022ce:	e8 f5 fe ff ff       	call   801021c8 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801022d3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	39 de                	cmp    %ebx,%esi
801022de:	73 e4                	jae    801022c4 <kinit2+0x24>
  kmem.use_lock = 1;
801022e0:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801022e7:	00 00 00 
}
801022ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022ed:	5b                   	pop    %ebx
801022ee:	5e                   	pop    %esi
801022ef:	5d                   	pop    %ebp
801022f0:	c3                   	ret    
801022f1:	8d 76 00             	lea    0x0(%esi),%esi

801022f4 <kinit1>:
{
801022f4:	55                   	push   %ebp
801022f5:	89 e5                	mov    %esp,%ebp
801022f7:	56                   	push   %esi
801022f8:	53                   	push   %ebx
801022f9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801022fc:	83 ec 08             	sub    $0x8,%esp
801022ff:	68 ec 6c 10 80       	push   $0x80106cec
80102304:	68 40 16 11 80       	push   $0x80111640
80102309:	e8 36 1b 00 00       	call   80103e44 <initlock>
  kmem.use_lock = 0;
8010230e:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102315:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102318:	8b 45 08             	mov    0x8(%ebp),%eax
8010231b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102321:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102327:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	39 de                	cmp    %ebx,%esi
80102332:	72 1c                	jb     80102350 <kinit1+0x5c>
    kfree(p);
80102334:	83 ec 0c             	sub    $0xc,%esp
80102337:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010233d:	50                   	push   %eax
8010233e:	e8 85 fe ff ff       	call   801021c8 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102343:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102349:	83 c4 10             	add    $0x10,%esp
8010234c:	39 de                	cmp    %ebx,%esi
8010234e:	73 e4                	jae    80102334 <kinit1+0x40>
}
80102350:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102353:	5b                   	pop    %ebx
80102354:	5e                   	pop    %esi
80102355:	5d                   	pop    %ebp
80102356:	c3                   	ret    
80102357:	90                   	nop

80102358 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102358:	a1 74 16 11 80       	mov    0x80111674,%eax
8010235d:	85 c0                	test   %eax,%eax
8010235f:	75 17                	jne    80102378 <kalloc+0x20>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102361:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
80102366:	85 c0                	test   %eax,%eax
80102368:	74 0a                	je     80102374 <kalloc+0x1c>
    kmem.freelist = r->next;
8010236a:	8b 10                	mov    (%eax),%edx
8010236c:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102372:	c3                   	ret    
80102373:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102374:	c3                   	ret    
80102375:	8d 76 00             	lea    0x0(%esi),%esi
{
80102378:	55                   	push   %ebp
80102379:	89 e5                	mov    %esp,%ebp
8010237b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010237e:	68 40 16 11 80       	push   $0x80111640
80102383:	e8 74 1c 00 00       	call   80103ffc <acquire>
  r = kmem.freelist;
80102388:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010238d:	83 c4 10             	add    $0x10,%esp
  if(kmem.use_lock)
80102390:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
80102396:	85 c0                	test   %eax,%eax
80102398:	74 08                	je     801023a2 <kalloc+0x4a>
    kmem.freelist = r->next;
8010239a:	8b 08                	mov    (%eax),%ecx
8010239c:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801023a2:	85 d2                	test   %edx,%edx
801023a4:	74 16                	je     801023bc <kalloc+0x64>
801023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&kmem.lock);
801023a9:	83 ec 0c             	sub    $0xc,%esp
801023ac:	68 40 16 11 80       	push   $0x80111640
801023b1:	e8 e6 1b 00 00       	call   80103f9c <release>
801023b6:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023bc:	c9                   	leave  
801023bd:	c3                   	ret    
801023be:	66 90                	xchg   %ax,%ax

801023c0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023c0:	ba 64 00 00 00       	mov    $0x64,%edx
801023c5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801023c6:	a8 01                	test   $0x1,%al
801023c8:	0f 84 b2 00 00 00    	je     80102480 <kbdgetc+0xc0>
{
801023ce:	55                   	push   %ebp
801023cf:	89 e5                	mov    %esp,%ebp
801023d1:	53                   	push   %ebx
801023d2:	ba 60 00 00 00       	mov    $0x60,%edx
801023d7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801023d8:	0f b6 d8             	movzbl %al,%ebx

  if(data == 0xE0){
    shift |= E0ESC;
801023db:	8b 0d 7c 16 11 80    	mov    0x8011167c,%ecx
  if(data == 0xE0){
801023e1:	3c e0                	cmp    $0xe0,%al
801023e3:	74 5b                	je     80102440 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801023e5:	89 ca                	mov    %ecx,%edx
801023e7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801023ea:	84 c0                	test   %al,%al
801023ec:	78 62                	js     80102450 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801023ee:	85 d2                	test   %edx,%edx
801023f0:	74 09                	je     801023fb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801023f2:	83 c8 80             	or     $0xffffff80,%eax
801023f5:	0f b6 d8             	movzbl %al,%ebx
    shift &= ~E0ESC;
801023f8:	83 e1 bf             	and    $0xffffffbf,%ecx
  }

  shift |= shiftcode[data];
801023fb:	0f b6 93 20 6e 10 80 	movzbl -0x7fef91e0(%ebx),%edx
80102402:	09 ca                	or     %ecx,%edx
  shift ^= togglecode[data];
80102404:	0f b6 83 20 6d 10 80 	movzbl -0x7fef92e0(%ebx),%eax
8010240b:	31 c2                	xor    %eax,%edx
8010240d:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102413:	89 d0                	mov    %edx,%eax
80102415:	83 e0 03             	and    $0x3,%eax
80102418:	8b 04 85 00 6d 10 80 	mov    -0x7fef9300(,%eax,4),%eax
8010241f:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
  if(shift & CAPSLOCK){
80102423:	83 e2 08             	and    $0x8,%edx
80102426:	74 13                	je     8010243b <kbdgetc+0x7b>
    if('a' <= c && c <= 'z')
80102428:	8d 50 9f             	lea    -0x61(%eax),%edx
8010242b:	83 fa 19             	cmp    $0x19,%edx
8010242e:	76 48                	jbe    80102478 <kbdgetc+0xb8>
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102430:	8d 50 bf             	lea    -0x41(%eax),%edx
80102433:	83 fa 19             	cmp    $0x19,%edx
80102436:	77 03                	ja     8010243b <kbdgetc+0x7b>
      c += 'a' - 'A';
80102438:	83 c0 20             	add    $0x20,%eax
  }
  return c;
}
8010243b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243e:	c9                   	leave  
8010243f:	c3                   	ret    
    shift |= E0ESC;
80102440:	83 c9 40             	or     $0x40,%ecx
80102443:	89 0d 7c 16 11 80    	mov    %ecx,0x8011167c
    return 0;
80102449:	31 c0                	xor    %eax,%eax
}
8010244b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010244e:	c9                   	leave  
8010244f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102450:	85 d2                	test   %edx,%edx
80102452:	75 05                	jne    80102459 <kbdgetc+0x99>
80102454:	89 c3                	mov    %eax,%ebx
80102456:	83 e3 7f             	and    $0x7f,%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102459:	8a 83 20 6e 10 80    	mov    -0x7fef91e0(%ebx),%al
8010245f:	83 c8 40             	or     $0x40,%eax
80102462:	0f b6 c0             	movzbl %al,%eax
80102465:	f7 d0                	not    %eax
80102467:	21 c8                	and    %ecx,%eax
80102469:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010246e:	31 c0                	xor    %eax,%eax
}
80102470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102473:	c9                   	leave  
80102474:	c3                   	ret    
80102475:	8d 76 00             	lea    0x0(%esi),%esi
      c += 'A' - 'a';
80102478:	83 e8 20             	sub    $0x20,%eax
}
8010247b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010247e:	c9                   	leave  
8010247f:	c3                   	ret    
    return -1;
80102480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102485:	c3                   	ret    
80102486:	66 90                	xchg   %ax,%ax

80102488 <kbdintr>:

void
kbdintr(void)
{
80102488:	55                   	push   %ebp
80102489:	89 e5                	mov    %esp,%ebp
8010248b:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010248e:	68 c0 23 10 80       	push   $0x801023c0
80102493:	e8 4c e3 ff ff       	call   801007e4 <consoleintr>
}
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	c9                   	leave  
8010249c:	c3                   	ret    
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801024a0:	a1 80 16 11 80       	mov    0x80111680,%eax
801024a5:	85 c0                	test   %eax,%eax
801024a7:	0f 84 c3 00 00 00    	je     80102570 <lapicinit+0xd0>
  lapic[index] = value;
801024ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801024b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801024c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801024ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801024d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801024db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801024de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801024e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801024eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801024f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801024f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801024fb:	8b 50 30             	mov    0x30(%eax),%edx
801024fe:	c1 ea 10             	shr    $0x10,%edx
80102501:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102507:	75 6b                	jne    80102574 <lapicinit+0xd4>
  lapic[index] = value;
80102509:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102510:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102513:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102516:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010251d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102520:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102523:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010252a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010252d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102530:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102537:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010253a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010253d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102544:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102547:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010254a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102551:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102554:	8b 50 20             	mov    0x20(%eax),%edx
80102557:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102558:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010255e:	80 e6 10             	and    $0x10,%dh
80102561:	75 f5                	jne    80102558 <lapicinit+0xb8>
  lapic[index] = value;
80102563:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010256a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010256d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102570:	c3                   	ret    
80102571:	8d 76 00             	lea    0x0(%esi),%esi
  lapic[index] = value;
80102574:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010257b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010257e:	8b 50 20             	mov    0x20(%eax),%edx
}
80102581:	eb 86                	jmp    80102509 <lapicinit+0x69>
80102583:	90                   	nop

80102584 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102584:	a1 80 16 11 80       	mov    0x80111680,%eax
80102589:	85 c0                	test   %eax,%eax
8010258b:	74 07                	je     80102594 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
8010258d:	8b 40 20             	mov    0x20(%eax),%eax
80102590:	c1 e8 18             	shr    $0x18,%eax
80102593:	c3                   	ret    
    return 0;
80102594:	31 c0                	xor    %eax,%eax
}
80102596:	c3                   	ret    
80102597:	90                   	nop

80102598 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102598:	a1 80 16 11 80       	mov    0x80111680,%eax
8010259d:	85 c0                	test   %eax,%eax
8010259f:	74 0d                	je     801025ae <lapiceoi+0x16>
  lapic[index] = value;
801025a1:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801025a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ab:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801025ae:	c3                   	ret    
801025af:	90                   	nop

801025b0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801025b0:	c3                   	ret    
801025b1:	8d 76 00             	lea    0x0(%esi),%esi

801025b4 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801025b4:	55                   	push   %ebp
801025b5:	89 e5                	mov    %esp,%ebp
801025b7:	53                   	push   %ebx
801025b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025be:	b0 0f                	mov    $0xf,%al
801025c0:	ba 70 00 00 00       	mov    $0x70,%edx
801025c5:	ee                   	out    %al,(%dx)
801025c6:	b0 0a                	mov    $0xa,%al
801025c8:	ba 71 00 00 00       	mov    $0x71,%edx
801025cd:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801025ce:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801025d5:	00 00 
  wrv[1] = addr >> 4;
801025d7:	89 c8                	mov    %ecx,%eax
801025d9:	c1 e8 04             	shr    $0x4,%eax
801025dc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801025e2:	a1 80 16 11 80       	mov    0x80111680,%eax

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801025e7:	c1 e3 18             	shl    $0x18,%ebx
801025ea:	89 da                	mov    %ebx,%edx
  lapic[index] = value;
801025ec:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801025f2:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801025f5:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801025fc:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ff:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102602:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102609:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010260f:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102615:	8b 58 20             	mov    0x20(%eax),%ebx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102618:	c1 e9 0c             	shr    $0xc,%ecx
8010261b:	80 cd 06             	or     $0x6,%ch
  lapic[index] = value;
8010261e:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102627:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010262d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102630:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102636:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102639:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010263c:	c9                   	leave  
8010263d:	c3                   	ret    
8010263e:	66 90                	xchg   %ax,%ax

80102640 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	57                   	push   %edi
80102644:	56                   	push   %esi
80102645:	53                   	push   %ebx
80102646:	83 ec 4c             	sub    $0x4c,%esp
80102649:	b0 0b                	mov    $0xb,%al
8010264b:	ba 70 00 00 00       	mov    $0x70,%edx
80102650:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102651:	ba 71 00 00 00       	mov    $0x71,%edx
80102656:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102657:	83 e0 04             	and    $0x4,%eax
8010265a:	88 45 b2             	mov    %al,-0x4e(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265d:	be 70 00 00 00       	mov    $0x70,%esi
80102662:	66 90                	xchg   %ax,%ax
80102664:	31 c0                	xor    %eax,%eax
80102666:	89 f2                	mov    %esi,%edx
80102668:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102669:	bb 71 00 00 00       	mov    $0x71,%ebx
8010266e:	89 da                	mov    %ebx,%edx
80102670:	ec                   	in     (%dx),%al
80102671:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102674:	bf 02 00 00 00       	mov    $0x2,%edi
80102679:	89 f8                	mov    %edi,%eax
8010267b:	89 f2                	mov    %esi,%edx
8010267d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010267e:	89 da                	mov    %ebx,%edx
80102680:	ec                   	in     (%dx),%al
80102681:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102684:	b0 04                	mov    $0x4,%al
80102686:	89 f2                	mov    %esi,%edx
80102688:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102689:	89 da                	mov    %ebx,%edx
8010268b:	ec                   	in     (%dx),%al
8010268c:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268f:	b0 07                	mov    $0x7,%al
80102691:	89 f2                	mov    %esi,%edx
80102693:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102694:	89 da                	mov    %ebx,%edx
80102696:	ec                   	in     (%dx),%al
80102697:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269a:	b0 08                	mov    $0x8,%al
8010269c:	89 f2                	mov    %esi,%edx
8010269e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010269f:	89 da                	mov    %ebx,%edx
801026a1:	ec                   	in     (%dx),%al
801026a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026a5:	b0 09                	mov    $0x9,%al
801026a7:	89 f2                	mov    %esi,%edx
801026a9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026aa:	89 da                	mov    %ebx,%edx
801026ac:	ec                   	in     (%dx),%al
801026ad:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b0:	b0 0a                	mov    $0xa,%al
801026b2:	89 f2                	mov    %esi,%edx
801026b4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b5:	89 da                	mov    %ebx,%edx
801026b7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801026b8:	84 c0                	test   %al,%al
801026ba:	78 a8                	js     80102664 <cmostime+0x24>
  return inb(CMOS_RETURN);
801026bc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801026c0:	89 45 b8             	mov    %eax,-0x48(%ebp)
801026c3:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801026c7:	89 45 bc             	mov    %eax,-0x44(%ebp)
801026ca:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801026ce:	89 45 c0             	mov    %eax,-0x40(%ebp)
801026d1:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801026d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801026d8:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
801026dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
801026df:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e2:	31 c0                	xor    %eax,%eax
801026e4:	89 f2                	mov    %esi,%edx
801026e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e7:	89 da                	mov    %ebx,%edx
801026e9:	ec                   	in     (%dx),%al
801026ea:	0f b6 c0             	movzbl %al,%eax
801026ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026f0:	89 f8                	mov    %edi,%eax
801026f2:	89 f2                	mov    %esi,%edx
801026f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f5:	89 da                	mov    %ebx,%edx
801026f7:	ec                   	in     (%dx),%al
801026f8:	0f b6 c0             	movzbl %al,%eax
801026fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026fe:	b0 04                	mov    $0x4,%al
80102700:	89 f2                	mov    %esi,%edx
80102702:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102703:	89 da                	mov    %ebx,%edx
80102705:	ec                   	in     (%dx),%al
80102706:	0f b6 c0             	movzbl %al,%eax
80102709:	89 45 d8             	mov    %eax,-0x28(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010270c:	b0 07                	mov    $0x7,%al
8010270e:	89 f2                	mov    %esi,%edx
80102710:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102711:	89 da                	mov    %ebx,%edx
80102713:	ec                   	in     (%dx),%al
80102714:	0f b6 c0             	movzbl %al,%eax
80102717:	89 45 dc             	mov    %eax,-0x24(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010271a:	b0 08                	mov    $0x8,%al
8010271c:	89 f2                	mov    %esi,%edx
8010271e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010271f:	89 da                	mov    %ebx,%edx
80102721:	ec                   	in     (%dx),%al
80102722:	0f b6 c0             	movzbl %al,%eax
80102725:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102728:	b0 09                	mov    $0x9,%al
8010272a:	89 f2                	mov    %esi,%edx
8010272c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010272d:	89 da                	mov    %ebx,%edx
8010272f:	ec                   	in     (%dx),%al
80102730:	0f b6 c0             	movzbl %al,%eax
80102733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102736:	50                   	push   %eax
80102737:	6a 18                	push   $0x18
80102739:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010273c:	50                   	push   %eax
8010273d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102740:	50                   	push   %eax
80102741:	e8 aa 19 00 00       	call   801040f0 <memcmp>
80102746:	83 c4 10             	add    $0x10,%esp
80102749:	85 c0                	test   %eax,%eax
8010274b:	0f 85 13 ff ff ff    	jne    80102664 <cmostime+0x24>
      break;
  }

  // convert
  if(bcd) {
80102751:	80 7d b2 00          	cmpb   $0x0,-0x4e(%ebp)
80102755:	75 7e                	jne    801027d5 <cmostime+0x195>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102757:	8b 55 b8             	mov    -0x48(%ebp),%edx
8010275a:	89 d0                	mov    %edx,%eax
8010275c:	c1 e8 04             	shr    $0x4,%eax
8010275f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102762:	01 c0                	add    %eax,%eax
80102764:	83 e2 0f             	and    $0xf,%edx
80102767:	01 d0                	add    %edx,%eax
80102769:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010276c:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010276f:	89 d0                	mov    %edx,%eax
80102771:	c1 e8 04             	shr    $0x4,%eax
80102774:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102777:	01 c0                	add    %eax,%eax
80102779:	83 e2 0f             	and    $0xf,%edx
8010277c:	01 d0                	add    %edx,%eax
8010277e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102781:	8b 55 c0             	mov    -0x40(%ebp),%edx
80102784:	89 d0                	mov    %edx,%eax
80102786:	c1 e8 04             	shr    $0x4,%eax
80102789:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010278c:	01 c0                	add    %eax,%eax
8010278e:	83 e2 0f             	and    $0xf,%edx
80102791:	01 d0                	add    %edx,%eax
80102793:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102796:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80102799:	89 d0                	mov    %edx,%eax
8010279b:	c1 e8 04             	shr    $0x4,%eax
8010279e:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027a1:	01 c0                	add    %eax,%eax
801027a3:	83 e2 0f             	and    $0xf,%edx
801027a6:	01 d0                	add    %edx,%eax
801027a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801027ab:	8b 55 c8             	mov    -0x38(%ebp),%edx
801027ae:	89 d0                	mov    %edx,%eax
801027b0:	c1 e8 04             	shr    $0x4,%eax
801027b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027b6:	01 c0                	add    %eax,%eax
801027b8:	83 e2 0f             	and    $0xf,%edx
801027bb:	01 d0                	add    %edx,%eax
801027bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801027c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
801027c3:	89 d0                	mov    %edx,%eax
801027c5:	c1 e8 04             	shr    $0x4,%eax
801027c8:	8d 04 80             	lea    (%eax,%eax,4),%eax
801027cb:	01 c0                	add    %eax,%eax
801027cd:	83 e2 0f             	and    $0xf,%edx
801027d0:	01 d0                	add    %edx,%eax
801027d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801027d5:	b9 06 00 00 00       	mov    $0x6,%ecx
801027da:	8b 7d 08             	mov    0x8(%ebp),%edi
801027dd:	8d 75 b8             	lea    -0x48(%ebp),%esi
801027e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
801027ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027ef:	5b                   	pop    %ebx
801027f0:	5e                   	pop    %esi
801027f1:	5f                   	pop    %edi
801027f2:	5d                   	pop    %ebp
801027f3:	c3                   	ret    

801027f4 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801027f4:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
801027fa:	85 c9                	test   %ecx,%ecx
801027fc:	7e 7e                	jle    8010287c <install_trans+0x88>
{
801027fe:	55                   	push   %ebp
801027ff:	89 e5                	mov    %esp,%ebp
80102801:	57                   	push   %edi
80102802:	56                   	push   %esi
80102803:	53                   	push   %ebx
80102804:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102807:	31 ff                	xor    %edi,%edi
80102809:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010280c:	83 ec 08             	sub    $0x8,%esp
8010280f:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102814:	01 f8                	add    %edi,%eax
80102816:	40                   	inc    %eax
80102817:	50                   	push   %eax
80102818:	ff 35 e4 16 11 80    	push   0x801116e4
8010281e:	e8 91 d8 ff ff       	call   801000b4 <bread>
80102823:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102825:	58                   	pop    %eax
80102826:	5a                   	pop    %edx
80102827:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
8010282e:	ff 35 e4 16 11 80    	push   0x801116e4
80102834:	e8 7b d8 ff ff       	call   801000b4 <bread>
80102839:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010283b:	83 c4 0c             	add    $0xc,%esp
8010283e:	68 00 02 00 00       	push   $0x200
80102843:	8d 46 5c             	lea    0x5c(%esi),%eax
80102846:	50                   	push   %eax
80102847:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010284a:	50                   	push   %eax
8010284b:	e8 d8 18 00 00       	call   80104128 <memmove>
    bwrite(dbuf);  // write dst to disk
80102850:	89 1c 24             	mov    %ebx,(%esp)
80102853:	e8 2c d9 ff ff       	call   80100184 <bwrite>
    brelse(lbuf);
80102858:	89 34 24             	mov    %esi,(%esp)
8010285b:	e8 5c d9 ff ff       	call   801001bc <brelse>
    brelse(dbuf);
80102860:	89 1c 24             	mov    %ebx,(%esp)
80102863:	e8 54 d9 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102868:	47                   	inc    %edi
80102869:	83 c4 10             	add    $0x10,%esp
8010286c:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102872:	7f 98                	jg     8010280c <install_trans+0x18>
  }
}
80102874:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102877:	5b                   	pop    %ebx
80102878:	5e                   	pop    %esi
80102879:	5f                   	pop    %edi
8010287a:	5d                   	pop    %ebp
8010287b:	c3                   	ret    
8010287c:	c3                   	ret    
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	53                   	push   %ebx
80102884:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102887:	ff 35 d4 16 11 80    	push   0x801116d4
8010288d:	ff 35 e4 16 11 80    	push   0x801116e4
80102893:	e8 1c d8 ff ff       	call   801000b4 <bread>
80102898:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010289a:	a1 e8 16 11 80       	mov    0x801116e8,%eax
8010289f:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801028a2:	83 c4 10             	add    $0x10,%esp
801028a5:	85 c0                	test   %eax,%eax
801028a7:	7e 13                	jle    801028bc <write_head+0x3c>
801028a9:	31 d2                	xor    %edx,%edx
801028ab:	90                   	nop
    hb->block[i] = log.lh.block[i];
801028ac:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
801028b3:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801028b7:	42                   	inc    %edx
801028b8:	39 d0                	cmp    %edx,%eax
801028ba:	75 f0                	jne    801028ac <write_head+0x2c>
  }
  bwrite(buf);
801028bc:	83 ec 0c             	sub    $0xc,%esp
801028bf:	53                   	push   %ebx
801028c0:	e8 bf d8 ff ff       	call   80100184 <bwrite>
  brelse(buf);
801028c5:	89 1c 24             	mov    %ebx,(%esp)
801028c8:	e8 ef d8 ff ff       	call   801001bc <brelse>
}
801028cd:	83 c4 10             	add    $0x10,%esp
801028d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028d3:	c9                   	leave  
801028d4:	c3                   	ret    
801028d5:	8d 76 00             	lea    0x0(%esi),%esi

801028d8 <initlog>:
{
801028d8:	55                   	push   %ebp
801028d9:	89 e5                	mov    %esp,%ebp
801028db:	53                   	push   %ebx
801028dc:	83 ec 2c             	sub    $0x2c,%esp
801028df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801028e2:	68 20 6f 10 80       	push   $0x80106f20
801028e7:	68 a0 16 11 80       	push   $0x801116a0
801028ec:	e8 53 15 00 00       	call   80103e44 <initlock>
  readsb(dev, &sb);
801028f1:	58                   	pop    %eax
801028f2:	5a                   	pop    %edx
801028f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801028f6:	50                   	push   %eax
801028f7:	53                   	push   %ebx
801028f8:	e8 8b ea ff ff       	call   80101388 <readsb>
  log.start = sb.logstart;
801028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102900:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102905:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102908:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  log.dev = dev;
8010290e:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  struct buf *buf = bread(log.dev, log.start);
80102914:	59                   	pop    %ecx
80102915:	5a                   	pop    %edx
80102916:	50                   	push   %eax
80102917:	53                   	push   %ebx
80102918:	e8 97 d7 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
8010291d:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102920:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102926:	83 c4 10             	add    $0x10,%esp
80102929:	85 db                	test   %ebx,%ebx
8010292b:	7e 13                	jle    80102940 <initlog+0x68>
8010292d:	31 d2                	xor    %edx,%edx
8010292f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102930:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102934:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010293b:	42                   	inc    %edx
8010293c:	39 d3                	cmp    %edx,%ebx
8010293e:	75 f0                	jne    80102930 <initlog+0x58>
  brelse(buf);
80102940:	83 ec 0c             	sub    $0xc,%esp
80102943:	50                   	push   %eax
80102944:	e8 73 d8 ff ff       	call   801001bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102949:	e8 a6 fe ff ff       	call   801027f4 <install_trans>
  log.lh.n = 0;
8010294e:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102955:	00 00 00 
  write_head(); // clear the log
80102958:	e8 23 ff ff ff       	call   80102880 <write_head>
}
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102963:	c9                   	leave  
80102964:	c3                   	ret    
80102965:	8d 76 00             	lea    0x0(%esi),%esi

80102968 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102968:	55                   	push   %ebp
80102969:	89 e5                	mov    %esp,%ebp
8010296b:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010296e:	68 a0 16 11 80       	push   $0x801116a0
80102973:	e8 84 16 00 00       	call   80103ffc <acquire>
80102978:	83 c4 10             	add    $0x10,%esp
8010297b:	eb 18                	jmp    80102995 <begin_op+0x2d>
8010297d:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102980:	83 ec 08             	sub    $0x8,%esp
80102983:	68 a0 16 11 80       	push   $0x801116a0
80102988:	68 a0 16 11 80       	push   $0x801116a0
8010298d:	e8 6a 11 00 00       	call   80103afc <sleep>
80102992:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102995:	a1 e0 16 11 80       	mov    0x801116e0,%eax
8010299a:	85 c0                	test   %eax,%eax
8010299c:	75 e2                	jne    80102980 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010299e:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801029a3:	8d 50 01             	lea    0x1(%eax),%edx
801029a6:	8d 44 80 05          	lea    0x5(%eax,%eax,4),%eax
801029aa:	01 c0                	add    %eax,%eax
801029ac:	03 05 e8 16 11 80    	add    0x801116e8,%eax
801029b2:	83 f8 1e             	cmp    $0x1e,%eax
801029b5:	7f c9                	jg     80102980 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
801029b7:	89 15 dc 16 11 80    	mov    %edx,0x801116dc
      release(&log.lock);
801029bd:	83 ec 0c             	sub    $0xc,%esp
801029c0:	68 a0 16 11 80       	push   $0x801116a0
801029c5:	e8 d2 15 00 00       	call   80103f9c <release>
      break;
    }
  }
}
801029ca:	83 c4 10             	add    $0x10,%esp
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
801029d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801029d9:	68 a0 16 11 80       	push   $0x801116a0
801029de:	e8 19 16 00 00       	call   80103ffc <acquire>
  log.outstanding -= 1;
801029e3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801029e8:	8d 58 ff             	lea    -0x1(%eax),%ebx
801029eb:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
801029f1:	83 c4 10             	add    $0x10,%esp
801029f4:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
801029fa:	85 f6                	test   %esi,%esi
801029fc:	0f 85 12 01 00 00    	jne    80102b14 <end_op+0x144>
    panic("log.committing");
  if(log.outstanding == 0){
80102a02:	85 db                	test   %ebx,%ebx
80102a04:	0f 85 e6 00 00 00    	jne    80102af0 <end_op+0x120>
    do_commit = 1;
    log.committing = 1;
80102a0a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102a11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102a14:	83 ec 0c             	sub    $0xc,%esp
80102a17:	68 a0 16 11 80       	push   $0x801116a0
80102a1c:	e8 7b 15 00 00       	call   80103f9c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102a2a:	85 c9                	test   %ecx,%ecx
80102a2c:	7f 3a                	jg     80102a68 <end_op+0x98>
    acquire(&log.lock);
80102a2e:	83 ec 0c             	sub    $0xc,%esp
80102a31:	68 a0 16 11 80       	push   $0x801116a0
80102a36:	e8 c1 15 00 00       	call   80103ffc <acquire>
    log.committing = 0;
80102a3b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102a42:	00 00 00 
    wakeup(&log);
80102a45:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102a4c:	e8 67 11 00 00       	call   80103bb8 <wakeup>
    release(&log.lock);
80102a51:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102a58:	e8 3f 15 00 00       	call   80103f9c <release>
80102a5d:	83 c4 10             	add    $0x10,%esp
}
80102a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a63:	5b                   	pop    %ebx
80102a64:	5e                   	pop    %esi
80102a65:	5f                   	pop    %edi
80102a66:	5d                   	pop    %ebp
80102a67:	c3                   	ret    
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102a68:	83 ec 08             	sub    $0x8,%esp
80102a6b:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102a70:	01 d8                	add    %ebx,%eax
80102a72:	40                   	inc    %eax
80102a73:	50                   	push   %eax
80102a74:	ff 35 e4 16 11 80    	push   0x801116e4
80102a7a:	e8 35 d6 ff ff       	call   801000b4 <bread>
80102a7f:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102a81:	58                   	pop    %eax
80102a82:	5a                   	pop    %edx
80102a83:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102a8a:	ff 35 e4 16 11 80    	push   0x801116e4
80102a90:	e8 1f d6 ff ff       	call   801000b4 <bread>
80102a95:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	8d 40 5c             	lea    0x5c(%eax),%eax
80102aa2:	50                   	push   %eax
80102aa3:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa6:	50                   	push   %eax
80102aa7:	e8 7c 16 00 00       	call   80104128 <memmove>
    bwrite(to);  // write the log
80102aac:	89 34 24             	mov    %esi,(%esp)
80102aaf:	e8 d0 d6 ff ff       	call   80100184 <bwrite>
    brelse(from);
80102ab4:	89 3c 24             	mov    %edi,(%esp)
80102ab7:	e8 00 d7 ff ff       	call   801001bc <brelse>
    brelse(to);
80102abc:	89 34 24             	mov    %esi,(%esp)
80102abf:	e8 f8 d6 ff ff       	call   801001bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac4:	43                   	inc    %ebx
80102ac5:	83 c4 10             	add    $0x10,%esp
80102ac8:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102ace:	7c 98                	jl     80102a68 <end_op+0x98>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ad0:	e8 ab fd ff ff       	call   80102880 <write_head>
    install_trans(); // Now install writes to home locations
80102ad5:	e8 1a fd ff ff       	call   801027f4 <install_trans>
    log.lh.n = 0;
80102ada:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ae1:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ae4:	e8 97 fd ff ff       	call   80102880 <write_head>
80102ae9:	e9 40 ff ff ff       	jmp    80102a2e <end_op+0x5e>
80102aee:	66 90                	xchg   %ax,%ax
    wakeup(&log);
80102af0:	83 ec 0c             	sub    $0xc,%esp
80102af3:	68 a0 16 11 80       	push   $0x801116a0
80102af8:	e8 bb 10 00 00       	call   80103bb8 <wakeup>
  release(&log.lock);
80102afd:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102b04:	e8 93 14 00 00       	call   80103f9c <release>
80102b09:	83 c4 10             	add    $0x10,%esp
}
80102b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5f                   	pop    %edi
80102b12:	5d                   	pop    %ebp
80102b13:	c3                   	ret    
    panic("log.committing");
80102b14:	83 ec 0c             	sub    $0xc,%esp
80102b17:	68 24 6f 10 80       	push   $0x80106f24
80102b1c:	e8 17 d8 ff ff       	call   80100338 <panic>
80102b21:	8d 76 00             	lea    0x0(%esi),%esi

80102b24 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102b24:	55                   	push   %ebp
80102b25:	89 e5                	mov    %esp,%ebp
80102b27:	53                   	push   %ebx
80102b28:	52                   	push   %edx
80102b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102b2c:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102b32:	83 fa 1d             	cmp    $0x1d,%edx
80102b35:	7f 79                	jg     80102bb0 <log_write+0x8c>
80102b37:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102b3c:	48                   	dec    %eax
80102b3d:	39 c2                	cmp    %eax,%edx
80102b3f:	7d 6f                	jge    80102bb0 <log_write+0x8c>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102b41:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102b46:	85 c0                	test   %eax,%eax
80102b48:	7e 73                	jle    80102bbd <log_write+0x99>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102b4a:	83 ec 0c             	sub    $0xc,%esp
80102b4d:	68 a0 16 11 80       	push   $0x801116a0
80102b52:	e8 a5 14 00 00       	call   80103ffc <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102b57:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	85 d2                	test   %edx,%edx
80102b62:	7e 40                	jle    80102ba4 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102b64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b67:	31 c0                	xor    %eax,%eax
80102b69:	eb 06                	jmp    80102b71 <log_write+0x4d>
80102b6b:	90                   	nop
80102b6c:	40                   	inc    %eax
80102b6d:	39 c2                	cmp    %eax,%edx
80102b6f:	74 23                	je     80102b94 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102b71:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102b78:	75 f2                	jne    80102b6c <log_write+0x48>
      break;
  }
  log.lh.block[i] = b->blockno;
80102b7a:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102b81:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102b84:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b8e:	c9                   	leave  
  release(&log.lock);
80102b8f:	e9 08 14 00 00       	jmp    80103f9c <release>
  log.lh.block[i] = b->blockno;
80102b94:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102b9b:	42                   	inc    %edx
80102b9c:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102ba2:	eb dd                	jmp    80102b81 <log_write+0x5d>
  log.lh.block[i] = b->blockno;
80102ba4:	8b 43 08             	mov    0x8(%ebx),%eax
80102ba7:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
80102bac:	75 d3                	jne    80102b81 <log_write+0x5d>
80102bae:	eb eb                	jmp    80102b9b <log_write+0x77>
    panic("too big a transaction");
80102bb0:	83 ec 0c             	sub    $0xc,%esp
80102bb3:	68 33 6f 10 80       	push   $0x80106f33
80102bb8:	e8 7b d7 ff ff       	call   80100338 <panic>
    panic("log_write outside of trans");
80102bbd:	83 ec 0c             	sub    $0xc,%esp
80102bc0:	68 49 6f 10 80       	push   $0x80106f49
80102bc5:	e8 6e d7 ff ff       	call   80100338 <panic>
80102bca:	66 90                	xchg   %ax,%ax

80102bcc <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102bcc:	55                   	push   %ebp
80102bcd:	89 e5                	mov    %esp,%ebp
80102bcf:	53                   	push   %ebx
80102bd0:	50                   	push   %eax
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102bd1:	e8 a2 08 00 00       	call   80103478 <cpuid>
80102bd6:	89 c3                	mov    %eax,%ebx
80102bd8:	e8 9b 08 00 00       	call   80103478 <cpuid>
80102bdd:	52                   	push   %edx
80102bde:	53                   	push   %ebx
80102bdf:	50                   	push   %eax
80102be0:	68 64 6f 10 80       	push   $0x80106f64
80102be5:	e8 32 da ff ff       	call   8010061c <cprintf>
  idtinit();       // load idt register
80102bea:	e8 29 25 00 00       	call   80105118 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102bef:	e8 20 08 00 00       	call   80103414 <mycpu>
80102bf4:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102bf6:	b8 01 00 00 00       	mov    $0x1,%eax
80102bfb:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102c02:	e8 31 0b 00 00       	call   80103738 <scheduler>
80102c07:	90                   	nop

80102c08 <mpenter>:
{
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102c0e:	e8 51 35 00 00       	call   80106164 <switchkvm>
  seginit();
80102c13:	e8 c8 34 00 00       	call   801060e0 <seginit>
  lapicinit();
80102c18:	e8 83 f8 ff ff       	call   801024a0 <lapicinit>
  mpmain();
80102c1d:	e8 aa ff ff ff       	call   80102bcc <mpmain>
80102c22:	66 90                	xchg   %ax,%ax

80102c24 <main>:
{
80102c24:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102c28:	83 e4 f0             	and    $0xfffffff0,%esp
80102c2b:	ff 71 fc             	push   -0x4(%ecx)
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	53                   	push   %ebx
80102c32:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102c33:	83 ec 08             	sub    $0x8,%esp
80102c36:	68 00 00 40 80       	push   $0x80400000
80102c3b:	68 a0 5e 11 80       	push   $0x80115ea0
80102c40:	e8 af f6 ff ff       	call   801022f4 <kinit1>
  kvmalloc();      // kernel page table
80102c45:	e8 9e 39 00 00       	call   801065e8 <kvmalloc>
  mpinit();        // detect other processors
80102c4a:	e8 61 01 00 00       	call   80102db0 <mpinit>
  lapicinit();     // interrupt controller
80102c4f:	e8 4c f8 ff ff       	call   801024a0 <lapicinit>
  seginit();       // segment descriptors
80102c54:	e8 87 34 00 00       	call   801060e0 <seginit>
  picinit();       // disable pic
80102c59:	e8 1a 03 00 00       	call   80102f78 <picinit>
  ioapicinit();    // another interrupt controller
80102c5e:	e8 91 f4 ff ff       	call   801020f4 <ioapicinit>
  consoleinit();   // console hardware
80102c63:	e8 40 dd ff ff       	call   801009a8 <consoleinit>
  uartinit();      // serial port
80102c68:	e8 4f 27 00 00       	call   801053bc <uartinit>
  pinit();         // process table
80102c6d:	e8 86 07 00 00       	call   801033f8 <pinit>
  tvinit();        // trap vectors
80102c72:	e8 35 24 00 00       	call   801050ac <tvinit>
  binit();         // buffer cache
80102c77:	e8 b8 d3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102c7c:	e8 a3 e0 ff ff       	call   80100d24 <fileinit>
  ideinit();       // disk 
80102c81:	e8 92 f2 ff ff       	call   80101f18 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102c86:	83 c4 0c             	add    $0xc,%esp
80102c89:	68 8a 00 00 00       	push   $0x8a
80102c8e:	68 90 a4 10 80       	push   $0x8010a490
80102c93:	68 00 70 00 80       	push   $0x80007000
80102c98:	e8 8b 14 00 00       	call   80104128 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102c9d:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102ca3:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102ca6:	01 c0                	add    %eax,%eax
80102ca8:	01 d0                	add    %edx,%eax
80102caa:	c1 e0 04             	shl    $0x4,%eax
80102cad:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102cb2:	83 c4 10             	add    $0x10,%esp
80102cb5:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80102cba:	76 74                	jbe    80102d30 <main+0x10c>
80102cbc:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80102cc1:	eb 20                	jmp    80102ce3 <main+0xbf>
80102cc3:	90                   	nop
80102cc4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102cca:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102cd0:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102cd3:	01 c0                	add    %eax,%eax
80102cd5:	01 d0                	add    %edx,%eax
80102cd7:	c1 e0 04             	shl    $0x4,%eax
80102cda:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102cdf:	39 c3                	cmp    %eax,%ebx
80102ce1:	73 4d                	jae    80102d30 <main+0x10c>
    if(c == mycpu())  // We've started already.
80102ce3:	e8 2c 07 00 00       	call   80103414 <mycpu>
80102ce8:	39 c3                	cmp    %eax,%ebx
80102cea:	74 d8                	je     80102cc4 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102cec:	e8 67 f6 ff ff       	call   80102358 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102cf1:	05 00 10 00 00       	add    $0x1000,%eax
80102cf6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102cfb:	c7 05 f8 6f 00 80 08 	movl   $0x80102c08,0x80006ff8
80102d02:	2c 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102d05:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102d0c:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102d0f:	83 ec 08             	sub    $0x8,%esp
80102d12:	68 00 70 00 00       	push   $0x7000
80102d17:	0f b6 03             	movzbl (%ebx),%eax
80102d1a:	50                   	push   %eax
80102d1b:	e8 94 f8 ff ff       	call   801025b4 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102d20:	83 c4 10             	add    $0x10,%esp
80102d23:	90                   	nop
80102d24:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102d2a:	85 c0                	test   %eax,%eax
80102d2c:	74 f6                	je     80102d24 <main+0x100>
80102d2e:	eb 94                	jmp    80102cc4 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102d30:	83 ec 08             	sub    $0x8,%esp
80102d33:	68 00 00 00 8e       	push   $0x8e000000
80102d38:	68 00 00 40 80       	push   $0x80400000
80102d3d:	e8 5e f5 ff ff       	call   801022a0 <kinit2>
  userinit();      // first user process
80102d42:	e8 89 07 00 00       	call   801034d0 <userinit>
  mpmain();        // finish this processor's setup
80102d47:	e8 80 fe ff ff       	call   80102bcc <mpmain>

80102d4c <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102d4c:	55                   	push   %ebp
80102d4d:	89 e5                	mov    %esp,%ebp
80102d4f:	57                   	push   %edi
80102d50:	56                   	push   %esi
80102d51:	53                   	push   %ebx
80102d52:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102d55:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
  e = addr+len;
80102d5b:	8d 9c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102d62:	39 de                	cmp    %ebx,%esi
80102d64:	72 0b                	jb     80102d71 <mpsearch1+0x25>
80102d66:	eb 3c                	jmp    80102da4 <mpsearch1+0x58>
80102d68:	8d 7e 10             	lea    0x10(%esi),%edi
80102d6b:	89 fe                	mov    %edi,%esi
80102d6d:	39 fb                	cmp    %edi,%ebx
80102d6f:	76 33                	jbe    80102da4 <mpsearch1+0x58>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102d71:	50                   	push   %eax
80102d72:	6a 04                	push   $0x4
80102d74:	68 78 6f 10 80       	push   $0x80106f78
80102d79:	56                   	push   %esi
80102d7a:	e8 71 13 00 00       	call   801040f0 <memcmp>
80102d7f:	83 c4 10             	add    $0x10,%esp
80102d82:	85 c0                	test   %eax,%eax
80102d84:	75 e2                	jne    80102d68 <mpsearch1+0x1c>
80102d86:	89 f2                	mov    %esi,%edx
80102d88:	8d 7e 10             	lea    0x10(%esi),%edi
80102d8b:	90                   	nop
    sum += addr[i];
80102d8c:	0f b6 0a             	movzbl (%edx),%ecx
80102d8f:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102d91:	42                   	inc    %edx
80102d92:	39 fa                	cmp    %edi,%edx
80102d94:	75 f6                	jne    80102d8c <mpsearch1+0x40>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102d96:	84 c0                	test   %al,%al
80102d98:	75 d1                	jne    80102d6b <mpsearch1+0x1f>
      return (struct mp*)p;
  return 0;
}
80102d9a:	89 f0                	mov    %esi,%eax
80102d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9f:	5b                   	pop    %ebx
80102da0:	5e                   	pop    %esi
80102da1:	5f                   	pop    %edi
80102da2:	5d                   	pop    %ebp
80102da3:	c3                   	ret    
  return 0;
80102da4:	31 f6                	xor    %esi,%esi
}
80102da6:	89 f0                	mov    %esi,%eax
80102da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dab:	5b                   	pop    %ebx
80102dac:	5e                   	pop    %esi
80102dad:	5f                   	pop    %edi
80102dae:	5d                   	pop    %ebp
80102daf:	c3                   	ret    

80102db0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102db9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102dc0:	c1 e0 08             	shl    $0x8,%eax
80102dc3:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102dca:	09 d0                	or     %edx,%eax
80102dcc:	c1 e0 04             	shl    $0x4,%eax
80102dcf:	75 1b                	jne    80102dec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102dd1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102dd8:	c1 e0 08             	shl    $0x8,%eax
80102ddb:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102de2:	09 d0                	or     %edx,%eax
80102de4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102de7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102dec:	ba 00 04 00 00       	mov    $0x400,%edx
80102df1:	e8 56 ff ff ff       	call   80102d4c <mpsearch1>
80102df6:	89 c3                	mov    %eax,%ebx
80102df8:	85 c0                	test   %eax,%eax
80102dfa:	0f 84 28 01 00 00    	je     80102f28 <mpinit+0x178>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102e00:	8b 73 04             	mov    0x4(%ebx),%esi
80102e03:	85 f6                	test   %esi,%esi
80102e05:	0f 84 0d 01 00 00    	je     80102f18 <mpinit+0x168>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102e0b:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102e11:	50                   	push   %eax
80102e12:	6a 04                	push   $0x4
80102e14:	68 7d 6f 10 80       	push   $0x80106f7d
80102e19:	57                   	push   %edi
80102e1a:	e8 d1 12 00 00       	call   801040f0 <memcmp>
80102e1f:	83 c4 10             	add    $0x10,%esp
80102e22:	85 c0                	test   %eax,%eax
80102e24:	0f 85 ee 00 00 00    	jne    80102f18 <mpinit+0x168>
  if(conf->version != 1 && conf->version != 4)
80102e2a:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102e30:	3c 01                	cmp    $0x1,%al
80102e32:	74 08                	je     80102e3c <mpinit+0x8c>
80102e34:	3c 04                	cmp    $0x4,%al
80102e36:	0f 85 dc 00 00 00    	jne    80102f18 <mpinit+0x168>
  if(sum((uchar*)conf, conf->length) != 0)
80102e3c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80102e43:	66 85 d2             	test   %dx,%dx
80102e46:	74 1f                	je     80102e67 <mpinit+0xb7>
80102e48:	89 f8                	mov    %edi,%eax
80102e4a:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
80102e4d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  sum = 0;
80102e50:	31 d2                	xor    %edx,%edx
80102e52:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80102e54:	0f b6 08             	movzbl (%eax),%ecx
80102e57:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80102e59:	40                   	inc    %eax
80102e5a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80102e5d:	75 f5                	jne    80102e54 <mpinit+0xa4>
  if(sum((uchar*)conf, conf->length) != 0)
80102e5f:	84 d2                	test   %dl,%dl
80102e61:	0f 85 b1 00 00 00    	jne    80102f18 <mpinit+0x168>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102e67:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80102e6d:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e72:	8d 96 2c 00 00 80    	lea    -0x7fffffd4(%esi),%edx
80102e78:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80102e7f:	01 f9                	add    %edi,%ecx
  ismp = 1;
80102e81:	be 01 00 00 00       	mov    $0x1,%esi
80102e86:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102e89:	8d 76 00             	lea    0x0(%esi),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e8c:	39 ca                	cmp    %ecx,%edx
80102e8e:	73 13                	jae    80102ea3 <mpinit+0xf3>
    switch(*p){
80102e90:	8a 02                	mov    (%edx),%al
80102e92:	3c 02                	cmp    $0x2,%al
80102e94:	74 46                	je     80102edc <mpinit+0x12c>
80102e96:	77 38                	ja     80102ed0 <mpinit+0x120>
80102e98:	84 c0                	test   %al,%al
80102e9a:	74 50                	je     80102eec <mpinit+0x13c>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102e9c:	83 c2 08             	add    $0x8,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e9f:	39 ca                	cmp    %ecx,%edx
80102ea1:	72 ed                	jb     80102e90 <mpinit+0xe0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102ea3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80102ea6:	85 f6                	test   %esi,%esi
80102ea8:	0f 84 bd 00 00 00    	je     80102f6b <mpinit+0x1bb>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102eae:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80102eb2:	74 12                	je     80102ec6 <mpinit+0x116>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb4:	b0 70                	mov    $0x70,%al
80102eb6:	ba 22 00 00 00       	mov    $0x22,%edx
80102ebb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebc:	ba 23 00 00 00       	mov    $0x23,%edx
80102ec1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102ec2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec5:	ee                   	out    %al,(%dx)
  }
}
80102ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ec9:	5b                   	pop    %ebx
80102eca:	5e                   	pop    %esi
80102ecb:	5f                   	pop    %edi
80102ecc:	5d                   	pop    %ebp
80102ecd:	c3                   	ret    
80102ece:	66 90                	xchg   %ax,%ax
    switch(*p){
80102ed0:	83 e8 03             	sub    $0x3,%eax
80102ed3:	3c 01                	cmp    $0x1,%al
80102ed5:	76 c5                	jbe    80102e9c <mpinit+0xec>
80102ed7:	31 f6                	xor    %esi,%esi
80102ed9:	eb b1                	jmp    80102e8c <mpinit+0xdc>
80102edb:	90                   	nop
      ioapicid = ioapic->apicno;
80102edc:	8a 42 01             	mov    0x1(%edx),%al
80102edf:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102ee4:	83 c2 08             	add    $0x8,%edx
      continue;
80102ee7:	eb a3                	jmp    80102e8c <mpinit+0xdc>
80102ee9:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80102eec:	a1 84 17 11 80       	mov    0x80111784,%eax
80102ef1:	83 f8 07             	cmp    $0x7,%eax
80102ef4:	7f 19                	jg     80102f0f <mpinit+0x15f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102ef6:	8d 3c 80             	lea    (%eax,%eax,4),%edi
80102ef9:	01 ff                	add    %edi,%edi
80102efb:	01 c7                	add    %eax,%edi
80102efd:	c1 e7 04             	shl    $0x4,%edi
80102f00:	8a 5a 01             	mov    0x1(%edx),%bl
80102f03:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
        ncpu++;
80102f09:	40                   	inc    %eax
80102f0a:	a3 84 17 11 80       	mov    %eax,0x80111784
      p += sizeof(struct mpproc);
80102f0f:	83 c2 14             	add    $0x14,%edx
      continue;
80102f12:	e9 75 ff ff ff       	jmp    80102e8c <mpinit+0xdc>
80102f17:	90                   	nop
    panic("Expect to run on an SMP");
80102f18:	83 ec 0c             	sub    $0xc,%esp
80102f1b:	68 82 6f 10 80       	push   $0x80106f82
80102f20:	e8 13 d4 ff ff       	call   80100338 <panic>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
{
80102f28:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80102f2d:	eb 0e                	jmp    80102f3d <mpinit+0x18d>
80102f2f:	90                   	nop
80102f30:	8d 73 10             	lea    0x10(%ebx),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102f33:	89 f3                	mov    %esi,%ebx
80102f35:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80102f3b:	74 db                	je     80102f18 <mpinit+0x168>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f3d:	52                   	push   %edx
80102f3e:	6a 04                	push   $0x4
80102f40:	68 78 6f 10 80       	push   $0x80106f78
80102f45:	53                   	push   %ebx
80102f46:	e8 a5 11 00 00       	call   801040f0 <memcmp>
80102f4b:	83 c4 10             	add    $0x10,%esp
80102f4e:	85 c0                	test   %eax,%eax
80102f50:	75 de                	jne    80102f30 <mpinit+0x180>
80102f52:	89 da                	mov    %ebx,%edx
80102f54:	8d 73 10             	lea    0x10(%ebx),%esi
80102f57:	90                   	nop
    sum += addr[i];
80102f58:	0f b6 0a             	movzbl (%edx),%ecx
80102f5b:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80102f5d:	42                   	inc    %edx
80102f5e:	39 d6                	cmp    %edx,%esi
80102f60:	75 f6                	jne    80102f58 <mpinit+0x1a8>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f62:	84 c0                	test   %al,%al
80102f64:	75 cd                	jne    80102f33 <mpinit+0x183>
80102f66:	e9 95 fe ff ff       	jmp    80102e00 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80102f6b:	83 ec 0c             	sub    $0xc,%esp
80102f6e:	68 9c 6f 10 80       	push   $0x80106f9c
80102f73:	e8 c0 d3 ff ff       	call   80100338 <panic>

80102f78 <picinit>:
80102f78:	b0 ff                	mov    $0xff,%al
80102f7a:	ba 21 00 00 00       	mov    $0x21,%edx
80102f7f:	ee                   	out    %al,(%dx)
80102f80:	ba a1 00 00 00       	mov    $0xa1,%edx
80102f85:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102f86:	c3                   	ret    
80102f87:	90                   	nop

80102f88 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102f88:	55                   	push   %ebp
80102f89:	89 e5                	mov    %esp,%ebp
80102f8b:	57                   	push   %edi
80102f8c:	56                   	push   %esi
80102f8d:	53                   	push   %ebx
80102f8e:	83 ec 0c             	sub    $0xc,%esp
80102f91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f94:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102f97:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102f9d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102fa3:	e8 98 dd ff ff       	call   80100d40 <filealloc>
80102fa8:	89 03                	mov    %eax,(%ebx)
80102faa:	85 c0                	test   %eax,%eax
80102fac:	0f 84 a8 00 00 00    	je     8010305a <pipealloc+0xd2>
80102fb2:	e8 89 dd ff ff       	call   80100d40 <filealloc>
80102fb7:	89 06                	mov    %eax,(%esi)
80102fb9:	85 c0                	test   %eax,%eax
80102fbb:	0f 84 87 00 00 00    	je     80103048 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102fc1:	e8 92 f3 ff ff       	call   80102358 <kalloc>
80102fc6:	89 c7                	mov    %eax,%edi
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	0f 84 ac 00 00 00    	je     8010307c <pipealloc+0xf4>
    goto bad;
  p->readopen = 1;
80102fd0:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102fd7:	00 00 00 
  p->writeopen = 1;
80102fda:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102fe1:	00 00 00 
  p->nwrite = 0;
80102fe4:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102feb:	00 00 00 
  p->nread = 0;
80102fee:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102ff5:	00 00 00 
  initlock(&p->lock, "pipe");
80102ff8:	83 ec 08             	sub    $0x8,%esp
80102ffb:	68 bb 6f 10 80       	push   $0x80106fbb
80103000:	50                   	push   %eax
80103001:	e8 3e 0e 00 00       	call   80103e44 <initlock>
  (*f0)->type = FD_PIPE;
80103006:	8b 03                	mov    (%ebx),%eax
80103008:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010300e:	8b 03                	mov    (%ebx),%eax
80103010:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103014:	8b 03                	mov    (%ebx),%eax
80103016:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010301a:	8b 03                	mov    (%ebx),%eax
8010301c:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010301f:	8b 06                	mov    (%esi),%eax
80103021:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103027:	8b 06                	mov    (%esi),%eax
80103029:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010302d:	8b 06                	mov    (%esi),%eax
8010302f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103033:	8b 06                	mov    (%esi),%eax
80103035:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80103038:	83 c4 10             	add    $0x10,%esp
8010303b:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
8010303d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103040:	5b                   	pop    %ebx
80103041:	5e                   	pop    %esi
80103042:	5f                   	pop    %edi
80103043:	5d                   	pop    %ebp
80103044:	c3                   	ret    
80103045:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103048:	8b 03                	mov    (%ebx),%eax
8010304a:	85 c0                	test   %eax,%eax
8010304c:	74 1e                	je     8010306c <pipealloc+0xe4>
    fileclose(*f0);
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	50                   	push   %eax
80103052:	e8 8d dd ff ff       	call   80100de4 <fileclose>
80103057:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010305a:	8b 06                	mov    (%esi),%eax
8010305c:	85 c0                	test   %eax,%eax
8010305e:	74 0c                	je     8010306c <pipealloc+0xe4>
    fileclose(*f1);
80103060:	83 ec 0c             	sub    $0xc,%esp
80103063:	50                   	push   %eax
80103064:	e8 7b dd ff ff       	call   80100de4 <fileclose>
80103069:	83 c4 10             	add    $0x10,%esp
  return -1;
8010306c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103074:	5b                   	pop    %ebx
80103075:	5e                   	pop    %esi
80103076:	5f                   	pop    %edi
80103077:	5d                   	pop    %ebp
80103078:	c3                   	ret    
80103079:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
8010307c:	8b 03                	mov    (%ebx),%eax
8010307e:	85 c0                	test   %eax,%eax
80103080:	75 cc                	jne    8010304e <pipealloc+0xc6>
80103082:	eb d6                	jmp    8010305a <pipealloc+0xd2>

80103084 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	56                   	push   %esi
80103088:	53                   	push   %ebx
80103089:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010308c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
80103092:	53                   	push   %ebx
80103093:	e8 64 0f 00 00       	call   80103ffc <acquire>
  if(writable){
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	85 f6                	test   %esi,%esi
8010309d:	74 5d                	je     801030fc <pipeclose+0x78>
    p->writeopen = 0;
8010309f:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801030a6:	00 00 00 
    wakeup(&p->nread);
801030a9:	83 ec 0c             	sub    $0xc,%esp
801030ac:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801030b2:	50                   	push   %eax
801030b3:	e8 00 0b 00 00       	call   80103bb8 <wakeup>
801030b8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801030bb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801030c1:	85 d2                	test   %edx,%edx
801030c3:	75 0a                	jne    801030cf <pipeclose+0x4b>
801030c5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801030cb:	85 c0                	test   %eax,%eax
801030cd:	74 11                	je     801030e0 <pipeclose+0x5c>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801030cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801030d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030d5:	5b                   	pop    %ebx
801030d6:	5e                   	pop    %esi
801030d7:	5d                   	pop    %ebp
    release(&p->lock);
801030d8:	e9 bf 0e 00 00       	jmp    80103f9c <release>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&p->lock);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	53                   	push   %ebx
801030e4:	e8 b3 0e 00 00       	call   80103f9c <release>
    kfree((char*)p);
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801030ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030f2:	5b                   	pop    %ebx
801030f3:	5e                   	pop    %esi
801030f4:	5d                   	pop    %ebp
    kfree((char*)p);
801030f5:	e9 ce f0 ff ff       	jmp    801021c8 <kfree>
801030fa:	66 90                	xchg   %ax,%ax
    p->readopen = 0;
801030fc:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103103:	00 00 00 
    wakeup(&p->nwrite);
80103106:	83 ec 0c             	sub    $0xc,%esp
80103109:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010310f:	50                   	push   %eax
80103110:	e8 a3 0a 00 00       	call   80103bb8 <wakeup>
80103115:	83 c4 10             	add    $0x10,%esp
80103118:	eb a1                	jmp    801030bb <pipeclose+0x37>
8010311a:	66 90                	xchg   %ax,%ax

8010311c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010311c:	55                   	push   %ebp
8010311d:	89 e5                	mov    %esp,%ebp
8010311f:	57                   	push   %edi
80103120:	56                   	push   %esi
80103121:	53                   	push   %ebx
80103122:	83 ec 28             	sub    $0x28,%esp
80103125:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103128:	53                   	push   %ebx
80103129:	e8 ce 0e 00 00       	call   80103ffc <acquire>
  for(i = 0; i < n; i++){
8010312e:	83 c4 10             	add    $0x10,%esp
80103131:	8b 45 10             	mov    0x10(%ebp),%eax
80103134:	85 c0                	test   %eax,%eax
80103136:	0f 8e b1 00 00 00    	jle    801031ed <pipewrite+0xd1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010313c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103145:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103148:	03 4d 10             	add    0x10(%ebp),%ecx
8010314b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010314e:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103154:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010315a:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103160:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103166:	39 d0                	cmp    %edx,%eax
80103168:	74 38                	je     801031a2 <pipewrite+0x86>
8010316a:	eb 59                	jmp    801031c5 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
8010316c:	e8 3b 03 00 00       	call   801034ac <myproc>
80103171:	8b 48 24             	mov    0x24(%eax),%ecx
80103174:	85 c9                	test   %ecx,%ecx
80103176:	75 34                	jne    801031ac <pipewrite+0x90>
      wakeup(&p->nread);
80103178:	83 ec 0c             	sub    $0xc,%esp
8010317b:	57                   	push   %edi
8010317c:	e8 37 0a 00 00       	call   80103bb8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103181:	58                   	pop    %eax
80103182:	5a                   	pop    %edx
80103183:	53                   	push   %ebx
80103184:	56                   	push   %esi
80103185:	e8 72 09 00 00       	call   80103afc <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010318a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103190:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103196:	05 00 02 00 00       	add    $0x200,%eax
8010319b:	83 c4 10             	add    $0x10,%esp
8010319e:	39 c2                	cmp    %eax,%edx
801031a0:	75 26                	jne    801031c8 <pipewrite+0xac>
      if(p->readopen == 0 || myproc()->killed){
801031a2:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801031a8:	85 c0                	test   %eax,%eax
801031aa:	75 c0                	jne    8010316c <pipewrite+0x50>
        release(&p->lock);
801031ac:	83 ec 0c             	sub    $0xc,%esp
801031af:	53                   	push   %ebx
801031b0:	e8 e7 0d 00 00       	call   80103f9c <release>
        return -1;
801031b5:	83 c4 10             	add    $0x10,%esp
801031b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801031c5:	89 c2                	mov    %eax,%edx
801031c7:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801031c8:	8d 42 01             	lea    0x1(%edx),%eax
801031cb:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801031d1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801031d4:	8a 0e                	mov    (%esi),%cl
801031d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801031dc:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801031e0:	46                   	inc    %esi
801031e1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801031e4:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801031e7:	0f 85 67 ff ff ff    	jne    80103154 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801031ed:	83 ec 0c             	sub    $0xc,%esp
801031f0:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801031f6:	50                   	push   %eax
801031f7:	e8 bc 09 00 00       	call   80103bb8 <wakeup>
  release(&p->lock);
801031fc:	89 1c 24             	mov    %ebx,(%esp)
801031ff:	e8 98 0d 00 00       	call   80103f9c <release>
  return n;
80103204:	83 c4 10             	add    $0x10,%esp
80103207:	8b 45 10             	mov    0x10(%ebp),%eax
8010320a:	eb b1                	jmp    801031bd <pipewrite+0xa1>

8010320c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010320c:	55                   	push   %ebp
8010320d:	89 e5                	mov    %esp,%ebp
8010320f:	57                   	push   %edi
80103210:	56                   	push   %esi
80103211:	53                   	push   %ebx
80103212:	83 ec 18             	sub    $0x18,%esp
80103215:	8b 75 08             	mov    0x8(%ebp),%esi
80103218:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010321b:	56                   	push   %esi
8010321c:	e8 db 0d 00 00       	call   80103ffc <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103221:	83 c4 10             	add    $0x10,%esp
80103224:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010322a:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103230:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103236:	74 2f                	je     80103267 <piperead+0x5b>
80103238:	eb 37                	jmp    80103271 <piperead+0x65>
8010323a:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
8010323c:	e8 6b 02 00 00       	call   801034ac <myproc>
80103241:	8b 48 24             	mov    0x24(%eax),%ecx
80103244:	85 c9                	test   %ecx,%ecx
80103246:	0f 85 80 00 00 00    	jne    801032cc <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010324c:	83 ec 08             	sub    $0x8,%esp
8010324f:	56                   	push   %esi
80103250:	53                   	push   %ebx
80103251:	e8 a6 08 00 00       	call   80103afc <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103256:	83 c4 10             	add    $0x10,%esp
80103259:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
8010325f:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103265:	75 0a                	jne    80103271 <piperead+0x65>
80103267:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
8010326d:	85 c0                	test   %eax,%eax
8010326f:	75 cb                	jne    8010323c <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103271:	31 db                	xor    %ebx,%ebx
80103273:	8b 55 10             	mov    0x10(%ebp),%edx
80103276:	85 d2                	test   %edx,%edx
80103278:	7f 1d                	jg     80103297 <piperead+0x8b>
8010327a:	eb 29                	jmp    801032a5 <piperead+0x99>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010327c:	8d 48 01             	lea    0x1(%eax),%ecx
8010327f:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103285:	25 ff 01 00 00       	and    $0x1ff,%eax
8010328a:	8a 44 06 34          	mov    0x34(%esi,%eax,1),%al
8010328e:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103291:	43                   	inc    %ebx
80103292:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103295:	74 0e                	je     801032a5 <piperead+0x99>
    if(p->nread == p->nwrite)
80103297:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010329d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801032a3:	75 d7                	jne    8010327c <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801032a5:	83 ec 0c             	sub    $0xc,%esp
801032a8:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801032ae:	50                   	push   %eax
801032af:	e8 04 09 00 00       	call   80103bb8 <wakeup>
  release(&p->lock);
801032b4:	89 34 24             	mov    %esi,(%esp)
801032b7:	e8 e0 0c 00 00       	call   80103f9c <release>
  return i;
801032bc:	83 c4 10             	add    $0x10,%esp
}
801032bf:	89 d8                	mov    %ebx,%eax
801032c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032c4:	5b                   	pop    %ebx
801032c5:	5e                   	pop    %esi
801032c6:	5f                   	pop    %edi
801032c7:	5d                   	pop    %ebp
801032c8:	c3                   	ret    
801032c9:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
801032cc:	83 ec 0c             	sub    $0xc,%esp
801032cf:	56                   	push   %esi
801032d0:	e8 c7 0c 00 00       	call   80103f9c <release>
      return -1;
801032d5:	83 c4 10             	add    $0x10,%esp
801032d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801032dd:	89 d8                	mov    %ebx,%eax
801032df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	90                   	nop

801032e8 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801032e8:	55                   	push   %ebp
801032e9:	89 e5                	mov    %esp,%ebp
801032eb:	53                   	push   %ebx
801032ec:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801032ef:	68 20 1d 11 80       	push   $0x80111d20
801032f4:	e8 03 0d 00 00       	call   80103ffc <acquire>
801032f9:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801032fc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103301:	eb 0c                	jmp    8010330f <allocproc+0x27>
80103303:	90                   	nop
80103304:	83 c3 7c             	add    $0x7c,%ebx
80103307:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010330d:	74 75                	je     80103384 <allocproc+0x9c>
    if(p->state == UNUSED)
8010330f:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80103312:	85 c9                	test   %ecx,%ecx
80103314:	75 ee                	jne    80103304 <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103316:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010331d:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103322:	8d 50 01             	lea    0x1(%eax),%edx
80103325:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010332b:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
8010332e:	83 ec 0c             	sub    $0xc,%esp
80103331:	68 20 1d 11 80       	push   $0x80111d20
80103336:	e8 61 0c 00 00       	call   80103f9c <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010333b:	e8 18 f0 ff ff       	call   80102358 <kalloc>
80103340:	89 43 08             	mov    %eax,0x8(%ebx)
80103343:	83 c4 10             	add    $0x10,%esp
80103346:	85 c0                	test   %eax,%eax
80103348:	74 53                	je     8010339d <allocproc+0xb5>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010334a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103350:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103353:	c7 80 b0 0f 00 00 a1 	movl   $0x801050a1,0xfb0(%eax)
8010335a:	50 10 80 

  sp -= sizeof *p->context;
8010335d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103362:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103365:	52                   	push   %edx
80103366:	6a 14                	push   $0x14
80103368:	6a 00                	push   $0x0
8010336a:	50                   	push   %eax
8010336b:	e8 34 0d 00 00       	call   801040a4 <memset>
  p->context->eip = (uint)forkret;
80103370:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103373:	c7 40 10 b0 33 10 80 	movl   $0x801033b0,0x10(%eax)

  return p;
8010337a:	83 c4 10             	add    $0x10,%esp
}
8010337d:	89 d8                	mov    %ebx,%eax
8010337f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103382:	c9                   	leave  
80103383:	c3                   	ret    
  release(&ptable.lock);
80103384:	83 ec 0c             	sub    $0xc,%esp
80103387:	68 20 1d 11 80       	push   $0x80111d20
8010338c:	e8 0b 0c 00 00       	call   80103f9c <release>
  return 0;
80103391:	83 c4 10             	add    $0x10,%esp
80103394:	31 db                	xor    %ebx,%ebx
}
80103396:	89 d8                	mov    %ebx,%eax
80103398:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010339b:	c9                   	leave  
8010339c:	c3                   	ret    
    p->state = UNUSED;
8010339d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801033a4:	31 db                	xor    %ebx,%ebx
}
801033a6:	89 d8                	mov    %ebx,%eax
801033a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033ab:	c9                   	leave  
801033ac:	c3                   	ret    
801033ad:	8d 76 00             	lea    0x0(%esi),%esi

801033b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801033b6:	68 20 1d 11 80       	push   $0x80111d20
801033bb:	e8 dc 0b 00 00       	call   80103f9c <release>

  if (first) {
801033c0:	83 c4 10             	add    $0x10,%esp
801033c3:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801033c8:	85 c0                	test   %eax,%eax
801033ca:	75 04                	jne    801033d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801033cc:	c9                   	leave  
801033cd:	c3                   	ret    
801033ce:	66 90                	xchg   %ax,%ax
    first = 0;
801033d0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801033d7:	00 00 00 
    iinit(ROOTDEV);
801033da:	83 ec 0c             	sub    $0xc,%esp
801033dd:	6a 01                	push   $0x1
801033df:	e8 dc df ff ff       	call   801013c0 <iinit>
    initlog(ROOTDEV);
801033e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801033eb:	e8 e8 f4 ff ff       	call   801028d8 <initlog>
}
801033f0:	83 c4 10             	add    $0x10,%esp
801033f3:	c9                   	leave  
801033f4:	c3                   	ret    
801033f5:	8d 76 00             	lea    0x0(%esi),%esi

801033f8 <pinit>:
{
801033f8:	55                   	push   %ebp
801033f9:	89 e5                	mov    %esp,%ebp
801033fb:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801033fe:	68 c0 6f 10 80       	push   $0x80106fc0
80103403:	68 20 1d 11 80       	push   $0x80111d20
80103408:	e8 37 0a 00 00       	call   80103e44 <initlock>
}
8010340d:	83 c4 10             	add    $0x10,%esp
80103410:	c9                   	leave  
80103411:	c3                   	ret    
80103412:	66 90                	xchg   %ax,%ax

80103414 <mycpu>:
{
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	56                   	push   %esi
80103418:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103419:	9c                   	pushf  
8010341a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010341b:	f6 c4 02             	test   $0x2,%ah
8010341e:	75 4b                	jne    8010346b <mycpu+0x57>
  apicid = lapicid();
80103420:	e8 5f f1 ff ff       	call   80102584 <lapicid>
80103425:	89 c1                	mov    %eax,%ecx
  for (i = 0; i < ncpu; ++i) {
80103427:	8b 1d 84 17 11 80    	mov    0x80111784,%ebx
8010342d:	85 db                	test   %ebx,%ebx
8010342f:	7e 2d                	jle    8010345e <mycpu+0x4a>
80103431:	31 d2                	xor    %edx,%edx
80103433:	eb 08                	jmp    8010343d <mycpu+0x29>
80103435:	8d 76 00             	lea    0x0(%esi),%esi
80103438:	42                   	inc    %edx
80103439:	39 da                	cmp    %ebx,%edx
8010343b:	74 21                	je     8010345e <mycpu+0x4a>
    if (cpus[i].apicid == apicid)
8010343d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103440:	01 c0                	add    %eax,%eax
80103442:	01 d0                	add    %edx,%eax
80103444:	c1 e0 04             	shl    $0x4,%eax
80103447:	0f b6 b0 a0 17 11 80 	movzbl -0x7feee860(%eax),%esi
8010344e:	39 ce                	cmp    %ecx,%esi
80103450:	75 e6                	jne    80103438 <mycpu+0x24>
      return &cpus[i];
80103452:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010345a:	5b                   	pop    %ebx
8010345b:	5e                   	pop    %esi
8010345c:	5d                   	pop    %ebp
8010345d:	c3                   	ret    
  panic("unknown apicid\n");
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	68 c7 6f 10 80       	push   $0x80106fc7
80103466:	e8 cd ce ff ff       	call   80100338 <panic>
    panic("mycpu called with interrupts enabled\n");
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	68 a4 70 10 80       	push   $0x801070a4
80103473:	e8 c0 ce ff ff       	call   80100338 <panic>

80103478 <cpuid>:
cpuid() {
80103478:	55                   	push   %ebp
80103479:	89 e5                	mov    %esp,%ebp
8010347b:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010347e:	e8 91 ff ff ff       	call   80103414 <mycpu>
80103483:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103488:	c1 f8 04             	sar    $0x4,%eax
8010348b:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
8010348e:	89 ca                	mov    %ecx,%edx
80103490:	c1 e2 05             	shl    $0x5,%edx
80103493:	29 ca                	sub    %ecx,%edx
80103495:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103498:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010349b:	89 ca                	mov    %ecx,%edx
8010349d:	c1 e2 0f             	shl    $0xf,%edx
801034a0:	29 ca                	sub    %ecx,%edx
801034a2:	8d 04 90             	lea    (%eax,%edx,4),%eax
801034a5:	f7 d8                	neg    %eax
}
801034a7:	c9                   	leave  
801034a8:	c3                   	ret    
801034a9:	8d 76 00             	lea    0x0(%esi),%esi

801034ac <myproc>:
myproc(void) {
801034ac:	55                   	push   %ebp
801034ad:	89 e5                	mov    %esp,%ebp
801034af:	83 ec 18             	sub    $0x18,%esp
  pushcli();
801034b2:	e8 f9 09 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
801034b7:	e8 58 ff ff ff       	call   80103414 <mycpu>
  p = c->proc;
801034bc:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801034c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
801034c5:	e8 32 0a 00 00       	call   80103efc <popcli>
}
801034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034cd:	c9                   	leave  
801034ce:	c3                   	ret    
801034cf:	90                   	nop

801034d0 <userinit>:
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
801034d4:	51                   	push   %ecx
  p = allocproc();
801034d5:	e8 0e fe ff ff       	call   801032e8 <allocproc>
801034da:	89 c3                	mov    %eax,%ebx
  initproc = p;
801034dc:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
801034e1:	e8 8e 30 00 00       	call   80106574 <setupkvm>
801034e6:	89 43 04             	mov    %eax,0x4(%ebx)
801034e9:	85 c0                	test   %eax,%eax
801034eb:	0f 84 b3 00 00 00    	je     801035a4 <userinit+0xd4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801034f1:	52                   	push   %edx
801034f2:	68 2c 00 00 00       	push   $0x2c
801034f7:	68 64 a4 10 80       	push   $0x8010a464
801034fc:	50                   	push   %eax
801034fd:	e8 6e 2d 00 00       	call   80106270 <inituvm>
  p->sz = PGSIZE;
80103502:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103508:	83 c4 0c             	add    $0xc,%esp
8010350b:	6a 4c                	push   $0x4c
8010350d:	6a 00                	push   $0x0
8010350f:	ff 73 18             	push   0x18(%ebx)
80103512:	e8 8d 0b 00 00       	call   801040a4 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103517:	8b 43 18             	mov    0x18(%ebx),%eax
8010351a:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103520:	8b 43 18             	mov    0x18(%ebx),%eax
80103523:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103529:	8b 43 18             	mov    0x18(%ebx),%eax
8010352c:	8b 50 2c             	mov    0x2c(%eax),%edx
8010352f:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103533:	8b 43 18             	mov    0x18(%ebx),%eax
80103536:	8b 50 2c             	mov    0x2c(%eax),%edx
80103539:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010353d:	8b 43 18             	mov    0x18(%ebx),%eax
80103540:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103547:	8b 43 18             	mov    0x18(%ebx),%eax
8010354a:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103551:	8b 43 18             	mov    0x18(%ebx),%eax
80103554:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010355b:	83 c4 0c             	add    $0xc,%esp
8010355e:	6a 10                	push   $0x10
80103560:	68 f0 6f 10 80       	push   $0x80106ff0
80103565:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103568:	50                   	push   %eax
80103569:	e8 8a 0c 00 00       	call   801041f8 <safestrcpy>
  p->cwd = namei("/");
8010356e:	c7 04 24 f9 6f 10 80 	movl   $0x80106ff9,(%esp)
80103575:	e8 ba e8 ff ff       	call   80101e34 <namei>
8010357a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010357d:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103584:	e8 73 0a 00 00       	call   80103ffc <acquire>
  p->state = RUNNABLE;
80103589:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103590:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103597:	e8 00 0a 00 00       	call   80103f9c <release>
}
8010359c:	83 c4 10             	add    $0x10,%esp
8010359f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035a2:	c9                   	leave  
801035a3:	c3                   	ret    
    panic("userinit: out of memory?");
801035a4:	83 ec 0c             	sub    $0xc,%esp
801035a7:	68 d7 6f 10 80       	push   $0x80106fd7
801035ac:	e8 87 cd ff ff       	call   80100338 <panic>
801035b1:	8d 76 00             	lea    0x0(%esi),%esi

801035b4 <growproc>:
{
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	56                   	push   %esi
801035b8:	53                   	push   %ebx
801035b9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801035bc:	e8 ef 08 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
801035c1:	e8 4e fe ff ff       	call   80103414 <mycpu>
  p = c->proc;
801035c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801035cc:	e8 2b 09 00 00       	call   80103efc <popcli>
  sz = curproc->sz;
801035d1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801035d3:	85 f6                	test   %esi,%esi
801035d5:	7f 19                	jg     801035f0 <growproc+0x3c>
  } else if(n < 0){
801035d7:	75 33                	jne    8010360c <growproc+0x58>
  curproc->sz = sz;
801035d9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	53                   	push   %ebx
801035df:	e8 90 2b 00 00       	call   80106174 <switchuvm>
  return 0;
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	31 c0                	xor    %eax,%eax
}
801035e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5d                   	pop    %ebp
801035ef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801035f0:	51                   	push   %ecx
801035f1:	01 c6                	add    %eax,%esi
801035f3:	56                   	push   %esi
801035f4:	50                   	push   %eax
801035f5:	ff 73 04             	push   0x4(%ebx)
801035f8:	e8 c3 2d 00 00       	call   801063c0 <allocuvm>
801035fd:	83 c4 10             	add    $0x10,%esp
80103600:	85 c0                	test   %eax,%eax
80103602:	75 d5                	jne    801035d9 <growproc+0x25>
      return -1;
80103604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103609:	eb de                	jmp    801035e9 <growproc+0x35>
8010360b:	90                   	nop
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010360c:	52                   	push   %edx
8010360d:	01 c6                	add    %eax,%esi
8010360f:	56                   	push   %esi
80103610:	50                   	push   %eax
80103611:	ff 73 04             	push   0x4(%ebx)
80103614:	e8 cf 2e 00 00       	call   801064e8 <deallocuvm>
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	75 b9                	jne    801035d9 <growproc+0x25>
80103620:	eb e2                	jmp    80103604 <growproc+0x50>
80103622:	66 90                	xchg   %ax,%ax

80103624 <fork>:
{
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	57                   	push   %edi
80103628:	56                   	push   %esi
80103629:	53                   	push   %ebx
8010362a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010362d:	e8 7e 08 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
80103632:	e8 dd fd ff ff       	call   80103414 <mycpu>
  p = c->proc;
80103637:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010363d:	e8 ba 08 00 00       	call   80103efc <popcli>
  if((np = allocproc()) == 0){
80103642:	e8 a1 fc ff ff       	call   801032e8 <allocproc>
80103647:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010364a:	85 c0                	test   %eax,%eax
8010364c:	0f 84 b9 00 00 00    	je     8010370b <fork+0xe7>
80103652:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103654:	83 ec 08             	sub    $0x8,%esp
80103657:	ff 33                	push   (%ebx)
80103659:	ff 73 04             	push   0x4(%ebx)
8010365c:	e8 eb 2f 00 00       	call   8010664c <copyuvm>
80103661:	89 47 04             	mov    %eax,0x4(%edi)
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	85 c0                	test   %eax,%eax
80103669:	0f 84 a3 00 00 00    	je     80103712 <fork+0xee>
  np->sz = curproc->sz;
8010366f:	8b 03                	mov    (%ebx),%eax
80103671:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103674:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103676:	89 c8                	mov    %ecx,%eax
80103678:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010367b:	8b 73 18             	mov    0x18(%ebx),%esi
8010367e:	8b 79 18             	mov    0x18(%ecx),%edi
80103681:	b9 13 00 00 00       	mov    $0x13,%ecx
80103686:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103688:	8b 40 18             	mov    0x18(%eax),%eax
8010368b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103692:	31 f6                	xor    %esi,%esi
    if(curproc->ofile[i])
80103694:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103698:	85 c0                	test   %eax,%eax
8010369a:	74 13                	je     801036af <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010369c:	83 ec 0c             	sub    $0xc,%esp
8010369f:	50                   	push   %eax
801036a0:	e8 fb d6 ff ff       	call   80100da0 <filedup>
801036a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036a8:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801036ac:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801036af:	46                   	inc    %esi
801036b0:	83 fe 10             	cmp    $0x10,%esi
801036b3:	75 df                	jne    80103694 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801036b5:	83 ec 0c             	sub    $0xc,%esp
801036b8:	ff 73 68             	push   0x68(%ebx)
801036bb:	e8 d4 de ff ff       	call   80101594 <idup>
801036c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801036c3:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801036c6:	83 c4 0c             	add    $0xc,%esp
801036c9:	6a 10                	push   $0x10
801036cb:	83 c3 6c             	add    $0x6c,%ebx
801036ce:	53                   	push   %ebx
801036cf:	8d 47 6c             	lea    0x6c(%edi),%eax
801036d2:	50                   	push   %eax
801036d3:	e8 20 0b 00 00       	call   801041f8 <safestrcpy>
  pid = np->pid;
801036d8:	8b 47 10             	mov    0x10(%edi),%eax
801036db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
801036de:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036e5:	e8 12 09 00 00       	call   80103ffc <acquire>
  np->state = RUNNABLE;
801036ea:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801036f1:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801036f8:	e8 9f 08 00 00       	call   80103f9c <release>
  return pid;
801036fd:	83 c4 10             	add    $0x10,%esp
80103700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80103703:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103706:	5b                   	pop    %ebx
80103707:	5e                   	pop    %esi
80103708:	5f                   	pop    %edi
80103709:	5d                   	pop    %ebp
8010370a:	c3                   	ret    
    return -1;
8010370b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103710:	eb f1                	jmp    80103703 <fork+0xdf>
    kfree(np->kstack);
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103718:	ff 73 08             	push   0x8(%ebx)
8010371b:	e8 a8 ea ff ff       	call   801021c8 <kfree>
    np->kstack = 0;
80103720:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103727:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010372e:	83 c4 10             	add    $0x10,%esp
80103731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103736:	eb cb                	jmp    80103703 <fork+0xdf>

80103738 <scheduler>:
{
80103738:	55                   	push   %ebp
80103739:	89 e5                	mov    %esp,%ebp
8010373b:	57                   	push   %edi
8010373c:	56                   	push   %esi
8010373d:	53                   	push   %ebx
8010373e:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103741:	e8 ce fc ff ff       	call   80103414 <mycpu>
80103746:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103748:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010374f:	00 00 00 
80103752:	8d 78 04             	lea    0x4(%eax),%edi
80103755:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103758:	fb                   	sti    
    acquire(&ptable.lock);
80103759:	83 ec 0c             	sub    $0xc,%esp
8010375c:	68 20 1d 11 80       	push   $0x80111d20
80103761:	e8 96 08 00 00       	call   80103ffc <acquire>
80103766:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103769:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010376e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103770:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103774:	75 33                	jne    801037a9 <scheduler+0x71>
      c->proc = p;
80103776:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	53                   	push   %ebx
80103780:	e8 ef 29 00 00       	call   80106174 <switchuvm>
      p->state = RUNNING;
80103785:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010378c:	58                   	pop    %eax
8010378d:	5a                   	pop    %edx
8010378e:	ff 73 1c             	push   0x1c(%ebx)
80103791:	57                   	push   %edi
80103792:	e8 ae 0a 00 00       	call   80104245 <swtch>
      switchkvm();
80103797:	e8 c8 29 00 00       	call   80106164 <switchkvm>
      c->proc = 0;
8010379c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801037a3:	00 00 00 
801037a6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037a9:	83 c3 7c             	add    $0x7c,%ebx
801037ac:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801037b2:	75 bc                	jne    80103770 <scheduler+0x38>
    release(&ptable.lock);
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	68 20 1d 11 80       	push   $0x80111d20
801037bc:	e8 db 07 00 00       	call   80103f9c <release>
    sti();
801037c1:	83 c4 10             	add    $0x10,%esp
801037c4:	eb 92                	jmp    80103758 <scheduler+0x20>
801037c6:	66 90                	xchg   %ax,%ax

801037c8 <sched>:
{
801037c8:	55                   	push   %ebp
801037c9:	89 e5                	mov    %esp,%ebp
801037cb:	56                   	push   %esi
801037cc:	53                   	push   %ebx
  pushcli();
801037cd:	e8 de 06 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
801037d2:	e8 3d fc ff ff       	call   80103414 <mycpu>
  p = c->proc;
801037d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037dd:	e8 1a 07 00 00       	call   80103efc <popcli>
  if(!holding(&ptable.lock))
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	68 20 1d 11 80       	push   $0x80111d20
801037ea:	e8 65 07 00 00       	call   80103f54 <holding>
801037ef:	83 c4 10             	add    $0x10,%esp
801037f2:	85 c0                	test   %eax,%eax
801037f4:	74 4f                	je     80103845 <sched+0x7d>
  if(mycpu()->ncli != 1)
801037f6:	e8 19 fc ff ff       	call   80103414 <mycpu>
801037fb:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103802:	75 68                	jne    8010386c <sched+0xa4>
  if(p->state == RUNNING)
80103804:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103808:	74 55                	je     8010385f <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010380a:	9c                   	pushf  
8010380b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010380c:	f6 c4 02             	test   $0x2,%ah
8010380f:	75 41                	jne    80103852 <sched+0x8a>
  intena = mycpu()->intena;
80103811:	e8 fe fb ff ff       	call   80103414 <mycpu>
80103816:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010381c:	e8 f3 fb ff ff       	call   80103414 <mycpu>
80103821:	83 ec 08             	sub    $0x8,%esp
80103824:	ff 70 04             	push   0x4(%eax)
80103827:	83 c3 1c             	add    $0x1c,%ebx
8010382a:	53                   	push   %ebx
8010382b:	e8 15 0a 00 00       	call   80104245 <swtch>
  mycpu()->intena = intena;
80103830:	e8 df fb ff ff       	call   80103414 <mycpu>
80103835:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010383b:	83 c4 10             	add    $0x10,%esp
8010383e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
    panic("sched ptable.lock");
80103845:	83 ec 0c             	sub    $0xc,%esp
80103848:	68 fb 6f 10 80       	push   $0x80106ffb
8010384d:	e8 e6 ca ff ff       	call   80100338 <panic>
    panic("sched interruptible");
80103852:	83 ec 0c             	sub    $0xc,%esp
80103855:	68 27 70 10 80       	push   $0x80107027
8010385a:	e8 d9 ca ff ff       	call   80100338 <panic>
    panic("sched running");
8010385f:	83 ec 0c             	sub    $0xc,%esp
80103862:	68 19 70 10 80       	push   $0x80107019
80103867:	e8 cc ca ff ff       	call   80100338 <panic>
    panic("sched locks");
8010386c:	83 ec 0c             	sub    $0xc,%esp
8010386f:	68 0d 70 10 80       	push   $0x8010700d
80103874:	e8 bf ca ff ff       	call   80100338 <panic>
80103879:	8d 76 00             	lea    0x0(%esi),%esi

8010387c <exit>:
{
8010387c:	55                   	push   %ebp
8010387d:	89 e5                	mov    %esp,%ebp
8010387f:	57                   	push   %edi
80103880:	56                   	push   %esi
80103881:	53                   	push   %ebx
80103882:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103885:	e8 22 fc ff ff       	call   801034ac <myproc>
  if(curproc == initproc)
8010388a:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103890:	0f 84 e9 00 00 00    	je     8010397f <exit+0x103>
80103896:	89 c3                	mov    %eax,%ebx
80103898:	8d 70 28             	lea    0x28(%eax),%esi
8010389b:	8d 78 68             	lea    0x68(%eax),%edi
8010389e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
801038a0:	8b 06                	mov    (%esi),%eax
801038a2:	85 c0                	test   %eax,%eax
801038a4:	74 12                	je     801038b8 <exit+0x3c>
      fileclose(curproc->ofile[fd]);
801038a6:	83 ec 0c             	sub    $0xc,%esp
801038a9:	50                   	push   %eax
801038aa:	e8 35 d5 ff ff       	call   80100de4 <fileclose>
      curproc->ofile[fd] = 0;
801038af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038b5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801038b8:	83 c6 04             	add    $0x4,%esi
801038bb:	39 f7                	cmp    %esi,%edi
801038bd:	75 e1                	jne    801038a0 <exit+0x24>
  begin_op();
801038bf:	e8 a4 f0 ff ff       	call   80102968 <begin_op>
  iput(curproc->cwd);
801038c4:	83 ec 0c             	sub    $0xc,%esp
801038c7:	ff 73 68             	push   0x68(%ebx)
801038ca:	e8 fd dd ff ff       	call   801016cc <iput>
  end_op();
801038cf:	e8 fc f0 ff ff       	call   801029d0 <end_op>
  curproc->cwd = 0;
801038d4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801038db:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801038e2:	e8 15 07 00 00       	call   80103ffc <acquire>
  wakeup1(curproc->parent);
801038e7:	8b 53 14             	mov    0x14(%ebx),%edx
801038ea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038ed:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801038f2:	eb 0a                	jmp    801038fe <exit+0x82>
801038f4:	83 c0 7c             	add    $0x7c,%eax
801038f7:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
801038fc:	74 1c                	je     8010391a <exit+0x9e>
    if(p->state == SLEEPING && p->chan == chan)
801038fe:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103902:	75 f0                	jne    801038f4 <exit+0x78>
80103904:	3b 50 20             	cmp    0x20(%eax),%edx
80103907:	75 eb                	jne    801038f4 <exit+0x78>
      p->state = RUNNABLE;
80103909:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103910:	83 c0 7c             	add    $0x7c,%eax
80103913:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103918:	75 e4                	jne    801038fe <exit+0x82>
      p->parent = initproc;
8010391a:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103920:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103925:	eb 0c                	jmp    80103933 <exit+0xb7>
80103927:	90                   	nop
80103928:	83 c2 7c             	add    $0x7c,%edx
8010392b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80103931:	74 33                	je     80103966 <exit+0xea>
    if(p->parent == curproc){
80103933:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103936:	75 f0                	jne    80103928 <exit+0xac>
      p->parent = initproc;
80103938:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010393b:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
8010393f:	75 e7                	jne    80103928 <exit+0xac>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103941:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103946:	eb 0a                	jmp    80103952 <exit+0xd6>
80103948:	83 c0 7c             	add    $0x7c,%eax
8010394b:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103950:	74 d6                	je     80103928 <exit+0xac>
    if(p->state == SLEEPING && p->chan == chan)
80103952:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103956:	75 f0                	jne    80103948 <exit+0xcc>
80103958:	3b 48 20             	cmp    0x20(%eax),%ecx
8010395b:	75 eb                	jne    80103948 <exit+0xcc>
      p->state = RUNNABLE;
8010395d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103964:	eb e2                	jmp    80103948 <exit+0xcc>
  curproc->state = ZOMBIE;
80103966:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010396d:	e8 56 fe ff ff       	call   801037c8 <sched>
  panic("zombie exit");
80103972:	83 ec 0c             	sub    $0xc,%esp
80103975:	68 48 70 10 80       	push   $0x80107048
8010397a:	e8 b9 c9 ff ff       	call   80100338 <panic>
    panic("init exiting");
8010397f:	83 ec 0c             	sub    $0xc,%esp
80103982:	68 3b 70 10 80       	push   $0x8010703b
80103987:	e8 ac c9 ff ff       	call   80100338 <panic>

8010398c <wait>:
{
8010398c:	55                   	push   %ebp
8010398d:	89 e5                	mov    %esp,%ebp
8010398f:	56                   	push   %esi
80103990:	53                   	push   %ebx
80103991:	83 ec 10             	sub    $0x10,%esp
  pushcli();
80103994:	e8 17 05 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
80103999:	e8 76 fa ff ff       	call   80103414 <mycpu>
  p = c->proc;
8010399e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801039a4:	e8 53 05 00 00       	call   80103efc <popcli>
  acquire(&ptable.lock);
801039a9:	83 ec 0c             	sub    $0xc,%esp
801039ac:	68 20 1d 11 80       	push   $0x80111d20
801039b1:	e8 46 06 00 00       	call   80103ffc <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801039b9:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039bb:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801039c0:	eb 0d                	jmp    801039cf <wait+0x43>
801039c2:	66 90                	xchg   %ax,%ax
801039c4:	83 c3 7c             	add    $0x7c,%ebx
801039c7:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801039cd:	74 1b                	je     801039ea <wait+0x5e>
      if(p->parent != curproc)
801039cf:	39 73 14             	cmp    %esi,0x14(%ebx)
801039d2:	75 f0                	jne    801039c4 <wait+0x38>
      if(p->state == ZOMBIE){
801039d4:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801039d8:	74 5a                	je     80103a34 <wait+0xa8>
      havekids = 1;
801039da:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039df:	83 c3 7c             	add    $0x7c,%ebx
801039e2:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801039e8:	75 e5                	jne    801039cf <wait+0x43>
    if(!havekids || curproc->killed){
801039ea:	85 c0                	test   %eax,%eax
801039ec:	0f 84 9c 00 00 00    	je     80103a8e <wait+0x102>
801039f2:	8b 46 24             	mov    0x24(%esi),%eax
801039f5:	85 c0                	test   %eax,%eax
801039f7:	0f 85 91 00 00 00    	jne    80103a8e <wait+0x102>
  pushcli();
801039fd:	e8 ae 04 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
80103a02:	e8 0d fa ff ff       	call   80103414 <mycpu>
  p = c->proc;
80103a07:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a0d:	e8 ea 04 00 00       	call   80103efc <popcli>
  if(p == 0)
80103a12:	85 db                	test   %ebx,%ebx
80103a14:	0f 84 8b 00 00 00    	je     80103aa5 <wait+0x119>
  p->chan = chan;
80103a1a:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103a1d:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103a24:	e8 9f fd ff ff       	call   801037c8 <sched>
  p->chan = 0;
80103a29:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103a30:	eb 87                	jmp    801039b9 <wait+0x2d>
80103a32:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80103a34:	8b 43 10             	mov    0x10(%ebx),%eax
80103a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
        kfree(p->kstack);
80103a3a:	83 ec 0c             	sub    $0xc,%esp
80103a3d:	ff 73 08             	push   0x8(%ebx)
80103a40:	e8 83 e7 ff ff       	call   801021c8 <kfree>
        p->kstack = 0;
80103a45:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103a4c:	5a                   	pop    %edx
80103a4d:	ff 73 04             	push   0x4(%ebx)
80103a50:	e8 af 2a 00 00       	call   80106504 <freevm>
        p->pid = 0;
80103a55:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103a5c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103a63:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103a67:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103a6e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103a75:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a7c:	e8 1b 05 00 00       	call   80103f9c <release>
        return pid;
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103a87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a8a:	5b                   	pop    %ebx
80103a8b:	5e                   	pop    %esi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
      release(&ptable.lock);
80103a8e:	83 ec 0c             	sub    $0xc,%esp
80103a91:	68 20 1d 11 80       	push   $0x80111d20
80103a96:	e8 01 05 00 00       	call   80103f9c <release>
      return -1;
80103a9b:	83 c4 10             	add    $0x10,%esp
80103a9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aa3:	eb e2                	jmp    80103a87 <wait+0xfb>
    panic("sleep");
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	68 54 70 10 80       	push   $0x80107054
80103aad:	e8 86 c8 ff ff       	call   80100338 <panic>
80103ab2:	66 90                	xchg   %ax,%ax

80103ab4 <yield>:
{
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	53                   	push   %ebx
80103ab8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103abb:	68 20 1d 11 80       	push   $0x80111d20
80103ac0:	e8 37 05 00 00       	call   80103ffc <acquire>
  pushcli();
80103ac5:	e8 e6 03 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
80103aca:	e8 45 f9 ff ff       	call   80103414 <mycpu>
  p = c->proc;
80103acf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad5:	e8 22 04 00 00       	call   80103efc <popcli>
  myproc()->state = RUNNABLE;
80103ada:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ae1:	e8 e2 fc ff ff       	call   801037c8 <sched>
  release(&ptable.lock);
80103ae6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103aed:	e8 aa 04 00 00       	call   80103f9c <release>
}
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103af8:	c9                   	leave  
80103af9:	c3                   	ret    
80103afa:	66 90                	xchg   %ax,%ax

80103afc <sleep>:
{
80103afc:	55                   	push   %ebp
80103afd:	89 e5                	mov    %esp,%ebp
80103aff:	57                   	push   %edi
80103b00:	56                   	push   %esi
80103b01:	53                   	push   %ebx
80103b02:	83 ec 0c             	sub    $0xc,%esp
80103b05:	8b 7d 08             	mov    0x8(%ebp),%edi
80103b08:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103b0b:	e8 a0 03 00 00       	call   80103eb0 <pushcli>
  c = mycpu();
80103b10:	e8 ff f8 ff ff       	call   80103414 <mycpu>
  p = c->proc;
80103b15:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b1b:	e8 dc 03 00 00       	call   80103efc <popcli>
  if(p == 0)
80103b20:	85 db                	test   %ebx,%ebx
80103b22:	0f 84 83 00 00 00    	je     80103bab <sleep+0xaf>
  if(lk == 0)
80103b28:	85 f6                	test   %esi,%esi
80103b2a:	74 72                	je     80103b9e <sleep+0xa2>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103b2c:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103b32:	74 4c                	je     80103b80 <sleep+0x84>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103b34:	83 ec 0c             	sub    $0xc,%esp
80103b37:	68 20 1d 11 80       	push   $0x80111d20
80103b3c:	e8 bb 04 00 00       	call   80103ffc <acquire>
    release(lk);
80103b41:	89 34 24             	mov    %esi,(%esp)
80103b44:	e8 53 04 00 00       	call   80103f9c <release>
  p->chan = chan;
80103b49:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103b4c:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103b53:	e8 70 fc ff ff       	call   801037c8 <sched>
  p->chan = 0;
80103b58:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103b5f:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b66:	e8 31 04 00 00       	call   80103f9c <release>
    acquire(lk);
80103b6b:	83 c4 10             	add    $0x10,%esp
80103b6e:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b74:	5b                   	pop    %ebx
80103b75:	5e                   	pop    %esi
80103b76:	5f                   	pop    %edi
80103b77:	5d                   	pop    %ebp
    acquire(lk);
80103b78:	e9 7f 04 00 00       	jmp    80103ffc <acquire>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103b80:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103b83:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103b8a:	e8 39 fc ff ff       	call   801037c8 <sched>
  p->chan = 0;
80103b8f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103b96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b99:	5b                   	pop    %ebx
80103b9a:	5e                   	pop    %esi
80103b9b:	5f                   	pop    %edi
80103b9c:	5d                   	pop    %ebp
80103b9d:	c3                   	ret    
    panic("sleep without lk");
80103b9e:	83 ec 0c             	sub    $0xc,%esp
80103ba1:	68 5a 70 10 80       	push   $0x8010705a
80103ba6:	e8 8d c7 ff ff       	call   80100338 <panic>
    panic("sleep");
80103bab:	83 ec 0c             	sub    $0xc,%esp
80103bae:	68 54 70 10 80       	push   $0x80107054
80103bb3:	e8 80 c7 ff ff       	call   80100338 <panic>

80103bb8 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103bb8:	55                   	push   %ebp
80103bb9:	89 e5                	mov    %esp,%ebp
80103bbb:	53                   	push   %ebx
80103bbc:	83 ec 10             	sub    $0x10,%esp
80103bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103bc2:	68 20 1d 11 80       	push   $0x80111d20
80103bc7:	e8 30 04 00 00       	call   80103ffc <acquire>
80103bcc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bcf:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103bd4:	eb 0c                	jmp    80103be2 <wakeup+0x2a>
80103bd6:	66 90                	xchg   %ax,%ax
80103bd8:	83 c0 7c             	add    $0x7c,%eax
80103bdb:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103be0:	74 1c                	je     80103bfe <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103be2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103be6:	75 f0                	jne    80103bd8 <wakeup+0x20>
80103be8:	3b 58 20             	cmp    0x20(%eax),%ebx
80103beb:	75 eb                	jne    80103bd8 <wakeup+0x20>
      p->state = RUNNABLE;
80103bed:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bf4:	83 c0 7c             	add    $0x7c,%eax
80103bf7:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103bfc:	75 e4                	jne    80103be2 <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103bfe:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80103c05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c08:	c9                   	leave  
  release(&ptable.lock);
80103c09:	e9 8e 03 00 00       	jmp    80103f9c <release>
80103c0e:	66 90                	xchg   %ax,%ax

80103c10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 10             	sub    $0x10,%esp
80103c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103c1a:	68 20 1d 11 80       	push   $0x80111d20
80103c1f:	e8 d8 03 00 00       	call   80103ffc <acquire>
80103c24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c27:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103c2c:	eb 0c                	jmp    80103c3a <kill+0x2a>
80103c2e:	66 90                	xchg   %ax,%ax
80103c30:	83 c0 7c             	add    $0x7c,%eax
80103c33:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80103c38:	74 32                	je     80103c6c <kill+0x5c>
    if(p->pid == pid){
80103c3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103c3d:	75 f1                	jne    80103c30 <kill+0x20>
      p->killed = 1;
80103c3f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103c46:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c4a:	75 07                	jne    80103c53 <kill+0x43>
        p->state = RUNNABLE;
80103c4c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103c53:	83 ec 0c             	sub    $0xc,%esp
80103c56:	68 20 1d 11 80       	push   $0x80111d20
80103c5b:	e8 3c 03 00 00       	call   80103f9c <release>
      return 0;
80103c60:	83 c4 10             	add    $0x10,%esp
80103c63:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c68:	c9                   	leave  
80103c69:	c3                   	ret    
80103c6a:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103c6c:	83 ec 0c             	sub    $0xc,%esp
80103c6f:	68 20 1d 11 80       	push   $0x80111d20
80103c74:	e8 23 03 00 00       	call   80103f9c <release>
  return -1;
80103c79:	83 c4 10             	add    $0x10,%esp
80103c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c84:	c9                   	leave  
80103c85:	c3                   	ret    
80103c86:	66 90                	xchg   %ax,%ax

80103c88 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103c88:	55                   	push   %ebp
80103c89:	89 e5                	mov    %esp,%ebp
80103c8b:	57                   	push   %edi
80103c8c:	56                   	push   %esi
80103c8d:	53                   	push   %ebx
80103c8e:	83 ec 3c             	sub    $0x3c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c91:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
80103c96:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103c99:	eb 3f                	jmp    80103cda <procdump+0x52>
80103c9b:	90                   	nop
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103c9c:	8b 04 85 cc 70 10 80 	mov    -0x7fef8f34(,%eax,4),%eax
80103ca3:	85 c0                	test   %eax,%eax
80103ca5:	74 3f                	je     80103ce6 <procdump+0x5e>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103ca7:	53                   	push   %ebx
80103ca8:	50                   	push   %eax
80103ca9:	ff 73 a4             	push   -0x5c(%ebx)
80103cac:	68 6f 70 10 80       	push   $0x8010706f
80103cb1:	e8 66 c9 ff ff       	call   8010061c <cprintf>
    if(p->state == SLEEPING){
80103cb6:	83 c4 10             	add    $0x10,%esp
80103cb9:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103cbd:	74 31                	je     80103cf0 <procdump+0x68>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103cbf:	83 ec 0c             	sub    $0xc,%esp
80103cc2:	68 d7 73 10 80       	push   $0x801073d7
80103cc7:	e8 50 c9 ff ff       	call   8010061c <cprintf>
80103ccc:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ccf:	83 c3 7c             	add    $0x7c,%ebx
80103cd2:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80103cd8:	74 52                	je     80103d2c <procdump+0xa4>
    if(p->state == UNUSED)
80103cda:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103cdd:	85 c0                	test   %eax,%eax
80103cdf:	74 ee                	je     80103ccf <procdump+0x47>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ce1:	83 f8 05             	cmp    $0x5,%eax
80103ce4:	76 b6                	jbe    80103c9c <procdump+0x14>
      state = "???";
80103ce6:	b8 6b 70 10 80       	mov    $0x8010706b,%eax
80103ceb:	eb ba                	jmp    80103ca7 <procdump+0x1f>
80103ced:	8d 76 00             	lea    0x0(%esi),%esi
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103cf0:	83 ec 08             	sub    $0x8,%esp
80103cf3:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103cf6:	50                   	push   %eax
80103cf7:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103cfa:	8b 40 0c             	mov    0xc(%eax),%eax
80103cfd:	83 c0 08             	add    $0x8,%eax
80103d00:	50                   	push   %eax
80103d01:	e8 5a 01 00 00       	call   80103e60 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d06:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103d09:	83 c4 10             	add    $0x10,%esp
80103d0c:	8b 17                	mov    (%edi),%edx
80103d0e:	85 d2                	test   %edx,%edx
80103d10:	74 ad                	je     80103cbf <procdump+0x37>
        cprintf(" %p", pc[i]);
80103d12:	83 ec 08             	sub    $0x8,%esp
80103d15:	52                   	push   %edx
80103d16:	68 c1 6a 10 80       	push   $0x80106ac1
80103d1b:	e8 fc c8 ff ff       	call   8010061c <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103d20:	83 c7 04             	add    $0x4,%edi
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	39 fe                	cmp    %edi,%esi
80103d28:	75 e2                	jne    80103d0c <procdump+0x84>
80103d2a:	eb 93                	jmp    80103cbf <procdump+0x37>
  }
}
80103d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d2f:	5b                   	pop    %ebx
80103d30:	5e                   	pop    %esi
80103d31:	5f                   	pop    %edi
80103d32:	5d                   	pop    %ebp
80103d33:	c3                   	ret    

80103d34 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103d34:	55                   	push   %ebp
80103d35:	89 e5                	mov    %esp,%ebp
80103d37:	53                   	push   %ebx
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103d3e:	68 e4 70 10 80       	push   $0x801070e4
80103d43:	8d 43 04             	lea    0x4(%ebx),%eax
80103d46:	50                   	push   %eax
80103d47:	e8 f8 00 00 00       	call   80103e44 <initlock>
  lk->name = name;
80103d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d4f:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103d52:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103d58:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d65:	c9                   	leave  
80103d66:	c3                   	ret    
80103d67:	90                   	nop

80103d68 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103d68:	55                   	push   %ebp
80103d69:	89 e5                	mov    %esp,%ebp
80103d6b:	56                   	push   %esi
80103d6c:	53                   	push   %ebx
80103d6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103d70:	8d 73 04             	lea    0x4(%ebx),%esi
80103d73:	83 ec 0c             	sub    $0xc,%esp
80103d76:	56                   	push   %esi
80103d77:	e8 80 02 00 00       	call   80103ffc <acquire>
  while (lk->locked) {
80103d7c:	83 c4 10             	add    $0x10,%esp
80103d7f:	8b 13                	mov    (%ebx),%edx
80103d81:	85 d2                	test   %edx,%edx
80103d83:	74 16                	je     80103d9b <acquiresleep+0x33>
80103d85:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80103d88:	83 ec 08             	sub    $0x8,%esp
80103d8b:	56                   	push   %esi
80103d8c:	53                   	push   %ebx
80103d8d:	e8 6a fd ff ff       	call   80103afc <sleep>
  while (lk->locked) {
80103d92:	83 c4 10             	add    $0x10,%esp
80103d95:	8b 03                	mov    (%ebx),%eax
80103d97:	85 c0                	test   %eax,%eax
80103d99:	75 ed                	jne    80103d88 <acquiresleep+0x20>
  }
  lk->locked = 1;
80103d9b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103da1:	e8 06 f7 ff ff       	call   801034ac <myproc>
80103da6:	8b 40 10             	mov    0x10(%eax),%eax
80103da9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103dac:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103daf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db2:	5b                   	pop    %ebx
80103db3:	5e                   	pop    %esi
80103db4:	5d                   	pop    %ebp
  release(&lk->lk);
80103db5:	e9 e2 01 00 00       	jmp    80103f9c <release>
80103dba:	66 90                	xchg   %ax,%ax

80103dbc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103dbc:	55                   	push   %ebp
80103dbd:	89 e5                	mov    %esp,%ebp
80103dbf:	56                   	push   %esi
80103dc0:	53                   	push   %ebx
80103dc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103dc4:	8d 73 04             	lea    0x4(%ebx),%esi
80103dc7:	83 ec 0c             	sub    $0xc,%esp
80103dca:	56                   	push   %esi
80103dcb:	e8 2c 02 00 00       	call   80103ffc <acquire>
  lk->locked = 0;
80103dd0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103dd6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103ddd:	89 1c 24             	mov    %ebx,(%esp)
80103de0:	e8 d3 fd ff ff       	call   80103bb8 <wakeup>
  release(&lk->lk);
80103de5:	83 c4 10             	add    $0x10,%esp
80103de8:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103deb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dee:	5b                   	pop    %ebx
80103def:	5e                   	pop    %esi
80103df0:	5d                   	pop    %ebp
  release(&lk->lk);
80103df1:	e9 a6 01 00 00       	jmp    80103f9c <release>
80103df6:	66 90                	xchg   %ax,%ax

80103df8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103df8:	55                   	push   %ebp
80103df9:	89 e5                	mov    %esp,%ebp
80103dfb:	56                   	push   %esi
80103dfc:	53                   	push   %ebx
80103dfd:	83 ec 1c             	sub    $0x1c,%esp
80103e00:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103e03:	8d 73 04             	lea    0x4(%ebx),%esi
80103e06:	56                   	push   %esi
80103e07:	e8 f0 01 00 00       	call   80103ffc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103e0c:	83 c4 10             	add    $0x10,%esp
80103e0f:	8b 03                	mov    (%ebx),%eax
80103e11:	85 c0                	test   %eax,%eax
80103e13:	75 1b                	jne    80103e30 <holdingsleep+0x38>
80103e15:	31 c0                	xor    %eax,%eax
80103e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	56                   	push   %esi
80103e1e:	e8 79 01 00 00       	call   80103f9c <release>
  return r;
}
80103e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e29:	5b                   	pop    %ebx
80103e2a:	5e                   	pop    %esi
80103e2b:	5d                   	pop    %ebp
80103e2c:	c3                   	ret    
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80103e30:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103e33:	e8 74 f6 ff ff       	call   801034ac <myproc>
80103e38:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e3b:	0f 94 c0             	sete   %al
80103e3e:	0f b6 c0             	movzbl %al,%eax
80103e41:	eb d4                	jmp    80103e17 <holdingsleep+0x1f>
80103e43:	90                   	nop

80103e44 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e4d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103e50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103e56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103e5d:	5d                   	pop    %ebp
80103e5e:	c3                   	ret    
80103e5f:	90                   	nop

80103e60 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103e67:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6a:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80103e6d:	31 d2                	xor    %edx,%edx
80103e6f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103e70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80103e76:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103e7c:	77 16                	ja     80103e94 <getcallerpcs+0x34>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103e7e:	8b 58 04             	mov    0x4(%eax),%ebx
80103e81:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103e84:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80103e86:	42                   	inc    %edx
80103e87:	83 fa 0a             	cmp    $0xa,%edx
80103e8a:	75 e4                	jne    80103e70 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103e8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e8f:	c9                   	leave  
80103e90:	c3                   	ret    
80103e91:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80103e94:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80103e97:	8d 51 28             	lea    0x28(%ecx),%edx
80103e9a:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80103e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80103ea2:	83 c0 04             	add    $0x4,%eax
80103ea5:	39 d0                	cmp    %edx,%eax
80103ea7:	75 f3                	jne    80103e9c <getcallerpcs+0x3c>
}
80103ea9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eac:	c9                   	leave  
80103ead:	c3                   	ret    
80103eae:	66 90                	xchg   %ax,%ax

80103eb0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	50                   	push   %eax
80103eb5:	9c                   	pushf  
80103eb6:	5b                   	pop    %ebx
  asm volatile("cli");
80103eb7:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103eb8:	e8 57 f5 ff ff       	call   80103414 <mycpu>
80103ebd:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80103ec3:	85 d2                	test   %edx,%edx
80103ec5:	74 11                	je     80103ed8 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103ec7:	e8 48 f5 ff ff       	call   80103414 <mycpu>
80103ecc:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed5:	c9                   	leave  
80103ed6:	c3                   	ret    
80103ed7:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80103ed8:	e8 37 f5 ff ff       	call   80103414 <mycpu>
80103edd:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103ee3:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80103ee9:	e8 26 f5 ff ff       	call   80103414 <mycpu>
80103eee:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef7:	c9                   	leave  
80103ef8:	c3                   	ret    
80103ef9:	8d 76 00             	lea    0x0(%esi),%esi

80103efc <popcli>:

void
popcli(void)
{
80103efc:	55                   	push   %ebp
80103efd:	89 e5                	mov    %esp,%ebp
80103eff:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f02:	9c                   	pushf  
80103f03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f04:	f6 c4 02             	test   $0x2,%ah
80103f07:	75 31                	jne    80103f3a <popcli+0x3e>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103f09:	e8 06 f5 ff ff       	call   80103414 <mycpu>
80103f0e:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80103f14:	78 31                	js     80103f47 <popcli+0x4b>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f16:	e8 f9 f4 ff ff       	call   80103414 <mycpu>
80103f1b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80103f21:	85 d2                	test   %edx,%edx
80103f23:	74 03                	je     80103f28 <popcli+0x2c>
    sti();
}
80103f25:	c9                   	leave  
80103f26:	c3                   	ret    
80103f27:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103f28:	e8 e7 f4 ff ff       	call   80103414 <mycpu>
80103f2d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103f33:	85 c0                	test   %eax,%eax
80103f35:	74 ee                	je     80103f25 <popcli+0x29>
  asm volatile("sti");
80103f37:	fb                   	sti    
}
80103f38:	c9                   	leave  
80103f39:	c3                   	ret    
    panic("popcli - interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 ef 70 10 80       	push   $0x801070ef
80103f42:	e8 f1 c3 ff ff       	call   80100338 <panic>
    panic("popcli");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 06 71 10 80       	push   $0x80107106
80103f4f:	e8 e4 c3 ff ff       	call   80100338 <panic>

80103f54 <holding>:
{
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	53                   	push   %ebx
80103f58:	83 ec 14             	sub    $0x14,%esp
80103f5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103f5e:	e8 4d ff ff ff       	call   80103eb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103f63:	8b 03                	mov    (%ebx),%eax
80103f65:	85 c0                	test   %eax,%eax
80103f67:	75 13                	jne    80103f7c <holding+0x28>
80103f69:	31 c0                	xor    %eax,%eax
80103f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80103f6e:	e8 89 ff ff ff       	call   80103efc <popcli>
}
80103f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f79:	c9                   	leave  
80103f7a:	c3                   	ret    
80103f7b:	90                   	nop
  r = lock->locked && lock->cpu == mycpu();
80103f7c:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103f7f:	e8 90 f4 ff ff       	call   80103414 <mycpu>
80103f84:	39 c3                	cmp    %eax,%ebx
80103f86:	0f 94 c0             	sete   %al
80103f89:	0f b6 c0             	movzbl %al,%eax
80103f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
80103f8f:	e8 68 ff ff ff       	call   80103efc <popcli>
}
80103f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f9a:	c9                   	leave  
80103f9b:	c3                   	ret    

80103f9c <release>:
{
80103f9c:	55                   	push   %ebp
80103f9d:	89 e5                	mov    %esp,%ebp
80103f9f:	56                   	push   %esi
80103fa0:	53                   	push   %ebx
80103fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103fa4:	e8 07 ff ff ff       	call   80103eb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103fa9:	8b 03                	mov    (%ebx),%eax
80103fab:	85 c0                	test   %eax,%eax
80103fad:	75 15                	jne    80103fc4 <release+0x28>
  popcli();
80103faf:	e8 48 ff ff ff       	call   80103efc <popcli>
    panic("release");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 0d 71 10 80       	push   $0x8010710d
80103fbc:	e8 77 c3 ff ff       	call   80100338 <panic>
80103fc1:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80103fc4:	8b 73 08             	mov    0x8(%ebx),%esi
80103fc7:	e8 48 f4 ff ff       	call   80103414 <mycpu>
80103fcc:	39 c6                	cmp    %eax,%esi
80103fce:	75 df                	jne    80103faf <release+0x13>
  popcli();
80103fd0:	e8 27 ff ff ff       	call   80103efc <popcli>
  lk->pcs[0] = 0;
80103fd5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103fdc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103fe3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103fe8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80103fee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff1:	5b                   	pop    %ebx
80103ff2:	5e                   	pop    %esi
80103ff3:	5d                   	pop    %ebp
  popcli();
80103ff4:	e9 03 ff ff ff       	jmp    80103efc <popcli>
80103ff9:	8d 76 00             	lea    0x0(%esi),%esi

80103ffc <acquire>:
{
80103ffc:	55                   	push   %ebp
80103ffd:	89 e5                	mov    %esp,%ebp
80103fff:	53                   	push   %ebx
80104000:	50                   	push   %eax
  pushcli(); // disable interrupts to avoid deadlock.
80104001:	e8 aa fe ff ff       	call   80103eb0 <pushcli>
  if(holding(lk))
80104006:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104009:	e8 a2 fe ff ff       	call   80103eb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010400e:	8b 13                	mov    (%ebx),%edx
80104010:	85 d2                	test   %edx,%edx
80104012:	75 70                	jne    80104084 <acquire+0x88>
  popcli();
80104014:	e8 e3 fe ff ff       	call   80103efc <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104019:	b9 01 00 00 00       	mov    $0x1,%ecx
8010401e:	66 90                	xchg   %ax,%ax
  while(xchg(&lk->locked, 1) != 0)
80104020:	8b 55 08             	mov    0x8(%ebp),%edx
80104023:	89 c8                	mov    %ecx,%eax
80104025:	f0 87 02             	lock xchg %eax,(%edx)
80104028:	85 c0                	test   %eax,%eax
8010402a:	75 f4                	jne    80104020 <acquire+0x24>
  __sync_synchronize();
8010402c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104031:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104034:	e8 db f3 ff ff       	call   80103414 <mycpu>
80104039:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010403c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010403f:	31 c0                	xor    %eax,%eax
  ebp = (uint*)v - 2;
80104041:	89 ea                	mov    %ebp,%edx
80104043:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104044:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010404a:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104050:	77 16                	ja     80104068 <acquire+0x6c>
    pcs[i] = ebp[1];     // saved %eip
80104052:	8b 5a 04             	mov    0x4(%edx),%ebx
80104055:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80104059:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010405b:	40                   	inc    %eax
8010405c:	83 f8 0a             	cmp    $0xa,%eax
8010405f:	75 e3                	jne    80104044 <acquire+0x48>
}
80104061:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104064:	c9                   	leave  
80104065:	c3                   	ret    
80104066:	66 90                	xchg   %ax,%ax
  for(; i < 10; i++)
80104068:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010406c:	8d 51 34             	lea    0x34(%ecx),%edx
8010406f:	90                   	nop
    pcs[i] = 0;
80104070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104076:	83 c0 04             	add    $0x4,%eax
80104079:	39 c2                	cmp    %eax,%edx
8010407b:	75 f3                	jne    80104070 <acquire+0x74>
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
80104081:	c3                   	ret    
80104082:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104084:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104087:	e8 88 f3 ff ff       	call   80103414 <mycpu>
8010408c:	39 c3                	cmp    %eax,%ebx
8010408e:	75 84                	jne    80104014 <acquire+0x18>
  popcli();
80104090:	e8 67 fe ff ff       	call   80103efc <popcli>
    panic("acquire");
80104095:	83 ec 0c             	sub    $0xc,%esp
80104098:	68 15 71 10 80       	push   $0x80107115
8010409d:	e8 96 c2 ff ff       	call   80100338 <panic>
801040a2:	66 90                	xchg   %ax,%ax

801040a4 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	57                   	push   %edi
801040a8:	53                   	push   %ebx
801040a9:	8b 55 08             	mov    0x8(%ebp),%edx
801040ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801040af:	89 d0                	mov    %edx,%eax
801040b1:	09 c8                	or     %ecx,%eax
801040b3:	a8 03                	test   $0x3,%al
801040b5:	75 29                	jne    801040e0 <memset+0x3c>
    c &= 0xFF;
801040b7:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801040bb:	c1 e9 02             	shr    $0x2,%ecx
801040be:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c1:	c1 e0 18             	shl    $0x18,%eax
801040c4:	89 fb                	mov    %edi,%ebx
801040c6:	c1 e3 10             	shl    $0x10,%ebx
801040c9:	09 d8                	or     %ebx,%eax
801040cb:	09 f8                	or     %edi,%eax
801040cd:	c1 e7 08             	shl    $0x8,%edi
801040d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801040d2:	89 d7                	mov    %edx,%edi
801040d4:	fc                   	cld    
801040d5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801040d7:	89 d0                	mov    %edx,%eax
801040d9:	5b                   	pop    %ebx
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
801040dc:	c3                   	ret    
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801040e0:	89 d7                	mov    %edx,%edi
801040e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801040e5:	fc                   	cld    
801040e6:	f3 aa                	rep stos %al,%es:(%edi)
801040e8:	89 d0                	mov    %edx,%eax
801040ea:	5b                   	pop    %ebx
801040eb:	5f                   	pop    %edi
801040ec:	5d                   	pop    %ebp
801040ed:	c3                   	ret    
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
801040f5:	8b 55 08             	mov    0x8(%ebp),%edx
801040f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801040fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801040fe:	85 f6                	test   %esi,%esi
80104100:	74 1e                	je     80104120 <memcmp+0x30>
80104102:	01 c6                	add    %eax,%esi
80104104:	eb 08                	jmp    8010410e <memcmp+0x1e>
80104106:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104108:	42                   	inc    %edx
80104109:	40                   	inc    %eax
  while(n-- > 0){
8010410a:	39 f0                	cmp    %esi,%eax
8010410c:	74 12                	je     80104120 <memcmp+0x30>
    if(*s1 != *s2)
8010410e:	8a 0a                	mov    (%edx),%cl
80104110:	0f b6 18             	movzbl (%eax),%ebx
80104113:	38 d9                	cmp    %bl,%cl
80104115:	74 f1                	je     80104108 <memcmp+0x18>
      return *s1 - *s2;
80104117:	0f b6 c1             	movzbl %cl,%eax
8010411a:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
8010411c:	5b                   	pop    %ebx
8010411d:	5e                   	pop    %esi
8010411e:	5d                   	pop    %ebp
8010411f:	c3                   	ret    
  return 0;
80104120:	31 c0                	xor    %eax,%eax
}
80104122:	5b                   	pop    %ebx
80104123:	5e                   	pop    %esi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret    
80104126:	66 90                	xchg   %ax,%ax

80104128 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104128:	55                   	push   %ebp
80104129:	89 e5                	mov    %esp,%ebp
8010412b:	57                   	push   %edi
8010412c:	56                   	push   %esi
8010412d:	8b 55 08             	mov    0x8(%ebp),%edx
80104130:	8b 75 0c             	mov    0xc(%ebp),%esi
80104133:	8b 4d 10             	mov    0x10(%ebp),%ecx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104136:	39 d6                	cmp    %edx,%esi
80104138:	73 07                	jae    80104141 <memmove+0x19>
8010413a:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
8010413d:	39 fa                	cmp    %edi,%edx
8010413f:	72 17                	jb     80104158 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104141:	85 c9                	test   %ecx,%ecx
80104143:	74 0c                	je     80104151 <memmove+0x29>
80104145:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104148:	89 d7                	mov    %edx,%edi
8010414a:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
8010414c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
8010414d:	39 c6                	cmp    %eax,%esi
8010414f:	75 fb                	jne    8010414c <memmove+0x24>

  return dst;
}
80104151:	89 d0                	mov    %edx,%eax
80104153:	5e                   	pop    %esi
80104154:	5f                   	pop    %edi
80104155:	5d                   	pop    %ebp
80104156:	c3                   	ret    
80104157:	90                   	nop
80104158:	8d 41 ff             	lea    -0x1(%ecx),%eax
    while(n-- > 0)
8010415b:	85 c9                	test   %ecx,%ecx
8010415d:	74 f2                	je     80104151 <memmove+0x29>
8010415f:	90                   	nop
      *--d = *--s;
80104160:	8a 0c 06             	mov    (%esi,%eax,1),%cl
80104163:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104166:	83 e8 01             	sub    $0x1,%eax
80104169:	73 f5                	jae    80104160 <memmove+0x38>
}
8010416b:	89 d0                	mov    %edx,%eax
8010416d:	5e                   	pop    %esi
8010416e:	5f                   	pop    %edi
8010416f:	5d                   	pop    %ebp
80104170:	c3                   	ret    
80104171:	8d 76 00             	lea    0x0(%esi),%esi

80104174 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104174:	eb b2                	jmp    80104128 <memmove>
80104176:	66 90                	xchg   %ax,%ax

80104178 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	56                   	push   %esi
8010417c:	53                   	push   %ebx
8010417d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104180:	8b 55 0c             	mov    0xc(%ebp),%edx
80104183:	8b 75 10             	mov    0x10(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104186:	85 f6                	test   %esi,%esi
80104188:	74 22                	je     801041ac <strncmp+0x34>
8010418a:	01 d6                	add    %edx,%esi
8010418c:	eb 0c                	jmp    8010419a <strncmp+0x22>
8010418e:	66 90                	xchg   %ax,%ax
80104190:	38 c8                	cmp    %cl,%al
80104192:	75 10                	jne    801041a4 <strncmp+0x2c>
    n--, p++, q++;
80104194:	43                   	inc    %ebx
80104195:	42                   	inc    %edx
  while(n > 0 && *p && *p == *q)
80104196:	39 f2                	cmp    %esi,%edx
80104198:	74 12                	je     801041ac <strncmp+0x34>
8010419a:	0f b6 03             	movzbl (%ebx),%eax
8010419d:	0f b6 0a             	movzbl (%edx),%ecx
801041a0:	84 c0                	test   %al,%al
801041a2:	75 ec                	jne    80104190 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801041a4:	29 c8                	sub    %ecx,%eax
}
801041a6:	5b                   	pop    %ebx
801041a7:	5e                   	pop    %esi
801041a8:	5d                   	pop    %ebp
801041a9:	c3                   	ret    
801041aa:	66 90                	xchg   %ax,%ax
    return 0;
801041ac:	31 c0                	xor    %eax,%eax
}
801041ae:	5b                   	pop    %ebx
801041af:	5e                   	pop    %esi
801041b0:	5d                   	pop    %ebp
801041b1:	c3                   	ret    
801041b2:	66 90                	xchg   %ax,%ax

801041b4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
801041b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801041bf:	8b 55 08             	mov    0x8(%ebp),%edx
801041c2:	eb 0c                	jmp    801041d0 <strncpy+0x1c>
801041c4:	41                   	inc    %ecx
801041c5:	42                   	inc    %edx
801041c6:	8a 41 ff             	mov    -0x1(%ecx),%al
801041c9:	88 42 ff             	mov    %al,-0x1(%edx)
801041cc:	84 c0                	test   %al,%al
801041ce:	74 07                	je     801041d7 <strncpy+0x23>
801041d0:	89 de                	mov    %ebx,%esi
801041d2:	4b                   	dec    %ebx
801041d3:	85 f6                	test   %esi,%esi
801041d5:	7f ed                	jg     801041c4 <strncpy+0x10>
    ;
  while(n-- > 0)
801041d7:	89 d1                	mov    %edx,%ecx
801041d9:	85 db                	test   %ebx,%ebx
801041db:	7e 14                	jle    801041f1 <strncpy+0x3d>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
801041e0:	41                   	inc    %ecx
801041e1:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801041e5:	89 d3                	mov    %edx,%ebx
801041e7:	29 cb                	sub    %ecx,%ebx
801041e9:	8d 5c 1e ff          	lea    -0x1(%esi,%ebx,1),%ebx
801041ed:	85 db                	test   %ebx,%ebx
801041ef:	7f ef                	jg     801041e0 <strncpy+0x2c>
  return os;
}
801041f1:	8b 45 08             	mov    0x8(%ebp),%eax
801041f4:	5b                   	pop    %ebx
801041f5:	5e                   	pop    %esi
801041f6:	5d                   	pop    %ebp
801041f7:	c3                   	ret    

801041f8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801041f8:	55                   	push   %ebp
801041f9:	89 e5                	mov    %esp,%ebp
801041fb:	56                   	push   %esi
801041fc:	53                   	push   %ebx
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	8b 55 0c             	mov    0xc(%ebp),%edx
80104203:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80104206:	85 c9                	test   %ecx,%ecx
80104208:	7e 1d                	jle    80104227 <safestrcpy+0x2f>
8010420a:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
8010420e:	89 c1                	mov    %eax,%ecx
80104210:	eb 0e                	jmp    80104220 <safestrcpy+0x28>
80104212:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104214:	42                   	inc    %edx
80104215:	41                   	inc    %ecx
80104216:	8a 5a ff             	mov    -0x1(%edx),%bl
80104219:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010421c:	84 db                	test   %bl,%bl
8010421e:	74 04                	je     80104224 <safestrcpy+0x2c>
80104220:	39 f2                	cmp    %esi,%edx
80104222:	75 f0                	jne    80104214 <safestrcpy+0x1c>
    ;
  *s = 0;
80104224:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104227:	5b                   	pop    %ebx
80104228:	5e                   	pop    %esi
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
8010422b:	90                   	nop

8010422c <strlen>:

int
strlen(const char *s)
{
8010422c:	55                   	push   %ebp
8010422d:	89 e5                	mov    %esp,%ebp
8010422f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104232:	31 c0                	xor    %eax,%eax
80104234:	80 3a 00             	cmpb   $0x0,(%edx)
80104237:	74 0a                	je     80104243 <strlen+0x17>
80104239:	8d 76 00             	lea    0x0(%esi),%esi
8010423c:	40                   	inc    %eax
8010423d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104241:	75 f9                	jne    8010423c <strlen+0x10>
    ;
  return n;
}
80104243:	5d                   	pop    %ebp
80104244:	c3                   	ret    

80104245 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104245:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104249:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010424d:	55                   	push   %ebp
  pushl %ebx
8010424e:	53                   	push   %ebx
  pushl %esi
8010424f:	56                   	push   %esi
  pushl %edi
80104250:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104251:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104253:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104255:	5f                   	pop    %edi
  popl %esi
80104256:	5e                   	pop    %esi
  popl %ebx
80104257:	5b                   	pop    %ebx
  popl %ebp
80104258:	5d                   	pop    %ebp
  ret
80104259:	c3                   	ret    
8010425a:	66 90                	xchg   %ax,%ax

8010425c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010425c:	55                   	push   %ebp
8010425d:	89 e5                	mov    %esp,%ebp
8010425f:	53                   	push   %ebx
80104260:	50                   	push   %eax
80104261:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104264:	e8 43 f2 ff ff       	call   801034ac <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104269:	8b 00                	mov    (%eax),%eax
8010426b:	39 d8                	cmp    %ebx,%eax
8010426d:	76 15                	jbe    80104284 <fetchint+0x28>
8010426f:	8d 53 04             	lea    0x4(%ebx),%edx
80104272:	39 d0                	cmp    %edx,%eax
80104274:	72 0e                	jb     80104284 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104276:	8b 13                	mov    (%ebx),%edx
80104278:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427b:	89 10                	mov    %edx,(%eax)
  return 0;
8010427d:	31 c0                	xor    %eax,%eax
}
8010427f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104282:	c9                   	leave  
80104283:	c3                   	ret    
    return -1;
80104284:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104289:	eb f4                	jmp    8010427f <fetchint+0x23>
8010428b:	90                   	nop

8010428c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010428c:	55                   	push   %ebp
8010428d:	89 e5                	mov    %esp,%ebp
8010428f:	53                   	push   %ebx
80104290:	50                   	push   %eax
80104291:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104294:	e8 13 f2 ff ff       	call   801034ac <myproc>

  if(addr >= curproc->sz)
80104299:	39 18                	cmp    %ebx,(%eax)
8010429b:	76 23                	jbe    801042c0 <fetchstr+0x34>
    return -1;
  *pp = (char*)addr;
8010429d:	8b 55 0c             	mov    0xc(%ebp),%edx
801042a0:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801042a2:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801042a4:	39 d3                	cmp    %edx,%ebx
801042a6:	73 18                	jae    801042c0 <fetchstr+0x34>
801042a8:	89 d8                	mov    %ebx,%eax
801042aa:	eb 05                	jmp    801042b1 <fetchstr+0x25>
801042ac:	40                   	inc    %eax
801042ad:	39 c2                	cmp    %eax,%edx
801042af:	76 0f                	jbe    801042c0 <fetchstr+0x34>
    if(*s == 0)
801042b1:	80 38 00             	cmpb   $0x0,(%eax)
801042b4:	75 f6                	jne    801042ac <fetchstr+0x20>
      return s - *pp;
801042b6:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801042b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042bb:	c9                   	leave  
801042bc:	c3                   	ret    
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801042c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    
801042ca:	66 90                	xchg   %ax,%ax

801042cc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801042cc:	55                   	push   %ebp
801042cd:	89 e5                	mov    %esp,%ebp
801042cf:	56                   	push   %esi
801042d0:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801042d1:	e8 d6 f1 ff ff       	call   801034ac <myproc>
801042d6:	8b 40 18             	mov    0x18(%eax),%eax
801042d9:	8b 40 44             	mov    0x44(%eax),%eax
801042dc:	8b 55 08             	mov    0x8(%ebp),%edx
801042df:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
801042e2:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
801042e5:	e8 c2 f1 ff ff       	call   801034ac <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801042ea:	8b 00                	mov    (%eax),%eax
801042ec:	39 c6                	cmp    %eax,%esi
801042ee:	73 18                	jae    80104308 <argint+0x3c>
801042f0:	8d 53 08             	lea    0x8(%ebx),%edx
801042f3:	39 d0                	cmp    %edx,%eax
801042f5:	72 11                	jb     80104308 <argint+0x3c>
  *ip = *(int*)(addr);
801042f7:	8b 53 04             	mov    0x4(%ebx),%edx
801042fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801042fd:	89 10                	mov    %edx,(%eax)
  return 0;
801042ff:	31 c0                	xor    %eax,%eax
}
80104301:	5b                   	pop    %ebx
80104302:	5e                   	pop    %esi
80104303:	5d                   	pop    %ebp
80104304:	c3                   	ret    
80104305:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010430d:	eb f2                	jmp    80104301 <argint+0x35>
8010430f:	90                   	nop

80104310 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104319:	e8 8e f1 ff ff       	call   801034ac <myproc>
8010431e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104320:	e8 87 f1 ff ff       	call   801034ac <myproc>
80104325:	8b 40 18             	mov    0x18(%eax),%eax
80104328:	8b 40 44             	mov    0x44(%eax),%eax
8010432b:	8b 55 08             	mov    0x8(%ebp),%edx
8010432e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104331:	8d 7b 04             	lea    0x4(%ebx),%edi
  struct proc *curproc = myproc();
80104334:	e8 73 f1 ff ff       	call   801034ac <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104339:	8b 00                	mov    (%eax),%eax
8010433b:	39 c7                	cmp    %eax,%edi
8010433d:	73 31                	jae    80104370 <argptr+0x60>
8010433f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104342:	39 c8                	cmp    %ecx,%eax
80104344:	72 2a                	jb     80104370 <argptr+0x60>
  *ip = *(int*)(addr);
80104346:	8b 43 04             	mov    0x4(%ebx),%eax
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104349:	8b 55 10             	mov    0x10(%ebp),%edx
8010434c:	85 d2                	test   %edx,%edx
8010434e:	78 20                	js     80104370 <argptr+0x60>
80104350:	8b 16                	mov    (%esi),%edx
80104352:	39 c2                	cmp    %eax,%edx
80104354:	76 1a                	jbe    80104370 <argptr+0x60>
80104356:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104359:	01 c3                	add    %eax,%ebx
8010435b:	39 da                	cmp    %ebx,%edx
8010435d:	72 11                	jb     80104370 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010435f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104362:	89 02                	mov    %eax,(%edx)
  return 0;
80104364:	31 c0                	xor    %eax,%eax
}
80104366:	83 c4 0c             	add    $0xc,%esp
80104369:	5b                   	pop    %ebx
8010436a:	5e                   	pop    %esi
8010436b:	5f                   	pop    %edi
8010436c:	5d                   	pop    %ebp
8010436d:	c3                   	ret    
8010436e:	66 90                	xchg   %ax,%ax
    return -1;
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104375:	eb ef                	jmp    80104366 <argptr+0x56>
80104377:	90                   	nop

80104378 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104378:	55                   	push   %ebp
80104379:	89 e5                	mov    %esp,%ebp
8010437b:	56                   	push   %esi
8010437c:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010437d:	e8 2a f1 ff ff       	call   801034ac <myproc>
80104382:	8b 40 18             	mov    0x18(%eax),%eax
80104385:	8b 40 44             	mov    0x44(%eax),%eax
80104388:	8b 55 08             	mov    0x8(%ebp),%edx
8010438b:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
8010438e:	8d 73 04             	lea    0x4(%ebx),%esi
  struct proc *curproc = myproc();
80104391:	e8 16 f1 ff ff       	call   801034ac <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104396:	8b 00                	mov    (%eax),%eax
80104398:	39 c6                	cmp    %eax,%esi
8010439a:	73 34                	jae    801043d0 <argstr+0x58>
8010439c:	8d 53 08             	lea    0x8(%ebx),%edx
8010439f:	39 d0                	cmp    %edx,%eax
801043a1:	72 2d                	jb     801043d0 <argstr+0x58>
  *ip = *(int*)(addr);
801043a3:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801043a6:	e8 01 f1 ff ff       	call   801034ac <myproc>
  if(addr >= curproc->sz)
801043ab:	3b 18                	cmp    (%eax),%ebx
801043ad:	73 21                	jae    801043d0 <argstr+0x58>
  *pp = (char*)addr;
801043af:	8b 55 0c             	mov    0xc(%ebp),%edx
801043b2:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801043b4:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801043b6:	39 d3                	cmp    %edx,%ebx
801043b8:	73 16                	jae    801043d0 <argstr+0x58>
801043ba:	89 d8                	mov    %ebx,%eax
801043bc:	eb 07                	jmp    801043c5 <argstr+0x4d>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	40                   	inc    %eax
801043c1:	39 c2                	cmp    %eax,%edx
801043c3:	76 0b                	jbe    801043d0 <argstr+0x58>
    if(*s == 0)
801043c5:	80 38 00             	cmpb   $0x0,(%eax)
801043c8:	75 f6                	jne    801043c0 <argstr+0x48>
      return s - *pp;
801043ca:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801043cc:	5b                   	pop    %ebx
801043cd:	5e                   	pop    %esi
801043ce:	5d                   	pop    %ebp
801043cf:	c3                   	ret    
    return -1;
801043d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043d5:	5b                   	pop    %ebx
801043d6:	5e                   	pop    %esi
801043d7:	5d                   	pop    %ebp
801043d8:	c3                   	ret    
801043d9:	8d 76 00             	lea    0x0(%esi),%esi

801043dc <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801043dc:	55                   	push   %ebp
801043dd:	89 e5                	mov    %esp,%ebp
801043df:	53                   	push   %ebx
801043e0:	50                   	push   %eax
  int num;
  struct proc *curproc = myproc();
801043e1:	e8 c6 f0 ff ff       	call   801034ac <myproc>
801043e6:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801043e8:	8b 40 18             	mov    0x18(%eax),%eax
801043eb:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801043ee:	8d 50 ff             	lea    -0x1(%eax),%edx
801043f1:	83 fa 14             	cmp    $0x14,%edx
801043f4:	77 1a                	ja     80104410 <syscall+0x34>
801043f6:	8b 14 85 40 71 10 80 	mov    -0x7fef8ec0(,%eax,4),%edx
801043fd:	85 d2                	test   %edx,%edx
801043ff:	74 0f                	je     80104410 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104401:	ff d2                	call   *%edx
80104403:	8b 53 18             	mov    0x18(%ebx),%edx
80104406:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440c:	c9                   	leave  
8010440d:	c3                   	ret    
8010440e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104410:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104411:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104414:	50                   	push   %eax
80104415:	ff 73 10             	push   0x10(%ebx)
80104418:	68 1d 71 10 80       	push   $0x8010711d
8010441d:	e8 fa c1 ff ff       	call   8010061c <cprintf>
    curproc->tf->eax = -1;
80104422:	8b 43 18             	mov    0x18(%ebx),%eax
80104425:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010442c:	83 c4 10             	add    $0x10,%esp
}
8010442f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104432:	c9                   	leave  
80104433:	c3                   	ret    

80104434 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	57                   	push   %edi
80104438:	56                   	push   %esi
80104439:	53                   	push   %ebx
8010443a:	83 ec 34             	sub    $0x34,%esp
8010443d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104440:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104443:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104446:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104449:	8d 7d da             	lea    -0x26(%ebp),%edi
8010444c:	57                   	push   %edi
8010444d:	50                   	push   %eax
8010444e:	e8 f9 d9 ff ff       	call   80101e4c <nameiparent>
80104453:	83 c4 10             	add    $0x10,%esp
80104456:	85 c0                	test   %eax,%eax
80104458:	0f 84 22 01 00 00    	je     80104580 <create+0x14c>
8010445e:	89 c3                	mov    %eax,%ebx
    return 0;
  ilock(dp);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	50                   	push   %eax
80104464:	e8 57 d1 ff ff       	call   801015c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104469:	83 c4 0c             	add    $0xc,%esp
8010446c:	6a 00                	push   $0x0
8010446e:	57                   	push   %edi
8010446f:	53                   	push   %ebx
80104470:	e8 47 d6 ff ff       	call   80101abc <dirlookup>
80104475:	89 c6                	mov    %eax,%esi
80104477:	83 c4 10             	add    $0x10,%esp
8010447a:	85 c0                	test   %eax,%eax
8010447c:	74 46                	je     801044c4 <create+0x90>
    iunlockput(dp);
8010447e:	83 ec 0c             	sub    $0xc,%esp
80104481:	53                   	push   %ebx
80104482:	e8 89 d3 ff ff       	call   80101810 <iunlockput>
    ilock(ip);
80104487:	89 34 24             	mov    %esi,(%esp)
8010448a:	e8 31 d1 ff ff       	call   801015c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010448f:	83 c4 10             	add    $0x10,%esp
80104492:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104497:	75 13                	jne    801044ac <create+0x78>
80104499:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010449e:	75 0c                	jne    801044ac <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801044a0:	89 f0                	mov    %esi,%eax
801044a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044a5:	5b                   	pop    %ebx
801044a6:	5e                   	pop    %esi
801044a7:	5f                   	pop    %edi
801044a8:	5d                   	pop    %ebp
801044a9:	c3                   	ret    
801044aa:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801044ac:	83 ec 0c             	sub    $0xc,%esp
801044af:	56                   	push   %esi
801044b0:	e8 5b d3 ff ff       	call   80101810 <iunlockput>
    return 0;
801044b5:	83 c4 10             	add    $0x10,%esp
801044b8:	31 f6                	xor    %esi,%esi
}
801044ba:	89 f0                	mov    %esi,%eax
801044bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044bf:	5b                   	pop    %ebx
801044c0:	5e                   	pop    %esi
801044c1:	5f                   	pop    %edi
801044c2:	5d                   	pop    %ebp
801044c3:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801044c4:	83 ec 08             	sub    $0x8,%esp
801044c7:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801044cb:	50                   	push   %eax
801044cc:	ff 33                	push   (%ebx)
801044ce:	e8 95 cf ff ff       	call   80101468 <ialloc>
801044d3:	89 c6                	mov    %eax,%esi
801044d5:	83 c4 10             	add    $0x10,%esp
801044d8:	85 c0                	test   %eax,%eax
801044da:	0f 84 b9 00 00 00    	je     80104599 <create+0x165>
  ilock(ip);
801044e0:	83 ec 0c             	sub    $0xc,%esp
801044e3:	50                   	push   %eax
801044e4:	e8 d7 d0 ff ff       	call   801015c0 <ilock>
  ip->major = major;
801044e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801044ec:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801044f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801044f3:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801044f7:	66 c7 46 56 01 00    	movw   $0x1,0x56(%esi)
  iupdate(ip);
801044fd:	89 34 24             	mov    %esi,(%esp)
80104500:	e8 13 d0 ff ff       	call   80101518 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104505:	83 c4 10             	add    $0x10,%esp
80104508:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010450d:	74 29                	je     80104538 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
8010450f:	50                   	push   %eax
80104510:	ff 76 04             	push   0x4(%esi)
80104513:	57                   	push   %edi
80104514:	53                   	push   %ebx
80104515:	e8 6a d8 ff ff       	call   80101d84 <dirlink>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	85 c0                	test   %eax,%eax
8010451f:	78 6b                	js     8010458c <create+0x158>
  iunlockput(dp);
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	53                   	push   %ebx
80104525:	e8 e6 d2 ff ff       	call   80101810 <iunlockput>
  return ip;
8010452a:	83 c4 10             	add    $0x10,%esp
}
8010452d:	89 f0                	mov    %esi,%eax
8010452f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	5f                   	pop    %edi
80104535:	5d                   	pop    %ebp
80104536:	c3                   	ret    
80104537:	90                   	nop
    dp->nlink++;  // for ".."
80104538:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
8010453c:	83 ec 0c             	sub    $0xc,%esp
8010453f:	53                   	push   %ebx
80104540:	e8 d3 cf ff ff       	call   80101518 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104545:	83 c4 0c             	add    $0xc,%esp
80104548:	ff 76 04             	push   0x4(%esi)
8010454b:	68 b4 71 10 80       	push   $0x801071b4
80104550:	56                   	push   %esi
80104551:	e8 2e d8 ff ff       	call   80101d84 <dirlink>
80104556:	83 c4 10             	add    $0x10,%esp
80104559:	85 c0                	test   %eax,%eax
8010455b:	78 16                	js     80104573 <create+0x13f>
8010455d:	52                   	push   %edx
8010455e:	ff 73 04             	push   0x4(%ebx)
80104561:	68 b3 71 10 80       	push   $0x801071b3
80104566:	56                   	push   %esi
80104567:	e8 18 d8 ff ff       	call   80101d84 <dirlink>
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	85 c0                	test   %eax,%eax
80104571:	79 9c                	jns    8010450f <create+0xdb>
      panic("create dots");
80104573:	83 ec 0c             	sub    $0xc,%esp
80104576:	68 a7 71 10 80       	push   $0x801071a7
8010457b:	e8 b8 bd ff ff       	call   80100338 <panic>
    return 0;
80104580:	31 f6                	xor    %esi,%esi
}
80104582:	89 f0                	mov    %esi,%eax
80104584:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104587:	5b                   	pop    %ebx
80104588:	5e                   	pop    %esi
80104589:	5f                   	pop    %edi
8010458a:	5d                   	pop    %ebp
8010458b:	c3                   	ret    
    panic("create: dirlink");
8010458c:	83 ec 0c             	sub    $0xc,%esp
8010458f:	68 b6 71 10 80       	push   $0x801071b6
80104594:	e8 9f bd ff ff       	call   80100338 <panic>
    panic("create: ialloc");
80104599:	83 ec 0c             	sub    $0xc,%esp
8010459c:	68 98 71 10 80       	push   $0x80107198
801045a1:	e8 92 bd ff ff       	call   80100338 <panic>
801045a6:	66 90                	xchg   %ax,%ax

801045a8 <sys_dup>:
{
801045a8:	55                   	push   %ebp
801045a9:	89 e5                	mov    %esp,%ebp
801045ab:	56                   	push   %esi
801045ac:	53                   	push   %ebx
801045ad:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801045b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045b3:	50                   	push   %eax
801045b4:	6a 00                	push   $0x0
801045b6:	e8 11 fd ff ff       	call   801042cc <argint>
801045bb:	83 c4 10             	add    $0x10,%esp
801045be:	85 c0                	test   %eax,%eax
801045c0:	78 2c                	js     801045ee <sys_dup+0x46>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801045c2:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801045c6:	77 26                	ja     801045ee <sys_dup+0x46>
801045c8:	e8 df ee ff ff       	call   801034ac <myproc>
801045cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045d0:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801045d4:	85 f6                	test   %esi,%esi
801045d6:	74 16                	je     801045ee <sys_dup+0x46>
  struct proc *curproc = myproc();
801045d8:	e8 cf ee ff ff       	call   801034ac <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801045dd:	31 db                	xor    %ebx,%ebx
801045df:	90                   	nop
    if(curproc->ofile[fd] == 0){
801045e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801045e4:	85 d2                	test   %edx,%edx
801045e6:	74 14                	je     801045fc <sys_dup+0x54>
  for(fd = 0; fd < NOFILE; fd++){
801045e8:	43                   	inc    %ebx
801045e9:	83 fb 10             	cmp    $0x10,%ebx
801045ec:	75 f2                	jne    801045e0 <sys_dup+0x38>
    return -1;
801045ee:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801045f3:	89 d8                	mov    %ebx,%eax
801045f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f8:	5b                   	pop    %ebx
801045f9:	5e                   	pop    %esi
801045fa:	5d                   	pop    %ebp
801045fb:	c3                   	ret    
      curproc->ofile[fd] = f;
801045fc:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	56                   	push   %esi
80104604:	e8 97 c7 ff ff       	call   80100da0 <filedup>
  return fd;
80104609:	83 c4 10             	add    $0x10,%esp
}
8010460c:	89 d8                	mov    %ebx,%eax
8010460e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104611:	5b                   	pop    %ebx
80104612:	5e                   	pop    %esi
80104613:	5d                   	pop    %ebp
80104614:	c3                   	ret    
80104615:	8d 76 00             	lea    0x0(%esi),%esi

80104618 <sys_read>:
{
80104618:	55                   	push   %ebp
80104619:	89 e5                	mov    %esp,%ebp
8010461b:	56                   	push   %esi
8010461c:	53                   	push   %ebx
8010461d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104620:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104623:	53                   	push   %ebx
80104624:	6a 00                	push   $0x0
80104626:	e8 a1 fc ff ff       	call   801042cc <argint>
8010462b:	83 c4 10             	add    $0x10,%esp
8010462e:	85 c0                	test   %eax,%eax
80104630:	78 56                	js     80104688 <sys_read+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104632:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104636:	77 50                	ja     80104688 <sys_read+0x70>
80104638:	e8 6f ee ff ff       	call   801034ac <myproc>
8010463d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104640:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104644:	85 f6                	test   %esi,%esi
80104646:	74 40                	je     80104688 <sys_read+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104648:	83 ec 08             	sub    $0x8,%esp
8010464b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010464e:	50                   	push   %eax
8010464f:	6a 02                	push   $0x2
80104651:	e8 76 fc ff ff       	call   801042cc <argint>
80104656:	83 c4 10             	add    $0x10,%esp
80104659:	85 c0                	test   %eax,%eax
8010465b:	78 2b                	js     80104688 <sys_read+0x70>
8010465d:	52                   	push   %edx
8010465e:	ff 75 f0             	push   -0x10(%ebp)
80104661:	53                   	push   %ebx
80104662:	6a 01                	push   $0x1
80104664:	e8 a7 fc ff ff       	call   80104310 <argptr>
80104669:	83 c4 10             	add    $0x10,%esp
8010466c:	85 c0                	test   %eax,%eax
8010466e:	78 18                	js     80104688 <sys_read+0x70>
  return fileread(f, p, n);
80104670:	50                   	push   %eax
80104671:	ff 75 f0             	push   -0x10(%ebp)
80104674:	ff 75 f4             	push   -0xc(%ebp)
80104677:	56                   	push   %esi
80104678:	e8 6b c8 ff ff       	call   80100ee8 <fileread>
8010467d:	83 c4 10             	add    $0x10,%esp
}
80104680:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104683:	5b                   	pop    %ebx
80104684:	5e                   	pop    %esi
80104685:	5d                   	pop    %ebp
80104686:	c3                   	ret    
80104687:	90                   	nop
    return -1;
80104688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468d:	eb f1                	jmp    80104680 <sys_read+0x68>
8010468f:	90                   	nop

80104690 <sys_write>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104698:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010469b:	53                   	push   %ebx
8010469c:	6a 00                	push   $0x0
8010469e:	e8 29 fc ff ff       	call   801042cc <argint>
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	85 c0                	test   %eax,%eax
801046a8:	78 56                	js     80104700 <sys_write+0x70>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801046aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801046ae:	77 50                	ja     80104700 <sys_write+0x70>
801046b0:	e8 f7 ed ff ff       	call   801034ac <myproc>
801046b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801046bc:	85 f6                	test   %esi,%esi
801046be:	74 40                	je     80104700 <sys_write+0x70>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801046c0:	83 ec 08             	sub    $0x8,%esp
801046c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801046c6:	50                   	push   %eax
801046c7:	6a 02                	push   $0x2
801046c9:	e8 fe fb ff ff       	call   801042cc <argint>
801046ce:	83 c4 10             	add    $0x10,%esp
801046d1:	85 c0                	test   %eax,%eax
801046d3:	78 2b                	js     80104700 <sys_write+0x70>
801046d5:	52                   	push   %edx
801046d6:	ff 75 f0             	push   -0x10(%ebp)
801046d9:	53                   	push   %ebx
801046da:	6a 01                	push   $0x1
801046dc:	e8 2f fc ff ff       	call   80104310 <argptr>
801046e1:	83 c4 10             	add    $0x10,%esp
801046e4:	85 c0                	test   %eax,%eax
801046e6:	78 18                	js     80104700 <sys_write+0x70>
  return filewrite(f, p, n);
801046e8:	50                   	push   %eax
801046e9:	ff 75 f0             	push   -0x10(%ebp)
801046ec:	ff 75 f4             	push   -0xc(%ebp)
801046ef:	56                   	push   %esi
801046f0:	e8 7f c8 ff ff       	call   80100f74 <filewrite>
801046f5:	83 c4 10             	add    $0x10,%esp
}
801046f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046fb:	5b                   	pop    %ebx
801046fc:	5e                   	pop    %esi
801046fd:	5d                   	pop    %ebp
801046fe:	c3                   	ret    
801046ff:	90                   	nop
    return -1;
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104705:	eb f1                	jmp    801046f8 <sys_write+0x68>
80104707:	90                   	nop

80104708 <sys_close>:
{
80104708:	55                   	push   %ebp
80104709:	89 e5                	mov    %esp,%ebp
8010470b:	56                   	push   %esi
8010470c:	53                   	push   %ebx
8010470d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104710:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104713:	50                   	push   %eax
80104714:	6a 00                	push   $0x0
80104716:	e8 b1 fb ff ff       	call   801042cc <argint>
8010471b:	83 c4 10             	add    $0x10,%esp
8010471e:	85 c0                	test   %eax,%eax
80104720:	78 3e                	js     80104760 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104722:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104726:	77 38                	ja     80104760 <sys_close+0x58>
80104728:	e8 7f ed ff ff       	call   801034ac <myproc>
8010472d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104730:	8d 5a 08             	lea    0x8(%edx),%ebx
80104733:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104737:	85 f6                	test   %esi,%esi
80104739:	74 25                	je     80104760 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
8010473b:	e8 6c ed ff ff       	call   801034ac <myproc>
80104740:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104747:	00 
  fileclose(f);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	56                   	push   %esi
8010474c:	e8 93 c6 ff ff       	call   80100de4 <fileclose>
  return 0;
80104751:	83 c4 10             	add    $0x10,%esp
80104754:	31 c0                	xor    %eax,%eax
}
80104756:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104759:	5b                   	pop    %ebx
8010475a:	5e                   	pop    %esi
8010475b:	5d                   	pop    %ebp
8010475c:	c3                   	ret    
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104765:	eb ef                	jmp    80104756 <sys_close+0x4e>
80104767:	90                   	nop

80104768 <sys_fstat>:
{
80104768:	55                   	push   %ebp
80104769:	89 e5                	mov    %esp,%ebp
8010476b:	56                   	push   %esi
8010476c:	53                   	push   %ebx
8010476d:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104770:	8d 5d f4             	lea    -0xc(%ebp),%ebx
80104773:	53                   	push   %ebx
80104774:	6a 00                	push   $0x0
80104776:	e8 51 fb ff ff       	call   801042cc <argint>
8010477b:	83 c4 10             	add    $0x10,%esp
8010477e:	85 c0                	test   %eax,%eax
80104780:	78 3e                	js     801047c0 <sys_fstat+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104782:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104786:	77 38                	ja     801047c0 <sys_fstat+0x58>
80104788:	e8 1f ed ff ff       	call   801034ac <myproc>
8010478d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104790:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104794:	85 f6                	test   %esi,%esi
80104796:	74 28                	je     801047c0 <sys_fstat+0x58>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104798:	50                   	push   %eax
80104799:	6a 14                	push   $0x14
8010479b:	53                   	push   %ebx
8010479c:	6a 01                	push   $0x1
8010479e:	e8 6d fb ff ff       	call   80104310 <argptr>
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	85 c0                	test   %eax,%eax
801047a8:	78 16                	js     801047c0 <sys_fstat+0x58>
  return filestat(f, st);
801047aa:	83 ec 08             	sub    $0x8,%esp
801047ad:	ff 75 f4             	push   -0xc(%ebp)
801047b0:	56                   	push   %esi
801047b1:	e8 ee c6 ff ff       	call   80100ea4 <filestat>
801047b6:	83 c4 10             	add    $0x10,%esp
}
801047b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047bc:	5b                   	pop    %ebx
801047bd:	5e                   	pop    %esi
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    
    return -1;
801047c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c5:	eb f2                	jmp    801047b9 <sys_fstat+0x51>
801047c7:	90                   	nop

801047c8 <sys_link>:
{
801047c8:	55                   	push   %ebp
801047c9:	89 e5                	mov    %esp,%ebp
801047cb:	57                   	push   %edi
801047cc:	56                   	push   %esi
801047cd:	53                   	push   %ebx
801047ce:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801047d1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801047d4:	50                   	push   %eax
801047d5:	6a 00                	push   $0x0
801047d7:	e8 9c fb ff ff       	call   80104378 <argstr>
801047dc:	83 c4 10             	add    $0x10,%esp
801047df:	85 c0                	test   %eax,%eax
801047e1:	0f 88 f2 00 00 00    	js     801048d9 <sys_link+0x111>
801047e7:	83 ec 08             	sub    $0x8,%esp
801047ea:	8d 45 d0             	lea    -0x30(%ebp),%eax
801047ed:	50                   	push   %eax
801047ee:	6a 01                	push   $0x1
801047f0:	e8 83 fb ff ff       	call   80104378 <argstr>
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	85 c0                	test   %eax,%eax
801047fa:	0f 88 d9 00 00 00    	js     801048d9 <sys_link+0x111>
  begin_op();
80104800:	e8 63 e1 ff ff       	call   80102968 <begin_op>
  if((ip = namei(old)) == 0){
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	ff 75 d4             	push   -0x2c(%ebp)
8010480b:	e8 24 d6 ff ff       	call   80101e34 <namei>
80104810:	89 c3                	mov    %eax,%ebx
80104812:	83 c4 10             	add    $0x10,%esp
80104815:	85 c0                	test   %eax,%eax
80104817:	0f 84 db 00 00 00    	je     801048f8 <sys_link+0x130>
  ilock(ip);
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	50                   	push   %eax
80104821:	e8 9a cd ff ff       	call   801015c0 <ilock>
  if(ip->type == T_DIR){
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010482e:	0f 84 ac 00 00 00    	je     801048e0 <sys_link+0x118>
  ip->nlink++;
80104834:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	53                   	push   %ebx
8010483c:	e8 d7 cc ff ff       	call   80101518 <iupdate>
  iunlock(ip);
80104841:	89 1c 24             	mov    %ebx,(%esp)
80104844:	e8 3f ce ff ff       	call   80101688 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104849:	5a                   	pop    %edx
8010484a:	59                   	pop    %ecx
8010484b:	8d 7d da             	lea    -0x26(%ebp),%edi
8010484e:	57                   	push   %edi
8010484f:	ff 75 d0             	push   -0x30(%ebp)
80104852:	e8 f5 d5 ff ff       	call   80101e4c <nameiparent>
80104857:	89 c6                	mov    %eax,%esi
80104859:	83 c4 10             	add    $0x10,%esp
8010485c:	85 c0                	test   %eax,%eax
8010485e:	74 54                	je     801048b4 <sys_link+0xec>
  ilock(dp);
80104860:	83 ec 0c             	sub    $0xc,%esp
80104863:	50                   	push   %eax
80104864:	e8 57 cd ff ff       	call   801015c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	8b 03                	mov    (%ebx),%eax
8010486e:	39 06                	cmp    %eax,(%esi)
80104870:	75 36                	jne    801048a8 <sys_link+0xe0>
80104872:	50                   	push   %eax
80104873:	ff 73 04             	push   0x4(%ebx)
80104876:	57                   	push   %edi
80104877:	56                   	push   %esi
80104878:	e8 07 d5 ff ff       	call   80101d84 <dirlink>
8010487d:	83 c4 10             	add    $0x10,%esp
80104880:	85 c0                	test   %eax,%eax
80104882:	78 24                	js     801048a8 <sys_link+0xe0>
  iunlockput(dp);
80104884:	83 ec 0c             	sub    $0xc,%esp
80104887:	56                   	push   %esi
80104888:	e8 83 cf ff ff       	call   80101810 <iunlockput>
  iput(ip);
8010488d:	89 1c 24             	mov    %ebx,(%esp)
80104890:	e8 37 ce ff ff       	call   801016cc <iput>
  end_op();
80104895:	e8 36 e1 ff ff       	call   801029d0 <end_op>
  return 0;
8010489a:	83 c4 10             	add    $0x10,%esp
8010489d:	31 c0                	xor    %eax,%eax
}
8010489f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048a2:	5b                   	pop    %ebx
801048a3:	5e                   	pop    %esi
801048a4:	5f                   	pop    %edi
801048a5:	5d                   	pop    %ebp
801048a6:	c3                   	ret    
801048a7:	90                   	nop
    iunlockput(dp);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	56                   	push   %esi
801048ac:	e8 5f cf ff ff       	call   80101810 <iunlockput>
    goto bad;
801048b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	53                   	push   %ebx
801048b8:	e8 03 cd ff ff       	call   801015c0 <ilock>
  ip->nlink--;
801048bd:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801048c1:	89 1c 24             	mov    %ebx,(%esp)
801048c4:	e8 4f cc ff ff       	call   80101518 <iupdate>
  iunlockput(ip);
801048c9:	89 1c 24             	mov    %ebx,(%esp)
801048cc:	e8 3f cf ff ff       	call   80101810 <iunlockput>
  end_op();
801048d1:	e8 fa e0 ff ff       	call   801029d0 <end_op>
  return -1;
801048d6:	83 c4 10             	add    $0x10,%esp
801048d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048de:	eb bf                	jmp    8010489f <sys_link+0xd7>
    iunlockput(ip);
801048e0:	83 ec 0c             	sub    $0xc,%esp
801048e3:	53                   	push   %ebx
801048e4:	e8 27 cf ff ff       	call   80101810 <iunlockput>
    end_op();
801048e9:	e8 e2 e0 ff ff       	call   801029d0 <end_op>
    return -1;
801048ee:	83 c4 10             	add    $0x10,%esp
801048f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048f6:	eb a7                	jmp    8010489f <sys_link+0xd7>
    end_op();
801048f8:	e8 d3 e0 ff ff       	call   801029d0 <end_op>
    return -1;
801048fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104902:	eb 9b                	jmp    8010489f <sys_link+0xd7>

80104904 <sys_unlink>:
{
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	57                   	push   %edi
80104908:	56                   	push   %esi
80104909:	53                   	push   %ebx
8010490a:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010490d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104910:	50                   	push   %eax
80104911:	6a 00                	push   $0x0
80104913:	e8 60 fa ff ff       	call   80104378 <argstr>
80104918:	83 c4 10             	add    $0x10,%esp
8010491b:	85 c0                	test   %eax,%eax
8010491d:	0f 88 71 01 00 00    	js     80104a94 <sys_unlink+0x190>
  begin_op();
80104923:	e8 40 e0 ff ff       	call   80102968 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104928:	83 ec 08             	sub    $0x8,%esp
8010492b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010492e:	53                   	push   %ebx
8010492f:	ff 75 c0             	push   -0x40(%ebp)
80104932:	e8 15 d5 ff ff       	call   80101e4c <nameiparent>
80104937:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010493a:	83 c4 10             	add    $0x10,%esp
8010493d:	85 c0                	test   %eax,%eax
8010493f:	0f 84 59 01 00 00    	je     80104a9e <sys_unlink+0x19a>
  ilock(dp);
80104945:	83 ec 0c             	sub    $0xc,%esp
80104948:	8b 7d b4             	mov    -0x4c(%ebp),%edi
8010494b:	57                   	push   %edi
8010494c:	e8 6f cc ff ff       	call   801015c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104951:	59                   	pop    %ecx
80104952:	5e                   	pop    %esi
80104953:	68 b4 71 10 80       	push   $0x801071b4
80104958:	53                   	push   %ebx
80104959:	e8 46 d1 ff ff       	call   80101aa4 <namecmp>
8010495e:	83 c4 10             	add    $0x10,%esp
80104961:	85 c0                	test   %eax,%eax
80104963:	0f 84 f7 00 00 00    	je     80104a60 <sys_unlink+0x15c>
80104969:	83 ec 08             	sub    $0x8,%esp
8010496c:	68 b3 71 10 80       	push   $0x801071b3
80104971:	53                   	push   %ebx
80104972:	e8 2d d1 ff ff       	call   80101aa4 <namecmp>
80104977:	83 c4 10             	add    $0x10,%esp
8010497a:	85 c0                	test   %eax,%eax
8010497c:	0f 84 de 00 00 00    	je     80104a60 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104982:	52                   	push   %edx
80104983:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104986:	50                   	push   %eax
80104987:	53                   	push   %ebx
80104988:	57                   	push   %edi
80104989:	e8 2e d1 ff ff       	call   80101abc <dirlookup>
8010498e:	89 c3                	mov    %eax,%ebx
80104990:	83 c4 10             	add    $0x10,%esp
80104993:	85 c0                	test   %eax,%eax
80104995:	0f 84 c5 00 00 00    	je     80104a60 <sys_unlink+0x15c>
  ilock(ip);
8010499b:	83 ec 0c             	sub    $0xc,%esp
8010499e:	50                   	push   %eax
8010499f:	e8 1c cc ff ff       	call   801015c0 <ilock>
  if(ip->nlink < 1)
801049a4:	83 c4 10             	add    $0x10,%esp
801049a7:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801049ac:	0f 8e 15 01 00 00    	jle    80104ac7 <sys_unlink+0x1c3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801049b2:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049b7:	74 67                	je     80104a20 <sys_unlink+0x11c>
801049b9:	8d 7d d8             	lea    -0x28(%ebp),%edi
  memset(&de, 0, sizeof(de));
801049bc:	50                   	push   %eax
801049bd:	6a 10                	push   $0x10
801049bf:	6a 00                	push   $0x0
801049c1:	57                   	push   %edi
801049c2:	e8 dd f6 ff ff       	call   801040a4 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801049c7:	6a 10                	push   $0x10
801049c9:	ff 75 c4             	push   -0x3c(%ebp)
801049cc:	57                   	push   %edi
801049cd:	ff 75 b4             	push   -0x4c(%ebp)
801049d0:	e8 af cf ff ff       	call   80101984 <writei>
801049d5:	83 c4 20             	add    $0x20,%esp
801049d8:	83 f8 10             	cmp    $0x10,%eax
801049db:	0f 85 d9 00 00 00    	jne    80104aba <sys_unlink+0x1b6>
  if(ip->type == T_DIR){
801049e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049e6:	0f 84 90 00 00 00    	je     80104a7c <sys_unlink+0x178>
  iunlockput(dp);
801049ec:	83 ec 0c             	sub    $0xc,%esp
801049ef:	ff 75 b4             	push   -0x4c(%ebp)
801049f2:	e8 19 ce ff ff       	call   80101810 <iunlockput>
  ip->nlink--;
801049f7:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801049fb:	89 1c 24             	mov    %ebx,(%esp)
801049fe:	e8 15 cb ff ff       	call   80101518 <iupdate>
  iunlockput(ip);
80104a03:	89 1c 24             	mov    %ebx,(%esp)
80104a06:	e8 05 ce ff ff       	call   80101810 <iunlockput>
  end_op();
80104a0b:	e8 c0 df ff ff       	call   801029d0 <end_op>
  return 0;
80104a10:	83 c4 10             	add    $0x10,%esp
80104a13:	31 c0                	xor    %eax,%eax
}
80104a15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5f                   	pop    %edi
80104a1b:	5d                   	pop    %ebp
80104a1c:	c3                   	ret    
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104a20:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104a24:	76 93                	jbe    801049b9 <sys_unlink+0xb5>
80104a26:	be 20 00 00 00       	mov    $0x20,%esi
80104a2b:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104a2e:	eb 08                	jmp    80104a38 <sys_unlink+0x134>
80104a30:	83 c6 10             	add    $0x10,%esi
80104a33:	3b 73 58             	cmp    0x58(%ebx),%esi
80104a36:	73 84                	jae    801049bc <sys_unlink+0xb8>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104a38:	6a 10                	push   $0x10
80104a3a:	56                   	push   %esi
80104a3b:	57                   	push   %edi
80104a3c:	53                   	push   %ebx
80104a3d:	e8 4a ce ff ff       	call   8010188c <readi>
80104a42:	83 c4 10             	add    $0x10,%esp
80104a45:	83 f8 10             	cmp    $0x10,%eax
80104a48:	75 63                	jne    80104aad <sys_unlink+0x1a9>
    if(de.inum != 0)
80104a4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104a4f:	74 df                	je     80104a30 <sys_unlink+0x12c>
    iunlockput(ip);
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	53                   	push   %ebx
80104a55:	e8 b6 cd ff ff       	call   80101810 <iunlockput>
    goto bad;
80104a5a:	83 c4 10             	add    $0x10,%esp
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80104a60:	83 ec 0c             	sub    $0xc,%esp
80104a63:	ff 75 b4             	push   -0x4c(%ebp)
80104a66:	e8 a5 cd ff ff       	call   80101810 <iunlockput>
  end_op();
80104a6b:	e8 60 df ff ff       	call   801029d0 <end_op>
  return -1;
80104a70:	83 c4 10             	add    $0x10,%esp
80104a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a78:	eb 9b                	jmp    80104a15 <sys_unlink+0x111>
80104a7a:	66 90                	xchg   %ax,%ax
    dp->nlink--;
80104a7c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104a7f:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
80104a83:	83 ec 0c             	sub    $0xc,%esp
80104a86:	50                   	push   %eax
80104a87:	e8 8c ca ff ff       	call   80101518 <iupdate>
80104a8c:	83 c4 10             	add    $0x10,%esp
80104a8f:	e9 58 ff ff ff       	jmp    801049ec <sys_unlink+0xe8>
    return -1;
80104a94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a99:	e9 77 ff ff ff       	jmp    80104a15 <sys_unlink+0x111>
    end_op();
80104a9e:	e8 2d df ff ff       	call   801029d0 <end_op>
    return -1;
80104aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa8:	e9 68 ff ff ff       	jmp    80104a15 <sys_unlink+0x111>
      panic("isdirempty: readi");
80104aad:	83 ec 0c             	sub    $0xc,%esp
80104ab0:	68 d8 71 10 80       	push   $0x801071d8
80104ab5:	e8 7e b8 ff ff       	call   80100338 <panic>
    panic("unlink: writei");
80104aba:	83 ec 0c             	sub    $0xc,%esp
80104abd:	68 ea 71 10 80       	push   $0x801071ea
80104ac2:	e8 71 b8 ff ff       	call   80100338 <panic>
    panic("unlink: nlink < 1");
80104ac7:	83 ec 0c             	sub    $0xc,%esp
80104aca:	68 c6 71 10 80       	push   $0x801071c6
80104acf:	e8 64 b8 ff ff       	call   80100338 <panic>

80104ad4 <sys_open>:

int
sys_open(void)
{
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	56                   	push   %esi
80104ad8:	53                   	push   %ebx
80104ad9:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104adc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104adf:	50                   	push   %eax
80104ae0:	6a 00                	push   $0x0
80104ae2:	e8 91 f8 ff ff       	call   80104378 <argstr>
80104ae7:	83 c4 10             	add    $0x10,%esp
80104aea:	85 c0                	test   %eax,%eax
80104aec:	0f 88 8d 00 00 00    	js     80104b7f <sys_open+0xab>
80104af2:	83 ec 08             	sub    $0x8,%esp
80104af5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104af8:	50                   	push   %eax
80104af9:	6a 01                	push   $0x1
80104afb:	e8 cc f7 ff ff       	call   801042cc <argint>
80104b00:	83 c4 10             	add    $0x10,%esp
80104b03:	85 c0                	test   %eax,%eax
80104b05:	78 78                	js     80104b7f <sys_open+0xab>
    return -1;

  begin_op();
80104b07:	e8 5c de ff ff       	call   80102968 <begin_op>

  if(omode & O_CREATE){
80104b0c:	f6 45 f5 02          	testb  $0x2,-0xb(%ebp)
80104b10:	75 76                	jne    80104b88 <sys_open+0xb4>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104b12:	83 ec 0c             	sub    $0xc,%esp
80104b15:	ff 75 f0             	push   -0x10(%ebp)
80104b18:	e8 17 d3 ff ff       	call   80101e34 <namei>
80104b1d:	89 c3                	mov    %eax,%ebx
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	74 7f                	je     80104ba5 <sys_open+0xd1>
      end_op();
      return -1;
    }
    ilock(ip);
80104b26:	83 ec 0c             	sub    $0xc,%esp
80104b29:	50                   	push   %eax
80104b2a:	e8 91 ca ff ff       	call   801015c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b37:	0f 84 bf 00 00 00    	je     80104bfc <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104b3d:	e8 fe c1 ff ff       	call   80100d40 <filealloc>
80104b42:	89 c6                	mov    %eax,%esi
80104b44:	85 c0                	test   %eax,%eax
80104b46:	74 26                	je     80104b6e <sys_open+0x9a>
  struct proc *curproc = myproc();
80104b48:	e8 5f e9 ff ff       	call   801034ac <myproc>
80104b4d:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80104b4f:	31 c0                	xor    %eax,%eax
80104b51:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104b54:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80104b58:	85 c9                	test   %ecx,%ecx
80104b5a:	74 58                	je     80104bb4 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80104b5c:	40                   	inc    %eax
80104b5d:	83 f8 10             	cmp    $0x10,%eax
80104b60:	75 f2                	jne    80104b54 <sys_open+0x80>
    if(f)
      fileclose(f);
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	56                   	push   %esi
80104b66:	e8 79 c2 ff ff       	call   80100de4 <fileclose>
80104b6b:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104b6e:	83 ec 0c             	sub    $0xc,%esp
80104b71:	53                   	push   %ebx
80104b72:	e8 99 cc ff ff       	call   80101810 <iunlockput>
    end_op();
80104b77:	e8 54 de ff ff       	call   801029d0 <end_op>
    return -1;
80104b7c:	83 c4 10             	add    $0x10,%esp
80104b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b84:	eb 6d                	jmp    80104bf3 <sys_open+0x11f>
80104b86:	66 90                	xchg   %ax,%ax
    ip = create(path, T_FILE, 0, 0);
80104b88:	83 ec 0c             	sub    $0xc,%esp
80104b8b:	6a 00                	push   $0x0
80104b8d:	31 c9                	xor    %ecx,%ecx
80104b8f:	ba 02 00 00 00       	mov    $0x2,%edx
80104b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b97:	e8 98 f8 ff ff       	call   80104434 <create>
80104b9c:	89 c3                	mov    %eax,%ebx
    if(ip == 0){
80104b9e:	83 c4 10             	add    $0x10,%esp
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	75 98                	jne    80104b3d <sys_open+0x69>
      end_op();
80104ba5:	e8 26 de ff ff       	call   801029d0 <end_op>
      return -1;
80104baa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104baf:	eb 42                	jmp    80104bf3 <sys_open+0x11f>
80104bb1:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104bb4:	89 74 82 28          	mov    %esi,0x28(%edx,%eax,4)
80104bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  }
  iunlock(ip);
80104bbb:	83 ec 0c             	sub    $0xc,%esp
80104bbe:	53                   	push   %ebx
80104bbf:	e8 c4 ca ff ff       	call   80101688 <iunlock>
  end_op();
80104bc4:	e8 07 de ff ff       	call   801029d0 <end_op>

  f->type = FD_INODE;
80104bc9:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
80104bcf:	89 5e 10             	mov    %ebx,0x10(%esi)
  f->off = 0;
80104bd2:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80104bd9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104bdc:	89 ca                	mov    %ecx,%edx
80104bde:	f7 d2                	not    %edx
80104be0:	83 e2 01             	and    $0x1,%edx
80104be3:	88 56 08             	mov    %dl,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104be6:	83 c4 10             	add    $0x10,%esp
80104be9:	83 e1 03             	and    $0x3,%ecx
80104bec:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
80104bf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80104bf3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bf6:	5b                   	pop    %ebx
80104bf7:	5e                   	pop    %esi
80104bf8:	5d                   	pop    %ebp
80104bf9:	c3                   	ret    
80104bfa:	66 90                	xchg   %ax,%ax
    if(ip->type == T_DIR && omode != O_RDONLY){
80104bfc:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104bff:	85 f6                	test   %esi,%esi
80104c01:	0f 84 36 ff ff ff    	je     80104b3d <sys_open+0x69>
80104c07:	e9 62 ff ff ff       	jmp    80104b6e <sys_open+0x9a>

80104c0c <sys_mkdir>:

int
sys_mkdir(void)
{
80104c0c:	55                   	push   %ebp
80104c0d:	89 e5                	mov    %esp,%ebp
80104c0f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104c12:	e8 51 dd ff ff       	call   80102968 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104c17:	83 ec 08             	sub    $0x8,%esp
80104c1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c1d:	50                   	push   %eax
80104c1e:	6a 00                	push   $0x0
80104c20:	e8 53 f7 ff ff       	call   80104378 <argstr>
80104c25:	83 c4 10             	add    $0x10,%esp
80104c28:	85 c0                	test   %eax,%eax
80104c2a:	78 30                	js     80104c5c <sys_mkdir+0x50>
80104c2c:	83 ec 0c             	sub    $0xc,%esp
80104c2f:	6a 00                	push   $0x0
80104c31:	31 c9                	xor    %ecx,%ecx
80104c33:	ba 01 00 00 00       	mov    $0x1,%edx
80104c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3b:	e8 f4 f7 ff ff       	call   80104434 <create>
80104c40:	83 c4 10             	add    $0x10,%esp
80104c43:	85 c0                	test   %eax,%eax
80104c45:	74 15                	je     80104c5c <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104c47:	83 ec 0c             	sub    $0xc,%esp
80104c4a:	50                   	push   %eax
80104c4b:	e8 c0 cb ff ff       	call   80101810 <iunlockput>
  end_op();
80104c50:	e8 7b dd ff ff       	call   801029d0 <end_op>
  return 0;
80104c55:	83 c4 10             	add    $0x10,%esp
80104c58:	31 c0                	xor    %eax,%eax
}
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
    end_op();
80104c5c:	e8 6f dd ff ff       	call   801029d0 <end_op>
    return -1;
80104c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c66:	c9                   	leave  
80104c67:	c3                   	ret    

80104c68 <sys_mknod>:

int
sys_mknod(void)
{
80104c68:	55                   	push   %ebp
80104c69:	89 e5                	mov    %esp,%ebp
80104c6b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104c6e:	e8 f5 dc ff ff       	call   80102968 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104c73:	83 ec 08             	sub    $0x8,%esp
80104c76:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c79:	50                   	push   %eax
80104c7a:	6a 00                	push   $0x0
80104c7c:	e8 f7 f6 ff ff       	call   80104378 <argstr>
80104c81:	83 c4 10             	add    $0x10,%esp
80104c84:	85 c0                	test   %eax,%eax
80104c86:	78 60                	js     80104ce8 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104c88:	83 ec 08             	sub    $0x8,%esp
80104c8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c8e:	50                   	push   %eax
80104c8f:	6a 01                	push   $0x1
80104c91:	e8 36 f6 ff ff       	call   801042cc <argint>
  if((argstr(0, &path)) < 0 ||
80104c96:	83 c4 10             	add    $0x10,%esp
80104c99:	85 c0                	test   %eax,%eax
80104c9b:	78 4b                	js     80104ce8 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104c9d:	83 ec 08             	sub    $0x8,%esp
80104ca0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ca3:	50                   	push   %eax
80104ca4:	6a 02                	push   $0x2
80104ca6:	e8 21 f6 ff ff       	call   801042cc <argint>
     argint(1, &major) < 0 ||
80104cab:	83 c4 10             	add    $0x10,%esp
80104cae:	85 c0                	test   %eax,%eax
80104cb0:	78 36                	js     80104ce8 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104cb2:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104cb6:	83 ec 0c             	sub    $0xc,%esp
80104cb9:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104cbd:	50                   	push   %eax
80104cbe:	ba 03 00 00 00       	mov    $0x3,%edx
80104cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cc6:	e8 69 f7 ff ff       	call   80104434 <create>
     argint(2, &minor) < 0 ||
80104ccb:	83 c4 10             	add    $0x10,%esp
80104cce:	85 c0                	test   %eax,%eax
80104cd0:	74 16                	je     80104ce8 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	50                   	push   %eax
80104cd6:	e8 35 cb ff ff       	call   80101810 <iunlockput>
  end_op();
80104cdb:	e8 f0 dc ff ff       	call   801029d0 <end_op>
  return 0;
80104ce0:	83 c4 10             	add    $0x10,%esp
80104ce3:	31 c0                	xor    %eax,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	90                   	nop
    end_op();
80104ce8:	e8 e3 dc ff ff       	call   801029d0 <end_op>
    return -1;
80104ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    

80104cf4 <sys_chdir>:

int
sys_chdir(void)
{
80104cf4:	55                   	push   %ebp
80104cf5:	89 e5                	mov    %esp,%ebp
80104cf7:	56                   	push   %esi
80104cf8:	53                   	push   %ebx
80104cf9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104cfc:	e8 ab e7 ff ff       	call   801034ac <myproc>
80104d01:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104d03:	e8 60 dc ff ff       	call   80102968 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104d08:	83 ec 08             	sub    $0x8,%esp
80104d0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0e:	50                   	push   %eax
80104d0f:	6a 00                	push   $0x0
80104d11:	e8 62 f6 ff ff       	call   80104378 <argstr>
80104d16:	83 c4 10             	add    $0x10,%esp
80104d19:	85 c0                	test   %eax,%eax
80104d1b:	78 67                	js     80104d84 <sys_chdir+0x90>
80104d1d:	83 ec 0c             	sub    $0xc,%esp
80104d20:	ff 75 f4             	push   -0xc(%ebp)
80104d23:	e8 0c d1 ff ff       	call   80101e34 <namei>
80104d28:	89 c3                	mov    %eax,%ebx
80104d2a:	83 c4 10             	add    $0x10,%esp
80104d2d:	85 c0                	test   %eax,%eax
80104d2f:	74 53                	je     80104d84 <sys_chdir+0x90>
    end_op();
    return -1;
  }
  ilock(ip);
80104d31:	83 ec 0c             	sub    $0xc,%esp
80104d34:	50                   	push   %eax
80104d35:	e8 86 c8 ff ff       	call   801015c0 <ilock>
  if(ip->type != T_DIR){
80104d3a:	83 c4 10             	add    $0x10,%esp
80104d3d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d42:	75 28                	jne    80104d6c <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104d44:	83 ec 0c             	sub    $0xc,%esp
80104d47:	53                   	push   %ebx
80104d48:	e8 3b c9 ff ff       	call   80101688 <iunlock>
  iput(curproc->cwd);
80104d4d:	58                   	pop    %eax
80104d4e:	ff 76 68             	push   0x68(%esi)
80104d51:	e8 76 c9 ff ff       	call   801016cc <iput>
  end_op();
80104d56:	e8 75 dc ff ff       	call   801029d0 <end_op>
  curproc->cwd = ip;
80104d5b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104d5e:	83 c4 10             	add    $0x10,%esp
80104d61:	31 c0                	xor    %eax,%eax
}
80104d63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d66:	5b                   	pop    %ebx
80104d67:	5e                   	pop    %esi
80104d68:	5d                   	pop    %ebp
80104d69:	c3                   	ret    
80104d6a:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	53                   	push   %ebx
80104d70:	e8 9b ca ff ff       	call   80101810 <iunlockput>
    end_op();
80104d75:	e8 56 dc ff ff       	call   801029d0 <end_op>
    return -1;
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d82:	eb df                	jmp    80104d63 <sys_chdir+0x6f>
    end_op();
80104d84:	e8 47 dc ff ff       	call   801029d0 <end_op>
    return -1;
80104d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d8e:	eb d3                	jmp    80104d63 <sys_chdir+0x6f>

80104d90 <sys_exec>:

int
sys_exec(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
80104d95:	53                   	push   %ebx
80104d96:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104d9c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104da2:	50                   	push   %eax
80104da3:	6a 00                	push   $0x0
80104da5:	e8 ce f5 ff ff       	call   80104378 <argstr>
80104daa:	83 c4 10             	add    $0x10,%esp
80104dad:	85 c0                	test   %eax,%eax
80104daf:	78 79                	js     80104e2a <sys_exec+0x9a>
80104db1:	83 ec 08             	sub    $0x8,%esp
80104db4:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104dba:	50                   	push   %eax
80104dbb:	6a 01                	push   $0x1
80104dbd:	e8 0a f5 ff ff       	call   801042cc <argint>
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 61                	js     80104e2a <sys_exec+0x9a>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104dc9:	50                   	push   %eax
80104dca:	68 80 00 00 00       	push   $0x80
80104dcf:	6a 00                	push   $0x0
80104dd1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
80104dd7:	57                   	push   %edi
80104dd8:	e8 c7 f2 ff ff       	call   801040a4 <memset>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	31 db                	xor    %ebx,%ebx
  for(i=0;; i++){
80104de2:	31 f6                	xor    %esi,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104de4:	83 ec 08             	sub    $0x8,%esp
80104de7:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104ded:	50                   	push   %eax
80104dee:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104df4:	01 d8                	add    %ebx,%eax
80104df6:	50                   	push   %eax
80104df7:	e8 60 f4 ff ff       	call   8010425c <fetchint>
80104dfc:	83 c4 10             	add    $0x10,%esp
80104dff:	85 c0                	test   %eax,%eax
80104e01:	78 27                	js     80104e2a <sys_exec+0x9a>
      return -1;
    if(uarg == 0){
80104e03:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	74 2b                	je     80104e38 <sys_exec+0xa8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104e0d:	83 ec 08             	sub    $0x8,%esp
80104e10:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80104e13:	52                   	push   %edx
80104e14:	50                   	push   %eax
80104e15:	e8 72 f4 ff ff       	call   8010428c <fetchstr>
80104e1a:	83 c4 10             	add    $0x10,%esp
80104e1d:	85 c0                	test   %eax,%eax
80104e1f:	78 09                	js     80104e2a <sys_exec+0x9a>
  for(i=0;; i++){
80104e21:	46                   	inc    %esi
    if(i >= NELEM(argv))
80104e22:	83 c3 04             	add    $0x4,%ebx
80104e25:	83 fe 20             	cmp    $0x20,%esi
80104e28:	75 ba                	jne    80104de4 <sys_exec+0x54>
    return -1;
80104e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e32:	5b                   	pop    %ebx
80104e33:	5e                   	pop    %esi
80104e34:	5f                   	pop    %edi
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	90                   	nop
      argv[i] = 0;
80104e38:	c7 84 b5 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%esi,4)
80104e3f:	00 00 00 00 
  return exec(path, argv);
80104e43:	83 ec 08             	sub    $0x8,%esp
80104e46:	57                   	push   %edi
80104e47:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80104e4d:	e8 9a bb ff ff       	call   801009ec <exec>
80104e52:	83 c4 10             	add    $0x10,%esp
}
80104e55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e58:	5b                   	pop    %ebx
80104e59:	5e                   	pop    %esi
80104e5a:	5f                   	pop    %edi
80104e5b:	5d                   	pop    %ebp
80104e5c:	c3                   	ret    
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <sys_pipe>:

int
sys_pipe(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
80104e65:	53                   	push   %ebx
80104e66:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104e69:	6a 08                	push   $0x8
80104e6b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80104e6e:	50                   	push   %eax
80104e6f:	6a 00                	push   $0x0
80104e71:	e8 9a f4 ff ff       	call   80104310 <argptr>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	78 48                	js     80104ec5 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104e7d:	83 ec 08             	sub    $0x8,%esp
80104e80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e83:	50                   	push   %eax
80104e84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e87:	50                   	push   %eax
80104e88:	e8 fb e0 ff ff       	call   80102f88 <pipealloc>
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 31                	js     80104ec5 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104e94:	8b 7d e0             	mov    -0x20(%ebp),%edi
  struct proc *curproc = myproc();
80104e97:	e8 10 e6 ff ff       	call   801034ac <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e9c:	31 db                	xor    %ebx,%ebx
80104e9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ea0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80104ea4:	85 f6                	test   %esi,%esi
80104ea6:	74 24                	je     80104ecc <sys_pipe+0x6c>
  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	43                   	inc    %ebx
80104ea9:	83 fb 10             	cmp    $0x10,%ebx
80104eac:	75 f2                	jne    80104ea0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	ff 75 e0             	push   -0x20(%ebp)
80104eb4:	e8 2b bf ff ff       	call   80100de4 <fileclose>
    fileclose(wf);
80104eb9:	58                   	pop    %eax
80104eba:	ff 75 e4             	push   -0x1c(%ebp)
80104ebd:	e8 22 bf ff ff       	call   80100de4 <fileclose>
    return -1;
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eca:	eb 45                	jmp    80104f11 <sys_pipe+0xb1>
      curproc->ofile[fd] = f;
80104ecc:	8d 73 08             	lea    0x8(%ebx),%esi
80104ecf:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104ed3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80104ed6:	e8 d1 e5 ff ff       	call   801034ac <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104edb:	31 d2                	xor    %edx,%edx
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80104ee0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104ee4:	85 c9                	test   %ecx,%ecx
80104ee6:	74 18                	je     80104f00 <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
80104ee8:	42                   	inc    %edx
80104ee9:	83 fa 10             	cmp    $0x10,%edx
80104eec:	75 f2                	jne    80104ee0 <sys_pipe+0x80>
      myproc()->ofile[fd0] = 0;
80104eee:	e8 b9 e5 ff ff       	call   801034ac <myproc>
80104ef3:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80104efa:	00 
80104efb:	eb b1                	jmp    80104eae <sys_pipe+0x4e>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104f00:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80104f04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80104f09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104f0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80104f0f:	31 c0                	xor    %eax,%eax
}
80104f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f14:	5b                   	pop    %ebx
80104f15:	5e                   	pop    %esi
80104f16:	5f                   	pop    %edi
80104f17:	5d                   	pop    %ebp
80104f18:	c3                   	ret    
80104f19:	66 90                	xchg   %ax,%ax
80104f1b:	90                   	nop

80104f1c <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80104f1c:	e9 03 e7 ff ff       	jmp    80103624 <fork>
80104f21:	8d 76 00             	lea    0x0(%esi),%esi

80104f24 <sys_exit>:
}

int
sys_exit(void)
{
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	83 ec 08             	sub    $0x8,%esp
  exit();
80104f2a:	e8 4d e9 ff ff       	call   8010387c <exit>
  return 0;  // not reached
}
80104f2f:	31 c0                	xor    %eax,%eax
80104f31:	c9                   	leave  
80104f32:	c3                   	ret    
80104f33:	90                   	nop

80104f34 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80104f34:	e9 53 ea ff ff       	jmp    8010398c <wait>
80104f39:	8d 76 00             	lea    0x0(%esi),%esi

80104f3c <sys_kill>:
}

int
sys_kill(void)
{
80104f3c:	55                   	push   %ebp
80104f3d:	89 e5                	mov    %esp,%ebp
80104f3f:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104f42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f45:	50                   	push   %eax
80104f46:	6a 00                	push   $0x0
80104f48:	e8 7f f3 ff ff       	call   801042cc <argint>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	78 10                	js     80104f64 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104f54:	83 ec 0c             	sub    $0xc,%esp
80104f57:	ff 75 f4             	push   -0xc(%ebp)
80104f5a:	e8 b1 ec ff ff       	call   80103c10 <kill>
80104f5f:	83 c4 10             	add    $0x10,%esp
}
80104f62:	c9                   	leave  
80104f63:	c3                   	ret    
    return -1;
80104f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    
80104f6b:	90                   	nop

80104f6c <sys_getpid>:

int
sys_getpid(void)
{
80104f6c:	55                   	push   %ebp
80104f6d:	89 e5                	mov    %esp,%ebp
80104f6f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104f72:	e8 35 e5 ff ff       	call   801034ac <myproc>
80104f77:	8b 40 10             	mov    0x10(%eax),%eax
}
80104f7a:	c9                   	leave  
80104f7b:	c3                   	ret    

80104f7c <sys_sbrk>:

int
sys_sbrk(void)
{
80104f7c:	55                   	push   %ebp
80104f7d:	89 e5                	mov    %esp,%ebp
80104f7f:	53                   	push   %ebx
80104f80:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104f83:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f86:	50                   	push   %eax
80104f87:	6a 00                	push   $0x0
80104f89:	e8 3e f3 ff ff       	call   801042cc <argint>
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	78 23                	js     80104fb8 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80104f95:	e8 12 e5 ff ff       	call   801034ac <myproc>
80104f9a:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104f9c:	83 ec 0c             	sub    $0xc,%esp
80104f9f:	ff 75 f4             	push   -0xc(%ebp)
80104fa2:	e8 0d e6 ff ff       	call   801035b4 <growproc>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	78 0a                	js     80104fb8 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80104fae:	89 d8                	mov    %ebx,%eax
80104fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb3:	c9                   	leave  
80104fb4:	c3                   	ret    
80104fb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fb8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104fbd:	eb ef                	jmp    80104fae <sys_sbrk+0x32>
80104fbf:	90                   	nop

80104fc0 <sys_sleep>:

int
sys_sleep(void)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
80104fc4:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104fc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fca:	50                   	push   %eax
80104fcb:	6a 00                	push   $0x0
80104fcd:	e8 fa f2 ff ff       	call   801042cc <argint>
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	78 7e                	js     80105057 <sys_sleep+0x97>
    return -1;
  acquire(&tickslock);
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	68 80 3c 11 80       	push   $0x80113c80
80104fe1:	e8 16 f0 ff ff       	call   80103ffc <acquire>
  ticks0 = ticks;
80104fe6:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
80104fec:	83 c4 10             	add    $0x10,%esp
80104fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ff2:	85 d2                	test   %edx,%edx
80104ff4:	75 23                	jne    80105019 <sys_sleep+0x59>
80104ff6:	eb 48                	jmp    80105040 <sys_sleep+0x80>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104ff8:	83 ec 08             	sub    $0x8,%esp
80104ffb:	68 80 3c 11 80       	push   $0x80113c80
80105000:	68 60 3c 11 80       	push   $0x80113c60
80105005:	e8 f2 ea ff ff       	call   80103afc <sleep>
  while(ticks - ticks0 < n){
8010500a:	a1 60 3c 11 80       	mov    0x80113c60,%eax
8010500f:	29 d8                	sub    %ebx,%eax
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105017:	73 27                	jae    80105040 <sys_sleep+0x80>
    if(myproc()->killed){
80105019:	e8 8e e4 ff ff       	call   801034ac <myproc>
8010501e:	8b 40 24             	mov    0x24(%eax),%eax
80105021:	85 c0                	test   %eax,%eax
80105023:	74 d3                	je     80104ff8 <sys_sleep+0x38>
      release(&tickslock);
80105025:	83 ec 0c             	sub    $0xc,%esp
80105028:	68 80 3c 11 80       	push   $0x80113c80
8010502d:	e8 6a ef ff ff       	call   80103f9c <release>
      return -1;
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010503a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010503d:	c9                   	leave  
8010503e:	c3                   	ret    
8010503f:	90                   	nop
  release(&tickslock);
80105040:	83 ec 0c             	sub    $0xc,%esp
80105043:	68 80 3c 11 80       	push   $0x80113c80
80105048:	e8 4f ef ff ff       	call   80103f9c <release>
  return 0;
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105055:	c9                   	leave  
80105056:	c3                   	ret    
    return -1;
80105057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505c:	eb f4                	jmp    80105052 <sys_sleep+0x92>
8010505e:	66 90                	xchg   %ax,%ax

80105060 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	83 ec 24             	sub    $0x24,%esp
  uint xticks;

  acquire(&tickslock);
80105066:	68 80 3c 11 80       	push   $0x80113c80
8010506b:	e8 8c ef ff ff       	call   80103ffc <acquire>
  xticks = ticks;
80105070:	a1 60 3c 11 80       	mov    0x80113c60,%eax
80105075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80105078:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
8010507f:	e8 18 ef ff ff       	call   80103f9c <release>
  return xticks;
}
80105084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105087:	c9                   	leave  
80105088:	c3                   	ret    

80105089 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105089:	1e                   	push   %ds
  pushl %es
8010508a:	06                   	push   %es
  pushl %fs
8010508b:	0f a0                	push   %fs
  pushl %gs
8010508d:	0f a8                	push   %gs
  pushal
8010508f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105090:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105094:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105096:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105098:	54                   	push   %esp
  call trap
80105099:	e8 9e 00 00 00       	call   8010513c <trap>
  addl $4, %esp
8010509e:	83 c4 04             	add    $0x4,%esp

801050a1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801050a1:	61                   	popa   
  popl %gs
801050a2:	0f a9                	pop    %gs
  popl %fs
801050a4:	0f a1                	pop    %fs
  popl %es
801050a6:	07                   	pop    %es
  popl %ds
801050a7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801050a8:	83 c4 08             	add    $0x8,%esp
  iret
801050ab:	cf                   	iret   

801050ac <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801050ac:	55                   	push   %ebp
801050ad:	89 e5                	mov    %esp,%ebp
801050af:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
801050b2:	31 c0                	xor    %eax,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801050b4:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801050bb:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
801050c2:	80 
801050c3:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
801050ca:	08 00 00 8e 
801050ce:	c1 ea 10             	shr    $0x10,%edx
801050d1:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
801050d8:	80 
  for(i = 0; i < 256; i++)
801050d9:	40                   	inc    %eax
801050da:	3d 00 01 00 00       	cmp    $0x100,%eax
801050df:	75 d3                	jne    801050b4 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801050e1:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801050e6:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
801050ec:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
801050f3:	00 00 ef 
801050f6:	c1 e8 10             	shr    $0x10,%eax
801050f9:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6

  initlock(&tickslock, "time");
801050ff:	83 ec 08             	sub    $0x8,%esp
80105102:	68 f9 71 10 80       	push   $0x801071f9
80105107:	68 80 3c 11 80       	push   $0x80113c80
8010510c:	e8 33 ed ff ff       	call   80103e44 <initlock>
}
80105111:	83 c4 10             	add    $0x10,%esp
80105114:	c9                   	leave  
80105115:	c3                   	ret    
80105116:	66 90                	xchg   %ax,%ax

80105118 <idtinit>:

void
idtinit(void)
{
80105118:	55                   	push   %ebp
80105119:	89 e5                	mov    %esp,%ebp
8010511b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010511e:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105124:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105129:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010512d:	c1 e8 10             	shr    $0x10,%eax
80105130:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105134:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105137:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    

8010513c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010513c:	55                   	push   %ebp
8010513d:	89 e5                	mov    %esp,%ebp
8010513f:	57                   	push   %edi
80105140:	56                   	push   %esi
80105141:	53                   	push   %ebx
80105142:	83 ec 1c             	sub    $0x1c,%esp
80105145:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105148:	8b 43 30             	mov    0x30(%ebx),%eax
8010514b:	83 f8 40             	cmp    $0x40,%eax
8010514e:	0f 84 4c 01 00 00    	je     801052a0 <trap+0x164>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105154:	83 e8 20             	sub    $0x20,%eax
80105157:	83 f8 1f             	cmp    $0x1f,%eax
8010515a:	77 7c                	ja     801051d8 <trap+0x9c>
8010515c:	ff 24 85 a0 72 10 80 	jmp    *-0x7fef8d60(,%eax,4)
80105163:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105164:	e8 17 ce ff ff       	call   80101f80 <ideintr>
    lapiceoi();
80105169:	e8 2a d4 ff ff       	call   80102598 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010516e:	e8 39 e3 ff ff       	call   801034ac <myproc>
80105173:	85 c0                	test   %eax,%eax
80105175:	74 1c                	je     80105193 <trap+0x57>
80105177:	e8 30 e3 ff ff       	call   801034ac <myproc>
8010517c:	8b 50 24             	mov    0x24(%eax),%edx
8010517f:	85 d2                	test   %edx,%edx
80105181:	74 10                	je     80105193 <trap+0x57>
80105183:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105186:	83 e0 03             	and    $0x3,%eax
80105189:	66 83 f8 03          	cmp    $0x3,%ax
8010518d:	0f 84 c1 01 00 00    	je     80105354 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105193:	e8 14 e3 ff ff       	call   801034ac <myproc>
80105198:	85 c0                	test   %eax,%eax
8010519a:	74 0f                	je     801051ab <trap+0x6f>
8010519c:	e8 0b e3 ff ff       	call   801034ac <myproc>
801051a1:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801051a5:	0f 84 ad 00 00 00    	je     80105258 <trap+0x11c>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801051ab:	e8 fc e2 ff ff       	call   801034ac <myproc>
801051b0:	85 c0                	test   %eax,%eax
801051b2:	74 1c                	je     801051d0 <trap+0x94>
801051b4:	e8 f3 e2 ff ff       	call   801034ac <myproc>
801051b9:	8b 40 24             	mov    0x24(%eax),%eax
801051bc:	85 c0                	test   %eax,%eax
801051be:	74 10                	je     801051d0 <trap+0x94>
801051c0:	8b 43 3c             	mov    0x3c(%ebx),%eax
801051c3:	83 e0 03             	and    $0x3,%eax
801051c6:	66 83 f8 03          	cmp    $0x3,%ax
801051ca:	0f 84 fd 00 00 00    	je     801052cd <trap+0x191>
    exit();
}
801051d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d3:	5b                   	pop    %ebx
801051d4:	5e                   	pop    %esi
801051d5:	5f                   	pop    %edi
801051d6:	5d                   	pop    %ebp
801051d7:	c3                   	ret    
    if(myproc() == 0 || (tf->cs&3) == 0){
801051d8:	e8 cf e2 ff ff       	call   801034ac <myproc>
801051dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801051e0:	85 c0                	test   %eax,%eax
801051e2:	0f 84 82 01 00 00    	je     8010536a <trap+0x22e>
801051e8:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801051ec:	0f 84 78 01 00 00    	je     8010536a <trap+0x22e>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801051f2:	0f 20 d1             	mov    %cr2,%ecx
801051f5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051f8:	e8 7b e2 ff ff       	call   80103478 <cpuid>
801051fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105200:	8b 43 34             	mov    0x34(%ebx),%eax
80105203:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105206:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105209:	e8 9e e2 ff ff       	call   801034ac <myproc>
8010520e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105211:	e8 96 e2 ff ff       	call   801034ac <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105216:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105219:	51                   	push   %ecx
8010521a:	57                   	push   %edi
8010521b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010521e:	52                   	push   %edx
8010521f:	ff 75 e4             	push   -0x1c(%ebp)
80105222:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105223:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105226:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105229:	56                   	push   %esi
8010522a:	ff 70 10             	push   0x10(%eax)
8010522d:	68 5c 72 10 80       	push   $0x8010725c
80105232:	e8 e5 b3 ff ff       	call   8010061c <cprintf>
    myproc()->killed = 1;
80105237:	83 c4 20             	add    $0x20,%esp
8010523a:	e8 6d e2 ff ff       	call   801034ac <myproc>
8010523f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105246:	e8 61 e2 ff ff       	call   801034ac <myproc>
8010524b:	85 c0                	test   %eax,%eax
8010524d:	0f 85 24 ff ff ff    	jne    80105177 <trap+0x3b>
80105253:	e9 3b ff ff ff       	jmp    80105193 <trap+0x57>
  if(myproc() && myproc()->state == RUNNING &&
80105258:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010525c:	0f 85 49 ff ff ff    	jne    801051ab <trap+0x6f>
    yield();
80105262:	e8 4d e8 ff ff       	call   80103ab4 <yield>
80105267:	e9 3f ff ff ff       	jmp    801051ab <trap+0x6f>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010526c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010526f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105273:	e8 00 e2 ff ff       	call   80103478 <cpuid>
80105278:	57                   	push   %edi
80105279:	56                   	push   %esi
8010527a:	50                   	push   %eax
8010527b:	68 04 72 10 80       	push   $0x80107204
80105280:	e8 97 b3 ff ff       	call   8010061c <cprintf>
    lapiceoi();
80105285:	e8 0e d3 ff ff       	call   80102598 <lapiceoi>
    break;
8010528a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010528d:	e8 1a e2 ff ff       	call   801034ac <myproc>
80105292:	85 c0                	test   %eax,%eax
80105294:	0f 85 dd fe ff ff    	jne    80105177 <trap+0x3b>
8010529a:	e9 f4 fe ff ff       	jmp    80105193 <trap+0x57>
8010529f:	90                   	nop
    if(myproc()->killed)
801052a0:	e8 07 e2 ff ff       	call   801034ac <myproc>
801052a5:	8b 70 24             	mov    0x24(%eax),%esi
801052a8:	85 f6                	test   %esi,%esi
801052aa:	0f 85 b0 00 00 00    	jne    80105360 <trap+0x224>
    myproc()->tf = tf;
801052b0:	e8 f7 e1 ff ff       	call   801034ac <myproc>
801052b5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801052b8:	e8 1f f1 ff ff       	call   801043dc <syscall>
    if(myproc()->killed)
801052bd:	e8 ea e1 ff ff       	call   801034ac <myproc>
801052c2:	8b 48 24             	mov    0x24(%eax),%ecx
801052c5:	85 c9                	test   %ecx,%ecx
801052c7:	0f 84 03 ff ff ff    	je     801051d0 <trap+0x94>
}
801052cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d0:	5b                   	pop    %ebx
801052d1:	5e                   	pop    %esi
801052d2:	5f                   	pop    %edi
801052d3:	5d                   	pop    %ebp
      exit();
801052d4:	e9 a3 e5 ff ff       	jmp    8010387c <exit>
801052d9:	8d 76 00             	lea    0x0(%esi),%esi
    uartintr();
801052dc:	e8 ef 01 00 00       	call   801054d0 <uartintr>
    lapiceoi();
801052e1:	e8 b2 d2 ff ff       	call   80102598 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801052e6:	e8 c1 e1 ff ff       	call   801034ac <myproc>
801052eb:	85 c0                	test   %eax,%eax
801052ed:	0f 85 84 fe ff ff    	jne    80105177 <trap+0x3b>
801052f3:	e9 9b fe ff ff       	jmp    80105193 <trap+0x57>
    kbdintr();
801052f8:	e8 8b d1 ff ff       	call   80102488 <kbdintr>
    lapiceoi();
801052fd:	e8 96 d2 ff ff       	call   80102598 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105302:	e8 a5 e1 ff ff       	call   801034ac <myproc>
80105307:	85 c0                	test   %eax,%eax
80105309:	0f 85 68 fe ff ff    	jne    80105177 <trap+0x3b>
8010530f:	e9 7f fe ff ff       	jmp    80105193 <trap+0x57>
    if(cpuid() == 0){
80105314:	e8 5f e1 ff ff       	call   80103478 <cpuid>
80105319:	85 c0                	test   %eax,%eax
8010531b:	0f 85 48 fe ff ff    	jne    80105169 <trap+0x2d>
      acquire(&tickslock);
80105321:	83 ec 0c             	sub    $0xc,%esp
80105324:	68 80 3c 11 80       	push   $0x80113c80
80105329:	e8 ce ec ff ff       	call   80103ffc <acquire>
      ticks++;
8010532e:	ff 05 60 3c 11 80    	incl   0x80113c60
      wakeup(&ticks);
80105334:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
8010533b:	e8 78 e8 ff ff       	call   80103bb8 <wakeup>
      release(&tickslock);
80105340:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105347:	e8 50 ec ff ff       	call   80103f9c <release>
8010534c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010534f:	e9 15 fe ff ff       	jmp    80105169 <trap+0x2d>
    exit();
80105354:	e8 23 e5 ff ff       	call   8010387c <exit>
80105359:	e9 35 fe ff ff       	jmp    80105193 <trap+0x57>
8010535e:	66 90                	xchg   %ax,%ax
      exit();
80105360:	e8 17 e5 ff ff       	call   8010387c <exit>
80105365:	e9 46 ff ff ff       	jmp    801052b0 <trap+0x174>
8010536a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010536d:	e8 06 e1 ff ff       	call   80103478 <cpuid>
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	56                   	push   %esi
80105376:	57                   	push   %edi
80105377:	50                   	push   %eax
80105378:	ff 73 30             	push   0x30(%ebx)
8010537b:	68 28 72 10 80       	push   $0x80107228
80105380:	e8 97 b2 ff ff       	call   8010061c <cprintf>
      panic("trap");
80105385:	83 c4 14             	add    $0x14,%esp
80105388:	68 fe 71 10 80       	push   $0x801071fe
8010538d:	e8 a6 af ff ff       	call   80100338 <panic>
80105392:	66 90                	xchg   %ax,%ax

80105394 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105394:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105399:	85 c0                	test   %eax,%eax
8010539b:	74 17                	je     801053b4 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010539d:	ba fd 03 00 00       	mov    $0x3fd,%edx
801053a2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801053a3:	a8 01                	test   $0x1,%al
801053a5:	74 0d                	je     801053b4 <uartgetc+0x20>
801053a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801053ac:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801053ad:	0f b6 c0             	movzbl %al,%eax
801053b0:	c3                   	ret    
801053b1:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b9:	c3                   	ret    
801053ba:	66 90                	xchg   %ax,%ax

801053bc <uartinit>:
{
801053bc:	55                   	push   %ebp
801053bd:	89 e5                	mov    %esp,%ebp
801053bf:	57                   	push   %edi
801053c0:	56                   	push   %esi
801053c1:	53                   	push   %ebx
801053c2:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801053c5:	bf fa 03 00 00       	mov    $0x3fa,%edi
801053ca:	31 c0                	xor    %eax,%eax
801053cc:	89 fa                	mov    %edi,%edx
801053ce:	ee                   	out    %al,(%dx)
801053cf:	bb fb 03 00 00       	mov    $0x3fb,%ebx
801053d4:	b0 80                	mov    $0x80,%al
801053d6:	89 da                	mov    %ebx,%edx
801053d8:	ee                   	out    %al,(%dx)
801053d9:	be f8 03 00 00       	mov    $0x3f8,%esi
801053de:	b0 0c                	mov    $0xc,%al
801053e0:	89 f2                	mov    %esi,%edx
801053e2:	ee                   	out    %al,(%dx)
801053e3:	b9 f9 03 00 00       	mov    $0x3f9,%ecx
801053e8:	31 c0                	xor    %eax,%eax
801053ea:	89 ca                	mov    %ecx,%edx
801053ec:	ee                   	out    %al,(%dx)
801053ed:	b0 03                	mov    $0x3,%al
801053ef:	89 da                	mov    %ebx,%edx
801053f1:	ee                   	out    %al,(%dx)
801053f2:	ba fc 03 00 00       	mov    $0x3fc,%edx
801053f7:	31 c0                	xor    %eax,%eax
801053f9:	ee                   	out    %al,(%dx)
801053fa:	b0 01                	mov    $0x1,%al
801053fc:	89 ca                	mov    %ecx,%edx
801053fe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801053ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105404:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105405:	fe c0                	inc    %al
80105407:	74 77                	je     80105480 <uartinit+0xc4>
  uart = 1;
80105409:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105410:	00 00 00 
80105413:	89 fa                	mov    %edi,%edx
80105415:	ec                   	in     (%dx),%al
80105416:	89 f2                	mov    %esi,%edx
80105418:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105419:	83 ec 08             	sub    $0x8,%esp
8010541c:	6a 00                	push   $0x0
8010541e:	6a 04                	push   $0x4
80105420:	e8 6f cd ff ff       	call   80102194 <ioapicenable>
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
  for(p="xv6...\n"; *p; p++)
8010542c:	bf 20 73 10 80       	mov    $0x80107320,%edi
80105431:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80105435:	be fd 03 00 00       	mov    $0x3fd,%esi
8010543a:	66 90                	xchg   %ax,%ax
  if(!uart)
8010543c:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105441:	85 c0                	test   %eax,%eax
80105443:	74 27                	je     8010546c <uartinit+0xb0>
80105445:	bb 80 00 00 00       	mov    $0x80,%ebx
8010544a:	eb 10                	jmp    8010545c <uartinit+0xa0>
    microdelay(10);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	6a 0a                	push   $0xa
80105451:	e8 5a d1 ff ff       	call   801025b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	4b                   	dec    %ebx
8010545a:	74 07                	je     80105463 <uartinit+0xa7>
8010545c:	89 f2                	mov    %esi,%edx
8010545e:	ec                   	in     (%dx),%al
8010545f:	a8 20                	test   $0x20,%al
80105461:	74 e9                	je     8010544c <uartinit+0x90>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105463:	8a 45 e6             	mov    -0x1a(%ebp),%al
80105466:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010546b:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
8010546c:	47                   	inc    %edi
8010546d:	8a 45 e7             	mov    -0x19(%ebp),%al
80105470:	84 c0                	test   %al,%al
80105472:	74 0c                	je     80105480 <uartinit+0xc4>
80105474:	88 45 e6             	mov    %al,-0x1a(%ebp)
80105477:	8a 47 01             	mov    0x1(%edi),%al
8010547a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010547d:	eb bd                	jmp    8010543c <uartinit+0x80>
8010547f:	90                   	nop
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105483:	5b                   	pop    %ebx
80105484:	5e                   	pop    %esi
80105485:	5f                   	pop    %edi
80105486:	5d                   	pop    %ebp
80105487:	c3                   	ret    

80105488 <uartputc>:
  if(!uart)
80105488:	a1 c0 44 11 80       	mov    0x801144c0,%eax
8010548d:	85 c0                	test   %eax,%eax
8010548f:	74 3b                	je     801054cc <uartputc+0x44>
{
80105491:	55                   	push   %ebp
80105492:	89 e5                	mov    %esp,%ebp
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
80105496:	bb 80 00 00 00       	mov    $0x80,%ebx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010549b:	be fd 03 00 00       	mov    $0x3fd,%esi
801054a0:	eb 12                	jmp    801054b4 <uartputc+0x2c>
801054a2:	66 90                	xchg   %ax,%ax
    microdelay(10);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	6a 0a                	push   $0xa
801054a9:	e8 02 d1 ff ff       	call   801025b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	4b                   	dec    %ebx
801054b2:	74 07                	je     801054bb <uartputc+0x33>
801054b4:	89 f2                	mov    %esi,%edx
801054b6:	ec                   	in     (%dx),%al
801054b7:	a8 20                	test   $0x20,%al
801054b9:	74 e9                	je     801054a4 <uartputc+0x1c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801054bb:	8b 45 08             	mov    0x8(%ebp),%eax
801054be:	ba f8 03 00 00       	mov    $0x3f8,%edx
801054c3:	ee                   	out    %al,(%dx)
}
801054c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c7:	5b                   	pop    %ebx
801054c8:	5e                   	pop    %esi
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret    
801054cb:	90                   	nop
801054cc:	c3                   	ret    
801054cd:	8d 76 00             	lea    0x0(%esi),%esi

801054d0 <uartintr>:

void
uartintr(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801054d6:	68 94 53 10 80       	push   $0x80105394
801054db:	e8 04 b3 ff ff       	call   801007e4 <consoleintr>
}
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	c9                   	leave  
801054e4:	c3                   	ret    

801054e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801054e5:	6a 00                	push   $0x0
  pushl $0
801054e7:	6a 00                	push   $0x0
  jmp alltraps
801054e9:	e9 9b fb ff ff       	jmp    80105089 <alltraps>

801054ee <vector1>:
.globl vector1
vector1:
  pushl $0
801054ee:	6a 00                	push   $0x0
  pushl $1
801054f0:	6a 01                	push   $0x1
  jmp alltraps
801054f2:	e9 92 fb ff ff       	jmp    80105089 <alltraps>

801054f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801054f7:	6a 00                	push   $0x0
  pushl $2
801054f9:	6a 02                	push   $0x2
  jmp alltraps
801054fb:	e9 89 fb ff ff       	jmp    80105089 <alltraps>

80105500 <vector3>:
.globl vector3
vector3:
  pushl $0
80105500:	6a 00                	push   $0x0
  pushl $3
80105502:	6a 03                	push   $0x3
  jmp alltraps
80105504:	e9 80 fb ff ff       	jmp    80105089 <alltraps>

80105509 <vector4>:
.globl vector4
vector4:
  pushl $0
80105509:	6a 00                	push   $0x0
  pushl $4
8010550b:	6a 04                	push   $0x4
  jmp alltraps
8010550d:	e9 77 fb ff ff       	jmp    80105089 <alltraps>

80105512 <vector5>:
.globl vector5
vector5:
  pushl $0
80105512:	6a 00                	push   $0x0
  pushl $5
80105514:	6a 05                	push   $0x5
  jmp alltraps
80105516:	e9 6e fb ff ff       	jmp    80105089 <alltraps>

8010551b <vector6>:
.globl vector6
vector6:
  pushl $0
8010551b:	6a 00                	push   $0x0
  pushl $6
8010551d:	6a 06                	push   $0x6
  jmp alltraps
8010551f:	e9 65 fb ff ff       	jmp    80105089 <alltraps>

80105524 <vector7>:
.globl vector7
vector7:
  pushl $0
80105524:	6a 00                	push   $0x0
  pushl $7
80105526:	6a 07                	push   $0x7
  jmp alltraps
80105528:	e9 5c fb ff ff       	jmp    80105089 <alltraps>

8010552d <vector8>:
.globl vector8
vector8:
  pushl $8
8010552d:	6a 08                	push   $0x8
  jmp alltraps
8010552f:	e9 55 fb ff ff       	jmp    80105089 <alltraps>

80105534 <vector9>:
.globl vector9
vector9:
  pushl $0
80105534:	6a 00                	push   $0x0
  pushl $9
80105536:	6a 09                	push   $0x9
  jmp alltraps
80105538:	e9 4c fb ff ff       	jmp    80105089 <alltraps>

8010553d <vector10>:
.globl vector10
vector10:
  pushl $10
8010553d:	6a 0a                	push   $0xa
  jmp alltraps
8010553f:	e9 45 fb ff ff       	jmp    80105089 <alltraps>

80105544 <vector11>:
.globl vector11
vector11:
  pushl $11
80105544:	6a 0b                	push   $0xb
  jmp alltraps
80105546:	e9 3e fb ff ff       	jmp    80105089 <alltraps>

8010554b <vector12>:
.globl vector12
vector12:
  pushl $12
8010554b:	6a 0c                	push   $0xc
  jmp alltraps
8010554d:	e9 37 fb ff ff       	jmp    80105089 <alltraps>

80105552 <vector13>:
.globl vector13
vector13:
  pushl $13
80105552:	6a 0d                	push   $0xd
  jmp alltraps
80105554:	e9 30 fb ff ff       	jmp    80105089 <alltraps>

80105559 <vector14>:
.globl vector14
vector14:
  pushl $14
80105559:	6a 0e                	push   $0xe
  jmp alltraps
8010555b:	e9 29 fb ff ff       	jmp    80105089 <alltraps>

80105560 <vector15>:
.globl vector15
vector15:
  pushl $0
80105560:	6a 00                	push   $0x0
  pushl $15
80105562:	6a 0f                	push   $0xf
  jmp alltraps
80105564:	e9 20 fb ff ff       	jmp    80105089 <alltraps>

80105569 <vector16>:
.globl vector16
vector16:
  pushl $0
80105569:	6a 00                	push   $0x0
  pushl $16
8010556b:	6a 10                	push   $0x10
  jmp alltraps
8010556d:	e9 17 fb ff ff       	jmp    80105089 <alltraps>

80105572 <vector17>:
.globl vector17
vector17:
  pushl $17
80105572:	6a 11                	push   $0x11
  jmp alltraps
80105574:	e9 10 fb ff ff       	jmp    80105089 <alltraps>

80105579 <vector18>:
.globl vector18
vector18:
  pushl $0
80105579:	6a 00                	push   $0x0
  pushl $18
8010557b:	6a 12                	push   $0x12
  jmp alltraps
8010557d:	e9 07 fb ff ff       	jmp    80105089 <alltraps>

80105582 <vector19>:
.globl vector19
vector19:
  pushl $0
80105582:	6a 00                	push   $0x0
  pushl $19
80105584:	6a 13                	push   $0x13
  jmp alltraps
80105586:	e9 fe fa ff ff       	jmp    80105089 <alltraps>

8010558b <vector20>:
.globl vector20
vector20:
  pushl $0
8010558b:	6a 00                	push   $0x0
  pushl $20
8010558d:	6a 14                	push   $0x14
  jmp alltraps
8010558f:	e9 f5 fa ff ff       	jmp    80105089 <alltraps>

80105594 <vector21>:
.globl vector21
vector21:
  pushl $0
80105594:	6a 00                	push   $0x0
  pushl $21
80105596:	6a 15                	push   $0x15
  jmp alltraps
80105598:	e9 ec fa ff ff       	jmp    80105089 <alltraps>

8010559d <vector22>:
.globl vector22
vector22:
  pushl $0
8010559d:	6a 00                	push   $0x0
  pushl $22
8010559f:	6a 16                	push   $0x16
  jmp alltraps
801055a1:	e9 e3 fa ff ff       	jmp    80105089 <alltraps>

801055a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801055a6:	6a 00                	push   $0x0
  pushl $23
801055a8:	6a 17                	push   $0x17
  jmp alltraps
801055aa:	e9 da fa ff ff       	jmp    80105089 <alltraps>

801055af <vector24>:
.globl vector24
vector24:
  pushl $0
801055af:	6a 00                	push   $0x0
  pushl $24
801055b1:	6a 18                	push   $0x18
  jmp alltraps
801055b3:	e9 d1 fa ff ff       	jmp    80105089 <alltraps>

801055b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801055b8:	6a 00                	push   $0x0
  pushl $25
801055ba:	6a 19                	push   $0x19
  jmp alltraps
801055bc:	e9 c8 fa ff ff       	jmp    80105089 <alltraps>

801055c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801055c1:	6a 00                	push   $0x0
  pushl $26
801055c3:	6a 1a                	push   $0x1a
  jmp alltraps
801055c5:	e9 bf fa ff ff       	jmp    80105089 <alltraps>

801055ca <vector27>:
.globl vector27
vector27:
  pushl $0
801055ca:	6a 00                	push   $0x0
  pushl $27
801055cc:	6a 1b                	push   $0x1b
  jmp alltraps
801055ce:	e9 b6 fa ff ff       	jmp    80105089 <alltraps>

801055d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801055d3:	6a 00                	push   $0x0
  pushl $28
801055d5:	6a 1c                	push   $0x1c
  jmp alltraps
801055d7:	e9 ad fa ff ff       	jmp    80105089 <alltraps>

801055dc <vector29>:
.globl vector29
vector29:
  pushl $0
801055dc:	6a 00                	push   $0x0
  pushl $29
801055de:	6a 1d                	push   $0x1d
  jmp alltraps
801055e0:	e9 a4 fa ff ff       	jmp    80105089 <alltraps>

801055e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801055e5:	6a 00                	push   $0x0
  pushl $30
801055e7:	6a 1e                	push   $0x1e
  jmp alltraps
801055e9:	e9 9b fa ff ff       	jmp    80105089 <alltraps>

801055ee <vector31>:
.globl vector31
vector31:
  pushl $0
801055ee:	6a 00                	push   $0x0
  pushl $31
801055f0:	6a 1f                	push   $0x1f
  jmp alltraps
801055f2:	e9 92 fa ff ff       	jmp    80105089 <alltraps>

801055f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801055f7:	6a 00                	push   $0x0
  pushl $32
801055f9:	6a 20                	push   $0x20
  jmp alltraps
801055fb:	e9 89 fa ff ff       	jmp    80105089 <alltraps>

80105600 <vector33>:
.globl vector33
vector33:
  pushl $0
80105600:	6a 00                	push   $0x0
  pushl $33
80105602:	6a 21                	push   $0x21
  jmp alltraps
80105604:	e9 80 fa ff ff       	jmp    80105089 <alltraps>

80105609 <vector34>:
.globl vector34
vector34:
  pushl $0
80105609:	6a 00                	push   $0x0
  pushl $34
8010560b:	6a 22                	push   $0x22
  jmp alltraps
8010560d:	e9 77 fa ff ff       	jmp    80105089 <alltraps>

80105612 <vector35>:
.globl vector35
vector35:
  pushl $0
80105612:	6a 00                	push   $0x0
  pushl $35
80105614:	6a 23                	push   $0x23
  jmp alltraps
80105616:	e9 6e fa ff ff       	jmp    80105089 <alltraps>

8010561b <vector36>:
.globl vector36
vector36:
  pushl $0
8010561b:	6a 00                	push   $0x0
  pushl $36
8010561d:	6a 24                	push   $0x24
  jmp alltraps
8010561f:	e9 65 fa ff ff       	jmp    80105089 <alltraps>

80105624 <vector37>:
.globl vector37
vector37:
  pushl $0
80105624:	6a 00                	push   $0x0
  pushl $37
80105626:	6a 25                	push   $0x25
  jmp alltraps
80105628:	e9 5c fa ff ff       	jmp    80105089 <alltraps>

8010562d <vector38>:
.globl vector38
vector38:
  pushl $0
8010562d:	6a 00                	push   $0x0
  pushl $38
8010562f:	6a 26                	push   $0x26
  jmp alltraps
80105631:	e9 53 fa ff ff       	jmp    80105089 <alltraps>

80105636 <vector39>:
.globl vector39
vector39:
  pushl $0
80105636:	6a 00                	push   $0x0
  pushl $39
80105638:	6a 27                	push   $0x27
  jmp alltraps
8010563a:	e9 4a fa ff ff       	jmp    80105089 <alltraps>

8010563f <vector40>:
.globl vector40
vector40:
  pushl $0
8010563f:	6a 00                	push   $0x0
  pushl $40
80105641:	6a 28                	push   $0x28
  jmp alltraps
80105643:	e9 41 fa ff ff       	jmp    80105089 <alltraps>

80105648 <vector41>:
.globl vector41
vector41:
  pushl $0
80105648:	6a 00                	push   $0x0
  pushl $41
8010564a:	6a 29                	push   $0x29
  jmp alltraps
8010564c:	e9 38 fa ff ff       	jmp    80105089 <alltraps>

80105651 <vector42>:
.globl vector42
vector42:
  pushl $0
80105651:	6a 00                	push   $0x0
  pushl $42
80105653:	6a 2a                	push   $0x2a
  jmp alltraps
80105655:	e9 2f fa ff ff       	jmp    80105089 <alltraps>

8010565a <vector43>:
.globl vector43
vector43:
  pushl $0
8010565a:	6a 00                	push   $0x0
  pushl $43
8010565c:	6a 2b                	push   $0x2b
  jmp alltraps
8010565e:	e9 26 fa ff ff       	jmp    80105089 <alltraps>

80105663 <vector44>:
.globl vector44
vector44:
  pushl $0
80105663:	6a 00                	push   $0x0
  pushl $44
80105665:	6a 2c                	push   $0x2c
  jmp alltraps
80105667:	e9 1d fa ff ff       	jmp    80105089 <alltraps>

8010566c <vector45>:
.globl vector45
vector45:
  pushl $0
8010566c:	6a 00                	push   $0x0
  pushl $45
8010566e:	6a 2d                	push   $0x2d
  jmp alltraps
80105670:	e9 14 fa ff ff       	jmp    80105089 <alltraps>

80105675 <vector46>:
.globl vector46
vector46:
  pushl $0
80105675:	6a 00                	push   $0x0
  pushl $46
80105677:	6a 2e                	push   $0x2e
  jmp alltraps
80105679:	e9 0b fa ff ff       	jmp    80105089 <alltraps>

8010567e <vector47>:
.globl vector47
vector47:
  pushl $0
8010567e:	6a 00                	push   $0x0
  pushl $47
80105680:	6a 2f                	push   $0x2f
  jmp alltraps
80105682:	e9 02 fa ff ff       	jmp    80105089 <alltraps>

80105687 <vector48>:
.globl vector48
vector48:
  pushl $0
80105687:	6a 00                	push   $0x0
  pushl $48
80105689:	6a 30                	push   $0x30
  jmp alltraps
8010568b:	e9 f9 f9 ff ff       	jmp    80105089 <alltraps>

80105690 <vector49>:
.globl vector49
vector49:
  pushl $0
80105690:	6a 00                	push   $0x0
  pushl $49
80105692:	6a 31                	push   $0x31
  jmp alltraps
80105694:	e9 f0 f9 ff ff       	jmp    80105089 <alltraps>

80105699 <vector50>:
.globl vector50
vector50:
  pushl $0
80105699:	6a 00                	push   $0x0
  pushl $50
8010569b:	6a 32                	push   $0x32
  jmp alltraps
8010569d:	e9 e7 f9 ff ff       	jmp    80105089 <alltraps>

801056a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801056a2:	6a 00                	push   $0x0
  pushl $51
801056a4:	6a 33                	push   $0x33
  jmp alltraps
801056a6:	e9 de f9 ff ff       	jmp    80105089 <alltraps>

801056ab <vector52>:
.globl vector52
vector52:
  pushl $0
801056ab:	6a 00                	push   $0x0
  pushl $52
801056ad:	6a 34                	push   $0x34
  jmp alltraps
801056af:	e9 d5 f9 ff ff       	jmp    80105089 <alltraps>

801056b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801056b4:	6a 00                	push   $0x0
  pushl $53
801056b6:	6a 35                	push   $0x35
  jmp alltraps
801056b8:	e9 cc f9 ff ff       	jmp    80105089 <alltraps>

801056bd <vector54>:
.globl vector54
vector54:
  pushl $0
801056bd:	6a 00                	push   $0x0
  pushl $54
801056bf:	6a 36                	push   $0x36
  jmp alltraps
801056c1:	e9 c3 f9 ff ff       	jmp    80105089 <alltraps>

801056c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801056c6:	6a 00                	push   $0x0
  pushl $55
801056c8:	6a 37                	push   $0x37
  jmp alltraps
801056ca:	e9 ba f9 ff ff       	jmp    80105089 <alltraps>

801056cf <vector56>:
.globl vector56
vector56:
  pushl $0
801056cf:	6a 00                	push   $0x0
  pushl $56
801056d1:	6a 38                	push   $0x38
  jmp alltraps
801056d3:	e9 b1 f9 ff ff       	jmp    80105089 <alltraps>

801056d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801056d8:	6a 00                	push   $0x0
  pushl $57
801056da:	6a 39                	push   $0x39
  jmp alltraps
801056dc:	e9 a8 f9 ff ff       	jmp    80105089 <alltraps>

801056e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801056e1:	6a 00                	push   $0x0
  pushl $58
801056e3:	6a 3a                	push   $0x3a
  jmp alltraps
801056e5:	e9 9f f9 ff ff       	jmp    80105089 <alltraps>

801056ea <vector59>:
.globl vector59
vector59:
  pushl $0
801056ea:	6a 00                	push   $0x0
  pushl $59
801056ec:	6a 3b                	push   $0x3b
  jmp alltraps
801056ee:	e9 96 f9 ff ff       	jmp    80105089 <alltraps>

801056f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801056f3:	6a 00                	push   $0x0
  pushl $60
801056f5:	6a 3c                	push   $0x3c
  jmp alltraps
801056f7:	e9 8d f9 ff ff       	jmp    80105089 <alltraps>

801056fc <vector61>:
.globl vector61
vector61:
  pushl $0
801056fc:	6a 00                	push   $0x0
  pushl $61
801056fe:	6a 3d                	push   $0x3d
  jmp alltraps
80105700:	e9 84 f9 ff ff       	jmp    80105089 <alltraps>

80105705 <vector62>:
.globl vector62
vector62:
  pushl $0
80105705:	6a 00                	push   $0x0
  pushl $62
80105707:	6a 3e                	push   $0x3e
  jmp alltraps
80105709:	e9 7b f9 ff ff       	jmp    80105089 <alltraps>

8010570e <vector63>:
.globl vector63
vector63:
  pushl $0
8010570e:	6a 00                	push   $0x0
  pushl $63
80105710:	6a 3f                	push   $0x3f
  jmp alltraps
80105712:	e9 72 f9 ff ff       	jmp    80105089 <alltraps>

80105717 <vector64>:
.globl vector64
vector64:
  pushl $0
80105717:	6a 00                	push   $0x0
  pushl $64
80105719:	6a 40                	push   $0x40
  jmp alltraps
8010571b:	e9 69 f9 ff ff       	jmp    80105089 <alltraps>

80105720 <vector65>:
.globl vector65
vector65:
  pushl $0
80105720:	6a 00                	push   $0x0
  pushl $65
80105722:	6a 41                	push   $0x41
  jmp alltraps
80105724:	e9 60 f9 ff ff       	jmp    80105089 <alltraps>

80105729 <vector66>:
.globl vector66
vector66:
  pushl $0
80105729:	6a 00                	push   $0x0
  pushl $66
8010572b:	6a 42                	push   $0x42
  jmp alltraps
8010572d:	e9 57 f9 ff ff       	jmp    80105089 <alltraps>

80105732 <vector67>:
.globl vector67
vector67:
  pushl $0
80105732:	6a 00                	push   $0x0
  pushl $67
80105734:	6a 43                	push   $0x43
  jmp alltraps
80105736:	e9 4e f9 ff ff       	jmp    80105089 <alltraps>

8010573b <vector68>:
.globl vector68
vector68:
  pushl $0
8010573b:	6a 00                	push   $0x0
  pushl $68
8010573d:	6a 44                	push   $0x44
  jmp alltraps
8010573f:	e9 45 f9 ff ff       	jmp    80105089 <alltraps>

80105744 <vector69>:
.globl vector69
vector69:
  pushl $0
80105744:	6a 00                	push   $0x0
  pushl $69
80105746:	6a 45                	push   $0x45
  jmp alltraps
80105748:	e9 3c f9 ff ff       	jmp    80105089 <alltraps>

8010574d <vector70>:
.globl vector70
vector70:
  pushl $0
8010574d:	6a 00                	push   $0x0
  pushl $70
8010574f:	6a 46                	push   $0x46
  jmp alltraps
80105751:	e9 33 f9 ff ff       	jmp    80105089 <alltraps>

80105756 <vector71>:
.globl vector71
vector71:
  pushl $0
80105756:	6a 00                	push   $0x0
  pushl $71
80105758:	6a 47                	push   $0x47
  jmp alltraps
8010575a:	e9 2a f9 ff ff       	jmp    80105089 <alltraps>

8010575f <vector72>:
.globl vector72
vector72:
  pushl $0
8010575f:	6a 00                	push   $0x0
  pushl $72
80105761:	6a 48                	push   $0x48
  jmp alltraps
80105763:	e9 21 f9 ff ff       	jmp    80105089 <alltraps>

80105768 <vector73>:
.globl vector73
vector73:
  pushl $0
80105768:	6a 00                	push   $0x0
  pushl $73
8010576a:	6a 49                	push   $0x49
  jmp alltraps
8010576c:	e9 18 f9 ff ff       	jmp    80105089 <alltraps>

80105771 <vector74>:
.globl vector74
vector74:
  pushl $0
80105771:	6a 00                	push   $0x0
  pushl $74
80105773:	6a 4a                	push   $0x4a
  jmp alltraps
80105775:	e9 0f f9 ff ff       	jmp    80105089 <alltraps>

8010577a <vector75>:
.globl vector75
vector75:
  pushl $0
8010577a:	6a 00                	push   $0x0
  pushl $75
8010577c:	6a 4b                	push   $0x4b
  jmp alltraps
8010577e:	e9 06 f9 ff ff       	jmp    80105089 <alltraps>

80105783 <vector76>:
.globl vector76
vector76:
  pushl $0
80105783:	6a 00                	push   $0x0
  pushl $76
80105785:	6a 4c                	push   $0x4c
  jmp alltraps
80105787:	e9 fd f8 ff ff       	jmp    80105089 <alltraps>

8010578c <vector77>:
.globl vector77
vector77:
  pushl $0
8010578c:	6a 00                	push   $0x0
  pushl $77
8010578e:	6a 4d                	push   $0x4d
  jmp alltraps
80105790:	e9 f4 f8 ff ff       	jmp    80105089 <alltraps>

80105795 <vector78>:
.globl vector78
vector78:
  pushl $0
80105795:	6a 00                	push   $0x0
  pushl $78
80105797:	6a 4e                	push   $0x4e
  jmp alltraps
80105799:	e9 eb f8 ff ff       	jmp    80105089 <alltraps>

8010579e <vector79>:
.globl vector79
vector79:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $79
801057a0:	6a 4f                	push   $0x4f
  jmp alltraps
801057a2:	e9 e2 f8 ff ff       	jmp    80105089 <alltraps>

801057a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $80
801057a9:	6a 50                	push   $0x50
  jmp alltraps
801057ab:	e9 d9 f8 ff ff       	jmp    80105089 <alltraps>

801057b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801057b0:	6a 00                	push   $0x0
  pushl $81
801057b2:	6a 51                	push   $0x51
  jmp alltraps
801057b4:	e9 d0 f8 ff ff       	jmp    80105089 <alltraps>

801057b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $82
801057bb:	6a 52                	push   $0x52
  jmp alltraps
801057bd:	e9 c7 f8 ff ff       	jmp    80105089 <alltraps>

801057c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $83
801057c4:	6a 53                	push   $0x53
  jmp alltraps
801057c6:	e9 be f8 ff ff       	jmp    80105089 <alltraps>

801057cb <vector84>:
.globl vector84
vector84:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $84
801057cd:	6a 54                	push   $0x54
  jmp alltraps
801057cf:	e9 b5 f8 ff ff       	jmp    80105089 <alltraps>

801057d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801057d4:	6a 00                	push   $0x0
  pushl $85
801057d6:	6a 55                	push   $0x55
  jmp alltraps
801057d8:	e9 ac f8 ff ff       	jmp    80105089 <alltraps>

801057dd <vector86>:
.globl vector86
vector86:
  pushl $0
801057dd:	6a 00                	push   $0x0
  pushl $86
801057df:	6a 56                	push   $0x56
  jmp alltraps
801057e1:	e9 a3 f8 ff ff       	jmp    80105089 <alltraps>

801057e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $87
801057e8:	6a 57                	push   $0x57
  jmp alltraps
801057ea:	e9 9a f8 ff ff       	jmp    80105089 <alltraps>

801057ef <vector88>:
.globl vector88
vector88:
  pushl $0
801057ef:	6a 00                	push   $0x0
  pushl $88
801057f1:	6a 58                	push   $0x58
  jmp alltraps
801057f3:	e9 91 f8 ff ff       	jmp    80105089 <alltraps>

801057f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801057f8:	6a 00                	push   $0x0
  pushl $89
801057fa:	6a 59                	push   $0x59
  jmp alltraps
801057fc:	e9 88 f8 ff ff       	jmp    80105089 <alltraps>

80105801 <vector90>:
.globl vector90
vector90:
  pushl $0
80105801:	6a 00                	push   $0x0
  pushl $90
80105803:	6a 5a                	push   $0x5a
  jmp alltraps
80105805:	e9 7f f8 ff ff       	jmp    80105089 <alltraps>

8010580a <vector91>:
.globl vector91
vector91:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $91
8010580c:	6a 5b                	push   $0x5b
  jmp alltraps
8010580e:	e9 76 f8 ff ff       	jmp    80105089 <alltraps>

80105813 <vector92>:
.globl vector92
vector92:
  pushl $0
80105813:	6a 00                	push   $0x0
  pushl $92
80105815:	6a 5c                	push   $0x5c
  jmp alltraps
80105817:	e9 6d f8 ff ff       	jmp    80105089 <alltraps>

8010581c <vector93>:
.globl vector93
vector93:
  pushl $0
8010581c:	6a 00                	push   $0x0
  pushl $93
8010581e:	6a 5d                	push   $0x5d
  jmp alltraps
80105820:	e9 64 f8 ff ff       	jmp    80105089 <alltraps>

80105825 <vector94>:
.globl vector94
vector94:
  pushl $0
80105825:	6a 00                	push   $0x0
  pushl $94
80105827:	6a 5e                	push   $0x5e
  jmp alltraps
80105829:	e9 5b f8 ff ff       	jmp    80105089 <alltraps>

8010582e <vector95>:
.globl vector95
vector95:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $95
80105830:	6a 5f                	push   $0x5f
  jmp alltraps
80105832:	e9 52 f8 ff ff       	jmp    80105089 <alltraps>

80105837 <vector96>:
.globl vector96
vector96:
  pushl $0
80105837:	6a 00                	push   $0x0
  pushl $96
80105839:	6a 60                	push   $0x60
  jmp alltraps
8010583b:	e9 49 f8 ff ff       	jmp    80105089 <alltraps>

80105840 <vector97>:
.globl vector97
vector97:
  pushl $0
80105840:	6a 00                	push   $0x0
  pushl $97
80105842:	6a 61                	push   $0x61
  jmp alltraps
80105844:	e9 40 f8 ff ff       	jmp    80105089 <alltraps>

80105849 <vector98>:
.globl vector98
vector98:
  pushl $0
80105849:	6a 00                	push   $0x0
  pushl $98
8010584b:	6a 62                	push   $0x62
  jmp alltraps
8010584d:	e9 37 f8 ff ff       	jmp    80105089 <alltraps>

80105852 <vector99>:
.globl vector99
vector99:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $99
80105854:	6a 63                	push   $0x63
  jmp alltraps
80105856:	e9 2e f8 ff ff       	jmp    80105089 <alltraps>

8010585b <vector100>:
.globl vector100
vector100:
  pushl $0
8010585b:	6a 00                	push   $0x0
  pushl $100
8010585d:	6a 64                	push   $0x64
  jmp alltraps
8010585f:	e9 25 f8 ff ff       	jmp    80105089 <alltraps>

80105864 <vector101>:
.globl vector101
vector101:
  pushl $0
80105864:	6a 00                	push   $0x0
  pushl $101
80105866:	6a 65                	push   $0x65
  jmp alltraps
80105868:	e9 1c f8 ff ff       	jmp    80105089 <alltraps>

8010586d <vector102>:
.globl vector102
vector102:
  pushl $0
8010586d:	6a 00                	push   $0x0
  pushl $102
8010586f:	6a 66                	push   $0x66
  jmp alltraps
80105871:	e9 13 f8 ff ff       	jmp    80105089 <alltraps>

80105876 <vector103>:
.globl vector103
vector103:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $103
80105878:	6a 67                	push   $0x67
  jmp alltraps
8010587a:	e9 0a f8 ff ff       	jmp    80105089 <alltraps>

8010587f <vector104>:
.globl vector104
vector104:
  pushl $0
8010587f:	6a 00                	push   $0x0
  pushl $104
80105881:	6a 68                	push   $0x68
  jmp alltraps
80105883:	e9 01 f8 ff ff       	jmp    80105089 <alltraps>

80105888 <vector105>:
.globl vector105
vector105:
  pushl $0
80105888:	6a 00                	push   $0x0
  pushl $105
8010588a:	6a 69                	push   $0x69
  jmp alltraps
8010588c:	e9 f8 f7 ff ff       	jmp    80105089 <alltraps>

80105891 <vector106>:
.globl vector106
vector106:
  pushl $0
80105891:	6a 00                	push   $0x0
  pushl $106
80105893:	6a 6a                	push   $0x6a
  jmp alltraps
80105895:	e9 ef f7 ff ff       	jmp    80105089 <alltraps>

8010589a <vector107>:
.globl vector107
vector107:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $107
8010589c:	6a 6b                	push   $0x6b
  jmp alltraps
8010589e:	e9 e6 f7 ff ff       	jmp    80105089 <alltraps>

801058a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801058a3:	6a 00                	push   $0x0
  pushl $108
801058a5:	6a 6c                	push   $0x6c
  jmp alltraps
801058a7:	e9 dd f7 ff ff       	jmp    80105089 <alltraps>

801058ac <vector109>:
.globl vector109
vector109:
  pushl $0
801058ac:	6a 00                	push   $0x0
  pushl $109
801058ae:	6a 6d                	push   $0x6d
  jmp alltraps
801058b0:	e9 d4 f7 ff ff       	jmp    80105089 <alltraps>

801058b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801058b5:	6a 00                	push   $0x0
  pushl $110
801058b7:	6a 6e                	push   $0x6e
  jmp alltraps
801058b9:	e9 cb f7 ff ff       	jmp    80105089 <alltraps>

801058be <vector111>:
.globl vector111
vector111:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $111
801058c0:	6a 6f                	push   $0x6f
  jmp alltraps
801058c2:	e9 c2 f7 ff ff       	jmp    80105089 <alltraps>

801058c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801058c7:	6a 00                	push   $0x0
  pushl $112
801058c9:	6a 70                	push   $0x70
  jmp alltraps
801058cb:	e9 b9 f7 ff ff       	jmp    80105089 <alltraps>

801058d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801058d0:	6a 00                	push   $0x0
  pushl $113
801058d2:	6a 71                	push   $0x71
  jmp alltraps
801058d4:	e9 b0 f7 ff ff       	jmp    80105089 <alltraps>

801058d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801058d9:	6a 00                	push   $0x0
  pushl $114
801058db:	6a 72                	push   $0x72
  jmp alltraps
801058dd:	e9 a7 f7 ff ff       	jmp    80105089 <alltraps>

801058e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $115
801058e4:	6a 73                	push   $0x73
  jmp alltraps
801058e6:	e9 9e f7 ff ff       	jmp    80105089 <alltraps>

801058eb <vector116>:
.globl vector116
vector116:
  pushl $0
801058eb:	6a 00                	push   $0x0
  pushl $116
801058ed:	6a 74                	push   $0x74
  jmp alltraps
801058ef:	e9 95 f7 ff ff       	jmp    80105089 <alltraps>

801058f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801058f4:	6a 00                	push   $0x0
  pushl $117
801058f6:	6a 75                	push   $0x75
  jmp alltraps
801058f8:	e9 8c f7 ff ff       	jmp    80105089 <alltraps>

801058fd <vector118>:
.globl vector118
vector118:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $118
801058ff:	6a 76                	push   $0x76
  jmp alltraps
80105901:	e9 83 f7 ff ff       	jmp    80105089 <alltraps>

80105906 <vector119>:
.globl vector119
vector119:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $119
80105908:	6a 77                	push   $0x77
  jmp alltraps
8010590a:	e9 7a f7 ff ff       	jmp    80105089 <alltraps>

8010590f <vector120>:
.globl vector120
vector120:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $120
80105911:	6a 78                	push   $0x78
  jmp alltraps
80105913:	e9 71 f7 ff ff       	jmp    80105089 <alltraps>

80105918 <vector121>:
.globl vector121
vector121:
  pushl $0
80105918:	6a 00                	push   $0x0
  pushl $121
8010591a:	6a 79                	push   $0x79
  jmp alltraps
8010591c:	e9 68 f7 ff ff       	jmp    80105089 <alltraps>

80105921 <vector122>:
.globl vector122
vector122:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $122
80105923:	6a 7a                	push   $0x7a
  jmp alltraps
80105925:	e9 5f f7 ff ff       	jmp    80105089 <alltraps>

8010592a <vector123>:
.globl vector123
vector123:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $123
8010592c:	6a 7b                	push   $0x7b
  jmp alltraps
8010592e:	e9 56 f7 ff ff       	jmp    80105089 <alltraps>

80105933 <vector124>:
.globl vector124
vector124:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $124
80105935:	6a 7c                	push   $0x7c
  jmp alltraps
80105937:	e9 4d f7 ff ff       	jmp    80105089 <alltraps>

8010593c <vector125>:
.globl vector125
vector125:
  pushl $0
8010593c:	6a 00                	push   $0x0
  pushl $125
8010593e:	6a 7d                	push   $0x7d
  jmp alltraps
80105940:	e9 44 f7 ff ff       	jmp    80105089 <alltraps>

80105945 <vector126>:
.globl vector126
vector126:
  pushl $0
80105945:	6a 00                	push   $0x0
  pushl $126
80105947:	6a 7e                	push   $0x7e
  jmp alltraps
80105949:	e9 3b f7 ff ff       	jmp    80105089 <alltraps>

8010594e <vector127>:
.globl vector127
vector127:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $127
80105950:	6a 7f                	push   $0x7f
  jmp alltraps
80105952:	e9 32 f7 ff ff       	jmp    80105089 <alltraps>

80105957 <vector128>:
.globl vector128
vector128:
  pushl $0
80105957:	6a 00                	push   $0x0
  pushl $128
80105959:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010595e:	e9 26 f7 ff ff       	jmp    80105089 <alltraps>

80105963 <vector129>:
.globl vector129
vector129:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $129
80105965:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010596a:	e9 1a f7 ff ff       	jmp    80105089 <alltraps>

8010596f <vector130>:
.globl vector130
vector130:
  pushl $0
8010596f:	6a 00                	push   $0x0
  pushl $130
80105971:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105976:	e9 0e f7 ff ff       	jmp    80105089 <alltraps>

8010597b <vector131>:
.globl vector131
vector131:
  pushl $0
8010597b:	6a 00                	push   $0x0
  pushl $131
8010597d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105982:	e9 02 f7 ff ff       	jmp    80105089 <alltraps>

80105987 <vector132>:
.globl vector132
vector132:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $132
80105989:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010598e:	e9 f6 f6 ff ff       	jmp    80105089 <alltraps>

80105993 <vector133>:
.globl vector133
vector133:
  pushl $0
80105993:	6a 00                	push   $0x0
  pushl $133
80105995:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010599a:	e9 ea f6 ff ff       	jmp    80105089 <alltraps>

8010599f <vector134>:
.globl vector134
vector134:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $134
801059a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801059a6:	e9 de f6 ff ff       	jmp    80105089 <alltraps>

801059ab <vector135>:
.globl vector135
vector135:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $135
801059ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801059b2:	e9 d2 f6 ff ff       	jmp    80105089 <alltraps>

801059b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801059b7:	6a 00                	push   $0x0
  pushl $136
801059b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801059be:	e9 c6 f6 ff ff       	jmp    80105089 <alltraps>

801059c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $137
801059c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801059ca:	e9 ba f6 ff ff       	jmp    80105089 <alltraps>

801059cf <vector138>:
.globl vector138
vector138:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $138
801059d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801059d6:	e9 ae f6 ff ff       	jmp    80105089 <alltraps>

801059db <vector139>:
.globl vector139
vector139:
  pushl $0
801059db:	6a 00                	push   $0x0
  pushl $139
801059dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801059e2:	e9 a2 f6 ff ff       	jmp    80105089 <alltraps>

801059e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801059e7:	6a 00                	push   $0x0
  pushl $140
801059e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801059ee:	e9 96 f6 ff ff       	jmp    80105089 <alltraps>

801059f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $141
801059f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801059fa:	e9 8a f6 ff ff       	jmp    80105089 <alltraps>

801059ff <vector142>:
.globl vector142
vector142:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $142
80105a01:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105a06:	e9 7e f6 ff ff       	jmp    80105089 <alltraps>

80105a0b <vector143>:
.globl vector143
vector143:
  pushl $0
80105a0b:	6a 00                	push   $0x0
  pushl $143
80105a0d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105a12:	e9 72 f6 ff ff       	jmp    80105089 <alltraps>

80105a17 <vector144>:
.globl vector144
vector144:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $144
80105a19:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105a1e:	e9 66 f6 ff ff       	jmp    80105089 <alltraps>

80105a23 <vector145>:
.globl vector145
vector145:
  pushl $0
80105a23:	6a 00                	push   $0x0
  pushl $145
80105a25:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105a2a:	e9 5a f6 ff ff       	jmp    80105089 <alltraps>

80105a2f <vector146>:
.globl vector146
vector146:
  pushl $0
80105a2f:	6a 00                	push   $0x0
  pushl $146
80105a31:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105a36:	e9 4e f6 ff ff       	jmp    80105089 <alltraps>

80105a3b <vector147>:
.globl vector147
vector147:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $147
80105a3d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105a42:	e9 42 f6 ff ff       	jmp    80105089 <alltraps>

80105a47 <vector148>:
.globl vector148
vector148:
  pushl $0
80105a47:	6a 00                	push   $0x0
  pushl $148
80105a49:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105a4e:	e9 36 f6 ff ff       	jmp    80105089 <alltraps>

80105a53 <vector149>:
.globl vector149
vector149:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $149
80105a55:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105a5a:	e9 2a f6 ff ff       	jmp    80105089 <alltraps>

80105a5f <vector150>:
.globl vector150
vector150:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $150
80105a61:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105a66:	e9 1e f6 ff ff       	jmp    80105089 <alltraps>

80105a6b <vector151>:
.globl vector151
vector151:
  pushl $0
80105a6b:	6a 00                	push   $0x0
  pushl $151
80105a6d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105a72:	e9 12 f6 ff ff       	jmp    80105089 <alltraps>

80105a77 <vector152>:
.globl vector152
vector152:
  pushl $0
80105a77:	6a 00                	push   $0x0
  pushl $152
80105a79:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105a7e:	e9 06 f6 ff ff       	jmp    80105089 <alltraps>

80105a83 <vector153>:
.globl vector153
vector153:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $153
80105a85:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105a8a:	e9 fa f5 ff ff       	jmp    80105089 <alltraps>

80105a8f <vector154>:
.globl vector154
vector154:
  pushl $0
80105a8f:	6a 00                	push   $0x0
  pushl $154
80105a91:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105a96:	e9 ee f5 ff ff       	jmp    80105089 <alltraps>

80105a9b <vector155>:
.globl vector155
vector155:
  pushl $0
80105a9b:	6a 00                	push   $0x0
  pushl $155
80105a9d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105aa2:	e9 e2 f5 ff ff       	jmp    80105089 <alltraps>

80105aa7 <vector156>:
.globl vector156
vector156:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $156
80105aa9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105aae:	e9 d6 f5 ff ff       	jmp    80105089 <alltraps>

80105ab3 <vector157>:
.globl vector157
vector157:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $157
80105ab5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105aba:	e9 ca f5 ff ff       	jmp    80105089 <alltraps>

80105abf <vector158>:
.globl vector158
vector158:
  pushl $0
80105abf:	6a 00                	push   $0x0
  pushl $158
80105ac1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105ac6:	e9 be f5 ff ff       	jmp    80105089 <alltraps>

80105acb <vector159>:
.globl vector159
vector159:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $159
80105acd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105ad2:	e9 b2 f5 ff ff       	jmp    80105089 <alltraps>

80105ad7 <vector160>:
.globl vector160
vector160:
  pushl $0
80105ad7:	6a 00                	push   $0x0
  pushl $160
80105ad9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105ade:	e9 a6 f5 ff ff       	jmp    80105089 <alltraps>

80105ae3 <vector161>:
.globl vector161
vector161:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $161
80105ae5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105aea:	e9 9a f5 ff ff       	jmp    80105089 <alltraps>

80105aef <vector162>:
.globl vector162
vector162:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $162
80105af1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105af6:	e9 8e f5 ff ff       	jmp    80105089 <alltraps>

80105afb <vector163>:
.globl vector163
vector163:
  pushl $0
80105afb:	6a 00                	push   $0x0
  pushl $163
80105afd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105b02:	e9 82 f5 ff ff       	jmp    80105089 <alltraps>

80105b07 <vector164>:
.globl vector164
vector164:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $164
80105b09:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105b0e:	e9 76 f5 ff ff       	jmp    80105089 <alltraps>

80105b13 <vector165>:
.globl vector165
vector165:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $165
80105b15:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105b1a:	e9 6a f5 ff ff       	jmp    80105089 <alltraps>

80105b1f <vector166>:
.globl vector166
vector166:
  pushl $0
80105b1f:	6a 00                	push   $0x0
  pushl $166
80105b21:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105b26:	e9 5e f5 ff ff       	jmp    80105089 <alltraps>

80105b2b <vector167>:
.globl vector167
vector167:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $167
80105b2d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105b32:	e9 52 f5 ff ff       	jmp    80105089 <alltraps>

80105b37 <vector168>:
.globl vector168
vector168:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $168
80105b39:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105b3e:	e9 46 f5 ff ff       	jmp    80105089 <alltraps>

80105b43 <vector169>:
.globl vector169
vector169:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $169
80105b45:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105b4a:	e9 3a f5 ff ff       	jmp    80105089 <alltraps>

80105b4f <vector170>:
.globl vector170
vector170:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $170
80105b51:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105b56:	e9 2e f5 ff ff       	jmp    80105089 <alltraps>

80105b5b <vector171>:
.globl vector171
vector171:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $171
80105b5d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105b62:	e9 22 f5 ff ff       	jmp    80105089 <alltraps>

80105b67 <vector172>:
.globl vector172
vector172:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $172
80105b69:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105b6e:	e9 16 f5 ff ff       	jmp    80105089 <alltraps>

80105b73 <vector173>:
.globl vector173
vector173:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $173
80105b75:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105b7a:	e9 0a f5 ff ff       	jmp    80105089 <alltraps>

80105b7f <vector174>:
.globl vector174
vector174:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $174
80105b81:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105b86:	e9 fe f4 ff ff       	jmp    80105089 <alltraps>

80105b8b <vector175>:
.globl vector175
vector175:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $175
80105b8d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105b92:	e9 f2 f4 ff ff       	jmp    80105089 <alltraps>

80105b97 <vector176>:
.globl vector176
vector176:
  pushl $0
80105b97:	6a 00                	push   $0x0
  pushl $176
80105b99:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105b9e:	e9 e6 f4 ff ff       	jmp    80105089 <alltraps>

80105ba3 <vector177>:
.globl vector177
vector177:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $177
80105ba5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105baa:	e9 da f4 ff ff       	jmp    80105089 <alltraps>

80105baf <vector178>:
.globl vector178
vector178:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $178
80105bb1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105bb6:	e9 ce f4 ff ff       	jmp    80105089 <alltraps>

80105bbb <vector179>:
.globl vector179
vector179:
  pushl $0
80105bbb:	6a 00                	push   $0x0
  pushl $179
80105bbd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105bc2:	e9 c2 f4 ff ff       	jmp    80105089 <alltraps>

80105bc7 <vector180>:
.globl vector180
vector180:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $180
80105bc9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105bce:	e9 b6 f4 ff ff       	jmp    80105089 <alltraps>

80105bd3 <vector181>:
.globl vector181
vector181:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $181
80105bd5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105bda:	e9 aa f4 ff ff       	jmp    80105089 <alltraps>

80105bdf <vector182>:
.globl vector182
vector182:
  pushl $0
80105bdf:	6a 00                	push   $0x0
  pushl $182
80105be1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105be6:	e9 9e f4 ff ff       	jmp    80105089 <alltraps>

80105beb <vector183>:
.globl vector183
vector183:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $183
80105bed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105bf2:	e9 92 f4 ff ff       	jmp    80105089 <alltraps>

80105bf7 <vector184>:
.globl vector184
vector184:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $184
80105bf9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105bfe:	e9 86 f4 ff ff       	jmp    80105089 <alltraps>

80105c03 <vector185>:
.globl vector185
vector185:
  pushl $0
80105c03:	6a 00                	push   $0x0
  pushl $185
80105c05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105c0a:	e9 7a f4 ff ff       	jmp    80105089 <alltraps>

80105c0f <vector186>:
.globl vector186
vector186:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $186
80105c11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105c16:	e9 6e f4 ff ff       	jmp    80105089 <alltraps>

80105c1b <vector187>:
.globl vector187
vector187:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $187
80105c1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105c22:	e9 62 f4 ff ff       	jmp    80105089 <alltraps>

80105c27 <vector188>:
.globl vector188
vector188:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $188
80105c29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105c2e:	e9 56 f4 ff ff       	jmp    80105089 <alltraps>

80105c33 <vector189>:
.globl vector189
vector189:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $189
80105c35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105c3a:	e9 4a f4 ff ff       	jmp    80105089 <alltraps>

80105c3f <vector190>:
.globl vector190
vector190:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $190
80105c41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105c46:	e9 3e f4 ff ff       	jmp    80105089 <alltraps>

80105c4b <vector191>:
.globl vector191
vector191:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $191
80105c4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105c52:	e9 32 f4 ff ff       	jmp    80105089 <alltraps>

80105c57 <vector192>:
.globl vector192
vector192:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $192
80105c59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105c5e:	e9 26 f4 ff ff       	jmp    80105089 <alltraps>

80105c63 <vector193>:
.globl vector193
vector193:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $193
80105c65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105c6a:	e9 1a f4 ff ff       	jmp    80105089 <alltraps>

80105c6f <vector194>:
.globl vector194
vector194:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $194
80105c71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105c76:	e9 0e f4 ff ff       	jmp    80105089 <alltraps>

80105c7b <vector195>:
.globl vector195
vector195:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $195
80105c7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105c82:	e9 02 f4 ff ff       	jmp    80105089 <alltraps>

80105c87 <vector196>:
.globl vector196
vector196:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $196
80105c89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105c8e:	e9 f6 f3 ff ff       	jmp    80105089 <alltraps>

80105c93 <vector197>:
.globl vector197
vector197:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $197
80105c95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105c9a:	e9 ea f3 ff ff       	jmp    80105089 <alltraps>

80105c9f <vector198>:
.globl vector198
vector198:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $198
80105ca1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ca6:	e9 de f3 ff ff       	jmp    80105089 <alltraps>

80105cab <vector199>:
.globl vector199
vector199:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $199
80105cad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105cb2:	e9 d2 f3 ff ff       	jmp    80105089 <alltraps>

80105cb7 <vector200>:
.globl vector200
vector200:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $200
80105cb9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105cbe:	e9 c6 f3 ff ff       	jmp    80105089 <alltraps>

80105cc3 <vector201>:
.globl vector201
vector201:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $201
80105cc5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105cca:	e9 ba f3 ff ff       	jmp    80105089 <alltraps>

80105ccf <vector202>:
.globl vector202
vector202:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $202
80105cd1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105cd6:	e9 ae f3 ff ff       	jmp    80105089 <alltraps>

80105cdb <vector203>:
.globl vector203
vector203:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $203
80105cdd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105ce2:	e9 a2 f3 ff ff       	jmp    80105089 <alltraps>

80105ce7 <vector204>:
.globl vector204
vector204:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $204
80105ce9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105cee:	e9 96 f3 ff ff       	jmp    80105089 <alltraps>

80105cf3 <vector205>:
.globl vector205
vector205:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $205
80105cf5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105cfa:	e9 8a f3 ff ff       	jmp    80105089 <alltraps>

80105cff <vector206>:
.globl vector206
vector206:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $206
80105d01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105d06:	e9 7e f3 ff ff       	jmp    80105089 <alltraps>

80105d0b <vector207>:
.globl vector207
vector207:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $207
80105d0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105d12:	e9 72 f3 ff ff       	jmp    80105089 <alltraps>

80105d17 <vector208>:
.globl vector208
vector208:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $208
80105d19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105d1e:	e9 66 f3 ff ff       	jmp    80105089 <alltraps>

80105d23 <vector209>:
.globl vector209
vector209:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $209
80105d25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105d2a:	e9 5a f3 ff ff       	jmp    80105089 <alltraps>

80105d2f <vector210>:
.globl vector210
vector210:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $210
80105d31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105d36:	e9 4e f3 ff ff       	jmp    80105089 <alltraps>

80105d3b <vector211>:
.globl vector211
vector211:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $211
80105d3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105d42:	e9 42 f3 ff ff       	jmp    80105089 <alltraps>

80105d47 <vector212>:
.globl vector212
vector212:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $212
80105d49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105d4e:	e9 36 f3 ff ff       	jmp    80105089 <alltraps>

80105d53 <vector213>:
.globl vector213
vector213:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $213
80105d55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105d5a:	e9 2a f3 ff ff       	jmp    80105089 <alltraps>

80105d5f <vector214>:
.globl vector214
vector214:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $214
80105d61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105d66:	e9 1e f3 ff ff       	jmp    80105089 <alltraps>

80105d6b <vector215>:
.globl vector215
vector215:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $215
80105d6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105d72:	e9 12 f3 ff ff       	jmp    80105089 <alltraps>

80105d77 <vector216>:
.globl vector216
vector216:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $216
80105d79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105d7e:	e9 06 f3 ff ff       	jmp    80105089 <alltraps>

80105d83 <vector217>:
.globl vector217
vector217:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $217
80105d85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105d8a:	e9 fa f2 ff ff       	jmp    80105089 <alltraps>

80105d8f <vector218>:
.globl vector218
vector218:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $218
80105d91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105d96:	e9 ee f2 ff ff       	jmp    80105089 <alltraps>

80105d9b <vector219>:
.globl vector219
vector219:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $219
80105d9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105da2:	e9 e2 f2 ff ff       	jmp    80105089 <alltraps>

80105da7 <vector220>:
.globl vector220
vector220:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $220
80105da9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105dae:	e9 d6 f2 ff ff       	jmp    80105089 <alltraps>

80105db3 <vector221>:
.globl vector221
vector221:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $221
80105db5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105dba:	e9 ca f2 ff ff       	jmp    80105089 <alltraps>

80105dbf <vector222>:
.globl vector222
vector222:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $222
80105dc1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105dc6:	e9 be f2 ff ff       	jmp    80105089 <alltraps>

80105dcb <vector223>:
.globl vector223
vector223:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $223
80105dcd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105dd2:	e9 b2 f2 ff ff       	jmp    80105089 <alltraps>

80105dd7 <vector224>:
.globl vector224
vector224:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $224
80105dd9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105dde:	e9 a6 f2 ff ff       	jmp    80105089 <alltraps>

80105de3 <vector225>:
.globl vector225
vector225:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $225
80105de5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105dea:	e9 9a f2 ff ff       	jmp    80105089 <alltraps>

80105def <vector226>:
.globl vector226
vector226:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $226
80105df1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105df6:	e9 8e f2 ff ff       	jmp    80105089 <alltraps>

80105dfb <vector227>:
.globl vector227
vector227:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $227
80105dfd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105e02:	e9 82 f2 ff ff       	jmp    80105089 <alltraps>

80105e07 <vector228>:
.globl vector228
vector228:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $228
80105e09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105e0e:	e9 76 f2 ff ff       	jmp    80105089 <alltraps>

80105e13 <vector229>:
.globl vector229
vector229:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $229
80105e15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105e1a:	e9 6a f2 ff ff       	jmp    80105089 <alltraps>

80105e1f <vector230>:
.globl vector230
vector230:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $230
80105e21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105e26:	e9 5e f2 ff ff       	jmp    80105089 <alltraps>

80105e2b <vector231>:
.globl vector231
vector231:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $231
80105e2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105e32:	e9 52 f2 ff ff       	jmp    80105089 <alltraps>

80105e37 <vector232>:
.globl vector232
vector232:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $232
80105e39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105e3e:	e9 46 f2 ff ff       	jmp    80105089 <alltraps>

80105e43 <vector233>:
.globl vector233
vector233:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $233
80105e45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105e4a:	e9 3a f2 ff ff       	jmp    80105089 <alltraps>

80105e4f <vector234>:
.globl vector234
vector234:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $234
80105e51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105e56:	e9 2e f2 ff ff       	jmp    80105089 <alltraps>

80105e5b <vector235>:
.globl vector235
vector235:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $235
80105e5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105e62:	e9 22 f2 ff ff       	jmp    80105089 <alltraps>

80105e67 <vector236>:
.globl vector236
vector236:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $236
80105e69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105e6e:	e9 16 f2 ff ff       	jmp    80105089 <alltraps>

80105e73 <vector237>:
.globl vector237
vector237:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $237
80105e75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105e7a:	e9 0a f2 ff ff       	jmp    80105089 <alltraps>

80105e7f <vector238>:
.globl vector238
vector238:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $238
80105e81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105e86:	e9 fe f1 ff ff       	jmp    80105089 <alltraps>

80105e8b <vector239>:
.globl vector239
vector239:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $239
80105e8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105e92:	e9 f2 f1 ff ff       	jmp    80105089 <alltraps>

80105e97 <vector240>:
.globl vector240
vector240:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $240
80105e99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105e9e:	e9 e6 f1 ff ff       	jmp    80105089 <alltraps>

80105ea3 <vector241>:
.globl vector241
vector241:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $241
80105ea5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105eaa:	e9 da f1 ff ff       	jmp    80105089 <alltraps>

80105eaf <vector242>:
.globl vector242
vector242:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $242
80105eb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105eb6:	e9 ce f1 ff ff       	jmp    80105089 <alltraps>

80105ebb <vector243>:
.globl vector243
vector243:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $243
80105ebd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105ec2:	e9 c2 f1 ff ff       	jmp    80105089 <alltraps>

80105ec7 <vector244>:
.globl vector244
vector244:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $244
80105ec9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105ece:	e9 b6 f1 ff ff       	jmp    80105089 <alltraps>

80105ed3 <vector245>:
.globl vector245
vector245:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $245
80105ed5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105eda:	e9 aa f1 ff ff       	jmp    80105089 <alltraps>

80105edf <vector246>:
.globl vector246
vector246:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $246
80105ee1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105ee6:	e9 9e f1 ff ff       	jmp    80105089 <alltraps>

80105eeb <vector247>:
.globl vector247
vector247:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $247
80105eed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105ef2:	e9 92 f1 ff ff       	jmp    80105089 <alltraps>

80105ef7 <vector248>:
.globl vector248
vector248:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $248
80105ef9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105efe:	e9 86 f1 ff ff       	jmp    80105089 <alltraps>

80105f03 <vector249>:
.globl vector249
vector249:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $249
80105f05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105f0a:	e9 7a f1 ff ff       	jmp    80105089 <alltraps>

80105f0f <vector250>:
.globl vector250
vector250:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $250
80105f11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105f16:	e9 6e f1 ff ff       	jmp    80105089 <alltraps>

80105f1b <vector251>:
.globl vector251
vector251:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $251
80105f1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105f22:	e9 62 f1 ff ff       	jmp    80105089 <alltraps>

80105f27 <vector252>:
.globl vector252
vector252:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $252
80105f29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105f2e:	e9 56 f1 ff ff       	jmp    80105089 <alltraps>

80105f33 <vector253>:
.globl vector253
vector253:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $253
80105f35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105f3a:	e9 4a f1 ff ff       	jmp    80105089 <alltraps>

80105f3f <vector254>:
.globl vector254
vector254:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $254
80105f41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105f46:	e9 3e f1 ff ff       	jmp    80105089 <alltraps>

80105f4b <vector255>:
.globl vector255
vector255:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $255
80105f4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105f52:	e9 32 f1 ff ff       	jmp    80105089 <alltraps>
80105f57:	90                   	nop

80105f58 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80105f58:	55                   	push   %ebp
80105f59:	89 e5                	mov    %esp,%ebp
80105f5b:	57                   	push   %edi
80105f5c:	56                   	push   %esi
80105f5d:	53                   	push   %ebx
80105f5e:	83 ec 1c             	sub    $0x1c,%esp
80105f61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80105f64:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80105f67:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80105f6d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80105f73:	39 d3                	cmp    %edx,%ebx
80105f75:	73 4a                	jae    80105fc1 <deallocuvm.part.0+0x69>
80105f77:	89 c6                	mov    %eax,%esi
80105f79:	eb 0c                	jmp    80105f87 <deallocuvm.part.0+0x2f>
80105f7b:	90                   	nop
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80105f7c:	40                   	inc    %eax
80105f7d:	c1 e0 16             	shl    $0x16,%eax
80105f80:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80105f82:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80105f85:	76 3a                	jbe    80105fc1 <deallocuvm.part.0+0x69>
  pde = &pgdir[PDX(va)];
80105f87:	89 d8                	mov    %ebx,%eax
80105f89:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80105f8c:	8b 0c 86             	mov    (%esi,%eax,4),%ecx
80105f8f:	f6 c1 01             	test   $0x1,%cl
80105f92:	74 e8                	je     80105f7c <deallocuvm.part.0+0x24>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105f94:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80105f9a:	89 df                	mov    %ebx,%edi
80105f9c:	c1 ef 0a             	shr    $0xa,%edi
80105f9f:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80105fa5:	8d bc 39 00 00 00 80 	lea    -0x80000000(%ecx,%edi,1),%edi
    if(!pte)
80105fac:	85 ff                	test   %edi,%edi
80105fae:	74 cc                	je     80105f7c <deallocuvm.part.0+0x24>
    else if((*pte & PTE_P) != 0){
80105fb0:	8b 07                	mov    (%edi),%eax
80105fb2:	a8 01                	test   $0x1,%al
80105fb4:	75 16                	jne    80105fcc <deallocuvm.part.0+0x74>
  for(; a  < oldsz; a += PGSIZE){
80105fb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105fbc:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80105fbf:	77 c6                	ja     80105f87 <deallocuvm.part.0+0x2f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80105fc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105fc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc7:	5b                   	pop    %ebx
80105fc8:	5e                   	pop    %esi
80105fc9:	5f                   	pop    %edi
80105fca:	5d                   	pop    %ebp
80105fcb:	c3                   	ret    
      if(pa == 0)
80105fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105fd1:	74 1f                	je     80105ff2 <deallocuvm.part.0+0x9a>
      kfree(v);
80105fd3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80105fd6:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80105fdb:	50                   	push   %eax
80105fdc:	e8 e7 c1 ff ff       	call   801021c8 <kfree>
      *pte = 0;
80105fe1:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  for(; a  < oldsz; a += PGSIZE){
80105fe7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	eb 90                	jmp    80105f82 <deallocuvm.part.0+0x2a>
        panic("kfree");
80105ff2:	83 ec 0c             	sub    $0xc,%esp
80105ff5:	68 e6 6c 10 80       	push   $0x80106ce6
80105ffa:	e8 39 a3 ff ff       	call   80100338 <panic>
80105fff:	90                   	nop

80106000 <mappages>:
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	57                   	push   %edi
80106004:	56                   	push   %esi
80106005:	53                   	push   %ebx
80106006:	83 ec 1c             	sub    $0x1c,%esp
80106009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  a = (char*)PGROUNDDOWN((uint)va);
8010600c:	89 d3                	mov    %edx,%ebx
8010600e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106014:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106018:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010601d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106020:	8b 45 08             	mov    0x8(%ebp),%eax
80106023:	29 d8                	sub    %ebx,%eax
80106025:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106028:	eb 39                	jmp    80106063 <mappages+0x63>
8010602a:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010602c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106031:	89 da                	mov    %ebx,%edx
80106033:	c1 ea 0a             	shr    $0xa,%edx
80106036:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
8010603c:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106043:	85 c0                	test   %eax,%eax
80106045:	74 71                	je     801060b8 <mappages+0xb8>
    if(*pte & PTE_P)
80106047:	f6 00 01             	testb  $0x1,(%eax)
8010604a:	0f 85 82 00 00 00    	jne    801060d2 <mappages+0xd2>
    *pte = pa | perm | PTE_P;
80106050:	0b 75 0c             	or     0xc(%ebp),%esi
80106053:	83 ce 01             	or     $0x1,%esi
80106056:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106058:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010605b:	74 6b                	je     801060c8 <mappages+0xc8>
    a += PGSIZE;
8010605d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106063:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106066:	8d 34 18             	lea    (%eax,%ebx,1),%esi
  pde = &pgdir[PDX(va)];
80106069:	89 d8                	mov    %ebx,%eax
8010606b:	c1 e8 16             	shr    $0x16,%eax
8010606e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106071:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106074:	8b 07                	mov    (%edi),%eax
80106076:	a8 01                	test   $0x1,%al
80106078:	75 b2                	jne    8010602c <mappages+0x2c>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010607a:	e8 d9 c2 ff ff       	call   80102358 <kalloc>
8010607f:	89 c2                	mov    %eax,%edx
80106081:	85 c0                	test   %eax,%eax
80106083:	74 33                	je     801060b8 <mappages+0xb8>
    memset(pgtab, 0, PGSIZE);
80106085:	50                   	push   %eax
80106086:	68 00 10 00 00       	push   $0x1000
8010608b:	6a 00                	push   $0x0
8010608d:	52                   	push   %edx
8010608e:	89 55 d8             	mov    %edx,-0x28(%ebp)
80106091:	e8 0e e0 ff ff       	call   801040a4 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106096:	8b 55 d8             	mov    -0x28(%ebp),%edx
80106099:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
8010609f:	83 c8 07             	or     $0x7,%eax
801060a2:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801060a4:	89 d8                	mov    %ebx,%eax
801060a6:	c1 e8 0a             	shr    $0xa,%eax
801060a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801060ae:	01 d0                	add    %edx,%eax
801060b0:	83 c4 10             	add    $0x10,%esp
801060b3:	eb 92                	jmp    80106047 <mappages+0x47>
801060b5:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
801060b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060c0:	5b                   	pop    %ebx
801060c1:	5e                   	pop    %esi
801060c2:	5f                   	pop    %edi
801060c3:	5d                   	pop    %ebp
801060c4:	c3                   	ret    
801060c5:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
801060c8:	31 c0                	xor    %eax,%eax
}
801060ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060cd:	5b                   	pop    %ebx
801060ce:	5e                   	pop    %esi
801060cf:	5f                   	pop    %edi
801060d0:	5d                   	pop    %ebp
801060d1:	c3                   	ret    
      panic("remap");
801060d2:	83 ec 0c             	sub    $0xc,%esp
801060d5:	68 28 73 10 80       	push   $0x80107328
801060da:	e8 59 a2 ff ff       	call   80100338 <panic>
801060df:	90                   	nop

801060e0 <seginit>:
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801060e6:	e8 8d d3 ff ff       	call   80103478 <cpuid>
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801060eb:	8d 14 80             	lea    (%eax,%eax,4),%edx
801060ee:	01 d2                	add    %edx,%edx
801060f0:	01 d0                	add    %edx,%eax
801060f2:	c1 e0 04             	shl    $0x4,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801060f5:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
801060fc:	ff 00 00 
801060ff:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106106:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106109:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106110:	ff 00 00 
80106113:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
8010611a:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010611d:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106124:	ff 00 00 
80106127:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
8010612e:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106131:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106138:	ff 00 00 
8010613b:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106142:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106145:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[0] = size-1;
8010614a:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106150:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106154:	c1 e8 10             	shr    $0x10,%eax
80106157:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010615b:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010615e:	0f 01 10             	lgdtl  (%eax)
}
80106161:	c9                   	leave  
80106162:	c3                   	ret    
80106163:	90                   	nop

80106164 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106164:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106169:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010616e:	0f 22 d8             	mov    %eax,%cr3
}
80106171:	c3                   	ret    
80106172:	66 90                	xchg   %ax,%ax

80106174 <switchuvm>:
{
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	57                   	push   %edi
80106178:	56                   	push   %esi
80106179:	53                   	push   %ebx
8010617a:	83 ec 1c             	sub    $0x1c,%esp
8010617d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106180:	85 f6                	test   %esi,%esi
80106182:	0f 84 bf 00 00 00    	je     80106247 <switchuvm+0xd3>
  if(p->kstack == 0)
80106188:	8b 56 08             	mov    0x8(%esi),%edx
8010618b:	85 d2                	test   %edx,%edx
8010618d:	0f 84 ce 00 00 00    	je     80106261 <switchuvm+0xed>
  if(p->pgdir == 0)
80106193:	8b 46 04             	mov    0x4(%esi),%eax
80106196:	85 c0                	test   %eax,%eax
80106198:	0f 84 b6 00 00 00    	je     80106254 <switchuvm+0xe0>
  pushcli();
8010619e:	e8 0d dd ff ff       	call   80103eb0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801061a3:	e8 6c d2 ff ff       	call   80103414 <mycpu>
801061a8:	89 c3                	mov    %eax,%ebx
801061aa:	e8 65 d2 ff ff       	call   80103414 <mycpu>
801061af:	89 c7                	mov    %eax,%edi
801061b1:	e8 5e d2 ff ff       	call   80103414 <mycpu>
801061b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061b9:	e8 56 d2 ff ff       	call   80103414 <mycpu>
801061be:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801061c5:	67 00 
801061c7:	83 c7 08             	add    $0x8,%edi
801061ca:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801061d1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801061d4:	83 c1 08             	add    $0x8,%ecx
801061d7:	c1 e9 10             	shr    $0x10,%ecx
801061da:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801061e0:	66 c7 83 9d 00 00 00 	movw   $0x4099,0x9d(%ebx)
801061e7:	99 40 
801061e9:	83 c0 08             	add    $0x8,%eax
801061ec:	c1 e8 18             	shr    $0x18,%eax
801061ef:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
801061f5:	e8 1a d2 ff ff       	call   80103414 <mycpu>
801061fa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106201:	e8 0e d2 ff ff       	call   80103414 <mycpu>
80106206:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010620c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010620f:	e8 00 d2 ff ff       	call   80103414 <mycpu>
80106214:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010621a:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010621d:	e8 f2 d1 ff ff       	call   80103414 <mycpu>
80106222:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106228:	b8 28 00 00 00       	mov    $0x28,%eax
8010622d:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106230:	8b 46 04             	mov    0x4(%esi),%eax
80106233:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106238:	0f 22 d8             	mov    %eax,%cr3
}
8010623b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010623e:	5b                   	pop    %ebx
8010623f:	5e                   	pop    %esi
80106240:	5f                   	pop    %edi
80106241:	5d                   	pop    %ebp
  popcli();
80106242:	e9 b5 dc ff ff       	jmp    80103efc <popcli>
    panic("switchuvm: no process");
80106247:	83 ec 0c             	sub    $0xc,%esp
8010624a:	68 2e 73 10 80       	push   $0x8010732e
8010624f:	e8 e4 a0 ff ff       	call   80100338 <panic>
    panic("switchuvm: no pgdir");
80106254:	83 ec 0c             	sub    $0xc,%esp
80106257:	68 59 73 10 80       	push   $0x80107359
8010625c:	e8 d7 a0 ff ff       	call   80100338 <panic>
    panic("switchuvm: no kstack");
80106261:	83 ec 0c             	sub    $0xc,%esp
80106264:	68 44 73 10 80       	push   $0x80107344
80106269:	e8 ca a0 ff ff       	call   80100338 <panic>
8010626e:	66 90                	xchg   %ax,%ax

80106270 <inituvm>:
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	57                   	push   %edi
80106274:	56                   	push   %esi
80106275:	53                   	push   %ebx
80106276:	83 ec 1c             	sub    $0x1c,%esp
80106279:	8b 45 08             	mov    0x8(%ebp),%eax
8010627c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010627f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106282:	8b 75 10             	mov    0x10(%ebp),%esi
  if(sz >= PGSIZE)
80106285:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010628b:	77 47                	ja     801062d4 <inituvm+0x64>
  mem = kalloc();
8010628d:	e8 c6 c0 ff ff       	call   80102358 <kalloc>
80106292:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106294:	50                   	push   %eax
80106295:	68 00 10 00 00       	push   $0x1000
8010629a:	6a 00                	push   $0x0
8010629c:	53                   	push   %ebx
8010629d:	e8 02 de ff ff       	call   801040a4 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801062a2:	5a                   	pop    %edx
801062a3:	59                   	pop    %ecx
801062a4:	6a 06                	push   $0x6
801062a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801062ac:	50                   	push   %eax
801062ad:	b9 00 10 00 00       	mov    $0x1000,%ecx
801062b2:	31 d2                	xor    %edx,%edx
801062b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062b7:	e8 44 fd ff ff       	call   80106000 <mappages>
  memmove(mem, init, sz);
801062bc:	83 c4 10             	add    $0x10,%esp
801062bf:	89 75 10             	mov    %esi,0x10(%ebp)
801062c2:	89 7d 0c             	mov    %edi,0xc(%ebp)
801062c5:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801062c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062cb:	5b                   	pop    %ebx
801062cc:	5e                   	pop    %esi
801062cd:	5f                   	pop    %edi
801062ce:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801062cf:	e9 54 de ff ff       	jmp    80104128 <memmove>
    panic("inituvm: more than a page");
801062d4:	83 ec 0c             	sub    $0xc,%esp
801062d7:	68 6d 73 10 80       	push   $0x8010736d
801062dc:	e8 57 a0 ff ff       	call   80100338 <panic>
801062e1:	8d 76 00             	lea    0x0(%esi),%esi

801062e4 <loaduvm>:
{
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	57                   	push   %edi
801062e8:	56                   	push   %esi
801062e9:	53                   	push   %ebx
801062ea:	83 ec 1c             	sub    $0x1c,%esp
801062ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801062f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801062f8:	0f 85 b3 00 00 00    	jne    801063b1 <loaduvm+0xcd>
  for(i = 0; i < sz; i += PGSIZE){
801062fe:	85 f6                	test   %esi,%esi
80106300:	0f 84 8a 00 00 00    	je     80106390 <loaduvm+0xac>
80106306:	89 f3                	mov    %esi,%ebx
80106308:	01 f0                	add    %esi,%eax
8010630a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010630d:	8b 45 14             	mov    0x14(%ebp),%eax
80106310:	01 f0                	add    %esi,%eax
80106312:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106315:	8d 76 00             	lea    0x0(%esi),%esi
  pde = &pgdir[PDX(va)];
80106318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010631b:	29 d8                	sub    %ebx,%eax
8010631d:	89 c2                	mov    %eax,%edx
8010631f:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106322:	8b 7d 08             	mov    0x8(%ebp),%edi
80106325:	8b 14 97             	mov    (%edi,%edx,4),%edx
80106328:	f6 c2 01             	test   $0x1,%dl
8010632b:	75 0f                	jne    8010633c <loaduvm+0x58>
      panic("loaduvm: address should exist");
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	68 87 73 10 80       	push   $0x80107387
80106335:	e8 fe 9f ff ff       	call   80100338 <panic>
8010633a:	66 90                	xchg   %ax,%ax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010633c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106342:	c1 e8 0a             	shr    $0xa,%eax
80106345:	25 fc 0f 00 00       	and    $0xffc,%eax
8010634a:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106351:	85 c0                	test   %eax,%eax
80106353:	74 d8                	je     8010632d <loaduvm+0x49>
    pa = PTE_ADDR(*pte);
80106355:	8b 00                	mov    (%eax),%eax
80106357:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010635c:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106362:	77 38                	ja     8010639c <loaduvm+0xb8>
80106364:	89 df                	mov    %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106366:	57                   	push   %edi
80106367:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010636a:	29 d9                	sub    %ebx,%ecx
8010636c:	51                   	push   %ecx
8010636d:	05 00 00 00 80       	add    $0x80000000,%eax
80106372:	50                   	push   %eax
80106373:	ff 75 10             	push   0x10(%ebp)
80106376:	e8 11 b5 ff ff       	call   8010188c <readi>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	39 f8                	cmp    %edi,%eax
80106380:	75 22                	jne    801063a4 <loaduvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
80106382:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106388:	89 f0                	mov    %esi,%eax
8010638a:	29 d8                	sub    %ebx,%eax
8010638c:	39 c6                	cmp    %eax,%esi
8010638e:	77 88                	ja     80106318 <loaduvm+0x34>
  return 0;
80106390:	31 c0                	xor    %eax,%eax
}
80106392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106395:	5b                   	pop    %ebx
80106396:	5e                   	pop    %esi
80106397:	5f                   	pop    %edi
80106398:	5d                   	pop    %ebp
80106399:	c3                   	ret    
8010639a:	66 90                	xchg   %ax,%ax
      n = PGSIZE;
8010639c:	bf 00 10 00 00       	mov    $0x1000,%edi
801063a1:	eb c3                	jmp    80106366 <loaduvm+0x82>
801063a3:	90                   	nop
      return -1;
801063a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ac:	5b                   	pop    %ebx
801063ad:	5e                   	pop    %esi
801063ae:	5f                   	pop    %edi
801063af:	5d                   	pop    %ebp
801063b0:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801063b1:	83 ec 0c             	sub    $0xc,%esp
801063b4:	68 28 74 10 80       	push   $0x80107428
801063b9:	e8 7a 9f ff ff       	call   80100338 <panic>
801063be:	66 90                	xchg   %ax,%ax

801063c0 <allocuvm>:
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	56                   	push   %esi
801063c5:	53                   	push   %ebx
801063c6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801063c9:	8b 7d 10             	mov    0x10(%ebp),%edi
801063cc:	85 ff                	test   %edi,%edi
801063ce:	0f 88 b8 00 00 00    	js     8010648c <allocuvm+0xcc>
  if(newsz < oldsz)
801063d4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801063d7:	0f 82 9f 00 00 00    	jb     8010647c <allocuvm+0xbc>
  a = PGROUNDUP(oldsz);
801063dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801063e0:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801063e6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801063ec:	39 75 10             	cmp    %esi,0x10(%ebp)
801063ef:	0f 86 8a 00 00 00    	jbe    8010647f <allocuvm+0xbf>
801063f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801063f8:	8b 7d 10             	mov    0x10(%ebp),%edi
801063fb:	eb 40                	jmp    8010643d <allocuvm+0x7d>
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106400:	50                   	push   %eax
80106401:	68 00 10 00 00       	push   $0x1000
80106406:	6a 00                	push   $0x0
80106408:	53                   	push   %ebx
80106409:	e8 96 dc ff ff       	call   801040a4 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010640e:	5a                   	pop    %edx
8010640f:	59                   	pop    %ecx
80106410:	6a 06                	push   $0x6
80106412:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106418:	50                   	push   %eax
80106419:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010641e:	89 f2                	mov    %esi,%edx
80106420:	8b 45 08             	mov    0x8(%ebp),%eax
80106423:	e8 d8 fb ff ff       	call   80106000 <mappages>
80106428:	83 c4 10             	add    $0x10,%esp
8010642b:	85 c0                	test   %eax,%eax
8010642d:	78 69                	js     80106498 <allocuvm+0xd8>
  for(; a < newsz; a += PGSIZE){
8010642f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106435:	39 f7                	cmp    %esi,%edi
80106437:	0f 86 9b 00 00 00    	jbe    801064d8 <allocuvm+0x118>
    mem = kalloc();
8010643d:	e8 16 bf ff ff       	call   80102358 <kalloc>
80106442:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106444:	85 c0                	test   %eax,%eax
80106446:	75 b8                	jne    80106400 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	68 a5 73 10 80       	push   $0x801073a5
80106450:	e8 c7 a1 ff ff       	call   8010061c <cprintf>
  if(newsz >= oldsz)
80106455:	83 c4 10             	add    $0x10,%esp
80106458:	8b 45 0c             	mov    0xc(%ebp),%eax
8010645b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010645e:	74 2c                	je     8010648c <allocuvm+0xcc>
80106460:	89 c1                	mov    %eax,%ecx
80106462:	8b 55 10             	mov    0x10(%ebp),%edx
80106465:	8b 45 08             	mov    0x8(%ebp),%eax
80106468:	e8 eb fa ff ff       	call   80105f58 <deallocuvm.part.0>
      return 0;
8010646d:	31 ff                	xor    %edi,%edi
}
8010646f:	89 f8                	mov    %edi,%eax
80106471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106474:	5b                   	pop    %ebx
80106475:	5e                   	pop    %esi
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
80106478:	c3                   	ret    
80106479:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
8010647c:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
8010647f:	89 f8                	mov    %edi,%eax
80106481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106484:	5b                   	pop    %ebx
80106485:	5e                   	pop    %esi
80106486:	5f                   	pop    %edi
80106487:	5d                   	pop    %ebp
80106488:	c3                   	ret    
80106489:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
8010648c:	31 ff                	xor    %edi,%edi
}
8010648e:	89 f8                	mov    %edi,%eax
80106490:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106493:	5b                   	pop    %ebx
80106494:	5e                   	pop    %esi
80106495:	5f                   	pop    %edi
80106496:	5d                   	pop    %ebp
80106497:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
80106498:	83 ec 0c             	sub    $0xc,%esp
8010649b:	68 bd 73 10 80       	push   $0x801073bd
801064a0:	e8 77 a1 ff ff       	call   8010061c <cprintf>
  if(newsz >= oldsz)
801064a5:	83 c4 10             	add    $0x10,%esp
801064a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801064ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801064ae:	74 0d                	je     801064bd <allocuvm+0xfd>
801064b0:	89 c1                	mov    %eax,%ecx
801064b2:	8b 55 10             	mov    0x10(%ebp),%edx
801064b5:	8b 45 08             	mov    0x8(%ebp),%eax
801064b8:	e8 9b fa ff ff       	call   80105f58 <deallocuvm.part.0>
      kfree(mem);
801064bd:	83 ec 0c             	sub    $0xc,%esp
801064c0:	53                   	push   %ebx
801064c1:	e8 02 bd ff ff       	call   801021c8 <kfree>
      return 0;
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	31 ff                	xor    %edi,%edi
}
801064cb:	89 f8                	mov    %edi,%eax
801064cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d0:	5b                   	pop    %ebx
801064d1:	5e                   	pop    %esi
801064d2:	5f                   	pop    %edi
801064d3:	5d                   	pop    %ebp
801064d4:	c3                   	ret    
801064d5:	8d 76 00             	lea    0x0(%esi),%esi
801064d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801064db:	89 f8                	mov    %edi,%eax
801064dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e0:	5b                   	pop    %ebx
801064e1:	5e                   	pop    %esi
801064e2:	5f                   	pop    %edi
801064e3:	5d                   	pop    %ebp
801064e4:	c3                   	ret    
801064e5:	8d 76 00             	lea    0x0(%esi),%esi

801064e8 <deallocuvm>:
{
801064e8:	55                   	push   %ebp
801064e9:	89 e5                	mov    %esp,%ebp
801064eb:	8b 45 08             	mov    0x8(%ebp),%eax
801064ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801064f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if(newsz >= oldsz)
801064f4:	39 d1                	cmp    %edx,%ecx
801064f6:	73 08                	jae    80106500 <deallocuvm+0x18>
}
801064f8:	5d                   	pop    %ebp
801064f9:	e9 5a fa ff ff       	jmp    80105f58 <deallocuvm.part.0>
801064fe:	66 90                	xchg   %ax,%ax
80106500:	89 d0                	mov    %edx,%eax
80106502:	5d                   	pop    %ebp
80106503:	c3                   	ret    

80106504 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106504:	55                   	push   %ebp
80106505:	89 e5                	mov    %esp,%ebp
80106507:	57                   	push   %edi
80106508:	56                   	push   %esi
80106509:	53                   	push   %ebx
8010650a:	83 ec 0c             	sub    $0xc,%esp
8010650d:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
80106510:	85 ff                	test   %edi,%edi
80106512:	74 51                	je     80106565 <freevm+0x61>
  if(newsz >= oldsz)
80106514:	31 c9                	xor    %ecx,%ecx
80106516:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010651b:	89 f8                	mov    %edi,%eax
8010651d:	e8 36 fa ff ff       	call   80105f58 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106522:	89 fb                	mov    %edi,%ebx
80106524:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
8010652a:	eb 07                	jmp    80106533 <freevm+0x2f>
8010652c:	83 c3 04             	add    $0x4,%ebx
8010652f:	39 de                	cmp    %ebx,%esi
80106531:	74 23                	je     80106556 <freevm+0x52>
    if(pgdir[i] & PTE_P){
80106533:	8b 03                	mov    (%ebx),%eax
80106535:	a8 01                	test   $0x1,%al
80106537:	74 f3                	je     8010652c <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106539:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010653c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106541:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106546:	50                   	push   %eax
80106547:	e8 7c bc ff ff       	call   801021c8 <kfree>
8010654c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010654f:	83 c3 04             	add    $0x4,%ebx
80106552:	39 de                	cmp    %ebx,%esi
80106554:	75 dd                	jne    80106533 <freevm+0x2f>
    }
  }
  kfree((char*)pgdir);
80106556:	89 7d 08             	mov    %edi,0x8(%ebp)
}
80106559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010655c:	5b                   	pop    %ebx
8010655d:	5e                   	pop    %esi
8010655e:	5f                   	pop    %edi
8010655f:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106560:	e9 63 bc ff ff       	jmp    801021c8 <kfree>
    panic("freevm: no pgdir");
80106565:	83 ec 0c             	sub    $0xc,%esp
80106568:	68 d9 73 10 80       	push   $0x801073d9
8010656d:	e8 c6 9d ff ff       	call   80100338 <panic>
80106572:	66 90                	xchg   %ax,%ax

80106574 <setupkvm>:
{
80106574:	55                   	push   %ebp
80106575:	89 e5                	mov    %esp,%ebp
80106577:	56                   	push   %esi
80106578:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106579:	e8 da bd ff ff       	call   80102358 <kalloc>
8010657e:	89 c6                	mov    %eax,%esi
80106580:	85 c0                	test   %eax,%eax
80106582:	74 40                	je     801065c4 <setupkvm+0x50>
  memset(pgdir, 0, PGSIZE);
80106584:	50                   	push   %eax
80106585:	68 00 10 00 00       	push   $0x1000
8010658a:	6a 00                	push   $0x0
8010658c:	56                   	push   %esi
8010658d:	e8 12 db ff ff       	call   801040a4 <memset>
80106592:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106595:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
8010659a:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010659d:	8b 4b 08             	mov    0x8(%ebx),%ecx
801065a0:	29 c1                	sub    %eax,%ecx
801065a2:	83 ec 08             	sub    $0x8,%esp
801065a5:	ff 73 0c             	push   0xc(%ebx)
801065a8:	50                   	push   %eax
801065a9:	8b 13                	mov    (%ebx),%edx
801065ab:	89 f0                	mov    %esi,%eax
801065ad:	e8 4e fa ff ff       	call   80106000 <mappages>
801065b2:	83 c4 10             	add    $0x10,%esp
801065b5:	85 c0                	test   %eax,%eax
801065b7:	78 17                	js     801065d0 <setupkvm+0x5c>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801065b9:	83 c3 10             	add    $0x10,%ebx
801065bc:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801065c2:	75 d6                	jne    8010659a <setupkvm+0x26>
}
801065c4:	89 f0                	mov    %esi,%eax
801065c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065c9:	5b                   	pop    %ebx
801065ca:	5e                   	pop    %esi
801065cb:	5d                   	pop    %ebp
801065cc:	c3                   	ret    
801065cd:	8d 76 00             	lea    0x0(%esi),%esi
      freevm(pgdir);
801065d0:	83 ec 0c             	sub    $0xc,%esp
801065d3:	56                   	push   %esi
801065d4:	e8 2b ff ff ff       	call   80106504 <freevm>
      return 0;
801065d9:	83 c4 10             	add    $0x10,%esp
801065dc:	31 f6                	xor    %esi,%esi
}
801065de:	89 f0                	mov    %esi,%eax
801065e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065e3:	5b                   	pop    %ebx
801065e4:	5e                   	pop    %esi
801065e5:	5d                   	pop    %ebp
801065e6:	c3                   	ret    
801065e7:	90                   	nop

801065e8 <kvmalloc>:
{
801065e8:	55                   	push   %ebp
801065e9:	89 e5                	mov    %esp,%ebp
801065eb:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801065ee:	e8 81 ff ff ff       	call   80106574 <setupkvm>
801065f3:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801065f8:	05 00 00 00 80       	add    $0x80000000,%eax
801065fd:	0f 22 d8             	mov    %eax,%cr3
}
80106600:	c9                   	leave  
80106601:	c3                   	ret    
80106602:	66 90                	xchg   %ax,%ax

80106604 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106604:	55                   	push   %ebp
80106605:	89 e5                	mov    %esp,%ebp
80106607:	83 ec 08             	sub    $0x8,%esp
  pde = &pgdir[PDX(va)];
8010660a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010660d:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106610:	8b 45 08             	mov    0x8(%ebp),%eax
80106613:	8b 04 90             	mov    (%eax,%edx,4),%eax
80106616:	a8 01                	test   $0x1,%al
80106618:	75 0e                	jne    80106628 <clearpteu+0x24>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010661a:	83 ec 0c             	sub    $0xc,%esp
8010661d:	68 ea 73 10 80       	push   $0x801073ea
80106622:	e8 11 9d ff ff       	call   80100338 <panic>
80106627:	90                   	nop
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106628:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010662d:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
8010662f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106632:	c1 e8 0a             	shr    $0xa,%eax
80106635:	25 fc 0f 00 00       	and    $0xffc,%eax
8010663a:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106641:	85 c0                	test   %eax,%eax
80106643:	74 d5                	je     8010661a <clearpteu+0x16>
  *pte &= ~PTE_U;
80106645:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106648:	c9                   	leave  
80106649:	c3                   	ret    
8010664a:	66 90                	xchg   %ax,%ax

8010664c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010664c:	55                   	push   %ebp
8010664d:	89 e5                	mov    %esp,%ebp
8010664f:	57                   	push   %edi
80106650:	56                   	push   %esi
80106651:	53                   	push   %ebx
80106652:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106655:	e8 1a ff ff ff       	call   80106574 <setupkvm>
8010665a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010665d:	85 c0                	test   %eax,%eax
8010665f:	0f 84 b0 00 00 00    	je     80106715 <copyuvm+0xc9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106665:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106668:	85 db                	test   %ebx,%ebx
8010666a:	0f 84 a5 00 00 00    	je     80106715 <copyuvm+0xc9>
80106670:	31 ff                	xor    %edi,%edi
80106672:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
80106674:	89 f8                	mov    %edi,%eax
80106676:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106679:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010667c:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010667f:	a8 01                	test   $0x1,%al
80106681:	75 0d                	jne    80106690 <copyuvm+0x44>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106683:	83 ec 0c             	sub    $0xc,%esp
80106686:	68 f4 73 10 80       	push   $0x801073f4
8010668b:	e8 a8 9c ff ff       	call   80100338 <panic>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106690:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106695:	89 fa                	mov    %edi,%edx
80106697:	c1 ea 0a             	shr    $0xa,%edx
8010669a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801066a7:	85 c0                	test   %eax,%eax
801066a9:	74 d8                	je     80106683 <copyuvm+0x37>
    if(!(*pte & PTE_P))
801066ab:	8b 18                	mov    (%eax),%ebx
801066ad:	f6 c3 01             	test   $0x1,%bl
801066b0:	0f 84 96 00 00 00    	je     8010674c <copyuvm+0x100>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801066b6:	89 d8                	mov    %ebx,%eax
801066b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
801066c0:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    if((mem = kalloc()) == 0)
801066c6:	e8 8d bc ff ff       	call   80102358 <kalloc>
801066cb:	89 c6                	mov    %eax,%esi
801066cd:	85 c0                	test   %eax,%eax
801066cf:	74 5b                	je     8010672c <copyuvm+0xe0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801066d1:	50                   	push   %eax
801066d2:	68 00 10 00 00       	push   $0x1000
801066d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066da:	05 00 00 00 80       	add    $0x80000000,%eax
801066df:	50                   	push   %eax
801066e0:	56                   	push   %esi
801066e1:	e8 42 da ff ff       	call   80104128 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801066e6:	5a                   	pop    %edx
801066e7:	59                   	pop    %ecx
801066e8:	53                   	push   %ebx
801066e9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066ef:	50                   	push   %eax
801066f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066f5:	89 fa                	mov    %edi,%edx
801066f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066fa:	e8 01 f9 ff ff       	call   80106000 <mappages>
801066ff:	83 c4 10             	add    $0x10,%esp
80106702:	85 c0                	test   %eax,%eax
80106704:	78 1a                	js     80106720 <copyuvm+0xd4>
  for(i = 0; i < sz; i += PGSIZE){
80106706:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010670c:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010670f:	0f 87 5f ff ff ff    	ja     80106674 <copyuvm+0x28>
  return d;

bad:
  freevm(d);
  return 0;
}
80106715:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106718:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010671b:	5b                   	pop    %ebx
8010671c:	5e                   	pop    %esi
8010671d:	5f                   	pop    %edi
8010671e:	5d                   	pop    %ebp
8010671f:	c3                   	ret    
      kfree(mem);
80106720:	83 ec 0c             	sub    $0xc,%esp
80106723:	56                   	push   %esi
80106724:	e8 9f ba ff ff       	call   801021c8 <kfree>
      goto bad;
80106729:	83 c4 10             	add    $0x10,%esp
  freevm(d);
8010672c:	83 ec 0c             	sub    $0xc,%esp
8010672f:	ff 75 e0             	push   -0x20(%ebp)
80106732:	e8 cd fd ff ff       	call   80106504 <freevm>
  return 0;
80106737:	83 c4 10             	add    $0x10,%esp
8010673a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106741:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106747:	5b                   	pop    %ebx
80106748:	5e                   	pop    %esi
80106749:	5f                   	pop    %edi
8010674a:	5d                   	pop    %ebp
8010674b:	c3                   	ret    
      panic("copyuvm: page not present");
8010674c:	83 ec 0c             	sub    $0xc,%esp
8010674f:	68 0e 74 10 80       	push   $0x8010740e
80106754:	e8 df 9b ff ff       	call   80100338 <panic>
80106759:	8d 76 00             	lea    0x0(%esi),%esi

8010675c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010675c:	55                   	push   %ebp
8010675d:	89 e5                	mov    %esp,%ebp
  pde = &pgdir[PDX(va)];
8010675f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106762:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106765:	8b 45 08             	mov    0x8(%ebp),%eax
80106768:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010676b:	a8 01                	test   $0x1,%al
8010676d:	0f 84 f3 00 00 00    	je     80106866 <uva2ka.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106773:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106778:	89 c2                	mov    %eax,%edx
  return &pgtab[PTX(va)];
8010677a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010677d:	c1 e8 0c             	shr    $0xc,%eax
80106780:	25 ff 03 00 00       	and    $0x3ff,%eax
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
80106785:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
    return 0;
  if((*pte & PTE_U) == 0)
8010678c:	89 c2                	mov    %eax,%edx
8010678e:	83 e2 05             	and    $0x5,%edx
80106791:	83 fa 05             	cmp    $0x5,%edx
80106794:	75 0e                	jne    801067a4 <uva2ka+0x48>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106796:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010679b:	05 00 00 00 80       	add    $0x80000000,%eax
}
801067a0:	5d                   	pop    %ebp
801067a1:	c3                   	ret    
801067a2:	66 90                	xchg   %ax,%ax
    return 0;
801067a4:	31 c0                	xor    %eax,%eax
}
801067a6:	5d                   	pop    %ebp
801067a7:	c3                   	ret    

801067a8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801067a8:	55                   	push   %ebp
801067a9:	89 e5                	mov    %esp,%ebp
801067ab:	57                   	push   %edi
801067ac:	56                   	push   %esi
801067ad:	53                   	push   %ebx
801067ae:	83 ec 0c             	sub    $0xc,%esp
801067b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801067b4:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801067b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
801067ba:	85 c9                	test   %ecx,%ecx
801067bc:	0f 84 9a 00 00 00    	je     8010685c <copyout+0xb4>
801067c2:	89 fe                	mov    %edi,%esi
801067c4:	eb 45                	jmp    8010680b <copyout+0x63>
801067c6:	66 90                	xchg   %ax,%ax
  return (char*)P2V(PTE_ADDR(*pte));
801067c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801067ce:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801067d4:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801067da:	74 71                	je     8010684d <copyout+0xa5>
      return -1;
    n = PGSIZE - (va - va0);
801067dc:	89 fb                	mov    %edi,%ebx
801067de:	29 c3                	sub    %eax,%ebx
801067e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067e6:	3b 5d 14             	cmp    0x14(%ebp),%ebx
801067e9:	76 03                	jbe    801067ee <copyout+0x46>
801067eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801067ee:	52                   	push   %edx
801067ef:	53                   	push   %ebx
801067f0:	56                   	push   %esi
801067f1:	29 f8                	sub    %edi,%eax
801067f3:	01 c1                	add    %eax,%ecx
801067f5:	51                   	push   %ecx
801067f6:	e8 2d d9 ff ff       	call   80104128 <memmove>
    len -= n;
    buf += n;
801067fb:	01 de                	add    %ebx,%esi
    va = va0 + PGSIZE;
801067fd:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80106803:	83 c4 10             	add    $0x10,%esp
80106806:	29 5d 14             	sub    %ebx,0x14(%ebp)
80106809:	74 51                	je     8010685c <copyout+0xb4>
    va0 = (uint)PGROUNDDOWN(va);
8010680b:	89 c7                	mov    %eax,%edi
8010680d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pde = &pgdir[PDX(va)];
80106813:	89 c1                	mov    %eax,%ecx
80106815:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106818:	8b 55 08             	mov    0x8(%ebp),%edx
8010681b:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
8010681e:	f6 c1 01             	test   $0x1,%cl
80106821:	0f 84 46 00 00 00    	je     8010686d <copyout.cold>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106827:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010682d:	89 fb                	mov    %edi,%ebx
8010682f:	c1 eb 0c             	shr    $0xc,%ebx
80106832:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80106838:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010683f:	89 d9                	mov    %ebx,%ecx
80106841:	83 e1 05             	and    $0x5,%ecx
80106844:	83 f9 05             	cmp    $0x5,%ecx
80106847:	0f 84 7b ff ff ff    	je     801067c8 <copyout+0x20>
      return -1;
8010684d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106852:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106855:	5b                   	pop    %ebx
80106856:	5e                   	pop    %esi
80106857:	5f                   	pop    %edi
80106858:	5d                   	pop    %ebp
80106859:	c3                   	ret    
8010685a:	66 90                	xchg   %ax,%ax
  return 0;
8010685c:	31 c0                	xor    %eax,%eax
}
8010685e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106861:	5b                   	pop    %ebx
80106862:	5e                   	pop    %esi
80106863:	5f                   	pop    %edi
80106864:	5d                   	pop    %ebp
80106865:	c3                   	ret    

80106866 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80106866:	a1 00 00 00 00       	mov    0x0,%eax
8010686b:	0f 0b                	ud2    

8010686d <copyout.cold>:
8010686d:	a1 00 00 00 00       	mov    0x0,%eax
80106872:	0f 0b                	ud2    

80106874 <sgenrand>:

/* initializing the array with a NONZERO seed */
void
sgenrand(seed)
    unsigned long seed;	
{
80106874:	55                   	push   %ebp
80106875:	89 e5                	mov    %esp,%ebp
80106877:	8b 45 08             	mov    0x8(%ebp),%eax
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
8010687a:	a3 e0 44 11 80       	mov    %eax,0x801144e0
    for (mti=1; mti<N; mti++)
8010687f:	b9 e4 44 11 80       	mov    $0x801144e4,%ecx
80106884:	eb 05                	jmp    8010688b <sgenrand+0x17>
80106886:	66 90                	xchg   %ax,%ax
80106888:	83 c1 04             	add    $0x4,%ecx
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
8010688b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010688e:	01 c2                	add    %eax,%edx
80106890:	01 d2                	add    %edx,%edx
80106892:	01 c2                	add    %eax,%edx
80106894:	8d 14 90             	lea    (%eax,%edx,4),%edx
80106897:	8d 14 d2             	lea    (%edx,%edx,8),%edx
8010689a:	01 d2                	add    %edx,%edx
8010689c:	01 c2                	add    %eax,%edx
8010689e:	8d 04 90             	lea    (%eax,%edx,4),%eax
801068a1:	89 c2                	mov    %eax,%edx
801068a3:	c1 e2 05             	shl    $0x5,%edx
801068a6:	01 d0                	add    %edx,%eax
801068a8:	89 01                	mov    %eax,(%ecx)
    for (mti=1; mti<N; mti++)
801068aa:	81 f9 9c 4e 11 80    	cmp    $0x80114e9c,%ecx
801068b0:	75 d6                	jne    80106888 <sgenrand+0x14>
801068b2:	c7 05 60 a4 10 80 70 	movl   $0x270,0x8010a460
801068b9:	02 00 00 
}
801068bc:	5d                   	pop    %ebp
801068bd:	c3                   	ret    
801068be:	66 90                	xchg   %ax,%ax

801068c0 <genrand>:

long
genrand()
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	53                   	push   %ebx
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
801068c4:	a1 60 a4 10 80       	mov    0x8010a460,%eax
801068c9:	3d 6f 02 00 00       	cmp    $0x26f,%eax
801068ce:	7f 41                	jg     80106911 <genrand+0x51>
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];

        mti = 0;
    }
  
    y = mt[mti++];
801068d0:	8d 50 01             	lea    0x1(%eax),%edx
801068d3:	8b 0c 85 e0 44 11 80 	mov    -0x7feebb20(,%eax,4),%ecx
801068da:	89 15 60 a4 10 80    	mov    %edx,0x8010a460
    y ^= TEMPERING_SHIFT_U(y);
801068e0:	89 ca                	mov    %ecx,%edx
801068e2:	c1 ea 0b             	shr    $0xb,%edx
801068e5:	31 ca                	xor    %ecx,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
801068e7:	89 d0                	mov    %edx,%eax
801068e9:	c1 e0 07             	shl    $0x7,%eax
801068ec:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
801068f1:	31 d0                	xor    %edx,%eax
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
801068f3:	89 c2                	mov    %eax,%edx
801068f5:	c1 e2 0f             	shl    $0xf,%edx
801068f8:	81 e2 00 00 c6 ef    	and    $0xefc60000,%edx
801068fe:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_L(y);
80106900:	89 d0                	mov    %edx,%eax
80106902:	c1 e8 12             	shr    $0x12,%eax
80106905:	31 d0                	xor    %edx,%eax

    return y & RAND_MAX; /* for long  generation */
80106907:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
8010690c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010690f:	c9                   	leave  
80106910:	c3                   	ret    
        if (mti == N+1)   /* if sgenrand() has not been called, */
80106911:	3d 71 02 00 00       	cmp    $0x271,%eax
80106916:	0f 84 c2 00 00 00    	je     801069de <genrand+0x11e>
    mt[0]= seed & 0xffffffff;
8010691c:	31 c0                	xor    %eax,%eax
8010691e:	66 90                	xchg   %ax,%ax
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80106920:	8b 0c 85 e0 44 11 80 	mov    -0x7feebb20(,%eax,4),%ecx
80106927:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
8010692d:	40                   	inc    %eax
8010692e:	8b 14 85 e0 44 11 80 	mov    -0x7feebb20(,%eax,4),%edx
80106935:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
8010693b:	09 ca                	or     %ecx,%edx
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
8010693d:	89 d1                	mov    %edx,%ecx
8010693f:	d1 e9                	shr    %ecx
80106941:	33 0c 85 10 4b 11 80 	xor    -0x7feeb4f0(,%eax,4),%ecx
80106948:	83 e2 01             	and    $0x1,%edx
8010694b:	33 0c 95 4c 74 10 80 	xor    -0x7fef8bb4(,%edx,4),%ecx
80106952:	89 0c 85 dc 44 11 80 	mov    %ecx,-0x7feebb24(,%eax,4)
        for (kk=0;kk<N-M;kk++) {
80106959:	3d e3 00 00 00       	cmp    $0xe3,%eax
8010695e:	75 c0                	jne    80106920 <genrand+0x60>
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
80106960:	8b 0c 85 e0 44 11 80 	mov    -0x7feebb20(,%eax,4),%ecx
80106967:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
8010696d:	40                   	inc    %eax
8010696e:	8b 14 85 e0 44 11 80 	mov    -0x7feebb20(,%eax,4),%edx
80106975:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
8010697b:	09 ca                	or     %ecx,%edx
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
8010697d:	89 d1                	mov    %edx,%ecx
8010697f:	d1 e9                	shr    %ecx
80106981:	33 0c 85 50 41 11 80 	xor    -0x7feebeb0(,%eax,4),%ecx
80106988:	83 e2 01             	and    $0x1,%edx
8010698b:	33 0c 95 4c 74 10 80 	xor    -0x7fef8bb4(,%edx,4),%ecx
80106992:	89 0c 85 dc 44 11 80 	mov    %ecx,-0x7feebb24(,%eax,4)
        for (;kk<N-1;kk++) {
80106999:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010699e:	75 c0                	jne    80106960 <genrand+0xa0>
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
801069a0:	8b 0d e0 44 11 80    	mov    0x801144e0,%ecx
801069a6:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
801069ab:	25 00 00 00 80       	and    $0x80000000,%eax
801069b0:	89 ca                	mov    %ecx,%edx
801069b2:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
801069b8:	09 d0                	or     %edx,%eax
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
801069ba:	89 c2                	mov    %eax,%edx
801069bc:	d1 ea                	shr    %edx
801069be:	33 15 10 4b 11 80    	xor    0x80114b10,%edx
801069c4:	83 e0 01             	and    $0x1,%eax
801069c7:	33 14 85 4c 74 10 80 	xor    -0x7fef8bb4(,%eax,4),%edx
801069ce:	89 15 9c 4e 11 80    	mov    %edx,0x80114e9c
801069d4:	ba 01 00 00 00       	mov    $0x1,%edx
801069d9:	e9 fc fe ff ff       	jmp    801068da <genrand+0x1a>
    mt[0]= seed & 0xffffffff;
801069de:	c7 05 e0 44 11 80 05 	movl   $0x1105,0x801144e0
801069e5:	11 00 00 
    for (mti=1; mti<N; mti++)
801069e8:	b9 e4 44 11 80       	mov    $0x801144e4,%ecx
801069ed:	bb 9c 4e 11 80       	mov    $0x80114e9c,%ebx
    mt[0]= seed & 0xffffffff;
801069f2:	b8 05 11 00 00       	mov    $0x1105,%eax
801069f7:	eb 06                	jmp    801069ff <genrand+0x13f>
801069f9:	8d 76 00             	lea    0x0(%esi),%esi
801069fc:	83 c1 04             	add    $0x4,%ecx
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
801069ff:	8d 14 00             	lea    (%eax,%eax,1),%edx
80106a02:	01 c2                	add    %eax,%edx
80106a04:	01 d2                	add    %edx,%edx
80106a06:	01 c2                	add    %eax,%edx
80106a08:	8d 14 90             	lea    (%eax,%edx,4),%edx
80106a0b:	8d 14 d2             	lea    (%edx,%edx,8),%edx
80106a0e:	01 d2                	add    %edx,%edx
80106a10:	01 c2                	add    %eax,%edx
80106a12:	8d 04 90             	lea    (%eax,%edx,4),%eax
80106a15:	89 c2                	mov    %eax,%edx
80106a17:	c1 e2 05             	shl    $0x5,%edx
80106a1a:	01 d0                	add    %edx,%eax
80106a1c:	89 01                	mov    %eax,(%ecx)
    for (mti=1; mti<N; mti++)
80106a1e:	39 cb                	cmp    %ecx,%ebx
80106a20:	75 da                	jne    801069fc <genrand+0x13c>
80106a22:	e9 f5 fe ff ff       	jmp    8010691c <genrand+0x5c>
80106a27:	90                   	nop

80106a28 <random_at_most>:

// Assumes 1 <= max <= RAND_MAX
// Returns in the half-open interval [1, max]
long random_at_most(long max) {
80106a28:	55                   	push   %ebp
80106a29:	89 e5                	mov    %esp,%ebp
80106a2b:	56                   	push   %esi
80106a2c:	53                   	push   %ebx
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
80106a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a30:	8d 48 01             	lea    0x1(%eax),%ecx
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
80106a33:	bb 00 00 00 80       	mov    $0x80000000,%ebx
80106a38:	89 d8                	mov    %ebx,%eax
80106a3a:	31 d2                	xor    %edx,%edx
80106a3c:	f7 f1                	div    %ecx
80106a3e:	89 c6                	mov    %eax,%esi
  long x;
  do {
   x = genrand();
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80106a40:	29 d3                	sub    %edx,%ebx
80106a42:	66 90                	xchg   %ax,%ax
   x = genrand();
80106a44:	e8 77 fe ff ff       	call   801068c0 <genrand>
  while (num_rand - defect <= (unsigned long)x);
80106a49:	39 d8                	cmp    %ebx,%eax
80106a4b:	73 f7                	jae    80106a44 <random_at_most+0x1c>

  long ret = x/bin_size;
  if (!ret)
80106a4d:	39 f0                	cmp    %esi,%eax
80106a4f:	72 0b                	jb     80106a5c <random_at_most+0x34>
  long ret = x/bin_size;
80106a51:	31 d2                	xor    %edx,%edx
80106a53:	f7 f6                	div    %esi
      ret++;

  // Truncated division is intentional
  return ret;
}
80106a55:	5b                   	pop    %ebx
80106a56:	5e                   	pop    %esi
80106a57:	5d                   	pop    %ebp
80106a58:	c3                   	ret    
80106a59:	8d 76 00             	lea    0x0(%esi),%esi
      ret++;
80106a5c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106a61:	5b                   	pop    %ebx
80106a62:	5e                   	pop    %esi
80106a63:	5d                   	pop    %ebp
80106a64:	c3                   	ret    
