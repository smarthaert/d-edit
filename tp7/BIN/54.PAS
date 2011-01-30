program modul;
uses summa3;
const n=100;
var k,m,l:integer;
procedure summa1(a,b,c:integer);
begin

c:=(a+b)*10;
writeln(c);
end;

begin
writeln('n=',n);
writeln('nm=',summa3.n);
 writeln('vvedite k,m=');
readln(k,m);
summa1(k,m,l);
summa3.summa1(k,m,l);
readln;
end.
