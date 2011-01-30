{$G+}
Unit MCGADemo;

Interface

 Uses Gr_MCGA,CRT;

 Var G : PScreenBuffer;
     ScrG : PScreenBuffer;

 Procedure RedPalette;
 Procedure FlashPalette;
 Procedure FlamePalette;
 Procedure SoftPicture; { - Сглаживание Экрана - }
 Procedure FlamePicture; { - "Огненное" Сглаживание Экрана - }
 Procedure FlamePicture2; { - "Огненное" Сглаживание Экрана 2 - }
{ MCGA-демка }
 Type TDemo = Object
   Constructor Init; { Инициализация }
   Procedure Step; { Один шаг вывода }
   Destructor Done; { Завершение }
   Procedure SetColor( Num,R,G,B:Byte );
 End;
 Procedure FullSoftPicture( Count:Byte ); { - Постепенное растворение экрана - }
{ - Вывод "огненного" червячка - }
 Type Worm = Object
   X,Y,XB,YB,Max:Word;
   Constructor Init(_XB,_YB,_Max:Word);
   Procedure Run;
 End;
{ - "FLAME" - }
 Type
   TFlame = Object(TDemo)
     Constructor Init;
     Destructor Done;
   End;

Implementation

 Procedure RedPalette;
   Var I:Byte;
   Begin
     For I:=0 to 63 do
       Begin
         SetPaletteColor64($00+I*2,I,0,0);
         SetPaletteColor64($00+I*2+1,I,0,0);
         SetPaletteColor64($FF-I*2-1,I,0,0);
         SetPaletteColor64($FF-I*2,I,0,0);
       End;
   End;

 Procedure FlashPalette;
   Var I,G,B:Byte;
   Begin
     For I:=0 to 31 do
       Begin
         SetPaletteColor64($00+I*2,  I,0,0);
         SetPaletteColor64($00+I*2+1,I,0,0);
         SetPaletteColor64($FF-I*2-1,I,0,0);
         SetPaletteColor64($FF-I*2,  I,0,0);
       End;
     For I:=32 to 63 do
       Begin
         G:=(I-32)*2+1; B:=Ord(I>48)*(I-48)*4+1;
         SetPaletteColor64($00+I*2,  I,G,B);
         SetPaletteColor64($00+I*2+1,I,G,B);
         SetPaletteColor64($FF-I*2-1,I,G,B);
         SetPaletteColor64($FF-I*2,  I,G,B);
       End;
   End;

 Procedure FlamePalette;
   Var I:Byte;
   Begin
     For I:=0 to 63 do
       Begin
         SetPaletteColor64(I,0,0,(32-Abs(32-I)) Shr 2);
         SetPaletteColor64(64+I,I,0,0);
         SetPaletteColor64(128+I,63,I,I Shr 1);
         SetPaletteColor64(128+64+I,63,63,32+I Shr 1);
       End;
   End;

 { - Сглаживание Экрана - }
 Procedure SoftPicture; Assembler;
   Asm
     LES  DI,DoubleBuffer
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

 { - "Огненное" Сглаживание Экрана - }
 Procedure FlamePicture; Assembler;
   Asm
     LES  DI,DoubleBuffer
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

 { - "Огненное" Сглаживание Экрана 2 - }
 Procedure FlamePicture2; Assembler;
   Asm
     LES  DI,DoubleBuffer
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

 { - Инициализация MCGA-демки - }
 Constructor TDemo.Init;
   Begin
     InitMCGA;
     Randomize;
     New(DoubleBuffer);
     FillChar(DoubleBuffer^,64000,0);
     G:=DoubleBuffer;
     ScrG:=@Scr;
   End;

 { - Один шаг вывода - }
 Procedure TDemo.Step;
   Begin
     Show;
   End;

 Procedure TDemo.SetColor( Num,R,G,B:Byte );
   Begin
     SetPaletteColor64(Num,R,G,B);
   End;

 { - Выход из MCGA-демки - }
 Destructor TDemo.Done;
   Begin
     While KeyPressed do ReadKey;
     Dispose(DoubleBuffer);
     DoneMCGA;
   End;

{ - Постепенное растворение экрана - }
 Procedure FullSoftPicture( Count:Byte );
   Var I:Byte;
   Begin
     FillChar(DoubleBuffer^,320,0);
     FillChar(DoubleBuffer^[199],320,0);
     For I:=1 to Count do
       Begin
         SoftPicture;
         SoftPicture;
         Show;
       End;
   End;

 { - Вывод "огненного" червячка - }
 Constructor Worm.Init;
   Begin
     X:=_XB; Y:=_YB; Max:=_Max; XB:=_XB; YB:=_YB;
   End;

 Procedure Worm.Run;
   Var I,J:Byte;
   Begin
     X:=X+Random(3)-1;
     Y:=Y+Random(3)-1;
     If X>(XB+Max) then X:=XB+Max;
     If X<(XB-Max) then X:=XB-Max;
     If Y>(YB+Max) then Y:=YB+Max;
     If Y<(YB-Max) then Y:=YB-Max;
     For I:=0 to 2 do
       For J:=0 to 2 do
	 DoubleBuffer^[Y+I,X+J]:=255;
   End;

 Constructor TFlame.Init;
   Begin
     Inherited Init;
     FlamePalette;
   End;

 Destructor TFlame.Done;
   Begin
     FullSoftPicture(50);
     Inherited Done;
   End;

End.