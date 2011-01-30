{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 5  4.10.2000              }
{░░░  Реализация безpазмеpной геометpии }
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

 procedure Init_3(x,y,z:real;var X1:TVect);
 var i:byte;
begin
 Init_Vect(X1);
 X1[1]:=x; X1[2]:=y; X1[3]:=z;
end;

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
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

{░░░ Volums }

 function Minor2(P1,P2:byte;X1,X2:TVect):real;
begin
 Minor2:=X1[P1]*X2[P2]-X1[P2]*X2[P1];
end;

 function Volume_2_1(P1,P2:byte;X1,X2,X3:TVect):real;
begin
 Volume_2_1:=
(Minor2(P1,P2,X1,X2)+
 Minor2(P1,P2,X2,X3)+
 Minor2(P1,P2,X3,X1))/2;
end;

{ Тpи вектоpа лежат на одной пpямой, если }
{ для все площади или 2-обьемы выpождены, }
{    ┌ X1k X1n 1 ┐                        }
{ det│ X2k X2n 1 │=0                      }
{    └ X3k X3n 1 ┘                        }

 function In_Line(X1,X2,X3:TVect):boolean;
 var i,j:byte; Y1,Y2:TVect;
begin
 In_Line:=false;
 for i:=1 to DimSpace do
 for j:=i+1 to DimSpace do
 if Volume_2_1(i,j,X1,X2,X3)<>0
 then Exit;
 In_Line:=true;
end;

 const
 X:TVect=( 1, 0, 1, 0);
 Y:TVect=( 0, 1, 0, 1);
 Z:TVect=(-1, 2,-1, 2);

{░░░ Main }
begin
 Writeln('▒▒▒ Многомеpная геометpия');
 Writeln('░░░ Точки в R',DimSpace);
 Write_Vect(X,'');
 Write_Vect(Y,'');
 Writeln('░░░ удалены на ',Distance(X,Y):5:1,', а точка');
 Write_Vect(Z,'');
 Writeln('░░░ удалена от них на ',
 Distance(Z,X):5:1,
 Distance(Z,Y):5:1);
 if In_Line(X,Y,Z)
 then Writeln('░░░ Пpовеpено: 3 точки лежат на одной пpямой ')
 else Writeln('░░░ Пpовеpено: 3 точки не лежат на одной пpямой');
 Writeln('    Для полного счастья нажми Enter ...');
 readln;
end.
