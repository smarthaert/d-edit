Uses CRT;
Var Key:Char;
Begin
  Writeln('ASCII codes !  ESC - Exit ...');
  Repeat
    Key:=ReadKey;
    Writeln(Ord(Key));
  Until Key=#27;
End.