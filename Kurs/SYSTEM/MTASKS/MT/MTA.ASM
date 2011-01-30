;**************************************************************************;
;*                            M T A . A S M                               *;
;*------------------------------------------------------------------------*;
;*    task        : Assembler module for the MT multitasking unit         *;
;*------------------------------------------------------------------------*;
;*    Author         : MICHAEL TISCHER                                    *;
;*    developed on   : 06/12/1989                                         *;
;*    last update    : 03/08/1990                                         *;
;*------------------------------------------------------------------------*;
;*    assemble       : TASM /MX MTA                                       *;
;*                     ... link with the MT unit                          *;
;**************************************************************************;

;== Constants ==============================================================

STACK_LEN      equ 300                ;Length of the internal stack in words

TIMER_0_CTRL   equ 43h                ;Timer #0, control register
TIMER_0_DATA   equ 40h                ;Timer #0, data register
TIMER_0_LOAD   equ 36h                ;Load command

INTR_EOI       equ 20h                ;EOI signal for interrupt controller
INTR_PORT      equ 20h                ;Port of the interrupt controller

;== Macros =================================================================

Block     macro
          inc  StopSwap           ;Increment block flag 
          endm

Continue  macro
          dec  StopSwap           ;Decrement block flag 
          endm

;== Structures =============================================================

TD        struc                   ;Task descriptor, must match the construction 
                                  ;of the record with the same name from the 
                                  ;MT unit 
StackPtr   equ this dword         ;Points to task stack
StackOfs   dw ?                   ;Offset address of the task stack
StackSeg   dw ?                   ;Segment address of the task stack

TaskSP     dw ?                   ;SP during task interruptions 
StackLen   dw ?                   ;Length of the task stack
Priority   db ?                   ;Task priority
Waitfor_Sm dd ?                   ;Pointer to expected semaphore
Last       dd ?                   ;Pointer to previous task descriptor
Next       dd ?                   ;Pointer to next task descriptor

TD        ends
;== Data Segment ===========================================================

DATA   segment word public

extrn  CurTask : dword            ;Pointer to current task (descriptor)
extrn  NumTask : word;            ;Number of tasks

DATA   ends
;== program ===============================================================

CODE       segment byte public    ;The program segment


;-- Declaration of the public routines ------------------------------------

public     MtaStart               ;Starts the multitasking
public     MtBlock                ;Stops the task switching
public     MtContinue             ;Starts the task switching again 
public     MtBlockFast            ;The two versions of the interrupt
public     MtContinueFast         ;handler
public     MtIsBlocked            ;Task switching blocked?
public     MtaTaskEnded           ;Is called at termination of a task
                                  ;automatically 
public     MtaStop                ;Switch multitasking off again 
public     MtaYield               ;Release execution (voluntarily) 
                                  ;to other task
public     MtaLost                ;Trigger task switching at next 
                                  ;opportunity 

;-- Declaration of the addressed routines from the MT unit ----------------

extrn      MtiKillTask  : near    ;Remove task from the list of task
                                  ;descriptors and release memory
extrn      MtChooseNext : near    ;Determines the next task to be executed
;== Variables in the Code Segment ===============================================

TurboSS    dw ?                   ;Stack segment of Turbo Pascal
TurboSP    dw ?                   ;Stack pointer of Turbo Pascal
TurboDS    dw ?                   ;Data segment of Turbo Pascal
StopSwap   db 1                   ;Is TRUE when a task cannot be 
                                  ;interrupted. Must be  
                                  ;initialized with TRUE.
Faster     db ?                   ;Is TRUE when system clock is accelerated 
Speed      db ?                   ;Speed factor for system clock 
Ticks      db ?                   ;Remaining ticks until the call of the old 
                                  ;Timer interrupt handler
RetAdr     dw ?                   ;Return jump address for TaskSwitch
Lost       db 0                   ;Is TRUE when a task switch was suppressed 
                                  ;by a block and must now be made up 

OldTimer   equ this dword
OldTimerO  dw  ?                  ;Offset and segment address of the old 
OldTimerS  dw  ?                  ;timer interrupt handler

OldDisk    equ this dword
OldDiskO   dw  ?                  ;Offset and segment address of the old 
OldDiskS   dw  ?                  ;BIOS disk interrupt handler (INTR 13)

OldDos     equ this dword
OldDosO    dw  ?                  ;Offset and segment address of the old 
OldDosS    dw  ?                  ;DOS function dispatcher (INTR 21)

MyStack    dw  STACK_LEN dup (?)  ;Internal stack
MyStackEnd equ this byte          ;Label marks end of stack 
;== Procedures =============================================================

           assume cs:code, ds:data

;---------------------------------------------------------------------------
;-- MtaStart     : Installs the scheduler as new timer interrupt and
;--                starts the multitasking with it
;-- input      : TEMPO = speed 
;--                  > 1 = Timer faster by factor TEMPO 
;--                  <-1 = Timer slower by factor TEMPO 
;-- call from TP: procedure MtaStart( Tempo : integer );
;-- Info         : To start multitasking, this procedure must be called 
;--                from the MT unit.

MtaStart   proc near

           mov   TurboSS,ss            ;Store Turbo stack 
           mov   TurboSP,sp
           mov   TurboDS,ds            ;Store data segment 

           ;-- Install new BIOS disk interrupt handler --------------

           mov   ax,3513h              ;Get interrupt vector 13h 
           int   21h
           mov   OldDiskO,bx           ;Store address in variables 
           mov   OldDiskS,es

           mov   cx,ds                 ;Store DS in CX 

           mov   ax,2513h              ;Install new handler 
           mov   dx,offset NewDisk
           push  cs                    ;Load CS into DS 
           pop   ds                    ;DS:DX now points to new handler
           int   21h

           ;-- Install new DOS interrupt handler --------------------

           mov   ax,3521h              ;Get interrupt vector 21h 
           int   21h
           mov   OldDosO,bx            ;Store address in variables 
           mov   OldDosS,es

           mov   ax,2521h              ;Install new handler 
           mov   dx,offset NewDos
           push  cs                    ;Load CS into DS 
           pop   ds                    ;DS:DX now points to new handler
           int   21h

           mov   ds,cx                 ;Restore DS from CX 

           ;-- Evaluate speed factor ----------------------------

           mov   bp,sp                 ;Make stack addressable 
           mov   cx,[bp+4]             ;get argument "Tempo" 
           or    ch,ch                 ;Greater than 0?
           jne   Slower                ;No, slower

           ;-- Accelerate the system clock -----------------------

           mov   Faster,1              ;Set flag 
           cmp   cx,1                  ;Neither faster nor slower?
           je    MtaSt1                ;Yes, timer does not have to be programmed 

           mov   al,TIMER_0_LOAD       ;Send command code to timer #0 
           out   TIMER_0_CTRL,al
           xor   ax,ax                 ;Calculate 65536 / CX 
           mov   dx,1
           div   cx                    ;Load quotient into AX 
           cli                         ;Suppress interrupts 
           out   TIMER_0_DATA,al       ;Load new timer frequency: low byte
           mov   al,ah
           out   TIMER_0_DATA,al       ;High byte
           sti                         ;Re-enable interrupts 

MtaSt1:    mov   dx,offset FastTimer   ;Address of the new handler
           jmp   ReplTimer

Slower:    ;-- Slow down system clock  -----------------------

           neg   cx                    ;Convert CX to positive number 
           mov   Faster,0              ;Set flag 
           mov   dx,offset SlowTimer   ;Address of the new handler

ReplTimer: ;-- Install new timer interrupt handler ------------------

           mov   Speed,cl              ;Store speed factor 
           mov   Ticks,cl

           mov   ax,3508h              ;Get interrupt vector 08h 
           int   21h
           mov   OldTimerO,bx          ;Store address in variables 
           mov   OldTimerS,es

           mov   cx,ds                 ;Store DS in CX 
           mov   ax,2508h              ;Install new handler 
           push  cs                    ;Load CS to DS 
           pop   ds                    ;DS:DX now points to new handler
           int   21h
           mov   ds,cx                 ;Restore DS from CX 

           call  MtChooseNext          ;Select first task

StartTask: ;-- Start execution of task again, to whose task descriptor -----
           ;-- CurTask points                                          -----

           mov   es,word ptr CurTask+2;Pointer to current task descriptor
           mov   bx,word ptr CurTask  ;Move to ES:BX 
           cli                        ;Do not disturb 
           mov   ss,es:[bx].StackSeg  ;Switch to task stack 
           mov   sp,es:[bx].TaskSP
           sti
           Continue                   ;Do not suppress task switching 

           pop   es                   ;Get the registers from the task stack 
           pop   ds
           pop   bp
           pop   si
           pop   di
           pop   dx
           pop   cx
           pop   bx
           pop   ax
           iret                       ;Jump into the task 

MtaStart   endp
;---------------------------------------------------------------------------
;-- SlowTimer : The new interrupt handler, when the timer interrupt was    -
;--             slowed 
;-- call from TP: Not permitted !

SlowTimer  proc near

           cmp   Lost,1                 ;Does a previous TaskSwitch
           je    StCall                 ;have to be suppressed?

           dec   Ticks                  ;Is call of the task switcher due?
           jne   STimer                 ;No

           ;-- Call task switcher, if possible -----------------------

StCall:    push  ax                     ;Load counter "Ticks" again 
           mov   al,Speed
           mov   Ticks,al
           pop   ax

           cmp   StopSwap,0             ;Task switching blocked?
           je    StSwitch               ;NO ---> StSwitch

           mov   Lost,1                 ;Yes, the task switch cannot be 
                                        ;executed 
STimer:    jmp   [OldTimer]             ;Jump to old handler 

StSwitch:  mov   Lost,0                 ;No call suppressed 
           mov   RetAdr,offset STimer   ;Return jump address for TaskSwitch

           ;-- Direct transition to TaskSwitch -----------------------------

SlowTimer  endp
;---------------------------------------------------------------------------
;-- TaskSwitch : Controls preemptive switching between various tasks
;--              tasks
;-- input    : Variable RetAdr = return jump address to caller 
;-- call from TP: not permitted!

TaskSwitch proc near

           push  ax                    ;Store the registers on the stack 
           push  bx                    ;of the current task 
           push  cx
           push  dx
           push  di
           push  si
           push  bp
           push  ds
           push  es

           ;-- Store current stack pointer in the task descriptor -----------

           mov   ds,TurboDS            ;Load Turbo data segment 
           mov   es,word ptr CurTask+2 ;Load pointer CurTask to ES:BX 
           mov   bx,word ptr CurTask
           mov   es:[bx].TaskSP,sp

           cli                         ;Switch to own stack 
           push  cs
           pop   ss 
           mov   sp,offset MyStackEnd
           sti

           Block
           call  MtChooseNext         ;Select next task 
           Continue

           ;-- Load pointer to new active task and return register from    -
           ;-- its task stack 

           mov   ax,word ptr CurTask+2 ;Load pointer CurTask into DS:BX 
           mov   bx,word ptr CurTask
           mov   ds,ax
           cli                        ;Switch to task stack 
           mov   ss,[bx].StackSeg
           mov   sp,[bx].TaskSP
           sti

           pop   es                   ;Load registers from task stack 
           pop   ds
           pop   bp
           pop   si
           pop   di
           pop   dx
           pop   cx
           pop   bx
           pop   ax

           jmp   [RetAdr]             ;Jump to caller 

TaskSwitch endp
;---------------------------------------------------------------------------
;-- FastTimer : The new interrupt handler, when the timer interrupt 
;--             was accelerated 
;-- call from TP: not permitted!

FastTimer  proc near

           cmp   StopSwap,0             ;Task switching blocked?
           jne   Ft                     ;Yes

           ;-- Task switching permitted, call task switcher ----------------

           mov   RetAdr,offset Ft1      ;Return jump address for taskSwitch
           jmp   taskSwitch

Ft:        mov   Lost,1                 ;Make up task switch 

Ft1:       push  ax                     ;Store AX on the stack 
           dec   Ticks                  ;Call to old handler is due 
           jne   FtEnde                 ;No ---> FtEnde

           ;-- Call old timer interrupt handler ----------------------

           mov   al,Speed               ;Load Speed into Ticks 
           mov   Ticks,al
           pop   ax                     ;Restore AX again 
           jmp   [OldTimer]             ;Jump to old handler 

           ;-- The old handler returns to the caller, jump to label -------
           ;-- FtEnde is not made 

FtEnde:    ;-- Return to caller without calling the old handler ----

           mov   al,INTR_EOI          ;Send "End of Interrupt" signal (EOI)
           out   INTR_PORT,al         ;to interrupt controller 
           pop   ax
           iret                       ;Back to caller

FastTimer  endp
;---------------------------------------------------------------------------
;-- MtBlock      : Stops the task switching until MtContinue is called 
;-- call from TP: procedure MtBlock;

MtBlock    proc far

           Block                  ;Increment block flag 
           mov  Lost,0            ;A task switch was not "lost"
           ret                    ;Back to caller

MtBlock    endp
;---------------------------------------------------------------------------
;-- MtContinue   : Starts task switching again, after it had been stopped 
;--                previously by MtBlock 
;-- call from TP: procedure MtContinue

MtContinue proc far

           Continue               ;Decrement block flag 
           cmp   Lost,0           ;Was a task switch lost?
           je    MtC              ;No, return 

           cmp   StopSwap,0       ;Is switching permissible again?
           jne   MtC              ;No ---> MtC

           ;-- A task switch should have been performed, ------
           ;-- make up for this now

           Block                  ;Block before yield 
           call  MtaYield         ;Perform task switch 

MtC:       ret                    ;Back to caller

MtContinue endp
;---------------------------------------------------------------------------
;-- MtBlockFast  : Stops the task switching until MtContinueFast is called 
;-- call from TP: procedure MtBlockFast;
;-- Info         : This procedure should be used only by the
;--                interrupt handler

MtBlockFast proc  far

           Block                  ;Increment flag 
           ret                    ;Back to caller

MtBlockFast endp

;---------------------------------------------------------------------------
;-- MtContinueFast: Starts the task switching again after it was stopped 
;--                 by MtBlockFast 
;-- call from TP: procedure MtContinueFast
;-- Info         : Unlike MtContinue a switch is not made to 
;--                another task, even if it should have occurred 
;--                in the meantime

MtContinueFast proc far

           Continue               ;Decrement block flag 
           ret                    ;Back to caller

MtContinueFast endp
;---------------------------------------------------------------------------
;-- MtaYield : Passes program execution (voluntarily) to another task
;-- call from TP: MtaYield
;-- Info         : - Call only possible from the MT unit!
;--                - During the call of this procedure, the task switching
;--                   must already be blocked. 

MtaYield proc near

           ;-- Emulate interrupt call ---------------------------------

           pop   ax                      ;Get offset addr. of the caller 
           pushf                         ;Flag register to the stack

           push  cs               ;Segment addr. for return jump on the stack
           push  ax               ;Offset addr. for return jump to stack

           mov   RetAdr,offset MtaYRet   ;Return jump address for TaskSwitch
           jmp   TaskSwitch              ;Switch to next task 

MtaYRet:   cli                           ;No timer call now 
           mov   Lost,0                  ;No switches lost 
           Continue                      ;Task switching permitted again 
           iret                          ;Back to caller

MtaYield   endp
;---------------------------------------------------------------------------
;-- MtIsBlocked : Inform the caller if the task switching is blocked at 
;--               the moment 
;-- call from TP: boolean := MtIsBlocked;

MtIsBlocked proc near

           cmp  StopSwap,0        ;Block flag deleted?

           mov  ax,1              ;No, no task switch currently permitted
           ret                    ;Back to caller

NoBlock:   xor  ax,ax             ;Return 0 for FALSE 
           ret                    ;Back to caller

MtIsBlocked endp
;---------------------------------------------------------------------------
;-- MtaStop : Re-installs the old interrupt handler and programs the timer -
;-            to its old frequency again
;-- call of TP: MtaStop
;-- Info         : - Call only possible from the MT unit!
;--                - During the call of this procedure the task switching 
;--                  must have been blocked already.

MtaStop    proc near

           mov   cx,ds                 ;Store DS in CX 

           mov   Lost,0                ;to prevent task switch 

           ;-- Reactivate old DOS interrupt ----------------------------

           mov   ax,2521h              ;Install new handler 
           lds   dx,OldDos             ;Load DS:DX with old handler 
           int   21h

           ;-- Reactivate old BIOS disk interrupt ----------------------

           mov   ax,2513h              ;Install new handler
           lds   dx,OldDisk            ;Load DS:DX with old handler
           int   21h

           ;-- Reactivate old timer ------------------------------------

           mov   ax,2508h              ;Install old timer interrupt handler
           lds   dx,OldTimer           ;again 
           int   21h

           ;-- Set old timer frequency again -----------------------

           mov   al,TIMER_0_LOAD       ;Set timer 0 again to old value
           out   TIMER_0_CTRL,al       ;to generate 18.2 ticks per 
           xor   al,al                 ;second 
           out   TIMER_0_DATA,al
           out   TIMER_0_DATA,al

           mov   ds,cx                 ;Return DS from CX 
           ret                         ;Back to caller

MtaStop    endp
;---------------------------------------------------------------------------
;-- MtaLost : Cause a task switch at the next opportunity (timer call)
;-- call from TP: MtaLost;
;-- Info         : - Call only possible from the MT unit!

MtaLost    proc near

           mov   Lost,1           ;Make up task switch 
           ret                    ;Back to caller

MtaLost    endp
;---------------------------------------------------------------------------
;-- MtaTaskEnded : Is called automatically when the end of the start 
;--                procedure of a task has been reached.
;-- call from TP: not permitted!

MtaTaskEnded proc near

           Block
           cli                         ;Switch to own stack 
           push  cs
           pop   ss
           mov   sp,offset MyStackEnd
           sti

           ;-- Delete task with the help of MtiKillTask from the Pascal ----
           ;-- part of the unit

           push  word ptr CurTask + 2  ;FAR pointer to current task
           push  word ptr CurTask      ;descriptor as parameter on the stack
           call  MtiKillTask           ;Call Pascal procedure
           cmp   NumTask,0             ;Was last task deleted?
           je    StopMt                ;Yes, back to caller of MtaStart

           jmp   StartTask             ;Start execution of new task 

StopMt:    ;-- Multitasking ended, back to caller of MtaStart() ----

           cli
           mov   ds,TurboDS            ;Load Turbo data segment 
           mov   ss,TurboSS            ;Install Turbo stack 
           mov   sp,TurboSP
           sti

           retf  2                     ;Back to caller with FAR return
                                       ;Remove arguments for MtaStart from 
                                       ;stack 
MtaTaskEnded endp
;----------------------------------------------------------------------------
;-- CheckLost : is called by one of the internal interrupt handlers to 
;--             trigger a task switch, if during its execution a task switch 
;--             had been blocked and the task switching is no longer blocked
;-- call of TP: not permitted!

CheckLost  proc near

           pushf                  ;Store flag register 
           Continue               ;Enable task switching 
           cmp  StopSwap,0        ;Enabled now?
           jne  clEnd             ;NO ---> clEnd

           cmp  Lost,0            ;Task switching permitted, switch blocked?
           je   clEnd             ;NO ---> clEnd

           ;-- Task switching is permitted and a switch --
           ;-- was already blocked. Do this switch

           Block                  ;Must execute before MtaYield
           push   ax              ;MtaYield changes ax, then store
           call MtaYield          ;Execute task change
           pop   ax               ;and return
clEnd:     popf                   ;Get flag register from stack
           ret                    ;Return to caller

CheckLost  endp

;-- The new interrupt 13h handler (BIOS disk interrupt) --------------------

NewDisk    proc far

           Block                  ;Suppress task switching
           pushf                  ;Call the old interrupt handler
           call   OldDisk         ;Emulate int 13h
           call   CheckLost       ;Suppress switches

           ret    2               ;Return to caller, but do not
                                  ;store registers on stack
NewDisk    endp

;-- The new interrupt 21h handler (DOS scheduler) -------------------------

NewDos     proc far

           Block                  ;Suppress task switching 
           pushf                  ;Emulate call of the old interrupt handler
           call  OldDos           ;through INT 13h 
           call  CheckLost        ;Perform blocked switches 

           ret  2                 ;Back to caller, but do not get 
                                  ;flag register from the stack 
NewDos     endp

;---------------------------------------------------------------------------

CODE       ends                   ;End of code segment
           end                    ;End of program
