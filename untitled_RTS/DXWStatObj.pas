unit DXWStatObj;

interface
uses
  Windows, SysUtils, Classes,Graphics ,DXClass, DXDraws ;

Type
/////////////////////////////////////////////////////////////////////////

  //TButtonEngine = Class;

  TDXButton = class
  private

    FSelected   : Boolean;
    FX: Integer;
    FY: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FVisible    : Boolean;

  protected
    procedure DoDraw; virtual;
    function GetBoundsRect: TRect;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property BoundsRect: TRect read GetBoundsRect;
    property Selected: Boolean read FSelected write FSelected;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Visible: Boolean read FVisible write FVisible;

  end;

/////////////////////////////////////////////////////////////////////////

 TDXImageButton = class (TDXButton)
  private
    FImage: TPictureCollectionItem;
    FSurface: TDirectDrawSurface;
    FCaption : String;

    procedure SetSurface(Value: TDirectDrawSurface);

  protected
   procedure DoDraw; override;
   function GetDrawImageIndex: Integer;
  public
   constructor Create; override;
   procedure DrawSelf;
   property Image: TPictureCollectionItem read FImage write FImage;
   property Surface: TDirectDrawSurface read FSurface write SetSurface;
   property Caption : String read FCaption write FCaption ;

  end;

/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////


implementation
/////////////////////////////////////////////////////////////////////////
constructor TDXButton.Create;
begin
  inherited Create;
  FSelected := False;
  FVisible:=true;

end;

destructor TDXButton.Destroy;
begin
  inherited Destroy;
end;

procedure TDXButton.DoDraw;
begin
end;

function TDXButton.GetBoundsRect: TRect;
begin
  Result := Bounds(FX,FY,FWidth,FHeight);
end;
/////////////////////////////////////////////////////////////////////////

constructor TDXImageButton.Create;
begin
  inherited Create;
  FCaption:='';
end;

function TDXImageButton.GetDrawImageIndex: Integer;
begin
  if Selected then Result :=1 else Result :=0;
end;

procedure TDXImageButton.DoDraw;
var
  ImageIndex: Integer;
begin
if Not FVisible then Exit; 
  ImageIndex := GetDrawImageIndex;
  Image.Draw( FSurface, X, Y, ImageIndex);
  if FCaption<>'' then
   begin
    with FSurface.Canvas do
    begin
     Brush.Style := bsClear;
     Font.Color := clYellow;
     Font.Size := 12;
     Font.Name:='Times New Roman';
     TextOut(X+(Width-TextWidth(FCaption))div 2 ,
             Y+(Height-TextHeight('A'))div 2, FCaption);
     Release;
    end;
   end;
end;

procedure TDXImageButton.DrawSelf;
begin
 DoDraw;
end;

procedure TDXImageButton.SetSurface(Value: TDirectDrawSurface);
begin
  FSurface := Value;
end;


end.
