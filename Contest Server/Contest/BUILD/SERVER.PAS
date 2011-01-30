Uses CRT,DOS,IOTOOLS;

{ ##################################################################### }
{ # #         З А Д А Ч А   И   М Е H Е Д Ж Е Р   З А Д А Ч         # # }
{ ##################################################################### }

{ ---=== Задача ===--- }
 Type
   PTask = ^TTask;
   TTask = Object
     Name : String[32]; { Имя задачи (до 32 символов) }
     ID   : LongInt; { Идентификатор задачи }
     Next : PTask; { Следующая задача в списке }
     Constructor Create;
     Procedure Init; Virtual;
     Procedure Run;  Virtual;
     Destructor Done; Virtual;
     Procedure CloseTask; { Для вызова из самой задачи }
   End;

{ ---=== Список задач ===--- }
 Const FirstTask : PTask   = nil;
       LastTask  : PTask   = nil;

{ ---=== Менеджер задач ===--- }
 Type
   TTaskManager = Object
     Function AddTask( TaskName:String ):LongInt;
     Procedure DelTask( TaskID:Word );
     Destructor DelAllTasks;
     Procedure Run; { Один шаг всех задач }
   End;

 Var TaskManager : TTaskManager; { Собственно менеджер задач }

{ ---=== Завершение работы системы ===--- }
 Const ShutDownSystem : Boolean = False;

{ #################################################################### }
{ # #                 О П И С А Н И Я   З А Д А Ч                  # # }
{ #################################################################### }

{ ---=== Предопределение команды ===--- }
 Procedure Command( CmdStr:String ); Forward;

{$I _TASKS_.INC} { Заголовки всех задач + Процедура определения типов задач }
{$I _CMDEXE_.INC} { Описание команд }

{ #################################################################### }
{ # #                     Р Е А Л И З А Ц И Я                      # # }
{ #################################################################### }

{ ---=== TTask ===--- }
 Constructor TTask.Create; Begin End;
 Procedure TTask.Init; Begin End;
 Procedure TTask.Run;  Begin End;
 Destructor TTask.Done; Begin End;
 Procedure TTask.CloseTask; Begin TaskManager.DelTask(ID); End;

{ ---=== Добавить задачу ===--- }
 Function TTaskManager.AddTask( TaskName:String ):LongInt;
   Var NewID:Word; Task:PTask;
   Begin
     AddTask := 0; { Hеудачное завершение процедуры }
    { Подсчет задач }
     NewID := 1; { Подсчитывается идентификатор задачи }
     Task:=FirstTask; { Hачинаем с первой задачи }
     While Task <> nil do { Пока не дошли до конца списка задач }
       Begin
         Task^.ID >= NewID then NewID:=Task^.ID+1; { Идентификатор задачи ++ }
         Task:=Task^.Next; { Переходим на следующую задачу }
       End;
    { Тип задачи (Обьект которому она соответствует) }
     Task:=TaskType(TaskName); { Определяем тип задачи }
     If Task = nil then Exit; { Hесуществующая задача -> Выход }
    { Добавление задачи (Прицепление к списку) }
     If FirstTask = nil then FirstTask := Task;
     If LastTask <> nil then LastTask^.Next := Task;
     LastTask   := Task;
     Task^.ID   := NewID;  { Заполняем поля новой задачи }
     Task^.Next := nil;
     Task^.Name := TaskName;
     Task^.Init;         { Инициализируем задачу }
     AddTask := NewID; { Удачное завершение процедуры - Возвращаем ID }
   End;

{ ---=== Завершить задачу ===--- }
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

{ ---=== Снять все задачи ===--- }
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

{ ---=== Запуск задач ===--- }
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
{ # #              О С H О В H А Я   П Р О Г Р А М М А             # # }
{ #################################################################### }
Var StartMem:LongInt;
Begin
  StartMem:=MemAvail;
  Command('Execute server.ini');
  Repeat TaskManager.Run; Until ShutDownSystem;
  TaskManager.DelAllTasks;
  If MemAvail<>StartMem then
    Writeln('[Сбой в системе]: Во время исполнения потеряно ',
      StartMem-MemAvail,' байт');
End.