unit InterFace_;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Server, StdCtrls, Base, Xml_Server, ExtCtrls, {RXClock,} xmldom,
  XMLIntf, msxmldom, XMLDoc, Monitor_XML;

Type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit2: TEdit;
    Edit1: TEdit;
    XMLDocument1: TXMLDocument;
    CollectorBTN: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CollectorBTNClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Var Form1 : TForm1;
{    LibHandle   : THandle;
    SendMessage : TSendMessage;
    AcceptMessage : TAcceptMessage;
    GiveUsers : TGiveUsers;}

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  LibHandle := LoadLibrary(PChar('Dir.dll'));
  Config := NewServer; // Создали Переменную
  Config := LoadServer('Server.xml'); // Загрузили конфиг
  @SendUserMessage := GetProcAddress(LibHandle, 'SendMessage');
  @AcceptMessage := GetProcAddress(LibHandle, 'AcceptMessage');
  @GiveUsers := GetProcAddress(LibHandle, 'GiveUsers');
  If (@AcceptMessage = nil) or (@SendMessage = nil) or (@GiveUsers = nil) then
    Begin
      ShowMessage('Can''t load "Dir.dll"');
      Exit;
    End;
  GiveUsers(Config.USERS);
  XMonitor := NewMONITOR;
  XMonitor := LoadMONITOR('monitor.xml');
  Contest_Start:= StrToTime(Config.CONTEST.Start);
  Collector := TCollector.Create(False);
  Compiler := TCompiler.Create(False);
  Answer := TAnswer.Create(False);
end;

procedure TForm1.CollectorBTNClick(Sender: TObject);
begin
  If CollectorBTN.Caption='Kill Collector' then begin
    Collector.Suspend;
    CollectorBTN.Caption:='Run Collector';
  end else begin
    Collector.Resume;
    CollectorBTN.Caption:='Kill Collector';
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Collector.Suspend;  // Убиваем все известные нам потоки
     Collector.Kill;
     Compiler.Suspend;
     Compiler.Kill;
     Answer.Suspend;
     Answer.Kill;
   FreeLibrary(LibHandle);  // убиваем dll-ку, чтобы дала нам спокойно завершиться
   LibHandle := 0;
end;

end.
