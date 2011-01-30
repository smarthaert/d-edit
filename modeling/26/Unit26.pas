unit Unit26;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    DatchM: TSpinEdit;
    DatchD: TSpinEdit;
    Label2: TLabel;
    MessageNumber: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ObrM: TSpinEdit;
    ObrD: TSpinEdit;
    ExpireTime: TSpinEdit;
    ModelingButton: TBitBtn;
    Log: TListBox;
    LostMessagesIn: TSpinEdit;
    LostMessagesBuf: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    FreeTime: TSpinEdit;
    BusyTime: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    CoefZagr: TLabel;
    procedure ModelingButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure OneSecond;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function Gen( Srednee, Razbros : integer ):integer;
begin
  Gen := Random(Razbros*2+1) + Srednee - Razbros;  // �������� ��������� �������� X � ��������� 0..1
end;

type // ���������� � ��������
  TMessage = class
    ID : Integer;
    Buffer_In : Integer; // ����� ����� ��������� �� ����� ������
    EVM_In : Integer; // ����� ����� ��������� �� ����� ���
    Done : Integer; // ����� ����� ��������� ����������
  end;

var
  NextMsgID : Integer = 1;
  NextMsgTime : Integer = 0;
  V : Integer = 0;
  Buf : TMessage; // �������� ������ �������� � 1 ���������
  EVM : TMessage; // ���

procedure TForm1.ModelingButtonClick(Sender: TObject);
begin
  V := 0;
  NextMsgID := 1;
  NextMsgTime := Gen(DatchM.Value,DatchD.Value);
  Log.Items.Clear;
  Log.Items.Add('������ ��������� ����� '+IntToStr(NextMsgTime));
  Buf := nil;
  EVM := nil;
  LostMessagesIn.Value := 0;
  LostMessagesBuf.Value := 0;
  FreeTime.Value := 0;
  BusyTime.Value := 0;
  while NextMsgID <= MessageNumber.Value do
    OneSecond;
  CoefZagr.Caption := '������ / ����� ����� = ' +
    IntToStr(Round((BusyTime.Value*100) / (BusyTime.Value + FreeTime.Value))) + '%';
end;

procedure TForm1.OneSecond;
var M : TMessage;
begin
  M := nil;
  Inc(V);
  Log.Items.Add('�������: '+IntToStr(V));
  // ���� ������ ����� => �������� ������ ���������
  if NextMsgTime = V then begin
    M := TMessage.Create;
    Log.Items.Add('������ ��������� #'+IntToStr(NextMsgID));
    M.ID := NextMsgID;
    // ���� ����� ����, �� ����� �������� ��������� � �����
    if Buf = nil then begin
      Log.Items.Add('����� ����, �������� #' + IntToStr(M.ID)+' � �����');
      Buf := M;
      Buf.Buffer_In := V; // ��������� ����� ��������� � �����
    end else begin
      // ����� ��������� ���������?
      Log.Items.Add('#' + IntToStr(M.ID)+' ������� �� ����� (� ������ #'+IntToStr(Buf.ID)+')');
      LostMessagesIn.Value := LostMessagesIn.Value + 1;
      M.Free;
      M := nil;
    end;
    // ����������� ������� ���������
    Inc(NextMsgID);
    // ��������� ��������� ����� �
    NextMsgTime := V + Gen(DatchM.Value,DatchD.Value);
  end;
  // ��������� 12 ������
  if Buf <> nil then
    if (Buf.Buffer_In + ExpireTime.Value) < V then begin
      Log.Items.Add('#' + IntToStr(Buf.ID)+' - ������� ����� � ������');
      LostMessagesBuf.Value := LostMessagesBuf.Value + 1;
      Buf := nil;
    end;
  // ���� � ������ ���� ��������� � ��� �����
  if (Buf <> nil) and (EVM = nil) then begin
    Log.Items.Add('������� ��������� �� ���');
    EVM := Buf; // �������� ������ �� ��������� �� ���
    Buf := nil; // ����� �������������
    EVM.EVM_In := V;
    EVM.Done := V + Gen(ObrM.Value,ObrD.Value);
  end;
  // ���� ���� ��������� �� ��������� � ������� ��� �����
  if EVM <> nil then
    if EVM.Done = V then begin
      Log.Items.Add('��������� ��������� #'+IntToStr(EVM.ID)+' �� ���');
      EVM.Free; // ���������� ������ ���������
      EVM := nil;
    end;
  if EVM = nil then begin
    FreeTime.Value := FreeTime.Value + 1;
  end else begin
    BusyTime.Value := BusyTime.Value + 1;
  end;
end;

end.
