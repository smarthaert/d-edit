Program Kurs_19_1;

uses crt;

Const n= 30;
      diap= 1000;

var a: array [1..n] of integer;
    b: array [1..n] of integer;
    i,k, bliz_arifm: integer;
    sr_arifm: real;
Begin
clrscr;
Randomize;
writeln ('Начальный массив');
For i:= 1 to n do
  begin
    a[i]:=(random(diap)-(diap div 2));
   write (a[i]:5);
  end;
writeln (' ');
writeln ('**********');
writeln ('Выборка по возрастанию');
b[1]:=a[1];
k:=1;
For i:=1 to n do
  begin
    if a[i]>b[k] then
      begin
      b[k+1]:=a[i];
      k:=k+1;
      end;
  end;
For i:=1 to k do writeln (b[i]);
writeln ('**********');
sr_arifm:=0;
for i:=1 to k do sr_arifm:= sr_arifm + b[i];
sr_arifm:= sr_arifm/k;
writeln ('Количество элементов, отличающихся от');
writeln ('среднего арифметического (',(sr_arifm):2:2,') не более, чем в 1.005 раз равно');
bliz_arifm:=0;
for i:= 1 to k do
  begin
  if abs((b[i]/sr_arifm)) < (1.005) then bliz_arifm:=bliz_arifm+1;
  writeln (b[i]/sr_arifm);
  end;
writeln(bliz_arifm);
readln;
End.