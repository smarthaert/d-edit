{ > "Система распознавания образов" }
{ > На экране случайным образом генерируется прямоугольник }
{ > Задача - определить координаты его углов сканируя экран }
{ > И повернуть так, чтобы стороны были параллельны краям экрана }
Uses CRT,Graph;

{ ---=== Рисование прямоугольника ===--- }
Procedure DrawRectangle( X1,Y1,A,B:Integer; Angle:Real );
  Var SinA,CosA:Real; X2,Y2,X3,Y3,X4,Y4:Integer;
  Begin
    SinA := Sin(Angle);
    CosA := Cos(Angle);
    X2 := X1 + Round(A*CosA);
    Y2 := Y1 + Round(A*SinA);
    X3 := X2 + Round(B*SinA);
    Y3 := Y2 - Round(B*CosA);
    X4 := X3 - Round(A*CosA);
    Y4 := Y3 - Round(A*SinA);
    SetColor(11);
    Line(X1,Y1,X2,Y2);
    Line(X2,Y2,X3,Y3);
    Line(X3,Y3,X4,Y4);
    Line(X4,Y4,X1,Y1);
  End;

{ ---=== Генерирование прямоугольника ===--- }
Procedure GenerateRectangle;
  Var X,Y,A,B:Integer; Angle:Real;
  Begin
    Randomize;
    DrawRectangle( 220 + Random(200), 140 + Random(200),
                   100 + Random(100), 100 + Random(100),
                    (Pi*Random(360))/180 );
  End;

{ ---=== Прямоугольник ===--- }
Var X : Array [1..4] of Integer;
    Y : Array [1..4] of Integer;

{ ---=== Расчет прямоугольника ===--- }
Procedure CalculateRectangle;
  Var _X_,_Y_:Integer; Find,Flag,Last:Boolean;
  Begin
   { ---=== Вертикальное сканирование ===--- }
    Flag:=False;
    For _Y_:=1 to GetMaxY do
      Begin
       { Поиск пикселя в строке }
        Find:=False;
        For _X_:=1 to GetMaxX do
          If GetPixel(_X_,_Y_)<>0 then
            Begin
              Find:=True;
              Break;
            End;
       { Анализ }
        If Find And not Flag then Begin Y[4]:=_Y_; Flag:=True; End;
        If not Find And Flag then Begin Y[2]:=_Y_-1; _Y_:=GetMaxY; End;
       { Прогресс }
        PutPixel(0,_Y_,3+Ord(Flag));
      End;
   { ---=== Горизонтальное сканирование ===--- }
    Flag:=False;
    For _X_:=1 to GetMaxX do
      Begin
       { Поиск пикселя в строке }
        Find:=False;
        For _Y_:=1 to GetMaxY do
          If GetPixel(_X_,_Y_)<>0 then
            Begin
              Find:=True;
              Break;
            End;
       { Анализ }
        If Find And not Flag then Begin X[1]:=_X_; Flag:=True; End;
        If not Find And Flag then Begin X[3]:=_X_-1; Break; End;
       { Прогресс }
        PutPixel(_X_,0,3+Ord(Flag));
      End;
   { ---=== Угловое сканирование ===--- }
    Flag:=True;
    Y[1]:=1;
    While GetPixel(X[1],Y[1]) = 0 do Inc(Y[1]);
    If Y[1] = Y[4] then Flag:=False;
    While GetPixel(X[1],Y[1]) <> 0 do Inc(Y[1]);
    Dec(Y[1]);
    X[4]:=1;
    While GetPixel(X[4],Y[4]) = 0 do Inc(X[4]);
    If Flag then
      Begin
        While GetPixel(X[4],Y[4]) <> 0 do Inc(X[4]);
        Dec(X[4]);
      End;
   { ---=== Рамки ===--- }
    SetColor(6);
    Line(1,Y[2],639,Y[2]);
    Line(1,Y[4],639,Y[4]);
    Line(X[1],1,X[1],479);
    Line(X[3],1,X[3],479);
   { ---=== Подсчет ===--- }
    X[2]:=X[1]+X[3]-X[4];
    Y[3]:=Y[2]+Y[4]-Y[1];
   { ---=== Обводим ===--- }
    SetColor(13);
    For _X_:=1 to 4 do
      Circle(X[_X_],Y[_X_],_X_*1);
  End;

{ ---=== Поворот прямоугольника ===--- }
Procedure RotateRectangle;
  Var I,Temp:Integer; A,CosA,SinA:Real;
  Begin
    A := Sqrt(Sqr(X[2]-X[1]) + Sqr(Y[2]-Y[1]));
    CosA := (X[2]-X[1]) / A;
    SinA := (Y[2]-Y[1]) / A;
    For I:=2 to 4 do
      Begin
        X[I]:=X[I]-X[1];
        Y[I]:=Y[I]-Y[1];
        Temp:=X[I];
        X[I]:=Round(X[I]*CosA + Y[I]*SinA);
        Y[I]:=Round(Y[I]*CosA - Temp*SinA);
        X[I]:=X[I]+X[1];
        Y[I]:=Y[I]+Y[1];
      End;
    SetColor(15);
    Line(X[1],Y[1],X[2],Y[2]);
    Line(X[2],Y[2],X[3],Y[3]);
    Line(X[3],Y[3],X[4],Y[4]);
    Line(X[4],Y[4],X[1],Y[1]);
  End;

{ ---=== Основная Программа ===--- }
Var GD,GM:Integer;
Begin
  GD:=VGA; GM:=VGAHI;
  InitGraph(GD,GM,'');
  GenerateRectangle;
  CalculateRectangle;
  RotateRectangle;
  ReadKey;
  CloseGraph;
End.