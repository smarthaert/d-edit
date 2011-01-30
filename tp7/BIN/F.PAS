uses Crt;
var
A:array[1..10,1..10] of integer;
B:array[1..10] of integer;
R:integer;
i,j,K:integer;
begin;
ClrScr;
{sozdaem massiv}
randomize;
   for i:=1 to 10 do
      begin;
       for j:=1 to 10 do
         begin;
           A[i,j]:=random(10);
      end;
         end;
  {bibodim ha ekran}
       for i:=1 to 10 do
      begin;
       for j:=1 to 10 do
         begin;
         R := A[i,j];
         write(R:8);
      end;
         end;
         readln;
         {sozdaem massib B}
         for i:=1 to 10 do
             begin;
             R:=10-i+1;
             B[i]:=R;
             end;

         {perestavlyaem stroki massiva B}
            for i:=1 to 10 do
            begin;
            for j:=1 to 10 do
            begin;
              K:=B[i];
              R:=A[K,j];
              write(R:8);
              end;
              end;
              readln;
         end.