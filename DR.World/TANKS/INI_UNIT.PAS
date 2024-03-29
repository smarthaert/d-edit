{ 浜様様様様様様様様様様様様様様様様様様様様様様� }
{ �  ---=== ｡譽�� - ���� ┃�罔��├�罔� ===---  � }
{ 藩様様様様様様様様様様様様様様様様様様様様様様� }
(*
 踸�ム �甎��讌������:
{ - H�痰牀��� 瓱痰ガ� - }
 Type
   TINI = Object(TINIFile)
     Procedure SetVar( Name,Value:String ); Virtual;
   End;

{ - ������讚襯 ��痰��│�ガ襯 �ムガキ�襯 - }
Var
  UsersDir, { ������� ��痰祚�キ�� �牀▲瑙ガ諷 ����� (��ぅ爨�� ��お������� 竍キ┴��) }
  TestsDir, { ������� 皀痰�� (���※�讚諷 爛茱�┤) }
  ResultsDir, { ������� 爛с�赳�皰� (�砒モ � �牀▲爲�) }
  TestersDir, { ������� �牀����� か� �牀▲爲� �癶モ�� }
  PupilDir, { ������� 瓣イキ┤ � �遒閻 (��膈諷 �砒モ��) }
  InFile, { ��� √�き��� ����� }
  SoftwareDir, { ������� ���竅�� 瓱痰ガ� }
  OutFile:String; { ��� �諷�き��� ����� }
  Time:LongInt; { �爛�� ぎ ���爬����� ��▲琥キ�� �牀������ (� 瓮�祗���) }

 Procedure TINI.SetVar( Name,Value:String );
   Begin
     OutText(10,'H�痰牀���: '+Name+' = '+Value);
    { ---=== ｡��｀皖� ������ ===--- }
     If Name = 'USERSDIR'   then UsersDir   := Value Else
     If Name = 'TESTSDIR'   then TestsDir   := Value Else
     If Name = 'RESULTSDIR' then ResultsDir := Value Else
     If Name = 'TESTERSDIR' then TestersDir := Value Else
     If Name = 'PUPILDIR'   then PupilDir   := Value Else
     If Name = 'INFILE'     then InFile     := Value Else
     If Name = 'OUTFILE'    then OutFile    := Value Else
     If Name = 'TIME'       then Time       := Str2Int(Value) Else
    { �アム��� ������� }
     RuntimeError('[Error]: �アム�覃 �����モ� � INI ����� !');
   End;

Var INI:TINI; 
  INI.Run('Start.ini');
*)

Unit INI_UNIT;

Interface

 Type
   TINIFile = Object
     Constructor Run( INIFileName:String ); { ｡��｀皖� ����� ┃�罔��├�罔� }
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