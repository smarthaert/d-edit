#include "kern.h"
#include <dos.h>
#include <conio.h>

#define INTR 0X08

#ifdef __cplusplus
    #define __CPPARGS ...
#else
    #define __CPPARGS
#endif

void interrupt handler(__CPPARGS);

void interrupt ( *oldhandler)(__CPPARGS);

tkernel *kernel;

//tkernel kernel;

//---------------------------------------------------------------------------
tkernel::tkernel() {
	count = 0;
	ReadyList    = new TNSCollection(50,10);
	KillList     = new TNSCollection(50,10);
	DelayList    = new TNSCollection(50,10);
	mainp        = new TMain;
	Semaphore    = new TSemaphore;
}//tkernel
//---------------------------------------------------------------------------
tkernel::~tkernel() {
	delete Semaphore;
	delete mainp;
	delete cur;
	DelayList->freeAll();
	delete DelayList;
	KillList->freeAll();
	delete KillList;
	ReadyList->freeAll();
	delete ReadyList;
}//~tkernel
//---------------------------------------------------------------------------
TProcess *tkernel::create(void *p) {
	  TProcess *proc;
	  disable();
	  proc = new TProcess(p);
	  ReadyList->insert(proc);
	  enable();
	  return proc;
}//tkernel::create
//---------------------------------------------------------------------------
void tkernel::kill() {
	  disable();
	  KillList->insert(cur);
	  next();
	  enable();
}//tkernel::kill
//---------------------------------------------------------------------------
void tkernel::swt(jmp_buf from,jmp_buf to) {
	 if (0 == setjmp(from)) {
	     longjmp(to,1);
	 }//if
}//tkernel::swt
//---------------------------------------------------------------------------
void tkernel::start() {
	 cur = (TProcess *)ReadyList->at(0);
	 ReadyList->remove(cur);
	 oldhandler = getvect(INTR);
	 disable();
	 setvect(INTR,handler);
	 swt(mainp->ts,cur->ts);
	 enable();
}//tkernel::start
//---------------------------------------------------------------------------
void tkernel::stop() {
	 disable();
	 setvect(INTR,oldhandler);
	 swt(cur->ts,mainp->ts);
}//tkernel::stop
//---------------------------------------------------------------------------
void tkernel::next() {
	 TProcess *old;
	 old = cur;
	 cur = (TProcess * )ReadyList->at(0);
	 ReadyList->remove(cur);
	 swt(old->ts,cur->ts);
}//tkernel::next
//---------------------------------------------------------------------------
void tkernel::transfer() {
	 ReadyList->insert(cur);
	 next();
}//tkernel::transfer
//---------------------------------------------------------------------------
void tkernel::lock_printf(int x,int y,char *str) {
	 Semaphore->P();
	 gotoxy(x,y);
	 cprintf("%s",str);
	 Semaphore->V();
}//tkernel::lock_printf
//---------------------------------------------------------------------------
void tkernel::delay(unsigned long tik) {
	 disable();
	 DelayList->insert(cur);
	 cur->t_act = count + tik;
	 next();
	 enable();
}//tkernel::delay
//---------------------------------------------------------------------------
Boolean  Test(void *v, void *c) {
	 TProcess *p;
	 unsigned long *l;
	 p = (TProcess *)v;
	 l = (unsigned long *)c;
	 if (p->t_act <= *l) {
	     return True;
	 }//if
	 return False;
}//Test
//---------------------------------------------------------------------------
void tkernel::resume() {
     TProcess *p;
     while ((p = (TProcess *)DelayList->firstThat(&Test,&count))!= 0) {
	    DelayList->remove(p);
	    ReadyList->insert(p);
	    p->t_act = 0;
     }//while
}//tkernel::resume
//---------------------------------------------------------------------------
void interrupt handler(__CPPARGS) {
	 disable();
	 oldhandler();
	 kernel->count++;
	 kernel->resume();
	 kernel->KillList->freeAll();
//	 kernel.count++;
	 kernel->transfer();
//	 kernel.transfer();
	 enable();
}//handler
//---------------------------------------------------------------------------
void kernelcreate() {
	 kernel = new tkernel;
}//kernelcreate
//---------------------------------------------------------------------------
void kerneldelete() {
	 delete kernel;
}//kerneldelete
//---------------------------------------------------------------------------
void kernelstart() {
	 kernel->start();
//	 kernel.start();
}//kernelstart
//---------------------------------------------------------------------------
void kernelstop() {
	 kernel->stop();
//	 kernel.stop();
}//kernelstop
//---------------------------------------------------------------------------
void kernelprint(int x,int y,char *str) {
	 kernel->lock_printf(x,y,str);
}//kernelprint
//---------------------------------------------------------------------------
void kerneldelay(unsigned long tik) {
	 kernel->delay(tik);
}//kerneldelay
//---------------------------------------------------------------------------
TProcess *processcreate(void *p) {
	 return kernel->create(p);
//	 return kernel.create(p);
}//processcreate
//---------------------------------------------------------------------------
void kernelkill() {
	 kernel->kill();
}//kernelkill
//---------------------------------------------------------------------------
TSemaphore::TSemaphore() {
	 count = 1;
	 List = new TNSCollection( 50, 10 );
}//TSemaphore::TSemaphore
//---------------------------------------------------------------------------
TSemaphore::~TSemaphore() {
	 List->freeAll();
	 delete List;
}//TSemaphore::~TSemaphore
//---------------------------------------------------------------------------
void TSemaphore::P() {
	   disable();
	   count--;
	   if ( count < 0 ) {
		List->insert(kernel->cur);
		kernel->next();
	   }//if
	   enable();
}//TSemaphore::P
//---------------------------------------------------------------------------
void TSemaphore::V() {
	   TProcess *old;
	   disable();
	   count++;
	   if ( count <= 0 ) {
		kernel->ReadyList->insert(kernel->cur);

		old = kernel->cur;
		kernel->cur = (TProcess *)List->at(0);
		List->remove(kernel->cur);
		kernel->swt(old->ts,kernel->cur->ts);

	   }//if
	   enable();
}//TSemaphore::V
//---------------------------------------------------------------------------
