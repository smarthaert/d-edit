{ Turbo Pascal - Занятие 3. Умножение матрицы на число }
uses CRT; { Подключаем модуль CRT }
var
  { Объявляем 2-х мерный массив целых чисел 
    с индексами от 1 до 10 по обеим измерениям }
  A : array [1..10,1..10] of integer; 
  Rows, { Количество строк матрицы }
  Cols, { Кол-во столбцов }
  i,j, { Переменные цикла }
  T { Число, на которое умножать матрицу }
  : integer; { Все переменные целого типа }

{ Процедура для вывода матрицы на экран }
{ Процедуры отличаются от 
   функций возвращением значения 
  Процедуры - НЕ возвращают значения
  Функции - возвращают
}
procedure ShowMatrix;
begin { Процедура начинается с ключевого слова begin } 
  { Вывод разделителя на экран }
  writeln('==================');
  { Цикл: переменная i меняется от 1 до Rows с шагом 1 }
  for i:=1 to Rows do begin
    { j меняется от 1 до Cols - 1,2,3...Cols }
    for j:=1 to Cols do begin
      jj := j*2; { Меняется 2,4,6... }
      Write(A[i,j] : 7);
    end;
    writeln;
  end;
end;

{
  Как сделать цикл с шагом 2?
   j:=1;
   while j<10 do begin
     ..что-то делаем...
     j := j + 2; // либо inc(j,2);
   end;
}


procedure MulMatrix( M : integer { Параметр процедуры } );
begin
  for i:=1 to Rows do
    for j:=1 to Cols do
      A[i,j] := A[i,j]*M;
end;

begin
  ClrScr; { Очистка экрана }
  writeln;
  writeln;
  WriteLn('Matrix Size');
  Write('Rows = '); ReadLn(Rows);
  Write('Cols = '); ReadLn(Cols);
  for i:=1 to Rows do
    for j:=1 to Cols do begin
      Write('A[',i,',',j,'] = ');
      ReadLn(A[i,j]);
    end;
  Write('T = '); ReadLn(T);
  ShowMatrix; { Вызов (использование) процедуры }
  MulMatrix(T);
  ShowMatrix;
  readln;
end.