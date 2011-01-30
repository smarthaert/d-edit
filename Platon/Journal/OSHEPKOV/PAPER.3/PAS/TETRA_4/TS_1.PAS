{∞∞∞                                   }
{∞∞∞  å≠Æ£Æ¨•p≠†Ô £•Æ¨•‚p®Ô            }
{∞∞∞  Ç•p·®Ô 1 03.05.1997              }
{∞∞∞  Ç•p·®Ô    5.04.2001              }
{∞∞∞                                   }
{∞∞∞  èpÆ•™Ê®Ô ® ·•Á•≠®• ØpÆ·‚Æ£Æ ™„°† }

 Uses Graph,Crt,Dos;

{∞∞∞ èpÆ·‚p†≠·‚¢Æ }

 Const
 DimSpace = 5;
 MaxNods = 8;
 DimPlanes3 = 5;

 Type
 TVect = array[1..DimSpace] of real;
 TComplex = array[1..MaxNods] of TVect;

 Const Sect  :TVect = ( 0, 0, 1,-1,-0);

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

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 procedure Press(var X:TVect;a:real);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=X[i]*a;
end;

 procedure Move(var X:TVect;x1,x2,x3:real);
begin
 X[1]:=X[1]+x1;
 X[2]:=X[2]+x2;
 X[3]:=X[3]+x3;
end;

 Var Norm:real;

 function Vect_Norm(X:TVect):real;
 var i:byte; r:real;
begin r:=0;
 for i:=1 to DimSpace do
 r:=r+X[i]*X[i];
 Vect_Norm:=Sqrt(r);
end;

 procedure Move_Vect(R:Real;var X,Y,Z:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 Z[i]:=R*X[i]+(1-R)*Y[i];
end;

{∞∞∞ äÆ¨Ø´•™·Î }

 Const
 DimNods  = 5;
 DimLoops =10;
 DimLoops1=12;

 Var
 Nods_Pr:byte;
 Nods_Sect:byte;

 Complex:  TComplex;
 Section:  TComplex;

 Const Tetra_4:array[1.. DimNods] of TVect=
 ((-4, 1, 1, 1, 1),
  ( 1,-4, 1, 1, 1),
  ( 1, 1,-4, 1, 1),
  ( 1, 1, 1,-4, 1),
  ( 1, 1, 1, 1,-4));

 Const Loops:array[1.. DimLoops,1..2] of byte =
 ((1,2),(2,5),(2,3),(2,4),(3,4),
  (3,5),(4,5),(4,1),(5,1),(3,1));

 Const Loops1:array[1..DimLoops1,1..2] of byte =
(( 1, 3),( 3, 4),( 4, 8),
 ( 8, 6),( 6, 5),( 5, 1),
 ( 8, 6),( 6, 5),( 5, 1),
 ( 8, 6),( 6, 5),( 5, 1));

 Const Loops2:array[1.. DimLoops1,1..2] of byte =
(( 5, 6),( 6, 4),( 4, 2),
 ( 3, 2),( 1, 3),( 6, 1),
 ( 5, 1),( 5, 3),( 3, 6),
 ( 4, 3),( 1, 4),( 2, 1));

 procedure Init_Complex;
 var i:byte;
begin
 Init_Comp(Complex);
 for i:=1 to DimNods do
 Complex[i]:=Tetra_4[i];
end;

{∞∞∞ Section }

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

{∞∞∞ Rotate }

 Type
 TRotate = array[1..DimSpace] of Tvect;
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

 procedure Build(Angl:real;Axe:TVect);
 var r,ca,sa:real; i,j:byte;
 V:TVect; { ≠Æp¨®pÆ¢†≠≠†Ô Æ·Ï }
begin
 sa:=Sin(Angl); ca:=Cos(Angl);
 V:=Axe; r:=1/Vect_Norm(V);
 Press(V,r);
 for i:=1 to 3 do
 for j:=1 to 3 do
 Rotate[i,j]:= (1-ca)*V[i]*V[j];
 for i:=1 to 3 do
 Rotate[i,i]:=Rotate[i,i]+ca;

 Move(Rotate[1],0,-sa*V[3],sa*V[2]);
 Move(Rotate[2],sa*V[3],0,-sa*V[1]);
 Move(Rotate[3],-sa*V[2],sa*V[1],0);
end;

{∞∞∞ Graphics }

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
 GetAspectRatio(Xasp, Yasp);
 x0:=Getmaxx div 2; y0:=Getmaxy div 2;
 Dx:=x; Dy:=Round((Xasp/Yasp)*Dx);
 Dy:=x;
end;

{∞∞∞ }

 function XP(k:byte;Z:TComplex):integer;
begin
 XP:=Round(X0+DX*Z[k][1]);
end;

 function YP(k:byte;Z:TComplex):integer;
begin
 YP:=Round(y0+Dy*Z[k][2]);
end;

 Const
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

 procedure ShowNamb(n:byte;Z:TComplex);
 var i:byte;
begin
 for i:=1 to n do
 OutTextXY( XP(i,Z)-8,YP(i,Z)-8,Digits[i])
end;

 procedure LoopsComplex;
 var i:byte;
begin
 for i:=1 to DimLoops do
 Line( XP(Loops[i,1],Complex),YP(Loops[i,1],Complex),
       XP(Loops[i,2],Complex),YP(Loops[i,2],Complex));
end;

 procedure Loops_Sect;
 var i:byte;
begin
 for i:=1 to DimLoops1 do
 Line( XP(Loops2[i,1],Section),YP(Loops2[i,1],Section),
       XP(Loops2[i,2],Section),YP(Loops2[i,2],Section));
end;

 Const Planes3:array[1.. DimPlanes3,1..3] of byte =
(( 1, 5, 6),
 ( 6, 3, 5),
 ( 5, 2, 1),
 ( 3, 4, 2),
 ( 3, 2, 5));

 Const Colors3:array[1..DimPlanes3] of byte =
 (9,2,3,4,6);

 procedure ShowPlanes3;
 var i,k:byte;
 Pl_3 : array[1..3] of PointType;
begin
 for k:=1 to DimPlanes3 do
 begin
  SetFillStyle(SolidFill,Colors3[k]);
  for i:=1 to 3 do
  with Pl_3[i] do
  begin
   X:=XP(Planes3[k,i],Section);
   Y:=YP(Planes3[k,i],Section);
  end;
  FillPoly(SizeOf(Pl_3) div SizeOf(PointType), Pl_3);
 end;
end;

{∞∞∞ Main }
begin
 Init_Complex;

 Init_Rotate(Rotate);
 Make_Rotate(5,2, pi/6);
 Make_Rotate(4,1, pi/7);
 Make_Rotate(1,3, pi/7);
 Make_Rotate(2,4, pi/7);
 Comp_Rotate(Complex);
 Comp_Rotate(Section);

 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(35);
 SetBkColor(White);

 Make_Scals;
 Make_Section;
 SetColor(Blue);
 ShowPlanes3;
{ShowNamb(Nods_Sect,Section);}

 SetColor(Magenta);
 ShowNamb(DimNods,Complex);
 LoopsComplex;

 readln;
 CloseGraph;
end.
