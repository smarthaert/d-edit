Var T:Text; A:Char; I:LongInt;
Begin
  Assign(T,'test.txt');
  Reset(T);
  While Not EOF(T) do Read(T,A);
  Close(T);
End.