Program Kurs1; {2_8. Программа, определяющая во сколько раз
наибольшее из 3-х чисел больше наименьшего}
uses crt;

var a, b, c, rez: real;
    ok: boolean;

Begin
clrscr;
ok:= false;
   {Считываем числа}
repeat
  writeln ('Введите 3 числа, отличающиеся друг от друга и не равных нулю');
  readln (a,b,c);
  if ( a<>b ) and ( b<>c ) and ( a<>c ) and ( a<>0 ) and ( b<>0 ) and ( c<>0 ) then ok:= true
  else
    Begin
    clrscr;
    writeln ('Вы ввели некорректные числа, повторите ввод');
  end;
until ok;
   {***}
   {Основная программа. Сравним числа}
If ( a>b ) and ( a>c ) then  {a ниабольшее}
  if ( b<c ) then rez:= a/b    {если b наим из оставшихся}
  else rez:= a/c;              {если с наим}
If ( b>a ) and ( b>c ) then  {b наибольшее}
  if ( a<c ) then rez:= b/a
  else rez:= b/c;
if ( c>a ) and ( c>b ) then  {c наибольшее}
  if ( a<b ) then rez:= c/a
  else rez:= c/b;
writeln ('Наибольшее число больше наименьшего в ', rez:2:1, ' раз(a)');
readln;
clrscr;
end.