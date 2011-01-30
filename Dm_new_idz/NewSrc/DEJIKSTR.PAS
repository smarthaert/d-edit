
const LARGE=32000;
type CMatrixType = array [1..100,1..100] of longint;
label m;
var C:CMatrixType;
    s,d,p,last`,v,u:integer;
    r:real;
    q:integer;
    T:array [1..100] of real;
    H:array [1..100] of integer;
    X:array [1..100] of integer;

procedure ReadMatrix;
var a,b,cost,i,j:integer;
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
  for v:=1 to p do
  begin
    T[v]:=LARGE;
    X[v] :=0;
  end;
  H[s]:=0;
  T[s]:=0;
  X[s]:=1;
  v:=s;
m:
  for u:=1 to p do
  begin
    if (X[u]=0) and (T[u] > T[v] + C[v][u]) then
    begin
      T[u] := T[v] + C[v][u];  q:=q+1;
      H[u]:=v;                 q:=q+1;
      Last:=u;
    end;
  end;
  r:=LARGE;
  v:=0;
  for u:=1 to p do
  begin
    if (X[u]=0) and (T[u]<r) then
    begin
      v:=u;
      r:=T[u];
    end;
  end;
  if (v=0) then
  begin
    WriteLn('No solution!');
    exit;
  end;
  if (v=d) then
  begin
    WriteLn('The shortest length is ',r:0:0);
    Write('Path: ',v,' ');
    while (v<>s) do
    begin
      write(H[v],' ');
      v:=H[v];
    end;
    writeln('Last top:',Last);
    writeLn('Labels: ',q);
    exit;
  end;
  X[v]:=1;
  goto m;
end.


