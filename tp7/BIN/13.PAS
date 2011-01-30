uses crt;
type a=^b;
     b=record
     inf1:string;
     inf:integer;
     next:a;
     end;
var tek,beg,pred:a;
    code,i,c:integer;
    s,s2:string;
    fl:text;
    ch:char;
begin
clrscr;
 assign(fl,'vvod.txt');
 reset(fl);
 i:=1;
 while not EOF(fl) do
 begin
 s:='';
 s2:='';
 while not EoLn(fl) do begin
 readln(fl,ch);
 if ch<>' ' then
 s:=s+ch
 else
 s2:=s2+ch;
  end;
 val(s2,c,code);
 if  i=1 then begin
 new(tek);
  tek^.inf1:=s;
  tek^.inf:=c;
tek^.next:=nil;
 beg:=tek;
 pred:=tek;
 i:=i+1;
 end
 else
 begin
 new(tek);
 tek^.inf1:=s;
 tek^.inf:=c;
 tek^.next:=nil;
 pred^.next:=tek;
 pred:=tek;
 end;
 end;
 tek:=beg;
 while tek<> nil do
 begin
 writeln(tek^.inf1,' ',tek^.inf);
 tek:=tek^.next;
 end;
 close(fl);
 readln;
 end.