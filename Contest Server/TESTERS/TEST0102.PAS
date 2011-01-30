{ Проверка ответов - Task 0102 - LongInt }

Uses _Testers;

{$I-}

Var NI,N1,N2,I,J,Cnt:LongInt;
    A:Array [1..1000] of LongInt;
    P:Array [1..1000,1..2] of LongInt;
Begin
  Writeln('Проверка ответов - Task 0102 - LongInt');
  OpenFiles('Test0102');
  NI:=ReadLongInt(FI);
  N1:=ReadLongInt(F1);
  N2:=ReadLongInt(F2);
  If N1<>N2 then ExitProg(cdWrAns);
  For I:=1 to NI do A[I]:=ReadLongInt(FI);
  For I:=1 to N2 do
    For J:=1 to 2 do
      P[I,J]:=ReadLongInt(F2);
  For I:=1 to N2 do
    Begin
      If ( (P[I,1] < 1) Or (P[I,1] > NI) Or
           (P[I,1] < 1) Or (P[I,1] > NI) Or
           (P[I,1] = P[I,2]) ) then ExitProg(cdWrAns);
      If A[P[I,1]] < A[P[I,2]] then ExitProg(cdWrAns);
      A[P[I,1]] := A[P[I,1]] - A[P[I,2]];
    End;
  Cnt:=0; For I:=1 to NI do If A[I]<>0 then Inc(Cnt);
  If Cnt<>1 then ExitProg(cdWrAns);
  ExitProg(cdAllOK);
End.