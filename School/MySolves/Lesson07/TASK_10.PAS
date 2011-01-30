uses graph;
var gd,gm: integer;
procedure rec(x,y,x2,y2,x3,y3,n:integer);
  var xa,ya,xb,yb,xc,yc:integer;
begin
  if n>0 then begin
  {рисуем треугольник}
  line(x,y,x2,y2);
  line(x3,y3,x2,y2);
  line(x,y,x3,y3);
  {вычисляем середины сторон}
  xa:=(x+x2)div 2;ya:=(y+y2)div 2;
  xb:=(x3+x2)div 2;yb:=(y3+y2)div 2;
  xc:=(x+x3)div 2;yc:=(y+y3)div 2;
  {и рекурсивно рисуем 3 меньших треугольника}
  rec(x,y,xa,ya,xc,yc,n-1);
  rec(x2,y2,xa,ya,xb,yb,n-1);
  rec(x3,y3,xb,yb,xc,yc,n-1);
  end;
end;

Begin
gd:=VGA; gm:=VGAHI;
initgraph(gd,gm,'c:\bp\bgi');
rec(100,300,200,120,300,300,7);
readln;
closegraph;
End.