unit UMap;

interface

Uses Classes,DXDraws,Graphics;

Type
  TME=(meSpace,meDWall,meSlow,meWater,meWall);
  TMapContainer=class(TComponent)
  private
    ImageList:TDXImageList;
    FMap:Array[1..20,1..15]of TME;
    function GetMap(X, Y: Integer): TME;
    procedure SetMap(X, Y: Integer; const Value: TME);
  public
    MEImages:Array[TME]of TGraphic;
    Property Map[X,Y:Integer]:TME
      Read GetMap
      Write SetMap;
    Constructor Create(AOwner:TComponent;AImageList:TDXImageList);
    Function OnMap(X,Y:Integer):Boolean;
    Procedure PaintMap(C:TCanvas);
    Procedure GenerateMap;
    Procedure ClearMap;
  End;

Var
  MapContainer:TMapContainer;

Const
  MEImagesNames:Array[TME]of ShortString=(
    'M Space',
    'M DWall',
    'M Slow',
    'M Water',
    'M Wall');

implementation

uses MMSystem;

{ TMapContainer }

function TMapContainer.GetMap(X, Y: Integer): TME;
begin
  If OnMap(X,Y) then
    Result:=FMap[X,Y]
    Else
    Result:=meWall;
end;

procedure TMapContainer.SetMap(X, Y: Integer; const Value: TME);
begin
  If OnMap(X,Y) then
    FMap[X,Y]:=Value;
end;

function TMapContainer.OnMap(X, Y: Integer): Boolean;
begin
  Result:=(X>=1)And(Y>=1)And(X<=20)And(Y<=15);
end;

procedure TMapContainer.GenerateMap;
Var I:Integer;
begin
  ClearMap;
  For I:=1 to 50 do
    FMap[Random(20)+1,Random(15)+1]:=meWall;
end;

procedure TMapContainer.ClearMap;
Var I,J:Byte;
begin
  For I:=1 to 20 do
    For J:=1 to 15 do
      FMap[I,J]:=meSpace;
end;

Constructor TMapContainer.Create;
Var
  ME:TME;
  Code:Integer;
begin
  Inherited Create(AOwner);
  ImageList:=AImageList;
  For ME:=meSpace to meWall do
    Begin
      Code:=ImageList.Items.IndexOf(MEImagesNames[ME]);
      If Code=-1 then
        MEImages[ME]:=Nil
        Else
        MEImages[ME]:=ImageList.Items.Items[Code].Picture.Graphic;
    End;
  GenerateMap;
end;

Procedure TMapContainer.PaintMap(C: TCanvas);
Var
  I,J:Byte;
  G:TGraphic;
begin
  With C do
    For I:=1 to 20 do
      For J:=1 to 15 do
        Begin
          G:=MEImages[FMap[I,J]];
          If G=Nil then Continue;
          Draw((I-1)*32,(J-1)*32,G);
        End;
end;

end.
