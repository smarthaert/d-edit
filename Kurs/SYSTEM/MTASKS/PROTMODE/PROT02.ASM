; 32-ࠧ�來� ���࠭�� � ��㣨� �ᮢ��襭�⢮�����
.386P

; ���ᠭ�� �����஢ ᥣ���⮢
Descr  Struc
Limit  DW   0
Base_L DW   0
Base_M DB   0
Attr_1 DB   0
Attr_2 DB   0
Base_H DB   0
Descr  EndS

Data   Segment
; ������ ��������� ���ਯ�஢ GDT
GDT_Null   Descr <0,0,0,0,0,0>
GDT_Data   Descr <Data_Size-1,0,0,92h,0,0>
GDT_Code   Descr <Code_Size-1,0,0,98h,0,0>
GDT_Stack  Descr <255,0,0,92h,0,0>
GDT_Screen Descr <4095,8000h,0Bh,92h,0,0>
GDT_Size = $ - GDT_Null

; ���� ������ �ணࠬ��
PDescr    DQ   0
Real_SP   DW   0
Sym       DB   1
Attr      DB 1Eh 
Message   DB '���㫨�� � ॠ��� ०�� !$'    
Data_Size = $ - GDT_Null
Data    EndS

Text    Segment 'Code' Use16
        Assume CS:Text,DS:Data
Main    Proc 
        Xor  EAX,EAX
	Mov  AX,Data
	Mov  DS,AX
; ������� ������
        SHL  EAX,4
	Mov  EBP,EAX
	Mov  EBX,Offset GDT_Data
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; ������� ������
	Xor  EAX,EAX
	Mov  AX,CS
        SHL  EAX,4
	Mov  EBX,Offset GDT_Code
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; ������� �⥪�
	Xor  EAX,EAX
	Mov  AX,SS
        SHL  EAX,4
	Mov  EBX,Offset GDT_Stack
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; GTDR
	Mov  DWord Ptr PDescr+2,EBP
        Mov  Word Ptr PDescr,GDT_Size-1
        LGDT PDescr 
; �����⮢�� � ���室� � ���饭�� ०��
        CLI
        Mov  AL,80h 
        Out  70h,AL
; ���室�� � ���饭�� ०��
	Mov  EAX,CR0
        Or   EAX,1
	Mov  CR0,EAX
        DB   0EAh
        DW   Offset Continue
        DW   16
Continue:
; ������ �� ����㥬�
        Mov  AX,8
        Mov  DS,AX      
        Mov  AX,24
        Mov  SS,AX      
        Mov  AX,32
        Mov  ES,AX      
; �뢮��� ᨬ����
        Mov  BX,800
	Mov  CX,640
        Mov  AX,Word Ptr Sym
Screen: Mov  ES:[BX],AX
        Add  BX,2
        Inc  AX
        Loop Screen
; ��୥��� � ॠ��� ०��
	Mov  GDT_Data.Limit,0FFFFh
	Mov  GDT_Code.Limit,0FFFFh
	Mov  GDT_Stack.Limit,0FFFFh
	Mov  GDT_Screen.Limit,0FFFFh
        Mov  AX,8
        Mov  DS,AX      
        Mov  AX,24
        Mov  SS,AX      
        Mov  AX,32
        Mov  ES,AX      
; ���室
	DB   0EAh
	DW   Offset Go
	DW   16
Go:     Mov  EAX,CR0
	And  EAX,0FFFFFFFEh
	Mov  CR0,EAX
	DB   0EAh
	DW   Offset Return
	DW   Text		
; ����⠭���� OS ॠ�쭮�� ०���
Return: Mov  AX,Data
        Mov  DS,AX
	Mov  AX,Stk
	Mov  SS,AX
	STI
	Mov  AL,0      
	Out  70h,AL
; ����饭�� � ��室�
	Mov  AH,09h
	Mov  EDX,Offset Message
	Int  21h
	Mov  AX,4C00h
	Int  21h
Main    EndP
Code_Size = $ - Main
Text    EndS
Stk     Segment Stack 'Stack' 
	DB 256 dup ('^')
Stk     EndS
	End Main