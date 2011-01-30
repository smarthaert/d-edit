{ �ணࠬ�� "�८�ࠧ������ ��אַ㣮�쭮� ������" }
const
  MaxM = 30; { ���ᨬ��쭮� ������⢮ ��ப }
  MaxN = 30; { ���ᨬ��쭮� ������⢮ �⮫�殢 }

type
  Matrix = array [1..MaxM,1..MaxN] of integer;

{ �뢮� ������ �� �࠭. }
{ M - ���ᨢ, rows - ������⢮ ��ப, cols - ������⢮ �⮫�殢 }
procedure ShowMatrix( M : Matrix; rows,cols : integer );
var i,j : integer;
begin
  for i:=1 to rows do begin
    for j:=1 to cols do
      write(M[i,j]:5); { ��ਭ� �⮫�� �� �뢮�� ������ �� �࠭ - 5 ᨬ����� }
    writeln;
  end;
end;

{ �������� ���祭�ﬨ ��� �᫮��� ����� � ������� �६����� ��६����� }
procedure Swap( var A,B:integer );
var temp : integer;
begin
  temp := A;
  A := B;
  B := temp;
end;

var
  B, C : Matrix; { ������ }
  m, n : integer; { ������� ����� B � C }

{ ���� ������ B }
procedure InputB;
var i, j : integer;
begin
  writeln('1. ���� ��室��� ������ B');
  write('������⢮ ��ப m: '); readln(m);
  write('������⢮ �⮫�殢 n: '); readln(n);
  for i:=1 to m do
    for j:=1 to n do begin
      write('B[',i,',',j,']: '); readln(B[i,j]);
    end;
  writeln('��室��� ����� B:');
  ShowMatrix(B,m,n);
end;

var
  i, j, s, line, sum : integer;
  Zeros : integer; { ������⢮ �㫥� � ��ப� }
  allSum : integer; { �㬬� �ᥫ � ��ப� � ����� C }
  sums : array [1..MaxN] of integer; { �㬬� �� �⮫�栬 � }
begin
  writeln(' �८�ࠧ������ ��אַ㣮�쭮� ������ ');
  writeln('======================================');
  writeln;
  InputB;

  writeln('2. �஡����� �� �ᥬ �⮫�栬 ������ � ��⠥� �㬬� �� ����⮢');
  C := B; { �����㥬 ������ B � C }
  for s:=1 to n do begin { 横� �� �ᥬ �⮫�栬 B }
    sums[s] := 0; { �㬬� ����⮢ �⮫�� s }
    for line:=1 to m do { �㬬��㥬 ������ �⮫�� s }
      sums[s] := sums[s] + C[line,s];
    sums[s] := abs(sums[s]); { ��� �㦥� ����� �㬬� }
    writeln('����� �㬬� ����⮢ ',s,'-��� �⮫�� - ',sums[s]);
  end;
  writeln('�����㥬 ��⮤�� "����쪠" �⮫��� � �� ����� �㬬� �⮫�殢');
  for i:=1 to n do
    for j:=i+1 to n do
      if sums[i] > sums[j] then begin
        Swap(sums[i],sums[j]); { ���塞 ���⠬� �㬬� }
        for line:=1 to m do { ���塞 ���⠬� �⮫��� }
          Swap(C[line,i],C[line,j]);
      end;

  writeln('3. �뢮��� �� �࠭ ������ �');
  ShowMatrix(C,m,n);

  writeln('�롨ࠥ� � ����� C ��ப� � ��묨 ����ࠬ�.');
  writeln('�㬬��㥬 ������ � �஢��塞, ���� �� � ��ப� ��� �� ���� 0,');
  writeln('�᫨ ����, ������塞 � ��饩 �㬬�.');
  allSum := 0; { ���� �㬬� ࠢ�� 0 }
  for line:=1 to m do { �஡����� �� �ᥬ ��ப��� ������ C }
    if line mod 2 = 0 then begin { �᫨ � ��ப� ���� ����� }
      sum := 0; { �㬬� � ��ப� ࠢ�� 0 }
      Zeros := 0; { ������⢮ �㫥� � ��ப� }
      for s:=1 to n do begin
        sum := sum + C[line,s]; { ��⠥� �㬬� }
        if C[line,s] = 0 then { ��⠥� ������⢮ �㫥� � ��ப� }
          Zeros := Zeros + 1;
      end;
      if Zeros >= 1 then { �᫨ �㫥� >= 1, ������塞 � ��饩 �㬬� }
        allSum := allSum + sum;
      writeln(line,'-�� ��ப�, �㬬� ',sum,' ���-�� �㫥� - ',Zeros);
    end;
  writeln('���� �㬬� ����⮢ ��ப � ��묨 ����ࠬ�, ᮤ�ঠ�� ��� �� ���� �㫥��� �����');
  writeln(allSum);

  writeln;
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
