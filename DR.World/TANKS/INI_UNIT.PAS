{ ���������������������������������������������ͻ }
{ �  ---=== ��쥪� - 䠩� ���樠����樨 ===---  � }
{ ���������������������������������������������ͼ }
(*
 �ਬ�� �ᯮ�짮�����:
{ - H���ன�� ��⥬� - }
 Type
   TINI = Object(TINIFile)
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

{ - �������� ����ࠨ����� ��६���� - }
Var
  UsersDir, { ��⠫�� ����㯫���� �஢��塞�� ����� (����ন� �����⠫��� �祭����) }
  TestsDir, { ��⠫�� ��⮢ (�ࠢ����� �襭��) }
  ResultsDir, { ��⠫�� १���⮢ (���� � �஢�થ) }
  TestersDir, { ��⠫�� �ணࠬ� ��� �஢�ન �⢥⮢ }
  PupilDir, { ��⠫�� ᢥ����� � ���� (����� ���⮢) }
  InFile, { ��� �室���� 䠩�� }
  SoftwareDir, { ��⠫�� ����᪠ ��⥬� }
  OutFile:String; { ��� ��室���� 䠩�� }
  Time:LongInt; { �६� �� ���਩���� �����襭�� �ணࠬ�� (� ᥪ㭤��) }

 Procedure TINI.SetVar( Name,Value:String );
   Begin
     OutText(10,'H���ன��: '+Name+' = '+Value);
    { ---=== ��ࠡ�⪠ ������ ===--- }
     If Name = 'USERSDIR'   then UsersDir   := Value Else
     If Name = 'TESTSDIR'   then TestsDir   := Value Else
     If Name = 'RESULTSDIR' then ResultsDir := Value Else
     If Name = 'TESTERSDIR' then TestersDir := Value Else
     If Name = 'PUPILDIR'   then PupilDir   := Value Else
     If Name = 'INFILE'     then InFile     := Value Else
     If Name = 'OUTFILE'    then OutFile    := Value Else
     If Name = 'TIME'       then Time       := Str2Int(Value) Else
    { ����ୠ� ������� }
     RuntimeError('[Error]: ������ ��ࠬ��� � INI 䠩�� !');
   End;

Var INI:TINI; 
  INI.Run('Start.ini');
*)

Unit INI_UNIT;

Interface

 Type
   TINIFile = Object
     Constructor Run( INIFileName:String ); { ��ࠡ�⪠ 䠩�� ���樠����樨 }
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

Implementation

 Uses RunError,StrUtils;

 Constructor TINIFile.Run( INIFileName:String );
   Var T:Text; S:String; P:Byte;
   Begin
     OpenTextRE(T,'Ini-file',INIFileName);
     Repeat
       Readln(T,S);
       S:=UpCaseStr(DelSpaces(S));
       If ((S<>'') And (S[1]<>'#') And (S[1]<>';')) then
         Begin
           P:=Pos('=',S);
           SetVar( DelSpaces(Copy(S,1,P-1)),
                   DelSpaces(Copy(S,P+1,Length(S)-P)) );
         End;
     Until EOF(T);
     Close(T);
   End;

 Procedure TINIFile.SetVar( Name,Value:String ); Begin End;

End.