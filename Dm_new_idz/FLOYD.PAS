const LARGE=32000;
type CMatrixType = array [1..100,1..100] of longint;
var C:CMatrixType;
    i,j,k,p,q:integer;
    s,d:integer;
procedure ReadMatrix;
var i,j,a,b,Cost:integer;
    f:text;
begin
  assign(f,'matrix.pas');
  reset(f);
  readln(f,p,s,d);
  for i:=1 to p do
  for j:=1 to p do C[i][j]:=LARGE;
  while (not eof(f)) do
  begin
    readln(f,a,b,cost);
    C[a][b]:=cost;
    c[b][a]:=cost;
  end;
  close(f);
end;
procedure Output;
var i,j:integer;
begin
  writeln;
  for i:=1 to p do
  begin
    for j:=1 to p do
    begin
      if (C[i][j] = LARGE) then write(0,' ') else Write(C[i][j],' ')
    end;
    writeln;
  end;

end;

begin
  ReadMatrix;
  Output;
  q:=0;
  for i:=1 to p do
  for j:=1 to p do
  for k:=1 to p do
    if (C[j][k] > C[j][i]+C[i][k]) and (i<>j) and (i<>k) and (j<>k) then
    begin
              C[j][k] := C[j][i]+C[i][k];
              q:=q+1;
    end;
  Output;
  WriteLn('Length: ',C[s][d]);
  writeln('Labels: ',q);
end.