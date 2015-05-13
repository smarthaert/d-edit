
```
var
  N, { Очередное число } 
  Max : integer; { Текущий максимум }
  C : char;
begin
  Max := low(integer); { Наименьшее число, которое можно записать в тип integer }
  Repeat
    Repeat
      Write('N = '); ReadLn(N);
      if (N<0) or (N>255) then
        Writeln('Число должно быть в диапазоне 0..255!');
    Until (N>=0) and (N<=255);
    { Если очередное введенное число N больше текущего максимума Max => обновить максимум }
    if N > Max then
      Max := N;
    Write('Ввести ещё число (y/n)?'); ReadLn(C);
  Until (C = 'n') or (C = 'N');
  WriteLn('Maximum = ',Max);
  Write('Нажмите Enter для завершения программы... '); ReadLn;
end.
```