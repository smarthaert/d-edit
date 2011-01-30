{ “โจซจโ๋ ขขฎค /ข๋ขฎค  คซ๏ เ กฎโ๋ ชฎฌฏฎญฅญโ Contest Server 2000 }
Unit IOTools;

Interface

{$I-}

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                        /                             ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Procedure RuntimeError( Message:String );
 Procedure OpenTextForRead( Var T:Text; FileName:String );

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                          ‘ ’                              ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function Str2Int( S:String ):LongInt;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function Int2Str( L:LongInt ):String;

{ ---=== ฎก ขซฅญจฅ แจฌขฎซฎข แง คจ ===--- }
 Function AddSym( S:String; Symbol:Char; Digits:Byte ):String;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ คฎฏฎซญฅญญใ๎ แจฌขฎซ ฌจ แฏเ ข  ===--- }
 Function AddNumStr( N:LongInt; Symbol:Char; Digits:Byte ):String;

Implementation

 Uses CRT;

{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                        /                             ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }

 Procedure RuntimeError( Message:String );
   Begin
     TextColor(15); Writeln;
     Writeln('่จกช : ',Message);
     Halt(1);
   End;

 Procedure OpenTextForRead( Var T:Text; FileName:String );
   Begin
     Assign(T,FileName);
     Reset(T);
     If IOResult<>0 then RuntimeError('Hฅ ฌฎฃใ ฎโชเ๋โ์: "'+FileName+'"');
   End;

{ ---=== ฅเฅขฎค แโเฎชจ ข ็จแซฎ ===--- }
 Function Str2Int( S:String ):LongInt;
   Var Res:LongInt; Error:Integer;
   Begin
     Val(S,Res,Error);
     If Error<>0 then RuntimeError('Hฅ ฌฎฃใ ชฎญขฅเโจเฎข โ์ แโเฎชใ ข ็จแซฎ.');
     Str2Int:=Res;
   End;

{ ---=== ฅเฅขฎค ็จแซ  ข แโเฎชใ ===--- }
 Function Int2Str( L:LongInt ):String;
   Var Res:String;
   Begin
     Str(L,Res);
     Int2Str:=Res;
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