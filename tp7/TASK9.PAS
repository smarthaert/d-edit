Uses CRT,_Calc;

{$I-}

Const MaxReal = 1.7E38;

Procedure InputError;
  Begin
    TextColor(15);
    Writeln(#13#10'        ---=== T A S K 9 ===---'#13#10);
    Writeln(#13#10'Нахождение корня методом половинного деления'#13#10);
    Writeln('Не могу найти файл INPUT.TXT !'+#13#10);
    TextColor(11);
    Writeln('  Файл INPUT.TXT содержит :        Пример:');
    Writeln(' ===========================      =========');
    Writeln('    Текст функции                   Sqr(X)');
    Writeln('    Начало, конец промежутка        0 2');
    Writeln('    Приближение значения функции    0.1');
    Writeln('    Минимальный размер интервала    0.1');
    Writeln('    Максимальное число итераций     1');
    Halt(1);
  End;

Procedure ReadNum( Var N );
  Begin
    Read(N);
    If IOResult<>0 then RuntimeError('Ошибка ввода данных !');
  End;

Var Func : FPtr; A,B:Real; N,NMax,LongInt; IncFlag:Boolean;
    Y,EpsF,EpsF:Real; S:String;
Begin
  Assign(Input,'INPUT.TXT');
  Reset(Input);
  If IOResult<>0 then InputError;
  Assign(Output,'OUTPUT.TXT');
  Rewrite(Output);
  Readln(S);
  Func:=GetFormula(S);
  ReadNum(A); ReadNum(B);
  ReadNum(EpsF); ReadNum(EpsX); ReadNum(NMax);
  N:=0;
  IncFlag();
  Repeat
    Inc(N);
    X_Calc:=(A+B)/2;
    Y:=CalcFormulaTree(Func);

  Until ((Y < EpsF) Or (((B-A)/A) < EpsX) Or (N > NMax));
  Close(Output);
  Close(Input);
End.
{
INPUT.TXT
sQR(X)
0 2
}