program qq;

const { Названия полей данных }
  id_nomer = 'Номер поезда';
  id_punkt = 'Пункт назначения';
  id_time_in = 'Bремя отправления';
  id_time_out = 'Bремя в пути';
  id_bilet = 'Hаличие билетов';

var zapis: integer;
  nomer, bilet: integer;
  punkt: string;
  time_in, time_out: real;
  f: text;

function ReadRecord : boolean;
var Code, p : integer;
  S, value, id : string;
begin
  readln(f,S);
  ReadRecord := S = '#';
  if S='#' then exit;
  { Отделяем то что до знака ":" - название поля данных }
  p := pos(':',S);
  id := copy(S,1,p-1);
  { А то что после ":" - значение }
  value := copy(S,p+1,length(S)-p);
  { Убираем начальные и концевые пробелы }
  if value <> '' then begin
    while value[1]=' ' do { Пока в начале строки стоит пробел }
      Delete(value,1,1); { удаляем начиная с первого символа 1 символ }
    while value[Length(value)] = ' ' do { Пока в конце строки строит пробел }
      Delete(value,Length(value),1); { удаляем его }
  end;
  if id = id_nomer then Val(value,nomer,Code);
  if id = id_punkt then punkt := value;
  if id = id_time_in then val(value,time_in,Code);
  if id = id_time_out then val(value,time_out,Code);
  if id = id_bilet then val(value,bilet,Code);
end;

var X : string;
  A,B : real;
  XXX : integer;
begin
  { Создаём раписание в текстовом файле }
  { Открываем его на запись }
  assign(f, 'poizd.txt'); { f - файловая переменная }
  rewrite(f); { перезаписываем этот текстовый файл }
    { если файла нет, то он будет создан, а иначе перезаписан заново }
  writeln('Начало ввода записей');
  writeln;
  writeln;
  zapis := 1;
  while zapis <= 15 do begin
    writeln('Запись ', zapis);
    write('Введите номер поезда: '); readln(nomer);
    writeln(f, id_nomer,': ', nomer);
    write('Введите пункт назначения: '); readln(punkt);
    writeln(f, id_punkt,': ', punkt);
    write('Введите время отправления: '); readln(time_in);
    writeln(f, id_time_in,': ', time_in);
    write('Введите время в пути: '); readln(time_out);
    writeln(f, id_time_out,': ', time_out);
    write('Введите наличие билетов: '); readln(bilet);
    writeln(f, id_bilet,': ', bilet);
    writeln(f,'#');
    writeln;
    zapis := zapis + 1;
  end;
  writeln('Конец записей!');
  close(f);
  writeln;
  { Вторая часть задачи - собственно поиск :) }
  writeln('=== Поиск записей ===');
  writeln;
  writeln('1. Время отправления поездов в город Х во временном');
  writeln('интервале от А до В часов');
  writeln;
  write('Введите требуемый пункт назначения: '); readln(X);
  write('Введите начало интервала: '); readln(A);
  write('Введите конец интервала: '); readln(B);
  reset(f); { Открываем файл снова на считывание }
  while not EOF(f) do begin { Пока файл f не закончился, считываем }
    if ReadRecord then
      if (punkt = X) and (time_in >= A) and (time_in <= B) then
        writeln(nomer,' ',punkt,' ',time_in);
  end;
  close(f); { Закрываем файл }
  writeln;
  writeln('2. Наличие билетов на поезд с номером ХХХ.');
  write('Введите требуемый номер поезда: '); readln(XXX);
  reset(f); { Открываем файл снова на считывание }
  while not EOF(f) do begin { Пока файл f не закончился, считываем }
    if ReadRecord then
      if nomer = XXX then
        writeln(nomer,' ',punkt,' ',time_in);
  end;
  close(f); { Закрываем файл }
  write('Enter'); readln;
end.