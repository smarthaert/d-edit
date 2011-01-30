program WebBrowser;

uses
  Forms,
  BrowserUnit in 'BrowserUnit.pas' {BrowserForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TBrowserForm, BrowserForm);
  Application.Run;
end.
