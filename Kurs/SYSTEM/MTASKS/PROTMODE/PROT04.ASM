;  Техника преключения задач
; ===========================

include ProtBug.ASM

.386P

; ---=== С Т Р У К Т У Р Ы ===---

; Структура для описания дескриторов сегментов
Descr  Struc
Limit  DW   0
Base_L DW   0
Base_M DB   0
Attr_1 DB   0
Attr_2 DB   0
Base_H DB   0
Descr  EndS

; Структура для описания шлюзов ловушек
Trap   Struc
Offs_1 DW   0
Sel    DW   16
Rsrv   DB   0
Attr   DB   8Fh
Offs_H DW   0
Trap   EndS

; ---=== Д А Н Н Ы Е ===---

Data   Segment  Use16

; Таблица глобальных дескрипторов GDT
GDT_Null   Descr <0,0,0,0,0,0>
GDT_Data   Descr <Data_Size-1,0,0,92h,0,0>
GDT_Code   Descr <Code_Size-1,0,0,98h,0,0>
GDT_Stack  Descr <255,0,0,92h,0,0>
GDT_Screen Descr <4095,8000h,0Bh,92h,0,0>
GDT_Himem  Descr <511,0,10h,92h,80h,0>
GDT_TSS_0  Descr <103,0,0,89h,0,0>
GDT_TSS_1  Descr <103,0,0,89h,0,0>
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
          Trap 14 dup (<Dummy_Exc>)
IDT_Size = $ - IDT

; Поля данных программы
PDescr    DQ  0
Real_SP   DW  0
Real_SS   DW  0
Message   DB 'Вернулись в реальный режим !$'
TblHex    DB '0123456789ABCDEF'
String    DB '**** ****-**** ****-**** ****'
Len = $ - String
Number    DB '???? ????'
Home_Sel  DW Home
          DW 10h
TSS_0     DB 104 dup (0)
TSS_1     DB 104 dup (0)
Task1_Offs DW 0
Task1_Sel  DW 56
Data_Size = $ - GDT_Null
Data    EndS

; ---=== К О Д ===---
Text    Segment 'Code' Use16
        Assume CS:Text,DS:Data
Begin   Label Word

; ---=== И С К Л Ю Ч Е Н И Я ===---
Exc_00h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,00h
        JMP  DWORD PTR Home_Sel
Exc_00h EndP
Exc_01h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,01h
        JMP  DWORD PTR Home_Sel
Exc_01h EndP
Exc_02h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,02h
        JMP  DWORD PTR Home_Sel
Exc_02h EndP
Exc_03h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,03h
        JMP  DWORD PTR Home_Sel
Exc_03h EndP
Exc_04h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,04h
        JMP  DWORD PTR Home_Sel
Exc_04h EndP
Exc_05h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,05h
        JMP  DWORD PTR Home_Sel
Exc_05h EndP
Exc_06h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,06h
        JMP  DWORD PTR Home_Sel
Exc_06h EndP
Exc_07h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,07h
        JMP  DWORD PTR Home_Sel
Exc_07h EndP
Exc_08h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,08h
        JMP  DWORD PTR Home_Sel
Exc_08h EndP
Exc_09h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,09h
        JMP  DWORD PTR Home_Sel
Exc_09h EndP
; Недопустимый сегмент состояния TSS
Exc_0Ah Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Ah
        JMP  DWORD PTR Home_Sel
Exc_0Ah EndP
; Отсутствие сегмента
Exc_0Bh Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Bh
        JMP  DWORD PTR Home_Sel
Exc_0Bh EndP
; Ошибка обращения к стеку
Exc_0Ch Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Ch
        JMP  DWORD PTR Home_Sel
Exc_0Ch EndP
; Ошибка общей защиты
Exc_0Dh Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Dh
        JMP  DWORD PTR Home_Sel
Exc_0Dh EndP
; Ошибка страничного нарушения
Exc_0Eh Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Eh
        JMP  DWORD PTR Home_Sel
Exc_0Eh EndP
Exc_0Fh Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,0Fh
        JMP  DWORD PTR Home_Sel
Exc_0Fh EndP
Exc_10h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,10h
        JMP  DWORD PTR Home_Sel
Exc_10h EndP
Exc_11h Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,11h
        JMP  DWORD PTR Home_Sel
Exc_11h EndP
Dummy_Exc Proc
        Pop  EAX
        Pop  EAX
        Mov  SI,Offset String + 5
        Debug
        Mov  AX,1111h
        JMP  DWORD PTR Home_Sel
Dummy_Exc EndP

Main    Proc
        Xor  EAX,EAX
	Mov  AX,Data
	Mov  DS,AX
; Линейный адрес данных
        SHL  EAX,4
	Mov  EBP,EAX
	Mov  EBX,Offset GDT_Data
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Линейный адрес команд
	Xor  EAX,EAX
	Mov  AX,CS
        SHL  EAX,4
	Mov  EBX,Offset GDT_Code
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Линейный адрес стека
	Xor  EAX,EAX
	Mov  AX,SS
        SHL  EAX,4
	Mov  EBX,Offset GDT_Stack
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Линейный адрес TSS_0
        Mov  EAX,EBP
        Add  EAX,Offset TSS_0
        Mov  EBX,Offset GDT_TSS_0
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; Линейный адрес TSS_1
        Mov  EAX,EBP
        Add  EAX,Offset TSS_1
        Mov  EBX,Offset GDT_TSS_1
 	Mov  [EBX].Base_L,AX
        ROL  EAX,16
 	Mov  [EBX].Base_M,AL
; --> GTDR <---
	Mov  DWord Ptr PDescr+2,EBP
        Mov  Word Ptr PDescr,GDT_Size-1
        LGDT PDescr
; TSS_0 Инициализировать не надо
; Инициализация TSS_1
        Mov  Word Ptr TSS_1 + 4Ch,16             ; [CS]
        Mov  Word Ptr TSS_1 + 20h,Offset HighMem ; [IP]
        Mov  Word Ptr TSS_1 + 50h,24             ; [SS]
        Mov  Word Ptr TSS_1 + 38h,128            ; [SP]
        Mov  Word Ptr TSS_1 + 54h,8              ; [DS]
        Mov  Word Ptr TSS_1 + 48h,32             ; [ES]
; Подготовка к переходу в защищенный режим
        CLI
        Mov  AL,8Fh
        Out  70h,AL
        JMP  $+2
        Mov  AL,0Ah
        Out  71h,AL
        Mov  AX,40h
        Mov  ES,AX
        Mov  Word Ptr ES:[67h],Offset Return
        Mov  Word Ptr ES:[69h],CS
; Загружаеи IDTR
        Mov  Word Ptr PDescr,IDT_Size-1
        Mov  EAX,Offset IDT
        Add  EAX,EBP
        Mov  Dword Ptr PDescr+2,EAX
        LIDT PDescr
; Откроем линию A20
        Mov  AL,0D1h
        Out  64h,AL
        Mov  AL,0DFh
        Out  60h,AL
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
; Делаем адресуемым видеобуфер
        Mov  AX,32
        Mov  ES,AX
; Делаем адресуемой расширенную память
        Mov  AX,40
        Mov  GS,AX
; Загрузим регистр задачи TR селектором TSS основной задачи
        Mov  AX,48
        LTR  AX
; Переключение на задачу 1
        Call DWord Ptr Task1_Offs
; Восстановим адрес точки входа в TSS задачи 1
        Mov  Word Ptr TSS_1+20h,Offset HighMem
; Выполним повторное переключение на задачу 1
        Call DWord Ptr Task1_Offs
; Завершение программы
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
; Закроем линию A20
        Mov  AL,0D1h
        Out  64h,AL
        Mov  AL,0DDh
        Out  60h,AL
; Переключим режим процессора
        Mov  AL,0FEh
        Out  64h,AL
        Hlt
; Воостановим OS реального режима
Return: Mov  AX,Data
        Mov  DS,AX
	Mov  AX,Stk
	Mov  SS,AX
        Mov  SP,256
        Mov  SS,Real_SS
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

; ---=== З А Д А Ч А  1 ===---
HighMem Proc
        Mov  AX,40
        Mov  GS,AX
        Mov  EAX,0
        Mov  EBX,0
        Mov  ECX,80000h
Fill:   Mov  GS:[EBX],EAX
        Push EAX
        Push CX
        Mov  SI,Offset Number+5
        Debug
        Shr  EAX,16
        Mov  SI,Offset Number
        Debug
        Mov  SI,Offset Number
        Mov  CX,9
        Mov  AH,43h
        Mov  DI,1040
Scrh:   Lodsb
        Stosw
        Loop Scrh
        Pop  CX
        Pop  EAX
        Add  EBX,4
        Inc  EAX
        DB   67h
        Loop Fill_1
        JMP  Go
Fill_1: JMP  Fill
Go:     IRet
HighMem EndP

Code_Size = $ - Begin
Text    EndS
Stk     Segment Stack 'Stack'
	DB 256 dup ('^')
Stk     EndS
	End Main