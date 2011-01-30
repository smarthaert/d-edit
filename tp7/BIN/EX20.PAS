Uses CRT;
Function Beep:string;
         Var i,be:integer;
         Begin
         be:=1000;
         For i:=1 To 5 do Begin
                          Sound(be);Writeln('Sound ON');
                          Delay(1000);Writeln('+1 sec');
                          be:=be+100;
                          End;
         NoSound;Writeln('NoSound');
         End;
Begin
Randomize;ClrScr;
Writeln(Beep);
NoSound;
Readln;
End.