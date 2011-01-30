{ Распределение Гаусса }
Uses CRT,Graph;

{ ---=== Генератор случайных чисел ===--- }
 Type
   TGaussRandom = Object
    { M-Математическое ожидание D - Дисперсия }
     _M_,_D_,MaxGauss : Real;
    { - Инициализация генератора - }
     Constructor Init( _M,_D : Real );
    { - Кривая гаусса в этой точке - }
     Function Gauss( X,M,D : Real ):Real;
    { - Генерируем число - }
     Function RND( X : Real ):Real;
   End;

{ ---=== Инициализация генератора ===--- }
 Constructor TGaussRandom.Init( _M,_D:Real );
   Begin
     Randomize;
     _M_ := _M;
     _D_ := _D;
     MaxGauss := Gauss(_M_,_M_,_D_);
   End;

{ ---=== Кривая гаусса в этой точке ==--- }
{ M-Математическое ожидание D - Дисперсия }
 Function TGaussRandom.Gauss( X,M,D:Real ):Real;
   Begin
     Gauss:=1/(D*Sqrt(2*Pi))*Exp(-Sqr(X-M)/(2*Sqr(D)));
   End;

{ ---=== Генерируем число ==--- }
 Function TGaussRandom.RND( X:Real ):Real;
   Var R1,R2:Real;
   Begin
      Repeat
        R1:=(Random(50000)/25000)*X-X;
        R2:=(Random(50000)/50000)*MaxGauss;
      Until R2 < Gauss(R1+_M_,_M_,_D_);
      RND:=R1;
   End;

Var GaussRandom : TGaussRandom;

Procedure Graphic;
  Var GaussGr : Array [0..639] of Word; I : Word;
  Begin
    For I:=0 to 639 do GaussGr[I]:=Round(32000*GaussRandom.Gauss(I,320,80));
    For I:=0 to 638 do
      Line(I,479-GaussGr[I],I+1,479-GaussGr[I+1]);
  End;

Var GD,GM : Integer;
    Counters : Array [0..639] of Word;
    J,I : Integer; MaxGauss : Real;
Begin
  GD:=VGA; GM:=VGAHI;
  InitGraph(GD,GM,'');
  Randomize;
  GaussRandom.Init(320,80);
  Graphic;
  For I:=0 to 639 do Counters[I]:=0;
  For J:=0 to 32000 do
    Begin
      I:=320+Round(GaussRandom.RND(320));
      Inc(Counters[I]);
      PutPixel(I,480-Counters[I],14);
    End;
  ReadKey;
  CloseGraph;
End.