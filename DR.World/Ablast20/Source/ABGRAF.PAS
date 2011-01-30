{-= Graphic unit for Alien Blaster by Peter Moraliyski =-}

Unit ABGraf;

Interface

Type PaletteRecord = Array[0..255] of Record
                                        Red, Green, Blue : Byte;
                                      End;
     PalettePointer = ^PaletteRecord;

{*** PCX HANDLING ***}

{Get width and hight}
Procedure GetPcxDimensions(Var F : File; Var Width, Height : Word);

{Load the palette}
Procedure LoadPcxPalette(Var F : File; Var Palette : PalettePointer);

{Decode and load image to memory}
Function LoadPcx(Var F : File; Width, Height : Word; Var Destination : Pointer) : Boolean;

{*** HANDLING GRAPHIC MODE ***}

{Get red, green and blue components for of a specified color}
Procedure GetRGB(Color : Byte; Var R, G, B : Byte);

{Set new RGB vlaus of a color}
Procedure SetRGB(Color : Byte; R, G, B : Byte);

{Clear a virtual screen with the given color}
Procedure Clear(Color : Byte; Buffer : Word);

{Change screen mode}
Procedure SetMode(Mode : Word);

{Put pixel}
Procedure PutPixel(X, Y : Word; Color : Byte; Buffer : Pointer);

{Copy the contents from one buffer to another}
Procedure Flip(Var Source, Destination); {by Mc}

{Put a sprite}
Procedure PutSprite(X , Y, Width, Height : Word; Source, Destination : Pointer); {by Mc}

Implementation

Procedure GetPcxDimensions;
Begin
  Seek(F, $8); {seek and get width...}
  BlockRead(F, Width, SizeOf(Width));
  Inc(Width);
  Seek(F, $A); {seek and get height...}
  BlockRead(F, Height, SizeOf(Height));
  Inc(Height);
End;

Procedure LoadPcxPalette;
  Var Run : Byte;

Begin
  Seek(F, FileSize(F) - 256 * 3); {seek and get 256 color palette...}
  BlockRead(F, Palette^, 256 * 3);
  For Run:= 0 to 255 Do
  With Palette^[Run] Do {decode palette...}
  Begin
    Red:= Red Div 4;
    Green:= Green Div 4;
    Blue:= Blue Div 4;
  End;
End;

Function LoadPcx;
  Label byPass;
  Const BufferSize = 512;
  Type TBuffer = Array[0..BufferSize - 1] of Byte; {buffer for data transfer}
  Var Buffer : ^TBuffer;
      Counter, Loop, Run, X, Y : Word;
      Color, Temp : Byte;

Begin
  Counter:= 0;
  X:= 0;
  Y:= 0;
  New(Buffer);
  Seek(f, $80); {seek image data}
  While Y < Height Do {load image...}
  Begin
    BlockRead(F, Buffer^, BufferSize);
    Loop:= 0;
    While Loop < BufferSize Do
    Begin
      Color:= Buffer^[Loop];
      If (Color And $C0) = $C0 Then {compressed?}
      Begin {decompress...}
        If Loop = BufferSize - 1 Then
        Begin
          BlockRead(F, Buffer^[0], 1);
          Temp:= Buffer^[0];
        End
        Else
        Begin
          Inc(Loop);
          Temp:= Buffer^[Loop];
        End;
        For Run:= 1 to (Color And $3F) Do {copy to buffer}
        Begin
          Mem[Seg(Destination^) : Ofs(Destination^) + Counter]:= Temp;
          Inc(Counter);
        End;
      End
      Else {not compressed}
      Begin {copy to buffer}
        Mem[Seg(Destination^) : Ofs(Destination^) + Counter]:= Color;
        Inc(Counter);
      End;
      Inc(Loop);
      If Counter > Width * Height - 1 Then Goto ByPass;
    End;
  End;
  ByPass:
  Dispose(Buffer);
  LoadPcx:= True;
End;

Procedure GetRGB;
Begin
  Port[$3C7]:= Color; {setup the ports and get the values...}
  R:= Port[$3C9];
  G:= Port[$3C9];
  B:= Port[$3C9];
End;

Procedure SetRGB; {setup the ports and set the values...}
Begin
  Port[$3C8]:= Color;
  Port[$3C9]:= R;
  Port[$3C9]:= G;
  Port[$3C9]:= B;
End;

Procedure Clear; Assembler;
Asm
  Push ES
  Mov  CX, 32000 {(width of display * height of display) divided by 2}
  Mov  ES, [Buffer]
  Xor  DI, DI
  Mov  AL, [Color]
  Mov  AH, AL
  Rep  StosW
  Pop  ES
end;

Procedure SetMode; Assembler;
Asm
  Mov AX, Mode
  Int $10
end;

Procedure PutPixel;
Begin
  Mem[Seg(Buffer^) : Y * 320 + X]:= Color;
end;

Procedure Flip; Assembler;
Asm
  Push DS
  Push SI
  Les  DI, Destination
  Lds  SI, Source
  Mov  CX, 16000
{  shr  cx, 2}
  DB   $F3, $66, $A5
  Pop  SI
  Pop  DS
End;

Procedure PutSprite; Assembler;
Asm
  Push DS
  Push BP
  Mov  DX, Width
  Mov  CX, Height
  Mov  AX, X
  Mov  BX, Y
  Les  DI, Destination
  Lds  SI, Source
  {machine code of PutSprite...}
  DB 081h, 0fbh, 000h, 000h, 07dh, 00dh, 0f7h, 0dbh, 02bh, 0cbh, 076h, 065h, 00fh
  DB 0afh, 0dah, 003h, 0f3h, 02bh, 0dbh, 081h, 0fbh, 0c8h, 000h, 073h, 058h, 050h
  DB 0b8h, 0c8h, 000h, 02bh, 0c3h, 03bh, 0c8h, 076h, 002h, 08bh, 0c8h, 058h, 069h
  DB 0dbh, 040h, 001h, 003h, 0fbh, 02bh, 0edh, 081h, 0f8h, 000h, 000h, 07dh, 00ch
  DB 0f7h, 0d8h, 02bh, 0d0h, 076h, 037h, 08bh, 0e8h, 003h, 0f0h, 02bh, 0c0h, 081h
  DB 0f8h, 040h, 001h, 073h, 02bh, 0bbh, 040h, 001h, 02bh, 0d8h, 03bh, 0d3h, 072h
  DB 006h, 003h, 0eah, 02bh, 0ebh, 08bh, 0d3h, 003h, 0f8h, 0bbh, 040h, 001h, 02bh
  DB 0dah, 051h, 08bh, 0cah, 0ach, 00ah, 0c0h, 074h, 003h, 0aah, 0ebh, 001h, 047h
  DB 0e2h, 0f5h, 003h, 0fbh, 003h, 0f5h, 059h, 0e2h, 0ebh
  Pop  BP
  Pop  DS
End;

End.
