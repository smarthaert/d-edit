; Исключения
include ProtBug.ASM
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

; Описание дескрипторов прерываний
Trap   Struc
Offs_1 DW   0
Sel    DW  16
Rsrv   DB   0
Attr   DB  8Fh
Offs_H DW   0
Trap   EndS

Data   Segment  Use16
; Таблица глобальных дескрипторов GDT
GDT_Null   Descr <0,0,0,0,0,0>
GDT_Data   Descr <Data_Size-1,0,0,92h,0,0>
GDT_Code   Descr <Code_Size-1,0,0,98h,0,0>
GDT_Stack  Descr <255,0,0,92h,0,0>
GDT_Screen Descr <4095,8000h,0Bh,92h,0,0>
GDT_Size = $ - GDT_Null

; Таблица дескрипторов прерываний
IDT       Label  Word
; Дескрипторы исключений
Exc00h    Trap <Exc_00h>
Exc01h    Trap <Exc_01h>
Exc02h    Trap <Exc_02h>
Exc03h    Trap <Exc_03h>
Exc04h    Trap <Exc_04h>
Exc05h    Trap <Exc_05h>
Exc06h    Trap <Exc_06h>
Exc07h    Trap <Exc_07h>
Exc08h    Trap <Exc_08h>
Exc09h    Trap <Exc_09h>
Exc0Ah    Trap <Exc_0Ah>
Exc0Bh    Trap <Exc_0Bh>
Exc0Ch    Trap <Exc_0Ch>
Exc0Dh    Trap <Exc_0Dh>
Exc0Eh    Trap <Exc_0Eh>
Exc0Fh    Trap <Exc_0Fh>
Exc10h    Trap <Exc_10h>
Exc11h    Trap <Exc_11h>
IDT_Size = $ - IDT

; Поля данных программы
PDescr    DQ   0
Message   DB 'Вернулись в реальный режим !$'
TblHex    DB '0123456789ABCDEF'
String    DB '**** ****-**** ****-**** ****'
Len = $ - String
Home_Sel  DW  Home
          DW  10h
Data_Size = $ - GDT_Null
Data    EndS

Text    Segment 'Code' Use16
        Assume CS:Text,DS:Data
Begin   Label Word

Exc_00h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,00h
        JMP  DWORD PTR Home_Sel
Exc_00h EndP
Exc_01h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,01h
        JMP  DWORD PTR Home_Sel
Exc_01h EndP
Exc_02h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,02h
        JMP  DWORD PTR Home_Sel
Exc_02h EndP
Exc_03h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,03h
        JMP  DWORD PTR Home_Sel
Exc_03h EndP
Exc_04h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,04h
        JMP  DWORD PTR Home_Sel
Exc_04h EndP
Exc_05h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,05h
        JMP  DWORD PTR Home_Sel
Exc_05h EndP
Exc_06h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,06h
        JMP  DWORD PTR Home_Sel
Exc_06h EndP
Exc_07h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,07h
        JMP  DWORD PTR Home_Sel
Exc_07h EndP
Exc_08h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,08h
        JMP  DWORD PTR Home_Sel
Exc_08h EndP
Exc_09h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,09h
        JMP  DWORD PTR Home_Sel
Exc_09h EndP
Exc_0Ah Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Ah
        JMP  DWORD PTR Home_Sel
Exc_0Ah EndP
Exc_0Bh Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Bh
        JMP  DWORD PTR Home_Sel
Exc_0Bh EndP
Exc_0Ch Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Ch
        JMP  DWORD PTR Home_Sel
Exc_0Ch EndP
Exc_0Dh Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Dh
        JMP  DWORD PTR Home_Sel
Exc_0Dh EndP
Exc_0Eh Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Eh
        JMP  DWORD PTR Home_Sel
Exc_0Eh EndP
Exc_0Fh Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Fh
        JMP  DWORD PTR Home_Sel
Exc_0Fh EndP
Exc_10h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,10h
        JMP  DWORD PTR Home_Sel
Exc_10h EndP
Exc_11h Proc
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,11h
        JMP  DWORD PTR Home_Sel
Exc_11h EndP

Main    Proc
        Xor  EAX,EAX
	Mov  AX,Data
	Mov  DS,AX
; Сегмент данных
        SHL  EAX,4
	Mov  EBP,EAX
	Mov  EBX,Offset GDT_Data
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Сегмент команд
	Xor  EAX,EAX
	Mov  AX,CS
        SHL  EAX,4
	Mov  EBX,Offset GDT_Code
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Сегмент стека
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
; Подготовка к переходу в защищенный режим
        CLI
        Mov  AL,80h
        Out  70h,AL
; Загружаеи IDTR
        Mov  Word Ptr PDescr,IDT_Size-1
        Mov  EAX,Offset IDT
        Add  EAX,EBP
        Mov  Dword Ptr PDescr+2,EAX
        LIDT PDescr
; Переходим в защищенный режим
	Mov  EAX,CR0
        Or   EAX,1
	Mov  CR0,EAX
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
; Глюк
        Mov  AX,Word Ptr DS:[Data_Size-1]
; Переодический вывод на экран символов
        Mov  CX,300
        Mov  BX,2720
        Mov  DX,3001h
xxxx:   Push CX
        Mov  CX,0
zzzz:   Loop zzzz
        Mov  ES:[BX],DX
        Inc  DL
        Add  BX,2
        Pop  CX
        Loop xxxx
        Mov  AX,0FFFFh
Home:   Mov  SI,Offset String
        Debug
; Выведем на экран диагностическую строку
        Mov  SI,Offset String
        Mov  CX,Len
        Mov  AH,74h
        Mov  DI,1600
Scr:    LODSB
        STOSW
        Loop Scr
; Вернемся в реальный режим
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
; Переход
	DB   0EAh
	DW   Offset Go
	DW   16
; Переключим режим процессора
Go:     Mov  EAX,CR0
	And  EAX,0FFFFFFFEh
	Mov  CR0,EAX
	DB   0EAh
	DW   Offset Return
	DW   Text
; Воостановим OS реального режима
Return: Mov  AX,Data
        Mov  DS,AX
	Mov  AX,Stk
	Mov  SS,AX
; Восстановим IDTR реального режима
        Mov  AX,3FFh
        Mov  Word Ptr PDescr,AX
        Xor  EAX,EAX
        Mov  Dword Ptr PDescr+2,EAX
        LIDT PDescr
; Разрешаем прерывания
	STI
	Mov  AL,0
	Out  70h,AL
; Сообщение о выходе
	Mov  AH,09h
	Mov  EDX,Offset Message
	Int  21h
	Mov  AX,4C00h
	Int  21h
Main    EndP
Code_Size = $ - Begin
Text    EndS
Stk     Segment Stack 'Stack'
	DB 256 dup ('^')
Stk     EndS
	End Main