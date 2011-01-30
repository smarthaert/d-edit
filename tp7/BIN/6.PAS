 program massiv1;
 uses crt;
type  m=array[1..3] of integer;
var  i:integer;
 m1:m;
 m2:m;
procedure mas (var m1:m);

  begin
  for i:=1 to 3 do
  readln(m1[i]);
end;
procedure mas2 (m2:m);
begin
  for i:=1 to 3 do
  writeln('вывод массива');
  write(m2[i]);
end;

begin
  {mas1 (m);}
  mas2 (m2);
  readkey;
end.