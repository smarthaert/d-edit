{ 4) ��� ���ᨢ A. �뢥�� ���ᨢ B ⠪��,�� B[i,j]=2*A[i,j] }
var
  N,M : integer; { ������⢮ ��ப � �⮫�殢 }
  A,B : array [1..10,1..10] of integer; { ��㬥�� ���ᨢ� A � B }
  i,j : integer; { ��६���� 横�� }
begin
  { ���� ���ᨢ� A }
  Write('������ ������⢮ ��ப (1..10): '); Readln(N);
  Write('������ ������⢮ �⮫�殢 (1..10): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('������ A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { ���᫥��� ���ᨢ� B }
  for i:=1 to N do
    for j:=1 to M do
      B[i,j] := 2 * A[i,j];
  { �뢮� ���ᨢ� B }
  for i:=1 to N do begin
    for j:=1 to M do begin
      Write(B[i,j]:4);
    end;
    Writeln;
  end;
end.
