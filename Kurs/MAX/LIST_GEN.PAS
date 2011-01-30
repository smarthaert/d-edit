{ ---=== Список строк ===--- }
 Type
   PStrList = ^TStrList;
   TStrList = Record
     Item1,Item2 : String;
     Next : PStrList;
   End;

{ ---=== Добавление нового элемента в начало списка ===--- }
 Procedure StrListAddBeg( Var Root:PStrList; Item1,Item2:String );
   Var Current:PStrList;
   Begin
     New(Current);
     Current^.Item1 := Item1;
     Current^.Item2 := Item2;
     Current^.Next := Root;
     Root:=Current;
   End;

{ ---=== Добавление нового элемента в конец списка ===--- }
 Procedure StrListAddEnd( Var Root:PStrList; Item1,Item2:String );
   Var Current,Buffer:PStrList;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Item1 := Item1;
     Buffer^.Item2 := Item2;
     Buffer^.Next := nil;
    { - Присоединение элемента к существующему списку - }
     If Root <> nil then
       Begin
         Current := Root;
         While Current^.Next <> nil do Current := Current^.Next;
         Current^.Next := Buffer;
       End
     Else
       Root := Buffer;
   End;

{ ---=== Добавление нового элемента после элемента с номером N ===--- }
 Procedure StrListAdd( Var Root:PStrList; N:Integer; Item1,Item2:String );
   Var Current,Buffer : PStrList; Counter:Integer;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Item1 := Item1;
     Buffer^.Item2 := Item2;
    { - Присоединение элемента к существующему списку - }
     Current := Root;
     Counter := 0;
     If N <> 0 then
       While Current <> nil do
         Begin
           Inc(Counter);
           If Counter = N then
             Begin
               Buffer^.Next := Current^.Next;
               Current^.Next := Buffer;
               Break; { Больше нам делать нечего ;) }
             End;
           Current := Current^.Next;
         End
     Else
       Begin
         Buffer^.Next := Root;
         Root := Buffer;
       End;
   End;

{ ---=== Просмотр всего списка (поэлементно) ===--- }
 Procedure StrListShow( Var Root:PStrList );
   Var Current : PStrList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по элемента обработке списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление элемента с номером N ===--- }
 Procedure StrListDel( Var Root:PStrList; N:Integer );
   Var Current,Buffer:PStrList; Counter:Integer;
   Begin
     Current := Root;
     Buffer := nil;
     Counter := 0;
    { - Ищем нужный нам элемент - }
     While Current <> nil do
       Begin
         Inc(Counter);
        { - И удаляем его ... - }
         If Counter = N then
           Begin
             If Buffer = nil then
               Root:=Current^.Next
             Else
               Buffer^.Next:=Current^.Next;
             Dispose(Current);
             Break; { Больше нам делать нечего ;) }
           End;
         Buffer := Current;
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление всего списка ===--- }
 Procedure StrListDelAll( Var Root:PStrList );
   Var Buffer : PStrList;
   Begin
    { Пока в списке остались элементы }
     While Root <> nil do
       Begin
        { Удаляем первый элемент }
         Buffer := Root;
         Root := Root^.Next;
         Dispose(Buffer);
       End;
   End;


 Var StrList : PStrList;

{ ---=== Работа с выходным файлом ===--- }
Var T:Text; Cur:Integer;

Procedure Out( S:String );
  Var I:Integer;
  Begin
    For I:=1 to Cur do Write(T,' ');
    Writeln(T,S);
  End;

Procedure OutPr;
  Var I:Integer;
  Begin
    For I:=1 to Cur do Write(T,' ');
  End;

Procedure OutWr( S:String );
  Begin
    Write(T,S);
  End;

Procedure OutEnd;
  Begin
    Writeln(T);
  End;

Procedure Comment( S:String );
  Begin
    Out('{ ---=== '+S+' ---===}');
  End;

{ ---=== Основная программа ===--- }
Var FileName,Name,ItemName,ItemType:String; CL:PStrList;

Procedure Parameters;
  Begin
    CL:=StrList; While CL<>nil do Begin OutWr('; '+CL^.Item1+':'+CL^.Item2);
    CL:=CL^.Next; End;
    OutWr(' );'); OutEnd; Inc(Cur,2);
  End;

Procedure Zapolnenie(S:String);
  Begin
    Inc(Cur,2);
    Out('New('+S+');');
    CL:=StrList; While CL<>nil do Begin
    Out(S+'^.'+CL^.Item1+' := '+CL^.Item1+';');
    CL:=CL^.Next; End;
  End;

Begin
  Writeln('>>> Генератор программ для работы со списками <<<');
  Writeln('- Поэтапное написание программы для работы со списком -');
  Writeln('- Пожалуйста, не ошибайтесь ! Отката пока нет ;) -');
  Writeln('                             < 9331 - Super Group >');
 { - Ввод имени файла - }
  Writeln(' - Ввод имени файла для размещения результирующего кода - ');
  Write('Введите имя для создаваемого файла: '); Readln(FileName);
 { - Ввод имени типа - }
  Writeln(' - Ввод имени типа (Hапример: Menu -> Будут созданы: TMenu и PMenu) - ');
  Write('Введите имя для создаваемого типа: '); Readln(Name);
 { - Ввод списка полей - }
  StrList := nil;
  Writeln(' - Ввод списка полей для описываемого типа - ');
  Writeln(' Пустое имя поля (Hажатие Enter) -> Конец списка');
  Repeat
    Write('Введите имя поля: '); Readln(ItemName);
    If ItemName <> '' then
      Begin
        Repeat
          Write('Введите тип поля: '); Readln(ItemType);
          If ItemType='' then Writeln('Ошибка ! Тип поля не может быть пустым !');
        Until ItemType <> '';
        StrListAddEnd(StrList,ItemName,ItemType);
      End;
  Until ItemName = '';
 { >>><<< }
  Writeln('>>> Создаю файл : ',FileName,' <<<');
  Assign(T,FileName);
  Rewrite(T);
 { ---=== Описание типа ===--- }
  Cur:=0; Comment('Описание типа список');
  Inc(Cur); Out('Type');
  Inc(Cur,2);
  Out('P'+Name+' = ^T'+Name+';');
  Out('T'+Name+' = Record');
  Inc(Cur,2);
  CL:=StrList;
  While CL<>nil do Begin Out(CL^.Item1+' : '+CL^.Item2+';'); CL:=CL^.Next; End;
  Out('Next : P'+Name+';');
  Dec(Cur,2); Out('End;'); OutEnd;
 { ---=== Добавление нового элемента в начало списка ===--- }
  Cur:=0; Comment('Добавление нового элемента в начало списка');
  Inc(Cur); OutPr; OutWr('Procedure '+Name+'AddBeg( Var Root:P'+Name);
  Parameters;
  Out('Var Current : P'+Name+';'); Out('Begin');
  Zapolnenie('Current');
  Out('Current^.Next := Root;');
  Out('Root := Current;');
  Dec(Cur,2); Out('End;'); OutEnd;
 { ---=== Добавление нового элемента в конец списка ===--- }
  Cur:=0;
  Comment('Добавление нового элемента в конец списка');
  Inc(Cur); OutPr; OutWr('Procedure '+Name+'AddEnd( Var Root:P'+Name);
  Parameters;
  Out('Var Current,Buffer : P'+Name+';');
  Out('Begin');
  Inc(Cur); Out('{ - Заведение нового элемента - }'); Dec(Cur);
  Zapolnenie('Buffer');
  Out('Buffer^.Next := nil;');
  Dec(Cur); Out('{ - Присоединение элемента к существующему списку - }');
  Inc(Cur); Out('If Root <> nil then');
  Inc(Cur,2); Out('Begin');
  Inc(Cur,2); Out('Current := Root;');
  Out('While Current^.Next <> nil do Current := Current^.Next;');
  Out('Current^.Next := Buffer;');
  Dec(Cur,2); Out('End');
  Dec(Cur,2); Out('Else');
  Inc(Cur,2); Out('Root := Buffer;');
  Dec(Cur,2); Out('End;'); OutEnd;
{ ---=== Добавление нового элемента после элемента с номером N ===--- }
  Cur:=0; Comment('Добавление нового элемента после элемента с номером N');
  Inc(Cur); OutPr;
  OutWr('Procedure '+Name+'Add( Var Root:P'+Name+'; N:Integer');
  Parameters;
  Out('Var Current,Buffer : P'+Name+'; Counter : Word;');
  Out('Begin'); Inc(Cur);
  Out('{ - Заведение нового элемента - }'); Dec(Cur);
  Zapolnenie('Buffer');
  Dec(Cur); Out('{ - Присоединение элемента к существующему списку - }');
  Inc(Cur);
  Out('Current := Root;');
  Out('Counter := 0;');
  Out('If N <> 0 then');
  Inc(Cur,2); Out('While Current <> nil do');
  Inc(Cur,2);
  Out('Begin');
  Inc(Cur,2);
  Out('Inc(Counter);');
  Out('If Counter = N then');
  Inc(Cur,2);
  Out('Begin');
  Inc(Cur,2);
  Out('Buffer^.Next := Current^.Next;');
  Out('Current^.Next := Buffer;');
  Out('Break; { Больше нам делать нечего ;) }');
  Dec(Cur,2); Out('End;'); Dec(Cur,2);
  Out('Current := Current^.Next;');
  Dec(Cur,2); Out('End'); Dec(Cur,4); Out('Else'); Inc(Cur,2); Out('Begin');
  Inc(Cur,2); Out('Buffer^.Next := Root;'); Out('Root := Buffer;');
  Dec(Cur,2); Out('End;'); Dec(Cur,4); Out('End;'); OutEnd;
{ ---=== Просмотр всего списка (поэлементно) ===--- }
  Cur:=0;
  Comment('Просмотр всего списка (поэлементно)');
  Inc(Cur); Out('Procedure '+Name+'Show( Var Root:P'+Name+' );');
  Inc(Cur,2); Out('Var Current : P'+Name+';'); Out('Begin');
  Inc(Cur,2); Out('Current := Root;');
  Out('While Current <> nil do');
  Inc(Cur,2); Out('Begin');
  Inc(Cur); Out('{ !!! Вставьте здесь действие по обработке элемента списка ;) !!! }');
  Inc(Cur); Out('Current := Current^.Next;');
  Dec(Cur,2); Out('End;');
  Dec(Cur,4); Out('End;'); OutEnd;
 { ---=== Удаление элемента с номером N ===--- }
  Cur:=0; Comment('Удаление элемента с номером N');
  Inc(Cur); Out('Procedure '+Name+'Del( Var Root:P'+Name+'; N:Integer );');
  Inc(Cur,2); Out('Var Current,Buffer:P'+Name+'; Counter:Integer;');
  Out('Begin'); Inc(Cur,2);
  Out('Current := Root;'); Out('Buffer := nil;'); Out('Counter := 0;');
  Dec(Cur); Out('{ - Ищем нужный нам элемент - }');
  Inc(Cur); Out('While Current <> nil do');
  Inc(Cur,2); Out('Begin');
  Inc(Cur,2); Out('Inc(Counter);');
  Dec(Cur); Out('{ - И удаляем его ... - }');
  Inc(Cur); Out('If Counter = N then');
  Inc(Cur,2); Out('Begin');
  Inc(Cur,2); Out('If Buffer = nil then');
  Inc(Cur,2); Out('Root:=Current^.Next');
  Dec(Cur,2); Out('Else');
  Inc(Cur,2); Out('Buffer^.Next:=Current^.Next;');
  Dec(Cur,2); Out('Dispose(Current);');
  Out('Break; { Больше нам делать нечего ;) }');
  Dec(Cur,2); Out('End;');
  Dec(Cur,2); Out('Buffer := Current;'); Out('Current := Current^.Next;');
  Dec(Cur,2); Out('End;');
  Dec(Cur,4); Out('End;'); OutEnd;
 { ---=== Удаление всего списка ===--- }
  Cur:=0; Comment('Удаление всего списка');
  Inc(Cur); Out('Procedure '+Name+'DelAll( Var Root:P'+Name+' );');
  Inc(Cur,2); Out('Var Buffer : P'+Name+';');
  Out('Begin');
  Inc(Cur); Out('{ Пока в списке остались элементы }');
  Inc(Cur); Out('While Root <> nil do');
  Inc(Cur,2); Out('Begin');
  Inc(Cur); Out('{ Удаляем первый элемент }');
  Inc(Cur); Out('Buffer := Root;');
  Out('Root := Root^.Next;'); Out('Dispose(Buffer);');
  Dec(Cur,2); Out('End;');
  Dec(Cur,4); Out('End;'); OutEnd;
 { ---=== Подсчет количества элементов списка ===--- }
  Cur:=0; Comment('Подсчет количества элементов списка');
  Inc(Cur); Out('Function '+Name+'Num( Var Root:P'+Name+' ):Word;');
  Inc(Cur,2); Out('Var Current : P'+Name+'; Counter : Word;'); Out('Begin');
  Inc(Cur,2); Out('Current := Root;'); Out('Counter := 0;');
  Out('While Current <> nil do');
  Inc(Cur,2); Out('Begin');
  Inc(Cur,2); Out('Inc(Counter);');
  Out('Current := Current^.Next;');
  Dec(Cur,2); Out('End;');
  Dec(Cur,2); Out(Name+'Num := Counter;');
  Dec(Cur,2); Out('End;'); OutEnd;
 { ---=== Основная Программа ===--- }
  Cur:=0;
  Comment('Основная Программа');
  Out('Var '+Name+' : P'+Name+';');
  Out('Begin');
  Out('  '+Name+' := nil;');
  Out('End.');
  StrListDelAll(StrList);
  Close(T);
End.