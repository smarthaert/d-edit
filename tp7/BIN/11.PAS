uses crt;
type a=^b;
     b=record
     inf:integer;
     next:a;
     end;
var tek,beg,pred:a;
    i,c,n,infa:integer;
begin
clrscr;
 writeln('vvedite kol-vo elementov');
 readln (n);
 for i:=1 to n do
 begin
 if i=1 then
 begin
 new(tek);
 writeln('vvedite element');
 readln (c);
 tek^.inf:=c;
 tek^.next:=nil;
 beg:=tek;
 pred:=tek;
 end
    else
     begin
 new(tek);
 writeln('vvedite element');
 readln (c);
 tek^.inf:=c;
 tek^.next:=nil;
 pred^.next:=tek;
 pred:=tek;
 end;
 end;
 tek:=beg;
 for i:=1 to n do
 begin
 writeln (tek^.inf);
 tek:=tek^.next;
 end;
  writeln('vvedite element dlya ydaleniya');
  readln (infa);
  tek:=beg;


 while (tek<>nil) and (tek^.inf <> infa)
 do begin
 tek:=tek^.next;
 pred:=tek;end;
 if tek^.inf=infa then begin
 pred^.next:=tek^.next;
 end;
  tek:=beg;
 for i:=1 to n do
 begin
 writeln (tek^.inf);
 tek:=tek^.next;
 end;
 readln;
 end.