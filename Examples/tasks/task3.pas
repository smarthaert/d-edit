{ 3) ��������� 2� ���� ���ᨢ ⠪ �⮡� �� ������� ��������� �뫨 0 }
var
  N,M : integer; { ������⢮ ��ப � �⮫�殢 }
  min : integer; { ������ �� ������⢠ ��ப � �⮫�殢 }
  A : array [1..10,1..10] of integer; { ��㬥�� ���ᨢ }
  i,j : integer; { ��६���� 横�� }
begin
  Writeln('���� ���ᨢ� A');
  Write('������ ������⢮ ��ப (1..10): '); Readln(N);
  Write('������ ������⢮ �⮫�殢 (1..10): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('������ A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { ������塞 ������� ��������� 0-�� }
  if N < M then
    min := N
  else
    min := M;
  for i:=1 to min do
    A[i,i] := 0;
  { �뢮� ��⮢��� ���ᨢ� }
  Writeln('���ᨢ A � 0-�� �� ������� ���������:');
  for i:=1 to N do begin
    for j:=1 to M do begin
      Write(A[i,j]:4);
    end;
    Writeln;
  end;
end.
