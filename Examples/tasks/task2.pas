{ 2) ���� �ந�������� ����⮢ ������୮�� ���ᨢ� }
const MaxSize = 100; { ���ᨬ���� ࠧ��� ���ᨢ� }
var
  N : integer; { ������⢮ ����⮢ ���ᨢ� }
  A : array [1..MaxSize] of integer; { �������� ���ᨢ }
  i : integer; { ��६����� 横�� }
  P : integer; { �ந�������� }
begin
  { ���� ���ᨢ� }
  Write('������ ������⢮ ����⮢: '); Readln(N);
  for i:=1 to N do begin
    Write('������ A[',i,']: '); Readln(A[i]);
  end;
  { ���᫥��� �ந�������� ��� ����⮢ ���ᨢ� }
  P := 1;
  for i:=1 to N do
    P := P * A[i];
  { �뢮� �⢥� }
  writeln('�ந��������: ',P);
end.
