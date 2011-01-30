Program LongArifm_realization;

uses Crt, tpcrt, DLARINT1;

const c=100; {Количество элементов в массиве}
      osn=10000; {Основание для хранения длинных чисел в массиве}

type Tlong = array [0..C] of longint;

var num1, num2 : Tlong; {Длинные числа}
    Rez, Ost: Tlong;   {Результат и остаток}
    k: integer; {счетчик}
    oper: char; {операция}

{------------------------------------------------------}
    x,y: byte; {координаты для оформления и реализации чтения}
{------------------------------------------------------}

procedure readcharlong (var num:Tlong; ch: char);
{Забивает char в длинное число}
  var i: longint;
  begin
    for i:= num[0] downto 1 do
      begin
        num[i+1]:= num[i+1] + (num[i]*10) div osn; {передвигаем старшую}
        num[i]:= (num[i]*10) mod osn;   {цифру в след число, освобождая}
      end;                            {нынешнее число для след цифры}
    num[1]:= num[1] + ord(ch) - ord ('0');
    if num[num[0]+1] > 0 then inc(num[0]);
  end;

procedure readchar (var x,y: byte);
  var ch: char;
  begin
    oper:='+';
    repeat
      ch:= readkey;
      TBO(x,y,ch,oper);
      if ch in ['0'..'9'] then  {Заполнение цифрами}
        begin
          if x <= 74 then
            begin
              x:=x+1;
              write (ch);
              if y=6 then
                begin
                  readcharlong(num1,ch);
                end
              else
                if y=14 then
                  readcharlong (num2,ch);
            end
          else
            begin
              fastwrite(#17,y,x-71,$0E);
              gotoxy(x,y);
              write (ch);
            end;
        end;
    until ch=#13;
  end;


procedure WriteLong (num:Tlong; var x,y: byte);
{Вывод длин чисел на экран}
  var zer, s: string;
      i: longint;
  begin
    gotoxy (x,y);
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

Procedure MultLongLInt (Num: Tlong; n: longint; var Rez: Tlong);
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
        if Rez[Num[0]+1] > 0 then
        {Проверяем/поправляем количество ячеек в произведении}
          Rez[0]:= Num[0]+1
        else
          Rez[0]:= Num[0]
      end;
  end;

Function MoreOrEqual(Num1, Num2: Tlong; sdvig: integer): byte;
{Сравнивает 2 длинных числа с учетом сдвига (сдвиг нужен для деления).
Возвращает 0, если первое больше второго; 1 - перове меньше врогоро
           2 - первое равно второму }
  var i: integer;
  begin
    if ( Num1[0] > (Num2[0] + sdvig) )
    {Если кол-во ячеек 1-го числа больше чем кол-во ячеек 2-го + сдвиг,
    то 1-е число больше 2-го}
      then
        MoreOrEqual:= 0
    else
      if ( Num1[0] < (Num2[0] + sdvig) )
      {Если меньше, то 1-е число меньше 2-го}
        then
          MoreOrEqual:= 1
      else
      {Если же количество ячеек 1-го совпадает с количеством ячеек 2-го}
        begin
          i:= Num1[0];
          while (i > sdvig) and (Num1[i] = Num2[i-sdvig]) do
          {сравниваем поочередно ячейки с учетом сдвига;
          если значения равны, переходим к следующей паре.
          Выход при условии, что ячейки закончились
          (то есть числа равны), или же найдены неравные значения}
            dec(i);
          if i= sdvig then
            begin
              MoreOrEqual:=0;
              {Числа совпали с учетом сдвига}
              for i:= 1 to sdvig do
                if Num1[i] > 0 then Exit;
              MoreOrEqual:=2;
              {Числа равны, "хвост" числа Num1 равен нулю}
            end
          else
            MoreOrEqual:= Byte( Num1[i] < Num2[i-sdvig] );
        end;
  end;


Procedure SubstrLong (var num1: Tlong; num2: Tlong; sd: integer);
{Вычитание длинных чисел c учетом сдвига sd. Результат в num1}
  var i, j: integer; {Переменные для цикла}
  begin
    for i:= 1 to num2[0] do {от 1 до кол. ячеек во втором числе}
      begin
        dec(Num1[i+sd],Num2[i]);
        {Вычитаем из уменьшаемой i-й ячейки Num1
        вычитаемую i-ю ячейку Num2}
        j:= i; {переменная для цикла по заимствованию}
        while (Num1[j+sd] < 0) and (j <= Num1[0]) do
        {если результат в j-й ячейке оказался меньше нуля и при
        этом j не больше количества ячеек в Num1, то...}
          begin
            inc(Num1[j+sd], osn);
            {Прибавляем к Num[j] основание (как обычно заимствуем при
            делении в столбик)}
            dec(Num1[j+sd+1]);
            {Уменьшаем старшую ячейку на единицу}
            inc(j);
          end;
      end;
    i:= Num1[0];
    while ( i>1 ) and ( Num1[i]=0 ) do
    {подправляем длину (количество ячеек) в разности}
      dec(i);
    Num1[0]:= i;
  end;


Function FindBin (Var Ost: Tlong; B : Tlong; sd: integer): Longint;
{Функция для поиска коэффицента, на который нужно домножать делитель
B - делитель; Ost - сначала делимое, в конце - остаток от деления}
  var Down, Up: word; {Верхняя и нижняя граница для поиска коэффициента}
      C: Tlong; {Результат для сравнения с делимым}
  begin
    down:=0;
    Up:= Osn; {Основание системы счисления}
    While (Up-1) > Down do
      begin
        MultLongLInt (B, ((Up+Down) div 2), C);
        Case MoreOrEqual (Ost, C, sd) of
          0: Down:= (Up+Down) div 2;
          {Если делимое Ost больше, чем С, тогда увеличиваем нижнюю границу}
          1: Up:= (Up+Down) div 2;
          {Если делимое Ost меньше, чем C, тогда уменьшаем верхнюю границу}
          2: begin
               Up:= (Up+Down) div 2;
               Down:= Up;
             end;
          {Если Ost = C, тогда числа делятся нацело и верхняя граница равна
           нижней и равна (Up+Down) div 2}
        end;
      end;
    MultLongLInt (B, (Up+Down) div 2, C);
    {Делитель умножаем на полученный коэффициент ( (Up+Down) div 2 ).
    Результат в С}
    {Находим остаток от деления}
    If MoreOrEqual (Ost, C, sd) = 0 then
    {Если делимое Ost больше С}
      SubstrLong (Ost, C, sd)
    else
      begin
        SubstrLong (C, Ost, sd);
        Ost:= C;
      end;
    FindBin:= (Up+Down) div 2;
    {Целая часть частного}
  end;

Procedure MakeDivLong (Num1, Num2: Tlong; Var Rez, Ost: Tlong);
{Деление двух длинных чисел при условии, что Num1 > Num2 и они не равны.
Условия проверяются в процедуре LongDivLong}
  var sd: integer;
  begin
    Ost:= Num1; {Первоначальное значение остатка}
    sd:= Num1[0] - Num2[0];
    if MoreOrEqual (Num1, Num2, sd) = 1 then
      Dec(sd);
    {Num2 * Osn > Num1, в результате 1 цифра}
    Rez[0]:= sd+1;
    while sd >= 0 do
      begin
        {находим очередную цифру результата}
        Rez[sd+1]:= FindBin (Ost, Num2, sd);
        dec (sd);
      end;
  end;

Procedure LongDivLong (Num1, Num2 : Tlong; Var Rez, Ost: Tlong);
{Различные ситуации при делении и вызов процедуры деления}
  var i: integer;
  begin
    for i:= 1 to c do  {Инициализация}
      Rez[i]:= 0;
    for i:= 1 to c do
      Ost[i]:=0;
    Case MoreOrEqual (Num1, Num2, 0) of
      0: MakeDivLong(Num1, Num2, Rez, Ost);
      {Выносим в процедуру само деление при условии,
      что Num1 > Num2 и они не равны}
      1: Ost:= Num1;
      {Если Num1 меньше Num2, то остатком от деления будет Num1}
      2: Rez[1]:=1;{Исправить длину R[0]?}
      {При условии, что числа равны, результат деления равен 1-це}
    end;
  end;


procedure MakeOper;
  begin
    x:= 6;    {В ответ}
    y:= 19;
    case oper of
      '+': begin
             SumLong(Num1,Num2,Rez);
             writelong(Rez,x,y);
           end;
      '-': begin
             SubstrLong(Num1,Num2,0);
             writelong(Num1,x,y);
           end;
      '*': begin

           end;
      '/': begin

           end;
    end;
  end;



BEGIN
  clrscr;
  for k:=0 to C do  {инициализация массива}
    num1[k]:=0;
  for k:=0 to C do  {инициализация массива}
    num2[k]:=0;
  oformlenie(x,y);
  readchar(x,y);
  makeoper;
  readln;
END.