unit FmxUtils;

interface

uses SysUtils, Windows, Classes, Consts;

type
  EInvalidDest = class(EStreamError);
  EFCantMove = class(EStreamError);

  TRunResult = Record
    _Answer : (_OK, _WA, _TL, _RE, _CE, _PE, _DQ);
    _ExitCode : LongBool;
  End;
procedure CopyFile(const FileName, DestName: string);
procedure MoveFile(const FileName, DestName: string);
function GetFileSize(const FileName: string): LongInt;
function FileDateTime(const FileName: string): TDateTime;
function HasAttr(const FileName: string; Attr: Word): Boolean;
function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
function Run(ExecuteFile, Directory, Parameters, Time_limit: String): TRunResult;
implementation

uses Forms, ShellAPI, RtlConsts;

const
  SInvalidDest = 'Destination %s does not exist';
  SFCantMove = 'Cannot move file %s';

procedure CopyFile(const FileName, DestName: string);
var
  CopyBuffer: Pointer; { buffer for copying }
  BytesCopied: Longint;
  Source, Dest: Integer; { handles }
  Len: Integer;
  Destination: TFileName; { holder for expanded destination name }
const
  ChunkSize: Longint = 8192; { copy in 8K chunks }
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
  if HasAttr(Destination, faDirectory) then { if destination is a directory... }
  begin
    Len :=  Length(Destination);
    if Destination[Len] = '\' then
      Destination := Destination + ExtractFileName(FileName) { ...clone file name }
    else
      Destination := Destination + '\' + ExtractFileName(FileName); { ...clone file name }
  end;
GetMem(CopyBuffer, ChunkSize); { allocate the buffer }
  try
    Source := FileOpen(FileName, fmShareDenyWrite); { open source file }
    if Source < 0 then raise EFOpenError.CreateFmt(SFOpenError, [FileName]);
    try
      Dest := FileCreate(Destination); { create output file; overwrite existing }
      if Dest < 0 then raise EFCreateError.CreateFmt(SFCreateError, [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize); { read chunk }
          if BytesCopied > 0 then { if we read anything... }
            FileWrite(Dest, CopyBuffer^, BytesCopied); { ...write chunk }
        until BytesCopied < ChunkSize; { until we run out of chunks }
      finally
        FileClose(Dest); { close the destination file }
      end;
    finally
      FileClose(Source); { close the source file }
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize); { free the buffer }
  end;
end;


{ MoveFile procedure }
{
  Moves the file passed in FileName to the directory specified in DestDir.
  Tries to just rename the file.  If that fails, try to copy the file and
  delete the original.

  Raises an exception if the source file is read-only, and therefore cannot
  be deleted/moved.
}

procedure MoveFile(const FileName, DestName: string);
var
  Destination: string;
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
  if not RenameFile(FileName, Destination) then { try just renaming }
  begin
    if HasAttr(FileName, faReadOnly) then  { if it's read-only... }
      raise EFCantMove.Create(Format(SFCantMove, [FileName])); { we wouldn't be able to delete it }
      CopyFile(FileName, Destination); { copy it over to destination...}
//      DeleteFile(FileName); { ...and delete the original }
  end;
end;

{ GetFileSize function }
{
  Returns the size of the named file without opening the file.  If the file
  doesn't exist, returns -1.
}

function GetFileSize(const FileName: string): LongInt;
var
  SearchRec: TSearchRec;
begin
  try
    if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
      Result := SearchRec.Size
    else Result := -1;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

function FileDateTime(const FileName: string): System.TDateTime;
begin
  Result := FileDateToDateTime(FileAge(FileName));
end;

function HasAttr(const FileName: string; Attr: Word): Boolean;
var
 FileAttr: Integer;
begin
  FileAttr := FileGetAttr(FileName);
  if FileAttr = -1 then FileAttr := 0;
  Result := (FileAttr and Attr) = Attr;
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;
Function Run(ExecuteFile, Directory, Parameters, Time_limit: String): TRunResult;

Var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  TimeLimit : Longint;
  Start : TDateTime;
  Answer : TRunResult;
begin
  Timelimit := StrToInt(Time_Limit);  // !!!!!!!!!!!!!
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do begin
   fMask := SEE_MASK_NOCLOSEPROCESS;
   Wnd := Application.Handle;
   lpFile := PChar(ExecuteFile);
   lpDirectory := PChar(Directory);
   lpParameters := PChar(Parameters);
    nShow := 0;  // SW_HIDE - 0;  SW_SHOW - 1
  end;
  if ShellExecuteEx(@SEInfo) then begin
    Start:= Time;
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess,ExitCode);
      If (100000*(Time-Start)>TimeLimit+0.5) and not (Application.Terminated) then
        Begin
          Application.Terminate;
          TerminateProcess(SEInfo.hProcess,ExitCode);
          Result._Answer:=_TL;
          Result._ExitCode:=GetExitCodeProcess(SEInfo.hProcess,ExitCode);
         // Writeln('Time Limit Exeed...');
        End;
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
  end;
  Result._Answer:=_OK;
  Result._ExitCode:=GetExitCodeProcess(SEInfo.hProcess,ExitCode);
 // Write('Work Time : ', 100000*(Time-Start) :0:2);
 // Readln;
End;

procedure Run_Vith_Params(ExecuteFile, Params : String);
Var
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
  TimeLimit : Longint;
  Start : TDateTime;
  Ans : TRunResult;
begin
  Timelimit := 2;  // !!!!!!!!!!!!!
  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  with SEInfo do begin
   fMask := SEE_MASK_NOCLOSEPROCESS;
   Wnd := Application.Handle;
   lpFile := PChar(ExecuteFile);
   lpParameters :=PChar(Params);
    nShow := 1;  // SW_HIDE - 0;  SW_SHOW - 1
  end;
  if ShellExecuteEx(@SEInfo) then begin
    Start:= Time;
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(SEInfo.hProcess,ExitCode);
      If (100000*(Time-Start)>TimeLimit+0.5) and not (Application.Terminated) then
        Begin
          Application.Terminate;
          TerminateProcess(SEInfo.hProcess,ExitCode);
         // Writeln('Time Limit Exeed...');
        End;
    until (ExitCode <> STILL_ACTIVE) or Application.Terminated;
  end;
 // Write('Work Time : ', 100000*(Time-Start) :0:2);
 //Readln;
End;

end.
