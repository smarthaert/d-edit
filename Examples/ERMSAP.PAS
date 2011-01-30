// Ермаков Михаил <ermakovmu@list.ru>
program Ermsaper;

uses
  Crt, Dos, Graph;

const
  GorSize : integer = 10;
  VerSize : integer = 10;
  CellWidth = 11;

Type
  OneCell = record
    Open : boolean;
    HaveMine : boolean;
    MineNearCount : integer;
    UserSelectMine : boolean;
  end;

  TPoint = record
    x : integer;
    y : integer;
  end;

var
  MA : Array [0..50, 0..50] of OneCell;
  CurrentCell : TPoint;
  GameRunning : boolean;
  GameStoped : boolean;
  EndOfGame  : boolean;
  TimeToExit : boolean;
  sh, sm, ss, shund : Word;
  TimeRemaining : word;
  BombCounter : integer;

  GraphDriver : integer;  
  GraphMode   : integer;  
  MaxX, MaxY  : word;     
  ErrorCode   : integer;  
  MaxColor    : word;     
  OldExitProc : Pointer; 

{$F+}
procedure MyExitProc;
begin
  ExitProc := OldExitProc; 
  CloseGraph;              
end;
{$F-}

procedure Initialize;

var
  InGraphicsMode : boolean;
  PathToDriver   : string;
begin
  DirectVideo := False;
  OldExitProc := ExitProc;
  ExitProc := @MyExitProc;
  PathToDriver := '.\';
  repeat
    GraphDriver := Detect;
    InitGraph(GraphDriver, GraphMode, PathToDriver);
    ErrorCode := GraphResult;
    if ErrorCode <> grOK then
    begin
      Writeln('Graphics error: ', GraphErrorMsg(ErrorCode));
      if ErrorCode = grFileNotFound then
      begin
        Writeln('Vvedite put k failu EGAVGA.BGI');
        Readln(PathToDriver);
        Writeln;
      end
      else
        Halt(1);
    end;
  until ErrorCode = grOK;
  Randomize;
  MaxColor := GetMaxColor;
  MaxX := GetMaxX;
  MaxY := GetMaxY;
end;

function Int2Str(L : LongInt) : string;

var
  S : string;
begin
  Str(L, S);
  Int2Str := S;
end;

procedure GetDriverAndMode(var DriveStr, ModeStr : string);

begin
  DriveStr := GetDriverName;
  ModeStr := GetModeName(GetGraphMode);
end; 

procedure SayResultOfGame;
var
  ViewInfo : ViewPortType;
  ch : char;
begin
  GetViewSettings(ViewInfo);
  SetTextStyle(TriplexFont, HorizDir, 5);
  SetTextJustify(CenterText, CenterText);
  with ViewInfo do begin
    OutTextXY((x2-x1) div 2, y2 - (y2-y1) div 6, 'Konec igry - ESC');
    repeat until KeyPressed;
    while keypressed do ch := readkey;
  end;
end; 

function CellHaveMine(x, y : integer) : boolean;
begin
  CellHaveMine := false;
  if (x>=0) and (x<=GorSize-1) and (y>=0) and (y<=VerSize-1)
    then CellHaveMine := MA[x, y].HaveMine;
end;

function CellIsFree(x, y : integer) : boolean;
begin
  CellIsFree := false;
  if (x>=0) and (x<=GorSize-1) and (y>=0) and (y<=VerSize-1)
    then if MA[x, y].MineNearCount=0 then CellIsFree := true;
end;

procedure InitArray;
Var
  i, j : integer;
begin
  BombCounter := 0;
  CurrentCell.X := 0;
  CurrentCell.Y := 0;
   for i:=0 to GorSize-1 do begin
    for j:=0 to VerSize-1 do begin
      MA[i,j].Open := false;
      if (Random(100) < 13)
        then begin MA[i,j].HaveMine := true; inc(BombCounter); end
        else MA[i,j].HaveMine := false;
      MA[i,j].MineNearCount := 0;
      MA[i,j].UserSelectMine := false;
    end;
  end;

  for i:=0 to GorSize-1 do begin
    for j:=0 to VerSize-1 do begin
      if CellHaveMine(i-1, j-1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i  , j-1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i+1, j-1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i+1, j  ) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i+1, j+1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i  , j+1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i-1, j+1) then inc(MA[i,j].MineNearCount);
      if CellHaveMine(i-1, j  ) then inc(MA[i,j].MineNearCount);
    end;
  end;
end;

procedure DrawCursor;
begin
  SetViewPort((GetMaxX - GorSize*CellWidth) div 2,
              (GetMaxY - VerSize*CellWidth) div 2,
               GetMaxX, GetMaxY, True);
  SetColor(Yellow);
  Rectangle(CurrentCell.X*CellWidth, CurrentCell.Y*CellWidth,
            CurrentCell.X*CellWidth+CellWidth, CurrentCell.Y*CellWidth+CellWidth);
  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;

procedure ClearCursor;
begin
  SetViewPort((GetMaxX - GorSize*CellWidth) div 2,
              (GetMaxY - VerSize*CellWidth) div 2,
              GetMaxX, GetMaxY, True);
  SetColor(Black);
  Rectangle(CurrentCell.X*CellWidth, CurrentCell.Y*CellWidth,
      CurrentCell.X*CellWidth+CellWidth, CurrentCell.Y*CellWidth+CellWidth);
  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;


procedure DrawArray;
Var
  i, j : integer;
begin
  SetViewPort((GetMaxX - (GorSize+1)*CellWidth) div 2,
              (GetMaxY - (VerSize+1)*CellWidth) div 2,
              GetMaxX, GetMaxY, True);
  ClearViewPort;
  SetViewPort((GetMaxX - (GorSize)*CellWidth) div 2,
              (GetMaxY - (VerSize)*CellWidth) div 2,
              GetMaxX, GetMaxY, True);
  for i:=0 to GorSize-1 do
    for j:=0 to VerSize-1 do begin

      SetFillStyle(1, LightGray);
      if MA[i,j].Open then
        if MA[i,j].UserSelectMine
          then SetFillStyle(1, LightRed)
          else SetFillStyle(1, Cyan);


      Bar(I*CellWidth+1, j*CellWidth+1,
          I*CellWidth+CellWidth-1, j*CellWidth+CellWidth-1);

      SetTextStyle(DefaultFont, HorizDir, 1);
      if MA[i,j].Open then
      begin
        if not GameStoped then
          begin
            if (MA[i,j].MineNearCount > 0) and not MA[i,j].UserSelectMine then
              begin
                SetColor(White);
                OutTextXY(I*CellWidth+2, j*CellWidth+6,
                Int2Str(MA[i,j].MineNearCount));
              end
            else if MA[i,j].UserSelectMine then
              begin
                SetColor(Black);
                OutTextXY(I*CellWidth+2, j*CellWidth+6, '*');
              end;
          end
        else
          begin
            if (MA[i,j].MineNearCount > 0) and
                   not MA[i,j].UserSelectMine and
                   not MA[i,j].HaveMine then
              begin
                SetColor(White);
                OutTextXY(I*CellWidth+2, j*CellWidth+6,
                Int2Str(MA[i,j].MineNearCount));
              end
            else
              begin
                if MA[i,j].HaveMine then
                  begin
                    SetColor(Black);
                    OutTextXY(I*CellWidth+2, j*CellWidth+6, '*');
                  end;
                if MA[i,j].UserSelectMine and not MA[i,j].HaveMine then
                  begin
                    SetColor(Black);
                    OutTextXY(I*CellWidth+2, j*CellWidth+6, '*');
                    SetColor(Black);
                    SetLineStyle(0,0,2);
                    Line(I*CellWidth+1, j*CellWidth+1,
                         I*CellWidth+CellWidth-1, j*CellWidth+CellWidth-1);
                    Line(I*CellWidth+CellWidth-1, j*CellWidth+1,
                         I*CellWidth+1, j*CellWidth+CellWidth-1);
                    SetLineStyle(0,0,1);
                  end;
              end;
      end; 
    end;
  end;
  SetViewPort(0, 0, GetMaxX, GetMaxY, True)
end;

procedure RightKeyPressed;
begin
  if CurrentCell.X < GorSize-1 then begin
    ClearCursor;
    inc(CurrentCell.X);
    DrawCursor;
  end;
end;

procedure LeftKeyPressed;
begin
  if CurrentCell.X > 0 then begin
    ClearCursor;
    dec(CurrentCell.X);
    DrawCursor;
  end;
end;

procedure UpKeyPressed;
begin
  if CurrentCell.Y > 0 then begin
    ClearCursor;
    dec(CurrentCell.Y);
    DrawCursor;
  end;
end;

procedure DownKeyPressed;
begin
  if CurrentCell.Y < VerSize-1 then begin
    ClearCursor;
    inc(CurrentCell.Y);
    DrawCursor;
  end;
end;

procedure OpenAll;
Var
  i, j : integer;
begin
  for i:=0 to GorSize-1 do
    for j:=0 to VerSize-1 do
      if MA[i,j].HaveMine then MA[i,j].Open := true;
end;

procedure OpenNearFree(x, y : integer);
begin
  if (MA[x,y].Open) or (x<0) or (x>GorSize-1) or
     (y<0) or (y>VerSize-1) then exit;

  MA[x,y].Open := true;
  if not CellIsFree(x, y) then exit;

  OpenNearFree(x, y-1);
  OpenNearFree(x+1, y);
  OpenNearFree(x, y+1);
  OpenNearFree(x-1, y);

  OpenNearFree(x-1, y-1);
  OpenNearFree(x+1, y+1);
  OpenNearFree(x-1, y+1);
  OpenNearFree(x+1, y-1);
end;

procedure OpenCurren;
begin
  if MA[CurrentCell.X, CurrentCell.Y].MineNearCount=0
    then OpenNearFree(CurrentCell.X, CurrentCell.Y)
    else MA[CurrentCell.X, CurrentCell.Y].Open := true;
end;

function SpaceKeyPressed : boolean;
begin
  SpaceKeyPressed := false;
  if MA[CurrentCell.X, CurrentCell.Y].Open then exit;
  if MA[CurrentCell.X, CurrentCell.Y].HaveMine
    then begin
      OpenAll;
      SpaceKeyPressed := true; end
    else OpenCurren;
  DrawArray;
  DrawCursor;
end;

function EnterKeyPressed : boolean;
begin
  EnterKeyPressed := false;

  if not MA[CurrentCell.X, CurrentCell.Y].Open then begin
    MA[CurrentCell.X, CurrentCell.Y].Open := true;
    MA[CurrentCell.X, CurrentCell.Y].UserSelectMine := true;
    dec(BombCounter);
    DrawArray;
    exit;
  end;

  if MA[CurrentCell.X, CurrentCell.Y].UserSelectMine then begin
    MA[CurrentCell.X, CurrentCell.Y].Open := false;
    MA[CurrentCell.X, CurrentCell.Y].UserSelectMine := false;
    inc(BombCounter);
    DrawArray;
    exit;
  end;
  DrawCursor;
end;

function AllCellsOpen : boolean;
Var
  i, j : integer;
begin
  AllCellsOpen := true;
  for i:=0 to GorSize-1 do
    for j:=0 to VerSize-1 do
      if not MA[i,j].Open then begin
        AllCellsOpen := false;
        exit;
      end;
end;

function CheckOnEndGame : boolean;
begin
  if AllCellsOpen then CheckOnEndGame := true
    else CheckOnEndGame := false;
end;

function GetElapsedSeconds : longint;
Var
 h, m, s, hund : word;
begin
  GetTime(h, m, s, hund);
  GetElapsedSeconds := (h-sh) * 3600 + (m-sm) * 60 + (s-ss);
end;

procedure DrawCounters(NeedDraw : boolean);
Var
  NewTimeRemaining : word;
begin
  SetViewPort(0, GetMaxY-30, GetMaxX, GetMaxY, True);

  NewTimeRemaining := GetElapsedSeconds;
  if (TimeRemaining <> NewTimeRemaining) or NeedDraw then begin
    TimeRemaining := NewTimeRemaining;
    ClearViewPort;
    SetTextStyle(DefaultFont, HorizDir, 1);
    SetTextJustify(LeftText, CenterText);
    SetColor(Green);     OutTextXY(50   , 5, 'Time='+Int2Str(NewTimeRemaining));
    SetColor(LightBlue); OutTextXY(170 , 5, 'BombRemaining='+Int2Str(BombCounter) );
  end;

  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;

procedure ClearCounters;
begin
  SetViewPort(0, GetMaxY-30, GetMaxX, GetMaxY, True);
  ClearViewPort;
  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;

procedure DrawMenu1;
begin
  SetViewPort(0, 0, GetMaxX, 20, True);
  ClearViewPort;

  SetTextStyle(DefaultFont, HorizDir, 1);
  SetTextJustify(LeftText, CenterText);
  SetColor(LightGreen); OutTextXY(0  , 5, 'F1' );
  SetColor(White); OutTextXY(20 , 5, 'Start');
  SetColor(LightGreen); OutTextXY(80 , 5, 'F2' );
  SetColor(White); OutTextXY(100 , 5, '+Shirina');
  SetColor(LightGreen); OutTextXY(175, 5, 'F3' );
  SetColor(White); OutTextXY(195, 5, '-Shirina');
  SetColor(LightGreen); OutTextXY(270, 5, 'F5' );
  SetColor(White); OutTextXY(290, 5, '+Vysota');
  SetColor(LightGreen); OutTextXY(370, 5, 'F6' );
  SetColor(White); OutTextXY(390, 5, '-Vysota');
  SetColor(LightRed);   OutTextXY(480, 5, 'F10' );
  SetColor(White); OutTextXY(510, 5, 'Exit');

  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;

procedure DrawMenu2;
begin
  SetViewPort(0, 0, GetMaxX, 20, True);
  ClearViewPort;

  SetTextStyle(DefaultFont, HorizDir, 1);
  SetTextJustify(LeftText, CenterText);
  SetColor(Green); OutTextXY(0  , 5, 'ESC' );
  SetColor(White); OutTextXY(30 , 5, 'Stop');
  SetColor(Green); OutTextXY(80 , 5, 'F2' );
  SetColor(DarkGray); OutTextXY(100, 5, '+Shirina');
  SetColor(Green); OutTextXY(175, 5, 'F3' );
  SetColor(DarkGray); OutTextXY(195, 5, '-Shirina');
  SetColor(Green); OutTextXY(270, 5, 'F5' );
  SetColor(DarkGray); OutTextXY(290, 5, '+Vysota');
  SetColor(Green); OutTextXY(370, 5, 'F6' );
  SetColor(DarkGray); OutTextXY(390, 5, '-Vysota');
  SetColor(LightRed);   OutTextXY(480, 5, 'F10' );
  SetColor(White); OutTextXY(510, 5, 'Exit');

  SetViewPort(0, 0, GetMaxX, GetMaxY, True);
end;

procedure ResetGame;
begin
  GameStoped := true;
  GameRunning := false;
  ClearViewPort;
  DrawArray;
  DrawCursor;

  SayResultOfGame;

  GameStoped := false;
  GameRunning := false;
  EndOfGame := false;

  ClearViewPort;
  DrawMenu1;
  InitArray;
  DrawArray;
end;

procedure RunGame;
var
  Ch : char;
  Code : integer;
begin
  GameStoped := false;
  DrawArray;
  DrawMenu1;
  GameRunning := false;
  TimeToExit := false;
  repeat
    repeat
      if GameRunning then DrawCounters(false);
    until KeyPressed;
    Ch := ReadKey; if ch = #0 then ch := readkey;
    Code := integer(ch);
    if GameRunning then begin
      Case Ch of
        #68 : begin
                TimeToExit := true;
                GameRunning := false;
              end;
        #27 : begin
                EndOfGame := true;
                GameRunning := false;
              end;
        #77 : RightKeyPressed;
        #72 : UpKeyPressed;
        #80 : DownKeyPressed;
        #75 : LeftKeyPressed;
        #32 : begin
                if SpaceKeyPressed or CheckOnEndGame
                  then EndOfGame := true
                  else EndOfGame := false;
              end;
        #13 : begin
                if EnterKeyPressed or CheckOnEndGame
                  then EndOfGame := true
                  else EndOfGame := false;
              end;
      end;
      DrawCounters(true);
    end else begin 
      Case Ch of
        #68 : begin
                TimeToExit := true;
                GameRunning := false;
              end;
        #59 : begin
                InitArray;
                GameRunning := true;
                GetTime(sh, sm, ss, shund);
                DrawCursor;
                DrawMenu2;
              end;
        #60 : begin
                if GorSize < 35 then inc(GorSize);
                DrawArray;
              end;
        #61 : begin
                if GorSize > 10 then dec(GorSize);
                DrawArray;
              end;
        #63 : begin
                if VerSize < 25 then inc(VerSize);
                DrawArray;
              end;
        #64 : begin
                if VerSize > 10 then dec(VerSize);
                DrawArray;
              end;
      end; 
    end;
    if EndOfGame then ResetGame;
  until TimeToExit;
  ClearViewPort;
  DrawArray;
  SayResultOfGame;
end;

begin 
  Initialize;
  if (GraphDriver = EGA) or (GraphDriver = EGA64) or (GraphDriver = VGA)
    then RunGame;
  CloseGraph;
end.
