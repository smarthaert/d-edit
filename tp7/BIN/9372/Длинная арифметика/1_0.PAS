Program Dlinnaya_Arifmetika;

uses crt, sr;

const MaxDig = 1000; {максимальное количество 4-х значных цифр (lg(osnov))}
      Osnov = 10000; {Основание системы счисления}

type TLong = array [0..MaxDig] of word; {В эл-х массива храним 4-х значные
                                            числа}

{const}

var operation: byte;
    num1, num2: TLong;

procedure ReadLong (hint: string; var a: TLong);
  var c: char;
      i: integer;
  begin
    i:=1;
    writeln (hint);
    read (c);
    while c in ['0'..'9'] do
      begin
        a[i]:= a[i]*10 + ord(c) - ord('0');
        read(c);
      end;
  end;

BEGIN
  repeat  {зацикливаем до запроса на выход}
    ReadLong ('Введите первое число', num1);
    ReadLong ('Введите второе число', num2);
    SRByte (operation,'Введите номер арифметической операции: 1) + 2) - 3) * 4) /',0,5);
    {case operation of
      1: SumNms;
      2: SubNms;
      3: MulNms;
      4: DivNms;
    end;}
  writeln ('Закончить работу? (Y/N)');
  until readkey in ['y','Y','д','1','н'];
END.