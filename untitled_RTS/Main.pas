unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, DIB, DXWStatObj, DXWPath, DXWNavigator,
  Wave, MMSystem, IniFiles, Z_prof ;

const
 FullScreen=true;
 //FullScreen=false;

type
  TGameScene = (
                 gsNone,
                 gsTitle,
                 gsMainMenu,
                 gsMain,
                 gsGameOver
                );

  TGameSubScene = (
                   gssNone,
                   gssMenu
                  );


  TMainForm = class(TDXForm)

    DXTimer      : TDXTimer;
    DXDraw       : TDXDraw;
    SpriteEngine : TDXSpriteEngine;
    DXInput      : TDXInput;
    ImageList    : TDXImageList;
    DXWaveList   : TDXWaveList;
    DXSound      : TDXSound;
    TmpImageList1: TDXImageList;
    TmpImageList2: TDXImageList;
    CursorImageList: TDXImageList;

    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure DXDrawInitializing(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXSoundInitialize(Sender: TObject);
  private

    FBlink     : Integer;
    FBlinkTime : Integer;

    procedure BlinkStart;
    procedure BlinkUpdate;

    procedure StartSceneTitle;
    procedure SceneTitle;
    procedure EndSceneTitle;


    procedure StartSceneGameOver;
    procedure SceneGameOver;
    procedure EndSceneGameOver;

    procedure EndScene;

    //MainMenu
    procedure StartSceneMainMenu;
    procedure SceneMainMenu;
    procedure EndSceneMainMenu;
    procedure SceneMainMenuMouseDown(Shift: TShiftState; X, Y: Integer);
    procedure SceneMainMenuMouseUp(Shift: TShiftState; X, Y: Integer);

  Public
    FScene     : TGameScene;
    FNextScene : TGameScene;

    procedure PrintScreen;

    procedure PlaySound(const Name: string; Wait: Boolean);
    procedure StartScene(Scene: TGameScene);
    procedure LoadWaves;
    procedure SavePicData(var DXImageList: TDXImageList; FileName: string);
    procedure LoadPicData(var DXImageList: TDXImageList; FileName: string);

  end;


var
  MainForm                 : TMainForm;
  FBtnList                 : TList;
  SubSceneMainMenuEnabled  : Boolean;

  MapDownPointX       : Double;
  MapDownPointY       : Double;

  MouseXY             : TPoint;
  DimW,DimH           : Integer;
  MapW,MapH           : Integer;
  ChipW,ChipH         : Integer;
  PathInf             : TDXPath;
  Navigator           : TDXWNavigator;

  JobList             : TStringList;

  DXRed,DXBlue,DXYellow,DXGreen,DXLime : Integer;

  function  FindPath(StartPos,EndPos : TPoint) : Boolean;
  Function  Sign(x : double): integer ;
  function GetFirstToken(S: string; Token: Char): string;

implementation
{$R *.DFM}
Uses  Menu,Pathes, GameSpritesUnit,SceneMainUnit,JPEG;


Const
 DXInputButton = [isButton1, isButton2, isButton3,
 isButton4, isButton5, isButton6, isButton7, isButton8, isButton9, isButton10, isButton11,
 isButton12, isButton13, isButton14, isButton15, isButton16, isButton17, isButton18,
 isButton19, isButton20, isButton21, isButton22, isButton23, isButton24, isButton25,
 isButton26, isButton27, isButton28, isButton29, isButton30, isButton31, isButton32];


Var
 PlayerDirection : integer;
 //PX,PY           : Double;
 //WPX,WPY         : Double;


Function Sign(x : double): integer ;
begin
 if X>0 then Result:=1  else Result:=-1;
end;

{
Function GradToRad( A : Double):Double;
begin
  Result:=A*Pi/180;
end;

Function RadToGrad( A : Double):Double;
begin
 Result:=A*180/Pi;
end;
}

function FindPath(StartPos,EndPos : TPoint) : Boolean;
begin
 PathInf.FStartPos:=StartPos;
 PathInf.FEndPos:=EndPos;
 Result:=PathInf.FindPath;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  JobList:=TStringList.Create;

  Cursor:=crNone;

  SubSceneMainMenuEnabled:=False;
  FBtnList:=TList.Create;

  //RandSeed:=GetTickCount;

  FScene:=gsNone;
  FNextScene:=gsNone;

  if FullScreen then
   begin
    BorderStyle := bsNone;
    DXDraw.Options := DXDraw.Options + [doFullScreen];
   end;

  DXDraw.Initialize;
  DXSound.Initialize;

  LoadWaves;

  //StartScene(gsTitle);
  //StartScene(gsMainMenu);
  StartScene(gsMain);

end;

procedure TMainForm.FormDestroy(Sender: TObject);
Var
i: integer;
begin
JobList.Free;
DXTimer.Enabled := False;

PathInf.Free;

For i:=0 to FBtnList.Count-1
 do TDXImageButton(FBtnList[i]).free;
FBtnList.Clear;
FBtnList.Free;
end;

procedure TMainForm.DXDrawInitializing(Sender: TObject);
begin
 DXDraw.Cursor := crNone;
end;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
 DXTimer.Enabled := True;

 DXRed:=DXDraw.Surface.ColorMatch(clRed);
 DXBlue:=DXDraw.Surface.ColorMatch(clBlue);
 DXYellow:=DXDraw.Surface.ColorMatch(clYellow);
 DXGreen:=DXDraw.Surface.ColorMatch(clGreen);
 DXLime:=DXDraw.Surface.ColorMatch(clLime);

end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
 Const
  Counter : LongInt=0;
  CursorPatternIndex : Integer=0;
begin
  if not DXDraw.CanDraw then exit;

  DXInput.Update;

  case FScene of
    gsTitle    : SceneTitle;
    gsMain     : SceneMain;
    gsMainMenu : SceneMainMenu;
    gsGameOver : SceneGameOver;
  end;


  If Counter=10 then
  begin
   Inc(CursorPatternIndex);
   Counter:=0;
   if CursorPatternIndex>4  then CursorPatternIndex:=0;
  end
   else Inc(Counter);

  if (FScene<>gsTitle)
   then CursorImageList.Items.Find('CursorNormal').Draw(DXDraw.Surface,mouseXY.x,mouseXY.y, CursorPatternIndex);
   //then CursorImageList.Items.Find('CursorAttack').Draw(DXDraw.Surface,mouseXY.x,mouseXY.y, CursorPatternIndex);

  if FNextScene<>gsNone then
  begin
    StartScene(FNextScene);
    FNextScene := gsNone;
  end;

  DXDraw.Flip;

end;

procedure TMainForm.BlinkStart;
begin
  FBlink := 0;
  FBlinkTime := GetTickCount;
end;

procedure TMainForm.BlinkUpdate;
begin
  if GetTickCount<>FBlinkTime then
  begin
    FBlink := FBlink + (GetTickCount-FBlinkTime);
    FBlinkTime := GetTickCount;
  end;
end;

procedure TMainForm.PlaySound(const Name: string; Wait: Boolean);
begin
 DXWaveList.Items.Find(Name).Play(Wait);
end;

procedure TMainForm.StartScene(Scene: TGameScene);
begin
  EndScene;
  DXInput.States := DXInput.States - DXInputButton;
  FScene := Scene;
  case FScene of
    gsTitle   : StartSceneTitle;
    gsMain    : StartSceneMain;
    gsMainMenu: StartSceneMainMenu;
    gsGameOver: StartSceneGameOver;
  end;
end;

//..........................................................................
//.....................................................................
procedure TMainForm.StartSceneTitle;
Var
FileName    : string;
Item        : TPictureCollectionItem;
NewGraphic  : TDIB;
begin
 FileName:='GameTitl.dxg';
 LoadPicData(TmpImageList1,FileName);
 SavePicData(TmpImageList1,FileName);

{
  NewGraphic := TDIB.Create;
  //NewGraphic.SetSize(320,240,24);
  try
    NewGraphic.LoadFromFile(GetName('Graphics\bmp','GameTitle.bmp'));
    Item := TPictureCollectionItem.Create(TmpImageList1.Items);
    //Item.Picture.LoadFromFile(GetName('Graphics\bmp','GameTitle.bmp'));
    //Item.Picture.Assign(TGraphic(NewGraphic));
    Item.Picture.Graphic := NewGraphic;
    //Item.Name:='GameTitle';
  finally
    NewGraphic.Free;
  end;

 //TmpImageList1.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
}


end;

//......................................................................

procedure TMainForm.SavePicData(var DXImageList : TDXImageList; FileName : string);
Var
 i           : integer;
 Item        : TPictureCollectionItem;
 SectionName : string;
 Ident       : string;
begin
FileName:=ChangeFileExt(FileName,'.dat');

if FileExists(GetName('Graphics\data',FileName)) then Exit;
With TIniFile.Create(GetName('Graphics\data',FileName)) do
 try
 For i:=0 to DXImageList.Items.Count-1 do
  begin
   Item:=DXImageList.Items[i];
   SectionName:=Item.Name;

   Ident:='PictureHeight';
   WriteInteger(SectionName,Ident,Item.Picture.Height);
   Ident:='PictureWidth';
   WriteInteger(SectionName,Ident,Item.Picture.Width);

   Ident:='PatternHeight';
   WriteInteger(SectionName,Ident,Item.PatternHeight);
   Ident:='PatternWidth';
   WriteInteger(SectionName,Ident,Item.PatternWidth);

   Ident:='SkipHeight';
   WriteInteger(SectionName,Ident,Item.SkipHeight);
   Ident:='SkipWidth';
   WriteInteger(SectionName,Ident,Item.SkipWidth);

   Ident:='SystemMemory';
   WriteBool(SectionName,Ident,Item.SystemMemory);

   Ident:='Transparent';
   WriteBool(SectionName,Ident,Item.Transparent);

   Ident:='TransparentColor';
   WriteString(SectionName,Ident,ColorToString(Item.TransparentColor));

  end;

 Finally
  Free;
 end;

end;

Procedure TMainForm.LoadPicData( var DXImageList : TDXImageList; FileName : string);
Var
 i           : integer;
 Item        : TPictureCollectionItem;
 SectionName : string;
 Ident       : string;
 NewGraphic  : TDIB;
 BitMap      : TBitMap;
 DXGFileName : string;
 PicFileName : string;
 SectionList : TStringList;
 JpgImg      : TJPEGImage;
 Ext         : String;
begin
DXImageList.Items.Clear;

DXGFileName:=GetName('Graphics\DXG',ChangeFileExt(FileName,'.dxg'));
if FileExists(DXGFileName) then
 begin
  DXImageList.Items.LoadFromFile(DXGFileName);
  Exit;
 end;

FileName:=ChangeFileExt(FileName,'.dat');
NewGraphic  := TDIB.Create;
BitMap      := TBitMap.Create;

SectionList := TStringList.Create;

try
With TIniFile.Create(GetName('Graphics\data',FileName)) do
 try
 ReadSections(SectionList);
 For i:=0 to SectionList.Count-1 do
  begin
  SectionName:=SectionList[i];

  Ext:='bmp';
  PicFileName:=GetName('Graphics',Ext+'\'+SectionName+'.'+Ext);

  if FileExists(PicFileName) then
   begin
    NewGraphic.LoadFromFile(PicFileName);
   end
  else
   begin

    Ext:='jpg';
    PicFileName:=GetName('Graphics',Ext+'\'+SectionName+'.'+Ext);
    JpgImg:=TJPEGImage.Create;
    try
     JpgImg.LoadFromFile(PicFileName);
     NewGraphic.Assign(JpgImg);
    finally
     JpgImg.Free;
    end;

   end;

   Item := TPictureCollectionItem.Create(DXImageList.Items);
   Item.Picture.Graphic := NewGraphic;

   Item.Name:=SectionName;

   Ident:='PatternHeight';
   Item.PatternHeight:=ReadInteger(SectionName,Ident,0);
   Ident:='PatternWidth';
   Item.PatternWidth:=ReadInteger(SectionName,Ident,0);

   Ident:='SkipHeight';
   Item.SkipHeight:=ReadInteger(SectionName,Ident,0);
   Ident:='SkipWidth';
   Item.SkipWidth:=ReadInteger(SectionName,Ident,0);

   Ident:='SystemMemory';
   Item.SystemMemory:=ReadBool(SectionName,Ident,false);

   Ident:='Transparent';
   Item.Transparent:=ReadBool(SectionName,Ident,false);

   Ident:='TransparentColor';
   Item.TransparentColor:=StringToColor(ReadString(SectionName,Ident,'clBlack'));
   Item.Restore;
  end;

 Finally
  Free;
 end;

Finally
 NewGraphic.Free;
 BitMap.Free;
 SectionList.Free;
end;


//DXImageList.DXDraw:=nil;
//DXImageList.DXDraw:=DXDraw;// do not work without it !!!!! ???????????

end;

procedure TMainForm.StartSceneMainMenu;
Var
FileName : string;
begin
 FileName:='MainMenu.dxg';
 LoadPicData(TmpImageList1,FileName);
 //TmpImageList1.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
 SavePicData(TmpImageList1,FileName);

FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
   Image := MainForm.TmpImageList1.Items.Find('BtnMainMenu');
   Width := Image.Width;
   Height := Image.Height;
   X := 200;
   Y := 240;
   Surface:=DXDraw.Surface;
   Caption:='Single Player Game';
   end;

FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
   Image := MainForm.TmpImageList1.Items.Find('BtnMainMenu');
   Width := Image.Width;
   Height := Image.Height;
   X := 200;
   Y := 276;
   Surface:=DXDraw.Surface;
   Caption:='Multi Player Game';
   end;

FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
   Image := MainForm.TmpImageList1.Items.Find('BtnMainMenu');
   Width := Image.Width;
   Height := Image.Height;
   X := 200;
   Y := 312;
   Surface:=DXDraw.Surface;
   Caption:='Replay Introduction';
   end;

FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
   Image := MainForm.TmpImageList1.Items.Find('BtnMainMenu');
   Width := Image.Width;
   Height := Image.Height;
   X := 200;
   Y := 348;
   Surface:=DXDraw.Surface;
   Caption:='Show Credits';
   end;

FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
   Image := MainForm.TmpImageList1.Items.Find('BtnMainMenu');
   Width := Image.Width;
   Height := Image.Height;
   X := 200;
   Y := 384;
   Surface:=DXDraw.Surface;
   Caption:='Exit Program';
   end;

end;


//........................................................................
procedure TMainForm.StartSceneGameOver;
Var
FileName : string;
begin
 FileName:='GameOver.dxg';
 LoadPicData(TmpImageList1,FileName);
 //TmpImageList1.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
 SavePicData(TmpImageList1,FileName);
end;
//..........................................................................

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
procedure TMainForm.EndScene;
begin
  case FScene of
    gsTitle   : EndSceneTitle;
    gsMain    : EndSceneMain;
    gsMainMenu: EndSceneMainMenu;
    gsGameOver: EndSceneGameOver;
  end;
end;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

procedure TMainForm.EndSceneTitle;
begin
 TmpImageList1.Items.Clear;
end;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

procedure TMainForm.EndSceneMainMenu;
Var
i : integer;
begin
TmpImageList1.Items.Clear;

For i:=0 to FBtnList.Count-1
 do TDXImageButton(FBtnList[i]).free;
FBtnList.Clear;

end;

procedure TMainForm.EndSceneGameOver;
begin
TmpImageList1.Items.Clear;
Close;
end;
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

//////////////////////////////////////////////////////////////////////
procedure TMainForm.SceneTitle;
var
  r    : TRect;
  Logo: TPictureCollectionItem;
begin
  BlinkUpdate;

  DXDraw.Surface.Fill(0);

  Logo:= TmpImageList1.Items[0];
  r:=Bounds((640-Logo.Width)div 2,(480-Logo.Height)div 2,Logo.Width, Logo.Height);

  //Logo.DrawWaveX(DXDraw.Surface,(640-Logo.Width)div 2,(480-Logo.Height)div 2,Logo.Width,Logo.Height,0,Trunc(4-Cos256(FBlink div 10)*4),200,FBlink div 6);
  Logo.DrawAlpha(DXDraw.Surface,r,0,Trunc(255-Sin256(FBlink div 30)*150));

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clRed;
    Textout(20, 20, 'FPS: '+inttostr(DXTimer.FrameRate));
    Release;
  end;

  if DXInput.States<>[] then
  begin
    //PlaySound('SceneMov', False);
    //Sleep(300);
    StartScene(gsMainMenu);
  end;

end;
////////////////////////////////////////////////////////////////////////
procedure TMainForm.SceneMainMenu;
Var
i : integer;
begin
//DXDraw.Surface.Fill(0);

TmpImageList1.Items[0].Draw(DXDraw.Surface, 0, 0, 0);

For i:=0 to FBtnList.Count-1
 do TDXImageButton(FBtnList[i]).DrawSelf;


  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Color := clRed;
    Font.Name := 'MS Sans Serif';
    Font.Size := 8;
    Textout(20, 20, 'FPS: '+inttostr(DXTimer.FrameRate));
    Release;
  end;


if isButton1 in DXInput.States then
  begin
    //PlaySound('SceneMov', False);
    //Sleep(200);
    StartScene(gsMain);
  end;

end;

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////

procedure TMainForm.SceneGameOver;
Const
 Counter : Integer=0;
 Mode    : Integer=0;
begin

  DXDraw.Surface.Fill(0);
  TmpImageList1.Items[0].Draw(DXDraw.Surface, 0, 0, 0);

  with DXDraw.Surface.Canvas do
  begin
    Brush.Style := bsClear;
    if ( (FBlink div 300) mod 2=0 )
    and (Mode=0)then
    begin
      Font.Color := clRed;
      Font.Size := 30;
      Font.Name:='Times New Roman';
      Textout(160, 420, 'Push ''Spase to Exit ''  ');
    end;
    BlinkUpdate;
    Font.Name := 'MS Sans Serif';
    Font.Size := 8;
    Textout(20, 20, 'FPS: '+inttostr(DXTimer.FrameRate));
    Release;
  end;

  if ( isButton1 in DXInput.States ) and (Mode=0) then
  begin
    //PlaySound('SceneMov', False);
    Mode:=1;
  end;

  If Mode=1 then Inc(Counter);
  If Counter> 200 then EndSceneGameOver;

end;

procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
MouseXY:=Point(X,Y);
if FScene=gsMain then SceneMainMouseMove(Shift,X,Y);
end;

procedure TMainForm.DXDrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
case FScene of
 //gsTitle   : SceneTitleMouseDown(Shift: TShiftState; X, Y: Integer);
 gsMain     : SceneMainMouseDown(Shift,X,Y);
 gsMainMenu : SceneMainMenuMouseDown(Shift,X,Y);
 //gsGameOver: SceneGameOverMouseDown(Shift: TShiftState; X, Y: Integer);
end;
end;


procedure TMainForm.DXDrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
case FScene of
// gsTitle   : SceneTitleMouseDown(Shift: TShiftState; X, Y: Integer);
 gsMain    : SceneMainMouseUp(Shift,X,Y);
 gsMainMenu: SceneMainMenuMouseUp(Shift,X,Y);
// gsGameOver: SceneGameOverMouseDown(Shift: TShiftState; X, Y: Integer);
end;
end;


procedure TMainForm.SceneMainMenuMouseUp(Shift: TShiftState; X, Y: Integer);
Var
 i          : integer;
begin
if TDXImageButton(FBtnList[0]).Selected then
 begin
  TDXImageButton(FBtnList[0]).Selected:=False;
  StartScene(gsMain);
  Exit;
 end;

if TDXImageButton(FBtnList[4]).Selected then
 begin
  TDXImageButton(FBtnList[4]).Selected:=False;
  StartScene(gsGameOver);
  Exit;
 end;

For i:=0 to FBtnList.Count-1
 do TDXImageButton(FBtnList[i]).Selected:=False;

end;

procedure TMainForm.SceneMainMenuMouseDown(Shift: TShiftState; X, Y: Integer);
Var
 i         : integer;
 DownPoint : TPoint;
 r          : TRect;
begin
DownPoint:=Point(x,y);
For i:=0 to FBtnList.Count-1 do
  begin
   r:=TDXImageButton(FBtnList[i]).BoundsRect;
   if PtInRect(r,DownPoint) then TDXImageButton(FBtnList[i]).Selected:=true;
  end;
end;


procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 JobList.SaveToFile(GetName('JobList.txt'));
 Action:=caFree;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Case Key of
   VK_ESCAPE  : Close;
   VK_F12     : PrintScreen;
  end;
end;

procedure TMainForm.PrintScreen;
Const
 N : integer=1;
Var
 //Dib : TDib;
 NewGraphic : TDIB;
 FileName   : String;
begin
 NewGraphic := TDIB.Create;
 try
  DXDraw.Primary.AssignTo(NewGraphic);
  FileName:=GetName('Screen'+IntToStr(N)+'.bmp');
  Inc(N);
  NewGraphic.SaveToFile(FileName);
 finally
  NewGraphic.free;
 end;
end;

function GetFirstToken(S: string; Token: Char): string;
var
  Temp  : string;
  Index : INteger;
begin
  Index := Pos(Token, S);
  if Index < 1 then begin
    Result:= '';
    Exit;
  end;
  Dec(Index);
  SetLength(Temp, Index);
  Move(S[1], Temp[1], Index);
  Result := Temp;
end;


procedure TMainForm.LoadWaves;  // do not work !!!!! ???????????
Var
 FResult       : integer;
 SearchRec     : TSearchRec;
 Item          : TWaveCollectionItem;
 SoundName     : String ;
begin
if FileExists(GetName('Sound\DXW','SpriteEffect.dxw')) then
begin
 MainForm.DXWaveList.Items.LoadFromFile(GetName('Sound\DXW','SpriteEffect.dxw'));
 Exit;
end;

FResult:=FindFirst(GetName('Sound\Wav','*.wav'),faArchive,SearchRec);
While FResult=0 do begin
 SoundName:=GetFirstToken(SearchRec.name,'.');
 Item := TWaveCollectionItem.Create(DXWaveList.Items);
 Item.Name := SoundName;
 Item.Wave.LoadFromFile(GetName('Sound\Wav',SearchRec.name));
 Item.Restore;
 FResult:=FindNext(SearchRec);

end;
Sysutils.FindClose(SearchRec);

//DXWaveList.DXSound:=DXSound;// do not work without it !!!!! ???????????
end;

procedure TMainForm.DXSoundInitialize(Sender: TObject);
var
WaveFormat:TWaveFormatEx;
begin
 //MakePCMWaveFormatEx(WaveFormat,11025,8,1);
 MakePCMWaveFormatEx(WaveFormat,22050,16,1);
 DXSound.Primary.SetFormat(WaveFormat);
end;


end.

