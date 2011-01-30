unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Log: TListBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Math;

{$R *.dfm}

function Gen( Srednee, Razbros : integer ):integer;
begin
  Gen := Random(Razbros*2+1) + Srednee - Razbros;  // �������� ��������� �������� X � ��������� 0..1
end;

type
  Zad = class // ������ �� ����� �������
    No : Integer; // ����� ������
    // ��������� �������
    Sost : (Nachalnoe,PunktPriema,NaPervoiObrabotke,Zavershena,VOcherediNaKorrect,Kerrectiruetsa);
    PostPunktPriema : integer; // ����� ����������� � ����� ����� (��� �� ����� ������������� ���������)
    ZaverPunktPriema : integer; // ��������� ��������� � ������ �����
    PostNaEVM : integer; // ����� ����������� �� ���� �� ��������� ���
    noEVM : integer; // �� ����� ������ ��� ������� ���������
    OshVvoda : boolean; // ���������� �� ������ ����� ��� ������ ����������� �� ���
    PolzNaIspravlenie : integer; // �����, ����� ������� ������������ ������������ �� �����������
    PostNaEVNPovtorno : integer; // ����� ����������� �� ��� ��������
    ZaverZadachi : integer; // ����� ���������� ������
  end;
  EVM = record // ������ ���������� ������ �� ����� ���
    Zadacha : Zad; // ������ �� ���� ���
    SvobodnoeVremya, ZanatoyeVremya : integer; // ��������� ����� � ������� �����
  end;

procedure TForm1.Button1Click(Sender: TObject);
var
  E : array [1..3] of EVM; // 3 ���
  Z : array [1..100+1] of Zad; // 100 �������
  V : integer; // ������� �����
  i,j : integer; // ��������������� ���������� ������
  MestoKorrectSvobodno : boolean; // �������� �� ����� ��� �������������
  sum : integer; // ��������� ����� �������� ����� �������� � ������� �� ���
  S : string;

// ���������� ����������� �����
function ZaversennihZadach : integer;
var i:integer;
begin
  Result := 0;
  for i:=1 to 100 do
    if (Z[i].Sost = Zavershena) and (Z[i].ZaverZadachi <= V) then
      Inc( Result );
end;

function EVM_Sost( q : integer ):string;
begin
  if E[q].Zadacha = nil then
    Result := '   ���'+IntToStr(q)+' ��.'
  else
    Result := '   ���'+IntToStr(q)+' ������ ���. '+IntToStr(E[q].Zadacha.No);
end;

begin
  // ������������� ������� ������������� � ��������� ���������
  randomize(); // �������������� ��������� ��������� ����� �� �������, ����� ������ ������ �������� ������ ����������
  v := 0; // ����� ����� 0
  for i:=1 to 100 do begin
    Z[i] := Zad.Create;
    Z[i].No := i;
    Z[i].Sost := Nachalnoe;
    // ��������� ������ ������ ��������� ��� ����� 20+-5 �����
    v := v + Gen( 20, 5 );
    Z[i].PostPunktPriema := V;
  end;
  v := 0;

  for i:=1 to 3 do
    with E[i] do begin
      Zadacha := nil;
      SvobodnoeVremya := 0;
      ZanatoyeVremya := 0;
    end;
  MestoKorrectSvobodno := true;

  // ����� ���� �������������, ���� �� ���������� 100 �����
  // �� ������ ���� ����� ����� �� ����� ������������ v-�� ������ ������ �������
  while ZaversennihZadach < 100 do begin
    Log.Items.Add('������� '+IntToStr(V)+'  '+EVM_Sost(1)+' '+EVM_Sost(2)+' '+
      EVM_Sost(3));
    // ��������� ��� 3 ���
    for j:=1 to 3 do
      with E[j] do
        // ���� ��� ��������
        if Zadacha = nil then
          Inc( SvobodnoeVremya ) // ����� ����������� ��������� �����
        else
          inc( ZanatoyeVremya ); // ����� ����������� ������� �����

    for i:=1 to 100 do begin
      // ��������, ��� � ��� �� ������
//      case Z[i].Sost of

  //    end;
      // ���� � ������ ��������� ��������� � ������ ����� ���������� � ����� �����
      if (Z[i].Sost = Nachalnoe) and (Z[i].PostPunktPriema = v) then begin
        // ��� ������ ������ � ������ �����
        Z[i].Sost := PunktPriema;
        // � ����� 12+-3 ����� ����� ���������
        Z[i].ZaverPunktPriema := V + Gen(12,3);
        Log.Items.Add('������ '+IntToStr(i)+
          ' �������� � ��������� � ����� ����� �� '+IntToStr(Z[i].ZaverPunktPriema));
      end;
      // ���� ������ ���� � ������ �����, � ��� �� ��� ����� ������� � ��������� �� ���
      if (Z[i].Sost = PunktPriema) and (Z[i].ZaverPunktPriema = v) then begin
        // ���� ������ ��������� ���
        for j:=1 to 3 do
          if E[j].Zadacha = nil then begin
            // �������� ���
            Log.Items.Add('������ '+IntToStr(i)+' �� ��� '+IntToStr(j) + ' �� ������ ���������');
            Z[i].Sost := NaPervoiObrabotke;
            Z[i].PostNaEVM := V; // ���������� ����� ����������� �� ���
            Z[i].noEVM := j; // ����������, ����� ��� ��������� ������ ������
            Z[i].OshVvoda := Random(100) < 70; // ������ ����� � 70% �������
            // ���� ������ ����� ����
            if Z[i].OshVvoda then begin
              Log.Items.Add('������ ����� � ������ '+IntToStr(i)+'. ��������� ����������� ����������');
              // ��������� ����������� ������ ����������
              Z[i].Sost := VOcherediNaKorrect;
            end else begin
              // ��������� ���������� ������
              Z[i].ZaverZadachi := V + Gen(10,5); // 10+-5 ����� �� ����������
              Log.Items.Add('������ '+IntToStr(i)+' ����� ��������� '+IntToStr(Z[i].ZaverZadachi));
              Z[i].Sost := Zavershena;
            end;
            E[j].Zadacha := Z[i];
            break; // �����������, ����� �� ������ ����� ����� ������� ��� ��������� ���
          end;
      end;
      // ���� ������ ������ �����������, �� ��� ����������� ���
      if (Z[i].Sost = Zavershena) and (Z[i].ZaverZadachi = V) then begin
        E[Z[i].noEVM].Zadacha := nil;
        Log.Items.Add('������ '+IntToStr(i)+' ���������!');
      end;
      // ���� ������ � ������� �� ������������� �������� ������
      if (Z[i].Sost = VOcherediNaKorrect) and MestoKorrectSvobodno then begin
        // �� �������� ����� ������� ����� �������������
        MestoKorrectSvobodno := false;
        // �������� ������ ��������������
        Z[i].Sost := Kerrectiruetsa;
        // ���������� ����� ����� ��������� �� �����������
        Z[i].PolzNaIspravlenie := V;
        // ������ �������� �� ��� �������� ����� 3+-2 ������
        Z[i].PostNaEVNPovtorno := V + Gen(3,2);
      end;
      // ���� ������ �������������� � ����� ������������� �����������
      if (Z[i].Sost = Kerrectiruetsa) and (Z[i].PostNaEVNPovtorno = V) then begin
        // ����������� ����� ������������� ��� ������ �����
        MestoKorrectSvobodno := true;
        // ���������� ������ �� �� �� ��� �������
        // �� ��� ����� ������� ������ ��� ������ i �� ����������� ���
        Z[i].ZaverZadachi := V + Gen(10,5); // ���������� ������ ��������� ����� 10+-5 �����
        Z[i].Sost := Zavershena;
      end;
    end;
    // ����������� �����,
    v := v + 1;
  end;

  // ���������� ������� �� ������������ �������
  // ������� ����� �������� � �������
  sum := 0;
  for i:=1 to 100 do
    sum := sum + Z[i].PostNaEVM - Z[i].PostPunktPriema;

  S := '';  
  for j:=1 to 3 do
    S := S + #13#10 + '��� ' + IntToStr(j) + ' �������� ' +
      IntToStr(E[j].SvobodnoeVremya) + ' ���. �� ' +
      IntToStr(E[j].SvobodnoeVremya + E[j].ZanatoyeVremya);

  Label1.Caption:='������� ����� �������� � �������:'+#13#10+
    FloatToStr(sum / 100) + ' ' + S;
end;

end.
