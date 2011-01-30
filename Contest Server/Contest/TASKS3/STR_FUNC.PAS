Unit Str_Func;

Interface

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function StrNum( S:String ):LongInt;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function NumStr( N:LongInt ):String;

{ ---=== ฎก ขซฅญจฅ แจฌขฎซฎข แง คจ ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

Implementation

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function StrNum( S:String ):LongInt;
   Var Error:Integer; Temp:LongInt;
   Begin
     Val(S,Temp,Error);
     If Error <> 0 then
       StrNum:=MaxLongInt
     Else
       StrNum:=Temp;
   End;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function NumStr( N:LongInt ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     NumStr:=Temp;
   End;

{ ---=== ฎก ขซฅญจฅ แจฌขฎซฎข แง คจ ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Temp:=S;
     While Length(Temp) < Digits do Temp:=Temp+Symbol;
     AddSym:=Temp;
   End;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;
   Var Temp:String;
   Begin
     Str(N,Temp);
     While Length(Temp) < Digits do Temp:=Symbol+Temp;
     AddNumStr:=Temp;
   End;

End.