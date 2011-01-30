{***************************************************************
 *
 * Project  : Client
 * Unit Name: ClientMain
 * Purpose  : Demonstrates basic interaction of IdTCPClient with server
 * Date  : 16/01/2001  -  03:21:02
 * History  :
 *
 ****************************************************************}

unit ClientMain;

interface

uses
  {$IFDEF Linux}
  QForms, QGraphics, QControls, QDialogs, QStdCtrls, QExtCtrls,
  {$ELSE}
  windows, messages, graphics, controls, forms, dialogs, stdctrls, extctrls,
  {$ENDIF}
  SysUtils, Classes,
  IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, XPMan, ComCtrls;

type
  TForm2 = class(TForm)
    TCPClient: TIdTCPClient;
    pnlTop: TPanel;
    btnGo: TButton;
    XPManifest1: TXPManifest;
    Host: TEdit;
    Label1: TLabel;
    Timer: TTimer;
    Panel: TPanel;
    myMessage: TEdit;
    Send: TButton;
    Nick: TEdit;
    Label2: TLabel;
    AutoRefresh: TCheckBox;
    lstMain: TMemo;
    Users: TListBox;
    PageControl1: TPageControl;
    Chat: TTabSheet;
    Log: TTabSheet;
    MsgLog: TMemo;
    Privat: TEdit;
    Clear: TButton;
    myStatus: TComboBox;
  procedure btnGoClick(Sender: TObject);
    procedure HostChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure SendClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UsersClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
  private
  public
    procedure SendMessageAndRefresh( myMessage:String );
  end;

var
  Form2: TForm2;

implementation
{$IFDEF MSWINDOWS}{$R *.dfm}{$ELSE}{$R *.xfm}{$ENDIF}


// Any data received from the client is added as a text line in the ListBox
procedure TForm2.btnGoClick(Sender: TObject);
begin
  SendMessageAndRefresh( Nick.Text + ': ' + ' Connected...  '+IntToStr(Random(MaxLongInt)));
  AutoRefresh.Checked := true;
end;

procedure TForm2.HostChange(Sender: TObject);
var T:TextFile;
begin
(*  try
    AssignFile(T,'Chat.IP');
    Rewrite(T);
    Writeln(T,TCPClient.Host);
    CloseFile(T);
  except
  end; *)
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  T:TextFile;
  S:String;
begin
  Randomize;
  try
    AssignFile(T,'Chat.IP');
    Reset(T);
    Readln(T,S);
    Host.Text := S;
    CloseFile(T);
  except
    HostChange(nil);
  end;
  lstMain.Clear;
end;

procedure TForm2.SendMessageAndRefresh(myMessage: String);
var
  S:String;
begin
  with TCPClient do begin
    Connect;
    WriteLn(myMessage);
    WriteLn(IntToStr(lstMain.Lines.Count));
    try
      Users.Clear;
      while true do begin
        S := ReadLn;
        MsgLog.Lines.Add( TimeToStr(Time) +': '+ S);
        if S='' then break;
        if S[1]='/' then { Это ник пользователя }
          Users.Items.Add(Copy(S,2,Length(S)-1))
        else
          lstMain.Lines.Add(S); { Это сообщение }
      end;
    finally
      Disconnect;
    end;
  end;
end;

procedure TForm2.TimerTimer(Sender: TObject);
begin
  TCPClient.Host := Host.Text;
  if not AutoRefresh.Checked then exit;
  try
    SendMessageAndRefresh('[REFRESH]');
  except
    AutoRefresh.Checked := false;
  end;
end;

procedure TForm2.SendClick(Sender: TObject);
begin
  if myMessage.Text='' then begin
    SendMessageAndRefresh('[REFRESH]');
  end else begin
    if Privat.Text='' then { Сообщение в приват }
      SendMessageAndRefresh(Nick.Text + ': '+ myMessage.Text)
    else
      SendMessageAndRefresh(Nick.Text + ': '+Privat.Text+', '+ myMessage.Text);
    myMessage.Text := '';
  end;
  AutoRefresh.Checked := true;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  myMessage.SetFocus;
end;

procedure TForm2.UsersClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to Users.Items.Count-1 do
    if Users.Selected[i] then
      Privat.Text := Users.Items[i];
end;

procedure TForm2.ClearClick(Sender: TObject);
begin
  Privat.Text := '';
  myMessage.Text := '';
end;

end.
