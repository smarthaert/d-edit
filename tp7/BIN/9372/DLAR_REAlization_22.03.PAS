Program LongArifm_realization;

uses Crt;

const c=1000;
      osn=10000;

type Tlong = array [0..C] of longint;

var num1, num2 : Tlong;
    Rez: Tlong;

procedure readlong (var num:Tlong); {Обеспечивает чтение длин чисел}
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

procedure WriteLong (num:Tlong); {Вывод длин чисел на экран}
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
        Rez[i+1]:= (Rez[i] + num1[i] + num2[i]) div osn; {переносим старшую
                                      цифру из суммы (если она по разрядности
                                      больше основания) в следующее число}
        Rez[i]:= (Rez[i] + num1[i] + num2[i]) mod osn; {остальное оставляем}
      end;
    If Rez[k+1]=0 then
      Rez[0]:= k
    else
      Rez[0]:=k+1;
  end;

Procedure SubstrLong (num1, num2: Tlong; var Rez: Tlong);
  begin

  end;

BEGIN
  clrscr;
  readlong (num1);
  num2:= num1;
  SumLong (num1,num2,Rez);
  writelong (Rez);
  readln;
END.