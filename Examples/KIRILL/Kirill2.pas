var c1,c2,ch:integer;
begin
  Writeln('�뢥�� ���姭��� �᫠, ����� ������� ��楫� �� ������ �� ᢮�� ���');
  for c1 := 1 to 9 do begin { ��ࢠ� ���, �� 1 �� 9, �.�. �᫮ ���姭�筮� }
    for c2 := 1 to 9 do begin { ���� ���, �� ������ ���� ࠢ�� 0, �.�. �� ��� ������ �������� �᫮ }
      ch := c1*10 + c2; { ����塞 ᠬ� �᫮ }
      if (ch mod c1 = 0) and (ch mod c2 = 0) then
        Writeln('��᫮ ',ch,' ������� �� ',c1,' � �� ',c2);
    end;
  end;
  Writeln('������ Enter ��� �த�������'); Readln;
end.
