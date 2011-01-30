function RevStr( S : String ):string;
var
  D : string;
  i : integer;
begin
  D := '';
  for i:=1 to Length(S) do begin
    writeln('D := "',S[i],'" + "',D,'"');
    D := S[i] + D;
    writeln('D = "',D,'"');
  end;
  RevStr := D;
end;

var S : string;
begin
  Readln(S);
  Writeln(S);
  Writeln(RevStr(S));
end.