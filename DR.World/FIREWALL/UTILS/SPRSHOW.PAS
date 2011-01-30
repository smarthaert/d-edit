Uses Crt,DOS,Graph;

{$I-}

Type
  TByteArray = Array [0..$FFFE] of Byte;
  PByteArray = ^TByteArray;

Const
  OpenFile : Boolean = False;
  BufSize  : Word = 0;
  Buf      : PByteArray = nil;

Var F:File;

Procedure InitMCGA;Assembler;
Asm
  Mov AX,0013h
  Int 10h
End;

Procedure DoneMCGA;Assembler;
Asm
  Mov AX,0003h
  Int 10h;
End;

Var ScreenBuffer : Array [0..199,0..319] of Byte Absolute $0A000:$00000;

Procedure ClearScreen; Assembler;
  Asm
    Mov AX,SegA000
    Mov ES,AX
    Xor DI,DI
    Mov CX,32000
    Xor AX,AX
    Rep Stosw
  End;

Procedure RuntimeError( Message:String );
  Begin
    DoneMCGA;
    If OpenFile then Close(F);
    If Buf <> nil then FreeMem(Buf,BufSize);
    Writeln('Runtime Error : ',Message);
    Halt(1);
  End;

Var
  Size:PointType;
  FSize:Word;

Function TestParam:Boolean;
  Var
    S:PathStr;
Begin
   If ParamCount<>1 then
     Begin
        TestParam:=False;
        Exit;
     End;
   TestParam:=True;
End;

Procedure AssignFile;
  Var
    S:PathStr;
Begin
   S:=FSearch(ParamStr(1),'');
   If S='' then RunTimeError('File '+ParamStr(1)+' not found !');
   Assign(F,S);
End;

Function LoadFile:Boolean;
  Var
    FTrueSize,Res:Word;
Begin
   Reset(F,1);
   If IOResult<>0 then RuntimeError('Access denied to spritefile !');
   OpenFile:=True;
   FTrueSize:=FileSize(F);
   If FTrueSize<7 then RuntimeError('Spritefile too small !');
   BlockRead(F,FSize,2,Res);
   If (FTrueSize<>FSize+2) Or (Res<>2) then RunTimeError('Wrong Header !');
   BlockRead(F,Size,4,Res);
   If (FTrueSize-6<>Size.X*Size.Y)Or(Res<>4) then RunTimeError('Wrong Header !');
   FSize:=FTrueSize-6;
   BufSize:=FSize;
   GetMem(Buf,BufSize);
   BlockRead(F,Buf^,FSize,Res);
   Close(F);
   OpenFile:=False;
   If Res<>FSize then RuntimeError('Can''t read Spritefile !');
End;

Procedure ShowSprite;
  Var Key:Char; MaxScale,Scale,X,Y,_X,_Y:Word;
  Begin
    If ((Size.X=0) Or (Size.Y=0)) then RuntimeError('Sprite size = 0 !');
    MaxScale:=320 div Size.X;
    Scale:=200 div Size.Y;
    If Scale < MaxScale then MaxScale:=Scale;
    Scale:=MaxScale;
    If Scale = 0 then Scale := 1;
    Repeat
      For X:=0 to (Size.X-1) do
        For Y:=0 to (Size.Y-1) do
          For _X:=0 to (Scale-1) do
            For _Y:=0 to (Scale-1) do
              ScreenBuffer[Y*Scale+_Y,X*Scale+_X] := Buf^[Y*Size.X+X];
      Key:=ReadKey;
      Case Key of
       '+': If Scale < MaxScale then Inc(Scale);
       '-': If Scale > 1 then Dec(Scale);
      End;
      ClearScreen;
    Until Key = #27;
  End;

Begin
   If TestParam then
     Begin
        AssignFile;
        LoadFile;
        InitMCGA;
        ShowSprite;
        DoneMCGA;
        FreeMem(Buf,FSize);
        Buf:=nil;
     End
     Else
     Begin
        Writeln;
        Writeln('Sprites Viewer ver 1.0');
        Writeln('By Lion Studio');
        Writeln('Usage :');
        Writeln('SPRSHOW spritefile');
        Writeln;
     End;
End.