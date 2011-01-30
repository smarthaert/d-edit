unit ULog;

interface

Const LogFileName = 'Sprite1.log';

procedure Log( S:String );

implementation

Uses SysUtils;

var LogFile : TextFile;

procedure Log( S:String );
Begin
  AssignFile(LogFile,LogFileName);
  Append(LogFile);
  Writeln(LogFile,S);
  Close(LogFile);
End;

Var TD : TDateTime;
begin
  AssignFile(LogFile,LogFileName);
  Rewrite(LogFile);
  TD := Now;
  Writeln(LogFile,DateTimeToStr(TD));
  Close(LogFile);
end.
