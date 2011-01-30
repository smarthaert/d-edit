{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 4  4.10.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 const
 DimSpace = 4;
 MaxNods  = 16;

{°°° Data }

 Type
 TVect = array[1.. DimSpace] of real;
 TComplex = array[1.. MaxNods] of TVect;

 Const Sect  :TVect = ( 0,-0, 1,-0);

 procedure Init_Vect(var X:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=0;
end;

 procedure Init_Comp(var C:TComplex);
 var i:byte;
begin
 for i:=1 to MaxNods do
 Init_Vect(C[i]);
end;

 procedure Move_Vect(R:Real;var X,Y,Z:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 Z[i]:=R*X[i]+(1-R)*Y[i];
end;

{°°° Š®¬¯«¥ªáë }

 Const
 DimNods  = 16;
 DimLoops = 32;
 DimPlanes4 =3;

 Var
 Nods_Pr:byte;
 Nods_Sect:byte;

 Complex:  TComplex;
 Section:  TComplex;

 Const Cube_4:TComplex =
((-1,-1,-1,-1),(-1,-1, 1,-1),
 (-1, 1,-1,-1),(-1, 1, 1,-1),
 ( 1,-1,-1,-1),( 1,-1, 1,-1),
 ( 1, 1,-1,-1),( 1, 1, 1,-1),
 (-1,-1,-1, 1),(-1,-1, 1, 1),
 (-1, 1,-1, 1),(-1, 1, 1, 1),
 ( 1,-1,-1, 1),( 1,-1, 1, 1),
 ( 1, 1,-1, 1),( 1, 1, 1, 1));

 Const Loops:array[1.. DimLoops,1..2] of byte =
(( 1, 2),( 1, 3),( 2, 4),( 3, 4),
 ( 1, 5),( 2, 6),( 3, 7),( 4, 8),
 ( 5, 6),( 5, 7),( 6, 8),( 7, 8),
 ( 1, 9),( 2,10),( 3,11),( 4,12),
 ( 5,13),( 6,14),( 7,15),( 8,16),
 ( 9,10),( 9,11),(10,12),(11,12),
 ( 9,13),(10,14),(11,15),(12,16),
 (13,14),(13,15),(14,16),(15,16));

 Const Planes4:array[1.. DimPlanes4,1..4] of byte =
(( 1, 2, 4, 3),
 ( 1, 3, 7, 5),
 ( 3, 4, 8, 7));

 procedure Init_Complex;
 var i:byte;
begin
 Init_Comp(Complex);
 for i:=1 to DimNods do
 Complex[i]:=Cube_4[i];
end;

{°°° Section }

 Var
 Scals:array[1.. DimNods] of real;

 procedure Make_Scals;
 var k,m:byte;
begin
 for m:=1 to DimNods do
 begin Scals[m]:=0;
  for k:=1 to DimSpace do
  Scals[m]:=Scals[m]+Complex[m][k]*Sect[k];
 end;
end;

{°°° Vect }

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

 procedure Make_Section;
 var k,m,n1,n2:byte; r:real;
begin
 Init_Comp(Section);
 Nods_Sect:=0;

 for k:=1 to DimNods do
 if Scals[k]=0 then
 begin
  Inc(Nods_Sect);
  Section[Nods_Sect]:=Complex[k];
 end;

 for k:=1 to DimLoops do
 begin
  n1:=Loops[k][1];
  n2:=Loops[k][2];
  if Scals[n1]*Scals[n2]<0 then
  begin
   Inc(Nods_Sect);
   R:=Scals[n2]/(Scals[n2]-Scals[n1]);
   Move_Vect(R,Complex[n1],Complex[n2],
               Section[Nods_Sect]);
   R:=Scal(Section[Nods_Sect],Sect);
  end;
 end;
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
 Init_Vect(Y);
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

 procedure Comp_Rotate(var Z:TComplex);
 var i:byte;
begin
 for i:=1 to DimNods do
 Vect_Rotate(Z[i]);
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

 function XP(k:byte;Z:TComplex):integer;
begin
 XP:=Round(X0+DX*Z[k][1]);
end;

 function YP(k:byte;Z:TComplex):integer;
begin
 YP:=Round(y0+Dy*Z[k][2]);
end;

 procedure LoopsComplex;
 var i:byte;
begin
 for i:=1 to DimLoops do
 Line( XP(Loops[i,1],Complex),YP(Loops[i,1],Complex),
       XP(Loops[i,2],Complex),YP(Loops[i,2],Complex));
end;

 Const
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

 procedure ShowNamb(n:byte;Z:TComplex);
 var i:byte;
begin
 for i:=1 to n do
 OutTextXY( XP(i,Z)-8,YP(i,Z)-8,Digits[i])
end;

 Const Colors4:array[1.. DimPlanes4] of byte =
 (9,2,4);

 procedure ShowPlanes4;
 var i,k:byte;
 Pl_4 : array[1..4] of PointType;
begin
 for k:=1 to DimPlanes4 do
 begin
  SetFillStyle(SolidFill,Colors4[k]);
  for i:=1 to 4 do
  with Pl_4[i] do
  begin
   X:=XP(Planes4[k,i],Section);
   Y:=YP(Planes4[k,i],Section);
  end;
  FillPoly(SizeOf(Pl_4) div SizeOf(PointType), Pl_4);
 end;
end;

{°°° Main }
 var p:byte;
 const DimAngle=1000;
begin
 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(45);

 Init_Complex;
 Make_Scals;
 Make_Section;

 Init_Rotate(Rotate);
 Make_Rotate(4,2, pi/7);
 Make_Rotate(4,1, pi/7);
 Make_Rotate(1,3, pi/7);
 Make_Rotate(2,3, pi/7);
 Comp_Rotate(Complex);

 Comp_Rotate(Section);
 ShowPlanes4;
 SetColor(Blue);
 ShowNamb(Nods_Sect,Section);

 SetColor(Magenta);
 ShowNamb(DimNods,Complex);
 LoopsComplex;
{
 Init_Rotate(Rotate);
 Make_Rotate(4,1,-1/DimAngle);
 Make_Rotate(1,3, 1/DimAngle);
 Make_Rotate(4,2, 1/DimAngle);
 p:=0;
 repeat
  ClearViewPort;
  Comp_Rotate(Complex);
  Comp_Rotate(Section);

  ShowPlanes4;
  SetColor(Blue);
  ShowNamb(Nods_Sect,Section);

  SetColor(Magenta);
  LoopsComplex;
  ShowNamb(MaxNods,Complex);

  p:=1-p;
  SetActivePage(P);
  SetVisualPage(1-P);
 until keypressed;
}
 readln;
 CloseGraph;
end.
