{ Программа на которой все это тестируется :) }
Uses CRT;

Begin
  Writeln(' CS := ',CSeg);
  Writeln('Press ESC to exit');
  Asm { Ожидается нажатие клавиши ESC }
   @@1:
    In  AL,60h
    Cmp AL,1
    JNE @@1
  End;
  While KeyPressed do ReadKey;
  Writeln;
End.
