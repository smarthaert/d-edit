Uses Crt,Paths,Video,Clr_Nat,SprMngr,MouseLib,UWorkScr,MapObj;

Var
  WorkFrameBuf:PScrBuf;

Function GameInput:Boolean;
  Var
    Res:Boolean;
  Procedure LeftMouseInput;
  Begin
     If MouseIn(100,15,309,174) then
       Begin
          {Map.PutBrush(Map.MouseMapX,Map.MouseMapY,1,etWater);}
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
       {'G':Map.Generate;
       'C':Map.Clear;}
       #27:Res:=True;
     End;
   GameInput:=Res;
End;

Procedure Step_All;
Begin
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
   Map.DrawMiniMap;
   DrawMouse;
   ScrCopy(ScrBuf,Screen);
End;

Procedure InitGameObjs;
{  Var
    I:Byte;}
Begin
   InitMObjs;
{     Begin
        New(TestView);
        TestView^.Init(@PMView(TestView),SpriteManager.Boom);
        TestView^.Next:=L;
        L:=TestView;
     End;}
End;

Procedure Init_All;
Begin
   Randomize;
   NewPaths('..\');
   New(ScrBuf);
   New(WorkFrameBuf);
   New(WorkScrBuf);
   Map.Init(80);
   Map.Generate;
   SpriteManager.Init;
   CurScr:=WorkFrameBuf;
   {If Not DetectMouse then}
     CurMouse:=SpriteManager.Mouse;
   DrawWorkFrame;
   InitMCGA;
   InitMCGAMouse;
End;

Procedure DoneGameObjs;
Begin
{   While TestView<>Nil do
     TestView^.Free;}
   DoneMObjs;
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

Procedure Game_All;
Begin
   While Not GameInput do
     Begin
        Step_All;
        Show_All;
     End;
End;

Begin
   Init_All;
   Game_All;
   Done_All;
   Writeln(MaxMapSize);
End.