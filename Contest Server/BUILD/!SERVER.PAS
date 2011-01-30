{ ��������������������������������������������ͻ }
{ �  ---=== Super Contest Server v0.99 ===---  � }
{ �      (c) Roman International Software      � }
{ �            Build 002 [18.11.99]            � }
{ ��������������������������������������������ͼ }
Uses CRT,DOS,Tools,_LOG_;

{$I-}

{ ---=== �६� ===--- }
 Const StartContestHour   : Byte    = 0;
       StartContestMinute : Byte    = 0;
       CurTime            : LongInt = 0;
       AllContestTime     : LongInt = 9999;
       TimeLeft           : LongInt = 9999;

{$I TASKMAN1.INC}

{ ������������������������������������������������������������������ͻ }
{ � �                 � � � � � � � �   � � � � �                  � � }
{ ������������������������������������������������������������������ͼ }

{ ---=== �।��।������ ������� ===--- }
 Procedure Command( CmdStr:String ); Forward;

{ ---=== ���� �ॢ������� ===--- }
 Const Contest : Boolean = False;

{ ---=== ������⢮ ������� ===--- }
 Const LastProblem:Char = 'A';



{ ��������������������������������������������������������������������ͻ }
{ � �                   � � � � � � � � � � � �                      � � }
{ ��������������������������������������������������������������������ͼ }

Type
 { = = = ����ﭨ� ����� = = = }
  TTaskFlag = (_New_,_Judge_,_Done_);

{ ---=== ����� � ���ﭨ� ����� ===--- }
 Function FlagText( Flag:TTaskFlag ):String;
   Begin
     Case Flag of
       _New_   : FlagText:='����� ⮫쪮 �� ����㯨��';
       _Judge_ : FlagText:='����� �������� ��쥩';
       _Done_  : FlagText:='����� �����஢���';
     End;
   End;

Type
 { = = = ����⪠ = = = }
  PTry = ^TTry;
  TTry = Record
    Number  : Word; { ����� ����⪨ �।� ��� }
    NumberP : Word; { ����� ����⪨ �� �⮩ �஡���� }
    Problem : Char; { ������� }
    Time    : Word; { �६� ��室� }
    Tests   : Byte; { ������� ��⮢ }
    Flag    : TTaskFlag; { ����ﭨ� ����� }
    Judge   : Byte; { ����� ��� }
    Error   : TError; { ��� �訡�� }
    Next    : PTry; { �������� ����⪠ }
  End;
 { = = = ���ଠ�� � ���짮��⥫� = = = }
  PUser = ^TUser;
  TUser = Record
    Rank    : Word; { ����襥 ���� }
    Number  : Word; { ����� ������� }
    Name    : String[32]; { ��� ���짮��⥫� }
    Tests   : Word; { �ᥣ� �ன���� ��⮢ }
    Time    : Word; { ���䭮� �६� }
    TryList : PTry; { ���᮪ ����⮪ }
    Next    : PUser; { ������騩 ���짮��⥫� }
  End;

{ ---=== ���᮪ ���짮��⥫�� ===--- }
 Const UsersList : PUser = nil;

{ ---=== ���� ��������� ⠡���� ���짮��⥫�� ===--- }
 Const UsersChange : Boolean = True;

{ ---=== ���������� ���짮��⥫� ===--- }
 Procedure AddUserCommand( UserName:String );
   Var NewUser,User:PUser; Num:Word;
   Begin
     Message('[><] ���������� ���짮��⥫� : '+UserName);
     New(NewUser);
    { ���뢠�� � ᯨ᪮� }
     User:=UsersList;
     If User<>nil then
       Begin
         Num:=User^.Number;
         While User^.Next<>nil do
           Begin
             User:=User^.Next;
             If User^.Number>Num then Num:=User^.Number;
           End;
         User^.Next:=NewUser;
         Inc(Num);
       End
     Else
       Begin
         UsersList:=NewUser;
         Num:=1;
       End;
    { ������塞 ���� }
     With NewUser^ do
       Begin
         Rank    := 0;
         Number  := Num;
         Name    := UserName;
         Tests   := 0;
         Time    := 0;
         TryList := nil;
         Next    := nil;
       End;
   End;

{ ---=== �������� ����⮪ ===--- }
 Procedure DelTryList( TryList:PTry );
   Var Try:PTry;
   Begin
     While TryList<>nil do
       Begin
         Try:=TryList^.Next;
         Dispose(TryList);
         TryList:=Try;
       End;
   End;

{ ---=== �������� ���짮��⥫� ===--- }
 Procedure DelUserCommand( Number:String );
   Var Prev,User:PUser; N:LongInt;
   Begin
     Message('[><] �������� ���짮��⥫� : '+Number);
     N:=StrNum(Number);
     If N=MaxLongInt then
       Begin Message('[!] DelUser <����� ���짮��⥫�> [!]'); Exit; End;
     Prev:=nil;
     User:=UsersList;
     While ((User<>nil) And (User^.Number<>N)) do
       Begin
         Prev:=User;
         User:=User^.Next;
       End;
     If User<>nil then
       Begin
         If Prev<>nil then
           Prev^.Next:=User^.Next
         Else
           UsersList:=User^.Next;
         DelTryList(User^.TryList);
         Dispose(User);
       End
     Else
       Message('[Error]: ���짮��⥫� � ⠪�� ����஬ �� �����㦥� !');
   End;

{ ---=== �������� ��� ���짮��⥫�� �� ᯨ᪠ ===--- }
 Procedure DelAllUsersCommand;
   Var User:PUser; Try:PTry;
   Begin
     Message('[><] �������� ��� ���짮��⥫��');
     While UsersList<>nil do
       Begin
         User:=UsersList^.Next;
         DelTryList(UsersList^.TryList);
         Dispose(UsersList);
         UsersList:=User;
       End;
   End;

{ ---=== ���᮪ ���짮��⥫�� ===--- }
 Procedure UsersListCommand;
   Var User:PUser;
   Begin
     Message(' ---=== ���᮪ ���짮��⥫�� ===---');
     User:=UsersList;
     While User<>nil do
       With User^ do
         Begin
           Message(AddNumStr(Number,'0',2)+'  '+
                   AddNumStr(Rank,' ',2)+
                   '   ���⮢ '+AddNumStr(Tests,' ',4)+
                   '   �६� ' +AddNumStr(Time,' ',4)+
                   '   '+Name);
           User:=Next;
         End;
   End;

{ ---=== �������� ��⠫��� INFO ===--- }
 Procedure CreateInfoDir;
   Begin
     Message('[<>]: ���뢠� ��⠫�� INFO');
     DelTree(InfoDir);
     MakeDir(InfoDir);
     CopyFile(TasksDir+'\TASKS.TXT',InfoDir+'\TASKS.TXT');
   End;

{ ---=== �������� ��⠫��� WORK ===--- }
 Procedure CreateWorkDir;
   Var User:PUser; F:File; Dir:String;
   Begin
     Message('[<>]: ���뢠� ��⠫�� WORK');
     DelTree(WorkDir);
     MakeDir(WorkDir);
     GetDir(0,Dir);
     ChDir(WorkDir);
     User:=UsersList;
     While User<>nil do
       Begin
         MakeDir(AddNumStr(User^.Number,'0',2));
         User:=User^.Next;
       End;
     ChDir(Dir);
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �                        � � � � � � �                           � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ������⢮ ����⮪ (�ᥣ�) ===--- }
 Function TryNum( TryList:PTry ):Word;
   Var Try:PTry;
   Begin
     TryNum:=0;
     Try:=TryList;
     While Try<>nil do
       Begin
         TryNum:=Try^.Number;
         Try:=Try^.Next;
       End;
   End;

{ ---=== ������⢮ ����⮪ (�� ������) ===--- }
 Function TryNumP( TryList:PTry; Problem:Char ):Word;
   Var Try:PTry;
   Begin
     TryNumP:=0;
     Try:=TryList;
     While Try<>nil do
       Begin
         If Try^.Problem = Problem then TryNumP:=Try^.NumberP;
         Try:=Try^.Next;
       End;
   End;

{ ---=== �६� ��室� ���ᨬ��쭮�� ��� ===--- }
 Var MaxTestsTime : Word;

{ ---=== ���ᨬ��쭮 ��⮢ ===--- }
 Function MaxTests( TryList:PTry; Problem:Char ):Word;
   Var Try:PTry; Max:Word;
   Begin
     Max:=0;
     MaxTestsTime:=0;
     Try:=TryList;
     While Try<>nil do
       Begin
         If ((Try^.Problem = Problem) And (Try^.Tests > Max)) then
           Begin
             Max:=Try^.Tests;
             MaxTestsTime:=Try^.Time;
           End;
         Try:=Try^.Next;
       End;
     MaxTests:=Max;
   End;

{ ---=== �뢮� ᯨ᪠ ����⮪ ===--- }
 Procedure ShowTryList( Var T:Text; TryList:PTry; Problem:Char );
   Begin
     Write(T,(NumStr(TryNumP(TryList,Problem))+'/'+
              NumStr(MaxTests(TryList,Problem))):7);
   End;

{ ---=== ������ ������⥫�� ���짮��⥫� ===--- }
 Procedure CountUser( User:PUser );
   Var Problem:Char; _Tests_,_Time_:Word;
   Begin
     User^.Tests:=0;
     User^.Time:=0;
     For Problem:='A' to LastProblem do
       Begin
         _Tests_:=MaxTests(User^.TryList,Problem);
         _Time_:=MaxTestsTime;
         If _Tests_ > 0 then
           User^.Time:=User^.Time+_Time_+
                       (TryNumP(User^.TryList,Problem)-1)*20;
         User^.Tests:=User^.Tests+_Tests_;
       End;
   End;

{ ---=== �뢮� ���ଠ樨 � ���짮��⥫� ===--- }
 Procedure ShowUserInfo( Var T:Text; User:PUser );
   Var C:Char;
   Begin
     With User^ do
       Begin
         Write(T,User^.Rank:2,' ',AddSym(User^.Name,' ',16));
         For C:='A' to LastProblem do ShowTryList(T,TryList,C);
         Writeln(T,' ',Tests:5,' ',Time:5);
       End;
   End;

{ ---=== ���ᨢ ���짮��⥫�� ===--- }
 Type
   UserRec = Record
     _User_ : PUser;
     Number : LongInt;
   End;
   TUserRecs = Array [1..$0FFFF div SizeOf(UserRec)] of UserRec;
   PUserRecs = ^TUserRecs;

{ ---=== ������ ===--- }
 Procedure Monitor;
   Var T:Text; User:PUser; N,I,J:Word; C:Char; Users:PUserRecs; L:LongInt;
   Begin
     Message('[Monitor]: ������� MONITOR.TXT');
    { ������ ������⢠ ��⮢ � �६��� }
     User:=UsersList;
     While User<>nil do
       Begin
         CountUser(User);
         User:=User^.Next;
       End;
    { ���뢠�� 䠩� ������ }
     Assign(T,InfoDir+'\MONITOR.TXT'); Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ MONITOR.TXT'); Exit; End;
    { ��������� }
     Write(T,'   '+AddSym('�������',' ',18));
     For C:='A' to LastProblem do Write(T,'   ',C,'   ');
     Writeln(T,'Tests Time');
     N:=(Ord(LastProblem)-Ord('A'))*7+39;
     For I:=1 to N do Write(T,'='); Writeln(T);
    { ������ ������⢠ ���짮��⥫�� }
     N:=0;
     User:=UsersList;
     While User<>nil do
       Begin
         Inc(N);
         User:=User^.Next;
       End;
    { ������塞 ���ᨢ ���짮��⥫�� }
     GetMem(Users,N*SizeOf(UserRec));
     N:=0;
     User:=UsersList;
     While User<>nil do
       Begin
         Inc(N);
         Users^[N]._User_ := User;
         Users^[N].Number := User^.Tests*1000000-User^.Time;
         User:=User^.Next;
       End;
    { �����㥬 ���ᨢ ���짮��⥫�� }
     For I:=1 to (N-1) do
       For J:=I to N do
         If Users^[I].Number < Users^[J].Number then
           Begin
             User:=Users^[I]._User_;
             L:=Users^[I].Number;
             Users^[I]._User_:=Users^[J]._User_;
             Users^[I].Number:=Users^[J].Number;
             Users^[J]._User_:=User;
             Users^[J].Number:=L;
           End;
    { �뢮��� ���짮��⥫�� }
     For I:=1 to N do
       With Users^[I] do
         Begin
           _User_^.Rank:=I;
           ShowUserInfo(T,_User_);
         End;
     FreeMem(Users,N*SizeOf(UserRec));
    { �����⨥ }
     Close(T);
     UsersChange:=False;
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �              � � � � �   � � � � � � � � � � � � �             � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ��।�� ����饭�� ===--- }
 Procedure UserMessage( UserName,FileName:String );
   Var T:Text; S:String;
   Begin
     Message(' ---=== Message from '+UserName+' ===---');
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ '+FileName); Exit; End;
     Repeat
       Readln(T,S);
       Message('> '+S);
     Until EOF(T);
     Close(T);
     DelFile(FileName);
   End;

{ ---=== ���� ���짮��⥫�� ===--- }
 Type
   PUsersTask = ^TUsersTask;
   TUsersTask = Object(TTask)
     Procedure Init; Virtual;
     Procedure Done; Virtual;
     Procedure GetProblem( C:Char; User:PUser );
     Procedure Run; Virtual;
   End;

 Procedure TUsersTask.Init;
   Var User:PUser;
   Begin
     Message('[*] ���뢠� ��⠫�� ���짮��⥫�� [*]');
     DelTree(UsersDir);
     MakeDir(UsersDir);
     User:=UsersList;
     While User<>nil do
       Begin
         MakeDir(UsersDir+'\'+AddNumStr(User^.Number,'0',2));
         Writeln(LOG,'[TUsersTask.Init]: ������ ��⠫�� '+UsersDir+'\'
                               +AddNumStr(User^.Number,'0',2));
         User:=User^.Next;
       End;
   End;

 Procedure TUsersTask.Done;
   Var Dir:String;
   Begin
     Writeln(LOG,'[*] ����뢠� ��⠫�� ���짮��⥫�� [*]');
     DelTree(UsersDir);
   End;

 Procedure TUsersTask.GetProblem( C:Char; User:PUser );
   Var PrvTry,NewTry:PTry; N1,N2:Word;
   Begin
     Message('[Users]: ��襫 '+C+'.PAS �� '+User^.Name);
    { PrvTry := �ॢ����� ����⪠ }
     PrvTry:=nil;
     NewTry:=User^.TryList;
     While NewTry<>nil do
       Begin
         PrvTry:=NewTry;
         NewTry:=NewTry^.Next;
       End;
     Writeln(LOG,'������뢠� ��饥 ������⢮ ����⮪');
     N1:=TryNum(User^.TryList)+1;
     Writeln(LOG,'������뢠� ������⢮ ����⮪ �� ��� ������');
     N2:=TryNumP(User^.TryList,C)+1;
     Writeln(LOG,'������� ����� ������');
     New(NewTry);
     If PrvTry<>nil then
       PrvTry^.Next:=NewTry
     Else
       User^.TryList:=NewTry;
     Writeln(LOG,'�������� ���� ����⪨');
     With NewTry^ do
       Begin
         Number  := N1;
         NumberP := N2;
         Problem := C;
         Time    := CurTime;
         Tests   := 0;
         Flag    := _New_;
         Judge   := 0;
         Error   := NoError;
         Next    := nil;
       End;
    { ����஢���� 䠩�� }
     Writeln(LOG,'������� 䠩� '+C+'.PAS -> '+
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
     CopyFile(C+'.PAS',
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
    { �������� 䠩�� }
     Writeln(LOG,'������ 䠩� '+C+'.PAS');
     DelFile(C+'.PAS');
   End;

 Procedure TUsersTask.Run;
   Var User:PUser; C:Char; CurDir,Dir:String;
   Begin
     GetDir(0,CurDir);
     ChDir(UsersDir);
     User:=UsersList;
     While User<>nil do
       Begin
         Dir:=AddNumStr(User^.Number,'0',2);
         ChDir(Dir);
        { ���� ����� }
         For C:='A' to LastProblem do
           If FSearch(C+'.PAS','')<>'' then
             GetProblem( C,User );
        { ���� ᮮ�饭�� }
         If FSearch('MESSAGE.TXT','')<>'' then
           UserMessage(User^.Name,'MESSAGE.TXT');
         ChDir('..');
        { ���室 � ᫥���饬� ���짮��⥫� }
         User:=User^.Next;
       End;
     ChDir(CurDir);
     If UsersChange then Monitor;
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �                   � � � � � � � � � � � �                      � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ��ॢ������� ===--- }
 Type
   PContestTask = ^TContestTask;
   TContestTask = Object(TTask)
     Counter : Word;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
   End;

 Procedure TContestTask.Init;
   Begin
     Message('>>> ��砫� �ॢ������� <<<');
     CreateWorkDir;
     CreateInfoDir;
     Contest:=True;
     Counter:=0;
     Writeln(LOG,'[Contest.Init]: �믮������ ������� OpenUsers');
     Command('OpenUsers');
   End;

 Procedure TContestTask.Run;
   Begin
     If Counter=1 then
       Begin
         Message('Start Contest Time : '+AddNumStr(CurHour,'0',2)+':'
                                      +AddNumStr(CurMinute,'0',2)+':'
                                      +AddNumStr(CurSecond,'0',2));
         StartContestHour   := CurHour;
         StartContestMinute := CurMinute;
       End;
     If ((TimeLeft = 0) And (Counter>1)) then
       Begin
         Command('CloseUsers');
         Contest:=False;
         Message('>>> ����� �ॢ������� <<<');
         TaskManager.DelTask(Name,Numb);
       End;
     Inc(Counter);
     If Counter > 32000 then Counter:=32000;
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �                         � � � � �                              � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ���� ===--- }
 Type
   PJudge = ^TJudge;
   TJudge = Record
     Number    : Word; { ����� ��� }
     Directory : String; { ����稩 ��⠫�� }
     FreeCode  : String; { ��� ᢮������� }
     BusyCode  : String; { ��� ������� }
     FreeFlag  : Boolean; { �������� �� ᥩ�� }
     User,Try  : Word; { ��ࠡ��뢠���� ����� }
     Problem   : Char; { ��������� ������� }
     Time      : Word; { �६� ���뫪� ����� }
     Next      : PJudge; { ������騩 ���� }
   End;

{ ---=== ���᮪ �㤥� ===--- }
 Const JudgesList : PJudge = nil;

{ ---=== �뢮� ᯨ᪠ �㤥� ===--- }
 Procedure ShowJudgesList;
   Var Judge:PJudge;
   Begin
     Message(' ---=== ���᮪ �㤥� ===---');
     Judge:=JudgesList;
     While Judge<>nil do
       Begin
         Message('Judge : '+Judge^.Directory);
         Judge:=Judge^.Next;
       End;
   End;

{ ---=== �����襭�� ��� ===--- }
 Procedure ShutDownJudge( Dir:String );
   Var T:Text;
   Begin
     Writeln(LOG,'������� ���� '+Dir+'\UNREG.TXT');
     Assign(T,Dir+'\UNREG.TXT');
     Rewrite(T); Close(T);
   End;

{ ---=== ��ࠡ�⪠ �㤥� ===--- }
 Type
   PJudgesTask = ^TJudgesTask;
   TJudgesTask = Object(TTask)
     Procedure Init; Virtual;
     Procedure Done; Virtual;
     Procedure Run; Virtual;
   End;

 Procedure TJudgesTask.Init;
   Begin
     Message('[Judges.Init]: ���樠������ ��⥬� �㤥� ...');
     DelTree(JudgesDir);
     MakeDir(JudgesDir);
   End;

 Procedure TJudgesTask.Done;
   Var Judge:PJudge;
   Begin
     Writeln(LOG,'[Judges.Done]: �����襭�� ��⥬� �㤥� ...');
     While JudgesList<>nil do
       Begin
         ShutDownJudge(JudgesDir+'\'+AddNumStr(JudgesList^.Number,'0',2));
         Judge:=JudgesList^.Next;
         Dispose(JudgesList);
         JudgesList:=Judge;
       End;
   End;

 Procedure JudgesGiveTry( Judge:PJudge; User:PUser; Try:PTry );
   Var _Tests,_Time:Word; T:Text; S:String; GoodAnswer:Boolean;
   Begin
     Message('[JudgesGiveTry]: �⤠� ������ ��� '+NumStr(Judge^.Number));
     Judge^.FreeFlag := False;
     Judge^.User     := User^.Number;
     Judge^.Try      := Try^.Number;
     Judge^.Time     := CurTime;
     Judge^.Problem  := Try^.Problem;
     Try^.Flag       := _Judge_;
     Try^.Judge      := Judge^.Number;
    { �⥭�� TIME.TXT }
     Message('[JudgesGiveTry]: ���� '+TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Assign(T,TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Repeat Reset(T); Until IOResult=0;
     Readln(T,_Tests);
     Readln(T,_Time);
     Close(T);
    { ������ ������� ��� }
    {  - ��� 䠩�� ����� }
    {  - ��� ��������� }
    {  - ��⠫�� ��⮢ }
    {  - ������⢮ ��⮢ }
    {  - �६� �� ���� ��� (� ᥪ㭤��) }
     Message('[JudgesGiveTry]: ���� TASK.TXT');
     Assign(T,'TASK.TXT');
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+
               Try^.Problem+AddNumStr(Try^.NumberP,'0',4)+'.PAS');
     Writeln(T,'F:\SOFTWARE\BP\BIN\TPC.EXE');
     Writeln(T,TasksDir+'\TESTS\'+Try^.Problem);
     Writeln(T,_Tests);
     Writeln(T,_Time);
     Close(T);
     Message('[JudgesGiveTry]: ��� �⢥� ���');
     GoodAnswer:=False;
     Repeat
       If FSearch('STATUS.TXT','')<>'' then
         Begin
           Assign(T,'STATUS.TXT');
           Repeat Reset(T); Until IOResult=0;
           Readln(T,S);
           Close(T);
           GoodAnswer := (S = Judge^.FreeCode);
         End;
     Until GoodAnswer;
     Message('[JudgesGiveTry]: ���� �⢥⨫');
   End;

 Procedure JudgesWork( Judge:PJudge );
   Var User:PUser; Try:PTry; T:Text;
   Begin
     User:=UsersList;
     While User<>nil do
       Begin
         Try:=User^.TryList;
         While Try<>nil do
           Begin
             If Try^.Flag=_New_ then JudgesGiveTry(Judge,User,Try);
             Try:=Try^.Next;
           End;
         User:=User^.Next;
       End;
   End;

 Procedure JudgesResults( Judge:PJudge );
   Var T:Text; _Tests:Word; User:PUser; Try:PTry; N:Word;
   Begin
     If FSearch('RESULTS.TXT','')<>'' then
       Begin
         Message('��ࠡ��뢠� १����� ��� '+NumStr(Judge^.Number));
         UsersChange:=True;
         Assign(T,'RESULTS.TXT');
         Reset(T);
         If IOResult<>0 then Exit;
         Readln(T,_Tests);
         Readln(T,N);
         Result:=ErrorSrc(N);
         Erase(T);
         Message('[Judges]: �����஢�� '+Judge^.Problem+'.PAS �� '+
                 NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
        { ���뫠�� ᮮ�饭�� ���짮��⥫� }
         Message('���뫠�� ᮮ�饭�� ���짮��⥫�');
         Assign(T,UsersDir+'\'+AddNumStr(Judge^.User,'0',2)+'\MESSAGES.TXT');
         Append(T);
         If IOResult<>0 then Rewrite(T);
         Writeln(T,'======================================');
         Writeln(T,'�����஢�� '+Judge^.Problem+'.PAS �� '+
                   NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
         Writeln(T,'�ன���� ��⮢ '+NumStr(_Tests));
         Writeln(T,ErrorText(Result));
         Close(T);
        { �饬 ���짮��⥫� }
         User:=UsersList;
         While User<>nil do
           Begin
             If User^.Number = Judge^.User then Break;
             User:=User^.Next;
           End;
         If User = nil then Exit;
        { �饬 ������ }
         Try:=User^.TryList;
         N:=0;
         While Try<>nil do
           Begin
             Inc(N);
             If N = Judge^.Try then Break;
             Try:=Try^.Next;
           End;
         If Try = nil then Exit;
        { �����塞 ⠡���� १���⮢ }
         Message('�����塞 ⠡���� १���⮢');
         With Try^ do
           Begin
             Tests := _Tests;
             Flag  := _Done_;
             Error := Result;
           End;
       End;
   End;

 Procedure TJudgesTask.Run;
   Var CurDir:String; N:Word; Judge:PJudge; T:Text; Stat:String; F:File;
   Begin
     GetDir(0,CurDir);
    { ���������/ࠧॣ������ �㤥� }
     ChDir(JudgesDir);
    { ����� �� ॣ������. ����� -���⮩. }
     If ((FSearch('REGISTER.TXT','')<>'') And
         (FSearch('REGBACK.TXT','')='')) then
       Begin
         Message('[TJudgesTask]: ��襫 REGISTER.TXT');
        { ������ ������⢠ �㤥� }
         Judge:=JudgesList;
         N:=1;
         While Judge<>nil do
           Begin
             Inc(N);
             Judge:=Judge^.Next;
           End;
         Message('[TJudgesTask]: ������ ��⠫�� '+JudgesDir+'\'+AddNumStr(N,'0',2));
         DelTree(AddNumStr(N,'0',2));
         MakeDir(AddNumStr(N,'0',2));
        { �������� ��쥪� ��� }
         New(Judge);
         With Judge^ do
           Begin
             Number    := N;
             Directory := JudgesDir+'\'+AddNumStr(N,'0',2);
             FreeCode  := 'FreeCode';
             BusyCode  := 'BusyCode';
             FreeFlag  := False;
             User      := 0;
             Try       := 0;
             Time      := 0;
             Next      := JudgesList;
           End;
         JudgesList:=Judge;
        { �⢥� ��� }
         Message('[TJudgesTask]: ������� REGBACK.TXT c ����஬ '+AddNumStr(N,'0',2));
        { �⢥� �� ॣ������. ����� -����� ��� � ����娨. }
        { (��� ⮫쪮 ���� ��� �����- �� 㭨�⮦��� ��� 䠩��) }
        { busy code }
        { free code }
         Assign(T,'REGBACK.TXT');
         Repeat Rewrite(T); Until IOResult=0;
         Writeln(T,AddNumStr(N,'0',2));
         Writeln(T,Judge^.BusyCode);
         Writeln(T,Judge^.FreeCode);
         Close(T);
       End;
    { ��⨧���ᠭ�� �㤥� }
    { [!] }
    { ���� �㤥� }
     Judge:=JudgesList;
     While Judge<>nil do
       Begin
         ChDir(AddNumStr(Judge^.Number,'0',2));
         If FSearch('STATUS.TXT','')<>'' then
           Begin
             Assign(T,'STATUS.TXT');
             Repeat Reset(T); Until IOResult = 0;
             Readln(T,Stat);
             Close(T);
             If Stat=Judge^.FreeCode then
               Begin
                 Judge^.FreeFlag:=True;
                 JudgesResults(Judge);
                 JudgesWork(Judge);
               End
             Else
               Judge^.FreeFlag:=False;
           End;
         ChDir('..');
         Judge:=Judge^.Next;
       End;
    { ����� ��⠫��� �� ��室�� }
     ChDir(CurDir);
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �             � � � � � �   � � � � �   � � � � � �              � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ��ப� ����� ������ ===--- }
 Type
   PInputStr = ^TInputStr;
   TInputStr = String[78];
   PConsoleInput = ^TConsoleInput;
   TConsoleInput = Object(TTask)
     Input  : PInputStr;
     Cursor : Byte;
     Procedure Init; Virtual;
     Procedure Run; Virtual;
     Procedure Done; Virtual;
     Procedure Edit;
     Procedure ClearStr;
     Procedure ShowStr;
   End;

 Procedure TConsoleInput.Init;
   Begin
     New(Input);
     DrawBorder(1,22,80,24,6);
     ClearStr;
     ShowStr;
   End;

 Procedure TConsoleInput.Run;
   Begin
     If KeyPressed then Edit;
   End;

 Procedure TConsoleInput.Done;
   Begin
     Dispose(Input);
   End;

 Procedure TConsoleInput.Edit;
   Var Key:Char;
   Begin
     Key:=ReadKey;
     Case Key of
       #08: { ����� }
        If Cursor > 1 then
          Begin
            Input^:=Copy(Input^,1,Cursor-2)+Copy(Input^,Cursor,79-Cursor)+' ';
            Dec(Cursor);
          End;
       #13: { Enter }
         Begin
           Command(Input^);
           ClearStr;
         End;
       #27: { ESC }
         Command('ShutDown');
       #00: { ��५�窨 }
         Case ReadKey of
           #75: If Cursor > 1 then Dec(Cursor);
           #77: If Cursor < 78 then Inc(Cursor);
          { Del }
           #83: Input^:=Copy(Input^,1,Cursor-1)+Copy(Input^,Cursor+1,79-Cursor)+' ';
          { Home }
           #71: Cursor:=1;
           #79: { End }
             Begin
               Cursor:=78;
               While Input^[Cursor]=' ' do Dec(Cursor);
               If Cursor < 78 then Inc(Cursor);
             End;
         End;
     Else
       If Cursor < 78 then
         Begin
           Input^:=Copy(Input^,1,Cursor-1)+Key+Copy(Input^,Cursor,78-Cursor);
           Inc(Cursor);
         End;
     End;
     ShowStr;
   End;

 Procedure TConsoleInput.ShowStr;
   Begin
     TextColor(7);
     GotoXY(2,23);
     Write(Input^);
     GotoXY(1+Cursor,23);
   End;

 Procedure TConsoleInput.ClearStr;
   Var I:Byte;
   Begin
     Input^[0]:=#78;
     For I:=1 to 78 do Input^[I]:=' ';
     Cursor:=1;
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �                     � � � � � � � � � �                        � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ����� ����� ࠡ��� ===--- }
 Const
   NumInfoSymb = 12;
   InfoSymb : Array [0..NumInfoSymb-1] of Char='-/|\-/|\-/|\';

{ ---=== ���ଠ�� ===--- }
 Type
   PInfoTask = ^TInfoTask;
   TInfoTask = Object(TTask)
     LastDraw : Word;
     Procedure Run; Virtual;
     Procedure Show;
   End;

 Procedure TInfoTask.Run;
   Var Temp:Word;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurTime:=(CurHour-StartContestHour)*60+(CurMinute-StartContestMinute);
     TimeLeft:=AllContestTime-CurTime;
     Temp:=CurSec100 div NumInfoSymb;
     If Temp<>LastDraw then
       Begin
         Show;
         LastDraw:=Temp;
       End;
   End;

 Procedure TInfoTask.Show;
   Var X,Y:Byte;
   Begin
     X:=WhereX; Y:=WhereY;
     GotoXY(1,25);
     TextColor(10);
     Write(CurrentTimeStr,'  ');
     TextColor(11);
     Write('Contest = ',Contest,' ',
           AddNumStr(StartContestHour,'0',2),':',
           AddNumStr(StartContestMinute,'0',2),'  ');
     TextColor(13);
     Write(' Time ',AddNumStr(CurTime,'0',4),
           '  All ',AddNumStr(AllContestTime,'0',4),
           ' Left ',AddNumStr(TimeLeft,'0',4),'  ');
     TextColor(9);
     Write(InfoSymb[CurSec100*NumInfoSymb div 100]);
     Write('  ');
     GotoXY(X,Y);
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �                        � � � � � � �                           � � }
{ ��������������������������������������������������������������������ͼ }

 Const HelpFile = 'HELP.TXT';

{ ---=== �뢮� ����� �� ��࠭ ===--- }
 Procedure Help;
   Var T:Text; Str:String;
   Begin
     Writeln(LOG,'[Help]: ���� 䠩� '+HelpFile);
     Assign(T,HelpFile);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ '+HelpFile); Exit; End;
     Repeat
       Readln(T,Str);
       Message(Str);
     Until EOF(T);
     Close(T);
   End;

{ ---=== �⮡ࠦ���� ���ଠ樨 ===--- }
 Procedure Info;
   Begin
     Message(' ---=== Information ===---');
     Message('UsersDir = ' + UsersDir);
     Message('JudgesDir = '+ JudgesDir);
     Message('WorkDir = '  + WorkDir);
     Message('TasksDir = ' + TasksDir);
     Message('InfoDir = '  + InfoDir);
   End;

{ ---=== �뢮� �� ��࠭ ᯨ᪠ ����� ===--- }
 Procedure ShowTasksList;
   Var Task:PTask; N:Word;
   Begin
     Message(' ---=== Tasks List ===---');
     Task:=FirstTask;
     N:=1;
     While Task<>nil do
       Begin
         Message(AddNumStr(N,'0',4)+' '+Task^.Name+' '+NumStr(Task^.Numb));
         Inc(N);
         Task:=Task^.Next;
       End;
   End;

{ ---=== �ᯮ������ ���������� 䠩�� ===--- }
 Procedure Execute( FileName:String );
   Var T:Text; TempStr:String;
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ '+FileName); Exit; End;
     Repeat
       Readln(T,TempStr);
       Command(TempStr);
     Until EOF(T);
     Close(T);
   End;

{ ---=== ����� �ॢ������� ===--- }
 Procedure StartContest( ContestTime:String );
   Var N:LongInt;
   Begin
     N:=StrNum(ContestTime);
     If N = MaxLongInt then
       Begin
         Message('[!] START <�६� �ॢ������� � ������> [!]');
         Exit;
       End;
     AllContestTime     := N;
     TaskManager.AddTask('CONTEST');
   End;

{ ---=== ������� ������⢠ ������� ===--- }
 Procedure LastProblemCommand( LastProblemStr:String );
   Var C:Char;
   Begin
     C:=UpCase(LastProblemStr[1]);
     If not (C in ['A'..'Z']) then
       Begin Message('[!] LastProblem <��� ��᫥���� �����> [!]'); Exit; End;
     Message('[*]: ����� ����� ����� "A"-"'+C+'"');
     LastProblem:=C;
   End;

{ ---=== �⮡ࠦ���� ���ﭨ� ��⥬� ===--- }
 Procedure MonitorCommand;
   Var T:Text; User:PUser; Try:PTry;
   Begin
     Message('[(M)]: �����뢠� ���ଠ�� � 䠩� !USERS!.TXT '+CurrentTimeStr);
     Assign(T,'!USERS!.TXT');
     Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ !USERS!.TXT'); Exit; End;
     Writeln(T,'������ ���짮��⥫�� �� ',CurrentTimeStr);
     User:=UsersList;
     While User<>nil do
       Begin
         Writeln(T,'---=== ',User^.Name,' ===--- ');
         Writeln(T,' ���� ',User^.Rank);
         Writeln(T,' ����� ',User^.Number);
         Writeln(T,' �ன���� ��⮢ ',User^.Tests);
         Writeln(T,' ���䭮� �६� ',User^.Time);
         Try:=User^.TryList;
         While Try<>nil do
           Begin
             Writeln(T,'����� ����⪨ ',Try^.Number);
             Writeln(T,'����� (��� ������ �����) ',Try^.NumberP);
             Writeln(T,'����� ',Try^.Problem);
             Writeln(T,'�६� ��室� ',Try^.Time);
             Writeln(T,'�ன���� ��⮢ ',Try^.Tests);
             Writeln(T,'����ﭨ� ����� ',FlagText(Try^.Flag));
             Writeln(T,'����祭� ��� ',Try^.Judge);
             Writeln(T,'�訡�� ',ErrorText(Try^.Error));
             Try:=Try^.Next;
           End;
         User:=User^.Next;
       End;
     Close(T);
   End;

{ ---=== �⥭�� ᯨ᪠ ���짮��⥫�� ===--- }
 Procedure ReadUsersList;
   Var T:Text; UserName:String;
   Begin
     Message('[*] �⥭�� ᯨ᪠ ���짮��⥫�� �� USERS.TXT ...');
     Assign(T,'USERS.TXT');
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ���� ������ USERS.TXT'); Exit; End;
     Repeat
       Readln(T,UserName);
       AddUserCommand(UserName);
     Until EOF(T);
     Close(T);
   End;

{ ---=== �����襭�� ࠡ��� ===--- }
 Procedure ShutDownCommand;
   Begin
     Command('DelAllUsers');
     ShutDownSystem:=True;
   End;

{ ��������������������������������������������������������������������ͻ }
{ � �              � � � � � � � � � �   � � � � � �                 � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== �ᯮ������ ������� ===--- }
 Procedure Command( CmdStr:String );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     Message('[Command]: '+S);
    { ---=== �뤥����� ������� � ��ࠬ��஢ ===--- }
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
     For I:=1 to Length(Cmd) do Cmd[I]:=UpCase(Cmd[I]);
    { ---=== ��ࠡ�⪠ ������ ===--- }
     If Cmd = 'HELP' then Help Else
    { ������� ��⠫��� }
     If Cmd = 'USERSDIR'  then UsersDir  := Prm Else
     If Cmd = 'JUDGESDIR' then JudgesDir := Prm Else
     If Cmd = 'WORKDIR'   then WorkDir   := Prm Else
     If Cmd = 'TASKSDIR'  then TasksDir  := Prm Else
     If Cmd = 'INFODIR'   then InfoDir   := Prm Else
    { �뢮� ���ଠ樨 �� ��࠭ }
     If Cmd = 'INFO'      then Info Else
    { ����樨 ��� ���짮��⥫ﬨ }
     If Cmd = 'ADDUSER' then AddUserCommand(Prm) Else
     If Cmd = 'DELUSER' then DelUserCommand(Prm) Else
     If Cmd = 'DELALLUSERS' then DelAllUsersCommand Else
     If Cmd = 'USERSLIST' then UsersListCommand Else
     If Cmd = 'OPENUSERS' then TaskManager.AddTask('USERS') Else
     If Cmd = 'CLOSEUSERS' then TaskManager.DelTask('USERS',1) Else
    { ����樨 ��� ���ﬨ }
     If Cmd = 'JUDGESLIST' then ShowJudgesList Else
    { ������⢮ ������� }
     If Cmd = 'LASTPROBLEM' then LastProblemCommand(Prm) Else
    { ��ࠢ����� �ॢ�������� }
     If Cmd = 'START' then StartContest(Prm) Else
    { ����� � ����砬� }
     If Cmd = 'TASKSLIST' then ShowTasksList Else
    { �ᯮ������ ���������� 䠩�� }
     If Cmd = 'EXECUTE' then Execute(Prm) Else
    { ����襥 ���ﭨ� ��� ������ }
     If Cmd = 'MONITOR' then MonitorCommand Else
    { �����襭�� ࠡ��� }
     If Cmd = 'SHUTDOWN' then ShutDownCommand Else
    { ����ୠ� ������� }
     Message('[Error]: ����ୠ� ������� !');
   End;

{ ������������������������������������������������������������������ͻ }
{ � �        � � � � � � � � � � �   � � � � �   � � � � �         � � }
{ ������������������������������������������������������������������ͼ }

 Function TaskType( TaskName:String ):PTask;
   Begin
     If TaskName = 'CONSOLEINPUT' then TaskType:=New(PConsoleInput,Create) Else
     If TaskName = 'MESSAGES' then TaskType:=New(PMessageTask,Create) Else
     If TaskName = 'INFO' then TaskType:=New(PInfoTask,Create) Else
     If TaskName = 'JUDGES' then TaskType:=New(PJudgesTask,Create) Else
     If TaskName = 'USERS' then TaskType:=New(PUsersTask,Create) Else
     If TaskName = 'CONTEST' then TaskType:=New(PContestTask,Create) Else
     TaskType:=nil;
   End;

{$I TASKMAN2.INC}

{ ������������������������������������������������������������������ͻ }
{ � �            � � � � � � � �   � � � � � � � � �               � � }
{ ������������������������������������������������������������������ͼ }

{ ---=== ���樠������ ��⥬� ===--- }
 Procedure InitServer;
   Begin
     ClrScr;
     TaskManager.AddTask('CONSOLEINPUT');
     TaskManager.AddTask('MESSAGES');
     TaskManager.AddTask('INFO');
     TaskManager.AddTask('XXX');
     ReadUsersList;
     Command('Execute StartUp.txt');
     TaskManager.AddTask('JUDGES');
   End;

{ ---=== �����⨥ ��⥬� ===--- }
 Procedure CloseServer;
   Begin
     TaskManager.DelAllTasks;
     TextColor(7); ClrScr;
   End;

{ ---=== �᭮���� �ணࠬ�� ===--- }
Var StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  InitServer;
  Repeat TaskManager.Run; Until ShutDownSystem;
  CloseServer;
  If MemAvail<>StartMem then
    Writeln('[���� � ��⥬�]: ����ﭮ ',StartMem-MemAvail,' ����');
End.



