Uses CRT,DOS,MCB;

{$M $4000,0,0 }

{$F+}
Var Old_Timer : Procedure;

Const
  ProgName  : String = 'TESTPROG';
  OK        : Boolean = True;
  Server_CS : Word = 0;
  Server_IP : Word = 0;
  Temp_CS   : Word = 0;
  Temp_IP   : Word = 0;
  Time      : LongInt = 0;
  TimeLim   : LongInt = 1;

Var Real_Interrupts : Array [0..$0FF] of Pointer Absolute $0000:$0000;
    Temp_Interrupts : Array [0..$0FF] of Pointer;

{ ---=== Возвращение из дочернего процесса ===--- }
 Procedure Server; Assembler;
   Asm
     Mov  AX,4C00h
     Int  21h
   End;

{ ---=== Новый обработчик таймера ===--- }
 Procedure New_Timer; Interrupt;
   Begin
     Asm PushF End;
     Old_Timer;
     If (((Time = TimeLim) Or (Port[$60] = 41)) And OK) then
       Begin
         Asm
          { Загружаем адрес вершины стека в ES:[DI] }
           Mov  AX,SS
           Mov  ES,AX
           Mov  DI,SP
          { Заменяем адрес }
           Mov  CX,Server_CS
           Mov  DX,Server_IP
           Mov  AX,ES:[DI+20]
           Mov  BX,ES:[DI+18]
           Mov  ES:[DI+20],CX
           Mov  ES:[DI+18],DX
          { Запоминаем старый адрес }
           Mov  Temp_CS,AX
           Mov  Temp_IP,BX
         End;
         Writeln;
         Writeln('[Timer]: Завершение работы :');
         Writeln('Старый адрес возврата : ',Temp_CS,':',Temp_IP);
         Writeln('Новый адрес возврата : ',Server_CS,':',Server_IP);
         Free_Program_Memory(ProgName);
         Writeln;
         OK:=False;
       End;
     Inc(Time);
     TextColor(11);
     Write(#13,Time,' -> ',TimeLim);
     TextColor(7);
   End;
{$F-}

Function CloseFile( Handler:Word ):Word; Assembler;
  Asm
    Mov AH,3Eh
    Mov BX,Handler
    Int 21h
    JC  @@Exit
    Xor AX,AX
   @@Exit:
  End;

Procedure CloseAllFiles;
  Var I:Word;
  Begin
    For I:=5 to $0FF do
      If CloseFile(I)=0 then
        Writeln('[Timer]: Закрываю файл ',I);
  End;

{$I-}

Var T:Text; I:Byte;
Begin
  TextColor(7);
  Writeln; Writeln('---=== T I M E R ===---'); Writeln;
 { Чтение инициаизации }
  Writeln('[Timer]: Читаю TIMER.TXT ...');
  Assign(T,'Timer.TXT');
  If IOResult <> 0 then
    Begin
      Writeln('[Timer]: Не могу открыть TIMER.TXT');
      Halt(1);
    End;
  Reset(T);
  Read(T,TimeLim);
  Close(T);
 { Установка процедуры Server }
  Server_CS:=Seg(Server);
  Server_IP:=Ofs(Server);
  Writeln('[Timer]: Server ',Server_CS,':',Server_IP);
 { Сохраняю таблицу прерываний }
  Writeln('[Timer]: Сохраняю таблицу прерываний');
  For I:=0 to $0FF do Temp_Interrupts[I] := Real_Interrupts[I];
 { Новый обработчик прерываний }
  GetIntVec($08,@Old_Timer);
  SetIntVec($08,Addr(New_Timer));
  Exec(ProgName+'.EXE','');
 { Восстанавливаю таблицу прерываний }
  For I:=0 to $0FF do Real_Interrupts[I] := Temp_Interrupts[I];
  CloseAllFiles;
  Writeln('[Timer]: Восстанавливаю таблицу прерываний');
  If OK then
    Begin
      Writeln('[Timer]: Записываю TimerOK.TXT ...');
      Assign(T,'TimerOK.TXT');
      Rewrite(T);
      Writeln(T,DosError);
      Writeln(T,DosExitCode);
      Close(T);
    End;
  TextColor(7);
  Writeln; Writeln;
End.
