{ �ணࠬ�� �뢮���� ����-���� ������, ��室 - ESC }
Uses CRT;
Var D:Byte;
Begin
  ClrScr;
  TextColor(11);
  Writeln('�ணࠬ�� �뢮���� ᪠�-���� ������. ��室 - ESC (��� ESC-1)');
  Repeat
    D:=Port[$60];
    GotoXY(2,2);
    Write('���� ��� - ',D,'  ');
  Until D = 1;
  ClrScr;
End.