Program m1;
  uses crt;
  var a,b,c:real;
begin
  clrscr;
  writeln('Введи a и b');
  readln(a,b);
  if b=0
  then writeln('нет ответа')
  else begin c:=a/b;
  writeln('Ответ=',c);
  end;
  readln;
end.
