Program Kurs1; {2_8. �ணࠬ��, ��।������ �� ᪮�쪮 ࠧ
�������襥 �� 3-� �ᥫ ����� �������襣�}
uses crt;

var a, b, c, rez: real;
    ok: boolean;

procedure SafeRead (var i: real; sch: byte);
    Var p: integer;
        ok: boolean;
    Begin
    ok:=false;
    {$I-}
    repeat
      writeln ('������ ', sch, ' �᫮ � ������ <Enter>');
      readln (i);
      P:= IOresult;
      if P<>0 then
          writeln ('�訡��: ������ �ଠ� �᫠. ������ ���� �᫠')
        else  {(�� �=0) ����� �᫮ ������� ��୮, �஢�ਬ ��� ��
               ᮢ������� � �㫥� ��� � ����� �� ࠭�� ��������� �ᥫ}
           begin
             case sch of
               1: ok:= (i<>0);
               2: ok:= (i<>a) and (i<>0);
               3: ok:= (i<>a) and (i<>b) and (i<>0)
             end;
           if (ok=false) then
             begin
               writeln ('�訡��: ��������� �᫮ ���� ࠢ�� ���, ���� ࠢ�� ������');
               writeln ('�� �।���� (�᫨ ⠪���� ���������). ������ ���� �᫠');
             end;
           end;
    until ok;
      {$I+}
    end;

Begin
repeat  {��横������ �� ����� �� ��室}
  clrscr;
     {���뢠�� �᫠ � �஢�ਬ, 㤮���⢮���� �� ��� �᫮���}
  writeln ('������ 3 �᫠, �⫨��騥�� ��� �� ��㣠 � �� ࠢ��� ���');
  SafeRead (a, 1);
  SafeRead (b, 2);
  SafeRead (c, 3);
    {***}
     {�᭮���� �ணࠬ��. �ࠢ��� �᫠}
  If ( a>b ) and ( a>c ) then  {a �������襥}
    if ( b<c ) then
      rez:= a/b    {�᫨ b ���� �� ��⠢����}
    else
      rez:= a/c
  else                  {�᫨ � ����}
    If ( b>a ) and ( b>c ) then  {b �������襥}
      if ( a<c ) then
        rez:= b/a
      else
       rez:= b/c
    else
      if ( c>a ) and ( c>b ) then  {c �������襥}
        if ( a<b ) then
          rez:= c/a
        else
          rez:= c/b;
  writeln ('�������襥 �᫮ ����� �������襣� � ', rez:2:1, ' ࠧ(a)');
  writeln('�������� �ணࠬ��? (Y/N)');
until readkey in ['y','Y','�','1','�'];
clrscr;
end.