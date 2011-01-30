{ * Удаление дерева каталогов * }
Uses DOS;

{$I-}
Procedure DelTree( DirName:String );
  Var DirInfo:SearchRec; F:File; Attr:Word;
  Begin
    ChDir(DirName);
    FindFirst('*.*',AnyFile,DirInfo);
    While DosError = 0 do
      Begin
        If ((DirInfo.Name <> '.') And
            (DirInfo.Name <> '..')) then
          Begin
            Assign(F,DirInfo.Name);
            GetFAttr(F,Attr);
            SetFAttr(F,(Attr And (VolumeID+Directory+Archive)));
            If (Attr And Directory)<>0 then
              DelTree(DirInfo.Name)
            Else
              Erase(F);
          End;
        FindNext(DirInfo);
      End;
    ChDir('..');
    RmDir(DirName);
  End;

Var S:String;
Begin
  If ParamCount = 1 then
    Begin
      GetDir(0,S);
      DelTree(ParamStr(1));
      ChDir(S);
    End
  Else
    Writeln('DELTREE <Имя каталога> - Удаление дерева каталогов');
End.
