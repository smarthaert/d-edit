Uses Crt,Paths,Video,Clr_Nat,SprMngr,MouseLib,UWorkScr;

Const
  NTV=30;

Type
  PMAttract=^TMAttract;
  TMAttract=
    Object(TMView)
      XR,YR,XS,YS:Real;
      Constructor Init(SP:PPMView; Sprite:PStdSprite);
      Procedure Step; Virtual;
      Procedure Attract(APX,APY,C:Real);
      Procedure Truncate;
    End;

Constructor TMAttract.Init;
Begin
   Inherited Init(SP,Sprite,Random(210),Random(160),0);
   XR:=XD;
   YR:=YD;
   XS:=0;
   YS:=0;
End;

Procedure TMAttract.Truncate;
Begin
   XD:=Trunc(XR+0.5);
   YD:=Trunc(YR+0.5);
End;

Procedure TMAttract.Attract;
  Var
    R,XA,YA:Real;
Begin
   If Next<>Nil then
     PMAttract(Next)^.Attract(APX,APY,C);
   R:=Sqrt(Sqr((XR-APX)/4)+Sqr((YR-APY)/4));
   If R<0.4 then Exit;
   XA:=(XR-APX)/R/R*C;
   YA:=(YR-APY)/R/R*C;
   XS:=XS+XA*((((500/R)/R)/R)-1);
   YS:=YS+YA*((((500/R)/R)/R)-1);
   Truncate;
End;

Procedure TMAttract.Step;
Begin
   Inherited Step;
   YS:=YS+0.05;
   If XS> 3 then XS:= 3;
   If XS<-3 then XS:=-3;
   If YS> 3 then YS:= 3;
   If YS<-3 then YS:=-3;
   XR:=XR+XS;
   YR:=YR+YS;
   If XR< 20 then XS:=XS+0.5;
   If XR>190 then XS:=XS-0.5;
   If YR< 20 then YS:=YS+0.5;
   If YR>140 then YS:=YS-0.5;
   If (XR<  0)And(XS<0) then XS:=0;
   If (XR>210)And(XS>0) then XS:=0;
   If (YR<  0)And(YS<0) then YS:=0;
   If (YR>160)And(YS>0) then YS:=0;
   Truncate;
End;

Var
  TestView:PMAttract;
  SpeedLowMode:Boolean;

Procedure StepTestView;
Begin
   TestView^.Attract(MouseX-100,MouseY-15,4);
End;

Procedure SpeedLow;
  Var
    P:PMAttract;
Begin
   P:=TestView;
   While P<>Nil do
     With P^ do
       Begin
          XS:=XS*0.8;
          YS:=YS*0.8;
          P:=PMAttract(Next);
       End;
End;

Procedure TestViewNext;
  Var
    P:PMView;
Begin
   P:=TestView;
   If P=Nil then Exit;
   While P^.Next<>Nil do
     P:=(P^.Next);
   P^.Next:=TestView;
   P:=TestView;
   TestView:=PMAttract(P^.Next);
   P^.Next:=Nil;
   With PMAttract(P)^ do
     Begin
        XD:=MouseX-100;
        YD:=MouseY-15;
        XR:=XD;
        YR:=YD;
        XS:=0;
        YS:=0;
     End;
End;

Function GameInput:Boolean;
  Var
    Res:Boolean;
Begin
   Res:=False;
   MouseX:=GetCursorX Div 2;
   MouseY:=GetCursorY;
   If LeftPressed then
     StepTestView;
   If RightPressed then
     Begin
        If (MouseX>=100)And(MouseY>=15)And(MouseX<=309)And(MouseY<=174) Then
          TestViewNext;
     End;
   If KeyPressed then
     Case ReadKey of
       #27:Res:=True;
       '`':SpeedLow;
       #9:SpeedLowMode:=Not SpeedLowMode;
     End;
   GameInput:=Res;
End;

Procedure StepAll;
  Var
    P:PMAttract;
Begin
   If TestView=Nil then Exit;
   TestView^.Step;
   P:=TestView;
   While P<>Nil do
     Begin
        TestView^.Attract(P^.XR,P^.YR,0.4);
        P:=PMAttract(P^.Next);
     End;
   If SpeedLowMode then
     Begin
        MouseNat:=3;
        SpeedLow;
     End
     Else
     MouseNat:=1;
End;

Procedure ShowFrame;
  Var
    I:ShortInt;
Begin
   Box(0,0,319,199,106);
   For I:=1 to 5 do
     Rectangle(100-I,15-I,309+I,174+I,104+16+I-5);
End;

Procedure DrawWorkWindow(N:Byte);
  Var
    I,J:Byte;
Begin
   CurScr:=WorkScrBuf;
   {Box(0,0,319,199,1);}
   For I:=0 to 20 do
     For J:=0 to 7 do
       SpriteManager.Pusto^.PutXY(WorkWinXS+I*10,WorkWinYS+J*10);
   TestView^.Draw(N);
   CurScr:=ScrBuf;
End;

Procedure DrawMouse;
Begin
   With SpriteManager.Mouse^ do
     PutNatCenter(
       MouseX,
       MouseY,
       MouseNat);
End;

Procedure ShowAll;
Begin
   ShowFrame;
   DrawWorkWindow(0);
   ShowWorkWindow(0);
   DrawWorkWindow(1);
   ShowWorkWindow(1);
   DrawMouse;
   ScrCopy(ScrBuf,Screen);
End;

Procedure Game_All;
Begin
   While Not GameInput do
     Begin
        StepAll;
        ShowAll;
     End;
End;

Procedure InitTestView;
  Var
    I:Byte;
    L:PMAttract;
Begin
   L:=Nil;
   For I:=0 to NTV do
     Begin
        New(TestView);
        TestView^.Init(@PMView(TestView),SpriteManager.Boom);
        TestView^.Next:=L;
        L:=TestView;
     End;
End;

Procedure DoneTestView;
Begin
   While TestView<>Nil do
     TestView^.Free;
End;

Procedure Init_All;
Begin
   NewPaths('..\');
   New(ScrBuf);
   New(WorkScrBuf);
   SpriteManager.Init;
   InitMCGA;
   CurScr:=ScrBuf;
   With SpriteManager.Mouse^ do
     SetRange(XSize,(YSize Div 2),640-XSize,200-(YSize Div 2));
   SetCursor(320,100);
   SpeedLowMode:=False;
   InitTestView;
   ScrollX:=0;
   ScrollY:=0;
End;

Procedure Done_All;
Begin
   DoneMCGA;
   SpriteManager.Done;
   Dispose(WorkScrBuf);
   Dispose(ScrBuf);
End;

Begin
   Init_All;
   Game_All;
   Done_All;
End.