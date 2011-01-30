{ 浜様様様様様様様様様様様様様様様様様様様様様様様様様� }
{ �  ---=== LOG Unit - ����瘡 皀�竕�� 甌°皋� ===---  � }
{ 藩様様様様様様様様様様様様様様様様様様様様様様様様様� }
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