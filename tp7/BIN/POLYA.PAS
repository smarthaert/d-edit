Program fyx;
uses crt;

type
  A=^B;
  B=record
  inf:string;
  adr:A;
  end;

  d=record
  tek,beg,pred:A;
  end;

var
 q:^d;
 i:integer;
 el:string;

begin
  new(q);
  new(q^.tek);
  writeln('vvedite informaciu');
  readln(q^.tek^.inf);
  q^.tek^.adr:=nil;
  q^.pred^.adr:=q^.tek;
  q^.pred:=q^.tek;
  q^.beg:=q^.tek;

  for i:=1 to 3 do
   begin
    new(q^.tek);
    writeln('vvod');
    readln(q^.tek^.inf);
    q^.tek^.adr:=nil;
    q^.pred^.adr:=q^.tek;
    q^.pred:=q^.tek;

   end;

   q^.tek:=q^.beg;
    while (q^.tek<>nil) do
     begin
     writeln(q^.tek^.inf);
     q^.tek:=q^.tek^.adr;
     end;
       readkey;
end.