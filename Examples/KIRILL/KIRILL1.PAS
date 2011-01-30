function f( a,b : integer ):integer;
begin
  f := a * b; { << здесь задается функция }
end;

var
  a : -4..4; { "a" в пределах от -4 до 4 }
  b : -5..3; { "b" в пределеах от -5 до 3 }
  y : integer; { Значение "y" }
  y_all : integer; { Количество всех "y" }
  y_pos_sum : integer; { Сумма положительных "y" }
begin
  Writeln('Задача. y=f(a,b). f(a,b)=a*b');
  Writeln('Найти отношение количества всех "y" к сумме положительных "y"');
  Writeln('Вариант 1. С использованием цикла For');
  y_all := 0; y_pos_sum := 0;
  for a := low(a) to high(a) do { low(a) - нижний предел "a", high(a) - верхний предел "a" }
    for b := low(b) to high(b) do begin { low(b) - нижний предел "b", high(b) - верхний предел "b" }
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
    end;
  Writeln('Отношение (точность - 5 знаков после десятичной точки): ',y_all/y_pos_sum:0:5);
  Writeln('Вариант 2. С использованием цикла While');
  y_all := 0; y_pos_sum := 0;
  a := low(a);
  while a <= high(a) do begin { low(a) - нижний предел "a", high(a) - верхний предел "a" }
    b := low(b);
    while b <= high(b) do begin { low(b) - нижний предел "b", high(b) - верхний предел "b" }
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
      b := b + 1;
    end;
    a := a + 1;
  end;
  Writeln('Отношение (точность - 5 знаков после десятичной точки): ',y_all/y_pos_sum:0:5);
  Writeln('Вариант 3. С использованием цикла Repeat..Until');
  y_all := 0; y_pos_sum := 0;
  a := low(a);
  repeat
    b := low(b);
    repeat
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
      b := b + 1;
    until b > high(b);
    a := a + 1;
  until a > high(a);
  Writeln('Отношение (точность - 5 знаков после десятичной точки): ',y_all/y_pos_sum:0:5);
  Writeln('Нажмите Enter для продолжения'); Readln;
end.
