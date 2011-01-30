unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, RzLstBox, RzChkLst, RzButton, ImgList,
  RzPanel, ExtCtrls, XPMan, ComCtrls, OleCtrls, SHDocVw, RzTabs;

type
  TCorrectConnection = array[0..2] of boolean;

  TConnectSettings = class
  private
    csName: string;
    csHost, csAltHost, csAltHost1: string;
    csPort, csAltPort, csAltPort1: integer;
    csHasAlt, csHasAlt1: boolean;
    csCorrect: TCorrectConnection;
    csWork: integer;
    csProtocol: string;
    csAnswer: string;
    function csIsCorrect: boolean;
  public
    constructor Create; overload;
    constructor Create(hname: string; hst: string; prt: integer; prot: string);
      overload;
    constructor Create(hname: string; hst: string; prt: integer; ha: boolean;
      ahost: string; aport: integer; prot: string); overload;
    constructor Create(hname: string; hst: string; prt: integer; ha: boolean;
      ahost: string; aport: integer; ha1: boolean; ahost1: string; aport1:
      integer; prot: string); overload;
    constructor Create(hname: string; hst: string; prt: integer; ha: boolean;
      ahost: string; aport: integer; ha1: boolean; ahost1: string; aport1:
      integer; ans: string; prot: string); overload;
    constructor Create(srvstr: string); overload;
    procedure SetSocketSettings(sckt: TClientSocket; vrt: integer = 0);
    function ToString: string;
    procedure SetCorrect;
    function HasHost: boolean;
    function GetCorrect: integer;

    property Name: string read csName write csName;
    property Host: string read csHost write csHost;
    property Port: integer read csPort write csPort;
    property HasAlternate: boolean read csHasAlt write csHasAlt;
    property AlternateHost: string read csAltHost write csAltHost;
    property AlternatePort: integer read csAltPort write csAltPort;
    property HasAlternate1: boolean read csHasAlt1 write csHasAlt1;
    property AlternateHost1: string read csAltHost1 write csAltHost1;
    property AlternatePort1: integer read csAltPort1 write csAltPort1;
    property WorkingHost: integer read csWork write csWork;
    property IsCorrect: boolean read csIsCorrect;
    property Answer: string read csAnswer write csAnswer;
    property Correct: TCorrectConnection read csCorrect write csCorrect;
    property Protocol: string read csProtocol write csProtocol;
  end;

  TMainForm = class(TForm)
    Connection: TClientSocket;
    Timer1: TTimer;
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    Servers: TRzCheckList;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    BtnInsertRecord: TRzToolButton;
    BtnDeleteRecord: TRzToolButton;
    BtnEdit: TRzToolButton;
    RzSpacer1: TRzSpacer;
    BtnInternet: TRzToolButton;
    Splitter1: TSplitter;
    WebBrowser1: TWebBrowser;
    Button1: TButton;
    XPManifest2: TXPManifest;
    RzSpacer2: TRzSpacer;
    Timer2: TTimer;
    BtnProperties: TRzToolButton;
    BtnChangeOptions: TRzToolButton;
    RzSpacer3: TRzSpacer;
    BtnHelp: TRzToolButton;
    RzSpacer4: TRzSpacer;
    Pages: TRzPageControl;
    Log: TRzTabSheet;
    Result: TRzTabSheet;
    ResultMemo: TRichEdit;
    ResultList: TListBox;
    procedure ConnectionRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure BtnInsertRecordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnInternetClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ConnectionError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDeleteRecordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ServersDblClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure ResultMemoChange(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BtnPropertiesClick(Sender: TObject);
    procedure BtnChangeOptionsClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure ServersClick(Sender: TObject);
    procedure ResultListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Hosts: array of TConnectSettings;
  CurrentIndex: integer;
  curmethod: string;
  DocComplete: boolean = false;
  n1, n2, n3, n4: integer;

procedure LoadItems(list: TRzCheckList);
function GetFileVersion(const sFilename: string; var nValue1, nValue2, nValue3,
  nValue4: Integer): string;
function WB_GetHTMLCode(WebBrowser: TWebBrowser; var ACode: TStringList):
  Boolean;
procedure CheckConnection();
procedure CheckResult;

implementation

uses HostSettings, ActiveX, About;

{$R *.dfm}

procedure CheckResult;
var
  i: integer;
begin
  MainForm.ResultList.Clear;
  for i := 0 to Length(Hosts) - 1 do
  begin
    if not MainForm.Servers.ItemChecked[i] then
      Continue;
    MainForm.ResultList.Items.Add(inttostr(I) + ';' +
      inttostr(Hosts[i].GetCorrect));
  end;
  MainForm.Pages.ActivePage := MainForm.Result;
end;

procedure CheckConnection();
begin
  with MainForm do
  begin
    Hosts[CurrentIndex].WorkingHost := Hosts[CurrentIndex].WorkingHost + 1;
    if Hosts[CurrentIndex].IsCorrect or not Hosts[CurrentIndex].HasHost then
    begin
      repeat
        Hosts[CurrentIndex].WorkingHost := -1;
        inc(CurrentIndex);
        if CurrentIndex >= Length(Hosts) then
          Break;
        Hosts[CurrentIndex].WorkingHost := Hosts[CurrentIndex].WorkingHost + 1;
      until Servers.ItemChecked[CurrentIndex] and
        Hosts[CurrentIndex].HasHost and (CurrentIndex < Length(Hosts));
    end;
    if CurrentIndex >= Length(Hosts) then
    begin
      ResultMemo.WordWrap := true;
      CheckResult;
      Exit;
    end;
    try
      DocComplete := false;
      if Hosts[CurrentIndex].Protocol <> 'HTTP' then
      begin
        Connection.Close;
        Connection.Destroy;
        Connection := TClientSocket.Create(MainForm);
        Connection.Active := false;
        Connection.Name := 'Connection';
        Connection.ClientType := ctNonBlocking;
        Connection.OnRead := ConnectionRead;
        Connection.OnError := ConnectionError;
        Hosts[CurrentIndex].SetSocketSettings(Connection);
        ResultMemo.Lines.Add('Соединение с сервером ' + Connection.Host +
          ' порт ' + inttostr(Connection.Port) + '...');
        Connection.Open;
      end
      else if Hosts[CurrentIndex].Protocol = 'HTTP' then
      begin
        ResultMemo.Lines.Add('Соединение с сервером ' + Hosts[CurrentIndex].Host
          + ' порт ' + inttostr(Hosts[CurrentIndex].Port) + '...');
        WebBrowser1.Navigate(Hosts[CurrentIndex].Host);
      end;
      Timer2.Enabled := true;
    except
      on e: Exception do
        MessageDlg('Ошибка соединения.' + #13#10 + e.Message, mtError, [mbOk],
          0);
    end
  end;
end;

function GetFileVersion(const sFilename: string; var nValue1, nValue2, nValue3,
  nValue4: Integer): string;
var
  pInfo, pPointer: Pointer;
  nSize: DWORD;
  nHandle: DWORD;
  pVerInfo: PVSFIXEDFILEINFO;
  nVerInfoSize: DWORD;
begin
  {
  Эта функция возвратит строку в формате 'n.n.n.n'
  и также выдвигает значения в переменные, переданные по ссылке.
  }
  Result := '?.?.?.?';
  nValue1 := -1;
  nValue2 := -1;
  nValue3 := -1;
  nValue4 := -1;

  nSize := GetFileVersionInfoSize(PChar(sFilename), nHandle);
  if (nSize <> 0) then
  begin
    GetMem(pInfo, nSize);
    try
      FillChar(pInfo^, nSize, 0);

      if (GetFileVersionInfo(PChar(sFilename), nHandle, nSize, pInfo)) then
      begin
        nVerInfoSize := SizeOf(VS_FIXEDFILEINFO);
        GetMem(pVerInfo, nVerInfoSize);
        try
          FillChar(pVerInfo^, nVerInfoSize, 0);
          pPointer := Pointer(pVerInfo);
          VerQueryValue(pInfo, '\', pPointer, nVerInfoSize);
          nValue1 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionMS shr 16;
          nValue2 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionMS and $FFFF;
          nValue3 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionLS shr 16;
          nValue4 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionLS and $FFFF;

          Result := IntToStr(nValue1) + '.' + IntToStr(nValue2) + '.' +
            IntToStr(nValue3);
        finally
          FreeMem(pVerInfo, nVerInfoSize);
        end;
      end;
    finally
      FreeMem(pInfo, nSize);
    end;
  end;
end;

function WB_GetHTMLCode(WebBrowser: TWebBrowser; var ACode: TStringList):
  Boolean;
var
  ps: IPersistStreamInit;
  ss: TStringStream;
  sa: IStream;
  s: string;
begin
  ps := WebBrowser.Document as IPersistStreamInit;
  s := '';
  ss := TStringStream.Create(s);
  try
    sa := TStreamAdapter.Create(ss, soReference) as IStream;
    Result := Succeeded(ps.Save(sa, True));
    if Result then
      ACode.Add(ss.Datastring);
  finally
    ss.Free;
  end;
end;

procedure LoadItems(list: TRzCheckList);
var
  i: integer;
  flst: TStringList;
begin
  if not FileExists('servers.lst') then
    Exit;
  flst := TStringList.Create;
  flst.LoadFromFile('servers.lst');
  for i := 0 to flst.Count - 1 do
  begin
    SetLength(Hosts, Length(Hosts) + 1);
    Hosts[Length(Hosts) - 1] := TConnectSettings.Create(flst[i]);
  end;
  List.Clear;
  for i := 0 to Length(Hosts) - 1 do
    list.Add(Hosts[i].Name);
  List.CheckAll;
end;

procedure TMainForm.ConnectionRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s: string;
begin
  s := Socket.ReceiveText;
  ResultMemo.Lines.Add('Ответ от сервера>> ' + s);
  if (Hosts[CurrentIndex].Answer = '') or (pos(Hosts[CurrentIndex].Answer, s) >
    0) then
    Hosts[CurrentIndex].SetCorrect;
  DocComplete := true;
  Timer2.Enabled := false;
  CheckConnection;
end;

{ TConnectSettings }

constructor TConnectSettings.Create;
begin
  csName := '';
  csHost := '';
  csPort := 0;
  csAltHost := '';
  csAltPort := 0;
  csAltHost1 := '';
  csAltPort1 := 0;
  csHasAlt := false;
  csHasAlt1 := false;
  csWork := -1;
  csCorrect[0] := false;
  csCorrect[1] := false;
  csCorrect[2] := false;
  csProtocol := '';
end;

constructor TConnectSettings.Create(hname: string; hst: string; prt: integer;
  prot: string);
begin
  Create;
  if hst = '' then
    Exit;
  csName := hname;
  csHost := hst;
  csPort := prt;
  csProtocol := prot;
  if csPort = 80 then
    csProtocol := 'HTTP';
end;

constructor TConnectSettings.Create(hname: string; hst: string; prt: integer;
  ha: boolean; ahost: string;
  aport: integer; prot: string);
begin
  Create(hname, hst, prt, prot);
  if (ahost = '') or not ha then
    Exit;
  csAltHost := ahost;
  csAltPort := aport;
  csHasAlt := true;
end;

constructor TConnectSettings.Create(hname: string; hst: string; prt: integer;
  ha: boolean; ahost: string; aport: integer; ha1: boolean; ahost1: string;
  aport1: integer; prot: string);
begin
  Create(hname, hst, prt, ha, ahost, aport, prot);
  if (ahost1 = '') or not ha1 then
    Exit;
  csAltHost1 := ahost1;
  csAltPort1 := aport1;
  csHasAlt1 := true;
end;

constructor TConnectSettings.Create(srvstr: string);
var
  s, s1: string;
begin
  Create;
  s := srvstr;

  csName := copy(s, 1, pos(';', s) - 1);
  delete(s, 1, pos(';', s));

  csHost := copy(s, 1, pos(';', s) - 1);
  delete(s, 1, pos(';', s));
  s1 := copy(s, 1, pos(';', s) - 1);
  if not TryStrToInt(s1, csPort) then
    csPort := 65000;
  delete(s, 1, pos(';', s));
  if csPort = 80 then
    csProtocol := 'HTTP';
  if s = '' then
    Exit;

  csAltHost := copy(s, 1, pos(';', s) - 1);
  csHasAlt := csAltHost <> '';
  delete(s, 1, pos(';', s));
  s1 := copy(s, 1, pos(';', s) - 1);
  if not TryStrToInt(s1, csAltPort) then
    csAltPort := 65000;
  delete(s, 1, pos(';', s));
  if s = '' then
    Exit;

  csAltHost1 := copy(s, 1, pos(';', s) - 1);
  csHasAlt1 := csAltHost1 <> '';
  delete(s, 1, pos(';', s));
  s1 := copy(s, 1, pos(';', s) - 1);
  if not TryStrToInt(s1, csAltPort1) then
    csAltPort1 := 65000;
  delete(s, 1, pos(';', s));

  csAnswer := copy(s, 1, pos(';', s) - 1);
end;

constructor TConnectSettings.Create(hname, hst: string; prt: integer;
  ha: boolean; ahost: string; aport: integer; ha1: boolean; ahost1: string;
  aport1: integer; ans, prot: string);
begin
  Create(hname, hst, prt, ha, ahost, aport, ha1, ahost1, aport1, prot);
  csAnswer := ans;
end;

function TConnectSettings.csIsCorrect: boolean;
begin
  Result := csCorrect[0] or csCorrect[1] or csCorrect[2];
end;

function TConnectSettings.GetCorrect: integer;
begin
  Result := -1;
  if not csIsCorrect then
    Exit;
  if csCorrect[0] then
    Result := 0;
  if csCorrect[1] then
    Result := 1;
  if csCorrect[2] then
    Result := 2;
end;

function TConnectSettings.HasHost: boolean;
begin
  Result := false;
  case csWork of
    0: Result := csHost <> '';
    1: Result := csHasAlt;
    2: Result := csHasAlt1;
  end;
end;

procedure TConnectSettings.SetCorrect;
begin
  csCorrect[csWork] := true;
end;

procedure TConnectSettings.SetSocketSettings(sckt: TClientSocket; vrt: integer
  = 0);
begin
  with sckt do
  begin
    Socket.Close;
    Close;
    case csWork of
      0:
        begin
          Host := csHost;
          Port := csPort;
        end;
      1:
        begin
          Host := csAltHost;
          Port := csAltPort;
        end;
      2:
        begin
          Host := csAltHost1;
          Port := csAltPort1;
        end;
    end;
  end;
end;

procedure TMainForm.BtnInsertRecordClick(Sender: TObject);
begin
  Application.CreateForm(THostSettingsForm, HostSettingsForm);
  with HostSettingsForm do
  begin
    ShowModal;
    if ModalResult = mrOk then
    begin
      SetLength(Hosts, Length(Hosts) + 1);
      Hosts[Length(Hosts) - 1] := TConnectSettings.Create(NameEdit.Text,
        HostEdit.Text, PortEdit.IntValue, HasAltCB.Checked, AltHostEdit.Text,
        AltPortEdit.IntValue, HasAlt1CB.Checked, AltHost1Edit.Text,
        AltPort1Edit.IntValue, AnswerEdit.Text, '');
      Servers.Add(Hosts[Length(Hosts) - 1].Name);
    end;
    Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SetLength(Hosts, 0);
  LoadItems(Servers);
  Servers.ItemIndex := 0;
  Pages.ActivePage := Log;
end;

procedure TMainForm.BtnInternetClick(Sender: TObject);
begin
  if Length(Hosts) < 1 then
  begin
    BtnInsertRecordClick(BtnInsertRecord);
    Exit;
  end;
  if Servers.ItemsChecked < 1 then
  begin
    MessageDlg('Не выбрано ни одного сервера.', mtInformation, [mbOk], 0);
    Exit;
  end;
  ResultMemo.Clear;
  CurrentIndex := 0;
  ResultMemo.WordWrap := false;
  //Timer1Timer(Timer1);
  Pages.ActivePage := Log;
  CheckConnection;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  {  try
      Timer2.Enabled := false;
      repeat
        inc(CurrentIndex);
        if CurrentIndex >= Servers.Items.Count then
        begin
          Connection.Close;
          ResultMemoChange(ResultMemo);
          ResultMemo.WordWrap := true;
          Exit;
        end;
      until Servers.ItemChecked[CurrentIndex];

      Connection.Free;
      Connection := TClientSocket.Create(Self);
      Connection.Name := 'Connection';
      Connection.ClientType := ctNonBlocking;
      Connection.OnRead := ConnectionRead;
      Connection.OnError := ConnectionError;
      Connection.Active := false;

      if Hosts[CurrentIndex].Protocol <> 'HTTP' then
      begin
        {
        Connection.Socket.Close;

        ResultMemo.Lines.Add('Подключение к серверу: ' + Hosts[CurrentIndex].Host
          + ' порт ' + inttostr(Hosts[CurrentIndex].Port) + '...');
        Hosts[CurrentIndex].SetSocketSettings(Connection);
        Connection.Active := true;
        //Connection.Open;
        {
      end
      else if Hosts[CurrentIndex].Protocol = 'HTTP' then
      begin
        ResultMemo.Lines.Add('Подключение к серверу: ' + Hosts[CurrentIndex].Host
          + ' порт 80...');
        DocComplete := false;
        WebBrowser1.Navigate(Hosts[CurrentIndex].Host);
        Timer2.Enabled := true;
      end
    except
      on e: Exception do
      begin
        MessageDlg('Ошибка: ' + e.Message, mtError, [mbOk], 0);
      end;
    end;      }
end;

procedure TMainForm.ConnectionError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  ErrorCode := 0;
  ResultMemo.Lines.Add('Подключение не удалось.');
  ResultMemo.Lines.Add('');
  DocComplete := true;
  Timer2.Enabled := false;
  CheckConnection;
end;

procedure TMainForm.BtnEditClick(Sender: TObject);
begin
  if servers.ItemIndex < 0 then
    Exit;
  Application.CreateForm(THostSettingsForm, HostSettingsForm);
  with HostSettingsForm, hosts[servers.ItemIndex] do
  begin
    NameEdit.Text := hosts[servers.ItemIndex].Name;
    HostEdit.Text := Host;
    PortEdit.IntValue := Port;
    HasAltCB.Checked := HasAlternate;
    HasAlt1CB.Checked := HasAlternate1;
    if HasAlternate then
    begin
      AltHostEdit.Text := AlternateHost;
      AltPortEdit.IntValue := AlternatePort;
    end;
    if HasAlternate1 then
    begin
      AltHost1Edit.Text := AlternateHost1;
      AltPort1Edit.IntValue := AlternatePort1;
    end;
    AnswerEdit.Text := Answer;
    ShowModal;
    if ModalResult = mrOk then
    begin
      Hosts[servers.ItemIndex] := TConnectSettings.Create(NameEdit.Text,
        HostEdit.Text, PortEdit.IntValue, HasAltCB.Checked, AltHostEdit.Text,
        AltPortEdit.IntValue, HasAlt1CB.Checked, AltHost1Edit.Text,
        AltPort1Edit.IntValue, AnswerEdit.Text, '');
      Servers.Items[servers.ItemIndex] := Hosts[servers.ItemIndex].Name;
    end;
    HostSettingsForm.Free;
  end;
  Servers.SetFocus;
end;

procedure TMainForm.BtnDeleteRecordClick(Sender: TObject);
var
  i: integer;
begin
  if Servers.ItemIndex < 0 then
    Exit;
  for i := servers.ItemIndex to Length(Hosts) - 1 do
    Hosts[I] := Hosts[I + 1];
  SetLength(Hosts, Length(Hosts) - 1);
  Servers.DeleteSelected;
  Servers.SetFocus;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  lst: TStringList;
  i: integer;
begin
  try
    lst := TStringList.Create;
    for i := 0 to Length(Hosts) - 1 do
    begin
      lst.Add(Hosts[i].ToString);
      //lst.Add(inttostr(Hosts[i].Port));
    end;
    Lst.SaveToFile('servers.lst');
  except
    on e: Exception do
    begin
      MessageDlg('Ошибка при закрытии программы. ' + e.Message, mtError,
        [mbOk], 0);
      Application.Terminate;
    end;
  end;
end;

procedure TMainForm.ServersDblClick(Sender: TObject);
begin
  if Servers.ItemIndex >= 0 then
    BtnEditClick(BtnEdit);
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_F5 then
    BtnInternetClick(BtnInternet);
end;

procedure TMainForm.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  s: TStringList;
begin
  DocComplete := true;
  Timer2.Enabled := false;
  s := TStringList.Create;
  WB_GetHTMLCode(WebBrowser1, s);
  if pos(Hosts[CurrentIndex].Answer, s.Text) > 0 then
  begin
    ResultMemo.Lines.Add('Ответ от сервера>> It works!');
    Hosts[CurrentIndex].SetCorrect;
  end
  else if pos(Hosts[CurrentIndex].Answer, s.Text) > 0 then
  begin
    ResultMemo.Lines.Add('Ответ от сервера>> Apache Tomcat');
    Hosts[CurrentIndex].SetCorrect;
  end
  else
  begin
    ResultMemo.Lines.Add('Подключение не удалось.');
  end;
  ResultMemo.Lines.Add('');
  s.Free;
  CheckConnection;
end;

procedure TMainForm.ResultMemoChange(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to ResultMemo.Lines.Count - 1 do
    if pos('Ответ от сервера', ResultMemo.Lines[i]) > 0 then
    begin
      ResultMemo.CaretPos := Point(0, i);
      ResultMemo.SelLength := length(ResultMemo.Lines[i]);
      ResultMemo.SelAttributes.Color := clGreen;
      ResultMemo.SelLength := 0;
    end
    else if pos('Подключение не удалось', ResultMemo.Lines[i]) > 0 then
    begin
      ResultMemo.CaretPos := Point(0, i);
      ResultMemo.SelLength := length(ResultMemo.Lines[i]);
      ResultMemo.SelAttributes.Color := clRed;
      ResultMemo.SelLength := 0;
    end
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
begin
  if not DocComplete then
  begin
    ResultMemo.Lines.Add('Подключение не удалось');
    ResultMemo.Lines.Add('');
  end;
  Timer2.Enabled := false;
  CheckConnection;
end;

procedure TMainForm.BtnPropertiesClick(Sender: TObject);
begin
  Servers.CheckAll;
end;

procedure TMainForm.BtnChangeOptionsClick(Sender: TObject);
begin
  Servers.UncheckAll;
end;

procedure TMainForm.BtnHelpClick(Sender: TObject);
begin
  Application.CreateForm(TAboutForm, AboutForm);
  with AboutForm do
  begin
    Label1.Caption := Format(Label1.Caption,
      [GetFileVersion(Application.ExeName, n1, n2, n3, n4), n4]);
    Update;
    ShowModal;
    Free;
  end;
end;

procedure TMainForm.ServersClick(Sender: TObject);
begin
  BtnDeleteRecord.Enabled := Servers.ItemIndex >= 0;
  BtnEdit.Enabled := Servers.ItemIndex >= 0;
end;

function TConnectSettings.ToString: string;
begin
  result := csName + ';' + csHost + ';' + inttostr(csPort) + ';';
  if HasAlternate then
    Result := Result + csAltHost + ';' + inttostr(csAltPort) + ';'
  else
    Result := Result + ';;';
  if HasAlternate1 then
    Result := Result + csAltHost1 + ';' + inttostr(csAltPort1) + ';'
  else
    Result := Result + ';;';
  Result := Result + csAnswer + ';';
end;

procedure Timer1Timer1(Sender: TObject);
begin
  with MainForm do
  begin
    try
      Timer2.Enabled := false;
      repeat
        inc(CurrentIndex);
        if CurrentIndex >= Servers.Items.Count then
        begin
          Connection.Close;
          ResultMemoChange(ResultMemo);
          ResultMemo.WordWrap := true;
          Exit;
        end;
      until Servers.ItemChecked[CurrentIndex];
      Connection.Free;
      Connection := TClientSocket.Create(MainForm);
      Connection.Name := 'Connection';
      Connection.ClientType := ctNonBlocking;
      Connection.OnRead := ConnectionRead;
      Connection.OnError := ConnectionError;
      Connection.Active := false;
      //Update;
      if Hosts[CurrentIndex].Protocol <> 'HTTP' then
      begin
        {
        Connection.Socket.Close;
        Connection.Close;        }
        ResultMemo.Lines.Add('Подключение к серверу: ' +
          Hosts[CurrentIndex].Host
          +
          ' порт ' + inttostr(Hosts[CurrentIndex].Port) + '...');
        Hosts[CurrentIndex].SetSocketSettings(Connection);
        Connection.Active := true;
        //Connection.Open;
      end
      else if Hosts[CurrentIndex].Protocol = 'HTTP' then
      begin
        ResultMemo.Lines.Add('Подключение к серверу: ' +
          Hosts[CurrentIndex].Host
          +
          ' порт 80...');
        DocComplete := false;
        WebBrowser1.Navigate(Hosts[CurrentIndex].Host);
        Timer2.Enabled := true;
      end
    except
      on e: Exception do
      begin
        MessageDlg('Ошибка: ' + e.Message, mtError, [mbOk], 0);
      end;
    end;
  end;
end;

procedure TMainForm.ResultListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
  i, indent, vindent, whst: integer;
begin
  s := ResultList.Items[Index];
  i := strtoint(copy(s, 1, pos(';', s) - 1));
  delete(s, 1, pos(';', s));
  whst := StrToInt(s);
  if i >= length(Hosts) then
    Exit;
  if Hosts[i] = nil then
    Exit;
  with ResultList.Canvas do
  begin
    Brush.Color := $00EAEDEE;
    if odSelected in State then
      Brush.Color := clWhite;
    Pen.Color := clGrayText;
    Pen.Width := 2;
    FillRect(Rect);
    Font.Color := clBlack;
    MoveTo(Rect.Left + 1, Rect.Top + 1);
    LineTo(Rect.Right - 1, Rect.Top + 1);
    LineTo(Rect.Right - 1, Rect.Bottom);
    if Index = ResultList.Items.Count - 1 then
      LineTo(Rect.Left + 1, Rect.Bottom)
    else
      MoveTo(Rect.Left + 1, Rect.Bottom);
    LineTo(Rect.Left + 1, Rect.Top);
    with Hosts[i] do
    begin
      Font.Style := Font.Style + [fsBold];
      TextOut(Rect.Left + 2, Rect.Top + 2, Name);
      vindent := TextHeight(Name) + 4;
      if not IsCorrect then
      begin
        Font.Color := clRed;
        TextOut(Rect.Left + 10, Rect.Top + vindent, 'Подключение не удалось');
      end
      else
      begin
        Font.Color := clGreen;
        Font.Style := [];
        TextOut(Rect.Left + 10, Rect.Top + vindent,
          'Соединение прошло успешно');
        Font.Color := clBlack;
        Font.Style := [];
        inc(vindent, TextHeight('Соединение прошло успешно') + 4);
        case whst of
          0:
            begin
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Адрес: ');
              indent := TextWidth('Адрес: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent, Host);
              inc(vindent, TextHeight(Host) + 3);
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Порт: ');
              indent := TextWidth('Порт: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent,
                inttostr(Port))
            end;
          1:
            begin
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Адрес: ');
              indent := TextWidth('Адрес: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent,
                AlternateHost);
              inc(vindent, TextHeight(AlternateHost) + 3);
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Порт: ');
              indent := TextWidth('Порт: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent,
                inttostr(AlternatePort))
            end;
          2:
            begin
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Адрес: ');
              indent := TextWidth('Адрес: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent,
                AlternateHost1);
              inc(vindent, TextHeight(AlternateHost1) + 3);
              Font.Style := [];
              TextOut(Rect.Left + 10, Rect.Top + vindent, 'Порт: ');
              indent := TextWidth('Порт: ') + 2;
              Font.Style := Font.Style + [fsBold];
              TextOut(Rect.Left + 10 + indent, Rect.Top + vindent,
                inttostr(AlternatePort1))
            end;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if Pages.ActivePage = Result then
    ResultList.Repaint;
end;

end.
