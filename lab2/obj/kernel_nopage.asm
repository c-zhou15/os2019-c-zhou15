
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	83 ec 04             	sub    $0x4,%esp
  100041:	50                   	push   %eax
  100042:	6a 00                	push   $0x0
  100044:	68 36 7a 11 00       	push   $0x117a36
  100049:	e8 7f 52 00 00       	call   1052cd <memset>
  10004e:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100051:	e8 5b 15 00 00       	call   1015b1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100056:	c7 45 f4 80 5a 10 00 	movl   $0x105a80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10005d:	83 ec 08             	sub    $0x8,%esp
  100060:	ff 75 f4             	pushl  -0xc(%ebp)
  100063:	68 9c 5a 10 00       	push   $0x105a9c
  100068:	e8 fa 01 00 00       	call   100267 <cprintf>
  10006d:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100070:	e8 7c 08 00 00       	call   1008f1 <print_kerninfo>

    grade_backtrace();
  100075:	e8 74 00 00 00       	call   1000ee <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007a:	e8 fd 30 00 00       	call   10317c <pmm_init>

    pic_init();                 // init interrupt controller
  10007f:	e8 9f 16 00 00       	call   101723 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100084:	e8 00 18 00 00       	call   101889 <idt_init>

    clock_init();               // init clock interrupt
  100089:	e8 ca 0c 00 00       	call   100d58 <clock_init>
    intr_enable();              // enable irq interrupt
  10008e:	e8 cd 17 00 00       	call   101860 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100093:	eb fe                	jmp    100093 <kern_init+0x69>

00100095 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  10009b:	83 ec 04             	sub    $0x4,%esp
  10009e:	6a 00                	push   $0x0
  1000a0:	6a 00                	push   $0x0
  1000a2:	6a 00                	push   $0x0
  1000a4:	e8 9d 0c 00 00       	call   100d46 <mon_backtrace>
  1000a9:	83 c4 10             	add    $0x10,%esp
}
  1000ac:	90                   	nop
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	53                   	push   %ebx
  1000b3:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000b6:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000bc:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1000c2:	51                   	push   %ecx
  1000c3:	52                   	push   %edx
  1000c4:	53                   	push   %ebx
  1000c5:	50                   	push   %eax
  1000c6:	e8 ca ff ff ff       	call   100095 <grade_backtrace2>
  1000cb:	83 c4 10             	add    $0x10,%esp
}
  1000ce:	90                   	nop
  1000cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000d2:	c9                   	leave  
  1000d3:	c3                   	ret    

001000d4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	83 ec 08             	sub    $0x8,%esp
  1000dd:	ff 75 10             	pushl  0x10(%ebp)
  1000e0:	ff 75 08             	pushl  0x8(%ebp)
  1000e3:	e8 c7 ff ff ff       	call   1000af <grade_backtrace1>
  1000e8:	83 c4 10             	add    $0x10,%esp
}
  1000eb:	90                   	nop
  1000ec:	c9                   	leave  
  1000ed:	c3                   	ret    

001000ee <grade_backtrace>:

void
grade_backtrace(void) {
  1000ee:	55                   	push   %ebp
  1000ef:	89 e5                	mov    %esp,%ebp
  1000f1:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f4:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1000f9:	83 ec 04             	sub    $0x4,%esp
  1000fc:	68 00 00 ff ff       	push   $0xffff0000
  100101:	50                   	push   %eax
  100102:	6a 00                	push   $0x0
  100104:	e8 cb ff ff ff       	call   1000d4 <grade_backtrace0>
  100109:	83 c4 10             	add    $0x10,%esp
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100115:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100118:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100121:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100125:	0f b7 c0             	movzwl %ax,%eax
  100128:	83 e0 03             	and    $0x3,%eax
  10012b:	89 c2                	mov    %eax,%edx
  10012d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100132:	83 ec 04             	sub    $0x4,%esp
  100135:	52                   	push   %edx
  100136:	50                   	push   %eax
  100137:	68 a1 5a 10 00       	push   $0x105aa1
  10013c:	e8 26 01 00 00       	call   100267 <cprintf>
  100141:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  100144:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100148:	0f b7 d0             	movzwl %ax,%edx
  10014b:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100150:	83 ec 04             	sub    $0x4,%esp
  100153:	52                   	push   %edx
  100154:	50                   	push   %eax
  100155:	68 af 5a 10 00       	push   $0x105aaf
  10015a:	e8 08 01 00 00       	call   100267 <cprintf>
  10015f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100162:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100166:	0f b7 d0             	movzwl %ax,%edx
  100169:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016e:	83 ec 04             	sub    $0x4,%esp
  100171:	52                   	push   %edx
  100172:	50                   	push   %eax
  100173:	68 bd 5a 10 00       	push   $0x105abd
  100178:	e8 ea 00 00 00       	call   100267 <cprintf>
  10017d:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	0f b7 d0             	movzwl %ax,%edx
  100187:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018c:	83 ec 04             	sub    $0x4,%esp
  10018f:	52                   	push   %edx
  100190:	50                   	push   %eax
  100191:	68 cb 5a 10 00       	push   $0x105acb
  100196:	e8 cc 00 00 00       	call   100267 <cprintf>
  10019b:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  10019e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a2:	0f b7 d0             	movzwl %ax,%edx
  1001a5:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001aa:	83 ec 04             	sub    $0x4,%esp
  1001ad:	52                   	push   %edx
  1001ae:	50                   	push   %eax
  1001af:	68 d9 5a 10 00       	push   $0x105ad9
  1001b4:	e8 ae 00 00 00       	call   100267 <cprintf>
  1001b9:	83 c4 10             	add    $0x10,%esp
    round ++;
  1001bc:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001c9:	90                   	nop
  1001ca:	c9                   	leave  
  1001cb:	c3                   	ret    

001001cc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cc:	55                   	push   %ebp
  1001cd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cf:	90                   	nop
  1001d0:	5d                   	pop    %ebp
  1001d1:	c3                   	ret    

001001d2 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d2:	55                   	push   %ebp
  1001d3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d5:	90                   	nop
  1001d6:	5d                   	pop    %ebp
  1001d7:	c3                   	ret    

001001d8 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d8:	55                   	push   %ebp
  1001d9:	89 e5                	mov    %esp,%ebp
  1001db:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001de:	e8 2c ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 e8 5a 10 00       	push   $0x105ae8
  1001eb:	e8 77 00 00 00       	call   100267 <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001f3:	e8 d4 ff ff ff       	call   1001cc <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f8:	e8 12 ff ff ff       	call   10010f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001fd:	83 ec 0c             	sub    $0xc,%esp
  100200:	68 08 5b 10 00       	push   $0x105b08
  100205:	e8 5d 00 00 00       	call   100267 <cprintf>
  10020a:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  10020d:	e8 c0 ff ff ff       	call   1001d2 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 f8 fe ff ff       	call   10010f <lab1_print_cur_status>
}
  100217:	90                   	nop
  100218:	c9                   	leave  
  100219:	c3                   	ret    

0010021a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
  10021d:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100220:	83 ec 0c             	sub    $0xc,%esp
  100223:	ff 75 08             	pushl  0x8(%ebp)
  100226:	e8 b7 13 00 00       	call   1015e2 <cons_putc>
  10022b:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  10022e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100231:	8b 00                	mov    (%eax),%eax
  100233:	8d 50 01             	lea    0x1(%eax),%edx
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 10                	mov    %edx,(%eax)
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10024b:	ff 75 0c             	pushl  0xc(%ebp)
  10024e:	ff 75 08             	pushl  0x8(%ebp)
  100251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100254:	50                   	push   %eax
  100255:	68 1a 02 10 00       	push   $0x10021a
  10025a:	e8 a4 53 00 00       	call   105603 <vprintfmt>
  10025f:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100265:	c9                   	leave  
  100266:	c3                   	ret    

00100267 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100267:	55                   	push   %ebp
  100268:	89 e5                	mov    %esp,%ebp
  10026a:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10026d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100270:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100276:	83 ec 08             	sub    $0x8,%esp
  100279:	50                   	push   %eax
  10027a:	ff 75 08             	pushl  0x8(%ebp)
  10027d:	e8 bc ff ff ff       	call   10023e <vcprintf>
  100282:	83 c4 10             	add    $0x10,%esp
  100285:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028b:	c9                   	leave  
  10028c:	c3                   	ret    

0010028d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10028d:	55                   	push   %ebp
  10028e:	89 e5                	mov    %esp,%ebp
  100290:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100293:	83 ec 0c             	sub    $0xc,%esp
  100296:	ff 75 08             	pushl  0x8(%ebp)
  100299:	e8 44 13 00 00       	call   1015e2 <cons_putc>
  10029e:	83 c4 10             	add    $0x10,%esp
}
  1002a1:	90                   	nop
  1002a2:	c9                   	leave  
  1002a3:	c3                   	ret    

001002a4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a4:	55                   	push   %ebp
  1002a5:	89 e5                	mov    %esp,%ebp
  1002a7:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  1002aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b1:	eb 14                	jmp    1002c7 <cputs+0x23>
        cputch(c, &cnt);
  1002b3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b7:	83 ec 08             	sub    $0x8,%esp
  1002ba:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bd:	52                   	push   %edx
  1002be:	50                   	push   %eax
  1002bf:	e8 56 ff ff ff       	call   10021a <cputch>
  1002c4:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	8d 50 01             	lea    0x1(%eax),%edx
  1002cd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d0:	0f b6 00             	movzbl (%eax),%eax
  1002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002da:	75 d7                	jne    1002b3 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dc:	83 ec 08             	sub    $0x8,%esp
  1002df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e2:	50                   	push   %eax
  1002e3:	6a 0a                	push   $0xa
  1002e5:	e8 30 ff ff ff       	call   10021a <cputch>
  1002ea:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f0:	c9                   	leave  
  1002f1:	c3                   	ret    

001002f2 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f2:	55                   	push   %ebp
  1002f3:	89 e5                	mov    %esp,%ebp
  1002f5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002f8:	e8 2e 13 00 00       	call   10162b <cons_getc>
  1002fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100304:	74 f2                	je     1002f8 <getchar+0x6>
        /* do nothing */;
    return c;
  100306:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100309:	c9                   	leave  
  10030a:	c3                   	ret    

0010030b <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030b:	55                   	push   %ebp
  10030c:	89 e5                	mov    %esp,%ebp
  10030e:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  100311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100315:	74 13                	je     10032a <readline+0x1f>
        cprintf("%s", prompt);
  100317:	83 ec 08             	sub    $0x8,%esp
  10031a:	ff 75 08             	pushl  0x8(%ebp)
  10031d:	68 27 5b 10 00       	push   $0x105b27
  100322:	e8 40 ff ff ff       	call   100267 <cprintf>
  100327:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  10032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100331:	e8 bc ff ff ff       	call   1002f2 <getchar>
  100336:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100339:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033d:	79 0a                	jns    100349 <readline+0x3e>
            return NULL;
  10033f:	b8 00 00 00 00       	mov    $0x0,%eax
  100344:	e9 82 00 00 00       	jmp    1003cb <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 2b                	jle    10037a <readline+0x6f>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 22                	jg     10037a <readline+0x6f>
            cputchar(c);
  100358:	83 ec 0c             	sub    $0xc,%esp
  10035b:	ff 75 f0             	pushl  -0x10(%ebp)
  10035e:	e8 2a ff ff ff       	call   10028d <cputchar>
  100363:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100369:	8d 50 01             	lea    0x1(%eax),%edx
  10036c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100372:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100378:	eb 4c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  10037a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037e:	75 1a                	jne    10039a <readline+0x8f>
  100380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100384:	7e 14                	jle    10039a <readline+0x8f>
            cputchar(c);
  100386:	83 ec 0c             	sub    $0xc,%esp
  100389:	ff 75 f0             	pushl  -0x10(%ebp)
  10038c:	e8 fc fe ff ff       	call   10028d <cputchar>
  100391:	83 c4 10             	add    $0x10,%esp
            i --;
  100394:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100398:	eb 2c                	jmp    1003c6 <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  10039a:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10039e:	74 06                	je     1003a6 <readline+0x9b>
  1003a0:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003a4:	75 8b                	jne    100331 <readline+0x26>
            cputchar(c);
  1003a6:	83 ec 0c             	sub    $0xc,%esp
  1003a9:	ff 75 f0             	pushl  -0x10(%ebp)
  1003ac:	e8 dc fe ff ff       	call   10028d <cputchar>
  1003b1:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  1003b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003b7:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003bc:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003bf:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003c4:	eb 05                	jmp    1003cb <readline+0xc0>
        }
    }
  1003c6:	e9 66 ff ff ff       	jmp    100331 <readline+0x26>
}
  1003cb:	c9                   	leave  
  1003cc:	c3                   	ret    

001003cd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003cd:	55                   	push   %ebp
  1003ce:	89 e5                	mov    %esp,%ebp
  1003d0:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003d3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003d8:	85 c0                	test   %eax,%eax
  1003da:	75 4a                	jne    100426 <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003dc:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003e3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003ec:	83 ec 04             	sub    $0x4,%esp
  1003ef:	ff 75 0c             	pushl  0xc(%ebp)
  1003f2:	ff 75 08             	pushl  0x8(%ebp)
  1003f5:	68 2a 5b 10 00       	push   $0x105b2a
  1003fa:	e8 68 fe ff ff       	call   100267 <cprintf>
  1003ff:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100405:	83 ec 08             	sub    $0x8,%esp
  100408:	50                   	push   %eax
  100409:	ff 75 10             	pushl  0x10(%ebp)
  10040c:	e8 2d fe ff ff       	call   10023e <vcprintf>
  100411:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100414:	83 ec 0c             	sub    $0xc,%esp
  100417:	68 46 5b 10 00       	push   $0x105b46
  10041c:	e8 46 fe ff ff       	call   100267 <cprintf>
  100421:	83 c4 10             	add    $0x10,%esp
  100424:	eb 01                	jmp    100427 <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100426:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100427:	e8 3b 14 00 00       	call   101867 <intr_disable>
    while (1) {
        kmonitor(NULL);
  10042c:	83 ec 0c             	sub    $0xc,%esp
  10042f:	6a 00                	push   $0x0
  100431:	e8 36 08 00 00       	call   100c6c <kmonitor>
  100436:	83 c4 10             	add    $0x10,%esp
    }
  100439:	eb f1                	jmp    10042c <__panic+0x5f>

0010043b <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10043b:	55                   	push   %ebp
  10043c:	89 e5                	mov    %esp,%ebp
  10043e:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100441:	8d 45 14             	lea    0x14(%ebp),%eax
  100444:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100447:	83 ec 04             	sub    $0x4,%esp
  10044a:	ff 75 0c             	pushl  0xc(%ebp)
  10044d:	ff 75 08             	pushl  0x8(%ebp)
  100450:	68 48 5b 10 00       	push   $0x105b48
  100455:	e8 0d fe ff ff       	call   100267 <cprintf>
  10045a:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  10045d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100460:	83 ec 08             	sub    $0x8,%esp
  100463:	50                   	push   %eax
  100464:	ff 75 10             	pushl  0x10(%ebp)
  100467:	e8 d2 fd ff ff       	call   10023e <vcprintf>
  10046c:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  10046f:	83 ec 0c             	sub    $0xc,%esp
  100472:	68 46 5b 10 00       	push   $0x105b46
  100477:	e8 eb fd ff ff       	call   100267 <cprintf>
  10047c:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  10047f:	90                   	nop
  100480:	c9                   	leave  
  100481:	c3                   	ret    

00100482 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100485:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  10048a:	5d                   	pop    %ebp
  10048b:	c3                   	ret    

0010048c <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10048c:	55                   	push   %ebp
  10048d:	89 e5                	mov    %esp,%ebp
  10048f:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	8b 00                	mov    (%eax),%eax
  100497:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049a:	8b 45 10             	mov    0x10(%ebp),%eax
  10049d:	8b 00                	mov    (%eax),%eax
  10049f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004a9:	e9 d2 00 00 00       	jmp    100580 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	89 c2                	mov    %eax,%edx
  1004b8:	c1 ea 1f             	shr    $0x1f,%edx
  1004bb:	01 d0                	add    %edx,%eax
  1004bd:	d1 f8                	sar    %eax
  1004bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c5:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004c8:	eb 04                	jmp    1004ce <stab_binsearch+0x42>
            m --;
  1004ca:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d4:	7c 1f                	jl     1004f5 <stab_binsearch+0x69>
  1004d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d9:	89 d0                	mov    %edx,%eax
  1004db:	01 c0                	add    %eax,%eax
  1004dd:	01 d0                	add    %edx,%eax
  1004df:	c1 e0 02             	shl    $0x2,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ed:	0f b6 c0             	movzbl %al,%eax
  1004f0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f3:	75 d5                	jne    1004ca <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fb:	7d 0b                	jge    100508 <stab_binsearch+0x7c>
            l = true_m + 1;
  1004fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100500:	83 c0 01             	add    $0x1,%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100506:	eb 78                	jmp    100580 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100508:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100512:	89 d0                	mov    %edx,%eax
  100514:	01 c0                	add    %eax,%eax
  100516:	01 d0                	add    %edx,%eax
  100518:	c1 e0 02             	shl    $0x2,%eax
  10051b:	89 c2                	mov    %eax,%edx
  10051d:	8b 45 08             	mov    0x8(%ebp),%eax
  100520:	01 d0                	add    %edx,%eax
  100522:	8b 40 08             	mov    0x8(%eax),%eax
  100525:	3b 45 18             	cmp    0x18(%ebp),%eax
  100528:	73 13                	jae    10053d <stab_binsearch+0xb1>
            *region_left = m;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100530:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100535:	83 c0 01             	add    $0x1,%eax
  100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053b:	eb 43                	jmp    100580 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10053d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100540:	89 d0                	mov    %edx,%eax
  100542:	01 c0                	add    %eax,%eax
  100544:	01 d0                	add    %edx,%eax
  100546:	c1 e0 02             	shl    $0x2,%eax
  100549:	89 c2                	mov    %eax,%edx
  10054b:	8b 45 08             	mov    0x8(%ebp),%eax
  10054e:	01 d0                	add    %edx,%eax
  100550:	8b 40 08             	mov    0x8(%eax),%eax
  100553:	3b 45 18             	cmp    0x18(%ebp),%eax
  100556:	76 16                	jbe    10056e <stab_binsearch+0xe2>
            *region_right = m - 1;
  100558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055e:	8b 45 10             	mov    0x10(%ebp),%eax
  100561:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100566:	83 e8 01             	sub    $0x1,%eax
  100569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056c:	eb 12                	jmp    100580 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100574:	89 10                	mov    %edx,(%eax)
            l = m;
  100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057c:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100583:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100586:	0f 8e 22 ff ff ff    	jle    1004ae <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100590:	75 0f                	jne    1005a1 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100592:	8b 45 0c             	mov    0xc(%ebp),%eax
  100595:	8b 00                	mov    (%eax),%eax
  100597:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059a:	8b 45 10             	mov    0x10(%ebp),%eax
  10059d:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059f:	eb 3f                	jmp    1005e0 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a4:	8b 00                	mov    (%eax),%eax
  1005a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a9:	eb 04                	jmp    1005af <stab_binsearch+0x123>
  1005ab:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b2:	8b 00                	mov    (%eax),%eax
  1005b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b7:	7d 1f                	jge    1005d8 <stab_binsearch+0x14c>
  1005b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005bc:	89 d0                	mov    %edx,%eax
  1005be:	01 c0                	add    %eax,%eax
  1005c0:	01 d0                	add    %edx,%eax
  1005c2:	c1 e0 02             	shl    $0x2,%eax
  1005c5:	89 c2                	mov    %eax,%edx
  1005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ca:	01 d0                	add    %edx,%eax
  1005cc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d0:	0f b6 c0             	movzbl %al,%eax
  1005d3:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d6:	75 d3                	jne    1005ab <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005de:	89 10                	mov    %edx,(%eax)
    }
}
  1005e0:	90                   	nop
  1005e1:	c9                   	leave  
  1005e2:	c3                   	ret    

001005e3 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e3:	55                   	push   %ebp
  1005e4:	89 e5                	mov    %esp,%ebp
  1005e6:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 00 68 5b 10 00    	movl   $0x105b68,(%eax)
    info->eip_line = 0;
  1005f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ff:	c7 40 08 68 5b 10 00 	movl   $0x105b68,0x8(%eax)
    info->eip_fn_namelen = 9;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	8b 55 08             	mov    0x8(%ebp),%edx
  100616:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100619:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100623:	c7 45 f4 70 6d 10 00 	movl   $0x106d70,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062a:	c7 45 f0 b8 1b 11 00 	movl   $0x111bb8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100631:	c7 45 ec b9 1b 11 00 	movl   $0x111bb9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100638:	c7 45 e8 49 46 11 00 	movl   $0x114649,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100642:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100645:	76 0d                	jbe    100654 <debuginfo_eip+0x71>
  100647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064a:	83 e8 01             	sub    $0x1,%eax
  10064d:	0f b6 00             	movzbl (%eax),%eax
  100650:	84 c0                	test   %al,%al
  100652:	74 0a                	je     10065e <debuginfo_eip+0x7b>
        return -1;
  100654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100659:	e9 91 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10065e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100665:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066b:	29 c2                	sub    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	c1 f8 02             	sar    $0x2,%eax
  100672:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100678:	83 e8 01             	sub    $0x1,%eax
  10067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10067e:	ff 75 08             	pushl  0x8(%ebp)
  100681:	6a 64                	push   $0x64
  100683:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100686:	50                   	push   %eax
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	50                   	push   %eax
  10068b:	ff 75 f4             	pushl  -0xc(%ebp)
  10068e:	e8 f9 fd ff ff       	call   10048c <stab_binsearch>
  100693:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  100696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100699:	85 c0                	test   %eax,%eax
  10069b:	75 0a                	jne    1006a7 <debuginfo_eip+0xc4>
        return -1;
  10069d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a2:	e9 48 02 00 00       	jmp    1008ef <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b3:	ff 75 08             	pushl  0x8(%ebp)
  1006b6:	6a 24                	push   $0x24
  1006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bb:	50                   	push   %eax
  1006bc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006bf:	50                   	push   %eax
  1006c0:	ff 75 f4             	pushl  -0xc(%ebp)
  1006c3:	e8 c4 fd ff ff       	call   10048c <stab_binsearch>
  1006c8:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d1:	39 c2                	cmp    %eax,%edx
  1006d3:	7f 7c                	jg     100751 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d8:	89 c2                	mov    %eax,%edx
  1006da:	89 d0                	mov    %edx,%eax
  1006dc:	01 c0                	add    %eax,%eax
  1006de:	01 d0                	add    %edx,%eax
  1006e0:	c1 e0 02             	shl    $0x2,%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e8:	01 d0                	add    %edx,%eax
  1006ea:	8b 00                	mov    (%eax),%eax
  1006ec:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006f2:	29 d1                	sub    %edx,%ecx
  1006f4:	89 ca                	mov    %ecx,%edx
  1006f6:	39 d0                	cmp    %edx,%eax
  1006f8:	73 22                	jae    10071c <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fd:	89 c2                	mov    %eax,%edx
  1006ff:	89 d0                	mov    %edx,%eax
  100701:	01 c0                	add    %eax,%eax
  100703:	01 d0                	add    %edx,%eax
  100705:	c1 e0 02             	shl    $0x2,%eax
  100708:	89 c2                	mov    %eax,%edx
  10070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	8b 10                	mov    (%eax),%edx
  100711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100714:	01 c2                	add    %eax,%edx
  100716:	8b 45 0c             	mov    0xc(%ebp),%eax
  100719:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10071c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071f:	89 c2                	mov    %eax,%edx
  100721:	89 d0                	mov    %edx,%eax
  100723:	01 c0                	add    %eax,%eax
  100725:	01 d0                	add    %edx,%eax
  100727:	c1 e0 02             	shl    $0x2,%eax
  10072a:	89 c2                	mov    %eax,%edx
  10072c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072f:	01 d0                	add    %edx,%eax
  100731:	8b 50 08             	mov    0x8(%eax),%edx
  100734:	8b 45 0c             	mov    0xc(%ebp),%eax
  100737:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10073a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073d:	8b 40 10             	mov    0x10(%eax),%eax
  100740:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100746:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100749:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10074c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10074f:	eb 15                	jmp    100766 <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100751:	8b 45 0c             	mov    0xc(%ebp),%eax
  100754:	8b 55 08             	mov    0x8(%ebp),%edx
  100757:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10075a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10075d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100763:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	8b 40 08             	mov    0x8(%eax),%eax
  10076c:	83 ec 08             	sub    $0x8,%esp
  10076f:	6a 3a                	push   $0x3a
  100771:	50                   	push   %eax
  100772:	e8 ca 49 00 00       	call   105141 <strfind>
  100777:	83 c4 10             	add    $0x10,%esp
  10077a:	89 c2                	mov    %eax,%edx
  10077c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077f:	8b 40 08             	mov    0x8(%eax),%eax
  100782:	29 c2                	sub    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10078a:	83 ec 0c             	sub    $0xc,%esp
  10078d:	ff 75 08             	pushl  0x8(%ebp)
  100790:	6a 44                	push   $0x44
  100792:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100795:	50                   	push   %eax
  100796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100799:	50                   	push   %eax
  10079a:	ff 75 f4             	pushl  -0xc(%ebp)
  10079d:	e8 ea fc ff ff       	call   10048c <stab_binsearch>
  1007a2:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  1007a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ab:	39 c2                	cmp    %eax,%edx
  1007ad:	7f 24                	jg     1007d3 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  1007af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	89 d0                	mov    %edx,%eax
  1007b6:	01 c0                	add    %eax,%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	c1 e0 02             	shl    $0x2,%eax
  1007bd:	89 c2                	mov    %eax,%edx
  1007bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007c8:	0f b7 d0             	movzwl %ax,%edx
  1007cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ce:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007d1:	eb 13                	jmp    1007e6 <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007d8:	e9 12 01 00 00       	jmp    1008ef <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e0:	83 e8 01             	sub    $0x1,%eax
  1007e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007ec:	39 c2                	cmp    %eax,%edx
  1007ee:	7c 56                	jl     100846 <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100809:	3c 84                	cmp    $0x84,%al
  10080b:	74 39                	je     100846 <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10080d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100810:	89 c2                	mov    %eax,%edx
  100812:	89 d0                	mov    %edx,%eax
  100814:	01 c0                	add    %eax,%eax
  100816:	01 d0                	add    %edx,%eax
  100818:	c1 e0 02             	shl    $0x2,%eax
  10081b:	89 c2                	mov    %eax,%edx
  10081d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100820:	01 d0                	add    %edx,%eax
  100822:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100826:	3c 64                	cmp    $0x64,%al
  100828:	75 b3                	jne    1007dd <debuginfo_eip+0x1fa>
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	89 c2                	mov    %eax,%edx
  10082f:	89 d0                	mov    %edx,%eax
  100831:	01 c0                	add    %eax,%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	c1 e0 02             	shl    $0x2,%eax
  100838:	89 c2                	mov    %eax,%edx
  10083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083d:	01 d0                	add    %edx,%eax
  10083f:	8b 40 08             	mov    0x8(%eax),%eax
  100842:	85 c0                	test   %eax,%eax
  100844:	74 97                	je     1007dd <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100846:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084c:	39 c2                	cmp    %eax,%edx
  10084e:	7c 46                	jl     100896 <debuginfo_eip+0x2b3>
  100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100853:	89 c2                	mov    %eax,%edx
  100855:	89 d0                	mov    %edx,%eax
  100857:	01 c0                	add    %eax,%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	c1 e0 02             	shl    $0x2,%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100863:	01 d0                	add    %edx,%eax
  100865:	8b 00                	mov    (%eax),%eax
  100867:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10086a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10086d:	29 d1                	sub    %edx,%ecx
  10086f:	89 ca                	mov    %ecx,%edx
  100871:	39 d0                	cmp    %edx,%eax
  100873:	73 21                	jae    100896 <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 10                	mov    (%eax),%edx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	01 c2                	add    %eax,%edx
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100896:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100899:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10089c:	39 c2                	cmp    %eax,%edx
  10089e:	7d 4a                	jge    1008ea <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  1008a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008a9:	eb 18                	jmp    1008c3 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ae:	8b 40 14             	mov    0x14(%eax),%eax
  1008b1:	8d 50 01             	lea    0x1(%eax),%edx
  1008b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b7:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008bd:	83 c0 01             	add    $0x1,%eax
  1008c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008c3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008c9:	39 c2                	cmp    %eax,%edx
  1008cb:	7d 1d                	jge    1008ea <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	89 c2                	mov    %eax,%edx
  1008d2:	89 d0                	mov    %edx,%eax
  1008d4:	01 c0                	add    %eax,%eax
  1008d6:	01 d0                	add    %edx,%eax
  1008d8:	c1 e0 02             	shl    $0x2,%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008e0:	01 d0                	add    %edx,%eax
  1008e2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008e6:	3c a0                	cmp    $0xa0,%al
  1008e8:	74 c1                	je     1008ab <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008ef:	c9                   	leave  
  1008f0:	c3                   	ret    

001008f1 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008f1:	55                   	push   %ebp
  1008f2:	89 e5                	mov    %esp,%ebp
  1008f4:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008f7:	83 ec 0c             	sub    $0xc,%esp
  1008fa:	68 72 5b 10 00       	push   $0x105b72
  1008ff:	e8 63 f9 ff ff       	call   100267 <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 2a 00 10 00       	push   $0x10002a
  10090f:	68 8b 5b 10 00       	push   $0x105b8b
  100914:	e8 4e f9 ff ff       	call   100267 <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 64 5a 10 00       	push   $0x105a64
  100924:	68 a3 5b 10 00       	push   $0x105ba3
  100929:	e8 39 f9 ff ff       	call   100267 <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100931:	83 ec 08             	sub    $0x8,%esp
  100934:	68 36 7a 11 00       	push   $0x117a36
  100939:	68 bb 5b 10 00       	push   $0x105bbb
  10093e:	e8 24 f9 ff ff       	call   100267 <cprintf>
  100943:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  100946:	83 ec 08             	sub    $0x8,%esp
  100949:	68 68 89 11 00       	push   $0x118968
  10094e:	68 d3 5b 10 00       	push   $0x105bd3
  100953:	e8 0f f9 ff ff       	call   100267 <cprintf>
  100958:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10095b:	b8 68 89 11 00       	mov    $0x118968,%eax
  100960:	05 ff 03 00 00       	add    $0x3ff,%eax
  100965:	ba 2a 00 10 00       	mov    $0x10002a,%edx
  10096a:	29 d0                	sub    %edx,%eax
  10096c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100972:	85 c0                	test   %eax,%eax
  100974:	0f 48 c2             	cmovs  %edx,%eax
  100977:	c1 f8 0a             	sar    $0xa,%eax
  10097a:	83 ec 08             	sub    $0x8,%esp
  10097d:	50                   	push   %eax
  10097e:	68 ec 5b 10 00       	push   $0x105bec
  100983:	e8 df f8 ff ff       	call   100267 <cprintf>
  100988:	83 c4 10             	add    $0x10,%esp
}
  10098b:	90                   	nop
  10098c:	c9                   	leave  
  10098d:	c3                   	ret    

0010098e <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10098e:	55                   	push   %ebp
  10098f:	89 e5                	mov    %esp,%ebp
  100991:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100997:	83 ec 08             	sub    $0x8,%esp
  10099a:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10099d:	50                   	push   %eax
  10099e:	ff 75 08             	pushl  0x8(%ebp)
  1009a1:	e8 3d fc ff ff       	call   1005e3 <debuginfo_eip>
  1009a6:	83 c4 10             	add    $0x10,%esp
  1009a9:	85 c0                	test   %eax,%eax
  1009ab:	74 15                	je     1009c2 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ad:	83 ec 08             	sub    $0x8,%esp
  1009b0:	ff 75 08             	pushl  0x8(%ebp)
  1009b3:	68 16 5c 10 00       	push   $0x105c16
  1009b8:	e8 aa f8 ff ff       	call   100267 <cprintf>
  1009bd:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009c0:	eb 65                	jmp    100a27 <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009c9:	eb 1c                	jmp    1009e7 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009cb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d1:	01 d0                	add    %edx,%eax
  1009d3:	0f b6 00             	movzbl (%eax),%eax
  1009d6:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009df:	01 ca                	add    %ecx,%edx
  1009e1:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009ed:	7f dc                	jg     1009cb <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009ef:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	01 d0                	add    %edx,%eax
  1009fa:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a00:	8b 55 08             	mov    0x8(%ebp),%edx
  100a03:	89 d1                	mov    %edx,%ecx
  100a05:	29 c1                	sub    %eax,%ecx
  100a07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a0d:	83 ec 0c             	sub    $0xc,%esp
  100a10:	51                   	push   %ecx
  100a11:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a17:	51                   	push   %ecx
  100a18:	52                   	push   %edx
  100a19:	50                   	push   %eax
  100a1a:	68 32 5c 10 00       	push   $0x105c32
  100a1f:	e8 43 f8 ff ff       	call   100267 <cprintf>
  100a24:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  100a27:	90                   	nop
  100a28:	c9                   	leave  
  100a29:	c3                   	ret    

00100a2a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a2a:	55                   	push   %ebp
  100a2b:	89 e5                	mov    %esp,%ebp
  100a2d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a30:	8b 45 04             	mov    0x4(%ebp),%eax
  100a33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a39:	c9                   	leave  
  100a3a:	c3                   	ret    

00100a3b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a3b:	55                   	push   %ebp
  100a3c:	89 e5                	mov    %esp,%ebp
  100a3e:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a41:	89 e8                	mov    %ebp,%eax
  100a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  100a49:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();
  100a4c:	e8 d9 ff ff ff       	call   100a2a <read_eip>
  100a51:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
  100a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a5b:	e9 8d 00 00 00       	jmp    100aed <print_stackframe+0xb2>
	{

	//打印当前ebp和eip的地址

		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a60:	83 ec 04             	sub    $0x4,%esp
  100a63:	ff 75 f0             	pushl  -0x10(%ebp)
  100a66:	ff 75 f4             	pushl  -0xc(%ebp)
  100a69:	68 44 5c 10 00       	push   $0x105c44
  100a6e:	e8 f4 f7 ff ff       	call   100267 <cprintf>
  100a73:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;
  100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a79:	83 c0 08             	add    $0x8,%eax
  100a7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
  100a7f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a86:	eb 26                	jmp    100aae <print_stackframe+0x73>

		    cprintf("0x%08x ", args[j]);
  100a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a95:	01 d0                	add    %edx,%eax
  100a97:	8b 00                	mov    (%eax),%eax
  100a99:	83 ec 08             	sub    $0x8,%esp
  100a9c:	50                   	push   %eax
  100a9d:	68 60 5c 10 00       	push   $0x105c60
  100aa2:	e8 c0 f7 ff ff       	call   100267 <cprintf>
  100aa7:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
  100aaa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100aae:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ab2:	7e d4                	jle    100a88 <print_stackframe+0x4d>

		    cprintf("0x%08x ", args[j]);

		}

		cprintf("\n");
  100ab4:	83 ec 0c             	sub    $0xc,%esp
  100ab7:	68 68 5c 10 00       	push   $0x105c68
  100abc:	e8 a6 f7 ff ff       	call   100267 <cprintf>
  100ac1:	83 c4 10             	add    $0x10,%esp

		print_debuginfo(eip - 1);
  100ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac7:	83 e8 01             	sub    $0x1,%eax
  100aca:	83 ec 0c             	sub    $0xc,%esp
  100acd:	50                   	push   %eax
  100ace:	e8 bb fe ff ff       	call   10098e <print_debuginfo>
  100ad3:	83 c4 10             	add    $0x10,%esp

		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容
  100ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad9:	83 c0 04             	add    $0x4,%eax
  100adc:	8b 00                	mov    (%eax),%eax
  100ade:	89 45 f0             	mov    %eax,-0x10(%ebp)

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8b 00                	mov    (%eax),%eax
  100ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
  100ae9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100af1:	74 0a                	je     100afd <print_stackframe+0xc2>
  100af3:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100af7:	0f 8e 63 ff ff ff    	jle    100a60 <print_stackframe+0x25>
		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容

	 }
}
  100afd:	90                   	nop
  100afe:	c9                   	leave  
  100aff:	c3                   	ret    

00100b00 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b00:	55                   	push   %ebp
  100b01:	89 e5                	mov    %esp,%ebp
  100b03:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0d:	eb 0c                	jmp    100b1b <parse+0x1b>
            *buf ++ = '\0';
  100b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b12:	8d 50 01             	lea    0x1(%eax),%edx
  100b15:	89 55 08             	mov    %edx,0x8(%ebp)
  100b18:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1e:	0f b6 00             	movzbl (%eax),%eax
  100b21:	84 c0                	test   %al,%al
  100b23:	74 1e                	je     100b43 <parse+0x43>
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	0f b6 00             	movzbl (%eax),%eax
  100b2b:	0f be c0             	movsbl %al,%eax
  100b2e:	83 ec 08             	sub    $0x8,%esp
  100b31:	50                   	push   %eax
  100b32:	68 ec 5c 10 00       	push   $0x105cec
  100b37:	e8 d2 45 00 00       	call   10510e <strchr>
  100b3c:	83 c4 10             	add    $0x10,%esp
  100b3f:	85 c0                	test   %eax,%eax
  100b41:	75 cc                	jne    100b0f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b43:	8b 45 08             	mov    0x8(%ebp),%eax
  100b46:	0f b6 00             	movzbl (%eax),%eax
  100b49:	84 c0                	test   %al,%al
  100b4b:	74 69                	je     100bb6 <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b4d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b51:	75 12                	jne    100b65 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b53:	83 ec 08             	sub    $0x8,%esp
  100b56:	6a 10                	push   $0x10
  100b58:	68 f1 5c 10 00       	push   $0x105cf1
  100b5d:	e8 05 f7 ff ff       	call   100267 <cprintf>
  100b62:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b68:	8d 50 01             	lea    0x1(%eax),%edx
  100b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b78:	01 c2                	add    %eax,%edx
  100b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b7f:	eb 04                	jmp    100b85 <parse+0x85>
            buf ++;
  100b81:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b85:	8b 45 08             	mov    0x8(%ebp),%eax
  100b88:	0f b6 00             	movzbl (%eax),%eax
  100b8b:	84 c0                	test   %al,%al
  100b8d:	0f 84 7a ff ff ff    	je     100b0d <parse+0xd>
  100b93:	8b 45 08             	mov    0x8(%ebp),%eax
  100b96:	0f b6 00             	movzbl (%eax),%eax
  100b99:	0f be c0             	movsbl %al,%eax
  100b9c:	83 ec 08             	sub    $0x8,%esp
  100b9f:	50                   	push   %eax
  100ba0:	68 ec 5c 10 00       	push   $0x105cec
  100ba5:	e8 64 45 00 00       	call   10510e <strchr>
  100baa:	83 c4 10             	add    $0x10,%esp
  100bad:	85 c0                	test   %eax,%eax
  100baf:	74 d0                	je     100b81 <parse+0x81>
            buf ++;
        }
    }
  100bb1:	e9 57 ff ff ff       	jmp    100b0d <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100bb6:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bba:	c9                   	leave  
  100bbb:	c3                   	ret    

00100bbc <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bbc:	55                   	push   %ebp
  100bbd:	89 e5                	mov    %esp,%ebp
  100bbf:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bc2:	83 ec 08             	sub    $0x8,%esp
  100bc5:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bc8:	50                   	push   %eax
  100bc9:	ff 75 08             	pushl  0x8(%ebp)
  100bcc:	e8 2f ff ff ff       	call   100b00 <parse>
  100bd1:	83 c4 10             	add    $0x10,%esp
  100bd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bdb:	75 0a                	jne    100be7 <runcmd+0x2b>
        return 0;
  100bdd:	b8 00 00 00 00       	mov    $0x0,%eax
  100be2:	e9 83 00 00 00       	jmp    100c6a <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100be7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bee:	eb 59                	jmp    100c49 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bf0:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf6:	89 d0                	mov    %edx,%eax
  100bf8:	01 c0                	add    %eax,%eax
  100bfa:	01 d0                	add    %edx,%eax
  100bfc:	c1 e0 02             	shl    $0x2,%eax
  100bff:	05 20 70 11 00       	add    $0x117020,%eax
  100c04:	8b 00                	mov    (%eax),%eax
  100c06:	83 ec 08             	sub    $0x8,%esp
  100c09:	51                   	push   %ecx
  100c0a:	50                   	push   %eax
  100c0b:	e8 5e 44 00 00       	call   10506e <strcmp>
  100c10:	83 c4 10             	add    $0x10,%esp
  100c13:	85 c0                	test   %eax,%eax
  100c15:	75 2e                	jne    100c45 <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1a:	89 d0                	mov    %edx,%eax
  100c1c:	01 c0                	add    %eax,%eax
  100c1e:	01 d0                	add    %edx,%eax
  100c20:	c1 e0 02             	shl    $0x2,%eax
  100c23:	05 28 70 11 00       	add    $0x117028,%eax
  100c28:	8b 10                	mov    (%eax),%edx
  100c2a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c2d:	83 c0 04             	add    $0x4,%eax
  100c30:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c33:	83 e9 01             	sub    $0x1,%ecx
  100c36:	83 ec 04             	sub    $0x4,%esp
  100c39:	ff 75 0c             	pushl  0xc(%ebp)
  100c3c:	50                   	push   %eax
  100c3d:	51                   	push   %ecx
  100c3e:	ff d2                	call   *%edx
  100c40:	83 c4 10             	add    $0x10,%esp
  100c43:	eb 25                	jmp    100c6a <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4c:	83 f8 02             	cmp    $0x2,%eax
  100c4f:	76 9f                	jbe    100bf0 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c51:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c54:	83 ec 08             	sub    $0x8,%esp
  100c57:	50                   	push   %eax
  100c58:	68 0f 5d 10 00       	push   $0x105d0f
  100c5d:	e8 05 f6 ff ff       	call   100267 <cprintf>
  100c62:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6a:	c9                   	leave  
  100c6b:	c3                   	ret    

00100c6c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c6c:	55                   	push   %ebp
  100c6d:	89 e5                	mov    %esp,%ebp
  100c6f:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c72:	83 ec 0c             	sub    $0xc,%esp
  100c75:	68 28 5d 10 00       	push   $0x105d28
  100c7a:	e8 e8 f5 ff ff       	call   100267 <cprintf>
  100c7f:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c82:	83 ec 0c             	sub    $0xc,%esp
  100c85:	68 50 5d 10 00       	push   $0x105d50
  100c8a:	e8 d8 f5 ff ff       	call   100267 <cprintf>
  100c8f:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c96:	74 0e                	je     100ca6 <kmonitor+0x3a>
        print_trapframe(tf);
  100c98:	83 ec 0c             	sub    $0xc,%esp
  100c9b:	ff 75 08             	pushl  0x8(%ebp)
  100c9e:	e8 9f 0d 00 00       	call   101a42 <print_trapframe>
  100ca3:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ca6:	83 ec 0c             	sub    $0xc,%esp
  100ca9:	68 75 5d 10 00       	push   $0x105d75
  100cae:	e8 58 f6 ff ff       	call   10030b <readline>
  100cb3:	83 c4 10             	add    $0x10,%esp
  100cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cbd:	74 e7                	je     100ca6 <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100cbf:	83 ec 08             	sub    $0x8,%esp
  100cc2:	ff 75 08             	pushl  0x8(%ebp)
  100cc5:	ff 75 f4             	pushl  -0xc(%ebp)
  100cc8:	e8 ef fe ff ff       	call   100bbc <runcmd>
  100ccd:	83 c4 10             	add    $0x10,%esp
  100cd0:	85 c0                	test   %eax,%eax
  100cd2:	78 02                	js     100cd6 <kmonitor+0x6a>
                break;
            }
        }
    }
  100cd4:	eb d0                	jmp    100ca6 <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cd6:	90                   	nop
            }
        }
    }
}
  100cd7:	90                   	nop
  100cd8:	c9                   	leave  
  100cd9:	c3                   	ret    

00100cda <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cda:	55                   	push   %ebp
  100cdb:	89 e5                	mov    %esp,%ebp
  100cdd:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce7:	eb 3c                	jmp    100d25 <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cec:	89 d0                	mov    %edx,%eax
  100cee:	01 c0                	add    %eax,%eax
  100cf0:	01 d0                	add    %edx,%eax
  100cf2:	c1 e0 02             	shl    $0x2,%eax
  100cf5:	05 24 70 11 00       	add    $0x117024,%eax
  100cfa:	8b 08                	mov    (%eax),%ecx
  100cfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cff:	89 d0                	mov    %edx,%eax
  100d01:	01 c0                	add    %eax,%eax
  100d03:	01 d0                	add    %edx,%eax
  100d05:	c1 e0 02             	shl    $0x2,%eax
  100d08:	05 20 70 11 00       	add    $0x117020,%eax
  100d0d:	8b 00                	mov    (%eax),%eax
  100d0f:	83 ec 04             	sub    $0x4,%esp
  100d12:	51                   	push   %ecx
  100d13:	50                   	push   %eax
  100d14:	68 79 5d 10 00       	push   $0x105d79
  100d19:	e8 49 f5 ff ff       	call   100267 <cprintf>
  100d1e:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d28:	83 f8 02             	cmp    $0x2,%eax
  100d2b:	76 bc                	jbe    100ce9 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d32:	c9                   	leave  
  100d33:	c3                   	ret    

00100d34 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d34:	55                   	push   %ebp
  100d35:	89 e5                	mov    %esp,%ebp
  100d37:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d3a:	e8 b2 fb ff ff       	call   1008f1 <print_kerninfo>
    return 0;
  100d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d44:	c9                   	leave  
  100d45:	c3                   	ret    

00100d46 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d46:	55                   	push   %ebp
  100d47:	89 e5                	mov    %esp,%ebp
  100d49:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d4c:	e8 ea fc ff ff       	call   100a3b <print_stackframe>
    return 0;
  100d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d56:	c9                   	leave  
  100d57:	c3                   	ret    

00100d58 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d58:	55                   	push   %ebp
  100d59:	89 e5                	mov    %esp,%ebp
  100d5b:	83 ec 18             	sub    $0x18,%esp
  100d5e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d64:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d68:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d6c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d70:	ee                   	out    %al,(%dx)
  100d71:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d77:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d7b:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d7f:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d83:	ee                   	out    %al,(%dx)
  100d84:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8a:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d8e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d92:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d96:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d97:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d9e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da1:	83 ec 0c             	sub    $0xc,%esp
  100da4:	68 82 5d 10 00       	push   $0x105d82
  100da9:	e8 b9 f4 ff ff       	call   100267 <cprintf>
  100dae:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100db1:	83 ec 0c             	sub    $0xc,%esp
  100db4:	6a 00                	push   $0x0
  100db6:	e8 3b 09 00 00       	call   1016f6 <pic_enable>
  100dbb:	83 c4 10             	add    $0x10,%esp
}
  100dbe:	90                   	nop
  100dbf:	c9                   	leave  
  100dc0:	c3                   	ret    

00100dc1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dc1:	55                   	push   %ebp
  100dc2:	89 e5                	mov    %esp,%ebp
  100dc4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dc7:	9c                   	pushf  
  100dc8:	58                   	pop    %eax
  100dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dcf:	25 00 02 00 00       	and    $0x200,%eax
  100dd4:	85 c0                	test   %eax,%eax
  100dd6:	74 0c                	je     100de4 <__intr_save+0x23>
        intr_disable();
  100dd8:	e8 8a 0a 00 00       	call   101867 <intr_disable>
        return 1;
  100ddd:	b8 01 00 00 00       	mov    $0x1,%eax
  100de2:	eb 05                	jmp    100de9 <__intr_save+0x28>
    }
    return 0;
  100de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100de9:	c9                   	leave  
  100dea:	c3                   	ret    

00100deb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100df5:	74 05                	je     100dfc <__intr_restore+0x11>
        intr_enable();
  100df7:	e8 64 0a 00 00       	call   101860 <intr_enable>
    }
}
  100dfc:	90                   	nop
  100dfd:	c9                   	leave  
  100dfe:	c3                   	ret    

00100dff <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dff:	55                   	push   %ebp
  100e00:	89 e5                	mov    %esp,%ebp
  100e02:	83 ec 10             	sub    $0x10,%esp
  100e05:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e0b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e0f:	89 c2                	mov    %eax,%edx
  100e11:	ec                   	in     (%dx),%al
  100e12:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e15:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e1b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100e1f:	89 c2                	mov    %eax,%edx
  100e21:	ec                   	in     (%dx),%al
  100e22:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e25:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e2b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e2f:	89 c2                	mov    %eax,%edx
  100e31:	ec                   	in     (%dx),%al
  100e32:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e35:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e3b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100e3f:	89 c2                	mov    %eax,%edx
  100e41:	ec                   	in     (%dx),%al
  100e42:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e45:	90                   	nop
  100e46:	c9                   	leave  
  100e47:	c3                   	ret    

00100e48 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e48:	55                   	push   %ebp
  100e49:	89 e5                	mov    %esp,%ebp
  100e4b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e4e:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e58:	0f b7 00             	movzwl (%eax),%eax
  100e5b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e62:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e6a:	0f b7 00             	movzwl (%eax),%eax
  100e6d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e71:	74 12                	je     100e85 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e73:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e7a:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e81:	b4 03 
  100e83:	eb 13                	jmp    100e98 <cga_init+0x50>
    } else {
        *cp = was;
  100e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e88:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e8c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e8f:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e96:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e98:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e9f:	0f b7 c0             	movzwl %ax,%eax
  100ea2:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100ea6:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eaa:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100eae:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100eb2:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eb3:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eba:	83 c0 01             	add    $0x1,%eax
  100ebd:	0f b7 c0             	movzwl %ax,%eax
  100ec0:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ec4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ec8:	89 c2                	mov    %eax,%edx
  100eca:	ec                   	in     (%dx),%al
  100ecb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ece:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ed2:	0f b6 c0             	movzbl %al,%eax
  100ed5:	c1 e0 08             	shl    $0x8,%eax
  100ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100edb:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee2:	0f b7 c0             	movzwl %ax,%eax
  100ee5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100ee9:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eed:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100ef1:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100ef5:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ef6:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100efd:	83 c0 01             	add    $0x1,%eax
  100f00:	0f b7 c0             	movzwl %ax,%eax
  100f03:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f07:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f0b:	89 c2                	mov    %eax,%edx
  100f0d:	ec                   	in     (%dx),%al
  100f0e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f15:	0f b6 c0             	movzbl %al,%eax
  100f18:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f1e:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f26:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f2c:	90                   	nop
  100f2d:	c9                   	leave  
  100f2e:	c3                   	ret    

00100f2f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f2f:	55                   	push   %ebp
  100f30:	89 e5                	mov    %esp,%ebp
  100f32:	83 ec 28             	sub    $0x28,%esp
  100f35:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f3b:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f3f:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f43:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f47:	ee                   	out    %al,(%dx)
  100f48:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f4e:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f52:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f56:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100f5a:	ee                   	out    %al,(%dx)
  100f5b:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f61:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f65:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f69:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f6d:	ee                   	out    %al,(%dx)
  100f6e:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f74:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f78:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f7c:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f80:	ee                   	out    %al,(%dx)
  100f81:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f87:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f8b:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f8f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f9a:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f9e:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100fa2:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fad:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fb1:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fc0:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100fc4:	89 c2                	mov    %eax,%edx
  100fc6:	ec                   	in     (%dx),%al
  100fc7:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fca:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fce:	3c ff                	cmp    $0xff,%al
  100fd0:	0f 95 c0             	setne  %al
  100fd3:	0f b6 c0             	movzbl %al,%eax
  100fd6:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fdb:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100feb:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100ff1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100ff5:	89 c2                	mov    %eax,%edx
  100ff7:	ec                   	in     (%dx),%al
  100ff8:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ffb:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101000:	85 c0                	test   %eax,%eax
  101002:	74 0d                	je     101011 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  101004:	83 ec 0c             	sub    $0xc,%esp
  101007:	6a 04                	push   $0x4
  101009:	e8 e8 06 00 00       	call   1016f6 <pic_enable>
  10100e:	83 c4 10             	add    $0x10,%esp
    }
}
  101011:	90                   	nop
  101012:	c9                   	leave  
  101013:	c3                   	ret    

00101014 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101014:	55                   	push   %ebp
  101015:	89 e5                	mov    %esp,%ebp
  101017:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101021:	eb 09                	jmp    10102c <lpt_putc_sub+0x18>
        delay();
  101023:	e8 d7 fd ff ff       	call   100dff <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101028:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10102c:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  101032:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  101036:	89 c2                	mov    %eax,%edx
  101038:	ec                   	in     (%dx),%al
  101039:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  10103c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101040:	84 c0                	test   %al,%al
  101042:	78 09                	js     10104d <lpt_putc_sub+0x39>
  101044:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10104b:	7e d6                	jle    101023 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10104d:	8b 45 08             	mov    0x8(%ebp),%eax
  101050:	0f b6 c0             	movzbl %al,%eax
  101053:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101059:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10105c:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  101060:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  101064:	ee                   	out    %al,(%dx)
  101065:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10106b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10106f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101077:	ee                   	out    %al,(%dx)
  101078:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  10107e:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101082:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  101086:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10108a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10108b:	90                   	nop
  10108c:	c9                   	leave  
  10108d:	c3                   	ret    

0010108e <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10108e:	55                   	push   %ebp
  10108f:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101091:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101095:	74 0d                	je     1010a4 <lpt_putc+0x16>
        lpt_putc_sub(c);
  101097:	ff 75 08             	pushl  0x8(%ebp)
  10109a:	e8 75 ff ff ff       	call   101014 <lpt_putc_sub>
  10109f:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010a2:	eb 1e                	jmp    1010c2 <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1010a4:	6a 08                	push   $0x8
  1010a6:	e8 69 ff ff ff       	call   101014 <lpt_putc_sub>
  1010ab:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  1010ae:	6a 20                	push   $0x20
  1010b0:	e8 5f ff ff ff       	call   101014 <lpt_putc_sub>
  1010b5:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  1010b8:	6a 08                	push   $0x8
  1010ba:	e8 55 ff ff ff       	call   101014 <lpt_putc_sub>
  1010bf:	83 c4 04             	add    $0x4,%esp
    }
}
  1010c2:	90                   	nop
  1010c3:	c9                   	leave  
  1010c4:	c3                   	ret    

001010c5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010c5:	55                   	push   %ebp
  1010c6:	89 e5                	mov    %esp,%ebp
  1010c8:	53                   	push   %ebx
  1010c9:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cf:	b0 00                	mov    $0x0,%al
  1010d1:	85 c0                	test   %eax,%eax
  1010d3:	75 07                	jne    1010dc <cga_putc+0x17>
        c |= 0x0700;
  1010d5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010df:	0f b6 c0             	movzbl %al,%eax
  1010e2:	83 f8 0a             	cmp    $0xa,%eax
  1010e5:	74 4e                	je     101135 <cga_putc+0x70>
  1010e7:	83 f8 0d             	cmp    $0xd,%eax
  1010ea:	74 59                	je     101145 <cga_putc+0x80>
  1010ec:	83 f8 08             	cmp    $0x8,%eax
  1010ef:	0f 85 8a 00 00 00    	jne    10117f <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  1010f5:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010fc:	66 85 c0             	test   %ax,%ax
  1010ff:	0f 84 a0 00 00 00    	je     1011a5 <cga_putc+0xe0>
            crt_pos --;
  101105:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10110c:	83 e8 01             	sub    $0x1,%eax
  10110f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101115:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10111a:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101121:	0f b7 d2             	movzwl %dx,%edx
  101124:	01 d2                	add    %edx,%edx
  101126:	01 d0                	add    %edx,%eax
  101128:	8b 55 08             	mov    0x8(%ebp),%edx
  10112b:	b2 00                	mov    $0x0,%dl
  10112d:	83 ca 20             	or     $0x20,%edx
  101130:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  101133:	eb 70                	jmp    1011a5 <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  101135:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10113c:	83 c0 50             	add    $0x50,%eax
  10113f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101145:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10114c:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101153:	0f b7 c1             	movzwl %cx,%eax
  101156:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10115c:	c1 e8 10             	shr    $0x10,%eax
  10115f:	89 c2                	mov    %eax,%edx
  101161:	66 c1 ea 06          	shr    $0x6,%dx
  101165:	89 d0                	mov    %edx,%eax
  101167:	c1 e0 02             	shl    $0x2,%eax
  10116a:	01 d0                	add    %edx,%eax
  10116c:	c1 e0 04             	shl    $0x4,%eax
  10116f:	29 c1                	sub    %eax,%ecx
  101171:	89 ca                	mov    %ecx,%edx
  101173:	89 d8                	mov    %ebx,%eax
  101175:	29 d0                	sub    %edx,%eax
  101177:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10117d:	eb 27                	jmp    1011a6 <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10117f:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  101185:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10118c:	8d 50 01             	lea    0x1(%eax),%edx
  10118f:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  101196:	0f b7 c0             	movzwl %ax,%eax
  101199:	01 c0                	add    %eax,%eax
  10119b:	01 c8                	add    %ecx,%eax
  10119d:	8b 55 08             	mov    0x8(%ebp),%edx
  1011a0:	66 89 10             	mov    %dx,(%eax)
        break;
  1011a3:	eb 01                	jmp    1011a6 <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011a5:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011a6:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ad:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011b1:	76 59                	jbe    10120c <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011b3:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011b8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011be:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011c3:	83 ec 04             	sub    $0x4,%esp
  1011c6:	68 00 0f 00 00       	push   $0xf00
  1011cb:	52                   	push   %edx
  1011cc:	50                   	push   %eax
  1011cd:	e8 3b 41 00 00       	call   10530d <memmove>
  1011d2:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011d5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011dc:	eb 15                	jmp    1011f3 <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  1011de:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011e6:	01 d2                	add    %edx,%edx
  1011e8:	01 d0                	add    %edx,%eax
  1011ea:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011f3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011fa:	7e e2                	jle    1011de <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011fc:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101203:	83 e8 50             	sub    $0x50,%eax
  101206:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10120c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101213:	0f b7 c0             	movzwl %ax,%eax
  101216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10121a:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10121e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  101222:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101226:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101227:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122e:	66 c1 e8 08          	shr    $0x8,%ax
  101232:	0f b6 c0             	movzbl %al,%eax
  101235:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10123c:	83 c2 01             	add    $0x1,%edx
  10123f:	0f b7 d2             	movzwl %dx,%edx
  101242:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101246:	88 45 e9             	mov    %al,-0x17(%ebp)
  101249:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10124d:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101251:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101252:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101259:	0f b7 c0             	movzwl %ax,%eax
  10125c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101260:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101264:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101268:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10126d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101274:	0f b6 c0             	movzbl %al,%eax
  101277:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10127e:	83 c2 01             	add    $0x1,%edx
  101281:	0f b7 d2             	movzwl %dx,%edx
  101284:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101288:	88 45 eb             	mov    %al,-0x15(%ebp)
  10128b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  10128f:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
}
  101294:	90                   	nop
  101295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101298:	c9                   	leave  
  101299:	c3                   	ret    

0010129a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10129a:	55                   	push   %ebp
  10129b:	89 e5                	mov    %esp,%ebp
  10129d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012a7:	eb 09                	jmp    1012b2 <serial_putc_sub+0x18>
        delay();
  1012a9:	e8 51 fb ff ff       	call   100dff <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012b2:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012b8:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  1012bc:	89 c2                	mov    %eax,%edx
  1012be:	ec                   	in     (%dx),%al
  1012bf:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012c2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012c6:	0f b6 c0             	movzbl %al,%eax
  1012c9:	83 e0 20             	and    $0x20,%eax
  1012cc:	85 c0                	test   %eax,%eax
  1012ce:	75 09                	jne    1012d9 <serial_putc_sub+0x3f>
  1012d0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012d7:	7e d0                	jle    1012a9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012dc:	0f b6 c0             	movzbl %al,%eax
  1012df:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  1012e5:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012e8:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  1012ec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1012f0:	ee                   	out    %al,(%dx)
}
  1012f1:	90                   	nop
  1012f2:	c9                   	leave  
  1012f3:	c3                   	ret    

001012f4 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012f4:	55                   	push   %ebp
  1012f5:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012f7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012fb:	74 0d                	je     10130a <serial_putc+0x16>
        serial_putc_sub(c);
  1012fd:	ff 75 08             	pushl  0x8(%ebp)
  101300:	e8 95 ff ff ff       	call   10129a <serial_putc_sub>
  101305:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101308:	eb 1e                	jmp    101328 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  10130a:	6a 08                	push   $0x8
  10130c:	e8 89 ff ff ff       	call   10129a <serial_putc_sub>
  101311:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  101314:	6a 20                	push   $0x20
  101316:	e8 7f ff ff ff       	call   10129a <serial_putc_sub>
  10131b:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  10131e:	6a 08                	push   $0x8
  101320:	e8 75 ff ff ff       	call   10129a <serial_putc_sub>
  101325:	83 c4 04             	add    $0x4,%esp
    }
}
  101328:	90                   	nop
  101329:	c9                   	leave  
  10132a:	c3                   	ret    

0010132b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10132b:	55                   	push   %ebp
  10132c:	89 e5                	mov    %esp,%ebp
  10132e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101331:	eb 33                	jmp    101366 <cons_intr+0x3b>
        if (c != 0) {
  101333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101337:	74 2d                	je     101366 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101339:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10133e:	8d 50 01             	lea    0x1(%eax),%edx
  101341:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10134a:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101350:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101355:	3d 00 02 00 00       	cmp    $0x200,%eax
  10135a:	75 0a                	jne    101366 <cons_intr+0x3b>
                cons.wpos = 0;
  10135c:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101363:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101366:	8b 45 08             	mov    0x8(%ebp),%eax
  101369:	ff d0                	call   *%eax
  10136b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10136e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101372:	75 bf                	jne    101333 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101374:	90                   	nop
  101375:	c9                   	leave  
  101376:	c3                   	ret    

00101377 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101377:	55                   	push   %ebp
  101378:	89 e5                	mov    %esp,%ebp
  10137a:	83 ec 10             	sub    $0x10,%esp
  10137d:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101383:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101387:	89 c2                	mov    %eax,%edx
  101389:	ec                   	in     (%dx),%al
  10138a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10138d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101391:	0f b6 c0             	movzbl %al,%eax
  101394:	83 e0 01             	and    $0x1,%eax
  101397:	85 c0                	test   %eax,%eax
  101399:	75 07                	jne    1013a2 <serial_proc_data+0x2b>
        return -1;
  10139b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013a0:	eb 2a                	jmp    1013cc <serial_proc_data+0x55>
  1013a2:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013a8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013ac:	89 c2                	mov    %eax,%edx
  1013ae:	ec                   	in     (%dx),%al
  1013af:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013b2:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013b6:	0f b6 c0             	movzbl %al,%eax
  1013b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013bc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013c0:	75 07                	jne    1013c9 <serial_proc_data+0x52>
        c = '\b';
  1013c2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013cc:	c9                   	leave  
  1013cd:	c3                   	ret    

001013ce <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ce:	55                   	push   %ebp
  1013cf:	89 e5                	mov    %esp,%ebp
  1013d1:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  1013d4:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013d9:	85 c0                	test   %eax,%eax
  1013db:	74 10                	je     1013ed <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1013dd:	83 ec 0c             	sub    $0xc,%esp
  1013e0:	68 77 13 10 00       	push   $0x101377
  1013e5:	e8 41 ff ff ff       	call   10132b <cons_intr>
  1013ea:	83 c4 10             	add    $0x10,%esp
    }
}
  1013ed:	90                   	nop
  1013ee:	c9                   	leave  
  1013ef:	c3                   	ret    

001013f0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013f0:	55                   	push   %ebp
  1013f1:	89 e5                	mov    %esp,%ebp
  1013f3:	83 ec 18             	sub    $0x18,%esp
  1013f6:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013fc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101400:	89 c2                	mov    %eax,%edx
  101402:	ec                   	in     (%dx),%al
  101403:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101406:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10140a:	0f b6 c0             	movzbl %al,%eax
  10140d:	83 e0 01             	and    $0x1,%eax
  101410:	85 c0                	test   %eax,%eax
  101412:	75 0a                	jne    10141e <kbd_proc_data+0x2e>
        return -1;
  101414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101419:	e9 5d 01 00 00       	jmp    10157b <kbd_proc_data+0x18b>
  10141e:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101424:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101428:	89 c2                	mov    %eax,%edx
  10142a:	ec                   	in     (%dx),%al
  10142b:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  10142e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  101432:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101435:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101439:	75 17                	jne    101452 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10143b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101440:	83 c8 40             	or     $0x40,%eax
  101443:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101448:	b8 00 00 00 00       	mov    $0x0,%eax
  10144d:	e9 29 01 00 00       	jmp    10157b <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  101452:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101456:	84 c0                	test   %al,%al
  101458:	79 47                	jns    1014a1 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10145a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10145f:	83 e0 40             	and    $0x40,%eax
  101462:	85 c0                	test   %eax,%eax
  101464:	75 09                	jne    10146f <kbd_proc_data+0x7f>
  101466:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146a:	83 e0 7f             	and    $0x7f,%eax
  10146d:	eb 04                	jmp    101473 <kbd_proc_data+0x83>
  10146f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101473:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101476:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147a:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101481:	83 c8 40             	or     $0x40,%eax
  101484:	0f b6 c0             	movzbl %al,%eax
  101487:	f7 d0                	not    %eax
  101489:	89 c2                	mov    %eax,%edx
  10148b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101490:	21 d0                	and    %edx,%eax
  101492:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101497:	b8 00 00 00 00       	mov    $0x0,%eax
  10149c:	e9 da 00 00 00       	jmp    10157b <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  1014a1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014a6:	83 e0 40             	and    $0x40,%eax
  1014a9:	85 c0                	test   %eax,%eax
  1014ab:	74 11                	je     1014be <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014ad:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	83 e0 bf             	and    $0xffffffbf,%eax
  1014b9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c2:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014c9:	0f b6 d0             	movzbl %al,%edx
  1014cc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d1:	09 d0                	or     %edx,%eax
  1014d3:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014d8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014dc:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014e3:	0f b6 d0             	movzbl %al,%edx
  1014e6:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014eb:	31 d0                	xor    %edx,%eax
  1014ed:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	83 e0 03             	and    $0x3,%eax
  1014fa:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	01 d0                	add    %edx,%eax
  101507:	0f b6 00             	movzbl (%eax),%eax
  10150a:	0f b6 c0             	movzbl %al,%eax
  10150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101510:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101515:	83 e0 08             	and    $0x8,%eax
  101518:	85 c0                	test   %eax,%eax
  10151a:	74 22                	je     10153e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10151c:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101520:	7e 0c                	jle    10152e <kbd_proc_data+0x13e>
  101522:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101526:	7f 06                	jg     10152e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101528:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10152c:	eb 10                	jmp    10153e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10152e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101532:	7e 0a                	jle    10153e <kbd_proc_data+0x14e>
  101534:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101538:	7f 04                	jg     10153e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10153a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10153e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101543:	f7 d0                	not    %eax
  101545:	83 e0 06             	and    $0x6,%eax
  101548:	85 c0                	test   %eax,%eax
  10154a:	75 2c                	jne    101578 <kbd_proc_data+0x188>
  10154c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101553:	75 23                	jne    101578 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101555:	83 ec 0c             	sub    $0xc,%esp
  101558:	68 9d 5d 10 00       	push   $0x105d9d
  10155d:	e8 05 ed ff ff       	call   100267 <cprintf>
  101562:	83 c4 10             	add    $0x10,%esp
  101565:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  10156b:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10156f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101573:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101577:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101578:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10157b:	c9                   	leave  
  10157c:	c3                   	ret    

0010157d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10157d:	55                   	push   %ebp
  10157e:	89 e5                	mov    %esp,%ebp
  101580:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  101583:	83 ec 0c             	sub    $0xc,%esp
  101586:	68 f0 13 10 00       	push   $0x1013f0
  10158b:	e8 9b fd ff ff       	call   10132b <cons_intr>
  101590:	83 c4 10             	add    $0x10,%esp
}
  101593:	90                   	nop
  101594:	c9                   	leave  
  101595:	c3                   	ret    

00101596 <kbd_init>:

static void
kbd_init(void) {
  101596:	55                   	push   %ebp
  101597:	89 e5                	mov    %esp,%ebp
  101599:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  10159c:	e8 dc ff ff ff       	call   10157d <kbd_intr>
    pic_enable(IRQ_KBD);
  1015a1:	83 ec 0c             	sub    $0xc,%esp
  1015a4:	6a 01                	push   $0x1
  1015a6:	e8 4b 01 00 00       	call   1016f6 <pic_enable>
  1015ab:	83 c4 10             	add    $0x10,%esp
}
  1015ae:	90                   	nop
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  1015b7:	e8 8c f8 ff ff       	call   100e48 <cga_init>
    serial_init();
  1015bc:	e8 6e f9 ff ff       	call   100f2f <serial_init>
    kbd_init();
  1015c1:	e8 d0 ff ff ff       	call   101596 <kbd_init>
    if (!serial_exists) {
  1015c6:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015cb:	85 c0                	test   %eax,%eax
  1015cd:	75 10                	jne    1015df <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1015cf:	83 ec 0c             	sub    $0xc,%esp
  1015d2:	68 a9 5d 10 00       	push   $0x105da9
  1015d7:	e8 8b ec ff ff       	call   100267 <cprintf>
  1015dc:	83 c4 10             	add    $0x10,%esp
    }
}
  1015df:	90                   	nop
  1015e0:	c9                   	leave  
  1015e1:	c3                   	ret    

001015e2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015e2:	55                   	push   %ebp
  1015e3:	89 e5                	mov    %esp,%ebp
  1015e5:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015e8:	e8 d4 f7 ff ff       	call   100dc1 <__intr_save>
  1015ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015f0:	83 ec 0c             	sub    $0xc,%esp
  1015f3:	ff 75 08             	pushl  0x8(%ebp)
  1015f6:	e8 93 fa ff ff       	call   10108e <lpt_putc>
  1015fb:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
  1015fe:	83 ec 0c             	sub    $0xc,%esp
  101601:	ff 75 08             	pushl  0x8(%ebp)
  101604:	e8 bc fa ff ff       	call   1010c5 <cga_putc>
  101609:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
  10160c:	83 ec 0c             	sub    $0xc,%esp
  10160f:	ff 75 08             	pushl  0x8(%ebp)
  101612:	e8 dd fc ff ff       	call   1012f4 <serial_putc>
  101617:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  10161a:	83 ec 0c             	sub    $0xc,%esp
  10161d:	ff 75 f4             	pushl  -0xc(%ebp)
  101620:	e8 c6 f7 ff ff       	call   100deb <__intr_restore>
  101625:	83 c4 10             	add    $0x10,%esp
}
  101628:	90                   	nop
  101629:	c9                   	leave  
  10162a:	c3                   	ret    

0010162b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10162b:	55                   	push   %ebp
  10162c:	89 e5                	mov    %esp,%ebp
  10162e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
  101631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101638:	e8 84 f7 ff ff       	call   100dc1 <__intr_save>
  10163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101640:	e8 89 fd ff ff       	call   1013ce <serial_intr>
        kbd_intr();
  101645:	e8 33 ff ff ff       	call   10157d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10164a:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101650:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101655:	39 c2                	cmp    %eax,%edx
  101657:	74 31                	je     10168a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101659:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10165e:	8d 50 01             	lea    0x1(%eax),%edx
  101661:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101667:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10166e:	0f b6 c0             	movzbl %al,%eax
  101671:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101674:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101679:	3d 00 02 00 00       	cmp    $0x200,%eax
  10167e:	75 0a                	jne    10168a <cons_getc+0x5f>
                cons.rpos = 0;
  101680:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101687:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10168a:	83 ec 0c             	sub    $0xc,%esp
  10168d:	ff 75 f0             	pushl  -0x10(%ebp)
  101690:	e8 56 f7 ff ff       	call   100deb <__intr_restore>
  101695:	83 c4 10             	add    $0x10,%esp
    return c;
  101698:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10169b:	c9                   	leave  
  10169c:	c3                   	ret    

0010169d <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10169d:	55                   	push   %ebp
  10169e:	89 e5                	mov    %esp,%ebp
  1016a0:	83 ec 14             	sub    $0x14,%esp
  1016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016aa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ae:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016b4:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016b9:	85 c0                	test   %eax,%eax
  1016bb:	74 36                	je     1016f3 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c1:	0f b6 c0             	movzbl %al,%eax
  1016c4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016ca:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016cd:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016d1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016da:	66 c1 e8 08          	shr    $0x8,%ax
  1016de:	0f b6 c0             	movzbl %al,%eax
  1016e1:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016e7:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016ea:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016ee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
    }
}
  1016f3:	90                   	nop
  1016f4:	c9                   	leave  
  1016f5:	c3                   	ret    

001016f6 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016f6:	55                   	push   %ebp
  1016f7:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  1016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fc:	ba 01 00 00 00       	mov    $0x1,%edx
  101701:	89 c1                	mov    %eax,%ecx
  101703:	d3 e2                	shl    %cl,%edx
  101705:	89 d0                	mov    %edx,%eax
  101707:	f7 d0                	not    %eax
  101709:	89 c2                	mov    %eax,%edx
  10170b:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101712:	21 d0                	and    %edx,%eax
  101714:	0f b7 c0             	movzwl %ax,%eax
  101717:	50                   	push   %eax
  101718:	e8 80 ff ff ff       	call   10169d <pic_setmask>
  10171d:	83 c4 04             	add    $0x4,%esp
}
  101720:	90                   	nop
  101721:	c9                   	leave  
  101722:	c3                   	ret    

00101723 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101723:	55                   	push   %ebp
  101724:	89 e5                	mov    %esp,%ebp
  101726:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101729:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101730:	00 00 00 
  101733:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101739:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10173d:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  101741:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  10174c:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  101750:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101754:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10175f:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  101763:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101767:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  101772:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101776:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10177a:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  101785:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101789:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  10178d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101798:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  10179c:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1017a0:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  1017ab:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  1017af:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  1017b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017be:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017c2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017c6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
  1017cb:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017d1:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017d5:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017d9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017dd:	ee                   	out    %al,(%dx)
  1017de:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017e4:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017e8:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017ec:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
  1017f1:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017f7:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1017fb:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1017ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101803:	ee                   	out    %al,(%dx)
  101804:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  10180a:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10180e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101812:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101816:	ee                   	out    %al,(%dx)
  101817:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10181d:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101821:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101825:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101829:	ee                   	out    %al,(%dx)
  10182a:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101830:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  101834:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101838:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  10183c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10183d:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101844:	66 83 f8 ff          	cmp    $0xffff,%ax
  101848:	74 13                	je     10185d <pic_init+0x13a>
        pic_setmask(irq_mask);
  10184a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101851:	0f b7 c0             	movzwl %ax,%eax
  101854:	50                   	push   %eax
  101855:	e8 43 fe ff ff       	call   10169d <pic_setmask>
  10185a:	83 c4 04             	add    $0x4,%esp
    }
}
  10185d:	90                   	nop
  10185e:	c9                   	leave  
  10185f:	c3                   	ret    

00101860 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101860:	55                   	push   %ebp
  101861:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101863:	fb                   	sti    
    sti();
}
  101864:	90                   	nop
  101865:	5d                   	pop    %ebp
  101866:	c3                   	ret    

00101867 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101867:	55                   	push   %ebp
  101868:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  10186a:	fa                   	cli    
    cli();
}
  10186b:	90                   	nop
  10186c:	5d                   	pop    %ebp
  10186d:	c3                   	ret    

0010186e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10186e:	55                   	push   %ebp
  10186f:	89 e5                	mov    %esp,%ebp
  101871:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101874:	83 ec 08             	sub    $0x8,%esp
  101877:	6a 64                	push   $0x64
  101879:	68 e0 5d 10 00       	push   $0x105de0
  10187e:	e8 e4 e9 ff ff       	call   100267 <cprintf>
  101883:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101886:	90                   	nop
  101887:	c9                   	leave  
  101888:	c3                   	ret    

00101889 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101889:	55                   	push   %ebp
  10188a:	89 e5                	mov    %esp,%ebp
  10188c:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10188f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101896:	e9 c3 00 00 00       	jmp    10195e <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10189b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189e:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a5:	89 c2                	mov    %eax,%edx
  1018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018aa:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b1:	00 
  1018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b5:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018bc:	00 08 00 
  1018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c2:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018c9:	00 
  1018ca:	83 e2 e0             	and    $0xffffffe0,%edx
  1018cd:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018de:	00 
  1018df:	83 e2 1f             	and    $0x1f,%edx
  1018e2:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ec:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f3:	00 
  1018f4:	83 e2 f0             	and    $0xfffffff0,%edx
  1018f7:	83 ca 0e             	or     $0xe,%edx
  1018fa:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101904:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190b:	00 
  10190c:	83 e2 ef             	and    $0xffffffef,%edx
  10190f:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101919:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101920:	00 
  101921:	83 e2 9f             	and    $0xffffff9f,%edx
  101924:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101935:	00 
  101936:	83 ca 80             	or     $0xffffff80,%edx
  101939:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101943:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10194a:	c1 e8 10             	shr    $0x10,%eax
  10194d:	89 c2                	mov    %eax,%edx
  10194f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101952:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101959:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10195a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	3d ff 00 00 00       	cmp    $0xff,%eax
  101966:	0f 86 2f ff ff ff    	jbe    10189b <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10196c:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101971:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101977:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  10197e:	08 00 
  101980:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101987:	83 e0 e0             	and    $0xffffffe0,%eax
  10198a:	a2 8c 84 11 00       	mov    %al,0x11848c
  10198f:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101996:	83 e0 1f             	and    $0x1f,%eax
  101999:	a2 8c 84 11 00       	mov    %al,0x11848c
  10199e:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019a5:	83 e0 f0             	and    $0xfffffff0,%eax
  1019a8:	83 c8 0e             	or     $0xe,%eax
  1019ab:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019b0:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b7:	83 e0 ef             	and    $0xffffffef,%eax
  1019ba:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019bf:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c6:	83 c8 60             	or     $0x60,%eax
  1019c9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ce:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d5:	83 c8 80             	or     $0xffffff80,%eax
  1019d8:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019dd:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019e2:	c1 e8 10             	shr    $0x10,%eax
  1019e5:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019eb:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f5:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  1019f8:	90                   	nop
  1019f9:	c9                   	leave  
  1019fa:	c3                   	ret    

001019fb <trapname>:

static const char *
trapname(int trapno) {
  1019fb:	55                   	push   %ebp
  1019fc:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101a01:	83 f8 13             	cmp    $0x13,%eax
  101a04:	77 0c                	ja     101a12 <trapname+0x17>
        return excnames[trapno];
  101a06:	8b 45 08             	mov    0x8(%ebp),%eax
  101a09:	8b 04 85 40 61 10 00 	mov    0x106140(,%eax,4),%eax
  101a10:	eb 18                	jmp    101a2a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a12:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a16:	7e 0d                	jle    101a25 <trapname+0x2a>
  101a18:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1c:	7f 07                	jg     101a25 <trapname+0x2a>
        return "Hardware Interrupt";
  101a1e:	b8 ea 5d 10 00       	mov    $0x105dea,%eax
  101a23:	eb 05                	jmp    101a2a <trapname+0x2f>
    }
    return "(unknown trap)";
  101a25:	b8 fd 5d 10 00       	mov    $0x105dfd,%eax
}
  101a2a:	5d                   	pop    %ebp
  101a2b:	c3                   	ret    

00101a2c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2c:	55                   	push   %ebp
  101a2d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a32:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a36:	66 83 f8 08          	cmp    $0x8,%ax
  101a3a:	0f 94 c0             	sete   %al
  101a3d:	0f b6 c0             	movzbl %al,%eax
}
  101a40:	5d                   	pop    %ebp
  101a41:	c3                   	ret    

00101a42 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a42:	55                   	push   %ebp
  101a43:	89 e5                	mov    %esp,%ebp
  101a45:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a48:	83 ec 08             	sub    $0x8,%esp
  101a4b:	ff 75 08             	pushl  0x8(%ebp)
  101a4e:	68 3e 5e 10 00       	push   $0x105e3e
  101a53:	e8 0f e8 ff ff       	call   100267 <cprintf>
  101a58:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5e:	83 ec 0c             	sub    $0xc,%esp
  101a61:	50                   	push   %eax
  101a62:	e8 b8 01 00 00       	call   101c1f <print_regs>
  101a67:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a71:	0f b7 c0             	movzwl %ax,%eax
  101a74:	83 ec 08             	sub    $0x8,%esp
  101a77:	50                   	push   %eax
  101a78:	68 4f 5e 10 00       	push   $0x105e4f
  101a7d:	e8 e5 e7 ff ff       	call   100267 <cprintf>
  101a82:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a8c:	0f b7 c0             	movzwl %ax,%eax
  101a8f:	83 ec 08             	sub    $0x8,%esp
  101a92:	50                   	push   %eax
  101a93:	68 62 5e 10 00       	push   $0x105e62
  101a98:	e8 ca e7 ff ff       	call   100267 <cprintf>
  101a9d:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa7:	0f b7 c0             	movzwl %ax,%eax
  101aaa:	83 ec 08             	sub    $0x8,%esp
  101aad:	50                   	push   %eax
  101aae:	68 75 5e 10 00       	push   $0x105e75
  101ab3:	e8 af e7 ff ff       	call   100267 <cprintf>
  101ab8:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101abb:	8b 45 08             	mov    0x8(%ebp),%eax
  101abe:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac2:	0f b7 c0             	movzwl %ax,%eax
  101ac5:	83 ec 08             	sub    $0x8,%esp
  101ac8:	50                   	push   %eax
  101ac9:	68 88 5e 10 00       	push   $0x105e88
  101ace:	e8 94 e7 ff ff       	call   100267 <cprintf>
  101ad3:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad9:	8b 40 30             	mov    0x30(%eax),%eax
  101adc:	83 ec 0c             	sub    $0xc,%esp
  101adf:	50                   	push   %eax
  101ae0:	e8 16 ff ff ff       	call   1019fb <trapname>
  101ae5:	83 c4 10             	add    $0x10,%esp
  101ae8:	89 c2                	mov    %eax,%edx
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	8b 40 30             	mov    0x30(%eax),%eax
  101af0:	83 ec 04             	sub    $0x4,%esp
  101af3:	52                   	push   %edx
  101af4:	50                   	push   %eax
  101af5:	68 9b 5e 10 00       	push   $0x105e9b
  101afa:	e8 68 e7 ff ff       	call   100267 <cprintf>
  101aff:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b02:	8b 45 08             	mov    0x8(%ebp),%eax
  101b05:	8b 40 34             	mov    0x34(%eax),%eax
  101b08:	83 ec 08             	sub    $0x8,%esp
  101b0b:	50                   	push   %eax
  101b0c:	68 ad 5e 10 00       	push   $0x105ead
  101b11:	e8 51 e7 ff ff       	call   100267 <cprintf>
  101b16:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	8b 40 38             	mov    0x38(%eax),%eax
  101b1f:	83 ec 08             	sub    $0x8,%esp
  101b22:	50                   	push   %eax
  101b23:	68 bc 5e 10 00       	push   $0x105ebc
  101b28:	e8 3a e7 ff ff       	call   100267 <cprintf>
  101b2d:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b30:	8b 45 08             	mov    0x8(%ebp),%eax
  101b33:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b37:	0f b7 c0             	movzwl %ax,%eax
  101b3a:	83 ec 08             	sub    $0x8,%esp
  101b3d:	50                   	push   %eax
  101b3e:	68 cb 5e 10 00       	push   $0x105ecb
  101b43:	e8 1f e7 ff ff       	call   100267 <cprintf>
  101b48:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4e:	8b 40 40             	mov    0x40(%eax),%eax
  101b51:	83 ec 08             	sub    $0x8,%esp
  101b54:	50                   	push   %eax
  101b55:	68 de 5e 10 00       	push   $0x105ede
  101b5a:	e8 08 e7 ff ff       	call   100267 <cprintf>
  101b5f:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b69:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b70:	eb 3f                	jmp    101bb1 <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 50 40             	mov    0x40(%eax),%edx
  101b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b7b:	21 d0                	and    %edx,%eax
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	74 29                	je     101baa <print_trapframe+0x168>
  101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b84:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8b:	85 c0                	test   %eax,%eax
  101b8d:	74 1b                	je     101baa <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b92:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b99:	83 ec 08             	sub    $0x8,%esp
  101b9c:	50                   	push   %eax
  101b9d:	68 ed 5e 10 00       	push   $0x105eed
  101ba2:	e8 c0 e6 ff ff       	call   100267 <cprintf>
  101ba7:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101baa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bae:	d1 65 f0             	shll   -0x10(%ebp)
  101bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb4:	83 f8 17             	cmp    $0x17,%eax
  101bb7:	76 b9                	jbe    101b72 <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbc:	8b 40 40             	mov    0x40(%eax),%eax
  101bbf:	25 00 30 00 00       	and    $0x3000,%eax
  101bc4:	c1 e8 0c             	shr    $0xc,%eax
  101bc7:	83 ec 08             	sub    $0x8,%esp
  101bca:	50                   	push   %eax
  101bcb:	68 f1 5e 10 00       	push   $0x105ef1
  101bd0:	e8 92 e6 ff ff       	call   100267 <cprintf>
  101bd5:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bd8:	83 ec 0c             	sub    $0xc,%esp
  101bdb:	ff 75 08             	pushl  0x8(%ebp)
  101bde:	e8 49 fe ff ff       	call   101a2c <trap_in_kernel>
  101be3:	83 c4 10             	add    $0x10,%esp
  101be6:	85 c0                	test   %eax,%eax
  101be8:	75 32                	jne    101c1c <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 40 44             	mov    0x44(%eax),%eax
  101bf0:	83 ec 08             	sub    $0x8,%esp
  101bf3:	50                   	push   %eax
  101bf4:	68 fa 5e 10 00       	push   $0x105efa
  101bf9:	e8 69 e6 ff ff       	call   100267 <cprintf>
  101bfe:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c08:	0f b7 c0             	movzwl %ax,%eax
  101c0b:	83 ec 08             	sub    $0x8,%esp
  101c0e:	50                   	push   %eax
  101c0f:	68 09 5f 10 00       	push   $0x105f09
  101c14:	e8 4e e6 ff ff       	call   100267 <cprintf>
  101c19:	83 c4 10             	add    $0x10,%esp
    }
}
  101c1c:	90                   	nop
  101c1d:	c9                   	leave  
  101c1e:	c3                   	ret    

00101c1f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c1f:	55                   	push   %ebp
  101c20:	89 e5                	mov    %esp,%ebp
  101c22:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c25:	8b 45 08             	mov    0x8(%ebp),%eax
  101c28:	8b 00                	mov    (%eax),%eax
  101c2a:	83 ec 08             	sub    $0x8,%esp
  101c2d:	50                   	push   %eax
  101c2e:	68 1c 5f 10 00       	push   $0x105f1c
  101c33:	e8 2f e6 ff ff       	call   100267 <cprintf>
  101c38:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 40 04             	mov    0x4(%eax),%eax
  101c41:	83 ec 08             	sub    $0x8,%esp
  101c44:	50                   	push   %eax
  101c45:	68 2b 5f 10 00       	push   $0x105f2b
  101c4a:	e8 18 e6 ff ff       	call   100267 <cprintf>
  101c4f:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c52:	8b 45 08             	mov    0x8(%ebp),%eax
  101c55:	8b 40 08             	mov    0x8(%eax),%eax
  101c58:	83 ec 08             	sub    $0x8,%esp
  101c5b:	50                   	push   %eax
  101c5c:	68 3a 5f 10 00       	push   $0x105f3a
  101c61:	e8 01 e6 ff ff       	call   100267 <cprintf>
  101c66:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c69:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  101c6f:	83 ec 08             	sub    $0x8,%esp
  101c72:	50                   	push   %eax
  101c73:	68 49 5f 10 00       	push   $0x105f49
  101c78:	e8 ea e5 ff ff       	call   100267 <cprintf>
  101c7d:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c80:	8b 45 08             	mov    0x8(%ebp),%eax
  101c83:	8b 40 10             	mov    0x10(%eax),%eax
  101c86:	83 ec 08             	sub    $0x8,%esp
  101c89:	50                   	push   %eax
  101c8a:	68 58 5f 10 00       	push   $0x105f58
  101c8f:	e8 d3 e5 ff ff       	call   100267 <cprintf>
  101c94:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c97:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9a:	8b 40 14             	mov    0x14(%eax),%eax
  101c9d:	83 ec 08             	sub    $0x8,%esp
  101ca0:	50                   	push   %eax
  101ca1:	68 67 5f 10 00       	push   $0x105f67
  101ca6:	e8 bc e5 ff ff       	call   100267 <cprintf>
  101cab:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cae:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb1:	8b 40 18             	mov    0x18(%eax),%eax
  101cb4:	83 ec 08             	sub    $0x8,%esp
  101cb7:	50                   	push   %eax
  101cb8:	68 76 5f 10 00       	push   $0x105f76
  101cbd:	e8 a5 e5 ff ff       	call   100267 <cprintf>
  101cc2:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ccb:	83 ec 08             	sub    $0x8,%esp
  101cce:	50                   	push   %eax
  101ccf:	68 85 5f 10 00       	push   $0x105f85
  101cd4:	e8 8e e5 ff ff       	call   100267 <cprintf>
  101cd9:	83 c4 10             	add    $0x10,%esp
}
  101cdc:	90                   	nop
  101cdd:	c9                   	leave  
  101cde:	c3                   	ret    

00101cdf <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cdf:	55                   	push   %ebp
  101ce0:	89 e5                	mov    %esp,%ebp
  101ce2:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce8:	8b 40 30             	mov    0x30(%eax),%eax
  101ceb:	83 f8 2f             	cmp    $0x2f,%eax
  101cee:	77 1d                	ja     101d0d <trap_dispatch+0x2e>
  101cf0:	83 f8 2e             	cmp    $0x2e,%eax
  101cf3:	0f 83 f4 00 00 00    	jae    101ded <trap_dispatch+0x10e>
  101cf9:	83 f8 21             	cmp    $0x21,%eax
  101cfc:	74 7e                	je     101d7c <trap_dispatch+0x9d>
  101cfe:	83 f8 24             	cmp    $0x24,%eax
  101d01:	74 55                	je     101d58 <trap_dispatch+0x79>
  101d03:	83 f8 20             	cmp    $0x20,%eax
  101d06:	74 16                	je     101d1e <trap_dispatch+0x3f>
  101d08:	e9 aa 00 00 00       	jmp    101db7 <trap_dispatch+0xd8>
  101d0d:	83 e8 78             	sub    $0x78,%eax
  101d10:	83 f8 01             	cmp    $0x1,%eax
  101d13:	0f 87 9e 00 00 00    	ja     101db7 <trap_dispatch+0xd8>
  101d19:	e9 82 00 00 00       	jmp    101da0 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks ++;
  101d1e:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d23:	83 c0 01             	add    $0x1,%eax
  101d26:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d2b:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d31:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d36:	89 c8                	mov    %ecx,%eax
  101d38:	f7 e2                	mul    %edx
  101d3a:	89 d0                	mov    %edx,%eax
  101d3c:	c1 e8 05             	shr    $0x5,%eax
  101d3f:	6b c0 64             	imul   $0x64,%eax,%eax
  101d42:	29 c1                	sub    %eax,%ecx
  101d44:	89 c8                	mov    %ecx,%eax
  101d46:	85 c0                	test   %eax,%eax
  101d48:	0f 85 a2 00 00 00    	jne    101df0 <trap_dispatch+0x111>
            print_ticks();
  101d4e:	e8 1b fb ff ff       	call   10186e <print_ticks>
        }
        break;
  101d53:	e9 98 00 00 00       	jmp    101df0 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d58:	e8 ce f8 ff ff       	call   10162b <cons_getc>
  101d5d:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d60:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d64:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d68:	83 ec 04             	sub    $0x4,%esp
  101d6b:	52                   	push   %edx
  101d6c:	50                   	push   %eax
  101d6d:	68 94 5f 10 00       	push   $0x105f94
  101d72:	e8 f0 e4 ff ff       	call   100267 <cprintf>
  101d77:	83 c4 10             	add    $0x10,%esp
        break;
  101d7a:	eb 75                	jmp    101df1 <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d7c:	e8 aa f8 ff ff       	call   10162b <cons_getc>
  101d81:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d84:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d88:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d8c:	83 ec 04             	sub    $0x4,%esp
  101d8f:	52                   	push   %edx
  101d90:	50                   	push   %eax
  101d91:	68 a6 5f 10 00       	push   $0x105fa6
  101d96:	e8 cc e4 ff ff       	call   100267 <cprintf>
  101d9b:	83 c4 10             	add    $0x10,%esp
        break;
  101d9e:	eb 51                	jmp    101df1 <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101da0:	83 ec 04             	sub    $0x4,%esp
  101da3:	68 b5 5f 10 00       	push   $0x105fb5
  101da8:	68 b0 00 00 00       	push   $0xb0
  101dad:	68 c5 5f 10 00       	push   $0x105fc5
  101db2:	e8 16 e6 ff ff       	call   1003cd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dbe:	0f b7 c0             	movzwl %ax,%eax
  101dc1:	83 e0 03             	and    $0x3,%eax
  101dc4:	85 c0                	test   %eax,%eax
  101dc6:	75 29                	jne    101df1 <trap_dispatch+0x112>
            print_trapframe(tf);
  101dc8:	83 ec 0c             	sub    $0xc,%esp
  101dcb:	ff 75 08             	pushl  0x8(%ebp)
  101dce:	e8 6f fc ff ff       	call   101a42 <print_trapframe>
  101dd3:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101dd6:	83 ec 04             	sub    $0x4,%esp
  101dd9:	68 d6 5f 10 00       	push   $0x105fd6
  101dde:	68 ba 00 00 00       	push   $0xba
  101de3:	68 c5 5f 10 00       	push   $0x105fc5
  101de8:	e8 e0 e5 ff ff       	call   1003cd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ded:	90                   	nop
  101dee:	eb 01                	jmp    101df1 <trap_dispatch+0x112>
         */
	ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  101df0:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101df1:	90                   	nop
  101df2:	c9                   	leave  
  101df3:	c3                   	ret    

00101df4 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101df4:	55                   	push   %ebp
  101df5:	89 e5                	mov    %esp,%ebp
  101df7:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dfa:	83 ec 0c             	sub    $0xc,%esp
  101dfd:	ff 75 08             	pushl  0x8(%ebp)
  101e00:	e8 da fe ff ff       	call   101cdf <trap_dispatch>
  101e05:	83 c4 10             	add    $0x10,%esp
}
  101e08:	90                   	nop
  101e09:	c9                   	leave  
  101e0a:	c3                   	ret    

00101e0b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $0
  101e0d:	6a 00                	push   $0x0
  jmp __alltraps
  101e0f:	e9 67 0a 00 00       	jmp    10287b <__alltraps>

00101e14 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $1
  101e16:	6a 01                	push   $0x1
  jmp __alltraps
  101e18:	e9 5e 0a 00 00       	jmp    10287b <__alltraps>

00101e1d <vector2>:
.globl vector2
vector2:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $2
  101e1f:	6a 02                	push   $0x2
  jmp __alltraps
  101e21:	e9 55 0a 00 00       	jmp    10287b <__alltraps>

00101e26 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $3
  101e28:	6a 03                	push   $0x3
  jmp __alltraps
  101e2a:	e9 4c 0a 00 00       	jmp    10287b <__alltraps>

00101e2f <vector4>:
.globl vector4
vector4:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $4
  101e31:	6a 04                	push   $0x4
  jmp __alltraps
  101e33:	e9 43 0a 00 00       	jmp    10287b <__alltraps>

00101e38 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $5
  101e3a:	6a 05                	push   $0x5
  jmp __alltraps
  101e3c:	e9 3a 0a 00 00       	jmp    10287b <__alltraps>

00101e41 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $6
  101e43:	6a 06                	push   $0x6
  jmp __alltraps
  101e45:	e9 31 0a 00 00       	jmp    10287b <__alltraps>

00101e4a <vector7>:
.globl vector7
vector7:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $7
  101e4c:	6a 07                	push   $0x7
  jmp __alltraps
  101e4e:	e9 28 0a 00 00       	jmp    10287b <__alltraps>

00101e53 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e53:	6a 08                	push   $0x8
  jmp __alltraps
  101e55:	e9 21 0a 00 00       	jmp    10287b <__alltraps>

00101e5a <vector9>:
.globl vector9
vector9:
  pushl $9
  101e5a:	6a 09                	push   $0x9
  jmp __alltraps
  101e5c:	e9 1a 0a 00 00       	jmp    10287b <__alltraps>

00101e61 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e61:	6a 0a                	push   $0xa
  jmp __alltraps
  101e63:	e9 13 0a 00 00       	jmp    10287b <__alltraps>

00101e68 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e68:	6a 0b                	push   $0xb
  jmp __alltraps
  101e6a:	e9 0c 0a 00 00       	jmp    10287b <__alltraps>

00101e6f <vector12>:
.globl vector12
vector12:
  pushl $12
  101e6f:	6a 0c                	push   $0xc
  jmp __alltraps
  101e71:	e9 05 0a 00 00       	jmp    10287b <__alltraps>

00101e76 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e76:	6a 0d                	push   $0xd
  jmp __alltraps
  101e78:	e9 fe 09 00 00       	jmp    10287b <__alltraps>

00101e7d <vector14>:
.globl vector14
vector14:
  pushl $14
  101e7d:	6a 0e                	push   $0xe
  jmp __alltraps
  101e7f:	e9 f7 09 00 00       	jmp    10287b <__alltraps>

00101e84 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $15
  101e86:	6a 0f                	push   $0xf
  jmp __alltraps
  101e88:	e9 ee 09 00 00       	jmp    10287b <__alltraps>

00101e8d <vector16>:
.globl vector16
vector16:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $16
  101e8f:	6a 10                	push   $0x10
  jmp __alltraps
  101e91:	e9 e5 09 00 00       	jmp    10287b <__alltraps>

00101e96 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e96:	6a 11                	push   $0x11
  jmp __alltraps
  101e98:	e9 de 09 00 00       	jmp    10287b <__alltraps>

00101e9d <vector18>:
.globl vector18
vector18:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $18
  101e9f:	6a 12                	push   $0x12
  jmp __alltraps
  101ea1:	e9 d5 09 00 00       	jmp    10287b <__alltraps>

00101ea6 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $19
  101ea8:	6a 13                	push   $0x13
  jmp __alltraps
  101eaa:	e9 cc 09 00 00       	jmp    10287b <__alltraps>

00101eaf <vector20>:
.globl vector20
vector20:
  pushl $0
  101eaf:	6a 00                	push   $0x0
  pushl $20
  101eb1:	6a 14                	push   $0x14
  jmp __alltraps
  101eb3:	e9 c3 09 00 00       	jmp    10287b <__alltraps>

00101eb8 <vector21>:
.globl vector21
vector21:
  pushl $0
  101eb8:	6a 00                	push   $0x0
  pushl $21
  101eba:	6a 15                	push   $0x15
  jmp __alltraps
  101ebc:	e9 ba 09 00 00       	jmp    10287b <__alltraps>

00101ec1 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $22
  101ec3:	6a 16                	push   $0x16
  jmp __alltraps
  101ec5:	e9 b1 09 00 00       	jmp    10287b <__alltraps>

00101eca <vector23>:
.globl vector23
vector23:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $23
  101ecc:	6a 17                	push   $0x17
  jmp __alltraps
  101ece:	e9 a8 09 00 00       	jmp    10287b <__alltraps>

00101ed3 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $24
  101ed5:	6a 18                	push   $0x18
  jmp __alltraps
  101ed7:	e9 9f 09 00 00       	jmp    10287b <__alltraps>

00101edc <vector25>:
.globl vector25
vector25:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $25
  101ede:	6a 19                	push   $0x19
  jmp __alltraps
  101ee0:	e9 96 09 00 00       	jmp    10287b <__alltraps>

00101ee5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $26
  101ee7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ee9:	e9 8d 09 00 00       	jmp    10287b <__alltraps>

00101eee <vector27>:
.globl vector27
vector27:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $27
  101ef0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ef2:	e9 84 09 00 00       	jmp    10287b <__alltraps>

00101ef7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $28
  101ef9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101efb:	e9 7b 09 00 00       	jmp    10287b <__alltraps>

00101f00 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $29
  101f02:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f04:	e9 72 09 00 00       	jmp    10287b <__alltraps>

00101f09 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $30
  101f0b:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f0d:	e9 69 09 00 00       	jmp    10287b <__alltraps>

00101f12 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $31
  101f14:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f16:	e9 60 09 00 00       	jmp    10287b <__alltraps>

00101f1b <vector32>:
.globl vector32
vector32:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $32
  101f1d:	6a 20                	push   $0x20
  jmp __alltraps
  101f1f:	e9 57 09 00 00       	jmp    10287b <__alltraps>

00101f24 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $33
  101f26:	6a 21                	push   $0x21
  jmp __alltraps
  101f28:	e9 4e 09 00 00       	jmp    10287b <__alltraps>

00101f2d <vector34>:
.globl vector34
vector34:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $34
  101f2f:	6a 22                	push   $0x22
  jmp __alltraps
  101f31:	e9 45 09 00 00       	jmp    10287b <__alltraps>

00101f36 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $35
  101f38:	6a 23                	push   $0x23
  jmp __alltraps
  101f3a:	e9 3c 09 00 00       	jmp    10287b <__alltraps>

00101f3f <vector36>:
.globl vector36
vector36:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $36
  101f41:	6a 24                	push   $0x24
  jmp __alltraps
  101f43:	e9 33 09 00 00       	jmp    10287b <__alltraps>

00101f48 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $37
  101f4a:	6a 25                	push   $0x25
  jmp __alltraps
  101f4c:	e9 2a 09 00 00       	jmp    10287b <__alltraps>

00101f51 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $38
  101f53:	6a 26                	push   $0x26
  jmp __alltraps
  101f55:	e9 21 09 00 00       	jmp    10287b <__alltraps>

00101f5a <vector39>:
.globl vector39
vector39:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $39
  101f5c:	6a 27                	push   $0x27
  jmp __alltraps
  101f5e:	e9 18 09 00 00       	jmp    10287b <__alltraps>

00101f63 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $40
  101f65:	6a 28                	push   $0x28
  jmp __alltraps
  101f67:	e9 0f 09 00 00       	jmp    10287b <__alltraps>

00101f6c <vector41>:
.globl vector41
vector41:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $41
  101f6e:	6a 29                	push   $0x29
  jmp __alltraps
  101f70:	e9 06 09 00 00       	jmp    10287b <__alltraps>

00101f75 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $42
  101f77:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f79:	e9 fd 08 00 00       	jmp    10287b <__alltraps>

00101f7e <vector43>:
.globl vector43
vector43:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $43
  101f80:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f82:	e9 f4 08 00 00       	jmp    10287b <__alltraps>

00101f87 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $44
  101f89:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f8b:	e9 eb 08 00 00       	jmp    10287b <__alltraps>

00101f90 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $45
  101f92:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f94:	e9 e2 08 00 00       	jmp    10287b <__alltraps>

00101f99 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $46
  101f9b:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f9d:	e9 d9 08 00 00       	jmp    10287b <__alltraps>

00101fa2 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $47
  101fa4:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fa6:	e9 d0 08 00 00       	jmp    10287b <__alltraps>

00101fab <vector48>:
.globl vector48
vector48:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $48
  101fad:	6a 30                	push   $0x30
  jmp __alltraps
  101faf:	e9 c7 08 00 00       	jmp    10287b <__alltraps>

00101fb4 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $49
  101fb6:	6a 31                	push   $0x31
  jmp __alltraps
  101fb8:	e9 be 08 00 00       	jmp    10287b <__alltraps>

00101fbd <vector50>:
.globl vector50
vector50:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $50
  101fbf:	6a 32                	push   $0x32
  jmp __alltraps
  101fc1:	e9 b5 08 00 00       	jmp    10287b <__alltraps>

00101fc6 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $51
  101fc8:	6a 33                	push   $0x33
  jmp __alltraps
  101fca:	e9 ac 08 00 00       	jmp    10287b <__alltraps>

00101fcf <vector52>:
.globl vector52
vector52:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $52
  101fd1:	6a 34                	push   $0x34
  jmp __alltraps
  101fd3:	e9 a3 08 00 00       	jmp    10287b <__alltraps>

00101fd8 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $53
  101fda:	6a 35                	push   $0x35
  jmp __alltraps
  101fdc:	e9 9a 08 00 00       	jmp    10287b <__alltraps>

00101fe1 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $54
  101fe3:	6a 36                	push   $0x36
  jmp __alltraps
  101fe5:	e9 91 08 00 00       	jmp    10287b <__alltraps>

00101fea <vector55>:
.globl vector55
vector55:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $55
  101fec:	6a 37                	push   $0x37
  jmp __alltraps
  101fee:	e9 88 08 00 00       	jmp    10287b <__alltraps>

00101ff3 <vector56>:
.globl vector56
vector56:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $56
  101ff5:	6a 38                	push   $0x38
  jmp __alltraps
  101ff7:	e9 7f 08 00 00       	jmp    10287b <__alltraps>

00101ffc <vector57>:
.globl vector57
vector57:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $57
  101ffe:	6a 39                	push   $0x39
  jmp __alltraps
  102000:	e9 76 08 00 00       	jmp    10287b <__alltraps>

00102005 <vector58>:
.globl vector58
vector58:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $58
  102007:	6a 3a                	push   $0x3a
  jmp __alltraps
  102009:	e9 6d 08 00 00       	jmp    10287b <__alltraps>

0010200e <vector59>:
.globl vector59
vector59:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $59
  102010:	6a 3b                	push   $0x3b
  jmp __alltraps
  102012:	e9 64 08 00 00       	jmp    10287b <__alltraps>

00102017 <vector60>:
.globl vector60
vector60:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $60
  102019:	6a 3c                	push   $0x3c
  jmp __alltraps
  10201b:	e9 5b 08 00 00       	jmp    10287b <__alltraps>

00102020 <vector61>:
.globl vector61
vector61:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $61
  102022:	6a 3d                	push   $0x3d
  jmp __alltraps
  102024:	e9 52 08 00 00       	jmp    10287b <__alltraps>

00102029 <vector62>:
.globl vector62
vector62:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $62
  10202b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10202d:	e9 49 08 00 00       	jmp    10287b <__alltraps>

00102032 <vector63>:
.globl vector63
vector63:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $63
  102034:	6a 3f                	push   $0x3f
  jmp __alltraps
  102036:	e9 40 08 00 00       	jmp    10287b <__alltraps>

0010203b <vector64>:
.globl vector64
vector64:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $64
  10203d:	6a 40                	push   $0x40
  jmp __alltraps
  10203f:	e9 37 08 00 00       	jmp    10287b <__alltraps>

00102044 <vector65>:
.globl vector65
vector65:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $65
  102046:	6a 41                	push   $0x41
  jmp __alltraps
  102048:	e9 2e 08 00 00       	jmp    10287b <__alltraps>

0010204d <vector66>:
.globl vector66
vector66:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $66
  10204f:	6a 42                	push   $0x42
  jmp __alltraps
  102051:	e9 25 08 00 00       	jmp    10287b <__alltraps>

00102056 <vector67>:
.globl vector67
vector67:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $67
  102058:	6a 43                	push   $0x43
  jmp __alltraps
  10205a:	e9 1c 08 00 00       	jmp    10287b <__alltraps>

0010205f <vector68>:
.globl vector68
vector68:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $68
  102061:	6a 44                	push   $0x44
  jmp __alltraps
  102063:	e9 13 08 00 00       	jmp    10287b <__alltraps>

00102068 <vector69>:
.globl vector69
vector69:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $69
  10206a:	6a 45                	push   $0x45
  jmp __alltraps
  10206c:	e9 0a 08 00 00       	jmp    10287b <__alltraps>

00102071 <vector70>:
.globl vector70
vector70:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $70
  102073:	6a 46                	push   $0x46
  jmp __alltraps
  102075:	e9 01 08 00 00       	jmp    10287b <__alltraps>

0010207a <vector71>:
.globl vector71
vector71:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $71
  10207c:	6a 47                	push   $0x47
  jmp __alltraps
  10207e:	e9 f8 07 00 00       	jmp    10287b <__alltraps>

00102083 <vector72>:
.globl vector72
vector72:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $72
  102085:	6a 48                	push   $0x48
  jmp __alltraps
  102087:	e9 ef 07 00 00       	jmp    10287b <__alltraps>

0010208c <vector73>:
.globl vector73
vector73:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $73
  10208e:	6a 49                	push   $0x49
  jmp __alltraps
  102090:	e9 e6 07 00 00       	jmp    10287b <__alltraps>

00102095 <vector74>:
.globl vector74
vector74:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $74
  102097:	6a 4a                	push   $0x4a
  jmp __alltraps
  102099:	e9 dd 07 00 00       	jmp    10287b <__alltraps>

0010209e <vector75>:
.globl vector75
vector75:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $75
  1020a0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020a2:	e9 d4 07 00 00       	jmp    10287b <__alltraps>

001020a7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $76
  1020a9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020ab:	e9 cb 07 00 00       	jmp    10287b <__alltraps>

001020b0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $77
  1020b2:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020b4:	e9 c2 07 00 00       	jmp    10287b <__alltraps>

001020b9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $78
  1020bb:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020bd:	e9 b9 07 00 00       	jmp    10287b <__alltraps>

001020c2 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $79
  1020c4:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020c6:	e9 b0 07 00 00       	jmp    10287b <__alltraps>

001020cb <vector80>:
.globl vector80
vector80:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $80
  1020cd:	6a 50                	push   $0x50
  jmp __alltraps
  1020cf:	e9 a7 07 00 00       	jmp    10287b <__alltraps>

001020d4 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $81
  1020d6:	6a 51                	push   $0x51
  jmp __alltraps
  1020d8:	e9 9e 07 00 00       	jmp    10287b <__alltraps>

001020dd <vector82>:
.globl vector82
vector82:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $82
  1020df:	6a 52                	push   $0x52
  jmp __alltraps
  1020e1:	e9 95 07 00 00       	jmp    10287b <__alltraps>

001020e6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $83
  1020e8:	6a 53                	push   $0x53
  jmp __alltraps
  1020ea:	e9 8c 07 00 00       	jmp    10287b <__alltraps>

001020ef <vector84>:
.globl vector84
vector84:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $84
  1020f1:	6a 54                	push   $0x54
  jmp __alltraps
  1020f3:	e9 83 07 00 00       	jmp    10287b <__alltraps>

001020f8 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $85
  1020fa:	6a 55                	push   $0x55
  jmp __alltraps
  1020fc:	e9 7a 07 00 00       	jmp    10287b <__alltraps>

00102101 <vector86>:
.globl vector86
vector86:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $86
  102103:	6a 56                	push   $0x56
  jmp __alltraps
  102105:	e9 71 07 00 00       	jmp    10287b <__alltraps>

0010210a <vector87>:
.globl vector87
vector87:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $87
  10210c:	6a 57                	push   $0x57
  jmp __alltraps
  10210e:	e9 68 07 00 00       	jmp    10287b <__alltraps>

00102113 <vector88>:
.globl vector88
vector88:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $88
  102115:	6a 58                	push   $0x58
  jmp __alltraps
  102117:	e9 5f 07 00 00       	jmp    10287b <__alltraps>

0010211c <vector89>:
.globl vector89
vector89:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $89
  10211e:	6a 59                	push   $0x59
  jmp __alltraps
  102120:	e9 56 07 00 00       	jmp    10287b <__alltraps>

00102125 <vector90>:
.globl vector90
vector90:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $90
  102127:	6a 5a                	push   $0x5a
  jmp __alltraps
  102129:	e9 4d 07 00 00       	jmp    10287b <__alltraps>

0010212e <vector91>:
.globl vector91
vector91:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $91
  102130:	6a 5b                	push   $0x5b
  jmp __alltraps
  102132:	e9 44 07 00 00       	jmp    10287b <__alltraps>

00102137 <vector92>:
.globl vector92
vector92:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $92
  102139:	6a 5c                	push   $0x5c
  jmp __alltraps
  10213b:	e9 3b 07 00 00       	jmp    10287b <__alltraps>

00102140 <vector93>:
.globl vector93
vector93:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $93
  102142:	6a 5d                	push   $0x5d
  jmp __alltraps
  102144:	e9 32 07 00 00       	jmp    10287b <__alltraps>

00102149 <vector94>:
.globl vector94
vector94:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $94
  10214b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10214d:	e9 29 07 00 00       	jmp    10287b <__alltraps>

00102152 <vector95>:
.globl vector95
vector95:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $95
  102154:	6a 5f                	push   $0x5f
  jmp __alltraps
  102156:	e9 20 07 00 00       	jmp    10287b <__alltraps>

0010215b <vector96>:
.globl vector96
vector96:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $96
  10215d:	6a 60                	push   $0x60
  jmp __alltraps
  10215f:	e9 17 07 00 00       	jmp    10287b <__alltraps>

00102164 <vector97>:
.globl vector97
vector97:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $97
  102166:	6a 61                	push   $0x61
  jmp __alltraps
  102168:	e9 0e 07 00 00       	jmp    10287b <__alltraps>

0010216d <vector98>:
.globl vector98
vector98:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $98
  10216f:	6a 62                	push   $0x62
  jmp __alltraps
  102171:	e9 05 07 00 00       	jmp    10287b <__alltraps>

00102176 <vector99>:
.globl vector99
vector99:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $99
  102178:	6a 63                	push   $0x63
  jmp __alltraps
  10217a:	e9 fc 06 00 00       	jmp    10287b <__alltraps>

0010217f <vector100>:
.globl vector100
vector100:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $100
  102181:	6a 64                	push   $0x64
  jmp __alltraps
  102183:	e9 f3 06 00 00       	jmp    10287b <__alltraps>

00102188 <vector101>:
.globl vector101
vector101:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $101
  10218a:	6a 65                	push   $0x65
  jmp __alltraps
  10218c:	e9 ea 06 00 00       	jmp    10287b <__alltraps>

00102191 <vector102>:
.globl vector102
vector102:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $102
  102193:	6a 66                	push   $0x66
  jmp __alltraps
  102195:	e9 e1 06 00 00       	jmp    10287b <__alltraps>

0010219a <vector103>:
.globl vector103
vector103:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $103
  10219c:	6a 67                	push   $0x67
  jmp __alltraps
  10219e:	e9 d8 06 00 00       	jmp    10287b <__alltraps>

001021a3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $104
  1021a5:	6a 68                	push   $0x68
  jmp __alltraps
  1021a7:	e9 cf 06 00 00       	jmp    10287b <__alltraps>

001021ac <vector105>:
.globl vector105
vector105:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $105
  1021ae:	6a 69                	push   $0x69
  jmp __alltraps
  1021b0:	e9 c6 06 00 00       	jmp    10287b <__alltraps>

001021b5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $106
  1021b7:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021b9:	e9 bd 06 00 00       	jmp    10287b <__alltraps>

001021be <vector107>:
.globl vector107
vector107:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $107
  1021c0:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021c2:	e9 b4 06 00 00       	jmp    10287b <__alltraps>

001021c7 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $108
  1021c9:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021cb:	e9 ab 06 00 00       	jmp    10287b <__alltraps>

001021d0 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $109
  1021d2:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021d4:	e9 a2 06 00 00       	jmp    10287b <__alltraps>

001021d9 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $110
  1021db:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021dd:	e9 99 06 00 00       	jmp    10287b <__alltraps>

001021e2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $111
  1021e4:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021e6:	e9 90 06 00 00       	jmp    10287b <__alltraps>

001021eb <vector112>:
.globl vector112
vector112:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $112
  1021ed:	6a 70                	push   $0x70
  jmp __alltraps
  1021ef:	e9 87 06 00 00       	jmp    10287b <__alltraps>

001021f4 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $113
  1021f6:	6a 71                	push   $0x71
  jmp __alltraps
  1021f8:	e9 7e 06 00 00       	jmp    10287b <__alltraps>

001021fd <vector114>:
.globl vector114
vector114:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $114
  1021ff:	6a 72                	push   $0x72
  jmp __alltraps
  102201:	e9 75 06 00 00       	jmp    10287b <__alltraps>

00102206 <vector115>:
.globl vector115
vector115:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $115
  102208:	6a 73                	push   $0x73
  jmp __alltraps
  10220a:	e9 6c 06 00 00       	jmp    10287b <__alltraps>

0010220f <vector116>:
.globl vector116
vector116:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $116
  102211:	6a 74                	push   $0x74
  jmp __alltraps
  102213:	e9 63 06 00 00       	jmp    10287b <__alltraps>

00102218 <vector117>:
.globl vector117
vector117:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $117
  10221a:	6a 75                	push   $0x75
  jmp __alltraps
  10221c:	e9 5a 06 00 00       	jmp    10287b <__alltraps>

00102221 <vector118>:
.globl vector118
vector118:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $118
  102223:	6a 76                	push   $0x76
  jmp __alltraps
  102225:	e9 51 06 00 00       	jmp    10287b <__alltraps>

0010222a <vector119>:
.globl vector119
vector119:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $119
  10222c:	6a 77                	push   $0x77
  jmp __alltraps
  10222e:	e9 48 06 00 00       	jmp    10287b <__alltraps>

00102233 <vector120>:
.globl vector120
vector120:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $120
  102235:	6a 78                	push   $0x78
  jmp __alltraps
  102237:	e9 3f 06 00 00       	jmp    10287b <__alltraps>

0010223c <vector121>:
.globl vector121
vector121:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $121
  10223e:	6a 79                	push   $0x79
  jmp __alltraps
  102240:	e9 36 06 00 00       	jmp    10287b <__alltraps>

00102245 <vector122>:
.globl vector122
vector122:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $122
  102247:	6a 7a                	push   $0x7a
  jmp __alltraps
  102249:	e9 2d 06 00 00       	jmp    10287b <__alltraps>

0010224e <vector123>:
.globl vector123
vector123:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $123
  102250:	6a 7b                	push   $0x7b
  jmp __alltraps
  102252:	e9 24 06 00 00       	jmp    10287b <__alltraps>

00102257 <vector124>:
.globl vector124
vector124:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $124
  102259:	6a 7c                	push   $0x7c
  jmp __alltraps
  10225b:	e9 1b 06 00 00       	jmp    10287b <__alltraps>

00102260 <vector125>:
.globl vector125
vector125:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $125
  102262:	6a 7d                	push   $0x7d
  jmp __alltraps
  102264:	e9 12 06 00 00       	jmp    10287b <__alltraps>

00102269 <vector126>:
.globl vector126
vector126:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $126
  10226b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10226d:	e9 09 06 00 00       	jmp    10287b <__alltraps>

00102272 <vector127>:
.globl vector127
vector127:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $127
  102274:	6a 7f                	push   $0x7f
  jmp __alltraps
  102276:	e9 00 06 00 00       	jmp    10287b <__alltraps>

0010227b <vector128>:
.globl vector128
vector128:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $128
  10227d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102282:	e9 f4 05 00 00       	jmp    10287b <__alltraps>

00102287 <vector129>:
.globl vector129
vector129:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $129
  102289:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10228e:	e9 e8 05 00 00       	jmp    10287b <__alltraps>

00102293 <vector130>:
.globl vector130
vector130:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $130
  102295:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10229a:	e9 dc 05 00 00       	jmp    10287b <__alltraps>

0010229f <vector131>:
.globl vector131
vector131:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $131
  1022a1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022a6:	e9 d0 05 00 00       	jmp    10287b <__alltraps>

001022ab <vector132>:
.globl vector132
vector132:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $132
  1022ad:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022b2:	e9 c4 05 00 00       	jmp    10287b <__alltraps>

001022b7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $133
  1022b9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022be:	e9 b8 05 00 00       	jmp    10287b <__alltraps>

001022c3 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $134
  1022c5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022ca:	e9 ac 05 00 00       	jmp    10287b <__alltraps>

001022cf <vector135>:
.globl vector135
vector135:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $135
  1022d1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022d6:	e9 a0 05 00 00       	jmp    10287b <__alltraps>

001022db <vector136>:
.globl vector136
vector136:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $136
  1022dd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022e2:	e9 94 05 00 00       	jmp    10287b <__alltraps>

001022e7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $137
  1022e9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ee:	e9 88 05 00 00       	jmp    10287b <__alltraps>

001022f3 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $138
  1022f5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022fa:	e9 7c 05 00 00       	jmp    10287b <__alltraps>

001022ff <vector139>:
.globl vector139
vector139:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $139
  102301:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102306:	e9 70 05 00 00       	jmp    10287b <__alltraps>

0010230b <vector140>:
.globl vector140
vector140:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $140
  10230d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102312:	e9 64 05 00 00       	jmp    10287b <__alltraps>

00102317 <vector141>:
.globl vector141
vector141:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $141
  102319:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10231e:	e9 58 05 00 00       	jmp    10287b <__alltraps>

00102323 <vector142>:
.globl vector142
vector142:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $142
  102325:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10232a:	e9 4c 05 00 00       	jmp    10287b <__alltraps>

0010232f <vector143>:
.globl vector143
vector143:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $143
  102331:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102336:	e9 40 05 00 00       	jmp    10287b <__alltraps>

0010233b <vector144>:
.globl vector144
vector144:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $144
  10233d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102342:	e9 34 05 00 00       	jmp    10287b <__alltraps>

00102347 <vector145>:
.globl vector145
vector145:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $145
  102349:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10234e:	e9 28 05 00 00       	jmp    10287b <__alltraps>

00102353 <vector146>:
.globl vector146
vector146:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $146
  102355:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10235a:	e9 1c 05 00 00       	jmp    10287b <__alltraps>

0010235f <vector147>:
.globl vector147
vector147:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $147
  102361:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102366:	e9 10 05 00 00       	jmp    10287b <__alltraps>

0010236b <vector148>:
.globl vector148
vector148:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $148
  10236d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102372:	e9 04 05 00 00       	jmp    10287b <__alltraps>

00102377 <vector149>:
.globl vector149
vector149:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $149
  102379:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10237e:	e9 f8 04 00 00       	jmp    10287b <__alltraps>

00102383 <vector150>:
.globl vector150
vector150:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $150
  102385:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10238a:	e9 ec 04 00 00       	jmp    10287b <__alltraps>

0010238f <vector151>:
.globl vector151
vector151:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $151
  102391:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102396:	e9 e0 04 00 00       	jmp    10287b <__alltraps>

0010239b <vector152>:
.globl vector152
vector152:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $152
  10239d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023a2:	e9 d4 04 00 00       	jmp    10287b <__alltraps>

001023a7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $153
  1023a9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023ae:	e9 c8 04 00 00       	jmp    10287b <__alltraps>

001023b3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $154
  1023b5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023ba:	e9 bc 04 00 00       	jmp    10287b <__alltraps>

001023bf <vector155>:
.globl vector155
vector155:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $155
  1023c1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023c6:	e9 b0 04 00 00       	jmp    10287b <__alltraps>

001023cb <vector156>:
.globl vector156
vector156:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $156
  1023cd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023d2:	e9 a4 04 00 00       	jmp    10287b <__alltraps>

001023d7 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $157
  1023d9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023de:	e9 98 04 00 00       	jmp    10287b <__alltraps>

001023e3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $158
  1023e5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023ea:	e9 8c 04 00 00       	jmp    10287b <__alltraps>

001023ef <vector159>:
.globl vector159
vector159:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $159
  1023f1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023f6:	e9 80 04 00 00       	jmp    10287b <__alltraps>

001023fb <vector160>:
.globl vector160
vector160:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $160
  1023fd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102402:	e9 74 04 00 00       	jmp    10287b <__alltraps>

00102407 <vector161>:
.globl vector161
vector161:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $161
  102409:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10240e:	e9 68 04 00 00       	jmp    10287b <__alltraps>

00102413 <vector162>:
.globl vector162
vector162:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $162
  102415:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10241a:	e9 5c 04 00 00       	jmp    10287b <__alltraps>

0010241f <vector163>:
.globl vector163
vector163:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $163
  102421:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102426:	e9 50 04 00 00       	jmp    10287b <__alltraps>

0010242b <vector164>:
.globl vector164
vector164:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $164
  10242d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102432:	e9 44 04 00 00       	jmp    10287b <__alltraps>

00102437 <vector165>:
.globl vector165
vector165:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $165
  102439:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10243e:	e9 38 04 00 00       	jmp    10287b <__alltraps>

00102443 <vector166>:
.globl vector166
vector166:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $166
  102445:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10244a:	e9 2c 04 00 00       	jmp    10287b <__alltraps>

0010244f <vector167>:
.globl vector167
vector167:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $167
  102451:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102456:	e9 20 04 00 00       	jmp    10287b <__alltraps>

0010245b <vector168>:
.globl vector168
vector168:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $168
  10245d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102462:	e9 14 04 00 00       	jmp    10287b <__alltraps>

00102467 <vector169>:
.globl vector169
vector169:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $169
  102469:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10246e:	e9 08 04 00 00       	jmp    10287b <__alltraps>

00102473 <vector170>:
.globl vector170
vector170:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $170
  102475:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10247a:	e9 fc 03 00 00       	jmp    10287b <__alltraps>

0010247f <vector171>:
.globl vector171
vector171:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $171
  102481:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102486:	e9 f0 03 00 00       	jmp    10287b <__alltraps>

0010248b <vector172>:
.globl vector172
vector172:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $172
  10248d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102492:	e9 e4 03 00 00       	jmp    10287b <__alltraps>

00102497 <vector173>:
.globl vector173
vector173:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $173
  102499:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10249e:	e9 d8 03 00 00       	jmp    10287b <__alltraps>

001024a3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $174
  1024a5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024aa:	e9 cc 03 00 00       	jmp    10287b <__alltraps>

001024af <vector175>:
.globl vector175
vector175:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $175
  1024b1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024b6:	e9 c0 03 00 00       	jmp    10287b <__alltraps>

001024bb <vector176>:
.globl vector176
vector176:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $176
  1024bd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024c2:	e9 b4 03 00 00       	jmp    10287b <__alltraps>

001024c7 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $177
  1024c9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024ce:	e9 a8 03 00 00       	jmp    10287b <__alltraps>

001024d3 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $178
  1024d5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024da:	e9 9c 03 00 00       	jmp    10287b <__alltraps>

001024df <vector179>:
.globl vector179
vector179:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $179
  1024e1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024e6:	e9 90 03 00 00       	jmp    10287b <__alltraps>

001024eb <vector180>:
.globl vector180
vector180:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $180
  1024ed:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024f2:	e9 84 03 00 00       	jmp    10287b <__alltraps>

001024f7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $181
  1024f9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024fe:	e9 78 03 00 00       	jmp    10287b <__alltraps>

00102503 <vector182>:
.globl vector182
vector182:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $182
  102505:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10250a:	e9 6c 03 00 00       	jmp    10287b <__alltraps>

0010250f <vector183>:
.globl vector183
vector183:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $183
  102511:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102516:	e9 60 03 00 00       	jmp    10287b <__alltraps>

0010251b <vector184>:
.globl vector184
vector184:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $184
  10251d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102522:	e9 54 03 00 00       	jmp    10287b <__alltraps>

00102527 <vector185>:
.globl vector185
vector185:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $185
  102529:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10252e:	e9 48 03 00 00       	jmp    10287b <__alltraps>

00102533 <vector186>:
.globl vector186
vector186:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $186
  102535:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10253a:	e9 3c 03 00 00       	jmp    10287b <__alltraps>

0010253f <vector187>:
.globl vector187
vector187:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $187
  102541:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102546:	e9 30 03 00 00       	jmp    10287b <__alltraps>

0010254b <vector188>:
.globl vector188
vector188:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $188
  10254d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102552:	e9 24 03 00 00       	jmp    10287b <__alltraps>

00102557 <vector189>:
.globl vector189
vector189:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $189
  102559:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10255e:	e9 18 03 00 00       	jmp    10287b <__alltraps>

00102563 <vector190>:
.globl vector190
vector190:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $190
  102565:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10256a:	e9 0c 03 00 00       	jmp    10287b <__alltraps>

0010256f <vector191>:
.globl vector191
vector191:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $191
  102571:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102576:	e9 00 03 00 00       	jmp    10287b <__alltraps>

0010257b <vector192>:
.globl vector192
vector192:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $192
  10257d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102582:	e9 f4 02 00 00       	jmp    10287b <__alltraps>

00102587 <vector193>:
.globl vector193
vector193:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $193
  102589:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10258e:	e9 e8 02 00 00       	jmp    10287b <__alltraps>

00102593 <vector194>:
.globl vector194
vector194:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $194
  102595:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10259a:	e9 dc 02 00 00       	jmp    10287b <__alltraps>

0010259f <vector195>:
.globl vector195
vector195:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $195
  1025a1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025a6:	e9 d0 02 00 00       	jmp    10287b <__alltraps>

001025ab <vector196>:
.globl vector196
vector196:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $196
  1025ad:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025b2:	e9 c4 02 00 00       	jmp    10287b <__alltraps>

001025b7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $197
  1025b9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025be:	e9 b8 02 00 00       	jmp    10287b <__alltraps>

001025c3 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $198
  1025c5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025ca:	e9 ac 02 00 00       	jmp    10287b <__alltraps>

001025cf <vector199>:
.globl vector199
vector199:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $199
  1025d1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025d6:	e9 a0 02 00 00       	jmp    10287b <__alltraps>

001025db <vector200>:
.globl vector200
vector200:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $200
  1025dd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025e2:	e9 94 02 00 00       	jmp    10287b <__alltraps>

001025e7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $201
  1025e9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ee:	e9 88 02 00 00       	jmp    10287b <__alltraps>

001025f3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $202
  1025f5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025fa:	e9 7c 02 00 00       	jmp    10287b <__alltraps>

001025ff <vector203>:
.globl vector203
vector203:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $203
  102601:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102606:	e9 70 02 00 00       	jmp    10287b <__alltraps>

0010260b <vector204>:
.globl vector204
vector204:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $204
  10260d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102612:	e9 64 02 00 00       	jmp    10287b <__alltraps>

00102617 <vector205>:
.globl vector205
vector205:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $205
  102619:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10261e:	e9 58 02 00 00       	jmp    10287b <__alltraps>

00102623 <vector206>:
.globl vector206
vector206:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $206
  102625:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10262a:	e9 4c 02 00 00       	jmp    10287b <__alltraps>

0010262f <vector207>:
.globl vector207
vector207:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $207
  102631:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102636:	e9 40 02 00 00       	jmp    10287b <__alltraps>

0010263b <vector208>:
.globl vector208
vector208:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $208
  10263d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102642:	e9 34 02 00 00       	jmp    10287b <__alltraps>

00102647 <vector209>:
.globl vector209
vector209:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $209
  102649:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10264e:	e9 28 02 00 00       	jmp    10287b <__alltraps>

00102653 <vector210>:
.globl vector210
vector210:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $210
  102655:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10265a:	e9 1c 02 00 00       	jmp    10287b <__alltraps>

0010265f <vector211>:
.globl vector211
vector211:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $211
  102661:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102666:	e9 10 02 00 00       	jmp    10287b <__alltraps>

0010266b <vector212>:
.globl vector212
vector212:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $212
  10266d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102672:	e9 04 02 00 00       	jmp    10287b <__alltraps>

00102677 <vector213>:
.globl vector213
vector213:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $213
  102679:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10267e:	e9 f8 01 00 00       	jmp    10287b <__alltraps>

00102683 <vector214>:
.globl vector214
vector214:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $214
  102685:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10268a:	e9 ec 01 00 00       	jmp    10287b <__alltraps>

0010268f <vector215>:
.globl vector215
vector215:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $215
  102691:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102696:	e9 e0 01 00 00       	jmp    10287b <__alltraps>

0010269b <vector216>:
.globl vector216
vector216:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $216
  10269d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026a2:	e9 d4 01 00 00       	jmp    10287b <__alltraps>

001026a7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $217
  1026a9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026ae:	e9 c8 01 00 00       	jmp    10287b <__alltraps>

001026b3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $218
  1026b5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026ba:	e9 bc 01 00 00       	jmp    10287b <__alltraps>

001026bf <vector219>:
.globl vector219
vector219:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $219
  1026c1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026c6:	e9 b0 01 00 00       	jmp    10287b <__alltraps>

001026cb <vector220>:
.globl vector220
vector220:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $220
  1026cd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026d2:	e9 a4 01 00 00       	jmp    10287b <__alltraps>

001026d7 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $221
  1026d9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026de:	e9 98 01 00 00       	jmp    10287b <__alltraps>

001026e3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $222
  1026e5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026ea:	e9 8c 01 00 00       	jmp    10287b <__alltraps>

001026ef <vector223>:
.globl vector223
vector223:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $223
  1026f1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026f6:	e9 80 01 00 00       	jmp    10287b <__alltraps>

001026fb <vector224>:
.globl vector224
vector224:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $224
  1026fd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102702:	e9 74 01 00 00       	jmp    10287b <__alltraps>

00102707 <vector225>:
.globl vector225
vector225:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $225
  102709:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10270e:	e9 68 01 00 00       	jmp    10287b <__alltraps>

00102713 <vector226>:
.globl vector226
vector226:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $226
  102715:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10271a:	e9 5c 01 00 00       	jmp    10287b <__alltraps>

0010271f <vector227>:
.globl vector227
vector227:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $227
  102721:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102726:	e9 50 01 00 00       	jmp    10287b <__alltraps>

0010272b <vector228>:
.globl vector228
vector228:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $228
  10272d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102732:	e9 44 01 00 00       	jmp    10287b <__alltraps>

00102737 <vector229>:
.globl vector229
vector229:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $229
  102739:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10273e:	e9 38 01 00 00       	jmp    10287b <__alltraps>

00102743 <vector230>:
.globl vector230
vector230:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $230
  102745:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10274a:	e9 2c 01 00 00       	jmp    10287b <__alltraps>

0010274f <vector231>:
.globl vector231
vector231:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $231
  102751:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102756:	e9 20 01 00 00       	jmp    10287b <__alltraps>

0010275b <vector232>:
.globl vector232
vector232:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $232
  10275d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102762:	e9 14 01 00 00       	jmp    10287b <__alltraps>

00102767 <vector233>:
.globl vector233
vector233:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $233
  102769:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10276e:	e9 08 01 00 00       	jmp    10287b <__alltraps>

00102773 <vector234>:
.globl vector234
vector234:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $234
  102775:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10277a:	e9 fc 00 00 00       	jmp    10287b <__alltraps>

0010277f <vector235>:
.globl vector235
vector235:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $235
  102781:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102786:	e9 f0 00 00 00       	jmp    10287b <__alltraps>

0010278b <vector236>:
.globl vector236
vector236:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $236
  10278d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102792:	e9 e4 00 00 00       	jmp    10287b <__alltraps>

00102797 <vector237>:
.globl vector237
vector237:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $237
  102799:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10279e:	e9 d8 00 00 00       	jmp    10287b <__alltraps>

001027a3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $238
  1027a5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027aa:	e9 cc 00 00 00       	jmp    10287b <__alltraps>

001027af <vector239>:
.globl vector239
vector239:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $239
  1027b1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027b6:	e9 c0 00 00 00       	jmp    10287b <__alltraps>

001027bb <vector240>:
.globl vector240
vector240:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $240
  1027bd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027c2:	e9 b4 00 00 00       	jmp    10287b <__alltraps>

001027c7 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $241
  1027c9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027ce:	e9 a8 00 00 00       	jmp    10287b <__alltraps>

001027d3 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $242
  1027d5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027da:	e9 9c 00 00 00       	jmp    10287b <__alltraps>

001027df <vector243>:
.globl vector243
vector243:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $243
  1027e1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027e6:	e9 90 00 00 00       	jmp    10287b <__alltraps>

001027eb <vector244>:
.globl vector244
vector244:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $244
  1027ed:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027f2:	e9 84 00 00 00       	jmp    10287b <__alltraps>

001027f7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $245
  1027f9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027fe:	e9 78 00 00 00       	jmp    10287b <__alltraps>

00102803 <vector246>:
.globl vector246
vector246:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $246
  102805:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10280a:	e9 6c 00 00 00       	jmp    10287b <__alltraps>

0010280f <vector247>:
.globl vector247
vector247:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $247
  102811:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102816:	e9 60 00 00 00       	jmp    10287b <__alltraps>

0010281b <vector248>:
.globl vector248
vector248:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $248
  10281d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102822:	e9 54 00 00 00       	jmp    10287b <__alltraps>

00102827 <vector249>:
.globl vector249
vector249:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $249
  102829:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10282e:	e9 48 00 00 00       	jmp    10287b <__alltraps>

00102833 <vector250>:
.globl vector250
vector250:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $250
  102835:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10283a:	e9 3c 00 00 00       	jmp    10287b <__alltraps>

0010283f <vector251>:
.globl vector251
vector251:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $251
  102841:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102846:	e9 30 00 00 00       	jmp    10287b <__alltraps>

0010284b <vector252>:
.globl vector252
vector252:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $252
  10284d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102852:	e9 24 00 00 00       	jmp    10287b <__alltraps>

00102857 <vector253>:
.globl vector253
vector253:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $253
  102859:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10285e:	e9 18 00 00 00       	jmp    10287b <__alltraps>

00102863 <vector254>:
.globl vector254
vector254:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $254
  102865:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10286a:	e9 0c 00 00 00       	jmp    10287b <__alltraps>

0010286f <vector255>:
.globl vector255
vector255:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $255
  102871:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102876:	e9 00 00 00 00       	jmp    10287b <__alltraps>

0010287b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10287b:	1e                   	push   %ds
    pushl %es
  10287c:	06                   	push   %es
    pushl %fs
  10287d:	0f a0                	push   %fs
    pushl %gs
  10287f:	0f a8                	push   %gs
    pushal
  102881:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102882:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102887:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102889:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10288b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10288c:	e8 63 f5 ff ff       	call   101df4 <trap>

    # pop the pushed stack pointer
    popl %esp
  102891:	5c                   	pop    %esp

00102892 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102892:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102893:	0f a9                	pop    %gs
    popl %fs
  102895:	0f a1                	pop    %fs
    popl %es
  102897:	07                   	pop    %es
    popl %ds
  102898:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102899:	83 c4 08             	add    $0x8,%esp
    iret
  10289c:	cf                   	iret   

0010289d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10289d:	55                   	push   %ebp
  10289e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a3:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1028a9:	29 d0                	sub    %edx,%eax
  1028ab:	c1 f8 02             	sar    $0x2,%eax
  1028ae:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028b4:	5d                   	pop    %ebp
  1028b5:	c3                   	ret    

001028b6 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028b6:	55                   	push   %ebp
  1028b7:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  1028b9:	ff 75 08             	pushl  0x8(%ebp)
  1028bc:	e8 dc ff ff ff       	call   10289d <page2ppn>
  1028c1:	83 c4 04             	add    $0x4,%esp
  1028c4:	c1 e0 0c             	shl    $0xc,%eax
}
  1028c7:	c9                   	leave  
  1028c8:	c3                   	ret    

001028c9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1028c9:	55                   	push   %ebp
  1028ca:	89 e5                	mov    %esp,%ebp
  1028cc:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
  1028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d2:	c1 e8 0c             	shr    $0xc,%eax
  1028d5:	89 c2                	mov    %eax,%edx
  1028d7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1028dc:	39 c2                	cmp    %eax,%edx
  1028de:	72 14                	jb     1028f4 <pa2page+0x2b>
        panic("pa2page called with invalid pa");
  1028e0:	83 ec 04             	sub    $0x4,%esp
  1028e3:	68 90 61 10 00       	push   $0x106190
  1028e8:	6a 5a                	push   $0x5a
  1028ea:	68 af 61 10 00       	push   $0x1061af
  1028ef:	e8 d9 da ff ff       	call   1003cd <__panic>
    }
    return &pages[PPN(pa)];
  1028f4:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  1028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1028fd:	c1 e8 0c             	shr    $0xc,%eax
  102900:	89 c2                	mov    %eax,%edx
  102902:	89 d0                	mov    %edx,%eax
  102904:	c1 e0 02             	shl    $0x2,%eax
  102907:	01 d0                	add    %edx,%eax
  102909:	c1 e0 02             	shl    $0x2,%eax
  10290c:	01 c8                	add    %ecx,%eax
}
  10290e:	c9                   	leave  
  10290f:	c3                   	ret    

00102910 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102910:	55                   	push   %ebp
  102911:	89 e5                	mov    %esp,%ebp
  102913:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
  102916:	ff 75 08             	pushl  0x8(%ebp)
  102919:	e8 98 ff ff ff       	call   1028b6 <page2pa>
  10291e:	83 c4 04             	add    $0x4,%esp
  102921:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102927:	c1 e8 0c             	shr    $0xc,%eax
  10292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10292d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102932:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102935:	72 14                	jb     10294b <page2kva+0x3b>
  102937:	ff 75 f4             	pushl  -0xc(%ebp)
  10293a:	68 c0 61 10 00       	push   $0x1061c0
  10293f:	6a 61                	push   $0x61
  102941:	68 af 61 10 00       	push   $0x1061af
  102946:	e8 82 da ff ff       	call   1003cd <__panic>
  10294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10294e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102953:	c9                   	leave  
  102954:	c3                   	ret    

00102955 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102955:	55                   	push   %ebp
  102956:	89 e5                	mov    %esp,%ebp
  102958:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
  10295b:	8b 45 08             	mov    0x8(%ebp),%eax
  10295e:	83 e0 01             	and    $0x1,%eax
  102961:	85 c0                	test   %eax,%eax
  102963:	75 14                	jne    102979 <pte2page+0x24>
        panic("pte2page called with invalid pte");
  102965:	83 ec 04             	sub    $0x4,%esp
  102968:	68 e4 61 10 00       	push   $0x1061e4
  10296d:	6a 6c                	push   $0x6c
  10296f:	68 af 61 10 00       	push   $0x1061af
  102974:	e8 54 da ff ff       	call   1003cd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102979:	8b 45 08             	mov    0x8(%ebp),%eax
  10297c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102981:	83 ec 0c             	sub    $0xc,%esp
  102984:	50                   	push   %eax
  102985:	e8 3f ff ff ff       	call   1028c9 <pa2page>
  10298a:	83 c4 10             	add    $0x10,%esp
}
  10298d:	c9                   	leave  
  10298e:	c3                   	ret    

0010298f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  10298f:	55                   	push   %ebp
  102990:	89 e5                	mov    %esp,%ebp
  102992:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
  102995:	8b 45 08             	mov    0x8(%ebp),%eax
  102998:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10299d:	83 ec 0c             	sub    $0xc,%esp
  1029a0:	50                   	push   %eax
  1029a1:	e8 23 ff ff ff       	call   1028c9 <pa2page>
  1029a6:	83 c4 10             	add    $0x10,%esp
}
  1029a9:	c9                   	leave  
  1029aa:	c3                   	ret    

001029ab <page_ref>:

static inline int
page_ref(struct Page *page) {
  1029ab:	55                   	push   %ebp
  1029ac:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b1:	8b 00                	mov    (%eax),%eax
}
  1029b3:	5d                   	pop    %ebp
  1029b4:	c3                   	ret    

001029b5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1029b5:	55                   	push   %ebp
  1029b6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029be:	89 10                	mov    %edx,(%eax)
}
  1029c0:	90                   	nop
  1029c1:	5d                   	pop    %ebp
  1029c2:	c3                   	ret    

001029c3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  1029c3:	55                   	push   %ebp
  1029c4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c9:	8b 00                	mov    (%eax),%eax
  1029cb:	8d 50 01             	lea    0x1(%eax),%edx
  1029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d1:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d6:	8b 00                	mov    (%eax),%eax
}
  1029d8:	5d                   	pop    %ebp
  1029d9:	c3                   	ret    

001029da <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1029da:	55                   	push   %ebp
  1029db:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e0:	8b 00                	mov    (%eax),%eax
  1029e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e8:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ed:	8b 00                	mov    (%eax),%eax
}
  1029ef:	5d                   	pop    %ebp
  1029f0:	c3                   	ret    

001029f1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  1029f1:	55                   	push   %ebp
  1029f2:	89 e5                	mov    %esp,%ebp
  1029f4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1029f7:	9c                   	pushf  
  1029f8:	58                   	pop    %eax
  1029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1029ff:	25 00 02 00 00       	and    $0x200,%eax
  102a04:	85 c0                	test   %eax,%eax
  102a06:	74 0c                	je     102a14 <__intr_save+0x23>
        intr_disable();
  102a08:	e8 5a ee ff ff       	call   101867 <intr_disable>
        return 1;
  102a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  102a12:	eb 05                	jmp    102a19 <__intr_save+0x28>
    }
    return 0;
  102a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102a19:	c9                   	leave  
  102a1a:	c3                   	ret    

00102a1b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102a1b:	55                   	push   %ebp
  102a1c:	89 e5                	mov    %esp,%ebp
  102a1e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a25:	74 05                	je     102a2c <__intr_restore+0x11>
        intr_enable();
  102a27:	e8 34 ee ff ff       	call   101860 <intr_enable>
    }
}
  102a2c:	90                   	nop
  102a2d:	c9                   	leave  
  102a2e:	c3                   	ret    

00102a2f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102a2f:	55                   	push   %ebp
  102a30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102a32:	8b 45 08             	mov    0x8(%ebp),%eax
  102a35:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102a38:	b8 23 00 00 00       	mov    $0x23,%eax
  102a3d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102a3f:	b8 23 00 00 00       	mov    $0x23,%eax
  102a44:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102a46:	b8 10 00 00 00       	mov    $0x10,%eax
  102a4b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a4d:	b8 10 00 00 00       	mov    $0x10,%eax
  102a52:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a54:	b8 10 00 00 00       	mov    $0x10,%eax
  102a59:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a5b:	ea 62 2a 10 00 08 00 	ljmp   $0x8,$0x102a62
}
  102a62:	90                   	nop
  102a63:	5d                   	pop    %ebp
  102a64:	c3                   	ret    

00102a65 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102a68:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6b:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  102a70:	90                   	nop
  102a71:	5d                   	pop    %ebp
  102a72:	c3                   	ret    

00102a73 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a73:	55                   	push   %ebp
  102a74:	89 e5                	mov    %esp,%ebp
  102a76:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a79:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a7e:	50                   	push   %eax
  102a7f:	e8 e1 ff ff ff       	call   102a65 <load_esp0>
  102a84:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
  102a87:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102a8e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102a90:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102a97:	68 00 
  102a99:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102a9e:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102aa4:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102aa9:	c1 e8 10             	shr    $0x10,%eax
  102aac:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102ab1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ab8:	83 e0 f0             	and    $0xfffffff0,%eax
  102abb:	83 c8 09             	or     $0x9,%eax
  102abe:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ac3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102aca:	83 e0 ef             	and    $0xffffffef,%eax
  102acd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ad2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ad9:	83 e0 9f             	and    $0xffffff9f,%eax
  102adc:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102ae1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102ae8:	83 c8 80             	or     $0xffffff80,%eax
  102aeb:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102af0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102af7:	83 e0 f0             	and    $0xfffffff0,%eax
  102afa:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102aff:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b06:	83 e0 ef             	and    $0xffffffef,%eax
  102b09:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b0e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b15:	83 e0 df             	and    $0xffffffdf,%eax
  102b18:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b1d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b24:	83 c8 40             	or     $0x40,%eax
  102b27:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b2c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102b33:	83 e0 7f             	and    $0x7f,%eax
  102b36:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102b3b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102b40:	c1 e8 18             	shr    $0x18,%eax
  102b43:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102b48:	68 30 7a 11 00       	push   $0x117a30
  102b4d:	e8 dd fe ff ff       	call   102a2f <lgdt>
  102b52:	83 c4 04             	add    $0x4,%esp
  102b55:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102b5b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b5f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b62:	90                   	nop
  102b63:	c9                   	leave  
  102b64:	c3                   	ret    

00102b65 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102b65:	55                   	push   %ebp
  102b66:	89 e5                	mov    %esp,%ebp
  102b68:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
  102b6b:	c7 05 50 89 11 00 58 	movl   $0x106b58,0x118950
  102b72:	6b 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b75:	a1 50 89 11 00       	mov    0x118950,%eax
  102b7a:	8b 00                	mov    (%eax),%eax
  102b7c:	83 ec 08             	sub    $0x8,%esp
  102b7f:	50                   	push   %eax
  102b80:	68 10 62 10 00       	push   $0x106210
  102b85:	e8 dd d6 ff ff       	call   100267 <cprintf>
  102b8a:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
  102b8d:	a1 50 89 11 00       	mov    0x118950,%eax
  102b92:	8b 40 04             	mov    0x4(%eax),%eax
  102b95:	ff d0                	call   *%eax
}
  102b97:	90                   	nop
  102b98:	c9                   	leave  
  102b99:	c3                   	ret    

00102b9a <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102b9a:	55                   	push   %ebp
  102b9b:	89 e5                	mov    %esp,%ebp
  102b9d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
  102ba0:	a1 50 89 11 00       	mov    0x118950,%eax
  102ba5:	8b 40 08             	mov    0x8(%eax),%eax
  102ba8:	83 ec 08             	sub    $0x8,%esp
  102bab:	ff 75 0c             	pushl  0xc(%ebp)
  102bae:	ff 75 08             	pushl  0x8(%ebp)
  102bb1:	ff d0                	call   *%eax
  102bb3:	83 c4 10             	add    $0x10,%esp
}
  102bb6:	90                   	nop
  102bb7:	c9                   	leave  
  102bb8:	c3                   	ret    

00102bb9 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102bb9:	55                   	push   %ebp
  102bba:	89 e5                	mov    %esp,%ebp
  102bbc:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
  102bbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102bc6:	e8 26 fe ff ff       	call   1029f1 <__intr_save>
  102bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102bce:	a1 50 89 11 00       	mov    0x118950,%eax
  102bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  102bd6:	83 ec 0c             	sub    $0xc,%esp
  102bd9:	ff 75 08             	pushl  0x8(%ebp)
  102bdc:	ff d0                	call   *%eax
  102bde:	83 c4 10             	add    $0x10,%esp
  102be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102be4:	83 ec 0c             	sub    $0xc,%esp
  102be7:	ff 75 f0             	pushl  -0x10(%ebp)
  102bea:	e8 2c fe ff ff       	call   102a1b <__intr_restore>
  102bef:	83 c4 10             	add    $0x10,%esp
    return page;
  102bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bf5:	c9                   	leave  
  102bf6:	c3                   	ret    

00102bf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102bf7:	55                   	push   %ebp
  102bf8:	89 e5                	mov    %esp,%ebp
  102bfa:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102bfd:	e8 ef fd ff ff       	call   1029f1 <__intr_save>
  102c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102c05:	a1 50 89 11 00       	mov    0x118950,%eax
  102c0a:	8b 40 10             	mov    0x10(%eax),%eax
  102c0d:	83 ec 08             	sub    $0x8,%esp
  102c10:	ff 75 0c             	pushl  0xc(%ebp)
  102c13:	ff 75 08             	pushl  0x8(%ebp)
  102c16:	ff d0                	call   *%eax
  102c18:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
  102c1b:	83 ec 0c             	sub    $0xc,%esp
  102c1e:	ff 75 f4             	pushl  -0xc(%ebp)
  102c21:	e8 f5 fd ff ff       	call   102a1b <__intr_restore>
  102c26:	83 c4 10             	add    $0x10,%esp
}
  102c29:	90                   	nop
  102c2a:	c9                   	leave  
  102c2b:	c3                   	ret    

00102c2c <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102c2c:	55                   	push   %ebp
  102c2d:	89 e5                	mov    %esp,%ebp
  102c2f:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102c32:	e8 ba fd ff ff       	call   1029f1 <__intr_save>
  102c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102c3a:	a1 50 89 11 00       	mov    0x118950,%eax
  102c3f:	8b 40 14             	mov    0x14(%eax),%eax
  102c42:	ff d0                	call   *%eax
  102c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102c47:	83 ec 0c             	sub    $0xc,%esp
  102c4a:	ff 75 f4             	pushl  -0xc(%ebp)
  102c4d:	e8 c9 fd ff ff       	call   102a1b <__intr_restore>
  102c52:	83 c4 10             	add    $0x10,%esp
    return ret;
  102c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c58:	c9                   	leave  
  102c59:	c3                   	ret    

00102c5a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102c5a:	55                   	push   %ebp
  102c5b:	89 e5                	mov    %esp,%ebp
  102c5d:	57                   	push   %edi
  102c5e:	56                   	push   %esi
  102c5f:	53                   	push   %ebx
  102c60:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102c63:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102c71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102c78:	83 ec 0c             	sub    $0xc,%esp
  102c7b:	68 27 62 10 00       	push   $0x106227
  102c80:	e8 e2 d5 ff ff       	call   100267 <cprintf>
  102c85:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c8f:	e9 fc 00 00 00       	jmp    102d90 <page_init+0x136>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c94:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c97:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c9a:	89 d0                	mov    %edx,%eax
  102c9c:	c1 e0 02             	shl    $0x2,%eax
  102c9f:	01 d0                	add    %edx,%eax
  102ca1:	c1 e0 02             	shl    $0x2,%eax
  102ca4:	01 c8                	add    %ecx,%eax
  102ca6:	8b 50 08             	mov    0x8(%eax),%edx
  102ca9:	8b 40 04             	mov    0x4(%eax),%eax
  102cac:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102caf:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102cb2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cb5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cb8:	89 d0                	mov    %edx,%eax
  102cba:	c1 e0 02             	shl    $0x2,%eax
  102cbd:	01 d0                	add    %edx,%eax
  102cbf:	c1 e0 02             	shl    $0x2,%eax
  102cc2:	01 c8                	add    %ecx,%eax
  102cc4:	8b 48 0c             	mov    0xc(%eax),%ecx
  102cc7:	8b 58 10             	mov    0x10(%eax),%ebx
  102cca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ccd:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cd0:	01 c8                	add    %ecx,%eax
  102cd2:	11 da                	adc    %ebx,%edx
  102cd4:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102cd7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102cda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102cdd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ce0:	89 d0                	mov    %edx,%eax
  102ce2:	c1 e0 02             	shl    $0x2,%eax
  102ce5:	01 d0                	add    %edx,%eax
  102ce7:	c1 e0 02             	shl    $0x2,%eax
  102cea:	01 c8                	add    %ecx,%eax
  102cec:	83 c0 14             	add    $0x14,%eax
  102cef:	8b 00                	mov    (%eax),%eax
  102cf1:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102cf4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102cf7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102cfa:	83 c0 ff             	add    $0xffffffff,%eax
  102cfd:	83 d2 ff             	adc    $0xffffffff,%edx
  102d00:	89 c1                	mov    %eax,%ecx
  102d02:	89 d3                	mov    %edx,%ebx
  102d04:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d07:	89 55 80             	mov    %edx,-0x80(%ebp)
  102d0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d0d:	89 d0                	mov    %edx,%eax
  102d0f:	c1 e0 02             	shl    $0x2,%eax
  102d12:	01 d0                	add    %edx,%eax
  102d14:	c1 e0 02             	shl    $0x2,%eax
  102d17:	03 45 80             	add    -0x80(%ebp),%eax
  102d1a:	8b 50 10             	mov    0x10(%eax),%edx
  102d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  102d20:	ff 75 84             	pushl  -0x7c(%ebp)
  102d23:	53                   	push   %ebx
  102d24:	51                   	push   %ecx
  102d25:	ff 75 bc             	pushl  -0x44(%ebp)
  102d28:	ff 75 b8             	pushl  -0x48(%ebp)
  102d2b:	52                   	push   %edx
  102d2c:	50                   	push   %eax
  102d2d:	68 34 62 10 00       	push   $0x106234
  102d32:	e8 30 d5 ff ff       	call   100267 <cprintf>
  102d37:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102d3a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d40:	89 d0                	mov    %edx,%eax
  102d42:	c1 e0 02             	shl    $0x2,%eax
  102d45:	01 d0                	add    %edx,%eax
  102d47:	c1 e0 02             	shl    $0x2,%eax
  102d4a:	01 c8                	add    %ecx,%eax
  102d4c:	83 c0 14             	add    $0x14,%eax
  102d4f:	8b 00                	mov    (%eax),%eax
  102d51:	83 f8 01             	cmp    $0x1,%eax
  102d54:	75 36                	jne    102d8c <page_init+0x132>
            if (maxpa < end && begin < KMEMSIZE) {
  102d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d5c:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d5f:	77 2b                	ja     102d8c <page_init+0x132>
  102d61:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102d64:	72 05                	jb     102d6b <page_init+0x111>
  102d66:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102d69:	73 21                	jae    102d8c <page_init+0x132>
  102d6b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d6f:	77 1b                	ja     102d8c <page_init+0x132>
  102d71:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102d75:	72 09                	jb     102d80 <page_init+0x126>
  102d77:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102d7e:	77 0c                	ja     102d8c <page_init+0x132>
                maxpa = end;
  102d80:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102d83:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d8c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102d90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d93:	8b 00                	mov    (%eax),%eax
  102d95:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102d98:	0f 8f f6 fe ff ff    	jg     102c94 <page_init+0x3a>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102da2:	72 1d                	jb     102dc1 <page_init+0x167>
  102da4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102da8:	77 09                	ja     102db3 <page_init+0x159>
  102daa:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102db1:	76 0e                	jbe    102dc1 <page_init+0x167>
        maxpa = KMEMSIZE;
  102db3:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102dba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102dc7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102dcb:	c1 ea 0c             	shr    $0xc,%edx
  102dce:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102dd3:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102dda:	b8 68 89 11 00       	mov    $0x118968,%eax
  102ddf:	8d 50 ff             	lea    -0x1(%eax),%edx
  102de2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102de5:	01 d0                	add    %edx,%eax
  102de7:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102dea:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102ded:	ba 00 00 00 00       	mov    $0x0,%edx
  102df2:	f7 75 ac             	divl   -0x54(%ebp)
  102df5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102df8:	29 d0                	sub    %edx,%eax
  102dfa:	a3 58 89 11 00       	mov    %eax,0x118958

    for (i = 0; i < npage; i ++) {
  102dff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e06:	eb 2f                	jmp    102e37 <page_init+0x1dd>
        SetPageReserved(pages + i);
  102e08:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e11:	89 d0                	mov    %edx,%eax
  102e13:	c1 e0 02             	shl    $0x2,%eax
  102e16:	01 d0                	add    %edx,%eax
  102e18:	c1 e0 02             	shl    $0x2,%eax
  102e1b:	01 c8                	add    %ecx,%eax
  102e1d:	83 c0 04             	add    $0x4,%eax
  102e20:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102e27:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e2a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e2d:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e30:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102e33:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102e37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e3a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102e3f:	39 c2                	cmp    %eax,%edx
  102e41:	72 c5                	jb     102e08 <page_init+0x1ae>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102e43:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102e49:	89 d0                	mov    %edx,%eax
  102e4b:	c1 e0 02             	shl    $0x2,%eax
  102e4e:	01 d0                	add    %edx,%eax
  102e50:	c1 e0 02             	shl    $0x2,%eax
  102e53:	89 c2                	mov    %eax,%edx
  102e55:	a1 58 89 11 00       	mov    0x118958,%eax
  102e5a:	01 d0                	add    %edx,%eax
  102e5c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102e5f:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102e66:	77 17                	ja     102e7f <page_init+0x225>
  102e68:	ff 75 a4             	pushl  -0x5c(%ebp)
  102e6b:	68 64 62 10 00       	push   $0x106264
  102e70:	68 db 00 00 00       	push   $0xdb
  102e75:	68 88 62 10 00       	push   $0x106288
  102e7a:	e8 4e d5 ff ff       	call   1003cd <__panic>
  102e7f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e82:	05 00 00 00 40       	add    $0x40000000,%eax
  102e87:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102e8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e91:	e9 69 01 00 00       	jmp    102fff <page_init+0x3a5>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e96:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e99:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e9c:	89 d0                	mov    %edx,%eax
  102e9e:	c1 e0 02             	shl    $0x2,%eax
  102ea1:	01 d0                	add    %edx,%eax
  102ea3:	c1 e0 02             	shl    $0x2,%eax
  102ea6:	01 c8                	add    %ecx,%eax
  102ea8:	8b 50 08             	mov    0x8(%eax),%edx
  102eab:	8b 40 04             	mov    0x4(%eax),%eax
  102eae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102eb1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102eb4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102eb7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102eba:	89 d0                	mov    %edx,%eax
  102ebc:	c1 e0 02             	shl    $0x2,%eax
  102ebf:	01 d0                	add    %edx,%eax
  102ec1:	c1 e0 02             	shl    $0x2,%eax
  102ec4:	01 c8                	add    %ecx,%eax
  102ec6:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ec9:	8b 58 10             	mov    0x10(%eax),%ebx
  102ecc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ecf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ed2:	01 c8                	add    %ecx,%eax
  102ed4:	11 da                	adc    %ebx,%edx
  102ed6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ed9:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102edc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102edf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ee2:	89 d0                	mov    %edx,%eax
  102ee4:	c1 e0 02             	shl    $0x2,%eax
  102ee7:	01 d0                	add    %edx,%eax
  102ee9:	c1 e0 02             	shl    $0x2,%eax
  102eec:	01 c8                	add    %ecx,%eax
  102eee:	83 c0 14             	add    $0x14,%eax
  102ef1:	8b 00                	mov    (%eax),%eax
  102ef3:	83 f8 01             	cmp    $0x1,%eax
  102ef6:	0f 85 ff 00 00 00    	jne    102ffb <page_init+0x3a1>
            if (begin < freemem) {
  102efc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102eff:	ba 00 00 00 00       	mov    $0x0,%edx
  102f04:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f07:	72 17                	jb     102f20 <page_init+0x2c6>
  102f09:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f0c:	77 05                	ja     102f13 <page_init+0x2b9>
  102f0e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f11:	76 0d                	jbe    102f20 <page_init+0x2c6>
                begin = freemem;
  102f13:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102f16:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f19:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102f20:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f24:	72 1d                	jb     102f43 <page_init+0x2e9>
  102f26:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102f2a:	77 09                	ja     102f35 <page_init+0x2db>
  102f2c:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102f33:	76 0e                	jbe    102f43 <page_init+0x2e9>
                end = KMEMSIZE;
  102f35:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102f3c:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102f43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f46:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f49:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f4c:	0f 87 a9 00 00 00    	ja     102ffb <page_init+0x3a1>
  102f52:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f55:	72 09                	jb     102f60 <page_init+0x306>
  102f57:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f5a:	0f 83 9b 00 00 00    	jae    102ffb <page_init+0x3a1>
                begin = ROUNDUP(begin, PGSIZE);
  102f60:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102f67:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f6a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102f6d:	01 d0                	add    %edx,%eax
  102f6f:	83 e8 01             	sub    $0x1,%eax
  102f72:	89 45 98             	mov    %eax,-0x68(%ebp)
  102f75:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f78:	ba 00 00 00 00       	mov    $0x0,%edx
  102f7d:	f7 75 9c             	divl   -0x64(%ebp)
  102f80:	8b 45 98             	mov    -0x68(%ebp),%eax
  102f83:	29 d0                	sub    %edx,%eax
  102f85:	ba 00 00 00 00       	mov    $0x0,%edx
  102f8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f8d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102f90:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f93:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102f96:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f99:	ba 00 00 00 00       	mov    $0x0,%edx
  102f9e:	89 c3                	mov    %eax,%ebx
  102fa0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102fa6:	89 de                	mov    %ebx,%esi
  102fa8:	89 d0                	mov    %edx,%eax
  102faa:	83 e0 00             	and    $0x0,%eax
  102fad:	89 c7                	mov    %eax,%edi
  102faf:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102fb2:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102fb5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fb8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fbb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fbe:	77 3b                	ja     102ffb <page_init+0x3a1>
  102fc0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102fc3:	72 05                	jb     102fca <page_init+0x370>
  102fc5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102fc8:	73 31                	jae    102ffb <page_init+0x3a1>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102fca:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fcd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102fd0:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102fd3:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102fd6:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102fda:	c1 ea 0c             	shr    $0xc,%edx
  102fdd:	89 c3                	mov    %eax,%ebx
  102fdf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fe2:	83 ec 0c             	sub    $0xc,%esp
  102fe5:	50                   	push   %eax
  102fe6:	e8 de f8 ff ff       	call   1028c9 <pa2page>
  102feb:	83 c4 10             	add    $0x10,%esp
  102fee:	83 ec 08             	sub    $0x8,%esp
  102ff1:	53                   	push   %ebx
  102ff2:	50                   	push   %eax
  102ff3:	e8 a2 fb ff ff       	call   102b9a <init_memmap>
  102ff8:	83 c4 10             	add    $0x10,%esp
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  102ffb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102fff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103002:	8b 00                	mov    (%eax),%eax
  103004:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103007:	0f 8f 89 fe ff ff    	jg     102e96 <page_init+0x23c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10300d:	90                   	nop
  10300e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  103011:	5b                   	pop    %ebx
  103012:	5e                   	pop    %esi
  103013:	5f                   	pop    %edi
  103014:	5d                   	pop    %ebp
  103015:	c3                   	ret    

00103016 <enable_paging>:

static void
enable_paging(void) {
  103016:	55                   	push   %ebp
  103017:	89 e5                	mov    %esp,%ebp
  103019:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10301c:	a1 54 89 11 00       	mov    0x118954,%eax
  103021:	89 45 fc             	mov    %eax,-0x4(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103027:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10302a:	0f 20 c0             	mov    %cr0,%eax
  10302d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103030:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103033:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103036:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10303d:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  103041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103044:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304a:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10304d:	90                   	nop
  10304e:	c9                   	leave  
  10304f:	c3                   	ret    

00103050 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103050:	55                   	push   %ebp
  103051:	89 e5                	mov    %esp,%ebp
  103053:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103056:	8b 45 0c             	mov    0xc(%ebp),%eax
  103059:	33 45 14             	xor    0x14(%ebp),%eax
  10305c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103061:	85 c0                	test   %eax,%eax
  103063:	74 19                	je     10307e <boot_map_segment+0x2e>
  103065:	68 96 62 10 00       	push   $0x106296
  10306a:	68 ad 62 10 00       	push   $0x1062ad
  10306f:	68 04 01 00 00       	push   $0x104
  103074:	68 88 62 10 00       	push   $0x106288
  103079:	e8 4f d3 ff ff       	call   1003cd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10307e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103085:	8b 45 0c             	mov    0xc(%ebp),%eax
  103088:	25 ff 0f 00 00       	and    $0xfff,%eax
  10308d:	89 c2                	mov    %eax,%edx
  10308f:	8b 45 10             	mov    0x10(%ebp),%eax
  103092:	01 c2                	add    %eax,%edx
  103094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103097:	01 d0                	add    %edx,%eax
  103099:	83 e8 01             	sub    $0x1,%eax
  10309c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10309f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030a2:	ba 00 00 00 00       	mov    $0x0,%edx
  1030a7:	f7 75 f0             	divl   -0x10(%ebp)
  1030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ad:	29 d0                	sub    %edx,%eax
  1030af:	c1 e8 0c             	shr    $0xc,%eax
  1030b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1030b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030c3:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1030c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1030c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1030d4:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030d7:	eb 57                	jmp    103130 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1030d9:	83 ec 04             	sub    $0x4,%esp
  1030dc:	6a 01                	push   $0x1
  1030de:	ff 75 0c             	pushl  0xc(%ebp)
  1030e1:	ff 75 08             	pushl  0x8(%ebp)
  1030e4:	e8 98 01 00 00       	call   103281 <get_pte>
  1030e9:	83 c4 10             	add    $0x10,%esp
  1030ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1030ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1030f3:	75 19                	jne    10310e <boot_map_segment+0xbe>
  1030f5:	68 c2 62 10 00       	push   $0x1062c2
  1030fa:	68 ad 62 10 00       	push   $0x1062ad
  1030ff:	68 0a 01 00 00       	push   $0x10a
  103104:	68 88 62 10 00       	push   $0x106288
  103109:	e8 bf d2 ff ff       	call   1003cd <__panic>
        *ptep = pa | PTE_P | perm;
  10310e:	8b 45 14             	mov    0x14(%ebp),%eax
  103111:	0b 45 18             	or     0x18(%ebp),%eax
  103114:	83 c8 01             	or     $0x1,%eax
  103117:	89 c2                	mov    %eax,%edx
  103119:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10311c:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10311e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103122:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103129:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  103130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103134:	75 a3                	jne    1030d9 <boot_map_segment+0x89>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  103136:	90                   	nop
  103137:	c9                   	leave  
  103138:	c3                   	ret    

00103139 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103139:	55                   	push   %ebp
  10313a:	89 e5                	mov    %esp,%ebp
  10313c:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
  10313f:	83 ec 0c             	sub    $0xc,%esp
  103142:	6a 01                	push   $0x1
  103144:	e8 70 fa ff ff       	call   102bb9 <alloc_pages>
  103149:	83 c4 10             	add    $0x10,%esp
  10314c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10314f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103153:	75 17                	jne    10316c <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
  103155:	83 ec 04             	sub    $0x4,%esp
  103158:	68 cf 62 10 00       	push   $0x1062cf
  10315d:	68 16 01 00 00       	push   $0x116
  103162:	68 88 62 10 00       	push   $0x106288
  103167:	e8 61 d2 ff ff       	call   1003cd <__panic>
    }
    return page2kva(p);
  10316c:	83 ec 0c             	sub    $0xc,%esp
  10316f:	ff 75 f4             	pushl  -0xc(%ebp)
  103172:	e8 99 f7 ff ff       	call   102910 <page2kva>
  103177:	83 c4 10             	add    $0x10,%esp
}
  10317a:	c9                   	leave  
  10317b:	c3                   	ret    

0010317c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10317c:	55                   	push   %ebp
  10317d:	89 e5                	mov    %esp,%ebp
  10317f:	83 ec 18             	sub    $0x18,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103182:	e8 de f9 ff ff       	call   102b65 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103187:	e8 ce fa ff ff       	call   102c5a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10318c:	e8 0a 04 00 00       	call   10359b <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  103191:	e8 a3 ff ff ff       	call   103139 <boot_alloc_page>
  103196:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10319b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031a0:	83 ec 04             	sub    $0x4,%esp
  1031a3:	68 00 10 00 00       	push   $0x1000
  1031a8:	6a 00                	push   $0x0
  1031aa:	50                   	push   %eax
  1031ab:	e8 1d 21 00 00       	call   1052cd <memset>
  1031b0:	83 c4 10             	add    $0x10,%esp
    boot_cr3 = PADDR(boot_pgdir);
  1031b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031bb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1031c2:	77 17                	ja     1031db <pmm_init+0x5f>
  1031c4:	ff 75 f4             	pushl  -0xc(%ebp)
  1031c7:	68 64 62 10 00       	push   $0x106264
  1031cc:	68 30 01 00 00       	push   $0x130
  1031d1:	68 88 62 10 00       	push   $0x106288
  1031d6:	e8 f2 d1 ff ff       	call   1003cd <__panic>
  1031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031de:	05 00 00 00 40       	add    $0x40000000,%eax
  1031e3:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  1031e8:	e8 d1 03 00 00       	call   1035be <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1031ed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031f2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1031f8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1031fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103200:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103207:	77 17                	ja     103220 <pmm_init+0xa4>
  103209:	ff 75 f0             	pushl  -0x10(%ebp)
  10320c:	68 64 62 10 00       	push   $0x106264
  103211:	68 38 01 00 00       	push   $0x138
  103216:	68 88 62 10 00       	push   $0x106288
  10321b:	e8 ad d1 ff ff       	call   1003cd <__panic>
  103220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103223:	05 00 00 00 40       	add    $0x40000000,%eax
  103228:	83 c8 03             	or     $0x3,%eax
  10322b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10322d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103232:	83 ec 0c             	sub    $0xc,%esp
  103235:	6a 02                	push   $0x2
  103237:	6a 00                	push   $0x0
  103239:	68 00 00 00 38       	push   $0x38000000
  10323e:	68 00 00 00 c0       	push   $0xc0000000
  103243:	50                   	push   %eax
  103244:	e8 07 fe ff ff       	call   103050 <boot_map_segment>
  103249:	83 c4 20             	add    $0x20,%esp

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10324c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103251:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  103257:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10325d:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10325f:	e8 b2 fd ff ff       	call   103016 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  103264:	e8 0a f8 ff ff       	call   102a73 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103269:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10326e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103274:	e8 ab 08 00 00       	call   103b24 <check_boot_pgdir>

    print_pgdir();
  103279:	e8 a1 0c 00 00       	call   103f1f <print_pgdir>

}
  10327e:	90                   	nop
  10327f:	c9                   	leave  
  103280:	c3                   	ret    

00103281 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  103281:	55                   	push   %ebp
  103282:	89 e5                	mov    %esp,%ebp
  103284:	83 ec 28             	sub    $0x28,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
//尝试获取页表，注：typedef uintptr_t pte_t;  
    pde_t *pdep = &pgdir[PDX(la)];   // (1) find page directory entry  
  103287:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328a:	c1 e8 16             	shr    $0x16,%eax
  10328d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103294:	8b 45 08             	mov    0x8(%ebp),%eax
  103297:	01 d0                	add    %edx,%eax
  103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //若获取不成功则执行下面的语句  
	if (!(*pdep & PTE_P)) {               
  10329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329f:	8b 00                	mov    (%eax),%eax
  1032a1:	83 e0 01             	and    $0x1,%eax
  1032a4:	85 c0                	test   %eax,%eax
  1032a6:	0f 85 9f 00 00 00    	jne    10334b <get_pte+0xca>
        	//申请一页  
	    struct Page *page;  
	    if(!create || (page = alloc_page())==NULL){  
  1032ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032b0:	74 16                	je     1032c8 <get_pte+0x47>
  1032b2:	83 ec 0c             	sub    $0xc,%esp
  1032b5:	6a 01                	push   $0x1
  1032b7:	e8 fd f8 ff ff       	call   102bb9 <alloc_pages>
  1032bc:	83 c4 10             	add    $0x10,%esp
  1032bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1032c6:	75 0a                	jne    1032d2 <get_pte+0x51>
	        return NULL;  
  1032c8:	b8 00 00 00 00       	mov    $0x0,%eax
  1032cd:	e9 ca 00 00 00       	jmp    10339c <get_pte+0x11b>
	    }   
	    //引用次数需要加1  
	    set_page_ref(page, 1);  
  1032d2:	83 ec 08             	sub    $0x8,%esp
  1032d5:	6a 01                	push   $0x1
  1032d7:	ff 75 f0             	pushl  -0x10(%ebp)
  1032da:	e8 d6 f6 ff ff       	call   1029b5 <set_page_ref>
  1032df:	83 c4 10             	add    $0x10,%esp
	    //获取页的线性地址                     
            uintptr_t pa = page2pa(page);   
  1032e2:	83 ec 0c             	sub    $0xc,%esp
  1032e5:	ff 75 f0             	pushl  -0x10(%ebp)
  1032e8:	e8 c9 f5 ff ff       	call   1028b6 <page2pa>
  1032ed:	83 c4 10             	add    $0x10,%esp
  1032f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa), 0, PGSIZE);  
  1032f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032fc:	c1 e8 0c             	shr    $0xc,%eax
  1032ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103302:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103307:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10330a:	72 17                	jb     103323 <get_pte+0xa2>
  10330c:	ff 75 e8             	pushl  -0x18(%ebp)
  10330f:	68 c0 61 10 00       	push   $0x1061c0
  103314:	68 8c 01 00 00       	push   $0x18c
  103319:	68 88 62 10 00       	push   $0x106288
  10331e:	e8 aa d0 ff ff       	call   1003cd <__panic>
  103323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103326:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10332b:	83 ec 04             	sub    $0x4,%esp
  10332e:	68 00 10 00 00       	push   $0x1000
  103333:	6a 00                	push   $0x0
  103335:	50                   	push   %eax
  103336:	e8 92 1f 00 00       	call   1052cd <memset>
  10333b:	83 c4 10             	add    $0x10,%esp
            //设置权限  
	    *pdep  = pa | PTE_U | PTE_W | PTE_P;                   
  10333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103341:	83 c8 07             	or     $0x7,%eax
  103344:	89 c2                	mov    %eax,%edx
  103346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103349:	89 10                	mov    %edx,(%eax)
	}  
	//返回页表地址  
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];    
  10334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10334e:	8b 00                	mov    (%eax),%eax
  103350:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103355:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103358:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10335b:	c1 e8 0c             	shr    $0xc,%eax
  10335e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103361:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103366:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103369:	72 17                	jb     103382 <get_pte+0x101>
  10336b:	ff 75 e0             	pushl  -0x20(%ebp)
  10336e:	68 c0 61 10 00       	push   $0x1061c0
  103373:	68 91 01 00 00       	push   $0x191
  103378:	68 88 62 10 00       	push   $0x106288
  10337d:	e8 4b d0 ff ff       	call   1003cd <__panic>
  103382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103385:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10338a:	89 c2                	mov    %eax,%edx
  10338c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10338f:	c1 e8 0c             	shr    $0xc,%eax
  103392:	25 ff 03 00 00       	and    $0x3ff,%eax
  103397:	c1 e0 02             	shl    $0x2,%eax
  10339a:	01 d0                	add    %edx,%eax
}
  10339c:	c9                   	leave  
  10339d:	c3                   	ret    

0010339e <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10339e:	55                   	push   %ebp
  10339f:	89 e5                	mov    %esp,%ebp
  1033a1:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1033a4:	83 ec 04             	sub    $0x4,%esp
  1033a7:	6a 00                	push   $0x0
  1033a9:	ff 75 0c             	pushl  0xc(%ebp)
  1033ac:	ff 75 08             	pushl  0x8(%ebp)
  1033af:	e8 cd fe ff ff       	call   103281 <get_pte>
  1033b4:	83 c4 10             	add    $0x10,%esp
  1033b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1033ba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033be:	74 08                	je     1033c8 <get_page+0x2a>
        *ptep_store = ptep;
  1033c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033c6:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033cc:	74 1f                	je     1033ed <get_page+0x4f>
  1033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033d1:	8b 00                	mov    (%eax),%eax
  1033d3:	83 e0 01             	and    $0x1,%eax
  1033d6:	85 c0                	test   %eax,%eax
  1033d8:	74 13                	je     1033ed <get_page+0x4f>
        return pte2page(*ptep);
  1033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033dd:	8b 00                	mov    (%eax),%eax
  1033df:	83 ec 0c             	sub    $0xc,%esp
  1033e2:	50                   	push   %eax
  1033e3:	e8 6d f5 ff ff       	call   102955 <pte2page>
  1033e8:	83 c4 10             	add    $0x10,%esp
  1033eb:	eb 05                	jmp    1033f2 <get_page+0x54>
    }
    return NULL;
  1033ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033f2:	c9                   	leave  
  1033f3:	c3                   	ret    

001033f4 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1033f4:	55                   	push   %ebp
  1033f5:	89 e5                	mov    %esp,%ebp
  1033f7:	83 ec 18             	sub    $0x18,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

	if (*ptep & PTE_P) {                    //判断页表中该表项是否存在
  1033fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1033fd:	8b 00                	mov    (%eax),%eax
  1033ff:	83 e0 01             	and    $0x1,%eax
  103402:	85 c0                	test   %eax,%eax
  103404:	74 50                	je     103456 <page_remove_pte+0x62>
	    struct Page *page = pte2page(*ptep);
  103406:	8b 45 10             	mov    0x10(%ebp),%eax
  103409:	8b 00                	mov    (%eax),%eax
  10340b:	83 ec 0c             	sub    $0xc,%esp
  10340e:	50                   	push   %eax
  10340f:	e8 41 f5 ff ff       	call   102955 <pte2page>
  103414:	83 c4 10             	add    $0x10,%esp
  103417:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if (page_ref_dec(page) == 0) {      //判断是否只被引用了一次
  10341a:	83 ec 0c             	sub    $0xc,%esp
  10341d:	ff 75 f4             	pushl  -0xc(%ebp)
  103420:	e8 b5 f5 ff ff       	call   1029da <page_ref_dec>
  103425:	83 c4 10             	add    $0x10,%esp
  103428:	85 c0                	test   %eax,%eax
  10342a:	75 10                	jne    10343c <page_remove_pte+0x48>
		free_page(page);                //如果只被引用了一次，那么可以释放掉此页
  10342c:	83 ec 08             	sub    $0x8,%esp
  10342f:	6a 01                	push   $0x1
  103431:	ff 75 f4             	pushl  -0xc(%ebp)
  103434:	e8 be f7 ff ff       	call   102bf7 <free_pages>
  103439:	83 c4 10             	add    $0x10,%esp
	    }
	    *ptep = 0;                          //如果被多次引用，则不能释放此页，只用释放二级页表的表项
  10343c:	8b 45 10             	mov    0x10(%ebp),%eax
  10343f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	    tlb_invalidate(pgdir, la);          //更新页表
  103445:	83 ec 08             	sub    $0x8,%esp
  103448:	ff 75 0c             	pushl  0xc(%ebp)
  10344b:	ff 75 08             	pushl  0x8(%ebp)
  10344e:	e8 f8 00 00 00       	call   10354b <tlb_invalidate>
  103453:	83 c4 10             	add    $0x10,%esp
	}  
}
  103456:	90                   	nop
  103457:	c9                   	leave  
  103458:	c3                   	ret    

00103459 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  103459:	55                   	push   %ebp
  10345a:	89 e5                	mov    %esp,%ebp
  10345c:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10345f:	83 ec 04             	sub    $0x4,%esp
  103462:	6a 00                	push   $0x0
  103464:	ff 75 0c             	pushl  0xc(%ebp)
  103467:	ff 75 08             	pushl  0x8(%ebp)
  10346a:	e8 12 fe ff ff       	call   103281 <get_pte>
  10346f:	83 c4 10             	add    $0x10,%esp
  103472:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103479:	74 14                	je     10348f <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
  10347b:	83 ec 04             	sub    $0x4,%esp
  10347e:	ff 75 f4             	pushl  -0xc(%ebp)
  103481:	ff 75 0c             	pushl  0xc(%ebp)
  103484:	ff 75 08             	pushl  0x8(%ebp)
  103487:	e8 68 ff ff ff       	call   1033f4 <page_remove_pte>
  10348c:	83 c4 10             	add    $0x10,%esp
    }
}
  10348f:	90                   	nop
  103490:	c9                   	leave  
  103491:	c3                   	ret    

00103492 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103492:	55                   	push   %ebp
  103493:	89 e5                	mov    %esp,%ebp
  103495:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103498:	83 ec 04             	sub    $0x4,%esp
  10349b:	6a 01                	push   $0x1
  10349d:	ff 75 10             	pushl  0x10(%ebp)
  1034a0:	ff 75 08             	pushl  0x8(%ebp)
  1034a3:	e8 d9 fd ff ff       	call   103281 <get_pte>
  1034a8:	83 c4 10             	add    $0x10,%esp
  1034ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1034ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034b2:	75 0a                	jne    1034be <page_insert+0x2c>
        return -E_NO_MEM;
  1034b4:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1034b9:	e9 8b 00 00 00       	jmp    103549 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1034be:	83 ec 0c             	sub    $0xc,%esp
  1034c1:	ff 75 0c             	pushl  0xc(%ebp)
  1034c4:	e8 fa f4 ff ff       	call   1029c3 <page_ref_inc>
  1034c9:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
  1034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034cf:	8b 00                	mov    (%eax),%eax
  1034d1:	83 e0 01             	and    $0x1,%eax
  1034d4:	85 c0                	test   %eax,%eax
  1034d6:	74 40                	je     103518 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
  1034d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034db:	8b 00                	mov    (%eax),%eax
  1034dd:	83 ec 0c             	sub    $0xc,%esp
  1034e0:	50                   	push   %eax
  1034e1:	e8 6f f4 ff ff       	call   102955 <pte2page>
  1034e6:	83 c4 10             	add    $0x10,%esp
  1034e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034f2:	75 10                	jne    103504 <page_insert+0x72>
            page_ref_dec(page);
  1034f4:	83 ec 0c             	sub    $0xc,%esp
  1034f7:	ff 75 0c             	pushl  0xc(%ebp)
  1034fa:	e8 db f4 ff ff       	call   1029da <page_ref_dec>
  1034ff:	83 c4 10             	add    $0x10,%esp
  103502:	eb 14                	jmp    103518 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103504:	83 ec 04             	sub    $0x4,%esp
  103507:	ff 75 f4             	pushl  -0xc(%ebp)
  10350a:	ff 75 10             	pushl  0x10(%ebp)
  10350d:	ff 75 08             	pushl  0x8(%ebp)
  103510:	e8 df fe ff ff       	call   1033f4 <page_remove_pte>
  103515:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103518:	83 ec 0c             	sub    $0xc,%esp
  10351b:	ff 75 0c             	pushl  0xc(%ebp)
  10351e:	e8 93 f3 ff ff       	call   1028b6 <page2pa>
  103523:	83 c4 10             	add    $0x10,%esp
  103526:	0b 45 14             	or     0x14(%ebp),%eax
  103529:	83 c8 01             	or     $0x1,%eax
  10352c:	89 c2                	mov    %eax,%edx
  10352e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103531:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103533:	83 ec 08             	sub    $0x8,%esp
  103536:	ff 75 10             	pushl  0x10(%ebp)
  103539:	ff 75 08             	pushl  0x8(%ebp)
  10353c:	e8 0a 00 00 00       	call   10354b <tlb_invalidate>
  103541:	83 c4 10             	add    $0x10,%esp
    return 0;
  103544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103549:	c9                   	leave  
  10354a:	c3                   	ret    

0010354b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10354b:	55                   	push   %ebp
  10354c:	89 e5                	mov    %esp,%ebp
  10354e:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103551:	0f 20 d8             	mov    %cr3,%eax
  103554:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  103557:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  10355a:	8b 45 08             	mov    0x8(%ebp),%eax
  10355d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103560:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103567:	77 17                	ja     103580 <tlb_invalidate+0x35>
  103569:	ff 75 f0             	pushl  -0x10(%ebp)
  10356c:	68 64 62 10 00       	push   $0x106264
  103571:	68 f4 01 00 00       	push   $0x1f4
  103576:	68 88 62 10 00       	push   $0x106288
  10357b:	e8 4d ce ff ff       	call   1003cd <__panic>
  103580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103583:	05 00 00 00 40       	add    $0x40000000,%eax
  103588:	39 c2                	cmp    %eax,%edx
  10358a:	75 0c                	jne    103598 <tlb_invalidate+0x4d>
        invlpg((void *)la);
  10358c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103595:	0f 01 38             	invlpg (%eax)
    }
}
  103598:	90                   	nop
  103599:	c9                   	leave  
  10359a:	c3                   	ret    

0010359b <check_alloc_page>:

static void
check_alloc_page(void) {
  10359b:	55                   	push   %ebp
  10359c:	89 e5                	mov    %esp,%ebp
  10359e:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
  1035a1:	a1 50 89 11 00       	mov    0x118950,%eax
  1035a6:	8b 40 18             	mov    0x18(%eax),%eax
  1035a9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1035ab:	83 ec 0c             	sub    $0xc,%esp
  1035ae:	68 e8 62 10 00       	push   $0x1062e8
  1035b3:	e8 af cc ff ff       	call   100267 <cprintf>
  1035b8:	83 c4 10             	add    $0x10,%esp
}
  1035bb:	90                   	nop
  1035bc:	c9                   	leave  
  1035bd:	c3                   	ret    

001035be <check_pgdir>:

static void
check_pgdir(void) {
  1035be:	55                   	push   %ebp
  1035bf:	89 e5                	mov    %esp,%ebp
  1035c1:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035c4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1035c9:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035ce:	76 19                	jbe    1035e9 <check_pgdir+0x2b>
  1035d0:	68 07 63 10 00       	push   $0x106307
  1035d5:	68 ad 62 10 00       	push   $0x1062ad
  1035da:	68 01 02 00 00       	push   $0x201
  1035df:	68 88 62 10 00       	push   $0x106288
  1035e4:	e8 e4 cd ff ff       	call   1003cd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1035e9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035ee:	85 c0                	test   %eax,%eax
  1035f0:	74 0e                	je     103600 <check_pgdir+0x42>
  1035f2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035f7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1035fc:	85 c0                	test   %eax,%eax
  1035fe:	74 19                	je     103619 <check_pgdir+0x5b>
  103600:	68 24 63 10 00       	push   $0x106324
  103605:	68 ad 62 10 00       	push   $0x1062ad
  10360a:	68 02 02 00 00       	push   $0x202
  10360f:	68 88 62 10 00       	push   $0x106288
  103614:	e8 b4 cd ff ff       	call   1003cd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103619:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10361e:	83 ec 04             	sub    $0x4,%esp
  103621:	6a 00                	push   $0x0
  103623:	6a 00                	push   $0x0
  103625:	50                   	push   %eax
  103626:	e8 73 fd ff ff       	call   10339e <get_page>
  10362b:	83 c4 10             	add    $0x10,%esp
  10362e:	85 c0                	test   %eax,%eax
  103630:	74 19                	je     10364b <check_pgdir+0x8d>
  103632:	68 5c 63 10 00       	push   $0x10635c
  103637:	68 ad 62 10 00       	push   $0x1062ad
  10363c:	68 03 02 00 00       	push   $0x203
  103641:	68 88 62 10 00       	push   $0x106288
  103646:	e8 82 cd ff ff       	call   1003cd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10364b:	83 ec 0c             	sub    $0xc,%esp
  10364e:	6a 01                	push   $0x1
  103650:	e8 64 f5 ff ff       	call   102bb9 <alloc_pages>
  103655:	83 c4 10             	add    $0x10,%esp
  103658:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10365b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103660:	6a 00                	push   $0x0
  103662:	6a 00                	push   $0x0
  103664:	ff 75 f4             	pushl  -0xc(%ebp)
  103667:	50                   	push   %eax
  103668:	e8 25 fe ff ff       	call   103492 <page_insert>
  10366d:	83 c4 10             	add    $0x10,%esp
  103670:	85 c0                	test   %eax,%eax
  103672:	74 19                	je     10368d <check_pgdir+0xcf>
  103674:	68 84 63 10 00       	push   $0x106384
  103679:	68 ad 62 10 00       	push   $0x1062ad
  10367e:	68 07 02 00 00       	push   $0x207
  103683:	68 88 62 10 00       	push   $0x106288
  103688:	e8 40 cd ff ff       	call   1003cd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10368d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103692:	83 ec 04             	sub    $0x4,%esp
  103695:	6a 00                	push   $0x0
  103697:	6a 00                	push   $0x0
  103699:	50                   	push   %eax
  10369a:	e8 e2 fb ff ff       	call   103281 <get_pte>
  10369f:	83 c4 10             	add    $0x10,%esp
  1036a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1036a9:	75 19                	jne    1036c4 <check_pgdir+0x106>
  1036ab:	68 b0 63 10 00       	push   $0x1063b0
  1036b0:	68 ad 62 10 00       	push   $0x1062ad
  1036b5:	68 0a 02 00 00       	push   $0x20a
  1036ba:	68 88 62 10 00       	push   $0x106288
  1036bf:	e8 09 cd ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  1036c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036c7:	8b 00                	mov    (%eax),%eax
  1036c9:	83 ec 0c             	sub    $0xc,%esp
  1036cc:	50                   	push   %eax
  1036cd:	e8 83 f2 ff ff       	call   102955 <pte2page>
  1036d2:	83 c4 10             	add    $0x10,%esp
  1036d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1036d8:	74 19                	je     1036f3 <check_pgdir+0x135>
  1036da:	68 dd 63 10 00       	push   $0x1063dd
  1036df:	68 ad 62 10 00       	push   $0x1062ad
  1036e4:	68 0b 02 00 00       	push   $0x20b
  1036e9:	68 88 62 10 00       	push   $0x106288
  1036ee:	e8 da cc ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 1);
  1036f3:	83 ec 0c             	sub    $0xc,%esp
  1036f6:	ff 75 f4             	pushl  -0xc(%ebp)
  1036f9:	e8 ad f2 ff ff       	call   1029ab <page_ref>
  1036fe:	83 c4 10             	add    $0x10,%esp
  103701:	83 f8 01             	cmp    $0x1,%eax
  103704:	74 19                	je     10371f <check_pgdir+0x161>
  103706:	68 f3 63 10 00       	push   $0x1063f3
  10370b:	68 ad 62 10 00       	push   $0x1062ad
  103710:	68 0c 02 00 00       	push   $0x20c
  103715:	68 88 62 10 00       	push   $0x106288
  10371a:	e8 ae cc ff ff       	call   1003cd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10371f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103724:	8b 00                	mov    (%eax),%eax
  103726:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10372b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10372e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103731:	c1 e8 0c             	shr    $0xc,%eax
  103734:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103737:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10373c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10373f:	72 17                	jb     103758 <check_pgdir+0x19a>
  103741:	ff 75 ec             	pushl  -0x14(%ebp)
  103744:	68 c0 61 10 00       	push   $0x1061c0
  103749:	68 0e 02 00 00       	push   $0x20e
  10374e:	68 88 62 10 00       	push   $0x106288
  103753:	e8 75 cc ff ff       	call   1003cd <__panic>
  103758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10375b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103760:	83 c0 04             	add    $0x4,%eax
  103763:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103766:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10376b:	83 ec 04             	sub    $0x4,%esp
  10376e:	6a 00                	push   $0x0
  103770:	68 00 10 00 00       	push   $0x1000
  103775:	50                   	push   %eax
  103776:	e8 06 fb ff ff       	call   103281 <get_pte>
  10377b:	83 c4 10             	add    $0x10,%esp
  10377e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103781:	74 19                	je     10379c <check_pgdir+0x1de>
  103783:	68 08 64 10 00       	push   $0x106408
  103788:	68 ad 62 10 00       	push   $0x1062ad
  10378d:	68 0f 02 00 00       	push   $0x20f
  103792:	68 88 62 10 00       	push   $0x106288
  103797:	e8 31 cc ff ff       	call   1003cd <__panic>

    p2 = alloc_page();
  10379c:	83 ec 0c             	sub    $0xc,%esp
  10379f:	6a 01                	push   $0x1
  1037a1:	e8 13 f4 ff ff       	call   102bb9 <alloc_pages>
  1037a6:	83 c4 10             	add    $0x10,%esp
  1037a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1037ac:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037b1:	6a 06                	push   $0x6
  1037b3:	68 00 10 00 00       	push   $0x1000
  1037b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  1037bb:	50                   	push   %eax
  1037bc:	e8 d1 fc ff ff       	call   103492 <page_insert>
  1037c1:	83 c4 10             	add    $0x10,%esp
  1037c4:	85 c0                	test   %eax,%eax
  1037c6:	74 19                	je     1037e1 <check_pgdir+0x223>
  1037c8:	68 30 64 10 00       	push   $0x106430
  1037cd:	68 ad 62 10 00       	push   $0x1062ad
  1037d2:	68 12 02 00 00       	push   $0x212
  1037d7:	68 88 62 10 00       	push   $0x106288
  1037dc:	e8 ec cb ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1037e1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037e6:	83 ec 04             	sub    $0x4,%esp
  1037e9:	6a 00                	push   $0x0
  1037eb:	68 00 10 00 00       	push   $0x1000
  1037f0:	50                   	push   %eax
  1037f1:	e8 8b fa ff ff       	call   103281 <get_pte>
  1037f6:	83 c4 10             	add    $0x10,%esp
  1037f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103800:	75 19                	jne    10381b <check_pgdir+0x25d>
  103802:	68 68 64 10 00       	push   $0x106468
  103807:	68 ad 62 10 00       	push   $0x1062ad
  10380c:	68 13 02 00 00       	push   $0x213
  103811:	68 88 62 10 00       	push   $0x106288
  103816:	e8 b2 cb ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_U);
  10381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10381e:	8b 00                	mov    (%eax),%eax
  103820:	83 e0 04             	and    $0x4,%eax
  103823:	85 c0                	test   %eax,%eax
  103825:	75 19                	jne    103840 <check_pgdir+0x282>
  103827:	68 98 64 10 00       	push   $0x106498
  10382c:	68 ad 62 10 00       	push   $0x1062ad
  103831:	68 14 02 00 00       	push   $0x214
  103836:	68 88 62 10 00       	push   $0x106288
  10383b:	e8 8d cb ff ff       	call   1003cd <__panic>
    assert(*ptep & PTE_W);
  103840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103843:	8b 00                	mov    (%eax),%eax
  103845:	83 e0 02             	and    $0x2,%eax
  103848:	85 c0                	test   %eax,%eax
  10384a:	75 19                	jne    103865 <check_pgdir+0x2a7>
  10384c:	68 a6 64 10 00       	push   $0x1064a6
  103851:	68 ad 62 10 00       	push   $0x1062ad
  103856:	68 15 02 00 00       	push   $0x215
  10385b:	68 88 62 10 00       	push   $0x106288
  103860:	e8 68 cb ff ff       	call   1003cd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103865:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10386a:	8b 00                	mov    (%eax),%eax
  10386c:	83 e0 04             	and    $0x4,%eax
  10386f:	85 c0                	test   %eax,%eax
  103871:	75 19                	jne    10388c <check_pgdir+0x2ce>
  103873:	68 b4 64 10 00       	push   $0x1064b4
  103878:	68 ad 62 10 00       	push   $0x1062ad
  10387d:	68 16 02 00 00       	push   $0x216
  103882:	68 88 62 10 00       	push   $0x106288
  103887:	e8 41 cb ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 1);
  10388c:	83 ec 0c             	sub    $0xc,%esp
  10388f:	ff 75 e4             	pushl  -0x1c(%ebp)
  103892:	e8 14 f1 ff ff       	call   1029ab <page_ref>
  103897:	83 c4 10             	add    $0x10,%esp
  10389a:	83 f8 01             	cmp    $0x1,%eax
  10389d:	74 19                	je     1038b8 <check_pgdir+0x2fa>
  10389f:	68 ca 64 10 00       	push   $0x1064ca
  1038a4:	68 ad 62 10 00       	push   $0x1062ad
  1038a9:	68 17 02 00 00       	push   $0x217
  1038ae:	68 88 62 10 00       	push   $0x106288
  1038b3:	e8 15 cb ff ff       	call   1003cd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1038b8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038bd:	6a 00                	push   $0x0
  1038bf:	68 00 10 00 00       	push   $0x1000
  1038c4:	ff 75 f4             	pushl  -0xc(%ebp)
  1038c7:	50                   	push   %eax
  1038c8:	e8 c5 fb ff ff       	call   103492 <page_insert>
  1038cd:	83 c4 10             	add    $0x10,%esp
  1038d0:	85 c0                	test   %eax,%eax
  1038d2:	74 19                	je     1038ed <check_pgdir+0x32f>
  1038d4:	68 dc 64 10 00       	push   $0x1064dc
  1038d9:	68 ad 62 10 00       	push   $0x1062ad
  1038de:	68 19 02 00 00       	push   $0x219
  1038e3:	68 88 62 10 00       	push   $0x106288
  1038e8:	e8 e0 ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p1) == 2);
  1038ed:	83 ec 0c             	sub    $0xc,%esp
  1038f0:	ff 75 f4             	pushl  -0xc(%ebp)
  1038f3:	e8 b3 f0 ff ff       	call   1029ab <page_ref>
  1038f8:	83 c4 10             	add    $0x10,%esp
  1038fb:	83 f8 02             	cmp    $0x2,%eax
  1038fe:	74 19                	je     103919 <check_pgdir+0x35b>
  103900:	68 08 65 10 00       	push   $0x106508
  103905:	68 ad 62 10 00       	push   $0x1062ad
  10390a:	68 1a 02 00 00       	push   $0x21a
  10390f:	68 88 62 10 00       	push   $0x106288
  103914:	e8 b4 ca ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103919:	83 ec 0c             	sub    $0xc,%esp
  10391c:	ff 75 e4             	pushl  -0x1c(%ebp)
  10391f:	e8 87 f0 ff ff       	call   1029ab <page_ref>
  103924:	83 c4 10             	add    $0x10,%esp
  103927:	85 c0                	test   %eax,%eax
  103929:	74 19                	je     103944 <check_pgdir+0x386>
  10392b:	68 1a 65 10 00       	push   $0x10651a
  103930:	68 ad 62 10 00       	push   $0x1062ad
  103935:	68 1b 02 00 00       	push   $0x21b
  10393a:	68 88 62 10 00       	push   $0x106288
  10393f:	e8 89 ca ff ff       	call   1003cd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103944:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103949:	83 ec 04             	sub    $0x4,%esp
  10394c:	6a 00                	push   $0x0
  10394e:	68 00 10 00 00       	push   $0x1000
  103953:	50                   	push   %eax
  103954:	e8 28 f9 ff ff       	call   103281 <get_pte>
  103959:	83 c4 10             	add    $0x10,%esp
  10395c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10395f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103963:	75 19                	jne    10397e <check_pgdir+0x3c0>
  103965:	68 68 64 10 00       	push   $0x106468
  10396a:	68 ad 62 10 00       	push   $0x1062ad
  10396f:	68 1c 02 00 00       	push   $0x21c
  103974:	68 88 62 10 00       	push   $0x106288
  103979:	e8 4f ca ff ff       	call   1003cd <__panic>
    assert(pte2page(*ptep) == p1);
  10397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103981:	8b 00                	mov    (%eax),%eax
  103983:	83 ec 0c             	sub    $0xc,%esp
  103986:	50                   	push   %eax
  103987:	e8 c9 ef ff ff       	call   102955 <pte2page>
  10398c:	83 c4 10             	add    $0x10,%esp
  10398f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103992:	74 19                	je     1039ad <check_pgdir+0x3ef>
  103994:	68 dd 63 10 00       	push   $0x1063dd
  103999:	68 ad 62 10 00       	push   $0x1062ad
  10399e:	68 1d 02 00 00       	push   $0x21d
  1039a3:	68 88 62 10 00       	push   $0x106288
  1039a8:	e8 20 ca ff ff       	call   1003cd <__panic>
    assert((*ptep & PTE_U) == 0);
  1039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039b0:	8b 00                	mov    (%eax),%eax
  1039b2:	83 e0 04             	and    $0x4,%eax
  1039b5:	85 c0                	test   %eax,%eax
  1039b7:	74 19                	je     1039d2 <check_pgdir+0x414>
  1039b9:	68 2c 65 10 00       	push   $0x10652c
  1039be:	68 ad 62 10 00       	push   $0x1062ad
  1039c3:	68 1e 02 00 00       	push   $0x21e
  1039c8:	68 88 62 10 00       	push   $0x106288
  1039cd:	e8 fb c9 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, 0x0);
  1039d2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039d7:	83 ec 08             	sub    $0x8,%esp
  1039da:	6a 00                	push   $0x0
  1039dc:	50                   	push   %eax
  1039dd:	e8 77 fa ff ff       	call   103459 <page_remove>
  1039e2:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
  1039e5:	83 ec 0c             	sub    $0xc,%esp
  1039e8:	ff 75 f4             	pushl  -0xc(%ebp)
  1039eb:	e8 bb ef ff ff       	call   1029ab <page_ref>
  1039f0:	83 c4 10             	add    $0x10,%esp
  1039f3:	83 f8 01             	cmp    $0x1,%eax
  1039f6:	74 19                	je     103a11 <check_pgdir+0x453>
  1039f8:	68 f3 63 10 00       	push   $0x1063f3
  1039fd:	68 ad 62 10 00       	push   $0x1062ad
  103a02:	68 21 02 00 00       	push   $0x221
  103a07:	68 88 62 10 00       	push   $0x106288
  103a0c:	e8 bc c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103a11:	83 ec 0c             	sub    $0xc,%esp
  103a14:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a17:	e8 8f ef ff ff       	call   1029ab <page_ref>
  103a1c:	83 c4 10             	add    $0x10,%esp
  103a1f:	85 c0                	test   %eax,%eax
  103a21:	74 19                	je     103a3c <check_pgdir+0x47e>
  103a23:	68 1a 65 10 00       	push   $0x10651a
  103a28:	68 ad 62 10 00       	push   $0x1062ad
  103a2d:	68 22 02 00 00       	push   $0x222
  103a32:	68 88 62 10 00       	push   $0x106288
  103a37:	e8 91 c9 ff ff       	call   1003cd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103a3c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a41:	83 ec 08             	sub    $0x8,%esp
  103a44:	68 00 10 00 00       	push   $0x1000
  103a49:	50                   	push   %eax
  103a4a:	e8 0a fa ff ff       	call   103459 <page_remove>
  103a4f:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
  103a52:	83 ec 0c             	sub    $0xc,%esp
  103a55:	ff 75 f4             	pushl  -0xc(%ebp)
  103a58:	e8 4e ef ff ff       	call   1029ab <page_ref>
  103a5d:	83 c4 10             	add    $0x10,%esp
  103a60:	85 c0                	test   %eax,%eax
  103a62:	74 19                	je     103a7d <check_pgdir+0x4bf>
  103a64:	68 41 65 10 00       	push   $0x106541
  103a69:	68 ad 62 10 00       	push   $0x1062ad
  103a6e:	68 25 02 00 00       	push   $0x225
  103a73:	68 88 62 10 00       	push   $0x106288
  103a78:	e8 50 c9 ff ff       	call   1003cd <__panic>
    assert(page_ref(p2) == 0);
  103a7d:	83 ec 0c             	sub    $0xc,%esp
  103a80:	ff 75 e4             	pushl  -0x1c(%ebp)
  103a83:	e8 23 ef ff ff       	call   1029ab <page_ref>
  103a88:	83 c4 10             	add    $0x10,%esp
  103a8b:	85 c0                	test   %eax,%eax
  103a8d:	74 19                	je     103aa8 <check_pgdir+0x4ea>
  103a8f:	68 1a 65 10 00       	push   $0x10651a
  103a94:	68 ad 62 10 00       	push   $0x1062ad
  103a99:	68 26 02 00 00       	push   $0x226
  103a9e:	68 88 62 10 00       	push   $0x106288
  103aa3:	e8 25 c9 ff ff       	call   1003cd <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103aa8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103aad:	8b 00                	mov    (%eax),%eax
  103aaf:	83 ec 0c             	sub    $0xc,%esp
  103ab2:	50                   	push   %eax
  103ab3:	e8 d7 ee ff ff       	call   10298f <pde2page>
  103ab8:	83 c4 10             	add    $0x10,%esp
  103abb:	83 ec 0c             	sub    $0xc,%esp
  103abe:	50                   	push   %eax
  103abf:	e8 e7 ee ff ff       	call   1029ab <page_ref>
  103ac4:	83 c4 10             	add    $0x10,%esp
  103ac7:	83 f8 01             	cmp    $0x1,%eax
  103aca:	74 19                	je     103ae5 <check_pgdir+0x527>
  103acc:	68 54 65 10 00       	push   $0x106554
  103ad1:	68 ad 62 10 00       	push   $0x1062ad
  103ad6:	68 28 02 00 00       	push   $0x228
  103adb:	68 88 62 10 00       	push   $0x106288
  103ae0:	e8 e8 c8 ff ff       	call   1003cd <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103ae5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103aea:	8b 00                	mov    (%eax),%eax
  103aec:	83 ec 0c             	sub    $0xc,%esp
  103aef:	50                   	push   %eax
  103af0:	e8 9a ee ff ff       	call   10298f <pde2page>
  103af5:	83 c4 10             	add    $0x10,%esp
  103af8:	83 ec 08             	sub    $0x8,%esp
  103afb:	6a 01                	push   $0x1
  103afd:	50                   	push   %eax
  103afe:	e8 f4 f0 ff ff       	call   102bf7 <free_pages>
  103b03:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103b06:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103b11:	83 ec 0c             	sub    $0xc,%esp
  103b14:	68 7b 65 10 00       	push   $0x10657b
  103b19:	e8 49 c7 ff ff       	call   100267 <cprintf>
  103b1e:	83 c4 10             	add    $0x10,%esp
}
  103b21:	90                   	nop
  103b22:	c9                   	leave  
  103b23:	c3                   	ret    

00103b24 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103b24:	55                   	push   %ebp
  103b25:	89 e5                	mov    %esp,%ebp
  103b27:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103b31:	e9 a3 00 00 00       	jmp    103bd9 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b3f:	c1 e8 0c             	shr    $0xc,%eax
  103b42:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b45:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103b4a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103b4d:	72 17                	jb     103b66 <check_boot_pgdir+0x42>
  103b4f:	ff 75 f0             	pushl  -0x10(%ebp)
  103b52:	68 c0 61 10 00       	push   $0x1061c0
  103b57:	68 34 02 00 00       	push   $0x234
  103b5c:	68 88 62 10 00       	push   $0x106288
  103b61:	e8 67 c8 ff ff       	call   1003cd <__panic>
  103b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b69:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103b6e:	89 c2                	mov    %eax,%edx
  103b70:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b75:	83 ec 04             	sub    $0x4,%esp
  103b78:	6a 00                	push   $0x0
  103b7a:	52                   	push   %edx
  103b7b:	50                   	push   %eax
  103b7c:	e8 00 f7 ff ff       	call   103281 <get_pte>
  103b81:	83 c4 10             	add    $0x10,%esp
  103b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103b87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103b8b:	75 19                	jne    103ba6 <check_boot_pgdir+0x82>
  103b8d:	68 98 65 10 00       	push   $0x106598
  103b92:	68 ad 62 10 00       	push   $0x1062ad
  103b97:	68 34 02 00 00       	push   $0x234
  103b9c:	68 88 62 10 00       	push   $0x106288
  103ba1:	e8 27 c8 ff ff       	call   1003cd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103ba9:	8b 00                	mov    (%eax),%eax
  103bab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bb0:	89 c2                	mov    %eax,%edx
  103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bb5:	39 c2                	cmp    %eax,%edx
  103bb7:	74 19                	je     103bd2 <check_boot_pgdir+0xae>
  103bb9:	68 d5 65 10 00       	push   $0x1065d5
  103bbe:	68 ad 62 10 00       	push   $0x1062ad
  103bc3:	68 35 02 00 00       	push   $0x235
  103bc8:	68 88 62 10 00       	push   $0x106288
  103bcd:	e8 fb c7 ff ff       	call   1003cd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103bd2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103bd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103bdc:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103be1:	39 c2                	cmp    %eax,%edx
  103be3:	0f 82 4d ff ff ff    	jb     103b36 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103be9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103bee:	05 ac 0f 00 00       	add    $0xfac,%eax
  103bf3:	8b 00                	mov    (%eax),%eax
  103bf5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103bfa:	89 c2                	mov    %eax,%edx
  103bfc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c04:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103c0b:	77 17                	ja     103c24 <check_boot_pgdir+0x100>
  103c0d:	ff 75 e4             	pushl  -0x1c(%ebp)
  103c10:	68 64 62 10 00       	push   $0x106264
  103c15:	68 38 02 00 00       	push   $0x238
  103c1a:	68 88 62 10 00       	push   $0x106288
  103c1f:	e8 a9 c7 ff ff       	call   1003cd <__panic>
  103c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c27:	05 00 00 00 40       	add    $0x40000000,%eax
  103c2c:	39 c2                	cmp    %eax,%edx
  103c2e:	74 19                	je     103c49 <check_boot_pgdir+0x125>
  103c30:	68 ec 65 10 00       	push   $0x1065ec
  103c35:	68 ad 62 10 00       	push   $0x1062ad
  103c3a:	68 38 02 00 00       	push   $0x238
  103c3f:	68 88 62 10 00       	push   $0x106288
  103c44:	e8 84 c7 ff ff       	call   1003cd <__panic>

    assert(boot_pgdir[0] == 0);
  103c49:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c4e:	8b 00                	mov    (%eax),%eax
  103c50:	85 c0                	test   %eax,%eax
  103c52:	74 19                	je     103c6d <check_boot_pgdir+0x149>
  103c54:	68 20 66 10 00       	push   $0x106620
  103c59:	68 ad 62 10 00       	push   $0x1062ad
  103c5e:	68 3a 02 00 00       	push   $0x23a
  103c63:	68 88 62 10 00       	push   $0x106288
  103c68:	e8 60 c7 ff ff       	call   1003cd <__panic>

    struct Page *p;
    p = alloc_page();
  103c6d:	83 ec 0c             	sub    $0xc,%esp
  103c70:	6a 01                	push   $0x1
  103c72:	e8 42 ef ff ff       	call   102bb9 <alloc_pages>
  103c77:	83 c4 10             	add    $0x10,%esp
  103c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103c7d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c82:	6a 02                	push   $0x2
  103c84:	68 00 01 00 00       	push   $0x100
  103c89:	ff 75 e0             	pushl  -0x20(%ebp)
  103c8c:	50                   	push   %eax
  103c8d:	e8 00 f8 ff ff       	call   103492 <page_insert>
  103c92:	83 c4 10             	add    $0x10,%esp
  103c95:	85 c0                	test   %eax,%eax
  103c97:	74 19                	je     103cb2 <check_boot_pgdir+0x18e>
  103c99:	68 34 66 10 00       	push   $0x106634
  103c9e:	68 ad 62 10 00       	push   $0x1062ad
  103ca3:	68 3e 02 00 00       	push   $0x23e
  103ca8:	68 88 62 10 00       	push   $0x106288
  103cad:	e8 1b c7 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 1);
  103cb2:	83 ec 0c             	sub    $0xc,%esp
  103cb5:	ff 75 e0             	pushl  -0x20(%ebp)
  103cb8:	e8 ee ec ff ff       	call   1029ab <page_ref>
  103cbd:	83 c4 10             	add    $0x10,%esp
  103cc0:	83 f8 01             	cmp    $0x1,%eax
  103cc3:	74 19                	je     103cde <check_boot_pgdir+0x1ba>
  103cc5:	68 62 66 10 00       	push   $0x106662
  103cca:	68 ad 62 10 00       	push   $0x1062ad
  103ccf:	68 3f 02 00 00       	push   $0x23f
  103cd4:	68 88 62 10 00       	push   $0x106288
  103cd9:	e8 ef c6 ff ff       	call   1003cd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103cde:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103ce3:	6a 02                	push   $0x2
  103ce5:	68 00 11 00 00       	push   $0x1100
  103cea:	ff 75 e0             	pushl  -0x20(%ebp)
  103ced:	50                   	push   %eax
  103cee:	e8 9f f7 ff ff       	call   103492 <page_insert>
  103cf3:	83 c4 10             	add    $0x10,%esp
  103cf6:	85 c0                	test   %eax,%eax
  103cf8:	74 19                	je     103d13 <check_boot_pgdir+0x1ef>
  103cfa:	68 74 66 10 00       	push   $0x106674
  103cff:	68 ad 62 10 00       	push   $0x1062ad
  103d04:	68 40 02 00 00       	push   $0x240
  103d09:	68 88 62 10 00       	push   $0x106288
  103d0e:	e8 ba c6 ff ff       	call   1003cd <__panic>
    assert(page_ref(p) == 2);
  103d13:	83 ec 0c             	sub    $0xc,%esp
  103d16:	ff 75 e0             	pushl  -0x20(%ebp)
  103d19:	e8 8d ec ff ff       	call   1029ab <page_ref>
  103d1e:	83 c4 10             	add    $0x10,%esp
  103d21:	83 f8 02             	cmp    $0x2,%eax
  103d24:	74 19                	je     103d3f <check_boot_pgdir+0x21b>
  103d26:	68 ab 66 10 00       	push   $0x1066ab
  103d2b:	68 ad 62 10 00       	push   $0x1062ad
  103d30:	68 41 02 00 00       	push   $0x241
  103d35:	68 88 62 10 00       	push   $0x106288
  103d3a:	e8 8e c6 ff ff       	call   1003cd <__panic>

    const char *str = "ucore: Hello world!!";
  103d3f:	c7 45 dc bc 66 10 00 	movl   $0x1066bc,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103d46:	83 ec 08             	sub    $0x8,%esp
  103d49:	ff 75 dc             	pushl  -0x24(%ebp)
  103d4c:	68 00 01 00 00       	push   $0x100
  103d51:	e8 9e 12 00 00       	call   104ff4 <strcpy>
  103d56:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103d59:	83 ec 08             	sub    $0x8,%esp
  103d5c:	68 00 11 00 00       	push   $0x1100
  103d61:	68 00 01 00 00       	push   $0x100
  103d66:	e8 03 13 00 00       	call   10506e <strcmp>
  103d6b:	83 c4 10             	add    $0x10,%esp
  103d6e:	85 c0                	test   %eax,%eax
  103d70:	74 19                	je     103d8b <check_boot_pgdir+0x267>
  103d72:	68 d4 66 10 00       	push   $0x1066d4
  103d77:	68 ad 62 10 00       	push   $0x1062ad
  103d7c:	68 45 02 00 00       	push   $0x245
  103d81:	68 88 62 10 00       	push   $0x106288
  103d86:	e8 42 c6 ff ff       	call   1003cd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103d8b:	83 ec 0c             	sub    $0xc,%esp
  103d8e:	ff 75 e0             	pushl  -0x20(%ebp)
  103d91:	e8 7a eb ff ff       	call   102910 <page2kva>
  103d96:	83 c4 10             	add    $0x10,%esp
  103d99:	05 00 01 00 00       	add    $0x100,%eax
  103d9e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103da1:	83 ec 0c             	sub    $0xc,%esp
  103da4:	68 00 01 00 00       	push   $0x100
  103da9:	e8 ee 11 00 00       	call   104f9c <strlen>
  103dae:	83 c4 10             	add    $0x10,%esp
  103db1:	85 c0                	test   %eax,%eax
  103db3:	74 19                	je     103dce <check_boot_pgdir+0x2aa>
  103db5:	68 0c 67 10 00       	push   $0x10670c
  103dba:	68 ad 62 10 00       	push   $0x1062ad
  103dbf:	68 48 02 00 00       	push   $0x248
  103dc4:	68 88 62 10 00       	push   $0x106288
  103dc9:	e8 ff c5 ff ff       	call   1003cd <__panic>

    free_page(p);
  103dce:	83 ec 08             	sub    $0x8,%esp
  103dd1:	6a 01                	push   $0x1
  103dd3:	ff 75 e0             	pushl  -0x20(%ebp)
  103dd6:	e8 1c ee ff ff       	call   102bf7 <free_pages>
  103ddb:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
  103dde:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103de3:	8b 00                	mov    (%eax),%eax
  103de5:	83 ec 0c             	sub    $0xc,%esp
  103de8:	50                   	push   %eax
  103de9:	e8 a1 eb ff ff       	call   10298f <pde2page>
  103dee:	83 c4 10             	add    $0x10,%esp
  103df1:	83 ec 08             	sub    $0x8,%esp
  103df4:	6a 01                	push   $0x1
  103df6:	50                   	push   %eax
  103df7:	e8 fb ed ff ff       	call   102bf7 <free_pages>
  103dfc:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
  103dff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103e04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103e0a:	83 ec 0c             	sub    $0xc,%esp
  103e0d:	68 30 67 10 00       	push   $0x106730
  103e12:	e8 50 c4 ff ff       	call   100267 <cprintf>
  103e17:	83 c4 10             	add    $0x10,%esp
}
  103e1a:	90                   	nop
  103e1b:	c9                   	leave  
  103e1c:	c3                   	ret    

00103e1d <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103e1d:	55                   	push   %ebp
  103e1e:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103e20:	8b 45 08             	mov    0x8(%ebp),%eax
  103e23:	83 e0 04             	and    $0x4,%eax
  103e26:	85 c0                	test   %eax,%eax
  103e28:	74 07                	je     103e31 <perm2str+0x14>
  103e2a:	b8 75 00 00 00       	mov    $0x75,%eax
  103e2f:	eb 05                	jmp    103e36 <perm2str+0x19>
  103e31:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103e36:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103e3b:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103e42:	8b 45 08             	mov    0x8(%ebp),%eax
  103e45:	83 e0 02             	and    $0x2,%eax
  103e48:	85 c0                	test   %eax,%eax
  103e4a:	74 07                	je     103e53 <perm2str+0x36>
  103e4c:	b8 77 00 00 00       	mov    $0x77,%eax
  103e51:	eb 05                	jmp    103e58 <perm2str+0x3b>
  103e53:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103e58:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103e5d:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103e64:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103e69:	5d                   	pop    %ebp
  103e6a:	c3                   	ret    

00103e6b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103e6b:	55                   	push   %ebp
  103e6c:	89 e5                	mov    %esp,%ebp
  103e6e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103e71:	8b 45 10             	mov    0x10(%ebp),%eax
  103e74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103e77:	72 0e                	jb     103e87 <get_pgtable_items+0x1c>
        return 0;
  103e79:	b8 00 00 00 00       	mov    $0x0,%eax
  103e7e:	e9 9a 00 00 00       	jmp    103f1d <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103e83:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103e87:	8b 45 10             	mov    0x10(%ebp),%eax
  103e8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103e8d:	73 18                	jae    103ea7 <get_pgtable_items+0x3c>
  103e8f:	8b 45 10             	mov    0x10(%ebp),%eax
  103e92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103e99:	8b 45 14             	mov    0x14(%ebp),%eax
  103e9c:	01 d0                	add    %edx,%eax
  103e9e:	8b 00                	mov    (%eax),%eax
  103ea0:	83 e0 01             	and    $0x1,%eax
  103ea3:	85 c0                	test   %eax,%eax
  103ea5:	74 dc                	je     103e83 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  103eaa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103ead:	73 69                	jae    103f18 <get_pgtable_items+0xad>
        if (left_store != NULL) {
  103eaf:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103eb3:	74 08                	je     103ebd <get_pgtable_items+0x52>
            *left_store = start;
  103eb5:	8b 45 18             	mov    0x18(%ebp),%eax
  103eb8:	8b 55 10             	mov    0x10(%ebp),%edx
  103ebb:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  103ec0:	8d 50 01             	lea    0x1(%eax),%edx
  103ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  103ec6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  103ed0:	01 d0                	add    %edx,%eax
  103ed2:	8b 00                	mov    (%eax),%eax
  103ed4:	83 e0 07             	and    $0x7,%eax
  103ed7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103eda:	eb 04                	jmp    103ee0 <get_pgtable_items+0x75>
            start ++;
  103edc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  103ee3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103ee6:	73 1d                	jae    103f05 <get_pgtable_items+0x9a>
  103ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  103eeb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103ef2:	8b 45 14             	mov    0x14(%ebp),%eax
  103ef5:	01 d0                	add    %edx,%eax
  103ef7:	8b 00                	mov    (%eax),%eax
  103ef9:	83 e0 07             	and    $0x7,%eax
  103efc:	89 c2                	mov    %eax,%edx
  103efe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f01:	39 c2                	cmp    %eax,%edx
  103f03:	74 d7                	je     103edc <get_pgtable_items+0x71>
            start ++;
        }
        if (right_store != NULL) {
  103f05:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103f09:	74 08                	je     103f13 <get_pgtable_items+0xa8>
            *right_store = start;
  103f0b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103f0e:	8b 55 10             	mov    0x10(%ebp),%edx
  103f11:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f16:	eb 05                	jmp    103f1d <get_pgtable_items+0xb2>
    }
    return 0;
  103f18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103f1d:	c9                   	leave  
  103f1e:	c3                   	ret    

00103f1f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103f1f:	55                   	push   %ebp
  103f20:	89 e5                	mov    %esp,%ebp
  103f22:	57                   	push   %edi
  103f23:	56                   	push   %esi
  103f24:	53                   	push   %ebx
  103f25:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103f28:	83 ec 0c             	sub    $0xc,%esp
  103f2b:	68 50 67 10 00       	push   $0x106750
  103f30:	e8 32 c3 ff ff       	call   100267 <cprintf>
  103f35:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
  103f38:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103f3f:	e9 e5 00 00 00       	jmp    104029 <print_pgdir+0x10a>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103f44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103f47:	83 ec 0c             	sub    $0xc,%esp
  103f4a:	50                   	push   %eax
  103f4b:	e8 cd fe ff ff       	call   103e1d <perm2str>
  103f50:	83 c4 10             	add    $0x10,%esp
  103f53:	89 c7                	mov    %eax,%edi
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103f55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f5b:	29 c2                	sub    %eax,%edx
  103f5d:	89 d0                	mov    %edx,%eax
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103f5f:	c1 e0 16             	shl    $0x16,%eax
  103f62:	89 c3                	mov    %eax,%ebx
  103f64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103f67:	c1 e0 16             	shl    $0x16,%eax
  103f6a:	89 c1                	mov    %eax,%ecx
  103f6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f6f:	c1 e0 16             	shl    $0x16,%eax
  103f72:	89 c2                	mov    %eax,%edx
  103f74:	8b 75 dc             	mov    -0x24(%ebp),%esi
  103f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f7a:	29 c6                	sub    %eax,%esi
  103f7c:	89 f0                	mov    %esi,%eax
  103f7e:	83 ec 08             	sub    $0x8,%esp
  103f81:	57                   	push   %edi
  103f82:	53                   	push   %ebx
  103f83:	51                   	push   %ecx
  103f84:	52                   	push   %edx
  103f85:	50                   	push   %eax
  103f86:	68 81 67 10 00       	push   $0x106781
  103f8b:	e8 d7 c2 ff ff       	call   100267 <cprintf>
  103f90:	83 c4 20             	add    $0x20,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  103f93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f96:	c1 e0 0a             	shl    $0xa,%eax
  103f99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103f9c:	eb 4f                	jmp    103fed <print_pgdir+0xce>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103fa1:	83 ec 0c             	sub    $0xc,%esp
  103fa4:	50                   	push   %eax
  103fa5:	e8 73 fe ff ff       	call   103e1d <perm2str>
  103faa:	83 c4 10             	add    $0x10,%esp
  103fad:	89 c7                	mov    %eax,%edi
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  103faf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103fb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fb5:	29 c2                	sub    %eax,%edx
  103fb7:	89 d0                	mov    %edx,%eax
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103fb9:	c1 e0 0c             	shl    $0xc,%eax
  103fbc:	89 c3                	mov    %eax,%ebx
  103fbe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103fc1:	c1 e0 0c             	shl    $0xc,%eax
  103fc4:	89 c1                	mov    %eax,%ecx
  103fc6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fc9:	c1 e0 0c             	shl    $0xc,%eax
  103fcc:	89 c2                	mov    %eax,%edx
  103fce:	8b 75 d4             	mov    -0x2c(%ebp),%esi
  103fd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103fd4:	29 c6                	sub    %eax,%esi
  103fd6:	89 f0                	mov    %esi,%eax
  103fd8:	83 ec 08             	sub    $0x8,%esp
  103fdb:	57                   	push   %edi
  103fdc:	53                   	push   %ebx
  103fdd:	51                   	push   %ecx
  103fde:	52                   	push   %edx
  103fdf:	50                   	push   %eax
  103fe0:	68 a0 67 10 00       	push   $0x1067a0
  103fe5:	e8 7d c2 ff ff       	call   100267 <cprintf>
  103fea:	83 c4 20             	add    $0x20,%esp
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103fed:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  103ff2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103ff5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ff8:	89 d3                	mov    %edx,%ebx
  103ffa:	c1 e3 0a             	shl    $0xa,%ebx
  103ffd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104000:	89 d1                	mov    %edx,%ecx
  104002:	c1 e1 0a             	shl    $0xa,%ecx
  104005:	83 ec 08             	sub    $0x8,%esp
  104008:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10400b:	52                   	push   %edx
  10400c:	8d 55 d8             	lea    -0x28(%ebp),%edx
  10400f:	52                   	push   %edx
  104010:	56                   	push   %esi
  104011:	50                   	push   %eax
  104012:	53                   	push   %ebx
  104013:	51                   	push   %ecx
  104014:	e8 52 fe ff ff       	call   103e6b <get_pgtable_items>
  104019:	83 c4 20             	add    $0x20,%esp
  10401c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10401f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104023:	0f 85 75 ff ff ff    	jne    103f9e <print_pgdir+0x7f>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104029:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10402e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104031:	83 ec 08             	sub    $0x8,%esp
  104034:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104037:	52                   	push   %edx
  104038:	8d 55 e0             	lea    -0x20(%ebp),%edx
  10403b:	52                   	push   %edx
  10403c:	51                   	push   %ecx
  10403d:	50                   	push   %eax
  10403e:	68 00 04 00 00       	push   $0x400
  104043:	6a 00                	push   $0x0
  104045:	e8 21 fe ff ff       	call   103e6b <get_pgtable_items>
  10404a:	83 c4 20             	add    $0x20,%esp
  10404d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104050:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104054:	0f 85 ea fe ff ff    	jne    103f44 <print_pgdir+0x25>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10405a:	83 ec 0c             	sub    $0xc,%esp
  10405d:	68 c4 67 10 00       	push   $0x1067c4
  104062:	e8 00 c2 ff ff       	call   100267 <cprintf>
  104067:	83 c4 10             	add    $0x10,%esp
}
  10406a:	90                   	nop
  10406b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  10406e:	5b                   	pop    %ebx
  10406f:	5e                   	pop    %esi
  104070:	5f                   	pop    %edi
  104071:	5d                   	pop    %ebp
  104072:	c3                   	ret    

00104073 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  104073:	55                   	push   %ebp
  104074:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104076:	8b 45 08             	mov    0x8(%ebp),%eax
  104079:	8b 15 58 89 11 00    	mov    0x118958,%edx
  10407f:	29 d0                	sub    %edx,%eax
  104081:	c1 f8 02             	sar    $0x2,%eax
  104084:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10408a:	5d                   	pop    %ebp
  10408b:	c3                   	ret    

0010408c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10408c:	55                   	push   %ebp
  10408d:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
  10408f:	ff 75 08             	pushl  0x8(%ebp)
  104092:	e8 dc ff ff ff       	call   104073 <page2ppn>
  104097:	83 c4 04             	add    $0x4,%esp
  10409a:	c1 e0 0c             	shl    $0xc,%eax
}
  10409d:	c9                   	leave  
  10409e:	c3                   	ret    

0010409f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10409f:	55                   	push   %ebp
  1040a0:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1040a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1040a5:	8b 00                	mov    (%eax),%eax
}
  1040a7:	5d                   	pop    %ebp
  1040a8:	c3                   	ret    

001040a9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1040a9:	55                   	push   %ebp
  1040aa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1040ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1040af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040b2:	89 10                	mov    %edx,(%eax)
}
  1040b4:	90                   	nop
  1040b5:	5d                   	pop    %ebp
  1040b6:	c3                   	ret    

001040b7 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1040b7:	55                   	push   %ebp
  1040b8:	89 e5                	mov    %esp,%ebp
  1040ba:	83 ec 10             	sub    $0x10,%esp
  1040bd:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1040c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1040ca:	89 50 04             	mov    %edx,0x4(%eax)
  1040cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040d0:	8b 50 04             	mov    0x4(%eax),%edx
  1040d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040d6:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1040d8:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  1040df:	00 00 00 
}
  1040e2:	90                   	nop
  1040e3:	c9                   	leave  
  1040e4:	c3                   	ret    

001040e5 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1040e5:	55                   	push   %ebp
  1040e6:	89 e5                	mov    %esp,%ebp
  1040e8:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);  
  1040eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1040ef:	75 16                	jne    104107 <default_init_memmap+0x22>
  1040f1:	68 f8 67 10 00       	push   $0x1067f8
  1040f6:	68 fe 67 10 00       	push   $0x1067fe
  1040fb:	6a 46                	push   $0x46
  1040fd:	68 13 68 10 00       	push   $0x106813
  104102:	e8 c6 c2 ff ff       	call   1003cd <__panic>
    struct Page *p = base;  
  104107:	8b 45 08             	mov    0x8(%ebp),%eax
  10410a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  
  10410d:	e9 cd 00 00 00       	jmp    1041df <default_init_memmap+0xfa>
        //检查此页是否为保留页   
        assert(PageReserved(p));  
  104112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104115:	83 c0 04             	add    $0x4,%eax
  104118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  10411f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104122:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104125:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104128:	0f a3 10             	bt     %edx,(%eax)
  10412b:	19 c0                	sbb    %eax,%eax
  10412d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104130:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104134:	0f 95 c0             	setne  %al
  104137:	0f b6 c0             	movzbl %al,%eax
  10413a:	85 c0                	test   %eax,%eax
  10413c:	75 16                	jne    104154 <default_init_memmap+0x6f>
  10413e:	68 29 68 10 00       	push   $0x106829
  104143:	68 fe 67 10 00       	push   $0x1067fe
  104148:	6a 4a                	push   $0x4a
  10414a:	68 13 68 10 00       	push   $0x106813
  10414f:	e8 79 c2 ff ff       	call   1003cd <__panic>
        //设置标志位   
        p->flags = p->property = 0;  
  104154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104157:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10415e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104161:	8b 50 08             	mov    0x8(%eax),%edx
  104164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104167:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);  
  10416a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10416d:	83 c0 04             	add    $0x4,%eax
  104170:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  104177:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10417a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10417d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104180:	0f ab 10             	bts    %edx,(%eax)
        //清零此页的引用计数   
        set_page_ref(p, 0);  
  104183:	83 ec 08             	sub    $0x8,%esp
  104186:	6a 00                	push   $0x0
  104188:	ff 75 f4             	pushl  -0xc(%ebp)
  10418b:	e8 19 ff ff ff       	call   1040a9 <set_page_ref>
  104190:	83 c4 10             	add    $0x10,%esp
        //将空闲页插入到链表  
        list_add_before(&free_list, &(p->page_link));   
  104193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104196:	83 c0 0c             	add    $0xc,%eax
  104199:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
  1041a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1041a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041a6:	8b 00                	mov    (%eax),%eax
  1041a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041ab:	89 55 d8             	mov    %edx,-0x28(%ebp)
  1041ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1041b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1041b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1041bd:	89 10                	mov    %edx,(%eax)
  1041bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041c2:	8b 10                	mov    (%eax),%edx
  1041c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041c7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1041ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1041cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041d0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1041d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1041d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041d9:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  
    struct Page *p = base;  
    for (; p != base + n; p ++) {  
  1041db:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1041df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041e2:	89 d0                	mov    %edx,%eax
  1041e4:	c1 e0 02             	shl    $0x2,%eax
  1041e7:	01 d0                	add    %edx,%eax
  1041e9:	c1 e0 02             	shl    $0x2,%eax
  1041ec:	89 c2                	mov    %eax,%edx
  1041ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1041f1:	01 d0                	add    %edx,%eax
  1041f3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1041f6:	0f 85 16 ff ff ff    	jne    104112 <default_init_memmap+0x2d>
        //清零此页的引用计数   
        set_page_ref(p, 0);  
        //将空闲页插入到链表  
        list_add_before(&free_list, &(p->page_link));   
    }  
    base->property = n;  
  1041fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1041ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  104202:	89 50 08             	mov    %edx,0x8(%eax)
    //计算空闲页总数   
    nr_free += n;  
  104205:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10420b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10420e:	01 d0                	add    %edx,%eax
  104210:	a3 64 89 11 00       	mov    %eax,0x118964
}
  104215:	90                   	nop
  104216:	c9                   	leave  
  104217:	c3                   	ret    

00104218 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104218:	55                   	push   %ebp
  104219:	89 e5                	mov    %esp,%ebp
  10421b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);  
  10421e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104222:	75 16                	jne    10423a <default_alloc_pages+0x22>
  104224:	68 f8 67 10 00       	push   $0x1067f8
  104229:	68 fe 67 10 00       	push   $0x1067fe
  10422e:	6a 5a                	push   $0x5a
  104230:	68 13 68 10 00       	push   $0x106813
  104235:	e8 93 c1 ff ff       	call   1003cd <__panic>
    if (n > nr_free) {  
  10423a:	a1 64 89 11 00       	mov    0x118964,%eax
  10423f:	3b 45 08             	cmp    0x8(%ebp),%eax
  104242:	73 0a                	jae    10424e <default_alloc_pages+0x36>
        return NULL;  
  104244:	b8 00 00 00 00       	mov    $0x0,%eax
  104249:	e9 37 01 00 00       	jmp    104385 <default_alloc_pages+0x16d>
    }  
    list_entry_t  *len;  
    list_entry_t  *le = &free_list;  
  10424e:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
    //在空闲链表中寻找合适大小的页块  
    while ((le = list_next(le)) != &free_list) {  
  104255:	e9 0a 01 00 00       	jmp    104364 <default_alloc_pages+0x14c>
        struct Page *p = le2page(le, page_link);  
  10425a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10425d:	83 e8 0c             	sub    $0xc,%eax
  104260:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //找到了合适大小的页块  
        if (p->property >= n) {  
  104263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104266:	8b 40 08             	mov    0x8(%eax),%eax
  104269:	3b 45 08             	cmp    0x8(%ebp),%eax
  10426c:	0f 82 f2 00 00 00    	jb     104364 <default_alloc_pages+0x14c>
	    int i;  
	    for(i=0;i<n;i++){  
  104272:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104279:	eb 7c                	jmp    1042f7 <default_alloc_pages+0xdf>
  10427b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10427e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104281:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104284:	8b 40 04             	mov    0x4(%eax),%eax
	        len = list_next(le);  
  104287:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		//让pp指向分配的那一页  
		//le2page宏可以根据链表元素获得对应的Page指针p  
		struct Page *pp = le2page(le, page_link);  
  10428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10428d:	83 e8 0c             	sub    $0xc,%eax
  104290:	89 45 e0             	mov    %eax,-0x20(%ebp)
		//设置每一页的标志位  
		SetPageReserved(pp);  
  104293:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104296:	83 c0 04             	add    $0x4,%eax
  104299:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  1042a0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  1042a3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1042a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042a9:	0f ab 10             	bts    %edx,(%eax)
		ClearPageProperty(pp);  
  1042ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042af:	83 c0 04             	add    $0x4,%eax
  1042b2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  1042b9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1042bc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042c2:	0f b3 10             	btr    %edx,(%eax)
  1042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c8:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1042cb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042ce:	8b 40 04             	mov    0x4(%eax),%eax
  1042d1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1042d4:	8b 12                	mov    (%edx),%edx
  1042d6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1042d9:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1042dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042df:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1042e2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1042e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1042e8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1042eb:	89 10                	mov    %edx,(%eax)
		//清除free_list中的链接  
		list_del(le);  
		le = len;  
  1042ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list) {  
        struct Page *p = le2page(le, page_link);  
    //找到了合适大小的页块  
        if (p->property >= n) {  
	    int i;  
	    for(i=0;i<n;i++){  
  1042f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  1042f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  1042fd:	0f 82 78 ff ff ff    	jb     10427b <default_alloc_pages+0x63>
		ClearPageProperty(pp);  
		//清除free_list中的链接  
		list_del(le);  
		le = len;  
	    }  
	if(p->property>n){  
  104303:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104306:	8b 40 08             	mov    0x8(%eax),%eax
  104309:	3b 45 08             	cmp    0x8(%ebp),%eax
  10430c:	76 12                	jbe    104320 <default_alloc_pages+0x108>
	    //分割的页需要重新设置空闲大小  
	    (le2page(le,page_link))->property = p->property - n;  
  10430e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104311:	8d 50 f4             	lea    -0xc(%eax),%edx
  104314:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104317:	8b 40 08             	mov    0x8(%eax),%eax
  10431a:	2b 45 08             	sub    0x8(%ebp),%eax
  10431d:	89 42 08             	mov    %eax,0x8(%edx)
	}  
	//第一页重置标志位  
	ClearPageProperty(p);  
  104320:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104323:	83 c0 04             	add    $0x4,%eax
  104326:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  10432d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  104330:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104333:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104336:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(p);  
  104339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10433c:	83 c0 04             	add    $0x4,%eax
  10433f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  104346:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104349:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10434c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10434f:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;  
  104352:	a1 64 89 11 00       	mov    0x118964,%eax
  104357:	2b 45 08             	sub    0x8(%ebp),%eax
  10435a:	a3 64 89 11 00       	mov    %eax,0x118964
	return p;  
  10435f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104362:	eb 21                	jmp    104385 <default_alloc_pages+0x16d>
  104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104367:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10436a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10436d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;  
    }  
    list_entry_t  *len;  
    list_entry_t  *le = &free_list;  
    //在空闲链表中寻找合适大小的页块  
    while ((le = list_next(le)) != &free_list) {  
  104370:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104373:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  10437a:	0f 85 da fe ff ff    	jne    10425a <default_alloc_pages+0x42>
	nr_free -= n;  
	return p;  
    }  
}  
//否则分配失败  
    return NULL;  
  104380:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104385:	c9                   	leave  
  104386:	c3                   	ret    

00104387 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104387:	55                   	push   %ebp
  104388:	89 e5                	mov    %esp,%ebp
  10438a:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10438d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104391:	75 19                	jne    1043ac <default_free_pages+0x25>
  104393:	68 f8 67 10 00       	push   $0x1067f8
  104398:	68 fe 67 10 00       	push   $0x1067fe
  10439d:	68 83 00 00 00       	push   $0x83
  1043a2:	68 13 68 10 00       	push   $0x106813
  1043a7:	e8 21 c0 ff ff       	call   1003cd <__panic>
    assert(PageReserved(base));
  1043ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1043af:	83 c0 04             	add    $0x4,%eax
  1043b2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1043b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1043bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043c2:	0f a3 10             	bt     %edx,(%eax)
  1043c5:	19 c0                	sbb    %eax,%eax
  1043c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
    return oldbit != 0;
  1043ca:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1043ce:	0f 95 c0             	setne  %al
  1043d1:	0f b6 c0             	movzbl %al,%eax
  1043d4:	85 c0                	test   %eax,%eax
  1043d6:	75 19                	jne    1043f1 <default_free_pages+0x6a>
  1043d8:	68 39 68 10 00       	push   $0x106839
  1043dd:	68 fe 67 10 00       	push   $0x1067fe
  1043e2:	68 84 00 00 00       	push   $0x84
  1043e7:	68 13 68 10 00       	push   $0x106813
  1043ec:	e8 dc bf ff ff       	call   1003cd <__panic>

    list_entry_t *le = &free_list;
  1043f1:	c7 45 f4 5c 89 11 00 	movl   $0x11895c,-0xc(%ebp)
    struct Page * p;
//查找该插入的位置le 
    while((le=list_next(le)) != &free_list) {
  1043f8:	eb 11                	jmp    10440b <default_free_pages+0x84>
      p = le2page(le, page_link);
  1043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043fd:	83 e8 0c             	sub    $0xc,%eax
  104400:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
  104403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104406:	3b 45 08             	cmp    0x8(%ebp),%eax
  104409:	77 1a                	ja     104425 <default_free_pages+0x9e>
  10440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104414:	8b 40 04             	mov    0x4(%eax),%eax
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
//查找该插入的位置le 
    while((le=list_next(le)) != &free_list) {
  104417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10441a:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104421:	75 d7                	jne    1043fa <default_free_pages+0x73>
  104423:	eb 01                	jmp    104426 <default_free_pages+0x9f>
      p = le2page(le, page_link);
      if(p>base){
        break;
  104425:	90                   	nop
      }
    }
//向le之前插入n个页（空闲），并设置标志位  
    for(p=base;p<base+n;p++){
  104426:	8b 45 08             	mov    0x8(%ebp),%eax
  104429:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10442c:	eb 4b                	jmp    104479 <default_free_pages+0xf2>
      list_add_before(le, &(p->page_link));
  10442e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104431:	8d 50 0c             	lea    0xc(%eax),%edx
  104434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104437:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10443a:	89 55 c8             	mov    %edx,-0x38(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10443d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104440:	8b 00                	mov    (%eax),%eax
  104442:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104445:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104448:	89 45 c0             	mov    %eax,-0x40(%ebp)
  10444b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10444e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104451:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104454:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104457:	89 10                	mov    %edx,(%eax)
  104459:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10445c:	8b 10                	mov    (%eax),%edx
  10445e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104461:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104464:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104467:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10446a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10446d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104470:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104473:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
//向le之前插入n个页（空闲），并设置标志位  
    for(p=base;p<base+n;p++){
  104475:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  104479:	8b 55 0c             	mov    0xc(%ebp),%edx
  10447c:	89 d0                	mov    %edx,%eax
  10447e:	c1 e0 02             	shl    $0x2,%eax
  104481:	01 d0                	add    %edx,%eax
  104483:	c1 e0 02             	shl    $0x2,%eax
  104486:	89 c2                	mov    %eax,%edx
  104488:	8b 45 08             	mov    0x8(%ebp),%eax
  10448b:	01 d0                	add    %edx,%eax
  10448d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104490:	77 9c                	ja     10442e <default_free_pages+0xa7>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  104492:	8b 45 08             	mov    0x8(%ebp),%eax
  104495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  10449c:	83 ec 08             	sub    $0x8,%esp
  10449f:	6a 00                	push   $0x0
  1044a1:	ff 75 08             	pushl  0x8(%ebp)
  1044a4:	e8 00 fc ff ff       	call   1040a9 <set_page_ref>
  1044a9:	83 c4 10             	add    $0x10,%esp
    ClearPageProperty(base);
  1044ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1044af:	83 c0 04             	add    $0x4,%eax
  1044b2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  1044b9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044bc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1044bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044c2:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  1044c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1044c8:	83 c0 04             	add    $0x4,%eax
  1044cb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1044d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1044d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1044db:	0f ab 10             	bts    %edx,(%eax)
//将页块信息记录在头部 
    base->property = n;
  1044de:	8b 45 08             	mov    0x8(%ebp),%eax
  1044e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044e4:	89 50 08             	mov    %edx,0x8(%eax)
//是否需要合并  
//向高地址合并  
    p = le2page(le,page_link) ;
  1044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ea:	83 e8 0c             	sub    $0xc,%eax
  1044ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
  1044f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044f3:	89 d0                	mov    %edx,%eax
  1044f5:	c1 e0 02             	shl    $0x2,%eax
  1044f8:	01 d0                	add    %edx,%eax
  1044fa:	c1 e0 02             	shl    $0x2,%eax
  1044fd:	89 c2                	mov    %eax,%edx
  1044ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104502:	01 d0                	add    %edx,%eax
  104504:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104507:	75 1e                	jne    104527 <default_free_pages+0x1a0>
      base->property += p->property;
  104509:	8b 45 08             	mov    0x8(%ebp),%eax
  10450c:	8b 50 08             	mov    0x8(%eax),%edx
  10450f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104512:	8b 40 08             	mov    0x8(%eax),%eax
  104515:	01 c2                	add    %eax,%edx
  104517:	8b 45 08             	mov    0x8(%ebp),%eax
  10451a:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
  10451d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104520:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
//向低地址合并  
    le = list_prev(&(base->page_link));
  104527:	8b 45 08             	mov    0x8(%ebp),%eax
  10452a:	83 c0 0c             	add    $0xc,%eax
  10452d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  104530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104533:	8b 00                	mov    (%eax),%eax
  104535:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10453b:	83 e8 0c             	sub    $0xc,%eax
  10453e:	89 45 f0             	mov    %eax,-0x10(%ebp)
//若低地址已分配则不需要合并
    if(le!=&free_list && p==base-1){
  104541:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  104548:	74 57                	je     1045a1 <default_free_pages+0x21a>
  10454a:	8b 45 08             	mov    0x8(%ebp),%eax
  10454d:	83 e8 14             	sub    $0x14,%eax
  104550:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104553:	75 4c                	jne    1045a1 <default_free_pages+0x21a>
      while(le!=&free_list){
  104555:	eb 41                	jmp    104598 <default_free_pages+0x211>
        if(p->property){
  104557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10455a:	8b 40 08             	mov    0x8(%eax),%eax
  10455d:	85 c0                	test   %eax,%eax
  10455f:	74 20                	je     104581 <default_free_pages+0x1fa>
          p->property += base->property;
  104561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104564:	8b 50 08             	mov    0x8(%eax),%edx
  104567:	8b 45 08             	mov    0x8(%ebp),%eax
  10456a:	8b 40 08             	mov    0x8(%eax),%eax
  10456d:	01 c2                	add    %eax,%edx
  10456f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104572:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
  104575:	8b 45 08             	mov    0x8(%ebp),%eax
  104578:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
  10457f:	eb 20                	jmp    1045a1 <default_free_pages+0x21a>
  104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104584:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104587:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10458a:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
  10458c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
  10458f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104592:	83 e8 0c             	sub    $0xc,%eax
  104595:	89 45 f0             	mov    %eax,-0x10(%ebp)
//向低地址合并  
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
//若低地址已分配则不需要合并
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
  104598:	81 7d f4 5c 89 11 00 	cmpl   $0x11895c,-0xc(%ebp)
  10459f:	75 b6                	jne    104557 <default_free_pages+0x1d0>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
  1045a1:	8b 15 64 89 11 00    	mov    0x118964,%edx
  1045a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045aa:	01 d0                	add    %edx,%eax
  1045ac:	a3 64 89 11 00       	mov    %eax,0x118964
    return ;
  1045b1:	90                   	nop
}
  1045b2:	c9                   	leave  
  1045b3:	c3                   	ret    

001045b4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1045b4:	55                   	push   %ebp
  1045b5:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1045b7:	a1 64 89 11 00       	mov    0x118964,%eax
}
  1045bc:	5d                   	pop    %ebp
  1045bd:	c3                   	ret    

001045be <basic_check>:

static void
basic_check(void) {
  1045be:	55                   	push   %ebp
  1045bf:	89 e5                	mov    %esp,%ebp
  1045c1:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1045c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1045cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1045d7:	83 ec 0c             	sub    $0xc,%esp
  1045da:	6a 01                	push   $0x1
  1045dc:	e8 d8 e5 ff ff       	call   102bb9 <alloc_pages>
  1045e1:	83 c4 10             	add    $0x10,%esp
  1045e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1045e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1045eb:	75 19                	jne    104606 <basic_check+0x48>
  1045ed:	68 4c 68 10 00       	push   $0x10684c
  1045f2:	68 fe 67 10 00       	push   $0x1067fe
  1045f7:	68 bd 00 00 00       	push   $0xbd
  1045fc:	68 13 68 10 00       	push   $0x106813
  104601:	e8 c7 bd ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  104606:	83 ec 0c             	sub    $0xc,%esp
  104609:	6a 01                	push   $0x1
  10460b:	e8 a9 e5 ff ff       	call   102bb9 <alloc_pages>
  104610:	83 c4 10             	add    $0x10,%esp
  104613:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104616:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10461a:	75 19                	jne    104635 <basic_check+0x77>
  10461c:	68 68 68 10 00       	push   $0x106868
  104621:	68 fe 67 10 00       	push   $0x1067fe
  104626:	68 be 00 00 00       	push   $0xbe
  10462b:	68 13 68 10 00       	push   $0x106813
  104630:	e8 98 bd ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  104635:	83 ec 0c             	sub    $0xc,%esp
  104638:	6a 01                	push   $0x1
  10463a:	e8 7a e5 ff ff       	call   102bb9 <alloc_pages>
  10463f:	83 c4 10             	add    $0x10,%esp
  104642:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104649:	75 19                	jne    104664 <basic_check+0xa6>
  10464b:	68 84 68 10 00       	push   $0x106884
  104650:	68 fe 67 10 00       	push   $0x1067fe
  104655:	68 bf 00 00 00       	push   $0xbf
  10465a:	68 13 68 10 00       	push   $0x106813
  10465f:	e8 69 bd ff ff       	call   1003cd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104664:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104667:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10466a:	74 10                	je     10467c <basic_check+0xbe>
  10466c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10466f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104672:	74 08                	je     10467c <basic_check+0xbe>
  104674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104677:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10467a:	75 19                	jne    104695 <basic_check+0xd7>
  10467c:	68 a0 68 10 00       	push   $0x1068a0
  104681:	68 fe 67 10 00       	push   $0x1067fe
  104686:	68 c1 00 00 00       	push   $0xc1
  10468b:	68 13 68 10 00       	push   $0x106813
  104690:	e8 38 bd ff ff       	call   1003cd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104695:	83 ec 0c             	sub    $0xc,%esp
  104698:	ff 75 ec             	pushl  -0x14(%ebp)
  10469b:	e8 ff f9 ff ff       	call   10409f <page_ref>
  1046a0:	83 c4 10             	add    $0x10,%esp
  1046a3:	85 c0                	test   %eax,%eax
  1046a5:	75 24                	jne    1046cb <basic_check+0x10d>
  1046a7:	83 ec 0c             	sub    $0xc,%esp
  1046aa:	ff 75 f0             	pushl  -0x10(%ebp)
  1046ad:	e8 ed f9 ff ff       	call   10409f <page_ref>
  1046b2:	83 c4 10             	add    $0x10,%esp
  1046b5:	85 c0                	test   %eax,%eax
  1046b7:	75 12                	jne    1046cb <basic_check+0x10d>
  1046b9:	83 ec 0c             	sub    $0xc,%esp
  1046bc:	ff 75 f4             	pushl  -0xc(%ebp)
  1046bf:	e8 db f9 ff ff       	call   10409f <page_ref>
  1046c4:	83 c4 10             	add    $0x10,%esp
  1046c7:	85 c0                	test   %eax,%eax
  1046c9:	74 19                	je     1046e4 <basic_check+0x126>
  1046cb:	68 c4 68 10 00       	push   $0x1068c4
  1046d0:	68 fe 67 10 00       	push   $0x1067fe
  1046d5:	68 c2 00 00 00       	push   $0xc2
  1046da:	68 13 68 10 00       	push   $0x106813
  1046df:	e8 e9 bc ff ff       	call   1003cd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1046e4:	83 ec 0c             	sub    $0xc,%esp
  1046e7:	ff 75 ec             	pushl  -0x14(%ebp)
  1046ea:	e8 9d f9 ff ff       	call   10408c <page2pa>
  1046ef:	83 c4 10             	add    $0x10,%esp
  1046f2:	89 c2                	mov    %eax,%edx
  1046f4:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046f9:	c1 e0 0c             	shl    $0xc,%eax
  1046fc:	39 c2                	cmp    %eax,%edx
  1046fe:	72 19                	jb     104719 <basic_check+0x15b>
  104700:	68 00 69 10 00       	push   $0x106900
  104705:	68 fe 67 10 00       	push   $0x1067fe
  10470a:	68 c4 00 00 00       	push   $0xc4
  10470f:	68 13 68 10 00       	push   $0x106813
  104714:	e8 b4 bc ff ff       	call   1003cd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104719:	83 ec 0c             	sub    $0xc,%esp
  10471c:	ff 75 f0             	pushl  -0x10(%ebp)
  10471f:	e8 68 f9 ff ff       	call   10408c <page2pa>
  104724:	83 c4 10             	add    $0x10,%esp
  104727:	89 c2                	mov    %eax,%edx
  104729:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10472e:	c1 e0 0c             	shl    $0xc,%eax
  104731:	39 c2                	cmp    %eax,%edx
  104733:	72 19                	jb     10474e <basic_check+0x190>
  104735:	68 1d 69 10 00       	push   $0x10691d
  10473a:	68 fe 67 10 00       	push   $0x1067fe
  10473f:	68 c5 00 00 00       	push   $0xc5
  104744:	68 13 68 10 00       	push   $0x106813
  104749:	e8 7f bc ff ff       	call   1003cd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10474e:	83 ec 0c             	sub    $0xc,%esp
  104751:	ff 75 f4             	pushl  -0xc(%ebp)
  104754:	e8 33 f9 ff ff       	call   10408c <page2pa>
  104759:	83 c4 10             	add    $0x10,%esp
  10475c:	89 c2                	mov    %eax,%edx
  10475e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104763:	c1 e0 0c             	shl    $0xc,%eax
  104766:	39 c2                	cmp    %eax,%edx
  104768:	72 19                	jb     104783 <basic_check+0x1c5>
  10476a:	68 3a 69 10 00       	push   $0x10693a
  10476f:	68 fe 67 10 00       	push   $0x1067fe
  104774:	68 c6 00 00 00       	push   $0xc6
  104779:	68 13 68 10 00       	push   $0x106813
  10477e:	e8 4a bc ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104783:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104788:	8b 15 60 89 11 00    	mov    0x118960,%edx
  10478e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104791:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104794:	c7 45 e4 5c 89 11 00 	movl   $0x11895c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10479b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10479e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1047a1:	89 50 04             	mov    %edx,0x4(%eax)
  1047a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047a7:	8b 50 04             	mov    0x4(%eax),%edx
  1047aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047ad:	89 10                	mov    %edx,(%eax)
  1047af:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1047b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1047b9:	8b 40 04             	mov    0x4(%eax),%eax
  1047bc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1047bf:	0f 94 c0             	sete   %al
  1047c2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1047c5:	85 c0                	test   %eax,%eax
  1047c7:	75 19                	jne    1047e2 <basic_check+0x224>
  1047c9:	68 57 69 10 00       	push   $0x106957
  1047ce:	68 fe 67 10 00       	push   $0x1067fe
  1047d3:	68 ca 00 00 00       	push   $0xca
  1047d8:	68 13 68 10 00       	push   $0x106813
  1047dd:	e8 eb bb ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  1047e2:	a1 64 89 11 00       	mov    0x118964,%eax
  1047e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1047ea:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  1047f1:	00 00 00 

    assert(alloc_page() == NULL);
  1047f4:	83 ec 0c             	sub    $0xc,%esp
  1047f7:	6a 01                	push   $0x1
  1047f9:	e8 bb e3 ff ff       	call   102bb9 <alloc_pages>
  1047fe:	83 c4 10             	add    $0x10,%esp
  104801:	85 c0                	test   %eax,%eax
  104803:	74 19                	je     10481e <basic_check+0x260>
  104805:	68 6e 69 10 00       	push   $0x10696e
  10480a:	68 fe 67 10 00       	push   $0x1067fe
  10480f:	68 cf 00 00 00       	push   $0xcf
  104814:	68 13 68 10 00       	push   $0x106813
  104819:	e8 af bb ff ff       	call   1003cd <__panic>

    free_page(p0);
  10481e:	83 ec 08             	sub    $0x8,%esp
  104821:	6a 01                	push   $0x1
  104823:	ff 75 ec             	pushl  -0x14(%ebp)
  104826:	e8 cc e3 ff ff       	call   102bf7 <free_pages>
  10482b:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  10482e:	83 ec 08             	sub    $0x8,%esp
  104831:	6a 01                	push   $0x1
  104833:	ff 75 f0             	pushl  -0x10(%ebp)
  104836:	e8 bc e3 ff ff       	call   102bf7 <free_pages>
  10483b:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  10483e:	83 ec 08             	sub    $0x8,%esp
  104841:	6a 01                	push   $0x1
  104843:	ff 75 f4             	pushl  -0xc(%ebp)
  104846:	e8 ac e3 ff ff       	call   102bf7 <free_pages>
  10484b:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
  10484e:	a1 64 89 11 00       	mov    0x118964,%eax
  104853:	83 f8 03             	cmp    $0x3,%eax
  104856:	74 19                	je     104871 <basic_check+0x2b3>
  104858:	68 83 69 10 00       	push   $0x106983
  10485d:	68 fe 67 10 00       	push   $0x1067fe
  104862:	68 d4 00 00 00       	push   $0xd4
  104867:	68 13 68 10 00       	push   $0x106813
  10486c:	e8 5c bb ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) != NULL);
  104871:	83 ec 0c             	sub    $0xc,%esp
  104874:	6a 01                	push   $0x1
  104876:	e8 3e e3 ff ff       	call   102bb9 <alloc_pages>
  10487b:	83 c4 10             	add    $0x10,%esp
  10487e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104881:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104885:	75 19                	jne    1048a0 <basic_check+0x2e2>
  104887:	68 4c 68 10 00       	push   $0x10684c
  10488c:	68 fe 67 10 00       	push   $0x1067fe
  104891:	68 d6 00 00 00       	push   $0xd6
  104896:	68 13 68 10 00       	push   $0x106813
  10489b:	e8 2d bb ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_page()) != NULL);
  1048a0:	83 ec 0c             	sub    $0xc,%esp
  1048a3:	6a 01                	push   $0x1
  1048a5:	e8 0f e3 ff ff       	call   102bb9 <alloc_pages>
  1048aa:	83 c4 10             	add    $0x10,%esp
  1048ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048b4:	75 19                	jne    1048cf <basic_check+0x311>
  1048b6:	68 68 68 10 00       	push   $0x106868
  1048bb:	68 fe 67 10 00       	push   $0x1067fe
  1048c0:	68 d7 00 00 00       	push   $0xd7
  1048c5:	68 13 68 10 00       	push   $0x106813
  1048ca:	e8 fe ba ff ff       	call   1003cd <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048cf:	83 ec 0c             	sub    $0xc,%esp
  1048d2:	6a 01                	push   $0x1
  1048d4:	e8 e0 e2 ff ff       	call   102bb9 <alloc_pages>
  1048d9:	83 c4 10             	add    $0x10,%esp
  1048dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048e3:	75 19                	jne    1048fe <basic_check+0x340>
  1048e5:	68 84 68 10 00       	push   $0x106884
  1048ea:	68 fe 67 10 00       	push   $0x1067fe
  1048ef:	68 d8 00 00 00       	push   $0xd8
  1048f4:	68 13 68 10 00       	push   $0x106813
  1048f9:	e8 cf ba ff ff       	call   1003cd <__panic>

    assert(alloc_page() == NULL);
  1048fe:	83 ec 0c             	sub    $0xc,%esp
  104901:	6a 01                	push   $0x1
  104903:	e8 b1 e2 ff ff       	call   102bb9 <alloc_pages>
  104908:	83 c4 10             	add    $0x10,%esp
  10490b:	85 c0                	test   %eax,%eax
  10490d:	74 19                	je     104928 <basic_check+0x36a>
  10490f:	68 6e 69 10 00       	push   $0x10696e
  104914:	68 fe 67 10 00       	push   $0x1067fe
  104919:	68 da 00 00 00       	push   $0xda
  10491e:	68 13 68 10 00       	push   $0x106813
  104923:	e8 a5 ba ff ff       	call   1003cd <__panic>

    free_page(p0);
  104928:	83 ec 08             	sub    $0x8,%esp
  10492b:	6a 01                	push   $0x1
  10492d:	ff 75 ec             	pushl  -0x14(%ebp)
  104930:	e8 c2 e2 ff ff       	call   102bf7 <free_pages>
  104935:	83 c4 10             	add    $0x10,%esp
  104938:	c7 45 e8 5c 89 11 00 	movl   $0x11895c,-0x18(%ebp)
  10493f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104942:	8b 40 04             	mov    0x4(%eax),%eax
  104945:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104948:	0f 94 c0             	sete   %al
  10494b:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10494e:	85 c0                	test   %eax,%eax
  104950:	74 19                	je     10496b <basic_check+0x3ad>
  104952:	68 90 69 10 00       	push   $0x106990
  104957:	68 fe 67 10 00       	push   $0x1067fe
  10495c:	68 dd 00 00 00       	push   $0xdd
  104961:	68 13 68 10 00       	push   $0x106813
  104966:	e8 62 ba ff ff       	call   1003cd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10496b:	83 ec 0c             	sub    $0xc,%esp
  10496e:	6a 01                	push   $0x1
  104970:	e8 44 e2 ff ff       	call   102bb9 <alloc_pages>
  104975:	83 c4 10             	add    $0x10,%esp
  104978:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10497b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10497e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104981:	74 19                	je     10499c <basic_check+0x3de>
  104983:	68 a8 69 10 00       	push   $0x1069a8
  104988:	68 fe 67 10 00       	push   $0x1067fe
  10498d:	68 e0 00 00 00       	push   $0xe0
  104992:	68 13 68 10 00       	push   $0x106813
  104997:	e8 31 ba ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  10499c:	83 ec 0c             	sub    $0xc,%esp
  10499f:	6a 01                	push   $0x1
  1049a1:	e8 13 e2 ff ff       	call   102bb9 <alloc_pages>
  1049a6:	83 c4 10             	add    $0x10,%esp
  1049a9:	85 c0                	test   %eax,%eax
  1049ab:	74 19                	je     1049c6 <basic_check+0x408>
  1049ad:	68 6e 69 10 00       	push   $0x10696e
  1049b2:	68 fe 67 10 00       	push   $0x1067fe
  1049b7:	68 e1 00 00 00       	push   $0xe1
  1049bc:	68 13 68 10 00       	push   $0x106813
  1049c1:	e8 07 ba ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  1049c6:	a1 64 89 11 00       	mov    0x118964,%eax
  1049cb:	85 c0                	test   %eax,%eax
  1049cd:	74 19                	je     1049e8 <basic_check+0x42a>
  1049cf:	68 c1 69 10 00       	push   $0x1069c1
  1049d4:	68 fe 67 10 00       	push   $0x1067fe
  1049d9:	68 e3 00 00 00       	push   $0xe3
  1049de:	68 13 68 10 00       	push   $0x106813
  1049e3:	e8 e5 b9 ff ff       	call   1003cd <__panic>
    free_list = free_list_store;
  1049e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1049ee:	a3 5c 89 11 00       	mov    %eax,0x11895c
  1049f3:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  1049f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1049fc:	a3 64 89 11 00       	mov    %eax,0x118964

    free_page(p);
  104a01:	83 ec 08             	sub    $0x8,%esp
  104a04:	6a 01                	push   $0x1
  104a06:	ff 75 dc             	pushl  -0x24(%ebp)
  104a09:	e8 e9 e1 ff ff       	call   102bf7 <free_pages>
  104a0e:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
  104a11:	83 ec 08             	sub    $0x8,%esp
  104a14:	6a 01                	push   $0x1
  104a16:	ff 75 f0             	pushl  -0x10(%ebp)
  104a19:	e8 d9 e1 ff ff       	call   102bf7 <free_pages>
  104a1e:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104a21:	83 ec 08             	sub    $0x8,%esp
  104a24:	6a 01                	push   $0x1
  104a26:	ff 75 f4             	pushl  -0xc(%ebp)
  104a29:	e8 c9 e1 ff ff       	call   102bf7 <free_pages>
  104a2e:	83 c4 10             	add    $0x10,%esp
}
  104a31:	90                   	nop
  104a32:	c9                   	leave  
  104a33:	c3                   	ret    

00104a34 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104a34:	55                   	push   %ebp
  104a35:	89 e5                	mov    %esp,%ebp
  104a37:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
  104a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104a4b:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104a52:	eb 60                	jmp    104ab4 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
  104a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a57:	83 e8 0c             	sub    $0xc,%eax
  104a5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104a5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a60:	83 c0 04             	add    $0x4,%eax
  104a63:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104a6a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a6d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104a70:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104a73:	0f a3 10             	bt     %edx,(%eax)
  104a76:	19 c0                	sbb    %eax,%eax
  104a78:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104a7b:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104a7f:	0f 95 c0             	setne  %al
  104a82:	0f b6 c0             	movzbl %al,%eax
  104a85:	85 c0                	test   %eax,%eax
  104a87:	75 19                	jne    104aa2 <default_check+0x6e>
  104a89:	68 ce 69 10 00       	push   $0x1069ce
  104a8e:	68 fe 67 10 00       	push   $0x1067fe
  104a93:	68 f4 00 00 00       	push   $0xf4
  104a98:	68 13 68 10 00       	push   $0x106813
  104a9d:	e8 2b b9 ff ff       	call   1003cd <__panic>
        count ++, total += p->property;
  104aa2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104aa9:	8b 50 08             	mov    0x8(%eax),%edx
  104aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aaf:	01 d0                	add    %edx,%eax
  104ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ab7:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104aba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104abd:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104ac3:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104aca:	75 88                	jne    104a54 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104acc:	e8 5b e1 ff ff       	call   102c2c <nr_free_pages>
  104ad1:	89 c2                	mov    %eax,%edx
  104ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad6:	39 c2                	cmp    %eax,%edx
  104ad8:	74 19                	je     104af3 <default_check+0xbf>
  104ada:	68 de 69 10 00       	push   $0x1069de
  104adf:	68 fe 67 10 00       	push   $0x1067fe
  104ae4:	68 f7 00 00 00       	push   $0xf7
  104ae9:	68 13 68 10 00       	push   $0x106813
  104aee:	e8 da b8 ff ff       	call   1003cd <__panic>

    basic_check();
  104af3:	e8 c6 fa ff ff       	call   1045be <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104af8:	83 ec 0c             	sub    $0xc,%esp
  104afb:	6a 05                	push   $0x5
  104afd:	e8 b7 e0 ff ff       	call   102bb9 <alloc_pages>
  104b02:	83 c4 10             	add    $0x10,%esp
  104b05:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104b08:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104b0c:	75 19                	jne    104b27 <default_check+0xf3>
  104b0e:	68 f7 69 10 00       	push   $0x1069f7
  104b13:	68 fe 67 10 00       	push   $0x1067fe
  104b18:	68 fc 00 00 00       	push   $0xfc
  104b1d:	68 13 68 10 00       	push   $0x106813
  104b22:	e8 a6 b8 ff ff       	call   1003cd <__panic>
    assert(!PageProperty(p0));
  104b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b2a:	83 c0 04             	add    $0x4,%eax
  104b2d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104b34:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b37:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104b3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104b3d:	0f a3 10             	bt     %edx,(%eax)
  104b40:	19 c0                	sbb    %eax,%eax
  104b42:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104b45:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104b49:	0f 95 c0             	setne  %al
  104b4c:	0f b6 c0             	movzbl %al,%eax
  104b4f:	85 c0                	test   %eax,%eax
  104b51:	74 19                	je     104b6c <default_check+0x138>
  104b53:	68 02 6a 10 00       	push   $0x106a02
  104b58:	68 fe 67 10 00       	push   $0x1067fe
  104b5d:	68 fd 00 00 00       	push   $0xfd
  104b62:	68 13 68 10 00       	push   $0x106813
  104b67:	e8 61 b8 ff ff       	call   1003cd <__panic>

    list_entry_t free_list_store = free_list;
  104b6c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104b71:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104b77:	89 45 80             	mov    %eax,-0x80(%ebp)
  104b7a:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104b7d:	c7 45 d0 5c 89 11 00 	movl   $0x11895c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104b84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b87:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104b8a:	89 50 04             	mov    %edx,0x4(%eax)
  104b8d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b90:	8b 50 04             	mov    0x4(%eax),%edx
  104b93:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104b96:	89 10                	mov    %edx,(%eax)
  104b98:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104b9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104ba2:	8b 40 04             	mov    0x4(%eax),%eax
  104ba5:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104ba8:	0f 94 c0             	sete   %al
  104bab:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104bae:	85 c0                	test   %eax,%eax
  104bb0:	75 19                	jne    104bcb <default_check+0x197>
  104bb2:	68 57 69 10 00       	push   $0x106957
  104bb7:	68 fe 67 10 00       	push   $0x1067fe
  104bbc:	68 01 01 00 00       	push   $0x101
  104bc1:	68 13 68 10 00       	push   $0x106813
  104bc6:	e8 02 b8 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104bcb:	83 ec 0c             	sub    $0xc,%esp
  104bce:	6a 01                	push   $0x1
  104bd0:	e8 e4 df ff ff       	call   102bb9 <alloc_pages>
  104bd5:	83 c4 10             	add    $0x10,%esp
  104bd8:	85 c0                	test   %eax,%eax
  104bda:	74 19                	je     104bf5 <default_check+0x1c1>
  104bdc:	68 6e 69 10 00       	push   $0x10696e
  104be1:	68 fe 67 10 00       	push   $0x1067fe
  104be6:	68 02 01 00 00       	push   $0x102
  104beb:	68 13 68 10 00       	push   $0x106813
  104bf0:	e8 d8 b7 ff ff       	call   1003cd <__panic>

    unsigned int nr_free_store = nr_free;
  104bf5:	a1 64 89 11 00       	mov    0x118964,%eax
  104bfa:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104bfd:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104c04:	00 00 00 

    free_pages(p0 + 2, 3);
  104c07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c0a:	83 c0 28             	add    $0x28,%eax
  104c0d:	83 ec 08             	sub    $0x8,%esp
  104c10:	6a 03                	push   $0x3
  104c12:	50                   	push   %eax
  104c13:	e8 df df ff ff       	call   102bf7 <free_pages>
  104c18:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
  104c1b:	83 ec 0c             	sub    $0xc,%esp
  104c1e:	6a 04                	push   $0x4
  104c20:	e8 94 df ff ff       	call   102bb9 <alloc_pages>
  104c25:	83 c4 10             	add    $0x10,%esp
  104c28:	85 c0                	test   %eax,%eax
  104c2a:	74 19                	je     104c45 <default_check+0x211>
  104c2c:	68 14 6a 10 00       	push   $0x106a14
  104c31:	68 fe 67 10 00       	push   $0x1067fe
  104c36:	68 08 01 00 00       	push   $0x108
  104c3b:	68 13 68 10 00       	push   $0x106813
  104c40:	e8 88 b7 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104c45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c48:	83 c0 28             	add    $0x28,%eax
  104c4b:	83 c0 04             	add    $0x4,%eax
  104c4e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104c55:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c58:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104c5b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104c5e:	0f a3 10             	bt     %edx,(%eax)
  104c61:	19 c0                	sbb    %eax,%eax
  104c63:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104c66:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104c6a:	0f 95 c0             	setne  %al
  104c6d:	0f b6 c0             	movzbl %al,%eax
  104c70:	85 c0                	test   %eax,%eax
  104c72:	74 0e                	je     104c82 <default_check+0x24e>
  104c74:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c77:	83 c0 28             	add    $0x28,%eax
  104c7a:	8b 40 08             	mov    0x8(%eax),%eax
  104c7d:	83 f8 03             	cmp    $0x3,%eax
  104c80:	74 19                	je     104c9b <default_check+0x267>
  104c82:	68 2c 6a 10 00       	push   $0x106a2c
  104c87:	68 fe 67 10 00       	push   $0x1067fe
  104c8c:	68 09 01 00 00       	push   $0x109
  104c91:	68 13 68 10 00       	push   $0x106813
  104c96:	e8 32 b7 ff ff       	call   1003cd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104c9b:	83 ec 0c             	sub    $0xc,%esp
  104c9e:	6a 03                	push   $0x3
  104ca0:	e8 14 df ff ff       	call   102bb9 <alloc_pages>
  104ca5:	83 c4 10             	add    $0x10,%esp
  104ca8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104cab:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104caf:	75 19                	jne    104cca <default_check+0x296>
  104cb1:	68 58 6a 10 00       	push   $0x106a58
  104cb6:	68 fe 67 10 00       	push   $0x1067fe
  104cbb:	68 0a 01 00 00       	push   $0x10a
  104cc0:	68 13 68 10 00       	push   $0x106813
  104cc5:	e8 03 b7 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104cca:	83 ec 0c             	sub    $0xc,%esp
  104ccd:	6a 01                	push   $0x1
  104ccf:	e8 e5 de ff ff       	call   102bb9 <alloc_pages>
  104cd4:	83 c4 10             	add    $0x10,%esp
  104cd7:	85 c0                	test   %eax,%eax
  104cd9:	74 19                	je     104cf4 <default_check+0x2c0>
  104cdb:	68 6e 69 10 00       	push   $0x10696e
  104ce0:	68 fe 67 10 00       	push   $0x1067fe
  104ce5:	68 0b 01 00 00       	push   $0x10b
  104cea:	68 13 68 10 00       	push   $0x106813
  104cef:	e8 d9 b6 ff ff       	call   1003cd <__panic>
    assert(p0 + 2 == p1);
  104cf4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cf7:	83 c0 28             	add    $0x28,%eax
  104cfa:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104cfd:	74 19                	je     104d18 <default_check+0x2e4>
  104cff:	68 76 6a 10 00       	push   $0x106a76
  104d04:	68 fe 67 10 00       	push   $0x1067fe
  104d09:	68 0c 01 00 00       	push   $0x10c
  104d0e:	68 13 68 10 00       	push   $0x106813
  104d13:	e8 b5 b6 ff ff       	call   1003cd <__panic>

    p2 = p0 + 1;
  104d18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d1b:	83 c0 14             	add    $0x14,%eax
  104d1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104d21:	83 ec 08             	sub    $0x8,%esp
  104d24:	6a 01                	push   $0x1
  104d26:	ff 75 dc             	pushl  -0x24(%ebp)
  104d29:	e8 c9 de ff ff       	call   102bf7 <free_pages>
  104d2e:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
  104d31:	83 ec 08             	sub    $0x8,%esp
  104d34:	6a 03                	push   $0x3
  104d36:	ff 75 c4             	pushl  -0x3c(%ebp)
  104d39:	e8 b9 de ff ff       	call   102bf7 <free_pages>
  104d3e:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
  104d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d44:	83 c0 04             	add    $0x4,%eax
  104d47:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104d4e:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d51:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104d54:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104d57:	0f a3 10             	bt     %edx,(%eax)
  104d5a:	19 c0                	sbb    %eax,%eax
  104d5c:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104d5f:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104d63:	0f 95 c0             	setne  %al
  104d66:	0f b6 c0             	movzbl %al,%eax
  104d69:	85 c0                	test   %eax,%eax
  104d6b:	74 0b                	je     104d78 <default_check+0x344>
  104d6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d70:	8b 40 08             	mov    0x8(%eax),%eax
  104d73:	83 f8 01             	cmp    $0x1,%eax
  104d76:	74 19                	je     104d91 <default_check+0x35d>
  104d78:	68 84 6a 10 00       	push   $0x106a84
  104d7d:	68 fe 67 10 00       	push   $0x1067fe
  104d82:	68 11 01 00 00       	push   $0x111
  104d87:	68 13 68 10 00       	push   $0x106813
  104d8c:	e8 3c b6 ff ff       	call   1003cd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104d91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104d94:	83 c0 04             	add    $0x4,%eax
  104d97:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104d9e:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104da1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104da4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104da7:	0f a3 10             	bt     %edx,(%eax)
  104daa:	19 c0                	sbb    %eax,%eax
  104dac:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104daf:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104db3:	0f 95 c0             	setne  %al
  104db6:	0f b6 c0             	movzbl %al,%eax
  104db9:	85 c0                	test   %eax,%eax
  104dbb:	74 0b                	je     104dc8 <default_check+0x394>
  104dbd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104dc0:	8b 40 08             	mov    0x8(%eax),%eax
  104dc3:	83 f8 03             	cmp    $0x3,%eax
  104dc6:	74 19                	je     104de1 <default_check+0x3ad>
  104dc8:	68 ac 6a 10 00       	push   $0x106aac
  104dcd:	68 fe 67 10 00       	push   $0x1067fe
  104dd2:	68 12 01 00 00       	push   $0x112
  104dd7:	68 13 68 10 00       	push   $0x106813
  104ddc:	e8 ec b5 ff ff       	call   1003cd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104de1:	83 ec 0c             	sub    $0xc,%esp
  104de4:	6a 01                	push   $0x1
  104de6:	e8 ce dd ff ff       	call   102bb9 <alloc_pages>
  104deb:	83 c4 10             	add    $0x10,%esp
  104dee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104df1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104df4:	83 e8 14             	sub    $0x14,%eax
  104df7:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104dfa:	74 19                	je     104e15 <default_check+0x3e1>
  104dfc:	68 d2 6a 10 00       	push   $0x106ad2
  104e01:	68 fe 67 10 00       	push   $0x1067fe
  104e06:	68 14 01 00 00       	push   $0x114
  104e0b:	68 13 68 10 00       	push   $0x106813
  104e10:	e8 b8 b5 ff ff       	call   1003cd <__panic>
    free_page(p0);
  104e15:	83 ec 08             	sub    $0x8,%esp
  104e18:	6a 01                	push   $0x1
  104e1a:	ff 75 dc             	pushl  -0x24(%ebp)
  104e1d:	e8 d5 dd ff ff       	call   102bf7 <free_pages>
  104e22:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104e25:	83 ec 0c             	sub    $0xc,%esp
  104e28:	6a 02                	push   $0x2
  104e2a:	e8 8a dd ff ff       	call   102bb9 <alloc_pages>
  104e2f:	83 c4 10             	add    $0x10,%esp
  104e32:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104e35:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104e38:	83 c0 14             	add    $0x14,%eax
  104e3b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104e3e:	74 19                	je     104e59 <default_check+0x425>
  104e40:	68 f0 6a 10 00       	push   $0x106af0
  104e45:	68 fe 67 10 00       	push   $0x1067fe
  104e4a:	68 16 01 00 00       	push   $0x116
  104e4f:	68 13 68 10 00       	push   $0x106813
  104e54:	e8 74 b5 ff ff       	call   1003cd <__panic>

    free_pages(p0, 2);
  104e59:	83 ec 08             	sub    $0x8,%esp
  104e5c:	6a 02                	push   $0x2
  104e5e:	ff 75 dc             	pushl  -0x24(%ebp)
  104e61:	e8 91 dd ff ff       	call   102bf7 <free_pages>
  104e66:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
  104e69:	83 ec 08             	sub    $0x8,%esp
  104e6c:	6a 01                	push   $0x1
  104e6e:	ff 75 c0             	pushl  -0x40(%ebp)
  104e71:	e8 81 dd ff ff       	call   102bf7 <free_pages>
  104e76:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
  104e79:	83 ec 0c             	sub    $0xc,%esp
  104e7c:	6a 05                	push   $0x5
  104e7e:	e8 36 dd ff ff       	call   102bb9 <alloc_pages>
  104e83:	83 c4 10             	add    $0x10,%esp
  104e86:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104e89:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104e8d:	75 19                	jne    104ea8 <default_check+0x474>
  104e8f:	68 10 6b 10 00       	push   $0x106b10
  104e94:	68 fe 67 10 00       	push   $0x1067fe
  104e99:	68 1b 01 00 00       	push   $0x11b
  104e9e:	68 13 68 10 00       	push   $0x106813
  104ea3:	e8 25 b5 ff ff       	call   1003cd <__panic>
    assert(alloc_page() == NULL);
  104ea8:	83 ec 0c             	sub    $0xc,%esp
  104eab:	6a 01                	push   $0x1
  104ead:	e8 07 dd ff ff       	call   102bb9 <alloc_pages>
  104eb2:	83 c4 10             	add    $0x10,%esp
  104eb5:	85 c0                	test   %eax,%eax
  104eb7:	74 19                	je     104ed2 <default_check+0x49e>
  104eb9:	68 6e 69 10 00       	push   $0x10696e
  104ebe:	68 fe 67 10 00       	push   $0x1067fe
  104ec3:	68 1c 01 00 00       	push   $0x11c
  104ec8:	68 13 68 10 00       	push   $0x106813
  104ecd:	e8 fb b4 ff ff       	call   1003cd <__panic>

    assert(nr_free == 0);
  104ed2:	a1 64 89 11 00       	mov    0x118964,%eax
  104ed7:	85 c0                	test   %eax,%eax
  104ed9:	74 19                	je     104ef4 <default_check+0x4c0>
  104edb:	68 c1 69 10 00       	push   $0x1069c1
  104ee0:	68 fe 67 10 00       	push   $0x1067fe
  104ee5:	68 1e 01 00 00       	push   $0x11e
  104eea:	68 13 68 10 00       	push   $0x106813
  104eef:	e8 d9 b4 ff ff       	call   1003cd <__panic>
    nr_free = nr_free_store;
  104ef4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104ef7:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  104efc:	8b 45 80             	mov    -0x80(%ebp),%eax
  104eff:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104f02:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104f07:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  104f0d:	83 ec 08             	sub    $0x8,%esp
  104f10:	6a 05                	push   $0x5
  104f12:	ff 75 dc             	pushl  -0x24(%ebp)
  104f15:	e8 dd dc ff ff       	call   102bf7 <free_pages>
  104f1a:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
  104f1d:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f24:	eb 1d                	jmp    104f43 <default_check+0x50f>
        struct Page *p = le2page(le, page_link);
  104f26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f29:	83 e8 0c             	sub    $0xc,%eax
  104f2c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  104f2f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104f33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104f36:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104f39:	8b 40 08             	mov    0x8(%eax),%eax
  104f3c:	29 c2                	sub    %eax,%edx
  104f3e:	89 d0                	mov    %edx,%eax
  104f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f46:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104f49:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104f4c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104f4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104f52:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104f59:	75 cb                	jne    104f26 <default_check+0x4f2>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  104f5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104f5f:	74 19                	je     104f7a <default_check+0x546>
  104f61:	68 2e 6b 10 00       	push   $0x106b2e
  104f66:	68 fe 67 10 00       	push   $0x1067fe
  104f6b:	68 29 01 00 00       	push   $0x129
  104f70:	68 13 68 10 00       	push   $0x106813
  104f75:	e8 53 b4 ff ff       	call   1003cd <__panic>
    assert(total == 0);
  104f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104f7e:	74 19                	je     104f99 <default_check+0x565>
  104f80:	68 39 6b 10 00       	push   $0x106b39
  104f85:	68 fe 67 10 00       	push   $0x1067fe
  104f8a:	68 2a 01 00 00       	push   $0x12a
  104f8f:	68 13 68 10 00       	push   $0x106813
  104f94:	e8 34 b4 ff ff       	call   1003cd <__panic>
}
  104f99:	90                   	nop
  104f9a:	c9                   	leave  
  104f9b:	c3                   	ret    

00104f9c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  104f9c:	55                   	push   %ebp
  104f9d:	89 e5                	mov    %esp,%ebp
  104f9f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104fa2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  104fa9:	eb 04                	jmp    104faf <strlen+0x13>
        cnt ++;
  104fab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  104faf:	8b 45 08             	mov    0x8(%ebp),%eax
  104fb2:	8d 50 01             	lea    0x1(%eax),%edx
  104fb5:	89 55 08             	mov    %edx,0x8(%ebp)
  104fb8:	0f b6 00             	movzbl (%eax),%eax
  104fbb:	84 c0                	test   %al,%al
  104fbd:	75 ec                	jne    104fab <strlen+0xf>
        cnt ++;
    }
    return cnt;
  104fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104fc2:	c9                   	leave  
  104fc3:	c3                   	ret    

00104fc4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  104fc4:	55                   	push   %ebp
  104fc5:	89 e5                	mov    %esp,%ebp
  104fc7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  104fca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  104fd1:	eb 04                	jmp    104fd7 <strnlen+0x13>
        cnt ++;
  104fd3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  104fd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104fda:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104fdd:	73 10                	jae    104fef <strnlen+0x2b>
  104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  104fe2:	8d 50 01             	lea    0x1(%eax),%edx
  104fe5:	89 55 08             	mov    %edx,0x8(%ebp)
  104fe8:	0f b6 00             	movzbl (%eax),%eax
  104feb:	84 c0                	test   %al,%al
  104fed:	75 e4                	jne    104fd3 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  104fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  104ff2:	c9                   	leave  
  104ff3:	c3                   	ret    

00104ff4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  104ff4:	55                   	push   %ebp
  104ff5:	89 e5                	mov    %esp,%ebp
  104ff7:	57                   	push   %edi
  104ff8:	56                   	push   %esi
  104ff9:	83 ec 20             	sub    $0x20,%esp
  104ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  104fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105002:	8b 45 0c             	mov    0xc(%ebp),%eax
  105005:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105008:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10500b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10500e:	89 d1                	mov    %edx,%ecx
  105010:	89 c2                	mov    %eax,%edx
  105012:	89 ce                	mov    %ecx,%esi
  105014:	89 d7                	mov    %edx,%edi
  105016:	ac                   	lods   %ds:(%esi),%al
  105017:	aa                   	stos   %al,%es:(%edi)
  105018:	84 c0                	test   %al,%al
  10501a:	75 fa                	jne    105016 <strcpy+0x22>
  10501c:	89 fa                	mov    %edi,%edx
  10501e:	89 f1                	mov    %esi,%ecx
  105020:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105023:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105026:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105029:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10502c:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10502d:	83 c4 20             	add    $0x20,%esp
  105030:	5e                   	pop    %esi
  105031:	5f                   	pop    %edi
  105032:	5d                   	pop    %ebp
  105033:	c3                   	ret    

00105034 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105034:	55                   	push   %ebp
  105035:	89 e5                	mov    %esp,%ebp
  105037:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10503a:	8b 45 08             	mov    0x8(%ebp),%eax
  10503d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105040:	eb 21                	jmp    105063 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105042:	8b 45 0c             	mov    0xc(%ebp),%eax
  105045:	0f b6 10             	movzbl (%eax),%edx
  105048:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10504b:	88 10                	mov    %dl,(%eax)
  10504d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105050:	0f b6 00             	movzbl (%eax),%eax
  105053:	84 c0                	test   %al,%al
  105055:	74 04                	je     10505b <strncpy+0x27>
            src ++;
  105057:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10505b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10505f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105063:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105067:	75 d9                	jne    105042 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10506c:	c9                   	leave  
  10506d:	c3                   	ret    

0010506e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10506e:	55                   	push   %ebp
  10506f:	89 e5                	mov    %esp,%ebp
  105071:	57                   	push   %edi
  105072:	56                   	push   %esi
  105073:	83 ec 20             	sub    $0x20,%esp
  105076:	8b 45 08             	mov    0x8(%ebp),%eax
  105079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10507c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10507f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105082:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105088:	89 d1                	mov    %edx,%ecx
  10508a:	89 c2                	mov    %eax,%edx
  10508c:	89 ce                	mov    %ecx,%esi
  10508e:	89 d7                	mov    %edx,%edi
  105090:	ac                   	lods   %ds:(%esi),%al
  105091:	ae                   	scas   %es:(%edi),%al
  105092:	75 08                	jne    10509c <strcmp+0x2e>
  105094:	84 c0                	test   %al,%al
  105096:	75 f8                	jne    105090 <strcmp+0x22>
  105098:	31 c0                	xor    %eax,%eax
  10509a:	eb 04                	jmp    1050a0 <strcmp+0x32>
  10509c:	19 c0                	sbb    %eax,%eax
  10509e:	0c 01                	or     $0x1,%al
  1050a0:	89 fa                	mov    %edi,%edx
  1050a2:	89 f1                	mov    %esi,%ecx
  1050a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050a7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1050aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1050ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1050b0:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1050b1:	83 c4 20             	add    $0x20,%esp
  1050b4:	5e                   	pop    %esi
  1050b5:	5f                   	pop    %edi
  1050b6:	5d                   	pop    %ebp
  1050b7:	c3                   	ret    

001050b8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1050b8:	55                   	push   %ebp
  1050b9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1050bb:	eb 0c                	jmp    1050c9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1050bd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1050c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1050c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1050c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1050cd:	74 1a                	je     1050e9 <strncmp+0x31>
  1050cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1050d2:	0f b6 00             	movzbl (%eax),%eax
  1050d5:	84 c0                	test   %al,%al
  1050d7:	74 10                	je     1050e9 <strncmp+0x31>
  1050d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1050dc:	0f b6 10             	movzbl (%eax),%edx
  1050df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050e2:	0f b6 00             	movzbl (%eax),%eax
  1050e5:	38 c2                	cmp    %al,%dl
  1050e7:	74 d4                	je     1050bd <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1050e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1050ed:	74 18                	je     105107 <strncmp+0x4f>
  1050ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1050f2:	0f b6 00             	movzbl (%eax),%eax
  1050f5:	0f b6 d0             	movzbl %al,%edx
  1050f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050fb:	0f b6 00             	movzbl (%eax),%eax
  1050fe:	0f b6 c0             	movzbl %al,%eax
  105101:	29 c2                	sub    %eax,%edx
  105103:	89 d0                	mov    %edx,%eax
  105105:	eb 05                	jmp    10510c <strncmp+0x54>
  105107:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10510c:	5d                   	pop    %ebp
  10510d:	c3                   	ret    

0010510e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10510e:	55                   	push   %ebp
  10510f:	89 e5                	mov    %esp,%ebp
  105111:	83 ec 04             	sub    $0x4,%esp
  105114:	8b 45 0c             	mov    0xc(%ebp),%eax
  105117:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10511a:	eb 14                	jmp    105130 <strchr+0x22>
        if (*s == c) {
  10511c:	8b 45 08             	mov    0x8(%ebp),%eax
  10511f:	0f b6 00             	movzbl (%eax),%eax
  105122:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105125:	75 05                	jne    10512c <strchr+0x1e>
            return (char *)s;
  105127:	8b 45 08             	mov    0x8(%ebp),%eax
  10512a:	eb 13                	jmp    10513f <strchr+0x31>
        }
        s ++;
  10512c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105130:	8b 45 08             	mov    0x8(%ebp),%eax
  105133:	0f b6 00             	movzbl (%eax),%eax
  105136:	84 c0                	test   %al,%al
  105138:	75 e2                	jne    10511c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  10513a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10513f:	c9                   	leave  
  105140:	c3                   	ret    

00105141 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105141:	55                   	push   %ebp
  105142:	89 e5                	mov    %esp,%ebp
  105144:	83 ec 04             	sub    $0x4,%esp
  105147:	8b 45 0c             	mov    0xc(%ebp),%eax
  10514a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10514d:	eb 0f                	jmp    10515e <strfind+0x1d>
        if (*s == c) {
  10514f:	8b 45 08             	mov    0x8(%ebp),%eax
  105152:	0f b6 00             	movzbl (%eax),%eax
  105155:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105158:	74 10                	je     10516a <strfind+0x29>
            break;
        }
        s ++;
  10515a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10515e:	8b 45 08             	mov    0x8(%ebp),%eax
  105161:	0f b6 00             	movzbl (%eax),%eax
  105164:	84 c0                	test   %al,%al
  105166:	75 e7                	jne    10514f <strfind+0xe>
  105168:	eb 01                	jmp    10516b <strfind+0x2a>
        if (*s == c) {
            break;
  10516a:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  10516b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10516e:	c9                   	leave  
  10516f:	c3                   	ret    

00105170 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105170:	55                   	push   %ebp
  105171:	89 e5                	mov    %esp,%ebp
  105173:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10517d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105184:	eb 04                	jmp    10518a <strtol+0x1a>
        s ++;
  105186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10518a:	8b 45 08             	mov    0x8(%ebp),%eax
  10518d:	0f b6 00             	movzbl (%eax),%eax
  105190:	3c 20                	cmp    $0x20,%al
  105192:	74 f2                	je     105186 <strtol+0x16>
  105194:	8b 45 08             	mov    0x8(%ebp),%eax
  105197:	0f b6 00             	movzbl (%eax),%eax
  10519a:	3c 09                	cmp    $0x9,%al
  10519c:	74 e8                	je     105186 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10519e:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a1:	0f b6 00             	movzbl (%eax),%eax
  1051a4:	3c 2b                	cmp    $0x2b,%al
  1051a6:	75 06                	jne    1051ae <strtol+0x3e>
        s ++;
  1051a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1051ac:	eb 15                	jmp    1051c3 <strtol+0x53>
    }
    else if (*s == '-') {
  1051ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1051b1:	0f b6 00             	movzbl (%eax),%eax
  1051b4:	3c 2d                	cmp    $0x2d,%al
  1051b6:	75 0b                	jne    1051c3 <strtol+0x53>
        s ++, neg = 1;
  1051b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1051bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1051c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051c7:	74 06                	je     1051cf <strtol+0x5f>
  1051c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1051cd:	75 24                	jne    1051f3 <strtol+0x83>
  1051cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1051d2:	0f b6 00             	movzbl (%eax),%eax
  1051d5:	3c 30                	cmp    $0x30,%al
  1051d7:	75 1a                	jne    1051f3 <strtol+0x83>
  1051d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051dc:	83 c0 01             	add    $0x1,%eax
  1051df:	0f b6 00             	movzbl (%eax),%eax
  1051e2:	3c 78                	cmp    $0x78,%al
  1051e4:	75 0d                	jne    1051f3 <strtol+0x83>
        s += 2, base = 16;
  1051e6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1051ea:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1051f1:	eb 2a                	jmp    10521d <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1051f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051f7:	75 17                	jne    105210 <strtol+0xa0>
  1051f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051fc:	0f b6 00             	movzbl (%eax),%eax
  1051ff:	3c 30                	cmp    $0x30,%al
  105201:	75 0d                	jne    105210 <strtol+0xa0>
        s ++, base = 8;
  105203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105207:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10520e:	eb 0d                	jmp    10521d <strtol+0xad>
    }
    else if (base == 0) {
  105210:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105214:	75 07                	jne    10521d <strtol+0xad>
        base = 10;
  105216:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10521d:	8b 45 08             	mov    0x8(%ebp),%eax
  105220:	0f b6 00             	movzbl (%eax),%eax
  105223:	3c 2f                	cmp    $0x2f,%al
  105225:	7e 1b                	jle    105242 <strtol+0xd2>
  105227:	8b 45 08             	mov    0x8(%ebp),%eax
  10522a:	0f b6 00             	movzbl (%eax),%eax
  10522d:	3c 39                	cmp    $0x39,%al
  10522f:	7f 11                	jg     105242 <strtol+0xd2>
            dig = *s - '0';
  105231:	8b 45 08             	mov    0x8(%ebp),%eax
  105234:	0f b6 00             	movzbl (%eax),%eax
  105237:	0f be c0             	movsbl %al,%eax
  10523a:	83 e8 30             	sub    $0x30,%eax
  10523d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105240:	eb 48                	jmp    10528a <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105242:	8b 45 08             	mov    0x8(%ebp),%eax
  105245:	0f b6 00             	movzbl (%eax),%eax
  105248:	3c 60                	cmp    $0x60,%al
  10524a:	7e 1b                	jle    105267 <strtol+0xf7>
  10524c:	8b 45 08             	mov    0x8(%ebp),%eax
  10524f:	0f b6 00             	movzbl (%eax),%eax
  105252:	3c 7a                	cmp    $0x7a,%al
  105254:	7f 11                	jg     105267 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105256:	8b 45 08             	mov    0x8(%ebp),%eax
  105259:	0f b6 00             	movzbl (%eax),%eax
  10525c:	0f be c0             	movsbl %al,%eax
  10525f:	83 e8 57             	sub    $0x57,%eax
  105262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105265:	eb 23                	jmp    10528a <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105267:	8b 45 08             	mov    0x8(%ebp),%eax
  10526a:	0f b6 00             	movzbl (%eax),%eax
  10526d:	3c 40                	cmp    $0x40,%al
  10526f:	7e 3c                	jle    1052ad <strtol+0x13d>
  105271:	8b 45 08             	mov    0x8(%ebp),%eax
  105274:	0f b6 00             	movzbl (%eax),%eax
  105277:	3c 5a                	cmp    $0x5a,%al
  105279:	7f 32                	jg     1052ad <strtol+0x13d>
            dig = *s - 'A' + 10;
  10527b:	8b 45 08             	mov    0x8(%ebp),%eax
  10527e:	0f b6 00             	movzbl (%eax),%eax
  105281:	0f be c0             	movsbl %al,%eax
  105284:	83 e8 37             	sub    $0x37,%eax
  105287:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10528a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10528d:	3b 45 10             	cmp    0x10(%ebp),%eax
  105290:	7d 1a                	jge    1052ac <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  105292:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105296:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105299:	0f af 45 10          	imul   0x10(%ebp),%eax
  10529d:	89 c2                	mov    %eax,%edx
  10529f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1052a2:	01 d0                	add    %edx,%eax
  1052a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1052a7:	e9 71 ff ff ff       	jmp    10521d <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  1052ac:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  1052ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1052b1:	74 08                	je     1052bb <strtol+0x14b>
        *endptr = (char *) s;
  1052b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1052b9:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1052bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1052bf:	74 07                	je     1052c8 <strtol+0x158>
  1052c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1052c4:	f7 d8                	neg    %eax
  1052c6:	eb 03                	jmp    1052cb <strtol+0x15b>
  1052c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1052cb:	c9                   	leave  
  1052cc:	c3                   	ret    

001052cd <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1052cd:	55                   	push   %ebp
  1052ce:	89 e5                	mov    %esp,%ebp
  1052d0:	57                   	push   %edi
  1052d1:	83 ec 24             	sub    $0x24,%esp
  1052d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052d7:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1052da:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1052de:	8b 55 08             	mov    0x8(%ebp),%edx
  1052e1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1052e4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1052e7:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1052ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1052f0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1052f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1052f7:	89 d7                	mov    %edx,%edi
  1052f9:	f3 aa                	rep stos %al,%es:(%edi)
  1052fb:	89 fa                	mov    %edi,%edx
  1052fd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105300:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105306:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105307:	83 c4 24             	add    $0x24,%esp
  10530a:	5f                   	pop    %edi
  10530b:	5d                   	pop    %ebp
  10530c:	c3                   	ret    

0010530d <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10530d:	55                   	push   %ebp
  10530e:	89 e5                	mov    %esp,%ebp
  105310:	57                   	push   %edi
  105311:	56                   	push   %esi
  105312:	53                   	push   %ebx
  105313:	83 ec 30             	sub    $0x30,%esp
  105316:	8b 45 08             	mov    0x8(%ebp),%eax
  105319:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10531c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10531f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105322:	8b 45 10             	mov    0x10(%ebp),%eax
  105325:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10532b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10532e:	73 42                	jae    105372 <memmove+0x65>
  105330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105336:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105339:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10533c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10533f:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105342:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105345:	c1 e8 02             	shr    $0x2,%eax
  105348:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10534a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10534d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105350:	89 d7                	mov    %edx,%edi
  105352:	89 c6                	mov    %eax,%esi
  105354:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105356:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105359:	83 e1 03             	and    $0x3,%ecx
  10535c:	74 02                	je     105360 <memmove+0x53>
  10535e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105360:	89 f0                	mov    %esi,%eax
  105362:	89 fa                	mov    %edi,%edx
  105364:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105367:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10536a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10536d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  105370:	eb 36                	jmp    1053a8 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105375:	8d 50 ff             	lea    -0x1(%eax),%edx
  105378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10537b:	01 c2                	add    %eax,%edx
  10537d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105380:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105386:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10538c:	89 c1                	mov    %eax,%ecx
  10538e:	89 d8                	mov    %ebx,%eax
  105390:	89 d6                	mov    %edx,%esi
  105392:	89 c7                	mov    %eax,%edi
  105394:	fd                   	std    
  105395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105397:	fc                   	cld    
  105398:	89 f8                	mov    %edi,%eax
  10539a:	89 f2                	mov    %esi,%edx
  10539c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10539f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1053a2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1053a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1053a8:	83 c4 30             	add    $0x30,%esp
  1053ab:	5b                   	pop    %ebx
  1053ac:	5e                   	pop    %esi
  1053ad:	5f                   	pop    %edi
  1053ae:	5d                   	pop    %ebp
  1053af:	c3                   	ret    

001053b0 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1053b0:	55                   	push   %ebp
  1053b1:	89 e5                	mov    %esp,%ebp
  1053b3:	57                   	push   %edi
  1053b4:	56                   	push   %esi
  1053b5:	83 ec 20             	sub    $0x20,%esp
  1053b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1053bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1053c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1053ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1053cd:	c1 e8 02             	shr    $0x2,%eax
  1053d0:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1053d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1053d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053d8:	89 d7                	mov    %edx,%edi
  1053da:	89 c6                	mov    %eax,%esi
  1053dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1053de:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1053e1:	83 e1 03             	and    $0x3,%ecx
  1053e4:	74 02                	je     1053e8 <memcpy+0x38>
  1053e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1053e8:	89 f0                	mov    %esi,%eax
  1053ea:	89 fa                	mov    %edi,%edx
  1053ec:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1053ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1053f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1053f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  1053f8:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1053f9:	83 c4 20             	add    $0x20,%esp
  1053fc:	5e                   	pop    %esi
  1053fd:	5f                   	pop    %edi
  1053fe:	5d                   	pop    %ebp
  1053ff:	c3                   	ret    

00105400 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105400:	55                   	push   %ebp
  105401:	89 e5                	mov    %esp,%ebp
  105403:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105406:	8b 45 08             	mov    0x8(%ebp),%eax
  105409:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10540c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105412:	eb 30                	jmp    105444 <memcmp+0x44>
        if (*s1 != *s2) {
  105414:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105417:	0f b6 10             	movzbl (%eax),%edx
  10541a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10541d:	0f b6 00             	movzbl (%eax),%eax
  105420:	38 c2                	cmp    %al,%dl
  105422:	74 18                	je     10543c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105424:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105427:	0f b6 00             	movzbl (%eax),%eax
  10542a:	0f b6 d0             	movzbl %al,%edx
  10542d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105430:	0f b6 00             	movzbl (%eax),%eax
  105433:	0f b6 c0             	movzbl %al,%eax
  105436:	29 c2                	sub    %eax,%edx
  105438:	89 d0                	mov    %edx,%eax
  10543a:	eb 1a                	jmp    105456 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  10543c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105440:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105444:	8b 45 10             	mov    0x10(%ebp),%eax
  105447:	8d 50 ff             	lea    -0x1(%eax),%edx
  10544a:	89 55 10             	mov    %edx,0x10(%ebp)
  10544d:	85 c0                	test   %eax,%eax
  10544f:	75 c3                	jne    105414 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105456:	c9                   	leave  
  105457:	c3                   	ret    

00105458 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105458:	55                   	push   %ebp
  105459:	89 e5                	mov    %esp,%ebp
  10545b:	83 ec 38             	sub    $0x38,%esp
  10545e:	8b 45 10             	mov    0x10(%ebp),%eax
  105461:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105464:	8b 45 14             	mov    0x14(%ebp),%eax
  105467:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10546a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10546d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105470:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105473:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105476:	8b 45 18             	mov    0x18(%ebp),%eax
  105479:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10547c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10547f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105482:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105485:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10548b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10548e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105492:	74 1c                	je     1054b0 <printnum+0x58>
  105494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105497:	ba 00 00 00 00       	mov    $0x0,%edx
  10549c:	f7 75 e4             	divl   -0x1c(%ebp)
  10549f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a5:	ba 00 00 00 00       	mov    $0x0,%edx
  1054aa:	f7 75 e4             	divl   -0x1c(%ebp)
  1054ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054b6:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054c8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054ce:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054d1:	8b 45 18             	mov    0x18(%ebp),%eax
  1054d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1054d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054dc:	77 41                	ja     10551f <printnum+0xc7>
  1054de:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054e1:	72 05                	jb     1054e8 <printnum+0x90>
  1054e3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054e6:	77 37                	ja     10551f <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054eb:	83 e8 01             	sub    $0x1,%eax
  1054ee:	83 ec 04             	sub    $0x4,%esp
  1054f1:	ff 75 20             	pushl  0x20(%ebp)
  1054f4:	50                   	push   %eax
  1054f5:	ff 75 18             	pushl  0x18(%ebp)
  1054f8:	ff 75 ec             	pushl  -0x14(%ebp)
  1054fb:	ff 75 e8             	pushl  -0x18(%ebp)
  1054fe:	ff 75 0c             	pushl  0xc(%ebp)
  105501:	ff 75 08             	pushl  0x8(%ebp)
  105504:	e8 4f ff ff ff       	call   105458 <printnum>
  105509:	83 c4 20             	add    $0x20,%esp
  10550c:	eb 1b                	jmp    105529 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10550e:	83 ec 08             	sub    $0x8,%esp
  105511:	ff 75 0c             	pushl  0xc(%ebp)
  105514:	ff 75 20             	pushl  0x20(%ebp)
  105517:	8b 45 08             	mov    0x8(%ebp),%eax
  10551a:	ff d0                	call   *%eax
  10551c:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10551f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105523:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105527:	7f e5                	jg     10550e <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105529:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10552c:	05 f4 6b 10 00       	add    $0x106bf4,%eax
  105531:	0f b6 00             	movzbl (%eax),%eax
  105534:	0f be c0             	movsbl %al,%eax
  105537:	83 ec 08             	sub    $0x8,%esp
  10553a:	ff 75 0c             	pushl  0xc(%ebp)
  10553d:	50                   	push   %eax
  10553e:	8b 45 08             	mov    0x8(%ebp),%eax
  105541:	ff d0                	call   *%eax
  105543:	83 c4 10             	add    $0x10,%esp
}
  105546:	90                   	nop
  105547:	c9                   	leave  
  105548:	c3                   	ret    

00105549 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105549:	55                   	push   %ebp
  10554a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10554c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105550:	7e 14                	jle    105566 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105552:	8b 45 08             	mov    0x8(%ebp),%eax
  105555:	8b 00                	mov    (%eax),%eax
  105557:	8d 48 08             	lea    0x8(%eax),%ecx
  10555a:	8b 55 08             	mov    0x8(%ebp),%edx
  10555d:	89 0a                	mov    %ecx,(%edx)
  10555f:	8b 50 04             	mov    0x4(%eax),%edx
  105562:	8b 00                	mov    (%eax),%eax
  105564:	eb 30                	jmp    105596 <getuint+0x4d>
    }
    else if (lflag) {
  105566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10556a:	74 16                	je     105582 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10556c:	8b 45 08             	mov    0x8(%ebp),%eax
  10556f:	8b 00                	mov    (%eax),%eax
  105571:	8d 48 04             	lea    0x4(%eax),%ecx
  105574:	8b 55 08             	mov    0x8(%ebp),%edx
  105577:	89 0a                	mov    %ecx,(%edx)
  105579:	8b 00                	mov    (%eax),%eax
  10557b:	ba 00 00 00 00       	mov    $0x0,%edx
  105580:	eb 14                	jmp    105596 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105582:	8b 45 08             	mov    0x8(%ebp),%eax
  105585:	8b 00                	mov    (%eax),%eax
  105587:	8d 48 04             	lea    0x4(%eax),%ecx
  10558a:	8b 55 08             	mov    0x8(%ebp),%edx
  10558d:	89 0a                	mov    %ecx,(%edx)
  10558f:	8b 00                	mov    (%eax),%eax
  105591:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105596:	5d                   	pop    %ebp
  105597:	c3                   	ret    

00105598 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105598:	55                   	push   %ebp
  105599:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10559b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10559f:	7e 14                	jle    1055b5 <getint+0x1d>
        return va_arg(*ap, long long);
  1055a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a4:	8b 00                	mov    (%eax),%eax
  1055a6:	8d 48 08             	lea    0x8(%eax),%ecx
  1055a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ac:	89 0a                	mov    %ecx,(%edx)
  1055ae:	8b 50 04             	mov    0x4(%eax),%edx
  1055b1:	8b 00                	mov    (%eax),%eax
  1055b3:	eb 28                	jmp    1055dd <getint+0x45>
    }
    else if (lflag) {
  1055b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055b9:	74 12                	je     1055cd <getint+0x35>
        return va_arg(*ap, long);
  1055bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1055be:	8b 00                	mov    (%eax),%eax
  1055c0:	8d 48 04             	lea    0x4(%eax),%ecx
  1055c3:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c6:	89 0a                	mov    %ecx,(%edx)
  1055c8:	8b 00                	mov    (%eax),%eax
  1055ca:	99                   	cltd   
  1055cb:	eb 10                	jmp    1055dd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d0:	8b 00                	mov    (%eax),%eax
  1055d2:	8d 48 04             	lea    0x4(%eax),%ecx
  1055d5:	8b 55 08             	mov    0x8(%ebp),%edx
  1055d8:	89 0a                	mov    %ecx,(%edx)
  1055da:	8b 00                	mov    (%eax),%eax
  1055dc:	99                   	cltd   
    }
}
  1055dd:	5d                   	pop    %ebp
  1055de:	c3                   	ret    

001055df <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055df:	55                   	push   %ebp
  1055e0:	89 e5                	mov    %esp,%ebp
  1055e2:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1055e5:	8d 45 14             	lea    0x14(%ebp),%eax
  1055e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055ee:	50                   	push   %eax
  1055ef:	ff 75 10             	pushl  0x10(%ebp)
  1055f2:	ff 75 0c             	pushl  0xc(%ebp)
  1055f5:	ff 75 08             	pushl  0x8(%ebp)
  1055f8:	e8 06 00 00 00       	call   105603 <vprintfmt>
  1055fd:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  105600:	90                   	nop
  105601:	c9                   	leave  
  105602:	c3                   	ret    

00105603 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105603:	55                   	push   %ebp
  105604:	89 e5                	mov    %esp,%ebp
  105606:	56                   	push   %esi
  105607:	53                   	push   %ebx
  105608:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10560b:	eb 17                	jmp    105624 <vprintfmt+0x21>
            if (ch == '\0') {
  10560d:	85 db                	test   %ebx,%ebx
  10560f:	0f 84 8e 03 00 00    	je     1059a3 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  105615:	83 ec 08             	sub    $0x8,%esp
  105618:	ff 75 0c             	pushl  0xc(%ebp)
  10561b:	53                   	push   %ebx
  10561c:	8b 45 08             	mov    0x8(%ebp),%eax
  10561f:	ff d0                	call   *%eax
  105621:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105624:	8b 45 10             	mov    0x10(%ebp),%eax
  105627:	8d 50 01             	lea    0x1(%eax),%edx
  10562a:	89 55 10             	mov    %edx,0x10(%ebp)
  10562d:	0f b6 00             	movzbl (%eax),%eax
  105630:	0f b6 d8             	movzbl %al,%ebx
  105633:	83 fb 25             	cmp    $0x25,%ebx
  105636:	75 d5                	jne    10560d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105638:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10563c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105646:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105649:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105653:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105656:	8b 45 10             	mov    0x10(%ebp),%eax
  105659:	8d 50 01             	lea    0x1(%eax),%edx
  10565c:	89 55 10             	mov    %edx,0x10(%ebp)
  10565f:	0f b6 00             	movzbl (%eax),%eax
  105662:	0f b6 d8             	movzbl %al,%ebx
  105665:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105668:	83 f8 55             	cmp    $0x55,%eax
  10566b:	0f 87 05 03 00 00    	ja     105976 <vprintfmt+0x373>
  105671:	8b 04 85 18 6c 10 00 	mov    0x106c18(,%eax,4),%eax
  105678:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10567a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10567e:	eb d6                	jmp    105656 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105680:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105684:	eb d0                	jmp    105656 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10568d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105690:	89 d0                	mov    %edx,%eax
  105692:	c1 e0 02             	shl    $0x2,%eax
  105695:	01 d0                	add    %edx,%eax
  105697:	01 c0                	add    %eax,%eax
  105699:	01 d8                	add    %ebx,%eax
  10569b:	83 e8 30             	sub    $0x30,%eax
  10569e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1056a4:	0f b6 00             	movzbl (%eax),%eax
  1056a7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056aa:	83 fb 2f             	cmp    $0x2f,%ebx
  1056ad:	7e 39                	jle    1056e8 <vprintfmt+0xe5>
  1056af:	83 fb 39             	cmp    $0x39,%ebx
  1056b2:	7f 34                	jg     1056e8 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056b4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056b8:	eb d3                	jmp    10568d <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1056ba:	8b 45 14             	mov    0x14(%ebp),%eax
  1056bd:	8d 50 04             	lea    0x4(%eax),%edx
  1056c0:	89 55 14             	mov    %edx,0x14(%ebp)
  1056c3:	8b 00                	mov    (%eax),%eax
  1056c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056c8:	eb 1f                	jmp    1056e9 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1056ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056ce:	79 86                	jns    105656 <vprintfmt+0x53>
                width = 0;
  1056d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056d7:	e9 7a ff ff ff       	jmp    105656 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1056dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056e3:	e9 6e ff ff ff       	jmp    105656 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1056e8:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1056e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056ed:	0f 89 63 ff ff ff    	jns    105656 <vprintfmt+0x53>
                width = precision, precision = -1;
  1056f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105700:	e9 51 ff ff ff       	jmp    105656 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105705:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105709:	e9 48 ff ff ff       	jmp    105656 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10570e:	8b 45 14             	mov    0x14(%ebp),%eax
  105711:	8d 50 04             	lea    0x4(%eax),%edx
  105714:	89 55 14             	mov    %edx,0x14(%ebp)
  105717:	8b 00                	mov    (%eax),%eax
  105719:	83 ec 08             	sub    $0x8,%esp
  10571c:	ff 75 0c             	pushl  0xc(%ebp)
  10571f:	50                   	push   %eax
  105720:	8b 45 08             	mov    0x8(%ebp),%eax
  105723:	ff d0                	call   *%eax
  105725:	83 c4 10             	add    $0x10,%esp
            break;
  105728:	e9 71 02 00 00       	jmp    10599e <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10572d:	8b 45 14             	mov    0x14(%ebp),%eax
  105730:	8d 50 04             	lea    0x4(%eax),%edx
  105733:	89 55 14             	mov    %edx,0x14(%ebp)
  105736:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105738:	85 db                	test   %ebx,%ebx
  10573a:	79 02                	jns    10573e <vprintfmt+0x13b>
                err = -err;
  10573c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10573e:	83 fb 06             	cmp    $0x6,%ebx
  105741:	7f 0b                	jg     10574e <vprintfmt+0x14b>
  105743:	8b 34 9d d8 6b 10 00 	mov    0x106bd8(,%ebx,4),%esi
  10574a:	85 f6                	test   %esi,%esi
  10574c:	75 19                	jne    105767 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  10574e:	53                   	push   %ebx
  10574f:	68 05 6c 10 00       	push   $0x106c05
  105754:	ff 75 0c             	pushl  0xc(%ebp)
  105757:	ff 75 08             	pushl  0x8(%ebp)
  10575a:	e8 80 fe ff ff       	call   1055df <printfmt>
  10575f:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105762:	e9 37 02 00 00       	jmp    10599e <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105767:	56                   	push   %esi
  105768:	68 0e 6c 10 00       	push   $0x106c0e
  10576d:	ff 75 0c             	pushl  0xc(%ebp)
  105770:	ff 75 08             	pushl  0x8(%ebp)
  105773:	e8 67 fe ff ff       	call   1055df <printfmt>
  105778:	83 c4 10             	add    $0x10,%esp
            }
            break;
  10577b:	e9 1e 02 00 00       	jmp    10599e <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105780:	8b 45 14             	mov    0x14(%ebp),%eax
  105783:	8d 50 04             	lea    0x4(%eax),%edx
  105786:	89 55 14             	mov    %edx,0x14(%ebp)
  105789:	8b 30                	mov    (%eax),%esi
  10578b:	85 f6                	test   %esi,%esi
  10578d:	75 05                	jne    105794 <vprintfmt+0x191>
                p = "(null)";
  10578f:	be 11 6c 10 00       	mov    $0x106c11,%esi
            }
            if (width > 0 && padc != '-') {
  105794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105798:	7e 76                	jle    105810 <vprintfmt+0x20d>
  10579a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10579e:	74 70                	je     105810 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057a3:	83 ec 08             	sub    $0x8,%esp
  1057a6:	50                   	push   %eax
  1057a7:	56                   	push   %esi
  1057a8:	e8 17 f8 ff ff       	call   104fc4 <strnlen>
  1057ad:	83 c4 10             	add    $0x10,%esp
  1057b0:	89 c2                	mov    %eax,%edx
  1057b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057b5:	29 d0                	sub    %edx,%eax
  1057b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057ba:	eb 17                	jmp    1057d3 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1057bc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057c0:	83 ec 08             	sub    $0x8,%esp
  1057c3:	ff 75 0c             	pushl  0xc(%ebp)
  1057c6:	50                   	push   %eax
  1057c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ca:	ff d0                	call   *%eax
  1057cc:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057cf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057d7:	7f e3                	jg     1057bc <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057d9:	eb 35                	jmp    105810 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057db:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057df:	74 1c                	je     1057fd <vprintfmt+0x1fa>
  1057e1:	83 fb 1f             	cmp    $0x1f,%ebx
  1057e4:	7e 05                	jle    1057eb <vprintfmt+0x1e8>
  1057e6:	83 fb 7e             	cmp    $0x7e,%ebx
  1057e9:	7e 12                	jle    1057fd <vprintfmt+0x1fa>
                    putch('?', putdat);
  1057eb:	83 ec 08             	sub    $0x8,%esp
  1057ee:	ff 75 0c             	pushl  0xc(%ebp)
  1057f1:	6a 3f                	push   $0x3f
  1057f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f6:	ff d0                	call   *%eax
  1057f8:	83 c4 10             	add    $0x10,%esp
  1057fb:	eb 0f                	jmp    10580c <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1057fd:	83 ec 08             	sub    $0x8,%esp
  105800:	ff 75 0c             	pushl  0xc(%ebp)
  105803:	53                   	push   %ebx
  105804:	8b 45 08             	mov    0x8(%ebp),%eax
  105807:	ff d0                	call   *%eax
  105809:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10580c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105810:	89 f0                	mov    %esi,%eax
  105812:	8d 70 01             	lea    0x1(%eax),%esi
  105815:	0f b6 00             	movzbl (%eax),%eax
  105818:	0f be d8             	movsbl %al,%ebx
  10581b:	85 db                	test   %ebx,%ebx
  10581d:	74 26                	je     105845 <vprintfmt+0x242>
  10581f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105823:	78 b6                	js     1057db <vprintfmt+0x1d8>
  105825:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105829:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10582d:	79 ac                	jns    1057db <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10582f:	eb 14                	jmp    105845 <vprintfmt+0x242>
                putch(' ', putdat);
  105831:	83 ec 08             	sub    $0x8,%esp
  105834:	ff 75 0c             	pushl  0xc(%ebp)
  105837:	6a 20                	push   $0x20
  105839:	8b 45 08             	mov    0x8(%ebp),%eax
  10583c:	ff d0                	call   *%eax
  10583e:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105841:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105845:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105849:	7f e6                	jg     105831 <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  10584b:	e9 4e 01 00 00       	jmp    10599e <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105850:	83 ec 08             	sub    $0x8,%esp
  105853:	ff 75 e0             	pushl  -0x20(%ebp)
  105856:	8d 45 14             	lea    0x14(%ebp),%eax
  105859:	50                   	push   %eax
  10585a:	e8 39 fd ff ff       	call   105598 <getint>
  10585f:	83 c4 10             	add    $0x10,%esp
  105862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105865:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10586b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10586e:	85 d2                	test   %edx,%edx
  105870:	79 23                	jns    105895 <vprintfmt+0x292>
                putch('-', putdat);
  105872:	83 ec 08             	sub    $0x8,%esp
  105875:	ff 75 0c             	pushl  0xc(%ebp)
  105878:	6a 2d                	push   $0x2d
  10587a:	8b 45 08             	mov    0x8(%ebp),%eax
  10587d:	ff d0                	call   *%eax
  10587f:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  105882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105888:	f7 d8                	neg    %eax
  10588a:	83 d2 00             	adc    $0x0,%edx
  10588d:	f7 da                	neg    %edx
  10588f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105892:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105895:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10589c:	e9 9f 00 00 00       	jmp    105940 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058a1:	83 ec 08             	sub    $0x8,%esp
  1058a4:	ff 75 e0             	pushl  -0x20(%ebp)
  1058a7:	8d 45 14             	lea    0x14(%ebp),%eax
  1058aa:	50                   	push   %eax
  1058ab:	e8 99 fc ff ff       	call   105549 <getuint>
  1058b0:	83 c4 10             	add    $0x10,%esp
  1058b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058c0:	eb 7e                	jmp    105940 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058c2:	83 ec 08             	sub    $0x8,%esp
  1058c5:	ff 75 e0             	pushl  -0x20(%ebp)
  1058c8:	8d 45 14             	lea    0x14(%ebp),%eax
  1058cb:	50                   	push   %eax
  1058cc:	e8 78 fc ff ff       	call   105549 <getuint>
  1058d1:	83 c4 10             	add    $0x10,%esp
  1058d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058da:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058e1:	eb 5d                	jmp    105940 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1058e3:	83 ec 08             	sub    $0x8,%esp
  1058e6:	ff 75 0c             	pushl  0xc(%ebp)
  1058e9:	6a 30                	push   $0x30
  1058eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ee:	ff d0                	call   *%eax
  1058f0:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1058f3:	83 ec 08             	sub    $0x8,%esp
  1058f6:	ff 75 0c             	pushl  0xc(%ebp)
  1058f9:	6a 78                	push   $0x78
  1058fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fe:	ff d0                	call   *%eax
  105900:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105903:	8b 45 14             	mov    0x14(%ebp),%eax
  105906:	8d 50 04             	lea    0x4(%eax),%edx
  105909:	89 55 14             	mov    %edx,0x14(%ebp)
  10590c:	8b 00                	mov    (%eax),%eax
  10590e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105918:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10591f:	eb 1f                	jmp    105940 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105921:	83 ec 08             	sub    $0x8,%esp
  105924:	ff 75 e0             	pushl  -0x20(%ebp)
  105927:	8d 45 14             	lea    0x14(%ebp),%eax
  10592a:	50                   	push   %eax
  10592b:	e8 19 fc ff ff       	call   105549 <getuint>
  105930:	83 c4 10             	add    $0x10,%esp
  105933:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105936:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105939:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105940:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105944:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105947:	83 ec 04             	sub    $0x4,%esp
  10594a:	52                   	push   %edx
  10594b:	ff 75 e8             	pushl  -0x18(%ebp)
  10594e:	50                   	push   %eax
  10594f:	ff 75 f4             	pushl  -0xc(%ebp)
  105952:	ff 75 f0             	pushl  -0x10(%ebp)
  105955:	ff 75 0c             	pushl  0xc(%ebp)
  105958:	ff 75 08             	pushl  0x8(%ebp)
  10595b:	e8 f8 fa ff ff       	call   105458 <printnum>
  105960:	83 c4 20             	add    $0x20,%esp
            break;
  105963:	eb 39                	jmp    10599e <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105965:	83 ec 08             	sub    $0x8,%esp
  105968:	ff 75 0c             	pushl  0xc(%ebp)
  10596b:	53                   	push   %ebx
  10596c:	8b 45 08             	mov    0x8(%ebp),%eax
  10596f:	ff d0                	call   *%eax
  105971:	83 c4 10             	add    $0x10,%esp
            break;
  105974:	eb 28                	jmp    10599e <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105976:	83 ec 08             	sub    $0x8,%esp
  105979:	ff 75 0c             	pushl  0xc(%ebp)
  10597c:	6a 25                	push   $0x25
  10597e:	8b 45 08             	mov    0x8(%ebp),%eax
  105981:	ff d0                	call   *%eax
  105983:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  105986:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10598a:	eb 04                	jmp    105990 <vprintfmt+0x38d>
  10598c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105990:	8b 45 10             	mov    0x10(%ebp),%eax
  105993:	83 e8 01             	sub    $0x1,%eax
  105996:	0f b6 00             	movzbl (%eax),%eax
  105999:	3c 25                	cmp    $0x25,%al
  10599b:	75 ef                	jne    10598c <vprintfmt+0x389>
                /* do nothing */;
            break;
  10599d:	90                   	nop
        }
    }
  10599e:	e9 68 fc ff ff       	jmp    10560b <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  1059a3:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  1059a7:	5b                   	pop    %ebx
  1059a8:	5e                   	pop    %esi
  1059a9:	5d                   	pop    %ebp
  1059aa:	c3                   	ret    

001059ab <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059ab:	55                   	push   %ebp
  1059ac:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b1:	8b 40 08             	mov    0x8(%eax),%eax
  1059b4:	8d 50 01             	lea    0x1(%eax),%edx
  1059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ba:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c0:	8b 10                	mov    (%eax),%edx
  1059c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c5:	8b 40 04             	mov    0x4(%eax),%eax
  1059c8:	39 c2                	cmp    %eax,%edx
  1059ca:	73 12                	jae    1059de <sprintputch+0x33>
        *b->buf ++ = ch;
  1059cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059cf:	8b 00                	mov    (%eax),%eax
  1059d1:	8d 48 01             	lea    0x1(%eax),%ecx
  1059d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059d7:	89 0a                	mov    %ecx,(%edx)
  1059d9:	8b 55 08             	mov    0x8(%ebp),%edx
  1059dc:	88 10                	mov    %dl,(%eax)
    }
}
  1059de:	90                   	nop
  1059df:	5d                   	pop    %ebp
  1059e0:	c3                   	ret    

001059e1 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1059e1:	55                   	push   %ebp
  1059e2:	89 e5                	mov    %esp,%ebp
  1059e4:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1059e7:	8d 45 14             	lea    0x14(%ebp),%eax
  1059ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1059ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059f0:	50                   	push   %eax
  1059f1:	ff 75 10             	pushl  0x10(%ebp)
  1059f4:	ff 75 0c             	pushl  0xc(%ebp)
  1059f7:	ff 75 08             	pushl  0x8(%ebp)
  1059fa:	e8 0b 00 00 00       	call   105a0a <vsnprintf>
  1059ff:	83 c4 10             	add    $0x10,%esp
  105a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a08:	c9                   	leave  
  105a09:	c3                   	ret    

00105a0a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a0a:	55                   	push   %ebp
  105a0b:	89 e5                	mov    %esp,%ebp
  105a0d:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a10:	8b 45 08             	mov    0x8(%ebp),%eax
  105a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a19:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1f:	01 d0                	add    %edx,%eax
  105a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a2f:	74 0a                	je     105a3b <vsnprintf+0x31>
  105a31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a37:	39 c2                	cmp    %eax,%edx
  105a39:	76 07                	jbe    105a42 <vsnprintf+0x38>
        return -E_INVAL;
  105a3b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a40:	eb 20                	jmp    105a62 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a42:	ff 75 14             	pushl  0x14(%ebp)
  105a45:	ff 75 10             	pushl  0x10(%ebp)
  105a48:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a4b:	50                   	push   %eax
  105a4c:	68 ab 59 10 00       	push   $0x1059ab
  105a51:	e8 ad fb ff ff       	call   105603 <vprintfmt>
  105a56:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  105a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a5c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a62:	c9                   	leave  
  105a63:	c3                   	ret    
