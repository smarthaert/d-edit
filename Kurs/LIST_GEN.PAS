{$I _STR_LST.PAS}

{ -= Работа с выходным файлом =- }
 Type
   TGen = Object
     T : Text; { Сюда мы записываем текст программы }
     Cur : Integer; { Текущая табуляция }
     FileNameSave : String;
     Constructor Open( FileName:String ); { Открываем файл }
     Procedure Sys( S:String ); { Вывод со смещением на символ влево }
     Procedure Out( S:String ); { Вывод строки в файл }
     Procedure OutTab; { Вывод табуляции }
     Procedure OutS( S:String ); { Вывод "середины" строки }
     Procedure OutEnd; { Вывод конца строки }
     Procedure ProcComm( S:String ); { Процедурные комментарии }
     Procedure Comm( S:String ); { "Обычные" комментарии }
     Procedure EndComm( S:String ); { Комментарии в конце строки }
     Procedure Parameters( ParamList:PFieldList );
     Procedure FieldsInit( NewElemName:String; Fields:PFieldList );
     Destructor Done; { Закрываем файл }
   End;

 Constructor TGen.Open( FileName:String );
   Begin
     Writeln('>>> Создаю файл : ',FileName+'.PAS',' <<<');
     Assign(T,FileName+'.PAS');
     Rewrite(T);
     Cur:=1;
     FileNameSave:=FileName;
   End;

 Procedure TGen.Sys( S:String ); Begin Dec(Cur); Out(S); Inc(Cur); End;
 Procedure TGen.Out( S:String );
   Var I:Word; Begin  For I:=1 to Cur do Write(T,' '); Writeln(T,S); End;
 Procedure TGen.OutTab; Var I:Word; Begin  For I:=1 to Cur do Write(T,' '); End;
 Procedure TGen.OutS( S:String ); Begin Write(T,S); End;
 Procedure TGen.OutEnd; Begin Writeln(T); End;
 Procedure TGen.ProcComm( S:String );
   Begin Sys('{ -= '+S+' =- }'); End;
 Procedure TGen.Comm( S:String );
   Begin Sys('{ '+S+' }'); End;
 Procedure TGen.EndComm( S:String ); Begin OutS(' { '+S+' }'); OutEnd; End;

 Procedure TGen.Parameters( ParamList:PFieldList );
   Var CL:PFieldList; S:String;
   Begin
     CL:=ParamList; S:='';
     While CL<>nil do
       Begin
         If ((CL^.ItemType = S) And (CL))
         OutS('; '+CL^.ItemName+':'+CL^.ItemType);
         S:=CL^.ItemName;
         CL:=CL^.Next;
       End;
     OutS(' );'); OutEnd; Inc(Cur,2);
   End;

 Procedure TGen.FieldsInit( NewElemName:String; Fields:PFieldList );
   Var CL:PFieldList;
   Begin
     Inc(Cur,2);
     Out('New('+NewElemName+');');
     CL:=Fields;
     While CL<>nil do
       Begin
         OutTab;
         OutS(NewElemName+'^.'+CL^.ItemName+' := '+CL^.ItemName+';');
         EndComm(CL^.ItemComm);
         CL:=CL^.Next;
       End;
   End;

 Destructor TGen.Done;
   Begin
     Close(T);
   End;

{ -= Генератор списка =- }
 Type
   TListGen = Object(TGen)
     Fields : PFieldList;
     Imp : Boolean;
     TypeName : String;
     Constructor Open( FileName,_TypeName:String );
     Destructor Done;
     Procedure _Type;
     Procedure _AddBeg;
     Procedure _AddEnd;
     Procedure _Add;
     Procedure _AddShow;
     Procedure _Del;
     Procedure _DelAll;
     Procedure _Num;
     Procedure _MainProg;
     Procedure _Unit;
     Procedure _AllProc;
   End;

 Constructor TListGen.Open( FileName,_TypeName:String );
   Begin
     Inherited Open(FileName);
     Fields := nil;
     TypeName := _TypeName;
     Imp := True;
   End;

 Destructor TListGen.Done;
   Begin
     FieldListDelAll(Fields);
     Inherited Done;
   End;

{ -= Описание типа =- }
 Procedure TListGen._Type;
   Var CL : PFieldList;
   Begin
     ProcComm('Описание типа список');
     Out('Type');
     Inc(Cur,2);
     Out('P'+TypeName+' = ^T'+TypeName+';');
     Out('T'+TypeName+' = Record');
     Inc(Cur,2);
     CL:=Fields;
     While CL<>nil do
       Begin
         OutTab; OutS(CL^.ItemName+' : '+CL^.ItemType+';'); EndComm(CL^.ItemComm);
         CL:=CL^.Next;
       End;
     Out('Next : P'+TypeName+';');
     Dec(Cur,2); Out('End;'); OutEnd; Dec(Cur,2);
   End;

{ -= Добавление нового элемента в начало списка =- }
 Procedure TListGen._AddBeg;
   Begin
     ProcComm('Добавление нового элемента в начало списка');
     OutTab; OutS('Procedure '+TypeName+'AddBeg( Var Root:P'+TypeName);
     Parameters(Fields);
     If Imp then
       Begin
         Out('Var Current : P'+TypeName+';'); Out('Begin');
         FieldsInit('Current',Fields);
         Out('Current^.Next := Root;');
         Out('Root := Current;');
         Dec(Cur,2); Out('End;'); OutEnd;
       End;
     Dec(Cur,2);
   End;

 { -= Добавление нового элемента в конец списка =- }
 Procedure TListGen._AddEnd;
   Begin
     ProcComm('Добавление нового элемента в конец списка');
     OutTab; OutS('Procedure '+TypeName+'AddEnd( Var Root:P'+TypeName);
     Parameters(Fields);
     If Imp then
       Begin
         Out('Var Current,Buffer : P'+TypeName+';');
         Out('Begin');
         Comm('- Заведение нового элемента -');
         FieldsInit('Buffer',Fields);
         Out('Buffer^.Next := nil;');
         Comm('- Присоединение элемента к существующему списку -');
         Out('If Root <> nil then');
         Inc(Cur,2); Out('Begin');
         Inc(Cur,2); Out('Current := Root;');
         Out('While Current^.Next <> nil do Current := Current^.Next;');
         Out('Current^.Next := Buffer;');
         Dec(Cur,2); Out('End');
         Dec(Cur,2); Out('Else');
         Inc(Cur,2); Out('Root := Buffer;'); Dec(Cur,4);
         Out('End;'); OutEnd;
       End;
     Dec(Cur,2);
   End;

{ -= Добавление нового элемента после элемента с номером N =- }
 Procedure TListGen._Add;
   Begin
     ProcComm('Добавление нового элемента после элемента с номером N');
     OutTab; OutS('Procedure '+TypeName+'Add( Var Root:P'+TypeName+'; N:Integer');
     Parameters(Fields);
     If Imp then
       Begin
         Out('Var Current,Buffer : P'+TypeName+'; Counter : Word;');
         Out('Begin');
         Comm('- Заведение нового элемента -');
         FieldsInit('Buffer',Fields);
         Comm('- Присоединение элемента к существующему списку -');
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
       End;
     Dec(Cur,2);
   End;

{ -= Просмотр всего списка (поэлементно) =- }
 Procedure TListGen._AddShow;
   Begin
     ProcComm('Просмотр всего списка (поэлементно)');
     Out('Procedure '+TypeName+'Show( Var Root:P'+TypeName+' );');
     Inc(Cur,2);
     If Imp then
       Begin
         Out('Var Current : P'+TypeName+';'); Out('Begin');
         Inc(Cur,2); Out('Current := Root;');
         Out('While Current <> nil do');
         Inc(Cur,2); Out('Begin');
         Inc(Cur,2);
         Comm('!!! Вставьте здесь действие по обработке элемента списка ;) !!!');
         Out('Current := Current^.Next;');
         Dec(Cur,2); Out('End;');
         Dec(Cur,4); Out('End;'); OutEnd;
       End;
     Dec(Cur,2);
   End;

{ -= Удаление элемента с номером N =- }
 Procedure TListGen._Del;
   Begin
     ProcComm('Удаление элемента с номером N');
     Out('Procedure '+TypeName+'Del( Var Root:P'+TypeName+'; N:Integer );');
     Inc(Cur,2);
     If Imp then
       Begin
         Out('Var Current,Buffer:P'+TypeName+'; Counter:Integer;');
         Out('Begin'); Inc(Cur,2);
         Out('Current := Root;'); Out('Buffer := nil;'); Out('Counter := 0;');
         Comm('- Ищем нужный нам элемент -');
         Out('While Current <> nil do');
         Inc(Cur,2); Out('Begin');
         Inc(Cur,2); Out('Inc(Counter);');
         Comm('- И удаляем его ... -');
         Out('If Counter = N then');
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
       End;
     Dec(Cur,2);
   End;

{ -= Удаление всего списка =- }
 Procedure TListGen._DelAll;
   Begin
     ProcComm('Удаление всего списка');
     Out('Procedure '+TypeName+'DelAll( Var Root:P'+TypeName+' );');
     Inc(Cur,2);
     If Imp then
       Begin
         Out('Var Buffer : P'+TypeName+';');
         Out('Begin');
         Inc(Cur,2);
         Comm('Пока в списке остались элементы');
         Out('While Root <> nil do');
         Inc(Cur,2); Out('Begin'); Inc(Cur,2);
         Comm('Удаляем первый элемент');
         Out('Buffer := Root;');
         Out('Root := Root^.Next;'); Out('Dispose(Buffer);');
         Dec(Cur,2); Out('End;');
         Dec(Cur,4); Out('End;'); OutEnd;
       End;
     Dec(Cur,2);
   End;

{ -= Подсчет количества элементов списка =- }
 Procedure TListGen._Num;
   Begin
     ProcComm('Подсчет количества элементов списка');
     Out('Function '+TypeName+'Num( Var Root:P'+TypeName+' ):Word;');
     Inc(Cur,2);
     If Imp then
       Begin
         Out('Var Current : P'+TypeName+'; Counter : Word;'); Out('Begin');
         Inc(Cur,2); Out('Current := Root;'); Out('Counter := 0;');
         Out('While Current <> nil do');
         Inc(Cur,2); Out('Begin');
         Inc(Cur,2); Out('Inc(Counter);');
         Out('Current := Current^.Next;');
         Dec(Cur,2); Out('End;');
         Dec(Cur,2); Out(TypeName+'Num := Counter;');
         Dec(Cur,2); Out('End;'); OutEnd;
       End;
     Dec(Cur,2);
   End;

{ -= Основная Программа =- }
 Procedure TListGen._MainProg;
   Begin
     Cur:=0;
     ProcComm('Основная Программа');
     Out('Var '+TypeName+' : P'+TypeName+';');
     Out('Begin');
     Out('  '+TypeName+' := nil;');
     Out('End.');
   End;

{ -= Все процедуры =- }
 Procedure TListGen._AllProc;
   Begin
     _AddBeg;
     _AddEnd;
     _Add;
     _AddShow;
     _Del;
     _DelAll;
     _Num;
   End;

{ -= Модуль (Unit) =- }
 Procedure TListGen._Unit;
   Begin
     Sys('Unit '+FileNameSave+';'); OutEnd;
     Sys('Interface'); OutEnd;
     _Type;
     Imp := False; _AllProc;
     OutEnd; Sys('Implementation'); OutEnd;
     Imp := True; _AllProc;
     Sys('End.');
   End;

{ ---=== Основная программа ===--- }
Var FileName,TypeName,ItemName,ItemType,ItemComm:String;
    CL : PFieldList;
    Gen : TListGen;
Begin
  Writeln('>>> Генератор программ для работы со списками <<<');
  Writeln('- Поэтапное написание программы для работы со списком -');
  Writeln('- Пожалуйста, не ошибайтесь ! Отката пока нет ;) -');
  Writeln('                             < 9331 - Super Group >');
 { - Ввод имени файла - }
{  Writeln(' - Ввод имени файла для размещения результирующего кода - ');
  Write('Введите имя для создаваемого файла: '); Readln(FileName);}
  FileName := 'Test';
 { - Ввод имени типа - }
{  Writeln(' - Ввод имени типа (Hапример: Menu -> Будут созданы: TMenu и PMenu) - ');
  Write('Введите имя для создаваемого типа: '); Readln(TypeName);}
  TypeName := 'FieldList';
  Gen.Open(FileName,TypeName);
 { - Ввод списка полей - }
{  Writeln(' - Ввод списка полей для описываемого типа - ');
  Writeln(' Пустое имя поля (Hажатие Enter) -> Конец списка');
  Repeat
    Write('Введите имя поля: '); Readln(ItemName);
    If ItemName <> '' then
      Begin
        Repeat
          Write('Введите тип поля: '); Readln(ItemType);
          If ItemType='' then Writeln('Ошибка! Тип поля не может быть пустым !');
        Until ItemType <> '';
        Repeat
          Write('Введите описание поля: '); Readln(ItemComm);
          If ItemComm='' then Writeln('Ошибка! Описание поля не может быть пустым !');
        Until ItemComm <> '';
        FieldListAddEnd(Gen.Fields,ItemName,ItemType,ItemComm);
      End;
  Until ItemName = '';}
  FieldListAddEnd(Gen.Fields,'ItemName','String','Имя поля');
  FieldListAddEnd(Gen.Fields,'ItemType','String','Тип поля');
  FieldListAddEnd(Gen.Fields,'ItemComm','String','Описание поля');
  Gen._Unit;
  Gen.Done;
End.