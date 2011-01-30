program Railway;

uses
  Forms,
  Main in 'Main.pas' {F};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF, F);
  Application.Run;
end.
