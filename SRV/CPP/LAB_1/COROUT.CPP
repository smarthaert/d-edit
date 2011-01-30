#include <stdio.h>
#include <setjmp.h>
#include <dos.h>
#include <conio.h>

jmp_buf  jmpc1;
jmp_buf  jmpc2;
jmp_buf  jmpmn;

void swt(jmp_buf from,jmp_buf to) {
  if (0 == setjmp(from)) {
      longjmp(to,1);
  }//if
}//swt

void cor1(void) {
  while (1) {

	 gotoxy(1,1);
	 printf("1");
	 delay(100);

	 gotoxy(1,1);
	 printf(" ");
	 delay(100);

	 swt(jmpc1,jmpc2);
  }//while
}//cor1

void cor2(void) {
  int c;
  while (1) {

	 gotoxy(5,1);
	 printf("2");
	 delay(100);

	 gotoxy(5,1);
	 printf(" ");
	 delay(100);

	 if (kbhit()) {
	     c = getch();
	     if (c == 27) {
		 swt(jmpc2,jmpmn);
	     }//if
	 }//if

	 swt(jmpc2,jmpc1);
  }//while
}//cor2

void main() {

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

  swt(jmpmn,jmpc1);

}//main






