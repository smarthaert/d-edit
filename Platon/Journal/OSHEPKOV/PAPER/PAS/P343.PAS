{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 4  4.10.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 const
 DimSpace = 4;
 DimNods  = 24;
 DimLoops = 96;
 DimPlanes= 14;

{°°° Data }

 Type
 TVect = array[1.. DimSpace] of real;
 TPoints = array[1.. DimNods] of TVect;

 var Points:TPoints;

 Const Init_Tetra:TPoints =
 (( 1, 1, 0, 0),( 1,-1, 0, 0),
  ( 1, 0, 1, 0),( 1, 0,-1, 0),
  ( 1, 0, 0, 1),( 1, 0, 0,-1),
  (-1, 1, 0, 0),(-1,-1, 0, 0),
  (-1, 0, 1, 0),(-1, 0,-1, 0),
  (-1, 0, 0, 1),(-1, 0, 0,-1),
  ( 0, 1, 1, 0),( 0, 1,-1, 0),
  ( 0, 1, 0, 1),( 0, 1, 0,-1),
  ( 0, 0, 1, 1),( 0, 0, 1,-1),
  ( 0,-1, 1, 0),( 0,-1,-1, 0),
  ( 0,-1, 0, 1),( 0,-1, 0,-1),
  ( 0, 0,-1, 1),( 0, 0,-1,-1));

 Const Loops:array[1.. DimLoops,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1,13),( 1,14),
 ( 1,15),( 1,16),( 2, 3),( 2, 4),( 2, 5),( 2, 6),
 ( 2,19),( 2,20),( 2,21),( 2,22),( 3, 5),( 3, 6),
 ( 3,13),( 3,17),( 3,18),( 3,19),( 4, 5),( 4, 6),
 ( 4,14),( 4,20),( 4,23),( 4,24),( 5,15),( 5,17),
 ( 5,21),( 5,23),( 6,16),( 6,18),( 6,22),( 6,24),
 ( 7, 9),( 7,10),( 7,11),( 7,12),( 7,13),( 7,14),
 ( 7,15),( 7,16),( 8, 9),( 8,10),( 8,11),( 8,12),
 ( 8,19),( 8,20),( 8,21),( 8,22),( 9,11),( 9,12),
 ( 9,13),( 9,17),( 9,18),( 9,19),(10,11),(10,12),
 (10,14),(10,20),(10,23),(10,24),(11,15),(11,17),
 (11,21),(11,23),(12,16),(12,18),(12,22),(12,24),
 (13,15),(13,16),(13,17),(13,18),(14,15),(14,16),
 (14,23),(14,24),(15,17),(15,23),(16,18),(16,24),
 (17,19),(17,21),(18,19),(18,22),(19,21),(19,22),
 (20,21),(20,22),(20,23),(20,24),(21,23),(22,24));

 Const Planes3:array[1.. DimPlanes,1..3] of byte =
(( 2, 4, 5),( 1, 5,15),
 ( 1,13,15),( 9, 8,11),
 ( 7,13,15),( 8, 9,12),
 ( 2, 8,20),( 7,11, 9),
 ( 7,11,15),( 2,11, 8),
 ( 7,11,15),( 2,11, 5),
 ( 5,11,15),( 2, 4, 5));

 Const Paterns:array[1..4] of FillPatternType=
(($AA,$55,$AA,$55,$AA,$55,$AA,$55),
 ($88,$22,$88,$22,$88,$22,$88,$22),
 ($55,$66,$55,$66,$55,$66,$55,$66),
 ($77,$DD,$77,$DD,$77,$DD,$77,$DD));

 Const NambPaterns:array[1..DimPlanes] of byte =
(1,2,4,3,1,2,3,1,4,2,3,4,1,2);

{°°° Vect }

 Const Center:TVect=( 0,-0, 0, 0);

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin
 S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 procedure Press(var X:TVect;a:real);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=a*X[i];
end;

{°°° Rotate }

 Type
 TRotate = array[1..DimSpace,1..DimSpace] of real;
 Var Rotate: TRotate;

 procedure Zero(var X:TRotate);
 var j,i:byte;
begin
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 X[i,j]:=0;
end;

 procedure Init_Rotate(var X:TRotate);
 var i:byte;
begin
 Zero(X);
 for i:=1 to DimSpace do
 X[i,i]:=1;
end;

 procedure Make_Rotate(n,m:byte;a:real);
 var ca,sa:real; j,i,k:byte;
 var S,R:TRotate;
begin
 Init_Rotate(R);
 sa:=Sin(2*Pi*a); ca:=Cos(2*Pi*a);
 R[n,n]:= ca; R[n,m]:=-sa;
 R[m,n]:= sa; R[m,m]:= ca;
 Zero(S);
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 for k:=1 to DimSpace do
 S[i,j]:=S[i,j]+Rotate[i,k]*R[k,j];
 Rotate:=S;
end;

 procedure Vect_Rotate(var X:TVect);
 var i,j:byte; Y:TVect;
begin
 Y:=Center;
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

 procedure Comp_Rotate;
 var i:byte;
begin
 for i:=1 to DimNods do
 Vect_Rotate(Points[i]);
end;

 function Norm(X,Y:TVect):real;
 var i:byte; S:real;
begin
 S:=0;
 for i:=1 to DimSpace do
 S:=S+(X[i]-Y[i])*(X[i]-Y[i]);
 Norm:=S;
end;

{°°° Graphics }

 procedure OpenEGAHi(Path:string);
 var Driver,Mode:integer;
begin
 Driver:=Vga;
 Mode:=EGAHi;
 Initgraph(Driver,Mode,Path);
 if graphresult<>0 then halt;
end;

 Var x0,y0,Dx,Dy:word;

 procedure OpenScr(x:word);
 var Xasp,Yasp: Word;
begin
 SetBkColor(White);
 SetColor(Magenta);
 GetAspectRatio(Xasp, Yasp);
 x0:=Getmaxx div 2; y0:=Getmaxy div 2;
 Dx:=x; Dy:=Round((Xasp/Yasp)*Dx);
 Dy:=x;
end;

{°°° Planes }

 function XP(k:byte):integer;
begin
 XP:=Round(X0+DX*Points[k][1]);
end;

 function YP(k:byte):integer;
begin
 YP:=Round(y0+Dy*Points[k][2]);
end;

 procedure ShowPlanes3;
 var i,k:byte;
 Pl_3 : array[1..3] of PointType;
begin
 for k:=1 to DimPlanes do
 begin
  SetFillPattern(Paterns[NambPaterns[k]], Green);
  for i:=1 to 3 do
  with Pl_3[i] do
  begin
   X:=XP(Planes3[k,i]);
   Y:=YP(Planes3[k,i]);
  end;
  FillPoly(SizeOf(Pl_3) div SizeOf(PointType), Pl_3);
 end;
end;

 procedure ShowLoops;
 var i,k,m:byte;
begin
 for i:=1 to DimLoops do
 Line(XP(Loops[i,1]),YP(Loops[i,1]),
      XP(Loops[i,2]),YP(Loops[i,2]));
end;

 Const
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

 procedure ShowNamb;
 var i:byte;
begin
 for i:=1 to DimNods do
 OutTextXY( XP(i)-8,YP(i)-8,Digits[i])
end;

{°°° Main }
begin
 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(60);

 Points:=Init_Tetra;

 Init_Rotate(Rotate);
 Make_Rotate(5,2, pi/6);
 Make_Rotate(4,1, pi/7);
 Make_Rotate(1,3, pi/7);
 Make_Rotate(2,3, pi/7);
 Comp_Rotate;

 ShowLoops;
 ShowNamb;

 readln;
 CloseGraph;
end.
