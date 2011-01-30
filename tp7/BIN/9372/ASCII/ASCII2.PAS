uses crt;

var i:integer;
    f:text;
begin
  clrscr;
  Assign (F,'TablASCII.txt');
  Rewrite(f);
  for i:=32 to 255 do
    Begin
      writeln (F, i, ' ',chr(i),'  ');
    end;
  Close (f);
end.


