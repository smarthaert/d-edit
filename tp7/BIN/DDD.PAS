 var a,b,c,d,x1,x2:real;
 begin
     writeln('vvod a ');
     readln(a);
     writeln('vvod b ');
     readln(b);
     writeln('vvod c ');
     readln(c);
     d:=sqr(b)+4*a*c;
     if d<0 then
     writeln('net reshenia')
         else
         if d=0 then
         writeln('odin koren', (-b/2*a):0:4)
            else
            begin
            x1:=(-b+sqrt(d)/2*a);
            x2:=(-b-sqrt(d)/2*a);
            writeln('dva kornia',x1:0:4, x2:0:4);
            readln;
            end;
end.

                                                 ÿ