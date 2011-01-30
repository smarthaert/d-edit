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
    FUnitColor       : TColor;

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
    FSpeed     : Double;
    FObstacle  : Array of Array of Boolean;

    function GetObstacle(j, i: Integer): boolean;
    procedure SetObstacle(j, i: Integer; const Value: boolean);

  protected
    procedure DoMove(MoveCount: Integer); override;
  public
    procedure LoadObstacle;
    Property Obstacle[j,i : Integer]: boolean Read GetObstacle write SetObstacle;
    Property Speed : Double read FSpeed write FSpeed;
  end;

  TSelectedUnitList = class(TList)

  protected
    // set the units 'Selected' property depending on the Action
    procedure Notify(Ptr: Pointer; Action: TListNotification); Override;
  end;

 // Groups support
 TUnitGroups = class
  Protected
    fMaxGroups : integer;
    fCount : integer;
    fSelectedUnitList : TSelectedUnitList;
    fUnitGroups : array of Tlist;
    function GetUnitGroup(group : integer) : Tlist;
    function GetUnit(index : integer) : TWImageSprite;
    Procedure SetMaxGroups(AMaxGroups : integer);
    Procedure SetCount(ACount : integer);
  Public
    Constructor Create(AMaxGroups : integer = 10);
    Destructor destroy; override;

    // forces the group to be the selected units
    // the groups doesnt contain any units then the active unit list isnt changed
    Procedure MakeUnitGroupSelected(Group : integer);
    // adds the group to the slected unit list
    Procedure AddUnitGroupToSelected(Group : integer);
    // stores the currently selected units in 'group' it overwrites the existing group data
    Procedure StoreSelectedUnits(Group : integer);

    Procedure Add(Sprite: TWImageSprite);
    Procedure Remove(Sprite: TWImageSprite);
    Procedure Clear;

    // the selected list
    Property Items[index : integer] : TWImageSprite read GetUnit; default;
    Property Count : integer read fCount Write SetCount;
    // the list of selected units
    Property SelectedUnitList : TSelectedUnitList read fSelectedUnitList;
    // the groups
    Property UnitGroups[group : integer] : Tlist read GetUnitGroup;
    Property MaxGroups : integer read fMaxGroups write setMaxGroups;
  end;
Var
 ScrollBackground         : TScrollBackground;
 SelectedUnitList         : TUnitGroups;

implementation

Uses
Main, Pathes, Math;

{ ------------------------ TUnitGroups ------------------------- }
Constructor TUnitGroups.Create(AMaxGroups : integer = 10);
begin
Inherited create;
fSelectedUnitList := TSelectedUnitList.create;
MaxGroups := aMaxGroups;
end; {Create}

Destructor TUnitGroups.destroy;
var
 index : integer;
begin
fSelectedUnitList.Clear;
fSelectedUnitList.free;
for index := 0 to high(fUnitGroups) do
  begin
  fUnitGroups[index].Clear;
  fUnitGroups[index].free;
  end;
fUnitGroups := nil;
Inherited Destroy;
end; {destroy}

Procedure TUnitGroups.SetMaxGroups(AMaxGroups : integer);
var
 Index : integer;
begin
if AMaxGroups <>fMaxGroups then
  begin
  setlength(fUnitGroups,AMaxGroups);
  // if new groups were added, initialize the goup lists
  for index := fMaxGroups to AMaxGroups -1 do
    fUnitGroups[index] := Tlist.Create;
  fMaxGroups := AMaxGroups;
  end;
end; {setMaxGroups}

Procedure TUnitGroups.SetCount(ACount : integer);
begin
fSelectedUnitList.Count := ACount;
fcount := fSelectedUnitList.Count;
end; {SetCount}

function TUnitGroups.GetUnitGroup(group : integer) : Tlist;
begin
if (Group >= 0) and (Group < MaxGroups) then
  result := fUnitGroups[Group]
else
  result := nil;  
end; {GetUnitGroup}

function TUnitGroups.GetUnit(index : integer) : TWImageSprite;
begin
if (index >= 0) and (index < fSelectedUnitList.count) then
  result := fSelectedUnitList[index]
else
  result := nil;
end; {GetUnit}

Procedure TUnitGroups.StoreSelectedUnits(Group : integer);
var
  index : integer;
  GroupList : Tlist;
begin
GroupList := UnitGroups[Group];
if GroupList <> nil then
  begin
  GroupList.clear;
  for index := 0 to fcount do
    GroupList.add(fSelectedUnitList[index]);
  end;
end; {StoreSelectedUnits}

Procedure TUnitGroups.AddUnitGroupToSelected(Group : integer);
var
  index : integer;
begin
if (Group >= 0) and (Group < MaxGroups) and
   (UnitGroups[Group].count <> 0) then
  for index := 0 to fUnitGroups[Group].count -1 do
    add(fUnitGroups[Group][index]);
end; {AddUnitGroupToSelected}

Procedure TUnitGroups.MakeUnitGroupSelected(Group : integer);
begin
if (Group >= 0) and (Group < MaxGroups) and
   (UnitGroups[Group].count <> 0) then
  begin
  SelectedUnitList.Clear;
  AddUnitGroupToSelected(Group);
  end;
end; {MakeUnitGroupSelected}

Procedure TUnitGroups.Add(Sprite: TWImageSprite);
begin
if fSelectedUnitList.indexof(TWImageSprite) = -1 then
  fSelectedUnitList.add(Sprite);
end; {Add}

Procedure TUnitGroups.Remove(Sprite: TWImageSprite);
begin
fSelectedUnitList.Remove(Sprite);
end; {Remove}

Procedure TUnitGroups.Clear;
begin
fSelectedUnitList.Clear;
end; {Clear}
{ --------------------- TSelectedUnitList ---------------------- }
procedure TSelectedUnitList.Notify(Ptr: Pointer; Action: TListNotification);
begin
assert(ptr <> nil,'Nil Pointer added to selected unit list!');
if Tobject(Ptr) is TWImageSprite then
case Action of
  lnAdded :
    begin
    inc(SelectedUnitList.fcount);
    TWImageSprite(Ptr).Selected := true;
    end;
  lnExtracted, lnDeleted :
    begin
    dec(SelectedUnitList.fcount);
    TWImageSprite(Ptr).Selected := false;
    end;
end;
end; {Notify}
{ ------------------------ TGameUnit --------------------------- }

constructor TGameUnit.Create(AParent: TSprite);
begin
 inherited Create(AParent);
end;

destructor TGameUnit.Destroy;
//Var i : integer;
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
    Pen.Color:=FUnitColor;
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
//Var
// LastX,LastY    : Double;
// dx,dy,dl,dr    : Double;
// Dir            : Byte;
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
  Z := MapH;
  Width := Image.Width;
  Height := Image.Height;

  FSpeed:=300/1000;

  AnimCount := Image.PatternCount;
  AnimLooped := True;
  AnimSpeed := 15/1000;
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

{  TScrollBackground  }

procedure TScrollBackground.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
end;

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
 else
  result := 0; 
 end;
end;

end.
