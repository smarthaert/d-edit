function f( a,b : integer ):integer;
begin
  f := a * b; { << ����� �������� �㭪�� }
end;

var
  a : -4..4; { "a" � �।���� �� -4 �� 4 }
  b : -5..3; { "b" � �।����� �� -5 �� 3 }
  y : integer; { ���祭�� "y" }
  y_all : integer; { ������⢮ ��� "y" }
  y_pos_sum : integer; { �㬬� ������⥫��� "y" }
begin
  Writeln('�����. y=f(a,b). f(a,b)=a*b');
  Writeln('���� �⭮襭�� ������⢠ ��� "y" � �㬬� ������⥫��� "y"');
  Writeln('��ਠ�� 1. � �ᯮ�짮������ 横�� For');
  y_all := 0; y_pos_sum := 0;
  for a := low(a) to high(a) do { low(a) - ������ �।�� "a", high(a) - ���孨� �।�� "a" }
    for b := low(b) to high(b) do begin { low(b) - ������ �।�� "b", high(b) - ���孨� �।�� "b" }
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
    end;
  Writeln('�⭮襭�� (�筮��� - 5 ������ ��᫥ �����筮� �窨): ',y_all/y_pos_sum:0:5);
  Writeln('��ਠ�� 2. � �ᯮ�짮������ 横�� While');
  y_all := 0; y_pos_sum := 0;
  a := low(a);
  while a <= high(a) do begin { low(a) - ������ �।�� "a", high(a) - ���孨� �।�� "a" }
    b := low(b);
    while b <= high(b) do begin { low(b) - ������ �।�� "b", high(b) - ���孨� �।�� "b" }
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
      b := b + 1;
    end;
    a := a + 1;
  end;
  Writeln('�⭮襭�� (�筮��� - 5 ������ ��᫥ �����筮� �窨): ',y_all/y_pos_sum:0:5);
  Writeln('��ਠ�� 3. � �ᯮ�짮������ 横�� Repeat..Until');
  y_all := 0; y_pos_sum := 0;
  a := low(a);
  repeat
    b := low(b);
    repeat
      y := f(a,b);
      y_all := y_all + 1;
      if y>0 then
        y_pos_sum := y_pos_sum + y;
      b := b + 1;
    until b > high(b);
    a := a + 1;
  until a > high(a);
  Writeln('�⭮襭�� (�筮��� - 5 ������ ��᫥ �����筮� �窨): ',y_all/y_pos_sum:0:5);
  Writeln('������ Enter ��� �த�������'); Readln;
end.
