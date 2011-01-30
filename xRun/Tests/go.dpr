{$APPTYPE CONSOLE}

uses SysUtils,Windows;

var
  i : Integer;
  s : String;
begin
  for i:=1 to 9999 do begin
    s := IntToStr(i);
    while Length(s)<4 do S:='0'+S;
    if not FileExists(s+'\check.exe') then begin
      CopyFile(PChar('check.exe'),PChar(s+'\check.exe'),true);
    end;
  end;
end.