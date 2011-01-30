{ษัออออออออออออออออออออออออออออออออออออออัป}
{บณ   "ฅไเ ฃฌฅญโ ๆจ๏" คฅเฅข  แโเฎช ;)   ณบ}
{ศฯออออออออออออออออออออออออออออออออออออออฯผ}

Uses WT_Lib;

{$I WT_MEM.PAS}

Var SrcF,DstF : TDictionary;

Procedure ReadSrc( Var VDir : PWTMem );
  Var Current : PWTMem;
  Begin
    VDir:=nil;
    Repeat
      SrcF.ReadSym;
      If SrcF.Sym.Sym <> TermSym then
        With SrcF.Sym do
          WTMemAddEnd(VDir,Sym,Adr,WRD,0,nil);
    Until SrcF.Sym.Sym = TermSym;
    Current := VDir;
    While Current <> nil do
      Begin
        If Current^.Adr<>0 then
          Begin
            Seek(SrcF.F,Current^.Adr);
            ReadSrc(Current^.Sub);
          End;
        Current := Current^.Next;
      End;
  End;

Procedure WriteDst( Var VDir : PWTMem );
  Begin
  End;

Var VDir : PWTMem;
Begin
  SrcF.Open('TEST.DIC');
  DstF.New('TEST_DEF.DIC');
  DstF.WordNum:=SrcF.WordNum;
  Seek(SrcF.F,SizeOf(LongInt));
  ReadSrc(VDir);
  Seek(DstF.F,SizeOf(LongInt));
  WriteDst(VDir);
  DstF.Done;
  SrcF.Done;
End.




