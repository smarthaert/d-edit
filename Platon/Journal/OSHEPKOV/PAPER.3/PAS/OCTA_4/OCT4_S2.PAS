{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 3 17.01.1999              }
{°°°                                   }

 Uses Graph,Crt,Dos;

{°°° Data }

 Const
 Mask:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';
 DimSpace = 4;
 DimNods  = 8;
 DimLoops = 24;
 DimAngle = 1000;

 Type
 TVect = array[1..DimSpace] of real;
 TComplex = array[1..DimNods] of TVect;

 Const Space:TVect = ( 1, 1, 1, 1);

 Const X_4:TComplex =
 (( 4, 0, 0, 0),(-4, 0, 0, 0),
  ( 0, 4, 0, 0),( 0,-4, 0, 0),
  ( 0, 0, 4, 0),( 0, 0,-4, 0),
  ( 0, 0, 0, 4),( 0, 0, 0,-4));

 Const Loops:array[1..DimLoops,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1, 7),( 1, 8),
 ( 2, 3),( 2, 4),( 2, 5),( 2, 6),( 2, 7),( 2, 8),
 ( 3, 5),( 3, 6),( 3, 7),( 3, 8),( 4, 5),( 7, 6),
 ( 4, 6),( 4, 7),( 4, 8),( 5, 7),( 5, 8),( 6, 8));

 Var Complex:TComplex;

{°°° Data }

 Const
 Nods_Sect  = 8;
 Loops_Sect = 24;
 DimPlanes3 = 12;
 DimPlanes4 = 6;

 Type TSection = array[1..Nods_Sect] of TVect;

 Var Section:TSection;

 Const Init_Section:TSection = (
( 4.0, 0.0, 0.0, 0.0),
(-4.0, 0.0, 0.0, 0.0),
( 0.0, 2.0,-2.0, 0.0),
( 0.0, 2.0, 0.0,-2.0),
( 0.0,-2.0, 2.0, 0.0),
( 0.0, 0.0,-2.0, 2.0),
( 0.0,-2.0, 0.0, 2.0),
( 0.0, 0.0, 2.0,-2.0));

 Const Planes3:array[1.. DimPlanes3,1..3] of byte =
(( 1, 4, 3), ( 1, 8, 4),
 ( 1, 5, 8), ( 1, 3, 6),
 ( 1, 7, 5), ( 1, 6, 7),
 ( 2, 6, 3), ( 2, 7, 6),
 ( 2, 8, 5), ( 2, 5, 7),
 ( 2, 3, 4), ( 2, 4, 8));

 Const Planes4:array[1.. DimPlanes4,1..4] of byte =
(( 1, 9,12, 3),
 ( 1, 2,10,11),
 ( 2, 3, 8, 7),
 ( 4, 6,10, 7),
 ( 4, 8,12, 5),
 ( 5, 9,11, 6));

{°°° Rotate }

 var Rotate: array[1..DimSpace,1..DimSpace] of real;

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 procedure Mult(var X:TVect);
 var i,j:byte; Y:TVect;
begin
 for i:=1 to DimSpace do Y[i]:=0;
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

 procedure WMove(n,m:byte;a:real);
 var ca,sa:real; j,i:byte;
begin
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Rotate[i,j]:=0;
 for i:=1 to DimSpace do
 Rotate[i,i]:=1;
 sa:=Sin(2*Pi*a); ca:=Cos(2*Pi*a);
 Rotate[n,n]:= ca; Rotate[n,m]:=-sa;
 Rotate[m,n]:= sa; Rotate[m,m]:= ca;
 for i:=1 to DimNods do
 Mult(Complex[i]);
 for i:=1 to Nods_Sect do
 Mult(Section[i]);
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

 function XC(T:TVect):integer;
begin
 XC:=Round(x0+Dx*T[1]);
end;

 function YC(T:TVect):integer;
begin
 YC:=Round(y0+Dy*T[2]);
end;

 function XP(k:byte):integer;
begin
 XP:=Round(X0+DX*Section[k][1]);
end;

 function YP(k:byte):integer;
begin
 YP:=Round(y0+Dy*Section[k][2]);
end;

 procedure ShowLoops;
 var i:byte;
begin
 for i:=1 to DimLoops do
 Line( XC(Complex[Loops[i,1]]),YC(Complex[Loops[i,1]]),
       XC(Complex[Loops[i,2]]),YC(Complex[Loops[i,2]]));
end;

 procedure ShowNamb;
 var i:byte;
begin
 for i:=1 to Nods_Sect do
 OutTextXY( XC(Section[i])-8,YC(Section[i])-8,Mask[i])
end;

{°°° Planes }

 function Minor2(p1,p2:byte):real;
begin
 Minor2:=Section[P1][1]*Section[P2][2]-Section[P2][1]*Section[P1][2];
end;

 function Area(p1,p2,p3:byte):real;
begin
 Area:=(Minor2(p2,p3)+Minor2(p3,p1)+Minor2(p1,p2))/2;
end;

 Const Colors3:array[1..DimPlanes3] of byte =
 (1,2,3,4,7,6,8,9,7,6,8,9);

 procedure ShowPlanes3;
 var i,k:byte;
 Pl_3 : array[1..3] of PointType;
begin
 for k:=1 to DimPlanes3 do
 if Area(Planes3[k,1],Planes3[k,2],Planes3[k,3])>0 then
 begin
  SetFillStyle(SolidFill,Colors3[k]);
  for i:=1 to 3 do
  with Pl_3[i] do
  begin
   X:=XP(Planes3[k,i]);
   Y:=YP(Planes3[k,i]);
  end;
  FillPoly(SizeOf(Pl_3) div SizeOf(PointType), Pl_3);
 end;
end;


{°°° Main }
 var P:byte;
begin
 Complex:=X_4;
 Section:=Init_Section;
 WMove(1,4, pi/5);
 WMove(2,4, pi/6);
 WMove(3,4,-pi/7);

 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(20); P:=0;
 SetColor(Magenta);
 SetActivePage(P);
 SetVisualPage(1-P);

 repeat
  WMove(3,4,-1/DimAngle);
  WMove(2,3,-1/DimAngle);
  WMove(1,3, 1/DimAngle);
  ClearViewPort;
  ShowPlanes3;
  ShowLoops;
  ShowNamb;
  p:=1-p;
  SetActivePage(P);
  SetVisualPage(1-P);
 until keypressed;
 CloseGraph;
end.
