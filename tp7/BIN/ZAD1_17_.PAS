uses crt;
var
  a,b,c,d:byte;
  s:integer;
begin
  clrscr;
  writeln('');
  write('Введите четырехзначное число: ');
  readln(s);
  a:=s div 1000;
  b:=(s-a*1000) div 100;
  c:=(s-a*1000-b*100) div 10;
  d:=s mod 10;
  if ((a+b)=(c+d)) then
  writeln('true') else
  writeln('false');
  readln;
end.

