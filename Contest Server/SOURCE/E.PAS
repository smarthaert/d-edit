{  Задача E (Несократимые дроби)  }
{ =============================== }
Var T:Text; A,B,C,D,I,J:Word;
Begin
  Assign(T,'INPUT.TXT');
  Reset(T);
  Read(T,A);
  Read(T,B);
  Close(T);
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  For I:=1 to A do
    For J:=1 to B do
      Begin
        C:=I; D:=J;
        Repeat
          If C >= D then C:=C-D;
          If D >= C then D:=D-C;
        Until ((C=0) Or (D=0));
        If (C+D)=1 then Writeln(T,I,'/',J);
      End;
  Close(T);
End.