program qq;

const { �������� ����� ������ }
  id_nomer = '����� ������';
  id_punkt = '�㭪� �����祭��';
  id_time_in = 'B६� ��ࠢ�����';
  id_time_out = 'B६� � ���';
  id_bilet = 'H���稥 ����⮢';

var zapis: integer;
  nomer, bilet: integer;
  punkt: string;
  time_in, time_out: real;
  f: text;

function ReadRecord : boolean;
var Code, p : integer;
  S, value, id : string;
begin
  readln(f,S);
  ReadRecord := S = '#';
  if S='#' then exit;
  { �⤥�塞 � �� �� ����� ":" - �������� ���� ������ }
  p := pos(':',S);
  id := copy(S,1,p-1);
  { � � �� ��᫥ ":" - ���祭�� }
  value := copy(S,p+1,length(S)-p);
  { ���ࠥ� ��砫�� � ���楢� �஡��� }
  if value <> '' then begin
    while value[1]=' ' do { ���� � ��砫� ��ப� �⮨� �஡�� }
      Delete(value,1,1); { 㤠�塞 ��稭�� � ��ࢮ�� ᨬ���� 1 ᨬ��� }
    while value[Length(value)] = ' ' do { ���� � ���� ��ப� ��ந� �஡�� }
      Delete(value,Length(value),1); { 㤠�塞 ��� }
  end;
  if id = id_nomer then Val(value,nomer,Code);
  if id = id_punkt then punkt := value;
  if id = id_time_in then val(value,time_in,Code);
  if id = id_time_out then val(value,time_out,Code);
  if id = id_bilet then val(value,bilet,Code);
end;

var X : string;
  A,B : real;
  XXX : integer;
begin
  { ������ ࠯�ᠭ�� � ⥪�⮢�� 䠩�� }
  { ���뢠�� ��� �� ������ }
  assign(f, 'poizd.txt'); { f - 䠩����� ��६����� }
  rewrite(f); { ��१����뢠�� ��� ⥪�⮢� 䠩� }
    { �᫨ 䠩�� ���, � �� �㤥� ᮧ���, � ���� ��१���ᠭ ������ }
  writeln('��砫� ����� ����ᥩ');
  writeln;
  writeln;
  zapis := 1;
  while zapis <= 15 do begin
    writeln('������ ', zapis);
    write('������ ����� ������: '); readln(nomer);
    writeln(f, id_nomer,': ', nomer);
    write('������ �㭪� �����祭��: '); readln(punkt);
    writeln(f, id_punkt,': ', punkt);
    write('������ �६� ��ࠢ�����: '); readln(time_in);
    writeln(f, id_time_in,': ', time_in);
    write('������ �६� � ���: '); readln(time_out);
    writeln(f, id_time_out,': ', time_out);
    write('������ ����稥 ����⮢: '); readln(bilet);
    writeln(f, id_bilet,': ', bilet);
    writeln(f,'#');
    writeln;
    zapis := zapis + 1;
  end;
  writeln('����� ����ᥩ!');
  close(f);
  writeln;
  { ���� ���� ����� - ᮡ�⢥��� ���� :) }
  writeln('=== ���� ����ᥩ ===');
  writeln;
  writeln('1. �६� ��ࠢ����� ������� � ��த � �� �६�����');
  writeln('���ࢠ�� �� � �� � �ᮢ');
  writeln;
  write('������ �ॡ㥬� �㭪� �����祭��: '); readln(X);
  write('������ ��砫� ���ࢠ��: '); readln(A);
  write('������ ����� ���ࢠ��: '); readln(B);
  reset(f); { ���뢠�� 䠩� ᭮�� �� ���뢠��� }
  while not EOF(f) do begin { ���� 䠩� f �� �����稫��, ���뢠�� }
    if ReadRecord then
      if (punkt = X) and (time_in >= A) and (time_in <= B) then
        writeln(nomer,' ',punkt,' ',time_in);
  end;
  close(f); { ����뢠�� 䠩� }
  writeln;
  writeln('2. ����稥 ����⮢ �� ����� � ����஬ ���.');
  write('������ �ॡ㥬� ����� ������: '); readln(XXX);
  reset(f); { ���뢠�� 䠩� ᭮�� �� ���뢠��� }
  while not EOF(f) do begin { ���� 䠩� f �� �����稫��, ���뢠�� }
    if ReadRecord then
      if nomer = XXX then
        writeln(nomer,' ',punkt,' ',time_in);
  end;
  close(f); { ����뢠�� 䠩� }
  write('Enter'); readln;
end.