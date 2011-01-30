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
  UTankTypes in 'UTankTypes.pas';

{$R *.RES}

begin
  If ParamCount=1 then
    MapName:=ParamStr(1);
  Application.Initialize;
  Application.Title := 'Tanks 2004';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
