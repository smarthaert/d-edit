(*    {$I-}
    repeat
      readln (a);
      P:= IOresult;
      if P<>0 then
        begin
          clrscr;
          writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
          writeln ('Некорректные данные, повторите ввод ПЕРВОГО числа');
        end;
    until P=0;
    {$I-}
    repeat
      readln (a);
      P:= IOresult;
      if P<>0 then
        begin
          clrscr;
          writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
          writeln ('Некорректные данные, повторите ввод ПЕРВОГО числа');
        end;
    until P=0;

    {+++ Безопасный ввод}
    {$I-}
    repeat
      readln (a);
      P:= IOresult;
      if P<>0 then
        begin
          clrscr;
          writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
          writeln ('Некорректные данные, повторите ввод ПЕРВОГО числа');
        end;
    until P=0;
    repeat
      readln (b);
      P:= IOresult;
      if P<>0 then
        begin
          clrscr;
          writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
          writeln ('a = ', a);
          writeln ('Некорректные данные, повторите ввод ВТОРОГО числа');
        end;
    until P=0;
    repeat
      readln (c);
      P:= IOresult;
      if P<>0 then
        begin
          writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
          writeln ('Некорректные данные, повторите ввод ТРЕТЬЕГО числа');
          writeln ('a = ', a);
          writeln ('b = ', b);
        end;
    until P=0;
    {$I+}
    {--- Безопасный ввод}  *)

     { else
        Begin
        clrscr;
        writeln ('Вы ввели некорректные числа, повторите ввод')
      end;
  until ok;}
 