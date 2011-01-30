unit NewGameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, RXSpin, ExtCtrls, RXCtrls, RXSlider,
  WorldUnit;

type
  TNewGameForm = class(TForm)
    RxSlider1: TRxSlider;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    RxLabel3: TRxLabel;
    Panel1: TPanel;
    PaintMap: TPaintBox;
    RxSpinEdit1: TRxSpinEdit;
    RxLabel4: TRxLabel;
    GenNewMapBtn: TBitBtn;
    ExitBtn: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GenerateMap;
    { Public declarations }
  end;

var
  NewGameForm: TNewGameForm;

implementation

uses GameUnit, MainUnit;

{$R *.dfm}


procedure TNewGameForm.FormActivate(Sender: TObject);
begin
  GenerateMap;
end;

Type
  TPoint = Record
    X,Y : Word;
  End;

procedure TNewGameForm.GenerateMap;
Var G : Array [1..10000] of TPoint;
begin
//  N := 1;
//  G[1].X := 1;
//  G[1].Y := 1;
//  For I:=1 to 1000 do begin
//    PaintMap.Canvas.
//  end;
end;

procedure TNewGameForm.BitBtn1Click(Sender: TObject);
Var I:Word;
begin
  // Для начала создаем две тестовые страны
  NumCountries:=2;
  For I:=1 to 2 do Countries[I]:=TCountry.Create;
  Countries[1].Name:='Англия';
  Countries[2].Name:='США';
  Countries[1].Peace[2]:=False;
  Countries[2].Peace[1]:=False;
  Hide;
  GameForm.Show;
end;

end.
