uses CRT;
var
i,j:integer;
C:integer;
Arr:array[1..200,1..200] of longint;
begin;
ClrScr;
randomize;
for i:=1 to 100 do
    begin;
      for j:=1 to 100 do
      begin;
    Arr[i,j]:=random(100);
    end;
    end;
      for i:=1 to 100 do
         begin;
         for j:=1 to 100 do
         begin;
           C:=Arr[i,j];
           write(C:8);
           end;
           end;
           readln;
           end.
