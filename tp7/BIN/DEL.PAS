 program p1;
 uses crt;
 var c,a, b1, b2, f: real;
      begin
      clrscr;
 writeln ('vvedite chisla a, b1, b2, f');
 readln (a, b1, b2,f);
     while b1<=b2 do
begin
      if b1=0 then
 write ('delenie na 0') else c:=a/b1;

if c>0 then
begin
textcolor(2);
writeln (c:1:0);
     end
 else
     begin
 textcolor (15);
 writeln (c:7:0);

     end;

 b1:=b1+f;
 readln;
end;
 end.


