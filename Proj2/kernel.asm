
kernel:     file format elf32-i386


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
80100028:	bc f0 55 11 80       	mov    $0x801155f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 90 31 10 80       	mov    $0x80103190,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 75 10 80       	push   $0x80107540
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 05 46 00 00       	call   80104660 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 75 10 80       	push   $0x80107547
80100097:	50                   	push   %eax
80100098:	e8 b3 44 00 00       	call   80104550 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 87 46 00 00       	call   80104770 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 29 47 00 00       	call   80104890 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 44 00 00       	call   80104590 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 7f 22 00 00       	call   80102410 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 75 10 80       	push   $0x8010754e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 44 00 00       	call   80104630 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 37 22 00 00       	jmp    80102410 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 75 10 80       	push   $0x8010755f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 44 00 00       	call   80104630 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 43 00 00       	call   801045f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 50 45 00 00       	call   80104770 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 1f 46 00 00       	jmp    80104890 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 75 10 80       	push   $0x80107566
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 f7 16 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 cb 44 00 00       	call   80104770 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 9e 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 95 45 00 00       	call   80104890 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	pushl  0x8(%ebp)
801002ff:	e8 ac 15 00 00       	call   801018b0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 3f 45 00 00       	call   80104890 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	pushl  0x8(%ebp)
80100355:	e8 56 15 00 00       	call   801018b0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 82 26 00 00       	call   80102a20 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 75 10 80       	push   $0x8010756d
801003a7:	e8 d4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 cb 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 09 7d 10 80 	movl   $0x80107d09,(%esp)
801003bc:	e8 bf 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 b3 42 00 00       	call   80104680 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 75 10 80       	push   $0x80107581
801003dd:	e8 9e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	c1 e0 08             	shl    $0x8,%eax
80100428:	89 c3                	mov    %eax,%ebx
8010042a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100430:	89 f2                	mov    %esi,%edx
80100432:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100433:	0f b6 c0             	movzbl %al,%eax
80100436:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100438:	83 f9 0a             	cmp    $0xa,%ecx
8010043b:	0f 84 97 00 00 00    	je     801004d8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100441:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100447:	74 77                	je     801004c0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c9             	movzbl %cl,%ecx
8010044c:	8d 58 01             	lea    0x1(%eax),%ebx
8010044f:	80 cd 07             	or     $0x7,%ch
80100452:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	0f 8f cc 00 00 00    	jg     80100532 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100466:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046c:	0f 8f 7e 00 00 00    	jg     801004f0 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100472:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100475:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100477:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100481:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100486:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048b:	89 da                	mov    %ebx,%edx
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100493:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100497:	89 ca                	mov    %ecx,%edx
80100499:	ee                   	out    %al,(%dx)
8010049a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ee                   	out    %al,(%dx)
801004a2:	89 f8                	mov    %edi,%eax
801004a4:	89 ca                	mov    %ecx,%edx
801004a6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a7:	b8 20 07 00 00       	mov    $0x720,%eax
801004ac:	66 89 06             	mov    %ax,(%esi)
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
801004b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004be:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004c3:	85 c0                	test   %eax,%eax
801004c5:	75 93                	jne    8010045a <cgaputc+0x5a>
801004c7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004cb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004d0:	31 ff                	xor    %edi,%edi
801004d2:	eb ad                	jmp    80100481 <cgaputc+0x81>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004dd:	f7 e2                	mul    %edx
801004df:	c1 ea 06             	shr    $0x6,%edx
801004e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004e5:	c1 e0 04             	shl    $0x4,%eax
801004e8:	8d 58 50             	lea    0x50(%eax),%ebx
801004eb:	e9 6a ff ff ff       	jmp    8010045a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004f3:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fd:	68 60 0e 00 00       	push   $0xe60
80100502:	68 a0 80 0b 80       	push   $0x800b80a0
80100507:	68 00 80 0b 80       	push   $0x800b8000
8010050c:	e8 6f 44 00 00       	call   80104980 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100511:	b8 80 07 00 00       	mov    $0x780,%eax
80100516:	83 c4 0c             	add    $0xc,%esp
80100519:	29 f8                	sub    %edi,%eax
8010051b:	01 c0                	add    %eax,%eax
8010051d:	50                   	push   %eax
8010051e:	6a 00                	push   $0x0
80100520:	56                   	push   %esi
80100521:	e8 ba 43 00 00       	call   801048e0 <memset>
  outb(CRTPORT+1, pos);
80100526:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010052a:	83 c4 10             	add    $0x10,%esp
8010052d:	e9 4f ff ff ff       	jmp    80100481 <cgaputc+0x81>
    panic("pos under/overflow");
80100532:	83 ec 0c             	sub    $0xc,%esp
80100535:	68 85 75 10 80       	push   $0x80107585
8010053a:	e8 41 fe ff ff       	call   80100380 <panic>
8010053f:	90                   	nop

80100540 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	53                   	push   %ebx
80100546:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100549:	ff 75 08             	pushl  0x8(%ebp)
{
8010054c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010054f:	e8 3c 14 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100554:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010055b:	e8 10 42 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++)
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	85 f6                	test   %esi,%esi
80100565:	7e 3a                	jle    801005a1 <consolewrite+0x61>
80100567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010056a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010056d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100573:	85 d2                	test   %edx,%edx
80100575:	74 09                	je     80100580 <consolewrite+0x40>
  asm volatile("cli");
80100577:	fa                   	cli    
    for(;;)
80100578:	eb fe                	jmp    80100578 <consolewrite+0x38>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100580:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100583:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100586:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100589:	50                   	push   %eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	e8 ce 5a 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100595:	e8 66 fe ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	39 df                	cmp    %ebx,%edi
8010059f:	75 cc                	jne    8010056d <consolewrite+0x2d>
  release(&cons.lock);
801005a1:	83 ec 0c             	sub    $0xc,%esp
801005a4:	68 20 ef 10 80       	push   $0x8010ef20
801005a9:	e8 e2 42 00 00       	call   80104890 <release>
  ilock(ip);
801005ae:	58                   	pop    %eax
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 f9 12 00 00       	call   801018b0 <ilock>

  return n;
}
801005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ba:	89 f0                	mov    %esi,%eax
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
801005c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop

801005d0 <printint>:
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 2c             	sub    $0x2c,%esp
801005d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005df:	85 c9                	test   %ecx,%ecx
801005e1:	74 04                	je     801005e7 <printint+0x17>
801005e3:	85 c0                	test   %eax,%eax
801005e5:	78 7e                	js     80100665 <printint+0x95>
    x = xx;
801005e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801005f0:	31 db                	xor    %ebx,%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801005f8:	89 c8                	mov    %ecx,%eax
801005fa:	31 d2                	xor    %edx,%edx
801005fc:	89 de                	mov    %ebx,%esi
801005fe:	89 cf                	mov    %ecx,%edi
80100600:	f7 75 d4             	divl   -0x2c(%ebp)
80100603:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100606:	0f b6 92 b0 75 10 80 	movzbl -0x7fef8a50(%edx),%edx
  }while((x /= base) != 0);
8010060d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010060f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100613:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100616:	73 e0                	jae    801005f8 <printint+0x28>
  if(sign)
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	85 c9                	test   %ecx,%ecx
8010061d:	74 0c                	je     8010062b <printint+0x5b>
    buf[i++] = '-';
8010061f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100624:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100626:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010062b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010062f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100634:	85 c0                	test   %eax,%eax
80100636:	74 08                	je     80100640 <printint+0x70>
80100638:	fa                   	cli    
    for(;;)
80100639:	eb fe                	jmp    80100639 <printint+0x69>
8010063b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop
    consputc(buf[i]);
80100640:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100643:	83 ec 0c             	sub    $0xc,%esp
80100646:	56                   	push   %esi
80100647:	e8 14 5a 00 00       	call   80106060 <uartputc>
  cgaputc(c);
8010064c:	89 f0                	mov    %esi,%eax
8010064e:	e8 ad fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100653:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	39 c3                	cmp    %eax,%ebx
8010065b:	74 0e                	je     8010066b <printint+0x9b>
    consputc(buf[i]);
8010065d:	0f b6 13             	movzbl (%ebx),%edx
80100660:	83 eb 01             	sub    $0x1,%ebx
80100663:	eb ca                	jmp    8010062f <printint+0x5f>
    x = -xx;
80100665:	f7 d8                	neg    %eax
80100667:	89 c1                	mov    %eax,%ecx
80100669:	eb 85                	jmp    801005f0 <printint+0x20>
}
8010066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066e:	5b                   	pop    %ebx
8010066f:	5e                   	pop    %esi
80100670:	5f                   	pop    %edi
80100671:	5d                   	pop    %ebp
80100672:	c3                   	ret    
80100673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
8010068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 37 01 00 00    	jne    801007d0 <cprintf+0x150>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 3f 02 00 00    	je     801008e3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	31 db                	xor    %ebx,%ebx
801006ac:	85 c0                	test   %eax,%eax
801006ae:	74 56                	je     80100706 <cprintf+0x86>
    if(c != '%'){
801006b0:	83 f8 25             	cmp    $0x25,%eax
801006b3:	0f 85 d7 00 00 00    	jne    80100790 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006b9:	83 c3 01             	add    $0x1,%ebx
801006bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006c0:	85 d2                	test   %edx,%edx
801006c2:	74 42                	je     80100706 <cprintf+0x86>
    switch(c){
801006c4:	83 fa 70             	cmp    $0x70,%edx
801006c7:	0f 84 94 00 00 00    	je     80100761 <cprintf+0xe1>
801006cd:	7f 51                	jg     80100720 <cprintf+0xa0>
801006cf:	83 fa 25             	cmp    $0x25,%edx
801006d2:	0f 84 48 01 00 00    	je     80100820 <cprintf+0x1a0>
801006d8:	83 fa 64             	cmp    $0x64,%edx
801006db:	0f 85 04 01 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006e1:	8d 47 04             	lea    0x4(%edi),%eax
801006e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801006e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f1:	8b 07                	mov    (%edi),%eax
801006f3:	e8 d8 fe ff ff       	call   801005d0 <printint>
801006f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fb:	83 c3 01             	add    $0x1,%ebx
801006fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 aa                	jne    801006b0 <cprintf+0x30>
  if(locking)
80100706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 b5 01 00 00    	jne    801008c6 <cprintf+0x246>
}
80100711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100714:	5b                   	pop    %ebx
80100715:	5e                   	pop    %esi
80100716:	5f                   	pop    %edi
80100717:	5d                   	pop    %ebp
80100718:	c3                   	ret    
80100719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	75 33                	jne    80100758 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100725:	8d 47 04             	lea    0x4(%edi),%eax
80100728:	8b 3f                	mov    (%edi),%edi
8010072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 85 33 01 00 00    	jne    80100868 <cprintf+0x1e8>
        s = "(null)";
80100735:	bf 98 75 10 80       	mov    $0x80107598,%edi
      for(; *s; s++)
8010073a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010073d:	b8 28 00 00 00       	mov    $0x28,%eax
80100742:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100744:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010074a:	85 d2                	test   %edx,%edx
8010074c:	0f 84 27 01 00 00    	je     80100879 <cprintf+0x1f9>
80100752:	fa                   	cli    
    for(;;)
80100753:	eb fe                	jmp    80100753 <cprintf+0xd3>
80100755:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100758:	83 fa 78             	cmp    $0x78,%edx
8010075b:	0f 85 84 00 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	31 c9                	xor    %ecx,%ecx
80100766:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 58 fe ff ff       	call   801005d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100778:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	85 c0                	test   %eax,%eax
80100781:	0f 85 29 ff ff ff    	jne    801006b0 <cprintf+0x30>
80100787:	e9 7a ff ff ff       	jmp    80100706 <cprintf+0x86>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100790:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100796:	85 c9                	test   %ecx,%ecx
80100798:	74 06                	je     801007a0 <cprintf+0x120>
8010079a:	fa                   	cli    
    for(;;)
8010079b:	eb fe                	jmp    8010079b <cprintf+0x11b>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007a9:	50                   	push   %eax
801007aa:	e8 b1 58 00 00       	call   80106060 <uartputc>
  cgaputc(c);
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	e8 49 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 85 ea fe ff ff    	jne    801006b0 <cprintf+0x30>
801007c6:	e9 3b ff ff ff       	jmp    80100706 <cprintf+0x86>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 93 3f 00 00       	call   80104770 <acquire>
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	e9 b4 fe ff ff       	jmp    80100699 <cprintf+0x19>
  if(panicked){
801007e5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007eb:	85 c9                	test   %ecx,%ecx
801007ed:	75 71                	jne    80100860 <cprintf+0x1e0>
    uartputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f5:	6a 25                	push   $0x25
801007f7:	e8 64 58 00 00       	call   80106060 <uartputc>
  cgaputc(c);
801007fc:	b8 25 00 00 00       	mov    $0x25,%eax
80100801:	e8 fa fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100806:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	85 d2                	test   %edx,%edx
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	0f 84 8e 00 00 00    	je     801008a8 <cprintf+0x228>
8010081a:	fa                   	cli    
    for(;;)
8010081b:	eb fe                	jmp    8010081b <cprintf+0x19b>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100820:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	74 07                	je     80100830 <cprintf+0x1b0>
80100829:	fa                   	cli    
    for(;;)
8010082a:	eb fe                	jmp    8010082a <cprintf+0x1aa>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100830:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100833:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100836:	6a 25                	push   $0x25
80100838:	e8 23 58 00 00       	call   80106060 <uartputc>
  cgaputc(c);
8010083d:	b8 25 00 00 00       	mov    $0x25,%eax
80100842:	e8 b9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100847:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010084b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010084e:	85 c0                	test   %eax,%eax
80100850:	0f 85 5a fe ff ff    	jne    801006b0 <cprintf+0x30>
80100856:	e9 ab fe ff ff       	jmp    80100706 <cprintf+0x86>
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop
80100860:	fa                   	cli    
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x1e1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
      for(; *s; s++)
80100868:	0f b6 07             	movzbl (%edi),%eax
8010086b:	84 c0                	test   %al,%al
8010086d:	74 6c                	je     801008db <cprintf+0x25b>
8010086f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100872:	89 fb                	mov    %edi,%ebx
80100874:	e9 cb fe ff ff       	jmp    80100744 <cprintf+0xc4>
    uartputc(c);
80100879:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010087c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010087f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100882:	57                   	push   %edi
80100883:	e8 d8 57 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 71 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
8010088f:	0f b6 03             	movzbl (%ebx),%eax
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	84 c0                	test   %al,%al
80100897:	0f 85 a7 fe ff ff    	jne    80100744 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010089d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008a3:	e9 53 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    uartputc(c);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008ae:	52                   	push   %edx
801008af:	e8 ac 57 00 00       	call   80106060 <uartputc>
  cgaputc(c);
801008b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b7:	89 d0                	mov    %edx,%eax
801008b9:	e8 42 fb ff ff       	call   80100400 <cgaputc>
}
801008be:	83 c4 10             	add    $0x10,%esp
801008c1:	e9 35 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    release(&cons.lock);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 20 ef 10 80       	push   $0x8010ef20
801008ce:	e8 bd 3f 00 00       	call   80104890 <release>
801008d3:	83 c4 10             	add    $0x10,%esp
}
801008d6:	e9 36 fe ff ff       	jmp    80100711 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008db:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008de:	e9 18 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    panic("null fmt");
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 9f 75 10 80       	push   $0x8010759f
801008eb:	e8 90 fa ff ff       	call   80100380 <panic>

801008f0 <consoleintr>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008f6:	31 db                	xor    %ebx,%ebx
{
801008f8:	83 ec 28             	sub    $0x28,%esp
801008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008fe:	68 20 ef 10 80       	push   $0x8010ef20
80100903:	e8 68 3e 00 00       	call   80104770 <acquire>
  while((c = getc()) >= 0){
80100908:	83 c4 10             	add    $0x10,%esp
8010090b:	eb 1a                	jmp    80100927 <consoleintr+0x37>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100910:	83 f8 08             	cmp    $0x8,%eax
80100913:	0f 84 17 01 00 00    	je     80100a30 <consoleintr+0x140>
80100919:	83 f8 10             	cmp    $0x10,%eax
8010091c:	0f 85 9a 01 00 00    	jne    80100abc <consoleintr+0x1cc>
80100922:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
80100927:	ff d6                	call   *%esi
80100929:	85 c0                	test   %eax,%eax
8010092b:	0f 88 6f 01 00 00    	js     80100aa0 <consoleintr+0x1b0>
    switch(c){
80100931:	83 f8 15             	cmp    $0x15,%eax
80100934:	0f 84 b6 00 00 00    	je     801009f0 <consoleintr+0x100>
8010093a:	7e d4                	jle    80100910 <consoleintr+0x20>
8010093c:	83 f8 7f             	cmp    $0x7f,%eax
8010093f:	0f 84 eb 00 00 00    	je     80100a30 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100945:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
8010094b:	89 d1                	mov    %edx,%ecx
8010094d:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
80100953:	83 f9 7f             	cmp    $0x7f,%ecx
80100956:	77 cf                	ja     80100927 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100958:	89 d1                	mov    %edx,%ecx
8010095a:	83 c2 01             	add    $0x1,%edx
  if(panicked){
8010095d:	8b 3d 58 ef 10 80    	mov    0x8010ef58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100963:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100969:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
8010096c:	83 f8 0d             	cmp    $0xd,%eax
8010096f:	0f 84 9b 01 00 00    	je     80100b10 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
80100975:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
8010097b:	85 ff                	test   %edi,%edi
8010097d:	0f 85 98 01 00 00    	jne    80100b1b <consoleintr+0x22b>
  if(c == BACKSPACE){
80100983:	3d 00 01 00 00       	cmp    $0x100,%eax
80100988:	0f 85 b3 01 00 00    	jne    80100b41 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010098e:	83 ec 0c             	sub    $0xc,%esp
80100991:	6a 08                	push   $0x8
80100993:	e8 c8 56 00 00       	call   80106060 <uartputc>
80100998:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010099f:	e8 bc 56 00 00       	call   80106060 <uartputc>
801009a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009ab:	e8 b0 56 00 00       	call   80106060 <uartputc>
  cgaputc(c);
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 46 fa ff ff       	call   80100400 <cgaputc>
801009ba:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009bd:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009c2:	83 e8 80             	sub    $0xffffff80,%eax
801009c5:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009cb:	0f 85 56 ff ff ff    	jne    80100927 <consoleintr+0x37>
          wakeup(&input.r);
801009d1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009d4:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801009d9:	68 00 ef 10 80       	push   $0x8010ef00
801009de:	e8 4d 39 00 00       	call   80104330 <wakeup>
801009e3:	83 c4 10             	add    $0x10,%esp
801009e6:	e9 3c ff ff ff       	jmp    80100927 <consoleintr+0x37>
801009eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ef:	90                   	nop
      while(input.e != input.w &&
801009f0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009f5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009fb:	0f 84 26 ff ff ff    	je     80100927 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a01:	83 e8 01             	sub    $0x1,%eax
80100a04:	89 c2                	mov    %eax,%edx
80100a06:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a09:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a10:	0f 84 11 ff ff ff    	je     80100927 <consoleintr+0x37>
  if(panicked){
80100a16:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a1c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a21:	85 d2                	test   %edx,%edx
80100a23:	74 33                	je     80100a58 <consoleintr+0x168>
80100a25:	fa                   	cli    
    for(;;)
80100a26:	eb fe                	jmp    80100a26 <consoleintr+0x136>
80100a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2f:	90                   	nop
      if(input.e != input.w){
80100a30:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a35:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a3b:	0f 84 e6 fe ff ff    	je     80100927 <consoleintr+0x37>
        input.e--;
80100a41:	83 e8 01             	sub    $0x1,%eax
80100a44:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a49:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	74 7e                	je     80100ad0 <consoleintr+0x1e0>
80100a52:	fa                   	cli    
    for(;;)
80100a53:	eb fe                	jmp    80100a53 <consoleintr+0x163>
80100a55:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	6a 08                	push   $0x8
80100a5d:	e8 fe 55 00 00       	call   80106060 <uartputc>
80100a62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a69:	e8 f2 55 00 00       	call   80106060 <uartputc>
80100a6e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a75:	e8 e6 55 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100a7a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a7f:	e8 7c f9 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100a84:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a89:	83 c4 10             	add    $0x10,%esp
80100a8c:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a92:	0f 85 69 ff ff ff    	jne    80100a01 <consoleintr+0x111>
80100a98:	e9 8a fe ff ff       	jmp    80100927 <consoleintr+0x37>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 20 ef 10 80       	push   $0x8010ef20
80100aa8:	e8 e3 3d 00 00       	call   80104890 <release>
  if(doprocdump) {
80100aad:	83 c4 10             	add    $0x10,%esp
80100ab0:	85 db                	test   %ebx,%ebx
80100ab2:	75 50                	jne    80100b04 <consoleintr+0x214>
}
80100ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ab7:	5b                   	pop    %ebx
80100ab8:	5e                   	pop    %esi
80100ab9:	5f                   	pop    %edi
80100aba:	5d                   	pop    %ebp
80100abb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100abc:	85 c0                	test   %eax,%eax
80100abe:	0f 84 63 fe ff ff    	je     80100927 <consoleintr+0x37>
80100ac4:	e9 7c fe ff ff       	jmp    80100945 <consoleintr+0x55>
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	6a 08                	push   $0x8
80100ad5:	e8 86 55 00 00       	call   80106060 <uartputc>
80100ada:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae1:	e8 7a 55 00 00       	call   80106060 <uartputc>
80100ae6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100aed:	e8 6e 55 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100af2:	b8 00 01 00 00       	mov    $0x100,%eax
80100af7:	e8 04 f9 ff ff       	call   80100400 <cgaputc>
}
80100afc:	83 c4 10             	add    $0x10,%esp
80100aff:	e9 23 fe ff ff       	jmp    80100927 <consoleintr+0x37>
}
80100b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b07:	5b                   	pop    %ebx
80100b08:	5e                   	pop    %esi
80100b09:	5f                   	pop    %edi
80100b0a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b0b:	e9 00 39 00 00       	jmp    80104410 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b10:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
  if(panicked){
80100b17:	85 ff                	test   %edi,%edi
80100b19:	74 05                	je     80100b20 <consoleintr+0x230>
80100b1b:	fa                   	cli    
    for(;;)
80100b1c:	eb fe                	jmp    80100b1c <consoleintr+0x22c>
80100b1e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	6a 0a                	push   $0xa
80100b25:	e8 36 55 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b2f:	e8 cc f8 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100b34:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b39:	83 c4 10             	add    $0x10,%esp
80100b3c:	e9 90 fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
    uartputc(c);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b47:	50                   	push   %eax
80100b48:	e8 13 55 00 00       	call   80106060 <uartputc>
  cgaputc(c);
80100b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b50:	e8 ab f8 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b58:	83 c4 10             	add    $0x10,%esp
80100b5b:	83 f8 0a             	cmp    $0xa,%eax
80100b5e:	74 09                	je     80100b69 <consoleintr+0x279>
80100b60:	83 f8 04             	cmp    $0x4,%eax
80100b63:	0f 85 54 fe ff ff    	jne    801009bd <consoleintr+0xcd>
          input.w = input.e;
80100b69:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b6e:	e9 5e fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
80100b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <consoleinit>:

void
consoleinit(void)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b86:	68 a8 75 10 80       	push   $0x801075a8
80100b8b:	68 20 ef 10 80       	push   $0x8010ef20
80100b90:	e8 cb 3a 00 00       	call   80104660 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b95:	58                   	pop    %eax
80100b96:	5a                   	pop    %edx
80100b97:	6a 00                	push   $0x0
80100b99:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b9b:	c7 05 0c f9 10 80 40 	movl   $0x80100540,0x8010f90c
80100ba2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba5:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100bac:	02 10 80 
  cons.locking = 1;
80100baf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100bb6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bb9:	e8 f2 19 00 00       	call   801025b0 <ioapicenable>
}
80100bbe:	83 c4 10             	add    $0x10,%esp
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    
80100bc3:	66 90                	xchg   %ax,%ax
80100bc5:	66 90                	xchg   %ax,%ax
80100bc7:	66 90                	xchg   %ax,%ax
80100bc9:	66 90                	xchg   %ax,%ax
80100bcb:	66 90                	xchg   %ax,%ax
80100bcd:	66 90                	xchg   %ax,%ax
80100bcf:	90                   	nop

80100bd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	57                   	push   %edi
80100bd4:	56                   	push   %esi
80100bd5:	53                   	push   %ebx
80100bd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bdc:	e8 cf 2e 00 00       	call   80103ab0 <myproc>
80100be1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100be7:	e8 a4 22 00 00       	call   80102e90 <begin_op>

  if((ip = namei(path)) == 0){
80100bec:	83 ec 0c             	sub    $0xc,%esp
80100bef:	ff 75 08             	pushl  0x8(%ebp)
80100bf2:	e8 d9 15 00 00       	call   801021d0 <namei>
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	85 c0                	test   %eax,%eax
80100bfc:	0f 84 02 03 00 00    	je     80100f04 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	89 c3                	mov    %eax,%ebx
80100c07:	50                   	push   %eax
80100c08:	e8 a3 0c 00 00       	call   801018b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c13:	6a 34                	push   $0x34
80100c15:	6a 00                	push   $0x0
80100c17:	50                   	push   %eax
80100c18:	53                   	push   %ebx
80100c19:	e8 a2 0f 00 00       	call   80101bc0 <readi>
80100c1e:	83 c4 20             	add    $0x20,%esp
80100c21:	83 f8 34             	cmp    $0x34,%eax
80100c24:	74 22                	je     80100c48 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	53                   	push   %ebx
80100c2a:	e8 11 0f 00 00       	call   80101b40 <iunlockput>
    end_op();
80100c2f:	e8 cc 22 00 00       	call   80102f00 <end_op>
80100c34:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c3f:	5b                   	pop    %ebx
80100c40:	5e                   	pop    %esi
80100c41:	5f                   	pop    %edi
80100c42:	5d                   	pop    %ebp
80100c43:	c3                   	ret    
80100c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c48:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c4f:	45 4c 46 
80100c52:	75 d2                	jne    80100c26 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c54:	e8 97 65 00 00       	call   801071f0 <setupkvm>
80100c59:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c5f:	85 c0                	test   %eax,%eax
80100c61:	74 c3                	je     80100c26 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c63:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c6a:	00 
80100c6b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c71:	0f 84 ac 02 00 00    	je     80100f23 <exec+0x353>
  sz = 0;
80100c77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c7e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	31 ff                	xor    %edi,%edi
80100c83:	e9 8e 00 00 00       	jmp    80100d16 <exec+0x146>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100c90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c97:	75 6c                	jne    80100d05 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100c99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ca5:	0f 82 87 00 00 00    	jb     80100d32 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cb1:	72 7f                	jb     80100d32 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb3:	83 ec 04             	sub    $0x4,%esp
80100cb6:	50                   	push   %eax
80100cb7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cbd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cc3:	e8 48 63 00 00       	call   80107010 <allocuvm>
80100cc8:	83 c4 10             	add    $0x10,%esp
80100ccb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100cd1:	85 c0                	test   %eax,%eax
80100cd3:	74 5d                	je     80100d32 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100cd5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cdb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ce0:	75 50                	jne    80100d32 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce2:	83 ec 0c             	sub    $0xc,%esp
80100ce5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ceb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cf1:	53                   	push   %ebx
80100cf2:	50                   	push   %eax
80100cf3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf9:	e8 22 62 00 00       	call   80106f20 <loaduvm>
80100cfe:	83 c4 20             	add    $0x20,%esp
80100d01:	85 c0                	test   %eax,%eax
80100d03:	78 2d                	js     80100d32 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d05:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d0c:	83 c7 01             	add    $0x1,%edi
80100d0f:	83 c6 20             	add    $0x20,%esi
80100d12:	39 f8                	cmp    %edi,%eax
80100d14:	7e 3a                	jle    80100d50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d16:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d1c:	6a 20                	push   $0x20
80100d1e:	56                   	push   %esi
80100d1f:	50                   	push   %eax
80100d20:	53                   	push   %ebx
80100d21:	e8 9a 0e 00 00       	call   80101bc0 <readi>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	83 f8 20             	cmp    $0x20,%eax
80100d2c:	0f 84 5e ff ff ff    	je     80100c90 <exec+0xc0>
    freevm(pgdir);
80100d32:	83 ec 0c             	sub    $0xc,%esp
80100d35:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3b:	e8 30 64 00 00       	call   80107170 <freevm>
  if(ip){
80100d40:	83 c4 10             	add    $0x10,%esp
80100d43:	e9 de fe ff ff       	jmp    80100c26 <exec+0x56>
80100d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d4f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d50:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d56:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d5c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d62:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	53                   	push   %ebx
80100d6c:	e8 cf 0d 00 00       	call   80101b40 <iunlockput>
  end_op();
80100d71:	e8 8a 21 00 00       	call   80102f00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d76:	83 c4 0c             	add    $0xc,%esp
80100d79:	56                   	push   %esi
80100d7a:	57                   	push   %edi
80100d7b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d81:	57                   	push   %edi
80100d82:	e8 89 62 00 00       	call   80107010 <allocuvm>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	89 c6                	mov    %eax,%esi
80100d8c:	85 c0                	test   %eax,%eax
80100d8e:	0f 84 94 00 00 00    	je     80100e28 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d94:	83 ec 08             	sub    $0x8,%esp
80100d97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100d9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9f:	50                   	push   %eax
80100da0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100da1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da3:	e8 e8 64 00 00       	call   80107290 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100db4:	8b 00                	mov    (%eax),%eax
80100db6:	85 c0                	test   %eax,%eax
80100db8:	0f 84 8b 00 00 00    	je     80100e49 <exec+0x279>
80100dbe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dca:	eb 23                	jmp    80100def <exec+0x21f>
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100dd3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dda:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ddd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100de3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100de6:	85 c0                	test   %eax,%eax
80100de8:	74 59                	je     80100e43 <exec+0x273>
    if(argc >= MAXARG)
80100dea:	83 ff 20             	cmp    $0x20,%edi
80100ded:	74 39                	je     80100e28 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	50                   	push   %eax
80100df3:	e8 e8 3c 00 00       	call   80104ae0 <strlen>
80100df8:	f7 d0                	not    %eax
80100dfa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfc:	58                   	pop    %eax
80100dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e00:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e03:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e06:	e8 d5 3c 00 00       	call   80104ae0 <strlen>
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	50                   	push   %eax
80100e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e12:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e15:	53                   	push   %ebx
80100e16:	56                   	push   %esi
80100e17:	e8 34 66 00 00       	call   80107450 <copyout>
80100e1c:	83 c4 20             	add    $0x20,%esp
80100e1f:	85 c0                	test   %eax,%eax
80100e21:	79 ad                	jns    80100dd0 <exec+0x200>
80100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e27:	90                   	nop
    freevm(pgdir);
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e31:	e8 3a 63 00 00       	call   80107170 <freevm>
80100e36:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3e:	e9 f9 fd ff ff       	jmp    80100c3c <exec+0x6c>
80100e43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e49:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e50:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e52:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e59:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e5f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e62:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e68:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6a:	50                   	push   %eax
80100e6b:	52                   	push   %edx
80100e6c:	53                   	push   %ebx
80100e6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e73:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e7a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e7d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e83:	e8 c8 65 00 00       	call   80107450 <copyout>
80100e88:	83 c4 10             	add    $0x10,%esp
80100e8b:	85 c0                	test   %eax,%eax
80100e8d:	78 99                	js     80100e28 <exec+0x258>
  for(last=s=path; *s; s++)
80100e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e92:	8b 55 08             	mov    0x8(%ebp),%edx
80100e95:	0f b6 00             	movzbl (%eax),%eax
80100e98:	84 c0                	test   %al,%al
80100e9a:	74 13                	je     80100eaf <exec+0x2df>
80100e9c:	89 d1                	mov    %edx,%ecx
80100e9e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100ea0:	83 c1 01             	add    $0x1,%ecx
80100ea3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100ea5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100ea8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100eab:	84 c0                	test   %al,%al
80100ead:	75 f1                	jne    80100ea0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100eaf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100eb5:	83 ec 04             	sub    $0x4,%esp
80100eb8:	6a 10                	push   $0x10
80100eba:	89 f8                	mov    %edi,%eax
80100ebc:	52                   	push   %edx
80100ebd:	83 c0 6c             	add    $0x6c,%eax
80100ec0:	50                   	push   %eax
80100ec1:	e8 da 3b 00 00       	call   80104aa0 <safestrcpy>
  curproc->pgdir = pgdir;
80100ec6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100ecc:	89 f8                	mov    %edi,%eax
80100ece:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ed1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ed3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ed6:	89 c1                	mov    %eax,%ecx
80100ed8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ee4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ee7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100eea:	89 0c 24             	mov    %ecx,(%esp)
80100eed:	e8 9e 5e 00 00       	call   80106d90 <switchuvm>
  freevm(oldpgdir);
80100ef2:	89 3c 24             	mov    %edi,(%esp)
80100ef5:	e8 76 62 00 00       	call   80107170 <freevm>
  return 0;
80100efa:	83 c4 10             	add    $0x10,%esp
80100efd:	31 c0                	xor    %eax,%eax
80100eff:	e9 38 fd ff ff       	jmp    80100c3c <exec+0x6c>
    end_op();
80100f04:	e8 f7 1f 00 00       	call   80102f00 <end_op>
    cprintf("exec: fail\n");
80100f09:	83 ec 0c             	sub    $0xc,%esp
80100f0c:	68 c1 75 10 80       	push   $0x801075c1
80100f11:	e8 6a f7 ff ff       	call   80100680 <cprintf>
    return -1;
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1e:	e9 19 fd ff ff       	jmp    80100c3c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f23:	31 ff                	xor    %edi,%edi
80100f25:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2a:	e9 39 fe ff ff       	jmp    80100d68 <exec+0x198>
80100f2f:	90                   	nop

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	68 cd 75 10 80       	push   $0x801075cd
80100f3b:	68 60 ef 10 80       	push   $0x8010ef60
80100f40:	e8 1b 37 00 00       	call   80104660 <initlock>
}
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f54:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100f59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f5c:	68 60 ef 10 80       	push   $0x8010ef60
80100f61:	e8 0a 38 00 00       	call   80104770 <acquire>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb 10                	jmp    80100f7b <filealloc+0x2b>
80100f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f70:	83 c3 18             	add    $0x18,%ebx
80100f73:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100f79:	74 25                	je     80100fa0 <filealloc+0x50>
    if(f->ref == 0){
80100f7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	75 ee                	jne    80100f70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f8c:	68 60 ef 10 80       	push   $0x8010ef60
80100f91:	e8 fa 38 00 00       	call   80104890 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f96:	89 d8                	mov    %ebx,%eax
      return f;
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f9e:	c9                   	leave  
80100f9f:	c3                   	ret    
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fa3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fa5:	68 60 ef 10 80       	push   $0x8010ef60
80100faa:	e8 e1 38 00 00       	call   80104890 <release>
}
80100faf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fb1:	83 c4 10             	add    $0x10,%esp
}
80100fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb7:	c9                   	leave  
80100fb8:	c3                   	ret    
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fca:	68 60 ef 10 80       	push   $0x8010ef60
80100fcf:	e8 9c 37 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80100fd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	7e 1a                	jle    80100ff8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fe1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fe4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fe7:	68 60 ef 10 80       	push   $0x8010ef60
80100fec:	e8 9f 38 00 00       	call   80104890 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 d4 75 10 80       	push   $0x801075d4
80101000:	e8 7b f3 ff ff       	call   80100380 <panic>
80101005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 28             	sub    $0x28,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010101c:	68 60 ef 10 80       	push   $0x8010ef60
80101021:	e8 4a 37 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80101026:	8b 53 04             	mov    0x4(%ebx),%edx
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	85 d2                	test   %edx,%edx
8010102e:	0f 8e a5 00 00 00    	jle    801010d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101034:	83 ea 01             	sub    $0x1,%edx
80101037:	89 53 04             	mov    %edx,0x4(%ebx)
8010103a:	75 44                	jne    80101080 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010103c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101040:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101043:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101045:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010104b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010104e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101051:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101054:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80101059:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010105c:	e8 2f 38 00 00       	call   80104890 <release>

  if(ff.type == FD_PIPE)
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	83 ff 01             	cmp    $0x1,%edi
80101067:	74 57                	je     801010c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101069:	83 ff 02             	cmp    $0x2,%edi
8010106c:	74 2a                	je     80101098 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
80101075:	c3                   	ret    
80101076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101080:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010108e:	e9 fd 37 00 00       	jmp    80104890 <release>
80101093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101097:	90                   	nop
    begin_op();
80101098:	e8 f3 1d 00 00       	call   80102e90 <begin_op>
    iput(ff.ip);
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	ff 75 e0             	pushl  -0x20(%ebp)
801010a3:	e8 38 09 00 00       	call   801019e0 <iput>
    end_op();
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ae:	5b                   	pop    %ebx
801010af:	5e                   	pop    %esi
801010b0:	5f                   	pop    %edi
801010b1:	5d                   	pop    %ebp
    end_op();
801010b2:	e9 49 1e 00 00       	jmp    80102f00 <end_op>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010c4:	83 ec 08             	sub    $0x8,%esp
801010c7:	53                   	push   %ebx
801010c8:	56                   	push   %esi
801010c9:	e8 92 25 00 00       	call   80103660 <pipeclose>
801010ce:	83 c4 10             	add    $0x10,%esp
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
    panic("fileclose");
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 dc 75 10 80       	push   $0x801075dc
801010e1:	e8 9a f2 ff ff       	call   80100380 <panic>
801010e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ed:	8d 76 00             	lea    0x0(%esi),%esi

801010f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
801010f4:	83 ec 04             	sub    $0x4,%esp
801010f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801010fd:	75 31                	jne    80101130 <filestat+0x40>
    ilock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 73 10             	pushl  0x10(%ebx)
80101105:	e8 a6 07 00 00       	call   801018b0 <ilock>
    stati(f->ip, st);
8010110a:	58                   	pop    %eax
8010110b:	5a                   	pop    %edx
8010110c:	ff 75 0c             	pushl  0xc(%ebp)
8010110f:	ff 73 10             	pushl  0x10(%ebx)
80101112:	e8 79 0a 00 00       	call   80101b90 <stati>
    iunlock(f->ip);
80101117:	59                   	pop    %ecx
80101118:	ff 73 10             	pushl  0x10(%ebx)
8010111b:	e8 70 08 00 00       	call   80101990 <iunlock>
    return 0;
  }
  return -1;
}
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	31 c0                	xor    %eax,%eax
}
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010114f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101152:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101156:	74 60                	je     801011b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101158:	8b 03                	mov    (%ebx),%eax
8010115a:	83 f8 01             	cmp    $0x1,%eax
8010115d:	74 41                	je     801011a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010115f:	83 f8 02             	cmp    $0x2,%eax
80101162:	75 5b                	jne    801011bf <fileread+0x7f>
    ilock(f->ip);
80101164:	83 ec 0c             	sub    $0xc,%esp
80101167:	ff 73 10             	pushl  0x10(%ebx)
8010116a:	e8 41 07 00 00       	call   801018b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116f:	57                   	push   %edi
80101170:	ff 73 14             	pushl  0x14(%ebx)
80101173:	56                   	push   %esi
80101174:	ff 73 10             	pushl  0x10(%ebx)
80101177:	e8 44 0a 00 00       	call   80101bc0 <readi>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	89 c6                	mov    %eax,%esi
80101181:	85 c0                	test   %eax,%eax
80101183:	7e 03                	jle    80101188 <fileread+0x48>
      f->off += r;
80101185:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101188:	83 ec 0c             	sub    $0xc,%esp
8010118b:	ff 73 10             	pushl  0x10(%ebx)
8010118e:	e8 fd 07 00 00       	call   80101990 <iunlock>
    return r;
80101193:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	89 f0                	mov    %esi,%eax
8010119b:	5b                   	pop    %ebx
8010119c:	5e                   	pop    %esi
8010119d:	5f                   	pop    %edi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	5b                   	pop    %ebx
801011aa:	5e                   	pop    %esi
801011ab:	5f                   	pop    %edi
801011ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011ad:	e9 4e 26 00 00       	jmp    80103800 <piperead>
801011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011bd:	eb d7                	jmp    80101196 <fileread+0x56>
  panic("fileread");
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	68 e6 75 10 80       	push   $0x801075e6
801011c7:	e8 b4 f1 ff ff       	call   80100380 <panic>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 1c             	sub    $0x1c,%esp
801011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011dc:	8b 75 08             	mov    0x8(%ebp),%esi
801011df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011e5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011ec:	0f 84 bd 00 00 00    	je     801012af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011f2:	8b 06                	mov    (%esi),%eax
801011f4:	83 f8 01             	cmp    $0x1,%eax
801011f7:	0f 84 bf 00 00 00    	je     801012bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011fd:	83 f8 02             	cmp    $0x2,%eax
80101200:	0f 85 c8 00 00 00    	jne    801012ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101209:	31 ff                	xor    %edi,%edi
    while(i < n){
8010120b:	85 c0                	test   %eax,%eax
8010120d:	7f 30                	jg     8010123f <filewrite+0x6f>
8010120f:	e9 94 00 00 00       	jmp    801012a8 <filewrite+0xd8>
80101214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101218:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101221:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101224:	e8 67 07 00 00       	call   80101990 <iunlock>
      end_op();
80101229:	e8 d2 1c 00 00       	call   80102f00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010122e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101231:	83 c4 10             	add    $0x10,%esp
80101234:	39 c3                	cmp    %eax,%ebx
80101236:	75 60                	jne    80101298 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101238:	01 df                	add    %ebx,%edi
    while(i < n){
8010123a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010123d:	7e 69                	jle    801012a8 <filewrite+0xd8>
      int n1 = n - i;
8010123f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101242:	b8 00 06 00 00       	mov    $0x600,%eax
80101247:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101249:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010124f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101252:	e8 39 1c 00 00       	call   80102e90 <begin_op>
      ilock(f->ip);
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	ff 76 10             	pushl  0x10(%esi)
8010125d:	e8 4e 06 00 00       	call   801018b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101262:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101265:	53                   	push   %ebx
80101266:	ff 76 14             	pushl  0x14(%esi)
80101269:	01 f8                	add    %edi,%eax
8010126b:	50                   	push   %eax
8010126c:	ff 76 10             	pushl  0x10(%esi)
8010126f:	e8 4c 0a 00 00       	call   80101cc0 <writei>
80101274:	83 c4 20             	add    $0x20,%esp
80101277:	85 c0                	test   %eax,%eax
80101279:	7f 9d                	jg     80101218 <filewrite+0x48>
      iunlock(f->ip);
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	ff 76 10             	pushl  0x10(%esi)
80101281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101284:	e8 07 07 00 00       	call   80101990 <iunlock>
      end_op();
80101289:	e8 72 1c 00 00       	call   80102f00 <end_op>
      if(r < 0)
8010128e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	85 c0                	test   %eax,%eax
80101296:	75 17                	jne    801012af <filewrite+0xdf>
        panic("short filewrite");
80101298:	83 ec 0c             	sub    $0xc,%esp
8010129b:	68 ef 75 10 80       	push   $0x801075ef
801012a0:	e8 db f0 ff ff       	call   80100380 <panic>
801012a5:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012a8:	89 f8                	mov    %edi,%eax
801012aa:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012ad:	74 05                	je     801012b4 <filewrite+0xe4>
801012af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b7:	5b                   	pop    %ebx
801012b8:	5e                   	pop    %esi
801012b9:	5f                   	pop    %edi
801012ba:	5d                   	pop    %ebp
801012bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012bc:	8b 46 0c             	mov    0xc(%esi),%eax
801012bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c5:	5b                   	pop    %ebx
801012c6:	5e                   	pop    %esi
801012c7:	5f                   	pop    %edi
801012c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012c9:	e9 32 24 00 00       	jmp    80103700 <pipewrite>
  panic("filewrite");
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	68 f5 75 10 80       	push   $0x801075f5
801012d6:	e8 a5 f0 ff ff       	call   80100380 <panic>
801012db:	66 90                	xchg   %ax,%ax
801012dd:	66 90                	xchg   %ax,%ax
801012df:	90                   	nop

801012e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012e9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801012ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012f2:	85 c9                	test   %ecx,%ecx
801012f4:	0f 84 87 00 00 00    	je     80101381 <balloc+0xa1>
801012fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101301:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101304:	83 ec 08             	sub    $0x8,%esp
80101307:	89 f0                	mov    %esi,%eax
80101309:	c1 f8 0c             	sar    $0xc,%eax
8010130c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101312:	50                   	push   %eax
80101313:	ff 75 d8             	pushl  -0x28(%ebp)
80101316:	e8 b5 ed ff ff       	call   801000d0 <bread>
8010131b:	83 c4 10             	add    $0x10,%esp
8010131e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101321:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101329:	31 c0                	xor    %eax,%eax
8010132b:	eb 2f                	jmp    8010135c <balloc+0x7c>
8010132d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101330:	89 c1                	mov    %eax,%ecx
80101332:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010133a:	83 e1 07             	and    $0x7,%ecx
8010133d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010133f:	89 c1                	mov    %eax,%ecx
80101341:	c1 f9 03             	sar    $0x3,%ecx
80101344:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101349:	89 fa                	mov    %edi,%edx
8010134b:	85 df                	test   %ebx,%edi
8010134d:	74 41                	je     80101390 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010134f:	83 c0 01             	add    $0x1,%eax
80101352:	83 c6 01             	add    $0x1,%esi
80101355:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010135a:	74 05                	je     80101361 <balloc+0x81>
8010135c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010135f:	77 cf                	ja     80101330 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	ff 75 e4             	pushl  -0x1c(%ebp)
80101367:	e8 84 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010136c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101373:	83 c4 10             	add    $0x10,%esp
80101376:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101379:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010137f:	77 80                	ja     80101301 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	68 ff 75 10 80       	push   $0x801075ff
80101389:	e8 f2 ef ff ff       	call   80100380 <panic>
8010138e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101393:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101396:	09 da                	or     %ebx,%edx
80101398:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010139c:	57                   	push   %edi
8010139d:	e8 ce 1c 00 00       	call   80103070 <log_write>
        brelse(bp);
801013a2:	89 3c 24             	mov    %edi,(%esp)
801013a5:	e8 46 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801013aa:	58                   	pop    %eax
801013ab:	5a                   	pop    %edx
801013ac:	56                   	push   %esi
801013ad:	ff 75 d8             	pushl  -0x28(%ebp)
801013b0:	e8 1b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801013b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801013bd:	68 00 02 00 00       	push   $0x200
801013c2:	6a 00                	push   $0x0
801013c4:	50                   	push   %eax
801013c5:	e8 16 35 00 00       	call   801048e0 <memset>
  log_write(bp);
801013ca:	89 1c 24             	mov    %ebx,(%esp)
801013cd:	e8 9e 1c 00 00       	call   80103070 <log_write>
  brelse(bp);
801013d2:	89 1c 24             	mov    %ebx,(%esp)
801013d5:	e8 16 ee ff ff       	call   801001f0 <brelse>
}
801013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013dd:	89 f0                	mov    %esi,%eax
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5f                   	pop    %edi
801013e2:	5d                   	pop    %ebp
801013e3:	c3                   	ret    
801013e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop

801013f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 c7                	mov    %eax,%edi
801013f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013f7:	31 f6                	xor    %esi,%esi
{
801013f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013fa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801013ff:	83 ec 28             	sub    $0x28,%esp
80101402:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101405:	68 60 f9 10 80       	push   $0x8010f960
8010140a:	e8 61 33 00 00       	call   80104770 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	eb 1b                	jmp    80101432 <iget+0x42>
80101417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010141e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101420:	39 3b                	cmp    %edi,(%ebx)
80101422:	74 6c                	je     80101490 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101424:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101430:	73 26                	jae    80101458 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101432:	8b 43 08             	mov    0x8(%ebx),%eax
80101435:	85 c0                	test   %eax,%eax
80101437:	7f e7                	jg     80101420 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101439:	85 f6                	test   %esi,%esi
8010143b:	75 e7                	jne    80101424 <iget+0x34>
8010143d:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010143f:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101445:	85 c0                	test   %eax,%eax
80101447:	75 6e                	jne    801014b7 <iget+0xc7>
80101449:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010144b:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101451:	72 df                	jb     80101432 <iget+0x42>
80101453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101457:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101458:	85 f6                	test   %esi,%esi
8010145a:	74 73                	je     801014cf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010145c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010145f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101461:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101464:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010146b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101472:	68 60 f9 10 80       	push   $0x8010f960
80101477:	e8 14 34 00 00       	call   80104890 <release>

  return ip;
8010147c:	83 c4 10             	add    $0x10,%esp
}
8010147f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101482:	89 f0                	mov    %esi,%eax
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
80101489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101490:	39 53 04             	cmp    %edx,0x4(%ebx)
80101493:	75 8f                	jne    80101424 <iget+0x34>
      release(&icache.lock);
80101495:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101498:	83 c0 01             	add    $0x1,%eax
      return ip;
8010149b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010149d:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
801014a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801014a5:	e8 e6 33 00 00       	call   80104890 <release>
      return ip;
801014aa:	83 c4 10             	add    $0x10,%esp
}
801014ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b0:	89 f0                	mov    %esi,%eax
801014b2:	5b                   	pop    %ebx
801014b3:	5e                   	pop    %esi
801014b4:	5f                   	pop    %edi
801014b5:	5d                   	pop    %ebp
801014b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b7:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801014bd:	73 10                	jae    801014cf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014bf:	8b 43 08             	mov    0x8(%ebx),%eax
801014c2:	85 c0                	test   %eax,%eax
801014c4:	0f 8f 56 ff ff ff    	jg     80101420 <iget+0x30>
801014ca:	e9 6e ff ff ff       	jmp    8010143d <iget+0x4d>
    panic("iget: no inodes");
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	68 15 76 10 80       	push   $0x80107615
801014d7:	e8 a4 ee ff ff       	call   80100380 <panic>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 8c 00 00 00    	jbe    80101580 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 a2 00 00 00    	ja     801015a2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
80101506:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
80101508:	85 c0                	test   %eax,%eax
8010150a:	74 5c                	je     80101568 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	50                   	push   %eax
80101510:	52                   	push   %edx
80101511:	e8 ba eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010151d:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010151f:	8b 3b                	mov    (%ebx),%edi
80101521:	85 ff                	test   %edi,%edi
80101523:	74 1b                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101525:	83 ec 0c             	sub    $0xc,%esp
80101528:	52                   	push   %edx
80101529:	e8 c2 ec ff ff       	call   801001f0 <brelse>
8010152e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101534:	89 f8                	mov    %edi,%eax
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5f                   	pop    %edi
80101539:	5d                   	pop    %ebp
8010153a:	c3                   	ret    
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
80101540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 96 fd ff ff       	call   801012e0 <balloc>
      log_write(bp);
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 03                	mov    %eax,(%ebx)
80101552:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101554:	52                   	push   %edx
80101555:	e8 16 1b 00 00       	call   80103070 <log_write>
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 c4 10             	add    $0x10,%esp
80101560:	eb c3                	jmp    80101525 <bmap+0x45>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101568:	89 d0                	mov    %edx,%eax
8010156a:	e8 71 fd ff ff       	call   801012e0 <balloc>
    bp = bread(ip->dev, addr);
8010156f:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101571:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101577:	eb 93                	jmp    8010150c <bmap+0x2c>
80101579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101580:	8d 5a 14             	lea    0x14(%edx),%ebx
80101583:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101587:	85 ff                	test   %edi,%edi
80101589:	75 a6                	jne    80101531 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010158b:	8b 00                	mov    (%eax),%eax
8010158d:	e8 4e fd ff ff       	call   801012e0 <balloc>
80101592:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101596:	89 c7                	mov    %eax,%edi
}
80101598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159b:	5b                   	pop    %ebx
8010159c:	89 f8                	mov    %edi,%eax
8010159e:	5e                   	pop    %esi
8010159f:	5f                   	pop    %edi
801015a0:	5d                   	pop    %ebp
801015a1:	c3                   	ret    
  panic("bmap: out of range");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 25 76 10 80       	push   $0x80107625
801015aa:	e8 d1 ed ff ff       	call   80100380 <panic>
801015af:	90                   	nop

801015b0 <bfree>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	89 c6                	mov    %eax,%esi
801015b7:	53                   	push   %ebx
801015b8:	89 d3                	mov    %edx,%ebx
801015ba:	83 ec 14             	sub    $0x14,%esp
  bp = bread(dev, 1);
801015bd:	6a 01                	push   $0x1
801015bf:	50                   	push   %eax
801015c0:	e8 0b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015c8:	89 c7                	mov    %eax,%edi
  memmove(sb, bp->data, sizeof(*sb));
801015ca:	83 c0 5c             	add    $0x5c,%eax
801015cd:	6a 1c                	push   $0x1c
801015cf:	50                   	push   %eax
801015d0:	68 b4 15 11 80       	push   $0x801115b4
801015d5:	e8 a6 33 00 00       	call   80104980 <memmove>
  brelse(bp);
801015da:	89 3c 24             	mov    %edi,(%esp)
801015dd:	e8 0e ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, BBLOCK(b, sb));
801015e2:	58                   	pop    %eax
801015e3:	89 d8                	mov    %ebx,%eax
801015e5:	5a                   	pop    %edx
801015e6:	c1 e8 0c             	shr    $0xc,%eax
801015e9:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801015ef:	50                   	push   %eax
801015f0:	56                   	push   %esi
801015f1:	e8 da ea ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801015f6:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801015f8:	c1 fb 03             	sar    $0x3,%ebx
801015fb:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015fe:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101600:	83 e1 07             	and    $0x7,%ecx
80101603:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101608:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
8010160e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101610:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
80101615:	85 c1                	test   %eax,%ecx
80101617:	74 24                	je     8010163d <bfree+0x8d>
  bp->data[bi/8] &= ~m;
80101619:	f7 d0                	not    %eax
  log_write(bp);
8010161b:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
8010161e:	21 c8                	and    %ecx,%eax
80101620:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101624:	56                   	push   %esi
80101625:	e8 46 1a 00 00       	call   80103070 <log_write>
  brelse(bp);
8010162a:	89 34 24             	mov    %esi,(%esp)
8010162d:	e8 be eb ff ff       	call   801001f0 <brelse>
}
80101632:	83 c4 10             	add    $0x10,%esp
80101635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101638:	5b                   	pop    %ebx
80101639:	5e                   	pop    %esi
8010163a:	5f                   	pop    %edi
8010163b:	5d                   	pop    %ebp
8010163c:	c3                   	ret    
    panic("freeing free block");
8010163d:	83 ec 0c             	sub    $0xc,%esp
80101640:	68 38 76 10 80       	push   $0x80107638
80101645:	e8 36 ed ff ff       	call   80100380 <panic>
8010164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101650 <readsb>:
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	6a 01                	push   $0x1
8010165d:	ff 75 08             	pushl  0x8(%ebp)
80101660:	e8 6b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101665:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101668:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010166a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010166d:	6a 1c                	push   $0x1c
8010166f:	50                   	push   %eax
80101670:	56                   	push   %esi
80101671:	e8 0a 33 00 00       	call   80104980 <memmove>
  brelse(bp);
80101676:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101679:	83 c4 10             	add    $0x10,%esp
}
8010167c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010167f:	5b                   	pop    %ebx
80101680:	5e                   	pop    %esi
80101681:	5d                   	pop    %ebp
  brelse(bp);
80101682:	e9 69 eb ff ff       	jmp    801001f0 <brelse>
80101687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168e:	66 90                	xchg   %ax,%ax

80101690 <iinit>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101699:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010169c:	68 4b 76 10 80       	push   $0x8010764b
801016a1:	68 60 f9 10 80       	push   $0x8010f960
801016a6:	e8 b5 2f 00 00       	call   80104660 <initlock>
  for(i = 0; i < NINODE; i++) {
801016ab:	83 c4 10             	add    $0x10,%esp
801016ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801016b0:	83 ec 08             	sub    $0x8,%esp
801016b3:	68 52 76 10 80       	push   $0x80107652
801016b8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801016b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801016bf:	e8 8c 2e 00 00       	call   80104550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016c4:	83 c4 10             	add    $0x10,%esp
801016c7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801016cd:	75 e1                	jne    801016b0 <iinit+0x20>
  bp = bread(dev, 1);
801016cf:	83 ec 08             	sub    $0x8,%esp
801016d2:	6a 01                	push   $0x1
801016d4:	ff 75 08             	pushl  0x8(%ebp)
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016dc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016df:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016e1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016e4:	6a 1c                	push   $0x1c
801016e6:	50                   	push   %eax
801016e7:	68 b4 15 11 80       	push   $0x801115b4
801016ec:	e8 8f 32 00 00       	call   80104980 <memmove>
  brelse(bp);
801016f1:	89 1c 24             	mov    %ebx,(%esp)
801016f4:	e8 f7 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016f9:	ff 35 cc 15 11 80    	pushl  0x801115cc
801016ff:	ff 35 c8 15 11 80    	pushl  0x801115c8
80101705:	ff 35 c4 15 11 80    	pushl  0x801115c4
8010170b:	ff 35 c0 15 11 80    	pushl  0x801115c0
80101711:	ff 35 bc 15 11 80    	pushl  0x801115bc
80101717:	ff 35 b8 15 11 80    	pushl  0x801115b8
8010171d:	ff 35 b4 15 11 80    	pushl  0x801115b4
80101723:	68 b8 76 10 80       	push   $0x801076b8
80101728:	e8 53 ef ff ff       	call   80100680 <cprintf>
}
8010172d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101730:	83 c4 30             	add    $0x30,%esp
80101733:	c9                   	leave  
80101734:	c3                   	ret    
80101735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <ialloc>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	57                   	push   %edi
80101744:	56                   	push   %esi
80101745:	53                   	push   %ebx
80101746:	83 ec 1c             	sub    $0x1c,%esp
80101749:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010174c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101753:	8b 75 08             	mov    0x8(%ebp),%esi
80101756:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101759:	0f 86 91 00 00 00    	jbe    801017f0 <ialloc+0xb0>
8010175f:	bf 01 00 00 00       	mov    $0x1,%edi
80101764:	eb 21                	jmp    80101787 <ialloc+0x47>
80101766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101770:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101773:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101776:	53                   	push   %ebx
80101777:	e8 74 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010177c:	83 c4 10             	add    $0x10,%esp
8010177f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101785:	73 69                	jae    801017f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101787:	89 f8                	mov    %edi,%eax
80101789:	83 ec 08             	sub    $0x8,%esp
8010178c:	c1 e8 03             	shr    $0x3,%eax
8010178f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101795:	50                   	push   %eax
80101796:	56                   	push   %esi
80101797:	e8 34 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010179c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010179f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801017a1:	89 f8                	mov    %edi,%eax
801017a3:	83 e0 07             	and    $0x7,%eax
801017a6:	c1 e0 06             	shl    $0x6,%eax
801017a9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017b1:	75 bd                	jne    80101770 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017b3:	83 ec 04             	sub    $0x4,%esp
801017b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017b9:	6a 40                	push   $0x40
801017bb:	6a 00                	push   $0x0
801017bd:	51                   	push   %ecx
801017be:	e8 1d 31 00 00       	call   801048e0 <memset>
      dip->type = type;
801017c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017cd:	89 1c 24             	mov    %ebx,(%esp)
801017d0:	e8 9b 18 00 00       	call   80103070 <log_write>
      brelse(bp);
801017d5:	89 1c 24             	mov    %ebx,(%esp)
801017d8:	e8 13 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017dd:	83 c4 10             	add    $0x10,%esp
}
801017e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017e3:	89 fa                	mov    %edi,%edx
}
801017e5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017e6:	89 f0                	mov    %esi,%eax
}
801017e8:	5e                   	pop    %esi
801017e9:	5f                   	pop    %edi
801017ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801017eb:	e9 00 fc ff ff       	jmp    801013f0 <iget>
  panic("ialloc: no inodes");
801017f0:	83 ec 0c             	sub    $0xc,%esp
801017f3:	68 58 76 10 80       	push   $0x80107658
801017f8:	e8 83 eb ff ff       	call   80100380 <panic>
801017fd:	8d 76 00             	lea    0x0(%esi),%esi

80101800 <iupdate>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101808:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010180b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180e:	83 ec 08             	sub    $0x8,%esp
80101811:	c1 e8 03             	shr    $0x3,%eax
80101814:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010181a:	50                   	push   %eax
8010181b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010181e:	e8 ad e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101823:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101827:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010182a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010182f:	83 e0 07             	and    $0x7,%eax
80101832:	c1 e0 06             	shl    $0x6,%eax
80101835:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101839:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010183c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101840:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101843:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101847:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010184b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010184f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101853:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101857:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010185a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185d:	6a 34                	push   $0x34
8010185f:	53                   	push   %ebx
80101860:	50                   	push   %eax
80101861:	e8 1a 31 00 00       	call   80104980 <memmove>
  log_write(bp);
80101866:	89 34 24             	mov    %esi,(%esp)
80101869:	e8 02 18 00 00       	call   80103070 <log_write>
  brelse(bp);
8010186e:	89 75 08             	mov    %esi,0x8(%ebp)
80101871:	83 c4 10             	add    $0x10,%esp
}
80101874:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101877:	5b                   	pop    %ebx
80101878:	5e                   	pop    %esi
80101879:	5d                   	pop    %ebp
  brelse(bp);
8010187a:	e9 71 e9 ff ff       	jmp    801001f0 <brelse>
8010187f:	90                   	nop

80101880 <idup>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	53                   	push   %ebx
80101884:	83 ec 10             	sub    $0x10,%esp
80101887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010188a:	68 60 f9 10 80       	push   $0x8010f960
8010188f:	e8 dc 2e 00 00       	call   80104770 <acquire>
  ip->ref++;
80101894:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101898:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010189f:	e8 ec 2f 00 00       	call   80104890 <release>
}
801018a4:	89 d8                	mov    %ebx,%eax
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <ilock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	0f 84 b7 00 00 00    	je     80101977 <ilock+0xc7>
801018c0:	8b 53 08             	mov    0x8(%ebx),%edx
801018c3:	85 d2                	test   %edx,%edx
801018c5:	0f 8e ac 00 00 00    	jle    80101977 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018cb:	83 ec 0c             	sub    $0xc,%esp
801018ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801018d1:	50                   	push   %eax
801018d2:	e8 b9 2c 00 00       	call   80104590 <acquiresleep>
  if(ip->valid == 0){
801018d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	85 c0                	test   %eax,%eax
801018df:	74 0f                	je     801018f0 <ilock+0x40>
}
801018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e4:	5b                   	pop    %ebx
801018e5:	5e                   	pop    %esi
801018e6:	5d                   	pop    %ebp
801018e7:	c3                   	ret    
801018e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018f0:	8b 43 04             	mov    0x4(%ebx),%eax
801018f3:	83 ec 08             	sub    $0x8,%esp
801018f6:	c1 e8 03             	shr    $0x3,%eax
801018f9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801018ff:	50                   	push   %eax
80101900:	ff 33                	pushl  (%ebx)
80101902:	e8 c9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101907:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010190a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010190c:	8b 43 04             	mov    0x4(%ebx),%eax
8010190f:	83 e0 07             	and    $0x7,%eax
80101912:	c1 e0 06             	shl    $0x6,%eax
80101915:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101919:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010191f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101923:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101927:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010192b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010192f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101933:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101937:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010193b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010193e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101941:	6a 34                	push   $0x34
80101943:	50                   	push   %eax
80101944:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101947:	50                   	push   %eax
80101948:	e8 33 30 00 00       	call   80104980 <memmove>
    brelse(bp);
8010194d:	89 34 24             	mov    %esi,(%esp)
80101950:	e8 9b e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101955:	83 c4 10             	add    $0x10,%esp
80101958:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010195d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101964:	0f 85 77 ff ff ff    	jne    801018e1 <ilock+0x31>
      panic("ilock: no type");
8010196a:	83 ec 0c             	sub    $0xc,%esp
8010196d:	68 70 76 10 80       	push   $0x80107670
80101972:	e8 09 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101977:	83 ec 0c             	sub    $0xc,%esp
8010197a:	68 6a 76 10 80       	push   $0x8010766a
8010197f:	e8 fc e9 ff ff       	call   80100380 <panic>
80101984:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010198f:	90                   	nop

80101990 <iunlock>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101998:	85 db                	test   %ebx,%ebx
8010199a:	74 28                	je     801019c4 <iunlock+0x34>
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	8d 73 0c             	lea    0xc(%ebx),%esi
801019a2:	56                   	push   %esi
801019a3:	e8 88 2c 00 00       	call   80104630 <holdingsleep>
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	85 c0                	test   %eax,%eax
801019ad:	74 15                	je     801019c4 <iunlock+0x34>
801019af:	8b 43 08             	mov    0x8(%ebx),%eax
801019b2:	85 c0                	test   %eax,%eax
801019b4:	7e 0e                	jle    801019c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019bc:	5b                   	pop    %ebx
801019bd:	5e                   	pop    %esi
801019be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019bf:	e9 2c 2c 00 00       	jmp    801045f0 <releasesleep>
    panic("iunlock");
801019c4:	83 ec 0c             	sub    $0xc,%esp
801019c7:	68 7f 76 10 80       	push   $0x8010767f
801019cc:	e8 af e9 ff ff       	call   80100380 <panic>
801019d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019df:	90                   	nop

801019e0 <iput>:
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 28             	sub    $0x28,%esp
801019e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019ef:	57                   	push   %edi
801019f0:	e8 9b 2b 00 00       	call   80104590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019f8:	83 c4 10             	add    $0x10,%esp
801019fb:	85 d2                	test   %edx,%edx
801019fd:	74 07                	je     80101a06 <iput+0x26>
801019ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a04:	74 32                	je     80101a38 <iput+0x58>
  releasesleep(&ip->lock);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	57                   	push   %edi
80101a0a:	e8 e1 2b 00 00       	call   801045f0 <releasesleep>
  acquire(&icache.lock);
80101a0f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a16:	e8 55 2d 00 00       	call   80104770 <acquire>
  ip->ref--;
80101a1b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a1f:	83 c4 10             	add    $0x10,%esp
80101a22:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2c:	5b                   	pop    %ebx
80101a2d:	5e                   	pop    %esi
80101a2e:	5f                   	pop    %edi
80101a2f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a30:	e9 5b 2e 00 00       	jmp    80104890 <release>
80101a35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a38:	83 ec 0c             	sub    $0xc,%esp
80101a3b:	68 60 f9 10 80       	push   $0x8010f960
80101a40:	e8 2b 2d 00 00       	call   80104770 <acquire>
    int r = ip->ref;
80101a45:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a48:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101a4f:	e8 3c 2e 00 00       	call   80104890 <release>
    if(r == 1){
80101a54:	83 c4 10             	add    $0x10,%esp
80101a57:	83 fe 01             	cmp    $0x1,%esi
80101a5a:	75 aa                	jne    80101a06 <iput+0x26>
80101a5c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a62:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a65:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a68:	89 cf                	mov    %ecx,%edi
80101a6a:	eb 0b                	jmp    80101a77 <iput+0x97>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a70:	83 c6 04             	add    $0x4,%esi
80101a73:	39 fe                	cmp    %edi,%esi
80101a75:	74 19                	je     80101a90 <iput+0xb0>
    if(ip->addrs[i]){
80101a77:	8b 16                	mov    (%esi),%edx
80101a79:	85 d2                	test   %edx,%edx
80101a7b:	74 f3                	je     80101a70 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a7d:	8b 03                	mov    (%ebx),%eax
80101a7f:	e8 2c fb ff ff       	call   801015b0 <bfree>
      ip->addrs[i] = 0;
80101a84:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a8a:	eb e4                	jmp    80101a70 <iput+0x90>
80101a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a90:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a96:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a99:	85 c0                	test   %eax,%eax
80101a9b:	75 2d                	jne    80101aca <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a9d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101aa0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101aa7:	53                   	push   %ebx
80101aa8:	e8 53 fd ff ff       	call   80101800 <iupdate>
      ip->type = 0;
80101aad:	31 c0                	xor    %eax,%eax
80101aaf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101ab3:	89 1c 24             	mov    %ebx,(%esp)
80101ab6:	e8 45 fd ff ff       	call   80101800 <iupdate>
      ip->valid = 0;
80101abb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101ac2:	83 c4 10             	add    $0x10,%esp
80101ac5:	e9 3c ff ff ff       	jmp    80101a06 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aca:	83 ec 08             	sub    $0x8,%esp
80101acd:	50                   	push   %eax
80101ace:	ff 33                	pushl  (%ebx)
80101ad0:	e8 fb e5 ff ff       	call   801000d0 <bread>
80101ad5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ad8:	83 c4 10             	add    $0x10,%esp
80101adb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ae4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ae7:	89 cf                	mov    %ecx,%edi
80101ae9:	eb 0c                	jmp    80101af7 <iput+0x117>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
80101af0:	83 c6 04             	add    $0x4,%esi
80101af3:	39 f7                	cmp    %esi,%edi
80101af5:	74 0f                	je     80101b06 <iput+0x126>
      if(a[j])
80101af7:	8b 16                	mov    (%esi),%edx
80101af9:	85 d2                	test   %edx,%edx
80101afb:	74 f3                	je     80101af0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101afd:	8b 03                	mov    (%ebx),%eax
80101aff:	e8 ac fa ff ff       	call   801015b0 <bfree>
80101b04:	eb ea                	jmp    80101af0 <iput+0x110>
    brelse(bp);
80101b06:	83 ec 0c             	sub    $0xc,%esp
80101b09:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b0f:	e8 dc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b14:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b1a:	8b 03                	mov    (%ebx),%eax
80101b1c:	e8 8f fa ff ff       	call   801015b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b21:	83 c4 10             	add    $0x10,%esp
80101b24:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b2b:	00 00 00 
80101b2e:	e9 6a ff ff ff       	jmp    80101a9d <iput+0xbd>
80101b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b40 <iunlockput>:
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	56                   	push   %esi
80101b44:	53                   	push   %ebx
80101b45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b48:	85 db                	test   %ebx,%ebx
80101b4a:	74 34                	je     80101b80 <iunlockput+0x40>
80101b4c:	83 ec 0c             	sub    $0xc,%esp
80101b4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b52:	56                   	push   %esi
80101b53:	e8 d8 2a 00 00       	call   80104630 <holdingsleep>
80101b58:	83 c4 10             	add    $0x10,%esp
80101b5b:	85 c0                	test   %eax,%eax
80101b5d:	74 21                	je     80101b80 <iunlockput+0x40>
80101b5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b62:	85 c0                	test   %eax,%eax
80101b64:	7e 1a                	jle    80101b80 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b66:	83 ec 0c             	sub    $0xc,%esp
80101b69:	56                   	push   %esi
80101b6a:	e8 81 2a 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101b6f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b72:	83 c4 10             	add    $0x10,%esp
}
80101b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5d                   	pop    %ebp
  iput(ip);
80101b7b:	e9 60 fe ff ff       	jmp    801019e0 <iput>
    panic("iunlock");
80101b80:	83 ec 0c             	sub    $0xc,%esp
80101b83:	68 7f 76 10 80       	push   $0x8010767f
80101b88:	e8 f3 e7 ff ff       	call   80100380 <panic>
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi

80101b90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	8b 55 08             	mov    0x8(%ebp),%edx
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b99:	8b 0a                	mov    (%edx),%ecx
80101b9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ba1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ba4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ba8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101baf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bb3:	8b 52 58             	mov    0x58(%edx),%edx
80101bb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret    
80101bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bd5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101be0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101be3:	0f 84 a7 00 00 00    	je     80101c90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	8b 40 58             	mov    0x58(%eax),%eax
80101bef:	39 c6                	cmp    %eax,%esi
80101bf1:	0f 87 ba 00 00 00    	ja     80101cb1 <readi+0xf1>
80101bf7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bfa:	31 c9                	xor    %ecx,%ecx
80101bfc:	89 da                	mov    %ebx,%edx
80101bfe:	01 f2                	add    %esi,%edx
80101c00:	0f 92 c1             	setb   %cl
80101c03:	89 cf                	mov    %ecx,%edi
80101c05:	0f 82 a6 00 00 00    	jb     80101cb1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c0b:	89 c1                	mov    %eax,%ecx
80101c0d:	29 f1                	sub    %esi,%ecx
80101c0f:	39 d0                	cmp    %edx,%eax
80101c11:	0f 43 cb             	cmovae %ebx,%ecx
80101c14:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c17:	85 c9                	test   %ecx,%ecx
80101c19:	74 67                	je     80101c82 <readi+0xc2>
80101c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	e8 b1 f8 ff ff       	call   801014e0 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 33                	pushl  (%ebx)
80101c35:	e8 96 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c3d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c42:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c45:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c47:	89 f0                	mov    %esi,%eax
80101c49:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c4e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c50:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c53:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c55:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c59:	39 d9                	cmp    %ebx,%ecx
80101c5b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c5e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c5f:	01 df                	add    %ebx,%edi
80101c61:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c63:	50                   	push   %eax
80101c64:	ff 75 e0             	pushl  -0x20(%ebp)
80101c67:	e8 14 2d 00 00       	call   80104980 <memmove>
    brelse(bp);
80101c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c6f:	89 14 24             	mov    %edx,(%esp)
80101c72:	e8 79 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c80:	77 9e                	ja     80101c20 <readi+0x60>
  }
  return n;
80101c82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c88:	5b                   	pop    %ebx
80101c89:	5e                   	pop    %esi
80101c8a:	5f                   	pop    %edi
80101c8b:	5d                   	pop    %ebp
80101c8c:	c3                   	ret    
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 17                	ja     80101cb1 <readi+0xf1>
80101c9a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 0c                	je     80101cb1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ca5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101caf:	ff e0                	jmp    *%eax
      return -1;
80101cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb6:	eb cd                	jmp    80101c85 <readi+0xc5>
80101cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cbf:	90                   	nop

80101cc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ccf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ce3:	0f 84 b7 00 00 00    	je     80101da0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	3b 70 58             	cmp    0x58(%eax),%esi
80101cef:	0f 87 e7 00 00 00    	ja     80101ddc <writei+0x11c>
80101cf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf8:	31 d2                	xor    %edx,%edx
80101cfa:	89 f8                	mov    %edi,%eax
80101cfc:	01 f0                	add    %esi,%eax
80101cfe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d06:	0f 87 d0 00 00 00    	ja     80101ddc <writei+0x11c>
80101d0c:	85 d2                	test   %edx,%edx
80101d0e:	0f 85 c8 00 00 00    	jne    80101ddc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d1b:	85 ff                	test   %edi,%edi
80101d1d:	74 72                	je     80101d91 <writei+0xd1>
80101d1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d23:	89 f2                	mov    %esi,%edx
80101d25:	c1 ea 09             	shr    $0x9,%edx
80101d28:	89 f8                	mov    %edi,%eax
80101d2a:	e8 b1 f7 ff ff       	call   801014e0 <bmap>
80101d2f:	83 ec 08             	sub    $0x8,%esp
80101d32:	50                   	push   %eax
80101d33:	ff 37                	pushl  (%edi)
80101d35:	e8 96 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d3a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d42:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d45:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d47:	89 f0                	mov    %esi,%eax
80101d49:	83 c4 0c             	add    $0xc,%esp
80101d4c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d51:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d57:	39 d9                	cmp    %ebx,%ecx
80101d59:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d5c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d5d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d5f:	ff 75 dc             	pushl  -0x24(%ebp)
80101d62:	50                   	push   %eax
80101d63:	e8 18 2c 00 00       	call   80104980 <memmove>
    log_write(bp);
80101d68:	89 3c 24             	mov    %edi,(%esp)
80101d6b:	e8 00 13 00 00       	call   80103070 <log_write>
    brelse(bp);
80101d70:	89 3c 24             	mov    %edi,(%esp)
80101d73:	e8 78 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d81:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d87:	77 97                	ja     80101d20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d8f:	77 37                	ja     80101dc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret    
80101d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 32                	ja     80101ddc <writei+0x11c>
80101daa:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 27                	je     80101ddc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101db5:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101dbf:	ff e0                	jmp    *%eax
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101dc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101dd1:	50                   	push   %eax
80101dd2:	e8 29 fa ff ff       	call   80101800 <iupdate>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	eb b5                	jmp    80101d91 <writei+0xd1>
      return -1;
80101ddc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de1:	eb b1                	jmp    80101d94 <writei+0xd4>
80101de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101df0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101df6:	6a 0e                	push   $0xe
80101df8:	ff 75 0c             	pushl  0xc(%ebp)
80101dfb:	ff 75 08             	pushl  0x8(%ebp)
80101dfe:	e8 ed 2b 00 00       	call   801049f0 <strncmp>
}
80101e03:	c9                   	leave  
80101e04:	c3                   	ret    
80101e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e21:	0f 85 85 00 00 00    	jne    80101eac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e27:	8b 53 58             	mov    0x58(%ebx),%edx
80101e2a:	31 ff                	xor    %edi,%edi
80101e2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2f:	85 d2                	test   %edx,%edx
80101e31:	74 3e                	je     80101e71 <dirlookup+0x61>
80101e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e37:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 7e fd ff ff       	call   80101bc0 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 55                	jne    80101e9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	74 18                	je     80101e69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e51:	83 ec 04             	sub    $0x4,%esp
80101e54:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e57:	6a 0e                	push   $0xe
80101e59:	50                   	push   %eax
80101e5a:	ff 75 0c             	pushl  0xc(%ebp)
80101e5d:	e8 8e 2b 00 00       	call   801049f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	85 c0                	test   %eax,%eax
80101e67:	74 17                	je     80101e80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e69:	83 c7 10             	add    $0x10,%edi
80101e6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e6f:	72 c7                	jb     80101e38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e74:	31 c0                	xor    %eax,%eax
}
80101e76:	5b                   	pop    %ebx
80101e77:	5e                   	pop    %esi
80101e78:	5f                   	pop    %edi
80101e79:	5d                   	pop    %ebp
80101e7a:	c3                   	ret    
80101e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e7f:	90                   	nop
      if(poff)
80101e80:	8b 45 10             	mov    0x10(%ebp),%eax
80101e83:	85 c0                	test   %eax,%eax
80101e85:	74 05                	je     80101e8c <dirlookup+0x7c>
        *poff = off;
80101e87:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e90:	8b 03                	mov    (%ebx),%eax
80101e92:	e8 59 f5 ff ff       	call   801013f0 <iget>
}
80101e97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e9a:	5b                   	pop    %ebx
80101e9b:	5e                   	pop    %esi
80101e9c:	5f                   	pop    %edi
80101e9d:	5d                   	pop    %ebp
80101e9e:	c3                   	ret    
      panic("dirlookup read");
80101e9f:	83 ec 0c             	sub    $0xc,%esp
80101ea2:	68 99 76 10 80       	push   $0x80107699
80101ea7:	e8 d4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	68 87 76 10 80       	push   $0x80107687
80101eb4:	e8 c7 e4 ff ff       	call   80100380 <panic>
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	89 c3                	mov    %eax,%ebx
80101ec8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ecb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ece:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ed1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101ed4:	0f 84 64 01 00 00    	je     8010203e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eda:	e8 d1 1b 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101edf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ee2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ee5:	68 60 f9 10 80       	push   $0x8010f960
80101eea:	e8 81 28 00 00       	call   80104770 <acquire>
  ip->ref++;
80101eef:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ef3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101efa:	e8 91 29 00 00       	call   80104890 <release>
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	eb 07                	jmp    80101f0b <namex+0x4b>
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f0b:	0f b6 03             	movzbl (%ebx),%eax
80101f0e:	3c 2f                	cmp    $0x2f,%al
80101f10:	74 f6                	je     80101f08 <namex+0x48>
  if(*path == 0)
80101f12:	84 c0                	test   %al,%al
80101f14:	0f 84 06 01 00 00    	je     80102020 <namex+0x160>
  while(*path != '/' && *path != 0)
80101f1a:	0f b6 03             	movzbl (%ebx),%eax
80101f1d:	84 c0                	test   %al,%al
80101f1f:	0f 84 10 01 00 00    	je     80102035 <namex+0x175>
80101f25:	89 df                	mov    %ebx,%edi
80101f27:	3c 2f                	cmp    $0x2f,%al
80101f29:	0f 84 06 01 00 00    	je     80102035 <namex+0x175>
80101f2f:	90                   	nop
80101f30:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f34:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f37:	3c 2f                	cmp    $0x2f,%al
80101f39:	74 04                	je     80101f3f <namex+0x7f>
80101f3b:	84 c0                	test   %al,%al
80101f3d:	75 f1                	jne    80101f30 <namex+0x70>
  len = path - s;
80101f3f:	89 f8                	mov    %edi,%eax
80101f41:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f43:	83 f8 0d             	cmp    $0xd,%eax
80101f46:	0f 8e ac 00 00 00    	jle    80101ff8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f4c:	83 ec 04             	sub    $0x4,%esp
80101f4f:	6a 0e                	push   $0xe
80101f51:	53                   	push   %ebx
    path++;
80101f52:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f54:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f57:	e8 24 2a 00 00       	call   80104980 <memmove>
80101f5c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f5f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f62:	75 0c                	jne    80101f70 <namex+0xb0>
80101f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f6b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f6e:	74 f8                	je     80101f68 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 37 f9 ff ff       	call   801018b0 <ilock>
    if(ip->type != T_DIR){
80101f79:	83 c4 10             	add    $0x10,%esp
80101f7c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f81:	0f 85 cd 00 00 00    	jne    80102054 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	74 09                	je     80101f97 <namex+0xd7>
80101f8e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f91:	0f 84 22 01 00 00    	je     801020b9 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f97:	83 ec 04             	sub    $0x4,%esp
80101f9a:	6a 00                	push   $0x0
80101f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f9f:	56                   	push   %esi
80101fa0:	e8 6b fe ff ff       	call   80101e10 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fa5:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	89 c7                	mov    %eax,%edi
80101fad:	85 c0                	test   %eax,%eax
80101faf:	0f 84 e1 00 00 00    	je     80102096 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fbb:	52                   	push   %edx
80101fbc:	e8 6f 26 00 00       	call   80104630 <holdingsleep>
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	85 c0                	test   %eax,%eax
80101fc6:	0f 84 30 01 00 00    	je     801020fc <namex+0x23c>
80101fcc:	8b 56 08             	mov    0x8(%esi),%edx
80101fcf:	85 d2                	test   %edx,%edx
80101fd1:	0f 8e 25 01 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80101fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fda:	83 ec 0c             	sub    $0xc,%esp
80101fdd:	52                   	push   %edx
80101fde:	e8 0d 26 00 00       	call   801045f0 <releasesleep>
  iput(ip);
80101fe3:	89 34 24             	mov    %esi,(%esp)
80101fe6:	89 fe                	mov    %edi,%esi
80101fe8:	e8 f3 f9 ff ff       	call   801019e0 <iput>
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	e9 16 ff ff ff       	jmp    80101f0b <namex+0x4b>
80101ff5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ff8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ffb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ffe:	83 ec 04             	sub    $0x4,%esp
80102001:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102004:	50                   	push   %eax
80102005:	53                   	push   %ebx
    name[len] = 0;
80102006:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102008:	ff 75 e4             	pushl  -0x1c(%ebp)
8010200b:	e8 70 29 00 00       	call   80104980 <memmove>
    name[len] = 0;
80102010:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102013:	83 c4 10             	add    $0x10,%esp
80102016:	c6 02 00             	movb   $0x0,(%edx)
80102019:	e9 41 ff ff ff       	jmp    80101f5f <namex+0x9f>
8010201e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102020:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102023:	85 c0                	test   %eax,%eax
80102025:	0f 85 be 00 00 00    	jne    801020e9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010202b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010202e:	89 f0                	mov    %esi,%eax
80102030:	5b                   	pop    %ebx
80102031:	5e                   	pop    %esi
80102032:	5f                   	pop    %edi
80102033:	5d                   	pop    %ebp
80102034:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102038:	89 df                	mov    %ebx,%edi
8010203a:	31 c0                	xor    %eax,%eax
8010203c:	eb c0                	jmp    80101ffe <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010203e:	ba 01 00 00 00       	mov    $0x1,%edx
80102043:	b8 01 00 00 00       	mov    $0x1,%eax
80102048:	e8 a3 f3 ff ff       	call   801013f0 <iget>
8010204d:	89 c6                	mov    %eax,%esi
8010204f:	e9 b7 fe ff ff       	jmp    80101f0b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010205a:	53                   	push   %ebx
8010205b:	e8 d0 25 00 00       	call   80104630 <holdingsleep>
80102060:	83 c4 10             	add    $0x10,%esp
80102063:	85 c0                	test   %eax,%eax
80102065:	0f 84 91 00 00 00    	je     801020fc <namex+0x23c>
8010206b:	8b 46 08             	mov    0x8(%esi),%eax
8010206e:	85 c0                	test   %eax,%eax
80102070:	0f 8e 86 00 00 00    	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	53                   	push   %ebx
8010207a:	e8 71 25 00 00       	call   801045f0 <releasesleep>
  iput(ip);
8010207f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102082:	31 f6                	xor    %esi,%esi
  iput(ip);
80102084:	e8 57 f9 ff ff       	call   801019e0 <iput>
      return 0;
80102089:	83 c4 10             	add    $0x10,%esp
}
8010208c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010208f:	89 f0                	mov    %esi,%eax
80102091:	5b                   	pop    %ebx
80102092:	5e                   	pop    %esi
80102093:	5f                   	pop    %edi
80102094:	5d                   	pop    %ebp
80102095:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010209c:	52                   	push   %edx
8010209d:	e8 8e 25 00 00       	call   80104630 <holdingsleep>
801020a2:	83 c4 10             	add    $0x10,%esp
801020a5:	85 c0                	test   %eax,%eax
801020a7:	74 53                	je     801020fc <namex+0x23c>
801020a9:	8b 4e 08             	mov    0x8(%esi),%ecx
801020ac:	85 c9                	test   %ecx,%ecx
801020ae:	7e 4c                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	52                   	push   %edx
801020b7:	eb c1                	jmp    8010207a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801020b9:	83 ec 0c             	sub    $0xc,%esp
801020bc:	8d 5e 0c             	lea    0xc(%esi),%ebx
801020bf:	53                   	push   %ebx
801020c0:	e8 6b 25 00 00       	call   80104630 <holdingsleep>
801020c5:	83 c4 10             	add    $0x10,%esp
801020c8:	85 c0                	test   %eax,%eax
801020ca:	74 30                	je     801020fc <namex+0x23c>
801020cc:	8b 7e 08             	mov    0x8(%esi),%edi
801020cf:	85 ff                	test   %edi,%edi
801020d1:	7e 29                	jle    801020fc <namex+0x23c>
  releasesleep(&ip->lock);
801020d3:	83 ec 0c             	sub    $0xc,%esp
801020d6:	53                   	push   %ebx
801020d7:	e8 14 25 00 00       	call   801045f0 <releasesleep>
}
801020dc:	83 c4 10             	add    $0x10,%esp
}
801020df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e2:	89 f0                	mov    %esi,%eax
801020e4:	5b                   	pop    %ebx
801020e5:	5e                   	pop    %esi
801020e6:	5f                   	pop    %edi
801020e7:	5d                   	pop    %ebp
801020e8:	c3                   	ret    
    iput(ip);
801020e9:	83 ec 0c             	sub    $0xc,%esp
801020ec:	56                   	push   %esi
    return 0;
801020ed:	31 f6                	xor    %esi,%esi
    iput(ip);
801020ef:	e8 ec f8 ff ff       	call   801019e0 <iput>
    return 0;
801020f4:	83 c4 10             	add    $0x10,%esp
801020f7:	e9 2f ff ff ff       	jmp    8010202b <namex+0x16b>
    panic("iunlock");
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	68 7f 76 10 80       	push   $0x8010767f
80102104:	e8 77 e2 ff ff       	call   80100380 <panic>
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <dirlink>:
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 20             	sub    $0x20,%esp
80102119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010211c:	6a 00                	push   $0x0
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	53                   	push   %ebx
80102122:	e8 e9 fc ff ff       	call   80101e10 <dirlookup>
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	85 c0                	test   %eax,%eax
8010212c:	75 67                	jne    80102195 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102131:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102134:	85 ff                	test   %edi,%edi
80102136:	74 29                	je     80102161 <dirlink+0x51>
80102138:	31 ff                	xor    %edi,%edi
8010213a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010213d:	eb 09                	jmp    80102148 <dirlink+0x38>
8010213f:	90                   	nop
80102140:	83 c7 10             	add    $0x10,%edi
80102143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102146:	73 19                	jae    80102161 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102148:	6a 10                	push   $0x10
8010214a:	57                   	push   %edi
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	e8 6e fa ff ff       	call   80101bc0 <readi>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	75 4e                	jne    801021a8 <dirlink+0x98>
    if(de.inum == 0)
8010215a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010215f:	75 df                	jne    80102140 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102161:	83 ec 04             	sub    $0x4,%esp
80102164:	8d 45 da             	lea    -0x26(%ebp),%eax
80102167:	6a 0e                	push   $0xe
80102169:	ff 75 0c             	pushl  0xc(%ebp)
8010216c:	50                   	push   %eax
8010216d:	e8 ce 28 00 00       	call   80104a40 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102172:	6a 10                	push   $0x10
  de.inum = inum;
80102174:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102177:	57                   	push   %edi
80102178:	56                   	push   %esi
80102179:	53                   	push   %ebx
  de.inum = inum;
8010217a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010217e:	e8 3d fb ff ff       	call   80101cc0 <writei>
80102183:	83 c4 20             	add    $0x20,%esp
80102186:	83 f8 10             	cmp    $0x10,%eax
80102189:	75 2a                	jne    801021b5 <dirlink+0xa5>
  return 0;
8010218b:	31 c0                	xor    %eax,%eax
}
8010218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5f                   	pop    %edi
80102193:	5d                   	pop    %ebp
80102194:	c3                   	ret    
    iput(ip);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	50                   	push   %eax
80102199:	e8 42 f8 ff ff       	call   801019e0 <iput>
    return -1;
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a6:	eb e5                	jmp    8010218d <dirlink+0x7d>
      panic("dirlink read");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 a8 76 10 80       	push   $0x801076a8
801021b0:	e8 cb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 b2 7c 10 80       	push   $0x80107cb2
801021bd:	e8 be e1 ff ff       	call   80100380 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <namei>:

struct inode*
namei(char *path)
{
801021d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021d1:	31 d2                	xor    %edx,%edx
{
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021de:	e8 dd fc ff ff       	call   80101ec0 <namex>
}
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    
801021e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021f0:	55                   	push   %ebp
  return namex(path, 1, name);
801021f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ff:	e9 bc fc ff ff       	jmp    80101ec0 <namex>
80102204:	66 90                	xchg   %ax,%ax
80102206:	66 90                	xchg   %ax,%ax
80102208:	66 90                	xchg   %ax,%ax
8010220a:	66 90                	xchg   %ax,%ax
8010220c:	66 90                	xchg   %ax,%ax
8010220e:	66 90                	xchg   %ax,%ax

80102210 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102219:	85 c0                	test   %eax,%eax
8010221b:	0f 84 b4 00 00 00    	je     801022d5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102221:	8b 70 08             	mov    0x8(%eax),%esi
80102224:	89 c3                	mov    %eax,%ebx
80102226:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010222c:	0f 87 96 00 00 00    	ja     801022c8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102232:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223e:	66 90                	xchg   %ax,%ax
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	31 ff                	xor    %edi,%edi
8010224c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102251:	89 f8                	mov    %edi,%eax
80102253:	ee                   	out    %al,(%dx)
80102254:	b8 01 00 00 00       	mov    $0x1,%eax
80102259:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010225e:	ee                   	out    %al,(%dx)
8010225f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102264:	89 f0                	mov    %esi,%eax
80102266:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102267:	89 f0                	mov    %esi,%eax
80102269:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010226e:	c1 f8 08             	sar    $0x8,%eax
80102271:	ee                   	out    %al,(%dx)
80102272:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102277:	89 f8                	mov    %edi,%eax
80102279:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010227a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010227e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102283:	c1 e0 04             	shl    $0x4,%eax
80102286:	83 e0 10             	and    $0x10,%eax
80102289:	83 c8 e0             	or     $0xffffffe0,%eax
8010228c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010228d:	f6 03 04             	testb  $0x4,(%ebx)
80102290:	75 16                	jne    801022a8 <idestart+0x98>
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 ca                	mov    %ecx,%edx
80102299:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010229a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5f                   	pop    %edi
801022a0:	5d                   	pop    %ebp
801022a1:	c3                   	ret    
801022a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022a8:	b8 30 00 00 00       	mov    $0x30,%eax
801022ad:	89 ca                	mov    %ecx,%edx
801022af:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022b0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022b5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022b8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022bd:	fc                   	cld    
801022be:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret    
    panic("incorrect blockno");
801022c8:	83 ec 0c             	sub    $0xc,%esp
801022cb:	68 14 77 10 80       	push   $0x80107714
801022d0:	e8 ab e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022d5:	83 ec 0c             	sub    $0xc,%esp
801022d8:	68 0b 77 10 80       	push   $0x8010770b
801022dd:	e8 9e e0 ff ff       	call   80100380 <panic>
801022e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022f0 <ideinit>:
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022f6:	68 26 77 10 80       	push   $0x80107726
801022fb:	68 00 16 11 80       	push   $0x80111600
80102300:	e8 5b 23 00 00       	call   80104660 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102305:	58                   	pop    %eax
80102306:	a1 84 17 11 80       	mov    0x80111784,%eax
8010230b:	5a                   	pop    %edx
8010230c:	83 e8 01             	sub    $0x1,%eax
8010230f:	50                   	push   %eax
80102310:	6a 0e                	push   $0xe
80102312:	e8 99 02 00 00       	call   801025b0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102317:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010231a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231f:	90                   	nop
80102320:	ec                   	in     (%dx),%al
80102321:	83 e0 c0             	and    $0xffffffc0,%eax
80102324:	3c 40                	cmp    $0x40,%al
80102326:	75 f8                	jne    80102320 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102328:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010232d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102332:	ee                   	out    %al,(%dx)
80102333:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102338:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010233d:	eb 06                	jmp    80102345 <ideinit+0x55>
8010233f:	90                   	nop
  for(i=0; i<1000; i++){
80102340:	83 e9 01             	sub    $0x1,%ecx
80102343:	74 0f                	je     80102354 <ideinit+0x64>
80102345:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102346:	84 c0                	test   %al,%al
80102348:	74 f6                	je     80102340 <ideinit+0x50>
      havedisk1 = 1;
8010234a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102351:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102354:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102359:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010235e:	ee                   	out    %al,(%dx)
}
8010235f:	c9                   	leave  
80102360:	c3                   	ret    
80102361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop

80102370 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
80102376:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102379:	68 00 16 11 80       	push   $0x80111600
8010237e:	e8 ed 23 00 00       	call   80104770 <acquire>

  if((b = idequeue) == 0){
80102383:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102389:	83 c4 10             	add    $0x10,%esp
8010238c:	85 db                	test   %ebx,%ebx
8010238e:	74 63                	je     801023f3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102390:	8b 43 58             	mov    0x58(%ebx),%eax
80102393:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102398:	8b 33                	mov    (%ebx),%esi
8010239a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023a0:	75 2f                	jne    801023d1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ae:	66 90                	xchg   %ax,%ax
801023b0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b1:	89 c1                	mov    %eax,%ecx
801023b3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023b6:	80 f9 40             	cmp    $0x40,%cl
801023b9:	75 f5                	jne    801023b0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023bb:	a8 21                	test   $0x21,%al
801023bd:	75 12                	jne    801023d1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023bf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023c2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023c7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023cc:	fc                   	cld    
801023cd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023cf:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023d1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023d4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023d7:	83 ce 02             	or     $0x2,%esi
801023da:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023dc:	53                   	push   %ebx
801023dd:	e8 4e 1f 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023e2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801023e7:	83 c4 10             	add    $0x10,%esp
801023ea:	85 c0                	test   %eax,%eax
801023ec:	74 05                	je     801023f3 <ideintr+0x83>
    idestart(idequeue);
801023ee:	e8 1d fe ff ff       	call   80102210 <idestart>
    release(&idelock);
801023f3:	83 ec 0c             	sub    $0xc,%esp
801023f6:	68 00 16 11 80       	push   $0x80111600
801023fb:	e8 90 24 00 00       	call   80104890 <release>

  release(&idelock);
}
80102400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102403:	5b                   	pop    %ebx
80102404:	5e                   	pop    %esi
80102405:	5f                   	pop    %edi
80102406:	5d                   	pop    %ebp
80102407:	c3                   	ret    
80102408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240f:	90                   	nop

80102410 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	53                   	push   %ebx
80102414:	83 ec 10             	sub    $0x10,%esp
80102417:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010241a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010241d:	50                   	push   %eax
8010241e:	e8 0d 22 00 00       	call   80104630 <holdingsleep>
80102423:	83 c4 10             	add    $0x10,%esp
80102426:	85 c0                	test   %eax,%eax
80102428:	0f 84 c3 00 00 00    	je     801024f1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010242e:	8b 03                	mov    (%ebx),%eax
80102430:	83 e0 06             	and    $0x6,%eax
80102433:	83 f8 02             	cmp    $0x2,%eax
80102436:	0f 84 a8 00 00 00    	je     801024e4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010243c:	8b 53 04             	mov    0x4(%ebx),%edx
8010243f:	85 d2                	test   %edx,%edx
80102441:	74 0d                	je     80102450 <iderw+0x40>
80102443:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102448:	85 c0                	test   %eax,%eax
8010244a:	0f 84 87 00 00 00    	je     801024d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	68 00 16 11 80       	push   $0x80111600
80102458:	e8 13 23 00 00       	call   80104770 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010245d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102462:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 c0                	test   %eax,%eax
8010246e:	74 60                	je     801024d0 <iderw+0xc0>
80102470:	89 c2                	mov    %eax,%edx
80102472:	8b 40 58             	mov    0x58(%eax),%eax
80102475:	85 c0                	test   %eax,%eax
80102477:	75 f7                	jne    80102470 <iderw+0x60>
80102479:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010247c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010247e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102484:	74 3a                	je     801024c0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102486:	8b 03                	mov    (%ebx),%eax
80102488:	83 e0 06             	and    $0x6,%eax
8010248b:	83 f8 02             	cmp    $0x2,%eax
8010248e:	74 1b                	je     801024ab <iderw+0x9b>
    sleep(b, &idelock);
80102490:	83 ec 08             	sub    $0x8,%esp
80102493:	68 00 16 11 80       	push   $0x80111600
80102498:	53                   	push   %ebx
80102499:	e8 d2 1d 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010249e:	8b 03                	mov    (%ebx),%eax
801024a0:	83 c4 10             	add    $0x10,%esp
801024a3:	83 e0 06             	and    $0x6,%eax
801024a6:	83 f8 02             	cmp    $0x2,%eax
801024a9:	75 e5                	jne    80102490 <iderw+0x80>
  }


  release(&idelock);
801024ab:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801024b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024b5:	c9                   	leave  
  release(&idelock);
801024b6:	e9 d5 23 00 00       	jmp    80104890 <release>
801024bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop
    idestart(b);
801024c0:	89 d8                	mov    %ebx,%eax
801024c2:	e8 49 fd ff ff       	call   80102210 <idestart>
801024c7:	eb bd                	jmp    80102486 <iderw+0x76>
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024d0:	ba e4 15 11 80       	mov    $0x801115e4,%edx
801024d5:	eb a5                	jmp    8010247c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 55 77 10 80       	push   $0x80107755
801024df:	e8 9c de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024e4:	83 ec 0c             	sub    $0xc,%esp
801024e7:	68 40 77 10 80       	push   $0x80107740
801024ec:	e8 8f de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024f1:	83 ec 0c             	sub    $0xc,%esp
801024f4:	68 2a 77 10 80       	push   $0x8010772a
801024f9:	e8 82 de ff ff       	call   80100380 <panic>
801024fe:	66 90                	xchg   %ax,%ax

80102500 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102500:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102501:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80102508:	00 c0 fe 
{
8010250b:	89 e5                	mov    %esp,%ebp
8010250d:	56                   	push   %esi
8010250e:	53                   	push   %ebx
  ioapic->reg = reg;
8010250f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102516:	00 00 00 
  return ioapic->data;
80102519:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010251f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102522:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102528:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010252e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102535:	c1 ee 10             	shr    $0x10,%esi
80102538:	89 f0                	mov    %esi,%eax
8010253a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010253d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102540:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102543:	39 c2                	cmp    %eax,%edx
80102545:	74 16                	je     8010255d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102547:	83 ec 0c             	sub    $0xc,%esp
8010254a:	68 74 77 10 80       	push   $0x80107774
8010254f:	e8 2c e1 ff ff       	call   80100680 <cprintf>
  ioapic->reg = reg;
80102554:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010255a:	83 c4 10             	add    $0x10,%esp
8010255d:	83 c6 21             	add    $0x21,%esi
{
80102560:	ba 10 00 00 00       	mov    $0x10,%edx
80102565:	b8 20 00 00 00       	mov    $0x20,%eax
8010256a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102570:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102572:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102574:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010257a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010257d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102583:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102586:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102589:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010258c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010258e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102594:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010259b:	39 f0                	cmp    %esi,%eax
8010259d:	75 d1                	jne    80102570 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010259f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a2:	5b                   	pop    %ebx
801025a3:	5e                   	pop    %esi
801025a4:	5d                   	pop    %ebp
801025a5:	c3                   	ret    
801025a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ad:	8d 76 00             	lea    0x0(%esi),%esi

801025b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025b0:	55                   	push   %ebp
  ioapic->reg = reg;
801025b1:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
801025b7:	89 e5                	mov    %esp,%ebp
801025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025bc:	8d 50 20             	lea    0x20(%eax),%edx
801025bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025c5:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025d6:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025de:	89 50 10             	mov    %edx,0x10(%eax)
}
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret    
801025e3:	66 90                	xchg   %ax,%ax
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	53                   	push   %ebx
801025f4:	83 ec 04             	sub    $0x4,%esp
801025f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102600:	75 76                	jne    80102678 <kfree+0x88>
80102602:	81 fb f0 55 11 80    	cmp    $0x801155f0,%ebx
80102608:	72 6e                	jb     80102678 <kfree+0x88>
8010260a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102610:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102615:	77 61                	ja     80102678 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102617:	83 ec 04             	sub    $0x4,%esp
8010261a:	68 00 10 00 00       	push   $0x1000
8010261f:	6a 01                	push   $0x1
80102621:	53                   	push   %ebx
80102622:	e8 b9 22 00 00       	call   801048e0 <memset>

  if(kmem.use_lock)
80102627:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	85 d2                	test   %edx,%edx
80102632:	75 1c                	jne    80102650 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102634:	a1 78 16 11 80       	mov    0x80111678,%eax
80102639:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010263b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102640:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102646:	85 c0                	test   %eax,%eax
80102648:	75 1e                	jne    80102668 <kfree+0x78>
    release(&kmem.lock);
}
8010264a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010264d:	c9                   	leave  
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    acquire(&kmem.lock);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	68 40 16 11 80       	push   $0x80111640
80102658:	e8 13 21 00 00       	call   80104770 <acquire>
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	eb d2                	jmp    80102634 <kfree+0x44>
80102662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102668:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010266f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102672:	c9                   	leave  
    release(&kmem.lock);
80102673:	e9 18 22 00 00       	jmp    80104890 <release>
    panic("kfree");
80102678:	83 ec 0c             	sub    $0xc,%esp
8010267b:	68 a6 77 10 80       	push   $0x801077a6
80102680:	e8 fb dc ff ff       	call   80100380 <panic>
80102685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <freerange>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102694:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102697:	8b 75 0c             	mov    0xc(%ebp),%esi
8010269a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010269b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ad:	39 de                	cmp    %ebx,%esi
801026af:	72 23                	jb     801026d4 <freerange+0x44>
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026c7:	50                   	push   %eax
801026c8:	e8 23 ff ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026cd:	83 c4 10             	add    $0x10,%esp
801026d0:	39 f3                	cmp    %esi,%ebx
801026d2:	76 e4                	jbe    801026b8 <freerange+0x28>
}
801026d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026d7:	5b                   	pop    %ebx
801026d8:	5e                   	pop    %esi
801026d9:	5d                   	pop    %ebp
801026da:	c3                   	ret    
801026db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026df:	90                   	nop

801026e0 <kinit2>:
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026e4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026e7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ea:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026fd:	39 de                	cmp    %ebx,%esi
801026ff:	72 23                	jb     80102724 <kinit2+0x44>
80102701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102711:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102717:	50                   	push   %eax
80102718:	e8 d3 fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	39 de                	cmp    %ebx,%esi
80102722:	73 e4                	jae    80102708 <kinit2+0x28>
  kmem.use_lock = 1;
80102724:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010272b:	00 00 00 
}
8010272e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102731:	5b                   	pop    %ebx
80102732:	5e                   	pop    %esi
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <kinit1>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
80102745:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102748:	83 ec 08             	sub    $0x8,%esp
8010274b:	68 ac 77 10 80       	push   $0x801077ac
80102750:	68 40 16 11 80       	push   $0x80111640
80102755:	e8 06 1f 00 00       	call   80104660 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010275a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010275d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102760:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102767:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010276a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102770:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102776:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010277c:	39 de                	cmp    %ebx,%esi
8010277e:	72 1c                	jb     8010279c <kinit1+0x5c>
    kfree(p);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102789:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010278f:	50                   	push   %eax
80102790:	e8 5b fe ff ff       	call   801025f0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102795:	83 c4 10             	add    $0x10,%esp
80102798:	39 de                	cmp    %ebx,%esi
8010279a:	73 e4                	jae    80102780 <kinit1+0x40>
}
8010279c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010279f:	5b                   	pop    %ebx
801027a0:	5e                   	pop    %esi
801027a1:	5d                   	pop    %ebp
801027a2:	c3                   	ret    
801027a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801027b0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801027b0:	a1 74 16 11 80       	mov    0x80111674,%eax
801027b5:	85 c0                	test   %eax,%eax
801027b7:	75 1f                	jne    801027d8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801027b9:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
801027be:	85 c0                	test   %eax,%eax
801027c0:	74 0e                	je     801027d0 <kalloc+0x20>
    kmem.freelist = r->next;
801027c2:	8b 10                	mov    (%eax),%edx
801027c4:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801027ca:	c3                   	ret    
801027cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027cf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801027d0:	c3                   	ret    
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027d8:	55                   	push   %ebp
801027d9:	89 e5                	mov    %esp,%ebp
801027db:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027de:	68 40 16 11 80       	push   $0x80111640
801027e3:	e8 88 1f 00 00       	call   80104770 <acquire>
  r = kmem.freelist;
801027e8:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
801027ed:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	85 c0                	test   %eax,%eax
801027f8:	74 08                	je     80102802 <kalloc+0x52>
    kmem.freelist = r->next;
801027fa:	8b 08                	mov    (%eax),%ecx
801027fc:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
80102802:	85 d2                	test   %edx,%edx
80102804:	74 16                	je     8010281c <kalloc+0x6c>
    release(&kmem.lock);
80102806:	83 ec 0c             	sub    $0xc,%esp
80102809:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280c:	68 40 16 11 80       	push   $0x80111640
80102811:	e8 7a 20 00 00       	call   80104890 <release>
  return (char*)r;
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102819:	83 c4 10             	add    $0x10,%esp
}
8010281c:	c9                   	leave  
8010281d:	c3                   	ret    
8010281e:	66 90                	xchg   %ax,%ax

80102820 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102820:	ba 64 00 00 00       	mov    $0x64,%edx
80102825:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102826:	a8 01                	test   $0x1,%al
80102828:	0f 84 ca 00 00 00    	je     801028f8 <kbdgetc+0xd8>
{
8010282e:	55                   	push   %ebp
8010282f:	ba 60 00 00 00       	mov    $0x60,%edx
80102834:	89 e5                	mov    %esp,%ebp
80102836:	53                   	push   %ebx
80102837:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102838:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
8010283e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102841:	3c e0                	cmp    $0xe0,%al
80102843:	74 5b                	je     801028a0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102845:	89 da                	mov    %ebx,%edx
80102847:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010284a:	84 c0                	test   %al,%al
8010284c:	78 62                	js     801028b0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010284e:	85 d2                	test   %edx,%edx
80102850:	74 09                	je     8010285b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102852:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102855:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102858:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010285b:	0f b6 91 e0 78 10 80 	movzbl -0x7fef8720(%ecx),%edx
  shift ^= togglecode[data];
80102862:	0f b6 81 e0 77 10 80 	movzbl -0x7fef8820(%ecx),%eax
  shift |= shiftcode[data];
80102869:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010286b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010286d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010286f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102875:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102878:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010287b:	8b 04 85 c0 77 10 80 	mov    -0x7fef8840(,%eax,4),%eax
80102882:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102886:	74 0b                	je     80102893 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102888:	8d 50 9f             	lea    -0x61(%eax),%edx
8010288b:	83 fa 19             	cmp    $0x19,%edx
8010288e:	77 50                	ja     801028e0 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102890:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102893:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102896:	c9                   	leave  
80102897:	c3                   	ret    
80102898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop
    shift |= E0ESC;
801028a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028a5:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
801028ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028ae:	c9                   	leave  
801028af:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801028b0:	83 e0 7f             	and    $0x7f,%eax
801028b3:	85 d2                	test   %edx,%edx
801028b5:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801028ba:	0f b6 91 e0 78 10 80 	movzbl -0x7fef8720(%ecx),%edx
801028c1:	83 ca 40             	or     $0x40,%edx
801028c4:	0f b6 d2             	movzbl %dl,%edx
801028c7:	f7 d2                	not    %edx
801028c9:	21 da                	and    %ebx,%edx
}
801028cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ce:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
}
801028d4:	c9                   	leave  
801028d5:	c3                   	ret    
801028d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028dd:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028e0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028e3:	8d 50 20             	lea    0x20(%eax),%edx
}
801028e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028e9:	c9                   	leave  
      c += 'a' - 'A';
801028ea:	83 f9 1a             	cmp    $0x1a,%ecx
801028ed:	0f 42 c2             	cmovb  %edx,%eax
}
801028f0:	c3                   	ret    
801028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028fd:	c3                   	ret    
801028fe:	66 90                	xchg   %ax,%ax

80102900 <kbdintr>:

void
kbdintr(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102906:	68 20 28 10 80       	push   $0x80102820
8010290b:	e8 e0 df ff ff       	call   801008f0 <consoleintr>
}
80102910:	83 c4 10             	add    $0x10,%esp
80102913:	c9                   	leave  
80102914:	c3                   	ret    
80102915:	66 90                	xchg   %ax,%ax
80102917:	66 90                	xchg   %ax,%ax
80102919:	66 90                	xchg   %ax,%ax
8010291b:	66 90                	xchg   %ax,%ax
8010291d:	66 90                	xchg   %ax,%ax
8010291f:	90                   	nop

80102920 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102920:	a1 80 16 11 80       	mov    0x80111680,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	0f 84 cb 00 00 00    	je     801029f8 <lapicinit+0xd8>
  lapic[index] = value;
8010292d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102934:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102941:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010294e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102951:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102954:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010295b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010295e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102961:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102968:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010296b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102975:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102978:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010297b:	8b 50 30             	mov    0x30(%eax),%edx
8010297e:	c1 ea 10             	shr    $0x10,%edx
80102981:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102987:	75 77                	jne    80102a00 <lapicinit+0xe0>
  lapic[index] = value;
80102989:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102990:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102996:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010299d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029d4:	8b 50 20             	mov    0x20(%eax),%edx
801029d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029de:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029e6:	80 e6 10             	and    $0x10,%dh
801029e9:	75 f5                	jne    801029e0 <lapicinit+0xc0>
  lapic[index] = value;
801029eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029f8:	c3                   	ret    
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a00:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a07:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102a0d:	e9 77 ff ff ff       	jmp    80102989 <lapicinit+0x69>
80102a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a20 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a20:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 07                	je     80102a30 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a29:	8b 40 20             	mov    0x20(%eax),%eax
80102a2c:	c1 e8 18             	shr    $0x18,%eax
80102a2f:	c3                   	ret    
    return 0;
80102a30:	31 c0                	xor    %eax,%eax
}
80102a32:	c3                   	ret    
80102a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a40 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a40:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a45:	85 c0                	test   %eax,%eax
80102a47:	74 0d                	je     80102a56 <lapiceoi+0x16>
  lapic[index] = value;
80102a49:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a56:	c3                   	ret    
80102a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a5e:	66 90                	xchg   %ax,%ax

80102a60 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a60:	c3                   	ret    
80102a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a6f:	90                   	nop

80102a70 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a70:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a71:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	53                   	push   %ebx
80102a7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a84:	ee                   	out    %al,(%dx)
80102a85:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a8a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a8f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a90:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a92:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a95:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a9b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a9d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102aa0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102aa2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102aa5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102aa8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102aae:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ab3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ab9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102ac3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ad0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ad6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102adc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102adf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ae5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ae8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102aee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102af1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afd:	c9                   	leave  
80102afe:	c3                   	ret    
80102aff:	90                   	nop

80102b00 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102b00:	55                   	push   %ebp
80102b01:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b06:	ba 70 00 00 00       	mov    $0x70,%edx
80102b0b:	89 e5                	mov    %esp,%ebp
80102b0d:	57                   	push   %edi
80102b0e:	56                   	push   %esi
80102b0f:	53                   	push   %ebx
80102b10:	83 ec 4c             	sub    $0x4c,%esp
80102b13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b14:	ba 71 00 00 00       	mov    $0x71,%edx
80102b19:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b1a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b22:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b25:	8d 76 00             	lea    0x0(%esi),%esi
80102b28:	31 c0                	xor    %eax,%eax
80102b2a:	89 da                	mov    %ebx,%edx
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b32:	89 ca                	mov    %ecx,%edx
80102b34:	ec                   	in     (%dx),%al
80102b35:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b38:	89 da                	mov    %ebx,%edx
80102b3a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b3f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
80102b43:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b46:	89 da                	mov    %ebx,%edx
80102b48:	b8 04 00 00 00       	mov    $0x4,%eax
80102b4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4e:	89 ca                	mov    %ecx,%edx
80102b50:	ec                   	in     (%dx),%al
80102b51:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b54:	89 da                	mov    %ebx,%edx
80102b56:	b8 07 00 00 00       	mov    $0x7,%eax
80102b5b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5c:	89 ca                	mov    %ecx,%edx
80102b5e:	ec                   	in     (%dx),%al
80102b5f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b62:	89 da                	mov    %ebx,%edx
80102b64:	b8 08 00 00 00       	mov    $0x8,%eax
80102b69:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6a:	89 ca                	mov    %ecx,%edx
80102b6c:	ec                   	in     (%dx),%al
80102b6d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6f:	89 da                	mov    %ebx,%edx
80102b71:	b8 09 00 00 00       	mov    $0x9,%eax
80102b76:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b77:	89 ca                	mov    %ecx,%edx
80102b79:	ec                   	in     (%dx),%al
80102b7a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7c:	89 da                	mov    %ebx,%edx
80102b7e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b84:	89 ca                	mov    %ecx,%edx
80102b86:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b87:	84 c0                	test   %al,%al
80102b89:	78 9d                	js     80102b28 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b8b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b8f:	89 fa                	mov    %edi,%edx
80102b91:	0f b6 fa             	movzbl %dl,%edi
80102b94:	89 f2                	mov    %esi,%edx
80102b96:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b99:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b9d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba0:	89 da                	mov    %ebx,%edx
80102ba2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102ba5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ba8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bac:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102baf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102bb2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102bb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102bb9:	31 c0                	xor    %eax,%eax
80102bbb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbc:	89 ca                	mov    %ecx,%edx
80102bbe:	ec                   	in     (%dx),%al
80102bbf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc2:	89 da                	mov    %ebx,%edx
80102bc4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102bc7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bcc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcd:	89 ca                	mov    %ecx,%edx
80102bcf:	ec                   	in     (%dx),%al
80102bd0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd3:	89 da                	mov    %ebx,%edx
80102bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bd8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bdd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bde:	89 ca                	mov    %ecx,%edx
80102be0:	ec                   	in     (%dx),%al
80102be1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be4:	89 da                	mov    %ebx,%edx
80102be6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102be9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bef:	89 ca                	mov    %ecx,%edx
80102bf1:	ec                   	in     (%dx),%al
80102bf2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf5:	89 da                	mov    %ebx,%edx
80102bf7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bfa:	b8 08 00 00 00       	mov    $0x8,%eax
80102bff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c00:	89 ca                	mov    %ecx,%edx
80102c02:	ec                   	in     (%dx),%al
80102c03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c06:	89 da                	mov    %ebx,%edx
80102c08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c11:	89 ca                	mov    %ecx,%edx
80102c13:	ec                   	in     (%dx),%al
80102c14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c20:	6a 18                	push   $0x18
80102c22:	50                   	push   %eax
80102c23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c26:	50                   	push   %eax
80102c27:	e8 04 1d 00 00       	call   80104930 <memcmp>
80102c2c:	83 c4 10             	add    $0x10,%esp
80102c2f:	85 c0                	test   %eax,%eax
80102c31:	0f 85 f1 fe ff ff    	jne    80102b28 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c3b:	75 78                	jne    80102cb5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c40:	89 c2                	mov    %eax,%edx
80102c42:	83 e0 0f             	and    $0xf,%eax
80102c45:	c1 ea 04             	shr    $0x4,%edx
80102c48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c54:	89 c2                	mov    %eax,%edx
80102c56:	83 e0 0f             	and    $0xf,%eax
80102c59:	c1 ea 04             	shr    $0x4,%edx
80102c5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c68:	89 c2                	mov    %eax,%edx
80102c6a:	83 e0 0f             	and    $0xf,%eax
80102c6d:	c1 ea 04             	shr    $0x4,%edx
80102c70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c7c:	89 c2                	mov    %eax,%edx
80102c7e:	83 e0 0f             	and    $0xf,%eax
80102c81:	c1 ea 04             	shr    $0x4,%edx
80102c84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c90:	89 c2                	mov    %eax,%edx
80102c92:	83 e0 0f             	and    $0xf,%eax
80102c95:	c1 ea 04             	shr    $0x4,%edx
80102c98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ca1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ca4:	89 c2                	mov    %eax,%edx
80102ca6:	83 e0 0f             	and    $0xf,%eax
80102ca9:	c1 ea 04             	shr    $0x4,%edx
80102cac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102caf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102cb5:	8b 75 08             	mov    0x8(%ebp),%esi
80102cb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cbb:	89 06                	mov    %eax,(%esi)
80102cbd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102cc0:	89 46 04             	mov    %eax,0x4(%esi)
80102cc3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cc6:	89 46 08             	mov    %eax,0x8(%esi)
80102cc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ccc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ccf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cd2:	89 46 10             	mov    %eax,0x10(%esi)
80102cd5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cd8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cdb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce5:	5b                   	pop    %ebx
80102ce6:	5e                   	pop    %esi
80102ce7:	5f                   	pop    %edi
80102ce8:	5d                   	pop    %ebp
80102ce9:	c3                   	ret    
80102cea:	66 90                	xchg   %ax,%ax
80102cec:	66 90                	xchg   %ax,%ax
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cf0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102cf6:	85 c9                	test   %ecx,%ecx
80102cf8:	0f 8e 8a 00 00 00    	jle    80102d88 <install_trans+0x98>
{
80102cfe:	55                   	push   %ebp
80102cff:	89 e5                	mov    %esp,%ebp
80102d01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102d02:	31 ff                	xor    %edi,%edi
{
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 0c             	sub    $0xc,%esp
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d10:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102d15:	83 ec 08             	sub    $0x8,%esp
80102d18:	01 f8                	add    %edi,%eax
80102d1a:	83 c0 01             	add    $0x1,%eax
80102d1d:	50                   	push   %eax
80102d1e:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
80102d29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d2b:	58                   	pop    %eax
80102d2c:	5a                   	pop    %edx
80102d2d:	ff 34 bd ec 16 11 80 	pushl  -0x7feee914(,%edi,4)
80102d34:	ff 35 e4 16 11 80    	pushl  0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d3d:	e8 8e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d4a:	68 00 02 00 00       	push   $0x200
80102d4f:	50                   	push   %eax
80102d50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d53:	50                   	push   %eax
80102d54:	e8 27 1c 00 00       	call   80104980 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d59:	89 1c 24             	mov    %ebx,(%esp)
80102d5c:	e8 4f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d61:	89 34 24             	mov    %esi,(%esp)
80102d64:	e8 87 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d69:	89 1c 24             	mov    %ebx,(%esp)
80102d6c:	e8 7f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d71:	83 c4 10             	add    $0x10,%esp
80102d74:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102d7a:	7f 94                	jg     80102d10 <install_trans+0x20>
  }
}
80102d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d7f:	5b                   	pop    %ebx
80102d80:	5e                   	pop    %esi
80102d81:	5f                   	pop    %edi
80102d82:	5d                   	pop    %ebp
80102d83:	c3                   	ret    
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d88:	c3                   	ret    
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d97:	ff 35 d4 16 11 80    	pushl  0x801116d4
80102d9d:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102da3:	e8 28 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102da8:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102dae:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102db1:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102db3:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102db6:	85 c9                	test   %ecx,%ecx
80102db8:	7e 18                	jle    80102dd2 <write_head+0x42>
80102dba:	31 c0                	xor    %eax,%eax
80102dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102dc0:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
80102dc7:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102dcb:	83 c0 01             	add    $0x1,%eax
80102dce:	39 c1                	cmp    %eax,%ecx
80102dd0:	75 ee                	jne    80102dc0 <write_head+0x30>
  }
  bwrite(buf);
80102dd2:	83 ec 0c             	sub    $0xc,%esp
80102dd5:	53                   	push   %ebx
80102dd6:	e8 d5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ddb:	89 1c 24             	mov    %ebx,(%esp)
80102dde:	e8 0d d4 ff ff       	call   801001f0 <brelse>
}
80102de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102de6:	83 c4 10             	add    $0x10,%esp
80102de9:	c9                   	leave  
80102dea:	c3                   	ret    
80102deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102def:	90                   	nop

80102df0 <initlog>:
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 2c             	sub    $0x2c,%esp
80102df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dfa:	68 e0 79 10 80       	push   $0x801079e0
80102dff:	68 a0 16 11 80       	push   $0x801116a0
80102e04:	e8 57 18 00 00       	call   80104660 <initlock>
  readsb(dev, &sb);
80102e09:	58                   	pop    %eax
80102e0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 3b e8 ff ff       	call   80101650 <readsb>
  log.start = sb.logstart;
80102e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e18:	59                   	pop    %ecx
  log.dev = dev;
80102e19:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e22:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102e27:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102e2d:	5a                   	pop    %edx
80102e2e:	50                   	push   %eax
80102e2f:	53                   	push   %ebx
80102e30:	e8 9b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e38:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102e3b:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102e3d:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102e43:	85 db                	test   %ebx,%ebx
80102e45:	7e 1b                	jle    80102e62 <initlog+0x72>
80102e47:	31 c0                	xor    %eax,%eax
80102e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102e50:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102e54:	89 14 85 ec 16 11 80 	mov    %edx,-0x7feee914(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e5b:	83 c0 01             	add    $0x1,%eax
80102e5e:	39 c3                	cmp    %eax,%ebx
80102e60:	75 ee                	jne    80102e50 <initlog+0x60>
  brelse(buf);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	51                   	push   %ecx
80102e66:	e8 85 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e6b:	e8 80 fe ff ff       	call   80102cf0 <install_trans>
  log.lh.n = 0;
80102e70:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102e77:	00 00 00 
  write_head(); // clear the log
80102e7a:	e8 11 ff ff ff       	call   80102d90 <write_head>
}
80102e7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e82:	83 c4 10             	add    $0x10,%esp
80102e85:	c9                   	leave  
80102e86:	c3                   	ret    
80102e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e8e:	66 90                	xchg   %ax,%ax

80102e90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e96:	68 a0 16 11 80       	push   $0x801116a0
80102e9b:	e8 d0 18 00 00       	call   80104770 <acquire>
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	eb 18                	jmp    80102ebd <begin_op+0x2d>
80102ea5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ea8:	83 ec 08             	sub    $0x8,%esp
80102eab:	68 a0 16 11 80       	push   $0x801116a0
80102eb0:	68 a0 16 11 80       	push   $0x801116a0
80102eb5:	e8 b6 13 00 00       	call   80104270 <sleep>
80102eba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ebd:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102ec2:	85 c0                	test   %eax,%eax
80102ec4:	75 e2                	jne    80102ea8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ec6:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102ecb:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102ed1:	83 c0 01             	add    $0x1,%eax
80102ed4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ed7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eda:	83 fa 1e             	cmp    $0x1e,%edx
80102edd:	7f c9                	jg     80102ea8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102edf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ee2:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102ee7:	68 a0 16 11 80       	push   $0x801116a0
80102eec:	e8 9f 19 00 00       	call   80104890 <release>
      break;
    }
  }
}
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	c9                   	leave  
80102ef5:	c3                   	ret    
80102ef6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102efd:	8d 76 00             	lea    0x0(%esi),%esi

80102f00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	57                   	push   %edi
80102f04:	56                   	push   %esi
80102f05:	53                   	push   %ebx
80102f06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f09:	68 a0 16 11 80       	push   $0x801116a0
80102f0e:	e8 5d 18 00 00       	call   80104770 <acquire>
  log.outstanding -= 1;
80102f13:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102f18:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102f1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f24:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102f2a:	85 f6                	test   %esi,%esi
80102f2c:	0f 85 22 01 00 00    	jne    80103054 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f32:	85 db                	test   %ebx,%ebx
80102f34:	0f 85 f6 00 00 00    	jne    80103030 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f3a:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102f41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 a0 16 11 80       	push   $0x801116a0
80102f4c:	e8 3f 19 00 00       	call   80104890 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f51:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	85 c9                	test   %ecx,%ecx
80102f5c:	7f 42                	jg     80102fa0 <end_op+0xa0>
    acquire(&log.lock);
80102f5e:	83 ec 0c             	sub    $0xc,%esp
80102f61:	68 a0 16 11 80       	push   $0x801116a0
80102f66:	e8 05 18 00 00       	call   80104770 <acquire>
    wakeup(&log);
80102f6b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80102f72:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102f79:	00 00 00 
    wakeup(&log);
80102f7c:	e8 af 13 00 00       	call   80104330 <wakeup>
    release(&log.lock);
80102f81:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f88:	e8 03 19 00 00       	call   80104890 <release>
80102f8d:	83 c4 10             	add    $0x10,%esp
}
80102f90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f93:	5b                   	pop    %ebx
80102f94:	5e                   	pop    %esi
80102f95:	5f                   	pop    %edi
80102f96:	5d                   	pop    %ebp
80102f97:	c3                   	ret    
80102f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102fa0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102fa5:	83 ec 08             	sub    $0x8,%esp
80102fa8:	01 d8                	add    %ebx,%eax
80102faa:	83 c0 01             	add    $0x1,%eax
80102fad:	50                   	push   %eax
80102fae:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102fb4:	e8 17 d1 ff ff       	call   801000d0 <bread>
80102fb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fbb:	58                   	pop    %eax
80102fbc:	5a                   	pop    %edx
80102fbd:	ff 34 9d ec 16 11 80 	pushl  -0x7feee914(,%ebx,4)
80102fc4:	ff 35 e4 16 11 80    	pushl  0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102fca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fcd:	e8 fe d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fd5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fd7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fda:	68 00 02 00 00       	push   $0x200
80102fdf:	50                   	push   %eax
80102fe0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fe3:	50                   	push   %eax
80102fe4:	e8 97 19 00 00       	call   80104980 <memmove>
    bwrite(to);  // write the log
80102fe9:	89 34 24             	mov    %esi,(%esp)
80102fec:	e8 bf d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ff1:	89 3c 24             	mov    %edi,(%esp)
80102ff4:	e8 f7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ff9:	89 34 24             	mov    %esi,(%esp)
80102ffc:	e8 ef d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
8010300a:	7c 94                	jl     80102fa0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010300c:	e8 7f fd ff ff       	call   80102d90 <write_head>
    install_trans(); // Now install writes to home locations
80103011:	e8 da fc ff ff       	call   80102cf0 <install_trans>
    log.lh.n = 0;
80103016:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010301d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103020:	e8 6b fd ff ff       	call   80102d90 <write_head>
80103025:	e9 34 ff ff ff       	jmp    80102f5e <end_op+0x5e>
8010302a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103030:	83 ec 0c             	sub    $0xc,%esp
80103033:	68 a0 16 11 80       	push   $0x801116a0
80103038:	e8 f3 12 00 00       	call   80104330 <wakeup>
  release(&log.lock);
8010303d:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103044:	e8 47 18 00 00       	call   80104890 <release>
80103049:	83 c4 10             	add    $0x10,%esp
}
8010304c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010304f:	5b                   	pop    %ebx
80103050:	5e                   	pop    %esi
80103051:	5f                   	pop    %edi
80103052:	5d                   	pop    %ebp
80103053:	c3                   	ret    
    panic("log.committing");
80103054:	83 ec 0c             	sub    $0xc,%esp
80103057:	68 e4 79 10 80       	push   $0x801079e4
8010305c:	e8 1f d3 ff ff       	call   80100380 <panic>
80103061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop

80103070 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103077:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010307d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103080:	83 fa 1d             	cmp    $0x1d,%edx
80103083:	0f 8f 85 00 00 00    	jg     8010310e <log_write+0x9e>
80103089:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010308e:	83 e8 01             	sub    $0x1,%eax
80103091:	39 c2                	cmp    %eax,%edx
80103093:	7d 79                	jge    8010310e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103095:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010309a:	85 c0                	test   %eax,%eax
8010309c:	7e 7d                	jle    8010311b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010309e:	83 ec 0c             	sub    $0xc,%esp
801030a1:	68 a0 16 11 80       	push   $0x801116a0
801030a6:	e8 c5 16 00 00       	call   80104770 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801030ab:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	85 d2                	test   %edx,%edx
801030b6:	7e 4a                	jle    80103102 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030b8:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801030bb:	31 c0                	xor    %eax,%eax
801030bd:	eb 08                	jmp    801030c7 <log_write+0x57>
801030bf:	90                   	nop
801030c0:	83 c0 01             	add    $0x1,%eax
801030c3:	39 c2                	cmp    %eax,%edx
801030c5:	74 29                	je     801030f0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030c7:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801030ce:	75 f0                	jne    801030c0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030d7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030dd:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
801030e4:	c9                   	leave  
  release(&log.lock);
801030e5:	e9 a6 17 00 00       	jmp    80104890 <release>
801030ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030f0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801030f7:	83 c2 01             	add    $0x1,%edx
801030fa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80103100:	eb d5                	jmp    801030d7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103102:	8b 43 08             	mov    0x8(%ebx),%eax
80103105:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
8010310a:	75 cb                	jne    801030d7 <log_write+0x67>
8010310c:	eb e9                	jmp    801030f7 <log_write+0x87>
    panic("too big a transaction");
8010310e:	83 ec 0c             	sub    $0xc,%esp
80103111:	68 f3 79 10 80       	push   $0x801079f3
80103116:	e8 65 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010311b:	83 ec 0c             	sub    $0xc,%esp
8010311e:	68 09 7a 10 80       	push   $0x80107a09
80103123:	e8 58 d2 ff ff       	call   80100380 <panic>
80103128:	66 90                	xchg   %ax,%ax
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	53                   	push   %ebx
80103134:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103137:	e8 54 09 00 00       	call   80103a90 <cpuid>
8010313c:	89 c3                	mov    %eax,%ebx
8010313e:	e8 4d 09 00 00       	call   80103a90 <cpuid>
80103143:	83 ec 04             	sub    $0x4,%esp
80103146:	53                   	push   %ebx
80103147:	50                   	push   %eax
80103148:	68 24 7a 10 80       	push   $0x80107a24
8010314d:	e8 2e d5 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103152:	e8 19 2b 00 00       	call   80105c70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103157:	e8 c4 08 00 00       	call   80103a20 <mycpu>
8010315c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010315e:	b8 01 00 00 00       	mov    $0x1,%eax
80103163:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010316a:	e8 e1 0a 00 00       	call   80103c50 <scheduler>
8010316f:	90                   	nop

80103170 <mpenter>:
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103176:	e8 05 3c 00 00       	call   80106d80 <switchkvm>
  seginit();
8010317b:	e8 70 3b 00 00       	call   80106cf0 <seginit>
  lapicinit();
80103180:	e8 9b f7 ff ff       	call   80102920 <lapicinit>
  mpmain();
80103185:	e8 a6 ff ff ff       	call   80103130 <mpmain>
8010318a:	66 90                	xchg   %ax,%ax
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <main>:
{
80103190:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103194:	83 e4 f0             	and    $0xfffffff0,%esp
80103197:	ff 71 fc             	pushl  -0x4(%ecx)
8010319a:	55                   	push   %ebp
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	53                   	push   %ebx
8010319e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010319f:	83 ec 08             	sub    $0x8,%esp
801031a2:	68 00 00 40 80       	push   $0x80400000
801031a7:	68 f0 55 11 80       	push   $0x801155f0
801031ac:	e8 8f f5 ff ff       	call   80102740 <kinit1>
  kvmalloc();      // kernel page table
801031b1:	e8 ba 40 00 00       	call   80107270 <kvmalloc>
  mpinit();        // detect other processors
801031b6:	e8 85 01 00 00       	call   80103340 <mpinit>
  lapicinit();     // interrupt controller
801031bb:	e8 60 f7 ff ff       	call   80102920 <lapicinit>
  seginit();       // segment descriptors
801031c0:	e8 2b 3b 00 00       	call   80106cf0 <seginit>
  picinit();       // disable pic
801031c5:	e8 76 03 00 00       	call   80103540 <picinit>
  ioapicinit();    // another interrupt controller
801031ca:	e8 31 f3 ff ff       	call   80102500 <ioapicinit>
  consoleinit();   // console hardware
801031cf:	e8 ac d9 ff ff       	call   80100b80 <consoleinit>
  uartinit();      // serial port
801031d4:	e8 87 2d 00 00       	call   80105f60 <uartinit>
  pinit();         // process table
801031d9:	e8 22 08 00 00       	call   80103a00 <pinit>
  tvinit();        // trap vectors
801031de:	e8 0d 2a 00 00       	call   80105bf0 <tvinit>
  binit();         // buffer cache
801031e3:	e8 58 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031e8:	e8 43 dd ff ff       	call   80100f30 <fileinit>
  ideinit();       // disk 
801031ed:	e8 fe f0 ff ff       	call   801022f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031f2:	83 c4 0c             	add    $0xc,%esp
801031f5:	68 8a 00 00 00       	push   $0x8a
801031fa:	68 8c a4 10 80       	push   $0x8010a48c
801031ff:	68 00 70 00 80       	push   $0x80007000
80103204:	e8 77 17 00 00       	call   80104980 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103213:	00 00 00 
80103216:	05 a0 17 11 80       	add    $0x801117a0,%eax
8010321b:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
80103220:	76 7e                	jbe    801032a0 <main+0x110>
80103222:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
80103227:	eb 20                	jmp    80103249 <main+0xb9>
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103230:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
80103237:	00 00 00 
8010323a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103240:	05 a0 17 11 80       	add    $0x801117a0,%eax
80103245:	39 c3                	cmp    %eax,%ebx
80103247:	73 57                	jae    801032a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103249:	e8 d2 07 00 00       	call   80103a20 <mycpu>
8010324e:	39 c3                	cmp    %eax,%ebx
80103250:	74 de                	je     80103230 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103252:	e8 59 f5 ff ff       	call   801027b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103257:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
8010325a:	c7 05 f8 6f 00 80 70 	movl   $0x80103170,0x80006ff8
80103261:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103264:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010326b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010326e:	05 00 10 00 00       	add    $0x1000,%eax
80103273:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103278:	0f b6 03             	movzbl (%ebx),%eax
8010327b:	68 00 70 00 00       	push   $0x7000
80103280:	50                   	push   %eax
80103281:	e8 ea f7 ff ff       	call   80102a70 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103286:	83 c4 10             	add    $0x10,%esp
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103296:	85 c0                	test   %eax,%eax
80103298:	74 f6                	je     80103290 <main+0x100>
8010329a:	eb 94                	jmp    80103230 <main+0xa0>
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801032a0:	83 ec 08             	sub    $0x8,%esp
801032a3:	68 00 00 00 8e       	push   $0x8e000000
801032a8:	68 00 00 40 80       	push   $0x80400000
801032ad:	e8 2e f4 ff ff       	call   801026e0 <kinit2>
  userinit();      // first user process
801032b2:	e8 29 08 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
801032b7:	e8 74 fe ff ff       	call   80103130 <mpmain>
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032cb:	53                   	push   %ebx
  e = addr+len;
801032cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032d2:	39 de                	cmp    %ebx,%esi
801032d4:	72 10                	jb     801032e6 <mpsearch1+0x26>
801032d6:	eb 50                	jmp    80103328 <mpsearch1+0x68>
801032d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	89 fe                	mov    %edi,%esi
801032e2:	39 fb                	cmp    %edi,%ebx
801032e4:	76 42                	jbe    80103328 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032e6:	83 ec 04             	sub    $0x4,%esp
801032e9:	8d 7e 10             	lea    0x10(%esi),%edi
801032ec:	6a 04                	push   $0x4
801032ee:	68 38 7a 10 80       	push   $0x80107a38
801032f3:	56                   	push   %esi
801032f4:	e8 37 16 00 00       	call   80104930 <memcmp>
801032f9:	83 c4 10             	add    $0x10,%esp
801032fc:	89 c2                	mov    %eax,%edx
801032fe:	85 c0                	test   %eax,%eax
80103300:	75 de                	jne    801032e0 <mpsearch1+0x20>
80103302:	89 f0                	mov    %esi,%eax
80103304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103308:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
8010330b:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010330e:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103310:	39 f8                	cmp    %edi,%eax
80103312:	75 f4                	jne    80103308 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103314:	84 d2                	test   %dl,%dl
80103316:	75 c8                	jne    801032e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103318:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010331b:	89 f0                	mov    %esi,%eax
8010331d:	5b                   	pop    %ebx
8010331e:	5e                   	pop    %esi
8010331f:	5f                   	pop    %edi
80103320:	5d                   	pop    %ebp
80103321:	c3                   	ret    
80103322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103328:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010332b:	31 f6                	xor    %esi,%esi
}
8010332d:	5b                   	pop    %ebx
8010332e:	89 f0                	mov    %esi,%eax
80103330:	5e                   	pop    %esi
80103331:	5f                   	pop    %edi
80103332:	5d                   	pop    %ebp
80103333:	c3                   	ret    
80103334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop

80103340 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103349:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103350:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103357:	c1 e0 08             	shl    $0x8,%eax
8010335a:	09 d0                	or     %edx,%eax
8010335c:	c1 e0 04             	shl    $0x4,%eax
8010335f:	75 1b                	jne    8010337c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103361:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103368:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010336f:	c1 e0 08             	shl    $0x8,%eax
80103372:	09 d0                	or     %edx,%eax
80103374:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103377:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010337c:	ba 00 04 00 00       	mov    $0x400,%edx
80103381:	e8 3a ff ff ff       	call   801032c0 <mpsearch1>
80103386:	89 c3                	mov    %eax,%ebx
80103388:	85 c0                	test   %eax,%eax
8010338a:	0f 84 40 01 00 00    	je     801034d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103390:	8b 73 04             	mov    0x4(%ebx),%esi
80103393:	85 f6                	test   %esi,%esi
80103395:	0f 84 25 01 00 00    	je     801034c0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010339b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010339e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801033a4:	6a 04                	push   $0x4
801033a6:	68 3d 7a 10 80       	push   $0x80107a3d
801033ab:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801033af:	e8 7c 15 00 00       	call   80104930 <memcmp>
801033b4:	83 c4 10             	add    $0x10,%esp
801033b7:	85 c0                	test   %eax,%eax
801033b9:	0f 85 01 01 00 00    	jne    801034c0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
801033bf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033c6:	3c 01                	cmp    $0x1,%al
801033c8:	74 08                	je     801033d2 <mpinit+0x92>
801033ca:	3c 04                	cmp    $0x4,%al
801033cc:	0f 85 ee 00 00 00    	jne    801034c0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033d2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033d9:	66 85 d2             	test   %dx,%dx
801033dc:	74 22                	je     80103400 <mpinit+0xc0>
801033de:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033e1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033e3:	31 d2                	xor    %edx,%edx
801033e5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033ef:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033f2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033f4:	39 f8                	cmp    %edi,%eax
801033f6:	75 f0                	jne    801033e8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033f8:	84 d2                	test   %dl,%dl
801033fa:	0f 85 c0 00 00 00    	jne    801034c0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103400:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103406:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010340b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103412:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103418:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103420:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103427:	90                   	nop
80103428:	39 d0                	cmp    %edx,%eax
8010342a:	73 15                	jae    80103441 <mpinit+0x101>
    switch(*p){
8010342c:	0f b6 08             	movzbl (%eax),%ecx
8010342f:	80 f9 02             	cmp    $0x2,%cl
80103432:	74 4c                	je     80103480 <mpinit+0x140>
80103434:	77 3a                	ja     80103470 <mpinit+0x130>
80103436:	84 c9                	test   %cl,%cl
80103438:	74 56                	je     80103490 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010343a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010343d:	39 d0                	cmp    %edx,%eax
8010343f:	72 eb                	jb     8010342c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103441:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103444:	85 f6                	test   %esi,%esi
80103446:	0f 84 d9 00 00 00    	je     80103525 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010344c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103450:	74 15                	je     80103467 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103452:	b8 70 00 00 00       	mov    $0x70,%eax
80103457:	ba 22 00 00 00       	mov    $0x22,%edx
8010345c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010345d:	ba 23 00 00 00       	mov    $0x23,%edx
80103462:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103463:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103466:	ee                   	out    %al,(%dx)
  }
}
80103467:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346a:	5b                   	pop    %ebx
8010346b:	5e                   	pop    %esi
8010346c:	5f                   	pop    %edi
8010346d:	5d                   	pop    %ebp
8010346e:	c3                   	ret    
8010346f:	90                   	nop
    switch(*p){
80103470:	83 e9 03             	sub    $0x3,%ecx
80103473:	80 f9 01             	cmp    $0x1,%cl
80103476:	76 c2                	jbe    8010343a <mpinit+0xfa>
80103478:	31 f6                	xor    %esi,%esi
8010347a:	eb ac                	jmp    80103428 <mpinit+0xe8>
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103480:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103484:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103487:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010348d:	eb 99                	jmp    80103428 <mpinit+0xe8>
8010348f:	90                   	nop
      if(ncpu < NCPU) {
80103490:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103496:	83 f9 07             	cmp    $0x7,%ecx
80103499:	7f 19                	jg     801034b4 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010349b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801034a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801034a5:	83 c1 01             	add    $0x1,%ecx
801034a8:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801034ae:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
801034b4:	83 c0 14             	add    $0x14,%eax
      continue;
801034b7:	e9 6c ff ff ff       	jmp    80103428 <mpinit+0xe8>
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	68 42 7a 10 80       	push   $0x80107a42
801034c8:	e8 b3 ce ff ff       	call   80100380 <panic>
801034cd:	8d 76 00             	lea    0x0(%esi),%esi
{
801034d0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034d5:	eb 13                	jmp    801034ea <mpinit+0x1aa>
801034d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034de:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034e0:	89 f3                	mov    %esi,%ebx
801034e2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034e8:	74 d6                	je     801034c0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ea:	83 ec 04             	sub    $0x4,%esp
801034ed:	8d 73 10             	lea    0x10(%ebx),%esi
801034f0:	6a 04                	push   $0x4
801034f2:	68 38 7a 10 80       	push   $0x80107a38
801034f7:	53                   	push   %ebx
801034f8:	e8 33 14 00 00       	call   80104930 <memcmp>
801034fd:	83 c4 10             	add    $0x10,%esp
80103500:	89 c2                	mov    %eax,%edx
80103502:	85 c0                	test   %eax,%eax
80103504:	75 da                	jne    801034e0 <mpinit+0x1a0>
80103506:	89 d8                	mov    %ebx,%eax
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop
    sum += addr[i];
80103510:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
80103513:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103516:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103518:	39 f0                	cmp    %esi,%eax
8010351a:	75 f4                	jne    80103510 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010351c:	84 d2                	test   %dl,%dl
8010351e:	75 c0                	jne    801034e0 <mpinit+0x1a0>
80103520:	e9 6b fe ff ff       	jmp    80103390 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103525:	83 ec 0c             	sub    $0xc,%esp
80103528:	68 5c 7a 10 80       	push   $0x80107a5c
8010352d:	e8 4e ce ff ff       	call   80100380 <panic>
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <picinit>:
80103540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103545:	ba 21 00 00 00       	mov    $0x21,%edx
8010354a:	ee                   	out    %al,(%dx)
8010354b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103550:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103551:	c3                   	ret    
80103552:	66 90                	xchg   %ax,%ax
80103554:	66 90                	xchg   %ax,%ax
80103556:	66 90                	xchg   %ax,%ax
80103558:	66 90                	xchg   %ax,%ax
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 0c             	sub    $0xc,%esp
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010356f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103575:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010357b:	e8 d0 d9 ff ff       	call   80100f50 <filealloc>
80103580:	89 03                	mov    %eax,(%ebx)
80103582:	85 c0                	test   %eax,%eax
80103584:	0f 84 a8 00 00 00    	je     80103632 <pipealloc+0xd2>
8010358a:	e8 c1 d9 ff ff       	call   80100f50 <filealloc>
8010358f:	89 06                	mov    %eax,(%esi)
80103591:	85 c0                	test   %eax,%eax
80103593:	0f 84 87 00 00 00    	je     80103620 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103599:	e8 12 f2 ff ff       	call   801027b0 <kalloc>
8010359e:	89 c7                	mov    %eax,%edi
801035a0:	85 c0                	test   %eax,%eax
801035a2:	0f 84 b0 00 00 00    	je     80103658 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035a8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035af:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035b2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035bc:	00 00 00 
  p->nwrite = 0;
801035bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035c6:	00 00 00 
  p->nread = 0;
801035c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035d0:	00 00 00 
  initlock(&p->lock, "pipe");
801035d3:	68 7b 7a 10 80       	push   $0x80107a7b
801035d8:	50                   	push   %eax
801035d9:	e8 82 10 00 00       	call   80104660 <initlock>
  (*f0)->type = FD_PIPE;
801035de:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035e0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035e9:	8b 03                	mov    (%ebx),%eax
801035eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035ef:	8b 03                	mov    (%ebx),%eax
801035f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035f5:	8b 03                	mov    (%ebx),%eax
801035f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035fa:	8b 06                	mov    (%esi),%eax
801035fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103602:	8b 06                	mov    (%esi),%eax
80103604:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103608:	8b 06                	mov    (%esi),%eax
8010360a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010360e:	8b 06                	mov    (%esi),%eax
80103610:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103613:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103616:	31 c0                	xor    %eax,%eax
}
80103618:	5b                   	pop    %ebx
80103619:	5e                   	pop    %esi
8010361a:	5f                   	pop    %edi
8010361b:	5d                   	pop    %ebp
8010361c:	c3                   	ret    
8010361d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103620:	8b 03                	mov    (%ebx),%eax
80103622:	85 c0                	test   %eax,%eax
80103624:	74 1e                	je     80103644 <pipealloc+0xe4>
    fileclose(*f0);
80103626:	83 ec 0c             	sub    $0xc,%esp
80103629:	50                   	push   %eax
8010362a:	e8 e1 d9 ff ff       	call   80101010 <fileclose>
8010362f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103632:	8b 06                	mov    (%esi),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	74 0c                	je     80103644 <pipealloc+0xe4>
    fileclose(*f1);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	50                   	push   %eax
8010363c:	e8 cf d9 ff ff       	call   80101010 <fileclose>
80103641:	83 c4 10             	add    $0x10,%esp
}
80103644:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103658:	8b 03                	mov    (%ebx),%eax
8010365a:	85 c0                	test   %eax,%eax
8010365c:	75 c8                	jne    80103626 <pipealloc+0xc6>
8010365e:	eb d2                	jmp    80103632 <pipealloc+0xd2>

80103660 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103668:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010366b:	83 ec 0c             	sub    $0xc,%esp
8010366e:	53                   	push   %ebx
8010366f:	e8 fc 10 00 00       	call   80104770 <acquire>
  if(writable){
80103674:	83 c4 10             	add    $0x10,%esp
80103677:	85 f6                	test   %esi,%esi
80103679:	74 65                	je     801036e0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010367b:	83 ec 0c             	sub    $0xc,%esp
8010367e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103684:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010368b:	00 00 00 
    wakeup(&p->nread);
8010368e:	50                   	push   %eax
8010368f:	e8 9c 0c 00 00       	call   80104330 <wakeup>
80103694:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103697:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010369d:	85 d2                	test   %edx,%edx
8010369f:	75 0a                	jne    801036ab <pipeclose+0x4b>
801036a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036a7:	85 c0                	test   %eax,%eax
801036a9:	74 15                	je     801036c0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b1:	5b                   	pop    %ebx
801036b2:	5e                   	pop    %esi
801036b3:	5d                   	pop    %ebp
    release(&p->lock);
801036b4:	e9 d7 11 00 00       	jmp    80104890 <release>
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	53                   	push   %ebx
801036c4:	e8 c7 11 00 00       	call   80104890 <release>
    kfree((char*)p);
801036c9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036cc:	83 c4 10             	add    $0x10,%esp
}
801036cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036d2:	5b                   	pop    %ebx
801036d3:	5e                   	pop    %esi
801036d4:	5d                   	pop    %ebp
    kfree((char*)p);
801036d5:	e9 16 ef ff ff       	jmp    801025f0 <kfree>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036f0:	00 00 00 
    wakeup(&p->nwrite);
801036f3:	50                   	push   %eax
801036f4:	e8 37 0c 00 00       	call   80104330 <wakeup>
801036f9:	83 c4 10             	add    $0x10,%esp
801036fc:	eb 99                	jmp    80103697 <pipeclose+0x37>
801036fe:	66 90                	xchg   %ax,%ax

80103700 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 28             	sub    $0x28,%esp
80103709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010370c:	53                   	push   %ebx
8010370d:	e8 5e 10 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++){
80103712:	8b 45 10             	mov    0x10(%ebp),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	0f 8e c0 00 00 00    	jle    801037e0 <pipewrite+0xe0>
80103720:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103723:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103729:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010372f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103732:	03 45 10             	add    0x10(%ebp),%eax
80103735:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103738:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010373e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103744:	89 ca                	mov    %ecx,%edx
80103746:	05 00 02 00 00       	add    $0x200,%eax
8010374b:	39 c1                	cmp    %eax,%ecx
8010374d:	74 3f                	je     8010378e <pipewrite+0x8e>
8010374f:	eb 67                	jmp    801037b8 <pipewrite+0xb8>
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103758:	e8 53 03 00 00       	call   80103ab0 <myproc>
8010375d:	8b 48 24             	mov    0x24(%eax),%ecx
80103760:	85 c9                	test   %ecx,%ecx
80103762:	75 34                	jne    80103798 <pipewrite+0x98>
      wakeup(&p->nread);
80103764:	83 ec 0c             	sub    $0xc,%esp
80103767:	57                   	push   %edi
80103768:	e8 c3 0b 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010376d:	58                   	pop    %eax
8010376e:	5a                   	pop    %edx
8010376f:	53                   	push   %ebx
80103770:	56                   	push   %esi
80103771:	e8 fa 0a 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103776:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010377c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103782:	83 c4 10             	add    $0x10,%esp
80103785:	05 00 02 00 00       	add    $0x200,%eax
8010378a:	39 c2                	cmp    %eax,%edx
8010378c:	75 2a                	jne    801037b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010378e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103794:	85 c0                	test   %eax,%eax
80103796:	75 c0                	jne    80103758 <pipewrite+0x58>
        release(&p->lock);
80103798:	83 ec 0c             	sub    $0xc,%esp
8010379b:	53                   	push   %ebx
8010379c:	e8 ef 10 00 00       	call   80104890 <release>
        return -1;
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037ac:	5b                   	pop    %ebx
801037ad:	5e                   	pop    %esi
801037ae:	5f                   	pop    %edi
801037af:	5d                   	pop    %ebp
801037b0:	c3                   	ret    
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801037be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037ca:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037cd:	83 c6 01             	add    $0x1,%esi
801037d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037da:	0f 85 58 ff ff ff    	jne    80103738 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037e9:	50                   	push   %eax
801037ea:	e8 41 0b 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801037ef:	89 1c 24             	mov    %ebx,(%esp)
801037f2:	e8 99 10 00 00       	call   80104890 <release>
  return n;
801037f7:	8b 45 10             	mov    0x10(%ebp),%eax
801037fa:	83 c4 10             	add    $0x10,%esp
801037fd:	eb aa                	jmp    801037a9 <pipewrite+0xa9>
801037ff:	90                   	nop

80103800 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 18             	sub    $0x18,%esp
80103809:	8b 75 08             	mov    0x8(%ebp),%esi
8010380c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010380f:	56                   	push   %esi
80103810:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103816:	e8 55 0f 00 00       	call   80104770 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010381b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103821:	83 c4 10             	add    $0x10,%esp
80103824:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010382a:	74 2f                	je     8010385b <piperead+0x5b>
8010382c:	eb 37                	jmp    80103865 <piperead+0x65>
8010382e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103830:	e8 7b 02 00 00       	call   80103ab0 <myproc>
80103835:	8b 48 24             	mov    0x24(%eax),%ecx
80103838:	85 c9                	test   %ecx,%ecx
8010383a:	0f 85 80 00 00 00    	jne    801038c0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103840:	83 ec 08             	sub    $0x8,%esp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
80103845:	e8 26 0a 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010384a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103850:	83 c4 10             	add    $0x10,%esp
80103853:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103859:	75 0a                	jne    80103865 <piperead+0x65>
8010385b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103861:	85 c0                	test   %eax,%eax
80103863:	75 cb                	jne    80103830 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103865:	8b 55 10             	mov    0x10(%ebp),%edx
80103868:	31 db                	xor    %ebx,%ebx
8010386a:	85 d2                	test   %edx,%edx
8010386c:	7f 20                	jg     8010388e <piperead+0x8e>
8010386e:	eb 2c                	jmp    8010389c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103870:	8d 48 01             	lea    0x1(%eax),%ecx
80103873:	25 ff 01 00 00       	and    $0x1ff,%eax
80103878:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010387e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103883:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103886:	83 c3 01             	add    $0x1,%ebx
80103889:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010388c:	74 0e                	je     8010389c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010388e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103894:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010389a:	75 d4                	jne    80103870 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010389c:	83 ec 0c             	sub    $0xc,%esp
8010389f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801038a5:	50                   	push   %eax
801038a6:	e8 85 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801038ab:	89 34 24             	mov    %esi,(%esp)
801038ae:	e8 dd 0f 00 00       	call   80104890 <release>
  return i;
801038b3:	83 c4 10             	add    $0x10,%esp
}
801038b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b9:	89 d8                	mov    %ebx,%eax
801038bb:	5b                   	pop    %ebx
801038bc:	5e                   	pop    %esi
801038bd:	5f                   	pop    %edi
801038be:	5d                   	pop    %ebp
801038bf:	c3                   	ret    
      release(&p->lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038c8:	56                   	push   %esi
801038c9:	e8 c2 0f 00 00       	call   80104890 <release>
      return -1;
801038ce:	83 c4 10             	add    $0x10,%esp
}
801038d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d4:	89 d8                	mov    %ebx,%eax
801038d6:	5b                   	pop    %ebx
801038d7:	5e                   	pop    %esi
801038d8:	5f                   	pop    %edi
801038d9:	5d                   	pop    %ebp
801038da:	c3                   	ret    
801038db:	66 90                	xchg   %ax,%ax
801038dd:	66 90                	xchg   %ax,%ax
801038df:	90                   	nop

801038e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e4:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
{
801038e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038ec:	68 40 1d 11 80       	push   $0x80111d40
801038f1:	e8 7a 0e 00 00       	call   80104770 <acquire>
801038f6:	83 c4 10             	add    $0x10,%esp
801038f9:	eb 10                	jmp    8010390b <allocproc+0x2b>
801038fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103900:	83 eb 80             	sub    $0xffffff80,%ebx
80103903:	81 fb 74 3d 11 80    	cmp    $0x80113d74,%ebx
80103909:	74 75                	je     80103980 <allocproc+0xa0>
    if(p->state == UNUSED)
8010390b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010390e:	85 c0                	test   %eax,%eax
80103910:	75 ee                	jne    80103900 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103912:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103917:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010391a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103921:	89 43 10             	mov    %eax,0x10(%ebx)
80103924:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103927:	68 40 1d 11 80       	push   $0x80111d40
  p->pid = nextpid++;
8010392c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103932:	e8 59 0f 00 00       	call   80104890 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103937:	e8 74 ee ff ff       	call   801027b0 <kalloc>
8010393c:	83 c4 10             	add    $0x10,%esp
8010393f:	89 43 08             	mov    %eax,0x8(%ebx)
80103942:	85 c0                	test   %eax,%eax
80103944:	74 53                	je     80103999 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103946:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010394c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010394f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103954:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103957:	c7 40 14 df 5b 10 80 	movl   $0x80105bdf,0x14(%eax)
  p->context = (struct context*)sp;
8010395e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103961:	6a 14                	push   $0x14
80103963:	6a 00                	push   $0x0
80103965:	50                   	push   %eax
80103966:	e8 75 0f 00 00       	call   801048e0 <memset>
  p->context->eip = (uint)forkret;
8010396b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010396e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103971:	c7 40 10 b0 39 10 80 	movl   $0x801039b0,0x10(%eax)
}
80103978:	89 d8                	mov    %ebx,%eax
8010397a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397d:	c9                   	leave  
8010397e:	c3                   	ret    
8010397f:	90                   	nop
  release(&ptable.lock);
80103980:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103983:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103985:	68 40 1d 11 80       	push   $0x80111d40
8010398a:	e8 01 0f 00 00       	call   80104890 <release>
}
8010398f:	89 d8                	mov    %ebx,%eax
  return 0;
80103991:	83 c4 10             	add    $0x10,%esp
}
80103994:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103997:	c9                   	leave  
80103998:	c3                   	ret    
    p->state = UNUSED;
80103999:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801039a0:	31 db                	xor    %ebx,%ebx
}
801039a2:	89 d8                	mov    %ebx,%eax
801039a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a7:	c9                   	leave  
801039a8:	c3                   	ret    
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039b6:	68 40 1d 11 80       	push   $0x80111d40
801039bb:	e8 d0 0e 00 00       	call   80104890 <release>

  if (first) {
801039c0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	85 c0                	test   %eax,%eax
801039ca:	75 04                	jne    801039d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    
801039ce:	66 90                	xchg   %ax,%ax
    first = 0;
801039d0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039d7:	00 00 00 
    iinit(ROOTDEV);
801039da:	83 ec 0c             	sub    $0xc,%esp
801039dd:	6a 01                	push   $0x1
801039df:	e8 ac dc ff ff       	call   80101690 <iinit>
    initlog(ROOTDEV);
801039e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039eb:	e8 00 f4 ff ff       	call   80102df0 <initlog>
}
801039f0:	83 c4 10             	add    $0x10,%esp
801039f3:	c9                   	leave  
801039f4:	c3                   	ret    
801039f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a00 <pinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a06:	68 80 7a 10 80       	push   $0x80107a80
80103a0b:	68 40 1d 11 80       	push   $0x80111d40
80103a10:	e8 4b 0c 00 00       	call   80104660 <initlock>
}
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	c9                   	leave  
80103a19:	c3                   	ret    
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a20 <mycpu>:
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a25:	9c                   	pushf  
80103a26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a27:	f6 c4 02             	test   $0x2,%ah
80103a2a:	75 4e                	jne    80103a7a <mycpu+0x5a>
  apicid = lapicid();
80103a2c:	e8 ef ef ff ff       	call   80102a20 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a31:	8b 35 84 17 11 80    	mov    0x80111784,%esi
  apicid = lapicid();
80103a37:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103a39:	85 f6                	test   %esi,%esi
80103a3b:	7e 30                	jle    80103a6d <mycpu+0x4d>
80103a3d:	31 c0                	xor    %eax,%eax
80103a3f:	eb 0e                	jmp    80103a4f <mycpu+0x2f>
80103a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a48:	83 c0 01             	add    $0x1,%eax
80103a4b:	39 f0                	cmp    %esi,%eax
80103a4d:	74 1e                	je     80103a6d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103a4f:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103a55:	0f b6 8a a0 17 11 80 	movzbl -0x7feee860(%edx),%ecx
80103a5c:	39 d9                	cmp    %ebx,%ecx
80103a5e:	75 e8                	jne    80103a48 <mycpu+0x28>
}
80103a60:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a63:	8d 82 a0 17 11 80    	lea    -0x7feee860(%edx),%eax
}
80103a69:	5b                   	pop    %ebx
80103a6a:	5e                   	pop    %esi
80103a6b:	5d                   	pop    %ebp
80103a6c:	c3                   	ret    
  panic("unknown apicid\n");
80103a6d:	83 ec 0c             	sub    $0xc,%esp
80103a70:	68 87 7a 10 80       	push   $0x80107a87
80103a75:	e8 06 c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a7a:	83 ec 0c             	sub    $0xc,%esp
80103a7d:	68 80 7b 10 80       	push   $0x80107b80
80103a82:	e8 f9 c8 ff ff       	call   80100380 <panic>
80103a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <cpuid>:
cpuid() {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a96:	e8 85 ff ff ff       	call   80103a20 <mycpu>
}
80103a9b:	c9                   	leave  
  return mycpu()-cpus;
80103a9c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret    
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <myproc>:
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 64 0c 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103abc:	e8 5f ff ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 64 0d 00 00       	call   80104830 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave  
80103ad2:	c3                   	ret    
80103ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <userinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ae7:	e8 f4 fd ff ff       	call   801038e0 <allocproc>
80103aec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103aee:	a3 74 3d 11 80       	mov    %eax,0x80113d74
  if((p->pgdir = setupkvm()) == 0)
80103af3:	e8 f8 36 00 00       	call   801071f0 <setupkvm>
80103af8:	89 43 04             	mov    %eax,0x4(%ebx)
80103afb:	85 c0                	test   %eax,%eax
80103afd:	0f 84 bd 00 00 00    	je     80103bc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b03:	83 ec 04             	sub    $0x4,%esp
80103b06:	68 2c 00 00 00       	push   $0x2c
80103b0b:	68 60 a4 10 80       	push   $0x8010a460
80103b10:	50                   	push   %eax
80103b11:	e8 8a 33 00 00       	call   80106ea0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b1f:	6a 4c                	push   $0x4c
80103b21:	6a 00                	push   $0x0
80103b23:	ff 73 18             	pushl  0x18(%ebx)
80103b26:	e8 b5 0d 00 00       	call   801048e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b51:	8b 43 18             	mov    0x18(%ebx),%eax
80103b54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b70:	8b 43 18             	mov    0x18(%ebx),%eax
80103b73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b7d:	6a 10                	push   $0x10
80103b7f:	68 b0 7a 10 80       	push   $0x80107ab0
80103b84:	50                   	push   %eax
80103b85:	e8 16 0f 00 00       	call   80104aa0 <safestrcpy>
  p->cwd = namei("/");
80103b8a:	c7 04 24 b9 7a 10 80 	movl   $0x80107ab9,(%esp)
80103b91:	e8 3a e6 ff ff       	call   801021d0 <namei>
80103b96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b99:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103ba0:	e8 cb 0b 00 00       	call   80104770 <acquire>
  p->state = RUNNABLE;
80103ba5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bac:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103bb3:	e8 d8 0c 00 00       	call   80104890 <release>
}
80103bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bbb:	83 c4 10             	add    $0x10,%esp
80103bbe:	c9                   	leave  
80103bbf:	c3                   	ret    
    panic("userinit: out of memory?");
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	68 97 7a 10 80       	push   $0x80107a97
80103bc8:	e8 b3 c7 ff ff       	call   80100380 <panic>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <growproc>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bd8:	e8 43 0b 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103bdd:	e8 3e fe ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103be2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be8:	e8 43 0c 00 00       	call   80104830 <popcli>
  sz = curproc->sz;
80103bed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bef:	85 f6                	test   %esi,%esi
80103bf1:	7f 1d                	jg     80103c10 <growproc+0x40>
  } else if(n < 0){
80103bf3:	75 3b                	jne    80103c30 <growproc+0x60>
  switchuvm(curproc);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bf8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bfa:	53                   	push   %ebx
80103bfb:	e8 90 31 00 00       	call   80106d90 <switchuvm>
  return 0;
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	31 c0                	xor    %eax,%eax
}
80103c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c08:	5b                   	pop    %ebx
80103c09:	5e                   	pop    %esi
80103c0a:	5d                   	pop    %ebp
80103c0b:	c3                   	ret    
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	pushl  0x4(%ebx)
80103c1a:	e8 f1 33 00 00       	call   80107010 <allocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 cf                	jne    80103bf5 <growproc+0x25>
      return -1;
80103c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c2b:	eb d8                	jmp    80103c05 <growproc+0x35>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	pushl  0x4(%ebx)
80103c3a:	e8 01 35 00 00       	call   80107140 <deallocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 af                	jne    80103bf5 <growproc+0x25>
80103c46:	eb de                	jmp    80103c26 <growproc+0x56>
80103c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4f:	90                   	nop

80103c50 <scheduler>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103c59:	e8 c2 fd ff ff       	call   80103a20 <mycpu>
  c->proc = 0;
80103c5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c65:	00 00 00 
  struct cpu *c = mycpu();
80103c68:	89 c3                	mov    %eax,%ebx
  int ran = 0; // CS 350/550: to solve the 100%-CPU-utilization-when-idling problem
80103c6a:	8d 70 04             	lea    0x4(%eax),%esi
80103c6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c70:	fb                   	sti    
    acquire(&ptable.lock);
80103c71:	83 ec 0c             	sub    $0xc,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c74:	bf 74 1d 11 80       	mov    $0x80111d74,%edi
    acquire(&ptable.lock);
80103c79:	68 40 1d 11 80       	push   $0x80111d40
80103c7e:	e8 ed 0a 00 00       	call   80104770 <acquire>
80103c83:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80103c86:	31 c0                	xor    %eax,%eax
80103c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
      if (p->state != RUNNABLE)
80103c90:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103c94:	75 41                	jne    80103cd7 <scheduler+0x87>
      if (policy == 1)
80103c96:	83 3d 20 1d 11 80 01 	cmpl   $0x1,0x80111d20
80103c9d:	74 71                	je     80103d10 <scheduler+0xc0>
      switchuvm(p);
80103c9f:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ca2:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103ca8:	57                   	push   %edi
80103ca9:	e8 e2 30 00 00       	call   80106d90 <switchuvm>
      p->state = RUNNING;
80103cae:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103cb5:	58                   	pop    %eax
80103cb6:	5a                   	pop    %edx
80103cb7:	ff 77 1c             	pushl  0x1c(%edi)
80103cba:	56                   	push   %esi
80103cbb:	e8 3b 0e 00 00       	call   80104afb <swtch>
      switchkvm();
80103cc0:	e8 bb 30 00 00       	call   80106d80 <switchkvm>
      c->proc = 0;
80103cc5:	83 c4 10             	add    $0x10,%esp
      ran = 1;
80103cc8:	b8 01 00 00 00       	mov    $0x1,%eax
      c->proc = 0;
80103ccd:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103cd4:	00 00 00 
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cd7:	83 ef 80             	sub    $0xffffff80,%edi
80103cda:	81 ff 74 3d 11 80    	cmp    $0x80113d74,%edi
80103ce0:	72 ae                	jb     80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103ce2:	83 ec 0c             	sub    $0xc,%esp
80103ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ce8:	68 40 1d 11 80       	push   $0x80111d40
80103ced:	e8 9e 0b 00 00       	call   80104890 <release>
    if (ran == 0)
80103cf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cf5:	83 c4 10             	add    $0x10,%esp
80103cf8:	85 c0                	test   %eax,%eax
80103cfa:	0f 85 70 ff ff ff    	jne    80103c70 <scheduler+0x20>

// CS 350/550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
    asm volatile("hlt" : : :"memory");
80103d00:	f4                   	hlt    
}
80103d01:	e9 6a ff ff ff       	jmp    80103c70 <scheduler+0x20>
80103d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
        for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
80103d10:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103d15:	8d 76 00             	lea    0x0(%esi),%esi
          if (p1->state != RUNNABLE)
80103d18:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d1c:	75 09                	jne    80103d27 <scheduler+0xd7>
          if ((p1->state == RUNNABLE) && (highPriority->priority < p1->priority))
80103d1e:	8b 50 7c             	mov    0x7c(%eax),%edx
80103d21:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103d24:	0f 4c f8             	cmovl  %eax,%edi
        for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
80103d27:	83 e8 80             	sub    $0xffffff80,%eax
80103d2a:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80103d2f:	75 e7                	jne    80103d18 <scheduler+0xc8>
80103d31:	e9 69 ff ff ff       	jmp    80103c9f <scheduler+0x4f>
80103d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi

80103d40 <sched>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
  pushcli();
80103d45:	e8 d6 09 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103d4a:	e8 d1 fc ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103d4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d55:	e8 d6 0a 00 00       	call   80104830 <popcli>
  if(!holding(&ptable.lock))
80103d5a:	83 ec 0c             	sub    $0xc,%esp
80103d5d:	68 40 1d 11 80       	push   $0x80111d40
80103d62:	e8 79 09 00 00       	call   801046e0 <holding>
80103d67:	83 c4 10             	add    $0x10,%esp
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	74 4f                	je     80103dbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103d6e:	e8 ad fc ff ff       	call   80103a20 <mycpu>
80103d73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d7a:	75 68                	jne    80103de4 <sched+0xa4>
  if(p->state == RUNNING)
80103d7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d80:	74 55                	je     80103dd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d82:	9c                   	pushf  
80103d83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d84:	f6 c4 02             	test   $0x2,%ah
80103d87:	75 41                	jne    80103dca <sched+0x8a>
  intena = mycpu()->intena;
80103d89:	e8 92 fc ff ff       	call   80103a20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d97:	e8 84 fc ff ff       	call   80103a20 <mycpu>
80103d9c:	83 ec 08             	sub    $0x8,%esp
80103d9f:	ff 70 04             	pushl  0x4(%eax)
80103da2:	53                   	push   %ebx
80103da3:	e8 53 0d 00 00       	call   80104afb <swtch>
  mycpu()->intena = intena;
80103da8:	e8 73 fc ff ff       	call   80103a20 <mycpu>
}
80103dad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103db0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103db6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db9:	5b                   	pop    %ebx
80103dba:	5e                   	pop    %esi
80103dbb:	5d                   	pop    %ebp
80103dbc:	c3                   	ret    
    panic("sched ptable.lock");
80103dbd:	83 ec 0c             	sub    $0xc,%esp
80103dc0:	68 bb 7a 10 80       	push   $0x80107abb
80103dc5:	e8 b6 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 e7 7a 10 80       	push   $0x80107ae7
80103dd2:	e8 a9 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103dd7:	83 ec 0c             	sub    $0xc,%esp
80103dda:	68 d9 7a 10 80       	push   $0x80107ad9
80103ddf:	e8 9c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	68 cd 7a 10 80       	push   $0x80107acd
80103dec:	e8 8f c5 ff ff       	call   80100380 <panic>
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <exit>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e09:	e8 a2 fc ff ff       	call   80103ab0 <myproc>
  if(curproc == initproc)
80103e0e:	39 05 74 3d 11 80    	cmp    %eax,0x80113d74
80103e14:	0f 84 fd 00 00 00    	je     80103f17 <exit+0x117>
80103e1a:	89 c3                	mov    %eax,%ebx
80103e1c:	8d 70 28             	lea    0x28(%eax),%esi
80103e1f:	8d 78 68             	lea    0x68(%eax),%edi
80103e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e28:	8b 06                	mov    (%esi),%eax
80103e2a:	85 c0                	test   %eax,%eax
80103e2c:	74 12                	je     80103e40 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	50                   	push   %eax
80103e32:	e8 d9 d1 ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
80103e37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e3d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e40:	83 c6 04             	add    $0x4,%esi
80103e43:	39 f7                	cmp    %esi,%edi
80103e45:	75 e1                	jne    80103e28 <exit+0x28>
  begin_op();
80103e47:	e8 44 f0 ff ff       	call   80102e90 <begin_op>
  iput(curproc->cwd);
80103e4c:	83 ec 0c             	sub    $0xc,%esp
80103e4f:	ff 73 68             	pushl  0x68(%ebx)
80103e52:	e8 89 db ff ff       	call   801019e0 <iput>
  end_op();
80103e57:	e8 a4 f0 ff ff       	call   80102f00 <end_op>
  curproc->cwd = 0;
80103e5c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e63:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103e6a:	e8 01 09 00 00       	call   80104770 <acquire>
  wakeup1(curproc->parent);
80103e6f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e72:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e75:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103e7a:	eb 0e                	jmp    80103e8a <exit+0x8a>
80103e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e80:	83 e8 80             	sub    $0xffffff80,%eax
80103e83:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80103e88:	74 1c                	je     80103ea6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0x80>
80103e90:	3b 50 20             	cmp    0x20(%eax),%edx
80103e93:	75 eb                	jne    80103e80 <exit+0x80>
      p->state = RUNNABLE;
80103e95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	83 e8 80             	sub    $0xffffff80,%eax
80103e9f:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80103ea4:	75 e4                	jne    80103e8a <exit+0x8a>
      p->parent = initproc;
80103ea6:	8b 0d 74 3d 11 80    	mov    0x80113d74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eac:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80103eb1:	eb 10                	jmp    80103ec3 <exit+0xc3>
80103eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eb7:	90                   	nop
80103eb8:	83 ea 80             	sub    $0xffffff80,%edx
80103ebb:	81 fa 74 3d 11 80    	cmp    $0x80113d74,%edx
80103ec1:	74 3b                	je     80103efe <exit+0xfe>
    if(p->parent == curproc){
80103ec3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103ec6:	75 f0                	jne    80103eb8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ec8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103ecc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ecf:	75 e7                	jne    80103eb8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed1:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103ed6:	eb 12                	jmp    80103eea <exit+0xea>
80103ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop
80103ee0:	83 e8 80             	sub    $0xffffff80,%eax
80103ee3:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80103ee8:	74 ce                	je     80103eb8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0xe0>
80103ef0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ef3:	75 eb                	jne    80103ee0 <exit+0xe0>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103efc:	eb e2                	jmp    80103ee0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103efe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f05:	e8 36 fe ff ff       	call   80103d40 <sched>
  panic("zombie exit");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 08 7b 10 80       	push   $0x80107b08
80103f12:	e8 69 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f17:	83 ec 0c             	sub    $0xc,%esp
80103f1a:	68 fb 7a 10 80       	push   $0x80107afb
80103f1f:	e8 5c c4 ff ff       	call   80100380 <panic>
80103f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f2f:	90                   	nop

80103f30 <wait>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
  pushcli();
80103f35:	e8 e6 07 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103f3a:	e8 e1 fa ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103f3f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f45:	e8 e6 08 00 00       	call   80104830 <popcli>
  acquire(&ptable.lock);
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 40 1d 11 80       	push   $0x80111d40
80103f52:	e8 19 08 00 00       	call   80104770 <acquire>
80103f57:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f5a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
80103f61:	eb 10                	jmp    80103f73 <wait+0x43>
80103f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f67:	90                   	nop
80103f68:	83 eb 80             	sub    $0xffffff80,%ebx
80103f6b:	81 fb 74 3d 11 80    	cmp    $0x80113d74,%ebx
80103f71:	74 1b                	je     80103f8e <wait+0x5e>
      if(p->parent != curproc)
80103f73:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f76:	75 f0                	jne    80103f68 <wait+0x38>
      if(p->state == ZOMBIE){
80103f78:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f7c:	74 62                	je     80103fe0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103f81:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f86:	81 fb 74 3d 11 80    	cmp    $0x80113d74,%ebx
80103f8c:	75 e5                	jne    80103f73 <wait+0x43>
    if(!havekids || curproc->killed){
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	0f 84 a0 00 00 00    	je     80104036 <wait+0x106>
80103f96:	8b 46 24             	mov    0x24(%esi),%eax
80103f99:	85 c0                	test   %eax,%eax
80103f9b:	0f 85 95 00 00 00    	jne    80104036 <wait+0x106>
  pushcli();
80103fa1:	e8 7a 07 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103fa6:	e8 75 fa ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80103fab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb1:	e8 7a 08 00 00       	call   80104830 <popcli>
  if(p == 0)
80103fb6:	85 db                	test   %ebx,%ebx
80103fb8:	0f 84 8f 00 00 00    	je     8010404d <wait+0x11d>
  p->chan = chan;
80103fbe:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103fc1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fc8:	e8 73 fd ff ff       	call   80103d40 <sched>
  p->chan = 0;
80103fcd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fd4:	eb 84                	jmp    80103f5a <wait+0x2a>
80103fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103fe3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fe6:	ff 73 08             	pushl  0x8(%ebx)
80103fe9:	e8 02 e6 ff ff       	call   801025f0 <kfree>
        p->kstack = 0;
80103fee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ff5:	5a                   	pop    %edx
80103ff6:	ff 73 04             	pushl  0x4(%ebx)
80103ff9:	e8 72 31 00 00       	call   80107170 <freevm>
        p->pid = 0;
80103ffe:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104005:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010400c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104010:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104017:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010401e:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80104025:	e8 66 08 00 00       	call   80104890 <release>
        return pid;
8010402a:	83 c4 10             	add    $0x10,%esp
}
8010402d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104030:	89 f0                	mov    %esi,%eax
80104032:	5b                   	pop    %ebx
80104033:	5e                   	pop    %esi
80104034:	5d                   	pop    %ebp
80104035:	c3                   	ret    
      release(&ptable.lock);
80104036:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104039:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010403e:	68 40 1d 11 80       	push   $0x80111d40
80104043:	e8 48 08 00 00       	call   80104890 <release>
      return -1;
80104048:	83 c4 10             	add    $0x10,%esp
8010404b:	eb e0                	jmp    8010402d <wait+0xfd>
    panic("sleep");
8010404d:	83 ec 0c             	sub    $0xc,%esp
80104050:	68 14 7b 10 80       	push   $0x80107b14
80104055:	e8 26 c3 ff ff       	call   80100380 <panic>
8010405a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104060 <yield>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 04             	sub    $0x4,%esp
  if (sched_trace_enabled)
80104067:	a1 2c 1d 11 80       	mov    0x80111d2c,%eax
8010406c:	85 c0                	test   %eax,%eax
8010406e:	75 48                	jne    801040b8 <yield+0x58>
  acquire(&ptable.lock);  //DOC: yieldlock
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	68 40 1d 11 80       	push   $0x80111d40
80104078:	e8 f3 06 00 00       	call   80104770 <acquire>
  pushcli();
8010407d:	e8 9e 06 00 00       	call   80104720 <pushcli>
  c = mycpu();
80104082:	e8 99 f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104087:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010408d:	e8 9e 07 00 00       	call   80104830 <popcli>
  myproc()->state = RUNNABLE;
80104092:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104099:	e8 a2 fc ff ff       	call   80103d40 <sched>
  release(&ptable.lock);
8010409e:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801040a5:	e8 e6 07 00 00       	call   80104890 <release>
}
801040aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040ad:	83 c4 10             	add    $0x10,%esp
801040b0:	c9                   	leave  
801040b1:	c3                   	ret    
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  pushcli();
801040b8:	e8 63 06 00 00       	call   80104720 <pushcli>
  c = mycpu();
801040bd:	e8 5e f9 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
801040c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c8:	e8 63 07 00 00       	call   80104830 <popcli>
    cprintf("%d", myproc()->pid);
801040cd:	83 ec 08             	sub    $0x8,%esp
801040d0:	ff 73 10             	pushl  0x10(%ebx)
801040d3:	68 1a 7b 10 80       	push   $0x80107b1a
801040d8:	e8 a3 c5 ff ff       	call   80100680 <cprintf>
    sched_trace_counter++;
801040dd:	a1 28 1d 11 80       	mov    0x80111d28,%eax
801040e2:	83 c4 10             	add    $0x10,%esp
801040e5:	83 c0 01             	add    $0x1,%eax
801040e8:	a3 28 1d 11 80       	mov    %eax,0x80111d28
801040ed:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
801040f3:	05 98 99 99 19       	add    $0x19999998,%eax
801040f8:	c1 c8 02             	ror    $0x2,%eax
    if (sched_trace_counter % 20 == 0)
801040fb:	3d cc cc cc 0c       	cmp    $0xccccccc,%eax
80104100:	77 1e                	ja     80104120 <yield+0xc0>
      cprintf("\n");
80104102:	83 ec 0c             	sub    $0xc,%esp
80104105:	68 09 7d 10 80       	push   $0x80107d09
8010410a:	e8 71 c5 ff ff       	call   80100680 <cprintf>
8010410f:	83 c4 10             	add    $0x10,%esp
80104112:	e9 59 ff ff ff       	jmp    80104070 <yield+0x10>
80104117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411e:	66 90                	xchg   %ax,%ax
      cprintf(" - ");
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	68 1d 7b 10 80       	push   $0x80107b1d
80104128:	e8 53 c5 ff ff       	call   80100680 <cprintf>
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	e9 3b ff ff ff       	jmp    80104070 <yield+0x10>
80104135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <fork>:
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	56                   	push   %esi
80104145:	53                   	push   %ebx
80104146:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104149:	e8 d2 05 00 00       	call   80104720 <pushcli>
  c = mycpu();
8010414e:	e8 cd f8 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104153:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104159:	e8 d2 06 00 00       	call   80104830 <popcli>
  if((np = allocproc()) == 0){
8010415e:	e8 7d f7 ff ff       	call   801038e0 <allocproc>
80104163:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104166:	85 c0                	test   %eax,%eax
80104168:	0f 84 d1 00 00 00    	je     8010423f <fork+0xff>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010416e:	83 ec 08             	sub    $0x8,%esp
80104171:	ff 33                	pushl  (%ebx)
80104173:	89 c7                	mov    %eax,%edi
80104175:	ff 73 04             	pushl  0x4(%ebx)
80104178:	e8 63 31 00 00       	call   801072e0 <copyuvm>
8010417d:	83 c4 10             	add    $0x10,%esp
80104180:	89 47 04             	mov    %eax,0x4(%edi)
80104183:	85 c0                	test   %eax,%eax
80104185:	0f 84 bb 00 00 00    	je     80104246 <fork+0x106>
  np->sz = curproc->sz;
8010418b:	8b 03                	mov    (%ebx),%eax
8010418d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104190:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104192:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104195:	89 c8                	mov    %ecx,%eax
80104197:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010419a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010419f:	8b 73 18             	mov    0x18(%ebx),%esi
801041a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801041a4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801041a6:	8b 40 18             	mov    0x18(%eax),%eax
801041a9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801041b0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801041b4:	85 c0                	test   %eax,%eax
801041b6:	74 13                	je     801041cb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	50                   	push   %eax
801041bc:	e8 ff cd ff ff       	call   80100fc0 <filedup>
801041c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041c4:	83 c4 10             	add    $0x10,%esp
801041c7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801041cb:	83 c6 01             	add    $0x1,%esi
801041ce:	83 fe 10             	cmp    $0x10,%esi
801041d1:	75 dd                	jne    801041b0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041d9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801041dc:	e8 9f d6 ff ff       	call   80101880 <idup>
801041e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041e4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801041e7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801041ea:	8d 47 6c             	lea    0x6c(%edi),%eax
801041ed:	6a 10                	push   $0x10
801041ef:	53                   	push   %ebx
801041f0:	50                   	push   %eax
801041f1:	e8 aa 08 00 00       	call   80104aa0 <safestrcpy>
  pid = np->pid;
801041f6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801041f9:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80104200:	e8 6b 05 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80104205:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010420c:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80104213:	e8 78 06 00 00       	call   80104890 <release>
  if(child_first == 1)
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	83 3d 24 1d 11 80 01 	cmpl   $0x1,0x80111d24
80104222:	74 0c                	je     80104230 <fork+0xf0>
}
80104224:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104227:	89 d8                	mov    %ebx,%eax
80104229:	5b                   	pop    %ebx
8010422a:	5e                   	pop    %esi
8010422b:	5f                   	pop    %edi
8010422c:	5d                   	pop    %ebp
8010422d:	c3                   	ret    
8010422e:	66 90                	xchg   %ax,%ax
    yield();
80104230:	e8 2b fe ff ff       	call   80104060 <yield>
}
80104235:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104238:	89 d8                	mov    %ebx,%eax
8010423a:	5b                   	pop    %ebx
8010423b:	5e                   	pop    %esi
8010423c:	5f                   	pop    %edi
8010423d:	5d                   	pop    %ebp
8010423e:	c3                   	ret    
    return -1;
8010423f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104244:	eb de                	jmp    80104224 <fork+0xe4>
    kfree(np->kstack);
80104246:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104249:	83 ec 0c             	sub    $0xc,%esp
8010424c:	ff 73 08             	pushl  0x8(%ebx)
8010424f:	e8 9c e3 ff ff       	call   801025f0 <kfree>
    np->kstack = 0;
80104254:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
8010425b:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010425e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104265:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010426a:	eb b8                	jmp    80104224 <fork+0xe4>
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <sleep>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010427c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010427f:	e8 9c 04 00 00       	call   80104720 <pushcli>
  c = mycpu();
80104284:	e8 97 f7 ff ff       	call   80103a20 <mycpu>
  p = c->proc;
80104289:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010428f:	e8 9c 05 00 00       	call   80104830 <popcli>
  if(p == 0)
80104294:	85 db                	test   %ebx,%ebx
80104296:	0f 84 87 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
8010429c:	85 f6                	test   %esi,%esi
8010429e:	74 76                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a0:	81 fe 40 1d 11 80    	cmp    $0x80111d40,%esi
801042a6:	74 50                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 40 1d 11 80       	push   $0x80111d40
801042b0:	e8 bb 04 00 00       	call   80104770 <acquire>
    release(lk);
801042b5:	89 34 24             	mov    %esi,(%esp)
801042b8:	e8 d3 05 00 00       	call   80104890 <release>
  p->chan = chan;
801042bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042c7:	e8 74 fa ff ff       	call   80103d40 <sched>
  p->chan = 0;
801042cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d3:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801042da:	e8 b1 05 00 00       	call   80104890 <release>
    acquire(lk);
801042df:	89 75 08             	mov    %esi,0x8(%ebp)
801042e2:	83 c4 10             	add    $0x10,%esp
}
801042e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e8:	5b                   	pop    %ebx
801042e9:	5e                   	pop    %esi
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
    acquire(lk);
801042ec:	e9 7f 04 00 00       	jmp    80104770 <acquire>
801042f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 39 fa ff ff       	call   80103d40 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 21 7b 10 80       	push   $0x80107b21
8010431e:	e8 5d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 14 7b 10 80       	push   $0x80107b14
8010432b:	e8 50 c0 ff ff       	call   80100380 <panic>

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433a:	68 40 1d 11 80       	push   $0x80111d40
8010433f:	e8 2c 04 00 00       	call   80104770 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104347:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
8010434c:	eb 0c                	jmp    8010435a <wakeup+0x2a>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	83 e8 80             	sub    $0xffffff80,%eax
80104353:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80104358:	74 1c                	je     80104376 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <wakeup+0x20>
80104360:	3b 58 20             	cmp    0x20(%eax),%ebx
80104363:	75 eb                	jne    80104350 <wakeup+0x20>
      p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436c:	83 e8 80             	sub    $0xffffff80,%eax
8010436f:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80104374:	75 e4                	jne    8010435a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104376:	c7 45 08 40 1d 11 80 	movl   $0x80111d40,0x8(%ebp)
}
8010437d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104380:	c9                   	leave  
  release(&ptable.lock);
80104381:	e9 0a 05 00 00       	jmp    80104890 <release>
80104386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 40 1d 11 80       	push   $0x80111d40
8010439f:	e8 cc 03 00 00       	call   80104770 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a7:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
801043ac:	eb 0c                	jmp    801043ba <kill+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 e8 80             	sub    $0xffffff80,%eax
801043b3:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
801043b8:	74 36                	je     801043f0 <kill+0x60>
    if(p->pid == pid){
801043ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801043bd:	75 f1                	jne    801043b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ca:	75 07                	jne    801043d3 <kill+0x43>
        p->state = RUNNABLE;
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 40 1d 11 80       	push   $0x80111d40
801043db:	e8 b0 04 00 00       	call   80104890 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043e3:	83 c4 10             	add    $0x10,%esp
801043e6:	31 c0                	xor    %eax,%eax
}
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 40 1d 11 80       	push   $0x80111d40
801043f8:	e8 93 04 00 00       	call   80104890 <release>
}
801043fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104418:	53                   	push   %ebx
80104419:	bb e0 1d 11 80       	mov    $0x80111de0,%ebx
8010441e:	83 ec 3c             	sub    $0x3c,%esp
80104421:	eb 24                	jmp    80104447 <procdump+0x37>
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 09 7d 10 80       	push   $0x80107d09
80104430:	e8 4b c2 ff ff       	call   80100680 <cprintf>
80104435:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104438:	83 eb 80             	sub    $0xffffff80,%ebx
8010443b:	81 fb e0 3d 11 80    	cmp    $0x80113de0,%ebx
80104441:	0f 84 81 00 00 00    	je     801044c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104447:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 ea                	je     80104438 <procdump+0x28>
      state = "???";
8010444e:	ba 32 7b 10 80       	mov    $0x80107b32,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104453:	83 f8 05             	cmp    $0x5,%eax
80104456:	77 11                	ja     80104469 <procdump+0x59>
80104458:	8b 14 85 a8 7b 10 80 	mov    -0x7fef8458(,%eax,4),%edx
      state = "???";
8010445f:	b8 32 7b 10 80       	mov    $0x80107b32,%eax
80104464:	85 d2                	test   %edx,%edx
80104466:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104469:	53                   	push   %ebx
8010446a:	52                   	push   %edx
8010446b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010446e:	68 36 7b 10 80       	push   $0x80107b36
80104473:	e8 08 c2 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010447f:	75 a7                	jne    80104428 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104481:	83 ec 08             	sub    $0x8,%esp
80104484:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104487:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010448a:	50                   	push   %eax
8010448b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010448e:	8b 40 0c             	mov    0xc(%eax),%eax
80104491:	83 c0 08             	add    $0x8,%eax
80104494:	50                   	push   %eax
80104495:	e8 e6 01 00 00       	call   80104680 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010449a:	83 c4 10             	add    $0x10,%esp
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
801044a0:	8b 17                	mov    (%edi),%edx
801044a2:	85 d2                	test   %edx,%edx
801044a4:	74 82                	je     80104428 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801044ac:	52                   	push   %edx
801044ad:	68 81 75 10 80       	push   $0x80107581
801044b2:	e8 c9 c1 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	39 fe                	cmp    %edi,%esi
801044bc:	75 e2                	jne    801044a0 <procdump+0x90>
801044be:	e9 65 ff ff ff       	jmp    80104428 <procdump+0x18>
801044c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c7:	90                   	nop
  }
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	5b                   	pop    %ebx
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <setpriority>:

int
setpriority(int pid, int priority)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	8b 75 0c             	mov    0xc(%ebp),%esi
801044d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  
  acquire(&tickslock);
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	68 a0 3d 11 80       	push   $0x80113da0
801044e3:	e8 88 02 00 00       	call   80104770 <acquire>
  acquire(&ptable.lock);
801044e8:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801044ef:	e8 7c 02 00 00       	call   80104770 <acquire>
801044f4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044f7:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
801044fc:	eb 0c                	jmp    8010450a <setpriority+0x3a>
801044fe:	66 90                	xchg   %ax,%ax
80104500:	83 e8 80             	sub    $0xffffff80,%eax
80104503:	3d 74 3d 11 80       	cmp    $0x80113d74,%eax
80104508:	74 1a                	je     80104524 <setpriority+0x54>
  {
    if (p->pid == pid)
8010450a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010450d:	75 f1                	jne    80104500 <setpriority+0x30>
    {
      p->priority = priority;
      cprintf("\nPID:%d\tPriority:%d\n", p->pid, p->priority);
8010450f:	83 ec 04             	sub    $0x4,%esp
      p->priority = priority;
80104512:	89 70 7c             	mov    %esi,0x7c(%eax)
      cprintf("\nPID:%d\tPriority:%d\n", p->pid, p->priority);
80104515:	56                   	push   %esi
80104516:	53                   	push   %ebx
80104517:	68 3f 7b 10 80       	push   $0x80107b3f
8010451c:	e8 5f c1 ff ff       	call   80100680 <cprintf>
      break;
80104521:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	68 40 1d 11 80       	push   $0x80111d40
8010452c:	e8 5f 03 00 00       	call   80104890 <release>
  release(&tickslock);
80104531:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104538:	e8 53 03 00 00       	call   80104890 <release>

  return pid;
}
8010453d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104540:	89 d8                	mov    %ebx,%eax
80104542:	5b                   	pop    %ebx
80104543:	5e                   	pop    %esi
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    
80104546:	66 90                	xchg   %ax,%ax
80104548:	66 90                	xchg   %ax,%ax
8010454a:	66 90                	xchg   %ax,%ax
8010454c:	66 90                	xchg   %ax,%ax
8010454e:	66 90                	xchg   %ax,%ax

80104550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010455a:	68 c0 7b 10 80       	push   $0x80107bc0
8010455f:	8d 43 04             	lea    0x4(%ebx),%eax
80104562:	50                   	push   %eax
80104563:	e8 f8 00 00 00       	call   80104660 <initlock>
  lk->name = name;
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010456b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010457b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010457e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104581:	c9                   	leave  
80104582:	c3                   	ret    
80104583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	8d 73 04             	lea    0x4(%ebx),%esi
8010459b:	83 ec 0c             	sub    $0xc,%esp
8010459e:	56                   	push   %esi
8010459f:	e8 cc 01 00 00       	call   80104770 <acquire>
  while (lk->locked) {
801045a4:	8b 13                	mov    (%ebx),%edx
801045a6:	83 c4 10             	add    $0x10,%esp
801045a9:	85 d2                	test   %edx,%edx
801045ab:	74 16                	je     801045c3 <acquiresleep+0x33>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	e8 b6 fc ff ff       	call   80104270 <sleep>
  while (lk->locked) {
801045ba:	8b 03                	mov    (%ebx),%eax
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 ed                	jne    801045b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045c9:	e8 e2 f4 ff ff       	call   80103ab0 <myproc>
801045ce:	8b 40 10             	mov    0x10(%eax),%eax
801045d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045da:	5b                   	pop    %ebx
801045db:	5e                   	pop    %esi
801045dc:	5d                   	pop    %ebp
  release(&lk->lk);
801045dd:	e9 ae 02 00 00       	jmp    80104890 <release>
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	8d 73 04             	lea    0x4(%ebx),%esi
801045fb:	83 ec 0c             	sub    $0xc,%esp
801045fe:	56                   	push   %esi
801045ff:	e8 6c 01 00 00       	call   80104770 <acquire>
  lk->locked = 0;
80104604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010460a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104611:	89 1c 24             	mov    %ebx,(%esp)
80104614:	e8 17 fd ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
80104619:	89 75 08             	mov    %esi,0x8(%ebp)
8010461c:	83 c4 10             	add    $0x10,%esp
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
  release(&lk->lk);
80104625:	e9 66 02 00 00       	jmp    80104890 <release>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104638:	8d 5e 04             	lea    0x4(%esi),%ebx
8010463b:	83 ec 0c             	sub    $0xc,%esp
8010463e:	53                   	push   %ebx
8010463f:	e8 2c 01 00 00       	call   80104770 <acquire>
  r = lk->locked;
80104644:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104646:	89 1c 24             	mov    %ebx,(%esp)
80104649:	e8 42 02 00 00       	call   80104890 <release>
  return r;
}
8010464e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104651:	89 f0                	mov    %esi,%eax
80104653:	5b                   	pop    %ebx
80104654:	5e                   	pop    %esi
80104655:	5d                   	pop    %ebp
80104656:	c3                   	ret    
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104666:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010466f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104672:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104680:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104681:	31 d2                	xor    %edx,%edx
{
80104683:	89 e5                	mov    %esp,%ebp
80104685:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104686:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010468c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010468f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104690:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104696:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010469c:	77 1a                	ja     801046b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010469e:	8b 58 04             	mov    0x4(%eax),%ebx
801046a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046a9:	83 fa 0a             	cmp    $0xa,%edx
801046ac:	75 e2                	jne    80104690 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b1:	c9                   	leave  
801046b2:	c3                   	ret    
801046b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b7:	90                   	nop
  for(; i < 10; i++)
801046b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046bb:	8d 51 28             	lea    0x28(%ecx),%edx
801046be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046c6:	83 c0 04             	add    $0x4,%eax
801046c9:	39 d0                	cmp    %edx,%eax
801046cb:	75 f3                	jne    801046c0 <getcallerpcs+0x40>
}
801046cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    
801046d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046e0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	53                   	push   %ebx
801046e4:	83 ec 04             	sub    $0x4,%esp
801046e7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801046ea:	8b 02                	mov    (%edx),%eax
801046ec:	85 c0                	test   %eax,%eax
801046ee:	75 10                	jne    80104700 <holding+0x20>
}
801046f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f3:	31 c0                	xor    %eax,%eax
801046f5:	c9                   	leave  
801046f6:	c3                   	ret    
801046f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fe:	66 90                	xchg   %ax,%ax
80104700:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
80104703:	e8 18 f3 ff ff       	call   80103a20 <mycpu>
80104708:	39 c3                	cmp    %eax,%ebx
}
8010470a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010470d:	c9                   	leave  
  return lock->locked && lock->cpu == mycpu();
8010470e:	0f 94 c0             	sete   %al
80104711:	0f b6 c0             	movzbl %al,%eax
}
80104714:	c3                   	ret    
80104715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	9c                   	pushf  
80104728:	5b                   	pop    %ebx
  asm volatile("cli");
80104729:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010472a:	e8 f1 f2 ff ff       	call   80103a20 <mycpu>
8010472f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	74 17                	je     80104750 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104739:	e8 e2 f2 ff ff       	call   80103a20 <mycpu>
8010473e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104748:	c9                   	leave  
80104749:	c3                   	ret    
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104750:	e8 cb f2 ff ff       	call   80103a20 <mycpu>
80104755:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010475b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104761:	eb d6                	jmp    80104739 <pushcli+0x19>
80104763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <acquire>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104777:	e8 a4 ff ff ff       	call   80104720 <pushcli>
  if(holding(lk))
8010477c:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010477f:	8b 02                	mov    (%edx),%eax
80104781:	85 c0                	test   %eax,%eax
80104783:	0f 85 7f 00 00 00    	jne    80104808 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104789:	b9 01 00 00 00       	mov    $0x1,%ecx
8010478e:	eb 03                	jmp    80104793 <acquire+0x23>
  while(xchg(&lk->locked, 1) != 0)
80104790:	8b 55 08             	mov    0x8(%ebp),%edx
80104793:	89 c8                	mov    %ecx,%eax
80104795:	f0 87 02             	lock xchg %eax,(%edx)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x20>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 77 f2 ff ff       	call   80103a20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047ac:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047ae:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047b1:	31 c0                	xor    %eax,%eax
801047b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047c4:	77 1a                	ja     801047e0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801047c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801047c9:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047cd:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047d0:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047d2:	83 f8 0a             	cmp    $0xa,%eax
801047d5:	75 e1                	jne    801047b8 <acquire+0x48>
}
801047d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047da:	c9                   	leave  
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801047e0:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801047e4:	8d 51 34             	lea    0x34(%ecx),%edx
801047e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047f6:	83 c0 04             	add    $0x4,%eax
801047f9:	39 c2                	cmp    %eax,%edx
801047fb:	75 f3                	jne    801047f0 <acquire+0x80>
}
801047fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104800:	c9                   	leave  
80104801:	c3                   	ret    
80104802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104808:	8b 5a 08             	mov    0x8(%edx),%ebx
  return lock->locked && lock->cpu == mycpu();
8010480b:	e8 10 f2 ff ff       	call   80103a20 <mycpu>
80104810:	39 c3                	cmp    %eax,%ebx
80104812:	74 0c                	je     80104820 <acquire+0xb0>
  while(xchg(&lk->locked, 1) != 0)
80104814:	8b 55 08             	mov    0x8(%ebp),%edx
80104817:	e9 6d ff ff ff       	jmp    80104789 <acquire+0x19>
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("acquire");
80104820:	83 ec 0c             	sub    $0xc,%esp
80104823:	68 cb 7b 10 80       	push   $0x80107bcb
80104828:	e8 53 bb ff ff       	call   80100380 <panic>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <popcli>:

void
popcli(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104836:	9c                   	pushf  
80104837:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104838:	f6 c4 02             	test   $0x2,%ah
8010483b:	75 35                	jne    80104872 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010483d:	e8 de f1 ff ff       	call   80103a20 <mycpu>
80104842:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104849:	78 34                	js     8010487f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010484b:	e8 d0 f1 ff ff       	call   80103a20 <mycpu>
80104850:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104856:	85 d2                	test   %edx,%edx
80104858:	74 06                	je     80104860 <popcli+0x30>
    sti();
}
8010485a:	c9                   	leave  
8010485b:	c3                   	ret    
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104860:	e8 bb f1 ff ff       	call   80103a20 <mycpu>
80104865:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010486b:	85 c0                	test   %eax,%eax
8010486d:	74 eb                	je     8010485a <popcli+0x2a>
  asm volatile("sti");
8010486f:	fb                   	sti    
}
80104870:	c9                   	leave  
80104871:	c3                   	ret    
    panic("popcli - interruptible");
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	68 d3 7b 10 80       	push   $0x80107bd3
8010487a:	e8 01 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010487f:	83 ec 0c             	sub    $0xc,%esp
80104882:	68 ea 7b 10 80       	push   $0x80107bea
80104887:	e8 f4 ba ff ff       	call   80100380 <panic>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <release>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
80104895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104898:	8b 03                	mov    (%ebx),%eax
8010489a:	85 c0                	test   %eax,%eax
8010489c:	75 12                	jne    801048b0 <release+0x20>
    panic("release");
8010489e:	83 ec 0c             	sub    $0xc,%esp
801048a1:	68 f1 7b 10 80       	push   $0x80107bf1
801048a6:	e8 d5 ba ff ff       	call   80100380 <panic>
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop
801048b0:	8b 73 08             	mov    0x8(%ebx),%esi
  return lock->locked && lock->cpu == mycpu();
801048b3:	e8 68 f1 ff ff       	call   80103a20 <mycpu>
801048b8:	39 c6                	cmp    %eax,%esi
801048ba:	75 e2                	jne    8010489e <release+0xe>
  lk->pcs[0] = 0;
801048bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d8:	5b                   	pop    %ebx
801048d9:	5e                   	pop    %esi
801048da:	5d                   	pop    %ebp
  popcli();
801048db:	e9 50 ff ff ff       	jmp    80104830 <popcli>

801048e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	8b 55 08             	mov    0x8(%ebp),%edx
801048e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048ea:	53                   	push   %ebx
801048eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801048ee:	89 d7                	mov    %edx,%edi
801048f0:	09 cf                	or     %ecx,%edi
801048f2:	83 e7 03             	and    $0x3,%edi
801048f5:	75 29                	jne    80104920 <memset+0x40>
    c &= 0xFF;
801048f7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048fa:	c1 e0 18             	shl    $0x18,%eax
801048fd:	89 fb                	mov    %edi,%ebx
801048ff:	c1 e9 02             	shr    $0x2,%ecx
80104902:	c1 e3 10             	shl    $0x10,%ebx
80104905:	09 d8                	or     %ebx,%eax
80104907:	09 f8                	or     %edi,%eax
80104909:	c1 e7 08             	shl    $0x8,%edi
8010490c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010490e:	89 d7                	mov    %edx,%edi
80104910:	fc                   	cld    
80104911:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104913:	5b                   	pop    %ebx
80104914:	89 d0                	mov    %edx,%eax
80104916:	5f                   	pop    %edi
80104917:	5d                   	pop    %ebp
80104918:	c3                   	ret    
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104920:	89 d7                	mov    %edx,%edi
80104922:	fc                   	cld    
80104923:	f3 aa                	rep stos %al,%es:(%edi)
80104925:	5b                   	pop    %ebx
80104926:	89 d0                	mov    %edx,%eax
80104928:	5f                   	pop    %edi
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010492f:	90                   	nop

80104930 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	8b 75 10             	mov    0x10(%ebp),%esi
80104937:	8b 55 08             	mov    0x8(%ebp),%edx
8010493a:	53                   	push   %ebx
8010493b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010493e:	85 f6                	test   %esi,%esi
80104940:	74 2e                	je     80104970 <memcmp+0x40>
80104942:	01 c6                	add    %eax,%esi
80104944:	eb 14                	jmp    8010495a <memcmp+0x2a>
80104946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104950:	83 c0 01             	add    $0x1,%eax
80104953:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104956:	39 f0                	cmp    %esi,%eax
80104958:	74 16                	je     80104970 <memcmp+0x40>
    if(*s1 != *s2)
8010495a:	0f b6 0a             	movzbl (%edx),%ecx
8010495d:	0f b6 18             	movzbl (%eax),%ebx
80104960:	38 d9                	cmp    %bl,%cl
80104962:	74 ec                	je     80104950 <memcmp+0x20>
      return *s1 - *s2;
80104964:	0f b6 c1             	movzbl %cl,%eax
80104967:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104969:	5b                   	pop    %ebx
8010496a:	5e                   	pop    %esi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret    
8010496d:	8d 76 00             	lea    0x0(%esi),%esi
80104970:	5b                   	pop    %ebx
  return 0;
80104971:	31 c0                	xor    %eax,%eax
}
80104973:	5e                   	pop    %esi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	8b 55 08             	mov    0x8(%ebp),%edx
80104987:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010498a:	56                   	push   %esi
8010498b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010498e:	39 d6                	cmp    %edx,%esi
80104990:	73 26                	jae    801049b8 <memmove+0x38>
80104992:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104995:	39 fa                	cmp    %edi,%edx
80104997:	73 1f                	jae    801049b8 <memmove+0x38>
80104999:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010499c:	85 c9                	test   %ecx,%ecx
8010499e:	74 0c                	je     801049ac <memmove+0x2c>
      *--d = *--s;
801049a0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801049a4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801049a7:	83 e8 01             	sub    $0x1,%eax
801049aa:	73 f4                	jae    801049a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049ac:	5e                   	pop    %esi
801049ad:	89 d0                	mov    %edx,%eax
801049af:	5f                   	pop    %edi
801049b0:	5d                   	pop    %ebp
801049b1:	c3                   	ret    
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801049b8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801049bb:	89 d7                	mov    %edx,%edi
801049bd:	85 c9                	test   %ecx,%ecx
801049bf:	74 eb                	je     801049ac <memmove+0x2c>
801049c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801049c8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801049c9:	39 f0                	cmp    %esi,%eax
801049cb:	75 fb                	jne    801049c8 <memmove+0x48>
}
801049cd:	5e                   	pop    %esi
801049ce:	89 d0                	mov    %edx,%eax
801049d0:	5f                   	pop    %edi
801049d1:	5d                   	pop    %ebp
801049d2:	c3                   	ret    
801049d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801049e0:	eb 9e                	jmp    80104980 <memmove>
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	8b 75 10             	mov    0x10(%ebp),%esi
801049f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049fa:	53                   	push   %ebx
801049fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801049fe:	85 f6                	test   %esi,%esi
80104a00:	74 36                	je     80104a38 <strncmp+0x48>
80104a02:	01 c6                	add    %eax,%esi
80104a04:	eb 18                	jmp    80104a1e <strncmp+0x2e>
80104a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
80104a10:	38 da                	cmp    %bl,%dl
80104a12:	75 14                	jne    80104a28 <strncmp+0x38>
    n--, p++, q++;
80104a14:	83 c0 01             	add    $0x1,%eax
80104a17:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a1a:	39 f0                	cmp    %esi,%eax
80104a1c:	74 1a                	je     80104a38 <strncmp+0x48>
80104a1e:	0f b6 11             	movzbl (%ecx),%edx
80104a21:	0f b6 18             	movzbl (%eax),%ebx
80104a24:	84 d2                	test   %dl,%dl
80104a26:	75 e8                	jne    80104a10 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a28:	0f b6 c2             	movzbl %dl,%eax
80104a2b:	29 d8                	sub    %ebx,%eax
}
80104a2d:	5b                   	pop    %ebx
80104a2e:	5e                   	pop    %esi
80104a2f:	5d                   	pop    %ebp
80104a30:	c3                   	ret    
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a38:	5b                   	pop    %ebx
    return 0;
80104a39:	31 c0                	xor    %eax,%eax
}
80104a3b:	5e                   	pop    %esi
80104a3c:	5d                   	pop    %ebp
80104a3d:	c3                   	ret    
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	8b 75 08             	mov    0x8(%ebp),%esi
80104a48:	53                   	push   %ebx
80104a49:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a4c:	89 f2                	mov    %esi,%edx
80104a4e:	eb 17                	jmp    80104a67 <strncpy+0x27>
80104a50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104a54:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104a57:	83 c2 01             	add    $0x1,%edx
80104a5a:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104a5e:	89 f9                	mov    %edi,%ecx
80104a60:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a63:	84 c9                	test   %cl,%cl
80104a65:	74 09                	je     80104a70 <strncpy+0x30>
80104a67:	89 c3                	mov    %eax,%ebx
80104a69:	83 e8 01             	sub    $0x1,%eax
80104a6c:	85 db                	test   %ebx,%ebx
80104a6e:	7f e0                	jg     80104a50 <strncpy+0x10>
    ;
  while(n-- > 0)
80104a70:	89 d1                	mov    %edx,%ecx
80104a72:	85 c0                	test   %eax,%eax
80104a74:	7e 1d                	jle    80104a93 <strncpy+0x53>
80104a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104a80:	83 c1 01             	add    $0x1,%ecx
80104a83:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104a87:	89 c8                	mov    %ecx,%eax
80104a89:	f7 d0                	not    %eax
80104a8b:	01 d0                	add    %edx,%eax
80104a8d:	01 d8                	add    %ebx,%eax
80104a8f:	85 c0                	test   %eax,%eax
80104a91:	7f ed                	jg     80104a80 <strncpy+0x40>
  return os;
}
80104a93:	5b                   	pop    %ebx
80104a94:	89 f0                	mov    %esi,%eax
80104a96:	5e                   	pop    %esi
80104a97:	5f                   	pop    %edi
80104a98:	5d                   	pop    %ebp
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	8b 55 10             	mov    0x10(%ebp),%edx
80104aa7:	8b 75 08             	mov    0x8(%ebp),%esi
80104aaa:	53                   	push   %ebx
80104aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104aae:	85 d2                	test   %edx,%edx
80104ab0:	7e 25                	jle    80104ad7 <safestrcpy+0x37>
80104ab2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ab6:	89 f2                	mov    %esi,%edx
80104ab8:	eb 16                	jmp    80104ad0 <safestrcpy+0x30>
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ac0:	0f b6 08             	movzbl (%eax),%ecx
80104ac3:	83 c0 01             	add    $0x1,%eax
80104ac6:	83 c2 01             	add    $0x1,%edx
80104ac9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104acc:	84 c9                	test   %cl,%cl
80104ace:	74 04                	je     80104ad4 <safestrcpy+0x34>
80104ad0:	39 d8                	cmp    %ebx,%eax
80104ad2:	75 ec                	jne    80104ac0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ad4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104ad7:	89 f0                	mov    %esi,%eax
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5d                   	pop    %ebp
80104adc:	c3                   	ret    
80104add:	8d 76 00             	lea    0x0(%esi),%esi

80104ae0 <strlen>:

int
strlen(const char *s)
{
80104ae0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ae1:	31 c0                	xor    %eax,%eax
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ae8:	80 3a 00             	cmpb   $0x0,(%edx)
80104aeb:	74 0c                	je     80104af9 <strlen+0x19>
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
80104af0:	83 c0 01             	add    $0x1,%eax
80104af3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104af7:	75 f7                	jne    80104af0 <strlen+0x10>
    ;
  return n;
}
80104af9:	5d                   	pop    %ebp
80104afa:	c3                   	ret    

80104afb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104afb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b03:	55                   	push   %ebp
  pushl %ebx
80104b04:	53                   	push   %ebx
  pushl %esi
80104b05:	56                   	push   %esi
  pushl %edi
80104b06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b09:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b0b:	5f                   	pop    %edi
  popl %esi
80104b0c:	5e                   	pop    %esi
  popl %ebx
80104b0d:	5b                   	pop    %ebx
  popl %ebp
80104b0e:	5d                   	pop    %ebp
  ret
80104b0f:	c3                   	ret    

80104b10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 04             	sub    $0x4,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b1a:	e8 91 ef ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b1f:	8b 00                	mov    (%eax),%eax
80104b21:	39 d8                	cmp    %ebx,%eax
80104b23:	76 1b                	jbe    80104b40 <fetchint+0x30>
80104b25:	8d 53 04             	lea    0x4(%ebx),%edx
80104b28:	39 d0                	cmp    %edx,%eax
80104b2a:	72 14                	jb     80104b40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b2f:	8b 13                	mov    (%ebx),%edx
80104b31:	89 10                	mov    %edx,(%eax)
  return 0;
80104b33:	31 c0                	xor    %eax,%eax
}
80104b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b38:	c9                   	leave  
80104b39:	c3                   	ret    
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b45:	eb ee                	jmp    80104b35 <fetchint+0x25>
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	53                   	push   %ebx
80104b54:	83 ec 04             	sub    $0x4,%esp
80104b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b5a:	e8 51 ef ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
80104b5f:	39 18                	cmp    %ebx,(%eax)
80104b61:	76 2d                	jbe    80104b90 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104b63:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b66:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b68:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b6a:	39 d3                	cmp    %edx,%ebx
80104b6c:	73 22                	jae    80104b90 <fetchstr+0x40>
80104b6e:	89 d8                	mov    %ebx,%eax
80104b70:	eb 0d                	jmp    80104b7f <fetchstr+0x2f>
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	83 c0 01             	add    $0x1,%eax
80104b7b:	39 c2                	cmp    %eax,%edx
80104b7d:	76 11                	jbe    80104b90 <fetchstr+0x40>
    if(*s == 0)
80104b7f:	80 38 00             	cmpb   $0x0,(%eax)
80104b82:	75 f4                	jne    80104b78 <fetchstr+0x28>
      return s - *pp;
80104b84:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b89:	c9                   	leave  
80104b8a:	c3                   	ret    
80104b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop
80104b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ba0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba5:	e8 06 ef ff ff       	call   80103ab0 <myproc>
80104baa:	8b 55 08             	mov    0x8(%ebp),%edx
80104bad:	8b 40 18             	mov    0x18(%eax),%eax
80104bb0:	8b 40 44             	mov    0x44(%eax),%eax
80104bb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bb6:	e8 f5 ee ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bbb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bbe:	8b 00                	mov    (%eax),%eax
80104bc0:	39 c6                	cmp    %eax,%esi
80104bc2:	73 1c                	jae    80104be0 <argint+0x40>
80104bc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bc7:	39 d0                	cmp    %edx,%eax
80104bc9:	72 15                	jb     80104be0 <argint+0x40>
  *ip = *(int*)(addr);
80104bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bce:	8b 53 04             	mov    0x4(%ebx),%edx
80104bd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be5:	eb ee                	jmp    80104bd5 <argint+0x35>
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
80104bf5:	53                   	push   %ebx
80104bf6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104bf9:	e8 b2 ee ff ff       	call   80103ab0 <myproc>
80104bfe:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c00:	e8 ab ee ff ff       	call   80103ab0 <myproc>
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
80104c08:	8b 40 18             	mov    0x18(%eax),%eax
80104c0b:	8b 40 44             	mov    0x44(%eax),%eax
80104c0e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c11:	e8 9a ee ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c16:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c19:	8b 00                	mov    (%eax),%eax
80104c1b:	39 c7                	cmp    %eax,%edi
80104c1d:	73 31                	jae    80104c50 <argptr+0x60>
80104c1f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c22:	39 c8                	cmp    %ecx,%eax
80104c24:	72 2a                	jb     80104c50 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c26:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c29:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c2c:	85 d2                	test   %edx,%edx
80104c2e:	78 20                	js     80104c50 <argptr+0x60>
80104c30:	8b 16                	mov    (%esi),%edx
80104c32:	39 c2                	cmp    %eax,%edx
80104c34:	76 1a                	jbe    80104c50 <argptr+0x60>
80104c36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c39:	01 c3                	add    %eax,%ebx
80104c3b:	39 da                	cmp    %ebx,%edx
80104c3d:	72 11                	jb     80104c50 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c42:	89 02                	mov    %eax,(%edx)
  return 0;
80104c44:	31 c0                	xor    %eax,%eax
}
80104c46:	83 c4 0c             	add    $0xc,%esp
80104c49:	5b                   	pop    %ebx
80104c4a:	5e                   	pop    %esi
80104c4b:	5f                   	pop    %edi
80104c4c:	5d                   	pop    %ebp
80104c4d:	c3                   	ret    
80104c4e:	66 90                	xchg   %ax,%ax
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c55:	eb ef                	jmp    80104c46 <argptr+0x56>
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c65:	e8 46 ee ff ff       	call   80103ab0 <myproc>
80104c6a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c6d:	8b 40 18             	mov    0x18(%eax),%eax
80104c70:	8b 40 44             	mov    0x44(%eax),%eax
80104c73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c76:	e8 35 ee ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c7b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c7e:	8b 00                	mov    (%eax),%eax
80104c80:	39 c6                	cmp    %eax,%esi
80104c82:	73 44                	jae    80104cc8 <argstr+0x68>
80104c84:	8d 53 08             	lea    0x8(%ebx),%edx
80104c87:	39 d0                	cmp    %edx,%eax
80104c89:	72 3d                	jb     80104cc8 <argstr+0x68>
  *ip = *(int*)(addr);
80104c8b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c8e:	e8 1d ee ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80104c93:	3b 18                	cmp    (%eax),%ebx
80104c95:	73 31                	jae    80104cc8 <argstr+0x68>
  *pp = (char*)addr;
80104c97:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c9a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c9c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c9e:	39 d3                	cmp    %edx,%ebx
80104ca0:	73 26                	jae    80104cc8 <argstr+0x68>
80104ca2:	89 d8                	mov    %ebx,%eax
80104ca4:	eb 11                	jmp    80104cb7 <argstr+0x57>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	83 c0 01             	add    $0x1,%eax
80104cb3:	39 c2                	cmp    %eax,%edx
80104cb5:	76 11                	jbe    80104cc8 <argstr+0x68>
    if(*s == 0)
80104cb7:	80 38 00             	cmpb   $0x0,(%eax)
80104cba:	75 f4                	jne    80104cb0 <argstr+0x50>
      return s - *pp;
80104cbc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104cbe:	5b                   	pop    %ebx
80104cbf:	5e                   	pop    %esi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret    
80104cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cc8:	5b                   	pop    %ebx
    return -1;
80104cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cce:	5e                   	pop    %esi
80104ccf:	5d                   	pop    %ebp
80104cd0:	c3                   	ret    
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdf:	90                   	nop

80104ce0 <syscall>:

};

void
syscall(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104ce7:	e8 c4 ed ff ff       	call   80103ab0 <myproc>
80104cec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cee:	8b 40 18             	mov    0x18(%eax),%eax
80104cf1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cf4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cf7:	83 fa 19             	cmp    $0x19,%edx
80104cfa:	77 24                	ja     80104d20 <syscall+0x40>
80104cfc:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
80104d03:	85 d2                	test   %edx,%edx
80104d05:	74 19                	je     80104d20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104d07:	ff d2                	call   *%edx
80104d09:	89 c2                	mov    %eax,%edx
80104d0b:	8b 43 18             	mov    0x18(%ebx),%eax
80104d0e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d14:	c9                   	leave  
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d24:	50                   	push   %eax
80104d25:	ff 73 10             	pushl  0x10(%ebx)
80104d28:	68 f9 7b 10 80       	push   $0x80107bf9
80104d2d:	e8 4e b9 ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104d32:	8b 43 18             	mov    0x18(%ebx),%eax
80104d35:	83 c4 10             	add    $0x10,%esp
80104d38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d42:	c9                   	leave  
80104d43:	c3                   	ret    
80104d44:	66 90                	xchg   %ax,%ax
80104d46:	66 90                	xchg   %ax,%ax
80104d48:	66 90                	xchg   %ax,%ax
80104d4a:	66 90                	xchg   %ax,%ax
80104d4c:	66 90                	xchg   %ax,%ax
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	57                   	push   %edi
80104d54:	56                   	push   %esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104d58:	53                   	push   %ebx
80104d59:	83 ec 44             	sub    $0x44,%esp
80104d5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d62:	57                   	push   %edi
80104d63:	50                   	push   %eax
{
80104d64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d6a:	e8 81 d4 ff ff       	call   801021f0 <nameiparent>
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	85 c0                	test   %eax,%eax
80104d74:	0f 84 46 01 00 00    	je     80104ec0 <create+0x170>
    return 0;
  ilock(dp);
80104d7a:	83 ec 0c             	sub    $0xc,%esp
80104d7d:	89 c3                	mov    %eax,%ebx
80104d7f:	50                   	push   %eax
80104d80:	e8 2b cb ff ff       	call   801018b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104d85:	83 c4 0c             	add    $0xc,%esp
80104d88:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104d8b:	50                   	push   %eax
80104d8c:	57                   	push   %edi
80104d8d:	53                   	push   %ebx
80104d8e:	e8 7d d0 ff ff       	call   80101e10 <dirlookup>
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	89 c6                	mov    %eax,%esi
80104d98:	85 c0                	test   %eax,%eax
80104d9a:	74 54                	je     80104df0 <create+0xa0>
    iunlockput(dp);
80104d9c:	83 ec 0c             	sub    $0xc,%esp
80104d9f:	53                   	push   %ebx
80104da0:	e8 9b cd ff ff       	call   80101b40 <iunlockput>
    ilock(ip);
80104da5:	89 34 24             	mov    %esi,(%esp)
80104da8:	e8 03 cb ff ff       	call   801018b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104db5:	75 19                	jne    80104dd0 <create+0x80>
80104db7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104dbc:	75 12                	jne    80104dd0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dc1:	89 f0                	mov    %esi,%eax
80104dc3:	5b                   	pop    %ebx
80104dc4:	5e                   	pop    %esi
80104dc5:	5f                   	pop    %edi
80104dc6:	5d                   	pop    %ebp
80104dc7:	c3                   	ret    
80104dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
    iunlockput(ip);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
80104dd3:	56                   	push   %esi
    return 0;
80104dd4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104dd6:	e8 65 cd ff ff       	call   80101b40 <iunlockput>
    return 0;
80104ddb:	83 c4 10             	add    $0x10,%esp
}
80104dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de1:	89 f0                	mov    %esi,%eax
80104de3:	5b                   	pop    %ebx
80104de4:	5e                   	pop    %esi
80104de5:	5f                   	pop    %edi
80104de6:	5d                   	pop    %ebp
80104de7:	c3                   	ret    
80104de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104df0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104df4:	83 ec 08             	sub    $0x8,%esp
80104df7:	50                   	push   %eax
80104df8:	ff 33                	pushl  (%ebx)
80104dfa:	e8 41 c9 ff ff       	call   80101740 <ialloc>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	89 c6                	mov    %eax,%esi
80104e04:	85 c0                	test   %eax,%eax
80104e06:	0f 84 cd 00 00 00    	je     80104ed9 <create+0x189>
  ilock(ip);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	50                   	push   %eax
80104e10:	e8 9b ca ff ff       	call   801018b0 <ilock>
  ip->major = major;
80104e15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e25:	b8 01 00 00 00       	mov    $0x1,%eax
80104e2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e2e:	89 34 24             	mov    %esi,(%esp)
80104e31:	e8 ca c9 ff ff       	call   80101800 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e36:	83 c4 10             	add    $0x10,%esp
80104e39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e3e:	74 30                	je     80104e70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e40:	83 ec 04             	sub    $0x4,%esp
80104e43:	ff 76 04             	pushl  0x4(%esi)
80104e46:	57                   	push   %edi
80104e47:	53                   	push   %ebx
80104e48:	e8 c3 d2 ff ff       	call   80102110 <dirlink>
80104e4d:	83 c4 10             	add    $0x10,%esp
80104e50:	85 c0                	test   %eax,%eax
80104e52:	78 78                	js     80104ecc <create+0x17c>
  iunlockput(dp);
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	53                   	push   %ebx
80104e58:	e8 e3 cc ff ff       	call   80101b40 <iunlockput>
  return ip;
80104e5d:	83 c4 10             	add    $0x10,%esp
}
80104e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e63:	89 f0                	mov    %esi,%eax
80104e65:	5b                   	pop    %ebx
80104e66:	5e                   	pop    %esi
80104e67:	5f                   	pop    %edi
80104e68:	5d                   	pop    %ebp
80104e69:	c3                   	ret    
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104e70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104e73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104e78:	53                   	push   %ebx
80104e79:	e8 82 c9 ff ff       	call   80101800 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104e7e:	83 c4 0c             	add    $0xc,%esp
80104e81:	ff 76 04             	pushl  0x4(%esi)
80104e84:	68 a8 7c 10 80       	push   $0x80107ca8
80104e89:	56                   	push   %esi
80104e8a:	e8 81 d2 ff ff       	call   80102110 <dirlink>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	78 18                	js     80104eae <create+0x15e>
80104e96:	83 ec 04             	sub    $0x4,%esp
80104e99:	ff 73 04             	pushl  0x4(%ebx)
80104e9c:	68 a7 7c 10 80       	push   $0x80107ca7
80104ea1:	56                   	push   %esi
80104ea2:	e8 69 d2 ff ff       	call   80102110 <dirlink>
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	79 92                	jns    80104e40 <create+0xf0>
      panic("create dots");
80104eae:	83 ec 0c             	sub    $0xc,%esp
80104eb1:	68 9b 7c 10 80       	push   $0x80107c9b
80104eb6:	e8 c5 b4 ff ff       	call   80100380 <panic>
80104ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ebf:	90                   	nop
}
80104ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ec3:	31 f6                	xor    %esi,%esi
}
80104ec5:	5b                   	pop    %ebx
80104ec6:	89 f0                	mov    %esi,%eax
80104ec8:	5e                   	pop    %esi
80104ec9:	5f                   	pop    %edi
80104eca:	5d                   	pop    %ebp
80104ecb:	c3                   	ret    
    panic("create: dirlink");
80104ecc:	83 ec 0c             	sub    $0xc,%esp
80104ecf:	68 aa 7c 10 80       	push   $0x80107caa
80104ed4:	e8 a7 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104ed9:	83 ec 0c             	sub    $0xc,%esp
80104edc:	68 8c 7c 10 80       	push   $0x80107c8c
80104ee1:	e8 9a b4 ff ff       	call   80100380 <panic>
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi

80104ef0 <sys_dup>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	50                   	push   %eax
80104efc:	6a 00                	push   $0x0
80104efe:	e8 9d fc ff ff       	call   80104ba0 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 36                	js     80104f40 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 30                	ja     80104f40 <sys_dup+0x50>
80104f10:	e8 9b eb ff ff       	call   80103ab0 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f1c:	85 f6                	test   %esi,%esi
80104f1e:	74 20                	je     80104f40 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f20:	e8 8b eb ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f25:	31 db                	xor    %ebx,%ebx
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104f30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f34:	85 d2                	test   %edx,%edx
80104f36:	74 18                	je     80104f50 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104f38:	83 c3 01             	add    $0x1,%ebx
80104f3b:	83 fb 10             	cmp    $0x10,%ebx
80104f3e:	75 f0                	jne    80104f30 <sys_dup+0x40>
}
80104f40:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f48:	89 d8                	mov    %ebx,%eax
80104f4a:	5b                   	pop    %ebx
80104f4b:	5e                   	pop    %esi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104f50:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104f53:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104f57:	56                   	push   %esi
80104f58:	e8 63 c0 ff ff       	call   80100fc0 <filedup>
  return fd;
80104f5d:	83 c4 10             	add    $0x10,%esp
}
80104f60:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f63:	89 d8                	mov    %ebx,%eax
80104f65:	5b                   	pop    %ebx
80104f66:	5e                   	pop    %esi
80104f67:	5d                   	pop    %ebp
80104f68:	c3                   	ret    
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f70 <sys_read>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f7b:	53                   	push   %ebx
80104f7c:	6a 00                	push   $0x0
80104f7e:	e8 1d fc ff ff       	call   80104ba0 <argint>
80104f83:	83 c4 10             	add    $0x10,%esp
80104f86:	85 c0                	test   %eax,%eax
80104f88:	78 5e                	js     80104fe8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f8e:	77 58                	ja     80104fe8 <sys_read+0x78>
80104f90:	e8 1b eb ff ff       	call   80103ab0 <myproc>
80104f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f9c:	85 f6                	test   %esi,%esi
80104f9e:	74 48                	je     80104fe8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fa0:	83 ec 08             	sub    $0x8,%esp
80104fa3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	6a 02                	push   $0x2
80104fa9:	e8 f2 fb ff ff       	call   80104ba0 <argint>
80104fae:	83 c4 10             	add    $0x10,%esp
80104fb1:	85 c0                	test   %eax,%eax
80104fb3:	78 33                	js     80104fe8 <sys_read+0x78>
80104fb5:	83 ec 04             	sub    $0x4,%esp
80104fb8:	ff 75 f0             	pushl  -0x10(%ebp)
80104fbb:	53                   	push   %ebx
80104fbc:	6a 01                	push   $0x1
80104fbe:	e8 2d fc ff ff       	call   80104bf0 <argptr>
80104fc3:	83 c4 10             	add    $0x10,%esp
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	78 1e                	js     80104fe8 <sys_read+0x78>
  return fileread(f, p, n);
80104fca:	83 ec 04             	sub    $0x4,%esp
80104fcd:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd0:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd3:	56                   	push   %esi
80104fd4:	e8 67 c1 ff ff       	call   80101140 <fileread>
80104fd9:	83 c4 10             	add    $0x10,%esp
}
80104fdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe7:	90                   	nop
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb ed                	jmp    80104fdc <sys_read+0x6c>
80104fef:	90                   	nop

80104ff0 <sys_write>:
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ff5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ff8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104ffb:	53                   	push   %ebx
80104ffc:	6a 00                	push   $0x0
80104ffe:	e8 9d fb ff ff       	call   80104ba0 <argint>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	78 5e                	js     80105068 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010500e:	77 58                	ja     80105068 <sys_write+0x78>
80105010:	e8 9b ea ff ff       	call   80103ab0 <myproc>
80105015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105018:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010501c:	85 f6                	test   %esi,%esi
8010501e:	74 48                	je     80105068 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105020:	83 ec 08             	sub    $0x8,%esp
80105023:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105026:	50                   	push   %eax
80105027:	6a 02                	push   $0x2
80105029:	e8 72 fb ff ff       	call   80104ba0 <argint>
8010502e:	83 c4 10             	add    $0x10,%esp
80105031:	85 c0                	test   %eax,%eax
80105033:	78 33                	js     80105068 <sys_write+0x78>
80105035:	83 ec 04             	sub    $0x4,%esp
80105038:	ff 75 f0             	pushl  -0x10(%ebp)
8010503b:	53                   	push   %ebx
8010503c:	6a 01                	push   $0x1
8010503e:	e8 ad fb ff ff       	call   80104bf0 <argptr>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 1e                	js     80105068 <sys_write+0x78>
  return filewrite(f, p, n);
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	ff 75 f0             	pushl  -0x10(%ebp)
80105050:	ff 75 f4             	pushl  -0xc(%ebp)
80105053:	56                   	push   %esi
80105054:	e8 77 c1 ff ff       	call   801011d0 <filewrite>
80105059:	83 c4 10             	add    $0x10,%esp
}
8010505c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105067:	90                   	nop
    return -1;
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb ed                	jmp    8010505c <sys_write+0x6c>
8010506f:	90                   	nop

80105070 <sys_close>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105075:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105078:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010507b:	50                   	push   %eax
8010507c:	6a 00                	push   $0x0
8010507e:	e8 1d fb ff ff       	call   80104ba0 <argint>
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	85 c0                	test   %eax,%eax
80105088:	78 3e                	js     801050c8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010508a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010508e:	77 38                	ja     801050c8 <sys_close+0x58>
80105090:	e8 1b ea ff ff       	call   80103ab0 <myproc>
80105095:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105098:	8d 5a 08             	lea    0x8(%edx),%ebx
8010509b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010509f:	85 f6                	test   %esi,%esi
801050a1:	74 25                	je     801050c8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801050a3:	e8 08 ea ff ff       	call   80103ab0 <myproc>
  fileclose(f);
801050a8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050ab:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801050b2:	00 
  fileclose(f);
801050b3:	56                   	push   %esi
801050b4:	e8 57 bf ff ff       	call   80101010 <fileclose>
  return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5d                   	pop    %ebp
801050c4:	c3                   	ret    
801050c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cd:	eb ef                	jmp    801050be <sys_close+0x4e>
801050cf:	90                   	nop

801050d0 <sys_fstat>:
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050db:	53                   	push   %ebx
801050dc:	6a 00                	push   $0x0
801050de:	e8 bd fa ff ff       	call   80104ba0 <argint>
801050e3:	83 c4 10             	add    $0x10,%esp
801050e6:	85 c0                	test   %eax,%eax
801050e8:	78 46                	js     80105130 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050ee:	77 40                	ja     80105130 <sys_fstat+0x60>
801050f0:	e8 bb e9 ff ff       	call   80103ab0 <myproc>
801050f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050f8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050fc:	85 f6                	test   %esi,%esi
801050fe:	74 30                	je     80105130 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105100:	83 ec 04             	sub    $0x4,%esp
80105103:	6a 14                	push   $0x14
80105105:	53                   	push   %ebx
80105106:	6a 01                	push   $0x1
80105108:	e8 e3 fa ff ff       	call   80104bf0 <argptr>
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	85 c0                	test   %eax,%eax
80105112:	78 1c                	js     80105130 <sys_fstat+0x60>
  return filestat(f, st);
80105114:	83 ec 08             	sub    $0x8,%esp
80105117:	ff 75 f4             	pushl  -0xc(%ebp)
8010511a:	56                   	push   %esi
8010511b:	e8 d0 bf ff ff       	call   801010f0 <filestat>
80105120:	83 c4 10             	add    $0x10,%esp
}
80105123:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105126:	5b                   	pop    %ebx
80105127:	5e                   	pop    %esi
80105128:	5d                   	pop    %ebp
80105129:	c3                   	ret    
8010512a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	eb ec                	jmp    80105123 <sys_fstat+0x53>
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <sys_link>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	57                   	push   %edi
80105144:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105145:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105148:	53                   	push   %ebx
80105149:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010514c:	50                   	push   %eax
8010514d:	6a 00                	push   $0x0
8010514f:	e8 0c fb ff ff       	call   80104c60 <argstr>
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	85 c0                	test   %eax,%eax
80105159:	0f 88 fb 00 00 00    	js     8010525a <sys_link+0x11a>
8010515f:	83 ec 08             	sub    $0x8,%esp
80105162:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105165:	50                   	push   %eax
80105166:	6a 01                	push   $0x1
80105168:	e8 f3 fa ff ff       	call   80104c60 <argstr>
8010516d:	83 c4 10             	add    $0x10,%esp
80105170:	85 c0                	test   %eax,%eax
80105172:	0f 88 e2 00 00 00    	js     8010525a <sys_link+0x11a>
  begin_op();
80105178:	e8 13 dd ff ff       	call   80102e90 <begin_op>
  if((ip = namei(old)) == 0){
8010517d:	83 ec 0c             	sub    $0xc,%esp
80105180:	ff 75 d4             	pushl  -0x2c(%ebp)
80105183:	e8 48 d0 ff ff       	call   801021d0 <namei>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	89 c3                	mov    %eax,%ebx
8010518d:	85 c0                	test   %eax,%eax
8010518f:	0f 84 e4 00 00 00    	je     80105279 <sys_link+0x139>
  ilock(ip);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	50                   	push   %eax
80105199:	e8 12 c7 ff ff       	call   801018b0 <ilock>
  if(ip->type == T_DIR){
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a6:	0f 84 b5 00 00 00    	je     80105261 <sys_link+0x121>
  iupdate(ip);
801051ac:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051af:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051b4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051b7:	53                   	push   %ebx
801051b8:	e8 43 c6 ff ff       	call   80101800 <iupdate>
  iunlock(ip);
801051bd:	89 1c 24             	mov    %ebx,(%esp)
801051c0:	e8 cb c7 ff ff       	call   80101990 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051c5:	58                   	pop    %eax
801051c6:	5a                   	pop    %edx
801051c7:	57                   	push   %edi
801051c8:	ff 75 d0             	pushl  -0x30(%ebp)
801051cb:	e8 20 d0 ff ff       	call   801021f0 <nameiparent>
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	89 c6                	mov    %eax,%esi
801051d5:	85 c0                	test   %eax,%eax
801051d7:	74 5b                	je     80105234 <sys_link+0xf4>
  ilock(dp);
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	50                   	push   %eax
801051dd:	e8 ce c6 ff ff       	call   801018b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051e2:	8b 03                	mov    (%ebx),%eax
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	39 06                	cmp    %eax,(%esi)
801051e9:	75 3d                	jne    80105228 <sys_link+0xe8>
801051eb:	83 ec 04             	sub    $0x4,%esp
801051ee:	ff 73 04             	pushl  0x4(%ebx)
801051f1:	57                   	push   %edi
801051f2:	56                   	push   %esi
801051f3:	e8 18 cf ff ff       	call   80102110 <dirlink>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	78 29                	js     80105228 <sys_link+0xe8>
  iunlockput(dp);
801051ff:	83 ec 0c             	sub    $0xc,%esp
80105202:	56                   	push   %esi
80105203:	e8 38 c9 ff ff       	call   80101b40 <iunlockput>
  iput(ip);
80105208:	89 1c 24             	mov    %ebx,(%esp)
8010520b:	e8 d0 c7 ff ff       	call   801019e0 <iput>
  end_op();
80105210:	e8 eb dc ff ff       	call   80102f00 <end_op>
  return 0;
80105215:	83 c4 10             	add    $0x10,%esp
80105218:	31 c0                	xor    %eax,%eax
}
8010521a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010521d:	5b                   	pop    %ebx
8010521e:	5e                   	pop    %esi
8010521f:	5f                   	pop    %edi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	56                   	push   %esi
8010522c:	e8 0f c9 ff ff       	call   80101b40 <iunlockput>
    goto bad;
80105231:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	53                   	push   %ebx
80105238:	e8 73 c6 ff ff       	call   801018b0 <ilock>
  ip->nlink--;
8010523d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105242:	89 1c 24             	mov    %ebx,(%esp)
80105245:	e8 b6 c5 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
8010524a:	89 1c 24             	mov    %ebx,(%esp)
8010524d:	e8 ee c8 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105252:	e8 a9 dc ff ff       	call   80102f00 <end_op>
  return -1;
80105257:	83 c4 10             	add    $0x10,%esp
8010525a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525f:	eb b9                	jmp    8010521a <sys_link+0xda>
    iunlockput(ip);
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	53                   	push   %ebx
80105265:	e8 d6 c8 ff ff       	call   80101b40 <iunlockput>
    end_op();
8010526a:	e8 91 dc ff ff       	call   80102f00 <end_op>
    return -1;
8010526f:	83 c4 10             	add    $0x10,%esp
80105272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105277:	eb a1                	jmp    8010521a <sys_link+0xda>
    end_op();
80105279:	e8 82 dc ff ff       	call   80102f00 <end_op>
    return -1;
8010527e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105283:	eb 95                	jmp    8010521a <sys_link+0xda>
80105285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_unlink>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105295:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105298:	53                   	push   %ebx
80105299:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 bc f9 ff ff       	call   80104c60 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 7a 01 00 00    	js     80105429 <sys_unlink+0x199>
  begin_op();
801052af:	e8 dc db ff ff       	call   80102e90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052b7:	83 ec 08             	sub    $0x8,%esp
801052ba:	53                   	push   %ebx
801052bb:	ff 75 c0             	pushl  -0x40(%ebp)
801052be:	e8 2d cf ff ff       	call   801021f0 <nameiparent>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801052c9:	85 c0                	test   %eax,%eax
801052cb:	0f 84 62 01 00 00    	je     80105433 <sys_unlink+0x1a3>
  ilock(dp);
801052d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	57                   	push   %edi
801052d8:	e8 d3 c5 ff ff       	call   801018b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052dd:	58                   	pop    %eax
801052de:	5a                   	pop    %edx
801052df:	68 a8 7c 10 80       	push   $0x80107ca8
801052e4:	53                   	push   %ebx
801052e5:	e8 06 cb ff ff       	call   80101df0 <namecmp>
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	85 c0                	test   %eax,%eax
801052ef:	0f 84 fb 00 00 00    	je     801053f0 <sys_unlink+0x160>
801052f5:	83 ec 08             	sub    $0x8,%esp
801052f8:	68 a7 7c 10 80       	push   $0x80107ca7
801052fd:	53                   	push   %ebx
801052fe:	e8 ed ca ff ff       	call   80101df0 <namecmp>
80105303:	83 c4 10             	add    $0x10,%esp
80105306:	85 c0                	test   %eax,%eax
80105308:	0f 84 e2 00 00 00    	je     801053f0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010530e:	83 ec 04             	sub    $0x4,%esp
80105311:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105314:	50                   	push   %eax
80105315:	53                   	push   %ebx
80105316:	57                   	push   %edi
80105317:	e8 f4 ca ff ff       	call   80101e10 <dirlookup>
8010531c:	83 c4 10             	add    $0x10,%esp
8010531f:	89 c3                	mov    %eax,%ebx
80105321:	85 c0                	test   %eax,%eax
80105323:	0f 84 c7 00 00 00    	je     801053f0 <sys_unlink+0x160>
  ilock(ip);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 7e c5 ff ff       	call   801018b0 <ilock>
  if(ip->nlink < 1)
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010533a:	0f 8e 1c 01 00 00    	jle    8010545c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105340:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105345:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105348:	74 66                	je     801053b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010534a:	83 ec 04             	sub    $0x4,%esp
8010534d:	6a 10                	push   $0x10
8010534f:	6a 00                	push   $0x0
80105351:	57                   	push   %edi
80105352:	e8 89 f5 ff ff       	call   801048e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105357:	6a 10                	push   $0x10
80105359:	ff 75 c4             	pushl  -0x3c(%ebp)
8010535c:	57                   	push   %edi
8010535d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105360:	e8 5b c9 ff ff       	call   80101cc0 <writei>
80105365:	83 c4 20             	add    $0x20,%esp
80105368:	83 f8 10             	cmp    $0x10,%eax
8010536b:	0f 85 de 00 00 00    	jne    8010544f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105371:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105376:	0f 84 94 00 00 00    	je     80105410 <sys_unlink+0x180>
  iunlockput(dp);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105382:	e8 b9 c7 ff ff       	call   80101b40 <iunlockput>
  ip->nlink--;
80105387:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010538c:	89 1c 24             	mov    %ebx,(%esp)
8010538f:	e8 6c c4 ff ff       	call   80101800 <iupdate>
  iunlockput(ip);
80105394:	89 1c 24             	mov    %ebx,(%esp)
80105397:	e8 a4 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
8010539c:	e8 5f db ff ff       	call   80102f00 <end_op>
  return 0;
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	31 c0                	xor    %eax,%eax
}
801053a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a9:	5b                   	pop    %ebx
801053aa:	5e                   	pop    %esi
801053ab:	5f                   	pop    %edi
801053ac:	5d                   	pop    %ebp
801053ad:	c3                   	ret    
801053ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053b4:	76 94                	jbe    8010534a <sys_unlink+0xba>
801053b6:	be 20 00 00 00       	mov    $0x20,%esi
801053bb:	eb 0b                	jmp    801053c8 <sys_unlink+0x138>
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
801053c0:	83 c6 10             	add    $0x10,%esi
801053c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801053c6:	73 82                	jae    8010534a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c8:	6a 10                	push   $0x10
801053ca:	56                   	push   %esi
801053cb:	57                   	push   %edi
801053cc:	53                   	push   %ebx
801053cd:	e8 ee c7 ff ff       	call   80101bc0 <readi>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	83 f8 10             	cmp    $0x10,%eax
801053d8:	75 68                	jne    80105442 <sys_unlink+0x1b2>
    if(de.inum != 0)
801053da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053df:	74 df                	je     801053c0 <sys_unlink+0x130>
    iunlockput(ip);
801053e1:	83 ec 0c             	sub    $0xc,%esp
801053e4:	53                   	push   %ebx
801053e5:	e8 56 c7 ff ff       	call   80101b40 <iunlockput>
    goto bad;
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	ff 75 b4             	pushl  -0x4c(%ebp)
801053f6:	e8 45 c7 ff ff       	call   80101b40 <iunlockput>
  end_op();
801053fb:	e8 00 db ff ff       	call   80102f00 <end_op>
  return -1;
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105408:	eb 9c                	jmp    801053a6 <sys_unlink+0x116>
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105410:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105413:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105416:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010541b:	50                   	push   %eax
8010541c:	e8 df c3 ff ff       	call   80101800 <iupdate>
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	e9 53 ff ff ff       	jmp    8010537c <sys_unlink+0xec>
    return -1;
80105429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542e:	e9 73 ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
    end_op();
80105433:	e8 c8 da ff ff       	call   80102f00 <end_op>
    return -1;
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	e9 64 ff ff ff       	jmp    801053a6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105442:	83 ec 0c             	sub    $0xc,%esp
80105445:	68 cc 7c 10 80       	push   $0x80107ccc
8010544a:	e8 31 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	68 de 7c 10 80       	push   $0x80107cde
80105457:	e8 24 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	68 ba 7c 10 80       	push   $0x80107cba
80105464:	e8 17 af ff ff       	call   80100380 <panic>
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_open>:

int
sys_open(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105475:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105478:	53                   	push   %ebx
80105479:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 dc f7 ff ff       	call   80104c60 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 8e 00 00 00    	js     8010551d <sys_open+0xad>
8010548f:	83 ec 08             	sub    $0x8,%esp
80105492:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105495:	50                   	push   %eax
80105496:	6a 01                	push   $0x1
80105498:	e8 03 f7 ff ff       	call   80104ba0 <argint>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 79                	js     8010551d <sys_open+0xad>
    return -1;

  begin_op();
801054a4:	e8 e7 d9 ff ff       	call   80102e90 <begin_op>

  if(omode & O_CREATE){
801054a9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054ad:	75 79                	jne    80105528 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	ff 75 e0             	pushl  -0x20(%ebp)
801054b5:	e8 16 cd ff ff       	call   801021d0 <namei>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	89 c6                	mov    %eax,%esi
801054bf:	85 c0                	test   %eax,%eax
801054c1:	0f 84 7e 00 00 00    	je     80105545 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	50                   	push   %eax
801054cb:	e8 e0 c3 ff ff       	call   801018b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d0:	83 c4 10             	add    $0x10,%esp
801054d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054d8:	0f 84 c2 00 00 00    	je     801055a0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054de:	e8 6d ba ff ff       	call   80100f50 <filealloc>
801054e3:	89 c7                	mov    %eax,%edi
801054e5:	85 c0                	test   %eax,%eax
801054e7:	74 23                	je     8010550c <sys_open+0x9c>
  struct proc *curproc = myproc();
801054e9:	e8 c2 e5 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801054f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f4:	85 d2                	test   %edx,%edx
801054f6:	74 60                	je     80105558 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	57                   	push   %edi
80105504:	e8 07 bb ff ff       	call   80101010 <fileclose>
80105509:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010550c:	83 ec 0c             	sub    $0xc,%esp
8010550f:	56                   	push   %esi
80105510:	e8 2b c6 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105515:	e8 e6 d9 ff ff       	call   80102f00 <end_op>
    return -1;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105522:	eb 6d                	jmp    80105591 <sys_open+0x121>
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105528:	83 ec 0c             	sub    $0xc,%esp
8010552b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010552e:	31 c9                	xor    %ecx,%ecx
80105530:	ba 02 00 00 00       	mov    $0x2,%edx
80105535:	6a 00                	push   $0x0
80105537:	e8 14 f8 ff ff       	call   80104d50 <create>
    if(ip == 0){
8010553c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010553f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105541:	85 c0                	test   %eax,%eax
80105543:	75 99                	jne    801054de <sys_open+0x6e>
      end_op();
80105545:	e8 b6 d9 ff ff       	call   80102f00 <end_op>
      return -1;
8010554a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010554f:	eb 40                	jmp    80105591 <sys_open+0x121>
80105551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105558:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010555b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010555f:	56                   	push   %esi
80105560:	e8 2b c4 ff ff       	call   80101990 <iunlock>
  end_op();
80105565:	e8 96 d9 ff ff       	call   80102f00 <end_op>

  f->type = FD_INODE;
8010556a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105570:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105573:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105576:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105579:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010557b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105582:	f7 d0                	not    %eax
80105584:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105587:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010558a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010558d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105594:	89 d8                	mov    %ebx,%eax
80105596:	5b                   	pop    %ebx
80105597:	5e                   	pop    %esi
80105598:	5f                   	pop    %edi
80105599:	5d                   	pop    %ebp
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055a3:	85 c9                	test   %ecx,%ecx
801055a5:	0f 84 33 ff ff ff    	je     801054de <sys_open+0x6e>
801055ab:	e9 5c ff ff ff       	jmp    8010550c <sys_open+0x9c>

801055b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055b6:	e8 d5 d8 ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055bb:	83 ec 08             	sub    $0x8,%esp
801055be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 97 f6 ff ff       	call   80104c60 <argstr>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 30                	js     80105600 <sys_mkdir+0x50>
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	ba 01 00 00 00       	mov    $0x1,%edx
801055dd:	6a 00                	push   $0x0
801055df:	e8 6c f7 ff ff       	call   80104d50 <create>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	74 15                	je     80105600 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	50                   	push   %eax
801055ef:	e8 4c c5 ff ff       	call   80101b40 <iunlockput>
  end_op();
801055f4:	e8 07 d9 ff ff       	call   80102f00 <end_op>
  return 0;
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	31 c0                	xor    %eax,%eax
}
801055fe:	c9                   	leave  
801055ff:	c3                   	ret    
    end_op();
80105600:	e8 fb d8 ff ff       	call   80102f00 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_mknod>:

int
sys_mknod(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105616:	e8 75 d8 ff ff       	call   80102e90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010561b:	83 ec 08             	sub    $0x8,%esp
8010561e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105621:	50                   	push   %eax
80105622:	6a 00                	push   $0x0
80105624:	e8 37 f6 ff ff       	call   80104c60 <argstr>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	85 c0                	test   %eax,%eax
8010562e:	78 60                	js     80105690 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 62 f5 ff ff       	call   80104ba0 <argint>
  if((argstr(0, &path)) < 0 ||
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 4b                	js     80105690 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	6a 02                	push   $0x2
8010564e:	e8 4d f5 ff ff       	call   80104ba0 <argint>
     argint(1, &major) < 0 ||
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 36                	js     80105690 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010565a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010565e:	83 ec 0c             	sub    $0xc,%esp
80105661:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105665:	ba 03 00 00 00       	mov    $0x3,%edx
8010566a:	50                   	push   %eax
8010566b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010566e:	e8 dd f6 ff ff       	call   80104d50 <create>
     argint(2, &minor) < 0 ||
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	74 16                	je     80105690 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	50                   	push   %eax
8010567e:	e8 bd c4 ff ff       	call   80101b40 <iunlockput>
  end_op();
80105683:	e8 78 d8 ff ff       	call   80102f00 <end_op>
  return 0;
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	31 c0                	xor    %eax,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop
    end_op();
80105690:	e8 6b d8 ff ff       	call   80102f00 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_chdir>:

int
sys_chdir(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056a8:	e8 03 e4 ff ff       	call   80103ab0 <myproc>
801056ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056af:	e8 dc d7 ff ff       	call   80102e90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056b4:	83 ec 08             	sub    $0x8,%esp
801056b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 9e f5 ff ff       	call   80104c60 <argstr>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 77                	js     80105740 <sys_chdir+0xa0>
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	ff 75 f4             	pushl  -0xc(%ebp)
801056cf:	e8 fc ca ff ff       	call   801021d0 <namei>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	89 c3                	mov    %eax,%ebx
801056d9:	85 c0                	test   %eax,%eax
801056db:	74 63                	je     80105740 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	50                   	push   %eax
801056e1:	e8 ca c1 ff ff       	call   801018b0 <ilock>
  if(ip->type != T_DIR){
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ee:	75 30                	jne    80105720 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 97 c2 ff ff       	call   80101990 <iunlock>
  iput(curproc->cwd);
801056f9:	58                   	pop    %eax
801056fa:	ff 76 68             	pushl  0x68(%esi)
801056fd:	e8 de c2 ff ff       	call   801019e0 <iput>
  end_op();
80105702:	e8 f9 d7 ff ff       	call   80102f00 <end_op>
  curproc->cwd = ip;
80105707:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	31 c0                	xor    %eax,%eax
}
8010570f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 17 c4 ff ff       	call   80101b40 <iunlockput>
    end_op();
80105729:	e8 d2 d7 ff ff       	call   80102f00 <end_op>
    return -1;
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105736:	eb d7                	jmp    8010570f <sys_chdir+0x6f>
80105738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573f:	90                   	nop
    end_op();
80105740:	e8 bb d7 ff ff       	call   80102f00 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	eb c3                	jmp    8010570f <sys_chdir+0x6f>
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exec>:

int
sys_exec(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105755:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010575b:	53                   	push   %ebx
8010575c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105762:	50                   	push   %eax
80105763:	6a 00                	push   $0x0
80105765:	e8 f6 f4 ff ff       	call   80104c60 <argstr>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	0f 88 87 00 00 00    	js     801057fc <sys_exec+0xac>
80105775:	83 ec 08             	sub    $0x8,%esp
80105778:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010577e:	50                   	push   %eax
8010577f:	6a 01                	push   $0x1
80105781:	e8 1a f4 ff ff       	call   80104ba0 <argint>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 6f                	js     801057fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010578d:	83 ec 04             	sub    $0x4,%esp
80105790:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105796:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105798:	68 80 00 00 00       	push   $0x80
8010579d:	6a 00                	push   $0x0
8010579f:	56                   	push   %esi
801057a0:	e8 3b f1 ff ff       	call   801048e0 <memset>
801057a5:	83 c4 10             	add    $0x10,%esp
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801057b9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801057c0:	50                   	push   %eax
801057c1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057c7:	01 f8                	add    %edi,%eax
801057c9:	50                   	push   %eax
801057ca:	e8 41 f3 ff ff       	call   80104b10 <fetchint>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	78 26                	js     801057fc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057d6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057dc:	85 c0                	test   %eax,%eax
801057de:	74 30                	je     80105810 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801057e6:	52                   	push   %edx
801057e7:	50                   	push   %eax
801057e8:	e8 63 f3 ff ff       	call   80104b50 <fetchstr>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 08                	js     801057fc <sys_exec+0xac>
  for(i=0;; i++){
801057f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057f7:	83 fb 20             	cmp    $0x20,%ebx
801057fa:	75 b4                	jne    801057b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801057fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105804:	5b                   	pop    %ebx
80105805:	5e                   	pop    %esi
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105810:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105817:	00 00 00 00 
  return exec(path, argv);
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	56                   	push   %esi
8010581f:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105825:	e8 a6 b3 ff ff       	call   80100bd0 <exec>
8010582a:	83 c4 10             	add    $0x10,%esp
}
8010582d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105830:	5b                   	pop    %ebx
80105831:	5e                   	pop    %esi
80105832:	5f                   	pop    %edi
80105833:	5d                   	pop    %ebp
80105834:	c3                   	ret    
80105835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_pipe>:

int
sys_pipe(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105845:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105848:	53                   	push   %ebx
80105849:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010584c:	6a 08                	push   $0x8
8010584e:	50                   	push   %eax
8010584f:	6a 00                	push   $0x0
80105851:	e8 9a f3 ff ff       	call   80104bf0 <argptr>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	78 4a                	js     801058a7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010585d:	83 ec 08             	sub    $0x8,%esp
80105860:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105863:	50                   	push   %eax
80105864:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105867:	50                   	push   %eax
80105868:	e8 f3 dc ff ff       	call   80103560 <pipealloc>
8010586d:	83 c4 10             	add    $0x10,%esp
80105870:	85 c0                	test   %eax,%eax
80105872:	78 33                	js     801058a7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105874:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105877:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105879:	e8 32 e2 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010587e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105880:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105884:	85 f6                	test   %esi,%esi
80105886:	74 28                	je     801058b0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105888:	83 c3 01             	add    $0x1,%ebx
8010588b:	83 fb 10             	cmp    $0x10,%ebx
8010588e:	75 f0                	jne    80105880 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	ff 75 e0             	pushl  -0x20(%ebp)
80105896:	e8 75 b7 ff ff       	call   80101010 <fileclose>
    fileclose(wf);
8010589b:	58                   	pop    %eax
8010589c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010589f:	e8 6c b7 ff ff       	call   80101010 <fileclose>
    return -1;
801058a4:	83 c4 10             	add    $0x10,%esp
801058a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ac:	eb 53                	jmp    80105901 <sys_pipe+0xc1>
801058ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058b0:	8d 73 08             	lea    0x8(%ebx),%esi
801058b3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ba:	e8 f1 e1 ff ff       	call   80103ab0 <myproc>
801058bf:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
801058c1:	31 c0                	xor    %eax,%eax
801058c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058c7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801058c8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801058cc:	85 c9                	test   %ecx,%ecx
801058ce:	74 20                	je     801058f0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058d0:	83 c0 01             	add    $0x1,%eax
801058d3:	83 f8 10             	cmp    $0x10,%eax
801058d6:	75 f0                	jne    801058c8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058d8:	e8 d3 e1 ff ff       	call   80103ab0 <myproc>
801058dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058e4:	00 
801058e5:	eb a9                	jmp    80105890 <sys_pipe+0x50>
801058e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ee:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058f0:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
801058f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058f7:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801058f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058fc:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
801058ff:	31 c0                	xor    %eax,%eax
}
80105901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105904:	5b                   	pop    %ebx
80105905:	5e                   	pop    %esi
80105906:	5f                   	pop    %edi
80105907:	5d                   	pop    %ebp
80105908:	c3                   	ret    
80105909:	66 90                	xchg   %ax,%ax
8010590b:	66 90                	xchg   %ax,%ax
8010590d:	66 90                	xchg   %ax,%ax
8010590f:	90                   	nop

80105910 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105910:	e9 2b e8 ff ff       	jmp    80104140 <fork>
80105915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010591c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105920 <sys_exit>:
}

int
sys_exit(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 08             	sub    $0x8,%esp
  exit();
80105926:	e8 d5 e4 ff ff       	call   80103e00 <exit>
  return 0;  // not reached
}
8010592b:	31 c0                	xor    %eax,%eax
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    
8010592f:	90                   	nop

80105930 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105930:	e9 fb e5 ff ff       	jmp    80103f30 <wait>
80105935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_kill>:
}

int
sys_kill(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105946:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105949:	50                   	push   %eax
8010594a:	6a 00                	push   $0x0
8010594c:	e8 4f f2 ff ff       	call   80104ba0 <argint>
80105951:	83 c4 10             	add    $0x10,%esp
80105954:	85 c0                	test   %eax,%eax
80105956:	78 18                	js     80105970 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	ff 75 f4             	pushl  -0xc(%ebp)
8010595e:	e8 2d ea ff ff       	call   80104390 <kill>
80105963:	83 c4 10             	add    $0x10,%esp
}
80105966:	c9                   	leave  
80105967:	c3                   	ret    
80105968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
80105970:	c9                   	leave  
    return -1;
80105971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105976:	c3                   	ret    
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_getpid>:

int
sys_getpid(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105986:	e8 25 e1 ff ff       	call   80103ab0 <myproc>
8010598b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    

80105990 <sys_sbrk>:

int
sys_sbrk(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105997:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010599a:	50                   	push   %eax
8010599b:	6a 00                	push   $0x0
8010599d:	e8 fe f1 ff ff       	call   80104ba0 <argint>
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	85 c0                	test   %eax,%eax
801059a7:	78 27                	js     801059d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059a9:	e8 02 e1 ff ff       	call   80103ab0 <myproc>
  if(growproc(n) < 0)
801059ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059b3:	ff 75 f4             	pushl  -0xc(%ebp)
801059b6:	e8 15 e2 ff ff       	call   80103bd0 <growproc>
801059bb:	83 c4 10             	add    $0x10,%esp
801059be:	85 c0                	test   %eax,%eax
801059c0:	78 0e                	js     801059d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059c2:	89 d8                	mov    %ebx,%eax
801059c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059c7:	c9                   	leave  
801059c8:	c3                   	ret    
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059d5:	eb eb                	jmp    801059c2 <sys_sbrk+0x32>
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax

801059e0 <sys_sleep>:

int
sys_sleep(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 ae f1 ff ff       	call   80104ba0 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	0f 88 8a 00 00 00    	js     80105a87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	68 a0 3d 11 80       	push   $0x80113da0
80105a05:	e8 66 ed ff ff       	call   80104770 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a0d:	8b 1d 80 3d 11 80    	mov    0x80113d80,%ebx
  while(ticks - ticks0 < n){
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	85 d2                	test   %edx,%edx
80105a18:	75 27                	jne    80105a41 <sys_sleep+0x61>
80105a1a:	eb 54                	jmp    80105a70 <sys_sleep+0x90>
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	68 a0 3d 11 80       	push   $0x80113da0
80105a28:	68 80 3d 11 80       	push   $0x80113d80
80105a2d:	e8 3e e8 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
80105a32:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80105a37:	83 c4 10             	add    $0x10,%esp
80105a3a:	29 d8                	sub    %ebx,%eax
80105a3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a3f:	73 2f                	jae    80105a70 <sys_sleep+0x90>
    if(myproc()->killed){
80105a41:	e8 6a e0 ff ff       	call   80103ab0 <myproc>
80105a46:	8b 40 24             	mov    0x24(%eax),%eax
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	74 d3                	je     80105a20 <sys_sleep+0x40>
      release(&tickslock);
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	68 a0 3d 11 80       	push   $0x80113da0
80105a55:	e8 36 ee ff ff       	call   80104890 <release>
  }
  release(&tickslock);
  return 0;
}
80105a5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a65:	c9                   	leave  
80105a66:	c3                   	ret    
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	68 a0 3d 11 80       	push   $0x80113da0
80105a78:	e8 13 ee ff ff       	call   80104890 <release>
  return 0;
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	31 c0                	xor    %eax,%eax
}
80105a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
    return -1;
80105a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a8c:	eb f4                	jmp    80105a82 <sys_sleep+0xa2>
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	53                   	push   %ebx
80105a94:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a97:	68 a0 3d 11 80       	push   $0x80113da0
80105a9c:	e8 cf ec ff ff       	call   80104770 <acquire>
  xticks = ticks;
80105aa1:	8b 1d 80 3d 11 80    	mov    0x80113d80,%ebx
  release(&tickslock);
80105aa7:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80105aae:	e8 dd ed ff ff       	call   80104890 <release>
  return xticks;
}
80105ab3:	89 d8                	mov    %ebx,%eax
80105ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab8:	c9                   	leave  
80105ab9:	c3                   	ret    
80105aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ac0 <sys_shutdown>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ac0:	b8 00 20 00 00       	mov    $0x2000,%eax
80105ac5:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105aca:	66 ef                	out    %ax,(%dx)
80105acc:	ba 04 06 00 00       	mov    $0x604,%edx
80105ad1:	66 ef                	out    %ax,(%dx)
  /* Either of the following will work. Does not harm to put them together. */
  outw(0xB004, 0x0|0x2000); // working for old qemu
  outw(0x604, 0x0|0x2000); // working for newer qemu
  
  return 0;
}
80105ad3:	31 c0                	xor    %eax,%eax
80105ad5:	c3                   	ret    
80105ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105add:	8d 76 00             	lea    0x0(%esi),%esi

80105ae0 <sys_enable_sched_trace>:

extern int sched_trace_enabled;
extern int sched_trace_counter;
int sys_enable_sched_trace(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 10             	sub    $0x10,%esp
  if (argint(0, &sched_trace_enabled) < 0)
80105ae6:	68 2c 1d 11 80       	push   $0x80111d2c
80105aeb:	6a 00                	push   $0x0
80105aed:	e8 ae f0 ff ff       	call   80104ba0 <argint>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	78 17                	js     80105b10 <sys_enable_sched_trace+0x30>
  {
    cprintf("enable_sched_trace() failed!\n");
  }

  sched_trace_counter = 0;
80105af9:	c7 05 28 1d 11 80 00 	movl   $0x0,0x80111d28
80105b00:	00 00 00 

  return 0;
}
80105b03:	31 c0                	xor    %eax,%eax
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b0e:	66 90                	xchg   %ax,%ax
    cprintf("enable_sched_trace() failed!\n");
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	68 ed 7c 10 80       	push   $0x80107ced
80105b18:	e8 63 ab ff ff       	call   80100680 <cprintf>
80105b1d:	83 c4 10             	add    $0x10,%esp
}
80105b20:	31 c0                	xor    %eax,%eax
  sched_trace_counter = 0;
80105b22:	c7 05 28 1d 11 80 00 	movl   $0x0,0x80111d28
80105b29:	00 00 00 
}
80105b2c:	c9                   	leave  
80105b2d:	c3                   	ret    
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <sys_fork_winner>:

extern int child_first;
int sys_fork_winner(void) {
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 10             	sub    $0x10,%esp
  if(argint(0, &child_first) < 0)
80105b36:	68 24 1d 11 80       	push   $0x80111d24
80105b3b:	6a 00                	push   $0x0
80105b3d:	e8 5e f0 ff ff       	call   80104ba0 <argint>
    return -1;
  return 0;
}
80105b42:	c9                   	leave  
  if(argint(0, &child_first) < 0)
80105b43:	c1 f8 1f             	sar    $0x1f,%eax
}
80105b46:	c3                   	ret    
80105b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_set_sched>:

int sys_set_sched(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 20             	sub    $0x20,%esp
 int argValue;
 if(!argint(0,&argValue))
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	50                   	push   %eax
80105b5a:	6a 00                	push   $0x0
80105b5c:	e8 3f f0 ff ff       	call   80104ba0 <argint>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	75 11                	jne    80105b79 <sys_set_sched+0x29>
  {
	//cprintf("\n\ninside method value of m: %d",m );
	if(argValue)
80105b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	74 0a                	je     80105b79 <sys_set_sched+0x29>
	  policy = 1;  //use stride scheduling
80105b6f:	c7 05 20 1d 11 80 01 	movl   $0x1,0x80111d20
80105b76:	00 00 00 
  }
	return 0;
}
80105b79:	c9                   	leave  
80105b7a:	31 c0                	xor    %eax,%eax
80105b7c:	c3                   	ret    
80105b7d:	8d 76 00             	lea    0x0(%esi),%esi

80105b80 <sys_set_priority>:

int
sys_set_priority(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 20             	sub    $0x20,%esp
    int pid, priority;
    if(argint(0, &pid) < 0)
80105b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b89:	50                   	push   %eax
80105b8a:	6a 00                	push   $0x0
80105b8c:	e8 0f f0 ff ff       	call   80104ba0 <argint>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 28                	js     80105bc0 <sys_set_priority+0x40>
        return -1;
    if(argint(1, &priority) < 0)
80105b98:	83 ec 08             	sub    $0x8,%esp
80105b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9e:	50                   	push   %eax
80105b9f:	6a 01                	push   $0x1
80105ba1:	e8 fa ef ff ff       	call   80104ba0 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 13                	js     80105bc0 <sys_set_priority+0x40>
        return -1;

    return setpriority(pid, priority);
80105bad:	83 ec 08             	sub    $0x8,%esp
80105bb0:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb3:	ff 75 f0             	pushl  -0x10(%ebp)
80105bb6:	e8 15 e9 ff ff       	call   801044d0 <setpriority>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
80105bc0:	c9                   	leave  
        return -1;
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	c3                   	ret    

80105bc7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bc7:	1e                   	push   %ds
  pushl %es
80105bc8:	06                   	push   %es
  pushl %fs
80105bc9:	0f a0                	push   %fs
  pushl %gs
80105bcb:	0f a8                	push   %gs
  pushal
80105bcd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bd2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bd4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bd6:	54                   	push   %esp
  call trap
80105bd7:	e8 c4 00 00 00       	call   80105ca0 <trap>
  addl $4, %esp
80105bdc:	83 c4 04             	add    $0x4,%esp

80105bdf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bdf:	61                   	popa   
  popl %gs
80105be0:	0f a9                	pop    %gs
  popl %fs
80105be2:	0f a1                	pop    %fs
  popl %es
80105be4:	07                   	pop    %es
  popl %ds
80105be5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105be6:	83 c4 08             	add    $0x8,%esp
  iret
80105be9:	cf                   	iret   
80105bea:	66 90                	xchg   %ax,%ax
80105bec:	66 90                	xchg   %ax,%ax
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bf0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bf1:	31 c0                	xor    %eax,%eax
{
80105bf3:	89 e5                	mov    %esp,%ebp
80105bf5:	83 ec 08             	sub    $0x8,%esp
80105bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c00:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c07:	c7 04 c5 e2 3d 11 80 	movl   $0x8e000008,-0x7feec21e(,%eax,8)
80105c0e:	08 00 00 8e 
80105c12:	66 89 14 c5 e0 3d 11 	mov    %dx,-0x7feec220(,%eax,8)
80105c19:	80 
80105c1a:	c1 ea 10             	shr    $0x10,%edx
80105c1d:	66 89 14 c5 e6 3d 11 	mov    %dx,-0x7feec21a(,%eax,8)
80105c24:	80 
  for(i = 0; i < 256; i++)
80105c25:	83 c0 01             	add    $0x1,%eax
80105c28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c2d:	75 d1                	jne    80105c00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c2f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c32:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c37:	c7 05 e2 3f 11 80 08 	movl   $0xef000008,0x80113fe2
80105c3e:	00 00 ef 
  initlock(&tickslock, "time");
80105c41:	68 0b 7d 10 80       	push   $0x80107d0b
80105c46:	68 a0 3d 11 80       	push   $0x80113da0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c4b:	66 a3 e0 3f 11 80    	mov    %ax,0x80113fe0
80105c51:	c1 e8 10             	shr    $0x10,%eax
80105c54:	66 a3 e6 3f 11 80    	mov    %ax,0x80113fe6
  initlock(&tickslock, "time");
80105c5a:	e8 01 ea ff ff       	call   80104660 <initlock>
}
80105c5f:	83 c4 10             	add    $0x10,%esp
80105c62:	c9                   	leave  
80105c63:	c3                   	ret    
80105c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c6f:	90                   	nop

80105c70 <idtinit>:

void
idtinit(void)
{
80105c70:	55                   	push   %ebp
  pd[0] = size-1;
80105c71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c76:	89 e5                	mov    %esp,%ebp
80105c78:	83 ec 10             	sub    $0x10,%esp
80105c7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c7f:	b8 e0 3d 11 80       	mov    $0x80113de0,%eax
80105c84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c88:	c1 e8 10             	shr    $0x10,%eax
80105c8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c95:	c9                   	leave  
80105c96:	c3                   	ret    
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	57                   	push   %edi
80105ca4:	56                   	push   %esi
80105ca5:	53                   	push   %ebx
80105ca6:	83 ec 1c             	sub    $0x1c,%esp
80105ca9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cac:	8b 43 30             	mov    0x30(%ebx),%eax
80105caf:	83 f8 40             	cmp    $0x40,%eax
80105cb2:	0f 84 68 01 00 00    	je     80105e20 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cb8:	83 e8 20             	sub    $0x20,%eax
80105cbb:	83 f8 1f             	cmp    $0x1f,%eax
80105cbe:	0f 87 8c 00 00 00    	ja     80105d50 <trap+0xb0>
80105cc4:	ff 24 85 b4 7d 10 80 	jmp    *-0x7fef824c(,%eax,4)
80105ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105cd0:	e8 9b c6 ff ff       	call   80102370 <ideintr>
    lapiceoi();
80105cd5:	e8 66 cd ff ff       	call   80102a40 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cda:	e8 d1 dd ff ff       	call   80103ab0 <myproc>
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	74 1d                	je     80105d00 <trap+0x60>
80105ce3:	e8 c8 dd ff ff       	call   80103ab0 <myproc>
80105ce8:	8b 50 24             	mov    0x24(%eax),%edx
80105ceb:	85 d2                	test   %edx,%edx
80105ced:	74 11                	je     80105d00 <trap+0x60>
80105cef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cf3:	83 e0 03             	and    $0x3,%eax
80105cf6:	66 83 f8 03          	cmp    $0x3,%ax
80105cfa:	0f 84 e8 01 00 00    	je     80105ee8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d00:	e8 ab dd ff ff       	call   80103ab0 <myproc>
80105d05:	85 c0                	test   %eax,%eax
80105d07:	74 0f                	je     80105d18 <trap+0x78>
80105d09:	e8 a2 dd ff ff       	call   80103ab0 <myproc>
80105d0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d12:	0f 84 b8 00 00 00    	je     80105dd0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d18:	e8 93 dd ff ff       	call   80103ab0 <myproc>
80105d1d:	85 c0                	test   %eax,%eax
80105d1f:	74 1d                	je     80105d3e <trap+0x9e>
80105d21:	e8 8a dd ff ff       	call   80103ab0 <myproc>
80105d26:	8b 40 24             	mov    0x24(%eax),%eax
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	74 11                	je     80105d3e <trap+0x9e>
80105d2d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d31:	83 e0 03             	and    $0x3,%eax
80105d34:	66 83 f8 03          	cmp    $0x3,%ax
80105d38:	0f 84 0f 01 00 00    	je     80105e4d <trap+0x1ad>
    exit();
}
80105d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d41:	5b                   	pop    %ebx
80105d42:	5e                   	pop    %esi
80105d43:	5f                   	pop    %edi
80105d44:	5d                   	pop    %ebp
80105d45:	c3                   	ret    
80105d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d50:	e8 5b dd ff ff       	call   80103ab0 <myproc>
80105d55:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d58:	85 c0                	test   %eax,%eax
80105d5a:	0f 84 a2 01 00 00    	je     80105f02 <trap+0x262>
80105d60:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d64:	0f 84 98 01 00 00    	je     80105f02 <trap+0x262>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d6a:	0f 20 d1             	mov    %cr2,%ecx
80105d6d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d70:	e8 1b dd ff ff       	call   80103a90 <cpuid>
80105d75:	8b 73 30             	mov    0x30(%ebx),%esi
80105d78:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d7b:	8b 43 34             	mov    0x34(%ebx),%eax
80105d7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105d81:	e8 2a dd ff ff       	call   80103ab0 <myproc>
80105d86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d89:	e8 22 dd ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d8e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d94:	51                   	push   %ecx
80105d95:	57                   	push   %edi
80105d96:	52                   	push   %edx
80105d97:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d9a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d9b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105d9e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105da1:	56                   	push   %esi
80105da2:	ff 70 10             	pushl  0x10(%eax)
80105da5:	68 70 7d 10 80       	push   $0x80107d70
80105daa:	e8 d1 a8 ff ff       	call   80100680 <cprintf>
    myproc()->killed = 1;
80105daf:	83 c4 20             	add    $0x20,%esp
80105db2:	e8 f9 dc ff ff       	call   80103ab0 <myproc>
80105db7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dbe:	e8 ed dc ff ff       	call   80103ab0 <myproc>
80105dc3:	85 c0                	test   %eax,%eax
80105dc5:	0f 85 18 ff ff ff    	jne    80105ce3 <trap+0x43>
80105dcb:	e9 30 ff ff ff       	jmp    80105d00 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105dd0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105dd4:	0f 85 3e ff ff ff    	jne    80105d18 <trap+0x78>
    yield();
80105dda:	e8 81 e2 ff ff       	call   80104060 <yield>
80105ddf:	e9 34 ff ff ff       	jmp    80105d18 <trap+0x78>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105de8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105deb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105def:	e8 9c dc ff ff       	call   80103a90 <cpuid>
80105df4:	57                   	push   %edi
80105df5:	56                   	push   %esi
80105df6:	50                   	push   %eax
80105df7:	68 18 7d 10 80       	push   $0x80107d18
80105dfc:	e8 7f a8 ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105e01:	e8 3a cc ff ff       	call   80102a40 <lapiceoi>
    break;
80105e06:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e09:	e8 a2 dc ff ff       	call   80103ab0 <myproc>
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	0f 85 cd fe ff ff    	jne    80105ce3 <trap+0x43>
80105e16:	e9 e5 fe ff ff       	jmp    80105d00 <trap+0x60>
80105e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e1f:	90                   	nop
    if(myproc()->killed)
80105e20:	e8 8b dc ff ff       	call   80103ab0 <myproc>
80105e25:	8b 70 24             	mov    0x24(%eax),%esi
80105e28:	85 f6                	test   %esi,%esi
80105e2a:	0f 85 c8 00 00 00    	jne    80105ef8 <trap+0x258>
    myproc()->tf = tf;
80105e30:	e8 7b dc ff ff       	call   80103ab0 <myproc>
80105e35:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e38:	e8 a3 ee ff ff       	call   80104ce0 <syscall>
    if(myproc()->killed)
80105e3d:	e8 6e dc ff ff       	call   80103ab0 <myproc>
80105e42:	8b 48 24             	mov    0x24(%eax),%ecx
80105e45:	85 c9                	test   %ecx,%ecx
80105e47:	0f 84 f1 fe ff ff    	je     80105d3e <trap+0x9e>
}
80105e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e50:	5b                   	pop    %ebx
80105e51:	5e                   	pop    %esi
80105e52:	5f                   	pop    %edi
80105e53:	5d                   	pop    %ebp
      exit();
80105e54:	e9 a7 df ff ff       	jmp    80103e00 <exit>
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e60:	e8 5b 02 00 00       	call   801060c0 <uartintr>
    lapiceoi();
80105e65:	e8 d6 cb ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e6a:	e8 41 dc ff ff       	call   80103ab0 <myproc>
80105e6f:	85 c0                	test   %eax,%eax
80105e71:	0f 85 6c fe ff ff    	jne    80105ce3 <trap+0x43>
80105e77:	e9 84 fe ff ff       	jmp    80105d00 <trap+0x60>
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e80:	e8 7b ca ff ff       	call   80102900 <kbdintr>
    lapiceoi();
80105e85:	e8 b6 cb ff ff       	call   80102a40 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e8a:	e8 21 dc ff ff       	call   80103ab0 <myproc>
80105e8f:	85 c0                	test   %eax,%eax
80105e91:	0f 85 4c fe ff ff    	jne    80105ce3 <trap+0x43>
80105e97:	e9 64 fe ff ff       	jmp    80105d00 <trap+0x60>
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ea0:	e8 eb db ff ff       	call   80103a90 <cpuid>
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	0f 85 28 fe ff ff    	jne    80105cd5 <trap+0x35>
      acquire(&tickslock);
80105ead:	83 ec 0c             	sub    $0xc,%esp
80105eb0:	68 a0 3d 11 80       	push   $0x80113da0
80105eb5:	e8 b6 e8 ff ff       	call   80104770 <acquire>
      wakeup(&ticks);
80105eba:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
      ticks++;
80105ec1:	83 05 80 3d 11 80 01 	addl   $0x1,0x80113d80
      wakeup(&ticks);
80105ec8:	e8 63 e4 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
80105ecd:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80105ed4:	e8 b7 e9 ff ff       	call   80104890 <release>
80105ed9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105edc:	e9 f4 fd ff ff       	jmp    80105cd5 <trap+0x35>
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105ee8:	e8 13 df ff ff       	call   80103e00 <exit>
80105eed:	e9 0e fe ff ff       	jmp    80105d00 <trap+0x60>
80105ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105ef8:	e8 03 df ff ff       	call   80103e00 <exit>
80105efd:	e9 2e ff ff ff       	jmp    80105e30 <trap+0x190>
80105f02:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f05:	e8 86 db ff ff       	call   80103a90 <cpuid>
80105f0a:	83 ec 0c             	sub    $0xc,%esp
80105f0d:	56                   	push   %esi
80105f0e:	57                   	push   %edi
80105f0f:	50                   	push   %eax
80105f10:	ff 73 30             	pushl  0x30(%ebx)
80105f13:	68 3c 7d 10 80       	push   $0x80107d3c
80105f18:	e8 63 a7 ff ff       	call   80100680 <cprintf>
      panic("trap");
80105f1d:	83 c4 14             	add    $0x14,%esp
80105f20:	68 10 7d 10 80       	push   $0x80107d10
80105f25:	e8 56 a4 ff ff       	call   80100380 <panic>
80105f2a:	66 90                	xchg   %ax,%ax
80105f2c:	66 90                	xchg   %ax,%ax
80105f2e:	66 90                	xchg   %ax,%ax

80105f30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f30:	a1 e0 45 11 80       	mov    0x801145e0,%eax
80105f35:	85 c0                	test   %eax,%eax
80105f37:	74 17                	je     80105f50 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f39:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f3e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f3f:	a8 01                	test   $0x1,%al
80105f41:	74 0d                	je     80105f50 <uartgetc+0x20>
80105f43:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f48:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f49:	0f b6 c0             	movzbl %al,%eax
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f55:	c3                   	ret    
80105f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5d:	8d 76 00             	lea    0x0(%esi),%esi

80105f60 <uartinit>:
{
80105f60:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f61:	31 c9                	xor    %ecx,%ecx
80105f63:	89 c8                	mov    %ecx,%eax
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	57                   	push   %edi
80105f68:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105f6d:	56                   	push   %esi
80105f6e:	89 fa                	mov    %edi,%edx
80105f70:	53                   	push   %ebx
80105f71:	83 ec 1c             	sub    $0x1c,%esp
80105f74:	ee                   	out    %al,(%dx)
80105f75:	be fb 03 00 00       	mov    $0x3fb,%esi
80105f7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f7f:	89 f2                	mov    %esi,%edx
80105f81:	ee                   	out    %al,(%dx)
80105f82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8c:	ee                   	out    %al,(%dx)
80105f8d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105f92:	89 c8                	mov    %ecx,%eax
80105f94:	89 da                	mov    %ebx,%edx
80105f96:	ee                   	out    %al,(%dx)
80105f97:	b8 03 00 00 00       	mov    $0x3,%eax
80105f9c:	89 f2                	mov    %esi,%edx
80105f9e:	ee                   	out    %al,(%dx)
80105f9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fa4:	89 c8                	mov    %ecx,%eax
80105fa6:	ee                   	out    %al,(%dx)
80105fa7:	b8 01 00 00 00       	mov    $0x1,%eax
80105fac:	89 da                	mov    %ebx,%edx
80105fae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105faf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fb4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fb5:	3c ff                	cmp    $0xff,%al
80105fb7:	0f 84 93 00 00 00    	je     80106050 <uartinit+0xf0>
  uart = 1;
80105fbd:	c7 05 e0 45 11 80 01 	movl   $0x1,0x801145e0
80105fc4:	00 00 00 
80105fc7:	89 fa                	mov    %edi,%edx
80105fc9:	ec                   	in     (%dx),%al
80105fca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fcf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105fd0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105fd3:	bf 34 7e 10 80       	mov    $0x80107e34,%edi
80105fd8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105fdd:	6a 00                	push   $0x0
80105fdf:	6a 04                	push   $0x4
80105fe1:	e8 ca c5 ff ff       	call   801025b0 <ioapicenable>
80105fe6:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
80105fea:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fed:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80105ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105ff8:	a1 e0 45 11 80       	mov    0x801145e0,%eax
80105ffd:	bb 80 00 00 00       	mov    $0x80,%ebx
80106002:	85 c0                	test   %eax,%eax
80106004:	75 1c                	jne    80106022 <uartinit+0xc2>
80106006:	eb 2b                	jmp    80106033 <uartinit+0xd3>
80106008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
    microdelay(10);
80106010:	83 ec 0c             	sub    $0xc,%esp
80106013:	6a 0a                	push   $0xa
80106015:	e8 46 ca ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010601a:	83 c4 10             	add    $0x10,%esp
8010601d:	83 eb 01             	sub    $0x1,%ebx
80106020:	74 07                	je     80106029 <uartinit+0xc9>
80106022:	89 f2                	mov    %esi,%edx
80106024:	ec                   	in     (%dx),%al
80106025:	a8 20                	test   $0x20,%al
80106027:	74 e7                	je     80106010 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106029:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
8010602d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106032:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106033:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106037:	83 c7 01             	add    $0x1,%edi
8010603a:	84 c0                	test   %al,%al
8010603c:	74 12                	je     80106050 <uartinit+0xf0>
8010603e:	88 45 e6             	mov    %al,-0x1a(%ebp)
80106041:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106045:	88 45 e7             	mov    %al,-0x19(%ebp)
80106048:	eb ae                	jmp    80105ff8 <uartinit+0x98>
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106050:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106053:	5b                   	pop    %ebx
80106054:	5e                   	pop    %esi
80106055:	5f                   	pop    %edi
80106056:	5d                   	pop    %ebp
80106057:	c3                   	ret    
80106058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605f:	90                   	nop

80106060 <uartputc>:
  if(!uart)
80106060:	a1 e0 45 11 80       	mov    0x801145e0,%eax
80106065:	85 c0                	test   %eax,%eax
80106067:	74 47                	je     801060b0 <uartputc+0x50>
{
80106069:	55                   	push   %ebp
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010606d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106072:	53                   	push   %ebx
80106073:	bb 80 00 00 00       	mov    $0x80,%ebx
80106078:	eb 18                	jmp    80106092 <uartputc+0x32>
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	6a 0a                	push   $0xa
80106085:	e8 d6 c9 ff ff       	call   80102a60 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	83 eb 01             	sub    $0x1,%ebx
80106090:	74 07                	je     80106099 <uartputc+0x39>
80106092:	89 f2                	mov    %esi,%edx
80106094:	ec                   	in     (%dx),%al
80106095:	a8 20                	test   $0x20,%al
80106097:	74 e7                	je     80106080 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106099:	8b 45 08             	mov    0x8(%ebp),%eax
8010609c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060a1:	ee                   	out    %al,(%dx)
}
801060a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060a5:	5b                   	pop    %ebx
801060a6:	5e                   	pop    %esi
801060a7:	5d                   	pop    %ebp
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b0:	c3                   	ret    
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bf:	90                   	nop

801060c0 <uartintr>:

void
uartintr(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060c6:	68 30 5f 10 80       	push   $0x80105f30
801060cb:	e8 20 a8 ff ff       	call   801008f0 <consoleintr>
}
801060d0:	83 c4 10             	add    $0x10,%esp
801060d3:	c9                   	leave  
801060d4:	c3                   	ret    

801060d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $0
801060d7:	6a 00                	push   $0x0
  jmp alltraps
801060d9:	e9 e9 fa ff ff       	jmp    80105bc7 <alltraps>

801060de <vector1>:
.globl vector1
vector1:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $1
801060e0:	6a 01                	push   $0x1
  jmp alltraps
801060e2:	e9 e0 fa ff ff       	jmp    80105bc7 <alltraps>

801060e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $2
801060e9:	6a 02                	push   $0x2
  jmp alltraps
801060eb:	e9 d7 fa ff ff       	jmp    80105bc7 <alltraps>

801060f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $3
801060f2:	6a 03                	push   $0x3
  jmp alltraps
801060f4:	e9 ce fa ff ff       	jmp    80105bc7 <alltraps>

801060f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $4
801060fb:	6a 04                	push   $0x4
  jmp alltraps
801060fd:	e9 c5 fa ff ff       	jmp    80105bc7 <alltraps>

80106102 <vector5>:
.globl vector5
vector5:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $5
80106104:	6a 05                	push   $0x5
  jmp alltraps
80106106:	e9 bc fa ff ff       	jmp    80105bc7 <alltraps>

8010610b <vector6>:
.globl vector6
vector6:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $6
8010610d:	6a 06                	push   $0x6
  jmp alltraps
8010610f:	e9 b3 fa ff ff       	jmp    80105bc7 <alltraps>

80106114 <vector7>:
.globl vector7
vector7:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $7
80106116:	6a 07                	push   $0x7
  jmp alltraps
80106118:	e9 aa fa ff ff       	jmp    80105bc7 <alltraps>

8010611d <vector8>:
.globl vector8
vector8:
  pushl $8
8010611d:	6a 08                	push   $0x8
  jmp alltraps
8010611f:	e9 a3 fa ff ff       	jmp    80105bc7 <alltraps>

80106124 <vector9>:
.globl vector9
vector9:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $9
80106126:	6a 09                	push   $0x9
  jmp alltraps
80106128:	e9 9a fa ff ff       	jmp    80105bc7 <alltraps>

8010612d <vector10>:
.globl vector10
vector10:
  pushl $10
8010612d:	6a 0a                	push   $0xa
  jmp alltraps
8010612f:	e9 93 fa ff ff       	jmp    80105bc7 <alltraps>

80106134 <vector11>:
.globl vector11
vector11:
  pushl $11
80106134:	6a 0b                	push   $0xb
  jmp alltraps
80106136:	e9 8c fa ff ff       	jmp    80105bc7 <alltraps>

8010613b <vector12>:
.globl vector12
vector12:
  pushl $12
8010613b:	6a 0c                	push   $0xc
  jmp alltraps
8010613d:	e9 85 fa ff ff       	jmp    80105bc7 <alltraps>

80106142 <vector13>:
.globl vector13
vector13:
  pushl $13
80106142:	6a 0d                	push   $0xd
  jmp alltraps
80106144:	e9 7e fa ff ff       	jmp    80105bc7 <alltraps>

80106149 <vector14>:
.globl vector14
vector14:
  pushl $14
80106149:	6a 0e                	push   $0xe
  jmp alltraps
8010614b:	e9 77 fa ff ff       	jmp    80105bc7 <alltraps>

80106150 <vector15>:
.globl vector15
vector15:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $15
80106152:	6a 0f                	push   $0xf
  jmp alltraps
80106154:	e9 6e fa ff ff       	jmp    80105bc7 <alltraps>

80106159 <vector16>:
.globl vector16
vector16:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $16
8010615b:	6a 10                	push   $0x10
  jmp alltraps
8010615d:	e9 65 fa ff ff       	jmp    80105bc7 <alltraps>

80106162 <vector17>:
.globl vector17
vector17:
  pushl $17
80106162:	6a 11                	push   $0x11
  jmp alltraps
80106164:	e9 5e fa ff ff       	jmp    80105bc7 <alltraps>

80106169 <vector18>:
.globl vector18
vector18:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $18
8010616b:	6a 12                	push   $0x12
  jmp alltraps
8010616d:	e9 55 fa ff ff       	jmp    80105bc7 <alltraps>

80106172 <vector19>:
.globl vector19
vector19:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $19
80106174:	6a 13                	push   $0x13
  jmp alltraps
80106176:	e9 4c fa ff ff       	jmp    80105bc7 <alltraps>

8010617b <vector20>:
.globl vector20
vector20:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $20
8010617d:	6a 14                	push   $0x14
  jmp alltraps
8010617f:	e9 43 fa ff ff       	jmp    80105bc7 <alltraps>

80106184 <vector21>:
.globl vector21
vector21:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $21
80106186:	6a 15                	push   $0x15
  jmp alltraps
80106188:	e9 3a fa ff ff       	jmp    80105bc7 <alltraps>

8010618d <vector22>:
.globl vector22
vector22:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $22
8010618f:	6a 16                	push   $0x16
  jmp alltraps
80106191:	e9 31 fa ff ff       	jmp    80105bc7 <alltraps>

80106196 <vector23>:
.globl vector23
vector23:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $23
80106198:	6a 17                	push   $0x17
  jmp alltraps
8010619a:	e9 28 fa ff ff       	jmp    80105bc7 <alltraps>

8010619f <vector24>:
.globl vector24
vector24:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $24
801061a1:	6a 18                	push   $0x18
  jmp alltraps
801061a3:	e9 1f fa ff ff       	jmp    80105bc7 <alltraps>

801061a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $25
801061aa:	6a 19                	push   $0x19
  jmp alltraps
801061ac:	e9 16 fa ff ff       	jmp    80105bc7 <alltraps>

801061b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $26
801061b3:	6a 1a                	push   $0x1a
  jmp alltraps
801061b5:	e9 0d fa ff ff       	jmp    80105bc7 <alltraps>

801061ba <vector27>:
.globl vector27
vector27:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $27
801061bc:	6a 1b                	push   $0x1b
  jmp alltraps
801061be:	e9 04 fa ff ff       	jmp    80105bc7 <alltraps>

801061c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $28
801061c5:	6a 1c                	push   $0x1c
  jmp alltraps
801061c7:	e9 fb f9 ff ff       	jmp    80105bc7 <alltraps>

801061cc <vector29>:
.globl vector29
vector29:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $29
801061ce:	6a 1d                	push   $0x1d
  jmp alltraps
801061d0:	e9 f2 f9 ff ff       	jmp    80105bc7 <alltraps>

801061d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $30
801061d7:	6a 1e                	push   $0x1e
  jmp alltraps
801061d9:	e9 e9 f9 ff ff       	jmp    80105bc7 <alltraps>

801061de <vector31>:
.globl vector31
vector31:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $31
801061e0:	6a 1f                	push   $0x1f
  jmp alltraps
801061e2:	e9 e0 f9 ff ff       	jmp    80105bc7 <alltraps>

801061e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $32
801061e9:	6a 20                	push   $0x20
  jmp alltraps
801061eb:	e9 d7 f9 ff ff       	jmp    80105bc7 <alltraps>

801061f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $33
801061f2:	6a 21                	push   $0x21
  jmp alltraps
801061f4:	e9 ce f9 ff ff       	jmp    80105bc7 <alltraps>

801061f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $34
801061fb:	6a 22                	push   $0x22
  jmp alltraps
801061fd:	e9 c5 f9 ff ff       	jmp    80105bc7 <alltraps>

80106202 <vector35>:
.globl vector35
vector35:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $35
80106204:	6a 23                	push   $0x23
  jmp alltraps
80106206:	e9 bc f9 ff ff       	jmp    80105bc7 <alltraps>

8010620b <vector36>:
.globl vector36
vector36:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $36
8010620d:	6a 24                	push   $0x24
  jmp alltraps
8010620f:	e9 b3 f9 ff ff       	jmp    80105bc7 <alltraps>

80106214 <vector37>:
.globl vector37
vector37:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $37
80106216:	6a 25                	push   $0x25
  jmp alltraps
80106218:	e9 aa f9 ff ff       	jmp    80105bc7 <alltraps>

8010621d <vector38>:
.globl vector38
vector38:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $38
8010621f:	6a 26                	push   $0x26
  jmp alltraps
80106221:	e9 a1 f9 ff ff       	jmp    80105bc7 <alltraps>

80106226 <vector39>:
.globl vector39
vector39:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $39
80106228:	6a 27                	push   $0x27
  jmp alltraps
8010622a:	e9 98 f9 ff ff       	jmp    80105bc7 <alltraps>

8010622f <vector40>:
.globl vector40
vector40:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $40
80106231:	6a 28                	push   $0x28
  jmp alltraps
80106233:	e9 8f f9 ff ff       	jmp    80105bc7 <alltraps>

80106238 <vector41>:
.globl vector41
vector41:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $41
8010623a:	6a 29                	push   $0x29
  jmp alltraps
8010623c:	e9 86 f9 ff ff       	jmp    80105bc7 <alltraps>

80106241 <vector42>:
.globl vector42
vector42:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $42
80106243:	6a 2a                	push   $0x2a
  jmp alltraps
80106245:	e9 7d f9 ff ff       	jmp    80105bc7 <alltraps>

8010624a <vector43>:
.globl vector43
vector43:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $43
8010624c:	6a 2b                	push   $0x2b
  jmp alltraps
8010624e:	e9 74 f9 ff ff       	jmp    80105bc7 <alltraps>

80106253 <vector44>:
.globl vector44
vector44:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $44
80106255:	6a 2c                	push   $0x2c
  jmp alltraps
80106257:	e9 6b f9 ff ff       	jmp    80105bc7 <alltraps>

8010625c <vector45>:
.globl vector45
vector45:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $45
8010625e:	6a 2d                	push   $0x2d
  jmp alltraps
80106260:	e9 62 f9 ff ff       	jmp    80105bc7 <alltraps>

80106265 <vector46>:
.globl vector46
vector46:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $46
80106267:	6a 2e                	push   $0x2e
  jmp alltraps
80106269:	e9 59 f9 ff ff       	jmp    80105bc7 <alltraps>

8010626e <vector47>:
.globl vector47
vector47:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $47
80106270:	6a 2f                	push   $0x2f
  jmp alltraps
80106272:	e9 50 f9 ff ff       	jmp    80105bc7 <alltraps>

80106277 <vector48>:
.globl vector48
vector48:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $48
80106279:	6a 30                	push   $0x30
  jmp alltraps
8010627b:	e9 47 f9 ff ff       	jmp    80105bc7 <alltraps>

80106280 <vector49>:
.globl vector49
vector49:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $49
80106282:	6a 31                	push   $0x31
  jmp alltraps
80106284:	e9 3e f9 ff ff       	jmp    80105bc7 <alltraps>

80106289 <vector50>:
.globl vector50
vector50:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $50
8010628b:	6a 32                	push   $0x32
  jmp alltraps
8010628d:	e9 35 f9 ff ff       	jmp    80105bc7 <alltraps>

80106292 <vector51>:
.globl vector51
vector51:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $51
80106294:	6a 33                	push   $0x33
  jmp alltraps
80106296:	e9 2c f9 ff ff       	jmp    80105bc7 <alltraps>

8010629b <vector52>:
.globl vector52
vector52:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $52
8010629d:	6a 34                	push   $0x34
  jmp alltraps
8010629f:	e9 23 f9 ff ff       	jmp    80105bc7 <alltraps>

801062a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $53
801062a6:	6a 35                	push   $0x35
  jmp alltraps
801062a8:	e9 1a f9 ff ff       	jmp    80105bc7 <alltraps>

801062ad <vector54>:
.globl vector54
vector54:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $54
801062af:	6a 36                	push   $0x36
  jmp alltraps
801062b1:	e9 11 f9 ff ff       	jmp    80105bc7 <alltraps>

801062b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $55
801062b8:	6a 37                	push   $0x37
  jmp alltraps
801062ba:	e9 08 f9 ff ff       	jmp    80105bc7 <alltraps>

801062bf <vector56>:
.globl vector56
vector56:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $56
801062c1:	6a 38                	push   $0x38
  jmp alltraps
801062c3:	e9 ff f8 ff ff       	jmp    80105bc7 <alltraps>

801062c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $57
801062ca:	6a 39                	push   $0x39
  jmp alltraps
801062cc:	e9 f6 f8 ff ff       	jmp    80105bc7 <alltraps>

801062d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $58
801062d3:	6a 3a                	push   $0x3a
  jmp alltraps
801062d5:	e9 ed f8 ff ff       	jmp    80105bc7 <alltraps>

801062da <vector59>:
.globl vector59
vector59:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $59
801062dc:	6a 3b                	push   $0x3b
  jmp alltraps
801062de:	e9 e4 f8 ff ff       	jmp    80105bc7 <alltraps>

801062e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $60
801062e5:	6a 3c                	push   $0x3c
  jmp alltraps
801062e7:	e9 db f8 ff ff       	jmp    80105bc7 <alltraps>

801062ec <vector61>:
.globl vector61
vector61:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $61
801062ee:	6a 3d                	push   $0x3d
  jmp alltraps
801062f0:	e9 d2 f8 ff ff       	jmp    80105bc7 <alltraps>

801062f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $62
801062f7:	6a 3e                	push   $0x3e
  jmp alltraps
801062f9:	e9 c9 f8 ff ff       	jmp    80105bc7 <alltraps>

801062fe <vector63>:
.globl vector63
vector63:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $63
80106300:	6a 3f                	push   $0x3f
  jmp alltraps
80106302:	e9 c0 f8 ff ff       	jmp    80105bc7 <alltraps>

80106307 <vector64>:
.globl vector64
vector64:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $64
80106309:	6a 40                	push   $0x40
  jmp alltraps
8010630b:	e9 b7 f8 ff ff       	jmp    80105bc7 <alltraps>

80106310 <vector65>:
.globl vector65
vector65:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $65
80106312:	6a 41                	push   $0x41
  jmp alltraps
80106314:	e9 ae f8 ff ff       	jmp    80105bc7 <alltraps>

80106319 <vector66>:
.globl vector66
vector66:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $66
8010631b:	6a 42                	push   $0x42
  jmp alltraps
8010631d:	e9 a5 f8 ff ff       	jmp    80105bc7 <alltraps>

80106322 <vector67>:
.globl vector67
vector67:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $67
80106324:	6a 43                	push   $0x43
  jmp alltraps
80106326:	e9 9c f8 ff ff       	jmp    80105bc7 <alltraps>

8010632b <vector68>:
.globl vector68
vector68:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $68
8010632d:	6a 44                	push   $0x44
  jmp alltraps
8010632f:	e9 93 f8 ff ff       	jmp    80105bc7 <alltraps>

80106334 <vector69>:
.globl vector69
vector69:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $69
80106336:	6a 45                	push   $0x45
  jmp alltraps
80106338:	e9 8a f8 ff ff       	jmp    80105bc7 <alltraps>

8010633d <vector70>:
.globl vector70
vector70:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $70
8010633f:	6a 46                	push   $0x46
  jmp alltraps
80106341:	e9 81 f8 ff ff       	jmp    80105bc7 <alltraps>

80106346 <vector71>:
.globl vector71
vector71:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $71
80106348:	6a 47                	push   $0x47
  jmp alltraps
8010634a:	e9 78 f8 ff ff       	jmp    80105bc7 <alltraps>

8010634f <vector72>:
.globl vector72
vector72:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $72
80106351:	6a 48                	push   $0x48
  jmp alltraps
80106353:	e9 6f f8 ff ff       	jmp    80105bc7 <alltraps>

80106358 <vector73>:
.globl vector73
vector73:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $73
8010635a:	6a 49                	push   $0x49
  jmp alltraps
8010635c:	e9 66 f8 ff ff       	jmp    80105bc7 <alltraps>

80106361 <vector74>:
.globl vector74
vector74:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $74
80106363:	6a 4a                	push   $0x4a
  jmp alltraps
80106365:	e9 5d f8 ff ff       	jmp    80105bc7 <alltraps>

8010636a <vector75>:
.globl vector75
vector75:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $75
8010636c:	6a 4b                	push   $0x4b
  jmp alltraps
8010636e:	e9 54 f8 ff ff       	jmp    80105bc7 <alltraps>

80106373 <vector76>:
.globl vector76
vector76:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $76
80106375:	6a 4c                	push   $0x4c
  jmp alltraps
80106377:	e9 4b f8 ff ff       	jmp    80105bc7 <alltraps>

8010637c <vector77>:
.globl vector77
vector77:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $77
8010637e:	6a 4d                	push   $0x4d
  jmp alltraps
80106380:	e9 42 f8 ff ff       	jmp    80105bc7 <alltraps>

80106385 <vector78>:
.globl vector78
vector78:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $78
80106387:	6a 4e                	push   $0x4e
  jmp alltraps
80106389:	e9 39 f8 ff ff       	jmp    80105bc7 <alltraps>

8010638e <vector79>:
.globl vector79
vector79:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $79
80106390:	6a 4f                	push   $0x4f
  jmp alltraps
80106392:	e9 30 f8 ff ff       	jmp    80105bc7 <alltraps>

80106397 <vector80>:
.globl vector80
vector80:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $80
80106399:	6a 50                	push   $0x50
  jmp alltraps
8010639b:	e9 27 f8 ff ff       	jmp    80105bc7 <alltraps>

801063a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $81
801063a2:	6a 51                	push   $0x51
  jmp alltraps
801063a4:	e9 1e f8 ff ff       	jmp    80105bc7 <alltraps>

801063a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $82
801063ab:	6a 52                	push   $0x52
  jmp alltraps
801063ad:	e9 15 f8 ff ff       	jmp    80105bc7 <alltraps>

801063b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $83
801063b4:	6a 53                	push   $0x53
  jmp alltraps
801063b6:	e9 0c f8 ff ff       	jmp    80105bc7 <alltraps>

801063bb <vector84>:
.globl vector84
vector84:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $84
801063bd:	6a 54                	push   $0x54
  jmp alltraps
801063bf:	e9 03 f8 ff ff       	jmp    80105bc7 <alltraps>

801063c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $85
801063c6:	6a 55                	push   $0x55
  jmp alltraps
801063c8:	e9 fa f7 ff ff       	jmp    80105bc7 <alltraps>

801063cd <vector86>:
.globl vector86
vector86:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $86
801063cf:	6a 56                	push   $0x56
  jmp alltraps
801063d1:	e9 f1 f7 ff ff       	jmp    80105bc7 <alltraps>

801063d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $87
801063d8:	6a 57                	push   $0x57
  jmp alltraps
801063da:	e9 e8 f7 ff ff       	jmp    80105bc7 <alltraps>

801063df <vector88>:
.globl vector88
vector88:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $88
801063e1:	6a 58                	push   $0x58
  jmp alltraps
801063e3:	e9 df f7 ff ff       	jmp    80105bc7 <alltraps>

801063e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $89
801063ea:	6a 59                	push   $0x59
  jmp alltraps
801063ec:	e9 d6 f7 ff ff       	jmp    80105bc7 <alltraps>

801063f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $90
801063f3:	6a 5a                	push   $0x5a
  jmp alltraps
801063f5:	e9 cd f7 ff ff       	jmp    80105bc7 <alltraps>

801063fa <vector91>:
.globl vector91
vector91:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $91
801063fc:	6a 5b                	push   $0x5b
  jmp alltraps
801063fe:	e9 c4 f7 ff ff       	jmp    80105bc7 <alltraps>

80106403 <vector92>:
.globl vector92
vector92:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $92
80106405:	6a 5c                	push   $0x5c
  jmp alltraps
80106407:	e9 bb f7 ff ff       	jmp    80105bc7 <alltraps>

8010640c <vector93>:
.globl vector93
vector93:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $93
8010640e:	6a 5d                	push   $0x5d
  jmp alltraps
80106410:	e9 b2 f7 ff ff       	jmp    80105bc7 <alltraps>

80106415 <vector94>:
.globl vector94
vector94:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $94
80106417:	6a 5e                	push   $0x5e
  jmp alltraps
80106419:	e9 a9 f7 ff ff       	jmp    80105bc7 <alltraps>

8010641e <vector95>:
.globl vector95
vector95:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $95
80106420:	6a 5f                	push   $0x5f
  jmp alltraps
80106422:	e9 a0 f7 ff ff       	jmp    80105bc7 <alltraps>

80106427 <vector96>:
.globl vector96
vector96:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $96
80106429:	6a 60                	push   $0x60
  jmp alltraps
8010642b:	e9 97 f7 ff ff       	jmp    80105bc7 <alltraps>

80106430 <vector97>:
.globl vector97
vector97:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $97
80106432:	6a 61                	push   $0x61
  jmp alltraps
80106434:	e9 8e f7 ff ff       	jmp    80105bc7 <alltraps>

80106439 <vector98>:
.globl vector98
vector98:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $98
8010643b:	6a 62                	push   $0x62
  jmp alltraps
8010643d:	e9 85 f7 ff ff       	jmp    80105bc7 <alltraps>

80106442 <vector99>:
.globl vector99
vector99:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $99
80106444:	6a 63                	push   $0x63
  jmp alltraps
80106446:	e9 7c f7 ff ff       	jmp    80105bc7 <alltraps>

8010644b <vector100>:
.globl vector100
vector100:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $100
8010644d:	6a 64                	push   $0x64
  jmp alltraps
8010644f:	e9 73 f7 ff ff       	jmp    80105bc7 <alltraps>

80106454 <vector101>:
.globl vector101
vector101:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $101
80106456:	6a 65                	push   $0x65
  jmp alltraps
80106458:	e9 6a f7 ff ff       	jmp    80105bc7 <alltraps>

8010645d <vector102>:
.globl vector102
vector102:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $102
8010645f:	6a 66                	push   $0x66
  jmp alltraps
80106461:	e9 61 f7 ff ff       	jmp    80105bc7 <alltraps>

80106466 <vector103>:
.globl vector103
vector103:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $103
80106468:	6a 67                	push   $0x67
  jmp alltraps
8010646a:	e9 58 f7 ff ff       	jmp    80105bc7 <alltraps>

8010646f <vector104>:
.globl vector104
vector104:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $104
80106471:	6a 68                	push   $0x68
  jmp alltraps
80106473:	e9 4f f7 ff ff       	jmp    80105bc7 <alltraps>

80106478 <vector105>:
.globl vector105
vector105:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $105
8010647a:	6a 69                	push   $0x69
  jmp alltraps
8010647c:	e9 46 f7 ff ff       	jmp    80105bc7 <alltraps>

80106481 <vector106>:
.globl vector106
vector106:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $106
80106483:	6a 6a                	push   $0x6a
  jmp alltraps
80106485:	e9 3d f7 ff ff       	jmp    80105bc7 <alltraps>

8010648a <vector107>:
.globl vector107
vector107:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $107
8010648c:	6a 6b                	push   $0x6b
  jmp alltraps
8010648e:	e9 34 f7 ff ff       	jmp    80105bc7 <alltraps>

80106493 <vector108>:
.globl vector108
vector108:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $108
80106495:	6a 6c                	push   $0x6c
  jmp alltraps
80106497:	e9 2b f7 ff ff       	jmp    80105bc7 <alltraps>

8010649c <vector109>:
.globl vector109
vector109:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $109
8010649e:	6a 6d                	push   $0x6d
  jmp alltraps
801064a0:	e9 22 f7 ff ff       	jmp    80105bc7 <alltraps>

801064a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $110
801064a7:	6a 6e                	push   $0x6e
  jmp alltraps
801064a9:	e9 19 f7 ff ff       	jmp    80105bc7 <alltraps>

801064ae <vector111>:
.globl vector111
vector111:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $111
801064b0:	6a 6f                	push   $0x6f
  jmp alltraps
801064b2:	e9 10 f7 ff ff       	jmp    80105bc7 <alltraps>

801064b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $112
801064b9:	6a 70                	push   $0x70
  jmp alltraps
801064bb:	e9 07 f7 ff ff       	jmp    80105bc7 <alltraps>

801064c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $113
801064c2:	6a 71                	push   $0x71
  jmp alltraps
801064c4:	e9 fe f6 ff ff       	jmp    80105bc7 <alltraps>

801064c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $114
801064cb:	6a 72                	push   $0x72
  jmp alltraps
801064cd:	e9 f5 f6 ff ff       	jmp    80105bc7 <alltraps>

801064d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $115
801064d4:	6a 73                	push   $0x73
  jmp alltraps
801064d6:	e9 ec f6 ff ff       	jmp    80105bc7 <alltraps>

801064db <vector116>:
.globl vector116
vector116:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $116
801064dd:	6a 74                	push   $0x74
  jmp alltraps
801064df:	e9 e3 f6 ff ff       	jmp    80105bc7 <alltraps>

801064e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $117
801064e6:	6a 75                	push   $0x75
  jmp alltraps
801064e8:	e9 da f6 ff ff       	jmp    80105bc7 <alltraps>

801064ed <vector118>:
.globl vector118
vector118:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $118
801064ef:	6a 76                	push   $0x76
  jmp alltraps
801064f1:	e9 d1 f6 ff ff       	jmp    80105bc7 <alltraps>

801064f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $119
801064f8:	6a 77                	push   $0x77
  jmp alltraps
801064fa:	e9 c8 f6 ff ff       	jmp    80105bc7 <alltraps>

801064ff <vector120>:
.globl vector120
vector120:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $120
80106501:	6a 78                	push   $0x78
  jmp alltraps
80106503:	e9 bf f6 ff ff       	jmp    80105bc7 <alltraps>

80106508 <vector121>:
.globl vector121
vector121:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $121
8010650a:	6a 79                	push   $0x79
  jmp alltraps
8010650c:	e9 b6 f6 ff ff       	jmp    80105bc7 <alltraps>

80106511 <vector122>:
.globl vector122
vector122:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $122
80106513:	6a 7a                	push   $0x7a
  jmp alltraps
80106515:	e9 ad f6 ff ff       	jmp    80105bc7 <alltraps>

8010651a <vector123>:
.globl vector123
vector123:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $123
8010651c:	6a 7b                	push   $0x7b
  jmp alltraps
8010651e:	e9 a4 f6 ff ff       	jmp    80105bc7 <alltraps>

80106523 <vector124>:
.globl vector124
vector124:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $124
80106525:	6a 7c                	push   $0x7c
  jmp alltraps
80106527:	e9 9b f6 ff ff       	jmp    80105bc7 <alltraps>

8010652c <vector125>:
.globl vector125
vector125:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $125
8010652e:	6a 7d                	push   $0x7d
  jmp alltraps
80106530:	e9 92 f6 ff ff       	jmp    80105bc7 <alltraps>

80106535 <vector126>:
.globl vector126
vector126:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $126
80106537:	6a 7e                	push   $0x7e
  jmp alltraps
80106539:	e9 89 f6 ff ff       	jmp    80105bc7 <alltraps>

8010653e <vector127>:
.globl vector127
vector127:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $127
80106540:	6a 7f                	push   $0x7f
  jmp alltraps
80106542:	e9 80 f6 ff ff       	jmp    80105bc7 <alltraps>

80106547 <vector128>:
.globl vector128
vector128:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $128
80106549:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010654e:	e9 74 f6 ff ff       	jmp    80105bc7 <alltraps>

80106553 <vector129>:
.globl vector129
vector129:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $129
80106555:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010655a:	e9 68 f6 ff ff       	jmp    80105bc7 <alltraps>

8010655f <vector130>:
.globl vector130
vector130:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $130
80106561:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106566:	e9 5c f6 ff ff       	jmp    80105bc7 <alltraps>

8010656b <vector131>:
.globl vector131
vector131:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $131
8010656d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106572:	e9 50 f6 ff ff       	jmp    80105bc7 <alltraps>

80106577 <vector132>:
.globl vector132
vector132:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $132
80106579:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010657e:	e9 44 f6 ff ff       	jmp    80105bc7 <alltraps>

80106583 <vector133>:
.globl vector133
vector133:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $133
80106585:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010658a:	e9 38 f6 ff ff       	jmp    80105bc7 <alltraps>

8010658f <vector134>:
.globl vector134
vector134:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $134
80106591:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106596:	e9 2c f6 ff ff       	jmp    80105bc7 <alltraps>

8010659b <vector135>:
.globl vector135
vector135:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $135
8010659d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065a2:	e9 20 f6 ff ff       	jmp    80105bc7 <alltraps>

801065a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $136
801065a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065ae:	e9 14 f6 ff ff       	jmp    80105bc7 <alltraps>

801065b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $137
801065b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065ba:	e9 08 f6 ff ff       	jmp    80105bc7 <alltraps>

801065bf <vector138>:
.globl vector138
vector138:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $138
801065c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065c6:	e9 fc f5 ff ff       	jmp    80105bc7 <alltraps>

801065cb <vector139>:
.globl vector139
vector139:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $139
801065cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065d2:	e9 f0 f5 ff ff       	jmp    80105bc7 <alltraps>

801065d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $140
801065d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065de:	e9 e4 f5 ff ff       	jmp    80105bc7 <alltraps>

801065e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $141
801065e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065ea:	e9 d8 f5 ff ff       	jmp    80105bc7 <alltraps>

801065ef <vector142>:
.globl vector142
vector142:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $142
801065f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801065f6:	e9 cc f5 ff ff       	jmp    80105bc7 <alltraps>

801065fb <vector143>:
.globl vector143
vector143:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $143
801065fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106602:	e9 c0 f5 ff ff       	jmp    80105bc7 <alltraps>

80106607 <vector144>:
.globl vector144
vector144:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $144
80106609:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010660e:	e9 b4 f5 ff ff       	jmp    80105bc7 <alltraps>

80106613 <vector145>:
.globl vector145
vector145:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $145
80106615:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010661a:	e9 a8 f5 ff ff       	jmp    80105bc7 <alltraps>

8010661f <vector146>:
.globl vector146
vector146:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $146
80106621:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106626:	e9 9c f5 ff ff       	jmp    80105bc7 <alltraps>

8010662b <vector147>:
.globl vector147
vector147:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $147
8010662d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106632:	e9 90 f5 ff ff       	jmp    80105bc7 <alltraps>

80106637 <vector148>:
.globl vector148
vector148:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $148
80106639:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010663e:	e9 84 f5 ff ff       	jmp    80105bc7 <alltraps>

80106643 <vector149>:
.globl vector149
vector149:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $149
80106645:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010664a:	e9 78 f5 ff ff       	jmp    80105bc7 <alltraps>

8010664f <vector150>:
.globl vector150
vector150:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $150
80106651:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106656:	e9 6c f5 ff ff       	jmp    80105bc7 <alltraps>

8010665b <vector151>:
.globl vector151
vector151:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $151
8010665d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106662:	e9 60 f5 ff ff       	jmp    80105bc7 <alltraps>

80106667 <vector152>:
.globl vector152
vector152:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $152
80106669:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010666e:	e9 54 f5 ff ff       	jmp    80105bc7 <alltraps>

80106673 <vector153>:
.globl vector153
vector153:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $153
80106675:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010667a:	e9 48 f5 ff ff       	jmp    80105bc7 <alltraps>

8010667f <vector154>:
.globl vector154
vector154:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $154
80106681:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106686:	e9 3c f5 ff ff       	jmp    80105bc7 <alltraps>

8010668b <vector155>:
.globl vector155
vector155:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $155
8010668d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106692:	e9 30 f5 ff ff       	jmp    80105bc7 <alltraps>

80106697 <vector156>:
.globl vector156
vector156:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $156
80106699:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010669e:	e9 24 f5 ff ff       	jmp    80105bc7 <alltraps>

801066a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $157
801066a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066aa:	e9 18 f5 ff ff       	jmp    80105bc7 <alltraps>

801066af <vector158>:
.globl vector158
vector158:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $158
801066b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066b6:	e9 0c f5 ff ff       	jmp    80105bc7 <alltraps>

801066bb <vector159>:
.globl vector159
vector159:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $159
801066bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066c2:	e9 00 f5 ff ff       	jmp    80105bc7 <alltraps>

801066c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $160
801066c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066ce:	e9 f4 f4 ff ff       	jmp    80105bc7 <alltraps>

801066d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $161
801066d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066da:	e9 e8 f4 ff ff       	jmp    80105bc7 <alltraps>

801066df <vector162>:
.globl vector162
vector162:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $162
801066e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066e6:	e9 dc f4 ff ff       	jmp    80105bc7 <alltraps>

801066eb <vector163>:
.globl vector163
vector163:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $163
801066ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801066f2:	e9 d0 f4 ff ff       	jmp    80105bc7 <alltraps>

801066f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $164
801066f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801066fe:	e9 c4 f4 ff ff       	jmp    80105bc7 <alltraps>

80106703 <vector165>:
.globl vector165
vector165:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $165
80106705:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010670a:	e9 b8 f4 ff ff       	jmp    80105bc7 <alltraps>

8010670f <vector166>:
.globl vector166
vector166:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $166
80106711:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106716:	e9 ac f4 ff ff       	jmp    80105bc7 <alltraps>

8010671b <vector167>:
.globl vector167
vector167:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $167
8010671d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106722:	e9 a0 f4 ff ff       	jmp    80105bc7 <alltraps>

80106727 <vector168>:
.globl vector168
vector168:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $168
80106729:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010672e:	e9 94 f4 ff ff       	jmp    80105bc7 <alltraps>

80106733 <vector169>:
.globl vector169
vector169:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $169
80106735:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010673a:	e9 88 f4 ff ff       	jmp    80105bc7 <alltraps>

8010673f <vector170>:
.globl vector170
vector170:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $170
80106741:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106746:	e9 7c f4 ff ff       	jmp    80105bc7 <alltraps>

8010674b <vector171>:
.globl vector171
vector171:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $171
8010674d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106752:	e9 70 f4 ff ff       	jmp    80105bc7 <alltraps>

80106757 <vector172>:
.globl vector172
vector172:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $172
80106759:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010675e:	e9 64 f4 ff ff       	jmp    80105bc7 <alltraps>

80106763 <vector173>:
.globl vector173
vector173:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $173
80106765:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010676a:	e9 58 f4 ff ff       	jmp    80105bc7 <alltraps>

8010676f <vector174>:
.globl vector174
vector174:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $174
80106771:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106776:	e9 4c f4 ff ff       	jmp    80105bc7 <alltraps>

8010677b <vector175>:
.globl vector175
vector175:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $175
8010677d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106782:	e9 40 f4 ff ff       	jmp    80105bc7 <alltraps>

80106787 <vector176>:
.globl vector176
vector176:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $176
80106789:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010678e:	e9 34 f4 ff ff       	jmp    80105bc7 <alltraps>

80106793 <vector177>:
.globl vector177
vector177:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $177
80106795:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010679a:	e9 28 f4 ff ff       	jmp    80105bc7 <alltraps>

8010679f <vector178>:
.globl vector178
vector178:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $178
801067a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067a6:	e9 1c f4 ff ff       	jmp    80105bc7 <alltraps>

801067ab <vector179>:
.globl vector179
vector179:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $179
801067ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067b2:	e9 10 f4 ff ff       	jmp    80105bc7 <alltraps>

801067b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $180
801067b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067be:	e9 04 f4 ff ff       	jmp    80105bc7 <alltraps>

801067c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $181
801067c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067ca:	e9 f8 f3 ff ff       	jmp    80105bc7 <alltraps>

801067cf <vector182>:
.globl vector182
vector182:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $182
801067d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067d6:	e9 ec f3 ff ff       	jmp    80105bc7 <alltraps>

801067db <vector183>:
.globl vector183
vector183:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $183
801067dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067e2:	e9 e0 f3 ff ff       	jmp    80105bc7 <alltraps>

801067e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $184
801067e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067ee:	e9 d4 f3 ff ff       	jmp    80105bc7 <alltraps>

801067f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $185
801067f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801067fa:	e9 c8 f3 ff ff       	jmp    80105bc7 <alltraps>

801067ff <vector186>:
.globl vector186
vector186:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $186
80106801:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106806:	e9 bc f3 ff ff       	jmp    80105bc7 <alltraps>

8010680b <vector187>:
.globl vector187
vector187:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $187
8010680d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106812:	e9 b0 f3 ff ff       	jmp    80105bc7 <alltraps>

80106817 <vector188>:
.globl vector188
vector188:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $188
80106819:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010681e:	e9 a4 f3 ff ff       	jmp    80105bc7 <alltraps>

80106823 <vector189>:
.globl vector189
vector189:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $189
80106825:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010682a:	e9 98 f3 ff ff       	jmp    80105bc7 <alltraps>

8010682f <vector190>:
.globl vector190
vector190:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $190
80106831:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106836:	e9 8c f3 ff ff       	jmp    80105bc7 <alltraps>

8010683b <vector191>:
.globl vector191
vector191:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $191
8010683d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106842:	e9 80 f3 ff ff       	jmp    80105bc7 <alltraps>

80106847 <vector192>:
.globl vector192
vector192:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $192
80106849:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010684e:	e9 74 f3 ff ff       	jmp    80105bc7 <alltraps>

80106853 <vector193>:
.globl vector193
vector193:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $193
80106855:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010685a:	e9 68 f3 ff ff       	jmp    80105bc7 <alltraps>

8010685f <vector194>:
.globl vector194
vector194:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $194
80106861:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106866:	e9 5c f3 ff ff       	jmp    80105bc7 <alltraps>

8010686b <vector195>:
.globl vector195
vector195:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $195
8010686d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106872:	e9 50 f3 ff ff       	jmp    80105bc7 <alltraps>

80106877 <vector196>:
.globl vector196
vector196:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $196
80106879:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010687e:	e9 44 f3 ff ff       	jmp    80105bc7 <alltraps>

80106883 <vector197>:
.globl vector197
vector197:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $197
80106885:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010688a:	e9 38 f3 ff ff       	jmp    80105bc7 <alltraps>

8010688f <vector198>:
.globl vector198
vector198:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $198
80106891:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106896:	e9 2c f3 ff ff       	jmp    80105bc7 <alltraps>

8010689b <vector199>:
.globl vector199
vector199:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $199
8010689d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068a2:	e9 20 f3 ff ff       	jmp    80105bc7 <alltraps>

801068a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $200
801068a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068ae:	e9 14 f3 ff ff       	jmp    80105bc7 <alltraps>

801068b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $201
801068b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068ba:	e9 08 f3 ff ff       	jmp    80105bc7 <alltraps>

801068bf <vector202>:
.globl vector202
vector202:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $202
801068c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068c6:	e9 fc f2 ff ff       	jmp    80105bc7 <alltraps>

801068cb <vector203>:
.globl vector203
vector203:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $203
801068cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068d2:	e9 f0 f2 ff ff       	jmp    80105bc7 <alltraps>

801068d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $204
801068d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068de:	e9 e4 f2 ff ff       	jmp    80105bc7 <alltraps>

801068e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $205
801068e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068ea:	e9 d8 f2 ff ff       	jmp    80105bc7 <alltraps>

801068ef <vector206>:
.globl vector206
vector206:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $206
801068f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801068f6:	e9 cc f2 ff ff       	jmp    80105bc7 <alltraps>

801068fb <vector207>:
.globl vector207
vector207:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $207
801068fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106902:	e9 c0 f2 ff ff       	jmp    80105bc7 <alltraps>

80106907 <vector208>:
.globl vector208
vector208:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $208
80106909:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010690e:	e9 b4 f2 ff ff       	jmp    80105bc7 <alltraps>

80106913 <vector209>:
.globl vector209
vector209:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $209
80106915:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010691a:	e9 a8 f2 ff ff       	jmp    80105bc7 <alltraps>

8010691f <vector210>:
.globl vector210
vector210:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $210
80106921:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106926:	e9 9c f2 ff ff       	jmp    80105bc7 <alltraps>

8010692b <vector211>:
.globl vector211
vector211:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $211
8010692d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106932:	e9 90 f2 ff ff       	jmp    80105bc7 <alltraps>

80106937 <vector212>:
.globl vector212
vector212:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $212
80106939:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010693e:	e9 84 f2 ff ff       	jmp    80105bc7 <alltraps>

80106943 <vector213>:
.globl vector213
vector213:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $213
80106945:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010694a:	e9 78 f2 ff ff       	jmp    80105bc7 <alltraps>

8010694f <vector214>:
.globl vector214
vector214:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $214
80106951:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106956:	e9 6c f2 ff ff       	jmp    80105bc7 <alltraps>

8010695b <vector215>:
.globl vector215
vector215:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $215
8010695d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106962:	e9 60 f2 ff ff       	jmp    80105bc7 <alltraps>

80106967 <vector216>:
.globl vector216
vector216:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $216
80106969:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010696e:	e9 54 f2 ff ff       	jmp    80105bc7 <alltraps>

80106973 <vector217>:
.globl vector217
vector217:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $217
80106975:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010697a:	e9 48 f2 ff ff       	jmp    80105bc7 <alltraps>

8010697f <vector218>:
.globl vector218
vector218:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $218
80106981:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106986:	e9 3c f2 ff ff       	jmp    80105bc7 <alltraps>

8010698b <vector219>:
.globl vector219
vector219:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $219
8010698d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106992:	e9 30 f2 ff ff       	jmp    80105bc7 <alltraps>

80106997 <vector220>:
.globl vector220
vector220:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $220
80106999:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010699e:	e9 24 f2 ff ff       	jmp    80105bc7 <alltraps>

801069a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $221
801069a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069aa:	e9 18 f2 ff ff       	jmp    80105bc7 <alltraps>

801069af <vector222>:
.globl vector222
vector222:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $222
801069b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069b6:	e9 0c f2 ff ff       	jmp    80105bc7 <alltraps>

801069bb <vector223>:
.globl vector223
vector223:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $223
801069bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069c2:	e9 00 f2 ff ff       	jmp    80105bc7 <alltraps>

801069c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $224
801069c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069ce:	e9 f4 f1 ff ff       	jmp    80105bc7 <alltraps>

801069d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $225
801069d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069da:	e9 e8 f1 ff ff       	jmp    80105bc7 <alltraps>

801069df <vector226>:
.globl vector226
vector226:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $226
801069e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069e6:	e9 dc f1 ff ff       	jmp    80105bc7 <alltraps>

801069eb <vector227>:
.globl vector227
vector227:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $227
801069ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801069f2:	e9 d0 f1 ff ff       	jmp    80105bc7 <alltraps>

801069f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $228
801069f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801069fe:	e9 c4 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $229
80106a05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a0a:	e9 b8 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $230
80106a11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a16:	e9 ac f1 ff ff       	jmp    80105bc7 <alltraps>

80106a1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $231
80106a1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a22:	e9 a0 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $232
80106a29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a2e:	e9 94 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $233
80106a35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a3a:	e9 88 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $234
80106a41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a46:	e9 7c f1 ff ff       	jmp    80105bc7 <alltraps>

80106a4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $235
80106a4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a52:	e9 70 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $236
80106a59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a5e:	e9 64 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $237
80106a65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a6a:	e9 58 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $238
80106a71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a76:	e9 4c f1 ff ff       	jmp    80105bc7 <alltraps>

80106a7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $239
80106a7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a82:	e9 40 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $240
80106a89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a8e:	e9 34 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $241
80106a95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106a9a:	e9 28 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $242
80106aa1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106aa6:	e9 1c f1 ff ff       	jmp    80105bc7 <alltraps>

80106aab <vector243>:
.globl vector243
vector243:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $243
80106aad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ab2:	e9 10 f1 ff ff       	jmp    80105bc7 <alltraps>

80106ab7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $244
80106ab9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106abe:	e9 04 f1 ff ff       	jmp    80105bc7 <alltraps>

80106ac3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $245
80106ac5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106aca:	e9 f8 f0 ff ff       	jmp    80105bc7 <alltraps>

80106acf <vector246>:
.globl vector246
vector246:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $246
80106ad1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ad6:	e9 ec f0 ff ff       	jmp    80105bc7 <alltraps>

80106adb <vector247>:
.globl vector247
vector247:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $247
80106add:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ae2:	e9 e0 f0 ff ff       	jmp    80105bc7 <alltraps>

80106ae7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $248
80106ae9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106aee:	e9 d4 f0 ff ff       	jmp    80105bc7 <alltraps>

80106af3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $249
80106af5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106afa:	e9 c8 f0 ff ff       	jmp    80105bc7 <alltraps>

80106aff <vector250>:
.globl vector250
vector250:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $250
80106b01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b06:	e9 bc f0 ff ff       	jmp    80105bc7 <alltraps>

80106b0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $251
80106b0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b12:	e9 b0 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $252
80106b19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b1e:	e9 a4 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $253
80106b25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b2a:	e9 98 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $254
80106b31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b36:	e9 8c f0 ff ff       	jmp    80105bc7 <alltraps>

80106b3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $255
80106b3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b42:	e9 80 f0 ff ff       	jmp    80105bc7 <alltraps>
80106b47:	66 90                	xchg   %ax,%ax
80106b49:	66 90                	xchg   %ax,%ax
80106b4b:	66 90                	xchg   %ax,%ax
80106b4d:	66 90                	xchg   %ax,%ax
80106b4f:	90                   	nop

80106b50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	57                   	push   %edi
80106b54:	56                   	push   %esi
80106b55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b5c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b62:	83 ec 1c             	sub    $0x1c,%esp
80106b65:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b68:	39 d3                	cmp    %edx,%ebx
80106b6a:	73 45                	jae    80106bb1 <deallocuvm.part.0+0x61>
80106b6c:	89 c7                	mov    %eax,%edi
80106b6e:	eb 0a                	jmp    80106b7a <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b70:	8d 59 01             	lea    0x1(%ecx),%ebx
80106b73:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b76:	39 da                	cmp    %ebx,%edx
80106b78:	76 37                	jbe    80106bb1 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
80106b7a:	89 d9                	mov    %ebx,%ecx
80106b7c:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106b7f:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80106b82:	a8 01                	test   $0x1,%al
80106b84:	74 ea                	je     80106b70 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106b86:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b88:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b8d:	c1 ee 0a             	shr    $0xa,%esi
80106b90:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106b96:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
80106b9d:	85 f6                	test   %esi,%esi
80106b9f:	74 cf                	je     80106b70 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106ba1:	8b 06                	mov    (%esi),%eax
80106ba3:	a8 01                	test   $0x1,%al
80106ba5:	75 19                	jne    80106bc0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106ba7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bad:	39 da                	cmp    %ebx,%edx
80106baf:	77 c9                	ja     80106b7a <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb7:	5b                   	pop    %ebx
80106bb8:	5e                   	pop    %esi
80106bb9:	5f                   	pop    %edi
80106bba:	5d                   	pop    %ebp
80106bbb:	c3                   	ret    
80106bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106bc0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bc5:	74 25                	je     80106bec <deallocuvm.part.0+0x9c>
      kfree(v);
80106bc7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bca:	05 00 00 00 80       	add    $0x80000000,%eax
80106bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bd2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106bd8:	50                   	push   %eax
80106bd9:	e8 12 ba ff ff       	call   801025f0 <kfree>
      *pte = 0;
80106bde:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106be4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106be7:	83 c4 10             	add    $0x10,%esp
80106bea:	eb 8a                	jmp    80106b76 <deallocuvm.part.0+0x26>
        panic("kfree");
80106bec:	83 ec 0c             	sub    $0xc,%esp
80106bef:	68 a6 77 10 80       	push   $0x801077a6
80106bf4:	e8 87 97 ff ff       	call   80100380 <panic>
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c00 <mappages>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c06:	89 d3                	mov    %edx,%ebx
80106c08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c0e:	83 ec 1c             	sub    $0x1c,%esp
80106c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
80106c23:	29 d8                	sub    %ebx,%eax
80106c25:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c28:	eb 3d                	jmp    80106c67 <mappages+0x67>
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c30:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c37:	c1 ea 0a             	shr    $0xa,%edx
80106c3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c40:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c47:	85 d2                	test   %edx,%edx
80106c49:	74 75                	je     80106cc0 <mappages+0xc0>
    if(*pte & PTE_P)
80106c4b:	f6 02 01             	testb  $0x1,(%edx)
80106c4e:	0f 85 86 00 00 00    	jne    80106cda <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c54:	0b 75 0c             	or     0xc(%ebp),%esi
80106c57:	83 ce 01             	or     $0x1,%esi
80106c5a:	89 32                	mov    %esi,(%edx)
    if(a == last)
80106c5c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106c5f:	74 6f                	je     80106cd0 <mappages+0xd0>
    a += PGSIZE;
80106c61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106c6a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c6d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106c70:	89 d8                	mov    %ebx,%eax
80106c72:	c1 e8 16             	shr    $0x16,%eax
80106c75:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106c78:	8b 07                	mov    (%edi),%eax
80106c7a:	a8 01                	test   $0x1,%al
80106c7c:	75 b2                	jne    80106c30 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c7e:	e8 2d bb ff ff       	call   801027b0 <kalloc>
80106c83:	85 c0                	test   %eax,%eax
80106c85:	74 39                	je     80106cc0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106c87:	83 ec 04             	sub    $0x4,%esp
80106c8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106c8d:	68 00 10 00 00       	push   $0x1000
80106c92:	6a 00                	push   $0x0
80106c94:	50                   	push   %eax
80106c95:	e8 46 dc ff ff       	call   801048e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c9a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106c9d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ca0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ca6:	83 c8 07             	or     $0x7,%eax
80106ca9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106cab:	89 d8                	mov    %ebx,%eax
80106cad:	c1 e8 0a             	shr    $0xa,%eax
80106cb0:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cb5:	01 c2                	add    %eax,%edx
80106cb7:	eb 92                	jmp    80106c4b <mappages+0x4b>
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc8:	5b                   	pop    %ebx
80106cc9:	5e                   	pop    %esi
80106cca:	5f                   	pop    %edi
80106ccb:	5d                   	pop    %ebp
80106ccc:	c3                   	ret    
80106ccd:	8d 76 00             	lea    0x0(%esi),%esi
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
      panic("remap");
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	68 3c 7e 10 80       	push   $0x80107e3c
80106ce2:	e8 99 96 ff ff       	call   80100380 <panic>
80106ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cee:	66 90                	xchg   %ax,%ax

80106cf0 <seginit>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106cf6:	e8 95 cd ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
80106cfb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d00:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d06:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d0a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106d11:	ff 00 00 
80106d14:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106d1b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d1e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106d25:	ff 00 00 
80106d28:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106d2f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d32:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106d39:	ff 00 00 
80106d3c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106d43:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d46:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106d4d:	ff 00 00 
80106d50:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106d57:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d5a:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106d5f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d63:	c1 e8 10             	shr    $0x10,%eax
80106d66:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106d6a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d6d:	0f 01 10             	lgdtl  (%eax)
}
80106d70:	c9                   	leave  
80106d71:	c3                   	ret    
80106d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d80 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d80:	a1 e4 45 11 80       	mov    0x801145e4,%eax
80106d85:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d8a:	0f 22 d8             	mov    %eax,%cr3
}
80106d8d:	c3                   	ret    
80106d8e:	66 90                	xchg   %ax,%ax

80106d90 <switchuvm>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
80106d99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d9c:	85 f6                	test   %esi,%esi
80106d9e:	0f 84 cb 00 00 00    	je     80106e6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106da4:	8b 46 08             	mov    0x8(%esi),%eax
80106da7:	85 c0                	test   %eax,%eax
80106da9:	0f 84 da 00 00 00    	je     80106e89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106daf:	8b 46 04             	mov    0x4(%esi),%eax
80106db2:	85 c0                	test   %eax,%eax
80106db4:	0f 84 c2 00 00 00    	je     80106e7c <switchuvm+0xec>
  pushcli();
80106dba:	e8 61 d9 ff ff       	call   80104720 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dbf:	e8 5c cc ff ff       	call   80103a20 <mycpu>
80106dc4:	89 c3                	mov    %eax,%ebx
80106dc6:	e8 55 cc ff ff       	call   80103a20 <mycpu>
80106dcb:	89 c7                	mov    %eax,%edi
80106dcd:	e8 4e cc ff ff       	call   80103a20 <mycpu>
80106dd2:	83 c7 08             	add    $0x8,%edi
80106dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106dd8:	e8 43 cc ff ff       	call   80103a20 <mycpu>
80106ddd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106de0:	ba 67 00 00 00       	mov    $0x67,%edx
80106de5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106dec:	83 c0 08             	add    $0x8,%eax
80106def:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106df6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dfb:	83 c1 08             	add    $0x8,%ecx
80106dfe:	c1 e8 18             	shr    $0x18,%eax
80106e01:	c1 e9 10             	shr    $0x10,%ecx
80106e04:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e0a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e15:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e21:	e8 fa cb ff ff       	call   80103a20 <mycpu>
80106e26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e2d:	e8 ee cb ff ff       	call   80103a20 <mycpu>
80106e32:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e36:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e39:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e3f:	e8 dc cb ff ff       	call   80103a20 <mycpu>
80106e44:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e47:	e8 d4 cb ff ff       	call   80103a20 <mycpu>
80106e4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e50:	b8 28 00 00 00       	mov    $0x28,%eax
80106e55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e58:	8b 46 04             	mov    0x4(%esi),%eax
80106e5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e60:	0f 22 d8             	mov    %eax,%cr3
}
80106e63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e66:	5b                   	pop    %ebx
80106e67:	5e                   	pop    %esi
80106e68:	5f                   	pop    %edi
80106e69:	5d                   	pop    %ebp
  popcli();
80106e6a:	e9 c1 d9 ff ff       	jmp    80104830 <popcli>
    panic("switchuvm: no process");
80106e6f:	83 ec 0c             	sub    $0xc,%esp
80106e72:	68 42 7e 10 80       	push   $0x80107e42
80106e77:	e8 04 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106e7c:	83 ec 0c             	sub    $0xc,%esp
80106e7f:	68 6d 7e 10 80       	push   $0x80107e6d
80106e84:	e8 f7 94 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106e89:	83 ec 0c             	sub    $0xc,%esp
80106e8c:	68 58 7e 10 80       	push   $0x80107e58
80106e91:	e8 ea 94 ff ff       	call   80100380 <panic>
80106e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ea0 <inituvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	8b 75 10             	mov    0x10(%ebp),%esi
80106eaf:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106eb5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ebb:	77 4b                	ja     80106f08 <inituvm+0x68>
  mem = kalloc();
80106ebd:	e8 ee b8 ff ff       	call   801027b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106ec2:	83 ec 04             	sub    $0x4,%esp
80106ec5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106eca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ecc:	6a 00                	push   $0x0
80106ece:	50                   	push   %eax
80106ecf:	e8 0c da ff ff       	call   801048e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ed4:	58                   	pop    %eax
80106ed5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106edb:	5a                   	pop    %edx
80106edc:	6a 06                	push   $0x6
80106ede:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ee3:	31 d2                	xor    %edx,%edx
80106ee5:	50                   	push   %eax
80106ee6:	89 f8                	mov    %edi,%eax
80106ee8:	e8 13 fd ff ff       	call   80106c00 <mappages>
  memmove(mem, init, sz);
80106eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ef0:	89 75 10             	mov    %esi,0x10(%ebp)
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ef9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eff:	5b                   	pop    %ebx
80106f00:	5e                   	pop    %esi
80106f01:	5f                   	pop    %edi
80106f02:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f03:	e9 78 da ff ff       	jmp    80104980 <memmove>
    panic("inituvm: more than a page");
80106f08:	83 ec 0c             	sub    $0xc,%esp
80106f0b:	68 81 7e 10 80       	push   $0x80107e81
80106f10:	e8 6b 94 ff ff       	call   80100380 <panic>
80106f15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <loaduvm>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	57                   	push   %edi
80106f24:	56                   	push   %esi
80106f25:	53                   	push   %ebx
80106f26:	83 ec 1c             	sub    $0x1c,%esp
80106f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f2c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106f2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106f34:	0f 85 bb 00 00 00    	jne    80106ff5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106f3a:	01 f0                	add    %esi,%eax
80106f3c:	89 f3                	mov    %esi,%ebx
80106f3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f41:	8b 45 14             	mov    0x14(%ebp),%eax
80106f44:	01 f0                	add    %esi,%eax
80106f46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106f49:	85 f6                	test   %esi,%esi
80106f4b:	0f 84 87 00 00 00    	je     80106fd8 <loaduvm+0xb8>
80106f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106f5e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106f60:	89 c2                	mov    %eax,%edx
80106f62:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106f65:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106f68:	f6 c2 01             	test   $0x1,%dl
80106f6b:	75 13                	jne    80106f80 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106f6d:	83 ec 0c             	sub    $0xc,%esp
80106f70:	68 9b 7e 10 80       	push   $0x80107e9b
80106f75:	e8 06 94 ff ff       	call   80100380 <panic>
80106f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106f80:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106f89:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f8e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f95:	85 c0                	test   %eax,%eax
80106f97:	74 d4                	je     80106f6d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106f99:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f9b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106f9e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fa8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106fae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fb1:	29 d9                	sub    %ebx,%ecx
80106fb3:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb8:	57                   	push   %edi
80106fb9:	51                   	push   %ecx
80106fba:	50                   	push   %eax
80106fbb:	ff 75 10             	pushl  0x10(%ebp)
80106fbe:	e8 fd ab ff ff       	call   80101bc0 <readi>
80106fc3:	83 c4 10             	add    $0x10,%esp
80106fc6:	39 f8                	cmp    %edi,%eax
80106fc8:	75 1e                	jne    80106fe8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106fca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106fd0:	89 f0                	mov    %esi,%eax
80106fd2:	29 d8                	sub    %ebx,%eax
80106fd4:	39 c6                	cmp    %eax,%esi
80106fd6:	77 80                	ja     80106f58 <loaduvm+0x38>
}
80106fd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fdb:	31 c0                	xor    %eax,%eax
}
80106fdd:	5b                   	pop    %ebx
80106fde:	5e                   	pop    %esi
80106fdf:	5f                   	pop    %edi
80106fe0:	5d                   	pop    %ebp
80106fe1:	c3                   	ret    
80106fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106feb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff0:	5b                   	pop    %ebx
80106ff1:	5e                   	pop    %esi
80106ff2:	5f                   	pop    %edi
80106ff3:	5d                   	pop    %ebp
80106ff4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106ff5:	83 ec 0c             	sub    $0xc,%esp
80106ff8:	68 3c 7f 10 80       	push   $0x80107f3c
80106ffd:	e8 7e 93 ff ff       	call   80100380 <panic>
80107002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107010 <allocuvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107019:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010701c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010701f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107022:	85 c0                	test   %eax,%eax
80107024:	0f 88 b6 00 00 00    	js     801070e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010702a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010702d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107030:	0f 82 9a 00 00 00    	jb     801070d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107036:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010703c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107042:	39 75 10             	cmp    %esi,0x10(%ebp)
80107045:	77 44                	ja     8010708b <allocuvm+0x7b>
80107047:	e9 87 00 00 00       	jmp    801070d3 <allocuvm+0xc3>
8010704c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107050:	83 ec 04             	sub    $0x4,%esp
80107053:	68 00 10 00 00       	push   $0x1000
80107058:	6a 00                	push   $0x0
8010705a:	50                   	push   %eax
8010705b:	e8 80 d8 ff ff       	call   801048e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107060:	58                   	pop    %eax
80107061:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107067:	5a                   	pop    %edx
80107068:	6a 06                	push   $0x6
8010706a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010706f:	89 f2                	mov    %esi,%edx
80107071:	50                   	push   %eax
80107072:	89 f8                	mov    %edi,%eax
80107074:	e8 87 fb ff ff       	call   80106c00 <mappages>
80107079:	83 c4 10             	add    $0x10,%esp
8010707c:	85 c0                	test   %eax,%eax
8010707e:	78 78                	js     801070f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107080:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107086:	39 75 10             	cmp    %esi,0x10(%ebp)
80107089:	76 48                	jbe    801070d3 <allocuvm+0xc3>
    mem = kalloc();
8010708b:	e8 20 b7 ff ff       	call   801027b0 <kalloc>
80107090:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107092:	85 c0                	test   %eax,%eax
80107094:	75 ba                	jne    80107050 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107096:	83 ec 0c             	sub    $0xc,%esp
80107099:	68 b9 7e 10 80       	push   $0x80107eb9
8010709e:	e8 dd 95 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
801070a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801070a6:	83 c4 10             	add    $0x10,%esp
801070a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801070ac:	74 32                	je     801070e0 <allocuvm+0xd0>
801070ae:	8b 55 10             	mov    0x10(%ebp),%edx
801070b1:	89 c1                	mov    %eax,%ecx
801070b3:	89 f8                	mov    %edi,%eax
801070b5:	e8 96 fa ff ff       	call   80106b50 <deallocuvm.part.0>
      return 0;
801070ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c7:	5b                   	pop    %ebx
801070c8:	5e                   	pop    %esi
801070c9:	5f                   	pop    %edi
801070ca:	5d                   	pop    %ebp
801070cb:	c3                   	ret    
801070cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801070d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d9:	5b                   	pop    %ebx
801070da:	5e                   	pop    %esi
801070db:	5f                   	pop    %edi
801070dc:	5d                   	pop    %ebp
801070dd:	c3                   	ret    
801070de:	66 90                	xchg   %ax,%ax
    return 0;
801070e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801070e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ed:	5b                   	pop    %ebx
801070ee:	5e                   	pop    %esi
801070ef:	5f                   	pop    %edi
801070f0:	5d                   	pop    %ebp
801070f1:	c3                   	ret    
801070f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070f8:	83 ec 0c             	sub    $0xc,%esp
801070fb:	68 d1 7e 10 80       	push   $0x80107ed1
80107100:	e8 7b 95 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80107105:	8b 45 0c             	mov    0xc(%ebp),%eax
80107108:	83 c4 10             	add    $0x10,%esp
8010710b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010710e:	74 0c                	je     8010711c <allocuvm+0x10c>
80107110:	8b 55 10             	mov    0x10(%ebp),%edx
80107113:	89 c1                	mov    %eax,%ecx
80107115:	89 f8                	mov    %edi,%eax
80107117:	e8 34 fa ff ff       	call   80106b50 <deallocuvm.part.0>
      kfree(mem);
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	53                   	push   %ebx
80107120:	e8 cb b4 ff ff       	call   801025f0 <kfree>
      return 0;
80107125:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010712c:	83 c4 10             	add    $0x10,%esp
}
8010712f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107132:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107135:	5b                   	pop    %ebx
80107136:	5e                   	pop    %esi
80107137:	5f                   	pop    %edi
80107138:	5d                   	pop    %ebp
80107139:	c3                   	ret    
8010713a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107140 <deallocuvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	8b 55 0c             	mov    0xc(%ebp),%edx
80107146:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107149:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010714c:	39 d1                	cmp    %edx,%ecx
8010714e:	73 10                	jae    80107160 <deallocuvm+0x20>
}
80107150:	5d                   	pop    %ebp
80107151:	e9 fa f9 ff ff       	jmp    80106b50 <deallocuvm.part.0>
80107156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	89 d0                	mov    %edx,%eax
80107162:	5d                   	pop    %ebp
80107163:	c3                   	ret    
80107164:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010716f:	90                   	nop

80107170 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 0c             	sub    $0xc,%esp
80107179:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010717c:	85 f6                	test   %esi,%esi
8010717e:	74 59                	je     801071d9 <freevm+0x69>
  if(newsz >= oldsz)
80107180:	31 c9                	xor    %ecx,%ecx
80107182:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107187:	89 f0                	mov    %esi,%eax
80107189:	89 f3                	mov    %esi,%ebx
8010718b:	e8 c0 f9 ff ff       	call   80106b50 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107190:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107196:	eb 0f                	jmp    801071a7 <freevm+0x37>
80107198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
801071a0:	83 c3 04             	add    $0x4,%ebx
801071a3:	39 df                	cmp    %ebx,%edi
801071a5:	74 23                	je     801071ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071a7:	8b 03                	mov    (%ebx),%eax
801071a9:	a8 01                	test   $0x1,%al
801071ab:	74 f3                	je     801071a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071b2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071bd:	50                   	push   %eax
801071be:	e8 2d b4 ff ff       	call   801025f0 <kfree>
801071c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071c6:	39 df                	cmp    %ebx,%edi
801071c8:	75 dd                	jne    801071a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071d0:	5b                   	pop    %ebx
801071d1:	5e                   	pop    %esi
801071d2:	5f                   	pop    %edi
801071d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071d4:	e9 17 b4 ff ff       	jmp    801025f0 <kfree>
    panic("freevm: no pgdir");
801071d9:	83 ec 0c             	sub    $0xc,%esp
801071dc:	68 ed 7e 10 80       	push   $0x80107eed
801071e1:	e8 9a 91 ff ff       	call   80100380 <panic>
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi

801071f0 <setupkvm>:
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	56                   	push   %esi
801071f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801071f5:	e8 b6 b5 ff ff       	call   801027b0 <kalloc>
801071fa:	89 c6                	mov    %eax,%esi
801071fc:	85 c0                	test   %eax,%eax
801071fe:	74 42                	je     80107242 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107203:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107208:	68 00 10 00 00       	push   $0x1000
8010720d:	6a 00                	push   $0x0
8010720f:	50                   	push   %eax
80107210:	e8 cb d6 ff ff       	call   801048e0 <memset>
80107215:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107218:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010721b:	83 ec 08             	sub    $0x8,%esp
8010721e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107221:	ff 73 0c             	pushl  0xc(%ebx)
80107224:	8b 13                	mov    (%ebx),%edx
80107226:	50                   	push   %eax
80107227:	29 c1                	sub    %eax,%ecx
80107229:	89 f0                	mov    %esi,%eax
8010722b:	e8 d0 f9 ff ff       	call   80106c00 <mappages>
80107230:	83 c4 10             	add    $0x10,%esp
80107233:	85 c0                	test   %eax,%eax
80107235:	78 19                	js     80107250 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107237:	83 c3 10             	add    $0x10,%ebx
8010723a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107240:	75 d6                	jne    80107218 <setupkvm+0x28>
}
80107242:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107245:	89 f0                	mov    %esi,%eax
80107247:	5b                   	pop    %ebx
80107248:	5e                   	pop    %esi
80107249:	5d                   	pop    %ebp
8010724a:	c3                   	ret    
8010724b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010724f:	90                   	nop
      freevm(pgdir);
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	56                   	push   %esi
      return 0;
80107254:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107256:	e8 15 ff ff ff       	call   80107170 <freevm>
      return 0;
8010725b:	83 c4 10             	add    $0x10,%esp
}
8010725e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107261:	89 f0                	mov    %esi,%eax
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5d                   	pop    %ebp
80107266:	c3                   	ret    
80107267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726e:	66 90                	xchg   %ax,%ax

80107270 <kvmalloc>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107276:	e8 75 ff ff ff       	call   801071f0 <setupkvm>
8010727b:	a3 e4 45 11 80       	mov    %eax,0x801145e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107280:	05 00 00 00 80       	add    $0x80000000,%eax
80107285:	0f 22 d8             	mov    %eax,%cr3
}
80107288:	c9                   	leave  
80107289:	c3                   	ret    
8010728a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107290 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 08             	sub    $0x8,%esp
80107296:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107299:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010729c:	89 c1                	mov    %eax,%ecx
8010729e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072a1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072a4:	f6 c2 01             	test   $0x1,%dl
801072a7:	75 17                	jne    801072c0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072a9:	83 ec 0c             	sub    $0xc,%esp
801072ac:	68 fe 7e 10 80       	push   $0x80107efe
801072b1:	e8 ca 90 ff ff       	call   80100380 <panic>
801072b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801072c0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072c3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072c9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072ce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072d5:	85 c0                	test   %eax,%eax
801072d7:	74 d0                	je     801072a9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801072d9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072dc:	c9                   	leave  
801072dd:	c3                   	ret    
801072de:	66 90                	xchg   %ax,%ax

801072e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072e9:	e8 02 ff ff ff       	call   801071f0 <setupkvm>
801072ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072f1:	85 c0                	test   %eax,%eax
801072f3:	0f 84 be 00 00 00    	je     801073b7 <copyuvm+0xd7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072fc:	85 c9                	test   %ecx,%ecx
801072fe:	0f 84 b3 00 00 00    	je     801073b7 <copyuvm+0xd7>
80107304:	31 f6                	xor    %esi,%esi
80107306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107310:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107313:	89 f0                	mov    %esi,%eax
80107315:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107318:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010731b:	a8 01                	test   $0x1,%al
8010731d:	75 11                	jne    80107330 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010731f:	83 ec 0c             	sub    $0xc,%esp
80107322:	68 08 7f 10 80       	push   $0x80107f08
80107327:	e8 54 90 ff ff       	call   80100380 <panic>
8010732c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107330:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107332:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107337:	c1 ea 0a             	shr    $0xa,%edx
8010733a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107340:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107347:	85 c0                	test   %eax,%eax
80107349:	74 d4                	je     8010731f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010734b:	8b 18                	mov    (%eax),%ebx
8010734d:	f6 c3 01             	test   $0x1,%bl
80107350:	0f 84 92 00 00 00    	je     801073e8 <copyuvm+0x108>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107356:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107358:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
8010735e:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107364:	e8 47 b4 ff ff       	call   801027b0 <kalloc>
80107369:	85 c0                	test   %eax,%eax
8010736b:	74 5b                	je     801073c8 <copyuvm+0xe8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010736d:	83 ec 04             	sub    $0x4,%esp
80107370:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107379:	68 00 10 00 00       	push   $0x1000
8010737e:	57                   	push   %edi
8010737f:	50                   	push   %eax
80107380:	e8 fb d5 ff ff       	call   80104980 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107385:	58                   	pop    %eax
80107386:	5a                   	pop    %edx
80107387:	53                   	push   %ebx
80107388:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010738b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010738e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107393:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107399:	52                   	push   %edx
8010739a:	89 f2                	mov    %esi,%edx
8010739c:	e8 5f f8 ff ff       	call   80106c00 <mappages>
801073a1:	83 c4 10             	add    $0x10,%esp
801073a4:	85 c0                	test   %eax,%eax
801073a6:	78 20                	js     801073c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801073a8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073ae:	39 75 0c             	cmp    %esi,0xc(%ebp)
801073b1:	0f 87 59 ff ff ff    	ja     80107310 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801073b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073bd:	5b                   	pop    %ebx
801073be:	5e                   	pop    %esi
801073bf:	5f                   	pop    %edi
801073c0:	5d                   	pop    %ebp
801073c1:	c3                   	ret    
801073c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(d);
801073c8:	83 ec 0c             	sub    $0xc,%esp
801073cb:	ff 75 e0             	pushl  -0x20(%ebp)
801073ce:	e8 9d fd ff ff       	call   80107170 <freevm>
  return 0;
801073d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801073da:	83 c4 10             	add    $0x10,%esp
}
801073dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e3:	5b                   	pop    %ebx
801073e4:	5e                   	pop    %esi
801073e5:	5f                   	pop    %edi
801073e6:	5d                   	pop    %ebp
801073e7:	c3                   	ret    
      panic("copyuvm: page not present");
801073e8:	83 ec 0c             	sub    $0xc,%esp
801073eb:	68 22 7f 10 80       	push   $0x80107f22
801073f0:	e8 8b 8f ff ff       	call   80100380 <panic>
801073f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107400 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107406:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107409:	89 c1                	mov    %eax,%ecx
8010740b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010740e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107411:	f6 c2 01             	test   $0x1,%dl
80107414:	0f 84 00 01 00 00    	je     8010751a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010741a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010741d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107423:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107424:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107429:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107430:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107432:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107437:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010743a:	05 00 00 00 80       	add    $0x80000000,%eax
8010743f:	83 fa 05             	cmp    $0x5,%edx
80107442:	ba 00 00 00 00       	mov    $0x0,%edx
80107447:	0f 45 c2             	cmovne %edx,%eax
}
8010744a:	c3                   	ret    
8010744b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010744f:	90                   	nop

80107450 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	8b 75 14             	mov    0x14(%ebp),%esi
8010745c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010745f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107462:	85 f6                	test   %esi,%esi
80107464:	75 51                	jne    801074b7 <copyout+0x67>
80107466:	e9 a5 00 00 00       	jmp    80107510 <copyout+0xc0>
8010746b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010746f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107470:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107476:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010747c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107482:	74 75                	je     801074f9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107484:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107486:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107489:	29 c3                	sub    %eax,%ebx
8010748b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107491:	39 f3                	cmp    %esi,%ebx
80107493:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107496:	29 f8                	sub    %edi,%eax
80107498:	83 ec 04             	sub    $0x4,%esp
8010749b:	01 c8                	add    %ecx,%eax
8010749d:	53                   	push   %ebx
8010749e:	52                   	push   %edx
8010749f:	50                   	push   %eax
801074a0:	e8 db d4 ff ff       	call   80104980 <memmove>
    len -= n;
    buf += n;
801074a5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074a8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801074ae:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074b1:	01 da                	add    %ebx,%edx
  while(len > 0){
801074b3:	29 de                	sub    %ebx,%esi
801074b5:	74 59                	je     80107510 <copyout+0xc0>
  if(*pde & PTE_P){
801074b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074ba:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074bc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801074be:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801074c1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074c7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801074ca:	f6 c1 01             	test   $0x1,%cl
801074cd:	0f 84 4e 00 00 00    	je     80107521 <copyout.cold>
  return &pgtab[PTX(va)];
801074d3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801074db:	c1 eb 0c             	shr    $0xc,%ebx
801074de:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801074e4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801074eb:	89 d9                	mov    %ebx,%ecx
801074ed:	83 e1 05             	and    $0x5,%ecx
801074f0:	83 f9 05             	cmp    $0x5,%ecx
801074f3:	0f 84 77 ff ff ff    	je     80107470 <copyout+0x20>
  }
  return 0;
}
801074f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107501:	5b                   	pop    %ebx
80107502:	5e                   	pop    %esi
80107503:	5f                   	pop    %edi
80107504:	5d                   	pop    %ebp
80107505:	c3                   	ret    
80107506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010750d:	8d 76 00             	lea    0x0(%esi),%esi
80107510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107513:	31 c0                	xor    %eax,%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    

8010751a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010751a:	a1 00 00 00 00       	mov    0x0,%eax
8010751f:	0f 0b                	ud2    

80107521 <copyout.cold>:
80107521:	a1 00 00 00 00       	mov    0x0,%eax
80107526:	0f 0b                	ud2    
