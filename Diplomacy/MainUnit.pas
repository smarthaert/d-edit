unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    NewGameBtn: TBitBtn;
    ExitBtn: TBitBtn;
    procedure ExitBtnClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses NewGameUnit;

{$R *.dfm}

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.NewGameBtnClick(Sender: TObject);
begin
  Hide;
  NewGameForm.Show;
end;

end.
