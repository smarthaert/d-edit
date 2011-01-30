{ ---=== Элемент списка букв ===---- }
Type
  TSymbol = Record
    Sym : Char; { Символ }
    WRD : LongInt; { Hомер слова в словаре или 0 при его несуществовании }
    Adr : LongInt; { Адрес в файле ветки дерева }
  End;

Var T:Text; F:File; L:LongInt; Sym:TSymbol;
Begin
  Assign(F,'TEST.DIC');
  Reset(F,1);
  Assign(T,'TESTDIC.TXT');
  Rewrite(T);
  BlockRead(F,L,SizeOf(L));
  Writeln(T,'Всего слов в словаре: ',L);
  Repeat
    L:=FilePos(F);
    BlockRead(F,Sym,SizeOf(Sym));
    Write(T,L,' Буква: ');
    Case Sym.Sym of
     'A'..'Z': Write(T,'"',Sym.Sym,'"');
     #254: Write(T,'<Ссылка>');
     #255: Write(T,'<Конец>');
    Else
      Write(T,Ord(Sym.Sym));
    End;
    Writeln(T,' Слово: ',Sym.WRD,' Адрес: ',Sym.Adr);
  Until EOF(F);
  Close(T);
  Close(F);
End.