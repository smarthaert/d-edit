{ 浜様様様様様様様様様様様様様様様様様様様様様融 }
{ �  ---=== Super Contest Judge ver1.0 ===---  � }
{ �      (c) Roman International Software      � }
{ �            Build 002 [20.11.99]            � }
{ 藩様様様様様様様様様様様様様様様様様様様様様夕 }
Uses CRT,DOS,Tools;

{$I-}

Var
  WorkDir   : String; { ��膈覃 ������� 痺れ� (� �������� JudgesDir) }
  FreeCode  : String; { ��� 瓣�｀き�痰� 痺れ� }
  BusyCode  : String; { ��� ���閧�痰� 痺れ� }
  TaskFile  : String; { �痳�き┴ 皀痰�珮ガ�� �牀������ }
  TestsDir  : String; { ������� � 皀痰��� }
  Tests     : Word; { ����腑痰〓 皀痰�� }
  TestsNum  : Word; { 蹍�ぅ��諷 皀痰�� }
  Time      : Word; { �爛�� �� ��Δ覃 皀痰 }
  Compiler  : String; { 鉘� � ����┼閧�珮 }

{ ---=== ���牀� �� 爛��痰��罔� 痺れ� ===--- }
 Procedure AskForRegistration;
   Var T:Text;
   Begin
     Writeln('[*] ��瘠��� ���牀� �� 爛��痰��罔� � 瓮燿ム� ...');
     Assign(T,RegisterFile);
     Repeat
       Rewrite(T);
     Until IOResult = 0;
     Close(T);
   End;

{ ---=== ����キ┘ ���牀�� �� 爛��痰��罔� ===--- }
 Procedure DelRegistation;
   Var T:Text;
   Begin
     Writeln('[*] ����闔 ���� ���牀�� ...');
     Assign(T,RegisterFile);
     While FSearch(RegisterFile,'')<>'' do Erase(T);
   End;

{ ---=== ｦ┐��┘ �癶モ� �� 瓮燿ム� ===--- }
 Procedure WaitServerAnswer;
   Begin
     Writeln('[*] �ゃ �癶モ� �� 瓮燿ム� ...');
     While FSearch(RegisterBackFile,'')='' do Delay(SystemDelay);
   End;

{ ---=== �皀�┘ 爛��痰�罔������ �癶モ� ===--- }
 Procedure ReadServerAnswer;
   Var T:Text;
   Begin
     Writeln('[*] ����� � 磴��闔 ���� �癶モ� ...');
     Assign(T,RegisterBackFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,WorkDir); Writeln('��｀腮� ������� = ',WorkDir);
     Readln(T,BusyCode); Writeln('��� ���閧�痰� = ',BusyCode);
     Readln(T,FreeCode); Writeln('��� 瓣�｀き�痰� = ',FreeCode);
     Erase(T);
   End;

{ ---=== �ィ�痰��罔� ===--- }
 Procedure Registration;
   Var T:Text;
   Begin
     AskForRegistration;
     WaitServerAnswer;
     DelRegistation;
     ReadServerAnswer;
   End;

{ ---=== �痰���→� 痰�矣�� 痺れ� ===--- }
 Procedure SetStatus( Status:String );
   Var T:Text;
   Begin
     Assign(T,StatusFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,Status);
     Close(T);
     If Status = FreeCode then
       Writeln('[*] ���矣� = �〓｀ぅ�')
     Else
       Writeln('[*] ���矣� = ���閧');
   End;

{ ---=== �皀�┘ ����� ������� ===--- }
 Procedure ReadServerTask;
   Var T:Text;
   Begin
     Writeln('[*] ����� ���� ������� � 磴��闔 ィ� ...');
     Assign(T,ServerFile);
     Repeat Reset(T); Until IOResult = 0;
     Readln(T,TaskFile); Writeln('��� ����� ����腮 = ',TaskFile);
     Readln(T,Compiler); Writeln('��� ����┼閧��� = ',Compiler);
     Readln(T,TestsDir); Writeln('������� 皀痰�� = ',TestsDir);
     Readln(T,Tests); Writeln('����腑痰〓 皀痰�� = ',Tests);
     Readln(T,Time); Writeln('�爛�� �� ���覃 皀痰 (瓮�) = ',Time);
     Erase(T);
   End;

{ ---=== ����珮ガ � ����┼�珮ガ �痳�き┴ ===--- }
 Procedure CompileSource;
   Begin
    { ����珮ガ �痳�き┴ }
     Writeln('[*] ����珮� �痳�き覃 皀�痰 ...');
     CopyFile(TaskFile,SourceTaskFile);
    { 蹍▲瑙ガ �� ���爛薀��襯 ┃痰珮�罔� }
     Writeln('[*] 蹍▲瑙� �� �イ��竅皋�襯 ┃痰珮�罔� ...');
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
    { ����┼�珮ガ ィ� }
     Writeln('[*] ����┼�珮� �痳�き覃 皀�痰 ...');
     SwapVectors;
     Exec(Compiler,SourceTaskFile);
     SwapVectors;
     If ((DosExitCode<>0) Or (DosError<>0)) then
       Begin
         Writeln('[DosExitCode]: ',DosExitCode);
         Result:=CompilationError;
       End;
   End;

{ ---=== ���竅� �牀������ ===--- }
 Procedure ExecuteProg( Prg:String );
   Var T:Text; _DosError_,_DosExitCode_:Integer;
   Begin
     Writeln('[*] ����瘠��� �━�� ∇ガキ� � TIMER.TXT ...');
     Assign(T,'TIMER.TXT');
     Rewrite(T);
     Writeln(T,Time*19); { � ����甌� ! }
     Close(T);
     Writeln('[*] ���竅��� ',ExecUtil,' ...');
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
     Writeln('[*] ��┼├�珮� �癶モ ',ExecUtil,' ...');
     While FSearch('TimerOK.TXT','')='' do
       Begin
         Writeln('[*] 踳�謌キ┘ �━��� ∇ガキ� !');
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

{ ---=== �メ皋珮ガ �牀������ ===--- }
 Procedure TestSource;
   Var I:Word;
   Begin
     TestsNum:=0;
     If Result = NoError then
       For I:=1 to Tests do
         Begin
           TestsNum:=I-1;
           Writeln('[*] �メ� ���ム ',I);
           CopyFile(TestsDir+'\INPUT'+AddNumStr(I,'0',2)+'.TXT','INPUT.TXT');
           ExecuteProg(WorkTaskFile);
           If Result <> NoError then Break;
           CompareFiles(TestsDir+'\OUTPUT'+AddNumStr(I,'0',2)+'.TXT','OUTPUT.TXT');
           If Result <> NoError then Break;
         End;
   End;

{ ---=== ����瘠��ガ 爛с�赳�硅 ===--- }
 Procedure WriteResult;
   Var T:Text;
   Begin
     Writeln('[*] ����瘠��� 爛с�赳�� : ',ErrorText(Result));
     Assign(T,ResultsFile);
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,TestsNum);
     Writeln(T,ErrorNum(Result));
     Close(T);
   End;

{ ---=== ｯ牀� 瓮燿ム� ===--- }
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

{ ---=== ｯ牀� �� �����ゃ ��▲琥キ�� ��｀硅 ===--- }
 Function ListenTermination:Boolean;
   Begin
     ListenTermination:=(FSearch(UnregisterFile,'')<>'');
   End;

{ ---=== � �牀������ ===--- }
 Procedure About;
   Begin
     Writeln;
     TextColor(15); Writeln('---=== Super Contest Judge ver1.0 ===---');
     TextColor(11); Writeln('    (c) Roman International Software');
     TextColor(09); Writeln('          Build 002 [18.11.99]');
     Writeln;
   End;

{ ---=== ����蛹 ===--- }
 Procedure Help;
   Begin
     TextColor(12); Write('     JUDGE ');
     TextColor(13); Write('<');
     TextColor(14); Write('鉘� � ������ｃ 痺ぅ�');
     TextColor(13); Writeln('>');
   End;

{ ---=== ��｀�� 痺れ� � �������� 痺ぅ� ===--- }
 Procedure JudgeWork;
   Begin
     TextColor(10);
    { �ィ�痰��罔� }
     Registration;
    { ��｀��ガ � ��膈�� �������� }
     ChDir(WorkDir);
    { 踸�━�ガ ����腮 �� 瓮燿ム� }
     Writeln('[*] 踸�━�� ����腮 �� 瓮燿ム� ...');
     SetStatus(FreeCode);
     Repeat
       ListenTasks;
       Delay(SystemDelay);
     Until ListenTermination;
    { �ムュ�え� � �痳�き覃 ������� � ��も���ガ 瓣�� 甌＝癶キ�覃 }
     ChDir('..');
     DelTree(WorkDir);
     Writeln('[*] �諷��� � ��ム�罔���竡 瓱痰ガ� ...');
   End;

{ ---=== �甅�↓�� 蹍������ ===--- }
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
