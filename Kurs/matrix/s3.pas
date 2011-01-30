{ Программа "Принадлежность заданной области" }
const
  MaxK = 10; { Максимальное количество значений K }
  MaxM = 20; { Максимальное количество точек }

type
  Point = record { Точка }
    X,Y : real; { Координаты точки на плоскости }
  end;

{ Ввод числа в заданном диапазоне }
{ Prompt - приглашение к вводу }
{ Число должно быть в пределах min..max }
function InputNum( Prompt:string; min,max : integer ):integer;
var Answer : integer; { ответ пользователя }
begin
  Repeat
    Write(Prompt); readln(Answer);
  Until (Answer >= min) and (Answer <= max);
  InputNum := Answer;
end;

{ Проверка, что точка попадает в область D }
{  P - точка для проверки }
{  K - текущее значение коэффициента K }
function in_D( P:Point; K:real ):boolean;
begin
  if P.X <= 1 then begin
    in_D := false; exit;
  end;
  in_D := (P.Y >= K * exp(P.X)) and
          (P.Y >= sqrt(1.15*P.X)) and
          (P.Y <= P.X*P.X - P.X + 1);
end;

var
  N : integer; { Количество точек }
  P : array [1..MaxM] of Point; { Массив точек }
  i, j : integer;
  flag : boolean;
  K_begin : real; { Начальное значение коэффициента K }
  K_end : real; { Конечное значение коэффициента K }
  delta_K : real; { Шаг изменения коэффициента K }
  K : array [1..MaxK] of Real; { Значения коэффициента K }
  KN : integer; { Количество коэффициентов K }
  Menu : integer; { Способ задания коэффициента K }
begin
  writeln(' Принадлежность заданной области ');
  writeln('=======================================');
  writeln(' Заданы уравнения 3-х кривых на плоскости.');
  writeln('Одно из уравнений содержит переменный коэффициент K.');
  writeln('Кривые пересекаясь ограничивают замкнутую область D,');
  writeln('размеры которой зависят от значения коэф-та K.');
  writeln('Выберите способ задания коэффициента K');
  writeln('  1) Задано начальное значение К_нач, конечное значение К_кон и шаг изменения К.');
  writeln('  2) Заданы К_нач, К_кон и набор из KN<=10 произвольных значений коэффициента К_нач <= К <= К_кон.');
  Menu := InputNum('Выберите 1 или 2: ',1,2);
  repeat
    Write('Введите K_нач: '); readln(K_begin);
    Write('Введите K_кон: '); readln(K_end);
    if K_end <= K_begin then
      Writeln('K_кон должно быть больше K_нач!');
  Until K_end > K_begin;
  { Заполняем массив K в зависимости от выбранного способа }
  Case Menu of
    1: begin
      repeat
        write('Введите шаг изменения K>0: '); readln(delta_K);
      until delta_K > 0;
      { Вычисляем значения K }
      K[1] := K_begin; { В качестве первого значения берём K_нач }
      KN := MaxK;
      for i:=2 to MaxK do begin
        K[i] := K[i-1] + delta_K; { Двигаемся по шагу }
        if K[i] >= K_end then begin { пока не дойдём до K_кон }
          KN := I; { Если дошли => прерываемся }
          break;
        end;
      end;
    end;
   2: begin;
      KN := InputNum('Введите количество KN: ',1,MaxK);
      for i:=1 to KN do begin
        repeat
          write('Введите K',i,' в пределах [',K_begin:0:2,'..',K_end,']: '); readln(K[i]);
        until (K[i] >= K_begin) and (K[i] <= K_end);
      end;
    end;
  end;
  writeln;
  writeln('Ввод множества M точек');
  write('Количество точек N: '); readln(N);
  for i:=1 to N do begin
    writeln('Ввод точки ',i,' из ',N);
    write('X = '); readln(P[i].X);
    write('Y = '); readln(P[i].Y);
    { Пробегаем по всем значениям коэффициента K }
    flag := false;
    for j:=1 to KN do
      if in_D(P[i],K[j]) then begin
        writeln('Точка попадает в область D при K=',K[j]:0:2);
        flag := true;
      end;
    if not flag then
      writeln('Точка не попадает в область D при при каких значениях K!');
  end;
  writeln;
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
