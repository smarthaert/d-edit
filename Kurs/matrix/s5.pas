{ �ணࠬ��: "��ࠡ�⪠ ⥪�⮢" }
const
  MaxRows = 100; { ���ᨬ��쭮� ������⢮ ��ப }
  MaxSL = 100; { ���ᨬ��쭮� ������⢮ ᫮��� }

var
  sep : string; { ��ப� � ᨬ������-ࠧ����⥫ﬨ }
  ends : string; { ��ப� � 2-�� �������騬� ᨬ������ }
  endPos : integer; { ������ 2-� ��������� ᨬ����� � ⥪�� }
  txt : string; { ����� }
  str : array [1..MaxRows] of string; { ��ப� ⥪�� }
  row : integer; { ������ ��ப� }
  i, j, t : integer; { ��६���� 横�� }
  slogi : array [1..MaxSL] of string; { ����� ��� ���᪠ }
  SN : integer; { ������⢮ ᫮��� ��� ���᪠ }
  newstr : string; { ����� ��ப� ��᫥ �����祭�� ᫮��� � ����窨 }
  slog : boolean; { ��稭����� �� � �⮣� ᨬ���� ���� �� ᫮��� }
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
  { ������ ᫮�� ��� ���᪠ }
  write('������ ������⢮ ᫮��� ��� ���᪠: '); readln(SN);
  for i:=1 to SN do begin
    write('������ ᫮� ',i,' �� ',SN,': '); readln(slogi[i]);
  end;
  row:=1; { ������ ��ப� - ��ࢠ� }
  str[row] := '';
  { �஡����� ���� ⥪�� ��ᨬ���쭮 }
  for i:=1 to length(txt) do
    if pos(txt[i],sep) <> 0 then begin { �᫨ ᨬ��� - ࠧ����⥫� }
      row := row + 1; { ��稭��� ����� ��ப� }
      str[row] := ''; { ����� ��ப� ����� }
    end else begin
      str[row] := str[row] + txt[i];
      if pos(txt[i],search) <> 0 then begin { �᫨ ��� ᨬ��� �饬 }
        writeln('������ ᨬ��� "',txt[i],'" ��ப� ',row,
          ' ������ ',length(str[row]));
      end;
    end;
  writeln;
  writeln('��ନ�㥬 ���� ⥪��, ����騩 �� ��ப ��������� ⥪��,');
  writeln('� ���஬ ������� ᫮�� �����祭� � ����窨.');
  for i:=1 to row do begin
    j := 1; { ����騩 ᨬ��� � ⥪�饩 ��ப� }
    newstr := '';
    while j <= length(str[i]) do begin
      slog := false;
      for t:=1 to SN do
        if Copy(str[i],j,Length(slogi[t])) =
           slogi[t] then begin { �᫨ ����� ��稭����� ��� ᫮� }
          { ������塞 ��� � ����窠� � ᬥ頥��� �� ��� ����� }
          newstr := newstr + '"'+ slogi[t] + '"';
          j := j + Length(slogi[t]);
          slog := true;
          break;
        end;
      if not slog then begin
        newstr := newstr + str[i,j];
        j := j + 1; { ��६�頥��� �� ᫥���騩 ᨬ��� }
      end;
    end;
    writeln(newstr); { �뢮��� ��⮢�� ��ப� �� �࠭ }
  end;

  writeln;
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
