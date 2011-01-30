Program Example;
Uses Crt, Corobj, Dos, Objects;
Var
   proc1,
   proc2,
   proc3  : Process;
   IntPtr : Pointer;

   ReadyList : PCollection;

   Cur, Old : Process;

Const
     TimerIntNo =    8;
     SavedIntNo =  $78;
{-----------------------------------------------------}
Procedure P3;
Var
     ch : Char;
Begin
     while true do begin
         If KeyPressed Then Begin
            ch := ReadKey;
            If ch = #27 Then Begin
                  asm cli end;
                  GetIntVec(SavedIntNo,IntPtr);
                  SetIntVec(TimerIntNo,IntPtr);
                  Transfer(Cur,Main);
            End;
         End;
     end {while};
End {P3};
{-----------------------------------------------------}
Procedure P2;
Var
   k  : longint;
   ch : Char absolute $B800:$0008;
Begin
     while true do begin
         ch := '2';
         For k := 1 To 500000 Do Begin  End;
         ch := ' ';
         For k := 1 To 500000 Do Begin  End;
     end {while};
End {P2};
{-----------------------------------------------------}
Procedure P1;
Var
     k : longint;
     ch : Char absolute $B800:$0000;
Begin
     while true do begin
         ch := '1';
         For k := 1 To 500000 Do Begin  End;
         ch := ' ';
         For k := 1 To 500000 Do Begin  End;
     end {while};
End {P1};
{-----------------------------------------------------}
Procedure Handler;
Interrupt;
Begin
     asm
         cli
         int 78h
     end;
     Old := Cur;
     ReadyList^.Insert(Old);
     Cur := Process(ReadyList^.At(0));
     ReadyList^.AtDelete(0);
     Transfer(Old, Cur);
End {Handler};
Begin
     ClrScr;
     GoToXY(1, 10);
     Writeln(MemAvail);
     ReadyList := New(PCollection, Init(10, 5));
{
     Proc1 := New(Process, Init(@P1));
     Proc2 := New(Process, Init(@P2));
     Proc3 := New(Process, Init(@P3));
     ReadyList^.Insert(Proc1);
     ReadyList^.Insert(Proc2);
     ReadyList^.Insert(Proc3);
}
     ReadyList^.Insert(New(Process, Init(@P1)));
     ReadyList^.Insert(New(Process, Init(@P2)));
     ReadyList^.Insert(New(Process, Init(@P3)));

     asm cli end;
     GetIntVec(TimerIntNo,IntPtr);
     SetIntVec(SavedIntNo,IntPtr);
     SetIntVec(TimerIntNo,@Handler);

     Cur := Process(ReadyList^.At(0));
     ReadyList^.AtDelete(0);
     Transfer(Main, Cur);

     Dispose(ReadyList, Done);
     Dispose(Cur, Done);
     GoToXY(1, 12);
     Writeln(MemAvail);
     Readkey;
End {Example}.


