#include <setjmp.h>
#include <dos.h>

class TMain {
public:
      jmp_buf ts;
};//TMain

class TProcess : public TMain {
public:
      int stack[1000];
      unsigned long t_act;
      TProcess(void *p) {
	  struct SREGS segs;
	  segread(&segs);
	  ts[0].j_sp   =  FP_OFF(stack) + sizeof stack;
	  ts[0].j_ss   =  FP_SEG(stack);
	  ts[0].j_flag =  0x200;
	  ts[0].j_cs   =  FP_SEG(p);
	  ts[0].j_ip   =  FP_OFF(p);
	  ts[0].j_bp   =  ts[0].j_sp;
	  ts[0].j_di   =  0;
	  ts[0].j_es   =  segs.es;
	  ts[0].j_si   =  0;
	  ts[0].j_ds   =  segs.ds;
      }//TProcess
};//TProcess

