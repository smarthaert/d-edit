uses CRT;

function Center( S:string; Width:integer ):string;
var Res:string;
i,Spaces:integer;
begin Res:=S;
Spaces:=(Width-Length(S))div 2;
for i:=1 to Spaces      do
Res   :=    ' ' +     Res;
while Length(Res)<Width do
Res:=Res+' ';Center:=Res;
end;
{Функция для перевода}
function IntToStr( I : Integer ):string;
var Res : string;
begin
Str(I,Res);
IntToStr := Res;
end; const
ScreenSize=80;var
ArrayName :
array [1995..
2010
] of
string   ;
i,S,E,ColumnSize,Columns,Color : integer;
begin
  ArrayName[1995] := 'Windows 95';
  ArrayName[1999] := 'Windows ME';
  ArrayName[2000] := 'Windows 2000';
  ArrayName[2002] := 'Windows XP';
  ArrayName[2008] := 'Windows Vista';
  ArrayName[2009] := 'Windows 7';

  for i:=low(ArrayName) to high(ArrayName) do
    writeln(i,' ',ArrayName[i]);

  ColumnSize := 15;
  Columns := ScreenSize div ColumnSize;
  S := low(ArrayName);
  E := S + Columns - 1;
  Color := 1;
  while S < high(ArrayName) do begin
    for i:=S to E do begin
      TextColor(Color);
      write(Center(IntToStr(i),ColumnSize));
      Color := Color + 1;
      if Color > 15 then Color := 1;
    end;
    WriteLn;
    for i:=S to E do begin
      TextColor(Color);
      write(Center(ArrayName[i],ColumnSize));
      if(ArrayName[i]<>'')then Color:=Color+1;
      if Color > 15 then Color := 1;
    end;
    WriteLn;
    S := E + 1;
    E := S + Columns-1;
  end;
  TextColor(7);
  readln;
end.
