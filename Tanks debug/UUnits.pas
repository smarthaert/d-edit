unit UUnits;

interface

uses
  Windows, SysUtils, Classes, DXClass, DXSprite, DXInput, DXDraws, DXSounds,
  MMSystem, Wave, UMap, Contnrs,Base,Dialogs,ULog,Pointers,UTankTypes;


{type
  TMonoSprite = class(TImageSprite)
  private
    FCounter: Double;
    FS: Integer;
    procedure Hit;
  public
    procedure DoMove(MoveCount: Integer); override;
  end;

  TPlayerSprite = class(TImageSprite)
  protected
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
    procedure DoMove(MoveCount: Integer); override;
  end;}

Const
  MaxTime=100000;
  MaxStep=8;
  TryDist=15;
  //MinExplosionBallDamage=250;
  DirChangeDelay=100;
  ConstMaxVisibleEnemies=40;
  MaxLivesDelay=2000;
  BonusLifeTime=15000;

Type
  TPlayerControlKey=(pkUP,pkDOWN,pkLEFT,pkRIGHT,pkFIRE1,pkFIRE2);
  TETCode=Record
    C:Char;
    T:String;
  End;

Type
  TSide=(siNone,siPlayer1,siPlayer2,siEnemy);
  TSideSet=Set of TSide;

Const
  PlayersSides:TSideSet=[siPlayer1,siPlayer2];

Type
  TPlayersCount=(pcPlayer1,pcPlayer2,pcTwoPlayers);

{ Движущийся обьект игры - танки, снаряды, вертолеты, ракеты }
type
  TClassGameObject=Class of TGameObject;
  TGameObject = class(TImageSprite)
  private
    FAlive:Boolean;
    function GetIntX: Integer;
    function GetIntY: Integer;
    function GetPointXY: TPoint;
    procedure SetIntX(const Value: Integer);
    procedure SetIntY(const Value: Integer);
    procedure SetPointXY(const Value: TPoint);
  protected
    {Общие для всех обьектов свойства}
    Dir : TDir;
    DirImages : TDirImages; { Буфер для картинок }
  public
    Side:TSide;
    Property Alive:Boolean
      Read FAlive;
//    procedure DoMove(MoveCount: Integer); override;
    Property IntX:Integer
      Read GetIntX
      Write SetIntX;
    Property IntY:Integer
      Read GetIntY
      Write SetIntY;
    Property PointXY:TPoint
      Read GetPointXY
      Write SetPointXY;
    Procedure Dead; Virtual;
    Constructor Create(AParent:TSprite);Override;
    procedure SetImage; virtual;
    Function GetCenterX:Integer;
    Function GetCenterY:Integer;
    Procedure SetCenter(Value:TPoint);
    Function CanBeAt(AX,AY:Integer):Boolean; Virtual;
    Function TryMove(Var Dist:Integer):Boolean;
    Function TryMoveFire(Var Dist:Integer):Boolean;
    Function TryBeAt(Var AX,AY:Integer):Boolean; Virtual;
    Function FireExplosionPoint:TPoint;
    Function IsEnemy(Sprite:TGameObject):Boolean;
    Function SpriteBounds:TRect;
  end;
  { Explosion }
  TExplosion=Class(TGameObject)
  Public
    Procedure Init(P:TPoint;AImageName:String);
    Procedure DoMove(MoveCount:Integer);Override;
  End;
  { Explosion ball }
  TExplosionBall=Class(TExplosion)
  Public
    Damage:Integer;
    Procedure Init(P:TPoint;AImageName:String;ADamage:Integer;ASide:TSide=siNone);
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
  End;

{ -- Описание типов танков -- }
type
  TTankType = Record
    Name : String;
    MaxHits : Integer;
    Armor : Integer;
    Speed : Integer;
    Upgrade : String;
  end;

var
  ImageList :TDXImageList;

{-- Описание снаряда --}
type
  TFire = class(TGameObject)
  private
  public
    Creator:TGameObject;
    WeaponType:PWeaponType;
    procedure Init(AWeaponType:PWeaponType; X_Init,Y_Init:Integer; Dir_Init:TDir; MoveCount:Integer;ACreator:TGameObject);
    procedure DoMove(MoveCount: Integer); override;
    Function CanBeAt(AX,AY:Integer):Boolean; Override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
    Procedure ExplosionDead; Virtual;
    Function ExplosionBall:Boolean;
  end;

type
  TTank = class(TGameObject)
  private
    LastShoot,DirTime : Integer;
    MyType : PTankType;
  public
    Life : Integer; { Жизненная энергия 0..MaxHits. MaxHits  }
    procedure Init( TankTypeName:String; X_Init,Y_Init:Integer; Dir_Init:TDir );
    procedure DoMove(MoveCount: Integer); override;
    Function DirExecute(NewDir:TDir;MoveCount:Integer):Boolean;
    Function CanBeAt(AX,AY:Integer):Boolean; Override;
    Function TryShoot(MoveCount:Integer):Boolean;
    Function TryTankBeAt(Var AX,AY:Integer):Integer;
    Function TryBeAt(Var AX,AY:Integer):Boolean; Override;
    Procedure CollisionFire(Sprite:TFire); Virtual;
    Function GetMaxLife:Integer;
    Function GetArmor:Integer;
    Function GetFireDelay:Integer;
    Function GetSpeed:Integer;
    Function GetUpgrade:String;
    Function GetWeapon1Type:PWeaponType;
    Procedure ExplosionDead; Virtual;
    Function TryMoveTank(Var Dist:Integer):Boolean;
    Function SmallStep(Var AX,AY:Integer;Step:Integer):Boolean;
    Procedure SetTankType(S:String);
    Procedure DoDamage(ADamage:Integer);
  end;

{-- Описание танка игрока --}
type
  TPlayerTank = class(TTank)
  private

  public
    PlayerNum:Byte;
    AutoFire,AutoFirePressed:Boolean;
    procedure DoMove(MoveCount: Integer); override;
    Procedure TestInit(APlayerNum:Byte;MX,MY:Integer);
    Procedure Dead;Override;
  end;

{ Приз }
type
  TBonus = class(TGameObject)
  private

  public
    BonusType:String;
    LifeTime:Integer;
    Procedure Init(ABonusType:String);
    procedure DoMove(MoveCount: Integer); override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
  end;

{-- Описание танка врага --}
type
  TEnemyTank = class(TTank)
  private

  public
    Infinite:Boolean;
    procedure DoMove(MoveCount: Integer); override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
    Procedure Init(AX,AY:Integer;TankTypeName:String;AInfinite:Boolean);
    Procedure ExplosionDead;Override;
  end;

{ Cтарт врагов }
Type
  TEnemySpawn=Class(TGameObject)
    SpawnTime,NextSpawnTime,SpawnCount:Integer;
    EnemyType:String;
    Procedure Init(AX,AY:Integer;AEnemyType:String='Enemy';ASpawnCount:Integer=-1;ASpawnTime:Integer=10000);
    procedure DoMove(MoveCount: Integer); override;
  End;

{ Телепорт }
Type
  TTeleport=Class(TGameObject)
    DX,DY:Integer;
    Procedure Init(AX,AY,ADX,ADY:Integer);
    procedure DoMove(MoveCount: Integer); override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
  End;

Var
  PlayerTanks:Array[1..2]of TPlayerTank;
  CoopPlay,WithoutEnemy:Boolean;
  EnemyCount,GameSkill,VisibleEnemies,CurrentMaxVisibleEnemies:Integer;
  PlayersCount:TPlayersCount;
  PlayerStartPos:Array[1..2]of TPoint;
  Lives,LivesDelay:Array [1..2] of Integer;

Function GetDirImages(Name:String):TDirImages;
Procedure MoveDir(Dir:TDir;Count:Integer;Var X,Y:Integer);
Function RearDir(Dir:TDir):TDir;
Function RandomDir:TDir;
Function GroundCollision(Sprite:TSprite):Boolean;
Procedure HandleTimeInc(Var N:Integer;MoveCount: Integer);
Function HandleTimeDec(Var N:Integer;MoveCount: Integer):Boolean;
function isPeres( R1,R2:TRect ):Boolean;
Function RandomEnemyType:String;
Function RandomBonusType:String;
//Procedure InitPlayer
function RectEmpty(R: TRect; C: TClassGameObject): Boolean;

Function EnemySpawnCount:Integer;
Function EnemySpawnTime:Integer;
Function CalcMaxVisibleEnemies:Integer;

procedure LoadMap(FileName: String; Engine:TSprite);

implementation

{procedure TMonoSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);
  PixelCheck := True;
  FCounter := FCounter + (100/1000)*MoveCount;
  X := X+Sin256(Trunc(FCounter))*(20/1000)*MoveCount;
  Y := Y+Cos256(Trunc(FCounter))*(20/1000)*MoveCount;

  if not Collisioned then
  begin
    Inc(FS, MoveCount);
    if FS>200 then Dead;
  end;
end;

procedure TMonoSprite.Hit;
begin
  Collisioned := False;

  Image := MainForm.ImageList.Items.Find('img1-2');
  MainForm.DXWaveList.Items.Find('snd').Play(False);
  MainForm.DXInput.Joystick.Effects.Find('eff1').Start;
end;

procedure TPlayerSprite.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
  if Sprite is TMonoSprite then
    TMonoSprite(Sprite).Hit;
  Done := False;
end;

procedure TPlayerSprite.DoMove(MoveCount: Integer);
begin
  inherited DoMove(MoveCount);

  if isUp in MainForm.DXInput.States then
    Y := Y - (300/1000)*MoveCount;
  if isDown in MainForm.DXInput.States then
    Y := Y + (300/1000)*MoveCount;
  if isLeft in MainForm.DXInput.States then
    X := X - (300/1000)*MoveCount;
  if isRight in MainForm.DXInput.States then
    X := X + (300/1000)*MoveCount;

  Collision;
end;}

{*********}

Function GetDirOneImage(Name:String):TDirImages;
Begin
  With ImageList.Items do
    Begin
      Result[_Up   ]:=Find(Name);
      Result[_Down ]:=Result[_Up   ];
      Result[_Left ]:=Result[_Up   ];
      Result[_Right]:=Result[_Up   ];
    End;
End;

Function GetDirImages(Name:String):TDirImages;
Begin
  With ImageList.Items do
    Begin
      Result[_Up   ]:=Find(Name+' U');
      Result[_Down ]:=Find(Name+' D');
      Result[_Left ]:=Find(Name+' L');
      Result[_Right]:=Find(Name+' R');
    End;
End;

Procedure MoveDir(Dir:TDir;Count:Integer;Var X,Y:Integer);
Begin
  Case Dir of
    _UP   :Dec(Y,Count);
    _DOWN :Inc(Y,Count);
    _LEFT :Dec(X,Count);
    _RIGHT:Inc(X,Count);
  End;
End;

Function RearDir(Dir:TDir):TDir;
Begin
  Case Dir of
    _UP   :Result:=_DOWN ;
    _DOWN :Result:=_UP   ;
    _LEFT :Result:=_RIGHT;
    Else
    {_RIGHT:}Result:=_LEFT ;
  End;
End;

Function RandomDir:TDir;
Begin
  Result:=TDir(Random(4));
End;


Function GroundCollision(Sprite:TSprite):Boolean;
Begin
  Result:=False;
  If Sprite Is TTank then
    Result:=True;
End;

Procedure HandleTimeInc(Var N:Integer;MoveCount: Integer);
Begin
  Inc(N,MoveCount);
  If N>MaxTime then
    N:=MaxTime;
End;

Function HandleTimeDec(Var N:Integer;MoveCount: Integer):Boolean;
Begin
  Dec(N,MoveCount);
  Result:=(N<0);
  If Result then
    N:=0;
End;

function isPeres( R1,R2:TRect ):Boolean;
begin
  isPeres := not (
    (R1.Right<R2.Left) or { R1 левее чем R2 }
    (R1.Left>R2.Right) or { R1 правее чем R2 }
    (R1.Bottom<R2.Top) or { R1 выше чем R2 }
    (R1.Top>R2.Bottom)); { R1 ниже чем R2 }
end;

Function RandomEnemyType:String;
Begin
  Case Random(100) of
    00..24:
      Result:='FatEnemy';
    90..99:
      Result:='Jeep';
    Else
      Result:='Enemy';
  End;
  If TankTypes.getType(Result)=Nil then Result:='Enemy';
End;

Function RandomBonusType:String;
Begin
  Case Random(100) of
    00..34:
      Result:='Upgrade';
    75..99:
      Result:='Live';
    Else
      Result:='Health';
  End;
End;

Function EnemySpawnCount:Integer;
Var
  I:Integer;
  R:Real;
Begin
  If GameSkill=1 then
    Begin
      Result:=3;
      Exit;
    End;
  R:=5;
  For I:=3 to GameSkill do
    R:=(R*1.2);
  Result:=Trunc(R);  
End;

Function EnemySpawnTime:Integer;
Var I:Integer;
Begin
  Result:=15000;
  For I:=2 to GameSkill do
    Result:=(Result*2) Div 3;
End;

Function CalcMaxVisibleEnemies:Integer;
Begin
  Result:=5+5*GameSkill;
  If Result>ConstMaxVisibleEnemies then
    Result:=ConstMaxVisibleEnemies;
End;


procedure LoadMap(FileName: String; Engine:TSprite);
Const
  ETCodesCount=3;
  ETCodes:Array [1..ETCodesCount] of TETCode=(
    (C:'E';T:'Enemy'     ),
    (C:'F';T:'FatEnemy'  ),
    (C:'T';T:'Tiger'     ));

Var
  F:Text;
  I,J,K,EST,ESC:Integer;
  S,ET:String;
  Tel:Array[3..10]of TPoint;
  TelSet:Set of 3..10;
begin
  TelSet:=[];
  ESC:=EnemySpawnCount;
  EST:=EnemySpawnTime;
  CurrentMaxVisibleEnemies:=CalcMaxVisibleEnemies;
  With MapContainer do
    Begin
      ClearMap;
      System.Assign(F,FileName);
      {$I-}
      System.Reset(F);
      {$I+}
      If IOResult<>0 then
        Begin
          ShowMessage('LoadMap: File '+FileName+' not found.');
          Exit;
        End;
      Readln(F);
      EnemyCount:=0;
      BasesCount:=0;
      VisibleEnemies:=0;
      For J:=1 to MapYSize do
        Begin
          ReadLn(F,S);
          For I:=1 to MapXSize do
            Begin
              If Length(S)<I then Break;
              Case S[I] of
                '#':Map[I,J]:=meWall;
                '@':Map[I,J]:=meDWall;
                '.':Map[I,J]:=meWater;
                '^':Map[I,J]:=meSlow;
                '3'..'9':
                  Begin
                    Map[I,J]:=meSpace;
                    K:=Ord(S[I])-Ord('0');
                    Include(TelSet,K);
                    Tel[K]:=Point(MapToPixel(I)+16,MapToPixel(J)+16);
                  End;
                '0':
                  Begin
                    Map[I,J]:=meSpace;
                    Include(TelSet,10);
                    Tel[10]:=Point(MapToPixel(I)+16,MapToPixel(J)+16);
                  End;
                '&':
                  Begin
                    Map[I,J]:=meBase;
                    Inc(BasesCount);
                  End;
                '1':
                  Begin
                    Map[I,J]:=meStart;
                    PlayerStartPos[1]:=Point(I,J);
                  End;
                '2':
                  Begin
                    Map[I,J]:=meStart;
                    PlayerStartPos[2]:=Point(I,J);
                  End;
                '*':
                  Begin
                    Map[I,J]:=meSpace;
                    {Case Random(3) of
                      1:ET:='FatEnemy';
                      2:ET:='Tiger';
                      Else
                        ET:='Enemy';
                    End;}
                    ET:='';
                    With TEnemySpawn.Create(MyDXSpriteEngine.Engine) do
                      Init(MapToPixel(I)+16,MapToPixel(J)+16,ET,ESC,EST);
                  End;
                Else
                  Map[I,J]:=meSpace;
                  For K:=1 to ETCodesCount do
                    With ETCodes[K] do
                      If S[I]=C then
                        Begin
                          With TEnemySpawn.Create(MyDXSpriteEngine.Engine) do
                            Init(MapToPixel(I)+16,MapToPixel(J)+16,T,ESC,EST);
                          Break;
                        End;
              End;
            End;
        End;
      System.Close(F);
      For K:=0 to 3 do
        Begin
          If
            (Not((K*2+3)In TelSet))Or
            (Not((K*2+4)In TelSet))then
            Continue;
          With TTeleport.Create(Engine) do
            Init(Tel[K*2+3].X,Tel[K*2+3].Y,Tel[K*2+4].X,Tel[K*2+4].Y);
        End;
      If BasesCount=0 then
        BasesCount:=1;
    End;
end;

function RectEmpty(R: TRect; C: TClassGameObject): Boolean;
Var I:Integer;
begin
  Result:=False;
  With MyDXSpriteEngine do
    For I:=0 to Engine.Count-1 do
      If Engine.Items[I] Is C then
        With Engine.Items[I] As TGameObject do
          Begin
            If Not Alive then Continue;
            If Not IsPeres(R,SpriteBounds) then Continue;
            Exit;
          End;
  Result:=True;
end;

{-- TFire --}

function TFire.CanBeAt(AX, AY: Integer): Boolean;
begin
  Result:=MapContainer.FireCanBeAt(Bounds(AX,AY,Width-1,Height-1));
end;

procedure TFire.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
  inherited;
  If Not Alive then Exit;
  If Sprite=Creator then Exit;
  if Sprite Is TTank then
    Begin
      If Not ExplosionBall then
        TTank(Sprite).CollisionFire(Self);
      ExplosionDead;
      Done:=True;
    End;
  If Sprite Is TFire then
    Begin
      If TFire(Sprite).Creator=Creator then Exit;
      TFire(Sprite).ExplosionDead;
      ExplosionDead;
      Done:=True;
    End;

end;

procedure TFire.DoMove(MoveCount: Integer);
var
  MoveDist:Integer;
  R:Boolean;
begin
  inherited;
  If Not Alive then Exit;
  MoveDist:=WeaponType.Speed*MoveCount Div 1000;
  R:=TryMoveFire(MoveDist);
  Collision;
  If Not Alive then Exit;
  If Not R then
    Begin
      ExplosionDead;
      Exit;
    End;
end;

function TFire.ExplosionBall: Boolean;
begin
  Result:=WeaponType.ExplosionBall;
end;

procedure TFire.ExplosionDead;
Const
  ERange=4;
Var
  P:TPoint;
  E:TExplosion;
  EB:TExplosionBall;
  R:Integer;
begin
  {R:=WeaponType.Damage Div 20;
  If R<1 then R:=1;}
  R:=1;
  If WeaponType.DoubleEarthDamage then R:=2;
  P:=FireExplosionPoint;
  MapContainer.SimpleFireDamage(P.X,P.Y,R,1,Dir);
  Inc(P.X,Random(ERange*2+1)-ERange);
  Inc(P.Y,Random(ERange*2+1)-ERange);
  Dead;
  If ExplosionBall then
    Begin
      EB:=TExplosionBall.Create(Engine);
      EB.Init(P,'100x100 Explosion',WeaponType.Damage,Side);
    End
    Else
    Begin
      E:=TExplosion.Create(Engine);
      E.Init(P,'Explosion 1');
    End;
end;

procedure TFire.Init(AWeaponType:PWeaponType; X_Init,Y_Init:Integer; Dir_Init:TDir; MoveCount:Integer;ACreator:TGameObject);
begin
  WeaponType:=AWeaponType;
  If WeaponType=Nil then
    ShowMessage('TFire: No weapon type');
  Creator:=ACreator;
  Side:=siEnemy;
  If Creator<>Nil then
    Begin
      Side:=Creator.Side;
    End;
  With WeaponType^ do
    If DirSprites then
      DirImages := GetDirImages(Sprite)
      Else
      DirImages := GetDirOneImage(Sprite);
  Dir:=Dir_Init;
  Width:=DirImages[_UP].Width;
  Height:=DirImages[_UP].Height;
  MoveDir(Dir,16,X_Init,Y_Init);
  SetCenter(Point(X_Init,Y_Init));
  Z:=2;
  SetImage;
  Move(MoveCount);
end;

{-- TTank --}
function TTank.CanBeAt(AX, AY: Integer): Boolean;
Var
  R,RC:TRect;
  I:Integer;
begin
  R:=Bounds(AX,AY,Width-1,Height-1);
  Result:=MapContainer.TankCanBeAt(R);
  If Not Result then Exit;
  With Engine do
    For I:=0 to Count-1 do
      If (Items[I] Is TTank)And(Items[I]<>Self) then
        With Items[I] As TTank do
          Begin
            RC:=Bounds(IntX,IntY,Width-1,Height-1);
            if isPeres(R,RC) then
              Begin
                Result:=False;
                Exit;
              End;
          End;
end;

procedure TTank.CollisionFire(Sprite: TFire);
begin
  If Sprite.IsEnemy(Self) then
    DoDamage(Sprite.WeaponType.Damage);
end;

Function TTank.DirExecute(NewDir: TDir;MoveCount:Integer):Boolean;
  {Function TryPos(PX,PY:Integer):Boolean;
  Begin
    If Not CanBeAt(PX,PY) then
      Begin
        Result:=False;
        Exit;
      End;
    Result:=True;
    X:=PX;
    Y:=PY;
  End;}
Var
  {I,OX,OY,IM,NX,NY,}MoveDist,Speed:Integer;
begin
  Result:=True;
  If NewDir<>Dir then
    Begin
      DirTime:=0;
      Dir:=NewDir;
      SetImage;
    End;
  If DirTime<DirChangeDelay then Exit;
  If DirTime-DirChangeDelay<MoveCount then
    MoveCount:=DirTime-DirChangeDelay;
  If MoveCount=0 then Exit;
  Speed:=GetSpeed;
  MoveDist:=Speed*MoveCount Div 1000;
  If (MoveDist=0)And(Speed<>0)And(Random(40 Div MoveCount)=0) then
    MoveDist:=1;
  Result:=TryMoveTank(MoveDist);
  {NX:=Trunc(X);
  NY:=Trunc(Y);
  OX:=NX;
  OY:=NY;}
  {Case NewDir of
    _UP   :NY := Y - MoveDist;
    _DOWN :NY := Y + MoveDist;
    _LEFT :NX := X - MoveDist;
    _RIGHT:NX := X + MoveDist;
  End;}
  {MoveDir(Dir,MoveDist,NX,NY);
  If TryPos(NX,NY) then Exit;
  Case Dir of
    _UP,_DOWN:
      Begin
        For I:=1 to TryDist do
          Begin
            If TryPos(NX+I,NY) then Exit;
            If TryPos(NX-I,NY) then Exit;
          End;
        IM:=Abs(NY-OY);
      End;
    Else
        For I:=1 to TryDist do
          Begin
            If TryPos(NX,NY+I) then Exit;
            If TryPos(NX,NY-I) then Exit;
          End;
        IM:=Abs(NX-OX);
  End;
  For I:=IM downto 1 do
    Begin
      MoveDir(Dir,-1,NX,NY);
      If TryPos(NX,NY) then Exit;
    End;}
end;

procedure TTank.DoMove(MoveCount: Integer);
begin
  inherited;
  If Not Alive then Exit;
  HandleTimeInc(DirTime,MoveCount);
  HandleTimeInc(LastShoot,MoveCount);
end;

procedure TTank.ExplosionDead;
Var
  E:TExplosion;
begin
  E:=TExplosion.Create(Engine);
  E.Init(Point(GetCenterX,GetCenterY),'Explosion 2');
  Dead;
end;

function TTank.GetArmor: Integer;
begin
  Result:=0;
  If MyType<>Nil then
    Result:=MyType.Armor;
  If Result=0 then
    Result:=10;
end;

function TTank.GetFireDelay: Integer;
begin
  Result:=0;
  If MyType<>Nil then
    If MyType.Weapon1<>Nil then
      Result:=MyType.Weapon1.FireDelay;
  If Result=0 then
    Result:=800;
end;

function TTank.GetMaxLife: Integer;
begin
  Result:=0;
  If MyType<>Nil then
    Result:=MyType.MaxHits;
  If Result=0 then
    Result:=100;
end;

function TTank.GetSpeed: Integer;
begin
  Result:=0;
  If MyType<>Nil then
    Result:=MyType.Speed;
  If Result=0 then
    Result:=150;
end;

procedure TTank.Init( TankTypeName:String; X_Init,Y_Init:Integer; Dir_Init:TDir );
Var IX,IY:Integer;
begin
  Dir:=Dir_Init;
  DirTime:=MaxTime;
  Width:=32;
  Height:=32;
  SetCenter(Point(X_Init,Y_Init));
  IX:=IntX;
  IY:=IntY;
  If Not TryBeAt(IX,IY) then
    MapContainer.Map[PixelToMap(IX),PixelToMap(IY)]:=meSpace;
  IntX:=IX;
  IntY:=IY;
  Z:=1;
  SetTankType(TankTypeName);
end;

{ TPlayerTank }

procedure TPlayerTank.Dead;
begin
  PlayerTanks[PlayerNum]:=Nil;
  LivesDelay[PlayerNum]:=MaxLivesDelay;
  If Lives[PlayerNum]>0 then
    Dec(Lives[PlayerNum]);
  inherited;
end;

procedure TPlayerTank.DoMove(MoveCount: Integer);
Const
  Keys:Array[1..2,TPlayerControlKey] of TDXInputState=
    (
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isUp      ,isDown    ,isLeft    ,isRight   ,isButton1 ,isButton2 ),
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isButton10,isButton11,isButton12,isButton13,isButton14,isButton15)
    );
Var
  NewDir:TDir;
  DirPressed,AF:Boolean;
begin
  inherited;
  If Not Alive then Exit;
  DirPressed:=False;
  if Keys[PlayerNum,pkUP   ] in MyDXInput.States then
    Begin
      NewDir:=_UP   ;
      DirPressed:=True;
    End;
  if Keys[PlayerNum,pkDOWN ] in MyDXInput.States then
    Begin
      NewDir:=_DOWN ;
      DirPressed:=True;
    End;
  if Keys[PlayerNum,pkLEFT ] in MyDXInput.States then
    Begin
      NewDir:=_LEFT ;
      DirPressed:=True;
    End;
  if Keys[PlayerNum,pkRIGHT] in MyDXInput.States then
    Begin
      NewDir:=_RIGHT;
      DirPressed:=True;
    End;
  If DirPressed then DirExecute(NewDir,MoveCount);
  AF:=(Keys[PlayerNum,pkFIRE2] in MyDXInput.States);
  If AF And (Not AutoFirePressed) then
    AutoFire:=Not AutoFire;
  AutoFirePressed:=AF;
  if (Keys[PlayerNum,pkFIRE1] in MyDXInput.States) Xor AutoFire then
    Begin
      TryShoot(MoveCount);
    End;
  Collision;
end;

procedure TPlayerTank.TestInit;
Var SpriteName : String;
begin
  AutoFire:=False;
  AutoFirePressed:=False;
  PlayerNum:=APlayerNum;
  SpriteName := 'Player';
  if PlayerNum = 2 then SpriteName:=SpriteName+'2';
  //Log('SpriteName = '+SpriteName);
  Inherited Init(SpriteName,MapToPixel(MX)+16,MapToPixel(MY)+16,_UP);
  If PlayerNum = 2 then
    Side:=siPlayer2
    Else
    Side:=siPlayer1;
  {SpriteName := 'Tank Player2';
  DirImages:=GetDirImages(SpriteName);}
End;

{ TGameObject }

function TGameObject.CanBeAt(AX,AY:Integer): Boolean;
begin
  Result:=True;
end;

constructor TGameObject.Create(AParent: TSprite);
begin
  inherited;
  FAlive:=True;
  Side:=siNone;
end;

procedure TGameObject.Dead;
begin
  FAlive:=False;
  inherited;
end;

function TGameObject.FireExplosionPoint: TPoint;
Var
  CX,CY:Integer;
  R:TRect;
begin
  CX:=GetCenterX;
  CY:=GetCenterY;
  R:=Bounds(IntX,IntY,Width-1,Height-1);
  With R do
    Case Dir Of
      _UP  :Result:=Point(CX   ,Top   );
      _Down:Result:=Point(CX   ,Bottom);
      _Left:Result:=Point(Left ,CY    );
      Else  Result:=Point(Right,CY    );
    End;
end;

function TGameObject.GetCenterX: Integer;
begin
  Result:=IntX+Width Div 2;
end;

function TGameObject.GetCenterY: Integer;
begin
  Result:=IntY+Height Div 2;
end;

function TGameObject.GetIntX: Integer;
begin
  Result:=Trunc(X);
end;

function TGameObject.GetIntY: Integer;
begin
  Result:=Trunc(Y);
end;

function TGameObject.GetPointXY: TPoint;
begin
  Result:=Point(IntX,IntY);
end;

function TGameObject.IsEnemy(Sprite: TGameObject): Boolean;
Var
  SS,SO:TSide;
begin
  Result:=False;
  SS:=Side;
  SO:=Sprite.Side;
  If (SS=siNone)Or(SO=siNone) then Exit;
  If
    (SS In PlayersSides)And
    (SO In PlayersSides)
    And CoopPlay
    then Exit;
  Result:=(SS<>SO);
end;

procedure TGameObject.SetCenter(Value: TPoint);
begin
  X:=Value.X-Width Div 2;
  Y:=Value.Y-Height Div 2;
end;

procedure TGameObject.SetImage;
begin
  Image:=DirImages[Dir];
end;

function TTank.TryTankBeAt(var AX,AY:Integer): Integer;
  Function TryPos(PX,PY:Integer):Boolean;
  Begin
    If Not CanBeAt(PX,PY) then
      Begin
        Result:=False;
        Exit;
      End;
    Result:=True;
    AX:=PX;
    AY:=PY;
  End;
Var
  I,CX,CY:Integer;
begin
  Result:=0;
  If Inherited TryBeAt(AX,AY) then Exit;
  CX:=AX;
  CY:=AY;
  Case Dir of
    _UP,_DOWN:
      Begin
        For I:=1 to TryDist do
          Begin
            Result:=I;
            If TryPos(CX+I,CY) then Exit;
            If TryPos(CX-I,CY) then Exit;
          End;
     End;
    Else
        For I:=1 to TryDist do
          Begin
            Result:=I;
            If TryPos(CX,CY+I) then Exit;
            If TryPos(CX,CY-I) then Exit;
          End;
  End;
  Result:=-1;
end;

function TTank.TryShoot(MoveCount:Integer): Boolean;
Var
  NewFire:TFire;
  Weapon:PWeaponType;
begin
  Result:=False;
  If LastShoot<GetFireDelay then Exit;
  Result:=True;
  LastShoot:=0;
  Weapon:=GetWeapon1Type;
  If Weapon=Nil then Exit;
  NewFire:=TFire.Create(Engine);
  NewFire.Init(Weapon,GetCenterX,GetCenterY,Dir,MoveCount,Self);
end;

procedure TGameObject.SetIntX(const Value: Integer);
begin
  X:=Value;
end;

procedure TGameObject.SetIntY(const Value: Integer);
begin
  Y:=Value;
end;

procedure TGameObject.SetPointXY(const Value: TPoint);
begin
  X:=Value.X;
  Y:=Value.Y;
end;

function TGameObject.SpriteBounds: TRect;
begin
  Result:=Bounds(IntX,IntY,Width-1,Height-1);
end;

function TGameObject.TryBeAt(var AX,AY:Integer): Boolean;
begin
  Result:=CanBeAt(AX,AY);
end;

function TGameObject.TryMove(var Dist: Integer): Boolean;
Var
  Moved,Step:Integer;
  P,L,T:TPoint;
begin
  Moved:=0;
  P:=Point(Trunc(X),Trunc(Y));
  L:=P;
  Result:=True;
  T:=P;
  If TryBeAt(T.X,T.Y) then
    While Moved<Dist do
      Begin
        P:=T;
        If Dist-Moved<MaxStep then
          Step:=Dist-Moved
          Else
          Step:=MaxStep;
        MoveDir(Dir,Step,P.X,P.Y);
        T:=P;
        If Not TryBeAt(T.X,T.Y) then
          Begin
            Result:=False;
            Break;
          End
          Else
          P:=T;
        Inc(Moved,Step);
        L:=P;
      End
    Else
    Result:=False;
  Dist:=Moved;
  X:=L.X;
  Y:=L.Y;
end;

function TGameObject.TryMoveFire(var Dist: Integer): Boolean;
Var
  IX,IY:Integer;
begin
  Result:=TryMove(Dist);
  If Result then Exit;
  IX:=IntX;
  IY:=IntY;
  If Not CanBeAt(IX,IY) then Exit;
  MoveDir(Dir,MaxStep,IX,IY);
  Inc(Dist,MaxStep);
  IntX:=IX;
  IntY:=IY;
end;

function TTank.TryMoveTank(var Dist: Integer): Boolean;
Var
  Moved,Step,Sh:Integer;
  P,L,T:TPoint;
  Slowed,F,Odd:Boolean;
  Procedure MoveWS(N:Integer);
  Begin
    If Slowed then
      Inc(Moved,N*2)
      Else
      Inc(Moved,N);
  End;
begin
  {If Dist=0 then
    Begin
      Result:=True;
      Exit;
    End;}
  Moved:=0;
  Sh:=0;
  P:=Point(IntX,IntY);
  L:=P;
  Result:=False;
  T:=P;
  Sh:=TryTankBeAt(T.X,T.Y);
  If Sh<>-1 then
    Begin
      L:=T;
      MoveWS(Sh);
      While Moved<Dist do
        Begin
          Odd:=False;
          Slowed:=(MapContainer.Map[
            PixelToMap(L.X+Width  Div 2),
            PixelToMap(L.Y+Height Div 2)
            ]=meSlow);
          P:=L;
          If Slowed then
            Begin
              Odd:=Boolean(((Dist-Moved)Mod 2)*Random(2));
              If Odd then
                Step:=(Dist-Moved)Div 2
                Else
                Step:=(Dist-Moved+1)Div 2
            End
            Else
            Step:=Dist-Moved;
          If Step>MaxStep then
            Begin
              Step:=MaxStep;
              Odd:=False;
            End;
          MoveDir(Dir,Step,P.X,P.Y);
          T:=P;
          {Case Dir of
            _UP,_DOWN:F:=HorizTryBeAt(T.X,T.Y);
            Else      F:= VertTryBeAt(T.X,T.Y);
          End;}
          Sh:=TryTankBeAt(T.X,T.Y);
          If Sh=-1 then
            If Not SmallStep(T.X,T.Y,Step) then
              Break;
          P:=T;
          MoveWS(Step);
          If Sh<>-1 then MoveWS(Sh);
          If Odd then
            Inc(Moved,2);
          L:=P;
        End;
    End;
  Result:=(Moved>=Dist);
  Dist:=Moved;
  X:=L.X;
  Y:=L.Y;
end;

{ TExplosion }

procedure TExplosion.DoMove(MoveCount: Integer);
begin
  inherited;
  If AnimSpeed=0 then Dead;
end;

procedure TExplosion.Init(P:TPoint; AImageName: String);
begin
  Z:=3;
  Image:=ImageList.Items.Find(AImageName);
  Width:=Image.Width;
  Height:=Image.Height;
  AnimStart:=0;
  AnimLooped:=False;
  AnimCount:=Image.PatternCount;
  AnimSpeed:=10/1000;
  SetCenter(P);
end;

{ TEnemyTank }

procedure TEnemyTank.DoCollision(Sprite:TSprite;Var Done:Boolean);
begin
  inherited;
  If Not Alive then Exit;
  If Not(Sprite Is TFire) then Exit;
  //CollisionFire(TFire(Sprite));
  //Done:=True;
end;

procedure TEnemyTank.DoMove(MoveCount: Integer);
Var NewDir:TDir;
begin
  inherited;
  If Not Alive then Exit;
  If (Not DirExecute(Dir,MoveCount)){Or(Random(1000 Div MoveCount)=0)} then
    Begin
      NewDir:=RandomDir;
      //NewDir:=TDir(Random(4));
      DirExecute(NewDir,0);
    End;
  If Random(25)=0 then
    TryShoot(MoveCount);
  Collision;
end;

procedure TEnemyTank.ExplosionDead;
begin
  If Not Alive then Exit;
  If Not Infinite then Dec(EnemyCount);
  Dec(VisibleEnemies);
  inherited;
  If Random(10)=0 then
    With TBonus.Create(Engine) do
      Init('');
end;

procedure TEnemyTank.Init(AX, AY: Integer; TankTypeName: String;AInfinite:Boolean);
begin
  Inherited Init(TankTypeName,AX,AY,RandomDir);
  Side:=siEnemy;
  Inc(VisibleEnemies);
end;

{ TBonus }

procedure TBonus.DoCollision(Sprite:TSprite; Var Done:Boolean);
Var S:String;
begin
  inherited;
  If Not Alive then Exit;
  If Not(Sprite Is TPlayerTank) then Exit;
  With Sprite As TPlayerTank do
    Begin
      If Not Alive then Exit;
      If BonusType='Health' then
        If Life<GetMaxLife then
          Life:=GetMaxLife
          Else
          Exit;
      If BonusType='Death' then
        ExplosionDead;
      If BonusType='Upgrade' then
        Begin
          S:=GetUpgrade;
          If S='' then Exit;
          SetTankType(S);
        End;
      If BonusType='Live' then
        Inc(Lives[PlayerNum]);
    End;
  Dead;
end;

procedure TBonus.DoMove(MoveCount: Integer);
begin
  inherited;
  If Not Alive then Exit;
  If HandleTimeDec(LifeTime,MoveCount) then
    Begin
      Dead;
      Exit;
    End;
  Collision;
end;

procedure TBonus.Init(ABonusType: String);
begin
  If ABonusType='' then
    BonusType:=RandomBonusType
    Else
    BonusType:=ABonusType;
  Image:=ImageList.Items.Find('Bonus '+BonusType);
  Z:=4;
  Width:=Image.Width;
  Height:=Image.Height;
  IntX:=Random(32*MapXSize-Width);
  IntY:=Random(32*MapYSize-Height);
  LifeTime:=BonusLifeTime;
end;

{ TEnemySpawn }

procedure TEnemySpawn.DoMove(MoveCount: Integer);
Var
  ET:TEnemyTank;
  S:String;
begin
  inherited;
  If SpawnCount=0 then Exit;
  If Not HandleTimeDec(NextSpawnTime,MoveCount) then Exit;
  If VisibleEnemies>=CurrentMaxVisibleEnemies then Exit;
  If WithoutEnemy then Exit;
  If Not RectEmpty(Bounds(GetCenterX-16,GetCenterY-16,31,31),TTank) then Exit;
  { Можно ставить }
  If EnemyType='' then
    S:=RandomEnemyType
    Else
    S:=EnemyType;
  ET:=TEnemyTank.Create(Engine);
  ET.Init(GetCenterX,GetCenterY,S,(SpawnCount=-1));
  NextSpawnTime:=SpawnTime;
  If SpawnCount<>-1 then Dec(SpawnCount);
end;

procedure TEnemySpawn.Init(AX, AY:Integer;AEnemyType:String;ASpawnCount:Integer;ASpawnTime: Integer);
begin
  EnemyType:=AEnemyType;
  SpawnTime:=ASpawnTime;
  SpawnCount:=ASpawnCount;
  If (SpawnCount<>-1) then Inc(EnemyCount,SpawnCount);
  Z:=0;
  Image:=ImageList.Items.Find('EnemySpawn');
  Width:=Image.Width;
  Height:=Image.Height;
  SetCenter(Point(AX,AY));
  NextSpawnTime:=Random(SpawnTime);
end;

function TTank.SmallStep(Var AX,AY:Integer;Step: Integer): Boolean;
  Function TryPos(PX,PY:Integer):Boolean;
  Begin
    If Not CanBeAt(PX,PY) then
      Begin
        Result:=False;
        Exit;
      End;
    Result:=True;
    AX:=PX;
    AY:=PY;
  End;
Var CX,CY,I:Integer;
begin
  Result:=True;
  CX:=AX;
  CY:=AY;
  For I:=Step-1 downto 1 do
    Begin
      MoveDir(Dir,-1,CX,CY);
      If TryPos(CX,CY) then Exit;
    End;
  Result:=False;
end;

procedure TTank.SetTankType(S: String);
begin
  MyType:=TankTypes.getType(S);
  If MyType=Nil then Exit;
  Life:=GetMaxLife;
  DirImages:=GetDirImages('Tank '+MyType^.Name);
  LastShoot:=MaxTime;
  SetImage;
end;

function TTank.GetUpgrade: String;
begin
  Result:='';
  If MyType<>Nil then
    Result:=MyType.Upgrade;
end;

{ TTeleport }

procedure TTeleport.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
  inherited;
  If Not(Sprite Is TTank) then Exit;
  With Sprite As TTank do
    Begin
      If CanBeAt(DX-16,DY-16) then
        Begin
          IntX:=DX-16;
          IntY:=DY-16;
        End;
      Done:=True;
    End;
end;

procedure TTeleport.DoMove(MoveCount: Integer);
begin
  inherited;
  Collision;
end;

procedure TTeleport.Init(AX, AY, ADX, ADY: Integer);
begin
  DX:=ADX;
  DY:=ADY;
  Z:=0;
  Image:=ImageList.Items.Find('Teleport');
  Width:=Image.Width;
  Height:=Image.Height;
  SetCenter(Point(AX,AY));
end;

function TTank.GetWeapon1Type: PWeaponType;
begin
  Result:=Nil;
  If MyType=Nil then Exit;
  Result:=MyType.Weapon1;
end;

procedure TTank.DoDamage(ADamage: Integer);
begin
  If Not Alive then Exit;
  Dec(Life,ADamage);
  If Life>0 then Exit;
  ExplosionDead;
end;

{ TExplosionBall }

procedure TExplosionBall.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
  inherited;
  If Not(Sprite Is TGameObject) then Exit;
  With Sprite As TGameObject do
    Begin
      If Not Alive then Exit;
      If Sqr(GetCenterX-Self.GetCenterX)+Sqr(GetCenterY-Self.GetCenterY)>Sqr(Self.Height Div 2) then Exit;
      If Sprite Is TFire then
        Begin
          TFire(Sprite).ExplosionDead;
          Exit;
        End;
      If Sprite Is TTank then
        If Self.IsEnemy(TTank(Sprite)) then
          TTank(Sprite).DoDamage(Damage);
    End;
end;

procedure TExplosionBall.Init(P: TPoint; AImageName: String; ADamage:Integer;ASide:TSide);
begin
  Inherited Init(P,AImageName);
  Side:=ASide;
  Damage:=ADamage;
  Collision;
end;

function TTank.TryBeAt(var AX, AY: Integer): Boolean;
begin
  Result:=(TryTankBeAt(AX,AY)<>-1);
end;

end.
