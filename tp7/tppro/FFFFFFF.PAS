uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu;

procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($79, $2E, $70, $4E, $7E, $0E, $19, $78);
  Frame1 : FrameArray = '…»ªºÕ∫';

begin
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(22,1,24,Horizontal,Frame1,Color1,'');
    MenuItem(' 1. File ',2,2,1,'Work with files');
    SubMenu(26,3,24,Vertical,Frame1,Color1,'');
      MenuItem(' New ',1,2,4,'kjkjkj ');
      MenuItem('Open ',2,1,5,'kjhkjkjkjkj ');
      PopSublevel;
    MenuItem(' 2. Edit ',13,2,2,'ghghgh ;l;l;l;l;l hjhjh');
    MenuItem(' 3. Exit ',24,5,3,'End Work');
    PopSublevel;

  ResetMenu(M);
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
