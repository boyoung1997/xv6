
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
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
80100028:	bc 80 e6 10 80       	mov    $0x8010e680,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 18 3a 10 80       	mov    $0x80103a18,%eax
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
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 fc 9a 10 	movl   $0x80109afc,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100049:	e8 97 61 00 00       	call   801061e5 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 2d 11 80 7c 	movl   $0x80112d7c,0x80112dcc
80100055:	2d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 2d 11 80 7c 	movl   $0x80112d7c,0x80112dd0
8010005f:	2d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 2d 11 80    	mov    0x80112dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 2d 11 80 	movl   $0x80112d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 03 9b 10 	movl   $0x80109b03,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 11 60 00 00       	call   801060a8 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 2d 11 80       	mov    %eax,0x80112dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
801000c9:	e8 38 61 00 00       	call   80106206 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100104:	e8 64 61 00 00       	call   8010626d <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 cb 5f 00 00       	call   801060e2 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 2d 11 80       	mov    0x80112dcc,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
8010017d:	e8 eb 60 00 00       	call   8010626d <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 52 5f 00 00       	call   801060e2 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 0a 9b 10 80 	movl   $0x80109b0a,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 a5 28 00 00       	call   80102a8c <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 80 5f 00 00       	call   80106180 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 1b 9b 10 80 	movl   $0x80109b1b,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 62 28 00 00       	call   80102a8c <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 40 5f 00 00       	call   80106180 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 22 9b 10 80 	movl   $0x80109b22,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 e0 5e 00 00       	call   8010613e <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100265:	e8 9c 5f 00 00       	call   80106206 <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 d0 2d 11 80    	mov    0x80112dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 2d 11 80 	movl   $0x80112d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 2d 11 80       	mov    %eax,0x80112dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
801002d1:	e8 97 5f 00 00       	call   8010626d <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 dc 03 00 00       	call   80100793 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
    consputc(buf[i]);
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
801003e3:	e8 1e 5e 00 00       	call   80106206 <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 29 9b 10 80 	movl   $0x80109b29,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 75 03 00 00       	call   80100793 <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec 32 9b 10 80 	movl   $0x80109b32,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 9f 02 00 00       	call   80100793 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
        consputc(*s);
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 83 02 00 00       	call   80100793 <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 75 02 00 00       	call   80100793 <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 6a 02 00 00       	call   80100793 <consputc>
      break;
80100529:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010055b:	e8 0d 5d 00 00       	call   8010626d <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100574:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100577:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010057d:	0f b6 00             	movzbl (%eax),%eax
80100580:	0f b6 c0             	movzbl %al,%eax
80100583:	89 44 24 04          	mov    %eax,0x4(%esp)
80100587:	c7 04 24 39 9b 10 80 	movl   $0x80109b39,(%esp)
8010058e:	e8 35 fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
80100593:	8b 45 08             	mov    0x8(%ebp),%eax
80100596:	89 04 24             	mov    %eax,(%esp)
80100599:	e8 2a fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
8010059e:	c7 04 24 55 9b 10 80 	movl   $0x80109b55,(%esp)
801005a5:	e8 1e fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005aa:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b1:	8d 45 08             	lea    0x8(%ebp),%eax
801005b4:	89 04 24             	mov    %eax,(%esp)
801005b7:	e8 fe 5c 00 00       	call   801062ba <getcallerpcs>
  for(i=0; i<10; i++)
801005bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c3:	eb 1b                	jmp    801005e0 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c8:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801005d0:	c7 04 24 57 9b 10 80 	movl   $0x80109b57,(%esp)
801005d7:	e8 ec fd ff ff       	call   801003c8 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e4:	7e df                	jle    801005c5 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005e6:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
801005ed:	00 00 00 
  for(;;)
    ;
801005f0:	eb fe                	jmp    801005f0 <panic+0x8e>

801005f2 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f2:	55                   	push   %ebp
801005f3:	89 e5                	mov    %esp,%ebp
801005f5:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f8:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005ff:	00 
80100600:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100607:	e8 e9 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
8010060c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100613:	e8 c0 fc ff ff       	call   801002d8 <inb>
80100618:	0f b6 c0             	movzbl %al,%eax
8010061b:	c1 e0 08             	shl    $0x8,%eax
8010061e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100621:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100628:	00 
80100629:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100630:	e8 c0 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
80100635:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010063c:	e8 97 fc ff ff       	call   801002d8 <inb>
80100641:	0f b6 c0             	movzbl %al,%eax
80100644:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100647:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010064b:	75 30                	jne    8010067d <cgaputc+0x8b>
    pos += 80 - pos%80;
8010064d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100650:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	f7 ea                	imul   %edx
80100659:	c1 fa 05             	sar    $0x5,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	c1 f8 1f             	sar    $0x1f,%eax
80100661:	29 c2                	sub    %eax,%edx
80100663:	89 d0                	mov    %edx,%eax
80100665:	c1 e0 02             	shl    $0x2,%eax
80100668:	01 d0                	add    %edx,%eax
8010066a:	c1 e0 04             	shl    $0x4,%eax
8010066d:	29 c1                	sub    %eax,%ecx
8010066f:	89 ca                	mov    %ecx,%edx
80100671:	b8 50 00 00 00       	mov    $0x50,%eax
80100676:	29 d0                	sub    %edx,%eax
80100678:	01 45 f4             	add    %eax,-0xc(%ebp)
8010067b:	eb 35                	jmp    801006b2 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010067d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100684:	75 0c                	jne    80100692 <cgaputc+0xa0>
    if(pos > 0) --pos;
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	7e 26                	jle    801006b2 <cgaputc+0xc0>
8010068c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100690:	eb 20                	jmp    801006b2 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100692:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
80100698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010069b:	8d 50 01             	lea    0x1(%eax),%edx
8010069e:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a1:	01 c0                	add    %eax,%eax
801006a3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006a6:	8b 45 08             	mov    0x8(%ebp),%eax
801006a9:	0f b6 c0             	movzbl %al,%eax
801006ac:	80 cc 07             	or     $0x7,%ah
801006af:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006b6:	78 09                	js     801006c1 <cgaputc+0xcf>
801006b8:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006bf:	7e 0c                	jle    801006cd <cgaputc+0xdb>
    panic("pos under/overflow");
801006c1:	c7 04 24 5b 9b 10 80 	movl   $0x80109b5b,(%esp)
801006c8:	e8 95 fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006cd:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006d4:	7e 53                	jle    80100729 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006d6:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e1:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006ed:	00 
801006ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801006f2:	89 04 24             	mov    %eax,(%esp)
801006f5:	e8 44 5e 00 00       	call   8010653e <memmove>
    pos -= 80;
801006fa:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006fe:	b8 80 07 00 00       	mov    $0x780,%eax
80100703:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100706:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100709:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010070e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100711:	01 c9                	add    %ecx,%ecx
80100713:	01 c8                	add    %ecx,%eax
80100715:	89 54 24 08          	mov    %edx,0x8(%esp)
80100719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100720:	00 
80100721:	89 04 24             	mov    %eax,(%esp)
80100724:	e8 46 5d 00 00       	call   8010646f <memset>
  }

  outb(CRTPORT, 14);
80100729:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100730:	00 
80100731:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100738:	e8 b8 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
8010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100740:	c1 f8 08             	sar    $0x8,%eax
80100743:	0f b6 c0             	movzbl %al,%eax
80100746:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100751:	e8 9f fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
80100756:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010075d:	00 
8010075e:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100765:	e8 8b fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
8010076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076d:	0f b6 c0             	movzbl %al,%eax
80100770:	89 44 24 04          	mov    %eax,0x4(%esp)
80100774:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010077b:	e8 75 fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100780:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100788:	01 d2                	add    %edx,%edx
8010078a:	01 d0                	add    %edx,%eax
8010078c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100791:	c9                   	leave  
80100792:	c3                   	ret    

80100793 <consputc>:

void
consputc(int c)
{
80100793:	55                   	push   %ebp
80100794:	89 e5                	mov    %esp,%ebp
80100796:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100799:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
8010079e:	85 c0                	test   %eax,%eax
801007a0:	74 07                	je     801007a9 <consputc+0x16>
    cli();
801007a2:	e8 6c fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a7:	eb fe                	jmp    801007a7 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a9:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b0:	75 26                	jne    801007d8 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b9:	e8 1c 79 00 00       	call   801080da <uartputc>
801007be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007c5:	e8 10 79 00 00       	call   801080da <uartputc>
801007ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007d1:	e8 04 79 00 00       	call   801080da <uartputc>
801007d6:	eb 0b                	jmp    801007e3 <consputc+0x50>
  } else
    uartputc(c);
801007d8:	8b 45 08             	mov    0x8(%ebp),%eax
801007db:	89 04 24             	mov    %eax,(%esp)
801007de:	e8 f7 78 00 00       	call   801080da <uartputc>
  cgaputc(c);
801007e3:	8b 45 08             	mov    0x8(%ebp),%eax
801007e6:	89 04 24             	mov    %eax,(%esp)
801007e9:	e8 04 fe ff ff       	call   801005f2 <cgaputc>
}
801007ee:	c9                   	leave  
801007ef:	c3                   	ret    

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007fd:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100804:	e8 fd 59 00 00       	call   80106206 <acquire>
  while((c = getc()) >= 0){
80100809:	e9 39 01 00 00       	jmp    80100947 <consoleintr+0x157>
    switch(c){
8010080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100811:	83 f8 10             	cmp    $0x10,%eax
80100814:	74 1e                	je     80100834 <consoleintr+0x44>
80100816:	83 f8 10             	cmp    $0x10,%eax
80100819:	7f 0a                	jg     80100825 <consoleintr+0x35>
8010081b:	83 f8 08             	cmp    $0x8,%eax
8010081e:	74 66                	je     80100886 <consoleintr+0x96>
80100820:	e9 93 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
80100825:	83 f8 15             	cmp    $0x15,%eax
80100828:	74 31                	je     8010085b <consoleintr+0x6b>
8010082a:	83 f8 7f             	cmp    $0x7f,%eax
8010082d:	74 57                	je     80100886 <consoleintr+0x96>
8010082f:	e9 84 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100834:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010083b:	e9 07 01 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100840:	a1 68 30 11 80       	mov    0x80113068,%eax
80100845:	83 e8 01             	sub    $0x1,%eax
80100848:	a3 68 30 11 80       	mov    %eax,0x80113068
        consputc(BACKSPACE);
8010084d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100854:	e8 3a ff ff ff       	call   80100793 <consputc>
80100859:	eb 01                	jmp    8010085c <consoleintr+0x6c>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085b:	90                   	nop
8010085c:	8b 15 68 30 11 80    	mov    0x80113068,%edx
80100862:	a1 64 30 11 80       	mov    0x80113064,%eax
80100867:	39 c2                	cmp    %eax,%edx
80100869:	74 16                	je     80100881 <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010086b:	a1 68 30 11 80       	mov    0x80113068,%eax
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	83 e0 7f             	and    $0x7f,%eax
80100876:	0f b6 80 e0 2f 11 80 	movzbl -0x7feed020(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010087d:	3c 0a                	cmp    $0xa,%al
8010087f:	75 bf                	jne    80100840 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100881:	e9 c1 00 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100886:	8b 15 68 30 11 80    	mov    0x80113068,%edx
8010088c:	a1 64 30 11 80       	mov    0x80113064,%eax
80100891:	39 c2                	cmp    %eax,%edx
80100893:	74 1e                	je     801008b3 <consoleintr+0xc3>
        input.e--;
80100895:	a1 68 30 11 80       	mov    0x80113068,%eax
8010089a:	83 e8 01             	sub    $0x1,%eax
8010089d:	a3 68 30 11 80       	mov    %eax,0x80113068
        consputc(BACKSPACE);
801008a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a9:	e8 e5 fe ff ff       	call   80100793 <consputc>
      }
      break;
801008ae:	e9 94 00 00 00       	jmp    80100947 <consoleintr+0x157>
801008b3:	e9 8f 00 00 00       	jmp    80100947 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 84 00 00 00    	je     80100946 <consoleintr+0x156>
801008c2:	8b 15 68 30 11 80    	mov    0x80113068,%edx
801008c8:	a1 60 30 11 80       	mov    0x80113060,%eax
801008cd:	29 c2                	sub    %eax,%edx
801008cf:	89 d0                	mov    %edx,%eax
801008d1:	83 f8 7f             	cmp    $0x7f,%eax
801008d4:	77 70                	ja     80100946 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008da:	74 05                	je     801008e1 <consoleintr+0xf1>
801008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008df:	eb 05                	jmp    801008e6 <consoleintr+0xf6>
801008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e9:	a1 68 30 11 80       	mov    0x80113068,%eax
801008ee:	8d 50 01             	lea    0x1(%eax),%edx
801008f1:	89 15 68 30 11 80    	mov    %edx,0x80113068
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	89 c2                	mov    %eax,%edx
801008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008ff:	88 82 e0 2f 11 80    	mov    %al,-0x7feed020(%edx)
        consputc(c);
80100905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100908:	89 04 24             	mov    %eax,(%esp)
8010090b:	e8 83 fe ff ff       	call   80100793 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100910:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100914:	74 18                	je     8010092e <consoleintr+0x13e>
80100916:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010091a:	74 12                	je     8010092e <consoleintr+0x13e>
8010091c:	a1 68 30 11 80       	mov    0x80113068,%eax
80100921:	8b 15 60 30 11 80    	mov    0x80113060,%edx
80100927:	83 ea 80             	sub    $0xffffff80,%edx
8010092a:	39 d0                	cmp    %edx,%eax
8010092c:	75 18                	jne    80100946 <consoleintr+0x156>
          input.w = input.e;
8010092e:	a1 68 30 11 80       	mov    0x80113068,%eax
80100933:	a3 64 30 11 80       	mov    %eax,0x80113064
          wakeup(&input.r);
80100938:	c7 04 24 60 30 11 80 	movl   $0x80113060,(%esp)
8010093f:	e8 cc 4f 00 00       	call   80105910 <wakeup>
        }
      }
      break;
80100944:	eb 00                	jmp    80100946 <consoleintr+0x156>
80100946:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100947:	8b 45 08             	mov    0x8(%ebp),%eax
8010094a:	ff d0                	call   *%eax
8010094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010094f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100953:	0f 89 b5 fe ff ff    	jns    8010080e <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100959:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100960:	e8 08 59 00 00       	call   8010626d <release>
  if(doprocdump) {
80100965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100969:	74 05                	je     80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
8010096b:	e8 74 50 00 00       	call   801059e4 <procdump>
  }
}
80100970:	c9                   	leave  
80100971:	c3                   	ret    

80100972 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100972:	55                   	push   %ebp
80100973:	89 e5                	mov    %esp,%ebp
80100975:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100978:	8b 45 08             	mov    0x8(%ebp),%eax
8010097b:	89 04 24             	mov    %eax,(%esp)
8010097e:	e8 06 11 00 00       	call   80101a89 <iunlock>
  target = n;
80100983:	8b 45 10             	mov    0x10(%ebp),%eax
80100986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100989:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100990:	e8 71 58 00 00       	call   80106206 <acquire>
  while(n > 0){
80100995:	e9 aa 00 00 00       	jmp    80100a44 <consoleread+0xd2>
    while(input.r == input.w){
8010099a:	eb 42                	jmp    801009de <consoleread+0x6c>
      if(proc->killed){
8010099c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009a2:	8b 40 24             	mov    0x24(%eax),%eax
801009a5:	85 c0                	test   %eax,%eax
801009a7:	74 21                	je     801009ca <consoleread+0x58>
        release(&cons.lock);
801009a9:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
801009b0:	e8 b8 58 00 00       	call   8010626d <release>
        ilock(ip);
801009b5:	8b 45 08             	mov    0x8(%ebp),%eax
801009b8:	89 04 24             	mov    %eax,(%esp)
801009bb:	e8 b2 0f 00 00       	call   80101972 <ilock>
        return -1;
801009c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009c5:	e9 a5 00 00 00       	jmp    80100a6f <consoleread+0xfd>
      }
      sleep(&input.r, &cons.lock);
801009ca:	c7 44 24 04 e0 d5 10 	movl   $0x8010d5e0,0x4(%esp)
801009d1:	80 
801009d2:	c7 04 24 60 30 11 80 	movl   $0x80113060,(%esp)
801009d9:	e8 28 4e 00 00       	call   80105806 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009de:	8b 15 60 30 11 80    	mov    0x80113060,%edx
801009e4:	a1 64 30 11 80       	mov    0x80113064,%eax
801009e9:	39 c2                	cmp    %eax,%edx
801009eb:	74 af                	je     8010099c <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ed:	a1 60 30 11 80       	mov    0x80113060,%eax
801009f2:	8d 50 01             	lea    0x1(%eax),%edx
801009f5:	89 15 60 30 11 80    	mov    %edx,0x80113060
801009fb:	83 e0 7f             	and    $0x7f,%eax
801009fe:	0f b6 80 e0 2f 11 80 	movzbl -0x7feed020(%eax),%eax
80100a05:	0f be c0             	movsbl %al,%eax
80100a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a0b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a0f:	75 19                	jne    80100a2a <consoleread+0xb8>
      if(n < target){
80100a11:	8b 45 10             	mov    0x10(%ebp),%eax
80100a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a17:	73 0f                	jae    80100a28 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a19:	a1 60 30 11 80       	mov    0x80113060,%eax
80100a1e:	83 e8 01             	sub    $0x1,%eax
80100a21:	a3 60 30 11 80       	mov    %eax,0x80113060
      }
      break;
80100a26:	eb 26                	jmp    80100a4e <consoleread+0xdc>
80100a28:	eb 24                	jmp    80100a4e <consoleread+0xdc>
    }
    *dst++ = c;
80100a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a2d:	8d 50 01             	lea    0x1(%eax),%edx
80100a30:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a36:	88 10                	mov    %dl,(%eax)
    --n;
80100a38:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a3c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a40:	75 02                	jne    80100a44 <consoleread+0xd2>
      break;
80100a42:	eb 0a                	jmp    80100a4e <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a48:	0f 8f 4c ff ff ff    	jg     8010099a <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100a4e:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100a55:	e8 13 58 00 00       	call   8010626d <release>
  ilock(ip);
80100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80100a5d:	89 04 24             	mov    %eax,(%esp)
80100a60:	e8 0d 0f 00 00       	call   80101972 <ilock>

  return target - n;
80100a65:	8b 45 10             	mov    0x10(%ebp),%eax
80100a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6b:	29 c2                	sub    %eax,%edx
80100a6d:	89 d0                	mov    %edx,%eax
}
80100a6f:	c9                   	leave  
80100a70:	c3                   	ret    

80100a71 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a71:	55                   	push   %ebp
80100a72:	89 e5                	mov    %esp,%ebp
80100a74:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a77:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7a:	89 04 24             	mov    %eax,(%esp)
80100a7d:	e8 07 10 00 00       	call   80101a89 <iunlock>
  acquire(&cons.lock);
80100a82:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100a89:	e8 78 57 00 00       	call   80106206 <acquire>
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 1d                	jmp    80100ab4 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	89 04 24             	mov    %eax,(%esp)
80100aab:	e8 e3 fc ff ff       	call   80100793 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ab7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aba:	7c db                	jl     80100a97 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100abc:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100ac3:	e8 a5 57 00 00       	call   8010626d <release>
  ilock(ip);
80100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80100acb:	89 04 24             	mov    %eax,(%esp)
80100ace:	e8 9f 0e 00 00       	call   80101972 <ilock>

  return n;
80100ad3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ad6:	c9                   	leave  
80100ad7:	c3                   	ret    

80100ad8 <consoleinit>:

void
consoleinit(void)
{
80100ad8:	55                   	push   %ebp
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ade:	c7 44 24 04 6e 9b 10 	movl   $0x80109b6e,0x4(%esp)
80100ae5:	80 
80100ae6:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100aed:	e8 f3 56 00 00       	call   801061e5 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100af2:	c7 05 2c 3a 11 80 71 	movl   $0x80100a71,0x80113a2c
80100af9:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100afc:	c7 05 28 3a 11 80 72 	movl   $0x80100972,0x80113a28
80100b03:	09 10 80 
  cons.locking = 1;
80100b06:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100b0d:	00 00 00 

  picenable(IRQ_KBD);
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 c1 34 00 00       	call   80103fdd <picenable>
  ioapicenable(IRQ_KBD, 0);
80100b1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b23:	00 
80100b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b2b:	e8 1e 21 00 00       	call   80102c4e <ioapicenable>
}
80100b30:	c9                   	leave  
80100b31:	c3                   	ret    

80100b32 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b32:	55                   	push   %ebp
80100b33:	89 e5                	mov    %esp,%ebp
80100b35:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b3b:	e8 eb 2b 00 00       	call   8010372b <begin_op>

  if((ip = namei(path)) == 0){
80100b40:	8b 45 08             	mov    0x8(%ebp),%eax
80100b43:	89 04 24             	mov    %eax,(%esp)
80100b46:	e8 41 1b 00 00       	call   8010268c <namei>
80100b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b52:	75 0f                	jne    80100b63 <exec+0x31>
    end_op();
80100b54:	e8 56 2c 00 00       	call   801037af <end_op>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 19 04 00 00       	jmp    80100f7c <exec+0x44a>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 04 0e 00 00       	call   80101972 <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 54 14 00 00       	call   80101fee <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x72>
    goto bad;
80100b9f:	e9 ac 03 00 00       	jmp    80100f50 <exec+0x41e>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x84>
    goto bad;
80100bb1:	e9 9a 03 00 00       	jmp    80100f50 <exec+0x41e>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 50 86 00 00       	call   8010920b <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0x97>
    goto bad;
80100bc4:	e9 87 03 00 00       	jmp    80100f50 <exec+0x41e>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1af>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 e5 13 00 00       	call   80101fee <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xe1>
      goto bad;
80100c0e:	e9 3d 03 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0xf1>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1a2>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c29:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x106>
      goto bad;
80100c33:	e9 18 03 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c3e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x123>
      goto bad;
80100c50:	e9 fb 02 00 00       	jmp    80100f50 <exec+0x41e>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 5d 89 00 00       	call   801095d6 <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x155>
      goto bad;
80100c82:	e9 c9 02 00 00       	jmp    80100f50 <exec+0x41e>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x169>
      goto bad;
80100c96:	e9 b5 02 00 00       	jmp    80100f50 <exec+0x41e>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100ca1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 28 88 00 00       	call   801094f3 <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1a2>
      goto bad;
80100ccf:	e9 7c 02 00 00       	jmp    80100f50 <exec+0x41e>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xb3>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 62 0e 00 00       	call   80101b61 <iunlockput>
  end_op();
80100cff:	e8 ab 2a 00 00       	call   801037af <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 00 20 00 00       	add    $0x2000,%eax
80100d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 9d 88 00 00       	call   801095d6 <allocuvm>
80100d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d40:	75 05                	jne    80100d47 <exec+0x215>
    goto bad;
80100d42:	e9 09 02 00 00       	jmp    80100f50 <exec+0x41e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d56:	89 04 24             	mov    %eax,(%esp)
80100d59:	e8 eb 8a 00 00       	call   80109849 <clearpteu>
  sp = sz;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d6b:	e9 9a 00 00 00       	jmp    80100e0a <exec+0x2d8>
    if(argc >= MAXARG)
80100d70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d74:	76 05                	jbe    80100d7b <exec+0x249>
      goto bad;
80100d76:	e9 d5 01 00 00       	jmp    80100f50 <exec+0x41e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 45 59 00 00       	call   801066d9 <strlen>
80100d94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d97:	29 c2                	sub    %eax,%edx
80100d99:	89 d0                	mov    %edx,%eax
80100d9b:	83 e8 01             	sub    $0x1,%eax
80100d9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db1:	01 d0                	add    %edx,%eax
80100db3:	8b 00                	mov    (%eax),%eax
80100db5:	89 04 24             	mov    %eax,(%esp)
80100db8:	e8 1c 59 00 00       	call   801066d9 <strlen>
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 c2                	mov    %eax,%edx
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 c8                	add    %ecx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de5:	89 04 24             	mov    %eax,(%esp)
80100de8:	e8 14 8c 00 00       	call   80109a01 <copyout>
80100ded:	85 c0                	test   %eax,%eax
80100def:	79 05                	jns    80100df6 <exec+0x2c4>
      goto bad;
80100df1:	e9 5a 01 00 00       	jmp    80100f50 <exec+0x41e>
    ustack[3+argc] = sp;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 50 03             	lea    0x3(%eax),%edx
80100dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dff:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	01 d0                	add    %edx,%eax
80100e19:	8b 00                	mov    (%eax),%eax
80100e1b:	85 c0                	test   %eax,%eax
80100e1d:	0f 85 4d ff ff ff    	jne    80100d70 <exec+0x23e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 03             	add    $0x3,%eax
80100e29:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e30:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e34:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e3b:	ff ff ff 
  ustack[1] = argc;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	29 d0                	sub    %edx,%eax
80100e59:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e62:	83 c0 04             	add    $0x4,%eax
80100e65:	c1 e0 02             	shl    $0x2,%eax
80100e68:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	83 c0 04             	add    $0x4,%eax
80100e71:	c1 e0 02             	shl    $0x2,%eax
80100e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e78:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e8c:	89 04 24             	mov    %eax,(%esp)
80100e8f:	e8 6d 8b 00 00       	call   80109a01 <copyout>
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x36b>
    goto bad;
80100e98:	e9 b3 00 00 00       	jmp    80100f50 <exec+0x41e>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x390>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x38c>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x379>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed2:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ed5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100edc:	00 
80100edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee4:	89 14 24             	mov    %edx,(%esp)
80100ee7:	e8 a3 57 00 00       	call   8010668f <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 04             	mov    0x4(%eax),%eax
80100ef5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f01:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0d:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f15:	8b 40 18             	mov    0x18(%eax),%eax
80100f18:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f1e:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f27:	8b 40 18             	mov    0x18(%eax),%eax
80100f2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f2d:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f36:	89 04 24             	mov    %eax,(%esp)
80100f39:	e8 99 83 00 00       	call   801092d7 <switchuvm>
  freevm(oldpgdir);
80100f3e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f41:	89 04 24             	mov    %eax,(%esp)
80100f44:	e8 69 88 00 00       	call   801097b2 <freevm>
  return 0;
80100f49:	b8 00 00 00 00       	mov    $0x0,%eax
80100f4e:	eb 2c                	jmp    80100f7c <exec+0x44a>

 bad:
  if(pgdir)
80100f50:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f54:	74 0b                	je     80100f61 <exec+0x42f>
    freevm(pgdir);
80100f56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f59:	89 04 24             	mov    %eax,(%esp)
80100f5c:	e8 51 88 00 00       	call   801097b2 <freevm>
  if(ip){
80100f61:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f65:	74 10                	je     80100f77 <exec+0x445>
    iunlockput(ip);
80100f67:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f6a:	89 04 24             	mov    %eax,(%esp)
80100f6d:	e8 ef 0b 00 00       	call   80101b61 <iunlockput>
    end_op();
80100f72:	e8 38 28 00 00       	call   801037af <end_op>
  }
  return -1;
80100f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f7c:	c9                   	leave  
80100f7d:	c3                   	ret    

80100f7e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f7e:	55                   	push   %ebp
80100f7f:	89 e5                	mov    %esp,%ebp
80100f81:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f84:	c7 44 24 04 76 9b 10 	movl   $0x80109b76,0x4(%esp)
80100f8b:	80 
80100f8c:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80100f93:	e8 4d 52 00 00       	call   801061e5 <initlock>
}
80100f98:	c9                   	leave  
80100f99:	c3                   	ret    

80100f9a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f9a:	55                   	push   %ebp
80100f9b:	89 e5                	mov    %esp,%ebp
80100f9d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa0:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80100fa7:	e8 5a 52 00 00       	call   80106206 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fac:	c7 45 f4 b4 30 11 80 	movl   $0x801130b4,-0xc(%ebp)
80100fb3:	eb 29                	jmp    80100fde <filealloc+0x44>
    if(f->ref == 0){
80100fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb8:	8b 40 04             	mov    0x4(%eax),%eax
80100fbb:	85 c0                	test   %eax,%eax
80100fbd:	75 1b                	jne    80100fda <filealloc+0x40>
      f->ref = 1;
80100fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc2:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fc9:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80100fd0:	e8 98 52 00 00       	call   8010626d <release>
      return f;
80100fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fd8:	eb 1e                	jmp    80100ff8 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fda:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fde:	81 7d f4 14 3a 11 80 	cmpl   $0x80113a14,-0xc(%ebp)
80100fe5:	72 ce                	jb     80100fb5 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fe7:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80100fee:	e8 7a 52 00 00       	call   8010626d <release>
  return 0;
80100ff3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    

80100ffa <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ffa:	55                   	push   %ebp
80100ffb:	89 e5                	mov    %esp,%ebp
80100ffd:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80101000:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101007:	e8 fa 51 00 00       	call   80106206 <acquire>
  if(f->ref < 1)
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	8b 40 04             	mov    0x4(%eax),%eax
80101012:	85 c0                	test   %eax,%eax
80101014:	7f 0c                	jg     80101022 <filedup+0x28>
    panic("filedup");
80101016:	c7 04 24 7d 9b 10 80 	movl   $0x80109b7d,(%esp)
8010101d:	e8 40 f5 ff ff       	call   80100562 <panic>
  f->ref++;
80101022:	8b 45 08             	mov    0x8(%ebp),%eax
80101025:	8b 40 04             	mov    0x4(%eax),%eax
80101028:	8d 50 01             	lea    0x1(%eax),%edx
8010102b:	8b 45 08             	mov    0x8(%ebp),%eax
8010102e:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101031:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101038:	e8 30 52 00 00       	call   8010626d <release>
  return f;
8010103d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101040:	c9                   	leave  
80101041:	c3                   	ret    

80101042 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101042:	55                   	push   %ebp
80101043:	89 e5                	mov    %esp,%ebp
80101045:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101048:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
8010104f:	e8 b2 51 00 00       	call   80106206 <acquire>
  if(f->ref < 1)
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7f 0c                	jg     8010106a <fileclose+0x28>
    panic("fileclose");
8010105e:	c7 04 24 85 9b 10 80 	movl   $0x80109b85,(%esp)
80101065:	e8 f8 f4 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
8010106a:	8b 45 08             	mov    0x8(%ebp),%eax
8010106d:	8b 40 04             	mov    0x4(%eax),%eax
80101070:	8d 50 ff             	lea    -0x1(%eax),%edx
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	89 50 04             	mov    %edx,0x4(%eax)
80101079:	8b 45 08             	mov    0x8(%ebp),%eax
8010107c:	8b 40 04             	mov    0x4(%eax),%eax
8010107f:	85 c0                	test   %eax,%eax
80101081:	7e 11                	jle    80101094 <fileclose+0x52>
    release(&ftable.lock);
80101083:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
8010108a:	e8 de 51 00 00       	call   8010626d <release>
8010108f:	e9 82 00 00 00       	jmp    80101116 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101094:	8b 45 08             	mov    0x8(%ebp),%eax
80101097:	8b 10                	mov    (%eax),%edx
80101099:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010109c:	8b 50 04             	mov    0x4(%eax),%edx
8010109f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010a2:	8b 50 08             	mov    0x8(%eax),%edx
801010a5:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010a8:	8b 50 0c             	mov    0xc(%eax),%edx
801010ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010ae:	8b 50 10             	mov    0x10(%eax),%edx
801010b1:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010b4:	8b 40 14             	mov    0x14(%eax),%eax
801010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010c4:	8b 45 08             	mov    0x8(%ebp),%eax
801010c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010cd:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801010d4:	e8 94 51 00 00       	call   8010626d <release>

  if(ff.type == FD_PIPE)
801010d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dc:	83 f8 01             	cmp    $0x1,%eax
801010df:	75 18                	jne    801010f9 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010e1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010e5:	0f be d0             	movsbl %al,%edx
801010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010eb:	89 54 24 04          	mov    %edx,0x4(%esp)
801010ef:	89 04 24             	mov    %eax,(%esp)
801010f2:	e8 96 31 00 00       	call   8010428d <pipeclose>
801010f7:	eb 1d                	jmp    80101116 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010fc:	83 f8 02             	cmp    $0x2,%eax
801010ff:	75 15                	jne    80101116 <fileclose+0xd4>
    begin_op();
80101101:	e8 25 26 00 00       	call   8010372b <begin_op>
    iput(ff.ip);
80101106:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101109:	89 04 24             	mov    %eax,(%esp)
8010110c:	e8 bc 09 00 00       	call   80101acd <iput>
    end_op();
80101111:	e8 99 26 00 00       	call   801037af <end_op>
  }
}
80101116:	c9                   	leave  
80101117:	c3                   	ret    

80101118 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101118:	55                   	push   %ebp
80101119:	89 e5                	mov    %esp,%ebp
8010111b:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010111e:	8b 45 08             	mov    0x8(%ebp),%eax
80101121:	8b 00                	mov    (%eax),%eax
80101123:	83 f8 02             	cmp    $0x2,%eax
80101126:	75 38                	jne    80101160 <filestat+0x48>
    ilock(f->ip);
80101128:	8b 45 08             	mov    0x8(%ebp),%eax
8010112b:	8b 40 10             	mov    0x10(%eax),%eax
8010112e:	89 04 24             	mov    %eax,(%esp)
80101131:	e8 3c 08 00 00       	call   80101972 <ilock>
    stati(f->ip, st);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010113f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101143:	89 04 24             	mov    %eax,(%esp)
80101146:	e8 5e 0e 00 00       	call   80101fa9 <stati>
    iunlock(f->ip);
8010114b:	8b 45 08             	mov    0x8(%ebp),%eax
8010114e:	8b 40 10             	mov    0x10(%eax),%eax
80101151:	89 04 24             	mov    %eax,(%esp)
80101154:	e8 30 09 00 00       	call   80101a89 <iunlock>
    return 0;
80101159:	b8 00 00 00 00       	mov    $0x0,%eax
8010115e:	eb 05                	jmp    80101165 <filestat+0x4d>
  }
  return -1;
80101160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101165:	c9                   	leave  
80101166:	c3                   	ret    

80101167 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101167:	55                   	push   %ebp
80101168:	89 e5                	mov    %esp,%ebp
8010116a:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101174:	84 c0                	test   %al,%al
80101176:	75 0a                	jne    80101182 <fileread+0x1b>
    return -1;
80101178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010117d:	e9 9f 00 00 00       	jmp    80101221 <fileread+0xba>
  if(f->type == FD_PIPE)
80101182:	8b 45 08             	mov    0x8(%ebp),%eax
80101185:	8b 00                	mov    (%eax),%eax
80101187:	83 f8 01             	cmp    $0x1,%eax
8010118a:	75 1e                	jne    801011aa <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010118c:	8b 45 08             	mov    0x8(%ebp),%eax
8010118f:	8b 40 0c             	mov    0xc(%eax),%eax
80101192:	8b 55 10             	mov    0x10(%ebp),%edx
80101195:	89 54 24 08          	mov    %edx,0x8(%esp)
80101199:	8b 55 0c             	mov    0xc(%ebp),%edx
8010119c:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a0:	89 04 24             	mov    %eax,(%esp)
801011a3:	e8 66 32 00 00       	call   8010440e <piperead>
801011a8:	eb 77                	jmp    80101221 <fileread+0xba>
  if(f->type == FD_INODE){
801011aa:	8b 45 08             	mov    0x8(%ebp),%eax
801011ad:	8b 00                	mov    (%eax),%eax
801011af:	83 f8 02             	cmp    $0x2,%eax
801011b2:	75 61                	jne    80101215 <fileread+0xae>
    ilock(f->ip);
801011b4:	8b 45 08             	mov    0x8(%ebp),%eax
801011b7:	8b 40 10             	mov    0x10(%eax),%eax
801011ba:	89 04 24             	mov    %eax,(%esp)
801011bd:	e8 b0 07 00 00       	call   80101972 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011c5:	8b 45 08             	mov    0x8(%ebp),%eax
801011c8:	8b 50 14             	mov    0x14(%eax),%edx
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 40 10             	mov    0x10(%eax),%eax
801011d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011d5:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801011dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801011e0:	89 04 24             	mov    %eax,(%esp)
801011e3:	e8 06 0e 00 00       	call   80101fee <readi>
801011e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011ef:	7e 11                	jle    80101202 <fileread+0x9b>
      f->off += r;
801011f1:	8b 45 08             	mov    0x8(%ebp),%eax
801011f4:	8b 50 14             	mov    0x14(%eax),%edx
801011f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fa:	01 c2                	add    %eax,%edx
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 10             	mov    0x10(%eax),%eax
80101208:	89 04 24             	mov    %eax,(%esp)
8010120b:	e8 79 08 00 00       	call   80101a89 <iunlock>
    return r;
80101210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101213:	eb 0c                	jmp    80101221 <fileread+0xba>
  }
  panic("fileread");
80101215:	c7 04 24 8f 9b 10 80 	movl   $0x80109b8f,(%esp)
8010121c:	e8 41 f3 ff ff       	call   80100562 <panic>
}
80101221:	c9                   	leave  
80101222:	c3                   	ret    

80101223 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101223:	55                   	push   %ebp
80101224:	89 e5                	mov    %esp,%ebp
80101226:	53                   	push   %ebx
80101227:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101231:	84 c0                	test   %al,%al
80101233:	75 0a                	jne    8010123f <filewrite+0x1c>
    return -1;
80101235:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010123a:	e9 20 01 00 00       	jmp    8010135f <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010123f:	8b 45 08             	mov    0x8(%ebp),%eax
80101242:	8b 00                	mov    (%eax),%eax
80101244:	83 f8 01             	cmp    $0x1,%eax
80101247:	75 21                	jne    8010126a <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 40 0c             	mov    0xc(%eax),%eax
8010124f:	8b 55 10             	mov    0x10(%ebp),%edx
80101252:	89 54 24 08          	mov    %edx,0x8(%esp)
80101256:	8b 55 0c             	mov    0xc(%ebp),%edx
80101259:	89 54 24 04          	mov    %edx,0x4(%esp)
8010125d:	89 04 24             	mov    %eax,(%esp)
80101260:	e8 ba 30 00 00       	call   8010431f <pipewrite>
80101265:	e9 f5 00 00 00       	jmp    8010135f <filewrite+0x13c>
  if(f->type == FD_INODE){
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	8b 00                	mov    (%eax),%eax
8010126f:	83 f8 02             	cmp    $0x2,%eax
80101272:	0f 85 db 00 00 00    	jne    80101353 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101278:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010127f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101286:	e9 a8 00 00 00       	jmp    80101333 <filewrite+0x110>
      int n1 = n - i;
8010128b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010128e:	8b 55 10             	mov    0x10(%ebp),%edx
80101291:	29 c2                	sub    %eax,%edx
80101293:	89 d0                	mov    %edx,%eax
80101295:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101298:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010129b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010129e:	7e 06                	jle    801012a6 <filewrite+0x83>
        n1 = max;
801012a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012a6:	e8 80 24 00 00       	call   8010372b <begin_op>
      ilock(f->ip);
801012ab:	8b 45 08             	mov    0x8(%ebp),%eax
801012ae:	8b 40 10             	mov    0x10(%eax),%eax
801012b1:	89 04 24             	mov    %eax,(%esp)
801012b4:	e8 b9 06 00 00       	call   80101972 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012bc:	8b 45 08             	mov    0x8(%ebp),%eax
801012bf:	8b 50 14             	mov    0x14(%eax),%edx
801012c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801012c8:	01 c3                	add    %eax,%ebx
801012ca:	8b 45 08             	mov    0x8(%ebp),%eax
801012cd:	8b 40 10             	mov    0x10(%eax),%eax
801012d0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801012d8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012dc:	89 04 24             	mov    %eax,(%esp)
801012df:	e8 6e 0e 00 00       	call   80102152 <writei>
801012e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012eb:	7e 11                	jle    801012fe <filewrite+0xdb>
        f->off += r;
801012ed:	8b 45 08             	mov    0x8(%ebp),%eax
801012f0:	8b 50 14             	mov    0x14(%eax),%edx
801012f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f6:	01 c2                	add    %eax,%edx
801012f8:	8b 45 08             	mov    0x8(%ebp),%eax
801012fb:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101301:	8b 40 10             	mov    0x10(%eax),%eax
80101304:	89 04 24             	mov    %eax,(%esp)
80101307:	e8 7d 07 00 00       	call   80101a89 <iunlock>
      end_op();
8010130c:	e8 9e 24 00 00       	call   801037af <end_op>

      if(r < 0)
80101311:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101315:	79 02                	jns    80101319 <filewrite+0xf6>
        break;
80101317:	eb 26                	jmp    8010133f <filewrite+0x11c>
      if(r != n1)
80101319:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010131f:	74 0c                	je     8010132d <filewrite+0x10a>
        panic("short filewrite");
80101321:	c7 04 24 98 9b 10 80 	movl   $0x80109b98,(%esp)
80101328:	e8 35 f2 ff ff       	call   80100562 <panic>
      i += r;
8010132d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101330:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101333:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101336:	3b 45 10             	cmp    0x10(%ebp),%eax
80101339:	0f 8c 4c ff ff ff    	jl     8010128b <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010133f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101342:	3b 45 10             	cmp    0x10(%ebp),%eax
80101345:	75 05                	jne    8010134c <filewrite+0x129>
80101347:	8b 45 10             	mov    0x10(%ebp),%eax
8010134a:	eb 05                	jmp    80101351 <filewrite+0x12e>
8010134c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101351:	eb 0c                	jmp    8010135f <filewrite+0x13c>
  }
  panic("filewrite");
80101353:	c7 04 24 a8 9b 10 80 	movl   $0x80109ba8,(%esp)
8010135a:	e8 03 f2 ff ff       	call   80100562 <panic>
}
8010135f:	83 c4 24             	add    $0x24,%esp
80101362:	5b                   	pop    %ebx
80101363:	5d                   	pop    %ebp
80101364:	c3                   	ret    

80101365 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101365:	55                   	push   %ebp
80101366:	89 e5                	mov    %esp,%ebp
80101368:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010136b:	8b 45 08             	mov    0x8(%ebp),%eax
8010136e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101375:	00 
80101376:	89 04 24             	mov    %eax,(%esp)
80101379:	e8 37 ee ff ff       	call   801001b5 <bread>
8010137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101384:	83 c0 5c             	add    $0x5c,%eax
80101387:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
8010138e:	00 
8010138f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101393:	8b 45 0c             	mov    0xc(%ebp),%eax
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 a0 51 00 00       	call   8010653e <memmove>
  brelse(bp);
8010139e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a1:	89 04 24             	mov    %eax,(%esp)
801013a4:	e8 83 ee ff ff       	call   8010022c <brelse>
}
801013a9:	c9                   	leave  
801013aa:	c3                   	ret    

801013ab <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013ab:	55                   	push   %ebp
801013ac:	89 e5                	mov    %esp,%ebp
801013ae:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
801013b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	89 54 24 04          	mov    %edx,0x4(%esp)
801013bb:	89 04 24             	mov    %eax,(%esp)
801013be:	e8 f2 ed ff ff       	call   801001b5 <bread>
801013c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013c9:	83 c0 5c             	add    $0x5c,%eax
801013cc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013d3:	00 
801013d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013db:	00 
801013dc:	89 04 24             	mov    %eax,(%esp)
801013df:	e8 8b 50 00 00       	call   8010646f <memset>
  log_write(bp);
801013e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013e7:	89 04 24             	mov    %eax,(%esp)
801013ea:	e8 47 25 00 00       	call   80103936 <log_write>
  brelse(bp);
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	89 04 24             	mov    %eax,(%esp)
801013f5:	e8 32 ee ff ff       	call   8010022c <brelse>
}
801013fa:	c9                   	leave  
801013fb:	c3                   	ret    

801013fc <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013fc:	55                   	push   %ebp
801013fd:	89 e5                	mov    %esp,%ebp
801013ff:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101402:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101409:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101410:	e9 07 01 00 00       	jmp    8010151c <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
80101415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101418:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010141e:	85 c0                	test   %eax,%eax
80101420:	0f 48 c2             	cmovs  %edx,%eax
80101423:	c1 f8 0c             	sar    $0xc,%eax
80101426:	89 c2                	mov    %eax,%edx
80101428:	a1 98 3a 11 80       	mov    0x80113a98,%eax
8010142d:	01 d0                	add    %edx,%eax
8010142f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101433:	8b 45 08             	mov    0x8(%ebp),%eax
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 77 ed ff ff       	call   801001b5 <bread>
8010143e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101441:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101448:	e9 9d 00 00 00       	jmp    801014ea <balloc+0xee>
      m = 1 << (bi % 8);
8010144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101450:	99                   	cltd   
80101451:	c1 ea 1d             	shr    $0x1d,%edx
80101454:	01 d0                	add    %edx,%eax
80101456:	83 e0 07             	and    $0x7,%eax
80101459:	29 d0                	sub    %edx,%eax
8010145b:	ba 01 00 00 00       	mov    $0x1,%edx
80101460:	89 c1                	mov    %eax,%ecx
80101462:	d3 e2                	shl    %cl,%edx
80101464:	89 d0                	mov    %edx,%eax
80101466:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146c:	8d 50 07             	lea    0x7(%eax),%edx
8010146f:	85 c0                	test   %eax,%eax
80101471:	0f 48 c2             	cmovs  %edx,%eax
80101474:	c1 f8 03             	sar    $0x3,%eax
80101477:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010147a:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010147f:	0f b6 c0             	movzbl %al,%eax
80101482:	23 45 e8             	and    -0x18(%ebp),%eax
80101485:	85 c0                	test   %eax,%eax
80101487:	75 5d                	jne    801014e6 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
80101489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148c:	8d 50 07             	lea    0x7(%eax),%edx
8010148f:	85 c0                	test   %eax,%eax
80101491:	0f 48 c2             	cmovs  %edx,%eax
80101494:	c1 f8 03             	sar    $0x3,%eax
80101497:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010149a:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010149f:	89 d1                	mov    %edx,%ecx
801014a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014a4:	09 ca                	or     %ecx,%edx
801014a6:	89 d1                	mov    %edx,%ecx
801014a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014ab:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
801014af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b2:	89 04 24             	mov    %eax,(%esp)
801014b5:	e8 7c 24 00 00       	call   80103936 <log_write>
        brelse(bp);
801014ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bd:	89 04 24             	mov    %eax,(%esp)
801014c0:	e8 67 ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
801014c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cb:	01 c2                	add    %eax,%edx
801014cd:	8b 45 08             	mov    0x8(%ebp),%eax
801014d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801014d4:	89 04 24             	mov    %eax,(%esp)
801014d7:	e8 cf fe ff ff       	call   801013ab <bzero>
        return b + bi;
801014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e2:	01 d0                	add    %edx,%eax
801014e4:	eb 52                	jmp    80101538 <balloc+0x13c>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ea:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014f1:	7f 17                	jg     8010150a <balloc+0x10e>
801014f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f9:	01 d0                	add    %edx,%eax
801014fb:	89 c2                	mov    %eax,%edx
801014fd:	a1 80 3a 11 80       	mov    0x80113a80,%eax
80101502:	39 c2                	cmp    %eax,%edx
80101504:	0f 82 43 ff ff ff    	jb     8010144d <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010150a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 17 ed ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101515:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010151c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010151f:	a1 80 3a 11 80       	mov    0x80113a80,%eax
80101524:	39 c2                	cmp    %eax,%edx
80101526:	0f 82 e9 fe ff ff    	jb     80101415 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010152c:	c7 04 24 b4 9b 10 80 	movl   $0x80109bb4,(%esp)
80101533:	e8 2a f0 ff ff       	call   80100562 <panic>
}
80101538:	c9                   	leave  
80101539:	c3                   	ret    

8010153a <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010153a:	55                   	push   %ebp
8010153b:	89 e5                	mov    %esp,%ebp
8010153d:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101540:	c7 44 24 04 80 3a 11 	movl   $0x80113a80,0x4(%esp)
80101547:	80 
80101548:	8b 45 08             	mov    0x8(%ebp),%eax
8010154b:	89 04 24             	mov    %eax,(%esp)
8010154e:	e8 12 fe ff ff       	call   80101365 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101553:	8b 45 0c             	mov    0xc(%ebp),%eax
80101556:	c1 e8 0c             	shr    $0xc,%eax
80101559:	89 c2                	mov    %eax,%edx
8010155b:	a1 98 3a 11 80       	mov    0x80113a98,%eax
80101560:	01 c2                	add    %eax,%edx
80101562:	8b 45 08             	mov    0x8(%ebp),%eax
80101565:	89 54 24 04          	mov    %edx,0x4(%esp)
80101569:	89 04 24             	mov    %eax,(%esp)
8010156c:	e8 44 ec ff ff       	call   801001b5 <bread>
80101571:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101574:	8b 45 0c             	mov    0xc(%ebp),%eax
80101577:	25 ff 0f 00 00       	and    $0xfff,%eax
8010157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101582:	99                   	cltd   
80101583:	c1 ea 1d             	shr    $0x1d,%edx
80101586:	01 d0                	add    %edx,%eax
80101588:	83 e0 07             	and    $0x7,%eax
8010158b:	29 d0                	sub    %edx,%eax
8010158d:	ba 01 00 00 00       	mov    $0x1,%edx
80101592:	89 c1                	mov    %eax,%ecx
80101594:	d3 e2                	shl    %cl,%edx
80101596:	89 d0                	mov    %edx,%eax
80101598:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010159b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159e:	8d 50 07             	lea    0x7(%eax),%edx
801015a1:	85 c0                	test   %eax,%eax
801015a3:	0f 48 c2             	cmovs  %edx,%eax
801015a6:	c1 f8 03             	sar    $0x3,%eax
801015a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ac:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
801015b1:	0f b6 c0             	movzbl %al,%eax
801015b4:	23 45 ec             	and    -0x14(%ebp),%eax
801015b7:	85 c0                	test   %eax,%eax
801015b9:	75 0c                	jne    801015c7 <bfree+0x8d>
    panic("freeing free block");
801015bb:	c7 04 24 ca 9b 10 80 	movl   $0x80109bca,(%esp)
801015c2:	e8 9b ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
801015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ca:	8d 50 07             	lea    0x7(%eax),%edx
801015cd:	85 c0                	test   %eax,%eax
801015cf:	0f 48 c2             	cmovs  %edx,%eax
801015d2:	c1 f8 03             	sar    $0x3,%eax
801015d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d8:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801015dd:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015e0:	f7 d1                	not    %ecx
801015e2:	21 ca                	and    %ecx,%edx
801015e4:	89 d1                	mov    %edx,%ecx
801015e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015e9:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f0:	89 04 24             	mov    %eax,(%esp)
801015f3:	e8 3e 23 00 00       	call   80103936 <log_write>
  brelse(bp);
801015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fb:	89 04 24             	mov    %eax,(%esp)
801015fe:	e8 29 ec ff ff       	call   8010022c <brelse>
}
80101603:	c9                   	leave  
80101604:	c3                   	ret    

80101605 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101605:	55                   	push   %ebp
80101606:	89 e5                	mov    %esp,%ebp
80101608:	57                   	push   %edi
80101609:	56                   	push   %esi
8010160a:	53                   	push   %ebx
8010160b:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
8010160e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101615:	c7 44 24 04 dd 9b 10 	movl   $0x80109bdd,0x4(%esp)
8010161c:	80 
8010161d:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101624:	e8 bc 4b 00 00       	call   801061e5 <initlock>
  for(i = 0; i < NINODE; i++) {
80101629:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101630:	eb 2c                	jmp    8010165e <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
80101632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101635:	89 d0                	mov    %edx,%eax
80101637:	c1 e0 03             	shl    $0x3,%eax
8010163a:	01 d0                	add    %edx,%eax
8010163c:	c1 e0 04             	shl    $0x4,%eax
8010163f:	83 c0 30             	add    $0x30,%eax
80101642:	05 a0 3a 11 80       	add    $0x80113aa0,%eax
80101647:	83 c0 10             	add    $0x10,%eax
8010164a:	c7 44 24 04 e4 9b 10 	movl   $0x80109be4,0x4(%esp)
80101651:	80 
80101652:	89 04 24             	mov    %eax,(%esp)
80101655:	e8 4e 4a 00 00       	call   801060a8 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
8010165a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010165e:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101662:	7e ce                	jle    80101632 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
80101664:	c7 44 24 04 80 3a 11 	movl   $0x80113a80,0x4(%esp)
8010166b:	80 
8010166c:	8b 45 08             	mov    0x8(%ebp),%eax
8010166f:	89 04 24             	mov    %eax,(%esp)
80101672:	e8 ee fc ff ff       	call   80101365 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101677:	a1 98 3a 11 80       	mov    0x80113a98,%eax
8010167c:	8b 3d 94 3a 11 80    	mov    0x80113a94,%edi
80101682:	8b 35 90 3a 11 80    	mov    0x80113a90,%esi
80101688:	8b 1d 8c 3a 11 80    	mov    0x80113a8c,%ebx
8010168e:	8b 0d 88 3a 11 80    	mov    0x80113a88,%ecx
80101694:	8b 15 84 3a 11 80    	mov    0x80113a84,%edx
8010169a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010169d:	8b 15 80 3a 11 80    	mov    0x80113a80,%edx
801016a3:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801016a7:	89 7c 24 18          	mov    %edi,0x18(%esp)
801016ab:	89 74 24 14          	mov    %esi,0x14(%esp)
801016af:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801016b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801016b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801016be:	89 d0                	mov    %edx,%eax
801016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c4:	c7 04 24 ec 9b 10 80 	movl   $0x80109bec,(%esp)
801016cb:	e8 f8 ec ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801016d0:	83 c4 4c             	add    $0x4c,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5f                   	pop    %edi
801016d6:	5d                   	pop    %ebp
801016d7:	c3                   	ret    

801016d8 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016d8:	55                   	push   %ebp
801016d9:	89 e5                	mov    %esp,%ebp
801016db:	83 ec 28             	sub    $0x28,%esp
801016de:	8b 45 0c             	mov    0xc(%ebp),%eax
801016e1:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016e5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016ec:	e9 9e 00 00 00       	jmp    8010178f <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f4:	c1 e8 03             	shr    $0x3,%eax
801016f7:	89 c2                	mov    %eax,%edx
801016f9:	a1 94 3a 11 80       	mov    0x80113a94,%eax
801016fe:	01 d0                	add    %edx,%eax
80101700:	89 44 24 04          	mov    %eax,0x4(%esp)
80101704:	8b 45 08             	mov    0x8(%ebp),%eax
80101707:	89 04 24             	mov    %eax,(%esp)
8010170a:	e8 a6 ea ff ff       	call   801001b5 <bread>
8010170f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101712:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101715:	8d 50 5c             	lea    0x5c(%eax),%edx
80101718:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010171b:	83 e0 07             	and    $0x7,%eax
8010171e:	c1 e0 06             	shl    $0x6,%eax
80101721:	01 d0                	add    %edx,%eax
80101723:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101726:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101729:	0f b7 00             	movzwl (%eax),%eax
8010172c:	66 85 c0             	test   %ax,%ax
8010172f:	75 4f                	jne    80101780 <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
80101731:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101738:	00 
80101739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101740:	00 
80101741:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 23 4d 00 00       	call   8010646f <memset>
      dip->type = type;
8010174c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010174f:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101753:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101756:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101759:	89 04 24             	mov    %eax,(%esp)
8010175c:	e8 d5 21 00 00       	call   80103936 <log_write>
      brelse(bp);
80101761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101764:	89 04 24             	mov    %eax,(%esp)
80101767:	e8 c0 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
8010176c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101773:	8b 45 08             	mov    0x8(%ebp),%eax
80101776:	89 04 24             	mov    %eax,(%esp)
80101779:	e8 ed 00 00 00       	call   8010186b <iget>
8010177e:	eb 2b                	jmp    801017ab <ialloc+0xd3>
    }
    brelse(bp);
80101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101783:	89 04 24             	mov    %eax,(%esp)
80101786:	e8 a1 ea ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010178b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010178f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101792:	a1 88 3a 11 80       	mov    0x80113a88,%eax
80101797:	39 c2                	cmp    %eax,%edx
80101799:	0f 82 52 ff ff ff    	jb     801016f1 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010179f:	c7 04 24 3f 9c 10 80 	movl   $0x80109c3f,(%esp)
801017a6:	e8 b7 ed ff ff       	call   80100562 <panic>
}
801017ab:	c9                   	leave  
801017ac:	c3                   	ret    

801017ad <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017ad:	55                   	push   %ebp
801017ae:	89 e5                	mov    %esp,%ebp
801017b0:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	8b 40 04             	mov    0x4(%eax),%eax
801017b9:	c1 e8 03             	shr    $0x3,%eax
801017bc:	89 c2                	mov    %eax,%edx
801017be:	a1 94 3a 11 80       	mov    0x80113a94,%eax
801017c3:	01 c2                	add    %eax,%edx
801017c5:	8b 45 08             	mov    0x8(%ebp),%eax
801017c8:	8b 00                	mov    (%eax),%eax
801017ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801017ce:	89 04 24             	mov    %eax,(%esp)
801017d1:	e8 df e9 ff ff       	call   801001b5 <bread>
801017d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dc:	8d 50 5c             	lea    0x5c(%eax),%edx
801017df:	8b 45 08             	mov    0x8(%ebp),%eax
801017e2:	8b 40 04             	mov    0x4(%eax),%eax
801017e5:	83 e0 07             	and    $0x7,%eax
801017e8:	c1 e0 06             	shl    $0x6,%eax
801017eb:	01 d0                	add    %edx,%eax
801017ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017f0:	8b 45 08             	mov    0x8(%ebp),%eax
801017f3:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fa:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101800:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101807:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010180b:	8b 45 08             	mov    0x8(%ebp),%eax
8010180e:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101812:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101815:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101819:	8b 45 08             	mov    0x8(%ebp),%eax
8010181c:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101820:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101823:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101827:	8b 45 08             	mov    0x8(%ebp),%eax
8010182a:	8b 50 58             	mov    0x58(%eax),%edx
8010182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101830:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	8d 50 5c             	lea    0x5c(%eax),%edx
80101839:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183c:	83 c0 0c             	add    $0xc,%eax
8010183f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101846:	00 
80101847:	89 54 24 04          	mov    %edx,0x4(%esp)
8010184b:	89 04 24             	mov    %eax,(%esp)
8010184e:	e8 eb 4c 00 00       	call   8010653e <memmove>
  log_write(bp);
80101853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101856:	89 04 24             	mov    %eax,(%esp)
80101859:	e8 d8 20 00 00       	call   80103936 <log_write>
  brelse(bp);
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101861:	89 04 24             	mov    %eax,(%esp)
80101864:	e8 c3 e9 ff ff       	call   8010022c <brelse>
}
80101869:	c9                   	leave  
8010186a:	c3                   	ret    

8010186b <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010186b:	55                   	push   %ebp
8010186c:	89 e5                	mov    %esp,%ebp
8010186e:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101871:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101878:	e8 89 49 00 00       	call   80106206 <acquire>

  // Is the inode already cached?
  empty = 0;
8010187d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101884:	c7 45 f4 d4 3a 11 80 	movl   $0x80113ad4,-0xc(%ebp)
8010188b:	eb 5c                	jmp    801018e9 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010188d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101890:	8b 40 08             	mov    0x8(%eax),%eax
80101893:	85 c0                	test   %eax,%eax
80101895:	7e 35                	jle    801018cc <iget+0x61>
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 00                	mov    (%eax),%eax
8010189c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010189f:	75 2b                	jne    801018cc <iget+0x61>
801018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a4:	8b 40 04             	mov    0x4(%eax),%eax
801018a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801018aa:	75 20                	jne    801018cc <iget+0x61>
      ip->ref++;
801018ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018af:	8b 40 08             	mov    0x8(%eax),%eax
801018b2:	8d 50 01             	lea    0x1(%eax),%edx
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018bb:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
801018c2:	e8 a6 49 00 00       	call   8010626d <release>
      return ip;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ca:	eb 72                	jmp    8010193e <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018d0:	75 10                	jne    801018e2 <iget+0x77>
801018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d5:	8b 40 08             	mov    0x8(%eax),%eax
801018d8:	85 c0                	test   %eax,%eax
801018da:	75 06                	jne    801018e2 <iget+0x77>
      empty = ip;
801018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018df:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018e2:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018e9:	81 7d f4 f4 56 11 80 	cmpl   $0x801156f4,-0xc(%ebp)
801018f0:	72 9b                	jb     8010188d <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018f6:	75 0c                	jne    80101904 <iget+0x99>
    panic("iget: no inodes");
801018f8:	c7 04 24 51 9c 10 80 	movl   $0x80109c51,(%esp)
801018ff:	e8 5e ec ff ff       	call   80100562 <panic>

  ip = empty;
80101904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010190a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190d:	8b 55 08             	mov    0x8(%ebp),%edx
80101910:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101915:	8b 55 0c             	mov    0xc(%ebp),%edx
80101918:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101928:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010192f:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101936:	e8 32 49 00 00       	call   8010626d <release>

  return ip;
8010193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010193e:	c9                   	leave  
8010193f:	c3                   	ret    

80101940 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101946:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
8010194d:	e8 b4 48 00 00       	call   80106206 <acquire>
  ip->ref++;
80101952:	8b 45 08             	mov    0x8(%ebp),%eax
80101955:	8b 40 08             	mov    0x8(%eax),%eax
80101958:	8d 50 01             	lea    0x1(%eax),%edx
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101961:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101968:	e8 00 49 00 00       	call   8010626d <release>
  return ip;
8010196d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101970:	c9                   	leave  
80101971:	c3                   	ret    

80101972 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101972:	55                   	push   %ebp
80101973:	89 e5                	mov    %esp,%ebp
80101975:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101978:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010197c:	74 0a                	je     80101988 <ilock+0x16>
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	8b 40 08             	mov    0x8(%eax),%eax
80101984:	85 c0                	test   %eax,%eax
80101986:	7f 0c                	jg     80101994 <ilock+0x22>
    panic("ilock");
80101988:	c7 04 24 61 9c 10 80 	movl   $0x80109c61,(%esp)
8010198f:	e8 ce eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	83 c0 0c             	add    $0xc,%eax
8010199a:	89 04 24             	mov    %eax,(%esp)
8010199d:	e8 40 47 00 00       	call   801060e2 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801019a2:	8b 45 08             	mov    0x8(%ebp),%eax
801019a5:	8b 40 4c             	mov    0x4c(%eax),%eax
801019a8:	83 e0 02             	and    $0x2,%eax
801019ab:	85 c0                	test   %eax,%eax
801019ad:	0f 85 d4 00 00 00    	jne    80101a87 <ilock+0x115>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
801019b6:	8b 40 04             	mov    0x4(%eax),%eax
801019b9:	c1 e8 03             	shr    $0x3,%eax
801019bc:	89 c2                	mov    %eax,%edx
801019be:	a1 94 3a 11 80       	mov    0x80113a94,%eax
801019c3:	01 c2                	add    %eax,%edx
801019c5:	8b 45 08             	mov    0x8(%ebp),%eax
801019c8:	8b 00                	mov    (%eax),%eax
801019ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801019ce:	89 04 24             	mov    %eax,(%esp)
801019d1:	e8 df e7 ff ff       	call   801001b5 <bread>
801019d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019dc:	8d 50 5c             	lea    0x5c(%eax),%edx
801019df:	8b 45 08             	mov    0x8(%ebp),%eax
801019e2:	8b 40 04             	mov    0x4(%eax),%eax
801019e5:	83 e0 07             	and    $0x7,%eax
801019e8:	c1 e0 06             	shl    $0x6,%eax
801019eb:	01 d0                	add    %edx,%eax
801019ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f3:	0f b7 10             	movzwl (%eax),%edx
801019f6:	8b 45 08             	mov    0x8(%ebp),%eax
801019f9:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
801019fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a00:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a04:	8b 45 08             	mov    0x8(%ebp),%eax
80101a07:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a12:	8b 45 08             	mov    0x8(%ebp),%eax
80101a15:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2a:	8b 50 08             	mov    0x8(%eax),%edx
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a36:	8d 50 0c             	lea    0xc(%eax),%edx
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	83 c0 5c             	add    $0x5c,%eax
80101a3f:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a46:	00 
80101a47:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a4b:	89 04 24             	mov    %eax,(%esp)
80101a4e:	e8 eb 4a 00 00       	call   8010653e <memmove>
    brelse(bp);
80101a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a56:	89 04 24             	mov    %eax,(%esp)
80101a59:	e8 ce e7 ff ff       	call   8010022c <brelse>
    ip->flags |= I_VALID;
80101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a61:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a64:	83 c8 02             	or     $0x2,%eax
80101a67:	89 c2                	mov    %eax,%edx
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	89 50 4c             	mov    %edx,0x4c(%eax)
    if(ip->type == 0)
80101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a72:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101a76:	66 85 c0             	test   %ax,%ax
80101a79:	75 0c                	jne    80101a87 <ilock+0x115>
      panic("ilock: no type");
80101a7b:	c7 04 24 67 9c 10 80 	movl   $0x80109c67,(%esp)
80101a82:	e8 db ea ff ff       	call   80100562 <panic>
  }
}
80101a87:	c9                   	leave  
80101a88:	c3                   	ret    

80101a89 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a89:	55                   	push   %ebp
80101a8a:	89 e5                	mov    %esp,%ebp
80101a8c:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a93:	74 1c                	je     80101ab1 <iunlock+0x28>
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	83 c0 0c             	add    $0xc,%eax
80101a9b:	89 04 24             	mov    %eax,(%esp)
80101a9e:	e8 dd 46 00 00       	call   80106180 <holdingsleep>
80101aa3:	85 c0                	test   %eax,%eax
80101aa5:	74 0a                	je     80101ab1 <iunlock+0x28>
80101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaa:	8b 40 08             	mov    0x8(%eax),%eax
80101aad:	85 c0                	test   %eax,%eax
80101aaf:	7f 0c                	jg     80101abd <iunlock+0x34>
    panic("iunlock");
80101ab1:	c7 04 24 76 9c 10 80 	movl   $0x80109c76,(%esp)
80101ab8:	e8 a5 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101abd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac0:	83 c0 0c             	add    $0xc,%eax
80101ac3:	89 04 24             	mov    %eax,(%esp)
80101ac6:	e8 73 46 00 00       	call   8010613e <releasesleep>
}
80101acb:	c9                   	leave  
80101acc:	c3                   	ret    

80101acd <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101acd:	55                   	push   %ebp
80101ace:	89 e5                	mov    %esp,%ebp
80101ad0:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101ad3:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101ada:	e8 27 47 00 00       	call   80106206 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101adf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae2:	8b 40 08             	mov    0x8(%eax),%eax
80101ae5:	83 f8 01             	cmp    $0x1,%eax
80101ae8:	75 5a                	jne    80101b44 <iput+0x77>
80101aea:	8b 45 08             	mov    0x8(%ebp),%eax
80101aed:	8b 40 4c             	mov    0x4c(%eax),%eax
80101af0:	83 e0 02             	and    $0x2,%eax
80101af3:	85 c0                	test   %eax,%eax
80101af5:	74 4d                	je     80101b44 <iput+0x77>
80101af7:	8b 45 08             	mov    0x8(%ebp),%eax
80101afa:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101afe:	66 85 c0             	test   %ax,%ax
80101b01:	75 41                	jne    80101b44 <iput+0x77>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
80101b03:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101b0a:	e8 5e 47 00 00       	call   8010626d <release>
    itrunc(ip);
80101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b12:	89 04 24             	mov    %eax,(%esp)
80101b15:	e8 b5 02 00 00       	call   80101dcf <itrunc>
    ip->type = 0;
80101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1d:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
    iupdate(ip);
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	89 04 24             	mov    %eax,(%esp)
80101b29:	e8 7f fc ff ff       	call   801017ad <iupdate>
    acquire(&icache.lock);
80101b2e:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101b35:	e8 cc 46 00 00       	call   80106206 <acquire>
    ip->flags = 0;
80101b3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }
  ip->ref--;
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	8b 40 08             	mov    0x8(%eax),%eax
80101b4a:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b50:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b53:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101b5a:	e8 0e 47 00 00       	call   8010626d <release>
}
80101b5f:	c9                   	leave  
80101b60:	c3                   	ret    

80101b61 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b67:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6a:	89 04 24             	mov    %eax,(%esp)
80101b6d:	e8 17 ff ff ff       	call   80101a89 <iunlock>
  iput(ip);
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	89 04 24             	mov    %eax,(%esp)
80101b78:	e8 50 ff ff ff       	call   80101acd <iput>
}
80101b7d:	c9                   	leave  
80101b7e:	c3                   	ret    

80101b7f <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b7f:	55                   	push   %ebp
80101b80:	89 e5                	mov    %esp,%ebp
80101b82:	53                   	push   %ebx
80101b83:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b86:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b8a:	77 3e                	ja     80101bca <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b92:	83 c2 14             	add    $0x14,%edx
80101b95:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b99:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba0:	75 20                	jne    80101bc2 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba5:	8b 00                	mov    (%eax),%eax
80101ba7:	89 04 24             	mov    %eax,(%esp)
80101baa:	e8 4d f8 ff ff       	call   801013fc <balloc>
80101baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb8:	8d 4a 14             	lea    0x14(%edx),%ecx
80101bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbe:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc5:	e9 ff 01 00 00       	jmp    80101dc9 <bmap+0x24a>
  }
  bn -= NDIRECT;
80101bca:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bce:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bd2:	0f 87 ab 00 00 00    	ja     80101c83 <bmap+0x104>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bdb:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101be8:	75 1c                	jne    80101c06 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bea:	8b 45 08             	mov    0x8(%ebp),%eax
80101bed:	8b 00                	mov    (%eax),%eax
80101bef:	89 04 24             	mov    %eax,(%esp)
80101bf2:	e8 05 f8 ff ff       	call   801013fc <balloc>
80101bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c00:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c06:	8b 45 08             	mov    0x8(%ebp),%eax
80101c09:	8b 00                	mov    (%eax),%eax
80101c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c12:	89 04 24             	mov    %eax,(%esp)
80101c15:	e8 9b e5 ff ff       	call   801001b5 <bread>
80101c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c20:	83 c0 5c             	add    $0x5c,%eax
80101c23:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c33:	01 d0                	add    %edx,%eax
80101c35:	8b 00                	mov    (%eax),%eax
80101c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c3e:	75 30                	jne    80101c70 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c40:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c4d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c50:	8b 45 08             	mov    0x8(%ebp),%eax
80101c53:	8b 00                	mov    (%eax),%eax
80101c55:	89 04 24             	mov    %eax,(%esp)
80101c58:	e8 9f f7 ff ff       	call   801013fc <balloc>
80101c5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c63:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c68:	89 04 24             	mov    %eax,(%esp)
80101c6b:	e8 c6 1c 00 00       	call   80103936 <log_write>
    }
    brelse(bp);
80101c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c73:	89 04 24             	mov    %eax,(%esp)
80101c76:	e8 b1 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7e:	e9 46 01 00 00       	jmp    80101dc9 <bmap+0x24a>
  }

  bn -=NINDIRECT;	
80101c83:	83 45 0c 80          	addl   $0xffffff80,0xc(%ebp)
  if(bn < NINDIRECT*NINDIRECT){
80101c87:	81 7d 0c ff 3f 00 00 	cmpl   $0x3fff,0xc(%ebp)
80101c8e:	0f 87 29 01 00 00    	ja     80101dbd <bmap+0x23e>
        // secondary storage (indirect block).
        if((addr = ip->addrs[NDIRECT+1]) == 0) 
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80101c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ca4:	75 1c                	jne    80101cc2 <bmap+0x143>
          ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
80101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca9:	8b 00                	mov    (%eax),%eax
80101cab:	89 04 24             	mov    %eax,(%esp)
80101cae:	e8 49 f7 ff ff       	call   801013fc <balloc>
80101cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cbc:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        bp = bread(ip->dev, addr);
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	8b 00                	mov    (%eax),%eax
80101cc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cca:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cce:	89 04 24             	mov    %eax,(%esp)
80101cd1:	e8 df e4 ff ff       	call   801001b5 <bread>
80101cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        a = (uint*)bp->data;
80101cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cdc:	83 c0 5c             	add    $0x5c,%eax
80101cdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if ((addr = a[bn/(NINDIRECT)]) == 0) { //  index for 1st level                        
80101ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ce5:	c1 e8 07             	shr    $0x7,%eax
80101ce8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf2:	01 d0                	add    %edx,%eax
80101cf4:	8b 00                	mov    (%eax),%eax
80101cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cfd:	75 33                	jne    80101d32 <bmap+0x1b3>
              a[bn/(NINDIRECT)] = addr = balloc(ip->dev);
80101cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d02:	c1 e8 07             	shr    $0x7,%eax
80101d05:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d0f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	8b 00                	mov    (%eax),%eax
80101d17:	89 04 24             	mov    %eax,(%esp)
80101d1a:	e8 dd f6 ff ff       	call   801013fc <balloc>
80101d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d25:	89 03                	mov    %eax,(%ebx)
              log_write(bp);
80101d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2a:	89 04 24             	mov    %eax,(%esp)
80101d2d:	e8 04 1c 00 00       	call   80103936 <log_write>
        }
        brelse(bp);               // release 1st level
80101d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d35:	89 04 24             	mov    %eax,(%esp)
80101d38:	e8 ef e4 ff ff       	call   8010022c <brelse>
        bp = bread(ip->dev, addr);
80101d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d40:	8b 00                	mov    (%eax),%eax
80101d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d45:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d49:	89 04 24             	mov    %eax,(%esp)
80101d4c:	e8 64 e4 ff ff       	call   801001b5 <bread>
80101d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
        a = (uint*)bp->data;
80101d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d57:	83 c0 5c             	add    $0x5c,%eax
80101d5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if ((addr = a[bn%(NINDIRECT)]) == 0) { // index for 2nd level 
80101d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d60:	83 e0 7f             	and    $0x7f,%eax
80101d63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6d:	01 d0                	add    %edx,%eax
80101d6f:	8b 00                	mov    (%eax),%eax
80101d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d78:	75 33                	jne    80101dad <bmap+0x22e>
             a[bn%(NINDIRECT)] = addr = balloc(ip->dev);
80101d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d7d:	83 e0 7f             	and    $0x7f,%eax
80101d80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	8b 00                	mov    (%eax),%eax
80101d92:	89 04 24             	mov    %eax,(%esp)
80101d95:	e8 62 f6 ff ff       	call   801013fc <balloc>
80101d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101da0:	89 03                	mov    %eax,(%ebx)
             log_write(bp);
80101da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da5:	89 04 24             	mov    %eax,(%esp)
80101da8:	e8 89 1b 00 00       	call   80103936 <log_write>
        }
        brelse(bp); //release 2nd level
80101dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db0:	89 04 24             	mov    %eax,(%esp)
80101db3:	e8 74 e4 ff ff       	call   8010022c <brelse>
        return addr;
80101db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dbb:	eb 0c                	jmp    80101dc9 <bmap+0x24a>
    }
  panic("bmap: out of range");
80101dbd:	c7 04 24 7e 9c 10 80 	movl   $0x80109c7e,(%esp)
80101dc4:	e8 99 e7 ff ff       	call   80100562 <panic>
}
80101dc9:	83 c4 24             	add    $0x24,%esp
80101dcc:	5b                   	pop    %ebx
80101dcd:	5d                   	pop    %ebp
80101dce:	c3                   	ret    

80101dcf <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101dcf:	55                   	push   %ebp
80101dd0:	89 e5                	mov    %esp,%ebp
80101dd2:	83 ec 38             	sub    $0x38,%esp
  int i, j, k;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ddc:	eb 44                	jmp    80101e22 <itrunc+0x53>
    if(ip->addrs[i]){
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de4:	83 c2 14             	add    $0x14,%edx
80101de7:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	74 2f                	je     80101e1e <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101def:	8b 45 08             	mov    0x8(%ebp),%eax
80101df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101df5:	83 c2 14             	add    $0x14,%edx
80101df8:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	8b 00                	mov    (%eax),%eax
80101e01:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e05:	89 04 24             	mov    %eax,(%esp)
80101e08:	e8 2d f7 ff ff       	call   8010153a <bfree>
      ip->addrs[i] = 0;
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e13:	83 c2 14             	add    $0x14,%edx
80101e16:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e1d:	00 
{
  int i, j, k;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e22:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e26:	7e b6                	jle    80101dde <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101e31:	85 c0                	test   %eax,%eax
80101e33:	0f 84 a4 00 00 00    	je     80101edd <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e39:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3c:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	8b 00                	mov    (%eax),%eax
80101e47:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e4b:	89 04 24             	mov    %eax,(%esp)
80101e4e:	e8 62 e3 ff ff       	call   801001b5 <bread>
80101e53:	89 45 e8             	mov    %eax,-0x18(%ebp)
    a = (uint*)bp->data;
80101e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e59:	83 c0 5c             	add    $0x5c,%eax
80101e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e5f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e66:	eb 3b                	jmp    80101ea3 <itrunc+0xd4>
      if(a[j])
80101e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e75:	01 d0                	add    %edx,%eax
80101e77:	8b 00                	mov    (%eax),%eax
80101e79:	85 c0                	test   %eax,%eax
80101e7b:	74 22                	je     80101e9f <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e80:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e8a:	01 d0                	add    %edx,%eax
80101e8c:	8b 10                	mov    (%eax),%edx
80101e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e91:	8b 00                	mov    (%eax),%eax
80101e93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e97:	89 04 24             	mov    %eax,(%esp)
80101e9a:	e8 9b f6 ff ff       	call   8010153a <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101e9f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea6:	83 f8 7f             	cmp    $0x7f,%eax
80101ea9:	76 bd                	jbe    80101e68 <itrunc+0x99>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eae:	89 04 24             	mov    %eax,(%esp)
80101eb1:	e8 76 e3 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb9:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101ebf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec2:	8b 00                	mov    (%eax),%eax
80101ec4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ec8:	89 04 24             	mov    %eax,(%esp)
80101ecb:	e8 6a f6 ff ff       	call   8010153a <bfree>
    ip->addrs[NDIRECT] = 0;
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101eda:	00 00 00 
  }

  if(ip->addrs[NINDIRECT]){
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 80 5c 02 00 00    	mov    0x25c(%eax),%eax
80101ee6:	85 c0                	test   %eax,%eax
80101ee8:	0f 84 a4 00 00 00    	je     80101f92 <itrunc+0x1c3>
    bp = bread(ip->dev, ip->addrs[NINDIRECT]);
80101eee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef1:	8b 90 5c 02 00 00    	mov    0x25c(%eax),%edx
80101ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80101efa:	8b 00                	mov    (%eax),%eax
80101efc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f00:	89 04 24             	mov    %eax,(%esp)
80101f03:	e8 ad e2 ff ff       	call   801001b5 <bread>
80101f08:	89 45 e8             	mov    %eax,-0x18(%ebp)
    a = (uint*)bp->data;
80101f0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f0e:	83 c0 5c             	add    $0x5c,%eax
80101f11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(k = 0; k < NINDIRECT; k++){
80101f14:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80101f1b:	eb 3b                	jmp    80101f58 <itrunc+0x189>
      if(a[k])
80101f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f2a:	01 d0                	add    %edx,%eax
80101f2c:	8b 00                	mov    (%eax),%eax
80101f2e:	85 c0                	test   %eax,%eax
80101f30:	74 22                	je     80101f54 <itrunc+0x185>
        bfree(ip->dev, a[k]);
80101f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f3f:	01 d0                	add    %edx,%eax
80101f41:	8b 10                	mov    (%eax),%edx
80101f43:	8b 45 08             	mov    0x8(%ebp),%eax
80101f46:	8b 00                	mov    (%eax),%eax
80101f48:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f4c:	89 04 24             	mov    %eax,(%esp)
80101f4f:	e8 e6 f5 ff ff       	call   8010153a <bfree>
  }

  if(ip->addrs[NINDIRECT]){
    bp = bread(ip->dev, ip->addrs[NINDIRECT]);
    a = (uint*)bp->data;
    for(k = 0; k < NINDIRECT; k++){
80101f54:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80101f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f5b:	83 f8 7f             	cmp    $0x7f,%eax
80101f5e:	76 bd                	jbe    80101f1d <itrunc+0x14e>
      if(a[k])
        bfree(ip->dev, a[k]);
    }
    brelse(bp);
80101f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f63:	89 04 24             	mov    %eax,(%esp)
80101f66:	e8 c1 e2 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NINDIRECT]);
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6e:	8b 90 5c 02 00 00    	mov    0x25c(%eax),%edx
80101f74:	8b 45 08             	mov    0x8(%ebp),%eax
80101f77:	8b 00                	mov    (%eax),%eax
80101f79:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f7d:	89 04 24             	mov    %eax,(%esp)
80101f80:	e8 b5 f5 ff ff       	call   8010153a <bfree>
    ip->addrs[NINDIRECT] = 0;
80101f85:	8b 45 08             	mov    0x8(%ebp),%eax
80101f88:	c7 80 5c 02 00 00 00 	movl   $0x0,0x25c(%eax)
80101f8f:	00 00 00 
  }

  ip->size = 0;
80101f92:	8b 45 08             	mov    0x8(%ebp),%eax
80101f95:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9f:	89 04 24             	mov    %eax,(%esp)
80101fa2:	e8 06 f8 ff ff       	call   801017ad <iupdate>
}
80101fa7:	c9                   	leave  
80101fa8:	c3                   	ret    

80101fa9 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101fa9:	55                   	push   %ebp
80101faa:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101fac:	8b 45 08             	mov    0x8(%ebp),%eax
80101faf:	8b 00                	mov    (%eax),%eax
80101fb1:	89 c2                	mov    %eax,%edx
80101fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb6:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	8b 50 04             	mov    0x4(%eax),%edx
80101fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fc2:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc8:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fcf:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd5:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdc:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 50 58             	mov    0x58(%eax),%edx
80101fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe9:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fec:	5d                   	pop    %ebp
80101fed:	c3                   	ret    

80101fee <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fee:	55                   	push   %ebp
80101fef:	89 e5                	mov    %esp,%ebp
80101ff1:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ffb:	66 83 f8 03          	cmp    $0x3,%ax
80101fff:	75 60                	jne    80102061 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102001:	8b 45 08             	mov    0x8(%ebp),%eax
80102004:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102008:	66 85 c0             	test   %ax,%ax
8010200b:	78 20                	js     8010202d <readi+0x3f>
8010200d:	8b 45 08             	mov    0x8(%ebp),%eax
80102010:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102014:	66 83 f8 09          	cmp    $0x9,%ax
80102018:	7f 13                	jg     8010202d <readi+0x3f>
8010201a:	8b 45 08             	mov    0x8(%ebp),%eax
8010201d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102021:	98                   	cwtl   
80102022:	8b 04 c5 20 3a 11 80 	mov    -0x7feec5e0(,%eax,8),%eax
80102029:	85 c0                	test   %eax,%eax
8010202b:	75 0a                	jne    80102037 <readi+0x49>
      return -1;
8010202d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102032:	e9 19 01 00 00       	jmp    80102150 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010203e:	98                   	cwtl   
8010203f:	8b 04 c5 20 3a 11 80 	mov    -0x7feec5e0(,%eax,8),%eax
80102046:	8b 55 14             	mov    0x14(%ebp),%edx
80102049:	89 54 24 08          	mov    %edx,0x8(%esp)
8010204d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102050:	89 54 24 04          	mov    %edx,0x4(%esp)
80102054:	8b 55 08             	mov    0x8(%ebp),%edx
80102057:	89 14 24             	mov    %edx,(%esp)
8010205a:	ff d0                	call   *%eax
8010205c:	e9 ef 00 00 00       	jmp    80102150 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80102061:	8b 45 08             	mov    0x8(%ebp),%eax
80102064:	8b 40 58             	mov    0x58(%eax),%eax
80102067:	3b 45 10             	cmp    0x10(%ebp),%eax
8010206a:	72 0d                	jb     80102079 <readi+0x8b>
8010206c:	8b 45 14             	mov    0x14(%ebp),%eax
8010206f:	8b 55 10             	mov    0x10(%ebp),%edx
80102072:	01 d0                	add    %edx,%eax
80102074:	3b 45 10             	cmp    0x10(%ebp),%eax
80102077:	73 0a                	jae    80102083 <readi+0x95>
    return -1;
80102079:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010207e:	e9 cd 00 00 00       	jmp    80102150 <readi+0x162>
  if(off + n > ip->size)
80102083:	8b 45 14             	mov    0x14(%ebp),%eax
80102086:	8b 55 10             	mov    0x10(%ebp),%edx
80102089:	01 c2                	add    %eax,%edx
8010208b:	8b 45 08             	mov    0x8(%ebp),%eax
8010208e:	8b 40 58             	mov    0x58(%eax),%eax
80102091:	39 c2                	cmp    %eax,%edx
80102093:	76 0c                	jbe    801020a1 <readi+0xb3>
    n = ip->size - off;
80102095:	8b 45 08             	mov    0x8(%ebp),%eax
80102098:	8b 40 58             	mov    0x58(%eax),%eax
8010209b:	2b 45 10             	sub    0x10(%ebp),%eax
8010209e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a8:	e9 94 00 00 00       	jmp    80102141 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020ad:	8b 45 10             	mov    0x10(%ebp),%eax
801020b0:	c1 e8 09             	shr    $0x9,%eax
801020b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801020b7:	8b 45 08             	mov    0x8(%ebp),%eax
801020ba:	89 04 24             	mov    %eax,(%esp)
801020bd:	e8 bd fa ff ff       	call   80101b7f <bmap>
801020c2:	8b 55 08             	mov    0x8(%ebp),%edx
801020c5:	8b 12                	mov    (%edx),%edx
801020c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801020cb:	89 14 24             	mov    %edx,(%esp)
801020ce:	e8 e2 e0 ff ff       	call   801001b5 <bread>
801020d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020d6:	8b 45 10             	mov    0x10(%ebp),%eax
801020d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020de:	89 c2                	mov    %eax,%edx
801020e0:	b8 00 02 00 00       	mov    $0x200,%eax
801020e5:	29 d0                	sub    %edx,%eax
801020e7:	89 c2                	mov    %eax,%edx
801020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ec:	8b 4d 14             	mov    0x14(%ebp),%ecx
801020ef:	29 c1                	sub    %eax,%ecx
801020f1:	89 c8                	mov    %ecx,%eax
801020f3:	39 c2                	cmp    %eax,%edx
801020f5:	0f 46 c2             	cmovbe %edx,%eax
801020f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801020fb:	8b 45 10             	mov    0x10(%ebp),%eax
801020fe:	25 ff 01 00 00       	and    $0x1ff,%eax
80102103:	8d 50 50             	lea    0x50(%eax),%edx
80102106:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102109:	01 d0                	add    %edx,%eax
8010210b:	8d 50 0c             	lea    0xc(%eax),%edx
8010210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102111:	89 44 24 08          	mov    %eax,0x8(%esp)
80102115:	89 54 24 04          	mov    %edx,0x4(%esp)
80102119:	8b 45 0c             	mov    0xc(%ebp),%eax
8010211c:	89 04 24             	mov    %eax,(%esp)
8010211f:	e8 1a 44 00 00       	call   8010653e <memmove>
    brelse(bp);
80102124:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102127:	89 04 24             	mov    %eax,(%esp)
8010212a:	e8 fd e0 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010212f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102132:	01 45 f4             	add    %eax,-0xc(%ebp)
80102135:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102138:	01 45 10             	add    %eax,0x10(%ebp)
8010213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010213e:	01 45 0c             	add    %eax,0xc(%ebp)
80102141:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102144:	3b 45 14             	cmp    0x14(%ebp),%eax
80102147:	0f 82 60 ff ff ff    	jb     801020ad <readi+0xbf>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010214d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102152:	55                   	push   %ebp
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102158:	8b 45 08             	mov    0x8(%ebp),%eax
8010215b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010215f:	66 83 f8 03          	cmp    $0x3,%ax
80102163:	75 60                	jne    801021c5 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102165:	8b 45 08             	mov    0x8(%ebp),%eax
80102168:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010216c:	66 85 c0             	test   %ax,%ax
8010216f:	78 20                	js     80102191 <writei+0x3f>
80102171:	8b 45 08             	mov    0x8(%ebp),%eax
80102174:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102178:	66 83 f8 09          	cmp    $0x9,%ax
8010217c:	7f 13                	jg     80102191 <writei+0x3f>
8010217e:	8b 45 08             	mov    0x8(%ebp),%eax
80102181:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102185:	98                   	cwtl   
80102186:	8b 04 c5 24 3a 11 80 	mov    -0x7feec5dc(,%eax,8),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 0a                	jne    8010219b <writei+0x49>
      return -1;
80102191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102196:	e9 44 01 00 00       	jmp    801022df <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
8010219e:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801021a2:	98                   	cwtl   
801021a3:	8b 04 c5 24 3a 11 80 	mov    -0x7feec5dc(,%eax,8),%eax
801021aa:	8b 55 14             	mov    0x14(%ebp),%edx
801021ad:	89 54 24 08          	mov    %edx,0x8(%esp)
801021b1:	8b 55 0c             	mov    0xc(%ebp),%edx
801021b4:	89 54 24 04          	mov    %edx,0x4(%esp)
801021b8:	8b 55 08             	mov    0x8(%ebp),%edx
801021bb:	89 14 24             	mov    %edx,(%esp)
801021be:	ff d0                	call   *%eax
801021c0:	e9 1a 01 00 00       	jmp    801022df <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
801021c5:	8b 45 08             	mov    0x8(%ebp),%eax
801021c8:	8b 40 58             	mov    0x58(%eax),%eax
801021cb:	3b 45 10             	cmp    0x10(%ebp),%eax
801021ce:	72 0d                	jb     801021dd <writei+0x8b>
801021d0:	8b 45 14             	mov    0x14(%ebp),%eax
801021d3:	8b 55 10             	mov    0x10(%ebp),%edx
801021d6:	01 d0                	add    %edx,%eax
801021d8:	3b 45 10             	cmp    0x10(%ebp),%eax
801021db:	73 0a                	jae    801021e7 <writei+0x95>
    return -1;
801021dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e2:	e9 f8 00 00 00       	jmp    801022df <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
801021e7:	8b 45 14             	mov    0x14(%ebp),%eax
801021ea:	8b 55 10             	mov    0x10(%ebp),%edx
801021ed:	01 d0                	add    %edx,%eax
801021ef:	3d 00 18 81 00       	cmp    $0x811800,%eax
801021f4:	76 0a                	jbe    80102200 <writei+0xae>
    return -1;
801021f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fb:	e9 df 00 00 00       	jmp    801022df <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102200:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102207:	e9 9f 00 00 00       	jmp    801022ab <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010220c:	8b 45 10             	mov    0x10(%ebp),%eax
8010220f:	c1 e8 09             	shr    $0x9,%eax
80102212:	89 44 24 04          	mov    %eax,0x4(%esp)
80102216:	8b 45 08             	mov    0x8(%ebp),%eax
80102219:	89 04 24             	mov    %eax,(%esp)
8010221c:	e8 5e f9 ff ff       	call   80101b7f <bmap>
80102221:	8b 55 08             	mov    0x8(%ebp),%edx
80102224:	8b 12                	mov    (%edx),%edx
80102226:	89 44 24 04          	mov    %eax,0x4(%esp)
8010222a:	89 14 24             	mov    %edx,(%esp)
8010222d:	e8 83 df ff ff       	call   801001b5 <bread>
80102232:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102235:	8b 45 10             	mov    0x10(%ebp),%eax
80102238:	25 ff 01 00 00       	and    $0x1ff,%eax
8010223d:	89 c2                	mov    %eax,%edx
8010223f:	b8 00 02 00 00       	mov    $0x200,%eax
80102244:	29 d0                	sub    %edx,%eax
80102246:	89 c2                	mov    %eax,%edx
80102248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010224b:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010224e:	29 c1                	sub    %eax,%ecx
80102250:	89 c8                	mov    %ecx,%eax
80102252:	39 c2                	cmp    %eax,%edx
80102254:	0f 46 c2             	cmovbe %edx,%eax
80102257:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010225a:	8b 45 10             	mov    0x10(%ebp),%eax
8010225d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102262:	8d 50 50             	lea    0x50(%eax),%edx
80102265:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102268:	01 d0                	add    %edx,%eax
8010226a:	8d 50 0c             	lea    0xc(%eax),%edx
8010226d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102270:	89 44 24 08          	mov    %eax,0x8(%esp)
80102274:	8b 45 0c             	mov    0xc(%ebp),%eax
80102277:	89 44 24 04          	mov    %eax,0x4(%esp)
8010227b:	89 14 24             	mov    %edx,(%esp)
8010227e:	e8 bb 42 00 00       	call   8010653e <memmove>
    log_write(bp);
80102283:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102286:	89 04 24             	mov    %eax,(%esp)
80102289:	e8 a8 16 00 00       	call   80103936 <log_write>
    brelse(bp);
8010228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102291:	89 04 24             	mov    %eax,(%esp)
80102294:	e8 93 df ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102299:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010229c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010229f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022a2:	01 45 10             	add    %eax,0x10(%ebp)
801022a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022a8:	01 45 0c             	add    %eax,0xc(%ebp)
801022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ae:	3b 45 14             	cmp    0x14(%ebp),%eax
801022b1:	0f 82 55 ff ff ff    	jb     8010220c <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801022b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022bb:	74 1f                	je     801022dc <writei+0x18a>
801022bd:	8b 45 08             	mov    0x8(%ebp),%eax
801022c0:	8b 40 58             	mov    0x58(%eax),%eax
801022c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801022c6:	73 14                	jae    801022dc <writei+0x18a>
    ip->size = off;
801022c8:	8b 45 08             	mov    0x8(%ebp),%eax
801022cb:	8b 55 10             	mov    0x10(%ebp),%edx
801022ce:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801022d1:	8b 45 08             	mov    0x8(%ebp),%eax
801022d4:	89 04 24             	mov    %eax,(%esp)
801022d7:	e8 d1 f4 ff ff       	call   801017ad <iupdate>
  }
  return n;
801022dc:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022df:	c9                   	leave  
801022e0:	c3                   	ret    

801022e1 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801022e1:	55                   	push   %ebp
801022e2:	89 e5                	mov    %esp,%ebp
801022e4:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801022e7:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022ee:	00 
801022ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801022f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f6:	8b 45 08             	mov    0x8(%ebp),%eax
801022f9:	89 04 24             	mov    %eax,(%esp)
801022fc:	e8 e0 42 00 00       	call   801065e1 <strncmp>
}
80102301:	c9                   	leave  
80102302:	c3                   	ret    

80102303 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102303:	55                   	push   %ebp
80102304:	89 e5                	mov    %esp,%ebp
80102306:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102309:	8b 45 08             	mov    0x8(%ebp),%eax
8010230c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102310:	66 83 f8 01          	cmp    $0x1,%ax
80102314:	74 0c                	je     80102322 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102316:	c7 04 24 91 9c 10 80 	movl   $0x80109c91,(%esp)
8010231d:	e8 40 e2 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102329:	e9 88 00 00 00       	jmp    801023b6 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010232e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102335:	00 
80102336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102339:	89 44 24 08          	mov    %eax,0x8(%esp)
8010233d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102340:	89 44 24 04          	mov    %eax,0x4(%esp)
80102344:	8b 45 08             	mov    0x8(%ebp),%eax
80102347:	89 04 24             	mov    %eax,(%esp)
8010234a:	e8 9f fc ff ff       	call   80101fee <readi>
8010234f:	83 f8 10             	cmp    $0x10,%eax
80102352:	74 0c                	je     80102360 <dirlookup+0x5d>
      panic("dirlink read");
80102354:	c7 04 24 a3 9c 10 80 	movl   $0x80109ca3,(%esp)
8010235b:	e8 02 e2 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102360:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102364:	66 85 c0             	test   %ax,%ax
80102367:	75 02                	jne    8010236b <dirlookup+0x68>
      continue;
80102369:	eb 47                	jmp    801023b2 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
8010236b:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010236e:	83 c0 02             	add    $0x2,%eax
80102371:	89 44 24 04          	mov    %eax,0x4(%esp)
80102375:	8b 45 0c             	mov    0xc(%ebp),%eax
80102378:	89 04 24             	mov    %eax,(%esp)
8010237b:	e8 61 ff ff ff       	call   801022e1 <namecmp>
80102380:	85 c0                	test   %eax,%eax
80102382:	75 2e                	jne    801023b2 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102384:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102388:	74 08                	je     80102392 <dirlookup+0x8f>
        *poff = off;
8010238a:	8b 45 10             	mov    0x10(%ebp),%eax
8010238d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102390:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102392:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102396:	0f b7 c0             	movzwl %ax,%eax
80102399:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010239c:	8b 45 08             	mov    0x8(%ebp),%eax
8010239f:	8b 00                	mov    (%eax),%eax
801023a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801023a8:	89 04 24             	mov    %eax,(%esp)
801023ab:	e8 bb f4 ff ff       	call   8010186b <iget>
801023b0:	eb 18                	jmp    801023ca <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801023b2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023b6:	8b 45 08             	mov    0x8(%ebp),%eax
801023b9:	8b 40 58             	mov    0x58(%eax),%eax
801023bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801023bf:	0f 87 69 ff ff ff    	ja     8010232e <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801023c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023ca:	c9                   	leave  
801023cb:	c3                   	ret    

801023cc <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023cc:	55                   	push   %ebp
801023cd:	89 e5                	mov    %esp,%ebp
801023cf:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023d9:	00 
801023da:	8b 45 0c             	mov    0xc(%ebp),%eax
801023dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801023e1:	8b 45 08             	mov    0x8(%ebp),%eax
801023e4:	89 04 24             	mov    %eax,(%esp)
801023e7:	e8 17 ff ff ff       	call   80102303 <dirlookup>
801023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023f3:	74 15                	je     8010240a <dirlink+0x3e>
    iput(ip);
801023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023f8:	89 04 24             	mov    %eax,(%esp)
801023fb:	e8 cd f6 ff ff       	call   80101acd <iput>
    return -1;
80102400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102405:	e9 b7 00 00 00       	jmp    801024c1 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010240a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102411:	eb 46                	jmp    80102459 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102416:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010241d:	00 
8010241e:	89 44 24 08          	mov    %eax,0x8(%esp)
80102422:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102425:	89 44 24 04          	mov    %eax,0x4(%esp)
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 04 24             	mov    %eax,(%esp)
8010242f:	e8 ba fb ff ff       	call   80101fee <readi>
80102434:	83 f8 10             	cmp    $0x10,%eax
80102437:	74 0c                	je     80102445 <dirlink+0x79>
      panic("dirlink read");
80102439:	c7 04 24 a3 9c 10 80 	movl   $0x80109ca3,(%esp)
80102440:	e8 1d e1 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102445:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102449:	66 85 c0             	test   %ax,%ax
8010244c:	75 02                	jne    80102450 <dirlink+0x84>
      break;
8010244e:	eb 16                	jmp    80102466 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102453:	83 c0 10             	add    $0x10,%eax
80102456:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102459:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010245c:	8b 45 08             	mov    0x8(%ebp),%eax
8010245f:	8b 40 58             	mov    0x58(%eax),%eax
80102462:	39 c2                	cmp    %eax,%edx
80102464:	72 ad                	jb     80102413 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80102466:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010246d:	00 
8010246e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102471:	89 44 24 04          	mov    %eax,0x4(%esp)
80102475:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102478:	83 c0 02             	add    $0x2,%eax
8010247b:	89 04 24             	mov    %eax,(%esp)
8010247e:	e8 b4 41 00 00       	call   80106637 <strncpy>
  de.inum = inum;
80102483:	8b 45 10             	mov    0x10(%ebp),%eax
80102486:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010248d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102494:	00 
80102495:	89 44 24 08          	mov    %eax,0x8(%esp)
80102499:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010249c:	89 44 24 04          	mov    %eax,0x4(%esp)
801024a0:	8b 45 08             	mov    0x8(%ebp),%eax
801024a3:	89 04 24             	mov    %eax,(%esp)
801024a6:	e8 a7 fc ff ff       	call   80102152 <writei>
801024ab:	83 f8 10             	cmp    $0x10,%eax
801024ae:	74 0c                	je     801024bc <dirlink+0xf0>
    panic("dirlink");
801024b0:	c7 04 24 b0 9c 10 80 	movl   $0x80109cb0,(%esp)
801024b7:	e8 a6 e0 ff ff       	call   80100562 <panic>

  return 0;
801024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024c1:	c9                   	leave  
801024c2:	c3                   	ret    

801024c3 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024c3:	55                   	push   %ebp
801024c4:	89 e5                	mov    %esp,%ebp
801024c6:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801024c9:	eb 04                	jmp    801024cf <skipelem+0xc>
    path++;
801024cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801024cf:	8b 45 08             	mov    0x8(%ebp),%eax
801024d2:	0f b6 00             	movzbl (%eax),%eax
801024d5:	3c 2f                	cmp    $0x2f,%al
801024d7:	74 f2                	je     801024cb <skipelem+0x8>
    path++;
  if(*path == 0)
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
801024dc:	0f b6 00             	movzbl (%eax),%eax
801024df:	84 c0                	test   %al,%al
801024e1:	75 0a                	jne    801024ed <skipelem+0x2a>
    return 0;
801024e3:	b8 00 00 00 00       	mov    $0x0,%eax
801024e8:	e9 86 00 00 00       	jmp    80102573 <skipelem+0xb0>
  s = path;
801024ed:	8b 45 08             	mov    0x8(%ebp),%eax
801024f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024f3:	eb 04                	jmp    801024f9 <skipelem+0x36>
    path++;
801024f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024f9:	8b 45 08             	mov    0x8(%ebp),%eax
801024fc:	0f b6 00             	movzbl (%eax),%eax
801024ff:	3c 2f                	cmp    $0x2f,%al
80102501:	74 0a                	je     8010250d <skipelem+0x4a>
80102503:	8b 45 08             	mov    0x8(%ebp),%eax
80102506:	0f b6 00             	movzbl (%eax),%eax
80102509:	84 c0                	test   %al,%al
8010250b:	75 e8                	jne    801024f5 <skipelem+0x32>
    path++;
  len = path - s;
8010250d:	8b 55 08             	mov    0x8(%ebp),%edx
80102510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102513:	29 c2                	sub    %eax,%edx
80102515:	89 d0                	mov    %edx,%eax
80102517:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010251a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010251e:	7e 1c                	jle    8010253c <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102520:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102527:	00 
80102528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010252b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010252f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102532:	89 04 24             	mov    %eax,(%esp)
80102535:	e8 04 40 00 00       	call   8010653e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010253a:	eb 2a                	jmp    80102566 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
8010253c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010253f:	89 44 24 08          	mov    %eax,0x8(%esp)
80102543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102546:	89 44 24 04          	mov    %eax,0x4(%esp)
8010254a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010254d:	89 04 24             	mov    %eax,(%esp)
80102550:	e8 e9 3f 00 00       	call   8010653e <memmove>
    name[len] = 0;
80102555:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102558:	8b 45 0c             	mov    0xc(%ebp),%eax
8010255b:	01 d0                	add    %edx,%eax
8010255d:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102560:	eb 04                	jmp    80102566 <skipelem+0xa3>
    path++;
80102562:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102566:	8b 45 08             	mov    0x8(%ebp),%eax
80102569:	0f b6 00             	movzbl (%eax),%eax
8010256c:	3c 2f                	cmp    $0x2f,%al
8010256e:	74 f2                	je     80102562 <skipelem+0x9f>
    path++;
  return path;
80102570:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102573:	c9                   	leave  
80102574:	c3                   	ret    

80102575 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102575:	55                   	push   %ebp
80102576:	89 e5                	mov    %esp,%ebp
80102578:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010257b:	8b 45 08             	mov    0x8(%ebp),%eax
8010257e:	0f b6 00             	movzbl (%eax),%eax
80102581:	3c 2f                	cmp    $0x2f,%al
80102583:	75 1c                	jne    801025a1 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102585:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010258c:	00 
8010258d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102594:	e8 d2 f2 ff ff       	call   8010186b <iget>
80102599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010259c:	e9 af 00 00 00       	jmp    80102650 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
801025a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801025a7:	8b 40 68             	mov    0x68(%eax),%eax
801025aa:	89 04 24             	mov    %eax,(%esp)
801025ad:	e8 8e f3 ff ff       	call   80101940 <idup>
801025b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801025b5:	e9 96 00 00 00       	jmp    80102650 <namex+0xdb>
    ilock(ip);
801025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025bd:	89 04 24             	mov    %eax,(%esp)
801025c0:	e8 ad f3 ff ff       	call   80101972 <ilock>
    if(ip->type != T_DIR){
801025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025c8:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801025cc:	66 83 f8 01          	cmp    $0x1,%ax
801025d0:	74 15                	je     801025e7 <namex+0x72>
      iunlockput(ip);
801025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025d5:	89 04 24             	mov    %eax,(%esp)
801025d8:	e8 84 f5 ff ff       	call   80101b61 <iunlockput>
      return 0;
801025dd:	b8 00 00 00 00       	mov    $0x0,%eax
801025e2:	e9 a3 00 00 00       	jmp    8010268a <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
801025e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025eb:	74 1d                	je     8010260a <namex+0x95>
801025ed:	8b 45 08             	mov    0x8(%ebp),%eax
801025f0:	0f b6 00             	movzbl (%eax),%eax
801025f3:	84 c0                	test   %al,%al
801025f5:	75 13                	jne    8010260a <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025fa:	89 04 24             	mov    %eax,(%esp)
801025fd:	e8 87 f4 ff ff       	call   80101a89 <iunlock>
      return ip;
80102602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102605:	e9 80 00 00 00       	jmp    8010268a <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010260a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102611:	00 
80102612:	8b 45 10             	mov    0x10(%ebp),%eax
80102615:	89 44 24 04          	mov    %eax,0x4(%esp)
80102619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010261c:	89 04 24             	mov    %eax,(%esp)
8010261f:	e8 df fc ff ff       	call   80102303 <dirlookup>
80102624:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010262b:	75 12                	jne    8010263f <namex+0xca>
      iunlockput(ip);
8010262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102630:	89 04 24             	mov    %eax,(%esp)
80102633:	e8 29 f5 ff ff       	call   80101b61 <iunlockput>
      return 0;
80102638:	b8 00 00 00 00       	mov    $0x0,%eax
8010263d:	eb 4b                	jmp    8010268a <namex+0x115>
    }
    iunlockput(ip);
8010263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102642:	89 04 24             	mov    %eax,(%esp)
80102645:	e8 17 f5 ff ff       	call   80101b61 <iunlockput>
    ip = next;
8010264a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102650:	8b 45 10             	mov    0x10(%ebp),%eax
80102653:	89 44 24 04          	mov    %eax,0x4(%esp)
80102657:	8b 45 08             	mov    0x8(%ebp),%eax
8010265a:	89 04 24             	mov    %eax,(%esp)
8010265d:	e8 61 fe ff ff       	call   801024c3 <skipelem>
80102662:	89 45 08             	mov    %eax,0x8(%ebp)
80102665:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102669:	0f 85 4b ff ff ff    	jne    801025ba <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010266f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102673:	74 12                	je     80102687 <namex+0x112>
    iput(ip);
80102675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102678:	89 04 24             	mov    %eax,(%esp)
8010267b:	e8 4d f4 ff ff       	call   80101acd <iput>
    return 0;
80102680:	b8 00 00 00 00       	mov    $0x0,%eax
80102685:	eb 03                	jmp    8010268a <namex+0x115>
  }
  return ip;
80102687:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010268a:	c9                   	leave  
8010268b:	c3                   	ret    

8010268c <namei>:

struct inode*
namei(char *path)
{
8010268c:	55                   	push   %ebp
8010268d:	89 e5                	mov    %esp,%ebp
8010268f:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102692:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102695:	89 44 24 08          	mov    %eax,0x8(%esp)
80102699:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026a0:	00 
801026a1:	8b 45 08             	mov    0x8(%ebp),%eax
801026a4:	89 04 24             	mov    %eax,(%esp)
801026a7:	e8 c9 fe ff ff       	call   80102575 <namex>
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    

801026ae <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801026ae:	55                   	push   %ebp
801026af:	89 e5                	mov    %esp,%ebp
801026b1:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801026b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801026b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801026bb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801026c2:	00 
801026c3:	8b 45 08             	mov    0x8(%ebp),%eax
801026c6:	89 04 24             	mov    %eax,(%esp)
801026c9:	e8 a7 fe ff ff       	call   80102575 <namex>
}
801026ce:	c9                   	leave  
801026cf:	c3                   	ret    

801026d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	83 ec 14             	sub    $0x14,%esp
801026d6:	8b 45 08             	mov    0x8(%ebp),%eax
801026d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801026e1:	89 c2                	mov    %eax,%edx
801026e3:	ec                   	in     (%dx),%al
801026e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801026e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801026eb:	c9                   	leave  
801026ec:	c3                   	ret    

801026ed <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801026ed:	55                   	push   %ebp
801026ee:	89 e5                	mov    %esp,%ebp
801026f0:	57                   	push   %edi
801026f1:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801026f2:	8b 55 08             	mov    0x8(%ebp),%edx
801026f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801026f8:	8b 45 10             	mov    0x10(%ebp),%eax
801026fb:	89 cb                	mov    %ecx,%ebx
801026fd:	89 df                	mov    %ebx,%edi
801026ff:	89 c1                	mov    %eax,%ecx
80102701:	fc                   	cld    
80102702:	f3 6d                	rep insl (%dx),%es:(%edi)
80102704:	89 c8                	mov    %ecx,%eax
80102706:	89 fb                	mov    %edi,%ebx
80102708:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010270b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010270e:	5b                   	pop    %ebx
8010270f:	5f                   	pop    %edi
80102710:	5d                   	pop    %ebp
80102711:	c3                   	ret    

80102712 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102712:	55                   	push   %ebp
80102713:	89 e5                	mov    %esp,%ebp
80102715:	83 ec 08             	sub    $0x8,%esp
80102718:	8b 55 08             	mov    0x8(%ebp),%edx
8010271b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010271e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102722:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102725:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102729:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010272d:	ee                   	out    %al,(%dx)
}
8010272e:	c9                   	leave  
8010272f:	c3                   	ret    

80102730 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	56                   	push   %esi
80102734:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102735:	8b 55 08             	mov    0x8(%ebp),%edx
80102738:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010273b:	8b 45 10             	mov    0x10(%ebp),%eax
8010273e:	89 cb                	mov    %ecx,%ebx
80102740:	89 de                	mov    %ebx,%esi
80102742:	89 c1                	mov    %eax,%ecx
80102744:	fc                   	cld    
80102745:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102747:	89 c8                	mov    %ecx,%eax
80102749:	89 f3                	mov    %esi,%ebx
8010274b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010274e:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102751:	5b                   	pop    %ebx
80102752:	5e                   	pop    %esi
80102753:	5d                   	pop    %ebp
80102754:	c3                   	ret    

80102755 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
80102758:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010275b:	90                   	nop
8010275c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102763:	e8 68 ff ff ff       	call   801026d0 <inb>
80102768:	0f b6 c0             	movzbl %al,%eax
8010276b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010276e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102771:	25 c0 00 00 00       	and    $0xc0,%eax
80102776:	83 f8 40             	cmp    $0x40,%eax
80102779:	75 e1                	jne    8010275c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010277b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010277f:	74 11                	je     80102792 <idewait+0x3d>
80102781:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102784:	83 e0 21             	and    $0x21,%eax
80102787:	85 c0                	test   %eax,%eax
80102789:	74 07                	je     80102792 <idewait+0x3d>
    return -1;
8010278b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102790:	eb 05                	jmp    80102797 <idewait+0x42>
  return 0;
80102792:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102797:	c9                   	leave  
80102798:	c3                   	ret    

80102799 <ideinit>:

void
ideinit(void)
{
80102799:	55                   	push   %ebp
8010279a:	89 e5                	mov    %esp,%ebp
8010279c:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010279f:	c7 44 24 04 b8 9c 10 	movl   $0x80109cb8,0x4(%esp)
801027a6:	80 
801027a7:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
801027ae:	e8 32 3a 00 00       	call   801061e5 <initlock>
  picenable(IRQ_IDE);
801027b3:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801027ba:	e8 1e 18 00 00       	call   80103fdd <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801027bf:	a1 20 5e 11 80       	mov    0x80115e20,%eax
801027c4:	83 e8 01             	sub    $0x1,%eax
801027c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801027cb:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801027d2:	e8 77 04 00 00       	call   80102c4e <ioapicenable>
  idewait(0);
801027d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801027de:	e8 72 ff ff ff       	call   80102755 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801027e3:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801027ea:	00 
801027eb:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027f2:	e8 1b ff ff ff       	call   80102712 <outb>
  for(i=0; i<1000; i++){
801027f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801027fe:	eb 20                	jmp    80102820 <ideinit+0x87>
    if(inb(0x1f7) != 0){
80102800:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102807:	e8 c4 fe ff ff       	call   801026d0 <inb>
8010280c:	84 c0                	test   %al,%al
8010280e:	74 0c                	je     8010281c <ideinit+0x83>
      havedisk1 = 1;
80102810:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
80102817:	00 00 00 
      break;
8010281a:	eb 0d                	jmp    80102829 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010281c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102820:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102827:	7e d7                	jle    80102800 <ideinit+0x67>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102829:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102830:	00 
80102831:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102838:	e8 d5 fe ff ff       	call   80102712 <outb>
}
8010283d:	c9                   	leave  
8010283e:	c3                   	ret    

8010283f <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010283f:	55                   	push   %ebp
80102840:	89 e5                	mov    %esp,%ebp
80102842:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102845:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102849:	75 0c                	jne    80102857 <idestart+0x18>
    panic("idestart");
8010284b:	c7 04 24 bc 9c 10 80 	movl   $0x80109cbc,(%esp)
80102852:	e8 0b dd ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
80102857:	8b 45 08             	mov    0x8(%ebp),%eax
8010285a:	8b 40 08             	mov    0x8(%eax),%eax
8010285d:	3d d7 40 00 00       	cmp    $0x40d7,%eax
80102862:	76 0c                	jbe    80102870 <idestart+0x31>
    panic("incorrect blockno");
80102864:	c7 04 24 c5 9c 10 80 	movl   $0x80109cc5,(%esp)
8010286b:	e8 f2 dc ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102870:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102877:	8b 45 08             	mov    0x8(%ebp),%eax
8010287a:	8b 50 08             	mov    0x8(%eax),%edx
8010287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102880:	0f af c2             	imul   %edx,%eax
80102883:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102886:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010288a:	75 07                	jne    80102893 <idestart+0x54>
8010288c:	b8 20 00 00 00       	mov    $0x20,%eax
80102891:	eb 05                	jmp    80102898 <idestart+0x59>
80102893:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102898:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010289b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010289f:	75 07                	jne    801028a8 <idestart+0x69>
801028a1:	b8 30 00 00 00       	mov    $0x30,%eax
801028a6:	eb 05                	jmp    801028ad <idestart+0x6e>
801028a8:	b8 c5 00 00 00       	mov    $0xc5,%eax
801028ad:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801028b0:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801028b4:	7e 0c                	jle    801028c2 <idestart+0x83>
801028b6:	c7 04 24 bc 9c 10 80 	movl   $0x80109cbc,(%esp)
801028bd:	e8 a0 dc ff ff       	call   80100562 <panic>

  idewait(0);
801028c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028c9:	e8 87 fe ff ff       	call   80102755 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801028ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801028d5:	00 
801028d6:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801028dd:	e8 30 fe ff ff       	call   80102712 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e5:	0f b6 c0             	movzbl %al,%eax
801028e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801028ec:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801028f3:	e8 1a fe ff ff       	call   80102712 <outb>
  outb(0x1f3, sector & 0xff);
801028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801028fb:	0f b6 c0             	movzbl %al,%eax
801028fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102902:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102909:	e8 04 fe ff ff       	call   80102712 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102911:	c1 f8 08             	sar    $0x8,%eax
80102914:	0f b6 c0             	movzbl %al,%eax
80102917:	89 44 24 04          	mov    %eax,0x4(%esp)
8010291b:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102922:	e8 eb fd ff ff       	call   80102712 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102927:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010292a:	c1 f8 10             	sar    $0x10,%eax
8010292d:	0f b6 c0             	movzbl %al,%eax
80102930:	89 44 24 04          	mov    %eax,0x4(%esp)
80102934:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010293b:	e8 d2 fd ff ff       	call   80102712 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102940:	8b 45 08             	mov    0x8(%ebp),%eax
80102943:	8b 40 04             	mov    0x4(%eax),%eax
80102946:	83 e0 01             	and    $0x1,%eax
80102949:	c1 e0 04             	shl    $0x4,%eax
8010294c:	89 c2                	mov    %eax,%edx
8010294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102951:	c1 f8 18             	sar    $0x18,%eax
80102954:	83 e0 0f             	and    $0xf,%eax
80102957:	09 d0                	or     %edx,%eax
80102959:	83 c8 e0             	or     $0xffffffe0,%eax
8010295c:	0f b6 c0             	movzbl %al,%eax
8010295f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102963:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010296a:	e8 a3 fd ff ff       	call   80102712 <outb>
  if(b->flags & B_DIRTY){
8010296f:	8b 45 08             	mov    0x8(%ebp),%eax
80102972:	8b 00                	mov    (%eax),%eax
80102974:	83 e0 04             	and    $0x4,%eax
80102977:	85 c0                	test   %eax,%eax
80102979:	74 36                	je     801029b1 <idestart+0x172>
    outb(0x1f7, write_cmd);
8010297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010297e:	0f b6 c0             	movzbl %al,%eax
80102981:	89 44 24 04          	mov    %eax,0x4(%esp)
80102985:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010298c:	e8 81 fd ff ff       	call   80102712 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102991:	8b 45 08             	mov    0x8(%ebp),%eax
80102994:	83 c0 5c             	add    $0x5c,%eax
80102997:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010299e:	00 
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801029aa:	e8 81 fd ff ff       	call   80102730 <outsl>
801029af:	eb 16                	jmp    801029c7 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
801029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801029b4:	0f b6 c0             	movzbl %al,%eax
801029b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029bb:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801029c2:	e8 4b fd ff ff       	call   80102712 <outb>
  }
}
801029c7:	c9                   	leave  
801029c8:	c3                   	ret    

801029c9 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801029c9:	55                   	push   %ebp
801029ca:	89 e5                	mov    %esp,%ebp
801029cc:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801029cf:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
801029d6:	e8 2b 38 00 00       	call   80106206 <acquire>
  if((b = idequeue) == 0){
801029db:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801029e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029e7:	75 11                	jne    801029fa <ideintr+0x31>
    release(&idelock);
801029e9:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
801029f0:	e8 78 38 00 00       	call   8010626d <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801029f5:	e9 90 00 00 00       	jmp    80102a8a <ideintr+0xc1>
  }
  idequeue = b->qnext;
801029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fd:	8b 40 58             	mov    0x58(%eax),%eax
80102a00:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a08:	8b 00                	mov    (%eax),%eax
80102a0a:	83 e0 04             	and    $0x4,%eax
80102a0d:	85 c0                	test   %eax,%eax
80102a0f:	75 2e                	jne    80102a3f <ideintr+0x76>
80102a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a18:	e8 38 fd ff ff       	call   80102755 <idewait>
80102a1d:	85 c0                	test   %eax,%eax
80102a1f:	78 1e                	js     80102a3f <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a24:	83 c0 5c             	add    $0x5c,%eax
80102a27:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102a2e:	00 
80102a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a33:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102a3a:	e8 ae fc ff ff       	call   801026ed <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a42:	8b 00                	mov    (%eax),%eax
80102a44:	83 c8 02             	or     $0x2,%eax
80102a47:	89 c2                	mov    %eax,%edx
80102a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4c:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a51:	8b 00                	mov    (%eax),%eax
80102a53:	83 e0 fb             	and    $0xfffffffb,%eax
80102a56:	89 c2                	mov    %eax,%edx
80102a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5b:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a60:	89 04 24             	mov    %eax,(%esp)
80102a63:	e8 a8 2e 00 00       	call   80105910 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102a68:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a6d:	85 c0                	test   %eax,%eax
80102a6f:	74 0d                	je     80102a7e <ideintr+0xb5>
    idestart(idequeue);
80102a71:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a76:	89 04 24             	mov    %eax,(%esp)
80102a79:	e8 c1 fd ff ff       	call   8010283f <idestart>

  release(&idelock);
80102a7e:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80102a85:	e8 e3 37 00 00       	call   8010626d <release>
}
80102a8a:	c9                   	leave  
80102a8b:	c3                   	ret    

80102a8c <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102a8c:	55                   	push   %ebp
80102a8d:	89 e5                	mov    %esp,%ebp
80102a8f:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102a92:	8b 45 08             	mov    0x8(%ebp),%eax
80102a95:	83 c0 0c             	add    $0xc,%eax
80102a98:	89 04 24             	mov    %eax,(%esp)
80102a9b:	e8 e0 36 00 00       	call   80106180 <holdingsleep>
80102aa0:	85 c0                	test   %eax,%eax
80102aa2:	75 0c                	jne    80102ab0 <iderw+0x24>
    panic("iderw: buf not locked");
80102aa4:	c7 04 24 d7 9c 10 80 	movl   $0x80109cd7,(%esp)
80102aab:	e8 b2 da ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab3:	8b 00                	mov    (%eax),%eax
80102ab5:	83 e0 06             	and    $0x6,%eax
80102ab8:	83 f8 02             	cmp    $0x2,%eax
80102abb:	75 0c                	jne    80102ac9 <iderw+0x3d>
    panic("iderw: nothing to do");
80102abd:	c7 04 24 ed 9c 10 80 	movl   $0x80109ced,(%esp)
80102ac4:	e8 99 da ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
80102ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80102acc:	8b 40 04             	mov    0x4(%eax),%eax
80102acf:	85 c0                	test   %eax,%eax
80102ad1:	74 15                	je     80102ae8 <iderw+0x5c>
80102ad3:	a1 58 d6 10 80       	mov    0x8010d658,%eax
80102ad8:	85 c0                	test   %eax,%eax
80102ada:	75 0c                	jne    80102ae8 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102adc:	c7 04 24 02 9d 10 80 	movl   $0x80109d02,(%esp)
80102ae3:	e8 7a da ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102ae8:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80102aef:	e8 12 37 00 00       	call   80106206 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102af4:	8b 45 08             	mov    0x8(%ebp),%eax
80102af7:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102afe:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102b05:	eb 0b                	jmp    80102b12 <iderw+0x86>
80102b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b0a:	8b 00                	mov    (%eax),%eax
80102b0c:	83 c0 58             	add    $0x58,%eax
80102b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b15:	8b 00                	mov    (%eax),%eax
80102b17:	85 c0                	test   %eax,%eax
80102b19:	75 ec                	jne    80102b07 <iderw+0x7b>
    ;
  *pp = b;
80102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1e:	8b 55 08             	mov    0x8(%ebp),%edx
80102b21:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102b23:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102b28:	3b 45 08             	cmp    0x8(%ebp),%eax
80102b2b:	75 0d                	jne    80102b3a <iderw+0xae>
    idestart(b);
80102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b30:	89 04 24             	mov    %eax,(%esp)
80102b33:	e8 07 fd ff ff       	call   8010283f <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b38:	eb 15                	jmp    80102b4f <iderw+0xc3>
80102b3a:	eb 13                	jmp    80102b4f <iderw+0xc3>
    sleep(b, &idelock);
80102b3c:	c7 44 24 04 20 d6 10 	movl   $0x8010d620,0x4(%esp)
80102b43:	80 
80102b44:	8b 45 08             	mov    0x8(%ebp),%eax
80102b47:	89 04 24             	mov    %eax,(%esp)
80102b4a:	e8 b7 2c 00 00       	call   80105806 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b52:	8b 00                	mov    (%eax),%eax
80102b54:	83 e0 06             	and    $0x6,%eax
80102b57:	83 f8 02             	cmp    $0x2,%eax
80102b5a:	75 e0                	jne    80102b3c <iderw+0xb0>
    sleep(b, &idelock);
  }

  release(&idelock);
80102b5c:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80102b63:	e8 05 37 00 00       	call   8010626d <release>
}
80102b68:	c9                   	leave  
80102b69:	c3                   	ret    

80102b6a <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102b6a:	55                   	push   %ebp
80102b6b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b6d:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102b72:	8b 55 08             	mov    0x8(%ebp),%edx
80102b75:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102b77:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102b7c:	8b 40 10             	mov    0x10(%eax),%eax
}
80102b7f:	5d                   	pop    %ebp
80102b80:	c3                   	ret    

80102b81 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102b81:	55                   	push   %ebp
80102b82:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102b84:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102b89:	8b 55 08             	mov    0x8(%ebp),%edx
80102b8c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102b8e:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102b93:	8b 55 0c             	mov    0xc(%ebp),%edx
80102b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b99:	5d                   	pop    %ebp
80102b9a:	c3                   	ret    

80102b9b <ioapicinit>:

void
ioapicinit(void)
{
80102b9b:	55                   	push   %ebp
80102b9c:	89 e5                	mov    %esp,%ebp
80102b9e:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102ba1:	a1 24 58 11 80       	mov    0x80115824,%eax
80102ba6:	85 c0                	test   %eax,%eax
80102ba8:	75 05                	jne    80102baf <ioapicinit+0x14>
    return;
80102baa:	e9 9d 00 00 00       	jmp    80102c4c <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102baf:	c7 05 f4 56 11 80 00 	movl   $0xfec00000,0x801156f4
80102bb6:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102bb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102bc0:	e8 a5 ff ff ff       	call   80102b6a <ioapicread>
80102bc5:	c1 e8 10             	shr    $0x10,%eax
80102bc8:	25 ff 00 00 00       	and    $0xff,%eax
80102bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102bd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102bd7:	e8 8e ff ff ff       	call   80102b6a <ioapicread>
80102bdc:	c1 e8 18             	shr    $0x18,%eax
80102bdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102be2:	0f b6 05 20 58 11 80 	movzbl 0x80115820,%eax
80102be9:	0f b6 c0             	movzbl %al,%eax
80102bec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102bef:	74 0c                	je     80102bfd <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102bf1:	c7 04 24 20 9d 10 80 	movl   $0x80109d20,(%esp)
80102bf8:	e8 cb d7 ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102bfd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102c04:	eb 3e                	jmp    80102c44 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c09:	83 c0 20             	add    $0x20,%eax
80102c0c:	0d 00 00 01 00       	or     $0x10000,%eax
80102c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102c14:	83 c2 08             	add    $0x8,%edx
80102c17:	01 d2                	add    %edx,%edx
80102c19:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1d:	89 14 24             	mov    %edx,(%esp)
80102c20:	e8 5c ff ff ff       	call   80102b81 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c28:	83 c0 08             	add    $0x8,%eax
80102c2b:	01 c0                	add    %eax,%eax
80102c2d:	83 c0 01             	add    $0x1,%eax
80102c30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102c37:	00 
80102c38:	89 04 24             	mov    %eax,(%esp)
80102c3b:	e8 41 ff ff ff       	call   80102b81 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102c40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c47:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102c4a:	7e ba                	jle    80102c06 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102c4c:	c9                   	leave  
80102c4d:	c3                   	ret    

80102c4e <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102c4e:	55                   	push   %ebp
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102c54:	a1 24 58 11 80       	mov    0x80115824,%eax
80102c59:	85 c0                	test   %eax,%eax
80102c5b:	75 02                	jne    80102c5f <ioapicenable+0x11>
    return;
80102c5d:	eb 37                	jmp    80102c96 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c62:	83 c0 20             	add    $0x20,%eax
80102c65:	8b 55 08             	mov    0x8(%ebp),%edx
80102c68:	83 c2 08             	add    $0x8,%edx
80102c6b:	01 d2                	add    %edx,%edx
80102c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c71:	89 14 24             	mov    %edx,(%esp)
80102c74:	e8 08 ff ff ff       	call   80102b81 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80102c7c:	c1 e0 18             	shl    $0x18,%eax
80102c7f:	8b 55 08             	mov    0x8(%ebp),%edx
80102c82:	83 c2 08             	add    $0x8,%edx
80102c85:	01 d2                	add    %edx,%edx
80102c87:	83 c2 01             	add    $0x1,%edx
80102c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c8e:	89 14 24             	mov    %edx,(%esp)
80102c91:	e8 eb fe ff ff       	call   80102b81 <ioapicwrite>
}
80102c96:	c9                   	leave  
80102c97:	c3                   	ret    

80102c98 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102c98:	55                   	push   %ebp
80102c99:	89 e5                	mov    %esp,%ebp
80102c9b:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102c9e:	c7 44 24 04 52 9d 10 	movl   $0x80109d52,0x4(%esp)
80102ca5:	80 
80102ca6:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102cad:	e8 33 35 00 00       	call   801061e5 <initlock>
  kmem.use_lock = 0;
80102cb2:	c7 05 34 57 11 80 00 	movl   $0x0,0x80115734
80102cb9:	00 00 00 
  freerange(vstart, vend);
80102cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102cc6:	89 04 24             	mov    %eax,(%esp)
80102cc9:	e8 26 00 00 00       	call   80102cf4 <freerange>
}
80102cce:	c9                   	leave  
80102ccf:	c3                   	ret    

80102cd0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce0:	89 04 24             	mov    %eax,(%esp)
80102ce3:	e8 0c 00 00 00       	call   80102cf4 <freerange>
  kmem.use_lock = 1;
80102ce8:	c7 05 34 57 11 80 01 	movl   $0x1,0x80115734
80102cef:	00 00 00 
}
80102cf2:	c9                   	leave  
80102cf3:	c3                   	ret    

80102cf4 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80102cfd:	05 ff 0f 00 00       	add    $0xfff,%eax
80102d02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d0a:	eb 12                	jmp    80102d1e <freerange+0x2a>
    kfree(p);
80102d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d0f:	89 04 24             	mov    %eax,(%esp)
80102d12:	e8 16 00 00 00       	call   80102d2d <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d17:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d21:	05 00 10 00 00       	add    $0x1000,%eax
80102d26:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102d29:	76 e1                	jbe    80102d0c <freerange+0x18>
    kfree(p);
}
80102d2b:	c9                   	leave  
80102d2c:	c3                   	ret    

80102d2d <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102d2d:	55                   	push   %ebp
80102d2e:	89 e5                	mov    %esp,%ebp
80102d30:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102d33:	8b 45 08             	mov    0x8(%ebp),%eax
80102d36:	25 ff 0f 00 00       	and    $0xfff,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	75 18                	jne    80102d57 <kfree+0x2a>
80102d3f:	81 7d 08 28 d3 11 80 	cmpl   $0x8011d328,0x8(%ebp)
80102d46:	72 0f                	jb     80102d57 <kfree+0x2a>
80102d48:	8b 45 08             	mov    0x8(%ebp),%eax
80102d4b:	05 00 00 00 80       	add    $0x80000000,%eax
80102d50:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102d55:	76 0c                	jbe    80102d63 <kfree+0x36>
    panic("kfree");
80102d57:	c7 04 24 57 9d 10 80 	movl   $0x80109d57,(%esp)
80102d5e:	e8 ff d7 ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102d63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102d6a:	00 
80102d6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102d72:	00 
80102d73:	8b 45 08             	mov    0x8(%ebp),%eax
80102d76:	89 04 24             	mov    %eax,(%esp)
80102d79:	e8 f1 36 00 00       	call   8010646f <memset>

  if(kmem.use_lock)
80102d7e:	a1 34 57 11 80       	mov    0x80115734,%eax
80102d83:	85 c0                	test   %eax,%eax
80102d85:	74 0c                	je     80102d93 <kfree+0x66>
    acquire(&kmem.lock);
80102d87:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102d8e:	e8 73 34 00 00       	call   80106206 <acquire>
  r = (struct run*)v;
80102d93:	8b 45 08             	mov    0x8(%ebp),%eax
80102d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102d99:	8b 15 38 57 11 80    	mov    0x80115738,%edx
80102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da2:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da7:	a3 38 57 11 80       	mov    %eax,0x80115738
  if(kmem.use_lock)
80102dac:	a1 34 57 11 80       	mov    0x80115734,%eax
80102db1:	85 c0                	test   %eax,%eax
80102db3:	74 0c                	je     80102dc1 <kfree+0x94>
    release(&kmem.lock);
80102db5:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102dbc:	e8 ac 34 00 00       	call   8010626d <release>
}
80102dc1:	c9                   	leave  
80102dc2:	c3                   	ret    

80102dc3 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102dc3:	55                   	push   %ebp
80102dc4:	89 e5                	mov    %esp,%ebp
80102dc6:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102dc9:	a1 34 57 11 80       	mov    0x80115734,%eax
80102dce:	85 c0                	test   %eax,%eax
80102dd0:	74 0c                	je     80102dde <kalloc+0x1b>
    acquire(&kmem.lock);
80102dd2:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102dd9:	e8 28 34 00 00       	call   80106206 <acquire>
  r = kmem.freelist;
80102dde:	a1 38 57 11 80       	mov    0x80115738,%eax
80102de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102dea:	74 0a                	je     80102df6 <kalloc+0x33>
    kmem.freelist = r->next;
80102dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102def:	8b 00                	mov    (%eax),%eax
80102df1:	a3 38 57 11 80       	mov    %eax,0x80115738
  if(kmem.use_lock)
80102df6:	a1 34 57 11 80       	mov    0x80115734,%eax
80102dfb:	85 c0                	test   %eax,%eax
80102dfd:	74 0c                	je     80102e0b <kalloc+0x48>
    release(&kmem.lock);
80102dff:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102e06:	e8 62 34 00 00       	call   8010626d <release>
  return (char*)r;
80102e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102e0e:	c9                   	leave  
80102e0f:	c3                   	ret    

80102e10 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 14             	sub    $0x14,%esp
80102e16:	8b 45 08             	mov    0x8(%ebp),%eax
80102e19:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e1d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e21:	89 c2                	mov    %eax,%edx
80102e23:	ec                   	in     (%dx),%al
80102e24:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e27:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e2b:	c9                   	leave  
80102e2c:	c3                   	ret    

80102e2d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e2d:	55                   	push   %ebp
80102e2e:	89 e5                	mov    %esp,%ebp
80102e30:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102e33:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102e3a:	e8 d1 ff ff ff       	call   80102e10 <inb>
80102e3f:	0f b6 c0             	movzbl %al,%eax
80102e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e48:	83 e0 01             	and    $0x1,%eax
80102e4b:	85 c0                	test   %eax,%eax
80102e4d:	75 0a                	jne    80102e59 <kbdgetc+0x2c>
    return -1;
80102e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e54:	e9 25 01 00 00       	jmp    80102f7e <kbdgetc+0x151>
  data = inb(KBDATAP);
80102e59:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102e60:	e8 ab ff ff ff       	call   80102e10 <inb>
80102e65:	0f b6 c0             	movzbl %al,%eax
80102e68:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102e6b:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102e72:	75 17                	jne    80102e8b <kbdgetc+0x5e>
    shift |= E0ESC;
80102e74:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e79:	83 c8 40             	or     $0x40,%eax
80102e7c:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e81:	b8 00 00 00 00       	mov    $0x0,%eax
80102e86:	e9 f3 00 00 00       	jmp    80102f7e <kbdgetc+0x151>
  } else if(data & 0x80){
80102e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e8e:	25 80 00 00 00       	and    $0x80,%eax
80102e93:	85 c0                	test   %eax,%eax
80102e95:	74 45                	je     80102edc <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102e97:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e9c:	83 e0 40             	and    $0x40,%eax
80102e9f:	85 c0                	test   %eax,%eax
80102ea1:	75 08                	jne    80102eab <kbdgetc+0x7e>
80102ea3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ea6:	83 e0 7f             	and    $0x7f,%eax
80102ea9:	eb 03                	jmp    80102eae <kbdgetc+0x81>
80102eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eb4:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102eb9:	0f b6 00             	movzbl (%eax),%eax
80102ebc:	83 c8 40             	or     $0x40,%eax
80102ebf:	0f b6 c0             	movzbl %al,%eax
80102ec2:	f7 d0                	not    %eax
80102ec4:	89 c2                	mov    %eax,%edx
80102ec6:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102ecb:	21 d0                	and    %edx,%eax
80102ecd:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102ed2:	b8 00 00 00 00       	mov    $0x0,%eax
80102ed7:	e9 a2 00 00 00       	jmp    80102f7e <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102edc:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102ee1:	83 e0 40             	and    $0x40,%eax
80102ee4:	85 c0                	test   %eax,%eax
80102ee6:	74 14                	je     80102efc <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ee8:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102eef:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102ef4:	83 e0 bf             	and    $0xffffffbf,%eax
80102ef7:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102eff:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102f04:	0f b6 00             	movzbl (%eax),%eax
80102f07:	0f b6 d0             	movzbl %al,%edx
80102f0a:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f0f:	09 d0                	or     %edx,%eax
80102f11:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102f16:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f19:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102f1e:	0f b6 00             	movzbl (%eax),%eax
80102f21:	0f b6 d0             	movzbl %al,%edx
80102f24:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f29:	31 d0                	xor    %edx,%eax
80102f2b:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102f30:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f35:	83 e0 03             	and    $0x3,%eax
80102f38:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102f42:	01 d0                	add    %edx,%eax
80102f44:	0f b6 00             	movzbl (%eax),%eax
80102f47:	0f b6 c0             	movzbl %al,%eax
80102f4a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102f4d:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102f52:	83 e0 08             	and    $0x8,%eax
80102f55:	85 c0                	test   %eax,%eax
80102f57:	74 22                	je     80102f7b <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102f59:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102f5d:	76 0c                	jbe    80102f6b <kbdgetc+0x13e>
80102f5f:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102f63:	77 06                	ja     80102f6b <kbdgetc+0x13e>
      c += 'A' - 'a';
80102f65:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102f69:	eb 10                	jmp    80102f7b <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102f6b:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102f6f:	76 0a                	jbe    80102f7b <kbdgetc+0x14e>
80102f71:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102f75:	77 04                	ja     80102f7b <kbdgetc+0x14e>
      c += 'a' - 'A';
80102f77:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102f7e:	c9                   	leave  
80102f7f:	c3                   	ret    

80102f80 <kbdintr>:

void
kbdintr(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102f86:	c7 04 24 2d 2e 10 80 	movl   $0x80102e2d,(%esp)
80102f8d:	e8 5e d8 ff ff       	call   801007f0 <consoleintr>
}
80102f92:	c9                   	leave  
80102f93:	c3                   	ret    

80102f94 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102f94:	55                   	push   %ebp
80102f95:	89 e5                	mov    %esp,%ebp
80102f97:	83 ec 14             	sub    $0x14,%esp
80102f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80102f9d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102fa5:	89 c2                	mov    %eax,%edx
80102fa7:	ec                   	in     (%dx),%al
80102fa8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fab:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102faf:	c9                   	leave  
80102fb0:	c3                   	ret    

80102fb1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102fb1:	55                   	push   %ebp
80102fb2:	89 e5                	mov    %esp,%ebp
80102fb4:	83 ec 08             	sub    $0x8,%esp
80102fb7:	8b 55 08             	mov    0x8(%ebp),%edx
80102fba:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fbd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102fc1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fc4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102fc8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102fcc:	ee                   	out    %al,(%dx)
}
80102fcd:	c9                   	leave  
80102fce:	c3                   	ret    

80102fcf <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102fcf:	55                   	push   %ebp
80102fd0:	89 e5                	mov    %esp,%ebp
80102fd2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102fd5:	9c                   	pushf  
80102fd6:	58                   	pop    %eax
80102fd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102fdd:	c9                   	leave  
80102fde:	c3                   	ret    

80102fdf <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102fdf:	55                   	push   %ebp
80102fe0:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102fe2:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102fe7:	8b 55 08             	mov    0x8(%ebp),%edx
80102fea:	c1 e2 02             	shl    $0x2,%edx
80102fed:	01 c2                	add    %eax,%edx
80102fef:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ff2:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ff4:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102ff9:	83 c0 20             	add    $0x20,%eax
80102ffc:	8b 00                	mov    (%eax),%eax
}
80102ffe:	5d                   	pop    %ebp
80102fff:	c3                   	ret    

80103000 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80103006:	a1 3c 57 11 80       	mov    0x8011573c,%eax
8010300b:	85 c0                	test   %eax,%eax
8010300d:	75 05                	jne    80103014 <lapicinit+0x14>
    return;
8010300f:	e9 43 01 00 00       	jmp    80103157 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80103014:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
8010301b:	00 
8010301c:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80103023:	e8 b7 ff ff ff       	call   80102fdf <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103028:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
8010302f:	00 
80103030:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80103037:	e8 a3 ff ff ff       	call   80102fdf <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010303c:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80103043:	00 
80103044:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010304b:	e8 8f ff ff ff       	call   80102fdf <lapicw>
  lapicw(TICR, 10000000);
80103050:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80103057:	00 
80103058:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
8010305f:	e8 7b ff ff ff       	call   80102fdf <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103064:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010306b:	00 
8010306c:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80103073:	e8 67 ff ff ff       	call   80102fdf <lapicw>
  lapicw(LINT1, MASKED);
80103078:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
8010307f:	00 
80103080:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80103087:	e8 53 ff ff ff       	call   80102fdf <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010308c:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103091:	83 c0 30             	add    $0x30,%eax
80103094:	8b 00                	mov    (%eax),%eax
80103096:	c1 e8 10             	shr    $0x10,%eax
80103099:	0f b6 c0             	movzbl %al,%eax
8010309c:	83 f8 03             	cmp    $0x3,%eax
8010309f:	76 14                	jbe    801030b5 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
801030a1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801030a8:	00 
801030a9:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
801030b0:	e8 2a ff ff ff       	call   80102fdf <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801030b5:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
801030bc:	00 
801030bd:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
801030c4:	e8 16 ff ff ff       	call   80102fdf <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
801030c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030d0:	00 
801030d1:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
801030d8:	e8 02 ff ff ff       	call   80102fdf <lapicw>
  lapicw(ESR, 0);
801030dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030e4:	00 
801030e5:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
801030ec:	e8 ee fe ff ff       	call   80102fdf <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801030f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801030f8:	00 
801030f9:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103100:	e8 da fe ff ff       	call   80102fdf <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103105:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010310c:	00 
8010310d:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103114:	e8 c6 fe ff ff       	call   80102fdf <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103119:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80103120:	00 
80103121:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103128:	e8 b2 fe ff ff       	call   80102fdf <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010312d:	90                   	nop
8010312e:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103133:	05 00 03 00 00       	add    $0x300,%eax
80103138:	8b 00                	mov    (%eax),%eax
8010313a:	25 00 10 00 00       	and    $0x1000,%eax
8010313f:	85 c0                	test   %eax,%eax
80103141:	75 eb                	jne    8010312e <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010314a:	00 
8010314b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103152:	e8 88 fe ff ff       	call   80102fdf <lapicw>
}
80103157:	c9                   	leave  
80103158:	c3                   	ret    

80103159 <cpunum>:

int
cpunum(void)
{
80103159:	55                   	push   %ebp
8010315a:	89 e5                	mov    %esp,%ebp
8010315c:	83 ec 28             	sub    $0x28,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010315f:	e8 6b fe ff ff       	call   80102fcf <readeflags>
80103164:	25 00 02 00 00       	and    $0x200,%eax
80103169:	85 c0                	test   %eax,%eax
8010316b:	74 25                	je     80103192 <cpunum+0x39>
    static int n;
    if(n++ == 0)
8010316d:	a1 60 d6 10 80       	mov    0x8010d660,%eax
80103172:	8d 50 01             	lea    0x1(%eax),%edx
80103175:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
8010317b:	85 c0                	test   %eax,%eax
8010317d:	75 13                	jne    80103192 <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
8010317f:	8b 45 04             	mov    0x4(%ebp),%eax
80103182:	89 44 24 04          	mov    %eax,0x4(%esp)
80103186:	c7 04 24 60 9d 10 80 	movl   $0x80109d60,(%esp)
8010318d:	e8 36 d2 ff ff       	call   801003c8 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
80103192:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103197:	85 c0                	test   %eax,%eax
80103199:	75 07                	jne    801031a2 <cpunum+0x49>
    return 0;
8010319b:	b8 00 00 00 00       	mov    $0x0,%eax
801031a0:	eb 51                	jmp    801031f3 <cpunum+0x9a>

  apicid = lapic[ID] >> 24;
801031a2:	a1 3c 57 11 80       	mov    0x8011573c,%eax
801031a7:	83 c0 20             	add    $0x20,%eax
801031aa:	8b 00                	mov    (%eax),%eax
801031ac:	c1 e8 18             	shr    $0x18,%eax
801031af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < ncpu; ++i) {
801031b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031b9:	eb 22                	jmp    801031dd <cpunum+0x84>
    if (cpus[i].apicid == apicid)
801031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031be:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801031c4:	05 40 58 11 80       	add    $0x80115840,%eax
801031c9:	0f b6 00             	movzbl (%eax),%eax
801031cc:	0f b6 c0             	movzbl %al,%eax
801031cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801031d2:	75 05                	jne    801031d9 <cpunum+0x80>
      return i;
801031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031d7:	eb 1a                	jmp    801031f3 <cpunum+0x9a>

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801031d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031dd:	a1 20 5e 11 80       	mov    0x80115e20,%eax
801031e2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801031e5:	7c d4                	jl     801031bb <cpunum+0x62>
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801031e7:	c7 04 24 8c 9d 10 80 	movl   $0x80109d8c,(%esp)
801031ee:	e8 6f d3 ff ff       	call   80100562 <panic>
}
801031f3:	c9                   	leave  
801031f4:	c3                   	ret    

801031f5 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801031f5:	55                   	push   %ebp
801031f6:	89 e5                	mov    %esp,%ebp
801031f8:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
801031fb:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103200:	85 c0                	test   %eax,%eax
80103202:	74 14                	je     80103218 <lapiceoi+0x23>
    lapicw(EOI, 0);
80103204:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010320b:	00 
8010320c:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80103213:	e8 c7 fd ff ff       	call   80102fdf <lapicw>
}
80103218:	c9                   	leave  
80103219:	c3                   	ret    

8010321a <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010321a:	55                   	push   %ebp
8010321b:	89 e5                	mov    %esp,%ebp
}
8010321d:	5d                   	pop    %ebp
8010321e:	c3                   	ret    

8010321f <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010321f:	55                   	push   %ebp
80103220:	89 e5                	mov    %esp,%ebp
80103222:	83 ec 1c             	sub    $0x1c,%esp
80103225:	8b 45 08             	mov    0x8(%ebp),%eax
80103228:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
8010322b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80103232:	00 
80103233:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010323a:	e8 72 fd ff ff       	call   80102fb1 <outb>
  outb(CMOS_PORT+1, 0x0A);
8010323f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103246:	00 
80103247:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010324e:	e8 5e fd ff ff       	call   80102fb1 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103253:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010325a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010325d:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103262:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103265:	8d 50 02             	lea    0x2(%eax),%edx
80103268:	8b 45 0c             	mov    0xc(%ebp),%eax
8010326b:	c1 e8 04             	shr    $0x4,%eax
8010326e:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103271:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103275:	c1 e0 18             	shl    $0x18,%eax
80103278:	89 44 24 04          	mov    %eax,0x4(%esp)
8010327c:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103283:	e8 57 fd ff ff       	call   80102fdf <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103288:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010328f:	00 
80103290:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103297:	e8 43 fd ff ff       	call   80102fdf <lapicw>
  microdelay(200);
8010329c:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801032a3:	e8 72 ff ff ff       	call   8010321a <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
801032a8:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
801032af:	00 
801032b0:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801032b7:	e8 23 fd ff ff       	call   80102fdf <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801032bc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
801032c3:	e8 52 ff ff ff       	call   8010321a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801032c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801032cf:	eb 40                	jmp    80103311 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
801032d1:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801032d5:	c1 e0 18             	shl    $0x18,%eax
801032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801032dc:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801032e3:	e8 f7 fc ff ff       	call   80102fdf <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801032e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801032eb:	c1 e8 0c             	shr    $0xc,%eax
801032ee:	80 cc 06             	or     $0x6,%ah
801032f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801032f5:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
801032fc:	e8 de fc ff ff       	call   80102fdf <lapicw>
    microdelay(200);
80103301:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103308:	e8 0d ff ff ff       	call   8010321a <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010330d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103311:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103315:	7e ba                	jle    801032d1 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103317:	c9                   	leave  
80103318:	c3                   	ret    

80103319 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103319:	55                   	push   %ebp
8010331a:	89 e5                	mov    %esp,%ebp
8010331c:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010331f:	8b 45 08             	mov    0x8(%ebp),%eax
80103322:	0f b6 c0             	movzbl %al,%eax
80103325:	89 44 24 04          	mov    %eax,0x4(%esp)
80103329:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103330:	e8 7c fc ff ff       	call   80102fb1 <outb>
  microdelay(200);
80103335:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010333c:	e8 d9 fe ff ff       	call   8010321a <microdelay>

  return inb(CMOS_RETURN);
80103341:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80103348:	e8 47 fc ff ff       	call   80102f94 <inb>
8010334d:	0f b6 c0             	movzbl %al,%eax
}
80103350:	c9                   	leave  
80103351:	c3                   	ret    

80103352 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103352:	55                   	push   %ebp
80103353:	89 e5                	mov    %esp,%ebp
80103355:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
80103358:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010335f:	e8 b5 ff ff ff       	call   80103319 <cmos_read>
80103364:	8b 55 08             	mov    0x8(%ebp),%edx
80103367:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
80103369:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103370:	e8 a4 ff ff ff       	call   80103319 <cmos_read>
80103375:	8b 55 08             	mov    0x8(%ebp),%edx
80103378:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010337b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103382:	e8 92 ff ff ff       	call   80103319 <cmos_read>
80103387:	8b 55 08             	mov    0x8(%ebp),%edx
8010338a:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010338d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103394:	e8 80 ff ff ff       	call   80103319 <cmos_read>
80103399:	8b 55 08             	mov    0x8(%ebp),%edx
8010339c:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010339f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801033a6:	e8 6e ff ff ff       	call   80103319 <cmos_read>
801033ab:	8b 55 08             	mov    0x8(%ebp),%edx
801033ae:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801033b1:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801033b8:	e8 5c ff ff ff       	call   80103319 <cmos_read>
801033bd:	8b 55 08             	mov    0x8(%ebp),%edx
801033c0:	89 42 14             	mov    %eax,0x14(%edx)
}
801033c3:	c9                   	leave  
801033c4:	c3                   	ret    

801033c5 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801033c5:	55                   	push   %ebp
801033c6:	89 e5                	mov    %esp,%ebp
801033c8:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801033cb:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801033d2:	e8 42 ff ff ff       	call   80103319 <cmos_read>
801033d7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033dd:	83 e0 04             	and    $0x4,%eax
801033e0:	85 c0                	test   %eax,%eax
801033e2:	0f 94 c0             	sete   %al
801033e5:	0f b6 c0             	movzbl %al,%eax
801033e8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801033eb:	8d 45 d8             	lea    -0x28(%ebp),%eax
801033ee:	89 04 24             	mov    %eax,(%esp)
801033f1:	e8 5c ff ff ff       	call   80103352 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801033f6:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801033fd:	e8 17 ff ff ff       	call   80103319 <cmos_read>
80103402:	25 80 00 00 00       	and    $0x80,%eax
80103407:	85 c0                	test   %eax,%eax
80103409:	74 02                	je     8010340d <cmostime+0x48>
        continue;
8010340b:	eb 36                	jmp    80103443 <cmostime+0x7e>
    fill_rtcdate(&t2);
8010340d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103410:	89 04 24             	mov    %eax,(%esp)
80103413:	e8 3a ff ff ff       	call   80103352 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103418:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010341f:	00 
80103420:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103423:	89 44 24 04          	mov    %eax,0x4(%esp)
80103427:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010342a:	89 04 24             	mov    %eax,(%esp)
8010342d:	e8 b4 30 00 00       	call   801064e6 <memcmp>
80103432:	85 c0                	test   %eax,%eax
80103434:	75 0d                	jne    80103443 <cmostime+0x7e>
      break;
80103436:	90                   	nop
  }

  // convert
  if(bcd) {
80103437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010343b:	0f 84 ac 00 00 00    	je     801034ed <cmostime+0x128>
80103441:	eb 02                	jmp    80103445 <cmostime+0x80>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103443:	eb a6                	jmp    801033eb <cmostime+0x26>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103445:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103448:	c1 e8 04             	shr    $0x4,%eax
8010344b:	89 c2                	mov    %eax,%edx
8010344d:	89 d0                	mov    %edx,%eax
8010344f:	c1 e0 02             	shl    $0x2,%eax
80103452:	01 d0                	add    %edx,%eax
80103454:	01 c0                	add    %eax,%eax
80103456:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103459:	83 e2 0f             	and    $0xf,%edx
8010345c:	01 d0                	add    %edx,%eax
8010345e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103461:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103464:	c1 e8 04             	shr    $0x4,%eax
80103467:	89 c2                	mov    %eax,%edx
80103469:	89 d0                	mov    %edx,%eax
8010346b:	c1 e0 02             	shl    $0x2,%eax
8010346e:	01 d0                	add    %edx,%eax
80103470:	01 c0                	add    %eax,%eax
80103472:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103475:	83 e2 0f             	and    $0xf,%edx
80103478:	01 d0                	add    %edx,%eax
8010347a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010347d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103480:	c1 e8 04             	shr    $0x4,%eax
80103483:	89 c2                	mov    %eax,%edx
80103485:	89 d0                	mov    %edx,%eax
80103487:	c1 e0 02             	shl    $0x2,%eax
8010348a:	01 d0                	add    %edx,%eax
8010348c:	01 c0                	add    %eax,%eax
8010348e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103491:	83 e2 0f             	and    $0xf,%edx
80103494:	01 d0                	add    %edx,%eax
80103496:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010349c:	c1 e8 04             	shr    $0x4,%eax
8010349f:	89 c2                	mov    %eax,%edx
801034a1:	89 d0                	mov    %edx,%eax
801034a3:	c1 e0 02             	shl    $0x2,%eax
801034a6:	01 d0                	add    %edx,%eax
801034a8:	01 c0                	add    %eax,%eax
801034aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034ad:	83 e2 0f             	and    $0xf,%edx
801034b0:	01 d0                	add    %edx,%eax
801034b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801034b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801034b8:	c1 e8 04             	shr    $0x4,%eax
801034bb:	89 c2                	mov    %eax,%edx
801034bd:	89 d0                	mov    %edx,%eax
801034bf:	c1 e0 02             	shl    $0x2,%eax
801034c2:	01 d0                	add    %edx,%eax
801034c4:	01 c0                	add    %eax,%eax
801034c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
801034c9:	83 e2 0f             	and    $0xf,%edx
801034cc:	01 d0                	add    %edx,%eax
801034ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801034d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d4:	c1 e8 04             	shr    $0x4,%eax
801034d7:	89 c2                	mov    %eax,%edx
801034d9:	89 d0                	mov    %edx,%eax
801034db:	c1 e0 02             	shl    $0x2,%eax
801034de:	01 d0                	add    %edx,%eax
801034e0:	01 c0                	add    %eax,%eax
801034e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801034e5:	83 e2 0f             	and    $0xf,%edx
801034e8:	01 d0                	add    %edx,%eax
801034ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801034ed:	8b 45 08             	mov    0x8(%ebp),%eax
801034f0:	8b 55 d8             	mov    -0x28(%ebp),%edx
801034f3:	89 10                	mov    %edx,(%eax)
801034f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801034f8:	89 50 04             	mov    %edx,0x4(%eax)
801034fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
801034fe:	89 50 08             	mov    %edx,0x8(%eax)
80103501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103504:	89 50 0c             	mov    %edx,0xc(%eax)
80103507:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010350a:	89 50 10             	mov    %edx,0x10(%eax)
8010350d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103510:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103513:	8b 45 08             	mov    0x8(%ebp),%eax
80103516:	8b 40 14             	mov    0x14(%eax),%eax
80103519:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010351f:	8b 45 08             	mov    0x8(%ebp),%eax
80103522:	89 50 14             	mov    %edx,0x14(%eax)
}
80103525:	c9                   	leave  
80103526:	c3                   	ret    

80103527 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103527:	55                   	push   %ebp
80103528:	89 e5                	mov    %esp,%ebp
8010352a:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010352d:	c7 44 24 04 9c 9d 10 	movl   $0x80109d9c,0x4(%esp)
80103534:	80 
80103535:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
8010353c:	e8 a4 2c 00 00       	call   801061e5 <initlock>
  readsb(dev, &sb);
80103541:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103544:	89 44 24 04          	mov    %eax,0x4(%esp)
80103548:	8b 45 08             	mov    0x8(%ebp),%eax
8010354b:	89 04 24             	mov    %eax,(%esp)
8010354e:	e8 12 de ff ff       	call   80101365 <readsb>
  log.start = sb.logstart;
80103553:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103556:	a3 74 57 11 80       	mov    %eax,0x80115774
  log.size = sb.nlog;
8010355b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010355e:	a3 78 57 11 80       	mov    %eax,0x80115778
  log.dev = dev;
80103563:	8b 45 08             	mov    0x8(%ebp),%eax
80103566:	a3 84 57 11 80       	mov    %eax,0x80115784
  recover_from_log();
8010356b:	e8 9a 01 00 00       	call   8010370a <recover_from_log>
}
80103570:	c9                   	leave  
80103571:	c3                   	ret    

80103572 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80103572:	55                   	push   %ebp
80103573:	89 e5                	mov    %esp,%ebp
80103575:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010357f:	e9 8c 00 00 00       	jmp    80103610 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103584:	8b 15 74 57 11 80    	mov    0x80115774,%edx
8010358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010358d:	01 d0                	add    %edx,%eax
8010358f:	83 c0 01             	add    $0x1,%eax
80103592:	89 c2                	mov    %eax,%edx
80103594:	a1 84 57 11 80       	mov    0x80115784,%eax
80103599:	89 54 24 04          	mov    %edx,0x4(%esp)
8010359d:	89 04 24             	mov    %eax,(%esp)
801035a0:	e8 10 cc ff ff       	call   801001b5 <bread>
801035a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ab:	83 c0 10             	add    $0x10,%eax
801035ae:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
801035b5:	89 c2                	mov    %eax,%edx
801035b7:	a1 84 57 11 80       	mov    0x80115784,%eax
801035bc:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c0:	89 04 24             	mov    %eax,(%esp)
801035c3:	e8 ed cb ff ff       	call   801001b5 <bread>
801035c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801035cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035ce:	8d 50 5c             	lea    0x5c(%eax),%edx
801035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d4:	83 c0 5c             	add    $0x5c,%eax
801035d7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035de:	00 
801035df:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e3:	89 04 24             	mov    %eax,(%esp)
801035e6:	e8 53 2f 00 00       	call   8010653e <memmove>
    bwrite(dbuf);  // write dst to disk
801035eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ee:	89 04 24             	mov    %eax,(%esp)
801035f1:	e8 f6 cb ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
801035f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035f9:	89 04 24             	mov    %eax,(%esp)
801035fc:	e8 2b cc ff ff       	call   8010022c <brelse>
    brelse(dbuf);
80103601:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103604:	89 04 24             	mov    %eax,(%esp)
80103607:	e8 20 cc ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010360c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103610:	a1 88 57 11 80       	mov    0x80115788,%eax
80103615:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103618:	0f 8f 66 ff ff ff    	jg     80103584 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
8010361e:	c9                   	leave  
8010361f:	c3                   	ret    

80103620 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103626:	a1 74 57 11 80       	mov    0x80115774,%eax
8010362b:	89 c2                	mov    %eax,%edx
8010362d:	a1 84 57 11 80       	mov    0x80115784,%eax
80103632:	89 54 24 04          	mov    %edx,0x4(%esp)
80103636:	89 04 24             	mov    %eax,(%esp)
80103639:	e8 77 cb ff ff       	call   801001b5 <bread>
8010363e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103644:	83 c0 5c             	add    $0x5c,%eax
80103647:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010364a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010364d:	8b 00                	mov    (%eax),%eax
8010364f:	a3 88 57 11 80       	mov    %eax,0x80115788
  for (i = 0; i < log.lh.n; i++) {
80103654:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010365b:	eb 1b                	jmp    80103678 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
8010365d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103660:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103663:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103667:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010366a:	83 c2 10             	add    $0x10,%edx
8010366d:	89 04 95 4c 57 11 80 	mov    %eax,-0x7feea8b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103674:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103678:	a1 88 57 11 80       	mov    0x80115788,%eax
8010367d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103680:	7f db                	jg     8010365d <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103685:	89 04 24             	mov    %eax,(%esp)
80103688:	e8 9f cb ff ff       	call   8010022c <brelse>
}
8010368d:	c9                   	leave  
8010368e:	c3                   	ret    

8010368f <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010368f:	55                   	push   %ebp
80103690:	89 e5                	mov    %esp,%ebp
80103692:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103695:	a1 74 57 11 80       	mov    0x80115774,%eax
8010369a:	89 c2                	mov    %eax,%edx
8010369c:	a1 84 57 11 80       	mov    0x80115784,%eax
801036a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801036a5:	89 04 24             	mov    %eax,(%esp)
801036a8:	e8 08 cb ff ff       	call   801001b5 <bread>
801036ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801036b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b3:	83 c0 5c             	add    $0x5c,%eax
801036b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801036b9:	8b 15 88 57 11 80    	mov    0x80115788,%edx
801036bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036c2:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801036c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036cb:	eb 1b                	jmp    801036e8 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
801036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d0:	83 c0 10             	add    $0x10,%eax
801036d3:	8b 0c 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%ecx
801036da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036e0:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801036e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036e8:	a1 88 57 11 80       	mov    0x80115788,%eax
801036ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f0:	7f db                	jg     801036cd <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801036f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036f5:	89 04 24             	mov    %eax,(%esp)
801036f8:	e8 ef ca ff ff       	call   801001ec <bwrite>
  brelse(buf);
801036fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103700:	89 04 24             	mov    %eax,(%esp)
80103703:	e8 24 cb ff ff       	call   8010022c <brelse>
}
80103708:	c9                   	leave  
80103709:	c3                   	ret    

8010370a <recover_from_log>:

static void
recover_from_log(void)
{
8010370a:	55                   	push   %ebp
8010370b:	89 e5                	mov    %esp,%ebp
8010370d:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103710:	e8 0b ff ff ff       	call   80103620 <read_head>
  install_trans(); // if committed, copy from log to disk
80103715:	e8 58 fe ff ff       	call   80103572 <install_trans>
  log.lh.n = 0;
8010371a:	c7 05 88 57 11 80 00 	movl   $0x0,0x80115788
80103721:	00 00 00 
  write_head(); // clear the log
80103724:	e8 66 ff ff ff       	call   8010368f <write_head>
}
80103729:	c9                   	leave  
8010372a:	c3                   	ret    

8010372b <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010372b:	55                   	push   %ebp
8010372c:	89 e5                	mov    %esp,%ebp
8010372e:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103731:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103738:	e8 c9 2a 00 00       	call   80106206 <acquire>
  while(1){
    if(log.committing){
8010373d:	a1 80 57 11 80       	mov    0x80115780,%eax
80103742:	85 c0                	test   %eax,%eax
80103744:	74 16                	je     8010375c <begin_op+0x31>
      sleep(&log, &log.lock);
80103746:	c7 44 24 04 40 57 11 	movl   $0x80115740,0x4(%esp)
8010374d:	80 
8010374e:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103755:	e8 ac 20 00 00       	call   80105806 <sleep>
8010375a:	eb 4f                	jmp    801037ab <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010375c:	8b 0d 88 57 11 80    	mov    0x80115788,%ecx
80103762:	a1 7c 57 11 80       	mov    0x8011577c,%eax
80103767:	8d 50 01             	lea    0x1(%eax),%edx
8010376a:	89 d0                	mov    %edx,%eax
8010376c:	c1 e0 02             	shl    $0x2,%eax
8010376f:	01 d0                	add    %edx,%eax
80103771:	01 c0                	add    %eax,%eax
80103773:	01 c8                	add    %ecx,%eax
80103775:	83 f8 1e             	cmp    $0x1e,%eax
80103778:	7e 16                	jle    80103790 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010377a:	c7 44 24 04 40 57 11 	movl   $0x80115740,0x4(%esp)
80103781:	80 
80103782:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103789:	e8 78 20 00 00       	call   80105806 <sleep>
8010378e:	eb 1b                	jmp    801037ab <begin_op+0x80>
    } else {
      log.outstanding += 1;
80103790:	a1 7c 57 11 80       	mov    0x8011577c,%eax
80103795:	83 c0 01             	add    $0x1,%eax
80103798:	a3 7c 57 11 80       	mov    %eax,0x8011577c
      release(&log.lock);
8010379d:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801037a4:	e8 c4 2a 00 00       	call   8010626d <release>
      break;
801037a9:	eb 02                	jmp    801037ad <begin_op+0x82>
    }
  }
801037ab:	eb 90                	jmp    8010373d <begin_op+0x12>
}
801037ad:	c9                   	leave  
801037ae:	c3                   	ret    

801037af <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801037b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801037bc:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801037c3:	e8 3e 2a 00 00       	call   80106206 <acquire>
  log.outstanding -= 1;
801037c8:	a1 7c 57 11 80       	mov    0x8011577c,%eax
801037cd:	83 e8 01             	sub    $0x1,%eax
801037d0:	a3 7c 57 11 80       	mov    %eax,0x8011577c
  if(log.committing)
801037d5:	a1 80 57 11 80       	mov    0x80115780,%eax
801037da:	85 c0                	test   %eax,%eax
801037dc:	74 0c                	je     801037ea <end_op+0x3b>
    panic("log.committing");
801037de:	c7 04 24 a0 9d 10 80 	movl   $0x80109da0,(%esp)
801037e5:	e8 78 cd ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
801037ea:	a1 7c 57 11 80       	mov    0x8011577c,%eax
801037ef:	85 c0                	test   %eax,%eax
801037f1:	75 13                	jne    80103806 <end_op+0x57>
    do_commit = 1;
801037f3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801037fa:	c7 05 80 57 11 80 01 	movl   $0x1,0x80115780
80103801:	00 00 00 
80103804:	eb 0c                	jmp    80103812 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103806:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
8010380d:	e8 fe 20 00 00       	call   80105910 <wakeup>
  }
  release(&log.lock);
80103812:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103819:	e8 4f 2a 00 00       	call   8010626d <release>

  if(do_commit){
8010381e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103822:	74 33                	je     80103857 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103824:	e8 de 00 00 00       	call   80103907 <commit>
    acquire(&log.lock);
80103829:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103830:	e8 d1 29 00 00       	call   80106206 <acquire>
    log.committing = 0;
80103835:	c7 05 80 57 11 80 00 	movl   $0x0,0x80115780
8010383c:	00 00 00 
    wakeup(&log);
8010383f:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103846:	e8 c5 20 00 00       	call   80105910 <wakeup>
    release(&log.lock);
8010384b:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103852:	e8 16 2a 00 00       	call   8010626d <release>
  }
}
80103857:	c9                   	leave  
80103858:	c3                   	ret    

80103859 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80103859:	55                   	push   %ebp
8010385a:	89 e5                	mov    %esp,%ebp
8010385c:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010385f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103866:	e9 8c 00 00 00       	jmp    801038f7 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010386b:	8b 15 74 57 11 80    	mov    0x80115774,%edx
80103871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103874:	01 d0                	add    %edx,%eax
80103876:	83 c0 01             	add    $0x1,%eax
80103879:	89 c2                	mov    %eax,%edx
8010387b:	a1 84 57 11 80       	mov    0x80115784,%eax
80103880:	89 54 24 04          	mov    %edx,0x4(%esp)
80103884:	89 04 24             	mov    %eax,(%esp)
80103887:	e8 29 c9 ff ff       	call   801001b5 <bread>
8010388c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103892:	83 c0 10             	add    $0x10,%eax
80103895:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
8010389c:	89 c2                	mov    %eax,%edx
8010389e:	a1 84 57 11 80       	mov    0x80115784,%eax
801038a3:	89 54 24 04          	mov    %edx,0x4(%esp)
801038a7:	89 04 24             	mov    %eax,(%esp)
801038aa:	e8 06 c9 ff ff       	call   801001b5 <bread>
801038af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801038b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038b5:	8d 50 5c             	lea    0x5c(%eax),%edx
801038b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038bb:	83 c0 5c             	add    $0x5c,%eax
801038be:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801038c5:	00 
801038c6:	89 54 24 04          	mov    %edx,0x4(%esp)
801038ca:	89 04 24             	mov    %eax,(%esp)
801038cd:	e8 6c 2c 00 00       	call   8010653e <memmove>
    bwrite(to);  // write the log
801038d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d5:	89 04 24             	mov    %eax,(%esp)
801038d8:	e8 0f c9 ff ff       	call   801001ec <bwrite>
    brelse(from);
801038dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801038e0:	89 04 24             	mov    %eax,(%esp)
801038e3:	e8 44 c9 ff ff       	call   8010022c <brelse>
    brelse(to);
801038e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038eb:	89 04 24             	mov    %eax,(%esp)
801038ee:	e8 39 c9 ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801038f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038f7:	a1 88 57 11 80       	mov    0x80115788,%eax
801038fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038ff:	0f 8f 66 ff ff ff    	jg     8010386b <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103905:	c9                   	leave  
80103906:	c3                   	ret    

80103907 <commit>:

static void
commit()
{
80103907:	55                   	push   %ebp
80103908:	89 e5                	mov    %esp,%ebp
8010390a:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010390d:	a1 88 57 11 80       	mov    0x80115788,%eax
80103912:	85 c0                	test   %eax,%eax
80103914:	7e 1e                	jle    80103934 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103916:	e8 3e ff ff ff       	call   80103859 <write_log>
    write_head();    // Write header to disk -- the real commit
8010391b:	e8 6f fd ff ff       	call   8010368f <write_head>
    install_trans(); // Now install writes to home locations
80103920:	e8 4d fc ff ff       	call   80103572 <install_trans>
    log.lh.n = 0;
80103925:	c7 05 88 57 11 80 00 	movl   $0x0,0x80115788
8010392c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010392f:	e8 5b fd ff ff       	call   8010368f <write_head>
  }
}
80103934:	c9                   	leave  
80103935:	c3                   	ret    

80103936 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103936:	55                   	push   %ebp
80103937:	89 e5                	mov    %esp,%ebp
80103939:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010393c:	a1 88 57 11 80       	mov    0x80115788,%eax
80103941:	83 f8 1d             	cmp    $0x1d,%eax
80103944:	7f 12                	jg     80103958 <log_write+0x22>
80103946:	a1 88 57 11 80       	mov    0x80115788,%eax
8010394b:	8b 15 78 57 11 80    	mov    0x80115778,%edx
80103951:	83 ea 01             	sub    $0x1,%edx
80103954:	39 d0                	cmp    %edx,%eax
80103956:	7c 0c                	jl     80103964 <log_write+0x2e>
    panic("too big a transaction");
80103958:	c7 04 24 af 9d 10 80 	movl   $0x80109daf,(%esp)
8010395f:	e8 fe cb ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
80103964:	a1 7c 57 11 80       	mov    0x8011577c,%eax
80103969:	85 c0                	test   %eax,%eax
8010396b:	7f 0c                	jg     80103979 <log_write+0x43>
    panic("log_write outside of trans");
8010396d:	c7 04 24 c5 9d 10 80 	movl   $0x80109dc5,(%esp)
80103974:	e8 e9 cb ff ff       	call   80100562 <panic>

  acquire(&log.lock);
80103979:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103980:	e8 81 28 00 00       	call   80106206 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103985:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010398c:	eb 1f                	jmp    801039ad <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010398e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103991:	83 c0 10             	add    $0x10,%eax
80103994:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
8010399b:	89 c2                	mov    %eax,%edx
8010399d:	8b 45 08             	mov    0x8(%ebp),%eax
801039a0:	8b 40 08             	mov    0x8(%eax),%eax
801039a3:	39 c2                	cmp    %eax,%edx
801039a5:	75 02                	jne    801039a9 <log_write+0x73>
      break;
801039a7:	eb 0e                	jmp    801039b7 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801039a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039ad:	a1 88 57 11 80       	mov    0x80115788,%eax
801039b2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039b5:	7f d7                	jg     8010398e <log_write+0x58>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801039b7:	8b 45 08             	mov    0x8(%ebp),%eax
801039ba:	8b 40 08             	mov    0x8(%eax),%eax
801039bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801039c0:	83 c2 10             	add    $0x10,%edx
801039c3:	89 04 95 4c 57 11 80 	mov    %eax,-0x7feea8b4(,%edx,4)
  if (i == log.lh.n)
801039ca:	a1 88 57 11 80       	mov    0x80115788,%eax
801039cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039d2:	75 0d                	jne    801039e1 <log_write+0xab>
    log.lh.n++;
801039d4:	a1 88 57 11 80       	mov    0x80115788,%eax
801039d9:	83 c0 01             	add    $0x1,%eax
801039dc:	a3 88 57 11 80       	mov    %eax,0x80115788
  b->flags |= B_DIRTY; // prevent eviction
801039e1:	8b 45 08             	mov    0x8(%ebp),%eax
801039e4:	8b 00                	mov    (%eax),%eax
801039e6:	83 c8 04             	or     $0x4,%eax
801039e9:	89 c2                	mov    %eax,%edx
801039eb:	8b 45 08             	mov    0x8(%ebp),%eax
801039ee:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801039f0:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801039f7:	e8 71 28 00 00       	call   8010626d <release>
}
801039fc:	c9                   	leave  
801039fd:	c3                   	ret    

801039fe <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801039fe:	55                   	push   %ebp
801039ff:	89 e5                	mov    %esp,%ebp
80103a01:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103a04:	8b 55 08             	mov    0x8(%ebp),%edx
80103a07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103a0d:	f0 87 02             	lock xchg %eax,(%edx)
80103a10:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103a16:	c9                   	leave  
80103a17:	c3                   	ret    

80103a18 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103a18:	55                   	push   %ebp
80103a19:	89 e5                	mov    %esp,%ebp
80103a1b:	83 e4 f0             	and    $0xfffffff0,%esp
80103a1e:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103a21:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103a28:	80 
80103a29:	c7 04 24 28 d3 11 80 	movl   $0x8011d328,(%esp)
80103a30:	e8 63 f2 ff ff       	call   80102c98 <kinit1>
  kvmalloc();      // kernel page table
80103a35:	e8 6c 58 00 00       	call   801092a6 <kvmalloc>
  mpinit();        // detect other processors
80103a3a:	e8 f1 03 00 00       	call   80103e30 <mpinit>
  lapicinit();     // interrupt controller
80103a3f:	e8 bc f5 ff ff       	call   80103000 <lapicinit>
  seginit();       // segment descriptors
80103a44:	e8 18 52 00 00       	call   80108c61 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103a49:	e8 0b f7 ff ff       	call   80103159 <cpunum>
80103a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a52:	c7 04 24 e0 9d 10 80 	movl   $0x80109de0,(%esp)
80103a59:	e8 6a c9 ff ff       	call   801003c8 <cprintf>
  picinit();       // another interrupt controller
80103a5e:	e8 a8 05 00 00       	call   8010400b <picinit>
  ioapicinit();    // another interrupt controller
80103a63:	e8 33 f1 ff ff       	call   80102b9b <ioapicinit>
  consoleinit();   // console hardware
80103a68:	e8 6b d0 ff ff       	call   80100ad8 <consoleinit>
  uartinit();      // serial port
80103a6d:	e8 58 45 00 00       	call   80107fca <uartinit>
  pinit();         // process table
80103a72:	e8 9e 0a 00 00       	call   80104515 <pinit>
  tvinit();        // trap vectors
80103a77:	e8 da 3f 00 00       	call   80107a56 <tvinit>
  binit();         // buffer cache
80103a7c:	e8 b3 c5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103a81:	e8 f8 d4 ff ff       	call   80100f7e <fileinit>
  ideinit();       // disk
80103a86:	e8 0e ed ff ff       	call   80102799 <ideinit>
  if(!ismp)
80103a8b:	a1 24 58 11 80       	mov    0x80115824,%eax
80103a90:	85 c0                	test   %eax,%eax
80103a92:	75 05                	jne    80103a99 <main+0x81>
    timerinit();   // uniprocessor timer
80103a94:	e8 08 3f 00 00       	call   801079a1 <timerinit>
  startothers();   // start other processors
80103a99:	e8 78 00 00 00       	call   80103b16 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103a9e:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103aa5:	8e 
80103aa6:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103aad:	e8 1e f2 ff ff       	call   80102cd0 <kinit2>
  userinit();      // first user process
80103ab2:	e8 4b 0d 00 00       	call   80104802 <userinit>
  mpmain();        // finish this processor's setup
80103ab7:	e8 1a 00 00 00       	call   80103ad6 <mpmain>

80103abc <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103ac2:	e8 f6 57 00 00       	call   801092bd <switchkvm>
  seginit();
80103ac7:	e8 95 51 00 00       	call   80108c61 <seginit>
  lapicinit();
80103acc:	e8 2f f5 ff ff       	call   80103000 <lapicinit>
  mpmain();
80103ad1:	e8 00 00 00 00       	call   80103ad6 <mpmain>

80103ad6 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80103adc:	e8 78 f6 ff ff       	call   80103159 <cpunum>
80103ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ae5:	c7 04 24 f7 9d 10 80 	movl   $0x80109df7,(%esp)
80103aec:	e8 d7 c8 ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103af1:	e8 50 41 00 00       	call   80107c46 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103af6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103afc:	05 a8 00 00 00       	add    $0xa8,%eax
80103b01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103b08:	00 
80103b09:	89 04 24             	mov    %eax,(%esp)
80103b0c:	e8 ed fe ff ff       	call   801039fe <xchg>
  scheduler();     // start running processes
80103b11:	e8 03 16 00 00       	call   80105119 <scheduler>

80103b16 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103b16:	55                   	push   %ebp
80103b17:	89 e5                	mov    %esp,%ebp
80103b19:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103b1c:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b23:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103b28:	89 44 24 08          	mov    %eax,0x8(%esp)
80103b2c:	c7 44 24 04 2c d5 10 	movl   $0x8010d52c,0x4(%esp)
80103b33:	80 
80103b34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b37:	89 04 24             	mov    %eax,(%esp)
80103b3a:	e8 ff 29 00 00       	call   8010653e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103b3f:	c7 45 f4 40 58 11 80 	movl   $0x80115840,-0xc(%ebp)
80103b46:	e9 81 00 00 00       	jmp    80103bcc <startothers+0xb6>
    if(c == cpus+cpunum())  // We've started already.
80103b4b:	e8 09 f6 ff ff       	call   80103159 <cpunum>
80103b50:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b56:	05 40 58 11 80       	add    $0x80115840,%eax
80103b5b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b5e:	75 02                	jne    80103b62 <startothers+0x4c>
      continue;
80103b60:	eb 63                	jmp    80103bc5 <startothers+0xaf>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103b62:	e8 5c f2 ff ff       	call   80102dc3 <kalloc>
80103b67:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6d:	83 e8 04             	sub    $0x4,%eax
80103b70:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103b73:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103b79:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7e:	83 e8 08             	sub    $0x8,%eax
80103b81:	c7 00 bc 3a 10 80    	movl   $0x80103abc,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8a:	8d 50 f4             	lea    -0xc(%eax),%edx
80103b8d:	b8 00 c0 10 80       	mov    $0x8010c000,%eax
80103b92:	05 00 00 00 80       	add    $0x80000000,%eax
80103b97:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b9c:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba5:	0f b6 00             	movzbl (%eax),%eax
80103ba8:	0f b6 c0             	movzbl %al,%eax
80103bab:	89 54 24 04          	mov    %edx,0x4(%esp)
80103baf:	89 04 24             	mov    %eax,(%esp)
80103bb2:	e8 68 f6 ff ff       	call   8010321f <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bb7:	90                   	nop
80103bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbb:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103bc1:	85 c0                	test   %eax,%eax
80103bc3:	74 f3                	je     80103bb8 <startothers+0xa2>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103bc5:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103bcc:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103bd1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103bd7:	05 40 58 11 80       	add    $0x80115840,%eax
80103bdc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103bdf:	0f 87 66 ff ff ff    	ja     80103b4b <startothers+0x35>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103be5:	c9                   	leave  
80103be6:	c3                   	ret    

80103be7 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103be7:	55                   	push   %ebp
80103be8:	89 e5                	mov    %esp,%ebp
80103bea:	83 ec 14             	sub    $0x14,%esp
80103bed:	8b 45 08             	mov    0x8(%ebp),%eax
80103bf0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103bf4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103bf8:	89 c2                	mov    %eax,%edx
80103bfa:	ec                   	in     (%dx),%al
80103bfb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103bfe:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103c02:	c9                   	leave  
80103c03:	c3                   	ret    

80103c04 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103c04:	55                   	push   %ebp
80103c05:	89 e5                	mov    %esp,%ebp
80103c07:	83 ec 08             	sub    $0x8,%esp
80103c0a:	8b 55 08             	mov    0x8(%ebp),%edx
80103c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c10:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c14:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c17:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c1b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c1f:	ee                   	out    %al,(%dx)
}
80103c20:	c9                   	leave  
80103c21:	c3                   	ret    

80103c22 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103c22:	55                   	push   %ebp
80103c23:	89 e5                	mov    %esp,%ebp
80103c25:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103c28:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103c2f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103c36:	eb 15                	jmp    80103c4d <sum+0x2b>
    sum += addr[i];
80103c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103c3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3e:	01 d0                	add    %edx,%eax
80103c40:	0f b6 00             	movzbl (%eax),%eax
80103c43:	0f b6 c0             	movzbl %al,%eax
80103c46:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103c49:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103c50:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103c53:	7c e3                	jl     80103c38 <sum+0x16>
    sum += addr[i];
  return sum;
80103c55:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103c58:	c9                   	leave  
80103c59:	c3                   	ret    

80103c5a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c5a:	55                   	push   %ebp
80103c5b:	89 e5                	mov    %esp,%ebp
80103c5d:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c60:	8b 45 08             	mov    0x8(%ebp),%eax
80103c63:	05 00 00 00 80       	add    $0x80000000,%eax
80103c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c71:	01 d0                	add    %edx,%eax
80103c73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c7c:	eb 3f                	jmp    80103cbd <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c7e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c85:	00 
80103c86:	c7 44 24 04 08 9e 10 	movl   $0x80109e08,0x4(%esp)
80103c8d:	80 
80103c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c91:	89 04 24             	mov    %eax,(%esp)
80103c94:	e8 4d 28 00 00       	call   801064e6 <memcmp>
80103c99:	85 c0                	test   %eax,%eax
80103c9b:	75 1c                	jne    80103cb9 <mpsearch1+0x5f>
80103c9d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103ca4:	00 
80103ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca8:	89 04 24             	mov    %eax,(%esp)
80103cab:	e8 72 ff ff ff       	call   80103c22 <sum>
80103cb0:	84 c0                	test   %al,%al
80103cb2:	75 05                	jne    80103cb9 <mpsearch1+0x5f>
      return (struct mp*)p;
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	eb 11                	jmp    80103cca <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103cb9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103cc3:	72 b9                	jb     80103c7e <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103cca:	c9                   	leave  
80103ccb:	c3                   	ret    

80103ccc <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ccc:	55                   	push   %ebp
80103ccd:	89 e5                	mov    %esp,%ebp
80103ccf:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103cd2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cdc:	83 c0 0f             	add    $0xf,%eax
80103cdf:	0f b6 00             	movzbl (%eax),%eax
80103ce2:	0f b6 c0             	movzbl %al,%eax
80103ce5:	c1 e0 08             	shl    $0x8,%eax
80103ce8:	89 c2                	mov    %eax,%edx
80103cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ced:	83 c0 0e             	add    $0xe,%eax
80103cf0:	0f b6 00             	movzbl (%eax),%eax
80103cf3:	0f b6 c0             	movzbl %al,%eax
80103cf6:	09 d0                	or     %edx,%eax
80103cf8:	c1 e0 04             	shl    $0x4,%eax
80103cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d02:	74 21                	je     80103d25 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103d04:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103d0b:	00 
80103d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d0f:	89 04 24             	mov    %eax,(%esp)
80103d12:	e8 43 ff ff ff       	call   80103c5a <mpsearch1>
80103d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d1e:	74 50                	je     80103d70 <mpsearch+0xa4>
      return mp;
80103d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d23:	eb 5f                	jmp    80103d84 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d28:	83 c0 14             	add    $0x14,%eax
80103d2b:	0f b6 00             	movzbl (%eax),%eax
80103d2e:	0f b6 c0             	movzbl %al,%eax
80103d31:	c1 e0 08             	shl    $0x8,%eax
80103d34:	89 c2                	mov    %eax,%edx
80103d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d39:	83 c0 13             	add    $0x13,%eax
80103d3c:	0f b6 00             	movzbl (%eax),%eax
80103d3f:	0f b6 c0             	movzbl %al,%eax
80103d42:	09 d0                	or     %edx,%eax
80103d44:	c1 e0 0a             	shl    $0xa,%eax
80103d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4d:	2d 00 04 00 00       	sub    $0x400,%eax
80103d52:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103d59:	00 
80103d5a:	89 04 24             	mov    %eax,(%esp)
80103d5d:	e8 f8 fe ff ff       	call   80103c5a <mpsearch1>
80103d62:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103d69:	74 05                	je     80103d70 <mpsearch+0xa4>
      return mp;
80103d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103d6e:	eb 14                	jmp    80103d84 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103d70:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103d77:	00 
80103d78:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103d7f:	e8 d6 fe ff ff       	call   80103c5a <mpsearch1>
}
80103d84:	c9                   	leave  
80103d85:	c3                   	ret    

80103d86 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d86:	55                   	push   %ebp
80103d87:	89 e5                	mov    %esp,%ebp
80103d89:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d8c:	e8 3b ff ff ff       	call   80103ccc <mpsearch>
80103d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d98:	74 0a                	je     80103da4 <mpconfig+0x1e>
80103d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9d:	8b 40 04             	mov    0x4(%eax),%eax
80103da0:	85 c0                	test   %eax,%eax
80103da2:	75 0a                	jne    80103dae <mpconfig+0x28>
    return 0;
80103da4:	b8 00 00 00 00       	mov    $0x0,%eax
80103da9:	e9 80 00 00 00       	jmp    80103e2e <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db1:	8b 40 04             	mov    0x4(%eax),%eax
80103db4:	05 00 00 00 80       	add    $0x80000000,%eax
80103db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103dbc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103dc3:	00 
80103dc4:	c7 44 24 04 0d 9e 10 	movl   $0x80109e0d,0x4(%esp)
80103dcb:	80 
80103dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dcf:	89 04 24             	mov    %eax,(%esp)
80103dd2:	e8 0f 27 00 00       	call   801064e6 <memcmp>
80103dd7:	85 c0                	test   %eax,%eax
80103dd9:	74 07                	je     80103de2 <mpconfig+0x5c>
    return 0;
80103ddb:	b8 00 00 00 00       	mov    $0x0,%eax
80103de0:	eb 4c                	jmp    80103e2e <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de5:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103de9:	3c 01                	cmp    $0x1,%al
80103deb:	74 12                	je     80103dff <mpconfig+0x79>
80103ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df0:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103df4:	3c 04                	cmp    $0x4,%al
80103df6:	74 07                	je     80103dff <mpconfig+0x79>
    return 0;
80103df8:	b8 00 00 00 00       	mov    $0x0,%eax
80103dfd:	eb 2f                	jmp    80103e2e <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e02:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e06:	0f b7 c0             	movzwl %ax,%eax
80103e09:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e10:	89 04 24             	mov    %eax,(%esp)
80103e13:	e8 0a fe ff ff       	call   80103c22 <sum>
80103e18:	84 c0                	test   %al,%al
80103e1a:	74 07                	je     80103e23 <mpconfig+0x9d>
    return 0;
80103e1c:	b8 00 00 00 00       	mov    $0x0,%eax
80103e21:	eb 0b                	jmp    80103e2e <mpconfig+0xa8>
  *pmp = mp;
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103e29:	89 10                	mov    %edx,(%eax)
  return conf;
80103e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103e2e:	c9                   	leave  
80103e2f:	c3                   	ret    

80103e30 <mpinit>:

void
mpinit(void)
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103e36:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103e39:	89 04 24             	mov    %eax,(%esp)
80103e3c:	e8 45 ff ff ff       	call   80103d86 <mpconfig>
80103e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103e44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103e48:	75 05                	jne    80103e4f <mpinit+0x1f>
    return;
80103e4a:	e9 23 01 00 00       	jmp    80103f72 <mpinit+0x142>
  ismp = 1;
80103e4f:	c7 05 24 58 11 80 01 	movl   $0x1,0x80115824
80103e56:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e5c:	8b 40 24             	mov    0x24(%eax),%eax
80103e5f:	a3 3c 57 11 80       	mov    %eax,0x8011573c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e67:	83 c0 2c             	add    $0x2c,%eax
80103e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e70:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e74:	0f b7 d0             	movzwl %ax,%edx
80103e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e7a:	01 d0                	add    %edx,%eax
80103e7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e7f:	eb 7e                	jmp    80103eff <mpinit+0xcf>
    switch(*p){
80103e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e84:	0f b6 00             	movzbl (%eax),%eax
80103e87:	0f b6 c0             	movzbl %al,%eax
80103e8a:	83 f8 04             	cmp    $0x4,%eax
80103e8d:	77 65                	ja     80103ef4 <mpinit+0xc4>
80103e8f:	8b 04 85 14 9e 10 80 	mov    -0x7fef61ec(,%eax,4),%eax
80103e96:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu < NCPU) {
80103e9e:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103ea3:	83 f8 07             	cmp    $0x7,%eax
80103ea6:	7f 28                	jg     80103ed0 <mpinit+0xa0>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103ea8:	8b 15 20 5e 11 80    	mov    0x80115e20,%edx
80103eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103eb1:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103eb5:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103ebb:	81 c2 40 58 11 80    	add    $0x80115840,%edx
80103ec1:	88 02                	mov    %al,(%edx)
        ncpu++;
80103ec3:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103ec8:	83 c0 01             	add    $0x1,%eax
80103ecb:	a3 20 5e 11 80       	mov    %eax,0x80115e20
      }
      p += sizeof(struct mpproc);
80103ed0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ed4:	eb 29                	jmp    80103eff <mpinit+0xcf>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103edf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ee3:	a2 20 58 11 80       	mov    %al,0x80115820
      p += sizeof(struct mpioapic);
80103ee8:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103eec:	eb 11                	jmp    80103eff <mpinit+0xcf>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103eee:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ef2:	eb 0b                	jmp    80103eff <mpinit+0xcf>
    default:
      ismp = 0;
80103ef4:	c7 05 24 58 11 80 00 	movl   $0x0,0x80115824
80103efb:	00 00 00 
      break;
80103efe:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f05:	0f 82 76 ff ff ff    	jb     80103e81 <mpinit+0x51>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103f0b:	a1 24 58 11 80       	mov    0x80115824,%eax
80103f10:	85 c0                	test   %eax,%eax
80103f12:	75 1d                	jne    80103f31 <mpinit+0x101>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f14:	c7 05 20 5e 11 80 01 	movl   $0x1,0x80115e20
80103f1b:	00 00 00 
    lapic = 0;
80103f1e:	c7 05 3c 57 11 80 00 	movl   $0x0,0x8011573c
80103f25:	00 00 00 
    ioapicid = 0;
80103f28:	c6 05 20 58 11 80 00 	movb   $0x0,0x80115820
    return;
80103f2f:	eb 41                	jmp    80103f72 <mpinit+0x142>
  }

  if(mp->imcrp){
80103f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f34:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f38:	84 c0                	test   %al,%al
80103f3a:	74 36                	je     80103f72 <mpinit+0x142>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f3c:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103f43:	00 
80103f44:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103f4b:	e8 b4 fc ff ff       	call   80103c04 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f50:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103f57:	e8 8b fc ff ff       	call   80103be7 <inb>
80103f5c:	83 c8 01             	or     $0x1,%eax
80103f5f:	0f b6 c0             	movzbl %al,%eax
80103f62:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f66:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103f6d:	e8 92 fc ff ff       	call   80103c04 <outb>
  }
}
80103f72:	c9                   	leave  
80103f73:	c3                   	ret    

80103f74 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	83 ec 08             	sub    $0x8,%esp
80103f7a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f80:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f84:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f87:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f8b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f8f:	ee                   	out    %al,(%dx)
}
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    

80103f92 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f92:	55                   	push   %ebp
80103f93:	89 e5                	mov    %esp,%ebp
80103f95:	83 ec 0c             	sub    $0xc,%esp
80103f98:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f9f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fa3:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103fa9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fad:	0f b6 c0             	movzbl %al,%eax
80103fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fb4:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103fbb:	e8 b4 ff ff ff       	call   80103f74 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103fc0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fc4:	66 c1 e8 08          	shr    $0x8,%ax
80103fc8:	0f b6 c0             	movzbl %al,%eax
80103fcb:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fcf:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103fd6:	e8 99 ff ff ff       	call   80103f74 <outb>
}
80103fdb:	c9                   	leave  
80103fdc:	c3                   	ret    

80103fdd <picenable>:

void
picenable(int irq)
{
80103fdd:	55                   	push   %ebp
80103fde:	89 e5                	mov    %esp,%ebp
80103fe0:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe6:	ba 01 00 00 00       	mov    $0x1,%edx
80103feb:	89 c1                	mov    %eax,%ecx
80103fed:	d3 e2                	shl    %cl,%edx
80103fef:	89 d0                	mov    %edx,%eax
80103ff1:	f7 d0                	not    %eax
80103ff3:	89 c2                	mov    %eax,%edx
80103ff5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103ffc:	21 d0                	and    %edx,%eax
80103ffe:	0f b7 c0             	movzwl %ax,%eax
80104001:	89 04 24             	mov    %eax,(%esp)
80104004:	e8 89 ff ff ff       	call   80103f92 <picsetmask>
}
80104009:	c9                   	leave  
8010400a:	c3                   	ret    

8010400b <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010400b:	55                   	push   %ebp
8010400c:	89 e5                	mov    %esp,%ebp
8010400e:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104011:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80104018:	00 
80104019:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104020:	e8 4f ff ff ff       	call   80103f74 <outb>
  outb(IO_PIC2+1, 0xFF);
80104025:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
8010402c:	00 
8010402d:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80104034:	e8 3b ff ff ff       	call   80103f74 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80104039:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80104040:	00 
80104041:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80104048:	e8 27 ff ff ff       	call   80103f74 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
8010404d:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80104054:	00 
80104055:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
8010405c:	e8 13 ff ff ff       	call   80103f74 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104061:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80104068:	00 
80104069:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104070:	e8 ff fe ff ff       	call   80103f74 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104075:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010407c:	00 
8010407d:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80104084:	e8 eb fe ff ff       	call   80103f74 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80104089:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80104090:	00 
80104091:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80104098:	e8 d7 fe ff ff       	call   80103f74 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
8010409d:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
801040a4:	00 
801040a5:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040ac:	e8 c3 fe ff ff       	call   80103f74 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801040b1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801040b8:	00 
801040b9:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040c0:	e8 af fe ff ff       	call   80103f74 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801040c5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801040cc:	00 
801040cd:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
801040d4:	e8 9b fe ff ff       	call   80103f74 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801040d9:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
801040e0:	00 
801040e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801040e8:	e8 87 fe ff ff       	call   80103f74 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
801040ed:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801040f4:	00 
801040f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801040fc:	e8 73 fe ff ff       	call   80103f74 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80104101:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80104108:	00 
80104109:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80104110:	e8 5f fe ff ff       	call   80103f74 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80104115:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
8010411c:	00 
8010411d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80104124:	e8 4b fe ff ff       	call   80103f74 <outb>

  if(irqmask != 0xFFFF)
80104129:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104130:	66 83 f8 ff          	cmp    $0xffff,%ax
80104134:	74 12                	je     80104148 <picinit+0x13d>
    picsetmask(irqmask);
80104136:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010413d:	0f b7 c0             	movzwl %ax,%eax
80104140:	89 04 24             	mov    %eax,(%esp)
80104143:	e8 4a fe ff ff       	call   80103f92 <picsetmask>
}
80104148:	c9                   	leave  
80104149:	c3                   	ret    

8010414a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010414a:	55                   	push   %ebp
8010414b:	89 e5                	mov    %esp,%ebp
8010414d:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80104150:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104160:	8b 45 0c             	mov    0xc(%ebp),%eax
80104163:	8b 10                	mov    (%eax),%edx
80104165:	8b 45 08             	mov    0x8(%ebp),%eax
80104168:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010416a:	e8 2b ce ff ff       	call   80100f9a <filealloc>
8010416f:	8b 55 08             	mov    0x8(%ebp),%edx
80104172:	89 02                	mov    %eax,(%edx)
80104174:	8b 45 08             	mov    0x8(%ebp),%eax
80104177:	8b 00                	mov    (%eax),%eax
80104179:	85 c0                	test   %eax,%eax
8010417b:	0f 84 c8 00 00 00    	je     80104249 <pipealloc+0xff>
80104181:	e8 14 ce ff ff       	call   80100f9a <filealloc>
80104186:	8b 55 0c             	mov    0xc(%ebp),%edx
80104189:	89 02                	mov    %eax,(%edx)
8010418b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	85 c0                	test   %eax,%eax
80104192:	0f 84 b1 00 00 00    	je     80104249 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104198:	e8 26 ec ff ff       	call   80102dc3 <kalloc>
8010419d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801041a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041a4:	75 05                	jne    801041ab <pipealloc+0x61>
    goto bad;
801041a6:	e9 9e 00 00 00       	jmp    80104249 <pipealloc+0xff>
  p->readopen = 1;
801041ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ae:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801041b5:	00 00 00 
  p->writeopen = 1;
801041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bb:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801041c2:	00 00 00 
  p->nwrite = 0;
801041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801041cf:	00 00 00 
  p->nread = 0;
801041d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801041dc:	00 00 00 
  initlock(&p->lock, "pipe");
801041df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e2:	c7 44 24 04 28 9e 10 	movl   $0x80109e28,0x4(%esp)
801041e9:	80 
801041ea:	89 04 24             	mov    %eax,(%esp)
801041ed:	e8 f3 1f 00 00       	call   801061e5 <initlock>
  (*f0)->type = FD_PIPE;
801041f2:	8b 45 08             	mov    0x8(%ebp),%eax
801041f5:	8b 00                	mov    (%eax),%eax
801041f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104200:	8b 00                	mov    (%eax),%eax
80104202:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104206:	8b 45 08             	mov    0x8(%ebp),%eax
80104209:	8b 00                	mov    (%eax),%eax
8010420b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010420f:	8b 45 08             	mov    0x8(%ebp),%eax
80104212:	8b 00                	mov    (%eax),%eax
80104214:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104217:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010421a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421d:	8b 00                	mov    (%eax),%eax
8010421f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104225:	8b 45 0c             	mov    0xc(%ebp),%eax
80104228:	8b 00                	mov    (%eax),%eax
8010422a:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010422e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104231:	8b 00                	mov    (%eax),%eax
80104233:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104237:	8b 45 0c             	mov    0xc(%ebp),%eax
8010423a:	8b 00                	mov    (%eax),%eax
8010423c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423f:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104242:	b8 00 00 00 00       	mov    $0x0,%eax
80104247:	eb 42                	jmp    8010428b <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80104249:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010424d:	74 0b                	je     8010425a <pipealloc+0x110>
    kfree((char*)p);
8010424f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104252:	89 04 24             	mov    %eax,(%esp)
80104255:	e8 d3 ea ff ff       	call   80102d2d <kfree>
  if(*f0)
8010425a:	8b 45 08             	mov    0x8(%ebp),%eax
8010425d:	8b 00                	mov    (%eax),%eax
8010425f:	85 c0                	test   %eax,%eax
80104261:	74 0d                	je     80104270 <pipealloc+0x126>
    fileclose(*f0);
80104263:	8b 45 08             	mov    0x8(%ebp),%eax
80104266:	8b 00                	mov    (%eax),%eax
80104268:	89 04 24             	mov    %eax,(%esp)
8010426b:	e8 d2 cd ff ff       	call   80101042 <fileclose>
  if(*f1)
80104270:	8b 45 0c             	mov    0xc(%ebp),%eax
80104273:	8b 00                	mov    (%eax),%eax
80104275:	85 c0                	test   %eax,%eax
80104277:	74 0d                	je     80104286 <pipealloc+0x13c>
    fileclose(*f1);
80104279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010427c:	8b 00                	mov    (%eax),%eax
8010427e:	89 04 24             	mov    %eax,(%esp)
80104281:	e8 bc cd ff ff       	call   80101042 <fileclose>
  return -1;
80104286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010428b:	c9                   	leave  
8010428c:	c3                   	ret    

8010428d <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010428d:	55                   	push   %ebp
8010428e:	89 e5                	mov    %esp,%ebp
80104290:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80104293:	8b 45 08             	mov    0x8(%ebp),%eax
80104296:	89 04 24             	mov    %eax,(%esp)
80104299:	e8 68 1f 00 00       	call   80106206 <acquire>
  if(writable){
8010429e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801042a2:	74 1f                	je     801042c3 <pipeclose+0x36>
    p->writeopen = 0;
801042a4:	8b 45 08             	mov    0x8(%ebp),%eax
801042a7:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801042ae:	00 00 00 
    wakeup(&p->nread);
801042b1:	8b 45 08             	mov    0x8(%ebp),%eax
801042b4:	05 34 02 00 00       	add    $0x234,%eax
801042b9:	89 04 24             	mov    %eax,(%esp)
801042bc:	e8 4f 16 00 00       	call   80105910 <wakeup>
801042c1:	eb 1d                	jmp    801042e0 <pipeclose+0x53>
  } else {
    p->readopen = 0;
801042c3:	8b 45 08             	mov    0x8(%ebp),%eax
801042c6:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801042cd:	00 00 00 
    wakeup(&p->nwrite);
801042d0:	8b 45 08             	mov    0x8(%ebp),%eax
801042d3:	05 38 02 00 00       	add    $0x238,%eax
801042d8:	89 04 24             	mov    %eax,(%esp)
801042db:	e8 30 16 00 00       	call   80105910 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801042e0:	8b 45 08             	mov    0x8(%ebp),%eax
801042e3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042e9:	85 c0                	test   %eax,%eax
801042eb:	75 25                	jne    80104312 <pipeclose+0x85>
801042ed:	8b 45 08             	mov    0x8(%ebp),%eax
801042f0:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042f6:	85 c0                	test   %eax,%eax
801042f8:	75 18                	jne    80104312 <pipeclose+0x85>
    release(&p->lock);
801042fa:	8b 45 08             	mov    0x8(%ebp),%eax
801042fd:	89 04 24             	mov    %eax,(%esp)
80104300:	e8 68 1f 00 00       	call   8010626d <release>
    kfree((char*)p);
80104305:	8b 45 08             	mov    0x8(%ebp),%eax
80104308:	89 04 24             	mov    %eax,(%esp)
8010430b:	e8 1d ea ff ff       	call   80102d2d <kfree>
80104310:	eb 0b                	jmp    8010431d <pipeclose+0x90>
  } else
    release(&p->lock);
80104312:	8b 45 08             	mov    0x8(%ebp),%eax
80104315:	89 04 24             	mov    %eax,(%esp)
80104318:	e8 50 1f 00 00       	call   8010626d <release>
}
8010431d:	c9                   	leave  
8010431e:	c3                   	ret    

8010431f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010431f:	55                   	push   %ebp
80104320:	89 e5                	mov    %esp,%ebp
80104322:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
80104328:	89 04 24             	mov    %eax,(%esp)
8010432b:	e8 d6 1e 00 00       	call   80106206 <acquire>
  for(i = 0; i < n; i++){
80104330:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104337:	e9 a6 00 00 00       	jmp    801043e2 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010433c:	eb 57                	jmp    80104395 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
8010433e:	8b 45 08             	mov    0x8(%ebp),%eax
80104341:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104347:	85 c0                	test   %eax,%eax
80104349:	74 0d                	je     80104358 <pipewrite+0x39>
8010434b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104351:	8b 40 24             	mov    0x24(%eax),%eax
80104354:	85 c0                	test   %eax,%eax
80104356:	74 15                	je     8010436d <pipewrite+0x4e>
        release(&p->lock);
80104358:	8b 45 08             	mov    0x8(%ebp),%eax
8010435b:	89 04 24             	mov    %eax,(%esp)
8010435e:	e8 0a 1f 00 00       	call   8010626d <release>
        return -1;
80104363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104368:	e9 9f 00 00 00       	jmp    8010440c <pipewrite+0xed>
      }
      wakeup(&p->nread);
8010436d:	8b 45 08             	mov    0x8(%ebp),%eax
80104370:	05 34 02 00 00       	add    $0x234,%eax
80104375:	89 04 24             	mov    %eax,(%esp)
80104378:	e8 93 15 00 00       	call   80105910 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010437d:	8b 45 08             	mov    0x8(%ebp),%eax
80104380:	8b 55 08             	mov    0x8(%ebp),%edx
80104383:	81 c2 38 02 00 00    	add    $0x238,%edx
80104389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010438d:	89 14 24             	mov    %edx,(%esp)
80104390:	e8 71 14 00 00       	call   80105806 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104395:	8b 45 08             	mov    0x8(%ebp),%eax
80104398:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010439e:	8b 45 08             	mov    0x8(%ebp),%eax
801043a1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043a7:	05 00 02 00 00       	add    $0x200,%eax
801043ac:	39 c2                	cmp    %eax,%edx
801043ae:	74 8e                	je     8010433e <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801043b0:	8b 45 08             	mov    0x8(%ebp),%eax
801043b3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043b9:	8d 48 01             	lea    0x1(%eax),%ecx
801043bc:	8b 55 08             	mov    0x8(%ebp),%edx
801043bf:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801043c5:	25 ff 01 00 00       	and    $0x1ff,%eax
801043ca:	89 c1                	mov    %eax,%ecx
801043cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801043d2:	01 d0                	add    %edx,%eax
801043d4:	0f b6 10             	movzbl (%eax),%edx
801043d7:	8b 45 08             	mov    0x8(%ebp),%eax
801043da:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e5:	3b 45 10             	cmp    0x10(%ebp),%eax
801043e8:	0f 8c 4e ff ff ff    	jl     8010433c <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043ee:	8b 45 08             	mov    0x8(%ebp),%eax
801043f1:	05 34 02 00 00       	add    $0x234,%eax
801043f6:	89 04 24             	mov    %eax,(%esp)
801043f9:	e8 12 15 00 00       	call   80105910 <wakeup>
  release(&p->lock);
801043fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104401:	89 04 24             	mov    %eax,(%esp)
80104404:	e8 64 1e 00 00       	call   8010626d <release>
  return n;
80104409:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010440c:	c9                   	leave  
8010440d:	c3                   	ret    

8010440e <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010440e:	55                   	push   %ebp
8010440f:	89 e5                	mov    %esp,%ebp
80104411:	53                   	push   %ebx
80104412:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104415:	8b 45 08             	mov    0x8(%ebp),%eax
80104418:	89 04 24             	mov    %eax,(%esp)
8010441b:	e8 e6 1d 00 00       	call   80106206 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104420:	eb 3a                	jmp    8010445c <piperead+0x4e>
    if(proc->killed){
80104422:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104428:	8b 40 24             	mov    0x24(%eax),%eax
8010442b:	85 c0                	test   %eax,%eax
8010442d:	74 15                	je     80104444 <piperead+0x36>
      release(&p->lock);
8010442f:	8b 45 08             	mov    0x8(%ebp),%eax
80104432:	89 04 24             	mov    %eax,(%esp)
80104435:	e8 33 1e 00 00       	call   8010626d <release>
      return -1;
8010443a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443f:	e9 b5 00 00 00       	jmp    801044f9 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104444:	8b 45 08             	mov    0x8(%ebp),%eax
80104447:	8b 55 08             	mov    0x8(%ebp),%edx
8010444a:	81 c2 34 02 00 00    	add    $0x234,%edx
80104450:	89 44 24 04          	mov    %eax,0x4(%esp)
80104454:	89 14 24             	mov    %edx,(%esp)
80104457:	e8 aa 13 00 00       	call   80105806 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010445c:	8b 45 08             	mov    0x8(%ebp),%eax
8010445f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104465:	8b 45 08             	mov    0x8(%ebp),%eax
80104468:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010446e:	39 c2                	cmp    %eax,%edx
80104470:	75 0d                	jne    8010447f <piperead+0x71>
80104472:	8b 45 08             	mov    0x8(%ebp),%eax
80104475:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010447b:	85 c0                	test   %eax,%eax
8010447d:	75 a3                	jne    80104422 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010447f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104486:	eb 4b                	jmp    801044d3 <piperead+0xc5>
    if(p->nread == p->nwrite)
80104488:	8b 45 08             	mov    0x8(%ebp),%eax
8010448b:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104491:	8b 45 08             	mov    0x8(%ebp),%eax
80104494:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010449a:	39 c2                	cmp    %eax,%edx
8010449c:	75 02                	jne    801044a0 <piperead+0x92>
      break;
8010449e:	eb 3b                	jmp    801044db <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801044a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801044a6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801044a9:	8b 45 08             	mov    0x8(%ebp),%eax
801044ac:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801044b2:	8d 48 01             	lea    0x1(%eax),%ecx
801044b5:	8b 55 08             	mov    0x8(%ebp),%edx
801044b8:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801044be:	25 ff 01 00 00       	and    $0x1ff,%eax
801044c3:	89 c2                	mov    %eax,%edx
801044c5:	8b 45 08             	mov    0x8(%ebp),%eax
801044c8:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044cd:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d6:	3b 45 10             	cmp    0x10(%ebp),%eax
801044d9:	7c ad                	jl     80104488 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044db:	8b 45 08             	mov    0x8(%ebp),%eax
801044de:	05 38 02 00 00       	add    $0x238,%eax
801044e3:	89 04 24             	mov    %eax,(%esp)
801044e6:	e8 25 14 00 00       	call   80105910 <wakeup>
  release(&p->lock);
801044eb:	8b 45 08             	mov    0x8(%ebp),%eax
801044ee:	89 04 24             	mov    %eax,(%esp)
801044f1:	e8 77 1d 00 00       	call   8010626d <release>
  return i;
801044f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044f9:	83 c4 24             	add    $0x24,%esp
801044fc:	5b                   	pop    %ebx
801044fd:	5d                   	pop    %ebp
801044fe:	c3                   	ret    

801044ff <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044ff:	55                   	push   %ebp
80104500:	89 e5                	mov    %esp,%ebp
80104502:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104505:	9c                   	pushf  
80104506:	58                   	pop    %eax
80104507:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010450a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010450d:	c9                   	leave  
8010450e:	c3                   	ret    

8010450f <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010450f:	55                   	push   %ebp
80104510:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104512:	fb                   	sti    
}
80104513:	5d                   	pop    %ebp
80104514:	c3                   	ret    

80104515 <pinit>:
int lev; //checing current level
int totalShare;

void
pinit(void)
{
80104515:	55                   	push   %ebp
80104516:	89 e5                	mov    %esp,%ebp
80104518:	83 ec 18             	sub    $0x18,%esp
    initlock(&ptable.lock, "ptable");
8010451b:	c7 44 24 04 2d 9e 10 	movl   $0x80109e2d,0x4(%esp)
80104522:	80 
80104523:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
8010452a:	e8 b6 1c 00 00       	call   801061e5 <initlock>
}
8010452f:	c9                   	leave  
80104530:	c3                   	ret    

80104531 <IsEmpty>:

int IsEmpty(Queue Q){
80104531:	55                   	push   %ebp
80104532:	89 e5                	mov    %esp,%ebp
    return (Q->qsize == 0);
80104534:	8b 45 08             	mov    0x8(%ebp),%eax
80104537:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
8010453d:	85 c0                	test   %eax,%eax
8010453f:	0f 94 c0             	sete   %al
80104542:	0f b6 c0             	movzbl %al,%eax
}
80104545:	5d                   	pop    %ebp
80104546:	c3                   	ret    

80104547 <IsFull>:

int IsFull(Queue Q){
80104547:	55                   	push   %ebp
80104548:	89 e5                	mov    %esp,%ebp
    return (Q->qsize == 64);
8010454a:	8b 45 08             	mov    0x8(%ebp),%eax
8010454d:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
80104553:	83 f8 40             	cmp    $0x40,%eax
80104556:	0f 94 c0             	sete   %al
80104559:	0f b6 c0             	movzbl %al,%eax
}
8010455c:	5d                   	pop    %ebp
8010455d:	c3                   	ret    

8010455e <Dequeue>:

struct proc *Dequeue(Queue Q){
8010455e:	55                   	push   %ebp
8010455f:	89 e5                	mov    %esp,%ebp
80104561:	83 ec 10             	sub    $0x10,%esp
    int tmp = Q->front;
80104564:	8b 45 08             	mov    0x8(%ebp),%eax
80104567:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
8010456d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    Q->front = ((Q->front)+1) % 64;
80104570:	8b 45 08             	mov    0x8(%ebp),%eax
80104573:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
80104579:	8d 50 01             	lea    0x1(%eax),%edx
8010457c:	89 d0                	mov    %edx,%eax
8010457e:	c1 f8 1f             	sar    $0x1f,%eax
80104581:	c1 e8 1a             	shr    $0x1a,%eax
80104584:	01 c2                	add    %eax,%edx
80104586:	83 e2 3f             	and    $0x3f,%edx
80104589:	29 c2                	sub    %eax,%edx
8010458b:	89 d0                	mov    %edx,%eax
8010458d:	89 c2                	mov    %eax,%edx
8010458f:	8b 45 08             	mov    0x8(%ebp),%eax
80104592:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
    Q->qsize--;
80104598:	8b 45 08             	mov    0x8(%ebp),%eax
8010459b:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
801045a1:	8d 50 ff             	lea    -0x1(%eax),%edx
801045a4:	8b 45 08             	mov    0x8(%ebp),%eax
801045a7:	89 90 08 01 00 00    	mov    %edx,0x108(%eax)
    return Q->proc[tmp];
801045ad:	8b 45 08             	mov    0x8(%ebp),%eax
801045b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801045b3:	8b 04 90             	mov    (%eax,%edx,4),%eax
}
801045b6:	c9                   	leave  
801045b7:	c3                   	ret    

801045b8 <Enqueue>:

void Enqueue(Queue Q, struct proc * X){
801045b8:	55                   	push   %ebp
801045b9:	89 e5                	mov    %esp,%ebp
    Q->qsize++;
801045bb:	8b 45 08             	mov    0x8(%ebp),%eax
801045be:	8b 80 08 01 00 00    	mov    0x108(%eax),%eax
801045c4:	8d 50 01             	lea    0x1(%eax),%edx
801045c7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ca:	89 90 08 01 00 00    	mov    %edx,0x108(%eax)
    Q->rear = (Q->rear+1)%64;
801045d0:	8b 45 08             	mov    0x8(%ebp),%eax
801045d3:	8b 80 04 01 00 00    	mov    0x104(%eax),%eax
801045d9:	8d 50 01             	lea    0x1(%eax),%edx
801045dc:	89 d0                	mov    %edx,%eax
801045de:	c1 f8 1f             	sar    $0x1f,%eax
801045e1:	c1 e8 1a             	shr    $0x1a,%eax
801045e4:	01 c2                	add    %eax,%edx
801045e6:	83 e2 3f             	and    $0x3f,%edx
801045e9:	29 c2                	sub    %eax,%edx
801045eb:	89 d0                	mov    %edx,%eax
801045ed:	89 c2                	mov    %eax,%edx
801045ef:	8b 45 08             	mov    0x8(%ebp),%eax
801045f2:	89 90 04 01 00 00    	mov    %edx,0x104(%eax)
    Q->proc[Q->rear] = X;
801045f8:	8b 45 08             	mov    0x8(%ebp),%eax
801045fb:	8b 90 04 01 00 00    	mov    0x104(%eax),%edx
80104601:	8b 45 08             	mov    0x8(%ebp),%eax
80104604:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104607:	89 0c 90             	mov    %ecx,(%eax,%edx,4)
}
8010460a:	5d                   	pop    %ebp
8010460b:	c3                   	ret    

8010460c <priorityBoost>:

void priorityBoost(){
8010460c:	55                   	push   %ebp
8010460d:	89 e5                	mov    %esp,%ebp
8010460f:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
   // cprintf("do boosting\n");
    while(!IsEmpty(&priority[1])){//boosting priority[1]
80104612:	eb 39                	jmp    8010464d <priorityBoost+0x41>
        p = Dequeue(&priority[1]);
80104614:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
8010461b:	e8 3e ff ff ff       	call   8010455e <Dequeue>
80104620:	89 45 fc             	mov    %eax,-0x4(%ebp)
        Enqueue(&priority[0],p);
80104623:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104626:	89 44 24 04          	mov    %eax,0x4(%esp)
8010462a:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
80104631:	e8 82 ff ff ff       	call   801045b8 <Enqueue>
        p->level = 0;
80104636:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104639:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104640:	00 00 00 
        p->cnt = 5;
80104643:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104646:	c7 40 7c 05 00 00 00 	movl   $0x5,0x7c(%eax)
}

void priorityBoost(){
    struct proc *p;
   // cprintf("do boosting\n");
    while(!IsEmpty(&priority[1])){//boosting priority[1]
8010464d:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
80104654:	e8 d8 fe ff ff       	call   80104531 <IsEmpty>
80104659:	85 c0                	test   %eax,%eax
8010465b:	74 b7                	je     80104614 <priorityBoost+0x8>
        p = Dequeue(&priority[1]);
        Enqueue(&priority[0],p);
        p->level = 0;
        p->cnt = 5;
    }
    while(!IsEmpty(&priority[2])){//boosting priority[2]
8010465d:	eb 39                	jmp    80104698 <priorityBoost+0x8c>
        p = Dequeue(&priority[2]);
8010465f:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
80104666:	e8 f3 fe ff ff       	call   8010455e <Dequeue>
8010466b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        Enqueue(&priority[0],p);
8010466e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104671:	89 44 24 04          	mov    %eax,0x4(%esp)
80104675:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
8010467c:	e8 37 ff ff ff       	call   801045b8 <Enqueue>
        p->level = 0;
80104681:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104684:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010468b:	00 00 00 
        p->cnt = 5;
8010468e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104691:	c7 40 7c 05 00 00 00 	movl   $0x5,0x7c(%eax)
        p = Dequeue(&priority[1]);
        Enqueue(&priority[0],p);
        p->level = 0;
        p->cnt = 5;
    }
    while(!IsEmpty(&priority[2])){//boosting priority[2]
80104698:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
8010469f:	e8 8d fe ff ff       	call   80104531 <IsEmpty>
801046a4:	85 c0                	test   %eax,%eax
801046a6:	74 b7                	je     8010465f <priorityBoost+0x53>
        p = Dequeue(&priority[2]);
        Enqueue(&priority[0],p);
        p->level = 0;
        p->cnt = 5;
    }
}
801046a8:	c9                   	leave  
801046a9:	c3                   	ret    

801046aa <boostFlagOn>:

void boostFlagOn() { //checking it is right time to boost
801046aa:	55                   	push   %ebp
801046ab:	89 e5                	mov    %esp,%ebp
    boostflag = 1;
801046ad:	c7 05 64 d6 10 80 01 	movl   $0x1,0x8010d664
801046b4:	00 00 00 
}
801046b7:	5d                   	pop    %ebp
801046b8:	c3                   	ret    

801046b9 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801046b9:	55                   	push   %ebp
801046ba:	89 e5                	mov    %esp,%ebp
801046bc:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
801046bf:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801046c6:	e8 3b 1b 00 00       	call   80106206 <acquire>
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046cb:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
801046d2:	eb 53                	jmp    80104727 <allocproc+0x6e>
        if(p->state == UNUSED)
801046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d7:	8b 40 0c             	mov    0xc(%eax),%eax
801046da:	85 c0                	test   %eax,%eax
801046dc:	75 42                	jne    80104720 <allocproc+0x67>
            goto found;
801046de:	90                   	nop

    release(&ptable.lock);
    return 0;

found:
    p->state = EMBRYO;
801046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e2:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    p->pid = nextpid++;
801046e9:	a1 04 d0 10 80       	mov    0x8010d004,%eax
801046ee:	8d 50 01             	lea    0x1(%eax),%edx
801046f1:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
801046f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046fa:	89 42 10             	mov    %eax,0x10(%edx)

    release(&ptable.lock);
801046fd:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104704:	e8 64 1b 00 00       	call   8010626d <release>
    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
80104709:	e8 b5 e6 ff ff       	call   80102dc3 <kalloc>
8010470e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104711:	89 42 08             	mov    %eax,0x8(%edx)
80104714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104717:	8b 40 08             	mov    0x8(%eax),%eax
8010471a:	85 c0                	test   %eax,%eax
8010471c:	75 3c                	jne    8010475a <allocproc+0xa1>
8010471e:	eb 26                	jmp    80104746 <allocproc+0x8d>
{
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104720:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80104727:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
8010472e:	72 a4                	jb     801046d4 <allocproc+0x1b>
        if(p->state == UNUSED)
            goto found;

    release(&ptable.lock);
80104730:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104737:	e8 31 1b 00 00       	call   8010626d <release>
    return 0;
8010473c:	b8 00 00 00 00       	mov    $0x0,%eax
80104741:	e9 ba 00 00 00       	jmp    80104800 <allocproc+0x147>
    p->pid = nextpid++;

    release(&ptable.lock);
    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        p->state = UNUSED;
80104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104749:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        return 0;
80104750:	b8 00 00 00 00       	mov    $0x0,%eax
80104755:	e9 a6 00 00 00       	jmp    80104800 <allocproc+0x147>
    }
    sp = p->kstack + KSTACKSIZE;
8010475a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475d:	8b 40 08             	mov    0x8(%eax),%eax
80104760:	05 00 10 00 00       	add    $0x1000,%eax
80104765:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // Leave room for trap frame.
    sp -= sizeof *p->tf;
80104768:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
8010476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104772:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
80104775:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
80104779:	ba 11 7a 10 80       	mov    $0x80107a11,%edx
8010477e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104781:	89 10                	mov    %edx,(%eax)

    //p->isThread = 0;

    sp -= sizeof *p->context;
80104783:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
80104787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010478d:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104793:	8b 40 1c             	mov    0x1c(%eax),%eax
80104796:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010479d:	00 
8010479e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801047a5:	00 
801047a6:	89 04 24             	mov    %eax,(%esp)
801047a9:	e8 c1 1c 00 00       	call   8010646f <memset>
    p->context->eip = (uint)forkret;
801047ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b1:	8b 40 1c             	mov    0x1c(%eax),%eax
801047b4:	ba c7 57 10 80       	mov    $0x801057c7,%edx
801047b9:	89 50 10             	mov    %edx,0x10(%eax)

    //Enqueue jobs to priority[0], so level is 0 and cnt(ticks) is 5
    Enqueue(&priority[0], p);
801047bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c3:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
801047ca:	e8 e9 fd ff ff       	call   801045b8 <Enqueue>
    p->level = 0;
801047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801047d9:	00 00 00 
    p->cnt = 5;
801047dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047df:	c7 40 7c 05 00 00 00 	movl   $0x5,0x7c(%eax)
    p->isStride = 0;
801047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e9:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801047f0:	00 00 00 
    noflag = 0;
801047f3:	c7 05 40 5e 11 80 00 	movl   $0x0,0x80115e40
801047fa:	00 00 00 
    
    return p;
801047fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104800:	c9                   	leave  
80104801:	c3                   	ret    

80104802 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104802:	55                   	push   %ebp
80104803:	89 e5                	mov    %esp,%ebp
80104805:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];
    
    int i;
    for(i=0;i<3;i++){//initialize queue
80104808:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010480f:	eb 42                	jmp    80104853 <userinit+0x51>
        priority[i].front = 0;
80104811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104814:	69 c0 0c 01 00 00    	imul   $0x10c,%eax,%eax
8010481a:	05 60 5f 11 80       	add    $0x80115f60,%eax
8010481f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        priority[i].rear = -1;
80104825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104828:	69 c0 0c 01 00 00    	imul   $0x10c,%eax,%eax
8010482e:	05 60 5f 11 80       	add    $0x80115f60,%eax
80104833:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        priority[i].qsize = 0;
8010483a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483d:	69 c0 0c 01 00 00    	imul   $0x10c,%eax,%eax
80104843:	05 60 5f 11 80       	add    $0x80115f60,%eax
80104848:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];
    
    int i;
    for(i=0;i<3;i++){//initialize queue
8010484f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104853:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80104857:	7e b8                	jle    80104811 <userinit+0xf>
        priority[i].front = 0;
        priority[i].rear = -1;
        priority[i].qsize = 0;
    }
    totalShare = 0;
80104859:	c7 05 84 61 11 80 00 	movl   $0x0,0x80116184
80104860:	00 00 00 

    p = allocproc();
80104863:	e8 51 fe ff ff       	call   801046b9 <allocproc>
80104868:	89 45 f0             	mov    %eax,-0x10(%ebp)
    initproc = p;
8010486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010486e:	a3 70 d6 10 80       	mov    %eax,0x8010d670
    if((p->pgdir = setupkvm()) == 0)
80104873:	e8 93 49 00 00       	call   8010920b <setupkvm>
80104878:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010487b:	89 42 04             	mov    %eax,0x4(%edx)
8010487e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104881:	8b 40 04             	mov    0x4(%eax),%eax
80104884:	85 c0                	test   %eax,%eax
80104886:	75 0c                	jne    80104894 <userinit+0x92>
        panic("userinit: out of memory?");
80104888:	c7 04 24 34 9e 10 80 	movl   $0x80109e34,(%esp)
8010488f:	e8 ce bc ff ff       	call   80100562 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104894:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010489c:	8b 40 04             	mov    0x4(%eax),%eax
8010489f:	89 54 24 08          	mov    %edx,0x8(%esp)
801048a3:	c7 44 24 04 00 d5 10 	movl   $0x8010d500,0x4(%esp)
801048aa:	80 
801048ab:	89 04 24             	mov    %eax,(%esp)
801048ae:	e8 b8 4b 00 00       	call   8010946b <inituvm>
    p->sz = PGSIZE;
801048b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048b6:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801048bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048bf:	8b 40 18             	mov    0x18(%eax),%eax
801048c2:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801048c9:	00 
801048ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801048d1:	00 
801048d2:	89 04 24             	mov    %eax,(%esp)
801048d5:	e8 95 1b 00 00       	call   8010646f <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801048da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048dd:	8b 40 18             	mov    0x18(%eax),%eax
801048e0:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801048e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048e9:	8b 40 18             	mov    0x18(%eax),%eax
801048ec:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801048f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048f5:	8b 40 18             	mov    0x18(%eax),%eax
801048f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048fb:	8b 52 18             	mov    0x18(%edx),%edx
801048fe:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104902:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104909:	8b 40 18             	mov    0x18(%eax),%eax
8010490c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010490f:	8b 52 18             	mov    0x18(%edx),%edx
80104912:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104916:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
8010491a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010491d:	8b 40 18             	mov    0x18(%eax),%eax
80104920:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104927:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010492a:	8b 40 18             	mov    0x18(%eax),%eax
8010492d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104934:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104937:	8b 40 18             	mov    0x18(%eax),%eax
8010493a:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

    

    
    safestrcpy(p->name, "initcode", sizeof(p->name));
80104941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104944:	83 c0 6c             	add    $0x6c,%eax
80104947:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010494e:	00 
8010494f:	c7 44 24 04 4d 9e 10 	movl   $0x80109e4d,0x4(%esp)
80104956:	80 
80104957:	89 04 24             	mov    %eax,(%esp)
8010495a:	e8 30 1d 00 00       	call   8010668f <safestrcpy>
    p->cwd = namei("/");
8010495f:	c7 04 24 56 9e 10 80 	movl   $0x80109e56,(%esp)
80104966:	e8 21 dd ff ff       	call   8010268c <namei>
8010496b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010496e:	89 42 68             	mov    %eax,0x68(%edx)
    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
80104971:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104978:	e8 89 18 00 00       	call   80106206 <acquire>
    p->state = RUNNABLE;
8010497d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104980:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    release(&ptable.lock);
80104987:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
8010498e:	e8 da 18 00 00       	call   8010626d <release>
}
80104993:	c9                   	leave  
80104994:	c3                   	ret    

80104995 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{   
80104995:	55                   	push   %ebp
80104996:	89 e5                	mov    %esp,%ebp
80104998:	83 ec 28             	sub    $0x28,%esp
    uint sz;
    sz = proc->sz;
8010499b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a1:	8b 00                	mov    (%eax),%eax
801049a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    if(n > 0){
801049a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801049aa:	7e 34                	jle    801049e0 <growproc+0x4b>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801049ac:	8b 55 08             	mov    0x8(%ebp),%edx
801049af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b2:	01 c2                	add    %eax,%edx
801049b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ba:	8b 40 04             	mov    0x4(%eax),%eax
801049bd:	89 54 24 08          	mov    %edx,0x8(%esp)
801049c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049c4:	89 54 24 04          	mov    %edx,0x4(%esp)
801049c8:	89 04 24             	mov    %eax,(%esp)
801049cb:	e8 06 4c 00 00       	call   801095d6 <allocuvm>
801049d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049d7:	75 41                	jne    80104a1a <growproc+0x85>
            return -1;
801049d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049de:	eb 58                	jmp    80104a38 <growproc+0xa3>
    } else if(n < 0){
801049e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801049e4:	79 34                	jns    80104a1a <growproc+0x85>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801049e6:	8b 55 08             	mov    0x8(%ebp),%edx
801049e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ec:	01 c2                	add    %eax,%edx
801049ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f4:	8b 40 04             	mov    0x4(%eax),%eax
801049f7:	89 54 24 08          	mov    %edx,0x8(%esp)
801049fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a02:	89 04 24             	mov    %eax,(%esp)
80104a05:	e8 e2 4c 00 00       	call   801096ec <deallocuvm>
80104a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a11:	75 07                	jne    80104a1a <growproc+0x85>
            return -1;
80104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a18:	eb 1e                	jmp    80104a38 <growproc+0xa3>
    }
    proc->sz = sz;
80104a1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a23:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
80104a25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2b:	89 04 24             	mov    %eax,(%esp)
80104a2e:	e8 a4 48 00 00       	call   801092d7 <switchuvm>
    return 0;
80104a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a38:	c9                   	leave  
80104a39:	c3                   	ret    

80104a3a <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{   
80104a3a:	55                   	push   %ebp
80104a3b:	89 e5                	mov    %esp,%ebp
80104a3d:	57                   	push   %edi
80104a3e:	56                   	push   %esi
80104a3f:	53                   	push   %ebx
80104a40:	83 ec 2c             	sub    $0x2c,%esp
    struct proc *np;
   // cprintf("fork enter\n");

    
    // Allocate process.
    if((np = allocproc()) == 0){
80104a43:	e8 71 fc ff ff       	call   801046b9 <allocproc>
80104a48:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104a4b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104a4f:	75 0a                	jne    80104a5b <fork+0x21>
        return -1;
80104a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a56:	e9 fd 02 00 00       	jmp    80104d58 <fork+0x31e>
    }

    if(np->isThread == 1){
80104a5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a5e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a64:	83 f8 01             	cmp    $0x1,%eax
80104a67:	0f 85 7b 01 00 00    	jne    80104be8 <fork+0x1ae>
        //cprintf("isThread==1\n");
        if((np->pgdir = copyuvm(proc->parent->pgdir, proc->sz)) == 0){
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 10                	mov    (%eax),%edx
80104a75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7b:	8b 40 14             	mov    0x14(%eax),%eax
80104a7e:	8b 40 04             	mov    0x4(%eax),%eax
80104a81:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a85:	89 04 24             	mov    %eax,(%esp)
80104a88:	e8 02 4e 00 00       	call   8010988f <copyuvm>
80104a8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104a90:	89 42 04             	mov    %eax,0x4(%edx)
80104a93:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104a96:	8b 40 04             	mov    0x4(%eax),%eax
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	75 2c                	jne    80104ac9 <fork+0x8f>
            kfree(np->kstack);
80104a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aa0:	8b 40 08             	mov    0x8(%eax),%eax
80104aa3:	89 04 24             	mov    %eax,(%esp)
80104aa6:	e8 82 e2 ff ff       	call   80102d2d <kfree>
            np->kstack = 0;
80104aab:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104aae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            np->state = UNUSED;
80104ab5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ab8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            return -1;
80104abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac4:	e9 8f 02 00 00       	jmp    80104d58 <fork+0x31e>
        }
        //cprintf("after copyuvm\n");
        np->isThread = 1;
80104ac9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104acc:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
80104ad3:	00 00 00 
       // np->isParent = 1;
        np->sz = proc->parent->sz;
80104ad6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104adc:	8b 40 14             	mov    0x14(%eax),%eax
80104adf:	8b 10                	mov    (%eax),%edx
80104ae1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ae4:	89 10                	mov    %edx,(%eax)
        np->parent = proc->parent->parent;
80104ae6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aec:	8b 40 14             	mov    0x14(%eax),%eax
80104aef:	8b 50 14             	mov    0x14(%eax),%edx
80104af2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104af5:	89 50 14             	mov    %edx,0x14(%eax)
        *np->tf = *proc->parent->tf;
80104af8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104afb:	8b 50 18             	mov    0x18(%eax),%edx
80104afe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b04:	8b 40 14             	mov    0x14(%eax),%eax
80104b07:	8b 40 18             	mov    0x18(%eax),%eax
80104b0a:	89 c3                	mov    %eax,%ebx
80104b0c:	b8 13 00 00 00       	mov    $0x13,%eax
80104b11:	89 d7                	mov    %edx,%edi
80104b13:	89 de                	mov    %ebx,%esi
80104b15:	89 c1                	mov    %eax,%ecx
80104b17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        
        np->tf->eax = 0;
80104b19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104b1c:	8b 40 18             	mov    0x18(%eax),%eax
80104b1f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    
        for(i = 0; i < NOFILE; i++)
80104b26:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b2d:	eb 43                	jmp    80104b72 <fork+0x138>
            if(proc->parent->ofile[i])
80104b2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b35:	8b 40 14             	mov    0x14(%eax),%eax
80104b38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b3b:	83 c2 08             	add    $0x8,%edx
80104b3e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b42:	85 c0                	test   %eax,%eax
80104b44:	74 28                	je     80104b6e <fork+0x134>
                np->ofile[i] = filedup(proc->parent->ofile[i]);
80104b46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4c:	8b 40 14             	mov    0x14(%eax),%eax
80104b4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b52:	83 c2 08             	add    $0x8,%edx
80104b55:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 99 c4 ff ff       	call   80100ffa <filedup>
80104b61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104b64:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104b67:	83 c1 08             	add    $0x8,%ecx
80104b6a:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        *np->tf = *proc->parent->tf;
        
        np->tf->eax = 0;

    
        for(i = 0; i < NOFILE; i++)
80104b6e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b72:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b76:	7e b7                	jle    80104b2f <fork+0xf5>
            if(proc->parent->ofile[i])
                np->ofile[i] = filedup(proc->parent->ofile[i]);
        np->cwd = idup(proc->parent->cwd);
80104b78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7e:	8b 40 14             	mov    0x14(%eax),%eax
80104b81:	8b 40 68             	mov    0x68(%eax),%eax
80104b84:	89 04 24             	mov    %eax,(%esp)
80104b87:	e8 b4 cd ff ff       	call   80101940 <idup>
80104b8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104b8f:	89 42 68             	mov    %eax,0x68(%edx)
        safestrcpy(np->name, proc->parent->name, sizeof(proc->parent->name));
80104b92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b98:	8b 40 14             	mov    0x14(%eax),%eax
80104b9b:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104ba1:	83 c0 6c             	add    $0x6c,%eax
80104ba4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104bab:	00 
80104bac:	89 54 24 04          	mov    %edx,0x4(%esp)
80104bb0:	89 04 24             	mov    %eax,(%esp)
80104bb3:	e8 d7 1a 00 00       	call   8010668f <safestrcpy>
        pid = np->pid;
80104bb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bbb:	8b 40 10             	mov    0x10(%eax),%eax
80104bbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
        acquire(&ptable.lock);
80104bc1:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104bc8:	e8 39 16 00 00       	call   80106206 <acquire>
        np->state = RUNNABLE;
80104bcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104bd0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        release(&ptable.lock);
80104bd7:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104bde:	e8 8a 16 00 00       	call   8010626d <release>
80104be3:	e9 6d 01 00 00       	jmp    80104d55 <fork+0x31b>
    }

    else if (np->isThread == 0){
80104be8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104beb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104bf1:	85 c0                	test   %eax,%eax
80104bf3:	0f 85 5c 01 00 00    	jne    80104d55 <fork+0x31b>
       //cprintf("isThread == 0\n");
       // Copy process state from p.
       if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104bf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bff:	8b 10                	mov    (%eax),%edx
80104c01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c07:	8b 40 04             	mov    0x4(%eax),%eax
80104c0a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c0e:	89 04 24             	mov    %eax,(%esp)
80104c11:	e8 79 4c 00 00       	call   8010988f <copyuvm>
80104c16:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104c19:	89 42 04             	mov    %eax,0x4(%edx)
80104c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c1f:	8b 40 04             	mov    0x4(%eax),%eax
80104c22:	85 c0                	test   %eax,%eax
80104c24:	75 2c                	jne    80104c52 <fork+0x218>
           kfree(np->kstack);
80104c26:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c29:	8b 40 08             	mov    0x8(%eax),%eax
80104c2c:	89 04 24             	mov    %eax,(%esp)
80104c2f:	e8 f9 e0 ff ff       	call   80102d2d <kfree>
           np->kstack = 0;
80104c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
           np->state = UNUSED;
80104c3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
           return -1;
80104c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c4d:	e9 06 01 00 00       	jmp    80104d58 <fork+0x31e>
       }
       //cprintf("after copyuvm in isThread == 0\n");
       np->isThread = 0;
80104c52:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c55:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104c5c:	00 00 00 
       //np->isParent = 0;
       np->sz = proc->sz;
80104c5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c65:	8b 10                	mov    (%eax),%edx
80104c67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c6a:	89 10                	mov    %edx,(%eax)
       np->parent = proc;
80104c6c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c76:	89 50 14             	mov    %edx,0x14(%eax)
       *np->tf = *proc->tf;
80104c79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c7c:	8b 50 18             	mov    0x18(%eax),%edx
80104c7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c85:	8b 40 18             	mov    0x18(%eax),%eax
80104c88:	89 c3                	mov    %eax,%ebx
80104c8a:	b8 13 00 00 00       	mov    $0x13,%eax
80104c8f:	89 d7                	mov    %edx,%edi
80104c91:	89 de                	mov    %ebx,%esi
80104c93:	89 c1                	mov    %eax,%ecx
80104c95:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      
        // Clear %eax so that fork returns 0 in the child.
        np->tf->eax = 0;
80104c97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c9a:	8b 40 18             	mov    0x18(%eax),%eax
80104c9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    
        for(i = 0; i < NOFILE; i++)
80104ca4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104cab:	eb 3d                	jmp    80104cea <fork+0x2b0>
            if(proc->ofile[i])
80104cad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104cb6:	83 c2 08             	add    $0x8,%edx
80104cb9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	74 25                	je     80104ce6 <fork+0x2ac>
                np->ofile[i] = filedup(proc->ofile[i]);
80104cc1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104cca:	83 c2 08             	add    $0x8,%edx
80104ccd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cd1:	89 04 24             	mov    %eax,(%esp)
80104cd4:	e8 21 c3 ff ff       	call   80100ffa <filedup>
80104cd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104cdc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104cdf:	83 c1 08             	add    $0x8,%ecx
80104ce2:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
      
        // Clear %eax so that fork returns 0 in the child.
        np->tf->eax = 0;

    
        for(i = 0; i < NOFILE; i++)
80104ce6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104cea:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104cee:	7e bd                	jle    80104cad <fork+0x273>
            if(proc->ofile[i])
                np->ofile[i] = filedup(proc->ofile[i]);
        np->cwd = idup(proc->cwd);
80104cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf6:	8b 40 68             	mov    0x68(%eax),%eax
80104cf9:	89 04 24             	mov    %eax,(%esp)
80104cfc:	e8 3f cc ff ff       	call   80101940 <idup>
80104d01:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104d04:	89 42 68             	mov    %eax,0x68(%edx)
        safestrcpy(np->name, proc->name, sizeof(proc->name));
80104d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d0d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d10:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104d13:	83 c0 6c             	add    $0x6c,%eax
80104d16:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d1d:	00 
80104d1e:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d22:	89 04 24             	mov    %eax,(%esp)
80104d25:	e8 65 19 00 00       	call   8010668f <safestrcpy>
        pid = np->pid;
80104d2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104d2d:	8b 40 10             	mov    0x10(%eax),%eax
80104d30:	89 45 e0             	mov    %eax,-0x20(%ebp)
        acquire(&ptable.lock);
80104d33:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104d3a:	e8 c7 14 00 00       	call   80106206 <acquire>
        np->state = RUNNABLE;
80104d3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104d42:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        release(&ptable.lock);
80104d49:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104d50:	e8 18 15 00 00       	call   8010626d <release>

    
        
     }
     return pid;
80104d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
    np->state = RUNNABLE;
    release(&ptable.lock);
    
    return pid;*/
    
}
80104d58:	83 c4 2c             	add    $0x2c,%esp
80104d5b:	5b                   	pop    %ebx
80104d5c:	5e                   	pop    %esi
80104d5d:	5f                   	pop    %edi
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    

80104d60 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{   
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;
    if(proc->parent == initproc)
80104d66:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6c:	8b 50 14             	mov    0x14(%eax),%edx
80104d6f:	a1 70 d6 10 80       	mov    0x8010d670,%eax
80104d74:	39 c2                	cmp    %eax,%edx
80104d76:	75 0c                	jne    80104d84 <exit+0x24>
        panic("init exiting");
80104d78:	c7 04 24 58 9e 10 80 	movl   $0x80109e58,(%esp)
80104d7f:	e8 de b7 ff ff       	call   80100562 <panic>

    //close all open files
    for(fd = 0; fd < NOFILE; fd++){
80104d84:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104d8b:	eb 44                	jmp    80104dd1 <exit+0x71>
        if(proc->ofile[fd]){
80104d8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d93:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d96:	83 c2 08             	add    $0x8,%edx
80104d99:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	74 2c                	je     80104dcd <exit+0x6d>
            fileclose(proc->ofile[fd]);
80104da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104daa:	83 c2 08             	add    $0x8,%edx
80104dad:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104db1:	89 04 24             	mov    %eax,(%esp)
80104db4:	e8 89 c2 ff ff       	call   80101042 <fileclose>
            proc->ofile[fd] = 0;
80104db9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dc2:	83 c2 08             	add    $0x8,%edx
80104dc5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104dcc:	00 
    int fd;
    if(proc->parent == initproc)
        panic("init exiting");

    //close all open files
    for(fd = 0; fd < NOFILE; fd++){
80104dcd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104dd1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104dd5:	7e b6                	jle    80104d8d <exit+0x2d>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    
    begin_op();
80104dd7:	e8 4f e9 ff ff       	call   8010372b <begin_op>
    iput(proc->cwd);
80104ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de2:	8b 40 68             	mov    0x68(%eax),%eax
80104de5:	89 04 24             	mov    %eax,(%esp)
80104de8:	e8 e0 cc ff ff       	call   80101acd <iput>
    end_op();
80104ded:	e8 bd e9 ff ff       	call   801037af <end_op>
    proc->cwd = 0;
80104df2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df8:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
   
    //thread calls exit
    if(proc->tid > 0){
80104dff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e05:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104e0b:	85 c0                	test   %eax,%eax
80104e0d:	0f 8e 90 00 00 00    	jle    80104ea3 <exit+0x143>
        acquire(&ptable.lock);
80104e13:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104e1a:	e8 e7 13 00 00       	call   80106206 <acquire>
        wakeup1(proc->parent);
80104e1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e25:	8b 40 14             	mov    0x14(%eax),%eax
80104e28:	89 04 24             	mov    %eax,(%esp)
80104e2b:	e8 71 0a 00 00       	call   801058a1 <wakeup1>
        for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){ //change threads' state
80104e30:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80104e37:	eb 4c                	jmp    80104e85 <exit+0x125>
            if(p->parent == proc->parent && p->tid == -1){
80104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3c:	8b 50 14             	mov    0x14(%eax),%edx
80104e3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e45:	8b 40 14             	mov    0x14(%eax),%eax
80104e48:	39 c2                	cmp    %eax,%edx
80104e4a:	75 32                	jne    80104e7e <exit+0x11e>
80104e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104e55:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e58:	75 24                	jne    80104e7e <exit+0x11e>
                p->parent = initproc;
80104e5a:	8b 15 70 d6 10 80    	mov    0x8010d670,%edx
80104e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e63:	89 50 14             	mov    %edx,0x14(%eax)
                if(p->state == ZOMBIE)
80104e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e69:	8b 40 0c             	mov    0xc(%eax),%eax
80104e6c:	83 f8 05             	cmp    $0x5,%eax
80104e6f:	75 0d                	jne    80104e7e <exit+0x11e>
                    wakeup1(initproc);
80104e71:	a1 70 d6 10 80       	mov    0x8010d670,%eax
80104e76:	89 04 24             	mov    %eax,(%esp)
80104e79:	e8 23 0a 00 00       	call   801058a1 <wakeup1>
   
    //thread calls exit
    if(proc->tid > 0){
        acquire(&ptable.lock);
        wakeup1(proc->parent);
        for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){ //change threads' state
80104e7e:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80104e85:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
80104e8c:	72 ab                	jb     80104e39 <exit+0xd9>
                p->parent = initproc;
                if(p->state == ZOMBIE)
                    wakeup1(initproc);
            }
        }
        proc->parent->killed = 1;
80104e8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e94:	8b 40 14             	mov    0x14(%eax),%eax
80104e97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104e9e:	e9 bd 00 00 00       	jmp    80104f60 <exit+0x200>
    }
    else{
        
        acquire(&ptable.lock);
80104ea3:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104eaa:	e8 57 13 00 00       	call   80106206 <acquire>
        wakeup1(proc->parent);
80104eaf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb5:	8b 40 14             	mov    0x14(%eax),%eax
80104eb8:	89 04 24             	mov    %eax,(%esp)
80104ebb:	e8 e1 09 00 00       	call   801058a1 <wakeup1>
 
        for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
80104ec0:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80104ec7:	e9 87 00 00 00       	jmp    80104f53 <exit+0x1f3>
            if(p->parent == proc && p->tid >0){
80104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecf:	8b 50 14             	mov    0x14(%eax),%edx
80104ed2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed8:	39 c2                	cmp    %eax,%edx
80104eda:	75 2e                	jne    80104f0a <exit+0x1aa>
80104edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104edf:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104ee5:	85 c0                	test   %eax,%eax
80104ee7:	7e 21                	jle    80104f0a <exit+0x1aa>
                p->killed = 1;
80104ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eec:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                if(p->state == SLEEPING){
80104ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ef6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ef9:	83 f8 02             	cmp    $0x2,%eax
80104efc:	75 0c                	jne    80104f0a <exit+0x1aa>
                    p->state = RUNNABLE;
80104efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f01:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                    continue;
80104f08:	eb 42                	jmp    80104f4c <exit+0x1ec>
                }
            }
            if(p->parent == proc && p->tid == -1){
80104f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0d:	8b 50 14             	mov    0x14(%eax),%edx
80104f10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f16:	39 c2                	cmp    %eax,%edx
80104f18:	75 32                	jne    80104f4c <exit+0x1ec>
80104f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104f23:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f26:	75 24                	jne    80104f4c <exit+0x1ec>
                p->parent = initproc;
80104f28:	8b 15 70 d6 10 80    	mov    0x8010d670,%edx
80104f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f31:	89 50 14             	mov    %edx,0x14(%eax)
                if(p->state == ZOMBIE)
80104f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f37:	8b 40 0c             	mov    0xc(%eax),%eax
80104f3a:	83 f8 05             	cmp    $0x5,%eax
80104f3d:	75 0d                	jne    80104f4c <exit+0x1ec>
                    wakeup1(initproc);
80104f3f:	a1 70 d6 10 80       	mov    0x8010d670,%eax
80104f44:	89 04 24             	mov    %eax,(%esp)
80104f47:	e8 55 09 00 00       	call   801058a1 <wakeup1>
    else{
        
        acquire(&ptable.lock);
        wakeup1(proc->parent);
 
        for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
80104f4c:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80104f53:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
80104f5a:	0f 82 6c ff ff ff    	jb     80104ecc <exit+0x16c>
                if(p->state == ZOMBIE)
                    wakeup1(initproc);
            }
        }
    }
    proc->state = ZOMBIE;
80104f60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f66:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
   // cprintf("exit finish befor sched\n");
    sched();
80104f6d:	e8 71 07 00 00       	call   801056e3 <sched>

    panic("zombie exit");
80104f72:	c7 04 24 65 9e 10 80 	movl   $0x80109e65,(%esp)
80104f79:	e8 e4 b5 ff ff       	call   80100562 <panic>

80104f7e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{  // cprintf("wait enter\n");
80104f7e:	55                   	push   %ebp
80104f7f:	89 e5                	mov    %esp,%ebp
80104f81:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havekids, pid,i;
    acquire(&ptable.lock);
80104f84:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80104f8b:	e8 76 12 00 00       	call   80106206 <acquire>
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
80104f90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f97:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80104f9e:	e9 26 01 00 00       	jmp    801050c9 <wait+0x14b>
            if(p->parent != proc)
80104fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa6:	8b 50 14             	mov    0x14(%eax),%edx
80104fa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104faf:	39 c2                	cmp    %eax,%edx
80104fb1:	74 05                	je     80104fb8 <wait+0x3a>
                continue;
80104fb3:	e9 0a 01 00 00       	jmp    801050c2 <wait+0x144>
            havekids = 1;
80104fb8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
80104fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc2:	8b 40 0c             	mov    0xc(%eax),%eax
80104fc5:	83 f8 05             	cmp    $0x5,%eax
80104fc8:	0f 85 f4 00 00 00    	jne    801050c2 <wait+0x144>
                if(p->tid > 0){
80104fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	0f 8e 82 00 00 00    	jle    80105061 <wait+0xe3>
                    p->tid = 0;
80104fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe2:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104fe9:	00 00 00 
                    deallocuvm(p->parent->pgdir, p->sz, p->sz-2*PGSIZE);
80104fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fef:	8b 00                	mov    (%eax),%eax
80104ff1:	8d 88 00 e0 ff ff    	lea    -0x2000(%eax),%ecx
80104ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffa:	8b 10                	mov    (%eax),%edx
80104ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fff:	8b 40 14             	mov    0x14(%eax),%eax
80105002:	8b 40 04             	mov    0x4(%eax),%eax
80105005:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105009:	89 54 24 04          	mov    %edx,0x4(%esp)
8010500d:	89 04 24             	mov    %eax,(%esp)
80105010:	e8 d7 46 00 00       	call   801096ec <deallocuvm>
                    for(i=0;i<10;i++){
80105015:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010501c:	eb 3d                	jmp    8010505b <wait+0xdd>
                        if(p->tarr[i] == 1){
8010501e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105021:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105024:	83 c2 24             	add    $0x24,%edx
80105027:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010502b:	83 f8 01             	cmp    $0x1,%eax
8010502e:	75 27                	jne    80105057 <wait+0xd9>
                            p->tarr[i] = 0;
80105030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105033:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105036:	83 c2 24             	add    $0x24,%edx
80105039:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105040:	00 
                            p->parent->tarr[i] = 0;
80105041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105044:	8b 40 14             	mov    0x14(%eax),%eax
80105047:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010504a:	83 c2 24             	add    $0x24,%edx
8010504d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105054:	00 
                            break;
80105055:	eb 0a                	jmp    80105061 <wait+0xe3>
            havekids = 1;
            if(p->state == ZOMBIE){
                if(p->tid > 0){
                    p->tid = 0;
                    deallocuvm(p->parent->pgdir, p->sz, p->sz-2*PGSIZE);
                    for(i=0;i<10;i++){
80105057:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010505b:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
8010505f:	7e bd                	jle    8010501e <wait+0xa0>
                            break;
                        }
                    }
                }
                // Found one.
                pid = p->pid;
80105061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105064:	8b 40 10             	mov    0x10(%eax),%eax
80105067:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(p->kstack);
8010506a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506d:	8b 40 08             	mov    0x8(%eax),%eax
80105070:	89 04 24             	mov    %eax,(%esp)
80105073:	e8 b5 dc ff ff       	call   80102d2d <kfree>
                p->kstack = 0;
80105078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                //freevm(p->pgdir);
                p->pid = 0;
80105082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105085:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
8010508c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010508f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80105096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105099:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
8010509d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a0:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                p->state = UNUSED;
801050a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                release(&ptable.lock);
801050b1:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801050b8:	e8 b0 11 00 00       	call   8010626d <release>
                return pid;
801050bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801050c0:	eb 55                	jmp    80105117 <wait+0x199>
    int havekids, pid,i;
    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited children.
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050c2:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
801050c9:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
801050d0:	0f 82 cd fe ff ff    	jb     80104fa3 <wait+0x25>
            }
        }
        
        
        // No point waiting if we don't have any children.
        if(!havekids || proc->killed){
801050d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050da:	74 0d                	je     801050e9 <wait+0x16b>
801050dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e2:	8b 40 24             	mov    0x24(%eax),%eax
801050e5:	85 c0                	test   %eax,%eax
801050e7:	74 13                	je     801050fc <wait+0x17e>
            release(&ptable.lock);
801050e9:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801050f0:	e8 78 11 00 00       	call   8010626d <release>
            return -1;
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	eb 1b                	jmp    80105117 <wait+0x199>
        }
        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
801050fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105102:	c7 44 24 04 a0 61 11 	movl   $0x801161a0,0x4(%esp)
80105109:	80 
8010510a:	89 04 24             	mov    %eax,(%esp)
8010510d:	e8 f4 06 00 00       	call   80105806 <sleep>
       // cprintf("wait finish\n");
    }
80105112:	e9 79 fe ff ff       	jmp    80104f90 <wait+0x12>
}
80105117:	c9                   	leave  
80105118:	c3                   	ret    

80105119 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80105119:	55                   	push   %ebp
8010511a:	89 e5                	mov    %esp,%ebp
8010511c:	53                   	push   %ebx
8010511d:	83 ec 24             	sub    $0x24,%esp

    struct proc *p;
    struct proc *minProc;

    totalShare = 0;
80105120:	c7 05 84 61 11 80 00 	movl   $0x0,0x80116184
80105127:	00 00 00 
    noflag = 0;
8010512a:	c7 05 40 5e 11 80 00 	movl   $0x0,0x80115e40
80105131:	00 00 00 

    for(;;){

        sti();
80105134:	e8 d6 f3 ff ff       	call   8010450f <sti>
        
        if(m >= 1000000) {
80105139:	a1 68 d6 10 80       	mov    0x8010d668,%eax
8010513e:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
80105143:	7e 14                	jle    80105159 <scheduler+0x40>
            m = 0; s = 0;
80105145:	c7 05 68 d6 10 80 00 	movl   $0x0,0x8010d668
8010514c:	00 00 00 
8010514f:	c7 05 6c d6 10 80 00 	movl   $0x0,0x8010d66c
80105156:	00 00 00 
        }
        if((totalShare == 0 || m*totalShare <= s *(100-totalShare)) && noflag == 0){
80105159:	a1 84 61 11 80       	mov    0x80116184,%eax
8010515e:	85 c0                	test   %eax,%eax
80105160:	74 2a                	je     8010518c <scheduler+0x73>
80105162:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80105168:	a1 84 61 11 80       	mov    0x80116184,%eax
8010516d:	0f af d0             	imul   %eax,%edx
80105170:	a1 84 61 11 80       	mov    0x80116184,%eax
80105175:	b9 64 00 00 00       	mov    $0x64,%ecx
8010517a:	29 c1                	sub    %eax,%ecx
8010517c:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80105181:	0f af c1             	imul   %ecx,%eax
80105184:	39 c2                	cmp    %eax,%edx
80105186:	0f 8f 10 04 00 00    	jg     8010559c <scheduler+0x483>
8010518c:	a1 40 5e 11 80       	mov    0x80115e40,%eax
80105191:	85 c0                	test   %eax,%eax
80105193:	0f 85 03 04 00 00    	jne    8010559c <scheduler+0x483>
          
     
            //cprintf("[[mlfq] m : [%d] s : [%d]]", m, s);
            // Enable interrupts on this processor.
            // Loop over process table looking for process to run.
            acquire(&ptable.lock);
80105199:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801051a0:	e8 61 10 00 00       	call   80106206 <acquire>
            if(!IsEmpty(&priority[0])) {
801051a5:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
801051ac:	e8 80 f3 ff ff       	call   80104531 <IsEmpty>
801051b1:	85 c0                	test   %eax,%eax
801051b3:	0f 85 25 01 00 00    	jne    801052de <scheduler+0x1c5>
                p = Dequeue(&priority[0]);
801051b9:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
801051c0:	e8 99 f3 ff ff       	call   8010455e <Dequeue>
801051c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
                if(p->state == RUNNABLE){// context switching
801051c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cb:	8b 40 0c             	mov    0xc(%eax),%eax
801051ce:	83 f8 03             	cmp    $0x3,%eax
801051d1:	0f 85 b4 03 00 00    	jne    8010558b <scheduler+0x472>
                    proc = p;
801051d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051da:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                    switchuvm(p);
801051e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e3:	89 04 24             	mov    %eax,(%esp)
801051e6:	e8 ec 40 00 00       	call   801092d7 <switchuvm>
                    p->state = RUNNING;
801051eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ee:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                    swtch(&cpu->scheduler, p->context);
801051f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f8:	8b 40 1c             	mov    0x1c(%eax),%eax
801051fb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105202:	83 c2 04             	add    $0x4,%edx
80105205:	89 44 24 04          	mov    %eax,0x4(%esp)
80105209:	89 14 24             	mov    %edx,(%esp)
8010520c:	e8 ef 14 00 00       	call   80106700 <swtch>
                    switchkvm();
80105211:	e8 a7 40 00 00       	call   801092bd <switchkvm>
                    proc = 0;
80105216:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010521d:	00 00 00 00 
                    if(p->isStride == 0) {
80105221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105224:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010522a:	85 c0                	test   %eax,%eax
8010522c:	0f 85 59 03 00 00    	jne    8010558b <scheduler+0x472>
                    if(boostflag == 1) {
80105232:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80105237:	83 f8 01             	cmp    $0x1,%eax
8010523a:	75 34                	jne    80105270 <scheduler+0x157>
                        Enqueue(&priority[0], p);
8010523c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010523f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105243:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
8010524a:	e8 69 f3 ff ff       	call   801045b8 <Enqueue>
                        priorityBoost();
8010524f:	e8 b8 f3 ff ff       	call   8010460c <priorityBoost>
                        boostflag = 0;
80105254:	c7 05 64 d6 10 80 00 	movl   $0x0,0x8010d664
8010525b:	00 00 00 
                        m+= 5;
8010525e:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80105263:	83 c0 05             	add    $0x5,%eax
80105266:	a3 68 d6 10 80       	mov    %eax,0x8010d668
8010526b:	e9 1b 03 00 00       	jmp    8010558b <scheduler+0x472>
                    } else if(p->state != SLEEPING) {
80105270:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105273:	8b 40 0c             	mov    0xc(%eax),%eax
80105276:	83 f8 02             	cmp    $0x2,%eax
80105279:	0f 84 0c 03 00 00    	je     8010558b <scheduler+0x472>
                        if(p->cnt <= 1){
8010527f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105282:	8b 40 7c             	mov    0x7c(%eax),%eax
80105285:	83 f8 01             	cmp    $0x1,%eax
80105288:	7f 3c                	jg     801052c6 <scheduler+0x1ad>
                            Enqueue(&priority[1], p);
8010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010528d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105291:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
80105298:	e8 1b f3 ff ff       	call   801045b8 <Enqueue>
                            p->level = 1;
8010529d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a0:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
801052a7:	00 00 00 
                            p->cnt = 10;
801052aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ad:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
                            m+= 5;
801052b4:	a1 68 d6 10 80       	mov    0x8010d668,%eax
801052b9:	83 c0 05             	add    $0x5,%eax
801052bc:	a3 68 d6 10 80       	mov    %eax,0x8010d668
801052c1:	e9 c5 02 00 00       	jmp    8010558b <scheduler+0x472>
                        } else {
                            //p->cnt--;
                            Enqueue(&priority[0], p);
801052c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052cd:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
801052d4:	e8 df f2 ff ff       	call   801045b8 <Enqueue>
801052d9:	e9 ad 02 00 00       	jmp    8010558b <scheduler+0x472>
                        }
                    }
                    }
                }
            }
            else if(!IsEmpty(&priority[1])) {
801052de:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
801052e5:	e8 47 f2 ff ff       	call   80104531 <IsEmpty>
801052ea:	85 c0                	test   %eax,%eax
801052ec:	0f 85 25 01 00 00    	jne    80105417 <scheduler+0x2fe>
                p = Dequeue(&priority[1]);
801052f2:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
801052f9:	e8 60 f2 ff ff       	call   8010455e <Dequeue>
801052fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
                if(p->state == RUNNABLE){//context switching
80105301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105304:	8b 40 0c             	mov    0xc(%eax),%eax
80105307:	83 f8 03             	cmp    $0x3,%eax
8010530a:	0f 85 7b 02 00 00    	jne    8010558b <scheduler+0x472>
                    proc = p;
80105310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105313:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                    switchuvm(p);
80105319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531c:	89 04 24             	mov    %eax,(%esp)
8010531f:	e8 b3 3f 00 00       	call   801092d7 <switchuvm>
                    p->state = RUNNING;
80105324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105327:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                    swtch(&cpu->scheduler, p->context);
8010532e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105331:	8b 40 1c             	mov    0x1c(%eax),%eax
80105334:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010533b:	83 c2 04             	add    $0x4,%edx
8010533e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105342:	89 14 24             	mov    %edx,(%esp)
80105345:	e8 b6 13 00 00       	call   80106700 <swtch>
                    switchkvm();
8010534a:	e8 6e 3f 00 00       	call   801092bd <switchkvm>
                    proc = 0;
8010534f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105356:	00 00 00 00 
                    
                    if(p->isStride == 0) {
8010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535d:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80105363:	85 c0                	test   %eax,%eax
80105365:	0f 85 20 02 00 00    	jne    8010558b <scheduler+0x472>
                    if(boostflag == 1) {
8010536b:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80105370:	83 f8 01             	cmp    $0x1,%eax
80105373:	75 34                	jne    801053a9 <scheduler+0x290>
                        Enqueue(&priority[1], p);
80105375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105378:	89 44 24 04          	mov    %eax,0x4(%esp)
8010537c:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
80105383:	e8 30 f2 ff ff       	call   801045b8 <Enqueue>
                        priorityBoost();
80105388:	e8 7f f2 ff ff       	call   8010460c <priorityBoost>
                        boostflag = 0;
8010538d:	c7 05 64 d6 10 80 00 	movl   $0x0,0x8010d664
80105394:	00 00 00 
                        m+=10;
80105397:	a1 68 d6 10 80       	mov    0x8010d668,%eax
8010539c:	83 c0 0a             	add    $0xa,%eax
8010539f:	a3 68 d6 10 80       	mov    %eax,0x8010d668
801053a4:	e9 e2 01 00 00       	jmp    8010558b <scheduler+0x472>
                    }
                    else if(p->state != SLEEPING) {
801053a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ac:	8b 40 0c             	mov    0xc(%eax),%eax
801053af:	83 f8 02             	cmp    $0x2,%eax
801053b2:	0f 84 d3 01 00 00    	je     8010558b <scheduler+0x472>
                        if(p->cnt == 1){
801053b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053bb:	8b 40 7c             	mov    0x7c(%eax),%eax
801053be:	83 f8 01             	cmp    $0x1,%eax
801053c1:	75 3c                	jne    801053ff <scheduler+0x2e6>
                            Enqueue(&priority[2],p);
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ca:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
801053d1:	e8 e2 f1 ff ff       	call   801045b8 <Enqueue>
                            p->level = 2;
801053d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d9:	c7 80 80 00 00 00 02 	movl   $0x2,0x80(%eax)
801053e0:	00 00 00 
                            p->cnt = 20;
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	c7 40 7c 14 00 00 00 	movl   $0x14,0x7c(%eax)
                            m+=10;
801053ed:	a1 68 d6 10 80       	mov    0x8010d668,%eax
801053f2:	83 c0 0a             	add    $0xa,%eax
801053f5:	a3 68 d6 10 80       	mov    %eax,0x8010d668
801053fa:	e9 8c 01 00 00       	jmp    8010558b <scheduler+0x472>
                        }
                        else {
                            // p->cnt--;
                            Enqueue(&priority[1], p);
801053ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105402:	89 44 24 04          	mov    %eax,0x4(%esp)
80105406:	c7 04 24 6c 5f 11 80 	movl   $0x80115f6c,(%esp)
8010540d:	e8 a6 f1 ff ff       	call   801045b8 <Enqueue>
80105412:	e9 74 01 00 00       	jmp    8010558b <scheduler+0x472>
                        }
                    }
                    }
                }
            }
            else if(!IsEmpty(&priority[2])) {
80105417:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
8010541e:	e8 0e f1 ff ff       	call   80104531 <IsEmpty>
80105423:	85 c0                	test   %eax,%eax
80105425:	0f 85 56 01 00 00    	jne    80105581 <scheduler+0x468>
                p = Dequeue(&priority[2]);
8010542b:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
80105432:	e8 27 f1 ff ff       	call   8010455e <Dequeue>
80105437:	89 45 f4             	mov    %eax,-0xc(%ebp)
                if(p->state == RUNNABLE){//context switching
8010543a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543d:	8b 40 0c             	mov    0xc(%eax),%eax
80105440:	83 f8 03             	cmp    $0x3,%eax
80105443:	0f 85 42 01 00 00    	jne    8010558b <scheduler+0x472>
                    proc = p;
80105449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010544c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                    switchuvm(p);
80105452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105455:	89 04 24             	mov    %eax,(%esp)
80105458:	e8 7a 3e 00 00       	call   801092d7 <switchuvm>
                    p->state = RUNNING;
8010545d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105460:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                    swtch(&cpu->scheduler, p->context);
80105467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010546d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105474:	83 c2 04             	add    $0x4,%edx
80105477:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547b:	89 14 24             	mov    %edx,(%esp)
8010547e:	e8 7d 12 00 00       	call   80106700 <swtch>
                    switchkvm();
80105483:	e8 35 3e 00 00       	call   801092bd <switchkvm>
                    proc = 0;
80105488:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010548f:	00 00 00 00 
                    
                    if(p->isStride == 0) {
80105493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105496:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010549c:	85 c0                	test   %eax,%eax
8010549e:	0f 85 e7 00 00 00    	jne    8010558b <scheduler+0x472>
                    if(boostflag == 1) {
801054a4:	a1 64 d6 10 80       	mov    0x8010d664,%eax
801054a9:	83 f8 01             	cmp    $0x1,%eax
801054ac:	75 27                	jne    801054d5 <scheduler+0x3bc>
                        Enqueue(&priority[2], p);
801054ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b5:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
801054bc:	e8 f7 f0 ff ff       	call   801045b8 <Enqueue>
                        priorityBoost();
801054c1:	e8 46 f1 ff ff       	call   8010460c <priorityBoost>
                        boostflag = 0;
801054c6:	c7 05 64 d6 10 80 00 	movl   $0x0,0x8010d664
801054cd:	00 00 00 
801054d0:	e9 b6 00 00 00       	jmp    8010558b <scheduler+0x472>
                    }
                    else if(p->state != SLEEPING) {
801054d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054d8:	8b 40 0c             	mov    0xc(%eax),%eax
801054db:	83 f8 02             	cmp    $0x2,%eax
801054de:	0f 84 a7 00 00 00    	je     8010558b <scheduler+0x472>
                        if(p->cnt == 1){
801054e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e7:	8b 40 7c             	mov    0x7c(%eax),%eax
801054ea:	83 f8 01             	cmp    $0x1,%eax
801054ed:	75 39                	jne    80105528 <scheduler+0x40f>
                            Enqueue(&priority[2],p);
801054ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f6:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
801054fd:	e8 b6 f0 ff ff       	call   801045b8 <Enqueue>
                            p->level = 2;
80105502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105505:	c7 80 80 00 00 00 02 	movl   $0x2,0x80(%eax)
8010550c:	00 00 00 
                            p->cnt = 20;
8010550f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105512:	c7 40 7c 14 00 00 00 	movl   $0x14,0x7c(%eax)
                            m+= 20;
80105519:	a1 68 d6 10 80       	mov    0x8010d668,%eax
8010551e:	83 c0 14             	add    $0x14,%eax
80105521:	a3 68 d6 10 80       	mov    %eax,0x8010d668
80105526:	eb 63                	jmp    8010558b <scheduler+0x472>
                        }
                        else {
                            // p->cnt--;
                            if(p->cnt == 1) {
80105528:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552b:	8b 40 7c             	mov    0x7c(%eax),%eax
8010552e:	83 f8 01             	cmp    $0x1,%eax
80105531:	75 39                	jne    8010556c <scheduler+0x453>
                                Enqueue(&priority[2], p);
80105533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105536:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553a:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
80105541:	e8 72 f0 ff ff       	call   801045b8 <Enqueue>
                                p->level = 2;
80105546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105549:	c7 80 80 00 00 00 02 	movl   $0x2,0x80(%eax)
80105550:	00 00 00 
                                p->cnt = 20;
80105553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105556:	c7 40 7c 14 00 00 00 	movl   $0x14,0x7c(%eax)
                                m+=20;
8010555d:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80105562:	83 c0 14             	add    $0x14,%eax
80105565:	a3 68 d6 10 80       	mov    %eax,0x8010d668
8010556a:	eb 1f                	jmp    8010558b <scheduler+0x472>
                                //cprintf("3\n");
                            }
                            else {
                                Enqueue(&priority[2], p);
8010556c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010556f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105573:	c7 04 24 78 60 11 80 	movl   $0x80116078,(%esp)
8010557a:	e8 39 f0 ff ff       	call   801045b8 <Enqueue>
8010557f:	eb 0a                	jmp    8010558b <scheduler+0x472>
                    }
                    }
                }
            }
            else {
                noflag = 1;
80105581:	c7 05 40 5e 11 80 01 	movl   $0x1,0x80115e40
80105588:	00 00 00 
            }        
            release(&ptable.lock);
8010558b:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105592:	e8 d6 0c 00 00       	call   8010626d <release>
80105597:	e9 42 01 00 00       	jmp    801056de <scheduler+0x5c5>
        }
        else if(totalShare){
8010559c:	a1 84 61 11 80       	mov    0x80116184,%eax
801055a1:	85 c0                	test   %eax,%eax
801055a3:	0f 84 35 01 00 00    	je     801056de <scheduler+0x5c5>
            acquire(&ptable.lock);
801055a9:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801055b0:	e8 51 0c 00 00       	call   80106206 <acquire>
            minProc = 0;
801055b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
            for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
801055bc:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
801055c3:	eb 50                	jmp    80105615 <scheduler+0x4fc>
                if(p && p->state == RUNNABLE && p->isStride == 1){
801055c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055c9:	74 43                	je     8010560e <scheduler+0x4f5>
801055cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ce:	8b 40 0c             	mov    0xc(%eax),%eax
801055d1:	83 f8 03             	cmp    $0x3,%eax
801055d4:	75 38                	jne    8010560e <scheduler+0x4f5>
801055d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801055df:	83 f8 01             	cmp    $0x1,%eax
801055e2:	75 2a                	jne    8010560e <scheduler+0x4f5>
                    if(minProc == 0) minProc = p;
801055e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055e8:	75 08                	jne    801055f2 <scheduler+0x4d9>
801055ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801055f0:	eb 1c                	jmp    8010560e <scheduler+0x4f5>
                    else if(minProc->pass > p->pass) minProc = p;
801055f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055f5:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801055fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055fe:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105604:	39 c2                	cmp    %eax,%edx
80105606:	7e 06                	jle    8010560e <scheduler+0x4f5>
80105608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010560b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            release(&ptable.lock);
        }
        else if(totalShare){
            acquire(&ptable.lock);
            minProc = 0;
            for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
8010560e:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80105615:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
8010561c:	72 a7                	jb     801055c5 <scheduler+0x4ac>
                if(p && p->state == RUNNABLE && p->isStride == 1){
                    if(minProc == 0) minProc = p;
                    else if(minProc->pass > p->pass) minProc = p;
                }
            }
            minProc->pass += minProc->stride;
8010561e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105621:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80105627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010562a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105630:	01 c2                	add    %eax,%edx
80105632:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105635:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
            minProc->state = RUNNING;
8010563b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010563e:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

            proc = minProc;
80105645:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105648:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(minProc);
8010564e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105651:	89 04 24             	mov    %eax,(%esp)
80105654:	e8 7e 3c 00 00       	call   801092d7 <switchuvm>
            swtch(&cpu->scheduler, minProc->context);
80105659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010565c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010565f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105666:	83 c2 04             	add    $0x4,%edx
80105669:	89 44 24 04          	mov    %eax,0x4(%esp)
8010566d:	89 14 24             	mov    %edx,(%esp)
80105670:	e8 8b 10 00 00       	call   80106700 <swtch>
            switchkvm();
80105675:	e8 43 3c 00 00       	call   801092bd <switchkvm>
            
            if(minProc && minProc->state != RUNNABLE) totalShare = totalShare - (1000/minProc->stride);
8010567a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010567e:	74 2b                	je     801056ab <scheduler+0x592>
80105680:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105683:	8b 40 0c             	mov    0xc(%eax),%eax
80105686:	83 f8 03             	cmp    $0x3,%eax
80105689:	74 20                	je     801056ab <scheduler+0x592>
8010568b:	8b 0d 84 61 11 80    	mov    0x80116184,%ecx
80105691:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105694:	8b 98 84 00 00 00    	mov    0x84(%eax),%ebx
8010569a:	b8 e8 03 00 00       	mov    $0x3e8,%eax
8010569f:	99                   	cltd   
801056a0:	f7 fb                	idiv   %ebx
801056a2:	29 c1                	sub    %eax,%ecx
801056a4:	89 c8                	mov    %ecx,%eax
801056a6:	a3 84 61 11 80       	mov    %eax,0x80116184

            proc = 0;
801056ab:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801056b2:	00 00 00 00 
            s = s + 1;
801056b6:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801056bb:	83 c0 01             	add    $0x1,%eax
801056be:	a3 6c d6 10 80       	mov    %eax,0x8010d66c
            noflag = 0;
801056c3:	c7 05 40 5e 11 80 00 	movl   $0x0,0x80115e40
801056ca:	00 00 00 
            release(&ptable.lock);
801056cd:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801056d4:	e8 94 0b 00 00       	call   8010626d <release>
        }
    }
801056d9:	e9 56 fa ff ff       	jmp    80105134 <scheduler+0x1b>
801056de:	e9 51 fa ff ff       	jmp    80105134 <scheduler+0x1b>

801056e3 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{  
801056e3:	55                   	push   %ebp
801056e4:	89 e5                	mov    %esp,%ebp
801056e6:	83 ec 28             	sub    $0x28,%esp
    int intena;
    if(!holding(&ptable.lock))
801056e9:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801056f0:	e8 3e 0c 00 00       	call   80106333 <holding>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	75 0c                	jne    80105705 <sched+0x22>
        panic("sched ptable.lock");
801056f9:	c7 04 24 71 9e 10 80 	movl   $0x80109e71,(%esp)
80105700:	e8 5d ae ff ff       	call   80100562 <panic>
    if(cpu->ncli != 1)
80105705:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010570b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105711:	83 f8 01             	cmp    $0x1,%eax
80105714:	74 0c                	je     80105722 <sched+0x3f>
        panic("sched locks");
80105716:	c7 04 24 83 9e 10 80 	movl   $0x80109e83,(%esp)
8010571d:	e8 40 ae ff ff       	call   80100562 <panic>
    if(proc->state == RUNNING)
80105722:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105728:	8b 40 0c             	mov    0xc(%eax),%eax
8010572b:	83 f8 04             	cmp    $0x4,%eax
8010572e:	75 0c                	jne    8010573c <sched+0x59>
        panic("sched running");
80105730:	c7 04 24 8f 9e 10 80 	movl   $0x80109e8f,(%esp)
80105737:	e8 26 ae ff ff       	call   80100562 <panic>
    if(readeflags()&FL_IF)
8010573c:	e8 be ed ff ff       	call   801044ff <readeflags>
80105741:	25 00 02 00 00       	and    $0x200,%eax
80105746:	85 c0                	test   %eax,%eax
80105748:	74 0c                	je     80105756 <sched+0x73>
        panic("sched interruptible");
8010574a:	c7 04 24 9d 9e 10 80 	movl   $0x80109e9d,(%esp)
80105751:	e8 0c ae ff ff       	call   80100562 <panic>
    intena = cpu->intena;
80105756:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010575c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105762:	89 45 f4             	mov    %eax,-0xc(%ebp)
    swtch(&proc->context, cpu->scheduler);
80105765:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010576b:	8b 40 04             	mov    0x4(%eax),%eax
8010576e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105775:	83 c2 1c             	add    $0x1c,%edx
80105778:	89 44 24 04          	mov    %eax,0x4(%esp)
8010577c:	89 14 24             	mov    %edx,(%esp)
8010577f:	e8 7c 0f 00 00       	call   80106700 <swtch>
    cpu->intena = intena;
80105784:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010578a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010578d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105793:	c9                   	leave  
80105794:	c3                   	ret    

80105795 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105795:	55                   	push   %ebp
80105796:	89 e5                	mov    %esp,%ebp
80105798:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
8010579b:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801057a2:	e8 5f 0a 00 00       	call   80106206 <acquire>
    proc->state = RUNNABLE;
801057a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057ad:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
801057b4:	e8 2a ff ff ff       	call   801056e3 <sched>
    release(&ptable.lock);
801057b9:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801057c0:	e8 a8 0a 00 00       	call   8010626d <release>
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    

801057c7 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801057c7:	55                   	push   %ebp
801057c8:	89 e5                	mov    %esp,%ebp
801057ca:	83 ec 18             	sub    $0x18,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801057cd:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801057d4:	e8 94 0a 00 00       	call   8010626d <release>
    
    if (first) {
801057d9:	a1 08 d0 10 80       	mov    0x8010d008,%eax
801057de:	85 c0                	test   %eax,%eax
801057e0:	74 22                	je     80105804 <forkret+0x3d>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
801057e2:	c7 05 08 d0 10 80 00 	movl   $0x0,0x8010d008
801057e9:	00 00 00 
        iinit(ROOTDEV);
801057ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057f3:	e8 0d be ff ff       	call   80101605 <iinit>
        initlog(ROOTDEV);
801057f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801057ff:	e8 23 dd ff ff       	call   80103527 <initlog>
    }
    
    // Return to "caller", actually trapret (see allocproc).
}
80105804:	c9                   	leave  
80105805:	c3                   	ret    

80105806 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105806:	55                   	push   %ebp
80105807:	89 e5                	mov    %esp,%ebp
80105809:	83 ec 18             	sub    $0x18,%esp
    if(proc == 0)
8010580c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105812:	85 c0                	test   %eax,%eax
80105814:	75 0c                	jne    80105822 <sleep+0x1c>
        panic("sleep");
80105816:	c7 04 24 b1 9e 10 80 	movl   $0x80109eb1,(%esp)
8010581d:	e8 40 ad ff ff       	call   80100562 <panic>
    if(lk == 0)
80105822:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105826:	75 0c                	jne    80105834 <sleep+0x2e>
        panic("sleep without lk");
80105828:	c7 04 24 b7 9e 10 80 	movl   $0x80109eb7,(%esp)
8010582f:	e8 2e ad ff ff       	call   80100562 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){  //DOC: sleeplock0
80105834:	81 7d 0c a0 61 11 80 	cmpl   $0x801161a0,0xc(%ebp)
8010583b:	74 17                	je     80105854 <sleep+0x4e>
        acquire(&ptable.lock);  //DOC: sleeplock1
8010583d:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105844:	e8 bd 09 00 00       	call   80106206 <acquire>
        release(lk);
80105849:	8b 45 0c             	mov    0xc(%ebp),%eax
8010584c:	89 04 24             	mov    %eax,(%esp)
8010584f:	e8 19 0a 00 00       	call   8010626d <release>
    }
    // Go to sleep.
    proc->chan = chan;
80105854:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010585a:	8b 55 08             	mov    0x8(%ebp),%edx
8010585d:	89 50 20             	mov    %edx,0x20(%eax)
    proc->state = SLEEPING;
80105860:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105866:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
    sched();
8010586d:	e8 71 fe ff ff       	call   801056e3 <sched>
    // Tidy up.
    proc->chan = 0;
80105872:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105878:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
    // Reacquire original lock.
    if(lk != &ptable.lock){  //DOC: sleeplock2
8010587f:	81 7d 0c a0 61 11 80 	cmpl   $0x801161a0,0xc(%ebp)
80105886:	74 17                	je     8010589f <sleep+0x99>
        release(&ptable.lock);
80105888:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
8010588f:	e8 d9 09 00 00       	call   8010626d <release>
        acquire(lk);
80105894:	8b 45 0c             	mov    0xc(%ebp),%eax
80105897:	89 04 24             	mov    %eax,(%esp)
8010589a:	e8 67 09 00 00       	call   80106206 <acquire>
    }
}
8010589f:	c9                   	leave  
801058a0:	c3                   	ret    

801058a1 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801058a1:	55                   	push   %ebp
801058a2:	89 e5                	mov    %esp,%ebp
801058a4:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801058a7:	c7 45 fc d4 61 11 80 	movl   $0x801161d4,-0x4(%ebp)
801058ae:	eb 55                	jmp    80105905 <wakeup1+0x64>
        if(p->state == SLEEPING && p->chan == chan) {
801058b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058b3:	8b 40 0c             	mov    0xc(%eax),%eax
801058b6:	83 f8 02             	cmp    $0x2,%eax
801058b9:	75 43                	jne    801058fe <wakeup1+0x5d>
801058bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058be:	8b 40 20             	mov    0x20(%eax),%eax
801058c1:	3b 45 08             	cmp    0x8(%ebp),%eax
801058c4:	75 38                	jne    801058fe <wakeup1+0x5d>
            p->state = RUNNABLE;
801058c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            Enqueue(&priority[p->level], p);//after changing
801058d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058d3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801058d9:	69 c0 0c 01 00 00    	imul   $0x10c,%eax,%eax
801058df:	8d 90 60 5e 11 80    	lea    -0x7feea1a0(%eax),%edx
801058e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ec:	89 14 24             	mov    %edx,(%esp)
801058ef:	e8 c4 ec ff ff       	call   801045b8 <Enqueue>
            noflag = 0;
801058f4:	c7 05 40 5e 11 80 00 	movl   $0x0,0x80115e40
801058fb:	00 00 00 
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801058fe:	81 45 fc a4 01 00 00 	addl   $0x1a4,-0x4(%ebp)
80105905:	81 7d fc d4 ca 11 80 	cmpl   $0x8011cad4,-0x4(%ebp)
8010590c:	72 a2                	jb     801058b0 <wakeup1+0xf>
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
            Enqueue(&priority[p->level], p);//after changing
            noflag = 0;
        }
}
8010590e:	c9                   	leave  
8010590f:	c3                   	ret    

80105910 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	83 ec 18             	sub    $0x18,%esp
    acquire(&ptable.lock);
80105916:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
8010591d:	e8 e4 08 00 00       	call   80106206 <acquire>
    wakeup1(chan);
80105922:	8b 45 08             	mov    0x8(%ebp),%eax
80105925:	89 04 24             	mov    %eax,(%esp)
80105928:	e8 74 ff ff ff       	call   801058a1 <wakeup1>
    release(&ptable.lock);
8010592d:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105934:	e8 34 09 00 00       	call   8010626d <release>
}
80105939:	c9                   	leave  
8010593a:	c3                   	ret    

8010593b <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid){
8010593b:	55                   	push   %ebp
8010593c:	89 e5                	mov    %esp,%ebp
8010593e:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    acquire(&ptable.lock);
80105941:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105948:	e8 b9 08 00 00       	call   80106206 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010594d:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80105954:	eb 72                	jmp    801059c8 <kill+0x8d>
        if(p->pid == pid){
80105956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105959:	8b 40 10             	mov    0x10(%eax),%eax
8010595c:	3b 45 08             	cmp    0x8(%ebp),%eax
8010595f:	75 60                	jne    801059c1 <kill+0x86>
            p->killed = 1;
80105961:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105964:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            // Wake process from sleep if necessary.
            if(p->state == SLEEPING) {
8010596b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596e:	8b 40 0c             	mov    0xc(%eax),%eax
80105971:	83 f8 02             	cmp    $0x2,%eax
80105974:	75 38                	jne    801059ae <kill+0x73>
                p->state = RUNNABLE;
80105976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105979:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                Enqueue(&priority[p->level], p);
80105980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105983:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105989:	69 c0 0c 01 00 00    	imul   $0x10c,%eax,%eax
8010598f:	8d 90 60 5e 11 80    	lea    -0x7feea1a0(%eax),%edx
80105995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105998:	89 44 24 04          	mov    %eax,0x4(%esp)
8010599c:	89 14 24             	mov    %edx,(%esp)
8010599f:	e8 14 ec ff ff       	call   801045b8 <Enqueue>
                noflag = 0;
801059a4:	c7 05 40 5e 11 80 00 	movl   $0x0,0x80115e40
801059ab:	00 00 00 
            }
            release(&ptable.lock);
801059ae:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801059b5:	e8 b3 08 00 00       	call   8010626d <release>
            return 0;
801059ba:	b8 00 00 00 00       	mov    $0x0,%eax
801059bf:	eb 21                	jmp    801059e2 <kill+0xa7>
// to user space (see trap in trap.c).
int
kill(int pid){
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059c1:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
801059c8:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
801059cf:	72 85                	jb     80105956 <kill+0x1b>
            }
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
801059d1:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
801059d8:	e8 90 08 00 00       	call   8010626d <release>
    return -1;
801059dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e2:	c9                   	leave  
801059e3:	c3                   	ret    

801059e4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	83 ec 58             	sub    $0x58,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801059ea:	c7 45 f0 d4 61 11 80 	movl   $0x801161d4,-0x10(%ebp)
801059f1:	e9 d9 00 00 00       	jmp    80105acf <procdump+0xeb>
        if(p->state == UNUSED)
801059f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f9:	8b 40 0c             	mov    0xc(%eax),%eax
801059fc:	85 c0                	test   %eax,%eax
801059fe:	75 05                	jne    80105a05 <procdump+0x21>
            continue;
80105a00:	e9 c3 00 00 00       	jmp    80105ac8 <procdump+0xe4>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a08:	8b 40 0c             	mov    0xc(%eax),%eax
80105a0b:	83 f8 05             	cmp    $0x5,%eax
80105a0e:	77 23                	ja     80105a33 <procdump+0x4f>
80105a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a13:	8b 40 0c             	mov    0xc(%eax),%eax
80105a16:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	74 12                	je     80105a33 <procdump+0x4f>
            state = states[p->state];
80105a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a24:	8b 40 0c             	mov    0xc(%eax),%eax
80105a27:	8b 04 85 0c d0 10 80 	mov    -0x7fef2ff4(,%eax,4),%eax
80105a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105a31:	eb 07                	jmp    80105a3a <procdump+0x56>
        else
            state = "???";
80105a33:	c7 45 ec c8 9e 10 80 	movl   $0x80109ec8,-0x14(%ebp)
        cprintf("%d %s %s", p->pid, state, p->name);
80105a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3d:	8d 50 6c             	lea    0x6c(%eax),%edx
80105a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a43:	8b 40 10             	mov    0x10(%eax),%eax
80105a46:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105a4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105a4d:	89 54 24 08          	mov    %edx,0x8(%esp)
80105a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a55:	c7 04 24 cc 9e 10 80 	movl   $0x80109ecc,(%esp)
80105a5c:	e8 67 a9 ff ff       	call   801003c8 <cprintf>
        if(p->state == SLEEPING){
80105a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a64:	8b 40 0c             	mov    0xc(%eax),%eax
80105a67:	83 f8 02             	cmp    $0x2,%eax
80105a6a:	75 50                	jne    80105abc <procdump+0xd8>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6f:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a72:	8b 40 0c             	mov    0xc(%eax),%eax
80105a75:	83 c0 08             	add    $0x8,%eax
80105a78:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105a7b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a7f:	89 04 24             	mov    %eax,(%esp)
80105a82:	e8 33 08 00 00       	call   801062ba <getcallerpcs>
            for(i=0; i<10 && pc[i] != 0; i++)
80105a87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105a8e:	eb 1b                	jmp    80105aab <procdump+0xc7>
                cprintf(" %p", pc[i]);
80105a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a93:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105a97:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a9b:	c7 04 24 d5 9e 10 80 	movl   $0x80109ed5,(%esp)
80105aa2:	e8 21 a9 ff ff       	call   801003c8 <cprintf>
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105aa7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105aab:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105aaf:	7f 0b                	jg     80105abc <procdump+0xd8>
80105ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab4:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105ab8:	85 c0                	test   %eax,%eax
80105aba:	75 d4                	jne    80105a90 <procdump+0xac>
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80105abc:	c7 04 24 d9 9e 10 80 	movl   $0x80109ed9,(%esp)
80105ac3:	e8 00 a9 ff ff       	call   801003c8 <cprintf>
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105ac8:	81 45 f0 a4 01 00 00 	addl   $0x1a4,-0x10(%ebp)
80105acf:	81 7d f0 d4 ca 11 80 	cmpl   $0x8011cad4,-0x10(%ebp)
80105ad6:	0f 82 1a ff ff ff    	jb     801059f6 <procdump+0x12>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}
80105adc:	c9                   	leave  
80105add:	c3                   	ret    

80105ade <checkLevel>:

int checkLevel(){//checking level : transfter result to getlev
80105ade:	55                   	push   %ebp
80105adf:	89 e5                	mov    %esp,%ebp
    return proc->level;
80105ae1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80105aed:	5d                   	pop    %ebp
80105aee:	c3                   	ret    

80105aef <set_cpu_share>:

int
set_cpu_share(int tickets)
{
80105aef:	55                   	push   %ebp
80105af0:	89 e5                	mov    %esp,%ebp
80105af2:	83 ec 10             	sub    $0x10,%esp
   // struct proc *p;
    int large = 1000;
80105af5:	c7 45 fc e8 03 00 00 	movl   $0x3e8,-0x4(%ebp)
    int stride = large/tickets;
80105afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aff:	99                   	cltd   
80105b00:	f7 7d 08             	idivl  0x8(%ebp)
80105b03:	89 45 f8             	mov    %eax,-0x8(%ebp)
  
    //cprintf("totalShare : %d\n", totalShare);
    if(totalShare + tickets > 80) return -1;
80105b06:	8b 15 84 61 11 80    	mov    0x80116184,%edx
80105b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0f:	01 d0                	add    %edx,%eax
80105b11:	83 f8 50             	cmp    $0x50,%eax
80105b14:	7e 07                	jle    80105b1d <set_cpu_share+0x2e>
80105b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1b:	eb 58                	jmp    80105b75 <set_cpu_share+0x86>
    
    //cprintf("set_cpu_share\n");
    totalShare = totalShare + tickets;
80105b1d:	8b 15 84 61 11 80    	mov    0x80116184,%edx
80105b23:	8b 45 08             	mov    0x8(%ebp),%eax
80105b26:	01 d0                	add    %edx,%eax
80105b28:	a3 84 61 11 80       	mov    %eax,0x80116184
    proc->stride = stride;
80105b2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b33:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105b36:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    proc->pass = 0;
80105b3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b42:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80105b49:	00 00 00 
    proc->isStride = 1;
80105b4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b52:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
80105b59:	00 00 00 
    m = 0;
80105b5c:	c7 05 68 d6 10 80 00 	movl   $0x0,0x8010d668
80105b63:	00 00 00 
    s = 0;
80105b66:	c7 05 6c d6 10 80 00 	movl   $0x0,0x8010d66c
80105b6d:	00 00 00 

    return 0;
80105b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    

80105b77 <thread_create>:
// Create a new thread (similar to process
// Sets up stack to return as if from system call.
// stack is independent elements (other areas are shared)
// Caller must set state of returned proc to RUNNABLE.

int thread_create(thread_t* thread, void *(*start_routine)(void *), void *arg){
80105b77:	55                   	push   %ebp
80105b78:	89 e5                	mov    %esp,%ebp
80105b7a:	57                   	push   %edi
80105b7b:	56                   	push   %esi
80105b7c:	53                   	push   %ebx
80105b7d:	83 ec 2c             	sub    $0x2c,%esp
    int i, base;
    struct proc* p;

    //allocate process
    p=allocproc();
80105b80:	e8 34 eb ff ff       	call   801046b9 <allocproc>
80105b85:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nextpid--;
80105b88:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80105b8d:	83 e8 01             	sub    $0x1,%eax
80105b90:	a3 04 d0 10 80       	mov    %eax,0x8010d004
    if(p == 0){
80105b95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80105b99:	75 16                	jne    80105bb1 <thread_create+0x3a>
        cprintf("process allocation fail\n");
80105b9b:	c7 04 24 db 9e 10 80 	movl   $0x80109edb,(%esp)
80105ba2:	e8 21 a8 ff ff       	call   801003c8 <cprintf>
        return -1;
80105ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bac:	e9 51 02 00 00       	jmp    80105e02 <thread_create+0x28b>
    }
    
    acquire(&ptable.lock);
80105bb1:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105bb8:	e8 49 06 00 00       	call   80106206 <acquire>

    if(proc->isThread==0)
80105bbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bc3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	75 0f                	jne    80105bdc <thread_create+0x65>
        p->parent = proc;
80105bcd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105bd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bd7:	89 50 14             	mov    %edx,0x14(%eax)
80105bda:	eb 0f                	jmp    80105beb <thread_create+0x74>
    else
        p->parent = proc->parent;
80105bdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105be2:	8b 50 14             	mov    0x14(%eax),%edx
80105be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105be8:	89 50 14             	mov    %edx,0x14(%eax)

    for(i=0;i<64;i++){
80105beb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105bf2:	eb 3d                	jmp    80105c31 <thread_create+0xba>
        if(proc->tarr[i]==0){
80105bf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105bfd:	83 c2 24             	add    $0x24,%edx
80105c00:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c04:	85 c0                	test   %eax,%eax
80105c06:	75 25                	jne    80105c2d <thread_create+0xb6>
            p->tid=i+1;
80105c08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c0b:	8d 50 01             	lea    0x1(%eax),%edx
80105c0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c11:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            proc->tarr[i] = 1;
80105c17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105c20:	83 c2 24             	add    $0x24,%edx
80105c23:	c7 44 90 08 01 00 00 	movl   $0x1,0x8(%eax,%edx,4)
80105c2a:	00 
            break;
80105c2b:	eb 0a                	jmp    80105c37 <thread_create+0xc0>
    if(proc->isThread==0)
        p->parent = proc;
    else
        p->parent = proc->parent;

    for(i=0;i<64;i++){
80105c2d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105c31:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
80105c35:	7e bd                	jle    80105bf4 <thread_create+0x7d>
            p->tid=i+1;
            proc->tarr[i] = 1;
            break;
        }
    }
    *thread = p->tid;
80105c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c3a:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105c40:	8b 45 08             	mov    0x8(%ebp),%eax
80105c43:	89 10                	mov    %edx,(%eax)
    p->isThread = 1;
80105c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c48:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
80105c4f:	00 00 00 
    safestrcpy(p->name, proc->name, sizeof(proc->name));
80105c52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c58:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c5e:	83 c0 6c             	add    $0x6c,%eax
80105c61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c68:	00 
80105c69:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c6d:	89 04 24             	mov    %eax,(%esp)
80105c70:	e8 1a 0a 00 00       	call   8010668f <safestrcpy>
    p->pid = proc->pid;
80105c75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7b:	8b 50 10             	mov    0x10(%eax),%edx
80105c7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c81:	89 50 10             	mov    %edx,0x10(%eax)
    *p->tf=*proc->tf; //copy trap frame
80105c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c87:	8b 50 18             	mov    0x18(%eax),%edx
80105c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c90:	8b 40 18             	mov    0x18(%eax),%eax
80105c93:	89 c3                	mov    %eax,%ebx
80105c95:	b8 13 00 00 00       	mov    $0x13,%eax
80105c9a:	89 d7                	mov    %edx,%edi
80105c9c:	89 de                	mov    %ebx,%esi
80105c9e:	89 c1                	mov    %eax,%ecx
80105ca0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    p->sz=proc->sz;
80105ca2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca8:	8b 10                	mov    (%eax),%edx
80105caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cad:	89 10                	mov    %edx,(%eax)
    p->tf->eax = 0;
80105caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cb2:	8b 40 18             	mov    0x18(%eax),%eax
80105cb5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    p->pgdir = proc->pgdir; //sharing pointer
80105cbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cc2:	8b 50 04             	mov    0x4(%eax),%edx
80105cc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cc8:	89 50 04             	mov    %edx,0x4(%eax)
    
    //kernel stack copyvi p
    for(i = 0; i < NOFILE; i++){
80105ccb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105cd2:	eb 54                	jmp    80105d28 <thread_create+0x1b1>
        if(proc->ofile[i]){
80105cd4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105cdd:	83 c2 08             	add    $0x8,%edx
80105ce0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	74 25                	je     80105d0d <thread_create+0x196>
            p->ofile[i] = filedup(proc->ofile[i]);
80105ce8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105cf1:	83 c2 08             	add    $0x8,%edx
80105cf4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cf8:	89 04 24             	mov    %eax,(%esp)
80105cfb:	e8 fa b2 ff ff       	call   80100ffa <filedup>
80105d00:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105d03:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d06:	83 c1 08             	add    $0x8,%ecx
80105d09:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
        }
        p->cwd = idup(proc->cwd);
80105d0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d13:	8b 40 68             	mov    0x68(%eax),%eax
80105d16:	89 04 24             	mov    %eax,(%esp)
80105d19:	e8 22 bc ff ff       	call   80101940 <idup>
80105d1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105d21:	89 42 68             	mov    %eax,0x68(%edx)
    p->sz=proc->sz;
    p->tf->eax = 0;
    p->pgdir = proc->pgdir; //sharing pointer
    
    //kernel stack copyvi p
    for(i = 0; i < NOFILE; i++){
80105d24:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105d28:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80105d2c:	7e a6                	jle    80105cd4 <thread_create+0x15d>
        if(proc->ofile[i]){
            p->ofile[i] = filedup(proc->ofile[i]);
        }
        p->cwd = idup(proc->cwd);
    }
    p->tf->eip = (uint)start_routine;
80105d2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d31:	8b 40 18             	mov    0x18(%eax),%eax
80105d34:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d37:	89 50 38             	mov    %edx,0x38(%eax)
    
    //allocate two memory for stack and guard page

    
    base = proc->sz + (uint)(PGSIZE*(p->tid));
80105d3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d40:	8b 10                	mov    (%eax),%edx
80105d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d45:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105d4b:	c1 e0 0c             	shl    $0xc,%eax
80105d4e:	01 d0                	add    %edx,%eax
80105d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
    p->sz = allocuvm(p->pgdir, base, base+PGSIZE);
80105d53:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d56:	05 00 10 00 00       	add    $0x1000,%eax
80105d5b:	89 c1                	mov    %eax,%ecx
80105d5d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d63:	8b 40 04             	mov    0x4(%eax),%eax
80105d66:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d6a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d6e:	89 04 24             	mov    %eax,(%esp)
80105d71:	e8 60 38 00 00       	call   801095d6 <allocuvm>
80105d76:	89 c2                	mov    %eax,%edx
80105d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d7b:	89 10                	mov    %edx,(%eax)
  

    
    //cprintf("[tid] %d\n", p->tid);
    p->tf->esp = proc->sz + (uint)(PGSIZE*(1 + p->tid)) - 4;
80105d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d80:	8b 40 18             	mov    0x18(%eax),%eax
80105d83:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105d8a:	8b 0a                	mov    (%edx),%ecx
80105d8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105d8f:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105d95:	83 c2 01             	add    $0x1,%edx
80105d98:	c1 e2 0c             	shl    $0xc,%edx
80105d9b:	01 ca                	add    %ecx,%edx
80105d9d:	83 ea 04             	sub    $0x4,%edx
80105da0:	89 50 44             	mov    %edx,0x44(%eax)
    *((uint*)(p->tf->esp)) = (uint)arg; //arg pointer
80105da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105da6:	8b 40 18             	mov    0x18(%eax),%eax
80105da9:	8b 40 44             	mov    0x44(%eax),%eax
80105dac:	8b 55 10             	mov    0x10(%ebp),%edx
80105daf:	89 10                	mov    %edx,(%eax)
    p->tf->esp -= 4;
80105db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105db4:	8b 40 18             	mov    0x18(%eax),%eax
80105db7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105dba:	8b 52 18             	mov    0x18(%edx),%edx
80105dbd:	8b 52 44             	mov    0x44(%edx),%edx
80105dc0:	83 ea 04             	sub    $0x4,%edx
80105dc3:	89 50 44             	mov    %edx,0x44(%eax)
    *((uint*)(p->tf->esp)) = 0xffffffff; //fake return PC
80105dc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dc9:	8b 40 18             	mov    0x18(%eax),%eax
80105dcc:	8b 40 44             	mov    0x44(%eax),%eax
80105dcf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
    p->tf->ebp = p->tf->esp;
80105dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dd8:	8b 40 18             	mov    0x18(%eax),%eax
80105ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105dde:	8b 52 18             	mov    0x18(%edx),%edx
80105de1:	8b 52 44             	mov    0x44(%edx),%edx
80105de4:	89 50 08             	mov    %edx,0x8(%eax)
    //cprintf("[create]esp : %d\n", p->tf->esp);
    
   // p->top = base + PGSIZE;
   
    p->state = RUNNABLE;
80105de7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105dea:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    release(&ptable.lock);
80105df1:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105df8:	e8 70 04 00 00       	call   8010626d <release>

    return 0;
80105dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e02:	83 c4 2c             	add    $0x2c,%esp
80105e05:	5b                   	pop    %ebx
80105e06:	5e                   	pop    %esi
80105e07:	5f                   	pop    %edi
80105e08:	5d                   	pop    %ebp
80105e09:	c3                   	ret    

80105e0a <thread_join>:

// Wait for exit and return its pid.
// Return -1 if this process has no threads.
 // Scan through table looking for exited threads.
int thread_join(thread_t thread, void **retval){
80105e0a:	55                   	push   %ebp
80105e0b:	89 e5                	mov    %esp,%ebp
80105e0d:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int havethreads;
    //int havethreads;
    acquire(&ptable.lock);
80105e10:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105e17:	e8 ea 03 00 00       	call   80106206 <acquire>
    for(;;){
        // Scan through table looking for exited threads.
        havethreads = 0;
80105e1c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e23:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80105e2a:	e9 f5 00 00 00       	jmp    80105f24 <thread_join+0x11a>
            if(p->tid != thread)
80105e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e32:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e38:	3b 45 08             	cmp    0x8(%ebp),%eax
80105e3b:	74 05                	je     80105e42 <thread_join+0x38>
                continue;
80105e3d:	e9 db 00 00 00       	jmp    80105f1d <thread_join+0x113>
            havethreads = 1;
80105e42:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if(p->state == ZOMBIE){
80105e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e4c:	8b 40 0c             	mov    0xc(%eax),%eax
80105e4f:	83 f8 05             	cmp    $0x5,%eax
80105e52:	0f 85 c5 00 00 00    	jne    80105f1d <thread_join+0x113>
                // Found one.
                p->parent->tarr[p->tid - 1] = 0;
80105e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5b:	8b 40 14             	mov    0x14(%eax),%eax
80105e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e61:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105e67:	83 ea 01             	sub    $0x1,%edx
80105e6a:	83 c2 24             	add    $0x24,%edx
80105e6d:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e74:	00 
                kfree(p->kstack);
80105e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e78:	8b 40 08             	mov    0x8(%eax),%eax
80105e7b:	89 04 24             	mov    %eax,(%esp)
80105e7e:	e8 aa ce ff ff       	call   80102d2d <kfree>
                p->kstack = 0;
80105e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                p->pid = 0;
80105e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e90:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->tid = 0;
80105e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9a:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80105ea1:	00 00 00 
                deallocuvm(p->pgdir, p->sz, p->sz-PGSIZE);
80105ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea7:	8b 00                	mov    (%eax),%eax
80105ea9:	8d 88 00 f0 ff ff    	lea    -0x1000(%eax),%ecx
80105eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb2:	8b 10                	mov    (%eax),%edx
80105eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb7:	8b 40 04             	mov    0x4(%eax),%eax
80105eba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105ebe:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ec2:	89 04 24             	mov    %eax,(%esp)
80105ec5:	e8 22 38 00 00       	call   801096ec <deallocuvm>
                p->parent = 0;
80105eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80105ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed7:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80105edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ede:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                p->state = UNUSED;
80105ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                *retval = p->retval;
80105eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef2:	8b 90 98 01 00 00    	mov    0x198(%eax),%edx
80105ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105efb:	89 10                	mov    %edx,(%eax)
                p->retval = 0;
80105efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f00:	c7 80 98 01 00 00 00 	movl   $0x0,0x198(%eax)
80105f07:	00 00 00 
                release(&ptable.lock);
80105f0a:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105f11:	e8 57 03 00 00       	call   8010626d <release>
                return 0;
80105f16:	b8 00 00 00 00       	mov    $0x0,%eax
80105f1b:	eb 55                	jmp    80105f72 <thread_join+0x168>
    //int havethreads;
    acquire(&ptable.lock);
    for(;;){
        // Scan through table looking for exited threads.
        havethreads = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105f1d:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80105f24:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
80105f2b:	0f 82 fe fe ff ff    	jb     80105e2f <thread_join+0x25>
                return 0;
            }
        }

        // No point waiting if we don't have any threads.
        if(!havethreads || proc->killed){
80105f31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f35:	74 0d                	je     80105f44 <thread_join+0x13a>
80105f37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f3d:	8b 40 24             	mov    0x24(%eax),%eax
80105f40:	85 c0                	test   %eax,%eax
80105f42:	74 13                	je     80105f57 <thread_join+0x14d>
            release(&ptable.lock);
80105f44:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80105f4b:	e8 1d 03 00 00       	call   8010626d <release>
            return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f55:	eb 1b                	jmp    80105f72 <thread_join+0x168>
        }
        // Wait for threas to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105f57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f5d:	c7 44 24 04 a0 61 11 	movl   $0x801161a0,0x4(%esp)
80105f64:	80 
80105f65:	89 04 24             	mov    %eax,(%esp)
80105f68:	e8 99 f8 ff ff       	call   80105806 <sleep>
    }
80105f6d:	e9 aa fe ff ff       	jmp    80105e1c <thread_join+0x12>
}
80105f72:	c9                   	leave  
80105f73:	c3                   	ret    

80105f74 <thread_exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
thread_exit(void *retval)
{
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	83 ec 28             	sub    $0x28,%esp
    struct proc *p;
    int fd;
    if(proc == initproc)
80105f7a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105f81:	a1 70 d6 10 80       	mov    0x8010d670,%eax
80105f86:	39 c2                	cmp    %eax,%edx
80105f88:	75 0c                	jne    80105f96 <thread_exit+0x22>
        panic("init exiting");
80105f8a:	c7 04 24 58 9e 10 80 	movl   $0x80109e58,(%esp)
80105f91:	e8 cc a5 ff ff       	call   80100562 <panic>
    for(fd = 0; fd < NOFILE; fd++){
80105f96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105f9d:	eb 44                	jmp    80105fe3 <thread_exit+0x6f>
        if(proc->ofile[fd]){
80105f9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fa8:	83 c2 08             	add    $0x8,%edx
80105fab:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105faf:	85 c0                	test   %eax,%eax
80105fb1:	74 2c                	je     80105fdf <thread_exit+0x6b>
            fileclose(proc->ofile[fd]);
80105fb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fbc:	83 c2 08             	add    $0x8,%edx
80105fbf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105fc3:	89 04 24             	mov    %eax,(%esp)
80105fc6:	e8 77 b0 ff ff       	call   80101042 <fileclose>
            proc->ofile[fd] = 0;
80105fcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fd4:	83 c2 08             	add    $0x8,%edx
80105fd7:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105fde:	00 
{
    struct proc *p;
    int fd;
    if(proc == initproc)
        panic("init exiting");
    for(fd = 0; fd < NOFILE; fd++){
80105fdf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105fe3:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105fe7:	7e b6                	jle    80105f9f <thread_exit+0x2b>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }
    
    begin_op();
80105fe9:	e8 3d d7 ff ff       	call   8010372b <begin_op>
    iput(proc->cwd);
80105fee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ff4:	8b 40 68             	mov    0x68(%eax),%eax
80105ff7:	89 04 24             	mov    %eax,(%esp)
80105ffa:	e8 ce ba ff ff       	call   80101acd <iput>
    end_op();
80105fff:	e8 ab d7 ff ff       	call   801037af <end_op>
    proc->cwd = 0;
80106004:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010600a:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
    acquire(&ptable.lock);
80106011:	c7 04 24 a0 61 11 80 	movl   $0x801161a0,(%esp)
80106018:	e8 e9 01 00 00       	call   80106206 <acquire>

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
8010601d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106023:	8b 40 14             	mov    0x14(%eax),%eax
80106026:	89 04 24             	mov    %eax,(%esp)
80106029:	e8 73 f8 ff ff       	call   801058a1 <wakeup1>
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010602e:	c7 45 f4 d4 61 11 80 	movl   $0x801161d4,-0xc(%ebp)
80106035:	eb 3b                	jmp    80106072 <thread_exit+0xfe>
        if(p->parent == proc){
80106037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603a:	8b 50 14             	mov    0x14(%eax),%edx
8010603d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106043:	39 c2                	cmp    %eax,%edx
80106045:	75 24                	jne    8010606b <thread_exit+0xf7>
            p->parent = initproc;
80106047:	8b 15 70 d6 10 80    	mov    0x8010d670,%edx
8010604d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106050:	89 50 14             	mov    %edx,0x14(%eax)
            if(p->state == ZOMBIE)
80106053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106056:	8b 40 0c             	mov    0xc(%eax),%eax
80106059:	83 f8 05             	cmp    $0x5,%eax
8010605c:	75 0d                	jne    8010606b <thread_exit+0xf7>
                wakeup1(initproc);
8010605e:	a1 70 d6 10 80       	mov    0x8010d670,%eax
80106063:	89 04 24             	mov    %eax,(%esp)
80106066:	e8 36 f8 ff ff       	call   801058a1 <wakeup1>
    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    // Pass abandoned children to init.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010606b:	81 45 f4 a4 01 00 00 	addl   $0x1a4,-0xc(%ebp)
80106072:	81 7d f4 d4 ca 11 80 	cmpl   $0x8011cad4,-0xc(%ebp)
80106079:	72 bc                	jb     80106037 <thread_exit+0xc3>
            if(p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }
    //return value
    proc->retval = retval;
8010607b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106081:	8b 55 08             	mov    0x8(%ebp),%edx
80106084:	89 90 98 01 00 00    	mov    %edx,0x198(%eax)
    proc->state = ZOMBIE;
8010608a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106090:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched();
80106097:	e8 47 f6 ff ff       	call   801056e3 <sched>
    panic("zombie exit");
8010609c:	c7 04 24 65 9e 10 80 	movl   $0x80109e65,(%esp)
801060a3:	e8 ba a4 ff ff       	call   80100562 <panic>

801060a8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801060a8:	55                   	push   %ebp
801060a9:	89 e5                	mov    %esp,%ebp
801060ab:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
801060ae:	8b 45 08             	mov    0x8(%ebp),%eax
801060b1:	83 c0 04             	add    $0x4,%eax
801060b4:	c7 44 24 04 1e 9f 10 	movl   $0x80109f1e,0x4(%esp)
801060bb:	80 
801060bc:	89 04 24             	mov    %eax,(%esp)
801060bf:	e8 21 01 00 00       	call   801061e5 <initlock>
  lk->name = name;
801060c4:	8b 45 08             	mov    0x8(%ebp),%eax
801060c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801060ca:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801060cd:	8b 45 08             	mov    0x8(%ebp),%eax
801060d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801060d6:	8b 45 08             	mov    0x8(%ebp),%eax
801060d9:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
801060e0:	c9                   	leave  
801060e1:	c3                   	ret    

801060e2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801060e2:	55                   	push   %ebp
801060e3:	89 e5                	mov    %esp,%ebp
801060e5:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
801060e8:	8b 45 08             	mov    0x8(%ebp),%eax
801060eb:	83 c0 04             	add    $0x4,%eax
801060ee:	89 04 24             	mov    %eax,(%esp)
801060f1:	e8 10 01 00 00       	call   80106206 <acquire>
  while (lk->locked) {
801060f6:	eb 15                	jmp    8010610d <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
801060f8:	8b 45 08             	mov    0x8(%ebp),%eax
801060fb:	83 c0 04             	add    $0x4,%eax
801060fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106102:	8b 45 08             	mov    0x8(%ebp),%eax
80106105:	89 04 24             	mov    %eax,(%esp)
80106108:	e8 f9 f6 ff ff       	call   80105806 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010610d:	8b 45 08             	mov    0x8(%ebp),%eax
80106110:	8b 00                	mov    (%eax),%eax
80106112:	85 c0                	test   %eax,%eax
80106114:	75 e2                	jne    801060f8 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80106116:	8b 45 08             	mov    0x8(%ebp),%eax
80106119:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = proc->pid;
8010611f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106125:	8b 50 10             	mov    0x10(%eax),%edx
80106128:	8b 45 08             	mov    0x8(%ebp),%eax
8010612b:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
8010612e:	8b 45 08             	mov    0x8(%ebp),%eax
80106131:	83 c0 04             	add    $0x4,%eax
80106134:	89 04 24             	mov    %eax,(%esp)
80106137:	e8 31 01 00 00       	call   8010626d <release>
}
8010613c:	c9                   	leave  
8010613d:	c3                   	ret    

8010613e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
8010613e:	55                   	push   %ebp
8010613f:	89 e5                	mov    %esp,%ebp
80106141:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80106144:	8b 45 08             	mov    0x8(%ebp),%eax
80106147:	83 c0 04             	add    $0x4,%eax
8010614a:	89 04 24             	mov    %eax,(%esp)
8010614d:	e8 b4 00 00 00       	call   80106206 <acquire>
  lk->locked = 0;
80106152:	8b 45 08             	mov    0x8(%ebp),%eax
80106155:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
8010615b:	8b 45 08             	mov    0x8(%ebp),%eax
8010615e:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80106165:	8b 45 08             	mov    0x8(%ebp),%eax
80106168:	89 04 24             	mov    %eax,(%esp)
8010616b:	e8 a0 f7 ff ff       	call   80105910 <wakeup>
  release(&lk->lk);
80106170:	8b 45 08             	mov    0x8(%ebp),%eax
80106173:	83 c0 04             	add    $0x4,%eax
80106176:	89 04 24             	mov    %eax,(%esp)
80106179:	e8 ef 00 00 00       	call   8010626d <release>
}
8010617e:	c9                   	leave  
8010617f:	c3                   	ret    

80106180 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80106186:	8b 45 08             	mov    0x8(%ebp),%eax
80106189:	83 c0 04             	add    $0x4,%eax
8010618c:	89 04 24             	mov    %eax,(%esp)
8010618f:	e8 72 00 00 00       	call   80106206 <acquire>
  r = lk->locked;
80106194:	8b 45 08             	mov    0x8(%ebp),%eax
80106197:	8b 00                	mov    (%eax),%eax
80106199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010619c:	8b 45 08             	mov    0x8(%ebp),%eax
8010619f:	83 c0 04             	add    $0x4,%eax
801061a2:	89 04 24             	mov    %eax,(%esp)
801061a5:	e8 c3 00 00 00       	call   8010626d <release>
  return r;
801061aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061ad:	c9                   	leave  
801061ae:	c3                   	ret    

801061af <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801061af:	55                   	push   %ebp
801061b0:	89 e5                	mov    %esp,%ebp
801061b2:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801061b5:	9c                   	pushf  
801061b6:	58                   	pop    %eax
801061b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801061ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061bd:	c9                   	leave  
801061be:	c3                   	ret    

801061bf <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801061bf:	55                   	push   %ebp
801061c0:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801061c2:	fa                   	cli    
}
801061c3:	5d                   	pop    %ebp
801061c4:	c3                   	ret    

801061c5 <sti>:

static inline void
sti(void)
{
801061c5:	55                   	push   %ebp
801061c6:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801061c8:	fb                   	sti    
}
801061c9:	5d                   	pop    %ebp
801061ca:	c3                   	ret    

801061cb <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801061cb:	55                   	push   %ebp
801061cc:	89 e5                	mov    %esp,%ebp
801061ce:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801061d1:	8b 55 08             	mov    0x8(%ebp),%edx
801061d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801061d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801061da:	f0 87 02             	lock xchg %eax,(%edx)
801061dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801061e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061e3:	c9                   	leave  
801061e4:	c3                   	ret    

801061e5 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801061e5:	55                   	push   %ebp
801061e6:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801061e8:	8b 45 08             	mov    0x8(%ebp),%eax
801061eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801061ee:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801061f1:	8b 45 08             	mov    0x8(%ebp),%eax
801061f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801061fa:	8b 45 08             	mov    0x8(%ebp),%eax
801061fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106204:	5d                   	pop    %ebp
80106205:	c3                   	ret    

80106206 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106206:	55                   	push   %ebp
80106207:	89 e5                	mov    %esp,%ebp
80106209:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010620c:	e8 4c 01 00 00       	call   8010635d <pushcli>
  if(holding(lk))
80106211:	8b 45 08             	mov    0x8(%ebp),%eax
80106214:	89 04 24             	mov    %eax,(%esp)
80106217:	e8 17 01 00 00       	call   80106333 <holding>
8010621c:	85 c0                	test   %eax,%eax
8010621e:	74 0c                	je     8010622c <acquire+0x26>
    panic("acquire");
80106220:	c7 04 24 29 9f 10 80 	movl   $0x80109f29,(%esp)
80106227:	e8 36 a3 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010622c:	90                   	nop
8010622d:	8b 45 08             	mov    0x8(%ebp),%eax
80106230:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106237:	00 
80106238:	89 04 24             	mov    %eax,(%esp)
8010623b:	e8 8b ff ff ff       	call   801061cb <xchg>
80106240:	85 c0                	test   %eax,%eax
80106242:	75 e9                	jne    8010622d <acquire+0x27>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80106244:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106249:	8b 45 08             	mov    0x8(%ebp),%eax
8010624c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106253:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106256:	8b 45 08             	mov    0x8(%ebp),%eax
80106259:	83 c0 0c             	add    $0xc,%eax
8010625c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106260:	8d 45 08             	lea    0x8(%ebp),%eax
80106263:	89 04 24             	mov    %eax,(%esp)
80106266:	e8 4f 00 00 00       	call   801062ba <getcallerpcs>
}
8010626b:	c9                   	leave  
8010626c:	c3                   	ret    

8010626d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010626d:	55                   	push   %ebp
8010626e:	89 e5                	mov    %esp,%ebp
80106270:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80106273:	8b 45 08             	mov    0x8(%ebp),%eax
80106276:	89 04 24             	mov    %eax,(%esp)
80106279:	e8 b5 00 00 00       	call   80106333 <holding>
8010627e:	85 c0                	test   %eax,%eax
80106280:	75 0c                	jne    8010628e <release+0x21>
    panic("release");
80106282:	c7 04 24 31 9f 10 80 	movl   $0x80109f31,(%esp)
80106289:	e8 d4 a2 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
8010628e:	8b 45 08             	mov    0x8(%ebp),%eax
80106291:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106298:	8b 45 08             	mov    0x8(%ebp),%eax
8010629b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801062a2:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801062a7:	8b 45 08             	mov    0x8(%ebp),%eax
801062aa:	8b 55 08             	mov    0x8(%ebp),%edx
801062ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801062b3:	e8 fb 00 00 00       	call   801063b3 <popcli>
}
801062b8:	c9                   	leave  
801062b9:	c3                   	ret    

801062ba <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801062ba:	55                   	push   %ebp
801062bb:	89 e5                	mov    %esp,%ebp
801062bd:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801062c0:	8b 45 08             	mov    0x8(%ebp),%eax
801062c3:	83 e8 08             	sub    $0x8,%eax
801062c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801062c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801062d0:	eb 38                	jmp    8010630a <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801062d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801062d6:	74 38                	je     80106310 <getcallerpcs+0x56>
801062d8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801062df:	76 2f                	jbe    80106310 <getcallerpcs+0x56>
801062e1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801062e5:	74 29                	je     80106310 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801062e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801062ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801062f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801062f4:	01 c2                	add    %eax,%edx
801062f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062f9:	8b 40 04             	mov    0x4(%eax),%eax
801062fc:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801062fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106301:	8b 00                	mov    (%eax),%eax
80106303:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106306:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010630a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010630e:	7e c2                	jle    801062d2 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106310:	eb 19                	jmp    8010632b <getcallerpcs+0x71>
    pcs[i] = 0;
80106312:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106315:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010631c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010631f:	01 d0                	add    %edx,%eax
80106321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106327:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010632b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010632f:	7e e1                	jle    80106312 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106331:	c9                   	leave  
80106332:	c3                   	ret    

80106333 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106333:	55                   	push   %ebp
80106334:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106336:	8b 45 08             	mov    0x8(%ebp),%eax
80106339:	8b 00                	mov    (%eax),%eax
8010633b:	85 c0                	test   %eax,%eax
8010633d:	74 17                	je     80106356 <holding+0x23>
8010633f:	8b 45 08             	mov    0x8(%ebp),%eax
80106342:	8b 50 08             	mov    0x8(%eax),%edx
80106345:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010634b:	39 c2                	cmp    %eax,%edx
8010634d:	75 07                	jne    80106356 <holding+0x23>
8010634f:	b8 01 00 00 00       	mov    $0x1,%eax
80106354:	eb 05                	jmp    8010635b <holding+0x28>
80106356:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010635b:	5d                   	pop    %ebp
8010635c:	c3                   	ret    

8010635d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010635d:	55                   	push   %ebp
8010635e:	89 e5                	mov    %esp,%ebp
80106360:	83 ec 10             	sub    $0x10,%esp
  int eflags;

  eflags = readeflags();
80106363:	e8 47 fe ff ff       	call   801061af <readeflags>
80106368:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010636b:	e8 4f fe ff ff       	call   801061bf <cli>
  if(cpu->ncli == 0)
80106370:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106376:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010637c:	85 c0                	test   %eax,%eax
8010637e:	75 15                	jne    80106395 <pushcli+0x38>
    cpu->intena = eflags & FL_IF;
80106380:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106386:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106389:	81 e2 00 02 00 00    	and    $0x200,%edx
8010638f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  cpu->ncli += 1;
80106395:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010639b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801063a2:	8b 92 ac 00 00 00    	mov    0xac(%edx),%edx
801063a8:	83 c2 01             	add    $0x1,%edx
801063ab:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801063b1:	c9                   	leave  
801063b2:	c3                   	ret    

801063b3 <popcli>:

void
popcli(void)
{
801063b3:	55                   	push   %ebp
801063b4:	89 e5                	mov    %esp,%ebp
801063b6:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801063b9:	e8 f1 fd ff ff       	call   801061af <readeflags>
801063be:	25 00 02 00 00       	and    $0x200,%eax
801063c3:	85 c0                	test   %eax,%eax
801063c5:	74 0c                	je     801063d3 <popcli+0x20>
    panic("popcli - interruptible");
801063c7:	c7 04 24 39 9f 10 80 	movl   $0x80109f39,(%esp)
801063ce:	e8 8f a1 ff ff       	call   80100562 <panic>
  if(--cpu->ncli < 0)
801063d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063d9:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801063df:	83 ea 01             	sub    $0x1,%edx
801063e2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801063e8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801063ee:	85 c0                	test   %eax,%eax
801063f0:	79 0c                	jns    801063fe <popcli+0x4b>
    panic("popcli");
801063f2:	c7 04 24 50 9f 10 80 	movl   $0x80109f50,(%esp)
801063f9:	e8 64 a1 ff ff       	call   80100562 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801063fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106404:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010640a:	85 c0                	test   %eax,%eax
8010640c:	75 15                	jne    80106423 <popcli+0x70>
8010640e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106414:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010641a:	85 c0                	test   %eax,%eax
8010641c:	74 05                	je     80106423 <popcli+0x70>
    sti();
8010641e:	e8 a2 fd ff ff       	call   801061c5 <sti>
}
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
80106428:	57                   	push   %edi
80106429:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010642a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010642d:	8b 55 10             	mov    0x10(%ebp),%edx
80106430:	8b 45 0c             	mov    0xc(%ebp),%eax
80106433:	89 cb                	mov    %ecx,%ebx
80106435:	89 df                	mov    %ebx,%edi
80106437:	89 d1                	mov    %edx,%ecx
80106439:	fc                   	cld    
8010643a:	f3 aa                	rep stos %al,%es:(%edi)
8010643c:	89 ca                	mov    %ecx,%edx
8010643e:	89 fb                	mov    %edi,%ebx
80106440:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106443:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106446:	5b                   	pop    %ebx
80106447:	5f                   	pop    %edi
80106448:	5d                   	pop    %ebp
80106449:	c3                   	ret    

8010644a <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010644a:	55                   	push   %ebp
8010644b:	89 e5                	mov    %esp,%ebp
8010644d:	57                   	push   %edi
8010644e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010644f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106452:	8b 55 10             	mov    0x10(%ebp),%edx
80106455:	8b 45 0c             	mov    0xc(%ebp),%eax
80106458:	89 cb                	mov    %ecx,%ebx
8010645a:	89 df                	mov    %ebx,%edi
8010645c:	89 d1                	mov    %edx,%ecx
8010645e:	fc                   	cld    
8010645f:	f3 ab                	rep stos %eax,%es:(%edi)
80106461:	89 ca                	mov    %ecx,%edx
80106463:	89 fb                	mov    %edi,%ebx
80106465:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106468:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010646b:	5b                   	pop    %ebx
8010646c:	5f                   	pop    %edi
8010646d:	5d                   	pop    %ebp
8010646e:	c3                   	ret    

8010646f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010646f:	55                   	push   %ebp
80106470:	89 e5                	mov    %esp,%ebp
80106472:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80106475:	8b 45 08             	mov    0x8(%ebp),%eax
80106478:	83 e0 03             	and    $0x3,%eax
8010647b:	85 c0                	test   %eax,%eax
8010647d:	75 49                	jne    801064c8 <memset+0x59>
8010647f:	8b 45 10             	mov    0x10(%ebp),%eax
80106482:	83 e0 03             	and    $0x3,%eax
80106485:	85 c0                	test   %eax,%eax
80106487:	75 3f                	jne    801064c8 <memset+0x59>
    c &= 0xFF;
80106489:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106490:	8b 45 10             	mov    0x10(%ebp),%eax
80106493:	c1 e8 02             	shr    $0x2,%eax
80106496:	89 c2                	mov    %eax,%edx
80106498:	8b 45 0c             	mov    0xc(%ebp),%eax
8010649b:	c1 e0 18             	shl    $0x18,%eax
8010649e:	89 c1                	mov    %eax,%ecx
801064a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801064a3:	c1 e0 10             	shl    $0x10,%eax
801064a6:	09 c1                	or     %eax,%ecx
801064a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801064ab:	c1 e0 08             	shl    $0x8,%eax
801064ae:	09 c8                	or     %ecx,%eax
801064b0:	0b 45 0c             	or     0xc(%ebp),%eax
801064b3:	89 54 24 08          	mov    %edx,0x8(%esp)
801064b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801064bb:	8b 45 08             	mov    0x8(%ebp),%eax
801064be:	89 04 24             	mov    %eax,(%esp)
801064c1:	e8 84 ff ff ff       	call   8010644a <stosl>
801064c6:	eb 19                	jmp    801064e1 <memset+0x72>
  } else
    stosb(dst, c, n);
801064c8:	8b 45 10             	mov    0x10(%ebp),%eax
801064cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801064cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801064d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801064d6:	8b 45 08             	mov    0x8(%ebp),%eax
801064d9:	89 04 24             	mov    %eax,(%esp)
801064dc:	e8 44 ff ff ff       	call   80106425 <stosb>
  return dst;
801064e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801064e4:	c9                   	leave  
801064e5:	c3                   	ret    

801064e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801064e6:	55                   	push   %ebp
801064e7:	89 e5                	mov    %esp,%ebp
801064e9:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801064ec:	8b 45 08             	mov    0x8(%ebp),%eax
801064ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801064f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801064f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801064f8:	eb 30                	jmp    8010652a <memcmp+0x44>
    if(*s1 != *s2)
801064fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064fd:	0f b6 10             	movzbl (%eax),%edx
80106500:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106503:	0f b6 00             	movzbl (%eax),%eax
80106506:	38 c2                	cmp    %al,%dl
80106508:	74 18                	je     80106522 <memcmp+0x3c>
      return *s1 - *s2;
8010650a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010650d:	0f b6 00             	movzbl (%eax),%eax
80106510:	0f b6 d0             	movzbl %al,%edx
80106513:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106516:	0f b6 00             	movzbl (%eax),%eax
80106519:	0f b6 c0             	movzbl %al,%eax
8010651c:	29 c2                	sub    %eax,%edx
8010651e:	89 d0                	mov    %edx,%eax
80106520:	eb 1a                	jmp    8010653c <memcmp+0x56>
    s1++, s2++;
80106522:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106526:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010652a:	8b 45 10             	mov    0x10(%ebp),%eax
8010652d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106530:	89 55 10             	mov    %edx,0x10(%ebp)
80106533:	85 c0                	test   %eax,%eax
80106535:	75 c3                	jne    801064fa <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106537:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010653c:	c9                   	leave  
8010653d:	c3                   	ret    

8010653e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010653e:	55                   	push   %ebp
8010653f:	89 e5                	mov    %esp,%ebp
80106541:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106544:	8b 45 0c             	mov    0xc(%ebp),%eax
80106547:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010654a:	8b 45 08             	mov    0x8(%ebp),%eax
8010654d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106550:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106553:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106556:	73 3d                	jae    80106595 <memmove+0x57>
80106558:	8b 45 10             	mov    0x10(%ebp),%eax
8010655b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010655e:	01 d0                	add    %edx,%eax
80106560:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106563:	76 30                	jbe    80106595 <memmove+0x57>
    s += n;
80106565:	8b 45 10             	mov    0x10(%ebp),%eax
80106568:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010656b:	8b 45 10             	mov    0x10(%ebp),%eax
8010656e:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106571:	eb 13                	jmp    80106586 <memmove+0x48>
      *--d = *--s;
80106573:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106577:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010657b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010657e:	0f b6 10             	movzbl (%eax),%edx
80106581:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106584:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106586:	8b 45 10             	mov    0x10(%ebp),%eax
80106589:	8d 50 ff             	lea    -0x1(%eax),%edx
8010658c:	89 55 10             	mov    %edx,0x10(%ebp)
8010658f:	85 c0                	test   %eax,%eax
80106591:	75 e0                	jne    80106573 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106593:	eb 26                	jmp    801065bb <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106595:	eb 17                	jmp    801065ae <memmove+0x70>
      *d++ = *s++;
80106597:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010659a:	8d 50 01             	lea    0x1(%eax),%edx
8010659d:	89 55 f8             	mov    %edx,-0x8(%ebp)
801065a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065a3:	8d 4a 01             	lea    0x1(%edx),%ecx
801065a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801065a9:	0f b6 12             	movzbl (%edx),%edx
801065ac:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801065ae:	8b 45 10             	mov    0x10(%ebp),%eax
801065b1:	8d 50 ff             	lea    -0x1(%eax),%edx
801065b4:	89 55 10             	mov    %edx,0x10(%ebp)
801065b7:	85 c0                	test   %eax,%eax
801065b9:	75 dc                	jne    80106597 <memmove+0x59>
      *d++ = *s++;

  return dst;
801065bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065be:	c9                   	leave  
801065bf:	c3                   	ret    

801065c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801065c6:	8b 45 10             	mov    0x10(%ebp),%eax
801065c9:	89 44 24 08          	mov    %eax,0x8(%esp)
801065cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801065d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801065d4:	8b 45 08             	mov    0x8(%ebp),%eax
801065d7:	89 04 24             	mov    %eax,(%esp)
801065da:	e8 5f ff ff ff       	call   8010653e <memmove>
}
801065df:	c9                   	leave  
801065e0:	c3                   	ret    

801065e1 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801065e1:	55                   	push   %ebp
801065e2:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801065e4:	eb 0c                	jmp    801065f2 <strncmp+0x11>
    n--, p++, q++;
801065e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801065ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801065ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801065f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801065f6:	74 1a                	je     80106612 <strncmp+0x31>
801065f8:	8b 45 08             	mov    0x8(%ebp),%eax
801065fb:	0f b6 00             	movzbl (%eax),%eax
801065fe:	84 c0                	test   %al,%al
80106600:	74 10                	je     80106612 <strncmp+0x31>
80106602:	8b 45 08             	mov    0x8(%ebp),%eax
80106605:	0f b6 10             	movzbl (%eax),%edx
80106608:	8b 45 0c             	mov    0xc(%ebp),%eax
8010660b:	0f b6 00             	movzbl (%eax),%eax
8010660e:	38 c2                	cmp    %al,%dl
80106610:	74 d4                	je     801065e6 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106612:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106616:	75 07                	jne    8010661f <strncmp+0x3e>
    return 0;
80106618:	b8 00 00 00 00       	mov    $0x0,%eax
8010661d:	eb 16                	jmp    80106635 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010661f:	8b 45 08             	mov    0x8(%ebp),%eax
80106622:	0f b6 00             	movzbl (%eax),%eax
80106625:	0f b6 d0             	movzbl %al,%edx
80106628:	8b 45 0c             	mov    0xc(%ebp),%eax
8010662b:	0f b6 00             	movzbl (%eax),%eax
8010662e:	0f b6 c0             	movzbl %al,%eax
80106631:	29 c2                	sub    %eax,%edx
80106633:	89 d0                	mov    %edx,%eax
}
80106635:	5d                   	pop    %ebp
80106636:	c3                   	ret    

80106637 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106637:	55                   	push   %ebp
80106638:	89 e5                	mov    %esp,%ebp
8010663a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010663d:	8b 45 08             	mov    0x8(%ebp),%eax
80106640:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106643:	90                   	nop
80106644:	8b 45 10             	mov    0x10(%ebp),%eax
80106647:	8d 50 ff             	lea    -0x1(%eax),%edx
8010664a:	89 55 10             	mov    %edx,0x10(%ebp)
8010664d:	85 c0                	test   %eax,%eax
8010664f:	7e 1e                	jle    8010666f <strncpy+0x38>
80106651:	8b 45 08             	mov    0x8(%ebp),%eax
80106654:	8d 50 01             	lea    0x1(%eax),%edx
80106657:	89 55 08             	mov    %edx,0x8(%ebp)
8010665a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010665d:	8d 4a 01             	lea    0x1(%edx),%ecx
80106660:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106663:	0f b6 12             	movzbl (%edx),%edx
80106666:	88 10                	mov    %dl,(%eax)
80106668:	0f b6 00             	movzbl (%eax),%eax
8010666b:	84 c0                	test   %al,%al
8010666d:	75 d5                	jne    80106644 <strncpy+0xd>
    ;
  while(n-- > 0)
8010666f:	eb 0c                	jmp    8010667d <strncpy+0x46>
    *s++ = 0;
80106671:	8b 45 08             	mov    0x8(%ebp),%eax
80106674:	8d 50 01             	lea    0x1(%eax),%edx
80106677:	89 55 08             	mov    %edx,0x8(%ebp)
8010667a:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010667d:	8b 45 10             	mov    0x10(%ebp),%eax
80106680:	8d 50 ff             	lea    -0x1(%eax),%edx
80106683:	89 55 10             	mov    %edx,0x10(%ebp)
80106686:	85 c0                	test   %eax,%eax
80106688:	7f e7                	jg     80106671 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010668a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010668d:	c9                   	leave  
8010668e:	c3                   	ret    

8010668f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010668f:	55                   	push   %ebp
80106690:	89 e5                	mov    %esp,%ebp
80106692:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80106695:	8b 45 08             	mov    0x8(%ebp),%eax
80106698:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010669b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010669f:	7f 05                	jg     801066a6 <safestrcpy+0x17>
    return os;
801066a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066a4:	eb 31                	jmp    801066d7 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801066a6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066ae:	7e 1e                	jle    801066ce <safestrcpy+0x3f>
801066b0:	8b 45 08             	mov    0x8(%ebp),%eax
801066b3:	8d 50 01             	lea    0x1(%eax),%edx
801066b6:	89 55 08             	mov    %edx,0x8(%ebp)
801066b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801066bc:	8d 4a 01             	lea    0x1(%edx),%ecx
801066bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801066c2:	0f b6 12             	movzbl (%edx),%edx
801066c5:	88 10                	mov    %dl,(%eax)
801066c7:	0f b6 00             	movzbl (%eax),%eax
801066ca:	84 c0                	test   %al,%al
801066cc:	75 d8                	jne    801066a6 <safestrcpy+0x17>
    ;
  *s = 0;
801066ce:	8b 45 08             	mov    0x8(%ebp),%eax
801066d1:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801066d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066d7:	c9                   	leave  
801066d8:	c3                   	ret    

801066d9 <strlen>:

int
strlen(const char *s)
{
801066d9:	55                   	push   %ebp
801066da:	89 e5                	mov    %esp,%ebp
801066dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801066df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801066e6:	eb 04                	jmp    801066ec <strlen+0x13>
801066e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066ef:	8b 45 08             	mov    0x8(%ebp),%eax
801066f2:	01 d0                	add    %edx,%eax
801066f4:	0f b6 00             	movzbl (%eax),%eax
801066f7:	84 c0                	test   %al,%al
801066f9:	75 ed                	jne    801066e8 <strlen+0xf>
    ;
  return n;
801066fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066fe:	c9                   	leave  
801066ff:	c3                   	ret    

80106700 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106700:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106704:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106708:	55                   	push   %ebp
  pushl %ebx
80106709:	53                   	push   %ebx
  pushl %esi
8010670a:	56                   	push   %esi
  pushl %edi
8010670b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010670c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010670e:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106710:	5f                   	pop    %edi
  popl %esi
80106711:	5e                   	pop    %esi
  popl %ebx
80106712:	5b                   	pop    %ebx
  popl %ebp
80106713:	5d                   	pop    %ebp
  ret
80106714:	c3                   	ret    

80106715 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106715:	55                   	push   %ebp
80106716:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106718:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010671e:	8b 00                	mov    (%eax),%eax
80106720:	3b 45 08             	cmp    0x8(%ebp),%eax
80106723:	76 12                	jbe    80106737 <fetchint+0x22>
80106725:	8b 45 08             	mov    0x8(%ebp),%eax
80106728:	8d 50 04             	lea    0x4(%eax),%edx
8010672b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106731:	8b 00                	mov    (%eax),%eax
80106733:	39 c2                	cmp    %eax,%edx
80106735:	76 07                	jbe    8010673e <fetchint+0x29>
    return -1;
80106737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673c:	eb 0f                	jmp    8010674d <fetchint+0x38>
  *ip = *(int*)(addr);
8010673e:	8b 45 08             	mov    0x8(%ebp),%eax
80106741:	8b 10                	mov    (%eax),%edx
80106743:	8b 45 0c             	mov    0xc(%ebp),%eax
80106746:	89 10                	mov    %edx,(%eax)
  return 0;
80106748:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010674d:	5d                   	pop    %ebp
8010674e:	c3                   	ret    

8010674f <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
8010674f:	55                   	push   %ebp
80106750:	89 e5                	mov    %esp,%ebp
80106752:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106755:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675b:	8b 00                	mov    (%eax),%eax
8010675d:	3b 45 08             	cmp    0x8(%ebp),%eax
80106760:	77 07                	ja     80106769 <fetchstr+0x1a>
    return -1;
80106762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106767:	eb 46                	jmp    801067af <fetchstr+0x60>
  *pp = (char*)addr;
80106769:	8b 55 08             	mov    0x8(%ebp),%edx
8010676c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010676f:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106771:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106777:	8b 00                	mov    (%eax),%eax
80106779:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010677c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010677f:	8b 00                	mov    (%eax),%eax
80106781:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106784:	eb 1c                	jmp    801067a2 <fetchstr+0x53>
    if(*s == 0)
80106786:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106789:	0f b6 00             	movzbl (%eax),%eax
8010678c:	84 c0                	test   %al,%al
8010678e:	75 0e                	jne    8010679e <fetchstr+0x4f>
      return s - *pp;
80106790:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106793:	8b 45 0c             	mov    0xc(%ebp),%eax
80106796:	8b 00                	mov    (%eax),%eax
80106798:	29 c2                	sub    %eax,%edx
8010679a:	89 d0                	mov    %edx,%eax
8010679c:	eb 11                	jmp    801067af <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010679e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801067a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801067a8:	72 dc                	jb     80106786 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801067aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067af:	c9                   	leave  
801067b0:	c3                   	ret    

801067b1 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801067b1:	55                   	push   %ebp
801067b2:	89 e5                	mov    %esp,%ebp
801067b4:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801067b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067bd:	8b 40 18             	mov    0x18(%eax),%eax
801067c0:	8b 50 44             	mov    0x44(%eax),%edx
801067c3:	8b 45 08             	mov    0x8(%ebp),%eax
801067c6:	c1 e0 02             	shl    $0x2,%eax
801067c9:	01 d0                	add    %edx,%eax
801067cb:	8d 50 04             	lea    0x4(%eax),%edx
801067ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801067d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801067d5:	89 14 24             	mov    %edx,(%esp)
801067d8:	e8 38 ff ff ff       	call   80106715 <fetchint>
}
801067dd:	c9                   	leave  
801067de:	c3                   	ret    

801067df <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801067df:	55                   	push   %ebp
801067e0:	89 e5                	mov    %esp,%ebp
801067e2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(argint(n, &i) < 0)
801067e5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801067e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ec:	8b 45 08             	mov    0x8(%ebp),%eax
801067ef:	89 04 24             	mov    %eax,(%esp)
801067f2:	e8 ba ff ff ff       	call   801067b1 <argint>
801067f7:	85 c0                	test   %eax,%eax
801067f9:	79 07                	jns    80106802 <argptr+0x23>
    return -1;
801067fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106800:	eb 43                	jmp    80106845 <argptr+0x66>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80106802:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106806:	78 27                	js     8010682f <argptr+0x50>
80106808:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010680b:	89 c2                	mov    %eax,%edx
8010680d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106813:	8b 00                	mov    (%eax),%eax
80106815:	39 c2                	cmp    %eax,%edx
80106817:	73 16                	jae    8010682f <argptr+0x50>
80106819:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010681c:	89 c2                	mov    %eax,%edx
8010681e:	8b 45 10             	mov    0x10(%ebp),%eax
80106821:	01 c2                	add    %eax,%edx
80106823:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106829:	8b 00                	mov    (%eax),%eax
8010682b:	39 c2                	cmp    %eax,%edx
8010682d:	76 07                	jbe    80106836 <argptr+0x57>
    return -1;
8010682f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106834:	eb 0f                	jmp    80106845 <argptr+0x66>
  *pp = (char*)i;
80106836:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106839:	89 c2                	mov    %eax,%edx
8010683b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010683e:	89 10                	mov    %edx,(%eax)
  return 0;
80106840:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106845:	c9                   	leave  
80106846:	c3                   	ret    

80106847 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106847:	55                   	push   %ebp
80106848:	89 e5                	mov    %esp,%ebp
8010684a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010684d:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106850:	89 44 24 04          	mov    %eax,0x4(%esp)
80106854:	8b 45 08             	mov    0x8(%ebp),%eax
80106857:	89 04 24             	mov    %eax,(%esp)
8010685a:	e8 52 ff ff ff       	call   801067b1 <argint>
8010685f:	85 c0                	test   %eax,%eax
80106861:	79 07                	jns    8010686a <argstr+0x23>
    return -1;
80106863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106868:	eb 12                	jmp    8010687c <argstr+0x35>
  return fetchstr(addr, pp);
8010686a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010686d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106870:	89 54 24 04          	mov    %edx,0x4(%esp)
80106874:	89 04 24             	mov    %eax,(%esp)
80106877:	e8 d3 fe ff ff       	call   8010674f <fetchstr>
}
8010687c:	c9                   	leave  
8010687d:	c3                   	ret    

8010687e <syscall>:
[SYS_thread_exit]    sys_thread_exit,
};

void
syscall(void)
{
8010687e:	55                   	push   %ebp
8010687f:	89 e5                	mov    %esp,%ebp
80106881:	53                   	push   %ebx
80106882:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80106885:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010688b:	8b 40 18             	mov    0x18(%eax),%eax
8010688e:	8b 40 1c             	mov    0x1c(%eax),%eax
80106891:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106898:	7e 30                	jle    801068ca <syscall+0x4c>
8010689a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010689d:	83 f8 1d             	cmp    $0x1d,%eax
801068a0:	77 28                	ja     801068ca <syscall+0x4c>
801068a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a5:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801068ac:	85 c0                	test   %eax,%eax
801068ae:	74 1a                	je     801068ca <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801068b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068b6:	8b 58 18             	mov    0x18(%eax),%ebx
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801068c3:	ff d0                	call   *%eax
801068c5:	89 43 1c             	mov    %eax,0x1c(%ebx)
801068c8:	eb 3d                	jmp    80106907 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801068ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068d0:	8d 48 6c             	lea    0x6c(%eax),%ecx
801068d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801068d9:	8b 40 10             	mov    0x10(%eax),%eax
801068dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068df:	89 54 24 0c          	mov    %edx,0xc(%esp)
801068e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801068eb:	c7 04 24 57 9f 10 80 	movl   $0x80109f57,(%esp)
801068f2:	e8 d1 9a ff ff       	call   801003c8 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801068f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068fd:	8b 40 18             	mov    0x18(%eax),%eax
80106900:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106907:	83 c4 24             	add    $0x24,%esp
8010690a:	5b                   	pop    %ebx
8010690b:	5d                   	pop    %ebp
8010690c:	c3                   	ret    

8010690d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010690d:	55                   	push   %ebp
8010690e:	89 e5                	mov    %esp,%ebp
80106910:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106913:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106916:	89 44 24 04          	mov    %eax,0x4(%esp)
8010691a:	8b 45 08             	mov    0x8(%ebp),%eax
8010691d:	89 04 24             	mov    %eax,(%esp)
80106920:	e8 8c fe ff ff       	call   801067b1 <argint>
80106925:	85 c0                	test   %eax,%eax
80106927:	79 07                	jns    80106930 <argfd+0x23>
    return -1;
80106929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010692e:	eb 50                	jmp    80106980 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106930:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106933:	85 c0                	test   %eax,%eax
80106935:	78 21                	js     80106958 <argfd+0x4b>
80106937:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010693a:	83 f8 0f             	cmp    $0xf,%eax
8010693d:	7f 19                	jg     80106958 <argfd+0x4b>
8010693f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106945:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106948:	83 c2 08             	add    $0x8,%edx
8010694b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010694f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106956:	75 07                	jne    8010695f <argfd+0x52>
    return -1;
80106958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695d:	eb 21                	jmp    80106980 <argfd+0x73>
  if(pfd)
8010695f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106963:	74 08                	je     8010696d <argfd+0x60>
    *pfd = fd;
80106965:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106968:	8b 45 0c             	mov    0xc(%ebp),%eax
8010696b:	89 10                	mov    %edx,(%eax)
  if(pf)
8010696d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106971:	74 08                	je     8010697b <argfd+0x6e>
    *pf = f;
80106973:	8b 45 10             	mov    0x10(%ebp),%eax
80106976:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106979:	89 10                	mov    %edx,(%eax)
  return 0;
8010697b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106980:	c9                   	leave  
80106981:	c3                   	ret    

80106982 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106982:	55                   	push   %ebp
80106983:	89 e5                	mov    %esp,%ebp
80106985:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106988:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010698f:	eb 30                	jmp    801069c1 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106991:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106997:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010699a:	83 c2 08             	add    $0x8,%edx
8010699d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801069a1:	85 c0                	test   %eax,%eax
801069a3:	75 18                	jne    801069bd <fdalloc+0x3b>
      proc->ofile[fd] = f;
801069a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069ae:	8d 4a 08             	lea    0x8(%edx),%ecx
801069b1:	8b 55 08             	mov    0x8(%ebp),%edx
801069b4:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801069b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069bb:	eb 0f                	jmp    801069cc <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801069bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801069c1:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801069c5:	7e ca                	jle    80106991 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801069c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069cc:	c9                   	leave  
801069cd:	c3                   	ret    

801069ce <sys_dup>:

int
sys_dup(void)
{
801069ce:	55                   	push   %ebp
801069cf:	89 e5                	mov    %esp,%ebp
801069d1:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801069d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069d7:	89 44 24 08          	mov    %eax,0x8(%esp)
801069db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069e2:	00 
801069e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069ea:	e8 1e ff ff ff       	call   8010690d <argfd>
801069ef:	85 c0                	test   %eax,%eax
801069f1:	79 07                	jns    801069fa <sys_dup+0x2c>
    return -1;
801069f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069f8:	eb 29                	jmp    80106a23 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801069fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069fd:	89 04 24             	mov    %eax,(%esp)
80106a00:	e8 7d ff ff ff       	call   80106982 <fdalloc>
80106a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a0c:	79 07                	jns    80106a15 <sys_dup+0x47>
    return -1;
80106a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a13:	eb 0e                	jmp    80106a23 <sys_dup+0x55>
  filedup(f);
80106a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a18:	89 04 24             	mov    %eax,(%esp)
80106a1b:	e8 da a5 ff ff       	call   80100ffa <filedup>
  return fd;
80106a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a23:	c9                   	leave  
80106a24:	c3                   	ret    

80106a25 <sys_read>:

int
sys_read(void)
{
80106a25:	55                   	push   %ebp
80106a26:	89 e5                	mov    %esp,%ebp
80106a28:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a2e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a39:	00 
80106a3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a41:	e8 c7 fe ff ff       	call   8010690d <argfd>
80106a46:	85 c0                	test   %eax,%eax
80106a48:	78 35                	js     80106a7f <sys_read+0x5a>
80106a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a51:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a58:	e8 54 fd ff ff       	call   801067b1 <argint>
80106a5d:	85 c0                	test   %eax,%eax
80106a5f:	78 1e                	js     80106a7f <sys_read+0x5a>
80106a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a64:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a68:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a76:	e8 64 fd ff ff       	call   801067df <argptr>
80106a7b:	85 c0                	test   %eax,%eax
80106a7d:	79 07                	jns    80106a86 <sys_read+0x61>
    return -1;
80106a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a84:	eb 19                	jmp    80106a9f <sys_read+0x7a>
  return fileread(f, p, n);
80106a86:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106a89:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a93:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a97:	89 04 24             	mov    %eax,(%esp)
80106a9a:	e8 c8 a6 ff ff       	call   80101167 <fileread>
}
80106a9f:	c9                   	leave  
80106aa0:	c3                   	ret    

80106aa1 <sys_write>:

int
sys_write(void)
{
80106aa1:	55                   	push   %ebp
80106aa2:	89 e5                	mov    %esp,%ebp
80106aa4:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106aa7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
80106aae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ab5:	00 
80106ab6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106abd:	e8 4b fe ff ff       	call   8010690d <argfd>
80106ac2:	85 c0                	test   %eax,%eax
80106ac4:	78 35                	js     80106afb <sys_write+0x5a>
80106ac6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106acd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106ad4:	e8 d8 fc ff ff       	call   801067b1 <argint>
80106ad9:	85 c0                	test   %eax,%eax
80106adb:	78 1e                	js     80106afb <sys_write+0x5a>
80106add:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ae0:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ae4:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106af2:	e8 e8 fc ff ff       	call   801067df <argptr>
80106af7:	85 c0                	test   %eax,%eax
80106af9:	79 07                	jns    80106b02 <sys_write+0x61>
    return -1;
80106afb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b00:	eb 19                	jmp    80106b1b <sys_write+0x7a>
  return filewrite(f, p, n);
80106b02:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b05:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b0b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106b0f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b13:	89 04 24             	mov    %eax,(%esp)
80106b16:	e8 08 a7 ff ff       	call   80101223 <filewrite>
}
80106b1b:	c9                   	leave  
80106b1c:	c3                   	ret    

80106b1d <sys_close>:

int
sys_close(void)
{
80106b1d:	55                   	push   %ebp
80106b1e:	89 e5                	mov    %esp,%ebp
80106b20:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80106b23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b26:	89 44 24 08          	mov    %eax,0x8(%esp)
80106b2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b38:	e8 d0 fd ff ff       	call   8010690d <argfd>
80106b3d:	85 c0                	test   %eax,%eax
80106b3f:	79 07                	jns    80106b48 <sys_close+0x2b>
    return -1;
80106b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b46:	eb 24                	jmp    80106b6c <sys_close+0x4f>
  proc->ofile[fd] = 0;
80106b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b51:	83 c2 08             	add    $0x8,%edx
80106b54:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b5b:	00 
  fileclose(f);
80106b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b5f:	89 04 24             	mov    %eax,(%esp)
80106b62:	e8 db a4 ff ff       	call   80101042 <fileclose>
  return 0;
80106b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6c:	c9                   	leave  
80106b6d:	c3                   	ret    

80106b6e <sys_fstat>:

int
sys_fstat(void)
{
80106b6e:	55                   	push   %ebp
80106b6f:	89 e5                	mov    %esp,%ebp
80106b71:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b77:	89 44 24 08          	mov    %eax,0x8(%esp)
80106b7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b82:	00 
80106b83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b8a:	e8 7e fd ff ff       	call   8010690d <argfd>
80106b8f:	85 c0                	test   %eax,%eax
80106b91:	78 1f                	js     80106bb2 <sys_fstat+0x44>
80106b93:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106b9a:	00 
80106b9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ba9:	e8 31 fc ff ff       	call   801067df <argptr>
80106bae:	85 c0                	test   %eax,%eax
80106bb0:	79 07                	jns    80106bb9 <sys_fstat+0x4b>
    return -1;
80106bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb7:	eb 12                	jmp    80106bcb <sys_fstat+0x5d>
  return filestat(f, st);
80106bb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbf:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bc3:	89 04 24             	mov    %eax,(%esp)
80106bc6:	e8 4d a5 ff ff       	call   80101118 <filestat>
}
80106bcb:	c9                   	leave  
80106bcc:	c3                   	ret    

80106bcd <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106bcd:	55                   	push   %ebp
80106bce:	89 e5                	mov    %esp,%ebp
80106bd0:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106bd3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106be1:	e8 61 fc ff ff       	call   80106847 <argstr>
80106be6:	85 c0                	test   %eax,%eax
80106be8:	78 17                	js     80106c01 <sys_link+0x34>
80106bea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106bed:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bf1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106bf8:	e8 4a fc ff ff       	call   80106847 <argstr>
80106bfd:	85 c0                	test   %eax,%eax
80106bff:	79 0a                	jns    80106c0b <sys_link+0x3e>
    return -1;
80106c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c06:	e9 42 01 00 00       	jmp    80106d4d <sys_link+0x180>

  begin_op();
80106c0b:	e8 1b cb ff ff       	call   8010372b <begin_op>
  if((ip = namei(old)) == 0){
80106c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106c13:	89 04 24             	mov    %eax,(%esp)
80106c16:	e8 71 ba ff ff       	call   8010268c <namei>
80106c1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c22:	75 0f                	jne    80106c33 <sys_link+0x66>
    end_op();
80106c24:	e8 86 cb ff ff       	call   801037af <end_op>
    return -1;
80106c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c2e:	e9 1a 01 00 00       	jmp    80106d4d <sys_link+0x180>
  }

  ilock(ip);
80106c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c36:	89 04 24             	mov    %eax,(%esp)
80106c39:	e8 34 ad ff ff       	call   80101972 <ilock>
  if(ip->type == T_DIR){
80106c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c41:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106c45:	66 83 f8 01          	cmp    $0x1,%ax
80106c49:	75 1a                	jne    80106c65 <sys_link+0x98>
    iunlockput(ip);
80106c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4e:	89 04 24             	mov    %eax,(%esp)
80106c51:	e8 0b af ff ff       	call   80101b61 <iunlockput>
    end_op();
80106c56:	e8 54 cb ff ff       	call   801037af <end_op>
    return -1;
80106c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c60:	e9 e8 00 00 00       	jmp    80106d4d <sys_link+0x180>
  }

  ip->nlink++;
80106c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c68:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106c6c:	8d 50 01             	lea    0x1(%eax),%edx
80106c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c72:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c79:	89 04 24             	mov    %eax,(%esp)
80106c7c:	e8 2c ab ff ff       	call   801017ad <iupdate>
  iunlock(ip);
80106c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c84:	89 04 24             	mov    %eax,(%esp)
80106c87:	e8 fd ad ff ff       	call   80101a89 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106c8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c8f:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106c92:	89 54 24 04          	mov    %edx,0x4(%esp)
80106c96:	89 04 24             	mov    %eax,(%esp)
80106c99:	e8 10 ba ff ff       	call   801026ae <nameiparent>
80106c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ca5:	75 02                	jne    80106ca9 <sys_link+0xdc>
    goto bad;
80106ca7:	eb 68                	jmp    80106d11 <sys_link+0x144>
  ilock(dp);
80106ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cac:	89 04 24             	mov    %eax,(%esp)
80106caf:	e8 be ac ff ff       	call   80101972 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cb7:	8b 10                	mov    (%eax),%edx
80106cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cbc:	8b 00                	mov    (%eax),%eax
80106cbe:	39 c2                	cmp    %eax,%edx
80106cc0:	75 20                	jne    80106ce2 <sys_link+0x115>
80106cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cc5:	8b 40 04             	mov    0x4(%eax),%eax
80106cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ccc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cd6:	89 04 24             	mov    %eax,(%esp)
80106cd9:	e8 ee b6 ff ff       	call   801023cc <dirlink>
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	79 0d                	jns    80106cef <sys_link+0x122>
    iunlockput(dp);
80106ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ce5:	89 04 24             	mov    %eax,(%esp)
80106ce8:	e8 74 ae ff ff       	call   80101b61 <iunlockput>
    goto bad;
80106ced:	eb 22                	jmp    80106d11 <sys_link+0x144>
  }
  iunlockput(dp);
80106cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cf2:	89 04 24             	mov    %eax,(%esp)
80106cf5:	e8 67 ae ff ff       	call   80101b61 <iunlockput>
  iput(ip);
80106cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cfd:	89 04 24             	mov    %eax,(%esp)
80106d00:	e8 c8 ad ff ff       	call   80101acd <iput>

  end_op();
80106d05:	e8 a5 ca ff ff       	call   801037af <end_op>

  return 0;
80106d0a:	b8 00 00 00 00       	mov    $0x0,%eax
80106d0f:	eb 3c                	jmp    80106d4d <sys_link+0x180>

bad:
  ilock(ip);
80106d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d14:	89 04 24             	mov    %eax,(%esp)
80106d17:	e8 56 ac ff ff       	call   80101972 <ilock>
  ip->nlink--;
80106d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d1f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106d23:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d29:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d30:	89 04 24             	mov    %eax,(%esp)
80106d33:	e8 75 aa ff ff       	call   801017ad <iupdate>
  iunlockput(ip);
80106d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d3b:	89 04 24             	mov    %eax,(%esp)
80106d3e:	e8 1e ae ff ff       	call   80101b61 <iunlockput>
  end_op();
80106d43:	e8 67 ca ff ff       	call   801037af <end_op>
  return -1;
80106d48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d4d:	c9                   	leave  
80106d4e:	c3                   	ret    

80106d4f <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106d4f:	55                   	push   %ebp
80106d50:	89 e5                	mov    %esp,%ebp
80106d52:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106d55:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106d5c:	eb 4b                	jmp    80106da9 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d61:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106d68:	00 
80106d69:	89 44 24 08          	mov    %eax,0x8(%esp)
80106d6d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106d70:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d74:	8b 45 08             	mov    0x8(%ebp),%eax
80106d77:	89 04 24             	mov    %eax,(%esp)
80106d7a:	e8 6f b2 ff ff       	call   80101fee <readi>
80106d7f:	83 f8 10             	cmp    $0x10,%eax
80106d82:	74 0c                	je     80106d90 <isdirempty+0x41>
      panic("isdirempty: readi");
80106d84:	c7 04 24 73 9f 10 80 	movl   $0x80109f73,(%esp)
80106d8b:	e8 d2 97 ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80106d90:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106d94:	66 85 c0             	test   %ax,%ax
80106d97:	74 07                	je     80106da0 <isdirempty+0x51>
      return 0;
80106d99:	b8 00 00 00 00       	mov    $0x0,%eax
80106d9e:	eb 1b                	jmp    80106dbb <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106da3:	83 c0 10             	add    $0x10,%eax
80106da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106dac:	8b 45 08             	mov    0x8(%ebp),%eax
80106daf:	8b 40 58             	mov    0x58(%eax),%eax
80106db2:	39 c2                	cmp    %eax,%edx
80106db4:	72 a8                	jb     80106d5e <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106db6:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106dbb:	c9                   	leave  
80106dbc:	c3                   	ret    

80106dbd <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106dbd:	55                   	push   %ebp
80106dbe:	89 e5                	mov    %esp,%ebp
80106dc0:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106dc3:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106dd1:	e8 71 fa ff ff       	call   80106847 <argstr>
80106dd6:	85 c0                	test   %eax,%eax
80106dd8:	79 0a                	jns    80106de4 <sys_unlink+0x27>
    return -1;
80106dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ddf:	e9 af 01 00 00       	jmp    80106f93 <sys_unlink+0x1d6>

  begin_op();
80106de4:	e8 42 c9 ff ff       	call   8010372b <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106de9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106dec:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106def:	89 54 24 04          	mov    %edx,0x4(%esp)
80106df3:	89 04 24             	mov    %eax,(%esp)
80106df6:	e8 b3 b8 ff ff       	call   801026ae <nameiparent>
80106dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e02:	75 0f                	jne    80106e13 <sys_unlink+0x56>
    end_op();
80106e04:	e8 a6 c9 ff ff       	call   801037af <end_op>
    return -1;
80106e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e0e:	e9 80 01 00 00       	jmp    80106f93 <sys_unlink+0x1d6>
  }

  ilock(dp);
80106e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e16:	89 04 24             	mov    %eax,(%esp)
80106e19:	e8 54 ab ff ff       	call   80101972 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106e1e:	c7 44 24 04 85 9f 10 	movl   $0x80109f85,0x4(%esp)
80106e25:	80 
80106e26:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e29:	89 04 24             	mov    %eax,(%esp)
80106e2c:	e8 b0 b4 ff ff       	call   801022e1 <namecmp>
80106e31:	85 c0                	test   %eax,%eax
80106e33:	0f 84 45 01 00 00    	je     80106f7e <sys_unlink+0x1c1>
80106e39:	c7 44 24 04 87 9f 10 	movl   $0x80109f87,0x4(%esp)
80106e40:	80 
80106e41:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e44:	89 04 24             	mov    %eax,(%esp)
80106e47:	e8 95 b4 ff ff       	call   801022e1 <namecmp>
80106e4c:	85 c0                	test   %eax,%eax
80106e4e:	0f 84 2a 01 00 00    	je     80106f7e <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106e54:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106e57:	89 44 24 08          	mov    %eax,0x8(%esp)
80106e5b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e65:	89 04 24             	mov    %eax,(%esp)
80106e68:	e8 96 b4 ff ff       	call   80102303 <dirlookup>
80106e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e74:	75 05                	jne    80106e7b <sys_unlink+0xbe>
    goto bad;
80106e76:	e9 03 01 00 00       	jmp    80106f7e <sys_unlink+0x1c1>
  ilock(ip);
80106e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e7e:	89 04 24             	mov    %eax,(%esp)
80106e81:	e8 ec aa ff ff       	call   80101972 <ilock>

  if(ip->nlink < 1)
80106e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e89:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106e8d:	66 85 c0             	test   %ax,%ax
80106e90:	7f 0c                	jg     80106e9e <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106e92:	c7 04 24 8a 9f 10 80 	movl   $0x80109f8a,(%esp)
80106e99:	e8 c4 96 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ea1:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106ea5:	66 83 f8 01          	cmp    $0x1,%ax
80106ea9:	75 1f                	jne    80106eca <sys_unlink+0x10d>
80106eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eae:	89 04 24             	mov    %eax,(%esp)
80106eb1:	e8 99 fe ff ff       	call   80106d4f <isdirempty>
80106eb6:	85 c0                	test   %eax,%eax
80106eb8:	75 10                	jne    80106eca <sys_unlink+0x10d>
    iunlockput(ip);
80106eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ebd:	89 04 24             	mov    %eax,(%esp)
80106ec0:	e8 9c ac ff ff       	call   80101b61 <iunlockput>
    goto bad;
80106ec5:	e9 b4 00 00 00       	jmp    80106f7e <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80106eca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106ed1:	00 
80106ed2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ed9:	00 
80106eda:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106edd:	89 04 24             	mov    %eax,(%esp)
80106ee0:	e8 8a f5 ff ff       	call   8010646f <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106ee5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106ee8:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106eef:	00 
80106ef0:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ef4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80106efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106efe:	89 04 24             	mov    %eax,(%esp)
80106f01:	e8 4c b2 ff ff       	call   80102152 <writei>
80106f06:	83 f8 10             	cmp    $0x10,%eax
80106f09:	74 0c                	je     80106f17 <sys_unlink+0x15a>
    panic("unlink: writei");
80106f0b:	c7 04 24 9c 9f 10 80 	movl   $0x80109f9c,(%esp)
80106f12:	e8 4b 96 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80106f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f1a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106f1e:	66 83 f8 01          	cmp    $0x1,%ax
80106f22:	75 1c                	jne    80106f40 <sys_unlink+0x183>
    dp->nlink--;
80106f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f27:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106f2b:	8d 50 ff             	lea    -0x1(%eax),%edx
80106f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f31:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f38:	89 04 24             	mov    %eax,(%esp)
80106f3b:	e8 6d a8 ff ff       	call   801017ad <iupdate>
  }
  iunlockput(dp);
80106f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f43:	89 04 24             	mov    %eax,(%esp)
80106f46:	e8 16 ac ff ff       	call   80101b61 <iunlockput>

  ip->nlink--;
80106f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f4e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106f52:	8d 50 ff             	lea    -0x1(%eax),%edx
80106f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f58:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f5f:	89 04 24             	mov    %eax,(%esp)
80106f62:	e8 46 a8 ff ff       	call   801017ad <iupdate>
  iunlockput(ip);
80106f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f6a:	89 04 24             	mov    %eax,(%esp)
80106f6d:	e8 ef ab ff ff       	call   80101b61 <iunlockput>

  end_op();
80106f72:	e8 38 c8 ff ff       	call   801037af <end_op>

  return 0;
80106f77:	b8 00 00 00 00       	mov    $0x0,%eax
80106f7c:	eb 15                	jmp    80106f93 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80106f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f81:	89 04 24             	mov    %eax,(%esp)
80106f84:	e8 d8 ab ff ff       	call   80101b61 <iunlockput>
  end_op();
80106f89:	e8 21 c8 ff ff       	call   801037af <end_op>
  return -1;
80106f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f93:	c9                   	leave  
80106f94:	c3                   	ret    

80106f95 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106f95:	55                   	push   %ebp
80106f96:	89 e5                	mov    %esp,%ebp
80106f98:	83 ec 48             	sub    $0x48,%esp
80106f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f9e:	8b 55 10             	mov    0x10(%ebp),%edx
80106fa1:	8b 45 14             	mov    0x14(%ebp),%eax
80106fa4:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106fa8:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106fac:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106fb0:	8d 45 de             	lea    -0x22(%ebp),%eax
80106fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106fba:	89 04 24             	mov    %eax,(%esp)
80106fbd:	e8 ec b6 ff ff       	call   801026ae <nameiparent>
80106fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fc9:	75 0a                	jne    80106fd5 <create+0x40>
    return 0;
80106fcb:	b8 00 00 00 00       	mov    $0x0,%eax
80106fd0:	e9 7e 01 00 00       	jmp    80107153 <create+0x1be>
  ilock(dp);
80106fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fd8:	89 04 24             	mov    %eax,(%esp)
80106fdb:	e8 92 a9 ff ff       	call   80101972 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106fe0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
80106fe7:	8d 45 de             	lea    -0x22(%ebp),%eax
80106fea:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff1:	89 04 24             	mov    %eax,(%esp)
80106ff4:	e8 0a b3 ff ff       	call   80102303 <dirlookup>
80106ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ffc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107000:	74 47                	je     80107049 <create+0xb4>
    iunlockput(dp);
80107002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107005:	89 04 24             	mov    %eax,(%esp)
80107008:	e8 54 ab ff ff       	call   80101b61 <iunlockput>
    ilock(ip);
8010700d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107010:	89 04 24             	mov    %eax,(%esp)
80107013:	e8 5a a9 ff ff       	call   80101972 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80107018:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010701d:	75 15                	jne    80107034 <create+0x9f>
8010701f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107022:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107026:	66 83 f8 02          	cmp    $0x2,%ax
8010702a:	75 08                	jne    80107034 <create+0x9f>
      return ip;
8010702c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010702f:	e9 1f 01 00 00       	jmp    80107153 <create+0x1be>
    iunlockput(ip);
80107034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107037:	89 04 24             	mov    %eax,(%esp)
8010703a:	e8 22 ab ff ff       	call   80101b61 <iunlockput>
    return 0;
8010703f:	b8 00 00 00 00       	mov    $0x0,%eax
80107044:	e9 0a 01 00 00       	jmp    80107153 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107049:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010704d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107050:	8b 00                	mov    (%eax),%eax
80107052:	89 54 24 04          	mov    %edx,0x4(%esp)
80107056:	89 04 24             	mov    %eax,(%esp)
80107059:	e8 7a a6 ff ff       	call   801016d8 <ialloc>
8010705e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107061:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107065:	75 0c                	jne    80107073 <create+0xde>
    panic("create: ialloc");
80107067:	c7 04 24 ab 9f 10 80 	movl   $0x80109fab,(%esp)
8010706e:	e8 ef 94 ff ff       	call   80100562 <panic>

  ilock(ip);
80107073:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107076:	89 04 24             	mov    %eax,(%esp)
80107079:	e8 f4 a8 ff ff       	call   80101972 <ilock>
  ip->major = major;
8010707e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107081:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107085:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80107089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010708c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107090:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80107094:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107097:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
8010709d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070a0:	89 04 24             	mov    %eax,(%esp)
801070a3:	e8 05 a7 ff ff       	call   801017ad <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801070a8:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801070ad:	75 6a                	jne    80107119 <create+0x184>
    dp->nlink++;  // for ".."
801070af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070b2:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801070b6:	8d 50 01             	lea    0x1(%eax),%edx
801070b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070bc:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801070c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c3:	89 04 24             	mov    %eax,(%esp)
801070c6:	e8 e2 a6 ff ff       	call   801017ad <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801070cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ce:	8b 40 04             	mov    0x4(%eax),%eax
801070d1:	89 44 24 08          	mov    %eax,0x8(%esp)
801070d5:	c7 44 24 04 85 9f 10 	movl   $0x80109f85,0x4(%esp)
801070dc:	80 
801070dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070e0:	89 04 24             	mov    %eax,(%esp)
801070e3:	e8 e4 b2 ff ff       	call   801023cc <dirlink>
801070e8:	85 c0                	test   %eax,%eax
801070ea:	78 21                	js     8010710d <create+0x178>
801070ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ef:	8b 40 04             	mov    0x4(%eax),%eax
801070f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801070f6:	c7 44 24 04 87 9f 10 	movl   $0x80109f87,0x4(%esp)
801070fd:	80 
801070fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107101:	89 04 24             	mov    %eax,(%esp)
80107104:	e8 c3 b2 ff ff       	call   801023cc <dirlink>
80107109:	85 c0                	test   %eax,%eax
8010710b:	79 0c                	jns    80107119 <create+0x184>
      panic("create dots");
8010710d:	c7 04 24 ba 9f 10 80 	movl   $0x80109fba,(%esp)
80107114:	e8 49 94 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010711c:	8b 40 04             	mov    0x4(%eax),%eax
8010711f:	89 44 24 08          	mov    %eax,0x8(%esp)
80107123:	8d 45 de             	lea    -0x22(%ebp),%eax
80107126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010712a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712d:	89 04 24             	mov    %eax,(%esp)
80107130:	e8 97 b2 ff ff       	call   801023cc <dirlink>
80107135:	85 c0                	test   %eax,%eax
80107137:	79 0c                	jns    80107145 <create+0x1b0>
    panic("create: dirlink");
80107139:	c7 04 24 c6 9f 10 80 	movl   $0x80109fc6,(%esp)
80107140:	e8 1d 94 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80107145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107148:	89 04 24             	mov    %eax,(%esp)
8010714b:	e8 11 aa ff ff       	call   80101b61 <iunlockput>

  return ip;
80107150:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107153:	c9                   	leave  
80107154:	c3                   	ret    

80107155 <sys_open>:

int
sys_open(void)
{
80107155:	55                   	push   %ebp
80107156:	89 e5                	mov    %esp,%ebp
80107158:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010715b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010715e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107169:	e8 d9 f6 ff ff       	call   80106847 <argstr>
8010716e:	85 c0                	test   %eax,%eax
80107170:	78 17                	js     80107189 <sys_open+0x34>
80107172:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107175:	89 44 24 04          	mov    %eax,0x4(%esp)
80107179:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80107180:	e8 2c f6 ff ff       	call   801067b1 <argint>
80107185:	85 c0                	test   %eax,%eax
80107187:	79 0a                	jns    80107193 <sys_open+0x3e>
    return -1;
80107189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010718e:	e9 5c 01 00 00       	jmp    801072ef <sys_open+0x19a>

  begin_op();
80107193:	e8 93 c5 ff ff       	call   8010372b <begin_op>

  if(omode & O_CREATE){
80107198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010719b:	25 00 02 00 00       	and    $0x200,%eax
801071a0:	85 c0                	test   %eax,%eax
801071a2:	74 3b                	je     801071df <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
801071a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801071a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801071ae:	00 
801071af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801071b6:	00 
801071b7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801071be:	00 
801071bf:	89 04 24             	mov    %eax,(%esp)
801071c2:	e8 ce fd ff ff       	call   80106f95 <create>
801071c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801071ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071ce:	75 6b                	jne    8010723b <sys_open+0xe6>
      end_op();
801071d0:	e8 da c5 ff ff       	call   801037af <end_op>
      return -1;
801071d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071da:	e9 10 01 00 00       	jmp    801072ef <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801071df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801071e2:	89 04 24             	mov    %eax,(%esp)
801071e5:	e8 a2 b4 ff ff       	call   8010268c <namei>
801071ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071f1:	75 0f                	jne    80107202 <sys_open+0xad>
      end_op();
801071f3:	e8 b7 c5 ff ff       	call   801037af <end_op>
      return -1;
801071f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071fd:	e9 ed 00 00 00       	jmp    801072ef <sys_open+0x19a>
    }
    ilock(ip);
80107202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107205:	89 04 24             	mov    %eax,(%esp)
80107208:	e8 65 a7 ff ff       	call   80101972 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010720d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107210:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107214:	66 83 f8 01          	cmp    $0x1,%ax
80107218:	75 21                	jne    8010723b <sys_open+0xe6>
8010721a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010721d:	85 c0                	test   %eax,%eax
8010721f:	74 1a                	je     8010723b <sys_open+0xe6>
      iunlockput(ip);
80107221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107224:	89 04 24             	mov    %eax,(%esp)
80107227:	e8 35 a9 ff ff       	call   80101b61 <iunlockput>
      end_op();
8010722c:	e8 7e c5 ff ff       	call   801037af <end_op>
      return -1;
80107231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107236:	e9 b4 00 00 00       	jmp    801072ef <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010723b:	e8 5a 9d ff ff       	call   80100f9a <filealloc>
80107240:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107247:	74 14                	je     8010725d <sys_open+0x108>
80107249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010724c:	89 04 24             	mov    %eax,(%esp)
8010724f:	e8 2e f7 ff ff       	call   80106982 <fdalloc>
80107254:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107257:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010725b:	79 28                	jns    80107285 <sys_open+0x130>
    if(f)
8010725d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107261:	74 0b                	je     8010726e <sys_open+0x119>
      fileclose(f);
80107263:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107266:	89 04 24             	mov    %eax,(%esp)
80107269:	e8 d4 9d ff ff       	call   80101042 <fileclose>
    iunlockput(ip);
8010726e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107271:	89 04 24             	mov    %eax,(%esp)
80107274:	e8 e8 a8 ff ff       	call   80101b61 <iunlockput>
    end_op();
80107279:	e8 31 c5 ff ff       	call   801037af <end_op>
    return -1;
8010727e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107283:	eb 6a                	jmp    801072ef <sys_open+0x19a>
  }
  iunlock(ip);
80107285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107288:	89 04 24             	mov    %eax,(%esp)
8010728b:	e8 f9 a7 ff ff       	call   80101a89 <iunlock>
  end_op();
80107290:	e8 1a c5 ff ff       	call   801037af <end_op>

  f->type = FD_INODE;
80107295:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107298:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010729e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072a4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801072a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072aa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801072b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072b4:	83 e0 01             	and    $0x1,%eax
801072b7:	85 c0                	test   %eax,%eax
801072b9:	0f 94 c0             	sete   %al
801072bc:	89 c2                	mov    %eax,%edx
801072be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072c1:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801072c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072c7:	83 e0 01             	and    $0x1,%eax
801072ca:	85 c0                	test   %eax,%eax
801072cc:	75 0a                	jne    801072d8 <sys_open+0x183>
801072ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d1:	83 e0 02             	and    $0x2,%eax
801072d4:	85 c0                	test   %eax,%eax
801072d6:	74 07                	je     801072df <sys_open+0x18a>
801072d8:	b8 01 00 00 00       	mov    $0x1,%eax
801072dd:	eb 05                	jmp    801072e4 <sys_open+0x18f>
801072df:	b8 00 00 00 00       	mov    $0x0,%eax
801072e4:	89 c2                	mov    %eax,%edx
801072e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072e9:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801072ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801072ef:	c9                   	leave  
801072f0:	c3                   	ret    

801072f1 <sys_mkdir>:

int
sys_mkdir(void)
{
801072f1:	55                   	push   %ebp
801072f2:	89 e5                	mov    %esp,%ebp
801072f4:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801072f7:	e8 2f c4 ff ff       	call   8010372b <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801072fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80107303:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010730a:	e8 38 f5 ff ff       	call   80106847 <argstr>
8010730f:	85 c0                	test   %eax,%eax
80107311:	78 2c                	js     8010733f <sys_mkdir+0x4e>
80107313:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107316:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010731d:	00 
8010731e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107325:	00 
80107326:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010732d:	00 
8010732e:	89 04 24             	mov    %eax,(%esp)
80107331:	e8 5f fc ff ff       	call   80106f95 <create>
80107336:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010733d:	75 0c                	jne    8010734b <sys_mkdir+0x5a>
    end_op();
8010733f:	e8 6b c4 ff ff       	call   801037af <end_op>
    return -1;
80107344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107349:	eb 15                	jmp    80107360 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010734b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734e:	89 04 24             	mov    %eax,(%esp)
80107351:	e8 0b a8 ff ff       	call   80101b61 <iunlockput>
  end_op();
80107356:	e8 54 c4 ff ff       	call   801037af <end_op>
  return 0;
8010735b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107360:	c9                   	leave  
80107361:	c3                   	ret    

80107362 <sys_mknod>:

int
sys_mknod(void)
{
80107362:	55                   	push   %ebp
80107363:	89 e5                	mov    %esp,%ebp
80107365:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80107368:	e8 be c3 ff ff       	call   8010372b <begin_op>
  if((argstr(0, &path)) < 0 ||
8010736d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107370:	89 44 24 04          	mov    %eax,0x4(%esp)
80107374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010737b:	e8 c7 f4 ff ff       	call   80106847 <argstr>
80107380:	85 c0                	test   %eax,%eax
80107382:	78 5e                	js     801073e2 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80107384:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107387:	89 44 24 04          	mov    %eax,0x4(%esp)
8010738b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80107392:	e8 1a f4 ff ff       	call   801067b1 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80107397:	85 c0                	test   %eax,%eax
80107399:	78 47                	js     801073e2 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010739b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010739e:	89 44 24 04          	mov    %eax,0x4(%esp)
801073a2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801073a9:	e8 03 f4 ff ff       	call   801067b1 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801073ae:	85 c0                	test   %eax,%eax
801073b0:	78 30                	js     801073e2 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801073b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801073b5:	0f bf c8             	movswl %ax,%ecx
801073b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801073bb:	0f bf d0             	movswl %ax,%edx
801073be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801073c1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801073c5:	89 54 24 08          	mov    %edx,0x8(%esp)
801073c9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801073d0:	00 
801073d1:	89 04 24             	mov    %eax,(%esp)
801073d4:	e8 bc fb ff ff       	call   80106f95 <create>
801073d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073e0:	75 0c                	jne    801073ee <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801073e2:	e8 c8 c3 ff ff       	call   801037af <end_op>
    return -1;
801073e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ec:	eb 15                	jmp    80107403 <sys_mknod+0xa1>
  }
  iunlockput(ip);
801073ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f1:	89 04 24             	mov    %eax,(%esp)
801073f4:	e8 68 a7 ff ff       	call   80101b61 <iunlockput>
  end_op();
801073f9:	e8 b1 c3 ff ff       	call   801037af <end_op>
  return 0;
801073fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107403:	c9                   	leave  
80107404:	c3                   	ret    

80107405 <sys_chdir>:

int
sys_chdir(void)
{
80107405:	55                   	push   %ebp
80107406:	89 e5                	mov    %esp,%ebp
80107408:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010740b:	e8 1b c3 ff ff       	call   8010372b <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107410:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107413:	89 44 24 04          	mov    %eax,0x4(%esp)
80107417:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010741e:	e8 24 f4 ff ff       	call   80106847 <argstr>
80107423:	85 c0                	test   %eax,%eax
80107425:	78 14                	js     8010743b <sys_chdir+0x36>
80107427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010742a:	89 04 24             	mov    %eax,(%esp)
8010742d:	e8 5a b2 ff ff       	call   8010268c <namei>
80107432:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107435:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107439:	75 0c                	jne    80107447 <sys_chdir+0x42>
    end_op();
8010743b:	e8 6f c3 ff ff       	call   801037af <end_op>
    return -1;
80107440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107445:	eb 61                	jmp    801074a8 <sys_chdir+0xa3>
  }
  ilock(ip);
80107447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744a:	89 04 24             	mov    %eax,(%esp)
8010744d:	e8 20 a5 ff ff       	call   80101972 <ilock>
  if(ip->type != T_DIR){
80107452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107455:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107459:	66 83 f8 01          	cmp    $0x1,%ax
8010745d:	74 17                	je     80107476 <sys_chdir+0x71>
    iunlockput(ip);
8010745f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107462:	89 04 24             	mov    %eax,(%esp)
80107465:	e8 f7 a6 ff ff       	call   80101b61 <iunlockput>
    end_op();
8010746a:	e8 40 c3 ff ff       	call   801037af <end_op>
    return -1;
8010746f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107474:	eb 32                	jmp    801074a8 <sys_chdir+0xa3>
  }
  iunlock(ip);
80107476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107479:	89 04 24             	mov    %eax,(%esp)
8010747c:	e8 08 a6 ff ff       	call   80101a89 <iunlock>
  iput(proc->cwd);
80107481:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107487:	8b 40 68             	mov    0x68(%eax),%eax
8010748a:	89 04 24             	mov    %eax,(%esp)
8010748d:	e8 3b a6 ff ff       	call   80101acd <iput>
  end_op();
80107492:	e8 18 c3 ff ff       	call   801037af <end_op>
  proc->cwd = ip;
80107497:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010749d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801074a0:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801074a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074a8:	c9                   	leave  
801074a9:	c3                   	ret    

801074aa <sys_exec>:

int
sys_exec(void)
{
801074aa:	55                   	push   %ebp
801074ab:	89 e5                	mov    %esp,%ebp
801074ad:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801074b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801074ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801074c1:	e8 81 f3 ff ff       	call   80106847 <argstr>
801074c6:	85 c0                	test   %eax,%eax
801074c8:	78 1a                	js     801074e4 <sys_exec+0x3a>
801074ca:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801074d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801074d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801074db:	e8 d1 f2 ff ff       	call   801067b1 <argint>
801074e0:	85 c0                	test   %eax,%eax
801074e2:	79 0a                	jns    801074ee <sys_exec+0x44>
    return -1;
801074e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074e9:	e9 c8 00 00 00       	jmp    801075b6 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801074ee:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801074f5:	00 
801074f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801074fd:	00 
801074fe:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107504:	89 04 24             	mov    %eax,(%esp)
80107507:	e8 63 ef ff ff       	call   8010646f <memset>
  for(i=0;; i++){
8010750c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107516:	83 f8 1f             	cmp    $0x1f,%eax
80107519:	76 0a                	jbe    80107525 <sys_exec+0x7b>
      return -1;
8010751b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107520:	e9 91 00 00 00       	jmp    801075b6 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107528:	c1 e0 02             	shl    $0x2,%eax
8010752b:	89 c2                	mov    %eax,%edx
8010752d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107533:	01 c2                	add    %eax,%edx
80107535:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010753b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010753f:	89 14 24             	mov    %edx,(%esp)
80107542:	e8 ce f1 ff ff       	call   80106715 <fetchint>
80107547:	85 c0                	test   %eax,%eax
80107549:	79 07                	jns    80107552 <sys_exec+0xa8>
      return -1;
8010754b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107550:	eb 64                	jmp    801075b6 <sys_exec+0x10c>
    if(uarg == 0){
80107552:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107558:	85 c0                	test   %eax,%eax
8010755a:	75 26                	jne    80107582 <sys_exec+0xd8>
      argv[i] = 0;
8010755c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755f:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107566:	00 00 00 00 
      break;
8010756a:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010756b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010756e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107574:	89 54 24 04          	mov    %edx,0x4(%esp)
80107578:	89 04 24             	mov    %eax,(%esp)
8010757b:	e8 b2 95 ff ff       	call   80100b32 <exec>
80107580:	eb 34                	jmp    801075b6 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107582:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107588:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010758b:	c1 e2 02             	shl    $0x2,%edx
8010758e:	01 c2                	add    %eax,%edx
80107590:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107596:	89 54 24 04          	mov    %edx,0x4(%esp)
8010759a:	89 04 24             	mov    %eax,(%esp)
8010759d:	e8 ad f1 ff ff       	call   8010674f <fetchstr>
801075a2:	85 c0                	test   %eax,%eax
801075a4:	79 07                	jns    801075ad <sys_exec+0x103>
      return -1;
801075a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075ab:	eb 09                	jmp    801075b6 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801075ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801075b1:	e9 5d ff ff ff       	jmp    80107513 <sys_exec+0x69>
  return exec(path, argv);
}
801075b6:	c9                   	leave  
801075b7:	c3                   	ret    

801075b8 <sys_pipe>:

int
sys_pipe(void)
{
801075b8:	55                   	push   %ebp
801075b9:	89 e5                	mov    %esp,%ebp
801075bb:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801075be:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801075c5:	00 
801075c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801075c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801075cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801075d4:	e8 06 f2 ff ff       	call   801067df <argptr>
801075d9:	85 c0                	test   %eax,%eax
801075db:	79 0a                	jns    801075e7 <sys_pipe+0x2f>
    return -1;
801075dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075e2:	e9 9b 00 00 00       	jmp    80107682 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801075e7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801075ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801075ee:	8d 45 e8             	lea    -0x18(%ebp),%eax
801075f1:	89 04 24             	mov    %eax,(%esp)
801075f4:	e8 51 cb ff ff       	call   8010414a <pipealloc>
801075f9:	85 c0                	test   %eax,%eax
801075fb:	79 07                	jns    80107604 <sys_pipe+0x4c>
    return -1;
801075fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107602:	eb 7e                	jmp    80107682 <sys_pipe+0xca>
  fd0 = -1;
80107604:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010760b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010760e:	89 04 24             	mov    %eax,(%esp)
80107611:	e8 6c f3 ff ff       	call   80106982 <fdalloc>
80107616:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010761d:	78 14                	js     80107633 <sys_pipe+0x7b>
8010761f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107622:	89 04 24             	mov    %eax,(%esp)
80107625:	e8 58 f3 ff ff       	call   80106982 <fdalloc>
8010762a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010762d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107631:	79 37                	jns    8010766a <sys_pipe+0xb2>
    if(fd0 >= 0)
80107633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107637:	78 14                	js     8010764d <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80107639:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010763f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107642:	83 c2 08             	add    $0x8,%edx
80107645:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010764c:	00 
    fileclose(rf);
8010764d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107650:	89 04 24             	mov    %eax,(%esp)
80107653:	e8 ea 99 ff ff       	call   80101042 <fileclose>
    fileclose(wf);
80107658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010765b:	89 04 24             	mov    %eax,(%esp)
8010765e:	e8 df 99 ff ff       	call   80101042 <fileclose>
    return -1;
80107663:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107668:	eb 18                	jmp    80107682 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010766a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010766d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107670:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107672:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107675:	8d 50 04             	lea    0x4(%eax),%edx
80107678:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010767b:	89 02                	mov    %eax,(%edx)
  return 0;
8010767d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107682:	c9                   	leave  
80107683:	c3                   	ret    

80107684 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010768a:	e8 ab d3 ff ff       	call   80104a3a <fork>
}
8010768f:	c9                   	leave  
80107690:	c3                   	ret    

80107691 <sys_exit>:

int
sys_exit(void)
{
80107691:	55                   	push   %ebp
80107692:	89 e5                	mov    %esp,%ebp
80107694:	83 ec 08             	sub    $0x8,%esp
  exit();
80107697:	e8 c4 d6 ff ff       	call   80104d60 <exit>
  return 0;  // not reached
8010769c:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076a1:	c9                   	leave  
801076a2:	c3                   	ret    

801076a3 <sys_wait>:

int
sys_wait(void)
{
801076a3:	55                   	push   %ebp
801076a4:	89 e5                	mov    %esp,%ebp
801076a6:	83 ec 08             	sub    $0x8,%esp
  return wait();
801076a9:	e8 d0 d8 ff ff       	call   80104f7e <wait>
}
801076ae:	c9                   	leave  
801076af:	c3                   	ret    

801076b0 <sys_kill>:

int
sys_kill(void)
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801076b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801076b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801076bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801076c4:	e8 e8 f0 ff ff       	call   801067b1 <argint>
801076c9:	85 c0                	test   %eax,%eax
801076cb:	79 07                	jns    801076d4 <sys_kill+0x24>
    return -1;
801076cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076d2:	eb 0b                	jmp    801076df <sys_kill+0x2f>
  return kill(pid);
801076d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d7:	89 04 24             	mov    %eax,(%esp)
801076da:	e8 5c e2 ff ff       	call   8010593b <kill>
}
801076df:	c9                   	leave  
801076e0:	c3                   	ret    

801076e1 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
801076e1:	55                   	push   %ebp
801076e2:	89 e5                	mov    %esp,%ebp
801076e4:	83 ec 28             	sub    $0x28,%esp
    int tickets;
    if(argint(0, &tickets) <0)
801076e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801076ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801076ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801076f5:	e8 b7 f0 ff ff       	call   801067b1 <argint>
801076fa:	85 c0                	test   %eax,%eax
801076fc:	79 07                	jns    80107705 <sys_set_cpu_share+0x24>
        return -1;
801076fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107703:	eb 0b                	jmp    80107710 <sys_set_cpu_share+0x2f>
    return set_cpu_share(tickets);
80107705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107708:	89 04 24             	mov    %eax,(%esp)
8010770b:	e8 df e3 ff ff       	call   80105aef <set_cpu_share>
}
80107710:	c9                   	leave  
80107711:	c3                   	ret    

80107712 <sys_thread_create>:

int
sys_thread_create(void)
{
80107712:	55                   	push   %ebp
80107713:	89 e5                	mov    %esp,%ebp
80107715:	83 ec 28             	sub    $0x28,%esp
    int temp;
    thread_t * thread;
    void * (*start_routine)(void *);
    void *arg;

    if(argint(0, &temp)<0)
80107718:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010771b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010771f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107726:	e8 86 f0 ff ff       	call   801067b1 <argint>
8010772b:	85 c0                	test   %eax,%eax
8010772d:	79 07                	jns    80107736 <sys_thread_create+0x24>
        return -1;
8010772f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107734:	eb 67                	jmp    8010779d <sys_thread_create+0x8b>
    thread = (thread_t*)temp;
80107736:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107739:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(argint(1, &temp)<0)
8010773c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010773f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107743:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010774a:	e8 62 f0 ff ff       	call   801067b1 <argint>
8010774f:	85 c0                	test   %eax,%eax
80107751:	79 07                	jns    8010775a <sys_thread_create+0x48>
        return -1;
80107753:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107758:	eb 43                	jmp    8010779d <sys_thread_create+0x8b>

    start_routine = (void*)temp;
8010775a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010775d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(argint(2, &temp)<0)
80107760:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107763:	89 44 24 04          	mov    %eax,0x4(%esp)
80107767:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010776e:	e8 3e f0 ff ff       	call   801067b1 <argint>
80107773:	85 c0                	test   %eax,%eax
80107775:	79 07                	jns    8010777e <sys_thread_create+0x6c>
        return -1;
80107777:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010777c:	eb 1f                	jmp    8010779d <sys_thread_create+0x8b>

    arg = (void*)temp;
8010777e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107781:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return thread_create(thread, start_routine, arg);
80107784:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107787:	89 44 24 08          	mov    %eax,0x8(%esp)
8010778b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010778e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107795:	89 04 24             	mov    %eax,(%esp)
80107798:	e8 da e3 ff ff       	call   80105b77 <thread_create>
}
8010779d:	c9                   	leave  
8010779e:	c3                   	ret    

8010779f <sys_thread_exit>:
int
sys_thread_exit(void)
{   
8010779f:	55                   	push   %ebp
801077a0:	89 e5                	mov    %esp,%ebp
801077a2:	83 ec 28             	sub    $0x28,%esp
    int temp;
    void *retval;
    if(argint(0, &temp)<0)
801077a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801077a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801077ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801077b3:	e8 f9 ef ff ff       	call   801067b1 <argint>
801077b8:	85 c0                	test   %eax,%eax
801077ba:	79 07                	jns    801077c3 <sys_thread_exit+0x24>
        return -1;
801077bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077c1:	eb 11                	jmp    801077d4 <sys_thread_exit+0x35>
    retval = (void*)temp;
801077c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    thread_exit(retval);
801077c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cc:	89 04 24             	mov    %eax,(%esp)
801077cf:	e8 a0 e7 ff ff       	call   80105f74 <thread_exit>
    return 0;
}
801077d4:	c9                   	leave  
801077d5:	c3                   	ret    

801077d6 <sys_thread_join>:

int
sys_thread_join(void)
{
801077d6:	55                   	push   %ebp
801077d7:	89 e5                	mov    %esp,%ebp
801077d9:	83 ec 28             	sub    $0x28,%esp
    int temp;
    thread_t thread;
    void **retval;
    if(argint(0, &temp) < 0)
801077dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
801077df:	89 44 24 04          	mov    %eax,0x4(%esp)
801077e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801077ea:	e8 c2 ef ff ff       	call   801067b1 <argint>
801077ef:	85 c0                	test   %eax,%eax
801077f1:	79 07                	jns    801077fa <sys_thread_join+0x24>
        return -1;
801077f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f8:	eb 3c                	jmp    80107836 <sys_thread_join+0x60>
    thread = (thread_t)temp;
801077fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077fd:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if(argint(1, &temp)<0)
80107800:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107803:	89 44 24 04          	mov    %eax,0x4(%esp)
80107807:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010780e:	e8 9e ef ff ff       	call   801067b1 <argint>
80107813:	85 c0                	test   %eax,%eax
80107815:	79 07                	jns    8010781e <sys_thread_join+0x48>
        return -1;
80107817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010781c:	eb 18                	jmp    80107836 <sys_thread_join+0x60>
    retval = (void**)temp;
8010781e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107821:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return thread_join(thread,retval);
80107824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107827:	89 44 24 04          	mov    %eax,0x4(%esp)
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	89 04 24             	mov    %eax,(%esp)
80107831:	e8 d4 e5 ff ff       	call   80105e0a <thread_join>
    
}
80107836:	c9                   	leave  
80107837:	c3                   	ret    

80107838 <sys_yield>:

int
sys_yield(void)
{
80107838:	55                   	push   %ebp
80107839:	89 e5                	mov    %esp,%ebp
8010783b:	83 ec 08             	sub    $0x8,%esp
    yield();
8010783e:	e8 52 df ff ff       	call   80105795 <yield>
    return 0;
80107843:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107848:	c9                   	leave  
80107849:	c3                   	ret    

8010784a <sys_getpid>:

int
sys_getpid(void)
{
8010784a:	55                   	push   %ebp
8010784b:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010784d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107853:	8b 40 10             	mov    0x10(%eax),%eax

}
80107856:	5d                   	pop    %ebp
80107857:	c3                   	ret    

80107858 <sys_getppid>:

int
sys_getppid(void)
{
80107858:	55                   	push   %ebp
80107859:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
8010785b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107861:	8b 40 14             	mov    0x14(%eax),%eax
80107864:	8b 40 10             	mov    0x10(%eax),%eax
}
80107867:	5d                   	pop    %ebp
80107868:	c3                   	ret    

80107869 <sys_getlev>:

int
sys_getlev(void)
{
80107869:	55                   	push   %ebp
8010786a:	89 e5                	mov    %esp,%ebp
8010786c:	83 ec 18             	sub    $0x18,%esp
    int res = checkLevel();
8010786f:	e8 6a e2 ff ff       	call   80105ade <checkLevel>
80107874:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return res;
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010787a:	c9                   	leave  
8010787b:	c3                   	ret    

8010787c <sys_sbrk>:

int
sys_sbrk(void)
{
8010787c:	55                   	push   %ebp
8010787d:	89 e5                	mov    %esp,%ebp
8010787f:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107882:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107885:	89 44 24 04          	mov    %eax,0x4(%esp)
80107889:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107890:	e8 1c ef ff ff       	call   801067b1 <argint>
80107895:	85 c0                	test   %eax,%eax
80107897:	79 07                	jns    801078a0 <sys_sbrk+0x24>
    return -1;
80107899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010789e:	eb 24                	jmp    801078c4 <sys_sbrk+0x48>
  addr = proc->sz;
801078a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801078a6:	8b 00                	mov    (%eax),%eax
801078a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801078ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ae:	89 04 24             	mov    %eax,(%esp)
801078b1:	e8 df d0 ff ff       	call   80104995 <growproc>
801078b6:	85 c0                	test   %eax,%eax
801078b8:	79 07                	jns    801078c1 <sys_sbrk+0x45>
    return -1;
801078ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078bf:	eb 03                	jmp    801078c4 <sys_sbrk+0x48>
  return addr;
801078c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801078c4:	c9                   	leave  
801078c5:	c3                   	ret    

801078c6 <sys_sleep>:

int
sys_sleep(void)
{
801078c6:	55                   	push   %ebp
801078c7:	89 e5                	mov    %esp,%ebp
801078c9:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801078cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801078cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801078d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801078da:	e8 d2 ee ff ff       	call   801067b1 <argint>
801078df:	85 c0                	test   %eax,%eax
801078e1:	79 07                	jns    801078ea <sys_sleep+0x24>
    return -1;
801078e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078e8:	eb 6c                	jmp    80107956 <sys_sleep+0x90>
  acquire(&tickslock);
801078ea:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
801078f1:	e8 10 e9 ff ff       	call   80106206 <acquire>
  ticks0 = ticks;
801078f6:	a1 20 d3 11 80       	mov    0x8011d320,%eax
801078fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801078fe:	eb 34                	jmp    80107934 <sys_sleep+0x6e>
    if(proc->killed){
80107900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107906:	8b 40 24             	mov    0x24(%eax),%eax
80107909:	85 c0                	test   %eax,%eax
8010790b:	74 13                	je     80107920 <sys_sleep+0x5a>
      release(&tickslock);
8010790d:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107914:	e8 54 e9 ff ff       	call   8010626d <release>
      return -1;
80107919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010791e:	eb 36                	jmp    80107956 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80107920:	c7 44 24 04 e0 ca 11 	movl   $0x8011cae0,0x4(%esp)
80107927:	80 
80107928:	c7 04 24 20 d3 11 80 	movl   $0x8011d320,(%esp)
8010792f:	e8 d2 de ff ff       	call   80105806 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107934:	a1 20 d3 11 80       	mov    0x8011d320,%eax
80107939:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010793c:	89 c2                	mov    %eax,%edx
8010793e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107941:	39 c2                	cmp    %eax,%edx
80107943:	72 bb                	jb     80107900 <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80107945:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
8010794c:	e8 1c e9 ff ff       	call   8010626d <release>
  return 0;
80107951:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107956:	c9                   	leave  
80107957:	c3                   	ret    

80107958 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107958:	55                   	push   %ebp
80107959:	89 e5                	mov    %esp,%ebp
8010795b:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
8010795e:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107965:	e8 9c e8 ff ff       	call   80106206 <acquire>
  xticks = ticks;
8010796a:	a1 20 d3 11 80       	mov    0x8011d320,%eax
8010796f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80107972:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107979:	e8 ef e8 ff ff       	call   8010626d <release>
  return xticks;
8010797e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107981:	c9                   	leave  
80107982:	c3                   	ret    

80107983 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107983:	55                   	push   %ebp
80107984:	89 e5                	mov    %esp,%ebp
80107986:	83 ec 08             	sub    $0x8,%esp
80107989:	8b 55 08             	mov    0x8(%ebp),%edx
8010798c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010798f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107993:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107996:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010799a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010799e:	ee                   	out    %al,(%dx)
}
8010799f:	c9                   	leave  
801079a0:	c3                   	ret    

801079a1 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801079a1:	55                   	push   %ebp
801079a2:	89 e5                	mov    %esp,%ebp
801079a4:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801079a7:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801079ae:	00 
801079af:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801079b6:	e8 c8 ff ff ff       	call   80107983 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801079bb:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801079c2:	00 
801079c3:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801079ca:	e8 b4 ff ff ff       	call   80107983 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801079cf:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801079d6:	00 
801079d7:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801079de:	e8 a0 ff ff ff       	call   80107983 <outb>
  picenable(IRQ_TIMER);
801079e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801079ea:	e8 ee c5 ff ff       	call   80103fdd <picenable>
}
801079ef:	c9                   	leave  
801079f0:	c3                   	ret    

801079f1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801079f1:	1e                   	push   %ds
  pushl %es
801079f2:	06                   	push   %es
  pushl %fs
801079f3:	0f a0                	push   %fs
  pushl %gs
801079f5:	0f a8                	push   %gs
  pushal
801079f7:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801079f8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801079fc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801079fe:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107a00:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107a04:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107a06:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107a08:	54                   	push   %esp
  call trap
80107a09:	e8 54 02 00 00       	call   80107c62 <trap>
  addl $4, %esp
80107a0e:	83 c4 04             	add    $0x4,%esp

80107a11 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107a11:	61                   	popa   
  popl %gs
80107a12:	0f a9                	pop    %gs
  popl %fs
80107a14:	0f a1                	pop    %fs
  popl %es
80107a16:	07                   	pop    %es
  popl %ds
80107a17:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107a18:	83 c4 08             	add    $0x8,%esp
  iret
80107a1b:	cf                   	iret   

80107a1c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107a1c:	55                   	push   %ebp
80107a1d:	89 e5                	mov    %esp,%ebp
80107a1f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a25:	83 e8 01             	sub    $0x1,%eax
80107a28:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a2f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107a33:	8b 45 08             	mov    0x8(%ebp),%eax
80107a36:	c1 e8 10             	shr    $0x10,%eax
80107a39:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107a3d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107a40:	0f 01 18             	lidtl  (%eax)
}
80107a43:	c9                   	leave  
80107a44:	c3                   	ret    

80107a45 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107a45:	55                   	push   %ebp
80107a46:	89 e5                	mov    %esp,%ebp
80107a48:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107a4b:	0f 20 d0             	mov    %cr2,%eax
80107a4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107a54:	c9                   	leave  
80107a55:	c3                   	ret    

80107a56 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107a56:	55                   	push   %ebp
80107a57:	89 e5                	mov    %esp,%ebp
80107a59:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80107a5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107a63:	e9 c3 00 00 00       	jmp    80107b2b <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6b:	8b 04 85 b8 d0 10 80 	mov    -0x7fef2f48(,%eax,4),%eax
80107a72:	89 c2                	mov    %eax,%edx
80107a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a77:	66 89 14 c5 20 cb 11 	mov    %dx,-0x7fee34e0(,%eax,8)
80107a7e:	80 
80107a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a82:	66 c7 04 c5 22 cb 11 	movw   $0x8,-0x7fee34de(,%eax,8)
80107a89:	80 08 00 
80107a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8f:	0f b6 14 c5 24 cb 11 	movzbl -0x7fee34dc(,%eax,8),%edx
80107a96:	80 
80107a97:	83 e2 e0             	and    $0xffffffe0,%edx
80107a9a:	88 14 c5 24 cb 11 80 	mov    %dl,-0x7fee34dc(,%eax,8)
80107aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa4:	0f b6 14 c5 24 cb 11 	movzbl -0x7fee34dc(,%eax,8),%edx
80107aab:	80 
80107aac:	83 e2 1f             	and    $0x1f,%edx
80107aaf:	88 14 c5 24 cb 11 80 	mov    %dl,-0x7fee34dc(,%eax,8)
80107ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab9:	0f b6 14 c5 25 cb 11 	movzbl -0x7fee34db(,%eax,8),%edx
80107ac0:	80 
80107ac1:	83 e2 f0             	and    $0xfffffff0,%edx
80107ac4:	83 ca 0e             	or     $0xe,%edx
80107ac7:	88 14 c5 25 cb 11 80 	mov    %dl,-0x7fee34db(,%eax,8)
80107ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad1:	0f b6 14 c5 25 cb 11 	movzbl -0x7fee34db(,%eax,8),%edx
80107ad8:	80 
80107ad9:	83 e2 ef             	and    $0xffffffef,%edx
80107adc:	88 14 c5 25 cb 11 80 	mov    %dl,-0x7fee34db(,%eax,8)
80107ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae6:	0f b6 14 c5 25 cb 11 	movzbl -0x7fee34db(,%eax,8),%edx
80107aed:	80 
80107aee:	83 e2 9f             	and    $0xffffff9f,%edx
80107af1:	88 14 c5 25 cb 11 80 	mov    %dl,-0x7fee34db(,%eax,8)
80107af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afb:	0f b6 14 c5 25 cb 11 	movzbl -0x7fee34db(,%eax,8),%edx
80107b02:	80 
80107b03:	83 ca 80             	or     $0xffffff80,%edx
80107b06:	88 14 c5 25 cb 11 80 	mov    %dl,-0x7fee34db(,%eax,8)
80107b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b10:	8b 04 85 b8 d0 10 80 	mov    -0x7fef2f48(,%eax,4),%eax
80107b17:	c1 e8 10             	shr    $0x10,%eax
80107b1a:	89 c2                	mov    %eax,%edx
80107b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1f:	66 89 14 c5 26 cb 11 	mov    %dx,-0x7fee34da(,%eax,8)
80107b26:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107b27:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107b2b:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80107b32:	0f 8e 30 ff ff ff    	jle    80107a68 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107b38:	a1 b8 d1 10 80       	mov    0x8010d1b8,%eax
80107b3d:	66 a3 20 cd 11 80    	mov    %ax,0x8011cd20
80107b43:	66 c7 05 22 cd 11 80 	movw   $0x8,0x8011cd22
80107b4a:	08 00 
80107b4c:	0f b6 05 24 cd 11 80 	movzbl 0x8011cd24,%eax
80107b53:	83 e0 e0             	and    $0xffffffe0,%eax
80107b56:	a2 24 cd 11 80       	mov    %al,0x8011cd24
80107b5b:	0f b6 05 24 cd 11 80 	movzbl 0x8011cd24,%eax
80107b62:	83 e0 1f             	and    $0x1f,%eax
80107b65:	a2 24 cd 11 80       	mov    %al,0x8011cd24
80107b6a:	0f b6 05 25 cd 11 80 	movzbl 0x8011cd25,%eax
80107b71:	83 c8 0f             	or     $0xf,%eax
80107b74:	a2 25 cd 11 80       	mov    %al,0x8011cd25
80107b79:	0f b6 05 25 cd 11 80 	movzbl 0x8011cd25,%eax
80107b80:	83 e0 ef             	and    $0xffffffef,%eax
80107b83:	a2 25 cd 11 80       	mov    %al,0x8011cd25
80107b88:	0f b6 05 25 cd 11 80 	movzbl 0x8011cd25,%eax
80107b8f:	83 c8 60             	or     $0x60,%eax
80107b92:	a2 25 cd 11 80       	mov    %al,0x8011cd25
80107b97:	0f b6 05 25 cd 11 80 	movzbl 0x8011cd25,%eax
80107b9e:	83 c8 80             	or     $0xffffff80,%eax
80107ba1:	a2 25 cd 11 80       	mov    %al,0x8011cd25
80107ba6:	a1 b8 d1 10 80       	mov    0x8010d1b8,%eax
80107bab:	c1 e8 10             	shr    $0x10,%eax
80107bae:	66 a3 26 cd 11 80    	mov    %ax,0x8011cd26
  SETGATE(idt[U_SYSCALL], 1, SEG_KCODE<<3, vectors[U_SYSCALL], DPL_USER);
80107bb4:	a1 b8 d2 10 80       	mov    0x8010d2b8,%eax
80107bb9:	66 a3 20 cf 11 80    	mov    %ax,0x8011cf20
80107bbf:	66 c7 05 22 cf 11 80 	movw   $0x8,0x8011cf22
80107bc6:	08 00 
80107bc8:	0f b6 05 24 cf 11 80 	movzbl 0x8011cf24,%eax
80107bcf:	83 e0 e0             	and    $0xffffffe0,%eax
80107bd2:	a2 24 cf 11 80       	mov    %al,0x8011cf24
80107bd7:	0f b6 05 24 cf 11 80 	movzbl 0x8011cf24,%eax
80107bde:	83 e0 1f             	and    $0x1f,%eax
80107be1:	a2 24 cf 11 80       	mov    %al,0x8011cf24
80107be6:	0f b6 05 25 cf 11 80 	movzbl 0x8011cf25,%eax
80107bed:	83 c8 0f             	or     $0xf,%eax
80107bf0:	a2 25 cf 11 80       	mov    %al,0x8011cf25
80107bf5:	0f b6 05 25 cf 11 80 	movzbl 0x8011cf25,%eax
80107bfc:	83 e0 ef             	and    $0xffffffef,%eax
80107bff:	a2 25 cf 11 80       	mov    %al,0x8011cf25
80107c04:	0f b6 05 25 cf 11 80 	movzbl 0x8011cf25,%eax
80107c0b:	83 c8 60             	or     $0x60,%eax
80107c0e:	a2 25 cf 11 80       	mov    %al,0x8011cf25
80107c13:	0f b6 05 25 cf 11 80 	movzbl 0x8011cf25,%eax
80107c1a:	83 c8 80             	or     $0xffffff80,%eax
80107c1d:	a2 25 cf 11 80       	mov    %al,0x8011cf25
80107c22:	a1 b8 d2 10 80       	mov    0x8010d2b8,%eax
80107c27:	c1 e8 10             	shr    $0x10,%eax
80107c2a:	66 a3 26 cf 11 80    	mov    %ax,0x8011cf26
  initlock(&tickslock, "time");
80107c30:	c7 44 24 04 d8 9f 10 	movl   $0x80109fd8,0x4(%esp)
80107c37:	80 
80107c38:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107c3f:	e8 a1 e5 ff ff       	call   801061e5 <initlock>
}
80107c44:	c9                   	leave  
80107c45:	c3                   	ret    

80107c46 <idtinit>:

void
idtinit(void)
{
80107c46:	55                   	push   %ebp
80107c47:	89 e5                	mov    %esp,%ebp
80107c49:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107c4c:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107c53:	00 
80107c54:	c7 04 24 20 cb 11 80 	movl   $0x8011cb20,(%esp)
80107c5b:	e8 bc fd ff ff       	call   80107a1c <lidt>
}
80107c60:	c9                   	leave  
80107c61:	c3                   	ret    

80107c62 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107c62:	55                   	push   %ebp
80107c63:	89 e5                	mov    %esp,%ebp
80107c65:	57                   	push   %edi
80107c66:	56                   	push   %esi
80107c67:	53                   	push   %ebx
80107c68:	83 ec 3c             	sub    $0x3c,%esp
  static int count = 0;
  if(tf->trapno == T_SYSCALL){
80107c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c6e:	8b 40 30             	mov    0x30(%eax),%eax
80107c71:	83 f8 40             	cmp    $0x40,%eax
80107c74:	75 3f                	jne    80107cb5 <trap+0x53>
    if(proc->killed)
80107c76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c7c:	8b 40 24             	mov    0x24(%eax),%eax
80107c7f:	85 c0                	test   %eax,%eax
80107c81:	74 05                	je     80107c88 <trap+0x26>
      exit();
80107c83:	e8 d8 d0 ff ff       	call   80104d60 <exit>
    proc->tf = tf;
80107c88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c8e:	8b 55 08             	mov    0x8(%ebp),%edx
80107c91:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107c94:	e8 e5 eb ff ff       	call   8010687e <syscall>
    if(proc->killed)
80107c99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c9f:	8b 40 24             	mov    0x24(%eax),%eax
80107ca2:	85 c0                	test   %eax,%eax
80107ca4:	74 0a                	je     80107cb0 <trap+0x4e>
      exit();
80107ca6:	e8 b5 d0 ff ff       	call   80104d60 <exit>
    return;
80107cab:	e9 d7 02 00 00       	jmp    80107f87 <trap+0x325>
80107cb0:	e9 d2 02 00 00       	jmp    80107f87 <trap+0x325>
  }

  if(tf ->trapno == U_SYSCALL){
80107cb5:	8b 45 08             	mov    0x8(%ebp),%eax
80107cb8:	8b 40 30             	mov    0x30(%eax),%eax
80107cbb:	3d 80 00 00 00       	cmp    $0x80,%eax
80107cc0:	75 35                	jne    80107cf7 <trap+0x95>
      if(proc->killed)
80107cc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cc8:	8b 40 24             	mov    0x24(%eax),%eax
80107ccb:	85 c0                	test   %eax,%eax
80107ccd:	74 05                	je     80107cd4 <trap+0x72>
          exit();
80107ccf:	e8 8c d0 ff ff       	call   80104d60 <exit>
      cprintf("user interrupt 128 called!\n");
80107cd4:	c7 04 24 dd 9f 10 80 	movl   $0x80109fdd,(%esp)
80107cdb:	e8 e8 86 ff ff       	call   801003c8 <cprintf>
      exit();
80107ce0:	e8 7b d0 ff ff       	call   80104d60 <exit>
      if(proc->killed)
80107ce5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ceb:	8b 40 24             	mov    0x24(%eax),%eax
80107cee:	85 c0                	test   %eax,%eax
80107cf0:	74 05                	je     80107cf7 <trap+0x95>
          exit();
80107cf2:	e8 69 d0 ff ff       	call   80104d60 <exit>
  }

  switch(tf->trapno){
80107cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80107cfa:	8b 40 30             	mov    0x30(%eax),%eax
80107cfd:	83 e8 20             	sub    $0x20,%eax
80107d00:	83 f8 1f             	cmp    $0x1f,%eax
80107d03:	0f 87 f8 00 00 00    	ja     80107e01 <trap+0x19f>
80107d09:	8b 04 85 9c a0 10 80 	mov    -0x7fef5f64(,%eax,4),%eax
80107d10:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80107d12:	e8 42 b4 ff ff       	call   80103159 <cpunum>
80107d17:	85 c0                	test   %eax,%eax
80107d19:	75 31                	jne    80107d4c <trap+0xea>
      acquire(&tickslock);
80107d1b:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107d22:	e8 df e4 ff ff       	call   80106206 <acquire>
      ticks++;
80107d27:	a1 20 d3 11 80       	mov    0x8011d320,%eax
80107d2c:	83 c0 01             	add    $0x1,%eax
80107d2f:	a3 20 d3 11 80       	mov    %eax,0x8011d320
      wakeup(&ticks);
80107d34:	c7 04 24 20 d3 11 80 	movl   $0x8011d320,(%esp)
80107d3b:	e8 d0 db ff ff       	call   80105910 <wakeup>
      release(&tickslock);
80107d40:	c7 04 24 e0 ca 11 80 	movl   $0x8011cae0,(%esp)
80107d47:	e8 21 e5 ff ff       	call   8010626d <release>
    }
    lapiceoi();
80107d4c:	e8 a4 b4 ff ff       	call   801031f5 <lapiceoi>
    count++;
80107d51:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80107d56:	83 c0 01             	add    $0x1,%eax
80107d59:	a3 74 d6 10 80       	mov    %eax,0x8010d674
    if(count % 100 == 0){//Only if count is 100, then execute priority boosting
80107d5e:	8b 0d 74 d6 10 80    	mov    0x8010d674,%ecx
80107d64:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80107d69:	89 c8                	mov    %ecx,%eax
80107d6b:	f7 ea                	imul   %edx
80107d6d:	c1 fa 05             	sar    $0x5,%edx
80107d70:	89 c8                	mov    %ecx,%eax
80107d72:	c1 f8 1f             	sar    $0x1f,%eax
80107d75:	29 c2                	sub    %eax,%edx
80107d77:	89 d0                	mov    %edx,%eax
80107d79:	6b c0 64             	imul   $0x64,%eax,%eax
80107d7c:	29 c1                	sub    %eax,%ecx
80107d7e:	89 c8                	mov    %ecx,%eax
80107d80:	85 c0                	test   %eax,%eax
80107d82:	75 14                	jne    80107d98 <trap+0x136>
        boostFlagOn();
80107d84:	e8 21 c9 ff ff       	call   801046aa <boostFlagOn>
        // cprintf("Boosting\n");
        count = 0;
80107d89:	c7 05 74 d6 10 80 00 	movl   $0x0,0x8010d674
80107d90:	00 00 00 
    }
    break;
80107d93:	e9 34 01 00 00       	jmp    80107ecc <trap+0x26a>
80107d98:	e9 2f 01 00 00       	jmp    80107ecc <trap+0x26a>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107d9d:	e8 27 ac ff ff       	call   801029c9 <ideintr>
    lapiceoi();
80107da2:	e8 4e b4 ff ff       	call   801031f5 <lapiceoi>
    break;
80107da7:	e9 20 01 00 00       	jmp    80107ecc <trap+0x26a>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107dac:	e8 cf b1 ff ff       	call   80102f80 <kbdintr>
    lapiceoi();
80107db1:	e8 3f b4 ff ff       	call   801031f5 <lapiceoi>
    break;
80107db6:	e9 11 01 00 00       	jmp    80107ecc <trap+0x26a>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107dbb:	e8 bc 03 00 00       	call   8010817c <uartintr>
    lapiceoi();
80107dc0:	e8 30 b4 ff ff       	call   801031f5 <lapiceoi>
    break;
80107dc5:	e9 02 01 00 00       	jmp    80107ecc <trap+0x26a>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107dca:	8b 45 08             	mov    0x8(%ebp),%eax
80107dcd:	8b 70 38             	mov    0x38(%eax),%esi
            cpunum(), tf->cs, tf->eip);
80107dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80107dd3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107dd7:	0f b7 d8             	movzwl %ax,%ebx
80107dda:	e8 7a b3 ff ff       	call   80103159 <cpunum>
80107ddf:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107de3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107de7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107deb:	c7 04 24 fc 9f 10 80 	movl   $0x80109ffc,(%esp)
80107df2:	e8 d1 85 ff ff       	call   801003c8 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80107df7:	e8 f9 b3 ff ff       	call   801031f5 <lapiceoi>
    break;
80107dfc:	e9 cb 00 00 00       	jmp    80107ecc <trap+0x26a>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107e01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e07:	85 c0                	test   %eax,%eax
80107e09:	74 11                	je     80107e1c <trap+0x1ba>
80107e0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e0e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e12:	0f b7 c0             	movzwl %ax,%eax
80107e15:	83 e0 03             	and    $0x3,%eax
80107e18:	85 c0                	test   %eax,%eax
80107e1a:	75 40                	jne    80107e5c <trap+0x1fa>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107e1c:	e8 24 fc ff ff       	call   80107a45 <rcr2>
80107e21:	89 c3                	mov    %eax,%ebx
80107e23:	8b 45 08             	mov    0x8(%ebp),%eax
80107e26:	8b 70 38             	mov    0x38(%eax),%esi
80107e29:	e8 2b b3 ff ff       	call   80103159 <cpunum>
80107e2e:	8b 55 08             	mov    0x8(%ebp),%edx
80107e31:	8b 52 30             	mov    0x30(%edx),%edx
80107e34:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107e38:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107e3c:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e40:	89 54 24 04          	mov    %edx,0x4(%esp)
80107e44:	c7 04 24 20 a0 10 80 	movl   $0x8010a020,(%esp)
80107e4b:	e8 78 85 ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80107e50:	c7 04 24 52 a0 10 80 	movl   $0x8010a052,(%esp)
80107e57:	e8 06 87 ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e5c:	e8 e4 fb ff ff       	call   80107a45 <rcr2>
80107e61:	89 c3                	mov    %eax,%ebx
80107e63:	8b 45 08             	mov    0x8(%ebp),%eax
80107e66:	8b 78 38             	mov    0x38(%eax),%edi
80107e69:	e8 eb b2 ff ff       	call   80103159 <cpunum>
80107e6e:	89 c2                	mov    %eax,%edx
80107e70:	8b 45 08             	mov    0x8(%ebp),%eax
80107e73:	8b 70 34             	mov    0x34(%eax),%esi
80107e76:	8b 45 08             	mov    0x8(%ebp),%eax
80107e79:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80107e7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e82:	83 c0 6c             	add    $0x6c,%eax
80107e85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107e8e:	8b 40 10             	mov    0x10(%eax),%eax
80107e91:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
80107e95:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107e99:	89 54 24 14          	mov    %edx,0x14(%esp)
80107e9d:	89 74 24 10          	mov    %esi,0x10(%esp)
80107ea1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107ea5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107ea8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80107eac:	89 44 24 04          	mov    %eax,0x4(%esp)
80107eb0:	c7 04 24 58 a0 10 80 	movl   $0x8010a058,(%esp)
80107eb7:	e8 0c 85 ff ff       	call   801003c8 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80107ebc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ec2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107ec9:	eb 01                	jmp    80107ecc <trap+0x26a>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107ecb:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ed2:	85 c0                	test   %eax,%eax
80107ed4:	74 24                	je     80107efa <trap+0x298>
80107ed6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107edc:	8b 40 24             	mov    0x24(%eax),%eax
80107edf:	85 c0                	test   %eax,%eax
80107ee1:	74 17                	je     80107efa <trap+0x298>
80107ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107eea:	0f b7 c0             	movzwl %ax,%eax
80107eed:	83 e0 03             	and    $0x3,%eax
80107ef0:	83 f8 03             	cmp    $0x3,%eax
80107ef3:	75 05                	jne    80107efa <trap+0x298>
    exit();
80107ef5:	e8 66 ce ff ff       	call   80104d60 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
80107efa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f00:	85 c0                	test   %eax,%eax
80107f02:	74 55                	je     80107f59 <trap+0x2f7>
80107f04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f0a:	8b 40 0c             	mov    0xc(%eax),%eax
80107f0d:	83 f8 04             	cmp    $0x4,%eax
80107f10:	75 47                	jne    80107f59 <trap+0x2f7>
80107f12:	8b 45 08             	mov    0x8(%ebp),%eax
80107f15:	8b 40 30             	mov    0x30(%eax),%eax
80107f18:	83 f8 20             	cmp    $0x20,%eax
80107f1b:	75 3c                	jne    80107f59 <trap+0x2f7>
    if(proc->isStride == 1) yield();
80107f1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f23:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80107f29:	83 f8 01             	cmp    $0x1,%eax
80107f2c:	75 07                	jne    80107f35 <trap+0x2d3>
80107f2e:	e8 62 d8 ff ff       	call   80105795 <yield>
80107f33:	eb 24                	jmp    80107f59 <trap+0x2f7>
    else {
      if(proc->cnt == 1) yield();
80107f35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f3b:	8b 40 7c             	mov    0x7c(%eax),%eax
80107f3e:	83 f8 01             	cmp    $0x1,%eax
80107f41:	75 07                	jne    80107f4a <trap+0x2e8>
80107f43:	e8 4d d8 ff ff       	call   80105795 <yield>
80107f48:	eb 0f                	jmp    80107f59 <trap+0x2f7>
      else proc->cnt--;
80107f4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f50:	8b 50 7c             	mov    0x7c(%eax),%edx
80107f53:	83 ea 01             	sub    $0x1,%edx
80107f56:	89 50 7c             	mov    %edx,0x7c(%eax)
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107f59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f5f:	85 c0                	test   %eax,%eax
80107f61:	74 24                	je     80107f87 <trap+0x325>
80107f63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f69:	8b 40 24             	mov    0x24(%eax),%eax
80107f6c:	85 c0                	test   %eax,%eax
80107f6e:	74 17                	je     80107f87 <trap+0x325>
80107f70:	8b 45 08             	mov    0x8(%ebp),%eax
80107f73:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107f77:	0f b7 c0             	movzwl %ax,%eax
80107f7a:	83 e0 03             	and    $0x3,%eax
80107f7d:	83 f8 03             	cmp    $0x3,%eax
80107f80:	75 05                	jne    80107f87 <trap+0x325>
    exit();
80107f82:	e8 d9 cd ff ff       	call   80104d60 <exit>
}
80107f87:	83 c4 3c             	add    $0x3c,%esp
80107f8a:	5b                   	pop    %ebx
80107f8b:	5e                   	pop    %esi
80107f8c:	5f                   	pop    %edi
80107f8d:	5d                   	pop    %ebp
80107f8e:	c3                   	ret    

80107f8f <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107f8f:	55                   	push   %ebp
80107f90:	89 e5                	mov    %esp,%ebp
80107f92:	83 ec 14             	sub    $0x14,%esp
80107f95:	8b 45 08             	mov    0x8(%ebp),%eax
80107f98:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107f9c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107fa0:	89 c2                	mov    %eax,%edx
80107fa2:	ec                   	in     (%dx),%al
80107fa3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107fa6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107faa:	c9                   	leave  
80107fab:	c3                   	ret    

80107fac <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107fac:	55                   	push   %ebp
80107fad:	89 e5                	mov    %esp,%ebp
80107faf:	83 ec 08             	sub    $0x8,%esp
80107fb2:	8b 55 08             	mov    0x8(%ebp),%edx
80107fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fb8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107fbc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107fbf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107fc3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107fc7:	ee                   	out    %al,(%dx)
}
80107fc8:	c9                   	leave  
80107fc9:	c3                   	ret    

80107fca <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107fca:	55                   	push   %ebp
80107fcb:	89 e5                	mov    %esp,%ebp
80107fcd:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107fd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fd7:	00 
80107fd8:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107fdf:	e8 c8 ff ff ff       	call   80107fac <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107fe4:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107feb:	00 
80107fec:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107ff3:	e8 b4 ff ff ff       	call   80107fac <outb>
  outb(COM1+0, 115200/9600);
80107ff8:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107fff:	00 
80108000:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80108007:	e8 a0 ff ff ff       	call   80107fac <outb>
  outb(COM1+1, 0);
8010800c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108013:	00 
80108014:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010801b:	e8 8c ff ff ff       	call   80107fac <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108020:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80108027:	00 
80108028:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010802f:	e8 78 ff ff ff       	call   80107fac <outb>
  outb(COM1+4, 0);
80108034:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010803b:	00 
8010803c:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80108043:	e8 64 ff ff ff       	call   80107fac <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108048:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010804f:	00 
80108050:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80108057:	e8 50 ff ff ff       	call   80107fac <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010805c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80108063:	e8 27 ff ff ff       	call   80107f8f <inb>
80108068:	3c ff                	cmp    $0xff,%al
8010806a:	75 02                	jne    8010806e <uartinit+0xa4>
    return;
8010806c:	eb 6a                	jmp    801080d8 <uartinit+0x10e>
  uart = 1;
8010806e:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
80108075:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108078:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010807f:	e8 0b ff ff ff       	call   80107f8f <inb>
  inb(COM1+0);
80108084:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010808b:	e8 ff fe ff ff       	call   80107f8f <inb>
  picenable(IRQ_COM1);
80108090:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80108097:	e8 41 bf ff ff       	call   80103fdd <picenable>
  ioapicenable(IRQ_COM1, 0);
8010809c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080a3:	00 
801080a4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801080ab:	e8 9e ab ff ff       	call   80102c4e <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801080b0:	c7 45 f4 1c a1 10 80 	movl   $0x8010a11c,-0xc(%ebp)
801080b7:	eb 15                	jmp    801080ce <uartinit+0x104>
    uartputc(*p);
801080b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080bc:	0f b6 00             	movzbl (%eax),%eax
801080bf:	0f be c0             	movsbl %al,%eax
801080c2:	89 04 24             	mov    %eax,(%esp)
801080c5:	e8 10 00 00 00       	call   801080da <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801080ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801080ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d1:	0f b6 00             	movzbl (%eax),%eax
801080d4:	84 c0                	test   %al,%al
801080d6:	75 e1                	jne    801080b9 <uartinit+0xef>
    uartputc(*p);
}
801080d8:	c9                   	leave  
801080d9:	c3                   	ret    

801080da <uartputc>:

void
uartputc(int c)
{
801080da:	55                   	push   %ebp
801080db:	89 e5                	mov    %esp,%ebp
801080dd:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801080e0:	a1 78 d6 10 80       	mov    0x8010d678,%eax
801080e5:	85 c0                	test   %eax,%eax
801080e7:	75 02                	jne    801080eb <uartputc+0x11>
    return;
801080e9:	eb 4b                	jmp    80108136 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801080eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801080f2:	eb 10                	jmp    80108104 <uartputc+0x2a>
    microdelay(10);
801080f4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801080fb:	e8 1a b1 ff ff       	call   8010321a <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108100:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108104:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108108:	7f 16                	jg     80108120 <uartputc+0x46>
8010810a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80108111:	e8 79 fe ff ff       	call   80107f8f <inb>
80108116:	0f b6 c0             	movzbl %al,%eax
80108119:	83 e0 20             	and    $0x20,%eax
8010811c:	85 c0                	test   %eax,%eax
8010811e:	74 d4                	je     801080f4 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80108120:	8b 45 08             	mov    0x8(%ebp),%eax
80108123:	0f b6 c0             	movzbl %al,%eax
80108126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010812a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80108131:	e8 76 fe ff ff       	call   80107fac <outb>
}
80108136:	c9                   	leave  
80108137:	c3                   	ret    

80108138 <uartgetc>:

static int
uartgetc(void)
{
80108138:	55                   	push   %ebp
80108139:	89 e5                	mov    %esp,%ebp
8010813b:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010813e:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80108143:	85 c0                	test   %eax,%eax
80108145:	75 07                	jne    8010814e <uartgetc+0x16>
    return -1;
80108147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010814c:	eb 2c                	jmp    8010817a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010814e:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80108155:	e8 35 fe ff ff       	call   80107f8f <inb>
8010815a:	0f b6 c0             	movzbl %al,%eax
8010815d:	83 e0 01             	and    $0x1,%eax
80108160:	85 c0                	test   %eax,%eax
80108162:	75 07                	jne    8010816b <uartgetc+0x33>
    return -1;
80108164:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108169:	eb 0f                	jmp    8010817a <uartgetc+0x42>
  return inb(COM1+0);
8010816b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80108172:	e8 18 fe ff ff       	call   80107f8f <inb>
80108177:	0f b6 c0             	movzbl %al,%eax
}
8010817a:	c9                   	leave  
8010817b:	c3                   	ret    

8010817c <uartintr>:

void
uartintr(void)
{
8010817c:	55                   	push   %ebp
8010817d:	89 e5                	mov    %esp,%ebp
8010817f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80108182:	c7 04 24 38 81 10 80 	movl   $0x80108138,(%esp)
80108189:	e8 62 86 ff ff       	call   801007f0 <consoleintr>
}
8010818e:	c9                   	leave  
8010818f:	c3                   	ret    

80108190 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108190:	6a 00                	push   $0x0
  pushl $0
80108192:	6a 00                	push   $0x0
  jmp alltraps
80108194:	e9 58 f8 ff ff       	jmp    801079f1 <alltraps>

80108199 <vector1>:
.globl vector1
vector1:
  pushl $0
80108199:	6a 00                	push   $0x0
  pushl $1
8010819b:	6a 01                	push   $0x1
  jmp alltraps
8010819d:	e9 4f f8 ff ff       	jmp    801079f1 <alltraps>

801081a2 <vector2>:
.globl vector2
vector2:
  pushl $0
801081a2:	6a 00                	push   $0x0
  pushl $2
801081a4:	6a 02                	push   $0x2
  jmp alltraps
801081a6:	e9 46 f8 ff ff       	jmp    801079f1 <alltraps>

801081ab <vector3>:
.globl vector3
vector3:
  pushl $0
801081ab:	6a 00                	push   $0x0
  pushl $3
801081ad:	6a 03                	push   $0x3
  jmp alltraps
801081af:	e9 3d f8 ff ff       	jmp    801079f1 <alltraps>

801081b4 <vector4>:
.globl vector4
vector4:
  pushl $0
801081b4:	6a 00                	push   $0x0
  pushl $4
801081b6:	6a 04                	push   $0x4
  jmp alltraps
801081b8:	e9 34 f8 ff ff       	jmp    801079f1 <alltraps>

801081bd <vector5>:
.globl vector5
vector5:
  pushl $0
801081bd:	6a 00                	push   $0x0
  pushl $5
801081bf:	6a 05                	push   $0x5
  jmp alltraps
801081c1:	e9 2b f8 ff ff       	jmp    801079f1 <alltraps>

801081c6 <vector6>:
.globl vector6
vector6:
  pushl $0
801081c6:	6a 00                	push   $0x0
  pushl $6
801081c8:	6a 06                	push   $0x6
  jmp alltraps
801081ca:	e9 22 f8 ff ff       	jmp    801079f1 <alltraps>

801081cf <vector7>:
.globl vector7
vector7:
  pushl $0
801081cf:	6a 00                	push   $0x0
  pushl $7
801081d1:	6a 07                	push   $0x7
  jmp alltraps
801081d3:	e9 19 f8 ff ff       	jmp    801079f1 <alltraps>

801081d8 <vector8>:
.globl vector8
vector8:
  pushl $8
801081d8:	6a 08                	push   $0x8
  jmp alltraps
801081da:	e9 12 f8 ff ff       	jmp    801079f1 <alltraps>

801081df <vector9>:
.globl vector9
vector9:
  pushl $0
801081df:	6a 00                	push   $0x0
  pushl $9
801081e1:	6a 09                	push   $0x9
  jmp alltraps
801081e3:	e9 09 f8 ff ff       	jmp    801079f1 <alltraps>

801081e8 <vector10>:
.globl vector10
vector10:
  pushl $10
801081e8:	6a 0a                	push   $0xa
  jmp alltraps
801081ea:	e9 02 f8 ff ff       	jmp    801079f1 <alltraps>

801081ef <vector11>:
.globl vector11
vector11:
  pushl $11
801081ef:	6a 0b                	push   $0xb
  jmp alltraps
801081f1:	e9 fb f7 ff ff       	jmp    801079f1 <alltraps>

801081f6 <vector12>:
.globl vector12
vector12:
  pushl $12
801081f6:	6a 0c                	push   $0xc
  jmp alltraps
801081f8:	e9 f4 f7 ff ff       	jmp    801079f1 <alltraps>

801081fd <vector13>:
.globl vector13
vector13:
  pushl $13
801081fd:	6a 0d                	push   $0xd
  jmp alltraps
801081ff:	e9 ed f7 ff ff       	jmp    801079f1 <alltraps>

80108204 <vector14>:
.globl vector14
vector14:
  pushl $14
80108204:	6a 0e                	push   $0xe
  jmp alltraps
80108206:	e9 e6 f7 ff ff       	jmp    801079f1 <alltraps>

8010820b <vector15>:
.globl vector15
vector15:
  pushl $0
8010820b:	6a 00                	push   $0x0
  pushl $15
8010820d:	6a 0f                	push   $0xf
  jmp alltraps
8010820f:	e9 dd f7 ff ff       	jmp    801079f1 <alltraps>

80108214 <vector16>:
.globl vector16
vector16:
  pushl $0
80108214:	6a 00                	push   $0x0
  pushl $16
80108216:	6a 10                	push   $0x10
  jmp alltraps
80108218:	e9 d4 f7 ff ff       	jmp    801079f1 <alltraps>

8010821d <vector17>:
.globl vector17
vector17:
  pushl $17
8010821d:	6a 11                	push   $0x11
  jmp alltraps
8010821f:	e9 cd f7 ff ff       	jmp    801079f1 <alltraps>

80108224 <vector18>:
.globl vector18
vector18:
  pushl $0
80108224:	6a 00                	push   $0x0
  pushl $18
80108226:	6a 12                	push   $0x12
  jmp alltraps
80108228:	e9 c4 f7 ff ff       	jmp    801079f1 <alltraps>

8010822d <vector19>:
.globl vector19
vector19:
  pushl $0
8010822d:	6a 00                	push   $0x0
  pushl $19
8010822f:	6a 13                	push   $0x13
  jmp alltraps
80108231:	e9 bb f7 ff ff       	jmp    801079f1 <alltraps>

80108236 <vector20>:
.globl vector20
vector20:
  pushl $0
80108236:	6a 00                	push   $0x0
  pushl $20
80108238:	6a 14                	push   $0x14
  jmp alltraps
8010823a:	e9 b2 f7 ff ff       	jmp    801079f1 <alltraps>

8010823f <vector21>:
.globl vector21
vector21:
  pushl $0
8010823f:	6a 00                	push   $0x0
  pushl $21
80108241:	6a 15                	push   $0x15
  jmp alltraps
80108243:	e9 a9 f7 ff ff       	jmp    801079f1 <alltraps>

80108248 <vector22>:
.globl vector22
vector22:
  pushl $0
80108248:	6a 00                	push   $0x0
  pushl $22
8010824a:	6a 16                	push   $0x16
  jmp alltraps
8010824c:	e9 a0 f7 ff ff       	jmp    801079f1 <alltraps>

80108251 <vector23>:
.globl vector23
vector23:
  pushl $0
80108251:	6a 00                	push   $0x0
  pushl $23
80108253:	6a 17                	push   $0x17
  jmp alltraps
80108255:	e9 97 f7 ff ff       	jmp    801079f1 <alltraps>

8010825a <vector24>:
.globl vector24
vector24:
  pushl $0
8010825a:	6a 00                	push   $0x0
  pushl $24
8010825c:	6a 18                	push   $0x18
  jmp alltraps
8010825e:	e9 8e f7 ff ff       	jmp    801079f1 <alltraps>

80108263 <vector25>:
.globl vector25
vector25:
  pushl $0
80108263:	6a 00                	push   $0x0
  pushl $25
80108265:	6a 19                	push   $0x19
  jmp alltraps
80108267:	e9 85 f7 ff ff       	jmp    801079f1 <alltraps>

8010826c <vector26>:
.globl vector26
vector26:
  pushl $0
8010826c:	6a 00                	push   $0x0
  pushl $26
8010826e:	6a 1a                	push   $0x1a
  jmp alltraps
80108270:	e9 7c f7 ff ff       	jmp    801079f1 <alltraps>

80108275 <vector27>:
.globl vector27
vector27:
  pushl $0
80108275:	6a 00                	push   $0x0
  pushl $27
80108277:	6a 1b                	push   $0x1b
  jmp alltraps
80108279:	e9 73 f7 ff ff       	jmp    801079f1 <alltraps>

8010827e <vector28>:
.globl vector28
vector28:
  pushl $0
8010827e:	6a 00                	push   $0x0
  pushl $28
80108280:	6a 1c                	push   $0x1c
  jmp alltraps
80108282:	e9 6a f7 ff ff       	jmp    801079f1 <alltraps>

80108287 <vector29>:
.globl vector29
vector29:
  pushl $0
80108287:	6a 00                	push   $0x0
  pushl $29
80108289:	6a 1d                	push   $0x1d
  jmp alltraps
8010828b:	e9 61 f7 ff ff       	jmp    801079f1 <alltraps>

80108290 <vector30>:
.globl vector30
vector30:
  pushl $0
80108290:	6a 00                	push   $0x0
  pushl $30
80108292:	6a 1e                	push   $0x1e
  jmp alltraps
80108294:	e9 58 f7 ff ff       	jmp    801079f1 <alltraps>

80108299 <vector31>:
.globl vector31
vector31:
  pushl $0
80108299:	6a 00                	push   $0x0
  pushl $31
8010829b:	6a 1f                	push   $0x1f
  jmp alltraps
8010829d:	e9 4f f7 ff ff       	jmp    801079f1 <alltraps>

801082a2 <vector32>:
.globl vector32
vector32:
  pushl $0
801082a2:	6a 00                	push   $0x0
  pushl $32
801082a4:	6a 20                	push   $0x20
  jmp alltraps
801082a6:	e9 46 f7 ff ff       	jmp    801079f1 <alltraps>

801082ab <vector33>:
.globl vector33
vector33:
  pushl $0
801082ab:	6a 00                	push   $0x0
  pushl $33
801082ad:	6a 21                	push   $0x21
  jmp alltraps
801082af:	e9 3d f7 ff ff       	jmp    801079f1 <alltraps>

801082b4 <vector34>:
.globl vector34
vector34:
  pushl $0
801082b4:	6a 00                	push   $0x0
  pushl $34
801082b6:	6a 22                	push   $0x22
  jmp alltraps
801082b8:	e9 34 f7 ff ff       	jmp    801079f1 <alltraps>

801082bd <vector35>:
.globl vector35
vector35:
  pushl $0
801082bd:	6a 00                	push   $0x0
  pushl $35
801082bf:	6a 23                	push   $0x23
  jmp alltraps
801082c1:	e9 2b f7 ff ff       	jmp    801079f1 <alltraps>

801082c6 <vector36>:
.globl vector36
vector36:
  pushl $0
801082c6:	6a 00                	push   $0x0
  pushl $36
801082c8:	6a 24                	push   $0x24
  jmp alltraps
801082ca:	e9 22 f7 ff ff       	jmp    801079f1 <alltraps>

801082cf <vector37>:
.globl vector37
vector37:
  pushl $0
801082cf:	6a 00                	push   $0x0
  pushl $37
801082d1:	6a 25                	push   $0x25
  jmp alltraps
801082d3:	e9 19 f7 ff ff       	jmp    801079f1 <alltraps>

801082d8 <vector38>:
.globl vector38
vector38:
  pushl $0
801082d8:	6a 00                	push   $0x0
  pushl $38
801082da:	6a 26                	push   $0x26
  jmp alltraps
801082dc:	e9 10 f7 ff ff       	jmp    801079f1 <alltraps>

801082e1 <vector39>:
.globl vector39
vector39:
  pushl $0
801082e1:	6a 00                	push   $0x0
  pushl $39
801082e3:	6a 27                	push   $0x27
  jmp alltraps
801082e5:	e9 07 f7 ff ff       	jmp    801079f1 <alltraps>

801082ea <vector40>:
.globl vector40
vector40:
  pushl $0
801082ea:	6a 00                	push   $0x0
  pushl $40
801082ec:	6a 28                	push   $0x28
  jmp alltraps
801082ee:	e9 fe f6 ff ff       	jmp    801079f1 <alltraps>

801082f3 <vector41>:
.globl vector41
vector41:
  pushl $0
801082f3:	6a 00                	push   $0x0
  pushl $41
801082f5:	6a 29                	push   $0x29
  jmp alltraps
801082f7:	e9 f5 f6 ff ff       	jmp    801079f1 <alltraps>

801082fc <vector42>:
.globl vector42
vector42:
  pushl $0
801082fc:	6a 00                	push   $0x0
  pushl $42
801082fe:	6a 2a                	push   $0x2a
  jmp alltraps
80108300:	e9 ec f6 ff ff       	jmp    801079f1 <alltraps>

80108305 <vector43>:
.globl vector43
vector43:
  pushl $0
80108305:	6a 00                	push   $0x0
  pushl $43
80108307:	6a 2b                	push   $0x2b
  jmp alltraps
80108309:	e9 e3 f6 ff ff       	jmp    801079f1 <alltraps>

8010830e <vector44>:
.globl vector44
vector44:
  pushl $0
8010830e:	6a 00                	push   $0x0
  pushl $44
80108310:	6a 2c                	push   $0x2c
  jmp alltraps
80108312:	e9 da f6 ff ff       	jmp    801079f1 <alltraps>

80108317 <vector45>:
.globl vector45
vector45:
  pushl $0
80108317:	6a 00                	push   $0x0
  pushl $45
80108319:	6a 2d                	push   $0x2d
  jmp alltraps
8010831b:	e9 d1 f6 ff ff       	jmp    801079f1 <alltraps>

80108320 <vector46>:
.globl vector46
vector46:
  pushl $0
80108320:	6a 00                	push   $0x0
  pushl $46
80108322:	6a 2e                	push   $0x2e
  jmp alltraps
80108324:	e9 c8 f6 ff ff       	jmp    801079f1 <alltraps>

80108329 <vector47>:
.globl vector47
vector47:
  pushl $0
80108329:	6a 00                	push   $0x0
  pushl $47
8010832b:	6a 2f                	push   $0x2f
  jmp alltraps
8010832d:	e9 bf f6 ff ff       	jmp    801079f1 <alltraps>

80108332 <vector48>:
.globl vector48
vector48:
  pushl $0
80108332:	6a 00                	push   $0x0
  pushl $48
80108334:	6a 30                	push   $0x30
  jmp alltraps
80108336:	e9 b6 f6 ff ff       	jmp    801079f1 <alltraps>

8010833b <vector49>:
.globl vector49
vector49:
  pushl $0
8010833b:	6a 00                	push   $0x0
  pushl $49
8010833d:	6a 31                	push   $0x31
  jmp alltraps
8010833f:	e9 ad f6 ff ff       	jmp    801079f1 <alltraps>

80108344 <vector50>:
.globl vector50
vector50:
  pushl $0
80108344:	6a 00                	push   $0x0
  pushl $50
80108346:	6a 32                	push   $0x32
  jmp alltraps
80108348:	e9 a4 f6 ff ff       	jmp    801079f1 <alltraps>

8010834d <vector51>:
.globl vector51
vector51:
  pushl $0
8010834d:	6a 00                	push   $0x0
  pushl $51
8010834f:	6a 33                	push   $0x33
  jmp alltraps
80108351:	e9 9b f6 ff ff       	jmp    801079f1 <alltraps>

80108356 <vector52>:
.globl vector52
vector52:
  pushl $0
80108356:	6a 00                	push   $0x0
  pushl $52
80108358:	6a 34                	push   $0x34
  jmp alltraps
8010835a:	e9 92 f6 ff ff       	jmp    801079f1 <alltraps>

8010835f <vector53>:
.globl vector53
vector53:
  pushl $0
8010835f:	6a 00                	push   $0x0
  pushl $53
80108361:	6a 35                	push   $0x35
  jmp alltraps
80108363:	e9 89 f6 ff ff       	jmp    801079f1 <alltraps>

80108368 <vector54>:
.globl vector54
vector54:
  pushl $0
80108368:	6a 00                	push   $0x0
  pushl $54
8010836a:	6a 36                	push   $0x36
  jmp alltraps
8010836c:	e9 80 f6 ff ff       	jmp    801079f1 <alltraps>

80108371 <vector55>:
.globl vector55
vector55:
  pushl $0
80108371:	6a 00                	push   $0x0
  pushl $55
80108373:	6a 37                	push   $0x37
  jmp alltraps
80108375:	e9 77 f6 ff ff       	jmp    801079f1 <alltraps>

8010837a <vector56>:
.globl vector56
vector56:
  pushl $0
8010837a:	6a 00                	push   $0x0
  pushl $56
8010837c:	6a 38                	push   $0x38
  jmp alltraps
8010837e:	e9 6e f6 ff ff       	jmp    801079f1 <alltraps>

80108383 <vector57>:
.globl vector57
vector57:
  pushl $0
80108383:	6a 00                	push   $0x0
  pushl $57
80108385:	6a 39                	push   $0x39
  jmp alltraps
80108387:	e9 65 f6 ff ff       	jmp    801079f1 <alltraps>

8010838c <vector58>:
.globl vector58
vector58:
  pushl $0
8010838c:	6a 00                	push   $0x0
  pushl $58
8010838e:	6a 3a                	push   $0x3a
  jmp alltraps
80108390:	e9 5c f6 ff ff       	jmp    801079f1 <alltraps>

80108395 <vector59>:
.globl vector59
vector59:
  pushl $0
80108395:	6a 00                	push   $0x0
  pushl $59
80108397:	6a 3b                	push   $0x3b
  jmp alltraps
80108399:	e9 53 f6 ff ff       	jmp    801079f1 <alltraps>

8010839e <vector60>:
.globl vector60
vector60:
  pushl $0
8010839e:	6a 00                	push   $0x0
  pushl $60
801083a0:	6a 3c                	push   $0x3c
  jmp alltraps
801083a2:	e9 4a f6 ff ff       	jmp    801079f1 <alltraps>

801083a7 <vector61>:
.globl vector61
vector61:
  pushl $0
801083a7:	6a 00                	push   $0x0
  pushl $61
801083a9:	6a 3d                	push   $0x3d
  jmp alltraps
801083ab:	e9 41 f6 ff ff       	jmp    801079f1 <alltraps>

801083b0 <vector62>:
.globl vector62
vector62:
  pushl $0
801083b0:	6a 00                	push   $0x0
  pushl $62
801083b2:	6a 3e                	push   $0x3e
  jmp alltraps
801083b4:	e9 38 f6 ff ff       	jmp    801079f1 <alltraps>

801083b9 <vector63>:
.globl vector63
vector63:
  pushl $0
801083b9:	6a 00                	push   $0x0
  pushl $63
801083bb:	6a 3f                	push   $0x3f
  jmp alltraps
801083bd:	e9 2f f6 ff ff       	jmp    801079f1 <alltraps>

801083c2 <vector64>:
.globl vector64
vector64:
  pushl $0
801083c2:	6a 00                	push   $0x0
  pushl $64
801083c4:	6a 40                	push   $0x40
  jmp alltraps
801083c6:	e9 26 f6 ff ff       	jmp    801079f1 <alltraps>

801083cb <vector65>:
.globl vector65
vector65:
  pushl $0
801083cb:	6a 00                	push   $0x0
  pushl $65
801083cd:	6a 41                	push   $0x41
  jmp alltraps
801083cf:	e9 1d f6 ff ff       	jmp    801079f1 <alltraps>

801083d4 <vector66>:
.globl vector66
vector66:
  pushl $0
801083d4:	6a 00                	push   $0x0
  pushl $66
801083d6:	6a 42                	push   $0x42
  jmp alltraps
801083d8:	e9 14 f6 ff ff       	jmp    801079f1 <alltraps>

801083dd <vector67>:
.globl vector67
vector67:
  pushl $0
801083dd:	6a 00                	push   $0x0
  pushl $67
801083df:	6a 43                	push   $0x43
  jmp alltraps
801083e1:	e9 0b f6 ff ff       	jmp    801079f1 <alltraps>

801083e6 <vector68>:
.globl vector68
vector68:
  pushl $0
801083e6:	6a 00                	push   $0x0
  pushl $68
801083e8:	6a 44                	push   $0x44
  jmp alltraps
801083ea:	e9 02 f6 ff ff       	jmp    801079f1 <alltraps>

801083ef <vector69>:
.globl vector69
vector69:
  pushl $0
801083ef:	6a 00                	push   $0x0
  pushl $69
801083f1:	6a 45                	push   $0x45
  jmp alltraps
801083f3:	e9 f9 f5 ff ff       	jmp    801079f1 <alltraps>

801083f8 <vector70>:
.globl vector70
vector70:
  pushl $0
801083f8:	6a 00                	push   $0x0
  pushl $70
801083fa:	6a 46                	push   $0x46
  jmp alltraps
801083fc:	e9 f0 f5 ff ff       	jmp    801079f1 <alltraps>

80108401 <vector71>:
.globl vector71
vector71:
  pushl $0
80108401:	6a 00                	push   $0x0
  pushl $71
80108403:	6a 47                	push   $0x47
  jmp alltraps
80108405:	e9 e7 f5 ff ff       	jmp    801079f1 <alltraps>

8010840a <vector72>:
.globl vector72
vector72:
  pushl $0
8010840a:	6a 00                	push   $0x0
  pushl $72
8010840c:	6a 48                	push   $0x48
  jmp alltraps
8010840e:	e9 de f5 ff ff       	jmp    801079f1 <alltraps>

80108413 <vector73>:
.globl vector73
vector73:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $73
80108415:	6a 49                	push   $0x49
  jmp alltraps
80108417:	e9 d5 f5 ff ff       	jmp    801079f1 <alltraps>

8010841c <vector74>:
.globl vector74
vector74:
  pushl $0
8010841c:	6a 00                	push   $0x0
  pushl $74
8010841e:	6a 4a                	push   $0x4a
  jmp alltraps
80108420:	e9 cc f5 ff ff       	jmp    801079f1 <alltraps>

80108425 <vector75>:
.globl vector75
vector75:
  pushl $0
80108425:	6a 00                	push   $0x0
  pushl $75
80108427:	6a 4b                	push   $0x4b
  jmp alltraps
80108429:	e9 c3 f5 ff ff       	jmp    801079f1 <alltraps>

8010842e <vector76>:
.globl vector76
vector76:
  pushl $0
8010842e:	6a 00                	push   $0x0
  pushl $76
80108430:	6a 4c                	push   $0x4c
  jmp alltraps
80108432:	e9 ba f5 ff ff       	jmp    801079f1 <alltraps>

80108437 <vector77>:
.globl vector77
vector77:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $77
80108439:	6a 4d                	push   $0x4d
  jmp alltraps
8010843b:	e9 b1 f5 ff ff       	jmp    801079f1 <alltraps>

80108440 <vector78>:
.globl vector78
vector78:
  pushl $0
80108440:	6a 00                	push   $0x0
  pushl $78
80108442:	6a 4e                	push   $0x4e
  jmp alltraps
80108444:	e9 a8 f5 ff ff       	jmp    801079f1 <alltraps>

80108449 <vector79>:
.globl vector79
vector79:
  pushl $0
80108449:	6a 00                	push   $0x0
  pushl $79
8010844b:	6a 4f                	push   $0x4f
  jmp alltraps
8010844d:	e9 9f f5 ff ff       	jmp    801079f1 <alltraps>

80108452 <vector80>:
.globl vector80
vector80:
  pushl $0
80108452:	6a 00                	push   $0x0
  pushl $80
80108454:	6a 50                	push   $0x50
  jmp alltraps
80108456:	e9 96 f5 ff ff       	jmp    801079f1 <alltraps>

8010845b <vector81>:
.globl vector81
vector81:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $81
8010845d:	6a 51                	push   $0x51
  jmp alltraps
8010845f:	e9 8d f5 ff ff       	jmp    801079f1 <alltraps>

80108464 <vector82>:
.globl vector82
vector82:
  pushl $0
80108464:	6a 00                	push   $0x0
  pushl $82
80108466:	6a 52                	push   $0x52
  jmp alltraps
80108468:	e9 84 f5 ff ff       	jmp    801079f1 <alltraps>

8010846d <vector83>:
.globl vector83
vector83:
  pushl $0
8010846d:	6a 00                	push   $0x0
  pushl $83
8010846f:	6a 53                	push   $0x53
  jmp alltraps
80108471:	e9 7b f5 ff ff       	jmp    801079f1 <alltraps>

80108476 <vector84>:
.globl vector84
vector84:
  pushl $0
80108476:	6a 00                	push   $0x0
  pushl $84
80108478:	6a 54                	push   $0x54
  jmp alltraps
8010847a:	e9 72 f5 ff ff       	jmp    801079f1 <alltraps>

8010847f <vector85>:
.globl vector85
vector85:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $85
80108481:	6a 55                	push   $0x55
  jmp alltraps
80108483:	e9 69 f5 ff ff       	jmp    801079f1 <alltraps>

80108488 <vector86>:
.globl vector86
vector86:
  pushl $0
80108488:	6a 00                	push   $0x0
  pushl $86
8010848a:	6a 56                	push   $0x56
  jmp alltraps
8010848c:	e9 60 f5 ff ff       	jmp    801079f1 <alltraps>

80108491 <vector87>:
.globl vector87
vector87:
  pushl $0
80108491:	6a 00                	push   $0x0
  pushl $87
80108493:	6a 57                	push   $0x57
  jmp alltraps
80108495:	e9 57 f5 ff ff       	jmp    801079f1 <alltraps>

8010849a <vector88>:
.globl vector88
vector88:
  pushl $0
8010849a:	6a 00                	push   $0x0
  pushl $88
8010849c:	6a 58                	push   $0x58
  jmp alltraps
8010849e:	e9 4e f5 ff ff       	jmp    801079f1 <alltraps>

801084a3 <vector89>:
.globl vector89
vector89:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $89
801084a5:	6a 59                	push   $0x59
  jmp alltraps
801084a7:	e9 45 f5 ff ff       	jmp    801079f1 <alltraps>

801084ac <vector90>:
.globl vector90
vector90:
  pushl $0
801084ac:	6a 00                	push   $0x0
  pushl $90
801084ae:	6a 5a                	push   $0x5a
  jmp alltraps
801084b0:	e9 3c f5 ff ff       	jmp    801079f1 <alltraps>

801084b5 <vector91>:
.globl vector91
vector91:
  pushl $0
801084b5:	6a 00                	push   $0x0
  pushl $91
801084b7:	6a 5b                	push   $0x5b
  jmp alltraps
801084b9:	e9 33 f5 ff ff       	jmp    801079f1 <alltraps>

801084be <vector92>:
.globl vector92
vector92:
  pushl $0
801084be:	6a 00                	push   $0x0
  pushl $92
801084c0:	6a 5c                	push   $0x5c
  jmp alltraps
801084c2:	e9 2a f5 ff ff       	jmp    801079f1 <alltraps>

801084c7 <vector93>:
.globl vector93
vector93:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $93
801084c9:	6a 5d                	push   $0x5d
  jmp alltraps
801084cb:	e9 21 f5 ff ff       	jmp    801079f1 <alltraps>

801084d0 <vector94>:
.globl vector94
vector94:
  pushl $0
801084d0:	6a 00                	push   $0x0
  pushl $94
801084d2:	6a 5e                	push   $0x5e
  jmp alltraps
801084d4:	e9 18 f5 ff ff       	jmp    801079f1 <alltraps>

801084d9 <vector95>:
.globl vector95
vector95:
  pushl $0
801084d9:	6a 00                	push   $0x0
  pushl $95
801084db:	6a 5f                	push   $0x5f
  jmp alltraps
801084dd:	e9 0f f5 ff ff       	jmp    801079f1 <alltraps>

801084e2 <vector96>:
.globl vector96
vector96:
  pushl $0
801084e2:	6a 00                	push   $0x0
  pushl $96
801084e4:	6a 60                	push   $0x60
  jmp alltraps
801084e6:	e9 06 f5 ff ff       	jmp    801079f1 <alltraps>

801084eb <vector97>:
.globl vector97
vector97:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $97
801084ed:	6a 61                	push   $0x61
  jmp alltraps
801084ef:	e9 fd f4 ff ff       	jmp    801079f1 <alltraps>

801084f4 <vector98>:
.globl vector98
vector98:
  pushl $0
801084f4:	6a 00                	push   $0x0
  pushl $98
801084f6:	6a 62                	push   $0x62
  jmp alltraps
801084f8:	e9 f4 f4 ff ff       	jmp    801079f1 <alltraps>

801084fd <vector99>:
.globl vector99
vector99:
  pushl $0
801084fd:	6a 00                	push   $0x0
  pushl $99
801084ff:	6a 63                	push   $0x63
  jmp alltraps
80108501:	e9 eb f4 ff ff       	jmp    801079f1 <alltraps>

80108506 <vector100>:
.globl vector100
vector100:
  pushl $0
80108506:	6a 00                	push   $0x0
  pushl $100
80108508:	6a 64                	push   $0x64
  jmp alltraps
8010850a:	e9 e2 f4 ff ff       	jmp    801079f1 <alltraps>

8010850f <vector101>:
.globl vector101
vector101:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $101
80108511:	6a 65                	push   $0x65
  jmp alltraps
80108513:	e9 d9 f4 ff ff       	jmp    801079f1 <alltraps>

80108518 <vector102>:
.globl vector102
vector102:
  pushl $0
80108518:	6a 00                	push   $0x0
  pushl $102
8010851a:	6a 66                	push   $0x66
  jmp alltraps
8010851c:	e9 d0 f4 ff ff       	jmp    801079f1 <alltraps>

80108521 <vector103>:
.globl vector103
vector103:
  pushl $0
80108521:	6a 00                	push   $0x0
  pushl $103
80108523:	6a 67                	push   $0x67
  jmp alltraps
80108525:	e9 c7 f4 ff ff       	jmp    801079f1 <alltraps>

8010852a <vector104>:
.globl vector104
vector104:
  pushl $0
8010852a:	6a 00                	push   $0x0
  pushl $104
8010852c:	6a 68                	push   $0x68
  jmp alltraps
8010852e:	e9 be f4 ff ff       	jmp    801079f1 <alltraps>

80108533 <vector105>:
.globl vector105
vector105:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $105
80108535:	6a 69                	push   $0x69
  jmp alltraps
80108537:	e9 b5 f4 ff ff       	jmp    801079f1 <alltraps>

8010853c <vector106>:
.globl vector106
vector106:
  pushl $0
8010853c:	6a 00                	push   $0x0
  pushl $106
8010853e:	6a 6a                	push   $0x6a
  jmp alltraps
80108540:	e9 ac f4 ff ff       	jmp    801079f1 <alltraps>

80108545 <vector107>:
.globl vector107
vector107:
  pushl $0
80108545:	6a 00                	push   $0x0
  pushl $107
80108547:	6a 6b                	push   $0x6b
  jmp alltraps
80108549:	e9 a3 f4 ff ff       	jmp    801079f1 <alltraps>

8010854e <vector108>:
.globl vector108
vector108:
  pushl $0
8010854e:	6a 00                	push   $0x0
  pushl $108
80108550:	6a 6c                	push   $0x6c
  jmp alltraps
80108552:	e9 9a f4 ff ff       	jmp    801079f1 <alltraps>

80108557 <vector109>:
.globl vector109
vector109:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $109
80108559:	6a 6d                	push   $0x6d
  jmp alltraps
8010855b:	e9 91 f4 ff ff       	jmp    801079f1 <alltraps>

80108560 <vector110>:
.globl vector110
vector110:
  pushl $0
80108560:	6a 00                	push   $0x0
  pushl $110
80108562:	6a 6e                	push   $0x6e
  jmp alltraps
80108564:	e9 88 f4 ff ff       	jmp    801079f1 <alltraps>

80108569 <vector111>:
.globl vector111
vector111:
  pushl $0
80108569:	6a 00                	push   $0x0
  pushl $111
8010856b:	6a 6f                	push   $0x6f
  jmp alltraps
8010856d:	e9 7f f4 ff ff       	jmp    801079f1 <alltraps>

80108572 <vector112>:
.globl vector112
vector112:
  pushl $0
80108572:	6a 00                	push   $0x0
  pushl $112
80108574:	6a 70                	push   $0x70
  jmp alltraps
80108576:	e9 76 f4 ff ff       	jmp    801079f1 <alltraps>

8010857b <vector113>:
.globl vector113
vector113:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $113
8010857d:	6a 71                	push   $0x71
  jmp alltraps
8010857f:	e9 6d f4 ff ff       	jmp    801079f1 <alltraps>

80108584 <vector114>:
.globl vector114
vector114:
  pushl $0
80108584:	6a 00                	push   $0x0
  pushl $114
80108586:	6a 72                	push   $0x72
  jmp alltraps
80108588:	e9 64 f4 ff ff       	jmp    801079f1 <alltraps>

8010858d <vector115>:
.globl vector115
vector115:
  pushl $0
8010858d:	6a 00                	push   $0x0
  pushl $115
8010858f:	6a 73                	push   $0x73
  jmp alltraps
80108591:	e9 5b f4 ff ff       	jmp    801079f1 <alltraps>

80108596 <vector116>:
.globl vector116
vector116:
  pushl $0
80108596:	6a 00                	push   $0x0
  pushl $116
80108598:	6a 74                	push   $0x74
  jmp alltraps
8010859a:	e9 52 f4 ff ff       	jmp    801079f1 <alltraps>

8010859f <vector117>:
.globl vector117
vector117:
  pushl $0
8010859f:	6a 00                	push   $0x0
  pushl $117
801085a1:	6a 75                	push   $0x75
  jmp alltraps
801085a3:	e9 49 f4 ff ff       	jmp    801079f1 <alltraps>

801085a8 <vector118>:
.globl vector118
vector118:
  pushl $0
801085a8:	6a 00                	push   $0x0
  pushl $118
801085aa:	6a 76                	push   $0x76
  jmp alltraps
801085ac:	e9 40 f4 ff ff       	jmp    801079f1 <alltraps>

801085b1 <vector119>:
.globl vector119
vector119:
  pushl $0
801085b1:	6a 00                	push   $0x0
  pushl $119
801085b3:	6a 77                	push   $0x77
  jmp alltraps
801085b5:	e9 37 f4 ff ff       	jmp    801079f1 <alltraps>

801085ba <vector120>:
.globl vector120
vector120:
  pushl $0
801085ba:	6a 00                	push   $0x0
  pushl $120
801085bc:	6a 78                	push   $0x78
  jmp alltraps
801085be:	e9 2e f4 ff ff       	jmp    801079f1 <alltraps>

801085c3 <vector121>:
.globl vector121
vector121:
  pushl $0
801085c3:	6a 00                	push   $0x0
  pushl $121
801085c5:	6a 79                	push   $0x79
  jmp alltraps
801085c7:	e9 25 f4 ff ff       	jmp    801079f1 <alltraps>

801085cc <vector122>:
.globl vector122
vector122:
  pushl $0
801085cc:	6a 00                	push   $0x0
  pushl $122
801085ce:	6a 7a                	push   $0x7a
  jmp alltraps
801085d0:	e9 1c f4 ff ff       	jmp    801079f1 <alltraps>

801085d5 <vector123>:
.globl vector123
vector123:
  pushl $0
801085d5:	6a 00                	push   $0x0
  pushl $123
801085d7:	6a 7b                	push   $0x7b
  jmp alltraps
801085d9:	e9 13 f4 ff ff       	jmp    801079f1 <alltraps>

801085de <vector124>:
.globl vector124
vector124:
  pushl $0
801085de:	6a 00                	push   $0x0
  pushl $124
801085e0:	6a 7c                	push   $0x7c
  jmp alltraps
801085e2:	e9 0a f4 ff ff       	jmp    801079f1 <alltraps>

801085e7 <vector125>:
.globl vector125
vector125:
  pushl $0
801085e7:	6a 00                	push   $0x0
  pushl $125
801085e9:	6a 7d                	push   $0x7d
  jmp alltraps
801085eb:	e9 01 f4 ff ff       	jmp    801079f1 <alltraps>

801085f0 <vector126>:
.globl vector126
vector126:
  pushl $0
801085f0:	6a 00                	push   $0x0
  pushl $126
801085f2:	6a 7e                	push   $0x7e
  jmp alltraps
801085f4:	e9 f8 f3 ff ff       	jmp    801079f1 <alltraps>

801085f9 <vector127>:
.globl vector127
vector127:
  pushl $0
801085f9:	6a 00                	push   $0x0
  pushl $127
801085fb:	6a 7f                	push   $0x7f
  jmp alltraps
801085fd:	e9 ef f3 ff ff       	jmp    801079f1 <alltraps>

80108602 <vector128>:
.globl vector128
vector128:
  pushl $0
80108602:	6a 00                	push   $0x0
  pushl $128
80108604:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108609:	e9 e3 f3 ff ff       	jmp    801079f1 <alltraps>

8010860e <vector129>:
.globl vector129
vector129:
  pushl $0
8010860e:	6a 00                	push   $0x0
  pushl $129
80108610:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108615:	e9 d7 f3 ff ff       	jmp    801079f1 <alltraps>

8010861a <vector130>:
.globl vector130
vector130:
  pushl $0
8010861a:	6a 00                	push   $0x0
  pushl $130
8010861c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108621:	e9 cb f3 ff ff       	jmp    801079f1 <alltraps>

80108626 <vector131>:
.globl vector131
vector131:
  pushl $0
80108626:	6a 00                	push   $0x0
  pushl $131
80108628:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010862d:	e9 bf f3 ff ff       	jmp    801079f1 <alltraps>

80108632 <vector132>:
.globl vector132
vector132:
  pushl $0
80108632:	6a 00                	push   $0x0
  pushl $132
80108634:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108639:	e9 b3 f3 ff ff       	jmp    801079f1 <alltraps>

8010863e <vector133>:
.globl vector133
vector133:
  pushl $0
8010863e:	6a 00                	push   $0x0
  pushl $133
80108640:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108645:	e9 a7 f3 ff ff       	jmp    801079f1 <alltraps>

8010864a <vector134>:
.globl vector134
vector134:
  pushl $0
8010864a:	6a 00                	push   $0x0
  pushl $134
8010864c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108651:	e9 9b f3 ff ff       	jmp    801079f1 <alltraps>

80108656 <vector135>:
.globl vector135
vector135:
  pushl $0
80108656:	6a 00                	push   $0x0
  pushl $135
80108658:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010865d:	e9 8f f3 ff ff       	jmp    801079f1 <alltraps>

80108662 <vector136>:
.globl vector136
vector136:
  pushl $0
80108662:	6a 00                	push   $0x0
  pushl $136
80108664:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108669:	e9 83 f3 ff ff       	jmp    801079f1 <alltraps>

8010866e <vector137>:
.globl vector137
vector137:
  pushl $0
8010866e:	6a 00                	push   $0x0
  pushl $137
80108670:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108675:	e9 77 f3 ff ff       	jmp    801079f1 <alltraps>

8010867a <vector138>:
.globl vector138
vector138:
  pushl $0
8010867a:	6a 00                	push   $0x0
  pushl $138
8010867c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108681:	e9 6b f3 ff ff       	jmp    801079f1 <alltraps>

80108686 <vector139>:
.globl vector139
vector139:
  pushl $0
80108686:	6a 00                	push   $0x0
  pushl $139
80108688:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010868d:	e9 5f f3 ff ff       	jmp    801079f1 <alltraps>

80108692 <vector140>:
.globl vector140
vector140:
  pushl $0
80108692:	6a 00                	push   $0x0
  pushl $140
80108694:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108699:	e9 53 f3 ff ff       	jmp    801079f1 <alltraps>

8010869e <vector141>:
.globl vector141
vector141:
  pushl $0
8010869e:	6a 00                	push   $0x0
  pushl $141
801086a0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801086a5:	e9 47 f3 ff ff       	jmp    801079f1 <alltraps>

801086aa <vector142>:
.globl vector142
vector142:
  pushl $0
801086aa:	6a 00                	push   $0x0
  pushl $142
801086ac:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801086b1:	e9 3b f3 ff ff       	jmp    801079f1 <alltraps>

801086b6 <vector143>:
.globl vector143
vector143:
  pushl $0
801086b6:	6a 00                	push   $0x0
  pushl $143
801086b8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801086bd:	e9 2f f3 ff ff       	jmp    801079f1 <alltraps>

801086c2 <vector144>:
.globl vector144
vector144:
  pushl $0
801086c2:	6a 00                	push   $0x0
  pushl $144
801086c4:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801086c9:	e9 23 f3 ff ff       	jmp    801079f1 <alltraps>

801086ce <vector145>:
.globl vector145
vector145:
  pushl $0
801086ce:	6a 00                	push   $0x0
  pushl $145
801086d0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801086d5:	e9 17 f3 ff ff       	jmp    801079f1 <alltraps>

801086da <vector146>:
.globl vector146
vector146:
  pushl $0
801086da:	6a 00                	push   $0x0
  pushl $146
801086dc:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801086e1:	e9 0b f3 ff ff       	jmp    801079f1 <alltraps>

801086e6 <vector147>:
.globl vector147
vector147:
  pushl $0
801086e6:	6a 00                	push   $0x0
  pushl $147
801086e8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801086ed:	e9 ff f2 ff ff       	jmp    801079f1 <alltraps>

801086f2 <vector148>:
.globl vector148
vector148:
  pushl $0
801086f2:	6a 00                	push   $0x0
  pushl $148
801086f4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801086f9:	e9 f3 f2 ff ff       	jmp    801079f1 <alltraps>

801086fe <vector149>:
.globl vector149
vector149:
  pushl $0
801086fe:	6a 00                	push   $0x0
  pushl $149
80108700:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108705:	e9 e7 f2 ff ff       	jmp    801079f1 <alltraps>

8010870a <vector150>:
.globl vector150
vector150:
  pushl $0
8010870a:	6a 00                	push   $0x0
  pushl $150
8010870c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108711:	e9 db f2 ff ff       	jmp    801079f1 <alltraps>

80108716 <vector151>:
.globl vector151
vector151:
  pushl $0
80108716:	6a 00                	push   $0x0
  pushl $151
80108718:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010871d:	e9 cf f2 ff ff       	jmp    801079f1 <alltraps>

80108722 <vector152>:
.globl vector152
vector152:
  pushl $0
80108722:	6a 00                	push   $0x0
  pushl $152
80108724:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108729:	e9 c3 f2 ff ff       	jmp    801079f1 <alltraps>

8010872e <vector153>:
.globl vector153
vector153:
  pushl $0
8010872e:	6a 00                	push   $0x0
  pushl $153
80108730:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108735:	e9 b7 f2 ff ff       	jmp    801079f1 <alltraps>

8010873a <vector154>:
.globl vector154
vector154:
  pushl $0
8010873a:	6a 00                	push   $0x0
  pushl $154
8010873c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108741:	e9 ab f2 ff ff       	jmp    801079f1 <alltraps>

80108746 <vector155>:
.globl vector155
vector155:
  pushl $0
80108746:	6a 00                	push   $0x0
  pushl $155
80108748:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010874d:	e9 9f f2 ff ff       	jmp    801079f1 <alltraps>

80108752 <vector156>:
.globl vector156
vector156:
  pushl $0
80108752:	6a 00                	push   $0x0
  pushl $156
80108754:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108759:	e9 93 f2 ff ff       	jmp    801079f1 <alltraps>

8010875e <vector157>:
.globl vector157
vector157:
  pushl $0
8010875e:	6a 00                	push   $0x0
  pushl $157
80108760:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108765:	e9 87 f2 ff ff       	jmp    801079f1 <alltraps>

8010876a <vector158>:
.globl vector158
vector158:
  pushl $0
8010876a:	6a 00                	push   $0x0
  pushl $158
8010876c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108771:	e9 7b f2 ff ff       	jmp    801079f1 <alltraps>

80108776 <vector159>:
.globl vector159
vector159:
  pushl $0
80108776:	6a 00                	push   $0x0
  pushl $159
80108778:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010877d:	e9 6f f2 ff ff       	jmp    801079f1 <alltraps>

80108782 <vector160>:
.globl vector160
vector160:
  pushl $0
80108782:	6a 00                	push   $0x0
  pushl $160
80108784:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108789:	e9 63 f2 ff ff       	jmp    801079f1 <alltraps>

8010878e <vector161>:
.globl vector161
vector161:
  pushl $0
8010878e:	6a 00                	push   $0x0
  pushl $161
80108790:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108795:	e9 57 f2 ff ff       	jmp    801079f1 <alltraps>

8010879a <vector162>:
.globl vector162
vector162:
  pushl $0
8010879a:	6a 00                	push   $0x0
  pushl $162
8010879c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801087a1:	e9 4b f2 ff ff       	jmp    801079f1 <alltraps>

801087a6 <vector163>:
.globl vector163
vector163:
  pushl $0
801087a6:	6a 00                	push   $0x0
  pushl $163
801087a8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801087ad:	e9 3f f2 ff ff       	jmp    801079f1 <alltraps>

801087b2 <vector164>:
.globl vector164
vector164:
  pushl $0
801087b2:	6a 00                	push   $0x0
  pushl $164
801087b4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801087b9:	e9 33 f2 ff ff       	jmp    801079f1 <alltraps>

801087be <vector165>:
.globl vector165
vector165:
  pushl $0
801087be:	6a 00                	push   $0x0
  pushl $165
801087c0:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801087c5:	e9 27 f2 ff ff       	jmp    801079f1 <alltraps>

801087ca <vector166>:
.globl vector166
vector166:
  pushl $0
801087ca:	6a 00                	push   $0x0
  pushl $166
801087cc:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801087d1:	e9 1b f2 ff ff       	jmp    801079f1 <alltraps>

801087d6 <vector167>:
.globl vector167
vector167:
  pushl $0
801087d6:	6a 00                	push   $0x0
  pushl $167
801087d8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801087dd:	e9 0f f2 ff ff       	jmp    801079f1 <alltraps>

801087e2 <vector168>:
.globl vector168
vector168:
  pushl $0
801087e2:	6a 00                	push   $0x0
  pushl $168
801087e4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801087e9:	e9 03 f2 ff ff       	jmp    801079f1 <alltraps>

801087ee <vector169>:
.globl vector169
vector169:
  pushl $0
801087ee:	6a 00                	push   $0x0
  pushl $169
801087f0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801087f5:	e9 f7 f1 ff ff       	jmp    801079f1 <alltraps>

801087fa <vector170>:
.globl vector170
vector170:
  pushl $0
801087fa:	6a 00                	push   $0x0
  pushl $170
801087fc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108801:	e9 eb f1 ff ff       	jmp    801079f1 <alltraps>

80108806 <vector171>:
.globl vector171
vector171:
  pushl $0
80108806:	6a 00                	push   $0x0
  pushl $171
80108808:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010880d:	e9 df f1 ff ff       	jmp    801079f1 <alltraps>

80108812 <vector172>:
.globl vector172
vector172:
  pushl $0
80108812:	6a 00                	push   $0x0
  pushl $172
80108814:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108819:	e9 d3 f1 ff ff       	jmp    801079f1 <alltraps>

8010881e <vector173>:
.globl vector173
vector173:
  pushl $0
8010881e:	6a 00                	push   $0x0
  pushl $173
80108820:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108825:	e9 c7 f1 ff ff       	jmp    801079f1 <alltraps>

8010882a <vector174>:
.globl vector174
vector174:
  pushl $0
8010882a:	6a 00                	push   $0x0
  pushl $174
8010882c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108831:	e9 bb f1 ff ff       	jmp    801079f1 <alltraps>

80108836 <vector175>:
.globl vector175
vector175:
  pushl $0
80108836:	6a 00                	push   $0x0
  pushl $175
80108838:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010883d:	e9 af f1 ff ff       	jmp    801079f1 <alltraps>

80108842 <vector176>:
.globl vector176
vector176:
  pushl $0
80108842:	6a 00                	push   $0x0
  pushl $176
80108844:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108849:	e9 a3 f1 ff ff       	jmp    801079f1 <alltraps>

8010884e <vector177>:
.globl vector177
vector177:
  pushl $0
8010884e:	6a 00                	push   $0x0
  pushl $177
80108850:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108855:	e9 97 f1 ff ff       	jmp    801079f1 <alltraps>

8010885a <vector178>:
.globl vector178
vector178:
  pushl $0
8010885a:	6a 00                	push   $0x0
  pushl $178
8010885c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108861:	e9 8b f1 ff ff       	jmp    801079f1 <alltraps>

80108866 <vector179>:
.globl vector179
vector179:
  pushl $0
80108866:	6a 00                	push   $0x0
  pushl $179
80108868:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010886d:	e9 7f f1 ff ff       	jmp    801079f1 <alltraps>

80108872 <vector180>:
.globl vector180
vector180:
  pushl $0
80108872:	6a 00                	push   $0x0
  pushl $180
80108874:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108879:	e9 73 f1 ff ff       	jmp    801079f1 <alltraps>

8010887e <vector181>:
.globl vector181
vector181:
  pushl $0
8010887e:	6a 00                	push   $0x0
  pushl $181
80108880:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108885:	e9 67 f1 ff ff       	jmp    801079f1 <alltraps>

8010888a <vector182>:
.globl vector182
vector182:
  pushl $0
8010888a:	6a 00                	push   $0x0
  pushl $182
8010888c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108891:	e9 5b f1 ff ff       	jmp    801079f1 <alltraps>

80108896 <vector183>:
.globl vector183
vector183:
  pushl $0
80108896:	6a 00                	push   $0x0
  pushl $183
80108898:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010889d:	e9 4f f1 ff ff       	jmp    801079f1 <alltraps>

801088a2 <vector184>:
.globl vector184
vector184:
  pushl $0
801088a2:	6a 00                	push   $0x0
  pushl $184
801088a4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801088a9:	e9 43 f1 ff ff       	jmp    801079f1 <alltraps>

801088ae <vector185>:
.globl vector185
vector185:
  pushl $0
801088ae:	6a 00                	push   $0x0
  pushl $185
801088b0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801088b5:	e9 37 f1 ff ff       	jmp    801079f1 <alltraps>

801088ba <vector186>:
.globl vector186
vector186:
  pushl $0
801088ba:	6a 00                	push   $0x0
  pushl $186
801088bc:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801088c1:	e9 2b f1 ff ff       	jmp    801079f1 <alltraps>

801088c6 <vector187>:
.globl vector187
vector187:
  pushl $0
801088c6:	6a 00                	push   $0x0
  pushl $187
801088c8:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801088cd:	e9 1f f1 ff ff       	jmp    801079f1 <alltraps>

801088d2 <vector188>:
.globl vector188
vector188:
  pushl $0
801088d2:	6a 00                	push   $0x0
  pushl $188
801088d4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801088d9:	e9 13 f1 ff ff       	jmp    801079f1 <alltraps>

801088de <vector189>:
.globl vector189
vector189:
  pushl $0
801088de:	6a 00                	push   $0x0
  pushl $189
801088e0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801088e5:	e9 07 f1 ff ff       	jmp    801079f1 <alltraps>

801088ea <vector190>:
.globl vector190
vector190:
  pushl $0
801088ea:	6a 00                	push   $0x0
  pushl $190
801088ec:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801088f1:	e9 fb f0 ff ff       	jmp    801079f1 <alltraps>

801088f6 <vector191>:
.globl vector191
vector191:
  pushl $0
801088f6:	6a 00                	push   $0x0
  pushl $191
801088f8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801088fd:	e9 ef f0 ff ff       	jmp    801079f1 <alltraps>

80108902 <vector192>:
.globl vector192
vector192:
  pushl $0
80108902:	6a 00                	push   $0x0
  pushl $192
80108904:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108909:	e9 e3 f0 ff ff       	jmp    801079f1 <alltraps>

8010890e <vector193>:
.globl vector193
vector193:
  pushl $0
8010890e:	6a 00                	push   $0x0
  pushl $193
80108910:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108915:	e9 d7 f0 ff ff       	jmp    801079f1 <alltraps>

8010891a <vector194>:
.globl vector194
vector194:
  pushl $0
8010891a:	6a 00                	push   $0x0
  pushl $194
8010891c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108921:	e9 cb f0 ff ff       	jmp    801079f1 <alltraps>

80108926 <vector195>:
.globl vector195
vector195:
  pushl $0
80108926:	6a 00                	push   $0x0
  pushl $195
80108928:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010892d:	e9 bf f0 ff ff       	jmp    801079f1 <alltraps>

80108932 <vector196>:
.globl vector196
vector196:
  pushl $0
80108932:	6a 00                	push   $0x0
  pushl $196
80108934:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108939:	e9 b3 f0 ff ff       	jmp    801079f1 <alltraps>

8010893e <vector197>:
.globl vector197
vector197:
  pushl $0
8010893e:	6a 00                	push   $0x0
  pushl $197
80108940:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108945:	e9 a7 f0 ff ff       	jmp    801079f1 <alltraps>

8010894a <vector198>:
.globl vector198
vector198:
  pushl $0
8010894a:	6a 00                	push   $0x0
  pushl $198
8010894c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108951:	e9 9b f0 ff ff       	jmp    801079f1 <alltraps>

80108956 <vector199>:
.globl vector199
vector199:
  pushl $0
80108956:	6a 00                	push   $0x0
  pushl $199
80108958:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010895d:	e9 8f f0 ff ff       	jmp    801079f1 <alltraps>

80108962 <vector200>:
.globl vector200
vector200:
  pushl $0
80108962:	6a 00                	push   $0x0
  pushl $200
80108964:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108969:	e9 83 f0 ff ff       	jmp    801079f1 <alltraps>

8010896e <vector201>:
.globl vector201
vector201:
  pushl $0
8010896e:	6a 00                	push   $0x0
  pushl $201
80108970:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108975:	e9 77 f0 ff ff       	jmp    801079f1 <alltraps>

8010897a <vector202>:
.globl vector202
vector202:
  pushl $0
8010897a:	6a 00                	push   $0x0
  pushl $202
8010897c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108981:	e9 6b f0 ff ff       	jmp    801079f1 <alltraps>

80108986 <vector203>:
.globl vector203
vector203:
  pushl $0
80108986:	6a 00                	push   $0x0
  pushl $203
80108988:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010898d:	e9 5f f0 ff ff       	jmp    801079f1 <alltraps>

80108992 <vector204>:
.globl vector204
vector204:
  pushl $0
80108992:	6a 00                	push   $0x0
  pushl $204
80108994:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108999:	e9 53 f0 ff ff       	jmp    801079f1 <alltraps>

8010899e <vector205>:
.globl vector205
vector205:
  pushl $0
8010899e:	6a 00                	push   $0x0
  pushl $205
801089a0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801089a5:	e9 47 f0 ff ff       	jmp    801079f1 <alltraps>

801089aa <vector206>:
.globl vector206
vector206:
  pushl $0
801089aa:	6a 00                	push   $0x0
  pushl $206
801089ac:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801089b1:	e9 3b f0 ff ff       	jmp    801079f1 <alltraps>

801089b6 <vector207>:
.globl vector207
vector207:
  pushl $0
801089b6:	6a 00                	push   $0x0
  pushl $207
801089b8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801089bd:	e9 2f f0 ff ff       	jmp    801079f1 <alltraps>

801089c2 <vector208>:
.globl vector208
vector208:
  pushl $0
801089c2:	6a 00                	push   $0x0
  pushl $208
801089c4:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801089c9:	e9 23 f0 ff ff       	jmp    801079f1 <alltraps>

801089ce <vector209>:
.globl vector209
vector209:
  pushl $0
801089ce:	6a 00                	push   $0x0
  pushl $209
801089d0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801089d5:	e9 17 f0 ff ff       	jmp    801079f1 <alltraps>

801089da <vector210>:
.globl vector210
vector210:
  pushl $0
801089da:	6a 00                	push   $0x0
  pushl $210
801089dc:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801089e1:	e9 0b f0 ff ff       	jmp    801079f1 <alltraps>

801089e6 <vector211>:
.globl vector211
vector211:
  pushl $0
801089e6:	6a 00                	push   $0x0
  pushl $211
801089e8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801089ed:	e9 ff ef ff ff       	jmp    801079f1 <alltraps>

801089f2 <vector212>:
.globl vector212
vector212:
  pushl $0
801089f2:	6a 00                	push   $0x0
  pushl $212
801089f4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801089f9:	e9 f3 ef ff ff       	jmp    801079f1 <alltraps>

801089fe <vector213>:
.globl vector213
vector213:
  pushl $0
801089fe:	6a 00                	push   $0x0
  pushl $213
80108a00:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108a05:	e9 e7 ef ff ff       	jmp    801079f1 <alltraps>

80108a0a <vector214>:
.globl vector214
vector214:
  pushl $0
80108a0a:	6a 00                	push   $0x0
  pushl $214
80108a0c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108a11:	e9 db ef ff ff       	jmp    801079f1 <alltraps>

80108a16 <vector215>:
.globl vector215
vector215:
  pushl $0
80108a16:	6a 00                	push   $0x0
  pushl $215
80108a18:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108a1d:	e9 cf ef ff ff       	jmp    801079f1 <alltraps>

80108a22 <vector216>:
.globl vector216
vector216:
  pushl $0
80108a22:	6a 00                	push   $0x0
  pushl $216
80108a24:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108a29:	e9 c3 ef ff ff       	jmp    801079f1 <alltraps>

80108a2e <vector217>:
.globl vector217
vector217:
  pushl $0
80108a2e:	6a 00                	push   $0x0
  pushl $217
80108a30:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108a35:	e9 b7 ef ff ff       	jmp    801079f1 <alltraps>

80108a3a <vector218>:
.globl vector218
vector218:
  pushl $0
80108a3a:	6a 00                	push   $0x0
  pushl $218
80108a3c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108a41:	e9 ab ef ff ff       	jmp    801079f1 <alltraps>

80108a46 <vector219>:
.globl vector219
vector219:
  pushl $0
80108a46:	6a 00                	push   $0x0
  pushl $219
80108a48:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108a4d:	e9 9f ef ff ff       	jmp    801079f1 <alltraps>

80108a52 <vector220>:
.globl vector220
vector220:
  pushl $0
80108a52:	6a 00                	push   $0x0
  pushl $220
80108a54:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108a59:	e9 93 ef ff ff       	jmp    801079f1 <alltraps>

80108a5e <vector221>:
.globl vector221
vector221:
  pushl $0
80108a5e:	6a 00                	push   $0x0
  pushl $221
80108a60:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108a65:	e9 87 ef ff ff       	jmp    801079f1 <alltraps>

80108a6a <vector222>:
.globl vector222
vector222:
  pushl $0
80108a6a:	6a 00                	push   $0x0
  pushl $222
80108a6c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108a71:	e9 7b ef ff ff       	jmp    801079f1 <alltraps>

80108a76 <vector223>:
.globl vector223
vector223:
  pushl $0
80108a76:	6a 00                	push   $0x0
  pushl $223
80108a78:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108a7d:	e9 6f ef ff ff       	jmp    801079f1 <alltraps>

80108a82 <vector224>:
.globl vector224
vector224:
  pushl $0
80108a82:	6a 00                	push   $0x0
  pushl $224
80108a84:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108a89:	e9 63 ef ff ff       	jmp    801079f1 <alltraps>

80108a8e <vector225>:
.globl vector225
vector225:
  pushl $0
80108a8e:	6a 00                	push   $0x0
  pushl $225
80108a90:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108a95:	e9 57 ef ff ff       	jmp    801079f1 <alltraps>

80108a9a <vector226>:
.globl vector226
vector226:
  pushl $0
80108a9a:	6a 00                	push   $0x0
  pushl $226
80108a9c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108aa1:	e9 4b ef ff ff       	jmp    801079f1 <alltraps>

80108aa6 <vector227>:
.globl vector227
vector227:
  pushl $0
80108aa6:	6a 00                	push   $0x0
  pushl $227
80108aa8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108aad:	e9 3f ef ff ff       	jmp    801079f1 <alltraps>

80108ab2 <vector228>:
.globl vector228
vector228:
  pushl $0
80108ab2:	6a 00                	push   $0x0
  pushl $228
80108ab4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108ab9:	e9 33 ef ff ff       	jmp    801079f1 <alltraps>

80108abe <vector229>:
.globl vector229
vector229:
  pushl $0
80108abe:	6a 00                	push   $0x0
  pushl $229
80108ac0:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108ac5:	e9 27 ef ff ff       	jmp    801079f1 <alltraps>

80108aca <vector230>:
.globl vector230
vector230:
  pushl $0
80108aca:	6a 00                	push   $0x0
  pushl $230
80108acc:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108ad1:	e9 1b ef ff ff       	jmp    801079f1 <alltraps>

80108ad6 <vector231>:
.globl vector231
vector231:
  pushl $0
80108ad6:	6a 00                	push   $0x0
  pushl $231
80108ad8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108add:	e9 0f ef ff ff       	jmp    801079f1 <alltraps>

80108ae2 <vector232>:
.globl vector232
vector232:
  pushl $0
80108ae2:	6a 00                	push   $0x0
  pushl $232
80108ae4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108ae9:	e9 03 ef ff ff       	jmp    801079f1 <alltraps>

80108aee <vector233>:
.globl vector233
vector233:
  pushl $0
80108aee:	6a 00                	push   $0x0
  pushl $233
80108af0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80108af5:	e9 f7 ee ff ff       	jmp    801079f1 <alltraps>

80108afa <vector234>:
.globl vector234
vector234:
  pushl $0
80108afa:	6a 00                	push   $0x0
  pushl $234
80108afc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108b01:	e9 eb ee ff ff       	jmp    801079f1 <alltraps>

80108b06 <vector235>:
.globl vector235
vector235:
  pushl $0
80108b06:	6a 00                	push   $0x0
  pushl $235
80108b08:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108b0d:	e9 df ee ff ff       	jmp    801079f1 <alltraps>

80108b12 <vector236>:
.globl vector236
vector236:
  pushl $0
80108b12:	6a 00                	push   $0x0
  pushl $236
80108b14:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108b19:	e9 d3 ee ff ff       	jmp    801079f1 <alltraps>

80108b1e <vector237>:
.globl vector237
vector237:
  pushl $0
80108b1e:	6a 00                	push   $0x0
  pushl $237
80108b20:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80108b25:	e9 c7 ee ff ff       	jmp    801079f1 <alltraps>

80108b2a <vector238>:
.globl vector238
vector238:
  pushl $0
80108b2a:	6a 00                	push   $0x0
  pushl $238
80108b2c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80108b31:	e9 bb ee ff ff       	jmp    801079f1 <alltraps>

80108b36 <vector239>:
.globl vector239
vector239:
  pushl $0
80108b36:	6a 00                	push   $0x0
  pushl $239
80108b38:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108b3d:	e9 af ee ff ff       	jmp    801079f1 <alltraps>

80108b42 <vector240>:
.globl vector240
vector240:
  pushl $0
80108b42:	6a 00                	push   $0x0
  pushl $240
80108b44:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108b49:	e9 a3 ee ff ff       	jmp    801079f1 <alltraps>

80108b4e <vector241>:
.globl vector241
vector241:
  pushl $0
80108b4e:	6a 00                	push   $0x0
  pushl $241
80108b50:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108b55:	e9 97 ee ff ff       	jmp    801079f1 <alltraps>

80108b5a <vector242>:
.globl vector242
vector242:
  pushl $0
80108b5a:	6a 00                	push   $0x0
  pushl $242
80108b5c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108b61:	e9 8b ee ff ff       	jmp    801079f1 <alltraps>

80108b66 <vector243>:
.globl vector243
vector243:
  pushl $0
80108b66:	6a 00                	push   $0x0
  pushl $243
80108b68:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108b6d:	e9 7f ee ff ff       	jmp    801079f1 <alltraps>

80108b72 <vector244>:
.globl vector244
vector244:
  pushl $0
80108b72:	6a 00                	push   $0x0
  pushl $244
80108b74:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108b79:	e9 73 ee ff ff       	jmp    801079f1 <alltraps>

80108b7e <vector245>:
.globl vector245
vector245:
  pushl $0
80108b7e:	6a 00                	push   $0x0
  pushl $245
80108b80:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108b85:	e9 67 ee ff ff       	jmp    801079f1 <alltraps>

80108b8a <vector246>:
.globl vector246
vector246:
  pushl $0
80108b8a:	6a 00                	push   $0x0
  pushl $246
80108b8c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108b91:	e9 5b ee ff ff       	jmp    801079f1 <alltraps>

80108b96 <vector247>:
.globl vector247
vector247:
  pushl $0
80108b96:	6a 00                	push   $0x0
  pushl $247
80108b98:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108b9d:	e9 4f ee ff ff       	jmp    801079f1 <alltraps>

80108ba2 <vector248>:
.globl vector248
vector248:
  pushl $0
80108ba2:	6a 00                	push   $0x0
  pushl $248
80108ba4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108ba9:	e9 43 ee ff ff       	jmp    801079f1 <alltraps>

80108bae <vector249>:
.globl vector249
vector249:
  pushl $0
80108bae:	6a 00                	push   $0x0
  pushl $249
80108bb0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108bb5:	e9 37 ee ff ff       	jmp    801079f1 <alltraps>

80108bba <vector250>:
.globl vector250
vector250:
  pushl $0
80108bba:	6a 00                	push   $0x0
  pushl $250
80108bbc:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108bc1:	e9 2b ee ff ff       	jmp    801079f1 <alltraps>

80108bc6 <vector251>:
.globl vector251
vector251:
  pushl $0
80108bc6:	6a 00                	push   $0x0
  pushl $251
80108bc8:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108bcd:	e9 1f ee ff ff       	jmp    801079f1 <alltraps>

80108bd2 <vector252>:
.globl vector252
vector252:
  pushl $0
80108bd2:	6a 00                	push   $0x0
  pushl $252
80108bd4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108bd9:	e9 13 ee ff ff       	jmp    801079f1 <alltraps>

80108bde <vector253>:
.globl vector253
vector253:
  pushl $0
80108bde:	6a 00                	push   $0x0
  pushl $253
80108be0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108be5:	e9 07 ee ff ff       	jmp    801079f1 <alltraps>

80108bea <vector254>:
.globl vector254
vector254:
  pushl $0
80108bea:	6a 00                	push   $0x0
  pushl $254
80108bec:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108bf1:	e9 fb ed ff ff       	jmp    801079f1 <alltraps>

80108bf6 <vector255>:
.globl vector255
vector255:
  pushl $0
80108bf6:	6a 00                	push   $0x0
  pushl $255
80108bf8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108bfd:	e9 ef ed ff ff       	jmp    801079f1 <alltraps>

80108c02 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108c02:	55                   	push   %ebp
80108c03:	89 e5                	mov    %esp,%ebp
80108c05:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c0b:	83 e8 01             	sub    $0x1,%eax
80108c0e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108c12:	8b 45 08             	mov    0x8(%ebp),%eax
80108c15:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108c19:	8b 45 08             	mov    0x8(%ebp),%eax
80108c1c:	c1 e8 10             	shr    $0x10,%eax
80108c1f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108c23:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108c26:	0f 01 10             	lgdtl  (%eax)
}
80108c29:	c9                   	leave  
80108c2a:	c3                   	ret    

80108c2b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108c2b:	55                   	push   %ebp
80108c2c:	89 e5                	mov    %esp,%ebp
80108c2e:	83 ec 04             	sub    $0x4,%esp
80108c31:	8b 45 08             	mov    0x8(%ebp),%eax
80108c34:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108c38:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108c3c:	0f 00 d8             	ltr    %ax
}
80108c3f:	c9                   	leave  
80108c40:	c3                   	ret    

80108c41 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108c41:	55                   	push   %ebp
80108c42:	89 e5                	mov    %esp,%ebp
80108c44:	83 ec 04             	sub    $0x4,%esp
80108c47:	8b 45 08             	mov    0x8(%ebp),%eax
80108c4a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108c4e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108c52:	8e e8                	mov    %eax,%gs
}
80108c54:	c9                   	leave  
80108c55:	c3                   	ret    

80108c56 <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80108c56:	55                   	push   %ebp
80108c57:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108c59:	8b 45 08             	mov    0x8(%ebp),%eax
80108c5c:	0f 22 d8             	mov    %eax,%cr3
}
80108c5f:	5d                   	pop    %ebp
80108c60:	c3                   	ret    

80108c61 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108c61:	55                   	push   %ebp
80108c62:	89 e5                	mov    %esp,%ebp
80108c64:	53                   	push   %ebx
80108c65:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108c68:	e8 ec a4 ff ff       	call   80103159 <cpunum>
80108c6d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108c73:	05 40 58 11 80       	add    $0x80115840,%eax
80108c78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c87:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c90:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c97:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108c9b:	83 e2 f0             	and    $0xfffffff0,%edx
80108c9e:	83 ca 0a             	or     $0xa,%edx
80108ca1:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108cab:	83 ca 10             	or     $0x10,%edx
80108cae:	88 50 7d             	mov    %dl,0x7d(%eax)
80108cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb4:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108cb8:	83 e2 9f             	and    $0xffffff9f,%edx
80108cbb:	88 50 7d             	mov    %dl,0x7d(%eax)
80108cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108cc5:	83 ca 80             	or     $0xffffff80,%edx
80108cc8:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cce:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cd2:	83 ca 0f             	or     $0xf,%edx
80108cd5:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cdb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cdf:	83 e2 ef             	and    $0xffffffef,%edx
80108ce2:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cec:	83 e2 df             	and    $0xffffffdf,%edx
80108cef:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108cf9:	83 ca 40             	or     $0x40,%edx
80108cfc:	88 50 7e             	mov    %dl,0x7e(%eax)
80108cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d02:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108d06:	83 ca 80             	or     $0xffffff80,%edx
80108d09:	88 50 7e             	mov    %dl,0x7e(%eax)
80108d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d0f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d16:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108d1d:	ff ff 
80108d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d22:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108d29:	00 00 
80108d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d38:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d3f:	83 e2 f0             	and    $0xfffffff0,%edx
80108d42:	83 ca 02             	or     $0x2,%edx
80108d45:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d4e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d55:	83 ca 10             	or     $0x10,%edx
80108d58:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d61:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d68:	83 e2 9f             	and    $0xffffff9f,%edx
80108d6b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d74:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108d7b:	83 ca 80             	or     $0xffffff80,%edx
80108d7e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d87:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108d8e:	83 ca 0f             	or     $0xf,%edx
80108d91:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108da1:	83 e2 ef             	and    $0xffffffef,%edx
80108da4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dad:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108db4:	83 e2 df             	and    $0xffffffdf,%edx
80108db7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108dc7:	83 ca 40             	or     $0x40,%edx
80108dca:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108dda:	83 ca 80             	or     $0xffffff80,%edx
80108ddd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de6:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df0:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108df7:	ff ff 
80108df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dfc:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108e03:	00 00 
80108e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e08:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e12:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e19:	83 e2 f0             	and    $0xfffffff0,%edx
80108e1c:	83 ca 0a             	or     $0xa,%edx
80108e1f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e28:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e2f:	83 ca 10             	or     $0x10,%edx
80108e32:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e42:	83 ca 60             	or     $0x60,%edx
80108e45:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e4e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108e55:	83 ca 80             	or     $0xffffff80,%edx
80108e58:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e61:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e68:	83 ca 0f             	or     $0xf,%edx
80108e6b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e74:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e7b:	83 e2 ef             	and    $0xffffffef,%edx
80108e7e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e87:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108e8e:	83 e2 df             	and    $0xffffffdf,%edx
80108e91:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e9a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108ea1:	83 ca 40             	or     $0x40,%edx
80108ea4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ead:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108eb4:	83 ca 80             	or     $0xffffff80,%edx
80108eb7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ec0:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eca:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108ed1:	ff ff 
80108ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed6:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108edd:	00 00 
80108edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ee2:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eec:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ef3:	83 e2 f0             	and    $0xfffffff0,%edx
80108ef6:	83 ca 02             	or     $0x2,%edx
80108ef9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f02:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108f09:	83 ca 10             	or     $0x10,%edx
80108f0c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f15:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108f1c:	83 ca 60             	or     $0x60,%edx
80108f1f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f28:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108f2f:	83 ca 80             	or     $0xffffff80,%edx
80108f32:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f3b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f42:	83 ca 0f             	or     $0xf,%edx
80108f45:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f4e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f55:	83 e2 ef             	and    $0xffffffef,%edx
80108f58:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f61:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f68:	83 e2 df             	and    $0xffffffdf,%edx
80108f6b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f74:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f7b:	83 ca 40             	or     $0x40,%edx
80108f7e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f87:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108f8e:	83 ca 80             	or     $0xffffff80,%edx
80108f91:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f9a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa4:	05 b4 00 00 00       	add    $0xb4,%eax
80108fa9:	89 c3                	mov    %eax,%ebx
80108fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fae:	05 b4 00 00 00       	add    $0xb4,%eax
80108fb3:	c1 e8 10             	shr    $0x10,%eax
80108fb6:	89 c1                	mov    %eax,%ecx
80108fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fbb:	05 b4 00 00 00       	add    $0xb4,%eax
80108fc0:	c1 e8 18             	shr    $0x18,%eax
80108fc3:	89 c2                	mov    %eax,%edx
80108fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fc8:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108fcf:	00 00 
80108fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd4:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fde:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108fee:	83 e1 f0             	and    $0xfffffff0,%ecx
80108ff1:	83 c9 02             	or     $0x2,%ecx
80108ff4:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ffd:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80109004:	83 c9 10             	or     $0x10,%ecx
80109007:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010900d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109010:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80109017:	83 e1 9f             	and    $0xffffff9f,%ecx
8010901a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80109020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109023:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010902a:	83 c9 80             	or     $0xffffff80,%ecx
8010902d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80109033:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109036:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010903d:	83 e1 f0             	and    $0xfffffff0,%ecx
80109040:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80109046:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109049:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80109050:	83 e1 ef             	and    $0xffffffef,%ecx
80109053:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80109059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010905c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80109063:	83 e1 df             	and    $0xffffffdf,%ecx
80109066:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010906c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010906f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80109076:	83 c9 40             	or     $0x40,%ecx
80109079:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010907f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109082:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80109089:	83 c9 80             	or     $0xffffff80,%ecx
8010908c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80109092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109095:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010909b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909e:	83 c0 70             	add    $0x70,%eax
801090a1:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801090a8:	00 
801090a9:	89 04 24             	mov    %eax,(%esp)
801090ac:	e8 51 fb ff ff       	call   80108c02 <lgdt>
  loadgs(SEG_KCPU << 3);
801090b1:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801090b8:	e8 84 fb ff ff       	call   80108c41 <loadgs>

  // Initialize cpu-local storage.
  cpu = c;
801090bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090c0:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801090c6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801090cd:	00 00 00 00 
}
801090d1:	83 c4 24             	add    $0x24,%esp
801090d4:	5b                   	pop    %ebx
801090d5:	5d                   	pop    %ebp
801090d6:	c3                   	ret    

801090d7 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801090d7:	55                   	push   %ebp
801090d8:	89 e5                	mov    %esp,%ebp
801090da:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)]; //page directory entry
801090dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801090e0:	c1 e8 16             	shr    $0x16,%eax
801090e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801090ea:	8b 45 08             	mov    0x8(%ebp),%eax
801090ed:	01 d0                	add    %edx,%eax
801090ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801090f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090f5:	8b 00                	mov    (%eax),%eax
801090f7:	83 e0 01             	and    $0x1,%eax
801090fa:	85 c0                	test   %eax,%eax
801090fc:	74 14                	je     80109112 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801090fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109101:	8b 00                	mov    (%eax),%eax
80109103:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109108:	05 00 00 00 80       	add    $0x80000000,%eax
8010910d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109110:	eb 48                	jmp    8010915a <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109116:	74 0e                	je     80109126 <walkpgdir+0x4f>
80109118:	e8 a6 9c ff ff       	call   80102dc3 <kalloc>
8010911d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109120:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109124:	75 07                	jne    8010912d <walkpgdir+0x56>
      return 0;
80109126:	b8 00 00 00 00       	mov    $0x0,%eax
8010912b:	eb 44                	jmp    80109171 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010912d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109134:	00 
80109135:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010913c:	00 
8010913d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109140:	89 04 24             	mov    %eax,(%esp)
80109143:	e8 27 d3 ff ff       	call   8010646f <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80109148:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010914b:	05 00 00 00 80       	add    $0x80000000,%eax
80109150:	83 c8 07             	or     $0x7,%eax
80109153:	89 c2                	mov    %eax,%edx
80109155:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109158:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010915a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010915d:	c1 e8 0c             	shr    $0xc,%eax
80109160:	25 ff 03 00 00       	and    $0x3ff,%eax
80109165:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010916c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010916f:	01 d0                	add    %edx,%eax
}
80109171:	c9                   	leave  
80109172:	c3                   	ret    

80109173 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109173:	55                   	push   %ebp
80109174:	89 e5                	mov    %esp,%ebp
80109176:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80109179:	8b 45 0c             	mov    0xc(%ebp),%eax
8010917c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109184:	8b 55 0c             	mov    0xc(%ebp),%edx
80109187:	8b 45 10             	mov    0x10(%ebp),%eax
8010918a:	01 d0                	add    %edx,%eax
8010918c:	83 e8 01             	sub    $0x1,%eax
8010918f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109194:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109197:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010919e:	00 
8010919f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801091a6:	8b 45 08             	mov    0x8(%ebp),%eax
801091a9:	89 04 24             	mov    %eax,(%esp)
801091ac:	e8 26 ff ff ff       	call   801090d7 <walkpgdir>
801091b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801091b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801091b8:	75 07                	jne    801091c1 <mappages+0x4e>
      return -1;
801091ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801091bf:	eb 48                	jmp    80109209 <mappages+0x96>
    if(*pte & PTE_P)
801091c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091c4:	8b 00                	mov    (%eax),%eax
801091c6:	83 e0 01             	and    $0x1,%eax
801091c9:	85 c0                	test   %eax,%eax
801091cb:	74 0c                	je     801091d9 <mappages+0x66>
      panic("remap");
801091cd:	c7 04 24 24 a1 10 80 	movl   $0x8010a124,(%esp)
801091d4:	e8 89 73 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
801091d9:	8b 45 18             	mov    0x18(%ebp),%eax
801091dc:	0b 45 14             	or     0x14(%ebp),%eax
801091df:	83 c8 01             	or     $0x1,%eax
801091e2:	89 c2                	mov    %eax,%edx
801091e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801091e7:	89 10                	mov    %edx,(%eax)
    if(a == last)
801091e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801091ef:	75 08                	jne    801091f9 <mappages+0x86>
      break;
801091f1:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801091f2:	b8 00 00 00 00       	mov    $0x0,%eax
801091f7:	eb 10                	jmp    80109209 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801091f9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109200:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109207:	eb 8e                	jmp    80109197 <mappages+0x24>
  return 0;
}
80109209:	c9                   	leave  
8010920a:	c3                   	ret    

8010920b <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010920b:	55                   	push   %ebp
8010920c:	89 e5                	mov    %esp,%ebp
8010920e:	53                   	push   %ebx
8010920f:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109212:	e8 ac 9b ff ff       	call   80102dc3 <kalloc>
80109217:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010921a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010921e:	75 07                	jne    80109227 <setupkvm+0x1c>
    return 0;
80109220:	b8 00 00 00 00       	mov    $0x0,%eax
80109225:	eb 79                	jmp    801092a0 <setupkvm+0x95>
  memset(pgdir, 0, PGSIZE);
80109227:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010922e:	00 
8010922f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80109236:	00 
80109237:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010923a:	89 04 24             	mov    %eax,(%esp)
8010923d:	e8 2d d2 ff ff       	call   8010646f <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109242:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80109249:	eb 49                	jmp    80109294 <setupkvm+0x89>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010924b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924e:	8b 48 0c             	mov    0xc(%eax),%ecx
80109251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109254:	8b 50 04             	mov    0x4(%eax),%edx
80109257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010925a:	8b 58 08             	mov    0x8(%eax),%ebx
8010925d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109260:	8b 40 04             	mov    0x4(%eax),%eax
80109263:	29 c3                	sub    %eax,%ebx
80109265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109268:	8b 00                	mov    (%eax),%eax
8010926a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010926e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80109272:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80109276:	89 44 24 04          	mov    %eax,0x4(%esp)
8010927a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010927d:	89 04 24             	mov    %eax,(%esp)
80109280:	e8 ee fe ff ff       	call   80109173 <mappages>
80109285:	85 c0                	test   %eax,%eax
80109287:	79 07                	jns    80109290 <setupkvm+0x85>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109289:	b8 00 00 00 00       	mov    $0x0,%eax
8010928e:	eb 10                	jmp    801092a0 <setupkvm+0x95>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109290:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109294:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
8010929b:	72 ae                	jb     8010924b <setupkvm+0x40>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010929d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801092a0:	83 c4 34             	add    $0x34,%esp
801092a3:	5b                   	pop    %ebx
801092a4:	5d                   	pop    %ebp
801092a5:	c3                   	ret    

801092a6 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801092a6:	55                   	push   %ebp
801092a7:	89 e5                	mov    %esp,%ebp
801092a9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801092ac:	e8 5a ff ff ff       	call   8010920b <setupkvm>
801092b1:	a3 24 d3 11 80       	mov    %eax,0x8011d324
  switchkvm();
801092b6:	e8 02 00 00 00       	call   801092bd <switchkvm>
}
801092bb:	c9                   	leave  
801092bc:	c3                   	ret    

801092bd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801092bd:	55                   	push   %ebp
801092be:	89 e5                	mov    %esp,%ebp
801092c0:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801092c3:	a1 24 d3 11 80       	mov    0x8011d324,%eax
801092c8:	05 00 00 00 80       	add    $0x80000000,%eax
801092cd:	89 04 24             	mov    %eax,(%esp)
801092d0:	e8 81 f9 ff ff       	call   80108c56 <lcr3>
}
801092d5:	c9                   	leave  
801092d6:	c3                   	ret    

801092d7 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801092d7:	55                   	push   %ebp
801092d8:	89 e5                	mov    %esp,%ebp
801092da:	53                   	push   %ebx
801092db:	83 ec 14             	sub    $0x14,%esp
  if(p == 0)
801092de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801092e2:	75 0c                	jne    801092f0 <switchuvm+0x19>
    panic("switchuvm: no process");
801092e4:	c7 04 24 2a a1 10 80 	movl   $0x8010a12a,(%esp)
801092eb:	e8 72 72 ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
801092f0:	8b 45 08             	mov    0x8(%ebp),%eax
801092f3:	8b 40 08             	mov    0x8(%eax),%eax
801092f6:	85 c0                	test   %eax,%eax
801092f8:	75 0c                	jne    80109306 <switchuvm+0x2f>
    panic("switchuvm: no kstack");
801092fa:	c7 04 24 40 a1 10 80 	movl   $0x8010a140,(%esp)
80109301:	e8 5c 72 ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
80109306:	8b 45 08             	mov    0x8(%ebp),%eax
80109309:	8b 40 04             	mov    0x4(%eax),%eax
8010930c:	85 c0                	test   %eax,%eax
8010930e:	75 0c                	jne    8010931c <switchuvm+0x45>
    panic("switchuvm: no pgdir");
80109310:	c7 04 24 55 a1 10 80 	movl   $0x8010a155,(%esp)
80109317:	e8 46 72 ff ff       	call   80100562 <panic>

  pushcli();
8010931c:	e8 3c d0 ff ff       	call   8010635d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109321:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109327:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010932e:	83 c2 08             	add    $0x8,%edx
80109331:	89 d3                	mov    %edx,%ebx
80109333:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010933a:	83 c2 08             	add    $0x8,%edx
8010933d:	c1 ea 10             	shr    $0x10,%edx
80109340:	89 d1                	mov    %edx,%ecx
80109342:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109349:	83 c2 08             	add    $0x8,%edx
8010934c:	c1 ea 18             	shr    $0x18,%edx
8010934f:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109356:	67 00 
80109358:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
8010935f:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80109365:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010936c:	83 e1 f0             	and    $0xfffffff0,%ecx
8010936f:	83 c9 09             	or     $0x9,%ecx
80109372:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80109378:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010937f:	83 c9 10             	or     $0x10,%ecx
80109382:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80109388:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010938f:	83 e1 9f             	and    $0xffffff9f,%ecx
80109392:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80109398:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010939f:	83 c9 80             	or     $0xffffff80,%ecx
801093a2:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
801093a8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801093af:	83 e1 f0             	and    $0xfffffff0,%ecx
801093b2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801093b8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801093bf:	83 e1 ef             	and    $0xffffffef,%ecx
801093c2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801093c8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801093cf:	83 e1 df             	and    $0xffffffdf,%ecx
801093d2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801093d8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801093df:	83 c9 40             	or     $0x40,%ecx
801093e2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801093e8:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801093ef:	83 e1 7f             	and    $0x7f,%ecx
801093f2:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801093f8:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801093fe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109404:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010940b:	83 e2 ef             	and    $0xffffffef,%edx
8010940e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109414:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010941a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80109420:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109426:	8b 55 08             	mov    0x8(%ebp),%edx
80109429:	8b 52 08             	mov    0x8(%edx),%edx
8010942c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109432:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80109435:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010943b:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80109441:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80109448:	e8 de f7 ff ff       	call   80108c2b <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010944d:	8b 45 08             	mov    0x8(%ebp),%eax
80109450:	8b 40 04             	mov    0x4(%eax),%eax
80109453:	05 00 00 00 80       	add    $0x80000000,%eax
80109458:	89 04 24             	mov    %eax,(%esp)
8010945b:	e8 f6 f7 ff ff       	call   80108c56 <lcr3>
  popcli();
80109460:	e8 4e cf ff ff       	call   801063b3 <popcli>
}
80109465:	83 c4 14             	add    $0x14,%esp
80109468:	5b                   	pop    %ebx
80109469:	5d                   	pop    %ebp
8010946a:	c3                   	ret    

8010946b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010946b:	55                   	push   %ebp
8010946c:	89 e5                	mov    %esp,%ebp
8010946e:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80109471:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109478:	76 0c                	jbe    80109486 <inituvm+0x1b>
    panic("inituvm: more than a page");
8010947a:	c7 04 24 69 a1 10 80 	movl   $0x8010a169,(%esp)
80109481:	e8 dc 70 ff ff       	call   80100562 <panic>
  mem = kalloc();
80109486:	e8 38 99 ff ff       	call   80102dc3 <kalloc>
8010948b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010948e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109495:	00 
80109496:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010949d:	00 
8010949e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a1:	89 04 24             	mov    %eax,(%esp)
801094a4:	e8 c6 cf ff ff       	call   8010646f <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801094a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ac:	05 00 00 00 80       	add    $0x80000000,%eax
801094b1:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801094b8:	00 
801094b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
801094bd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801094c4:	00 
801094c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801094cc:	00 
801094cd:	8b 45 08             	mov    0x8(%ebp),%eax
801094d0:	89 04 24             	mov    %eax,(%esp)
801094d3:	e8 9b fc ff ff       	call   80109173 <mappages>
  memmove(mem, init, sz);
801094d8:	8b 45 10             	mov    0x10(%ebp),%eax
801094db:	89 44 24 08          	mov    %eax,0x8(%esp)
801094df:	8b 45 0c             	mov    0xc(%ebp),%eax
801094e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801094e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e9:	89 04 24             	mov    %eax,(%esp)
801094ec:	e8 4d d0 ff ff       	call   8010653e <memmove>
}
801094f1:	c9                   	leave  
801094f2:	c3                   	ret    

801094f3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801094f3:	55                   	push   %ebp
801094f4:	89 e5                	mov    %esp,%ebp
801094f6:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801094f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801094fc:	25 ff 0f 00 00       	and    $0xfff,%eax
80109501:	85 c0                	test   %eax,%eax
80109503:	74 0c                	je     80109511 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80109505:	c7 04 24 84 a1 10 80 	movl   $0x8010a184,(%esp)
8010950c:	e8 51 70 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109518:	e9 a6 00 00 00       	jmp    801095c3 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010951d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109520:	8b 55 0c             	mov    0xc(%ebp),%edx
80109523:	01 d0                	add    %edx,%eax
80109525:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010952c:	00 
8010952d:	89 44 24 04          	mov    %eax,0x4(%esp)
80109531:	8b 45 08             	mov    0x8(%ebp),%eax
80109534:	89 04 24             	mov    %eax,(%esp)
80109537:	e8 9b fb ff ff       	call   801090d7 <walkpgdir>
8010953c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010953f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109543:	75 0c                	jne    80109551 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80109545:	c7 04 24 a7 a1 10 80 	movl   $0x8010a1a7,(%esp)
8010954c:	e8 11 70 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80109551:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109554:	8b 00                	mov    (%eax),%eax
80109556:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010955b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010955e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109561:	8b 55 18             	mov    0x18(%ebp),%edx
80109564:	29 c2                	sub    %eax,%edx
80109566:	89 d0                	mov    %edx,%eax
80109568:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010956d:	77 0f                	ja     8010957e <loaduvm+0x8b>
      n = sz - i;
8010956f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109572:	8b 55 18             	mov    0x18(%ebp),%edx
80109575:	29 c2                	sub    %eax,%edx
80109577:	89 d0                	mov    %edx,%eax
80109579:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010957c:	eb 07                	jmp    80109585 <loaduvm+0x92>
    else
      n = PGSIZE;
8010957e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80109585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109588:	8b 55 14             	mov    0x14(%ebp),%edx
8010958b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010958e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109591:	05 00 00 00 80       	add    $0x80000000,%eax
80109596:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109599:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010959d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801095a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801095a5:	8b 45 10             	mov    0x10(%ebp),%eax
801095a8:	89 04 24             	mov    %eax,(%esp)
801095ab:	e8 3e 8a ff ff       	call   80101fee <readi>
801095b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801095b3:	74 07                	je     801095bc <loaduvm+0xc9>
      return -1;
801095b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801095ba:	eb 18                	jmp    801095d4 <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801095bc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801095c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c6:	3b 45 18             	cmp    0x18(%ebp),%eax
801095c9:	0f 82 4e ff ff ff    	jb     8010951d <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801095cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801095d4:	c9                   	leave  
801095d5:	c3                   	ret    

801095d6 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801095d6:	55                   	push   %ebp
801095d7:	89 e5                	mov    %esp,%ebp
801095d9:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801095dc:	8b 45 10             	mov    0x10(%ebp),%eax
801095df:	85 c0                	test   %eax,%eax
801095e1:	79 0a                	jns    801095ed <allocuvm+0x17>
    return 0;
801095e3:	b8 00 00 00 00       	mov    $0x0,%eax
801095e8:	e9 fd 00 00 00       	jmp    801096ea <allocuvm+0x114>
  if(newsz < oldsz)
801095ed:	8b 45 10             	mov    0x10(%ebp),%eax
801095f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801095f3:	73 08                	jae    801095fd <allocuvm+0x27>
    return oldsz;
801095f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801095f8:	e9 ed 00 00 00       	jmp    801096ea <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
801095fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80109600:	05 ff 0f 00 00       	add    $0xfff,%eax
80109605:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010960a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010960d:	e9 c9 00 00 00       	jmp    801096db <allocuvm+0x105>
    mem = kalloc();
80109612:	e8 ac 97 ff ff       	call   80102dc3 <kalloc>
80109617:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010961a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010961e:	75 2f                	jne    8010964f <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80109620:	c7 04 24 c5 a1 10 80 	movl   $0x8010a1c5,(%esp)
80109627:	e8 9c 6d ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010962c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010962f:	89 44 24 08          	mov    %eax,0x8(%esp)
80109633:	8b 45 10             	mov    0x10(%ebp),%eax
80109636:	89 44 24 04          	mov    %eax,0x4(%esp)
8010963a:	8b 45 08             	mov    0x8(%ebp),%eax
8010963d:	89 04 24             	mov    %eax,(%esp)
80109640:	e8 a7 00 00 00       	call   801096ec <deallocuvm>
      return 0;
80109645:	b8 00 00 00 00       	mov    $0x0,%eax
8010964a:	e9 9b 00 00 00       	jmp    801096ea <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
8010964f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109656:	00 
80109657:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010965e:	00 
8010965f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109662:	89 04 24             	mov    %eax,(%esp)
80109665:	e8 05 ce ff ff       	call   8010646f <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010966a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010966d:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80109673:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109676:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010967d:	00 
8010967e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80109682:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109689:	00 
8010968a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010968e:	8b 45 08             	mov    0x8(%ebp),%eax
80109691:	89 04 24             	mov    %eax,(%esp)
80109694:	e8 da fa ff ff       	call   80109173 <mappages>
80109699:	85 c0                	test   %eax,%eax
8010969b:	79 37                	jns    801096d4 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
8010969d:	c7 04 24 dd a1 10 80 	movl   $0x8010a1dd,(%esp)
801096a4:	e8 1f 6d ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801096a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801096ac:	89 44 24 08          	mov    %eax,0x8(%esp)
801096b0:	8b 45 10             	mov    0x10(%ebp),%eax
801096b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801096b7:	8b 45 08             	mov    0x8(%ebp),%eax
801096ba:	89 04 24             	mov    %eax,(%esp)
801096bd:	e8 2a 00 00 00       	call   801096ec <deallocuvm>
      kfree(mem);
801096c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096c5:	89 04 24             	mov    %eax,(%esp)
801096c8:	e8 60 96 ff ff       	call   80102d2d <kfree>
      return 0;
801096cd:	b8 00 00 00 00       	mov    $0x0,%eax
801096d2:	eb 16                	jmp    801096ea <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801096d4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801096db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096de:	3b 45 10             	cmp    0x10(%ebp),%eax
801096e1:	0f 82 2b ff ff ff    	jb     80109612 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801096e7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801096ea:	c9                   	leave  
801096eb:	c3                   	ret    

801096ec <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801096ec:	55                   	push   %ebp
801096ed:	89 e5                	mov    %esp,%ebp
801096ef:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801096f2:	8b 45 10             	mov    0x10(%ebp),%eax
801096f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801096f8:	72 08                	jb     80109702 <deallocuvm+0x16>
    return oldsz;
801096fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801096fd:	e9 ae 00 00 00       	jmp    801097b0 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80109702:	8b 45 10             	mov    0x10(%ebp),%eax
80109705:	05 ff 0f 00 00       	add    $0xfff,%eax
8010970a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010970f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109712:	e9 8a 00 00 00       	jmp    801097a1 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80109721:	00 
80109722:	89 44 24 04          	mov    %eax,0x4(%esp)
80109726:	8b 45 08             	mov    0x8(%ebp),%eax
80109729:	89 04 24             	mov    %eax,(%esp)
8010972c:	e8 a6 f9 ff ff       	call   801090d7 <walkpgdir>
80109731:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109738:	75 16                	jne    80109750 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010973a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010973d:	c1 e8 16             	shr    $0x16,%eax
80109740:	83 c0 01             	add    $0x1,%eax
80109743:	c1 e0 16             	shl    $0x16,%eax
80109746:	2d 00 10 00 00       	sub    $0x1000,%eax
8010974b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010974e:	eb 4a                	jmp    8010979a <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
80109750:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109753:	8b 00                	mov    (%eax),%eax
80109755:	83 e0 01             	and    $0x1,%eax
80109758:	85 c0                	test   %eax,%eax
8010975a:	74 3e                	je     8010979a <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
8010975c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010975f:	8b 00                	mov    (%eax),%eax
80109761:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109766:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109769:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010976d:	75 0c                	jne    8010977b <deallocuvm+0x8f>
        panic("kfree");
8010976f:	c7 04 24 f9 a1 10 80 	movl   $0x8010a1f9,(%esp)
80109776:	e8 e7 6d ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
8010977b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010977e:	05 00 00 00 80       	add    $0x80000000,%eax
80109783:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109786:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109789:	89 04 24             	mov    %eax,(%esp)
8010978c:	e8 9c 95 ff ff       	call   80102d2d <kfree>
      *pte = 0;
80109791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010979a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801097a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801097a7:	0f 82 6a ff ff ff    	jb     80109717 <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801097ad:	8b 45 10             	mov    0x10(%ebp),%eax
}
801097b0:	c9                   	leave  
801097b1:	c3                   	ret    

801097b2 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801097b2:	55                   	push   %ebp
801097b3:	89 e5                	mov    %esp,%ebp
801097b5:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
801097b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801097bc:	75 0c                	jne    801097ca <freevm+0x18>
    panic("freevm: no pgdir");
801097be:	c7 04 24 ff a1 10 80 	movl   $0x8010a1ff,(%esp)
801097c5:	e8 98 6d ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801097ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801097d1:	00 
801097d2:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801097d9:	80 
801097da:	8b 45 08             	mov    0x8(%ebp),%eax
801097dd:	89 04 24             	mov    %eax,(%esp)
801097e0:	e8 07 ff ff ff       	call   801096ec <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801097e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801097ec:	eb 45                	jmp    80109833 <freevm+0x81>
    if(pgdir[i] & PTE_P){
801097ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801097f8:	8b 45 08             	mov    0x8(%ebp),%eax
801097fb:	01 d0                	add    %edx,%eax
801097fd:	8b 00                	mov    (%eax),%eax
801097ff:	83 e0 01             	and    $0x1,%eax
80109802:	85 c0                	test   %eax,%eax
80109804:	74 29                	je     8010982f <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80109806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109809:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109810:	8b 45 08             	mov    0x8(%ebp),%eax
80109813:	01 d0                	add    %edx,%eax
80109815:	8b 00                	mov    (%eax),%eax
80109817:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010981c:	05 00 00 00 80       	add    $0x80000000,%eax
80109821:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109827:	89 04 24             	mov    %eax,(%esp)
8010982a:	e8 fe 94 ff ff       	call   80102d2d <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010982f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109833:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010983a:	76 b2                	jbe    801097ee <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010983c:	8b 45 08             	mov    0x8(%ebp),%eax
8010983f:	89 04 24             	mov    %eax,(%esp)
80109842:	e8 e6 94 ff ff       	call   80102d2d <kfree>
}
80109847:	c9                   	leave  
80109848:	c3                   	ret    

80109849 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109849:	55                   	push   %ebp
8010984a:	89 e5                	mov    %esp,%ebp
8010984c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010984f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80109856:	00 
80109857:	8b 45 0c             	mov    0xc(%ebp),%eax
8010985a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010985e:	8b 45 08             	mov    0x8(%ebp),%eax
80109861:	89 04 24             	mov    %eax,(%esp)
80109864:	e8 6e f8 ff ff       	call   801090d7 <walkpgdir>
80109869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010986c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109870:	75 0c                	jne    8010987e <clearpteu+0x35>
    panic("clearpteu");
80109872:	c7 04 24 10 a2 10 80 	movl   $0x8010a210,(%esp)
80109879:	e8 e4 6c ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
8010987e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109881:	8b 00                	mov    (%eax),%eax
80109883:	83 e0 fb             	and    $0xfffffffb,%eax
80109886:	89 c2                	mov    %eax,%edx
80109888:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010988b:	89 10                	mov    %edx,(%eax)
}
8010988d:	c9                   	leave  
8010988e:	c3                   	ret    

8010988f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010988f:	55                   	push   %ebp
80109890:	89 e5                	mov    %esp,%ebp
80109892:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109895:	e8 71 f9 ff ff       	call   8010920b <setupkvm>
8010989a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010989d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801098a1:	75 0a                	jne    801098ad <copyuvm+0x1e>
    return 0;
801098a3:	b8 00 00 00 00       	mov    $0x0,%eax
801098a8:	e9 f8 00 00 00       	jmp    801099a5 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
801098ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801098b4:	e9 cb 00 00 00       	jmp    80109984 <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801098b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801098c3:	00 
801098c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801098c8:	8b 45 08             	mov    0x8(%ebp),%eax
801098cb:	89 04 24             	mov    %eax,(%esp)
801098ce:	e8 04 f8 ff ff       	call   801090d7 <walkpgdir>
801098d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801098d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801098da:	75 0c                	jne    801098e8 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
801098dc:	c7 04 24 1a a2 10 80 	movl   $0x8010a21a,(%esp)
801098e3:	e8 7a 6c ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
801098e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098eb:	8b 00                	mov    (%eax),%eax
801098ed:	83 e0 01             	and    $0x1,%eax
801098f0:	85 c0                	test   %eax,%eax
801098f2:	75 0c                	jne    80109900 <copyuvm+0x71>
      panic("copyuvm: page not present");
801098f4:	c7 04 24 34 a2 10 80 	movl   $0x8010a234,(%esp)
801098fb:	e8 62 6c ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80109900:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109903:	8b 00                	mov    (%eax),%eax
80109905:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010990a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010990d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109910:	8b 00                	mov    (%eax),%eax
80109912:	25 ff 0f 00 00       	and    $0xfff,%eax
80109917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010991a:	e8 a4 94 ff ff       	call   80102dc3 <kalloc>
8010991f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109922:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109926:	75 02                	jne    8010992a <copyuvm+0x9b>
      goto bad;
80109928:	eb 6b                	jmp    80109995 <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010992a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010992d:	05 00 00 00 80       	add    $0x80000000,%eax
80109932:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109939:	00 
8010993a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010993e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109941:	89 04 24             	mov    %eax,(%esp)
80109944:	e8 f5 cb ff ff       	call   8010653e <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80109949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010994c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010994f:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80109955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109958:	89 54 24 10          	mov    %edx,0x10(%esp)
8010995c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80109960:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109967:	00 
80109968:	89 44 24 04          	mov    %eax,0x4(%esp)
8010996c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010996f:	89 04 24             	mov    %eax,(%esp)
80109972:	e8 fc f7 ff ff       	call   80109173 <mappages>
80109977:	85 c0                	test   %eax,%eax
80109979:	79 02                	jns    8010997d <copyuvm+0xee>
      goto bad;
8010997b:	eb 18                	jmp    80109995 <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010997d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109984:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109987:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010998a:	0f 82 29 ff ff ff    	jb     801098b9 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80109990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109993:	eb 10                	jmp    801099a5 <copyuvm+0x116>

bad:
  freevm(d);
80109995:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109998:	89 04 24             	mov    %eax,(%esp)
8010999b:	e8 12 fe ff ff       	call   801097b2 <freevm>
  return 0;
801099a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801099a5:	c9                   	leave  
801099a6:	c3                   	ret    

801099a7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801099a7:	55                   	push   %ebp
801099a8:	89 e5                	mov    %esp,%ebp
801099aa:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801099ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801099b4:	00 
801099b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801099b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801099bc:	8b 45 08             	mov    0x8(%ebp),%eax
801099bf:	89 04 24             	mov    %eax,(%esp)
801099c2:	e8 10 f7 ff ff       	call   801090d7 <walkpgdir>
801099c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801099ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099cd:	8b 00                	mov    (%eax),%eax
801099cf:	83 e0 01             	and    $0x1,%eax
801099d2:	85 c0                	test   %eax,%eax
801099d4:	75 07                	jne    801099dd <uva2ka+0x36>
    return 0;
801099d6:	b8 00 00 00 00       	mov    $0x0,%eax
801099db:	eb 22                	jmp    801099ff <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801099dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099e0:	8b 00                	mov    (%eax),%eax
801099e2:	83 e0 04             	and    $0x4,%eax
801099e5:	85 c0                	test   %eax,%eax
801099e7:	75 07                	jne    801099f0 <uva2ka+0x49>
    return 0;
801099e9:	b8 00 00 00 00       	mov    $0x0,%eax
801099ee:	eb 0f                	jmp    801099ff <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
801099f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099f3:	8b 00                	mov    (%eax),%eax
801099f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801099fa:	05 00 00 00 80       	add    $0x80000000,%eax
}
801099ff:	c9                   	leave  
80109a00:	c3                   	ret    

80109a01 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109a01:	55                   	push   %ebp
80109a02:	89 e5                	mov    %esp,%ebp
80109a04:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109a07:	8b 45 10             	mov    0x10(%ebp),%eax
80109a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109a0d:	e9 87 00 00 00       	jmp    80109a99 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80109a12:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80109a24:	8b 45 08             	mov    0x8(%ebp),%eax
80109a27:	89 04 24             	mov    %eax,(%esp)
80109a2a:	e8 78 ff ff ff       	call   801099a7 <uva2ka>
80109a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109a32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109a36:	75 07                	jne    80109a3f <copyout+0x3e>
      return -1;
80109a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109a3d:	eb 69                	jmp    80109aa8 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80109a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a42:	8b 55 ec             	mov    -0x14(%ebp),%edx
80109a45:	29 c2                	sub    %eax,%edx
80109a47:	89 d0                	mov    %edx,%eax
80109a49:	05 00 10 00 00       	add    $0x1000,%eax
80109a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a54:	3b 45 14             	cmp    0x14(%ebp),%eax
80109a57:	76 06                	jbe    80109a5f <copyout+0x5e>
      n = len;
80109a59:	8b 45 14             	mov    0x14(%ebp),%eax
80109a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a62:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a65:	29 c2                	sub    %eax,%edx
80109a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109a6a:	01 c2                	add    %eax,%edx
80109a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a6f:	89 44 24 08          	mov    %eax,0x8(%esp)
80109a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a76:	89 44 24 04          	mov    %eax,0x4(%esp)
80109a7a:	89 14 24             	mov    %edx,(%esp)
80109a7d:	e8 bc ca ff ff       	call   8010653e <memmove>
    len -= n;
80109a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a85:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a8b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a91:	05 00 10 00 00       	add    $0x1000,%eax
80109a96:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109a99:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109a9d:	0f 85 6f ff ff ff    	jne    80109a12 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109aa8:	c9                   	leave  
80109aa9:	c3                   	ret    

80109aaa <my_syscall>:
#include "defs.h"

//
int
my_syscall(char *str)
{
80109aaa:	55                   	push   %ebp
80109aab:	89 e5                	mov    %esp,%ebp
80109aad:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
80109ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80109ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80109ab7:	c7 04 24 4e a2 10 80 	movl   $0x8010a24e,(%esp)
80109abe:	e8 05 69 ff ff       	call   801003c8 <cprintf>
    return 0xABCDABCD;
80109ac3:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80109ac8:	c9                   	leave  
80109ac9:	c3                   	ret    

80109aca <sys_my_syscall>:
//Wrapper
int
sys_my_syscall(void)
{
80109aca:	55                   	push   %ebp
80109acb:	89 e5                	mov    %esp,%ebp
80109acd:	83 ec 28             	sub    $0x28,%esp
    char *str;
    //decode
    if (argstr(0, &str) <0 )
80109ad0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80109ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
80109ad7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80109ade:	e8 64 cd ff ff       	call   80106847 <argstr>
80109ae3:	85 c0                	test   %eax,%eax
80109ae5:	79 07                	jns    80109aee <sys_my_syscall+0x24>
        return -1;
80109ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109aec:	eb 0b                	jmp    80109af9 <sys_my_syscall+0x2f>
    return my_syscall(str);
80109aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109af1:	89 04 24             	mov    %eax,(%esp)
80109af4:	e8 b1 ff ff ff       	call   80109aaa <my_syscall>
}
80109af9:	c9                   	leave  
80109afa:	c3                   	ret    
