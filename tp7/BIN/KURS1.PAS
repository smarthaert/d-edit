Program Kurs1; {������� 1 (116); ��ࢠ� ���� ���ᮢ�� ࠡ���}

uses crt;

Var x, y: real;

Const a=3;

procedure read_int (prompt: string; var i: integer; i_min, i_max: integer);
          {i_max, i_min - �ਭ���������� �᫠ ���������
           prompt - ���᪠��� ���짮��⥫�, i - ���祭�� ��६�����}
var s: string;
    c: integer;
    err: boolean;
Begin
  repeat
    write (prompt);
    readln(s);
    val (s, i, c);
    writeln (i);
    err:= (  (length (s)>5) {���� ��������, ���ਬ�� ��� 77777} )or (c<>0) or ((c=0) and ((I<I_min) or (I>I_max)));
    if err then writeln('�訡��! ������ ����');
  until not err;
end;

procedure read_real (prompt: string; var i: real; i_min, i_max: real);
          {i_max, i_min - �ਭ���������� �᫠ ���������
           prompt - ���᪠��� ���짮��⥫�, i - ���祭�� ��६�����}
var s: string;
    c: integer;
    err: boolean;
Begin
  repeat
    write (prompt);
    readln(s);
    val (s, i, c);
    writeln (i);
    err:= (c<>0) or ((c=0) and ((I<I_min) or (I>I_max)));
    if err then writeln('�訡��! ������ ����');
  until not err;
end;

Begin
  clrscr;
  read_real ('������ ���न���� � ', x, -32000,32000);
  read_real ('������ ���न���� � ', y, -32000,32000);
  if (x<0) and (y>-x-a) and (sqr(x) + sqr(y) < sqr(a))
    then
    writeln ('��, �窠 �ਭ������� ������')
    else writeln ('���, �窠 �� �ਭ������� ������');
  readln;
end.