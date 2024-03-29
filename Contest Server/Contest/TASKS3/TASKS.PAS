Unit Tasks;

Interface

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                � � � � � � � �   � � � � �                    � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ --=== ������ ===-- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { ��� ����腮 }
     Numb : Word; { ���ム ����腮 � ���━ ━キガ }
     Next : PTask; { ��イ竡��� ������ � 甎�瓷� }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Procedure Done; Virtual;
     Procedure CloseTask;
   End;

{ --=== �キイΕ� ����� ===-- }
 Type
   TTaskManager = Object
     Procedure AddTask( TaskName:String );
     Procedure DelTask( TaskName:String; Numb:Word );
     Procedure DelAllTasks;
     Procedure Run;
   End;

 Var TaskManager : TTaskManager; { ��＝癶キ�� �′オ� �キイΕ� }

{ --=== ��▲琥キ┘ ��｀硅 瓱痰ガ� ===-- }
 Const ShutDownSystem : Boolean = False;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                       C � � � � � � � �                        � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== ���♂キ┘ ===--- }
 Type
   PMessage = ^TMessage;
   TMessage = Record
     Mesg : String[78];
     Next : PMessage;
   End;

{ ---=== ��〓� 甌�♂キ┘ ===--- }
 Procedure Message( _Message_:String );

Implementation

{ �瓮 �甎��讌礇�襯 ��ゃ�� }
Uses _LOG_;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                � � � � � � � �   � � � � �                    � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ --=== ���甌� ����� ===-- }
 Const FirstTask : PTask = nil;
       LastTask  : PTask = nil;

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Procedure TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(Name,Numb); End;

{ ---=== ����※碎 ����艫 ===--- }
 Procedure TTaskManager.AddTask( TaskName:String );
   Var Num:Word; Task:PTask;
   Begin
     Writeln(LOG,'[TaskManager.AddTask]: ����←錺矚� ������ '+TaskName);
    { ��め腑� ����� }
     Num:=1;
     Task:=FirstTask;
     While Task <> nil do
       Begin
         If Task^.Name = TaskName then Inc(Num);
         Task:=Task^.Next;
       End;
    { �┓ ����腮 }
     Task:=TaskType(TaskName);
     If Task = nil then
       Begin
         Writeln(LOG,'[TaskManager.AddTask]: ����←キ┘ �エБメ皚��� 皋�� ����腮 '+TaskName);
         Exit;
       End;
    { ����←キ┘ ����腮 }
     If FirstTask=nil then FirstTask:=Task;
     If LastTask<>nil then LastTask^.Next:=Task;
     LastTask:=Task;
     LastTask^.Numb:=Num;
     LastTask^.Next:=nil;
     LastTask^.Name:=TaskName;
     LastTask^.Init;
   End;

{ ---=== ��▲琥�碎 ����艫 ===--- }
 Procedure TTaskManager.DelTask( TaskName:String; Numb:Word );
   Var Task,Prev:PTask;
   Begin
     Writeln(LOG,'[TaskManager.DelTask]: ��━�モ瘴 ������ '+TaskName);
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

{ ---=== ��閧� ≡� ����腮 ===--- }
 Procedure TTaskManager.DelAllTasks;
   Var Task,Next:PTask;
   Begin
     Writeln(LOG,'[TaskManager.DelAllTasks]: ��━�鈞瘴 ≡� ����腮 ');
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next:=Task^.Next;
         Task^.Done;
         Dispose(Task);
         Task:=Next;
       End;
   End;

{ ---=== ���竅� ����� ===--- }
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

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用融 }
{ � �                       C � � � � � � � �                        � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶夕 }

{ ---=== �邃ム 甌�♂キ┤ ===--- }
 Const MessageList : PMessage = nil;

{ ---=== ��〓� 甌�♂キ┘ ===--- }
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

{ ---=== �Б�ョ� 甌�♂キ┘ ===--- }
 Function GetMessage:String;
   Var Mesg:PMessage;
   Begin
     GetMessage:=MessageList^.Mesg;
     Mesg:=MessageList^.Next;
     Dispose(MessageList);
     MessageList:=Mesg;
   End;

{ ---=== ｡��｀皖� 甌�♂キ┤ ===--- }
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
     Message(' 浜様様様様様様様様様様様様様様様様様様様様様融');
     Message(' �  ---=== Super Contest Server v0.99 ===---  �');
     Message(' �      (c) Roman International Software      �');
     Message(' �            Build 001 [04.12.99]            �');
     Message(' 藩様様様様様様様様様様様様様様様様様様様様様夕');
     Message('    ����瘡 � ���� : '+LogFileName);
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

