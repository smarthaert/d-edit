{ �ணࠬ��: "��ࠡ�⪠ ⥪�⮢" }

{ ����쪮 ࠧ ����砥��� � ��ப� �������� ᨬ��� }
function Count( S:string; C:Char ):integer;
var
  Res : integer; { ������� }
  i : integer; { ��६����� 横�� }
begin
  Res := 0;
  for i:=1 to length(S) do
    if S[i] = C then
      Res := Res + 1;
  Count := Res;
end;

var
  sep : string; { ��ப� � ᨬ������-ࠧ����⥫ﬨ }
  ends : string; { ��ப� � 2-�� �������騬� ᨬ������ }
  endPos : integer; { ������ 2-� ��������� ᨬ����� � ⥪�� }
  txt : string; { ����� }
  search : string; { ������� ��� ���᪠ }
  ok : boolean;
  str : array [1..100] of string; { ��ப� ⥪�� }
  row : integer; { ������ ��ப� }
  i, j : integer; { ��६���� 横�� }
begin
  writeln(' �ணࠬ��: "��ࠡ�⪠ ⥪�⮢" ');
  writeln('================================');
  write(' ������ ��ப� � ᨬ������-ࠧ����⥫ﬨ ��ப: '); readln(sep);
  repeat
    write(' ������ 2 ᨬ����, ��������騥 ����� ⥪��: '); readln(ends);
    ok := true;
    { �஢�ઠ ᮡ���� �᫮��� }
    if length(ends)<>2 then begin
      writeln(' ������ 2 ᨬ����, � �� ',length(ends),'!');
      ok := false;
    end;
  until ok;
  write('������ ��室�� ⥪��: '); readln(txt);
  { ��१��� 墮�� � ⥪�� }
  endPos := pos(ends,txt); { �饬 ����� ������ ends � txt }
  if endPos <> 0 then
    Delete(txt,endPos,length(txt)-endPos+1);
  writeln('����� �� ����: "',txt,'"');
  { ������ ᨬ���� ��� ���᪠ � �饬 �� ����樨 }
  write('������ ᨬ���� ��� ���᪠: '); readln(search);
  row:=1; { ������ ��ப�  }
  str[row] := '';
  { �஡����� ���� ⥪�� ��ᨬ���쭮 }
  for i:=1 to length(txt) do
    if pos(txt[i],sep) <> 0 then begin { �᫨ ᨬ��� - ࠧ����⥫� }
      row := row + 1; { ��稭��� ����� ��ப� }
      str[row] := ''; { ����� ��ப� ����� }
    end else begin
      str[row] := str[row] + txt[i];
      if pos(txt[i],search) <> 0 then begin { �᫨ �� ��� ᨬ��� �饬 }
        writeln('������ ᨬ��� "',txt[i],'" ��ப� ',row,
          ' ������ ',length(str[row]));
      end;
    end;
  writeln;
  writeln('��ନ�㥬 ���� ⥪��, ����騩 �� ��ப ��������� ⥪��,');
  writeln('� ������ �� ������ �� �� �������� ᨬ����� ����砥���');
  writeln('�� ����� ������ ࠧ�.');
  for i:=1 to row do begin
    ok := true;
    { �஢��塞 �� ������� ᨬ���� }
    for j:=1 to length(search) do
      if Count(str[i],search[j]) > 1 then begin
        ok := false;
        break;
      end;
    { �᫨ ��ப� 㤮���⢮��� �᫮��� => �뢮��� �� �� �࠭ }
    if ok then
      writeln(str[i]);
  end;

  writeln;
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
