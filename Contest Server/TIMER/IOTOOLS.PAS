{ �⨫��� �����/�뢮�� ��� ࠡ��� ��������� Contest Server 2000 }
Unit IOTools;

Interface

{$I-}

{ �������������������������������������������������������������������ͻ }
{ � �                    � � � � / � � � � �                        � � }
{ �������������������������������������������������������������������ͼ }

 Procedure RuntimeError( Message:String );
 Procedure OpenTextForRead( Var T:Text; FileName:String );

{ �������������������������������������������������������������������ͻ }
{ � �                          � � � � � �                          � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== ��ॢ�� ��ப� � �᫮ ===--- }
 Function Str2Int( S:String ):LongInt;

{ ---=== ��ॢ�� �᫠ � ��ப� ===--- }
 Function Int2Str( L:LongInt ):String;

{ ---=== ���������� ᨬ����� ᧠�� ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ �ࠢ� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

Implementation

 Uses CRT;

{ �������������������������������������������������������������������ͻ }
{ � �                    � � � � / � � � � �                        � � }
{ �������������������������������������������������������������������ͼ }

 Procedure RuntimeError( Message:String );
   Begin
     TextColor(15); Writeln;
     Writeln('�訡��: ',Message);
     Halt(1);
   End;

 Procedure OpenTextForRead( Var T:Text; FileName:String );
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then RuntimeError('H� ���� ������: "'+FileName+'"');
   End;

{ ---=== ��ॢ�� ��ப� � �᫮ ===--- }
 Function Str2Int( S:String ):LongInt;
   Var Res:LongInt; Error:Integer;
   Begin
     Val(S,Res,Error);
     If Error<>0 then RuntimeError('H� ���� �������஢��� ��ப� � �᫮.');
     Str2Int:=Res;
   End;

{ ---=== ��ॢ�� �᫠ � ��ப� ===--- }
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
   End;

{ ---=== ���������� ᨬ����� ᧠�� ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ ---=== ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ �ࠢ� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

End.