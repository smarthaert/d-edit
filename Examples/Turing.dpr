{ Машина Тьюринга }
{$APPTYPE CONSOLE}

uses SysUtils;

var
  L : array ['1'..'9'] of string; {Ленты}
  P : array ['1'..'9'] of record
    Lenta : '1'..'9';
    Pos : integer; {Текущая позиция на ленте}
  end;
  State : array ['1'..'9'] of char; {Состояние a-z}

begin
  L[1] := '0111133';
  repeat
    {проверяем, что все машины завершены}
    AllFinished := true;
  until AllFinished;
end.

