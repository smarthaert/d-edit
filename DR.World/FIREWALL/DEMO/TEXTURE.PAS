Uses Video,CRT;

Function Fractal(X,Y:Real):Byte;
  Const
    Scale=0.6;
  Var
    N:Real;
Begin
   N:=Sqrt(Cos(X/5)*Cos(X/5)*7+Sin(Y/5)*Sin(Y/5)*5+(X-165)*(X-155)/500+(Y-105)*(Y-95)/500+Random(5));
   Fractal:=(Trunc(N/Scale)+16384)Mod 256;
End;

Procedure PutFractal;
  Var
    I,J:Word;
Begin
   For I:=0 to 319 do
     For J:=0 to 199 do
       PutPixel(I,J,(Fractal(I,J) Mod 16)+16);
End;

Procedure BuildTexture;
Begin
   PutFractal;
End;

Begin
   InitMCGA;
   BuildTexture;
   ReadKey;
   DoneMCGA;
End.