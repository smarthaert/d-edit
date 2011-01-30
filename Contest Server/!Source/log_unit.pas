{ ��������������������������ͻ }
{ �  ---=== LOG Unit ===---  � }
{ ��������������������������ͼ }

Unit LOG_Unit;

Interface

{ ---=== �६� ===--- }
 Const CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;

{ ---=== ��ப� �६��� ===--- }
 Function CurrentTimeStr:String;

{ �������������������������������������������������������������������ͻ }
{ � �          � � � � � �   � � � � � � �   � � � � � � �          � � }
{ �������������������������������������������������������������������ͼ }

 Const LogFileName : String = '_LOG_.TXT';
 Var Log : Text;

 Procedure OpenLog;
 Procedure CloseLog; Far;

{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }
{ <><><><><><><> }         Implementation             { <><><><><><><> }
{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }

{$I-}

Uses DOS;

{ ---=== ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ �ࠢ� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ ---=== ��ப� �६��� ===--- }
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
     Writeln(Log,' ���� � �த������� ࠡ��: ');
     Writeln(Log,'=============================');
   End;

 Procedure CloseLog;
   Begin
     Writeln(Log,'>>> ����� 䠩�� '+LogFileName+'  ['+CurrentTimeStr+'] <<<');
     Writeln(Log);
     Close(Log);
     ChDir(StartDir);
   End;

Begin
  OpenLog;
End.