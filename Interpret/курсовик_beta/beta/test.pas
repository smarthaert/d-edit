uses parslib,sysutils;
type
parser=object(TInterpreter)
procedure execute;virtual;
end;

procedure parser.execute;
begin
if (ident='fsgds') and (length(valparr)=1) then writeln('I lold',valparr[0]);
end;
var
teset:parser;
begin
teset.init;
teset.inputstr:='fsgds(1);fsgds(2);';
teset.executeall;
teset.done;
readln;
end.
