; pm.asm
; TASM
;  tasm /m pm.asm
;  tlink /x /3 pm.obj
.386P
RM_Seg Segment Para Public "CODE" Use16
       Assume CS:RM_Seg,DS:PM_Seg,SS:Stack_Seg
Start:
; ---=== Segment Registers ===---
       Push PM_Seg
       Pop  DS
; ---=== Are we are in PM ? ===---
       Mov  EAX,CR0
       Test AL,1
       JZ   no_V86
       Mov  DX,Offset v86_msg
; ---=== E X I T ===---
Err_Exit:
       Push CS
       Pop  DS
       Mov  AH,9
       Int  21h
       Mov  AH,4Ch
       Int  21h
; ---=== Windows ? ===---
no_V86:
       Mov  AX,1600h
       Int  2Fh
       Test AL,AL
       JZ   no_Windows
       Mov  DX,Offset Win_msg
       JMP  Short Err_Exit
; ---=== Messages ===---
v86_msg DB "V86 mode - cann't switch to PM$"
Win_msg DB "Windows - access denied to PM 0$"

; ---=== Real Mode ===---
no_Windows:
; ---=== Clear Screen ===---
       Mov  AX,3
       Int  10h
; ---=== Descriptors ===---
       Xor  EAX,EAX
       Mov  AX,RM_Seg
       SHL  EAX,4
       Mov  Word Ptr GDT_16bitCS+2,AX
       SHR  EAX,16
       Mov  Byte Ptr GDT_16bitCS+4,AL
       Mov  AX,PM_Seg
       SHL  EAX,4
       Mov  Word Ptr GDT_32bitCS+2,AX
       Mov  Word Ptr GDT_32bitSS+2,AX
       SHR  EAX,16
       Mov  Byte Ptr GDT_32bitCS+4,AL
       Mov  Byte Ptr GDT_32bitSS+4,AL
; ---=== Linear GDT Address ===---
       Xor  EAX,EAX
       Mov  AX,PM_Seg
       SHL  EAX,4
       Push EAX
       Add  EAX,Offset GDT
       Mov  DWord Ptr GDTR+2,EAX
; ---=== Load GDT ===---
       LGDT FWord Ptr GDTR
; ---=== Linear Tasks Addresses ===---
       Pop  EAX
       Push EAX
       Add  EAX,Offset TSS_0
       Mov  Word Ptr GDT_TSS0+2,AX
       SHR  EAX,16
       Mov  Byte Ptr GDT_TSS0+4,AL
       Pop  EAX
       Add  EAX,Offset TSS_1
       Mov  Word Ptr GDT_TSS1+2,AX
       SHR  EAX,16
       Mov  Byte Ptr GDT_TSS1+4,AL
; ---=== Open A20 ===---
       Mov  AL,2
       Out  92h,AL
; ---=== Disable Intterrupts ===---
       CLI
; ---=== Disable NMI ===---
       In   AL,70h
       Or   AL,80h
       Out  70h,AL
; ---=== Switch to PM ===---
       Mov  EAX,CR0
       Or   AL,1
       Mov  CR0,EAX
; ---=== Load CS ===---
       DB   66h
       DB   0EAh
       DD   Offset PM_Entry
       DW   SEL_32bitCS
RM_Return:
; ---=== Return to RM ===---
       Mov  EAX,CR0
       And  AL,0FEh
       Mov  CR0,EAX
; ---=== Load CS ===---
       DB   0EAh
       DW   $+4
       DW   RM_Seg
; ---=== Load Serment Registers for RM ===---
       Mov  AX,PM_Seg
       Mov  DS,AX
       Mov  ES,AX
       Mov  AX,Stack_Seg
       Mov  BX,Stack_L
       Mov  SS,AX
       Mov  SP,BX
; ---=== Enable NMI ===---
       In   AL,70h
       And  AL,07Fh
       Out  70h,AL
; ---=== Enable Interrupts ===---
       STI
; ---=== E X I T ===---
       Mov  AH,4Ch
       Int  21h
RM_Seg EndS

PM_Seg Segment Para Public "CODE" Use32
       Assume CS:PM_Seg
; ---=== Global Descriptors Table ===---
GDT         Label Byte
            DB  8 dup(0)
GDT_FlatDS  DB  0FFh,0FFh,0,0,0,10010010b,11001111b,0
GDT_16bitCS DB  0FFh,0FFh,0,0,0,10011010b,0,0
GDT_32bitCS DB  0FFh,0FFh,0,0,0,10010010b,11001111b,0
GDT_32bitSS DB  0FFh,0FFh,0,0,0,10010010b,11001111b,0
; ---=== TSS 0 ===---
GDT_TSS0    DB  067h,0,0,0,0,1001001b,01000000b,0
; ---=== TSS 1 ===---
GDT_TSS1    DB  067h,0,0,0,0,1001001b,01000000b,0
GDT_Size = $ - GDT
GDTR        DW  GDT_Size - 1   ; GDT Size
            DD  ?              ; GDT Address
; ---=== Selectors ===---
SEL_FlatDS  EQU  001000b
SEL_16bitCS EQU  010000b
SEL_32bitCS EQU  011000b
SEL_32bitSS EQU  100000b
SEL_TSS0    EQU  101000b
SEL_TSS1    EQU  110000b
; ---=== TSS 0 ===---
TSS_0    DB  68h dup(0)
; ---=== TSS 1 ===---
TSS_1    DD  0,0,0,0,0,0,0,0
         DD  Offset Task_1
; Registers
         DD  0,0,0,0,0,Stack_L2,0,0,0B8140h
; Segment registers
         DD  SEL_FlatDS,SEL_32bitCS,SEL_32bitSS,SEL_FlatDS,0,0
         DD  0
         DD  0
; ---=== PM ENTRY ===---
PM_Entry:
; ---=== Prepare registers ===---
         Xor  EAX,EAX
         Mov  AX,SEL_FlatDS
         Mov  DS,AX
         Mov  ES,AX
         Mov  AX,SEL_32bitSS
         Mov  EBX,Stack_L
         Mov  SS,AX
         Mov  ESP,EBX
         Mov  AX,SEL_TSS0
         LTR  AX
; ---=== WORK ===---
         Xor  EAX,EAX
         Mov  EDI,0B8000h
Task_0:
         Mov  Byte Ptr DS:[EDI],AL
; ---=== FAR JUMP TO TSS_1 ===---
         DB   0EAh
         DD   0
         DW   SEL_TSS1
         Add  EDI,2
         Inc  AL
         Cmp  AL,80
         JB   Task_0
; ---=== FAR JUMP TO RM ===---
         DB   0EAh
         DD   Offset RM_Return
         DW   SEL_16bitCS
; ---=== TASK 1 ===---
Task_1:
         Mov  Byte Ptr DS:[EDI],AL
         Inc  AL
         Add  EDI,2
; ---=== Switch to Task 0 ===---
         DB   0EAh
         DD   0
         DW   SEL_TSS0
; ---=== Second Call ===---
         Mov  ECX,02000000h
         Loop $
         JMP  Task_1
PM_Seg   EndS

Stack_SEG SEGMENT        PARA STACK "STACK"
STACK_START DB 100h dup(?)
Stack_L = $ - STACK_START
STACK_TASK2 DB 100H DUP(?)
STACK_L2 = $ - sTACK_sTART
STACK_SEG ENDS
END START