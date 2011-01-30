unit GameSpritesUnit;

Interface


Uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,  DXClass, DXSprite, DXInput, DXDraws,
  DXSounds, DIB , DXWStatObj, DXWPath, DXWImageSprite;

type

  TObjectState= Set of (
                        osStay,
                        osMove,
                        osCollided,
                        osAttacked,
                        osAttackObject,
                        osAttackGround
                        );

  TTileInf = record
              SetN     : byte;
              TileN    : byte;
              TileBits : byte;
             end;


  TGameObject=class(TWImageSprite)
  private
    // need to load from ini in future
    FUnitName            : string;
    FLife                : Integer;
    FMode                : Integer;

    procedure SetUnitName(const Value: String);
    procedure SetLife(const Value: Integer);
  public
        // need to load from ini in future
        FLifeMax         : Integer;
        FArmorMax        : Integer;
        FArmor           : Integer;
        FDamage          : Integer;
        FAttackRange     : Double;
        FSight           : Integer;
        FSpeed           : Double;

    FObjectToAttack  : TGameObject;
    //FAttacked
    FAttackAngle     : Double;
    FCanAttack       : Boolean;
    FGroundToAttackX : Double;
    FGroundToAttackY : Double;


    procedure Initialize;// do after create
    procedure LoadProperties;// get specials

    property UnitName : String read FUnitName write SetUnitName;
    property Life     : Integer read FLife write SetLife;

    function AttackAngleToDir : byte;
   end;



  TGameUnit = class(TGameObject)
  private
    FAttackCounter       : LongInt;
    //FAttackEffectCount   : Integer;
    FOldAttackEffectTime : Integer;
  protected
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
    procedure DoDraw; override;
  public
    FObjectState     : TObjectState;
    FAllyID          : Byte;
    FUnitColor       : Integer;

    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;

    procedure DoWatchForEnemy;//select FObjectToAttak
    procedure DoAttack;
    //procedure OrientToUnit( DestUnit : TWImageSprite );

   end;




  TAttackEffect = class(TGameObject)
  private
    FStartX       : Double;
    FStartY       : Double;
    FDestX        : Double;
    FDestY        : Double;

    //FMode         : Integer;

   protected
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  public
    constructor Create(AParent: TSprite); override;
    destructor Destroy; override;
  end;


  TScrollBackground = class(TBackgroundSprite)
  private
    FSpeed      : Double;
    FObstacle   : Array of Array of Boolean;
    FTileMap    : Array of Array of TTileInf;

    FSet1Image  : TPictureCollectionItem;
    FSet2Image  : TPictureCollectionItem;
    FSet3Image  : TPictureCollectionItem;

    function GetObstacle (j, i: Integer): boolean;
    procedure SetObstacle(j, i: Integer; const Value: boolean);

  protected
    procedure DoDraw; override;
    function GetBoundsRect: TRect; override;

  public
    //procedure LoadObstacle;
    procedure MakeMiniMap;

    procedure LoadMap(FileName: string);

    Property Obstacle[j,i : Integer]: boolean Read GetObstacle write SetObstacle;
  end;

Var
 ScrollBackground         : TScrollBackground;

implementation

Uses
Main, Pathes, Math;


{ ------------------------ TGameUnit --------------------------- }

constructor TGameUnit.Create(AParent: TSprite);
begin
 inherited Create(AParent);
end;

destructor TGameUnit.Destroy;
Var
i : integer;
begin
 inherited Destroy;
end;


procedure TGameUnit.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
 //if (Sprite is TAttackEffect)
 FObjectState:=FObjectState+[osCollided];
 Done := true;//interrupt the other detection of the colliding sprite
end;

procedure TGameUnit.DoMove(MoveCount: Integer);
Const
LastTickCount : longint = 0;
LastAnimPos   : Double = 0;
Var
LastX,LastY     : Double;
dx,dy,dl,dr     : Double;
Dir           : Byte;
dl_,X_,Y_     : Double;
i             : integer;
begin

 if FMode=1 then
  begin
    FMode:=2;

    For i:=0 to Engine.Count-1 do
    begin
     if Engine.Items[i] is TGameObject
      then with TGameObject(Engine.Items[i])do
      begin
       if  FObjectToAttack=Self
        then FObjectToAttack:=nil;
      end;
    end;

    FObjectToAttack:=nil;


    MainForm.PlaySound('RobotDth', False);
    Image := MainForm.ImageList.Items.Find('BigExplosion');

    X:=X-(Image.Width-Width)div 2;
    Y:=Y-(Image.Height-Height)div 2;

    Width := Image.Width;
    Height := Image.Height;

    AnimCount := Image.PatternCount;
    AnimLooped := False;
    AnimSpeed := 10/1000;
    AnimStart :=0;
    AnimPos := 0;

    //MainForm.PrintScreen; 

  end
 else
 if FMode=2 then
  begin
    if AnimSpeed=0 then  Dead;
    //if AnimPos=4 then  Dead;
  end;

inherited DoMove(MoveCount);


if Not CanMove then Exit;

if FMode=0 then  //  Existing now
 begin
   //FObjectState:=FObjectState-[osCollided];

   LastX:=X;
   LastY:=Y;

   Dir:=DirChangedXYArr[CurrentDirChangedXYId].Dir;
   dr:=FSpeed*MoveCount*DirV[Dir];
   Case Dir of
   0,2: begin
         dy:=ABS(DirChangedXYArr[CurrentDirChangedXYId+1].Y-cY);
         if dy>dr
          then Y:=Y+DirY[Dir]*dr
           else
             inc(CurrentDirChangedXYId);
             if CurrentDirChangedXYId=DirChangedXYCount-1
              then CanMove:=false;

        end;
   1,3: begin
         dx:=ABS(DirChangedXYArr[CurrentDirChangedXYId+1].X-cX);
         if dx>dr
          then X:=X+DirX[Dir]*dr
           else
             inc(CurrentDirChangedXYId);
             if CurrentDirChangedXYId=DirChangedXYCount-1
              then CanMove:=false;
        end;

   4,5,6,7: begin
            X_:=X;
            Y_:=Y;
            dx:=(DirChangedXYArr[CurrentDirChangedXYId+1].X-cX);
            dy:=(DirChangedXYArr[CurrentDirChangedXYId+1].Y-cY);
            dl_:=Sqrt(dx*dx+dy*dy);

            X:=X+DirX[Dir]*dr;
            Y:=Y+DirY[Dir]*dr;
            dx:=(DirChangedXYArr[CurrentDirChangedXYId+1].X-cX);
            dy:=(DirChangedXYArr[CurrentDirChangedXYId+1].Y-cY);
            dl:=Sqrt(dx*dx+dy*dy);

            if dl>dl_ then
             begin
              X:=X_;
              Y:=Y_;
              inc(CurrentDirChangedXYId);
              if CurrentDirChangedXYId=DirChangedXYCount-1
               then CanMove:=false;
             end;

            end;

   end;//Case

   Z:=Trunc(Y);

   Direction:=Dir;// alsou defind AnimStart


   if CanMove and ( Not (osMove in FObjectState))
    then // Start Mooving
      begin
       FObjectState:=FObjectState+[osMove];
       AnimLooped :=True;
       AnimSpeed := 5/1000;
       AnimCount := XCount;
       AnimPos:=0;
      end;


   if Not CanMove then
    begin //stop Mooving
     DirChangedXYCount:=0;
     FObjectState:=FObjectState-[osMove];
     AnimCount := 0;
    end;


    //if osCollided in  FObjectState then
    if Collision>0 then
     begin
      X:=LastX;
      Y:=LastY;
      Z:=Trunc(Y);
     end;
 end;//FMode=0
end;

procedure TGameUnit.DoDraw;
var
 r     : TRect;
 LifeR : TRect;
 W     : Integer;
 Progress  :integer;
 k         : double;
 DXColor   : Integer;
begin
//DXRed,DXBlue,DXYellow,DXGreen,DXLime

if FMode=0 then
begin

  r:=BoundsRect;
  W:=r.Right-r.Left;
  k:=FLife/FLifeMax;
  if k>0.66 then DXColor:=DXGreen
  else
  if k>0.33 then DXColor:=DXYellow
  else
  DXColor:=DXRed;


  Progress:=Trunc(W*k);
  LifeR:=Bounds(r.Left,r.Top,Progress,3);
  With Engine.Surface do
   begin
    FillRect(LifeR,DXColor);
    //FillRect(r,$0000FF00);
    //Pixels[L,T]:=$0000FF00;//yellow
    //FillRectAlpha(r,$0000FF00,10);
   end;

if Selected then
 begin
  With Engine.Surface.Canvas do
   begin
    Pen.Color:=clLime;
    //Rectangle(r.Left,r.Top,r.Right,r.Bottom);
    Ellipse(r.Left+4,r.Top+28,r.Right-4,r.Bottom-8);

    TextOut(r.Left,r.Bottom,format('%d %.2f',[Direction,FAttackAngle]));

    Release;
   end;
 end;//if selected

end;

inherited DoDraw;

end;

procedure TGameObject.Initialize;
begin

end;

procedure TGameObject.LoadProperties;
begin

end;


procedure TGameUnit.DoWatchForEnemy;
Var
i : integer;
dr,dx,dy: double;
//Sprite : TGameUnit;
begin
//if FObjectToAttack<>nil then Exit;

FCanAttack:=false;
FObjectToAttack:=nil;
if FMode>0 then Exit; 

For i:=0 to Engine.AllCount-1 do
 if Engine.Items[i] is TGameUnit then
  With TGameUnit(Engine.Items[i]) do
   begin
    if FMode>0 then continue;

    if Self.FAllyID=FAllyID
     then continue
      else
      begin
       dx:=Self.x-x;
       dy:=Self.y-y;
       dr:=sqrt(dx*dx+dy*dy);
       if dr<Self.FSight then
         begin
          Self.FObjectToAttack:=TGameUnit(Engine.Items[i]);
          Self.FCanAttack:=true;
          break;
         end;
      end;
   end;
end;

{
procedure TGameUnit.OrientToUnit(DestUnit: TWImageSprite);
begin
end;
}

procedure TGameUnit.DoAttack;
Const
 LastTickCount  : longint = 0;
 LastAnimPos    : Double = 0;
Var
 LastX,LastY    : Double;
 dx,dy,dl,dr    : Double;
 Dir            : Byte;
begin
inc(FAttackCounter);
if (FObjectToAttack = nil)or(Not FCanAttack)then Exit;

if
//(FAttackEffectCount<=4)and
(FAttackCounter-FOldAttackEffectTime>MainForm.DXTimer.FrameRate*0.7)
then
 begin
  MainForm.PlaySound('Gun', False);
  //Inc(FAttackEffectCount);
  FAttackAngle:=GetAngleToUnit(FObjectToAttack);
  Direction:=AttackAngleToDir;

        with TAttackEffect.Create(Engine) do
        begin
         //FGameUnit := Self;
         FObjectToAttack:=Self.FObjectToAttack;
         Direction:=Self.Direction;
         FAttackRange:=Self.FAttackRange;
         FDamage:=Self.FDamage;

         X := Self.X+(Self.Width div 2)+(Self.Width div 2)*Sin(DirRad[Direction])-Width div 2;
         Y := Self.Y+(Self.Height div 2)+(Self.Height div 2)*Cos(DirRad[Direction])-Height div 2;

         FAttackAngle:=GetAngleToUnit(FObjectToAttack);

         FStartX :=X;
         FStartY :=Y;
         FDestX:=FObjectToAttack.X;
         FDestY:=FObjectToAttack.Y;

        end;
        FOldAttackEffectTime := FAttackCounter;
      end;

end;


procedure TGameObject.SetUnitName(const Value: String);
begin

  if Value=FUnitName then Exit;
  FUnitName := Value;

  Image := MainForm.ImageList.Items.Find(Value);
  Width := Image.Width;
  Height := Image.Height;
  CalculatePatternXYCount;
  FObjectToAttack:=nil;
  AnimPos:=0;
  AnimStart:=0;

end;

procedure TGameObject.SetLife(const Value: Integer);
begin
  if Value < 0
   then FLife:=0
  else
  {
  if Value > FLifeMax
   then FLife:=FLifeMax
  else
  }
   FLife := Value;

   if(FLife=0)and(FMode=0)
    then FMode:=1;
    
end;

////////////////////////////////////////////////////////////////////

constructor TAttackEffect.Create(AParent: TSprite);
begin
  inherited Create(AParent);
  Collisioned := False;

  Image := MainForm.ImageList.Items.Find('FBall');
  //Image := MainForm.ImageList.Items.Find('Explosion32x42');

  Z := MapH;
  Width := Image.Width;
  Height := Image.Height;

  FSpeed:=200/1000;

  AnimCount := Image.PatternCount;
  AnimLooped := True;
  AnimSpeed := 25/1000;
end;

destructor TAttackEffect.Destroy;
begin
  //Dec(FGameUnit.FAttackEffectCount);
  inherited Destroy;
end;

procedure TAttackEffect.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
//
end;

procedure TAttackEffect.DoMove(MoveCount: Integer);
Var
Vx,Vy : real;
dL1,dL2 : Double;
dX,dY : Double;
dLmax : Double;
begin
inherited DoMove(MoveCount);

 if FMode=0 then//existing now
  begin
  dLmax:=FSpeed*MoveCount;

  //Vx:=FSpeed*Sin(DirRad[FDirection]);
  //Vy:=FSpeed*Cos(DirRad[FDirection]);

  Vx:=FSpeed*Sin(FAttackAngle);
  Vy:=FSpeed*Cos(FAttackAngle);

  X := X + Vx*MoveCount;
  Y := Y + Vy*MoveCount;

  dX:=X-FStartX;
  dY:=Y-FStartY;
  dL1:=sqrt(dX*dX+dY*dY);

  dX:=X-FDestX;
  dY:=Y-FDestY;
  dL2:=sqrt(dX*dX+dY*dY);

  if (dL2< dLmax)or(dL1>FAttackRange)then FMode:=1;
  end
 else
 if FMode=1 then
  begin
   FMode:=2;

    MainForm.PlaySound('Explosion', False);
    Image := MainForm.ImageList.Items.Find('Explosion');
    Width := Image.Width;
    Height := Image.Height;
    AnimCount := Image.PatternCount;
    AnimLooped := False;
    AnimSpeed := 15/1000;
    AnimStart :=0;
    AnimPos := 0;

    if FObjectToAttack<>nil
     then FObjectToAttack.Life:=FObjectToAttack.Life-FDamage;

  end
 else
 if FMode=2 then
  begin
    if AnimSpeed=0 then  Dead;
  end;

  //Collision;
end;



{ TScrollBackground  }
function TScrollBackground.GetBoundsRect: TRect;
begin
 Result:=Bounds(Trunc(WorldX),Trunc(WorldY),32*MapWidth,32*MapHeight);
end;

{
procedure TScrollBackground.DoDraw;
var
 wx, wy, i, j  : Integer;
 StartX, StartY, OfsX, OfsY, dWidth, dHeight: Integer;

 SetN,TileN,TileBits : byte;

begin
  dWidth := (Engine.SurfaceRect.Right   div ChipW)+2;
  dHeight := (Engine.SurfaceRect.Bottom div ChipH)+2;

  wx := Trunc(WorldX);
  wy := Trunc(WorldY);

  OfsX := wx mod ChipW;
  OfsY := wy mod ChipH;

  StartX := -(wx div ChipW);
  StartY := -(wy div ChipH);

  for j:=StartY to StartY+dHeight-1 do
  for i:=StartX to StartX+dWidth-1 do
   begin

       SetN:=FTileMap[j,i].SetN;
       TileN:=FTileMap[j,i].TileN;
       TileBits:=FTileMap[j,i].TileBits;

       if (SetN=0)and(TileBits=255) then
        begin
         SetN:=1;
         TileBits:=0;
         TileN:=16;
        end;

       Case SetN of
        1: FSet1Image.Draw(Engine.Surface, i*ChipW+OfsX, j*ChipH+OfsY, TileN);
        2: FSet2Image.Draw(Engine.Surface, i*ChipW+OfsX, j*ChipH+OfsY, TileN);
        3: FSet3Image.Draw(Engine.Surface, i*ChipW+OfsX, j*ChipH+OfsY, TileN);
       end;

   with Engine.Surface.Canvas do
    begin
     Brush.Style := bsClear;
     Font.Color := clWhite;
     //Font.Name := 'MS Sans Serif';
     Font.Name := 'Arial';
     Font.Size := 7;
     //Textout(0,0, format('OfsXY: %d,%d ',[OfsX,OfsY]));
     Textout(i*ChipW+OfsX, j*ChipH+OfsY,format('%d,%d',[i,j]));

    Release;
    end;


   end;

end;
}


procedure SmoothResize(var Src, Dst: TDIB);
var
 x,y,xP,yP,yP2,xP2 :  Integer;
 Read,Read2        :  PByteArray;
 t,t3,t13,z,z2,iz2 :  Integer;
 pc                :  PBytearray;
 w1,w2,w3,w4       :  Integer;
 Col1r,col1g,col1b,Col2r,col2g,col2b:   byte;
begin
  xP2:=((src.Width-1) shl 15)div Dst.Width;
  yP2:=((src.Height-1)shl 15)div Dst.Height;
  yP:=0;
  for y:=0 to Dst.Height-1 do
  begin
    xP:=0;
    Read:=src.ScanLine[yP shr 15];
    if yP shr 16<src.Height-1
     then  Read2:=src.ScanLine[yP shr 15+1]
      else Read2:=src.ScanLine[yP shr 15];
    pc:=Dst.scanline[y];
    z2:=yP and $7FFF;
    iz2:=$8000-z2;
    for x:=0 to Dst.Width-1 do
     begin
      t:=xP shr 15;
      t3:=t*3;
      t13:=t3+3;
      Col1r:=Read[t3];
      Col1g:=Read[t3+1];
      Col1b:=Read[t3+2];
      Col2r:=Read2[t3];
      Col2g:=Read2[t3+1];
      Col2b:=Read2[t3+2];
      z:=xP and $7FFF;
      w2:=(z*iz2)shr 15;
      w1:=iz2-w2;
      w4:=(z*z2)shr 15;
      w3:=z2-w4;
      pc[x*3+2]:=(Col1b*w1+Read[t13+2]*w2+Col2b*w3+Read2[t13+2]*w4)shr 15;
      pc[x*3+1]:=(Col1g*w1+Read[t13+1]*w2+Col2g*w3+Read2[t13+1]*w4)shr 15;
      // (t+1)*3  is now t13
      pc[x*3]:=(Col1r*w1+Read2[t13]*w2+Col2r*w3+Read2[t13]*w4)shr 15;
      Inc(xP,xP2);
     end;
    Inc(yP,yP2);
  end;
end;


procedure TScrollBackground.MakeMiniMap;
var
 i, j  : Integer;
 SetN,TileN,TileBits : byte;

 TmpSurface : TDirectDrawSurface;
 NewGraphic : TDIB;
 MiniMapGraphic : TDIB;

 Rect    :  TRect;
 dw,dh   :  integer;
 AWidth, AHeight : integer;

 Item: TPictureCollectionItem;
 SWidth, SHeight : integer;


begin

 TmpSurface := TDirectDrawSurface.Create(Engine.Surface.DDraw);
 TmpSurface.SystemMemory := false;

 AWidth := Navigator.BoundsRect.Right-Navigator.BoundsRect.Left;
 AHeight := Navigator.BoundsRect.Bottom-Navigator.BoundsRect.Top;

 dw:=(AWidth  div DimW)+1;
 dh:=(AHeight div DimH)+1;
 SWidth:=dW*DimW;
 SHeight:=dH*DimH;

 TmpSurface.SetSize(SWidth, SHeight);

 JobList.Add('TmpSurface.Width'+'|'+IntToStr(SWidth));
 JobList.Add('TmpSurface.Height'+'|'+IntToStr(SHeight));

  For j :=0 to (DimH-1) do
   For i :=0 to(DimW-1) do
    begin
       SetN:=FTileMap[j,i].SetN;
       TileN:=FTileMap[j,i].TileN;
       TileBits:=FTileMap[j,i].TileBits;

       if (SetN=0)and(TileBits=255) then
        begin
         SetN:=1;
         TileBits:=0;
         TileN:=16;
        end;

       Rect:=Bounds(i*dw,j*dh,dw,dh);
       Case SetN of
        1: FSet1Image.StretchDraw(TmpSurface,Rect,TileN);
        2: FSet2Image.StretchDraw(TmpSurface,Rect,TileN);
        3: FSet3Image.StretchDraw(TmpSurface,Rect,TileN);
       end;

   end;

  //Navigator.MiniMapGraphic.SetSize(AWidth, AHeight,24);

  NewGraphic:= TDIB.Create;
  //NewGraphic.SetSize(SWidth,SHeight,16);
  //SetStretchBltMode(NewGraphic.Canvas.Handle, COLORONCOLOR);

  TmpSurface.AssignTo(NewGraphic);
  TmpSurface.Free;

  //NewGraphic.SaveToFile(GetName('MiniMap.bmp'));

  MiniMapGraphic:= TDIB.Create;
  MiniMapGraphic.SetSize(AWidth,AHeight,24);

  //Rect:=Bounds(0,0,AWidth,AHeight);
  //MiniMapGraphic.Canvas.StretchDraw(Rect,NewGraphic);

  SmoothResize(NewGraphic,MiniMapGraphic);

  //SetStretchBltMode(MiniMapGraphic.Canvas.Handle, COLORONCOLOR);
  //StretchBlt(MiniMapGraphic.Canvas.Handle,0,0,AWidth,AHeight,
  //           NewGraphic.Canvas.Handle,0,0,SWidth,SHeight,MiniMapGraphic.Canvas.CopyMode);


  NewGraphic.free;

  //MiniMapGraphic.SaveToFile(GetName('MiniMap_2.bmp'));

  Item := TPictureCollectionItem.Create(MainForm.ImageList.Items);
  Item.Name:='MiniMapGraphic';
  Item.SystemMemory:=false;
  Item.Picture.Graphic := MiniMapGraphic;
  Item.Restore;
  MiniMapGraphic.free;
  Navigator.Image:=Item;

end;



procedure TScrollBackground.DoDraw;
var
  _x, _y, cx, cy, cx2, cy2, c : Integer;
  StartX, StartY, EndX, EndY, StartX_, StartY_, OfsX, OfsY, dWidth, dHeight: Integer;
  r: TRect;

  SetN,TileN,TileBits : byte;

begin

  dWidth := (Engine.SurfaceRect.Right+ChipW) div ChipW+1;
  dHeight := (Engine.SurfaceRect.Bottom+ChipH) div ChipH+1;

  _x := Trunc(WorldX);
  _y := Trunc(WorldY);

  OfsX := _x mod ChipW;
  OfsY := _y mod ChipH;

  StartX := _x div ChipW;
  StartX_ := 0;

  if StartX<0 then
  begin
    StartX_ := -StartX;
    StartX := 0;
  end;

  StartY := _y div ChipH;
  StartY_ := 0;

  if StartY<0 then
  begin
    StartY_ := -StartY;
    StartY := 0;
  end;

  EndX := Min(StartX+MapWidth-StartX_, dWidth);
  EndY := Min(StartY+MapHeight-StartY_, dHeight);


    for cy:=StartY to EndY-1 do
      for cx:=StartX to EndX-1 do
      begin

       SetN:=FTileMap[cy-StartY+StartY_,cx-StartX+StartX_].SetN;
       TileN:=FTileMap[cy-StartY+StartY_,cx-StartX+StartX_].TileN;
       TileBits:=FTileMap[cy-StartY+StartY_,cx-StartX+StartX_].TileBits;

       if (SetN=0)and(TileBits=255) then
        begin
         SetN:=1;
         TileBits:=0;
         TileN:=16;
        end;

       Case SetN of
        1: FSet1Image.Draw(Engine.Surface, cx*ChipW+OfsX, cy*ChipH+OfsY, TileN);
        2: FSet2Image.Draw(Engine.Surface, cx*ChipW+OfsX, cy*ChipH+OfsY, TileN);
        3: FSet3Image.Draw(Engine.Surface, cx*ChipW+OfsX, cy*ChipH+OfsY, TileN);
       end;

      end;

end;

{
procedure TScrollBackground.LoadObstacle;
Var
i,j : Integer;
ms  : TMemoryStream;
begin
ms:=TMemoryStream.Create;
try
 ms.LoadFromFile(GetName('Map1.Dat'));
 ms.Position:=0;
 mS.Read(DimH,SizeOf(Integer));
 mS.Read(DimW,SizeOf(Integer));

 SetLength(FObstacle,DimH,DimW);
 For j :=0 to (DimH-1) do
  For i :=0 to(DimW-1) do
   ms.Read(FObstacle[j,i],SizeOf(Boolean));

finally
ms.Free;
end;

end;
}



procedure TScrollBackground.LoadMap(FileName: string);
Var
 i,j : integer;
 fs  : TFileStream;
 bVal: byte;
begin

fs:=TFileStream.Create(FileName,fmOpenRead);
try

fs.Read(DimH,sizeof(DimH));
fs.Read(DimW,sizeof(DimW));


JobList.Add('DimH'+'|'+IntToStr(DimH));
JobList.Add('DimW'+'|'+IntToStr(DimW));


FTileMap:=nil;
SetLength(FTileMap,DimH,DimW);

SetLength(FObstacle,DimH,DimW);


For i:=0 to DimW-1 do
 For j:=0 to DimH-1 do
 begin
  fs.Read(bval,sizeof(bval));
  FTileMap[j,i].SetN:=bval;

  Case bval of
   0,1,3 : FObstacle[j,i]:=true;
  else
    FObstacle[j,i]:=false;
  end;

  fs.Read(bval,sizeof(bval));
  FTileMap[j,i].TileN:=bval;

  fs.Read(bval,sizeof(bval));
  FTileMap[j,i].TileBits:=bval;
 end;

finally
fs.Free;
end;

SetMapSize(DimW,DimH);

FSet1Image := MainForm.ImageList.Items.Find('Set1');
FSet2Image := MainForm.ImageList.Items.Find('Set2');
FSet3Image := MainForm.ImageList.Items.Find('Set3');

ChipW:=32;
ChipH:=32;

MapW:=ChipW*DimW;
MapH:=ChipH*DimH;

X:=0;
Y:=0;
Z:=Trunc(Y);

Tile := false;
Collisioned:=false;

//Randomize;
{
Image := MainForm.ImageList.Items.Find('background');
for j:=0 to MapHeight-1 do
  for i:=0 to MapWidth-1 do
  begin
   if Obstacle[j,i] then
     begin
       Chips[i, j] :=1;
       //CollisionMap[i, j]:=true;
      end
     else
      begin
       Chips[i, j] :=0;
       //CollisionMap[i, j]:=false;
      end;
  end;
}
end;


function TScrollBackground.GetObstacle(j, i: Integer): boolean;
begin
if (j<0)or(j>(DimH-1))or(i<0)or(i>(DimW-1))then Result:=true
else Result:=FObstacle[j, i];
end;

procedure TScrollBackground.SetObstacle(j, i: Integer; const Value: boolean);
begin
if (j<0)or(j>(DimH-1))or(i<0)or(i>(DimW-1))then Exit;
FObstacle[j, i]:=Value;
end;



function TGameObject.AttackAngleToDir: byte;
Var
 i: integer;
begin
 //i:=Trunc(FAttackAngle*4/Pi);
 i:=Round(FAttackAngle*4/Pi);
 //Result:=i*0.79;
 Case i of
  0:Result:=2;
  1:Result:=6;
  2:Result:=1;
  3:Result:=5;
  4:Result:=0;
  -1:Result:=7;
  -2:Result:=3;
  -3:Result:=4;
  -4:Result:=0;
 end;
end;

end.
