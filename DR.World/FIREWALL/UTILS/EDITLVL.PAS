Uses Video,Crt,UWorkScr,Paths,MouseLib,SprMngr,MapObj;

Var
  WorkFrameBuf:PScrBuf;

Function ProgInput:Boolean;
  Var
    Res:Boolean;
  Procedure LeftMouseInput;
  Begin
     If MouseIn(100,15,309,174) then
       Begin
          Map.PutBrush(Map.MouseMapX,Map.MouseMapY,1,etWater);
          Exit;
       End;
  End;
Begin
   Res:=False;
   GetMousePos;
   Map.MouseScroll;
   If MouseLB then
     LeftMouseInput;
   If KeyPressed then
     Case ReadKey of
       #0:Map.ZeroKeyScroll(ReadKey);
       'G':Map.Generate;
       'C':Map.Clear;
       #27:Res:=True;
     End;
   ProgInput:=Res;
End;

Procedure DrawWorkWindow(NP:Byte);
Begin
   Map.Draw(NP);
End;

Procedure Show_All;
Begin
   ScrCopy(WorkFrameBuf,ScrBuf);
   CurScr:=WorkScrBuf;
   DrawWorkWindow(0);
   ShowWorkWindow(0);
   DrawWorkWindow(1);
   ShowWorkWindow(1);
   CurScr:=ScrBuf;
   DrawMouse;
   ScrCopy(ScrBuf,Screen);
End;

Procedure Init_All;
Begin
   Randomize;
   NewPaths('..\');
   New(ScrBuf);
   New(WorkFrameBuf);
   New(WorkScrBuf);
   Map.Init(32);
   SpriteManager.Init;
   CurScr:=WorkFrameBuf;
   {If Not DetectMouse then} CurMouse:=SpriteManager.Mouse;
   DrawWorkFrame;
   InitMCGA;
   InitMCGAMouse;
End;

Procedure Done_All;
Begin
   DoneMCGA;
   SpriteManager.Done;
   Map.Done;
   Dispose(WorkScrBuf);
   Dispose(WorkFrameBuf);
   Dispose(ScrBuf);
End;

Begin
   Init_All;
   While Not ProgInput do
     Show_All;
   Done_All;
End.