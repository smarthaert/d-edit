unit Unit1; 
//TODO вывести программу из цикла
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls,Menus, SynEdit;

type

  { TForm1 }

  TForm1 = class(TForm)
    btn_all: TButton;
    btn_step: TButton;
    btn_reset: TButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    mn_new: TMenuItem;
    mn_open: TMenuItem;
    mn_save: TMenuItem;
    mn_exit: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    monitor: TLabel;
    logbox: TListBox;
    opdlg: TOpenDialog;
    pb: TPaintBox;
    svdlg: TSaveDialog;
    mm_input: TSynEdit;
    procedure btn_allClick(Sender: TObject);
    procedure btn_stepClick(Sender: TObject);
    procedure btn_resetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mm_inputChange(Sender: TObject);
    procedure mn_exitClick(Sender: TObject);
    procedure mn_newClick(Sender: TObject);
    procedure mn_openClick(Sender: TObject);
    procedure mn_saveClick(Sender: TObject);
    //procedure monitorClick(Sender: TObject);
    //procedure SynEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation
 uses parslib;


 type

 parseex=object(TInterpreter)
 procedure execute;virtual;
 procedure showerror;virtual;
 end;

 procedure parseex.showerror;
 begin
 form1.logbox.Items.Add('At '+inttostr(debugpos)+' '+cerror);
 end;

 procedure parseex.execute;


 begin
 {if (ident<>'circle') or (ident<>'line') or (ident<>'ellipse') or (ident<>'rectangle') or (ident<>'pie') or (ident<>'arc') or (ident<>'chord')  then
 begin
 cerror:='identifier '+ident+' not found';
 end;}
 if (ident='circle') and (length(valparr)=3) then form1.pb.Canvas.EllipseC(valparr[0],valparr[1],valparr[2],valparr[2]);
 if (ident='line') and (length(valparr)=4) then form1.pb.Canvas.Line(valparr[0],valparr[1],valparr[2],valparr[3]);
 if (ident='ellipse') and (length(valparr)=4) then form1.pb.Canvas.EllipseC(valparr[0],valparr[1],valparr[2],valparr[2]);
 if (ident='rectangle') and (length(valparr)=4) then form1.pb.Canvas.Rectangle(valparr[0],valparr[1],valparr[2],valparr[3]);
 if (ident='pie') and (length(valparr)=8) then form1.pb.Canvas.Pie(valparr[0],valparr[1],valparr[2],valparr[3],valparr[4],valparr[5],valparr[6],valparr[7]);
 if (ident='arc') and (length(valparr)=8) then form1.pb.Canvas.Arc(valparr[0],valparr[1],valparr[2],valparr[3],valparr[4],valparr[5],valparr[6],valparr[7]);
 if (ident='chord') and (length(valparr)=8) then form1.pb.Canvas.Chord(valparr[0],valparr[1],valparr[2],valparr[3],valparr[4],valparr[5],valparr[6],valparr[7])

 end;

 var drawer:parseex;
{ TForm1 }

procedure TForm1.btn_allClick(Sender: TObject);
begin

   if (mm_input.Text+' '<>drawer.inputstr) then
   begin
   pb.Canvas.Clear;
   drawer.DebugPos:=1;
   drawer.inputstr:=mm_input.Text;
   end;

  while not(drawer.DebugPos=length(drawer.inputstr)) and (drawer.cerror='') do
  begin
   drawer.parse;
   if drawer.cerror='' then drawer.execute;

  end;
end;

procedure TForm1.btn_stepClick(Sender: TObject);
begin
if (mm_input.Text+' '<>drawer.inputstr) then
   begin
   drawer.DebugPos:=1;
   drawer.inputstr:=mm_input.Text;
   end;
  drawer.parse;
  drawer.execute;
  monitor.Caption:=inttostr(drawer.DebugPos);
end;

procedure TForm1.btn_resetClick(Sender: TObject);
begin
  drawer.DebugPos:=1;
  pb.Canvas.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   drawer.Init;
end;

procedure TForm1.mm_inputChange(Sender: TObject);
begin

end;

procedure TForm1.mn_exitClick(Sender: TObject);
begin
  halt;
end;

procedure TForm1.mn_newClick(Sender: TObject);
begin
  mm_input.ClearAll;
end;

procedure TForm1.mn_openClick(Sender: TObject);

begin
try

  if opdlg.Execute then mm_input.Lines.LoadFromFile(opdlg.FileName);
  form1.caption:='Графический парсер -'+ opdlg.filename;

except
 showmessage('Не могу открыть файл, его либо нет, либо прав у вас нет');
end;
end;

procedure TForm1.mn_saveClick(Sender: TObject);
begin
    try
  if svdlg.Execute then mm_input.Lines.SaveToFile(svdlg.FileName);
  except
 showmessage('Не могу сохранить файл, его либо нет, либо прав у вас нет');
end;
end;

{procedure TForm1.monitorClick(Sender: TObject);
begin

  mm_input.Text:='circle(10,10,10);circle(20,20,10);'

end;}



initialization
  {$I unit1.lrs}

end.

