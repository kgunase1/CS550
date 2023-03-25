
_schdtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	printf(1, "\n");
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 10             	sub    $0x10,%esp
    enable_sched_trace(1);
  11:	6a 01                	push   $0x1
  13:	e8 33 05 00 00       	call   54b <enable_sched_trace>

    /* ---------------- start: add your test code ------------------- */
    set_sched(1);
  18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1f:	e8 37 05 00 00       	call   55b <set_sched>
    example_test_code();
  24:	e8 a7 00 00 00       	call   d0 <example_test_code>


    /* ---------------- end: add your test code ------------------- */

    enable_sched_trace(0);
  29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  30:	e8 16 05 00 00       	call   54b <enable_sched_trace>
    
    exit();
  35:	e8 69 04 00 00       	call   4a3 <exit>
  3a:	66 90                	xchg   %ax,%ax
  3c:	66 90                	xchg   %ax,%ax
  3e:	66 90                	xchg   %ax,%ax

00000040 <do_parent>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 10             	sub    $0x10,%esp
    volatile int cnt = 0;
  46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    volatile int tmp = 0;
  4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(cnt < P_LOOP_CNT)
  54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  57:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  5c:	7f 20                	jg     7e <do_parent+0x3e>
  5e:	66 90                	xchg   %ax,%ax
        tmp += cnt;
  60:	8b 55 f8             	mov    -0x8(%ebp),%edx
  63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  66:	01 d0                	add    %edx,%eax
  68:	89 45 fc             	mov    %eax,-0x4(%ebp)
        cnt ++;
  6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  6e:	83 c0 01             	add    $0x1,%eax
  71:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while(cnt < P_LOOP_CNT)
  74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  77:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  7c:	7e e2                	jle    60 <do_parent+0x20>
}
  7e:	c9                   	leave  
  7f:	c3                   	ret    

00000080 <do_child>:
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	83 ec 18             	sub    $0x18,%esp
    volatile int cnt = 0;
  86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    volatile int tmp = 0;
  8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(cnt < C_LOOP_CNT)
  94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  97:	3d ff ff ff 02       	cmp    $0x2ffffff,%eax
  9c:	7f 20                	jg     be <do_child+0x3e>
  9e:	66 90                	xchg   %ax,%ax
        tmp += cnt;
  a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a6:	01 d0                	add    %edx,%eax
  a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cnt ++;
  ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ae:	83 c0 01             	add    $0x1,%eax
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(cnt < C_LOOP_CNT)
  b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b7:	3d ff ff ff 02       	cmp    $0x2ffffff,%eax
  bc:	7e e2                	jle    a0 <do_child+0x20>
    exit();
  be:	e8 e0 03 00 00       	call   4a3 <exit>
  c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000d0 <example_test_code>:
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	83 ec 18             	sub    $0x18,%esp
    pid = fork();
  d6:	e8 c0 03 00 00       	call   49b <fork>
    if (pid < 0)
  db:	85 c0                	test   %eax,%eax
  dd:	0f 88 21 01 00 00    	js     204 <example_test_code+0x134>
    else if (pid == 0) // child
  e3:	0f 84 50 01 00 00    	je     239 <example_test_code+0x169>
        printf(1, "fork() Parent!\n");
  e9:	83 ec 08             	sub    $0x8,%esp
  ec:	68 a7 09 00 00       	push   $0x9a7
  f1:	6a 01                	push   $0x1
  f3:	e8 28 05 00 00       	call   620 <printf>
        set_priority(getpid(), 3);
  f8:	e8 26 04 00 00       	call   523 <getpid>
  fd:	5a                   	pop    %edx
  fe:	59                   	pop    %ecx
  ff:	6a 03                	push   $0x3
 101:	50                   	push   %eax
 102:	e8 5c 04 00 00       	call   563 <set_priority>
    volatile int cnt = 0;
 107:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    while(cnt < P_LOOP_CNT)
 10e:	83 c4 10             	add    $0x10,%esp
    volatile int tmp = 0;
 111:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(cnt < P_LOOP_CNT)
 118:	8b 45 e8             	mov    -0x18(%ebp),%eax
 11b:	3d ff ff ff 00       	cmp    $0xffffff,%eax
 120:	7f 24                	jg     146 <example_test_code+0x76>
 122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        tmp += cnt;
 128:	8b 45 e8             	mov    -0x18(%ebp),%eax
 12b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 12e:	01 d0                	add    %edx,%eax
 130:	89 45 ec             	mov    %eax,-0x14(%ebp)
        cnt ++;
 133:	8b 45 e8             	mov    -0x18(%ebp),%eax
 136:	83 c0 01             	add    $0x1,%eax
 139:	89 45 e8             	mov    %eax,-0x18(%ebp)
    while(cnt < P_LOOP_CNT)
 13c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 13f:	3d ff ff ff 00       	cmp    $0xffffff,%eax
 144:	7e e2                	jle    128 <example_test_code+0x58>
        if (wait() < 0)
 146:	e8 60 03 00 00       	call   4ab <wait>
 14b:	85 c0                	test   %eax,%eax
 14d:	0f 88 7d 00 00 00    	js     1d0 <example_test_code+0x100>
    pid1 = fork();
 153:	e8 43 03 00 00       	call   49b <fork>
    if (pid1 < 0)
 158:	85 c0                	test   %eax,%eax
 15a:	0f 88 a4 00 00 00    	js     204 <example_test_code+0x134>
    else if (pid1 == 0) // child
 160:	0f 84 b1 00 00 00    	je     217 <example_test_code+0x147>
        printf(1, "fork() Parent!\n");
 166:	83 ec 08             	sub    $0x8,%esp
 169:	68 a7 09 00 00       	push   $0x9a7
 16e:	6a 01                	push   $0x1
 170:	e8 ab 04 00 00       	call   620 <printf>
    volatile int cnt = 0;
 175:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(cnt < P_LOOP_CNT)
 17c:	83 c4 10             	add    $0x10,%esp
    volatile int tmp = 0;
 17f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(cnt < P_LOOP_CNT)
 186:	8b 45 f0             	mov    -0x10(%ebp),%eax
 189:	3d ff ff ff 00       	cmp    $0xffffff,%eax
 18e:	7f 1e                	jg     1ae <example_test_code+0xde>
        tmp += cnt;
 190:	8b 45 f0             	mov    -0x10(%ebp),%eax
 193:	8b 55 f4             	mov    -0xc(%ebp),%edx
 196:	01 d0                	add    %edx,%eax
 198:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cnt ++;
 19b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 19e:	83 c0 01             	add    $0x1,%eax
 1a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while(cnt < P_LOOP_CNT)
 1a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a7:	3d ff ff ff 00       	cmp    $0xffffff,%eax
 1ac:	7e e2                	jle    190 <example_test_code+0xc0>
        if (wait() < 0)
 1ae:	e8 f8 02 00 00       	call   4ab <wait>
 1b3:	85 c0                	test   %eax,%eax
 1b5:	78 39                	js     1f0 <example_test_code+0x120>
	printf(1, "\n");
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	68 96 09 00 00       	push   $0x996
 1bf:	6a 01                	push   $0x1
 1c1:	e8 5a 04 00 00       	call   620 <printf>
}
 1c6:	83 c4 10             	add    $0x10,%esp
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop
            printf(1, "wait() failed!\n");
 1d0:	83 ec 08             	sub    $0x8,%esp
 1d3:	68 b7 09 00 00       	push   $0x9b7
 1d8:	6a 01                	push   $0x1
 1da:	e8 41 04 00 00       	call   620 <printf>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	e9 6c ff ff ff       	jmp    153 <example_test_code+0x83>
 1e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ee:	66 90                	xchg   %ax,%ax
            printf(1, "wait() failed!\n");
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	68 b7 09 00 00       	push   $0x9b7
 1f8:	6a 01                	push   $0x1
 1fa:	e8 21 04 00 00       	call   620 <printf>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	eb b3                	jmp    1b7 <example_test_code+0xe7>
        printf(1, "fork() failed!\n");
 204:	51                   	push   %ecx
 205:	51                   	push   %ecx
 206:	68 88 09 00 00       	push   $0x988
 20b:	6a 01                	push   $0x1
 20d:	e8 0e 04 00 00       	call   620 <printf>
        exit();
 212:	e8 8c 02 00 00       	call   4a3 <exit>
        set_priority(getpid(), 3);
 217:	e8 07 03 00 00       	call   523 <getpid>
 21c:	51                   	push   %ecx
 21d:	51                   	push   %ecx
 21e:	6a 03                	push   $0x3
 220:	50                   	push   %eax
 221:	e8 3d 03 00 00       	call   563 <set_priority>
        printf(1, "fork() Child!\n");
 226:	58                   	pop    %eax
 227:	5a                   	pop    %edx
 228:	68 98 09 00 00       	push   $0x998
 22d:	6a 01                	push   $0x1
 22f:	e8 ec 03 00 00       	call   620 <printf>
        do_child();
 234:	e8 47 fe ff ff       	call   80 <do_child>
        set_priority(getpid(), 2);
 239:	e8 e5 02 00 00       	call   523 <getpid>
 23e:	52                   	push   %edx
 23f:	52                   	push   %edx
 240:	6a 02                	push   $0x2
 242:	eb dc                	jmp    220 <example_test_code+0x150>
 244:	66 90                	xchg   %ax,%ax
 246:	66 90                	xchg   %ax,%ax
 248:	66 90                	xchg   %ax,%ax
 24a:	66 90                	xchg   %ax,%ax
 24c:	66 90                	xchg   %ax,%ax
 24e:	66 90                	xchg   %ax,%ax

00000250 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 250:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 251:	31 c0                	xor    %eax,%eax
{
 253:	89 e5                	mov    %esp,%ebp
 255:	53                   	push   %ebx
 256:	8b 4d 08             	mov    0x8(%ebp),%ecx
 259:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 260:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 264:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 267:	83 c0 01             	add    $0x1,%eax
 26a:	84 d2                	test   %dl,%dl
 26c:	75 f2                	jne    260 <strcpy+0x10>
    ;
  return os;
}
 26e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 271:	89 c8                	mov    %ecx,%eax
 273:	c9                   	leave  
 274:	c3                   	ret    
 275:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000280 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 4d 08             	mov    0x8(%ebp),%ecx
 287:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 28a:	0f b6 01             	movzbl (%ecx),%eax
 28d:	0f b6 1a             	movzbl (%edx),%ebx
 290:	84 c0                	test   %al,%al
 292:	75 1d                	jne    2b1 <strcmp+0x31>
 294:	eb 2a                	jmp    2c0 <strcmp+0x40>
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 2a4:	83 c1 01             	add    $0x1,%ecx
 2a7:	83 c2 01             	add    $0x1,%edx
  return (uchar)*p - (uchar)*q;
 2aa:	0f b6 1a             	movzbl (%edx),%ebx
  while(*p && *p == *q)
 2ad:	84 c0                	test   %al,%al
 2af:	74 0f                	je     2c0 <strcmp+0x40>
 2b1:	38 d8                	cmp    %bl,%al
 2b3:	74 eb                	je     2a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2b5:	29 d8                	sub    %ebx,%eax
}
 2b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    
 2bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 2c2:	29 d8                	sub    %ebx,%eax
}
 2c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <strlen>:

uint
strlen(char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2d6:	80 3a 00             	cmpb   $0x0,(%edx)
 2d9:	74 15                	je     2f0 <strlen+0x20>
 2db:	31 c0                	xor    %eax,%eax
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	83 c0 01             	add    $0x1,%eax
 2e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2e7:	89 c1                	mov    %eax,%ecx
 2e9:	75 f5                	jne    2e0 <strlen+0x10>
    ;
  return n;
}
 2eb:	89 c8                	mov    %ecx,%eax
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    
 2ef:	90                   	nop
  for(n = 0; s[n]; n++)
 2f0:	31 c9                	xor    %ecx,%ecx
}
 2f2:	5d                   	pop    %ebp
 2f3:	89 c8                	mov    %ecx,%eax
 2f5:	c3                   	ret    
 2f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fd:	8d 76 00             	lea    0x0(%esi),%esi

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 307:	8b 4d 10             	mov    0x10(%ebp),%ecx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	89 d7                	mov    %edx,%edi
 30f:	fc                   	cld    
 310:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 312:	8b 7d fc             	mov    -0x4(%ebp),%edi
 315:	89 d0                	mov    %edx,%eax
 317:	c9                   	leave  
 318:	c3                   	ret    
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <strchr>:

char*
strchr(const char *s, char c)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 32a:	0f b6 10             	movzbl (%eax),%edx
 32d:	84 d2                	test   %dl,%dl
 32f:	75 12                	jne    343 <strchr+0x23>
 331:	eb 1d                	jmp    350 <strchr+0x30>
 333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 337:	90                   	nop
 338:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 33c:	83 c0 01             	add    $0x1,%eax
 33f:	84 d2                	test   %dl,%dl
 341:	74 0d                	je     350 <strchr+0x30>
    if(*s == c)
 343:	38 d1                	cmp    %dl,%cl
 345:	75 f1                	jne    338 <strchr+0x18>
      return (char*)s;
  return 0;
}
 347:	5d                   	pop    %ebp
 348:	c3                   	ret    
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 350:	31 c0                	xor    %eax,%eax
}
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    
 354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop

00000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 365:	31 f6                	xor    %esi,%esi
{
 367:	53                   	push   %ebx
 368:	89 f3                	mov    %esi,%ebx
 36a:	83 ec 1c             	sub    $0x1c,%esp
 36d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 370:	eb 2f                	jmp    3a1 <gets+0x41>
 372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 378:	83 ec 04             	sub    $0x4,%esp
 37b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 37e:	6a 01                	push   $0x1
 380:	50                   	push   %eax
 381:	6a 00                	push   $0x0
 383:	e8 33 01 00 00       	call   4bb <read>
    if(cc < 1)
 388:	83 c4 10             	add    $0x10,%esp
 38b:	85 c0                	test   %eax,%eax
 38d:	7e 1c                	jle    3ab <gets+0x4b>
      break;
    buf[i++] = c;
 38f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    if(c == '\n' || c == '\r')
 393:	83 c7 01             	add    $0x1,%edi
    buf[i++] = c;
 396:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 399:	3c 0a                	cmp    $0xa,%al
 39b:	74 23                	je     3c0 <gets+0x60>
 39d:	3c 0d                	cmp    $0xd,%al
 39f:	74 1f                	je     3c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 3a1:	83 c3 01             	add    $0x1,%ebx
    buf[i++] = c;
 3a4:	89 fe                	mov    %edi,%esi
  for(i=0; i+1 < max; ){
 3a6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3a9:	7c cd                	jl     378 <gets+0x18>
 3ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b6:	5b                   	pop    %ebx
 3b7:	5e                   	pop    %esi
 3b8:	5f                   	pop    %edi
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop
  buf[i] = '\0';
 3c0:	8b 75 08             	mov    0x8(%ebp),%esi
}
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3c6:	01 de                	add    %ebx,%esi
 3c8:	89 f3                	mov    %esi,%ebx
 3ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 3cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5f                   	pop    %edi
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003e0 <stat>:

int
stat(char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 f1 00 00 00       	call   4e3 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	pushl  0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f4 00 00 00       	call   4fb <fstat>
  close(fd);
 407:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 40a:	89 c6                	mov    %eax,%esi
  close(fd);
 40c:	e8 ba 00 00 00       	call   4cb <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	8d 65 f8             	lea    -0x8(%ebp),%esp
 417:	89 f0                	mov    %esi,%eax
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 420:	be ff ff ff ff       	mov    $0xffffffff,%esi
 425:	eb ed                	jmp    414 <stat+0x34>
 427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42e:	66 90                	xchg   %ax,%ax

00000430 <atoi>:

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 02             	movsbl (%edx),%eax
 43a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 43d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 440:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 445:	77 1e                	ja     465 <atoi+0x35>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 450:	83 c2 01             	add    $0x1,%edx
 453:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 456:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 45a:	0f be 02             	movsbl (%edx),%eax
 45d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
  return n;
}
 465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 468:	89 c8                	mov    %ecx,%eax
 46a:	c9                   	leave  
 46b:	c3                   	ret    
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	8b 45 10             	mov    0x10(%ebp),%eax
 477:	8b 55 08             	mov    0x8(%ebp),%edx
 47a:	56                   	push   %esi
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 c0                	test   %eax,%eax
 480:	7e 13                	jle    495 <memmove+0x25>
 482:	01 d0                	add    %edx,%eax
  dst = vdst;
 484:	89 d7                	mov    %edx,%edi
 486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 490:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 491:	39 f8                	cmp    %edi,%eax
 493:	75 fb                	jne    490 <memmove+0x20>
  return vdst;
}
 495:	5e                   	pop    %esi
 496:	89 d0                	mov    %edx,%eax
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret    

0000049b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49b:	b8 01 00 00 00       	mov    $0x1,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <exit>:
SYSCALL(exit)
 4a3:	b8 02 00 00 00       	mov    $0x2,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <wait>:
SYSCALL(wait)
 4ab:	b8 03 00 00 00       	mov    $0x3,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <pipe>:
SYSCALL(pipe)
 4b3:	b8 04 00 00 00       	mov    $0x4,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <read>:
SYSCALL(read)
 4bb:	b8 05 00 00 00       	mov    $0x5,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <write>:
SYSCALL(write)
 4c3:	b8 10 00 00 00       	mov    $0x10,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <close>:
SYSCALL(close)
 4cb:	b8 15 00 00 00       	mov    $0x15,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <kill>:
SYSCALL(kill)
 4d3:	b8 06 00 00 00       	mov    $0x6,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <exec>:
SYSCALL(exec)
 4db:	b8 07 00 00 00       	mov    $0x7,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <open>:
SYSCALL(open)
 4e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <mknod>:
SYSCALL(mknod)
 4eb:	b8 11 00 00 00       	mov    $0x11,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <unlink>:
SYSCALL(unlink)
 4f3:	b8 12 00 00 00       	mov    $0x12,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <fstat>:
SYSCALL(fstat)
 4fb:	b8 08 00 00 00       	mov    $0x8,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <link>:
SYSCALL(link)
 503:	b8 13 00 00 00       	mov    $0x13,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <mkdir>:
SYSCALL(mkdir)
 50b:	b8 14 00 00 00       	mov    $0x14,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <chdir>:
SYSCALL(chdir)
 513:	b8 09 00 00 00       	mov    $0x9,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <dup>:
SYSCALL(dup)
 51b:	b8 0a 00 00 00       	mov    $0xa,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <getpid>:
SYSCALL(getpid)
 523:	b8 0b 00 00 00       	mov    $0xb,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <sbrk>:
SYSCALL(sbrk)
 52b:	b8 0c 00 00 00       	mov    $0xc,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <sleep>:
SYSCALL(sleep)
 533:	b8 0d 00 00 00       	mov    $0xd,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <uptime>:
SYSCALL(uptime)
 53b:	b8 0e 00 00 00       	mov    $0xe,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <shutdown>:
SYSCALL(shutdown)
 543:	b8 16 00 00 00       	mov    $0x16,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <enable_sched_trace>:
SYSCALL(enable_sched_trace)
 54b:	b8 17 00 00 00       	mov    $0x17,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <fork_winner>:
SYSCALL(fork_winner)
 553:	b8 18 00 00 00       	mov    $0x18,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <set_sched>:
SYSCALL(set_sched)
 55b:	b8 19 00 00 00       	mov    $0x19,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <set_priority>:
SYSCALL(set_priority)
 563:	b8 1a 00 00 00       	mov    $0x1a,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    
 56b:	66 90                	xchg   %ax,%ax
 56d:	66 90                	xchg   %ax,%ax
 56f:	90                   	nop

00000570 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	56                   	push   %esi
 575:	53                   	push   %ebx
 576:	83 ec 3c             	sub    $0x3c,%esp
 579:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 57c:	89 d1                	mov    %edx,%ecx
{
 57e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 581:	85 d2                	test   %edx,%edx
 583:	0f 89 7f 00 00 00    	jns    608 <printint+0x98>
 589:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 58d:	74 79                	je     608 <printint+0x98>
    neg = 1;
 58f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 596:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 598:	31 db                	xor    %ebx,%ebx
 59a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 59d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5a0:	89 c8                	mov    %ecx,%eax
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	89 cf                	mov    %ecx,%edi
 5a6:	f7 75 c4             	divl   -0x3c(%ebp)
 5a9:	0f b6 92 d0 09 00 00 	movzbl 0x9d0(%edx),%edx
 5b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5b3:	89 d8                	mov    %ebx,%eax
 5b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5c1:	76 dd                	jbe    5a0 <printint+0x30>
  if(neg)
 5c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5c6:	85 c9                	test   %ecx,%ecx
 5c8:	74 0c                	je     5d6 <printint+0x66>
    buf[i++] = '-';
 5ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5dd:	eb 07                	jmp    5e6 <printint+0x76>
 5df:	90                   	nop
    putc(fd, buf[i]);
 5e0:	0f b6 13             	movzbl (%ebx),%edx
 5e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5e6:	83 ec 04             	sub    $0x4,%esp
 5e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5ec:	6a 01                	push   $0x1
 5ee:	56                   	push   %esi
 5ef:	57                   	push   %edi
 5f0:	e8 ce fe ff ff       	call   4c3 <write>
  while(--i >= 0)
 5f5:	83 c4 10             	add    $0x10,%esp
 5f8:	39 de                	cmp    %ebx,%esi
 5fa:	75 e4                	jne    5e0 <printint+0x70>
}
 5fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ff:	5b                   	pop    %ebx
 600:	5e                   	pop    %esi
 601:	5f                   	pop    %edi
 602:	5d                   	pop    %ebp
 603:	c3                   	ret    
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 608:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 60f:	eb 87                	jmp    598 <printint+0x28>
 611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop

00000620 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 629:	8b 75 0c             	mov    0xc(%ebp),%esi
 62c:	0f b6 1e             	movzbl (%esi),%ebx
 62f:	84 db                	test   %bl,%bl
 631:	0f 84 b8 00 00 00    	je     6ef <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 637:	8d 45 10             	lea    0x10(%ebp),%eax
 63a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 63d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 640:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 642:	89 45 d0             	mov    %eax,-0x30(%ebp)
 645:	eb 37                	jmp    67e <printf+0x5e>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax
 650:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 653:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	74 17                	je     674 <printf+0x54>
  write(fd, &c, 1);
 65d:	83 ec 04             	sub    $0x4,%esp
 660:	88 5d e7             	mov    %bl,-0x19(%ebp)
 663:	6a 01                	push   $0x1
 665:	57                   	push   %edi
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 55 fe ff ff       	call   4c3 <write>
 66e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 671:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 674:	0f b6 1e             	movzbl (%esi),%ebx
 677:	83 c6 01             	add    $0x1,%esi
 67a:	84 db                	test   %bl,%bl
 67c:	74 71                	je     6ef <printf+0xcf>
    c = fmt[i] & 0xff;
 67e:	0f be cb             	movsbl %bl,%ecx
 681:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 684:	85 d2                	test   %edx,%edx
 686:	74 c8                	je     650 <printf+0x30>
      }
    } else if(state == '%'){
 688:	83 fa 25             	cmp    $0x25,%edx
 68b:	75 e7                	jne    674 <printf+0x54>
      if(c == 'd'){
 68d:	83 f8 64             	cmp    $0x64,%eax
 690:	0f 84 9a 00 00 00    	je     730 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 696:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 69c:	83 f9 70             	cmp    $0x70,%ecx
 69f:	74 5f                	je     700 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6a1:	83 f8 73             	cmp    $0x73,%eax
 6a4:	0f 84 d6 00 00 00    	je     780 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6aa:	83 f8 63             	cmp    $0x63,%eax
 6ad:	0f 84 8d 00 00 00    	je     740 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6b3:	83 f8 25             	cmp    $0x25,%eax
 6b6:	0f 84 b4 00 00 00    	je     770 <printf+0x150>
  write(fd, &c, 1);
 6bc:	83 ec 04             	sub    $0x4,%esp
 6bf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6c3:	6a 01                	push   $0x1
 6c5:	57                   	push   %edi
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 f5 fd ff ff       	call   4c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6ce:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6d1:	83 c4 0c             	add    $0xc,%esp
 6d4:	6a 01                	push   $0x1
  for(i = 0; fmt[i]; i++){
 6d6:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6d9:	57                   	push   %edi
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 e1 fd ff ff       	call   4c3 <write>
  for(i = 0; fmt[i]; i++){
 6e2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6e6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6eb:	84 db                	test   %bl,%bl
 6ed:	75 8f                	jne    67e <printf+0x5e>
    }
  }
}
 6ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f2:	5b                   	pop    %ebx
 6f3:	5e                   	pop    %esi
 6f4:	5f                   	pop    %edi
 6f5:	5d                   	pop    %ebp
 6f6:	c3                   	ret    
 6f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 10 00 00 00       	mov    $0x10,%ecx
 708:	6a 00                	push   $0x0
 70a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 70d:	8b 45 08             	mov    0x8(%ebp),%eax
 710:	8b 13                	mov    (%ebx),%edx
 712:	e8 59 fe ff ff       	call   570 <printint>
        ap++;
 717:	89 d8                	mov    %ebx,%eax
 719:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71c:	31 d2                	xor    %edx,%edx
        ap++;
 71e:	83 c0 04             	add    $0x4,%eax
 721:	89 45 d0             	mov    %eax,-0x30(%ebp)
 724:	e9 4b ff ff ff       	jmp    674 <printf+0x54>
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 730:	83 ec 0c             	sub    $0xc,%esp
 733:	b9 0a 00 00 00       	mov    $0xa,%ecx
 738:	6a 01                	push   $0x1
 73a:	eb ce                	jmp    70a <printf+0xea>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 740:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 746:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 748:	6a 01                	push   $0x1
        ap++;
 74a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 74d:	57                   	push   %edi
 74e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 751:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 754:	e8 6a fd ff ff       	call   4c3 <write>
        ap++;
 759:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 75c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 75f:	31 d2                	xor    %edx,%edx
 761:	e9 0e ff ff ff       	jmp    674 <printf+0x54>
 766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 770:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 773:	83 ec 04             	sub    $0x4,%esp
 776:	e9 59 ff ff ff       	jmp    6d4 <printf+0xb4>
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
        s = (char*)*ap;
 780:	8b 45 d0             	mov    -0x30(%ebp),%eax
 783:	8b 18                	mov    (%eax),%ebx
        ap++;
 785:	83 c0 04             	add    $0x4,%eax
 788:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 78b:	85 db                	test   %ebx,%ebx
 78d:	74 17                	je     7a6 <printf+0x186>
        while(*s != 0){
 78f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 792:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 794:	84 c0                	test   %al,%al
 796:	0f 84 d8 fe ff ff    	je     674 <printf+0x54>
 79c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 79f:	89 de                	mov    %ebx,%esi
 7a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a4:	eb 1a                	jmp    7c0 <printf+0x1a0>
          s = "(null)";
 7a6:	bb c7 09 00 00       	mov    $0x9c7,%ebx
        while(*s != 0){
 7ab:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ae:	b8 28 00 00 00       	mov    $0x28,%eax
 7b3:	89 de                	mov    %ebx,%esi
 7b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7c3:	83 c6 01             	add    $0x1,%esi
 7c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7c9:	6a 01                	push   $0x1
 7cb:	57                   	push   %edi
 7cc:	53                   	push   %ebx
 7cd:	e8 f1 fc ff ff       	call   4c3 <write>
        while(*s != 0){
 7d2:	0f b6 06             	movzbl (%esi),%eax
 7d5:	83 c4 10             	add    $0x10,%esp
 7d8:	84 c0                	test   %al,%al
 7da:	75 e4                	jne    7c0 <printf+0x1a0>
      state = 0;
 7dc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 7df:	31 d2                	xor    %edx,%edx
 7e1:	e9 8e fe ff ff       	jmp    674 <printf+0x54>
 7e6:	66 90                	xchg   %ax,%ax
 7e8:	66 90                	xchg   %ax,%ax
 7ea:	66 90                	xchg   %ax,%ax
 7ec:	66 90                	xchg   %ax,%ax
 7ee:	66 90                	xchg   %ax,%ax

000007f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	a1 d4 0c 00 00       	mov    0xcd4,%eax
{
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	57                   	push   %edi
 7f9:	56                   	push   %esi
 7fa:	53                   	push   %ebx
 7fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 808:	89 c2                	mov    %eax,%edx
 80a:	8b 00                	mov    (%eax),%eax
 80c:	39 ca                	cmp    %ecx,%edx
 80e:	73 30                	jae    840 <free+0x50>
 810:	39 c1                	cmp    %eax,%ecx
 812:	72 04                	jb     818 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 814:	39 c2                	cmp    %eax,%edx
 816:	72 f0                	jb     808 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 f8                	cmp    %edi,%eax
 820:	74 30                	je     852 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 822:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 825:	8b 42 04             	mov    0x4(%edx),%eax
 828:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 82b:	39 f1                	cmp    %esi,%ecx
 82d:	74 3a                	je     869 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 82f:	89 0a                	mov    %ecx,(%edx)
  freep = p;
}
 831:	5b                   	pop    %ebx
  freep = p;
 832:	89 15 d4 0c 00 00    	mov    %edx,0xcd4
}
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret    
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	39 c2                	cmp    %eax,%edx
 842:	72 c4                	jb     808 <free+0x18>
 844:	39 c1                	cmp    %eax,%ecx
 846:	73 c0                	jae    808 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 848:	8b 73 fc             	mov    -0x4(%ebx),%esi
 84b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 84e:	39 f8                	cmp    %edi,%eax
 850:	75 d0                	jne    822 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 852:	03 70 04             	add    0x4(%eax),%esi
 855:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	8b 02                	mov    (%edx),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 85f:	8b 42 04             	mov    0x4(%edx),%eax
 862:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 865:	39 f1                	cmp    %esi,%ecx
 867:	75 c6                	jne    82f <free+0x3f>
    p->s.size += bp->s.size;
 869:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 86c:	89 15 d4 0c 00 00    	mov    %edx,0xcd4
    p->s.size += bp->s.size;
 872:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 875:	8b 43 f8             	mov    -0x8(%ebx),%eax
 878:	89 02                	mov    %eax,(%edx)
}
 87a:	5b                   	pop    %ebx
 87b:	5e                   	pop    %esi
 87c:	5f                   	pop    %edi
 87d:	5d                   	pop    %ebp
 87e:	c3                   	ret    
 87f:	90                   	nop

00000880 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	57                   	push   %edi
 884:	56                   	push   %esi
 885:	53                   	push   %ebx
 886:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 889:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 88c:	8b 3d d4 0c 00 00    	mov    0xcd4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	8d 70 07             	lea    0x7(%eax),%esi
 895:	c1 ee 03             	shr    $0x3,%esi
 898:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 89b:	85 ff                	test   %edi,%edi
 89d:	0f 84 ad 00 00 00    	je     950 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a3:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 8a5:	8b 48 04             	mov    0x4(%eax),%ecx
 8a8:	39 f1                	cmp    %esi,%ecx
 8aa:	73 71                	jae    91d <malloc+0x9d>
 8ac:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8b7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ba:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8c1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8c4:	eb 1b                	jmp    8e1 <malloc+0x61>
 8c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8d2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8d5:	39 f1                	cmp    %esi,%ecx
 8d7:	73 4f                	jae    928 <malloc+0xa8>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d9:	8b 3d d4 0c 00 00    	mov    0xcd4,%edi
 8df:	89 d0                	mov    %edx,%eax
 8e1:	39 c7                	cmp    %eax,%edi
 8e3:	75 eb                	jne    8d0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8e5:	83 ec 0c             	sub    $0xc,%esp
 8e8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8eb:	e8 3b fc ff ff       	call   52b <sbrk>
  if(p == (char*)-1)
 8f0:	83 c4 10             	add    $0x10,%esp
 8f3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8f6:	74 1b                	je     913 <malloc+0x93>
  hp->s.size = nu;
 8f8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	83 c0 08             	add    $0x8,%eax
 901:	50                   	push   %eax
 902:	e8 e9 fe ff ff       	call   7f0 <free>
  return freep;
 907:	a1 d4 0c 00 00       	mov    0xcd4,%eax
      if((p = morecore(nunits)) == 0)
 90c:	83 c4 10             	add    $0x10,%esp
 90f:	85 c0                	test   %eax,%eax
 911:	75 bd                	jne    8d0 <malloc+0x50>
        return 0;
  }
}
 913:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 916:	31 c0                	xor    %eax,%eax
}
 918:	5b                   	pop    %ebx
 919:	5e                   	pop    %esi
 91a:	5f                   	pop    %edi
 91b:	5d                   	pop    %ebp
 91c:	c3                   	ret    
    if(p->s.size >= nunits){
 91d:	89 c2                	mov    %eax,%edx
 91f:	89 f8                	mov    %edi,%eax
 921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 928:	39 ce                	cmp    %ecx,%esi
 92a:	74 54                	je     980 <malloc+0x100>
        p->s.size -= nunits;
 92c:	29 f1                	sub    %esi,%ecx
 92e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 931:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 934:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 937:	a3 d4 0c 00 00       	mov    %eax,0xcd4
}
 93c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 93f:	8d 42 08             	lea    0x8(%edx),%eax
}
 942:	5b                   	pop    %ebx
 943:	5e                   	pop    %esi
 944:	5f                   	pop    %edi
 945:	5d                   	pop    %ebp
 946:	c3                   	ret    
 947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 94e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 950:	c7 05 d4 0c 00 00 d8 	movl   $0xcd8,0xcd4
 957:	0c 00 00 
    base.s.size = 0;
 95a:	bf d8 0c 00 00       	mov    $0xcd8,%edi
    base.s.ptr = freep = prevp = &base;
 95f:	c7 05 d8 0c 00 00 d8 	movl   $0xcd8,0xcd8
 966:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 969:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 96b:	c7 05 dc 0c 00 00 00 	movl   $0x0,0xcdc
 972:	00 00 00 
    if(p->s.size >= nunits){
 975:	e9 32 ff ff ff       	jmp    8ac <malloc+0x2c>
 97a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 980:	8b 0a                	mov    (%edx),%ecx
 982:	89 08                	mov    %ecx,(%eax)
 984:	eb b1                	jmp    937 <malloc+0xb7>
