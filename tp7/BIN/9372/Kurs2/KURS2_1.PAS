Program Kurs2;
{ 19_1 Программа делает следующее:
       а) Формирует массив случайных чисел в заданном диапазоне
       б) Формирует другой массив, вклюив в него элементы,
          которые не нарушают упорядоченность исходного
          массива по возрастанию

       Для сформированного массива (из пункта "б"):
         1) Определяет число элементов, отличающихся от среднего
            арифметического не более , чем в 1,005 раза
         2) Находит элемент наиболее близкий к нулю
         3) Уплотняет массив, вычеркнув все отрицательные числа }

uses crt;

Const n= 30;  {Количество элементов}
      diap= 1000; {Диапазон значений ( от -(diap/2) до diap/2 )}

var a: array [1..n] of integer;  {см. пункт "а" в описании}
    b: array [1..n] of integer;  {см. "б"}
    i,k, bliz_arifm: integer;
    sr_arifm: real;

Begin
repeat  {зацикливаем до запроса на выход}
  clrscr;
  Randomize;

  {+++ а}
    writeln ('Начальный массив');
    For i:= 1 to n do
      begin
        a[i]:=(random(diap)-(diap div 2));
        write (a[i]:5);
      end;
    writeln (' ');
  {---}

  {+++ б}
    writeln ('**********');
    writeln ('Выборка по возрастанию');
    b[1]:=a[1];
    k:=1;
    For i:=1 to n do
      begin
        if a[i]>b[k] then
          begin
          b[k+1]:=a[i];
          k:=k+1;
          end;
      end;
    For i:=1 to k do writeln (b[i]);
  {---}

  {+++ 1}
    writeln ('**********');
    sr_arifm:=0;
    for i:=1 to k do sr_arifm:= sr_arifm + b[i];
    sr_arifm:= sr_arifm/k;
    writeln ('Количество элементов, отличающихся от среднего');
    writeln ('арифметического (',(sr_arifm):2:2,') не более, чем в 1.005 раз равно');
    bliz_arifm:=0;
    for i:= 1 to k do
      begin
      if abs((b[i]/sr_arifm)) < (1.005) then bliz_arifm:=bliz_arifm+1;
      writeln (b[i]/sr_arifm);
      end;
    writeln(bliz_arifm);

until readkey in ['y','Y','д','1','н'];
End.