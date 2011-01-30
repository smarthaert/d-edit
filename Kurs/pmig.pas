{ Инжененрная графика }
Type
  TPoint = Record
    X,Y,Z : Real;
  End;

Function Calc( P1,P2:TPoint ):Real;
  Begin
    Calc:=Sqrt(
           Sqr(P1.X-P2.X) +
           Sqr(P1.Y-P2.Y) +
           Sqr(P1.Z-P2.Z));
  End;

Function Geron( P1,P2,P3:TPoint ):Real;
  Var P,A,B,C:Real;
  Begin
    A:=Calc(P1,P2);
    B:=Calc(P1,P3);
    C:=Calc(P3,P2);
    P:=(A+B+C)/2;
    Geron:=Sqrt( P * (P-A) * (P-B) * (P-C));
  End;

Function Razvertka( P1,P2,P3,P4:TPoint ):Real;
  Begin
    Razvertka:=
      Geron(P2,P3,P4)+
      Geron(P1,P3,P4)+
      Geron(P1,P2,P4)+
      Geron(P1,P2,P3);
  End;

Const
  A : TPoint = (X:20;Y:90;Z:0);
  B : TPoint = (X:70;Y:90;Z:0);
  C : TPoint = (X:20;Y:50;Z:0);
  D : TPoint = (X:60;Y:40;Z:50);

Begin
  Writeln('AB ',Calc(A,B):3:3);
  Writeln('AC ',Calc(A,C):3:3);
  Writeln('AD ',Calc(A,D):3:3);
  Writeln('BC ',Calc(B,C):3:3);
  Writeln('BD ',Calc(B,D):3:3);
  Writeln('CD ',Calc(C,D):3:3);
  Writeln(Razvertka(A,B,C,D):3:3);
End.