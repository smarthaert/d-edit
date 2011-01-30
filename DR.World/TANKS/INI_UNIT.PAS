{ ╔═════════════════════════════════════════════╗ }
{ ║  ---=== Обьект - файл инициализации ===---  ║ }
{ ╚═════════════════════════════════════════════╝ }
(*
 Пример использования:
{ - Hастройки системы - }
 Type
   TINI = Object(TINIFile)
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

{ - Глобальные настраиваемые переменные - }
Var
  UsersDir, { Каталог поступления проверяемых задач (Содержит подкаталоги учеников) }
  TestsDir, { Каталог тестов (Правильных решений) }
  ResultsDir, { Каталог результатов (Отчет о проверке) }
  TestersDir, { Каталог программ для проверки ответов }
  PupilDir, { Каталог сведений о людях (Личных отчетов) }
  InFile, { Имя входного файла }
  SoftwareDir, { Каталог запуска системы }
  OutFile:String; { Имя выходного файла }
  Time:LongInt; { Время до аварийного завершения программы (в секундах) }

 Procedure TINI.SetVar( Name,Value:String );
   Begin
     OutText(10,'Hастройка: '+Name+' = '+Value);
    { ---=== Обработка команд ===--- }
     If Name = 'USERSDIR'   then UsersDir   := Value Else
     If Name = 'TESTSDIR'   then TestsDir   := Value Else
     If Name = 'RESULTSDIR' then ResultsDir := Value Else
     If Name = 'TESTERSDIR' then TestersDir := Value Else
     If Name = 'PUPILDIR'   then PupilDir   := Value Else
     If Name = 'INFILE'     then InFile     := Value Else
     If Name = 'OUTFILE'    then OutFile    := Value Else
     If Name = 'TIME'       then Time       := Str2Int(Value) Else
    { Неверная команда }
     RuntimeError('[Error]: Неверный параметр в INI файле !');
   End;

Var INI:TINI; 
  INI.Run('Start.ini');
*)

Unit INI_UNIT;

Interface

 Type
   TINIFile = Object
     Constructor Run( INIFileName:String ); { Обработка файла инициализации }
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

Implementation

 Uses RunError,StrUtils;

 Constructor TINIFile.Run( INIFileName:String );
   Var T:Text; S:String; P:Byte;
   Begin
     OpenTextRE(T,'Ini-file',INIFileName);
     Repeat
       Readln(T,S);
       S:=UpCaseStr(DelSpaces(S));
       If ((S<>'') And (S[1]<>'#') And (S[1]<>';')) then
         Begin
           P:=Pos('=',S);
           SetVar( DelSpaces(Copy(S,1,P-1)),
                   DelSpaces(Copy(S,P+1,Length(S)-P)) );
         End;
     Until EOF(T);
     Close(T);
   End;

 Procedure TINIFile.SetVar( Name,Value:String ); Begin End;

End.