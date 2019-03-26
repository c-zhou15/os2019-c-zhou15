
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	83 ec 04             	sub    $0x4,%esp
c0100041:	50                   	push   %eax
c0100042:	6a 00                	push   $0x0
c0100044:	68 36 7a 11 c0       	push   $0xc0117a36
c0100049:	e8 7f 52 00 00       	call   c01052cd <memset>
c010004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100051:	e8 5b 15 00 00       	call   c01015b1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100056:	c7 45 f4 80 5a 10 c0 	movl   $0xc0105a80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010005d:	83 ec 08             	sub    $0x8,%esp
c0100060:	ff 75 f4             	pushl  -0xc(%ebp)
c0100063:	68 9c 5a 10 c0       	push   $0xc0105a9c
c0100068:	e8 fa 01 00 00       	call   c0100267 <cprintf>
c010006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100070:	e8 7c 08 00 00       	call   c01008f1 <print_kerninfo>

    grade_backtrace();
c0100075:	e8 74 00 00 00       	call   c01000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007a:	e8 fd 30 00 00       	call   c010317c <pmm_init>

    pic_init();                 // init interrupt controller
c010007f:	e8 9f 16 00 00       	call   c0101723 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100084:	e8 00 18 00 00       	call   c0101889 <idt_init>

    clock_init();               // init clock interrupt
c0100089:	e8 ca 0c 00 00       	call   c0100d58 <clock_init>
    intr_enable();              // enable irq interrupt
c010008e:	e8 cd 17 00 00       	call   c0101860 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100093:	eb fe                	jmp    c0100093 <kern_init+0x69>

c0100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c0100095:	55                   	push   %ebp
c0100096:	89 e5                	mov    %esp,%ebp
c0100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c010009b:	83 ec 04             	sub    $0x4,%esp
c010009e:	6a 00                	push   $0x0
c01000a0:	6a 00                	push   $0x0
c01000a2:	6a 00                	push   $0x0
c01000a4:	e8 9d 0c 00 00       	call   c0100d46 <mon_backtrace>
c01000a9:	83 c4 10             	add    $0x10,%esp
}
c01000ac:	90                   	nop
c01000ad:	c9                   	leave  
c01000ae:	c3                   	ret    

c01000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000af:	55                   	push   %ebp
c01000b0:	89 e5                	mov    %esp,%ebp
c01000b2:	53                   	push   %ebx
c01000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01000c2:	51                   	push   %ecx
c01000c3:	52                   	push   %edx
c01000c4:	53                   	push   %ebx
c01000c5:	50                   	push   %eax
c01000c6:	e8 ca ff ff ff       	call   c0100095 <grade_backtrace2>
c01000cb:	83 c4 10             	add    $0x10,%esp
}
c01000ce:	90                   	nop
c01000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000d2:	c9                   	leave  
c01000d3:	c3                   	ret    

c01000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000d4:	55                   	push   %ebp
c01000d5:	89 e5                	mov    %esp,%ebp
c01000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000da:	83 ec 08             	sub    $0x8,%esp
c01000dd:	ff 75 10             	pushl  0x10(%ebp)
c01000e0:	ff 75 08             	pushl  0x8(%ebp)
c01000e3:	e8 c7 ff ff ff       	call   c01000af <grade_backtrace1>
c01000e8:	83 c4 10             	add    $0x10,%esp
}
c01000eb:	90                   	nop
c01000ec:	c9                   	leave  
c01000ed:	c3                   	ret    

c01000ee <grade_backtrace>:

void
grade_backtrace(void) {
c01000ee:	55                   	push   %ebp
c01000ef:	89 e5                	mov    %esp,%ebp
c01000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01000f9:	83 ec 04             	sub    $0x4,%esp
c01000fc:	68 00 00 ff ff       	push   $0xffff0000
c0100101:	50                   	push   %eax
c0100102:	6a 00                	push   $0x0
c0100104:	e8 cb ff ff ff       	call   c01000d4 <grade_backtrace0>
c0100109:	83 c4 10             	add    $0x10,%esp
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100125:	0f b7 c0             	movzwl %ax,%eax
c0100128:	83 e0 03             	and    $0x3,%eax
c010012b:	89 c2                	mov    %eax,%edx
c010012d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100132:	83 ec 04             	sub    $0x4,%esp
c0100135:	52                   	push   %edx
c0100136:	50                   	push   %eax
c0100137:	68 a1 5a 10 c0       	push   $0xc0105aa1
c010013c:	e8 26 01 00 00       	call   c0100267 <cprintf>
c0100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c0100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100148:	0f b7 d0             	movzwl %ax,%edx
c010014b:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100150:	83 ec 04             	sub    $0x4,%esp
c0100153:	52                   	push   %edx
c0100154:	50                   	push   %eax
c0100155:	68 af 5a 10 c0       	push   $0xc0105aaf
c010015a:	e8 08 01 00 00       	call   c0100267 <cprintf>
c010015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c0100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100166:	0f b7 d0             	movzwl %ax,%edx
c0100169:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016e:	83 ec 04             	sub    $0x4,%esp
c0100171:	52                   	push   %edx
c0100172:	50                   	push   %eax
c0100173:	68 bd 5a 10 c0       	push   $0xc0105abd
c0100178:	e8 ea 00 00 00       	call   c0100267 <cprintf>
c010017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100184:	0f b7 d0             	movzwl %ax,%edx
c0100187:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018c:	83 ec 04             	sub    $0x4,%esp
c010018f:	52                   	push   %edx
c0100190:	50                   	push   %eax
c0100191:	68 cb 5a 10 c0       	push   $0xc0105acb
c0100196:	e8 cc 00 00 00       	call   c0100267 <cprintf>
c010019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c010019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001a2:	0f b7 d0             	movzwl %ax,%edx
c01001a5:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001aa:	83 ec 04             	sub    $0x4,%esp
c01001ad:	52                   	push   %edx
c01001ae:	50                   	push   %eax
c01001af:	68 d9 5a 10 c0       	push   $0xc0105ad9
c01001b4:	e8 ae 00 00 00       	call   c0100267 <cprintf>
c01001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001bc:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001c1:	83 c0 01             	add    $0x1,%eax
c01001c4:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001c9:	90                   	nop
c01001ca:	c9                   	leave  
c01001cb:	c3                   	ret    

c01001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001cc:	55                   	push   %ebp
c01001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001cf:	90                   	nop
c01001d0:	5d                   	pop    %ebp
c01001d1:	c3                   	ret    

c01001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001d2:	55                   	push   %ebp
c01001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001d5:	90                   	nop
c01001d6:	5d                   	pop    %ebp
c01001d7:	c3                   	ret    

c01001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001d8:	55                   	push   %ebp
c01001d9:	89 e5                	mov    %esp,%ebp
c01001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001de:	e8 2c ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001e3:	83 ec 0c             	sub    $0xc,%esp
c01001e6:	68 e8 5a 10 c0       	push   $0xc0105ae8
c01001eb:	e8 77 00 00 00       	call   c0100267 <cprintf>
c01001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001f3:	e8 d4 ff ff ff       	call   c01001cc <lab1_switch_to_user>
    lab1_print_cur_status();
c01001f8:	e8 12 ff ff ff       	call   c010010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c01001fd:	83 ec 0c             	sub    $0xc,%esp
c0100200:	68 08 5b 10 c0       	push   $0xc0105b08
c0100205:	e8 5d 00 00 00       	call   c0100267 <cprintf>
c010020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c010020d:	e8 c0 ff ff ff       	call   c01001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100212:	e8 f8 fe ff ff       	call   c010010f <lab1_print_cur_status>
}
c0100217:	90                   	nop
c0100218:	c9                   	leave  
c0100219:	c3                   	ret    

c010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010021a:	55                   	push   %ebp
c010021b:	89 e5                	mov    %esp,%ebp
c010021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100220:	83 ec 0c             	sub    $0xc,%esp
c0100223:	ff 75 08             	pushl  0x8(%ebp)
c0100226:	e8 b7 13 00 00       	call   c01015e2 <cons_putc>
c010022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c010022e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100231:	8b 00                	mov    (%eax),%eax
c0100233:	8d 50 01             	lea    0x1(%eax),%edx
c0100236:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100239:	89 10                	mov    %edx,(%eax)
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010024b:	ff 75 0c             	pushl  0xc(%ebp)
c010024e:	ff 75 08             	pushl  0x8(%ebp)
c0100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100254:	50                   	push   %eax
c0100255:	68 1a 02 10 c0       	push   $0xc010021a
c010025a:	e8 a4 53 00 00       	call   c0105603 <vprintfmt>
c010025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
c0100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100265:	c9                   	leave  
c0100266:	c3                   	ret    

c0100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100267:	55                   	push   %ebp
c0100268:	89 e5                	mov    %esp,%ebp
c010026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010026d:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100276:	83 ec 08             	sub    $0x8,%esp
c0100279:	50                   	push   %eax
c010027a:	ff 75 08             	pushl  0x8(%ebp)
c010027d:	e8 bc ff ff ff       	call   c010023e <vcprintf>
c0100282:	83 c4 10             	add    $0x10,%esp
c0100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c0100293:	83 ec 0c             	sub    $0xc,%esp
c0100296:	ff 75 08             	pushl  0x8(%ebp)
c0100299:	e8 44 13 00 00       	call   c01015e2 <cons_putc>
c010029e:	83 c4 10             	add    $0x10,%esp
}
c01002a1:	90                   	nop
c01002a2:	c9                   	leave  
c01002a3:	c3                   	ret    

c01002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002a4:	55                   	push   %ebp
c01002a5:	89 e5                	mov    %esp,%ebp
c01002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c01002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002b1:	eb 14                	jmp    c01002c7 <cputs+0x23>
        cputch(c, &cnt);
c01002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002b7:	83 ec 08             	sub    $0x8,%esp
c01002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002bd:	52                   	push   %edx
c01002be:	50                   	push   %eax
c01002bf:	e8 56 ff ff ff       	call   c010021a <cputch>
c01002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ca:	8d 50 01             	lea    0x1(%eax),%edx
c01002cd:	89 55 08             	mov    %edx,0x8(%ebp)
c01002d0:	0f b6 00             	movzbl (%eax),%eax
c01002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002da:	75 d7                	jne    c01002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002dc:	83 ec 08             	sub    $0x8,%esp
c01002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002e2:	50                   	push   %eax
c01002e3:	6a 0a                	push   $0xa
c01002e5:	e8 30 ff ff ff       	call   c010021a <cputch>
c01002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01002f0:	c9                   	leave  
c01002f1:	c3                   	ret    

c01002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01002f2:	55                   	push   %ebp
c01002f3:	89 e5                	mov    %esp,%ebp
c01002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01002f8:	e8 2e 13 00 00       	call   c010162b <cons_getc>
c01002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100304:	74 f2                	je     c01002f8 <getchar+0x6>
        /* do nothing */;
    return c;
c0100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100309:	c9                   	leave  
c010030a:	c3                   	ret    

c010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010030b:	55                   	push   %ebp
c010030c:	89 e5                	mov    %esp,%ebp
c010030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100315:	74 13                	je     c010032a <readline+0x1f>
        cprintf("%s", prompt);
c0100317:	83 ec 08             	sub    $0x8,%esp
c010031a:	ff 75 08             	pushl  0x8(%ebp)
c010031d:	68 27 5b 10 c0       	push   $0xc0105b27
c0100322:	e8 40 ff ff ff       	call   c0100267 <cprintf>
c0100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100331:	e8 bc ff ff ff       	call   c01002f2 <getchar>
c0100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010033d:	79 0a                	jns    c0100349 <readline+0x3e>
            return NULL;
c010033f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100344:	e9 82 00 00 00       	jmp    c01003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010034d:	7e 2b                	jle    c010037a <readline+0x6f>
c010034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100356:	7f 22                	jg     c010037a <readline+0x6f>
            cputchar(c);
c0100358:	83 ec 0c             	sub    $0xc,%esp
c010035b:	ff 75 f0             	pushl  -0x10(%ebp)
c010035e:	e8 2a ff ff ff       	call   c010028d <cputchar>
c0100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c0100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100369:	8d 50 01             	lea    0x1(%eax),%edx
c010036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100372:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100378:	eb 4c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c010037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010037e:	75 1a                	jne    c010039a <readline+0x8f>
c0100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100384:	7e 14                	jle    c010039a <readline+0x8f>
            cputchar(c);
c0100386:	83 ec 0c             	sub    $0xc,%esp
c0100389:	ff 75 f0             	pushl  -0x10(%ebp)
c010038c:	e8 fc fe ff ff       	call   c010028d <cputchar>
c0100391:	83 c4 10             	add    $0x10,%esp
            i --;
c0100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0100398:	eb 2c                	jmp    c01003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c010039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c010039e:	74 06                	je     c01003a6 <readline+0x9b>
c01003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003a4:	75 8b                	jne    c0100331 <readline+0x26>
            cputchar(c);
c01003a6:	83 ec 0c             	sub    $0xc,%esp
c01003a9:	ff 75 f0             	pushl  -0x10(%ebp)
c01003ac:	e8 dc fe ff ff       	call   c010028d <cputchar>
c01003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003b7:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003bf:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003c4:	eb 05                	jmp    c01003cb <readline+0xc0>
        }
    }
c01003c6:	e9 66 ff ff ff       	jmp    c0100331 <readline+0x26>
}
c01003cb:	c9                   	leave  
c01003cc:	c3                   	ret    

c01003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003cd:	55                   	push   %ebp
c01003ce:	89 e5                	mov    %esp,%ebp
c01003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c01003d3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003d8:	85 c0                	test   %eax,%eax
c01003da:	75 4a                	jne    c0100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
c01003dc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c01003ec:	83 ec 04             	sub    $0x4,%esp
c01003ef:	ff 75 0c             	pushl  0xc(%ebp)
c01003f2:	ff 75 08             	pushl  0x8(%ebp)
c01003f5:	68 2a 5b 10 c0       	push   $0xc0105b2a
c01003fa:	e8 68 fe ff ff       	call   c0100267 <cprintf>
c01003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100405:	83 ec 08             	sub    $0x8,%esp
c0100408:	50                   	push   %eax
c0100409:	ff 75 10             	pushl  0x10(%ebp)
c010040c:	e8 2d fe ff ff       	call   c010023e <vcprintf>
c0100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100414:	83 ec 0c             	sub    $0xc,%esp
c0100417:	68 46 5b 10 c0       	push   $0xc0105b46
c010041c:	e8 46 fe ff ff       	call   c0100267 <cprintf>
c0100421:	83 c4 10             	add    $0x10,%esp
c0100424:	eb 01                	jmp    c0100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100427:	e8 3b 14 00 00       	call   c0101867 <intr_disable>
    while (1) {
        kmonitor(NULL);
c010042c:	83 ec 0c             	sub    $0xc,%esp
c010042f:	6a 00                	push   $0x0
c0100431:	e8 36 08 00 00       	call   c0100c6c <kmonitor>
c0100436:	83 c4 10             	add    $0x10,%esp
    }
c0100439:	eb f1                	jmp    c010042c <__panic+0x5f>

c010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010043b:	55                   	push   %ebp
c010043c:	89 e5                	mov    %esp,%ebp
c010043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100441:	8d 45 14             	lea    0x14(%ebp),%eax
c0100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100447:	83 ec 04             	sub    $0x4,%esp
c010044a:	ff 75 0c             	pushl  0xc(%ebp)
c010044d:	ff 75 08             	pushl  0x8(%ebp)
c0100450:	68 48 5b 10 c0       	push   $0xc0105b48
c0100455:	e8 0d fe ff ff       	call   c0100267 <cprintf>
c010045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c010045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100460:	83 ec 08             	sub    $0x8,%esp
c0100463:	50                   	push   %eax
c0100464:	ff 75 10             	pushl  0x10(%ebp)
c0100467:	e8 d2 fd ff ff       	call   c010023e <vcprintf>
c010046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c010046f:	83 ec 0c             	sub    $0xc,%esp
c0100472:	68 46 5b 10 c0       	push   $0xc0105b46
c0100477:	e8 eb fd ff ff       	call   c0100267 <cprintf>
c010047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c010047f:	90                   	nop
c0100480:	c9                   	leave  
c0100481:	c3                   	ret    

c0100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100482:	55                   	push   %ebp
c0100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100485:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010048a:	5d                   	pop    %ebp
c010048b:	c3                   	ret    

c010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010048c:	55                   	push   %ebp
c010048d:	89 e5                	mov    %esp,%ebp
c010048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 00                	mov    (%eax),%eax
c0100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049a:	8b 45 10             	mov    0x10(%ebp),%eax
c010049d:	8b 00                	mov    (%eax),%eax
c010049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004a9:	e9 d2 00 00 00       	jmp    c0100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	c1 ea 1f             	shr    $0x1f,%edx
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	d1 f8                	sar    %eax
c01004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004c8:	eb 04                	jmp    c01004ce <stab_binsearch+0x42>
            m --;
c01004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004d4:	7c 1f                	jl     c01004f5 <stab_binsearch+0x69>
c01004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d9:	89 d0                	mov    %edx,%eax
c01004db:	01 c0                	add    %eax,%eax
c01004dd:	01 d0                	add    %edx,%eax
c01004df:	c1 e0 02             	shl    $0x2,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ed:	0f b6 c0             	movzbl %al,%eax
c01004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
c01004f3:	75 d5                	jne    c01004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c01004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fb:	7d 0b                	jge    c0100508 <stab_binsearch+0x7c>
            l = true_m + 1;
c01004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100500:	83 c0 01             	add    $0x1,%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100506:	eb 78                	jmp    c0100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	8b 40 08             	mov    0x8(%eax),%eax
c0100525:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100528:	73 13                	jae    c010053d <stab_binsearch+0xb1>
            *region_left = m;
c010052a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010053b:	eb 43                	jmp    c0100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100540:	89 d0                	mov    %edx,%eax
c0100542:	01 c0                	add    %eax,%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	c1 e0 02             	shl    $0x2,%eax
c0100549:	89 c2                	mov    %eax,%edx
c010054b:	8b 45 08             	mov    0x8(%ebp),%eax
c010054e:	01 d0                	add    %edx,%eax
c0100550:	8b 40 08             	mov    0x8(%eax),%eax
c0100553:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100556:	76 16                	jbe    c010056e <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010055b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010055e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100566:	83 e8 01             	sub    $0x1,%eax
c0100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010056c:	eb 12                	jmp    c0100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010056e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100574:	89 10                	mov    %edx,(%eax)
            l = m;
c0100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c0100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100586:	0f 8e 22 ff ff ff    	jle    c01004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c010058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100590:	75 0f                	jne    c01005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c0100592:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100595:	8b 00                	mov    (%eax),%eax
c0100597:	8d 50 ff             	lea    -0x1(%eax),%edx
c010059a:	8b 45 10             	mov    0x10(%ebp),%eax
c010059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010059f:	eb 3f                	jmp    c01005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01005a4:	8b 00                	mov    (%eax),%eax
c01005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005a9:	eb 04                	jmp    c01005af <stab_binsearch+0x123>
c01005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b2:	8b 00                	mov    (%eax),%eax
c01005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005b7:	7d 1f                	jge    c01005d8 <stab_binsearch+0x14c>
c01005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005bc:	89 d0                	mov    %edx,%eax
c01005be:	01 c0                	add    %eax,%eax
c01005c0:	01 d0                	add    %edx,%eax
c01005c2:	c1 e0 02             	shl    $0x2,%eax
c01005c5:	89 c2                	mov    %eax,%edx
c01005c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ca:	01 d0                	add    %edx,%eax
c01005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005d0:	0f b6 c0             	movzbl %al,%eax
c01005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005d6:	75 d3                	jne    c01005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005de:	89 10                	mov    %edx,(%eax)
    }
}
c01005e0:	90                   	nop
c01005e1:	c9                   	leave  
c01005e2:	c3                   	ret    

c01005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005e3:	55                   	push   %ebp
c01005e4:	89 e5                	mov    %esp,%ebp
c01005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ec:	c7 00 68 5b 10 c0    	movl   $0xc0105b68,(%eax)
    info->eip_line = 0;
c01005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c01005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ff:	c7 40 08 68 5b 10 c0 	movl   $0xc0105b68,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100606:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	8b 55 08             	mov    0x8(%ebp),%edx
c0100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100623:	c7 45 f4 70 6d 10 c0 	movl   $0xc0106d70,-0xc(%ebp)
    stab_end = __STAB_END__;
c010062a:	c7 45 f0 b8 1b 11 c0 	movl   $0xc0111bb8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100631:	c7 45 ec b9 1b 11 c0 	movl   $0xc0111bb9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100638:	c7 45 e8 49 46 11 c0 	movl   $0xc0114649,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100645:	76 0d                	jbe    c0100654 <debuginfo_eip+0x71>
c0100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010064a:	83 e8 01             	sub    $0x1,%eax
c010064d:	0f b6 00             	movzbl (%eax),%eax
c0100650:	84 c0                	test   %al,%al
c0100652:	74 0a                	je     c010065e <debuginfo_eip+0x7b>
        return -1;
c0100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100659:	e9 91 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066b:	29 c2                	sub    %eax,%edx
c010066d:	89 d0                	mov    %edx,%eax
c010066f:	c1 f8 02             	sar    $0x2,%eax
c0100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100678:	83 e8 01             	sub    $0x1,%eax
c010067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010067e:	ff 75 08             	pushl  0x8(%ebp)
c0100681:	6a 64                	push   $0x64
c0100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0100686:	50                   	push   %eax
c0100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c010068a:	50                   	push   %eax
c010068b:	ff 75 f4             	pushl  -0xc(%ebp)
c010068e:	e8 f9 fd ff ff       	call   c010048c <stab_binsearch>
c0100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c0100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100699:	85 c0                	test   %eax,%eax
c010069b:	75 0a                	jne    c01006a7 <debuginfo_eip+0xc4>
        return -1;
c010069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a2:	e9 48 02 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006b3:	ff 75 08             	pushl  0x8(%ebp)
c01006b6:	6a 24                	push   $0x24
c01006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006bb:	50                   	push   %eax
c01006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006bf:	50                   	push   %eax
c01006c0:	ff 75 f4             	pushl  -0xc(%ebp)
c01006c3:	e8 c4 fd ff ff       	call   c010048c <stab_binsearch>
c01006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c01006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d1:	39 c2                	cmp    %eax,%edx
c01006d3:	7f 7c                	jg     c0100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c01006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006d8:	89 c2                	mov    %eax,%edx
c01006da:	89 d0                	mov    %edx,%eax
c01006dc:	01 c0                	add    %eax,%eax
c01006de:	01 d0                	add    %edx,%eax
c01006e0:	c1 e0 02             	shl    $0x2,%eax
c01006e3:	89 c2                	mov    %eax,%edx
c01006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006e8:	01 d0                	add    %edx,%eax
c01006ea:	8b 00                	mov    (%eax),%eax
c01006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01006f2:	29 d1                	sub    %edx,%ecx
c01006f4:	89 ca                	mov    %ecx,%edx
c01006f6:	39 d0                	cmp    %edx,%eax
c01006f8:	73 22                	jae    c010071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c01006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006fd:	89 c2                	mov    %eax,%edx
c01006ff:	89 d0                	mov    %edx,%eax
c0100701:	01 c0                	add    %eax,%eax
c0100703:	01 d0                	add    %edx,%eax
c0100705:	c1 e0 02             	shl    $0x2,%eax
c0100708:	89 c2                	mov    %eax,%edx
c010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010070d:	01 d0                	add    %edx,%eax
c010070f:	8b 10                	mov    (%eax),%edx
c0100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100714:	01 c2                	add    %eax,%edx
c0100716:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071f:	89 c2                	mov    %eax,%edx
c0100721:	89 d0                	mov    %edx,%eax
c0100723:	01 c0                	add    %eax,%eax
c0100725:	01 d0                	add    %edx,%eax
c0100727:	c1 e0 02             	shl    $0x2,%eax
c010072a:	89 c2                	mov    %eax,%edx
c010072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072f:	01 d0                	add    %edx,%eax
c0100731:	8b 50 08             	mov    0x8(%eax),%edx
c0100734:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010073a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010073d:	8b 40 10             	mov    0x10(%eax),%eax
c0100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010074f:	eb 15                	jmp    c0100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100754:	8b 55 08             	mov    0x8(%ebp),%edx
c0100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100769:	8b 40 08             	mov    0x8(%eax),%eax
c010076c:	83 ec 08             	sub    $0x8,%esp
c010076f:	6a 3a                	push   $0x3a
c0100771:	50                   	push   %eax
c0100772:	e8 ca 49 00 00       	call   c0105141 <strfind>
c0100777:	83 c4 10             	add    $0x10,%esp
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077f:	8b 40 08             	mov    0x8(%eax),%eax
c0100782:	29 c2                	sub    %eax,%edx
c0100784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010078a:	83 ec 0c             	sub    $0xc,%esp
c010078d:	ff 75 08             	pushl  0x8(%ebp)
c0100790:	6a 44                	push   $0x44
c0100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100795:	50                   	push   %eax
c0100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100799:	50                   	push   %eax
c010079a:	ff 75 f4             	pushl  -0xc(%ebp)
c010079d:	e8 ea fc ff ff       	call   c010048c <stab_binsearch>
c01007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ab:	39 c2                	cmp    %eax,%edx
c01007ad:	7f 24                	jg     c01007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
c01007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007b2:	89 c2                	mov    %eax,%edx
c01007b4:	89 d0                	mov    %edx,%eax
c01007b6:	01 c0                	add    %eax,%eax
c01007b8:	01 d0                	add    %edx,%eax
c01007ba:	c1 e0 02             	shl    $0x2,%eax
c01007bd:	89 c2                	mov    %eax,%edx
c01007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c01007c8:	0f b7 d0             	movzwl %ax,%edx
c01007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007d1:	eb 13                	jmp    c01007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c01007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01007d8:	e9 12 01 00 00       	jmp    c01008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c01007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e0:	83 e8 01             	sub    $0x1,%eax
c01007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c01007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007ec:	39 c2                	cmp    %eax,%edx
c01007ee:	7c 56                	jl     c0100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
c01007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f3:	89 c2                	mov    %eax,%edx
c01007f5:	89 d0                	mov    %edx,%eax
c01007f7:	01 c0                	add    %eax,%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	c1 e0 02             	shl    $0x2,%eax
c01007fe:	89 c2                	mov    %eax,%edx
c0100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100803:	01 d0                	add    %edx,%eax
c0100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100809:	3c 84                	cmp    $0x84,%al
c010080b:	74 39                	je     c0100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100810:	89 c2                	mov    %eax,%edx
c0100812:	89 d0                	mov    %edx,%eax
c0100814:	01 c0                	add    %eax,%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	c1 e0 02             	shl    $0x2,%eax
c010081b:	89 c2                	mov    %eax,%edx
c010081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100820:	01 d0                	add    %edx,%eax
c0100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100826:	3c 64                	cmp    $0x64,%al
c0100828:	75 b3                	jne    c01007dd <debuginfo_eip+0x1fa>
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	89 c2                	mov    %eax,%edx
c010082f:	89 d0                	mov    %edx,%eax
c0100831:	01 c0                	add    %eax,%eax
c0100833:	01 d0                	add    %edx,%eax
c0100835:	c1 e0 02             	shl    $0x2,%eax
c0100838:	89 c2                	mov    %eax,%edx
c010083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010083d:	01 d0                	add    %edx,%eax
c010083f:	8b 40 08             	mov    0x8(%eax),%eax
c0100842:	85 c0                	test   %eax,%eax
c0100844:	74 97                	je     c01007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084c:	39 c2                	cmp    %eax,%edx
c010084e:	7c 46                	jl     c0100896 <debuginfo_eip+0x2b3>
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	89 c2                	mov    %eax,%edx
c0100855:	89 d0                	mov    %edx,%eax
c0100857:	01 c0                	add    %eax,%eax
c0100859:	01 d0                	add    %edx,%eax
c010085b:	c1 e0 02             	shl    $0x2,%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100863:	01 d0                	add    %edx,%eax
c0100865:	8b 00                	mov    (%eax),%eax
c0100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010086d:	29 d1                	sub    %edx,%ecx
c010086f:	89 ca                	mov    %ecx,%edx
c0100871:	39 d0                	cmp    %edx,%eax
c0100873:	73 21                	jae    c0100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 10                	mov    (%eax),%edx
c010088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010088f:	01 c2                	add    %eax,%edx
c0100891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010089c:	39 c2                	cmp    %eax,%edx
c010089e:	7d 4a                	jge    c01008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
c01008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008a3:	83 c0 01             	add    $0x1,%eax
c01008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008a9:	eb 18                	jmp    c01008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ae:	8b 40 14             	mov    0x14(%eax),%eax
c01008b1:	8d 50 01             	lea    0x1(%eax),%edx
c01008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008bd:	83 c0 01             	add    $0x1,%eax
c01008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7d 1d                	jge    c01008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c01008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008e0:	01 d0                	add    %edx,%eax
c01008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008e6:	3c a0                	cmp    $0xa0,%al
c01008e8:	74 c1                	je     c01008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c01008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01008ef:	c9                   	leave  
c01008f0:	c3                   	ret    

c01008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c01008f1:	55                   	push   %ebp
c01008f2:	89 e5                	mov    %esp,%ebp
c01008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c01008f7:	83 ec 0c             	sub    $0xc,%esp
c01008fa:	68 72 5b 10 c0       	push   $0xc0105b72
c01008ff:	e8 63 f9 ff ff       	call   c0100267 <cprintf>
c0100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100907:	83 ec 08             	sub    $0x8,%esp
c010090a:	68 2a 00 10 c0       	push   $0xc010002a
c010090f:	68 8b 5b 10 c0       	push   $0xc0105b8b
c0100914:	e8 4e f9 ff ff       	call   c0100267 <cprintf>
c0100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010091c:	83 ec 08             	sub    $0x8,%esp
c010091f:	68 64 5a 10 c0       	push   $0xc0105a64
c0100924:	68 a3 5b 10 c0       	push   $0xc0105ba3
c0100929:	e8 39 f9 ff ff       	call   c0100267 <cprintf>
c010092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100931:	83 ec 08             	sub    $0x8,%esp
c0100934:	68 36 7a 11 c0       	push   $0xc0117a36
c0100939:	68 bb 5b 10 c0       	push   $0xc0105bbb
c010093e:	e8 24 f9 ff ff       	call   c0100267 <cprintf>
c0100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100946:	83 ec 08             	sub    $0x8,%esp
c0100949:	68 68 89 11 c0       	push   $0xc0118968
c010094e:	68 d3 5b 10 c0       	push   $0xc0105bd3
c0100953:	e8 0f f9 ff ff       	call   c0100267 <cprintf>
c0100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010095b:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100960:	05 ff 03 00 00       	add    $0x3ff,%eax
c0100965:	ba 2a 00 10 c0       	mov    $0xc010002a,%edx
c010096a:	29 d0                	sub    %edx,%eax
c010096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100972:	85 c0                	test   %eax,%eax
c0100974:	0f 48 c2             	cmovs  %edx,%eax
c0100977:	c1 f8 0a             	sar    $0xa,%eax
c010097a:	83 ec 08             	sub    $0x8,%esp
c010097d:	50                   	push   %eax
c010097e:	68 ec 5b 10 c0       	push   $0xc0105bec
c0100983:	e8 df f8 ff ff       	call   c0100267 <cprintf>
c0100988:	83 c4 10             	add    $0x10,%esp
}
c010098b:	90                   	nop
c010098c:	c9                   	leave  
c010098d:	c3                   	ret    

c010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010098e:	55                   	push   %ebp
c010098f:	89 e5                	mov    %esp,%ebp
c0100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100997:	83 ec 08             	sub    $0x8,%esp
c010099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010099d:	50                   	push   %eax
c010099e:	ff 75 08             	pushl  0x8(%ebp)
c01009a1:	e8 3d fc ff ff       	call   c01005e3 <debuginfo_eip>
c01009a6:	83 c4 10             	add    $0x10,%esp
c01009a9:	85 c0                	test   %eax,%eax
c01009ab:	74 15                	je     c01009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ad:	83 ec 08             	sub    $0x8,%esp
c01009b0:	ff 75 08             	pushl  0x8(%ebp)
c01009b3:	68 16 5c 10 c0       	push   $0xc0105c16
c01009b8:	e8 aa f8 ff ff       	call   c0100267 <cprintf>
c01009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009c0:	eb 65                	jmp    c0100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01009c9:	eb 1c                	jmp    c01009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c01009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	0f b6 00             	movzbl (%eax),%eax
c01009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01009df:	01 ca                	add    %ecx,%edx
c01009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01009ed:	7f dc                	jg     c01009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c01009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	01 d0                	add    %edx,%eax
c01009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c01009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a00:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a03:	89 d1                	mov    %edx,%ecx
c0100a05:	29 c1                	sub    %eax,%ecx
c0100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a0d:	83 ec 0c             	sub    $0xc,%esp
c0100a10:	51                   	push   %ecx
c0100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a17:	51                   	push   %ecx
c0100a18:	52                   	push   %edx
c0100a19:	50                   	push   %eax
c0100a1a:	68 32 5c 10 c0       	push   $0xc0105c32
c0100a1f:	e8 43 f8 ff ff       	call   c0100267 <cprintf>
c0100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a27:	90                   	nop
c0100a28:	c9                   	leave  
c0100a29:	c3                   	ret    

c0100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a2a:	55                   	push   %ebp
c0100a2b:	89 e5                	mov    %esp,%ebp
c0100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a30:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a39:	c9                   	leave  
c0100a3a:	c3                   	ret    

c0100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a3b:	55                   	push   %ebp
c0100a3c:	89 e5                	mov    %esp,%ebp
c0100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a41:	89 e8                	mov    %ebp,%eax
c0100a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c0100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();
c0100a4c:	e8 d9 ff ff ff       	call   c0100a2a <read_eip>
c0100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
c0100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a5b:	e9 8d 00 00 00       	jmp    c0100aed <print_stackframe+0xb2>
	{

	//打印当前ebp和eip的地址

		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100a60:	83 ec 04             	sub    $0x4,%esp
c0100a63:	ff 75 f0             	pushl  -0x10(%ebp)
c0100a66:	ff 75 f4             	pushl  -0xc(%ebp)
c0100a69:	68 44 5c 10 c0       	push   $0xc0105c44
c0100a6e:	e8 f4 f7 ff ff       	call   c0100267 <cprintf>
c0100a73:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;
c0100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a79:	83 c0 08             	add    $0x8,%eax
c0100a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
c0100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a86:	eb 26                	jmp    c0100aae <print_stackframe+0x73>

		    cprintf("0x%08x ", args[j]);
c0100a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a95:	01 d0                	add    %edx,%eax
c0100a97:	8b 00                	mov    (%eax),%eax
c0100a99:	83 ec 08             	sub    $0x8,%esp
c0100a9c:	50                   	push   %eax
c0100a9d:	68 60 5c 10 c0       	push   $0xc0105c60
c0100aa2:	e8 c0 f7 ff ff       	call   c0100267 <cprintf>
c0100aa7:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
c0100aaa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100aae:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100ab2:	7e d4                	jle    c0100a88 <print_stackframe+0x4d>

		    cprintf("0x%08x ", args[j]);

		}

		cprintf("\n");
c0100ab4:	83 ec 0c             	sub    $0xc,%esp
c0100ab7:	68 68 5c 10 c0       	push   $0xc0105c68
c0100abc:	e8 a6 f7 ff ff       	call   c0100267 <cprintf>
c0100ac1:	83 c4 10             	add    $0x10,%esp

		print_debuginfo(eip - 1);
c0100ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ac7:	83 e8 01             	sub    $0x1,%eax
c0100aca:	83 ec 0c             	sub    $0xc,%esp
c0100acd:	50                   	push   %eax
c0100ace:	e8 bb fe ff ff       	call   c010098e <print_debuginfo>
c0100ad3:	83 c4 10             	add    $0x10,%esp

		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容
c0100ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad9:	83 c0 04             	add    $0x4,%eax
c0100adc:	8b 00                	mov    (%eax),%eax
c0100ade:	89 45 f0             	mov    %eax,-0x10(%ebp)

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8b 00                	mov    (%eax),%eax
c0100ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
c0100ae9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100af1:	74 0a                	je     c0100afd <print_stackframe+0xc2>
c0100af3:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100af7:	0f 8e 63 ff ff ff    	jle    c0100a60 <print_stackframe+0x25>
		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容

	 }
}
c0100afd:	90                   	nop
c0100afe:	c9                   	leave  
c0100aff:	c3                   	ret    

c0100b00 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b00:	55                   	push   %ebp
c0100b01:	89 e5                	mov    %esp,%ebp
c0100b03:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b0d:	eb 0c                	jmp    c0100b1b <parse+0x1b>
            *buf ++ = '\0';
c0100b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b12:	8d 50 01             	lea    0x1(%eax),%edx
c0100b15:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b18:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1e:	0f b6 00             	movzbl (%eax),%eax
c0100b21:	84 c0                	test   %al,%al
c0100b23:	74 1e                	je     c0100b43 <parse+0x43>
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	0f b6 00             	movzbl (%eax),%eax
c0100b2b:	0f be c0             	movsbl %al,%eax
c0100b2e:	83 ec 08             	sub    $0x8,%esp
c0100b31:	50                   	push   %eax
c0100b32:	68 ec 5c 10 c0       	push   $0xc0105cec
c0100b37:	e8 d2 45 00 00       	call   c010510e <strchr>
c0100b3c:	83 c4 10             	add    $0x10,%esp
c0100b3f:	85 c0                	test   %eax,%eax
c0100b41:	75 cc                	jne    c0100b0f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b46:	0f b6 00             	movzbl (%eax),%eax
c0100b49:	84 c0                	test   %al,%al
c0100b4b:	74 69                	je     c0100bb6 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b4d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b51:	75 12                	jne    c0100b65 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b53:	83 ec 08             	sub    $0x8,%esp
c0100b56:	6a 10                	push   $0x10
c0100b58:	68 f1 5c 10 c0       	push   $0xc0105cf1
c0100b5d:	e8 05 f7 ff ff       	call   c0100267 <cprintf>
c0100b62:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b68:	8d 50 01             	lea    0x1(%eax),%edx
c0100b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b78:	01 c2                	add    %eax,%edx
c0100b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b7d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b7f:	eb 04                	jmp    c0100b85 <parse+0x85>
            buf ++;
c0100b81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b88:	0f b6 00             	movzbl (%eax),%eax
c0100b8b:	84 c0                	test   %al,%al
c0100b8d:	0f 84 7a ff ff ff    	je     c0100b0d <parse+0xd>
c0100b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b96:	0f b6 00             	movzbl (%eax),%eax
c0100b99:	0f be c0             	movsbl %al,%eax
c0100b9c:	83 ec 08             	sub    $0x8,%esp
c0100b9f:	50                   	push   %eax
c0100ba0:	68 ec 5c 10 c0       	push   $0xc0105cec
c0100ba5:	e8 64 45 00 00       	call   c010510e <strchr>
c0100baa:	83 c4 10             	add    $0x10,%esp
c0100bad:	85 c0                	test   %eax,%eax
c0100baf:	74 d0                	je     c0100b81 <parse+0x81>
            buf ++;
        }
    }
c0100bb1:	e9 57 ff ff ff       	jmp    c0100b0d <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100bb6:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bba:	c9                   	leave  
c0100bbb:	c3                   	ret    

c0100bbc <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bbc:	55                   	push   %ebp
c0100bbd:	89 e5                	mov    %esp,%ebp
c0100bbf:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100bc2:	83 ec 08             	sub    $0x8,%esp
c0100bc5:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bc8:	50                   	push   %eax
c0100bc9:	ff 75 08             	pushl  0x8(%ebp)
c0100bcc:	e8 2f ff ff ff       	call   c0100b00 <parse>
c0100bd1:	83 c4 10             	add    $0x10,%esp
c0100bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bdb:	75 0a                	jne    c0100be7 <runcmd+0x2b>
        return 0;
c0100bdd:	b8 00 00 00 00       	mov    $0x0,%eax
c0100be2:	e9 83 00 00 00       	jmp    c0100c6a <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bee:	eb 59                	jmp    c0100c49 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100bf0:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bf6:	89 d0                	mov    %edx,%eax
c0100bf8:	01 c0                	add    %eax,%eax
c0100bfa:	01 d0                	add    %edx,%eax
c0100bfc:	c1 e0 02             	shl    $0x2,%eax
c0100bff:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c04:	8b 00                	mov    (%eax),%eax
c0100c06:	83 ec 08             	sub    $0x8,%esp
c0100c09:	51                   	push   %ecx
c0100c0a:	50                   	push   %eax
c0100c0b:	e8 5e 44 00 00       	call   c010506e <strcmp>
c0100c10:	83 c4 10             	add    $0x10,%esp
c0100c13:	85 c0                	test   %eax,%eax
c0100c15:	75 2e                	jne    c0100c45 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c1a:	89 d0                	mov    %edx,%eax
c0100c1c:	01 c0                	add    %eax,%eax
c0100c1e:	01 d0                	add    %edx,%eax
c0100c20:	c1 e0 02             	shl    $0x2,%eax
c0100c23:	05 28 70 11 c0       	add    $0xc0117028,%eax
c0100c28:	8b 10                	mov    (%eax),%edx
c0100c2a:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c2d:	83 c0 04             	add    $0x4,%eax
c0100c30:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c33:	83 e9 01             	sub    $0x1,%ecx
c0100c36:	83 ec 04             	sub    $0x4,%esp
c0100c39:	ff 75 0c             	pushl  0xc(%ebp)
c0100c3c:	50                   	push   %eax
c0100c3d:	51                   	push   %ecx
c0100c3e:	ff d2                	call   *%edx
c0100c40:	83 c4 10             	add    $0x10,%esp
c0100c43:	eb 25                	jmp    c0100c6a <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4c:	83 f8 02             	cmp    $0x2,%eax
c0100c4f:	76 9f                	jbe    c0100bf0 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c51:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c54:	83 ec 08             	sub    $0x8,%esp
c0100c57:	50                   	push   %eax
c0100c58:	68 0f 5d 10 c0       	push   $0xc0105d0f
c0100c5d:	e8 05 f6 ff ff       	call   c0100267 <cprintf>
c0100c62:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c6a:	c9                   	leave  
c0100c6b:	c3                   	ret    

c0100c6c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c6c:	55                   	push   %ebp
c0100c6d:	89 e5                	mov    %esp,%ebp
c0100c6f:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c72:	83 ec 0c             	sub    $0xc,%esp
c0100c75:	68 28 5d 10 c0       	push   $0xc0105d28
c0100c7a:	e8 e8 f5 ff ff       	call   c0100267 <cprintf>
c0100c7f:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100c82:	83 ec 0c             	sub    $0xc,%esp
c0100c85:	68 50 5d 10 c0       	push   $0xc0105d50
c0100c8a:	e8 d8 f5 ff ff       	call   c0100267 <cprintf>
c0100c8f:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100c92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c96:	74 0e                	je     c0100ca6 <kmonitor+0x3a>
        print_trapframe(tf);
c0100c98:	83 ec 0c             	sub    $0xc,%esp
c0100c9b:	ff 75 08             	pushl  0x8(%ebp)
c0100c9e:	e8 9f 0d 00 00       	call   c0101a42 <print_trapframe>
c0100ca3:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100ca6:	83 ec 0c             	sub    $0xc,%esp
c0100ca9:	68 75 5d 10 c0       	push   $0xc0105d75
c0100cae:	e8 58 f6 ff ff       	call   c010030b <readline>
c0100cb3:	83 c4 10             	add    $0x10,%esp
c0100cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100cb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cbd:	74 e7                	je     c0100ca6 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100cbf:	83 ec 08             	sub    $0x8,%esp
c0100cc2:	ff 75 08             	pushl  0x8(%ebp)
c0100cc5:	ff 75 f4             	pushl  -0xc(%ebp)
c0100cc8:	e8 ef fe ff ff       	call   c0100bbc <runcmd>
c0100ccd:	83 c4 10             	add    $0x10,%esp
c0100cd0:	85 c0                	test   %eax,%eax
c0100cd2:	78 02                	js     c0100cd6 <kmonitor+0x6a>
                break;
            }
        }
    }
c0100cd4:	eb d0                	jmp    c0100ca6 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100cd6:	90                   	nop
            }
        }
    }
}
c0100cd7:	90                   	nop
c0100cd8:	c9                   	leave  
c0100cd9:	c3                   	ret    

c0100cda <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cda:	55                   	push   %ebp
c0100cdb:	89 e5                	mov    %esp,%ebp
c0100cdd:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ce7:	eb 3c                	jmp    c0100d25 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cec:	89 d0                	mov    %edx,%eax
c0100cee:	01 c0                	add    %eax,%eax
c0100cf0:	01 d0                	add    %edx,%eax
c0100cf2:	c1 e0 02             	shl    $0x2,%eax
c0100cf5:	05 24 70 11 c0       	add    $0xc0117024,%eax
c0100cfa:	8b 08                	mov    (%eax),%ecx
c0100cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cff:	89 d0                	mov    %edx,%eax
c0100d01:	01 c0                	add    %eax,%eax
c0100d03:	01 d0                	add    %edx,%eax
c0100d05:	c1 e0 02             	shl    $0x2,%eax
c0100d08:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100d0d:	8b 00                	mov    (%eax),%eax
c0100d0f:	83 ec 04             	sub    $0x4,%esp
c0100d12:	51                   	push   %ecx
c0100d13:	50                   	push   %eax
c0100d14:	68 79 5d 10 c0       	push   $0xc0105d79
c0100d19:	e8 49 f5 ff ff       	call   c0100267 <cprintf>
c0100d1e:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d28:	83 f8 02             	cmp    $0x2,%eax
c0100d2b:	76 bc                	jbe    c0100ce9 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d32:	c9                   	leave  
c0100d33:	c3                   	ret    

c0100d34 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d34:	55                   	push   %ebp
c0100d35:	89 e5                	mov    %esp,%ebp
c0100d37:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d3a:	e8 b2 fb ff ff       	call   c01008f1 <print_kerninfo>
    return 0;
c0100d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d44:	c9                   	leave  
c0100d45:	c3                   	ret    

c0100d46 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d46:	55                   	push   %ebp
c0100d47:	89 e5                	mov    %esp,%ebp
c0100d49:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d4c:	e8 ea fc ff ff       	call   c0100a3b <print_stackframe>
    return 0;
c0100d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d56:	c9                   	leave  
c0100d57:	c3                   	ret    

c0100d58 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d58:	55                   	push   %ebp
c0100d59:	89 e5                	mov    %esp,%ebp
c0100d5b:	83 ec 18             	sub    $0x18,%esp
c0100d5e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d64:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d68:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100d6c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d70:	ee                   	out    %al,(%dx)
c0100d71:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100d77:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100d7b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100d7f:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100d83:	ee                   	out    %al,(%dx)
c0100d84:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d8a:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d92:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d96:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d97:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d9e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100da1:	83 ec 0c             	sub    $0xc,%esp
c0100da4:	68 82 5d 10 c0       	push   $0xc0105d82
c0100da9:	e8 b9 f4 ff ff       	call   c0100267 <cprintf>
c0100dae:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100db1:	83 ec 0c             	sub    $0xc,%esp
c0100db4:	6a 00                	push   $0x0
c0100db6:	e8 3b 09 00 00       	call   c01016f6 <pic_enable>
c0100dbb:	83 c4 10             	add    $0x10,%esp
}
c0100dbe:	90                   	nop
c0100dbf:	c9                   	leave  
c0100dc0:	c3                   	ret    

c0100dc1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dc1:	55                   	push   %ebp
c0100dc2:	89 e5                	mov    %esp,%ebp
c0100dc4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dc7:	9c                   	pushf  
c0100dc8:	58                   	pop    %eax
c0100dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dcf:	25 00 02 00 00       	and    $0x200,%eax
c0100dd4:	85 c0                	test   %eax,%eax
c0100dd6:	74 0c                	je     c0100de4 <__intr_save+0x23>
        intr_disable();
c0100dd8:	e8 8a 0a 00 00       	call   c0101867 <intr_disable>
        return 1;
c0100ddd:	b8 01 00 00 00       	mov    $0x1,%eax
c0100de2:	eb 05                	jmp    c0100de9 <__intr_save+0x28>
    }
    return 0;
c0100de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100de9:	c9                   	leave  
c0100dea:	c3                   	ret    

c0100deb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100deb:	55                   	push   %ebp
c0100dec:	89 e5                	mov    %esp,%ebp
c0100dee:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100df5:	74 05                	je     c0100dfc <__intr_restore+0x11>
        intr_enable();
c0100df7:	e8 64 0a 00 00       	call   c0101860 <intr_enable>
    }
}
c0100dfc:	90                   	nop
c0100dfd:	c9                   	leave  
c0100dfe:	c3                   	ret    

c0100dff <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100dff:	55                   	push   %ebp
c0100e00:	89 e5                	mov    %esp,%ebp
c0100e02:	83 ec 10             	sub    $0x10,%esp
c0100e05:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e0b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e0f:	89 c2                	mov    %eax,%edx
c0100e11:	ec                   	in     (%dx),%al
c0100e12:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100e15:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100e1b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0100e1f:	89 c2                	mov    %eax,%edx
c0100e21:	ec                   	in     (%dx),%al
c0100e22:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e25:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e2b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e2f:	89 c2                	mov    %eax,%edx
c0100e31:	ec                   	in     (%dx),%al
c0100e32:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100e35:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100e3b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0100e3f:	89 c2                	mov    %eax,%edx
c0100e41:	ec                   	in     (%dx),%al
c0100e42:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e45:	90                   	nop
c0100e46:	c9                   	leave  
c0100e47:	c3                   	ret    

c0100e48 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e48:	55                   	push   %ebp
c0100e49:	89 e5                	mov    %esp,%ebp
c0100e4b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e4e:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e58:	0f b7 00             	movzwl (%eax),%eax
c0100e5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e62:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e6a:	0f b7 00             	movzwl (%eax),%eax
c0100e6d:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e71:	74 12                	je     c0100e85 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e73:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e7a:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e81:	b4 03 
c0100e83:	eb 13                	jmp    c0100e98 <cga_init+0x50>
    } else {
        *cp = was;
c0100e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e88:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e8c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e8f:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e96:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e98:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e9f:	0f b7 c0             	movzwl %ax,%eax
c0100ea2:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100ea6:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eaa:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100eae:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0100eb2:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eb3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eba:	83 c0 01             	add    $0x1,%eax
c0100ebd:	0f b7 c0             	movzwl %ax,%eax
c0100ec0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ec4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ec8:	89 c2                	mov    %eax,%edx
c0100eca:	ec                   	in     (%dx),%al
c0100ecb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100ece:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100ed2:	0f b6 c0             	movzbl %al,%eax
c0100ed5:	c1 e0 08             	shl    $0x8,%eax
c0100ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100edb:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee2:	0f b7 c0             	movzwl %ax,%eax
c0100ee5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100ee9:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eed:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100ef1:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100ef5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100ef6:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100efd:	83 c0 01             	add    $0x1,%eax
c0100f00:	0f b7 c0             	movzwl %ax,%eax
c0100f03:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f07:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f0b:	89 c2                	mov    %eax,%edx
c0100f0d:	ec                   	in     (%dx),%al
c0100f0e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f15:	0f b6 c0             	movzbl %al,%eax
c0100f18:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f1e:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f26:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f2c:	90                   	nop
c0100f2d:	c9                   	leave  
c0100f2e:	c3                   	ret    

c0100f2f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f2f:	55                   	push   %ebp
c0100f30:	89 e5                	mov    %esp,%ebp
c0100f32:	83 ec 28             	sub    $0x28,%esp
c0100f35:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f3b:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f3f:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100f43:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f47:	ee                   	out    %al,(%dx)
c0100f48:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100f4e:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100f52:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100f56:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c0100f5a:	ee                   	out    %al,(%dx)
c0100f5b:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100f61:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100f65:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100f69:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f6d:	ee                   	out    %al,(%dx)
c0100f6e:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100f74:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f78:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f7c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
c0100f81:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100f87:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100f8b:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f9a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f9e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100fa2:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fad:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100fb1:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100fb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fc0:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0100fc4:	89 c2                	mov    %eax,%edx
c0100fc6:	ec                   	in     (%dx),%al
c0100fc7:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fce:	3c ff                	cmp    $0xff,%al
c0100fd0:	0f 95 c0             	setne  %al
c0100fd3:	0f b6 c0             	movzbl %al,%eax
c0100fd6:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fdb:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100feb:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100ff1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
c0100ff5:	89 c2                	mov    %eax,%edx
c0100ff7:	ec                   	in     (%dx),%al
c0100ff8:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100ffb:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101000:	85 c0                	test   %eax,%eax
c0101002:	74 0d                	je     c0101011 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
c0101004:	83 ec 0c             	sub    $0xc,%esp
c0101007:	6a 04                	push   $0x4
c0101009:	e8 e8 06 00 00       	call   c01016f6 <pic_enable>
c010100e:	83 c4 10             	add    $0x10,%esp
    }
}
c0101011:	90                   	nop
c0101012:	c9                   	leave  
c0101013:	c3                   	ret    

c0101014 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101014:	55                   	push   %ebp
c0101015:	89 e5                	mov    %esp,%ebp
c0101017:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101021:	eb 09                	jmp    c010102c <lpt_putc_sub+0x18>
        delay();
c0101023:	e8 d7 fd ff ff       	call   c0100dff <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101028:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010102c:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0101032:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0101036:	89 c2                	mov    %eax,%edx
c0101038:	ec                   	in     (%dx),%al
c0101039:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c010103c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101040:	84 c0                	test   %al,%al
c0101042:	78 09                	js     c010104d <lpt_putc_sub+0x39>
c0101044:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010104b:	7e d6                	jle    c0101023 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010104d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101050:	0f b6 c0             	movzbl %al,%eax
c0101053:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0101059:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010105c:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0101060:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c0101064:	ee                   	out    %al,(%dx)
c0101065:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010106b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010106f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c010107e:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c0101082:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0101086:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010108b:	90                   	nop
c010108c:	c9                   	leave  
c010108d:	c3                   	ret    

c010108e <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010108e:	55                   	push   %ebp
c010108f:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101091:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101095:	74 0d                	je     c01010a4 <lpt_putc+0x16>
        lpt_putc_sub(c);
c0101097:	ff 75 08             	pushl  0x8(%ebp)
c010109a:	e8 75 ff ff ff       	call   c0101014 <lpt_putc_sub>
c010109f:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010a2:	eb 1e                	jmp    c01010c2 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c01010a4:	6a 08                	push   $0x8
c01010a6:	e8 69 ff ff ff       	call   c0101014 <lpt_putc_sub>
c01010ab:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010ae:	6a 20                	push   $0x20
c01010b0:	e8 5f ff ff ff       	call   c0101014 <lpt_putc_sub>
c01010b5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010b8:	6a 08                	push   $0x8
c01010ba:	e8 55 ff ff ff       	call   c0101014 <lpt_putc_sub>
c01010bf:	83 c4 04             	add    $0x4,%esp
    }
}
c01010c2:	90                   	nop
c01010c3:	c9                   	leave  
c01010c4:	c3                   	ret    

c01010c5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010c5:	55                   	push   %ebp
c01010c6:	89 e5                	mov    %esp,%ebp
c01010c8:	53                   	push   %ebx
c01010c9:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cf:	b0 00                	mov    $0x0,%al
c01010d1:	85 c0                	test   %eax,%eax
c01010d3:	75 07                	jne    c01010dc <cga_putc+0x17>
        c |= 0x0700;
c01010d5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010df:	0f b6 c0             	movzbl %al,%eax
c01010e2:	83 f8 0a             	cmp    $0xa,%eax
c01010e5:	74 4e                	je     c0101135 <cga_putc+0x70>
c01010e7:	83 f8 0d             	cmp    $0xd,%eax
c01010ea:	74 59                	je     c0101145 <cga_putc+0x80>
c01010ec:	83 f8 08             	cmp    $0x8,%eax
c01010ef:	0f 85 8a 00 00 00    	jne    c010117f <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
c01010f5:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010fc:	66 85 c0             	test   %ax,%ax
c01010ff:	0f 84 a0 00 00 00    	je     c01011a5 <cga_putc+0xe0>
            crt_pos --;
c0101105:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010110c:	83 e8 01             	sub    $0x1,%eax
c010110f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101115:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010111a:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101121:	0f b7 d2             	movzwl %dx,%edx
c0101124:	01 d2                	add    %edx,%edx
c0101126:	01 d0                	add    %edx,%eax
c0101128:	8b 55 08             	mov    0x8(%ebp),%edx
c010112b:	b2 00                	mov    $0x0,%dl
c010112d:	83 ca 20             	or     $0x20,%edx
c0101130:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c0101133:	eb 70                	jmp    c01011a5 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
c0101135:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010113c:	83 c0 50             	add    $0x50,%eax
c010113f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101145:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010114c:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101153:	0f b7 c1             	movzwl %cx,%eax
c0101156:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010115c:	c1 e8 10             	shr    $0x10,%eax
c010115f:	89 c2                	mov    %eax,%edx
c0101161:	66 c1 ea 06          	shr    $0x6,%dx
c0101165:	89 d0                	mov    %edx,%eax
c0101167:	c1 e0 02             	shl    $0x2,%eax
c010116a:	01 d0                	add    %edx,%eax
c010116c:	c1 e0 04             	shl    $0x4,%eax
c010116f:	29 c1                	sub    %eax,%ecx
c0101171:	89 ca                	mov    %ecx,%edx
c0101173:	89 d8                	mov    %ebx,%eax
c0101175:	29 d0                	sub    %edx,%eax
c0101177:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010117d:	eb 27                	jmp    c01011a6 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010117f:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c0101185:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010118c:	8d 50 01             	lea    0x1(%eax),%edx
c010118f:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c0101196:	0f b7 c0             	movzwl %ax,%eax
c0101199:	01 c0                	add    %eax,%eax
c010119b:	01 c8                	add    %ecx,%eax
c010119d:	8b 55 08             	mov    0x8(%ebp),%edx
c01011a0:	66 89 10             	mov    %dx,(%eax)
        break;
c01011a3:	eb 01                	jmp    c01011a6 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c01011a5:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011a6:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ad:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011b1:	76 59                	jbe    c010120c <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011b3:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011b8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011be:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011c3:	83 ec 04             	sub    $0x4,%esp
c01011c6:	68 00 0f 00 00       	push   $0xf00
c01011cb:	52                   	push   %edx
c01011cc:	50                   	push   %eax
c01011cd:	e8 3b 41 00 00       	call   c010530d <memmove>
c01011d2:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011d5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011dc:	eb 15                	jmp    c01011f3 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
c01011de:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011e6:	01 d2                	add    %edx,%edx
c01011e8:	01 d0                	add    %edx,%eax
c01011ea:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011f3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011fa:	7e e2                	jle    c01011de <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c01011fc:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101203:	83 e8 50             	sub    $0x50,%eax
c0101206:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010120c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101213:	0f b7 c0             	movzwl %ax,%eax
c0101216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010121a:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c010121e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c0101222:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101226:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101227:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122e:	66 c1 e8 08          	shr    $0x8,%ax
c0101232:	0f b6 c0             	movzbl %al,%eax
c0101235:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010123c:	83 c2 01             	add    $0x1,%edx
c010123f:	0f b7 d2             	movzwl %dx,%edx
c0101242:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c0101246:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101249:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010124d:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c0101251:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101252:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101259:	0f b7 c0             	movzwl %ax,%eax
c010125c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101260:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c0101264:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0101268:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010126c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c010126d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101274:	0f b6 c0             	movzbl %al,%eax
c0101277:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010127e:	83 c2 01             	add    $0x1,%edx
c0101281:	0f b7 d2             	movzwl %dx,%edx
c0101284:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101288:	88 45 eb             	mov    %al,-0x15(%ebp)
c010128b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c010128f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c0101293:	ee                   	out    %al,(%dx)
}
c0101294:	90                   	nop
c0101295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101298:	c9                   	leave  
c0101299:	c3                   	ret    

c010129a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010129a:	55                   	push   %ebp
c010129b:	89 e5                	mov    %esp,%ebp
c010129d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012a7:	eb 09                	jmp    c01012b2 <serial_putc_sub+0x18>
        delay();
c01012a9:	e8 51 fb ff ff       	call   c0100dff <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012b2:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012b8:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c01012bc:	89 c2                	mov    %eax,%edx
c01012be:	ec                   	in     (%dx),%al
c01012bf:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c01012c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01012c6:	0f b6 c0             	movzbl %al,%eax
c01012c9:	83 e0 20             	and    $0x20,%eax
c01012cc:	85 c0                	test   %eax,%eax
c01012ce:	75 09                	jne    c01012d9 <serial_putc_sub+0x3f>
c01012d0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012d7:	7e d0                	jle    c01012a9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01012dc:	0f b6 c0             	movzbl %al,%eax
c01012df:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c01012e5:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012e8:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c01012ec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01012f0:	ee                   	out    %al,(%dx)
}
c01012f1:	90                   	nop
c01012f2:	c9                   	leave  
c01012f3:	c3                   	ret    

c01012f4 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012f4:	55                   	push   %ebp
c01012f5:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01012f7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012fb:	74 0d                	je     c010130a <serial_putc+0x16>
        serial_putc_sub(c);
c01012fd:	ff 75 08             	pushl  0x8(%ebp)
c0101300:	e8 95 ff ff ff       	call   c010129a <serial_putc_sub>
c0101305:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101308:	eb 1e                	jmp    c0101328 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c010130a:	6a 08                	push   $0x8
c010130c:	e8 89 ff ff ff       	call   c010129a <serial_putc_sub>
c0101311:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101314:	6a 20                	push   $0x20
c0101316:	e8 7f ff ff ff       	call   c010129a <serial_putc_sub>
c010131b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010131e:	6a 08                	push   $0x8
c0101320:	e8 75 ff ff ff       	call   c010129a <serial_putc_sub>
c0101325:	83 c4 04             	add    $0x4,%esp
    }
}
c0101328:	90                   	nop
c0101329:	c9                   	leave  
c010132a:	c3                   	ret    

c010132b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010132b:	55                   	push   %ebp
c010132c:	89 e5                	mov    %esp,%ebp
c010132e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101331:	eb 33                	jmp    c0101366 <cons_intr+0x3b>
        if (c != 0) {
c0101333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101337:	74 2d                	je     c0101366 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101339:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010133e:	8d 50 01             	lea    0x1(%eax),%edx
c0101341:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101347:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010134a:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101350:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101355:	3d 00 02 00 00       	cmp    $0x200,%eax
c010135a:	75 0a                	jne    c0101366 <cons_intr+0x3b>
                cons.wpos = 0;
c010135c:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101363:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101366:	8b 45 08             	mov    0x8(%ebp),%eax
c0101369:	ff d0                	call   *%eax
c010136b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010136e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101372:	75 bf                	jne    c0101333 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101374:	90                   	nop
c0101375:	c9                   	leave  
c0101376:	c3                   	ret    

c0101377 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101377:	55                   	push   %ebp
c0101378:	89 e5                	mov    %esp,%ebp
c010137a:	83 ec 10             	sub    $0x10,%esp
c010137d:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101383:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
c0101387:	89 c2                	mov    %eax,%edx
c0101389:	ec                   	in     (%dx),%al
c010138a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010138d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101391:	0f b6 c0             	movzbl %al,%eax
c0101394:	83 e0 01             	and    $0x1,%eax
c0101397:	85 c0                	test   %eax,%eax
c0101399:	75 07                	jne    c01013a2 <serial_proc_data+0x2b>
        return -1;
c010139b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013a0:	eb 2a                	jmp    c01013cc <serial_proc_data+0x55>
c01013a2:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013a8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013ac:	89 c2                	mov    %eax,%edx
c01013ae:	ec                   	in     (%dx),%al
c01013af:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c01013b2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013b6:	0f b6 c0             	movzbl %al,%eax
c01013b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013bc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013c0:	75 07                	jne    c01013c9 <serial_proc_data+0x52>
        c = '\b';
c01013c2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013cc:	c9                   	leave  
c01013cd:	c3                   	ret    

c01013ce <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c01013d4:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	74 10                	je     c01013ed <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c01013dd:	83 ec 0c             	sub    $0xc,%esp
c01013e0:	68 77 13 10 c0       	push   $0xc0101377
c01013e5:	e8 41 ff ff ff       	call   c010132b <cons_intr>
c01013ea:	83 c4 10             	add    $0x10,%esp
    }
}
c01013ed:	90                   	nop
c01013ee:	c9                   	leave  
c01013ef:	c3                   	ret    

c01013f0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013f0:	55                   	push   %ebp
c01013f1:	89 e5                	mov    %esp,%ebp
c01013f3:	83 ec 18             	sub    $0x18,%esp
c01013f6:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013fc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101400:	89 c2                	mov    %eax,%edx
c0101402:	ec                   	in     (%dx),%al
c0101403:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101406:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010140a:	0f b6 c0             	movzbl %al,%eax
c010140d:	83 e0 01             	and    $0x1,%eax
c0101410:	85 c0                	test   %eax,%eax
c0101412:	75 0a                	jne    c010141e <kbd_proc_data+0x2e>
        return -1;
c0101414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101419:	e9 5d 01 00 00       	jmp    c010157b <kbd_proc_data+0x18b>
c010141e:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101424:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101428:	89 c2                	mov    %eax,%edx
c010142a:	ec                   	in     (%dx),%al
c010142b:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c010142e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101432:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101435:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101439:	75 17                	jne    c0101452 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010143b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101440:	83 c8 40             	or     $0x40,%eax
c0101443:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101448:	b8 00 00 00 00       	mov    $0x0,%eax
c010144d:	e9 29 01 00 00       	jmp    c010157b <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
c0101452:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101456:	84 c0                	test   %al,%al
c0101458:	79 47                	jns    c01014a1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010145a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010145f:	83 e0 40             	and    $0x40,%eax
c0101462:	85 c0                	test   %eax,%eax
c0101464:	75 09                	jne    c010146f <kbd_proc_data+0x7f>
c0101466:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010146a:	83 e0 7f             	and    $0x7f,%eax
c010146d:	eb 04                	jmp    c0101473 <kbd_proc_data+0x83>
c010146f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101473:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101476:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147a:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101481:	83 c8 40             	or     $0x40,%eax
c0101484:	0f b6 c0             	movzbl %al,%eax
c0101487:	f7 d0                	not    %eax
c0101489:	89 c2                	mov    %eax,%edx
c010148b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101490:	21 d0                	and    %edx,%eax
c0101492:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101497:	b8 00 00 00 00       	mov    $0x0,%eax
c010149c:	e9 da 00 00 00       	jmp    c010157b <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
c01014a1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014a6:	83 e0 40             	and    $0x40,%eax
c01014a9:	85 c0                	test   %eax,%eax
c01014ab:	74 11                	je     c01014be <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ad:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	83 e0 bf             	and    $0xffffffbf,%eax
c01014b9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c2:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014c9:	0f b6 d0             	movzbl %al,%edx
c01014cc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d1:	09 d0                	or     %edx,%eax
c01014d3:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014d8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014dc:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014e3:	0f b6 d0             	movzbl %al,%edx
c01014e6:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014eb:	31 d0                	xor    %edx,%eax
c01014ed:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	83 e0 03             	and    $0x3,%eax
c01014fa:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101505:	01 d0                	add    %edx,%eax
c0101507:	0f b6 00             	movzbl (%eax),%eax
c010150a:	0f b6 c0             	movzbl %al,%eax
c010150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101510:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101515:	83 e0 08             	and    $0x8,%eax
c0101518:	85 c0                	test   %eax,%eax
c010151a:	74 22                	je     c010153e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010151c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101520:	7e 0c                	jle    c010152e <kbd_proc_data+0x13e>
c0101522:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101526:	7f 06                	jg     c010152e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101528:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010152c:	eb 10                	jmp    c010153e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010152e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101532:	7e 0a                	jle    c010153e <kbd_proc_data+0x14e>
c0101534:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101538:	7f 04                	jg     c010153e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010153a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010153e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101543:	f7 d0                	not    %eax
c0101545:	83 e0 06             	and    $0x6,%eax
c0101548:	85 c0                	test   %eax,%eax
c010154a:	75 2c                	jne    c0101578 <kbd_proc_data+0x188>
c010154c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101553:	75 23                	jne    c0101578 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
c0101555:	83 ec 0c             	sub    $0xc,%esp
c0101558:	68 9d 5d 10 c0       	push   $0xc0105d9d
c010155d:	e8 05 ed ff ff       	call   c0100267 <cprintf>
c0101562:	83 c4 10             	add    $0x10,%esp
c0101565:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c010156b:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010156f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101573:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101577:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101578:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010157b:	c9                   	leave  
c010157c:	c3                   	ret    

c010157d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010157d:	55                   	push   %ebp
c010157e:	89 e5                	mov    %esp,%ebp
c0101580:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c0101583:	83 ec 0c             	sub    $0xc,%esp
c0101586:	68 f0 13 10 c0       	push   $0xc01013f0
c010158b:	e8 9b fd ff ff       	call   c010132b <cons_intr>
c0101590:	83 c4 10             	add    $0x10,%esp
}
c0101593:	90                   	nop
c0101594:	c9                   	leave  
c0101595:	c3                   	ret    

c0101596 <kbd_init>:

static void
kbd_init(void) {
c0101596:	55                   	push   %ebp
c0101597:	89 e5                	mov    %esp,%ebp
c0101599:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c010159c:	e8 dc ff ff ff       	call   c010157d <kbd_intr>
    pic_enable(IRQ_KBD);
c01015a1:	83 ec 0c             	sub    $0xc,%esp
c01015a4:	6a 01                	push   $0x1
c01015a6:	e8 4b 01 00 00       	call   c01016f6 <pic_enable>
c01015ab:	83 c4 10             	add    $0x10,%esp
}
c01015ae:	90                   	nop
c01015af:	c9                   	leave  
c01015b0:	c3                   	ret    

c01015b1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015b1:	55                   	push   %ebp
c01015b2:	89 e5                	mov    %esp,%ebp
c01015b4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015b7:	e8 8c f8 ff ff       	call   c0100e48 <cga_init>
    serial_init();
c01015bc:	e8 6e f9 ff ff       	call   c0100f2f <serial_init>
    kbd_init();
c01015c1:	e8 d0 ff ff ff       	call   c0101596 <kbd_init>
    if (!serial_exists) {
c01015c6:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015cb:	85 c0                	test   %eax,%eax
c01015cd:	75 10                	jne    c01015df <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015cf:	83 ec 0c             	sub    $0xc,%esp
c01015d2:	68 a9 5d 10 c0       	push   $0xc0105da9
c01015d7:	e8 8b ec ff ff       	call   c0100267 <cprintf>
c01015dc:	83 c4 10             	add    $0x10,%esp
    }
}
c01015df:	90                   	nop
c01015e0:	c9                   	leave  
c01015e1:	c3                   	ret    

c01015e2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015e2:	55                   	push   %ebp
c01015e3:	89 e5                	mov    %esp,%ebp
c01015e5:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015e8:	e8 d4 f7 ff ff       	call   c0100dc1 <__intr_save>
c01015ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015f0:	83 ec 0c             	sub    $0xc,%esp
c01015f3:	ff 75 08             	pushl  0x8(%ebp)
c01015f6:	e8 93 fa ff ff       	call   c010108e <lpt_putc>
c01015fb:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c01015fe:	83 ec 0c             	sub    $0xc,%esp
c0101601:	ff 75 08             	pushl  0x8(%ebp)
c0101604:	e8 bc fa ff ff       	call   c01010c5 <cga_putc>
c0101609:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010160c:	83 ec 0c             	sub    $0xc,%esp
c010160f:	ff 75 08             	pushl  0x8(%ebp)
c0101612:	e8 dd fc ff ff       	call   c01012f4 <serial_putc>
c0101617:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010161a:	83 ec 0c             	sub    $0xc,%esp
c010161d:	ff 75 f4             	pushl  -0xc(%ebp)
c0101620:	e8 c6 f7 ff ff       	call   c0100deb <__intr_restore>
c0101625:	83 c4 10             	add    $0x10,%esp
}
c0101628:	90                   	nop
c0101629:	c9                   	leave  
c010162a:	c3                   	ret    

c010162b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010162b:	55                   	push   %ebp
c010162c:	89 e5                	mov    %esp,%ebp
c010162e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101638:	e8 84 f7 ff ff       	call   c0100dc1 <__intr_save>
c010163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101640:	e8 89 fd ff ff       	call   c01013ce <serial_intr>
        kbd_intr();
c0101645:	e8 33 ff ff ff       	call   c010157d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010164a:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101650:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101655:	39 c2                	cmp    %eax,%edx
c0101657:	74 31                	je     c010168a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101659:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010165e:	8d 50 01             	lea    0x1(%eax),%edx
c0101661:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101667:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010166e:	0f b6 c0             	movzbl %al,%eax
c0101671:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101674:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101679:	3d 00 02 00 00       	cmp    $0x200,%eax
c010167e:	75 0a                	jne    c010168a <cons_getc+0x5f>
                cons.rpos = 0;
c0101680:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101687:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010168a:	83 ec 0c             	sub    $0xc,%esp
c010168d:	ff 75 f0             	pushl  -0x10(%ebp)
c0101690:	e8 56 f7 ff ff       	call   c0100deb <__intr_restore>
c0101695:	83 c4 10             	add    $0x10,%esp
    return c;
c0101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010169b:	c9                   	leave  
c010169c:	c3                   	ret    

c010169d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c010169d:	55                   	push   %ebp
c010169e:	89 e5                	mov    %esp,%ebp
c01016a0:	83 ec 14             	sub    $0x14,%esp
c01016a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016aa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ae:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016b4:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016b9:	85 c0                	test   %eax,%eax
c01016bb:	74 36                	je     c01016f3 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c1:	0f b6 c0             	movzbl %al,%eax
c01016c4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016ca:	88 45 fa             	mov    %al,-0x6(%ebp)
c01016cd:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c01016d1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016d5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016da:	66 c1 e8 08          	shr    $0x8,%ax
c01016de:	0f b6 c0             	movzbl %al,%eax
c01016e1:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016e7:	88 45 fb             	mov    %al,-0x5(%ebp)
c01016ea:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c01016ee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c01016f2:	ee                   	out    %al,(%dx)
    }
}
c01016f3:	90                   	nop
c01016f4:	c9                   	leave  
c01016f5:	c3                   	ret    

c01016f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016f6:	55                   	push   %ebp
c01016f7:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016fc:	ba 01 00 00 00       	mov    $0x1,%edx
c0101701:	89 c1                	mov    %eax,%ecx
c0101703:	d3 e2                	shl    %cl,%edx
c0101705:	89 d0                	mov    %edx,%eax
c0101707:	f7 d0                	not    %eax
c0101709:	89 c2                	mov    %eax,%edx
c010170b:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101712:	21 d0                	and    %edx,%eax
c0101714:	0f b7 c0             	movzwl %ax,%eax
c0101717:	50                   	push   %eax
c0101718:	e8 80 ff ff ff       	call   c010169d <pic_setmask>
c010171d:	83 c4 04             	add    $0x4,%esp
}
c0101720:	90                   	nop
c0101721:	c9                   	leave  
c0101722:	c3                   	ret    

c0101723 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101723:	55                   	push   %ebp
c0101724:	89 e5                	mov    %esp,%ebp
c0101726:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
c0101729:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101730:	00 00 00 
c0101733:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101739:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c010173d:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c0101741:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101745:	ee                   	out    %al,(%dx)
c0101746:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c010174c:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c0101750:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c0101754:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c0101758:	ee                   	out    %al,(%dx)
c0101759:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c010175f:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c0101763:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c0101767:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176b:	ee                   	out    %al,(%dx)
c010176c:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c0101772:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c0101776:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010177a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
c010177e:	ee                   	out    %al,(%dx)
c010177f:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c0101785:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c0101789:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c010178d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101791:	ee                   	out    %al,(%dx)
c0101792:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c0101798:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c010179c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01017a0:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
c01017a4:	ee                   	out    %al,(%dx)
c01017a5:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c01017ab:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c01017af:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c01017b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017b7:	ee                   	out    %al,(%dx)
c01017b8:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c01017be:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c01017c2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017c6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01017ca:	ee                   	out    %al,(%dx)
c01017cb:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017d1:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c01017d5:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c01017d9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017dd:	ee                   	out    %al,(%dx)
c01017de:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c01017e4:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c01017e8:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c01017ec:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01017f0:	ee                   	out    %al,(%dx)
c01017f1:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c01017f7:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c01017fb:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c01017ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101803:	ee                   	out    %al,(%dx)
c0101804:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c010180a:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c010180e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101812:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101816:	ee                   	out    %al,(%dx)
c0101817:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010181d:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c0101821:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0101825:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101829:	ee                   	out    %al,(%dx)
c010182a:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c0101830:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c0101834:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101838:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
c010183c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010183d:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101844:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101848:	74 13                	je     c010185d <pic_init+0x13a>
        pic_setmask(irq_mask);
c010184a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101851:	0f b7 c0             	movzwl %ax,%eax
c0101854:	50                   	push   %eax
c0101855:	e8 43 fe ff ff       	call   c010169d <pic_setmask>
c010185a:	83 c4 04             	add    $0x4,%esp
    }
}
c010185d:	90                   	nop
c010185e:	c9                   	leave  
c010185f:	c3                   	ret    

c0101860 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101860:	55                   	push   %ebp
c0101861:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101863:	fb                   	sti    
    sti();
}
c0101864:	90                   	nop
c0101865:	5d                   	pop    %ebp
c0101866:	c3                   	ret    

c0101867 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101867:	55                   	push   %ebp
c0101868:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c010186a:	fa                   	cli    
    cli();
}
c010186b:	90                   	nop
c010186c:	5d                   	pop    %ebp
c010186d:	c3                   	ret    

c010186e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010186e:	55                   	push   %ebp
c010186f:	89 e5                	mov    %esp,%ebp
c0101871:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101874:	83 ec 08             	sub    $0x8,%esp
c0101877:	6a 64                	push   $0x64
c0101879:	68 e0 5d 10 c0       	push   $0xc0105de0
c010187e:	e8 e4 e9 ff ff       	call   c0100267 <cprintf>
c0101883:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101886:	90                   	nop
c0101887:	c9                   	leave  
c0101888:	c3                   	ret    

c0101889 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101889:	55                   	push   %ebp
c010188a:	89 e5                	mov    %esp,%ebp
c010188c:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010188f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101896:	e9 c3 00 00 00       	jmp    c010195e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c010189b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010189e:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018a5:	89 c2                	mov    %eax,%edx
c01018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018aa:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018b1:	c0 
c01018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b5:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018bc:	c0 08 00 
c01018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c2:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018c9:	c0 
c01018ca:	83 e2 e0             	and    $0xffffffe0,%edx
c01018cd:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d7:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018de:	c0 
c01018df:	83 e2 1f             	and    $0x1f,%edx
c01018e2:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ec:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01018f3:	c0 
c01018f4:	83 e2 f0             	and    $0xfffffff0,%edx
c01018f7:	83 ca 0e             	or     $0xe,%edx
c01018fa:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101904:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190b:	c0 
c010190c:	83 e2 ef             	and    $0xffffffef,%edx
c010190f:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101919:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101920:	c0 
c0101921:	83 e2 9f             	and    $0xffffff9f,%edx
c0101924:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101935:	c0 
c0101936:	83 ca 80             	or     $0xffffff80,%edx
c0101939:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101943:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010194a:	c1 e8 10             	shr    $0x10,%eax
c010194d:	89 c2                	mov    %eax,%edx
c010194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101952:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101959:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010195a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101961:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101966:	0f 86 2f ff ff ff    	jbe    c010189b <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010196c:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101971:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101977:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c010197e:	08 00 
c0101980:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101987:	83 e0 e0             	and    $0xffffffe0,%eax
c010198a:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010198f:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101996:	83 e0 1f             	and    $0x1f,%eax
c0101999:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c010199e:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019a5:	83 e0 f0             	and    $0xfffffff0,%eax
c01019a8:	83 c8 0e             	or     $0xe,%eax
c01019ab:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019b0:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b7:	83 e0 ef             	and    $0xffffffef,%eax
c01019ba:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019bf:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c6:	83 c8 60             	or     $0x60,%eax
c01019c9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ce:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d5:	83 c8 80             	or     $0xffffff80,%eax
c01019d8:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019dd:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019e2:	c1 e8 10             	shr    $0x10,%eax
c01019e5:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019eb:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019f5:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
c01019f8:	90                   	nop
c01019f9:	c9                   	leave  
c01019fa:	c3                   	ret    

c01019fb <trapname>:

static const char *
trapname(int trapno) {
c01019fb:	55                   	push   %ebp
c01019fc:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a01:	83 f8 13             	cmp    $0x13,%eax
c0101a04:	77 0c                	ja     c0101a12 <trapname+0x17>
        return excnames[trapno];
c0101a06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a09:	8b 04 85 40 61 10 c0 	mov    -0x3fef9ec0(,%eax,4),%eax
c0101a10:	eb 18                	jmp    c0101a2a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a12:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a16:	7e 0d                	jle    c0101a25 <trapname+0x2a>
c0101a18:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a1c:	7f 07                	jg     c0101a25 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a1e:	b8 ea 5d 10 c0       	mov    $0xc0105dea,%eax
c0101a23:	eb 05                	jmp    c0101a2a <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a25:	b8 fd 5d 10 c0       	mov    $0xc0105dfd,%eax
}
c0101a2a:	5d                   	pop    %ebp
c0101a2b:	c3                   	ret    

c0101a2c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a2c:	55                   	push   %ebp
c0101a2d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a36:	66 83 f8 08          	cmp    $0x8,%ax
c0101a3a:	0f 94 c0             	sete   %al
c0101a3d:	0f b6 c0             	movzbl %al,%eax
}
c0101a40:	5d                   	pop    %ebp
c0101a41:	c3                   	ret    

c0101a42 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a42:	55                   	push   %ebp
c0101a43:	89 e5                	mov    %esp,%ebp
c0101a45:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a48:	83 ec 08             	sub    $0x8,%esp
c0101a4b:	ff 75 08             	pushl  0x8(%ebp)
c0101a4e:	68 3e 5e 10 c0       	push   $0xc0105e3e
c0101a53:	e8 0f e8 ff ff       	call   c0100267 <cprintf>
c0101a58:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5e:	83 ec 0c             	sub    $0xc,%esp
c0101a61:	50                   	push   %eax
c0101a62:	e8 b8 01 00 00       	call   c0101c1f <print_regs>
c0101a67:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a71:	0f b7 c0             	movzwl %ax,%eax
c0101a74:	83 ec 08             	sub    $0x8,%esp
c0101a77:	50                   	push   %eax
c0101a78:	68 4f 5e 10 c0       	push   $0xc0105e4f
c0101a7d:	e8 e5 e7 ff ff       	call   c0100267 <cprintf>
c0101a82:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a8c:	0f b7 c0             	movzwl %ax,%eax
c0101a8f:	83 ec 08             	sub    $0x8,%esp
c0101a92:	50                   	push   %eax
c0101a93:	68 62 5e 10 c0       	push   $0xc0105e62
c0101a98:	e8 ca e7 ff ff       	call   c0100267 <cprintf>
c0101a9d:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aa7:	0f b7 c0             	movzwl %ax,%eax
c0101aaa:	83 ec 08             	sub    $0x8,%esp
c0101aad:	50                   	push   %eax
c0101aae:	68 75 5e 10 c0       	push   $0xc0105e75
c0101ab3:	e8 af e7 ff ff       	call   c0100267 <cprintf>
c0101ab8:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abe:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ac2:	0f b7 c0             	movzwl %ax,%eax
c0101ac5:	83 ec 08             	sub    $0x8,%esp
c0101ac8:	50                   	push   %eax
c0101ac9:	68 88 5e 10 c0       	push   $0xc0105e88
c0101ace:	e8 94 e7 ff ff       	call   c0100267 <cprintf>
c0101ad3:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad9:	8b 40 30             	mov    0x30(%eax),%eax
c0101adc:	83 ec 0c             	sub    $0xc,%esp
c0101adf:	50                   	push   %eax
c0101ae0:	e8 16 ff ff ff       	call   c01019fb <trapname>
c0101ae5:	83 c4 10             	add    $0x10,%esp
c0101ae8:	89 c2                	mov    %eax,%edx
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	8b 40 30             	mov    0x30(%eax),%eax
c0101af0:	83 ec 04             	sub    $0x4,%esp
c0101af3:	52                   	push   %edx
c0101af4:	50                   	push   %eax
c0101af5:	68 9b 5e 10 c0       	push   $0xc0105e9b
c0101afa:	e8 68 e7 ff ff       	call   c0100267 <cprintf>
c0101aff:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b05:	8b 40 34             	mov    0x34(%eax),%eax
c0101b08:	83 ec 08             	sub    $0x8,%esp
c0101b0b:	50                   	push   %eax
c0101b0c:	68 ad 5e 10 c0       	push   $0xc0105ead
c0101b11:	e8 51 e7 ff ff       	call   c0100267 <cprintf>
c0101b16:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1c:	8b 40 38             	mov    0x38(%eax),%eax
c0101b1f:	83 ec 08             	sub    $0x8,%esp
c0101b22:	50                   	push   %eax
c0101b23:	68 bc 5e 10 c0       	push   $0xc0105ebc
c0101b28:	e8 3a e7 ff ff       	call   c0100267 <cprintf>
c0101b2d:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b37:	0f b7 c0             	movzwl %ax,%eax
c0101b3a:	83 ec 08             	sub    $0x8,%esp
c0101b3d:	50                   	push   %eax
c0101b3e:	68 cb 5e 10 c0       	push   $0xc0105ecb
c0101b43:	e8 1f e7 ff ff       	call   c0100267 <cprintf>
c0101b48:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b51:	83 ec 08             	sub    $0x8,%esp
c0101b54:	50                   	push   %eax
c0101b55:	68 de 5e 10 c0       	push   $0xc0105ede
c0101b5a:	e8 08 e7 ff ff       	call   c0100267 <cprintf>
c0101b5f:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b69:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b70:	eb 3f                	jmp    c0101bb1 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b75:	8b 50 40             	mov    0x40(%eax),%edx
c0101b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b7b:	21 d0                	and    %edx,%eax
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 29                	je     c0101baa <print_trapframe+0x168>
c0101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b84:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8b:	85 c0                	test   %eax,%eax
c0101b8d:	74 1b                	je     c0101baa <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
c0101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b92:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b99:	83 ec 08             	sub    $0x8,%esp
c0101b9c:	50                   	push   %eax
c0101b9d:	68 ed 5e 10 c0       	push   $0xc0105eed
c0101ba2:	e8 c0 e6 ff ff       	call   c0100267 <cprintf>
c0101ba7:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101baa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bae:	d1 65 f0             	shll   -0x10(%ebp)
c0101bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb4:	83 f8 17             	cmp    $0x17,%eax
c0101bb7:	76 b9                	jbe    c0101b72 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbc:	8b 40 40             	mov    0x40(%eax),%eax
c0101bbf:	25 00 30 00 00       	and    $0x3000,%eax
c0101bc4:	c1 e8 0c             	shr    $0xc,%eax
c0101bc7:	83 ec 08             	sub    $0x8,%esp
c0101bca:	50                   	push   %eax
c0101bcb:	68 f1 5e 10 c0       	push   $0xc0105ef1
c0101bd0:	e8 92 e6 ff ff       	call   c0100267 <cprintf>
c0101bd5:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bd8:	83 ec 0c             	sub    $0xc,%esp
c0101bdb:	ff 75 08             	pushl  0x8(%ebp)
c0101bde:	e8 49 fe ff ff       	call   c0101a2c <trap_in_kernel>
c0101be3:	83 c4 10             	add    $0x10,%esp
c0101be6:	85 c0                	test   %eax,%eax
c0101be8:	75 32                	jne    c0101c1c <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bed:	8b 40 44             	mov    0x44(%eax),%eax
c0101bf0:	83 ec 08             	sub    $0x8,%esp
c0101bf3:	50                   	push   %eax
c0101bf4:	68 fa 5e 10 c0       	push   $0xc0105efa
c0101bf9:	e8 69 e6 ff ff       	call   c0100267 <cprintf>
c0101bfe:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c04:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c08:	0f b7 c0             	movzwl %ax,%eax
c0101c0b:	83 ec 08             	sub    $0x8,%esp
c0101c0e:	50                   	push   %eax
c0101c0f:	68 09 5f 10 c0       	push   $0xc0105f09
c0101c14:	e8 4e e6 ff ff       	call   c0100267 <cprintf>
c0101c19:	83 c4 10             	add    $0x10,%esp
    }
}
c0101c1c:	90                   	nop
c0101c1d:	c9                   	leave  
c0101c1e:	c3                   	ret    

c0101c1f <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c1f:	55                   	push   %ebp
c0101c20:	89 e5                	mov    %esp,%ebp
c0101c22:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c28:	8b 00                	mov    (%eax),%eax
c0101c2a:	83 ec 08             	sub    $0x8,%esp
c0101c2d:	50                   	push   %eax
c0101c2e:	68 1c 5f 10 c0       	push   $0xc0105f1c
c0101c33:	e8 2f e6 ff ff       	call   c0100267 <cprintf>
c0101c38:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	8b 40 04             	mov    0x4(%eax),%eax
c0101c41:	83 ec 08             	sub    $0x8,%esp
c0101c44:	50                   	push   %eax
c0101c45:	68 2b 5f 10 c0       	push   $0xc0105f2b
c0101c4a:	e8 18 e6 ff ff       	call   c0100267 <cprintf>
c0101c4f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c55:	8b 40 08             	mov    0x8(%eax),%eax
c0101c58:	83 ec 08             	sub    $0x8,%esp
c0101c5b:	50                   	push   %eax
c0101c5c:	68 3a 5f 10 c0       	push   $0xc0105f3a
c0101c61:	e8 01 e6 ff ff       	call   c0100267 <cprintf>
c0101c66:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6c:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c6f:	83 ec 08             	sub    $0x8,%esp
c0101c72:	50                   	push   %eax
c0101c73:	68 49 5f 10 c0       	push   $0xc0105f49
c0101c78:	e8 ea e5 ff ff       	call   c0100267 <cprintf>
c0101c7d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c83:	8b 40 10             	mov    0x10(%eax),%eax
c0101c86:	83 ec 08             	sub    $0x8,%esp
c0101c89:	50                   	push   %eax
c0101c8a:	68 58 5f 10 c0       	push   $0xc0105f58
c0101c8f:	e8 d3 e5 ff ff       	call   c0100267 <cprintf>
c0101c94:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9a:	8b 40 14             	mov    0x14(%eax),%eax
c0101c9d:	83 ec 08             	sub    $0x8,%esp
c0101ca0:	50                   	push   %eax
c0101ca1:	68 67 5f 10 c0       	push   $0xc0105f67
c0101ca6:	e8 bc e5 ff ff       	call   c0100267 <cprintf>
c0101cab:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb1:	8b 40 18             	mov    0x18(%eax),%eax
c0101cb4:	83 ec 08             	sub    $0x8,%esp
c0101cb7:	50                   	push   %eax
c0101cb8:	68 76 5f 10 c0       	push   $0xc0105f76
c0101cbd:	e8 a5 e5 ff ff       	call   c0100267 <cprintf>
c0101cc2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc8:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101ccb:	83 ec 08             	sub    $0x8,%esp
c0101cce:	50                   	push   %eax
c0101ccf:	68 85 5f 10 c0       	push   $0xc0105f85
c0101cd4:	e8 8e e5 ff ff       	call   c0100267 <cprintf>
c0101cd9:	83 c4 10             	add    $0x10,%esp
}
c0101cdc:	90                   	nop
c0101cdd:	c9                   	leave  
c0101cde:	c3                   	ret    

c0101cdf <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cdf:	55                   	push   %ebp
c0101ce0:	89 e5                	mov    %esp,%ebp
c0101ce2:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce8:	8b 40 30             	mov    0x30(%eax),%eax
c0101ceb:	83 f8 2f             	cmp    $0x2f,%eax
c0101cee:	77 1d                	ja     c0101d0d <trap_dispatch+0x2e>
c0101cf0:	83 f8 2e             	cmp    $0x2e,%eax
c0101cf3:	0f 83 f4 00 00 00    	jae    c0101ded <trap_dispatch+0x10e>
c0101cf9:	83 f8 21             	cmp    $0x21,%eax
c0101cfc:	74 7e                	je     c0101d7c <trap_dispatch+0x9d>
c0101cfe:	83 f8 24             	cmp    $0x24,%eax
c0101d01:	74 55                	je     c0101d58 <trap_dispatch+0x79>
c0101d03:	83 f8 20             	cmp    $0x20,%eax
c0101d06:	74 16                	je     c0101d1e <trap_dispatch+0x3f>
c0101d08:	e9 aa 00 00 00       	jmp    c0101db7 <trap_dispatch+0xd8>
c0101d0d:	83 e8 78             	sub    $0x78,%eax
c0101d10:	83 f8 01             	cmp    $0x1,%eax
c0101d13:	0f 87 9e 00 00 00    	ja     c0101db7 <trap_dispatch+0xd8>
c0101d19:	e9 82 00 00 00       	jmp    c0101da0 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks ++;
c0101d1e:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d23:	83 c0 01             	add    $0x1,%eax
c0101d26:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101d2b:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d31:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d36:	89 c8                	mov    %ecx,%eax
c0101d38:	f7 e2                	mul    %edx
c0101d3a:	89 d0                	mov    %edx,%eax
c0101d3c:	c1 e8 05             	shr    $0x5,%eax
c0101d3f:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d42:	29 c1                	sub    %eax,%ecx
c0101d44:	89 c8                	mov    %ecx,%eax
c0101d46:	85 c0                	test   %eax,%eax
c0101d48:	0f 85 a2 00 00 00    	jne    c0101df0 <trap_dispatch+0x111>
            print_ticks();
c0101d4e:	e8 1b fb ff ff       	call   c010186e <print_ticks>
        }
        break;
c0101d53:	e9 98 00 00 00       	jmp    c0101df0 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d58:	e8 ce f8 ff ff       	call   c010162b <cons_getc>
c0101d5d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d60:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d64:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d68:	83 ec 04             	sub    $0x4,%esp
c0101d6b:	52                   	push   %edx
c0101d6c:	50                   	push   %eax
c0101d6d:	68 94 5f 10 c0       	push   $0xc0105f94
c0101d72:	e8 f0 e4 ff ff       	call   c0100267 <cprintf>
c0101d77:	83 c4 10             	add    $0x10,%esp
        break;
c0101d7a:	eb 75                	jmp    c0101df1 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d7c:	e8 aa f8 ff ff       	call   c010162b <cons_getc>
c0101d81:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d84:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d88:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d8c:	83 ec 04             	sub    $0x4,%esp
c0101d8f:	52                   	push   %edx
c0101d90:	50                   	push   %eax
c0101d91:	68 a6 5f 10 c0       	push   $0xc0105fa6
c0101d96:	e8 cc e4 ff ff       	call   c0100267 <cprintf>
c0101d9b:	83 c4 10             	add    $0x10,%esp
        break;
c0101d9e:	eb 51                	jmp    c0101df1 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101da0:	83 ec 04             	sub    $0x4,%esp
c0101da3:	68 b5 5f 10 c0       	push   $0xc0105fb5
c0101da8:	68 b0 00 00 00       	push   $0xb0
c0101dad:	68 c5 5f 10 c0       	push   $0xc0105fc5
c0101db2:	e8 16 e6 ff ff       	call   c01003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101db7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dbe:	0f b7 c0             	movzwl %ax,%eax
c0101dc1:	83 e0 03             	and    $0x3,%eax
c0101dc4:	85 c0                	test   %eax,%eax
c0101dc6:	75 29                	jne    c0101df1 <trap_dispatch+0x112>
            print_trapframe(tf);
c0101dc8:	83 ec 0c             	sub    $0xc,%esp
c0101dcb:	ff 75 08             	pushl  0x8(%ebp)
c0101dce:	e8 6f fc ff ff       	call   c0101a42 <print_trapframe>
c0101dd3:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101dd6:	83 ec 04             	sub    $0x4,%esp
c0101dd9:	68 d6 5f 10 c0       	push   $0xc0105fd6
c0101dde:	68 ba 00 00 00       	push   $0xba
c0101de3:	68 c5 5f 10 c0       	push   $0xc0105fc5
c0101de8:	e8 e0 e5 ff ff       	call   c01003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101ded:	90                   	nop
c0101dee:	eb 01                	jmp    c0101df1 <trap_dispatch+0x112>
         */
	ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0101df0:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101df1:	90                   	nop
c0101df2:	c9                   	leave  
c0101df3:	c3                   	ret    

c0101df4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101df4:	55                   	push   %ebp
c0101df5:	89 e5                	mov    %esp,%ebp
c0101df7:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dfa:	83 ec 0c             	sub    $0xc,%esp
c0101dfd:	ff 75 08             	pushl  0x8(%ebp)
c0101e00:	e8 da fe ff ff       	call   c0101cdf <trap_dispatch>
c0101e05:	83 c4 10             	add    $0x10,%esp
}
c0101e08:	90                   	nop
c0101e09:	c9                   	leave  
c0101e0a:	c3                   	ret    

c0101e0b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e0b:	6a 00                	push   $0x0
  pushl $0
c0101e0d:	6a 00                	push   $0x0
  jmp __alltraps
c0101e0f:	e9 67 0a 00 00       	jmp    c010287b <__alltraps>

c0101e14 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e14:	6a 00                	push   $0x0
  pushl $1
c0101e16:	6a 01                	push   $0x1
  jmp __alltraps
c0101e18:	e9 5e 0a 00 00       	jmp    c010287b <__alltraps>

c0101e1d <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e1d:	6a 00                	push   $0x0
  pushl $2
c0101e1f:	6a 02                	push   $0x2
  jmp __alltraps
c0101e21:	e9 55 0a 00 00       	jmp    c010287b <__alltraps>

c0101e26 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e26:	6a 00                	push   $0x0
  pushl $3
c0101e28:	6a 03                	push   $0x3
  jmp __alltraps
c0101e2a:	e9 4c 0a 00 00       	jmp    c010287b <__alltraps>

c0101e2f <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e2f:	6a 00                	push   $0x0
  pushl $4
c0101e31:	6a 04                	push   $0x4
  jmp __alltraps
c0101e33:	e9 43 0a 00 00       	jmp    c010287b <__alltraps>

c0101e38 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e38:	6a 00                	push   $0x0
  pushl $5
c0101e3a:	6a 05                	push   $0x5
  jmp __alltraps
c0101e3c:	e9 3a 0a 00 00       	jmp    c010287b <__alltraps>

c0101e41 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e41:	6a 00                	push   $0x0
  pushl $6
c0101e43:	6a 06                	push   $0x6
  jmp __alltraps
c0101e45:	e9 31 0a 00 00       	jmp    c010287b <__alltraps>

c0101e4a <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e4a:	6a 00                	push   $0x0
  pushl $7
c0101e4c:	6a 07                	push   $0x7
  jmp __alltraps
c0101e4e:	e9 28 0a 00 00       	jmp    c010287b <__alltraps>

c0101e53 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e53:	6a 08                	push   $0x8
  jmp __alltraps
c0101e55:	e9 21 0a 00 00       	jmp    c010287b <__alltraps>

c0101e5a <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e5a:	6a 09                	push   $0x9
  jmp __alltraps
c0101e5c:	e9 1a 0a 00 00       	jmp    c010287b <__alltraps>

c0101e61 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e61:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e63:	e9 13 0a 00 00       	jmp    c010287b <__alltraps>

c0101e68 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e68:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e6a:	e9 0c 0a 00 00       	jmp    c010287b <__alltraps>

c0101e6f <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e6f:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e71:	e9 05 0a 00 00       	jmp    c010287b <__alltraps>

c0101e76 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e76:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e78:	e9 fe 09 00 00       	jmp    c010287b <__alltraps>

c0101e7d <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e7d:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e7f:	e9 f7 09 00 00       	jmp    c010287b <__alltraps>

c0101e84 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e84:	6a 00                	push   $0x0
  pushl $15
c0101e86:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e88:	e9 ee 09 00 00       	jmp    c010287b <__alltraps>

c0101e8d <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e8d:	6a 00                	push   $0x0
  pushl $16
c0101e8f:	6a 10                	push   $0x10
  jmp __alltraps
c0101e91:	e9 e5 09 00 00       	jmp    c010287b <__alltraps>

c0101e96 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e96:	6a 11                	push   $0x11
  jmp __alltraps
c0101e98:	e9 de 09 00 00       	jmp    c010287b <__alltraps>

c0101e9d <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e9d:	6a 00                	push   $0x0
  pushl $18
c0101e9f:	6a 12                	push   $0x12
  jmp __alltraps
c0101ea1:	e9 d5 09 00 00       	jmp    c010287b <__alltraps>

c0101ea6 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  pushl $19
c0101ea8:	6a 13                	push   $0x13
  jmp __alltraps
c0101eaa:	e9 cc 09 00 00       	jmp    c010287b <__alltraps>

c0101eaf <vector20>:
.globl vector20
vector20:
  pushl $0
c0101eaf:	6a 00                	push   $0x0
  pushl $20
c0101eb1:	6a 14                	push   $0x14
  jmp __alltraps
c0101eb3:	e9 c3 09 00 00       	jmp    c010287b <__alltraps>

c0101eb8 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101eb8:	6a 00                	push   $0x0
  pushl $21
c0101eba:	6a 15                	push   $0x15
  jmp __alltraps
c0101ebc:	e9 ba 09 00 00       	jmp    c010287b <__alltraps>

c0101ec1 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ec1:	6a 00                	push   $0x0
  pushl $22
c0101ec3:	6a 16                	push   $0x16
  jmp __alltraps
c0101ec5:	e9 b1 09 00 00       	jmp    c010287b <__alltraps>

c0101eca <vector23>:
.globl vector23
vector23:
  pushl $0
c0101eca:	6a 00                	push   $0x0
  pushl $23
c0101ecc:	6a 17                	push   $0x17
  jmp __alltraps
c0101ece:	e9 a8 09 00 00       	jmp    c010287b <__alltraps>

c0101ed3 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ed3:	6a 00                	push   $0x0
  pushl $24
c0101ed5:	6a 18                	push   $0x18
  jmp __alltraps
c0101ed7:	e9 9f 09 00 00       	jmp    c010287b <__alltraps>

c0101edc <vector25>:
.globl vector25
vector25:
  pushl $0
c0101edc:	6a 00                	push   $0x0
  pushl $25
c0101ede:	6a 19                	push   $0x19
  jmp __alltraps
c0101ee0:	e9 96 09 00 00       	jmp    c010287b <__alltraps>

c0101ee5 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ee5:	6a 00                	push   $0x0
  pushl $26
c0101ee7:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101ee9:	e9 8d 09 00 00       	jmp    c010287b <__alltraps>

c0101eee <vector27>:
.globl vector27
vector27:
  pushl $0
c0101eee:	6a 00                	push   $0x0
  pushl $27
c0101ef0:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ef2:	e9 84 09 00 00       	jmp    c010287b <__alltraps>

c0101ef7 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ef7:	6a 00                	push   $0x0
  pushl $28
c0101ef9:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101efb:	e9 7b 09 00 00       	jmp    c010287b <__alltraps>

c0101f00 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f00:	6a 00                	push   $0x0
  pushl $29
c0101f02:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f04:	e9 72 09 00 00       	jmp    c010287b <__alltraps>

c0101f09 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f09:	6a 00                	push   $0x0
  pushl $30
c0101f0b:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f0d:	e9 69 09 00 00       	jmp    c010287b <__alltraps>

c0101f12 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f12:	6a 00                	push   $0x0
  pushl $31
c0101f14:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f16:	e9 60 09 00 00       	jmp    c010287b <__alltraps>

c0101f1b <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f1b:	6a 00                	push   $0x0
  pushl $32
c0101f1d:	6a 20                	push   $0x20
  jmp __alltraps
c0101f1f:	e9 57 09 00 00       	jmp    c010287b <__alltraps>

c0101f24 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f24:	6a 00                	push   $0x0
  pushl $33
c0101f26:	6a 21                	push   $0x21
  jmp __alltraps
c0101f28:	e9 4e 09 00 00       	jmp    c010287b <__alltraps>

c0101f2d <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $34
c0101f2f:	6a 22                	push   $0x22
  jmp __alltraps
c0101f31:	e9 45 09 00 00       	jmp    c010287b <__alltraps>

c0101f36 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $35
c0101f38:	6a 23                	push   $0x23
  jmp __alltraps
c0101f3a:	e9 3c 09 00 00       	jmp    c010287b <__alltraps>

c0101f3f <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $36
c0101f41:	6a 24                	push   $0x24
  jmp __alltraps
c0101f43:	e9 33 09 00 00       	jmp    c010287b <__alltraps>

c0101f48 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $37
c0101f4a:	6a 25                	push   $0x25
  jmp __alltraps
c0101f4c:	e9 2a 09 00 00       	jmp    c010287b <__alltraps>

c0101f51 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $38
c0101f53:	6a 26                	push   $0x26
  jmp __alltraps
c0101f55:	e9 21 09 00 00       	jmp    c010287b <__alltraps>

c0101f5a <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $39
c0101f5c:	6a 27                	push   $0x27
  jmp __alltraps
c0101f5e:	e9 18 09 00 00       	jmp    c010287b <__alltraps>

c0101f63 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $40
c0101f65:	6a 28                	push   $0x28
  jmp __alltraps
c0101f67:	e9 0f 09 00 00       	jmp    c010287b <__alltraps>

c0101f6c <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $41
c0101f6e:	6a 29                	push   $0x29
  jmp __alltraps
c0101f70:	e9 06 09 00 00       	jmp    c010287b <__alltraps>

c0101f75 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $42
c0101f77:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f79:	e9 fd 08 00 00       	jmp    c010287b <__alltraps>

c0101f7e <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $43
c0101f80:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f82:	e9 f4 08 00 00       	jmp    c010287b <__alltraps>

c0101f87 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $44
c0101f89:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f8b:	e9 eb 08 00 00       	jmp    c010287b <__alltraps>

c0101f90 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $45
c0101f92:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f94:	e9 e2 08 00 00       	jmp    c010287b <__alltraps>

c0101f99 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $46
c0101f9b:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f9d:	e9 d9 08 00 00       	jmp    c010287b <__alltraps>

c0101fa2 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $47
c0101fa4:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fa6:	e9 d0 08 00 00       	jmp    c010287b <__alltraps>

c0101fab <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $48
c0101fad:	6a 30                	push   $0x30
  jmp __alltraps
c0101faf:	e9 c7 08 00 00       	jmp    c010287b <__alltraps>

c0101fb4 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $49
c0101fb6:	6a 31                	push   $0x31
  jmp __alltraps
c0101fb8:	e9 be 08 00 00       	jmp    c010287b <__alltraps>

c0101fbd <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $50
c0101fbf:	6a 32                	push   $0x32
  jmp __alltraps
c0101fc1:	e9 b5 08 00 00       	jmp    c010287b <__alltraps>

c0101fc6 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $51
c0101fc8:	6a 33                	push   $0x33
  jmp __alltraps
c0101fca:	e9 ac 08 00 00       	jmp    c010287b <__alltraps>

c0101fcf <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $52
c0101fd1:	6a 34                	push   $0x34
  jmp __alltraps
c0101fd3:	e9 a3 08 00 00       	jmp    c010287b <__alltraps>

c0101fd8 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $53
c0101fda:	6a 35                	push   $0x35
  jmp __alltraps
c0101fdc:	e9 9a 08 00 00       	jmp    c010287b <__alltraps>

c0101fe1 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $54
c0101fe3:	6a 36                	push   $0x36
  jmp __alltraps
c0101fe5:	e9 91 08 00 00       	jmp    c010287b <__alltraps>

c0101fea <vector55>:
.globl vector55
vector55:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $55
c0101fec:	6a 37                	push   $0x37
  jmp __alltraps
c0101fee:	e9 88 08 00 00       	jmp    c010287b <__alltraps>

c0101ff3 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $56
c0101ff5:	6a 38                	push   $0x38
  jmp __alltraps
c0101ff7:	e9 7f 08 00 00       	jmp    c010287b <__alltraps>

c0101ffc <vector57>:
.globl vector57
vector57:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $57
c0101ffe:	6a 39                	push   $0x39
  jmp __alltraps
c0102000:	e9 76 08 00 00       	jmp    c010287b <__alltraps>

c0102005 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $58
c0102007:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102009:	e9 6d 08 00 00       	jmp    c010287b <__alltraps>

c010200e <vector59>:
.globl vector59
vector59:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $59
c0102010:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102012:	e9 64 08 00 00       	jmp    c010287b <__alltraps>

c0102017 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $60
c0102019:	6a 3c                	push   $0x3c
  jmp __alltraps
c010201b:	e9 5b 08 00 00       	jmp    c010287b <__alltraps>

c0102020 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $61
c0102022:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102024:	e9 52 08 00 00       	jmp    c010287b <__alltraps>

c0102029 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $62
c010202b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010202d:	e9 49 08 00 00       	jmp    c010287b <__alltraps>

c0102032 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $63
c0102034:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102036:	e9 40 08 00 00       	jmp    c010287b <__alltraps>

c010203b <vector64>:
.globl vector64
vector64:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $64
c010203d:	6a 40                	push   $0x40
  jmp __alltraps
c010203f:	e9 37 08 00 00       	jmp    c010287b <__alltraps>

c0102044 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $65
c0102046:	6a 41                	push   $0x41
  jmp __alltraps
c0102048:	e9 2e 08 00 00       	jmp    c010287b <__alltraps>

c010204d <vector66>:
.globl vector66
vector66:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $66
c010204f:	6a 42                	push   $0x42
  jmp __alltraps
c0102051:	e9 25 08 00 00       	jmp    c010287b <__alltraps>

c0102056 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $67
c0102058:	6a 43                	push   $0x43
  jmp __alltraps
c010205a:	e9 1c 08 00 00       	jmp    c010287b <__alltraps>

c010205f <vector68>:
.globl vector68
vector68:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $68
c0102061:	6a 44                	push   $0x44
  jmp __alltraps
c0102063:	e9 13 08 00 00       	jmp    c010287b <__alltraps>

c0102068 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $69
c010206a:	6a 45                	push   $0x45
  jmp __alltraps
c010206c:	e9 0a 08 00 00       	jmp    c010287b <__alltraps>

c0102071 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $70
c0102073:	6a 46                	push   $0x46
  jmp __alltraps
c0102075:	e9 01 08 00 00       	jmp    c010287b <__alltraps>

c010207a <vector71>:
.globl vector71
vector71:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $71
c010207c:	6a 47                	push   $0x47
  jmp __alltraps
c010207e:	e9 f8 07 00 00       	jmp    c010287b <__alltraps>

c0102083 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $72
c0102085:	6a 48                	push   $0x48
  jmp __alltraps
c0102087:	e9 ef 07 00 00       	jmp    c010287b <__alltraps>

c010208c <vector73>:
.globl vector73
vector73:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $73
c010208e:	6a 49                	push   $0x49
  jmp __alltraps
c0102090:	e9 e6 07 00 00       	jmp    c010287b <__alltraps>

c0102095 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $74
c0102097:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102099:	e9 dd 07 00 00       	jmp    c010287b <__alltraps>

c010209e <vector75>:
.globl vector75
vector75:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $75
c01020a0:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020a2:	e9 d4 07 00 00       	jmp    c010287b <__alltraps>

c01020a7 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $76
c01020a9:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020ab:	e9 cb 07 00 00       	jmp    c010287b <__alltraps>

c01020b0 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $77
c01020b2:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020b4:	e9 c2 07 00 00       	jmp    c010287b <__alltraps>

c01020b9 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $78
c01020bb:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020bd:	e9 b9 07 00 00       	jmp    c010287b <__alltraps>

c01020c2 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $79
c01020c4:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020c6:	e9 b0 07 00 00       	jmp    c010287b <__alltraps>

c01020cb <vector80>:
.globl vector80
vector80:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $80
c01020cd:	6a 50                	push   $0x50
  jmp __alltraps
c01020cf:	e9 a7 07 00 00       	jmp    c010287b <__alltraps>

c01020d4 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $81
c01020d6:	6a 51                	push   $0x51
  jmp __alltraps
c01020d8:	e9 9e 07 00 00       	jmp    c010287b <__alltraps>

c01020dd <vector82>:
.globl vector82
vector82:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $82
c01020df:	6a 52                	push   $0x52
  jmp __alltraps
c01020e1:	e9 95 07 00 00       	jmp    c010287b <__alltraps>

c01020e6 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $83
c01020e8:	6a 53                	push   $0x53
  jmp __alltraps
c01020ea:	e9 8c 07 00 00       	jmp    c010287b <__alltraps>

c01020ef <vector84>:
.globl vector84
vector84:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $84
c01020f1:	6a 54                	push   $0x54
  jmp __alltraps
c01020f3:	e9 83 07 00 00       	jmp    c010287b <__alltraps>

c01020f8 <vector85>:
.globl vector85
vector85:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $85
c01020fa:	6a 55                	push   $0x55
  jmp __alltraps
c01020fc:	e9 7a 07 00 00       	jmp    c010287b <__alltraps>

c0102101 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $86
c0102103:	6a 56                	push   $0x56
  jmp __alltraps
c0102105:	e9 71 07 00 00       	jmp    c010287b <__alltraps>

c010210a <vector87>:
.globl vector87
vector87:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $87
c010210c:	6a 57                	push   $0x57
  jmp __alltraps
c010210e:	e9 68 07 00 00       	jmp    c010287b <__alltraps>

c0102113 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $88
c0102115:	6a 58                	push   $0x58
  jmp __alltraps
c0102117:	e9 5f 07 00 00       	jmp    c010287b <__alltraps>

c010211c <vector89>:
.globl vector89
vector89:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $89
c010211e:	6a 59                	push   $0x59
  jmp __alltraps
c0102120:	e9 56 07 00 00       	jmp    c010287b <__alltraps>

c0102125 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $90
c0102127:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102129:	e9 4d 07 00 00       	jmp    c010287b <__alltraps>

c010212e <vector91>:
.globl vector91
vector91:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $91
c0102130:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102132:	e9 44 07 00 00       	jmp    c010287b <__alltraps>

c0102137 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $92
c0102139:	6a 5c                	push   $0x5c
  jmp __alltraps
c010213b:	e9 3b 07 00 00       	jmp    c010287b <__alltraps>

c0102140 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $93
c0102142:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102144:	e9 32 07 00 00       	jmp    c010287b <__alltraps>

c0102149 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $94
c010214b:	6a 5e                	push   $0x5e
  jmp __alltraps
c010214d:	e9 29 07 00 00       	jmp    c010287b <__alltraps>

c0102152 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $95
c0102154:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102156:	e9 20 07 00 00       	jmp    c010287b <__alltraps>

c010215b <vector96>:
.globl vector96
vector96:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $96
c010215d:	6a 60                	push   $0x60
  jmp __alltraps
c010215f:	e9 17 07 00 00       	jmp    c010287b <__alltraps>

c0102164 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $97
c0102166:	6a 61                	push   $0x61
  jmp __alltraps
c0102168:	e9 0e 07 00 00       	jmp    c010287b <__alltraps>

c010216d <vector98>:
.globl vector98
vector98:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $98
c010216f:	6a 62                	push   $0x62
  jmp __alltraps
c0102171:	e9 05 07 00 00       	jmp    c010287b <__alltraps>

c0102176 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $99
c0102178:	6a 63                	push   $0x63
  jmp __alltraps
c010217a:	e9 fc 06 00 00       	jmp    c010287b <__alltraps>

c010217f <vector100>:
.globl vector100
vector100:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $100
c0102181:	6a 64                	push   $0x64
  jmp __alltraps
c0102183:	e9 f3 06 00 00       	jmp    c010287b <__alltraps>

c0102188 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $101
c010218a:	6a 65                	push   $0x65
  jmp __alltraps
c010218c:	e9 ea 06 00 00       	jmp    c010287b <__alltraps>

c0102191 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $102
c0102193:	6a 66                	push   $0x66
  jmp __alltraps
c0102195:	e9 e1 06 00 00       	jmp    c010287b <__alltraps>

c010219a <vector103>:
.globl vector103
vector103:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $103
c010219c:	6a 67                	push   $0x67
  jmp __alltraps
c010219e:	e9 d8 06 00 00       	jmp    c010287b <__alltraps>

c01021a3 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $104
c01021a5:	6a 68                	push   $0x68
  jmp __alltraps
c01021a7:	e9 cf 06 00 00       	jmp    c010287b <__alltraps>

c01021ac <vector105>:
.globl vector105
vector105:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $105
c01021ae:	6a 69                	push   $0x69
  jmp __alltraps
c01021b0:	e9 c6 06 00 00       	jmp    c010287b <__alltraps>

c01021b5 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $106
c01021b7:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021b9:	e9 bd 06 00 00       	jmp    c010287b <__alltraps>

c01021be <vector107>:
.globl vector107
vector107:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $107
c01021c0:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021c2:	e9 b4 06 00 00       	jmp    c010287b <__alltraps>

c01021c7 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $108
c01021c9:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021cb:	e9 ab 06 00 00       	jmp    c010287b <__alltraps>

c01021d0 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $109
c01021d2:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021d4:	e9 a2 06 00 00       	jmp    c010287b <__alltraps>

c01021d9 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $110
c01021db:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021dd:	e9 99 06 00 00       	jmp    c010287b <__alltraps>

c01021e2 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $111
c01021e4:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021e6:	e9 90 06 00 00       	jmp    c010287b <__alltraps>

c01021eb <vector112>:
.globl vector112
vector112:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $112
c01021ed:	6a 70                	push   $0x70
  jmp __alltraps
c01021ef:	e9 87 06 00 00       	jmp    c010287b <__alltraps>

c01021f4 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $113
c01021f6:	6a 71                	push   $0x71
  jmp __alltraps
c01021f8:	e9 7e 06 00 00       	jmp    c010287b <__alltraps>

c01021fd <vector114>:
.globl vector114
vector114:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $114
c01021ff:	6a 72                	push   $0x72
  jmp __alltraps
c0102201:	e9 75 06 00 00       	jmp    c010287b <__alltraps>

c0102206 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $115
c0102208:	6a 73                	push   $0x73
  jmp __alltraps
c010220a:	e9 6c 06 00 00       	jmp    c010287b <__alltraps>

c010220f <vector116>:
.globl vector116
vector116:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $116
c0102211:	6a 74                	push   $0x74
  jmp __alltraps
c0102213:	e9 63 06 00 00       	jmp    c010287b <__alltraps>

c0102218 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $117
c010221a:	6a 75                	push   $0x75
  jmp __alltraps
c010221c:	e9 5a 06 00 00       	jmp    c010287b <__alltraps>

c0102221 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $118
c0102223:	6a 76                	push   $0x76
  jmp __alltraps
c0102225:	e9 51 06 00 00       	jmp    c010287b <__alltraps>

c010222a <vector119>:
.globl vector119
vector119:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $119
c010222c:	6a 77                	push   $0x77
  jmp __alltraps
c010222e:	e9 48 06 00 00       	jmp    c010287b <__alltraps>

c0102233 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $120
c0102235:	6a 78                	push   $0x78
  jmp __alltraps
c0102237:	e9 3f 06 00 00       	jmp    c010287b <__alltraps>

c010223c <vector121>:
.globl vector121
vector121:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $121
c010223e:	6a 79                	push   $0x79
  jmp __alltraps
c0102240:	e9 36 06 00 00       	jmp    c010287b <__alltraps>

c0102245 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $122
c0102247:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102249:	e9 2d 06 00 00       	jmp    c010287b <__alltraps>

c010224e <vector123>:
.globl vector123
vector123:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $123
c0102250:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102252:	e9 24 06 00 00       	jmp    c010287b <__alltraps>

c0102257 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $124
c0102259:	6a 7c                	push   $0x7c
  jmp __alltraps
c010225b:	e9 1b 06 00 00       	jmp    c010287b <__alltraps>

c0102260 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $125
c0102262:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102264:	e9 12 06 00 00       	jmp    c010287b <__alltraps>

c0102269 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $126
c010226b:	6a 7e                	push   $0x7e
  jmp __alltraps
c010226d:	e9 09 06 00 00       	jmp    c010287b <__alltraps>

c0102272 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $127
c0102274:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102276:	e9 00 06 00 00       	jmp    c010287b <__alltraps>

c010227b <vector128>:
.globl vector128
vector128:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $128
c010227d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102282:	e9 f4 05 00 00       	jmp    c010287b <__alltraps>

c0102287 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102287:	6a 00                	push   $0x0
  pushl $129
c0102289:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010228e:	e9 e8 05 00 00       	jmp    c010287b <__alltraps>

c0102293 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102293:	6a 00                	push   $0x0
  pushl $130
c0102295:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010229a:	e9 dc 05 00 00       	jmp    c010287b <__alltraps>

c010229f <vector131>:
.globl vector131
vector131:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $131
c01022a1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022a6:	e9 d0 05 00 00       	jmp    c010287b <__alltraps>

c01022ab <vector132>:
.globl vector132
vector132:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $132
c01022ad:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022b2:	e9 c4 05 00 00       	jmp    c010287b <__alltraps>

c01022b7 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $133
c01022b9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022be:	e9 b8 05 00 00       	jmp    c010287b <__alltraps>

c01022c3 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $134
c01022c5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022ca:	e9 ac 05 00 00       	jmp    c010287b <__alltraps>

c01022cf <vector135>:
.globl vector135
vector135:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $135
c01022d1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022d6:	e9 a0 05 00 00       	jmp    c010287b <__alltraps>

c01022db <vector136>:
.globl vector136
vector136:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $136
c01022dd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022e2:	e9 94 05 00 00       	jmp    c010287b <__alltraps>

c01022e7 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $137
c01022e9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022ee:	e9 88 05 00 00       	jmp    c010287b <__alltraps>

c01022f3 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $138
c01022f5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022fa:	e9 7c 05 00 00       	jmp    c010287b <__alltraps>

c01022ff <vector139>:
.globl vector139
vector139:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $139
c0102301:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102306:	e9 70 05 00 00       	jmp    c010287b <__alltraps>

c010230b <vector140>:
.globl vector140
vector140:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $140
c010230d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102312:	e9 64 05 00 00       	jmp    c010287b <__alltraps>

c0102317 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $141
c0102319:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010231e:	e9 58 05 00 00       	jmp    c010287b <__alltraps>

c0102323 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $142
c0102325:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010232a:	e9 4c 05 00 00       	jmp    c010287b <__alltraps>

c010232f <vector143>:
.globl vector143
vector143:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $143
c0102331:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102336:	e9 40 05 00 00       	jmp    c010287b <__alltraps>

c010233b <vector144>:
.globl vector144
vector144:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $144
c010233d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102342:	e9 34 05 00 00       	jmp    c010287b <__alltraps>

c0102347 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $145
c0102349:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010234e:	e9 28 05 00 00       	jmp    c010287b <__alltraps>

c0102353 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $146
c0102355:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010235a:	e9 1c 05 00 00       	jmp    c010287b <__alltraps>

c010235f <vector147>:
.globl vector147
vector147:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $147
c0102361:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102366:	e9 10 05 00 00       	jmp    c010287b <__alltraps>

c010236b <vector148>:
.globl vector148
vector148:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $148
c010236d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102372:	e9 04 05 00 00       	jmp    c010287b <__alltraps>

c0102377 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $149
c0102379:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010237e:	e9 f8 04 00 00       	jmp    c010287b <__alltraps>

c0102383 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $150
c0102385:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010238a:	e9 ec 04 00 00       	jmp    c010287b <__alltraps>

c010238f <vector151>:
.globl vector151
vector151:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $151
c0102391:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102396:	e9 e0 04 00 00       	jmp    c010287b <__alltraps>

c010239b <vector152>:
.globl vector152
vector152:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $152
c010239d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023a2:	e9 d4 04 00 00       	jmp    c010287b <__alltraps>

c01023a7 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $153
c01023a9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023ae:	e9 c8 04 00 00       	jmp    c010287b <__alltraps>

c01023b3 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $154
c01023b5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023ba:	e9 bc 04 00 00       	jmp    c010287b <__alltraps>

c01023bf <vector155>:
.globl vector155
vector155:
  pushl $0
c01023bf:	6a 00                	push   $0x0
  pushl $155
c01023c1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023c6:	e9 b0 04 00 00       	jmp    c010287b <__alltraps>

c01023cb <vector156>:
.globl vector156
vector156:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $156
c01023cd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023d2:	e9 a4 04 00 00       	jmp    c010287b <__alltraps>

c01023d7 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $157
c01023d9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023de:	e9 98 04 00 00       	jmp    c010287b <__alltraps>

c01023e3 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023e3:	6a 00                	push   $0x0
  pushl $158
c01023e5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023ea:	e9 8c 04 00 00       	jmp    c010287b <__alltraps>

c01023ef <vector159>:
.globl vector159
vector159:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $159
c01023f1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023f6:	e9 80 04 00 00       	jmp    c010287b <__alltraps>

c01023fb <vector160>:
.globl vector160
vector160:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $160
c01023fd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102402:	e9 74 04 00 00       	jmp    c010287b <__alltraps>

c0102407 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102407:	6a 00                	push   $0x0
  pushl $161
c0102409:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010240e:	e9 68 04 00 00       	jmp    c010287b <__alltraps>

c0102413 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $162
c0102415:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010241a:	e9 5c 04 00 00       	jmp    c010287b <__alltraps>

c010241f <vector163>:
.globl vector163
vector163:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $163
c0102421:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102426:	e9 50 04 00 00       	jmp    c010287b <__alltraps>

c010242b <vector164>:
.globl vector164
vector164:
  pushl $0
c010242b:	6a 00                	push   $0x0
  pushl $164
c010242d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102432:	e9 44 04 00 00       	jmp    c010287b <__alltraps>

c0102437 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102437:	6a 00                	push   $0x0
  pushl $165
c0102439:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010243e:	e9 38 04 00 00       	jmp    c010287b <__alltraps>

c0102443 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $166
c0102445:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010244a:	e9 2c 04 00 00       	jmp    c010287b <__alltraps>

c010244f <vector167>:
.globl vector167
vector167:
  pushl $0
c010244f:	6a 00                	push   $0x0
  pushl $167
c0102451:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102456:	e9 20 04 00 00       	jmp    c010287b <__alltraps>

c010245b <vector168>:
.globl vector168
vector168:
  pushl $0
c010245b:	6a 00                	push   $0x0
  pushl $168
c010245d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102462:	e9 14 04 00 00       	jmp    c010287b <__alltraps>

c0102467 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $169
c0102469:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010246e:	e9 08 04 00 00       	jmp    c010287b <__alltraps>

c0102473 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102473:	6a 00                	push   $0x0
  pushl $170
c0102475:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010247a:	e9 fc 03 00 00       	jmp    c010287b <__alltraps>

c010247f <vector171>:
.globl vector171
vector171:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $171
c0102481:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102486:	e9 f0 03 00 00       	jmp    c010287b <__alltraps>

c010248b <vector172>:
.globl vector172
vector172:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $172
c010248d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102492:	e9 e4 03 00 00       	jmp    c010287b <__alltraps>

c0102497 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102497:	6a 00                	push   $0x0
  pushl $173
c0102499:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010249e:	e9 d8 03 00 00       	jmp    c010287b <__alltraps>

c01024a3 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $174
c01024a5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024aa:	e9 cc 03 00 00       	jmp    c010287b <__alltraps>

c01024af <vector175>:
.globl vector175
vector175:
  pushl $0
c01024af:	6a 00                	push   $0x0
  pushl $175
c01024b1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024b6:	e9 c0 03 00 00       	jmp    c010287b <__alltraps>

c01024bb <vector176>:
.globl vector176
vector176:
  pushl $0
c01024bb:	6a 00                	push   $0x0
  pushl $176
c01024bd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024c2:	e9 b4 03 00 00       	jmp    c010287b <__alltraps>

c01024c7 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024c7:	6a 00                	push   $0x0
  pushl $177
c01024c9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024ce:	e9 a8 03 00 00       	jmp    c010287b <__alltraps>

c01024d3 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024d3:	6a 00                	push   $0x0
  pushl $178
c01024d5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024da:	e9 9c 03 00 00       	jmp    c010287b <__alltraps>

c01024df <vector179>:
.globl vector179
vector179:
  pushl $0
c01024df:	6a 00                	push   $0x0
  pushl $179
c01024e1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024e6:	e9 90 03 00 00       	jmp    c010287b <__alltraps>

c01024eb <vector180>:
.globl vector180
vector180:
  pushl $0
c01024eb:	6a 00                	push   $0x0
  pushl $180
c01024ed:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024f2:	e9 84 03 00 00       	jmp    c010287b <__alltraps>

c01024f7 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024f7:	6a 00                	push   $0x0
  pushl $181
c01024f9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024fe:	e9 78 03 00 00       	jmp    c010287b <__alltraps>

c0102503 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102503:	6a 00                	push   $0x0
  pushl $182
c0102505:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010250a:	e9 6c 03 00 00       	jmp    c010287b <__alltraps>

c010250f <vector183>:
.globl vector183
vector183:
  pushl $0
c010250f:	6a 00                	push   $0x0
  pushl $183
c0102511:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102516:	e9 60 03 00 00       	jmp    c010287b <__alltraps>

c010251b <vector184>:
.globl vector184
vector184:
  pushl $0
c010251b:	6a 00                	push   $0x0
  pushl $184
c010251d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102522:	e9 54 03 00 00       	jmp    c010287b <__alltraps>

c0102527 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102527:	6a 00                	push   $0x0
  pushl $185
c0102529:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010252e:	e9 48 03 00 00       	jmp    c010287b <__alltraps>

c0102533 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102533:	6a 00                	push   $0x0
  pushl $186
c0102535:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010253a:	e9 3c 03 00 00       	jmp    c010287b <__alltraps>

c010253f <vector187>:
.globl vector187
vector187:
  pushl $0
c010253f:	6a 00                	push   $0x0
  pushl $187
c0102541:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102546:	e9 30 03 00 00       	jmp    c010287b <__alltraps>

c010254b <vector188>:
.globl vector188
vector188:
  pushl $0
c010254b:	6a 00                	push   $0x0
  pushl $188
c010254d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102552:	e9 24 03 00 00       	jmp    c010287b <__alltraps>

c0102557 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102557:	6a 00                	push   $0x0
  pushl $189
c0102559:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010255e:	e9 18 03 00 00       	jmp    c010287b <__alltraps>

c0102563 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102563:	6a 00                	push   $0x0
  pushl $190
c0102565:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010256a:	e9 0c 03 00 00       	jmp    c010287b <__alltraps>

c010256f <vector191>:
.globl vector191
vector191:
  pushl $0
c010256f:	6a 00                	push   $0x0
  pushl $191
c0102571:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102576:	e9 00 03 00 00       	jmp    c010287b <__alltraps>

c010257b <vector192>:
.globl vector192
vector192:
  pushl $0
c010257b:	6a 00                	push   $0x0
  pushl $192
c010257d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102582:	e9 f4 02 00 00       	jmp    c010287b <__alltraps>

c0102587 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102587:	6a 00                	push   $0x0
  pushl $193
c0102589:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010258e:	e9 e8 02 00 00       	jmp    c010287b <__alltraps>

c0102593 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102593:	6a 00                	push   $0x0
  pushl $194
c0102595:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010259a:	e9 dc 02 00 00       	jmp    c010287b <__alltraps>

c010259f <vector195>:
.globl vector195
vector195:
  pushl $0
c010259f:	6a 00                	push   $0x0
  pushl $195
c01025a1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025a6:	e9 d0 02 00 00       	jmp    c010287b <__alltraps>

c01025ab <vector196>:
.globl vector196
vector196:
  pushl $0
c01025ab:	6a 00                	push   $0x0
  pushl $196
c01025ad:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025b2:	e9 c4 02 00 00       	jmp    c010287b <__alltraps>

c01025b7 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025b7:	6a 00                	push   $0x0
  pushl $197
c01025b9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025be:	e9 b8 02 00 00       	jmp    c010287b <__alltraps>

c01025c3 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025c3:	6a 00                	push   $0x0
  pushl $198
c01025c5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025ca:	e9 ac 02 00 00       	jmp    c010287b <__alltraps>

c01025cf <vector199>:
.globl vector199
vector199:
  pushl $0
c01025cf:	6a 00                	push   $0x0
  pushl $199
c01025d1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025d6:	e9 a0 02 00 00       	jmp    c010287b <__alltraps>

c01025db <vector200>:
.globl vector200
vector200:
  pushl $0
c01025db:	6a 00                	push   $0x0
  pushl $200
c01025dd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025e2:	e9 94 02 00 00       	jmp    c010287b <__alltraps>

c01025e7 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025e7:	6a 00                	push   $0x0
  pushl $201
c01025e9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025ee:	e9 88 02 00 00       	jmp    c010287b <__alltraps>

c01025f3 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025f3:	6a 00                	push   $0x0
  pushl $202
c01025f5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025fa:	e9 7c 02 00 00       	jmp    c010287b <__alltraps>

c01025ff <vector203>:
.globl vector203
vector203:
  pushl $0
c01025ff:	6a 00                	push   $0x0
  pushl $203
c0102601:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102606:	e9 70 02 00 00       	jmp    c010287b <__alltraps>

c010260b <vector204>:
.globl vector204
vector204:
  pushl $0
c010260b:	6a 00                	push   $0x0
  pushl $204
c010260d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102612:	e9 64 02 00 00       	jmp    c010287b <__alltraps>

c0102617 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102617:	6a 00                	push   $0x0
  pushl $205
c0102619:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010261e:	e9 58 02 00 00       	jmp    c010287b <__alltraps>

c0102623 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $206
c0102625:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010262a:	e9 4c 02 00 00       	jmp    c010287b <__alltraps>

c010262f <vector207>:
.globl vector207
vector207:
  pushl $0
c010262f:	6a 00                	push   $0x0
  pushl $207
c0102631:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102636:	e9 40 02 00 00       	jmp    c010287b <__alltraps>

c010263b <vector208>:
.globl vector208
vector208:
  pushl $0
c010263b:	6a 00                	push   $0x0
  pushl $208
c010263d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102642:	e9 34 02 00 00       	jmp    c010287b <__alltraps>

c0102647 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $209
c0102649:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010264e:	e9 28 02 00 00       	jmp    c010287b <__alltraps>

c0102653 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102653:	6a 00                	push   $0x0
  pushl $210
c0102655:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010265a:	e9 1c 02 00 00       	jmp    c010287b <__alltraps>

c010265f <vector211>:
.globl vector211
vector211:
  pushl $0
c010265f:	6a 00                	push   $0x0
  pushl $211
c0102661:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102666:	e9 10 02 00 00       	jmp    c010287b <__alltraps>

c010266b <vector212>:
.globl vector212
vector212:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $212
c010266d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102672:	e9 04 02 00 00       	jmp    c010287b <__alltraps>

c0102677 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102677:	6a 00                	push   $0x0
  pushl $213
c0102679:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010267e:	e9 f8 01 00 00       	jmp    c010287b <__alltraps>

c0102683 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102683:	6a 00                	push   $0x0
  pushl $214
c0102685:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010268a:	e9 ec 01 00 00       	jmp    c010287b <__alltraps>

c010268f <vector215>:
.globl vector215
vector215:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $215
c0102691:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102696:	e9 e0 01 00 00       	jmp    c010287b <__alltraps>

c010269b <vector216>:
.globl vector216
vector216:
  pushl $0
c010269b:	6a 00                	push   $0x0
  pushl $216
c010269d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026a2:	e9 d4 01 00 00       	jmp    c010287b <__alltraps>

c01026a7 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026a7:	6a 00                	push   $0x0
  pushl $217
c01026a9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026ae:	e9 c8 01 00 00       	jmp    c010287b <__alltraps>

c01026b3 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $218
c01026b5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026ba:	e9 bc 01 00 00       	jmp    c010287b <__alltraps>

c01026bf <vector219>:
.globl vector219
vector219:
  pushl $0
c01026bf:	6a 00                	push   $0x0
  pushl $219
c01026c1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026c6:	e9 b0 01 00 00       	jmp    c010287b <__alltraps>

c01026cb <vector220>:
.globl vector220
vector220:
  pushl $0
c01026cb:	6a 00                	push   $0x0
  pushl $220
c01026cd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026d2:	e9 a4 01 00 00       	jmp    c010287b <__alltraps>

c01026d7 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $221
c01026d9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026de:	e9 98 01 00 00       	jmp    c010287b <__alltraps>

c01026e3 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026e3:	6a 00                	push   $0x0
  pushl $222
c01026e5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026ea:	e9 8c 01 00 00       	jmp    c010287b <__alltraps>

c01026ef <vector223>:
.globl vector223
vector223:
  pushl $0
c01026ef:	6a 00                	push   $0x0
  pushl $223
c01026f1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026f6:	e9 80 01 00 00       	jmp    c010287b <__alltraps>

c01026fb <vector224>:
.globl vector224
vector224:
  pushl $0
c01026fb:	6a 00                	push   $0x0
  pushl $224
c01026fd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102702:	e9 74 01 00 00       	jmp    c010287b <__alltraps>

c0102707 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102707:	6a 00                	push   $0x0
  pushl $225
c0102709:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010270e:	e9 68 01 00 00       	jmp    c010287b <__alltraps>

c0102713 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102713:	6a 00                	push   $0x0
  pushl $226
c0102715:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010271a:	e9 5c 01 00 00       	jmp    c010287b <__alltraps>

c010271f <vector227>:
.globl vector227
vector227:
  pushl $0
c010271f:	6a 00                	push   $0x0
  pushl $227
c0102721:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102726:	e9 50 01 00 00       	jmp    c010287b <__alltraps>

c010272b <vector228>:
.globl vector228
vector228:
  pushl $0
c010272b:	6a 00                	push   $0x0
  pushl $228
c010272d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102732:	e9 44 01 00 00       	jmp    c010287b <__alltraps>

c0102737 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102737:	6a 00                	push   $0x0
  pushl $229
c0102739:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010273e:	e9 38 01 00 00       	jmp    c010287b <__alltraps>

c0102743 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102743:	6a 00                	push   $0x0
  pushl $230
c0102745:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010274a:	e9 2c 01 00 00       	jmp    c010287b <__alltraps>

c010274f <vector231>:
.globl vector231
vector231:
  pushl $0
c010274f:	6a 00                	push   $0x0
  pushl $231
c0102751:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102756:	e9 20 01 00 00       	jmp    c010287b <__alltraps>

c010275b <vector232>:
.globl vector232
vector232:
  pushl $0
c010275b:	6a 00                	push   $0x0
  pushl $232
c010275d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102762:	e9 14 01 00 00       	jmp    c010287b <__alltraps>

c0102767 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $233
c0102769:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010276e:	e9 08 01 00 00       	jmp    c010287b <__alltraps>

c0102773 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $234
c0102775:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010277a:	e9 fc 00 00 00       	jmp    c010287b <__alltraps>

c010277f <vector235>:
.globl vector235
vector235:
  pushl $0
c010277f:	6a 00                	push   $0x0
  pushl $235
c0102781:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102786:	e9 f0 00 00 00       	jmp    c010287b <__alltraps>

c010278b <vector236>:
.globl vector236
vector236:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $236
c010278d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102792:	e9 e4 00 00 00       	jmp    c010287b <__alltraps>

c0102797 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $237
c0102799:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010279e:	e9 d8 00 00 00       	jmp    c010287b <__alltraps>

c01027a3 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027a3:	6a 00                	push   $0x0
  pushl $238
c01027a5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027aa:	e9 cc 00 00 00       	jmp    c010287b <__alltraps>

c01027af <vector239>:
.globl vector239
vector239:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $239
c01027b1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027b6:	e9 c0 00 00 00       	jmp    c010287b <__alltraps>

c01027bb <vector240>:
.globl vector240
vector240:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $240
c01027bd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027c2:	e9 b4 00 00 00       	jmp    c010287b <__alltraps>

c01027c7 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027c7:	6a 00                	push   $0x0
  pushl $241
c01027c9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027ce:	e9 a8 00 00 00       	jmp    c010287b <__alltraps>

c01027d3 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $242
c01027d5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027da:	e9 9c 00 00 00       	jmp    c010287b <__alltraps>

c01027df <vector243>:
.globl vector243
vector243:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $243
c01027e1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027e6:	e9 90 00 00 00       	jmp    c010287b <__alltraps>

c01027eb <vector244>:
.globl vector244
vector244:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $244
c01027ed:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027f2:	e9 84 00 00 00       	jmp    c010287b <__alltraps>

c01027f7 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $245
c01027f9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027fe:	e9 78 00 00 00       	jmp    c010287b <__alltraps>

c0102803 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $246
c0102805:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010280a:	e9 6c 00 00 00       	jmp    c010287b <__alltraps>

c010280f <vector247>:
.globl vector247
vector247:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $247
c0102811:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102816:	e9 60 00 00 00       	jmp    c010287b <__alltraps>

c010281b <vector248>:
.globl vector248
vector248:
  pushl $0
c010281b:	6a 00                	push   $0x0
  pushl $248
c010281d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102822:	e9 54 00 00 00       	jmp    c010287b <__alltraps>

c0102827 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $249
c0102829:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010282e:	e9 48 00 00 00       	jmp    c010287b <__alltraps>

c0102833 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $250
c0102835:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010283a:	e9 3c 00 00 00       	jmp    c010287b <__alltraps>

c010283f <vector251>:
.globl vector251
vector251:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $251
c0102841:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102846:	e9 30 00 00 00       	jmp    c010287b <__alltraps>

c010284b <vector252>:
.globl vector252
vector252:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $252
c010284d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102852:	e9 24 00 00 00       	jmp    c010287b <__alltraps>

c0102857 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $253
c0102859:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010285e:	e9 18 00 00 00       	jmp    c010287b <__alltraps>

c0102863 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $254
c0102865:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010286a:	e9 0c 00 00 00       	jmp    c010287b <__alltraps>

c010286f <vector255>:
.globl vector255
vector255:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $255
c0102871:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102876:	e9 00 00 00 00       	jmp    c010287b <__alltraps>

c010287b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010287b:	1e                   	push   %ds
    pushl %es
c010287c:	06                   	push   %es
    pushl %fs
c010287d:	0f a0                	push   %fs
    pushl %gs
c010287f:	0f a8                	push   %gs
    pushal
c0102881:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102882:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102887:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102889:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010288b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010288c:	e8 63 f5 ff ff       	call   c0101df4 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102891:	5c                   	pop    %esp

c0102892 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102892:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102893:	0f a9                	pop    %gs
    popl %fs
c0102895:	0f a1                	pop    %fs
    popl %es
c0102897:	07                   	pop    %es
    popl %ds
c0102898:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102899:	83 c4 08             	add    $0x8,%esp
    iret
c010289c:	cf                   	iret   

c010289d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010289d:	55                   	push   %ebp
c010289e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01028a3:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01028a9:	29 d0                	sub    %edx,%eax
c01028ab:	c1 f8 02             	sar    $0x2,%eax
c01028ae:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028b4:	5d                   	pop    %ebp
c01028b5:	c3                   	ret    

c01028b6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028b6:	55                   	push   %ebp
c01028b7:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01028b9:	ff 75 08             	pushl  0x8(%ebp)
c01028bc:	e8 dc ff ff ff       	call   c010289d <page2ppn>
c01028c1:	83 c4 04             	add    $0x4,%esp
c01028c4:	c1 e0 0c             	shl    $0xc,%eax
}
c01028c7:	c9                   	leave  
c01028c8:	c3                   	ret    

c01028c9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01028c9:	55                   	push   %ebp
c01028ca:	89 e5                	mov    %esp,%ebp
c01028cc:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01028cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d2:	c1 e8 0c             	shr    $0xc,%eax
c01028d5:	89 c2                	mov    %eax,%edx
c01028d7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01028dc:	39 c2                	cmp    %eax,%edx
c01028de:	72 14                	jb     c01028f4 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01028e0:	83 ec 04             	sub    $0x4,%esp
c01028e3:	68 90 61 10 c0       	push   $0xc0106190
c01028e8:	6a 5a                	push   $0x5a
c01028ea:	68 af 61 10 c0       	push   $0xc01061af
c01028ef:	e8 d9 da ff ff       	call   c01003cd <__panic>
    }
    return &pages[PPN(pa)];
c01028f4:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c01028fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01028fd:	c1 e8 0c             	shr    $0xc,%eax
c0102900:	89 c2                	mov    %eax,%edx
c0102902:	89 d0                	mov    %edx,%eax
c0102904:	c1 e0 02             	shl    $0x2,%eax
c0102907:	01 d0                	add    %edx,%eax
c0102909:	c1 e0 02             	shl    $0x2,%eax
c010290c:	01 c8                	add    %ecx,%eax
}
c010290e:	c9                   	leave  
c010290f:	c3                   	ret    

c0102910 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102910:	55                   	push   %ebp
c0102911:	89 e5                	mov    %esp,%ebp
c0102913:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0102916:	ff 75 08             	pushl  0x8(%ebp)
c0102919:	e8 98 ff ff ff       	call   c01028b6 <page2pa>
c010291e:	83 c4 04             	add    $0x4,%esp
c0102921:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102927:	c1 e8 0c             	shr    $0xc,%eax
c010292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010292d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102932:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102935:	72 14                	jb     c010294b <page2kva+0x3b>
c0102937:	ff 75 f4             	pushl  -0xc(%ebp)
c010293a:	68 c0 61 10 c0       	push   $0xc01061c0
c010293f:	6a 61                	push   $0x61
c0102941:	68 af 61 10 c0       	push   $0xc01061af
c0102946:	e8 82 da ff ff       	call   c01003cd <__panic>
c010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102953:	c9                   	leave  
c0102954:	c3                   	ret    

c0102955 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102955:	55                   	push   %ebp
c0102956:	89 e5                	mov    %esp,%ebp
c0102958:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c010295b:	8b 45 08             	mov    0x8(%ebp),%eax
c010295e:	83 e0 01             	and    $0x1,%eax
c0102961:	85 c0                	test   %eax,%eax
c0102963:	75 14                	jne    c0102979 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c0102965:	83 ec 04             	sub    $0x4,%esp
c0102968:	68 e4 61 10 c0       	push   $0xc01061e4
c010296d:	6a 6c                	push   $0x6c
c010296f:	68 af 61 10 c0       	push   $0xc01061af
c0102974:	e8 54 da ff ff       	call   c01003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102979:	8b 45 08             	mov    0x8(%ebp),%eax
c010297c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102981:	83 ec 0c             	sub    $0xc,%esp
c0102984:	50                   	push   %eax
c0102985:	e8 3f ff ff ff       	call   c01028c9 <pa2page>
c010298a:	83 c4 10             	add    $0x10,%esp
}
c010298d:	c9                   	leave  
c010298e:	c3                   	ret    

c010298f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c010298f:	55                   	push   %ebp
c0102990:	89 e5                	mov    %esp,%ebp
c0102992:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c0102995:	8b 45 08             	mov    0x8(%ebp),%eax
c0102998:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010299d:	83 ec 0c             	sub    $0xc,%esp
c01029a0:	50                   	push   %eax
c01029a1:	e8 23 ff ff ff       	call   c01028c9 <pa2page>
c01029a6:	83 c4 10             	add    $0x10,%esp
}
c01029a9:	c9                   	leave  
c01029aa:	c3                   	ret    

c01029ab <page_ref>:

static inline int
page_ref(struct Page *page) {
c01029ab:	55                   	push   %ebp
c01029ac:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01029ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b1:	8b 00                	mov    (%eax),%eax
}
c01029b3:	5d                   	pop    %ebp
c01029b4:	c3                   	ret    

c01029b5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01029b5:	55                   	push   %ebp
c01029b6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01029b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029be:	89 10                	mov    %edx,(%eax)
}
c01029c0:	90                   	nop
c01029c1:	5d                   	pop    %ebp
c01029c2:	c3                   	ret    

c01029c3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01029c3:	55                   	push   %ebp
c01029c4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01029c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c9:	8b 00                	mov    (%eax),%eax
c01029cb:	8d 50 01             	lea    0x1(%eax),%edx
c01029ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d1:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01029d6:	8b 00                	mov    (%eax),%eax
}
c01029d8:	5d                   	pop    %ebp
c01029d9:	c3                   	ret    

c01029da <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01029da:	55                   	push   %ebp
c01029db:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01029dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e0:	8b 00                	mov    (%eax),%eax
c01029e2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01029e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01029ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ed:	8b 00                	mov    (%eax),%eax
}
c01029ef:	5d                   	pop    %ebp
c01029f0:	c3                   	ret    

c01029f1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01029f1:	55                   	push   %ebp
c01029f2:	89 e5                	mov    %esp,%ebp
c01029f4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01029f7:	9c                   	pushf  
c01029f8:	58                   	pop    %eax
c01029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01029ff:	25 00 02 00 00       	and    $0x200,%eax
c0102a04:	85 c0                	test   %eax,%eax
c0102a06:	74 0c                	je     c0102a14 <__intr_save+0x23>
        intr_disable();
c0102a08:	e8 5a ee ff ff       	call   c0101867 <intr_disable>
        return 1;
c0102a0d:	b8 01 00 00 00       	mov    $0x1,%eax
c0102a12:	eb 05                	jmp    c0102a19 <__intr_save+0x28>
    }
    return 0;
c0102a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102a19:	c9                   	leave  
c0102a1a:	c3                   	ret    

c0102a1b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102a1b:	55                   	push   %ebp
c0102a1c:	89 e5                	mov    %esp,%ebp
c0102a1e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a25:	74 05                	je     c0102a2c <__intr_restore+0x11>
        intr_enable();
c0102a27:	e8 34 ee ff ff       	call   c0101860 <intr_enable>
    }
}
c0102a2c:	90                   	nop
c0102a2d:	c9                   	leave  
c0102a2e:	c3                   	ret    

c0102a2f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102a2f:	55                   	push   %ebp
c0102a30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a35:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102a38:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a3d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102a3f:	b8 23 00 00 00       	mov    $0x23,%eax
c0102a44:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102a46:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a4b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102a4d:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a52:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102a54:	b8 10 00 00 00       	mov    $0x10,%eax
c0102a59:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102a5b:	ea 62 2a 10 c0 08 00 	ljmp   $0x8,$0xc0102a62
}
c0102a62:	90                   	nop
c0102a63:	5d                   	pop    %ebp
c0102a64:	c3                   	ret    

c0102a65 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102a65:	55                   	push   %ebp
c0102a66:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6b:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0102a70:	90                   	nop
c0102a71:	5d                   	pop    %ebp
c0102a72:	c3                   	ret    

c0102a73 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a73:	55                   	push   %ebp
c0102a74:	89 e5                	mov    %esp,%ebp
c0102a76:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a79:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a7e:	50                   	push   %eax
c0102a7f:	e8 e1 ff ff ff       	call   c0102a65 <load_esp0>
c0102a84:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0102a87:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102a8e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a90:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a97:	68 00 
c0102a99:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102a9e:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102aa4:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102aa9:	c1 e8 10             	shr    $0x10,%eax
c0102aac:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102ab1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ab8:	83 e0 f0             	and    $0xfffffff0,%eax
c0102abb:	83 c8 09             	or     $0x9,%eax
c0102abe:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ac3:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102aca:	83 e0 ef             	and    $0xffffffef,%eax
c0102acd:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ad2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ad9:	83 e0 9f             	and    $0xffffff9f,%eax
c0102adc:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102ae1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102ae8:	83 c8 80             	or     $0xffffff80,%eax
c0102aeb:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102af0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102af7:	83 e0 f0             	and    $0xfffffff0,%eax
c0102afa:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aff:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b06:	83 e0 ef             	and    $0xffffffef,%eax
c0102b09:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b0e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b15:	83 e0 df             	and    $0xffffffdf,%eax
c0102b18:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b1d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b24:	83 c8 40             	or     $0x40,%eax
c0102b27:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b2c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102b33:	83 e0 7f             	and    $0x7f,%eax
c0102b36:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102b3b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102b40:	c1 e8 18             	shr    $0x18,%eax
c0102b43:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102b48:	68 30 7a 11 c0       	push   $0xc0117a30
c0102b4d:	e8 dd fe ff ff       	call   c0102a2f <lgdt>
c0102b52:	83 c4 04             	add    $0x4,%esp
c0102b55:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102b5b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102b5f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102b62:	90                   	nop
c0102b63:	c9                   	leave  
c0102b64:	c3                   	ret    

c0102b65 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102b65:	55                   	push   %ebp
c0102b66:	89 e5                	mov    %esp,%ebp
c0102b68:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0102b6b:	c7 05 50 89 11 c0 58 	movl   $0xc0106b58,0xc0118950
c0102b72:	6b 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b75:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b7a:	8b 00                	mov    (%eax),%eax
c0102b7c:	83 ec 08             	sub    $0x8,%esp
c0102b7f:	50                   	push   %eax
c0102b80:	68 10 62 10 c0       	push   $0xc0106210
c0102b85:	e8 dd d6 ff ff       	call   c0100267 <cprintf>
c0102b8a:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0102b8d:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102b92:	8b 40 04             	mov    0x4(%eax),%eax
c0102b95:	ff d0                	call   *%eax
}
c0102b97:	90                   	nop
c0102b98:	c9                   	leave  
c0102b99:	c3                   	ret    

c0102b9a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b9a:	55                   	push   %ebp
c0102b9b:	89 e5                	mov    %esp,%ebp
c0102b9d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0102ba0:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba8:	83 ec 08             	sub    $0x8,%esp
c0102bab:	ff 75 0c             	pushl  0xc(%ebp)
c0102bae:	ff 75 08             	pushl  0x8(%ebp)
c0102bb1:	ff d0                	call   *%eax
c0102bb3:	83 c4 10             	add    $0x10,%esp
}
c0102bb6:	90                   	nop
c0102bb7:	c9                   	leave  
c0102bb8:	c3                   	ret    

c0102bb9 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102bb9:	55                   	push   %ebp
c0102bba:	89 e5                	mov    %esp,%ebp
c0102bbc:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0102bbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bc6:	e8 26 fe ff ff       	call   c01029f1 <__intr_save>
c0102bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102bce:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102bd3:	8b 40 0c             	mov    0xc(%eax),%eax
c0102bd6:	83 ec 0c             	sub    $0xc,%esp
c0102bd9:	ff 75 08             	pushl  0x8(%ebp)
c0102bdc:	ff d0                	call   *%eax
c0102bde:	83 c4 10             	add    $0x10,%esp
c0102be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102be4:	83 ec 0c             	sub    $0xc,%esp
c0102be7:	ff 75 f0             	pushl  -0x10(%ebp)
c0102bea:	e8 2c fe ff ff       	call   c0102a1b <__intr_restore>
c0102bef:	83 c4 10             	add    $0x10,%esp
    return page;
c0102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bf5:	c9                   	leave  
c0102bf6:	c3                   	ret    

c0102bf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102bf7:	55                   	push   %ebp
c0102bf8:	89 e5                	mov    %esp,%ebp
c0102bfa:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bfd:	e8 ef fd ff ff       	call   c01029f1 <__intr_save>
c0102c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102c05:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102c0a:	8b 40 10             	mov    0x10(%eax),%eax
c0102c0d:	83 ec 08             	sub    $0x8,%esp
c0102c10:	ff 75 0c             	pushl  0xc(%ebp)
c0102c13:	ff 75 08             	pushl  0x8(%ebp)
c0102c16:	ff d0                	call   *%eax
c0102c18:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0102c1b:	83 ec 0c             	sub    $0xc,%esp
c0102c1e:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c21:	e8 f5 fd ff ff       	call   c0102a1b <__intr_restore>
c0102c26:	83 c4 10             	add    $0x10,%esp
}
c0102c29:	90                   	nop
c0102c2a:	c9                   	leave  
c0102c2b:	c3                   	ret    

c0102c2c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102c2c:	55                   	push   %ebp
c0102c2d:	89 e5                	mov    %esp,%ebp
c0102c2f:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102c32:	e8 ba fd ff ff       	call   c01029f1 <__intr_save>
c0102c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102c3a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102c3f:	8b 40 14             	mov    0x14(%eax),%eax
c0102c42:	ff d0                	call   *%eax
c0102c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102c47:	83 ec 0c             	sub    $0xc,%esp
c0102c4a:	ff 75 f4             	pushl  -0xc(%ebp)
c0102c4d:	e8 c9 fd ff ff       	call   c0102a1b <__intr_restore>
c0102c52:	83 c4 10             	add    $0x10,%esp
    return ret;
c0102c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c58:	c9                   	leave  
c0102c59:	c3                   	ret    

c0102c5a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102c5a:	55                   	push   %ebp
c0102c5b:	89 e5                	mov    %esp,%ebp
c0102c5d:	57                   	push   %edi
c0102c5e:	56                   	push   %esi
c0102c5f:	53                   	push   %ebx
c0102c60:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102c63:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102c71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102c78:	83 ec 0c             	sub    $0xc,%esp
c0102c7b:	68 27 62 10 c0       	push   $0xc0106227
c0102c80:	e8 e2 d5 ff ff       	call   c0100267 <cprintf>
c0102c85:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c8f:	e9 fc 00 00 00       	jmp    c0102d90 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c94:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c97:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c9a:	89 d0                	mov    %edx,%eax
c0102c9c:	c1 e0 02             	shl    $0x2,%eax
c0102c9f:	01 d0                	add    %edx,%eax
c0102ca1:	c1 e0 02             	shl    $0x2,%eax
c0102ca4:	01 c8                	add    %ecx,%eax
c0102ca6:	8b 50 08             	mov    0x8(%eax),%edx
c0102ca9:	8b 40 04             	mov    0x4(%eax),%eax
c0102cac:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102caf:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102cb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cb8:	89 d0                	mov    %edx,%eax
c0102cba:	c1 e0 02             	shl    $0x2,%eax
c0102cbd:	01 d0                	add    %edx,%eax
c0102cbf:	c1 e0 02             	shl    $0x2,%eax
c0102cc2:	01 c8                	add    %ecx,%eax
c0102cc4:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102cc7:	8b 58 10             	mov    0x10(%eax),%ebx
c0102cca:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ccd:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cd0:	01 c8                	add    %ecx,%eax
c0102cd2:	11 da                	adc    %ebx,%edx
c0102cd4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102cd7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102cda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102cdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ce0:	89 d0                	mov    %edx,%eax
c0102ce2:	c1 e0 02             	shl    $0x2,%eax
c0102ce5:	01 d0                	add    %edx,%eax
c0102ce7:	c1 e0 02             	shl    $0x2,%eax
c0102cea:	01 c8                	add    %ecx,%eax
c0102cec:	83 c0 14             	add    $0x14,%eax
c0102cef:	8b 00                	mov    (%eax),%eax
c0102cf1:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102cf4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102cf7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102cfa:	83 c0 ff             	add    $0xffffffff,%eax
c0102cfd:	83 d2 ff             	adc    $0xffffffff,%edx
c0102d00:	89 c1                	mov    %eax,%ecx
c0102d02:	89 d3                	mov    %edx,%ebx
c0102d04:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d07:	89 55 80             	mov    %edx,-0x80(%ebp)
c0102d0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d0d:	89 d0                	mov    %edx,%eax
c0102d0f:	c1 e0 02             	shl    $0x2,%eax
c0102d12:	01 d0                	add    %edx,%eax
c0102d14:	c1 e0 02             	shl    $0x2,%eax
c0102d17:	03 45 80             	add    -0x80(%ebp),%eax
c0102d1a:	8b 50 10             	mov    0x10(%eax),%edx
c0102d1d:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d20:	ff 75 84             	pushl  -0x7c(%ebp)
c0102d23:	53                   	push   %ebx
c0102d24:	51                   	push   %ecx
c0102d25:	ff 75 bc             	pushl  -0x44(%ebp)
c0102d28:	ff 75 b8             	pushl  -0x48(%ebp)
c0102d2b:	52                   	push   %edx
c0102d2c:	50                   	push   %eax
c0102d2d:	68 34 62 10 c0       	push   $0xc0106234
c0102d32:	e8 30 d5 ff ff       	call   c0100267 <cprintf>
c0102d37:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102d3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d40:	89 d0                	mov    %edx,%eax
c0102d42:	c1 e0 02             	shl    $0x2,%eax
c0102d45:	01 d0                	add    %edx,%eax
c0102d47:	c1 e0 02             	shl    $0x2,%eax
c0102d4a:	01 c8                	add    %ecx,%eax
c0102d4c:	83 c0 14             	add    $0x14,%eax
c0102d4f:	8b 00                	mov    (%eax),%eax
c0102d51:	83 f8 01             	cmp    $0x1,%eax
c0102d54:	75 36                	jne    c0102d8c <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
c0102d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d5c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d5f:	77 2b                	ja     c0102d8c <page_init+0x132>
c0102d61:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102d64:	72 05                	jb     c0102d6b <page_init+0x111>
c0102d66:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102d69:	73 21                	jae    c0102d8c <page_init+0x132>
c0102d6b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d6f:	77 1b                	ja     c0102d8c <page_init+0x132>
c0102d71:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102d75:	72 09                	jb     c0102d80 <page_init+0x126>
c0102d77:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102d7e:	77 0c                	ja     c0102d8c <page_init+0x132>
                maxpa = end;
c0102d80:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102d83:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d86:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d8c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d93:	8b 00                	mov    (%eax),%eax
c0102d95:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102d98:	0f 8f f6 fe ff ff    	jg     c0102c94 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102da2:	72 1d                	jb     c0102dc1 <page_init+0x167>
c0102da4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102da8:	77 09                	ja     c0102db3 <page_init+0x159>
c0102daa:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102db1:	76 0e                	jbe    c0102dc1 <page_init+0x167>
        maxpa = KMEMSIZE;
c0102db3:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102dba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102dc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102dc7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102dcb:	c1 ea 0c             	shr    $0xc,%edx
c0102dce:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102dd3:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102dda:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102ddf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102de2:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102de5:	01 d0                	add    %edx,%eax
c0102de7:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102dea:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102ded:	ba 00 00 00 00       	mov    $0x0,%edx
c0102df2:	f7 75 ac             	divl   -0x54(%ebp)
c0102df5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102df8:	29 d0                	sub    %edx,%eax
c0102dfa:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102dff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e06:	eb 2f                	jmp    c0102e37 <page_init+0x1dd>
        SetPageReserved(pages + i);
c0102e08:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e11:	89 d0                	mov    %edx,%eax
c0102e13:	c1 e0 02             	shl    $0x2,%eax
c0102e16:	01 d0                	add    %edx,%eax
c0102e18:	c1 e0 02             	shl    $0x2,%eax
c0102e1b:	01 c8                	add    %ecx,%eax
c0102e1d:	83 c0 04             	add    $0x4,%eax
c0102e20:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102e27:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e2a:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e2d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e30:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102e33:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102e37:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e3a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102e3f:	39 c2                	cmp    %eax,%edx
c0102e41:	72 c5                	jb     c0102e08 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102e43:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102e49:	89 d0                	mov    %edx,%eax
c0102e4b:	c1 e0 02             	shl    $0x2,%eax
c0102e4e:	01 d0                	add    %edx,%eax
c0102e50:	c1 e0 02             	shl    $0x2,%eax
c0102e53:	89 c2                	mov    %eax,%edx
c0102e55:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102e5a:	01 d0                	add    %edx,%eax
c0102e5c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102e5f:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102e66:	77 17                	ja     c0102e7f <page_init+0x225>
c0102e68:	ff 75 a4             	pushl  -0x5c(%ebp)
c0102e6b:	68 64 62 10 c0       	push   $0xc0106264
c0102e70:	68 db 00 00 00       	push   $0xdb
c0102e75:	68 88 62 10 c0       	push   $0xc0106288
c0102e7a:	e8 4e d5 ff ff       	call   c01003cd <__panic>
c0102e7f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e82:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e87:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e91:	e9 69 01 00 00       	jmp    c0102fff <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e96:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e9c:	89 d0                	mov    %edx,%eax
c0102e9e:	c1 e0 02             	shl    $0x2,%eax
c0102ea1:	01 d0                	add    %edx,%eax
c0102ea3:	c1 e0 02             	shl    $0x2,%eax
c0102ea6:	01 c8                	add    %ecx,%eax
c0102ea8:	8b 50 08             	mov    0x8(%eax),%edx
c0102eab:	8b 40 04             	mov    0x4(%eax),%eax
c0102eae:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102eb1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102eb4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102eb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102eba:	89 d0                	mov    %edx,%eax
c0102ebc:	c1 e0 02             	shl    $0x2,%eax
c0102ebf:	01 d0                	add    %edx,%eax
c0102ec1:	c1 e0 02             	shl    $0x2,%eax
c0102ec4:	01 c8                	add    %ecx,%eax
c0102ec6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ec9:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ecc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ecf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ed2:	01 c8                	add    %ecx,%eax
c0102ed4:	11 da                	adc    %ebx,%edx
c0102ed6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ed9:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102edc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102edf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ee2:	89 d0                	mov    %edx,%eax
c0102ee4:	c1 e0 02             	shl    $0x2,%eax
c0102ee7:	01 d0                	add    %edx,%eax
c0102ee9:	c1 e0 02             	shl    $0x2,%eax
c0102eec:	01 c8                	add    %ecx,%eax
c0102eee:	83 c0 14             	add    $0x14,%eax
c0102ef1:	8b 00                	mov    (%eax),%eax
c0102ef3:	83 f8 01             	cmp    $0x1,%eax
c0102ef6:	0f 85 ff 00 00 00    	jne    c0102ffb <page_init+0x3a1>
            if (begin < freemem) {
c0102efc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102eff:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f04:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f07:	72 17                	jb     c0102f20 <page_init+0x2c6>
c0102f09:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102f0c:	77 05                	ja     c0102f13 <page_init+0x2b9>
c0102f0e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102f11:	76 0d                	jbe    c0102f20 <page_init+0x2c6>
                begin = freemem;
c0102f13:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102f16:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f19:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102f20:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f24:	72 1d                	jb     c0102f43 <page_init+0x2e9>
c0102f26:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102f2a:	77 09                	ja     c0102f35 <page_init+0x2db>
c0102f2c:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102f33:	76 0e                	jbe    c0102f43 <page_init+0x2e9>
                end = KMEMSIZE;
c0102f35:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102f3c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102f43:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f49:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f4c:	0f 87 a9 00 00 00    	ja     c0102ffb <page_init+0x3a1>
c0102f52:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f55:	72 09                	jb     c0102f60 <page_init+0x306>
c0102f57:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f5a:	0f 83 9b 00 00 00    	jae    c0102ffb <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
c0102f60:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102f67:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f6a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102f6d:	01 d0                	add    %edx,%eax
c0102f6f:	83 e8 01             	sub    $0x1,%eax
c0102f72:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102f75:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f78:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f7d:	f7 75 9c             	divl   -0x64(%ebp)
c0102f80:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102f83:	29 d0                	sub    %edx,%eax
c0102f85:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f8d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f90:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f93:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102f96:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f99:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f9e:	89 c3                	mov    %eax,%ebx
c0102fa0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102fa6:	89 de                	mov    %ebx,%esi
c0102fa8:	89 d0                	mov    %edx,%eax
c0102faa:	83 e0 00             	and    $0x0,%eax
c0102fad:	89 c7                	mov    %eax,%edi
c0102faf:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102fb2:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102fb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102fbb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fbe:	77 3b                	ja     c0102ffb <page_init+0x3a1>
c0102fc0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102fc3:	72 05                	jb     c0102fca <page_init+0x370>
c0102fc5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102fc8:	73 31                	jae    c0102ffb <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102fca:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fcd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102fd0:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102fd3:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102fd6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102fda:	c1 ea 0c             	shr    $0xc,%edx
c0102fdd:	89 c3                	mov    %eax,%ebx
c0102fdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102fe2:	83 ec 0c             	sub    $0xc,%esp
c0102fe5:	50                   	push   %eax
c0102fe6:	e8 de f8 ff ff       	call   c01028c9 <pa2page>
c0102feb:	83 c4 10             	add    $0x10,%esp
c0102fee:	83 ec 08             	sub    $0x8,%esp
c0102ff1:	53                   	push   %ebx
c0102ff2:	50                   	push   %eax
c0102ff3:	e8 a2 fb ff ff       	call   c0102b9a <init_memmap>
c0102ff8:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0102ffb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102fff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103002:	8b 00                	mov    (%eax),%eax
c0103004:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103007:	0f 8f 89 fe ff ff    	jg     c0102e96 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010300d:	90                   	nop
c010300e:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103011:	5b                   	pop    %ebx
c0103012:	5e                   	pop    %esi
c0103013:	5f                   	pop    %edi
c0103014:	5d                   	pop    %ebp
c0103015:	c3                   	ret    

c0103016 <enable_paging>:

static void
enable_paging(void) {
c0103016:	55                   	push   %ebp
c0103017:	89 e5                	mov    %esp,%ebp
c0103019:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010301c:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0103021:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103024:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103027:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010302a:	0f 20 c0             	mov    %cr0,%eax
c010302d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103030:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103033:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103036:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010303d:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0103041:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103044:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103047:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010304a:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010304d:	90                   	nop
c010304e:	c9                   	leave  
c010304f:	c3                   	ret    

c0103050 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103050:	55                   	push   %ebp
c0103051:	89 e5                	mov    %esp,%ebp
c0103053:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103056:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103059:	33 45 14             	xor    0x14(%ebp),%eax
c010305c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103061:	85 c0                	test   %eax,%eax
c0103063:	74 19                	je     c010307e <boot_map_segment+0x2e>
c0103065:	68 96 62 10 c0       	push   $0xc0106296
c010306a:	68 ad 62 10 c0       	push   $0xc01062ad
c010306f:	68 04 01 00 00       	push   $0x104
c0103074:	68 88 62 10 c0       	push   $0xc0106288
c0103079:	e8 4f d3 ff ff       	call   c01003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010307e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103085:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103088:	25 ff 0f 00 00       	and    $0xfff,%eax
c010308d:	89 c2                	mov    %eax,%edx
c010308f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103092:	01 c2                	add    %eax,%edx
c0103094:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103097:	01 d0                	add    %edx,%eax
c0103099:	83 e8 01             	sub    $0x1,%eax
c010309c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010309f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030a2:	ba 00 00 00 00       	mov    $0x0,%edx
c01030a7:	f7 75 f0             	divl   -0x10(%ebp)
c01030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030ad:	29 d0                	sub    %edx,%eax
c01030af:	c1 e8 0c             	shr    $0xc,%eax
c01030b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01030b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01030be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030c3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01030c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01030c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01030cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01030cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01030d4:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030d7:	eb 57                	jmp    c0103130 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01030d9:	83 ec 04             	sub    $0x4,%esp
c01030dc:	6a 01                	push   $0x1
c01030de:	ff 75 0c             	pushl  0xc(%ebp)
c01030e1:	ff 75 08             	pushl  0x8(%ebp)
c01030e4:	e8 98 01 00 00       	call   c0103281 <get_pte>
c01030e9:	83 c4 10             	add    $0x10,%esp
c01030ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01030ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01030f3:	75 19                	jne    c010310e <boot_map_segment+0xbe>
c01030f5:	68 c2 62 10 c0       	push   $0xc01062c2
c01030fa:	68 ad 62 10 c0       	push   $0xc01062ad
c01030ff:	68 0a 01 00 00       	push   $0x10a
c0103104:	68 88 62 10 c0       	push   $0xc0106288
c0103109:	e8 bf d2 ff ff       	call   c01003cd <__panic>
        *ptep = pa | PTE_P | perm;
c010310e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103111:	0b 45 18             	or     0x18(%ebp),%eax
c0103114:	83 c8 01             	or     $0x1,%eax
c0103117:	89 c2                	mov    %eax,%edx
c0103119:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010311c:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010311e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103122:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103129:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0103130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103134:	75 a3                	jne    c01030d9 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0103136:	90                   	nop
c0103137:	c9                   	leave  
c0103138:	c3                   	ret    

c0103139 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103139:	55                   	push   %ebp
c010313a:	89 e5                	mov    %esp,%ebp
c010313c:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c010313f:	83 ec 0c             	sub    $0xc,%esp
c0103142:	6a 01                	push   $0x1
c0103144:	e8 70 fa ff ff       	call   c0102bb9 <alloc_pages>
c0103149:	83 c4 10             	add    $0x10,%esp
c010314c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010314f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103153:	75 17                	jne    c010316c <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0103155:	83 ec 04             	sub    $0x4,%esp
c0103158:	68 cf 62 10 c0       	push   $0xc01062cf
c010315d:	68 16 01 00 00       	push   $0x116
c0103162:	68 88 62 10 c0       	push   $0xc0106288
c0103167:	e8 61 d2 ff ff       	call   c01003cd <__panic>
    }
    return page2kva(p);
c010316c:	83 ec 0c             	sub    $0xc,%esp
c010316f:	ff 75 f4             	pushl  -0xc(%ebp)
c0103172:	e8 99 f7 ff ff       	call   c0102910 <page2kva>
c0103177:	83 c4 10             	add    $0x10,%esp
}
c010317a:	c9                   	leave  
c010317b:	c3                   	ret    

c010317c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010317c:	55                   	push   %ebp
c010317d:	89 e5                	mov    %esp,%ebp
c010317f:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103182:	e8 de f9 ff ff       	call   c0102b65 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103187:	e8 ce fa ff ff       	call   c0102c5a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010318c:	e8 0a 04 00 00       	call   c010359b <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0103191:	e8 a3 ff ff ff       	call   c0103139 <boot_alloc_page>
c0103196:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010319b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031a0:	83 ec 04             	sub    $0x4,%esp
c01031a3:	68 00 10 00 00       	push   $0x1000
c01031a8:	6a 00                	push   $0x0
c01031aa:	50                   	push   %eax
c01031ab:	e8 1d 21 00 00       	call   c01052cd <memset>
c01031b0:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
c01031b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031bb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01031c2:	77 17                	ja     c01031db <pmm_init+0x5f>
c01031c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01031c7:	68 64 62 10 c0       	push   $0xc0106264
c01031cc:	68 30 01 00 00       	push   $0x130
c01031d1:	68 88 62 10 c0       	push   $0xc0106288
c01031d6:	e8 f2 d1 ff ff       	call   c01003cd <__panic>
c01031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031de:	05 00 00 00 40       	add    $0x40000000,%eax
c01031e3:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c01031e8:	e8 d1 03 00 00       	call   c01035be <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01031ed:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031f2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01031f8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01031fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103200:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103207:	77 17                	ja     c0103220 <pmm_init+0xa4>
c0103209:	ff 75 f0             	pushl  -0x10(%ebp)
c010320c:	68 64 62 10 c0       	push   $0xc0106264
c0103211:	68 38 01 00 00       	push   $0x138
c0103216:	68 88 62 10 c0       	push   $0xc0106288
c010321b:	e8 ad d1 ff ff       	call   c01003cd <__panic>
c0103220:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103223:	05 00 00 00 40       	add    $0x40000000,%eax
c0103228:	83 c8 03             	or     $0x3,%eax
c010322b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010322d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103232:	83 ec 0c             	sub    $0xc,%esp
c0103235:	6a 02                	push   $0x2
c0103237:	6a 00                	push   $0x0
c0103239:	68 00 00 00 38       	push   $0x38000000
c010323e:	68 00 00 00 c0       	push   $0xc0000000
c0103243:	50                   	push   %eax
c0103244:	e8 07 fe ff ff       	call   c0103050 <boot_map_segment>
c0103249:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010324c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103251:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0103257:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010325d:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010325f:	e8 b2 fd ff ff       	call   c0103016 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0103264:	e8 0a f8 ff ff       	call   c0102a73 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103269:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010326e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0103274:	e8 ab 08 00 00       	call   c0103b24 <check_boot_pgdir>

    print_pgdir();
c0103279:	e8 a1 0c 00 00       	call   c0103f1f <print_pgdir>

}
c010327e:	90                   	nop
c010327f:	c9                   	leave  
c0103280:	c3                   	ret    

c0103281 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0103281:	55                   	push   %ebp
c0103282:	89 e5                	mov    %esp,%ebp
c0103284:	83 ec 28             	sub    $0x28,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
//尝试获取页表，注：typedef uintptr_t pte_t;  
    pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry  
c0103287:	8b 45 0c             	mov    0xc(%ebp),%eax
c010328a:	c1 e8 16             	shr    $0x16,%eax
c010328d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103294:	8b 45 08             	mov    0x8(%ebp),%eax
c0103297:	01 d0                	add    %edx,%eax
c0103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //若获取不成功则执行下面的语句  
	if (!(*pdep & PTE_P)) {               
c010329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010329f:	8b 00                	mov    (%eax),%eax
c01032a1:	83 e0 01             	and    $0x1,%eax
c01032a4:	85 c0                	test   %eax,%eax
c01032a6:	0f 85 9f 00 00 00    	jne    c010334b <get_pte+0xca>
        	//申请一页  
	    struct Page *page;  
	    if(!create || (page = alloc_page())==NULL){  
c01032ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01032b0:	74 16                	je     c01032c8 <get_pte+0x47>
c01032b2:	83 ec 0c             	sub    $0xc,%esp
c01032b5:	6a 01                	push   $0x1
c01032b7:	e8 fd f8 ff ff       	call   c0102bb9 <alloc_pages>
c01032bc:	83 c4 10             	add    $0x10,%esp
c01032bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01032c6:	75 0a                	jne    c01032d2 <get_pte+0x51>
	        return NULL;  
c01032c8:	b8 00 00 00 00       	mov    $0x0,%eax
c01032cd:	e9 ca 00 00 00       	jmp    c010339c <get_pte+0x11b>
	    }   
	    //引用次数需要加1  
	    set_page_ref(page, 1);  
c01032d2:	83 ec 08             	sub    $0x8,%esp
c01032d5:	6a 01                	push   $0x1
c01032d7:	ff 75 f0             	pushl  -0x10(%ebp)
c01032da:	e8 d6 f6 ff ff       	call   c01029b5 <set_page_ref>
c01032df:	83 c4 10             	add    $0x10,%esp
	    //获取页的线性地址                     
            uintptr_t pa = page2pa(page);   
c01032e2:	83 ec 0c             	sub    $0xc,%esp
c01032e5:	ff 75 f0             	pushl  -0x10(%ebp)
c01032e8:	e8 c9 f5 ff ff       	call   c01028b6 <page2pa>
c01032ed:	83 c4 10             	add    $0x10,%esp
c01032f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa), 0, PGSIZE);  
c01032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032fc:	c1 e8 0c             	shr    $0xc,%eax
c01032ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103302:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103307:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010330a:	72 17                	jb     c0103323 <get_pte+0xa2>
c010330c:	ff 75 e8             	pushl  -0x18(%ebp)
c010330f:	68 c0 61 10 c0       	push   $0xc01061c0
c0103314:	68 8c 01 00 00       	push   $0x18c
c0103319:	68 88 62 10 c0       	push   $0xc0106288
c010331e:	e8 aa d0 ff ff       	call   c01003cd <__panic>
c0103323:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103326:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010332b:	83 ec 04             	sub    $0x4,%esp
c010332e:	68 00 10 00 00       	push   $0x1000
c0103333:	6a 00                	push   $0x0
c0103335:	50                   	push   %eax
c0103336:	e8 92 1f 00 00       	call   c01052cd <memset>
c010333b:	83 c4 10             	add    $0x10,%esp
            //设置权限  
	    *pdep  = pa | PTE_U | PTE_W | PTE_P;                   
c010333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103341:	83 c8 07             	or     $0x7,%eax
c0103344:	89 c2                	mov    %eax,%edx
c0103346:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103349:	89 10                	mov    %edx,(%eax)
	}  
	//返回页表地址  
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];    
c010334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010334e:	8b 00                	mov    (%eax),%eax
c0103350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103355:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103358:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010335b:	c1 e8 0c             	shr    $0xc,%eax
c010335e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103361:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103366:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103369:	72 17                	jb     c0103382 <get_pte+0x101>
c010336b:	ff 75 e0             	pushl  -0x20(%ebp)
c010336e:	68 c0 61 10 c0       	push   $0xc01061c0
c0103373:	68 91 01 00 00       	push   $0x191
c0103378:	68 88 62 10 c0       	push   $0xc0106288
c010337d:	e8 4b d0 ff ff       	call   c01003cd <__panic>
c0103382:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103385:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010338a:	89 c2                	mov    %eax,%edx
c010338c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010338f:	c1 e8 0c             	shr    $0xc,%eax
c0103392:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103397:	c1 e0 02             	shl    $0x2,%eax
c010339a:	01 d0                	add    %edx,%eax
}
c010339c:	c9                   	leave  
c010339d:	c3                   	ret    

c010339e <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010339e:	55                   	push   %ebp
c010339f:	89 e5                	mov    %esp,%ebp
c01033a1:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01033a4:	83 ec 04             	sub    $0x4,%esp
c01033a7:	6a 00                	push   $0x0
c01033a9:	ff 75 0c             	pushl  0xc(%ebp)
c01033ac:	ff 75 08             	pushl  0x8(%ebp)
c01033af:	e8 cd fe ff ff       	call   c0103281 <get_pte>
c01033b4:	83 c4 10             	add    $0x10,%esp
c01033b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01033ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033be:	74 08                	je     c01033c8 <get_page+0x2a>
        *ptep_store = ptep;
c01033c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01033c6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033cc:	74 1f                	je     c01033ed <get_page+0x4f>
c01033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033d1:	8b 00                	mov    (%eax),%eax
c01033d3:	83 e0 01             	and    $0x1,%eax
c01033d6:	85 c0                	test   %eax,%eax
c01033d8:	74 13                	je     c01033ed <get_page+0x4f>
        return pte2page(*ptep);
c01033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033dd:	8b 00                	mov    (%eax),%eax
c01033df:	83 ec 0c             	sub    $0xc,%esp
c01033e2:	50                   	push   %eax
c01033e3:	e8 6d f5 ff ff       	call   c0102955 <pte2page>
c01033e8:	83 c4 10             	add    $0x10,%esp
c01033eb:	eb 05                	jmp    c01033f2 <get_page+0x54>
    }
    return NULL;
c01033ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01033f2:	c9                   	leave  
c01033f3:	c3                   	ret    

c01033f4 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01033f4:	55                   	push   %ebp
c01033f5:	89 e5                	mov    %esp,%ebp
c01033f7:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

	if (*ptep & PTE_P) {                    //判断页表中该表项是否存在
c01033fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01033fd:	8b 00                	mov    (%eax),%eax
c01033ff:	83 e0 01             	and    $0x1,%eax
c0103402:	85 c0                	test   %eax,%eax
c0103404:	74 50                	je     c0103456 <page_remove_pte+0x62>
	    struct Page *page = pte2page(*ptep);
c0103406:	8b 45 10             	mov    0x10(%ebp),%eax
c0103409:	8b 00                	mov    (%eax),%eax
c010340b:	83 ec 0c             	sub    $0xc,%esp
c010340e:	50                   	push   %eax
c010340f:	e8 41 f5 ff ff       	call   c0102955 <pte2page>
c0103414:	83 c4 10             	add    $0x10,%esp
c0103417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (page_ref_dec(page) == 0) {      //判断是否只被引用了一次
c010341a:	83 ec 0c             	sub    $0xc,%esp
c010341d:	ff 75 f4             	pushl  -0xc(%ebp)
c0103420:	e8 b5 f5 ff ff       	call   c01029da <page_ref_dec>
c0103425:	83 c4 10             	add    $0x10,%esp
c0103428:	85 c0                	test   %eax,%eax
c010342a:	75 10                	jne    c010343c <page_remove_pte+0x48>
		free_page(page);                //如果只被引用了一次，那么可以释放掉此页
c010342c:	83 ec 08             	sub    $0x8,%esp
c010342f:	6a 01                	push   $0x1
c0103431:	ff 75 f4             	pushl  -0xc(%ebp)
c0103434:	e8 be f7 ff ff       	call   c0102bf7 <free_pages>
c0103439:	83 c4 10             	add    $0x10,%esp
	    }
	    *ptep = 0;                          //如果被多次引用，则不能释放此页，只用释放二级页表的表项
c010343c:	8b 45 10             	mov    0x10(%ebp),%eax
c010343f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    tlb_invalidate(pgdir, la);          //更新页表
c0103445:	83 ec 08             	sub    $0x8,%esp
c0103448:	ff 75 0c             	pushl  0xc(%ebp)
c010344b:	ff 75 08             	pushl  0x8(%ebp)
c010344e:	e8 f8 00 00 00       	call   c010354b <tlb_invalidate>
c0103453:	83 c4 10             	add    $0x10,%esp
	}  
}
c0103456:	90                   	nop
c0103457:	c9                   	leave  
c0103458:	c3                   	ret    

c0103459 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0103459:	55                   	push   %ebp
c010345a:	89 e5                	mov    %esp,%ebp
c010345c:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010345f:	83 ec 04             	sub    $0x4,%esp
c0103462:	6a 00                	push   $0x0
c0103464:	ff 75 0c             	pushl  0xc(%ebp)
c0103467:	ff 75 08             	pushl  0x8(%ebp)
c010346a:	e8 12 fe ff ff       	call   c0103281 <get_pte>
c010346f:	83 c4 10             	add    $0x10,%esp
c0103472:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0103475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103479:	74 14                	je     c010348f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c010347b:	83 ec 04             	sub    $0x4,%esp
c010347e:	ff 75 f4             	pushl  -0xc(%ebp)
c0103481:	ff 75 0c             	pushl  0xc(%ebp)
c0103484:	ff 75 08             	pushl  0x8(%ebp)
c0103487:	e8 68 ff ff ff       	call   c01033f4 <page_remove_pte>
c010348c:	83 c4 10             	add    $0x10,%esp
    }
}
c010348f:	90                   	nop
c0103490:	c9                   	leave  
c0103491:	c3                   	ret    

c0103492 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103492:	55                   	push   %ebp
c0103493:	89 e5                	mov    %esp,%ebp
c0103495:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103498:	83 ec 04             	sub    $0x4,%esp
c010349b:	6a 01                	push   $0x1
c010349d:	ff 75 10             	pushl  0x10(%ebp)
c01034a0:	ff 75 08             	pushl  0x8(%ebp)
c01034a3:	e8 d9 fd ff ff       	call   c0103281 <get_pte>
c01034a8:	83 c4 10             	add    $0x10,%esp
c01034ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01034ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01034b2:	75 0a                	jne    c01034be <page_insert+0x2c>
        return -E_NO_MEM;
c01034b4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01034b9:	e9 8b 00 00 00       	jmp    c0103549 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034be:	83 ec 0c             	sub    $0xc,%esp
c01034c1:	ff 75 0c             	pushl  0xc(%ebp)
c01034c4:	e8 fa f4 ff ff       	call   c01029c3 <page_ref_inc>
c01034c9:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c01034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034cf:	8b 00                	mov    (%eax),%eax
c01034d1:	83 e0 01             	and    $0x1,%eax
c01034d4:	85 c0                	test   %eax,%eax
c01034d6:	74 40                	je     c0103518 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c01034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034db:	8b 00                	mov    (%eax),%eax
c01034dd:	83 ec 0c             	sub    $0xc,%esp
c01034e0:	50                   	push   %eax
c01034e1:	e8 6f f4 ff ff       	call   c0102955 <pte2page>
c01034e6:	83 c4 10             	add    $0x10,%esp
c01034e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034f2:	75 10                	jne    c0103504 <page_insert+0x72>
            page_ref_dec(page);
c01034f4:	83 ec 0c             	sub    $0xc,%esp
c01034f7:	ff 75 0c             	pushl  0xc(%ebp)
c01034fa:	e8 db f4 ff ff       	call   c01029da <page_ref_dec>
c01034ff:	83 c4 10             	add    $0x10,%esp
c0103502:	eb 14                	jmp    c0103518 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103504:	83 ec 04             	sub    $0x4,%esp
c0103507:	ff 75 f4             	pushl  -0xc(%ebp)
c010350a:	ff 75 10             	pushl  0x10(%ebp)
c010350d:	ff 75 08             	pushl  0x8(%ebp)
c0103510:	e8 df fe ff ff       	call   c01033f4 <page_remove_pte>
c0103515:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103518:	83 ec 0c             	sub    $0xc,%esp
c010351b:	ff 75 0c             	pushl  0xc(%ebp)
c010351e:	e8 93 f3 ff ff       	call   c01028b6 <page2pa>
c0103523:	83 c4 10             	add    $0x10,%esp
c0103526:	0b 45 14             	or     0x14(%ebp),%eax
c0103529:	83 c8 01             	or     $0x1,%eax
c010352c:	89 c2                	mov    %eax,%edx
c010352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103531:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103533:	83 ec 08             	sub    $0x8,%esp
c0103536:	ff 75 10             	pushl  0x10(%ebp)
c0103539:	ff 75 08             	pushl  0x8(%ebp)
c010353c:	e8 0a 00 00 00       	call   c010354b <tlb_invalidate>
c0103541:	83 c4 10             	add    $0x10,%esp
    return 0;
c0103544:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103549:	c9                   	leave  
c010354a:	c3                   	ret    

c010354b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010354b:	55                   	push   %ebp
c010354c:	89 e5                	mov    %esp,%ebp
c010354e:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103551:	0f 20 d8             	mov    %cr3,%eax
c0103554:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103557:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c010355a:	8b 45 08             	mov    0x8(%ebp),%eax
c010355d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103560:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103567:	77 17                	ja     c0103580 <tlb_invalidate+0x35>
c0103569:	ff 75 f0             	pushl  -0x10(%ebp)
c010356c:	68 64 62 10 c0       	push   $0xc0106264
c0103571:	68 f4 01 00 00       	push   $0x1f4
c0103576:	68 88 62 10 c0       	push   $0xc0106288
c010357b:	e8 4d ce ff ff       	call   c01003cd <__panic>
c0103580:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103583:	05 00 00 00 40       	add    $0x40000000,%eax
c0103588:	39 c2                	cmp    %eax,%edx
c010358a:	75 0c                	jne    c0103598 <tlb_invalidate+0x4d>
        invlpg((void *)la);
c010358c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103592:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103595:	0f 01 38             	invlpg (%eax)
    }
}
c0103598:	90                   	nop
c0103599:	c9                   	leave  
c010359a:	c3                   	ret    

c010359b <check_alloc_page>:

static void
check_alloc_page(void) {
c010359b:	55                   	push   %ebp
c010359c:	89 e5                	mov    %esp,%ebp
c010359e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c01035a1:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01035a6:	8b 40 18             	mov    0x18(%eax),%eax
c01035a9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01035ab:	83 ec 0c             	sub    $0xc,%esp
c01035ae:	68 e8 62 10 c0       	push   $0xc01062e8
c01035b3:	e8 af cc ff ff       	call   c0100267 <cprintf>
c01035b8:	83 c4 10             	add    $0x10,%esp
}
c01035bb:	90                   	nop
c01035bc:	c9                   	leave  
c01035bd:	c3                   	ret    

c01035be <check_pgdir>:

static void
check_pgdir(void) {
c01035be:	55                   	push   %ebp
c01035bf:	89 e5                	mov    %esp,%ebp
c01035c1:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035c4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01035c9:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035ce:	76 19                	jbe    c01035e9 <check_pgdir+0x2b>
c01035d0:	68 07 63 10 c0       	push   $0xc0106307
c01035d5:	68 ad 62 10 c0       	push   $0xc01062ad
c01035da:	68 01 02 00 00       	push   $0x201
c01035df:	68 88 62 10 c0       	push   $0xc0106288
c01035e4:	e8 e4 cd ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01035e9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035ee:	85 c0                	test   %eax,%eax
c01035f0:	74 0e                	je     c0103600 <check_pgdir+0x42>
c01035f2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035f7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035fc:	85 c0                	test   %eax,%eax
c01035fe:	74 19                	je     c0103619 <check_pgdir+0x5b>
c0103600:	68 24 63 10 c0       	push   $0xc0106324
c0103605:	68 ad 62 10 c0       	push   $0xc01062ad
c010360a:	68 02 02 00 00       	push   $0x202
c010360f:	68 88 62 10 c0       	push   $0xc0106288
c0103614:	e8 b4 cd ff ff       	call   c01003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103619:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010361e:	83 ec 04             	sub    $0x4,%esp
c0103621:	6a 00                	push   $0x0
c0103623:	6a 00                	push   $0x0
c0103625:	50                   	push   %eax
c0103626:	e8 73 fd ff ff       	call   c010339e <get_page>
c010362b:	83 c4 10             	add    $0x10,%esp
c010362e:	85 c0                	test   %eax,%eax
c0103630:	74 19                	je     c010364b <check_pgdir+0x8d>
c0103632:	68 5c 63 10 c0       	push   $0xc010635c
c0103637:	68 ad 62 10 c0       	push   $0xc01062ad
c010363c:	68 03 02 00 00       	push   $0x203
c0103641:	68 88 62 10 c0       	push   $0xc0106288
c0103646:	e8 82 cd ff ff       	call   c01003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010364b:	83 ec 0c             	sub    $0xc,%esp
c010364e:	6a 01                	push   $0x1
c0103650:	e8 64 f5 ff ff       	call   c0102bb9 <alloc_pages>
c0103655:	83 c4 10             	add    $0x10,%esp
c0103658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010365b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103660:	6a 00                	push   $0x0
c0103662:	6a 00                	push   $0x0
c0103664:	ff 75 f4             	pushl  -0xc(%ebp)
c0103667:	50                   	push   %eax
c0103668:	e8 25 fe ff ff       	call   c0103492 <page_insert>
c010366d:	83 c4 10             	add    $0x10,%esp
c0103670:	85 c0                	test   %eax,%eax
c0103672:	74 19                	je     c010368d <check_pgdir+0xcf>
c0103674:	68 84 63 10 c0       	push   $0xc0106384
c0103679:	68 ad 62 10 c0       	push   $0xc01062ad
c010367e:	68 07 02 00 00       	push   $0x207
c0103683:	68 88 62 10 c0       	push   $0xc0106288
c0103688:	e8 40 cd ff ff       	call   c01003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010368d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103692:	83 ec 04             	sub    $0x4,%esp
c0103695:	6a 00                	push   $0x0
c0103697:	6a 00                	push   $0x0
c0103699:	50                   	push   %eax
c010369a:	e8 e2 fb ff ff       	call   c0103281 <get_pte>
c010369f:	83 c4 10             	add    $0x10,%esp
c01036a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01036a9:	75 19                	jne    c01036c4 <check_pgdir+0x106>
c01036ab:	68 b0 63 10 c0       	push   $0xc01063b0
c01036b0:	68 ad 62 10 c0       	push   $0xc01062ad
c01036b5:	68 0a 02 00 00       	push   $0x20a
c01036ba:	68 88 62 10 c0       	push   $0xc0106288
c01036bf:	e8 09 cd ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c01036c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c7:	8b 00                	mov    (%eax),%eax
c01036c9:	83 ec 0c             	sub    $0xc,%esp
c01036cc:	50                   	push   %eax
c01036cd:	e8 83 f2 ff ff       	call   c0102955 <pte2page>
c01036d2:	83 c4 10             	add    $0x10,%esp
c01036d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036d8:	74 19                	je     c01036f3 <check_pgdir+0x135>
c01036da:	68 dd 63 10 c0       	push   $0xc01063dd
c01036df:	68 ad 62 10 c0       	push   $0xc01062ad
c01036e4:	68 0b 02 00 00       	push   $0x20b
c01036e9:	68 88 62 10 c0       	push   $0xc0106288
c01036ee:	e8 da cc ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 1);
c01036f3:	83 ec 0c             	sub    $0xc,%esp
c01036f6:	ff 75 f4             	pushl  -0xc(%ebp)
c01036f9:	e8 ad f2 ff ff       	call   c01029ab <page_ref>
c01036fe:	83 c4 10             	add    $0x10,%esp
c0103701:	83 f8 01             	cmp    $0x1,%eax
c0103704:	74 19                	je     c010371f <check_pgdir+0x161>
c0103706:	68 f3 63 10 c0       	push   $0xc01063f3
c010370b:	68 ad 62 10 c0       	push   $0xc01062ad
c0103710:	68 0c 02 00 00       	push   $0x20c
c0103715:	68 88 62 10 c0       	push   $0xc0106288
c010371a:	e8 ae cc ff ff       	call   c01003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010371f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103724:	8b 00                	mov    (%eax),%eax
c0103726:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010372b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010372e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103731:	c1 e8 0c             	shr    $0xc,%eax
c0103734:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103737:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010373c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010373f:	72 17                	jb     c0103758 <check_pgdir+0x19a>
c0103741:	ff 75 ec             	pushl  -0x14(%ebp)
c0103744:	68 c0 61 10 c0       	push   $0xc01061c0
c0103749:	68 0e 02 00 00       	push   $0x20e
c010374e:	68 88 62 10 c0       	push   $0xc0106288
c0103753:	e8 75 cc ff ff       	call   c01003cd <__panic>
c0103758:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010375b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103760:	83 c0 04             	add    $0x4,%eax
c0103763:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103766:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010376b:	83 ec 04             	sub    $0x4,%esp
c010376e:	6a 00                	push   $0x0
c0103770:	68 00 10 00 00       	push   $0x1000
c0103775:	50                   	push   %eax
c0103776:	e8 06 fb ff ff       	call   c0103281 <get_pte>
c010377b:	83 c4 10             	add    $0x10,%esp
c010377e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103781:	74 19                	je     c010379c <check_pgdir+0x1de>
c0103783:	68 08 64 10 c0       	push   $0xc0106408
c0103788:	68 ad 62 10 c0       	push   $0xc01062ad
c010378d:	68 0f 02 00 00       	push   $0x20f
c0103792:	68 88 62 10 c0       	push   $0xc0106288
c0103797:	e8 31 cc ff ff       	call   c01003cd <__panic>

    p2 = alloc_page();
c010379c:	83 ec 0c             	sub    $0xc,%esp
c010379f:	6a 01                	push   $0x1
c01037a1:	e8 13 f4 ff ff       	call   c0102bb9 <alloc_pages>
c01037a6:	83 c4 10             	add    $0x10,%esp
c01037a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01037ac:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037b1:	6a 06                	push   $0x6
c01037b3:	68 00 10 00 00       	push   $0x1000
c01037b8:	ff 75 e4             	pushl  -0x1c(%ebp)
c01037bb:	50                   	push   %eax
c01037bc:	e8 d1 fc ff ff       	call   c0103492 <page_insert>
c01037c1:	83 c4 10             	add    $0x10,%esp
c01037c4:	85 c0                	test   %eax,%eax
c01037c6:	74 19                	je     c01037e1 <check_pgdir+0x223>
c01037c8:	68 30 64 10 c0       	push   $0xc0106430
c01037cd:	68 ad 62 10 c0       	push   $0xc01062ad
c01037d2:	68 12 02 00 00       	push   $0x212
c01037d7:	68 88 62 10 c0       	push   $0xc0106288
c01037dc:	e8 ec cb ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01037e1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037e6:	83 ec 04             	sub    $0x4,%esp
c01037e9:	6a 00                	push   $0x0
c01037eb:	68 00 10 00 00       	push   $0x1000
c01037f0:	50                   	push   %eax
c01037f1:	e8 8b fa ff ff       	call   c0103281 <get_pte>
c01037f6:	83 c4 10             	add    $0x10,%esp
c01037f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103800:	75 19                	jne    c010381b <check_pgdir+0x25d>
c0103802:	68 68 64 10 c0       	push   $0xc0106468
c0103807:	68 ad 62 10 c0       	push   $0xc01062ad
c010380c:	68 13 02 00 00       	push   $0x213
c0103811:	68 88 62 10 c0       	push   $0xc0106288
c0103816:	e8 b2 cb ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_U);
c010381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010381e:	8b 00                	mov    (%eax),%eax
c0103820:	83 e0 04             	and    $0x4,%eax
c0103823:	85 c0                	test   %eax,%eax
c0103825:	75 19                	jne    c0103840 <check_pgdir+0x282>
c0103827:	68 98 64 10 c0       	push   $0xc0106498
c010382c:	68 ad 62 10 c0       	push   $0xc01062ad
c0103831:	68 14 02 00 00       	push   $0x214
c0103836:	68 88 62 10 c0       	push   $0xc0106288
c010383b:	e8 8d cb ff ff       	call   c01003cd <__panic>
    assert(*ptep & PTE_W);
c0103840:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103843:	8b 00                	mov    (%eax),%eax
c0103845:	83 e0 02             	and    $0x2,%eax
c0103848:	85 c0                	test   %eax,%eax
c010384a:	75 19                	jne    c0103865 <check_pgdir+0x2a7>
c010384c:	68 a6 64 10 c0       	push   $0xc01064a6
c0103851:	68 ad 62 10 c0       	push   $0xc01062ad
c0103856:	68 15 02 00 00       	push   $0x215
c010385b:	68 88 62 10 c0       	push   $0xc0106288
c0103860:	e8 68 cb ff ff       	call   c01003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103865:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010386a:	8b 00                	mov    (%eax),%eax
c010386c:	83 e0 04             	and    $0x4,%eax
c010386f:	85 c0                	test   %eax,%eax
c0103871:	75 19                	jne    c010388c <check_pgdir+0x2ce>
c0103873:	68 b4 64 10 c0       	push   $0xc01064b4
c0103878:	68 ad 62 10 c0       	push   $0xc01062ad
c010387d:	68 16 02 00 00       	push   $0x216
c0103882:	68 88 62 10 c0       	push   $0xc0106288
c0103887:	e8 41 cb ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 1);
c010388c:	83 ec 0c             	sub    $0xc,%esp
c010388f:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103892:	e8 14 f1 ff ff       	call   c01029ab <page_ref>
c0103897:	83 c4 10             	add    $0x10,%esp
c010389a:	83 f8 01             	cmp    $0x1,%eax
c010389d:	74 19                	je     c01038b8 <check_pgdir+0x2fa>
c010389f:	68 ca 64 10 c0       	push   $0xc01064ca
c01038a4:	68 ad 62 10 c0       	push   $0xc01062ad
c01038a9:	68 17 02 00 00       	push   $0x217
c01038ae:	68 88 62 10 c0       	push   $0xc0106288
c01038b3:	e8 15 cb ff ff       	call   c01003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01038b8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038bd:	6a 00                	push   $0x0
c01038bf:	68 00 10 00 00       	push   $0x1000
c01038c4:	ff 75 f4             	pushl  -0xc(%ebp)
c01038c7:	50                   	push   %eax
c01038c8:	e8 c5 fb ff ff       	call   c0103492 <page_insert>
c01038cd:	83 c4 10             	add    $0x10,%esp
c01038d0:	85 c0                	test   %eax,%eax
c01038d2:	74 19                	je     c01038ed <check_pgdir+0x32f>
c01038d4:	68 dc 64 10 c0       	push   $0xc01064dc
c01038d9:	68 ad 62 10 c0       	push   $0xc01062ad
c01038de:	68 19 02 00 00       	push   $0x219
c01038e3:	68 88 62 10 c0       	push   $0xc0106288
c01038e8:	e8 e0 ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p1) == 2);
c01038ed:	83 ec 0c             	sub    $0xc,%esp
c01038f0:	ff 75 f4             	pushl  -0xc(%ebp)
c01038f3:	e8 b3 f0 ff ff       	call   c01029ab <page_ref>
c01038f8:	83 c4 10             	add    $0x10,%esp
c01038fb:	83 f8 02             	cmp    $0x2,%eax
c01038fe:	74 19                	je     c0103919 <check_pgdir+0x35b>
c0103900:	68 08 65 10 c0       	push   $0xc0106508
c0103905:	68 ad 62 10 c0       	push   $0xc01062ad
c010390a:	68 1a 02 00 00       	push   $0x21a
c010390f:	68 88 62 10 c0       	push   $0xc0106288
c0103914:	e8 b4 ca ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103919:	83 ec 0c             	sub    $0xc,%esp
c010391c:	ff 75 e4             	pushl  -0x1c(%ebp)
c010391f:	e8 87 f0 ff ff       	call   c01029ab <page_ref>
c0103924:	83 c4 10             	add    $0x10,%esp
c0103927:	85 c0                	test   %eax,%eax
c0103929:	74 19                	je     c0103944 <check_pgdir+0x386>
c010392b:	68 1a 65 10 c0       	push   $0xc010651a
c0103930:	68 ad 62 10 c0       	push   $0xc01062ad
c0103935:	68 1b 02 00 00       	push   $0x21b
c010393a:	68 88 62 10 c0       	push   $0xc0106288
c010393f:	e8 89 ca ff ff       	call   c01003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103944:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103949:	83 ec 04             	sub    $0x4,%esp
c010394c:	6a 00                	push   $0x0
c010394e:	68 00 10 00 00       	push   $0x1000
c0103953:	50                   	push   %eax
c0103954:	e8 28 f9 ff ff       	call   c0103281 <get_pte>
c0103959:	83 c4 10             	add    $0x10,%esp
c010395c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010395f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103963:	75 19                	jne    c010397e <check_pgdir+0x3c0>
c0103965:	68 68 64 10 c0       	push   $0xc0106468
c010396a:	68 ad 62 10 c0       	push   $0xc01062ad
c010396f:	68 1c 02 00 00       	push   $0x21c
c0103974:	68 88 62 10 c0       	push   $0xc0106288
c0103979:	e8 4f ca ff ff       	call   c01003cd <__panic>
    assert(pte2page(*ptep) == p1);
c010397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103981:	8b 00                	mov    (%eax),%eax
c0103983:	83 ec 0c             	sub    $0xc,%esp
c0103986:	50                   	push   %eax
c0103987:	e8 c9 ef ff ff       	call   c0102955 <pte2page>
c010398c:	83 c4 10             	add    $0x10,%esp
c010398f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103992:	74 19                	je     c01039ad <check_pgdir+0x3ef>
c0103994:	68 dd 63 10 c0       	push   $0xc01063dd
c0103999:	68 ad 62 10 c0       	push   $0xc01062ad
c010399e:	68 1d 02 00 00       	push   $0x21d
c01039a3:	68 88 62 10 c0       	push   $0xc0106288
c01039a8:	e8 20 ca ff ff       	call   c01003cd <__panic>
    assert((*ptep & PTE_U) == 0);
c01039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b0:	8b 00                	mov    (%eax),%eax
c01039b2:	83 e0 04             	and    $0x4,%eax
c01039b5:	85 c0                	test   %eax,%eax
c01039b7:	74 19                	je     c01039d2 <check_pgdir+0x414>
c01039b9:	68 2c 65 10 c0       	push   $0xc010652c
c01039be:	68 ad 62 10 c0       	push   $0xc01062ad
c01039c3:	68 1e 02 00 00       	push   $0x21e
c01039c8:	68 88 62 10 c0       	push   $0xc0106288
c01039cd:	e8 fb c9 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, 0x0);
c01039d2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039d7:	83 ec 08             	sub    $0x8,%esp
c01039da:	6a 00                	push   $0x0
c01039dc:	50                   	push   %eax
c01039dd:	e8 77 fa ff ff       	call   c0103459 <page_remove>
c01039e2:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c01039e5:	83 ec 0c             	sub    $0xc,%esp
c01039e8:	ff 75 f4             	pushl  -0xc(%ebp)
c01039eb:	e8 bb ef ff ff       	call   c01029ab <page_ref>
c01039f0:	83 c4 10             	add    $0x10,%esp
c01039f3:	83 f8 01             	cmp    $0x1,%eax
c01039f6:	74 19                	je     c0103a11 <check_pgdir+0x453>
c01039f8:	68 f3 63 10 c0       	push   $0xc01063f3
c01039fd:	68 ad 62 10 c0       	push   $0xc01062ad
c0103a02:	68 21 02 00 00       	push   $0x221
c0103a07:	68 88 62 10 c0       	push   $0xc0106288
c0103a0c:	e8 bc c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103a11:	83 ec 0c             	sub    $0xc,%esp
c0103a14:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a17:	e8 8f ef ff ff       	call   c01029ab <page_ref>
c0103a1c:	83 c4 10             	add    $0x10,%esp
c0103a1f:	85 c0                	test   %eax,%eax
c0103a21:	74 19                	je     c0103a3c <check_pgdir+0x47e>
c0103a23:	68 1a 65 10 c0       	push   $0xc010651a
c0103a28:	68 ad 62 10 c0       	push   $0xc01062ad
c0103a2d:	68 22 02 00 00       	push   $0x222
c0103a32:	68 88 62 10 c0       	push   $0xc0106288
c0103a37:	e8 91 c9 ff ff       	call   c01003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103a3c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a41:	83 ec 08             	sub    $0x8,%esp
c0103a44:	68 00 10 00 00       	push   $0x1000
c0103a49:	50                   	push   %eax
c0103a4a:	e8 0a fa ff ff       	call   c0103459 <page_remove>
c0103a4f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c0103a52:	83 ec 0c             	sub    $0xc,%esp
c0103a55:	ff 75 f4             	pushl  -0xc(%ebp)
c0103a58:	e8 4e ef ff ff       	call   c01029ab <page_ref>
c0103a5d:	83 c4 10             	add    $0x10,%esp
c0103a60:	85 c0                	test   %eax,%eax
c0103a62:	74 19                	je     c0103a7d <check_pgdir+0x4bf>
c0103a64:	68 41 65 10 c0       	push   $0xc0106541
c0103a69:	68 ad 62 10 c0       	push   $0xc01062ad
c0103a6e:	68 25 02 00 00       	push   $0x225
c0103a73:	68 88 62 10 c0       	push   $0xc0106288
c0103a78:	e8 50 c9 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p2) == 0);
c0103a7d:	83 ec 0c             	sub    $0xc,%esp
c0103a80:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103a83:	e8 23 ef ff ff       	call   c01029ab <page_ref>
c0103a88:	83 c4 10             	add    $0x10,%esp
c0103a8b:	85 c0                	test   %eax,%eax
c0103a8d:	74 19                	je     c0103aa8 <check_pgdir+0x4ea>
c0103a8f:	68 1a 65 10 c0       	push   $0xc010651a
c0103a94:	68 ad 62 10 c0       	push   $0xc01062ad
c0103a99:	68 26 02 00 00       	push   $0x226
c0103a9e:	68 88 62 10 c0       	push   $0xc0106288
c0103aa3:	e8 25 c9 ff ff       	call   c01003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103aa8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103aad:	8b 00                	mov    (%eax),%eax
c0103aaf:	83 ec 0c             	sub    $0xc,%esp
c0103ab2:	50                   	push   %eax
c0103ab3:	e8 d7 ee ff ff       	call   c010298f <pde2page>
c0103ab8:	83 c4 10             	add    $0x10,%esp
c0103abb:	83 ec 0c             	sub    $0xc,%esp
c0103abe:	50                   	push   %eax
c0103abf:	e8 e7 ee ff ff       	call   c01029ab <page_ref>
c0103ac4:	83 c4 10             	add    $0x10,%esp
c0103ac7:	83 f8 01             	cmp    $0x1,%eax
c0103aca:	74 19                	je     c0103ae5 <check_pgdir+0x527>
c0103acc:	68 54 65 10 c0       	push   $0xc0106554
c0103ad1:	68 ad 62 10 c0       	push   $0xc01062ad
c0103ad6:	68 28 02 00 00       	push   $0x228
c0103adb:	68 88 62 10 c0       	push   $0xc0106288
c0103ae0:	e8 e8 c8 ff ff       	call   c01003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103ae5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103aea:	8b 00                	mov    (%eax),%eax
c0103aec:	83 ec 0c             	sub    $0xc,%esp
c0103aef:	50                   	push   %eax
c0103af0:	e8 9a ee ff ff       	call   c010298f <pde2page>
c0103af5:	83 c4 10             	add    $0x10,%esp
c0103af8:	83 ec 08             	sub    $0x8,%esp
c0103afb:	6a 01                	push   $0x1
c0103afd:	50                   	push   %eax
c0103afe:	e8 f4 f0 ff ff       	call   c0102bf7 <free_pages>
c0103b03:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103b06:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103b11:	83 ec 0c             	sub    $0xc,%esp
c0103b14:	68 7b 65 10 c0       	push   $0xc010657b
c0103b19:	e8 49 c7 ff ff       	call   c0100267 <cprintf>
c0103b1e:	83 c4 10             	add    $0x10,%esp
}
c0103b21:	90                   	nop
c0103b22:	c9                   	leave  
c0103b23:	c3                   	ret    

c0103b24 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103b24:	55                   	push   %ebp
c0103b25:	89 e5                	mov    %esp,%ebp
c0103b27:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b31:	e9 a3 00 00 00       	jmp    c0103bd9 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b3f:	c1 e8 0c             	shr    $0xc,%eax
c0103b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b45:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103b4a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103b4d:	72 17                	jb     c0103b66 <check_boot_pgdir+0x42>
c0103b4f:	ff 75 f0             	pushl  -0x10(%ebp)
c0103b52:	68 c0 61 10 c0       	push   $0xc01061c0
c0103b57:	68 34 02 00 00       	push   $0x234
c0103b5c:	68 88 62 10 c0       	push   $0xc0106288
c0103b61:	e8 67 c8 ff ff       	call   c01003cd <__panic>
c0103b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b69:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103b6e:	89 c2                	mov    %eax,%edx
c0103b70:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b75:	83 ec 04             	sub    $0x4,%esp
c0103b78:	6a 00                	push   $0x0
c0103b7a:	52                   	push   %edx
c0103b7b:	50                   	push   %eax
c0103b7c:	e8 00 f7 ff ff       	call   c0103281 <get_pte>
c0103b81:	83 c4 10             	add    $0x10,%esp
c0103b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103b87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103b8b:	75 19                	jne    c0103ba6 <check_boot_pgdir+0x82>
c0103b8d:	68 98 65 10 c0       	push   $0xc0106598
c0103b92:	68 ad 62 10 c0       	push   $0xc01062ad
c0103b97:	68 34 02 00 00       	push   $0x234
c0103b9c:	68 88 62 10 c0       	push   $0xc0106288
c0103ba1:	e8 27 c8 ff ff       	call   c01003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ba9:	8b 00                	mov    (%eax),%eax
c0103bab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bb0:	89 c2                	mov    %eax,%edx
c0103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bb5:	39 c2                	cmp    %eax,%edx
c0103bb7:	74 19                	je     c0103bd2 <check_boot_pgdir+0xae>
c0103bb9:	68 d5 65 10 c0       	push   $0xc01065d5
c0103bbe:	68 ad 62 10 c0       	push   $0xc01062ad
c0103bc3:	68 35 02 00 00       	push   $0x235
c0103bc8:	68 88 62 10 c0       	push   $0xc0106288
c0103bcd:	e8 fb c7 ff ff       	call   c01003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103bd2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103bdc:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103be1:	39 c2                	cmp    %eax,%edx
c0103be3:	0f 82 4d ff ff ff    	jb     c0103b36 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103be9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103bee:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103bf3:	8b 00                	mov    (%eax),%eax
c0103bf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103bfa:	89 c2                	mov    %eax,%edx
c0103bfc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c04:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103c0b:	77 17                	ja     c0103c24 <check_boot_pgdir+0x100>
c0103c0d:	ff 75 e4             	pushl  -0x1c(%ebp)
c0103c10:	68 64 62 10 c0       	push   $0xc0106264
c0103c15:	68 38 02 00 00       	push   $0x238
c0103c1a:	68 88 62 10 c0       	push   $0xc0106288
c0103c1f:	e8 a9 c7 ff ff       	call   c01003cd <__panic>
c0103c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c27:	05 00 00 00 40       	add    $0x40000000,%eax
c0103c2c:	39 c2                	cmp    %eax,%edx
c0103c2e:	74 19                	je     c0103c49 <check_boot_pgdir+0x125>
c0103c30:	68 ec 65 10 c0       	push   $0xc01065ec
c0103c35:	68 ad 62 10 c0       	push   $0xc01062ad
c0103c3a:	68 38 02 00 00       	push   $0x238
c0103c3f:	68 88 62 10 c0       	push   $0xc0106288
c0103c44:	e8 84 c7 ff ff       	call   c01003cd <__panic>

    assert(boot_pgdir[0] == 0);
c0103c49:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c4e:	8b 00                	mov    (%eax),%eax
c0103c50:	85 c0                	test   %eax,%eax
c0103c52:	74 19                	je     c0103c6d <check_boot_pgdir+0x149>
c0103c54:	68 20 66 10 c0       	push   $0xc0106620
c0103c59:	68 ad 62 10 c0       	push   $0xc01062ad
c0103c5e:	68 3a 02 00 00       	push   $0x23a
c0103c63:	68 88 62 10 c0       	push   $0xc0106288
c0103c68:	e8 60 c7 ff ff       	call   c01003cd <__panic>

    struct Page *p;
    p = alloc_page();
c0103c6d:	83 ec 0c             	sub    $0xc,%esp
c0103c70:	6a 01                	push   $0x1
c0103c72:	e8 42 ef ff ff       	call   c0102bb9 <alloc_pages>
c0103c77:	83 c4 10             	add    $0x10,%esp
c0103c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103c7d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c82:	6a 02                	push   $0x2
c0103c84:	68 00 01 00 00       	push   $0x100
c0103c89:	ff 75 e0             	pushl  -0x20(%ebp)
c0103c8c:	50                   	push   %eax
c0103c8d:	e8 00 f8 ff ff       	call   c0103492 <page_insert>
c0103c92:	83 c4 10             	add    $0x10,%esp
c0103c95:	85 c0                	test   %eax,%eax
c0103c97:	74 19                	je     c0103cb2 <check_boot_pgdir+0x18e>
c0103c99:	68 34 66 10 c0       	push   $0xc0106634
c0103c9e:	68 ad 62 10 c0       	push   $0xc01062ad
c0103ca3:	68 3e 02 00 00       	push   $0x23e
c0103ca8:	68 88 62 10 c0       	push   $0xc0106288
c0103cad:	e8 1b c7 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 1);
c0103cb2:	83 ec 0c             	sub    $0xc,%esp
c0103cb5:	ff 75 e0             	pushl  -0x20(%ebp)
c0103cb8:	e8 ee ec ff ff       	call   c01029ab <page_ref>
c0103cbd:	83 c4 10             	add    $0x10,%esp
c0103cc0:	83 f8 01             	cmp    $0x1,%eax
c0103cc3:	74 19                	je     c0103cde <check_boot_pgdir+0x1ba>
c0103cc5:	68 62 66 10 c0       	push   $0xc0106662
c0103cca:	68 ad 62 10 c0       	push   $0xc01062ad
c0103ccf:	68 3f 02 00 00       	push   $0x23f
c0103cd4:	68 88 62 10 c0       	push   $0xc0106288
c0103cd9:	e8 ef c6 ff ff       	call   c01003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103cde:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103ce3:	6a 02                	push   $0x2
c0103ce5:	68 00 11 00 00       	push   $0x1100
c0103cea:	ff 75 e0             	pushl  -0x20(%ebp)
c0103ced:	50                   	push   %eax
c0103cee:	e8 9f f7 ff ff       	call   c0103492 <page_insert>
c0103cf3:	83 c4 10             	add    $0x10,%esp
c0103cf6:	85 c0                	test   %eax,%eax
c0103cf8:	74 19                	je     c0103d13 <check_boot_pgdir+0x1ef>
c0103cfa:	68 74 66 10 c0       	push   $0xc0106674
c0103cff:	68 ad 62 10 c0       	push   $0xc01062ad
c0103d04:	68 40 02 00 00       	push   $0x240
c0103d09:	68 88 62 10 c0       	push   $0xc0106288
c0103d0e:	e8 ba c6 ff ff       	call   c01003cd <__panic>
    assert(page_ref(p) == 2);
c0103d13:	83 ec 0c             	sub    $0xc,%esp
c0103d16:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d19:	e8 8d ec ff ff       	call   c01029ab <page_ref>
c0103d1e:	83 c4 10             	add    $0x10,%esp
c0103d21:	83 f8 02             	cmp    $0x2,%eax
c0103d24:	74 19                	je     c0103d3f <check_boot_pgdir+0x21b>
c0103d26:	68 ab 66 10 c0       	push   $0xc01066ab
c0103d2b:	68 ad 62 10 c0       	push   $0xc01062ad
c0103d30:	68 41 02 00 00       	push   $0x241
c0103d35:	68 88 62 10 c0       	push   $0xc0106288
c0103d3a:	e8 8e c6 ff ff       	call   c01003cd <__panic>

    const char *str = "ucore: Hello world!!";
c0103d3f:	c7 45 dc bc 66 10 c0 	movl   $0xc01066bc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103d46:	83 ec 08             	sub    $0x8,%esp
c0103d49:	ff 75 dc             	pushl  -0x24(%ebp)
c0103d4c:	68 00 01 00 00       	push   $0x100
c0103d51:	e8 9e 12 00 00       	call   c0104ff4 <strcpy>
c0103d56:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103d59:	83 ec 08             	sub    $0x8,%esp
c0103d5c:	68 00 11 00 00       	push   $0x1100
c0103d61:	68 00 01 00 00       	push   $0x100
c0103d66:	e8 03 13 00 00       	call   c010506e <strcmp>
c0103d6b:	83 c4 10             	add    $0x10,%esp
c0103d6e:	85 c0                	test   %eax,%eax
c0103d70:	74 19                	je     c0103d8b <check_boot_pgdir+0x267>
c0103d72:	68 d4 66 10 c0       	push   $0xc01066d4
c0103d77:	68 ad 62 10 c0       	push   $0xc01062ad
c0103d7c:	68 45 02 00 00       	push   $0x245
c0103d81:	68 88 62 10 c0       	push   $0xc0106288
c0103d86:	e8 42 c6 ff ff       	call   c01003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103d8b:	83 ec 0c             	sub    $0xc,%esp
c0103d8e:	ff 75 e0             	pushl  -0x20(%ebp)
c0103d91:	e8 7a eb ff ff       	call   c0102910 <page2kva>
c0103d96:	83 c4 10             	add    $0x10,%esp
c0103d99:	05 00 01 00 00       	add    $0x100,%eax
c0103d9e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103da1:	83 ec 0c             	sub    $0xc,%esp
c0103da4:	68 00 01 00 00       	push   $0x100
c0103da9:	e8 ee 11 00 00       	call   c0104f9c <strlen>
c0103dae:	83 c4 10             	add    $0x10,%esp
c0103db1:	85 c0                	test   %eax,%eax
c0103db3:	74 19                	je     c0103dce <check_boot_pgdir+0x2aa>
c0103db5:	68 0c 67 10 c0       	push   $0xc010670c
c0103dba:	68 ad 62 10 c0       	push   $0xc01062ad
c0103dbf:	68 48 02 00 00       	push   $0x248
c0103dc4:	68 88 62 10 c0       	push   $0xc0106288
c0103dc9:	e8 ff c5 ff ff       	call   c01003cd <__panic>

    free_page(p);
c0103dce:	83 ec 08             	sub    $0x8,%esp
c0103dd1:	6a 01                	push   $0x1
c0103dd3:	ff 75 e0             	pushl  -0x20(%ebp)
c0103dd6:	e8 1c ee ff ff       	call   c0102bf7 <free_pages>
c0103ddb:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0103dde:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103de3:	8b 00                	mov    (%eax),%eax
c0103de5:	83 ec 0c             	sub    $0xc,%esp
c0103de8:	50                   	push   %eax
c0103de9:	e8 a1 eb ff ff       	call   c010298f <pde2page>
c0103dee:	83 c4 10             	add    $0x10,%esp
c0103df1:	83 ec 08             	sub    $0x8,%esp
c0103df4:	6a 01                	push   $0x1
c0103df6:	50                   	push   %eax
c0103df7:	e8 fb ed ff ff       	call   c0102bf7 <free_pages>
c0103dfc:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0103dff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103e04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103e0a:	83 ec 0c             	sub    $0xc,%esp
c0103e0d:	68 30 67 10 c0       	push   $0xc0106730
c0103e12:	e8 50 c4 ff ff       	call   c0100267 <cprintf>
c0103e17:	83 c4 10             	add    $0x10,%esp
}
c0103e1a:	90                   	nop
c0103e1b:	c9                   	leave  
c0103e1c:	c3                   	ret    

c0103e1d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103e1d:	55                   	push   %ebp
c0103e1e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103e20:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e23:	83 e0 04             	and    $0x4,%eax
c0103e26:	85 c0                	test   %eax,%eax
c0103e28:	74 07                	je     c0103e31 <perm2str+0x14>
c0103e2a:	b8 75 00 00 00       	mov    $0x75,%eax
c0103e2f:	eb 05                	jmp    c0103e36 <perm2str+0x19>
c0103e31:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e36:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103e3b:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103e42:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e45:	83 e0 02             	and    $0x2,%eax
c0103e48:	85 c0                	test   %eax,%eax
c0103e4a:	74 07                	je     c0103e53 <perm2str+0x36>
c0103e4c:	b8 77 00 00 00       	mov    $0x77,%eax
c0103e51:	eb 05                	jmp    c0103e58 <perm2str+0x3b>
c0103e53:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103e58:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103e5d:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103e64:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103e69:	5d                   	pop    %ebp
c0103e6a:	c3                   	ret    

c0103e6b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103e6b:	55                   	push   %ebp
c0103e6c:	89 e5                	mov    %esp,%ebp
c0103e6e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103e71:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e74:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e77:	72 0e                	jb     c0103e87 <get_pgtable_items+0x1c>
        return 0;
c0103e79:	b8 00 00 00 00       	mov    $0x0,%eax
c0103e7e:	e9 9a 00 00 00       	jmp    c0103f1d <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103e83:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103e87:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103e8d:	73 18                	jae    c0103ea7 <get_pgtable_items+0x3c>
c0103e8f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103e92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103e99:	8b 45 14             	mov    0x14(%ebp),%eax
c0103e9c:	01 d0                	add    %edx,%eax
c0103e9e:	8b 00                	mov    (%eax),%eax
c0103ea0:	83 e0 01             	and    $0x1,%eax
c0103ea3:	85 c0                	test   %eax,%eax
c0103ea5:	74 dc                	je     c0103e83 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103ea7:	8b 45 10             	mov    0x10(%ebp),%eax
c0103eaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ead:	73 69                	jae    c0103f18 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0103eaf:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103eb3:	74 08                	je     c0103ebd <get_pgtable_items+0x52>
            *left_store = start;
c0103eb5:	8b 45 18             	mov    0x18(%ebp),%eax
c0103eb8:	8b 55 10             	mov    0x10(%ebp),%edx
c0103ebb:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103ebd:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ec0:	8d 50 01             	lea    0x1(%eax),%edx
c0103ec3:	89 55 10             	mov    %edx,0x10(%ebp)
c0103ec6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ecd:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ed0:	01 d0                	add    %edx,%eax
c0103ed2:	8b 00                	mov    (%eax),%eax
c0103ed4:	83 e0 07             	and    $0x7,%eax
c0103ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103eda:	eb 04                	jmp    c0103ee0 <get_pgtable_items+0x75>
            start ++;
c0103edc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103ee0:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ee3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ee6:	73 1d                	jae    c0103f05 <get_pgtable_items+0x9a>
c0103ee8:	8b 45 10             	mov    0x10(%ebp),%eax
c0103eeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ef2:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ef5:	01 d0                	add    %edx,%eax
c0103ef7:	8b 00                	mov    (%eax),%eax
c0103ef9:	83 e0 07             	and    $0x7,%eax
c0103efc:	89 c2                	mov    %eax,%edx
c0103efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f01:	39 c2                	cmp    %eax,%edx
c0103f03:	74 d7                	je     c0103edc <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
c0103f05:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103f09:	74 08                	je     c0103f13 <get_pgtable_items+0xa8>
            *right_store = start;
c0103f0b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103f0e:	8b 55 10             	mov    0x10(%ebp),%edx
c0103f11:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f16:	eb 05                	jmp    c0103f1d <get_pgtable_items+0xb2>
    }
    return 0;
c0103f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f1d:	c9                   	leave  
c0103f1e:	c3                   	ret    

c0103f1f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103f1f:	55                   	push   %ebp
c0103f20:	89 e5                	mov    %esp,%ebp
c0103f22:	57                   	push   %edi
c0103f23:	56                   	push   %esi
c0103f24:	53                   	push   %ebx
c0103f25:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103f28:	83 ec 0c             	sub    $0xc,%esp
c0103f2b:	68 50 67 10 c0       	push   $0xc0106750
c0103f30:	e8 32 c3 ff ff       	call   c0100267 <cprintf>
c0103f35:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0103f38:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103f3f:	e9 e5 00 00 00       	jmp    c0104029 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f47:	83 ec 0c             	sub    $0xc,%esp
c0103f4a:	50                   	push   %eax
c0103f4b:	e8 cd fe ff ff       	call   c0103e1d <perm2str>
c0103f50:	83 c4 10             	add    $0x10,%esp
c0103f53:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103f55:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f5b:	29 c2                	sub    %eax,%edx
c0103f5d:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103f5f:	c1 e0 16             	shl    $0x16,%eax
c0103f62:	89 c3                	mov    %eax,%ebx
c0103f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f67:	c1 e0 16             	shl    $0x16,%eax
c0103f6a:	89 c1                	mov    %eax,%ecx
c0103f6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f6f:	c1 e0 16             	shl    $0x16,%eax
c0103f72:	89 c2                	mov    %eax,%edx
c0103f74:	8b 75 dc             	mov    -0x24(%ebp),%esi
c0103f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f7a:	29 c6                	sub    %eax,%esi
c0103f7c:	89 f0                	mov    %esi,%eax
c0103f7e:	83 ec 08             	sub    $0x8,%esp
c0103f81:	57                   	push   %edi
c0103f82:	53                   	push   %ebx
c0103f83:	51                   	push   %ecx
c0103f84:	52                   	push   %edx
c0103f85:	50                   	push   %eax
c0103f86:	68 81 67 10 c0       	push   $0xc0106781
c0103f8b:	e8 d7 c2 ff ff       	call   c0100267 <cprintf>
c0103f90:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f96:	c1 e0 0a             	shl    $0xa,%eax
c0103f99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103f9c:	eb 4f                	jmp    c0103fed <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fa1:	83 ec 0c             	sub    $0xc,%esp
c0103fa4:	50                   	push   %eax
c0103fa5:	e8 73 fe ff ff       	call   c0103e1d <perm2str>
c0103faa:	83 c4 10             	add    $0x10,%esp
c0103fad:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103faf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fb5:	29 c2                	sub    %eax,%edx
c0103fb7:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103fb9:	c1 e0 0c             	shl    $0xc,%eax
c0103fbc:	89 c3                	mov    %eax,%ebx
c0103fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103fc1:	c1 e0 0c             	shl    $0xc,%eax
c0103fc4:	89 c1                	mov    %eax,%ecx
c0103fc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fc9:	c1 e0 0c             	shl    $0xc,%eax
c0103fcc:	89 c2                	mov    %eax,%edx
c0103fce:	8b 75 d4             	mov    -0x2c(%ebp),%esi
c0103fd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fd4:	29 c6                	sub    %eax,%esi
c0103fd6:	89 f0                	mov    %esi,%eax
c0103fd8:	83 ec 08             	sub    $0x8,%esp
c0103fdb:	57                   	push   %edi
c0103fdc:	53                   	push   %ebx
c0103fdd:	51                   	push   %ecx
c0103fde:	52                   	push   %edx
c0103fdf:	50                   	push   %eax
c0103fe0:	68 a0 67 10 c0       	push   $0xc01067a0
c0103fe5:	e8 7d c2 ff ff       	call   c0100267 <cprintf>
c0103fea:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103fed:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103ff2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103ff5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ff8:	89 d3                	mov    %edx,%ebx
c0103ffa:	c1 e3 0a             	shl    $0xa,%ebx
c0103ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104000:	89 d1                	mov    %edx,%ecx
c0104002:	c1 e1 0a             	shl    $0xa,%ecx
c0104005:	83 ec 08             	sub    $0x8,%esp
c0104008:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010400b:	52                   	push   %edx
c010400c:	8d 55 d8             	lea    -0x28(%ebp),%edx
c010400f:	52                   	push   %edx
c0104010:	56                   	push   %esi
c0104011:	50                   	push   %eax
c0104012:	53                   	push   %ebx
c0104013:	51                   	push   %ecx
c0104014:	e8 52 fe ff ff       	call   c0103e6b <get_pgtable_items>
c0104019:	83 c4 20             	add    $0x20,%esp
c010401c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010401f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104023:	0f 85 75 ff ff ff    	jne    c0103f9e <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104029:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010402e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104031:	83 ec 08             	sub    $0x8,%esp
c0104034:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104037:	52                   	push   %edx
c0104038:	8d 55 e0             	lea    -0x20(%ebp),%edx
c010403b:	52                   	push   %edx
c010403c:	51                   	push   %ecx
c010403d:	50                   	push   %eax
c010403e:	68 00 04 00 00       	push   $0x400
c0104043:	6a 00                	push   $0x0
c0104045:	e8 21 fe ff ff       	call   c0103e6b <get_pgtable_items>
c010404a:	83 c4 20             	add    $0x20,%esp
c010404d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104054:	0f 85 ea fe ff ff    	jne    c0103f44 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010405a:	83 ec 0c             	sub    $0xc,%esp
c010405d:	68 c4 67 10 c0       	push   $0xc01067c4
c0104062:	e8 00 c2 ff ff       	call   c0100267 <cprintf>
c0104067:	83 c4 10             	add    $0x10,%esp
}
c010406a:	90                   	nop
c010406b:	8d 65 f4             	lea    -0xc(%ebp),%esp
c010406e:	5b                   	pop    %ebx
c010406f:	5e                   	pop    %esi
c0104070:	5f                   	pop    %edi
c0104071:	5d                   	pop    %ebp
c0104072:	c3                   	ret    

c0104073 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104073:	55                   	push   %ebp
c0104074:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104076:	8b 45 08             	mov    0x8(%ebp),%eax
c0104079:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c010407f:	29 d0                	sub    %edx,%eax
c0104081:	c1 f8 02             	sar    $0x2,%eax
c0104084:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010408a:	5d                   	pop    %ebp
c010408b:	c3                   	ret    

c010408c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010408c:	55                   	push   %ebp
c010408d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c010408f:	ff 75 08             	pushl  0x8(%ebp)
c0104092:	e8 dc ff ff ff       	call   c0104073 <page2ppn>
c0104097:	83 c4 04             	add    $0x4,%esp
c010409a:	c1 e0 0c             	shl    $0xc,%eax
}
c010409d:	c9                   	leave  
c010409e:	c3                   	ret    

c010409f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010409f:	55                   	push   %ebp
c01040a0:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01040a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01040a5:	8b 00                	mov    (%eax),%eax
}
c01040a7:	5d                   	pop    %ebp
c01040a8:	c3                   	ret    

c01040a9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01040a9:	55                   	push   %ebp
c01040aa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01040ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01040af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040b2:	89 10                	mov    %edx,(%eax)
}
c01040b4:	90                   	nop
c01040b5:	5d                   	pop    %ebp
c01040b6:	c3                   	ret    

c01040b7 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01040b7:	55                   	push   %ebp
c01040b8:	89 e5                	mov    %esp,%ebp
c01040ba:	83 ec 10             	sub    $0x10,%esp
c01040bd:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01040c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01040ca:	89 50 04             	mov    %edx,0x4(%eax)
c01040cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040d0:	8b 50 04             	mov    0x4(%eax),%edx
c01040d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040d6:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01040d8:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01040df:	00 00 00 
}
c01040e2:	90                   	nop
c01040e3:	c9                   	leave  
c01040e4:	c3                   	ret    

c01040e5 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01040e5:	55                   	push   %ebp
c01040e6:	89 e5                	mov    %esp,%ebp
c01040e8:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);  
c01040eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01040ef:	75 16                	jne    c0104107 <default_init_memmap+0x22>
c01040f1:	68 f8 67 10 c0       	push   $0xc01067f8
c01040f6:	68 fe 67 10 c0       	push   $0xc01067fe
c01040fb:	6a 46                	push   $0x46
c01040fd:	68 13 68 10 c0       	push   $0xc0106813
c0104102:	e8 c6 c2 ff ff       	call   c01003cd <__panic>
    struct Page *p = base;  
c0104107:	8b 45 08             	mov    0x8(%ebp),%eax
c010410a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  
c010410d:	e9 cd 00 00 00       	jmp    c01041df <default_init_memmap+0xfa>
        //检查此页是否为保留页   
        assert(PageReserved(p));  
c0104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104115:	83 c0 04             	add    $0x4,%eax
c0104118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010411f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104125:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104128:	0f a3 10             	bt     %edx,(%eax)
c010412b:	19 c0                	sbb    %eax,%eax
c010412d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104130:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104134:	0f 95 c0             	setne  %al
c0104137:	0f b6 c0             	movzbl %al,%eax
c010413a:	85 c0                	test   %eax,%eax
c010413c:	75 16                	jne    c0104154 <default_init_memmap+0x6f>
c010413e:	68 29 68 10 c0       	push   $0xc0106829
c0104143:	68 fe 67 10 c0       	push   $0xc01067fe
c0104148:	6a 4a                	push   $0x4a
c010414a:	68 13 68 10 c0       	push   $0xc0106813
c010414f:	e8 79 c2 ff ff       	call   c01003cd <__panic>
        //设置标志位   
        p->flags = p->property = 0;  
c0104154:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104157:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104161:	8b 50 08             	mov    0x8(%eax),%edx
c0104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104167:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);  
c010416a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010416d:	83 c0 04             	add    $0x4,%eax
c0104170:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c0104177:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010417a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010417d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104180:	0f ab 10             	bts    %edx,(%eax)
        //清零此页的引用计数   
        set_page_ref(p, 0);  
c0104183:	83 ec 08             	sub    $0x8,%esp
c0104186:	6a 00                	push   $0x0
c0104188:	ff 75 f4             	pushl  -0xc(%ebp)
c010418b:	e8 19 ff ff ff       	call   c01040a9 <set_page_ref>
c0104190:	83 c4 10             	add    $0x10,%esp
        //将空闲页插入到链表  
        list_add_before(&free_list, &(p->page_link));   
c0104193:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104196:	83 c0 0c             	add    $0xc,%eax
c0104199:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
c01041a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01041a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041a6:	8b 00                	mov    (%eax),%eax
c01041a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041ab:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01041ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01041b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01041b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01041bd:	89 10                	mov    %edx,(%eax)
c01041bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041c2:	8b 10                	mov    (%eax),%edx
c01041c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01041ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01041d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041d9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  
    struct Page *p = base;  
    for (; p != base + n; p ++) {  
c01041db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01041df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041e2:	89 d0                	mov    %edx,%eax
c01041e4:	c1 e0 02             	shl    $0x2,%eax
c01041e7:	01 d0                	add    %edx,%eax
c01041e9:	c1 e0 02             	shl    $0x2,%eax
c01041ec:	89 c2                	mov    %eax,%edx
c01041ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01041f1:	01 d0                	add    %edx,%eax
c01041f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01041f6:	0f 85 16 ff ff ff    	jne    c0104112 <default_init_memmap+0x2d>
        //清零此页的引用计数   
        set_page_ref(p, 0);  
        //将空闲页插入到链表  
        list_add_before(&free_list, &(p->page_link));   
    }  
    base->property = n;  
c01041fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01041ff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104202:	89 50 08             	mov    %edx,0x8(%eax)
    //计算空闲页总数   
    nr_free += n;  
c0104205:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010420b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010420e:	01 d0                	add    %edx,%eax
c0104210:	a3 64 89 11 c0       	mov    %eax,0xc0118964
}
c0104215:	90                   	nop
c0104216:	c9                   	leave  
c0104217:	c3                   	ret    

c0104218 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104218:	55                   	push   %ebp
c0104219:	89 e5                	mov    %esp,%ebp
c010421b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);  
c010421e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104222:	75 16                	jne    c010423a <default_alloc_pages+0x22>
c0104224:	68 f8 67 10 c0       	push   $0xc01067f8
c0104229:	68 fe 67 10 c0       	push   $0xc01067fe
c010422e:	6a 5a                	push   $0x5a
c0104230:	68 13 68 10 c0       	push   $0xc0106813
c0104235:	e8 93 c1 ff ff       	call   c01003cd <__panic>
    if (n > nr_free) {  
c010423a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010423f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104242:	73 0a                	jae    c010424e <default_alloc_pages+0x36>
        return NULL;  
c0104244:	b8 00 00 00 00       	mov    $0x0,%eax
c0104249:	e9 37 01 00 00       	jmp    c0104385 <default_alloc_pages+0x16d>
    }  
    list_entry_t  *len;  
    list_entry_t  *le = &free_list;  
c010424e:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    //在空闲链表中寻找合适大小的页块  
    while ((le = list_next(le)) != &free_list) {  
c0104255:	e9 0a 01 00 00       	jmp    c0104364 <default_alloc_pages+0x14c>
        struct Page *p = le2page(le, page_link);  
c010425a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010425d:	83 e8 0c             	sub    $0xc,%eax
c0104260:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //找到了合适大小的页块  
        if (p->property >= n) {  
c0104263:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104266:	8b 40 08             	mov    0x8(%eax),%eax
c0104269:	3b 45 08             	cmp    0x8(%ebp),%eax
c010426c:	0f 82 f2 00 00 00    	jb     c0104364 <default_alloc_pages+0x14c>
	    int i;  
	    for(i=0;i<n;i++){  
c0104272:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0104279:	eb 7c                	jmp    c01042f7 <default_alloc_pages+0xdf>
c010427b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010427e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104281:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104284:	8b 40 04             	mov    0x4(%eax),%eax
	        len = list_next(le);  
c0104287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//让pp指向分配的那一页  
		//le2page宏可以根据链表元素获得对应的Page指针p  
		struct Page *pp = le2page(le, page_link);  
c010428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010428d:	83 e8 0c             	sub    $0xc,%eax
c0104290:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//设置每一页的标志位  
		SetPageReserved(pp);  
c0104293:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104296:	83 c0 04             	add    $0x4,%eax
c0104299:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c01042a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01042a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01042a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042a9:	0f ab 10             	bts    %edx,(%eax)
		ClearPageProperty(pp);  
c01042ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042af:	83 c0 04             	add    $0x4,%eax
c01042b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01042b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01042bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042c2:	0f b3 10             	btr    %edx,(%eax)
c01042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01042cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042ce:	8b 40 04             	mov    0x4(%eax),%eax
c01042d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042d4:	8b 12                	mov    (%edx),%edx
c01042d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01042d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01042dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042df:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01042e2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01042e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01042e8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01042eb:	89 10                	mov    %edx,(%eax)
		//清除free_list中的链接  
		list_del(le);  
		le = len;  
c01042ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {  
        struct Page *p = le2page(le, page_link);  
    //找到了合适大小的页块  
        if (p->property >= n) {  
	    int i;  
	    for(i=0;i<n;i++){  
c01042f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01042f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042fa:	3b 45 08             	cmp    0x8(%ebp),%eax
c01042fd:	0f 82 78 ff ff ff    	jb     c010427b <default_alloc_pages+0x63>
		ClearPageProperty(pp);  
		//清除free_list中的链接  
		list_del(le);  
		le = len;  
	    }  
	if(p->property>n){  
c0104303:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104306:	8b 40 08             	mov    0x8(%eax),%eax
c0104309:	3b 45 08             	cmp    0x8(%ebp),%eax
c010430c:	76 12                	jbe    c0104320 <default_alloc_pages+0x108>
	    //分割的页需要重新设置空闲大小  
	    (le2page(le,page_link))->property = p->property - n;  
c010430e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104311:	8d 50 f4             	lea    -0xc(%eax),%edx
c0104314:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104317:	8b 40 08             	mov    0x8(%eax),%eax
c010431a:	2b 45 08             	sub    0x8(%ebp),%eax
c010431d:	89 42 08             	mov    %eax,0x8(%edx)
	}  
	//第一页重置标志位  
	ClearPageProperty(p);  
c0104320:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104323:	83 c0 04             	add    $0x4,%eax
c0104326:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c010432d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104330:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104333:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104336:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(p);  
c0104339:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010433c:	83 c0 04             	add    $0x4,%eax
c010433f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104349:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010434c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010434f:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;  
c0104352:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104357:	2b 45 08             	sub    0x8(%ebp),%eax
c010435a:	a3 64 89 11 c0       	mov    %eax,0xc0118964
	return p;  
c010435f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104362:	eb 21                	jmp    c0104385 <default_alloc_pages+0x16d>
c0104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104367:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010436a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010436d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;  
    }  
    list_entry_t  *len;  
    list_entry_t  *le = &free_list;  
    //在空闲链表中寻找合适大小的页块  
    while ((le = list_next(le)) != &free_list) {  
c0104370:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104373:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c010437a:	0f 85 da fe ff ff    	jne    c010425a <default_alloc_pages+0x42>
	nr_free -= n;  
	return p;  
    }  
}  
//否则分配失败  
    return NULL;  
c0104380:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104385:	c9                   	leave  
c0104386:	c3                   	ret    

c0104387 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104387:	55                   	push   %ebp
c0104388:	89 e5                	mov    %esp,%ebp
c010438a:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010438d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104391:	75 19                	jne    c01043ac <default_free_pages+0x25>
c0104393:	68 f8 67 10 c0       	push   $0xc01067f8
c0104398:	68 fe 67 10 c0       	push   $0xc01067fe
c010439d:	68 83 00 00 00       	push   $0x83
c01043a2:	68 13 68 10 c0       	push   $0xc0106813
c01043a7:	e8 21 c0 ff ff       	call   c01003cd <__panic>
    assert(PageReserved(base));
c01043ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01043af:	83 c0 04             	add    $0x4,%eax
c01043b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c01043b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043c2:	0f a3 10             	bt     %edx,(%eax)
c01043c5:	19 c0                	sbb    %eax,%eax
c01043c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
c01043ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01043ce:	0f 95 c0             	setne  %al
c01043d1:	0f b6 c0             	movzbl %al,%eax
c01043d4:	85 c0                	test   %eax,%eax
c01043d6:	75 19                	jne    c01043f1 <default_free_pages+0x6a>
c01043d8:	68 39 68 10 c0       	push   $0xc0106839
c01043dd:	68 fe 67 10 c0       	push   $0xc01067fe
c01043e2:	68 84 00 00 00       	push   $0x84
c01043e7:	68 13 68 10 c0       	push   $0xc0106813
c01043ec:	e8 dc bf ff ff       	call   c01003cd <__panic>

    list_entry_t *le = &free_list;
c01043f1:	c7 45 f4 5c 89 11 c0 	movl   $0xc011895c,-0xc(%ebp)
    struct Page * p;
//查找该插入的位置le 
    while((le=list_next(le)) != &free_list) {
c01043f8:	eb 11                	jmp    c010440b <default_free_pages+0x84>
      p = le2page(le, page_link);
c01043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043fd:	83 e8 0c             	sub    $0xc,%eax
c0104400:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0104403:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104406:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104409:	77 1a                	ja     c0104425 <default_free_pages+0x9e>
c010440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104411:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104414:	8b 40 04             	mov    0x4(%eax),%eax
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
//查找该插入的位置le 
    while((le=list_next(le)) != &free_list) {
c0104417:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010441a:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104421:	75 d7                	jne    c01043fa <default_free_pages+0x73>
c0104423:	eb 01                	jmp    c0104426 <default_free_pages+0x9f>
      p = le2page(le, page_link);
      if(p>base){
        break;
c0104425:	90                   	nop
      }
    }
//向le之前插入n个页（空闲），并设置标志位  
    for(p=base;p<base+n;p++){
c0104426:	8b 45 08             	mov    0x8(%ebp),%eax
c0104429:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010442c:	eb 4b                	jmp    c0104479 <default_free_pages+0xf2>
      list_add_before(le, &(p->page_link));
c010442e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104431:	8d 50 0c             	lea    0xc(%eax),%edx
c0104434:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104437:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010443a:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010443d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104440:	8b 00                	mov    (%eax),%eax
c0104442:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104445:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104448:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010444b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010444e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104451:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104454:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104457:	89 10                	mov    %edx,(%eax)
c0104459:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010445c:	8b 10                	mov    (%eax),%edx
c010445e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104461:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104464:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104467:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010446a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010446d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104470:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104473:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
//向le之前插入n个页（空闲），并设置标志位  
    for(p=base;p<base+n;p++){
c0104475:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0104479:	8b 55 0c             	mov    0xc(%ebp),%edx
c010447c:	89 d0                	mov    %edx,%eax
c010447e:	c1 e0 02             	shl    $0x2,%eax
c0104481:	01 d0                	add    %edx,%eax
c0104483:	c1 e0 02             	shl    $0x2,%eax
c0104486:	89 c2                	mov    %eax,%edx
c0104488:	8b 45 08             	mov    0x8(%ebp),%eax
c010448b:	01 d0                	add    %edx,%eax
c010448d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104490:	77 9c                	ja     c010442e <default_free_pages+0xa7>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0104492:	8b 45 08             	mov    0x8(%ebp),%eax
c0104495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c010449c:	83 ec 08             	sub    $0x8,%esp
c010449f:	6a 00                	push   $0x0
c01044a1:	ff 75 08             	pushl  0x8(%ebp)
c01044a4:	e8 00 fc ff ff       	call   c01040a9 <set_page_ref>
c01044a9:	83 c4 10             	add    $0x10,%esp
    ClearPageProperty(base);
c01044ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01044af:	83 c0 04             	add    $0x4,%eax
c01044b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c01044b9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044bc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01044bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044c2:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01044c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c8:	83 c0 04             	add    $0x4,%eax
c01044cb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01044d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01044d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01044d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01044db:	0f ab 10             	bts    %edx,(%eax)
//将页块信息记录在头部 
    base->property = n;
c01044de:	8b 45 08             	mov    0x8(%ebp),%eax
c01044e1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044e4:	89 50 08             	mov    %edx,0x8(%eax)
//是否需要合并  
//向高地址合并  
    p = le2page(le,page_link) ;
c01044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ea:	83 e8 0c             	sub    $0xc,%eax
c01044ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c01044f0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044f3:	89 d0                	mov    %edx,%eax
c01044f5:	c1 e0 02             	shl    $0x2,%eax
c01044f8:	01 d0                	add    %edx,%eax
c01044fa:	c1 e0 02             	shl    $0x2,%eax
c01044fd:	89 c2                	mov    %eax,%edx
c01044ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104502:	01 d0                	add    %edx,%eax
c0104504:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104507:	75 1e                	jne    c0104527 <default_free_pages+0x1a0>
      base->property += p->property;
c0104509:	8b 45 08             	mov    0x8(%ebp),%eax
c010450c:	8b 50 08             	mov    0x8(%eax),%edx
c010450f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104512:	8b 40 08             	mov    0x8(%eax),%eax
c0104515:	01 c2                	add    %eax,%edx
c0104517:	8b 45 08             	mov    0x8(%ebp),%eax
c010451a:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c010451d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104520:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
//向低地址合并  
    le = list_prev(&(base->page_link));
c0104527:	8b 45 08             	mov    0x8(%ebp),%eax
c010452a:	83 c0 0c             	add    $0xc,%eax
c010452d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0104530:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104533:	8b 00                	mov    (%eax),%eax
c0104535:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453b:	83 e8 0c             	sub    $0xc,%eax
c010453e:	89 45 f0             	mov    %eax,-0x10(%ebp)
//若低地址已分配则不需要合并
    if(le!=&free_list && p==base-1){
c0104541:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c0104548:	74 57                	je     c01045a1 <default_free_pages+0x21a>
c010454a:	8b 45 08             	mov    0x8(%ebp),%eax
c010454d:	83 e8 14             	sub    $0x14,%eax
c0104550:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104553:	75 4c                	jne    c01045a1 <default_free_pages+0x21a>
      while(le!=&free_list){
c0104555:	eb 41                	jmp    c0104598 <default_free_pages+0x211>
        if(p->property){
c0104557:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455a:	8b 40 08             	mov    0x8(%eax),%eax
c010455d:	85 c0                	test   %eax,%eax
c010455f:	74 20                	je     c0104581 <default_free_pages+0x1fa>
          p->property += base->property;
c0104561:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104564:	8b 50 08             	mov    0x8(%eax),%edx
c0104567:	8b 45 08             	mov    0x8(%ebp),%eax
c010456a:	8b 40 08             	mov    0x8(%eax),%eax
c010456d:	01 c2                	add    %eax,%edx
c010456f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104572:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0104575:	8b 45 08             	mov    0x8(%ebp),%eax
c0104578:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c010457f:	eb 20                	jmp    c01045a1 <default_free_pages+0x21a>
c0104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104584:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104587:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010458a:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c010458c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c010458f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104592:	83 e8 0c             	sub    $0xc,%eax
c0104595:	89 45 f0             	mov    %eax,-0x10(%ebp)
//向低地址合并  
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
//若低地址已分配则不需要合并
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0104598:	81 7d f4 5c 89 11 c0 	cmpl   $0xc011895c,-0xc(%ebp)
c010459f:	75 b6                	jne    c0104557 <default_free_pages+0x1d0>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c01045a1:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c01045a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045aa:	01 d0                	add    %edx,%eax
c01045ac:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    return ;
c01045b1:	90                   	nop
}
c01045b2:	c9                   	leave  
c01045b3:	c3                   	ret    

c01045b4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01045b4:	55                   	push   %ebp
c01045b5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01045b7:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c01045bc:	5d                   	pop    %ebp
c01045bd:	c3                   	ret    

c01045be <basic_check>:

static void
basic_check(void) {
c01045be:	55                   	push   %ebp
c01045bf:	89 e5                	mov    %esp,%ebp
c01045c1:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01045c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01045cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01045d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01045d7:	83 ec 0c             	sub    $0xc,%esp
c01045da:	6a 01                	push   $0x1
c01045dc:	e8 d8 e5 ff ff       	call   c0102bb9 <alloc_pages>
c01045e1:	83 c4 10             	add    $0x10,%esp
c01045e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01045e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01045eb:	75 19                	jne    c0104606 <basic_check+0x48>
c01045ed:	68 4c 68 10 c0       	push   $0xc010684c
c01045f2:	68 fe 67 10 c0       	push   $0xc01067fe
c01045f7:	68 bd 00 00 00       	push   $0xbd
c01045fc:	68 13 68 10 c0       	push   $0xc0106813
c0104601:	e8 c7 bd ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104606:	83 ec 0c             	sub    $0xc,%esp
c0104609:	6a 01                	push   $0x1
c010460b:	e8 a9 e5 ff ff       	call   c0102bb9 <alloc_pages>
c0104610:	83 c4 10             	add    $0x10,%esp
c0104613:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104616:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010461a:	75 19                	jne    c0104635 <basic_check+0x77>
c010461c:	68 68 68 10 c0       	push   $0xc0106868
c0104621:	68 fe 67 10 c0       	push   $0xc01067fe
c0104626:	68 be 00 00 00       	push   $0xbe
c010462b:	68 13 68 10 c0       	push   $0xc0106813
c0104630:	e8 98 bd ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104635:	83 ec 0c             	sub    $0xc,%esp
c0104638:	6a 01                	push   $0x1
c010463a:	e8 7a e5 ff ff       	call   c0102bb9 <alloc_pages>
c010463f:	83 c4 10             	add    $0x10,%esp
c0104642:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104649:	75 19                	jne    c0104664 <basic_check+0xa6>
c010464b:	68 84 68 10 c0       	push   $0xc0106884
c0104650:	68 fe 67 10 c0       	push   $0xc01067fe
c0104655:	68 bf 00 00 00       	push   $0xbf
c010465a:	68 13 68 10 c0       	push   $0xc0106813
c010465f:	e8 69 bd ff ff       	call   c01003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104664:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104667:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010466a:	74 10                	je     c010467c <basic_check+0xbe>
c010466c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010466f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104672:	74 08                	je     c010467c <basic_check+0xbe>
c0104674:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104677:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010467a:	75 19                	jne    c0104695 <basic_check+0xd7>
c010467c:	68 a0 68 10 c0       	push   $0xc01068a0
c0104681:	68 fe 67 10 c0       	push   $0xc01067fe
c0104686:	68 c1 00 00 00       	push   $0xc1
c010468b:	68 13 68 10 c0       	push   $0xc0106813
c0104690:	e8 38 bd ff ff       	call   c01003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104695:	83 ec 0c             	sub    $0xc,%esp
c0104698:	ff 75 ec             	pushl  -0x14(%ebp)
c010469b:	e8 ff f9 ff ff       	call   c010409f <page_ref>
c01046a0:	83 c4 10             	add    $0x10,%esp
c01046a3:	85 c0                	test   %eax,%eax
c01046a5:	75 24                	jne    c01046cb <basic_check+0x10d>
c01046a7:	83 ec 0c             	sub    $0xc,%esp
c01046aa:	ff 75 f0             	pushl  -0x10(%ebp)
c01046ad:	e8 ed f9 ff ff       	call   c010409f <page_ref>
c01046b2:	83 c4 10             	add    $0x10,%esp
c01046b5:	85 c0                	test   %eax,%eax
c01046b7:	75 12                	jne    c01046cb <basic_check+0x10d>
c01046b9:	83 ec 0c             	sub    $0xc,%esp
c01046bc:	ff 75 f4             	pushl  -0xc(%ebp)
c01046bf:	e8 db f9 ff ff       	call   c010409f <page_ref>
c01046c4:	83 c4 10             	add    $0x10,%esp
c01046c7:	85 c0                	test   %eax,%eax
c01046c9:	74 19                	je     c01046e4 <basic_check+0x126>
c01046cb:	68 c4 68 10 c0       	push   $0xc01068c4
c01046d0:	68 fe 67 10 c0       	push   $0xc01067fe
c01046d5:	68 c2 00 00 00       	push   $0xc2
c01046da:	68 13 68 10 c0       	push   $0xc0106813
c01046df:	e8 e9 bc ff ff       	call   c01003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01046e4:	83 ec 0c             	sub    $0xc,%esp
c01046e7:	ff 75 ec             	pushl  -0x14(%ebp)
c01046ea:	e8 9d f9 ff ff       	call   c010408c <page2pa>
c01046ef:	83 c4 10             	add    $0x10,%esp
c01046f2:	89 c2                	mov    %eax,%edx
c01046f4:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046f9:	c1 e0 0c             	shl    $0xc,%eax
c01046fc:	39 c2                	cmp    %eax,%edx
c01046fe:	72 19                	jb     c0104719 <basic_check+0x15b>
c0104700:	68 00 69 10 c0       	push   $0xc0106900
c0104705:	68 fe 67 10 c0       	push   $0xc01067fe
c010470a:	68 c4 00 00 00       	push   $0xc4
c010470f:	68 13 68 10 c0       	push   $0xc0106813
c0104714:	e8 b4 bc ff ff       	call   c01003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104719:	83 ec 0c             	sub    $0xc,%esp
c010471c:	ff 75 f0             	pushl  -0x10(%ebp)
c010471f:	e8 68 f9 ff ff       	call   c010408c <page2pa>
c0104724:	83 c4 10             	add    $0x10,%esp
c0104727:	89 c2                	mov    %eax,%edx
c0104729:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010472e:	c1 e0 0c             	shl    $0xc,%eax
c0104731:	39 c2                	cmp    %eax,%edx
c0104733:	72 19                	jb     c010474e <basic_check+0x190>
c0104735:	68 1d 69 10 c0       	push   $0xc010691d
c010473a:	68 fe 67 10 c0       	push   $0xc01067fe
c010473f:	68 c5 00 00 00       	push   $0xc5
c0104744:	68 13 68 10 c0       	push   $0xc0106813
c0104749:	e8 7f bc ff ff       	call   c01003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010474e:	83 ec 0c             	sub    $0xc,%esp
c0104751:	ff 75 f4             	pushl  -0xc(%ebp)
c0104754:	e8 33 f9 ff ff       	call   c010408c <page2pa>
c0104759:	83 c4 10             	add    $0x10,%esp
c010475c:	89 c2                	mov    %eax,%edx
c010475e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104763:	c1 e0 0c             	shl    $0xc,%eax
c0104766:	39 c2                	cmp    %eax,%edx
c0104768:	72 19                	jb     c0104783 <basic_check+0x1c5>
c010476a:	68 3a 69 10 c0       	push   $0xc010693a
c010476f:	68 fe 67 10 c0       	push   $0xc01067fe
c0104774:	68 c6 00 00 00       	push   $0xc6
c0104779:	68 13 68 10 c0       	push   $0xc0106813
c010477e:	e8 4a bc ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104783:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104788:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c010478e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104791:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104794:	c7 45 e4 5c 89 11 c0 	movl   $0xc011895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010479b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010479e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047a1:	89 50 04             	mov    %edx,0x4(%eax)
c01047a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047a7:	8b 50 04             	mov    0x4(%eax),%edx
c01047aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ad:	89 10                	mov    %edx,(%eax)
c01047af:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01047b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01047b9:	8b 40 04             	mov    0x4(%eax),%eax
c01047bc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01047bf:	0f 94 c0             	sete   %al
c01047c2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01047c5:	85 c0                	test   %eax,%eax
c01047c7:	75 19                	jne    c01047e2 <basic_check+0x224>
c01047c9:	68 57 69 10 c0       	push   $0xc0106957
c01047ce:	68 fe 67 10 c0       	push   $0xc01067fe
c01047d3:	68 ca 00 00 00       	push   $0xca
c01047d8:	68 13 68 10 c0       	push   $0xc0106813
c01047dd:	e8 eb bb ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c01047e2:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01047e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01047ea:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c01047f1:	00 00 00 

    assert(alloc_page() == NULL);
c01047f4:	83 ec 0c             	sub    $0xc,%esp
c01047f7:	6a 01                	push   $0x1
c01047f9:	e8 bb e3 ff ff       	call   c0102bb9 <alloc_pages>
c01047fe:	83 c4 10             	add    $0x10,%esp
c0104801:	85 c0                	test   %eax,%eax
c0104803:	74 19                	je     c010481e <basic_check+0x260>
c0104805:	68 6e 69 10 c0       	push   $0xc010696e
c010480a:	68 fe 67 10 c0       	push   $0xc01067fe
c010480f:	68 cf 00 00 00       	push   $0xcf
c0104814:	68 13 68 10 c0       	push   $0xc0106813
c0104819:	e8 af bb ff ff       	call   c01003cd <__panic>

    free_page(p0);
c010481e:	83 ec 08             	sub    $0x8,%esp
c0104821:	6a 01                	push   $0x1
c0104823:	ff 75 ec             	pushl  -0x14(%ebp)
c0104826:	e8 cc e3 ff ff       	call   c0102bf7 <free_pages>
c010482b:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010482e:	83 ec 08             	sub    $0x8,%esp
c0104831:	6a 01                	push   $0x1
c0104833:	ff 75 f0             	pushl  -0x10(%ebp)
c0104836:	e8 bc e3 ff ff       	call   c0102bf7 <free_pages>
c010483b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010483e:	83 ec 08             	sub    $0x8,%esp
c0104841:	6a 01                	push   $0x1
c0104843:	ff 75 f4             	pushl  -0xc(%ebp)
c0104846:	e8 ac e3 ff ff       	call   c0102bf7 <free_pages>
c010484b:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010484e:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104853:	83 f8 03             	cmp    $0x3,%eax
c0104856:	74 19                	je     c0104871 <basic_check+0x2b3>
c0104858:	68 83 69 10 c0       	push   $0xc0106983
c010485d:	68 fe 67 10 c0       	push   $0xc01067fe
c0104862:	68 d4 00 00 00       	push   $0xd4
c0104867:	68 13 68 10 c0       	push   $0xc0106813
c010486c:	e8 5c bb ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104871:	83 ec 0c             	sub    $0xc,%esp
c0104874:	6a 01                	push   $0x1
c0104876:	e8 3e e3 ff ff       	call   c0102bb9 <alloc_pages>
c010487b:	83 c4 10             	add    $0x10,%esp
c010487e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104885:	75 19                	jne    c01048a0 <basic_check+0x2e2>
c0104887:	68 4c 68 10 c0       	push   $0xc010684c
c010488c:	68 fe 67 10 c0       	push   $0xc01067fe
c0104891:	68 d6 00 00 00       	push   $0xd6
c0104896:	68 13 68 10 c0       	push   $0xc0106813
c010489b:	e8 2d bb ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01048a0:	83 ec 0c             	sub    $0xc,%esp
c01048a3:	6a 01                	push   $0x1
c01048a5:	e8 0f e3 ff ff       	call   c0102bb9 <alloc_pages>
c01048aa:	83 c4 10             	add    $0x10,%esp
c01048ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048b4:	75 19                	jne    c01048cf <basic_check+0x311>
c01048b6:	68 68 68 10 c0       	push   $0xc0106868
c01048bb:	68 fe 67 10 c0       	push   $0xc01067fe
c01048c0:	68 d7 00 00 00       	push   $0xd7
c01048c5:	68 13 68 10 c0       	push   $0xc0106813
c01048ca:	e8 fe ba ff ff       	call   c01003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048cf:	83 ec 0c             	sub    $0xc,%esp
c01048d2:	6a 01                	push   $0x1
c01048d4:	e8 e0 e2 ff ff       	call   c0102bb9 <alloc_pages>
c01048d9:	83 c4 10             	add    $0x10,%esp
c01048dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048e3:	75 19                	jne    c01048fe <basic_check+0x340>
c01048e5:	68 84 68 10 c0       	push   $0xc0106884
c01048ea:	68 fe 67 10 c0       	push   $0xc01067fe
c01048ef:	68 d8 00 00 00       	push   $0xd8
c01048f4:	68 13 68 10 c0       	push   $0xc0106813
c01048f9:	e8 cf ba ff ff       	call   c01003cd <__panic>

    assert(alloc_page() == NULL);
c01048fe:	83 ec 0c             	sub    $0xc,%esp
c0104901:	6a 01                	push   $0x1
c0104903:	e8 b1 e2 ff ff       	call   c0102bb9 <alloc_pages>
c0104908:	83 c4 10             	add    $0x10,%esp
c010490b:	85 c0                	test   %eax,%eax
c010490d:	74 19                	je     c0104928 <basic_check+0x36a>
c010490f:	68 6e 69 10 c0       	push   $0xc010696e
c0104914:	68 fe 67 10 c0       	push   $0xc01067fe
c0104919:	68 da 00 00 00       	push   $0xda
c010491e:	68 13 68 10 c0       	push   $0xc0106813
c0104923:	e8 a5 ba ff ff       	call   c01003cd <__panic>

    free_page(p0);
c0104928:	83 ec 08             	sub    $0x8,%esp
c010492b:	6a 01                	push   $0x1
c010492d:	ff 75 ec             	pushl  -0x14(%ebp)
c0104930:	e8 c2 e2 ff ff       	call   c0102bf7 <free_pages>
c0104935:	83 c4 10             	add    $0x10,%esp
c0104938:	c7 45 e8 5c 89 11 c0 	movl   $0xc011895c,-0x18(%ebp)
c010493f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104942:	8b 40 04             	mov    0x4(%eax),%eax
c0104945:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104948:	0f 94 c0             	sete   %al
c010494b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010494e:	85 c0                	test   %eax,%eax
c0104950:	74 19                	je     c010496b <basic_check+0x3ad>
c0104952:	68 90 69 10 c0       	push   $0xc0106990
c0104957:	68 fe 67 10 c0       	push   $0xc01067fe
c010495c:	68 dd 00 00 00       	push   $0xdd
c0104961:	68 13 68 10 c0       	push   $0xc0106813
c0104966:	e8 62 ba ff ff       	call   c01003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010496b:	83 ec 0c             	sub    $0xc,%esp
c010496e:	6a 01                	push   $0x1
c0104970:	e8 44 e2 ff ff       	call   c0102bb9 <alloc_pages>
c0104975:	83 c4 10             	add    $0x10,%esp
c0104978:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010497b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010497e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104981:	74 19                	je     c010499c <basic_check+0x3de>
c0104983:	68 a8 69 10 c0       	push   $0xc01069a8
c0104988:	68 fe 67 10 c0       	push   $0xc01067fe
c010498d:	68 e0 00 00 00       	push   $0xe0
c0104992:	68 13 68 10 c0       	push   $0xc0106813
c0104997:	e8 31 ba ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c010499c:	83 ec 0c             	sub    $0xc,%esp
c010499f:	6a 01                	push   $0x1
c01049a1:	e8 13 e2 ff ff       	call   c0102bb9 <alloc_pages>
c01049a6:	83 c4 10             	add    $0x10,%esp
c01049a9:	85 c0                	test   %eax,%eax
c01049ab:	74 19                	je     c01049c6 <basic_check+0x408>
c01049ad:	68 6e 69 10 c0       	push   $0xc010696e
c01049b2:	68 fe 67 10 c0       	push   $0xc01067fe
c01049b7:	68 e1 00 00 00       	push   $0xe1
c01049bc:	68 13 68 10 c0       	push   $0xc0106813
c01049c1:	e8 07 ba ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c01049c6:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01049cb:	85 c0                	test   %eax,%eax
c01049cd:	74 19                	je     c01049e8 <basic_check+0x42a>
c01049cf:	68 c1 69 10 c0       	push   $0xc01069c1
c01049d4:	68 fe 67 10 c0       	push   $0xc01067fe
c01049d9:	68 e3 00 00 00       	push   $0xe3
c01049de:	68 13 68 10 c0       	push   $0xc0106813
c01049e3:	e8 e5 b9 ff ff       	call   c01003cd <__panic>
    free_list = free_list_store;
c01049e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049ee:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c01049f3:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c01049f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01049fc:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_page(p);
c0104a01:	83 ec 08             	sub    $0x8,%esp
c0104a04:	6a 01                	push   $0x1
c0104a06:	ff 75 dc             	pushl  -0x24(%ebp)
c0104a09:	e8 e9 e1 ff ff       	call   c0102bf7 <free_pages>
c0104a0e:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c0104a11:	83 ec 08             	sub    $0x8,%esp
c0104a14:	6a 01                	push   $0x1
c0104a16:	ff 75 f0             	pushl  -0x10(%ebp)
c0104a19:	e8 d9 e1 ff ff       	call   c0102bf7 <free_pages>
c0104a1e:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104a21:	83 ec 08             	sub    $0x8,%esp
c0104a24:	6a 01                	push   $0x1
c0104a26:	ff 75 f4             	pushl  -0xc(%ebp)
c0104a29:	e8 c9 e1 ff ff       	call   c0102bf7 <free_pages>
c0104a2e:	83 c4 10             	add    $0x10,%esp
}
c0104a31:	90                   	nop
c0104a32:	c9                   	leave  
c0104a33:	c3                   	ret    

c0104a34 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a34:	55                   	push   %ebp
c0104a35:	89 e5                	mov    %esp,%ebp
c0104a37:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0104a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a4b:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a52:	eb 60                	jmp    c0104ab4 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0104a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a57:	83 e8 0c             	sub    $0xc,%eax
c0104a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a60:	83 c0 04             	add    $0x4,%eax
c0104a63:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104a6a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a6d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104a70:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104a73:	0f a3 10             	bt     %edx,(%eax)
c0104a76:	19 c0                	sbb    %eax,%eax
c0104a78:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104a7b:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104a7f:	0f 95 c0             	setne  %al
c0104a82:	0f b6 c0             	movzbl %al,%eax
c0104a85:	85 c0                	test   %eax,%eax
c0104a87:	75 19                	jne    c0104aa2 <default_check+0x6e>
c0104a89:	68 ce 69 10 c0       	push   $0xc01069ce
c0104a8e:	68 fe 67 10 c0       	push   $0xc01067fe
c0104a93:	68 f4 00 00 00       	push   $0xf4
c0104a98:	68 13 68 10 c0       	push   $0xc0106813
c0104a9d:	e8 2b b9 ff ff       	call   c01003cd <__panic>
        count ++, total += p->property;
c0104aa2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104aa9:	8b 50 08             	mov    0x8(%eax),%edx
c0104aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aaf:	01 d0                	add    %edx,%eax
c0104ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104abd:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ac3:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104aca:	75 88                	jne    c0104a54 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104acc:	e8 5b e1 ff ff       	call   c0102c2c <nr_free_pages>
c0104ad1:	89 c2                	mov    %eax,%edx
c0104ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad6:	39 c2                	cmp    %eax,%edx
c0104ad8:	74 19                	je     c0104af3 <default_check+0xbf>
c0104ada:	68 de 69 10 c0       	push   $0xc01069de
c0104adf:	68 fe 67 10 c0       	push   $0xc01067fe
c0104ae4:	68 f7 00 00 00       	push   $0xf7
c0104ae9:	68 13 68 10 c0       	push   $0xc0106813
c0104aee:	e8 da b8 ff ff       	call   c01003cd <__panic>

    basic_check();
c0104af3:	e8 c6 fa ff ff       	call   c01045be <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104af8:	83 ec 0c             	sub    $0xc,%esp
c0104afb:	6a 05                	push   $0x5
c0104afd:	e8 b7 e0 ff ff       	call   c0102bb9 <alloc_pages>
c0104b02:	83 c4 10             	add    $0x10,%esp
c0104b05:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104b08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104b0c:	75 19                	jne    c0104b27 <default_check+0xf3>
c0104b0e:	68 f7 69 10 c0       	push   $0xc01069f7
c0104b13:	68 fe 67 10 c0       	push   $0xc01067fe
c0104b18:	68 fc 00 00 00       	push   $0xfc
c0104b1d:	68 13 68 10 c0       	push   $0xc0106813
c0104b22:	e8 a6 b8 ff ff       	call   c01003cd <__panic>
    assert(!PageProperty(p0));
c0104b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b2a:	83 c0 04             	add    $0x4,%eax
c0104b2d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104b34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b3d:	0f a3 10             	bt     %edx,(%eax)
c0104b40:	19 c0                	sbb    %eax,%eax
c0104b42:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104b45:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104b49:	0f 95 c0             	setne  %al
c0104b4c:	0f b6 c0             	movzbl %al,%eax
c0104b4f:	85 c0                	test   %eax,%eax
c0104b51:	74 19                	je     c0104b6c <default_check+0x138>
c0104b53:	68 02 6a 10 c0       	push   $0xc0106a02
c0104b58:	68 fe 67 10 c0       	push   $0xc01067fe
c0104b5d:	68 fd 00 00 00       	push   $0xfd
c0104b62:	68 13 68 10 c0       	push   $0xc0106813
c0104b67:	e8 61 b8 ff ff       	call   c01003cd <__panic>

    list_entry_t free_list_store = free_list;
c0104b6c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104b71:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104b77:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104b7a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104b7d:	c7 45 d0 5c 89 11 c0 	movl   $0xc011895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104b84:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b87:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104b8a:	89 50 04             	mov    %edx,0x4(%eax)
c0104b8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b90:	8b 50 04             	mov    0x4(%eax),%edx
c0104b93:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b96:	89 10                	mov    %edx,(%eax)
c0104b98:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104b9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104ba2:	8b 40 04             	mov    0x4(%eax),%eax
c0104ba5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104ba8:	0f 94 c0             	sete   %al
c0104bab:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104bae:	85 c0                	test   %eax,%eax
c0104bb0:	75 19                	jne    c0104bcb <default_check+0x197>
c0104bb2:	68 57 69 10 c0       	push   $0xc0106957
c0104bb7:	68 fe 67 10 c0       	push   $0xc01067fe
c0104bbc:	68 01 01 00 00       	push   $0x101
c0104bc1:	68 13 68 10 c0       	push   $0xc0106813
c0104bc6:	e8 02 b8 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104bcb:	83 ec 0c             	sub    $0xc,%esp
c0104bce:	6a 01                	push   $0x1
c0104bd0:	e8 e4 df ff ff       	call   c0102bb9 <alloc_pages>
c0104bd5:	83 c4 10             	add    $0x10,%esp
c0104bd8:	85 c0                	test   %eax,%eax
c0104bda:	74 19                	je     c0104bf5 <default_check+0x1c1>
c0104bdc:	68 6e 69 10 c0       	push   $0xc010696e
c0104be1:	68 fe 67 10 c0       	push   $0xc01067fe
c0104be6:	68 02 01 00 00       	push   $0x102
c0104beb:	68 13 68 10 c0       	push   $0xc0106813
c0104bf0:	e8 d8 b7 ff ff       	call   c01003cd <__panic>

    unsigned int nr_free_store = nr_free;
c0104bf5:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104bfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104bfd:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104c04:	00 00 00 

    free_pages(p0 + 2, 3);
c0104c07:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c0a:	83 c0 28             	add    $0x28,%eax
c0104c0d:	83 ec 08             	sub    $0x8,%esp
c0104c10:	6a 03                	push   $0x3
c0104c12:	50                   	push   %eax
c0104c13:	e8 df df ff ff       	call   c0102bf7 <free_pages>
c0104c18:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0104c1b:	83 ec 0c             	sub    $0xc,%esp
c0104c1e:	6a 04                	push   $0x4
c0104c20:	e8 94 df ff ff       	call   c0102bb9 <alloc_pages>
c0104c25:	83 c4 10             	add    $0x10,%esp
c0104c28:	85 c0                	test   %eax,%eax
c0104c2a:	74 19                	je     c0104c45 <default_check+0x211>
c0104c2c:	68 14 6a 10 c0       	push   $0xc0106a14
c0104c31:	68 fe 67 10 c0       	push   $0xc01067fe
c0104c36:	68 08 01 00 00       	push   $0x108
c0104c3b:	68 13 68 10 c0       	push   $0xc0106813
c0104c40:	e8 88 b7 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104c45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c48:	83 c0 28             	add    $0x28,%eax
c0104c4b:	83 c0 04             	add    $0x4,%eax
c0104c4e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104c55:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c58:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104c5b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104c5e:	0f a3 10             	bt     %edx,(%eax)
c0104c61:	19 c0                	sbb    %eax,%eax
c0104c63:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104c66:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104c6a:	0f 95 c0             	setne  %al
c0104c6d:	0f b6 c0             	movzbl %al,%eax
c0104c70:	85 c0                	test   %eax,%eax
c0104c72:	74 0e                	je     c0104c82 <default_check+0x24e>
c0104c74:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c77:	83 c0 28             	add    $0x28,%eax
c0104c7a:	8b 40 08             	mov    0x8(%eax),%eax
c0104c7d:	83 f8 03             	cmp    $0x3,%eax
c0104c80:	74 19                	je     c0104c9b <default_check+0x267>
c0104c82:	68 2c 6a 10 c0       	push   $0xc0106a2c
c0104c87:	68 fe 67 10 c0       	push   $0xc01067fe
c0104c8c:	68 09 01 00 00       	push   $0x109
c0104c91:	68 13 68 10 c0       	push   $0xc0106813
c0104c96:	e8 32 b7 ff ff       	call   c01003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104c9b:	83 ec 0c             	sub    $0xc,%esp
c0104c9e:	6a 03                	push   $0x3
c0104ca0:	e8 14 df ff ff       	call   c0102bb9 <alloc_pages>
c0104ca5:	83 c4 10             	add    $0x10,%esp
c0104ca8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104cab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104caf:	75 19                	jne    c0104cca <default_check+0x296>
c0104cb1:	68 58 6a 10 c0       	push   $0xc0106a58
c0104cb6:	68 fe 67 10 c0       	push   $0xc01067fe
c0104cbb:	68 0a 01 00 00       	push   $0x10a
c0104cc0:	68 13 68 10 c0       	push   $0xc0106813
c0104cc5:	e8 03 b7 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104cca:	83 ec 0c             	sub    $0xc,%esp
c0104ccd:	6a 01                	push   $0x1
c0104ccf:	e8 e5 de ff ff       	call   c0102bb9 <alloc_pages>
c0104cd4:	83 c4 10             	add    $0x10,%esp
c0104cd7:	85 c0                	test   %eax,%eax
c0104cd9:	74 19                	je     c0104cf4 <default_check+0x2c0>
c0104cdb:	68 6e 69 10 c0       	push   $0xc010696e
c0104ce0:	68 fe 67 10 c0       	push   $0xc01067fe
c0104ce5:	68 0b 01 00 00       	push   $0x10b
c0104cea:	68 13 68 10 c0       	push   $0xc0106813
c0104cef:	e8 d9 b6 ff ff       	call   c01003cd <__panic>
    assert(p0 + 2 == p1);
c0104cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cf7:	83 c0 28             	add    $0x28,%eax
c0104cfa:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104cfd:	74 19                	je     c0104d18 <default_check+0x2e4>
c0104cff:	68 76 6a 10 c0       	push   $0xc0106a76
c0104d04:	68 fe 67 10 c0       	push   $0xc01067fe
c0104d09:	68 0c 01 00 00       	push   $0x10c
c0104d0e:	68 13 68 10 c0       	push   $0xc0106813
c0104d13:	e8 b5 b6 ff ff       	call   c01003cd <__panic>

    p2 = p0 + 1;
c0104d18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d1b:	83 c0 14             	add    $0x14,%eax
c0104d1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104d21:	83 ec 08             	sub    $0x8,%esp
c0104d24:	6a 01                	push   $0x1
c0104d26:	ff 75 dc             	pushl  -0x24(%ebp)
c0104d29:	e8 c9 de ff ff       	call   c0102bf7 <free_pages>
c0104d2e:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c0104d31:	83 ec 08             	sub    $0x8,%esp
c0104d34:	6a 03                	push   $0x3
c0104d36:	ff 75 c4             	pushl  -0x3c(%ebp)
c0104d39:	e8 b9 de ff ff       	call   c0102bf7 <free_pages>
c0104d3e:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c0104d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d44:	83 c0 04             	add    $0x4,%eax
c0104d47:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104d4e:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d51:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104d54:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104d57:	0f a3 10             	bt     %edx,(%eax)
c0104d5a:	19 c0                	sbb    %eax,%eax
c0104d5c:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104d5f:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104d63:	0f 95 c0             	setne  %al
c0104d66:	0f b6 c0             	movzbl %al,%eax
c0104d69:	85 c0                	test   %eax,%eax
c0104d6b:	74 0b                	je     c0104d78 <default_check+0x344>
c0104d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d70:	8b 40 08             	mov    0x8(%eax),%eax
c0104d73:	83 f8 01             	cmp    $0x1,%eax
c0104d76:	74 19                	je     c0104d91 <default_check+0x35d>
c0104d78:	68 84 6a 10 c0       	push   $0xc0106a84
c0104d7d:	68 fe 67 10 c0       	push   $0xc01067fe
c0104d82:	68 11 01 00 00       	push   $0x111
c0104d87:	68 13 68 10 c0       	push   $0xc0106813
c0104d8c:	e8 3c b6 ff ff       	call   c01003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104d91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104d94:	83 c0 04             	add    $0x4,%eax
c0104d97:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104d9e:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104da1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104da4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104da7:	0f a3 10             	bt     %edx,(%eax)
c0104daa:	19 c0                	sbb    %eax,%eax
c0104dac:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104daf:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104db3:	0f 95 c0             	setne  %al
c0104db6:	0f b6 c0             	movzbl %al,%eax
c0104db9:	85 c0                	test   %eax,%eax
c0104dbb:	74 0b                	je     c0104dc8 <default_check+0x394>
c0104dbd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104dc0:	8b 40 08             	mov    0x8(%eax),%eax
c0104dc3:	83 f8 03             	cmp    $0x3,%eax
c0104dc6:	74 19                	je     c0104de1 <default_check+0x3ad>
c0104dc8:	68 ac 6a 10 c0       	push   $0xc0106aac
c0104dcd:	68 fe 67 10 c0       	push   $0xc01067fe
c0104dd2:	68 12 01 00 00       	push   $0x112
c0104dd7:	68 13 68 10 c0       	push   $0xc0106813
c0104ddc:	e8 ec b5 ff ff       	call   c01003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104de1:	83 ec 0c             	sub    $0xc,%esp
c0104de4:	6a 01                	push   $0x1
c0104de6:	e8 ce dd ff ff       	call   c0102bb9 <alloc_pages>
c0104deb:	83 c4 10             	add    $0x10,%esp
c0104dee:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104df1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104df4:	83 e8 14             	sub    $0x14,%eax
c0104df7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104dfa:	74 19                	je     c0104e15 <default_check+0x3e1>
c0104dfc:	68 d2 6a 10 c0       	push   $0xc0106ad2
c0104e01:	68 fe 67 10 c0       	push   $0xc01067fe
c0104e06:	68 14 01 00 00       	push   $0x114
c0104e0b:	68 13 68 10 c0       	push   $0xc0106813
c0104e10:	e8 b8 b5 ff ff       	call   c01003cd <__panic>
    free_page(p0);
c0104e15:	83 ec 08             	sub    $0x8,%esp
c0104e18:	6a 01                	push   $0x1
c0104e1a:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e1d:	e8 d5 dd ff ff       	call   c0102bf7 <free_pages>
c0104e22:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104e25:	83 ec 0c             	sub    $0xc,%esp
c0104e28:	6a 02                	push   $0x2
c0104e2a:	e8 8a dd ff ff       	call   c0102bb9 <alloc_pages>
c0104e2f:	83 c4 10             	add    $0x10,%esp
c0104e32:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e35:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104e38:	83 c0 14             	add    $0x14,%eax
c0104e3b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e3e:	74 19                	je     c0104e59 <default_check+0x425>
c0104e40:	68 f0 6a 10 c0       	push   $0xc0106af0
c0104e45:	68 fe 67 10 c0       	push   $0xc01067fe
c0104e4a:	68 16 01 00 00       	push   $0x116
c0104e4f:	68 13 68 10 c0       	push   $0xc0106813
c0104e54:	e8 74 b5 ff ff       	call   c01003cd <__panic>

    free_pages(p0, 2);
c0104e59:	83 ec 08             	sub    $0x8,%esp
c0104e5c:	6a 02                	push   $0x2
c0104e5e:	ff 75 dc             	pushl  -0x24(%ebp)
c0104e61:	e8 91 dd ff ff       	call   c0102bf7 <free_pages>
c0104e66:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0104e69:	83 ec 08             	sub    $0x8,%esp
c0104e6c:	6a 01                	push   $0x1
c0104e6e:	ff 75 c0             	pushl  -0x40(%ebp)
c0104e71:	e8 81 dd ff ff       	call   c0102bf7 <free_pages>
c0104e76:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0104e79:	83 ec 0c             	sub    $0xc,%esp
c0104e7c:	6a 05                	push   $0x5
c0104e7e:	e8 36 dd ff ff       	call   c0102bb9 <alloc_pages>
c0104e83:	83 c4 10             	add    $0x10,%esp
c0104e86:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e89:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104e8d:	75 19                	jne    c0104ea8 <default_check+0x474>
c0104e8f:	68 10 6b 10 c0       	push   $0xc0106b10
c0104e94:	68 fe 67 10 c0       	push   $0xc01067fe
c0104e99:	68 1b 01 00 00       	push   $0x11b
c0104e9e:	68 13 68 10 c0       	push   $0xc0106813
c0104ea3:	e8 25 b5 ff ff       	call   c01003cd <__panic>
    assert(alloc_page() == NULL);
c0104ea8:	83 ec 0c             	sub    $0xc,%esp
c0104eab:	6a 01                	push   $0x1
c0104ead:	e8 07 dd ff ff       	call   c0102bb9 <alloc_pages>
c0104eb2:	83 c4 10             	add    $0x10,%esp
c0104eb5:	85 c0                	test   %eax,%eax
c0104eb7:	74 19                	je     c0104ed2 <default_check+0x49e>
c0104eb9:	68 6e 69 10 c0       	push   $0xc010696e
c0104ebe:	68 fe 67 10 c0       	push   $0xc01067fe
c0104ec3:	68 1c 01 00 00       	push   $0x11c
c0104ec8:	68 13 68 10 c0       	push   $0xc0106813
c0104ecd:	e8 fb b4 ff ff       	call   c01003cd <__panic>

    assert(nr_free == 0);
c0104ed2:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104ed7:	85 c0                	test   %eax,%eax
c0104ed9:	74 19                	je     c0104ef4 <default_check+0x4c0>
c0104edb:	68 c1 69 10 c0       	push   $0xc01069c1
c0104ee0:	68 fe 67 10 c0       	push   $0xc01067fe
c0104ee5:	68 1e 01 00 00       	push   $0x11e
c0104eea:	68 13 68 10 c0       	push   $0xc0106813
c0104eef:	e8 d9 b4 ff ff       	call   c01003cd <__panic>
    nr_free = nr_free_store;
c0104ef4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104ef7:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c0104efc:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104eff:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104f02:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104f07:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c0104f0d:	83 ec 08             	sub    $0x8,%esp
c0104f10:	6a 05                	push   $0x5
c0104f12:	ff 75 dc             	pushl  -0x24(%ebp)
c0104f15:	e8 dd dc ff ff       	call   c0102bf7 <free_pages>
c0104f1a:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0104f1d:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f24:	eb 1d                	jmp    c0104f43 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
c0104f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f29:	83 e8 0c             	sub    $0xc,%eax
c0104f2c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c0104f2f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104f33:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104f36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104f39:	8b 40 08             	mov    0x8(%eax),%eax
c0104f3c:	29 c2                	sub    %eax,%edx
c0104f3e:	89 d0                	mov    %edx,%eax
c0104f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f46:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104f49:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f4c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104f52:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104f59:	75 cb                	jne    c0104f26 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f5f:	74 19                	je     c0104f7a <default_check+0x546>
c0104f61:	68 2e 6b 10 c0       	push   $0xc0106b2e
c0104f66:	68 fe 67 10 c0       	push   $0xc01067fe
c0104f6b:	68 29 01 00 00       	push   $0x129
c0104f70:	68 13 68 10 c0       	push   $0xc0106813
c0104f75:	e8 53 b4 ff ff       	call   c01003cd <__panic>
    assert(total == 0);
c0104f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104f7e:	74 19                	je     c0104f99 <default_check+0x565>
c0104f80:	68 39 6b 10 c0       	push   $0xc0106b39
c0104f85:	68 fe 67 10 c0       	push   $0xc01067fe
c0104f8a:	68 2a 01 00 00       	push   $0x12a
c0104f8f:	68 13 68 10 c0       	push   $0xc0106813
c0104f94:	e8 34 b4 ff ff       	call   c01003cd <__panic>
}
c0104f99:	90                   	nop
c0104f9a:	c9                   	leave  
c0104f9b:	c3                   	ret    

c0104f9c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0104f9c:	55                   	push   %ebp
c0104f9d:	89 e5                	mov    %esp,%ebp
c0104f9f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0104fa9:	eb 04                	jmp    c0104faf <strlen+0x13>
        cnt ++;
c0104fab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0104faf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fb2:	8d 50 01             	lea    0x1(%eax),%edx
c0104fb5:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fb8:	0f b6 00             	movzbl (%eax),%eax
c0104fbb:	84 c0                	test   %al,%al
c0104fbd:	75 ec                	jne    c0104fab <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0104fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104fc2:	c9                   	leave  
c0104fc3:	c3                   	ret    

c0104fc4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0104fc4:	55                   	push   %ebp
c0104fc5:	89 e5                	mov    %esp,%ebp
c0104fc7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0104fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0104fd1:	eb 04                	jmp    c0104fd7 <strnlen+0x13>
        cnt ++;
c0104fd3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0104fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104fda:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104fdd:	73 10                	jae    c0104fef <strnlen+0x2b>
c0104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe2:	8d 50 01             	lea    0x1(%eax),%edx
c0104fe5:	89 55 08             	mov    %edx,0x8(%ebp)
c0104fe8:	0f b6 00             	movzbl (%eax),%eax
c0104feb:	84 c0                	test   %al,%al
c0104fed:	75 e4                	jne    c0104fd3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0104fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104ff2:	c9                   	leave  
c0104ff3:	c3                   	ret    

c0104ff4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0104ff4:	55                   	push   %ebp
c0104ff5:	89 e5                	mov    %esp,%ebp
c0104ff7:	57                   	push   %edi
c0104ff8:	56                   	push   %esi
c0104ff9:	83 ec 20             	sub    $0x20,%esp
c0104ffc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105002:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105005:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105008:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010500b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010500e:	89 d1                	mov    %edx,%ecx
c0105010:	89 c2                	mov    %eax,%edx
c0105012:	89 ce                	mov    %ecx,%esi
c0105014:	89 d7                	mov    %edx,%edi
c0105016:	ac                   	lods   %ds:(%esi),%al
c0105017:	aa                   	stos   %al,%es:(%edi)
c0105018:	84 c0                	test   %al,%al
c010501a:	75 fa                	jne    c0105016 <strcpy+0x22>
c010501c:	89 fa                	mov    %edi,%edx
c010501e:	89 f1                	mov    %esi,%ecx
c0105020:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105023:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105029:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010502c:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010502d:	83 c4 20             	add    $0x20,%esp
c0105030:	5e                   	pop    %esi
c0105031:	5f                   	pop    %edi
c0105032:	5d                   	pop    %ebp
c0105033:	c3                   	ret    

c0105034 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105034:	55                   	push   %ebp
c0105035:	89 e5                	mov    %esp,%ebp
c0105037:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010503a:	8b 45 08             	mov    0x8(%ebp),%eax
c010503d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105040:	eb 21                	jmp    c0105063 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105042:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105045:	0f b6 10             	movzbl (%eax),%edx
c0105048:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010504b:	88 10                	mov    %dl,(%eax)
c010504d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105050:	0f b6 00             	movzbl (%eax),%eax
c0105053:	84 c0                	test   %al,%al
c0105055:	74 04                	je     c010505b <strncpy+0x27>
            src ++;
c0105057:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010505b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010505f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105067:	75 d9                	jne    c0105042 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105069:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010506c:	c9                   	leave  
c010506d:	c3                   	ret    

c010506e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010506e:	55                   	push   %ebp
c010506f:	89 e5                	mov    %esp,%ebp
c0105071:	57                   	push   %edi
c0105072:	56                   	push   %esi
c0105073:	83 ec 20             	sub    $0x20,%esp
c0105076:	8b 45 08             	mov    0x8(%ebp),%eax
c0105079:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010507c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010507f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105082:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105085:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105088:	89 d1                	mov    %edx,%ecx
c010508a:	89 c2                	mov    %eax,%edx
c010508c:	89 ce                	mov    %ecx,%esi
c010508e:	89 d7                	mov    %edx,%edi
c0105090:	ac                   	lods   %ds:(%esi),%al
c0105091:	ae                   	scas   %es:(%edi),%al
c0105092:	75 08                	jne    c010509c <strcmp+0x2e>
c0105094:	84 c0                	test   %al,%al
c0105096:	75 f8                	jne    c0105090 <strcmp+0x22>
c0105098:	31 c0                	xor    %eax,%eax
c010509a:	eb 04                	jmp    c01050a0 <strcmp+0x32>
c010509c:	19 c0                	sbb    %eax,%eax
c010509e:	0c 01                	or     $0x1,%al
c01050a0:	89 fa                	mov    %edi,%edx
c01050a2:	89 f1                	mov    %esi,%ecx
c01050a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050a7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01050aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01050ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01050b0:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01050b1:	83 c4 20             	add    $0x20,%esp
c01050b4:	5e                   	pop    %esi
c01050b5:	5f                   	pop    %edi
c01050b6:	5d                   	pop    %ebp
c01050b7:	c3                   	ret    

c01050b8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01050b8:	55                   	push   %ebp
c01050b9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050bb:	eb 0c                	jmp    c01050c9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01050bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01050c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01050c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01050c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050cd:	74 1a                	je     c01050e9 <strncmp+0x31>
c01050cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01050d2:	0f b6 00             	movzbl (%eax),%eax
c01050d5:	84 c0                	test   %al,%al
c01050d7:	74 10                	je     c01050e9 <strncmp+0x31>
c01050d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050dc:	0f b6 10             	movzbl (%eax),%edx
c01050df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050e2:	0f b6 00             	movzbl (%eax),%eax
c01050e5:	38 c2                	cmp    %al,%dl
c01050e7:	74 d4                	je     c01050bd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01050e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01050ed:	74 18                	je     c0105107 <strncmp+0x4f>
c01050ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01050f2:	0f b6 00             	movzbl (%eax),%eax
c01050f5:	0f b6 d0             	movzbl %al,%edx
c01050f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050fb:	0f b6 00             	movzbl (%eax),%eax
c01050fe:	0f b6 c0             	movzbl %al,%eax
c0105101:	29 c2                	sub    %eax,%edx
c0105103:	89 d0                	mov    %edx,%eax
c0105105:	eb 05                	jmp    c010510c <strncmp+0x54>
c0105107:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010510c:	5d                   	pop    %ebp
c010510d:	c3                   	ret    

c010510e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010510e:	55                   	push   %ebp
c010510f:	89 e5                	mov    %esp,%ebp
c0105111:	83 ec 04             	sub    $0x4,%esp
c0105114:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105117:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010511a:	eb 14                	jmp    c0105130 <strchr+0x22>
        if (*s == c) {
c010511c:	8b 45 08             	mov    0x8(%ebp),%eax
c010511f:	0f b6 00             	movzbl (%eax),%eax
c0105122:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105125:	75 05                	jne    c010512c <strchr+0x1e>
            return (char *)s;
c0105127:	8b 45 08             	mov    0x8(%ebp),%eax
c010512a:	eb 13                	jmp    c010513f <strchr+0x31>
        }
        s ++;
c010512c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105130:	8b 45 08             	mov    0x8(%ebp),%eax
c0105133:	0f b6 00             	movzbl (%eax),%eax
c0105136:	84 c0                	test   %al,%al
c0105138:	75 e2                	jne    c010511c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010513a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010513f:	c9                   	leave  
c0105140:	c3                   	ret    

c0105141 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105141:	55                   	push   %ebp
c0105142:	89 e5                	mov    %esp,%ebp
c0105144:	83 ec 04             	sub    $0x4,%esp
c0105147:	8b 45 0c             	mov    0xc(%ebp),%eax
c010514a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010514d:	eb 0f                	jmp    c010515e <strfind+0x1d>
        if (*s == c) {
c010514f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105152:	0f b6 00             	movzbl (%eax),%eax
c0105155:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105158:	74 10                	je     c010516a <strfind+0x29>
            break;
        }
        s ++;
c010515a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010515e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105161:	0f b6 00             	movzbl (%eax),%eax
c0105164:	84 c0                	test   %al,%al
c0105166:	75 e7                	jne    c010514f <strfind+0xe>
c0105168:	eb 01                	jmp    c010516b <strfind+0x2a>
        if (*s == c) {
            break;
c010516a:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c010516b:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010516e:	c9                   	leave  
c010516f:	c3                   	ret    

c0105170 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105170:	55                   	push   %ebp
c0105171:	89 e5                	mov    %esp,%ebp
c0105173:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010517d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105184:	eb 04                	jmp    c010518a <strtol+0x1a>
        s ++;
c0105186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010518a:	8b 45 08             	mov    0x8(%ebp),%eax
c010518d:	0f b6 00             	movzbl (%eax),%eax
c0105190:	3c 20                	cmp    $0x20,%al
c0105192:	74 f2                	je     c0105186 <strtol+0x16>
c0105194:	8b 45 08             	mov    0x8(%ebp),%eax
c0105197:	0f b6 00             	movzbl (%eax),%eax
c010519a:	3c 09                	cmp    $0x9,%al
c010519c:	74 e8                	je     c0105186 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010519e:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a1:	0f b6 00             	movzbl (%eax),%eax
c01051a4:	3c 2b                	cmp    $0x2b,%al
c01051a6:	75 06                	jne    c01051ae <strtol+0x3e>
        s ++;
c01051a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051ac:	eb 15                	jmp    c01051c3 <strtol+0x53>
    }
    else if (*s == '-') {
c01051ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b1:	0f b6 00             	movzbl (%eax),%eax
c01051b4:	3c 2d                	cmp    $0x2d,%al
c01051b6:	75 0b                	jne    c01051c3 <strtol+0x53>
        s ++, neg = 1;
c01051b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01051bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01051c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051c7:	74 06                	je     c01051cf <strtol+0x5f>
c01051c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01051cd:	75 24                	jne    c01051f3 <strtol+0x83>
c01051cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d2:	0f b6 00             	movzbl (%eax),%eax
c01051d5:	3c 30                	cmp    $0x30,%al
c01051d7:	75 1a                	jne    c01051f3 <strtol+0x83>
c01051d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051dc:	83 c0 01             	add    $0x1,%eax
c01051df:	0f b6 00             	movzbl (%eax),%eax
c01051e2:	3c 78                	cmp    $0x78,%al
c01051e4:	75 0d                	jne    c01051f3 <strtol+0x83>
        s += 2, base = 16;
c01051e6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01051ea:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01051f1:	eb 2a                	jmp    c010521d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01051f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051f7:	75 17                	jne    c0105210 <strtol+0xa0>
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	0f b6 00             	movzbl (%eax),%eax
c01051ff:	3c 30                	cmp    $0x30,%al
c0105201:	75 0d                	jne    c0105210 <strtol+0xa0>
        s ++, base = 8;
c0105203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105207:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010520e:	eb 0d                	jmp    c010521d <strtol+0xad>
    }
    else if (base == 0) {
c0105210:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105214:	75 07                	jne    c010521d <strtol+0xad>
        base = 10;
c0105216:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010521d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105220:	0f b6 00             	movzbl (%eax),%eax
c0105223:	3c 2f                	cmp    $0x2f,%al
c0105225:	7e 1b                	jle    c0105242 <strtol+0xd2>
c0105227:	8b 45 08             	mov    0x8(%ebp),%eax
c010522a:	0f b6 00             	movzbl (%eax),%eax
c010522d:	3c 39                	cmp    $0x39,%al
c010522f:	7f 11                	jg     c0105242 <strtol+0xd2>
            dig = *s - '0';
c0105231:	8b 45 08             	mov    0x8(%ebp),%eax
c0105234:	0f b6 00             	movzbl (%eax),%eax
c0105237:	0f be c0             	movsbl %al,%eax
c010523a:	83 e8 30             	sub    $0x30,%eax
c010523d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105240:	eb 48                	jmp    c010528a <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105242:	8b 45 08             	mov    0x8(%ebp),%eax
c0105245:	0f b6 00             	movzbl (%eax),%eax
c0105248:	3c 60                	cmp    $0x60,%al
c010524a:	7e 1b                	jle    c0105267 <strtol+0xf7>
c010524c:	8b 45 08             	mov    0x8(%ebp),%eax
c010524f:	0f b6 00             	movzbl (%eax),%eax
c0105252:	3c 7a                	cmp    $0x7a,%al
c0105254:	7f 11                	jg     c0105267 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105256:	8b 45 08             	mov    0x8(%ebp),%eax
c0105259:	0f b6 00             	movzbl (%eax),%eax
c010525c:	0f be c0             	movsbl %al,%eax
c010525f:	83 e8 57             	sub    $0x57,%eax
c0105262:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105265:	eb 23                	jmp    c010528a <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105267:	8b 45 08             	mov    0x8(%ebp),%eax
c010526a:	0f b6 00             	movzbl (%eax),%eax
c010526d:	3c 40                	cmp    $0x40,%al
c010526f:	7e 3c                	jle    c01052ad <strtol+0x13d>
c0105271:	8b 45 08             	mov    0x8(%ebp),%eax
c0105274:	0f b6 00             	movzbl (%eax),%eax
c0105277:	3c 5a                	cmp    $0x5a,%al
c0105279:	7f 32                	jg     c01052ad <strtol+0x13d>
            dig = *s - 'A' + 10;
c010527b:	8b 45 08             	mov    0x8(%ebp),%eax
c010527e:	0f b6 00             	movzbl (%eax),%eax
c0105281:	0f be c0             	movsbl %al,%eax
c0105284:	83 e8 37             	sub    $0x37,%eax
c0105287:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010528d:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105290:	7d 1a                	jge    c01052ac <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c0105292:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105296:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105299:	0f af 45 10          	imul   0x10(%ebp),%eax
c010529d:	89 c2                	mov    %eax,%edx
c010529f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052a2:	01 d0                	add    %edx,%eax
c01052a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01052a7:	e9 71 ff ff ff       	jmp    c010521d <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01052ac:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01052ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01052b1:	74 08                	je     c01052bb <strtol+0x14b>
        *endptr = (char *) s;
c01052b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052b6:	8b 55 08             	mov    0x8(%ebp),%edx
c01052b9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01052bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01052bf:	74 07                	je     c01052c8 <strtol+0x158>
c01052c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052c4:	f7 d8                	neg    %eax
c01052c6:	eb 03                	jmp    c01052cb <strtol+0x15b>
c01052c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01052cb:	c9                   	leave  
c01052cc:	c3                   	ret    

c01052cd <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01052cd:	55                   	push   %ebp
c01052ce:	89 e5                	mov    %esp,%ebp
c01052d0:	57                   	push   %edi
c01052d1:	83 ec 24             	sub    $0x24,%esp
c01052d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052d7:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01052da:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01052de:	8b 55 08             	mov    0x8(%ebp),%edx
c01052e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01052e4:	88 45 f7             	mov    %al,-0x9(%ebp)
c01052e7:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01052ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01052f0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01052f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01052f7:	89 d7                	mov    %edx,%edi
c01052f9:	f3 aa                	rep stos %al,%es:(%edi)
c01052fb:	89 fa                	mov    %edi,%edx
c01052fd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105300:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105303:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105306:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105307:	83 c4 24             	add    $0x24,%esp
c010530a:	5f                   	pop    %edi
c010530b:	5d                   	pop    %ebp
c010530c:	c3                   	ret    

c010530d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010530d:	55                   	push   %ebp
c010530e:	89 e5                	mov    %esp,%ebp
c0105310:	57                   	push   %edi
c0105311:	56                   	push   %esi
c0105312:	53                   	push   %ebx
c0105313:	83 ec 30             	sub    $0x30,%esp
c0105316:	8b 45 08             	mov    0x8(%ebp),%eax
c0105319:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010531c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010531f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105322:	8b 45 10             	mov    0x10(%ebp),%eax
c0105325:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105328:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010532b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010532e:	73 42                	jae    c0105372 <memmove+0x65>
c0105330:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105336:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105339:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010533c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010533f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105342:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105345:	c1 e8 02             	shr    $0x2,%eax
c0105348:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010534a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010534d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105350:	89 d7                	mov    %edx,%edi
c0105352:	89 c6                	mov    %eax,%esi
c0105354:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105356:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105359:	83 e1 03             	and    $0x3,%ecx
c010535c:	74 02                	je     c0105360 <memmove+0x53>
c010535e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105360:	89 f0                	mov    %esi,%eax
c0105362:	89 fa                	mov    %edi,%edx
c0105364:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105367:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010536a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010536d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c0105370:	eb 36                	jmp    c01053a8 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105372:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105375:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105378:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010537b:	01 c2                	add    %eax,%edx
c010537d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105380:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105383:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105386:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105389:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010538c:	89 c1                	mov    %eax,%ecx
c010538e:	89 d8                	mov    %ebx,%eax
c0105390:	89 d6                	mov    %edx,%esi
c0105392:	89 c7                	mov    %eax,%edi
c0105394:	fd                   	std    
c0105395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105397:	fc                   	cld    
c0105398:	89 f8                	mov    %edi,%eax
c010539a:	89 f2                	mov    %esi,%edx
c010539c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010539f:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01053a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01053a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01053a8:	83 c4 30             	add    $0x30,%esp
c01053ab:	5b                   	pop    %ebx
c01053ac:	5e                   	pop    %esi
c01053ad:	5f                   	pop    %edi
c01053ae:	5d                   	pop    %ebp
c01053af:	c3                   	ret    

c01053b0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01053b0:	55                   	push   %ebp
c01053b1:	89 e5                	mov    %esp,%ebp
c01053b3:	57                   	push   %edi
c01053b4:	56                   	push   %esi
c01053b5:	83 ec 20             	sub    $0x20,%esp
c01053b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01053ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053cd:	c1 e8 02             	shr    $0x2,%eax
c01053d0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01053d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d8:	89 d7                	mov    %edx,%edi
c01053da:	89 c6                	mov    %eax,%esi
c01053dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01053de:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01053e1:	83 e1 03             	and    $0x3,%ecx
c01053e4:	74 02                	je     c01053e8 <memcpy+0x38>
c01053e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01053e8:	89 f0                	mov    %esi,%eax
c01053ea:	89 fa                	mov    %edi,%edx
c01053ec:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01053ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01053f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01053f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c01053f8:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01053f9:	83 c4 20             	add    $0x20,%esp
c01053fc:	5e                   	pop    %esi
c01053fd:	5f                   	pop    %edi
c01053fe:	5d                   	pop    %ebp
c01053ff:	c3                   	ret    

c0105400 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105400:	55                   	push   %ebp
c0105401:	89 e5                	mov    %esp,%ebp
c0105403:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105406:	8b 45 08             	mov    0x8(%ebp),%eax
c0105409:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010540c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105412:	eb 30                	jmp    c0105444 <memcmp+0x44>
        if (*s1 != *s2) {
c0105414:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105417:	0f b6 10             	movzbl (%eax),%edx
c010541a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010541d:	0f b6 00             	movzbl (%eax),%eax
c0105420:	38 c2                	cmp    %al,%dl
c0105422:	74 18                	je     c010543c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105424:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105427:	0f b6 00             	movzbl (%eax),%eax
c010542a:	0f b6 d0             	movzbl %al,%edx
c010542d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105430:	0f b6 00             	movzbl (%eax),%eax
c0105433:	0f b6 c0             	movzbl %al,%eax
c0105436:	29 c2                	sub    %eax,%edx
c0105438:	89 d0                	mov    %edx,%eax
c010543a:	eb 1a                	jmp    c0105456 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010543c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105440:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105444:	8b 45 10             	mov    0x10(%ebp),%eax
c0105447:	8d 50 ff             	lea    -0x1(%eax),%edx
c010544a:	89 55 10             	mov    %edx,0x10(%ebp)
c010544d:	85 c0                	test   %eax,%eax
c010544f:	75 c3                	jne    c0105414 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105451:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105456:	c9                   	leave  
c0105457:	c3                   	ret    

c0105458 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105458:	55                   	push   %ebp
c0105459:	89 e5                	mov    %esp,%ebp
c010545b:	83 ec 38             	sub    $0x38,%esp
c010545e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105461:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105464:	8b 45 14             	mov    0x14(%ebp),%eax
c0105467:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010546a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010546d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105470:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105473:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105476:	8b 45 18             	mov    0x18(%ebp),%eax
c0105479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010547c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010547f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105482:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105485:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105488:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010548b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010548e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105492:	74 1c                	je     c01054b0 <printnum+0x58>
c0105494:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105497:	ba 00 00 00 00       	mov    $0x0,%edx
c010549c:	f7 75 e4             	divl   -0x1c(%ebp)
c010549f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a5:	ba 00 00 00 00       	mov    $0x0,%edx
c01054aa:	f7 75 e4             	divl   -0x1c(%ebp)
c01054ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054b6:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054ce:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054d1:	8b 45 18             	mov    0x18(%ebp),%eax
c01054d4:	ba 00 00 00 00       	mov    $0x0,%edx
c01054d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054dc:	77 41                	ja     c010551f <printnum+0xc7>
c01054de:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054e1:	72 05                	jb     c01054e8 <printnum+0x90>
c01054e3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054e6:	77 37                	ja     c010551f <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054eb:	83 e8 01             	sub    $0x1,%eax
c01054ee:	83 ec 04             	sub    $0x4,%esp
c01054f1:	ff 75 20             	pushl  0x20(%ebp)
c01054f4:	50                   	push   %eax
c01054f5:	ff 75 18             	pushl  0x18(%ebp)
c01054f8:	ff 75 ec             	pushl  -0x14(%ebp)
c01054fb:	ff 75 e8             	pushl  -0x18(%ebp)
c01054fe:	ff 75 0c             	pushl  0xc(%ebp)
c0105501:	ff 75 08             	pushl  0x8(%ebp)
c0105504:	e8 4f ff ff ff       	call   c0105458 <printnum>
c0105509:	83 c4 20             	add    $0x20,%esp
c010550c:	eb 1b                	jmp    c0105529 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010550e:	83 ec 08             	sub    $0x8,%esp
c0105511:	ff 75 0c             	pushl  0xc(%ebp)
c0105514:	ff 75 20             	pushl  0x20(%ebp)
c0105517:	8b 45 08             	mov    0x8(%ebp),%eax
c010551a:	ff d0                	call   *%eax
c010551c:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010551f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105523:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105527:	7f e5                	jg     c010550e <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105529:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010552c:	05 f4 6b 10 c0       	add    $0xc0106bf4,%eax
c0105531:	0f b6 00             	movzbl (%eax),%eax
c0105534:	0f be c0             	movsbl %al,%eax
c0105537:	83 ec 08             	sub    $0x8,%esp
c010553a:	ff 75 0c             	pushl  0xc(%ebp)
c010553d:	50                   	push   %eax
c010553e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105541:	ff d0                	call   *%eax
c0105543:	83 c4 10             	add    $0x10,%esp
}
c0105546:	90                   	nop
c0105547:	c9                   	leave  
c0105548:	c3                   	ret    

c0105549 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105549:	55                   	push   %ebp
c010554a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010554c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105550:	7e 14                	jle    c0105566 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105552:	8b 45 08             	mov    0x8(%ebp),%eax
c0105555:	8b 00                	mov    (%eax),%eax
c0105557:	8d 48 08             	lea    0x8(%eax),%ecx
c010555a:	8b 55 08             	mov    0x8(%ebp),%edx
c010555d:	89 0a                	mov    %ecx,(%edx)
c010555f:	8b 50 04             	mov    0x4(%eax),%edx
c0105562:	8b 00                	mov    (%eax),%eax
c0105564:	eb 30                	jmp    c0105596 <getuint+0x4d>
    }
    else if (lflag) {
c0105566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010556a:	74 16                	je     c0105582 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010556c:	8b 45 08             	mov    0x8(%ebp),%eax
c010556f:	8b 00                	mov    (%eax),%eax
c0105571:	8d 48 04             	lea    0x4(%eax),%ecx
c0105574:	8b 55 08             	mov    0x8(%ebp),%edx
c0105577:	89 0a                	mov    %ecx,(%edx)
c0105579:	8b 00                	mov    (%eax),%eax
c010557b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105580:	eb 14                	jmp    c0105596 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105582:	8b 45 08             	mov    0x8(%ebp),%eax
c0105585:	8b 00                	mov    (%eax),%eax
c0105587:	8d 48 04             	lea    0x4(%eax),%ecx
c010558a:	8b 55 08             	mov    0x8(%ebp),%edx
c010558d:	89 0a                	mov    %ecx,(%edx)
c010558f:	8b 00                	mov    (%eax),%eax
c0105591:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105596:	5d                   	pop    %ebp
c0105597:	c3                   	ret    

c0105598 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105598:	55                   	push   %ebp
c0105599:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010559b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010559f:	7e 14                	jle    c01055b5 <getint+0x1d>
        return va_arg(*ap, long long);
c01055a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a4:	8b 00                	mov    (%eax),%eax
c01055a6:	8d 48 08             	lea    0x8(%eax),%ecx
c01055a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ac:	89 0a                	mov    %ecx,(%edx)
c01055ae:	8b 50 04             	mov    0x4(%eax),%edx
c01055b1:	8b 00                	mov    (%eax),%eax
c01055b3:	eb 28                	jmp    c01055dd <getint+0x45>
    }
    else if (lflag) {
c01055b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055b9:	74 12                	je     c01055cd <getint+0x35>
        return va_arg(*ap, long);
c01055bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01055be:	8b 00                	mov    (%eax),%eax
c01055c0:	8d 48 04             	lea    0x4(%eax),%ecx
c01055c3:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c6:	89 0a                	mov    %ecx,(%edx)
c01055c8:	8b 00                	mov    (%eax),%eax
c01055ca:	99                   	cltd   
c01055cb:	eb 10                	jmp    c01055dd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d0:	8b 00                	mov    (%eax),%eax
c01055d2:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d5:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d8:	89 0a                	mov    %ecx,(%edx)
c01055da:	8b 00                	mov    (%eax),%eax
c01055dc:	99                   	cltd   
    }
}
c01055dd:	5d                   	pop    %ebp
c01055de:	c3                   	ret    

c01055df <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055df:	55                   	push   %ebp
c01055e0:	89 e5                	mov    %esp,%ebp
c01055e2:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c01055e5:	8d 45 14             	lea    0x14(%ebp),%eax
c01055e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055ee:	50                   	push   %eax
c01055ef:	ff 75 10             	pushl  0x10(%ebp)
c01055f2:	ff 75 0c             	pushl  0xc(%ebp)
c01055f5:	ff 75 08             	pushl  0x8(%ebp)
c01055f8:	e8 06 00 00 00       	call   c0105603 <vprintfmt>
c01055fd:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105600:	90                   	nop
c0105601:	c9                   	leave  
c0105602:	c3                   	ret    

c0105603 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105603:	55                   	push   %ebp
c0105604:	89 e5                	mov    %esp,%ebp
c0105606:	56                   	push   %esi
c0105607:	53                   	push   %ebx
c0105608:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010560b:	eb 17                	jmp    c0105624 <vprintfmt+0x21>
            if (ch == '\0') {
c010560d:	85 db                	test   %ebx,%ebx
c010560f:	0f 84 8e 03 00 00    	je     c01059a3 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c0105615:	83 ec 08             	sub    $0x8,%esp
c0105618:	ff 75 0c             	pushl  0xc(%ebp)
c010561b:	53                   	push   %ebx
c010561c:	8b 45 08             	mov    0x8(%ebp),%eax
c010561f:	ff d0                	call   *%eax
c0105621:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105624:	8b 45 10             	mov    0x10(%ebp),%eax
c0105627:	8d 50 01             	lea    0x1(%eax),%edx
c010562a:	89 55 10             	mov    %edx,0x10(%ebp)
c010562d:	0f b6 00             	movzbl (%eax),%eax
c0105630:	0f b6 d8             	movzbl %al,%ebx
c0105633:	83 fb 25             	cmp    $0x25,%ebx
c0105636:	75 d5                	jne    c010560d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105638:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010563c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105646:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105649:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105650:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105653:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105656:	8b 45 10             	mov    0x10(%ebp),%eax
c0105659:	8d 50 01             	lea    0x1(%eax),%edx
c010565c:	89 55 10             	mov    %edx,0x10(%ebp)
c010565f:	0f b6 00             	movzbl (%eax),%eax
c0105662:	0f b6 d8             	movzbl %al,%ebx
c0105665:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105668:	83 f8 55             	cmp    $0x55,%eax
c010566b:	0f 87 05 03 00 00    	ja     c0105976 <vprintfmt+0x373>
c0105671:	8b 04 85 18 6c 10 c0 	mov    -0x3fef93e8(,%eax,4),%eax
c0105678:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010567a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010567e:	eb d6                	jmp    c0105656 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105680:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105684:	eb d0                	jmp    c0105656 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010568d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105690:	89 d0                	mov    %edx,%eax
c0105692:	c1 e0 02             	shl    $0x2,%eax
c0105695:	01 d0                	add    %edx,%eax
c0105697:	01 c0                	add    %eax,%eax
c0105699:	01 d8                	add    %ebx,%eax
c010569b:	83 e8 30             	sub    $0x30,%eax
c010569e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01056a4:	0f b6 00             	movzbl (%eax),%eax
c01056a7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056aa:	83 fb 2f             	cmp    $0x2f,%ebx
c01056ad:	7e 39                	jle    c01056e8 <vprintfmt+0xe5>
c01056af:	83 fb 39             	cmp    $0x39,%ebx
c01056b2:	7f 34                	jg     c01056e8 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056b4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056b8:	eb d3                	jmp    c010568d <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01056ba:	8b 45 14             	mov    0x14(%ebp),%eax
c01056bd:	8d 50 04             	lea    0x4(%eax),%edx
c01056c0:	89 55 14             	mov    %edx,0x14(%ebp)
c01056c3:	8b 00                	mov    (%eax),%eax
c01056c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056c8:	eb 1f                	jmp    c01056e9 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c01056ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056ce:	79 86                	jns    c0105656 <vprintfmt+0x53>
                width = 0;
c01056d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056d7:	e9 7a ff ff ff       	jmp    c0105656 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c01056dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056e3:	e9 6e ff ff ff       	jmp    c0105656 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01056e8:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01056e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056ed:	0f 89 63 ff ff ff    	jns    c0105656 <vprintfmt+0x53>
                width = precision, precision = -1;
c01056f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105700:	e9 51 ff ff ff       	jmp    c0105656 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105705:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105709:	e9 48 ff ff ff       	jmp    c0105656 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010570e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105711:	8d 50 04             	lea    0x4(%eax),%edx
c0105714:	89 55 14             	mov    %edx,0x14(%ebp)
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	83 ec 08             	sub    $0x8,%esp
c010571c:	ff 75 0c             	pushl  0xc(%ebp)
c010571f:	50                   	push   %eax
c0105720:	8b 45 08             	mov    0x8(%ebp),%eax
c0105723:	ff d0                	call   *%eax
c0105725:	83 c4 10             	add    $0x10,%esp
            break;
c0105728:	e9 71 02 00 00       	jmp    c010599e <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010572d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105730:	8d 50 04             	lea    0x4(%eax),%edx
c0105733:	89 55 14             	mov    %edx,0x14(%ebp)
c0105736:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105738:	85 db                	test   %ebx,%ebx
c010573a:	79 02                	jns    c010573e <vprintfmt+0x13b>
                err = -err;
c010573c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010573e:	83 fb 06             	cmp    $0x6,%ebx
c0105741:	7f 0b                	jg     c010574e <vprintfmt+0x14b>
c0105743:	8b 34 9d d8 6b 10 c0 	mov    -0x3fef9428(,%ebx,4),%esi
c010574a:	85 f6                	test   %esi,%esi
c010574c:	75 19                	jne    c0105767 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c010574e:	53                   	push   %ebx
c010574f:	68 05 6c 10 c0       	push   $0xc0106c05
c0105754:	ff 75 0c             	pushl  0xc(%ebp)
c0105757:	ff 75 08             	pushl  0x8(%ebp)
c010575a:	e8 80 fe ff ff       	call   c01055df <printfmt>
c010575f:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105762:	e9 37 02 00 00       	jmp    c010599e <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105767:	56                   	push   %esi
c0105768:	68 0e 6c 10 c0       	push   $0xc0106c0e
c010576d:	ff 75 0c             	pushl  0xc(%ebp)
c0105770:	ff 75 08             	pushl  0x8(%ebp)
c0105773:	e8 67 fe ff ff       	call   c01055df <printfmt>
c0105778:	83 c4 10             	add    $0x10,%esp
            }
            break;
c010577b:	e9 1e 02 00 00       	jmp    c010599e <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105780:	8b 45 14             	mov    0x14(%ebp),%eax
c0105783:	8d 50 04             	lea    0x4(%eax),%edx
c0105786:	89 55 14             	mov    %edx,0x14(%ebp)
c0105789:	8b 30                	mov    (%eax),%esi
c010578b:	85 f6                	test   %esi,%esi
c010578d:	75 05                	jne    c0105794 <vprintfmt+0x191>
                p = "(null)";
c010578f:	be 11 6c 10 c0       	mov    $0xc0106c11,%esi
            }
            if (width > 0 && padc != '-') {
c0105794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105798:	7e 76                	jle    c0105810 <vprintfmt+0x20d>
c010579a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010579e:	74 70                	je     c0105810 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a3:	83 ec 08             	sub    $0x8,%esp
c01057a6:	50                   	push   %eax
c01057a7:	56                   	push   %esi
c01057a8:	e8 17 f8 ff ff       	call   c0104fc4 <strnlen>
c01057ad:	83 c4 10             	add    $0x10,%esp
c01057b0:	89 c2                	mov    %eax,%edx
c01057b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057b5:	29 d0                	sub    %edx,%eax
c01057b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ba:	eb 17                	jmp    c01057d3 <vprintfmt+0x1d0>
                    putch(padc, putdat);
c01057bc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057c0:	83 ec 08             	sub    $0x8,%esp
c01057c3:	ff 75 0c             	pushl  0xc(%ebp)
c01057c6:	50                   	push   %eax
c01057c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ca:	ff d0                	call   *%eax
c01057cc:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057cf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057d7:	7f e3                	jg     c01057bc <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057d9:	eb 35                	jmp    c0105810 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057df:	74 1c                	je     c01057fd <vprintfmt+0x1fa>
c01057e1:	83 fb 1f             	cmp    $0x1f,%ebx
c01057e4:	7e 05                	jle    c01057eb <vprintfmt+0x1e8>
c01057e6:	83 fb 7e             	cmp    $0x7e,%ebx
c01057e9:	7e 12                	jle    c01057fd <vprintfmt+0x1fa>
                    putch('?', putdat);
c01057eb:	83 ec 08             	sub    $0x8,%esp
c01057ee:	ff 75 0c             	pushl  0xc(%ebp)
c01057f1:	6a 3f                	push   $0x3f
c01057f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f6:	ff d0                	call   *%eax
c01057f8:	83 c4 10             	add    $0x10,%esp
c01057fb:	eb 0f                	jmp    c010580c <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c01057fd:	83 ec 08             	sub    $0x8,%esp
c0105800:	ff 75 0c             	pushl  0xc(%ebp)
c0105803:	53                   	push   %ebx
c0105804:	8b 45 08             	mov    0x8(%ebp),%eax
c0105807:	ff d0                	call   *%eax
c0105809:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010580c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105810:	89 f0                	mov    %esi,%eax
c0105812:	8d 70 01             	lea    0x1(%eax),%esi
c0105815:	0f b6 00             	movzbl (%eax),%eax
c0105818:	0f be d8             	movsbl %al,%ebx
c010581b:	85 db                	test   %ebx,%ebx
c010581d:	74 26                	je     c0105845 <vprintfmt+0x242>
c010581f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105823:	78 b6                	js     c01057db <vprintfmt+0x1d8>
c0105825:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105829:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010582d:	79 ac                	jns    c01057db <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010582f:	eb 14                	jmp    c0105845 <vprintfmt+0x242>
                putch(' ', putdat);
c0105831:	83 ec 08             	sub    $0x8,%esp
c0105834:	ff 75 0c             	pushl  0xc(%ebp)
c0105837:	6a 20                	push   $0x20
c0105839:	8b 45 08             	mov    0x8(%ebp),%eax
c010583c:	ff d0                	call   *%eax
c010583e:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105841:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105845:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105849:	7f e6                	jg     c0105831 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
c010584b:	e9 4e 01 00 00       	jmp    c010599e <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105850:	83 ec 08             	sub    $0x8,%esp
c0105853:	ff 75 e0             	pushl  -0x20(%ebp)
c0105856:	8d 45 14             	lea    0x14(%ebp),%eax
c0105859:	50                   	push   %eax
c010585a:	e8 39 fd ff ff       	call   c0105598 <getint>
c010585f:	83 c4 10             	add    $0x10,%esp
c0105862:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105865:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105868:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010586b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010586e:	85 d2                	test   %edx,%edx
c0105870:	79 23                	jns    c0105895 <vprintfmt+0x292>
                putch('-', putdat);
c0105872:	83 ec 08             	sub    $0x8,%esp
c0105875:	ff 75 0c             	pushl  0xc(%ebp)
c0105878:	6a 2d                	push   $0x2d
c010587a:	8b 45 08             	mov    0x8(%ebp),%eax
c010587d:	ff d0                	call   *%eax
c010587f:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c0105882:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105885:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105888:	f7 d8                	neg    %eax
c010588a:	83 d2 00             	adc    $0x0,%edx
c010588d:	f7 da                	neg    %edx
c010588f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105892:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105895:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010589c:	e9 9f 00 00 00       	jmp    c0105940 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058a1:	83 ec 08             	sub    $0x8,%esp
c01058a4:	ff 75 e0             	pushl  -0x20(%ebp)
c01058a7:	8d 45 14             	lea    0x14(%ebp),%eax
c01058aa:	50                   	push   %eax
c01058ab:	e8 99 fc ff ff       	call   c0105549 <getuint>
c01058b0:	83 c4 10             	add    $0x10,%esp
c01058b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058c0:	eb 7e                	jmp    c0105940 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058c2:	83 ec 08             	sub    $0x8,%esp
c01058c5:	ff 75 e0             	pushl  -0x20(%ebp)
c01058c8:	8d 45 14             	lea    0x14(%ebp),%eax
c01058cb:	50                   	push   %eax
c01058cc:	e8 78 fc ff ff       	call   c0105549 <getuint>
c01058d1:	83 c4 10             	add    $0x10,%esp
c01058d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058da:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058e1:	eb 5d                	jmp    c0105940 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c01058e3:	83 ec 08             	sub    $0x8,%esp
c01058e6:	ff 75 0c             	pushl  0xc(%ebp)
c01058e9:	6a 30                	push   $0x30
c01058eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ee:	ff d0                	call   *%eax
c01058f0:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c01058f3:	83 ec 08             	sub    $0x8,%esp
c01058f6:	ff 75 0c             	pushl  0xc(%ebp)
c01058f9:	6a 78                	push   $0x78
c01058fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fe:	ff d0                	call   *%eax
c0105900:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105903:	8b 45 14             	mov    0x14(%ebp),%eax
c0105906:	8d 50 04             	lea    0x4(%eax),%edx
c0105909:	89 55 14             	mov    %edx,0x14(%ebp)
c010590c:	8b 00                	mov    (%eax),%eax
c010590e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105918:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010591f:	eb 1f                	jmp    c0105940 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105921:	83 ec 08             	sub    $0x8,%esp
c0105924:	ff 75 e0             	pushl  -0x20(%ebp)
c0105927:	8d 45 14             	lea    0x14(%ebp),%eax
c010592a:	50                   	push   %eax
c010592b:	e8 19 fc ff ff       	call   c0105549 <getuint>
c0105930:	83 c4 10             	add    $0x10,%esp
c0105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105936:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105939:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105940:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105947:	83 ec 04             	sub    $0x4,%esp
c010594a:	52                   	push   %edx
c010594b:	ff 75 e8             	pushl  -0x18(%ebp)
c010594e:	50                   	push   %eax
c010594f:	ff 75 f4             	pushl  -0xc(%ebp)
c0105952:	ff 75 f0             	pushl  -0x10(%ebp)
c0105955:	ff 75 0c             	pushl  0xc(%ebp)
c0105958:	ff 75 08             	pushl  0x8(%ebp)
c010595b:	e8 f8 fa ff ff       	call   c0105458 <printnum>
c0105960:	83 c4 20             	add    $0x20,%esp
            break;
c0105963:	eb 39                	jmp    c010599e <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105965:	83 ec 08             	sub    $0x8,%esp
c0105968:	ff 75 0c             	pushl  0xc(%ebp)
c010596b:	53                   	push   %ebx
c010596c:	8b 45 08             	mov    0x8(%ebp),%eax
c010596f:	ff d0                	call   *%eax
c0105971:	83 c4 10             	add    $0x10,%esp
            break;
c0105974:	eb 28                	jmp    c010599e <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105976:	83 ec 08             	sub    $0x8,%esp
c0105979:	ff 75 0c             	pushl  0xc(%ebp)
c010597c:	6a 25                	push   $0x25
c010597e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105981:	ff d0                	call   *%eax
c0105983:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105986:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010598a:	eb 04                	jmp    c0105990 <vprintfmt+0x38d>
c010598c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105990:	8b 45 10             	mov    0x10(%ebp),%eax
c0105993:	83 e8 01             	sub    $0x1,%eax
c0105996:	0f b6 00             	movzbl (%eax),%eax
c0105999:	3c 25                	cmp    $0x25,%al
c010599b:	75 ef                	jne    c010598c <vprintfmt+0x389>
                /* do nothing */;
            break;
c010599d:	90                   	nop
        }
    }
c010599e:	e9 68 fc ff ff       	jmp    c010560b <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c01059a3:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
c01059a7:	5b                   	pop    %ebx
c01059a8:	5e                   	pop    %esi
c01059a9:	5d                   	pop    %ebp
c01059aa:	c3                   	ret    

c01059ab <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059ab:	55                   	push   %ebp
c01059ac:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b1:	8b 40 08             	mov    0x8(%eax),%eax
c01059b4:	8d 50 01             	lea    0x1(%eax),%edx
c01059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ba:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c0:	8b 10                	mov    (%eax),%edx
c01059c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c5:	8b 40 04             	mov    0x4(%eax),%eax
c01059c8:	39 c2                	cmp    %eax,%edx
c01059ca:	73 12                	jae    c01059de <sprintputch+0x33>
        *b->buf ++ = ch;
c01059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cf:	8b 00                	mov    (%eax),%eax
c01059d1:	8d 48 01             	lea    0x1(%eax),%ecx
c01059d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059d7:	89 0a                	mov    %ecx,(%edx)
c01059d9:	8b 55 08             	mov    0x8(%ebp),%edx
c01059dc:	88 10                	mov    %dl,(%eax)
    }
}
c01059de:	90                   	nop
c01059df:	5d                   	pop    %ebp
c01059e0:	c3                   	ret    

c01059e1 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01059e1:	55                   	push   %ebp
c01059e2:	89 e5                	mov    %esp,%ebp
c01059e4:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01059e7:	8d 45 14             	lea    0x14(%ebp),%eax
c01059ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01059ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059f0:	50                   	push   %eax
c01059f1:	ff 75 10             	pushl  0x10(%ebp)
c01059f4:	ff 75 0c             	pushl  0xc(%ebp)
c01059f7:	ff 75 08             	pushl  0x8(%ebp)
c01059fa:	e8 0b 00 00 00       	call   c0105a0a <vsnprintf>
c01059ff:	83 c4 10             	add    $0x10,%esp
c0105a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a08:	c9                   	leave  
c0105a09:	c3                   	ret    

c0105a0a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a0a:	55                   	push   %ebp
c0105a0b:	89 e5                	mov    %esp,%ebp
c0105a0d:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a19:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a1f:	01 d0                	add    %edx,%eax
c0105a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a2f:	74 0a                	je     c0105a3b <vsnprintf+0x31>
c0105a31:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a37:	39 c2                	cmp    %eax,%edx
c0105a39:	76 07                	jbe    c0105a42 <vsnprintf+0x38>
        return -E_INVAL;
c0105a3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a40:	eb 20                	jmp    c0105a62 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a42:	ff 75 14             	pushl  0x14(%ebp)
c0105a45:	ff 75 10             	pushl  0x10(%ebp)
c0105a48:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a4b:	50                   	push   %eax
c0105a4c:	68 ab 59 10 c0       	push   $0xc01059ab
c0105a51:	e8 ad fb ff ff       	call   c0105603 <vprintfmt>
c0105a56:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c0105a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a5c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a62:	c9                   	leave  
c0105a63:	c3                   	ret    
