{ 13. ������� ��楤��� ��� �㭪��,
  � ������ ��।����� ���ᨢ �� 128 STRING,
  ᮤ�ঠ騩 ��ப� �� ᫮�, ࠧ�������� �஡�����
  � STRING' �, ᮤ�ঠ騥 �����塞��
  � �������饥 ᫮��,
  � ���������� ���ᨢ � ��������묨 ᫮����.
  (�����, �� ��७��� ����������) }

const Num = 13; { 128 }

type
  Arr = array [1..Num] of String;

{ A - ���ᨢ ��ப (�室�� �����)
  B - ��室��� ���ᨢ ��ப
  FromS - �����塞�� ᫮��
  ToS - �������饥 ᫮�� }
procedure Change( A:Arr; var B:Arr; FromS,ToS : string );
var i,P : integer;
begin
  { �����㥬 ��室�� ���ᨢ � ��室��� }
  B := A;
  { �஡����� � 横�� �� �ᥬ ��ப�� ���ᨢ� }
  for i:=1 to Num do
    while true do begin
      { �饬 �����ப� FromS � ��।��� ��ப� ���ᨢ� B }
      P := Pos(FromS,B[i]);
      if P=0 then break; { �᫨ ��ப� FromS �� ������� =>
         ��室�� �� 横�� while }
      { ��ப� FromS �������! }
      { ����塞 ��ப� FromS �� ��ப� B[i] }
      Delete(B[i],P,Length(FromS));
      { ��⠢�塞 �� �� �� ���� ToS }
      Insert(ToS,B[i],P);
    end;
end;

procedure ShowArray( A : Arr );
var i : integer;
begin
  for i:=1 to Num do
    writeln(A[i]);
  writeln;
end;

const
  ExampleData : Arr = (
    '1. ������� �㭪��, ������� � ����⢥ �室����',
    '��ࠬ��� �������� ���ᨢ 楫�� �ᥫ ������ 10,',
    ' � ���������� ���ᨬ��쭮� ���祭�� �᫠ � ���ᨢ�.',
    '2. ������� �㭪��, ������� � ����⢥ �室���� ��ࠬ���',
    ' ��㬥�� ���ᨢ 楫�� �ᥫ  ࠧ��஬ 10*10, � ����������',
    '�������쭮� ���祭�� �᫠ � ���ᨢ�.',
    '3. ������� �㭪��, ������� � ����⢥ �室���� ��ࠬ���',
    ' ��㬥�� ���ᨢ 楫�� �ᥫ  ࠧ��஬ 10*10, � ����������',
    ' ����� ��ப�, ᮤ�ঠ饩 �������쭮� ���祭�� �᫠ � ���ᨢ�.',
    '4. ������� ��楤���, ������� � ����⢥ �室���� ��ࠬ���',
    '��㬥�� ���ᨢ 楫�� �ᥫ  ࠧ��஬ 10*10, � ����������',
    '  ����� ��ப� � �⮫��, �� ����祭�� ������ ��室����',
    ' �������쭮�  �᫮ � ���ᨢ�.');

var ResData : Arr;
begin
  ShowArray(ExampleData);
  Change(ExampleData,ResData,'�㭪��','��������� ����');
  ShowArray(ResData);
end.
