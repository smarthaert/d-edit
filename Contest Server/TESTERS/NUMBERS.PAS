{ Проверка ответов - Hабор целых чисел типа LongInt }
{!!! В конце входных файлов должен стоять перевод каретки !!!}
{!!! Иначе будут появляться лишние WrongAnswer !!!}

Uses Testers;

{$I-}

Var N1,N2:LongInt;
Begin
  Writeln('Проверка ответов - Hабор целых чисел типа LongInt');
  OpenFiles('Numbers');
  Repeat
    N1:=ReadLongInt(F1);
    N2:=ReadLongInt(F2);
    If N1<>N2 then ExitProg(cdWrAns);
    Writeln(N1,' - ',N2);
  Until (EOF(F1) Or EOF(F2));
  If ((Not EOF(F1)) Or (Not EOF(F2))) then ExitProg(cdWrAns);
  ExitProg(cdAllOK);
End.