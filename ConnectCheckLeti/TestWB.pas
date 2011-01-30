unit TestWB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, ActiveX, HTTPApp, SHDocVw;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    Button2: TButton;
    WebDispatcher1: TWebDispatcher;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function WB_GetHTMLCode(WebBrowser: TWebBrowser; var ACode: TStringList): Boolean;
 var
   ps: IPersistStreamInit;
   ss: TStringStream;
   sa: IStream;
   s: string;
 begin
   ps := WebBrowser.Document as IPersistStreamInit;
   s := '';
   ss := TStringStream.Create(s);
   try
     sa := TStreamAdapter.Create(ss, soReference) as IStream;
     Result := Succeeded(ps.Save(sa, True));
     if Result then ACode.Add(ss.Datastring);
   finally
     ss.Free;
   end;
 end;

procedure TForm1.Button1Click(Sender: TObject);
begin
WebBrowser1.Navigate('pointer.argosgrp.ru');

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  s: TStringList;
begin
  s := TStringList.Create;
  WB_GetHTMLCode(WebBrowser1, s);
  ShowMessage(s.Text);
end;

end.
