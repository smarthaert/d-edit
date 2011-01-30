; Первое знакомство с защищенным режимом
.386P

; Описание дескриторов сегментов
Descr  Struc
Limit  DW   0
Base_L DW   0
Base_M DB   0
Attr_1 DB   0
Attr_2 DB   0
Base_H DB   0
Descr  EndS

Data   Segment
; Таблица глобальных дескрипторов GDT
GDT_Null   Descr <0,0,0,0,0,0>
GDT_Data   Descr <Data_Size-1,0,0,92h,0,0>
GDT_Code   Descr <Code_Size-1,0,0,98h,0,0>
GDT_Stack  Descr <255,0,0,92h,0,0>
GDT_Screen Descr <4095,8000h,0Bh,92h,0,0>
GDT_Size = $ - GDT_Null

; Поля данных программы
PDescr    DQ   0
Real_SP   DW   0
Sym       DB   1
Attr      DB 1Eh 
Message   DB 'Вернулись в реальный режим !$'    
Data_Size = $ - GDT_Null
Data    EndS

Text    Segment 'Code' Use16
        Assume CS:Text,DS:Data
Main    Proc 
	Mov  AX,Data
	Mov  DS,AX
; Сегмент данных
	Mov  DL,0
  	SHLD DX,AX,4
	SHL  AX,4
	Mov  EBX,Offset GDT_Data
	Mov  [EBX].Base_L,AX         
	Mov  [EBX].Base_M,DL         
; Сегмент команд
	Mov  AX,CS
        Mov  DL,0
  	SHLD DX,AX,4
	SHL  AX,4
	Mov  EBX,Offset GDT_Code
	Mov  [EBX].Base_L,AX         
	Mov  [EBX].Base_M,DL         
; Сегмент стека
	Mov  AX,SS
        Mov  DL,0
  	SHLD DX,AX,4
	SHL  AX,4
	Mov  EBX,Offset GDT_Stack
	Mov  [EBX].Base_L,AX         
	Mov  [EBX].Base_M,DL         
; GTDR
	Mov  EBX,Offset GDT_Data
 	Mov  AX,[EBX].Base_L	        	
        Mov  Word Ptr PDescr+2,AX
        Mov  DL,[EBX].Base_M
        Mov  Byte Ptr PDescr+4,DL
        Mov  Word Ptr PDescr,GDT_Size-1
        LGDT PDescr
; Подготовка к возврату в реальный режим
 	Mov  AX,40h
  	Mov  ES,AX
        Mov  Word Ptr ES:[67h],Offset Return   
        Mov  ES:[69h],CS
; Подготовка к переходу в защищенный режим
        CLI
        Mov  AL,8Fh 
        Out  70h,AL
        JMP  $+2
        Mov  AL,0Ah
        Out  71h,AL
; Переходим в защищенный режим
	SMSW AX
        OR   AX,1
	LMSW AX
        DB   0EAh
        DW   Offset Continue
        DW   16
Continue:
; Делаем все адресуемым
        Mov  AX,8
        Mov  DS,AX      
        Mov  AX,24
        Mov  SS,AX      
        Mov  AX,32
        Mov  ES,AX      
        Mov  BX,800
	Mov  CX,640
        Mov  AX,Word Ptr Sym
Screen: Mov  ES:[BX],AX
        Add  BX,2
        Inc  AX
        Loop Screen
; Вернемся в реальный режим
	Mov  Real_SP,SP
        Mov  AL,0FEh
        Out  64h,AL
        Hlt
Return: Mov  AX,Data
        Mov  DS,AX
	Mov  SP,Real_SP
	Mov  AX,Stk
	Mov  SS,AX
	STI
	Mov  AL,0      
	Out  70h,AL
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