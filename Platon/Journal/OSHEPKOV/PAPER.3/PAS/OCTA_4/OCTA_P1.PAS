{∞∞∞                                   }
{∞∞∞  å≠Æ£Æ¨•p≠†Ô £•Æ¨•‚p®Ô            }
{∞∞∞  Ç•p·®Ô 1 03.05.1997              }
{∞∞∞  Ç•p·®Ô    5.04.2001              }
{∞∞∞                                   }
{∞∞∞  èpÆ•™Ê®Ô ® ·•Á•≠®• ØpÆ·‚Æ£Æ ™„°† }

 Uses Graph,Crt,Dos;

{∞∞∞ èpÆ·‚p†≠·‚¢Æ }

 Const
 DimSpace = 3;
 MaxNods = 8;

 Type
 TVect = array[1..DimSpace] of real;
 TComplex = array[1..MaxNods] of TVect;

 Const Vector:TVect = ( 1,-1,-1);

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

 Var Norm:real;

 procedure Vect_Proect(var X:TVect);
 var i:byte; S:real;
begin
 S:=Scal(X,Vector)/Norm;
 for i:=1 to DimSpace do
 X[i]:=X[i]-S*Vector[i];
end;

{∞∞∞ äÆ¨Ø´•™·Î }

 Const
 DimNods  = 6;
 DimLoops =12;
 DimLoops1= 6;

 Var
 Nods_Pr:byte;
 Nods_Sect:byte;

 Complex:  TComplex;
 Proection:TComplex;
 Section:  TComplex;

 Const Cube_3:array[1..DimNods] of TVect=
 ((-2, 0, 0),( 2, 0, 0),
  ( 0,-2, 0),( 0, 2, 0),
  ( 0, 0,-2),( 0, 0, 2));

 Const Loops:array[1..DimLoops,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),
 ( 2, 3),( 2, 4),( 2, 5),( 2, 6),
 ( 3, 5),( 5, 4),( 4, 6),( 6, 3));

 Const Loops1:array[1..DimLoops1,1..2] of byte =
(( 1, 5),( 5, 4),( 4, 2),
 ( 2, 6),( 6, 3),( 3, 1));

 Const Loops2:array[1..DimLoops1,1..2] of byte =
(( 1, 2),( 2, 5),( 5, 3),
 ( 3, 4),( 4, 6),( 6, 1));

 procedure Init_Complex;
 var i:byte;
begin
 Init_Comp(Complex);
 for i:=1 to DimNods do
 Complex[i]:=Cube_3[i];
end;

{∞∞∞ Proection }

 procedure Make_Proection;
 var i:byte;
begin
 Nods_Pr:=DimNods;
 Proection:=Complex;
 Norm:=Scal(Vector,Vector);
 for i:=1 to DimNods do
 Vect_Proect(Proection[i]);
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
  Scals[m]:=Scals[m]+Complex[m][k]*Vector[k];
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
   n1:=Loops[k][1];
   n2:=Loops[k][2];
   r:=Scals[n1]-Scals[n2];
   for m:=1 to DimSpace do
   if (Scals[n1]+Scals[n2]=0)
   then Section[Nods_Sect][m]:=
   (Complex[n1][m]+Complex[n2][m])/2
   else Section[Nods_Sect][m]:=
   (-Complex[n1][m]*Scals[n2]+Complex[n2][m]*Scals[n1])/r;
  end;
 end;
end;

{∞∞∞ Rotate }

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

 procedure Loops_Pr;
 var i:byte;
begin
 for i:=1 to DimLoops1 do
 Line( XP(Loops1[i,1],Proection),YP(Loops1[i,1],Proection),
       XP(Loops1[i,2],Proection),YP(Loops1[i,2],Proection));
end;

 procedure Loops_Sect;
 var i:byte;
begin
 for i:=1 to DimLoops1 do
 Line( XP(Loops2[i,1],Section),YP(Loops2[i,1],Section),
       XP(Loops2[i,2],Section),YP(Loops2[i,2],Section));
end;

{∞∞∞ Main }
begin
 Init_Complex;
 Make_Scals;
 Make_Proection;
 Make_Section;

 Init_Rotate(Rotate);
 Make_Rotate(2,3, pi/9);
 Make_Rotate(1,3, pi/7);
 Comp_Rotate(Complex);
 Comp_Rotate(Section);
 Comp_Rotate(Proection);

 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(50);
 SetBkColor(White);

 SetColor(Magenta);
 ShowNamb(DimNods,Complex);
 LoopsComplex;

 SetColor(Green);
 Loops_Pr;
 ShowNamb(Nods_Pr,Proection);

 SetColor(Blue);
 Loops_Sect;
 ShowNamb(Nods_Sect,Section);

 readln;
 CloseGraph;
end.
