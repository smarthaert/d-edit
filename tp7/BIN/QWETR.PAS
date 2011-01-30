program laba;
uses crt;
type
a=record
name:string;
nomer:integer;
end;
var f:file of a;
b:a;
i:integer;
d:string;
begin
clrscr;
 assign(f,'46.txt');
 {rewrite(f);
 for i:=1 to 3 do
begin
 write('a.name');
 readln(b.name);
 write('a.nomer');
 readln(b.nomer);
 write(f,b);
end;}
reset(f);
seek(f,0);
write('vvod');
read(d);
while not eof (f) do
 begin
  read(f,b);
  if d=(b.name) then
  writeln(b.name, b.nomer);
 end;
 close(f);
 readkey;
end.


