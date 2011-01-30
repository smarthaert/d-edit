{ ---=== Описание типа список ---===}
 Type
   PNumList = ^TNumList;
   TNumList = Record
     Data : Float;
     Next : PNumList;
   End;

{ ---=== Добавление нового элемента в начало списка ---===}
 Procedure NumListAddBeg( Var Root:PNumList; Data:Float );
   Var Current : PNumList;
   Begin
     New(Current);
     Current^.Data := Data;
     Current^.Next := Root;
     Root := Current;
   End;

{ ---=== Добавление нового элемента в конец списка ---===}
 Procedure NumListAddEnd( Var Root:PNumList; Data:Float );
   Var Current,Buffer : PNumList;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
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
 Procedure NumListAdd( Var Root:PNumList; N:Integer; Data:Float );
   Var Current,Buffer : PNumList; Counter : Word;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
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
 Procedure NumListShow( Var Root:PNumList );
   Var Current : PNumList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление элемента с номером N ---===}
 Procedure NumListDel( Var Root:PNumList; N:Integer );
   Var Current,Buffer:PNumList; Counter:Integer;
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
 Procedure NumListDelAll( Var Root:PNumList );
   Var Buffer : PNumList;
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
 Function NumListNum( Var Root:PNumList ):Word;
   Var Current : PNumList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     NumListNum := Counter;
   End;

{ ---=== Основная Программа ---===}
Var NumList : PNumList;
Begin
  NumList := nil;
End.
