{ ---=== Описание типа список ---===}
 Type
   PPolyList = ^TPolyList;
   TPolyList = Record
     Name : String;
     Data : Polynom;
     Next : PPolyList;
   End;

{ ---=== Добавление нового элемента в начало списка ---===}
 Procedure PolyListAddBeg( Var Root:PPolyList; Name:String; Data:Polynom );
   Var Current : PPolyList;
   Begin
     New(Current);
     Current^.Name := Name;
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Добавление нового элемента в конец списка ---===}
 Procedure PolyListAddEnd( Var Root:PPolyList; Name:String; Data:Polynom );
   Var Current,Buffer : PPolyList;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Name := Name;
     Buffer^.Data := Data;
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
 Procedure PolyListAdd( Var Root:PPolyList; N:Integer; Name:String; Data:Polynom );
   Var Current,Buffer : PPolyList; Counter : Word;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Name := Name;
     Buffer^.Data := Data;
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
 Procedure PolyListShow( Var Root:PPolyList );
   Var Current : PPolyList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление элемента с номером N ---===}
 Procedure PolyListDel( Var Root:PPolyList; N:Integer );
   Var Current,Buffer:PPolyList; Counter:Integer;
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
 Procedure PolyListDelAll( Var Root:PPolyList );
   Var Buffer : PPolyList;
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
 Function PolyListNum( Var Root:PPolyList ):Word;
   Var Current : PPolyList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     PolyListNum := Counter;
   End;

{ ---=== Список полиномов ---===}
Const PolyList : PPolyList = nil;
