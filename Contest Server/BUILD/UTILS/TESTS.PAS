{ >>> �ணࠬ�� �����஢���� ��⮢ <<< }
Uses Tools;

Function Select:Byte;
  Var Temp:Byte;
  Begin
    Write(' �롥�� ⨯ ��⮢ : ');
    Readln(Temp);
    Select:=Temp;
  End;

{ ---=== ���砩�� �᫠ � ��������� [0..N] ===--- }
 Function LongRandom( N:LongInt ):LongInt;
   Var A,B,C:Real;
   Begin
     A:=Random($0FFFF); B:=Random($0FFFF); C:=$0FFFF;
     LongRandom:=Round((A*B*N)/(C*C));
   End;

Var T:Text; Test:Byte;

Procedure OpenFile;
  Begin
    Assign(T,'INPUT'+AddNumStr(Test,'0',2)+'.TXT');
    Rewrite(T);
  End;

Var Tests:Byte; Max,MinN,MaxN,Num,Count:LongInt;
Begin
  MkDir('TEMPTEST');
  ChDir('TEMPTEST');
  Randomize;
  Writeln('>>> �ணࠬ�� �����஢���� ��⮢ <<<');
  Write('������ ������⢮ ��⮢ : '); Readln(Tests);
 { �᭮���� ���� }
  Writeln(' 1. ��ࢮ� �᫮ - ������⢮ �ᥫ, ����� - ���� �᫠');
  Writeln(' 2. ����஢����� �᫮ �ᥫ � 䠩�� (�᫠ - 楫�)');
  Case Select of
   1: { ��ࢮ� �᫮ - ������⢮ �ᥫ, ����� - ���� �᫠ }
    Begin
      Write('���ᨬ��쭮� ������⢮ �ᥫ : '); Readln(Max);
      Write('�������쭮� ��������� �᫮ : '); Readln(MinN);
      Write('���ᨬ��쭮� ��������� �᫮ : '); Readln(MaxN);
      For Test:=1 to Tests do
        Begin
          OpenFile;
          Num:=1+Random(Max);
          Writeln(T,Num);
          For Count:=1 to Num do
            Writeln(T,MinN+LongRandom(MaxN-MinN+1));
          Close(T);
        End;
    End;
   2: { ���� �᫮ � 䠩�� }
    Begin
      Write('������⢮ �ᥫ : '); Readln(Num);
      Write('�������쭮� ��������� �᫮ : '); Readln(MinN);
      Write('���ᨬ��쭮� ��������� �᫮ : '); Readln(MaxN);
      For Test:=1 to Tests do
        Begin
          OpenFile;
          For Count:=1 to Num do
            Writeln(T,MinN+LongRandom(MaxN-MinN+1));
          Close(T);
        End;
    End;
  End;
  ChDir('..');
End.







