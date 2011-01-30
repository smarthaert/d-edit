program asd;
var f, g, h: text;
a, b: char;
x, y: integer;
c: boolean;
begin
assign (f, 'd:\u\fin.txt');
assign (g, 'd:\u\gin.txt');
assign (h, 'd:\u\out.txt');
reset (f);
reset (g);
rewrite (h);
c:=eof (f) or not eof (g);
while c and not eof (f) and not eof (g) do
begin
read (f, a);
read (g, b);
writeln (h, ' ', c)
end;
c:=c and eof (f);
writeln (h,'ответ:',c);
close (f);
close (g);
close (h);
readln;
end.
