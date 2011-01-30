program DreamClient;

{%File 'Dir.dpr'}

uses
  Forms,
  DreamUnit in 'DreamUnit.pas' {F},
  monitor_XML in 'monitor_XML.pas',
  User_Xml in 'User_Xml.pas',
  Arhive_Xml in 'Arhive_Xml.pas',
  MessageUnit in 'MessageUnit.pas' {MF};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TF, F);
  Application.CreateForm(TMF, MF);
  Application.Run;
end.
