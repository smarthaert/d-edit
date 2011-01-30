{ Проверка ответов - Task 0102 - LongInt }

{$I trans.inc}
Uses TestLib, SysUtils;

Var NI,User,Jury,I,J,Cnt:LongInt;
    A:Array [1..1000] of LongInt;
    P:Array [1..1000,1..2] of LongInt;
Begin
  NI := inf.ReadLongint;
  User := ouf.ReadLongint;
  Jury := ans.ReadLongint;
  If User<>Jury then Quit(_WA,'Количество не совпадает!');
  //
  For I:=1 to NI do
    A[I] := inf.ReadLongint;
  {}
  For I:=1 to User do
    For J:=1 to 2 do
      P[I,J]:=ouf.ReadLongint;
  {}
  For I:=1 to User do begin
    If ( (P[I,1] < 1) Or (P[I,1] > NI) Or
         (P[I,1] < 1) Or (P[I,1] > NI) Or
         (P[I,1] = P[I,2]) ) then
      Quit(_WA,'!');
    If A[P[I,1]] < A[P[I,2]] then
      Quit(_WA,'!');
    A[P[I,1]] := A[P[I,1]] - A[P[I,2]];
  End;
  {}
  Cnt:=0;
  For I:=1 to NI do
    If A[I]<>0 then Inc(Cnt);
  If Cnt<>1 then
    Quit(_WA,'');
  Quit(_OK,'Всё верно!');
End.
