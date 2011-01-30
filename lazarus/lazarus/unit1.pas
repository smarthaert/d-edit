unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ActnList, Menus, ExtCtrls, Buttons, ExtDlgs;

type
   TPIEV=function (n:longint):extended;
  { Tmain_frm }

  Tmain_frm = class(TForm)
    btn_new: TButton;
    add_btn: TButton;
    del_btn: TButton;
    edit_btn: TButton;
    Button3: TButton;
    Button4: TButton;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    file_mnu: TMenuItem;
    new_mnu: TMenuItem;
    open_mnu: TMenuItem;
    save_mnu: TMenuItem;
    exit_mnu: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    help_mnu: TMenuItem;
    about_mnu: TMenuItem;
    OpenD: TOpenDialog;
    SaveD: TSaveDialog;
    trr: TTreeView;
    procedure btn_newClick(Sender: TObject);
    procedure add_btnClick(Sender: TObject);
    procedure del_btnClick(Sender: TObject);
    procedure edit_btnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDockOver(Sender: TObject; Source: TDragDockObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FormHide(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure new_mnuClick(Sender: TObject);
    procedure open_mnuClick(Sender: TObject);
    procedure save_mnuClick(Sender: TObject);
    procedure exit_mnuClick(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure about_mnuClick(Sender: TObject);
    procedure trrSelectionChanged(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  main_frm: Tmain_frm;
  flag,anychange:boolean;
implementation

{ Tmain_frm }
uses unit2;

function PIEV(prec:longint):extended external 'PIlib.dll';//функция из внешней библиотеки, по сути пасхальное яйцо

procedure Tmain_frm.add_btnClick(Sender: TObject);//вызов формы для добавления записи
begin
  with edit_new_frm do
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

procedure Tmain_frm.del_btnClick(Sender: TObject);//удаление элементов
var selitem:integer;
begin
selitem:=trr.selected.absoluteindex-1;
if trr.Items.Count=0 then del_btn.Enabled:=false
else
  begin
  trr.Selected.DeleteChildren;
  trr.Selected.Delete;
  trr.Selected:=trr.items[selitem];
  anychange:=true;
  end;
end;

procedure Tmain_frm.edit_btnClick(Sender: TObject);//вызов формы для редактирования записи
begin
     with edit_new_frm do
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

procedure Tmain_frm.Button3Click(Sender: TObject);//отладочные функции
//var indx,absindx:integer;
begin

 showmessage('Абсолютный индекс '+
inttostr(trr.Selected.AbsoluteIndex)+#13+
'Относительный индекс '+ inttostr(trr.Selected.Index))

end;

procedure Tmain_frm.Button4Click(Sender: TObject); //отладочные функции
begin
 showmessage('Абсолютный индекс '+
inttostr(trr.topitem.AbsoluteIndex)+#13+
'Относительный индекс '+ inttostr(trr.topitem.Index)+
#13+inttostr(trr.Selected.Parent.AbsoluteIndex))

end;

procedure Tmain_frm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
procedure FullEXIT;
var answer:WORD;
begin
  if anychange then
    answer:=messagedlg('Вы хотите сохранить изменения?', mtwarning, mbYesNoCancel,0);
   if answer=mryes then
   if main_frm.saved.Execute then main_frm.trr.SaveToFile(main_frm.saved.FileName);
   if answer=mrcancel then
   else
   halt;
end;

begin
 fullexit;
end;

procedure Tmain_frm.FormDockOver(Sender: TObject; Source: TDragDockObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin

end;

procedure Tmain_frm.FormHide(Sender: TObject);
begin

end;

procedure Tmain_frm.FormWindowStateChange(Sender: TObject);
begin

end;



procedure Tmain_frm.btn_newClick(Sender: TObject);//новая записная книга
begin
  trr.Items.Clear;
  anychange:=false;
end;

procedure Tmain_frm.new_mnuClick(Sender: TObject); //меню->новая//новая записная книга
begin
   trr.Items.Clear;
   anychange:=false;
end;

procedure Tmain_frm.open_mnuClick(Sender: TObject);//открытие файла
begin
   if opend.Execute then  trr.LoadFromFile(opend.FileName);
   trr.Update;
end;

procedure Tmain_frm.save_mnuClick(Sender: TObject);//сохранение файла
begin
  if saved.Execute then trr.SaveToFile(saved.FileName);
end;

procedure Tmain_frm.exit_mnuClick(Sender: TObject);//Выход из программы с определением изменения файла
procedure FullEXIT;
var answer:WORD;
begin
  if anychange then
    answer:=messagedlg('Вы хотите сохранить изменения?', mtwarning, mbYesNoCancel,0);
   if answer=mryes then
   if main_frm.saved.Execute then main_frm.trr.SaveToFile(main_frm.saved.FileName);
   if answer=mrcancel then
   else
   halt;
end;
begin
 FullExit;
end;




procedure Tmain_frm.MenuItem8Click(Sender: TObject);
begin

end;

procedure Tmain_frm.about_mnuClick(Sender: TObject);
begin
   showmessage('Число Пи равно' +#13+floattostr(PIEV(10000)))
end;





procedure Tmain_frm.trrSelectionChanged(Sender: TObject);//добавлено для того чтобы функции редактирования не вылетали с ошибкой
begin
  edit_btn.Enabled:=true;
  if trr.Items.GetLastNode.AbsoluteIndex>=0 then del_btn.Enabled:=true;
end;



initialization
  {$I unit1.lrs}

end.

