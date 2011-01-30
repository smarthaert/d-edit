uses crt;
type a=^b;
     b=record
     inf:integer;
     next:a;
     end;
var tek1,beg1,pred1:a; {1st list}

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

Function Insert(ai:a; li:a): a;
   begin
     ai^.next := nil;
     if li = nil then Insert := ai
     else
      if ai^.inf < li^.inf then
       begin
        ai^.next := li;
        Insert := ai;
       end
      else
       begin
        li^.next := Insert(ai, li^.next);
        Insert := li;
       end;
   end;



Begin
ClrScr;
Init(tek1,beg1,pred1);
tek1:=beg1;
Insert(tek1,tek1);
writeln;
WriteLn('Sortirovka');
writeln(' ');
Output(tek1);
readln;
End.
