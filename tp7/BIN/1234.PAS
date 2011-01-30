program vst;
uses crt;
type elem=^rec;
           rec=record
                     inf:string;
                     adr:elem;
           end;
var first, tek,next,predfind,find:elem; a:char; i,srch:integer;
    begin
         clrscr;
         new(first);
         writeln('Insert inf string');
         readln(first^.inf);
         new(tek);
         first^.adr:=tek;
         for i:=1 to 5 do
             begin
                  writeln('Insert inf string');
                  readln(tek^.inf);
                  new(next);
                  tek^.adr:=next;
                  tek:=next;
             end;
         tek^.adr:=nil;
         tek:=first;
         for i:=1 to 5 do
             begin
             writeln(tek^.inf);
             tek:=tek^.adr;
             end;
             writeln('---------------------------');
             readkey;
          writeln('DELETE - insert number');
          readln(srch);
          tek:=first;
          i:=1;
          while (i<>srch-1) and (tek^.adr<>nil) do
                begin
                     tek:=tek^.adr;
                     inc(i);
                 end;


          predfind:=tek;
          find:=
          predfind^.adr:=predfind^.adr^.adr;
          p
          writeln('----------');
          writeln(find^.inf);
          readkey;
          end.






