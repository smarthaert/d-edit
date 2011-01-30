Unit Video;

Interface

Uses DOS,Paths;

Const
  MaxSpriteSize=200;

 Type
   TPoint=
     Record
       X,Y:Word;
     End;
   TScrBuf = Array [0..199,0..319] of Byte;
   PScrBuf = ^TScrBuf;
   SpriteSize=1..MaxSpriteSize;
   PStdSprite=^TStdSprite;
   TStdSprite=
     Object
       XSize,YSize:SpriteSize;
       Pic:Pointer;
       DispPic:Boolean;
       Constructor Init(XS,YS:SpriteSize);
       Constructor SetPointer(XS,YS:SpriteSize; Buf:Pointer);
       Constructor LoadHSprite(FileName:PathStr);
       Destructor Done;Virtual;
       Procedure PutXY(X,Y:Word);Virtual;
       Procedure PutCenterXY(X,Y:Word);Virtual;
       Procedure Clear(Col:Byte);
     End;
   PMaskSprite=^TMaskSprite;
   TMaskSprite=
     Object(TStdSprite)
       Procedure PutXY(X,Y:Word);Virtual;
     End;

 Var
   Screen:PScrBuf;
   CurScr:PScrBuf;

 Procedure InitMCGA;
 Procedure DoneMCGA;
 Procedure ScrCopy( ScrBuf1,ScrBuf2:PScrBuf );
 Procedure ClearScreen( Color:Byte );
 Procedure SetRGBPalette( NR,R,G,B:Byte );
 Procedure GetRGBPalette( NR:Byte; Var R,G,B:Byte );
 Procedure WaitRetrace;

{ ---=== Вывод точки в видеобуфер ===--- }
 Procedure PutPixel( X,Y:Word; Col:Byte );

{ ---=== Вывод прямоугольника в видеобуфер ===--- }
 Procedure Rectangle( X1,Y1,X2,Y2:Word; Col:Byte );

{ ---=== Вывод залитого прямоугольника в видеобуфер ===--- }
 Procedure Box( X1,Y1,X2,Y2:Word; Col:Byte );

 Function KeyPressed:Boolean;
 Procedure ClearKbdBuf;

Implementation

 Procedure InitMCGA;Assembler;
 Asm
   Mov AX,0013h
   Int 10h
 End;

 Procedure DoneMCGA;Assembler;
 Asm
   Mov AX,0003h
   Int 10h
 End;

 Procedure ScrCopy( ScrBuf1,ScrBuf2:PScrBuf ); Assembler;
 Asm
   Push DS
   Mov  CX,32000
   LDS  SI,ScrBuf1
   LES  DI,ScrBuf2
   Rep  Movsw
   Pop  DS
 End;

 Procedure ClearScreen( Color:Byte ); Assembler;
   Asm
     LES DI,CurScr
     Mov CX,32000
     Mov AH,Color
     Mov AL,AH
     Rep Stosw
   End;

 Procedure SetRGBPalette(NR,R,G,B:Byte);
 Begin
   Port[$3C8]:=NR;
   Port[$3C9]:=R;
   Port[$3C9]:=G;
   Port[$3C9]:=B;
 End;

 Procedure GetRGBPalette(NR:Byte; Var R,G,B:Byte);
 Begin
   Port[$3C8]:=NR;
   R:=Port[$3C9];
   G:=Port[$3C9];
   B:=Port[$3C9];
 End;

 Procedure WaitRetrace;
 Begin
   Asm
     Mov DX,3DAh
   @@1:
     In AL,DX
     Test AL,8
     JZ @@1
   @@2:
     In AL,DX
     Test AL,8
     JNZ @@2
   End;
 End;

 { ---=== Вывод точки в видеобуфер ===--- }
 Procedure PutPixel( X,Y:Word; Col:Byte ); Assembler;
   Asm
     LES DI,CurScr
     Mov SI,Y
     Mov AX,Y
     Shl SI,8
     Shl AX,6
     Add SI,AX
     Add SI,X
     Mov AL,Col
     Add DI,SI
     STOSB
   End;

 { ---=== Вывод прямоугольника в видеобуфер ===--- }
 Procedure Rectangle(X1,Y1,X2,Y2:Word;Col:Byte);Assembler;
 Asm
    LES DI,CurScr
    Mov AX,320
    Mov SI,Y2
    Cmp SI,Y1
    JB @@Weiter3
    Mul Y1
    Mov BX,Y2
    Sub BX,Y1
    JMP @@Weiter2
    @@Weiter3:
    Mul Y2
    Mov BX,Y1
    Sub BX,Y2
    @@Weiter2:
    Dec BX
    Mov SI,X2
    Cmp SI,X1
    JB @@Weiter4
    Add AX,X1
    Mov CX,X2
    Sub CX,X1
    JMP @@Weiter5
    @@Weiter4:
    Add AX,X2
    Mov CX,X1
    Sub CX,X2
    @@Weiter5:
    Inc CX
    Add DI,AX {[!]}
    Mov AL,Col
    Push DI
    Push CX
    Rep STOSB
    Pop CX
    Cmp BX,0
    JZ @@Weiter
    Pop DI
    Add DI,320
    Push DI
    @@Repeat:
            STOSB
            Add DI,CX
            Sub DI,2
            STOSB
            Dec BX
            JZ @@Weiter
            Pop DI
            Add DI,320
            Push DI
    JMP @@Repeat
    @@Weiter:
    Pop DI
    Add DI,320
    Rep STOSB
 End;

 Procedure Box(X1,Y1,X2,Y2:Word;Col:Byte);Assembler;
 Asm
    LES DI,CurScr
    Mov AX,320
    Mov SI,Y2
    Cmp SI,Y1
    JB @@Weiter3
    Mul Y1
    Mov BX,Y2
    Sub BX,Y1
    JMP @@Weiter2
    @@Weiter3:
    Mul Y2
    Mov BX,Y1
    Sub BX,Y2
    @@Weiter2:
    Mov SI,X2
    Cmp SI,X1
    JB @@Weiter4
    Add AX,X1
    Mov CX,X2
    Sub CX,X1
    JMP @@Weiter5
    @@Weiter4:
    Add AX,X2
    Mov CX,X1
    Sub CX,X2
    @@Weiter5:
    Add DI,AX
    Push DI
    Inc BX
    Inc CX
    Push CX
    Mov AL,Col
    @@Repeat:
            Rep STOSB
            Dec BX
            JZ @@Weiter
            Pop CX
            Pop DI
            Add DI,320
            Push DI
            Push CX
    JMP @@Repeat
    @@Weiter:
    Pop DI
    Pop CX
 End;

 Function KeyPressed:Boolean;Assembler;        (*About 21 times faster than crt's keypressed*)
 Asm
    Mov  AX,40h
    Mov  ES,AX
    Mov  DX,ES:[1Ah]
    Mov  BX,ES:[1Ch]
    Xor  AX,AX
    Cmp  DX,BX
    JE   @@End
    Mov  AL,1
  @@End:
 End;

 {Clear keyboard buffer}
 Procedure ClearKbdBuf;Assembler;
 Asm
    Mov  AX,40h
    Mov  ES,AX
    Mov  AX,ES:[1Ch]
    Mov  ES:[1Ah],AX
 End;

 { * * * TStdSprite * * * }

 Constructor TStdSprite.SetPointer;
 Begin
    DispPic:=False;
    XSize:=XS;
    YSize:=YS;
    Pic:=Buf;
 End;

 Constructor TStdSprite.Init;
 Begin
    DispPic:=True;
    XSize:=XS;
    YSize:=YS;
    GetMem(Pic,XSize*YSize);
 End;

 Constructor TStdSprite.LoadHSprite;
   Var
     F:File;
     S:PathStr;
     WX,WY:Word;
 Begin
    DispPic:=True;
    Pic:=Nil;
    S:=FSearch(FileName,DataPath);
    If S='' then Exit;
    Assign(F,S);
    Reset(F,1);
    Seek(F,2);
    BlockRead(F,WX,2);
    BlockRead(F,WY,2);
    XSize:=WX;
    YSize:=WY;
    GetMem(Pic,XSize*YSize);
    BlockRead(F,Pic^,XSize*YSize);
    Close(F);
 End;

 Destructor TStdSprite.Done;
 Begin
    If (Pic<>Nil)And DispPic then FreeMem(Pic,XSize*YSize);
    Pic:=Nil;
 End;

 Procedure TStdSprite.PutXY;
   Var
     P,PS:Pointer;
     XS,YS:Word;
 Begin
    If Pic=Nil then Exit;
    P:=Pic;
    PS:=CurScr;
    XS:=XSize;
    YS:=YSize;
    Asm
      Mov  DX,Y
      Mov  CX,X
      Mov  AX,DX
      Shl  DX,8
      Shl  AX,6
      Add  DX,AX
      Add  DX,CX
      Mov  AX,YS
      Mov  BX,XS
      Push DS
      LES  CX,PS
      LDS  SI,P
      Add  DX,CX
     @@Line:
      Mov  DI,DX
      Mov  CX,BX
      Rep  Movsb
      Add  DX,320
      Dec  AX
      JNZ  @@Line
      Pop  DS
    End;
 End;

 Procedure TStdSprite.Clear;
 Begin
    If Pic=Nil then Exit;
    FillChar(Pic^,XSize*YSize,Col);
 End;

 Procedure TStdSprite.PutCenterXY;
 Begin
    PutXY(X+(XSize Shr 1),Y+(YSize Shr 1));
 End;

 Procedure TMaskSprite.PutXY;
   Var
     P,PS:Pointer;
     XS,YS:Word;
 Begin
    If Pic=Nil then Exit;
    P:=Pic;
    PS:=CurScr;
    XS:=XSize;
    YS:=YSize;
    Asm
      Mov  DX,Y
      Mov  CX,X
      Mov  AX,DX
      Shl  DX,8
      Shl  AX,6
      Add  DX,AX
      Add  DX,CX
      Mov  BX,YS
      Mov  CX,XS
      Push DS
      LES  AX,PS
      LDS  SI,P
      Add  DX,AX
      Mov  AH,0FFh
     @@Line:
      Mov  DI,DX
      Push CX
     @@Pix:
      Mov AL,DS:[SI]
      Cmp AL,AH
      JE @@NoPut
      Mov ES:[DI],AL
     @@NoPut:
      Inc SI
      Inc DI
      Loop @@Pix
      Pop  CX
      Add  DX,320
      Dec  BX
      JNZ  @@Line
      Pop  DS
    End;
 End;

Begin
   Screen:=Ptr(SegA000,$00000);
   CurScr:=Screen;
End.