program spisok;
uses crt;
  type a=^b;
       b=record
         inf:integer;
         adr:a;
  end;
var beg, tek,pred:a;
    i,d,e,f:integer;
begin
 new(tek);
 writeln('vvedite informaciu:');
 readln(tek^.inf);
 tek^.adr:=nil;
 beg:=tek;
 pred:=tek;
  for i:=1 to 3 do
   begin
    new(tek);
    writeln('vvedite informaciu');
    readln(tek^.inf);
    tek^.adr:=nil;
    tek^.adr:=tek;
    pred:=tek;
   end;



while tek<>nil do
begin
if beg^.inf>tek^.inf
 then
  begin

   beg^.adr:=tek^.adr;

  end
else tek:=beg^.adr
  { tek:=beg;
   while(tek<>nil) do
   begin
   writeln(tek^.inf);
   tek:=tek^.adr;
   end;}
   readkey;
   end.
