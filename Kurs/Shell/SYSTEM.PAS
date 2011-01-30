Uses CRT,DOS;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ      €           ‘      •      …  ’       ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---===  ค ็  ===--- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { ฌ๏ ง ค ็จ }
     Numb : Word; { ฎฌฅเ ง ค ็จ แ โ ชจฌ จฌฅญฅฌ }
     Next : PTask; { ‘ซฅคใ๎้ ๏ ง ค ็  ข แฏจแชฅ }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Procedure Done; Virtual;
     Procedure CloseTask;
   End;

{ ---=== ‘ฏจแฎช ง ค ็ ===--- }
 Const FirstTask : PTask = nil;
       LastTask  : PTask = nil;

{ ---=== ฅญฅคฆฅเ ง ค ็ ===--- }
 Type
   TTaskManager = Object
     Procedure AddTask( TaskName:String );
     Procedure DelTask( TaskName:String; Numb:Word );
     Procedure DelAllTasks;
     Procedure Run;
   End;

 Var TaskManager : TTaskManager;

{ ---===  ขฅเ่ฅญจฅ เ กฎโ๋ แจแโฅฌ๋ ===--- }
 Const ShutDownSystem : Boolean = False;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                    ‘ €       €  € —                  ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ๋ๅฎค ฏฎ ESC ===--- }
 Type
   PEscapeTask = ^TEscapeTask;
   TEscapeTask = Object(TTask)
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Procedure Done; Virtual;
   End;

 Procedure TEscapeTask.Init;
   Begin
     Randomize;
     Writeln('[1] โชเ๋ข ฅโแ๏ ฏเจซฎฆฅญจฅ ...');
   End;

 Procedure TEscapeTask.Run;
   Begin
     Write('[2] เจซฎฆฅญจฅ เ กฎโ ฅโ ',Random(5),#13);
     If KeyPressed then
       If ReadKey = #27 then
         ShutDownSystem:=True;
   End;

 Procedure TEscapeTask.Done;
   Begin
     Writeln;
     Writeln('[3]  ชเ๋ข ฅโแ๏ ฏเจซฎฆฅญจฅ ...');
   End;

{ ---=== ฅฃจแโเ ๆจฎญญ๋ฉ แฏจแฎช ง ค ็ ===--- }
 Function TaskType( TaskName:String ):PTask;
   Begin
     If TaskName = 'ESCAPE' then TaskType:=New(PEscapeTask,Create) Else
     TaskType:=nil;
   End;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ         ‘ €   …    ‘      •      …  ’       ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Procedure TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(Name,Numb); End;

{ ---=== ฎก ขจโ์ ง ค ็ใ ===--- }
 Procedure TTaskManager.AddTask( TaskName:String );
   Var Num:Word; Task:PTask;
   Begin
    { ฎคแ็ฅโ ง ค ็ }
     Num:=1;
     Task:=FirstTask;
     While Task <> nil do
       Begin
         If Task^.Name = TaskName then Inc(Num);
         Task:=Task^.Next;
       End;
    { ’จฏ ง ค ็จ }
     Task:=TaskType(TaskName);
     If Task = nil then Exit;
    { ฎก ขซฅญจฅ ง ค ็จ }
     If FirstTask=nil then FirstTask:=Task;
     If LastTask<>nil then LastTask^.Next:=Task;
     LastTask:=Task;
     LastTask^.Numb:=Num;
     LastTask^.Next:=nil;
     LastTask^.Init;
   End;

{ ---===  ขฅเ่จโ์ ง ค ็ใ ===--- }
 Procedure TTaskManager.DelTask( TaskName:String; Numb:Word );
   Var Task,Prev:PTask;
   Begin
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

{ ---=== ‘ญ๏โ์ ขแฅ ง ค ็จ ===--- }
 Procedure TTaskManager.DelAllTasks;
   Var Task,Next:PTask;
   Begin
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next:=Task^.Next;
         Task^.Done;
         Dispose(Task);
         Task:=Next;
       End;
   End;

{ ---===  ฏใแช ง ค ็ ===--- }
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

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ             ‘     €         €   €               ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }
Begin
  TaskManager.AddTask('ESCAPE');
  Repeat
    TaskManager.Run;
  Until ShutDownSystem;
  TaskManager.DelAllTasks;
End.