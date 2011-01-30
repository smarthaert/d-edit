Uses CRT;

Var T:Text;
Begin
  Assign(T,'TEST.TXT');
  Rewrite(T);
  Writeln(' CS := ',CSeg);
  Writeln('Press ESC to exit');
  Asm
   @@1:
    In  AL,60h
    Cmp AL,1
    JNE @@1
  End;
  While KeyPressed do ReadKey;
  Writeln;
  Close(T);
End.
