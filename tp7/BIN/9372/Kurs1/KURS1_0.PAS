Program Kurs1; {2_8. �ணࠬ��, ��।������ �� ᪮�쪮 ࠧ
�������襥 �� 3-� �ᥫ ����� �������襣�}
uses crt;

var a, b, c, rez: real;
    ok: boolean;

Begin
clrscr;
ok:= false;
   {���뢠�� �᫠}
repeat
  writeln ('������ 3 �᫠, �⫨��騥�� ��� �� ��㣠 � �� ࠢ��� ���');
  readln (a,b,c);
  if ( a<>b ) and ( b<>c ) and ( a<>c ) and ( a<>0 ) and ( b<>0 ) and ( c<>0 ) then ok:= true
  else
    Begin
    clrscr;
    writeln ('�� ����� �����४�� �᫠, ������ ����');
  end;
until ok;
   {***}
   {�᭮���� �ணࠬ��. �ࠢ��� �᫠}
If ( a>b ) and ( a>c ) then  {a �������襥}
  if ( b<c ) then rez:= a/b    {�᫨ b ���� �� ��⠢����}
  else rez:= a/c;              {�᫨ � ����}
If ( b>a ) and ( b>c ) then  {b �������襥}
  if ( a<c ) then rez:= b/a
  else rez:= b/c;
if ( c>a ) and ( c>b ) then  {c �������襥}
  if ( a<b ) then rez:= c/a
  else rez:= c/b;
writeln ('�������襥 �᫮ ����� �������襣� � ', rez:2:1, ' ࠧ(a)');
readln;
clrscr;
end.