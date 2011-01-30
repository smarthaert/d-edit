program p2;
uses crt;
var a:boolean;
    x,  y, r, x2: real;
begin
   clrscr;
   write('vvedite koordinati tochek i radiys:');
   readln(x,y,r,x2);
   a:=(x*x+y*y<=r*r) and  (x<0 (y<) or (y>) ) ;

   writeln(a);
   readln
end.