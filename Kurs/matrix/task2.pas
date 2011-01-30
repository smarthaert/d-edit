{  �ணࠬ��: "�८�ࠧ������ ��אַ㣮�쭮� ������" }
const
  MaxM = 30; { ���ᨬ��쭮� ������⢮ ��ப }
  MaxN = 30; { ���ᨬ��쭮� ������⢮ �⮫�殢 }

type
  Matrix = array [1..MaxM,1..MaxN] of integer;

procedure ShowMatrix( M : Matrix; rows,cols : integer );
var i,j : integer;
begin
  for i:=1 to rows do begin
    for j:=1 to cols do
      write(M[i,j]:5); { ��ਭ� �⮫�� �� �뢮�� �� �࠭ - 5 ᨬ����� }
    writeln;
  end;
end;

var
  B, C : Matrix;
  m, n, k, i, j, s : integer;
  contain : boolean; { ����ন� �� �⮫��� B ࠢ�� ������ }
  V : array [1..MaxM] of integer; { ����� 楫�� �ᥫ }
  sum : integer; { �㬬� �ᥫ � ��ப� � ����� C }
begin
  writeln(' �८�ࠧ������ ��אַ㣮�쭮� ������ ');
  writeln('======================================');
  writeln;
  writeln('1. ���� ��室��� ������ B');
  write('������⢮ ��ப m: '); readln(m);
  write('������⢮ �⮫�殢 n: '); readln(n);
  for i:=1 to m do
    for j:=1 to n do begin
      write('B[',i,',',j,']: '); readln(B[i,j]);
    end;
  ShowMatrix(B,m,n);
  writeln('2. �஡����� � 横�� �� �ᥬ �⮫�栬 ������ B � �஢��塞,');
  writeln(' ᮤ�ন� �� �⮫��� ࠢ�� ������.');
  writeln('�᫨ �� ᮤ�ন�, ������塞 ��� �⮫��� � ����� �.');
  k:=0; { ������⢮ �⮫�殢 � ����� C ࠢ�� 0 }
  for s:=1 to n do begin { 横� �� �ᥬ �⮫�栬 B }
    contain := false;
    for i:=1 to m-1 do { �ࠢ������ ����୮ ������ �⮫�� s }
      for j:=i+1 to m do
        if B[i,s] = B[j,s] then begin { �᫨ ��� ����� �⮫�� s ᮢ���� }
          contain := true;
          break;
        end;
    if not contain then begin { ������塞 ��� �⮫��� � ����� � }
      k := k + 1;
      for i:=1 to m do
        C[i,k] := B[i,s];
    end;
  end;
  writeln('3. �뢮��� �� �࠭ ������ �');
  ShowMatrix(C,m,k);
  writeln('4. ������ � 横�� ����� 楫�� �ᥫ V ࠧ��� m=',m,'.');
  writeln('����� ⮫쪮 V[i] ࠢ�� 0 ��� ���');
  for i:=1 to m do begin
    write('V[',i,']: '); readln(V[i]);
  end;
  writeln('5. �஡����� � 横�� �� ��ப�� ������ �, �᫨ V[i]<>0,');
  writeln(' �㬬��㥬 ������ � ��ப� � �뢮��� �㬬� �� �࠭.');
  for i:=1 to m do { i - ����� ��ப� ������ C }
    if V[i]<>0 then begin { �᫨ V[i]<>0 => �㬬��㥬 }
      sum := 0;
      for j:=1 to k do
        sum := sum + C[i,j];
      writeln('�㬬� ',i,'-�� ��ப� ������ C = ',sum);
    end;
  writeln;
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
