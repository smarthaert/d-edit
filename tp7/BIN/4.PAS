program p1;
uses crt;
var y, a, b, k: real;
   begin
     clrscr;
     writeln('vvedite a i b');
     readln(a,b);
     if a<=0 then  writeln('oshibka')
     else
     begin
     k:=a*sin(b) - exp (b*ln(a));
     if k=0 then
     write('oshibka')
     else
     begin
     if a>0 then
     y:=(exp(7*ln(a))+3*a-b)/k
     else
     writeln('oshibka');
     end;
     end;
   writeln(y:4:5);
   readkey;
   end.