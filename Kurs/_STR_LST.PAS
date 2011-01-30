{ -= Описание типа список =- }
 Type
   PFieldList = ^TFieldList;
   TFieldList = Record
     ItemName : String; { Имя поля }
     ItemType : String; { Тип поля }
     ItemComm : String; { Описание поля }
     Next : PFieldList;
   End;

{ -= Добавление нового элемента в начало списка =- }
 Procedure FieldListAddBeg( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
   Var Current : PFieldList;
   Begin
     New(Current);
     Current^.ItemName := ItemName; { Имя поля }
     Current^.ItemType := ItemType; { Тип поля }
     Current^.ItemComm := ItemComm; { Описание поля }
     Current^.Next := Root;
     Root := Current;
   End;

{ -= Добавление нового элемента в конец списка =- }
 Procedure FieldListAddEnd( Var Root:PFieldList; ItemName:String; ItemType:String; ItemComm:String );
   Var Current,Buffer : PFieldList;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.ItemName := ItemName; { Имя поля }
     Buffer^.ItemType := ItemType; { Тип поля }
     Buffer^.ItemComm := ItemComm; { Описание поля }
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

{ -= Добавление нового элемента после элемента с номером N =- }
 Procedure FieldListAdd( Var Root:PFieldList; N:Integer; ItemName:String; ItemType:String; ItemComm:String );
   Var Current,Buffer : PFieldList; Counter : Word;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.ItemName := ItemName; { Имя поля }
     Buffer^.ItemType := ItemType; { Тип поля }
     Buffer^.ItemComm := ItemComm; { Описание поля }
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

{ -= Просмотр всего списка (поэлементно) =- }
 Procedure FieldListShow( Var Root:PFieldList );
   Var Current : PFieldList;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ -= Удаление элемента с номером N =- }
 Procedure FieldListDel( Var Root:PFieldList; N:Integer );
   Var Current,Buffer:PFieldList; Counter:Integer;
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

{ -= Удаление всего списка =- }
 Procedure FieldListDelAll( Var Root:PFieldList );
   Var Buffer : PFieldList;
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

{ -= Подсчет количества элементов списка =- }
 Function FieldListNum( Var Root:PFieldList ):Word;
   Var Current : PFieldList; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     FieldListNum := Counter;
   End;

