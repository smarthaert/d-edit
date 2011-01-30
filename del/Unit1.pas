unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DXClass, DXInput, DXDraws, ExtCtrls;

type
  TForm1 = class(TForm)
    DXDraw: TDXDraw;
    DXImageList: TDXImageList;
    DXInput: TDXInput;
    DXTimer: TDXTimer;
    Panel1: TPanel;
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PaperImage:TPictureCollectionItem;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  If Not DXDraw.CanDraw then Exit;

  With DXDraw.Surface.Canvas do
    Begin
      //I:=DXImageList.Items.Find('Leader.bmp');
      PaperImage.Draw(DXDraw.Surface,0,0,0);
      //Release;
    End;
  DXDraw.Flip;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { Color table }
  DXImageList.Items.MakeColorTable;

  DXDraw.ColorTable := DXImageList.Items.ColorTable;
  DXDraw.DefColorTable := DXImageList.Items.ColorTable;
  DXDraw.UpdatePalette;

  { Paper image }
  PaperImage:=DXImageList.Items.Find('Leader.bmp');
end;

end.
