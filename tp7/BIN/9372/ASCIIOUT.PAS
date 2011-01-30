uses crt;
var c: char;
i: integer;

begin
clrscr;
textcolor (7);
for i:=0 to 255 do
  begin
    write (i, '  ', chr(i));
    writeln;
    if (i mod 20) = 0 then
    readln;
  end;
readln;
end.