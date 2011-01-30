program Contest;

uses
  Forms,
  Start in 'Start.pas' {MainWindow};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainWindow, MainWindow);
  Application.Run;
end.
