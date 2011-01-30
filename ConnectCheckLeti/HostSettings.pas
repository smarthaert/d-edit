unit HostSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzDlgBtn, StdCtrls, Mask, RzEdit, RzSpnEdt;

type
  THostSettingsForm = class(TForm)
    PortEdit: TRzSpinEdit;
    HostEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    RzDialogButtons1: TRzDialogButtons;
    HasAltCB: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    AltPortEdit: TRzSpinEdit;
    AltHostEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    AltPort1Edit: TRzSpinEdit;
    AltHost1Edit: TEdit;
    HasAlt1CB: TCheckBox;
    NameEdit: TEdit;
    Label7: TLabel;
    Bevel1: TBevel;
    AnswerEdit: TEdit;
    Label8: TLabel;
    procedure HasAltCBClick(Sender: TObject);
    procedure HasAlt1CBClick(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HostSettingsForm: THostSettingsForm;

implementation

{$R *.dfm}

procedure THostSettingsForm.HasAltCBClick(Sender: TObject);
begin
  AltHostEdit.Enabled := HasAltCB.Checked;
  AltPortEdit.Enabled := HasAltCB.Checked;
  Label3.Enabled := HasAltCB.Checked;
  Label4.Enabled := HasAltCB.Checked;
  HasAlt1CB.Enabled := HasAltCB.Checked;
end;

procedure THostSettingsForm.HasAlt1CBClick(Sender: TObject);
begin
  AltHost1Edit.Enabled := HasAlt1CB.Checked;
  AltPort1Edit.Enabled := HasAlt1CB.Checked;
  Label5.Enabled := HasAlt1CB.Checked;
  Label6.Enabled := HasAlt1CB.Checked;
end;

procedure THostSettingsForm.NameEditChange(Sender: TObject);
begin
  RzDialogButtons1.EnableOk := (NameEdit.Text <> '') and (HostEdit.Text <> '')
    and (PortEdit.Text <> '');
end;

procedure THostSettingsForm.FormShow(Sender: TObject);
begin
  NameEditChange(NameEdit);
end;

end.
