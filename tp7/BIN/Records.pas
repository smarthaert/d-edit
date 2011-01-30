program Records;

(* 12. (�) ������� 䠩�, ᮤ�ঠ騩 ᢥ����� �� ��ࠢ����� �������
  ���쭥�� ᫥������� � ���᪮�� �������.
  ������� �����:
  - ����� ������,
  - �㭪� �����祭��,
  - �६� ��ࠢ�����,
  - �६� � ���,
  - ����稥 ����⮢;
  ������⢮ ����ᥩ:15.
*)
type
  TTrain = record
    TrainNumber: Integer; { ����� ������ }
    Destination: String; { �㭪� �����祭�� }
    Departure: Integer; { �६� ��ࠢ����� }
    Travel: Integer; { �६� � ��� }
    Tickets: Integer; { ����稥 ����⮢ (������⢮) }
  end;

const
  Cities: array [0..4] of string =
    ('����', '������', '����', '��⥡�', '�த��');
  FileName = 'trains.db'; { ���� ��� �࠭���� ���� ������ }

{ ��᫮ � ��ப� � ����������� ��������� �㫥� }
function IntToStr0( Number,Len:integer ):string;
var Result : string;
begin
  Str(Number,Result);
  if Length(Result) < Len then
    Result := '0' + Result;
  IntToStr0 := Result;
end;

{ �६� � ��ப� }
function TimeToStr( T:Integer ):string;
var DD,HH,MM : integer; { ���, ���, ������ }
begin
  MM := T mod 60;
  HH := (T div 60) mod 24;
  DD := T div (24*60);
  if DD > 0 then
    TimeToStr := IntToStr0(DD,1) + ' ���� ' + IntToStr0(HH,2) + ':' + IntToStr0(MM,2)
  else
    TimeToStr := IntToStr0(HH,2) + ':' + IntToStr0(MM,2)
end;

{ ������� �ਬ�� ��室��� ������ }
procedure GenerateSampleData;
var
  i: integer;
  F: file of TTrain; { ������஢���� 䠩� }
  Train: TTrain;
begin
  Assign(F, FileName);
  Rewrite(F);
  writeln('�ਬ�� �ᯨᠭ��:');
  Randomize;  
  for i := 1 to 15 do begin
    with Train do begin
      TrainNumber := Random(100) + 1;
      Destination := Cities[Random(High(Cities))];
      Departure := Random(24*60);
      Travel := 7 + Random(40*60);
      Tickets := Random(5);
      Writeln('�',TrainNumber,' �� ',Destination,
        ' ��ࠢ����� � ',TimeToStr(Departure),
        ' � ��� ',TimeToStr(Travel),
        ' ����⮢ ',Tickets);
    end;
    { �����뢠� ������ � 䠩� }
    Write(F, Train);
  end;
  Close(F);
  Writeln;
end;

(*
  (�) ������� �ணࠬ��, �뤠���� ᫥������ ���ଠ��:
  - �६� ��ࠢ����� ������� � ��த � �� �६����� ���ࢠ�� �� � �� � �ᮢ,
  - ����稥 ����⮢ �� ����� � ����஬ ���.
  ���祭�� �, �, �, ��� �������� � ���������� ०���.
*)
procedure Queries;
var
  Choice, i, XXX: integer;
  X: string;
  A, B: Integer;
  F: file of TTrain; { ������஢���� 䠩� }
  Train: TTrain;
begin
  repeat
    Writeln;
    Writeln('�롥�� ⨯ �����:');
    Writeln('1. �६� ��ࠢ����� ������� � ��த � �� �६����� ���ࢠ�� �� � �� � �ᮢ');
    Writeln('2. ����稥 ����⮢ �� ����� � ����஬ ���');
    Writeln('0. ��室 �� �ணࠬ��');
    Writeln;
    Write('��� �롮�: ');
    Readln(Choice);
    case Choice of
      1:
        begin
          Writeln('�६� ��ࠢ����� ������� � ��த � �� �६����� ���ࢠ�� �� � �� � �ᮢ');
          Write('��த�: ');
          for i := low(Cities) to high(Cities) do
            write(i,'. ',Cities[i], ' ');
          Writeln;
          Write('������ � ��த� �����祭��: ');
          Readln(i);
          X := Cities[i];
          Write('��稭�� � ᪮�쪨 �ᮢ: ');
          Readln(A);
          Write('�� ᪮�쪨 �ᮢ: ');
          Readln(B);
          Writeln('�६� ��ࠢ����� ������� � ��த "', X,
            '" �� �६����� ���ࢠ�� �� "', A, '" �� "', B, '" �ᮢ:');
          Assign(F, FileName);
          Reset(F);
          while not EOF(F) do
          begin
            Read(F, Train);
            with Train do
              if (Destination = X) and
                 (Departure >= (A*60)) and (Departure <= (B*60)) then
                Writeln(TimeToStr(Departure), ' �', TrainNumber, ' "', Destination,'"');
          end;
          Close(F);
        end;
      2:
        begin
          Writeln('����稥 ����⮢ �� ����� � ����஬ ���');
          Write('������ � ������: ');
          Readln(XXX);
          Assign(F, FileName);
          Reset(F);
          while not EOF(F) do begin
            Read(F, Train);
            with Train do
              if TrainNumber = XXX then
                Writeln('�� ����� �', TrainNumber, ' ����⮢: ', Tickets);
          end;
          Close(F);
        end;
    end;
  until Choice = 0;
end;

begin
  GenerateSampleData;
  Queries;
end.
