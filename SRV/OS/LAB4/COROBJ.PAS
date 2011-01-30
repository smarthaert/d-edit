Unit Corobj;
Interface
Uses Objects;
Type
    arptr    = ^artype;
    artype   = array[0..999] of word; {под стек - 1000 слов}

    PMain    = ^TMain;
    TMain    = object(TObject)
                     ssreg,
                     spreg  : word;
                     Constructor Init;
                     Destructor  Done; Virtual;
               end;

    Process  = ^TProcess;
    TProcess = object(TMain)
                     Stack : ArPtr;
                     Tact  : LongInt;
                     Constructor Init(Body : Pointer);
                     Destructor  Done; Virtual;
               end;


Procedure Transfer(OldProc,NewProc:PMain);

Var
     Main : PMain;
     Time : LongInt;
{--------------------------------------------------------------------------}
Implementation

Constructor TMain.Init;
Begin
End;

Destructor TMain.Done;
Begin
End;

Constructor TProcess.Init(body : pointer);
Begin
          New(Stack);
          ssreg := seg(Stack^);
          spreg := ofs(Stack^) + 1998 - 14;
          memw[ssreg:spreg+2] := ofs(body^);
          memw[ssreg:spreg+4] := seg(body^);
End {TProcess.Init};

Destructor TProcess.Done;
Begin
     Dispose(Stack);
End {TProcess.Done};
{-----------------------------------------------------}
Procedure Transfer(OldProc, NewProc : PMain);
Assembler;
Asm                    {компилятор после Call Transfer
                        подставляет push bp; mov bp,sp}
   les di,oldproc
   mov es:[di+2],ss      {oldproc.ssreg := ss;}
   mov es:[di+4],sp    {oldproc.spreg := sp; адрес возврата в sp+2}
   les di,newproc
   mov ss,es:[di+2]      {ss := newproc.ssreg;}
   mov sp,es:[di+4]    {sp := newproc.spreg;}
   pop bp      {выталкивание bp выводит стек на адрес возврата}
   sti
   ret 8
       {затолкнули 8 байтов - 4 слова - значения oldproc и newproc}
End {Transfer};
{-----------------------------------------------------}
Begin
     Main := New(PMain, Init);
     Time := 0;
End {Corout}.


