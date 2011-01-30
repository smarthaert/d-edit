unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ActnList, Menus, ExtCtrls, Buttons, ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btn_new: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenD: TOpenDialog;
    SaveD: TSaveDialog;
    trr: TTreeView;
    procedure btn_newClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormHide(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure strgrClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure trrDblClick(Sender: TObject);
    procedure trrEnter(Sender: TObject);
    procedure trrSelectionChanged(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  flag,anychange:boolean;
implementation

{ TForm1 }
uses unit2;
function PIEV(prec:longint):extended external 'PIlib.dll';
procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with form2 do
     begin
          Height:=165;
          comb.Visible:=false;
          Editor.Visible:=false;
          EName.Visible:=true;
          Etel.Visible:=true;
          Emobtel.Visible:=true;
          Email.Visible:=true;
          Eicq.Visible:=true;
          Caption:='Добавление новой записи';
          Show;
     end;
flag:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     with form2 do
        begin
             height:=87;
             EName.Visible:=false;
             Etel.Visible:=false;
             Emobtel.Visible:=false;
             Email.Visible:=false;
             Eicq.Visible:=false;
             comb.Visible:=true;
             Editor.Visible:=true;
             Editor.text:=trr.Selected.Text;
             Caption:='Редактирование элемента';
             Show;
        end;
//txt:=inputbox('Введите новое значение','','');
flag:=false;

end;

procedure TForm1.Button3Click(Sender: TObject);
//var indx,absindx:integer;
begin

 showmessage('Абсолютный индекс '+
inttostr(trr.Selected.AbsoluteIndex)+#13+
'Относительный индекс '+ inttostr(trr.Selected.Index))

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 showmessage('Абсолютный индекс '+
inttostr(trr.topitem.AbsoluteIndex)+#13+
'Относительный индекс '+ inttostr(trr.topitem.Index)+
#13+inttostr(trr.Selected.Parent.AbsoluteIndex))

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TForm1.FormDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin

end;

procedure TForm1.FormHide(Sender: TObject);
begin

end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.btn_newClick(Sender: TObject);
begin
  trr.Items.Clear;
  anychange:=false;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
   trr.Items.Clear;
   anychange:=false;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
   if opend.Execute then  trr.LoadFromFile(opend.FileName);
   trr.Update;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  if saved.Execute then trr.SaveToFile(saved.FileName);
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
var answer:WORD;
begin
  if anychange then
    answer:=messagedlg('Вы хотите сохранить изменения?', mtwarning, mbYesNoCancel,0);
   if answer=mryes then
   if saved.Execute then trr.SaveToFile(saved.FileName);
   if answer=mrcancel then
   else
   halt;
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem9Click(Sender: TObject);
begin
 MessageDlg('Число ПИ равно'+#13+floattostr(PIEV(10)), mtinformation,mbOKCancel,0);
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;

procedure TForm1.strgrClick(Sender: TObject);
begin

end;

procedure TForm1.TrayIcon1Click(Sender: TObject);
begin
    //form1.Show;
    form1.WindowState:=wsnormal;
  form1.ShowInTaskBar:=stalways;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin

end;

procedure TForm1.trrDblClick(Sender: TObject);
begin

end;

procedure TForm1.trrEnter(Sender: TObject);
begin

end;

procedure TForm1.trrSelectionChanged(Sender: TObject);
begin
  button2.Enabled:=true;
end;

procedure updatetree;
begin



end;

initialization
  {$I unit1.lrs}

end.

