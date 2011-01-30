{  �ணࠬ��: "�८�ࠧ������ ������⢠ ����� �����" }
const
  MaxN = 30; { ���ᨬ��쭮� ������⢮ ����� }

type
  Line = record { ��ﬠ� ����� }
    A,B,C : real; { �����樥��� �ࠢ����� }
  end;

{ ���਩��� �����襭�� �ணࠬ�� }
procedure Fail( Reason : string );
begin
  writeln('Fail: ',Reason);
  halt(1);
end;

{ ��ࠫ����� �� ���� X � Y? }
function isParallel( X,Y : Line ):boolean;
begin
  isParallel := X.A * Y.B = X.B * Y.A;
end;

{ �����ﭨ� ����� ���� ��ࠫ����묨 ���묨 }
function Distance( X,Y : Line ):real;
var k : real;
begin
  { �᫮��� �� �室� � ����ணࠬ�� }
  if not isParallel(X,Y) then
    Fail('���� X � Y �� ��ࠫ�����!');
  { ����塞 �⭮襭�� �����樥�⮢ ����� }
  if Y.A <> 0 then
    k := X.A / Y.A
  else
    k := X.B / Y.B;
  { �ᯮ��㥬 ���� ���᫥��� ����ﭨ� }
  Distance := abs(X.C - Y.C*k) / sqrt(X.A*X.A + X.B*X.B);
end;

var
  N : integer; { ������⢮ ����� }
  L : array [1..MaxN] of Line; { ���ᨢ ����� }
  i, j : integer;
  done : boolean;
  R : real; { �������� ����ﭨ� ����� ���묨 }
begin
  writeln(' �८�ࠧ������ ������⢠ ����� ����� ');
  writeln('=======================================');
  writeln(' ����� ������ �ࠢ����ﬨ ����: Ax+By+C=0');
  writeln;
  writeln('1. ���� ������⢠ M ��室��� �����');
  write('������⢮ ����� N: '); readln(N);
  for i:=1 to N do begin
    repeat
      writeln('���� ��אַ� ',i,' �� ',N);
      write('A = '); readln(L[i].A);
      write('B = '); readln(L[i].B);
      write('C = '); readln(L[i].C);
      done := ( L[i].A<>0 ) or ( L[i].B<>0 );
      if not done then
        writeln('A � B �� ����� ���� �����६���� ࠢ�� 0!!');
    until done;
  end;
  writeln('2. �롨ࠥ� �� ���� ��ࠫ������ �����');
  for i:=1 to N-1 do
    for j:=i+1 to N do
      if isParallel(L[i],L[j]) then
        writeln(' ',i,' � ',j,' ��ࠫ�����! �����ﭨ� = ',
           Distance(L[i],L[j]):0:2);
  writeln;
  writeln('3. �뢮��� ⮫쪮 ����, ����ﭨ� ����� ����묨 ����� ���������.');
  write('�������� ����ﭨ�: '); readln(R);
  for i:=1 to N-1 do
    for j:=i+1 to N do
      if isParallel(L[i],L[j]) then
        if Distance(L[i],L[j]) < R then
          writeln(' ��ﬠ� ',i,' �室�� � P. �����ﭨ� �� ',j,' = ',
           Distance(L[i],L[j]):0:2);
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
