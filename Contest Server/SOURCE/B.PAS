{  Задача B (Числа Фибоначчи)  }
{ ============================ }
Var T:Text; N,I:Word; P:LongInt;
Begin
  Assign(T,'INPUT.TXT');
  Reset(T);
  Read(T,N);
  Close(T);
  P:=1;
  For I:=1 to N do P:=P*I;
  Assign(T,'OUTPUT.TXT');
  Rewrite(T);
  Writeln(T,P);
  Close(T);
End.