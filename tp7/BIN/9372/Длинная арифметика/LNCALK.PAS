uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu;

procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '…»ªºÕ∫';

begin
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(1,2,1,Horizontal,Frame1,Color1,'');
    MenuMode(True, False, False);
    MenuWidth(37);
    MenuItem('File',2,1,10,'Open/Save projects');
    SubMenu(3,4,1,Vertical,Frame1,Color1,'');
      MenuMode(True, False, False);
      MenuItem('Open',1,1,11,'Opens saved project');
      MenuItem('Save',2,1,12,'Saves currunt project');
      PopSublevel;
    MenuItem('Operations',8,1,1,'Choose the operation to work with long numbers');
    SubMenu(9,4,1,Vertical,Frame1,Color1,'');
      MenuMode(True, False, False);
      MenuItem('+',1,1,5,'Sums two numbers');
      MenuItem('-',2,1,6,'Distracts two numbers');
      MenuItem('*',3,1,7,'Multiplicates two numbers');
      MenuItem('/',4,1,8,'Divides two numbers');
      PopSublevel;
    MenuItem('Numbers',20,1,2,'Change numbers');
    SubMenu(20,4,1,Vertical,Frame1,Color1,'');
      MenuMode(True, False, False);
      MenuItem('1-st number',1,1,3,'Changes the value of the first number');
      MenuItem('2-nd number',2,1,4,'Changes the value of the second number');
      PopSublevel;
    MenuItem('Exit',29,1,9,'Shut down the program');
    PopSublevel;

  ResetMenu(M);
  SetMenuDelay(M, 10);
end;

var
  M : Menu;
  Ch : Char;
  Key : MenuKey;

begin
  InitMenu(M);
  Key := MenuChoice(M, Ch);
  EraseMenu(M, False);
  Writeln('Key=', Key, ' Ch=#', Ord(Ch));
end.
