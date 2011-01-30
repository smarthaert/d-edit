Uses DOS,IOTools;
{ NewName - Переименовывает файлы в формате Cim_2.exe в Cim_0102.exe например :) }

Procedure NewName( UserID:String; LessonNum:Integer );
  Var DirInfo:SearchRec; F:File; Num:Integer; OldN,NewN:String;
  Begin
    FindFirst(UserID+'*.EXE',AnyFile,DirInfo);
    While DosError = 0 do
      Begin
        OldN := DirInfo.Name;
        Num := Str2Int( Copy(OldN,5,Pos('.',OldN)-5) );
        NewN := Copy(DirInfo.Name,1,4) +
                AddNumStr(LessonNum,'0',2) +
                AddNumStr(Num,'0',2) + '.EXE';
        Writeln( OldN,' -> ',NewN );
        Assign(F,OldN);
        Rename(F,NewN);
        FindNext(DirInfo);
      End;
  End;

Begin
  If ParamCount = 2 then
    NewName(ParamStr(1),Str2Int(ParamStr(2)))
  Else
    Begin
      Writeln('Renamer <UserID> <LessonNum>');
    End;
End.