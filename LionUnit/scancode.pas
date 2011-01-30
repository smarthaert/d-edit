{ Программа Выводящая Скан-Коды Клавиш, Выход - ESC }
Uses CRT;
Var D:Byte;
Begin
  ClrScr;
  TextColor(11);
  Writeln('Программа выводящая скан-коды клавиш. Выход - ESC (Код ESC-1)');
  Repeat
    D:=Port[$60];
    GotoXY(2,2);
    Write('Скан Код - ',D,'  ');
  Until D = 1;
  ClrScr;
End.