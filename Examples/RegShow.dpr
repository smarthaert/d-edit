program RegShow;

{$APPTYPE CONSOLE}
uses
  SysUtils,
  Registry,
  Windows,
  Classes,
  Dialogs;

var
  key : String;
  subk: TStringList;
  i:Integer;
begin
  subK := TStringList.Create;
  key := 'SOFTWARE\Microsoft\Internet Explorer\AdvancedOptions\JAVA_SUN';
  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    if OpenKey(key,false) then begin
      GetValueNames(subk);
      for i:=0 to subk.count-1 do
        writeln('подключ ',i,'=',subk.strings[i],' ',ReadString(subk.strings[i]),' ',ValueExists(subk.strings[i]));
    end else
      ShowMessage('Ключ не открыт!');
    closekey;
  end;
  subk.free;
  Readln;
end.

