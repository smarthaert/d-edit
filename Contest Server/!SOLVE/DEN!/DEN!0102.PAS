Var
  N : LongInt;
  A : Array [1..100] of LongInt;
  P : Array [1..100,1..2] of LongInt;
  Min : LongInt;
  PM : Array [1..100,1..2] of LongInt;

Procedure Rec( K:Word );
  Var Cnt,I,J:Integer;
  Begin
    If K > Min then Exit;
   { Count nozero }
    Cnt:=0; For I:=1 to N do If A[I]<>0 then Inc(Cnt);
   { If solve finded ! }
    If Cnt = 1 then
      Begin
        If K < Min then
          Begin
            For I:=1 to (K-1) do
              For J:=1 to 2 do
                PM[I,J]:=P[I,J];
            Min:=K;
          End;
        Exit;
      End;
   { Next step of recurse }
    For I:=1 to N do
      For J:=1 to N do
        If ((A[I] >= A[J]) And (I<>J) And (A[J]<>0)) then
          Begin
            P[K,1]:=I;
            P[K,2]:=J;
            A[I]:=A[I]-A[J];
            Rec(K+1);
            A[I]:=A[I]+A[J];
          End;
  End;

Var I:LongInt;
Begin
  Read(N);
  For I:=1 to N do Read(A[I]);
  Min:=MaxLongInt;
  Rec(1);
  Writeln(Min-1);
  For I:=1 to (Min-1) do
    Writeln(PM[I,1],' ',PM[I,2]);
End.