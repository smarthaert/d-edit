Program Example;
Uses Crt, Corobj, Dos, Objects;
Var
   proc1,
   proc2,
   proc3  : Process;
   IntPtr : Pointer;

   ProcNum : Integer;

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
                  Transfer(Proc3,Main);
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
Procedure Handler; Interrupt;
Begin
     asm
         cli
         int 78h
     end;

     Case ProcNum Of
1  : Begin
         ProcNum := 2;
         Transfer(Proc1, Proc2);
     End;
2  : Begin
         ProcNum := 3;
         Transfer(Proc2, Proc3);
     End;
3  : Begin
         ProcNum := 1;
         Transfer(Proc3, Proc1);
     End;
     Else
     End {Case};
End {Handler};
Begin
     ClrScr;
     GoToXY(1, 10);
     Writeln(MemAvail);

     Proc1 := New(Process, Init(@P1));
     Proc2 := New(Process, Init(@P2));
     Proc3 := New(Process, Init(@P3));

     asm cli end;
     GetIntVec(TimerIntNo,IntPtr);
     SetIntVec(SavedIntNo,IntPtr);
     SetIntVec(TimerIntNo,@Handler);
     ProcNum := 1;
     Transfer(Main, Proc1);

     Dispose(Proc1, Done);
     Dispose(Proc2, Done);
     Dispose(Proc3, Done);

     GoToXY(1, 12);
     Writeln(MemAvail);
     Readkey;
End {Example}.


