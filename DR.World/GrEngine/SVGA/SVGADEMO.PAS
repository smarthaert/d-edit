Uses DOS,CRT,SVGA;

Function AbsoluteTime:LongInt;
  Var Hour,Minute,Second,Sec100:Word;
  Begin
    GetTime( Hour,Minute,Second,Sec100 );
    AbsoluteTime:=((Hour*60+Minute)*60+Second*100)+Sec100;
  End;

Var SVGA_Info:PSVGA_InfoRec; BankSize:LongInt;

Procedure Put_Pixel( X,Y:Word; Color:Byte );
  Var VBank,VAddr:Word; Address:LongInt;
  Begin
    Address:=X+LongInt(Y)*640;
    VBank:=Address div BankSize;
    VAddr:=Address mod BankSize;
    Set_Bank(VBank);
    Mem[$A000:VAddr]:=ScreenBuffer[Y]^[X];
  End;

Procedure _Line( X1,Y1,X2,Y2:Word; Color:Byte );
  Var X,dX,dY:Word;
  Begin
    dX:=X2-X1;
    dY:=Y2-Y1;
    For X:=X1 to X2 do
      Put_Pixel(X,Y1+(LongInt(X)*dY) div dX,Color);
  End;

Procedure ShowScreenBuffer;
  Var X,Y:Word;
  Begin
    For X:=0 to 639 do
      For Y:=0 to 479 do
        Put_Pixel(X,Y,ScreenBuffer[Y]^[X]);
  End;

Var X,Y,I:Word; BeginTime,EndTime:LongInt;
Begin
  Init_SVGA($101);
  New(SVGA_Info);
  Get_SVGA_Info($101,SVGA_Info);
  BankSize:=SVGA_Info^.BankSize;
  If BankSize = 0 then BankSize:=$10000;
  InitScreenBuffer;
  BeginTime:=AbsoluteTime;
  For X:=0 to 639 do
    _Line(0,0,639,Random(480),Random(256));
  ShowScreenBuffer;
  EndTime:=AbsoluteTime;
  Dispose(SVGA_Info);
  ReadKey;
  Init_Text;
  CloseScreenBuffer;
  Writeln(EndTime-BeginTime);
  ReadKey;
End.