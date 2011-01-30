{ ---=== Описание типа список ---===}
 Type
   PWTMem = ^TWTMem;
   TWTMem = Record
     Sym : Char;
     Adr : LongInt;
     WRD : LongInt;
     SelfAdr : LongInt;
     Sub : PWTMem;
     Next : PWTMem;
   End;

{ ---=== Добавление нового элемента в начало списка ---===}
 Procedure WTMemAddBeg( Var Root:PWTMem; Sym:Char; Adr:LongInt; WRD:LongInt; SelfAdr:LongInt; Sub:PWTMem );
   Var Current : PWTMem;
   Begin
     New(Current);
     Current^.Sym := Sym;
     Current^.Adr := Adr;
     Current^.WRD := WRD;
     Current^.SelfAdr := SelfAdr;
     Current^.Sub := Sub;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Добавление нового элемента в конец списка ---===}
 Procedure WTMemAddEnd( Var Root:PWTMem; Sym:Char; Adr:LongInt; WRD:LongInt; SelfAdr:LongInt; Sub:PWTMem );
   Var Current,Buffer : PWTMem;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Sym := Sym;
     Buffer^.Adr := Adr;
     Buffer^.WRD := WRD;
     Buffer^.SelfAdr := SelfAdr;
     Buffer^.Sub := Sub;
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

{ ---=== Добавление нового элемента после элемента с номером N ---===}
 Procedure WTMemAdd( Var Root:PWTMem; N:Integer; Sym:Char; Adr:LongInt; WRD:LongInt; SelfAdr:LongInt; Sub:PWTMem );
   Var Current,Buffer : PWTMem; Counter : Word;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Sym := Sym;
     Buffer^.Adr := Adr;
     Buffer^.WRD := WRD;
     Buffer^.SelfAdr := SelfAdr;
     Buffer^.Sub := Sub;
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

{ ---=== Просмотр всего списка (поэлементно) ---===}
 Procedure WTMemShow( Var Root:PWTMem );
   Var Current : PWTMem;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление элемента с номером N ---===}
 Procedure WTMemDel( Var Root:PWTMem; N:Integer );
   Var Current,Buffer:PWTMem; Counter:Integer;
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

{ ---=== Удаление всего списка ---===}
 Procedure WTMemDelAll( Var Root:PWTMem );
   Var Buffer : PWTMem;
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

{ ---=== Подсчет количества элементов списка ---===}
 Function WTMemNum( Var Root:PWTMem ):Word;
   Var Current : PWTMem; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     WTMemNum := Counter;
   End;
