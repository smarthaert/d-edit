Uses CRT;

Var C:Byte;
Begin
  ClrScr;
  Writeln('Press "ESC" for Exit !');
  Repeat
    C := Port[$60];
    GotoXY(2,2); Write('  ',C,'  ');
    While KeyPressed do ReadKey;
  Until C = 1;
End.