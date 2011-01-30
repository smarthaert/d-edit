unit BrowserUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Sockets, XPMan, OleCtrls, SHDocVw, ExtCtrls, StdCtrls;

type
  TBrowserForm = class(TForm)
    XPManifest1: TXPManifest;
    TcpClient1: TTcpClient;
    TcpServer1: TTcpServer;
    MainWB: TWebBrowser;
    Panel1: TPanel;
    SiteURL: TEdit;
    GoButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrowserForm: TBrowserForm;

implementation

{$R *.dfm}

procedure TBrowserForm.FormCreate(Sender: TObject);
begin
  SiteURL.Text := 'http://google.com';
  MainWB.Navigate(SiteURL.Text);
end;

procedure TBrowserForm.GoButtonClick(Sender: TObject);
begin
  MainWB.Navigate(SiteURL.Text);
end;

end.
