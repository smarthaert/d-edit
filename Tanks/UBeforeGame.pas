unit UBeforeGame;

interface

Uses UMyMenu,Classes,Graphics,Pointers,SysUtils,URedefineKeys,UBGMenus,MapPreview,USkill;

Type
  TBGSMenu=(bgMain,bgRedefineKeys,bgOptions,bgMap);
  TBeforeGameScreen=Class(TComponent)
  private
    MapImage:TBitMap;
  Public
    Menu:TMyMenu;
    GameType:Integer;
    CurrentMenu:TBGSMenu;
    OptionsMenu:TGameOptionsMenu;
    MapMenu:TMapMenu;
    Constructor Create(AOwner:TComponent);Override;
    Destructor Destroy;Override;
    Function Step(MoveCount:Integer):Integer;
    Procedure RefreshMapImage;
  End;

Var
  BeforeGameScreen:TBeforeGameScreen;

implementation

Uses Main,UUnits;

Const
  NGameTypeCount=5;
  NGameType:Array [1..NGameTypeCount] of String=('1 PL','2 PL','COOP','DM','DUEL');

{ TBeforeGameScreen }

constructor TBeforeGameScreen.Create(AOwner: TComponent);
begin
  inherited;
  MapImage:=TBitMap.Create;
  MapImage.Width:=MapHImageWidth;
  MapImage.Height:=MapHImageHeight;
  RefreshMapImage;
  Menu:=TMyMenu.MyCreate(Nil,200,5);
  GameType:=3;
  Menu.AddTextItem('START');
  Menu.AddValueItem('GAME TYPE',NGameType[GameType]);
  Menu.AddValueItem('SKILL',IntToStr(GameSkill));
  Menu.AddImageItem('MAP',MapImage);
  Menu.AddTextItem('REDEFINE KEYS');
  Menu.AddTextItem('GAME OPTIONS');
  Menu.AddTextItem('EXIT');
  CurrentMenu:=bgMain;
  RedefineKeysMenu:=TRedefineKeysMenu.Create(MyDXInput);
  OptionsMenu:=TGameOptionsMenu.Create;
  MapMenu:=TMapMenu.Create;
end;

destructor TBeforeGameScreen.Destroy;
begin
  MapMenu.Free;
  OptionsMenu.Free;
  RedefineKeysMenu.Free;
  FreeAndNil(Menu);
  MapImage.Free;
  inherited;
end;

procedure TBeforeGameScreen.RefreshMapImage;
begin
  LoadHMapImage(MapImage.Canvas,0,0,MapName);
end;

Function TBeforeGameScreen.Step;
Var R:ShortInt;
begin
  Result:=0;
  If Not MyDXDraw.CanDraw then Exit;
  { Copyrights }
  With MyDXDraw.Surface.Canvas do
    Begin
      Brush.Style:=bsClear;
      Font.Size := 15;
      Font.Color:=clWhite;
      Font.Style:=[fsItalic];
      TextOut(20,420,'This program is freeware');
      TextOut(20,440,'stkolj.narod.ru');
      Font.Style:=[];
    End;
  Case CurrentMenu of
    bgRedefineKeys:If RedefineKeysMenu.Step(MoveCount) then
      Begin
        CurrentMenu:=bgMain;
        Exit;
      End;
    bgOptions:If OptionsMenu.Step(MoveCount) then
      Begin
        CurrentMenu:=bgMain;
        Exit;
      End;
    bgMap:If MapMenu.Step(MoveCount) then
      Begin
        CurrentMenu:=bgMain;
        RefreshMapImage;
        Exit;
      End;
    Else
      Menu.Paint(MyDXDraw.Surface.Canvas);
      MyDXDraw.Surface.Canvas.Release;
      With Menu do
        Begin
          R:=Input(MoveCount);
          If R=0 then Exit;
          If Items[NumSel].Name='START' then
            Begin
              Result:=1;
              CoopPlay:=True;
              If (NGameType[GameType]='DUEL') Or
                 (NGameType[GameType]='DM'  ) then
                CoopPlay:=False;
              WithoutEnemy:=(NGameType[GameType]='DUEL');
              PlayersCount:=pcTwoPlayers;
              If NGameType[GameType]='1 PL' then
                PlayersCount:=pcPlayer1;
              If NGameType[GameType]='2 PL' then
                PlayersCount:=pcPlayer2;
            End;
          If Items[NumSel].Name='GAME TYPE' then
            Begin
              Inc(GameType,R);
              If GameType<1 then GameType:=NGameTypeCount;
              If GameType>NGameTypeCount then GameType:=1;
              Items[NumSel].Value:=NGameType[GameType];
            End;
          If Items[NumSel].Name='SKILL' then
            Begin
              Inc(GameSkill,R);
              If GameSkill<1 then GameSkill:=MaxGameSkill;
              If GameSkill>MaxGameSkill then GameSkill:=1;
              Items[NumSel].Value:=IntToStr(GameSkill);
            End;
          If Items[NumSel].Name='EXIT' then
            Result:=2;
          If Items[NumSel].Name='REDEFINE KEYS' then
            Begin
              CurrentMenu:=bgRedefineKeys;
              Exit;
            End;
          If Items[NumSel].Name='MAP' then
            Begin
              CurrentMenu:=bgMap;
              Exit;
            End;
          If Items[NumSel].Name='GAME OPTIONS' then
            Begin
              CurrentMenu:=bgOptions;
              Exit;
            End;
        End;
  End;
end;

end.
