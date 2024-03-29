{ 浜様様様様様様様様様様様様融 }
{ �  ---=== LOG Unit ===---  � }
{ 藩様様様様様様様様様様様様夕 }

Unit LOG_Unit;

Interface

{ ---=== �爛�� ===--- }
 Const CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;

{ ---=== �矗��� ∇ガキ� ===--- }
 Function CurrentTimeStr:String;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �          � � � � � �   � � � � � � �   � � � � � � �          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

 Const LogFileName : String = '_LOG_.TXT';
 Var Log : Text;

 Procedure OpenLog;
 Procedure CloseLog; Far;

{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }
{ <><><><><><><> }         Implementation             { <><><><><><><> }
{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }

{$I-}

Uses DOS;

{ ---=== �ムア�� 腮甄� � 痰牀�� ぎ����キ�竡 瓱�〓���� 甎���� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ ---=== �矗��� ∇ガキ� ===--- }
 Function CurrentTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurrentTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

 Var StartDir:String;

 Procedure OpenLog;
   Begin
     GetDir(0,StartDir);
     ExitProc:=Addr(CloseLog);
     Assign(Log,LogFileName);
     Append(Log);
     If IOResult<>0 then Rewrite(Log);
     Writeln(Log,'>>>  LogFileName = '+LogFileName+'  ['+CurrentTimeStr+'] <<<');
     Writeln(Log,' �砒モ � �牀ぅ������ ��｀皀: ');
     Writeln(Log,'=============================');
   End;

 Procedure CloseLog;
   Begin
     Writeln(Log,'>>> ���ユ ����� '+LogFileName+'  ['+CurrentTimeStr+'] <<<');
     Writeln(Log);
     Close(Log);
     ChDir(StartDir);
   End;

Begin
  OpenLog;
End.