unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UMap, DXDraws;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    DXImageList1: TDXImageList;
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  MapContainer.PaintMap(PaintBox1.Canvas);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MapContainer:=TMapContainer.Create(Self,DXImageList1);
end;

end.
