program graf;
uses crt, graph;
var i, a,b,x,y,x1,y1:integer;
begin
clrscr;
a:=detect;
initgraph(a,b,'d:\9361');
setlinestyle(0,1 ,3);
line(50,50,50,200);
line(50,200,200,200);
line(200,200,200,50);
line(200,50,50,50);
setfillstyle(1,green);
floodfill(100,100,white);
x:=100;
y:=100;
x1:=150;
y1:=150;
circle(x,y,20);
for i:=1 to 10 do
begin
setcolor(black);
circle(x1,y1,30);
circle(x,y,20);
x:=x+20;
y:=y+20;
x1:=x1+25;
end;

setcolor(white);
circle(x,y,20);
setfillstyle(
1,red);
floodfill(x,y,white);
circle(x1,y1,30);
setfillstyle(2,red);
floodfill(x1,y1,white);
readkey;
end.
