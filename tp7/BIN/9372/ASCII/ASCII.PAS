uses crt;

var i:integer;

begin
  clrscr;
  for i:=32 to 256 do
    Begin
      writeln (i, ' ',chr(i),'  ');
      if (i-31) mod 23 = 0 then
      readkey;
    end;
  readln;
end.


