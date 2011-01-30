{ Проверка ответов - Одна строка (первая в файле) }

Uses _Testers;

{$I-}

Var S1,S2:String;
Begin
  Writeln('Проверка ответов - Одна строка (первая в файле)');
  OpenFiles('OneStr');
  Readln(F1,S1); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F2,S2); If IOResult<>0 then ExitProg(cdPrErr);
  If S1<>S2 then begin
    Writeln('S1 = '+S1+'  S2 = '+S2);
    ExitProg(cdWrAns);
  end;
  ExitProg(cdAllOK);
End.