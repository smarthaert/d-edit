{ �ணࠬ�� "�ਭ���������� �������� ������" }
const
  MaxK = 10; { ���ᨬ��쭮� ������⢮ ���祭�� K }
  MaxM = 20; { ���ᨬ��쭮� ������⢮ �祪 }

type
  Point = record { ��窠 }
    X,Y : real; { ���न���� �窨 �� ���᪮�� }
  end;

{ ���� �᫠ � �������� ��������� }
{ Prompt - �ਣ��襭�� � ����� }
{ ��᫮ ������ ���� � �।���� min..max }
function InputNum( Prompt:string; min,max : integer ):integer;
var Answer : integer; { �⢥� ���짮��⥫� }
begin
  Repeat
    Write(Prompt); readln(Answer);
  Until (Answer >= min) and (Answer <= max);
  InputNum := Answer;
end;

{ �஢�ઠ, �� �窠 �������� � ������� D }
{  P - �窠 ��� �஢�ન }
{  K - ⥪�饥 ���祭�� �����樥�� K }
function in_D( P:Point; K:real ):boolean;
begin
  if P.X <= 1 then begin
    in_D := false; exit;
  end;
  in_D := (P.Y >= K * exp(P.X)) and
          (P.Y >= sqrt(1.15*P.X)) and
          (P.Y <= P.X*P.X - P.X + 1);
end;

var
  N : integer; { ������⢮ �祪 }
  P : array [1..MaxM] of Point; { ���ᨢ �祪 }
  i, j : integer;
  flag : boolean;
  K_begin : real; { ��砫쭮� ���祭�� �����樥�� K }
  K_end : real; { ����筮� ���祭�� �����樥�� K }
  delta_K : real; { ��� ��������� �����樥�� K }
  K : array [1..MaxK] of Real; { ���祭�� �����樥�� K }
  KN : integer; { ������⢮ �����樥�⮢ K }
  Menu : integer; { ���ᮡ ������� �����樥�� K }
begin
  writeln(' �ਭ���������� �������� ������ ');
  writeln('=======================================');
  writeln(' ������ �ࠢ����� 3-� �ਢ�� �� ���᪮��.');
  writeln('���� �� �ࠢ����� ᮤ�ন� ��६���� �����樥�� K.');
  writeln('�ਢ� ���ᥪ���� ��࠭�稢��� ��������� ������� D,');
  writeln('ࠧ���� ���ன ������� �� ���祭�� ����-� K.');
  writeln('�롥�� ᯮᮡ ������� �����樥�� K');
  writeln('  1) ������ ��砫쭮� ���祭�� �_���, ����筮� ���祭�� �_��� � 蠣 ��������� �.');
  writeln('  2) ������ �_���, �_��� � ����� �� KN<=10 �ந������� ���祭�� �����樥�� �_��� <= � <= �_���.');
  Menu := InputNum('�롥�� 1 ��� 2: ',1,2);
  repeat
    Write('������ K_���: '); readln(K_begin);
    Write('������ K_���: '); readln(K_end);
    if K_end <= K_begin then
      Writeln('K_��� ������ ���� ����� K_���!');
  Until K_end > K_begin;
  { ������塞 ���ᨢ K � ����ᨬ��� �� ��࠭���� ᯮᮡ� }
  Case Menu of
    1: begin
      repeat
        write('������ 蠣 ��������� K>0: '); readln(delta_K);
      until delta_K > 0;
      { ����塞 ���祭�� K }
      K[1] := K_begin; { � ����⢥ ��ࢮ�� ���祭�� ���� K_��� }
      KN := MaxK;
      for i:=2 to MaxK do begin
        K[i] := K[i-1] + delta_K; { ��������� �� 蠣� }
        if K[i] >= K_end then begin { ���� �� ����� �� K_��� }
          KN := I; { �᫨ ��諨 => ���뢠���� }
          break;
        end;
      end;
    end;
   2: begin;
      KN := InputNum('������ ������⢮ KN: ',1,MaxK);
      for i:=1 to KN do begin
        repeat
          write('������ K',i,' � �।���� [',K_begin:0:2,'..',K_end,']: '); readln(K[i]);
        until (K[i] >= K_begin) and (K[i] <= K_end);
      end;
    end;
  end;
  writeln;
  writeln('���� ������⢠ M �祪');
  write('������⢮ �祪 N: '); readln(N);
  for i:=1 to N do begin
    writeln('���� �窨 ',i,' �� ',N);
    write('X = '); readln(P[i].X);
    write('Y = '); readln(P[i].Y);
    { �஡����� �� �ᥬ ���祭�� �����樥�� K }
    flag := false;
    for j:=1 to KN do
      if in_D(P[i],K[j]) then begin
        writeln('��窠 �������� � ������� D �� K=',K[j]:0:2);
        flag := true;
      end;
    if not flag then
      writeln('��窠 �� �������� � ������� D �� �� ����� ���祭��� K!');
  end;
  writeln;
  writeln('������ Enter ��� �����襭�� �ணࠬ��');
  readln;
end.
