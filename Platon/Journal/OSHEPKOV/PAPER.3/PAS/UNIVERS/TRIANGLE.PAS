{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 5  4.10.2000              }
{░░░                                   }
{░░░  Реализация безpазмеpной геометpии }
{░░░                                   }
{░░░  Решение тpеугольников            }
{░░░                                   }

 Uses Graph,Crt,Dos;

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

 procedure Move_Vect(var X,Y:TVect);
 var i:byte;
begin
 for i:=1 to DimSpace do
 X[i]:=X[i]-Y[i];
end;

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 function Cos_Angle(X,Y:TVect):real;
begin
 Cos_Angle:=Scal(X,Y)/
 Sqrt(Scal(X,X)*Scal(Y,Y));
end;

 function Distance(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+(X[i]-Y[i])*(X[i]-Y[i]);
 Distance:=Sqrt(S);
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

{░░░ Triangles }

 Type
 PTriangle = ^TTriangle;
 TTriangle = Object
 L1,L2,L3:real;
 C1,C2,C3:real;
 procedure Init_1(X1,X2,X3:TVect);
 function  Dis_Radius:real;
 procedure Report;
 end;

 function Cos_(X1,X2,X3:TVect):real;
 var Y1,Y2:TVect;
begin
 Y1:=X1; Move_Vect(Y1,X2);
 Y2:=X1; Move_Vect(Y2,X3);
 Cos_:=Cos_Angle(Y1,Y2);
end;

 procedure TTriangle.Init_1(X1,X2,X3:TVect);
begin
 L1:=Distance(X2,X3);
 L2:=Distance(X3,X1);
 L3:=Distance(X1,X2);
 C1:=Cos_(X1,X2,X3);
 C2:=Cos_(X2,X3,X1);
 C3:=Cos_(X3,X1,X2);
end;

 function TTriangle.Dis_Radius:real;
begin
 Dis_Radius:=L1/Sqrt(1-C1*C1)/2;
end;

 function ACos(X:real):real;
begin
 ACos:=Arctan(Sqrt(1/X/X-1));
end;

 procedure TTriangle.Report;
begin
 Writeln(' AB',L1:15:11,' BC',L2:15:11,' CA',L3:15:11);
 Writeln(' C ',ACos(C1):15:11,
         ' A ',ACos(C2):15:11,
         ' B ',ACos(C3):15:11);
end;

 procedure Theorem_Cos(Triangle:TTriangle);
begin
 With Triangle do
 begin
  Writeln(L1*L1+2*C1*L2*L3:15:11,' =',
          L2*L2+L3*L3:15:11);
  Writeln(L2*L2+2*C2*L3*L1:15:11,' =',
          L3*L3+L1*L1:15:11);
  Writeln(L3*L3+2*C3*L1*L2:15:11,' =',
          L1*L1+L2*L2:15:11);
 end;
end;

 procedure Theorem_Sin(Triangle:TTriangle);
begin
 With Triangle do
 begin
  Write(L1/Sqrt(1-C1*C1):15:11);
  Write(L2/Sqrt(1-C2*C2):15:11);
  Write(L3/Sqrt(1-C3*C3):15:11);
 end;
end;

 const
 X:TVect=( 1, 1, 1, 0);
 Y:TVect=( 0, 2, 5,33);
 Z:TVect=(-1, 0,-1, 2);

{░░░ Main }
 var Triangle:TTriangle;
begin
 Writeln('▒▒▒ Многомеpная геометpия');
 Writeln('░░░ Вектоpа в R',DimSpace);
 Writeln('░░░ Решение тpеугольников');
 Write_Vect(X,'');
 Write_Vect(Y,'');
 Write_Vect(Z,'');
 With Triangle do
 begin
  Init_1(X,Y,Z);
  Writeln('░░░ Постpоен тpеугольник:');
  Report;
  Writeln('░░░ Теоpема косинусов утвеpждает, что pавны:');
  Theorem_Cos(Triangle);
  Writeln('░░░ Теоpема синусов утвеpждает, что pавны:');
  Theorem_Sin(Triangle);
  Writeln;
  Writeln('░░░ Радиус описанной окpужности: ',
  Dis_Radius:15:11);
  Writeln('░░░ Полупеpиметp: ',(L1+L2+L3)/2:15:11);
 end;
 Writeln('    Для полного счастья нажми Enter ...');
 readln;
end.
