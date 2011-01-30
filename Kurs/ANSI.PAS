{---------------Cut here------------------}

PROGRAM _ShowAnsi;
USES CRT;
{$M 20000, 10000, 10000}
CONST
  Escape     :  Byte = 0;
  {0 = Send output to screen/look for Escapes}
  {1 = Look for [}
  {2 = Look for parameters/commands}
  {Safe to abort ansi sequence when Escape = 0}
  {To reset sequence, simply set escape := 0}
  Num        :  Byte = 0;
  {Number of parameters}
VAR
  Params     :  ARRAY[ 1..16 ] OF Integer;
  {Maximum of 16 parameters}
  {"?" or "=" = -1}
  SaveX, SaveY :  Byte;

PROCEDURE MoveCursor(x, y : Integer);
BEGIN
IF y < 1 THEN y := 1;
IF y > 25 THEN y := 25;
IF x < 1 THEN x := 1;
IF x > 80 THEN x := 80;
GoToXY(x, y);
Escape := 0;
END;

FUNCTION Get(N : Byte) : Integer;
BEGIN
IF N > Num THEN
  Get := 0
ELSE
  Get := Params[ N ];
END;

FUNCTION Get1(N : Byte) : Integer;
BEGIN
IF N > Num THEN
  Get1 := 1
ELSE
  IF Params[ N ] < 1 THEN
    Get1 := 1
  ELSE
    Get1 := Params[ N ];
END;

PROCEDURE SetCol;
CONST
  Order : ARRAY[ 0..7 ] OF Byte = (0, 4, 2, 6, 1, 5, 3, 7);
VAR
  Col   : Byte;
  N     : Byte;
BEGIN
FOR N := 1 TO Num DO
  BEGIN
  Col := Get(N);
  CASE Col OF
    0      : BEGIN
             LowVideo;
             TextColor(LightGray);
             TextBackground(Black);
             END;
    1      : HighVideo;
    5      : TextAttr := TextAttr OR $80;
    7      : BEGIN
             LowVideo;
             TextAttr := ((TextAttr AND $7) SHL 4) + (TextAttr SHR 4);
             END;
    30..37 : TextAttr := (TextAttr AND $F8) + Order[ Col - 30 ];
    40..47 : TextBackground(Order[ Col - 40 ]);
    END;
  END;
Escape := 0;
END;

PROCEDURE WriteANS(ch : Char);
BEGIN
CASE Escape OF
  0 :  CASE ch OF
         #27  : Escape := 1;
         #9   : GoToXY(((WhereX SHR 3) + 1) * 8, WhereY);
         #12  : ClrScr;
         ELSE BEGIN
              IF (WhereX = 80) AND (WhereY = 25) THEN
                BEGIN
                WindMax := 80 + 24 * 256;
                Write(ch);
                WindMax := 79 + 24 * 256;
                END
              ELSE
                Write(ch);
              Escape := 0;
              END;
         END;
  1 :  IF ch = '[' THEN
         BEGIN
         Escape := 2;
         Num := 1;
         Params[ 1 ] := 0;
         END
       ELSE
         Escape := 0;
  2 :  CASE ch OF
         '0'..'9' :  Params[ Num ] := Params[ Num ] * 10 + Ord(ch) - Ord('0');
         ';'      :  BEGIN
                       Inc(Num);
                       Params[ Num ] := 0;
                       END;
         'H', 'f' :  MoveCursor(Get(2), Get(1));
         'A'      :  MoveCursor(WhereX, WhereY - Get1(1));
         'B'      :  MoveCursor(WhereX, WhereY + Get1(1));
         'C'      :  MoveCursor(WhereX + Get1(1), WhereY);
         'D'      :  MoveCursor(WhereX - Get1(1), WhereY);
         'J'      :  BEGIN
                       ClrScr;
                       Escape := 0;
                       END;
         'K'      :  BEGIN
                       ClrEol;
                       Escape := 0;
                       END;
         'm'      :  SetCol;
         's'      :  BEGIN
                       SaveX := WhereX;
                       SaveY := WhereY;
                       Escape := 0;
                       END;
         'u'      :  MoveCursor(SaveX, SaveY);
         '=', '?' :  BEGIN
                       Params[ Num ] := -1;
                       Inc(Num);
                       Params[ Num ] := 0;
                       END;
         'h'      :  BEGIN
                       IF Get(1) = -1 THEN
                         CASE Get(2) OF
                           0 : TextMode(bw40);
                           1 : TextMode(co40);
                           2 : TextMode(bw80);
                           3 : TextMode(co80);
                           4 : {GraphColorMode};
                           5 : {GraphMode};
                           6 : TextMode(co80 + Font8x8);
                           {7 : TruncateLines := FALSE;}
                           END;
                       Escape := 0;
                       END;
         'l', 'L' : BEGIN
                      IF (Get(1) = -1) AND (Get(2) = 7) THEN
                        {TruncateLines := FALSE};
                      {ignore this truncatelines, ive never seen it}
                      Escape := 0;
                      END;
         END;
  END;
END;

VAR
  F : Text;
  S : STRING;
  C : Char;
BEGIN
clrscr;
Assign(F, paramstr(1));
ReSet(F);
WHILE NOT EOF(F) DO
  begin
  WHILE NOT EOLN(F) DO
    BEGIN
    Read(F, C);
    WriteANS(C);
    END;
  Readln(F);
  WriteANS(#13);
  WriteANS(#10);
  end;
close(f);
END.

{-------Stop cutting here, and put away those dangerous scissors :-) -----}
