unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons;

type
  TAR1 = array of extended;
  TAR = array of TAR1;
  TForm1 = class(TForm)
    SG1: TStringGrid;
    SG2: TStringGrid;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SG3: TStringGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SG1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SG2SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SG3SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Edit4Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  A1, A2, A3: array of TAR1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  halt;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  x, y: integer;
begin
  if (SG1.ColCount <> SG2.ColCount) or
    (SG1.RowCount <> SG2.RowCount) then
  begin
    ShowMessage('Error in matrixes sizes!');
    exit;
  end;
  SG3.RowCount := SG1.RowCount;
  SG3.ColCount := SG1.ColCount;
  for x := 0 to SG1.ColCount - 1 do
  begin
    SetLength(a3[x], SG1.RowCount);
    for y := 0 to SG1.RowCount - 1 do
    begin
      a1[x, y] := strtofloat(SG1.Cells[x, y]);
      a2[x, y] := strtofloat(SG2.Cells[x, y]);
      a3[x, y] := a1[x, y] + a2[x, y];
      SG3.Cells[x, y] := floattostr(a3[x, y]);
    end;
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);

  function max(q, w: integer): integer;
  begin
    if q > w then
      max := q
    else
      max := w;
  end;
var
  x, y: integer;
  i: integer;
begin

  if not trystrtoint(Edit1.Text + Edit2.Text + Edit3.Text + Edit4.Text, i) then
    Exit;
  with Form1 do
  begin
    SG1.RowCount := strtoint(Edit1.Text);
    SG1.ColCount := strtoint(Edit2.Text);
    SG2.RowCount := strtoint(Edit3.Text);
    SG2.ColCount := strtoint(Edit4.Text);
  end;

  SetLength(A1, SG1.ColCount);
  SetLength(A2, SG2.ColCount);
  SetLength(A3, max(SG1.ColCount, SG2.ColCount) * max(SG1.RowCount,
    SG2.RowCount));

  for x := 0 to SG1.ColCount - 1 do
  begin
    Setlength(a1[x], SG1.RowCount);
    for y := 0 to SG1.RowCount - 1 do
    begin
      a1[x, y] := random(10);
      if SG1.Cells[x, y] = '' then
        SG1.Cells[x, y] := inttostr(random(10));
    end;
  end;

  for x := 0 to SG2.ColCount - 1 do
  begin
    Setlength(a2[x], SG2.RowCount);
    for y := 0 to SG2.RowCount - 1 do
    begin
      a2[x, y] := random(10);
      if SG2.Cells[x, y] = '' then
        SG2.Cells[x, y] := inttostr(random(10));
    end;
  end;

  {for x:=1 to SG1.ColCount do setlength(a1[x],SG1.RowCount);
  for x:=1 to SG2.ColCount do setlength(a1[x],SG2.RowCount);}
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
var
  x, y, i: integer;
  sum: extended;
begin
  if SG1.ColCount <> SG2.RowCount then
  begin
    ShowMessage('Error in matrixes sizes!');
    exit;
  end;
  SG3.RowCount := SG1.RowCount;
  SG3.ColCount := SG2.ColCount;

  for x := 1 to SG1.ColCount do
    for y := 1 to SG1.RowCount do
    begin
      a1[x - 1, y - 1] := strtofloat(SG1.Cells[x - 1, y - 1]);
    end;

  for x := 1 to SG2.ColCount do
    for y := 1 to SG2.RowCount do
    begin
      a2[x - 1, y - 1] := strtofloat(SG2.Cells[x - 1, y - 1]);
    end;

  for x := 1 to SG1.RowCount do
    for y := 1 to SG2.ColCount do
    begin
      sum := 0;
      for i := 1 to SG1.ColCount do
        sum := sum + a1[i - 1, x - 1] * a2[y - 1, i - 1];
      SG3.Cells[y - 1, x - 1] := floattostr(sum);
    end;

end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  x, y: integer;
begin
  if (SG1.ColCount <> SG2.ColCount) or
    (SG1.RowCount <> SG2.RowCount) then
  begin
    ShowMessage('Error in matrixes sizes!');
    exit;
  end;
  SG3.RowCount := SG1.RowCount;
  SG3.ColCount := SG1.ColCount;
  for x := 0 to SG1.ColCount - 1 do
  begin
    SetLength(a3[x], sg1.RowCount);
    for y := 0 to SG1.RowCount - 1 do
    begin
      a1[x, y] := strtofloat(SG1.Cells[x, y]);
      a2[x, y] := strtofloat(SG2.Cells[x, y]);
      a3[x, y] := a1[x, y] - a2[x, y];
      SG3.Cells[x, y] := floattostr(a3[x, y]);
    end;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);

  function max(q, w: integer): integer;
  begin
    if q > w then
      max := q
    else
      max := w;
  end;
var
  x, y: integer;
begin
  {SetLength(A1,1000);
  SetLength(A2,1000);
  SetLength(A3,1000);}
  {for x:=1 to 100 do
    begin
    SetLength(A1[x],100);
    SetLength(A2[x],100);
    SetLength(A3[x],100);
    end;}

  SG1.RowCount := strtoint(Edit1.Text);
  SG1.ColCount := strtoint(Edit2.Text);
  SG2.RowCount := strtoint(Edit3.Text);
  SG2.ColCount := strtoint(Edit4.Text);

  {SetLength(A1,SG1.ColCount*SG1.RowCount);
  SetLength(A2,SG2.ColCount*SG2.RowCount);
  SetLength(A3,max(SG1.ColCount,SG2.ColCount)*max(SG1.RowCount,SG2.RowCount));}
  SetLength(A1, SG1.ColCount);
  SetLength(A2, SG2.ColCount);
  SetLength(A3, max(SG1.ColCount, SG2.ColCount) * max(SG1.RowCount,
    SG2.RowCount));

  randomize;
  for x := 0 to SG1.ColCount - 1 do
  begin
    Setlength(a1[x], SG1.RowCount);
    for y := 0 to SG1.RowCount - 1 do
    begin
      a1[x, y] := (trunc(3 * random) + 1) / 1;
      SG1.Cells[x, y] := floattostr(a1[x, y]);
    end;
  end;

  for x := 0 to SG2.ColCount - 1 do
  begin
    Setlength(a2[x], SG2.RowCount);
    for y := 0 to SG2.RowCount - 1 do
    begin
      a2[x, y] := (trunc(3 * random) + 1) / 1;
      SG2.Cells[x, y] := floattostr(a2[x, y]);
    end;
  end;

  {  for y:=0 to 5 do
      begin
      SG1.Cells[x, y]:=floattostr((trunc(3*random)+1)/1);
      SG2.Cells[x, y]:=floattostr((trunc(3*random)+1)/1);
      end;}

  {for x:=1 to SG1.ColCount do setlength(a1[x],SG1.RowCount);
  for x:=1 to SG2.ColCount do setlength(a2[x],SG2.RowCount);}

end;

procedure TForm1.SG1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  i, j, t: integer;
begin
  Form1.Label5.Caption := TStringGrid(Sender).Cells[Acol, Arow];
  for i := 0 to TStringGrid(Sender).ColCount - 1 do
    for j := 0 to TStringGrid(Sender).RowCount - 1 do
      if not TryStrToInt(TStringGrid(Sender).Cells[i, j], t) then
        TStringGrid(Sender).Cells[i, j] := '';
end;

procedure TForm1.SG2SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  Form1.Label5.Caption := SG2.Cells[Acol, Arow];
end;

procedure TForm1.SG3SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  Form1.Label5.Caption := SG3.Cells[Acol, Arow];
end;

procedure TForm1.Edit4Exit(Sender: TObject);
var
  i: integer;
begin
  if not trystrtoint(TEdit(Sender).Text, i) then
    TEdit(Sender).Text := '';
end;

end.

