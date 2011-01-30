unit Figures;

interface

uses
  Windows, Graphics, Math, Classes;

type

  TFigure = class
  private
    fLayer: integer;
    fColor: TColor;
  published
    property Color: TColor read fColor write fColor;
    property Layer: integer read fLayer write fLayer;
  public
    procedure Draw(Canvas: TCanvas); virtual;
  end;

  TArrayOfPoints = array of TPoint;

  TPoints = class(TFigure)
  private
    fPoints: TArrayOfPoints;
    function fCount: integer;
  published
    property Points: TArrayOfPoints read fPoints write fPoints;
    property Count: integer read fCount;
  public
    constructor Create(StartPoint: TPoint);
    procedure Clear;
    procedure AddPoint(p: TPoint);
    procedure Draw(Canvas: TCanvas); override;
    procedure DrawLast(Canvas: TCanvas);
  end;

  TLine = class(TFigure)
  private
    fStPoint: TPoint;
    fEnPoint: TPoint;
    fPenWidth: integer;
    function fLineWidth: Double;
  published
    property StartPoint: TPoint read fStPoint write fStPoint;
    property EndPoint: TPoint read fEnPoint write fEnPoint;
    property PenWidth: integer read fPenWidth write fPenWidth;
    property LineWidth: Double read fLineWidth;
  public
    constructor Create(St: TPoint);
    procedure Draw(Canvas: TCanvas); override;
  end;

  TEllipseDrawStyle = (edsSimple, edsFilled);

  TEllipse = class(TFigure)
  private
    eds: TEllipseDrawStyle;
    fPenWidth: integer;
    fBrushColor: TColor;
    fUpperLeft: TPoint;
    fLowerRight: TPoint;
  published
    property PenWidth: integer read fPenWidth write fPenWidth;
    property DrawStyle: TEllipseDrawStyle read eds write eds;
    property BrushColor: TColor read fBrushColor write fBrushColor;
    property UpLeftPoint: TPoint read fUpperLeft write fUpperLeft;
    property LowRigthPoint: TPoint read fLowerRight write fLowerRight;
  public
    constructor Create(UL, LR: TPoint; aDrawStyle: TEllipseDrawStyle);
    procedure Draw(Canvas: TCanvas); override;
  end;

  TCircle = class(TEllipse)
  private
    {
      Координаты центра: UpLeftPoint;
      Координаты точки на окружности: LowRigth;
    }
    function fRadius: Double;
  published
    property Radius: Double read fRadius;
  public
    procedure Draw(Canvas: TCanvas); override;
  end;

  TSimpleBrush = class(TPoints)
  private
    fPenWidth: integer;
    function FillPoints(Index: integer; Canvas: TCanvas): TArrayOfPoints;
  published
    property PenWidth: integer read fPenWidth write fPenWidth;
  public
    procedure Draw(Canvas: TCanvas); override;
    procedure DrawLast(Canvas: TCanvas);
  end;

  TFItems = array of TFigure;

  TFigures = class
  private
    fItems: TFItems;
    function fCount: integer;
    function fLast: TFigure;
  published
    property Items: TFItems read fItems write fItems;
    property Count: integer read fCount;
    property Last: TFigure read fLast;
  public
    constructor Create;
    procedure Add(Figure: TCircle); overload;
    procedure Add(Figure: TEllipse); overload;
    procedure Add(Figure: TLine); overload;
    procedure Add(Figure: TPoints); overload;
    procedure Add(Figure: TSimpleBrush); overload;
    procedure Delete(Index: integer);
    procedure Draw(Canvas: TCanvas); overload;
    procedure Draw(Canvas: TCanvas; aLayer: integer); overload;
    procedure Draw(var Last: integer; Canvas: TCanvas); overload;
  end;

  TPaintStyle = (psPen, psBrush, psLine, psEllipse);

  TPaintSettings = class
  private
    psBrushWidth: integer;
    psLineWidth: integer;
    psEllipseWidth: integer;
    psEllipseStyle: TEllipseDrawStyle;
    psPenColor: TColor;
    psBrushColor: TColor;
    psLineColor: TColor;
    psEllipseExColor: TColor;
    psEllipseInColor: TColor;
    psPaintStyle: TPaintStyle;
  published
    property PaintStyle: TPaintStyle read psPaintStyle write psPaintStyle;
    property PenColor: TColor read psPenColor write psPenColor;
    property BrushWidth: integer read psBrushWidth write psBrushWidth;
    property BrushColor: TColor read psBrushColor write psBrushColor;
    property LineWidth: integer read psLineWidth write psLineWidth;
    property LineColor: TColor read psLineColor write psLineColor;
    property EllipseWidth: integer read psEllipseWidth write psEllipseWidth;
    property EllipseStyle: TEllipseDrawStyle read psEllipseStyle write
      psEllipseStyle;
    property EllipseExColor: TColor read psEllipseExColor write
      psEllipseExColor;
    property EllipseInColor: TColor read psEllipseInColor write
      psEllipseInColor;
  public
    constructor Create;
    procedure SetOptions(F: TPoints); overload;
    procedure SetOptions(F: TSimpleBrush); overload;
    procedure SetOptions(F: TLine); overload;
    procedure SetOptions(F: TEllipse); overload;
    procedure SetOptions(F: TCircle); overload;
  end;

implementation

{ TFigure }

procedure TFigure.Draw(Canvas: TCanvas);
begin
  //
end;

{ TPoints }

procedure TPoints.AddPoint(p: TPoint);
begin
  SetLength(fPoints, fCount + 1);
  fPoints[fCount - 1] := p;
end;

procedure TPoints.Clear;
begin
  SetLength(fPoints, 0);
end;

constructor TPoints.Create(StartPoint: TPoint);
begin
  SetLength(fPoints, 1);
  fPoints[0] := StartPoint;
end;

procedure TPoints.Draw(Canvas: TCanvas);
var
  i: integer;
begin
  Canvas.MoveTo(fPoints[0].X, fPoints[0].Y);
  for i := 1 to fCount - 1 do
  begin
    Canvas.LineTo(fPoints[i].X, fPoints[i].Y);
  end;
  //  Canvas.Pixels[fPoints[i].X, fPoints[i].Y] := fPenColor;
end;

procedure TPoints.DrawLast(Canvas: TCanvas);
begin
  if fCount = 0 then
    Exit;
  if fCount < 2 then
    Canvas.Pixels[fPoints[0].X, fPoints[0].Y] := fColor
  else
  begin
    Canvas.MoveTo(fPoints[fCount - 2].X, fPoints[fCount - 2].Y);
    Canvas.LineTo(fPoints[fCount - 1].X, fPoints[fCount - 1].Y);
  end;
end;

function TPoints.fCount: integer;
begin
  Result := Length(fPoints);
end;

{ TLine }

function TLine.fLineWidth: Double;
begin
  Result := sqrt(power(fStPoint.X - fEnPoint.X, 2) + power(fStPoint.Y +
    fEnPoint.Y, 2));
end;

constructor TLine.Create(St: TPoint);
begin
  fStPoint := St;
  fEnPoint := St;
end;

procedure TLine.Draw(Canvas: TCanvas);
begin
  with Canvas do
  begin
    Pen.Width := fPenWidth;
    Pen.Color := fColor;
    Pen.Mode := pmCopy;
    MoveTo(fStPoint.X, fStPoint.Y);
    LineTo(fEnPoint.X, fEnPoint.Y);
  end;
end;

{ TEllipse }

constructor TEllipse.Create(UL, LR: TPoint; aDrawStyle: TEllipseDrawStyle);
begin
  fUpperLeft := UL;
  fLowerRight := LR;
  eds := aDrawStyle;
end;

procedure TEllipse.Draw(Canvas: TCanvas);
begin
  with Canvas do
  begin
    Pen.Color := fColor;
    PenWidth := fPenWidth;
    if eds = edsFilled then
    begin
      Brush.Color := fBrushColor;
      Pen.Mode := pmCopy;
    end
    else
    begin
      Pen.Mode := pmNop;
    end;
    Ellipse(Rect(fUpperLeft, fLowerRight));

  end;
end;

{ TCircle }

procedure TCircle.Draw(Canvas: TCanvas);
var
  r: integer;
begin
  with Canvas do
  begin
    Pen.Color := fColor;
    PenWidth := fPenWidth;
    if eds = edsFilled then
    begin
      Brush.Color := fBrushColor;
      Pen.Mode := pmCopy;
    end
    else
    begin
      Pen.Mode := pmMask;
    end;
    r := Round(Sqrt(Power(fLowerRight.X - fUpperLeft.X, 2) + Power(fLowerRight.Y
      - fUpperLeft.Y, 2)));
    Ellipse(fUpperLeft.X - R, fUpperLeft.Y - R, fUpperLeft.X + R, fUpperLeft.Y
      + R);
  end;
end;

function TCircle.fRadius: Double;
begin
  Result := Sqrt(power(fLowerRight.X - fUpperLeft.X, 2) + power(fLowerRight.Y -
    fUpperLeft.Y, 2));
end;

{ TFigures }

constructor TFigures.Create;
begin
  SetLength(fItems, 0);
end;

procedure TFigures.Draw(Canvas: TCanvas);
var
  i: integer;
begin
  for i := 0 to fCount - 1 do
    fItems[i].Draw(Canvas);
end;

procedure TFigures.Delete(Index: integer);
var
  i: integer;
begin
  if Index >= fCount then
    Exit;
  for i := Index to fCount - 2 do
  begin
    fItems[i] := fItems[i + 1];
  end;
  SetLength(fItems, fCount - 1);
end;

procedure TFigures.Draw(Canvas: TCanvas; aLayer: integer);
var
  i: integer;
begin
  for i := 0 to fCount - 1 do
    if fItems[i].Layer = aLayer then
      fItems[i].Draw(Canvas);
end;

function TFigures.fCount: integer;
begin
  Result := Length(fItems);
end;

procedure TFigures.Draw(var Last: integer; Canvas: TCanvas);
var
  i: integer;
begin
  Last := Min(Last, fCount - 1);
  for i := 0 to Last do
    fItems[i].Draw(Canvas);
end;

function TFigures.fLast: TFigure;
begin
  Result := fItems[fCount - 1];
end;

procedure TFigures.Add(Figure: TEllipse);
begin
  SetLength(fItems, fCount + 1);
  fItems[fCount - 1] := Figure;
end;

procedure TFigures.Add(Figure: TCircle);
begin
  SetLength(fItems, fCount + 1);
  fItems[fCount - 1] := Figure;
end;

procedure TFigures.Add(Figure: TLine);
begin
  SetLength(fItems, fCount + 1);
  fItems[fCount - 1] := Figure;
end;

procedure TFigures.Add(Figure: TSimpleBrush);
begin
  SetLength(fItems, fCount + 1);
  fItems[fCount - 1] := Figure;
end;

procedure TFigures.Add(Figure: TPoints);
begin
  SetLength(fItems, fCount + 1);
  fItems[fCount - 1] := Figure;
end;

{ TSimpleBrush }

procedure TSimpleBrush.Draw(Canvas: TCanvas);
var
  i: integer;
begin
  with Canvas do
  begin
    for i := 0 to fCount - 1 do
    begin
      FillPoints(i, Canvas);
    end;
  end;
end;

procedure TSimpleBrush.DrawLast(Canvas: TCanvas);
begin
  FillPoints(fCount - 1, Canvas);
end;

function TSimpleBrush.FillPoints(Index: integer; Canvas: TCanvas):
  TArrayOfPoints;
var
  arlen, X, Y, cX, cY, od, i, fpx, fpy, lpx, lpy: integer;
begin
  if fPenWidth < 3 then
    arlen := fPenWidth * fPenWidth
  else
    arlen := fPenWidth * fPenWidth - 4;
  SetLength(Result, arlen);
  Result[0] := fPoints[Index];
  case fPenWidth of
    2:
      begin
        Result[1] := Point(fPoints[Index].X + 1, fPoints[Index].Y + 1);
        Result[2] := Point(fPoints[Index].X + 1, fPoints[Index].Y);
        Result[3] := Point(fPoints[Index].X, fPoints[Index].Y + 1);
      end;
    3..9:
      begin
        od := 0;
        if (fPenWidth mod 2 = 0) then
          od := 1;
        cX := fPoints[Index].X;
        cY := fPoints[Index].Y;
        i := 1;
        fpx := cX - (fPenWidth div 2) + od;
        lpx := cX + (fPenWidth div 2);
        fpy := cY - (fPenWidth div 2) + od;
        lpy := cY + (fPenWidth div 2);
        for X := fpx to lpx do
          for Y := fpy to lpy do
          begin
            if ((X = fpx) or (X = lpx)) and ((Y = fpy) or (Y = lpy)) then
              Continue;
            if fPenWidth > 6 then
            begin
              if (X = fpx) then
                if (Y = fpy + 1)or(Y = lpy - 1) then
                  Continue;
              if (X = fpx + 1) then
                if (Y = fpy)or(Y = lpy) then
                  Continue;
              if (X = lpx) then
                if (Y = fpy + 1)or(Y = lpy - 1) then
                  Continue;
              if (X = lpx - 1) then
                if (Y = fpy)or(Y = lpy) then
                  Continue;
            end;
            Result[i] := Point(X, Y);
            Canvas.Pixels[X, Y] := fColor;
          end;
      end;
  end;
  for i := 0 to Length(Result) - 1 do
    Canvas.Pixels[Result[i].X, Result[i].Y] := fColor;
end;

{ TPaintSettings }

procedure TPaintSettings.SetOptions(F: TPoints);
begin
  //
  F.Color := psPenColor;
end;

procedure TPaintSettings.SetOptions(F: TLine);
begin
  //
  F.PenWidth := psLineWidth;
  F.Color := psLineColor;
end;

constructor TPaintSettings.Create;
begin
  psBrushWidth := 2;
  psBrushColor := clBlack;
  psLineWidth := 1;
  psLineColor := clBlack;
  psEllipseWidth := 1;
  psEllipseStyle := edsSimple;
  psEllipseExColor := clBlack;
  psEllipseInColor := clWhite;
  psPenColor := clBlack;
  psPaintStyle := psPen;
end;

procedure TPaintSettings.SetOptions(F: TCircle);
begin
  //
  F.PenWidth := psEllipseWidth;
  F.BrushColor := psEllipseInColor;
  F.Color := psEllipseExColor;
  F.DrawStyle := psEllipseStyle;
end;

procedure TPaintSettings.SetOptions(F: TEllipse);
begin
  //
  F.PenWidth := psEllipseWidth;
  F.BrushColor := psEllipseInColor;
  F.Color := psEllipseExColor;
  F.DrawStyle := psEllipseStyle;
end;

procedure TPaintSettings.SetOptions(F: TSimpleBrush);
begin
  F.PenWidth := psBrushWidth;
  F.Color := psBrushColor;
end;

end.

