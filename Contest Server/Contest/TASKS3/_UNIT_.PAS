Unit _Unit_;

Interface

{$I+}

 Uses DOS,CRT,Tools;

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                       К О Н С Т А Н Т Ы                       │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

 Const
  { Системная задержка }
   SystemDelay = 100;
  { Тестов за полностью рещенную задачу }
   BonusTests = 20;
  { Утилита проверки на недопустимые инструкции }
   CheckUtil = 'CHECK.EXE';
  { Утилита запуска программы }
   ExecUtil = 'TIMER.EXE';

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                          О Ш И Б К А                          │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Ошибка ===--- }
 Type
   TError = (NoError,CompilationError,WrongAnswer,TimeLimit,RuntimeError,
             IllegalInstructions);

{ ---=== Результат ===--- }
 Var Result : TError;

{ ---=== Номер ошибки ===--- }
 Function ErrorNum( _Error_:TError ):Byte;

{ ---=== Ошибка по номеру ===--- }
 Function ErrorSrc( _Error_:Word ):TError;

{ ---=== Текст ошибки ===--- }
 Function ErrorText( _Error_:TError ):String;

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                           Ф А Й Л Ы                           │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Копирование файла ===--- }
 Procedure CopyFile( Sourse,Dest:String );

 Procedure CopyBinary( Source,Dest:String );

{ ---=== Удаление файла ===--- }
 Procedure DelFile( FileName:String );

{ ---=== Удаление дерева каталогов ===--- }
 Procedure DelTree( DirName:String );

{ ---=== Сравнение файлов ===--- }
 Procedure CompareFiles( FileName1,FileName2:String );

{ ---=== Присутствие обьекта ===--- }
 Function ObjectExist( S:String ):Boolean;

{ ---=== Создание каталога ===--- }
 Procedure MakeDir( S:String );

{ ---=== Строка времени ===--- }
 Const CurHour   : Word = 0;
       CurMinute : Word = 0;
       CurSecond : Word = 0;
       CurSec100 : Word = 0;
       Time      : Word = 10;

{ ---=== Строка времени ===--- }
 Function CurTimeStr:String;

{ ---=== О программе ===--- }
 Procedure About;

{ ---=== Вывод информации ===--- }
 Procedure ShowInfo;

{ ---=== Файл отладки ===--- }
 Var LOG : Text;

{ ---=== Вывод строки на экран ===--- }
 Const NS = #13#10;

 Procedure OutText( Color:Byte; S:String );

{ ---=== Имена каталогов ===--- }
 Var SoftwareDir,NewDir,PupilDir,ResultsDir,TestDir:String;

{ ---=== Имена файлов ===--- }
 Var InFile,OutFile:String;

{ ---=== Ввод/вывод с файлами или с переопределением ввода/вывода ===--- }
 Const InOutFiles : Boolean = True; { True - С файлами }

{ ---=== Чтение файла инициализации ===--- }
 Procedure ReadIniFile( FileName:String; ShowFlag:Boolean );

{ ---=== Дописывание к текстовому файлу другого файла ===--- }
 Procedure CopyTextToText( Var BigText:Text; FileName:String );

{ ---=== Упакованный текстовой файл ===--- }
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

{ ---=== Создание правильных ответов ===--- }
 Procedure GenerateAnswers;

{ ---=== ID Задачи ===--- }
 Var TaskID : String[4];

{ ---=== ID Пользователя ===--- }
 Var UserID : String[4];

{ ---=== Пройдено тестов ===--- }
 Var TestsNum : Integer;

{ ---=== Запуск программы ===--- }
 Procedure ExecuteProg( Prg:String );

{ ---=== Тестируем программу ===--- }
 Procedure TestSource;

{ ---=== Записываем результаты ===--- }
 Procedure WriteResults;

{ ---=== Опрос сервера ===--- }
 Procedure ListenTasks;

{ ---=== Check ===--- }
 Procedure Check;

Implementation

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                          О Ш И Б К А                          │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

 Uses CRT,DOS;

{ ---=== Номер ошибки ===--- }
 Function ErrorNum( _Error_:TError ):Byte;
   Begin
     Case _Error_ of
       NoError             : ErrorNum:=0;
       CompilationError    : ErrorNum:=1;
       WrongAnswer         : ErrorNum:=2;
       TimeLimit           : ErrorNum:=3;
       RuntimeError        : ErrorNum:=4;
       IllegalInstructions : ErrorNum:=5;
     End;
   End;

{ ---=== Ошибка по номеру ===--- }
 Function ErrorSrc( _Error_:Word ):TError;
   Begin
     Case _Error_ of
       0: ErrorSrc:=NoError;
       1: ErrorSrc:=CompilationError;
       2: ErrorSrc:=WrongAnswer;
       3: ErrorSrc:=TimeLimit;
       4: ErrorSrc:=RuntimeError;
       5: ErrorSrc:=IllegalInstructions;
     End;
   End;

{ ---=== Текст ошибки ===--- }
 Function ErrorText( _Error_:TError ):String;
   Begin
     Case _Error_ of
       NoError             : ErrorText:='Ошибок не обнаружено';
       CompilationError    : ErrorText:='Ошибка компиляции';
       WrongAnswer         : ErrorText:='Неправильный ответ';
       TimeLimit           : ErrorText:='Превышение пердела времени';
       RuntimeError        : ErrorText:='Ошибка исполнения';
       IllegalInstructions : ErrorText:='Недопутимая инструкция';
     End;
   End;

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                           Ф А Й Л Ы                           │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Копирование файла ===--- }
 Procedure CopyFile( Sourse,Dest:String );
   Var SF,DF:Text; Str:String;
   Begin
     Assign(SF,Sourse);
     Assign(DF,Dest);
     Reset(SF);
     If IOResult<>0 then Exit;
     Rewrite(DF);
     If IOResult<>0 then Exit;
     Repeat
       Readln(SF,Str);
       Writeln(DF,Str);
     Until EOF(SF);
     Close(SF);
     Close(DF);
   End;

 Procedure CopyBinary( Source,Dest:String );
   Begin
     SwapVectors;
     Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C COPY '+Source+' '+Dest);
     SwapVectors;
   End;

{ ---=== Удаление файла ===--- }
 Procedure DelFile( FileName:String );
   Var F:File; Attr:Word;
   Begin
     Assign(F,FileName);
     Reset(F);
     If IOResult<>0 then Exit;
     GetFAttr(F,Attr);
     SetFAttr(F,(Attr And (VolumeID+Directory+Archive)));
     Erase(F);
   End;

{ ---=== Удаление дерева каталогов ===--- }
 Procedure _DelTree_( DirName:String );
   Var DirInfo:SearchRec; F:File; Attr:Word;
   Begin
     ChDir(DirName);
     If IOResult <> 0 then Exit;
     FindFirst('*.*',AnyFile,DirInfo);
     While DosError = 0 do
       Begin
         If ((DirInfo.Name <> '.') And
             (DirInfo.Name <> '..')) then
           Begin
             Assign(F,DirInfo.Name);
             GetFAttr(F,Attr);
             SetFAttr(F,(Attr And (VolumeID+Directory+Archive)));
             If (Attr And Directory)<>0 then
               _DelTree_(DirInfo.Name)
             Else
               Erase(F);
           End;
         FindNext(DirInfo);
       End;
     ChDir('..');
     RmDir(DirName);
   End;

 Procedure DelTree( DirName:String );
   Var CurDir:String;
   Begin
     GetDir(0,CurDir);
     _DelTree_(DirName);
     ChDir(CurDir);
   End;

{ ---=== Сравнение файлов ===--- }
 Procedure CompareFiles( FileName1,FileName2:String );
   Var T1,T2:Text; Str1,Str2:String;
   Begin
     Assign(T1,FileName1); Reset(T1);
     If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
     Assign(T2,FileName2); Reset(T2);
     If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
     Repeat
       Readln(T1,Str1);
       If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
       Readln(T2,Str2);
       If IOResult<>0 then Begin Result:=WrongAnswer; Exit; End;
       If Str1<>Str2 then Begin Result:=WrongAnswer; Exit; End;
     Until EOF(T1);
     Close(T1); Close(T2);
   End;

 Function ObjectExist( S:String ):Boolean;
   Var DirInfo:SearchRec;
   Begin
     FindFirst(S,AnyFile,DirInfo);
     ObjectExist := (DosError = 0);
   End;

 Procedure MakeDir( S:String );
   Var I:Byte; T,TS:String; CurDir:String;
   Begin
     GetDir(0,CurDir);
     T:=S;
     If T[Length(T)]<>'\' then T:=T+'\';
     If Pos(':',T)<>0 then
       Begin
         ChDir(Copy(T,1,3));
         T:=Copy(T,4,Length(S)-2);
       End;
     While T<>'' do
       Begin
         I:=Pos('\',T);
         TS:=Copy(T,1,I-1);
         If Not ObjectExist(TS) then MkDir(TS);
         ChDir(TS);
         T:=Copy(T,I+1,Length(T)-I+1);
       End;
     ChDir(CurDir);
   End;

{ ---=== Строка времени ===--- }
 Function CurTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurTimeStr := AddNumStr(CurHour,'0',2)+':'+
                   AddNumStr(CurMinute,'0',2)+':'+
                   AddNumStr(CurSecond,'0',2);
   End;

{ ---=== Вывод строки на экран ===--- }
 Procedure OutText( Color:Byte; S:String );
   Begin
     TextColor(Color);
     Write('{'+CurTimeStr+'} '+S);
     Write(LOG,'{'+CurTimeStr+'} '+S);
   End;

{ ---=== О программе ===--- }
 Procedure About;
   Begin
     OutText(15,NS+'---=== Super Contest Judge 2000 ===---'+NS);
     OutText(11,'    (c) XXX International Software'+NS);
     OutText(09,'             Build 002'+NS+NS);
     OutText(13,'           Denis@ipo.spb.ru'+NS+NS);
   End;

{ ---=== Вывод информации ===--- }
 Procedure ShowInfo;
   Begin
     OutText(11,'[!]: Каталог приема : '+NewDir+NS);
     OutText(11,'[!]: Каталог тестов : '+TestDir+NS);
     OutText(11,'[!]: Каталог пользователей : '+PupilDir+NS);
     OutText(11,'[!]: Каталог результатов : '+ResultsDir+NS);
     If InOutFiles then
       Begin
         OutText(11,'[!]: Входной файл : '+InFile+NS);
         OutText(11,'[!]: Выходной файл : '+OutFile+NS);
       End
     Else
       Begin
         OutText(11,'[!]: Входной файл : Клавиатура'+NS);
         OutText(11,'[!]: Выходной файл : Дисплей'+NS);
       End;
     OutText(11,'[!]: Время после которого система отключает задачу (сек) : '+NumStr(Time)+NS);
   End;

 Procedure __SetTime( S:String );
   Var Error:Integer;
   Begin
     Val(S,Time,Error);
     If Error<>0 then OutText(12,'Неправильный формат времени'+NS);
   End;

{ ---=== Исполнение команды ===--- }
 Procedure Command( CmdStr:String; ShowFlag:Boolean );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     If S='' then Exit;
     If S[1]='#' then Exit;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     If ShowFlag then OutText(13,'[Command]: '+S+NS);
    { ---=== Выделение команды и параметров ===--- }
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
     For I:=1 to Length(Cmd) do Cmd[I]:=UpCase(Cmd[I]);
     While (((Prm[1]=' ') Or (Prm[1]='=')) And (Length(Prm)>0)) do
       Prm:=Copy(Prm,2,Length(Prm)-1);
    { ---=== Обработка команд ===--- }
     If Cmd = 'NEWDIR'     then NewDir     := Prm Else
     If Cmd = 'TESTDIR'    then TestDir    := Prm Else
     If Cmd = 'PUPILDIR'   then PupilDir   := Prm Else
     If Cmd = 'RESULTSDIR' then ResultsDir := Prm Else
     If Cmd = 'INFILE'     then InFile     := Prm Else
     If Cmd = 'OUTFILE'    then OutFile    := Prm Else
     If Cmd = 'TIME'       then __SetTime(Prm) Else
    { Неверная команда }
     OutText(12,'[Error]: Неверная команда !'+NS);
   End;

{ ---=== Чтение файла инициализации ===--- }
Procedure ReadIniFile( FileName:String; ShowFlag:Boolean );
  Var T:Text; TempStr:String;
  Begin
    OutText(15,'[*] Читаю файл инициализации '+FileName+' [*]'+NS);
    Assign(T,FileName);
    Reset(T);
    If IOResult<>0 then
      Begin OutText(12,'[Error]: Не могу открыть '+FileName+NS); Exit; End;
    Repeat
      Readln(T,TempStr);
      Command(TempStr,ShowFlag);
    Until EOF(T);
    Close(T);
    If ((InFile[1] = '!') Or (OutFile[1] = '!')) then
      InOutFiles := False;
  End;

{ ---=== Дописывание к текстовому файлу другого файла ===--- }
 Procedure CopyTextToText( Var BigText:Text; FileName:String );
   Var T:Text; S:String;
   Begin
     Assign(T,FileName);
     Reset(T);
     Repeat
       Readln(T,S);
       Writeln(BigText,S);
     Until EOF(T);
     Close(T);
   End;

{ ---=== Упакованный текстовой файл ===--- }

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
     If Not First then Writeln(Data,'--------');
     CopyTextToText(Data,FileName);
     First:=False;
   End;

 Constructor TTextPack.Open( _Name_:String );
   Begin
     Name:=_Name_;
     Assign(Data,Name);
     Reset(Data);
     First:=True;
   End;

 Procedure TTextPack.WriteFile( FileName:String );
   Var T:Text; S:String;
   Begin
     Assign(T,FileName);
     Rewrite(T);
     Repeat
       Readln(Data,S);
       If S[1]='-' then Break;
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

{ ---=== Создание правильных ответов ===--- }
 Procedure GenerateTests( ExeTF,InTF,OutTF:String );
   Var In_T,Out_T:TTextPack;
   Begin
     In_T.Open(InTF);
     Out_T.New(OutTF);
     Repeat
       In_T.WriteFile(InFile);
       SwapVectors;
       If InOutFiles then
         Exec(ExeTF,'')
       Else
         Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C '+
           ExeTF+' < '+InFile+' > '+OutFile);
       SwapVectors;
       If DosError<>0 then
         OutText(12,'[!!!] Ошибка запуска #'+NumStr(DosError)+NS);
       Out_T.AddFile(OutFile);
     Until In_T.EndOfFile;
     In_T.Close;
     Out_T.Close;
     DelFile(InFile);
     DelFile(OutFile);
   End;

 Procedure GenerateAnswers;
   Var DirInfo:SearchRec; CurDir,S:String;
   Begin
     OutText(15,'[*] Создаю правильные ответы [*]'+NS);
     GetDir(0,CurDir);
     ChDir(TestDir);
     If IOResult<>0 then
       Begin
         OutText(12,'[!] Invalid Directory : '+TestDir+' [!]');
         Halt(1);
       End;
     FindFirst('*.EXE',AnyFile,DirInfo);
     While DosError = 0 do
       Begin
         S:=DirInfo.Name;
         GenerateTests(S,Copy(S,1,4)+'.TXT',Copy(S,1,4)+'OUT.TXT');
         FindNext(DirInfo);
       End;
     ChDir(CurDir);
   End;

{ ---=== Запуск программы ===--- }
 Procedure ExecuteProg( Prg:String );
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
     OutText(6,'[*] Записываю лимит времени в TIMER.TXT ...'+NS);
     Assign(T,'TIMER.TXT');
     Rewrite(T);
     Writeln(T,Time*19); { С запасом ! }
     Close(T);
     OutText(6,'[*] Запускаю '+ExecUtil+' ...'+NS);
     SwapVectors;
     If InOutFiles then
       Exec(SoftwareDir+'\'+ExecUtil,'')
     Else
       Exec(SoftwareDir+'\'+ExecUtil,InFile+' '+OutFile);
     SwapVectors;
     TextColor(10);
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         OutText(12,'[DosExitCode]: '+NumStr(DosExitCode)+NS);
         Result:=RuntimeError;
         Exit;
       End;
     OutText(6,'[*] Анализирую ответ '+ExecUtil+' ...'+NS);
     While FSearch('TimerOK.TXT','')='' do
       Begin
         OutText(12,'[*] Превышение лимита времени !'+NS);
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
         OutText(12,'[DosError]: '+NumStr(_DosError_)+NS);
         OutText(12,'[DosExitCode]: '+NumStr(_DosExitCode_)+NS);
         Result:=RuntimeError;
       End;
   End;

{ ---=== Тестируем программу ===--- }
 Procedure TestSource;
   Var In_T,Out_T:TTextPack;
   Begin
     TestsNum:=-1;
     If Result = NoError then
       Begin
         In_T.Open(TestDir+'\'+TaskID+'.TXT');
         Out_T.Open(TestDir+'\'+TaskID+'OUT.TXT');
         Repeat
           Inc(TestsNum);
           OutText(11,'[*] Тест номер '+NumStr(TestsNum+1)+' [*]'+NS);
           In_T.WriteFile(InFile);
           Out_T.WriteFile('STDOUT.TXT');
           ExecuteProg('TESTPROG.EXE');
           If Result <> NoError then Break;
           CompareFiles(OutFile,'STDOUT.TXT');
           If Result <> NoError then Break;
         Until In_T.EndOfFile;
         In_T.Close;
         Out_T.Close;
       End;
     If Result = NoError then Inc(TestsNum);
   End;

{ ---=== Записываем результаты ===--- }
 Procedure WriteResults;
   Var T:Text; Dir:String;
   Begin
     OutText(15,'[*] Записываю результат : '+ErrorText(Result)+' [*]'+NS);
     Assign(T,ResultsDir+'\'+UserID+'.TXT');
     Rewrite(T);
     Writeln(T,'<'+UserID+':'+TaskID+'> '+ErrorText(Result));
     Writeln(T,'Пройдено тестов : ',TestsNum);
     Writeln(T,'Ошибка в тесте :');
     CopyTextToText(T,InFile);
     Writeln(T,'Ответ :');
     If FSearch(OutFile,'')<>'' then
       CopyTextToText(T,OutFile)
     Else
       Writeln(T,'Нет выходного файла');
     Writeln(T,'Правильный ответ :');
     CopyTextToText(T,'STDOUT.TXT');
     Close(T);
     GetDir(0,Dir);
     ChDir(PupilDir);
     If Not ObjectExist(UserID) then MkDir(UserID);
     ChDir(UserID);
     Assign(T,UserID+'.RES');
     If ObjectExist(UserID+'.RES') then Append(T) Else Rewrite(T);
     ChDir(Dir);
     Writeln(T,'---=== '+CurTimeStr+' ===---');
     CopyTextToText(T,ResultsDir+'\'+UserID+'.TXT');
     Close(T);
   End;

{ ---=== Опрос сервера ===--- }
 Procedure ListenTasks;
   Var DirInfo:SearchRec; Flag:Boolean;
   Begin
     GetDir(0,SoftwareDir);
     ChDir(NewDir);
     FindFirst('*.EXE',AnyFile,DirInfo);
     While DosError = 0 do
       Begin
         UserID:=Copy(DirInfo.Name,1,4);
         TaskID:=Copy(DirInfo.Name,5,4);
         OutText(7,'[*] Обнаружен файл: '+DirInfo.Name+' [*]'+NS);
         Result:=NoError;
         ChDir(TestDir);
         Flag:=ObjectExist(TaskID+'.EXE');
         ChDir(NewDir);
         If Flag then
           Begin
             DelTree('TEMP');
             MkDir('TEMP');
             CopyBinary(DirInfo.Name,'TEMP\TESTPROG.EXE');
             ChDir('TEMP');
             TestSource;
             WriteResults;
             ChDir('..');
             DelTree('TEMP');
             CopyBinary(DirInfo.Name,PupilDir+'\'+UserID+'\'+DirInfo.Name);
             DelFile(DirInfo.Name);
           End;
         FindNext(DirInfo);
       End;
     ChDir(SoftwareDir);
   End;

{ ---=== Check ===--- }
Procedure Check;
  Var CurDir:String; C:Byte;
  Begin
    Assign(LOG,'LOG.TXT');
    Rewrite(LOG);
    About;
    OutText(10,'[#] Начало работы [#]'+NS);
    OutText(7,'Программа запущена: '+ParamStr(0)+NS);
    CurDir:=ParamStr(0);
    For C:=Length(CurDir) downto 1 do If CurDir[C]='\' then Break;
    If C > 1 then ChDir(Copy(CurDir,1,C));
    ReadIniFile('CONTEST.INI',False);
    ShowInfo;
    GenerateAnswers;
    OutText(14,'[*] Принимаю задачи от пользователей [*]'+NS);
    ListenTasks;
    OutText(10,'[#] Конец работы [#]'+NS);
    TextColor(7); Writeln;
    Close(LOG);
  End;

End.