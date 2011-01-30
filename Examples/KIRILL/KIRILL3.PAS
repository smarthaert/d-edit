var
  a : array [1..20] of integer; { Массив }
  N : integer; { Количество элементов в массиве }
  i,j : integer;
  res : integer; { Результат умножения }
  found : boolean; { Есть ли четный элемент в массиве? }
begin
  Writeln('В одномерном числовом массиве элементы, расположенные после первого четного элемента перемножить');
  Write('Введите количество элементов массива (целое число от 1 до ',High(a),'): '); Readln(N);
  for i := 1 to N do begin
    Write('Введите a[',i,'] = ');
    Readln(a[i]);
  end;
  found := false;
  for i := 1 to N do
    if not odd(a[i]) then begin { odd(x) - true - если x нечётное, и false если x - четное }
      Writeln('Первый четный элемент: a[',i,'] = ',a[i]);
      Writeln('Перемножаем:');
      res := a[i]; Write(a[i]);
      for j := i+1 to N do begin
        res := res * a[j]; Write('*',a[j]);
      end;
      Writeln(' = ',res);
      found := true;
      break; { Прерываем цикл (т.к. нам нужен только первый четный элемент) }
    end;
  if not found then
    Writeln('В массиве нет четных элементов!');
  Writeln('Нажмите Enter для продолжения'); Readln;
end.
