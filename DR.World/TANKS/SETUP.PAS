{ Lion Studio 1998 }
{ *** Установка клавиш упpавления для игpы TANKS *** }
Uses Crt,Control,GameKeyb;

Var Ctrl:TControl;
Begin
  GameKeyb.InitInt09;
  Ctrl.LoadKeys('Data\CtrlKeys.dat');
  Ctrl.RedefineKeys;
  Ctrl.SaveKeys('Data\CtrlKeys.dat');
  GameKeyb.RestoreInt09;
  Writeln('Type "TANKS" to play');
End.