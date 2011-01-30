#include <tv.h>
#include "proc.h"
#include "sema.h"

void kernelcreate();
void kerneldelete();
void kernelstart();
void kernelstop();
void kernelprint(int x,int y,char *str);
void kerneldelay(unsigned long tik);
void kernelkill();
TProcess *processcreate(void *);


class tkernel {
public :
      TSemaphore    *Semaphore;
      TNSCollection *ReadyList;
      TNSCollection *KillList;
      TNSCollection *DelayList;
      TProcess *cur;
      TMain    *mainp;
      unsigned long count;

      tkernel();
      ~tkernel();
      TProcess *create(void *);
      void kill();
      void start();
      void stop();
      void transfer();
      void swt(jmp_buf from,jmp_buf to);
      void next();
      void lock_printf(int x,int y,char *str);
      void delay(unsigned long tik);
      void resume();
};
