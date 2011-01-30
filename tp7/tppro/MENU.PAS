uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu;

procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($1E, $2E, $1F, $4E, $1E, $0E, $19, $78);
  Frame1 : FrameArray = '┌└┐┘─│';

begin
  {Customize this call for special exit characters and custom item displays}
  M := NewMenu([], nil);

  SubMenu(6,3,24,Horizontal,Frame1,Color1,'');
    MenuItem(' 1. Файл ',2,1,1,'Работа с файлами');
    MenuItem(' 2. Редактирование ',13,2,2,'Редактор');
    SubMenu(20,6,24,Vertical,Frame1,Color1,'');
      MenuItem(' Выделить ',1,2,4,'ороромпавпап пававав');
      MenuItem(' Копировать ',2,2,5,'оололднкекекм ававава');
      PopSublevel;
    MenuItem(' 3. Выход ',34,2,3,'Закончить работу');
    PopSublevel;

  ResetMenu(M);
end;

var
  M : Menu;
  Ch : Char;
  Key : MenuKey;

  procedure Task1;
  var W1 : WindowPtr;
  begin
    if MakeWindow(W1, 10, 5, 30, 20, true, true, false, $1F, $1E, $13, ' Окно 1 ')
       and DisplayWindow(W1) then
      begin
        Writeln(' Окно 1 ');
        Readln;
      end
  end;

  procedure Task2;
  begin
    Window(1, 1, 80, 25);
    TextBackGround(0);
    ClrScr;
  end;

begin
  ClrScr;
  InitMenu(M);
  repeat
    Key := MenuChoice(M, Ch);
    EraseMenu(M, False);
    case Key of
      1: Task1;
      4: Task2;
    end;
  until Key = 3;
  ClrScr;
end.
