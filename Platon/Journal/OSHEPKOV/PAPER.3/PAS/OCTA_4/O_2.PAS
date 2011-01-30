{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 4  4.10.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 const
 DimSpace = 4;
 MaxNods  = 8;

{°°° Data }

 Type
 TVect = array[1.. DimSpace] of real;
 TComplex = array[1..MaxNods] of TVect;

 Var
 Complex:  TComplex;
 Section:  TComplex;

{°°° Š®¬¯«¥ªáë }

 Const
 DimNods  = 8;
 DimLoops =24;

 Const Tetra_4:array[1.. MaxNods] of TVect=
(( 1, 0, 0, 0),(-1, 0, 0, 0),
 ( 0, 1, 0, 0),( 0,-1, 0, 0),
 ( 0, 0, 1, 0),( 0, 0,-1, 0),
 ( 0, 0, 0, 1),( 0, 0, 0,-1));

 Const Loops:array[1.. DimLoops,1..2] of byte =
((1,3),(1,5),(1,6),(1,4),(1,7),(1,8),
 (2,3),(2,5),(2,6),(2,4),(2,7),(2,8),
 (3,5),(3,6),(3,7),(3,8),
 (4,5),(4,6),(4,7),(4,8),
 (5,7),(5,8),(6,7),(6,8));

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

 procedure Init_Complex;
 var i:byte;
begin
 Init_Comp(Complex);
 for i:=1 to MaxNods do
 Complex[i]:=Tetra_4[i];
end;

{°°° Section }

 Var Nods_Sect:byte;

 Const Sect  :TVect = ( 0, 0, 1,-0);

 Var
 Scals:array[1.. MaxNods] of real;

 procedure Make_Scals;
 var k,m:byte;
begin
 for m:=1 to MaxNods do
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

 for k:=1 to MaxNods do
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

 procedure Comp_Rotate;
 var i:byte;
begin
 for i:=1 to MaxNods do
 Vect_Rotate(Complex[i]);
end;

 function Norm(X,Y:TVect):real;
 var i:byte; S:real;
begin
 S:=0;
 for i:=1 to DimSpace do
 S:=S+(X[i]-Y[i])*(X[i]-Y[i]);
 Norm:=S;
end;

 Const Proection:TVect =
 ( 1, 1, 1, 1);

 procedure Vect_Proect(var X:TVect);
 var i:byte; S:real;
begin
 S:=Scal(X,Proection)/
 Scal(Proection,Proection);
 for i:=1 to DimSpace do
 X[i]:=X[i]-S*Proection[i];
end;

 procedure Make_Proect;
 var i:byte;
begin
 for i:=1 to DimNods do
 Vect_Proect(Complex[i]);
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


{°°° Main }
begin
 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(100);

 Init_Complex;
 Make_Proect;

 Init_Rotate(Rotate);
 Make_Rotate(1,4, pi/5);
 Make_Rotate(2,4, pi/6);
 Make_Rotate(3,4,-pi/7);
 Comp_Rotate;

 Make_Scals;
 Make_Section;

 LoopsComplex;
 ShowNamb(MaxNods,Complex);

 readln;
 CloseGraph;
end.
