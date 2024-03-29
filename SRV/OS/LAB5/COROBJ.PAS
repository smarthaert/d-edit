Unit Corobj;
Interface
Uses Objects;
Type
    arptr    = ^artype;
    artype   = array[0..999] of word; {��� �⥪ - 1000 ᫮�}

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
                     Constructor Init(Body : Pointer);
                     Destructor  Done; Virtual;
               end;

PSemaphore = ^TSemaphore;
TSemaphore = Object
     Count : Integer;
     List  : PCollection;
     Constructor Init(C : Integer);
     Destructor  Done; Virtual;
     Procedure   P;
     Procedure   V;
End {TSemaphore};


Procedure Transfer(OldProc,NewProc:PMain);

Var
     Main : PMain;
     Sem  : PSemaphore;
     Cur,
     Old  : Process;
     ReadyList : PCollection;
{--------------------------------------------------------------------------}
Implementation

Constructor TSemaphore.Init(C : Integer);
Begin
     Count := C;
     List  := New(PCollection, Init(10, 5));
End {TSemaphore.Init};

Destructor TSemaphore.Done;
Begin
     Dispose(List, Done);
End {TSemaphore.Done};

Procedure TSemaphore.P;
Begin
     Asm cli End;
     Dec(Count);
     If Count < 0 Then Begin
        Old := Cur;
        List^.Insert(Old);
        Cur := Process(ReadyList^.At(0));
        ReadyList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Asm sti End;
End {TSemaphore.P};

Procedure TSemaphore.V;
Begin
     Asm cli End;
     Inc(Count);
     If Count <= 0 Then Begin
        Old := Cur;
        ReadyList^.Insert(Old);
        Cur := Process(List^.At(0));
        List^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Asm sti End;
End {TSemaphore.V};

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
Asm                    {��������� ��᫥ Call Transfer
                        ����⠢��� push bp; mov bp,sp}
   les di,oldproc
   mov es:[di+2],ss      {oldproc.ssreg := ss;}
   mov es:[di+4],sp    {oldproc.spreg := sp; ���� ������ � sp+2}
   les di,newproc
   mov ss,es:[di+2]      {ss := newproc.ssreg;}
   mov sp,es:[di+4]    {sp := newproc.spreg;}
   pop bp      {��⠫������� bp �뢮��� �⥪ �� ���� ������}
   sti
   ret 8
       {��⮫��㫨 8 ���⮢ - 4 ᫮�� - ���祭�� oldproc � newproc}
End {Transfer};
{-----------------------------------------------------}
Begin
     Main := New(PMain, Init);
End {Corout}.


