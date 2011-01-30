Uses CRT,SVGA;

Type
  Pixel = Record
    B,G,R:Byte;
  End;

Type
  TScreenLine = Array [0..639] of Pixel;
  PScreenLine = ^TScreenLine;

Var ScreenBuffer : Array [0..479] of PScreenLine;

Procedure InitScreenBuffer;
  Var I:Word;
  Begin
    For I:=0 to 479 do New(ScreenBuffer[I]);
  End;
  
Procedure CloseScreenBuffer;
  Var I:Word;
  Begin
    For I:=0 to 479 do Dispose(ScreenBuffer[I]);
  End;

Procedure _Put_( P:Pointer; Addr,Size:Word ); Assembler;
  Asm
    Mov  AX,SegA000
    Mov  ES,AX
    Mov  DI,Addr
    Push DS
    LDS  SI,P
    Mov  CX,Size
    Rep  Movsw
    Pop  DS
  End;

Procedure ShowScreenBuffer;
  Var I:Word;
  Begin
    For I:=0 to 479 do
      Begin
        If (I mod 2)=0 then Set_Bank(I shr 1);
        _Put_(ScreenBuffer[I],(I mod 2)*2048,960);
      End;
  End;

Var X,Y:Word;
Begin
  Init_SVGA($112);
  InitScreenBuffer;
  For X:=0 to 639 do
    For Y:=0 to 479 do
      With ScreenBuffer[Y]^[X] do
        Begin
          R:=X mod 256;
          G:=255-(X mod 256);
          B:=Y mod 256;
        End;
  ShowScreenBuffer;
  CloseScreenBuffer;
  ReadKey;
  Init_Text;
End.
