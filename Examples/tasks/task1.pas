{ 1) ���� �㬬� ����⥫��� � ������୮�� ���ᨢ� }
const MaxSize = 100; { ���ᨬ���� ࠧ��� ���ᨢ� }
var
  N : integer; { ������⢮ ����⮢ ���ᨢ� }
  A : array [1..MaxSize] of integer; { �������� ���ᨢ }
  i : integer; { ��६����� 横�� }
  sum : integer; { �㬬� }
begin
  { ���� ���ᨢ� }
  Write('������ ������⢮ ����⮢: '); Readln(N);
  for i:=1 to N do begin
    Write('������ A[',i,']: ');
    Readln(A[i]);
  end;
  { ���᫥��� �㬬� }
  sum := 0;
  for i:=1 to N do
  if A[i] < 0 then
    sum := sum + A[i];
  { �뢮� �⢥� }
  writeln('�㬬�: ',sum);
end.