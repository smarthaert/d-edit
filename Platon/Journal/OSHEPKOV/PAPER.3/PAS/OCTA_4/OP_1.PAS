{∞∞∞                                   }
{∞∞∞  å≠Æ£Æ¨•p≠†Ô £•Æ¨•‚p®Ô            }
{∞∞∞  Ç•p·®Ô 1 03.05.1997              }
{∞∞∞  Ç•p·®Ô 4  4.10.2000              }
{∞∞∞                                   }

 Uses Graph,Crt,Dos;

{∞∞∞ èpÆ·‚p†≠·‚¢Æ }

 const
 DimSpace = 4;
 MaxNods  = 8;

 Type
 TVect = array[1.. DimSpace] of real;
 TComplex = array[1..MaxNods] of TVect;

 Var
 Complex:  TComplex;

{∞∞∞ äÆ¨Ø´•™·: 4-é™‚†Ì§p }

 Const Octa_4:array[1.. MaxNods] of TVect=
(( 1, 0, 0, 0),(-1, 0, 0, 0),
 ( 0, 1, 0, 0),( 0,-1, 0, 0),
 ( 0, 0, 1, 0),( 0, 0,-1, 0),
 ( 0, 0, 0, 1),( 0, 0, 0,-1));

{∞∞∞ Vect }

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
 Complex[i]:=Octa_4[i];
end;

{∞∞∞ äÆ¨Ø´•™·Î }

 Const
 DimNods  = 8;
 DimPlanes3=6;

 Const Planes3:array[1.. DimPlanes3,1..3] of byte =
(( 4, 2, 5),
 ( 4, 5, 8),
 ( 4, 8, 1),
 ( 4, 1, 6),
 ( 3, 1, 8),
 ( 3, 5, 8));

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
 SetBkColor(White);
 SetColor(Magenta);
 GetAspectRatio(Xasp, Yasp);
 x0:=Getmaxx div 2; y0:=Getmaxy div 2;
 Dx:=x; Dy:=Round((Xasp/Yasp)*Dx);
 Dy:=x;
end;

{∞∞∞ Planes }

 function XP(k:byte;Z:TComplex):integer;
begin
 XP:=Round(X0+DX*Z[k][1]);
end;

 function YP(k:byte;Z:TComplex):integer;
begin
 YP:=Round(y0+Dy*Z[k][2]);
end;

 Const Colors3:array[1..DimPlanes3] of byte =
 (9,2,3,4,6,8);

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
   X:=XP(Planes3[k,i],COmplex);
   Y:=YP(Planes3[k,i],COmplex);
  end;
  FillPoly(SizeOf(Pl_3) div SizeOf(PointType), Pl_3);
 end;
end;

 Const
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

 procedure ShowNamb(n:byte;Z:TComplex);
 var i:byte;
begin
 for i:=1 to n do
 OutTextXY( XP(i,Z)-8,YP(i,Z)-8,Digits[i])
end;


{∞∞∞ Main }
begin
 OpenEGAHi('C:\Dos\TP.6');
 OpenScr(90);

 Init_Complex;

 Init_Rotate(Rotate);
 Make_Rotate(4,2, pi/7);
 Make_Rotate(4,1, pi/6);
 Make_Rotate(1,3, pi/8);
 Make_Rotate(2,3, pi/7);
 Comp_Rotate;

 ShowPlanes3;
 ShowNamb(MaxNods,Complex);

 readln;
 CloseGraph;
end.
