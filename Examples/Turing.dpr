{ ������ �������� }
{$APPTYPE CONSOLE}

uses SysUtils;

var
  L : array ['1'..'9'] of string; {�����}
  P : array ['1'..'9'] of record
    Lenta : '1'..'9';
    Pos : integer; {������� ������� �� �����}
  end;
  State : array ['1'..'9'] of char; {��������� a-z}

begin
  L[1] := '0111133';
  repeat
    {���������, ��� ��� ������ ���������}
    AllFinished := true;
  until AllFinished;
end.

