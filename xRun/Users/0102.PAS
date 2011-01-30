Program vor_2;
{
 В основе данного алгоритма лежит идея, что наименьшее кол-во циклов
 получается если на каждом цикле вычитать из наибольшего числа второе
 по величине.

 Для этого в начале каждого цикла необходимо искать сначала максимальное
 число, а затем максимальное число из оставшихся.

 При таком алгоритме заранее неизвестно кол-во предстоящих циклов.
 Поэтому в данной программе, чтобы удовлетворить заданному формату вывода,
 индексы уменьшаемого и вычитаемого сохраняются в буферном массиве. Затем
 последовательно выводятся кол-во циклов и индексы из буферного массива.
}
var Num: array[1..10] of integer;
var Buf: array[1..1000,1..2] of integer;
var i, N, M, L, RC, Max1, Max2: integer;
begin
{  assign(input,'in.txt'); reset(input);
  assign(output,'out.txt'); rewrite(output);}
{ Ввод исходных данных: }
 read(N);
 if N > 10 then N := 10;
 for i:=1 to N do readln(Num[i]);
{ Подсчет НОД  }
 M := 0;
 while 1=1 do
 begin
  L := 0;
  for i:=1 to N do { Проверка кол-ва ненулевых чисел }
  begin
   if Num[i] > 0 then L := L + 1;
  end;
  if L < 2 then Break;

  Max1 := 1;
  for i:=1 to N do { Поиск максимального числа }
  begin
   if Num[i] > Num[Max1] then Max1 := i;
  end;
  if Max1 = 1 then
  begin
   Max2 := 2;
  end
  else
  begin
   Max2 := 1;
  end;
  for i:=1 to N do { Поиск второго по величине числа }
  begin
   if (Num[i] > Num[Max2]) and (i <> Max1) then Max2 := i;
  end;
  Num[Max1] := Num[Max1] - Num[Max2];
  M := M + 1;
  Buf[M][1] := Max1;
  Buf[M][2] := Max2;
 end;
 { Вывод чисел: }
 writeln(M);
 for i:=1 to M do writeln(Buf[i][1],' ',Buf[i][2]);


end.