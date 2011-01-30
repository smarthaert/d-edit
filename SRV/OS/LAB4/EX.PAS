Program Example;
Uses Crt, Corobj, Dos, Objects;
Var
     proc1,
     proc2,
     proc3,
     proc4     : Process;
     IntPtr    : Pointer;
     ReadyList : PCollection;
     DelayList : PCollection;
     KillList  : PCollection;
     TimeList  : PCollection;
     Cur, Old  : Process;
Const
     TimerIntNo =    8;
     SavedIntNo =  $78;
Procedure P2; Forward;
{----------------------------------------------------------------------------}
Procedure Stop(P : Process);
Begin
     Asm cli End;
     If ReadyList^.IndexOf(P) >= 0 Then Begin
         ReadyList^.Delete(P);
         DelayList^.Insert(P);
     End {If};
     Asm sti End;
End {Stop};
{----------------------------------------------------------------------------}
Procedure Start(P : Process);
Begin
     Asm cli End;
     If DelayList^.IndexOf(P) >= 0 Then Begin
         DelayList^.Delete(P);
         ReadyList^.Insert(P);
     End {If};
     Asm sti End;
End {Start};
{----------------------------------------------------------------------------}
Procedure Kill(P : Process);
Begin
     Asm cli End;
     If ReadyList^.IndexOf(P) >= 0 Then Begin
         ReadyList^.Free(P);
     End {If};
     Asm sti End;
End {Kill};
{----------------------------------------------------------------------------}
Procedure KillSelf;
Begin
     Asm cli End;
         Old := Cur;
         KillList^.Insert(Old);
         Cur := Process(ReadyList^.At(0));
         ReadyList^.AtDelete(0);
         Transfer(Old, Cur);
     Asm sti End;
End {KillSelf};
{----------------------------------------------------------------------------}
Procedure Create(Var P : Process; Body : Pointer);
Begin
     Asm cli End;
        P := New(Process, Init(Body));
        ReadyList^.Insert(P);
     Asm sti End;
End {Create};
{---------------------------------------------------------------------------}
Procedure DelayProcess(P : Process; T : LongInt);
Begin
     Asm cli End;
     If ReadyList^.IndexOf(P) >= 0 Then Begin
         P^.Tact := Time + T;
         ReadyList^.Delete(P);
         TimeList^.Insert(P);
     End {If};
     Asm sti End;
End {DelayProcess};
{---------------------------------------------------------------------------}
Procedure DelaySelf(T : LongInt);
Begin
     Asm cli End;
         Old := Cur;
         Old^.Tact := Time + T;
         TimeList^.Insert(Old);
         Cur := Process(ReadyList^.At(0));
         ReadyList^.AtDelete(0);
         Transfer(Old, Cur);
     Asm sti End;
End {DelaySelf};
{---------------------------------------------------------------------------}
Procedure StartDelayProc;
Var
    k : Integer;
    P : Process;
Begin
    k := 0;
    While k <= TimeList^.Count - 1 Do Begin
          P := TimeList^.At(k);
          If P^.Tact <= Time Then Begin
             TimeList^.Delete(P);
             ReadyList^.Insert(P);
          End Else Begin
             Inc(k);
          End {If};
    End {While};
End {StartDelayProc};
{---------------------------------------------------------------------------}
Procedure P4;
Var
     k  : LongInt;
     i  : LongInt;
     ch : Char absolute $B800:$0010;
Begin
     i := 0;
     while true do begin
         ch := '3';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);                      }
         ch := ' ';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);                      }
         inc(i);
         If i > 20 Then Break;
     end {while};
     KillSelf;
End {P4};
{----------------------------------------------------------------------------}
Procedure P3;
Var
     ch : Char;
Begin
     while true do begin
         If KeyPressed Then Begin
            ch := ReadKey;
            Case ch Of
#27 : Begin
                  asm cli end;
                  GetIntVec(SavedIntNo,IntPtr);
                  SetIntVec(TimerIntNo,IntPtr);
                  Transfer(Cur,Main);
      End;
'1' : Stop(proc1);
'2' : Start(proc1);
'3' : Kill(proc2);
'4' : Create(proc2, @P2);
'5' : Create(proc4, @P4);
'6' : DelayProcess(proc1, 100);
      Else
      End {Case};
         End;
     end {while};
End {P3};
{---------------------------------------------------------------------------}
Procedure P2;
Var
     k  : longint;
     ch : Char absolute $B800:$0008;
Begin
     while true do begin
         ch := '2';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);                    }
         ch := ' ';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);}
     end {while};
End {P2};
{---------------------------------------------------------------------------}
Procedure P1;
Var
     k  : longint;
     ch : Char absolute $B800:$0000;
Begin
     while true do begin
         ch := '1';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);  }
         ch := ' ';
         For k := 1 To 500000 Do Begin  End;
{         DelaySelf(20);}
     end {while};
End {P1};
{---------------------------------------------------------------------------}
Procedure Handler; Interrupt;
Begin
     asm
         cli
         int 78h
     end;
     Inc(Time);
     KillList^.FreeAll;
     StartDelayProc;
     Old := Cur;
     ReadyList^.Insert(Old);
     Cur := Process(ReadyList^.At(0));
     ReadyList^.AtDelete(0);
     Transfer(Old, Cur);
End {Handler};
{---------------------------------------------------------------------------}
Begin
     ClrScr;
     GoToXY(1, 20);
     Writeln(MemAvail);

     ReadyList := New(PCollection, Init(10, 5));
     DelayList := New(PCollection, Init(10, 5));
     KillList  := New(PCollection, Init(10, 5));
     TimeList  := New(PCollection, Init(10, 5));

     Proc1 := New(Process, Init(@P1));
     Proc2 := New(Process, Init(@P2));
     Proc3 := New(Process, Init(@P3));
     Proc4 := New(Process, Init(@P4));

     ReadyList^.Insert(Proc1);
     ReadyList^.Insert(Proc2);
     ReadyList^.Insert(Proc3);
     ReadyList^.Insert(Proc4);
{
     ReadyList^.Insert(New(Process, Init(@P1)));
     ReadyList^.Insert(New(Process, Init(@P2)));
     ReadyList^.Insert(New(Process, Init(@P3)));
}
     asm cli end;
     GetIntVec(TimerIntNo,IntPtr);
     SetIntVec(SavedIntNo,IntPtr);
     SetIntVec(TimerIntNo,@Handler);

     Cur := Process(ReadyList^.At(0));
     ReadyList^.AtDelete(0);
     Transfer(Main, Cur);

     Dispose(ReadyList, Done);
     Dispose(DelayList, Done);
     Dispose(KillList,  Done);
     Dispose(TimeList,  Done);
     Dispose(Cur, Done);

     GoToXY(1, 21);
     Writeln(MemAvail);
     Readkey;
End {Example}.


