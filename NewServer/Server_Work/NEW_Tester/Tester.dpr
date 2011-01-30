program Tester;

uses
  Forms,
  TersterUnit in 'TersterUnit.pas' {Form1},
  FmxUtils in 'FmxUtils.pas',
  Tester_Xml in 'Tester_Xml.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
