#include <stdio.h>
#include <setjmp.h>
#include <dos.h>
#include <conio.h>

#define INTR 0X08    /* The clock tick interrupt */

#ifdef __cplusplus
    #define __CPPARGS ...
#else
    #define __CPPARGS
#endif

jmp_buf  jmpc1;
jmp_buf  jmpc2;
jmp_buf  jmpmn;

unsigned int far *screen;

void swt(jmp_buf from,jmp_buf to) {
  if (0 == setjmp(from)) {
      longjmp(to,1);
  }//if
}//swt

int proc = 0;

void interrupt ( *oldhandler)(__CPPARGS);

void interrupt handler(__CPPARGS) {
     disable();
     oldhandler();
     if (proc == 0) {
	 proc = 1;
	 swt(jmpc1,jmpc2);
     } else {
	 if (proc == 1) {
	     proc = 0;
	     swt(jmpc2,jmpc1);
	 } else {
	 }//if
     }//if
     enable();
}//handler

void cor1(void) {
  long k;
  while (1) {

	 screen[0] = 0x0700 + '1';
	 for (k = 0; k < 500000; k++);

	 screen[0] = 0x0700 + ' ';
	 for (k = 0; k < 500000; k++);

//	 swt(jmpc1,jmpc2);
  }//while
}//cor1

void cor2(void) {
  int c;
  long k;
  while (1) {

	 screen[8] = 0x0700 + '2';
	 for (k = 0; k < 500000; k++);

	 screen[8] = 0x0700 + ' ';
	 for (k = 0; k < 500000; k++);

	 if (kbhit()) {
	     c = getch();
	     if (c == 27) {
		 disable();
		 setvect(INTR,oldhandler);
		 swt(jmpc2,jmpmn);
	     }//if
	 }//if

//	 swt(jmpc2,jmpc1);
  }//while
}//cor2

void main() {

  clrscr();

  screen = (unsigned int*)MK_FP(0xB800,0);

  int stack1[1000];
  int stack2[1000];

  struct SREGS segs;

  segread(&segs);

  jmpc1[0].j_sp   =  FP_OFF(stack1) + sizeof stack1 - 4;
  jmpc1[0].j_ss   =  FP_SEG(stack1);
  jmpc1[0].j_flag =  0x200;       //enable interrupt
  jmpc1[0].j_cs   =  FP_SEG(cor1);
  jmpc1[0].j_ip   =  FP_OFF(cor1);
  jmpc1[0].j_bp   =  jmpc1[0].j_sp;
  jmpc1[0].j_di   =  0;
  jmpc1[0].j_es   =  segs.es;
  jmpc1[0].j_si   =  0;
  jmpc1[0].j_ds   =  segs.ds;

  jmpc2[0].j_sp   =  FP_OFF(stack2) + sizeof stack2 - 4;
  jmpc2[0].j_ss   =  FP_SEG(stack2);
  jmpc2[0].j_flag =  0x200;
  jmpc2[0].j_cs   =  FP_SEG(cor2);
  jmpc2[0].j_ip   =  FP_OFF(cor2);
  jmpc2[0].j_bp   =  jmpc2[0].j_sp;
  jmpc2[0].j_di   =  0;
  jmpc2[0].j_es   =  segs.es;
  jmpc2[0].j_si   =  0;
  jmpc2[0].j_ds   =  segs.ds;

  oldhandler = getvect(INTR);
  disable();
  setvect(INTR,handler);
  swt(jmpmn,jmpc1);

}//main