type
  TSet = Set of Byte;

{ Показать берег }
procedure Coast( Humans,Boards:TSet );
var i:integer;
begin
  write(' [');
  for i:=Low(Byte) to High(Byte) do
    if i in Humans then
      write('Ч',i,' ');
  for i:=Low(Byte) to High(Byte) do
    if i in Boards then
      write('Д',i,' ');
  write('] ');
end;

{ Извлечь первый (самый младший) элемент множества }
function Get( var X : TSet ):Byte;
var i:integer;
begin
  for i:=Low(Byte) to High(Byte) do
    if i in X then begin
      X := X - [i]; { Удаляем элемент из множества }
      Get := i; { Возвращаем элемент }
      exit;
    end;
end;

{ Глобальные переменные }
var
  N : integer; { Количество человек, количество досок N+1 }
  HL,HR : TSet; { Люди на левом и на правом берегу }
  BL,BR : TSet; { Доски на правом и на левом берегу }
  { Массив досок в болоте }
  X : array [0..1000] of record { Доска в болоте }
    B : Byte; { Номер доски }
    H : Byte; { Номер человека, 0 - если никого нет }
    R : Real;
  end;
  Left, Right : Integer; { Активный кусочек в массиве досок в болоте }
  W : real; { Ширина болота }
  L : array [1..1000] of Real; { Ширины всех досок }

procedure ShowState;
var i:integer;
begin
  { Выводим левый берег }
  Coast(HL,BL);
  for i:=Left to Right do begin
    write('{Д',X[i].B);
    if X[i].H = 0 then { Если человека нет, то это просто пустая доска }
      write('  } ')
    else
      write(' Ч',X[i].H,'} ');
  end;
  write(X[Right].R:0:1,' ');
  { Выводим правый берег }
  Coast(HR,BR);
  writeln(W:0:1);
  { Ожидаем нажатия Enter }
  readln;
end;

{ Положить доску вперёд на болото }
procedure PutBoard( B : Byte );
begin
  { Первый человек всегда впереди, поэтому именно он кладёт доску вперёд }
  writeln('Ч1 кладёт перед собой Д',B);
  Inc(Right);
  X[Right].B := B;
  X[Right].H := 0; { Доска пустая - никто не стоит }
  X[Right].R := X[Right-1].R + L[B];
  ShowState;
end;

{ Продвинуть людей вперёд если возможно }
procedure Move;
var i:integer;
begin
  { Если на болоте не лежит досок, то двигаться некуда }
  if Right < Left then exit;
  { Если мы достигли правого берега и на правой доске стоит человек,
  { то он сходит на берег }
  if (X[Right].R >= W) and (X[Right].H <> 0) then begin
    writeln('Ч',X[Right].H,' сходит на правый берег');
    HR := HR + [X[Right].H];
    X[Right].H := 0;
    ShowState;
    exit;
  end;
  { Если левая доска пустая и на левом берегу есть люди, то помещаем }
  { первого на левую доску }
  if (HL<>[]) and (X[Left].H = 0) then begin
    X[Left].H := Get(HL);
    writeln('На Д',X[Left].B,' становится Ч',X[Left].H,' с берега');
    ShowState;
    exit;
  end;
  { Если правая доска пустая, то двигаемся вперёд }
  if X[Right].H = 0 then begin
    writeln('Двигаемся вперёд');
    for i:=Right downto Left-1 do
      X[i].H := X[i-1].H;
    if HL<>[] then
      X[Left].H := Get(HL)
    else
      X[Left].H := 0;
    ShowState;
  end;
end;

procedure CarryBoard;
begin
  { Если досок на болоте нет, то можно носить только с левого берега }
  if Right < Left then begin
    if BL<>[] then begin
      writeln('Ч1 берёт первую доску с левого берега и кладёт её вперёд');
      PutBoard(Get(BL));
    end;
    exit;
  end;
  { Доски на болоте есть }
  if X[Right].R < W then begin
    { Если досок на левом берегу нет, и левая пустая, то передаём её вперёд }
    if BL = [] then begin
      if X[Left].H = 0 then begin
        writeln('Передаём освободившуюся Д',X[Left].B,' вперёд');
        PutBoard(X[Left].B);
        Inc(Left);
        exit;
      end;
    end else begin
      writeln('Берём доску с левого берега и по цепочке передаём её вперёд Ч1');
      PutBoard(Get(BL));
      exit;
    end;
  end;
  { Если первая доска пустая, то носить доски не получится }
  if (Right > Left) and (X[Right].H = 0) then exit;
  { Если последняя доска пустая }
  if X[Left].H = 0 then begin
    if (X[Right].R >= W) then begin
      writeln('Складываем Д',X[Left].B,' на берег');
      BR := BR + [X[Left].B];
      Inc(Left);
      ShowState;
    end;
  end;
end;

{ Основная программа }
var
  i : integer;
begin
  writeln;
  writeln('Смоделировать переход группы людей через болото по маршруту');
  writeln('(задаётся расстояние) использующих доски разной длины, в количестве,');
  writeln(' превышающем на единицу число людей в группе.');
  writeln(' Движение осуществляется по следующим правилам:');
  writeln('  * Доски укладываются вплотную друг к другу ');
  writeln('  * На одной доске может находиться только один человек');
  writeln('  * Последняя свободная доска передаётся вперёд,');
  writeln('    после чего группа продвигается вперёд на одну доску');
  writeln('  * Переход заканчивается при сходе последнего человека');
  writeln('    с попавшей первой на сушу доски.');
  writeln(' Вывести информацию о выходе группы и её продвижении с указанием');
  writeln('расположения людей на каждой доске, а также порядке освобождения');
  writeln('досок в конце.');
  
  writeln;
  writeln('Обозначим количество людей переменной N.');
  writeln('При решении люди будут пронумерованы Ч1, Ч2, Ч3, ... ЧN. ');
  repeat
    write('Введите количество людей (N>=1): '); readln(N); 
  until N>=1;
  writeln('Количество досок ',N+1,' (по условию оно больше количества людей на 1).');
  write('Введите ширину болота: '); readln(W); 
  writeln('Теперь введите длины всех досок');
  for i:=1 to N+1 do begin
    write('Длина Д',i,' = '); readln(L[i]); 
  end;
  writeln('Сначала все люди с досками находятся на левом берегу болота.');
  HL := [1..N];    BL := [1..N+1];
  HR := [];        BR := [];
  { Сначала ни одной доски не лежит в болоте }
  Left := 1;
  Right := 0;
  X[0].R := 0;
  X[0].H := 1;
  ShowState;
  Writeln('Строим цепочку от левого берега');
  while X[Right].R < W do begin
    Move;
    CarryBoard;
  end;
  writeln('Добрались до правого берега, двигаем людей вперёд и складываем доски');
  if BL<>[] then
    writeln('Ещё остались доски слева, оставляем их на левом берегу :)');
  while (HR<>[1..N]) or (Left <= Right) do begin
    Move;
    CarryBoard;
  end;
  writeln('Задача решена, условия выполнены');
  ShowState;
end.