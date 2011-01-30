uses crt;
type CMatrixType = array [1..5,1..5] of longint;
type CVectorType = array [0..5] of integer;
const LARGE = 32000;
const Max = 9;
label 1,2;

procedure Output(m:CMatrixType; p:integer);
var i,j:integer;
begin
  writeln;
  for i:=1 to p do
  begin
    for j:=1 to p do
    begin
      if (m[i][j] >=0 ) then write(' ');
      if (m[i][j] = LARGE) then write(0,' ') else write(m[i][j],' ');
    end;
    writeln;
  end;
end;

procedure Floyd(p:integer; C:CmatrixType; var T:CMatrixType; var H:CMatrixType);
var i,j,k,f:integer;
begin
  for i:=1 to p do
  for j:=1 to p do
  for k:=1 to p do
    if (C[j][k] > C[j][i]+C[i][k]) and (i<>j) and (i<>k) and (j<>k) then
              C[j][k] := C[j][i]+C[i][k];
  for i:=1 to p do
  for j:=1 to p do
    if (C[i][j]=LARGE) then
    begin
      writeln('Matrix is not linked');
      exit;
    end;
  writeln('Matrix is linked');
end;

var C,T,H:CMatrixType;
var i,j,p,s,d:integer;
var Tops:CVectorType;

function rnd:integer;
var i:integer;
begin
  i:=0;
  i:=random(4);
  if (i=0) then i:=LARGE;
  rnd:=i;
end;

procedure Dejikstra(C:CMatrixType; S:integer);
begin
end;

begin
  randomize;
1:
  write('Enter Tops Count: ');
  readln(p);
  if (p<4) and (p>5) then
  begin
    writeln('Error: Tops count must be 4 or 5.');
    goto 1;
  end;
  { Matrix Generation}
  for i:=2 to p do
      for j:=1 to i-1 do
      begin
        C[i][j] := rnd;
        C[j][i] :=C[i][j]; {Simmetric}
      end;

  for i:=1 to p do C[i][i] := 0;  {main diagonal}
  C[1][1]:=0;
  C[1][2]:=1;
  C[1][3]:=LARGE;
  C[1][4]:=LARGE;
  C[2][1]:=1;
  C[2][2]:=0;
  C[2][3]:=LARGE;
  C[2][4]:=LARGE;
  C[3][1]:=LARGE;
  C[3][2]:=LARGE;
  C[3][3]:=0;
  C[3][4]:=2;
  C[4][1]:=LARGE;
  C[4][2]:=LARGE;
  C[4][3]:=2;
  C[4][4]:=0;

  WriteLn('Price matrix:');
  Output(C,p);
  Floyd(p,C,T,H);
{  WriteLn('Enter Source top: ');
  readln(s);
{  Dejikstra(C,s);}

end.