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
                     Constructor Init(Body : Pointer);
                     Destructor  Done; Virtual;
               end;

Const
     BufSize = 10;

Type

     PBuffer = ^TBuffer;
     TBuffer = Object
           Buf   : Array[0..BufSize-1] Of Char;
           R_Ind : 0..BufSize-1;
           W_Ind : 0..BufSize-1;
           Size  : 0..BufSize;
           WList : PCollection;
           RList : PCollection;
           Constructor Init;
           Destructor  Done; Virtual;
           Procedure   Read(Var Ch : Char);
           Procedure   Write(Ch : Char);
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
Constructor TBuffer.Init;
Begin
        R_Ind := 0;
        W_Ind := 0;
        Size  := 0;
        WList := New(PCollection, Init(10, 5));
        RList := New(PCollection, Init(10, 5));
End {TBuffer.Init};
{-----------------------------------------------------}
Destructor TBuffer.Done;
Begin
     Dispose(WList, Done);
     Dispose(RList, Done);
End {TBuffer.Done};
{-----------------------------------------------------}
Procedure TBuffer.Read(Var Ch : Char);
Begin
     Asm cli End;
     If Size = 0 Then Begin {buffer is empty}
{       Writeln('buffer is empty');     }
        Old := Cur;
        RList^.Insert(Old);
        Cur := Process(ReadyList^.At(0));
        ReadyList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Dec(Size);
     Ch    := Buf[R_Ind];
     R_Ind := (R_Ind + 1) MOD BufSize;
     If WList^.Count > 0 Then Begin
        Old := Cur;
        ReadyList^.Insert(Old);
        Cur := Process(WList^.At(0));
        WList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Asm sti End;
End {TBuffer.Read};
{-----------------------------------------------------}
Procedure TBuffer.Write(Ch : Char);
Begin
     Asm cli End;
     If Size = BufSize Then Begin {buffer is full}
{       Writeln('buffer is full');      }
        Old := Cur;
        WList^.Insert(Old);
        Cur := Process(ReadyList^.At(0));
        ReadyList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Inc(Size);
     Buf[W_Ind] := Ch;
     W_Ind      := (W_Ind + 1) MOD BufSize;
     If RList^.Count > 0 Then Begin
        Old := Cur;
        ReadyList^.Insert(Old);
        Cur := Process(RList^.At(0));
        RList^.AtDelete(0);
        Transfer(Old, Cur);
     End {If};
     Asm sti End;
End {TBuffer.Write};
{-----------------------------------------------------}
Begin
     Main := New(PMain, Init);
End {Corout}.


