{ Программа: "Обработка текстов" }
const
  MaxRows = 100; { Максимальное количество строк }
  MaxSL = 100; { Максимальное количество слогов }

var
  sep : string; { Строка с символами-разделителями }
  ends : string; { Строка с 2-мя завершающими символами }
  endPos : integer; { Позиция 2-х завершающих символов в тексте }
  txt : string; { Текст }
  str : array [1..MaxRows] of string; { Строки текста }
  row : integer; { Текущая строка }
  i, j, t : integer; { Переменные цикла }
  slogi : array [1..MaxSL] of string; { Слоги для поиска }
  SN : integer; { Количество слогов для поиска }
  newstr : string; { Новая строка после заключения слогов в кавычки }
  slog : boolean; { Начинается ли с этого символа один из слогов }
begin
  writeln(' Программа: "Обработка текстов" ');
  writeln('================================');
  write(' Введите строку с символами-разделителями строк: '); readln(sep);
  repeat
    write(' Введите 2 символа, обозначающие конец текста: '); readln(ends);
    ok := true;
    { Проверка соблюдения условия }
    if length(ends)<>2 then begin
      writeln(' Введите 2 символа, а не ',length(ends),'!');
      ok := false;
    end;
  until ok;
  write('Введите исходный текст: '); readln(txt);
  { Обрезаем хвост у текста }
  endPos := pos(ends,txt); { Ищем первую позицию ends в txt }
  if endPos <> 0 then
    Delete(txt,endPos,length(txt)-endPos+1);
  writeln('Текст до конца: "',txt,'"');
  { Вводим слоги для поиска }
  write('Введите количество слогов для поиска: '); readln(SN);
  for i:=1 to SN do begin
    write('Введите слог ',i,' из ',SN,': '); readln(slogi[i]);
  end;
  row:=1; { Текущая строка - первая }
  str[row] := '';
  { Пробегаем весь текст посимвольно }
  for i:=1 to length(txt) do
    if pos(txt[i],sep) <> 0 then begin { Если символ - разделитель }
      row := row + 1; { Начинаем новую строку }
      str[row] := ''; { Новая строка пустая }
    end else begin
      str[row] := str[row] + txt[i];
      if pos(txt[i],search) <> 0 then begin { Если этот символ ищем }
        writeln('Найден символ "',txt[i],'" строка ',row,
          ' позиция ',length(str[row]));
      end;
    end;
  writeln;
  writeln('Формируем новый текст, состоящий из строк заданного текста,');
  writeln('в котором заданные слоги заключены в кавычки.');
  for i:=1 to row do begin
    j := 1; { Текущий символ в текущей строке }
    newstr := '';
    while j <= length(str[i]) do begin
      slog := false;
      for t:=1 to SN do
        if Copy(str[i],j,Length(slogi[t])) =
           slogi[t] then begin { Если здесь начинается этот слог }
          { Добавляем его в кавычках и смещаемся на его длину }
          newstr := newstr + '"'+ slogi[t] + '"';
          j := j + Length(slogi[t]);
          slog := true;
          break;
        end;
      if not slog then begin
        newstr := newstr + str[i,j];
        j := j + 1; { Перемещаемся на следующий символ }
      end;
    end;
    writeln(newstr); { Выводим готовую строку на экран }
  end;

  writeln;
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
