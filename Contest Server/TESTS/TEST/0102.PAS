var n, dec : longint;  {в переменной dec хранится k-тая степень десятки}
    A, k, p, i: integer;   {p - количество k-значных чисел}
begin
  readln(n);
  k:=1;
  dec:=10;
  p:=10;

  while p >= n do
    begin
      n:=n-p;                {уменьшаем ряд}
      inc(k);                  {k - число цифр в числах в начале ряда}
      dec:=dec*10;
      p:=dec - dec div 10;
    end;

  A := n div k + dec div 10;

  dec := 1;
  for i:= 1 to k - n mod k do dec:=dec*10;
{вычисляем 10k - n mod k}
  writeln((A mod dec) div (dec*10));
end.
