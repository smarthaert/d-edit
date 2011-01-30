program Records;

(* 12. (А) Создать файл, содержащий сведения об отправлении поездов
  дальнего следования с Минского вокзала.
  Структура записи:
  - номер поезда,
  - пункт назначения,
  - время отправления,
  - время в пути,
  - наличие билетов;
  количество записей:15.
*)
type
  TTrain = record
    TrainNumber: Integer; { номер поезда }
    Destination: String; { пункт назначения }
    Departure: Integer; { время отправления }
    Travel: Integer; { время в пути }
    Tickets: Integer; { наличие билетов (количество) }
  end;

const
  Cities: array [0..4] of string =
    ('Минск', 'Гомель', 'Брест', 'Витебск', 'Гродно');
  FileName = 'trains.db'; { Файл для хранения базы данных }

{ Число в строку с добавлением лидирующих нулей }
function IntToStr0( Number,Len:integer ):string;
var Result : string;
begin
  Str(Number,Result);
  if Length(Result) < Len then
    Result := '0' + Result;
  IntToStr0 := Result;
end;

{ Время в строку }
function TimeToStr( T:Integer ):string;
var DD,HH,MM : integer; { Дни, часы, минуты }
begin
  MM := T mod 60;
  HH := (T div 60) mod 24;
  DD := T div (24*60);
  if DD > 0 then
    TimeToStr := IntToStr0(DD,1) + ' день ' + IntToStr0(HH,2) + ':' + IntToStr0(MM,2)
  else
    TimeToStr := IntToStr0(HH,2) + ':' + IntToStr0(MM,2)
end;

{ Генерация примера исходных данных }
procedure GenerateSampleData;
var
  i: integer;
  F: file of TTrain; { Типизированный файл }
  Train: TTrain;
begin
  Assign(F, FileName);
  Rewrite(F);
  writeln('Пример расписания:');
  Randomize;  
  for i := 1 to 15 do begin
    with Train do begin
      TrainNumber := Random(100) + 1;
      Destination := Cities[Random(High(Cities))];
      Departure := Random(24*60);
      Travel := 7 + Random(40*60);
      Tickets := Random(5);
      Writeln('№',TrainNumber,' до ',Destination,
        ' отправляется в ',TimeToStr(Departure),
        ' в пути ',TimeToStr(Travel),
        ' билетов ',Tickets);
    end;
    { Записывам запись в файл }
    Write(F, Train);
  end;
  Close(F);
  Writeln;
end;

(*
  (В) написать программу, выдающую следующую информацию:
  - время отправления поездов в город Х во временном интервале от А до В часов,
  - наличие билетов на поезд с номером ХХХ.
  Значения Х, А, В, ХХХ задаются в диалоговом режиме.
*)
procedure Queries;
var
  Choice, i, XXX: integer;
  X: string;
  A, B: Integer;
  F: file of TTrain; { Типизированный файл }
  Train: TTrain;
begin
  repeat
    Writeln;
    Writeln('Выберите тип запроса:');
    Writeln('1. Время отправления поездов в город Х во временном интервале от А до В часов');
    Writeln('2. Наличие билетов на поезд с номером ХХХ');
    Writeln('0. Выход из программы');
    Writeln;
    Write('Ваш выбор: ');
    Readln(Choice);
    case Choice of
      1:
        begin
          Writeln('Время отправления поездов в город Х во временном интервале от А до В часов');
          Write('Города: ');
          for i := low(Cities) to high(Cities) do
            write(i,'. ',Cities[i], ' ');
          Writeln;
          Write('Введите № города назначения: ');
          Readln(i);
          X := Cities[i];
          Write('Начиная со скольки часов: ');
          Readln(A);
          Write('До скольки часов: ');
          Readln(B);
          Writeln('Время отправления поездов в город "', X,
            '" во временном интервале от "', A, '" до "', B, '" часов:');
          Assign(F, FileName);
          Reset(F);
          while not EOF(F) do
          begin
            Read(F, Train);
            with Train do
              if (Destination = X) and
                 (Departure >= (A*60)) and (Departure <= (B*60)) then
                Writeln(TimeToStr(Departure), ' №', TrainNumber, ' "', Destination,'"');
          end;
          Close(F);
        end;
      2:
        begin
          Writeln('Наличие билетов на поезд с номером ХХХ');
          Write('Введите № поезда: ');
          Readln(XXX);
          Assign(F, FileName);
          Reset(F);
          while not EOF(F) do begin
            Read(F, Train);
            with Train do
              if TrainNumber = XXX then
                Writeln('На поезд №', TrainNumber, ' билетов: ', Tickets);
          end;
          Close(F);
        end;
    end;
  until Choice = 0;
end;

begin
  GenerateSampleData;
  Queries;
end.
