{ �������������������������������������������������������������������ѻ }
{ ��                        Word Tree Library                        �� }
{ ��                      ---===#########===---                      �� }
{ ��    ���ᠭ�� �ଠ� 䠩�� ᫮����:                              �� }
{ �� 4 ���� - ����饥 ������⢮ ᫮� � 䠩��                       �� }
{ �� ��⠫�� - ���᮪ �㪢 ( �㪢� � ���� �� ��⪨ ), ������騩    �� }
{ ��  �த������� ᯨ᪠ � �ନ����� ᨬ��� ! )                   �� }
{ �������������������������������������������������������������������ϼ }
Unit WT_Lib;

Interface

{ ---=== ������� ᯨ᪠ �㪢 ===---- }
 Type
   TSymbol = Record
     Sym : Char; { ������ }
     WRD : LongInt; { H���� ᫮�� � ᫮��� ��� 0 �� ��� ������⢮����� }
     Adr : LongInt; { ���� � 䠩�� ��⪨ ��ॢ� }
   End;

 Const
  { ������ �த������� ( ࠧ�뢠 ) ᯨ᪠ }
   ContSym = #254;
  { ������ ���� ᯨ᪠ �㪢 }
   TermSym = #255;

{ ---=== ������� ! ===---- }
 Type
   TDictionary = Object
     F       : File; { �������� ��६����� ��� ࠡ��� ;) }
     Sym     : TSymbol; { ���� ⥪�饣� ᨬ���� }
     SymPos  : LongInt; { ������ ᨬ���� }
     WordNum : LongInt; { ��᫮ ᫮� � ᫮��� }
    { - ������ 4-� ���⮢��� �᫠ � 䠩� - }
     Procedure WriteNum( N:LongInt );
    { - �⥭�� 4-� ���⮢��� �᫠ �� 䠩�� - }
     Procedure ReadNum( Var N:LongInt );
    { - �����뢠��� �ନ���쭮�� ᨬ���� - }
     Procedure WriteTermSym;
    { - ���뢠��� ᨬ���� - }
     Procedure ReadSym;
    { - ������ ᨬ���� - }
     Procedure WriteSym;
    { - �������� ������ 䠩�� ᫮���� - }
     Constructor New( FileName:String );
    { - ����⨥ �������饣� 䠩�� ᫮���� - }
     Constructor Open( FileName:String );
    { - �����⨥ 䠩�� - }
     Destructor Done;
    { - ���� ᨬ���� � ��ப� Sym := ���ᠭ�� - }
     Procedure FindChar( _Char_:Char );
    { - ���������� ᫮�� � ᫮���� - }
     Procedure Add( NewWord:String );
    { - ���� ᫮�� � ᫮��� - }
     Function Find( _Word_:String ):LongInt;
    { - �������� ᫮�� �� ᫮���� - }
     Procedure Del( _Word_:String );
   End;

Implementation


{ ---=== ������ 4-� ���⮢��� �᫠ � 䠩� ===--- }
 Procedure TDictionary.WriteNum( N:LongInt );
   Begin
     BlockWrite(F,N,SizeOf(N));
   End;

{ ---=== �⥭�� 4-� ���⮢��� �᫠ �� 䠩�� ===--- }
 Procedure TDictionary.ReadNum( Var N:LongInt );
   Begin
     BlockRead(F,N,SizeOf(N));
   End;

{ ---=== �����뢠��� �ନ���쭮�� ᨬ���� ===--- }
 Procedure TDictionary.WriteTermSym;
   Begin
     Sym.Sym := TermSym;
     Sym.WRD := 0;
     Sym.Adr := 0;
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== ���뢠��� ᨬ���� ===--- }
 Procedure TDictionary.ReadSym;
   Begin
     Repeat
       SymPos:=FilePos(F);
       BlockRead(F,Sym,SizeOf(Sym));
       If Sym.Sym = ContSym then Seek(F,Sym.Adr);
     Until Sym.Sym <> ContSym;
   End;

{ ---=== ������ ᨬ���� ===--- }
 Procedure TDictionary.WriteSym;
   Begin
     SymPos:=FilePos(F);
     BlockWrite(F,Sym,SizeOf(Sym));
   End;

{ ---=== �������� ������ 䠩�� ᫮���� ===--- }
 Constructor TDictionary.New( FileName:String );
   Begin
     Assign(F,FileName);
     Rewrite(F,1);
     WordNum := 0;
     WriteNum(WordNum);
    { ���ᥬ - ᮢᥬ ��� �㪢 ;) }
     WriteTermSym;
   End;

{ ---=== ����⨥ �������饣� 䠩�� ᫮���� ===--- }
 Constructor TDictionary.Open( FileName:String );
   Begin
     Assign(F,FileName);
     Reset(F,1);
     ReadNum(WordNum);
   End;

{ ---=== �����⨥ 䠩�� ᫮���� ===--- }
 Destructor TDictionary.Done;
   Begin
     Seek(F,0);
     WriteNum(WordNum);
     Close(F);
   End;

{ ---=== ���� ᨬ���� � ��ப� Sym := ���ᠭ�� ===--- }
 Procedure TDictionary.FindChar( _Char_:Char );
   Begin
     Repeat
       ReadSym;
     Until ((Sym.Sym = TermSym) Or (Sym.Sym = _Char_));
   End;

{ ---=== ���������� ᫮�� � ᫮���� ===--- }
 Procedure TDictionary.Add( NewWord:String );
   Var I:Byte; Temp:LongInt; Flag:Boolean;
   Begin
     Inc(WordNum);
     Seek(F,SizeOf(LongInt));
    { ���� �� �㪢�� }
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

{ ---=== ���� ᫮�� � ᫮��� ===--- }
 Function TDictionary.Find( _Word_:String ):LongInt;
   Var I:Byte;
   Begin
     Seek(F,SizeOf(LongInt));
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { �᫨ �� ������� ᫮�� ! (Sym.WRD:=0) }
         If Sym.Sym = TermSym then Break;
         Seek(F,Sym.Adr);
       End;
     Find := Sym.WRD;
   End;

{ ---=== �������� ᫮�� �� ᫮���� ===--- }
 Procedure TDictionary.Del( _Word_:String );
   Var I:Byte; Temp:TSymbol; PathAdr,TempAdr:LongInt;
   Begin
     Seek(F,SizeOf(LongInt));
     PathAdr:=SizeOf(LongInt);
     For I:=1 to Length(_Word_) do
       Begin
         FindChar(_Word_[I]);
        { �᫨ �� ������� ᫮�� ! (Sym.WRD:=0) }
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