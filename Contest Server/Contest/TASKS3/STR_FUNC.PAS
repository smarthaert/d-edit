Unit Str_Func;

Interface

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                          � � � � � �                          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ ---=== �ムア�� 痰牀�� � 腮甄� ===--- }
 Function StrNum( S:String ):LongInt;

{ ---=== �ムア�� 腮甄� � 痰牀�� ===--- }
 Function NumStr( N:LongInt ):String;

{ ---=== ����←キ┘ 瓱�〓��� 瓰�え ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== �ムア�� 腮甄� � 痰牀�� ぎ����キ�竡 瓱�〓���� 甎���� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

Implementation

{ 浜冤様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様冤� }
{ � �                          � � � � � �                          � � }
{ 藩詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様詫� }

{ ---=== �ムア�� 痰牀�� � 腮甄� ===--- }
 Function StrNum( S:String ):LongInt;
   Var Error:Integer; Temp:LongInt;
   Begin
     Val(S,Temp,Error);
     If Error <> 0 then
       StrNum:=MaxLongInt
     Else
       StrNum:=Temp;
   End;

{ ---=== �ムア�� 腮甄� � 痰牀�� ===--- }
 Function NumStr( N:LongInt ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     NumStr:=Temp;
   End;

{ ---=== ����←キ┘ 瓱�〓��� 瓰�え ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ ---=== �ムア�� 腮甄� � 痰牀�� ぎ����キ�竡 瓱�〓���� 甎���� ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

End.