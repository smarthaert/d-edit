{ * �������� ��६���� � Config-file ��� Tanks(new!) * }
Unit TanksCfg;

Interface

 Uses Ini_Unit;

{ - �������� ����ࠨ����� ��६���� - }
 Const { -= ���� ���䨣�p�樨 ��p� 'TANKS' =- }
   Max_Level       : Byte = 0; { ���ᨬ���� �p����� (0) }
   Start_Level     : Byte = 1; { ��砫�� �p����� (1) }
   Current_Delay   : Byte = 10; { ������ ����p��� (10) }
   Password_Key    : Byte = 55;
    { Scan ��� ������ ��p�室� �� ᫥���騩 �p����� (55 - PrtScr(Gray *) }
   Set_Tanks_Delay : Byte = 50;
    { ����p��� ����� ������� �p���᪨� ⠭��� (50) }
  { ��� �p��� �뢮�� ���p��樨 � �p���᪨� ⠭��� (255)
    ��� 255 - ��� ������襣�
    ���   0 - ��� ������⢨� }
   Enemy_Tanks_Info : Byte = 255;
  { ����� ���⠢��: 0-�� �����뢠�� 1-�����뢠�� (1) }
   Show_Poster : Byte = 1;

{ - H���ன�� ��⥬� - }
 Type
   TINI = Object(TINIFile)
     Procedure SetVar( Name,Value:String ); Virtual;
   End;
 Var INI:TINI;

Implementation

Uses RunError,StrUtils;

 Procedure TINI.SetVar( Name,Value:String );
   Begin
    { - ��ࠡ�⪠ ������ - }
     If Name = 'MAX_LEVEL'        then Max_Level        := Str2Int(Value) Else
     If Name = 'START_LEVEL'      then Start_Level      := Str2Int(Value) Else
     If Name = 'CURRENT_DELAY'    then Current_Delay    := Str2Int(Value) Else
     If Name = 'PASSWORD_KEY'     then Password_Key     := Str2Int(Value) Else
     If Name = 'SET_TANKS_DELAY'  then Set_Tanks_Delay  := Str2Int(Value) Else
     If Name = 'ENEMY_TANKS_INFO' then Enemy_Tanks_Info := Str2Int(Value) Else
     If Name = 'SHOW_POSTER'      then Show_Poster      := Str2Int(Value) Else
    { ����ୠ� ������� }
     RuntimeError('[Error]: ������ ��ࠬ��� � INI 䠩��! ['+Name+
       ' = '+Value+']');
   End;

End.
