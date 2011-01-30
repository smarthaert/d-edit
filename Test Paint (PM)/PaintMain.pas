unit PaintMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, XPMan, Menus,  Buttons, ImgList,Math, StdCtrls,  Figures,
  ComCtrls, ToolWin, Mask, ExtDlgs, Jpeg, NewParametersWindow, ColorGrd ;

type
  TMainPaintForm = class(TForm)
    XPManifest1: TXPManifest;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ScrollBox1: TScrollBox;
    PaintBox: TImage;
    TopTBImageList: TImageList;
    TopTB: TToolBar;
    BTNew: TToolButton;
    BTOpen: TToolButton;
    BTSave: TToolButton;
    PaintTb: TPanel;
    TBPen: TSpeedButton;
    TBBrush: TSpeedButton;
    TBLine: TSpeedButton;
    TBEllipse: TSpeedButton;
    Bevel1: TBevel;
    StatusBar1: TStatusBar;
    BrushSettingsPanel: TPanel;
    BrushWidthSpeedButton: TSpeedButton;
    BrushWidthPopup: TPopupMenu;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    BrushWidthImageList: TImageList;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    N11: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    SavePictureDialog1: TSavePictureDialog;
    ColorGrid1: TColorGrid;
    Panel1: TPanel;
    Shape1: TShape;
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure TBPenClick(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetBrushStyle(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShowAHint(Sender: TObject);
    procedure BrushWidthSpeedButtonClick(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ColorGrid1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  FillSelected,       
  BorderSelected: Boolean;
  BrushStyle: TBrushStyle;
  PenStyle: TPenStyle;
  PenWide: Integer;
  CurrentFile: string;
  Bitmap: TBitmap;
  JpegIm: TJpegImage;
  color1: integer;
  color2: integer;
  procedure SaveStyles;
  procedure RestoreStyles;
  end;

procedure TempPaint(pSt: TPaintStyle; St, En: TPoint);
var
  MainPaintForm: TMainPaintForm;
  CurPaintStyle: TPaintStyle;
  CurPos, StartPos: TPoint; // Начальная и текущая позиции рисования
  HintPos: TPoint;
  Painting: boolean = false;
  Figures: TFigures;
  PSettings: TPaintSettings;

implementation

uses DateUtils;

{$R *.dfm}

procedure TempPaint(pSt: TPaintStyle; St, En: TPoint);
var
  R: integer;
begin
  with MainPaintForm.PaintBox.Canvas do
  begin
    Pen.Mode := pmNotXor;
    if pSt = psEllipse then
    begin
      r := Round(Sqrt(Power(En.X - St.X, 2) + Power(En.Y - St.Y, 2)));
      Ellipse(St.X - R, St.Y - R, St.X + R, St.Y + R);
    end
    else
    begin
      MoveTo(st.X, st.Y);
      LineTo(en.X, en.Y);
    end;
  end;
end;

{ TMainPaintForm }
procedure TMainPaintForm.ColorGrid1Change(Sender: TObject);
begin
     color1:=ColorGrid1.ForeGroundColor;
     color2:=ColorGrid1.BackgroundColor;
     Shape1.Brush.Color:=ColorGrid1.ForeGroundColor;
end;

procedure TMainPaintForm.Exit1Click(Sender: TObject);
begin
 Close;
end;

procedure TMainPaintForm.SetBrushStyle(Sender: TObject);
 var i:Integer;
begin
 with paintbox.Canvas.Brush do
   Style := TBrushStyle((Sender as TComponent).Tag - 1);
 if Sender is TMenuItem then
  begin
  (Sender as TMenuItem).Checked := True;
   with TopTB do
   for i:=0 to ButtonCount-1 do
    with Buttons[i] do
    if Tag = (Sender as TComponent).Tag
      then Down := True
       else if (Style=tbsCheck) and Grouped then Down := False;
  end;
end;

procedure TMainPaintForm.New1Click(Sender: TObject);
begin
  with NewParameters do
  begin
    ActiveControl := WidthEdit;
    WidthEdit.Text := IntToStr(Paintbox.Picture.Graphic.Width);
    HeightEdit.Text := IntToStr(Paintbox.Picture.Graphic.Height);
    if ShowModal <> idCancel then
    begin
      Bitmap := TBitmap.Create;
      Bitmap.Width := StrToInt(WidthEdit.Text);
      Bitmap.Height := StrToInt(HeightEdit.Text);
      Paintbox.Picture.Graphic := Bitmap;
      CurrentFile := EmptyStr;
    end;
  end;
end;

procedure TMainPaintForm.Open1Click(Sender: TObject);
  begin
  {if OpenPictureDialog1.Execute then
  begin
  CurrentFile := OpenPictureDialog1.FileName;
  SaveStyles;
  paintbox.Picture.LoadFromFile(CurrentFile);
  RestoreStyles;
  end;  (открытие bmp файла)}
  if OpenPictureDialog1.Execute = false then
    Exit;
  Bitmap := TBitMap.Create;
  JpegIm := TJpegImage.Create;
  JpegIm.LoadFromFile(OpenPictureDialog1.FileName);
  Bitmap.Assign(JpegIm);
  paintbox.Canvas.Draw(0, 0, Bitmap);
  Bitmap.Destroy;
  JpegIm.Destroy;
end;

procedure TMainPaintForm.Save1Click(Sender: TObject);
var
  jpg: TJpegImage;
  begin
    if SavePictureDialog1.Execute then
begin
  JpegIm := TJpegImage.Create;
  JpegIm.Assign(paintbox.picture.graphic);
  JpegIm.CompressionQuality := 50;  {степень сжатия  1..100}
  JpegIm.Compress;
  JpegIm.SaveToFile(ChangeFileext ( SavePictureDialog1.filename,'_.JPG' )) ;
  JpegIm.free;
   end;
 end;

procedure TMainPaintForm.TBPenClick(Sender: TObject);
begin
  if Sender = TBPen then
    CurPaintStyle := psPen;
  if Sender = TBBrush then
    CurPaintStyle := psBrush;
  if Sender = TBLine then
    CurPaintStyle := psLine;
  if Sender = TBEllipse then
    CurPaintStyle := psEllipse;
end;

procedure TMainPaintForm.PaintBoxMouseDown(Sender: TObject; Button:
  TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  StartPos := Point(X, Y);
  CurPos := StartPos;
  case CurPaintStyle of
    psPen:
      begin
        Figures.Add(TPoints.Create(StartPos));
        PSettings.SetOptions(TPoints(Figures.Last));
        with TPoints(Figures.Last) do
        begin
          DrawLast(PaintBox.Canvas);
          PaintBox.Canvas.Pen.Color := color1;
          PaintBox.Canvas.Pen.Width := BrushWidthSpeedButton.Tag;
        end;
      end;
    psBrush:
      begin
        Figures.Add(TSimpleBrush.Create(StartPos));
        PSettings.SetOptions(TSimpleBrush(Figures.Last));
        with TSimpleBrush(Figures.Last) do
        begin
          Color := color1;
          PenWidth:= (BrushWidthSpeedButton.Tag);
          DrawLast(PaintBox.Canvas);
        end;
      end;
    psLine:
      begin
        Figures.Add(TLine.Create(StartPos));
        PSettings.SetOptions(TLine(Figures.Last));
        with TLine(Figures.Last) do
        begin
          PenWidth:= BrushWidthSpeedButton.Tag;
          Color := color1;
        end;
      end;
    psEllipse:
      begin
        Figures.Add(TCircle.Create(StartPos, StartPos, edsSimple));
        PSettings.SetOptions(TCircle(Figures.Last));
        with TEllipse(Figures.Last) do
        begin
         PaintBox.Canvas.Pen.Width:= BrushWidthSpeedButton.Tag;
         Color := color1;
        end;
      end;
  end;
  Painting := true;
end;

procedure TMainPaintForm.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  HintPos := Point(X, Y);
  PaintBox.Hint := 'X=' + inttostr(HintPos.X) + ' ' + 'Y=' +
    inttostr(HintPos.Y);
  if not Painting then
    exit;
  case CurPaintStyle of
    psPen:
      begin
        TPoints(Figures.Last).AddPoint(Point(X, Y));
        TPoints(Figures.Last).DrawLast(PaintBox.Canvas);
      end;
    psBrush:
      begin
        TSimpleBrush(Figures.Last).AddPoint(Point(X, Y));
        TSimpleBrush(Figures.Last).DrawLast(PaintBox.Canvas);
      end;
    psLine:
      begin
        TempPaint(CurPaintStyle, StartPos, CurPos);
        CurPos := Point(X, Y);
        TempPaint(CurPaintStyle, StartPos, CurPos);
      end;
    psEllipse:
      begin
        TempPaint(CurPaintStyle, StartPos, CurPos);
        CurPos := Point(X, Y);
        TempPaint(CurPaintStyle, StartPos, CurPos);
      end;
  end;
end;

procedure TMainPaintForm.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not Painting then
    exit;
  case CurPaintStyle of
    psPen:
      begin
        TPoints(Figures.Last).AddPoint(Point(X, Y));
        TPoints(Figures.Last).DrawLast(PaintBox.Canvas);
      end;
    psBrush:
      begin
        TSimpleBrush(Figures.Last).AddPoint(Point(X, Y));
        TSimpleBrush(Figures.Last).DrawLast(PaintBox.Canvas);
      end;
    psLine:
      begin
        TempPaint(CurPaintStyle, StartPos, CurPos);
        TLine(Figures.Last).EndPoint := Point(X, Y);
        Figures.Last.Draw(PaintBox.Canvas);
      end;
    psEllipse:
      begin
        TempPaint(CurPaintStyle, StartPos, CurPos);
        TCircle(Figures.Last).LowRigthPoint := Point(X, Y);
        Figures.Last.Draw(PaintBox.Canvas);
      end;
  end;
  Painting := false;
  StatusBar1.Panels[1].Text := '';
end;

procedure TMainPaintForm.FormCreate(Sender: TObject);
begin
  Application.OnHint := ShowAHint;
  Figures := TFigures.Create;
  PSettings := TPaintSettings.Create;
  Bitmap := TBitMap.Create;
  JpegIm := TJpegImage.Create;
  JpegIm.LoadFromFile('logo_.JPG');
  Bitmap.Assign(JpegIm);
  paintbox.Canvas.Draw(0, 0, Bitmap);
  Bitmap.Destroy;
  JpegIm.Destroy;
  BrushWidthSpeedButton.Tag := 1  ;
end;

procedure TMainPaintForm.ShowAHint(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := Application.Hint;
end;

procedure TMainPaintForm.FormActivate(Sender: TObject);
begin
  New1Click(New1);
end;

procedure TMainPaintForm.BrushWidthSpeedButtonClick(Sender: TObject);
var
  p: TPoint;
begin
GetCursorPos(p);
BrushWidthSpeedButton.PopupMenu.Popup(p.X, p.Y);
end;

procedure TMainPaintForm.SaveStyles;
begin
  with paintbox.Canvas do
  begin
    BrushStyle := Brush.Style;
    PenStyle := Pen.Style;
    PenWide := Pen.Width;
  end;
end;

procedure TMainPaintForm.RestoreStyles;
begin
  with paintbox.Canvas do
  begin
    Brush.Style := BrushStyle;
    Pen.Style := PenStyle;
    Pen.Width := PenWide;
  end;
end;

procedure TMainPaintForm.N91Click(Sender: TObject);
begin
BrushWidthSpeedButton.Glyph := nil;
BrushWidthPopup.Images.GetBitmap(TMenuItem(Sender).ImageIndex,BrushWidthSpeedButton.Glyph);
BrushWidthSpeedButton.Tag := TMenuItem(Sender).ImageIndex + 1
end;
end.

