{ �᭮���� �ணࠬ�� - �ࠩ��� ���஢���� }
uses List; { ������砥� ����� }

{ �ࠩ��� ���஢���� ����� ������ ��������� ���஢���
 �� ��� �㭪樨 � �� ���浪� � �� �᫮ ࠧ, � ⠪ �� ����� ���⮩
  � ������ ����䥩� }
var Root : PBox; { �����⥫� �� ���� ������� ��襣� ᯨ᪠ }
  V : integer; { ��࠭��� ���짮��⥫�� ����⢨� }
  Value : integer; { ���祭�� ������� ��� ����⢨� }
  NewValue : integer; { ����� ���祭�� ������� }
begin
  Root := nil; { ���砫� ᯨ᮪ ���⮩ }
  repeat
    { ����� ࠧ �뢮��� ᯨ᮪ }
    Show(Root);
    writeln('�롥�� ����⢨�:');
    writeln('  1. ��⠢��� ������� ��। ��᫥���� ������⮬');
    writeln('  2. �������� ���祭�� ��ࢮ�� �� ���浪� ������� � ������� ���祭���');
    writeln('  3. ������� ��᫥���� �� ���浪� ������� � ������� ���祭���');
    writeln('  4. ���� ����� ��ࢮ�� ������� � ������� ���祭���');
    writeln('  5. ����冷��� ᯨ᮪');
    writeln('  0. ��� �� �ணࠬ��');
    writeln;
    write('�� ᤥ����: '); readln(V);
    writeln;
    case V of
      1: begin
        write('���祭�� ������� ��� ��⠢��: '); readln(Value);
        AddElement(Root,Value);
       end;
      2: begin
        write('���祭�� ������� ��� ������: '); readln(Value);
        write('����� ���祭�� �������: '); readln(NewValue);
        ReplaceValue(Root,Value,NewValue);
       end;
      3: begin
        write('���祭�� ������� ��� 㤠�����: '); readln(Value);
        DeleteValue(Root,Value);
       end;
      4: begin
        write('���祭�� ������� ��� ���᪠: '); readln(Value);
        writeln('��� �����: ',FindValue(Root,Value));
       end;
      5: { ���� ��뢠�� ��楤��� ���஢�� }
        SortList(Root);
    end;
  until V = 0;
end.