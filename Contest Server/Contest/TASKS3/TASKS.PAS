Unit Tasks;

Interface

{ �������������������������������������������������������������������ͻ }
{ � �                � � � � � � � �   � � � � �                    � � }
{ �������������������������������������������������������������������ͼ }

{ --=== ����� ===-- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { ��� ����� }
     Numb : Word; { ����� ����� � ⠪�� ������ }
     Next : PTask; { �������� ����� � ᯨ᪥ }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Procedure Done; Virtual;
     Procedure CloseTask;
   End;

{ --=== �������� ����� ===-- }
 Type
   TTaskManager = Object
     Procedure AddTask( TaskName:String );
     Procedure DelTask( TaskName:String; Numb:Word );
     Procedure DelAllTasks;
     Procedure Run;
   End;

 Var TaskManager : TTaskManager; { ����⢥��� ��쥪� �������� }

{ --=== �����襭�� ࠡ��� ��⥬� ===-- }
 Const ShutDownSystem : Boolean = False;

{ ��������������������������������������������������������������������ͻ }
{ � �                       C � � � � � � � �                        � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ����饭�� ===--- }
 Type
   PMessage = ^TMessage;
   TMessage = Record
     Mesg : String[78];
     Next : PMessage;
   End;

{ ---=== ����� ᮮ�饭�� ===--- }
 Procedure Message( _Message_:String );

Implementation

{ �� �ᯮ��㥬� ���㫨 }
Uses _LOG_;

{ �������������������������������������������������������������������ͻ }
{ � �                � � � � � � � �   � � � � �                    � � }
{ �������������������������������������������������������������������ͼ }

{ --=== ���᮪ ����� ===-- }
 Const FirstTask : PTask = nil;
       LastTask  : PTask = nil;

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Procedure TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(Name,Numb); End;

{ ---=== �������� ������ ===--- }
 Procedure TTaskManager.AddTask( TaskName:String );
   Var Num:Word; Task:PTask;
   Begin
     Writeln(LOG,'[TaskManager.AddTask]: ���������� ����� '+TaskName);
    { ������ ����� }
     Num:=1;
     Task:=FirstTask;
     While Task <> nil do
       Begin
         If Task^.Name = TaskName then Inc(Num);
         Task:=Task^.Next;
       End;
    { ��� ����� }
     Task:=TaskType(TaskName);
     If Task = nil then
       Begin
         Writeln(LOG,'[TaskManager.AddTask]: ���������� �������⭮�� ⨯� ����� '+TaskName);
         Exit;
       End;
    { ���������� ����� }
     If FirstTask=nil then FirstTask:=Task;
     If LastTask<>nil then LastTask^.Next:=Task;
     LastTask:=Task;
     LastTask^.Numb:=Num;
     LastTask^.Next:=nil;
     LastTask^.Name:=TaskName;
     LastTask^.Init;
   End;

{ ---=== �������� ������ ===--- }
 Procedure TTaskManager.DelTask( TaskName:String; Numb:Word );
   Var Task,Prev:PTask;
   Begin
     Writeln(LOG,'[TaskManager.DelTask]: ��������� ����� '+TaskName);
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

{ ---=== ����� �� ����� ===--- }
 Procedure TTaskManager.DelAllTasks;
   Var Task,Next:PTask;
   Begin
     Writeln(LOG,'[TaskManager.DelAllTasks]: ��������� �� ����� ');
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next:=Task^.Next;
         Task^.Done;
         Dispose(Task);
         Task:=Next;
       End;
   End;

{ ---=== ����� ����� ===--- }
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

{ ��������������������������������������������������������������������ͻ }
{ � �                       C � � � � � � � �                        � � }
{ ��������������������������������������������������������������������ͼ }

{ ---=== ���� ᮮ�饭�� ===--- }
 Const MessageList : PMessage = nil;

{ ---=== ����� ᮮ�饭�� ===--- }
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

{ ---=== ������� ᮮ�饭�� ===--- }
 Function GetMessage:String;
   Var Mesg:PMessage;
   Begin
     GetMessage:=MessageList^.Mesg;
     Mesg:=MessageList^.Next;
     Dispose(MessageList);
     MessageList:=Mesg;
   End;

{ ---=== ��ࠡ�⪠ ᮮ�饭�� ===--- }
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
     Message(' ��������������������������������������������ͻ');
     Message(' �  ---=== Super Contest Server v0.99 ===---  �');
     Message(' �      (c) Roman International Software      �');
     Message(' �            Build 001 [04.12.99]            �');
     Message(' ��������������������������������������������ͼ');
     Message('    ������ � 䠩� : '+LogFileName);
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
