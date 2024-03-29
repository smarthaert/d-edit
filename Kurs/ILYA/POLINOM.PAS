uses
  TPCrt,
  TPMenu,
  TPWindow,
  ListUnit,
  About;

procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($04, $2E, $04, $0F, $04, $0E, $19, $78);
  Frame1 : FrameArray = '�Ը�ͳ';

begin
  M := NewMenu([], nil);

  SubMenu(1,2,1,Horizontal,Frame1,Color1,'');
    MenuWidth(80);
    MenuItem('�������',2,1,1,'');
    SubMenu(3,4,1,Vertical,Frame1,Color1,'');
      MenuItem('���� ������',1,1,9,'');
      MenuItem('�뢮�',2,1,10,'');
      MenuItem('��������',3,1,11,'');
      MenuItem('������஢����',4,1,12,'');
      MenuItem('�������� ��� ',5,1,13,'');
      PopSublevel;
    MenuItem('����樨',14,1,2,'');
    SubMenu(15,4,1,Vertical,Frame1,Color1,'');
      MenuItem('��������',1,1,6,'');
      MenuItem('���⠭��',2,1,7,'');
      MenuItem('����஢��',3,1,8,'');
      PopSublevel;
    MenuItem('� �ணࠬ��',47,1,3,'');
    MenuItem('HELP',63,1,4,'');
    MenuItem('��室',72,1,5,'');
    PopSublevel;

  ResetMenu(M);
end;

var
  M : Menu;
  Ch : Char;
  Key : MenuKey;

begin
  ClrScr;
  InitMenu(M);
  MakeWindow(ListWindow,1,6,20,22,True,True,False,$07,$04,$0F,'���᮪ ���������');
  DisplayWindow(ListWindow);
  Repeat
    List_Polynom;
    Key := MenuChoice(M, Ch);
    Case Key of
      9: New_Polynom;
     10: Show_Polynom;
     11: Del_Polynom;
     12: Edit_Polynom;
     13: DeleteAllPolynoms;
      6: Add_Polynom;
      7: Sub_Polynom;
      8: Sort_Polynom;
      3: AboutProg;
      4: Help;
    End;
    EraseMenu(M, False);
  Until Key = 5;
  DeleteAllPolynoms;
  KillWindow(ListWindow);
  ClrScr;
end.
