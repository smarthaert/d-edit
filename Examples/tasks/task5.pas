{ 5)Вывести номера чётных эл двумерного массива }
const Size = 10;
var
  N,M : integer; { Количество строк и столбцов }
  A : array [1..Size,1..Size] of integer; { Двумерный массив A }
  i,j : integer; { Переменные цикла }
begin
  { Ввод массива A }
  Write('Введите количество строк (1..',Size,'): '); Readln(N);
  Write('Введите количество столбцов (1..',Size,'): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('Введите A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { Вывод номеров чётных элементов }
  for i:=1 to N do
    for j:=1 to M do
      if A[i,j] mod 2 = 0 then
        Writeln('Чётный элемент: A[',i,',',j,'] = ',A[i,j]);
end.
