{  Программа: "Преобразование прямоугольной матрицы" }
const
  MaxM = 30; { максимальное количество строк }
  MaxN = 30; { максимальное количество столбцов }

type
  Matrix = array [1..MaxM,1..MaxN] of integer;

procedure ShowMatrix( M : Matrix; rows,cols : integer );
var i,j : integer;
begin
  for i:=1 to rows do begin
    for j:=1 to cols do
      write(M[i,j]:5); { Ширина столбца при выводе на экран - 5 символов }
    writeln;
  end;
end;

var
  B, C : Matrix;
  m, n, k, i, j, s : integer;
  contain : boolean; { Содержит ли столбец B равные элементы }
  V : array [1..MaxM] of integer; { Вектор целых чисел }
  sum : integer; { Сумма чисел в строке в матрице C }
begin
  writeln(' Преобразование прямоугольной матрицы ');
  writeln('======================================');
  writeln;
  writeln('1. Ввод исходной матрицы B');
  write('Количество строк m: '); readln(m);
  write('Количество столбцов n: '); readln(n);
  for i:=1 to m do
    for j:=1 to n do begin
      write('B[',i,',',j,']: '); readln(B[i,j]);
    end;
  ShowMatrix(B,m,n);
  writeln('2. Пробегаем в цикле по всем столбцам матрицы B и проверяем,');
  writeln(' содержит ли столбец равные элементы.');
  writeln('Если не содержит, добавляем этот столбец к матрице С.');
  k:=0; { Количество столбцов в матрице C равно 0 }
  for s:=1 to n do begin { цикл по всем столбцам B }
    contain := false;
    for i:=1 to m-1 do { Сравниваем попарно элементы столбца s }
      for j:=i+1 to m do
        if B[i,s] = B[j,s] then begin { Если два элемента столбца s совпали }
          contain := true;
          break;
        end;
    if not contain then begin { добавляем этот столбец к матрице С }
      k := k + 1;
      for i:=1 to m do
        C[i,k] := B[i,s];
    end;
  end;
  writeln('3. Выводим на экран матрицу С');
  ShowMatrix(C,m,k);
  writeln('4. Вводим в цикле вектор целых чисел V размера m=',m,'.');
  writeln('Важно только V[i] равно 0 или нет');
  for i:=1 to m do begin
    write('V[',i,']: '); readln(V[i]);
  end;
  writeln('5. Пробегаем в цикле по строкам матрицы С, если V[i]<>0,');
  writeln(' суммируем элементы в строке и выводим сумму на экран.');
  for i:=1 to m do { i - номер строки матрицы C }
    if V[i]<>0 then begin { Если V[i]<>0 => суммируем }
      sum := 0;
      for j:=1 to k do
        sum := sum + C[i,j];
      writeln('Сумма ',i,'-ой строки матрицы C = ',sum);
    end;
  writeln;
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
