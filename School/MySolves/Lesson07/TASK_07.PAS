Uses Graph;
Const
  Angle60=Pi/3; {���� ����� "�����窠��" ᭥�����}
Var
  Driver,Mode:Integer;

Procedure Sneg(x,y,l:Integer); {x,y - 業�� ᭥�����, l - ����� "�����窨"}
Var
  i:Integer;
  xNew,yNew:Integer; {���� ���न���� 業�� ᭥�����}
Begin
  If l>=1 Then {�᫮��� ��室� �� ४��ᨨ - ����� ����� 1}
    For i:=0 To 5 Do {��ᮢ���� ��� "�����祪"}
    Begin
      xNew:=x+Round(l*Cos(i*Angle60));
      yNew:=y+Round(l*Sin(i*Angle60));
      Line(x,y,xNew,yNew);
      Sneg(xNew,yNew,l Div 3); {�����ᨢ�� �맮� � ���묨 ��ࠬ��ࠬ�}
    End;
End;

Begin
  Driver:=Vga; Mode:=VgaHi;
  InitGraph(Driver,Mode,'c:\Bp\Bgi');
  Sneg(320,240,100); {��砫�� �맮�: (320,240) - 業�� ��࠭�, 100 - ��砫쭠� �����}
  ReadLn;
End.
