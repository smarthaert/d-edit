{ ╔═╤════════════════════════════════════════════════════════════════╤═╗ }
{ ║ │                        К О М А Н Д Ы                           │ ║ }
{ ╚═╧════════════════════════════════════════════════════════════════╧═╝ }

 Const HelpFile = 'HELP.TXT';

{ ---=== Вывод помощи на экран ===--- }
 Procedure Help;
   Var T:Text; Str:String;
   Begin
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

{ ---=== Вывод на экран списка задач ===--- }
 Procedure ShowTasksList;
   Var Task:PTask; N:Word;
   Begin
     Message(' ---=== Tasks List ===---');
     Task:=FirstTask;
     N:=1;
     While Task<>nil do
       Begin
         Message(AddNumStr(N,'0',4)+' '+Task^.Name+' '+Int2Str(Task^.Numb));
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
     N:=Str2Int(ContestTime);
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
     For I:=1 to Length(S) do S[I]:=UpCase(S[I]);
     While S[Length(S)]=' ' do S:=Copy(S,1,Length(S)-1);
     If S[1]='#' then Exit; { Комментарии }
     Message('[Command]: '+S);
    { ---=== Выделение команды и параметров ===--- }
     P:=Pos(' ',S);
     If P<>0 then
       Begin Cmd:=Copy(S,1,P-1); Prm:=Copy(S,P+1,Length(S)-P); End
     Else
       Begin Cmd:=S; Prm:=''; End;
    { ---=== Обработка команд ===--- }
     If Cmd = 'ADDTASK' then
       Begin
         If Not TaskManager.AddTask(Prm) then Message('Hе могу запустить '+Prm);
       End
     Else
     If Cmd = 'DELTASK' then TaskManager.DelTask(Prm,1) Else
     If Cmd = 'HELP' then Help Else
    { Задание каталога }
    { Вывод информации на экран }
    { Операции над пользователями }
     If Cmd = 'OPENUSERS' then TaskManager.AddTask('USERS') Else
     If Cmd = 'CLOSEUSERS' then TaskManager.DelTask('USERS',1) Else
    { Операции над судьями }
    { Количество заданий }
     If Cmd = 'LASTPROBLEM' then LastProblemCommand(Prm) Else
    { Управление соревнованием }
     If Cmd = 'START' then StartContest(Prm) Else
    { Работа с задачами }
     If Cmd = 'TASKSLIST' then ShowTasksList Else
    { Исполнение командного файла }
     If Cmd = 'EXECUTE' then Execute(Prm) Else
    { Текушее состояние баз данных }
    { Завершение работы }
     If Cmd = 'SHUTDOWN' then ShutDownCommand Else
    { Неверная команда }
     Message('[Error]: Неверная команда (используйте команду HELP) !');
   End;
