unit unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DXInput, DXDraws, DIB, ExtCtrls,Contnrs, ImgList, DXClass,UMyMenu;

type
  TTankType=class(TComponent)
  public
    TankImage:TGraphic;
    Armor:Integer;
    Constructor MyCreate(TankImageName:String;AArmor:Integer);
  End;
  TForm1 = class(TDXForm)
    ImageList: TDXImageList;
    DXInput: TDXInput;
    DXDraw: TDXDraw;
    DXTimer1: TDXTimer;
    FontDialog: TFontDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    procedure DXDrawClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TypSel:Integer;
    Procedure MyPaint(C:TCanvas);
    Procedure MyMenuInput;
    Procedure ReflectTypSel;
  end;

var
  Form1: TForm1;
  TankTypes:TComponentList;
  MyMenu:TMyMenu;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.MyPaint(C: TCanvas);
{Const
  INameSize=150;
  procedure PaintItem(IName:String;Focused:Boolean;X,Y:Integer;Image:TGraphic);
  begin
    With C do
      Begin
        TextOut(X,Y,IName);
        TextOut(X+INameSize-10,Y,':');
        Draw(X+INameSize,Y,Image);

      End;
  end;}

begin
  With C do
    Begin
      Brush.Color:=clBlack;
      FillRect(Rect(0,0,300,300));
      Pen.Color:=clGray;
      Rectangle(0,0,300,300);
      MyMenu.Paint(C);
      {Font:=MyFont;
      PaintItem('Tank',True,5,5,TankImage);
      //ImageList.Items.Items[0].Draw(DXDraw.Surface,50,50,0);}
    End;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var T:TTankType;
begin
  ImageList.Items.MakeColorTable;
  DXDraw.ColorTable:=ImageList.Items.ColorTable;
  DXDraw.DefColorTable:=ImageList.Items.ColorTable;
  //ImageList.Items.ColorTable
  TankTypes:=TComponentList.Create(True);
  TankTypes.Add(TTankType.MyCreate('Tank 1',50));
  TankTypes.Add(TTankType.MyCreate('Tank 2',100));
  //ImageList.Items.Items[0].
  MyMenu:=TMyMenu.MyCreate(Self,5,5);
  MyMenu.AddImageItem('TANK',Nil);
  MyMenu.AddValueItem('ARMOR','');
  MyMenu.AddValueItem('SPEED','');
  MyMenu.AddValueItem('HIT POINTS','');
  MyMenu.AddValueItem('DAMAGE','');
  MyMenu.AddImageItem('Image',ImageList.Items.Items[2].Picture.Graphic);
  MyMenu.AddTextItem('TEXT');
  TypSel:=0;
  ReflectTypSel;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  MyMenu.Free;
  TankTypes.Free;
end;

procedure TForm1.MyMenuInput;
begin
  With DXInput,MyMenu do
    Begin
      If isDown in States then
        NumSel:=NumSel+1;
      If isUp in States then
        NumSel:=NumSel-1;
      If NumSel=0 then
        Begin
          If (isLeft in States)And(TypSel>0) then
            Begin
              Dec(TypSel);
              ReflectTypSel;
            End;
          If (isRight in States)And(TypSel<TankTypes.Count-1) then
            Begin
              Inc(TypSel);
              ReflectTypSel;
            End;
        End;
    End;
end;

procedure TForm1.ReflectTypSel;
begin
  With MyMenu,TTankType(TankTypes.Items[TypSel]) do
    Begin
      Items[0]^.Image:=TankImage;
      Items[1]^.Value:=IntToStr(Armor);
    End;
end;

{ TTankType }

constructor TTankType.MyCreate(TankImageName: String;AArmor:Integer);
begin
  TankImage:=Form1.ImageList.Items.Find(TankImageName).Picture.Graphic;
  Armor:=AArmor;
  //TankImage:=Form1.DXDIB1.DIB.
  //TankImage:=Form1.ImageList1[0]
  //Form1.ImageList1.
end;

procedure TForm1.DXTimer1Timer(Sender: TObject; LagCount: Integer);
begin
  If Not DXDraw.CanDraw then Exit;

  DXInput.Update;
  MyMenuInput;

  DXDraw.Surface.Fill(0);
  MyPaint(DXDraw.Surface.Canvas);
  DXDraw.Surface.Canvas.TextOut(500,10,IntToStr(DXTimer1.FrameRate));
  DXDraw.Surface.Canvas.Release;

  DXDraw.Flip;
end;

procedure TForm1.DXDrawClick(Sender: TObject);
begin
  FontDialog.Execute;
end;


end.
