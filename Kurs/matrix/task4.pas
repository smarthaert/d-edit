{  Программа: "Преобразование множества прямых линий" }
const
  MaxN = 30; { максимальное количество прямых }

type
  Line = record { Прямая линия }
    A,B,C : real; { Коэффициенты уравнения }
  end;

{ Аварийное завершение программы }
procedure Fail( Reason : string );
begin
  writeln('Fail: ',Reason);
  halt(1);
end;

{ Параллельны ли прямые X и Y? }
function isParallel( X,Y : Line ):boolean;
begin
  isParallel := X.A * Y.B = X.B * Y.A;
end;

{ Расстояние между двумя параллельными прямыми }
function Distance( X,Y : Line ):real;
var k : real;
begin
  { Условие при входе в подпрограмму }
  if not isParallel(X,Y) then
    Fail('Прямые X и Y не параллельны!');
  { Вычисляем отношение коэффициентов прямых }
  if Y.A <> 0 then
    k := X.A / Y.A
  else
    k := X.B / Y.B;
  { Используем формулу вычисления расстояния }
  Distance := abs(X.C - Y.C*k) / sqrt(X.A*X.A + X.B*X.B);
end;

var
  N : integer; { Количество прямых }
  L : array [1..MaxN] of Line; { Массив прямых }
  i, j : integer;
  done : boolean;
  R : real; { Заданное расстояние между прямыми }
begin
  writeln(' Преобразование множества прямых линий ');
  writeln('=======================================');
  writeln(' Линии заданы уравнениями вида: Ax+By+C=0');
  writeln;
  writeln('1. Ввод множества M исходных прямых');
  write('Количество прямых N: '); readln(N);
  for i:=1 to N do begin
    repeat
      writeln('Ввод прямой ',i,' из ',N);
      write('A = '); readln(L[i].A);
      write('B = '); readln(L[i].B);
      write('C = '); readln(L[i].C);
      done := ( L[i].A<>0 ) or ( L[i].B<>0 );
      if not done then
        writeln('A и B не могут быть одновременно равны 0!!');
    until done;
  end;
  writeln('2. Выбираем все пары параллельных прямых');
  for i:=1 to N-1 do
    for j:=i+1 to N do
      if isParallel(L[i],L[j]) then
        writeln(' ',i,' и ',j,' параллельны! Расстояние = ',
           Distance(L[i],L[j]):0:2);
  writeln;
  writeln('3. Выводим только прямые, расстояние между которыми меньше заданного.');
  write('Заданное расстояние: '); readln(R);
  for i:=1 to N-1 do
    for j:=i+1 to N do
      if isParallel(L[i],L[j]) then
        if Distance(L[i],L[j]) < R then
          writeln(' Прямая ',i,' входит в P. Расстояние до ',j,' = ',
           Distance(L[i],L[j]):0:2);
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
