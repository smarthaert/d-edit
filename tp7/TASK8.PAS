Uses CRT,_Calc;

{$I-}

Const MaxReal = 1.7E38;

Procedure InputError;
  Begin
    TextColor(14);
    Writeln(#13#10'   ---=== T A S K 8 ===---'#13#10);
    TextColor(15);
    Writeln('Не могу найти файл INPUT.TXT !'+#13#10);
    TextColor(11);
    Writeln('  Файл INPUT.TXT содержит :        Пример:');
    Writeln(' ===========================      =========');
    Writeln('    Текст функции                   Sqr(X)');
    Writeln('    Начало, конец промежутка        0 2');
    Writeln('    Точность вычисления             0.01');
    Writeln('    Алгоритм вычислений             1');
    Writeln;
    Writeln('  Алгоритмы вычислений:');
    Writeln('    1 - Метод прямоугольников');
    Writeln('    2 - Метод трапеций');
    Writeln('    3 - Метод парабол ( Симпсона )');
    Halt(1);
  End;

Const NMax = MaxLongInt div 2;

Var Func : FPtr; A,B:Real; Method:Byte; N:LongInt;
    MNum,I:Word; X,Y,Sum,Eps,SumLast,H:Real; S:String;
Begin
  Assign(Input,'INPUT.TXT');
  Reset(Input);
  If IOResult<>0 then InputError;
  Assign(Output,'OUTPUT.TXT');
  Rewrite(Output);
  Readln(S);
  Func:=GetFormula(S);
  Read(A); Read(B); Read(Eps); Read(Method);
  Case Method of
    1: Writeln('1 - Метод прямоугольников');
    2: Writeln('2 - Метод трапеций');
    3: Writeln('3 - Метод парабол ( Симпсона )');
  End;
  N:=2;
  SumLast:=MaxReal/2;
  Repeat
    H:=(B-A)/N;
    Sum:=0;
    For I:=0 to (N-1) do
      Begin
        X_Calc:=A+I*H;
        Sum:=Sum+H*CalcFormulaTree(Func);
      End;
    If N >= 4 then Writeln(B,' ',Sum:0:7,' ',N,' ',(Sum-SumLast):0:7);
    SumLast:=Sum;
    N:=N*2;
  Until ((N > NMax) Or ((Sum-SumLast)<Eps));
  Close(Output);
  Close(Input);
End.
{
INPUT.TXT
Sqr(X)
0 2
0.01
1
}