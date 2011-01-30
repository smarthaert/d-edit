unit UTankTypes;

interface

Uses Classes,SysUtils;

{ -- Описание одного типа снарядов -- }
type
  PWeaponType = ^TWeaponType;
  TWeaponType = Record
    Name : String;
    Damage : Integer; { Разрушительная сила, определят урон танку, на основании
      его определяется, пробивает ли снаряд стену определенного вида }
    Speed : Integer; { Скорость полета }
    FireDelay : Integer; { "Скорострельность" }
    Sprite : String; { Имя картинки спрайта }
    DirSprites : Boolean; { Есть ли различия по направлениям }
    ExplosionBall : Boolean; { Взрыв порожает определённую площадь }
    DoubleEarthDamage : Boolean; { Взрыв уничтожает две маленькие клетки кирпича }
    {VerEarthDamage}
  end;

{ -- Список типов снарядов -- }
type
  TWeaponTypes = class (TComponent)
    List : TList;
    constructor Create( AOwner:TComponent );
    function Load( FileName:String ):boolean;
    function getType( TypeName:String ):PWeaponType;
    destructor Destroy; Override;
  End;

Var WeaponTypes : TWeaponTypes;

{ -- Описание одного типа танков -- }
type
  PTankType = ^TTankType;
  TTankType = Record
    Name : String;
    MaxHits : Integer;
    Armor : Integer;
    Speed : Integer;
    Upgrade : String;
    Weapon1 : PWeaponType; { nil если оружия нет }
    Enabled : Boolean;
    RndPart : Integer; { Количесво танков при выборе случайного }
    MapChar : Char; { Символ, которым обозначается старт на карте }
  end;

{ -- Список типов танков -- }
type
  TTankTypes = class (TComponent)
    public
    SumRndPart:Integer;
    List : TList;
    constructor Create( AOwner:TComponent );
    function Load( FileName:String ):boolean;
    function getType( TypeName:String ):PTankType;
    function CanBeType( TypeName:String ):Boolean;
    function getTypeIndex( N:Integer ):PTankType;
    function GetCount:Integer;
    destructor Destroy; Override;
    Procedure CalcSumRndPart;
  End;

Var TankTypes : TTankTypes;

Const
  DefaultWeaponType:TWeaponType=(
    Name : 'Weapon';
    Damage : 100;
    Speed : 200;
    FireDelay : 1000;
    Sprite : 'Fire1';
    DirSprites : False;
    ExplosionBall : False;
    DoubleEarthDamage : False);
  DefaultTankType:TTankType=(
    Name : 'Tank';
    MaxHits : 100;
    Armor : 0;
    Speed : 200;
    Upgrade : '';
    Weapon1 : Nil;
    Enabled : True;
    RndPart : 0;
    MapChar : ' ');

implementation

Function CalcMapChar(S:String):Char;
Begin
  Result:=' ';
  If Length(S)<1 then Exit;
  If Length(S)>=6 then
    If UpperCase(Copy(S,1,6))='PLAYER' then Exit;
  Result:=UpCase(S[1]);
End;

{ Методы класса TWeaponTypes }
constructor TWeaponTypes.Create;
begin
  inherited Create(AOwner);
  List := nil;
end;

destructor TWeaponTypes.Destroy;
begin
  List.Free;
  inherited;
end;

function TWeaponTypes.getType(TypeName: String): PWeaponType;
Var I:Integer;
begin
  Result:=nil;
  For I:=0 to List.Count-1 do
    If UpperCase(TypeName)=UpperCase(PWeaponType(List.Items[I])^.Name) then
      Begin
        Result:=List.Items[I];
        Exit;
      End;
End;

function TWeaponTypes.Load( FileName:String ):boolean;
const breakers : set of char = [#0..' '];
var t : TextFile;
  Name, Value : String;
  NewEl : ^TWeaponType;
  HaveWeapon : boolean; { Есть ли хоть один вид снарядов }
  s : String;
  p : integer;
begin
  Load:=False;
  List:=TList.Create;
  {}
  if not FileExists(FileName) then Exit;
  {}
  AssignFile(t,FileName); reset(t);
  HaveWeapon := false;
  {}
  NewEl:=Nil;
  while not EOF(t) do begin
    readln(t,s);
    s := UpperCase(s);
    {удаляем комментарии}
    p := pos(';',s);
    delete(s,p,length(s)-p+1);
    {}
    if s='' then continue;
    {}
    while ((s[1] in breakers) and
           (Length(S)>0)) do delete(s,1,1);
    p := pos(' ',s);
    Name := copy(s,1,p-1);
    delete(s,1,p);
    while ((s[1] in breakers) and
           (Length(S)>0)) do delete(s,1,1);
    while ((s[Length(S)] in breakers) and
           (Length(S)>0)) do delete(s,Length(S),1);
    Value := s;
    If Name='' then
      Begin
        Name:=S;
        S:='';
      End;
    {}
    if Name = 'WEAPON' then begin
      if HaveWeapon then List.Add(NewEl);
      New(NewEl);
      NewEl^:=DefaultWeaponType;
      NewEl^.Name := Value;
      HaveWeapon := true;
    end;
    If NewEl=Nil then Continue;
    if Name = 'DAMAGE' then NewEl^.Damage := StrToInt(Value);
    if Name = 'SPEED' then NewEl^.Speed := StrToInt(Value);
    if Name = 'FIREDELAY' then NewEl^.FireDelay := StrToInt(Value);
    if Name = 'SPRITE' then begin
      NewEl^.Sprite := Value;
      If Value[Length(Value)]='@' then begin
        NewEl^.DirSprites := true;
        Delete(NewEl^.Sprite,Length(Value),1);
      end else begin
        NewEl^.DirSprites := false;
      end;
    end;
    if Name = 'DIRSPRITES' then NewEl^.DirSprites := (Value='TRUE');
    if Name = 'EXPLOSIONBALL' then NewEl^.ExplosionBall := True;
    if Name = 'DOUBLEEARTHDAMAGE' then NewEl^.DoubleEarthDamage := True;
  end;
  { Не забудем последний тип танков! }
  if HaveWeapon then List.Add(NewEl);
  {}
  CloseFile(t);
  Load:=True;
end;

{ Методы класса TTankTypes }
procedure TTankTypes.CalcSumRndPart;
Var I:Integer;
begin
  SumRndPart:=0;
  For I:=0 to GetCount-1 do
    Inc(SumRndPart,GetTypeIndex(I).RndPart);
end;

function TTankTypes.CanBeType(TypeName: String): Boolean;
Var T:PTankType;
begin
  Result:=False;
  T:=getType(TypeName);
  If T=Nil then Exit;
  If Not T.Enabled then Exit;
  Result:=True;
end;

constructor TTankTypes.Create;
begin
  inherited Create(AOwner);
  List := nil;
  SumRndPart:=0;
end;

destructor TTankTypes.Destroy;
begin
  List.Free;
  inherited;
end;

function TTankTypes.GetCount: Integer;
begin
  Result:=0;
  If List=Nil then Exit;
  Result:=List.Count;
end;

function TTankTypes.getType(TypeName: String): PTankType;
Var I:Integer;
begin
  Result:=nil;
  If List=Nil then Exit;
  For I:=0 to List.Count-1 do
    If UpperCase(TypeName)=UpperCase(PTankType(List.Items[I])^.Name) then
      Begin
        Result:=List.Items[I];
        Exit;
      End;
End;

function TTankTypes.getTypeIndex(N: Integer): PTankType;
begin
  Result:=nil;
  If List=Nil then Exit;
  If N>=List.Count then Exit;
  Result:=List.Items[N];
end;

function TTankTypes.Load( FileName:String ):boolean;
const breakers : set of char = [#0..' '];
var t : TextFile;
  Name, Value : String;
  NewEl : ^TTankType;
  HaveTanks : boolean; { Есть ли хоть один танк }
  s : String;
  p : integer;
begin
  Load:=False;
  List:=TList.Create;
  {}
  if not FileExists(FileName) then Exit;
  {}
  AssignFile(t,FileName); reset(t);
  HaveTanks := false;
  {}
  NewEl:=Nil;
  while not EOF(t) do begin
    readln(t,s);
    s := UpperCase(s);
    {удаляем комментарии}
    p := pos(';',s);
    delete(s,p,length(s)-p+1);
    {}
    if s='' then continue;
    {}
    while ((s[1] in breakers) and
           (Length(S)>0)) do delete(s,1,1);
    p := pos(' ',s);
    Name := copy(s,1,p-1);
    delete(s,1,p);
    while ((s[1] in breakers) and
           (Length(S)>0)) do delete(s,1,1);
    while ((s[Length(S)] in breakers) and
           (Length(S)>0)) do delete(s,Length(S),1);
    Value := s;
    If Name='' then
      Begin
        Name:=S;
        S:='';
      End;
    {}
    if Name = 'TANK' then begin
      if HaveTanks then List.Add(NewEl);
      New(NewEl);
      NewEl^:=DefaultTankType;
      NewEl^.Name := Value;
      NewEl^.MapChar:=CalcMapChar(Value);
      NewEl^.Weapon1 := nil;
      HaveTanks := true;
    end;
    If NewEl=Nil then Continue;
    if Name = 'MAXHITS' then NewEl^.MaxHits := StrToInt(Value);
    if Name = 'ARMOR' then NewEl^.Armor := StrToInt(Value);
    if Name = 'SPEED' then NewEl^.Speed := StrToInt(Value);
    if Name = 'UPGRADE' then NewEl^.Upgrade := Value;
    if Name = 'WEAPON1' then NewEl^.Weapon1 := WeaponTypes.getType(Value);
    if Name = 'RNDPART' then NewEl^.RndPart := StrToInt(Value);
    if (Name = 'MAPCHAR')And(Length(Value)=1) then NewEl^.MapChar := Value[1];
//    if Name = 'FIREDELAY' then NewEl^.FireDelay := StrToInt(Value); Не нужен!!!
  end;
  { Не забудем последний тип танков! }
  if HaveTanks then List.Add(NewEl);
  {}
  CloseFile(t);
  Load:=True;
  CalcSumRndPart;
end;

end.
