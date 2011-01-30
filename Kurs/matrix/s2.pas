{ Программа "Преобразование прямоугольной матрицы" }
const
  MaxM = 30; { максимальное количество строк }
  MaxN = 30; { максимальное количество столбцов }

type
  Matrix = array [1..MaxM,1..MaxN] of integer;

{ Вывод матрицы на экран. }
{ M - массив, rows - количество строк, cols - количество столбцов }
procedure ShowMatrix( M : Matrix; rows,cols : integer );
var i,j : integer;
begin
  for i:=1 to rows do begin
    for j:=1 to cols do
      write(M[i,j]:5); { Ширина столбца при выводе матрицы на экран - 5 символов }
    writeln;
  end;
end;

{ Поменять значениями два числовых элемента с помощью временной переменной }
procedure Swap( var A,B:integer );
var temp : integer;
begin
  temp := A;
  A := B;
  B := temp;
end;

var
  B, C : Matrix; { Матрицы }
  m, n : integer; { Размеры матриц B и C }

{ Ввод матрицы B }
procedure InputB;
var i, j : integer;
begin
  writeln('1. Ввод исходной матрицы B');
  write('Количество строк m: '); readln(m);
  write('Количество столбцов n: '); readln(n);
  for i:=1 to m do
    for j:=1 to n do begin
      write('B[',i,',',j,']: '); readln(B[i,j]);
    end;
  writeln('Исходная матрица B:');
  ShowMatrix(B,m,n);
end;

var
  i, j, s, line, sum : integer;
  Zeros : integer; { Количество нулей в строке }
  allSum : integer; { Сумма чисел в строке в матрице C }
  sums : array [1..MaxN] of integer; { Суммы по столбцам С }
begin
  writeln(' Преобразование прямоугольной матрицы ');
  writeln('======================================');
  writeln;
  InputB;

  writeln('2. Пробегаем по всем столбцам матрицы С считаем суммы их элементов');
  C := B; { Копируем матрицу B в C }
  for s:=1 to n do begin { цикл по всем столбцам B }
    sums[s] := 0; { Сумма элементов столбца s }
    for line:=1 to m do { Суммируем элементы столбца s }
      sums[s] := sums[s] + C[line,s];
    sums[s] := abs(sums[s]); { Нам нужен модуль суммы }
    writeln('Модуль суммы элементов ',s,'-ого столбца - ',sums[s]);
  end;
  writeln('Сортируем методом "пузырька" столбцы С по модулям суммы столбцов');
  for i:=1 to n do
    for j:=i+1 to n do
      if sums[i] > sums[j] then begin
        Swap(sums[i],sums[j]); { Меняем местами суммы }
        for line:=1 to m do { Меняем местами столбцы }
          Swap(C[line,i],C[line,j]);
      end;

  writeln('3. Выводим на экран матрицу С');
  ShowMatrix(C,m,n);

  writeln('Выбираем в матрице C строки с четными номерами.');
  writeln('Суммируем элементы и проверяем, есть ли в строке хотя бы один 0,');
  writeln('если есть, добавляем к общей сумме.');
  allSum := 0; { Общая сумма равна 0 }
  for line:=1 to m do { Пробегаем по всем строками матрицы C }
    if line mod 2 = 0 then begin { Если у строки чётный номер }
      sum := 0; { Сумма в строке равна 0 }
      Zeros := 0; { Количество нулей в строке }
      for s:=1 to n do begin
        sum := sum + C[line,s]; { Считаем сумму }
        if C[line,s] = 0 then { Считаем количество нулей в строке }
          Zeros := Zeros + 1;
      end;
      if Zeros >= 1 then { Если нулей >= 1, добавляем к общей сумме }
        allSum := allSum + sum;
      writeln(line,'-ая строка, сумма ',sum,' кол-во нулей - ',Zeros);
    end;
  writeln('Общая сумма элементов строк с четными номерами, содержащих хотя бы один нулевой элемент');
  writeln(allSum);

  writeln;
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
