Unit SVGA;

Interface

  Type
    PSVGA_InfoRec = ^SVGA_InfoRec;
    SVGA_InfoRec = Record
      ModeAttrs:Word;   { bit fields: mode characteristics }
      WinAAttrs:Byte;   { bit fields: windowing system characteristics }
      WinBAttrs:Byte;   { bit fields: windowing system characteristics }
      WinGran:Word;     { window granularity, in Kbytes }
      WinSize:Word;     { window size, in KB }
      WinASeg:Word;     { window A segment address }
      WinBSeg:Word;     { window B segment address }
      WinFnPtr:Pointer; { far address of window-handling function }
      ScanLineSiz:Word; { bytes per scan line }
     { 컴컴컴컴컴컴컴컴� Extended/optional information; present only }
     {                    when rModeAttrs bit 1 is 1. }
      HorizRes:Word;    { horizontal resolution, in pixels or char cells }
      VertRes:Word;     { vertical resolution, in pixels or char cells }
      CharWide:Byte;    { character cell width }
      CharHigh:Byte;    { character cell height }
      PlaneCnt:Byte;    { number of video memory planes }
      BitsPerPel:Byte;  { number of bits per pixel }
      BankCnt:Byte;     { number of video memory banks }
      MemModel:Byte;    { memory model type code }
      BankSize:Byte;    { video memory bank size, in Kbytes }
      Reserved:Array [1..227] of Byte;
    End;

  Function Get_SVGA_Info( Mode:Word; SVGA_Info:PSVGA_InfoRec ):Byte;

  Procedure Init_SVGA( Mode:Word );

  Procedure Init_Text;

  Procedure Set_Bank( Bank:Word );

  Procedure Fill_Bank( Color:Byte );

  Const Cur_Bank:Word = 0;

  Procedure PutPixel( X,Y:Word; Color:Byte );

  Procedure Line( X1,Y1,X2,Y2:Word );

  Type TScreenBlock = Array [0..639] of Byte;
       PScreenBlock = ^TScreenBlock;

  Var ScreenBuffer : Array [0..479] of PScreenBlock;

  Procedure InitScreenBuffer;

  Procedure CloseScreenBuffer;

Implementation

  Function Get_SVGA_Info( Mode:Word; SVGA_Info:PSVGA_InfoRec ):Byte; Assembler;
    Asm
      Mov AX,4F01h
      Mov CX,Mode
      LES DI,SVGA_Info;
      Int 10h
      Mov AL,AH
    End;

  Procedure Init_SVGA( Mode:Word ); Assembler;
    Asm
      Mov AX,4F02h
      Mov BX,Mode
      Int 10h
    End;

  Procedure Init_Text; Assembler;
    Asm
      Mov AX,0003h
      Int 10h
    End;

  Procedure Set_Bank( Bank:Word ); Assembler;
    Asm
      Mov AX,4F05h
      Mov BX,0000h
      Mov DX,Bank
      Int 10h
    End;

  Procedure Fill_Bank( Color:Byte ); Assembler;
    Asm
      Mov AX,SegA000
      Mov ES,AX
      Mov CX,$8000;
      Mov AL,Color
      Mov AH,AL
      Xor DI,DI
      Rep Stosw
    End;

  Procedure PutPixel( X,Y:Word; Color:Byte ); Assembler;
    Asm
      Mov AX,SegA000
      Mov ES,AX
      Mov AX,Y
      Mov BX,640
      Mul BX
      Mov BX,1000h
      Div BX
      Mov SI,DX { AX:=Video_Bank SI:=Video_Address }
      Add SI,X
      Cmp AX,Cur_Bank
      JE  @@No_Set_Bank
      Mov DX,AX         { Set Bank }
      Mov Cur_Bank,DX
      Mov AX,4F05h
      Mov BX,0000h
      Int 10h
     @@No_Set_Bank:
      Mov AL,Color     { PutPixel }
      Mov ES:[SI],AL
    End;

  Procedure Line( X1,Y1,X2,Y2:Word );
    Var _Y,_X,X,Y:Word;
    Begin
      _Y:=Y2-Y1;
      _X:=X2-X1;
      Asm
        Mov AX,SegA000  { ES = Video Segment }
        Mov ES,AX
        Mov DI,X1       { DI = X }
       @@X:
        Mov AX,DI       { AX = Y }
        Mov BX,_Y
        Mul BX
        Mov BX,_X
        Div BX
        Mov BX,640      { AX = Video Bank }
        Mul BX
        Mov BX,1000h
        Div BX
        Mov SI,DX       { SI = Video Address }
        Add SI,DI
        Cmp AX,Cur_Bank { If AX = Cur_Bank then No_Set_Bank }
        JE  @@No_Set_Bank
        Mov DX,AX       { Set Bank }
        Mov Cur_Bank,DX
        Mov AX,4F05h
        Mov BX,0000h
        Int 10h
       @@No_Set_Bank:
        Mov AL,15       { Put Pixel }
        Mov ES:[SI],AL
        Inc DI
        Cmp DI,X2       { Next Pixel }
        JNE @@X
      End;
    End;

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

End.