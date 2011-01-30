unit DlarInt1;

interface

  procedure oformlenie (var x,y: byte);
  {- рисует интерфейс, возвр. координаты курсора}

  procedure TBO (var x,y: byte; ch: char; var oper: char);
  {- контоль перемещений курсора в меню, заполнения полей,
     стирания, операций}

implementation

uses crt, tpcrt;

  procedure oformlenie (var x,y: byte);
  var ch: char;
  begin
    textcolor (15);
    textbackground (0);
    clrscr;

    Fastwrite ('Hex Calculator',2,24, $0F);

    Fastwrite ('Pervoe chislo', 5,6, $0A);
    FastFill (70,' ', 6,6, $10);
    FastWrite ('0',6,6,$1E);

    Fastwrite ('Deistvie', 9,6, $0A);
    FastFill (3,' ', 10,6, $10);
    FastWrite ('+',10,7,$1E);

    Fastwrite ('Vtoroe chislo', 13,6, $0A);
    FastFill (70,' ', 14,6, $10);
    FastWrite ('0',14,6,$1E);

    FastFill (70,'-', 16,6, $0B);

    Fastwrite ('Result', 18,6, $0A);
    FastFill (70,' ', 19,6, $10);
    FastWrite ('0',19,6,$1E);

    Fastwrite ('Made by Leontev Alexey 9373', 24,55, $08);

    Textbackground(1);
    textcolor(14);
    x:=6;
    y:=6;
    gotoxy(x,y);
  end;

  procedure TBO (var x,y: byte; ch: char; var oper: char);
  {Tab, Backspace, Operation}
  begin
    if ch=#9 then {если нажат Tab прыгаем между полями}
      begin
        case y of
          6: begin   {1 num}
               y:=14;
               x:=6;
             end;
          14: begin  {2 num}
                x:=6;
                y:=6;
              end;
        end;
        gotoxy (x,y);
      end;



    if ( ( ch=#8 ) and (x > 6) ) then       {Backspace}
      begin
        x:=x-1;
        gotoxy(x,y);
        write(' ');
        gotoxy(x,y);
      end;

    case ch of             {Операция}
      '+': begin
             FastWrite ('+',10,7,$1E);
             oper:='+';
           end;
      '-': begin
             FastWrite ('-',10,7,$1E);
             oper:='-';
           end;
      '*': begin
             FastWrite ('*',10,7,$1E);
             oper:='*';
           end;
      '/': begin
             FastWrite ('/',10,7,$1E);
             oper:='/';
           end;
    end;
  end;

begin
end.