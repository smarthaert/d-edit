Uses CRT;

Begin
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
End.
