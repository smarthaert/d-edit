{ Lion Studio 1998 }
{ *** Установка клавиш упpавления для игpы TANKS *** }
Uses Crt;

{ Функция ожидаюшая нажатия клавиши и возврашающая ее скан-код }
Function Key:Byte;
  Begin
    Repeat Until KeyPressed;
    Key:=Port[$60];
    While KeyPressed do ReadKey;
  End;

Var  { Клавиши управления }
      Up    :Array[1..2] of Byte;
      Down  :Array[1..2] of Byte;
      Left  :Array[1..2] of Byte;
      Right :Array[1..2] of Byte;
      Fire  :Array[1..2] of Byte;
      F:File;
      I:Byte;
Begin
  ClrScr;
  Writeln('Redefine Control Keys for TANKS');Writeln;
  For I:=1 to 2 do
    Begin
      Writeln;
      Writeln('  Redefine keys for Player ',I);
      Writeln('    Up    ');Up[I]:=Key;
      Writeln('    Down  ');Down[I]:=Key;
      Writeln('    Left  ');Left[I]:=Key;
      Writeln('    Right ');Right[I]:=Key;
      Writeln('    Fire  ');Fire[I]:=Key;
    End;
  Assign(F,'DATA\Tanks.cfg');
  Rewrite(F,1);
  BlockWrite(F,Up,2);
  BlockWrite(F,Down,2);
  BlockWrite(F,Left,2);
  BlockWrite(F,Right,2);
  BlockWrite(F,Fire,2);
  Close(F);
  ClrScr;
  Writeln('Type "TANKS" to play');
End.