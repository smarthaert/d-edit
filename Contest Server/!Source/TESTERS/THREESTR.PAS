{ Проверка ответов - Три строки (в начале файла) }

Uses Testers;

{$I-}

Var S11,S12,S13,S21,S22,S23:String;
Begin
  Writeln('Проверка ответов - Одна строка (первая в файле)');
  OpenFiles('ThreeStr');
  Readln(F1,S11); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F1,S12); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F1,S13); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F2,S21); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F2,S22); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F2,S23); If IOResult<>0 then ExitProg(cdPrErr);
  If S11<>S21 then ExitProg(cdWrAns);
  If S12<>S22 then ExitProg(cdWrAns);
  If S13<>S23 then ExitProg(cdWrAns);
  ExitProg(cdAllOK);
End.