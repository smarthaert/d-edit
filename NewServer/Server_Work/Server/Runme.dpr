program Runme;

{%File 'Dir.dpr'}
{%File 'server.xml'}

uses
  Forms,
  InterFace_ in 'InterFace_.pas' {Form1},
  Xml_Server in 'Xml_Server.pas',
  monitor_XML in 'monitor_XML.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
