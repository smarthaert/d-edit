{ Модуль, реализующий операции со списком }
{ Список должен быть реализован в виде модуля. }
unit List;

interface { Заголовки функций, которые можно вызвать из основной программы }

{ Задаём структуру данных }
type
  PBox = ^TBox;
  TBox = record
    Value : integer; { Значение элемента списка - целое число }
    Next : PBox; { Ссылка на следующий элемент }
  end;

{ Действия, определяемые заданием оформляются в виде процедур или функций,
  включенных в этот модуль. }

{ Вставить элемент перед последним элементом }
{ Параметры: }
{   Root - корень списка }
{   Value - значение добавляемого элемента }
procedure AddElement( var Root : PBox; Value : integer );

{ Заменить значение первого по порядку элемента с заданным значением }
procedure ReplaceValue( var Root : PBox; Value,NewValue : integer );

{ Удалить последний по порядку элемент с заданным значением }
procedure DeleteValue( var Root : PBox; Value : integer );

{ Найти номер первого элемента с заданным значением }
function FindValue( var Root : PBox; Value : integer ) : integer;

{ Сортировка }
procedure SortList( var Root : PBox );

{ Модуль так же должен содержать средства визуализации списка используемые
 при тестировании и предъявлении результатов выполнения задания. }
procedure Show( Root : PBox );

implementation { Реализация функций по работе со списками }

procedure AddElement( var Root : PBox; Value : integer );
var
  N : PBox; { Указатель на новый элемент }
  I : PBox; { Указатель на текущий элемент при поиске предпоследнего }
begin
  { Создаём новый элемент }
  New( N ); { Заводим элемент в динамической памяти }
  N^.Value := Value;
  { Если список пустой, то элемент N будет единственным }
  if Root = nil then begin
    Root := N;
    N^.Next := nil;
  end else { Если в списке 1 элемент }
    if Root^.Next = nil then begin
      N^.Next := Root;
      Root := N;
    end else begin { Если в списке больше 1 элемента }
      { Ищем предпоследний элемент }
      I := Root;
      { Сейчас I - предпоследний элемент }
      while I^.Next^.Next <> nil do
        I := I^.Next;
      { Последний элемент перевешиваем на N }
      N^.Next := I^.Next;
      { Элемент N перевешиваем на I }
      I^.Next := N;
    end;
end;

{ Заменить значение первого по порядку элемента с заданным значением }
procedure ReplaceValue( var Root : PBox; Value,NewValue : integer );
var P : PBox;
begin
  { Просматриваем в цикле весь список, I постоянно указывает на просматриваемый элемент }
  P := Root; { Сначало указывает на корень списка }
  while P<>nil do begin
    { Если у просматриваемого элемента нужное нам значение }
    if P^.Value = Value then begin
	  P^.Value := NewValue; { Заменяем значение на новое }
	  { И выходим из программы, поскольку нам надо заменить только первое значение }
	  exit; { Выход из процедуры }
	end;
    P := P^.Next;
  end;  
end;

{ Удалить последний по порядку элемент с заданным значением }
procedure DeleteValue( var Root : PBox; Value : integer );
var
  Pre : PBox; { Предыдущий элемент }
  Cur : PBox; { Текущий элемент }
  PreFind : PBox; { Предыдущий от элемента с заданным значением }
  CurFind : PBox; { Элемент с заданным значением }
  NextEl : PBox;
begin
  PreFind := nil;
  CurFind := nil;
  Pre := nil;
  Cur := Root;
  while Cur <> nil do begin
    { Если нашли заданное значение, то }
    if Cur^.Value = Value then begin
	  PreFind := Pre; { запоминаем предыдущий элемент }
      CurFind := Cur; { запоминаем текущий элемент }  
	end;
	Pre := Cur;
    Cur := Cur^.Next;
  end;
  { Если так и не нашли элемент с заданным значением }
  if (PreFind = nil) and (CurFind = nil) then 
	exit;	
  { Указатель на следующий элемент после элемента с заданным значением }
  NextEl := CurFind^.Next;	
  if PreFind = nil then begin
    { Значит надо удалить корневой элемент }
	Dispose(Root);
	Root := NextEl;
  end else begin
    { Надо удалить CurFind }
	Dispose(CurFind);
	PreFind^.Next := NextEl;
  end;
end;

{ Найти номер первого элемента с заданным значением }
function FindValue( var Root : PBox; Value : integer ) : integer;
var P : PBox;
    I : integer;
begin
  FindValue := 0; { Первоначально считаем, что элемент не найден }
  I := 1;
  P := Root; { Сначало указывает на корень списка }
  while P<>nil do begin
    { Если у просматриваемого элемента нужное нам значение }
    if P^.Value = Value then begin
	  FindValue := I; { Номер просматриваемого элемента }
	  { И выходим из программы, поскольку нам надо заменить только первое значение }
	  exit; { Выход из процедуры }
	end;
    P := P^.Next;
	I := I + 1;
  end;    
end;

{ Сортировка }
procedure SortList( var Root : PBox );
var 
  changes : boolean; { Если есть изменения }
  Temp : integer; { Временная переменная для обмена значениями между соседними элементами списка }
  P : PBox;
begin
  { Если в списке меньше двух элементов, то сразу на выход }
  if Root = nil then 
    exit;
  if Root^.Next = nil then 
    exit;
  { Будем пробегать от начала к концу списка и менять местами }
  { элементы стоящие в неправильном порядке пока происходят изменения }  
  repeat
    changes := false;
    P := Root;
    while P^.Next <> nil do begin
	  { Если элементы стоят в неправильном порядке }
	  if P^.Value > P^.Next^.Value then begin
	    { то меняем их местами }
		Temp := P^.Value;
		P^.Value := P^.Next^.Value;
		P^.Next^.Value := Temp;
		{ Есть изменения }
		changes := true;
	  end;
	  P := P^.Next;
	end;	
  until not changes;
  { Раз нет изменений, значит нет элементов стоящих не по порядку, значит список уже отсортирован }
end;

{ Вывод списка на экран }
procedure Show( Root : PBox );
var P : PBox;
    I : integer;
begin
  writeln('Выводим список на экран');
  if Root = nil then
    writeln(' (сейчас список пуст)');
  I := 0;
  P := Root;
  while P <> nil do begin
    I := I + 1;
    writeln(' ',I,') ',P^.Value);
    P := P^.Next;
  end;
  writeln;
end;

end.