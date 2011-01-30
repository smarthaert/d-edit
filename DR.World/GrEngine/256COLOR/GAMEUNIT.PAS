{ ษอัอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออัอป }
{ บ ณ                ---=== G A M E U N I T ===---                    ณ บ }
{ บ ณ                                                                 ณ บ }
{ บ ณ        Roman International Explorer 21:32:48 22-06-99           ณ บ }
{ ศอฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออฯอผ }
Unit GameUnit;

Interface

 { = = = VIDEO BANK MANAGER = = = }

  Const _Current_SVGA_Video_Bank_ : Word = $0FFFF;
  Procedure _Set_SVGA_Video_Bank_( _Video_Bank_ : Word );

 { = = = VIDEO BUFFER MANAGER = = = }
 Type
   TScreenBlock = Array [0..639] of Byte;
   PScreenBlock = ^TScreenBlock;
   TScreenArray = Array [0..479] of PScreenBlock;
   TScreenBuffer = Object
     Data : TScreenArray;
     Constructor Init;
     Destructor Done;
     Procedure Draw;
   End;

 Var ScreenBuffer:TScreenBuffer;

Implementation

  Procedure _Set_SVGA_Video_Bank_( _Video_Bank_ : Word );
   Begin
     If _Video_Bank_ <> _Current_SVGA_Video_Bank_ Then
       Begin
         _Current_SVGA_Video_Bank_:=_Video_Bank_;
         Asm
           Mov AX,4F05h
           Xor BX,BX
           Mov DX,_Current_SVGA_Video_Bank_
           Int 10h
         End;
       End;
   End;

  Constructor TScreenBuffer.Init;
    Var Counter:Word;
    Begin
      Asm
        Mov AX,4F02h
        Mov BX,101h
        Int 10h
      End;
      For Counter:=0 to 479 do New(Data[Counter]);
    End;

  Destructor TScreenBuffer.Done;
    Var Counter:Word;
    Begin
      Asm
        Mov AX,0003h
        Int 10h
      End;
      For Counter:=0 to 479 do Dispose(Data[Counter]);
    End;

  Procedure TScreenBuffer.Draw;
    Var Size,Bank,LineNumber,Address : Word;
        P : Pointer;
    Begin
      For LineNumber:=0 to 479 do
      Begin
        P:=Data[LineNumber];
        Bank:=LongInt(LineNumber)*640 div $10000;
        Address:=LongInt(LineNumber)*640 mod $10000;
        If Address < ($10000-640) then
          Begin
            _Set_SVGA_Video_Bank_(Bank);
            Asm
              Mov AX,SegA000
              Mov ES,AX
              Mov DI,Address
              Mov CX,320
              Push DS
              LDS SI,P
              Rep Movsw
              Pop DS
            End;
          End
        Else
          Begin
            _Set_SVGA_Video_Bank_(Bank);
            Size:=($10000-Address) div 2;
            Asm
              Mov AX,SegA000
              Mov ES,AX
              Mov DI,Address
              Mov CX,Size
              Push DS
              LDS SI,P
              Rep Movsw
              Pop DS
            End;
            _Set_SVGA_Video_Bank_(Bank+1);
            P:=@Data[LineNumber]^[Size*2];
            Size:=320-Size;
            Asm
              Mov AX,SegA000
              Mov ES,AX
              Xor DI,DI
              Mov CX,Size
              Push DS
              LDS SI,P
              Rep Movsw
              Pop DS
            End;
          End;
      End;
    End;

End.