uses crt;
const n=5; m=5;
var
  a:array[1..n, 1..m] of integer;
  i,j: integer;
  x: integer;
  c: char;
begin
clrscr;randomize;
repeat
for i:= 1 to n do
begin
for j:= 1 to m do
begin
a[i,j]:=random (21)-10;
write (a[i,j],' ');
end;
writeln
end;
writeln;
for i:=1 to m-1 do
for j:=i+1 to m do
if a[n,i] > a[n,j] then
begin
x:=a[n,i];
a[n,i]:=a[n,j];
a[n,j]:=x;
end;
for i:=1 to n do
begin
for j:=1 to m do
write (a[i,j],' ');
writeln;
end;
writeln ('если вы хотите выйти нажмите y, если хотите продолжить нажмите любую клавишу');
readln (c);
until c='y';
end.
