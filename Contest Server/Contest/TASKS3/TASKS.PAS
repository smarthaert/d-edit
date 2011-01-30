Unit Tasks;

Interface

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                 …  …   …     €  € —                    ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ --===  ค ็  ===-- }
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

{ --=== ฅญฅคฆฅเ ง ค ็ ===-- }
 Type
   TTaskManager = Object
     Procedure AddTask( TaskName:String );
     Procedure DelTask( TaskName:String; Numb:Word );
     Procedure DelAllTasks;
     Procedure Run;
   End;

 Var TaskManager : TTaskManager; { ‘ฎกแโขฅญญฎ ฎก์ฅชโ ฌฅญฅคฆฅเ }

{ --===  ขฅเ่ฅญจฅ เ กฎโ๋ แจแโฅฌ๋ ===-- }
 Const ShutDownSystem : Boolean = False;

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                       C     …                           ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ‘ฎฎก้ฅญจฅ ===--- }
 Type
   PMessage = ^TMessage;
   TMessage = Record
     Mesg : String[78];
     Next : PMessage;
   End;

{ ---=== ฎขฎฅ แฎฎก้ฅญจฅ ===--- }
 Procedure Message( _Message_:String );

Implementation

{ แฅ จแฏฎซ์งใฅฌ๋ฅ ฎคใซจ }
Uses _LOG_;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                 …  …   …     €  € —                    ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ --=== ‘ฏจแฎช ง ค ็ ===-- }
 Const FirstTask : PTask = nil;
       LastTask  : PTask = nil;

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
     Writeln(LOG,'[TaskManager.AddTask]: ฎก ขซ๏ฅโแ๏ ง ค ็  '+TaskName);
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
     If Task = nil then
       Begin
         Writeln(LOG,'[TaskManager.AddTask]: ฎก ขซฅญจฅ ญฅจงขฅแโญฎฃฎ โจฏ  ง ค ็จ '+TaskName);
         Exit;
       End;
    { ฎก ขซฅญจฅ ง ค ็จ }
     If FirstTask=nil then FirstTask:=Task;
     If LastTask<>nil then LastTask^.Next:=Task;
     LastTask:=Task;
     LastTask^.Numb:=Num;
     LastTask^.Next:=nil;
     LastTask^.Name:=TaskName;
     LastTask^.Init;
   End;

{ ---===  ขฅเ่จโ์ ง ค ็ใ ===--- }
 Procedure TTaskManager.DelTask( TaskName:String; Numb:Word );
   Var Task,Prev:PTask;
   Begin
     Writeln(LOG,'[TaskManager.DelTask]: ‘ญจฌ ฅโแ๏ ง ค ็  '+TaskName);
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
     Writeln(LOG,'[TaskManager.DelAllTasks]: ‘ญจฌ ๎โแ๏ ขแฅ ง ค ็จ ');
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

{ ษอัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                       C     …                           ณ บ }
{ ศอฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ใไฅเ แฎฎก้ฅญจฉ ===--- }
 Const MessageList : PMessage = nil;

{ ---=== ฎขฎฅ แฎฎก้ฅญจฅ ===--- }
 Procedure Message( _Message_:String );
   Var Last,Mesg:PMessage;
   Begin
     Writeln(Log,'# '+_Message_);
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

{ ---=== งขซฅ็์ แฎฎก้ฅญจฅ ===--- }
 Function GetMessage:String;
   Var Mesg:PMessage;
   Begin
     GetMessage:=MessageList^.Mesg;
     Mesg:=MessageList^.Next;
     Dispose(MessageList);
     MessageList:=Mesg;
   End;

{ ---=== กเ กฎโช  แฎฎก้ฅญจฉ ===--- }
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
     Message(' ษออออออออออออออออออออออออออออออออออออออออออออป');
     Message(' บ  ---=== Super Contest Server v0.99 ===---  บ');
     Message(' บ      (c) Roman International Software      บ');
     Message(' บ            Build 001 [04.12.99]            บ');
     Message(' ศออออออออออออออออออออออออออออออออออออออออออออผ');
     Message('     ฏจแ์ ข ไ ฉซ : '+LogFileName);
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

End.

