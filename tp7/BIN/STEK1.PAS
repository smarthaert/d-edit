program stek;
uses crt;
type a=^b;
    b=record
    inf:string;
    adr:a
    end;
var top,tek,beg:a;
    n,i,k:integer;
    label off;

begin
  writeln('1-dobavlenie elementa');
  writeln('2-ydalenie elementa');
  writeln('3-vihod');

  new(tek);
  writeln('vvod informacii');
  readln(tek^.inf);
  tek^.adr:=nil;
  beg:=tek; {nachalniy element}
  top:=tek;

 for i:=1 to 3 do
 begin
   new(tek);
   writeln('vvod informacii');
   readln(tek^.inf);

   tek^.adr:=top;
   top:=tek;
 end;
writeln('n-');
readln(n);

case n of
1:
begin
 writeln('skolko elementov sozd');
 readln(k);
 for i:=1 to k do
  begin
   new(tek);
   writeln('informaciu');
  readln(tek^.inf);
   tek^.adr:=top;
   top:=tek;
  end;
end;
2:
begin
 writeln('skolko ydalit');
 readln(k);
 for i:=1 to k do
  begin
   top:=top^.adr;

   dispose(tek);
  end;
end;
3:
begin
goto off;
end;
  end;
  tek:=top;
  while tek<>nil
  do
  begin
   writeln(tek^.inf);
   tek:=tek^.adr;
  end;
  readkey;
  off:
end.
