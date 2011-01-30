program p;
var
f:text;
a,b,c:integer;
y:real;
begin
assign(f,'2.txt');
reset(f);
readln(f);
readln(f,a,b,c);
close(f);

append(f);
y:=c/(a-b);
write(f,'y:4:0');
close(f);
readln
end.