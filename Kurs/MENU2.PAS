Uses CRT;

Procedure OutText( Color:Byte; Str:String );
  Begin
    TextColor(Color);
    Write(Str);
  End; 

Function NumToStr( N:LongInt ):String;
  Var TempStr:String;
  Begin
    Str(N,TempStr);
    NumToStr := TempStr;
  End;

Procedure Menu;
  Var Key:Char; N,I,Select:Integer;
  Begin
    N:=5; Select:=1;
    Repeat
      For I:=1 to N do
        Begin
          GotoXY(10,I);
          If I = Select then
            OutText(15,'---=== '+NumToStr(I)+' ===---')
          Else
            OutText(7,'---=== '+NumToStr(I)+' ===---');
        End;
      GotoXY(1,1);
      Key := ReadKey;
      If Key = #00 then
        Case ReadKey of
         #72: Dec(Select);
         #80: Inc(Select);
        End;
      If Select < 1 then Select := N;
      If Select > N then Select := 1;
    Until Key = #27;
  End;

Begin
  ClrScr;
  Menu;
End.