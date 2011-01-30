uses CRT;

{ Очередь }
type
  FIFO = object
    ArrW : array [0..5] of integer;
    Head : word; { Индекс головы }
    Tail : word; { Индекс хвоста, куда добавляем элементы }
    constructor Init;
    destructor Done;
    procedure Put( a : integer );
    function Get : integer;
    function Empty : boolean;
    function Full : boolean;
    function MaxSize : word;
    function Size : word;
    procedure Show;
  end;

constructor FIFO.Init;
begin
  Head := 0;
  Tail := 0;
end;

destructor FIFO.Done;
begin
end;

procedure FIFO.Put;
begin
  if not Full then begin
    Tail := Tail + 1;
    ArrW[Tail mod MaxSize] := a;
  end else
    writeln('# Очередь полна: не могу положить в неё ',a,'!');
end;

function FIFO.Get : integer;
begin
  if not Empty then begin
    Head := Head + 1;
    Get := ArrW[Head mod MaxSize];
  end else begin
    writeln('# Очередь пуста! Доставать нечего! Возвращаем 0');
    Get := 0;
  end;
end;

function FIFO.Empty : boolean;
begin
  Empty := Tail = Head;
end;

function FIFO.Full : boolean;
begin
  Full := Size = MaxSize;
end;

function FIFO.MaxSize : word;
begin
  MaxSize := high(ArrW)-low(ArrW)+1;
end;

function FIFO.Size : word;
begin
  Size := Tail-Head;
end;

procedure FIFO.Show;
var i:integer;
begin
  for i:=Head+1 to Tail do
    write(' ',ArrW[i mod MaxSize]);
  writeln;
end;

type
  FIFOX = object(FIFO)
    procedure PutFirst( a : integer );
  end;

procedure FIFOX.PutFirst;
begin
  if not Full then begin
    ArrW[Head mod MaxSize] := a;
    Head := Head - 1;
  end else
    writeln('# Очередь полна: не могу положить в неё ',a,'!');
end;

var F : FIFOX;
begin
  ClrScr;
  F.Init;
  writeln('Сейчас будет сообщение об ошибке, потому что очередь пуста!');
  F.Get;
  F.Put(11);
  writeln('Добавили 1 элемент');
  F.Show;
  F.Put(14);
  writeln('Добавили 2-ой элемент');
  F.Show;
  F.Put(1234);
  F.Put(235);
  F.Put(435);
  F.Put(23);
  writeln('Добавили ещё 4 элемента');
  F.Show;
  F.Put(3423);
  writeln('Забираем элемент: ',F.Get);
  F.Show;
  F.PutFirst(444);
  F.Show;
end.