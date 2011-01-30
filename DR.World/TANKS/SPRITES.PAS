Uses Crt,Mcga,_Speed;

Type Sprite=Array [0..15] of Byte;

Var S:Sprite;

Procedure PutSprite;Far;
  Var P:Pointer; C:Byte; X,Y:Word;
  Begin
    P:=@S;
    X:=1; Y:=1;
    Asm
      Push DS
      Lds SI,P
      Les DI,ScreenBuffer
      Mov BX,Y
      Shl BX,8
      Mov CX,BX
      Mov AX,X
      Add BX,AX
      Shl BX,2
      Add BX,CX
      Add DI,BX
      Mov CL,4
     @@C:
      Mov DX,DS:[SI]
      Mov ES:[DI],DX
      Add SI,2
      Add DI,2
      Mov DX,DS:[SI]
      Mov ES:[DI],DX
      Add SI,2
      Add DI,318
      Dec CL
      JNZ @@C
      Pop DS
    End;
  End;

Var T:LongInt; C:Integer; X,Y:Integer;
Begin
  InitMCGA;
  InitScreenBuffer;
  For X:=0 to 319 do
    For Y:=0 to 199 do
      ScreenBuffer^[Y,X]:=0;
  For C:=0 to 15 do S[C]:=15;
  For C:=4 to 7 do S[C]:=2;
  T:=TestSpeed(PutSprite,1000000);
  ShowScreenBuffer;
  CloseScreenBuffer;
  CloseMCGA;
  Writeln(T);
  ReadKey;
End.
