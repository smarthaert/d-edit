uses crt;
function generateChislo:integer;
var a:array [0..9] of boolean;
ch:integer;
s:string;
b:byte;
i:byte;
er:integer;
comp:integer;
igrok:integer;
n:integer;
begin
s:=' ';
fillchar(a,sezeof(a),false);
i:=0;
repeat
b:=random(10);
if not (a[b]) then if not ((i=0) and (b=0)) then
begin
a[b]:=true;
s:=s+chr(b+48);
inc(i);
end;
until i=4;
writeln(s);
val(s,ch,er);
generateChislo:=ch;
end;
begin
randomize;
writeln(generateChislo);
readln;
end;
begin
n:=0;
writeln('komputer "zadumal" chetyrehznachnoe chislo');
writeln('ugadajte ego');
writeln('vvedite chislo');
repeat
n:=n+1;
write('->'); readln(igrok);
until (comp=igrok);
if comp=igrok then writeln ('***VY VYJGRALI!*** za n shagov',n);
readln;
readln;
readln;
end.