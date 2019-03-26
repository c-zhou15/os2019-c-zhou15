
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 56 2c 00 00       	call   102c7a <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 1d 15 00 00       	call   101549 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 20 34 10 00 	movl   $0x103420,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 3c 34 10 00       	push   $0x10343c
  10003e:	e8 fa 01 00 00       	call   10023d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 7c 08 00 00       	call   1008c7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 74 00 00 00       	call   1000c4 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 e9 28 00 00       	call   10293e <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 32 16 00 00       	call   10168c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 93 17 00 00       	call   1017f2 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 ca 0c 00 00       	call   100d2e <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 60 17 00 00       	call   1017c9 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100069:	eb fe                	jmp    100069 <kern_init+0x69>

0010006b <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006b:	55                   	push   %ebp
  10006c:	89 e5                	mov    %esp,%ebp
  10006e:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100071:	83 ec 04             	sub    $0x4,%esp
  100074:	6a 00                	push   $0x0
  100076:	6a 00                	push   $0x0
  100078:	6a 00                	push   $0x0
  10007a:	e8 9d 0c 00 00       	call   100d1c <mon_backtrace>
  10007f:	83 c4 10             	add    $0x10,%esp
}
  100082:	90                   	nop
  100083:	c9                   	leave  
  100084:	c3                   	ret    

00100085 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100085:	55                   	push   %ebp
  100086:	89 e5                	mov    %esp,%ebp
  100088:	53                   	push   %ebx
  100089:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10008c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10008f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100092:	8d 5d 08             	lea    0x8(%ebp),%ebx
  100095:	8b 45 08             	mov    0x8(%ebp),%eax
  100098:	51                   	push   %ecx
  100099:	52                   	push   %edx
  10009a:	53                   	push   %ebx
  10009b:	50                   	push   %eax
  10009c:	e8 ca ff ff ff       	call   10006b <grade_backtrace2>
  1000a1:	83 c4 10             	add    $0x10,%esp
}
  1000a4:	90                   	nop
  1000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000a8:	c9                   	leave  
  1000a9:	c3                   	ret    

001000aa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b0:	83 ec 08             	sub    $0x8,%esp
  1000b3:	ff 75 10             	pushl  0x10(%ebp)
  1000b6:	ff 75 08             	pushl  0x8(%ebp)
  1000b9:	e8 c7 ff ff ff       	call   100085 <grade_backtrace1>
  1000be:	83 c4 10             	add    $0x10,%esp
}
  1000c1:	90                   	nop
  1000c2:	c9                   	leave  
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ca:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000cf:	83 ec 04             	sub    $0x4,%esp
  1000d2:	68 00 00 ff ff       	push   $0xffff0000
  1000d7:	50                   	push   %eax
  1000d8:	6a 00                	push   $0x0
  1000da:	e8 cb ff ff ff       	call   1000aa <grade_backtrace0>
  1000df:	83 c4 10             	add    $0x10,%esp
}
  1000e2:	90                   	nop
  1000e3:	c9                   	leave  
  1000e4:	c3                   	ret    

001000e5 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000e5:	55                   	push   %ebp
  1000e6:	89 e5                	mov    %esp,%ebp
  1000e8:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000eb:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000ee:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f1:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f4:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000f7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1000fb:	0f b7 c0             	movzwl %ax,%eax
  1000fe:	83 e0 03             	and    $0x3,%eax
  100101:	89 c2                	mov    %eax,%edx
  100103:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100108:	83 ec 04             	sub    $0x4,%esp
  10010b:	52                   	push   %edx
  10010c:	50                   	push   %eax
  10010d:	68 41 34 10 00       	push   $0x103441
  100112:	e8 26 01 00 00       	call   10023d <cprintf>
  100117:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011e:	0f b7 d0             	movzwl %ax,%edx
  100121:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100126:	83 ec 04             	sub    $0x4,%esp
  100129:	52                   	push   %edx
  10012a:	50                   	push   %eax
  10012b:	68 4f 34 10 00       	push   $0x10344f
  100130:	e8 08 01 00 00       	call   10023d <cprintf>
  100135:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  100138:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10013c:	0f b7 d0             	movzwl %ax,%edx
  10013f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100144:	83 ec 04             	sub    $0x4,%esp
  100147:	52                   	push   %edx
  100148:	50                   	push   %eax
  100149:	68 5d 34 10 00       	push   $0x10345d
  10014e:	e8 ea 00 00 00       	call   10023d <cprintf>
  100153:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  100156:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015a:	0f b7 d0             	movzwl %ax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	83 ec 04             	sub    $0x4,%esp
  100165:	52                   	push   %edx
  100166:	50                   	push   %eax
  100167:	68 6b 34 10 00       	push   $0x10346b
  10016c:	e8 cc 00 00 00       	call   10023d <cprintf>
  100171:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100174:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100178:	0f b7 d0             	movzwl %ax,%edx
  10017b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100180:	83 ec 04             	sub    $0x4,%esp
  100183:	52                   	push   %edx
  100184:	50                   	push   %eax
  100185:	68 79 34 10 00       	push   $0x103479
  10018a:	e8 ae 00 00 00       	call   10023d <cprintf>
  10018f:	83 c4 10             	add    $0x10,%esp
    round ++;
  100192:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100197:	83 c0 01             	add    $0x1,%eax
  10019a:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  10019f:	90                   	nop
  1001a0:	c9                   	leave  
  1001a1:	c3                   	ret    

001001a2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a2:	55                   	push   %ebp
  1001a3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001a5:	90                   	nop
  1001a6:	5d                   	pop    %ebp
  1001a7:	c3                   	ret    

001001a8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001a8:	55                   	push   %ebp
  1001a9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ab:	90                   	nop
  1001ac:	5d                   	pop    %ebp
  1001ad:	c3                   	ret    

001001ae <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ae:	55                   	push   %ebp
  1001af:	89 e5                	mov    %esp,%ebp
  1001b1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001b4:	e8 2c ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001b9:	83 ec 0c             	sub    $0xc,%esp
  1001bc:	68 88 34 10 00       	push   $0x103488
  1001c1:	e8 77 00 00 00       	call   10023d <cprintf>
  1001c6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001c9:	e8 d4 ff ff ff       	call   1001a2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ce:	e8 12 ff ff ff       	call   1000e5 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001d3:	83 ec 0c             	sub    $0xc,%esp
  1001d6:	68 a8 34 10 00       	push   $0x1034a8
  1001db:	e8 5d 00 00 00       	call   10023d <cprintf>
  1001e0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001e3:	e8 c0 ff ff ff       	call   1001a8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001e8:	e8 f8 fe ff ff       	call   1000e5 <lab1_print_cur_status>
}
  1001ed:	90                   	nop
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
  1001f3:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  1001f6:	83 ec 0c             	sub    $0xc,%esp
  1001f9:	ff 75 08             	pushl  0x8(%ebp)
  1001fc:	e8 79 13 00 00       	call   10157a <cons_putc>
  100201:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100204:	8b 45 0c             	mov    0xc(%ebp),%eax
  100207:	8b 00                	mov    (%eax),%eax
  100209:	8d 50 01             	lea    0x1(%eax),%edx
  10020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10020f:	89 10                	mov    %edx,(%eax)
}
  100211:	90                   	nop
  100212:	c9                   	leave  
  100213:	c3                   	ret    

00100214 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100214:	55                   	push   %ebp
  100215:	89 e5                	mov    %esp,%ebp
  100217:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10021a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100221:	ff 75 0c             	pushl  0xc(%ebp)
  100224:	ff 75 08             	pushl  0x8(%ebp)
  100227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10022a:	50                   	push   %eax
  10022b:	68 f0 01 10 00       	push   $0x1001f0
  100230:	e8 7b 2d 00 00       	call   102fb0 <vprintfmt>
  100235:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100238:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10023b:	c9                   	leave  
  10023c:	c3                   	ret    

0010023d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10023d:	55                   	push   %ebp
  10023e:	89 e5                	mov    %esp,%ebp
  100240:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100243:	8d 45 0c             	lea    0xc(%ebp),%eax
  100246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10024c:	83 ec 08             	sub    $0x8,%esp
  10024f:	50                   	push   %eax
  100250:	ff 75 08             	pushl  0x8(%ebp)
  100253:	e8 bc ff ff ff       	call   100214 <vcprintf>
  100258:	83 c4 10             	add    $0x10,%esp
  10025b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100261:	c9                   	leave  
  100262:	c3                   	ret    

00100263 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100263:	55                   	push   %ebp
  100264:	89 e5                	mov    %esp,%ebp
  100266:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100269:	83 ec 0c             	sub    $0xc,%esp
  10026c:	ff 75 08             	pushl  0x8(%ebp)
  10026f:	e8 06 13 00 00       	call   10157a <cons_putc>
  100274:	83 c4 10             	add    $0x10,%esp
}
  100277:	90                   	nop
  100278:	c9                   	leave  
  100279:	c3                   	ret    

0010027a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10027a:	55                   	push   %ebp
  10027b:	89 e5                	mov    %esp,%ebp
  10027d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100280:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100287:	eb 14                	jmp    10029d <cputs+0x23>
        cputch(c, &cnt);
  100289:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10028d:	83 ec 08             	sub    $0x8,%esp
  100290:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100293:	52                   	push   %edx
  100294:	50                   	push   %eax
  100295:	e8 56 ff ff ff       	call   1001f0 <cputch>
  10029a:	83 c4 10             	add    $0x10,%esp
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10029d:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a0:	8d 50 01             	lea    0x1(%eax),%edx
  1002a3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002a6:	0f b6 00             	movzbl (%eax),%eax
  1002a9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002ac:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002b0:	75 d7                	jne    100289 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002b2:	83 ec 08             	sub    $0x8,%esp
  1002b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002b8:	50                   	push   %eax
  1002b9:	6a 0a                	push   $0xa
  1002bb:	e8 30 ff ff ff       	call   1001f0 <cputch>
  1002c0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002c6:	c9                   	leave  
  1002c7:	c3                   	ret    

001002c8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ce:	e8 d7 12 00 00       	call   1015aa <cons_getc>
  1002d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002da:	74 f2                	je     1002ce <getchar+0x6>
        /* do nothing */;
    return c;
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002df:	c9                   	leave  
  1002e0:	c3                   	ret    

001002e1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002e1:	55                   	push   %ebp
  1002e2:	89 e5                	mov    %esp,%ebp
  1002e4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002eb:	74 13                	je     100300 <readline+0x1f>
        cprintf("%s", prompt);
  1002ed:	83 ec 08             	sub    $0x8,%esp
  1002f0:	ff 75 08             	pushl  0x8(%ebp)
  1002f3:	68 c7 34 10 00       	push   $0x1034c7
  1002f8:	e8 40 ff ff ff       	call   10023d <cprintf>
  1002fd:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100307:	e8 bc ff ff ff       	call   1002c8 <getchar>
  10030c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10030f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100313:	79 0a                	jns    10031f <readline+0x3e>
            return NULL;
  100315:	b8 00 00 00 00       	mov    $0x0,%eax
  10031a:	e9 82 00 00 00       	jmp    1003a1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10031f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100323:	7e 2b                	jle    100350 <readline+0x6f>
  100325:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10032c:	7f 22                	jg     100350 <readline+0x6f>
            cputchar(c);
  10032e:	83 ec 0c             	sub    $0xc,%esp
  100331:	ff 75 f0             	pushl  -0x10(%ebp)
  100334:	e8 2a ff ff ff       	call   100263 <cputchar>
  100339:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10033f:	8d 50 01             	lea    0x1(%eax),%edx
  100342:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100345:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100348:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10034e:	eb 4c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100350:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100354:	75 1a                	jne    100370 <readline+0x8f>
  100356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10035a:	7e 14                	jle    100370 <readline+0x8f>
            cputchar(c);
  10035c:	83 ec 0c             	sub    $0xc,%esp
  10035f:	ff 75 f0             	pushl  -0x10(%ebp)
  100362:	e8 fc fe ff ff       	call   100263 <cputchar>
  100367:	83 c4 10             	add    $0x10,%esp
            i --;
  10036a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10036e:	eb 2c                	jmp    10039c <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100370:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100374:	74 06                	je     10037c <readline+0x9b>
  100376:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10037a:	75 8b                	jne    100307 <readline+0x26>
            cputchar(c);
  10037c:	83 ec 0c             	sub    $0xc,%esp
  10037f:	ff 75 f0             	pushl  -0x10(%ebp)
  100382:	e8 dc fe ff ff       	call   100263 <cputchar>
  100387:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10038a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  100392:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100395:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  10039a:	eb 05                	jmp    1003a1 <readline+0xc0>
        }
    }
  10039c:	e9 66 ff ff ff       	jmp    100307 <readline+0x26>
}
  1003a1:	c9                   	leave  
  1003a2:	c3                   	ret    

001003a3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003a3:	55                   	push   %ebp
  1003a4:	89 e5                	mov    %esp,%ebp
  1003a6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003a9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ae:	85 c0                	test   %eax,%eax
  1003b0:	75 4a                	jne    1003fc <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003b2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003b9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003bc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003c2:	83 ec 04             	sub    $0x4,%esp
  1003c5:	ff 75 0c             	pushl  0xc(%ebp)
  1003c8:	ff 75 08             	pushl  0x8(%ebp)
  1003cb:	68 ca 34 10 00       	push   $0x1034ca
  1003d0:	e8 68 fe ff ff       	call   10023d <cprintf>
  1003d5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003db:	83 ec 08             	sub    $0x8,%esp
  1003de:	50                   	push   %eax
  1003df:	ff 75 10             	pushl  0x10(%ebp)
  1003e2:	e8 2d fe ff ff       	call   100214 <vcprintf>
  1003e7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003ea:	83 ec 0c             	sub    $0xc,%esp
  1003ed:	68 e6 34 10 00       	push   $0x1034e6
  1003f2:	e8 46 fe ff ff       	call   10023d <cprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
  1003fa:	eb 01                	jmp    1003fd <__panic+0x5a>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  1003fc:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  1003fd:	e8 ce 13 00 00       	call   1017d0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100402:	83 ec 0c             	sub    $0xc,%esp
  100405:	6a 00                	push   $0x0
  100407:	e8 36 08 00 00       	call   100c42 <kmonitor>
  10040c:	83 c4 10             	add    $0x10,%esp
    }
  10040f:	eb f1                	jmp    100402 <__panic+0x5f>

00100411 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100411:	55                   	push   %ebp
  100412:	89 e5                	mov    %esp,%ebp
  100414:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100417:	8d 45 14             	lea    0x14(%ebp),%eax
  10041a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10041d:	83 ec 04             	sub    $0x4,%esp
  100420:	ff 75 0c             	pushl  0xc(%ebp)
  100423:	ff 75 08             	pushl  0x8(%ebp)
  100426:	68 e8 34 10 00       	push   $0x1034e8
  10042b:	e8 0d fe ff ff       	call   10023d <cprintf>
  100430:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100436:	83 ec 08             	sub    $0x8,%esp
  100439:	50                   	push   %eax
  10043a:	ff 75 10             	pushl  0x10(%ebp)
  10043d:	e8 d2 fd ff ff       	call   100214 <vcprintf>
  100442:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100445:	83 ec 0c             	sub    $0xc,%esp
  100448:	68 e6 34 10 00       	push   $0x1034e6
  10044d:	e8 eb fd ff ff       	call   10023d <cprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100455:	90                   	nop
  100456:	c9                   	leave  
  100457:	c3                   	ret    

00100458 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100458:	55                   	push   %ebp
  100459:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10045b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100460:	5d                   	pop    %ebp
  100461:	c3                   	ret    

00100462 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
  100465:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10046b:	8b 00                	mov    (%eax),%eax
  10046d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100470:	8b 45 10             	mov    0x10(%ebp),%eax
  100473:	8b 00                	mov    (%eax),%eax
  100475:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10047f:	e9 d2 00 00 00       	jmp    100556 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10048a:	01 d0                	add    %edx,%eax
  10048c:	89 c2                	mov    %eax,%edx
  10048e:	c1 ea 1f             	shr    $0x1f,%edx
  100491:	01 d0                	add    %edx,%eax
  100493:	d1 f8                	sar    %eax
  100495:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10049b:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10049e:	eb 04                	jmp    1004a4 <stab_binsearch+0x42>
            m --;
  1004a0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004aa:	7c 1f                	jl     1004cb <stab_binsearch+0x69>
  1004ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004af:	89 d0                	mov    %edx,%eax
  1004b1:	01 c0                	add    %eax,%eax
  1004b3:	01 d0                	add    %edx,%eax
  1004b5:	c1 e0 02             	shl    $0x2,%eax
  1004b8:	89 c2                	mov    %eax,%edx
  1004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1004bd:	01 d0                	add    %edx,%eax
  1004bf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004c3:	0f b6 c0             	movzbl %al,%eax
  1004c6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004c9:	75 d5                	jne    1004a0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d1:	7d 0b                	jge    1004de <stab_binsearch+0x7c>
            l = true_m + 1;
  1004d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d6:	83 c0 01             	add    $0x1,%eax
  1004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004dc:	eb 78                	jmp    100556 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004de:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	8b 40 08             	mov    0x8(%eax),%eax
  1004fb:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004fe:	73 13                	jae    100513 <stab_binsearch+0xb1>
            *region_left = m;
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10050b:	83 c0 01             	add    $0x1,%eax
  10050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100511:	eb 43                	jmp    100556 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052c:	76 16                	jbe    100544 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100531:	8d 50 ff             	lea    -0x1(%eax),%edx
  100534:	8b 45 10             	mov    0x10(%ebp),%eax
  100537:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10053c:	83 e8 01             	sub    $0x1,%eax
  10053f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100542:	eb 12                	jmp    100556 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
            l = m;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100552:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100559:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10055c:	0f 8e 22 ff ff ff    	jle    100484 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100566:	75 0f                	jne    100577 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056b:	8b 00                	mov    (%eax),%eax
  10056d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100575:	eb 3f                	jmp    1005b6 <stab_binsearch+0x154>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100577:	8b 45 10             	mov    0x10(%ebp),%eax
  10057a:	8b 00                	mov    (%eax),%eax
  10057c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10057f:	eb 04                	jmp    100585 <stab_binsearch+0x123>
  100581:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100585:	8b 45 0c             	mov    0xc(%ebp),%eax
  100588:	8b 00                	mov    (%eax),%eax
  10058a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10058d:	7d 1f                	jge    1005ae <stab_binsearch+0x14c>
  10058f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100592:	89 d0                	mov    %edx,%eax
  100594:	01 c0                	add    %eax,%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	c1 e0 02             	shl    $0x2,%eax
  10059b:	89 c2                	mov    %eax,%edx
  10059d:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a0:	01 d0                	add    %edx,%eax
  1005a2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005a6:	0f b6 c0             	movzbl %al,%eax
  1005a9:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ac:	75 d3                	jne    100581 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b4:	89 10                	mov    %edx,(%eax)
    }
}
  1005b6:	90                   	nop
  1005b7:	c9                   	leave  
  1005b8:	c3                   	ret    

001005b9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005b9:	55                   	push   %ebp
  1005ba:	89 e5                	mov    %esp,%ebp
  1005bc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	c7 00 08 35 10 00    	movl   $0x103508,(%eax)
    info->eip_line = 0;
  1005c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	c7 40 08 08 35 10 00 	movl   $0x103508,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005ec:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  1005f9:	c7 45 f4 2c 3d 10 00 	movl   $0x103d2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100600:	c7 45 f0 70 b6 10 00 	movl   $0x10b670,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100607:	c7 45 ec 71 b6 10 00 	movl   $0x10b671,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10060e:	c7 45 e8 a5 d6 10 00 	movl   $0x10d6a5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100615:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100618:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10061b:	76 0d                	jbe    10062a <debuginfo_eip+0x71>
  10061d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100620:	83 e8 01             	sub    $0x1,%eax
  100623:	0f b6 00             	movzbl (%eax),%eax
  100626:	84 c0                	test   %al,%al
  100628:	74 0a                	je     100634 <debuginfo_eip+0x7b>
        return -1;
  10062a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10062f:	e9 91 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100634:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10063b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10063e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100641:	29 c2                	sub    %eax,%edx
  100643:	89 d0                	mov    %edx,%eax
  100645:	c1 f8 02             	sar    $0x2,%eax
  100648:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10064e:	83 e8 01             	sub    $0x1,%eax
  100651:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100654:	ff 75 08             	pushl  0x8(%ebp)
  100657:	6a 64                	push   $0x64
  100659:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10065c:	50                   	push   %eax
  10065d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100660:	50                   	push   %eax
  100661:	ff 75 f4             	pushl  -0xc(%ebp)
  100664:	e8 f9 fd ff ff       	call   100462 <stab_binsearch>
  100669:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10066c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10066f:	85 c0                	test   %eax,%eax
  100671:	75 0a                	jne    10067d <debuginfo_eip+0xc4>
        return -1;
  100673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100678:	e9 48 02 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10067d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100680:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100686:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100689:	ff 75 08             	pushl  0x8(%ebp)
  10068c:	6a 24                	push   $0x24
  10068e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100691:	50                   	push   %eax
  100692:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100695:	50                   	push   %eax
  100696:	ff 75 f4             	pushl  -0xc(%ebp)
  100699:	e8 c4 fd ff ff       	call   100462 <stab_binsearch>
  10069e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a7:	39 c2                	cmp    %eax,%edx
  1006a9:	7f 7c                	jg     100727 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006ae:	89 c2                	mov    %eax,%edx
  1006b0:	89 d0                	mov    %edx,%eax
  1006b2:	01 c0                	add    %eax,%eax
  1006b4:	01 d0                	add    %edx,%eax
  1006b6:	c1 e0 02             	shl    $0x2,%eax
  1006b9:	89 c2                	mov    %eax,%edx
  1006bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006be:	01 d0                	add    %edx,%eax
  1006c0:	8b 00                	mov    (%eax),%eax
  1006c2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006c8:	29 d1                	sub    %edx,%ecx
  1006ca:	89 ca                	mov    %ecx,%edx
  1006cc:	39 d0                	cmp    %edx,%eax
  1006ce:	73 22                	jae    1006f2 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006d3:	89 c2                	mov    %eax,%edx
  1006d5:	89 d0                	mov    %edx,%eax
  1006d7:	01 c0                	add    %eax,%eax
  1006d9:	01 d0                	add    %edx,%eax
  1006db:	c1 e0 02             	shl    $0x2,%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e3:	01 d0                	add    %edx,%eax
  1006e5:	8b 10                	mov    (%eax),%edx
  1006e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006ea:	01 c2                	add    %eax,%edx
  1006ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ef:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1006f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f5:	89 c2                	mov    %eax,%edx
  1006f7:	89 d0                	mov    %edx,%eax
  1006f9:	01 c0                	add    %eax,%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	c1 e0 02             	shl    $0x2,%eax
  100700:	89 c2                	mov    %eax,%edx
  100702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100705:	01 d0                	add    %edx,%eax
  100707:	8b 50 08             	mov    0x8(%eax),%edx
  10070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100710:	8b 45 0c             	mov    0xc(%ebp),%eax
  100713:	8b 40 10             	mov    0x10(%eax),%eax
  100716:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10071c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10071f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100722:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100725:	eb 15                	jmp    10073c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072a:	8b 55 08             	mov    0x8(%ebp),%edx
  10072d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100733:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100736:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100739:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10073c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073f:	8b 40 08             	mov    0x8(%eax),%eax
  100742:	83 ec 08             	sub    $0x8,%esp
  100745:	6a 3a                	push   $0x3a
  100747:	50                   	push   %eax
  100748:	e8 a1 23 00 00       	call   102aee <strfind>
  10074d:	83 c4 10             	add    $0x10,%esp
  100750:	89 c2                	mov    %eax,%edx
  100752:	8b 45 0c             	mov    0xc(%ebp),%eax
  100755:	8b 40 08             	mov    0x8(%eax),%eax
  100758:	29 c2                	sub    %eax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100760:	83 ec 0c             	sub    $0xc,%esp
  100763:	ff 75 08             	pushl  0x8(%ebp)
  100766:	6a 44                	push   $0x44
  100768:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10076b:	50                   	push   %eax
  10076c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10076f:	50                   	push   %eax
  100770:	ff 75 f4             	pushl  -0xc(%ebp)
  100773:	e8 ea fc ff ff       	call   100462 <stab_binsearch>
  100778:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10077b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10077e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100781:	39 c2                	cmp    %eax,%edx
  100783:	7f 24                	jg     1007a9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100785:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100788:	89 c2                	mov    %eax,%edx
  10078a:	89 d0                	mov    %edx,%eax
  10078c:	01 c0                	add    %eax,%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	c1 e0 02             	shl    $0x2,%eax
  100793:	89 c2                	mov    %eax,%edx
  100795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10079e:	0f b7 d0             	movzwl %ax,%edx
  1007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007a7:	eb 13                	jmp    1007bc <debuginfo_eip+0x203>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ae:	e9 12 01 00 00       	jmp    1008c5 <debuginfo_eip+0x30c>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b6:	83 e8 01             	sub    $0x1,%eax
  1007b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007c2:	39 c2                	cmp    %eax,%edx
  1007c4:	7c 56                	jl     10081c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c9:	89 c2                	mov    %eax,%edx
  1007cb:	89 d0                	mov    %edx,%eax
  1007cd:	01 c0                	add    %eax,%eax
  1007cf:	01 d0                	add    %edx,%eax
  1007d1:	c1 e0 02             	shl    $0x2,%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d9:	01 d0                	add    %edx,%eax
  1007db:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007df:	3c 84                	cmp    $0x84,%al
  1007e1:	74 39                	je     10081c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	89 d0                	mov    %edx,%eax
  1007ea:	01 c0                	add    %eax,%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	c1 e0 02             	shl    $0x2,%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f6:	01 d0                	add    %edx,%eax
  1007f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007fc:	3c 64                	cmp    $0x64,%al
  1007fe:	75 b3                	jne    1007b3 <debuginfo_eip+0x1fa>
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 40 08             	mov    0x8(%eax),%eax
  100818:	85 c0                	test   %eax,%eax
  10081a:	74 97                	je     1007b3 <debuginfo_eip+0x1fa>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10081c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100822:	39 c2                	cmp    %eax,%edx
  100824:	7c 46                	jl     10086c <debuginfo_eip+0x2b3>
  100826:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100829:	89 c2                	mov    %eax,%edx
  10082b:	89 d0                	mov    %edx,%eax
  10082d:	01 c0                	add    %eax,%eax
  10082f:	01 d0                	add    %edx,%eax
  100831:	c1 e0 02             	shl    $0x2,%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	8b 00                	mov    (%eax),%eax
  10083d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100843:	29 d1                	sub    %edx,%ecx
  100845:	89 ca                	mov    %ecx,%edx
  100847:	39 d0                	cmp    %edx,%eax
  100849:	73 21                	jae    10086c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10084b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084e:	89 c2                	mov    %eax,%edx
  100850:	89 d0                	mov    %edx,%eax
  100852:	01 c0                	add    %eax,%eax
  100854:	01 d0                	add    %edx,%eax
  100856:	c1 e0 02             	shl    $0x2,%eax
  100859:	89 c2                	mov    %eax,%edx
  10085b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085e:	01 d0                	add    %edx,%eax
  100860:	8b 10                	mov    (%eax),%edx
  100862:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100865:	01 c2                	add    %eax,%edx
  100867:	8b 45 0c             	mov    0xc(%ebp),%eax
  10086a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10086c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10086f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100872:	39 c2                	cmp    %eax,%edx
  100874:	7d 4a                	jge    1008c0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100876:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100879:	83 c0 01             	add    $0x1,%eax
  10087c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10087f:	eb 18                	jmp    100899 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100881:	8b 45 0c             	mov    0xc(%ebp),%eax
  100884:	8b 40 14             	mov    0x14(%eax),%eax
  100887:	8d 50 01             	lea    0x1(%eax),%edx
  10088a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10088d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	83 c0 01             	add    $0x1,%eax
  100896:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100899:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10089c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10089f:	39 c2                	cmp    %eax,%edx
  1008a1:	7d 1d                	jge    1008c0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	89 d0                	mov    %edx,%eax
  1008aa:	01 c0                	add    %eax,%eax
  1008ac:	01 d0                	add    %edx,%eax
  1008ae:	c1 e0 02             	shl    $0x2,%eax
  1008b1:	89 c2                	mov    %eax,%edx
  1008b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b6:	01 d0                	add    %edx,%eax
  1008b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008bc:	3c a0                	cmp    $0xa0,%al
  1008be:	74 c1                	je     100881 <debuginfo_eip+0x2c8>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008c5:	c9                   	leave  
  1008c6:	c3                   	ret    

001008c7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008c7:	55                   	push   %ebp
  1008c8:	89 e5                	mov    %esp,%ebp
  1008ca:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008cd:	83 ec 0c             	sub    $0xc,%esp
  1008d0:	68 12 35 10 00       	push   $0x103512
  1008d5:	e8 63 f9 ff ff       	call   10023d <cprintf>
  1008da:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008dd:	83 ec 08             	sub    $0x8,%esp
  1008e0:	68 00 00 10 00       	push   $0x100000
  1008e5:	68 2b 35 10 00       	push   $0x10352b
  1008ea:	e8 4e f9 ff ff       	call   10023d <cprintf>
  1008ef:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008f2:	83 ec 08             	sub    $0x8,%esp
  1008f5:	68 11 34 10 00       	push   $0x103411
  1008fa:	68 43 35 10 00       	push   $0x103543
  1008ff:	e8 39 f9 ff ff       	call   10023d <cprintf>
  100904:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100907:	83 ec 08             	sub    $0x8,%esp
  10090a:	68 16 ea 10 00       	push   $0x10ea16
  10090f:	68 5b 35 10 00       	push   $0x10355b
  100914:	e8 24 f9 ff ff       	call   10023d <cprintf>
  100919:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10091c:	83 ec 08             	sub    $0x8,%esp
  10091f:	68 20 fd 10 00       	push   $0x10fd20
  100924:	68 73 35 10 00       	push   $0x103573
  100929:	e8 0f f9 ff ff       	call   10023d <cprintf>
  10092e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100931:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100936:	05 ff 03 00 00       	add    $0x3ff,%eax
  10093b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100940:	29 d0                	sub    %edx,%eax
  100942:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100948:	85 c0                	test   %eax,%eax
  10094a:	0f 48 c2             	cmovs  %edx,%eax
  10094d:	c1 f8 0a             	sar    $0xa,%eax
  100950:	83 ec 08             	sub    $0x8,%esp
  100953:	50                   	push   %eax
  100954:	68 8c 35 10 00       	push   $0x10358c
  100959:	e8 df f8 ff ff       	call   10023d <cprintf>
  10095e:	83 c4 10             	add    $0x10,%esp
}
  100961:	90                   	nop
  100962:	c9                   	leave  
  100963:	c3                   	ret    

00100964 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100964:	55                   	push   %ebp
  100965:	89 e5                	mov    %esp,%ebp
  100967:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10096d:	83 ec 08             	sub    $0x8,%esp
  100970:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100973:	50                   	push   %eax
  100974:	ff 75 08             	pushl  0x8(%ebp)
  100977:	e8 3d fc ff ff       	call   1005b9 <debuginfo_eip>
  10097c:	83 c4 10             	add    $0x10,%esp
  10097f:	85 c0                	test   %eax,%eax
  100981:	74 15                	je     100998 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100983:	83 ec 08             	sub    $0x8,%esp
  100986:	ff 75 08             	pushl  0x8(%ebp)
  100989:	68 b6 35 10 00       	push   $0x1035b6
  10098e:	e8 aa f8 ff ff       	call   10023d <cprintf>
  100993:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100996:	eb 65                	jmp    1009fd <print_debuginfo+0x99>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10099f:	eb 1c                	jmp    1009bd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009a7:	01 d0                	add    %edx,%eax
  1009a9:	0f b6 00             	movzbl (%eax),%eax
  1009ac:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009b5:	01 ca                	add    %ecx,%edx
  1009b7:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009c0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009c3:	7f dc                	jg     1009a1 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009c5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	01 d0                	add    %edx,%eax
  1009d0:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  1009d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009d9:	89 d1                	mov    %edx,%ecx
  1009db:	29 c1                	sub    %eax,%ecx
  1009dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009e3:	83 ec 0c             	sub    $0xc,%esp
  1009e6:	51                   	push   %ecx
  1009e7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ed:	51                   	push   %ecx
  1009ee:	52                   	push   %edx
  1009ef:	50                   	push   %eax
  1009f0:	68 d2 35 10 00       	push   $0x1035d2
  1009f5:	e8 43 f8 ff ff       	call   10023d <cprintf>
  1009fa:	83 c4 20             	add    $0x20,%esp
                fnname, eip - info.eip_fn_addr);
    }
}
  1009fd:	90                   	nop
  1009fe:	c9                   	leave  
  1009ff:	c3                   	ret    

00100a00 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a00:	55                   	push   %ebp
  100a01:	89 e5                	mov    %esp,%ebp
  100a03:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a06:	8b 45 04             	mov    0x4(%ebp),%eax
  100a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a0f:	c9                   	leave  
  100a10:	c3                   	ret    

00100a11 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a11:	55                   	push   %ebp
  100a12:	89 e5                	mov    %esp,%ebp
  100a14:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a17:	89 e8                	mov    %ebp,%eax
  100a19:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  100a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();
  100a22:	e8 d9 ff ff ff       	call   100a00 <read_eip>
  100a27:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
  100a2a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a31:	e9 8d 00 00 00       	jmp    100ac3 <print_stackframe+0xb2>
	{

	//打印当前ebp和eip的地址

		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a36:	83 ec 04             	sub    $0x4,%esp
  100a39:	ff 75 f0             	pushl  -0x10(%ebp)
  100a3c:	ff 75 f4             	pushl  -0xc(%ebp)
  100a3f:	68 e4 35 10 00       	push   $0x1035e4
  100a44:	e8 f4 f7 ff ff       	call   10023d <cprintf>
  100a49:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;
  100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4f:	83 c0 08             	add    $0x8,%eax
  100a52:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
  100a55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a5c:	eb 26                	jmp    100a84 <print_stackframe+0x73>

		    cprintf("0x%08x ", args[j]);
  100a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a6b:	01 d0                	add    %edx,%eax
  100a6d:	8b 00                	mov    (%eax),%eax
  100a6f:	83 ec 08             	sub    $0x8,%esp
  100a72:	50                   	push   %eax
  100a73:	68 00 36 10 00       	push   $0x103600
  100a78:	e8 c0 f7 ff ff       	call   10023d <cprintf>
  100a7d:	83 c4 10             	add    $0x10,%esp

		uint32_t *args = (uint32_t *)ebp + 2;

	//读出参数的相关声明

		for (j = 0; j < 4; j ++) {
  100a80:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a84:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a88:	7e d4                	jle    100a5e <print_stackframe+0x4d>

		    cprintf("0x%08x ", args[j]);

		}

		cprintf("\n");
  100a8a:	83 ec 0c             	sub    $0xc,%esp
  100a8d:	68 08 36 10 00       	push   $0x103608
  100a92:	e8 a6 f7 ff ff       	call   10023d <cprintf>
  100a97:	83 c4 10             	add    $0x10,%esp

		print_debuginfo(eip - 1);
  100a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a9d:	83 e8 01             	sub    $0x1,%eax
  100aa0:	83 ec 0c             	sub    $0xc,%esp
  100aa3:	50                   	push   %eax
  100aa4:	e8 bb fe ff ff       	call   100964 <print_debuginfo>
  100aa9:	83 c4 10             	add    $0x10,%esp

		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容
  100aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aaf:	83 c0 04             	add    $0x4,%eax
  100ab2:	8b 00                	mov    (%eax),%eax
  100ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容
  100ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aba:	8b 00                	mov    (%eax),%eax
  100abc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	uint32_t eip = read_eip();

	int i, j;

	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH;i++)
  100abf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ac7:	74 0a                	je     100ad3 <print_stackframe+0xc2>
  100ac9:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100acd:	0f 8e 63 ff ff ff    	jle    100a36 <print_stackframe+0x25>
		eip = ((uint32_t *)ebp)[1];//eip为压到栈中的eip地址的内容

		ebp = ((uint32_t *)ebp)[0];//ebp为压入栈中的ebp所在地址的内容

	 }
}
  100ad3:	90                   	nop
  100ad4:	c9                   	leave  
  100ad5:	c3                   	ret    

00100ad6 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ad6:	55                   	push   %ebp
  100ad7:	89 e5                	mov    %esp,%ebp
  100ad9:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100adc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ae3:	eb 0c                	jmp    100af1 <parse+0x1b>
            *buf ++ = '\0';
  100ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae8:	8d 50 01             	lea    0x1(%eax),%edx
  100aeb:	89 55 08             	mov    %edx,0x8(%ebp)
  100aee:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af1:	8b 45 08             	mov    0x8(%ebp),%eax
  100af4:	0f b6 00             	movzbl (%eax),%eax
  100af7:	84 c0                	test   %al,%al
  100af9:	74 1e                	je     100b19 <parse+0x43>
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	0f b6 00             	movzbl (%eax),%eax
  100b01:	0f be c0             	movsbl %al,%eax
  100b04:	83 ec 08             	sub    $0x8,%esp
  100b07:	50                   	push   %eax
  100b08:	68 8c 36 10 00       	push   $0x10368c
  100b0d:	e8 a9 1f 00 00       	call   102abb <strchr>
  100b12:	83 c4 10             	add    $0x10,%esp
  100b15:	85 c0                	test   %eax,%eax
  100b17:	75 cc                	jne    100ae5 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b19:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1c:	0f b6 00             	movzbl (%eax),%eax
  100b1f:	84 c0                	test   %al,%al
  100b21:	74 69                	je     100b8c <parse+0xb6>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b23:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b27:	75 12                	jne    100b3b <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b29:	83 ec 08             	sub    $0x8,%esp
  100b2c:	6a 10                	push   $0x10
  100b2e:	68 91 36 10 00       	push   $0x103691
  100b33:	e8 05 f7 ff ff       	call   10023d <cprintf>
  100b38:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b3e:	8d 50 01             	lea    0x1(%eax),%edx
  100b41:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b44:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b4e:	01 c2                	add    %eax,%edx
  100b50:	8b 45 08             	mov    0x8(%ebp),%eax
  100b53:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b55:	eb 04                	jmp    100b5b <parse+0x85>
            buf ++;
  100b57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b5e:	0f b6 00             	movzbl (%eax),%eax
  100b61:	84 c0                	test   %al,%al
  100b63:	0f 84 7a ff ff ff    	je     100ae3 <parse+0xd>
  100b69:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6c:	0f b6 00             	movzbl (%eax),%eax
  100b6f:	0f be c0             	movsbl %al,%eax
  100b72:	83 ec 08             	sub    $0x8,%esp
  100b75:	50                   	push   %eax
  100b76:	68 8c 36 10 00       	push   $0x10368c
  100b7b:	e8 3b 1f 00 00       	call   102abb <strchr>
  100b80:	83 c4 10             	add    $0x10,%esp
  100b83:	85 c0                	test   %eax,%eax
  100b85:	74 d0                	je     100b57 <parse+0x81>
            buf ++;
        }
    }
  100b87:	e9 57 ff ff ff       	jmp    100ae3 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b8c:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b90:	c9                   	leave  
  100b91:	c3                   	ret    

00100b92 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b92:	55                   	push   %ebp
  100b93:	89 e5                	mov    %esp,%ebp
  100b95:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b98:	83 ec 08             	sub    $0x8,%esp
  100b9b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b9e:	50                   	push   %eax
  100b9f:	ff 75 08             	pushl  0x8(%ebp)
  100ba2:	e8 2f ff ff ff       	call   100ad6 <parse>
  100ba7:	83 c4 10             	add    $0x10,%esp
  100baa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bb1:	75 0a                	jne    100bbd <runcmd+0x2b>
        return 0;
  100bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  100bb8:	e9 83 00 00 00       	jmp    100c40 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bc4:	eb 59                	jmp    100c1f <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bc6:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bcc:	89 d0                	mov    %edx,%eax
  100bce:	01 c0                	add    %eax,%eax
  100bd0:	01 d0                	add    %edx,%eax
  100bd2:	c1 e0 02             	shl    $0x2,%eax
  100bd5:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bda:	8b 00                	mov    (%eax),%eax
  100bdc:	83 ec 08             	sub    $0x8,%esp
  100bdf:	51                   	push   %ecx
  100be0:	50                   	push   %eax
  100be1:	e8 35 1e 00 00       	call   102a1b <strcmp>
  100be6:	83 c4 10             	add    $0x10,%esp
  100be9:	85 c0                	test   %eax,%eax
  100beb:	75 2e                	jne    100c1b <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bf0:	89 d0                	mov    %edx,%eax
  100bf2:	01 c0                	add    %eax,%eax
  100bf4:	01 d0                	add    %edx,%eax
  100bf6:	c1 e0 02             	shl    $0x2,%eax
  100bf9:	05 08 e0 10 00       	add    $0x10e008,%eax
  100bfe:	8b 10                	mov    (%eax),%edx
  100c00:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c03:	83 c0 04             	add    $0x4,%eax
  100c06:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c09:	83 e9 01             	sub    $0x1,%ecx
  100c0c:	83 ec 04             	sub    $0x4,%esp
  100c0f:	ff 75 0c             	pushl  0xc(%ebp)
  100c12:	50                   	push   %eax
  100c13:	51                   	push   %ecx
  100c14:	ff d2                	call   *%edx
  100c16:	83 c4 10             	add    $0x10,%esp
  100c19:	eb 25                	jmp    100c40 <runcmd+0xae>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c22:	83 f8 02             	cmp    $0x2,%eax
  100c25:	76 9f                	jbe    100bc6 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c27:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c2a:	83 ec 08             	sub    $0x8,%esp
  100c2d:	50                   	push   %eax
  100c2e:	68 af 36 10 00       	push   $0x1036af
  100c33:	e8 05 f6 ff ff       	call   10023d <cprintf>
  100c38:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c40:	c9                   	leave  
  100c41:	c3                   	ret    

00100c42 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c42:	55                   	push   %ebp
  100c43:	89 e5                	mov    %esp,%ebp
  100c45:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c48:	83 ec 0c             	sub    $0xc,%esp
  100c4b:	68 c8 36 10 00       	push   $0x1036c8
  100c50:	e8 e8 f5 ff ff       	call   10023d <cprintf>
  100c55:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c58:	83 ec 0c             	sub    $0xc,%esp
  100c5b:	68 f0 36 10 00       	push   $0x1036f0
  100c60:	e8 d8 f5 ff ff       	call   10023d <cprintf>
  100c65:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c6c:	74 0e                	je     100c7c <kmonitor+0x3a>
        print_trapframe(tf);
  100c6e:	83 ec 0c             	sub    $0xc,%esp
  100c71:	ff 75 08             	pushl  0x8(%ebp)
  100c74:	e8 32 0d 00 00       	call   1019ab <print_trapframe>
  100c79:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c7c:	83 ec 0c             	sub    $0xc,%esp
  100c7f:	68 15 37 10 00       	push   $0x103715
  100c84:	e8 58 f6 ff ff       	call   1002e1 <readline>
  100c89:	83 c4 10             	add    $0x10,%esp
  100c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c93:	74 e7                	je     100c7c <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100c95:	83 ec 08             	sub    $0x8,%esp
  100c98:	ff 75 08             	pushl  0x8(%ebp)
  100c9b:	ff 75 f4             	pushl  -0xc(%ebp)
  100c9e:	e8 ef fe ff ff       	call   100b92 <runcmd>
  100ca3:	83 c4 10             	add    $0x10,%esp
  100ca6:	85 c0                	test   %eax,%eax
  100ca8:	78 02                	js     100cac <kmonitor+0x6a>
                break;
            }
        }
    }
  100caa:	eb d0                	jmp    100c7c <kmonitor+0x3a>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100cac:	90                   	nop
            }
        }
    }
}
  100cad:	90                   	nop
  100cae:	c9                   	leave  
  100caf:	c3                   	ret    

00100cb0 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cb0:	55                   	push   %ebp
  100cb1:	89 e5                	mov    %esp,%ebp
  100cb3:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cbd:	eb 3c                	jmp    100cfb <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cc2:	89 d0                	mov    %edx,%eax
  100cc4:	01 c0                	add    %eax,%eax
  100cc6:	01 d0                	add    %edx,%eax
  100cc8:	c1 e0 02             	shl    $0x2,%eax
  100ccb:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cd0:	8b 08                	mov    (%eax),%ecx
  100cd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd5:	89 d0                	mov    %edx,%eax
  100cd7:	01 c0                	add    %eax,%eax
  100cd9:	01 d0                	add    %edx,%eax
  100cdb:	c1 e0 02             	shl    $0x2,%eax
  100cde:	05 00 e0 10 00       	add    $0x10e000,%eax
  100ce3:	8b 00                	mov    (%eax),%eax
  100ce5:	83 ec 04             	sub    $0x4,%esp
  100ce8:	51                   	push   %ecx
  100ce9:	50                   	push   %eax
  100cea:	68 19 37 10 00       	push   $0x103719
  100cef:	e8 49 f5 ff ff       	call   10023d <cprintf>
  100cf4:	83 c4 10             	add    $0x10,%esp

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cf7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfe:	83 f8 02             	cmp    $0x2,%eax
  100d01:	76 bc                	jbe    100cbf <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d08:	c9                   	leave  
  100d09:	c3                   	ret    

00100d0a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d0a:	55                   	push   %ebp
  100d0b:	89 e5                	mov    %esp,%ebp
  100d0d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d10:	e8 b2 fb ff ff       	call   1008c7 <print_kerninfo>
    return 0;
  100d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d1a:	c9                   	leave  
  100d1b:	c3                   	ret    

00100d1c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d1c:	55                   	push   %ebp
  100d1d:	89 e5                	mov    %esp,%ebp
  100d1f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d22:	e8 ea fc ff ff       	call   100a11 <print_stackframe>
    return 0;
  100d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2c:	c9                   	leave  
  100d2d:	c3                   	ret    

00100d2e <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d2e:	55                   	push   %ebp
  100d2f:	89 e5                	mov    %esp,%ebp
  100d31:	83 ec 18             	sub    $0x18,%esp
  100d34:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d3a:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d3e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100d42:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d46:	ee                   	out    %al,(%dx)
  100d47:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100d4d:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100d51:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100d55:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100d59:	ee                   	out    %al,(%dx)
  100d5a:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d60:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d64:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d68:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d6c:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d6d:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d74:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d77:	83 ec 0c             	sub    $0xc,%esp
  100d7a:	68 22 37 10 00       	push   $0x103722
  100d7f:	e8 b9 f4 ff ff       	call   10023d <cprintf>
  100d84:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d87:	83 ec 0c             	sub    $0xc,%esp
  100d8a:	6a 00                	push   $0x0
  100d8c:	e8 ce 08 00 00       	call   10165f <pic_enable>
  100d91:	83 c4 10             	add    $0x10,%esp
}
  100d94:	90                   	nop
  100d95:	c9                   	leave  
  100d96:	c3                   	ret    

00100d97 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d97:	55                   	push   %ebp
  100d98:	89 e5                	mov    %esp,%ebp
  100d9a:	83 ec 10             	sub    $0x10,%esp
  100d9d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100da3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100da7:	89 c2                	mov    %eax,%edx
  100da9:	ec                   	in     (%dx),%al
  100daa:	88 45 f4             	mov    %al,-0xc(%ebp)
  100dad:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100db3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
  100db7:	89 c2                	mov    %eax,%edx
  100db9:	ec                   	in     (%dx),%al
  100dba:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dbd:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dc3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dc7:	89 c2                	mov    %eax,%edx
  100dc9:	ec                   	in     (%dx),%al
  100dca:	88 45 f6             	mov    %al,-0xa(%ebp)
  100dcd:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100dd3:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  100dd7:	89 c2                	mov    %eax,%edx
  100dd9:	ec                   	in     (%dx),%al
  100dda:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ddd:	90                   	nop
  100dde:	c9                   	leave  
  100ddf:	c3                   	ret    

00100de0 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100de6:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df0:	0f b7 00             	movzwl (%eax),%eax
  100df3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dfa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e02:	0f b7 00             	movzwl (%eax),%eax
  100e05:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e09:	74 12                	je     100e1d <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e0b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e12:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e19:	b4 03 
  100e1b:	eb 13                	jmp    100e30 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e20:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e24:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e27:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e2e:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e30:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e37:	0f b7 c0             	movzwl %ax,%eax
  100e3a:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e3e:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e42:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e46:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100e4a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e4b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e52:	83 c0 01             	add    $0x1,%eax
  100e55:	0f b7 c0             	movzwl %ax,%eax
  100e58:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e5c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e60:	89 c2                	mov    %eax,%edx
  100e62:	ec                   	in     (%dx),%al
  100e63:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e66:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e6a:	0f b6 c0             	movzbl %al,%eax
  100e6d:	c1 e0 08             	shl    $0x8,%eax
  100e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e73:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7a:	0f b7 c0             	movzwl %ax,%eax
  100e7d:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e81:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e85:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e89:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100e8d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e8e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e95:	83 c0 01             	add    $0x1,%eax
  100e98:	0f b7 c0             	movzwl %ax,%eax
  100e9b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e9f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ea3:	89 c2                	mov    %eax,%edx
  100ea5:	ec                   	in     (%dx),%al
  100ea6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ead:	0f b6 c0             	movzbl %al,%eax
  100eb0:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb6:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ebe:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ec4:	90                   	nop
  100ec5:	c9                   	leave  
  100ec6:	c3                   	ret    

00100ec7 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ec7:	55                   	push   %ebp
  100ec8:	89 e5                	mov    %esp,%ebp
  100eca:	83 ec 28             	sub    $0x28,%esp
  100ecd:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ed3:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed7:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100edb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100edf:	ee                   	out    %al,(%dx)
  100ee0:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100ee6:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100eea:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100eee:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  100ef2:	ee                   	out    %al,(%dx)
  100ef3:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100ef9:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100efd:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f01:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f05:	ee                   	out    %al,(%dx)
  100f06:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f0c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f10:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f14:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  100f18:	ee                   	out    %al,(%dx)
  100f19:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100f1f:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100f23:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100f27:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f2b:	ee                   	out    %al,(%dx)
  100f2c:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f32:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f36:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f3a:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  100f3e:	ee                   	out    %al,(%dx)
  100f3f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f45:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f49:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f4d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f51:	ee                   	out    %al,(%dx)
  100f52:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f58:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
  100f5c:	89 c2                	mov    %eax,%edx
  100f5e:	ec                   	in     (%dx),%al
  100f5f:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f62:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f66:	3c ff                	cmp    $0xff,%al
  100f68:	0f 95 c0             	setne  %al
  100f6b:	0f b6 c0             	movzbl %al,%eax
  100f6e:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f73:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f79:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f7d:	89 c2                	mov    %eax,%edx
  100f7f:	ec                   	in     (%dx),%al
  100f80:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f83:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f89:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
  100f8d:	89 c2                	mov    %eax,%edx
  100f8f:	ec                   	in     (%dx),%al
  100f90:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f93:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f98:	85 c0                	test   %eax,%eax
  100f9a:	74 0d                	je     100fa9 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100f9c:	83 ec 0c             	sub    $0xc,%esp
  100f9f:	6a 04                	push   $0x4
  100fa1:	e8 b9 06 00 00       	call   10165f <pic_enable>
  100fa6:	83 c4 10             	add    $0x10,%esp
    }
}
  100fa9:	90                   	nop
  100faa:	c9                   	leave  
  100fab:	c3                   	ret    

00100fac <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fac:	55                   	push   %ebp
  100fad:	89 e5                	mov    %esp,%ebp
  100faf:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fb2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fb9:	eb 09                	jmp    100fc4 <lpt_putc_sub+0x18>
        delay();
  100fbb:	e8 d7 fd ff ff       	call   100d97 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fc4:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100fca:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100fce:	89 c2                	mov    %eax,%edx
  100fd0:	ec                   	in     (%dx),%al
  100fd1:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fd4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fd8:	84 c0                	test   %al,%al
  100fda:	78 09                	js     100fe5 <lpt_putc_sub+0x39>
  100fdc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fe3:	7e d6                	jle    100fbb <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  100fe8:	0f b6 c0             	movzbl %al,%eax
  100feb:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100ff1:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff4:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100ff8:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  100ffc:	ee                   	out    %al,(%dx)
  100ffd:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101003:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101007:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10100b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10100f:	ee                   	out    %al,(%dx)
  101010:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101016:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  10101a:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10101e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101022:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101023:	90                   	nop
  101024:	c9                   	leave  
  101025:	c3                   	ret    

00101026 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101026:	55                   	push   %ebp
  101027:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101029:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10102d:	74 0d                	je     10103c <lpt_putc+0x16>
        lpt_putc_sub(c);
  10102f:	ff 75 08             	pushl  0x8(%ebp)
  101032:	e8 75 ff ff ff       	call   100fac <lpt_putc_sub>
  101037:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10103a:	eb 1e                	jmp    10105a <lpt_putc+0x34>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10103c:	6a 08                	push   $0x8
  10103e:	e8 69 ff ff ff       	call   100fac <lpt_putc_sub>
  101043:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101046:	6a 20                	push   $0x20
  101048:	e8 5f ff ff ff       	call   100fac <lpt_putc_sub>
  10104d:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  101050:	6a 08                	push   $0x8
  101052:	e8 55 ff ff ff       	call   100fac <lpt_putc_sub>
  101057:	83 c4 04             	add    $0x4,%esp
    }
}
  10105a:	90                   	nop
  10105b:	c9                   	leave  
  10105c:	c3                   	ret    

0010105d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10105d:	55                   	push   %ebp
  10105e:	89 e5                	mov    %esp,%ebp
  101060:	53                   	push   %ebx
  101061:	83 ec 14             	sub    $0x14,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101064:	8b 45 08             	mov    0x8(%ebp),%eax
  101067:	b0 00                	mov    $0x0,%al
  101069:	85 c0                	test   %eax,%eax
  10106b:	75 07                	jne    101074 <cga_putc+0x17>
        c |= 0x0700;
  10106d:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101074:	8b 45 08             	mov    0x8(%ebp),%eax
  101077:	0f b6 c0             	movzbl %al,%eax
  10107a:	83 f8 0a             	cmp    $0xa,%eax
  10107d:	74 4e                	je     1010cd <cga_putc+0x70>
  10107f:	83 f8 0d             	cmp    $0xd,%eax
  101082:	74 59                	je     1010dd <cga_putc+0x80>
  101084:	83 f8 08             	cmp    $0x8,%eax
  101087:	0f 85 8a 00 00 00    	jne    101117 <cga_putc+0xba>
    case '\b':
        if (crt_pos > 0) {
  10108d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101094:	66 85 c0             	test   %ax,%ax
  101097:	0f 84 a0 00 00 00    	je     10113d <cga_putc+0xe0>
            crt_pos --;
  10109d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a4:	83 e8 01             	sub    $0x1,%eax
  1010a7:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ad:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010b2:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010b9:	0f b7 d2             	movzwl %dx,%edx
  1010bc:	01 d2                	add    %edx,%edx
  1010be:	01 d0                	add    %edx,%eax
  1010c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1010c3:	b2 00                	mov    $0x0,%dl
  1010c5:	83 ca 20             	or     $0x20,%edx
  1010c8:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010cb:	eb 70                	jmp    10113d <cga_putc+0xe0>
    case '\n':
        crt_pos += CRT_COLS;
  1010cd:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d4:	83 c0 50             	add    $0x50,%eax
  1010d7:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010dd:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010e4:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010eb:	0f b7 c1             	movzwl %cx,%eax
  1010ee:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010f4:	c1 e8 10             	shr    $0x10,%eax
  1010f7:	89 c2                	mov    %eax,%edx
  1010f9:	66 c1 ea 06          	shr    $0x6,%dx
  1010fd:	89 d0                	mov    %edx,%eax
  1010ff:	c1 e0 02             	shl    $0x2,%eax
  101102:	01 d0                	add    %edx,%eax
  101104:	c1 e0 04             	shl    $0x4,%eax
  101107:	29 c1                	sub    %eax,%ecx
  101109:	89 ca                	mov    %ecx,%edx
  10110b:	89 d8                	mov    %ebx,%eax
  10110d:	29 d0                	sub    %edx,%eax
  10110f:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101115:	eb 27                	jmp    10113e <cga_putc+0xe1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101117:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10111d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101124:	8d 50 01             	lea    0x1(%eax),%edx
  101127:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10112e:	0f b7 c0             	movzwl %ax,%eax
  101131:	01 c0                	add    %eax,%eax
  101133:	01 c8                	add    %ecx,%eax
  101135:	8b 55 08             	mov    0x8(%ebp),%edx
  101138:	66 89 10             	mov    %dx,(%eax)
        break;
  10113b:	eb 01                	jmp    10113e <cga_putc+0xe1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10113d:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10113e:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101145:	66 3d cf 07          	cmp    $0x7cf,%ax
  101149:	76 59                	jbe    1011a4 <cga_putc+0x147>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10114b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101150:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101156:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10115b:	83 ec 04             	sub    $0x4,%esp
  10115e:	68 00 0f 00 00       	push   $0xf00
  101163:	52                   	push   %edx
  101164:	50                   	push   %eax
  101165:	e8 50 1b 00 00       	call   102cba <memmove>
  10116a:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10116d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101174:	eb 15                	jmp    10118b <cga_putc+0x12e>
            crt_buf[i] = 0x0700 | ' ';
  101176:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10117e:	01 d2                	add    %edx,%edx
  101180:	01 d0                	add    %edx,%eax
  101182:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101187:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10118b:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101192:	7e e2                	jle    101176 <cga_putc+0x119>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101194:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10119b:	83 e8 50             	sub    $0x50,%eax
  10119e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011a4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011ab:	0f b7 c0             	movzwl %ax,%eax
  1011ae:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011b2:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  1011b6:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011be:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011bf:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c6:	66 c1 e8 08          	shr    $0x8,%ax
  1011ca:	0f b6 c0             	movzbl %al,%eax
  1011cd:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011d4:	83 c2 01             	add    $0x1,%edx
  1011d7:	0f b7 d2             	movzwl %dx,%edx
  1011da:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011de:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011e1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011e5:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1011e9:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011ea:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f1:	0f b7 c0             	movzwl %ax,%eax
  1011f4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011f8:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1011fc:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101200:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101204:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101205:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120c:	0f b6 c0             	movzbl %al,%eax
  10120f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101216:	83 c2 01             	add    $0x1,%edx
  101219:	0f b7 d2             	movzwl %dx,%edx
  10121c:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101220:	88 45 eb             	mov    %al,-0x15(%ebp)
  101223:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101227:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  10122b:	ee                   	out    %al,(%dx)
}
  10122c:	90                   	nop
  10122d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101230:	c9                   	leave  
  101231:	c3                   	ret    

00101232 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101232:	55                   	push   %ebp
  101233:	89 e5                	mov    %esp,%ebp
  101235:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10123f:	eb 09                	jmp    10124a <serial_putc_sub+0x18>
        delay();
  101241:	e8 51 fb ff ff       	call   100d97 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101246:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10124a:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101250:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  101254:	89 c2                	mov    %eax,%edx
  101256:	ec                   	in     (%dx),%al
  101257:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10125a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10125e:	0f b6 c0             	movzbl %al,%eax
  101261:	83 e0 20             	and    $0x20,%eax
  101264:	85 c0                	test   %eax,%eax
  101266:	75 09                	jne    101271 <serial_putc_sub+0x3f>
  101268:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10126f:	7e d0                	jle    101241 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101271:	8b 45 08             	mov    0x8(%ebp),%eax
  101274:	0f b6 c0             	movzbl %al,%eax
  101277:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10127d:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101280:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101284:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101288:	ee                   	out    %al,(%dx)
}
  101289:	90                   	nop
  10128a:	c9                   	leave  
  10128b:	c3                   	ret    

0010128c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10128c:	55                   	push   %ebp
  10128d:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  10128f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101293:	74 0d                	je     1012a2 <serial_putc+0x16>
        serial_putc_sub(c);
  101295:	ff 75 08             	pushl  0x8(%ebp)
  101298:	e8 95 ff ff ff       	call   101232 <serial_putc_sub>
  10129d:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012a0:	eb 1e                	jmp    1012c0 <serial_putc+0x34>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  1012a2:	6a 08                	push   $0x8
  1012a4:	e8 89 ff ff ff       	call   101232 <serial_putc_sub>
  1012a9:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012ac:	6a 20                	push   $0x20
  1012ae:	e8 7f ff ff ff       	call   101232 <serial_putc_sub>
  1012b3:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012b6:	6a 08                	push   $0x8
  1012b8:	e8 75 ff ff ff       	call   101232 <serial_putc_sub>
  1012bd:	83 c4 04             	add    $0x4,%esp
    }
}
  1012c0:	90                   	nop
  1012c1:	c9                   	leave  
  1012c2:	c3                   	ret    

001012c3 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012c3:	55                   	push   %ebp
  1012c4:	89 e5                	mov    %esp,%ebp
  1012c6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012c9:	eb 33                	jmp    1012fe <cons_intr+0x3b>
        if (c != 0) {
  1012cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012cf:	74 2d                	je     1012fe <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012d1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012d6:	8d 50 01             	lea    0x1(%eax),%edx
  1012d9:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012e2:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012e8:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ed:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012f2:	75 0a                	jne    1012fe <cons_intr+0x3b>
                cons.wpos = 0;
  1012f4:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  1012fb:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	ff d0                	call   *%eax
  101303:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101306:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10130a:	75 bf                	jne    1012cb <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10130c:	90                   	nop
  10130d:	c9                   	leave  
  10130e:	c3                   	ret    

0010130f <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10130f:	55                   	push   %ebp
  101310:	89 e5                	mov    %esp,%ebp
  101312:	83 ec 10             	sub    $0x10,%esp
  101315:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10131b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
  10131f:	89 c2                	mov    %eax,%edx
  101321:	ec                   	in     (%dx),%al
  101322:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  101325:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101329:	0f b6 c0             	movzbl %al,%eax
  10132c:	83 e0 01             	and    $0x1,%eax
  10132f:	85 c0                	test   %eax,%eax
  101331:	75 07                	jne    10133a <serial_proc_data+0x2b>
        return -1;
  101333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101338:	eb 2a                	jmp    101364 <serial_proc_data+0x55>
  10133a:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101340:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101344:	89 c2                	mov    %eax,%edx
  101346:	ec                   	in     (%dx),%al
  101347:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  10134a:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10134e:	0f b6 c0             	movzbl %al,%eax
  101351:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101354:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101358:	75 07                	jne    101361 <serial_proc_data+0x52>
        c = '\b';
  10135a:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101361:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101364:	c9                   	leave  
  101365:	c3                   	ret    

00101366 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101366:	55                   	push   %ebp
  101367:	89 e5                	mov    %esp,%ebp
  101369:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10136c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101371:	85 c0                	test   %eax,%eax
  101373:	74 10                	je     101385 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101375:	83 ec 0c             	sub    $0xc,%esp
  101378:	68 0f 13 10 00       	push   $0x10130f
  10137d:	e8 41 ff ff ff       	call   1012c3 <cons_intr>
  101382:	83 c4 10             	add    $0x10,%esp
    }
}
  101385:	90                   	nop
  101386:	c9                   	leave  
  101387:	c3                   	ret    

00101388 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101388:	55                   	push   %ebp
  101389:	89 e5                	mov    %esp,%ebp
  10138b:	83 ec 18             	sub    $0x18,%esp
  10138e:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101394:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101398:	89 c2                	mov    %eax,%edx
  10139a:	ec                   	in     (%dx),%al
  10139b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10139e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013a2:	0f b6 c0             	movzbl %al,%eax
  1013a5:	83 e0 01             	and    $0x1,%eax
  1013a8:	85 c0                	test   %eax,%eax
  1013aa:	75 0a                	jne    1013b6 <kbd_proc_data+0x2e>
        return -1;
  1013ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013b1:	e9 5d 01 00 00       	jmp    101513 <kbd_proc_data+0x18b>
  1013b6:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013bc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c0:	89 c2                	mov    %eax,%edx
  1013c2:	ec                   	in     (%dx),%al
  1013c3:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013c6:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ca:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013cd:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013d1:	75 17                	jne    1013ea <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013d3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013d8:	83 c8 40             	or     $0x40,%eax
  1013db:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013e0:	b8 00 00 00 00       	mov    $0x0,%eax
  1013e5:	e9 29 01 00 00       	jmp    101513 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ee:	84 c0                	test   %al,%al
  1013f0:	79 47                	jns    101439 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013f2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f7:	83 e0 40             	and    $0x40,%eax
  1013fa:	85 c0                	test   %eax,%eax
  1013fc:	75 09                	jne    101407 <kbd_proc_data+0x7f>
  1013fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101402:	83 e0 7f             	and    $0x7f,%eax
  101405:	eb 04                	jmp    10140b <kbd_proc_data+0x83>
  101407:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10140e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101412:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101419:	83 c8 40             	or     $0x40,%eax
  10141c:	0f b6 c0             	movzbl %al,%eax
  10141f:	f7 d0                	not    %eax
  101421:	89 c2                	mov    %eax,%edx
  101423:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101428:	21 d0                	and    %edx,%eax
  10142a:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10142f:	b8 00 00 00 00       	mov    $0x0,%eax
  101434:	e9 da 00 00 00       	jmp    101513 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  101439:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143e:	83 e0 40             	and    $0x40,%eax
  101441:	85 c0                	test   %eax,%eax
  101443:	74 11                	je     101456 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101445:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101449:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144e:	83 e0 bf             	and    $0xffffffbf,%eax
  101451:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101456:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101461:	0f b6 d0             	movzbl %al,%edx
  101464:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101469:	09 d0                	or     %edx,%eax
  10146b:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10147b:	0f b6 d0             	movzbl %al,%edx
  10147e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101483:	31 d0                	xor    %edx,%eax
  101485:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10148a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148f:	83 e0 03             	and    $0x3,%eax
  101492:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101499:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149d:	01 d0                	add    %edx,%eax
  10149f:	0f b6 00             	movzbl (%eax),%eax
  1014a2:	0f b6 c0             	movzbl %al,%eax
  1014a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014a8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ad:	83 e0 08             	and    $0x8,%eax
  1014b0:	85 c0                	test   %eax,%eax
  1014b2:	74 22                	je     1014d6 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014b4:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014b8:	7e 0c                	jle    1014c6 <kbd_proc_data+0x13e>
  1014ba:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014be:	7f 06                	jg     1014c6 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014c0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014c4:	eb 10                	jmp    1014d6 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014c6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ca:	7e 0a                	jle    1014d6 <kbd_proc_data+0x14e>
  1014cc:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014d0:	7f 04                	jg     1014d6 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014d2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014d6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014db:	f7 d0                	not    %eax
  1014dd:	83 e0 06             	and    $0x6,%eax
  1014e0:	85 c0                	test   %eax,%eax
  1014e2:	75 2c                	jne    101510 <kbd_proc_data+0x188>
  1014e4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014eb:	75 23                	jne    101510 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  1014ed:	83 ec 0c             	sub    $0xc,%esp
  1014f0:	68 3d 37 10 00       	push   $0x10373d
  1014f5:	e8 43 ed ff ff       	call   10023d <cprintf>
  1014fa:	83 c4 10             	add    $0x10,%esp
  1014fd:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101503:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101507:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10150b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10150f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101510:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101513:	c9                   	leave  
  101514:	c3                   	ret    

00101515 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101515:	55                   	push   %ebp
  101516:	89 e5                	mov    %esp,%ebp
  101518:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10151b:	83 ec 0c             	sub    $0xc,%esp
  10151e:	68 88 13 10 00       	push   $0x101388
  101523:	e8 9b fd ff ff       	call   1012c3 <cons_intr>
  101528:	83 c4 10             	add    $0x10,%esp
}
  10152b:	90                   	nop
  10152c:	c9                   	leave  
  10152d:	c3                   	ret    

0010152e <kbd_init>:

static void
kbd_init(void) {
  10152e:	55                   	push   %ebp
  10152f:	89 e5                	mov    %esp,%ebp
  101531:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101534:	e8 dc ff ff ff       	call   101515 <kbd_intr>
    pic_enable(IRQ_KBD);
  101539:	83 ec 0c             	sub    $0xc,%esp
  10153c:	6a 01                	push   $0x1
  10153e:	e8 1c 01 00 00       	call   10165f <pic_enable>
  101543:	83 c4 10             	add    $0x10,%esp
}
  101546:	90                   	nop
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  10154f:	e8 8c f8 ff ff       	call   100de0 <cga_init>
    serial_init();
  101554:	e8 6e f9 ff ff       	call   100ec7 <serial_init>
    kbd_init();
  101559:	e8 d0 ff ff ff       	call   10152e <kbd_init>
    if (!serial_exists) {
  10155e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101563:	85 c0                	test   %eax,%eax
  101565:	75 10                	jne    101577 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101567:	83 ec 0c             	sub    $0xc,%esp
  10156a:	68 49 37 10 00       	push   $0x103749
  10156f:	e8 c9 ec ff ff       	call   10023d <cprintf>
  101574:	83 c4 10             	add    $0x10,%esp
    }
}
  101577:	90                   	nop
  101578:	c9                   	leave  
  101579:	c3                   	ret    

0010157a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10157a:	55                   	push   %ebp
  10157b:	89 e5                	mov    %esp,%ebp
  10157d:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101580:	ff 75 08             	pushl  0x8(%ebp)
  101583:	e8 9e fa ff ff       	call   101026 <lpt_putc>
  101588:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10158b:	83 ec 0c             	sub    $0xc,%esp
  10158e:	ff 75 08             	pushl  0x8(%ebp)
  101591:	e8 c7 fa ff ff       	call   10105d <cga_putc>
  101596:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  101599:	83 ec 0c             	sub    $0xc,%esp
  10159c:	ff 75 08             	pushl  0x8(%ebp)
  10159f:	e8 e8 fc ff ff       	call   10128c <serial_putc>
  1015a4:	83 c4 10             	add    $0x10,%esp
}
  1015a7:	90                   	nop
  1015a8:	c9                   	leave  
  1015a9:	c3                   	ret    

001015aa <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015aa:	55                   	push   %ebp
  1015ab:	89 e5                	mov    %esp,%ebp
  1015ad:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015b0:	e8 b1 fd ff ff       	call   101366 <serial_intr>
    kbd_intr();
  1015b5:	e8 5b ff ff ff       	call   101515 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015ba:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015c0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015c5:	39 c2                	cmp    %eax,%edx
  1015c7:	74 36                	je     1015ff <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015c9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ce:	8d 50 01             	lea    0x1(%eax),%edx
  1015d1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015d7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015de:	0f b6 c0             	movzbl %al,%eax
  1015e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015e4:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015ee:	75 0a                	jne    1015fa <cons_getc+0x50>
            cons.rpos = 0;
  1015f0:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015f7:	00 00 00 
        }
        return c;
  1015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015fd:	eb 05                	jmp    101604 <cons_getc+0x5a>
    }
    return 0;
  1015ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101604:	c9                   	leave  
  101605:	c3                   	ret    

00101606 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101606:	55                   	push   %ebp
  101607:	89 e5                	mov    %esp,%ebp
  101609:	83 ec 14             	sub    $0x14,%esp
  10160c:	8b 45 08             	mov    0x8(%ebp),%eax
  10160f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101613:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101617:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10161d:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101622:	85 c0                	test   %eax,%eax
  101624:	74 36                	je     10165c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101626:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162a:	0f b6 c0             	movzbl %al,%eax
  10162d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101633:	88 45 fa             	mov    %al,-0x6(%ebp)
  101636:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10163a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10163e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10163f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101643:	66 c1 e8 08          	shr    $0x8,%ax
  101647:	0f b6 c0             	movzbl %al,%eax
  10164a:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101650:	88 45 fb             	mov    %al,-0x5(%ebp)
  101653:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  101657:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  10165b:	ee                   	out    %al,(%dx)
    }
}
  10165c:	90                   	nop
  10165d:	c9                   	leave  
  10165e:	c3                   	ret    

0010165f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10165f:	55                   	push   %ebp
  101660:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101662:	8b 45 08             	mov    0x8(%ebp),%eax
  101665:	ba 01 00 00 00       	mov    $0x1,%edx
  10166a:	89 c1                	mov    %eax,%ecx
  10166c:	d3 e2                	shl    %cl,%edx
  10166e:	89 d0                	mov    %edx,%eax
  101670:	f7 d0                	not    %eax
  101672:	89 c2                	mov    %eax,%edx
  101674:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10167b:	21 d0                	and    %edx,%eax
  10167d:	0f b7 c0             	movzwl %ax,%eax
  101680:	50                   	push   %eax
  101681:	e8 80 ff ff ff       	call   101606 <pic_setmask>
  101686:	83 c4 04             	add    $0x4,%esp
}
  101689:	90                   	nop
  10168a:	c9                   	leave  
  10168b:	c3                   	ret    

0010168c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10168c:	55                   	push   %ebp
  10168d:	89 e5                	mov    %esp,%ebp
  10168f:	83 ec 30             	sub    $0x30,%esp
    did_init = 1;
  101692:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  101699:	00 00 00 
  10169c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016a2:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  1016a6:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016aa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ae:	ee                   	out    %al,(%dx)
  1016af:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016b5:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016b9:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016bd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
  1016c1:	ee                   	out    %al,(%dx)
  1016c2:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016c8:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016cc:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016d0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016db:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016df:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016e3:	0f b7 55 f8          	movzwl -0x8(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1016ee:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  1016f2:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  1016f6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101701:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101705:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  101709:	0f b7 55 f4          	movzwl -0xc(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101714:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  101718:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10171c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  101727:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  10172b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10172f:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10173a:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  10173e:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101742:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  10174d:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101751:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101755:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101760:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101764:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  101768:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101773:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  101777:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10177b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101786:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10178a:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10178e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101799:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10179d:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  1017a1:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017a6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ad:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017b1:	74 13                	je     1017c6 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017b3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ba:	0f b7 c0             	movzwl %ax,%eax
  1017bd:	50                   	push   %eax
  1017be:	e8 43 fe ff ff       	call   101606 <pic_setmask>
  1017c3:	83 c4 04             	add    $0x4,%esp
    }
}
  1017c6:	90                   	nop
  1017c7:	c9                   	leave  
  1017c8:	c3                   	ret    

001017c9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017c9:	55                   	push   %ebp
  1017ca:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017cc:	fb                   	sti    
    sti();
}
  1017cd:	90                   	nop
  1017ce:	5d                   	pop    %ebp
  1017cf:	c3                   	ret    

001017d0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017d0:	55                   	push   %ebp
  1017d1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017d3:	fa                   	cli    
    cli();
}
  1017d4:	90                   	nop
  1017d5:	5d                   	pop    %ebp
  1017d6:	c3                   	ret    

001017d7 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017d7:	55                   	push   %ebp
  1017d8:	89 e5                	mov    %esp,%ebp
  1017da:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017dd:	83 ec 08             	sub    $0x8,%esp
  1017e0:	6a 64                	push   $0x64
  1017e2:	68 80 37 10 00       	push   $0x103780
  1017e7:	e8 51 ea ff ff       	call   10023d <cprintf>
  1017ec:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017ef:	90                   	nop
  1017f0:	c9                   	leave  
  1017f1:	c3                   	ret    

001017f2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f2:	55                   	push   %ebp
  1017f3:	89 e5                	mov    %esp,%ebp
  1017f5:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1017f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017ff:	e9 c3 00 00 00       	jmp    1018c7 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101804:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101807:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10180e:	89 c2                	mov    %eax,%edx
  101810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101813:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10181a:	00 
  10181b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181e:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101825:	00 08 00 
  101828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101832:	00 
  101833:	83 e2 e0             	and    $0xffffffe0,%edx
  101836:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101840:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101847:	00 
  101848:	83 e2 1f             	and    $0x1f,%edx
  10184b:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101855:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10185c:	00 
  10185d:	83 e2 f0             	and    $0xfffffff0,%edx
  101860:	83 ca 0e             	or     $0xe,%edx
  101863:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10186a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101874:	00 
  101875:	83 e2 ef             	and    $0xffffffef,%edx
  101878:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10187f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101882:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101889:	00 
  10188a:	83 e2 9f             	and    $0xffffff9f,%edx
  10188d:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101894:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101897:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189e:	00 
  10189f:	83 ca 80             	or     $0xffffff80,%edx
  1018a2:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ac:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018b3:	c1 e8 10             	shr    $0x10,%eax
  1018b6:	89 c2                	mov    %eax,%edx
  1018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bb:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018c2:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018c3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ca:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018cf:	0f 86 2f ff ff ff    	jbe    101804 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018d5:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018da:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018e0:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018e7:	08 00 
  1018e9:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018f0:	83 e0 e0             	and    $0xffffffe0,%eax
  1018f3:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1018f8:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018ff:	83 e0 1f             	and    $0x1f,%eax
  101902:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101907:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10190e:	83 e0 f0             	and    $0xfffffff0,%eax
  101911:	83 c8 0e             	or     $0xe,%eax
  101914:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101919:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101920:	83 e0 ef             	and    $0xffffffef,%eax
  101923:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101928:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192f:	83 c8 60             	or     $0x60,%eax
  101932:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101937:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193e:	83 c8 80             	or     $0xffffff80,%eax
  101941:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101946:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10194b:	c1 e8 10             	shr    $0x10,%eax
  10194e:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101954:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  10195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10195e:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  101961:	90                   	nop
  101962:	c9                   	leave  
  101963:	c3                   	ret    

00101964 <trapname>:

static const char *
trapname(int trapno) {
  101964:	55                   	push   %ebp
  101965:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101967:	8b 45 08             	mov    0x8(%ebp),%eax
  10196a:	83 f8 13             	cmp    $0x13,%eax
  10196d:	77 0c                	ja     10197b <trapname+0x17>
        return excnames[trapno];
  10196f:	8b 45 08             	mov    0x8(%ebp),%eax
  101972:	8b 04 85 e0 3a 10 00 	mov    0x103ae0(,%eax,4),%eax
  101979:	eb 18                	jmp    101993 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10197b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10197f:	7e 0d                	jle    10198e <trapname+0x2a>
  101981:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101985:	7f 07                	jg     10198e <trapname+0x2a>
        return "Hardware Interrupt";
  101987:	b8 8a 37 10 00       	mov    $0x10378a,%eax
  10198c:	eb 05                	jmp    101993 <trapname+0x2f>
    }
    return "(unknown trap)";
  10198e:	b8 9d 37 10 00       	mov    $0x10379d,%eax
}
  101993:	5d                   	pop    %ebp
  101994:	c3                   	ret    

00101995 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101995:	55                   	push   %ebp
  101996:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101998:	8b 45 08             	mov    0x8(%ebp),%eax
  10199b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10199f:	66 83 f8 08          	cmp    $0x8,%ax
  1019a3:	0f 94 c0             	sete   %al
  1019a6:	0f b6 c0             	movzbl %al,%eax
}
  1019a9:	5d                   	pop    %ebp
  1019aa:	c3                   	ret    

001019ab <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019ab:	55                   	push   %ebp
  1019ac:	89 e5                	mov    %esp,%ebp
  1019ae:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  1019b1:	83 ec 08             	sub    $0x8,%esp
  1019b4:	ff 75 08             	pushl  0x8(%ebp)
  1019b7:	68 de 37 10 00       	push   $0x1037de
  1019bc:	e8 7c e8 ff ff       	call   10023d <cprintf>
  1019c1:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  1019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c7:	83 ec 0c             	sub    $0xc,%esp
  1019ca:	50                   	push   %eax
  1019cb:	e8 b8 01 00 00       	call   101b88 <print_regs>
  1019d0:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d6:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019da:	0f b7 c0             	movzwl %ax,%eax
  1019dd:	83 ec 08             	sub    $0x8,%esp
  1019e0:	50                   	push   %eax
  1019e1:	68 ef 37 10 00       	push   $0x1037ef
  1019e6:	e8 52 e8 ff ff       	call   10023d <cprintf>
  1019eb:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019f5:	0f b7 c0             	movzwl %ax,%eax
  1019f8:	83 ec 08             	sub    $0x8,%esp
  1019fb:	50                   	push   %eax
  1019fc:	68 02 38 10 00       	push   $0x103802
  101a01:	e8 37 e8 ff ff       	call   10023d <cprintf>
  101a06:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a10:	0f b7 c0             	movzwl %ax,%eax
  101a13:	83 ec 08             	sub    $0x8,%esp
  101a16:	50                   	push   %eax
  101a17:	68 15 38 10 00       	push   $0x103815
  101a1c:	e8 1c e8 ff ff       	call   10023d <cprintf>
  101a21:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a2b:	0f b7 c0             	movzwl %ax,%eax
  101a2e:	83 ec 08             	sub    $0x8,%esp
  101a31:	50                   	push   %eax
  101a32:	68 28 38 10 00       	push   $0x103828
  101a37:	e8 01 e8 ff ff       	call   10023d <cprintf>
  101a3c:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a42:	8b 40 30             	mov    0x30(%eax),%eax
  101a45:	83 ec 0c             	sub    $0xc,%esp
  101a48:	50                   	push   %eax
  101a49:	e8 16 ff ff ff       	call   101964 <trapname>
  101a4e:	83 c4 10             	add    $0x10,%esp
  101a51:	89 c2                	mov    %eax,%edx
  101a53:	8b 45 08             	mov    0x8(%ebp),%eax
  101a56:	8b 40 30             	mov    0x30(%eax),%eax
  101a59:	83 ec 04             	sub    $0x4,%esp
  101a5c:	52                   	push   %edx
  101a5d:	50                   	push   %eax
  101a5e:	68 3b 38 10 00       	push   $0x10383b
  101a63:	e8 d5 e7 ff ff       	call   10023d <cprintf>
  101a68:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	8b 40 34             	mov    0x34(%eax),%eax
  101a71:	83 ec 08             	sub    $0x8,%esp
  101a74:	50                   	push   %eax
  101a75:	68 4d 38 10 00       	push   $0x10384d
  101a7a:	e8 be e7 ff ff       	call   10023d <cprintf>
  101a7f:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	8b 40 38             	mov    0x38(%eax),%eax
  101a88:	83 ec 08             	sub    $0x8,%esp
  101a8b:	50                   	push   %eax
  101a8c:	68 5c 38 10 00       	push   $0x10385c
  101a91:	e8 a7 e7 ff ff       	call   10023d <cprintf>
  101a96:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aa0:	0f b7 c0             	movzwl %ax,%eax
  101aa3:	83 ec 08             	sub    $0x8,%esp
  101aa6:	50                   	push   %eax
  101aa7:	68 6b 38 10 00       	push   $0x10386b
  101aac:	e8 8c e7 ff ff       	call   10023d <cprintf>
  101ab1:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab7:	8b 40 40             	mov    0x40(%eax),%eax
  101aba:	83 ec 08             	sub    $0x8,%esp
  101abd:	50                   	push   %eax
  101abe:	68 7e 38 10 00       	push   $0x10387e
  101ac3:	e8 75 e7 ff ff       	call   10023d <cprintf>
  101ac8:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101acb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ad2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ad9:	eb 3f                	jmp    101b1a <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101adb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ade:	8b 50 40             	mov    0x40(%eax),%edx
  101ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ae4:	21 d0                	and    %edx,%eax
  101ae6:	85 c0                	test   %eax,%eax
  101ae8:	74 29                	je     101b13 <print_trapframe+0x168>
  101aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101aed:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101af4:	85 c0                	test   %eax,%eax
  101af6:	74 1b                	je     101b13 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101afb:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b02:	83 ec 08             	sub    $0x8,%esp
  101b05:	50                   	push   %eax
  101b06:	68 8d 38 10 00       	push   $0x10388d
  101b0b:	e8 2d e7 ff ff       	call   10023d <cprintf>
  101b10:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b17:	d1 65 f0             	shll   -0x10(%ebp)
  101b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1d:	83 f8 17             	cmp    $0x17,%eax
  101b20:	76 b9                	jbe    101adb <print_trapframe+0x130>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b22:	8b 45 08             	mov    0x8(%ebp),%eax
  101b25:	8b 40 40             	mov    0x40(%eax),%eax
  101b28:	25 00 30 00 00       	and    $0x3000,%eax
  101b2d:	c1 e8 0c             	shr    $0xc,%eax
  101b30:	83 ec 08             	sub    $0x8,%esp
  101b33:	50                   	push   %eax
  101b34:	68 91 38 10 00       	push   $0x103891
  101b39:	e8 ff e6 ff ff       	call   10023d <cprintf>
  101b3e:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101b41:	83 ec 0c             	sub    $0xc,%esp
  101b44:	ff 75 08             	pushl  0x8(%ebp)
  101b47:	e8 49 fe ff ff       	call   101995 <trap_in_kernel>
  101b4c:	83 c4 10             	add    $0x10,%esp
  101b4f:	85 c0                	test   %eax,%eax
  101b51:	75 32                	jne    101b85 <print_trapframe+0x1da>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b53:	8b 45 08             	mov    0x8(%ebp),%eax
  101b56:	8b 40 44             	mov    0x44(%eax),%eax
  101b59:	83 ec 08             	sub    $0x8,%esp
  101b5c:	50                   	push   %eax
  101b5d:	68 9a 38 10 00       	push   $0x10389a
  101b62:	e8 d6 e6 ff ff       	call   10023d <cprintf>
  101b67:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b71:	0f b7 c0             	movzwl %ax,%eax
  101b74:	83 ec 08             	sub    $0x8,%esp
  101b77:	50                   	push   %eax
  101b78:	68 a9 38 10 00       	push   $0x1038a9
  101b7d:	e8 bb e6 ff ff       	call   10023d <cprintf>
  101b82:	83 c4 10             	add    $0x10,%esp
    }
}
  101b85:	90                   	nop
  101b86:	c9                   	leave  
  101b87:	c3                   	ret    

00101b88 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b88:	55                   	push   %ebp
  101b89:	89 e5                	mov    %esp,%ebp
  101b8b:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b91:	8b 00                	mov    (%eax),%eax
  101b93:	83 ec 08             	sub    $0x8,%esp
  101b96:	50                   	push   %eax
  101b97:	68 bc 38 10 00       	push   $0x1038bc
  101b9c:	e8 9c e6 ff ff       	call   10023d <cprintf>
  101ba1:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	8b 40 04             	mov    0x4(%eax),%eax
  101baa:	83 ec 08             	sub    $0x8,%esp
  101bad:	50                   	push   %eax
  101bae:	68 cb 38 10 00       	push   $0x1038cb
  101bb3:	e8 85 e6 ff ff       	call   10023d <cprintf>
  101bb8:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 08             	mov    0x8(%eax),%eax
  101bc1:	83 ec 08             	sub    $0x8,%esp
  101bc4:	50                   	push   %eax
  101bc5:	68 da 38 10 00       	push   $0x1038da
  101bca:	e8 6e e6 ff ff       	call   10023d <cprintf>
  101bcf:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  101bd8:	83 ec 08             	sub    $0x8,%esp
  101bdb:	50                   	push   %eax
  101bdc:	68 e9 38 10 00       	push   $0x1038e9
  101be1:	e8 57 e6 ff ff       	call   10023d <cprintf>
  101be6:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	8b 40 10             	mov    0x10(%eax),%eax
  101bef:	83 ec 08             	sub    $0x8,%esp
  101bf2:	50                   	push   %eax
  101bf3:	68 f8 38 10 00       	push   $0x1038f8
  101bf8:	e8 40 e6 ff ff       	call   10023d <cprintf>
  101bfd:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c00:	8b 45 08             	mov    0x8(%ebp),%eax
  101c03:	8b 40 14             	mov    0x14(%eax),%eax
  101c06:	83 ec 08             	sub    $0x8,%esp
  101c09:	50                   	push   %eax
  101c0a:	68 07 39 10 00       	push   $0x103907
  101c0f:	e8 29 e6 ff ff       	call   10023d <cprintf>
  101c14:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c17:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1a:	8b 40 18             	mov    0x18(%eax),%eax
  101c1d:	83 ec 08             	sub    $0x8,%esp
  101c20:	50                   	push   %eax
  101c21:	68 16 39 10 00       	push   $0x103916
  101c26:	e8 12 e6 ff ff       	call   10023d <cprintf>
  101c2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c34:	83 ec 08             	sub    $0x8,%esp
  101c37:	50                   	push   %eax
  101c38:	68 25 39 10 00       	push   $0x103925
  101c3d:	e8 fb e5 ff ff       	call   10023d <cprintf>
  101c42:	83 c4 10             	add    $0x10,%esp
}
  101c45:	90                   	nop
  101c46:	c9                   	leave  
  101c47:	c3                   	ret    

00101c48 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c48:	55                   	push   %ebp
  101c49:	89 e5                	mov    %esp,%ebp
  101c4b:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	8b 40 30             	mov    0x30(%eax),%eax
  101c54:	83 f8 2f             	cmp    $0x2f,%eax
  101c57:	77 1d                	ja     101c76 <trap_dispatch+0x2e>
  101c59:	83 f8 2e             	cmp    $0x2e,%eax
  101c5c:	0f 83 f4 00 00 00    	jae    101d56 <trap_dispatch+0x10e>
  101c62:	83 f8 21             	cmp    $0x21,%eax
  101c65:	74 7e                	je     101ce5 <trap_dispatch+0x9d>
  101c67:	83 f8 24             	cmp    $0x24,%eax
  101c6a:	74 55                	je     101cc1 <trap_dispatch+0x79>
  101c6c:	83 f8 20             	cmp    $0x20,%eax
  101c6f:	74 16                	je     101c87 <trap_dispatch+0x3f>
  101c71:	e9 aa 00 00 00       	jmp    101d20 <trap_dispatch+0xd8>
  101c76:	83 e8 78             	sub    $0x78,%eax
  101c79:	83 f8 01             	cmp    $0x1,%eax
  101c7c:	0f 87 9e 00 00 00    	ja     101d20 <trap_dispatch+0xd8>
  101c82:	e9 82 00 00 00       	jmp    101d09 <trap_dispatch+0xc1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks ++;
  101c87:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c8c:	83 c0 01             	add    $0x1,%eax
  101c8f:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101c94:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c9a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c9f:	89 c8                	mov    %ecx,%eax
  101ca1:	f7 e2                	mul    %edx
  101ca3:	89 d0                	mov    %edx,%eax
  101ca5:	c1 e8 05             	shr    $0x5,%eax
  101ca8:	6b c0 64             	imul   $0x64,%eax,%eax
  101cab:	29 c1                	sub    %eax,%ecx
  101cad:	89 c8                	mov    %ecx,%eax
  101caf:	85 c0                	test   %eax,%eax
  101cb1:	0f 85 a2 00 00 00    	jne    101d59 <trap_dispatch+0x111>
            print_ticks();
  101cb7:	e8 1b fb ff ff       	call   1017d7 <print_ticks>
        }
        break;
  101cbc:	e9 98 00 00 00       	jmp    101d59 <trap_dispatch+0x111>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc1:	e8 e4 f8 ff ff       	call   1015aa <cons_getc>
  101cc6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cc9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ccd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd1:	83 ec 04             	sub    $0x4,%esp
  101cd4:	52                   	push   %edx
  101cd5:	50                   	push   %eax
  101cd6:	68 34 39 10 00       	push   $0x103934
  101cdb:	e8 5d e5 ff ff       	call   10023d <cprintf>
  101ce0:	83 c4 10             	add    $0x10,%esp
        break;
  101ce3:	eb 75                	jmp    101d5a <trap_dispatch+0x112>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ce5:	e8 c0 f8 ff ff       	call   1015aa <cons_getc>
  101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf5:	83 ec 04             	sub    $0x4,%esp
  101cf8:	52                   	push   %edx
  101cf9:	50                   	push   %eax
  101cfa:	68 46 39 10 00       	push   $0x103946
  101cff:	e8 39 e5 ff ff       	call   10023d <cprintf>
  101d04:	83 c4 10             	add    $0x10,%esp
        break;
  101d07:	eb 51                	jmp    101d5a <trap_dispatch+0x112>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d09:	83 ec 04             	sub    $0x4,%esp
  101d0c:	68 55 39 10 00       	push   $0x103955
  101d11:	68 b0 00 00 00       	push   $0xb0
  101d16:	68 65 39 10 00       	push   $0x103965
  101d1b:	e8 83 e6 ff ff       	call   1003a3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d20:	8b 45 08             	mov    0x8(%ebp),%eax
  101d23:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d27:	0f b7 c0             	movzwl %ax,%eax
  101d2a:	83 e0 03             	and    $0x3,%eax
  101d2d:	85 c0                	test   %eax,%eax
  101d2f:	75 29                	jne    101d5a <trap_dispatch+0x112>
            print_trapframe(tf);
  101d31:	83 ec 0c             	sub    $0xc,%esp
  101d34:	ff 75 08             	pushl  0x8(%ebp)
  101d37:	e8 6f fc ff ff       	call   1019ab <print_trapframe>
  101d3c:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101d3f:	83 ec 04             	sub    $0x4,%esp
  101d42:	68 76 39 10 00       	push   $0x103976
  101d47:	68 ba 00 00 00       	push   $0xba
  101d4c:	68 65 39 10 00       	push   $0x103965
  101d51:	e8 4d e6 ff ff       	call   1003a3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d56:	90                   	nop
  101d57:	eb 01                	jmp    101d5a <trap_dispatch+0x112>
         */
	ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  101d59:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d5a:	90                   	nop
  101d5b:	c9                   	leave  
  101d5c:	c3                   	ret    

00101d5d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d5d:	55                   	push   %ebp
  101d5e:	89 e5                	mov    %esp,%ebp
  101d60:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d63:	83 ec 0c             	sub    $0xc,%esp
  101d66:	ff 75 08             	pushl  0x8(%ebp)
  101d69:	e8 da fe ff ff       	call   101c48 <trap_dispatch>
  101d6e:	83 c4 10             	add    $0x10,%esp
}
  101d71:	90                   	nop
  101d72:	c9                   	leave  
  101d73:	c3                   	ret    

00101d74 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d74:	6a 00                	push   $0x0
  pushl $0
  101d76:	6a 00                	push   $0x0
  jmp __alltraps
  101d78:	e9 67 0a 00 00       	jmp    1027e4 <__alltraps>

00101d7d <vector1>:
.globl vector1
vector1:
  pushl $0
  101d7d:	6a 00                	push   $0x0
  pushl $1
  101d7f:	6a 01                	push   $0x1
  jmp __alltraps
  101d81:	e9 5e 0a 00 00       	jmp    1027e4 <__alltraps>

00101d86 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d86:	6a 00                	push   $0x0
  pushl $2
  101d88:	6a 02                	push   $0x2
  jmp __alltraps
  101d8a:	e9 55 0a 00 00       	jmp    1027e4 <__alltraps>

00101d8f <vector3>:
.globl vector3
vector3:
  pushl $0
  101d8f:	6a 00                	push   $0x0
  pushl $3
  101d91:	6a 03                	push   $0x3
  jmp __alltraps
  101d93:	e9 4c 0a 00 00       	jmp    1027e4 <__alltraps>

00101d98 <vector4>:
.globl vector4
vector4:
  pushl $0
  101d98:	6a 00                	push   $0x0
  pushl $4
  101d9a:	6a 04                	push   $0x4
  jmp __alltraps
  101d9c:	e9 43 0a 00 00       	jmp    1027e4 <__alltraps>

00101da1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101da1:	6a 00                	push   $0x0
  pushl $5
  101da3:	6a 05                	push   $0x5
  jmp __alltraps
  101da5:	e9 3a 0a 00 00       	jmp    1027e4 <__alltraps>

00101daa <vector6>:
.globl vector6
vector6:
  pushl $0
  101daa:	6a 00                	push   $0x0
  pushl $6
  101dac:	6a 06                	push   $0x6
  jmp __alltraps
  101dae:	e9 31 0a 00 00       	jmp    1027e4 <__alltraps>

00101db3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101db3:	6a 00                	push   $0x0
  pushl $7
  101db5:	6a 07                	push   $0x7
  jmp __alltraps
  101db7:	e9 28 0a 00 00       	jmp    1027e4 <__alltraps>

00101dbc <vector8>:
.globl vector8
vector8:
  pushl $8
  101dbc:	6a 08                	push   $0x8
  jmp __alltraps
  101dbe:	e9 21 0a 00 00       	jmp    1027e4 <__alltraps>

00101dc3 <vector9>:
.globl vector9
vector9:
  pushl $9
  101dc3:	6a 09                	push   $0x9
  jmp __alltraps
  101dc5:	e9 1a 0a 00 00       	jmp    1027e4 <__alltraps>

00101dca <vector10>:
.globl vector10
vector10:
  pushl $10
  101dca:	6a 0a                	push   $0xa
  jmp __alltraps
  101dcc:	e9 13 0a 00 00       	jmp    1027e4 <__alltraps>

00101dd1 <vector11>:
.globl vector11
vector11:
  pushl $11
  101dd1:	6a 0b                	push   $0xb
  jmp __alltraps
  101dd3:	e9 0c 0a 00 00       	jmp    1027e4 <__alltraps>

00101dd8 <vector12>:
.globl vector12
vector12:
  pushl $12
  101dd8:	6a 0c                	push   $0xc
  jmp __alltraps
  101dda:	e9 05 0a 00 00       	jmp    1027e4 <__alltraps>

00101ddf <vector13>:
.globl vector13
vector13:
  pushl $13
  101ddf:	6a 0d                	push   $0xd
  jmp __alltraps
  101de1:	e9 fe 09 00 00       	jmp    1027e4 <__alltraps>

00101de6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101de6:	6a 0e                	push   $0xe
  jmp __alltraps
  101de8:	e9 f7 09 00 00       	jmp    1027e4 <__alltraps>

00101ded <vector15>:
.globl vector15
vector15:
  pushl $0
  101ded:	6a 00                	push   $0x0
  pushl $15
  101def:	6a 0f                	push   $0xf
  jmp __alltraps
  101df1:	e9 ee 09 00 00       	jmp    1027e4 <__alltraps>

00101df6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101df6:	6a 00                	push   $0x0
  pushl $16
  101df8:	6a 10                	push   $0x10
  jmp __alltraps
  101dfa:	e9 e5 09 00 00       	jmp    1027e4 <__alltraps>

00101dff <vector17>:
.globl vector17
vector17:
  pushl $17
  101dff:	6a 11                	push   $0x11
  jmp __alltraps
  101e01:	e9 de 09 00 00       	jmp    1027e4 <__alltraps>

00101e06 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $18
  101e08:	6a 12                	push   $0x12
  jmp __alltraps
  101e0a:	e9 d5 09 00 00       	jmp    1027e4 <__alltraps>

00101e0f <vector19>:
.globl vector19
vector19:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $19
  101e11:	6a 13                	push   $0x13
  jmp __alltraps
  101e13:	e9 cc 09 00 00       	jmp    1027e4 <__alltraps>

00101e18 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $20
  101e1a:	6a 14                	push   $0x14
  jmp __alltraps
  101e1c:	e9 c3 09 00 00       	jmp    1027e4 <__alltraps>

00101e21 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $21
  101e23:	6a 15                	push   $0x15
  jmp __alltraps
  101e25:	e9 ba 09 00 00       	jmp    1027e4 <__alltraps>

00101e2a <vector22>:
.globl vector22
vector22:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $22
  101e2c:	6a 16                	push   $0x16
  jmp __alltraps
  101e2e:	e9 b1 09 00 00       	jmp    1027e4 <__alltraps>

00101e33 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $23
  101e35:	6a 17                	push   $0x17
  jmp __alltraps
  101e37:	e9 a8 09 00 00       	jmp    1027e4 <__alltraps>

00101e3c <vector24>:
.globl vector24
vector24:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $24
  101e3e:	6a 18                	push   $0x18
  jmp __alltraps
  101e40:	e9 9f 09 00 00       	jmp    1027e4 <__alltraps>

00101e45 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $25
  101e47:	6a 19                	push   $0x19
  jmp __alltraps
  101e49:	e9 96 09 00 00       	jmp    1027e4 <__alltraps>

00101e4e <vector26>:
.globl vector26
vector26:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $26
  101e50:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e52:	e9 8d 09 00 00       	jmp    1027e4 <__alltraps>

00101e57 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $27
  101e59:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e5b:	e9 84 09 00 00       	jmp    1027e4 <__alltraps>

00101e60 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $28
  101e62:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e64:	e9 7b 09 00 00       	jmp    1027e4 <__alltraps>

00101e69 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $29
  101e6b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e6d:	e9 72 09 00 00       	jmp    1027e4 <__alltraps>

00101e72 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $30
  101e74:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e76:	e9 69 09 00 00       	jmp    1027e4 <__alltraps>

00101e7b <vector31>:
.globl vector31
vector31:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $31
  101e7d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e7f:	e9 60 09 00 00       	jmp    1027e4 <__alltraps>

00101e84 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $32
  101e86:	6a 20                	push   $0x20
  jmp __alltraps
  101e88:	e9 57 09 00 00       	jmp    1027e4 <__alltraps>

00101e8d <vector33>:
.globl vector33
vector33:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $33
  101e8f:	6a 21                	push   $0x21
  jmp __alltraps
  101e91:	e9 4e 09 00 00       	jmp    1027e4 <__alltraps>

00101e96 <vector34>:
.globl vector34
vector34:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $34
  101e98:	6a 22                	push   $0x22
  jmp __alltraps
  101e9a:	e9 45 09 00 00       	jmp    1027e4 <__alltraps>

00101e9f <vector35>:
.globl vector35
vector35:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $35
  101ea1:	6a 23                	push   $0x23
  jmp __alltraps
  101ea3:	e9 3c 09 00 00       	jmp    1027e4 <__alltraps>

00101ea8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $36
  101eaa:	6a 24                	push   $0x24
  jmp __alltraps
  101eac:	e9 33 09 00 00       	jmp    1027e4 <__alltraps>

00101eb1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $37
  101eb3:	6a 25                	push   $0x25
  jmp __alltraps
  101eb5:	e9 2a 09 00 00       	jmp    1027e4 <__alltraps>

00101eba <vector38>:
.globl vector38
vector38:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $38
  101ebc:	6a 26                	push   $0x26
  jmp __alltraps
  101ebe:	e9 21 09 00 00       	jmp    1027e4 <__alltraps>

00101ec3 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $39
  101ec5:	6a 27                	push   $0x27
  jmp __alltraps
  101ec7:	e9 18 09 00 00       	jmp    1027e4 <__alltraps>

00101ecc <vector40>:
.globl vector40
vector40:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $40
  101ece:	6a 28                	push   $0x28
  jmp __alltraps
  101ed0:	e9 0f 09 00 00       	jmp    1027e4 <__alltraps>

00101ed5 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $41
  101ed7:	6a 29                	push   $0x29
  jmp __alltraps
  101ed9:	e9 06 09 00 00       	jmp    1027e4 <__alltraps>

00101ede <vector42>:
.globl vector42
vector42:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $42
  101ee0:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ee2:	e9 fd 08 00 00       	jmp    1027e4 <__alltraps>

00101ee7 <vector43>:
.globl vector43
vector43:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $43
  101ee9:	6a 2b                	push   $0x2b
  jmp __alltraps
  101eeb:	e9 f4 08 00 00       	jmp    1027e4 <__alltraps>

00101ef0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $44
  101ef2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ef4:	e9 eb 08 00 00       	jmp    1027e4 <__alltraps>

00101ef9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $45
  101efb:	6a 2d                	push   $0x2d
  jmp __alltraps
  101efd:	e9 e2 08 00 00       	jmp    1027e4 <__alltraps>

00101f02 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $46
  101f04:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f06:	e9 d9 08 00 00       	jmp    1027e4 <__alltraps>

00101f0b <vector47>:
.globl vector47
vector47:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $47
  101f0d:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f0f:	e9 d0 08 00 00       	jmp    1027e4 <__alltraps>

00101f14 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $48
  101f16:	6a 30                	push   $0x30
  jmp __alltraps
  101f18:	e9 c7 08 00 00       	jmp    1027e4 <__alltraps>

00101f1d <vector49>:
.globl vector49
vector49:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $49
  101f1f:	6a 31                	push   $0x31
  jmp __alltraps
  101f21:	e9 be 08 00 00       	jmp    1027e4 <__alltraps>

00101f26 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $50
  101f28:	6a 32                	push   $0x32
  jmp __alltraps
  101f2a:	e9 b5 08 00 00       	jmp    1027e4 <__alltraps>

00101f2f <vector51>:
.globl vector51
vector51:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $51
  101f31:	6a 33                	push   $0x33
  jmp __alltraps
  101f33:	e9 ac 08 00 00       	jmp    1027e4 <__alltraps>

00101f38 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $52
  101f3a:	6a 34                	push   $0x34
  jmp __alltraps
  101f3c:	e9 a3 08 00 00       	jmp    1027e4 <__alltraps>

00101f41 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $53
  101f43:	6a 35                	push   $0x35
  jmp __alltraps
  101f45:	e9 9a 08 00 00       	jmp    1027e4 <__alltraps>

00101f4a <vector54>:
.globl vector54
vector54:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $54
  101f4c:	6a 36                	push   $0x36
  jmp __alltraps
  101f4e:	e9 91 08 00 00       	jmp    1027e4 <__alltraps>

00101f53 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $55
  101f55:	6a 37                	push   $0x37
  jmp __alltraps
  101f57:	e9 88 08 00 00       	jmp    1027e4 <__alltraps>

00101f5c <vector56>:
.globl vector56
vector56:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $56
  101f5e:	6a 38                	push   $0x38
  jmp __alltraps
  101f60:	e9 7f 08 00 00       	jmp    1027e4 <__alltraps>

00101f65 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $57
  101f67:	6a 39                	push   $0x39
  jmp __alltraps
  101f69:	e9 76 08 00 00       	jmp    1027e4 <__alltraps>

00101f6e <vector58>:
.globl vector58
vector58:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $58
  101f70:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f72:	e9 6d 08 00 00       	jmp    1027e4 <__alltraps>

00101f77 <vector59>:
.globl vector59
vector59:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $59
  101f79:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f7b:	e9 64 08 00 00       	jmp    1027e4 <__alltraps>

00101f80 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $60
  101f82:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f84:	e9 5b 08 00 00       	jmp    1027e4 <__alltraps>

00101f89 <vector61>:
.globl vector61
vector61:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $61
  101f8b:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f8d:	e9 52 08 00 00       	jmp    1027e4 <__alltraps>

00101f92 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $62
  101f94:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f96:	e9 49 08 00 00       	jmp    1027e4 <__alltraps>

00101f9b <vector63>:
.globl vector63
vector63:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $63
  101f9d:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f9f:	e9 40 08 00 00       	jmp    1027e4 <__alltraps>

00101fa4 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $64
  101fa6:	6a 40                	push   $0x40
  jmp __alltraps
  101fa8:	e9 37 08 00 00       	jmp    1027e4 <__alltraps>

00101fad <vector65>:
.globl vector65
vector65:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $65
  101faf:	6a 41                	push   $0x41
  jmp __alltraps
  101fb1:	e9 2e 08 00 00       	jmp    1027e4 <__alltraps>

00101fb6 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $66
  101fb8:	6a 42                	push   $0x42
  jmp __alltraps
  101fba:	e9 25 08 00 00       	jmp    1027e4 <__alltraps>

00101fbf <vector67>:
.globl vector67
vector67:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $67
  101fc1:	6a 43                	push   $0x43
  jmp __alltraps
  101fc3:	e9 1c 08 00 00       	jmp    1027e4 <__alltraps>

00101fc8 <vector68>:
.globl vector68
vector68:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $68
  101fca:	6a 44                	push   $0x44
  jmp __alltraps
  101fcc:	e9 13 08 00 00       	jmp    1027e4 <__alltraps>

00101fd1 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $69
  101fd3:	6a 45                	push   $0x45
  jmp __alltraps
  101fd5:	e9 0a 08 00 00       	jmp    1027e4 <__alltraps>

00101fda <vector70>:
.globl vector70
vector70:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $70
  101fdc:	6a 46                	push   $0x46
  jmp __alltraps
  101fde:	e9 01 08 00 00       	jmp    1027e4 <__alltraps>

00101fe3 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $71
  101fe5:	6a 47                	push   $0x47
  jmp __alltraps
  101fe7:	e9 f8 07 00 00       	jmp    1027e4 <__alltraps>

00101fec <vector72>:
.globl vector72
vector72:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $72
  101fee:	6a 48                	push   $0x48
  jmp __alltraps
  101ff0:	e9 ef 07 00 00       	jmp    1027e4 <__alltraps>

00101ff5 <vector73>:
.globl vector73
vector73:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $73
  101ff7:	6a 49                	push   $0x49
  jmp __alltraps
  101ff9:	e9 e6 07 00 00       	jmp    1027e4 <__alltraps>

00101ffe <vector74>:
.globl vector74
vector74:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $74
  102000:	6a 4a                	push   $0x4a
  jmp __alltraps
  102002:	e9 dd 07 00 00       	jmp    1027e4 <__alltraps>

00102007 <vector75>:
.globl vector75
vector75:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $75
  102009:	6a 4b                	push   $0x4b
  jmp __alltraps
  10200b:	e9 d4 07 00 00       	jmp    1027e4 <__alltraps>

00102010 <vector76>:
.globl vector76
vector76:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $76
  102012:	6a 4c                	push   $0x4c
  jmp __alltraps
  102014:	e9 cb 07 00 00       	jmp    1027e4 <__alltraps>

00102019 <vector77>:
.globl vector77
vector77:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $77
  10201b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10201d:	e9 c2 07 00 00       	jmp    1027e4 <__alltraps>

00102022 <vector78>:
.globl vector78
vector78:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $78
  102024:	6a 4e                	push   $0x4e
  jmp __alltraps
  102026:	e9 b9 07 00 00       	jmp    1027e4 <__alltraps>

0010202b <vector79>:
.globl vector79
vector79:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $79
  10202d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10202f:	e9 b0 07 00 00       	jmp    1027e4 <__alltraps>

00102034 <vector80>:
.globl vector80
vector80:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $80
  102036:	6a 50                	push   $0x50
  jmp __alltraps
  102038:	e9 a7 07 00 00       	jmp    1027e4 <__alltraps>

0010203d <vector81>:
.globl vector81
vector81:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $81
  10203f:	6a 51                	push   $0x51
  jmp __alltraps
  102041:	e9 9e 07 00 00       	jmp    1027e4 <__alltraps>

00102046 <vector82>:
.globl vector82
vector82:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $82
  102048:	6a 52                	push   $0x52
  jmp __alltraps
  10204a:	e9 95 07 00 00       	jmp    1027e4 <__alltraps>

0010204f <vector83>:
.globl vector83
vector83:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $83
  102051:	6a 53                	push   $0x53
  jmp __alltraps
  102053:	e9 8c 07 00 00       	jmp    1027e4 <__alltraps>

00102058 <vector84>:
.globl vector84
vector84:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $84
  10205a:	6a 54                	push   $0x54
  jmp __alltraps
  10205c:	e9 83 07 00 00       	jmp    1027e4 <__alltraps>

00102061 <vector85>:
.globl vector85
vector85:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $85
  102063:	6a 55                	push   $0x55
  jmp __alltraps
  102065:	e9 7a 07 00 00       	jmp    1027e4 <__alltraps>

0010206a <vector86>:
.globl vector86
vector86:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $86
  10206c:	6a 56                	push   $0x56
  jmp __alltraps
  10206e:	e9 71 07 00 00       	jmp    1027e4 <__alltraps>

00102073 <vector87>:
.globl vector87
vector87:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $87
  102075:	6a 57                	push   $0x57
  jmp __alltraps
  102077:	e9 68 07 00 00       	jmp    1027e4 <__alltraps>

0010207c <vector88>:
.globl vector88
vector88:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $88
  10207e:	6a 58                	push   $0x58
  jmp __alltraps
  102080:	e9 5f 07 00 00       	jmp    1027e4 <__alltraps>

00102085 <vector89>:
.globl vector89
vector89:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $89
  102087:	6a 59                	push   $0x59
  jmp __alltraps
  102089:	e9 56 07 00 00       	jmp    1027e4 <__alltraps>

0010208e <vector90>:
.globl vector90
vector90:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $90
  102090:	6a 5a                	push   $0x5a
  jmp __alltraps
  102092:	e9 4d 07 00 00       	jmp    1027e4 <__alltraps>

00102097 <vector91>:
.globl vector91
vector91:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $91
  102099:	6a 5b                	push   $0x5b
  jmp __alltraps
  10209b:	e9 44 07 00 00       	jmp    1027e4 <__alltraps>

001020a0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $92
  1020a2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020a4:	e9 3b 07 00 00       	jmp    1027e4 <__alltraps>

001020a9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $93
  1020ab:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020ad:	e9 32 07 00 00       	jmp    1027e4 <__alltraps>

001020b2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $94
  1020b4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020b6:	e9 29 07 00 00       	jmp    1027e4 <__alltraps>

001020bb <vector95>:
.globl vector95
vector95:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $95
  1020bd:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020bf:	e9 20 07 00 00       	jmp    1027e4 <__alltraps>

001020c4 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $96
  1020c6:	6a 60                	push   $0x60
  jmp __alltraps
  1020c8:	e9 17 07 00 00       	jmp    1027e4 <__alltraps>

001020cd <vector97>:
.globl vector97
vector97:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $97
  1020cf:	6a 61                	push   $0x61
  jmp __alltraps
  1020d1:	e9 0e 07 00 00       	jmp    1027e4 <__alltraps>

001020d6 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $98
  1020d8:	6a 62                	push   $0x62
  jmp __alltraps
  1020da:	e9 05 07 00 00       	jmp    1027e4 <__alltraps>

001020df <vector99>:
.globl vector99
vector99:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $99
  1020e1:	6a 63                	push   $0x63
  jmp __alltraps
  1020e3:	e9 fc 06 00 00       	jmp    1027e4 <__alltraps>

001020e8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $100
  1020ea:	6a 64                	push   $0x64
  jmp __alltraps
  1020ec:	e9 f3 06 00 00       	jmp    1027e4 <__alltraps>

001020f1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $101
  1020f3:	6a 65                	push   $0x65
  jmp __alltraps
  1020f5:	e9 ea 06 00 00       	jmp    1027e4 <__alltraps>

001020fa <vector102>:
.globl vector102
vector102:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $102
  1020fc:	6a 66                	push   $0x66
  jmp __alltraps
  1020fe:	e9 e1 06 00 00       	jmp    1027e4 <__alltraps>

00102103 <vector103>:
.globl vector103
vector103:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $103
  102105:	6a 67                	push   $0x67
  jmp __alltraps
  102107:	e9 d8 06 00 00       	jmp    1027e4 <__alltraps>

0010210c <vector104>:
.globl vector104
vector104:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $104
  10210e:	6a 68                	push   $0x68
  jmp __alltraps
  102110:	e9 cf 06 00 00       	jmp    1027e4 <__alltraps>

00102115 <vector105>:
.globl vector105
vector105:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $105
  102117:	6a 69                	push   $0x69
  jmp __alltraps
  102119:	e9 c6 06 00 00       	jmp    1027e4 <__alltraps>

0010211e <vector106>:
.globl vector106
vector106:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $106
  102120:	6a 6a                	push   $0x6a
  jmp __alltraps
  102122:	e9 bd 06 00 00       	jmp    1027e4 <__alltraps>

00102127 <vector107>:
.globl vector107
vector107:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $107
  102129:	6a 6b                	push   $0x6b
  jmp __alltraps
  10212b:	e9 b4 06 00 00       	jmp    1027e4 <__alltraps>

00102130 <vector108>:
.globl vector108
vector108:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $108
  102132:	6a 6c                	push   $0x6c
  jmp __alltraps
  102134:	e9 ab 06 00 00       	jmp    1027e4 <__alltraps>

00102139 <vector109>:
.globl vector109
vector109:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $109
  10213b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10213d:	e9 a2 06 00 00       	jmp    1027e4 <__alltraps>

00102142 <vector110>:
.globl vector110
vector110:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $110
  102144:	6a 6e                	push   $0x6e
  jmp __alltraps
  102146:	e9 99 06 00 00       	jmp    1027e4 <__alltraps>

0010214b <vector111>:
.globl vector111
vector111:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $111
  10214d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10214f:	e9 90 06 00 00       	jmp    1027e4 <__alltraps>

00102154 <vector112>:
.globl vector112
vector112:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $112
  102156:	6a 70                	push   $0x70
  jmp __alltraps
  102158:	e9 87 06 00 00       	jmp    1027e4 <__alltraps>

0010215d <vector113>:
.globl vector113
vector113:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $113
  10215f:	6a 71                	push   $0x71
  jmp __alltraps
  102161:	e9 7e 06 00 00       	jmp    1027e4 <__alltraps>

00102166 <vector114>:
.globl vector114
vector114:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $114
  102168:	6a 72                	push   $0x72
  jmp __alltraps
  10216a:	e9 75 06 00 00       	jmp    1027e4 <__alltraps>

0010216f <vector115>:
.globl vector115
vector115:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $115
  102171:	6a 73                	push   $0x73
  jmp __alltraps
  102173:	e9 6c 06 00 00       	jmp    1027e4 <__alltraps>

00102178 <vector116>:
.globl vector116
vector116:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $116
  10217a:	6a 74                	push   $0x74
  jmp __alltraps
  10217c:	e9 63 06 00 00       	jmp    1027e4 <__alltraps>

00102181 <vector117>:
.globl vector117
vector117:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $117
  102183:	6a 75                	push   $0x75
  jmp __alltraps
  102185:	e9 5a 06 00 00       	jmp    1027e4 <__alltraps>

0010218a <vector118>:
.globl vector118
vector118:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $118
  10218c:	6a 76                	push   $0x76
  jmp __alltraps
  10218e:	e9 51 06 00 00       	jmp    1027e4 <__alltraps>

00102193 <vector119>:
.globl vector119
vector119:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $119
  102195:	6a 77                	push   $0x77
  jmp __alltraps
  102197:	e9 48 06 00 00       	jmp    1027e4 <__alltraps>

0010219c <vector120>:
.globl vector120
vector120:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $120
  10219e:	6a 78                	push   $0x78
  jmp __alltraps
  1021a0:	e9 3f 06 00 00       	jmp    1027e4 <__alltraps>

001021a5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $121
  1021a7:	6a 79                	push   $0x79
  jmp __alltraps
  1021a9:	e9 36 06 00 00       	jmp    1027e4 <__alltraps>

001021ae <vector122>:
.globl vector122
vector122:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $122
  1021b0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021b2:	e9 2d 06 00 00       	jmp    1027e4 <__alltraps>

001021b7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $123
  1021b9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021bb:	e9 24 06 00 00       	jmp    1027e4 <__alltraps>

001021c0 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $124
  1021c2:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021c4:	e9 1b 06 00 00       	jmp    1027e4 <__alltraps>

001021c9 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $125
  1021cb:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021cd:	e9 12 06 00 00       	jmp    1027e4 <__alltraps>

001021d2 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $126
  1021d4:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021d6:	e9 09 06 00 00       	jmp    1027e4 <__alltraps>

001021db <vector127>:
.globl vector127
vector127:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $127
  1021dd:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021df:	e9 00 06 00 00       	jmp    1027e4 <__alltraps>

001021e4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $128
  1021e6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021eb:	e9 f4 05 00 00       	jmp    1027e4 <__alltraps>

001021f0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $129
  1021f2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021f7:	e9 e8 05 00 00       	jmp    1027e4 <__alltraps>

001021fc <vector130>:
.globl vector130
vector130:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $130
  1021fe:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102203:	e9 dc 05 00 00       	jmp    1027e4 <__alltraps>

00102208 <vector131>:
.globl vector131
vector131:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $131
  10220a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10220f:	e9 d0 05 00 00       	jmp    1027e4 <__alltraps>

00102214 <vector132>:
.globl vector132
vector132:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $132
  102216:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10221b:	e9 c4 05 00 00       	jmp    1027e4 <__alltraps>

00102220 <vector133>:
.globl vector133
vector133:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $133
  102222:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102227:	e9 b8 05 00 00       	jmp    1027e4 <__alltraps>

0010222c <vector134>:
.globl vector134
vector134:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $134
  10222e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102233:	e9 ac 05 00 00       	jmp    1027e4 <__alltraps>

00102238 <vector135>:
.globl vector135
vector135:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $135
  10223a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10223f:	e9 a0 05 00 00       	jmp    1027e4 <__alltraps>

00102244 <vector136>:
.globl vector136
vector136:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $136
  102246:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10224b:	e9 94 05 00 00       	jmp    1027e4 <__alltraps>

00102250 <vector137>:
.globl vector137
vector137:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $137
  102252:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102257:	e9 88 05 00 00       	jmp    1027e4 <__alltraps>

0010225c <vector138>:
.globl vector138
vector138:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $138
  10225e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102263:	e9 7c 05 00 00       	jmp    1027e4 <__alltraps>

00102268 <vector139>:
.globl vector139
vector139:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $139
  10226a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10226f:	e9 70 05 00 00       	jmp    1027e4 <__alltraps>

00102274 <vector140>:
.globl vector140
vector140:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $140
  102276:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10227b:	e9 64 05 00 00       	jmp    1027e4 <__alltraps>

00102280 <vector141>:
.globl vector141
vector141:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $141
  102282:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102287:	e9 58 05 00 00       	jmp    1027e4 <__alltraps>

0010228c <vector142>:
.globl vector142
vector142:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $142
  10228e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102293:	e9 4c 05 00 00       	jmp    1027e4 <__alltraps>

00102298 <vector143>:
.globl vector143
vector143:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $143
  10229a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10229f:	e9 40 05 00 00       	jmp    1027e4 <__alltraps>

001022a4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $144
  1022a6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022ab:	e9 34 05 00 00       	jmp    1027e4 <__alltraps>

001022b0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $145
  1022b2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022b7:	e9 28 05 00 00       	jmp    1027e4 <__alltraps>

001022bc <vector146>:
.globl vector146
vector146:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $146
  1022be:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022c3:	e9 1c 05 00 00       	jmp    1027e4 <__alltraps>

001022c8 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $147
  1022ca:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022cf:	e9 10 05 00 00       	jmp    1027e4 <__alltraps>

001022d4 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $148
  1022d6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022db:	e9 04 05 00 00       	jmp    1027e4 <__alltraps>

001022e0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $149
  1022e2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022e7:	e9 f8 04 00 00       	jmp    1027e4 <__alltraps>

001022ec <vector150>:
.globl vector150
vector150:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $150
  1022ee:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022f3:	e9 ec 04 00 00       	jmp    1027e4 <__alltraps>

001022f8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $151
  1022fa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1022ff:	e9 e0 04 00 00       	jmp    1027e4 <__alltraps>

00102304 <vector152>:
.globl vector152
vector152:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $152
  102306:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10230b:	e9 d4 04 00 00       	jmp    1027e4 <__alltraps>

00102310 <vector153>:
.globl vector153
vector153:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $153
  102312:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102317:	e9 c8 04 00 00       	jmp    1027e4 <__alltraps>

0010231c <vector154>:
.globl vector154
vector154:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $154
  10231e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102323:	e9 bc 04 00 00       	jmp    1027e4 <__alltraps>

00102328 <vector155>:
.globl vector155
vector155:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $155
  10232a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10232f:	e9 b0 04 00 00       	jmp    1027e4 <__alltraps>

00102334 <vector156>:
.globl vector156
vector156:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $156
  102336:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10233b:	e9 a4 04 00 00       	jmp    1027e4 <__alltraps>

00102340 <vector157>:
.globl vector157
vector157:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $157
  102342:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102347:	e9 98 04 00 00       	jmp    1027e4 <__alltraps>

0010234c <vector158>:
.globl vector158
vector158:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $158
  10234e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102353:	e9 8c 04 00 00       	jmp    1027e4 <__alltraps>

00102358 <vector159>:
.globl vector159
vector159:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $159
  10235a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10235f:	e9 80 04 00 00       	jmp    1027e4 <__alltraps>

00102364 <vector160>:
.globl vector160
vector160:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $160
  102366:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10236b:	e9 74 04 00 00       	jmp    1027e4 <__alltraps>

00102370 <vector161>:
.globl vector161
vector161:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $161
  102372:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102377:	e9 68 04 00 00       	jmp    1027e4 <__alltraps>

0010237c <vector162>:
.globl vector162
vector162:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $162
  10237e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102383:	e9 5c 04 00 00       	jmp    1027e4 <__alltraps>

00102388 <vector163>:
.globl vector163
vector163:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $163
  10238a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10238f:	e9 50 04 00 00       	jmp    1027e4 <__alltraps>

00102394 <vector164>:
.globl vector164
vector164:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $164
  102396:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10239b:	e9 44 04 00 00       	jmp    1027e4 <__alltraps>

001023a0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $165
  1023a2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023a7:	e9 38 04 00 00       	jmp    1027e4 <__alltraps>

001023ac <vector166>:
.globl vector166
vector166:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $166
  1023ae:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023b3:	e9 2c 04 00 00       	jmp    1027e4 <__alltraps>

001023b8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $167
  1023ba:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023bf:	e9 20 04 00 00       	jmp    1027e4 <__alltraps>

001023c4 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $168
  1023c6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023cb:	e9 14 04 00 00       	jmp    1027e4 <__alltraps>

001023d0 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $169
  1023d2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023d7:	e9 08 04 00 00       	jmp    1027e4 <__alltraps>

001023dc <vector170>:
.globl vector170
vector170:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $170
  1023de:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023e3:	e9 fc 03 00 00       	jmp    1027e4 <__alltraps>

001023e8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $171
  1023ea:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023ef:	e9 f0 03 00 00       	jmp    1027e4 <__alltraps>

001023f4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $172
  1023f6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023fb:	e9 e4 03 00 00       	jmp    1027e4 <__alltraps>

00102400 <vector173>:
.globl vector173
vector173:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $173
  102402:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102407:	e9 d8 03 00 00       	jmp    1027e4 <__alltraps>

0010240c <vector174>:
.globl vector174
vector174:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $174
  10240e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102413:	e9 cc 03 00 00       	jmp    1027e4 <__alltraps>

00102418 <vector175>:
.globl vector175
vector175:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $175
  10241a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10241f:	e9 c0 03 00 00       	jmp    1027e4 <__alltraps>

00102424 <vector176>:
.globl vector176
vector176:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $176
  102426:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10242b:	e9 b4 03 00 00       	jmp    1027e4 <__alltraps>

00102430 <vector177>:
.globl vector177
vector177:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $177
  102432:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102437:	e9 a8 03 00 00       	jmp    1027e4 <__alltraps>

0010243c <vector178>:
.globl vector178
vector178:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $178
  10243e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102443:	e9 9c 03 00 00       	jmp    1027e4 <__alltraps>

00102448 <vector179>:
.globl vector179
vector179:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $179
  10244a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10244f:	e9 90 03 00 00       	jmp    1027e4 <__alltraps>

00102454 <vector180>:
.globl vector180
vector180:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $180
  102456:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10245b:	e9 84 03 00 00       	jmp    1027e4 <__alltraps>

00102460 <vector181>:
.globl vector181
vector181:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $181
  102462:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102467:	e9 78 03 00 00       	jmp    1027e4 <__alltraps>

0010246c <vector182>:
.globl vector182
vector182:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $182
  10246e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102473:	e9 6c 03 00 00       	jmp    1027e4 <__alltraps>

00102478 <vector183>:
.globl vector183
vector183:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $183
  10247a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10247f:	e9 60 03 00 00       	jmp    1027e4 <__alltraps>

00102484 <vector184>:
.globl vector184
vector184:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $184
  102486:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10248b:	e9 54 03 00 00       	jmp    1027e4 <__alltraps>

00102490 <vector185>:
.globl vector185
vector185:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $185
  102492:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102497:	e9 48 03 00 00       	jmp    1027e4 <__alltraps>

0010249c <vector186>:
.globl vector186
vector186:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $186
  10249e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024a3:	e9 3c 03 00 00       	jmp    1027e4 <__alltraps>

001024a8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $187
  1024aa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024af:	e9 30 03 00 00       	jmp    1027e4 <__alltraps>

001024b4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $188
  1024b6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024bb:	e9 24 03 00 00       	jmp    1027e4 <__alltraps>

001024c0 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $189
  1024c2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024c7:	e9 18 03 00 00       	jmp    1027e4 <__alltraps>

001024cc <vector190>:
.globl vector190
vector190:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $190
  1024ce:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024d3:	e9 0c 03 00 00       	jmp    1027e4 <__alltraps>

001024d8 <vector191>:
.globl vector191
vector191:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $191
  1024da:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024df:	e9 00 03 00 00       	jmp    1027e4 <__alltraps>

001024e4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $192
  1024e6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024eb:	e9 f4 02 00 00       	jmp    1027e4 <__alltraps>

001024f0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $193
  1024f2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024f7:	e9 e8 02 00 00       	jmp    1027e4 <__alltraps>

001024fc <vector194>:
.globl vector194
vector194:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $194
  1024fe:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102503:	e9 dc 02 00 00       	jmp    1027e4 <__alltraps>

00102508 <vector195>:
.globl vector195
vector195:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $195
  10250a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10250f:	e9 d0 02 00 00       	jmp    1027e4 <__alltraps>

00102514 <vector196>:
.globl vector196
vector196:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $196
  102516:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10251b:	e9 c4 02 00 00       	jmp    1027e4 <__alltraps>

00102520 <vector197>:
.globl vector197
vector197:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $197
  102522:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102527:	e9 b8 02 00 00       	jmp    1027e4 <__alltraps>

0010252c <vector198>:
.globl vector198
vector198:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $198
  10252e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102533:	e9 ac 02 00 00       	jmp    1027e4 <__alltraps>

00102538 <vector199>:
.globl vector199
vector199:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $199
  10253a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10253f:	e9 a0 02 00 00       	jmp    1027e4 <__alltraps>

00102544 <vector200>:
.globl vector200
vector200:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $200
  102546:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10254b:	e9 94 02 00 00       	jmp    1027e4 <__alltraps>

00102550 <vector201>:
.globl vector201
vector201:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $201
  102552:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102557:	e9 88 02 00 00       	jmp    1027e4 <__alltraps>

0010255c <vector202>:
.globl vector202
vector202:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $202
  10255e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102563:	e9 7c 02 00 00       	jmp    1027e4 <__alltraps>

00102568 <vector203>:
.globl vector203
vector203:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $203
  10256a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10256f:	e9 70 02 00 00       	jmp    1027e4 <__alltraps>

00102574 <vector204>:
.globl vector204
vector204:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $204
  102576:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10257b:	e9 64 02 00 00       	jmp    1027e4 <__alltraps>

00102580 <vector205>:
.globl vector205
vector205:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $205
  102582:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102587:	e9 58 02 00 00       	jmp    1027e4 <__alltraps>

0010258c <vector206>:
.globl vector206
vector206:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $206
  10258e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102593:	e9 4c 02 00 00       	jmp    1027e4 <__alltraps>

00102598 <vector207>:
.globl vector207
vector207:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $207
  10259a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10259f:	e9 40 02 00 00       	jmp    1027e4 <__alltraps>

001025a4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $208
  1025a6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025ab:	e9 34 02 00 00       	jmp    1027e4 <__alltraps>

001025b0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $209
  1025b2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025b7:	e9 28 02 00 00       	jmp    1027e4 <__alltraps>

001025bc <vector210>:
.globl vector210
vector210:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $210
  1025be:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025c3:	e9 1c 02 00 00       	jmp    1027e4 <__alltraps>

001025c8 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $211
  1025ca:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025cf:	e9 10 02 00 00       	jmp    1027e4 <__alltraps>

001025d4 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $212
  1025d6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025db:	e9 04 02 00 00       	jmp    1027e4 <__alltraps>

001025e0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $213
  1025e2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025e7:	e9 f8 01 00 00       	jmp    1027e4 <__alltraps>

001025ec <vector214>:
.globl vector214
vector214:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $214
  1025ee:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025f3:	e9 ec 01 00 00       	jmp    1027e4 <__alltraps>

001025f8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $215
  1025fa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1025ff:	e9 e0 01 00 00       	jmp    1027e4 <__alltraps>

00102604 <vector216>:
.globl vector216
vector216:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $216
  102606:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10260b:	e9 d4 01 00 00       	jmp    1027e4 <__alltraps>

00102610 <vector217>:
.globl vector217
vector217:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $217
  102612:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102617:	e9 c8 01 00 00       	jmp    1027e4 <__alltraps>

0010261c <vector218>:
.globl vector218
vector218:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $218
  10261e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102623:	e9 bc 01 00 00       	jmp    1027e4 <__alltraps>

00102628 <vector219>:
.globl vector219
vector219:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $219
  10262a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10262f:	e9 b0 01 00 00       	jmp    1027e4 <__alltraps>

00102634 <vector220>:
.globl vector220
vector220:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $220
  102636:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10263b:	e9 a4 01 00 00       	jmp    1027e4 <__alltraps>

00102640 <vector221>:
.globl vector221
vector221:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $221
  102642:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102647:	e9 98 01 00 00       	jmp    1027e4 <__alltraps>

0010264c <vector222>:
.globl vector222
vector222:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $222
  10264e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102653:	e9 8c 01 00 00       	jmp    1027e4 <__alltraps>

00102658 <vector223>:
.globl vector223
vector223:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $223
  10265a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10265f:	e9 80 01 00 00       	jmp    1027e4 <__alltraps>

00102664 <vector224>:
.globl vector224
vector224:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $224
  102666:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10266b:	e9 74 01 00 00       	jmp    1027e4 <__alltraps>

00102670 <vector225>:
.globl vector225
vector225:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $225
  102672:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102677:	e9 68 01 00 00       	jmp    1027e4 <__alltraps>

0010267c <vector226>:
.globl vector226
vector226:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $226
  10267e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102683:	e9 5c 01 00 00       	jmp    1027e4 <__alltraps>

00102688 <vector227>:
.globl vector227
vector227:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $227
  10268a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10268f:	e9 50 01 00 00       	jmp    1027e4 <__alltraps>

00102694 <vector228>:
.globl vector228
vector228:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $228
  102696:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10269b:	e9 44 01 00 00       	jmp    1027e4 <__alltraps>

001026a0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $229
  1026a2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026a7:	e9 38 01 00 00       	jmp    1027e4 <__alltraps>

001026ac <vector230>:
.globl vector230
vector230:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $230
  1026ae:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026b3:	e9 2c 01 00 00       	jmp    1027e4 <__alltraps>

001026b8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $231
  1026ba:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026bf:	e9 20 01 00 00       	jmp    1027e4 <__alltraps>

001026c4 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $232
  1026c6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026cb:	e9 14 01 00 00       	jmp    1027e4 <__alltraps>

001026d0 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $233
  1026d2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026d7:	e9 08 01 00 00       	jmp    1027e4 <__alltraps>

001026dc <vector234>:
.globl vector234
vector234:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $234
  1026de:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026e3:	e9 fc 00 00 00       	jmp    1027e4 <__alltraps>

001026e8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $235
  1026ea:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026ef:	e9 f0 00 00 00       	jmp    1027e4 <__alltraps>

001026f4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $236
  1026f6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026fb:	e9 e4 00 00 00       	jmp    1027e4 <__alltraps>

00102700 <vector237>:
.globl vector237
vector237:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $237
  102702:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102707:	e9 d8 00 00 00       	jmp    1027e4 <__alltraps>

0010270c <vector238>:
.globl vector238
vector238:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $238
  10270e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102713:	e9 cc 00 00 00       	jmp    1027e4 <__alltraps>

00102718 <vector239>:
.globl vector239
vector239:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $239
  10271a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10271f:	e9 c0 00 00 00       	jmp    1027e4 <__alltraps>

00102724 <vector240>:
.globl vector240
vector240:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $240
  102726:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10272b:	e9 b4 00 00 00       	jmp    1027e4 <__alltraps>

00102730 <vector241>:
.globl vector241
vector241:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $241
  102732:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102737:	e9 a8 00 00 00       	jmp    1027e4 <__alltraps>

0010273c <vector242>:
.globl vector242
vector242:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $242
  10273e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102743:	e9 9c 00 00 00       	jmp    1027e4 <__alltraps>

00102748 <vector243>:
.globl vector243
vector243:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $243
  10274a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10274f:	e9 90 00 00 00       	jmp    1027e4 <__alltraps>

00102754 <vector244>:
.globl vector244
vector244:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $244
  102756:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10275b:	e9 84 00 00 00       	jmp    1027e4 <__alltraps>

00102760 <vector245>:
.globl vector245
vector245:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $245
  102762:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102767:	e9 78 00 00 00       	jmp    1027e4 <__alltraps>

0010276c <vector246>:
.globl vector246
vector246:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $246
  10276e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102773:	e9 6c 00 00 00       	jmp    1027e4 <__alltraps>

00102778 <vector247>:
.globl vector247
vector247:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $247
  10277a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10277f:	e9 60 00 00 00       	jmp    1027e4 <__alltraps>

00102784 <vector248>:
.globl vector248
vector248:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $248
  102786:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10278b:	e9 54 00 00 00       	jmp    1027e4 <__alltraps>

00102790 <vector249>:
.globl vector249
vector249:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $249
  102792:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102797:	e9 48 00 00 00       	jmp    1027e4 <__alltraps>

0010279c <vector250>:
.globl vector250
vector250:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $250
  10279e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027a3:	e9 3c 00 00 00       	jmp    1027e4 <__alltraps>

001027a8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $251
  1027aa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027af:	e9 30 00 00 00       	jmp    1027e4 <__alltraps>

001027b4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $252
  1027b6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027bb:	e9 24 00 00 00       	jmp    1027e4 <__alltraps>

001027c0 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $253
  1027c2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027c7:	e9 18 00 00 00       	jmp    1027e4 <__alltraps>

001027cc <vector254>:
.globl vector254
vector254:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $254
  1027ce:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027d3:	e9 0c 00 00 00       	jmp    1027e4 <__alltraps>

001027d8 <vector255>:
.globl vector255
vector255:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $255
  1027da:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027df:	e9 00 00 00 00       	jmp    1027e4 <__alltraps>

001027e4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1027e4:	1e                   	push   %ds
    pushl %es
  1027e5:	06                   	push   %es
    pushl %fs
  1027e6:	0f a0                	push   %fs
    pushl %gs
  1027e8:	0f a8                	push   %gs
    pushal
  1027ea:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1027eb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1027f0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1027f2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1027f4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1027f5:	e8 63 f5 ff ff       	call   101d5d <trap>

    # pop the pushed stack pointer
    popl %esp
  1027fa:	5c                   	pop    %esp

001027fb <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1027fb:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1027fc:	0f a9                	pop    %gs
    popl %fs
  1027fe:	0f a1                	pop    %fs
    popl %es
  102800:	07                   	pop    %es
    popl %ds
  102801:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102802:	83 c4 08             	add    $0x8,%esp
    iret
  102805:	cf                   	iret   

00102806 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102806:	55                   	push   %ebp
  102807:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102809:	8b 45 08             	mov    0x8(%ebp),%eax
  10280c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10280f:	b8 23 00 00 00       	mov    $0x23,%eax
  102814:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102816:	b8 23 00 00 00       	mov    $0x23,%eax
  10281b:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10281d:	b8 10 00 00 00       	mov    $0x10,%eax
  102822:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102824:	b8 10 00 00 00       	mov    $0x10,%eax
  102829:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10282b:	b8 10 00 00 00       	mov    $0x10,%eax
  102830:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102832:	ea 39 28 10 00 08 00 	ljmp   $0x8,$0x102839
}
  102839:	90                   	nop
  10283a:	5d                   	pop    %ebp
  10283b:	c3                   	ret    

0010283c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10283c:	55                   	push   %ebp
  10283d:	89 e5                	mov    %esp,%ebp
  10283f:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102842:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102847:	05 00 04 00 00       	add    $0x400,%eax
  10284c:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102851:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102858:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10285a:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102861:	68 00 
  102863:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102868:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10286e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102873:	c1 e8 10             	shr    $0x10,%eax
  102876:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10287b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102882:	83 e0 f0             	and    $0xfffffff0,%eax
  102885:	83 c8 09             	or     $0x9,%eax
  102888:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102894:	83 c8 10             	or     $0x10,%eax
  102897:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028a3:	83 e0 9f             	and    $0xffffff9f,%eax
  1028a6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ab:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028b2:	83 c8 80             	or     $0xffffff80,%eax
  1028b5:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ba:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c1:	83 e0 f0             	and    $0xfffffff0,%eax
  1028c4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028c9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d0:	83 e0 ef             	and    $0xffffffef,%eax
  1028d3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028df:	83 e0 df             	and    $0xffffffdf,%eax
  1028e2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ee:	83 c8 40             	or     $0x40,%eax
  1028f1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028fd:	83 e0 7f             	and    $0x7f,%eax
  102900:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102905:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10290a:	c1 e8 18             	shr    $0x18,%eax
  10290d:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102912:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102919:	83 e0 ef             	and    $0xffffffef,%eax
  10291c:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102921:	68 10 ea 10 00       	push   $0x10ea10
  102926:	e8 db fe ff ff       	call   102806 <lgdt>
  10292b:	83 c4 04             	add    $0x4,%esp
  10292e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102934:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102938:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10293b:	90                   	nop
  10293c:	c9                   	leave  
  10293d:	c3                   	ret    

0010293e <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10293e:	55                   	push   %ebp
  10293f:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102941:	e8 f6 fe ff ff       	call   10283c <gdt_init>
}
  102946:	90                   	nop
  102947:	5d                   	pop    %ebp
  102948:	c3                   	ret    

00102949 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102949:	55                   	push   %ebp
  10294a:	89 e5                	mov    %esp,%ebp
  10294c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10294f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102956:	eb 04                	jmp    10295c <strlen+0x13>
        cnt ++;
  102958:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10295c:	8b 45 08             	mov    0x8(%ebp),%eax
  10295f:	8d 50 01             	lea    0x1(%eax),%edx
  102962:	89 55 08             	mov    %edx,0x8(%ebp)
  102965:	0f b6 00             	movzbl (%eax),%eax
  102968:	84 c0                	test   %al,%al
  10296a:	75 ec                	jne    102958 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10296c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10296f:	c9                   	leave  
  102970:	c3                   	ret    

00102971 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102971:	55                   	push   %ebp
  102972:	89 e5                	mov    %esp,%ebp
  102974:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102977:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10297e:	eb 04                	jmp    102984 <strnlen+0x13>
        cnt ++;
  102980:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102987:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10298a:	73 10                	jae    10299c <strnlen+0x2b>
  10298c:	8b 45 08             	mov    0x8(%ebp),%eax
  10298f:	8d 50 01             	lea    0x1(%eax),%edx
  102992:	89 55 08             	mov    %edx,0x8(%ebp)
  102995:	0f b6 00             	movzbl (%eax),%eax
  102998:	84 c0                	test   %al,%al
  10299a:	75 e4                	jne    102980 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10299c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10299f:	c9                   	leave  
  1029a0:	c3                   	ret    

001029a1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1029a1:	55                   	push   %ebp
  1029a2:	89 e5                	mov    %esp,%ebp
  1029a4:	57                   	push   %edi
  1029a5:	56                   	push   %esi
  1029a6:	83 ec 20             	sub    $0x20,%esp
  1029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1029b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bb:	89 d1                	mov    %edx,%ecx
  1029bd:	89 c2                	mov    %eax,%edx
  1029bf:	89 ce                	mov    %ecx,%esi
  1029c1:	89 d7                	mov    %edx,%edi
  1029c3:	ac                   	lods   %ds:(%esi),%al
  1029c4:	aa                   	stos   %al,%es:(%edi)
  1029c5:	84 c0                	test   %al,%al
  1029c7:	75 fa                	jne    1029c3 <strcpy+0x22>
  1029c9:	89 fa                	mov    %edi,%edx
  1029cb:	89 f1                	mov    %esi,%ecx
  1029cd:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1029d0:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1029d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  1029d9:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1029da:	83 c4 20             	add    $0x20,%esp
  1029dd:	5e                   	pop    %esi
  1029de:	5f                   	pop    %edi
  1029df:	5d                   	pop    %ebp
  1029e0:	c3                   	ret    

001029e1 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1029e1:	55                   	push   %ebp
  1029e2:	89 e5                	mov    %esp,%ebp
  1029e4:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1029ed:	eb 21                	jmp    102a10 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1029ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029f2:	0f b6 10             	movzbl (%eax),%edx
  1029f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029f8:	88 10                	mov    %dl,(%eax)
  1029fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1029fd:	0f b6 00             	movzbl (%eax),%eax
  102a00:	84 c0                	test   %al,%al
  102a02:	74 04                	je     102a08 <strncpy+0x27>
            src ++;
  102a04:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102a08:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102a0c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102a10:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a14:	75 d9                	jne    1029ef <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102a16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102a19:	c9                   	leave  
  102a1a:	c3                   	ret    

00102a1b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102a1b:	55                   	push   %ebp
  102a1c:	89 e5                	mov    %esp,%ebp
  102a1e:	57                   	push   %edi
  102a1f:	56                   	push   %esi
  102a20:	83 ec 20             	sub    $0x20,%esp
  102a23:	8b 45 08             	mov    0x8(%ebp),%eax
  102a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a35:	89 d1                	mov    %edx,%ecx
  102a37:	89 c2                	mov    %eax,%edx
  102a39:	89 ce                	mov    %ecx,%esi
  102a3b:	89 d7                	mov    %edx,%edi
  102a3d:	ac                   	lods   %ds:(%esi),%al
  102a3e:	ae                   	scas   %es:(%edi),%al
  102a3f:	75 08                	jne    102a49 <strcmp+0x2e>
  102a41:	84 c0                	test   %al,%al
  102a43:	75 f8                	jne    102a3d <strcmp+0x22>
  102a45:	31 c0                	xor    %eax,%eax
  102a47:	eb 04                	jmp    102a4d <strcmp+0x32>
  102a49:	19 c0                	sbb    %eax,%eax
  102a4b:	0c 01                	or     $0x1,%al
  102a4d:	89 fa                	mov    %edi,%edx
  102a4f:	89 f1                	mov    %esi,%ecx
  102a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102a54:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102a57:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102a5d:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102a5e:	83 c4 20             	add    $0x20,%esp
  102a61:	5e                   	pop    %esi
  102a62:	5f                   	pop    %edi
  102a63:	5d                   	pop    %ebp
  102a64:	c3                   	ret    

00102a65 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a68:	eb 0c                	jmp    102a76 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102a6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102a6e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a72:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102a76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a7a:	74 1a                	je     102a96 <strncmp+0x31>
  102a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7f:	0f b6 00             	movzbl (%eax),%eax
  102a82:	84 c0                	test   %al,%al
  102a84:	74 10                	je     102a96 <strncmp+0x31>
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	0f b6 10             	movzbl (%eax),%edx
  102a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a8f:	0f b6 00             	movzbl (%eax),%eax
  102a92:	38 c2                	cmp    %al,%dl
  102a94:	74 d4                	je     102a6a <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102a96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a9a:	74 18                	je     102ab4 <strncmp+0x4f>
  102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9f:	0f b6 00             	movzbl (%eax),%eax
  102aa2:	0f b6 d0             	movzbl %al,%edx
  102aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aa8:	0f b6 00             	movzbl (%eax),%eax
  102aab:	0f b6 c0             	movzbl %al,%eax
  102aae:	29 c2                	sub    %eax,%edx
  102ab0:	89 d0                	mov    %edx,%eax
  102ab2:	eb 05                	jmp    102ab9 <strncmp+0x54>
  102ab4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ab9:	5d                   	pop    %ebp
  102aba:	c3                   	ret    

00102abb <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102abb:	55                   	push   %ebp
  102abc:	89 e5                	mov    %esp,%ebp
  102abe:	83 ec 04             	sub    $0x4,%esp
  102ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ac4:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ac7:	eb 14                	jmp    102add <strchr+0x22>
        if (*s == c) {
  102ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  102acc:	0f b6 00             	movzbl (%eax),%eax
  102acf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102ad2:	75 05                	jne    102ad9 <strchr+0x1e>
            return (char *)s;
  102ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad7:	eb 13                	jmp    102aec <strchr+0x31>
        }
        s ++;
  102ad9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102add:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae0:	0f b6 00             	movzbl (%eax),%eax
  102ae3:	84 c0                	test   %al,%al
  102ae5:	75 e2                	jne    102ac9 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102aec:	c9                   	leave  
  102aed:	c3                   	ret    

00102aee <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102aee:	55                   	push   %ebp
  102aef:	89 e5                	mov    %esp,%ebp
  102af1:	83 ec 04             	sub    $0x4,%esp
  102af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102afa:	eb 0f                	jmp    102b0b <strfind+0x1d>
        if (*s == c) {
  102afc:	8b 45 08             	mov    0x8(%ebp),%eax
  102aff:	0f b6 00             	movzbl (%eax),%eax
  102b02:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b05:	74 10                	je     102b17 <strfind+0x29>
            break;
        }
        s ++;
  102b07:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0e:	0f b6 00             	movzbl (%eax),%eax
  102b11:	84 c0                	test   %al,%al
  102b13:	75 e7                	jne    102afc <strfind+0xe>
  102b15:	eb 01                	jmp    102b18 <strfind+0x2a>
        if (*s == c) {
            break;
  102b17:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102b18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b1b:	c9                   	leave  
  102b1c:	c3                   	ret    

00102b1d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102b1d:	55                   	push   %ebp
  102b1e:	89 e5                	mov    %esp,%ebp
  102b20:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102b23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102b2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b31:	eb 04                	jmp    102b37 <strtol+0x1a>
        s ++;
  102b33:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102b37:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3a:	0f b6 00             	movzbl (%eax),%eax
  102b3d:	3c 20                	cmp    $0x20,%al
  102b3f:	74 f2                	je     102b33 <strtol+0x16>
  102b41:	8b 45 08             	mov    0x8(%ebp),%eax
  102b44:	0f b6 00             	movzbl (%eax),%eax
  102b47:	3c 09                	cmp    $0x9,%al
  102b49:	74 e8                	je     102b33 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4e:	0f b6 00             	movzbl (%eax),%eax
  102b51:	3c 2b                	cmp    $0x2b,%al
  102b53:	75 06                	jne    102b5b <strtol+0x3e>
        s ++;
  102b55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b59:	eb 15                	jmp    102b70 <strtol+0x53>
    }
    else if (*s == '-') {
  102b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5e:	0f b6 00             	movzbl (%eax),%eax
  102b61:	3c 2d                	cmp    $0x2d,%al
  102b63:	75 0b                	jne    102b70 <strtol+0x53>
        s ++, neg = 1;
  102b65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b69:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102b70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b74:	74 06                	je     102b7c <strtol+0x5f>
  102b76:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102b7a:	75 24                	jne    102ba0 <strtol+0x83>
  102b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7f:	0f b6 00             	movzbl (%eax),%eax
  102b82:	3c 30                	cmp    $0x30,%al
  102b84:	75 1a                	jne    102ba0 <strtol+0x83>
  102b86:	8b 45 08             	mov    0x8(%ebp),%eax
  102b89:	83 c0 01             	add    $0x1,%eax
  102b8c:	0f b6 00             	movzbl (%eax),%eax
  102b8f:	3c 78                	cmp    $0x78,%al
  102b91:	75 0d                	jne    102ba0 <strtol+0x83>
        s += 2, base = 16;
  102b93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102b97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102b9e:	eb 2a                	jmp    102bca <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102ba0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ba4:	75 17                	jne    102bbd <strtol+0xa0>
  102ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba9:	0f b6 00             	movzbl (%eax),%eax
  102bac:	3c 30                	cmp    $0x30,%al
  102bae:	75 0d                	jne    102bbd <strtol+0xa0>
        s ++, base = 8;
  102bb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bb4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102bbb:	eb 0d                	jmp    102bca <strtol+0xad>
    }
    else if (base == 0) {
  102bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc1:	75 07                	jne    102bca <strtol+0xad>
        base = 10;
  102bc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102bca:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcd:	0f b6 00             	movzbl (%eax),%eax
  102bd0:	3c 2f                	cmp    $0x2f,%al
  102bd2:	7e 1b                	jle    102bef <strtol+0xd2>
  102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd7:	0f b6 00             	movzbl (%eax),%eax
  102bda:	3c 39                	cmp    $0x39,%al
  102bdc:	7f 11                	jg     102bef <strtol+0xd2>
            dig = *s - '0';
  102bde:	8b 45 08             	mov    0x8(%ebp),%eax
  102be1:	0f b6 00             	movzbl (%eax),%eax
  102be4:	0f be c0             	movsbl %al,%eax
  102be7:	83 e8 30             	sub    $0x30,%eax
  102bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bed:	eb 48                	jmp    102c37 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102bef:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf2:	0f b6 00             	movzbl (%eax),%eax
  102bf5:	3c 60                	cmp    $0x60,%al
  102bf7:	7e 1b                	jle    102c14 <strtol+0xf7>
  102bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfc:	0f b6 00             	movzbl (%eax),%eax
  102bff:	3c 7a                	cmp    $0x7a,%al
  102c01:	7f 11                	jg     102c14 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102c03:	8b 45 08             	mov    0x8(%ebp),%eax
  102c06:	0f b6 00             	movzbl (%eax),%eax
  102c09:	0f be c0             	movsbl %al,%eax
  102c0c:	83 e8 57             	sub    $0x57,%eax
  102c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c12:	eb 23                	jmp    102c37 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102c14:	8b 45 08             	mov    0x8(%ebp),%eax
  102c17:	0f b6 00             	movzbl (%eax),%eax
  102c1a:	3c 40                	cmp    $0x40,%al
  102c1c:	7e 3c                	jle    102c5a <strtol+0x13d>
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	0f b6 00             	movzbl (%eax),%eax
  102c24:	3c 5a                	cmp    $0x5a,%al
  102c26:	7f 32                	jg     102c5a <strtol+0x13d>
            dig = *s - 'A' + 10;
  102c28:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2b:	0f b6 00             	movzbl (%eax),%eax
  102c2e:	0f be c0             	movsbl %al,%eax
  102c31:	83 e8 37             	sub    $0x37,%eax
  102c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  102c3d:	7d 1a                	jge    102c59 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102c3f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c46:	0f af 45 10          	imul   0x10(%ebp),%eax
  102c4a:	89 c2                	mov    %eax,%edx
  102c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4f:	01 d0                	add    %edx,%eax
  102c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102c54:	e9 71 ff ff ff       	jmp    102bca <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102c59:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c5e:	74 08                	je     102c68 <strtol+0x14b>
        *endptr = (char *) s;
  102c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c63:	8b 55 08             	mov    0x8(%ebp),%edx
  102c66:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102c68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102c6c:	74 07                	je     102c75 <strtol+0x158>
  102c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c71:	f7 d8                	neg    %eax
  102c73:	eb 03                	jmp    102c78 <strtol+0x15b>
  102c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102c78:	c9                   	leave  
  102c79:	c3                   	ret    

00102c7a <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102c7a:	55                   	push   %ebp
  102c7b:	89 e5                	mov    %esp,%ebp
  102c7d:	57                   	push   %edi
  102c7e:	83 ec 24             	sub    $0x24,%esp
  102c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c84:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102c87:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  102c8e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102c91:	88 45 f7             	mov    %al,-0x9(%ebp)
  102c94:	8b 45 10             	mov    0x10(%ebp),%eax
  102c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102c9a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102c9d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102ca1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102ca4:	89 d7                	mov    %edx,%edi
  102ca6:	f3 aa                	rep stos %al,%es:(%edi)
  102ca8:	89 fa                	mov    %edi,%edx
  102caa:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102cad:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102cb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102cb3:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102cb4:	83 c4 24             	add    $0x24,%esp
  102cb7:	5f                   	pop    %edi
  102cb8:	5d                   	pop    %ebp
  102cb9:	c3                   	ret    

00102cba <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102cba:	55                   	push   %ebp
  102cbb:	89 e5                	mov    %esp,%ebp
  102cbd:	57                   	push   %edi
  102cbe:	56                   	push   %esi
  102cbf:	53                   	push   %ebx
  102cc0:	83 ec 30             	sub    $0x30,%esp
  102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ccc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cdb:	73 42                	jae    102d1f <memmove+0x65>
  102cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cec:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102cef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cf2:	c1 e8 02             	shr    $0x2,%eax
  102cf5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cfd:	89 d7                	mov    %edx,%edi
  102cff:	89 c6                	mov    %eax,%esi
  102d01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102d06:	83 e1 03             	and    $0x3,%ecx
  102d09:	74 02                	je     102d0d <memmove+0x53>
  102d0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d0d:	89 f0                	mov    %esi,%eax
  102d0f:	89 fa                	mov    %edi,%edx
  102d11:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102d14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d17:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102d1d:	eb 36                	jmp    102d55 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d22:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d28:	01 c2                	add    %eax,%edx
  102d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d2d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d33:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d39:	89 c1                	mov    %eax,%ecx
  102d3b:	89 d8                	mov    %ebx,%eax
  102d3d:	89 d6                	mov    %edx,%esi
  102d3f:	89 c7                	mov    %eax,%edi
  102d41:	fd                   	std    
  102d42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d44:	fc                   	cld    
  102d45:	89 f8                	mov    %edi,%eax
  102d47:	89 f2                	mov    %esi,%edx
  102d49:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102d4c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102d4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102d55:	83 c4 30             	add    $0x30,%esp
  102d58:	5b                   	pop    %ebx
  102d59:	5e                   	pop    %esi
  102d5a:	5f                   	pop    %edi
  102d5b:	5d                   	pop    %ebp
  102d5c:	c3                   	ret    

00102d5d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102d5d:	55                   	push   %ebp
  102d5e:	89 e5                	mov    %esp,%ebp
  102d60:	57                   	push   %edi
  102d61:	56                   	push   %esi
  102d62:	83 ec 20             	sub    $0x20,%esp
  102d65:	8b 45 08             	mov    0x8(%ebp),%eax
  102d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d71:	8b 45 10             	mov    0x10(%ebp),%eax
  102d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d7a:	c1 e8 02             	shr    $0x2,%eax
  102d7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d85:	89 d7                	mov    %edx,%edi
  102d87:	89 c6                	mov    %eax,%esi
  102d89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102d8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102d8e:	83 e1 03             	and    $0x3,%ecx
  102d91:	74 02                	je     102d95 <memcpy+0x38>
  102d93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102d95:	89 f0                	mov    %esi,%eax
  102d97:	89 fa                	mov    %edi,%edx
  102d99:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d9c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102d9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102da5:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102da6:	83 c4 20             	add    $0x20,%esp
  102da9:	5e                   	pop    %esi
  102daa:	5f                   	pop    %edi
  102dab:	5d                   	pop    %ebp
  102dac:	c3                   	ret    

00102dad <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102dad:	55                   	push   %ebp
  102dae:	89 e5                	mov    %esp,%ebp
  102db0:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102db3:	8b 45 08             	mov    0x8(%ebp),%eax
  102db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102dbf:	eb 30                	jmp    102df1 <memcmp+0x44>
        if (*s1 != *s2) {
  102dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dc4:	0f b6 10             	movzbl (%eax),%edx
  102dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dca:	0f b6 00             	movzbl (%eax),%eax
  102dcd:	38 c2                	cmp    %al,%dl
  102dcf:	74 18                	je     102de9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102dd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dd4:	0f b6 00             	movzbl (%eax),%eax
  102dd7:	0f b6 d0             	movzbl %al,%edx
  102dda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ddd:	0f b6 00             	movzbl (%eax),%eax
  102de0:	0f b6 c0             	movzbl %al,%eax
  102de3:	29 c2                	sub    %eax,%edx
  102de5:	89 d0                	mov    %edx,%eax
  102de7:	eb 1a                	jmp    102e03 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102de9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102ded:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102df1:	8b 45 10             	mov    0x10(%ebp),%eax
  102df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  102df7:	89 55 10             	mov    %edx,0x10(%ebp)
  102dfa:	85 c0                	test   %eax,%eax
  102dfc:	75 c3                	jne    102dc1 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e03:	c9                   	leave  
  102e04:	c3                   	ret    

00102e05 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102e05:	55                   	push   %ebp
  102e06:	89 e5                	mov    %esp,%ebp
  102e08:	83 ec 38             	sub    $0x38,%esp
  102e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  102e0e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e11:	8b 45 14             	mov    0x14(%ebp),%eax
  102e14:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102e17:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e1a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e20:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102e23:	8b 45 18             	mov    0x18(%ebp),%eax
  102e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e2c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e32:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e3f:	74 1c                	je     102e5d <printnum+0x58>
  102e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e44:	ba 00 00 00 00       	mov    $0x0,%edx
  102e49:	f7 75 e4             	divl   -0x1c(%ebp)
  102e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e52:	ba 00 00 00 00       	mov    $0x0,%edx
  102e57:	f7 75 e4             	divl   -0x1c(%ebp)
  102e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e63:	f7 75 e4             	divl   -0x1c(%ebp)
  102e66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e69:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102e6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102e72:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e75:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102e78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e7b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102e7e:	8b 45 18             	mov    0x18(%ebp),%eax
  102e81:	ba 00 00 00 00       	mov    $0x0,%edx
  102e86:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e89:	77 41                	ja     102ecc <printnum+0xc7>
  102e8b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102e8e:	72 05                	jb     102e95 <printnum+0x90>
  102e90:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102e93:	77 37                	ja     102ecc <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102e95:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102e98:	83 e8 01             	sub    $0x1,%eax
  102e9b:	83 ec 04             	sub    $0x4,%esp
  102e9e:	ff 75 20             	pushl  0x20(%ebp)
  102ea1:	50                   	push   %eax
  102ea2:	ff 75 18             	pushl  0x18(%ebp)
  102ea5:	ff 75 ec             	pushl  -0x14(%ebp)
  102ea8:	ff 75 e8             	pushl  -0x18(%ebp)
  102eab:	ff 75 0c             	pushl  0xc(%ebp)
  102eae:	ff 75 08             	pushl  0x8(%ebp)
  102eb1:	e8 4f ff ff ff       	call   102e05 <printnum>
  102eb6:	83 c4 20             	add    $0x20,%esp
  102eb9:	eb 1b                	jmp    102ed6 <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102ebb:	83 ec 08             	sub    $0x8,%esp
  102ebe:	ff 75 0c             	pushl  0xc(%ebp)
  102ec1:	ff 75 20             	pushl  0x20(%ebp)
  102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec7:	ff d0                	call   *%eax
  102ec9:	83 c4 10             	add    $0x10,%esp
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102ecc:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102ed0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102ed4:	7f e5                	jg     102ebb <printnum+0xb6>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102ed6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ed9:	05 b0 3b 10 00       	add    $0x103bb0,%eax
  102ede:	0f b6 00             	movzbl (%eax),%eax
  102ee1:	0f be c0             	movsbl %al,%eax
  102ee4:	83 ec 08             	sub    $0x8,%esp
  102ee7:	ff 75 0c             	pushl  0xc(%ebp)
  102eea:	50                   	push   %eax
  102eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  102eee:	ff d0                	call   *%eax
  102ef0:	83 c4 10             	add    $0x10,%esp
}
  102ef3:	90                   	nop
  102ef4:	c9                   	leave  
  102ef5:	c3                   	ret    

00102ef6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102ef6:	55                   	push   %ebp
  102ef7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ef9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102efd:	7e 14                	jle    102f13 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102eff:	8b 45 08             	mov    0x8(%ebp),%eax
  102f02:	8b 00                	mov    (%eax),%eax
  102f04:	8d 48 08             	lea    0x8(%eax),%ecx
  102f07:	8b 55 08             	mov    0x8(%ebp),%edx
  102f0a:	89 0a                	mov    %ecx,(%edx)
  102f0c:	8b 50 04             	mov    0x4(%eax),%edx
  102f0f:	8b 00                	mov    (%eax),%eax
  102f11:	eb 30                	jmp    102f43 <getuint+0x4d>
    }
    else if (lflag) {
  102f13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f17:	74 16                	je     102f2f <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102f19:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1c:	8b 00                	mov    (%eax),%eax
  102f1e:	8d 48 04             	lea    0x4(%eax),%ecx
  102f21:	8b 55 08             	mov    0x8(%ebp),%edx
  102f24:	89 0a                	mov    %ecx,(%edx)
  102f26:	8b 00                	mov    (%eax),%eax
  102f28:	ba 00 00 00 00       	mov    $0x0,%edx
  102f2d:	eb 14                	jmp    102f43 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f32:	8b 00                	mov    (%eax),%eax
  102f34:	8d 48 04             	lea    0x4(%eax),%ecx
  102f37:	8b 55 08             	mov    0x8(%ebp),%edx
  102f3a:	89 0a                	mov    %ecx,(%edx)
  102f3c:	8b 00                	mov    (%eax),%eax
  102f3e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102f43:	5d                   	pop    %ebp
  102f44:	c3                   	ret    

00102f45 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102f45:	55                   	push   %ebp
  102f46:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102f48:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102f4c:	7e 14                	jle    102f62 <getint+0x1d>
        return va_arg(*ap, long long);
  102f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f51:	8b 00                	mov    (%eax),%eax
  102f53:	8d 48 08             	lea    0x8(%eax),%ecx
  102f56:	8b 55 08             	mov    0x8(%ebp),%edx
  102f59:	89 0a                	mov    %ecx,(%edx)
  102f5b:	8b 50 04             	mov    0x4(%eax),%edx
  102f5e:	8b 00                	mov    (%eax),%eax
  102f60:	eb 28                	jmp    102f8a <getint+0x45>
    }
    else if (lflag) {
  102f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f66:	74 12                	je     102f7a <getint+0x35>
        return va_arg(*ap, long);
  102f68:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6b:	8b 00                	mov    (%eax),%eax
  102f6d:	8d 48 04             	lea    0x4(%eax),%ecx
  102f70:	8b 55 08             	mov    0x8(%ebp),%edx
  102f73:	89 0a                	mov    %ecx,(%edx)
  102f75:	8b 00                	mov    (%eax),%eax
  102f77:	99                   	cltd   
  102f78:	eb 10                	jmp    102f8a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7d:	8b 00                	mov    (%eax),%eax
  102f7f:	8d 48 04             	lea    0x4(%eax),%ecx
  102f82:	8b 55 08             	mov    0x8(%ebp),%edx
  102f85:	89 0a                	mov    %ecx,(%edx)
  102f87:	8b 00                	mov    (%eax),%eax
  102f89:	99                   	cltd   
    }
}
  102f8a:	5d                   	pop    %ebp
  102f8b:	c3                   	ret    

00102f8c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102f8c:	55                   	push   %ebp
  102f8d:	89 e5                	mov    %esp,%ebp
  102f8f:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  102f92:	8d 45 14             	lea    0x14(%ebp),%eax
  102f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f9b:	50                   	push   %eax
  102f9c:	ff 75 10             	pushl  0x10(%ebp)
  102f9f:	ff 75 0c             	pushl  0xc(%ebp)
  102fa2:	ff 75 08             	pushl  0x8(%ebp)
  102fa5:	e8 06 00 00 00       	call   102fb0 <vprintfmt>
  102faa:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  102fad:	90                   	nop
  102fae:	c9                   	leave  
  102faf:	c3                   	ret    

00102fb0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102fb0:	55                   	push   %ebp
  102fb1:	89 e5                	mov    %esp,%ebp
  102fb3:	56                   	push   %esi
  102fb4:	53                   	push   %ebx
  102fb5:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fb8:	eb 17                	jmp    102fd1 <vprintfmt+0x21>
            if (ch == '\0') {
  102fba:	85 db                	test   %ebx,%ebx
  102fbc:	0f 84 8e 03 00 00    	je     103350 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  102fc2:	83 ec 08             	sub    $0x8,%esp
  102fc5:	ff 75 0c             	pushl  0xc(%ebp)
  102fc8:	53                   	push   %ebx
  102fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcc:	ff d0                	call   *%eax
  102fce:	83 c4 10             	add    $0x10,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd4:	8d 50 01             	lea    0x1(%eax),%edx
  102fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  102fda:	0f b6 00             	movzbl (%eax),%eax
  102fdd:	0f b6 d8             	movzbl %al,%ebx
  102fe0:	83 fb 25             	cmp    $0x25,%ebx
  102fe3:	75 d5                	jne    102fba <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102fe5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102fe9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102ff0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ff3:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ff6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ffd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103000:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103003:	8b 45 10             	mov    0x10(%ebp),%eax
  103006:	8d 50 01             	lea    0x1(%eax),%edx
  103009:	89 55 10             	mov    %edx,0x10(%ebp)
  10300c:	0f b6 00             	movzbl (%eax),%eax
  10300f:	0f b6 d8             	movzbl %al,%ebx
  103012:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103015:	83 f8 55             	cmp    $0x55,%eax
  103018:	0f 87 05 03 00 00    	ja     103323 <vprintfmt+0x373>
  10301e:	8b 04 85 d4 3b 10 00 	mov    0x103bd4(,%eax,4),%eax
  103025:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103027:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10302b:	eb d6                	jmp    103003 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10302d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103031:	eb d0                	jmp    103003 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103033:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10303a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10303d:	89 d0                	mov    %edx,%eax
  10303f:	c1 e0 02             	shl    $0x2,%eax
  103042:	01 d0                	add    %edx,%eax
  103044:	01 c0                	add    %eax,%eax
  103046:	01 d8                	add    %ebx,%eax
  103048:	83 e8 30             	sub    $0x30,%eax
  10304b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10304e:	8b 45 10             	mov    0x10(%ebp),%eax
  103051:	0f b6 00             	movzbl (%eax),%eax
  103054:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103057:	83 fb 2f             	cmp    $0x2f,%ebx
  10305a:	7e 39                	jle    103095 <vprintfmt+0xe5>
  10305c:	83 fb 39             	cmp    $0x39,%ebx
  10305f:	7f 34                	jg     103095 <vprintfmt+0xe5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103061:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  103065:	eb d3                	jmp    10303a <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103067:	8b 45 14             	mov    0x14(%ebp),%eax
  10306a:	8d 50 04             	lea    0x4(%eax),%edx
  10306d:	89 55 14             	mov    %edx,0x14(%ebp)
  103070:	8b 00                	mov    (%eax),%eax
  103072:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103075:	eb 1f                	jmp    103096 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  103077:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10307b:	79 86                	jns    103003 <vprintfmt+0x53>
                width = 0;
  10307d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103084:	e9 7a ff ff ff       	jmp    103003 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103089:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  103090:	e9 6e ff ff ff       	jmp    103003 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  103095:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103096:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10309a:	0f 89 63 ff ff ff    	jns    103003 <vprintfmt+0x53>
                width = precision, precision = -1;
  1030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1030ad:	e9 51 ff ff ff       	jmp    103003 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1030b2:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1030b6:	e9 48 ff ff ff       	jmp    103003 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1030bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1030be:	8d 50 04             	lea    0x4(%eax),%edx
  1030c1:	89 55 14             	mov    %edx,0x14(%ebp)
  1030c4:	8b 00                	mov    (%eax),%eax
  1030c6:	83 ec 08             	sub    $0x8,%esp
  1030c9:	ff 75 0c             	pushl  0xc(%ebp)
  1030cc:	50                   	push   %eax
  1030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d0:	ff d0                	call   *%eax
  1030d2:	83 c4 10             	add    $0x10,%esp
            break;
  1030d5:	e9 71 02 00 00       	jmp    10334b <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1030da:	8b 45 14             	mov    0x14(%ebp),%eax
  1030dd:	8d 50 04             	lea    0x4(%eax),%edx
  1030e0:	89 55 14             	mov    %edx,0x14(%ebp)
  1030e3:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1030e5:	85 db                	test   %ebx,%ebx
  1030e7:	79 02                	jns    1030eb <vprintfmt+0x13b>
                err = -err;
  1030e9:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1030eb:	83 fb 06             	cmp    $0x6,%ebx
  1030ee:	7f 0b                	jg     1030fb <vprintfmt+0x14b>
  1030f0:	8b 34 9d 94 3b 10 00 	mov    0x103b94(,%ebx,4),%esi
  1030f7:	85 f6                	test   %esi,%esi
  1030f9:	75 19                	jne    103114 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  1030fb:	53                   	push   %ebx
  1030fc:	68 c1 3b 10 00       	push   $0x103bc1
  103101:	ff 75 0c             	pushl  0xc(%ebp)
  103104:	ff 75 08             	pushl  0x8(%ebp)
  103107:	e8 80 fe ff ff       	call   102f8c <printfmt>
  10310c:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10310f:	e9 37 02 00 00       	jmp    10334b <vprintfmt+0x39b>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  103114:	56                   	push   %esi
  103115:	68 ca 3b 10 00       	push   $0x103bca
  10311a:	ff 75 0c             	pushl  0xc(%ebp)
  10311d:	ff 75 08             	pushl  0x8(%ebp)
  103120:	e8 67 fe ff ff       	call   102f8c <printfmt>
  103125:	83 c4 10             	add    $0x10,%esp
            }
            break;
  103128:	e9 1e 02 00 00       	jmp    10334b <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10312d:	8b 45 14             	mov    0x14(%ebp),%eax
  103130:	8d 50 04             	lea    0x4(%eax),%edx
  103133:	89 55 14             	mov    %edx,0x14(%ebp)
  103136:	8b 30                	mov    (%eax),%esi
  103138:	85 f6                	test   %esi,%esi
  10313a:	75 05                	jne    103141 <vprintfmt+0x191>
                p = "(null)";
  10313c:	be cd 3b 10 00       	mov    $0x103bcd,%esi
            }
            if (width > 0 && padc != '-') {
  103141:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103145:	7e 76                	jle    1031bd <vprintfmt+0x20d>
  103147:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10314b:	74 70                	je     1031bd <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10314d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103150:	83 ec 08             	sub    $0x8,%esp
  103153:	50                   	push   %eax
  103154:	56                   	push   %esi
  103155:	e8 17 f8 ff ff       	call   102971 <strnlen>
  10315a:	83 c4 10             	add    $0x10,%esp
  10315d:	89 c2                	mov    %eax,%edx
  10315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103162:	29 d0                	sub    %edx,%eax
  103164:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103167:	eb 17                	jmp    103180 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  103169:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10316d:	83 ec 08             	sub    $0x8,%esp
  103170:	ff 75 0c             	pushl  0xc(%ebp)
  103173:	50                   	push   %eax
  103174:	8b 45 08             	mov    0x8(%ebp),%eax
  103177:	ff d0                	call   *%eax
  103179:	83 c4 10             	add    $0x10,%esp
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10317c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103180:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103184:	7f e3                	jg     103169 <vprintfmt+0x1b9>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103186:	eb 35                	jmp    1031bd <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  103188:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10318c:	74 1c                	je     1031aa <vprintfmt+0x1fa>
  10318e:	83 fb 1f             	cmp    $0x1f,%ebx
  103191:	7e 05                	jle    103198 <vprintfmt+0x1e8>
  103193:	83 fb 7e             	cmp    $0x7e,%ebx
  103196:	7e 12                	jle    1031aa <vprintfmt+0x1fa>
                    putch('?', putdat);
  103198:	83 ec 08             	sub    $0x8,%esp
  10319b:	ff 75 0c             	pushl  0xc(%ebp)
  10319e:	6a 3f                	push   $0x3f
  1031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a3:	ff d0                	call   *%eax
  1031a5:	83 c4 10             	add    $0x10,%esp
  1031a8:	eb 0f                	jmp    1031b9 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1031aa:	83 ec 08             	sub    $0x8,%esp
  1031ad:	ff 75 0c             	pushl  0xc(%ebp)
  1031b0:	53                   	push   %ebx
  1031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b4:	ff d0                	call   *%eax
  1031b6:	83 c4 10             	add    $0x10,%esp
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1031b9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031bd:	89 f0                	mov    %esi,%eax
  1031bf:	8d 70 01             	lea    0x1(%eax),%esi
  1031c2:	0f b6 00             	movzbl (%eax),%eax
  1031c5:	0f be d8             	movsbl %al,%ebx
  1031c8:	85 db                	test   %ebx,%ebx
  1031ca:	74 26                	je     1031f2 <vprintfmt+0x242>
  1031cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031d0:	78 b6                	js     103188 <vprintfmt+0x1d8>
  1031d2:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1031d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1031da:	79 ac                	jns    103188 <vprintfmt+0x1d8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1031dc:	eb 14                	jmp    1031f2 <vprintfmt+0x242>
                putch(' ', putdat);
  1031de:	83 ec 08             	sub    $0x8,%esp
  1031e1:	ff 75 0c             	pushl  0xc(%ebp)
  1031e4:	6a 20                	push   $0x20
  1031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e9:	ff d0                	call   *%eax
  1031eb:	83 c4 10             	add    $0x10,%esp
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1031ee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1031f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031f6:	7f e6                	jg     1031de <vprintfmt+0x22e>
                putch(' ', putdat);
            }
            break;
  1031f8:	e9 4e 01 00 00       	jmp    10334b <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1031fd:	83 ec 08             	sub    $0x8,%esp
  103200:	ff 75 e0             	pushl  -0x20(%ebp)
  103203:	8d 45 14             	lea    0x14(%ebp),%eax
  103206:	50                   	push   %eax
  103207:	e8 39 fd ff ff       	call   102f45 <getint>
  10320c:	83 c4 10             	add    $0x10,%esp
  10320f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103212:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10321b:	85 d2                	test   %edx,%edx
  10321d:	79 23                	jns    103242 <vprintfmt+0x292>
                putch('-', putdat);
  10321f:	83 ec 08             	sub    $0x8,%esp
  103222:	ff 75 0c             	pushl  0xc(%ebp)
  103225:	6a 2d                	push   $0x2d
  103227:	8b 45 08             	mov    0x8(%ebp),%eax
  10322a:	ff d0                	call   *%eax
  10322c:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  10322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103232:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103235:	f7 d8                	neg    %eax
  103237:	83 d2 00             	adc    $0x0,%edx
  10323a:	f7 da                	neg    %edx
  10323c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10323f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103242:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103249:	e9 9f 00 00 00       	jmp    1032ed <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10324e:	83 ec 08             	sub    $0x8,%esp
  103251:	ff 75 e0             	pushl  -0x20(%ebp)
  103254:	8d 45 14             	lea    0x14(%ebp),%eax
  103257:	50                   	push   %eax
  103258:	e8 99 fc ff ff       	call   102ef6 <getuint>
  10325d:	83 c4 10             	add    $0x10,%esp
  103260:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103263:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103266:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10326d:	eb 7e                	jmp    1032ed <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10326f:	83 ec 08             	sub    $0x8,%esp
  103272:	ff 75 e0             	pushl  -0x20(%ebp)
  103275:	8d 45 14             	lea    0x14(%ebp),%eax
  103278:	50                   	push   %eax
  103279:	e8 78 fc ff ff       	call   102ef6 <getuint>
  10327e:	83 c4 10             	add    $0x10,%esp
  103281:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103284:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  103287:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10328e:	eb 5d                	jmp    1032ed <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  103290:	83 ec 08             	sub    $0x8,%esp
  103293:	ff 75 0c             	pushl  0xc(%ebp)
  103296:	6a 30                	push   $0x30
  103298:	8b 45 08             	mov    0x8(%ebp),%eax
  10329b:	ff d0                	call   *%eax
  10329d:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1032a0:	83 ec 08             	sub    $0x8,%esp
  1032a3:	ff 75 0c             	pushl  0xc(%ebp)
  1032a6:	6a 78                	push   $0x78
  1032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ab:	ff d0                	call   *%eax
  1032ad:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1032b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1032b3:	8d 50 04             	lea    0x4(%eax),%edx
  1032b6:	89 55 14             	mov    %edx,0x14(%ebp)
  1032b9:	8b 00                	mov    (%eax),%eax
  1032bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1032c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1032cc:	eb 1f                	jmp    1032ed <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1032ce:	83 ec 08             	sub    $0x8,%esp
  1032d1:	ff 75 e0             	pushl  -0x20(%ebp)
  1032d4:	8d 45 14             	lea    0x14(%ebp),%eax
  1032d7:	50                   	push   %eax
  1032d8:	e8 19 fc ff ff       	call   102ef6 <getuint>
  1032dd:	83 c4 10             	add    $0x10,%esp
  1032e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1032e6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1032ed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1032f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032f4:	83 ec 04             	sub    $0x4,%esp
  1032f7:	52                   	push   %edx
  1032f8:	ff 75 e8             	pushl  -0x18(%ebp)
  1032fb:	50                   	push   %eax
  1032fc:	ff 75 f4             	pushl  -0xc(%ebp)
  1032ff:	ff 75 f0             	pushl  -0x10(%ebp)
  103302:	ff 75 0c             	pushl  0xc(%ebp)
  103305:	ff 75 08             	pushl  0x8(%ebp)
  103308:	e8 f8 fa ff ff       	call   102e05 <printnum>
  10330d:	83 c4 20             	add    $0x20,%esp
            break;
  103310:	eb 39                	jmp    10334b <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103312:	83 ec 08             	sub    $0x8,%esp
  103315:	ff 75 0c             	pushl  0xc(%ebp)
  103318:	53                   	push   %ebx
  103319:	8b 45 08             	mov    0x8(%ebp),%eax
  10331c:	ff d0                	call   *%eax
  10331e:	83 c4 10             	add    $0x10,%esp
            break;
  103321:	eb 28                	jmp    10334b <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103323:	83 ec 08             	sub    $0x8,%esp
  103326:	ff 75 0c             	pushl  0xc(%ebp)
  103329:	6a 25                	push   $0x25
  10332b:	8b 45 08             	mov    0x8(%ebp),%eax
  10332e:	ff d0                	call   *%eax
  103330:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  103333:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103337:	eb 04                	jmp    10333d <vprintfmt+0x38d>
  103339:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10333d:	8b 45 10             	mov    0x10(%ebp),%eax
  103340:	83 e8 01             	sub    $0x1,%eax
  103343:	0f b6 00             	movzbl (%eax),%eax
  103346:	3c 25                	cmp    $0x25,%al
  103348:	75 ef                	jne    103339 <vprintfmt+0x389>
                /* do nothing */;
            break;
  10334a:	90                   	nop
        }
    }
  10334b:	e9 68 fc ff ff       	jmp    102fb8 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  103350:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103351:	8d 65 f8             	lea    -0x8(%ebp),%esp
  103354:	5b                   	pop    %ebx
  103355:	5e                   	pop    %esi
  103356:	5d                   	pop    %ebp
  103357:	c3                   	ret    

00103358 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103358:	55                   	push   %ebp
  103359:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10335b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335e:	8b 40 08             	mov    0x8(%eax),%eax
  103361:	8d 50 01             	lea    0x1(%eax),%edx
  103364:	8b 45 0c             	mov    0xc(%ebp),%eax
  103367:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10336a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336d:	8b 10                	mov    (%eax),%edx
  10336f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103372:	8b 40 04             	mov    0x4(%eax),%eax
  103375:	39 c2                	cmp    %eax,%edx
  103377:	73 12                	jae    10338b <sprintputch+0x33>
        *b->buf ++ = ch;
  103379:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337c:	8b 00                	mov    (%eax),%eax
  10337e:	8d 48 01             	lea    0x1(%eax),%ecx
  103381:	8b 55 0c             	mov    0xc(%ebp),%edx
  103384:	89 0a                	mov    %ecx,(%edx)
  103386:	8b 55 08             	mov    0x8(%ebp),%edx
  103389:	88 10                	mov    %dl,(%eax)
    }
}
  10338b:	90                   	nop
  10338c:	5d                   	pop    %ebp
  10338d:	c3                   	ret    

0010338e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10338e:	55                   	push   %ebp
  10338f:	89 e5                	mov    %esp,%ebp
  103391:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103394:	8d 45 14             	lea    0x14(%ebp),%eax
  103397:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10339a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10339d:	50                   	push   %eax
  10339e:	ff 75 10             	pushl  0x10(%ebp)
  1033a1:	ff 75 0c             	pushl  0xc(%ebp)
  1033a4:	ff 75 08             	pushl  0x8(%ebp)
  1033a7:	e8 0b 00 00 00       	call   1033b7 <vsnprintf>
  1033ac:	83 c4 10             	add    $0x10,%esp
  1033af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1033b5:	c9                   	leave  
  1033b6:	c3                   	ret    

001033b7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1033b7:	55                   	push   %ebp
  1033b8:	89 e5                	mov    %esp,%ebp
  1033ba:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1033bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cc:	01 d0                	add    %edx,%eax
  1033ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1033d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1033dc:	74 0a                	je     1033e8 <vsnprintf+0x31>
  1033de:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e4:	39 c2                	cmp    %eax,%edx
  1033e6:	76 07                	jbe    1033ef <vsnprintf+0x38>
        return -E_INVAL;
  1033e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1033ed:	eb 20                	jmp    10340f <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1033ef:	ff 75 14             	pushl  0x14(%ebp)
  1033f2:	ff 75 10             	pushl  0x10(%ebp)
  1033f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1033f8:	50                   	push   %eax
  1033f9:	68 58 33 10 00       	push   $0x103358
  1033fe:	e8 ad fb ff ff       	call   102fb0 <vprintfmt>
  103403:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  103406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103409:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10340f:	c9                   	leave  
  103410:	c3                   	ret    
