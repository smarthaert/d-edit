{ Поиспользуем Turbo Professional на полную катушку ;) }
Uses TPCRT,TPString,TPEdit,TPWindow;

{ ---=== Размеры таблицы ===--- }
 Const MaxI = 10; MaxJ = 76;

{ ---=== Две матрицы (Основная и временная) ===--- }
 Var Map : Array [1..MaxI,1..MaxJ] of Boolean; { Они еще живы ?! }
     TempMap : Array [1..MaxI,1..MaxJ] of Boolean;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                           О программе                            │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }

 Procedure About;
   Begin
     Writeln('>>> Если ничто другое не помогает прочтите, наконец, инструкцию ! <<<');
     Writeln('ESC - Выход из программы [Escape]');
     Writeln('Стрелочки - Перемещение по матрице');
     Writeln('Enter - Редактирование коэффициента (Завершение ввода - Enter)');
     Writeln('N - Уничтожение существующей и создание новой матрицы');
     Writeln('S - Сохранение матрицы в текстовой файл [Save]');
     Writeln('L - Загрузка матрицы из текстового файла [Load]');
     Writeln('R - Шаг жизни [Run Life]');
     Writeln('C - Много шагов жизни ! (До нажатия клавиши)');
     Writeln('[!] This program was protected by Russian and International Laws [!]');
   End;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                        Работа с матрицей                         │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }

 Procedure NewTable;
   Var I,J:Word;
   Begin
     For I:=1 to MaxI do
       For J:=1 to MaxJ do
         Begin
           Map     [I,J] := False;
           TempMap [I,J] := Not Map[I,J];
         End;
   End;

 Procedure SaveTable;
   Var Window:WindowPtr; Escaped:Boolean;
       FileName:String; T:Text; I,J:Byte;
   Begin
     MakeWindow(Window,10,10,70,12,True,True,True,$07,$07,$07,
       ' Сохранение матрицы в текстовой файл ');
     DisplayWindow(Window);
     FileName := 'LIFE.TXT';
     ReadString('Введите имя файла: ',
       11,12,20,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then
       Begin
         Assign(T,FileName);
        {$I-}
         Rewrite(T);
         If IOResult<>0 then
           Begin
             Write('[!!!]: Не могу создать файл ! Нажмите любую клавишу ...'); ReadKey;
             KillWindow(Window); Close(T); Exit;
           End;
         For I:=1 to MaxI do
           Begin
             For J:=1 to MaxJ do
               Write(T,Ord(Map[I,J]));
             Writeln(T);
           End;
         Close(T);
        {$I+}
         Write('>>> Сохранено ! <<< Нажмите любую клавишу ...'); ReadKey;
       End;
     KillWindow(Window);
   End;
 Procedure LoadTable;
   Var Window:WindowPtr; Escaped:Boolean;
       FileName,S:String; T:Text; I,J:Byte;
   Begin
     MakeWindow(Window,10,10,70,12,True,True,True,$07,$07,$07,
       ' Загрузка матрицы из текстового файла ');
     DisplayWindow(Window);
     FileName := 'LIFE.TXT';
     ReadString('Введите имя файла: ',
       11,12,20,$0F,$0F,$0F,Escaped,FileName);
     If Not Escaped then
       Begin
         Assign(T,FileName);
        {$I-}
         Reset(T);
         If IOResult<>0 then
           Begin
             Write('[!!!]: Не могу открыть файл ! Нажмите любую клавишу ...'); ReadKey;
             KillWindow(Window); Close(T); Exit;
           End;
         For I:=1 to MaxI do
           Begin
             If IOResult<>0 then
               Begin
                 Write('[!!!]: Не могу прочитать файл ! Нажмите любую клавишу ...'); ReadKey;
                 KillWindow(Window); Close(T); Exit;
               End;
             Readln(T,S);
             For J:=1 to MaxJ do
               Begin
                 Case S[J] of
                   '0': Map[I,J]:=False;
                   '1': Map[I,J]:=True;
                 End;
                 TempMap[I,J] := Not Map[I,J];
               End;
           End;
         Close(T);
        {$I+}
         Write('>>> Загружено ! <<< Нажмите любую клавишу ...'); ReadKey;
       End;
     KillWindow(Window);
   End;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                          Алгоритм Жизни                          │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }

{ Если кажется,что работу сделать легко, это непременно будет трудно. }
{ А если на вид она трудна, значит выполнить её абсолютно невозможно. }

Procedure CopyMap;
  Var I,J:Word;
  Begin
    For I:=1 to MaxI do
      For J:=1 to MaxJ do
        TempMap[I,J] := Map[I,J];
  End;

Function Get( I,J:Integer ):Byte;
  Var A,B:Word;
  Begin
    A:=I; B:=J;
   { Склеиваем края в виде шара }
    If A > MaxI then A := 1;
    If A < 1    then A := MaxI;
    If B > MaxJ then B := 1;
    If B < 1    then B := MaxJ;
   { Возрашаем значение }
    Get := Ord(TempMap[A,B]);
  End;

Procedure Life;
  Var Friends,I,J:Byte;
 Begin
   { - Цикл по всем клеткам - }
    For I:=1 to MaxI do
      For J:=1 to MaxJ do
        Begin
         { Додсчет количества соседей }
          Friends:=Get(I-1,J-1)+Get(I,J-1)+Get(I+1,J-1)+Get(I+1,J)+
                   Get(I+1,J+1)+Get(I,J+1)+Get(I-1,J+1)+Get(I-1,J);
         { - Правила жизни ! - }
         { Гибель "от одиночества" :( }
          If Friends < 2 then Map[I,J]:=False;
         { Гибель "от тесноты" :( }
          If Friends > 3 then Map[I,J]:=False;
         { Рождение новой клетки ! :) }
          If Friends = 3 then Map[I,J]:=True;
        End;
End;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                      Вывод матрицы на экран                      │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }

 Var CurI, CurJ : Byte;

 Procedure Sym( I,J:Integer );
   Begin
     GotoXY(J,I);
     Case Map[I,J] of
       False: Write(' ');
       True:  Write('#');
     End;
   End;

 Procedure ShowTable;
   Var I,J:Integer;
   Begin
     For I:=1 to MaxI do
       For J:=1 to MaxJ do
         Begin
           If ((I=CurI) And (J=CurJ)) then
             TextAttr:=$70 Else TextAttr:=$07;
           Sym(I,J);
         End;
     TextAttr := $07;
     CopyMap;
   End;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                           Ввод таблицы                           │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }

 Procedure CursorMove;
   Begin
     Case ReadKey of
       #72: Dec(CurI);
       #75: Dec(CurJ);
       #77: Inc(CurJ);
       #80: Inc(CurI);
     End;
     If CurJ > MaxJ then CurJ:=1;
     If CurJ < 1    then CurJ:=MaxJ;
     If CurI > MaxI then CurI:=1;
     If CurI < 1    then CurI:=MaxI;
   End;

{ ---=== Редактирование матрицы ===--- }
 Procedure EditTable;
   Var Window:WindowPtr; Escaped:Boolean; Key:Char;
   Begin
     MakeWindow(Window,2,12,79,24,True,True,True,$07,$07,$07,
       ' Поле жизни ');
     DisplayWindow(Window);
     NewTable;
     CurI:=1; CurJ:=1; { Сначала мы находимся в левом верхнем углу }
     Repeat
       ShowTable;
       Key := UpCase(ReadKey);
      { - Выполняем необходимые действия - }
       Case Key of
         #00: CursorMove;
         #13: Map[CurI,CurJ]:=Not Map[CurI,CurJ];
         'N': NewTable;
         'S': SaveTable;
         'L': LoadTable;
         'R': Life;
         'C':
           Begin
             Repeat
               Life;
               ShowTable;
             Until KeyPressed;
             ReadKey;
           End;
       End;
      { Пока мы не выйдем по клавише ESC :о) }
     Until Key = #27;
     KillWindow(Window);
   End;

{ ╔╤══════════════════════════════════════════════════════════════════╤╗ }
{ ║│                        Основная программа                        │║ }
{ ╚╧══════════════════════════════════════════════════════════════════╧╝ }
Var Window:WindowPtr;
Begin
 { - Создаем окошко программы - }
  MakeWindow(Window,1,1,80,25,True,True,True,$07,$07,$07,
    ' Игра "Жизнь" ');
  DisplayWindow(Window);
 { - Работаем в окне программы - }
  About; { Помощь и рассказ о программе }
  EditTable; { А теперь редактируем таблицу }
 { - Закрываем окошко программы - }
  KillWindow(Window);
End.