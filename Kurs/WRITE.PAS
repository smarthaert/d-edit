Var T:Text; A:Char; I:LongInt;
Begin
  Assign(T,'test.txt');
  Rewrite(T);
  For I:=1 to 1024*1024*10 do
    Write(T,A);
  Close(T);
End.