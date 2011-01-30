unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, MMSystem, Wave,UMap,UUnits,ULog,DIB,UBeforeGame,UMyMenu,Pointers,UTankTypes,
  URedefineKeys,UBonusSpawner,UFPS,USkill;

Const
  MaxKeyDelay=500;
  StartLives=3;

Var
  MapName:String='Maps\map.map';

Type
  TGameScreen=(gsNone,gsGame,gsBeforeGame);

type
  TMainForm = class(TDXForm)
    DXTimer: TDXTimer;
    DXDraw: TDXDraw;
    DXSpriteEngine: TDXSpriteEngine;
    DXInput: TDXInput;
    DXWaveList: TDXWaveList;
    DXSound: TDXSound;
    UnitsImageList: TDXImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXTimerDeactivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DXDrawRestoreSurface(Sender: TObject);
    //procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
    //  Y: Integer);
  private
    FMoveMode,FPaused: Boolean;
    FGameScreen:TGameScreen;
    procedure SetGameScreen(const Value: TGameScreen);
    procedure SetPaused(const Value: Boolean);
  public
    MapPicture:TDirectDrawSurface;
    PlayerDead:Array [1..2] of Boolean;
    BaseDead,ShowInfo,GameInitialized,ShowFPS:Boolean;
    GameMenu:TMyMenu;
    KeyDelay:LongInt;
    StartEnemyCount:Integer;
    Property Paused:Boolean
      Read FPaused
      Write SetPaused;
    Property GameScreen:TGameScreen
      Read FGameScreen
      Write SetGameScreen;
    Procedure GameStep(LagCount:Integer);
    Procedure BeforeGameStep(LagCount:Integer);
    Procedure InitBeforeGame;
    Procedure DoneBeforeGame;
    Procedure InitGame;
    Procedure DoneGame;
    Procedure CalcGameWin;
    Procedure HandleGameMenuInput(N:ShortInt);
    procedure NewGame;
    procedure EndGame;
    procedure GamePause;
    procedure TryPlayerSpawn(N:Byte);
    procedure UseParams;
    procedure DrawFPS;
    procedure GameWorldStep(MoveCount:Integer);
    procedure PL2Color(DIB:TDIB;TransparentColor:TColor);
  end;

var
  MainForm: TMainForm;

Procedure MergeColorTables(Var Main:TRGBQuads;A:TRGBQuads);

implementation

{$R *.DFM}

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
Var
  S:String;
begin
  if not DXDraw.CanDraw then exit;
  FPSCallCounter:=0;
  DXInput.Update;

  {  Description  }
  DXDraw.Surface.Fill(0);
  { Set font }
  With DXDraw.Surface.Canvas.Font do
    Begin
      Name:='CityBlueprint';
      Style:=[];
      Color:=clWhite;
      Size:=15;
    End;

  Case GameScreen of
    gsGame:
      GameStep(LagCount);
    gsBeforeGame:
      BeforeGameStep(LagCount);
    Else
      With DXDraw.Surface.Canvas do
        Begin
          Brush.Style := bsClear;
          Font.Size:=40;
          Font.Color:=clWhite;
          Font.Name:='Vernada';
          Font.Style:=[fsBold];
          S:='NONE';
          TextOut((640-TextWidth(S))Div 2,(480-TextHeight(S))Div 2,S);
          Release;
        End;
  End;

  if DXDraw=Nil then Exit;
  if not DXDraw.CanDraw then exit;
  If ShowFPS then DrawFPS;
  DXDraw.Flip;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled:=False;
  FreeAndNil(MapPicture);
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  MapPicture:=TDirectDrawSurface.Create(DXDraw.DDraw);
  DXTimer.Enabled:=True;
  //Paused:=False;
end;

function getB( C:TColor ):byte;
Begin
  getB:=(C and $FF0000) shr 16;
End;

function getG( C:TColor ):byte;
Begin
  getG:=(C and $00FF00) shr 8;
End;

function getR( C:TColor ):byte;
Begin
  getR:=C and $0000FF;
End;

Procedure MergeColorTables(Var Main:TRGBQuads;A:TRGBQuads);
Var I:Byte;
  Procedure AddColor;
  Var J:Byte;
  Begin
    For J:=0 to 255 do
      If DWORD(Main[J])=DWORD(A[I]) then Exit;
    // Skip 0 - black
    For J:=1 to 255 do
      If DWORD(Main[J])=0 then
        Begin
          Main[J]:=A[I];
          Exit;
        End;
  End;
Begin
  For I:=0 to 255 do
    AddColor;
End;

procedure TMainForm.FormCreate(Sender: TObject);
Const
  PlayerName='Tank Player';
var
  i{,x,y}: Integer;
  ET:TEnemyTank;
  //_RGB : TColor;
  //R,G,B,_R,_G,_B : Byte;
  DIB:TDIB;
  S:String;
  CT:TRGBQuads;
begin
  DXTimer.Enabled:=False;
  MyDXInput:=DXInput;
  MyDXDraw:=DXDraw;
  MyDXSpriteEngine:=DXSpriteEngine;
  MyDXTimer:=DXTimer;
  MyDXImageList:=UnitsImageList;
  UUnits.ImageList:=UnitsImageList;
  Randomize;
  FGameScreen:=gsNone;
  GameSkill:=DefaultGameSkill;
  CoopPlay:=True;
  WithoutEnemy:=False;
  ShowInfo:=True;
  ShowFPS:=False;
  GameInitialized:=False;
  PlayersCount:=pcTwoPlayers;
  StartEnemyCount:=0;
  FPaused:=True;
  CurrentMaxVisibleEnemies:=ConstMaxVisibleEnemies;
  BonusSpawner:=TBonusSpawner.Create;
  BonusSpawner.Add(TOneBonusSpawner.Create('Health',10000,3000));
  BonusSpawner.Add(TOneBonusSpawner.Create('Shield',BonusShieldTime*4,BonusShieldTime*2));
  MapContainer:=TMapContainer.Create(Nil,UnitsImageList);
  For I:=1 to 2 do
    Begin
      PlayerTanks[I]:=Nil;
      Lives[I]:=0;
      LivesDelay[I]:=0;
    End;

  {Оттенки танков}
  DIB := TDIB.Create;
  With UnitsImageList.Items do
    For I:=0 to Count-1 do
      Begin
        S:=Items[I].Name;
        If Length(S)<Length(PlayerName) then Continue;
        If Copy(S,1,Length(PlayerName))<>PlayerName then Continue;
        {For Dir:=0 to 3 do
          Begin
            Case Dir of
              0: Letter:='U';
              1: Letter:='D';
              2: Letter:='L';
              Else
                 Letter:='R';
            End;}
        With TPictureCollectionItem.Create(UnitsImageList.Items) do
          Begin
            Assign(Items[I]);
            //Picture.Assign(Items[I].Picture);
            //Picture.Bitmap.Assign(Items[I].Picture.Bitmap);
            //DIB.SetSize(Picture.Width,Picture.Height,16);
            //Picture.Bitmap.Canvas
            DIB.Assign(Picture);
            //DIB.BitCount:=32;
            //PatternSurfaces[0].Canvas
            PL2Color(DIB,TransparentColor);
            //Name:='Tank Player2 '+Letter;
            System.Delete(S,1,Length(PlayerName));
            Name:='Tank Player2'+S;
            Picture.Assign(DIB);
          End;
          //End;
      End;
  DIB.Free;

  // Палитра должна создаваться после создания всех картинок
  //ImageList.Items.MakeColorTable;
  UnitsImageList.Items.MakeColorTable;
  //MapImageList.Items.MakeColorTable;

  CT:=UnitsImageList.Items.ColorTable;
  //MergeColorTables(CT,MapImageList.Items.ColorTable);
  //MergeColorTables(CT,ImageList.Items.ColorTable);

  DXDraw.ColorTable := CT;
  DXDraw.DefColorTable := CT;
  DXDraw.UpdatePalette;
  {}
  //Log('Список всех спрайтов');
  //For I:=0 to (UUnits.ImageList.Items.Count-1) do
  //  Log(UUnits.ImageList.Items[I].Name);
  {}
  WeaponTypes:=TWeaponTypes.Create(Nil);
  if not WeaponTypes.Load('Texts\Weapons.txt') then
    Begin
      ShowMessage('Cann''t load Texts\Weapons.txt!');
      Application.Terminate;
    End;

  TankTypes:=TTankTypes.Create(Nil);
  if not TankTypes.Load('Texts\Tanks.txt') then
    Begin
      ShowMessage('Cann''t load Texts\Tanks.txt!');
      Application.Terminate;
    End;
  {GameMenu}
  GameMenu:=TMyMenu.MyCreate(Nil,320-100,100);
  With GameMenu do
    Begin
      AddTextItem('Continue');
      NumSel:=0;
      AddTextItem('Restart game');
      AddTextItem('Main menu');
      AddTextItem('Exit');
      Font.Color:=clWhite;
      Font.Name:='GothicE';
      Font.Size:=20;
      Font.Style:=[fsBold];
      SelFont.Assign(Font);
      SelFont.Color:=clBlue;
      FocusFrame:=False;
    End;

  KeyDelay:=0;

  //NewGame;
  {For I:=1 to 20 do
    With TBonus.Create(DXSpriteEngine.Engine) do
      Begin
        Init('Upgrade');
      End;}
  {For I:=1 to 10 do
    Begin
      ET:=TEnemyTank.Create(DXSpriteEngine.Engine);
      ET.Init(16+32*I,16+32*1,'Enemy');
    End;
  For I:=1 to 10 do
    Begin
      ET:=TEnemyTank.Create(DXSpriteEngine.Engine);
      ET.Init(16+32*I,16+32*2,'FatEnemy');
    End;
  For I:=1 to 10 do
    Begin
      ET:=TEnemyTank.Create(DXSpriteEngine.Engine);
      ET.Init(16+32*I,16+32*3,'Tiger');
    End;}
  {BS := TBackgroundSprite.Create(DXSpriteEngine.Engine);
  with BS do
  begin
    SetMapSize(2, 2);
    Image := ImageList.Items.Find('background');
    //BS.Chips
    Z := -2;
    Tile := True;
  end;

  for i:=0 to 96 do
    with TImageSprite.Create(DXSpriteEngine.Engine) do begin
      Image := ImageList.Items.Find('wall1');
      X := Random(100);
      Y := Random(100);
      Z := 1;
      Width := Image.Width;
      Height := Image.Height;
    end;

  for i:=0 to 200 do
    with TMonoSprite.Create(DXSpriteEngine.Engine) do
    begin
      Image := ImageList.Items.Find('img1');
      X := Random(5000)-2500;
      Y := Random(5000)-2500;
      Z := 2;
      Width := Image.Width;
      Height := Image.Height;
      FCounter := Random(MaxInt);
    end;}

  {PlayerSprite := TPlayerSprite.Create(DXSpriteEngine.Engine);
  with TPlayerSprite(PlayerSprite) do
  begin
    Image := ImageList.Items.Find('img2');
    Z := 2;
    Width := Image.Width;
    Height := Image.Height;
  end;}
  { * * * Use params * * * }
  UseParams;
  { BeforeGameScreen after TankTypes }
  BeforeGameScreen:=TBeforeGameScreen.Create(Nil);
  GameScreen:=gsBeforeGame;
  Paused:=False;
  DXTimer.Enabled:=True;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
// Debug
{Var S:String;}
begin
  // Dedug
  {if Key=Ord('U') then
     Begin
       If PlayerTanks[1]=Nil then Exit;
       S:=PlayerTanks[1].GetUpgrade;
       If S='' then Exit;
       PlayerTanks[1].SetTankType(S);
     End;}
  {if Key=Ord('B') then
    With TBonus.Create(DXSpriteEngine.Engine) do
      Init('');}
  // Show info
  if Key=VK_PAUSE then
    ShowFPS:=Not ShowFPS;
  // Show info
  if Key=VK_BACK then
    ShowInfo:=Not ShowInfo;
  (*{  Application end  }
  if Key=VK_PAUSE then
    Close;*)
  { Game Menu }
  if Key=VK_ESCAPE then
    GamePause;
  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.DXDrawClick(Sender: TObject);
begin
  {FMoveMode := not FMoveMode;
  if FMoveMode then
  begin
    DXTimer.Interval := 1000 div 60;
  end else
  begin
    DXTimer.Interval := 0;
  end;}
  GamePause;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  //Log('F0');
  //Log('F1');
  DXTimer.Enabled:=False;
  //Log('F2');
  BeforeGameScreen.Free;
  //Log('F3');
  TankTypes.Free;
  //Log('FW');
  WeaponTypes.Free;
  //Log('F4');
  MapContainer.Free;
  //Log('F5');
  //Log('F6');
  GameMenu.Free;
  //Log('F7');
  BonusSpawner.Free;
  //Log('F8');
  //DXDraw.Free;
  //Log('F9');
  {FreeAndNil(GameMenu);
  FreeAndNil(MapContainer);
  FreeAndNil(BeforeGameScreen);
  FreeAndNil(TankTypes);}
  {FreeAndNil(DXDraw);
  FreeAndNil(DXSpriteEngine);
  FreeAndNil(DXTimer);
  FreeAndNil(DXSound);
  FreeAndNil(DXInput);
  FreeAndNil(DXWaveList);
  FreeAndNil(ImageList);
  FreeAndNil(MapImageList);
  FreeAndNil(UnitsImageList);}

  {DXDraw.Free;
  DXSpriteEngine.Free;
  DXTimer.Free;
  DXSound.Free;
  DXInput.Free;
  DXWaveList.Free;
  ImageList.Free;
  MapImageList.Free;
  UnitsImageList.Free;}
end;

{procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If MapContainer.TankCanBeAt(Bounds(X-31,Y-31,32,32)) then
    Caption:='Yes'
    Else
    Caption:='No';
end;}

procedure TMainForm.GameStep(LagCount:Integer);
  Procedure DrawState(S:String;Row:Integer);
  Const
    MaxRow=2;
  Begin
    With DXDraw.Surface.Canvas do
      Begin
        Brush.Style := bsClear;
        Font.Size:=40;
        Font.Color:=clBlack;
        Font.Name:='Vernada';
        Font.Style:=[fsBold];
        TextOut((640-TextWidth(S))Div 2,480*Row Div (MaxRow+1)-(TextHeight(S)Div 2),S);
      End;
  End;
  Procedure DrawDeathMatchState;
  Begin
    If (PlayerDead[1]And PlayerDead[2])Or(BaseDead And Not WithoutEnemy) then
      Begin
        DrawState('DRAW GAME',2);
        Exit;
      End;
    If PlayerDead[1] then DrawState('PLAYER 2 WIN',2);
    If PlayerDead[2] then DrawState('PLAYER 1 WIN',2);
  End;
  Procedure DrawCoopState;
  Begin
    If (PlayerDead[1]And PlayerDead[2])Or BaseDead then
      Begin
        DrawState('GAME OVER',2);
        Exit;
      End;
    If EnemyCount=0 then DrawState('YOU WIN',2);
  End;
  Procedure DrawInfo;
  Var
    I:Byte;
    DX,DY:Integer;
    S:String;
  Begin
    With DXDraw.Surface.Canvas do
      Begin
        Brush.Style := bsClear;
        Font.Size:=8;
        Font.Color:=clWhite;
        Font.Name:='Vernada';
        Font.Style:=[fsBold];
        For I:=1 to 2 do
          Begin
            If PlayerStartPos[I].X=-1 then Continue;
            DX:=MapToPixel(PlayerStartPos[I].X);
            DY:=MapToPixel(PlayerStartPos[I].Y);
            S:=IntToStr(Lives[I]);
            TextOut(DX+16-(TextWidth(S) Div 2),DY+5,S);
            If PlayerTanks[I]=Nil then Continue;
            If Not PlayerTanks[I].Alive then Continue;
            S:=IntToStr(PlayerTanks[I].Life*100 Div PlayerTanks[I].GetMaxLife)+'%';
            TextOut(DX+16-(TextWidth(S) Div 2),DY+20,S);
          End;
        S:='Enemy: '+IntToStr(EnemyCount)+'/'+IntToStr(StartEnemyCount);
        TextOut(5,5,S);
      End;
  End;
Var
  I,J:Integer;
  {S:String;
  N:ShortInt;}
  SpritesLagCount:Integer;
begin
  if FMoveMode then
    LagCount := 1000 div 60;

  SpritesLagCount:=LagCount;
  HandleTimeDec(KeyDelay,LagCount);

  If SpritesLagCount>60 then SpritesLagCount:=60;
  //If LagCount<20 then LagCount:=20;

  If (Not Paused)And(KeyDelay=0) then
    Begin
      {For I:=1 to SpritesLagCount Div 20 do
          GameWorldStep(20);}
      GameWorldStep(SpritesLagCount);
    End;

  CalcGameWin;

  {  Description  }
  MapContainer.PaintMap(MapPicture);

  DXDraw.Surface.Draw(0,0,MapPicture.ClientRect,MapPicture,False);

  if not DXDraw.CanDraw then exit;

  DXSpriteEngine.Draw;

  {  Frame rate display  }
  with DXDraw.Surface.Canvas do
  begin
    (*Brush.Style := bsClear;
    Font.Color := clWhite;
    Font.Size := 12;
    Textout(0, 0, 'FPS: '+inttostr(DXTimer.FrameRate));
    Textout(0,24, 'Sprite: '+inttostr(DXSpriteEngine.Engine.AllCount));
    Textout(0, 48, 'Draw: '+inttostr(DXSpriteEngine.Engine.DrawCount));
    if FMoveMode then
      Textout(0, 72, 'Time mode: 60 FPS')
    else
      Textout(0, 72, 'Time mode: Real time');*)
    If ShowInfo then DrawInfo;
    If Paused then GameMenu.Paint(DXDraw.Surface.Canvas);
    If CoopPlay then
      DrawCoopState
      Else
      DrawDeathMatchState;
    Release;
  end;

  If Paused {And(KeyDelay=0)} then HandleGameMenuInput(GameMenu.Input(LagCount));
end;

procedure TMainForm.BeforeGameStep;
Var IR:Integer;
begin
  IR:=BeforeGameScreen.Step(LagCount);
  Case IR of
    1:
    Begin
      NewGame;
      GameScreen:=gsGame;
    End;
    2:Close;
  End;
end;

procedure TMainForm.SetGameScreen(const Value: TGameScreen);
begin
  Case FGameScreen of
    gsGame:DoneGame;
    gsBeforeGame:DoneBeforeGame;
  End;
  FGameScreen := Value;
  If Value<>gsNone then
    DXInput.States:=[];
  Case Value of
    gsGame:InitGame;
    gsBeforeGame:InitBeforeGame;
  End;
end;

procedure TMainForm.DoneBeforeGame;
begin

end;

procedure TMainForm.DoneGame;
begin

end;

procedure TMainForm.InitBeforeGame;
begin

end;

procedure TMainForm.InitGame;
Var I:Byte;
Begin
  If Not GameInitialized then ShowMessage('Game screen without game initialized');
  For I:=1 to 2 do
    PlayerDead[I]:=False;
end;

procedure TMainForm.CalcGameWin;
Var I:Byte;
begin
  For I:=1 to 2 do
    PlayerDead[I]:=((PlayerTanks[I]=Nil)And(Lives[I]<=0));
  BaseDead:=(BasesCount=0);
end;

procedure TMainForm.SetPaused(const Value: Boolean);
begin
  If FPaused<>Value then
    KeyDelay:=MaxKeyDelay;
  FPaused := Value;
  If Value then
    Caption:=Application.Title+'-PAUSE'
    Else
    Caption:=Application.Title;
end;

procedure TMainForm.DXTimerDeactivate(Sender: TObject);
begin
  GamePause;
end;

procedure TMainForm.HandleGameMenuInput(N: ShortInt);
Var S:ShortString;
begin
  If N=0 then Exit;
  With GameMenu do
    S:=UpperCase(Items[NumSel].Name);
  If S='CONTINUE' then
    Begin
      Paused:=False;
      Exit;
    End;
  If S='EXIT' then
    Begin
      Close;
      Exit;
    End;
  If S='MAIN MENU' then
    Begin
      Paused:=False;
      EndGame;
      //NewGame;
      GameScreen:=gsBeforeGame;
      Exit;
    End;
  If S='RESTART GAME' then
    Begin
      Paused:=False;
      EndGame;
      NewGame;
      Exit;
    End;
end;

procedure TMainForm.NewGame;
  Procedure StartPlayer(N:Byte);
  Begin
    If PlayerStartPos[N].X=-1 then Exit;
    If CoopPlay then
      Lives[N]:=StartLives
      Else
      Lives[N]:=1;
    PlayerTanks[N]:=TPlayerTank.Create(DXSpriteEngine.Engine);
    PlayerTanks[N].TestInit(N,PlayerStartPos[N].X,PlayerStartPos[N].Y);
  End;
Var I:Byte;
begin
  For I:=1 to 2 do
    Begin
      PlayerTanks[I]:=Nil;
      PlayerStartPos[I]:=Point(-1,-1);
      Lives[I]:=0;
      LivesDelay[I]:=0;
    End;
  LoadMap(MapName,DXSpriteEngine.Engine);
  Case PlayersCount of
    pcPlayer1:
      StartPlayer(1);
    pcPlayer2:
      StartPlayer(2);
    Else
      StartPlayer(1);
      StartPlayer(2);
  End;
  StartEnemyCount:=EnemyCount;
  BonusSpawner.Reset;
  BonusSpawner.SetEnabled('Shield',CoopPlay);
  GameInitialized:=True;
end;

procedure TMainForm.EndGame;
Var I:Integer;
begin
  With DXSpriteEngine.Engine do
    For I:=0 to Count-1 do
      Items[I].Dead;
  DXSpriteEngine.Dead;
  GameInitialized:=False;
end;

procedure TMainForm.GamePause;
begin
  If GameScreen=gsGame then Paused:=True;
end;

procedure TMainForm.TryPlayerSpawn(N: Byte);
Var X,Y:Integer;
begin
  X:=MapToPixel(PlayerStartPos[N].X);
  Y:=MapToPixel(PlayerStartPos[N].Y);
  If Not RectEmpty(Bounds(X,Y,31,31),TTank) then Exit;
  PlayerTanks[N]:=TPlayerTank.Create(DXSpriteEngine.Engine);
  PlayerTanks[N].TestInit(N,PlayerStartPos[N].X,PlayerStartPos[N].Y);
end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  GamePause;
end;

procedure TMainForm.UseParams;
Var
  I,N:Integer;
  S,U,V:String;
  TT:PTankType;
  Function OptionIs(N:String):Boolean;
  Begin
    Result:=False;
    If Length(U)<Length(N) then Exit;
    If Copy(U,1,Length(N))<>N then Exit;
    Result:=True;
    V:=Copy(S,Length(N)+1,Length(S)-Length(N));
  End;
begin
  If ParamCount=0 then Exit;
  MapName:=ParamStr(ParamCount);
  For I:=1 to ParamCount-1 do
    Begin
      S:=ParamStr(I);
      U:=UpperCase(S);
      If OptionIs('-SKILL') then
        Begin
          N:=StrToIntDef(V,GameSkill);
          If (N>=1)And(N<=MaxGameSkill) then
            GameSkill:=N;
        End;
      If OptionIs('-NOJEEPS') then
        Begin
          TT:=TankTypes.getType('Jeep');
          If TT<>Nil then TT.Enabled:=False;
        End;
      If OptionIs('-NOMACHINEGUNS') then
        Begin
          TT:=TankTypes.getType('Machinegun');
          If TT<>Nil then TT.Enabled:=False;
        End;
      If OptionIs('-GAMETYPE') then
        ;
    End;
end;

procedure TMainForm.DrawFPS;
begin
  If Not DXDraw.CanDraw then Exit;
  With DXDraw.Surface.Canvas do
    Begin
      Brush.Style := bsClear;
      Font.Color := clWhite;
      Font.Size := 12;
      Font.Style:=[];
      Textout(0,380, 'FPSCallCounter: '+inttostr(FPSCallCounter));
      Textout(0,400, 'FPS: '+inttostr(DXTimer.FrameRate));
      Textout(0,420, 'Sprite: '+inttostr(DXSpriteEngine.Engine.AllCount));
      Textout(0,440, 'Draw: '+inttostr(DXSpriteEngine.Engine.DrawCount));
      if FMoveMode then
        Textout(0,460, 'Time mode: 60 FPS')
      else
        Textout(0,460, 'Time mode: Real time');
      Release;
    End;
end;

procedure TMainForm.GameWorldStep(MoveCount: Integer);
Var J:Integer;
begin
  BonusSpawner.Step(MoveCount);
  {If Random(BonusTime Div 20)=0 then
    With TBonus.Create(Engine) do
      Init('Health');
  If CoopPlay then
    If Random(BonusShieldTime*5 Div 20)=0 then
      With TBonus.Create(Engine) do
        Init('Shield');}
  For J:=1 to 2 do
    If (Lives[J]>0)And(PlayerTanks[J]=Nil) then
      If HandleTimeDec(LivesDelay[J],MoveCount) then
        TryPlayerSpawn(J);
  With DXSpriteEngine do
    Begin
      Move(MoveCount);
      Dead;
    End;
end;

procedure TMainForm.PL2Color(DIB: TDIB;TransparentColor:TColor);
Var
  i,x,y: Integer;
  _RGB : TColor;
  R,G,B,_R,_G,_B,Gray : Byte;
  S:String;
begin
  For X:=0 to DIB.Width-1 do
    For Y:=0 to DIB.Height-1 do
      Begin
        _RGB :=DIB.Canvas.Pixels[X,Y];
        If _RGB=TransparentColor then Continue;
        R := getR(_RGB);
        G := getG(_RGB);
        B := getB(_RGB);
        Gray:=R;
        If G<Gray then Gray:=G;
        If B<Gray then Gray:=B;
        {_R:=(R*3+G) Div 4;
        _G:=(G*3+B) Div 4;
        _B:=(B*3+R) Div 4;}
        _R:=Gray+(R-Gray)*3 Div 4;
        _G:=Gray+(G-Gray)*3 Div 4;
        _B:=Gray+(B-Gray)*3 Div 4;
        DIB.Canvas.Pixels[X,Y] := RGB(_R,_G,_B);
      End;
end;

procedure TMainForm.DXDrawRestoreSurface(Sender: TObject);
begin
  MapPicture.SetSize(DXDraw.Width,DXDraw.Height);
  MapContainer.FullPaintMap(MapPicture);
end;

end.

