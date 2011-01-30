Uses CRT,_Calc;

{$I-}

Const MaxReal = 1.7E38;

Procedure InputError;
  Begin
    TextColor(14);
    Writeln(#13#10'   ---=== T A S K 3 ===---'#13#10);
    TextColor(15);
    Writeln('Не могу найти файл INPUT.TXT !'+#13#10);
    TextColor(11);
    Writeln('  Файл INPUT.TXT содержит :        Пример:');
    Writeln(' ===========================      =========');
    Writeln('    Количество функций              4');
    Writeln('    Текст первой функции            Ln(X)');
    Writeln('    Текст второй функции            Sqrt(X)');
    Writeln('     ...                            Cos(X)');
    Writeln('    Текст последней функции         Sin(X)+Tan(X)');
    Writeln('    Количество точек                3');
    Writeln('    X,Y первой точки                1.3 12.2');
    Writeln('    X,Y второй точки                2.4 2.3');
    Writeln('     ...                            10 3');
    Writeln('    X,Y последней точки');
    Halt(1);
  End;

Type
  PFunction = ^TFunction;
  TFunction = Record
    FuncTree : FPtr;
    Next : PFunction;
  End;

Const FunctionList : PFunction = nil;

Procedure RegisterAllFunctions;
  Var CurFunc,OldFunc:PFunction; FNum,I:Word; S:String;
  Begin
    Readln(FNum);
    OldFunc:=nil;
    For I:=1 to FNum do
      Begin
        Readln(S);
        New(CurFunc);
        If OldFunc<>nil then OldFunc^.Next:=CurFunc;
        If FunctionList = nil then FunctionList := CurFunc;
        CurFunc^.FuncTree:=GetFormula(S);
        CurFunc^.Next:=nil;
        OldFunc:=CurFunc;
      End;
  End;

Function Check( X,Y:Real ):Boolean;
  Var CurFunc : PFunction; R,Min,Max:Real;
  Begin
    X_Calc:=X;
    Min:=+MaxReal;
    Max:=-MaxReal;
    CurFunc:=FunctionList;
    While CurFunc<>nil do
      Begin
        R:=CalcFormulaTree(CurFunc^.FuncTree);
        If ((R < Min) And (Not Error)) then Min:=R;
        If ((R > Max) And (Not Error)) then Max:=R;
        CurFunc:=CurFunc^.Next;
      End;
    Check:=((Y >= Min) And (Y <= Max));
  End;

Var MNum,I:Word; X,Y:Real;
Begin
  Assign(Input,'INPUT.TXT');
  Reset(Input);
  If IOResult<>0 then InputError;
  Assign(Output,'OUTPUT.TXT');
  Rewrite(Output);
  RegisterAllFunctions;
  Writeln('Координаты точек находящихся в области D');
  Read(MNum);
  For I:=1 to MNum do
    Begin
      Read(X); Read(Y);
      If Check(X,Y) then Writeln('(',X:0:8,';',Y:0:8,')');
    End;
  Close(Output);
  Close(Input);
End.

{
INPUT.TXT
2
X
X-1
4
1 1
2 2
3 4
4 4
}