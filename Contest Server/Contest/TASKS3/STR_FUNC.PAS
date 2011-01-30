Unit Str_Func;

Interface

{ �������������������������������������������������������������������ͻ }
{ � �                          � � � � � �                          � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== ��ॢ�� ��ப� � �᫮ ===--- }
 Function StrNum( S:String ):LongInt;

{ ---=== ��ॢ�� �᫠ � ��ப� ===--- }
 Function NumStr( N:LongInt ):String;

{ ---=== ���������� ᨬ����� ᧠�� ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== ��ॢ�� �᫠ � ��ப� ����������� ᨬ������ �ࠢ� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

Implementation

{ �������������������������������������������������������������������ͻ }
{ � �                          � � � � � �                          � � }
{ �������������������������������������������������������������������ͼ }

{ ---=== ��ॢ�� ��ப� � �᫮ ===--- }
 Function StrNum( S:String ):LongInt;
   Var Error:Integer; Temp:LongInt;
   Begin
     Val(S,Temp,Error);
     If Error <> 0 then
       StrNum:=MaxLongInt
     Else
       StrNum:=Temp;
   End;

{ ---=== ��ॢ�� �᫠ � ��ப� ===--- }
 Function NumStr( N:LongInt ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     NumStr:=Temp;
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