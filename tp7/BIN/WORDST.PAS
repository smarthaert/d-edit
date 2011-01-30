uses CRT;

{ Реализация простейшего стека на базе массива }
type
  TStackElement = integer;
  TWordStack = object
    ArrW : array [1..5] of TStackElement;
    IndTop : word; { Индекс вершины }
    constructor Init;
    destructor Done;
    procedure Put( a : TStackElement );
    function Get : TStackElement;
    function Empty : boolean;
    function Full : boolean;
  end;

constructor TWordStack.Init;
begin
  IndTop := 0; { Сначала в стеке 0 слов }
end;

destructor TWordStack.Done;
begin
end;

procedure TWordStack.Put;
begin
  if not Full then begin
    IndTop := IndTop + 1;
    ArrW[IndTop] := a;
  end else
    writeln('# Стек полон: не могу положить в него ',a,'!');
end;

function TWordStack.Get : word;
begin
  if not Empty then begin
    Get := ArrW[IndTop];
    IndTop := IndTop - 1;
  end else begin
    writeln('# Стек пуст! Доставать нечего! Возвращаем 0');
    Get := 0;
  end;
end;

function TWordStack.Empty : boolean;
begin
  Empty := IndTop = 0;
end;

function TWordStack.Full : boolean;
begin
  Full := IndTop = high(ArrW);
end;

var
  W : TWordStack;
  i : integer;
begin
  ClrScr; { Очищаем экран }
  W.Init;
  writeln('Должно быть сообщение что стек пуст!');
  writeln('Потому что мы только что инициализировали и сразу Get');
  writeln('до того как что-либо положили в стек');
  W.Get;
  writeln('Кладём в стек 6 элементов от 1 до 6. При помещении 6-ого');
  writeln('должно быть сообщение что стек полон!');
  for i:=1 to 6 do
    W.Put(i);
  for i:=1 to 6 do
    writeln('Извлекаем последний элемент: ',W.Get);
end.