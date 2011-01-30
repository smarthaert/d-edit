{ Утилиты ввода/вывода для работы компонент Contest Server 2000 }
Unit IOTools;

Interface

{$I-}

 Procedure RuntimeError( Message:String );
 Procedure OpenTextForRead( Var T:Text; FileName:String );
 Function Str2Int( S:String ):LongInt;
 Function Int2Str( L:LongInt ):String;

Implementation

 Procedure RuntimeError( Message:String );
   Begin
     Writeln('Ошибка: ',Message);
     Halt(1);
   End;

 Procedure OpenTextForRead( Var T:Text; FileName:String );
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then RuntimeError('Hе могу открыть: "'+FileName+'"');
   End;
   
 Function Str2Int( S:String ):LongInt;
   Var Res:LongInt; Error:Integer;
   Begin
     Val(S,Res,Error);
     If Error<>0 then RuntimeError('Hе могу конвертировать строку в число.');
     Str2Int:=Res;
   End;
   
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
   End;

End.