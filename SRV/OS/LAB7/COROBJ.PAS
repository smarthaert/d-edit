Unit Corobj;
Interface
Uses Objects;
Type
    arptr    = ^artype;
    artype   = array[0..999] of word; {под стек - 1000 слов}

    PMessage = ^TMessage;
    TMessage = Object(TObject)
          Ptr : Pointer;
          Constructor Init(P : Pointer);
          Destructor  Done; Virtual;
    End {TMessage};

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


     PPostBox = ^TPostBox;
     TPostBox = Object
           MList : PCollection;
           PList : PCollection;
           GList : PCollection;
           Constructor Init;
           Destructor  Done; Virtual;
           Procedure   Put(P : Pointer);
           Procedure   Get(Var P : Pointer);
     End {TBuffer};


Procedure Transfer(OldProc,NewProc:PMain);

Var
     Main : PMain;

     IntPtr : Pointer;

     ReadyList : PCollection;

     Cur, Old : Process;

Const
     TimerIntNo =    8;
     SavedIntNo =  $78;
{--------------------------------------------------------------------------}
Implementation

Constructor TMessage.Init(P : Pointer);
Begin
      Ptr := P;
End {TMessage.Init};

Destructor TMessage.Done;
Begin
End {TMessage.Done};

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
Constructor TPostBox.Init;
Begin
        PList := New(PCollection, Init(10, 5));
        GList := New(PCollection, Init(10, 5));
        MList := New(PCollection, Init(10, 5));
End {TPostBox.Init};
{-----------------------------------------------------}
Destructor TPostBox.Done;
Begin
     Dispose(PList, Done);
     Dispose(GList, Done);
     Dispose(MList, Done);
End {TPostBox.Done};
{-----------------------------------------------------}
Procedure TPostBox.Put(P : Pointer);
Begin
     Asm cli End;
     MList^.Insert(New(PMessage, Init(P)));
     Old := Cur;
     PList^.Insert(Old);
     If GList^.Count > 0 Then Begin
        Cur := Process(GList^.At(0));
        GList^.AtDelete(0);
     End Else Begin
        Cur := Process(ReadyList^.At(0));
        ReadyList^.AtDelete(0);
     End {If};
     Transfer(Old, Cur);
     Asm sti End;
End {TPostBox.Put};
{-----------------------------------------------------}
Procedure TPostBox.Get(Var P : Pointer);
Var
     PMsg : PMessage;
Begin
     Asm cli End;
     If MList^.Count = 0 Then Begin
        Old := Cur;
        GList^.Insert(Old);
        Cur := Process(ReadyList^.At(0));
        ReadyList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};

     PMsg := PMessage(MList^.At(0));
     P    := PMsg^.Ptr;
     MList^.AtFree(0);

     Old := Cur;
     ReadyList^.Insert(Old);
     Cur := Process(PList^.At(0));
     PList^.AtDelete(0);
     Transfer(Old, Cur);
     Asm sti End;
End {TPostBox.Get};
{-----------------------------------------------------}
Begin
     Main := New(PMain, Init);
End {Corout}.


