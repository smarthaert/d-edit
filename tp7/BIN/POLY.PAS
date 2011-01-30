{ Функция вычисления максимума 2-х целых чисел }
function Max( X,Y : Integer ):Integer;
begin
  if X > Y then Max := X else Max := Y;
end;

type
  PList = ^TList; { Указатель на элемент списка }
  TList = record { Элемент списка - соответствует одному одночлену }
    Value : Real; { Коэффициент при данной степени X }
    Next : PList; { Указатель на следующий элемент списка -
      т.е. коэффициент при следующей степени X }
     { Корневой элемент списка - коэффициент при X в степени 0 }
     {   т.е. константа }
     { Многочлен: 2x^2 + 3x + 7, будет списком:
        Root -> Value=7 -> Value=3 -> Value=2 -> nil }
  end;

{ Какая сейчас степень у полинома P? }
function Stepen( P:PList ):Integer;
var Step : Integer;
begin
  Step := -1; { Если P=nil, то степень = -1. Полином со степенью -1,
        это даже не константа, он просто всегда равен 0 }
  while P<>nil do begin
    Step := Step + 1;
    P := P^.Next;
  end;
  Stepen := Step;
end;

{ Установить коэффициент полинома P при степени XStep равным Value }
procedure SetValue( var P:PList; XStep:Integer; Value:Real );
var Step : Integer;
   Cur,LastElement,NewElement : PList;
begin
  { Нам нужно найти существующий коэффициент с номером Step и }
  { установить его значение или создать новый }
  Step := -1; { Если P=nil, то степень полинома - -1, полином со степенью -1,
        это даже не константа, он просто всегда равен 0 }
  Cur := P;
  LastElement := nil;
  while Cur<>nil do begin
    Step := Step + 1;
    { Сравниваем степень текущего элемента с той степенью, }
    { которую нам надо найти }
    if Step = XStep then begin
      { Мы нашли коэффициент с требуемой степенью, изменяем его значение }
      Cur^.Value := Value;
      exit; { ...и выходим из процедуры  }
    end;
    LastElement := Cur;
    Cur := Cur^.Next;
  end;
  { Если мы оказались здесь, то это значит, что коэффициента при }
  { X в степени Step ещё нет в полиноме }
  { При этом переменная Step хранит текущую степень полинома }
  { Создаём промежуточные элементы и заполняем их нулями }
  while Step < XStep-1 do begin
    Step := Step + 1;
    { Заводим новый нулевой элемент }
    new( NewElement );
    NewElement^.Value := 0;
    NewElement^.Next := nil;
    { Подвешиваем его к последнему }
    if LastElement<>nil then
      LastElement^.Next := NewElement
    else
      P := NewElement;
    LastElement := NewElement;
  end;
  { Заводим в динамической памяти новый элемент }
  new( NewElement );
  NewElement^.Value := Value;
  NewElement^.Next := nil;
  { Подвешиваем новый элемент к последнему }
  if LastElement<>nil then
    LastElement^.Next := NewElement
  else
    P := NewElement;
  LastElement := NewElement;
end;

{ Получить значение коэффициента перед X в степени XStep }
function GetValue( P:PList; XStep:Integer ):Real;
var Step : Integer;
begin
  Step := 0;
  while P<>nil do begin
    if Step = XStep then begin
      GetValue := P^.Value;
      exit;
    end;
    Step := Step + 1;
    P := P^.Next;
  end;
  { Не нашли коэффициента с заданной степенью => ответ 0 }
  GetValue := 0;
end;

{ Ввод многочлена }
function InputPolynom( Name:string) : PList;
var
  Step,Code : integer;
  Root : PList;
  Value : Real;
  s : string;
begin
  writeln;
  writeln(' === Ввод полинома ',Name,' === ');
  { Сначала нет никаких коэффициентов }
  Root := nil;
  Step := 0;
  writeln('Вводите коэффициент при очередной степени x или Enter для окончания ввода');
  repeat
    write('Коэффициент при x^',step,' = '); { Вывод запроса }
    readln(s); { Ввод числа в виде строки }
    { Извлекаем из строки значение элемента - число типа Real }
    val(s,Value,Code);
    if Code<>0 then break;
    SetValue(Root,Step,Value);
    Step := Step + 1;
  until Code <> 0;
  InputPolynom := Root;
end;

{ Перевод полинома в строку }
function PolynomToString( P:PList ):string;
var
  R,CoefStr,StepStr : string;
  Step : integer;
begin
  if P=nil then begin
    PolynomToString := '0';
    exit;
  end;
  Step := 0;
  while P<>nil do begin
    { Если коэффициент не равен 0, то добавляем очередной моном в полином }
    if P^.Value <> 0 then begin
      Str(P^.Value:0:0,CoefStr);
      Str(Step,StepStr);
      if R<>'' then R := ' + ' + R;
      case Step of
        0: R := CoefStr;
        1: R := CoefStr + 'x' + R;
      else
        R := CoefStr + 'x^' + StepStr + R;
      end;
    end;
    Step := Step + 1;
    P := P^.Next;
  end;
  PolynomToString := R;
end;

{ Сумма полиномов }
function AddPolynom( P,Q : PList ):PList;
var R : PList; i : Integer;
begin
  R := nil;
  for i:=0 to Max(Stepen(P),Stepen(Q)) do
    SetValue(R, i, GetValue(P,i) + GetValue(Q,i) );
  AddPolynom := R;
end;

{ Разность полиномов }
function SubPolynom( P,Q : PList ):PList;
var R : PList; i : Integer;
begin
  R := nil;
  for i:=0 to Max(Stepen(P),Stepen(Q)) do
    SetValue(R, i, GetValue(P,i) - GetValue(Q,i) );
  SubPolynom := R;
end;

{ Произведение полиномов }
function MulPolynom( P,Q : PList ):PList;
var R : PList; i,j : Integer;
begin
  R := nil;
  for i:=0 to Stepen(P) do
    for j:=0 to Stepen(Q) do
      SetValue(R, i+j, GetValue(P,i) * GetValue(Q,j) );
  MulPolynom := R;
end;

{ Освобождение динамической памяти }
{ После работы процедуры P=nil }
procedure FreePolynom( var P:PList );
var Temp : PList;
begin
  while P<>nil do begin
    Temp := P;
    P := P^.Next;
    Dispose(Temp);
  end;
end;

{ Вывод меню и организация основного цикла программы }
var
  P,Q,R : PList;
  choice : integer;
begin
  P := InputPolynom('P');
  Q := InputPolynom('Q');
  repeat
    writeln;
    writeln(' === Основное меню программы ===');
    writeln('1. Вычислить сумму полиномов');
    writeln('2. Вычислить разность полиномов');
    writeln('3. Вычислить произведение полиномов');
    writeln('0. Выход из программы');
    writeln;
    repeat
      write('Ваш выбор: '); {$I-} readln(choice); {$I+}
    until IOResult = 0;
    case choice of
      1: begin
           R := AddPolynom(P,Q);
           writeln('(',PolynomToString(P),') + (',PolynomToString(Q),') = ',PolynomToString(R));
           FreePolynom(R);
         end;
      2: begin
           R := SubPolynom(P,Q);
           writeln('(',PolynomToString(P),') - (',PolynomToString(Q),') = ',PolynomToString(R));
           FreePolynom(R);
         end;
      3: begin
           R := MulPolynom(P,Q);
           writeln('(',PolynomToString(P),') * (',PolynomToString(Q),') = ',PolynomToString(R));
           FreePolynom(R);
         end;
    else 
      writeln('Некорректный номер операции! Выберите ещё раз');
    end;
  until choice = 0;
  FreePolynom(Q);
  FreePolynom(P);
end.