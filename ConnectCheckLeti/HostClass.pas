unit HostClass;

interface

uses
  SysUtils, Classes, ScktComp, SHDocVw;

type
  TCorrectConnection = array[0..2] of boolean;

  {Класс для хранения параметров подключения к узлу.}
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

var
  Hosts: array of TConnectSettings;
  CurrentIndex: integer;
  DocComplete: boolean = false;
  n1, n2, n3, n4: integer;

implementation

{ TConnectSettings }

{Создание пустого экземпляра класса}
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

{Конструкторы различаются набором параметров -
неуказанные параметры остаются пустыми}

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

constructor TConnectSettings.Create(hname, hst: string; prt: integer;
  ha: boolean; ahost: string; aport: integer; ha1: boolean; ahost1: string;
  aport1: integer; ans, prot: string);
begin
  Create(hname, hst, prt, ha, ahost, aport, ha1, ahost1, aport1, prot);
  csAnswer := ans;
end;

{Конструктор, получающий значения полей экземпляра в результате
парсинга строки}
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

{Возвращает истину, если хотя бы с одним набором параметров
соединение прошло успешно}
function TConnectSettings.csIsCorrect: boolean;
begin
  Result := csCorrect[0] or csCorrect[1] or csCorrect[2];
end;

{Возвращает порядковый номер набора параметров,
с которым соединение прошло успешно}
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

{Возвращает истину, если выбранный набор параметров (csWork) не пустой}
function TConnectSettings.HasHost: boolean;
begin
  Result := false;
  case csWork of
    0: Result := csHost <> '';
    1: Result := csHasAlt;
    2: Result := csHasAlt1;
  end;
end;

{Для выбранного набра параметров (csWork) соединение прошло успешно}
procedure TConnectSettings.SetCorrect;
begin
  csCorrect[csWork] := true;
end;

{Для компонента sckt устанавливаются параметры из данных в этом экземпляре}
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

{Возвращает данные экземпляра в виде строки}
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

end.

