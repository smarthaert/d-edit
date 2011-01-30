{ ษออออออออออออออออออออออออออออออออออออออออออออป }
{ บ  ---=== Super Contest Server v0.01 ===---  บ }
{ บ      (c) Roman International Software      บ }
{ บ            Build 001 [20.11.99]            บ }
{ ศออออออออออออออออออออออออออออออออออออออออออออผ }

Unit ServerB;

Interface

{ ---=== เฅฌ๏ ===--- }
 Const StartContestHour   : Byte    = 0;
       StartContestMinute : Byte    = 0;
       CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;
       CurTime            : LongInt = 0;
       AllContestTime     : LongInt = 9999;
       TimeLeft           : LongInt = 9999;

{ ---=== ‘โเฎช  ขเฅฌฅญจ ===--- }
 Function CurrentTimeStr:String;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ           €   ‘    ’ …  “   •   ‘    ’            ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

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

{ ---=== ‘โเฎช  ขเฅฌฅญจ ===--- }
 Function CurrentTimeStr:String;
   Begin
     GetTime(CurHour,CurMinute,CurSecond,CurSec100);
     CurrentTimeStr := AddNumStr(CurHour,'0',2)+':'+
                       AddNumStr(CurMinute,'0',2)+':'+
                       AddNumStr(CurSecond,'0',2);
   End;

 Procedure OpenLog;
   Begin
     ExitProc:=Addr(CloseLog);
     Assign(FileLog,ServerLog);
     Append(FileLog);
     If IOResult<>0 then Rewrite(FileLog);
     Writeln(FileLog,'>>>  '+ServerLog+'  '+CurrentTimeStr+' <<<');
   End;

 Procedure CloseLog;
   Begin
     Writeln(FileLog,'>>> ฎญฅๆ ไ ฉซ  '+ServerLog+'  '+CurrentTimeStr+' <<<');
     Writeln(FileLog,#13#10#13#10#13#10);
     Close(FileLog);
   End;

 Procedure Log( _Message_:String );
   Begin
     Writeln(FileLog,_Message_);
   End;

End.