unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function Gen( Srednee, Razbros : integer ):integer;
begin
  Gen := Random(Razbros*2+1) + Srednee - Razbros;  // �������� ��������� �������� X � ��������� 0..1
end;

{
  ������� 22.
  ��� ����������� ���������� ��� �� � ��� ������������ ��� ���.
  ������ ��� ��������� ��������� ������ � ��������������� �������� � ���������
  ����������� ��������, � ������ ��������� � �������� �������.
  ������ � ��� ��������� ����� 10 � 2 �, �������������� � ������� 3 �,
  ����� ���������� ����������� ������, �������������� �������� ���� ��������.
  ���� � ������� ������� ���������� ������ ������ �� ������� ����������� ������,
  �� ������������� ���������� ���������������� �������� ����������� �����,
  � ������ ���������� ��� 20 � 4 �.
  �������� ��� ������ 30 � �������� ��������� ��� ������ � �����������������.
  ���������� ������� �������� ������������� ��������� ��������� ��� ������
  ��������. �������������� ����� ��� ���������.
  ����������� ��������� ��� �������� 5 �,
  ����� ���� ��� �������� �������� �� ��������������,
  � ������� ������������ � ����������� �����.
  ������ ��� ���������� ����� 300 � 30 �.
  �������������� �������� 100 �. ��������� ��� ��������� �������.
  ������������� 1 � ������ �������.
  ���������� ������� ����� ���������� ���������������� ��������
  � ������������� ���������� � ������� ����� ����������� ��-�� ������� ������.
}
procedure TForm1.Button1Click(Sender: TObject);
var
  zd,dzd,od,sr,pre,ve,oe,doe: Integer;
  st,so: Integer;
  i,n,r,v,o: Integer;
  fsu,fsr,fv: Boolean;
begin
  randomize();
  // ������ � ��� ��������� ����� 10 � 2 �
  zd:=10;
  dzd:=2;
  // �������������� � ������� 3 �
  od:=3;
  // �������� ��� ������ 30 � �������� ��������� ��� ������ � �����������������
  sr:=30;
  pre:=5;
  ve:=100;
  oe:=300;
  doe:=30;

  fsr:=True;

  st:=0;
  so:=0;
  n:=Random(2*dzd+1)+(zd-dzd);
  r:=n;
  v:=1;
  fv:=False;
  o:=Random(2*doe+1)+(oe-doe);
  i:=0;
  while i<3600 do
  begin
    i:=i+1;
    fsu := random(2) <> 0;
    if i=o then
    begin
      fsr:=False;
      o:=i+Random(2*doe+1)+(oe-doe);
    end;
    if (i/sr = Int(i/sr)) and (not fv) then
    begin
      if not fsr then
      begin
        i:=i+pre;
        if i>=r then
        begin
          so:=so+1;
          n:=Random(2*dzd+1)+(zd-dzd);
          r:=i+n;
        end;
        fv:=True;
        fsr:=True;
      end;
    end;
    if fv then
    begin
      if v>=ve then
      begin
        v:=1;
        fv:=False;
      end
      else
        v:=v+1;
    end;
    if i=r then
    begin
      if not fsu then
      begin
        if n=0 then
        begin
          st:=st+1;
          n:=Random(2*dzd+1)+(zd-dzd);
          r:=i+n;
        end
        else
        begin
          r:=i+n;
          n:=0;
        end;
      end
      else
      begin
        i:=i+od;
        n:=Random(2*dzd+1)+(zd-dzd);
        r:=i+n;
      end;
    end;
  end;
  Label1.Caption:='���������� ���������� ������� ������:'+#13#10+'��-�� �������� - '+
    IntToStr(st)+#13#10+'��-�� ������� - '+IntToStr(so);
end;

end.
