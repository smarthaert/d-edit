unit Start;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TMainWindow = class(TForm)
    NewDirEdit: TEdit;
    SaveButton: TButton;
    TestDirEdit: TEdit;
    ResultsDirEdit: TEdit;
    PupilDirEdit: TEdit;
    InputFileEdit: TEdit;
    OutputFileEdit: TEdit;
    TimeLimitEdit: TEdit;
    TestDirLabel: TLabel;
    ResultsDirLabel: TLabel;
    PupilDirLabel: TLabel;
    InputFileLabel: TLabel;
    OutputFileLabel: TLabel;
    TimeLimitLabel: TLabel;
    NewDirLabel: TLabel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    procedure EnterEvent(Sender: TObject);
    procedure StartApp(Sender: TObject);
    procedure SaveEvent(Sender: TObject);
    procedure SaveApp(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainWindow: TMainWindow;

implementation

{$R *.DFM}

{ ---=== Строка времени ===--- }
 Const CurHour   : Word = 0;
       CurMinute : Word = 0;
       CurSecond : Word = 0;
       CurSec100 : Word = 0;
       Time      : Word = 10;

{ ---=== Имена каталогов ===--- }
 Var SoftwareDir,NewDir,PupilDir,ResultsDir,TestDir,
     TimeStr:String;

{ ---=== Имена файлов ===--- }
 Var InFile,OutFile:String;

{ ---=== Ввод/вывод с файлами или с переопределением ввода/вывода ===--- }
 Const InOutFiles : Boolean = True; { True - С файлами }

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

{ ---=== Сообщение об ошибке ===--- }
 Procedure ErrorMessage( S:PChar );
   Begin
     MessageBox(Application.Handle,S,'Ошибка',128);
   End;

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

{ ---=== ID Задачи ===--- }
 Var TaskID : String[4];

{ ---=== ID Пользователя ===--- }
 Var UserID : String[4];

{ ---=== Пройдено тестов ===--- }
 Var TestsNum : Integer;

 Procedure __SetTime( S:String );
   Var Error:Integer;
   Begin
     Val(S,Time,Error);
     ErrorMessage('Неправильный формат времени');
   End;

{ ---=== Исполнение команды ===--- }
 Procedure Command( CmdStr:String; ShowFlag:Boolean );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     If S='' then Exit;
     If S[1]='#' then Exit;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
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
     ErrorMessage('Неверена конфигурация !');
   End;

 Function ValidCheck:Boolean;
   Var Error:Integer; D:String;
   Begin
     ValidCheck:=False;
     GetDir(0,D);
     {$I-} ChDir(NewDir); {$I+}
     If IOResult<>0 then Begin
       ErrorMessage('Не существует каталог входящие'); Exit; End;
     {$I-} ChDir(TestDir); {$I+}
     If IOResult<>0 then Begin
       ErrorMessage('Не существует каталог тесты'); Exit; End;
     {$I-} ChDir(ResultsDir); {$I+}
     If IOResult<>0 then Begin
       ErrorMessage('Не существует каталог результаты'); Exit; End;
     {$I-} ChDir(PupilDir); {$I+}
     If IOResult<>0 then Begin
       ErrorMessage('Не существует каталог учащиеся'); Exit; End;
     ChDir(D);
     Val(TimeStr,Time,Error);
     If Error<>0 then
       Begin
         ErrorMessage('Неверный лимит времени');
         Exit;
       End;
     ValidCheck:=True;
   End;

{ ---=== Удаление файла ===--- }
 Procedure DelFile( FileName:String );
   Var F:File; Attr:Word;
   Begin
     Assign(F,FileName);
     Reset(F);
     If IOResult<>0 then Exit;
     Erase(F);
   End;

{ ---=== Ошибка ===--- }
 Type
   TError = (NoError,CompilationError,WrongAnswer,TimeLimit,RuntimeError,
             IllegalInstructions);

{ ---=== Результат ===--- }
 Var Result : TError;

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

{ ---=== Создание правильных ответов ===--- }
 Procedure GenerateTests( ExeTF,InTF,OutTF:String );
   Var In_T,Out_T:TTextPack;
   Begin
     In_T.Open(InTF);
     Out_T.New(OutTF);
     Repeat
       In_T.WriteFile(InFile);
      {!!!}
{       SwapVectors;
       If InOutFiles then
         Exec(ExeTF,'')
       Else
         Exec(FSearch('COMMAND.COM',GetEnv('PATH')),'/C '+
           ExeTF+' < '+InFile+' > '+OutFile);
       SwapVectors;}
      {!!!}
       While FileSearch(OutFile,'')='' do;
       Out_T.AddFile(OutFile);
     Until In_T.EndOfFile;
     In_T.Close;
     Out_T.Close;
     DelFile(InFile);
     DelFile(OutFile);
   End;

 Procedure GenerateAnswers;
   Var DirInfo:TSearchRec; CurDir,S:String;
   Begin
     GetDir(0,CurDir);
     ChDir(TestDir);
     FindFirst('*.EXE',faAnyFile,DirInfo);
     While Found = 0 do
       Begin
         S:=DirInfo.Name;
         {GenerateTests(S,Copy(S,1,4)+'.TXT',Copy(S,1,4)+'OUT.TXT');}
         FindNext(DirInfo);
       End;
     ChDir(CurDir);
   End;

{ ---=== Запуск программы ===--- }
 Procedure ExecuteProg( Prg:String );
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
(*     OutText(6,'[*] Записываю лимит времени в TIMER.TXT ...'+NS);
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
       End;*)
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
       { !!!   OutText(11,'[*] Тест номер '+NumStr(TestsNum+1)+' [*]'+NS);}
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

{ ---=== Присутствие обьекта ===--- }
 Function ObjectExist( S:String ):Boolean;
   Var DirInfo:TSearchRec;
   Begin
     FindFirst(S,faAnyFile,DirInfo);
     ObjectExist := (IOResult = 0);
   End;

{ ---=== Записываем результаты ===--- }
 Procedure WriteResults;
   Var T:Text; Dir:String;
   Begin
     Assign(T,ResultsDir+'\'+UserID+'.TXT');
     Rewrite(T);
     Writeln(T,'<'+UserID+':'+TaskID+'> '+ErrorText(Result));
     Writeln(T,'Пройдено тестов : ',TestsNum);
     Writeln(T,'Ошибка в тесте :');
     CopyTextToText(T,InFile);
     Writeln(T,'Ответ :');
     If FileSearch(OutFile,'')<>'' then
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
     Writeln(T,'---===###===---');
     CopyTextToText(T,ResultsDir+'\'+UserID+'.TXT');
     Close(T);
   End;

{ ---=== Опрос сервера ===--- }
 Procedure ListenTasks;
   Var DirInfo:TSearchRec; Flag:Boolean;
   Begin
     GetDir(0,SoftwareDir);
     ChDir(NewDir);
     FindFirst('*.EXE',faAnyFile,DirInfo);
     While IOResult = 0 do
       Begin
         UserID:=Copy(DirInfo.Name,1,4);
         TaskID:=Copy(DirInfo.Name,5,4);
         Result:=NoError;
         ChDir(TestDir);
         Flag:=ObjectExist(TaskID+'.EXE');
         ChDir(NewDir);
         If Flag then
           Begin
 {  !!!          DelTree('TEMP');}
             MkDir('TEMP');
{!!!             CopyBinary(DirInfo.Name,'TEMP\TESTPROG.EXE');}
             ChDir('TEMP');
             TestSource;
             WriteResults;
             ChDir('..');
{!!!             DelTree('TEMP');}
{!!!             CopyBinary(DirInfo.Name,PupilDir+'\'+UserID+'\'+DirInfo.Name);}
             DelFile(DirInfo.Name);
           End;
         FindNext(DirInfo);
       End;
     ChDir(SoftwareDir);
   End;

 Procedure Check;
   Begin
     If not ValidCheck then Exit;
     GenerateAnswers;
     {ListenTasks;}
     MessageBox(Application.Handle,'Поздравляю',
       'Тестирование завершено',128);
   End;

 Procedure IniCommand( CmdStr:String );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     If S='' then Exit;
     If S[1]='#' then Exit;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
     For I:=1 to Length(Cmd) do Cmd[I]:=UpCase(Cmd[I]);
     While (((Prm[1]=' ') Or (Prm[1]='=')) And (Length(Prm)>0)) do
       Prm:=Copy(Prm,2,Length(Prm)-1);
     If Cmd = 'NEWDIR'     then NewDir     := Prm Else
     If Cmd = 'TESTDIR'    then TestDir    := Prm Else
     If Cmd = 'PUPILDIR'   then PupilDir   := Prm Else
     If Cmd = 'RESULTSDIR' then ResultsDir := Prm Else
     If Cmd = 'INFILE'     then InFile     := Prm Else
     If Cmd = 'OUTFILE'    then OutFile    := Prm Else
     If Cmd = 'TIME'       then TimeStr    := Prm;
   End;

 Procedure ReadIniFile( FileName:String );
   Var T:TextFile; TempStr:String;
   Begin
     AssignFile(T,FileName);
     Reset(T);
     Repeat
       Readln(T,TempStr);
       IniCommand(TempStr);
     Until EOF(T);
     CloseFile(T);
   End;

 Procedure SetParams;
   Begin
     With MainWindow do
       Begin
         NewDir:=NewDirEdit.Text;
         TestDir:=TestDirEdit.Text;
         ResultsDir:=ResultsDirEdit.Text;
         PupilDir:=PupilDirEdit.Text;
         InFile:=InputFileEdit.Text;
         OutFile:=OutputFileEdit.Text;
         TimeStr:=TimeLimitEdit.Text;
       End;
   End;

 Procedure SaveIni;
   Var T:TextFile;
   Begin
     AssignFile(T,'CONTEST.INI');
     Rewrite(T);
     Writeln(T,'#  Файл настроек системы Автоматизированной Проверки Задач');
     Writeln(T,'# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
     Writeln(T,'#');
     Writeln(T,'# Каталог задач, принимаемых от учащихся');
     Writeln(T,'NewDir = ',NewDir);
     Writeln(T,'# Каталог тестов');
     Writeln(T,'TestDir = ',TestDir);
     Writeln(T,'# Каталог результатов');
     Writeln(T,'ResultsDir = ',ResultsDir);
     Writeln(T,'# Архив сведений об учащихся');
     Writeln(T,'PupilDir = ',PupilDir);
     Writeln(T,'# Имя файла исходных данных');
     Writeln(T,'InFile = ',InFile);
     Writeln(T,'# Имя файла выходных данных');
     Writeln(T,'OutFile = ',OutFile);
     Writeln(T,'# Время до отключения задачи (в секундах)');
     Writeln(T,'Time = ',TimeStr);
     Writeln(T,'# Конец файла');
     CloseFile(T);
   End;

procedure TMainWindow.EnterEvent(Sender: TObject);
begin
  NewDirEdit.Text:=NewDir;
  TestDirEdit.Text:=TestDir;
  ResultsDirEdit.Text:=ResultsDir;
  PupilDirEdit.Text:=PupilDir;
  InputFileEdit.Text:=InFile;
  OutputFileEdit.Text:=OutFile;
  TimeLimitEdit.Text:=TimeStr;
end;

procedure TMainWindow.StartApp(Sender: TObject);
Var CurDir:String; C:Word;
begin
  CurDir:=ParamStr(0);
  For C:=Length(CurDir) downto 1 do
    If CurDir[C]='\' then Break;
  If C > 1 then ChDir(Copy(CurDir,1,C));
  If Not FileExists('CONTEST.INI') then
    Begin
      GetDir(0,CurDir);
      NewDir:=CurDir+'\New';
      TestDir:=CurDir+'\Test';
      ResultsDir:=CurDir+'\Result';
      PupilDir:=CurDir+'\Pupil';
      InFile:='IN.TXT';
      OutFile:='OUT.TXT';
      TimeStr:='100';
    End
  Else
    ReadIniFile('CONTEST.INI');
end;

procedure TMainWindow.SaveEvent(Sender: TObject);
begin
  SetParams;
  SaveIni;
  Check;
end;

procedure TMainWindow.SaveApp(Sender: TObject; var Action: TCloseAction);
begin
  SetParams;
  SaveIni;
end;

end.
