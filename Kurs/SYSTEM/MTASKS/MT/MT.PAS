{***************************************************************************
*  MT : A unit which permits the simultaneous execution of several         *
*       independent tasks in a Turbo Pascal program.                       *
**------------------------------------------------------------------------**
*  Author          : MICHAEL TISCHER                                       *
*  developed on    : 06/10/1989                                            *
*  last update on  : 03/09/1990                                            *
***************************************************************************}

unit Mt;

Interface

{== constants, public =====================================================}

const MAX_UNITS  = 5;                { maximum number of cooperating units }
      SEM_FREE   = 1;                                  { semaphore is free }
      SEM_WAITS  = 0;                  { wait for semaphore to become free }
      NO_ARG     = ptr( 0, 0 );             { do not pass argument to task }

{== Public type declarations required by other units for work with    =====}
{== the functions and procedures from this unit                       =====}

type SEMAPHORE = integer;                                    { a semaphore }
     SEMP      = ^SEMAPHORE;                      { pointer to a semaphore }

     QUEUEP    = ^QUEUE;                   { pointer to a queue descriptor }
     QUEUE     = record                                 { queue descriptor }
                   FAccess,                               { is access free }
                   OccpdE,                   { number of occupied elements }
                   Free    : SEMAPHORE;          { number of free elements }
                   ElSize,                       { size of a queue element }
                   NumEnt  : integer;     { number of entries in the queue }
                   QBufP   : pointer;        { pointer to the queue buffer }
                   Next,                { pointer to next element in queue }
                   Last    : integer;   { pointer to last element in queue }
                 end;

     TDP       = ^TD;                       { pointer to a task descriptor }
     TD        = record                                  { task descriptor }
                   Stack     : pointer;   { memory allocated for the stack }
                   SP        : word;  { stack ptr during task interruption }
                   StackLen  : integer;       { size of the stack in bytes }
                   Priority  : byte;                      { priority level }
                   Waitfor_Sm: SEMP;       { pointer to semaphore expected }
                   Next,                 { pointer to next task descriptor }
                   Last      : TDP; { pointer to preceding task descriptor }
                   StartTime : longint;               { time of last start }
                   UnitData  : array [1..MAX_UNITS] of pointer;
                 end;

     TS        = procedure( TskPtr : pointer );{ start procedure of a task }

     {---- the following types represent procedural pointers to routines  -}
     {---- which must be made available to units registered as "partners" -}

     UpCreate  = function : pointer;
     UpChange  = procedure( TskPtr : pointer );
     UpDelete  = procedure( TskPtr : pointer; RestTasks : integer );
{== Declaration of the public procedures of the unit ======================}

function  MtCreateTask  ( Task   : TS;
                          Priory : byte;
                          SLen   : integer;
                          TskPtr : pointer   ) : TDP;
procedure MtGetSem      ( var S : SEMAPHORE );
procedure MtReleaseSem  ( var S : SEMAPHORE );
function  MtCreateQueue ( Num, Size : integer ) : QUEUEP;
function  MtPeekQueue   ( Qp : QUEUEP; var Message ) : boolean;
procedure MtReadQueue   ( Qp : QUEUEP; var Message );
procedure MtWriteQueue  ( Qp : QUEUEP; var Message );
procedure MtDeleteQueue ( Qp : QUEUEP );
procedure MtaStart      ( Tempo : integer );
procedure MtKillTask    ( Task : TDP );
procedure MTChangePrio  ( Task : TDP; NewPrio : byte );
procedure MtYield;
procedure MtBlock;
procedure MtContinue;

{-- Routines only intended for the call of cooperating units --------------}

function  MtRegisterUnit( Create : UPCreate;
                          Change : UPChange;
                          Delete : UPDelete  ) : boolean;
procedure MtWriteQFast  ( Qp : QUEUEP; var Message );
procedure MtBlockFast;
procedure MtContinueFast;
procedure MtAtomicStart; inline( $FA );
procedure MtAtomicEnd;   inline( $FB );

{==========================================================================}
{== Implementation section                                               ==}
{==========================================================================}

Implementation

{$L mta.obj}                                   { link mta assembler module }

{== Declaration of NEAR procedures from the assembler module ==============}

procedure MtaStart( Tempo : integer ) ; external;
procedure MtaYield                    ; external;
procedure MtaStop                     ; external;
procedure MtaLost                     ; external;
procedure MtaTaskEnded                ; external;
function  MtIsBlocked    : boolean    ; external;

{== Declaration of FAR procedures from the assembler module ===============}

procedure MtBlock                  ; external;
procedure MtContinue               ; external;
procedure MtBlockFast              ; external;
procedure MtContinueFast           ; external;

{== Constants, internal to the module =====================================}

const MIN_STACK      = 40;            { minimum size of a task stack, must }
                                      { be sufficient for context change   }
      TP_STACK_NEED  = 512;            { Turbo requires at least 512 bytes }
      WHAT_SEMAPHORE = nil;                    { do not wait for semaphore }
      MAX_LONGINT    = 2147483647;   { largest positive value of a Longint }

{== Internal type declarations ============================================}

type PTRREC  = record                         { for access to the parts of }
                 Ofs : word;                  { any pointer                }
                 Seg : word;
               end;

     UNITPROC = record                      { unit procedures to be called }
                  CreateProc : UPCreate;                     { create task }
                  ChangeProc : UPChange;                     { task switch }
                  DeleteProc : UPDelete;                     { delete task }
                end;

{== internal typed constants ==============================================}

const FirstTask : TDP     = nil;        { pointer to first and last task   }
      LastTask  : TDP     = nil;        { Descriptor in the chain of tasks }
      NumTask   : integer = 0;                   { number of tasks created }
      NumLUnits : integer = 0;               { number of cooperating units }

{== internal global variables =============================================}

var   CurTask : TDP;                            { currently executing task }
      IdleTdp : TDP;        { pointer to task descriptor of the Idle-Tasks }
      ExitOld : pointer;               { pointer to the old Exit-procedure }
      LUnits  : array [1..MAX_UNITS] of UNITPROC;           { linked units }

{***************************************************************************
*  MtRegisterUnit : Registers a unit as associate of the MT-Unit           *
**------------------------------------------------------------------------**
*  input : Create : procedure called during the creation of a task         *
*          Change : procedure called during the change of a task           *
*          Delete : procedure called during the deletion of a task         *
*  output : TRUE, if the unit could be registered                          *
*  Info    : a maximum of MAX_UNITS can be registered                      *
*  Global : NumLUnits, LUnits                                              *
***************************************************************************}

function  MtRegisterUnit( Create : UPCreate;
                          Change : UPChange;
                          Delete : UPDelete ) : boolean;

begin
  if ( NumLUnits < MAX_UNITS ) then             { can units be registered? }
    begin                                                            { yes }
      inc( NumLUnits );              { increase number of registered units }
      LUnits[ NumLUnits ].CreateProc := Create;
      LUnits[ NumLUnits ].ChangeProc := Change;
      LUnits[ NumLUnits ].DeleteProc := Delete;
      MtRegisterUnit := TRUE;                              { everything OK }
    end
  else                                  { already MAX_UNITS are registered }
     MtRegisterUnit := FALSE;                               { return error }
end;

{***************************************************************************
*  MtYield : pass program execution voluntarily to another task            *
***************************************************************************}

procedure MtYield;

begin
  MtBlock;                                          { block task switching }
  MtaYield;                                           { activate next task }

  {-- Continue is executed automatically by MtaYield ----------------------}
end;

{***************************************************************************
*  MtChangePrio : changes the priority of a task                           *
**------------------------------------------------------------------------**
*  input : Task    = pointer to the task descriptor of the task            *
*            NewPrio = new priority of the task                            *
***************************************************************************}

procedure MTChangePrio( Task : TDP; NewPrio : byte );

begin
  Task^.Priority := NewPrio;                            { set new priority }
end;

{***************************************************************************
*  MtGetSem : brings a semaphore into possession of the caller             *
**------------------------------------------------------------------------**
*  input : S = the semaphore                                               *
*  Info    : if the semaphore is at the time in the possession of another  *
*            task, the task execution is stopped until the other task      *
*            has released the semaphore through the procedure MTReleaseSem.*
***************************************************************************}

procedure MtGetSem( var S : SEMAPHORE );

begin
  MtBlock;                                          { block task switching }
  If ( S = 0 ) then                                      { stored Wakeups? }
    begin                                 { no, task must wait for release }
      if ( NumTask <> 0 ) then                { in multitasking-operation? }
        begin                                                        { yes }
          CurTask^.Waitfor_Sm := @S;                     { store semaphore }
          MtaYield;  { the current task is blocked until semaphore is free }

          {-- when the task returns to this place, the semaphore has been -}
          {-- released again through a call of MtReleaseSem and the       -}
          {-- multitasking can begin again                                -}

          MtBlock;                                           { block again }
        end
      else                           { no, only the main program is active }
        repeat until ( S <> 0 );                        { wait for release }
    end;
  dec( S );                                          { decrement semaphore }
  MtContinue;                                 { start task switching again }
end;

{***************************************************************************
*  MtReleaseSem : releases a semaphore again                               *
**------------------------------------------------------------------------**
*  input : S = the semaphore                                               *
*  Info    : if tasks with a higher priority than the current task are     *
*            waiting for the release of the semaphore, the execution of the*
*            current task is interrupted to activate one of these tasks.   *
***************************************************************************}

procedure MtReleaseSem( var S : SEMAPHORE );

var Tlp         : TDP;        { pointer into the chain of task descriptors }
    i,                                                      { loop counter }
    Prio        : integer;                { task with the highest priority }
    NotBlocked,              { task switching before call not yet blocked? }
    Yield       : boolean;                { pass execution to other tasks? }

begin
  NotBlocked := not(MtIsBlocked);        { task switching blocked already? }
  MtBlock;                                          { block task switching }
  if ( S = 0 ) then               { maybe tasks are waiting for semaphore? }
    begin                                          { yes, find such a task }
      Tlp := FirstTask;                     { start search with first task }
      Prio := CurTask^.Priority;            { this priority must be higher }
      Yield := FALSE;                                      { do not yield  }
      for i := 1 to NumTask do  { process the individual tasks in the list }
        begin
          with Tlp^ do                           { process task descriptor }
            if ( Waitfor_Sm = @S ) then   { is task waiting for semaphore? }
              begin             { yes, task does not have to wait any more }
                Waitfor_Sm := WHAT_SEMAPHORE;
                if ( Priority > Prio ) then  { task with highest priority? }
                  Yield := NotBlocked;               { yes, task switching }
              end;
            Tlp := Tlp^.Next;                  { set Tlp to next task data }
        end;
      inc( S );                                      { increment semaphore }
      if ( Yield ) then                          { switch to another task? }
        MtaYield;                                                    { yes }
    end
  else                              { no task is waiting for the semaphore }
    inc( S );                                        { increment semaphore }
  MtContinue;                                     { restart task switching }
end;

{***************************************************************************
*  MtCreateQueue : creates a queue                                         *
**------------------------------------------------------------------------**
*  input : NUM  = maximum number of the elements in the queue              *
*          SIZE = size of a queue element in bytes                         *
*  output : pointer to the queue, which is needed for all subsequent       *
*           queue operations.                                              *
***************************************************************************}

function MtCreateQueue( Num, Size : integer ) : QUEUEP;

var Qp : QUEUEP;              { pointer to memory area for allocated queue }

begin
  MtBlock;                                                     { new block }
  New( Qp );                              { allocate memory area for queue }
  MtContinue;

  with Qp^ do                                          { process the queue }
    begin
      FAccess := SEM_FREE;       { until now nobody has accessed the queue }
      OccpdE  := 0;                              { no entry into the queue }
      Free    := Num;                              { all elements are free }
      NumEnt  := Num;                                       { store length }
      ElSize  := Size;                            { store size of elements }
      MtBlock;                                      { block task switching }
      GetMem( QBufP, Num * Size );                 { allocate queue buffer }
      MtContinue;                                { continue task switching }
      Next := 1;                     { the pointers Next and Last point to }
      Last := 1;                     { the beginning of the queue buffer   }
    end;
  MtCreateQueue := Qp;                             { pass pointer to queue }
end;

{***************************************************************************
*  MtDeleteQueue : deletes a queue previously created with MtCreateQueue   *
**------------------------------------------------------------------------**
*  input : QP = pointer to the queue                                       *
*  Info    : Tasks which are still waiting for the queue to be deleted     *
*            must be deleted before the call of this procedure, or they    *
*            will never terminate.                                         *
***************************************************************************}

procedure MtDeleteQueue( Qp : QUEUEP );

begin
  with Qp^ do                               { process the queue data block }
    begin
      MtBlock;                                 { block the call of FreeMem }
      FreeMem( QBufP, NumEnt * ElSize );            { release queue buffer }
    end;
 Dispose( Qp );                                     { release queue itself }
 MtContinue;                                 { permit task switching again }
end;

{***************************************************************************
*  MtWriteQFast: writes a message into a queue, even if another            *
*                task is currently accessing the queue.                    *
**------------------------------------------------------------------------**
*  input : QP      = pointer to the addressed queue                        *
*            MESSAGE = message which should be copied to the queue         *
*  Info    : - if the queue is full, the last queue element is over-       *
*              written without waiting for the next read access 	   *
*            - this procedure should only be called by interrupt handlers  *
*              that must access the queue fast and unconditionally.        *
***************************************************************************}

procedure MtWriteQFast( Qp : QUEUEP; var Message );

type QBUF = array [0..65000] of byte;            { image of a queue buffer }
     QBP  = ^QBUF;                              { pointer to such a buffer }

var Tlp    : TDP;             { pointer into the chain of task descriptors }
    i      : integer;                                       { loop counter }
    Switch : boolean;      { is TRUE, when a task is waiting for the queue }

begin
  with Qp^ do                                          { process the queue }
    begin
      MtAtomicStart;                          { no interruptions permitted }
      Move( Message, QBP(QBufP)^[ (Last-1) * ElSize ], ElSize );
      if ( Free <> 0 ) then                           { is the queue full? }
        begin                                                         { no }
          if ( Last = NumEnt ) then                { reached last element? }
             Last := 1                    { yes, set Last to first element }
          else                                        { no, increment only }
            inc( Last );
          dec( Free );                             { one element less free }

          {-- if the queue was empty until now, tasks which were        ---}
          {-- waiting for this queue must be unblocked                  ---}

          if ( OccpdE = 0 ) then                            { queue empty? }
            begin                             { yes, unblock waiting tasks }
              Switch := FALSE;                       { do not leave switch }
              Tlp := FirstTask;             { start search with first task }
              for i := 1 to NumTask do                      { process list }
                begin                     { is task waiting for semaphore? }
                  if ( Tlp^.Waitfor_Sm = @OccpdE ) then
                    begin                                   { yes, unblock }
                      Tlp^.Waitfor_Sm := WHAT_SEMAPHORE;
                      Switch := TRUE;    { task switch as soon as possible }
                    end;
                  Tlp := Tlp^.Next;         { set pointer Tlp to next task }
                end;
              if ( Switch ) then        { task switch as soon as possible? }
                MtaLost;                { yes, inform the assembler module }
            end;
          inc( OccpdE );                        { another element occupied }
        end;
      MtAtomicEnd;                          { interruption permitted again }
    end;
end;

{***************************************************************************
*  MtWriteQueue: write a message into a queue                              *
**------------------------------------------------------------------------**
*  input : QP      = pointer to the addressed queue                        *
*          MESSAGE = pointer to the message which should be copied to the  *
*                      queue                                               *
*  Info    : - if the queue is full, the function returns to the caller    *
*              only when another task has read an element from the queue.  *
***************************************************************************}

procedure MtWriteQueue( Qp : QUEUEP; var Message );

type QBUF = array [0..65000] of byte;            { image of a queue buffer }
     QBP  = ^QBUF;                              { pointer to such a buffer }

begin
  with Qp^ do                                          { process the queue }
    begin
      MtGetSem( Free );            { wait until at least one entry is free }
      MtGetSem( FAccess );                     { get access right to queue }
      Move( Message, QBP(QBufP)^[ (Last-1) * ElSize ], ElSize );
      if ( Last = NumEnt ) then                    { reached last element? }
        Last := 1                          { yes, set Last to next element }
      else                                            { no, increment only }
        inc( Last );
      MtReleaseSem( OccpdE );                  { one element more occupied }
      MtReleaseSem( FAccess );                     { release FAccess again }
    end;
end;

{***************************************************************************
*  MtPeekQueue: determines if a message is in the queue. If so, return this*
*               message without removing it from the queue.                *
**------------------------------------------------------------------------**
*  input : QP      = pointer to the addressed queue                        *
*            Message = pointer to buffer where the message will be copied  *
*  output : TRUE, a message was ready                                      *
*  Info    : in contrast with MTReadQueue the function returns immediately *
*            to the caller, even when no message was ready in the queue.   *
***************************************************************************}

function MtPeekQueue( Qp : QUEUEP; var Message ) : boolean;

type QBUF = array [0..65000] of byte;            { image of a queue buffer }
     QBP  = ^QBUF;                              { pointer to such a buffer }

begin
  with Qp^ do                                          { process the queue }
    begin
      MtGetSem( FAccess );                 { secure access rights to queue }
      if ( OccpdE <> SEM_WAITS ) then                  { message in queue? }
        begin                             { yes, load into variable passed }
          Move( QBP(QBufP)^[ (Next-1) * ElSize ], Message, ElSize );
          MtPeekQueue := TRUE;                            { return message }
        end
      else                                       { no message in the queue }
        MtPeekQueue := FALSE;
      MtReleaseSem( FAccess );                     { release FAccess again }
    end;
end;

{***************************************************************************
*  MtReadQueue: read a message from a queue                                *
**------------------------------------------------------------------------**
*  input : QP      = pointer to the addressed queue                        *
*            Message = pointer to buffer to which the message is copied    *
*  Info    : - if the queue is empty, the function only returns to the     *
*              caller when another task has written an element into        *
*              the queue.                                                  *
***************************************************************************}

procedure MtReadQueue( Qp : QUEUEP; var Message );

type QBUF = array [0..65000] of byte;            { image of a queue buffer }
     QBP  = ^QBUF;                              { pointer to such a buffer }

begin
  with Qp^ do                                          { process the queue }
    begin
      MtGetSem( OccpdE );      { wait until at least one entry is occupied }
      MtGetSem( FAccess );                  { secure access right to queue }
      Move( QBP(QBufP)^[ (Next-1) * ElSize ], Message, ElSize );
      if ( Next = NumEnt ) then                    { reached last element? }
        Next := 1                          { yes, set Next to next element }
      else                                            { no, increment only }
        inc( Next );
      MtReleaseSem( Free );                    { one more element free now }
      MtReleaseSem( FAccess );                     { release FAccess again }
    end;
end;

{***************************************************************************
*  PushStack : stores a word on the stack of a task                        *
**------------------------------------------------------------------------**
*  input : TaDes = pointer to the task descriptor                          *
*            Push  = the word to be stored on the stack                    *
***************************************************************************}

procedure PushStack( TaDes : TDP; Push : word );

type WPTR = ^word;                                     { pointer to a word }

begin
  with TaDes^ do          { process task descriptor, to which TaDes points }
    begin
      dec( SP, 2);                    { decrement stack pointer by 2 bytes }
      WPTR( ptr( PTRREC(Stack).Seg, SP ) )^ := Push; { store word on stack }
    end;
end;

{***************************************************************************
*  MtBuildTask : creates a new task                                        *
**------------------------------------------------------------------------**
*  input : Task   = procedure, which begins the execution of the task      *
*            Priory = priority of the task                                 *
*            SLen   = size of the task stack                               *
*            TskPtr = pointer, which is passed to start of task            *
*  output : a pointer to the created task descriptor or NIL, when          *
*            the task could not be created.                                *
*  Info    : - the Start-procedure of the task must be FAR !               *
*            - this procedure is only for internal use in the  MT unit.    *
*              External units must use the procedure MtCreateTask.         *
*  Global : CurTask, FirstTask, LastTask                                   *
***************************************************************************}

function MtBuildTask( Task   : TS;
                      Priory : byte;
                      SLen   : integer;
                      TskPtr : pointer ) : TDP;

var NewTask : TDP;                        { pointer to new task descriptor }
    i       : integer;                                      { loop counter }

begin
  {-- create new task descriptor and attach to end of the task list -------}

  MtBlock;                                         { no task switching yet }
  New( NewTask );                             { create new task descriptor }

  if FirstTask = nil then                           { no task created yet? }
    begin                                                             { no }
      FirstTask := NewTask;                  { store pointer to first task }
      NewTask^.Last := nil;                      { there is no predecessor }
      CurTask := NewTask;         { with this task begins the multitasking }
    end
  else                                                    { not first task }
    begin
      LastTask^.Next := NewTask;          { construct chaining to new task }
      NewTask^.Last := LastTask;                 { chaining to predecessor }
    end;

  LastTask := NewTask;           { the new task is the last task up to now }
  NewTask^.Next := nil;          { and has no successor yet                }

  {-- create the stack of the new task and initialize ---------------------}

  if SLen < MIN_STACK then               { minimum stack size is MIN_STACK }
    SLen := MIN_STACK;
  SLen := SLen + TP_STACK_NEED + System.StackLimit;       { TP stack needs }
  GetMem( NewTask^.Stack, SLen );                { create memory for stack }
  NewTask^.StackLen := SLen;            { store stack length for FreeMem() }
  NewTask^.SP := Ofs( NewTask^.Stack^ ) + SLen;       { SP to end of stack }

  NewTask^.Waitfor_Sm := WHAT_SEMAPHORE; { task doesn't wait for semaphore }
  NewTask^.Priority := Priory;                            { store priority }
  NewTask^.StartTime := 0;                      { task was not yet started }

  {-- allow external units to store information ---------------------------}

  for i := 1 to NumLUnits do
    NewTask^.UnitData[ i ] := LUnits[ i ].CreateProc;

  {-- store the argument, the return jump address to task and various    --}
  {-- processor registers on the task stack                              --}

  PushStack( NewTask, PTRREC( TskPtr ).Seg );      { argument for new task }
  PushStack( NewTask, PTRREC( TskPtr ).Ofs );
  PushStack( NewTask, Seg( MtaTaskEnded ) ); { FAR return jump address for }
  PushStack( NewTask, Ofs( MtaTaskEnded ) ); { TaskEnded                   }
  PushStack( NewTask, 512);                                { flag register }
  PushStack( NewTask, Seg( Task ) );        { return jump address for IRET }
  PushStack( NewTask, Ofs( Task ) );
  for i := 1 to 7 do                   { AX, BX, CX, DX, DI, SI & BP are 0 }
    PushStack( NewTask, 0 );
  PushStack( NewTask, DSeg );          { segment addr. of the data segment }
  PushStack( NewTask, 0 );                                  { ES is also 0 }

  {-- the task stack looks like this: -------------------------------------}
  {                                                                        }
  {   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                           }
  {   ³   FAR-pointer which is passed to the   ³          [ SP + 1Eh ]     }
  {   ÃÄ                                      Ä´                           }
  {   ³   procedure [Task-Start] as Argument   ³          [ SP + 1Ch ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³   FAR-pointer to the procedure MtTask- |          [ SP + 1Ah ]     }
  {   ÃÄ                                      Ä´                           }
  {   ³      Ended, which ends the task        ³          [ SP + 18h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³   content of Flag-Register for IRET    ³          [ SP + 16h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³                                        ³          [ SP + 14h ]     }
  {   ÃÄ  return-jump address for IRET        Ä´                           }
  {   ³                                        ³          [ SP + 12h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of AX register before INT 08  ³          [ SP + 10h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of BX register before INT 08  ³          [ SP + 0Eh ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of CX register before INT 08  ³          [ SP + 0Ch ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of DX register before INT 08  ³          [ SP + 0Ah ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of DI register before INT 08  ³          [ SP + 08h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of SI register before INT 08  ³          [ SP + 06h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of BP register before INT 08  ³          [ SP + 04h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of DS register before INT 08  ³          [ SP + 02h ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³  content of ES register before INT 08  ³   <----- [ SP       ]     }
  {   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                           }
  {   ³                                        ³                           }
  {                                                                        }
  {   During the next context change in this task, the registers are       }
  {   loaded again from the stack and the IRET instruction makes a jump    }
  {   to the procedure [ TaskStart ]. As argument this procedure finds the }
  {   pointer [ TskPtr ] on the stack.                                     }
  {                                                                        }
  {------------------------------------------------------------------------}

  inc( NumTask );                          { increment number of the tasks }
  MtBuildTask := NewTask;              { return pointer to task descriptor }
  MtContinue;                              { task switching possible again }
end;

{***************************************************************************
*  IdleTask : this task, which has no function, runs on the lowest         *
*             priority level and is only called when                       *
*             no other task is available.                                  *
***************************************************************************}

{$F+}
procedure IdleTask( TskPtr : pointer );

begin
  while ( TRUE ) do                                 { useless endless loop }
   ;
end;
{$F-}

{***************************************************************************
*  MtCreateTask : creates a new task                                       *
**------------------------------------------------------------------------**
*  input : Task   = procedure with which the execution of the task starts  *
*            Priory = priority of the task                                 *
*            SLen   = size of the task stack                               *
*            TskPtr = pointer, passed to the starting task                 *
*  output : a pointer to the task descriptor created or NIL when           *
*           the task could not be created.                                 *
*  Info    : the start procedure of the task must be FAR !                 *
*  Global : CurTask, FirstTask, LastTask                                   *
***************************************************************************}

function MtCreateTask( Task   : TS;
                       Priory : byte;
                       SLen   : integer;
                       TskPtr : pointer ) : TDP;

begin
  if ( NumTask = 0 ) then                        { is this the first task? }
    IdleTdp := MtBuildTask(IdleTask, 0, 0, NO_ARG); { yes, create IdleTask }
  MtCreateTask := MtBuildTask( Task, Priory, SLen, TskPtr );
end;

{***************************************************************************
*  MtChooseNext : selects the next task to be executed                     *
**------------------------------------------------------------------------**
*  Info    : this procedure is called by the scheduler in the assembler    *
*            module MTA.ASM. It assumes that the task switching was        *
*            switched off before its call                                  *
*  Global : CurTask : the current task                                     *
***************************************************************************}

procedure MtChooseNext;

const Call_Me : longint = 0;            { previous calls of this procedure }

var LookTask,                                    { currently compared task }
    MaxTask  : TDP;     { pointer to task descriptor with highest priority }
    CurPrio,                                { priority of the current task }
    MaxPrio,                                      { highest priority found }
    i        : integer;                                     { loop counter }
    MinTime  : longint;                            { earliest task started }

begin
  {-- find the unblocked task that currently has the highest priority and--}
  {-- has not been executed for the longest time in comparison with the  --}
  {-- other tasks of the same priority                                   --}

  MaxPrio  := -1;                       { every priority is higher than -1 }
  MinTime  := MAX_LONGINT;
  LookTask := FirstTask;                       { begin with the first task }

  for i := 1 to NumTask do         { process the chain of task descriptors }
    begin
      with LookTask^ do                      { process the task data block }
        begin
          if ( Waitfor_Sm = WHAT_SEMAPHORE ) then          { is task free? }
            if ( Priority > MaxPrio ) then { yes,highest current priority? }
              begin
                MaxPrio := Priority;                     { yes, store data }
                MaxTask := LookTask;
                MinTime := StartTime;
              end
            else                   { not highest priority, but maybe equal }
              if (Priority = MaxPrio) and
                 ((StartTime < MinTime) or
                 ((StartTime = MinTime) and (LookTask <> CurTask))) then
                begin                  { yes, and last execution was older }
                  MaxTask := LookTask;
                  MinTime := StartTime;
                end
        end;
      LookTask := LookTask^.Next;                 { set pointer to next TD }
    end;

  if ( MaxTask <> CurTask ) then                    { perform task switch? }
    begin                                                            { yes }
      {-- notify external units of task change  ---------------------------}

      for i := 1 to NumLUnits do                                     { yes }
          LUnits[ i ].ChangeProc( MaxTask^.UnitData[ i ] );

      CurTask := MaxTask;                   { new current task is the task }
                                            { with the highest priority    }
      CurTask^.StartTime := Call_Me;                    { store start time }
    end;
  inc( Call_Me );                { increment the number of calls up to now }
end;

{***************************************************************************
*  MtDelTask: removes a task from the list of the task descriptors and     *
*             releases the memory allocated for it again                   *
*  input : Task : pointer to the task descriptor of the task               *
*  Info    : - the procedure assumes that before its call the task         *
*              switching was blocked.                                      *
*  Global : CurTask, LastTask, FirstTask                                   *
***************************************************************************}

procedure MtDelTask( Task : TDP );

var i : integer;                                            { loop counter }

begin
  {-- delete indicated task from the list of task descriptors -------------}

  if Task = FirstTask then           { is current task first task in list? }
    FirstTask := Task^.Next                  { yes, next task is now first }
  else                            { no, connect predecessor with successor }
    Task^.Last^.Next := Task^.Next;

  if Task = LastTask then                       { was last task up to now? }
    LastTask := Task^.Last                    { yes, previous task is last }
  else                            { no, connect successor with predecessor }
    Task^.Next^.Last := Task^.Last;

  {-- inform external units of deletion of the task -----------------------}

  for i := 1 to NumLUnits do
    LUnits[ i ].DeleteProc( Task^.UnitData[ i ], NumTask );

  FreeMem( Task^.Stack, Task^.StackLen );           { release stack memory }
  Dispose( Task );                         { release task descriptor again }
  dec( NumTask );                    { decrement number of remaining tasks }
end;

{***************************************************************************
*  MtiKillTask: removes a task from the list of the task descriptors       *
*               and releases the memory allocated for it again             *
*  input : Task : pointer to the task descriptor of the task               *
*  Info    : - if a task erases itself, a new current task is              *
*              automatically selected.                                     *
*            - the procedure assumes that before its call the task         *
*              switching was blocked.                                      *
*  Global : CurTask, LastTask, FirstTask                                   *
***************************************************************************}

procedure MtiKillTask( Task : TDP );

begin
  {-- is the current task being erased and does one task remain? ----------}
  if ( ( Task = CurTask ) and ( NumTask > 2 ) ) then
    begin                                   { yes, select new current task }
      CurTask^.Priority := 0;           { current task may not be selected }
      MtChooseNext;                              { select new current task }
    end;

  MtDelTask( Task );                                          { erase task }
  if  ( NumTask = 1 ) then                    { does only IdleTask remain? }
    begin                                                            { yes }
      MtDelTask( IdleTdp );                              { delete IdleTask }
      MtaStop;                                    { terminate multitasking }
    end;
end;

{***************************************************************************
*  MtKillTask: removes a task from the list of the task descriptors        *
*              and releases the memory allocated for it again.             *
*  input : Task : pointer to the task descriptor of the task               *
*  Info    : - A task may not erase itself with the help of this function  *
*  Global : CurTask, LastTask, FirstTask                                   *
***************************************************************************}

procedure MtKillTask( Task : TDP );

begin
  MtBlock;                                       { suppress task switching }
  if ( Task <> CurTask ) then               { prevent, task erasing itself }
    MtiKillTask( Task );                                      { erase task }
  MtContinue;                               { restore task switching again }
end;

{***************************************************************************
*  MtEnd : is called in the following situations:                          *
*            - normal end of a program which works with the MT unit        *
*            - program termination through activation of Ctrl-Break        *
*            - program termination through a run-time error                *
***************************************************************************}

{$F+}                                                        { must be FAR }

procedure MtEnd;

var Resultat : boolean;            { accepts function result of MtKillTask }

begin
  MtBlock;

  {-- was the program terminated through a run-time error? ----------------}

  if (NumTask <> 0 ) then                            { still tasks active? }
   begin                              { yes, error, clear all active tasks }
     CurTask := nil;                                       { no more tasks }
     while ( NumTask <> 0 ) do                   { not even one more task? }
       MtiKillTask( LastTask );                      { no! clear last task }
     writeln('Multitasking error');
   end;

  ExitProc := ExitOld;                     { re-install old Exit procedure }
end;

{$F-}

{**----------------------------------------------------------------------**}
{** Starting code of the unit                                            **}
{**----------------------------------------------------------------------**}

begin
  ExitOld := ExitProc;                    { mark address of Exit procedure }
  ExitProc := @MtEnd;                     { define MtEnd as Exit procedure }
end.