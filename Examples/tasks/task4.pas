{ 4) Дан массив A. Вывести массив B такой,что B[i,j]=2*A[i,j] }
var
  N,M : integer; { Количество строк и столбцов }
  A,B : array [1..10,1..10] of integer; { Двумерные массивы A и B }
  i,j : integer; { Переменные цикла }
begin
  { Ввод массива A }
  Write('Введите количество строк (1..10): '); Readln(N);
  Write('Введите количество столбцов (1..10): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('Введите A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { Вычисление массива B }
  for i:=1 to N do
    for j:=1 to M do
      B[i,j] := 2 * A[i,j];
  { Вывод массива B }
  for i:=1 to N do begin
    for j:=1 to M do begin
      Write(B[i,j]:4);
    end;
    Writeln;
  end;
end.
