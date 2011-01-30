Program N100416;
 uses Graph, crt;
 var x, y, i, grMode, grDriver, r, x1, y1, vx, vy:integer;
begin
 grMode:=Detect;
 initGraph(grMode, grDriver, 'F:\');
 x:=GetMaxX;
 y:=GetMaxY;
 r:=x div 32;
 x1:=x div 2;
 y1:=y div 2;
   vx:=random(3) + 1;
   vy:=random(3) + 1;
 setTextStyle(GothicFont, 0, 20);
 outTextXY(x div 2, y div 7, 'Hello!!!');
 while(not keypressed) do begin
  if(i = 100) then begin
   vx:=random(3) + 1;
   vy:=random(3) + 1;
   i:=0;
  end;
  inc(i);
   circle(x1, y1, r);
   x1:=x1+vx;
   y1:=y1+vy;
   if(x1 < x div 4) or (x1 > x div 4 * 3) then begin
    vx:=-vx;
    x1:=x1+2*vx;
   end;
   if(y1 < y div 4) or (y1 > y div 4 * 3) then begin
    vy:=-vy;
    y1:=y1+2*vy;
   end;
   delay(2000);
   setFillStyle(1, 0);
   bar(x1 - r - 20, y1 - r - 20, x1 + r + 20, y1 + r + 20);
   setColor(15);
   rectangle(x div 4 - 20, y div 4 - 20, x div 4 * 3 + 20, y div 4 * 3 + 20);
 end;
 readln;
 closeGraph;
end.