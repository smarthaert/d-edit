{> �⨫�� ��� �����஢���� OUTPUT.TXT <}
Uses DOS,Tools;
{$M $4000,$2000,$4000}

{$I+}

Procedure RuntimeError( Message:String );
  Begin
    Writeln('Runtime Error : ',Message);
    Halt(1);
  End;

Var Problem,Problems:Char; TD,SD:String; Test,Tests:Byte; T:Text;

Procedure ReadTests;
  Begin
   { ���뢠�� ������⢮ ��⮢ }
    Writeln('���� ',TD+'TESTS.TXT');
    Assign(T,TD+'TESTS.TXT');
    Reset(T);
    If IOResult<>0 then RuntimeError('�� ���� ������ 䠩� !');
    Readln(T,Tests);
    Close(T);
  End;

Begin
  Writeln('>>> �⨫�� ��� �����஢���� OUTPUT.TXT <<<');
  Write('��� ��᫥���� ����� : '); Readln(Problems);
  SD:='SOURCE\';
  For Problem:='A' to Problems do
    Begin
      TD:='TESTS\'+Problem+'\';
      ReadTests;
     { ���� �� ��⠬ }
      For Test:=1 to Tests do
        Begin
          Write(Problem,' - ',Test,' ');
          CopyFile(TD+'INPUT'+AddNumStr(Test,'0',2)+'.TXT',SD+'INPUT.TXT');
         { ����� }
          Write('Exec ... ');
          ChDir('Source');
          SwapVectors;
          Exec(Problem+'.EXE','');
          SwapVectors;
          Writeln('done');
          If DosError <> 0 then
            Writeln('Dos error #', DosError);
          ChDir('..');
         { �������� }
          CopyFile(SD+'OUTPUT.TXT',TD+'OUTPUT'+AddNumStr(Test,'0',2)+'.TXT');
        End;
    End;
  DelFile(SD+'INPUT.TXT');
  DelFile(SD+'OUTPUT.TXT');
End.