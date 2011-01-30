program Paint;

uses
  Forms,
  PaintMain in 'PaintMain.pas' {MainPaintForm},
  NewParametersWindow in 'NewParametersWindow.pas' {NewParameters},
  Figures in 'Figures.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainPaintForm, MainPaintForm);
  Application.CreateForm(TNewBMPForm, NewParameters);
  Application.Run;
end.

