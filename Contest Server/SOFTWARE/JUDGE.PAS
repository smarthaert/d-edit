{ ╔════════════════════════════════════════════╗ }
{ ║  ---=== Super Contest Judge ver1.0 ===---  ║ }
{ ║      (c) Roman International Software      ║ }
{ ║            Build 002 [20.11.99]            ║ }
{ ╚════════════════════════════════════════════╝ }
Uses CRT,DOS,Tools;

{$I-}

Var
  WorkDir   : String; { Личный каталог судьи (в каталоге JudgesDir) }
  FreeCode  : String; { Код свободности судьи }
  BusyCode  : String; { Код занятости судьи }
  TaskFile  : String; { Исходник тестируемой программы }
  TestsDir  : String; { Каталог с тестами }
  Tests     : Word; { Количество тестов }
  TestsNum  : Word; { Пройденных тестов }
  Time      : Word; { Время на каждый тест }
  Compiler  : String; { Путь к компилятору }

{ ---=== Запрос на регистрацию судьи ===--- }
 Procedure AskForRegistration;
   Var T:Text;
   Begin
     Writeln('[*] Посылаю запрос на регистрацию к серверу ...');
     Assign(T,RegisterFile);
     Repeat
       Rewrite(T);
     Until IOResult = 0;
     Close(T);
   End;

{ ---=== Удаление запроса на регистрацию ===--- }
 Procedure DelRegistation;
   Var T:Text;
   Begin
     Writeln('[*] Удаляю файл запроса ...');
     Assign(T,RegisterFile);
     While FSearch(RegisterFile,'')<>'' do Erase(T);
   End;

{ ---=== Ожидание ответа от сервера ===--- }
 Procedure WaitServerAnswer;
   Begin
     Writeln('[*] Жду ответа от сервера ...');
     While FSearch(RegisterBackFile,'')='' do Delay(SystemDelay);
   End;

{ ---=== Чтение регистационного ответа ===--- }
 Procedure ReadServerAnswer;
   Var T:Text;
   Begin
     Writeln('[*] Читаю и удаляю файл ответа ...');
     Assign(T,RegisterBackFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,WorkDir); Writeln('Рабочий каталог = ',WorkDir);
     Readln(T,BusyCode); Writeln('Код занятости = ',BusyCode);
     Readln(T,FreeCode); Writeln('Код свободности = ',FreeCode);
     Erase(T);
   End;

{ ---=== Регистрация ===--- }
 Procedure Registration;
   Var T:Text;
   Begin
     AskForRegistration;
     WaitServerAnswer;
     DelRegistation;
     ReadServerAnswer;
   End;

{ ---=== Установка статуса судьи ===--- }
 Procedure SetStatus( Status:String );
   Var T:Text;
   Begin
     Assign(T,StatusFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,Status);
     Close(T);
     If Status = FreeCode then
       Writeln('[*] Статус = Свободен')
     Else
       Writeln('[*] Статус = Занят');
   End;

{ ---=== Чтение файла задания ===--- }
 Procedure ReadServerTask;
   Var T:Text;
   Begin
     Writeln('[*] Читаю файл задания и удаляю его ...');
     Assign(T,ServerFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,TaskFile); Writeln('Имя файла задачи = ',TaskFile);
     Readln(T,Compiler); Writeln('Имя компилятора = ',Compiler);
     Readln(T,TestsDir); Writeln('Каталог тестов = ',TestsDir);
     Readln(T,Tests); Writeln('Количество тестов = ',Tests);
     Readln(T,Time); Writeln('Время на кажый тест (сек) = ',Time);
     Erase(T);
   End;

{ ---=== Копируем и компилируем исходник ===--- }
 Procedure CompileSource;
   Begin
    { Копируем исходник }
     Writeln('[*] Копирую исходный текст ...');
     CopyFile(TaskFile,SourceTaskFile);
    { Проверяем на запрещенные инструкции }
     Writeln('[*] Проверяю на недопустимые инструкции ...');
     SwapVectors;
     Exec(SoftwareDir+'\'+CheckUtil,SourceTaskFile);
     SwapVectors;
     TextColor(10);
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         Writeln('[DosExitCode]: ',DosExitCode);
         Result:=IllegalInstructions;
         Exit;
       End;
    { Компилируем его }
     Writeln('[*] Компилирую исходный текст ...');
     SwapVectors;
     Exec(Compiler,SourceTaskFile);
     SwapVectors;
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         Writeln('[DosExitCode]: ',DosExitCode);
         Result:=CompilationError;
       End;
   End;

{ ---=== Запуск программы ===--- }
 Procedure ExecuteProg( Prg:String );
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
     Writeln('[*] Записываю лимит времени в TIMER.TXT ...');
     Assign(T,'TIMER.TXT');
     Rewrite(T);
     Writeln(T,Time*19); { С запасом ! }
     Close(T);
     Writeln('[*] Запускаю ',ExecUtil,' ...');
     SwapVectors;
     Exec(SoftwareDir+'\'+ExecUtil,Prg);
     SwapVectors;
     TextColor(10);
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         Writeln('[DosExitCode]: ',DosExitCode);
         Result:=RuntimeError;
         Exit;
       End;
     Writeln('[*] Анилизирую ответ ',ExecUtil,' ...');
     While FSearch('TimerOK.TXT','')='' do
       Begin
         Writeln('[*] Превышение лимита времени !');
         Result:=TimeLimit;
         Exit;
       End;
     Assign(T,'TimerOK.TXT');
     Reset(T);
     Readln(T,_DosError_);
     Readln(T,_DosExitCode_);
     Erase(T);
     If ((_DosError_<>0) Or (_DosExitCode_<>0)) then
       Begin
         Writeln('[DosError]: ',_DosError_);
         Writeln('[DosExitCode]: ',_DosExitCode_);
         Result:=RuntimeError;
       End;
   End;

{ ---=== Тестируем программу ===--- }
 Procedure TestSource;
   Var I:Word;
   Begin
     TestsNum:=0;
     If Result = NoError then
       For I:=1 to Tests do
         Begin
           TestsNum:=I-1;
           Writeln('[*] Тест номер ',I);
           CopyFile(TestsDir+'\INPUT'+AddNumStr(I,'0',2)+'.TXT','INPUT.TXT');
           ExecuteProg(WorkTaskFile);
           If Result <> NoError then Break;
           CompareFiles(TestsDir+'\OUTPUT'+AddNumStr(I,'0',2)+'.TXT','OUTPUT.TXT');
           If Result <> NoError then Break;
         End;
   End;

{ ---=== Записываем результаты ===--- }
 Procedure WriteResult;
   Var T:Text;
   Begin
     Writeln('[*] Записываю результат : ',ErrorText(Result));
     Assign(T,ResultsFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,TestsNum);
     Writeln(T,ErrorNum(Result));
     Close(T);
   End;

{ ---=== Опрос сервера ===--- }
 Procedure ListenTasks;
   Begin
     If FSearch(ServerFile,'')<>'' then
       Begin
         SetStatus(BusyCode);
         Result:=NoError;
         ReadServerTask;
         MkDir(TempDir);
         ChDir(TempDir);
         CompileSource;
         If Result = NoError then TestSource;
         If Result = NoError then TestsNum:=BonusTests;
         ChDir('..');
         DelTree(TempDir);
         WriteResult;
         SetStatus(FreeCode);
       End;
   End;

{ ---=== Опрос на команду завершения работы ===--- }
 Function ListenTermination:Boolean;
   Begin
     ListenTermination:=(FSearch(UnregisterFile,'')<>'');
   End;

{ ---=== О программе ===--- }
 Procedure About;
   Begin
     Writeln;
     TextColor(15); Writeln('---=== Super Contest Judge ver1.0 ===---');
     TextColor(11); Writeln('    (c) Roman International Software');
     TextColor(09); Writeln('          Build 002 [18.11.99]');
     Writeln;
   End;

{ ---=== Помощь ===--- }
 Procedure Help;
   Begin
     TextColor(12); Write('     JUDGE ');
     TextColor(13); Write('<');
     TextColor(14); Write('Путь к каталогу судей');
     TextColor(13); Writeln('>');
   End;

{ ---=== Работа судьи в каталоге судей ===--- }
 Procedure JudgeWork;
   Begin
     TextColor(10);
    { Регистрация }
     Registration;
    { Работаем в личном каталоге }
     ChDir(WorkDir);
    { Принимаем задачи от сервера }
     Writeln('[*] Принимаю задачи от сервера ...');
     SetStatus(FreeCode);
     Repeat
       ListenTasks;
       Delay(SystemDelay);
     Until ListenTermination;
    { Переходим в исходный каталог и подтираем свой собственный }
     ChDir('..');
     DelTree(WorkDir);
     Writeln('[*] Выхожу в операционную систему ...');
   End;

{ ---=== Основная Программа ===--- }
Var JudgesDir:String;
Begin
  About;
  If ParamCount = 1 then
    Begin
      JudgesDir:=ParamStr(1);
      GetDir(0,SoftwareDir);
      ChDir(JudgesDir);
      JudgeWork;
      ChDir(SoftwareDir);
    End
  Else
    Help;
  TextColor(07);
  Writeln;
End.
