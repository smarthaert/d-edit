{$M $4000,0,70000}
Uses CRT,DOS,_LOG_,Tools,IOTools,INI_Unit;

{ --=== Вывод строки на экран и в LOG-файл ===-- }
 Const NS = #13#10;

 Procedure OutText( Color:Byte; S:String );
   Begin
     TextColor(Color);    { Выводим на экран заданным цветом }
     Writeln(S);          { и одновременно }
     Writeln(LOG,'# '+S); { пишем в LOG-файл }
   End;

{ --=== Hастройки системы ===-- }
 Type
   TJudgeINI = Object(TINIFile)
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

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

 Procedure TJudgeINI.SetVar( Name,Value:String );
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

Var JudgeINI : TJudgeINI;

{ ---=== Дописывание к текстовому файлу другого файла ===--- }
 Procedure CopyTextToText( Var BigText:Text; FileName:String );
   Var T:Text; S:String;
   Begin
     OpenTextForRead(T,FileName);
     Repeat
       Readln(T,S);
       Writeln(BigText,S);
     Until EOF(T);
     Close(T);
   End;

{ --=== Упакованный текстовой файл ===-- }
 Type
   TTextPack = Object
     Name  : String;
     Data  : Text;
     First : Boolean;
     Constructor New( _Name_:String );
     Procedure AddFile( FileName:String );
     Constructor Open( _Name_:String );
     Procedure WriteFile( FileName:String );
     Function EndOfFile:Boolean;
     Destructor Close;
   End;

 Constructor TTextPack.New( _Name_:String );
   Begin
     Name:=_Name_;
     Assign(Data,Name);
     Rewrite(Data);
     First:=True;
   End;

 Procedure TTextPack.AddFile( FileName:String );
   Var T:Text;
   Begin
     If Not First then Writeln(Data,'########');
     CopyTextToText(Data,FileName);
     First:=False;
   End;

 Constructor TTextPack.Open( _Name_:String );
   Begin
     OutText(10,'Открываю файл (Упакованный текстовик): '+_Name_);
     Name:=_Name_;
     OpenTextForRead(Data,Name);
     First:=True;
   End;

 Procedure TTextPack.WriteFile( FileName:String );
   Var T:Text; S:String;
   Begin
     Assign(T,FileName);
     Rewrite(T);
     Repeat
       Readln(Data,S);
       If S[1]='#' then Break;
       Writeln(T,S);
     Until EOF(Data);
     System.Close(T);
   End;

 Function TTextPack.EndOfFile:Boolean;
   Begin
     EndOfFile:=EOF(Data);
   End;

 Destructor TTextPack.Close;
   Begin
     System.Close(Data);
   End;

{ --=== Console Output ===-- }
 Const ConOutFile : String = 'CONOUT.TXT';

{ --=== Проверка одной программы ===-- }
 Type
   TCheck = Object
     TaskID : String[4]; { ID Задачи }
     UserID : String[4]; { ID Ученика }
     TestsNum : Integer; { Пройдено тестов }
     Result : TError; { Результат тестирования }
     In_T,Out_T : TTextPack; { Tests }
     Constructor Init( _UserID,_TaskID:String );
     Procedure Test;
     Procedure WriteResults;
     Procedure ExecuteTask;
     Procedure CheckAnswer;
   End;

 Var Check:TCheck;

 Constructor TCheck.Init( _UserID,_TaskID:String );
   Begin
     UserID := _UserID;
     TaskID := _TaskID;
     Result := erNo;
   End;

 Procedure TCheck.Test;
   Begin
     ChDir(SoftwareDir);
    {$I-}
     OutText(7,'Создаю временный каталог TEMP: '); MkDir('TEMP');
     If IOResult<>0 then
       RuntimeError('Не могу создать каталог "TEMP" (Возможно, есть старый каталог "TEMP")');
    {$I+}
     OutText(7,'Перехожу во временный каталог TEMP: '); ChDir('TEMP');
     OutText(7,'Копирую файл: '+SoftwareDir+'\'+UsersDir+'\'+UserID+TaskID+'.EXE -> TEST.EXE');
     CopyFile(SoftwareDir+'\'+UsersDir+'\'+UserID+TaskID+'.EXE','TEST.EXE');
    { <Test> }
     In_T.Open(SoftwareDir+'\'+TestsDir+'\'+TaskID+'.in');
     Out_T.Open(SoftwareDir+'\'+TestsDir+'\'+TaskID+'.out');
     TestsNum := -1;
     Repeat
       Inc(TestsNum);
       OutText(7,'Test '+Int2Str(TestsNum+1));
       In_T.WriteFile(InFile);
       Out_T.WriteFile('OK_OUT.TXT');
       ExecuteTask; If Result <> erNo then Break;
       CheckAnswer; If Result <> erNo then Break;
     Until In_T.EndOfFile;
     If Result = erNo then Inc(TestsNum);
     In_T.Close;
     Out_T.Close;
    { </Test> }
     WriteResults;
     OutText(7,'Удаляю временный каталог TEMP: '); ChDir('..'); DelTree('TEMP');
   End;

 Procedure TCheck.WriteResults;
   Var T:Text; Dir:String;
   Begin
     OutText(11,'[*] Записываю результат : '+ErrorText(Result)+' [*]'+NS);
     Assign(T,SoftwareDir+'\'+ResultsDir+'\'+UserID+'.TXT');
    {$I-} Append(T); {$I+}
     If IOResult<>0 then Rewrite(T);
     Writeln(T);
     Writeln(T,'--=== Тестирование:  ID ученика - '+UserID+'  ID задачи - '+TaskID+' ===--');
     Writeln(T,'Результат: '+ErrorText(Result));
     If Result <> erNo then Writeln(T,'Всего пройдено тестов : ',TestsNum);
     If Result = erWrongAnswer then
       Begin
         Writeln(T,'Ошибка в тесте :');
         CopyTextToText(T,InFile);
         Writeln(T,'Ответ программы :');
         If FSearch(OutFile,'')<>'' then
           CopyTextToText(T,OutFile)
         Else
         If FSearch(ConOutFile,'')<>'' then
           CopyTextToText(T,ConOutFile)
         Else
           Writeln(T,'Нет выходного файла');
         Writeln(T,'Пример правильного ответа :');
         CopyTextToText(T,'OK_OUT.TXT');
       End;
     Close(T);
   End;

{ Запуск программы с контролем на TimeLimit и RuntimeError }
 Procedure TCheck.ExecuteTask;
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
     OutText(11,'Запуск программы с контролем на TimeLimit и RuntimeError'); 
    { TIMER <mode> <progname> <infile> <outfile> <timelimit> }
     OutText(13,'>> Запуск TIMER.EXE <<');
     SwapVectors;
     Exec( SoftwareDir+'\TIMER.EXE',
           '0 '{mode}+ 'TEST.EXE '{progname}+ InFile{infile}+
            ' '+ConOutFile+' '{outfile}+ Int2Str(Time){time limit} );
     SwapVectors;
    { Проверка на Time Limit }
     If FSearch('TimerOK.txt','') = '' then
       Begin
         Result := erTimeLimit;
         Exit;
       End;
    { Проверка на Runtime Error }
     OpenTextForRead(T,'TimerOK.txt');
     Readln(T,_DosError_);
     Readln(T,_DosExitCode_);
     If ((_DosError_<>0) Or (_DosExitCode_<>0)) then
       Begin
         OutText(12,'[DosError]: '+Int2Str(_DosError_));
         OutText(12,'[DosExitCode]: '+Int2Str(_DosExitCode_));
         Result:=erRuntime;
       End;
     Close(T);
   End;

 Procedure TCheck.CheckAnswer;
   Var T:Text; TaskName,TesterName:String; DEC1,DEC2:Integer;
   Begin
    { Находим нужнуя проверяющую программу }
     OutText(7,'Чтение Tasks.txt');
     OpenTextForRead(T,SoftwareDir+'\'+TestsDir+'\tasks.txt');
     Repeat
       Readln(T,TaskName);
       Readln(T,TesterName);
       If TaskName = TaskID then Break;
     Until EOF(T);
     Close(T);
     If TaskName <> TaskID then RuntimeError('No Testers !');
     OutText(11,'Tester: '+TesterName);
    { Запускаем ее ! }
     SwapVectors;
     Exec(SoftwareDir+'\'+TestersDir+'\'+TesterName,InFile+' OK_OUT.TXT '+OutFile);
     SwapVectors;
     DEC1:=DosExitCode;
     SwapVectors;
     Exec(SoftwareDir+'\'+TestersDir+'\'+TesterName,InFile+' OK_OUT.TXT '+ConOutFile);
     SwapVectors;
     DEC2:=DosExitCode;
     If Not ((DEC1=0) Or (DEC2=0)) then Result:=erWrongAnswer;
   End;

{ --=== Опрос сервера ===-- }
 Procedure ListenTasks;
   Var DirInfo:SearchRec; Flag:Boolean;
   Begin
     OutText(15,'[*] Проверка каталога сдаваемых задач [*]');
     ChDir(UsersDir);
     FindFirst('*.EXE',AnyFile,DirInfo);
     While DosError = 0 do
       Begin
         OutText(15,'--> Обнаружен файл: '+DirInfo.Name+' <--');
         Check.Init( Copy(DirInfo.Name,1,4) {UserID},
                     Copy(DirInfo.Name,5,4) {TaskID} );
         Check.Test;
         FindNext(DirInfo);
       End;
   End;

{ --=== Переход в каталог запуска программы ===-- }
Procedure GotoWorkDirectory;
  Var CurDir:String; C:Byte;
  Begin
    CurDir:=ParamStr(0);
    OutText(9,'Программа запущена: '+CurDir);
    For C:=Length(CurDir) downto 1 do If CurDir[C]='\' then Break;
    OutText(9,'Перехожу в каталог: "'+Copy(CurDir,1,C-1)+'"');
    If C > 1 then ChDir(Copy(CurDir,1,C-1));
    GetDir(0,SoftwareDir);
  End;

{ --=== О программе ===-- }
 Procedure About;
   Begin
     OutText(14,NS+'--=== Автоматическая тестирующая система ===--');
     OutText(11,   '  Заочная Школа Современного Программирования');
     OutText(10,   '    Copyrights (c) Степуленок Денис Олегович');
     OutText(13,   '            mailto: Denis@ipo.spb.ru'+NS);
   End;

{ --=== Основная программа ===-- }
Begin
  About;
  GotoWorkDirectory;
  JudgeINI.Run('JUDGE.INI');
  ListenTasks;
  TextColor(7); Writeln;
End.
