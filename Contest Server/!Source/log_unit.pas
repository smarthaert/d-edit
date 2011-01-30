{ ษออออออออออออออออออออออออออป }
{ บ  ---=== LOG Unit ===---  บ }
{ ศออออออออออออออออออออออออออผ }

Unit LOG_Unit;

Interface

{ ---=== เฅฌ๏ ===--- }
 Const CurHour            : Word    = 0;
       CurMinute          : Word    = 0;
       CurSecond          : Word    = 0;
       CurSec100          : Word    = 0;

{ ---=== ‘โเฎช  ขเฅฌฅญจ ===--- }
 Function CurrentTimeStr:String;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ           €   ‘    ’ …  “   •   ‘    ’            ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Const LogFileName : String = '_LOG_.TXT';
 Var Log : Text;

 Procedure OpenLog;
 Procedure CloseLog; Far;

{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }
{ <><><><><><><> }         Implementation             { <><><><><><><> }
{ <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> }

{$I-}

Uses DOS;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

{ ---=== ‘โเฎช  ขเฅฌฅญจ ===--- }
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