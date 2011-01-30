{ ╔════════════════════════════════════════════╗ }
{ ║  ---=== Super Contest Server v0.99 ===---  ║ }
{ ║      (c) Roman International Software      ║ }
{ ║            Build 002 [18.11.99]            ║ }
{ ╚════════════════════════════════════════════╝ }
Uses CRT,DOS,Tools,ServerB;

{$I-}

{ ╔═╤═══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │     З А Г О Л О В К И   О С Н О В Н Ы Х   О Б Ь Е К Т О В     │ ║ }
{ ╚═╧═══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Задача ===--- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { Имя задачи }
     Numb : Word; { Номер задачи с таким именем }
     Next : PTask; { Следующая задача в списке }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Procedure Done; Virtual;
     Procedure CloseTask;
   End;

{ ---=== Список задач ===--- }
 Const FirstTask : PTask = nil;
       LastTask  : PTask = nil;

{ ---=== Менеджер задач ===--- }
 Type
   TTaskManager = Object
     Procedure AddTask( TaskName:String );
     Procedure DelTask( TaskName:String; Numb:Word );
     Procedure DelAllTasks;
     Procedure Run;
   End;

 Var TaskManager : TTaskManager;

{ ---=== Завершение работы системы ===--- }
 Const ShutDownSystem : Boolean = False;

{ ╔═╤══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                 О П И С А Н И Я   З А Д А Ч                  │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Предопределение команды ===--- }
 Procedure Command( CmdStr:String ); Forward;

{ ---=== Флаг соревнования ===--- }
 Const Contest : Boolean = False;

{ ---=== Количество заданий ===--- }
 Const LastProblem:Char = 'A';

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                       C О О Б Щ Е Н И Я                        │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Сообщение ===--- }
 Type
   PMessage = ^TMessage;
   TMessage = Record
     Mesg : String[78];
     Next : PMessage;
   End;

{ ---=== Буфер сообщений ===--- }
 Const MessageList : PMessage = nil;

{ ---=== Новое сообщение ===--- }
 Procedure Message( _Message_:String );
   Var Last,Mesg:PMessage;
   Begin
     Log('# '+_Message_);
     New(Mesg);
     Mesg^.Mesg:=_Message_;
     Mesg^.Next:=nil;
     If MessageList<>nil then
       Begin
         Last:=MessageList;
         While Last^.Next<>nil do Last:=Last^.Next;
         Last^.Next:=Mesg;
       End
     Else
       MessageList:=Mesg;
   End;

{ ---=== Извлечь сообщение ===--- }
 Function GetMessage:String;
   Var Mesg:PMessage;
   Begin
     GetMessage:=MessageList^.Mesg;
     Mesg:=MessageList^.Next;
     Dispose(MessageList);
     MessageList:=Mesg;
   End;

{ ---=== Обработка сообщений ===--- }
 Type
   PMessageTask = ^TMessageTask;
   TMessageTask = Object(TTask)
     OutX,OutY : Byte;
     Procedure Init; Virtual;
     Procedure Run; Virtual;
     Procedure Done; Virtual;
   End;

 Procedure TMessageTask.Init;
   Begin
     DrawBorder(1,1,80,21,5);
     Message(' ╔════════════════════════════════════════════╗');
     Message(' ║  ---=== Super Contest Server v0.99 ===---  ║');
     Message(' ║      (c) Roman International Software      ║');
     Message(' ║            Build 001 [04.12.99]            ║');
     Message(' ╚════════════════════════════════════════════╝');
     Message('    Запись в файл : '+ServerLog);
     Message('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
     Message('');
   End;

 Procedure TMessageTask.Run;
   Var X,Y:Byte; S:String;
   Begin
     If MessageList = nil then Exit;
     X:=WhereX; Y:=WhereY;
     TextColor(3);
     Window(2,2,79,20);
     GotoXY(OutX,OutY);
     While MessageList<>nil do
       Begin
         S:=GetMessage;
         Writeln(S);
       End;
     OutX:=WhereX;
     OutY:=WhereY;
     Window(1,1,80,25);
     GotoXY(X,Y);
   End;

 Procedure TMessageTask.Done;
   Begin
     Run;
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                   П О Л Ь З О В А Т Е Л И                      │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

Type
 { = = = Состояние задачи = = = }
  TTaskFlag = (_New_,_Judge_,_Done_);

{ ---=== Текст о состоянии задачи ===--- }
 Function FlagText( Flag:TTaskFlag ):String;
   Begin
     Case Flag of
       _New_   : FlagText:='Задача только что поступила';
       _Judge_ : FlagText:='Задача тестируется судьей';
       _Done_  : FlagText:='Задача протестирована';
     End;
   End;

Type
 { = = = Попытка = = = }
  PTry = ^TTry;
  TTry = Record
    Number  : Word; { Номер попытки среди всех }
    NumberP : Word; { Номер попытки по этой проблеме }
    Problem : Char; { Задание }
    Time    : Word; { Время прихода }
    Tests   : Byte; { Пойдено тестов }
    Flag    : TTaskFlag; { Состояние задачи }
    Judge   : Byte; { Номер судьи }
    Error   : TError; { Код ошибки }
    Next    : PTry; { Следующая попытка }
  End;
 { = = = Информация о пользователе = = = }
  PUser = ^TUser;
  TUser = Record
    Rank    : Word; { Текушее место }
    Number  : Word; { Номер команды }
    Name    : String[32]; { Имя пользователя }
    Tests   : Word; { Всего пройдено тестов }
    Time    : Word; { Штрафное время }
    TryList : PTry; { Список попыток }
    Next    : PUser; { Следующий пользователь }
  End;

{ ---=== Список пользователей ===--- }
 Const UsersList : PUser = nil;

{ ---=== Флаг изменения таблицы пользователей ===--- }
 Const UsersChange : Boolean = True;

{ ---=== Добавление пользователя ===--- }
 Procedure AddUserCommand( UserName:String );
   Var NewUser,User:PUser; Num:Word;
   Begin
     Message('[><] Добавление пользователя : '+UserName);
     New(NewUser);
    { Связываем со списком }
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
    { Заполняем поля }
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

{ ---=== Удаление попыток ===--- }
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

{ ---=== Удаление пользователя ===--- }
 Procedure DelUserCommand( Number:String );
   Var Prev,User:PUser; N:LongInt;
   Begin
     Message('[><] Удаление пользователя : '+Number);
     N:=StrNum(Number);
     If N=MaxLongInt then
       Begin Message('[!] DelUser <Номер пользователя> [!]'); Exit; End;
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
       Message('[Error]: Пользователь с таким номером не обнаружен !');
   End;

{ ---=== Удаление всех пользователей из списка ===--- }
 Procedure DelAllUsersCommand;
   Var User:PUser; Try:PTry;
   Begin
     Message('[><] Удаление всех пользователей');
     While UsersList<>nil do
       Begin
         User:=UsersList^.Next;
         DelTryList(UsersList^.TryList);
         Dispose(UsersList);
         UsersList:=User;
       End;
   End;

{ ---=== Список пользователей ===--- }
 Procedure UsersListCommand;
   Var User:PUser;
   Begin
     Message(' ---=== Список пользователей ===---');
     User:=UsersList;
     While User<>nil do
       With User^ do
         Begin
           Message(AddNumStr(Number,'0',2)+'  '+
                   AddNumStr(Rank,' ',2)+
                   '   Тестов '+AddNumStr(Tests,' ',4)+
                   '   Время ' +AddNumStr(Time,' ',4)+
                   '   '+Name);
           User:=Next;
         End;
   End;

{ ---=== Создание каталога INFO ===--- }
 Procedure CreateInfoDir;
   Begin
     Message('[<>]: Открываю каталог INFO');
     DelTree(InfoDir);
     MakeDir(InfoDir);
     CopyFile(TasksDir+'\TASKS.TXT',InfoDir+'\TASKS.TXT');
   End;

{ ---=== Создание каталога WORK ===--- }
 Procedure CreateWorkDir;
   Var User:PUser; F:File; Dir:String;
   Begin
     Message('[<>]: Открываю каталог WORK');
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

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                        М О Н И Т О Р                           │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Количество попыток (всего) ===--- }
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

{ ---=== Количество попыток (на задачу) ===--- }
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

{ ---=== Время прихода максимального теста ===--- }
 Var MaxTestsTime : Word;

{ ---=== Максимально тестов ===--- }
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

{ ---=== Вывод списка попыток ===--- }
 Procedure ShowTryList( Var T:Text; TryList:PTry; Problem:Char );
   Begin
     Write(T,(NumStr(TryNumP(TryList,Problem))+'/'+
              NumStr(MaxTests(TryList,Problem))):7);
   End;

{ ---=== Подсчет показателей пользователя ===--- }
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

{ ---=== Вывод информации о пользователе ===--- }
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

{ ---=== Массив пользователей ===--- }
 Type
   UserRec = Record
     _User_ : PUser;
     Number : LongInt;
   End;
   TUserRecs = Array [1..$0FFFF div SizeOf(UserRec)] of UserRec;
   PUserRecs = ^TUserRecs;

{ ---=== Монитор ===--- }
 Procedure Monitor;
   Var T:Text; User:PUser; N,I,J:Word; C:Char; Users:PUserRecs; L:LongInt;
   Begin
     Message('[Monitor]: Изменяю MONITOR.TXT');
    { Подсчет количества тестов и времени }
     User:=UsersList;
     While User<>nil do
       Begin
         CountUser(User);
         User:=User^.Next;
       End;
    { Открываем файл монитора }
     Assign(T,InfoDir+'\MONITOR.TXT'); Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть MONITOR.TXT'); Exit; End;
    { Заголовок }
     Write(T,'   '+AddSym('Команда',' ',18));
     For C:='A' to LastProblem do Write(T,'   ',C,'   ');
     Writeln(T,'Tests Time');
     N:=(Ord(LastProblem)-Ord('A'))*7+39;
     For I:=1 to N do Write(T,'='); Writeln(T);
    { Подсчет количества пользователей }
     N:=0;
     User:=UsersList;
     While User<>nil do
       Begin
         Inc(N);
         User:=User^.Next;
       End;
    { Заполняем массив пользователей }
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
    { Сортируем массив пользователей }
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
    { Выводим пользователей }
     For I:=1 to N do
       With Users^[I] do
         Begin
           _User_^.Rank:=I;
           ShowUserInfo(T,_User_);
         End;
     FreeMem(Users,N*SizeOf(UserRec));
    { Закрытие }
     Close(T);
     UsersChange:=False;
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │              О П Р О С   П О Л Ь З О В А Т Е Л Е Й             │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Передача Сообщения ===--- }
 Procedure UserMessage( UserName,FileName:String );
   Var T:Text; S:String;
   Begin
     Message(' ---=== Message from '+UserName+' ===---');
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть '+FileName); Exit; End;
     Repeat
       Readln(T,S);
       Message('> '+S);
     Until EOF(T);
     Close(T);
     DelFile(FileName);
   End;

{ ---=== Опрос Пользователей ===--- }
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
     Message('[*] Открываю каталог пользователей [*]');
     DelTree(UsersDir);
     MakeDir(UsersDir);
     User:=UsersList;
     While User<>nil do
       Begin
         MakeDir(UsersDir+'\'+AddNumStr(User^.Number,'0',2));
         Log('[TUsersTask.Init]: Создаю каталог '+UsersDir+'\'
                               +AddNumStr(User^.Number,'0',2));
         User:=User^.Next;
       End;
   End;

 Procedure TUsersTask.Done;
   Var Dir:String;
   Begin
     Log('[*] Закрываю каталог пользователей [*]');
     DelTree(UsersDir);
   End;

 Procedure TUsersTask.GetProblem( C:Char; User:PUser );
   Var PrvTry,NewTry:PTry; N1,N2:Word;
   Begin
     Message('[Users]: Пришел '+C+'.PAS от '+User^.Name);
    { PrvTry := Преведущая попытка }
     PrvTry:=nil;
     NewTry:=User^.TryList;
     While NewTry<>nil do
       Begin
         PrvTry:=NewTry;
         NewTry:=NewTry^.Next;
       End;
     Log('Подсчитываю общее количество попыток');
     N1:=TryNum(User^.TryList)+1;
     Log('Подсчитываю количество попыток на эту задачу');
     N2:=TryNumP(User^.TryList,C)+1;
     Log('Добаляю новую попытку');
     New(NewTry);
     If PrvTry<>nil then
       PrvTry^.Next:=NewTry
     Else
       User^.TryList:=NewTry;
     Log('Заполняю поля попытки');
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
    { Копирование файла }
     Log('Копирую файл '+C+'.PAS -> '+
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
     CopyFile(C+'.PAS',
       WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+C+
       AddNumStr(NewTry^.NumberP,'0',4)+'.PAS');
    { Удаление файла }
     Log('Удаляю файл '+C+'.PAS');
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
        { Опрос задач }
         For C:='A' to LastProblem do
           If FSearch(C+'.PAS','')<>'' then
             GetProblem( C,User );
        { Опрос сообщений }
         If FSearch('MESSAGE.TXT','')<>'' then
           UserMessage(User^.Name,'MESSAGE.TXT');
         ChDir('..');
        { Переход к следующему пользователю }
         User:=User^.Next;
       End;
     ChDir(CurDir);
     If UsersChange then Monitor;
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                   С О Р Е В Н О В А Н И Е                      │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Соревнование ===--- }
 Type
   PContestTask = ^TContestTask;
   TContestTask = Object(TTask)
     Counter : Word;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
   End;

 Procedure TContestTask.Init;
   Begin
     Message('>>> Начало соревнования <<<');
     CreateWorkDir;
     CreateInfoDir;
     Contest:=True;
     Counter:=0;
     Log('[Contest.Init]: Выполняется команда OpenUsers');
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
         Message('>>> Конец соревнования <<<');
         TaskManager.DelTask(Name,Numb);
       End;
     Inc(Counter);
     If Counter > 32000 then Counter:=32000;
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                         С У Д Ь И                              │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Судья ===--- }
 Type
   PJudge = ^TJudge;
   TJudge = Record
     Number    : Word; { Номер судьи }
     Directory : String; { Рабочий каталог }
     FreeCode  : String; { Код свободности }
     BusyCode  : String; { Код занятости }
     FreeFlag  : Boolean; { Свободен ли сейчас }
     User,Try  : Word; { Обрабатываемая задача }
     Problem   : Char; { Сдаваемое задание }
     Time      : Word; { Время отсылки задачи }
     Next      : PJudge; { Следующий судья }
   End;

{ ---=== Список судей ===--- }
 Const JudgesList : PJudge = nil;

{ ---=== Вывод списка судей ===--- }
 Procedure ShowJudgesList;
   Var Judge:PJudge;
   Begin
     Message(' ---=== Список судей ===---');
     Judge:=JudgesList;
     While Judge<>nil do
       Begin
         Message('Judge : '+Judge^.Directory);
         Judge:=Judge^.Next;
       End;
   End;

{ ---=== Завершение судьи ===--- }
 Procedure ShutDownJudge( Dir:String );
   Var T:Text;
   Begin
     Log('Завершаю судью '+Dir+'\UNREG.TXT');
     Assign(T,Dir+'\UNREG.TXT');
     Rewrite(T); Close(T);
   End;

{ ---=== Обработка судей ===--- }
 Type
   PJudgesTask = ^TJudgesTask;
   TJudgesTask = Object(TTask)
     Procedure Init; Virtual;
     Procedure Done; Virtual;
     Procedure Run; Virtual;
   End;

 Procedure TJudgesTask.Init;
   Begin
     Message('[Judges.Init]: Инициализация системы судей ...');
     DelTree(JudgesDir);
     MakeDir(JudgesDir);
   End;

 Procedure TJudgesTask.Done;
   Var Judge:PJudge;
   Begin
     Log('[Judges.Done]: Завершение системы судей ...');
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
     Message('[JudgesGiveTry]: Отдаю задачу судье '+NumStr(Judge^.Number));
     Judge^.FreeFlag := False;
     Judge^.User     := User^.Number;
     Judge^.Try      := Try^.Number;
     Judge^.Time     := CurTime;
     Judge^.Problem  := Try^.Problem;
     Try^.Flag       := _Judge_;
     Try^.Judge      := Judge^.Number;
    { Чтение TIME.TXT }
     Message('[JudgesGiveTry]: Читаю '+TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Assign(T,TasksDir+'\TESTS\'+Try^.Problem+'\TESTS.TXT');
     Repeat Reset(T); Until IOResult=0;
     Readln(T,_Tests);
     Readln(T,_Time);
     Close(T);
    { Запись задания судьи }
    {  - Имя файла задачи }
    {  - Имя компилятора }
    {  - Каталог тестов }
    {  - Количество тестов }
    {  - Время на кажый тест (в секундах) }
     Message('[JudgesGiveTry]: Пишу TASK.TXT');
     Assign(T,'TASK.TXT');
     Repeat Rewrite(T); Until IOResult=0;
     Writeln(T,WorkDir+'\'+AddNumStr(User^.Number,'0',2)+'\'+
               Try^.Problem+AddNumStr(Try^.NumberP,'0',4)+'.PAS');
     Writeln(T,'F:\SOFTWARE\BP\BIN\TPC.EXE');
     Writeln(T,TasksDir+'\TESTS\'+Try^.Problem);
     Writeln(T,_Tests);
     Writeln(T,_Time);
     Close(T);
     Message('[JudgesGiveTry]: Жду ответа судьи');
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
     Message('[JudgesGiveTry]: Судья ответил');
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
         Message('Обрабатываю результаты судьи '+NumStr(Judge^.Number));
         UsersChange:=True;
         Assign(T,'RESULTS.TXT');
         Reset(T);
         If IOResult<>0 then Exit;
         Readln(T,_Tests);
         Readln(T,N);
         Result:=ErrorSrc(N);
         Erase(T);
         Message('[Judges]: Протестирован '+Judge^.Problem+'.PAS от '+
                 NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
        { Посылаем сообщение пользователю }
         Message('Посылаем сообщение пользователю');
         Assign(T,UsersDir+'\'+AddNumStr(Judge^.User,'0',2)+'\MESSAGES.TXT');
         Append(T);
         If IOResult<>0 then Rewrite(T);
         Writeln(T,'======================================');
         Writeln(T,'Протестирован '+Judge^.Problem+'.PAS от '+
                   NumStr(Judge^.User)+' / '+NumStr(Judge^.Try));
         Writeln(T,'Пройдено тестов '+NumStr(_Tests));
         Writeln(T,ErrorText(Result));
         Close(T);
        { Ищем пользователя }
         User:=UsersList;
         While User<>nil do
           Begin
             If User^.Number = Judge^.User then Break;
             User:=User^.Next;
           End;
         If User = nil then Exit;
        { Ищем попытку }
         Try:=User^.TryList;
         N:=0;
         While Try<>nil do
           Begin
             Inc(N);
             If N = Judge^.Try then Break;
             Try:=Try^.Next;
           End;
         If Try = nil then Exit;
        { Изменяем таблицу результатов }
         Message('Изменяем таблицу результатов');
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
    { Регистрация/разрегистрация судей }
     ChDir(JudgesDir);
    { Запрос на регистрацию. Внутри -пустой. }
     If ((FSearch('REGISTER.TXT','')<>'') And
         (FSearch('REGBACK.TXT','')='')) then
       Begin
         Message('[TJudgesTask]: Нашел REGISTER.TXT');
        { Подсчет количества судей }
         Judge:=JudgesList;
         N:=1;
         While Judge<>nil do
           Begin
             Inc(N);
             Judge:=Judge^.Next;
           End;
         Message('[TJudgesTask]: Создаю каталог '+JudgesDir+'\'+AddNumStr(N,'0',2));
         DelTree(AddNumStr(N,'0',2));
         MakeDir(AddNumStr(N,'0',2));
        { Создание обьекта судьи }
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
        { Ответ судье }
         Message('[TJudgesTask]: Возвращаю REGBACK.TXT c номером '+AddNumStr(N,'0',2));
        { Ответ на регистрацию. Внутри -номер судьи в иерархии. }
        { (Как только судья его видит- он уничтожает оба файла) }
        { busy code }
        { free code }
         Assign(T,'REGBACK.TXT');
         Repeat Rewrite(T); Until IOResult=0;
         Writeln(T,AddNumStr(N,'0',2));
         Writeln(T,Judge^.BusyCode);
         Writeln(T,Judge^.FreeCode);
         Close(T);
       End;
    { Антизависание судей }
    { [!] }
    { Опрос судей }
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
    { Смена каталога на исходный }
     ChDir(CurDir);
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │             С Т Р О К А   В В О Д А   К О М А Н Д              │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Строка ввода команд ===--- }
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
       #08: { Забой }
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
       #00: { Стрелочки }
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

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                     И Н Ф О Р М А Ц И Я                        │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Показ процесса работы ===--- }
 Const
   NumInfoSymb = 12;
   InfoSymb : Array [0..NumInfoSymb-1] of Char='-/|\-/|\-/|\';

{ ---=== Информация ===--- }
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

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                        К О М А Н Д Ы                           │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

 Const HelpFile = 'HELP.TXT';

{ ---=== Вывод помощи на экран ===--- }
 Procedure Help;
   Var T:Text; Str:String;
   Begin
     Log('[Help]: Читаю файл '+HelpFile);
     Assign(T,HelpFile);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть '+HelpFile); Exit; End;
     Repeat
       Readln(T,Str);
       Message(Str);
     Until EOF(T);
     Close(T);
   End;

{ ---=== Отображение информации ===--- }
 Procedure Info;
   Begin
     Message(' ---=== Information ===---');
     Message('UsersDir = ' + UsersDir);
     Message('JudgesDir = '+ JudgesDir);
     Message('WorkDir = '  + WorkDir);
     Message('TasksDir = ' + TasksDir);
     Message('InfoDir = '  + InfoDir);
   End;

{ ---=== Вывод на экран списка задач ===--- }
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

{ ---=== Исполнение командного файла ===--- }
 Procedure Execute( FileName:String );
   Var T:Text; TempStr:String;
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть '+FileName); Exit; End;
     Repeat
       Readln(T,TempStr);
       Command(TempStr);
     Until EOF(T);
     Close(T);
   End;

{ ---=== Запуск соревнования ===--- }
 Procedure StartContest( ContestTime:String );
   Var N:LongInt;
   Begin
     N:=StrNum(ContestTime);
     If N = MaxLongInt then
       Begin
         Message('[!] START <Время соревнования в минутах> [!]');
         Exit;
       End;
     AllContestTime     := N;
     TaskManager.AddTask('CONTEST');
   End;

{ ---=== Задание количества заданий ===--- }
 Procedure LastProblemCommand( LastProblemStr:String );
   Var C:Char;
   Begin
     C:=UpCase(LastProblemStr[1]);
     If not (C in ['A'..'Z']) then
       Begin Message('[!] LastProblem <Имя последней задачи> [!]'); Exit; End;
     Message('[*]: Задачи имеют имена "A"-"'+C+'"');
     LastProblem:=C;
   End;

{ ---=== Отображение состояния системы ===--- }
 Procedure MonitorCommand;
   Var T:Text; User:PUser; Try:PTry;
   Begin
     Message('[(M)]: Записываю информацию в файл !USERS!.TXT '+CurrentTimeStr);
     Assign(T,'!USERS!.TXT');
     Rewrite(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть !USERS!.TXT'); Exit; End;
     Writeln(T,'Таблица пользователей на ',CurrentTimeStr);
     User:=UsersList;
     While User<>nil do
       Begin
         Writeln(T,'---=== ',User^.Name,' ===--- ');
         Writeln(T,' Место ',User^.Rank);
         Writeln(T,' Номер ',User^.Number);
         Writeln(T,' Пройдено тестов ',User^.Tests);
         Writeln(T,' Штрафное время ',User^.Time);
         Try:=User^.TryList;
         While Try<>nil do
           Begin
             Writeln(T,'Номер попытки ',Try^.Number);
             Writeln(T,'Номер (для данной задачи) ',Try^.NumberP);
             Writeln(T,'Задача ',Try^.Problem);
             Writeln(T,'Время прихода ',Try^.Time);
             Writeln(T,'Пройдено тестов ',Try^.Tests);
             Writeln(T,'Состояние задачи ',FlagText(Try^.Flag));
             Writeln(T,'Поручено судье ',Try^.Judge);
             Writeln(T,'Ошибка ',ErrorText(Try^.Error));
             Try:=Try^.Next;
           End;
         User:=User^.Next;
       End;
     Close(T);
   End;

{ ---=== Чтение списка пользователей ===--- }
 Procedure ReadUsersList;
   Var T:Text; UserName:String;
   Begin
     Message('[*] Чтение списка пользователей из USERS.TXT ...');
     Assign(T,'USERS.TXT');
     Reset(T);
     If IOResult<>0 then
       Begin Message('[Error]: Не могу открыть USERS.TXT'); Exit; End;
     Repeat
       Readln(T,UserName);
       AddUserCommand(UserName);
     Until EOF(T);
     Close(T);
   End;

{ ---=== Завершение работы ===--- }
 Procedure ShutDownCommand;
   Begin
     Command('DelAllUsers');
     ShutDownSystem:=True;
   End;

{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │              И С П О Л Н Е Н И Е   К О М А Н Д                 │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Исполнение команды ===--- }
 Procedure Command( CmdStr:String );
   Var P,I:Byte; S,Cmd,Prm:String;
   Begin
     S:=CmdStr;
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     Message('[Command]: '+S);
    { ---=== Выделение команды и параметров ===--- }
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
     For I:=1 to Length(Cmd) do Cmd[I]:=UpCase(Cmd[I]);
    { ---=== Обработка команд ===--- }
     If Cmd = 'HELP' then Help Else
    { Задание каталога }
     If Cmd = 'USERSDIR'  then UsersDir  := Prm Else
     If Cmd = 'JUDGESDIR' then JudgesDir := Prm Else
     If Cmd = 'WORKDIR'   then WorkDir   := Prm Else
     If Cmd = 'TASKSDIR'  then TasksDir  := Prm Else
     If Cmd = 'INFODIR'   then InfoDir   := Prm Else
    { Вывод информации на экран }
     If Cmd = 'INFO'      then Info Else
    { Операции над пользователями }
     If Cmd = 'ADDUSER' then AddUserCommand(Prm) Else
     If Cmd = 'DELUSER' then DelUserCommand(Prm) Else
     If Cmd = 'DELALLUSERS' then DelAllUsersCommand Else
     If Cmd = 'USERSLIST' then UsersListCommand Else
     If Cmd = 'OPENUSERS' then TaskManager.AddTask('USERS') Else
     If Cmd = 'CLOSEUSERS' then TaskManager.DelTask('USERS',1) Else
    { Операции над судьями }
     If Cmd = 'JUDGESLIST' then ShowJudgesList Else
    { Количество заданий }
     If Cmd = 'LASTPROBLEM' then LastProblemCommand(Prm) Else
    { Управление соревнованием }
     If Cmd = 'START' then StartContest(Prm) Else
    { Работа с задачами }
     If Cmd = 'TASKSLIST' then ShowTasksList Else
    { Исполнение командного файла }
     If Cmd = 'EXECUTE' then Execute(Prm) Else
    { Текушее состояние баз данных }
     If Cmd = 'MONITOR' then MonitorCommand Else
    { Завершение работы }
     If Cmd = 'SHUTDOWN' then ShutDownCommand Else
    { Неверная команда }
     Message('[Error]: Неверная команда !');
   End;

{ ╔═╤══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │        Р Е Г И С Т Р А Ц И Я   Т И П О В   З А Д А Ч         │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════╧═╝ }

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

{ ╔═╤══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │      О П И С А Н И Е   О С Н О В Н Ы Х   О Б Ь Е К Т О В     │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Procedure TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(Name,Numb); End;

{ ---=== Добавить задачу ===--- }
 Procedure TTaskManager.AddTask( TaskName:String );
   Var Num:Word; Task:PTask;
   Begin
     Log('[TaskManager.AddTask]: Добавляется задача '+TaskName);
    { Подсчет задач }
     Num:=1;
     Task:=FirstTask;
     While Task <> nil do
       Begin
         If Task^.Name = TaskName then Inc(Num);
         Task:=Task^.Next;
       End;
    { Тип задачи }
     Task:=TaskType(TaskName);
     If Task = nil then Exit;
    { Добавление задачи }
     If FirstTask=nil then FirstTask:=Task;
     If LastTask<>nil then LastTask^.Next:=Task;
     LastTask:=Task;
     LastTask^.Numb:=Num;
     LastTask^.Next:=nil;
     LastTask^.Name:=TaskName;
     LastTask^.Init;
   End;

{ ---=== Завершить задачу ===--- }
 Procedure TTaskManager.DelTask( TaskName:String; Numb:Word );
   Var Task,Prev:PTask;
   Begin
     Log('[TaskManager.DelTask]: Снимается задача '+TaskName);
     Task:=FirstTask;
     Prev:=nil;
     While Task<>nil do
       Begin
         If Task^.Name = TaskName then
           Begin
             If Task^.Numb = Numb then
               Begin
                 If Prev<>nil then
                   Prev^.Next:=Task^.Next
                 Else
                   FirstTask:=Task^.Next;
                 Task^.Done;
                 Dispose(Task);
               End;
             If Task^.Numb > Numb then Dec(Task^.Numb);
           End;
         Prev:=Task;
         Task:=Task^.Next;
       End;
   End;

{ ---=== Снять все задачи ===--- }
 Procedure TTaskManager.DelAllTasks;
   Var Task,Next:PTask;
   Begin
     Log('[TaskManager.DelAllTasks]: Снимаются все задачи ');
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next:=Task^.Next;
         Task^.Done;
         Dispose(Task);
         Task:=Next;
       End;
   End;

{ ---=== Запуск задач ===--- }
 Procedure TTaskManager.Run;
   Var Task:PTask;
   Begin
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Task^.Run;
         Task:=Task^.Next;
       End;
   End;

{ ╔═╤══════════════════════════════════════════════════════════════╤═╗ }
{ ║ │            О С Н О В Н А Я   П Р О Г Р А М М А               │ ║ }
{ ╚═╧══════════════════════════════════════════════════════════════╧═╝ }

{ ---=== Инициализация системы ===--- }
 Procedure InitServer;
   Begin
     OpenLog;
     ClrScr;
     TaskManager.AddTask('CONSOLEINPUT');
     TaskManager.AddTask('MESSAGES');
     TaskManager.AddTask('INFO');
     ReadUsersList;
     Command('Execute StartUp.txt');
     TaskManager.AddTask('JUDGES');
   End;

{ ---=== Закрытие системы ===--- }
 Procedure CloseServer;
   Begin
     TaskManager.DelAllTasks;
     TextColor(7); ClrScr;
   End;

{ ---=== Основная программа ===--- }
Var StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  InitServer;
  Repeat TaskManager.Run; Until ShutDownSystem;
  CloseServer;
  If MemAvail<>StartMem then
    Writeln('[Сбой в системе]: Потеряно ',StartMem-MemAvail,' байт');
End.




