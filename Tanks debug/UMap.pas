unit UMap;

interface

Uses Classes,DXDraws,Graphics,Types,Base,ULog;

Const
  MapXSize=20;
  MapYSize=15;

Type
  TMESet=Set of TME;
  TMapContainer=class(TComponent)
  private
    ImageList:TDXImageList;
    FMap:Array[1..MapXSize,1..MapYSize]of TME;
    FNotRazed:Array[1..MapXSize,1..MapYSize]of TMENotRazed;
    //FGroundObjs:Array[0..MapXSize*32-1,0..MapYSize*32-1]of Boolean;
    function GetMap(X, Y: Integer): TME;
    procedure SetMap(X, Y: Integer; const Value: TME);
    function GetNotRazed(X, Y: Integer): TMENotRazed;
    procedure SetNotRazed(X, Y: Integer; const Value: TMENotRazed);
  public
    MEImages:Array[TME]of TGraphic;
    MEImagesRazed:Array[TME]of TPictureCollectionItem;
    Property Map[X,Y:Integer]:TME
      Read GetMap
      Write SetMap;
    Property NotRazed[X,Y:Integer]:TMENotRazed
      Read GetNotRazed
      Write SetNotRazed;
    {Property GroundObjs[0..MapXSize*32-1,0..MapYSize*32-1]:Boolean
      Read GetGroundObjs
      Write SetGroundObjs;}
    Constructor Create(AOwner:TComponent;AImageList:TDXImageList); virtual;
    Function OnMap(X,Y:Integer):Boolean;
    Procedure PaintMap(S:TDirectDrawSurface);
    Procedure GenerateMap;
    Procedure ClearMap;
    Function TankCanBeAt(R:TRect):Boolean;
    Function FireCanBeAt(R:TRect):Boolean;
    Procedure SimpleFireDamage(X,Y,R,P:Integer;Dir:TDir);
    Procedure DamageNotRazed(NRX,NRY,Count:Integer);
    Function CheckCanBe(CR:TRect;MEFullSet,MERazedSet:TMESet):Boolean;
    //Procedure PutGroundRect(R:TRect);
    //Procedure EraseGroundRect(R:TRect);
    //Function TestGroundRect(R:TRect):Boolean;
  End;

Var
  MapContainer:TMapContainer;

Const
  MEImagesNames:Array[TME]of String=(
    'M Space',
    'M DWall',
    'M Slow',
    'M Water',
    'M Start',
    'M Wall',
    'M Base',
    'M Base Razed');
  MERazeable:TMESet=[meDWall];
  METankCanBe:TMESet=[meSpace,meStart,meSlow,meBaseRazed];
  MEFireCanBe:TMESet=[meSpace,meStart,meWater,meSlow,meBaseRazed];

Var
  EmptyNotRazed:TMENotRazed;
  BasesCount:Integer;

Function MaxNotRazed(ME:TME):Byte;
Function PixelToNR(Const Value:Integer):Integer;
Function NRToPixel(Const Value:Integer):Integer;
Function MapToNR(Const Value:Integer):Integer;
Function NRToMap(Const Value:Integer):Integer;
Function PixelToMap(Const Value:Integer):Integer;
Function MapToPixel(Const Value:Integer):Integer;

implementation

uses MMSystem;

Function PixelToNR(Const Value:Integer):Integer;
Begin
  Result:=Value*MESize Div 32;
End;

Function NRToPixel(Const Value:Integer):Integer;
Begin
  Result:=Value*32 Div MESize;
End;

Function MapToNR(Const Value:Integer):Integer;
Begin
  Result:=(Value-1)*MESize;
End;

Function NRToMap(Const Value:Integer):Integer;
Begin
  Result:=(Value+MESize) Div MESize;
End;

Function PixelToMap(Const Value:Integer):Integer;
Begin
  Result:=(Value+32) Div 32;
End;

Function MapToPixel(Const Value:Integer):Integer;
Begin
  Result:=(Value-1)*32;
End;

function MaxNotRazed(ME:TME):Byte;
begin
  Result:=1;
end;

{ TMapContainer }

function TMapContainer.GetMap(X, Y: Integer): TME;
begin
  If OnMap(X,Y) then
    Result:=FMap[X,Y]
    Else
    Result:=meWall;
end;

procedure TMapContainer.SetMap(X, Y: Integer; const Value: TME);
Var
  I,J:Integer;
  R:Byte;
begin
  If Not OnMap(X,Y) then Exit;
  FMap[X,Y]:=Value;
  R:=MaxNotRazed(Value);
  For I:=1 to MESize do
    For J:=1 to MESize do
      FNotRazed[X,Y,I,J]:=R;
end;

function TMapContainer.OnMap(X, Y: Integer): Boolean;
begin
  Result:=(X>=1)And(Y>=1)And(X<=MapXSize)And(Y<=MapYSize);
end;

procedure TMapContainer.GenerateMap;
Var I:Integer;
begin
  ClearMap;
  For I:=1 to 50 do
    Map[Random(MapXSize)+1,Random(MapYSize)+1]:=meWall;
  For I:=1 to 50 do
    Map[Random(MapXSize)+1,Random(MapYSize)+1]:=meDWall;
end;

procedure TMapContainer.ClearMap;
Var I,J:Integer;
begin
  For I:=1 to MapXSize do
    For J:=1 to MapYSize do
      Map[I,J]:=meSpace;
  {For I:=0 to MapXSize*32-1 do
    For J:=0 to MapYSize*32-1 do
      FGroundObjs[I,J]:=False;}
end;

Constructor TMapContainer.Create;
Var
  ME:TME;
  Code:Integer;
  I,J:Byte;
begin
  Inherited Create(AOwner);
  For I:=1 to MESize do
    For J:=1 to MESize do
      EmptyNotRazed[I,J]:=1;
  ImageList:=AImageList;
  For ME:=meSpace to meBaseRazed do
    Begin            
      Code:=ImageList.Items.IndexOf(MEImagesNames[ME]);
      If Code=-1 then
        MEImages[ME]:=Nil
        Else
        Begin
          //Log('Map image:'+MEImagesNames[ME]);
          MEImages[ME]:=ImageList.Items.Items[Code].Picture.Graphic;
        End;
      Code:=ImageList.Items.IndexOf(MEImagesNames[ME]+' R');
      If Code=-1 then
        MEImagesRazed[ME]:=Nil
        Else
        Begin
          //Log('Map image:'+MEImagesNames[ME]+' R');
          MEImagesRazed[ME]:=ImageList.Items.Items[Code];
        End;
    End;
  ClearMap;
end;

Procedure TMapContainer.PaintMap(S:TDirectDrawSurface);
Var
  I,J,K,L:Byte;
  G:TGraphic;
  PC:TPictureCollectionItem;
  NR:TMENotRazed;
begin
  With S.Canvas do
    Begin
      For I:=1 to MapXSize do
        For J:=1 to MapYSize do
          Begin
            G:=MEImages[FMap[I,J]];
            If G=Nil then Continue;
            Draw((I-1)*32,(J-1)*32,G);
            {If FMap[I,J] In MERazeable then
              Begin
                NR:=FNotRazed[I,J];
                For K:=1 to MESize do
                  For L:=1 to MESize do
                    Begin
                      If NR[K,L]<>0 then Continue;
                      PC:=MEImagesRazed[FMap[I,J]];
                      If PC=Nil then Continue;
                      CopyRect(
                        Bounds(
                        (I-1)*32+(K-1)*32 Div MESize,
                        (J-1)*32+(L-1)*32 Div MESize,
                        32 Div MESize-1,
                        32 Div MESize-1),
                        PC.Picture.Bitmap.Canvas,
                        Bounds(
                        (K-1)*32 Div MESize,
                        (L-1)*32 Div MESize,
                        32 Div MESize-1,
                        32 Div MESize-1));
                    End;
              End;}
          End;
      Release;
    End;
  For I:=1 to MapXSize do
    For J:=1 to MapYSize do
      If FMap[I,J] In MERazeable then
        Begin
          NR:=FNotRazed[I,J];
          For K:=1 to MESize do
            For L:=1 to MESize do
              Begin
                If NR[K,L]<>0 then Continue;
                PC:=MEImagesRazed[FMap[I,J]];
                If PC=Nil then Continue;
                PC.Draw(S,
                  (I-1)*32+(K-1)*32 Div MESize,
                  (J-1)*32+(L-1)*32 Div MESize,
                  (L-1)*MESize+K-1);
              End;
        End;
end;

function TMapContainer.GetNotRazed(X, Y: Integer): TMENotRazed;
begin
  Result:=EmptyNotRazed;
  If Not OnMap(X,Y) then Exit;
  If FMap[X,Y] in MERazeable then Result:=FNotRazed[X,Y];
end;

procedure TMapContainer.SetNotRazed(X, Y: Integer;
  const Value: TMENotRazed);
begin
  If Not OnMap(X,Y) then Exit;
  If Not (FMap[X,Y] in MERazeable) then Exit;
  FNotRazed[X,Y] := Value;
end;

function TMapContainer.TankCanBeAt(R: TRect): Boolean;
//Var I,J:Integer;
begin
  Result:=CheckCanBe(R,METankCanBe,MERazeable);
  {Result:=True;
  With R do
    For I:=(Left+32) Div 32 to (Right+32) Div 32 do
      For J:=(Top+32) Div 32 to (Bottom+32) Div 32 do
        If Not (Map[I,J] In METankCanBe) then
          Begin
            Result:=False;
            Exit;
          End;}
end;

function TMapContainer.FireCanBeAt(R: TRect): Boolean;
//Var I,J:Integer;
begin
  Result:=CheckCanBe(R,MEFireCanBe,MERazeable);
  {Result:=True;
  With R do
    For I:=(Left+32) Div 32 to (Right+32) Div 32 do
      For J:=(Top+32) Div 32 to (Bottom+32) Div 32 do
        If Not (Map[I,J] In MEFireCanBe) then
          Begin
            Result:=False;
            Exit;
          End;}
end;

procedure TMapContainer.SimpleFireDamage(X, Y, R, P: Integer;Dir:TDir);
Var
  Horiz:Boolean;
  Rect:TRect;
  UX,UY,I,J:Integer;
begin
  Dec(R);
  Horiz:=(Dir In [_LEFT,_RIGHT]);
  If Horiz then
    Begin
      UX:=X*MESize Div 32;
      UY:=((Y-8) Div 16)*MESize Div 2;
      Rect:=Bounds(UX-R,UY,R*2,MESize-1);
    End
    Else
    Begin
      UX:=((X-8) Div 16)*MESize Div 2;
      UY:=Y*MESize Div 32;
      Rect:=Bounds(UX,UY-R,MESize-1,R*2);
    End;
  With Rect do
    For I:=Left to Right do
      For J:=Top to Bottom do
        DamageNotRazed(I,J,P);
end;

procedure TMapContainer.DamageNotRazed(NRX, NRY, Count: Integer);
Var
  MX,MY,EX,EY,N:Integer;
begin
  MX:=NRX Div MESize+1;
  MY:=NRY Div MESize+1;
  If Map[MX,MY]=meBase then
    Begin
      Map[MX,MY]:=meBaseRazed;
      Dec(BasesCount);
    End;
  If Not (Map[MX,MY] In MERazeable) then Exit;
  EX:=NRX Mod MESize+1;
  EY:=NRY Mod MESize+1;
  N:=FNotRazed[MX,MY,EX,EY];
  If N>Count then
    FNotRazed[MX,MY,EX,EY]:=N-Count
    Else
    FNotRazed[MX,MY,EX,EY]:=0;
end;

function TMapContainer.CheckCanBe(CR: TRect; MEFullSet,
  MERazedSet: TMESet): Boolean;
Var
  I,J,MX,MY:Integer;
  CNR:TMENotRazed;
  R,RB:TRect;
begin
  Result:=True;
  With CR do
    For MX:=PixelToMap(Left) to PixelToMap(Right) do
      For MY:=PixelToMap(Top) to PixelToMap(Bottom) do
        Begin
          If Map[MX,MY] In MEFullSet then Continue;
          If Not(Map[MX,MY] In MERazedSet) then
            Begin
              Result:=False;
              Exit;
            End;
          R:=Rect(1,1,MESize,MESize);
          With RB do
            Begin
              Left  :=PixelToNR(CR.Left  )-MapToNR(MX)+1;
              Right :=PixelToNR(CR.Right )-MapToNR(MX)+1;
              Top   :=PixelToNR(CR.Top   )-MapToNR(MY)+1;
              Bottom:=PixelToNR(CR.Bottom)-MapToNR(MY)+1;
              {Dec(Left  ,(MX-1)*MESize-1);
              Dec(Right ,(MX-1)*MESize-1);
              Dec(Top   ,(MY-1)*MESize-1);
              Dec(Bottom,(MY-1)*MESize-1);}
              If R.Top   <Top    then R.Top   :=Top   ;
              If R.Bottom>Bottom then R.Bottom:=Bottom;
              If R.Left  <Left   then R.Left  :=Left  ;
              If R.Right >Right  then R.Right :=Right ;
            End;
          CNR:=GetNotRazed(MX,MY);
          With R do
            For I:=Left to Right do
              For J:=Top to Bottom do
                If CNR[I,J]<>0 then
                  Begin
                    Result:=False;
                    Exit;
                  End;
        End;
end;


end.
