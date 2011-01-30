Uses CRT,Graph;

function IntToStr( i:integer ):string;
var R : string;
begin
  Str(i,R);
  IntToStr := R;
end;

var i:integer;
Var grDriver : Integer;
      grMode : Integer;
     ErrCode : Integer;
begin
  grDriver:=Detect;
  InitGraph(grDriver, grMode, '');
  ErrCode:=GraphResult;
  if ErrCode <> grOk then begin
    WriteLn('Ошибка инициализации графики:', GraphErrorMsg(ErrCode));
    exit;
  end;
  Line(0, 0, GetMaxX, GetMaxY);

  for i:=1 to 15 do begin
    SetColor(i);
    OutTextXY(i*30,20,'#'+IntToStr(i)+'#');
  end;

  GotoXY(4,14);
  writeln('______');
  { Берег }
  TextColor(2);
  GotoXY(1,14); write('ЯЯЯ');
  TextColor(7);
  GotoXY(1,15); write('###');
  { Изображаем Болото }
  TextColor(6);
  TextBackGround(0);
  for i:=3 to 76 do
    write('~');
  GotoXY(20,10);
  Writeln('Б О Л О Т О');

  Readln;
  CloseGraph;
end.