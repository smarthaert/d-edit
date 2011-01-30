program SeaWars;

uses
  Forms,
  Windows,
  Main_fm in 'Main_fm.pas' {fmMain},
  EGM24 in 'EGM24.pas';

{$R R256C.RES}


begin
  Application.Icon.Handle:=LoadIcon(hInstance,'ICMAIN');
  Application.Initialize;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
