Procedure Init_MCGA; Assembler;
  Asm
    Mov AX,0013h
    Int 10h
  End;

Procedure Close_MCGA; Assembler;
  Asm
    Mov AX,0003h
    Int 10h
  End;

Procedure Enable_Refrech; Assembler;
  Asm
    Mov AX,1200h
    Mov BL,36h
    Int 10h
  End;

Procedure Disable_Refrech; Assembler;
  Asm
    Mov AX,1201h
    Mov BL,36h
    Int 10h
  End;

Procedure Fill_Screen; Assembler;
  Asm
    Mov AX,SegA000
    Mov ES,AX
    Mov DL,100
    Xor DI,DI
  @@RULES:
    Mov CX,160
    Mov AX,000Fh
    Rep Stosw
    Mov CX,160
    Mov AX,0F00h
    Rep Stosw
    Dec DL
    JNZ @@RULES;
  End;

Procedure Set_Color( Num,R,G,B:Byte ); Assembler;
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

Procedure Red_Palette;
  Var I:Byte;
  Begin
    For I:=0 to 63 do
      Begin
        Set_Color($00+I*2,I,0,0);
        Set_Color($00+I*2+1,I,0,0);
        Set_Color($FF-I*2-1,I,0,0);
        Set_Color($FF-I*2,I,0,0);
      End;
  End;

Procedure Flash_Palette;
  Var I,G,B:Byte;
  Begin
    For I:=0 to 31 do
      Begin
        Set_Color($00+I*2,  I,0,0);
        Set_Color($00+I*2+1,I,0,0);
        Set_Color($FF-I*2-1,I,0,0);
        Set_Color($FF-I*2,  I,0,0);
      End;
    For I:=32 to 63 do
      Begin
        G:=(I-32)*2+1; B:=Ord(I>48)*(I-48)*4+1;
        Set_Color($00+I*2,  I,G,B);
        Set_Color($00+I*2+1,I,G,B);
        Set_Color($FF-I*2-1,I,G,B);
        Set_Color($FF-I*2,  I,G,B);
      End;
  End;

Procedure Flame_Palette;
  Var I:Byte;
  Begin
    For I:=0 to 63 do
      Begin
        Set_Color(I,0,0,(32-Abs(32-I)) Shr 2);
        Set_Color(64+I,I,0,0);
        Set_Color(128+I,63,I,I Shr 1);
        Set_Color(128+64+I,63,63,32+I Shr 1);
      End;
  End;

Type TScreenBuffer = Array [0..63999] of Byte;
     PScreenBuffer = ^TScreenBuffer;

Var SB : PScreenBuffer;
    Scr : TScreenBuffer Absolute $0A000:0000;

{ = = = Вывод Экранного Буфера = = = }
Procedure Show; Assembler;
  Asm
    Mov  AX,SegA000
    Mov  ES,AX
    Push DS
    Xor  DI,DI
    LDS  SI,SB
    Mov  CX,32000
    Rep  Movsw
    Pop  DS
  End;

{ = = = Сглаживание Экрана = = = }
Procedure Soft_Picture; Assembler;
  Asm
    LES  DI,SB
    Add  DI,320
    Mov  CX,63360
  @@L:
    Xor  BX,BX
    Xor  AH,AH
    Mov  AL,ES:[DI+1]
    Add  BX,AX
    Mov  AL,ES:[DI-1]
    Add  BX,AX
    Mov  AL,ES:[DI+320]
    Add  BX,AX
    Mov  AL,ES:[DI-320]
    Add  BX,AX
    Shr  BX,2
    Mov  ES:[DI],BL
    Inc  DI
    Loop @@L
  End;

{ = = = Огненное Сглаживание Экрана = = = }
Procedure Flame_Picture; Assembler;
  Asm
    LES  DI,SB
    Add  DI,320
    Mov  CX,63680
   @@L:
    Xor  BX,BX
    Xor  AH,AH
    Mov  AL,ES:[DI]
    Add  BX,AX
    Add  BX,AX
    Mov  AL,ES:[DI+1]
    Add  BX,AX
    Mov  AL,ES:[DI-1]
    Add  BX,AX
    Mov  AL,ES:[DI-320]
    Add  BX,AX
    Add  BX,AX
    Add  BX,AX
    Add  BX,AX
    Shr  BX,3
    Mov  ES:[DI-320],BL
    Inc  DI
    Loop @@L
  End;

Procedure Flame_Picture_2; Assembler;
  Asm
    LES  DI,SB
    Add  DI,320
    Mov  CX,63360
   @@L:
    Xor  BX,BX
    Xor  AH,AH
    Mov  AL,ES:[DI+320]
    Add  BX,AX
    Add  BX,AX
    Mov  AL,ES:[DI+321]
    Add  BX,AX
    Mov  AL,ES:[DI+319]
    Add  BX,AX
    Mov  AL,ES:[DI-320]
    Add  BX,AX
    Add  BX,AX
    Mov  AL,ES:[DI]
    Add  BX,AX
    Add  BX,AX
    Add  BX,2
    Shr  BX,3
    Mov  ES:[DI],BL
    Inc  DI
    Loop @@L
  End;

{ = = = Инициализация = = = }
Procedure Init_Demo;
  Begin
    Init_MCGA;
    Randomize;
    New(SB);
    FillChar(SB^,64000,0);
  End;

{ = = = Выход = = = }
Procedure Close_Demo;
  Begin
    While KeyPressed do ReadKey;
    Dispose(SB);
    Close_MCGA;
  End;

{ = = = Гашение Экрана = = = }
Procedure Full_Soft_Picture( Count:Byte );
  Var I:Byte;
  Begin
    FillChar(SB^,320,0);
    FillChar(SB^[63680],320,0);
    For I:=1 to Count do
      Begin
        Soft_Picture;
        Soft_Picture;
        Show;
      End;
  End;

{ = = = Червячок = = = }
 Type
   Worm = Object
     X,Y:Word;
     Constructor Init(_X,_Y:Word);
     Procedure Run;
   End;

  Constructor Worm.Init;
    Begin
      X:=_X; Y:=_Y;
    End;

  Procedure Worm.Run;
    Var I,J:Byte;
    Begin
      X:=X+Random(3)-1;
      Y:=Y+Random(3)-1;
      If X>310 then X:=310;
      If X<10 then X:=10;
      If Y>190 then Y:=190;
      If Y<10 then Y:=10;
      For I:=0 to 2 do
	For J:=0 to 2 do
	  SB^[(Y+I)*320+(X+J)]:=255;
    End;
