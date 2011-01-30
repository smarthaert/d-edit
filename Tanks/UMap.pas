unit UMap;

interface

Uses Classes,DXDraws,Graphics,Types,Base,ULog,UFPS,DIB,Pointers;

// Измерение FPSCallCounter

//{$Define CCCheckCanBe} //500-1200
//{$Define CCPaintNR} //0-1000

Const
  MapXSize=20;
  MapYSize=15;

Type
  TMESet=Set of TME;
  TMapContainer=class(TComponent)
  private
    MapChanged:Array[1..MapXSize,1..MapYSize]of Boolean;
    ImageList:TDXImageList;
    FMap:Array[1..MapXSize,1..MapYSize]of TME;
    FNotRazed:Array[1..MapXSize,1..MapYSize]of TMENotRazed;
    //FGroundObjs:Array[0..MapXSize*32-1,0..MapYSize*32-1]of Boolean;
    function GetMap(X, Y: Integer): TME;
    procedure SetMap(X, Y: Integer; const Value: TME);
    function GetNotRazed(X, Y: Integer): TMENotRazed;
    procedure SetNotRazed(X, Y: Integer; const Value: TMENotRazed);
  public
    MEImages:Array[TME]of TPictureCollectionItem;
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
    Destructor Destroy; Override;
    Function OnMap(X,Y:Integer):Boolean;
    Procedure PaintMap(Const S:TDirectDrawSurface);
    Procedure FullPaintMap(Const S:TDirectDrawSurface);
    Procedure PaintME(Const S:TDirectDrawSurface;MX,MY:Integer);
    Procedure GenerateMap;
    Procedure ClearMap;
    Function TankCanBeAt(Const R:TRect):Boolean;
    Function FireCanBeAt(Const R:TRect):Boolean;
    Procedure SimpleFireDamage(X,Y,R,P:Integer;Dir:TDir);
    Procedure HalfFireDamage(BR:TRect;R,P:Integer;Dir:TDir);
    Procedure RectFireDamage(Const NRR:TRect;P:Integer);
    Procedure DamageNotRazed(NRX,NRY,Count:Integer);
    Function CheckCanBe(Const CR:TRect;Const MEFullSet,MERazedSet:TMESet):Boolean;
    Function CheckExtendRound(CR:TRect;Dir:TDir;MaxDist:Integer;MEFullSet,MERazedSet:TMESet):Integer;
    Function CheckExtend(CR:TRect;Dir:TDir;MaxDist:Integer;MEFullSet,MERazedSet:TMESet):Integer;
    Function CheckRectRazeable(CR:TRect):Boolean;
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
    'M Diag UL',
    'M Diag UR',
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
Function PixelToMEHalf(Const Value:Integer):Integer;

implementation

uses MMSystem,UUnits;

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

Function PixelToMEHalf(Const Value:Integer):Integer;
Begin
  Result:=Value Div 16;
End;

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
  MapChanged[X,Y]:=True;
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
  {MapPicture:=Nil;
  MapPictureCollection:=TPictureCollection.Create(Nil);}
  {MapPicture.PatternWidth:=640;
  MapPicture.PatternHeight:=480;}
  {With MapPicture do
    Begin
      Width:=640;
      Height:=480;
      Transparent:=False;
      // Заполняется при помощи ClearMap
    End;}
  For ME:=meSpace to meBaseRazed do
    Begin
      Code:=ImageList.Items.IndexOf(MEImagesNames[ME]);
      If Code=-1 then
        MEImages[ME]:=Nil
        Else
        Begin
          //Log('Map image:'+MEImagesNames[ME]);
          MEImages[ME]:=ImageList.Items.Items[Code];
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

Procedure TMapContainer.PaintMap(Const S:TDirectDrawSurface);
Var
  I,J{,K,L}:Byte;
  {G:TGraphic;
  PC:TPictureCollectionItem;
  NR:TMENotRazed;}
begin
  {If MapPicture=Nil then
    Begin
      MapPicture:=TPictureCollectionItem.Create(MapPictureCollection);
      MapPicture.Assign(S);
      MapPicture:=TDirectDrawSurface.Create(MyDXDraw.DDraw);
      MapPicture.Assign(S);
    End;}
  For I:=1 to MapXSize do
    For J:=1 to MapYSize do
      If MapChanged[I,J] then
        Begin
          PaintME(S,I,J);
          MapChanged[I,J]:=False;
        End;
  //S.Draw(0,0,S.ClientRect,MapPicture.PatternSurfaces[0],False);
  {S.Canvas.CopyRect(S.ClientRect,MapPicture.Canvas,S.ClientRect);
  S.Canvas.Release;}
  {For I:=1 to MapXSize do
    For J:=1 to MapYSize do
      PaintME(S,I,J);}
  (*With S.Canvas do
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
                {$IfDef CCPaintNR}
                Inc(FPSCallCounter);
                {$EndIf}
              End;
        End;*)
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
  MapChanged[X,Y]:=True;
end;

function TMapContainer.TankCanBeAt(Const R: TRect): Boolean;
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

function TMapContainer.FireCanBeAt(Const R: TRect): Boolean;
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

procedure TMapContainer.HalfFireDamage(BR:TRect; R, P: Integer; Dir: TDir);
  Procedure DamageHalfHoriz(P_:TPoint);
  Begin
    With P_ do
      RectFireDamage(
        Bounds(
          PixelToNR(X)-R,
          (Y Div 16)*MESize Div 2,
          R*2,
          MESize Div 2-1),
          P);
  End;
  Procedure DamageHalfVert(P_:TPoint);
  Begin
    With P_ do
      RectFireDamage(
        Bounds(
          (X Div 16)*MESize Div 2,
          PixelToNR(Y)-R,
          MESize Div 2-1,
          R*2),
          P);
  End;
Var
  Horiz:Boolean;
  P1,P2:TPoint;
  UX,UYL,UYH,I,J:Integer;
begin
  Dec(R);
  With BR do
    Case Dir of
      _UP:
        Begin
          P1:=Point(Left ,Top   );
          P2:=Point(Right,Top   );
        End;
      _DOWN:
        Begin
          P1:=Point(Left ,Bottom);
          P2:=Point(Right,Bottom);
        End;
      _LEFT:
        Begin
          P1:=Point(Left ,Top   );
          P2:=Point(Left ,Bottom);
        End;
      Else
        Begin
          P1:=Point(Right,Top   );
          P2:=Point(Right,Bottom);
        End;
    End;
  Horiz:=(Dir In [_LEFT,_RIGHT]);
  If Horiz then
    Begin
      If PixelToMEHalf(P1.Y)<>PixelToMEHalf(P2.Y) then
        Begin
          DamageHalfHoriz(P1);
          DamageHalfHoriz(P2);
        End
        Else
        DamageHalfHoriz(P1);
    End
    Else
    Begin
      If PixelToMEHalf(P1.X)<>PixelToMEHalf(P2.X) then
        Begin
          DamageHalfVert(P1);
          DamageHalfVert(P2);
        End
        Else
        DamageHalfVert(P1);
    End;
end;

procedure TMapContainer.DamageNotRazed(NRX, NRY, Count: Integer);
Var
  MX,MY,EX,EY,N:Integer;
begin
  MX:=NRX Div MESize+1;
  MY:=NRY Div MESize+1;
  If Not OnMap(MX,MY) then Exit;
  If Map[MX,MY]=meBase then
    Begin
      Map[MX,MY]:=meBaseRazed;
      Dec(BasesCount);
      MapChanged[MX,MY]:=True;
    End;
  If Not (Map[MX,MY] In MERazeable) then Exit;
  EX:=NRX Mod MESize+1;
  EY:=NRY Mod MESize+1;
  If (EX<1)Or(EY<1) then Exit;
  N:=FNotRazed[MX,MY,EX,EY];
  MapChanged[MX,MY]:=True;
  If N>Count then
    FNotRazed[MX,MY,EX,EY]:=N-Count
    Else
    FNotRazed[MX,MY,EX,EY]:=0;
end;

function TMapContainer.CheckCanBe(Const CR: TRect; Const MEFullSet,
  MERazedSet: TMESet): Boolean;
Const
  DiagDist=0;
Var
  I,J,MX,MY,EX,EY:Integer;
  CNR:TMENotRazed;
  R,RB:TRect;

begin
  {$Ifdef CCCheckCanBe}
  Inc(FPSCallCounter);
  {$EndIf}
  Result:=True;
  With CR do
    For MX:=PixelToMap(Left) to PixelToMap(Right) do
      For MY:=PixelToMap(Top) to PixelToMap(Bottom) do
        Begin
          If Map[MX,MY] In MEFullSet then Continue;
          If Map[MX,MY]=meDiagUL then
            Begin
              EX:=Right-MapToPixel(MX);
              EY:=Top-MapToPixel(MY);
              If EY-EX>DiagDist then Continue;
              EX:=Left-MapToPixel(MX);
              EY:=Bottom-MapToPixel(MY);
              If EX-EY>DiagDist then Continue;
              Result:=False;
              Exit;
            End;
          If Map[MX,MY]=meDiagUR then
            Begin
              EX:=Left-MapToPixel(MX);
              EY:=Top-MapToPixel(MY);
              If EX+EY-32>DiagDist then Continue;
              EX:=Right-MapToPixel(MX);
              EY:=Bottom-MapToPixel(MY);
              If EX+EY-32<-DiagDist then Continue;
              Result:=False;
              Exit;
            End;
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

function TMapContainer.CheckExtendRound(CR: TRect; Dir: TDir; MaxDist: Integer;
  MEFullSet, MERazedSet: TMESet): Integer;
Var
  I:Integer;
  R:TRect;
begin
  Result:=0;
  If Not CheckCanBe(CR,MEFullSet,MERazedSet) then
    Exit;
  R:=CR;
  With R do
    For I:=1 to (MaxDist+NRPixelSize-1) Div NRPixelSize do
      Begin
        Case Dir of
          _UP   :
            Begin
              Bottom:=Top-1;
              Dec(Top,NRPixelSize);
            End;
          _DOWN :
            Begin
              Top:=Bottom+1;
              Inc(Bottom,NRPixelSize);
            End;
          _LEFT :
            Begin
              Right:=Left-1;
              Dec(Left,NRPixelSize);
            End;
          _RIGHT:
            Begin
              Left:=Right+1;
              Inc(Right,NRPixelSize);
            End;
        End;
        If Not CheckCanBe(R,MEFullSet,MERazedSet) then
          {Begin
            Case Dir of
              _UP   :Inc(Result,Top Mod NRPixelSize);
              _DOWN :Inc(Result,NRPixelSize-Bottom Mod NRPixelSize);
                Begin
                  R.Bottom:=R.Top-1;
                  Dec(R.Top,NRPixelSize);
                End;
            End;}
            Exit;
          //End;
        Inc(Result,NRPixelSize);
      End;
  Result:=MaxDist;
end;

{ don`t work }
{ bugs with meDiag }
function TMapContainer.CheckExtend(CR: TRect; Dir: TDir; MaxDist: Integer;
  MEFullSet, MERazedSet: TMESet): Integer;
  Procedure UpSmallStep(N:Integer);
  Begin
    Inc(Result,(N+NRPixelSize) Mod NRPixelSize);
  End;
  Procedure DownSmallStep(N:Integer);
  Begin
    Inc(Result,(MapXSize*32+NRPixelSize-N-1) Mod NRPixelSize);
  End;
Var
  I:Integer;
  R:TRect;
begin
  Result:=0;
  If Not CheckCanBe(CR,MEFullSet,MERazedSet) then
    Exit;
  R:=CR;
  With R do
    For I:=1 to (MaxDist+NRPixelSize-1) Div NRPixelSize do
      Begin
        Case Dir of
          _UP   :
            Begin
              Bottom:=Top-1;
              Dec(Top,NRPixelSize);
            End;
          _DOWN :
            Begin
              Top:=Bottom+1;
              Inc(Bottom,NRPixelSize);
            End;
          _LEFT :
            Begin
              Right:=Left-1;
              Dec(Left,NRPixelSize);
            End;
          _RIGHT:
            Begin
              Left:=Right+1;
              Inc(Right,NRPixelSize);
            End;
        End;
        If Not CheckCanBe(R,MEFullSet,MERazedSet) then
          Begin
            Case Dir of
              _UP   :UpSmallStep(Top);
              _DOWN :DownSmallStep(Bottom);
              _LEFT :UpSmallStep(Left);
              _RIGHT:DownSmallStep(Right);
            End;
            If Result>MaxDist then
              Result:=MaxDist;
            Exit;
          End;
        Inc(Result,NRPixelSize);
      End;
  Result:=MaxDist;
end;

function TMapContainer.CheckRectRazeable(CR: TRect): Boolean;
Var
  MX,MY,I,J:Integer;
  MR,NRR,NRS:TRect;
begin
  With CR do
    Begin
      If Left<0 then
        Left:=0;
      If Top<0 then
        Top:=0;
      If Bottom>479 then
        Bottom:=479;
      If Right>639 then
        Right:=639;
      { В координатах Map }
      MR.Left  :=PixelToMap(Left)  ;
      MR.Right :=PixelToMap(Right) ;
      MR.Top   :=PixelToMap(Top)   ;
      MR.Bottom:=PixelToMap(Bottom);
      { Остаток от Map в координатах NR }
      NRS.Left  :=PixelToNR(Left  ) Mod MESize+1;
      NRS.Right :=PixelToNR(Right ) Mod MESize+1;
      NRS.Top   :=PixelToNR(Top   ) Mod MESize+1;
      NRS.Bottom:=PixelToNR(Bottom) Mod MESize+1;
    End;
      For MX:=MR.Left to MR.Right do
        For MY:=MR.Top to MR.Bottom do
          Begin
            If Not (FMap[MX,MY] In MERazeable) then Continue;
            NRR:=Rect(1,1,MESize,MESize);
            { Если край CR - то только край клетки }
            With NRR do
              Begin
                If MX=MR.Left   then Left  :=NRS.Left  ;
                If MX=MR.Right  then Right :=NRS.Right ;
                If MY=MR.Top    then Top   :=NRS.Top   ;
                If MY=MR.Bottom then Bottom:=NRS.Bottom;
                For I:=Left to Right do
                  For J:=Top to Bottom do
                    If FNotRazed[MX,MY,I,J]>0 then
                      Begin
                        Result:=True;
                        Exit;
                      End;
              End;
          End;
  Result:=False;
end;

procedure TMapContainer.RectFireDamage(Const NRR: TRect; P: Integer);
Var I,J:Integer;
begin
  With NRR do
    For I:=Left to Right do
      For J:=Top to Bottom do
        DamageNotRazed(I,J,P);
end;

procedure TMapContainer.PaintME(const S:TDirectDrawSurface;MX,MY:Integer);
Var
  K,L:Byte;
  PC:TPictureCollectionItem;
  NR:TMENotRazed;
  MEX,MEY:Integer;
begin
  PC:=MEImages[FMap[MX,MY]];
  If PC=Nil then Exit;
  MEX:=(MX-1)*32;
  MEY:=(MY-1)*32;
  PC.Draw(S,MEX,MEY,0);
  {With PC,C,Picture.Bitmap do
    CopyRect(
      Bounds((MX-1)*32,(MY-1)*32,31,31),Canvas,PatternRects[0]);}
  If FMap[MX,MY] In MERazeable then
    Begin
      NR:=FNotRazed[MX,MY];
      PC:=MEImagesRazed[FMap[MX,MY]];
      If PC=Nil then Exit;
      With PC{,C,Picture.Bitmap} do
        For K:=1 to MESize do
          For L:=1 to MESize do
            Begin
              If NR[K,L]<>0 then Continue;
              {CopyRect(
                Bounds(
                (MX-1)*32+(K-1)*32 Div MESize,
                (MY-1)*32+(L-1)*32 Div MESize,
                32 Div MESize-1,
                32 Div MESize-1),
                Canvas,
                PatternRects[(L-1)*MESize+K-1]);}
              Draw(S,
                MEX+(K-1)*32 Div MESize,
                MEY+(L-1)*32 Div MESize,
                (L-1)*MESize+K-1);
              {$IfDef CCPaintNR}
              Inc(FPSCallCounter);
              {$EndIf}
            End;
    End;
end;

destructor TMapContainer.Destroy;
begin
  //MapPictureCollection.Free;
  inherited;
end;

procedure TMapContainer.FullPaintMap(const S: TDirectDrawSurface);
Var I,J:Byte;
begin
  For I:=1 to MapXSize do
    For J:=1 to MapYSize do
      PaintME(S,I,J);
end;

end.
