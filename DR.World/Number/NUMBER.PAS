{ ╔═╤════════════════════════════════════════╤═╗ }
{ ║ │  Пример программы на Turbo-Pascal 7.0  │ ║ }
{ ╚═╧════════════════════════════════════════╧═╝ }
Uses CRT;

Var Limit,Option,U,D,N:Integer; Ans:Char;
Begin
  Randomize;
  Limit:=1000; { Предел для чисел }
  Repeat
   { Выбор варианта игры  }
    ClrScr;
    TextColor(11);
    Writeln(' ╔═╤═╤════════════════════════════════════════╤═╤═╗');
    Writeln(' ║ │ │  И Г Р А  Б О Л Ь Ш Е  -  М Е Н Ь Ш Е  │ │ ║');
    Writeln(' ╚═╧═╧════════════════════════════════════════╧═╧═╝');
    Writeln(' ------======ЁЁЁЁЁЁ Lion  Studio ЁЁЁЁЁЁ======------');
    Writeln;
    TextColor(10);
    Writeln(' В этой игре числа используются от 0 до ',Limit);
    Writeln;
    TextColor(7);
    Writeln(' Выберите вариант игры нажав цифровую клавишу :');
    Writeln('  1  Загадываете вы - Отгадывает компьютер');
    Writeln('  2  Загадывает компьютер - Отгадываете вы');
    Writeln('  0  Выход в Операционную систему');
    Writeln;
    Write('  Введите номер нужной опции : ');
    Readln(Option);
    Writeln;
   { Собственно игра }
    Case Option of
      1: { === 1 === }
        Begin
          Writeln('Загадываете вы - Отгадывает компьютер');
          D:=0;
          U:=Limit;
          Repeat
            N:=(U+D) div 2;
            Writeln(' Ваше число больше ',N,'  1 - да  0 - нет  : ',D,'-',U);
            Ans:=ReadKey;
            If Ans='1' then D:=(N+1) Else U:=N;
            If U=D then
              Begin
                Writeln(' Ваше число ',U);
                D:=Limit; { Break }
                Break;
              End;
          Until D>U;
          ReadKey;
        End;
      2: { === 2 === }
        Begin
          U:=Random(Limit);
          Writeln('Загадывает компьютер - Отгадываете вы');
          Repeat
            Write(' Введите число ');
            Readln(D);
            if U>D then Writeln('Мое число больше !');
            if U<D then Writeln('Мое число меньше !');
          Until U=D;
          Writeln(' Вы Угадали !!! ');
          Readln;
        End;
    End;
  Until Option=0;
End.
