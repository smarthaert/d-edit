program p2;
uses crt;
var a:boolean;
    x,  y: real;
begin
   clrscr;
   write('vvedite koordinati tochek :');
   readln(x,y);
   a:=(x*x+y*y<=1) and ((y>x+1)or(y<x-1) or (y>1-x) or (y<-x-1));
   writeln(a);
   readln
end.