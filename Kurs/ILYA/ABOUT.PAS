Unit About;

Interface

Uses TPCrt, TPWindow;

{ --- ������ --- }
Procedure Help;
{ --- ���ଠ�� � �ணࠬ�� --- }
Procedure AboutProg;

Implementation

{ --- ������ --- }
Procedure Help;
  Var Window : WindowPtr;
  Begin
    MakeWindow(Window, 1, 4, 80, 25, True, True, False, $04, $07, $0F,
               '������');
    DisplayWindow(Window);
    TextColor(11);
    WriteLn('�ணࠬ�� "�������" �।�����祭� ��� ࠡ��� � �����童����.');
    WriteLn('������ "�������" ��⮨� �� ᫥����� �������:');
    TextColor(15);
    Write('I) "���� ������".�� ��� �롮� �㦭� ������ ���, ����� ���ண� �� ����� ��-');
    WriteLn('����� 17 ᨬ�����. ���������� 童�� �ந�室�� �� ����⨨ "ENTER" �� �뤥-');
    Write('������ "�⥯���/�����樥��". ������஢���� �����ண� ����樥�� �ந�室��');
    Write('�� ����⨨ "ENTER" �� �㦭�� ����. � �⥯���. �⥯��� �� ������ ���� �஡���,');
    WriteLn('����� 65535 � ����� 0. �����樥�� - �� ������ �ॢ����  53 ᨬ�����.');
    WriteLn('II) "�뢮�". ��। �뢮��� �㦭� ����� ��� �㦭��� ��������.');
    WriteLn('III) "��������". ��। 㤠������ �㦭� ����� ��� �㦭��� ��������.');
    WriteLn('IV) "�������� ���". �������� �ᥣ� ᯨ᪠ ���������.');
    WriteLn('V) "������஢����".���������  � ���������� ����� �⥯��� � �����樥�� �');
    WriteLn('��� 童��. (����� �������筮 �㭪�� "���� ������")');
    WriteLn;
    TextColor(11);
    WriteLn('������ "����⢨�" ��⮨� �� ᫥����� �������:');
    TextColor(15);
    WriteLn('I,II) "��������" � "���⠭��" 2-� ���������. �������� �� ����� � �������� ��-������-�㬬�.');
    WriteLn('III) ����஢��". �ਬ������,�᫨ �����童� �� ������ ��㯮�冷祭�� �⭮�-⥫쭮 �⥯���.');
    TextColor(7);
    WriteLn;
    Write('                          <������ ���� �������>');
    readkey;
    KillWindow(Window);
  End;

{ --- ���ଠ�� � �ணࠬ�� --- }
Procedure AboutProg;
  Var Window:WindowPtr;
  Begin
    MakeWindow(Window,17,6,63,22,True,True,False,$07,$04,$0F,' ���ଠ�� � �ணࠬ�� ');
    DisplayWindow(Window);
    TextColor(15);
    WriteLn;
    WriteLn('     �������� ������ ��  ����������������');
    WriteLn('      �� II ������� 1-�� ����� �� ���� : ');
    WriteLn('         �������� ����� ���������� ��');
    WriteLn('    ��������� �������������� �������������');
    WriteLn;
    WriteLn('�믮�����:   ���஢ �.�.');
    WriteLn('             ��७�� �.�.');
    WriteLn('��㯯�:      9331 ');
    WriteLn('��䥤�:     �����  ');
    WriteLn('�������:   ���');
    WriteLn;
    WriteLn('            Copyright(c)  2000        ');
    WriteLn;
    TextColor(7);
    Write('          < ������ ���� ������� >');
    ReadKey;
    KillWindow(Window);
  End;

End.