(*
  ПРИЛОЖЕНИЕ А. ИСХОДНЫЙ ТЕКСТ ПРОГРАММЫ
  Курсовая работа по программированию
*)

Program Change;

Uses
  Crt;

Const
  MaxNum = 100; {Максимально возможное количество строчек}

{Глобальные переменные}
Var
  Menu : Char; {Выбранный пункт меню}

  WordToFind, {Искомое слово}
  WordToReplace : String; {Слово, на которое нужно заменить искомое при необходимых обстоятельствах}
  NeedCount : LongInt; {Количество раз, которое искомое слово должно встречаться в тексте, чтобы быть замененным на другое}
  S : Array[1..MaxNum] of String; {Массив строк текста}
  Num : LongInt; {Количество строк}

{Проверяет, является ли входной символ буквой}
function IsLetter(Ch : Char) : Boolean;
Begin
  IsLetter := False; {Сначала считаем, что не является}
  if (Ch >= 'A') and (Ch <= 'Z') then IsLetter := True;
  if (Ch >= 'a') and (Ch <= 'z') then IsLetter := True;
  if (Ch >= 'А') and (Ch <= 'Я') then IsLetter := True;

  {Цифры, как говорится - тоже буквы. В том смысле, что они являются
  верными символами при составлении слов, и не являются знаками
  препинания}
  if (Ch >= '0') and (Ch <= '9') then IsLetter := True;

  {Поскольку строчные буквы русского алфавита в таблице ASCII
  делится на 2 части, проверяем каждую часть по отдельности}
  if (Ch >= 'а') and (Ch <= 'п') then IsLetter := True;
  if (Ch >= 'р') and (Ch <= 'я') then IsLetter := True;

  if (ord(Ch) = 240) or (ord(Ch) = 241) then IsLetter := True; {Буква е:}
end;

{Устанавливает цвет текста - Text и цвет фона BackGround}
procedure Color(Text, BackGround : Integer);
Begin
  TextColor(Text);
  TextBackGround(BackGround);
end;

{Возвращает строку из Count символов Ch}
function StrOf(Ch : Char; Count : Byte) : String;
Var
  S : String;
  i : integer;
Begin
  S := '';
  for i := 1 to Count do S := S + Ch;
  StrOf := S;
end;

{Рисует текст S по середина строки Y}
procedure WriteCenter(Y : Integer; S : String);
Begin
  GotoXY(40 - (length(S) div 2), Y);
  Write(S);
end;

{Ждет нажатия клавиши}
function WaitKey : Char;
Var
  Key : Char;
Begin
  While KeyPressed do ReadKey; {Очищаем буфер клавиатуры, если в нем что-нибудь есть}

  {Ждем нажатия клавиши}
  Key := ReadKey;

  {Клавиша нажата. Сохраняем значение и выходим из функции}
  WaitKey := Key;
end;

{Рисует рамку}
procedure DrawBorder(X1, Y1, X2, Y2 : Integer);
Var
  i : integer;
Begin
  GotoXY(X1, Y1); Write('╔', StrOf('═', X2 - X1), '╗');
  for i := Y1 + 1 to Y2 - 1 do Begin
    GotoXY(X1, i); Write('║', StrOf(' ', X2 - X1), '║');
  end;
  GotoXY(X1, Y2); Write('╚', StrOf('═', X2 - X1), '╝');
end;

{Выводит на экран сообщение S и ждет нажатия клавиши}
procedure WriteMessage(S : String);
Begin
  Color(15, 2);
  DrawBorder(35 - (length(S) div 2), 11, 44 + (length(S) div 2), 15);
  WriteCenter(13, S);
  WaitKey;
end;

{Подтверждение. Возвращает да (true) / нет (false)}
function Agreement(S : String) : Boolean;
Var
  Key : Char;
Begin
  Color(15, 2);
  DrawBorder(35 - (length(S) div 2), 17, 44 + (length(S) div 2), 21);
  WriteCenter(19, S);

  {Ждем нажатия клавиши}
  While KeyPressed do ReadKey; {Очищаем буфер клавиатуры}
  Key := ReadKey;

  Agreement := False; {Сначала считаем, что подтвеждения нет}
  if UpCase(Key) = 'Y' then Agreement := True;
end;

{Рисует меню}
procedure DrawMenu;
Begin
  Color(7, 0);
  ClrScr; {Очищаем экран перед выполнением программы}

  {Рамка меню}
  Color(15, 4);
  DrawBorder(10, 8, 70, 18);

  {Рисуем пункты меню}
  Color(14, 4);
  WriteCenter(10, '1. Обнулить данные');
  WriteCenter(11, '2. Добавить строку к тексту');
  WriteCenter(12, '3. Удалить строку из текста');
  WriteCenter(13, '4. Выбрать слова и число вхождений');
  WriteCenter(14, '5. Просмотр текущей статистики');
  WriteCenter(15, '6. ПРЕОБРАЗОВАТЬ ТЕКСТ');
  WriteCenter(16, 'Esc. Выход');

  {Выводим текст об авторе и названии работы}
  Color(10, 0);
  WriteCenter(3, 'Курсовая работа по программированию');
  WriteCenter(4, 'Дмитрия Кирюшова, гр. 1372, ВТ, ФКТИ.');
  WriteCenter(5, '1 курс, осенний семестр 2001 года');

  {Выводим сообщение о просьбе выбрать меню}
  Color(11, 0);
  WriteCenter(21, 'Нажмите клавишу 1 - 6 для продолжения');
end;

{Окно просмотра статистики}
procedure WatchStats;
Var
  i,
  Cur : Integer;
  Key, Key1 : Char;
  Temp : String;
Begin
  {Если параметры не заданы - выводим сообщение об этом и выходим}
  if (WordToFind = '') or (WordToReplace = '') or (NeedCount = 0) then Begin
    WriteMessage('Параметры обработки текста не заданы');
    Exit;
  end;

  {Рисуем первую страницу}
  Color(15, 2);
  GotoXY(1, 8); Write(StrOf('═', 80));
  WriteCenter(8, '╡ Искомое слово ╞');
  GotoXY(1, 9); Write(StrOf(' ', 80));
  GotoXY(1, 10); Write(StrOf(' ', 80));
  GotoXY(1, 9); Write(WordToFind);
  GotoXY(1, 11); Write(StrOf('─', 80));
  WriteCenter(11, '┤ Сколько раз должно встретиться ├');
  GotoXY(1, 12); Write(StrOf(' ', 80));
  GotoXY(1, 13); Write(StrOf(' ', 80));
  GotoXY(1, 12); Write(NeedCount);
  GotoXY(1, 14); Write(StrOf('─', 80));
  WriteCenter(14, '┤ В этом случае оно заменяется на слово ├');
  GotoXY(1, 15); Write(StrOf(' ', 80));
  GotoXY(1, 16); Write(StrOf(' ', 80));
  GotoXY(1, 15); Write(WordToReplace);
  GotoXY(1, 17); Write(StrOf('═', 80));
  WriteCenter(17, '╡ Нажмите любую клавишу для продолжения ... ╞');

  {Ждем нажатия клавиши ...}
  WaitKey;

  {... очищаем экран ...}
  DrawMenu;

  {... и выводим следующее окно}
  if Num = 0 then Begin
    {Строк нет. Выводим сообщение и выходим}
    WriteMessage('Строк не найдено');
    Exit;
  end;

  {Рисуем рамку}
  Color(15, 2);
  GotoXY(1, 10); Write(StrOf('═', 80));
  WriteCenter(10, '╡ Используйте клавиши Вверх, Вниз и Esc чтобы вернуться в главное меню ╞');
  GotoXY(1, 11); Write(StrOf(' ', 80));
  GotoXY(1, 12); Write(StrOf(' ', 80));
  GotoXY(1, 13); Write(StrOf(' ', 80));
  GotoXY(1, 14); Write(StrOf(' ', 80));
  GotoXY(1, 15); Write(StrOf('═', 80));

  Cur := 1;
  Repeat
    GotoXY(1, 11); Write(StrOf(' ', 80));
    GotoXY(1, 12); Write(StrOf(' ', 80));
    GotoXY(1, 13); Write(StrOf(' ', 80));
    GotoXY(1, 14); Write(StrOf(' ', 80));
    GotoXY(1, 15); Write(StrOf('═', 80));
    GotoXY(1, 11); Write(S[Cur]);
    Str(Cur, Temp); WriteCenter(15, '╡ Строка ' + Temp + ' ╞');

    {Читаем нажатие клавиши}
    While KeyPressed do ReadKey; {Очищаем буфер клавиатуры}
    Key := ReadKey;
    if Key = #0 then Key1 := ReadKey;

    {Анализируем нажатие клавиши}
    if Key = #0 then Begin
      if Key1 = #72 then Begin Dec(Cur); if Cur < 1 then Cur := 1; end;
      if Key1 = #80 then Begin Inc(Cur); if Cur > Num then Cur := Num; end;
    end;

  Until Key = #27;

end;

{Меню добавления строки}
procedure AddStringMenu;
Begin
  {Рисуем рамку}
  Color(15, 2);
  GotoXY(1, 10); Write(StrOf('═', 80));
  WriteCenter(10, '╡ Введите новую строку ╞');
  GotoXY(1, 11); Write(StrOf(' ', 80));
  GotoXY(1, 12); Write(StrOf(' ', 80));
  GotoXY(1, 13); Write(StrOf(' ', 80));
  GotoXY(1, 14); Write(StrOf(' ', 80));
  GotoXY(1, 15); Write(StrOf('═', 80));

  {Добавляем новую строку}
  Inc(Num);
  if Num > MaxNum then Begin
    WriteMessage('Достигнуто максимальное количество строчек');
  end else Begin
    GotoXY(1, 11); ReadLn(S[Num]);
  end;
end;

{Меню удаления строки}
procedure DelStringMenu;
Var
  i,
  Cur : Integer;
  Key, Key1 : Char;
  Temp : String;
Begin
  if Num = 0 then Begin
    {Строк нет. Выводим сообщение и выходим}
    WriteMessage('Строк не найдено');
    Exit;
  end;

  {Рисуем рамку}
  Color(15, 2);
  GotoXY(1, 10); Write(StrOf('═', 80));
  WriteCenter(10, '╡ Используйте клавиши Вверх, Вниз и Enter чтобы удалить строку ╞');
  GotoXY(1, 11); Write(StrOf(' ', 80));
  GotoXY(1, 12); Write(StrOf(' ', 80));
  GotoXY(1, 13); Write(StrOf(' ', 80));
  GotoXY(1, 14); Write(StrOf(' ', 80));
  GotoXY(1, 15); Write(StrOf('═', 80));

  Cur := 1;
  Repeat
    GotoXY(1, 11); Write(StrOf(' ', 80));
    GotoXY(1, 12); Write(StrOf(' ', 80));
    GotoXY(1, 13); Write(StrOf(' ', 80));
    GotoXY(1, 14); Write(StrOf(' ', 80));
    GotoXY(1, 15); Write(StrOf('═', 80));
    GotoXY(1, 11); Write(S[Cur]);
    Str(Cur, Temp); WriteCenter(15, '╡ Строка ' + Temp + ' ╞');

    {Читаем нажатие клавиши}
    While KeyPressed do ReadKey; {Очищаем буфер клавиатуры}
    Key := ReadKey;
    if Key = #0 then Key1 := ReadKey;

    {Анализируем нажатие клавиши}
    if Key = #0 then Begin
      if Key1 = #72 then Begin Dec(Cur); if Cur < 1 then Cur := 1; end;
      if Key1 = #80 then Begin Inc(Cur); if Cur > Num then Cur := Num; end;
    end;

  Until (Key = #13) or (Key = #27);

  if Key = #13 then Begin
    if not Agreement('Вы действительно хотите удалить строку ? ( Y / N )') then Key := #255;
  end;

  if Key = #13 then Begin
    {Удаляем строку и сдвигаем оставшиеся}
    Dec(Num);
    for i := Cur to Num do Begin
      S[i] := S[i + 1];
    end;
  end;
end;

{Процедура выбора слова и необходимого количества вхождений}
procedure ReadWords;
Var
  TempS : String; {Строка, временно хранящая число раз,
                   которое должно встретиться искомое слово}
  i, {Переменная цикла}
  ErrorCode : Integer; {Код ошибки при операции Val}
  Right : Boolean; {Верно ли введено слово}
Begin
  {Рисуем рамку}
  Color(15, 2);
  GotoXY(1, 8); Write(StrOf('═', 80));
  WriteCenter(8, '╡ Введите искомое слово ╞');
  GotoXY(1, 9); Write(StrOf(' ', 80));
  GotoXY(1, 10); Write(StrOf(' ', 80));
  GotoXY(1, 11); Write(StrOf('─', 80));
  WriteCenter(11, '┤ Введите, какое количество раз оно должно встретиться ├');
  GotoXY(1, 12); Write(StrOf(' ', 80));
  GotoXY(1, 13); Write(StrOf(' ', 80));
  GotoXY(1, 14); Write(StrOf('─', 80));
  WriteCenter(14, '┤ Введите на какое слово его нужно заменить ├');
  GotoXY(1, 15); Write(StrOf(' ', 80));
  GotoXY(1, 16); Write(StrOf(' ', 80));
  GotoXY(1, 17); Write(StrOf('═', 80));

  {Вводим сначала искомое слово}
  Right := True;
  Repeat
    if not Right then Write(#7);
    GotoXY(1, 9); Write(StrOf(' ', 80));
    GotoXY(1, 10); Write(StrOf(' ', 80));
    GotoXY(1, 9); ReadLn(WordToFind);

    {Проверяем, не содержит ли слово небуквенные символы (например,
    знаки препинания, пробелы и т. д. Слово не должно их содержать}
    Right := True;
    for i := 1 to length(WordToFind) do
      if not IsLetter(WordToFind[i]) then
        Right := False;

    {Если слово пустое - тоже ошибка}
    if length(WordToFind) = 0 then Right := False;
  Until Right; {Вводим до тех пор, пока оно не будет верное}

  {Теперь вводим число раз. Вводим, пока не будет нормального числа}
  Repeat
    GotoXY(1, 12); Write(StrOf(' ', 80));
    GotoXY(1, 13); Write(StrOf(' ', 80));
    GotoXY(1, 12); ReadLn(TempS);
    Val(TempS, NeedCount, ErrorCode);

    {Если NeedCount <= 0 -> ошибка}
    if NeedCount <= 0 then ErrorCode := 1;
  Until ErrorCode = 0;

  {Наконец вводим слово, на которое меняем искомое}
  Right := True;
  Repeat
    if not Right then Write(#7);
    GotoXY(1, 15); Write(StrOf(' ', 80));
    GotoXY(1, 16); Write(StrOf(' ', 80));
    GotoXY(1, 15); ReadLn(WordToReplace);

    {Проверяем, не содержит ли слово небуквенные символы (например,
    знаки препинания, пробелы и т. д. Слово не должно их содержать}
    Right := True;
    for i := 1 to length(WordToReplace) do
      if not IsLetter(WordToReplace[i]) then
        Right := False;

    {Если слово пустое - тоже ошибка}
    if length(WordToReplace) = 0 then Right := False;
  Until Right; {Вводим до тех пор, пока оно не будет верное}

end;

{АЛГОРИТМ РЕШЕНИЯ ЗАДАЧИ}
procedure Solve;
Var
  Count, {Сколько раз искомое слово встретилось в строчке}
  Cur, {Номер текущего символа в слове}
  RightRange, {Правая граница слова}
  i, j : longint; {Переменные цикла}
  Temp, {Временная переменная}
  ThisWord : String; {Текущее слово}
  Ok : Boolean; {Переменная для проверки совпадения слова}
Begin
  {Если параметры не заданы - выводим сообщение об этом и выходим}
  if (WordToFind = '') or (WordToReplace = '') or (NeedCount = 0) then Begin
    WriteMessage('Параметры обработки текста не заданы');
    Exit;
  end;

  {Анализируем исходный текст построчно}
  for i := 1 to Num do Begin
    Count := 0; {Сначала инициализируем количество вхождений в ноль}
    Cur := 0; {Начинаем с начала строки}
    ThisWord := ''; {Текущее слово пока пустое}
    While length(S[i]) > Cur do Begin
      Inc(Cur);
      if IsLetter(S[i, Cur]) then Begin {Буква}
        ThisWord := ThisWord + S[i, Cur];
      end else Begin {Не буква}

        if ThisWord <> '' then Begin {Если слово не пустое - работаем с ним}
          {Сравниваем с искомым. Если оно - увеличиваем счетчик}
          if WordToFind = ThisWord then Inc(Count);
        end;

        {Обнуляем текущее слово}
        ThisWord := '';
      end;
    end;

    {Проверяем последнее слово. Подразумевается, что равенство выполняется,
    только если слово ThisWord не пустое}
    if WordToFind = ThisWord then Inc(Count);

    {Строчка пройдена. Если количество вхождений искомого слова совпадает
    с необходимым, то заменяем его}
    if Count = NeedCount then Begin
      {Проверяем, ни становится ли строчка слишком длинной}
      if length(S[i]) + (Count * (length(WordToReplace) - length(WordToFind))) > 255 then Begin
        Str(i, Temp);
        WriteMessage('Невозможно преобразовать строку номер ' + Temp + '.');
      end else Begin

        {Используем здесь другой алгоритм поиска слова}
        j := 1;
        While j <= length(S[i]) - length(WordToFind) + 1 do Begin {Проходим по всему предложению}
          if (Copy(S[i], j, length(WordToFind)) = WordToFind) then Begin {Данный фрагмент равен слову. Проверяем границы слова}
            {Проверяем левую границу}
            Ok := False; {Сначала считаем, что не все в порядке}
            if j = 1 then Ok := True;
            if not Ok then Begin
              if not IsLetter(S[i, j - 1]) then Ok := True;
            end;
            if Ok then Begin {Проверяем правую границу}
              Ok := False; {Сначала считаем, что не все в порядке}
              RightRange := j + length(WordToFind); {Вычисляем правую границу слова}
              if RightRange > length(S[i]) then Ok := True;
              if not Ok then Begin
                if not IsLetter(S[i, RightRange]) then Ok := True;
              end;
              if Ok then Begin {Все отлично. Слова совпали -> заменяем}
                S[i] := Copy(S[i], 1, j - 1) + WordToReplace + Copy(S[i], j + length(WordToFind), length(S[i]));
                Inc(j, length(WordToReplace));
              end;
            end;
          end;
          Inc(j);
        end;
      end;
    end;
  end;

  WriteMessage('Преобразование выполнено');
end;

{Проверяет нажатую клавишу}
procedure CheckMenu(var Key : Char);
Begin

  {Выполняем соответствующую процедуру в зависимости}
  Case Key of
    '1' : Begin {Обнуляем значения}
      Num := 0;
      NeedCount := 0;
      WordToFind := '';
      WordToReplace := '';
      WriteMessage('Обнуление выполнено');
    end;
    '2' : Begin
      AddStringMenu; {Вызов меню добавления строки}
    end;
    '3' : Begin
      DelStringMenu; {Вызов меню удаления строки}
    end;
    '4' : Begin
      ReadWords; {Вызов меню выбора слов и количества вхождения его}
    end;
    '5' : Begin
      WatchStats; {Вызов окна просмотра статистики}
    end;
    '6' : Begin
      Solve; {Запуск процедуры решения задачи}
    end;
    #27 : Begin
      {Выводим сообщение, просящее подтвердить выход из программы}
      if not Agreement('Вы действительно хотите выйти из программы ? ( Y / N )') then Key := #255;
      {Если подтверждение не получено - меняем код}
    end
    else Begin
      {Нажата неверная клавиша. Выдаем звуковой сигнал и продолжаем работу}
      Write(#7);
    end;
  end;

end;

Begin
  {Начальная инициализация}
  Num := 0; NeedCount := 0; WordToFind := ''; WordToReplace := '';

  {Основной цикл программы. Работает, пока не нажата клавиша '6' (выход)}
  Repeat
    {Рисуем меню}
    DrawMenu;

    {Ждем нажатия клавиши}
    Menu := WaitKey;

    {Обрабатываем нажатие}
    CheckMenu(Menu);
  Until Menu = #27;

  {Нажат выход. Выходим из программы}
End.