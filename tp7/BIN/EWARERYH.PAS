program stack;
uses crt;
type a=^rec;
     rec=record
               inf:string;
               adr:a;
         end;
var el,pred,last:a; stackexist:boolean; key:char;

procedure stackexist_prc;
         begin
              stackexist:=false;
              new(pred);
              new(last);
              writeln('Заполните строку информации элемента');
              readln(pred^.inf);
              last:=pred;
              stackexist:=true;
         end;

procedure edit;
begin
     new (el);
     writeln('Заполните строку информации элемента');
     readln(el^.inf);
     pred^.adr:=el;
     pred:=el;
end;
    procedure show;
              begin
              el:=last;
              while el^.adr<>nil do
              begin
              writeln(el^.inf);
              el:=el^.adr;
              writeln(el^.inf);
              end;
              end;

     procedure outstack;
               begin
                    writeln(el^.inf);
                    dispose(el);
                    pred^.adr:=nil;
                    el:=pred;
               end;

begin
     clrscr;
     stackexist_prc;
     key:=' ';
     while (ord(key)<>27) do
           begin
           edit;
           writeln('Press any key (ESC) - exit');
           key:=readkey;
           end;
     el^.adr:=nil;
     show;
     writeln;
     outstack;
     show;
     writeln;

     readkey;
end.







