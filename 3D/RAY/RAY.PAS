{$A+,B-,D-,E+,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S-,T+,V-,X+}
{$M 16384,0,85000}
uses crt,graph;
const
     ANGLE_0           =0;
     ANGLE_1           =5;
     ANGLE_2           =10;
     ANGLE_4           =20;
     ANGLE_5           =25;
     ANGLE_6           =30;
     ANGLE_15          =80;
     ANGLE_30          =160;
     ANGLE_45          =240;
     ANGLE_60          =320;
     ANGLE_90          =480;
     ANGLE_135         =720;
     ANGLE_180         =960;
     ANGLE_225         =1200;
     ANGLE_270         =1440;
     ANGLE_315         =1680;
     ANGLE_360         =1920;
     WORLD_ROWS        =16;
     WORLD_COLUMNS     =16;
     CELL_X_SIZE       =64;
     CELL_Y_SIZE       =64;
     CELL_X_SIZE_FP    =6;
     CELL_Y_SIZE_FP    =6;
     PCOLOR            =1;
     FCOLOR            =PCOLOR+8;
     RCOLOR            =14;
     OVERBOARD         =48;
     INTERSECTION_FOUND=1;
     WORLD_X_SIZE      =(WORLD_COLUMNS*CELL_X_SIZE);
     WORLD_Y_SIZE      =(WORLD_ROWS   *CELL_Y_SIZE);
type
    int=integer;
    long=longint;
    float=real;
    table=array[0..ANGLE_360] of float;
var
    tan_table,inv_tan_table,y_step,x_step,
    cos_table,inv_cos_table,inv_sin_table:^table;
    world:array[0..WORLD_ROWS-1,0..WORLD_COLUMNS-1] of byte;
{****************************************************************************}
procedure Build_Tables;
var
   ang:integer;
   rad_angle:float;
begin
     new(tan_table);
     new(inv_tan_table);
     new(y_step);
     new(x_step);
     new(cos_table);
     new(inv_cos_table);
     new(inv_sin_table);
     for ang:=ANGLE_0 to ANGLE_360 do begin
         rad_angle:=(3.272e-4)+ang*2*pi/ANGLE_360;
         tan_table^[ang]    := sin(rad_angle)/cos(rad_angle);
         inv_tan_table^[ang]:= 1/tan_table^[ang];
         if (ang>=ANGLE_0)and(ang<ANGLE_180) then
            y_step^[ang]:= abs(tan_table^[ang]*CELL_Y_SIZE)
         else
            y_step^[ang]:=-abs(tan_table^[ang]*CELL_Y_SIZE);
         if (ang>=ANGLE_90)and(ang<ANGLE_270) then
            x_step^[ang]:=-abs(inv_tan_table^[ang]*CELL_X_SIZE)
         else
            x_step^[ang]:= abs(inv_tan_table^[ang]*CELL_X_SIZE);
         inv_cos_table^[ang]:=1/cos(rad_angle);
         inv_sin_table^[ang]:=1/sin(rad_angle);
     end;
     for ang:=-ANGLE_30 to ANGLE_30 do begin
         rad_angle:=(3.272e-4)+ang*2*pi/ANGLE_360;
         cos_table^[ang+ANGLE_30]:=1/cos(rad_angle);
     end
end;
{****************************************************************************}
procedure Load_World(fname:string);
var
   fp:file of char;
   index,row,column:integer;
   ch:char;
begin
     assign(fp,fname);reset(fp);
     if ioresult<>0 then begin
        textmode(co80);
        writeln(#10#13'Can''t open map file',#7);
        halt(1)
     end;
     for row:=0 to WORLD_ROWS-1 do begin
         for column:=0 to WORLD_COLUMNS-1 do begin
             read(fp,ch);
             if ch=' ' then world[row,column]:=0
             else world[row,column]:=byte(ch)-byte('0');
         end;read(fp,ch);read(fp,ch)
     end;
     close(fp);
end;
{****************************************************************************}
procedure sline(x1,y1,x2,y2:integer;color:byte);
begin
     x1:=x1 shr 2;
     y1:=256-(y1 shr 2);
     x2:=x2 shr 2;
     y2:=256-(y2 shr 2);
     setcolor(color);
     line(x1,y1,x2,y2);
end;
{****************************************************************************}
procedure splot(x,y:integer;color:byte);
begin
     x:=x shr 2;
     y:=256-(y shr 2);
     putpixel(x,  y  ,color);
     putpixel(x+1,y  ,color);
     putpixel(x,  y+1,color);
     putpixel(x+1,y+1,color);
end;
{****************************************************************************}
procedure Draw_2D_Map;
var
   row,column,block,t,done:integer;
begin
     asm cli end;
     for row:=0 to WORLD_ROWS-1 do
         for column:=0 to WORLD_COLUMNS-1  do begin
             block:=world[row,column];
             if block=0 then begin
                setcolor(15);setfillstyle(1,0);
                bar(column*CELL_X_SIZE div 4,row*CELL_Y_SIZE div 4,
                    column*CELL_X_SIZE div 4+CELL_X_SIZE div 4-1,
                    row*CELL_Y_SIZE div 4+CELL_Y_SIZE div 4-1);
                rectangle(column*CELL_X_SIZE div 4,row*CELL_Y_SIZE div 4,
                    column*CELL_X_SIZE div 4+CELL_X_SIZE div 4-1,
                    row*CELL_Y_SIZE div 4+CELL_Y_SIZE div 4-1)
             end
             else begin
                  setcolor(PCOLOR);setfillstyle(1,PCOLOR);
                  bar(column*CELL_X_SIZE div 4,row*CELL_Y_SIZE div 4,
                      column*CELL_X_SIZE div 4+CELL_X_SIZE div 4-1,
                      row*CELL_Y_SIZE div 4+CELL_Y_SIZE div 4-1);
             end;
         end;
     asm sti end
end;
{****************************************************************************}
procedure Ray_Caster(x,y,view_angle:int);
var
   cell_x,cell_y,ray,casting,x_hit_type,y_hit_type,x_bound,y_bound,
   next_y_cell,next_x_cell,xray,yray,top,bottom,x_delta,y_delta,
   xb_save,yb_save,xi_save,yi_save,scale:int;
   dist_x,dist_y:long;
   xi,yi:float;
begin                                                                         {
// S E C T I O N  1 //////////////////////////////////////////////////////////}
     asm cli end;
     casting:=2;xray:=0;yray:=0;
     view_angle:=view_angle-ANGLE_30;
     if view_angle<0 then
        view_angle:=ANGLE_360+view_angle;
     for ray:=0 to 319 do begin                                               {
// S E C T I O N  2 //////////////////////////////////////////////////////////}
         if (view_angle>=ANGLE_0)and(view_angle<ANGLE_180) then begin
            y_bound:=CELL_Y_SIZE+(y and $FFC0);
            y_delta:=CELL_Y_SIZE;
            xi:=inv_tan_table^[view_angle]*(y_bound-y)+x;
            next_y_cell:=0
         end
         else begin
              y_bound:=y and $FFC0 ;
              y_delta:=-CELL_Y_SIZE;
              xi:=inv_tan_table^[view_angle]*(y_bound-y)+x;
              next_y_cell:=-1;
         end;                                                                {
// S E C T I O N  3 /////////////////////////////////////////////////////////}
         if (view_angle<ANGLE_90)or(view_angle>=ANGLE_270) then begin
            x_bound:=CELL_X_SIZE+(x and $FFC0);
            x_delta:=CELL_X_SIZE;
            yi:=tan_table^[view_angle]*(x_bound-x)+y;
            next_x_cell:=0;
         end
         else begin
              x_bound:=x and $FFC0;
              x_delta:=-CELL_X_SIZE;
              yi:=tan_table^[view_angle]*(x_bound-x)+y;
              next_x_cell:=-1;
         end;
         casting:=2;
         xray:=0;
         yray:=0;                                                            {
// S E C T I O N  4 /////////////////////////////////////////////////////////}
         while casting<>0 do begin
               if xray<>INTERSECTION_FOUND then begin
                  if y_step^[view_angle]=0 then begin
                     xray:=INTERSECTION_FOUND;
                     dec(casting);
                     dist_x:=trunc(1e+8);
                  end;
                  cell_x:=(x_bound+next_x_cell) shr CELL_X_SIZE_FP;
                  cell_y:=trunc(yi);{round}
                  cell_y:=cell_y shr CELL_Y_SIZE_FP;
                  x_hit_type:=world[(WORLD_ROWS-1)-cell_y,cell_x];
                  if x_hit_type<>0 then begin
                     dist_x :=trunc((yi-y)*inv_sin_table^[view_angle]);
                     yi_save:=round(yi);{round}
                     xb_save:=x_bound;
                     xray:=INTERSECTION_FOUND;
                     dec(casting)
                  end
                  else begin
                       yi:=yi+y_step^[view_angle];
                       x_bound:=x_bound+x_delta;
                  end
               end;                                                          {
// S E C T I O N  5 /////////////////////////////////////////////////////////}
               if yray<>INTERSECTION_FOUND then begin
                  if x_step^[view_angle]=0 then begin
                     yray:=INTERSECTION_FOUND;
                     dec(casting);
                     dist_y:=trunc(1e+8);
                  end;
                  cell_x:=trunc(xi);{round}
                  cell_x:=cell_x shr CELL_X_SIZE_FP;
                  cell_y:=(y_bound+next_y_cell) shr CELL_Y_SIZE_FP;
                  y_hit_type:=world[(WORLD_ROWS-1)-cell_y,cell_x];
                  if y_hit_type<>0 then begin
                     dist_y:=trunc((xi-x)*inv_cos_table^[view_angle]);
                     xi_save:=round(xi);{round}
                     yb_save:=y_bound;
                     yray:=INTERSECTION_FOUND;
                     dec(casting)
                  end
                  else begin
                       xi:=xi+x_step^[view_angle];
                       y_bound:=y_bound+y_delta
                  end
               end;
         end;                                                                {
// S E C T I O N  6 /////////////////////////////////////////////////////////}
         if dist_x<dist_y then begin
            sline(x,y,xb_save,yi_save,rcolor);
            scale:=trunc(cos_table^[ray]*15000/(1e-10+dist_x));
            top:=100-scale shr 1;
            if top<1 then top:=1;
            bottom:=top+scale;
            if bottom>200 then bottom:=200;
            if  yi_save mod CELL_Y_SIZE <= 1 then
                setcolor(15)
            else
                setcolor(FCOLOR);
            line(638-ray,top,638-ray,bottom);
         end
         else begin
               sline(x,y,xi_save,yb_save,rcolor);
               scale:=trunc(cos_table^[ray]*15000/(1e-10+dist_y));
               top:=100-scale shr 1;
               if top<1 then top:=1;
               bottom:=top+scale;
               if bottom>200 then bottom:=200;
               if xi_save mod CELL_X_SIZE <= 1 then
                  setcolor(15)
               else
                  setcolor(PCOLOR);
               line(638-ray,top,638-ray,bottom);
          end;                                                                {
// S E C T I O N  7 //////////////////////////////////////////////////////////}
         inc(view_angle);
         if view_angle>=ANGLE_360 then view_angle:=0;
     end;
     asm sti end
end;
{****************************************************************************}
var
   drv,mode,row,column,block,t,done:integer;
   x,y,view_angle,x_cell,y_cell,x_sub_cell,y_sub_cell:longint;
   dx,dy:float;
begin
     randomize;
     directvideo:=false;
     drv:=vga;mode:=vgahi;
     initgraph(drv,mode,'');
     Build_Tables;
     if paramcount>0
        then Load_World(paramstr(1))
        else Load_World('raymap.dat');
     Draw_2D_Map;
     gotoxy( 8,18);write('2-D Map View');
     gotoxy(54,16);write('3-D Projection');
     gotoxy(16,25);write('Use numeric keypad to move. Press Q to quit.');
     setcolor(15);rectangle(318,0,639,201);
     x:=1*64+25;y:=14*64+25;
     view_angle:=ANGLE_315;
     Ray_Caster(x,y,view_angle);
     repeat
           if keypressed then begin
              dx:=0;dy:=0;
              setcolor(0);setfillstyle(1,0);
              bar(319,1,638,200);
              setcolor(8);setfillstyle(1,8);
              bar(319,100,638,200);
              case readkey of
                   '6':begin
                            view_angle:=view_angle-ANGLE_6;
                            if view_angle<ANGLE_0 then
                               view_angle:=ANGLE_360;
                   end;
                   '4':begin
                            view_angle:=view_angle+ANGLE_6;
                            if view_angle>=ANGLE_360 then
                               view_angle:=ANGLE_0;
                   end;
                   '8':begin
                            dx:=cos(6.28*view_angle/ANGLE_360)*10;
                            dy:=sin(6.28*view_angle/ANGLE_360)*10;
                   end;
                   '2':begin
                            dx:=-cos(6.28*view_angle/ANGLE_360)*10;
                            dy:=-sin(6.28*view_angle/ANGLE_360)*10;
                   end;
                   'q': break
              end;
              x:=trunc(x+dx);
              y:=trunc(y+dy);
              x_cell:=x shr CELL_X_SIZE_FP;
              y_cell:=y shr CELL_Y_SIZE_FP;
              x_sub_cell:=x mod CELL_X_SIZE;
              y_sub_cell:=y mod CELL_Y_SIZE;
              if dx>0 then begin
                 if (world[(WORLD_ROWS-1)-y_cell,x_cell+1]<>0)and
                    (x_sub_cell>(CELL_X_SIZE-OVERBOARD)) then
                    x:=x-(x_sub_cell-(CELL_X_SIZE-OVERBOARD))
              end
              else begin
                  if (world[(WORLD_ROWS-1)-y_cell,x_cell-1]<>0)and
                     (x_sub_cell<OVERBOARD) then
                     x:=x+(OVERBOARD-x_sub_cell)
              end;
              if dy>0 then begin
                 if (world[(WORLD_ROWS-1)-(y_cell+1),x_cell]<>0)and
                    (y_sub_cell>(CELL_Y_SIZE-OVERBOARD)) then
                    y:=y-(y_sub_cell-(CELL_Y_SIZE-OVERBOARD))
              end
              else begin
                  if (world[(WORLD_ROWS-1)-(y_cell-1),x_cell]<>0)and
                     (y_sub_cell<(OVERBOARD)) then
                     y:=y+(OVERBOARD-y_sub_cell)
              end;
              Draw_2D_Map;
              Ray_Caster(x,y,view_angle);
              gotoxy(1,20);
              writeln('Position of player is (',x,',',y,')   ');
              writeln('View angle is ',round(360*view_angle/ANGLE_360),'  ');
              writeln('Current cell is (',x_cell,',',y_cell,')   ');
              writeln('Relative position within cell is (',
                       x_sub_cell,',',y_sub_cell,')  ');
              while keypressed do readkey
           end;
     until false;
     closegraph;
     dispose(tan_table);
     dispose(inv_tan_table);
     dispose(y_step);
     dispose(x_step);
     dispose(cos_table);
     dispose(inv_cos_table);
     dispose(inv_sin_table);
end.