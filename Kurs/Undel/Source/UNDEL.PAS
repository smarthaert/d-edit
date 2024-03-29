Uses DOS,F_DISK,U_LIST;

Const DirCount  : LongInt = 0;
      FileCount : LongInt = 0;
      StartDir  : String  = '';
      Symbol    : String  = '#';
      MakeChanges : Boolean = False; { ������ �� ��������� }

Procedure UndelDir( DirName:String );
  Var
    Dir : Array [1..16] of Dir_Type;        { ���� �� 1 ᥪ�� ��⠫��� }
    Path : DirStr;                { ������� ���᪠ }
    NameF: NameStr;               { ��� 䠩�� }
    Ext  : ExtStr;                { ����७�� 䠩�� }
    Disk : Byte;                  { ����� ��᪠ }
    Dirs : LongInt;               { ����� ᥪ�� }
    DirSize : Word;               { ������ ��⠫��� }
    J   : Integer;                { ����� ������� ��⠫��� }
    K,I : Integer;                { ���稪� }
    DI : TDisk;                   { ���ଠ�� � ��᪥ }
    Clus : Word;                  { ����� ������ }
    Flag,Changes : Boolean;       { �஢�ઠ ᨬ����� � 䫠� ��������� }
    FileStr : String;             { ����ﭨ� 䠩�� }
    DirInfo : SearchRec;          { ��� ���᪠ �����⠫���� }
  Begin
    Writeln('[!] ����⠭������� ��⠫��: ',DirName);
    ClearAll;
   { �᪠�� ��⠫�� }
    GetDirSector(DirName,Disk,Dirs,DirSize);
    If ((Dirs=0) Or Disk_Error) then { Dirs=0 - �訡�� � ������� }
      Begin
        Writeln('[!] �訡��: �� ������ ����!');
        Exit;
      End;
    GetDiskInfo(Disk,DI);         { ����砥� ����� ������ }
    ReadSector(Disk,Dirs,1,Dir);  { ��⠥� ���� ᥪ�� }
    K := 0;               { ������⢮ ��ᬮ�७��� ������⮢ }
    J := 1;               { ����騩 ������� ��⠫��� }
   { ���� ���᪠ }
    Changes:=False;
    Repeat
      If Dir[J].Name[1]=#0 then Exit; { �����㦥� ����� ᯨ᪠ 䠩��� }
     { �ய�᪠�� ��୥��� � ��� ��⠫�� (H�祣� �� ��稭����� �� '.') }
      While Dir[J].NameExt[1] = '.' do Inc(J);
     { �ய�᪠�� �� ASCII 䠩�� � ��⠫��� }
      Flag:=True;
      For I:=1 to Length(Dir[j].NameExt) do
        If Not (((Dir[j].NameExt[I] >= #32) And
                 (Dir[j].NameExt[I] <= #128)) Or
                 (Dir[j].NameExt[I] = #229)) then Flag:=False;
      If Flag then { ASCII - 䠩� }
        Begin
         { �������� 䠩� (��⠫��) }
          FileStr:='';
          If Dir[j].NameExt[1] = #229 then
            Begin
              Dir[j].NameExt[1] := Symbol[1];
              While FindStr(Dir[j].NameExt) do
                Dir[j].NameExt[1]:=Chr(Ord(Dir[j].NameExt[1])+1);
              AddStr(Dir[j].NameExt);
              If MakeChanges then 
                FileStr:='<����⠭�����>'
              Else
                FileStr:='<����� ����⠭�����>';
             { ����⨪�. ������⢮ ��⠫���� & ������⢮ 䠩��� }
              If (Dir[j].FAttr and Directory) = 0 then
                Inc(FileCount) Else Inc(DirCount);
             { ���ᨬ ��������� }
              Changes:=True;
            End;
         { ����騩 ������� ��⠫��� }
          Writeln('* ',DirName,'\',Dir[J].NameExt,' ',FileStr);
        End;
      Inc(J);
      If J = 17 then
        Begin
         { ���ᥭ�� ��������� }
          If (Changes And MakeChanges) then WriteSector(Disk,Dirs,1,Dir);
          Changes:=False;
          Inc(K,16);
          if K >= DirSize then Exit; { ��諨 �� ���� ��⠫��� }
          J := 1;         { �த������ � 1-�� ������� ᫥���饣� ᥪ�� }
          If (K div 16) mod DI.ClusSize=0 then
            If Succ(Dirs) < DI.DataLock then
              Inc(Dirs)       { ��୥��� ��⠫�� }
            Else
              Begin   { ����� ������ }
                Clus := GetFATItem(Disk,GetCluster(Disk,Dirs)); { ���� ������ }
                Dirs := GetSector(Disk,Clus) { ���� ᥪ�� }
              End
          Else Inc(Dirs); { ��।��� ᥪ�� - � ������ }
          ReadSector(Disk,Dirs,1,Dir)
        End;
    Until Dir[J].Name[1]=#0;
    If (Changes And MakeChanges) then WriteSector(Disk,Dirs,1,Dir);
    Writeln('[!] ����⠭������� ��⠫��� �����襭� !');
   { �����ᨢ�� �맮� ��� �����⠫���� }
    FindFirst(DirName+'\*.*',Directory,DirInfo);
    While DosError = 0 do
      Begin
        If ((DirInfo.Attr And Directory) <> 0) And
            (DirInfo.Name[1]<>'.') then
          UndelDir(DirName+'\'+DirInfo.Name);
        FindNext(DirInfo);
      End;
  End;  { UndelDir }

{ - UpCaseStr - }
Function UpCaseStr( S:String ):String;
  Var Res:String; I:Byte;
  Begin
    Res:=S;
    For I:=1 to Length(Res) do Res[I]:=UpCase(Res[I]);
    UpCaseStr:=Res;
  End;

{ - �᭮���� �ணࠬ�� - }
Begin
  Writeln('      --=== �ணࠬ�� ��� ����⠭������� ��ॢ� ��⠫���� ===--');
  Writeln('      * ���쪮 ��� FAT12,FAT16 �����஢��� ��� MS-DOS 6.22 *');
  Writeln(' * �� �����প�� ���頩����: ����� (812)511-31-95,Denis@ipo.spb.ru *');
  If ParamCount >= 1 then
    Begin
      StartDir:=UpCaseStr(ParamStr(1));
      Writeln(' * ����⠭��������� ��⠫��: ',StartDir);
      If ParamCount >= 2 then
        Begin
          Symbol:=UpCaseStr(ParamStr(2));
          Writeln(' * H�砫�� ���� ᨬ���: ',Symbol[1]);
          MakeChanges:=True;
        End
      Else
        Writeln('�������� ०��. ����� �� ����⠭����������.');
      Writeln('��⮪�� ����⠭�������: ');
      UndelDir(StartDir);
      Writeln('����⠭������ (����� ����⠭�����): ������ ',FileCount,' ��⠫���� ',DirCount);
    End
  Else
    Begin
      Writeln('��������! �訡��! H�墠⠥� ����室���� ��ࠬ��஢.');
      Writeln('��� ����᪠ �ᯮ����:');
      Writeln('  UNDEL <��� ����⠭����������� ��⠫���> [<H�砫�� ���� ᨬ���>]');
      Writeln('�ਬ��: UNDEL E:\USERS #  - ����⠭������� ᮤ�ন���� ��⠫��� USERS');
      Writeln('�� �⮬ UNDEL ����⠭���� ��⠫�� USERS �� ��᪥ E,');
      Writeln('�.�. ��᪠����� ��� ᮤ�ন��� � ����⠭���� 䠩�� � �����⠫��� ��� �������');
      Writeln('��稭��騬��� �� #. �᫨ ��������� ��� 䠩�� (��⠫���) ����� ������');
      Writeln('���� �⫨����� ⮫쪮 ��ࢮ� �㪢��, ��� ����⠭������� �㤥� ��࠭');
      Writeln('᫥���騩 ᨬ��� ⠡���� ASCII (ᨬ��� $, ��⥬ %,...)');
      Writeln('�� ����᪥ � ����� ��ࠬ��஬ UNDEL ���� ������� ᯨ᮪ 㤠������ 䠩���.');
      Writeln('��। ����᪮� ࠧ��� ��אַ� ����� � ���� � ������� TESTDIR.EXE');
    End;
End.