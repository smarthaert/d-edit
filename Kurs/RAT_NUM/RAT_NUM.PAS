Uses RN_Unit,CRT;

{ ---=== Основная Программа ---===}
Var R : TRational; S : String;
Begin
  Write('Введите выражение: '); Readln(S);
  Calc(S,R); Writeln(Show_Rational(R));
  ReadKey;
End.
