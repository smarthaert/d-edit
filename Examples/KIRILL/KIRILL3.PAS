var
  a : array [1..20] of integer; { ���ᨢ }
  N : integer; { ������⢮ ������⮢ � ���ᨢ� }
  i,j : integer;
  res : integer; { ������� 㬭������ }
  found : boolean; { ���� �� ��� ������� � ���ᨢ�? }
begin
  Writeln('� ������୮� �᫮��� ���ᨢ� ��������, �ᯮ������� ��᫥ ��ࢮ�� �⭮�� ������� ��६������');
  Write('������ ������⢮ ������⮢ ���ᨢ� (楫�� �᫮ �� 1 �� ',High(a),'): '); Readln(N);
  for i := 1 to N do begin
    Write('������ a[',i,'] = ');
    Readln(a[i]);
  end;
  found := false;
  for i := 1 to N do
    if not odd(a[i]) then begin { odd(x) - true - �᫨ x ����⭮�, � false �᫨ x - �⭮� }
      Writeln('���� ��� �������: a[',i,'] = ',a[i]);
      Writeln('��६������:');
      res := a[i]; Write(a[i]);
      for j := i+1 to N do begin
        res := res * a[j]; Write('*',a[j]);
      end;
      Writeln(' = ',res);
      found := true;
      break; { ���뢠�� 横� (�.�. ��� �㦥� ⮫쪮 ���� ��� �������) }
    end;
  if not found then
    Writeln('� ���ᨢ� ��� ���� ������⮢!');
  Writeln('������ Enter ��� �த�������'); Readln;
end.
