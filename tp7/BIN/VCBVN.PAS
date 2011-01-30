program abc;
var a,b,c,d,y: real;
begin
writeln ('vvedite a,b');
readln (a,b);
if a>0 then
 begin
  c:=((exp(ln(a)*7))+(a*3)-b);
  d:=((a*sin(b))-(exp(ln(a)*b)));
  y:=c/d;
  writeln (y:2:4);
 end
 else writeln('resheniy net');
readln;
end.























