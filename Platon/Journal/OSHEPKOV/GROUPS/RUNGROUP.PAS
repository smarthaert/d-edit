unit RunGroup;

interface

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DataForm: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure DataFormClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var Form1:TForm1;

implementation
{$R *.DFM}

 var Degree:byte;
 var Order:longint;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Close;
end;

 procedure MakeDegree(s:string);
begin
 if (Degree=0) and (length(s)>0)
 then Degree:=Pos(',',s)+Pos(';',s)-1;
end;

 procedure TForm1.DataFormClick(Sender: TObject);
 var f:TextFile; S:string;
begin
  AssignFile(F,'Group.sub');   { File selected in dialog box }
  Reset(F);
  Repeat
   Readln(F, S);               { Read the first line out of the file }
   MakeDegree(S);
   Memo1.Lines.Add(S);         { Put string in a TEdit control }
   Edit1.Text:='  '+IntToStr(Degree);
  Until Eof(f);
  CloseFile(F);
 Edit4.Text:=' Загружен Group.sub';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Memo1.Lines.Clear;
 Degree:=0;
 Order:=0;
 Edit1.Text:='  '+IntToStr(Degree);
 Edit2.Text:='  '+IntToStr(Order);
 Edit4.Text:=' Сброшен';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Degree:=0;
end;

procedure TForm1.Memo1Change(Sender: TObject);
 var n:integer;
begin
 n:=Pos(',',Memo1.Text);
 if n>0 then Degree:=n-1;
 Order:=length(Memo1.Text) div (1+Degree);
 Edit1.Text:='  '+IntToStr(Degree);
 Edit2.Text:='  '+IntToStr(Order);
end;

end.

