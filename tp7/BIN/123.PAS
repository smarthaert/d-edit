program p;
var
f,f1:text;
s, s1:string;
begin
assign(f,'2.txt');
assign(f1,'1.txt');
reset(f);
while not eof(f) do
begin
rewrite(f1)
readln(f,s1);
writeln(f1,s);
end;
close(f);
append(f);

write(f,'y:4:0');
close(f);
readln
end.