uses crt;
type a=^b;
     b=record
     inf:integer;
     next:a;
     end;
var tek1,beg1,pred1:a;

Procedure Init( var tekI,begI,PredI:a );
var i,c,infa:integer;
begin
 writeln('vvedite kolichestvo elementov');
 readln(c);
  for i:=1 to c do
   begin
    writeln('vvedite element ',i);
    readln(infa);
     if  i=1 then
      begin
       new(tekI);
       tekI^.inf:=infa;
       tekI^.next:=nil;
       begI:=tekI;
       predI:=tekI;
      end
     else
      begin
       new(tekI);
       tekI^.inf:=infa;
       tekI^.next:=nil;
       predI^.next:=tekI;
       predI:=tekI;
      end;
   end;
end;

Procedure Output(tekO:a);
begin
  while tekO<> nil do
   begin
    write(tekO^.inf,'   ');
    tekO:=tekO^.next;
   end;
 writeln;
end;

Function Insert_sort(teks:a): a;
  Function Insert(teks2:a; teks:a): a;
   begin
     teks2^.next := nil;
     if teks = nil then Insert := teks2
     else
      if teks2^.inf < teks^.inf then
       begin
        teks2^.next := teks;
        Insert := teks2;
       end
      else
       begin
        teks^.next := Insert(teks2, teks^.next);
        Insert := teks;
       end;
   end;
begin
  if teks = nil then Insert_sort := nil
  else Insert_sort := Insert(teks, Insert_sort(teks^.next));
end;




Begin
ClrScr;
Init(tek1,beg1,pred1);
tek1:=beg1;
tek1:= Insert_Sort(tek1);
while tek1<>nil do begin
 if  tek1^.inf=tek1^.next^.inf then
 tek1^.next:=tek1^.next^.next;
 tek1:=tek1^.next
end;
writeln;
WriteLn('Spisok 1');
writeln(' ');
Output(tek1);
readln;
End.
