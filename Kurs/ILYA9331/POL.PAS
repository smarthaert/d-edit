Uses CRT,Poly;

{ ************* }
{ * Степень X * }
{ ************* }
Type
  PXStep = ^TXStep;
  TXStep = Record
    Coef     : PDigit;
    Step     : Word;
    NextStep : PXStep;
  End;

{ --- Устанавливание коэффициента --- }
Procedure MakeXStep( Var Root:PXStep; CoefStr:String; Step:Word );
  Var NewEl:PXStep;
  Begin
    New(NewEl);
    MakeCoef(NewEl^.Coef,CoefStr);
    NewEl^.Step := Step;
    Root        := NewEl;
  End;

{ --- Уничтожение полинома --- }
Procedure DelPol( Var Root:PXStep );
  Var Buf:PXStep;
  Begin
    While Root<>nil do
      Begin
        Buf:=Root;
        Root:=Root^.NextStep;
        DelCoef(Buf^.Coef);
        Dispose(Buf);
      End;
  End;

{ ******************** }
{ * Список полиномов * }
{ ******************** }
Type
  PPolynom = ^TPolynom;
  TPolynom = Record
    Name : String;
    Step : PXStep;
    Next : PPolynom;
  End;

Const Polynoms : PPolynom = nil;

{ --- Добавление полинома --- }
Procedure AddPolynom( NewPolynomName:String );
  Var NewEl,Cur : PPolynom;
  Begin
    New(NewEl);
    NewEl^.Name := NewPolynomName;
    NewEl^.Step := nil;
    NewEl^.Next := nil;
    If Polynoms = nil then
      Begin
        Polynoms := NewEl;
        Exit;
      End;
    Cur := Polynoms;
    While Cur^.Next <> nil do Cur:=Cur^.Next;
    Cur^.Next := NewEl;
  End;

{ --- Уничтожение всех полиномов --- }
Procedure DeleteAllPolynoms;
  Var Buf:PPolynom;
  Begin
    While Polynoms<>nil do
      Begin
        Buf:=Polynoms;
        Polynoms:=Polynoms^.Next;
        DelPol(Buf^.Step);
        Dispose(Buf);
      End;
  End;

Var Test1,Test2,Test3:PDigit;
Begin
  ClrScr;
  MakeCoef(Test1,'2');
  MakeCoef(Test2,'2');
  Test3:=SubCoef(Test1,Test2);
  Writeln(ShowCoef(Test1));
  Writeln(ShowCoef(Test2));
  Writeln(ShowCoef(Test3));
  DelCoef(Test1);
  DelCoef(Test2);
  DelCoef(Test3);
  ReadKey;
End.