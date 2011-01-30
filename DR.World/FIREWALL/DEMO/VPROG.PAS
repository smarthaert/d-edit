Uses CRT,Video,Clr_Nat,Paths;

Const
  Nation=5;

Var
  S:String[1];
  I,J,K,L:Word;
  Buf:PScrBuf;
  Tanks:Array[1..8] of PNationSprite;
  Pusto:PStdSprite;
Begin
  NewPaths('..\');
  New(Buf);
  For I:=1 to 8 do
    Begin
       Str(I,S);
       New(Tanks[I],LoadHSprite('_Tank'+S+'.SPR'));
    End;
  New(Pusto,LoadHSprite('_Pusto.SPR'));
  InitMCGA;
  CurScr:=Buf;
  ClearScreen(0);
  I:=1;
  L:=0;
  Repeat
    For J:=4 to 25 do
      For K:=9 to 11 do
        Pusto^.PutXY(10*J,10*K);
    If (I=3)Or(I=7) then
      Begin
         NoSound;
         If I=3 then
           Tanks[I]^.PutNatCenter(105+L,105,Nation)
           Else
           Tanks[I]^.PutNatCenter(205-L,105,Nation);
         Inc(L);
         If L>100 then
           Begin
              L:=0;
              Inc(I);
              If I>8 then I:=1;
           End;
      End
      Else
      Begin
         Sound(1000);
         Tanks[I]^.PutNatCenter(105+((I+1)Shr 2 And 1)*100,105,Nation);
         Inc(I);
         If I>8 then I:=1;
      End;
    WaitRetrace;
    ScrCopy(Buf,Screen);
  Until KeyPressed;
  NoSound;
  ReadKey;
  DoneMCGA;
  For I:=1 to 8 do
    Dispose(Tanks[I],Done);
  Dispose(Pusto,Done);
  Dispose(Buf);
End.