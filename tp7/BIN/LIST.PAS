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

procedure ReplaceValue( var Root : PBox; Value,NewValue : integer );
begin

end;

end.