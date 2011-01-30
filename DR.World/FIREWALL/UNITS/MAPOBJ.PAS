Unit MapObj;

Interface

Uses Video,SprMngr,UWorkScr;

Const
  etPusto=0;
  etWater=1;

Type
  PMapRec=^TMapRec;
  TMapRec=
    Record
      EarthType:Byte;
      SprNum:Word;
    End;

Const
  MapBlockRecSize=64000 div SizeOf(TMapRec);

Type
  PMapBlock=^TMapBlock;
  TMapBlock=
    Record
       Size:Word;
       Data:Array [0..MapBlockRecSize-1] of TMapRec;
    End;

Const
  MaxMapBlock=4;
  MapBlockDataSize=SizeOf(TMapRec)*MapBlockRecSize;
  MapBlockMinSize=SizeOf(TMapBlock)-MapBlockDataSize;
  MaxMapSizeSqr=MapBlockRecSize*MaxMapBlock;

Type
  PMap=^TMap;
  TMap=
    Object
      Block:Array [1..MaxMapBlock] of PMapBlock;
      MapSize:Word;
      NumBlocks:Byte;
      MiniMapSpr:PStdSprite;
      MiniMapScale:Integer;
      MiniMapOfs:Byte;
      Constructor Init(_Size:Word);
      Destructor Done;
      Procedure Draw(NP:Byte);
      Procedure RefreshMiniMap;
      Procedure DrawMiniMap;
      Function CalcScrMiniMapX(X:Integer):Integer;
      Function CalcScrMiniMapY(Y:Integer):Integer;
      Function CalcMiniMapScrX(X:Integer):Integer;
      Function CalcMiniMapScrY(Y:Integer):Integer;
      Procedure Clear;
      Procedure Generate;
      Procedure PutBrush(X,Y:Integer;_Size:Byte;ET:Byte);
      Function GetRec(X,Y:Word):PMapRec;
      Function OnMap(X,Y:Integer):Boolean;
      Function MouseMapX:Word;
      Function MouseMapY:Word;
      Procedure ScrollUp;
      Procedure ScrollDown;
      Procedure ScrollRight;
      Procedure ScrollLeft;
      Procedure MouseScroll;
      Procedure ZeroKeyScroll(Key:Char);
    End;

Function MaxMapSize:Word;

Var
  Map:TMap;

Implementation

Constructor TMap.Init;
  Var
    N:LongInt;
    K,M:Word;
Begin
   MapSize:=_Size;
   N:=MapSize*MapSize;
   NumBlocks:=0;
   While N>0 do
     Begin
        If N>MapBlockRecSize then
          M:=MapBlockRecSize
          Else
          M:=N;
        K:=M*SizeOf(TMapRec)+MapBlockMinSize;
        Inc(NumBlocks);
        GetMem(Block[NumBlocks],K);
        Block[NumBlocks]^.Size:=K;
        Dec(N,M);
     End;
   If MapSize>80 then
     MiniMapScale:=-((MapSize+79) div 80)
     Else
     MiniMapScale:=80 div MapSize;
   If MiniMapScale>0 then
     MiniMapOfs:=(80 Mod MapSize) div 2
     Else
     MiniMapOfs:=(80-(MapSize div (-MiniMapScale)))div 2;
   New(MiniMapSpr,Init(80,80));
   Clear;
End;

Destructor TMap.Done;
  Var I:Byte;
Begin
   Dispose(MiniMapSpr,Done);
   For I:=1 to NumBlocks do
     FreeMem(Block[I],Block[I]^.Size);
End;

Procedure TMap.Draw;
  Var
    X,Y:Byte;
    CurRec:PMapRec;
    Spr:PStdSprite;
Begin
   With SpriteManager do
     For X:=0 to 20 do
       For Y:=0 to 7 do
         Begin
            CurRec:=GetRec(X+1+ScrollX,Y+ScrollY+1+NP*8);
            Spr:=Nil;
            Case CurRec^.SprNum of
              0:Spr:=Pusto;
              1:Spr:=Water;
              Else
                Spr:=Water;
            End;
            If Spr<>Nil then Spr^.PutXY(WorkWinXS+X*10,WorkWinYS+Y*10);
         End;
End;

Procedure TMap.Clear;
  Var
    X,Y:Word;
    ClearRec:TMapRec;
Begin
   With ClearRec do
     Begin
        EarthType:=etPusto;
        SprNum:=0;
     End;
   For X:=1 to MapSize do
     For Y:=1 to MapSize do
       GetRec(X,Y)^:=ClearRec;
   ScrollX:=(MapSize-21) Div 2;
   ScrollY:=(MapSize-16) Div 2;
   RefreshMiniMap;
End;

Procedure TMap.Generate;
  Var
    X,Y,XS,YS:Integer;
    I:Word;
    ClearRec:TMapRec;
Begin
   Clear;
   With ClearRec do
     Begin
        EarthType:=etWater;
        SprNum:=1;
     End;
   {For I:=1 to MapSize*MapSize Div 20 do
     Begin
        X:=Random(MapSize)+1;
        Y:=Random(MapSize)+1;
        PutBrush(X,Y,1+Random(2),etWater);
     End;}
   X:=Random(MapSize)+1;
   Y:=Random(MapSize)+1;
   XS:=0;
   YS:=0;
   For I:=1 to MapSize*MapSize Div 20 do
     Begin
        If (Not OnMap(X,Y))Or(I Mod (80-Random(10))=0) then
          Begin
             X:=Random(MapSize)+1;
             Y:=Random(MapSize)+1;
          End
          Else
          Begin
             X:=X+(XS div 3);
             Y:=Y+(YS div 3);
          End;
        If XS>+7 then XS:=-6;
        If XS<-7 then XS:=+6;
        If YS>+7 then YS:=-6;
        If YS<-7 then YS:=+6;
        XS:=XS+Random(2)*2-1;
        YS:=YS+Random(2)*2-1;
        PutBrush(X,Y,2+Random(2),etWater);
     End;
   RefreshMiniMap;
End;

Function TMap.GetRec;
  Var
    L:LongInt;
    NB,NE:Word;
Begin
   L:=(X-1)+(Y-1)*MapSize;
   NB:=(L Div MapBlockRecSize)+1;
   NE:=L Mod MapBlockRecSize;
   GetRec:=@Block[NB]^.Data[NE];
End;

Procedure TMap.PutBrush;
  Procedure Put2(XN,YN:ShortInt);
    Var
      P:PMapRec;
      PSN:Word;
  Begin
     If Not OnMap(X+XN,Y+YN) then Exit;
     P:=GetRec(X+XN,Y+YN);
     PSN:=$FFFF;
     Case P^.EarthType of
       etPusto:PSN:=0;
       etWater:PSN:=1;
     End;
     If PSN=$FFFF then Exit;
     With P^ do
       Begin
          SprNum:=PSN;
       End;
  End;

  Procedure Put1(XN,YN:ShortInt);
  Begin
     If Not OnMap(X+XN,Y+YN) then Exit;
     GetRec(X+XN,Y+YN)^.EarthType:=ET;
  End;

  Var
    I,J:ShortInt;
Begin
   For I:=-_Size to _Size do
     For J:=-_Size to _Size do
       Put1(I,J);
   For I:=-_Size to _Size do
     For J:=-_Size to _Size do
       Put2(I,J);
End;

Function TMap.OnMap;
Begin
   If
     (X>MapSize)Or
     (X<1)Or
     (Y>MapSize)Or
     (Y<1) then
     OnMap:=False
     Else
     OnMap:=True;
End;

Function TMap.MouseMapX;
Begin
   MouseMapX:=ScrollX+((MouseX-100) Div 10)+1;
End;

Function TMap.MouseMapY;
Begin
   MouseMapY:=ScrollY+((MouseY-15) Div 10)+1;
End;

Procedure TMap.ScrollUp;
Begin
   If (ScrollY>0) then Dec(ScrollY);
End;

Procedure TMap.ScrollDown;
Begin
   If (ScrollY<MapSize-16) then Inc(ScrollY);
End;

Procedure TMap.ScrollRight;
Begin
   If (ScrollX<MapSize-21) then Inc(ScrollX);
End;

Procedure TMap.ScrollLeft;
Begin
   If (ScrollX>0) then Dec(ScrollX);
End;

Procedure TMap.MouseScroll;
  Var
    X1,X2,Y1,Y2,XM,YM:Integer;
Begin
   If CurMouse=Nil then Exit;
   If MouseIn(93,8,315,181)And MouseLB then
     Begin
        If MouseIn( 93,  8,315, 14) then ScrollUp;
        If MouseIn( 93,175,315,181) then ScrollDown;
        If MouseIn( 93,  8, 99,181) then ScrollLeft;
        If MouseIn(310,  8,315,181) then ScrollRight;
     End;
   If MouseIn(9,9,87,87)And MouseLB then
     Begin
        XM:=CalcScrMiniMapX(MouseX)-11;
        YM:=CalcScrMiniMapY(MouseY)-8;
        If XM<0 then XM:=0;
        If YM<0 then YM:=0;
        If XM>MapSize-21 then XM:=MapSize-21;
        If YM>MapSize-16 then YM:=MapSize-16;
        ScrollX:=XM;
        ScrollY:=YM;
     End;
   With SpriteManager.Mouse^ do
     Begin
       X1:=XSize div 2;
       Y1:=YSize div 2;
       X2:=320-XSize div 2;
       Y2:=200-YSize div 2;
     End;
   If Not MouseIn(X1+1,Y1+1,X2-1,Y2-1) then
     Begin
        If MouseX=X1 then ScrollLeft;
        If MouseX=X2 then ScrollRight;
        If MouseY=Y1 then ScrollUp;
        If MouseY=Y2 then ScrollDown;
     End;
End;

Procedure TMap.ZeroKeyScroll;
Begin
   Case Key of
     { One Direct Scroll Keys }
     #72:ScrollUp;
     #80:ScrollDown;
     #75:ScrollLeft;
     #77:ScrollRight;
     { Two Direct Scroll Keys }
     #71:
       Begin
          ScrollUp;
          ScrollLeft;
       End;
     #73:
       Begin
          ScrollUp;
          ScrollRight;
       End;
     #81:
       Begin
          ScrollDown;
          ScrollRight;
       End;
     #79:
       Begin
          ScrollDown;
          ScrollLeft;
       End;
   End;
End;

Procedure TMap.DrawMiniMap;
  Var
    XS1,YS1,XS2,YS2:Word;
Begin
   MiniMapSpr^.PutXY(9,9);
   If MiniMapScale>0 then
     Begin
        XS2:=CalcMiniMapScrX(ScrollX+1+20)+MiniMapScale-1;
        YS2:=CalcMiniMapScrY(ScrollY+1+15)+MiniMapScale-1;
        XS1:=CalcMiniMapScrX(ScrollX)+1;
        YS1:=CalcMiniMapScrY(ScrollY)+1;
     End
     Else
     Begin
        XS2:=CalcMiniMapScrX(ScrollX+1+20);
        YS2:=CalcMiniMapScrY(ScrollY+1+15);
        XS1:=CalcMiniMapScrX(ScrollX+1);
        YS1:=CalcMiniMapScrY(ScrollY+1);
     End;
   If (XS1<>XS2)And(YS1<>YS2) then
     Rectangle(XS1,YS1,XS2,YS2,25)
     Else
     Box(XS1,YS1,XS2,YS2,25);
End;

Procedure TMap.RefreshMiniMap;
  Var
    I,J,N:Byte;
    CR:PMapRec;
    XR,YR:Integer;
Begin
   For I:=0 to 79 do
     For J:=0 to 79 do
       Begin
          XR:=CalcScrMiniMapX(I+9);
          YR:=CalcScrMiniMapY(J+9);
          N:=8;
          If OnMap(XR,YR) then
            Begin
               CR:=GetRec(XR,YR);
               Case CR^.EarthType of
                 etPusto:N:=2;
                 etWater:N:=1;
               End;
            End;
          With MiniMapSpr^ do
            Mem[Seg(Pic^):Ofs(Pic^)+I+J*80]:=N;
       End;
End;

Function TMap.CalcScrMiniMapX(X:Integer):Integer;
Begin
   If (X<9)Or(X>89) then
     Begin
        CalcScrMiniMapX:=-10;
        Exit
     End;
   If MiniMapScale>0 then
     CalcScrMiniMapX:=((X-9-MiniMapOfs) div MiniMapScale)+1
     Else
     CalcScrMiniMapX:=((X-9-MiniMapOfs)*(-MiniMapScale))+1;
End;

Function TMap.CalcScrMiniMapY(Y:Integer):Integer;
Begin
   If (Y<9)Or(Y>89) then
     Begin
        CalcScrMiniMapY:=-10;
        Exit
     End;
   If MiniMapScale>0 then
     CalcScrMiniMapY:=((Y-9-MiniMapOfs) div MiniMapScale)+1
     Else
     CalcScrMiniMapY:=((Y-9-MiniMapOfs)*(-MiniMapScale))+1;
End;

Function TMap.CalcMiniMapScrX(X:Integer):Integer;
Begin
   If MiniMapScale>0 then
     CalcMiniMapScrX:=MiniMapOfs+9+(X-1)*MiniMapScale
     Else
     CalcMiniMapScrX:=MiniMapOfs+9+(X-1) div (-MiniMapScale);
End;

Function TMap.CalcMiniMapScrY(Y:Integer):Integer;
Begin
   If MiniMapScale>0 then
     CalcMiniMapScrY:=MiniMapOfs+9+(Y-1)*MiniMapScale
     Else
     CalcMiniMapScrY:=MiniMapOfs+9+(Y-1) div (-MiniMapScale);
End;

Function MaxMapSize;
Begin
   MaxMapSize:=Trunc(Sqrt(MaxMapSizeSqr));
End;

End.