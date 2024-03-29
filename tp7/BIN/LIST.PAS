{ �����, ॠ�����騩 ����樨 � ᯨ᪮� }
{ ���᮪ ������ ���� ॠ������� � ���� �����. }
unit List;

interface { ��������� �㭪権, ����� ����� �맢��� �� �᭮���� �ணࠬ�� }

{ ����� �������� ������ }
type
  PBox = ^TBox;
  TBox = record
    Value : integer; { ���祭�� ������� ᯨ᪠ - 楫�� �᫮ }
    Next : PBox; { ��뫪� �� ᫥���騩 ������� }
  end;

{ ����⢨�, ��।��塞� �������� ��ଫ����� � ���� ��楤�� ��� �㭪権,
  ����祭��� � ��� �����. }

{ ��⠢��� ������� ��। ��᫥���� ������⮬ }
{ ��ࠬ����: }
{   Root - ��७� ᯨ᪠ }
{   Value - ���祭�� ������塞��� ������� }
procedure AddElement( var Root : PBox; Value : integer );

{ �������� ���祭�� ��ࢮ�� �� ���浪� ������� � ������� ���祭��� }
procedure ReplaceValue( var Root : PBox; Value,NewValue : integer );

{ ����� ⠪ �� ������ ᮤ�ঠ�� �।�⢠ ���㠫���樨 ᯨ᪠ �ᯮ��㥬�
 �� ���஢���� � �।����� १���⮢ �믮������ �������. }
procedure Show( Root : PBox );

implementation { ��������� �㭪権 �� ࠡ�� � ᯨ᪠�� }

procedure AddElement( var Root : PBox; Value : integer );
var
  N : PBox; { �����⥫� �� ���� ������� }
  I : PBox; { �����⥫� �� ⥪�騩 ������� �� ���᪥ �।��᫥����� }
begin
  { ������ ���� ������� }
  New( N ); { ������� ������� � �������᪮� ����� }
  N^.Value := Value;
  { �᫨ ᯨ᮪ ���⮩, � ������� N �㤥� �����⢥��� }
  if Root = nil then begin
    Root := N;
    N^.Next := nil;
  end else { �᫨ � ᯨ᪥ 1 ������� }
    if Root^.Next = nil then begin
      N^.Next := Root;
      Root := N;
    end else begin { �᫨ � ᯨ᪥ ����� 1 ������� }
      { �饬 �।��᫥���� ������� }
      I := Root;
      { ����� I - �।��᫥���� ������� }
      while I^.Next^.Next <> nil do
        I := I^.Next;
      { ��᫥���� ������� ��ॢ�訢��� �� N }
      N^.Next := I^.Next;
      { ������� N ��ॢ�訢��� �� I }
      I^.Next := N;
    end;
end;

procedure Show( Root : PBox );
var P : PBox;
    I : integer;
begin
  writeln('�뢮��� ᯨ᮪ �� ��࠭');
  if Root = nil then
    writeln(' (ᥩ�� ᯨ᮪ ����)');
  I := 0;
  P := Root;
  while P <> nil do begin
    I := I + 1;
    writeln(' ',I,') ',P^.Value);
    P := P^.Next;
  end;
  writeln;
end;

procedure ReplaceValue( var Root : PBox; Value,NewValue : integer );
begin

end;

end.