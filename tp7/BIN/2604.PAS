 uses graph,crt;
 var a,b,c,fx,fy:integer;
     m1,m2,x,xk,y:real;
 begin
 writeln('vvedite x(0) and x(end)');
 readln(x,xk);
 clrscr;
 a:=detect;
 initgraph(a,b,'d:\9361');
 setlinestyle(0,4,2);
 line(getmaxx div 2,getmaxy div 2-250,getmaxx div 2,getmaxy div 2+250);
 line(getmaxx div 2-350,getmaxy div 2,getmaxx div 2+350,getmaxy div 2);
 m1:=(getmaxx div 2)/xk;
 m2:=(getmaxy div 2)/5;
 repeat
 y:=-sin(x);
 fy:=round(m2*y);
 fx:=round(m1*x);
 putpixel(getmaxx div 2+fx,getmaxy div 2+fy,15);
 x:=x+0.5;
 until x=xk;
 readln;
 end.
