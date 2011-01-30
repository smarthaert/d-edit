program p1;
uses crt;
 var k, i:integer;
   begin
     clrscr;
     write('введите положительное число k=');
     readln(k);
     i:=0;
     if k=0 then
     i:=1 else
     begin
    while k>=1 do
      begin
        k:=k div 2;
        i:=i+1;
      end;
    end;
    writeln('результат');
    writeln(i);
    readkey;
   end.