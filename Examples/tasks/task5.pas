{ 5)�뢥�� ����� ����� � ��㬥୮�� ���ᨢ� }
const Size = 10;
var
  N,M : integer; { ������⢮ ��ப � �⮫�殢 }
  A : array [1..Size,1..Size] of integer; { ��㬥�� ���ᨢ A }
  i,j : integer; { ��६���� 横�� }
begin
  { ���� ���ᨢ� A }
  Write('������ ������⢮ ��ப (1..',Size,'): '); Readln(N);
  Write('������ ������⢮ �⮫�殢 (1..',Size,'): '); Readln(M);
  for i:=1 to N do
    for j:=1 to M do begin
      Write('������ A[',i,',',j,']: '); Readln(A[i,j]);
    end;
  { �뢮� ����஢ ����� ����⮢ }
  for i:=1 to N do
    for j:=1 to M do
      if A[i,j] mod 2 = 0 then
        Writeln('���� �����: A[',i,',',j,'] = ',A[i,j]);
end.
