unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ComCtrls;

type

  { Tedit_new_frm }

  Tedit_new_frm = class(TForm)
    ok_btn: TButton;
    cancel_btn: TButton;
    comb: TComboBox;
    Editor: TEdit;
    EName: TEdit;
    Etel: TEdit;
    Email: TEdit;
    Eicq: TEdit;
    Emobtel: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure ok_btnClick(Sender: TObject);
    procedure cancel_btnClick(Sender: TObject);
    procedure combChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end; 
procedure clearform;//очистка формы
var
  edit_new_frm: Tedit_new_frm;
   Enam,etl,emob,emll,eic:string;
implementation
uses unit1;
{ Tedit_new_frm }
const
TEL='Телефон ';NME='Имя ';MTEL='Моб.Телефон ';EML='Email ';ICQ='ICQ ';

procedure clearform;
begin
 edit_new_frm.CleanupInstance;
end;

procedure Tedit_new_frm.ok_btnClick(Sender: TObject);//подтверждение добавления/изменения записи/элемента
begin
with  main_frm.trr.Items do
begin
    if flag then
      begin
        Add(nil,ename.Text);
        if trim(etel.Text)<>'' then addchild(main_frm.trr.Items.GetLastNode,TEL+etel.Text);
        if trim(emobtel.Text)<>'' then addchild(main_frm.trr.Items.GetLastNode,MTEL+emobtel.Text);
        if trim(email.Text)<>'' then addchild(main_frm.trr.Items.GetLastNode,EML+email.Text);
        if trim(eicq.Text)<>'' then addchild(main_frm.trr.Items.GetLastNode,ICQ+eicq.Text);
      end
     else
      if trim(editor.Text)<>'' then main_frm.trr.Selected.Text:=comb.Text+': '+editor.Text;
end;
   self.Hide;
   anychange:=true;
end;

procedure Tedit_new_frm.cancel_btnClick(Sender: TObject);
begin
  self.Hide;
end;

procedure Tedit_new_frm.combChange(Sender: TObject);
begin

end;

initialization
  {$I unit2.lrs}

end.

