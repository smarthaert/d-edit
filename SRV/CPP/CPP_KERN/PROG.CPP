#include <conio.h>
#include <alloc.h>
#include <dos.h>
#include "kern.h"

unsigned int far *screen;

const TIK = 10;

//---------------------------------------------------------------------------
void cor1(void) {
  long k;
  int count = 0;
  while (1) {
//	 screen[0] = 0x0700 + '1';
	 kernelprint(1,1,"1");
//	 for (k = 0; k < 500000; k++);
	 kerneldelay(TIK);
//	 screen[0] = 0x0700 + ' ';
	 kernelprint(1,1," ");
//	 for (k = 0; k < 500000; k++);
	 kerneldelay(TIK);
	 count++;
	 if (count > 10) {
	     kernelkill();
	 }//if
  }//while
}//cor1
//---------------------------------------------------------------------------
void cor2(void) {
  long k;
  int count = 0;
  while (1) {
//	 screen[4] = 0x0700 + '2';
	 kernelprint(4,1,"2");
//	 for (k = 0; k < 500000; k++);
	 kerneldelay(TIK);
//	 screen[4] = 0x0700 + ' ';
	 kernelprint(4,1," ");
//	 for (k = 0; k < 500000; k++);
	 kerneldelay(TIK);
	 count++;
	 if (count > 20) {
	     kernelkill();
	 }//if
  }//while
}//cor2
//---------------------------------------------------------------------------
void cor3(void) {
  long k;
  int  c;
  while (1) {
	 screen[8] = 0x0700 + '3';
//	 kernelprint(7,1,"3");
	 for (k = 0; k < 500000; k++);
	 screen[8] = 0x0700 + ' ';
//	 kernelprint(7,1," ");
	 for (k = 0; k < 500000; k++);
	 if ( kbhit() ) {
	      c = getch();
	      if ( c == 27 ) {
		   kernelstop();
	      }//if
	 }//if

  }//while
}//cor3
//---------------------------------------------------------------------------
int main() {

    TProcess* proc1;
    TProcess* proc2;
    TProcess* proc3;

    clrscr();

    screen = (unsigned int *)MK_FP(0xB800,0);

    cprintf("\n\nheapsize = %lu\n", farcoreleft());

    kernelcreate();

    proc1 = processcreate(cor1);
    proc2 = processcreate(cor2);
    proc3 = processcreate(cor3);

    kernelstart();

    kerneldelete();

    gotoxy(1,4);
    cprintf("heapsize = %lu\n", farcoreleft());

    getch();

    return 0;
}//main