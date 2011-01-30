unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TF = class(TForm)
    LeftUpB: TBevel;
    LeftDownB: TBevel;
    LeftB: TBevel;
    CenterB: TBevel;
    RigthB: TBevel;
    RightUB: TBevel;
    RigthDB: TBevel;
    RigthBtn: TBitBtn;
    LeftBtn: TBitBtn;
    Label1: TLabel;
    Queue: TLabel;
    Direction: TLabel;
    Count: TLabel;
    procedure LeftBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RigthBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F: TF;

{ ����������� ������ TTrain }
type
  TKind = (_Left,_Right);
  TTrain = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    Kind : TKind;
    Image : TLabel;
    myNum : Integer;
    constructor Create( K:TKind );  // ����� ���� ����������� Create
  end;

var Trains : TList;

type
  TCenter = object
   private
    Count : Integer;
    State : (cLeft,cRight,cEmpty);
    procedure goRight;
    procedure goLeft;
   public
    function canLeft : boolean;
    function canRight : boolean;
    procedure Leave;
  end;

var Center : TCenter;

implementation

{$R *.dfm}

constructor TTrain.Create( K:TKind );
begin
  inherited Create(true); // ���������, ��������� ���� ��������� ���������� ������
  FreeOnTerminate := True; // ����� ���������� ���������� ������ Execute ��������� ������ ������
  Kind := K;
  Priority := tpLowest;
  Image := TLabel.Create(F);
  Case Kind of
    _Left: begin
      Image.Caption := 'L';
      Image.Top := F.LeftUpB.Top;
      Image.Left := F.LeftUpB.Left;
    end;
    _Right: begin
      Image.Caption := 'R';
      Image.Top := F.RightUB.Top;
      Image.Left := F.RightUB.Left+F.RightUB.Width-F.RightUB.Height;
    end;
  end;
  F.Queue.Caption := F.Queue.Caption + Image.Caption;
  F.InsertControl(Image);
end;

Const Delay = 10;

procedure TTrain.Execute;
var x,y:Integer;
begin
  { ����� ����� ��� ��������� �� ������, ������� ������ ���� ��������� ��������� }
  Case Kind of
    _Left: begin { ���� ����� "�����" }
      for x:=F.LeftUpB.Left to F.LeftUpB.Left+F.LeftUpB.Width-F.LeftUpB.Height do begin
        Image.Left:=x;
        Synchronize(F.LeftUpB.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for y:=F.LeftUpB.Top to F.CenterB.Top-F.CenterB.Height do begin
        Image.Top:=y;
        Synchronize(F.CenterB.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      { ����������� ������� }
      while not Center.canLeft do Sleep(5);
      for y:=F.CenterB.Top-F.CenterB.Height to F.CenterB.Top do begin
        Image.Top:=y;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for x:=F.CenterB.Left to F.CenterB.Left+F.CenterB.Width do begin
        Image.Left:=x;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      Center.Leave;
      {}
      for y:=F.CenterB.Top to F.RigthDB.Top do begin
        Image.Top:=y;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for x:=F.RigthDB.Left to F.RigthDB.Left+F.RigthDB.Width-F.RigthDB.Height do begin
        Image.Left:=x;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
    end;
    _Right: begin { ���� ����� "������" }
      for x:=F.RigthDB.Left+F.RigthDB.Width-F.RigthDB.Height downto F.RigthDB.Left do begin
        Image.Left:=x;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for y:=F.RightUB.Top to F.CenterB.Top-F.CenterB.Height do begin
        Image.Top:=y;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      { ����������� ������� }
      while not Center.canRight do Sleep(5);
      for y:=F.CenterB.Top-F.CenterB.Height to F.CenterB.Top do begin
        Image.Top:=y;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for x:=F.CenterB.Left+F.CenterB.Width downto F.CenterB.Left do begin
        Image.Left:=x;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      Center.Leave;
      {}
      for y:=F.CenterB.Top to F.LeftDownB.Top do begin
        Image.Top:=y;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
      for x:=F.LeftUpB.Left+F.LeftUpB.Width-F.LeftUpB.Height downto F.LeftDownB.Left do begin
        Image.Left:=x;
        Synchronize(F.Refresh);
        if Terminated then exit;
        Sleep(Delay);
      end;
    end;
  end;
  Image.Hide;
  Terminate;
end;

procedure TF.LeftBtnClick(Sender: TObject);
var T : TTrain;
begin
  {������� � ����� ��������� �������}
  T := TTrain.Create(_Left);
  T.myNum := Trains.Add(T);
  T.Resume;
end;

procedure TF.FormCreate(Sender: TObject);
begin
  Trains := TList.Create;
  Trains.Clear;
  Center.State := cEmpty;
end;

procedure TF.RigthBtnClick(Sender: TObject);
var T : TTrain;
begin
  {������� � ����� ��������� �������}
  T := TTrain.Create(_Right);
  Trains.Add(T);
  T.Resume;
end;

procedure TF.FormClose(Sender: TObject; var Action: TCloseAction);
var i : Integer;
begin
  Application.ProcessMessages;
  for i:=0 to Trains.Count-1 do
    if TTrain(Trains.Items[i])<>nil then
      TTrain(Trains.Items[i]).Terminate; // ������ ������� �� ����������
  for i:=0 to Trains.Count-1 do
    if TTrain(Trains.Items[i])<>nil then
      TTrain(Trains.Items[i]).WaitFor; // ������� ����������
end;

(*procedure TTrain.DoTerminate;
begin
  inherited;
  Trains.Delete(myNum);
end; *)

{ Center }

function TCenter.canLeft: boolean;
var S : String;
begin
  S := F.Queue.Caption;
  Result := (State<>cRight) and (S[1]='L');
  if Result then goLeft;
end;

function TCenter.canRight: boolean;
var S : String;
begin
  S := F.Queue.Caption;
  Result := (State<>cLeft) and (S[1]='R');
  if Result then goRight;
end;

procedure TCenter.goLeft;
var S : String;
begin
  State := cLeft;
  inc(Count);
  { ������� ����� �� ������� }
  S:=F.Queue.Caption;
  Delete(S,1,1);
  F.Queue.Caption:=S;
  {}
  F.Direction.Caption := 'Left';
  F.Count.Caption := IntToStr(Count);
end;

procedure TCenter.goRight;
var S : String;
begin
  State := cRight;
  inc(Count);
  { ������� ����� �� ������� }
  S:=F.Queue.Caption;
  Delete(S,1,1);
  F.Queue.Caption:=S;
  {}
  F.Direction.Caption := 'Right';
  F.Count.Caption := IntToStr(Count);
end;

procedure TCenter.Leave;
begin
  if Count = 0 then ShowMessage('BUG!!! Center.Leave');
  dec(Count);
  F.Count.Caption := IntToStr(Count);
  if Count=0 then begin
    F.Direction.Caption := 'Empty';
    State := cEmpty;
  end;
end;

procedure TF.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Case Key of
    'l','L','�','�': LeftBtnClick(Sender);
    'r','R','�','�': RigthBtnClick(Sender);
  end;
end;

end.
