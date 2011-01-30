unit Menu;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, DIB , DXWStatObj;

type
  TMenuScene = (
    msGameMenu,
    msSave,
    msLoad,
    msOptions,
    msHelp,
    msMissionObj,
    msEndMission,
    msReturnToGame
  );

Var
 FSubSceneBtnList : TList;
 FMenuScene       : TMenuScene;
 FMenuCaption     : String ;

 procedure StartSubSceneMainMenu;
 procedure SubSceneMainMenu;
 procedure EndSubSceneMainMenu;
 procedure SubSceneMainMenuMouseDown(Shift: TShiftState; X, Y: Integer);
 procedure SubSceneMainMenuMouseUp(Shift: TShiftState; X, Y: Integer);

 procedure StartSubScene_msGameMenu;
 procedure StartSubScene_msOptions;
 procedure StartSubScene_msEndMission;

implementation
Uses Main,Pathes ;

procedure StartSubSceneMainMenu;
Var
 i : Integer;
 FileName : string;
begin
FSubSceneBtnList:=TList.Create;
With MainForm do begin
 FileName:='GameMenu.dxg';
 LoadPicData(TmpImageList1,FileName);
 //TmpImageList1.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
 SavePicData(TmpImageList1,FileName);

 For i:=0 to 6 do
 begin
   FSubSceneBtnList.Add(TDXImageButton.Create);
   With TDXImageButton(FSubSceneBtnList[i]) do
   begin
    Image := MainForm.TmpImageList1.Items.Find('BtnMenu');
    Width := Image.Width;
    Height := Image.Height;
    X := 118;
    Surface:=DXDraw.Surface;
   end;
 end;
end;
StartSubScene_msGameMenu;
SubSceneMainMenuEnabled:=true;
end;

procedure StartSubScene_msGameMenu;
Var
i : Integer;
begin
FMenuScene:=msGameMenu;
FMenuCaption:='Game Menu';
For i:=0 to 6 do
 begin
   With TDXImageButton(FSubSceneBtnList[i]) do
   begin
    Visible:=true;
    Case i of
     0 : Begin
          Y := 132;
          Caption:='Save Game';
         end;
     1 : Begin
          Y := 168;
          Caption:='Load Game';
         end;
     2 : Begin
          Y := 204;
          Caption:='Option';
         end;
     3 : Begin
          Y := 240;
          Caption:='Help';
         end;
     4 : Begin
          Y := 276;
          Caption:='Mission Objectives';
         end;
     5 : Begin
          Y := 312;
          Caption:='Abort Mission';
         end;
     6 : Begin
          Y := 348;
          Caption:='Return to Game';
         end;
    end;
   end;
 end;
end;


procedure StartSubScene_msOptions;
Var
i : Integer;
begin
FMenuScene:=msOptions;
FMenuCaption:='Game Options';
For i:=0 to 6 do
 begin
   With TDXImageButton(FSubSceneBtnList[i]) do
   begin
    Visible:=true;
    Case i of
     0 : Begin
          Y := 132;
          Caption:='Sound';
         end;
     1 : Begin
          Y := 168;
          Caption:='Speeds';
         end;
     2 : Begin
          Y := 204;
          Caption:='Preferences';
         end;
     3 : Begin
          Y := 240;
          Caption:='';
          Visible:=False;
        end;
     4 : Begin
          Y := 276;
          Caption:='';
          Visible:=False;
          end;
     5 : Begin
          Y := 312;
          Caption:='';
          Visible:=False;
         end;
     6 : Begin
          Y := 348;
          Caption:='Previous';
         end;
    end;
   end;
 end;
end;

procedure StartSubScene_msEndMission;
Var
i : Integer;
begin
FMenuScene:=msEndMission;
FMenuCaption:='Прервать миссию';
For i:=0 to 6 do
 begin
   With TDXImageButton(FSubSceneBtnList[i]) do
   begin
    Visible:=true;
    Case i of
     0 : Begin
          Y := 132;
          Caption:='Restart Mission';
         end;
     1 : Begin
          Y := 168;
          Caption:='Surrender';
         end;
     2 : Begin
          Y := 204;
          Caption:='';
          Visible:=False;
         end;
     3 : Begin
          Y := 240;
          Caption:='Quit to Game Menu';
         end;
     4 : Begin
          Y := 276;
          Caption:='Exit Program';
         end;
     5 : Begin
          Y := 312;
          Caption:='';
          Visible:=False;
         end;
     6 : Begin
          Y := 348;
          Caption:='Previous';
         end;
    end;
   end;
 end;
end;


procedure EndSubSceneMainMenu;
Var
i : integer;
begin
SubSceneMainMenuEnabled:=false;
With MainForm do begin
TmpImageList1.Items.Clear;
For i:=0 to FSubSceneBtnList.Count-1
 do TDXImageButton(FSubSceneBtnList[i]).free;
FSubSceneBtnList.Clear;
FSubSceneBtnList.Free;
end;
end;

procedure SubSceneMainMenu;
Var
i : integer;
begin
With MainForm do begin
 TmpImageList1.Items[0].Draw(DXDraw.Surface, 100, 100, 0);

 With DXDraw.Surface.Canvas do
 begin
    Brush.Style := bsClear;
    Font.Color := clYellow;
    Font.Size := 12;
    Font.Name:='Times New Roman';
    TextOut(100+(260-TextWidth( FMenuCaption))div 2 ,105,  FMenuCaption);
    Release;
 end;
 For i:=0 to 6
  do TDXImageButton(FSubSceneBtnList[i]).DrawSelf;
end;
end;

procedure SubSceneMainMenuMouseUp(Shift: TShiftState; X, Y: Integer);
Var
 i          : integer;
 SelIndex   : Integer;
begin
With MainForm do begin
 For i:=0 to 6 do
 begin
  if TDXImageButton(FSubSceneBtnList[i]).Selected then
  begin
   TDXImageButton(FSubSceneBtnList[i]).Selected:=False;
   SelIndex:=i;
  end;
 end;

Case FMenuScene of
 msGameMenu : Case SelIndex of
              2 : StartSubScene_msOptions;
              5 : StartSubScene_msEndMission;
              6 : EndSubSceneMainMenu;
              end;
 msSave: Begin
         end;
 msLoad:Begin
              end;
 msOptions: Case SelIndex of
              6 : StartSubScene_msGameMenu;
              end;
 msHelp:Begin
              end;
 msMissionObj:Begin
              end;
 msEndMission:Case SelIndex of
              3 : begin
                   EndSubSceneMainMenu;
                   StartScene(gsMainMenu);
                  end;
              4 : begin
                   EndSubSceneMainMenu;
                   StartScene(gsGameOver);
                  end;
              6 : StartSubScene_msGameMenu;
              end;
 msReturnToGame: Begin
              end;

 end;

end;
end;

procedure SubSceneMainMenuMouseDown(Shift: TShiftState; X, Y: Integer);
Var
 i         : integer;
 DownPoint : TPoint;
 r          : TRect;
begin
With MainForm do begin
 DownPoint:=Point(x,y);
 For i:=0 to FSubSceneBtnList.Count-1 do
  begin
   r:=TDXImageButton(FSubSceneBtnList[i]).BoundsRect;
   if ( PtInRect(r,DownPoint) ) and
      (TDXImageButton(FSubSceneBtnList[i]).Visible)
    then TDXImageButton(FSubSceneBtnList[i]).Selected:=true;
  end;
 end;
end;

end.
