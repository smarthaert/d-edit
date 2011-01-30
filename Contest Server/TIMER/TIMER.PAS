Uses CRT,DOS,IOTools;

{$M $4000,0,0 }

{$F+}
Var Old_Timer : Procedure;

Const
  AllOK     : Boolean = True;
  Server_CS : Word = 0;
  Server_IP : Word = 0;
  Temp_CS   : Word = 0;
  Temp_IP   : Word = 0;
  Time      : LongInt = 0;
  TimeLim   : LongInt = 1;

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
     If (((Time = TimeLim) Or (Port[$60] = 41)) And AllOK) then
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
         Writeln;
         AllOK:=False;
       End;
     Inc(Time);
     TextColor(11);
     Write(#13,Time,' -> ',TimeLim);
     TextColor(7);
   End;
{$F-}

{ --=== Установка нового таймера ===-- }
Procedure SetNewTimer;
  Begin
   { Установка процедуры Server }
    Server_CS:=Seg(Server);
    Server_IP:=Ofs(Server);
    Writeln('[Timer]: Server ',Server_CS,':',Server_IP);
   { Новый обработчик прерываний }
    GetIntVec($08,@Old_Timer);
    SetIntVec($08,Addr(New_Timer));
  End;

Procedure ExecProg( Mode:Byte; ProgName,InFile,OutFile:String );
  Begin
    Writeln('EXECUTE ',Mode,' ',ProgName,' ',InFile,' ',OutFile);
    Case Mode of
      0:
        Begin
          Writeln('Работаем с клавиатурой/дисплеем (Консольный режим)');
          If FSearch('COMMAND.COM',GetEnv('PATH'))='' then
            Writeln('Cann''t find COMMAND.COM! PATH = ',GetEnv('PATH'));
          Writeln('[Exec]: ',FSearch('COMMAND.COM',GetEnv('PATH'))+' /C '+
            ProgName+' < '+InFile+' > '+OutFile);
          Exec(FSearch('COMMAND.COM',GetEnv('PATH')),' /C '+
            ProgName+' < '+InFile+' > '+OutFile);
        End;
      1:
        Begin
          Writeln('Работаем с файлами');
          Exec(ProgName,'');
        End;
    End;
End;

{ --=== Восстановление таймера ===-- }
Procedure RestoreTimer;
  Begin
    SetIntVec($08,Addr(Old_Timer));
  End;

{ --=== Сохранение результатов ===-- }
Procedure SaveResults;
  Var T:Text;
  Begin
    Writeln('[Timer]: Записываю TimerOK.TXT ...');
    Writeln('[Timer]: DosError & DosExitCode');
    Assign(T,'TimerOK.TXT');
    Rewrite(T);
    Writeln(T,DosError);
    Writeln(T,DosExitCode);
    Close(T);
  End;

{ --=== Основная программа ===-- }
Begin
  TextColor(7); Writeln(#13#10'---=== T I M E R  2 0 0 0 ===---'#13#10);
  If ParamCount = 5 then
    Begin
      TimeLim := Trunc( Str2Int(ParamStr(5))*18.2 ) + 1;
      SetNewTimer;  { Установка нового таймера }
     { - Запуск программы - }
      ExecProg(Str2Int(ParamStr(1)){<mode>}, ParamStr(2){<progname>},
               ParamStr(3){<infile>}, ParamStr(4){<outfile>});
      RestoreTimer; { Восстановление таймера }
      If AllOK then SaveResults; { Сохранение результатов в "TimerOK.txt" }
    End
  Else
    Begin
      Writeln('TIMER <mode> <progname> <infile> <outfile> <timelimit>');
      Writeln('<mode>: 0 - Консольный режим');
      Writeln('        1 - Файловый режим');
      Writeln('<progname> - Имя файла программы (Полный путь)');
      Writeln('<timelimit> - Ограничение в секундах на работу программы');
      Writeln('Hажмите "~" для преждевременного выхода из программы');
    End;
  TextColor(7); Writeln(#13#10);
End.