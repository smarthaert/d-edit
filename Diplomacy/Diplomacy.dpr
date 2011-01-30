program Diplomacy;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  NewGameUnit in 'NewGameUnit.pas' {NewGameForm},
  GameUnit in 'GameUnit.pas' {GameForm},
  WorldUnit in 'WorldUnit.pas',
  SpeakUnit in 'SpeakUnit.pas' {SpeakForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TNewGameForm, NewGameForm);
  Application.CreateForm(TGameForm, GameForm);
  Application.CreateForm(TSpeakForm, SpeakForm);
  Application.Run;
end.
