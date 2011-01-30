uses crt;
const LARGE=32000;
type CMatrixType = array [1..20,0..20] of longint;
var p,s,d,q:integer;
    C:CMatrixType;
    A:CMatrixType;
    v,i,j,k,min,k1:longint;

procedure Output(C:CMatrixType; q:integer);
var i,j:integer;
begin
  writeln;
  for i:=1 to p do
  begin
    for j:=1-q to p-q do
    begin
      if (C[i][j] = LARGE) then write('--',' ') else if (C[i][j] <10) then write(' ',C[i][j],' ') else Write(C[i][j],' ')
    end;
    writeln;
  end;
end;

procedure ReadMatrix;
var i,j:integer;
    f:text;
    a,b,cost:integer;
begin
  assign(f,'Forddata.pas');
  reset(f);
  readln(f,p,s,d);
  for i:=1 to p do
  for j:=1 to p do C[i][j]:=LARGE;
  while (not eof(f)) do
  begin
    readln(f,a,b,cost);
    C[a][b]:=cost;
  end;
  close(f);
end;

begin
  clrscr;
  ReadMatrix;
  for i:=1 to p do A[i][0] := LARGE;
  A[1][0] :=0;  { soglasno alg Forda-Belmana}
  q:=q+p;
  for k:=0 to p-1 do
  begin
    for i:=2 to p do
    begin
      min:=LARGE;
      for j:=1 to p do
         if (A[j][k]+C[j][i] < min) then
         begin
            min:=A[j][k]+C[j][i];
            q:=q+1;
         end;
      A[i][k+1]:=min;
      q:=q+1;
    end;
  end;
  if (A[d][p-1] = LARGE) then
  begin
    writeln('No Solution!');
    exit;
  end;
  Output(A,1);
  for i:=p-2 downto 1 do
    if (A[d][i] <> A[d][p-1]) then
      break;
  k1:=i+1;
  v:=d;
  Output(C,0);
  writeln('path: ');
  writeln(v);
  i:=k1;
  while (k1>0) do
  begin
    for j:=1 to p do
    begin
      if (A[j][k1-1] + C[j][v] = A[v][k1]) then
      begin
        WriteLn(j);
        v:=j;
        k1:=k1-1;
        break;
      end;
    end;
  end;
  writeln('Labels: ',q);
end.