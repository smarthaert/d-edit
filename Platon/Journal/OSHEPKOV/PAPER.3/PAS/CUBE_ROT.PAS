{°°°                                   }
{°°°  Œ­®£®¬¥p­ ï £¥®¬¥âp¨ï            }
{°°°  ‚¥pá¨ï 1 03.05.1997              }
{°°°  ‚¥pá¨ï 4  4.10.2000              }
{°°°                                   }

 Uses Graph,Crt,Dos;

 const
 DimSpace = 4;
 DimNods  = 16;
 DimLoops = 32;
 DimPlanes= 7;
 Digits:string = '123456789ABCDEFGHIJKLMNOPQRSTVUWXYZ';

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
 TMatr = array[1.. DimSpace] of TVect;

 var Points:TPoints;
 var Rotate:TMatr;

 Const Init_Tetra:TPoints =
 ((-1,-1,-1,-1),( 1,-1,-1,-1),
  (-1, 1,-1,-1),( 1, 1,-1,-1),
  (-1,-1, 1,-1),( 1,-1, 1,-1),
  (-1, 1, 1,-1),( 1, 1, 1,-1),
  (-1,-1,-1, 1),( 1,-1,-1, 1),
  (-1, 1,-1, 1),( 1, 1,-1, 1),
  (-1,-1, 1, 1),( 1,-1, 1, 1),
  (-1, 1, 1, 1),( 1, 1, 1, 1));

 Const Disp:TMatr =
 (( 1,-1,-1,-1),
  (-1, 1,-1,-1),
  (-1,-1, 1,-1),
  (-1,-1,-1, 1));

 var Sub_1:string;

 procedure Make_Rotate;
 var i:byte;
begin
 for i:=1 to 4 do
 Rotate[i]:=Init_Tetra[Pos(Sub_1[i],Digits)];
end;

 procedure Make_Disp;
 var k,j,i:byte; X:TMatr;
begin
 for i:=1 to 4 do
 for j:=1 to 4 do
 begin
  X[i,j]:=0;
  for k:=1 to 4 do
  X[i,j]:=X[i,j]+
  Rotate[k,i]*Disp[k,j]/4;
 end;
 Rotate:=X;
end;

 procedure Show_Rotate(Name:string);
 var i,j:byte; f:text;
begin
 Assign(f,Name); Rewrite(f);
 for i:=1 to DimSpace do
 begin
  for j:=1 to DimSpace do
  Write(f,'  ',Rotate[i,j]:3:0);
  Writeln(f);
 end;
 Close(f);
end;

{°°° Main }

 const FileReport='Report.bak';
 const Substitude:
 string='3748BFCG15269DAE,';

begin
 Writeln('°°°> ®áâp®¥­¨¥ ¯®¤áâ ­®¢ª¨ ¤«ï ¢p é¥­¨ï ªã¡ -4:');
 Points:=Init_Tetra;
 Writeln('°°°> „«ï ¯®¤áâ ­®¢ª¨: ',Substitude);
 Sub_1:=
 Substitude[2]+
 Substitude[3]+
 Substitude[5]+
 Substitude[9];
 Writeln('°°°> ¢ë¤¥«ïîâáï 4 ®¡p §  ¢¥pè¨­ 2359: ',Sub_1);
 Writeln('°°°> ¢ë¤¥«ïîâáï ¢ë¡®pª  ¢¥pè¨­ :');
 Make_Rotate;
 Show_Rotate('');
 Writeln('°°°> áâp®¨¬ ¢p é¥­¨¥ :');
 Make_Disp;
 Show_Rotate('');
 Show_Rotate(FileReport);

 readln;
end.
