{ 浜様様様様様様様様様様様様様様様様様様様様様融 }
{ �  ---=== Super Contest Server v0.99 ===---  � }
{ �      (c) Roman International Software      � }
{ �            Build 002 [18.11.99]            � }
{ 藩様様様様様様様様様様様様様様様様様様様様様夕 }
Uses CRT,DOS,Tools,_LOG_;

{$I-}

{ ---=== �爛�� ===--- }
 Const StartContestHour   : Byte    = 0;
       StartContestMinute : Byte    = 0;
       CurTime            : LongInt = 0;
       AllContestTime     : LongInt = 9999;
       TimeLeft           : LongInt = 9999;

{$I TASKMAN1.INC}

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                 � � � � � � � �   � � � � �                  � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== 踳ぎ�爛ぅ�キ┘ �����る ===--- }
 Procedure Command( CmdStr:String ); Forward;

{ ---=== ���� 甌爛↓������ ===--- }
 Const Contest : Boolean = False;

{ ---=== ����腑痰〓 �����┤ ===--- }
 Const LastProblem:Char = 'A';



{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                   � � � � � � � � � � � �                      � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

Type
 { = = = ��痰�鎰┘ ����腮 = = = }
  TTaskFlag = (_New_,_Judge_,_Done_);

{ ---=== �オ痰 � 甌痰�鎰┬ ����腮 ===--- }
 Function FlagText( Flag:TTaskFlag ):String;
   Begin
     Case Flag of
       _New_   : FlagText:='������ 皰�讓� 艪� ��痰祚┼�';
       _Judge_ : FlagText:='������ 皀痰�珮モ瘴 痺れォ';
       _Done_  : FlagText:='������ �牀皀痰�牀����';
     End;
   End;

Type
 { = = = ���謔�� = = = }
  PTry = ^TTry;
  TTry = Record
    Number  : Word; { ���ム ���謔�� 痼イ� ≡ュ }
    NumberP : Word; { ���ム ���謔�� �� 轤�� �牀゛ガ� }
    Problem : Char; { �����┘ }
    Time    : Word; { �爛�� �爬絎�� }
    Tests   : Byte; { ���ぅ�� 皀痰�� }
    Flag    : TTaskFlag; { ��痰�鎰┘ ����腮 }
    Judge   : Byte; { ���ム 痺れ� }
    Error   : TError; { ��� �荐！� }
    Next    : PTry; { ��イ竡��� ���謔�� }
  End;
 { = = = ��筮爼�罔� � ���讌���皀�� = = = }
  PUser = ^TUser;
  TUser = Record
    Rank    : Word; { �オ竏ゥ �メ皰 }
    Number  : Word; { ���ム �����る }
    Name    : String[32]; { ��� ���讌���皀�� }
    Tests   : Word; { �瓮�� �牀�ぅ�� 皀痰�� }
    Time    : Word; { �矗�筬�� ∇ガ� }
    TryList : PTry; { ���甌� ���謔�� }
    Next    : PUser; { ��イ竡薑� ���讌���皀�� }
  End;

{ ---=== ���甌� ���讌���皀�ォ ===--- }
 Const UsersList : PUser = nil;

{ ---=== ���� ├�キキ�� ��゛�肓 ���讌���皀�ォ ===--- }
 Const UsersChange : Boolean = True;

{ ---=== ����←キ┘ ���讌���皀�� ===--- }
 Procedure AddUserCommand( UserName:String );
   Var NewUser,User:PUser; Num:Word;
   Begin
     Message('[><] ����←キ┘ ���讌���皀�� : '+UserName);
     New(NewUser);
    { ��錻襤�ガ 甌 甎�瓷�� }
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
    { ������錺� ���� }
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

{ ---=== ����キ┘ ���謔�� ===--- }
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

{ ---=== ����キ┘ ���讌���皀�� ===--- }
 Procedure DelUserCommand( Number:String );
   Var Prev,User:PUser; N:LongInt;
   Begin
     Message('[><] ����キ┘ ���讌���皀�� : '+Number);
     N:=StrNum(Number);
     If N=MaxLongInt then
       Begin Message('[!] DelUser <���ム ���讌���皀��> [!]'); Exit; End;
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
       Message('[Error]: ���讌���皀�� � ���━ ���ム�� �� �´�珮Ε� !');
   End;

{ ---=== ����キ┘ ≡ュ ���讌���皀�ォ ├ 甎�瓷� ===--- }
 Procedure DelAllUsersCommand;
   Var User:PUser; Try:PTry;
   Begin
     Message('[><] ����キ┘ ≡ュ ���讌���皀�ォ');
     While UsersList<>nil do
       Begin
         User:=UsersList^.Next;
         DelTryList(UsersList^.TryList);
         Dispose(UsersList);
         UsersList:=User;
       End;
   End;

{ ---=== ���甌� ���讌���皀�ォ ===--- }
 Procedure UsersListCommand;
   Var User:PUser;
   Begin
     Message(' ---=== ���甌� ���讌���皀�ォ ===---');
     User:=UsersList;
     While User<>nil do
       With User^ do
         Begin
           Message(AddNumStr(Number,'0',2)+'  '+
                   AddNumStr(Rank,' ',2)+
                   '   �メ皰� '+AddNumStr(Tests,' ',4)+
                   '   �爛�� ' +AddNumStr(Time,' ',4)+
                   '   '+Name);
           User:=Next;
         End;
   End;

{ ---=== ��Г��┘ �������� INFO ===--- }
 Procedure CreateInfoDir;
   Begin
     Message('[<>]: �皖琺��� ������� INFO');
     DelTree(InfoDir);
     MakeDir(InfoDir);
     CopyFile(TasksDir+'\TASKS.TXT',InfoDir+'\TASKS.TXT');
   End;

{ ---=== ��Г��┘ �������� WORK ===--- }
 Procedure CreateWorkDir;
   Var User:PUser; F:File; Dir:String;
   Begin
     Message('[<>]: �皖琺��� ������� WORK');
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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                        � � � � � � �                           � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== ����腑痰〓 ���謔�� (≡ィ�) ===--- }
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

{ ---=== ����腑痰〓 ���謔�� (�� ����艫) ===--- }
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

{ ---=== �爛�� �爬絎�� ���瓱���讚��� 皀痰� ===--- }
 Var MaxTestsTime : Word;

{ ---=== ���瓱���讚� 皀痰�� ===--- }
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

{ ---=== �襤�� 甎�瓷� ���謔�� ===--- }
 Procedure ShowTryList( Var T:Text; TryList:PTry; Problem:Char );
   Begin
     Write(T,(NumStr(TryNumP(TryList,Problem))+'/'+
              NumStr(MaxTests(TryList,Problem))):7);
   End;

{ ---=== ��め腑� ������皀�ォ ���讌���皀�� ===--- }
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

{ ---=== �襤�� ┃筮爼�罔� � ���讌���皀�� ===--- }
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

{ ---=== ��瘁│ ���讌���皀�ォ ===--- }
 Type
   UserRec = Record
     _User_ : PUser;
     Number : LongInt;
   End;
   TUserRecs = Array [1..$0FFFF div SizeOf(UserRec)] of UserRec;
   PUserRecs = ^TUserRecs;

{ ---=== ����皰� ===--- }
 Procedure Monitor;
   Var T:Text; User:PUser; N,I,J:Word; C:Char; Users:PUserRecs; L:LongInt;
   Begin
     Message('[Monitor]: �Кキ闔 MONITOR.TXT');
    { ��め腑� ����腑痰�� 皀痰�� � ∇ガキ� }
     User:=UsersList;
     While User<>nil do
       Begin
         CountUser(User);
         User:=User^.Next;
       End;
    { �皖琺��ガ ���� ����皰�� }
     Assign(T,InfoDir+'\MONITOR.TXT'); Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 MONITOR.TXT'); Exit; End;
    { ������〓� }
     Write(T,'   '+AddSym('�������',' ',18));
     For C:='A' to LastProblem do Write(T,'   ',C,'   ');
     Writeln(T,'Tests Time');
     N:=(Ord(LastProblem)-Ord('A'))*7+39;
     For I:=1 to N do Write(T,'='); Writeln(T);
    { ��め腑� ����腑痰�� ���讌���皀�ォ }
     N:=0;
     User:=UsersList;
     While User<>nil do
       Begin
         Inc(N);
         User:=User^.Next;
       End;
    { ������錺� ��瘁│ ���讌���皀�ォ }
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
    { ��珥�珮ガ ��瘁│ ���讌���皀�ォ }
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
    { �襤�え� ���讌���皀�ォ }
     For I:=1 to N do
       With Users^[I] do
         Begin
           _User_^.Rank:=I;
           ShowUserInfo(T,_User_);
         End;
     FreeMem(Users,N*SizeOf(UserRec));
    { ���琺皋� }
     Close(T);
     UsersChange:=False;
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �              � � � � �   � � � � � � � � � � � � �             � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== �ムイ��� ���♂キ�� ===--- }
 Procedure UserMessage( UserName,FileName:String );
   Var T:Text; S:String;
   Begin
     Message(' ---=== Message from '+UserName+' ===---');
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 '+FileName); Exit; End;
     Repeat
       Readln(T,S);
       Message('> '+S);
     Until EOF(T);
     Close(T);
     DelFile(FileName);
   End;

{ ---=== ｯ牀� ���讌���皀�ォ ===--- }
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
     Message('[*] �皖琺��� ������� ���讌���皀�ォ [*]');
     DelTree(UsersDir);
     MakeDir(UsersDir);
     User:=UsersList;
     While User<>nil do
       Begin
         MakeDir(UsersDir+'\'+AddNumStr(User^.Number,'0',2));
         Writeln(LOG,'[TUsersTask.Init]: ��Г�� ������� '+UsersDir+'\'
                               +AddNumStr(User^.Number,'0',2));
         User:=User^.Next;
       End;
   End;

 Procedure TUsersTask.Done;
   Var Dir:String;
   Begin
     Writeln(LOG,'[*] ���琺��� ������� ���讌���皀�ォ [*]');
     DelTree(UsersDir);
   End;

 Procedure TUsersTask.GetProblem( C:Char; User:PUser );
   Var PrvTry,NewTry:PTry; N1,N2:Word;
   Begin
     Message('[Users]: 踸茱� '+C+'.PAS �� '+User^.Name);
    { PrvTry := 踳▲ゃ��� ���謔�� }
     PrvTry:=nil;
     NewTry:=User^.TryList;
     While NewTry<>nil do
       Begin
         PrvTry:=NewTry;
         NewTry:=NewTry^.Next;
       End;
     Writeln(LOG,'��め腮硅��� �♂ゥ ����腑痰〓 ���謔��');
     N1:=TryNum(User^.TryList)+1;
     Writeln(LOG,'��め腮硅��� ����腑痰〓 ���謔�� �� 轤� ����艫');
     N2:=TryNumP(User^.TryList,C)+1;
     Writeln(LOG,'�����闔 ��≪� ���謔��');
     New(NewTry);
     If PrvTry<>nil then
       PrvTry^.Next:=NewTry
     Else
       User^.TryList:=NewTry;
     Writeln(LOG,'������闔 ���� ���謔��');
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
    { ����牀���┘ ����� }
     Writeln(LOG,'����珮� ���� '+C+'.PAS -> '+
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
     CopyFile(C+'.PAS',
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
    { ����キ┘ ����� }
     Writeln(LOG,'����闔 ���� '+C+'.PAS');
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
        { ｯ牀� ����� }
         For C:='A' to LastProblem do
           If FSearch(C+'.PAS','')<>'' then
             GetProblem( C,User );
        { ｯ牀� 甌�♂キ┤ }
         If FSearch('MESSAGE.TXT','')<>'' then
           UserMessage(User^.Name,'MESSAGE.TXT');
         ChDir('..');
        { �ムュ�� � 甄イ竡薀�� ���讌���皀�� }
         User:=User^.Next;
       End;
     ChDir(CurDir);
     If UsersChange then Monitor;
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                   � � � � � � � � � � � �                      � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== ��爛↓����┘ ===--- }
 Type
   PContestTask = ^TContestTask;
   TContestTask = Object(TTask)
     Counter : Word;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
   End;

 Procedure TContestTask.Init;
   Begin
     Message('>>> ������ 甌爛↓������ <<<');
     CreateWorkDir;
     CreateInfoDir;
     Contest:=True;
     Counter:=0;
     Writeln(LOG,'[Contest.Init]: �覩���錺矚� ������� OpenUsers');
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
         Message('>>> ���ユ 甌爛↓������ <<<');
         TaskManager.DelTask(Name,Numb);
       End;
     Inc(Counter);
     If Counter > 32000 then Counter:=32000;
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                         � � � � �                              � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== �磴跫 ===--- }
 Type
   PJudge = ^TJudge;
   TJudge = Record
     Number    : Word; { ���ム 痺れ� }
     Directory : String; { ��｀腮� ������� }
     FreeCode  : String; { ��� 瓣�｀き�痰� }
     BusyCode  : String; { ��� ���閧�痰� }
     FreeFlag  : Boolean; { �〓｀ぅ� �� 瓮���� }
     User,Try  : Word; { ｡����硅��ガ�� ������ }
     Problem   : Char; { �����ガ�� �����┘ }
     Time      : Word; { �爛�� �矚覊�� ����腮 }
     Next      : PJudge; { ��イ竡薑� 痺れ� }
   End;

{ ---=== ���甌� 痺ぅ� ===--- }
 Const JudgesList : PJudge = nil;

{ ---=== �襤�� 甎�瓷� 痺ぅ� ===--- }
 Procedure ShowJudgesList;
   Var Judge:PJudge;
   Begin
     Message(' ---=== ���甌� 痺ぅ� ===---');
     Judge:=JudgesList;
     While Judge<>nil do
       Begin
         Message('Judge : '+Judge^.Directory);
         Judge:=Judge^.Next;
       End;
   End;

{ ---=== ��▲琥キ┘ 痺れ� ===--- }
 Procedure ShutDownJudge( Dir:String );
   Var T:Text;
   Begin
     Writeln(LOG,'��▲琥�� 痺れ� '+Dir+'\UNREG.TXT');
     Assign(T,Dir+'\UNREG.TXT');
     Rewrite(T); Close(T);
   End;

{ ---=== ｡��｀皖� 痺ぅ� ===--- }
 Type
   PJudgesTask = ^TJudgesTask;
   TJudgesTask = Object(TTask)
     Procedure Init; Virtual;
     Procedure Done; Virtual;
     Procedure Run; Virtual;
   End;

 Procedure TJudgesTask.Init;
   Begin
     Message('[Judges.Init]: ���罔��├�罔� 瓱痰ガ� 痺ぅ� ...');
     DelTree(JudgesDir);
     MakeDir(JudgesDir);
   End;

 Procedure TJudgesTask.Done;
   Var Judge:PJudge;
   Begin
     Writeln(LOG,'[Judges.Done]: ��▲琥キ┘ 瓱痰ガ� 痺ぅ� ...');
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
     Message('[JudgesGiveTry]: �發�� ����艫 痺れ� '+NumStr(Judge^.Number));
     Judge^.FreeFlag := False;
     Judge^.User     := User^.Number;
     Judge^.Try      := Try^.Number;
     Judge^.Time     := CurTime;
     Judge^.Problem  := Try^.Problem;
     Try^.Flag       := _Judge_;
     Try^.Judge      := Judge^.Number;
    { �皀�┘ TIME.TXT }
     Message('[JudgesGiveTry]: ����� '+TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Assign(T,TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Repeat Reset(T); Until IOResult=0;
     Readln(T,_Tests);
     Readln(T,_Time);
     Close(T);
    { ����瘡 ������� 痺れ� }
    {  - ��� ����� ����腮 }
    {  - ��� ����┼閧��� }
    {  - ������� 皀痰�� }
    {  - ����腑痰〓 皀痰�� }
    {  - �爛�� �� ���覃 皀痰 (� 瓮�祗���) }
     Message('[JudgesGiveTry]: ��蓊 TASK.TXT');
     Assign(T,'TASK.TXT');
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+
               Try^.Problem+AddNumStr(Try^.NumberP,'0',4)+'.PAS');
     Writeln(T,'F:\SOFTWARE\BP\BIN\TPC.EXE');
     Writeln(T,TasksDir+'\TESTS\'+Try^.Problem);
     Writeln(T,_Tests);
     Writeln(T,_Time);
     Close(T);
     Message('[JudgesGiveTry]: �ゃ �癶モ� 痺れ�');
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
     Message('[JudgesGiveTry]: �磴跫 �癶モ┼');
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
         Message('｡����硅��� 爛с�赳�硅 痺れ� '+NumStr(Judge^.Number));
         UsersChange:=True;
         Assign(T,'RESULTS.TXT');
         Reset(T);
         If IOResult<>0 then Exit;
         Readln(T,_Tests);
         Readln(T,N);
         Result:=ErrorSrc(N);
         Erase(T);
         Message('[Judges]: 蹍皀痰�牀��� '+Judge^.Problem+'.PAS �� '+
                 NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
        { ��瘠��ガ 甌�♂キ┘ ���讌���皀�� }
         Message('��瘠��ガ 甌�♂キ┘ ���讌���皀��');
         Assign(T,UsersDir+'\'+AddNumStr(Judge^.User,'0',2)+'\MESSAGES.TXT');
         Append(T);
         If IOResult<>0 then Rewrite(T);
         Writeln(T,'======================================');
         Writeln(T,'蹍皀痰�牀��� '+Judge^.Problem+'.PAS �� '+
                   NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
         Writeln(T,'蹍�ぅ�� 皀痰�� '+NumStr(_Tests));
         Writeln(T,ErrorText(Result));
         Close(T);
        { �薀� ���讌���皀�� }
         User:=UsersList;
         While User<>nil do
           Begin
             If User^.Number = Judge^.User then Break;
             User:=User^.Next;
           End;
         If User = nil then Exit;
        { �薀� ���謔�� }
         Try:=User^.TryList;
         N:=0;
         While Try<>nil do
           Begin
             Inc(N);
             If N = Judge^.Try then Break;
             Try:=Try^.Next;
           End;
         If Try = nil then Exit;
        { �Кキ錺� ��゛�聶 爛с�赳�皰� }
         Message('�Кキ錺� ��゛�聶 爛с�赳�皰�');
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
    { �ィ�痰��罔�/��оィ�痰��罔� 痺ぅ� }
     ChDir(JudgesDir);
    { ���牀� �� 爛��痰��罔�. ��竄爬 -�竅皰�. }
     If ((FSearch('REGISTER.TXT','')<>'') And
         (FSearch('REGBACK.TXT','')='')) then
       Begin
         Message('[TJudgesTask]: ��茱� REGISTER.TXT');
        { ��め腑� ����腑痰�� 痺ぅ� }
         Judge:=JudgesList;
         N:=1;
         While Judge<>nil do
           Begin
             Inc(N);
             Judge:=Judge^.Next;
           End;
         Message('[TJudgesTask]: ��Г�� ������� '+JudgesDir+'\'+AddNumStr(N,'0',2));
         DelTree(AddNumStr(N,'0',2));
         MakeDir(AddNumStr(N,'0',2));
        { ��Г��┘ �′オ�� 痺れ� }
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
        { �癶モ 痺れ� }
         Message('[TJudgesTask]: ��Б����� REGBACK.TXT c ���ム�� '+AddNumStr(N,'0',2));
        { �癶モ �� 爛��痰��罔�. ��竄爬 -���ム 痺れ� � ┘��璢┬. }
        { (��� 皰�讓� 痺れ� ィ� ※え�- �� 祗�艪���モ ��� �����) }
        { busy code }
        { free code }
         Assign(T,'REGBACK.TXT');
         Repeat Rewrite(T); Until IOResult=0;
         Writeln(T,AddNumStr(N,'0',2));
         Writeln(T,Judge^.BusyCode);
         Writeln(T,Judge^.FreeCode);
         Close(T);
       End;
    { ��皋��※���┘ 痺ぅ� }
    { [!] }
    { ｯ牀� 痺ぅ� }
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
    { ��キ� �������� �� �痳�き覃 }
     ChDir(CurDir);
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �             � � � � � �   � � � � �   � � � � � �              � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== �矗��� □��� ������ ===--- }
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
       #08: { ��｀� }
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
       #00: { �矗カ�腦� }
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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                     � � � � � � � � � �                        � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== ����� �牀罐瘁� ��｀硅 ===--- }
 Const
   NumInfoSymb = 12;
   InfoSymb : Array [0..NumInfoSymb-1] of Char='-/|\-/|\-/|\';

{ ---=== ��筮爼�罔� ===--- }
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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                        � � � � � � �                           � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

 Const HelpFile = 'HELP.TXT';

{ ---=== �襤�� ����薑 �� 蹣��� ===--- }
 Procedure Help;
   Var T:Text; Str:String;
   Begin
     Writeln(LOG,'[Help]: ����� ���� '+HelpFile);
     Assign(T,HelpFile);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 '+HelpFile); Exit; End;
     Repeat
       Readln(T,Str);
       Message(Str);
     Until EOF(T);
     Close(T);
   End;

{ ---=== �皰÷�Ε�┘ ┃筮爼�罔� ===--- }
 Procedure Info;
   Begin
     Message(' ---=== Information ===---');
     Message('UsersDir = ' + UsersDir);
     Message('JudgesDir = '+ JudgesDir);
     Message('WorkDir = '  + WorkDir);
     Message('TasksDir = ' + TasksDir);
     Message('InfoDir = '  + InfoDir);
   End;

{ ---=== �襤�� �� 蹣��� 甎�瓷� ����� ===--- }
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

{ ---=== �甎���キ┘ �����き��� ����� ===--- }
 Procedure Execute( FileName:String );
   Var T:Text; TempStr:String;
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 '+FileName); Exit; End;
     Repeat
       Readln(T,TempStr);
       Command(TempStr);
     Until EOF(T);
     Close(T);
   End;

{ ---=== ���竅� 甌爛↓������ ===--- }
 Procedure StartContest( ContestTime:String );
   Var N:LongInt;
   Begin
     N:=StrNum(ContestTime);
     If N = MaxLongInt then
       Begin
         Message('[!] START <�爛�� 甌爛↓������ � �┃竄��> [!]');
         Exit;
       End;
     AllContestTime     := N;
     TaskManager.AddTask('CONTEST');
   End;

{ ---=== �����┘ ����腑痰�� �����┤ ===--- }
 Procedure LastProblemCommand( LastProblemStr:String );
   Var C:Char;
   Begin
     C:=UpCase(LastProblemStr[1]);
     If not (C in ['A'..'Z']) then
       Begin Message('[!] LastProblem <��� ��甄イ�ォ ����腮> [!]'); Exit; End;
     Message('[*]: ����腮 ━ヮ� ━キ� "A"-"'+C+'"');
     LastProblem:=C;
   End;

{ ---=== �皰÷�Ε�┘ 甌痰�鎰�� 瓱痰ガ� ===--- }
 Procedure MonitorCommand;
   Var T:Text; User:PUser; Try:PTry;
   Begin
     Message('[(M)]: ����瘠��� ┃筮爼�罔� � ���� !USERS!.TXT '+CurrentTimeStr);
     Assign(T,'!USERS!.TXT');
     Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 !USERS!.TXT'); Exit; End;
     Writeln(T,'��゛��� ���讌���皀�ォ �� ',CurrentTimeStr);
     User:=UsersList;
     While User<>nil do
       Begin
         Writeln(T,'---=== ',User^.Name,' ===--- ');
         Writeln(T,' �メ皰 ',User^.Rank);
         Writeln(T,' ���ム ',User^.Number);
         Writeln(T,' 蹍�ぅ�� 皀痰�� ',User^.Tests);
         Writeln(T,' �矗�筬�� ∇ガ� ',User^.Time);
         Try:=User^.TryList;
         While Try<>nil do
           Begin
             Writeln(T,'���ム ���謔�� ',Try^.Number);
             Writeln(T,'���ム (か� ������ ����腮) ',Try^.NumberP);
             Writeln(T,'������ ',Try^.Problem);
             Writeln(T,'�爛�� �爬絎�� ',Try^.Time);
             Writeln(T,'蹍�ぅ�� 皀痰�� ',Try^.Tests);
             Writeln(T,'��痰�鎰┘ ����腮 ',FlagText(Try^.Flag));
             Writeln(T,'��珮腑�� 痺れ� ',Try^.Judge);
             Writeln(T,'�荐！� ',ErrorText(Try^.Error));
             Try:=Try^.Next;
           End;
         User:=User^.Next;
       End;
     Close(T);
   End;

{ ---=== �皀�┘ 甎�瓷� ���讌���皀�ォ ===--- }
 Procedure ReadUsersList;
   Var T:Text; UserName:String;
   Begin
     Message('[*] �皀�┘ 甎�瓷� ���讌���皀�ォ ├ USERS.TXT ...');
     Assign(T,'USERS.TXT');
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: �� ��ｃ �皖琺碎 USERS.TXT'); Exit; End;
     Repeat
       Readln(T,UserName);
       AddUserCommand(UserName);
     Until EOF(T);
     Close(T);
   End;

{ ---=== ��▲琥キ┘ ��｀硅 ===--- }
 Procedure ShutDownCommand;
   Begin
     Command('DelAllUsers');
     ShutDownSystem:=True;
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �              � � � � � � � � � �   � � � � � �                 � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== �甎���キ┘ �����る ===--- }
 Procedure Command( CmdStr:String );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     Message('[Command]: '+S);
    { ---=== �襪カキ┘ �����る � �����モ牀� ===--- }
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
     For I:=1 to Length(Cmd) do Cmd[I]:=UpCase(Cmd[I]);
    { ---=== ｡��｀皖� ������ ===--- }
     If Cmd = 'HELP' then Help Else
    { �����┘ �������� }
     If Cmd = 'USERSDIR'  then UsersDir  := Prm Else
     If Cmd = 'JUDGESDIR' then JudgesDir := Prm Else
     If Cmd = 'WORKDIR'   then WorkDir   := Prm Else
     If Cmd = 'TASKSDIR'  then TasksDir  := Prm Else
     If Cmd = 'INFODIR'   then InfoDir   := Prm Else
    { �襤�� ┃筮爼�罔� �� 蹣��� }
     If Cmd = 'INFO'      then Info Else
    { ｯム�罔� ��� ���讌���皀�鍖� }
     If Cmd = 'ADDUSER' then AddUserCommand(Prm) Else
     If Cmd = 'DELUSER' then DelUserCommand(Prm) Else
     If Cmd = 'DELALLUSERS' then DelAllUsersCommand Else
     If Cmd = 'USERSLIST' then UsersListCommand Else
     If Cmd = 'OPENUSERS' then TaskManager.AddTask('USERS') Else
     If Cmd = 'CLOSEUSERS' then TaskManager.DelTask('USERS',1) Else
    { ｯム�罔� ��� 痺れ鍖� }
     If Cmd = 'JUDGESLIST' then ShowJudgesList Else
    { ����腑痰〓 �����┤ }
     If Cmd = 'LASTPROBLEM' then LastProblemCommand(Prm) Else
    { ����←キ┘ 甌爛↓����┘� }
     If Cmd = 'START' then StartContest(Prm) Else
    { ��｀�� � �������� }
     If Cmd = 'TASKSLIST' then ShowTasksList Else
    { �甎���キ┘ �����き��� ����� }
     If Cmd = 'EXECUTE' then Execute(Prm) Else
    { �オ竏ゥ 甌痰�鎰┘ ��� ����諷 }
     If Cmd = 'MONITOR' then MonitorCommand Else
    { ��▲琥キ┘ ��｀硅 }
     If Cmd = 'SHUTDOWN' then ShutDownCommand Else
    { �アム��� ������� }
     Message('[Error]: �アム��� ������� !');
   End;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �        � � � � � � � � � � �   � � � � �   � � � � �         � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �            � � � � � � � �   � � � � � � � � �               � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== ���罔��├�罔� 瓱痰ガ� ===--- }
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

{ ---=== ���琺皋� 瓱痰ガ� ===--- }
 Procedure CloseServer;
   Begin
     TaskManager.DelAllTasks;
     TextColor(7); ClrScr;
   End;

{ ---=== �甅�↓�� �牀������ ===--- }
Var StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  InitServer;
  Repeat TaskManager.Run; Until ShutDownSystem;
  CloseServer;
  If MemAvail<>StartMem then
    Writeln('[�｀� � 瓱痰ガ�]: ��皀瑙�� ',StartMem-MemAvail,' ����');
End.




