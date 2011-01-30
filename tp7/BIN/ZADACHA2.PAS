uses crt;
var
   k,a,b,c:byte;
   s:integer;
begin
  clrscr;
  write('Введите трехразрядное целое число: ');
  readln(s);
      k:=s div 1000;
      a:=s mod 1000 div 100;
      b:=s mod 100 div 10;
      c:=s mod 10;
    if (a=b) or (b=c) or (c=a) or (k=a) or (k=b) or (k=c) then
      writeln('true') else
      writeln('false');
  readln;
end.