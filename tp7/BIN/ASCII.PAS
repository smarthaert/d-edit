{ Таблица ASCII символов }
uses crt;

var i:integer;
begin
  ClrScr;
  for i:=30 to 255 do begin
    write(i, ' ',chr(i),'  ');
    if (i-29) mod 10 = 0 then
      writeln;
  end;
  readln;
end.


