{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 4  4.10.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 const
 DimSpace = 4;
 DimNods  = 8;
 DimLoops = 32;
 DimPlanes= 7;

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

{°°° Data }

 Type
 TVect = array[1.. DimSpace] of real;
 TPoints = array[1.. DimNods] of TVect;

 var Points:TPoints;

 Const Init_Tetra:TPoints =
(( 1, 0, 0, 0),(-1, 0, 0, 0),
 ( 0, 1, 0, 0),( 0,-1, 0, 0),
 ( 0, 0, 1, 0),( 0, 0,-1, 0),
 ( 0, 0, 0, 1),( 0, 0, 0,-1));

 Const Rotate:array[1..4,1..4] of real =
 ((-0, 0,-1,-0),
  ( 0,-0, 0, 1),
  (-0, 1, 0, 0),
  ( 1, 0, 0,-0));

{°°° Vect }

 Const Center:TVect=( 0,-0, 0, 0);

 function Namber(X:TVect):byte;
 var m,n,i:byte;
begin
 n:=0; m:=3;
 for i:=1 to DimSpace do
 begin
  n:=n+Round((m-X[i])*X[i]*X[i]/2);
  m:=m+4;
 end;
 Namber:=n;
end;

 Const
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

 function Substitude:string;
 var i:byte; S:string;
begin S:='';
 for i:=1 to 8 do
 S:=S+Digits[Namber(Points[i])];
 Substitude:=S;
end;

 procedure Vect_Rotate(var X:TVect);
 var i,j:byte; Y:TVect;
begin
 Y:=Center;
 for i:=1 to DimSpace do
 for j:=1 to DimSpace do
 Y[i]:=Y[i]+Rotate[i,j]*X[j];
 X:=Y;
end;

 procedure Show_Rotate;
 var i,j:byte;
begin
 for i:=1 to DimSpace do
 begin
  for j:=1 to DimSpace do
  Write('  ',Rotate[i,j]:5:2);
  Writeln;
 end;
end;

 procedure Comp_Rotate;
 var i:byte;
begin
 for i:=1 to DimNods do
 Vect_Rotate(Points[i]);
end;

 const
 FileReport='Report.bak';

{°°° Main }
begin
 Writeln('°°°> ®áâp®¥­¨¥ ¯®¤áâ ­®¢ª¨ ¤«ï ¢p é¥­¨ï ®ªâ í¤p  -4:');
 Points:=Init_Tetra;
 Show_Rotate;
 Writeln('°°°> ',Substitude);
 Comp_Rotate;
 Writeln('°°°> ',Substitude);

 if not FileExists(FileReport)
 then InitText(FileReport);
 AppendText(FileReport,Substitude);

 readln;
end.
