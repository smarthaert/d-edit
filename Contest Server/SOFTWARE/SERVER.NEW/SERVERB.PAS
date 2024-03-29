{ 浜様様様様様様様様様様様様様様様様様様様様様融 }
{ �  ---=== Super Contest Server v0.01 ===---  � }
{ �      (c) Roman International Software      � }
{ �            Build 001 [20.11.99]            � }
{ 藩様様様様様様様様様様様様様様様様様様様様様夕 }

Unit ServerB;

Interface

{ ---=== �爛�� ===--- }
 Const StartContestHour   : Byte    = 0;
       StartContestMinute : Byte    = 0;
       CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;
       CurTime            : LongInt = 0;
       AllContestTime     : LongInt = 9999;
       TimeLeft           : LongInt = 9999;

{ ---=== �矗��� ∇ガキ� ===--- }
 Function CurTimeStr:String;

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �          � � � � � �   � � � � � � �   � � � � � � �          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

 Const ServerLog = 'LOG.TXT';
 Var FileLog : Text;

 Procedure OpenLog;
 Procedure CloseLog; Far;
 Procedure Log( _Message_:String );

{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }
{ <><><><><><><> }         Implementation             { <><><><><><><> }
{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }

{$I-}

Uses DOS,Tools;

{ ---=== �矗��� ∇ガキ� ===--- }
 Function CurTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

 Procedure OpenLog;
   Begin
     ExitProc:=Addr(CloseLog);
     Assign(FileLog,ServerLog);
     Append(FileLog);
     If IOResult<>0 then Rewrite(FileLog);
     Writeln(FileLog,'>>>  '+ServerLog+'  '+CurTimeStr+' <<<');
   End;

 Procedure CloseLog;
   Begin
     Writeln(FileLog,'>>> ���ユ ����� '+ServerLog+'  '+CurTimeStr+' <<<');
     Writeln(FileLog,#13#10#13#10#13#10);
     Close(FileLog);
   End;

 Procedure Log( _Message_:String );
   Begin
     Writeln(FileLog,_Message_);
   End;

End.