{ Модуль для программ проверки ответов }

Unit Testers;

{$I-}

Interface

 Const { Коды выхода }
   cdAllOK = 0; { Файлы одинаковы и все в порядке }
   cdPrErr = 1; { Presentation Error }
   cdWrAns = 2; { Wrong Answer }
   cdParam = 3; { Ошибка при открытии входного/выходного файла }

{ Сообщения при выходе из программы }
 Messages : Array [0..3] of String =
  ( 'Файлы одинаковы и все в порядке',
    'Presentation Error',
    'Wrong Answer',
    'Ошибка при открытии входного/выходного файла');

 Var FI,F1,F2:Text; { Сравниваемые файлы }

{ --=== Открытие сравниваемых файлов ===-- }
 Procedure OpenFiles( Header:String );
{ --=== Закрытие сравниваемых файлов ===-- }
 Procedure CloseFiles;
{ --=== Выход из программы с кодом возврата Code ===-- }
 Procedure ExitProg( Code:Integer );
{ --=== Чтение числа типа LongInt ===-- }
 Function ReadLongInt( Var T:Text ):LongInt;

Implementation

{ --=== Выход из программы с кодом возврата Code ===-- }
 Procedure ExitProg( Code:Integer );
   Begin
     Writeln(Messages[Code]);
     CloseFiles;
     Halt(Code);
   End;

{ --=== Открытие сравниваемых файлов ===-- }
 Procedure OpenFiles( Header:String );
   Begin
     If ParamCount = 3 then
       Begin
         Assign(FI,ParamStr(1));
         Assign(F1,ParamStr(2));
         Assign(F2,ParamStr(3));
         Reset(FI); If IOResult<>0 then ExitProg(cdParam);
         Reset(F1); If IOResult<>0 then ExitProg(cdParam);
         Reset(F2); If IOResult<>0 then ExitProg(cdParam);
       End
     Else
       Begin
         Writeln(Header+' <Input> <Standart Output> <User Output>');
         Halt(0);
       End;
   End;

{ --=== Закрытие сравниваемых файлов ===-- }
 Procedure CloseFiles;
   Begin
     Close(FI);
     Close(F1);
     Close(F2);
   End;

{ --=== Чтение числа типа LongInt ===-- }
 Function ReadLongInt( Var T:Text ):LongInt;
   Var N:LongInt;
   Begin
     Read(T,N);
     If IOResult<>0 then ExitProg(cdPrErr);
     ReadLongInt:=N;
   End;

End.