Uses CRT,DOS,IOTOOLS;

{ ##################################################################### }
{ # #         � � � � � �   �   � � H � � � � �   � � � � �         # # }
{ ##################################################################### }

{ ---=== ����� ===--- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { ��� ����� (�� 32 ᨬ�����) }
     ID   : LongInt; { �����䨪��� ����� }
     Next : PTask; { �������� ����� � ᯨ᪥ }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Destructor Done; Virtual;
     Procedure CloseTask; { ��� �맮�� �� ᠬ�� ����� }
   End;

{ ---=== ���᮪ ����� ===--- }
 Const FirstTask : PTask   = nil;
       LastTask  : PTask   = nil;

{ ---=== �������� ����� ===--- }
 Type
   TTaskManager = Object
     Function AddTask( TaskName:String ):LongInt;
     Procedure DelTask( TaskID:Word );
     Destructor DelAllTasks;
     Procedure Run; { ���� 蠣 ��� ����� }
   End;

 Var TaskManager : TTaskManager; { ����⢥��� �������� ����� }

{ ---=== �����襭�� ࠡ��� ��⥬� ===--- }
 Const ShutDownSystem : Boolean = False;

{ #################################################################### }
{ # #                 � � � � � � � �   � � � � �                  # # }
{ #################################################################### }

{ ---=== �।��।������ ������� ===--- }
 Procedure Command( CmdStr:String ); Forward;

{$I _TASKS_.INC} { ��������� ��� ����� + ��楤�� ��।������ ⨯�� ����� }
{$I _CMDEXE_.INC} { ���ᠭ�� ������ }

{ #################################################################### }
{ # #                     � � � � � � � � � �                      # # }
{ #################################################################### }

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Destructor TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(ID); End;

{ ---=== �������� ������ ===--- }
 Function TTaskManager.AddTask( TaskName:String ):LongInt;
   Var NewID:Word; Task:PTask;
   Begin
     AddTask := 0; { H�㤠筮� �����襭�� ��楤��� }
    { ������ ����� }
     NewID := 1; { ������뢠���� �����䨪��� ����� }
     Task:=FirstTask; { H�稭��� � ��ࢮ� ����� }
     While Task <> nil do { ���� �� ��諨 �� ���� ᯨ᪠ ����� }
       Begin
         Task^.ID >= NewID then NewID:=Task^.ID+1; { �����䨪��� ����� ++ }
         Task:=Task^.Next; { ���室�� �� ᫥������ ������ }
       End;
    { ��� ����� (��쥪� ���஬� ��� ᮮ⢥�����) }
     Task:=TaskType(TaskName); { ��।��塞 ⨯ ����� }
     If Task = nil then Exit; { H���������� ����� -> ��室 }
    { ���������� ����� (��楯����� � ᯨ��) }
     If FirstTask = nil then FirstTask := Task;
     If LastTask <> nil then LastTask^.Next := Task;
     LastTask   := Task;
     Task^.ID   := NewID;  { ������塞 ���� ����� ����� }
     Task^.Next := nil;
     Task^.Name := TaskName;
     Task^.Init;         { ���樠�����㥬 ������ }
     AddTask := NewID; { ���筮� �����襭�� ��楤��� - �����頥� ID }
   End;

{ ---=== �������� ������ ===--- }
 Procedure TTaskManager.DelTask( TaskID:LondInt );
   Var Task,Prev:PTask;
   Begin
     Task:=FirstTask;
     Prev:=nil;
     While Task<>nil do
       Begin
         If Task^.ID = TaskID then
           Begin
             If Prev<>nil then
               Prev^.Next:=Task^.Next
             Else
               FirstTask:=Task^.Next;
             Dispose(Task,Done);
           End;
         Prev:=Task;
         Task:=Task^.Next;
       End;
   End;

{ ---=== ����� �� ����� ===--- }
 Destructor TTaskManager.DelAllTasks;
   Var Task,Next:PTask;
   Begin
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next:=Task^.Next;
         Dispose(Task,Done);
         Task:=Next;
       End;
   End;

{ ---=== ����� ����� ===--- }
 Procedure TTaskManager.Run;
   Var Task,Next:PTask;
   Begin
     If Task = nil then ShutDownSystem:=True;
     Task:=FirstTask;
     While Task<>nil do
       Begin
         Next := Tast^.Next;
         Task^.Run;
         Task := Next;
       End;
   End;

{ #################################################################### }
{ # #              � � H � � H � �   � � � � � � � � �             # # }
{ #################################################################### }
Var StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  Command('Execute server.ini');
  Repeat TaskManager.Run; Until ShutDownSystem;
  TaskManager.DelAllTasks;
  If MemAvail<>StartMem then
    Writeln('[���� � ��⥬�]: �� �६� �ᯮ������ ����ﭮ ',
      StartMem-MemAvail,' ����');
End.