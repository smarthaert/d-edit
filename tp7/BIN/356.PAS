program firma;
uses crt;
   type A=record
     f:string;
     zp:array[1..4] of real;
     end;
    var m2:array[1..3] of A;
        i,j:integer;
begin
   clrscr;
   for i:=1 to 3 do
begin
  writeln('familia');
  readln(M2[i].f);
  for j:=1 to 4 do
  begin
  writeln('zarplata');
  readln (m2[i].zp[j]);
  end;
end;
  for i:=1 to 3 do
begin
write (m2[i].f);
  write(' ');
  for j:=1 to 4 do
  write(m2[i].zp[j]:4:3,' ');
    writeln;
end;
readkey;
end.
