{Simple MCGA 320x200x256 unit by Bj”rn Hallstr”m}

UNIT Graphic;

INTERFACE
  {PROCEDURES}
  PROCEDURE MCGA;                                   {Enter MCGA mode}
  PROCEDURE Textmode;                               {Back to text mode}
  PROCEDURE PutPix(x:Word; y,col:Byte);             {Puts a pixel}
  PROCEDURE Line(x1,y1,x2,y2:Integer; col:Byte);    {Draws a line}
  PROCEDURE Hline(x1, x2: Word; y,col:Byte);        {Draws a horizontal line}
  PROCEDURE Vline(y1, y2: Byte; x:Word; col:Byte);  {Draws a vertical line}
  PROCEDURE Rectangle(x1,y1,x2,y2:Word; col:Byte);  {Draws a rectangle}
  PROCEDURE SetRGBPalette(nr,r,g,b:Byte);           {Sets the RGB for a color}
  PROCEDURE GetRGBPalette(nr:byte; VAR r,g,b:Byte); {Gets the RGB for a color}
  PROCEDURE WaitRetrace;                            {Wait for verticalretrace}
  PROCEDURE ShowPic(filen:STRING; x,y:Word; ex:ShortInt);
  {FUNCTIONS}
  FUNCTION GetPix(x:Word; y:Byte) : Byte;           {Returns the pixel color}


IMPLEMENTATION

Procedure MCGA;
BEGIN
  ASM mov ax,13h; int 10h; END;
END;

Procedure Textmode;
BEGIN
  ASM mov ax,3h; int 10h; END;
END;


PROCEDURE PutPix(x:Word; y,col:Byte);
BEGIN
  Mem[$a000:x+y*320]:=col;
END;

PROCEDURE Line(x1,y1,x2,y2:Integer; col:Byte);
VAR Angel      : Real;
    RAngel     : Real;
    i          : Integer;
    DifX, DifY : Integer;
BEGIN
  IF x1=x2 THEN
  BEGIN
    IF y2>=y1 THEN FOR i:=y1 TO y2 DO PutPix(x1, i, col);
    IF y1>y2 THEN FOR i := y2 TO y1 DO PutPix(x1, i, col);
    Exit;
  END;

  IF y1=y2 THEN
  BEGIN
    IF x1<x2 THEN FOR i:=x1 TO x2 DO PutPix(i, y1, Col);
    IF x1>=x2 THEN FOR i:=x2 TO x1 DO PutPix(i, y1, Col);
    Exit;
  END;

  Angel:=(y1-y2)/(x1-x2);
  DifX:=Abs(x1-x2);
  DifY:=Abs(y1-y2);

  IF DifX<=DifY THEN
  BEGIN
    IF y1>y2 THEN
    BEGIN
      y1:=y2;
      x1:=x2;
    END;
    RAngel:=1/Angel;
    FOR i:=0 TO DifY DO PutPix(Trunc(i*RAngel)+x1, i+y1, Col);
  END
  ELSE
  BEGIN
    IF x1>x2 THEN
    BEGIN
      x1:=x2;
      y1:=y2;
    END;
    FOR i := 0 TO DifX DO PutPix( i + x1, Trunc( Angel * i ) + y1, Col );
  END;
END;

PROCEDURE Hline(x1, x2: Word; y,col:Byte);
VAR i:Word;
BEGIN
  FOR i:=x1 TO x2 DO Mem[$a000:i+y*320]:=col;
END;

PROCEDURE Vline(y1, y2: Byte; x:Word; col:Byte);
VAR i:Word;
BEGIN
  FOR i:=y1 TO y2 DO Mem[$a000:x+i*320]:=col;
END;

PROCEDURE Rectangle(x1,y1,x2,y2:Word; col:Byte);
VAR i, j : Word;
BEGIN
  FOR I:=x1 to x2-1 DO Mem[$a000:i+y1*320]:=col;
  FOR I:=x1+1 to x2 DO Mem[$a000:i+y2*320]:=col;
  FOR I:=y1+1 to y2 DO Mem[$a000:x1+i*320]:=col;
  FOR I:=y1 to y2-1 DO Mem[$a000:x2+i*320]:=col;
END;

PROCEDURE SetRGBPalette(nr,r,g,b:Byte);
BEGIN
  Port[$3C8]:=nr;
  Port[$3C9]:=r;
  Port[$3C9]:=g;
  Port[$3C9]:=b;
END;

PROCEDURE GetRGBPalette(nr:Byte; VAR r,g,b:Byte);
BEGIN
  Port[$3C8]:=nr;
  r:=Port[$3C9];
  g:=Port[$3C9];
  b:=Port[$3C9];
END;

PROCEDURE WaitRetrace;
BEGIN
  ASM
    mov dx,$3da
  @1:in al,dx
    test al,8
    jz @1
  @2:in al,dx
    test al,8
    jnz @2
  END;
END;

PROCEDURE ShowPic(filen:STRING; x,y:Word; ex:ShortInt);
VAR i, j, c   : Word;
    Fil       : Text;
    xMax, yMax: Word;
BEGIN
  Assign(Fil, filen);
  ReSet(Fil);
  Read(Fil, xMax);
  Read(Fil, yMax);
  FOR i:=1 TO xMax DO
    FOR j:=1 TO yMax DO
    BEGIN
      Read(Fil, c);
      IF c<>0 THEN Mem[$a000:i+x+(j+y)*320]:=c;
      IF c=0 THEN Mem[$a000:i+x+(j+y)*320]:=Mem[$a000:i+x+(j+y)*320];
    END;
  Close(fil);
END;


FUNCTION GetPix(x:Word; y:Byte) : Byte;
BEGIN
  GetPix:=Mem[$a000:x+y*320];
END;


BEGIN

END.
