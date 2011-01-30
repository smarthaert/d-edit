program Sprite1;

uses
  Windows,
  Forms,
  Main in 'Main.pas' {MainForm},
  UMap in 'UMap.pas',
  UUnits in 'UUnits.pas',
  Base in 'Base.pas',
  ULog in 'ULog.pas',
  UMyMenu in 'UMyMenu.pas',
  UBeforeGame in 'UBeforeGame.pas',
  Pointers in 'Pointers.pas',
  UTankTypes in 'UTankTypes.pas',
  URedefineKeys in 'URedefineKeys.pas',
  UBGMenus in 'UBGMenus.pas',
  MapPreview in 'MapPreview.pas',
  UBonusSpawner in 'UBonusSpawner.pas',
  UFPS in 'UFPS.pas',
  USkill in 'USkill.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Tanks 2004';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
