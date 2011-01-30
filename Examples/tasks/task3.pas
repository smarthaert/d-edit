{ 3) Заполнить 2у мерный массив так чтобы на главной диагонали были 0 }
var
  N,M : integer; { Количество строк и столбцов }
  min : integer; { Минимум из количества строк и столбцов }
  A : array [1..10,1..10] of integer; { Двумерный массив }
  i,j : integer; { Переменные цикла }
begin
  Writeln('Ввод массива A');
  Write('Введите количество строк (1..10): '); Readln(N);
  Write('Введите количество столбцов (1..10): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('Введите A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { Заполняем главную диагональ 0-ми }
  if N < M then
    min := N
  else
    min := M;
  for i:=1 to min do
    A[i,i] := 0;
  { Вывод готового массива }
  Writeln('Массив A с 0-ми на главной диагонали:');
  for i:=1 to N do begin
    for j:=1 to M do begin
      Write(A[i,j]:4);
    end;
    Writeln;
  end;
end.
