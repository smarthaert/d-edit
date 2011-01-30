unit main_frm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, Menus, ExtCtrls;



type

  { TForm1 }

  TForm1 = class(TForm)
    btn_start: TButton;
    Inputmemo: TEdit;
    lst_log: TListBox;
    Sandbox: TPaintBox;
    procedure btn_startClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
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
inter=class(TInterpreter)
procedure execute(identifier:string;value:valueaccumulator);virtual;
end;

var parsr:Tinterpreter;grab:valueaccumulator;

{ TForm1 }

procedure circle(x,y,r:integer);
begin
 form1.Sandbox.Canvas.EllipseC(x,y,r,r);
end;

procedure inter.execute(identifier:string;value:valueaccumulator);
var valarr: array of integer;i:integer; erfolg:word;
begin
i:=0;
if identifier='круг' then
           begin
           setlength(valarr,3);
                               while not value.empty do
                                        begin
                                               inc(i);
                                               valarr[i]:=strtoint(value.get.str)
                                        end;
           circle(valarr[1],valarr[2],valarr[3]);
           end;

end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin

end;

procedure TForm1.btn_startClick(Sender: TObject);
var godobject:inter;id,err:shortstring;vall:valueaccumulator;
begin
vall.init;
  godobject.parse(inputmemo.Text,id,err,vall);
end;

initialization
  {$I main_frm.lrs}

end.

