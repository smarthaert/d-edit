Program Kurs1; {2_8. Программа, определяющая во сколько раз
наибольшее из 3-х чисел больше наименьшего}
uses crt;

var a, b, c, rez: real;
    ok: boolean;

procedure SafeRead (var i: real; sch: byte);
    Var p: integer;
        ok: boolean;
    Begin
    ok:=false;
    {$I-}
    repeat
      writeln ('Введите ', sch, ' число и нажмите <Enter>');
      readln (i);
      P:= IOresult;
      if P<>0 then
          writeln ('Ошибка: неверный формат числа. Повторите ввод числа')
        else  {(при Р=0) когда число введено верно, проверим его на
               совпадение с нулем или с одним из ранее введенных чисел}
           begin
             case sch of
               1: ok:= (i<>0);
               2: ok:= (i<>a) and (i<>0);
               3: ok:= (i<>a) and (i<>b) and (i<>0)
             end;
           if (ok=false) then
             begin
               writeln ('Ошибка: введенное число либо равно нулю, либо равно одному');
               writeln ('из предыдущих (если таковое вводилось). Повторите ввод числа');
             end;
           end;
    until ok;
      {$I+}
    end;

Begin
repeat  {зацикливаем до запроса на выход}
  clrscr;
     {Считываем числа и проверим, удовлетворяют ли они условию}
  writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
  SafeRead (a, 1);
  SafeRead (b, 2);
  SafeRead (c, 3);
    {***}
     {Основная программа. Сравним числа}
  If ( a>b ) and ( a>c ) then  {a ниабольшее}
    if ( b<c ) then
      rez:= a/b    {если b наим из оставшихся}
    else
      rez:= a/c
  else                  {если с наим}
    If ( b>a ) and ( b>c ) then  {b наибольшее}
      if ( a<c ) then
        rez:= b/a
      else
       rez:= b/c
    else
      if ( c>a ) and ( c>b ) then  {c наибольшее}
        if ( a<b ) then
          rez:= c/a
        else
          rez:= c/b;
  writeln ('Наибольшее число больше наименьшего в ', rez:2:1, ' раз(a)');
  writeln('Закончить программу? (Y/N)');
until readkey in ['y','Y','д','1','н'];
clrscr;
end.