{ * RunError - Обработка Runtime ошибок * }
Unit RunError;

Interface

{ Выход из программы с сообщением об ошибке }
Procedure RuntimeError( Message:String );
{ Открытие файла с сообщением об ошибке если он не открывается }
Procedure OpenFileRE( Var F:File; FileTypeName,FileName:String );
Procedure OpenTextRE( Var F:Text; FileTypeName,FileName:String );

Implementation

Const NS : String = #13#10;

Procedure RuntimeError( Message:String );
  Begin
    Asm MOV AX,3; INT 10h; End; { Переходим в текстовой режим }
    Writeln('RuntimeError: ',Message);
    Halt(1);
  End;

Procedure OpenFileRE( Var F:File; FileTypeName,FileName:String );
  Begin
   {$I-} Assign(F,FileName); Reset(F,1); {$I+}
    If IOResult<>0 then
      RuntimeError(FileTypeName+' file missing. Couldn''t open "'+FileName+'"');
  End;

Procedure OpenTextRE( Var F:Text; FileTypeName,FileName:String );
  Begin
   {$I-} Assign(F,FileName); Reset(F); {$I+}
    If IOResult<>0 then
      RuntimeError(FileTypeName+' file missing. Couldn''t open "'+FileName+'"');
  End;

End.
