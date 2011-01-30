program DeleteOldFiles;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure DoDelete( DirPath:String; NumberOfDays:Integer );
var
  sr:TSearchRec;
  Path:String;
  FileTime,KillTime:TDateTime;
begin
  Path := IncludeTrailingPathDelimiter(ParamStr(1));
  Writeln('Path = ', Path);
  KillTime := Now - NumberOfDays;
  Writeln('KillTime = ', DateTimeToStr(KillTime));
  if FindFirst(Path + '*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      FileTime := FileDateToDateTime(sr.Time);
      if FileTime < KillTime then
        DeleteFile(Path + sr.Name);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

begin
  if ParamCount = 2 then begin
    DoDelete(ParamStr(1),StrToInt(ParamStr(2)));
  end else begin
    Writeln('Утилита для удаления старых файлов в заданном каталоге');
    Writeln('DeleteOldFiles <Каталог> <КоличествоДней>');
  end;
end.
