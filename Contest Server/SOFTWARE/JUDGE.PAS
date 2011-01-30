{ ��������������������������������������������ͻ }
{ �  ---=== Super Contest Judge ver1.0 ===---  � }
{ �      (c) Roman International Software      � }
{ �            Build 002 [20.11.99]            � }
{ ��������������������������������������������ͼ }
Uses CRT,DOS,Tools;

{$I-}

Var
  WorkDir   : String; { ���� ��⠫�� ��� (� ��⠫��� JudgesDir) }
  FreeCode  : String; { ��� ᢮������� ��� }
  BusyCode  : String; { ��� ������� ��� }
  TaskFile  : String; { ��室��� ����㥬�� �ணࠬ�� }
  TestsDir  : String; { ��⠫�� � ��⠬� }
  Tests     : Word; { ������⢮ ��⮢ }
  TestsNum  : Word; { �ன������ ��⮢ }
  Time      : Word; { �६� �� ����� ��� }
  Compiler  : String; { ���� � ���������� }

{ ---=== ����� �� ॣ������ ��� ===--- }
 Procedure AskForRegistration;
   Var T:Text;
   Begin
     Writeln('[*] ���뫠� ����� �� ॣ������ � �ࢥ�� ...');
     Assign(T,RegisterFile);
     Repeat
       Rewrite(T);
     Until IOResult = 0;
     Close(T);
   End;

{ ---=== �������� ����� �� ॣ������ ===--- }
 Procedure DelRegistation;
   Var T:Text;
   Begin
     Writeln('[*] ������ 䠩� ����� ...');
     Assign(T,RegisterFile);
     While FSearch(RegisterFile,'')<>'' do Erase(T);
   End;

{ ---=== �������� �⢥� �� �ࢥ� ===--- }
 Procedure WaitServerAnswer;
   Begin
     Writeln('[*] ��� �⢥� �� �ࢥ� ...');
     While FSearch(RegisterBackFile,'')='' do Delay(SystemDelay);
   End;

{ ---=== �⥭�� ॣ���樮����� �⢥� ===--- }
 Procedure ReadServerAnswer;
   Var T:Text;
   Begin
     Writeln('[*] ���� � 㤠��� 䠩� �⢥� ...');
     Assign(T,RegisterBackFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,WorkDir); Writeln('����稩 ��⠫�� = ',WorkDir);
     Readln(T,BusyCode); Writeln('��� ������� = ',BusyCode);
     Readln(T,FreeCode); Writeln('��� ᢮������� = ',FreeCode);
     Erase(T);
   End;

{ ---=== ��������� ===--- }
 Procedure Registration;
   Var T:Text;
   Begin
     AskForRegistration;
     WaitServerAnswer;
     DelRegistation;
     ReadServerAnswer;
   End;

{ ---=== ��⠭���� ����� ��� ===--- }
 Procedure SetStatus( Status:String );
   Var T:Text;
   Begin
     Assign(T,StatusFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,Status);
     Close(T);
     If Status = FreeCode then
       Writeln('[*] ����� = ��������')
     Else
       Writeln('[*] ����� = �����');
   End;

{ ---=== �⥭�� 䠩�� ������� ===--- }
 Procedure ReadServerTask;
   Var T:Text;
   Begin
     Writeln('[*] ���� 䠩� ������� � 㤠��� ��� ...');
     Assign(T,ServerFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,TaskFile); Writeln('��� 䠩�� ����� = ',TaskFile);
     Readln(T,Compiler); Writeln('��� ��������� = ',Compiler);
     Readln(T,TestsDir); Writeln('��⠫�� ��⮢ = ',TestsDir);
     Readln(T,Tests); Writeln('������⢮ ��⮢ = ',Tests);
     Readln(T,Time); Writeln('�६� �� ���� ��� (ᥪ) = ',Time);
     Erase(T);
   End;

{ ---=== �����㥬 � ��������㥬 ��室��� ===--- }
 Procedure CompileSource;
   Begin
    { �����㥬 ��室��� }
     Writeln('[*] ������� ��室�� ⥪�� ...');
     CopyFile(TaskFile,SourceTaskFile);
    { �஢��塞 �� ����饭�� ������樨 }
     Writeln('[*] �஢���� �� �������⨬� ������樨 ...');
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
    { ��������㥬 ��� }
     Writeln('[*] ���������� ��室�� ⥪�� ...');
     SwapVectors;
     Exec(Compiler,SourceTaskFile);
     SwapVectors;
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         Writeln('[DosExitCode]: ',DosExitCode);
         Result:=CompilationError;
       End;
   End;

{ ---=== ����� �ணࠬ�� ===--- }
 Procedure ExecuteProg( Prg:String );
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
     Writeln('[*] �����뢠� ����� �६��� � TIMER.TXT ...');
     Assign(T,'TIMER.TXT');
     Rewrite(T);
     Writeln(T,Time*19); { � ����ᮬ ! }
     Close(T);
     Writeln('[*] ����᪠� ',ExecUtil,' ...');
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
     Writeln('[*] ���������� �⢥� ',ExecUtil,' ...');
     While FSearch('TimerOK.TXT','')='' do
       Begin
         Writeln('[*] �ॢ�襭�� ����� �६��� !');
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

{ ---=== �����㥬 �ணࠬ�� ===--- }
 Procedure TestSource;
   Var I:Word;
   Begin
     TestsNum:=0;
     If Result = NoError then
       For I:=1 to Tests do
         Begin
           TestsNum:=I-1;
           Writeln('[*] ���� ����� ',I);
           CopyFile(TestsDir+'\INPUT'+AddNumStr(I,'0',2)+'.TXT','INPUT.TXT');
           ExecuteProg(WorkTaskFile);
           If Result <> NoError then Break;
           CompareFiles(TestsDir+'\OUTPUT'+AddNumStr(I,'0',2)+'.TXT','OUTPUT.TXT');
           If Result <> NoError then Break;
         End;
   End;

{ ---=== �����뢠�� १����� ===--- }
 Procedure WriteResult;
   Var T:Text;
   Begin
     Writeln('[*] �����뢠� १���� : ',ErrorText(Result));
     Assign(T,ResultsFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,TestsNum);
     Writeln(T,ErrorNum(Result));
     Close(T);
   End;

{ ---=== ���� �ࢥ� ===--- }
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

{ ---=== ���� �� ������� �����襭�� ࠡ��� ===--- }
 Function ListenTermination:Boolean;
   Begin
     ListenTermination:=(FSearch(UnregisterFile,'')<>'');
   End;

{ ---=== � �ணࠬ�� ===--- }
 Procedure About;
   Begin
     Writeln;
     TextColor(15); Writeln('---=== Super Contest Judge ver1.0 ===---');
     TextColor(11); Writeln('    (c) Roman International Software');
     TextColor(09); Writeln('          Build 002 [18.11.99]');
     Writeln;
   End;

{ ---=== ������ ===--- }
 Procedure Help;
   Begin
     TextColor(12); Write('     JUDGE ');
     TextColor(13); Write('<');
     TextColor(14); Write('���� � ��⠫��� �㤥�');
     TextColor(13); Writeln('>');
   End;

{ ---=== ����� ��� � ��⠫��� �㤥� ===--- }
 Procedure JudgeWork;
   Begin
     TextColor(10);
    { ��������� }
     Registration;
    { ����⠥� � ��筮� ��⠫��� }
     ChDir(WorkDir);
    { �ਭ����� ����� �� �ࢥ� }
     Writeln('[*] �ਭ���� ����� �� �ࢥ� ...');
     SetStatus(FreeCode);
     Repeat
       ListenTasks;
       Delay(SystemDelay);
     Until ListenTermination;
    { ���室�� � ��室�� ��⠫�� � ����ࠥ� ᢮� ᮡ�⢥��� }
     ChDir('..');
     DelTree(WorkDir);
     Writeln('[*] ��宦� � ����樮���� ��⥬� ...');
   End;

{ ---=== �᭮���� �ணࠬ�� ===--- }
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