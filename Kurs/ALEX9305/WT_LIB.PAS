{ ╔╤═════════════════════════════════════════════════════════════════╤╗ }
{ ║│                        Word Tree Library                        │║ }
{ ║│                      ---===#########===---                      │║ }
{ ║│    Описание формата файла словаря:                              │║ }
{ ║│ 4 байта - Текущее количество слов в файле                       │║ }
{ ║│ Каталог - Список букв ( Буква и адрес ее ветки ), включающий    │║ }
{ ║│  продолжения списка и терминальный символ ! )                   │║ }
{ ╚╧═════════════════════════════════════════════════════════════════╧╝ }
Unit WT_Lib;

Interface

{ ---=== Элемент списка букв ===---- }
 Type
   TSymbol = Record
     Sym : Char; { Символ }
     WRD : LongInt; { Hомер слова в словаре или 0 при его несуществовании }
     Adr : LongInt; { Адрес в файле ветки дерева }
   End;

 Const
  { Символ продолжения ( разрыва ) списка }
   ContSym = #254;
  { Символ конца списка букв }
   TermSym = #255;

{ ---=== Словарь ! ===---- }
 Type
   TDictionary = Object
     F       : File; { Файловая переменная для работы ;) }
     Sym     : TSymbol; { Буфер текущего символа }
     SymPos  : LongInt; { Позиция символа }
     WordNum : LongInt; { Число слов в словаре }
    { - Запись 4-х байтового числа в файл - }
     Procedure WriteNum( N:LongInt );
    { - Чтение 4-х байтового числа из файла - }
     Procedure ReadNum( Var N:LongInt );
    { - Дописывание терминального символа - }
     Procedure WriteTermSym;
    { - Считывание символа - }
     Procedure ReadSym;
    { - Запись символа - }
     Procedure WriteSym;
    { - Создание нового файла словаря - }
     Constructor New( FileName:String );
    { - Открытие существующего файла словаря - }
     Constructor Open( FileName:String );
    { - Закрытие файла - }
     Destructor Done;
    { - Поиск символа в строке Sym := Описание - }
     Procedure FindChar( _Char_:Char );
    { - Добавление слова в словарь - }
     Procedure Add( NewWord:String );
    { - Поиск слова в словаре - }
     Function Find( _Word_:String ):LongInt;
    { - Удаление слова из словаря - }
     Procedure Del( _Word_:String );
   End;

Implementation


{ ---=== Запись 4-х байтового числа в файл ===--- }
 Procedure TDictionary.WriteNum( N:LongInt );
   Begin
     BlockWrite(F,N,SizeOf(N));
   End;

{ ---=== Чтение 4-х байтового числа из файла ===--- }
 Procedure TDictionary.ReadNum( Var N:LongInt );
   Begin
     BlockRead(F,N,SizeOf(N));
   End;

{ ---=== Дописывание терминального символа ===--- }
 Procedure TDictionary.WriteTermSym;
   Begin
     Sym.Sym := TermSym;
     Sym.WRD := 0;
     Sym.Adr := 0;
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== Считывание символа ===--- }
 Procedure TDictionary.ReadSym;
   Begin
     Repeat
       SymPos:=FilePos(F);
       BlockRead(F,Sym,SizeOf(Sym));
       If Sym.Sym = ContSym then Seek(F,Sym.Adr);
     Until Sym.Sym <> ContSym;
   End;

{ ---=== Запись символа ===--- }
 Procedure TDictionary.WriteSym;
   Begin
     SymPos:=FilePos(F);
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== Создание нового файла словаря ===--- }
 Constructor TDictionary.New( FileName:String );
   Begin
     Assign(F,FileName);
     Rewrite(F,1);
     WordNum := 0;
     WriteNum(WordNum);
    { Совсем - совсем нет букв ;) }
     WriteTermSym;
   End;

{ ---=== Открытие существующего файла словаря ===--- }
 Constructor TDictionary.Open( FileName:String );
   Begin
     Assign(F,FileName);
     Reset(F,1);
     ReadNum(WordNum);
   End;

{ ---=== Закрытие файла словаря ===--- }
 Destructor TDictionary.Done;
   Begin
     Seek(F,0);
     WriteNum(WordNum);
     Close(F);
   End;

{ ---=== Поиск символа в строке Sym := Описание ===--- }
 Procedure TDictionary.FindChar( _Char_:Char );
   Begin
     Repeat
       ReadSym;
     Until ((Sym.Sym = TermSym) Or (Sym.Sym = _Char_));
   End;

{ ---=== Добавление слова в словарь ===--- }
 Procedure TDictionary.Add( NewWord:String );
   Var I:Byte; Temp:LongInt; Flag:Boolean;
   Begin
     Inc(WordNum);
     Seek(F,SizeOf(LongInt));
    { Цикл по буквам }
     Flag:=True;
     For I:=1 to Length(NewWord) do
       Begin
         If Flag then
           Begin
             FindChar(NewWord[I]);
             If Sym.Sym = TermSym then
               Begin
                 Flag := False;
                 Seek(F,SymPos);
                 Sym.Sym := ContSym;
                 Sym.Adr := FileSize(F);
                 WriteSym;
                 Seek(F,Sym.Adr);
                 SymPos:=Sym.Adr;
                 Dec(I);
               End
             Else
               Seek(F,Sym.Adr);
           End
         Else
           Begin
             Sym.Sym:=NewWord[I];
             If I <> Length(NewWord) then
               Begin
                 Sym.WRD:=0;
                 Sym.Adr:=SymPos+2*SizeOf(TSymbol);
               End
             Else
               Begin
                 Sym.WRD:=WordNum;
                 Sym.Adr:=0;
               End;
             WriteSym;
             WriteTermSym;
             SymPos:=FilePos(F);
           End;
       End;
   End;

{ ---=== Поиск слова в словаре ===--- }
 Function TDictionary.Find( _Word_:String ):LongInt;
   Var I:Byte;
   Begin
     Seek(F,SizeOf(LongInt));
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { Если не найдено слово ! (Sym.WRD:=0) }
         If Sym.Sym = TermSym then Break;
         Seek(F,Sym.Adr);
       End;
     Find := Sym.WRD;
   End;

{ ---=== Удаление слова из словаря ===--- }
 Procedure TDictionary.Del( _Word_:String );
   Var I:Byte; Temp:TSymbol; PathAdr,TempAdr:LongInt;
   Begin
     Seek(F,SizeOf(LongInt));
     PathAdr:=SizeOf(LongInt);
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { Если не найдено слово ! (Sym.WRD:=0) }
         If Sym.Sym = TermSym then Exit;
         TempAdr:=SymPos;
         Temp:=Sym;
         ReadSym;
         If Sym.Sym <> TermSym then PathAdr:=TempAdr;
         Seek(F,Temp.Adr);
       End;
     Seek(F,PathAdr);
     Sym.Sym:=ContSym;
     Sym.WRD:=0;
     Sym.Adr:=PathAdr+SizeOf(TSymbol);
     WriteSym;
   End;

End.