{ * GR_MCGA - ����� � 320x200 256c * }
Unit Gr_MCGA;

Interface

Type RGBPoint = Record R,G,B:Byte; End; { ���ᠭ�� �窨 � RGB }
Type RGBPalette = Array [0..255] of RGBPoint; { ���ᠭ�� ������� � RGB }
Procedure InitMCGA; { - ���樠������ MCGA - }
Procedure DoneMCGA; { - ���室 ���⭮ � ⥪�⮢�� ०�� - }
Procedure EnableRefrech; { - ������� ���������� ��࠭� - }
Procedure DisableRefrech; { - ������� ���������� ��࠭� - }
Procedure WaitForRetrace; { - �������� ����砭�� ����ᮢ�� ��࠭� - }
{ - ��⠭���� 梥�256 � ������ - }
Procedure SetPaletteColor( ColorNum,R,G,B:Byte ); 
Procedure SetPaletteColor64( Num,R,G,B:Byte ); { ���� - 0..63 }
{ - ��⠭���� ����� ������� - }
Procedure SetPalette( Pal:RGBPalette );
Procedure Flip( Src,Dst:Word ); { - ����஥ ����஢���� �����  - }
Procedure ClearMemory( lvSeg:Word ); { - ������ ����⪠ ����� ���⮬ 00h - }
{ - MCGA ��࠭ - }
Type TScreenBuffer = Array [0..199,0..319] of Byte;
     PScreenBuffer = ^TScreenBuffer;
Var Scr : TScreenBuffer Absolute $0A000:0000;
    DoubleBuffer : PScreenBuffer;
{ - �뢮� ��࠭���� ���� - }
Procedure Show;
{ - ����襭�� ��אַ㣮�쭨� - }
Procedure Bar( X1,Y1,X2,Y2:Word; Color:Byte );
{ - �뢮� ����⮣� �pאַ㣮�쭨�� � ��p���� ���p - }
Procedure BarDB(X1,Y1,X2,Y2:Word; Color:Byte );
{ - �뢮� p���� � Double Buffer - }
Procedure FrameDB( x1,y1,x2,y2:Integer; Color:Byte );
{ - ����㧪� ���⨭�� �� Pic-䠩�� - }
Procedure LoadPic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );
{ - ������ ���⨭�� � Pic-䠩� - }
Procedure SavePic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );

Implementation

Uses RunError;

{ - ���樠������ MCGA - }
Procedure InitMCGA; Assembler;
  Asm
    MOV AX,13h;
    INT 10h;
  End;

{ - ���室 ���⭮ � ⥪�⮢�� ०�� - }
Procedure DoneMCGA; Assembler;
  Asm
    MOV AX,3h;
    INT 10h;
  End;

{ - ������� ���������� ��࠭� - }
Procedure EnableRefrech; Assembler;
  Asm
    Mov AX,1200h
    Mov BL,36h
    Int 10h
  End;

{ - ������� ���������� ��࠭� - }
Procedure DisableRefrech; Assembler;
  Asm
    Mov AX,1201h
    Mov BL,36h
    Int 10h
  End;

{ - �������� ����砭�� ����ᮢ�� ��࠭� - }
Procedure WaitForRetrace;
  Begin
    While ((Port[$3DA] And 8) > 0) do;
    While ((Port[$3DA] And 8) = 0) do;
  End;

{ - ��⠭���� 梥�256 � ������ - }
Procedure SetPaletteColor( ColorNum,R,G,B:Byte );
  Begin
    Port[$3C8]:=ColorNum;
    Port[$3C9]:=R shr 2;
    Port[$3C9]:=G shr 2;
    Port[$3C9]:=B shr 2;
  End;

Procedure SetPaletteColor64( Num,R,G,B:Byte ); Assembler;
  Asm
    Mov DX,3C8h
    Mov AL,Num
    Out DX,AL
    Inc DX
    Mov AL,R
    Out DX,AL
    Mov AL,G
    Out DX,AL
    Mov AL,B
    Out DX,AL
  End;


{ - ��⠭���� ����� ������� - }
Procedure SetPalette( Pal:RGBPalette );
  Var Color:Byte;
  Begin
    For Color:=0 to 255 do
      SetPaletteColor(Color,Pal[Color].R,Pal[Color].G,Pal[Color].B);
  End;

{ - ����஥ ����஢���� �����  - }
Procedure Flip( Src,Dst:Word ); Assembler;
  Asm
    push ds
    mov ax,[dst]
    mov es,ax
    mov ax,[src]
    mov ds,ax
    xor si,si
    xor di,di
    mov cx,320*200/4
    rep;db 66h; movsw
    pop ds
  End;

{ - ������ ����⪠ ����� - }
Procedure ClearMemory( lvSeg:Word ); Assembler;
  Asm
    mov es,[lvSeg]
    xor di,di
    db 66h; xor ax,ax
    mov cx,320*200/4
    rep;db 66h;stosw
  End;

{ - ����襭�� ��אַ㣮�쭨� - }
Procedure Bar( X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        Scr[Y,X]:=Color;
  End;

{ - �뢮� ����⮣� �pאַ㣮�쭨�� � ��p���� ���p - }
Procedure BarDB(X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        DoubleBuffer^[Y,X]:=Color;
  End;

{ - �뢮� p���� � Double Buffer - }
Procedure FrameDB( x1,y1,x2,y2:Integer; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      Begin
        DoubleBuffer^[Y1,X]:=Color;
        DoubleBuffer^[Y2,X]:=Color;
      End;
    For Y:=Y1 to Y2 do
      Begin
        DoubleBuffer^[Y,X1]:=Color;
        DoubleBuffer^[Y,X2]:=Color;
      End;
  End;

{ - �뢮� ��࠭���� ���� - }
Procedure Show; Assembler;
  Asm
    Mov  AX,SegA000
    Mov  ES,AX
    Push DS
    Xor  DI,DI
    LDS  SI,DoubleBuffer
    Mov  CX,32000
    Rep  Movsw
    Pop  DS
  End;

{ - ����㧪� ���⨭�� �� Pic-䠩�� - }
Procedure LoadPic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );
  Var F:File;
  Begin
    OpenFileRE(F,'Pic',FileName);
    BlockRead(F,SB,SizeOf(SB));
    BlockRead(F,Pal,SizeOf(Pal));
    Close(F);
  End;

{ - ������ ���⨭�� � Pic-䠩� - }
Procedure SavePic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );
  Var F:File;
  Begin
    Assign(F,FileName);
    Rewrite(F);
    BlockWrite(F,SB,SizeOf(SB));
    BlockWrite(F,Pal,SizeOf(Pal));
    Close(F);
  End;

End.