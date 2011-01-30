{***************************************************************
 *
 * Project  : Server
 * Unit Name: ServerMain
 * Purpose  : Demonstrates basic use of IdTCPServer
 * Date  : 16/01/2001  -  03:19:36
 * History  :
 *
 ****************************************************************}

unit ServerMain;

interface

uses
  SysUtils, Classes,
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs,
  {$ELSE}
  graphics, controls, forms, dialogs,
  {$ENDIF}
  IdBaseComponent, IdComponent, IdTCPServer, StdCtrls, XPMan;

type
  TfrmServer = class(TForm)
    TCPServer: TIdTCPServer;
    XPManifest1: TXPManifest;
    Log: TMemo;
    Users: TListBox;
  procedure FormCreate(Sender: TObject);
  procedure TCPServerExecute(AThread: TIdPeerThread);
  private
  public
    procedure workWithNick( ClientMessage : String );
  end;

var
  frmServer: TfrmServer;

implementation

uses IdTCPConnection;
{$IFDEF MSWINDOWS}{$R *.dfm}{$ELSE}{$R *.xfm}{$ENDIF}

procedure TfrmServer.FormCreate(Sender: TObject);
begin
  TCPServer.Active := True;
  Log.Clear;
end;

// Any client that makes a connection is sent a simple message,
// then disconnected.
procedure TfrmServer.TCPServerExecute(AThread: TIdPeerThread);
var
  ClientMessage : String;
  ClientLines,i,j : Integer;
begin
  with AThread.Connection do begin
    ClientMessage := ReadLn;
    ClientLines := StrToInt(Readln);
    if ClientMessage<>'[REFRESH]' then begin
      workWithNick( ClientMessage );
      Log.Lines.Add('#'+IntToStr(Log.Lines.Count+1)+': '+ClientMessage);
    end;
    for i:=ClientLines to Log.Lines.Count-1 do WriteLn(Log.Lines[i]);
    for j:=0 to Users.Items.Count-1 do WriteLn('/'+Users.Items[j]);
    WriteLn;
    Disconnect;
  end;
end;

procedure TfrmServer.workWithNick(ClientMessage: String);
var UserNick : String;
begin
  assert( Pos(':',ClientMessage)<>0 );
  UserNick := Copy( ClientMessage, 1, Pos(':',ClientMessage)-1 );
  if Users.Items.IndexOf(UserNick)=-1 then
    Users.Items.Add(UserNick);
end;

end.
