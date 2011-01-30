{°°°                                   }
{°°°  ‹¨­¥©­ë©  ­ «¨§                  }
{°°°  ‚¥pá¨ï 1 03.05.1993              }
{°°°  ‚¥pá¨ï 4 00.12.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 procedure ErrHalt(S: String);
begin
 Writeln(S); {Halt;}
end;

{°°° Space and Vectors }

 Const DimSpace = 4;

 Type
 PVect = ^TVect;
 TVect = array[1.. DimSpace] of real;

 procedure Init_Vect(var X:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=0;
end;

 procedure Press_Vect(R:real;var X:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=X[i]*R;
end;

 function Norm(X:TVect):real;
 var i:byte; r:real;
begin r:=0;
 for i:=1 to DimSpace do
 r:=r+X[i]*X[i];
 Norm:=Sqrt(r);
end;

 procedure Write_Vect(X:TVect;Name:string);
 var k:byte; f:text;
begin
 Assign(f,Name); Append(f);
 Write  (f,'(');
 for k:=1 to DimSpace do
 Write(f,X[k]:5:1);
 Writeln(f,')');
 Close(f);
end;

{±±± Œ âp¨æë }

 Type Tmatr =
 array[1..DimSpace] of TVect;

 procedure Zero_Matr(var X:TMatr);
 var i,j:byte;
begin
 for i:=1 to DimSpace do
 Init_Vect(X[i]);
end;

 procedure Init_Matr(var X:TMatr);
 var i,j:byte;
begin
 Zero_Matr(X);
 for i:=1 to DimSpace do
 X[i][i]:=1;
end;

 procedure Transp(var X:TMatr);
 var i,j:byte; Y:TMatr;
begin
 for i:=0 to DimSpace do
 for j:=0 to DimSpace do
 Y[j,i]:=X[i,j];
end;

 procedure Matr_Mult(var U,V,W:TMatr);
 var i,j,k:byte;
begin
 Zero_Matr(W);
 for i:=0 to DimSpace do
 for j:=0 to DimSpace do
 for k:=0 to DimSpace do
 W[i,j]:=W[i,j]+U[i,k]*V[k,j];
end;

 procedure Vect_Mult(X:TMatr;var U:TVect);
 var i,j:byte; r:Real; Vect:TVect;
begin
 Init_Vect(Vect);
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Vect[i]:=Vect[i]+X[i,j]*U[j];
 U:=Vect;
end;

 function Radius(X:TMatr):real;
 var i:word; r,N0,N1:Real;
 V:TVect;
begin
 Init_Vect(V); V[1]:=1; i:=0;
 Repeat
  Inc(i); N1:=N0;
  Vect_Mult(X,V);
  N0:=Norm(V); r:=1/N0;
  Press_Vect(r,V);
 Until (abs((1-N1/N0))<1E-7) or (i>200);
 Radius:=N0;
end;

 procedure Max_Element(X:TMatr;var i,j:byte);
 var i1,j1:byte; Max:real;
begin  Max:=-1E9;
 for i1:=1 to DimSpace do
 for j1:=i1+1 to DimSpace do
 if (Max<abs(X[i1,j1])) and (i<>j) then
 begin
  Max:=abs(X[i1,j1]);
  i:=i1;  j:=j1;
 end;
end;

 procedure Make_Rotate(n,m:byte;a:real;var X:TMatr);
 var ca,sa:real;
begin
 Init_Matr(X);
 sa:=Sin(2*Pi*a); ca:=Cos(2*Pi*a);
 X[n,n]:= ca; X[n,m]:=-sa;
 X[m,n]:= sa; X[m,m]:= ca;
end;

 procedure Write_Matr(X:TMatr;Name:string);
 var k:byte; f:text;
begin
 for k:=1 to DimSpace do
 Write_Vect(X[k],Name);
end;

 procedure Rotate(var X,U:TMatr);
 var Z,V:TMatr;
begin
 Init_Matr(X);
 V:=U; Transp(V);
 Matr_Mult(V,X,Z);
 Matr_Mult(Z,U,X);
end;

 procedure Control(X:TMatr);
 var Z,V:TMatr;
begin
 Write_Matr(X,'');
 Gotoxy(1,wherey-DimSpace-1);
end;

 procedure Danilev(var X,Y,U:TMatr);
 var i,j:byte; a,s:real;
begin
 Repeat
  Max_Element(X,i,j);
  s:=X[i,j]-X[j,i];
  if s=0 then a:=Pi/2 else
  a:=Arctan(2*X[1,j]/s)/2;
  Make_Rotate(i,j,a,U);
  Y:=X; Rotate(Y,U);
  Control(Y);
 Until (Radius(X)<1E-9) or keypressed;
end;

 const Demo:array[1..4,1..4] of real=(
( 1,-1,-1,-4),
(-1, 3,-2,-1),
(-1,-2, 1,-1),
(-4,-1,-1, 1));

 procedure Init_Demo(var X:TMatr);
 var i,j:byte;
begin
 Init_Matr(X);
 for i:=1 to 4 do
 for j:=1 to 4 do
 X[i][j]:=Demo[i,j];
end;

{°°° Main }
 var X,Y,U:TMatr;
begin
 Writeln('ÛÛÛ ‹¨­¥©­ë©  ­ «¨§');
 Writeln('°°° Ž¡p é¥­¨¥ á¨¬¬¥âp¨ç­®© ¬ âp¨æë:');
 Init_Demo(X);
 Write_Matr(X,'');
 Writeln('°°° ‘¯¥ªâp «ì­ë© p ¤¨ãá :', Radius(X):5:1);
 Danilev(X,Y,U);
 readln;
end.
