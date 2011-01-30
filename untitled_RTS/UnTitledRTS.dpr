program UnTitledRTS;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm},
  Menu in 'Menu.pas',
  DXWPath in 'DXWPath.pas',
  GameSpritesUnit in 'GameSpritesUnit.pas',
  SceneMainUnit in 'SceneMainUnit.pas',
  DXWNavigator in 'DXWNavigator.pas',
  DXWImageSprite in 'DXWImageSprite.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DelphiX Sample';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
