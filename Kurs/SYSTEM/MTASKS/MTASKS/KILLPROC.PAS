{*********************************}
{*      ���������� ࠡ���      *}
{*  ����������୮�� ������  *}
{*         VSTasks v 1.0         *}
{*   (c) VVSsoft Group, 1993     *}
{*********************************}

{$S-,I-}
Uses VSTasks, Crt;

Var
  Ch : char;

procedure InputChar; far;
begin
 Writeln(' "�����" ����� !');
 repeat
  If KeyPressed then Ch:=ReadKey
   else SwithTasks;
 until Ch=#27;
end;

procedure P1; far;
begin
 Writeln('���୨� ����� 1!');
 repeat
  SwithTasks;
 until Ch='1';
 Writeln('���� ����� 1...');
end;

procedure P2; far;
begin
 Writeln('���୨� ����� 2!');
 repeat
  SwithTasks;
 until Ch='2';
 Writeln('���� ����� 2...');
end;

procedure P3; far;
begin
 Writeln('���୨� ����� 3!');
 repeat
  SwithTasks;
 until Ch='3';
 Writeln('���� ����� 3...');
end;

procedure Kill; far;
begin
 Writeln('���୨� ����� "㡨��"!');
 repeat
  SwithTasks;
 until Ch='4';
 Writeln('��� ���訫...');
 HaltAllTasks;
end;

begin
 RegisterTask(@P3,1024);
 RegisterTask(@P2,1024);
 RegisterTask(@InputChar,1024);
 RegisterTask(@P1,1024);
 RegisterTask(@Kill,1024);
 StartTasks;
 Writeln;
 Writeln('����� �����祭�');
end.

