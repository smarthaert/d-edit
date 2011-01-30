uses crt;
const LARGE = 32000;

type CMatrixType = array [1..100,1..100] of longint;
type CStack = array [0..100] of integer;
type CEdge = record
       i:integer;
       j:integer;
       Cost:integer;
end;
var E:array [1..100] of CEdge;
    ECount:integer;
    C:CMatrixType;
    i,j,p,k,last:integer;
    T:array [1..100] of integer;
    TCount:integer;
    Temp:CEdge;

procedure Output;
var i,j:integer;
begin
  writeln('Adjective Matrix: ');;
  for i:=1 to p do
  begin
    for j:=1 to p do
    begin
      if (C[i][j] = LARGE) then write(0,' ') else Write(C[i][j],' ')
    end;
    writeln;
  end;

end;

procedure ReadMatrix;
var i,j,a,b,Cost,s,d:integer;
    f:text;
begin
  assign(f,'matrix.pas');
  reset(f);
  readln(f,p,s,d);
  for i:=1 to p do  for j:=1 to p do C[i][j]:=LARGE;
  ECount:=0;
  while (not eof(f)) do
  begin
    readln(f,a,b,cost);
    ECount:=ECount+1;
    E[ECount].i := a;
    E[ECount].j := b;
    E[ECount].cost := Cost;
  end;
  close(f);
end;

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

begin
  clrscr;
  ReadMatrix;
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
  for i:=1 to TCount do WriteLn(E[T[i]].i,'-',E[T[i]].j);
  WriteLn('Last edge: ',E[k].i,'-',E[k].j);
end.