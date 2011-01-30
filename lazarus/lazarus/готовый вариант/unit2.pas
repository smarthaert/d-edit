unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Grids, ComCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure combChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }

  end; 
procedure clearform;
var
  Form2: TForm2; 
   Enam,etl,emob,emll,eic:string;
implementation
uses unit1;
{ TForm2 }
const
TEL='Телефон ';NME='Имя ';MTEL='Моб.Телефон ';EML='Email ';ICQ='ICQ ';

procedure clearform;
begin
 form2.CleanupInstance;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
with  form1.trr.Items do
begin
    if flag then
      begin
        Add(nil,ename.Text);
        if trim(etel.Text)<>'' then addchild(form1.trr.Items.GetLastNode,TEL+etel.Text);
        if trim(emobtel.Text)<>'' then addchild(form1.trr.Items.GetLastNode,MTEL+emobtel.Text);
        if trim(email.Text)<>'' then addchild(form1.trr.Items.GetLastNode,EML+email.Text);
        if trim(eicq.Text)<>'' then addchild(form1.trr.Items.GetLastNode,ICQ+eicq.Text);
      end
     else
      if trim(editor.Text)<>'' then form1.trr.Selected.Text:=comb.Text+': '+editor.Text;
end;
   self.Hide;
   anychange:=true;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  self.Hide;
end;

procedure TForm2.combChange(Sender: TObject);
begin

end;

initialization
  {$I unit2.lrs}

end.

