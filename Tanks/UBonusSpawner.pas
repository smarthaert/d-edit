unit UBonusSpawner;

interface

Type
  TOneBonusSpawner=Class(TObject)
    NextSpawn,MaxSpawnDelay,MinSpawnDelay:Integer;
    BonusType:String;
    Enabled:Boolean;
    Constructor Create(ABonusType:String;AMaxSpawnDelay:Integer;AMinSpawnDelay:Integer=0);
    Procedure Step(MoveCount:Longint);
    Procedure RndNextSpawn;
    Procedure Reset;
  End;

Type
  TBonusSpawner=Class(TObject)
    Spawners:Array of TOneBonusSpawner;
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Step(MoveCount:Longint);
    Procedure Add(NewSpawner:TOneBonusSpawner);
    Procedure Reset;
    function GetSpawner(Name:String):TOneBonusSpawner;
    procedure SetEnabled(Name:String;AEnabled:Boolean);
  End;

Var BonusSpawner:TBonusSpawner;

implementation

Uses UUnits,Pointers;

{ TOneBonusSpawner }

constructor TOneBonusSpawner.Create(ABonusType: String; AMaxSpawnDelay,
  AMinSpawnDelay: Integer);
begin
  Inherited Create;
  BonusType:=ABonusType;
  MaxSpawnDelay:=AMaxSpawnDelay;
  MinSpawnDelay:=AMinSpawnDelay;
  Enabled:=True;
  Reset;
end;

procedure TOneBonusSpawner.Reset;
begin
  NextSpawn:=Random(MaxSpawnDelay);
end;

procedure TOneBonusSpawner.RndNextSpawn;
begin
  NextSpawn:=Random(MaxSpawnDelay-MinSpawnDelay)+MinSpawnDelay;
end;

procedure TOneBonusSpawner.Step(MoveCount: Integer);
begin
  If Not Enabled then Exit;
  If Not HandleTimeDec(NextSpawn,MoveCount) then Exit;
  If Random(2)=0 then
    Begin
      NextSpawn:=Random(MaxSpawnDelay-MinSpawnDelay);
      Exit;
    End;
  RndNextSpawn;
  With TBonus.Create(MyDXSpriteEngine.Engine) do
    Init(Self.BonusType);
end;

{ TBonusSpawner }

procedure TBonusSpawner.Add(NewSpawner: TOneBonusSpawner);
Var N:Integer;
begin
  N:=Length(Spawners);
  SetLength(Spawners,N+1);
  Spawners[N]:=NewSpawner;
end;

constructor TBonusSpawner.Create;
begin
  Inherited;
  SetLength(Spawners,0);
end;

destructor TBonusSpawner.Destroy;
Var I:Integer;
begin
  For I:=0 to Length(Spawners)-1 do
    Spawners[I].Free;
  inherited;
end;

function TBonusSpawner.GetSpawner(Name: String):TOneBonusSpawner;
Var I:Integer;
begin
  For I:=0 to Length(Spawners)-1 do
    If Spawners[I].BonusType=Name then
      Begin
        Result:=Spawners[I];
        Exit;
      End;
  Result:=Nil;
end;

procedure TBonusSpawner.Reset;
Var I:Integer;
begin
  For I:=0 to Length(Spawners)-1 do
    Spawners[I].Reset;
end;

procedure TBonusSpawner.SetEnabled(Name: String; AEnabled: Boolean);
Var S:TOneBonusSpawner;
begin
  S:=GetSpawner(Name);
  If S=Nil then Exit;
  S.Enabled:=AEnabled;
end;

procedure TBonusSpawner.Step(MoveCount: Integer);
Var I:Integer;
begin
  For I:=0 to Length(Spawners)-1 do
    Spawners[I].Step(MoveCount);
end;

end.
