unit SceneMainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, DIB , DXWStatObj,DXWPath, DXWImageSprite;


 Var
   StartSelection   : boolean;

 procedure StartSceneMain;
 procedure SceneMain;
 procedure EndSceneMain;
 procedure ScrollSpriteEngine;
 procedure WatchForEnemy;
 procedure Attack;


 procedure SceneMainMouseDown(Shift: TShiftState; X, Y: Integer);
 procedure SceneMainMouseUp(Shift: TShiftState; X, Y: Integer);
 procedure SceneMainMouseMove(Shift: TShiftState; X, Y: Integer);

 procedure OutSelSpriteInf;

implementation
Uses Main,GameSpritesUnit,Menu, DXWNavigator, Pathes ;

procedure ScrollSpriteEngine;
Const
 StepScroll=20;
Var
  dx,dy,ScrollCount : integer;
  NewX,NewY : double;
  Xmax,Xmin,Ymax,Ymin : double;
begin
With MainForm do begin

Xmax:=0;
Ymax:=0;
Xmin:=SpriteEngine.Engine.Width-MapW;
Ymin:=SpriteEngine.Engine.Height-MapH;

if DXTimer.FrameRate=0
 then ScrollCount:=Trunc(StepScroll)
  else ScrollCount:=Trunc(StepScroll*(80/DXTimer.FrameRate));

dx:=0;
dy:=0;
if MouseXY.Y=0 then dy:=ScrollCount;
if MouseXY.Y=479 then dy:=-ScrollCount;//(480-1)
if MouseXY.X=0 then dx:=ScrollCount;
if MouseXY.X=639 then dx:=-ScrollCount;//(640-1)

if ( isUp in DXInput.States )then dy:=ScrollCount;
if ( isDown in DXInput.States )then dy:=-ScrollCount;
if ( isLeft in DXInput.States )then dx:=ScrollCount;
if ( isRight in DXInput.States )then dx:=-ScrollCount;

NewX:=SpriteEngine.Engine.X+dx;
NewY:=SpriteEngine.Engine.Y+dy;
if ( NewX<=Xmax ) and ( NewX>=Xmin )
 then SpriteEngine.Engine.X:=NewX
 else
  if NewX>Xmax
   then SpriteEngine.Engine.X:=Xmax
    else SpriteEngine.Engine.X:=Xmin;

if ( NewY<=Ymax ) and ( NewY>=Ymin )
 then SpriteEngine.Engine.Y:=NewY
 else
  if NewY>Ymax
   then SpriteEngine.Engine.Y:=Ymax
    else SpriteEngine.Engine.Y:=Ymin;

end;
end;

procedure WatchForEnemy;
Var
 i     : integer;


begin
// need  optimiztion
 With MainForm do
 begin
 //Zprofiler.mark(1,true);


  For i:=0 to MainForm.SpriteEngine.Engine.AllCount-1 do
   if (MainForm.SpriteEngine.Engine.Items[i] is TGameUnit)
    then TGameUnit(MainForm.SpriteEngine.Engine.Items[i]).doWatchForEnemy;


{
   i := -1;
   repeat
    i := MainForm.SpriteEngine.Engine.FindInstanceOf(TGameUnit, false, i+1);
    if i >= 0
     then TGameUnit(MainForm.SpriteEngine.Engine.Items[i]).doWatchForEnemy;
   until(i < 0);
}

 //Zprofiler.mark(1,false);
 end;
end;

procedure Attack;
Var
 i     : integer;
begin
// need  optimiztion
 With MainForm do
 begin
  For i:=0 to MainForm.SpriteEngine.Engine.AllCount-1 do
   if (MainForm.SpriteEngine.Engine.Items[i] is TGameUnit)
    then TGameUnit(MainForm.SpriteEngine.Engine.Items[i]).doAttack;
 end;
end;


procedure SceneMain;
Const
 StepMove=25;// (1000/40)
 Counter : LongInt=0;
Var
  i     : integer;
  selX  : integer;
begin
With MainForm do begin

if DXTimer.FrameRate=0
 then SpriteEngine.Move(Trunc(StepMove))
  else SpriteEngine.Move(Trunc(StepMove*(80/DXTimer.FrameRate)));

SpriteEngine.Dead;

ScrollSpriteEngine;

If Counter>(DXTimer.FrameRate div 2) then// no need exectly
  begin
   WatchForEnemy;
   Counter:=0;
  end
   else Inc(Counter);

Attack;


DXDraw.Surface.Fill(0);// may do not this
if FNextScene=gsNone then
  begin
   SpriteEngine.Draw;

   //TmpImageList2.Items.Find('Map1_1').Draw(DXDraw.Surface,0,0, 0);
   //TmpImageList2.Items.Find('Map1_2').Draw(DXDraw.Surface,22,0, 0);
   //TmpImageList2.Items.Find('Map1_3').Draw(DXDraw.Surface,22,458, 0);
   TmpImageList2.Items.Find('Map1_4').Draw(DXDraw.Surface,446,0, 0);

   For i:=0 to FBtnList.Count-1
    do TDXImageButton(FBtnList[i]).DrawSelf;

   Navigator.DrawSelf;

   if SubSceneMainMenuEnabled then SubSceneMainMenu;

//---------- Frame rate display and GroupeSelRect---------
    with DXDraw.Surface.Canvas do
    begin

    if StartSelection then
     begin
      Pen.Color:=clGreen;
      Pen.Style:=psDot;
      Pen.Width:=1;

      if MouseXY.X >SpriteEngine.Engine.Width
       then selX:=SpriteEngine.Engine.Width
        else selX:=MouseXY.X;

      Rectangle(Trunc(MapDownPointX+SpriteEngine.Engine.X),
                Trunc(MapDownPointY+SpriteEngine.Engine.Y),
                selX,MouseXY.Y);
     end;
    Pen.Style:=psSolid;


    Brush.Style := bsClear;
    Font.Color := clWhite;
    //Font.Name := 'MS Sans Serif';
    Font.Name := 'Arial';
    Font.Size := 7;

    Textout(480, 150, 'FPS: '+inttostr(DXTimer.FrameRate));
    //Textout(480, 160, 'Sprite: '+inttostr(SpriteEngine.Engine.AllCount));
    Textout(480, 160, 'Sprite: '+inttostr(SpriteEngine.Engine.Count));

    Textout(480, 170, 'Draw: '+inttostr(SpriteEngine.Engine.DrawCount));


    Textout(480, 180, format('Engine.W/H: %d,%d ',[SpriteEngine.Engine.Width,SpriteEngine.Engine.Height]));
    Textout(480, 190, format('Engine.XY: %.0f,%.0f ',[SpriteEngine.Engine.X,SpriteEngine.Engine.Y]));
    Textout(480, 200, format('Engine.WorldXY: %.0f,%.0f ',[SpriteEngine.Engine.WorldX,SpriteEngine.Engine.WorldY]));
    Textout(400, 210, format('Engine.SerfaseRect: %d,%d,%d,%d ',
           [SpriteEngine.Engine.SurfaceRect.left,
            SpriteEngine.Engine.SurfaceRect.top,
            SpriteEngine.Engine.SurfaceRect.Right,
            SpriteEngine.Engine.SurfaceRect.Bottom]));
    Textout(400, 220, format('Engine.BoundsRect: %d,%d,%d,%d ',
           [SpriteEngine.Engine.BoundsRect.left,
            SpriteEngine.Engine.BoundsRect.top,
            SpriteEngine.Engine.BoundsRect.Right,
            SpriteEngine.Engine.BoundsRect.Bottom]));

    Textout(480, 230, format('MapW/H: %d,%d ',[MapW,MapH]));


    Textout(400, 240, format('ScrollBackground.WorldXY: %.0f,%.0f ',[ScrollBackground.WorldX,ScrollBackground.WorldY]));
    Textout(400, 250, format('ScrollBackground.XY: %.0f,%.0f ',[ScrollBackground.X,ScrollBackground.Y]));



    Release;
    end;
    OutSelSpriteInf;
  end;
end;
end;



procedure StartSceneMain;
Var
 i, j    : Integer;
 FileName : string;
begin
 MainForm.SpriteEngine.Engine.SurfaceRect :=Rect(0,0,446,480);

 FileName:='MainFon.dxg';
 MainForm.LoadPicData(MainForm.TmpImageList2,FileName);
 //MainForm.TmpImageList2.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
 MainForm.SavePicData(MainForm.TmpImageList2,FileName);

 FileName:='GameSprites.dxg';
 MainForm.LoadPicData(MainForm.ImageList,FileName);
 //MainForm.ImageList.Items.LoadFromFile(GetName('Graphics\DXG',FileName));
 MainForm.SavePicData(MainForm.ImageList,FileName);

 MainForm.LoadWaves;
 //MainForm.DXWaveList.Items.LoadFromFile(GetName('Sound\DXW','SpriteEffect.dxw'));

 //FScore := 0;
 //FEnemyAdventPos := 0;
 //FFrame := 0;

{
  For i:=1 to 5 do begin
  With TPlayer2.Create(SpriteEngine.Engine) do
   begin
    X:=50 + 70*i;
    Y:=100;
    Z := Trunc(Y);
   end;
  end;
}

{  Cursor object  }
//  CursorSprite:=TCursorSprite.Create(SpriteEngine.Engine);


  {
  With  TBuilding.Create(SpriteEngine.Engine) do
   begin
   Image := MainForm.ImageList.Items.Find('Castle');
   Width := Image.Width;
   Height := Image.Height;
   //PixelCheck:=true;
   X := 150;
   Y := 300;
   Z := Trunc(Y);
   end;


 Randomize;
 For i:=1 to 30 do begin
  With  TBuilding.Create(SpriteEngine.Engine) do
   begin
   Image := MainForm.ImageList.Items.Find('Trees');
   Width := Image.Width;
   Height := Image.Height;
   //PixelCheck:=true;

   if i<=15 then
   begin
   X := -1800+ 200*i;
   Y := 0;
   Z := Trunc(Y);
   end
   else
   begin
   X := -1800+ 200*(i-15);
   Y := 450;
   Z := Trunc(Y);
   end;

   end;
  end;


 With  TBuilding.Create(SpriteEngine.Engine) do
   begin
   Image := MainForm.ImageList.Items.Find('Mine');
   Width := Image.Width;
   Height := Image.Height;
   //PixelCheck:=true;
   X := 350;
   Y := 350;
   Z := Trunc(Y);
   end;
}



//  Background //  Background //  Background //  Background //  Background //  Background
  ScrollBackground:=TScrollBackground.Create(MainForm.SpriteEngine.Engine);
  //ScrollBackground.LoadObstacle;

  ScrollBackground.LoadMap(GetName('Map','Test2.map'));

  PathInf:=TDXPath.Create(DimW,DimH);
  For j :=0 to (DimH-1) do
   For i :=0 to(DimW-1) do
    PathInf.FObstacle[j,i]:=ScrollBackground.Obstacle[j,i];

  For i:=1 to 5 do begin
  With TGameUnit.Create(MainForm.SpriteEngine.Engine) do
   begin
    UnitName:='Player1Spr';
    Direction:=Random(8);

    FChipH:=ChipH;
    FChipW:=ChipW;
    X:=150 + 90*i;

    Y:=130;
    Z := Trunc(Y);

    Life             := 20;
    FLifeMax         := 20;
    FDamage          := 1;
    FAttackRange     := 200;
    FSight           := 200;
    FSpeed           := 75/1000;

    FAllyID          := 1;
    FUnitColor       :=DXRed;

   end;
  end;

  For i:=1 to 5 do begin
  With TGameUnit.Create(MainForm.SpriteEngine.Engine) do
   begin
    UnitName:='Player2Spr';
    Direction:=Random(8);

    FChipH:=ChipH;
    FChipW:=ChipW;

    X:=50 + 120*i;
    Y:=400;
    Z := Trunc(Y);

    Life             := 20;
    FLifeMax         := 20;
    FDamage          := 1;
    FAttackRange     := 200;
    FSight           := 200;
    FSpeed           := 75/1000;

    FAllyID          := 2;
    FUnitColor       :=DXBlue;
   end;
  end;


  Navigator:=TDXWNavigator.Create;
  Navigator.InitLeft:=468;
  Navigator.InitTop:=22;
  Navigator.InitWidth:=150;
  Navigator.InitHeight:=150;
  Navigator.MapW:=MapW;
  Navigator.MapH:=MapH;
  Navigator.SpriteEngine:=MainForm.SpriteEngine;


  ScrollBackground.MakeMiniMap;


  FBtnList.Add(TDXImageButton.Create);
  With TDXImageButton(FBtnList[FBtnList.Count-1]) do
   begin
    Image := MainForm.TmpImageList2.Items.Find('BtnGameMenu');
    Width := Image.Width;
    Height := Image.Height;
    X := 468;
    Y := 3;
    Surface:=MainForm.DXDraw.Surface;
   end;

end;


procedure SceneMainMouseDown(Shift: TShiftState; X, Y: Integer);
Var
 i,n             : integer;
 r               : TRect;
 ClickedSprite   : TSprite;
 SelSprites      : TList;
 BaseX,BaseY     : Double;
 dX,dY           : Double;

 MapX,MapY       : Double;
 DestX,DestY     : Double;

 dL,dLmin        : Double;
 DownPoint       : TPoint;
begin
DownPoint:=Point(X,Y);

MapX:=(-MainForm.SpriteEngine.Engine.X)+X;
MapY:=(-MainForm.SpriteEngine.Engine.Y)+Y;

MapDownPointX:=MapX;
MapDownPointY:=MapY;

if Not SubSceneMainMenuEnabled then
begin

r:= MainForm.SpriteEngine.Engine.SurfaceRect;
if PtInRect(r,DownPoint)then
  begin
   if (ssLeft in Shift) then StartSelection := True;

   ClickedSprite:=MainForm.SpriteEngine.Engine.GetSpriteAt(DownPoint.X,DownPoint.Y);

   if (ClickedSprite is TWImageSprite)and(ssLeft in Shift) then
   begin
    For i:=0 to MainForm.SpriteEngine.Engine.AllCount-1 do
     if MainForm.SpriteEngine.Engine.Items[i] is TWImageSprite
      then TWImageSprite(MainForm.SpriteEngine.Engine.Items[i]).Selected:=false;
    With TWImageSprite(ClickedSprite) do
     begin
      Selected:=true;
      CanMove:=false;
     end;
   end;


   if (ClickedSprite=nil) and (ssRight in Shift) then
   begin
    DestX:=MapX;
    DestY:=MapY;

    if Not ScrollBackground.Obstacle[Trunc(DestY/ChipH),Trunc(DestX/ChipW)] then
    begin

     SelSprites:=TList.Create;
     try

     For i:=0 to MainForm.SpriteEngine.Engine.AllCount-1 do
      if (MainForm.SpriteEngine.Engine.Items[i] is TWImageSprite) and
         (TWImageSprite(MainForm.SpriteEngine.Engine.Items[i]).Selected)
       then
         SelSprites.Add(TWImageSprite(MainForm.SpriteEngine.Engine.Items[i]));

     if SelSprites.Count=0 then Exit;

     i:=0;
     dx:=(DestX-TWImageSprite(SelSprites[i]).X);
     dy:=(DestY-TWImageSprite(SelSprites[i]).Y);
     dLmin:=dx*dx+dy*dy;
     n:=0;

     For i:=1 to SelSprites.Count-1 do
     begin
      dx:=(DestX-TWImageSprite(SelSprites[i]).X);
      dy:=(DestY-TWImageSprite(SelSprites[i]).Y);
      dL:=dx*dx+dy*dy;
      if dL<dLmin then
       begin
        dLmin:=dL;
        n:=i;
       end;
     end;
     BaseX:=TWImageSprite(SelSprites[n]).X;
     BaseY:=TWImageSprite(SelSprites[n]).Y;

     For i:=0 to SelSprites.Count-1 do
      With TWImageSprite(SelSprites[i]) do
       begin
           dX:=BaseX-X;
           dY:=BaseY-Y;

           DestPointX:=(-MainForm.SpriteEngine.Engine.X)+DownPoint.X-dX;
           DestPointY:=(-MainForm.SpriteEngine.Engine.Y)+DownPoint.Y-dY;

           DestChipX:=Trunc(DestPointX/ChipW);
           DestChipY:=Trunc(DestPointY/ChipH);

           While ScrollBackground.Obstacle[DestChipY,DestChipX] do
            begin
             dX:=(Abs(dX)-ChipW)*Sign(dX);
             DestPointX:=(-MainForm.SpriteEngine.Engine.X)+DownPoint.X-dX;
             DestChipX:=Trunc(DestPointX/ChipW);
             if Not ScrollBackground.Obstacle[DestChipY,DestChipX]
              then Break;

             dY:=(Abs(dY)-ChipH)*Sign(dY);
             DestPointY:=(-MainForm.SpriteEngine.Engine.Y)+DownPoint.Y-dY;
             DestChipY:=Trunc(DestPointY/ChipH);
            end;

           FindPath(Point(ChipX,ChipY),Point(DestChipX,DestChipY));
           if FindPath(Point(ChipX,ChipY),Point(DestChipX,DestChipY)) then
            begin
             DirChangedXYCount:=PathInf.DirChangedPointsCount;
             CurrentDirChangedXYId:=0;
             SetLength(DirChangedXYArr,DirChangedXYCount);
             For n:=0 to DirChangedXYCount-1 do
             begin
              DirChangedXYArr[n].x:=PathInf.DirChangedPointsArr[n].Point.x*ChipW + ChipW div 2;
              DirChangedXYArr[n].y:=PathInf.DirChangedPointsArr[n].Point.y*ChipH + ChipH div 2;
              DirChangedXYArr[n].Dir:=PathInf.DirChangedPointsArr[n].Dir;
             end;
            end
            else Exit;

           CanMove:=true;
           //DestPointLocked:=False;
           //DestPointOriented:=False;


     end;//i
     finally
      SelSprites.Free;
     end;
    end;//if Not Obstacle
   end;//if (ClickedSprite=nil) and (ssRight in Shift)
end//if PtInRect(r,DownPoint)
else

  begin
   Navigator.NavigatorMouseDown(Shift,X,Y);
  end;

  begin
   For i:=0 to FBtnList.Count-1 do
    begin
     r:=TDXImageButton(FBtnList[i]).BoundsRect;
     if PtInRect(r,DownPoint)
      then TDXImageButton(FBtnList[i]).Selected:=true;
    end;
  end;
end
else
 SubSceneMainMenuMouseDown(Shift,X,Y);
end;


procedure EndSceneMain;
Var
 i: integer;
begin
Navigator.Free;

MainForm.TmpImageList2.Items.Clear;
MainForm.SpriteEngine.Engine.Clear;

MainForm.DXWaveList.Items.Clear;

For i:=0 to FBtnList.Count-1
 do TDXImageButton(FBtnList[i]).free;
FBtnList.Clear;
end;

procedure SceneMainMouseUp(Shift: TShiftState; X, Y: Integer);
begin
StartSelection := false;

Navigator.NavigatorMouseUp(Shift,X,Y);

if Not SubSceneMainMenuEnabled then
 begin
 if TDXImageButton(FBtnList[0]).Selected then
  begin
   TDXImageButton(FBtnList[0]).Selected:=False;
   StartSubSceneMainMenu;
  end;
 end else SubSceneMainMenuMouseUp(Shift,X,Y);
end;

procedure SceneMainMouseMove(Shift: TShiftState; X, Y: Integer);
Var
 i          : integer;
 GroupR     : TRect;
 WX,WY      : integer;
begin
Navigator.NavigatorMouseMove(Shift,X,Y);

if (StartSelection)and(ssLeft in Shift)then
 With MainForm do
 begin
  if X>SpriteEngine.Engine.Width
   then X:=SpriteEngine.Engine.Width;

  WX:=Trunc(MapDownPointX+SpriteEngine.Engine.X);
  WY:=Trunc(MapDownPointY+SpriteEngine.Engine.Y);

  GroupR:=Rect(min(WX,X),min(WY,Y),max(WX,X),max(WY,Y));

  For i:=0 to SpriteEngine.Engine.AllCount-1 do
   if SpriteEngine.Engine.Items[i] is TWImageSprite then
    With TWImageSprite(SpriteEngine.Engine.Items[i]) do
     if OverlapRect(GroupR,BoundsRect)
      then Selected:=true
       else Selected:=false;

 end;

end;

procedure OutSelSpriteInf;
Var
i,n : integer;
S: String;
DestX,DestY : integer;
begin

with MainForm,  MainForm.DXDraw.Surface.Canvas do
try

For i:=0 to SpriteEngine.Engine.AllCount-1 do
begin
 if SpriteEngine.Engine.Items[i] is TGameUnit then
  begin
   With TGameUnit(SpriteEngine.Engine.Items[i]) do
    begin
     if Selected then
     begin

       Pen.Color:=clYellow;
       DestX:=Trunc(DestPointX+SpriteEngine.Engine.X);
       DestY:=Trunc(DestPointY+SpriteEngine.Engine.Y);
       Ellipse(DestX-5,DestY-5,DestX+5,DestY+5);


       if  DirChangedXYCount>0 then
       begin
          n:=0;
          DestX:=Trunc(DirChangedXYArr[n].X+SpriteEngine.Engine.X);
          DestY:=Trunc(DirChangedXYArr[n].Y+SpriteEngine.Engine.Y);
          MoveTo(DestX,DestY);
        For n:=1 to DirChangedXYCount-1 do
         begin
          DestX:=Trunc(DirChangedXYArr[n].X+SpriteEngine.Engine.X);
          DestY:=Trunc(DirChangedXYArr[n].Y+SpriteEngine.Engine.Y);
          LineTo(DestX,DestY);
         end;
       end;



        Brush.Style := bsClear;
        Font.Color := clWhite;
        //Font.Name := 'MS Sans Serif';
        Font.Name := 'Arial';
        Font.Size := 7;


        //Textout(480, 50, format('Name: %s',[FName]));
        Textout(480, 60, format('Life: %d',[Life]));


        Textout(480, 260, format('XYZ: %.0f,%.0f / %d',[X,Y,Z]));
        Textout(480, 270, format('WXY: %.0f,%.0f',[WorldX,WorldY]));


        //Textout(480, 290, format('Direction: %d',[Direction]));
        //Textout(480, 300, format('DestXY: %.0f %.0f',[DestPointX,DestPointY]));

        //Textout(480, 310, format('ChipXY: %d %d',[ChipX,ChipY]));
        //Textout(480, 320, format('DestChipXY: %d %d',[DestChipX,DestChipY]));

        {
        if CanMove
        then Textout(480, 330, format('CanMove: %S',['true']))
        else Textout(480, 330, format('CanMove: %S',['false']));
        }
        {
        Textout(480, 320, format('AnimIndex: %d',[AnimIndex]));
        Textout(480, 330, format('AnimPos: %.0f',[AnimPos]));
        Textout(480, 340, format('AnimStart: %d',[AnimStart]));
        Textout(480, 350, format('AnimCount: %d',[AnimCount]));
        //Textout(480, 360, format('Image.PatternCount: %d',[Image.PatternCount]));
        }
        {
        S:='';
        if osMove in FObjectState then S:=S+' osMove ';
        if osCollided in FObjectState then S:=S+' osCollided ';
        Textout(480, 380, format('State: %S',[S]));
        }

        Exit;

     end;//if selected
    end;//With TPlayer1
  end;
end;// i: For i:=0 to SpriteEngine.Engine.AllCount-1 do

finally
 Release;
end;

end;

end.
