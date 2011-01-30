{ * RunError - ��ࠡ�⪠ Runtime �訡�� * }
Unit RunError;

Interface

{ ��室 �� �ணࠬ�� � ᮮ�饭��� �� �訡�� }
Procedure RuntimeError( Message:String );
{ ����⨥ 䠩�� � ᮮ�饭��� �� �訡�� �᫨ �� �� ���뢠���� }
Procedure OpenFileRE( Var F:File; FileTypeName,FileName:String );
Procedure OpenTextRE( Var F:Text; FileTypeName,FileName:String );

Implementation

Const NS : String = #13#10;

Procedure RuntimeError( Message:String );
  Begin
    Asm MOV AX,3; INT 10h; End; { ���室�� � ⥪�⮢�� ०�� }
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
