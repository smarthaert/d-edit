program p1;
uses crt;
 var k, i:integer;
   begin
     clrscr;
     write('������ ������⥫쭮� �᫮ k=');
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
    writeln('१����');
    writeln(i);
    readkey;
   end.