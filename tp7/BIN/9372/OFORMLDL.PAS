Program Oformlenie;
uses crt, tpcrt, tpedit, tpwindow;
var c: char;
    x, y: byte;
begin
  textcolor (9);
  textbackground (0);
  clrscr;
  {------------------------------------------------------}
  Fastwrite ('Калькулятор длинных чисел v 1.0',2,6, $0F);
  Fastwrite ('Перовое число', 5,6, $0A);
  FastFill (70,' ', 6,6, $10);
  Fastwrite ('Второе число', 9,6, $0A);
  FastFill (70,' ', 10,6, $10);
  Fastwrite ('Действие', 13,6, $0A);
  FastFill (3,' ', 14,6, $10);
  Fastwrite ('Результат', 18,6, $0A);
  FastFill (70,' ', 19,6, $10);
  Fastwrite ('(с) А.С. Романов 9372', 24,55, $08);
  {------------------------------------------------------}
  Textbackground(1);
  textcolor(15);
  x:=6; y:=6;
  gotoxy(x,y);
  repeat
    c:= readkey;
    if c=#9 then {если нажат Tab прыгаем между полями}
      begin
        if y=6 then
          begin
            y:=10;
            x:=6;
          end
        else
          if y=10 then
            begin
              x:=7;
              y:=14;
            end
          else
            if y=14 then
              begin
                x:=6;
                y:=6;
              end;
        gotoxy (x,y);
      end;
    if c in ['0'..'9'] then
      begin
        if x <= 74 then
          begin
            x:=x+1;
            write (c);
          end
        else
          begin
            fastwrite(#17,y,x-71,$0F);
            gotoxy(x,y);
            write (c);
          end;
      end;
  until c = #27;


  textcolor (9);
  textbackground (0);
  clrscr;
end.