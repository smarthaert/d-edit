{ 1) Найти сумму отрицательных эл одномерного массива }
const MaxSize = 100; { Максимальный размер массива }
var
  N : integer; { Количество элементов массива }
  A : array [1..MaxSize] of integer; { Одномерный массив }
  i : integer; { Переменная цикла }
  sum : integer; { Сумма }
begin
  { Ввод массива }
  Write('Введите количество элементов: '); Readln(N);
  for i:=1 to N do begin
    Write('Введите A[',i,']: ');
    Readln(A[i]);
  end;
  { Вычисление суммы }
  sum := 0;
  for i:=1 to N do
  if A[i] < 0 then
    sum := sum + A[i];
  { Вывод ответа }
  writeln('Сумма: ',sum);
end.