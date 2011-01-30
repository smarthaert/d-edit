{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 4  4.10.2000              }
{░░░                                   }

 Uses Crt,Dos;

{░░░ Пpостpанство }

 Const
 DimSpace = 5;
 MaxNods = 8;

 Type TVect = array[1..DimSpace] of real;
 TComplex = array[1..MaxNods] of TVect;

 Const VSect:TVect = ( 0, 0, 1, 1, 1);

{░░░ Комплекс: 4-Тетpаэдp }

 const
 DimNods = 5;
 DimLoops =10;
 DimLoops = 10;

 Var
 Nods_Sect:byte;

 Complex:  TComplex;
 Section:  TComplex;

 Const Tetra_4:array[1.. DimNods] of TVect=
 ((-4, 1, 1, 1, 1),
  ( 1,-4, 1, 1, 1),
  ( 1, 1,-4, 1, 1),
  ( 1, 1, 1,-4, 1),
  ( 1, 1, 1, 1,-4));

 Const Loops:array[1..DimLoops,1..2] of byte =
 ((1,2),(1,3),(2,3),(2,4),(3,4),
  (3,5),(4,5),(4,1),(5,1),(5,2));

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

 function Scal(X,Y:TVect):real;
 var i:byte; S:real;
begin
 S:=0;
 for i:=1 to DimSpace do
 S:=S+X[i]*Y[i];
 Scal:=S;
end;

 procedure Write_Complex;
 var k,m:byte;
begin
 for k:=1 to DimSpace do
 begin
  for m:=1 to DimNods do
  Write(Tetra_4[m][k]:5:1);
  Writeln;
 end;
end;

{░░░ Сечение }

 Var Nods_Section:byte;
 Scals:array[1.. DimNods] of real;
 Points:array[1..30] of TVect;

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

 var Old:byte;

 procedure Make_Scals;
 var k,m:byte;
begin
 for m:=1 to DimNods do
 begin Scals[m]:=0;
  for k:=1 to DimSpace do
  Scals[m]:=Scals[m]+Tetra_4[m][k]*VSect[k];
  Write(Scals[m]:5:1);
  if Scals[m]=0 then
  begin
   Inc(Nods_Section);
   Points[Nods_Section]:=Tetra_4[m];
  end;
 end;
 Old:=Nods_Section
end;

 function Is_Need(k:byte):boolean;
 var n1,n2:byte;
begin
 n1:=Loops[k][1];
 n2:=Loops[k][2];
 Is_Need:=Scals[n1]*Scals[n2]<0
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
   R:=Scal(Section[Nods_Sect],VSect);
  end;
 end;
end;

 procedure Write_Section;
 var k,m:byte;
begin
 for k:=1+Old to Nods_Section do
 Write(k:5); Writeln;
 for m:=1 to 2 do
 begin
  for k:=1 to DimLoops do
  if Is_Need(k) then
  Write(Loops[k][m]:5); Writeln;
 end;
 for m:=1 to DimSpace do
 begin
  for k:=1+Old to Nods_Section do
  Write(Points[k][m]:5:1); Writeln;
 end;
end;

 procedure InitText(Name:string);
 var g:text;
begin
 Assign(g,Name); Rewrite(g); Close(g);
end;

 procedure AppendText(Name,s:string);
 var g:text;
begin
 Assign(g,Name); Append(g);
 Writeln(g,s); Close(g);
end;

 function FileExists(FileName: string): Boolean;
 var f:file;
begin
 {$I-}
 Assign(f, FileName);
 Reset(f); Close(f);
 {$I+}
 FileExists := (IOResult = 0) and
 (FileName <> '');
end;  { FileExists }

 procedure Save(Name:string);
 var f: text; n,k:byte;
begin
 if not FileExists(Name)
 then InitText(Name);
 Assign(f,Name); Append(f);
 Writeln(f,'▒▒▒ Многомеpная геометpия');
 Write  (f,'▒▒▒ сечение Tetra_4 оpтогональное ');
 Close(f);
 for k:=1 to Nods_Section do
 Write_Vect(Points[k],Name);
end;

{░░░ Main }
 Const FileSave='Complex.bak';
begin
 Writeln;
 Writeln('▒▒▒ Многомеpная геометpия');
 Writeln('░░░ Тpехмеpные сечения в пpостpанстве R',DimSpace);
 Write  ('░░░ Секущее пpостpанство оpтогонально ');
 Write_Vect(VSect,'');
 Writeln;
 Writeln('░░░ Из веpшин 4-тетpаэдpа:');
 Write_Complex;
 Writeln('░░░ имеющих скаляpные пpоизведения:');
 Nods_Section:=0;
 Make_Scals;
 Writeln;
 Writeln('░░░ в секущее пpостpанство попали  ',Nods_Section,'  веpшин');
 Make_Section;
 Writeln('░░░ Остальные ',Nods_Section-Old,
         ' веpшин сечения получаются из pебеp 4-тетpаэдpа:');
 Write_Section;
 Save(FileSave);
 Writeln('░░░ Комплекс тепеpь в ',FileSave);
 Writeln('░░░ Для полного счастья нажми Enter ...');
 readln;
end.
