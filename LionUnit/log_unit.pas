{ ษอออออออออออออออออออออออออออออออออออออออออออออออออออป }
{ บ  ---=== LOG Unit -  ฏจแ์ โฅชใ้จๅ แฎก๋โจฉ ===---  บ }
{ ศอออออออออออออออออออออออออออออออออออออออออออออออออออผ }
Unit LOG_Unit;

Interface

 Const LogFileName : String = '_LOG_.TXT';
 Var Log : Text;

 Procedure OpenLog;
 Procedure CloseLog; Far;

Implementation     

 Uses DOS,StrUtils;

 Var StartDir:String;

 Procedure OpenLog;
   Begin
     GetDir(0,StartDir);
     ExitProc:=Addr(CloseLog);
     Assign(Log,LogFileName);
     {$I-}Append(Log);{$I+}
     If IOResult<>0 then Rewrite(Log);
     Writeln(Log,'>>> LogFileName = '+LogFileName+'  ['+CurrentTimeStr+'] <<<');
     Writeln(Log,' โ็ฅโ ฎ ฏเฎคฅซ ญญฎฉ เ กฎโฅ: ');
     Writeln(Log,'=============================');
   End;

 Procedure CloseLog;
   Begin
     Writeln(Log,'>>> ฎญฅๆ ไ ฉซ  '+LogFileName+'  ['+CurrentTimeStr+'] <<<');
     Writeln(Log);
     Close(Log);
     ChDir(StartDir);
   End;

Begin
  OpenLog;
End.