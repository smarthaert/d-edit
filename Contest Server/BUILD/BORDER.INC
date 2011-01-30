{ ---=== ç†‡®·Æ¢†‚Ï ‡†¨™„ ===--- }
 Procedure DrawBorder( X1,Y1,X2,Y2,Color:Byte );
   Var I:Byte;
   Begin
     TextColor(Color);
     For I:=(X1+1) to (X2-1) do
       Begin
         GotoXY(I,Y1); Write('Õ');
         GotoXY(I,Y2); Write('Õ');
       End;
     For I:=(Y1+1) to (Y2)-1 do
       Begin
         GotoXY(X1,I); Write('∫');
         GotoXY(X2,I); Write('∫');
       End;
     GotoXY(X1,Y1); Write('…');
     GotoXY(X1,Y2); Write('»');
     GotoXY(X2,Y1); Write('ª');
     GotoXY(X2,Y2); Write('º');
   End;
