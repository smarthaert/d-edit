Program LongArifm_realization;

uses Crt;

const c=1000; {Количество элементов в массиве}
      osn=10000; {Основание для хранения длинных чисел в массиве}

type Tlong = array [0..C] of longint;

var num1, num2 : Tlong; {Длинные числа}
    Rez: Tlong;   {Результат}

procedure readlong (var num:Tlong);
{Чтение длинных чисел}
  var i: longint;
      ch: char;
  begin
    for i:=0 to C do  {инициализация массива}
      num[i]:=0;
    read (ch);
    while ch in ['0'..'9'] do
      begin
        for i:= num[0] downto 1 do
          begin
            num[i+1]:= num[i+1] + (num[i]*10) div osn; {передвигаем старшую}
            num[i]:= (num[i]*10) mod osn;   {цифру в след число, освобождая}
          end;                            {нынешнее число для след цифры}
        num[1]:= num[1] + ord(ch) - ord ('0');
        if num[num[0]+1] > 0 then inc(num[0]);
        read (ch);
      end;
    writeln;
  end;

procedure WriteLong (num:Tlong);
{Вывод длин чисел на экран}
  var zer, s: string;
      i: longint;
  begin
    write (num[num[0]]);  {вывод старшего числа}
    str (osn div 10, zer);
    for i:= num[0]-1 downto 1 do
      begin
        str (num[i], s);
        while length (s) < length (zer) do  {дополнение незнач нулями}
          s:='0'+s;
        write (s);   {вывод остальных чисел}
      end;
    writeln;
  end;

Procedure SumLong (num1, num2: Tlong; var Rez: Tlong);
{Суммирование 2-х длинных чисел}
  var i, k: integer;
  begin
    for i:=0 to C do  {инициализация}
    Rez[i]:=0;
    if num1[0] > num2[0] then {выясняем максимальное кол-во чисел}
      k:= num1[0]
    else
      k:= num2[0];
    for i:= 1 to k do  {реализуем суммирование}
      begin
        Rez[i+1]:= (Rez[i] + num1[i] + num2[i]) div osn;
        {переносим старшую цифру из суммы (если она по
        разрядности больше основания) в следующее число}
        Rez[i]:= (Rez[i] + num1[i] + num2[i]) mod osn; {остальное оставляем}
      end;
    If Rez[k+1]=0 then
      Rez[0]:= k
    else
      Rez[0]:=k+1;
  end;

Procedure MultLong (Num: Tlong; n: longint; var Rez: Tlong);
{Умножение длиного числа на число типа longint
 Num - длин. число; n - число, на которое умножаем (longint); Rez - результат}
  var i: word; {i - cчетчик для цикла}
  begin
    for i:= 1 to c do  {Инициализация}
      Rez[i]:= 0;
    if n <> 0 then {Проверка на то, является ли множитель нулем}
      begin
        for i:= 1 to Num[0] do {от 1 до количества ячеек}
          begin
            Rez[i+1]:= (Num[i] * n + Rez[i]) div osn;
            {Если произведение значения в ячейке на множитель больше
            основания, то выносим старшую цифру в следующую ячейку}
            Rez[i]:= (Num[i] * n + Rez[i]) mod osn;
            {В i-й ячейке оставляем значение произведения (без
            старшей цифры, если оно было больше основания)}
          end;
        if Rez[Num[0]+1] > 0 then {Проверяем количество ячеек в произведении}
          Rez[0]:= Num[0]+1
        else
          Rez[0]:= Num[0]
      end;
  end;

Function MoreOrEqual(Num1, Num2: Tlong): boolean;
{Сравнивает 2 длинных числа.
Возвращает true, если первое больше второго или они равны}
  var i: integer;
  begin
    if ( Num1[0] > Num2[0] )
    {Если кол-во ячеек 1-го числа больше чем кол-во ячеек 2-го,
    то 1-е число больше 2-го}
      then MoreOrEqual:= true
    else
      if ( Num1[0] < Num2[0] ) {Если меньше, то 1-е число меньше 2-го}
        then MoreOrEqual:= false
      else
      {Если же количество ячеек 1-го совпадает с количеством ячеек 2-го}
        begin
          i:= Num1[0];
          while (i>0) and (Num1[i]=Num2[i]) do
          {сравниваем поочередно ячейки если значения равны, переходим
          к следующей паре. Выход при условии, что ячейки закончились
          (то есть числа равны), или же найдены неравные значения}
            dec(i);
          if i=0 then
            MoreOrEqual:= true {они равны}
          else
            if Num1[i] > Num2[i] then
            {Если начение в i-й ячейке 1-го числа больше значения в
            i-й ячейке второго, то 1-е число больше}
              MoreOrEqual:= true
            else
              MoreOrEqual:= false; {иначе 1-е меньше}
        end;
  end;


Procedure SubstrLong (var num1: Tlong; num2: Tlong);
{Вычитание длинных чисел. Результат в num1}
  var i, j: integer; {Переменные для цикла}
  begin
    if MoreOrEqual (num1, num2) then
      begin
        for i:= 1 to num2[0] do {от 1 до кол. ячеек во втором числе}
          begin
            dec(Num1[i],Num2[i]);
            {Вычитаем из уменьшаемой i-й ячейки Num1
            вычитаемую i-ю ячейку Num2}
            j:= i; {переменная для цикла по заимствованию}
            while (Num1[j] < 0) and (j <= Num1[0]) do
            {если результат в j-й ячейке оказался меньше нуля и при
            этом j не больше количества ячеек в Num1, то...}
              begin
                inc(Num1[j], osn);
                {Прибавляем к Num[j] основание (как обычно заимствуем при
                делении в столбик)}
                dec(Num1[j+1]);
                {Уменьшаем старшую ячейку на единицу}
                inc(j);
              end;
          end;
        i:= Num1[0];
        while ( i>1 ) and ( Num1[i]=0 ) do
        {подправляем длину (количество ячеек) в разности}
          dec(i);
        Num1[0]:= i;
      end
    else
      writeln ('Первое число меньше второго!');
  end;

Procedure DivLong;
  begin
  end;

BEGIN
  clrscr;
  readlong (num1);
  num2:= num1;
  {SumLong (num1,num2,Rez);
  writelong ('Рез суммы ',Rez);}
  MultLong (num1,3,Rez);
  writelong (Rez);
  num1:=rez;
  substrlong (Num2,Num1);
  writelong (num2);
  readln;
END.