unit DXWNavigator;

interface
 uses
  Windows, Messages, SysUtils, Classes, ExtCtrls, Controls,
  DXClass, DXDraws, DXSprite, DXWImageSprite,DIB;

Type
/////////////////////////////////////////////////////////////////////////

  TDXWCustomNavigator = class
  private
    FInitLeft    : Integer;
    FInitTop     : Integer;
    FInitWidth   : Integer;
    FInitHeight  : Integer;
    FVisible     : Boolean;

    FLeft     : Integer;
    FTop      : Integer;
    FWidth    : Integer;
    FHeight   : Integer;

    FMapW,FMapH   : Integer;

    FGidRect      : TRect; // in Screen CS
    FGidW,FGidH   : Integer;
    FGidX,FGidY   : Integer;// in OutRect CS

    FkX,FkY,Fk    : Double;

    FGidClicked   : Boolean;
    FClicked      : Boolean;

    procedure SetInitHeight(const Value: Integer);
    procedure SetInitWidth(const Value: Integer);

    procedure SetMapH(const Value: Integer);
    procedure SetMapW(const Value: Integer);
    procedure Calculate;

  protected
    procedure DoDraw ; virtual; abstract;
    function  GetBoundsRect : TRect;

    function MapXToX(AMapX : Double):Integer;
    function MapYToY(AMapY : Double):Integer;

    function XToMapX(AX : Integer ) : Double;
    function YToMapY(AY : Integer ) : Double;

  public

    constructor Create; virtual;
    destructor Destroy; override;

    property BoundsRect: TRect read GetBoundsRect;

    property InitLeft   : Integer write FInitLeft;
    property InitTop    : Integer write FInitTop;
    property InitWidth  : Integer write SetInitWidth;
    property InitHeight : Integer write SetInitHeight;

    property MapW    : Integer write SetMapW;
    property MapH    : Integer write SetMapH;

    property GidRect : TRect read FGidRect;

    property Visible : Boolean read FVisible write FVisible;

  end;


 TDXWNavigator = class (TDXWCustomNavigator)
  private
   FSpriteEngine : TDXSpriteEngine;
   FImage: TPictureCollectionItem;

   procedure SetSpriteEngine(Value: TDXSpriteEngine);

  protected
   procedure ScrollTo( X,Y : Integer);
   procedure DoDraw; override;
  public

   procedure NavigatorMouseMove(Shift: TShiftState;Const X,Y: Integer);
   procedure NavigatorMouseDown(Shift: TShiftState;Const X, Y: Integer);
   procedure NavigatorMouseUp(Shift: TShiftState;Const X, Y: Integer);

   constructor Create; override;
   destructor Destroy; override;

   procedure DrawSelf;

   property Image: TPictureCollectionItem read FImage write FImage;
   property SpriteEngine: TDXSpriteEngine write SetSpriteEngine;
  end;

implementation
Uses Math,Main,GameSpritesUnit;

{ TDXWCustomNavigator }

constructor TDXWCustomNavigator.Create;
begin
  inherited Create;
  FInitWidth:=0;
  FInitHeight:=0;

  FMapW:=0;
  FMapH:=0;
  FkX:=0;
  FkY:=0;
  Fk :=0;
  FVisible:=true;
  FGidClicked:=false;
  FClicked:=false;
end;

destructor TDXWCustomNavigator.Destroy;
begin
  inherited Destroy;
end;

{
procedure TDXWCustomNavigator.DoDraw;
begin
//
end;
}

function TDXWCustomNavigator.GetBoundsRect: TRect;
begin
 Result := Bounds(FLeft,FTop,FWidth,FHeight);
end;

function TDXWCustomNavigator.MapXToX(AMapX: Double): Integer;
begin

end;

function TDXWCustomNavigator.MapYToY(AMapY: Double): Integer;
begin

end;

procedure TDXWCustomNavigator.Calculate;
begin
if ( FInitHeight*FMapH*FInitWidth*FMapW=0 )  then Exit;

FkY:=FInitHeight/FMapH;
FkX:=FInitWidth/FMapW;
Fk:=min(FkX,FkY);

FWidth:=Trunc(Fk*FMapW);
FHeight:=Trunc(Fk*FMapH);

FLeft:=FInitLeft+(FInitWidth-FWidth)div 2;
FTop:=FInitTop+(FInitHeight-FHeight)div 2;

JobList.Add('DXWCustomNavigator.Fk'+'|'+FloatToStr(Fk));
JobList.Add('DXWCustomNavigator.FWidth'+'|'+IntToStr(FWidth));
JobList.Add('DXWCustomNavigator.FHeight'+'|'+IntToStr(FHeight));

end;

procedure TDXWCustomNavigator.SetInitHeight(const Value: Integer);
begin
FInitHeight:=Value;
Calculate;
end;

procedure TDXWCustomNavigator.SetMapH(const Value: Integer);
begin
FMapH:=Value;
Calculate;
end;

procedure TDXWCustomNavigator.SetMapW(const Value: Integer);
begin
FMapW:=Value;
Calculate;
end;

procedure TDXWCustomNavigator.SetInitWidth(const Value: Integer);
begin
FInitWidth:=Value;
Calculate;
end;

function TDXWCustomNavigator.XToMapX(AX: Integer): Double;
begin

end;

function TDXWCustomNavigator.YToMapY(AY: Integer): Double;
begin

end;



{ TDXWNavigator }

constructor TDXWNavigator.Create;
begin
  inherited Create;
  FSpriteEngine:=nil;
end;

procedure TDXWNavigator.DoDraw;
Var
 i       : integer;
 L,T     : integer;
 SpriteR : TRect;
begin
if Not FVisible then Exit;

FGidX:=Trunc(Abs(FSpriteEngine.Engine.X*Fk));
FGidY:=Trunc(Abs(FSpriteEngine.Engine.Y*Fk));

L:=FLeft+FGidX;
T:=FTop +FGidY;
FGidRect:=Bounds(L,T,FGidW,FGidH);

with FSpriteEngine.DXDraw do
begin
//Surface.FillRect(Self.BoundsRect,0);
FImage.Draw(Surface,FLeft,FTop,0);

Surface.FillRectAlpha(FGidRect,DXYellow,50);

  For i:=0 to FSpriteEngine.Engine.AllCount-1 do
   //if FSpriteEngine.Engine.Items[i] is TWImageSprite then
     //With TWImageSprite(FSpriteEngine.Engine.Items[i]) do
   if FSpriteEngine.Engine.Items[i] is TGameUnit then
     With TGameUnit(FSpriteEngine.Engine.Items[i]) do
     begin
       L:=FLeft+Trunc(X*Fk);
       T:=FTop+Trunc(Y*Fk);
       SpriteR:=Bounds(L,T,Trunc(Width*Fk),Trunc(Height*Fk));
       Surface.FillRect(SpriteR,FUnitColor);
       //Pixels[L,T]:=DXRed;
     end;

end;

end;

procedure TDXWNavigator.DrawSelf;
begin
 DoDraw;
end;

procedure TDXWNavigator.SetSpriteEngine(Value: TDXSpriteEngine);
 begin
  FSpriteEngine:=Value;
  FGidW:=Trunc(FSpriteEngine.Engine.Width*Fk);
  FGidH:=Trunc(FSpriteEngine.Engine.Height*Fk);
 end;

procedure TDXWNavigator.ScrollTo( X,Y : Integer);
Var
 eX,eY: Double;
begin

  eX:=( X-FLeft-(FGidW div 2) )/Fk;
  eY:=( Y-FTop-(FGidH div 2) )/Fk;

  //if eX>FMapW then eX:=FMapW;// working
  //if eY>FMapH then eY:=FMapH;// without it !!! ???

  FSpriteEngine.Engine.X:=-eX;
  FSpriteEngine.Engine.y:=-eY;

  //if (ssLeft in Shift) then FGidClicked := TRUE;

end;


procedure TDXWNavigator.NavigatorMouseDown(Shift: TShiftState; Const X, Y: Integer);
begin
if PointInRect(Point(X,Y),BoundsRect)then
 begin
  FClicked:=true;
  ScrollTo(X,Y);
 end;
end;

procedure TDXWNavigator.NavigatorMouseMove(Shift: TShiftState;Const X,Y: Integer);
begin
if FClicked then
 begin
  ScrollTo(X,Y);
 end
end;

procedure TDXWNavigator.NavigatorMouseUp(Shift: TShiftState;Const X, Y: Integer);
begin
 FGidClicked:=false;
 FClicked:=false;
end;

destructor TDXWNavigator.Destroy;
begin
 //MiniMapGraphic.Free;
 inherited Destroy;
end;

end.
