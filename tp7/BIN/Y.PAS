program  br;
uses crt;
type a=record
     f,n:string;
     end;
        b=record
        fam:a;
        rost:integer;
        end;
var m:array [1..5] of b;
    c:b;
    i,j:integer;
begin
clrscr;
writeln('vvedite familiu rost imya');
  for i:=1 to 5 do
  begin
  write('fam');
  readln(m[i].fam.f);
  write('name');
  readln(m[i].fam. n);
  write('rost');
  readln(m[i].rost);
  end;
for j:=1 to 4 do
 for i:=1  to 5-j do
  if m[i].rost>m[i+1].rost then
  begin
  c:=m[i];
  m[i]:=m[i+1];
  m[i+1]:=c;
  end;



for i:=1 to 5 do
   begin
   write(m[i].fam.f,' ');
  write(m[i].fam. n,' ');
  write(m[i].rost,' ');
  writeln;
  end;
readkey;
end.
