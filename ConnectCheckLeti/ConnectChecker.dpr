program ConnectChecker;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  HostSettings in 'HostSettings.pas' {HostSettingsForm},
  About in 'About.pas' {AboutForm},
  HostClass in 'HostClass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ArgosConnectChecker';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

