{ * GR_MCGA - Работа в 320x200 256c * }
Unit Gr_MCGA;

Interface

Type RGBPoint = Record R,G,B:Byte; End; { Описание точки в RGB }
Type RGBPalette = Array [0..255] of RGBPoint; { Описание палитры в RGB }
Procedure InitMCGA; { - Инициализация MCGA - }
Procedure DoneMCGA; { - Переход обратно в текстовой режим - }
Procedure EnableRefrech; { - Разрешить обновление экрана - }
Procedure DisableRefrech; { - Запретить обновление экрана - }
Procedure WaitForRetrace; { - Ожидание окончания перерисовки экрана - }
{ - Установка цвета256 в палитре - }
Procedure SetPaletteColor( ColorNum,R,G,B:Byte ); 
Procedure SetPaletteColor64( Num,R,G,B:Byte ); { Цвет - 0..63 }
{ - Установка новой палитры - }
Procedure SetPalette( Pal:RGBPalette );
Procedure Flip( Src,Dst:Word ); { - Быстрое копирование памяти  - }
Procedure ClearMemory( lvSeg:Word ); { - Быстрая отчистка памяти байтом 00h - }
{ - MCGA экран - }
Type TScreenBuffer = Array [0..199,0..319] of Byte;
     PScreenBuffer = ^TScreenBuffer;
Var Scr : TScreenBuffer Absolute $0A000:0000;
    DoubleBuffer : PScreenBuffer;
{ - Вывод Экранного Буфера - }
Procedure Show;
{ - Закрашенный прямоугольник - }
Procedure Bar( X1,Y1,X2,Y2:Word; Color:Byte );
{ - Вывод залитого пpямоугольника в экpанный буфеp - }
Procedure BarDB(X1,Y1,X2,Y2:Word; Color:Byte );
{ - Вывод pамки в Double Buffer - }
Procedure FrameDB( x1,y1,x2,y2:Integer; Color:Byte );
{ - Загрузка картинки из Pic-файла - }
Procedure LoadPic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );
{ - Запись картинки в Pic-файл - }
Procedure SavePic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );

Implementation

Uses RunError;

{ - Инициализация MCGA - }
Procedure InitMCGA; Assembler;
  Asm
    MOV AX,13h;
    INT 10h;
  End;

{ - Переход обратно в текстовой режим - }
Procedure DoneMCGA; Assembler;
  Asm
    MOV AX,3h;
    INT 10h;
  End;

{ - Разрешить обновление экрана - }
Procedure EnableRefrech; Assembler;
  Asm
    Mov AX,1200h
    Mov BL,36h
    Int 10h
  End;

{ - Запретить обновление экрана - }
Procedure DisableRefrech; Assembler;
  Asm
    Mov AX,1201h
    Mov BL,36h
    Int 10h
  End;

{ - Ожидание окончания перерисовки экрана - }
Procedure WaitForRetrace;
  Begin
    While ((Port[$3DA] And 8) > 0) do;
    While ((Port[$3DA] And 8) = 0) do;
  End;

{ - Установка цвета256 в палитре - }
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


{ - Установка новой палитры - }
Procedure SetPalette( Pal:RGBPalette );
  Var Color:Byte;
  Begin
    For Color:=0 to 255 do
      SetPaletteColor(Color,Pal[Color].R,Pal[Color].G,Pal[Color].B);
  End;

{ - Быстрое копирование памяти  - }
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

{ - Быстрая отчистка памяти - }
Procedure ClearMemory( lvSeg:Word ); Assembler;
  Asm
    mov es,[lvSeg]
    xor di,di
    db 66h; xor ax,ax
    mov cx,320*200/4
    rep;db 66h;stosw
  End;

{ - Закрашенный прямоугольник - }
Procedure Bar( X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        Scr[Y,X]:=Color;
  End;

{ - Вывод залитого пpямоугольника в экpанный буфеp - }
Procedure BarDB(X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,Y:Word;
  Begin
    For X:=X1 to X2 do
      For Y:=Y1 to Y2 do
        DoubleBuffer^[Y,X]:=Color;
  End;

{ - Вывод pамки в Double Buffer - }
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

{ - Вывод Экранного Буфера - }
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

{ - Загрузка картинки из Pic-файла - }
Procedure LoadPic( FileName:String; Var SB:TScreenBuffer; Var Pal:RGBPalette );
  Var F:File;
  Begin
    OpenFileRE(F,'Pic',FileName);
    BlockRead(F,SB,SizeOf(SB));
    BlockRead(F,Pal,SizeOf(Pal));
    Close(F);
  End;

{ - Запись картинки в Pic-файл - }
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