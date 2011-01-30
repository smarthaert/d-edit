Unit U_LIST;

Interface

 Type
   StrP = ^StrT;
   StrT = Record
     Data : String;
     Next : StrP;
   End;

 Const Root : StrP = nil;

 { - Отчистка списка строк - }
  Procedure ClearAll;
 { - Добавление строки - }
  Procedure AddStr( Str:String );
 { - Поиск строки в списке - }
  Function FindStr( Str:String ):Boolean;

Implementation

{ - Отчистка списка строк - }
 Procedure ClearAll;
   Var Buf:StrP;
   Begin
     While Root<>nil do
       Begin
         Buf  := Root;
         Root := Buf^.Next;
         Dispose(Buf);
       End;
   End;

{ - Добавление строки - }
 Procedure AddStr( Str:String );
   Var Buf:StrP;
   Begin
     New(Buf);
     Buf^.Data := Str;
     Buf^.Next := Root;
     Root      := Buf;
   End;

{ - Поиск строки в списке - }
 Function FindStr( Str:String ):Boolean;
   Var Buf:StrP;
   Begin
     FindStr := False;
     Buf := Root;
     While Buf<>nil do
       Begin
         If Buf^.Data = Str then
           Begin
             FindStr := True;
             Exit;
           End;
         Buf := Buf^.Next;
       End;
   End;

End.