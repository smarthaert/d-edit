{ 頻様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様用� }
{ 些                        Word Tree Library                        該 }
{ 些                      ---===#########===---                      該 }
{ 些    ｯ����┘ 筮爼��� ����� 甄���瑙:                              該 }
{ 些 4 ����� - �オ竕ゥ ����腑痰〓 甄�� � �����                       該 }
{ 些 ������� - ���甌� ＜�� ( �礫�� � �むメ ゥ ▲皖� ), →�鈑�鉗┤    該 }
{ 些  �牀ぎ�Ε��� 甎�瓷� � 皀爼┃��讚覃 瓱�〓� ! )                   該 }
{ 範様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様溶� }
Unit WT_Lib;

Interface

{ ---=== ��ガキ� 甎�瓷� ＜�� ===---- }
 Type
   TSymbol = Record
     Sym : Char; { �━〓� }
     WRD : LongInt; { H��ム 甄��� � 甄���爛 ┼� 0 �爬 ィ� �メ竕メ癶����┬ }
     Adr : LongInt; { �むメ � ����� ▲皖� ぅ爛�� }
   End;

 Const
  { �━〓� �牀ぎ�Ε��� ( ��о襤� ) 甎�瓷� }
   ContSym = #254;
  { �━〓� ����� 甎�瓷� ＜�� }
   TermSym = #255;

{ ---=== �����瑕 ! ===---- }
 Type
   TDictionary = Object
     F       : File; { �������� �ムガキ��� か� ��｀硅 ;) }
     Sym     : TSymbol; { �邃ム 皀�竕ィ� 瓱�〓�� }
     SymPos  : LongInt; { ��Ж罔� 瓱�〓�� }
     WordNum : LongInt; { ��甄� 甄�� � 甄���爛 }
    { - ����瘡 4-� ���皰〓�� 腮甄� � ���� - }
     Procedure WriteNum( N:LongInt );
    { - �皀�┘ 4-� ���皰〓�� 腮甄� ├ ����� - }
     Procedure ReadNum( Var N:LongInt );
    { - ����瘠���┘ 皀爼┃��讚��� 瓱�〓�� - }
     Procedure WriteTermSym;
    { - �腮硅���┘ 瓱�〓�� - }
     Procedure ReadSym;
    { - ����瘡 瓱�〓�� - }
     Procedure WriteSym;
    { - ��Г��┘ ��〓�� ����� 甄���瑙 - }
     Constructor New( FileName:String );
    { - �皖琺皋� 痺薀痰≪鉗ィ� ����� 甄���瑙 - }
     Constructor Open( FileName:String );
    { - ���琺皋� ����� - }
     Destructor Done;
    { - ���瓷 瓱�〓�� � 痰牀�� Sym := ｯ����┘ - }
     Procedure FindChar( _Char_:Char );
    { - ����←キ┘ 甄��� � 甄���瑕 - }
     Procedure Add( NewWord:String );
    { - ���瓷 甄��� � 甄���爛 - }
     Function Find( _Word_:String ):LongInt;
    { - ����キ┘ 甄��� ├ 甄���瑙 - }
     Procedure Del( _Word_:String );
   End;

Implementation


{ ---=== ����瘡 4-� ���皰〓�� 腮甄� � ���� ===--- }
 Procedure TDictionary.WriteNum( N:LongInt );
   Begin
     BlockWrite(F,N,SizeOf(N));
   End;

{ ---=== �皀�┘ 4-� ���皰〓�� 腮甄� ├ ����� ===--- }
 Procedure TDictionary.ReadNum( Var N:LongInt );
   Begin
     BlockRead(F,N,SizeOf(N));
   End;

{ ---=== ����瘠���┘ 皀爼┃��讚��� 瓱�〓�� ===--- }
 Procedure TDictionary.WriteTermSym;
   Begin
     Sym.Sym := TermSym;
     Sym.WRD := 0;
     Sym.Adr := 0;
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== �腮硅���┘ 瓱�〓�� ===--- }
 Procedure TDictionary.ReadSym;
   Begin
     Repeat
       SymPos:=FilePos(F);
       BlockRead(F,Sym,SizeOf(Sym));
       If Sym.Sym = ContSym then Seek(F,Sym.Adr);
     Until Sym.Sym <> ContSym;
   End;

{ ---=== ����瘡 瓱�〓�� ===--- }
 Procedure TDictionary.WriteSym;
   Begin
     SymPos:=FilePos(F);
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== ��Г��┘ ��〓�� ����� 甄���瑙 ===--- }
 Constructor TDictionary.New( FileName:String );
   Begin
     Assign(F,FileName);
     Rewrite(F,1);
     WordNum := 0;
     WriteNum(WordNum);
    { ��≡ガ - 甌≡ガ �モ ＜�� ;) }
     WriteTermSym;
   End;

{ ---=== �皖琺皋� 痺薀痰≪鉗ィ� ����� 甄���瑙 ===--- }
 Constructor TDictionary.Open( FileName:String );
   Begin
     Assign(F,FileName);
     Reset(F,1);
     ReadNum(WordNum);
   End;

{ ---=== ���琺皋� ����� 甄���瑙 ===--- }
 Destructor TDictionary.Done;
   Begin
     Seek(F,0);
     WriteNum(WordNum);
     Close(F);
   End;

{ ---=== ���瓷 瓱�〓�� � 痰牀�� Sym := ｯ����┘ ===--- }
 Procedure TDictionary.FindChar( _Char_:Char );
   Begin
     Repeat
       ReadSym;
     Until ((Sym.Sym = TermSym) Or (Sym.Sym = _Char_));
   End;

{ ---=== ����←キ┘ 甄��� � 甄���瑕 ===--- }
 Procedure TDictionary.Add( NewWord:String );
   Var I:Byte; Temp:LongInt; Flag:Boolean;
   Begin
     Inc(WordNum);
     Seek(F,SizeOf(LongInt));
    { �┴� �� ＜���� }
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

{ ---=== ���瓷 甄��� � 甄���爛 ===--- }
 Function TDictionary.Find( _Word_:String ):LongInt;
   Var I:Byte;
   Begin
     Seek(F,SizeOf(LongInt));
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { �甄� �� ���ぅ�� 甄�〓 ! (Sym.WRD:=0) }
         If Sym.Sym = TermSym then Break;
         Seek(F,Sym.Adr);
       End;
     Find := Sym.WRD;
   End;

{ ---=== ����キ┘ 甄��� ├ 甄���瑙 ===--- }
 Procedure TDictionary.Del( _Word_:String );
   Var I:Byte; Temp:TSymbol; PathAdr,TempAdr:LongInt;
   Begin
     Seek(F,SizeOf(LongInt));
     PathAdr:=SizeOf(LongInt);
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { �甄� �� ���ぅ�� 甄�〓 ! (Sym.WRD:=0) }
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