unit UUnits;

interface

uses
  Windows, SysUtils, Classes, DXClass, DXSprite, DXInput, DXDraws, DXSounds,
  MMSystem, Wave, UMap, Contnrs,Base,Dialogs,ULog,Pointers,UTankTypes,Graphics,UFPS,USkill;

// Измерение FPSCallCounter

//{$Define CCCanBeAt} //(500-1000) 200-500
//{$Define CCTankDoMove} //120
//{$Define CCTankTryPos} //0-2

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
  MaxLivesDelay=2000;
  BonusShieldTime=15000;
  StartShieldTime=5000;
  BonusLifeTime=15000;
  ShieldFPS=6;
  MaxGameSkill=20;
  DefaultGameSkill=10;
  ETMoveDirDelay=50000;

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
    Function TryMove(Var Dist:Integer):Boolean; Virtual;
    Function TryMoveFire(Var Dist:Integer):Boolean;
    Function TryBeAt(Var AX,AY:Integer):Boolean; Virtual;
    Function FireExplosionPoint:TPoint;
    Function IsEnemy(Sprite:TGameObject):Boolean;
    Function SpriteBounds:TRect;
    Function TryExtend(R:TRect;MEFullSet,MERazedSet:TMESet;CantBeOn:TClassGameObject;NDir:TDir;Var Dist:Integer):Boolean;
  end;
  TCObject=TGameObject; { Сталкивающийся со снарядом спрайт }
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
  TFire = class(TCObject)
  private
  public
    Creator:TGameObject;
    WeaponType:PWeaponType;
    procedure Init(AWeaponType:PWeaponType; X_Init,Y_Init:Integer; Dir_Init:TDir; MoveCount:Integer;ACreator:TGameObject);
    procedure DoMove(MoveCount: Integer); override;
    Function CanBeAt(AX,AY:Integer):Boolean; Override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
    Procedure ExplosionDead(EarthDamage:Boolean); Virtual;
    Function ExplosionBall:Boolean;
    Function TryMove(Var Dist:Integer):Boolean; Override;
  end;

type
  TTank = class(TCObject)
  private
    LastShoot,DirTime,OverMoved : Integer;
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
    Procedure DoDamage(ADamage:Integer); Virtual;
  end;

{-- Описание танка игрока --}
type
  TPlayerTank = class(TTank)
  private
    FShieldTime: Longint;
    procedure SetShieldTime(const Value: Longint);
  private
    ShieldSprite:TImageSprite;
    Property ShieldTime:Longint
      Read FShieldTime
      Write SetShieldTime;
  public
    PlayerNum:Byte;
    AutoFire,AutoFirePressed:Boolean;
    procedure DoMove(MoveCount: Integer); override;
    Procedure TestInit(APlayerNum:Byte;MX,MY:Integer);
    Procedure Dead;Override;
    Procedure DoDamage(Damage:Integer);Override;
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
    MoveDirTime:Integer;
    procedure DoMove(MoveCount: Integer); override;
    //procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
    Procedure Init(AX,AY:Integer;TankTypeName:String;AInfinite:Boolean);
    Procedure ExplosionDead;Override;
    Procedure RndMoveDirTime;
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
  TTeleportClass=Class(TGameObject)
    TelNum:Integer;
    Constructor Create(AParent:TSprite;ATelNum:Integer);
    Procedure DoDraw; Override;
  End;
  TTeleportDest=Class(TTeleportClass)
    Constructor Create(AParent:TSprite;AX,AY,ATelNum:Integer);
  End;
  TTeleport=Class(TTeleportClass)
    DX,DY:Integer;
    Constructor Create(AParent:TSprite;AX,AY,ADX,ADY,ATelNum:Integer);
    procedure DoMove(MoveCount: Integer); override;
    procedure DoCollision(Sprite:TSprite; Var Done:Boolean); override;
  End;

Var
  PlayerTanks:Array[1..2]of TPlayerTank;
  CoopPlay,WithoutEnemy:Boolean;
  EnemyCount,VisibleEnemies,CurrentMaxVisibleEnemies:Integer;
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
function isPeres(Const R1,R2:TRect ):Boolean;
Function RandomEnemyType:String;
Function RandomBonusType:String;
//Procedure InitPlayer
function RectEmpty(Const R: TRect;Const C: TClassGameObject): Boolean;
function ExtendEmptyRect(Const R:TRect;Const NDir:TDir;Const C: TClassGameObject; _S:TGameObject): Integer;

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

Uses URedefineKeys;

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

function isPeres(Const R1,R2:TRect ):Boolean;
begin
  isPeres := not (
    (R1.Right<R2.Left) or { R1 левее чем R2 }
    (R1.Left>R2.Right) or { R1 правее чем R2 }
    (R1.Bottom<R2.Top) or { R1 выше чем R2 }
    (R1.Top>R2.Bottom)); { R1 ниже чем R2 }
end;

Function RandomEnemyType:String;
Var
  S,R,I,N:Integer;
  T:PTankType;
Begin
  Result:='Enemy';
  With TankTypes do
    Begin
      S:=SumRndPart;
      If S=0 then Exit;
      R:=Random(S);
      N:=0;
      For I:=0 to GetCount-1 do
        Begin
          T:=GetTypeIndex(I);
          Inc(N,T.RndPart);
          If N<=R then Continue;
          Result:=T.Name;
          Break;
        End;
      If Not CanBeType(Result) then Result:='Enemy';
    End;
  {Case Random(100) of
    00..24:
      Result:='FatEnemy';
    25..44:
      Result:='Machinegun';
    90..99:
      Result:='Jeep';
    Else
      Result:='Enemy';
  End;}
End;

Function RandomBonusType:String;
Begin
  Case Random(100) of
    00..34:
      Result:='Upgrade';
    35..59:
      Result:='Live';
    {60..69:
      Result:='Shield';}
    Else
      Result:='Health';
  End;
End;

procedure LoadMap(FileName: String; Engine:TSprite);
{Const
  ETCodesCount=5;
  ETCodes:Array [1..ETCodesCount] of TETCode=(
    (C:'E';T:'Enemy'     ),
    (C:'F';T:'FatEnemy'  ),
    (C:'T';T:'Tiger'     ),
    (C:'M';T:'Machinegun'),
    (C:'J';T:'Jeep'      ));}

Var
  F:Text;
  I,J,K,EST,ESC:Integer;
  S,ET:String;
  Tel:Array[3..10]of TPoint;
  TelSet:Set of 3..10;
  TS,TD:Byte;
  T:PTankType;
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
                '/':Map[I,J]:=meDiagUR;
                '\':Map[I,J]:=meDiagUL;
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
                  If S[I] in ['A'..'Z','a'..'z'] then
                    With TankTypes do
                      For K:=0 to GetCount-1 do
                        Begin
                          T:=GetTypeIndex(K);
                          If S[I]=T.MapChar then
                            Begin
                              With TEnemySpawn.Create(MyDXSpriteEngine.Engine) do
                                Init(MapToPixel(I)+16,MapToPixel(J)+16,T.Name,ESC,EST);
                              Break;
                            End;
                        End;
              End;
            End;
        End;
      System.Close(F);
      For K:=0 to 3 do
        Begin
          TS:=K*2+3;
          TD:=K*2+4;
          If
            (Not(TS In TelSet))Or
            (Not(TD In TelSet))then
            Continue;
          TTeleport.Create(Engine,Tel[TS].X,Tel[TS].Y,Tel[TD].X,Tel[TD].Y,K+1);
        End;
      If BasesCount=0 then
        BasesCount:=1;
    End;
end;

function RectEmpty(Const R: TRect;Const C: TClassGameObject): Boolean;
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

function ExtendEmptyRect(Const R:TRect;Const NDir:TDir;Const C: TClassGameObject; _S:TGameObject): Integer;
Const
  MapBorder=0;
Var
  I:Integer;
  ER,SB:TRect;
Begin
  ER:=R;
  With ER do
    Begin
      Case NDir of
        _UP   :Top   :=   -MapBorder;
        _DOWN :Bottom:=480+MapBorder;
        _LEFT :Left  :=   -MapBorder;
        _RIGHT:Right :=640+MapBorder;
      End;
      With MyDXSpriteEngine.Engine,ER do
        For I:=0 to Count-1 do
          If (Items[I] Is C)And(Items[I]<>_S) then
            With Items[I] As TGameObject do
              Begin
                If Not Alive then Continue;
                SB:=SpriteBounds;
                If Not IsPeres(ER,SB) then Continue;
                Case NDir of
                  _UP   :Top   :=SB.Bottom+1;
                  _DOWN :Bottom:=SB.Top   -1;
                  _LEFT :Left  :=SB.Right +1;
                  _RIGHT:Right :=SB.Left  -1;
                End;
                //If (ER.Top>ER.Bottom)Or(ER.Left>ER.Right) then
              End;
      Case NDir of
        _UP   :Result:=R.Top   -  Top   ;
        _DOWN :Result:=  Bottom-R.Bottom;
        _LEFT :Result:=R.Left  -  Left  ;
        _RIGHT:Result:=  Right -R.Right ;
        Else
          Result:=-100;
          ShowMessage('ExtendEmptyRect : Unknown dir');
      End;
    End;
End;

{-- TFire --}

function TFire.CanBeAt(AX, AY: Integer): Boolean;
begin
  Result:=MapContainer.FireCanBeAt(Bounds(AX,AY,Width-1,Height-1));
  {$Ifdef CCCanBeAt}
  Inc(FPSCallCounter);
  {$EndIf}
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
      ExplosionDead(False);
      Done:=True;
    End;
  If Sprite Is TFire then
    Begin
      If TFire(Sprite).Creator=Creator then Exit;
      TFire(Sprite).ExplosionDead(False);
      ExplosionDead(False);
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
      ExplosionDead(True);
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
  //CRR:TRect;
begin
  {R:=WeaponType.Damage Div 20;
  If R<1 then R:=1;}
  {Case Dir of
  _UP
  End;}
  P:=FireExplosionPoint;
  If EarthDamage then
    Begin
      R:=1;
      If WeaponType.DoubleEarthDamage then R:=2;
      MapContainer.SimpleFireDamage(P.X,P.Y,R,1,Dir);
    End;
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
  Width:=8{DirImages[_UP].Width};
  Height:=8{DirImages[_UP].Height};
  MoveDir(Dir,16,X_Init,Y_Init);
  SetCenter(Point(X_Init,Y_Init));
  Z:=2;
  SetImage;
  Move(MoveCount);
end;

function TFire.TryMove(var Dist: Integer): Boolean;
Var
  R,IX,IY,N:Integer;
  SB:TRect;
begin
  SB:=SpriteBounds;
  {N:=ExtendEmptyRect(SB,Dir,TCObject,Self);
  If Dist>N then Dist:=N;}
  R:=MapContainer.CheckExtendRound(SB,Dir,Dist,MEFireCanBe,MERazeable);
  //R:=TryExtend(SpriteBounds,MEFireCanBe,MERazeable,TCObject,Dir,Dist);
  Result:=(R>=Dist);
  Dist:=R;
  IX:=IntX;
  IY:=IntY;
  MoveDir(Dir,Dist,IX,IY);
  IntX:=IX;
  IntY:=IY;
end;

{-- TTank --}
function TTank.CanBeAt(AX, AY: Integer): Boolean;
Var
  R,RC:TRect;
  I:Integer;
begin
  {$Ifdef CCCanBeAt}
  Inc(FPSCallCounter);
  {$EndIf}
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
  {I,OX,OY,IM,NX,NY,}MoveDist{,Speed,Dist}:Integer;
begin
  Result:=True;
  If NewDir<>Dir then
    Begin
      DirTime:=0;
      Dir:=NewDir;
      SetImage;
    End;
  If (DirTime<DirChangeDelay)Or(MoveCount<=0) then Exit;
  {If DirTime-DirChangeDelay<MoveCount then
    MoveCount:=DirTime-DirChangeDelay;
  If MoveCount=0 then Exit;
  Speed:=GetSpeed;
  MoveDist:=Speed*MoveCount Div 1000;
  If (MoveDist=0)And(Speed<>0)And(Random(40 Div MoveCount)=0) then
    MoveDist:=1;}
  MoveDist:=-OverMoved;
  If MoveDist<=0 then Exit;
  Result:=TryMoveTank(MoveDist);
  Inc(OverMoved,MoveDist);
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
Var MC,MoveDist,Speed:Integer;
begin
  inherited;
  If Not Alive then Exit;
  {$Ifdef CCTankDoMove}
  Inc(FPSCallCounter);
  {$EndIf}
  HandleTimeInc(DirTime,MoveCount);
  HandleTimeInc(LastShoot,MoveCount);
  // неиспользованное движение не передается к следуещему ходу
  If OverMoved<0 then OverMoved:=0;
  // Если танк еще не закончил поворачивать
  If DirTime<DirChangeDelay then Exit;

  MC:=MoveCount;
  // С момента, когда танк закончил поворачивать
  If DirTime-DirChangeDelay<MC then
    MC:=DirTime-DirChangeDelay;

  If MC=0 then Exit;
  Speed:=GetSpeed;
  MoveDist:=Speed*MC Div 1000;
  If (MoveDist=0)And(Speed<>0)And(Random(40 Div MoveCount)=0) then
    MoveDist:=1;
  Dec(OverMoved,MoveDist);
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
  OverMoved:=0;
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

procedure TPlayerTank.DoDamage(Damage: Integer);
begin
  If ShieldTime<>0 then Exit;
  inherited;
end;

procedure TPlayerTank.DoMove(MoveCount: Integer);
(*Const
  Keys:Array[1..2,TPlayerControlKey] of TDXInputState=
    (
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isUp      ,isDown    ,isLeft    ,isRight   ,isButton1 ,isButton2 ),
    {Up        ,Down      ,Left      ,Right     ,Fire 1    ,Fire 2    }
    (isButton10,isButton11,isButton12,isButton13,isButton14,isButton15)
    );*)
Var
  NewDir:TDir;
  DirPressed,AF:Boolean;
begin
  inherited;
  If Not Alive then Exit;
  If ShieldTime>0 then
    Begin
      If ShieldTime>MoveCount then
        ShieldTime:=ShieldTime-MoveCount
        Else
        ShieldTime:=0;
    End;
  DirPressed:=False;
  {Keys[PlayerNum,pkLEFT ] in MyDXInput.States}
  With RedefineKeysMenu,MyDXInput.Keyboard do
    Begin
      if Keys[CurrentKeys[PlayerNum,pkUP   ]] then
        Begin
          NewDir:=_UP   ;
          DirPressed:=True;
        End;
      if Keys[CurrentKeys[PlayerNum,pkDOWN ]] then
        Begin
          NewDir:=_DOWN ;
          DirPressed:=True;
        End;
      if Keys[CurrentKeys[PlayerNum,pkLEFT ]] then
        Begin
          NewDir:=_LEFT ;
          DirPressed:=True;
        End;
      if Keys[CurrentKeys[PlayerNum,pkRIGHT]] then
        Begin
          NewDir:=_RIGHT;
          DirPressed:=True;
        End;
      If DirPressed then DirExecute(NewDir,MoveCount);
      AF:=Keys[CurrentKeys[PlayerNum,pkFIRE2]];
      If AF And (Not AutoFirePressed) then
        AutoFire:=Not AutoFire;
      AutoFirePressed:=AF;
      if Keys[CurrentKeys[PlayerNum,pkFIRE1]] Xor AutoFire then
        Begin
          TryShoot(MoveCount);
        End;
    End;
  Collision;
end;

procedure TPlayerTank.SetShieldTime(const Value: Longint);
Var F:Boolean;
begin
  FShieldTime := Value;
  If ShieldSprite=Nil then Exit;
  If (Value<=2000)And(Value>0) then
    { Мерцание Shield`а в последние 2 секунды }
    F:=((Value Mod 200)>=100)
    Else
    { Если Shield есть }
    F:=(Value<>0);
  If F=ShieldSprite.Visible then Exit;
  ShieldSprite.Visible:=F;
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
  ShieldSprite:=TImageSprite.Create(Self);
  With ShieldSprite do
    Begin
      Image:=ImageList.Items.Find('Shield');
      AnimLooped:=True;
      AnimCount:=Image.PatternCount;
      AnimSpeed:=ShieldFPS/1000;
      AnimStart:=0;
      X:=Self.Width div 2;
      Y:=Self.Height div 2;
      Z:=1;
      {Width:=Image.Width;
      Height:=Image.Height;}
    End;
  { ShieldTime - property }
  ShieldTime:=StartShieldTime;
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
    {$Ifdef CCTankTryPos}
    Inc(FPSCallCounter);
    {$EndIf}
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

function TGameObject.TryExtend(R:TRect;MEFullSet, MERazedSet: TMESet; CantBeOn:TClassGameObject; NDir: TDir;
  var Dist: Integer): Boolean;
Var
  N,M:Integer;
begin
  N:=ExtendEmptyRect(R,NDir,CantBeOn,Self);
  If N<0 then N:=0;
  If Dist<N then N:=Dist;
  M:=MapContainer.CheckExtend(R,NDir,N,MEFullSet,MERazedSet);
  Result:=(M<Dist);
  Dist:=M;
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
  //N:=Dist;
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
  Slowed,Odd:Boolean;
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

{procedure TEnemyTank.DoCollision(Sprite:TSprite;Var Done:Boolean);
begin
  inherited;
  If Not Alive then Exit;
  If Not(Sprite Is TFire) then Exit;
  //CollisionFire(TFire(Sprite));
  //Done:=True;
end;}

procedure TEnemyTank.DoMove(MoveCount: Integer);
Const
  //EnemyRotateTime=16000;
  EnemySlideTime=300;
Var
  NewDir:TDir;
  Rotate,Sliding:Boolean;
  FX,FY{,Speed,MoveDist}:Integer;
  Function RandomTime(N:Integer):Boolean;
  Begin
    {Result:=False;
    If MoveDist=0 then Exit;}
    Result:=(Random(N Div MoveCount)=0);
  End;
begin
  inherited;
  If Not Alive then Exit;
  Rotate:=Not DirExecute(Dir,MoveCount);
  FX:=IntX;
  FY:=IntY;
  MoveDir(Dir,1,FX,FY);
  Sliding:=((Not Rotate) And (Not CanBeAt(FX,FY)));
  {Speed:=GetSpeed;
  MoveDist:=MoveCount Div 1000+1;}
  If HandleTimeDec(MoveDirTime,MoveCount) then
    Begin
      RndMoveDirTime;
      If Random(2)=0 then Rotate:=True;
    End;
  //If RandomTime((EnemyRotateTime*200) Div GetSpeed) then Rotate:=True;
  If
    Sliding And
    RandomTime(EnemySlideTime) then Rotate:=True;
  If Rotate then
    Begin
      RndMoveDirTime;
      NewDir:=RandomDir;
      //NewDir:=TDir(Random(4));
      DirExecute(NewDir,0);
    End;
  If Random(MyType.Weapon1.FireDelay Div (MoveCount*4))=0 then
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
  RndMoveDirTime;
end;

procedure TEnemyTank.RndMoveDirTime;
Var N:Longint;
begin
  N:=ETMoveDirDelay*200 Div GetSpeed;
  MoveDirTime:=Trunc(N-
    ((Sqr(Random((N+1)*2))/N/4)));
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
      If BonusType='Shield' then
        ShieldTime:=BonusShieldTime;
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
  Repeat
    IntX:=Random(32*MapXSize-Width);
    IntY:=Random(32*MapYSize-Height);
  Until RectEmpty(Bounds(IntX,IntY,Width-1,Height-1),TPlayerTank);  
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
//Var OX,OY:Integer;
//Var D:Integer;
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
  { TMapContainer.CheckExtendRound с точностью до MaxStep !!!!}
  { meDiag }
  {OX:=AX;
  OY:=AY;
  MoveDir(Dir,-Step,AX,AY);
  TryExtend(Bounds(AX,AY,Width-1,Height-1),METankCanBe,MERazeable,TTank,Dir,Step);
  If Step<=0 then
    Begin
      Result:=False;
      AX:=OX;
      AY:=OY;
      Exit;
    End;
  MoveDir(Dir,Step,AX,AY);
  Result:=True;}
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

Constructor TTeleport.Create(AParent:TSprite;AX, AY, ADX, ADY,ATelNum: Integer);
begin
  Inherited Create(AParent,ATelNum);
  Image:=ImageList.Items.Find('Teleport');
  Width:=Image.Width;
  Height:=Image.Height;
  SetCenter(Point(AX,AY));
  DX:=ADX;
  DY:=ADY;
  TTeleportDest.Create(AParent,DX,DY,ATelNum);
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
          TFire(Sprite).ExplosionDead(False);
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

{ TTeleportClass }

constructor TTeleportClass.Create(AParent: TSprite; ATelNum: Integer);
begin
  inherited Create(AParent);
  TelNum:=ATelNum;
  Z:=0;
end;

procedure TTeleportClass.DoDraw;
Var C:Char;
begin
  inherited;
  If (TelNum<1)Or(TelNum>26) then Exit;
  With Engine.Surface.Canvas do
    Begin
      C:=Chr(Ord('A')+TelNum-1);
      Font.Color:=clBlack;
      Brush.Style:=bsClear;
      Font.Size:=8;
      Font.Style:=[];
      TextOut(
        Trunc(WorldX)+(Width-TextWidth(C)) div 2,
        Trunc(WorldY)+(Height-TextHeight(C)) div 2,C);
      Release;
    End;
end;

{ TTeleportDest }

constructor TTeleportDest.Create(AParent: TSprite; AX, AY,
  ATelNum: Integer);
begin
  Inherited Create(AParent,ATelNum);
  Image:=ImageList.Items.Find('Teleport exit');
  Width:=Image.Width;
  Height:=Image.Height;
  SetCenter(Point(AX,AY));
end;

end.
