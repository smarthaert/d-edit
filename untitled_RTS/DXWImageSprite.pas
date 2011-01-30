unit DXWImageSprite;

interface

uses
  Windows, SysUtils, Classes, DXClass, DXDraws,
  DXWPath, DXSprite;

Type

  TDirChangedXY=record
      x   : double;
      y   : double;
      Dir : Byte;
      end;

  TWImageSprite = class(TImageSprite)
  private
    FDirection            : integer;

    FDestPointX           : Double;
    FDestPointY           : Double;

    FDestChipX            : Integer;
    FDestChipY            : Integer;

    FSelected             : Boolean;
    FCanMove              : Boolean;
 
    function GetChipX     : integer;
    function GetChipY     : integer;

    function GetCX        : Double;
    function GetCY        : Double;

  protected
    Procedure SetDirection( Value : Integer);
    function  TestCollision(Sprite: TSprite): Boolean; override;
    function  GetAngleToUnit( DestUnit : TImageSprite ):double; virtual;

    Procedure CalculatePatternXYCount;
  public
    XCount,YCount         : Integer;
    FChipW,FChipH         : Integer;

    DirChangedXYArr       : Array of TDirChangedXY; //

    DirChangedXYCount     : integer;
    CurrentDirChangedXYId : integer;

    constructor Create(AParent: TSprite); override;


    property Direction :Integer read FDirection write SetDirection;

    property DestPointX : Double read FDestPointX write FDestPointX;
    property DestPointY : Double read FDestPointY write FDestPointY;

    property DestChipX : integer read FDestChipX write FDestChipX;
    property DestChipY : integer read FDestChipY write FDestChipY;

    Property ChipX : integer read GetChipX;
    Property ChipY : integer read GetChipY;

    Property cX : Double read GetCX;
    Property cY : Double read GetCY;

    property Selected : Boolean read FSelected write FSelected;
    property CanMove  : Boolean read FCanMove  write FCanMove;

  end;


implementation
Uses Math;
{------------------------  TWImageSprite ---------------------------- }

constructor TWImageSprite.Create(AParent: TSprite);
begin
 inherited Create(AParent);

 //PixelCheck:=false;
 //FSelected := False;
 //FCanMove  := False;

end;

Procedure TWImageSprite.CalculatePatternXYCount;
begin
 XCount := Image.Picture.Width div (Image.PatternWidth+Image.SkipWidth);
 YCount := Image.Picture.Height div (Image.PatternHeight+Image.SkipHeight);
end;

Procedure TWImageSprite.SetDirection( Value : Integer);
Var
PatternX,PatternY  : Integer;
begin
if Value=FDirection then exit;
FDirection:=Value;

//Current //not needed
//PatternX:=AnimIndex mod XCount;
//PatternY:=AnimIndex div XCount;

//Next
PatternY:=DirToPatternY[FDirection];

AnimStart:=XCount*PatternY;
//AnimPos:=PatternX;// not needed i.e. not chenged
end;

function TWImageSprite.TestCollision(Sprite: TSprite): Boolean;
Var
 R1,R2 : TRect;
begin
  if Sprite is TWImageSprite then
  begin
   With Sprite do
    R1:=Bounds(BoundsRect.Left+Width div 4,BoundsRect.Top+Height div 2,Width div 2,Height div 3);
    R2:=Bounds(BoundsRect.Left+Width div 4,BoundsRect.Top+Height div 2,Width div 2,Height div 3);
   Result := OverlapRect(R1,R2);
  end;
end;

function TWImageSprite.GetChipX: integer;
begin
 Result:=Trunc((X+Width div 2 )/FChipW);
end;

function TWImageSprite.GetChipY: integer;
begin
 Result:=Trunc((Y+Height div 2)/FChipH);
end;

function TWImageSprite.GetCX: Double;
begin
 Result:=(X+Width div 2 );
end;

function TWImageSprite.GetCY: Double;
begin
 Result:=(Y+Height div 2);
end;


function TWImageSprite.GetAngleToUnit(DestUnit: TImageSprite): double;
Var
dx,dy: double;
begin
 dx:=DestUnit.x-x;
 dy:=DestUnit.y-y;
 //if dx=0 then Result
 Result:=ArcTan2(dx,dy);
end;

end.
