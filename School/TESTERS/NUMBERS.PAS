{ �஢�ઠ �⢥⮢ - H���� 楫�� �ᥫ ⨯� LongInt }
{!!! � ���� �室��� 䠩��� ������ ����� ��ॢ�� ���⪨ !!!}
{!!! ���� ���� ������� ��譨� WrongAnswer !!!}

Uses _Testers;

{$I-}

Var N1,N2:LongInt;
Begin
  Writeln('�஢�ઠ �⢥⮢ - H���� 楫�� �ᥫ ⨯� LongInt');
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