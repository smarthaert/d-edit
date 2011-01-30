function EntInt : integer;
var
  Result,ErrCode : integer;
  S : string;
begin
  repeat
    write('Enter int: ');
    Readln(S);
    Val(S,Result,ErrCode);
  until ErrCode = 0;
  EntInt := Result;
end;

begin
  writeln('Result: ',EntInt);
end.
