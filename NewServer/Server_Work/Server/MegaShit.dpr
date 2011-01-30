program MegaShit;

uses
  Forms,
  MegaShitUnit in 'MegaShitUnit.pas' {Form1},
  Base in 'Base.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
