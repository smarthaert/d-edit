Const
  StrNum = 45;
  Str : Array [1..StrNum] of String = (
   '',
   '{ - А сюда мы будем сохраняться - }',
   'Var T:Text;',
   '',
   '{ - Сохpанение текстового буфеpа - }',
   'Procedure SaveStr;',
   '  Var Counter:Word; I:Byte;',
   '  Begin',
   '    For Counter := 1 to StrNum do',
   '      Begin',
   '        Write(T,'+#39+'   '+#39+',#39);',
   '        For I := 1 to Length(Str[Counter]) do',
   '          Case Str[Counter,I] of',
   '            #39: Write(T,#39+'+#39+'+#39+'+#39+'+#39);',
   '          Else',
   '            Write(T,Str[Counter,I]);',
   '          End;',
   '        Write(T,#39);',
   '        If Counter < StrNum then Writeln(T,'+#39+','+#39+');',
   '      End;',
   '    Writeln(T,'+#39+'  );'+#39+');',
   '  End;',
   '',
   '{ - Сохpанение текста самой пpогpаммы - }',
   'Procedure SavePrg;',
   '  Var Counter:Word;',
   '  Begin',
   '    For Counter := 1 to StrNum do',
   '      Writeln( T, Str[Counter] );',
   '  End;',
   '',
   '{ ---=== Основная Программа ===--- }',
   'Begin',
   ' { Откpываем файл и пишем заголовок }',
   '  Assign(T,'+#39+'SelfCopy.Pas'+#39+');',
   '  Rewrite(T);',
   '  Writeln(T,'+#39+'Const'+#39+');',
   '  Writeln(T,'+#39+'  StrNum = '+#39+',StrNum,'+#39+';'+#39+');',
   '  Writeln(T,'+#39+'  Str : Array [1..StrNum] of String = ('+#39+');',
   ' { Пишем пpогpамму }',
   '  SaveStr;',
   '  SavePrg;',
   ' { Закpываем файл }',
   '  Close(T);',
   'End.'  );

{ - А сюда мы будем сохраняться - }
Var T:Text;

{ - Сохpанение текстового буфеpа - }
Procedure SaveStr;
  Var Counter:Word; I:Byte;
  Begin
    For Counter := 1 to StrNum do
      Begin
        Write(T,'   ',#39);
        For I := 1 to Length(Str[Counter]) do
          Case Str[Counter,I] of
            #39: Write(T,#39+'+#39+'+#39);
          Else
            Write(T,Str[Counter,I]);
          End;
        Write(T,#39);
        If Counter < StrNum then Writeln(T,',');
      End;
    Writeln(T,'  );');
  End;

{ - Сохpанение текста самой пpогpаммы - }
Procedure SavePrg;
  Var Counter:Word;
  Begin
    For Counter := 1 to StrNum do
      Writeln( T, Str[Counter] );
  End;

{ ---=== Основная Программа ===--- }
Begin
 { Откpываем файл и пишем заголовок }
  Assign(T,'SelfCopy.Pas');
  Rewrite(T);
  Writeln(T,'Const');
  Writeln(T,'  StrNum = ',StrNum,';');
  Writeln(T,'  Str : Array [1..StrNum] of String = (');
 { Пишем пpогpамму }
  SaveStr;
  SavePrg;
 { Закpываем файл }
  Close(T);
End.
