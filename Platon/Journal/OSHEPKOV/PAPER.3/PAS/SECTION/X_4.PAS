{░░░                                   }
{░░░  Многомеpная геометpия            }
{░░░  Веpсия 1 03.05.1997              }
{░░░  Веpсия 4  4.10.2000              }
{░░░                                   }

 Uses Crt,Dos;

 Const DimSpace = 4;

 Type TVect = array[1..DimSpace] of real;

 Const Section:TVect = ( 1, 1, 0,-1);

{░░░ Комплекс: 4-Октаэдp }

 const
 Nods_Complex  = 24;
 Loops_Complex = 96;

 Const Complex:array[1..Nods_Complex] of TVect =
 (( 1, 1, 0, 0),( 1,-1, 0, 0),
  ( 1, 0, 1, 0),( 1, 0,-1, 0),
  ( 1, 0, 0, 1),( 1, 0, 0,-1),
  (-1, 1, 0, 0),(-1,-1, 0, 0),
  (-1, 0, 1, 0),(-1, 0,-1, 0),
  (-1, 0, 0, 1),(-1, 0, 0,-1),
  ( 0, 1, 1, 0),( 0, 1,-1, 0),
  ( 0, 1, 0, 1),( 0, 1, 0,-1),
  ( 0, 0, 1, 1),( 0, 0, 1,-1),
  ( 0,-1, 1, 0),( 0,-1,-1, 0),
  ( 0,-1, 0, 1),( 0,-1, 0,-1),
  ( 0, 0,-1, 1),( 0, 0,-1,-1));

 Const Loops:array[1..Loops_Complex,1..2] of byte =
(( 1, 3),( 1, 4),( 1, 5),( 1, 6),( 1,13),( 1,14),
 ( 1,15),( 1,16),( 2, 3),( 2, 4),( 2, 5),( 2, 6),
 ( 2,19),( 2,20),( 2,21),( 2,22),( 3, 5),( 3, 6),
 ( 3,13),( 3,17),( 3,18),( 3,19),( 4, 5),( 4, 6),
 ( 4,14),( 4,20),( 4,23),( 4,24),( 5,15),( 5,17),
 ( 5,21),( 5,23),( 6,16),( 6,18),( 6,22),( 6,24),
 ( 7, 9),( 7,10),( 7,11),( 7,12),( 7,13),( 7,14),
 ( 7,15),( 7,16),( 8, 9),( 8,10),( 8,11),( 8,12),
 ( 8,19),( 8,20),( 8,21),( 8,22),( 9,11),( 9,12),
 ( 9,13),( 9,17),( 9,18),( 9,19),(10,11),(10,12),
 (10,14),(10,20),(10,23),(10,24),(11,15),(11,17),
 (11,21),(11,23),(12,16),(12,18),(12,22),(12,24),
 (13,15),(13,16),(13,17),(13,18),(14,15),(14,16),
 (14,23),(14,24),(15,17),(15,23),(16,18),(16,24),
 (17,19),(17,21),(18,19),(18,22),(19,21),(19,22),
 (20,21),(20,22),(20,23),(20,24),(21,23),(22,24));

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
 Write  (f,'▒▒▒ сечение X_4 оpтогональное ');
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
