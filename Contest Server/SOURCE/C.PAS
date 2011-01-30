{  Задача C (Среднее Арифметическое)  }
{ =================================== }
Var T:Text; I,N,A,B:LongInt;
Begin
  Assign(T,'INPUT.TXT');
  Reset(T);
  Read(T,N);
  A:=0;
  For I:=1 to N do
    Begin
      Read(T,B);
      A:=A+B;
    End;
  Close(T);
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  Writeln(T,A/N:0:3);
  Close(T);
End.