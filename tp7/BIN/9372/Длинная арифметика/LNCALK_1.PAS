uses
  TPString,
  TPCrt,
  TPCmd,
  TPWindow,
  TPMenu;

procedure InitMenu(var M : Menu);
const
  Color1 : MenuColorArray = ($0E, $2E, $03, $1E, $0B, $0E, $19, $78);
  Frame1 : FrameArray = '╔╚╗╝═║';

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
{-----------------------------------}
const c=1000;
      osn=10000;

type Tlong = array [0..C] of longint;

procedure readlong (var num:Tlong); {Обеспечивает чтение длин чисел}
  var i: longint;
      ch: char;
  begin
    for i:=0 to C do  {инициализация массива}
      num[i]:=0;
    read (ch);
    while ch in ['0'..'9'] do
      begin
        for i:= num[0] downto 1 do
          begin
            num[i+1]:= num[i+1] + (num[i]*10) div osn; {передвигаем старшую}
            num[i]:= (num[i]*10) mod osn;   {цифру в след число, освобождая}
          end;                            {нынешнее число для след цифры}
        num[1]:= num[1] + ord(ch) - ord ('0');
        if num[num[0]+1] > 0 then inc(num[0]);
        read (ch);
      end;
  end;

procedure WriteLong (num:Tlong); {Вывод длин чисел на экран}
  var zer, s: string;
      i: longint;
  begin
    write (num[num[0]]);  {вывод старшего числа}
    str (osn div 10, zer);
    for i:= num[0]-1 downto 1 do
      begin
        str (num[i], s);
        while length (s) < length (zer) do  {дополнение незнач нулями}
          s:='0'+s;
        write (s);   {вывод остальных чисел}
      end;
    writeln;
  end;
{-----------------------------------------------}
var
  M : Menu;
  Ch : Char;
  Key : MenuKey;
{------------------------}
  num1, num2 : Tlong;
{------------------------}
begin
  clrscr;
  InitMenu(M);
  Key := MenuChoice(M, Ch);
  EraseMenu(M, False);
{-------------------------}
  case key of
    3: begin
         readlong (num1);
         writelong (num1);
       end;
    4: readlong (num2);
    9: writeln ('gggss');
  end;
  readln;
{--------------------------}
  Writeln('Key=', Key, ' Ch=#', Ord(Ch));
end.
