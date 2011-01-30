{ Тема курсовой работы "Ввести шум в изображение и произвести 
  операцию сглаживания шумов вдоль одной из координат" }
program kurs;

uses Graph, CRT;

const
  dy=600; dx=640;
  DirPos = 'images'; { Каталог с картинками }

type
  Dim    = array [1..dx] of byte;
  DimPtr = ^Dim;
  PoI    = array [1..dy] of DimPtr;

var
  seektiff : longint;
  Wx  : longint; { Размер по горизонтали }
  Wy  : longint; { Размер по вертикали }
  ImageFileName : string;
  po  : poi; { Исходное изображение }
  pon : poi; { Изображение с добавленным шумом }
  pof : poi; { Изображение отфильтрованное }


{ Чтение заголовка TIFF файла }
procedure HeadRead( var f:file );
const
  TH : array [0..3] of byte=(73,73,42,0); { II* - байты, которые идут в 
                                   начале файла и обозначают, что это именно TIFF-файл  }
var
  NumberOfTag,IFDlength : integer;
  i,TagType,PoinTyp     : integer;
  comp,PoinAdr          : longint;
  head,IFDInd,BegIFD    : longint;
  TiffHead              : longint absolute TH;
begin
  BlockRead(f,head,4);
  if head<>TiffHead then begin
    Writeln('Это не TIFF - файл');
    Write('Такие файлы я обрабатывать не умею');
    halt;
  end;

  BlockRead(f,BegIFD,4);
  Seek(f,BegIFD);
  BlockRead(f,NumberOfTag,2);

  IFDInd:=BegIFD+2;
  for i:=1 to NumberOfTag do begin
    BlockRead(f,TagType,2);
    case TagType of
      256: begin {размер по горизонтали}
             Inc(IFDInd,8);
             Seek(f,IFDInd);
             BlockRead(f,Wx,4);
           end;
      257: begin {размер по вертикали}
             IFDInd:=IFDInd+8;
             Seek(f,IFDInd);
             BlockRead(f,Wy,4);
           end;
      273: begin {определение начала области данных}
             IFDInd:=IFDInd+2;
             Seek(f,IFDInd);
             BlockRead(f,PoinTyp,2);
             IFDInd:=IFDInd+2;
             Seek(f,IFDInd);
             BlockRead(f,comp,4);
             IFDInd:=IFDInd+4;
             Seek(f,IFDInd);
             if comp=1 then
               BlockRead(f,seektiff,4)
             else begin
               BlockRead(f,PoinAdr,4);
               Seek(f,PoinAdr);
               BlockRead(f,seektiff,PoinTyp);
             end;
           end;
      else begin
             IFDInd:=IFDInd+8;
           end;
    end; {case}
    Inc(IFDInd,4);
    Seek(f,IFDInd);
  end; {окончание чтения Tag'ов}
end; {HeadRead}

{ Вывод одной картинки на экран }
{ dX,dY - смещение картинки относительно верхнего левого угла экрана }
procedure Show( Var Image : poi; dX,dY : integer );
var x,y,col : integer;
begin
  for y:=1 to Wy do
    for x:=1 to Wx do begin
      col:=Image[y]^[x];
      col:=col shr 4;
      putpixel(x+dX,y+dY,col);
    end;
end;

{ Пауза }
procedure Pause;
begin
  SetColor(15);
  OutTextXY(200,GetMaxY-20,'Press any key to continue...');
  ReadKey;
end;

function IntToStr( N : integer ):string;
var Result : string;
begin
  Str( N, Result );
  IntToStr := Result;
end;

{ Вывод изображений на экран }
procedure Vivod;
var
  y : integer;
begin
  for y:=0 to 15 do begin           {установка палитры}
    SetRGBPalette(y,y*4,y*4,y*4);   {16  градаций     }
    SetPalette(y,y);                {серой шкалы      }
  end;

  if 3*Wx<638 then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Show( pof, 2*Wx+4, 10 );
  end else if 3*Wy<478 then begin
    Show( po, 0, 10 );
    Show( pon, 0, 10+2+Wy );
    Show( pof, 0, 10+2*Wy+4 );
  end else if (2*Wx<638) and (2*Wy<478) then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Show( pof, 0, 10+Wy+2 );
  end else if 2*Wy<478 then begin
    Show( po, 0, 10 );
    Show( pon, 0, 10+Wy+2 );
    Pause;
    Show( pon, 0, 10 );
    Show( pof, 0, 10+Wy+2 );
    Pause;
    Show( po, 0, 10 );
    Show( pof, 0, 10+Wy+2 );
  end else if 2*Wx<638 then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Pause;
    Show( pon, 0, 10 );
    Show( pof, Wx+2, 10 );
    Pause;
    Show( po, 0, 10 );
    Show( pof, Wx+2, 10 );
  end else begin
    Show( po, 0, 10 );
    Pause;
    Show( pon, 0, 10 );
    Pause;
    Show( pof, 0, 10 );
  end;

  SetColor(15);
  OutTextXY(10,1,'File: "'+ImageFileName+'"');
  OutTextXY(GetMaxX-220,15,'Picture size: '+IntToStr(Wx)+' x '+IntToStr(Wy));

  Pause;
end;

{ Отводим динамическую память под картинку }
procedure AllocImage( var Image : PoI );
var y : integer;
begin
  for y:=1 to Wy do
    GetMem(Image[y],Wx);
end;

{ Добавление шума: po -> pon }                                           
procedure AddNoise;
var
  a, b, noise, x, y, bn : integer;
  k : byte;
begin
  writeln;
  writeln('= Добавление шума =');
  writeln('Введите число b (отношение сигнал/шум) от 1 до 255');
  repeat
    write('b = '); readln(b);
  until (b>=1) and (b<=255);
  a:=255 div b;

  AllocImage(pon);

  for y:=1 to Wy do 
    for x:=1 to Wx do begin
      { Вычисляем шум для данного пиксела изображения }
      noise := 0;
      for k:=0 to 5 do
        noise := noise + random(a) - a div 2;
      { Добавляем шум }
      bn := po[y]^[x] + noise;
      { Если выход за границы 0..255 => исправляем }
      if bn<0 then bn:=0;
      if bn>255 then bn:=255;
      pon[y]^[x] := bn;
    end;
end;

{ Фильтрация: pon -> pof }
procedure Filter;
var
  p1,p2,p3 : byte;
  x,y,n : integer;
begin
  writeln;
  writeln('= Фильтрация =');
  writeln('Если сглаживать по y, то n=0, по x - n=1');
  repeat
    write('Введите n= '); readln(n);
  until (n=0) or (n=1);

  AllocImage(pof);

  { Усредняем по y }
  if n=0 then
    for y:=2 to Wy-1 do
      for x:=1 to Wx do begin
        { Вычисляем среднее значение из 3-х соседних пикселей }
        p1 := pon[y-1]^[x];
        p2 := pon[y]^[x];
        p3 := pon[y+1]^[x];
        p2 := (p1+p2+p3) div 3;
        pof[y]^[x] := p2;
      end;
  { Усредняем по x }
  if n=1 then 
    for y:=1 to Wy do
      for x:=2 to Wx-1 do begin
        p1 := pon[y]^[x-1];
        p2 := pon[y]^[x];
        p3 := pon[y]^[x+1];
        p2 := (p1+p2+p3) div 3;
        pof[y]^[x] := p2;
      end;
end;

{ Загрузка картинки }
procedure LoadImage;
var
  y,Size : integer;
  f      : file;
begin
  Writeln('Загружаю файл "'+DirPos+'\'+ImageFileName+'"');
  Assign(f,DirPos+'\'+ImageFileName);
  Size:=1;
  Reset(f,Size);
  HeadRead(f); { Чтение заголовка TIFF-файла }
  Seek(f,seektiff);

  AllocImage(po);

  for y:=1 to Wy do {для каждой строки...}
    BlockRead(f,po[y]^,Wx);  {считать строку из файла}
                  {чтение данных из нетипизированного}
                  {файла f в динамическую память     }
                  {Wx*Wy-число читаемых байт         }
  close(f);     {закрыть файл}
end;

{ Исполнительная часть }
var Driv,Mode : integer;
Begin
  { Выводим описание программы и ждём нажатие любой клавиши }
  clrscr;
  writeln('Данная программа производит зашумление изображения');
  writeln('и производит операцию сглаживания шумов');
  writeln('вдоль одной из координат');
  writeln;
  writeln('Автор: Чиркунова Анастасия, группа 7106');
  writeln;
  writeln('Нажмите любую клавишу для продолжения...');
  readkey;

  clrscr;
  If ParamCount > 0 then
    ImageFileName := ParamStr(1)
  else begin
    Write('Введите имя файла из каталога "'+DirPos+'": ');
    Readln(ImageFileName);
  end;
  if ImageFileName='' then begin
    ImageFileName:='mouseb.tif';
    Writeln('Используется картинка "по-умолчанию" - "'+ImageFileName+'"');
  end;

  LoadImage;
  Writeln('Памяти осталось: ',MemAvail);

  AddNoise; { Добавление шума }
  Writeln('Памяти осталось: ',MemAvail);

  Filter; { Фильтрация }
  Writeln('Памяти осталось: ',MemAvail);

  { Переход в графический режим }
  Driv:=9; Mode:=2;
  InitGraph(Driv,Mode,'');
  Vivod;
  Closegraph; { Закрыть графический режим }
End.

