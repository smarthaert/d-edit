{ Программа: "Обработка текстов" }

{ Сколько раз встречается в строке заданных символ }
function Count( S:string; C:Char ):integer;
var
  Res : integer; { Результат }
  i : integer; { Переменная цикла }
begin
  Res := 0;
  for i:=1 to length(S) do
    if S[i] = C then
      Res := Res + 1;
  Count := Res;
end;

var
  sep : string; { Строка с символами-разделителями }
  ends : string; { Строка с 2-мя завершающими символами }
  endPos : integer; { Позиция 2-х завершающих символов в тексте }
  txt : string; { Текст }
  search : string; { Символы для поиска }
  ok : boolean;
  str : array [1..100] of string; { Строки текста }
  row : integer; { Текущая строка }
  i, j : integer; { Переменные цикла }
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
  { Вводим символы для поиска и ищем их позиции }
  write('Введите символы для поиска: '); readln(search);
  row:=1; { Текущая строка  }
  str[row] := '';
  { Пробегаем весь текст посимвольно }
  for i:=1 to length(txt) do
    if pos(txt[i],sep) <> 0 then begin { Если символ - разделитель }
      row := row + 1; { Начинаем новую строку }
      str[row] := ''; { Новая строка пустая }
    end else begin
      str[row] := str[row] + txt[i];
      if pos(txt[i],search) <> 0 then begin { Если мы этот символ ищем }
        writeln('Найден символ "',txt[i],'" строка ',row,
          ' позиция ',length(str[row]));
      end;
    end;
  writeln;
  writeln('Формируем новый текст, состоящий из строк заданного текста,');
  writeln('в каждой из которых любой из заданных символов встречается');
  writeln('не более одного раза.');
  for i:=1 to row do begin
    ok := true;
    { Проверяем все заданные символы }
    for j:=1 to length(search) do
      if Count(str[i],search[j]) > 1 then begin
        ok := false;
        break;
      end;
    { Если строка удовлетворяет условиям => выводим её на экран }
    if ok then
      writeln(str[i]);
  end;

  writeln;
  writeln('Нажмите Enter для завершения программы');
  readln;
end.
