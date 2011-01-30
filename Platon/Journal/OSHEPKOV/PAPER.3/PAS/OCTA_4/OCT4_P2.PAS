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
 DimPlanes3=12;

 Type
 TVect = array[1..DimSpace] of real;
 TComplex = array[1..DimNods] of TVect;

 Const Space:TVect = ( 0, 1, 1, 1);

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

 Const Planes3:array[1.. DimPlanes3,1..3] of byte =
(( 1, 4, 7),( 1, 5, 4),
 ( 1, 8, 5),( 1, 3, 8),
 ( 1, 6, 3),( 1, 7, 6),
 ( 2, 3, 6),( 2, 6, 7),
 ( 2, 7, 4),( 2, 4, 5),
 ( 2, 5, 8),( 2, 8, 3));

{°°° Proection }

 Var Norm:real;
 Complex:TComplex;
 Rotate: array[1..DimSpace,1..DimSpace] of real;

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 procedure Vect_Proect(var X:TVect);
 var i:byte; S:real;
begin
 S:=Scal(X,Space)/Norm;
 for i:=1 to DimSpace do
 X[i]:=X[i]-S*Space[i];
end;

 procedure Make_Proect;
 var i:byte;
begin
 for i:=1 to DimNods do
 Vect_Proect(Complex[i]);
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
 XP:=Round(X0+DX*Complex[k][1]);
end;

 function YP(k:byte):integer;
begin
 YP:=Round(y0+Dy*Complex[k][2]);
end;

 procedure ShowLoops;
 var i:byte;
begin
 for i:=1 to DimLoops do
 Line( XC(Complex[Loops[i,1]]),YC(Complex[Loops[i,1]]),
       XC(Complex[Loops[i,2]]),YC(Complex[Loops[i,2]]));
end;

{°°° Planes }

 function Minor2(p1,p2:byte):real;
begin
 Minor2:=Complex[P1][1]*Complex[P2][2]-Complex[P2][1]*Complex[P1][2];
end;

 function Area(p1,p2,p3:byte):real;
begin
 Area:=(Minor2(p2,p3)+Minor2(p3,p1)+Minor2(p1,p2))/2;
end;

 Const Colors:array[1..DimPlanes3] of byte =
 (1,2,3,4,7,6,8,9,10,11,12,13);

 procedure ShowPlanes3;
 var i,k:byte;
 Pl_3 : array[1..3] of PointType;
begin
 for k:=1 to DimPlanes3 do
 if Area(Planes3[k,1],Planes3[k,2],Planes3[k,3])>0 then
 begin
  SetFillStyle(SolidFill,Colors[k]);
  for i:=1 to 3 do
  with Pl_3[i] do
  begin
   X:=XP(Planes3[k,i]);
   Y:=YP(Planes3[k,i]);
  end;
  FillPoly(SizeOf(Pl_3) div SizeOf(PointType), Pl_3);
 end;
end;

 procedure ShowNamb;
 var i:byte;
begin
 for i:=1 to DimNods do
 OutTextXY( XC(Complex[i])-8,YC(Complex[i])-8,Mask[i])
end;

{°°° Main }
 var P:byte;
begin
 Norm:=Scal(Space,Space);
 Complex:=X_4;
 Make_Proect;
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
