var
 T: array[1..255] of byte;
 a:byte;
 i,j:byte;
begin
a:=0;
  for j:=1 to 5 do
    begin
     readln(T[j]);
    end;
 for i:=1 to 5 do
    begin
    if (a<T[i]) then a:=T[i];
    end;
writeln('maxchislo=',a);
readln;
end.