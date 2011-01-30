type CStack = array [0..100] of integer;
type CEdge = record
       i:integer;
       j:integer;
       Cost:integer;
end;
type CMatrixType = array [1..5,1..5] of longint;
type CVectorType = array [0..5] of integer;
const LARGE = 32000;
const Max = 9;
var fIn1,fIn2,fIn3,fIn4,fIn5,fOut1,fOut2,fOut3,fOut4,fOut5:text;
var C:CMatrixType;
var i,p:integer;

procedure Push(var Stack:CStack; i:integer);
begin
  Stack[0]:=Stack[0]+1;
  Stack[Stack[0]]:=i;
end;

function Pop(var Stack:CStack):integer;
begin
  Pop:=Stack[Stack[0]];
  Stack[0]:=Stack[0]-1;
end;

function IsEmpty(Stack:CStack):boolean;
begin
  if (Stack[0]=0) then IsEmpty:=true else IsEmpty:=false;
end;

function IsPathPresent(a,b:integer):boolean;
var Stack:CStack;
    X:array [1..100] of integer;
    v,u,w,f,i:integer;
begin
  Stack[0]:=0;
  for i:=1 to p do X[i]:=0;
  v:=a;
  Push(Stack,v);
  X[v]:=1;
  repeat
    u:=Pop(Stack);
    Push(Stack,u);
    f:=0;
    for w:=1 to p do
    begin
      if (X[w]=0) and (C[v][w]<>LARGE) then
      begin
        Push(Stack,w);
        if (w=b) then
        begin
          IsPathPresent:=true;
          exit;
        end;
        X[w]:=1;
        f:=w;
      end;
    end;
    if (f<>0) then
    begin
      u:=f;
    end
    else
    begin
      u:=Pop(Stack);
    end;

  until IsEmpty(Stack);
  IsPathPresent:=False;
end;

function Floyd(p:integer; C:CmatrixType):boolean;
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
      Floyd:=false;
      exit;
    end;
    Floyd:=true;
end;

function rnd:integer;
var i:integer;
begin
  i:=0;
  i:=random(4);
  if (i=0) then i:=LARGE;
  rnd:=i;
end;

procedure Problem1;
var i,j:integer; f:text;
begin
  p:=Random(2)+4;
  for i:=2 to p do
      for j:=1 to i-1 do
      begin
        C[i][j] := rnd;
        C[j][i] :=C[i][j]; {Simmetric}
      end;
  for i:=1 to p do C[i][i] := 0;  {main diagonal}
  for i:=1 to p do
  for j:=1 to p do write(fIn1,C[i][j],';');
  writeln(fIn1);
  if (Floyd(p,C)) then WriteLn(fOut1,1) else WriteLn(fOut1,0);
end;

procedure Problem2(C:CMatrixType);
var i,j,k:integer;
begin
  for i:=1 to p do
  for j:=1 to p do write(fIn2,C[i][j],';');
  writeln(fIn2);
  for i:=1 to p do
  for j:=1 to p do
  for k:=1 to p do
    if (C[j][k] > C[j][i]+C[i][k]) then C[j][k] := C[j][i]+C[i][k];
  for i:=1 to p do
  for j:=1 to p do write(fOut2,C[i][j],';');
  writeln(fOut2);
end;

procedure problem3(C:CMatrixType);
label m;
var i,j,v,u,s,d,r:longint; T,H,X:CVectorType;
begin
  repeat
    s:=random(p)+1;
    d:=random(p)+1;
  until(s<>d);
  write(fIn3,p,';',s,';',d,';');
  for i:=1 to p do for j:=1 to p do write(fIn3,C[i][j],';');
  writeln(fIn3);
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
      T[u] := T[v] + C[v][u];
      H[u]:=v;
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
    write(fOut3,0);
    exit;
  end;
  if (v=d) then
  begin
    Write(fOut3,r,';');
    Write(fOut3,v,';');
    while (v<>s) do
    begin
      write(fOut3,H[v],';');
      v:=H[v];
    end;
    WriteLn(fOut3);
    exit;
  end;
  X[v]:=1;
  goto m;
end;

procedure Problem4(C:CMatrixType);
var v,k1,d,i,j,k,min:integer; A:array [1..20,0..20] of longint;
begin
  repeat
    d:=Random(p)+1;
  until d<>1;
  write(fIn4,p,';',d,';');
  for i:=1 to p do for j:=1 to p do write(fIn4,C[i][j],';');
  writeln(fIn4);
  for i:=1 to p do A[i][0] := LARGE;
  A[1][0] :=0;  { soglasno alg Forda-Belmana}
  for k:=0 to p-1 do
  begin
    for i:=2 to p do
    begin
      min:=LARGE;
      for j:=1 to p do if (A[j][k]+C[j][i] < min) then min:=A[j][k]+C[j][i];
      A[i][k+1]:=min;
    end;
  end;
  if (A[d][p-1] = LARGE) then
  begin
    writeln(fOut4,0);
    exit;
  end;
  for i:=1 to p do for j:=0 to p-1 do write(fOut4,A[i][j],';');
  writeln(fOut4);
  for i:=p-2 downto 1 do
    if (A[d][i] <> A[d][p-1]) then
      break;
  k1:=i+1;
  v:=d;
  write(fOut4,v,';');
  i:=k1;
  while (k1>0) do
  begin
    for j:=1 to p do
    begin
      if (A[j][k1-1] + C[j][v] = A[v][k1]) then
      begin
        Write(fOut4,j,';');
        v:=j;
        k1:=k1-1;
        break;
      end;
    end;
  end;
end;

procedure problem5;
var E:array [1..100] of CEdge;
    ECount:integer;
    i,j,k,last:integer;
    T:array [1..100] of integer;
    TCount:integer;
    Temp:CEdge;
begin
  ECount:=0;
  for i:=1 to p-1 do
  for j:=i+1 to p do
    if (C[i][j]<>LARGE) then
    begin
      ECount:=ECount+1;
      E[ECount].i:=i;
      E[ECount].j:=j;
      E[ECount].Cost:=C[i][j];
    end;
  write(fIn5,p,';');
  for i:=1 to p do for j:=1 to p do write(fIn5,C[i][j],';');
  writeln(fIn5);

  TCount:=0;
  for i:=1 to ECount-1 do
  for j:=i+1 to ECount do
    if (E[i].Cost > E[j].Cost) then
    begin
      Temp:=E[i];
      E[i]:=E[j];
      E[j]:=Temp;
    end;
  k:=1;
  for i:=1 to p-1 do
  begin
    while (IsPathPresent(E[k].i,E[k].j)) do
       k:=k+1;
    TCount:=TCount+1;
    T[TCount]:=k;
    C[E[k].i][E[k].j]:=E[k].Cost;
    C[E[k].j][E[k].i]:=E[k].Cost;
    Last:=k;
  end;
  for i:=1 to TCount do Write(fOut5,E[T[i]].i,';',E[T[i]].j,';');
  writeln(fOut5);

end;

begin
  assign(fIn1,'Data1.tex');
  rewrite(fIn1);
  assign(fIn2,'Data2.tex');
  rewrite(fIn2);
  assign(fIn3,'Data3.tex');
  rewrite(fIn3);
  assign(fIn4,'Data4.tex');
  rewrite(fIn4);
  assign(fIn5,'Data5.tex');
  rewrite(fIn5);
  assign(fOut1,'Answer1.tex');
  rewrite(fOut1);
  assign(fOut2,'Answer2.tex');
  rewrite(fOut2);
  assign(fOut3,'Answer3.tex');
  rewrite(fOut3);
  assign(fOut4,'Answer4.tex');
  rewrite(fOut4);
  assign(fOut5,'Answer5.tex');
  rewrite(fOut5);
  randomize;
  for i:=1 to 24 do
  begin
    Problem1;
    Problem2(C);
    Problem3(C);
    Problem4(c);
    Problem5;
  end;
  close(fIn1);
  close(fIn2);
  close(fIn3);
  close(fIn4);
  close(fIn5);
  close(fOut1);
  close(fOut2);
  close(fOut3);
  close(fOut4);
  close(fOut5);
end.