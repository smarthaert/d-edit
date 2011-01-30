{ ษออออออออออออออออออออออออออออออออออออออออออออป }
{ บ  ---=== Super Contest Server v0.01 ===---  บ }
{ บ      (c) Roman International Software      บ }
{ บ            Build 001 [20.11.99]            บ }
{ ศออออออออออออออออออออออออออออออออออออออออออออผ }

Unit ServerB;

Interface

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ           €   ‘    ’ …  “   •   ‘    ’            ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Const ServerLog = 'LOG.TXT';
 Var FileLog : Text;

 Procedure OpenLog;
   Begin
     Assign(FileLog,ServerLog);
     Append(FileLog);
     If IOResult<>0 then Rewrite(FileLog);
     Writeln(FileLog,'>>>  ็ ซฎ ไ ฉซ  '+ServerLog+'  '+CurrentTimeStr+' <<<');
   End;

 Procedure CloseLog; Far;
   Begin
     Writeln(FileLog,'>>> ฎญฅๆ ไ ฉซ  '+ServerLog+'  '+CurrentTimeStr+' <<<');
     Writeln(FileLog,#13#10#13#10#13#10);
     Close(FileLog);
   End;

 Procedure Log( _Message_:String );
   Begin
     Writeln(FileLog,_Message_);
   End;

Implementation

 Procedure OpenLog;
   Begin
     Assign(FileLog,ServerLog);
     Append(FileLog);
     If IOResult<>0 then Rewrite(FileLog);
     Writeln(FileLog,'>>>  '+ServerLog+'  '+CurrentTimeStr+' <<<');
   End;

 Procedure CloseLog; Far;
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