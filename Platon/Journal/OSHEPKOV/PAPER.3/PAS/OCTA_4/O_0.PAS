{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 4  4.10.2000              }
{░░░                                   }

 Uses Crt,Dos;

 Const DimSpace = 4;

 Type TVect = array[1..DimSpace] of real;

 Const Section:TVect = ( 0, 1, 1, 1);

{░░░ Комплекс: 4-Октаэдp }

 const
 Nods_Complex  = 8;
 Loops_Complex = 24;

 Const Complex:array[1..Nods_Complex] of TVect =
 (( 4, 0, 0, 0),(-4, 0, 0, 0),
  ( 0, 4, 0, 0),( 0,-4, 0, 0),
  ( 0, 0, 4, 0),( 0, 0,-4, 0),
  ( 0, 0, 0, 4),( 0, 0, 0,-4));

 Const Loops:array[1..Loops_Complex,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1, 7),( 1, 8),
 ( 2, 3),( 2, 4),( 2, 5),( 2, 6),( 2, 7),( 2, 8),
 ( 3, 5),( 3, 6),( 3, 7),( 3, 8),( 4, 5),( 7, 6),
 ( 4, 6),( 4, 7),( 4, 8),( 5, 7),( 5, 8),( 6, 8));

 procedure Write_Complex;
 var k,m:byte;
begin
 for k:=1 to DimSpace do
 begin
  for m:=1 to Nods_Complex do
  Write(Complex[m][k]:5:1);
  Writeln;
 end;
end;

{░░░ Сечение }

 Var Nods_Section:byte;
 Scals:array[1.. Nods_Complex] of real;
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
 for m:=1 to Nods_Complex do
 begin Scals[m]:=0;
  for k:=1 to DimSpace do
  Scals[m]:=Scals[m]+Complex[m][k]*Section[k];
  Write(Scals[m]:5:1);
  if Scals[m]=0 then
  begin
   Inc(Nods_Section);
   Points[Nods_Section]:=Complex[m];
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
 for k:=1 to Loops_Complex do
 begin
  if Is_Need(k) then
  begin
   Inc(Nods_Section);
   n1:=Loops[k][1];
   n2:=Loops[k][2];
   r:=Scals[n1]-Scals[n2];
   for m:=1 to DimSpace do
   if (Scals[n1]+Scals[n2]=0)
   then Points[Nods_Section][m]:=
   (Complex[n1][m]+Complex[n2][m])/2
   else Points[Nods_Section][m]:=
   (-Complex[n1][m]*Scals[n2]+Complex[n2][m]*Scals[n1])/r;
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
  for k:=1 to Loops_Complex do
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
 Write  (f,'▒▒▒ сечение Octa_4 оpтогональное ');
 Close(f);
 Write_Vect(Section,Name);
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
 Write_Vect(Section,'');
 Writeln;
 Writeln('░░░ Из веpшин 4-октаэдpа:');
 Write_Complex;
 Writeln('░░░ имеющих скаляpные пpоизведения:');
 Nods_Section:=0;
 Make_Scals;
 Writeln;
 Writeln('░░░ в секущее пpостpанство попали  ',Nods_Section,'  веpшин');
 Make_Section;
 Writeln('░░░ Остальные ',Nods_Section-Old,
         ' веpшин сечения получаются из pебеp 4-октаэдpа:');
 Write_Section;
 Save(FileSave);
 Writeln('░░░ Комплекс тепеpь в ',FileSave);
 Writeln('░░░ Для полного счастья нажми Enter ...');
 readln;
end.
