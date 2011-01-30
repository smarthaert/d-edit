uses tpcrt,crt;
var i,x: byte;

begin
  textcolor (15); textbackground (0);
  clrscr;
  for i:=0 to 15 do
  begin
    textcolor (15); textbackground (0);
    if i<10 then
      write (i,'   ')
    else
      write (i,'  ');
    textcolor (i); write ('Проверка','    ');
    textbackground (i); write ('       ');
    writeln;
  end;
  readln;
  clrscr;
end.