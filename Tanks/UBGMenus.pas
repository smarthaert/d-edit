unit UBGMenus;

interface

Uses UMyMenu,MapPreview,Graphics,SysUtils,DXInput,Types,DXDraws;

Const
  MapsPath='Maps\';
  MapMenuBorder=5;
  MapMenuImageSize=MapImageSize+MapMenuBorder*2;
  MapMenuX=50;
  MapMenuY=50;
  MapMenuDown=100;
  MapMenuRowCount=(480-MapMenuY-MapMenuDown) Div MapMenuImageSize;
  MapMenuColCount=(640-(MapMenuX*2)) Div MapMenuImageSize;
  MapMenuAD=10;

Type
  TSubMenu=Class(TObject)
  protected
    Menu:TMyMenu;
    Procedure Handle(Command:ShortInt;MI:PMyMenuItem); Virtual;
  public
    MenuName:ShortString;
    Constructor Create(AMenuName:ShortString);
    Destructor Destroy; Override;
    Function Step(MoveCount:Integer):Boolean;
  End;

Type
  TGameOptionsMenu=Class(TSubMenu)
  protected
    Procedure Handle(Command:ShortInt;MI:PMyMenuItem); Override;
  public
    Constructor Create;
    Function JeepsState:ShortString;
    Function MachinegunsState:ShortString;
  End;

Type
  TMapMenu=Class(TObject)
  public
    MapImages:Array of TBitmap;
    MapNames:Array of String;
    Sel,ColScroll:Integer;
    FirstStep:Boolean;
    NextKeyTime:LongInt;
    LAImage,RAImage:TPictureCollectionItem;
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Scan;
    Procedure ImagesFree;
    Function Step(MoveCount:Integer):Boolean;
    Procedure Paint;
  End;

Function BoolToOnOff(F:Boolean):ShortString;
Procedure DrawMenuCaption(MenuName:String);

implementation

Uses Pointers,UTankTypes,Main,UUnits;

{ Functions }

Function BoolToOnOff(F:Boolean):ShortString;
Begin
  If F then
    Result:='ON'
    Else
    Result:='OFF';
End;

Procedure DrawMenuCaption(MenuName:String);
Begin
  With MyDXDraw.Surface.Canvas do
    Begin
      Brush.Style:=bsClear;
      Font.Color:=clYellow;
      Font.Style:=[fsBold];
      TextOut(325-TextWidth(MenuName) Div 2,10,MenuName);
      Font.Style:=[];
    End;
End;

{ TGameOptionsMenu }

Procedure TSubMenu.Handle(Command:ShortInt;MI:PMyMenuItem);
Begin
  // Empty
End;

constructor TSubMenu.Create;
begin
  inherited Create;
  Menu:=TMyMenu.MyCreate(Nil,200,40);
  MenuName:=AMenuName;
end;

destructor TSubMenu.Destroy;
begin
  Menu.Free;
  inherited;
end;

function TSubMenu.Step(MoveCount: Integer): Boolean;
Var R:ShortInt;
begin
  Result:=False;
  If Not MyDXDraw.CanDraw then Exit;
  DrawMenuCaption(MenuName);
  Menu.Paint(MyDXDraw.Surface.Canvas);
  MyDXDraw.Surface.Canvas.Release;
  R:=Menu.Input(MoveCount);
  If R=0 then Exit;
  With Menu do
    Begin
      Result:=(Items[NumSel].Name='RETURN');
      Handle(R,Items[NumSel]);
    End;
end;

procedure TGameOptionsMenu.Handle(Command: ShortInt; MI: PMyMenuItem);
Var T:PTankType;
begin
  inherited;
  If MI.Typ<>itValue then Exit;
  If MI.Name='JEEPS' then
    Begin
      T:=TankTypes.getType('JEEP');
      If T=Nil then Exit;
      T.Enabled:=Not T.Enabled;
      { MI is type itValue }
      MI.Value:=JeepsState;
      Exit;
    End;
  If MI.Name='MACHINEGUNS' then
    Begin
      T:=TankTypes.getType('MACHINEGUN');
      If T=Nil then Exit;
      T.Enabled:=Not T.Enabled;
      { MI is type itValue }
      MI.Value:=MachinegunsState;
      Exit;
    End;
end;

function TGameOptionsMenu.MachinegunsState: ShortString;
Var T:PTankType;
begin
  T:=TankTypes.getType('MACHINEGUN');
  If T=Nil then
    Begin
      Result:='NOT LOADED';
      Exit;
    End;
  Result:=BoolToOnOff(T.Enabled);
end;

{ TGameOptionsMenu }

function TGameOptionsMenu.JeepsState: ShortString;
Var T:PTankType;
begin
  T:=TankTypes.getType('JEEP');
  If T=Nil then
    Begin
      Result:='NOT LOADED';
      Exit;
    End;
  Result:=BoolToOnOff(T.Enabled);
end;

constructor TGameOptionsMenu.Create;
begin
  Inherited Create('GAME OPTIONS');
  Menu.AddValueItem('JEEPS',JeepsState);
  Menu.AddValueItem('MACHINEGUNS',MachinegunsState);
  //Menu.AddValueItem('FIRES','');
  Menu.AddTextItem('RETURN');
end;

{ TMapPreviewMenu }

constructor TMapMenu.Create;
begin
  Inherited;
  SetLength(MapImages,0);
  SetLength(MapNames,0);
  Sel:=0;
  FirstStep:=True;
  ColScroll:=0;
  NextKeyTime:=MyMenuKeyDelay;
  LAImage:=MyDXImageList.Items.Find('Arrow L');
  RAImage:=MyDXImageList.Items.Find('Arrow R');
end;

destructor TMapMenu.Destroy;
begin
  ImagesFree;
  inherited;
end;

procedure TMapMenu.ImagesFree;
Var I:Integer;
begin
  For I:=0 to Length(MapImages)-1 do
    MapImages[I].Free;
end;

procedure TMapMenu.Paint;
Var
  I,X,Y,Scroll,Num:Integer;
  B:TRect;
begin
  Scroll:=ColScroll*MapMenuRowCount;
  B:=Bounds(MapMenuX,MapMenuY,
    MapMenuColCount*MapMenuImageSize,
    MapMenuRowCount*MapMenuImageSize);
  If Not MyDXDraw.CanDraw then Exit;
  DrawMenuCaption('MAPS');
  With MyDXDraw.Surface.Canvas do
    Begin
      Pen.Color:=clGreen;
      Brush.Style:=bsClear;
      Rectangle(B);
      For I:=0 to MapMenuColCount*MapMenuRowCount-1 do
        Begin
          Num:=Scroll+I;
          If Num>=Length(MapImages) then Break;
          X:=MapMenuX+MapMenuBorder+(I Div MapMenuRowCount)*MapMenuImageSize;
          Y:=MapMenuY+MapMenuBorder+(I Mod MapMenuRowCount)*MapMenuImageSize;
          With MapImages[Num] do
            Begin
              CopyRect(Bounds(X,Y,Width,Height),Canvas,Bounds(0,0,Width,Height));
              If Num=Sel then
                Begin
                  Pen.Style:=psDot;
                  Pen.Color:=clFuchsia;
                  Brush.Style:=bsClear;
                  Rectangle(Bounds(X-3,Y-3,Width+6,Height+6));
                  Pen.Style:=psSolid;
                End;
            End;
        End;
    End;
  MyDXDraw.Surface.Canvas.Release;
  With B do
    Y:=(Top+Bottom-LAImage.Height) Div 2;
  If ColScroll>0 then
    With LAImage do
      MyDXDraw.Surface.Draw(
        MapMenuX-MapMenuAD-Width,
        Y,
        PatternRects[0],PatternSurfaces[0],True);
  If ColScroll*MapMenuRowCount+MapMenuColCount*MapMenuRowCount<Length(MapImages) then
    With RAImage do
      MyDXDraw.Surface.Draw(
        MapMenuX+MapMenuAD+MapMenuColCount*MapMenuImageSize,
        Y,
        PatternRects[0],PatternSurfaces[0],True);
end;

procedure TMapMenu.Scan;
Var
  C,R,I:Integer;
  SR:TSearchRec;
begin
  Sel:=0;
  C:=0;
  R:=FindFirst(MapsPath+'*.*',faAnyFile-faDirectory-faVolumeID,SR);
  While (R=0) do
    Begin
      Inc(C);
      SetLength(MapNames,C);
      MapNames[C-1]:=MapsPath+SR.Name;
      If UpperCase(MapNames[C-1])=UpperCase(MapName) then
        Sel:=C-1;
      R:=FindNext(SR);
    End;
  FindClose(SR);
  ImagesFree;
  SetLength(MapImages,C);
  For I:=0 to C-1 do
    Begin
      MapImages[I]:=TBitmap.Create;
      With MapImages[I] do
        Begin
          Width:=MapImageSize;
          Height:=MapImageSize;
          LoadMapImage(Canvas,0,0,MapNames[I]);
        End;
    End;
  FirstStep:=False;
end;

function TMapMenu.Step(MoveCount: Integer): Boolean;
begin
  Result:=False;
  If FirstStep then
    Begin
      Scan;
      Exit;
    End;
  Paint;
  If Not HandleTimeDec(NextKeyTime,MoveCount) then Exit;
  If isUp in MyDXInput.States then
    If (Sel Mod MapMenuRowCount)>0 then
      Begin
        Dec(Sel);
        NextKeyTime:=MyMenuKeyDelay;
      End;
  If isDown in MyDXInput.States then
    If ((Sel Mod MapMenuRowCount)<MapMenuRowCount-1)And(Sel<Length(MapImages)-1) then
      Begin
        Inc(Sel);
        NextKeyTime:=MyMenuKeyDelay;
      End;
  If isLeft in MyDXInput.States then
    If Sel>=MapMenuRowCount then
      Begin
        Dec(Sel,MapMenuRowCount);
        If Sel<ColScroll*MapMenuRowCount then
          Dec(ColScroll);
        NextKeyTime:=MyMenuKeyDelay;
      End;
  If isRight in MyDXInput.States then
    If Sel<Length(MapImages)-MapMenuRowCount then
      Begin
        Inc(Sel,MapMenuRowCount);
        If Sel>ColScroll*MapMenuRowCount+MapMenuRowCount*MapMenuColCount-1 then
          Inc(ColScroll);
        NextKeyTime:=MyMenuKeyDelay;
      End;
  If isButton32 in MyDXInput.States then
    Begin
      MapName:=MapNames[Sel];
      Result:=True;
      FirstStep:=True;
      Exit;
    End;
end;

end.
