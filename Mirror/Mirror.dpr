// Зеркалирование двух папок без выделенного главного каталога
// Т.е. изменения в одной папке реплицируются в другую, и наоборот
program Mirror;

uses
  Forms,
  SaveXMLU,
  Windows,
  SysUtils,
  history in 'history.pas';

{$R *.res}

function Path( _Path:string ):string;
begin
  Result := IncludeTrailingPathDelimiter(_Path);
end;

const
  HistoryFileName = 'history.xml';
  HistoryFileAttr = faHidden;

function SearchFile( FileName:string; FileList:IXMLFileTypeList ):IXMLFileType;
var i:integer;
begin
  Result := nil;
  for i:=0 to FileList.Count-1 do
    if UpperCase(FileList[i].Name) = UpperCase(FileName) then begin
      Result := FileList[i];
      exit;
    end;
end;

function SearchDir( DirName:string; DirList:IXMLDirTypeList ):IXMLDirType;
var i:integer;
begin
  Result := nil;
  for i:=0 to DirList.Count-1 do
    if UpperCase(DirList[i].Name) = UpperCase(DirName) then begin
      Result := DirList[i];
      exit;
    end;
end;

procedure FillNotExists( FileList:IXMLFileTypeList; DirList:IXMLDirTypeList );
var i:integer;
begin
  for i:=0 to FileList.Count-1 do
    FileList[i].Exists := false;
  for i:=0 to DirList.Count-1 do
    DirList[i].Exists := false;
end;

Procedure AddFile( thisFile:TSearchRec; FileList:IXMLFileTypeList );
var
  XFile : IXMLFileType;
begin
  XFile := SearchFile(thisFile.Name,FileList);
  if XFile = nil then begin
    XFile := FileList.Add;
    XFile.Name := thisFile.Name;
  end;
  XFile.Exists := true;
end;

Procedure AddDir( RootDirName:string; thisDir:TSearchRec; DirList:IXMLDirTypeList );
var
  XDir : IXMLDirType;
  sr : TSearchRec;
begin
  if thisDir.Name = '.' then exit;
  if thisDir.Name = '..' then exit;

  XDir := SearchDir(thisDir.Name,DirList);
  if XDir = nil then begin
    XDir := DirList.Add;
    XDir.Name := thisDir.Name;
  end;
  XDir.Exists := true;

  FillNotExists(XDir.File_,XDir.Dir);

  if FindFirst(RootDirName+'\'+thisDir.Name+'\*.*',faAnyFile, sr) = 0 then begin
    repeat
      if (sr.Attr and faDirectory) <> 0 then begin
        AddDir(RootDirName+'\'+thisDir.Name, sr, XDir.Dir);
      end else begin
        AddFile(sr, XDir.File_ );
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

// Каталог для зеркалирования
type
  MirrorDir = class
    History : IXMLRootType;
    HistoryFullFileName : string;
    DirName : string;
    constructor Create( DirName : string );
    procedure RewriteHistory;
    procedure RefreshHistory;
  end;

constructor MirrorDir.Create( DirName : string );
begin
  self.DirName := Path(DirName);
  HistoryFullFileName := self.DirName + HistoryFileName;
  // Если есть файл истории каталога => читаем его
  if FileExists(HistoryFileName) then begin
    History := Loadroot(HistoryFileName);
  end else begin
    History := Newroot;
    History.Name := self.DirName;
  end;
end;

procedure MirrorDir.RewriteHistory;
begin
  DeleteFile( HistoryFullFileName );
  SaveXML( HistoryFullFileName, History.XML );
  FileSetAttr( HistoryFullFileName, HistoryFileAttr );
end;

procedure MirrorDir.RefreshHistory;
var
  sr : TSearchRec;
begin
  FillNotExists(History.File_,History.Dir);
  if FindFirst(DirName+'*.*',faAnyFile, sr) = 0 then begin
    repeat
      if (sr.Attr and faDirectory) <> 0 then begin
        AddDir(DirName, sr, History.Dir);
      end else begin
        AddFile(sr, History.File_ );
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

var
  Mirror1, Mirror2 : MirrorDir;
begin
  Application.Initialize;
  Mirror1 := MirrorDir.Create('X:\scripts\Favorites');
  Mirror2 := MirrorDir.Create('D:\Favorites');
  // Обновляем файл истории
  Mirror1.RefreshHistory;
  Mirror1.RewriteHistory;
  Mirror2.RewriteHistory;
end.
