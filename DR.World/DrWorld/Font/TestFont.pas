{$G+}
Uses CRT;

{$I MCGA.PAS}

Procedure Pixel( X,Y:Word; Col:Byte );
  Begin
    SB^[Y*320+X]:=Col;
  End;

Var Font : Array [#32..#128,1..7,1..5] of Char;
    XFontSize,YFontSize : Byte;

Procedure LoadFont( FileName:String );
  Var C:Char; I,J:Byte; T:Text; S:String;
  Begin
    Assign(T,FileName);
    Reset(T);
    Read(T,YFontSize); Readln(T,XFontSize);
    For C:=#32 to #128 do
      Begin
        Readln(T,S);
        For I:=1 to YFontSize do
          Begin
            Readln(T,S);
            For J:=1 to XFontSize do
              Font[C,I,J]:=S[J];
          End;
      End;
    Close(T);
  End;

Procedure ShowFont( YBase:Word );
  Var C:Char; I,J:Byte; XS,YS:Word;
  Begin
    For C:=#32 to #128 do
      Begin
        YS:=(Ord(C) div 40) * 10;
        XS:=(Ord(C) mod 40) * 8;
        For I:=1 to YFontSize do
          For J:=1 to XFontSize do
            If Font[C,I,J] <> '_' then Pixel(XS+J+1,YS+I+1+YBase,0);
        For I:=1 to YFontSize do
          For J:=1 to XFontSize do
            Case Font[C,I,J] of
             'W': Pixel(XS+J,YS+I+YBase,15);
             'B': Pixel(XS+J,YS+I+YBase,7);
            End;
      End;
  End;

Var I:Word;
Begin
  Init_Demo;
  For I:=0 to 63999 do SB^[I]:=2;
  LoadFont('font_7x5.ini');
  ShowFont(0);
  LoadFont('font_5x5.ini');
  ShowFont(50);
  LoadFont('font_5x3.ini');
  ShowFont(100);
  Show;
  Repeat Until KeyPressed;
  Close_Demo;
End.
