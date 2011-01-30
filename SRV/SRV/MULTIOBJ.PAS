Unit MultiObj;
Interface
Uses Dos;
Type
    SortType = (Writer,Reader);  {для задачи "читатели-редакторы"}
    ArPtr    = ^Artype;
    Artype   =  Array[0..999] of word; {for stack - 1000 word}
{----------------------------------------------------------}
    ListPtr  = ^List;
{----------------------------------------------------------}
    ElmPtr   = ^Element;       {abstract type}
    Element  =  object
             next : ElmPtr;      {for queues}
             pri  : integer;     {priority}
             destructor  Done;                  virtual;
             procedure   SetNext (N : ElmPtr);
             function    GetNext    : ElmPtr;
             procedure   SetQueue(L : ListPtr); virtual;
             function    GetQueue   : ListPtr;  virtual;
             procedure   SetTact (T : word);    virtual;
             function    GetTact    : word;     virtual;
             function    GetMes     : Pointer;  virtual;
             function    GetPri     : integer;
             procedure   SetSort(S  : SortType);virtual;
             function    GetSort    : SortType; virtual;
             procedure   SetSize(N  : Word);virtual;
             function    GetSize    : Word; virtual;
         end;
{----------------------------------------------------------}
     MesPtr  = ^Message;
     Message =  object(Element)
             Mes  : Pointer;
             constructor Init(M  : Pointer; Pr : integer);
             destructor  Done;              virtual;
             function    GetMes  : Pointer; virtual;
      end;
{----------------------------------------------------------}
    ProcMPtr = ^ProcessM;
    ProcessM =  object(Element)     {only for Main}
                     ssreg,
                     spreg  : word;
                     constructor Init;
                     destructor  Done; virtual;
          end;
{----------------------------------------------------------}
    ProcPtr  = ^Process;
    Process  =  object(ProcessM)
                     stack  : ArPtr;
                     queue  : ListPtr;
                     tact   : Word;        {for delay}
                     sort   : SortType;
                     size   : Word;
                     constructor Init(body  : Pointer; Pr : integer);
                     destructor  Done;                  virtual;
                     function    GetQueue   : ListPtr;  virtual;
                     procedure   SetQueue(L : ListPtr); virtual;
                     procedure   SetTact (T : word);    virtual;
                     function    GetTact    : word;     virtual;
                     procedure   SetSort(S  : SortType);virtual;
                     function    GetSort    : SortType; virtual;
                     procedure   SetSize(N  : Word);    virtual;
                     function    GetSize    : Word;     virtual;
               end;
{----------------------------------------------------------}
    List  = object
              beg : ElmPtr;
              constructor Init;
              destructor  Done; virtual;
              function    GetBeg  : ElmPtr;
              procedure   Remove(E  : ElmPtr);  {remove from queue}
              procedure   Incl(E  : ElmPtr);    {include to queue}
        end;
{----------------------------------------------------------}
    ListTPtr = ^ListT;        {queue of processes, delayed to}
    ListT    =  object(List)  {time in ticks}
                  constructor Init;
                  destructor  Done; virtual;
                  procedure   Activisation;
        end;
{----------------------------------------------------------}
    ListRPtr = ^ListR;        {queue of ready processes}
    ListR    =  object(List)
         constructor Init;
         destructor  Done; virtual;
         procedure   Start;
         procedure   Stop;
         procedure   GoToNext;
         procedure   Add (P : Pointer; Pr : integer; Var Pt : ProcPtr);
         procedure   Move(P : ElmPtr; Var L : List; T : word);
         procedure   MoveSelf(Var L : List; T : word);
     end;
{----------------------------------------------------------}
     Semaphore = object(List)
               count : integer;
               constructor Init(S : integer);
               destructor  Done; virtual;
               procedure   Wait_P;
               procedure   Send_V;
        end;
{----------------------------------------------------------}
        Box = object
            QProc : List;
            QMes  : List;
            constructor Init;
            destructor  Done; virtual;
            function    GetMsg   : Pointer;
            procedure   PutMsg(M : Pointer);
        end;
{==========================================================}
Procedure Transfer(OldProc,NewProc : Pointer);
Procedure DI;
Procedure EI;
Var
   Prev,Cur   : ElmPtr;      {Pointers to previous and current processes}
   Tick       : word;
{==========================================================}
Var
   ListDelayT : ListT;           {queue of processes, delayed to time}
   ListKill,                     {queue killed processes}
   ListDelay  : List;            {queue of processes, delayed to resume}
   ListReady  : ListR;           {queue of ready processes}
   DosSem     : Semaphore;
{----------------------------------------------------------}
Implementation
{----------------------------------------------------------}
Const
     TimerIntNo =    8;
     SavedIntNo =  $78;
Var
   Main       : ProcMPtr;
   Regs       : Registers;
   IntPtr     : Pointer;
   IdlProc    : ProcPtr;     {Pointer to Idler}
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Descriptors fields are    : next  - 2 words;
                             pri   - 1 word;
                             VMT   - 1 word;
                             ssreg - 1 word;
                             etc.
 Therefore [di+ 8] points to ssreg.
-------------------------------------------------------------------}
Procedure Transfer(OldProc, NewProc : Pointer);
Assembler;
Asm      {compiler after "Call Transfer" includs  push bp; mov bp,sp}
   les di,oldproc
   mov es:[di+ 8],ss    {oldproc.ssreg := ss;}
   mov es:[di+10],sp    {oldproc.spreg := sp; return address in sp+2}
   les di,newproc
   mov ss,es:[di+ 8]    {ss := newproc.ssreg;}
   mov sp,es:[di+10]    {sp := newproc.spreg;}
   pop bp      {after pop bp stack points to return address}
   sti
   ret 8       {oldproc and newproc have summary size - 8 bytes}
End {Transfer};
{----------------------------------------------------------}
Procedure DI;
Assembler;
Asm
   cli
End {DI};
{----------------------------------------------------------}
Procedure EI;
Assembler;
Asm
   sti
End {EI};
{----------------------------------------------------------}
Procedure Handler;
Interrupt;
Begin
      DI;
      Intr(SavedIntNo,Regs);
      inc(Tick);
      ListDelayT.Activisation;
      ListKill.Done;           {Kill processes that must be kill}
      ListKill.Init;
      ListReady.GoToNext;
End {Handler};
{----------------------------------------------------------}
Procedure Idler;    {forever in ListReady}
Begin
     while true do begin
     end;
End {Idler};
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
Destructor Element.Done;
Begin
End {Element.Done};
{----------------------------------------------------------}
Procedure Element.SetNext(N : ElmPtr);
Begin
     next := N;
End {Element.SetNext};
{----------------------------------------------------------}
Function Element.GetNext : ElmPtr;
Begin
     GetNext := next;
End {Element.GetNext};
{----------------------------------------------------------}
Procedure   Element.SetQueue(L : ListPtr);
Begin  {if Element is Message this virtual procedure does not do anything}
End {Element.SetQueue};
{----------------------------------------------------------}
Function    Element.GetQueue   : ListPtr;
Begin  {if Element is Message this virtual procedure does not do anything}
End {Element.GetQueue};
{----------------------------------------------------------}
Function    Element.GetTact    : word;
Begin  {if Element is Message this virtual procedure does not do anything}
End {Element.GetTact};
{----------------------------------------------------------}
Procedure   Element.SetTact (T : word);
Begin  {if Element is Message this virtual procedure does not do anything}
End {Element.SetTact};
{----------------------------------------------------------}
Function    Element.GetMes     : Pointer;
Begin  {if Element is Process this virtual procedure does not do anything}
End {Element.GetMes};
{----------------------------------------------------------}
Function    Element.GetPri : integer;
Begin
     GetPri := pri;
End {Element.GetPri};
{----------------------------------------------------------}
Procedure Element.SetSort(S : SortType);
Begin
End {Element.SetSort};
{----------------------------------------------------------}
Function  Element.GetSort    : SortType;
Begin
End {Element.GetSort};
{----------------------------------------------------------}
Procedure Element.SetSize(N : Word);
Begin
End {Element.SetSize};
{----------------------------------------------------------}
Function  Element.GetSize    : Word;
Begin
End {Element.GetSize};
{----------------------------------------------------------}
Constructor Message.Init(M : Pointer; Pr : integer);
Begin
     Mes := M;
     pri := Pr;   {priority to use the same procedure List.Incl}
End {Message.Init};
{----------------------------------------------------------}
Destructor  Message.Done;
Begin
End {Message.Done};
{----------------------------------------------------------}
Function    Message.GetMes  : Pointer;
Begin
            GetMes := Mes;
End {Message.GetMes};
{----------------------------------------------------------}
Constructor ProcessM.Init;
Begin   {fields are set transfer}
End {ProcessM.Init};
{----------------------------------------------------------}
Destructor ProcessM.Done;
Begin
End {ProcessM.Done};
{----------------------------------------------------------}
Constructor Process.Init(body:Pointer; Pr : integer);
Var
     ar : ArPtr;
Begin
     New(ar);
     ssreg := seg(ar^);
     spreg := ofs(ar^) + 1998 - 14;     {go to stack bottom}
     memw[ssreg:spreg+2] := ofs(body^);
     memw[ssreg:spreg+4] := seg(body^);
     stack := ar;
     pri   := Pr;
     size  := 0;
End {Process.Init};
{----------------------------------------------------------}
Destructor Process.Done;
Begin
     Dispose(stack);
End {Process.Done};
{----------------------------------------------------------}
Function Process.GetQueue : ListPtr;
Begin
     GetQueue := queue;
End {Process.GetQueue};
{----------------------------------------------------------}
Procedure Process.SetQueue(L : ListPtr);
Begin
     queue := L;
End {Process.SetQueue};
{----------------------------------------------------------}
Function Process.GetTact : word;
Begin
     GetTact := tact;
End {Process.GetTact};
{----------------------------------------------------------}
Procedure Process.SetTact(T : word);
Begin
     tact := T;
End {Process.SetTact};
{----------------------------------------------------------}
Procedure Process.SetSort(S : SortType);
Begin
     sort := S;
End {Process.SetSort};
{----------------------------------------------------------}
Function  Process.GetSort : SortType;
Begin
     GetSort := sort;
End {Process.GetSort};
{----------------------------------------------------------}
Procedure Process.SetSize(N : Word);
Begin
     Size := N;
End {Process.SetSize};
{----------------------------------------------------------}
Function  Process.GetSize    : Word;
Begin
     GetSize := Size;
End {Process.GetSize};
{----------------------------------------------------------}
Constructor List.Init;
Begin
     beg := nil;
End {List.Init};
{----------------------------------------------------------}
Destructor List.Done;
Var
   N : ElmPtr;
Begin
     while beg <> nil do begin
          N   := beg;
          beg := N^.GetNext;
          Dispose(N,Done);
     end {while};
End {List.Done};
{----------------------------------------------------------}
Function List.GetBeg : ElmPtr;
Begin
     GetBeg := beg;
End {List.GetBeg};
{----------------------------------------------------------}
Procedure List.Remove(E : ElmPtr);  {remove object from queue}
Var
   S : ElmPtr;
Begin
     if E = beg then               {if first}
          beg := E^.GetNext
     else begin
          S := beg;
          while S^.GetNext <> E do begin
                S := S^.GetNext
          end;
          S^.SetNext(E^.GetNext);
     end;
     E^.SetQueue(nil);             {only for processes}
End {List.Remove};
{----------------------------------------------------------}
Procedure   List.Incl(E  : ElmPtr);
Var          {include object with priority}
   en,ep : ElmPtr;
Begin
     en := beg;
     ep := nil;
     while (en <> nil) and (en^.GetPri >= E^.GetPri) do begin
             ep := en;
             en := en^.GetNext;
     end;
     if ep = nil then    {List is empty or include before the first}
               beg := E
        else
               ep^.SetNext(E);
     E^.SetNext(en);
     E^.SetQueue(@Self);
End {List.InclPri};
{----------------------------------------------------------}
Constructor ListT.Init;
Begin
     List.Init;
End {ListT.Init};
{----------------------------------------------------------}
Destructor ListT.Done;
Begin
     List.Done;
End {ListT.Done};
{----------------------------------------------------------}
Procedure ListT.Activisation; {activisation of processes, delayed to}
Var                           {current tick}
   N,S : ElmPtr;
Begin
     N := beg;
     while N <> nil do begin
           S := N^.GetNext;
           if N^.GetTact = Tick then begin  {must be activisate}
                  Remove(N);         {remove from ListT - ListDelayT}
                  ListReady.Incl(N); {include to ListReady}
           end;
           N := S;              {go to next}
     end {while};
End {List.Activisation};
{----------------------------------------------------------}
Constructor ListR.Init;
Begin
     List.Init;
End {listR.Init};
{----------------------------------------------------------}
Destructor ListR.Done;
Begin
     List.Done;
     ListDelayT.Done;
     ListDelay .Done;
     ListKill  .Done;
     Dispose(Cur,Done);
     Dispose(Main,Done);
     DosSem.Done;
End {ListR.Done};
{----------------------------------------------------------}
Procedure ListR.Start;
Begin
     DI;
     GetIntVec(TimerIntNo,IntPtr);
     SetIntVec(SavedIntNo,IntPtr);
     SetIntVec(TimerIntNo,@Handler);
     Cur := GetBeg;           {Get first process, it will be current}
     Remove(Cur);             {remove it from queue}
     Transfer(Main,Cur);
End {ListR.Start};
{----------------------------------------------------------}
Procedure ListR.Stop;
Begin
     DI;
     GetIntVec(SavedIntNo,IntPtr);
     SetIntVec(TimerIntNo,IntPtr);
     Transfer(Cur,Main);
End {ListR.Stop};
{----------------------------------------------------------}
Procedure ListR.GoToNext;
Begin
     Prev := Cur;             {save current in prev}
     Incl(Prev);              {include it to ListReady}
     Cur := GetBeg;           {Get first process, it will be current}
     Remove(Cur);             {remove it from queue}
     Transfer(Prev,Cur);
End {ListR.GoToNext};
{----------------------------------------------------------}
Procedure ListR.Add(P : Pointer; Pr : integer; Var Pt : ProcPtr);
Begin            {Create process}
     DI;
        Pt  := new(ProcPtr,Init(P,Pr));    {create new process}
        Incl(Pt);                          {include it to ListReady}
     EI;
End {ListR.Add};
{----------------------------------------------------------}
{  Next procedure may be act as various operators:
 - ListReady.Move(proc,ListDelay,0)  - delay process to resume;
 - ListReady.Move(proc,ListReady,0)  - resume process;
 - ListReady.Move(proc,ListKill,0)   - carry process to kill queue
 - ListReady.Move(proc,ListDelayT,T) - delay process to time T}
Procedure ListR.Move(P : ElmPtr; Var L : List; T : word);
Var
   S : ListPtr;
Begin
     DI;
     S := P^.GetQueue;              {what queue process P in}
     if S <> nil then S^.Remove(P); {S = nil for current process}
     Prev := Cur;
     if Prev <> P then Incl(Prev);  {include prev to ListReady}
     L.Incl(P);                     {include P to List   L}
     P^.SetTact(T + Tick);          {only to L - ListDelayT}
     Cur := GetBeg;
     Remove(Cur);
     Transfer(Prev,Cur);
End {ListR.Move};
{----------------------------------------------------------}
Procedure ListR.MoveSelf(Var L : List; T : word);
Begin
     Move(Cur,L,T);
End {ListR.Move};
{----------------------------------------------------------}
Constructor Semaphore.Init(S : integer);
Begin
   List.Init;           {beg := nil}
   count := S; {S = 0 - Signals from TopSpeed Modula-2/S = 1 - semaphors}
End {Semaphore.Init};
{----------------------------------------------------------}
Destructor Semaphore.Done;
Begin
     List.Done;
End {Semaphore.Done};
{----------------------------------------------------------}
Procedure Semaphore.Wait_P;
Var
   P,N : ElmPtr;
Begin
    DI;
    dec(count);
    if count < 0 then begin          {must be wait to Send}
       Prev := Cur;
       Incl(Prev);                   {include Рrev to semaphore queue}
       Cur := ListReady.GetBeg;      {get first from ListReady}
       ListReady.Remove(Cur);        {remove it}
       Transfer(Prev,Cur);
    end;
    EI;
End {Semaphore.Wait_P};
{----------------------------------------------------------}
Procedure Semaphore.Send_V;
Var
   P : ElmPtr;
Begin
     DI;
     inc(count);
     if count <= 0 then begin     {there are waited processes}
        P := GetBeg;              {get first from semaphore queue}
        Remove(P);                {remove it from semaphore queue}
        ListReady.Incl(P);        {include it to ListReady}
     end;
     EI;
End {Semaphore.Send_V};
{----------------------------------------------------------}
Constructor Box.Init;
Begin
     QProc.Init;
     QMes.Init;
End {Box.};
{----------------------------------------------------------}
Destructor  Box.Done;
Begin
     QProc.Done;
     QMes.Done;
End {Box.};
{----------------------------------------------------------}
Function    Box.GetMsg : Pointer;
Var
     L   : ElmPtr;
     P,N : ElmPtr;
Begin
     DI;
     if QMes.GetBeg = nil then begin     {message queue is empty}
          Prev := Cur;
          QProc.Incl(Prev);              {include process to box queue}
          Cur := ListReady.GetBeg;
          ListReady.Remove(Cur);
          Transfer(Prev,Cur);
          DI;               {process begin to act from this point DI}
     end;
     L := QMes.GetBeg;             {get first message element}
     QMes.Remove(L);               {remove it from queue}
     GetMsg := L^.GetMes;          {get pointer to message}
     Dispose(L,Done);
     EI;
End {Box.GetMsg};
{----------------------------------------------------------}
Procedure   Box.PutMsg(M : Pointer);
Var
     P : ElmPtr;
     S : MesPtr;
Begin
     DI; {Message priority is the same as priority of process that send}
     S := new(MesPtr,Init(M,Cur^.GetPri));
     QMes.Incl(S);                      {include message in queue}
     if QProc.GetBeg <> nil then begin  {there arе processes waited message}
             P := QProc.GetBeg;         {get first process}
             QProc.Remove(P);           {remove it from queue}
             ListReady.Incl(P);         {include it to ready queue}
     end;
     ListReady.GoToNext;
End {Box.PutMsg};
{----------------------------------------------------------}
Begin
     ListReady .Init;
     ListDelay .Init;
     ListKill  .Init;
     ListDelayT.Init;
     Main := New(ProcMPtr,Init);
     Tick := 0;
     DosSem.Init(1);
     ListReady.Add(@Idler,-1,IdlProc);
End {MultiObj}.




