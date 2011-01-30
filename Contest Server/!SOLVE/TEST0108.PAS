Var A,B,C:LongInt;
Begin
  Readln(A);
  Readln(B);
  C:=0;
  Repeat
    Inc(C);
    If A > B then A:=A mod B Else B:=B mod A;
    Writeln(C:4,' - ',A:4,' - ',B:4);
  Until ((A=0) Or (B=0));
End.