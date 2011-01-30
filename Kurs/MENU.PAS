{ Простейшее меню (Работа со списками) }
Uses CRT;

{ ---=== Описание типа список ---===}
 Type
   PMenu = ^TMenu;
   TMenu = Record
     Item : String;
     Next : PMenu;
   End;

{ ---=== Добавление нового элемента в конец списка ---===}
 Procedure MenuAdd( Var Root:PMenu; Item:String );
   Var Current,Buffer : PMenu;
   Begin
    { - Заведение нового элемента - }
     New(Buffer);
     Buffer^.Item := Item;
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

{ ---=== Просмотр всего списка (поэлементно) ---===}
 Procedure MenuShow( Var Root:PMenu );
   Var Current : PMenu;
   Begin
     Current := Root;
     While Current <> nil do
       Begin
        { !!! Вставьте здесь действие по обработке элемента списка ;) !!! }
         Current := Current^.Next;
       End;
   End;

{ ---=== Удаление всего списка ---===}
 Procedure MenuDelAll( Var Root:PMenu );
   Var Buffer : PMenu;
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
 Function MenuNum( Var Root:PMenu ):Word;
   Var Current : PMenu; Counter : Word;
   Begin
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         Current := Current^.Next;
       End;
     MenuNum := Counter;
   End;

{ ---=== Вывод меню на экран ===--- }
 Procedure MenuDraw( Var Root:PMenu; Select:Word );
   Var Current : PMenu; Counter : Word;
   Begin
     TextColor(0);
     GotoXY(1,1);
     Current := Root;
     Counter := 0;
     While Current <> nil do
       Begin
         Inc(Counter);
         If Select = Counter then TextBackGround(7) Else TextBackGround(3);
         Write(' '+Current^.Item+' ');
         Current := Current^.Next;
       End;
     TextColor(7); TextBackGround(0);
   End;

{ ---=== Выбор в меню ---===}
 Function MenuSelect( Var Root:PMenu ):Word;
   Var Current : PMenu; Select : Word; Key : Char;
   Begin
     ClrScr;
     Select:=1;
     Repeat
       MenuDraw(Root,Select);
       Key:=ReadKey;
       If Key = #00 then
         Case ReadKey of
           #75: Dec(Select);
           #77: Inc(Select);
         End;
       If Select < 1 then Select := MenuNum(Root);
       If Select > MenuNum(Root) then Select := 1;
     Until ((Key = #27) Or (Key = #13) Or (Key = ' '));
     ClrScr;
     MenuSelect := Select;
   End;

{ ---=== Основная Программа ---===}
Var Menu : PMenu;
Begin
  Menu := nil;
  MenuAdd(Menu,'Test1');
  MenuAdd(Menu,'Test2');
  MenuAdd(Menu,'Test3');
  Writeln(MenuSelect(Menu));
  MenuDelAll(Menu);
End.
