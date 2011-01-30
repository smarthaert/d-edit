unit SpeakUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls,WorldUnit;

type
  TSpeakForm = class(TForm)
    TryBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cPeace1: TCheckBox;
    cPeace2: TCheckBox;
    cMoveRight1: TCheckBox;
    cMoney1: TLabeledEdit;
    cMoney2: TLabeledEdit;
    cZerno2: TLabeledEdit;
    cZerno1: TLabeledEdit;
    cMoveRight2: TCheckBox;
    procedure cPeace1Click(Sender: TObject);
    procedure cPeace2Click(Sender: TObject);
    procedure cMoneyClick(Sender: TObject);
  private
    { Private declarations }
    Procedure SetState(NS,NO:Integer);
    Function TryAccept(NS,NO:Integer):Boolean;
  public
    { Public declarations }
    Procedure SpeakCountry(NS,NO:Integer);
  end;

var
  SpeakForm: TSpeakForm;

implementation

{$R *.dfm}

Function TSpeakForm.TryAccept;
Var S,O:TDiplomacyCost;
begin
  S:=NullDiplomacyCost;
  O:=S;
  With S do
    Begin
      Peace:=cPeace1.Checked;
      Money:=StrToIntDef(cMoney1.Text,0);
      Zerno:=StrToIntDef(cZerno1.Text,0);
      MoveRight:=cMoveRight1.Checked;
      {ViewCountry
      Space}
    End;
  With O do
    Begin
      Peace:=cPeace2.Checked;
      Money:=StrToIntDef(cMoney2.Text,0);
      Zerno:=StrToIntDef(cZerno2.Text,0);
      MoveRight:=cMoveRight2.Checked;
      {ViewCountry
      Space}
    End;
  Result:=
    Countries[NS].CanPay(S)And
    Countries[NO].DiplomacyAcceptable(O,S,NS);
  If Not Result then Exit;
  DiplomacyAction(S,O,NS,NO);
  ShowMessage('Договор заключен');
end;

procedure TSpeakForm.SetState(NS, NO: Integer);
Var F:Boolean;
begin
  Caption:='Говорим с '+Countries[NO].Name;
  GroupBox1.Caption:=Countries[NS].Name;
  GroupBox2.Caption:=Countries[NO].Name;
  F:=Not Countries[NS].Peace[NO];
  cPeace1.Enabled:=False;
  cPeace2.Enabled:=False;
  cPeace1.Checked:=F;
  cPeace2.Checked:=F;
  cMoveRight1.Checked:=False;
  cMoveRight1.Enabled:=Not Countries[NO].MoveRight[NS];
  cMoveRight2.Checked:=False;
  cMoveRight2.Enabled:=Not Countries[NS].MoveRight[NO];
  cMoney1.Text:='0';
  cMoney2.Text:='0';
  cZerno1.Text:='0';
  cZerno2.Text:='0';
end;

Procedure TSpeakForm.SpeakCountry(NS,NO:Integer);
Begin
  SetState(NS,NO);
  Repeat
    If ShowModal=mrCancel then Break;
  Until TryAccept(NS,NO);
End;

procedure TSpeakForm.cPeace1Click(Sender: TObject);
begin
  cPeace2.Checked:=cPeace1.Checked;
end;

procedure TSpeakForm.cPeace2Click(Sender: TObject);
begin
  cPeace1.Checked:=cPeace2.Checked;
end;

procedure TSpeakForm.cMoneyClick(Sender: TObject);
Var N:LongInt;
begin
  With Sender As TLabeledEdit do
    Begin
      N:=StrToIntDef(Text,0);
      If N<0 then N:=0;
      Text:=IntToStr(N);
    End;
end;

end.
