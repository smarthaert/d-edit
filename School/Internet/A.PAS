Uses CRT;

Var A : Array [1..4] of LongInt;
    B : Array [1..4] of LongInt;
    I,J,K : Byte; FN,SN : Byte; Max : LongInt;
Begin
  Writeln('Введите 4-ре числа:');
  For I:=1 to 4 do Readln(A[I]);
  For I:=1 to 4 do B[I]:=A[I];
 { Алгоритм Евклида }
  J:=1;
  Repeat
    Max:=0;
    Writeln(J,' ',A[1],' ',A[2],' ',A[3],' ',A[4],' - ',FN,' ',SN);
    For I:=1 to 4 do
      If A[I] > Max then Begin Max:=A[I]; FN:=I; End;
    Max:=0;
    For I:=1 to 4 do
      If ((A[I] > Max) And (I<>FN)) then Begin Max:=A[I]; SN:=I; End;
    A[FN]:=A[FN]-A[SN];
    Inc(J);
    K:=0;
    For I:=1 to 4 do If A[I]<>0 then Inc(K);
  Until K=1;
  Writeln(J,' ',A[1],' ',A[2],' ',A[3],' ',A[4],' - ',FN,' ',SN);
  ReadKey;
 { Алгоритм Евклида }
  J:=1;
  Repeat
    Max:=0;
    Writeln(J,' ',B[1],' ',B[2],' ',B[3],' ',B[4],' - ',FN,' ',SN);
    For I:=1 to 4 do
      If B[I] > Max then Begin Max:=B[I]; FN:=I; End;
    Max:=0;
    For I:=1 to 4 do
      If ((B[I] > Max) And (I<>FN)) then Begin Max:=B[I]; SN:=I; End;
    Max:=0;
    For I:=1 to 4 do
      If (((B[FN]-B[I])<B[I]) And ((B[FN]-B[I]) > Max) And (I<>FN)) then
        Begin Max:=B[FN]-B[I]; SN:=I; End;
    B[FN]:=B[FN]-B[SN];
    Inc(J);
    K:=0;
    For I:=1 to 4 do If B[I]<>0 then Inc(K);
  Until K=1;
  Writeln(J,' ',B[1],' ',B[2],' ',B[3],' ',B[4],' - ',FN,' ',SN);
End.