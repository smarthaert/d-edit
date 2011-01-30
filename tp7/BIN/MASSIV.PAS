Program massiv;
uses crt;
var a:array [1..4,1..4] of integer;
x, i, j: integer;
begin
clrscr;
for i:=1 to 4 do
begin
for j:=1 to 4 do
{writeln (a[i,j]);}
readln (a[i,j]);
end;
for i:=1 to 4 do
begin
writeln (a[i,j]);
 for j:=1 to 4 do
 writeln;
  end;
  readkey;
end.







