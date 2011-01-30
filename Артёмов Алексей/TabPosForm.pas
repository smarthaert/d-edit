unit TabPosForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Menus, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    StringGrid1: TStringGrid;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel1: TPanel;
    Button6: TButton;
    Button7: TButton;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);

    procedure DeleteRow;
    procedure InsertRow;
    procedure SummCol;
    procedure Result;
    procedure SCell(f: integer);


    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
    Rect: TRect; State: TGridDrawState);
    procedure ColorRow0;
    procedure ColorRow(State: TGridDrawState;  Clr1, Clr2: TColor);

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N5Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ARow, ACol : Integer;

implementation

{$R *.dfm}

//назвать столбцы таблицы
procedure TForm1.FormShow(Sender: TObject);
begin
StringGrid1.Cells[0,0]:='Позиция';
StringGrid1.Cells[1,0]:='Текущая Цена';
StringGrid1.Cells[2,0]:='Цена Сделки';
StringGrid1.Cells[3,0]:='Доступно';
StringGrid1.Cells[4,0]:='Объем';
StringGrid1.Cells[5,0]:='Доход/Убыток';
end;

//открыть таблицу из файла при запуске
procedure TForm1.FormCreate(Sender: TObject);
var
  f: textfile;
  temp, x, y: integer;
  tempstr: string;
begin
  if FileExists('FileTab') then
  begin
  assignfile(f, 'FileTab');
  reset(f);
  readln(f, temp);
  StringGrid1.ColCount := temp;
  readln(f, temp);
  StringGrid1.RowCount := temp;
  for X := 0 to StringGrid1.ColCount - 1 do
    for y := 0 to StringGrid1.RowCount - 1 do
    begin
      readln(F, tempstr);
      StringGrid1.Cells[x, y] := tempstr;
    end;
  closefile(f);
  end
    else exit;
  SummCol;
end;

//сохранить таблицу в файл при выходе
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  f: textfile;
  x, y: integer;
begin
  assignfile(f, 'FileTab');
  rewrite(f);
  writeln(f, StringGrid1.ColCount);
  writeln(f, StringGrid1.RowCount);
  for X := 0 to StringGrid1.ColCount - 1 do
    for y := 0 to StringGrid1.RowCount - 1 do
      writeln(F, StringGrid1.Cells[x, y]);
  closefile(f);
end;

//обработчик для меню изменить позицию
procedure TForm1.N6Click(Sender: TObject);
begin
Button1.Visible:=True;
StringGrid1.Options:=StringGrid1.Options-[goRowSelect];
end;

//обработчик для кнопки сохранить изменения
procedure TForm1.Button1Click(Sender: TObject);
begin
Button1.Visible:=False;
StringGrid1.Options:=StringGrid1.Options+[goRowSelect];
StringGrid1.Refresh;
Result;
end;

//обработчик для меню добавить позицию
procedure TForm1.N7Click(Sender: TObject);
begin
Button1.Visible:=True;
StringGrid1.Options:=StringGrid1.Options-[goRowSelect];
InsertRow;
end;

//добавить строку в таблицу
procedure TForm1.InsertRow;
var
  i: integer;
begin
    StringGrid1.RowCount:= StringGrid1.RowCount+1;
    for i:= StringGrid1.RowCount-1 downto 2 do
      for ACol:=0 to 6 do
      StringGrid1.Cells[ACol, i]:= StringGrid1.Cells[ACol, i-1];
    StringGrid1.Rows[1].Clear();
StringGrid1.Refresh;
SummCol;
end;

//обработчик для меню удалить позицию
procedure TForm1.N8Click(Sender: TObject);
begin
DeleteRow;
end;

//удалить строку из таблицы
procedure TForm1.DeleteRow;
var
  i, Pos: integer;
begin
  Pos:= StringGrid1.Row;
  if Pos> 0 then
    begin
    for i:=Pos to StringGrid1.RowCount-1 do
      for ACol:=0 to 6 do
      StringGrid1.Cells[ACol, i]:= StringGrid1.Cells[ACol, i+1];
    end;
  StringGrid1.RowCount:= StringGrid1.RowCount-1;
  StringGrid1.Refresh;
SummCol;
end;

//обработчик для меню справка
procedure TForm1.N5Click(Sender: TObject);
begin
ShowMessage('Алексей Артемов,  Александр Ушаков  гр.7852  E-mail: alekseyhost@mail.ru');
end;

//сумма чисел в столбцах 4,5
procedure TForm1.SummCol;
var i,j,Summ,Ress: Integer;
a : array[1..100] of integer;
//количество строк ограничено 100
begin
   Summ:= 0;
   Ress:= 0;
   for i:=4 to 5 do
   begin
      for j:=1 to 10 do
      if Length(StringGrid1.Cells[i,j]) <>0 then
      a[j]:= StrToInt(StringGrid1.Cells[i,j])
      else a[j] := 0;
      for j:=1 to StringGrid1.RowCount-1 do
      if i= 4 then Summ:= Summ+ a[j]
      else Ress:= Ress+ a[j];
      Label2.Caption:= IntToStr(Summ);
      Label3.Caption:= IntToStr(Ress);
   end;
end;

//результат в ячейках 4,5 одной строки
procedure TForm1.Result;
var
i,j,Vol,Res,Sel: integer;
a : array[1..5] of integer;
begin
    for j:= 1 to StringGrid1.RowCount- 1 do
      begin
      for i:=1 to 5 do
      if Length(StringGrid1.Cells[i,j]) <>0 then
      a[i]:= StrToInt(StringGrid1.Cells[i,j])
      else a[i] := 0;
      Vol:= a[1]* a[3];
      Sel:= a[2]* a[3];
      Res:= Vol- Sel;
      StringGrid1.Cells[4,j]:= IntToStr(Vol);
      StringGrid1.Cells[5,j]:= IntToStr(Res);
      end;
SummCol;
end;

//исключение и порядок ввода букв в ячейки
procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin
If  StringGrid1.Col> 0 then
  begin
  if StringGrid1.Col> 3 then
  key := Chr(0);
      case Key of
      #8,'0'..'9': ;
      #13:
      if StringGrid1.Col< 3 then
         StringGrid1.Col := StringGrid1.Col + 1;
      else key := Chr(0)
      end;
  exit;
  end;
If key in[#13] then
StringGrid1.Col := StringGrid1.Col + 1;
end;

//изменение первой ячейки выделенной строки
procedure TForm1.SCell(f: integer);
var t: integer;
begin
ARow:= StringGrid1.Row;
if Length(StringGrid1.Cells[1,Arow])= 0 then
 StringGrid1.Cells[1,Arow]:= '0';
 //begin
 t:= StrToInt(StringGrid1.Cells[1, ARow])+ f;
 If t>= 0 then
  begin
  StringGrid1.Cells[1, ARow]:= IntToStr(t);
  StringGrid1.Refresh;
  Result;
  end
  else exit;
end;

// обработчик для кнопки -1.0
procedure TForm1.Button2Click(Sender: TObject);
begin
SCell(-1);
end;

// обработчик для кнопки +1.0
procedure TForm1.Button3Click(Sender: TObject);
begin
SCell(1);
end;

// обработчик для кнопки -10.0
procedure TForm1.Button4Click(Sender: TObject);
begin
SCell(-10);
end;

// обработчик для кнопки +10.0
procedure TForm1.Button5Click(Sender: TObject);
begin
SCell(10);
end;

// обработчик для кнопки -100.0
procedure TForm1.Button6Click(Sender: TObject);
begin
SCell(-100);
end;

// обработчик для кнопки +100.0
procedure TForm1.Button7Click(Sender: TObject);
begin
SCell(100);
end;

//выделение строк цветом
procedure TForm1.StringGrid1DrawCell (Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState) ;
var s: integer;
begin
if ARow= 0 then ColorRow0
 else
   begin
   s:= StrToInt(StringGrid1.Cells[5, ARow]);
   If s= 0 then
   begin
   StrToInt(StringGrid1.Cells[5, ARow]);
    ColorRow(State, clYellow, clBlack);
   end
   else
  //   if s> 0 then
     ColorRow(State, clLime, clWhite);
   //  else
    // ColorRow(State, clRed, clWhite);
   if (ARow mod 2) = 0 then
     ColorRow(State, clYellow, clBlack)
   else
     ColorRow(State, clLime, clWhite);

 end;
StringGrid1.Canvas.fillRect(Rect);
StringGrid1.Canvas.TextOut(Rect.Left,Rect.Top,StringGrid1.Cells[ACol,ARow]);
end;

//выделение цветом строки заголовка
procedure TForm1.ColorRow0;
begin
StringGrid1.Canvas.Brush.Color:= clMoneyGreen;
StringGrid1.Canvas.Font.Color:= clBlack;
//StringGrid1.Canvas.Font.Style:= [fsBold];
end;

//выделение цветом строки заданным цветом
procedure TForm1.ColorRow(State: TGridDrawState; Clr1, Clr2: TColor);
var i: integer;
begin
for i:=1 to 5 do
 begin
 if not(gdFocused in State) then
  begin
  StringGrid1.Cells[i,ARow];
  StringGrid1.Canvas.Brush.Color:= Clr1;
  StringGrid1.Canvas.Font.Color:= Clr2;
  //StringGrid1.Canvas.Font.Style:= [fsBold];
  end
  else
  begin
  StringGrid1.Canvas.Brush.Color:= clBlack;
  StringGrid1.Canvas.Font.Color:= clWhite;
  //StringGrid1.Canvas.Font.Style:= [fsBold];
  end;
 end;
end;

end.



