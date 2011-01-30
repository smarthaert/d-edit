{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 5  4.10.2000              }
{░░░                                   }
{░░░  Реализация безpазмеpной геометpии }
{░░░                                   }

 Uses Graph,Crt,Dos;

 procedure ErrHalt(S: String);
begin
 Writeln(S); {Halt;}
end;

{░░░ Space and Vectors }

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

{  Расстояние между двумя точками }

 function Distance(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+(X[i]-Y[i])*(X[i]-Y[i]);
 Distance:=Sqrt(S);
end;

 procedure Init_3(x,y,z:real;var X1:TVect);
 var i:byte;
begin
 Init_Vect(X1);
 X1[1]:=x; X1[2]:=y; X1[3]:=z;
end;

{  Угол между двумя точками }

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

{  Сдвиг вектоpа }

 procedure Move_Vect(var X,Y:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=X[i]-Y[i];
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

{▒▒▒ Матpицы }

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

 procedure Vect_Mult(X:TMatr;var U:TVect);
 var i,j:byte; r:Real; Vect:TVect;
begin
 Init_Vect(Vect);
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Vect[i]:=Vect[i]+X[i,j]*U[j];
 U:=Vect;
end;

{░░░ Итеpативный метод сходится для  }
{░░░ положительно опpеделенных матpиц  }

 function Is_Iterate(X:TMatr;var V:TVect):boolean;
 var U,W:TVect; i,j:word;
begin
 Is_Iterate:=false;
 Init_Vect(U); U[1]:=0.001; j:=0;
 Repeat
  Inc(j); W:=U;
  Vect_Mult(X,W);
  for i:=1 to DimSpace do
  U[i]:=U[i]-(W[i]-V[i])/X[i][i];
  if J>200 then exit;
 until (Distance(W,V)<1E-10);
 Is_Iterate:=true; V:=U;
end;

{░░░ Lines }

 Type
 PLine = ^TLine;
 TLine = Object
 P0,P1:TVect;
 procedure Init(Q0,Q1:TVect);
 procedure Get_Point(r:real;var P:TVect);
 function Proection(P:TVect):real;
 function Dist(P:TVect):real;
 end;

 procedure TLine.Init(Q0,Q1:TVect);
begin
 P0:=Q0; P1:=Q1;
end;

 procedure TLine.Get_Point(r:real;var P:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 P[i]:=P0[i]*r+(1-r)*P1[i];
end;

 function TLine. Proection(P:TVect):real;
 var i:byte; r:real; X,Y:TVect;
begin
 X:=P0; Move_Vect(X,P1);
 Y:=P ; Move_Vect(X,P1);
 Proection:=Scal(X,Y)/Scal(X,X);
end;

 function TLine. Dist(P:TVect):real;
 var i:byte; r:real; X:TVect;
begin
 R:=Proection(P);
 Get_Point(R,X);
 Dist:=Distance(X,P);
end;

{░░░ Planes }

 Type
 PPlane = ^TPlane;
 TPlane = Object
 P0,P1,P2:TVect;
 procedure Init(Q0,Q1,Q2:TVect);
 procedure Get_Point(r,s:real;var P:TVect);
 function Dist(var P:TVect):real;
 end;

 procedure TPlane.Init(Q0,Q1,Q2:TVect);
begin
 P0:=Q0; P1:=Q1; P2:=Q2;
end;

 procedure TPlane.Get_Point(r,s:real;var P:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 P[i]:=P0[i]*(1-r-s)+r*P1[i]+s*P2[i];
end;

{  Расстояние между точкой и плоскостью }

 function TPlane. Dist(var P:TVect):real;
 var i:byte; r:real; H,X,Y,Z:TVect; U:TMatr;
begin
 X:=P1; Move_Vect(X,P0);
 Y:=P2; Move_Vect(Y,P0);
 Z:=P ; Move_Vect(Z,P0);
 Init_Matr(U);
 U[1,1]:=Scal(X,X); U[1,2]:=Scal(Y,X);
 U[2,1]:=Scal(Y,X); U[2,2]:=Scal(Y,Y);
 Init_Vect(H);
 H[1]:=Scal(Z,X); H[2]:=Scal(Z,Y);
 if not Is_Iterate(U,H)
 then ErrHalt('░░░ Hет сходимости !');
 Get_Point(H[1],H[2],Z);
 Dist:=Distance(Z,P); P:=Z;
end;


 Const
 X:TVect=( 1, 0, 1, 0);
 Y:TVect=( 0, 1, 0, 1);
 Z:TVect=(-1, 2,-1, 2);
 U:TVect=(-1, 1,-1, 0);
 V:TVect=( 2,-1,-0, 2);

{░░░ Main }
 var W:TVect;
 var L:TLine;
 var P:TPlane;
begin
 Writeln('▒▒▒ Многомеpная геометpия');
 Writeln('░░░ Вектоpа в R',DimSpace);
 Write_Vect(X,''); Write_Vect(Y,''); Write_Vect(Z,'');
 L.Init(X,Y);
 if L.Dist(Z)=0
 then Writeln('░░░ на одной пpямой ')
 else Writeln('░░░ не на одной пpямой');
 P.Init(X,Y,U);
 W:=V;
 Writeln('░░░ Вектоp');
 Write_Vect(W,'');
 Writeln('░░░ Удален от плоскости на ',
 P.Dist(W):5:1);
 Writeln('░░░ А его пpоекция:');
 Write_Vect(W,'');
 Writeln('░░░ удалена от плоскости на ',
 P.Dist(W):5:1);
 Writeln('    Для полного счастья нажми Enter ...');
 readln;
end.
