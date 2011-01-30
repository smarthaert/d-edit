unit GameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, RXSpin, RXCtrls, Mask, ToolEdit,
  CurrEdit,SpeakUnit, ExtCtrls, WorldUnit;

type
  TGameForm = class(TForm)
    Pages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox1: TGroupBox;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    RxLabel3: TRxLabel;
    RxLabel4: TRxLabel;
    ProgressBar1: TProgressBar;
    MinBtn: TButton;
    MaxBtn: TButton;
    ScEdit: TRxSpinEdit;
    ListBox1: TListBox;
    Label1: TLabel;
    PeaceLabel: TLabel;
    Label2: TLabel;
    SpaceLabel: TLabel;
    SpeakBtn: TBitBtn;
    RxLabel5: TRxLabel;
    RxLabel6: TRxLabel;
    LevelEdit: TCurrencyEdit;
    GroupBox2: TGroupBox;
    RxLabel7: TRxLabel;
    RxLabel8: TRxLabel;
    RxLabel9: TRxLabel;
    RxLabel10: TRxLabel;
    RxLabel11: TRxLabel;
    RxLabel12: TRxLabel;
    ProgressBar2: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    RxSpinEdit1: TRxSpinEdit;
    CurrencyEdit1: TCurrencyEdit;
    GroupBox3: TGroupBox;
    RxLabel13: TRxLabel;
    RxLabel14: TRxLabel;
    RxLabel15: TRxLabel;
    RxLabel16: TRxLabel;
    RxLabel17: TRxLabel;
    RxLabel18: TRxLabel;
    ProgressBar3: TProgressBar;
    Button3: TButton;
    Button4: TButton;
    RxSpinEdit2: TRxSpinEdit;
    CurrencyEdit2: TCurrencyEdit;
    GroupBox4: TGroupBox;
    RxLabel19: TRxLabel;
    RxLabel20: TRxLabel;
    RxLabel21: TRxLabel;
    RxLabel22: TRxLabel;
    RxLabel23: TRxLabel;
    RxLabel24: TRxLabel;
    ProgressBar4: TProgressBar;
    Button5: TButton;
    Button6: TButton;
    RxSpinEdit3: TRxSpinEdit;
    CurrencyEdit3: TCurrencyEdit;
    GroupBox5: TGroupBox;
    RxLabel25: TRxLabel;
    RxLabel26: TRxLabel;
    RxLabel27: TRxLabel;
    RxLabel28: TRxLabel;
    RxLabel29: TRxLabel;
    RxLabel30: TRxLabel;
    ProgressBar5: TProgressBar;
    Button7: TButton;
    Button8: TButton;
    RxSpinEdit4: TRxSpinEdit;
    CurrencyEdit4: TCurrencyEdit;
    GroupBox6: TGroupBox;
    RxLabel31: TRxLabel;
    RxLabel32: TRxLabel;
    RxLabel33: TRxLabel;
    RxLabel34: TRxLabel;
    RxLabel35: TRxLabel;
    RxLabel36: TRxLabel;
    ProgressBar6: TProgressBar;
    Button9: TButton;
    Button10: TButton;
    RxSpinEdit5: TRxSpinEdit;
    CurrencyEdit5: TCurrencyEdit;
    RxLabel43: TRxLabel;
    GroupBox9: TGroupBox;
    RxLabel53: TRxLabel;
    RxLabel54: TRxLabel;
    RxLabel55: TRxLabel;
    RxLabel56: TRxLabel;
    RxLabel57: TRxLabel;
    RxLabel58: TRxLabel;
    RxLabel59: TRxLabel;
    RxLabel60: TRxLabel;
    CurrencyEdit12: TCurrencyEdit;
    CurrencyEdit22: TCurrencyEdit;
    CurrencyEdit23: TCurrencyEdit;
    CurrencyEdit24: TCurrencyEdit;
    CurrencyEdit25: TCurrencyEdit;
    CurrencyEdit26: TCurrencyEdit;
    CurrencyEdit27: TCurrencyEdit;
    CurrencyEdit28: TCurrencyEdit;
    GroupBox7: TGroupBox;
    RxLabel37: TRxLabel;
    CurrencyEdit6: TCurrencyEdit;
    RxLabel38: TRxLabel;
    CurrencyEdit7: TCurrencyEdit;
    Panel1: TPanel;
    ExitBtn: TBitBtn;
    NextCountryBtn: TBitBtn;
    RxLabel39: TRxLabel;
    CurCountryName: TRxLabel;
    procedure ExitBtnClick(Sender: TObject);
    procedure SpeakBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NextCountryBtnClick(Sender: TObject);
    procedure ExitClick(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GameForm: TGameForm;
  CurCountry: LongInt = 1; { Первоначально ходит первая страна }

implementation

uses MainUnit;

{$R *.dfm}

procedure TGameForm.ExitBtnClick(Sender: TObject);
begin
  MainForm.Show;
  Hide;
end;

procedure TGameForm.SpeakBtnClick(Sender: TObject);
begin
  SpeakForm.SpeakCountry(1,2);
end;

procedure TGameForm.FormActivate(Sender: TObject);
begin
  { Обновление отображаемой информации в форме }
  { Данные берутся из обьекта страна }
  { В остальных местах для обновления данных в форме просто вызываем }
  {    FormActivate(nil);    }
  CurCountryName.Caption := Countries[CurCountry].Name;
end;

{ Переход на следующую страну (следующего игрока) }
procedure TGameForm.NextCountryBtnClick(Sender: TObject);
begin
  { Циклическое изменение на 1 переменной CurCountry }
  Inc(CurCountry);
  If CurCountry > NumCountries then CurCountry := 1;
  { Обновление состояния формы }
  FormActivate(nil);
end;

procedure TGameForm.ExitClick(Sender: TObject; var Action: TCloseAction);
begin
  ExitBtnClick(Sender);
end;

end.
