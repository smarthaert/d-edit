{ �஢�ઠ �⢥⮢ - ���� ��ப� (��ࢠ� � 䠩��) }

Uses Testers;

{$I-}

Var S1,S2:String;
Begin
  Writeln('�஢�ઠ �⢥⮢ - ���� ��ப� (��ࢠ� � 䠩��)');
  OpenFiles('OneStr');
  Readln(F1,S1); If IOResult<>0 then ExitProg(cdPrErr);
  Readln(F2,S2); If IOResult<>0 then ExitProg(cdPrErr);
  If S1<>S2 then ExitProg(cdWrAns);
  ExitProg(cdAllOK);
End.