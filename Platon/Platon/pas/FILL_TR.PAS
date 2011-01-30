Uses Graph,CRT;

Var
  P : Array [0..3] of PointType;
  GD,GM : Integer;
  A,B,X1,X2 : Integer;
Begin
  GD:=VGA; GM:=VGAHI;
  InitGraph(GD,GM,'');
  P[0].X:=200; P[0].Y:=100;
  P[1].X:=400; P[1].Y:=100{250};
  P[2].X:=450; P[2].Y:=400;
  P[3].X:=200; P[3].Y:=100;
  SetColor(5);
  If (P[0].Y <> P[1].Y) And (P[0].Y <> P[2].Y) then
    For A:=P[0].Y to P[1].Y do
      Begin
        x1:=Round( ((P[2].X-P[0].X)/(P[2].Y-P[0].Y)) * (a-P[0].Y) ) + P[0].X;
        x2:=Round( ((P[1].X-P[0].X)/(P[1].Y-P[0].Y)) * (a-P[0].Y) ) + P[0].X;
        For B:=X1 to X2 do
          PutPixel(B,A,Random(16));
      End;
  If (P[0].Y <> P[2].Y) And (P[1].Y <> P[2].Y) then
    For A:=P[1].Y to P[2].Y do
      Begin
        x1:=Round( ((P[2].X-P[0].X)/(P[2].Y-P[0].Y)) * (a-P[0].Y) ) + P[0].X;
        x2:=Round( ((P[2].X-P[1].X)/(P[2].Y-P[1].Y)) * (a-P[1].Y) ) + P[1].X;
        For B:=X1 to X2 do
          PutPixel(B,A,Random(16));
      End;
  SetColor(15);
  DrawPoly(4,P);
  ReadKey;
  CloseGraph;
End.