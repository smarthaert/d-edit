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
  Gen := Random(Razbros*2+1) + Srednee - Razbros;  // Получаем случайную величину X в диапазоне 0..1
end;

type // Информация с датчиков
  TMessage = class
    ID : Integer;
    Buffer_In : Integer; // Время когда сообщение на входе буфера
    EVM_In : Integer; // Время когда сообщение на входе ЭВМ
    Done : Integer; // Время когда сообщение обработано
  end;

var
  NextMsgID : Integer = 1;
  NextMsgTime : Integer = 0;
  V : Integer = 0;
  Buf : TMessage; // Буферная память емкостью в 1 сообщение
  EVM : TMessage; // ЭВМ

procedure TForm1.ModelingButtonClick(Sender: TObject);
begin
  V := 0;
  NextMsgID := 1;
  NextMsgTime := Gen(DatchM.Value,DatchD.Value);
  Log.Items.Clear;
  Log.Items.Add('Первое сообщение будет '+IntToStr(NextMsgTime));
  Buf := nil;
  EVM := nil;
  LostMessagesIn.Value := 0;
  LostMessagesBuf.Value := 0;
  FreeTime.Value := 0;
  BusyTime.Value := 0;
  while NextMsgID <= MessageNumber.Value do
    OneSecond;
  CoefZagr.Caption := 'Работа / Общее время = ' +
    IntToStr(Round((BusyTime.Value*100) / (BusyTime.Value + FreeTime.Value))) + '%';
end;

procedure TForm1.OneSecond;
var M : TMessage;
begin
  M := nil;
  Inc(V);
  Log.Items.Add('Секунда: '+IntToStr(V));
  // Если пришло время => Создание нового сообщения
  if NextMsgTime = V then begin
    M := TMessage.Create;
    Log.Items.Add('Создаём сообщение #'+IntToStr(NextMsgID));
    M.ID := NextMsgID;
    // Если буфер пуст, то сразу помещаем сообщение в буфер
    if Buf = nil then begin
      Log.Items.Add('Буфер пуст, помещаем #' + IntToStr(M.ID)+' в буфер');
      Buf := M;
      Buf.Buffer_In := V; // Фиксируем время помещения в буфер
    end else begin
      // Иначе сообщение пропадает?
      Log.Items.Add('#' + IntToStr(M.ID)+' пропало на входе (в буфере #'+IntToStr(Buf.ID)+')');
      LostMessagesIn.Value := LostMessagesIn.Value + 1;
      M.Free;
      M := nil;
    end;
    // Увеличиваем счётчик сообщений
    Inc(NextMsgID);
    // Следующее сообщение будет в
    NextMsgTime := V + Gen(DatchM.Value,DatchD.Value);
  end;
  // Истечение 12 секунд
  if Buf <> nil then
    if (Buf.Buffer_In + ExpireTime.Value) < V then begin
      Log.Items.Add('#' + IntToStr(Buf.ID)+' - истекло время в буфере');
      LostMessagesBuf.Value := LostMessagesBuf.Value + 1;
      Buf := nil;
    end;
  // Если в буфере есть сообщение и ЭВМ пуста
  if (Buf <> nil) and (EVM = nil) then begin
    Log.Items.Add('Передаём сообщение на ЭВМ');
    EVM := Buf; // Копируем ссылку на сообщение на ЭВМ
    Buf := nil; // Буфер освобождается
    EVM.EVM_In := V;
    EVM.Done := V + Gen(ObrM.Value,ObrD.Value);
  end;
  // Если есть сообщение на обработке и настало его время
  if EVM <> nil then
    if EVM.Done = V then begin
      Log.Items.Add('Завершена обработка #'+IntToStr(EVM.ID)+' на ЭВМ');
      EVM.Free; // Особождаем память сообщения
      EVM := nil;
    end;
  if EVM = nil then begin
    FreeTime.Value := FreeTime.Value + 1;
  end else begin
    BusyTime.Value := BusyTime.Value + 1;
  end;
end;

end.
