unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, DXClass, DXDraws, DXSounds, DXInput,Contnrs;

type
  TDirGraphic=Array[1..4] of TGraphic;
  TMapObject=class(TComponent)
  Public
    Image:TGraphic;
    BRect:TRect;
    Dead:Boolean;
    Constructor Create(AOwner:TComponent);Override;
    Procedure Move(DX,DY:Integer);
    Procedure Step;Virtual;
    Procedure Collision(W:TMapObject);Virtual;
  End;
  TPlayer=class(TMapObject)
    Constructor Create(AOwner:TComponent);Override;
  End;
  TME=(meSpace,meDWall,meSlow,meWater,meWall);
  TMainForm = class(TDXForm)
    DXDraw: TDXDraw;
    DXTimer: TDXTimer;
    ImageList: TDXImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DXDrawFinalize(Sender: TObject);
    procedure DXDrawInitialize(Sender: TObject);
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FMap:Array[1..20,1..15]of TME;
    function GetMap(X, Y: Integer): TME;
    procedure SetMap(X, Y: Integer; const Value: TME);
  public
    MEImages:Array[TME]of TGraphic;
    Objs:TComponentList;
    Property Map[X,Y:Integer]:TME
      Read GetMap
      Write SetMap;
    Function OnMap(X,Y:Integer):Boolean;
    Procedure MyPaint(C:TCanvas);
    Procedure PaintMap(C:TCanvas);
    Procedure GenerateMap;
    Procedure ClearMap;
    Procedure DeleteDeads;
    Procedure PaintObjs(C:TCanvas);
  end;

var
  MainForm: TMainForm;
  Players:Array[1..2]of TPlayer;

Function IntersectRect(R1,R2:TRect):Boolean;

implementation

uses MMSystem;

{$R *.DFM}

Function IntersectRect(R1,R2:TRect):Boolean;
Begin
  Result:=
    (R1.Left  <R2.Right )And
    (R1.Right >R2.Left  )And
    (R1.Top   <R2.Bottom)And
    (R1.Bottom>R2.Top   );
End;

procedure TMainForm.DXDrawInitialize(Sender: TObject);
begin
  DXTimer.Enabled := True;
end;

procedure TMainForm.DXDrawFinalize(Sender: TObject);
begin
  DXTimer.Enabled := False;
end;

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
  if not DXDraw.CanDraw then exit;

  DXDraw.Surface.Fill(0);

  with DXDraw.Surface,Canvas do
  begin
    MyPaint(Canvas);

    Release; {  Indispensability  }
  end;

  DXDraw.Flip;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {  Application end  }
  if Key=VK_ESCAPE then
    Close;

  {  Screen mode change  }
  if (ssAlt in Shift) and (Key=VK_RETURN) then
  begin
    DXDraw.Finalize;

    if doFullScreen in DXDraw.Options then
    begin
      RestoreWindow;

      DXDraw.Cursor := crDefault;
      BorderStyle := bsSizeable;
      DXDraw.Options := DXDraw.Options - [doFullScreen];
    end else
    begin
      StoreWindow;

      DXDraw.Cursor := crNone;
      BorderStyle := bsNone;
      DXDraw.Options := DXDraw.Options + [doFullScreen];
    end;

    DXDraw.Initialize;
  end;
end;

procedure TMainForm.MyPaint(C: TCanvas);
begin
  PaintMap(C);
  PaintObjs(C);
  With C do
    Begin
      //Draw(100,100,ImageList.Items.Find('Player1 Up').Picture.Graphic);
    End;
end;

function TMainForm.GetMap(X, Y: Integer): TME;
begin
  If OnMap(X,Y) then
    Result:=FMap[X,Y]
    Else
    Result:=meWall;
end;

procedure TMainForm.SetMap(X, Y: Integer; const Value: TME);
begin
  If OnMap(X,Y) then
    FMap[X,Y]:=Value;
end;

function TMainForm.OnMap(X, Y: Integer): Boolean;
begin
  Result:=(X>=1)And(Y>=1)And(X<=20)And(Y<=15);
end;

procedure TMainForm.GenerateMap;
Var I:Integer;
begin
  ClearMap;
  For I:=1 to 50 do
    FMap[Random(20)+1,Random(15)+1]:=meWall;
end;

procedure TMainForm.ClearMap;
Var I,J:Byte;
begin
  For I:=1 to 20 do
    For J:=1 to 15 do
      FMap[I,J]:=meSpace;
end;

procedure TMainForm.FormCreate(Sender: TObject);
Var
  ME:TME;
  I:Integer;
begin
  For ME:=meSpace to meWall do
    MEImages[ME]:=Nil;
  MEImages[meSpace]:=ImageList.Items.Find('Space').Picture.Graphic;
  MEImages[meWall]:=ImageList.Items.Find('Wall').Picture.Graphic;
  GenerateMap;
  Objs:=TComponentList.Create(True);
  For I:=1 to 2 do
    Begin
      Players[I]:=TPlayer.Create(Self);
      Objs.Add(Players[I]);
    End;
end;

Procedure TMainForm.PaintMap(C: TCanvas);
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

{ TMapObject }

procedure TMapObject.Collision(W: TMapObject);
begin
  //Virtual
end;

constructor TMapObject.Create(AOwner: TComponent);
begin
  inherited;
  Image:=Nil;
  Dead:=False;
  BRect:=Bounds(0,0,32,32);
end;

procedure TMapObject.Move(DX, DY: Integer);
begin
  With BRect do
    Begin
      Inc(Left  ,DX);
      Inc(Right ,DX);
      Inc(Top   ,DY);
      Inc(Bottom,DY);
    End;
end;

procedure TMapObject.Step;
begin
  //Virtual
end;

procedure TMainForm.DeleteDeads;
Var I:Integer;
begin
  I:=0;
  With Objs do
    While I<Count-1 do
      With TMapObject(Items[I]) do
        If Dead then
          Delete(I)
          Else
          Inc(I);
end;

procedure TMainForm.PaintObjs(C: TCanvas);
Var I:Integer;
begin
  With C,Objs do
    For I:=0 to Count-1 do
      With TMapObject(Items[I]),BRect do
        If Image<>Nil then
          Draw(Left,Top,Image);
end;

{ TPlayer }

constructor TPlayer.Create(AOwner: TComponent);
begin
  inherited;
  Image:=MainForm.ImageList.Items.Find('Player1 Up').Picture.Graphic;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Objs.Free;
end;

end.
