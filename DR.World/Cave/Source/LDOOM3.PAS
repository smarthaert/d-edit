PROGRAM LDOOM;
{$G+}

uses variable,pong2,thegraph,dos,pcx,crt,ctvoice;


(*---------------------- Procedure init_d_sound ----------------------------*)

PROCEDURE fade;

VAR counter:integer;
    facts:rgb_color_typ;
    done:boolean;

BEGIN
REPEAT
  FOR counter:=1 TO 255 DO
  BEGIN
    get_palette_register(counter,facts);
    IF facts.red-5<0 THEN facts.red:=0 ELSE facts.red:=facts.red-5;
    IF facts.blue-5<0 THEN facts.blue:=0 ELSE facts.blue:=facts.blue-5;
    IF facts.green-5<0 THEN facts.green:=0 ELSE facts.green:=facts.green-5;
    IF (facts.red=0) AND (facts.green=0) AND (facts.blue=0) THEN done:=true
    ELSE done:=false;
    set_palette_register(counter,facts);
  END;
  delay(75);
  UNTIL done;
END;

PROCEDURE init_sound;
BEGIN
  loadctdriver('ct-voice.drv');
  useport($220);
  useirq(5);
  usechannel(1);
  initializedriver;
END;

(*------------------- Procedure play_sound --------------------------------*)


PROCEDURE play_sound(sound:voctp);

VAR sample:voctp;

begin
  stopvprocess;
  sbioresult:=callok;
  if sbioresult=callok then begin
  if statusword=0 then playblock(sound);
  end;
end;


(*------------------PROCEDURE SEARCH-----------------------------------*)


PROCEDURE search(first:enemypointer; xer,yer:byte; var Last,Next:enemypointer);
BEGIN
  next:=first^.link;
  last:=first;
  while ((next^.enemy.xpos<>xer) OR (next^.enemy.ypos<>yer)) AND
        (next^.link<>nil) do
  begin
      last:=next;
      next:=next^.link
  end;
END;

PROCEDURE del_enemy(first:enemypointer; xer,yer:byte);

VAR last,next:enemypointer;

BEGIN
  next:=first^.link;
  if next<>nil THEN
  BEGIN
    search(first,xer,yer,last,next);
    if (next^.enemy.xpos=xer) AND (next^.enemy.ypos=yer) THEN
    BEGIN
      last^.link:=next^.link;
      dispose(next);
    END
  END;
END;

PROCEDURE add_enemy(VAR head:enemypointer; num,xer,yer:byte);

var newnode:enemypointer;

begin
  new(newnode);
  newnode^.enemy.xpos:=xer;
  newnode^.enemy.ypos:=yer;
  newnode^.enemy.curframe:=1;
  CASE num OF
   11:BEGIN
        newnode^.enemy.numhp:=3;
        newnode^.enemy.daminflict:=3
      END;
   12:BEGIN
        newnode^.enemy.numhp:=5;
        newnode^.enemy.daminflict:=6
      END;
   END;
newnode^.link:=head^.link;
head^.link:=newnode;
END;


(*----------------------- Procedure Load_World ---------------------------*)


PROCEDURE Load_World(worldfile:string);

VAR  infile:text;
     row,column,times:INTEGER;
     ch:char;
     temp:integer;
     res,ans:byte;

BEGIN
check_file(worldfile);
assign(infile,worldfile);
reset(infile);
for row:=0  TO WORLD_ROWS-1 DO
BEGIN
  for column:=1 TO WORLD_COLUMNS DO
  BEGIN
  ans:=0;
  FOR  times:=1 TO 2 DO
  BEGIN
    read(infile,ch);
    IF ch=' ' THEN res :=0
    ELSE
    val(ch,res,temp);
    IF times=1 THEN res:=res*10;
    ans:=ans+res
  END;
  IF ans>10 THEN add_enemy(enemylist,ans,column,world_rows-row);
    world[world_rows-row,column] := ans;
  END;
   readln(infile);
END;
close(infile);
END;


(*------------- Procedure Save_World ----------------------------*)
PROCEDURE Save_World(position:word);

VAR  infile:text;
     row,column:INTEGER;
     ch:char;
     res:byte;
     filename:string;

BEGIN
CASE position OF
1:filename:='Cave1.sav';
2:filename:='Cave2.sav';
3:filename:='Cave3.sav';
4:filename:='Cave4.sav';
5:filename:='Cave5.sav';
END;
assign(infile,filename);
rewrite(infile);
for row:=0  TO WORLD_ROWS-1 DO
BEGIN
  for column:=1 TO WORLD_COLUMNS DO
  BEGIN
    res:=world[world_rows-row,column];
    IF res=0 THEN ch:=' '
    ELSE
    BEGIN
    str(res,filename);
    ch:=filename[1];
    END;
    write(infile,ch);
  END;
   writeln(infile);
END;
close(infile);
END;

(*------------- Procedure Create_Scale_Data ---------------------*)



Procedure Create_Scale_Data(scale:INTEGER; VAR row:pcximage);

VAR  y,roff,rseg,temp:INTEGER;
      y_scale_index,y_scale_step:real;

BEGIN
y_scale_index:=0;
y_scale_step := 64/scale;
y_scale_index:=y_scale_index+y_scale_step;
roff:=ofs(row^); rseg:=seg(row^);
for y:=0 TO scale-1 DO
BEGIN
   temp:=TRUNC((y_scale_index+0.5)) * CELL_X_SIZE;
   move(temp,mem[rseg:roff+(y*2)],2);
  if  ( temp> 63*CELL_X_SIZE) THEN
  BEGIN
   temp := 63*CELL_X_SIZE;
   move(temp,mem[rseg:roff+(y*2)],2);
  END;
    y_scale_index:=y_scale_index+y_scale_step;
END
END;


(*---------------------- Procedure Build_Tables --------------------------*)


PROCEDURE Build_Tables;

VAR temp,rad_angle:real;
    scale:integer;
    ang:INTEGER;
BEGIN
check_mem(tan_table,6*angle_360);
check_mem(inv_tan_table,6*angle_360);
check_mem(y_step,6*angle_360);
check_mem(x_step,6*angle_360);
check_mem(cos_table,6*angle_360);
check_mem(inv_cos_table,6*angle_360);
check_mem(inv_sin_table,6*angle_360);
toff:=ofs(tan_table^); tseg:=seg(tan_table^);
ioff:=ofs(inv_tan_table^); iseg:=seg(inv_tan_table^);
yoff:=ofs(y_step^); yseg:=seg(y_step^);
xoff:=ofs(x_step^); xseg:=seg(x_step^);
icoff:=ofs(inv_cos_table^); icseg:=seg(inv_cos_table^);
isoff:=ofs(inv_sin_table^); isseg:=seg(inv_sin_table^);
coff:=ofs(cos_table^); cseg:=seg(cos_table^);
FOR ang:=ANGLE_0 TO ANGLE_360 DO
BEGIN
  rad_angle := ((3.72e-4)+ang*2*3.141592654/ANGLE_360);
  temp:=sin(rad_angle)/cos(rad_angle);
  move(temp,mem[tseg:toff+ang*6],6);
  temp:=1/temp;
  move(temp,mem[iseg:ioff+ang*6],6);
  if (ang>=ANGLE_0) AND (ang<ANGLE_180) THEN
  BEGIN
    move(mem[tseg:toff+ang*6],temp,6);
    temp:=ABS(temp*CELL_Y_SIZE);
    move(temp,mem[yseg:yoff+ang*6],6)
  END
    else
       BEGIN
         move(mem[tseg:toff+ang*6],temp,6);
         temp:=-(ABS(temp*CELL_Y_SIZE));
         move(temp,mem[yseg:yoff+ang*6],6)
       END;

    if (ang>=ANGLE_90) AND (ang<ANGLE_270) THEN
    BEGIN
      move(mem[iseg:ioff+ang*6],temp,6);
      temp:=-(ABS(temp*CELL_X_SIZE));
      move(temp,mem[xseg:xoff+ang*6],6)
    END
    else
    BEGIN
      move(mem[iseg:ioff+ang*6],temp,6);
      temp:=(ABS(temp*CELL_X_SIZE));
      move(temp,mem[xseg:xoff+ang*6],6)
    END;
    temp:=1/cos(rad_angle);
    move(temp,mem[icseg:icoff+ang*6],6);
    temp:=1/sin(rad_angle);
    move(temp,mem[isseg:isoff+ang*6],6);
END;
FOR ang:=-Angle_30 to Angle_30 DO
BEGIN
  rad_angle := ((3.72e-4)+ang*2*3.141592654/ANGLE_360);
  temp:=VERTICAL_SCALE/cos(rad_angle);
  move(temp,mem[cseg:coff+((ang +ANGLE_30)*6)],6);
END;
for scale:=1 TO MAX_SCALE DO
BEGIN
  check_mem(scales[scale],scale*2);
  create_scale_data(scale,scales[scale]);
END;
END;



(*---------------------- Procedure free_scale_data -------------------*)


PROCEDURE free_scale_data;

VAR y:INTEGER;

bEGIN
 FOR y:=1 TO MAX_SCALE DO
  freemem(scales[y],y*2);
END;


(*----------------------- Procedure Render_Sliver ------------------------*)


PROCEDURE fast_render;

VAR soff,sseg:word;

BEGIN
 soff:=ofs(sliver_texture^);
 sseg:=seg(sliver_texture^);
 asm
   push si
   push di
   mov di, doff
   mov dx,sliver_column
   mov si,soff
   mov bx,sliver_top
   shl bx,8
   mov ax,bx
   shr bx,2
   add bx,ax
   add bx,sliver_ray
   add di,bx
   mov bx,sliver_clip
   mov ax,sliver_scale
   add ax,bx
@Sliver_Loop:
      xchg dx,bx
      mov es,sseg
      mov cl, BYTE PTR es:[si+bx]
      mov es,dseg
      mov es:[di], cl
      xchg dx,bx
      mov cx,bx
      mov dx,scaleoff
      mov es,scaleseg
      shl bx,1
      add bx,dx
      mov dx, WORD PTR es:[bx]
      add dx,sliver_column
      mov bx,cx
      add di,320
      inc bx
      cmp bx, ax
      jne @Sliver_Loop
      pop di
      pop si
END;
END;

PROCEDURE fast_render_blit;

VAR soff,sseg,goff,gseg:word;

BEGIN
 soff:=ofs(sliver_texture^);
 sseg:=seg(sliver_texture^);
 asm
 jmp @start
@draw_it:
   mov es,dseg
   mov es:[di], cl
jmp @begins
@start:
   push si
   push di
   mov di, doff
   mov dx,sliver_column
   mov si,soff
   mov bx,sliver_top
   shl bx,8
   mov ax,bx
   shr bx,2
   add bx,ax
   add bx,sliver_ray
   add di,bx
   mov bx,sliver_clip
   mov ax,sliver_scale
   add ax,bx
@Sliver_Loop:
      xchg dx,bx
      mov es,sseg
      mov cl, BYTE PTR es:[si+bx]
      cmp cl,0
      jne @draw_it
  @begins:
      xchg dx,bx
      mov cx,bx
      mov dx,scaleoff
      mov es,scaleseg
      shl bx,1
      add bx,dx
      mov dx, WORD PTR es:[bx]
      add dx,sliver_column
      mov bx,cx
      add di,320
      inc bx
      cmp bx, ax
      jne @Sliver_Loop
      pop di
      pop si
END;
END;

PROCEDURE hit_guy(xer,yer:word);

VAR next,last:enemypointer;

BEGIN
  search(enemylist,xer,yer,next,last);
  bloodon:=true;
  IF sniper THEN last^.enemy.numhp:=0
  ELSE
  last^.enemy.numhp:=last^.enemy.numhp-1;
  IF last^.enemy.numhp=0 THEN
  BEGIN
    IF last^.enemy.daminflict=6 THEN gatesdead:=true;
    world[yer,xer]:=0;
    play_sound(ugh);
    del_enemy(enemylist,xer,yer);
  END;
END;

PROCEDURE move_guy(guyx,guyy,playerx,playery:word);

VAR moved:boolean;
    next,last:enemypointer;
BEGIN
  playerx:=playerx SHR 6;
  playery:=playery SHR 6;
  search(enemylist,guyx,guyy,next,last);
  moved:=false;
 { IF random(5)=3 THEN
  BEGIN
  IF (world[guyy,guyx-1]=0) AND (playerx<guyx) AND
  ((guyx-1<>playerx) OR (playery<>guyy)) THEN
  BEGIN
    moved:=true;
    world[guyy,guyx]:=0;
    world[guyy,guyx-1]:=11;
    last^.enemy.xpos:=guyx-1;
  END
  ELSE
  IF (world[guyy,guyx+1]=0) AND (playerx>guyx)
  AND ((guyx+1<>playerx) OR (playery<>guyy)) THEN
  BEGIN
    moved:=true;
    world[guyy,guyx]:=0;
    world[guyy,guyx+1]:=11;
    last^.enemy.xpos:=guyx+1;
  END
  ELSE
  IF (world[guyy-1,guyx]=0) AND (playery<guyy)
  AND ((guyy-1<>playery) OR (playerx<>guyx)) THEN
  BEGIN
    moved:=true;
    world[guyy,guyx]:=0;
    world[guyy-1,guyx]:=11;
    last^.enemy.ypos:=guyy-1;
  END
  ELSE
  IF (world[guyy+1,guyx]=0) AND (playery>guyy)
  AND ((guyy+1<>playery) OR (playerx<>guyx)) THEN
  BEGIN
    moved:=true;
    world[guyy,guyx]:=0;
    world[guyy+1,guyx]:=11;
    last^.enemy.ypos:=guyy+1;
  END;
  END;
  IF moved THEN }
  IF monster.cur_frame<3 THEN INC(monster.cur_frame)
  ELSE monster.cur_frame:=1;
  enmove:=true;
  IF (guyx+1=playerx)  OR (guyx-1=playerx) OR (guyy-1=playery)
  OR (guyy+1=playery) THEN
  IF (RANDOM(6)+1=3) THEN
  BEGIN
    monster.cur_frame:=4;
    IF not(touch) THEN life:=life-3
  END;
END;

PROCEDURE GUY_Caster(x,y,view_angle:LONGINT);

VAR
cell_x,cell_y,ray,casting,x_hit_type,y_hit_type,x_bound,y_bound,
next_y_cell,next_x_cell,xray,yray,x_delta,y_delta,xb_save,yb_save,
xi_save,yi_save,scale:INTEGER;
dist_x,dist_y:longint;
xi,yi,temp:REAL;

BEGIN
xray:=0;
yray:=0;
casting:=2;
view_angle:=view_angle-angle_30;
if (view_angle< 0) THEN view_angle:=ANGLE_360 + view_angle;
for ray:=319 downto 0 DO
BEGIN
  if (view_angle >= ANGLE_0) AND (view_angle < ANGLE_180) THEN
  BEGIN
    y_bound := (CELL_Y_SIZE + (y AND $ffc0));
    y_delta := CELL_Y_SIZE;
    move(mem[iseg:ioff+(view_angle*6)],temp,6);
    xi:=temp*(y_bound-y)+x;
    next_y_cell := 0;
  END
    else
    BEGIN
       y_bound := (y AND $ffc0);
       y_delta := -CELL_Y_SIZE;
       move(mem[iseg:ioff+(view_angle*6)],temp,6);
       xi := temp * (y_bound - y) + x;
       next_y_cell := -1;
    ENd;
   if (view_angle < ANGLE_90) OR (view_angle >= ANGLE_270)  THEN
   BEGIN
     x_bound := (CELL_X_SIZE + (x AND $ffc0));
     x_delta := CELL_X_SIZE;
     move(mem[tseg:toff+(view_angle*6)],temp,6);
     yi:=temp*(x_bound-x)+y;
     next_x_cell := 0;
   END
   else
   BEGIN
     x_bound := (x AND $ffc0);
     x_delta := -CELL_X_SIZE;
     move(mem[tseg:toff+(view_angle*6)],temp,6);
     yi := temp * (x_bound - x) + y;
     next_x_cell := -1;
   END;
 casting:= 2;
 xray:= 0;
 yray:=0;
 while casting>0 DO
 BEGIN
   if (xray<>INTERSECTION_FOUND) THEN
   BEGIN
   cell_x := ( (x_bound+next_x_cell) SHR CELL_X_SIZE_FP);
     cell_y := trunc(yi);
     cell_y:=cell_y SHR CELL_Y_SIZE_FP;
     x_hit_type:=world[cell_y,cell_x];
     if (x_hit_type>0) THEN
     BEGIN
        move(mem[isseg:isoff+(view_angle*6)],temp,6);
       dist_x  := round((yi - y) * temp);
       yi_save := trunc(yi);
       xb_save := x_bound;
       xray := INTERSECTION_FOUND;
       dec(casting);
    END
    else
    BEGIN
     move(mem[yseg:yoff+(view_angle*6)],temp,6);
      yi:=yi+temp;
      x_bound:=x_bound+x_delta;
    END;
  END;
  if (yray<>INTERSECTION_FOUND) THEN
  BEGIN
    cell_x :=trunc(xi);
    cell_x:=cell_x SHR CELL_X_SIZE_FP;
    cell_y := ( (y_bound + next_y_cell) SHR CELL_Y_SIZE_FP);
    y_hit_type := world[cell_y,cell_x];
    if (y_hit_type>0 ) THEN
    BEGIN
      move(mem[icseg:icoff+(view_angle*6)],temp,6);
      dist_y  := round((xi- x) * temp);
      xi_save := trunc(xi);
      yb_save := y_bound;
      yray := INTERSECTION_FOUND;
      dec(casting);
    END
     else
     BEGIN
        move(mem[xseg:xoff+(view_angle*6)],temp,6);
       xi :=xi+temp;
       y_bound :=y_bound+ y_delta;
     END;
  END;
END;
 if (dist_x < dist_y) AND ((x_hit_type>10) OR (y_hit_type>10)) THEN
 BEGIN
   move(mem[cseg:coff+(ray*6)],temp,6);
   scale := trunc((temp/dist_x));
   if (scale>(MAX_SCALE)) THEN scale:=(MAX_SCALE);
   scaleoff := ofs(scales[scale]^);
   scaleseg := seg(scales[scale]^);
   if (scale>WINDOW_HEIGHT) THEN
   BEGIN
     sliver_clip := (scale-WINDOW_HEIGHT) SHR 1;
     scale:=WINDOW_HEIGHT;
   END
   else
    sliver_clip := 0;
   sliver_scale   := scale;
   CASE x_hit_type OF
       11:sliver_texture:= monster.frames[monster.cur_frame];
       12:sliver_texture:=gates.frames[1];
       13:sliver_texture:=waldo.frames[1];
   END;
   sliver_column  := (yi_save AND $003f);
   sliver_top     := WINDOW_MIDDLE - (scale SHR 1);
   sliver_ray     := ray;
   IF (x_hit_type>10) AND
   (((player_view_angle>=720) AND (player_view_angle<=1200))
   OR ((player_view_angle>=1680) OR (player_view_angle<=240)))
   THEN fast_Render_blit;
  END
    else
    BEGIN
      move(mem[cseg:coff+(ray*6)],temp,6);
      scale := trunc((temp/dist_y));
       if (scale>(MAX_SCALE)) THEN scale:=(MAX_SCALE);
        scaleoff := ofs(scales[scale]^);
        scaleseg := seg(scales[scale]^);
       if (scale>WINDOW_HEIGHT) THEN
       BEGIN
         sliver_clip := (scale-WINDOW_HEIGHT) SHR 1;
          scale:=WINDOW_HEIGHT;
       END
      else
       sliver_clip := 0;
       sliver_scale:= scale;
       CASE y_hit_type OF
       11:sliver_texture:= monster.frames[monster.cur_frame];
       12:sliver_texture:=gates.frames[1];
       13:sliver_texture:=waldo.frames[1];
       END;
       sliver_column:= (xi_save AND $003f);
       sliver_top:= WINDOW_MIDDLE - (scale SHR 1);
       sliver_ray:= ray;
       IF (y_hit_type>10) AND
       ((player_view_angle>1200) AND (player_view_angle<1680)
       OR (player_view_angle>240) AND (player_view_angle<720))
       THEN fast_Render_blit;
    END;
    view_angle:=view_angle+1;
    if (view_angle>=ANGLE_360) THEN view_angle:=0;
  END;
END;

PROCEDURE Ray_Caster(x,y,view_angle:LONGINT);

VAR
cell_x,cell_y,ray,casting,x_hit_type,y_hit_type,x_bound,y_bound,
next_y_cell,next_x_cell,xray,yray,x_delta,y_delta,xb_save,yb_save,
xi_save,yi_save,scale:INTEGER;
dist_x,dist_y:longint;
xi,yi,temp:REAL;

BEGIN
xray:=0;
yray:=0;
casting:=2;
view_angle:=view_angle-angle_30;
if (view_angle< 0) THEN view_angle:=ANGLE_360 + view_angle;
for ray:=319 downto 0 DO
BEGIN
  if (view_angle >= ANGLE_0) AND (view_angle < ANGLE_180) THEN
  BEGIN
    y_bound := (CELL_Y_SIZE + (y AND $ffc0));
    y_delta := CELL_Y_SIZE;
    move(mem[iseg:ioff+(view_angle*6)],temp,6);
    xi:=temp*(y_bound-y)+x;
    next_y_cell := 0;
  END
    else
    BEGIN
       y_bound := (y AND $ffc0);
       y_delta := -CELL_Y_SIZE;
       move(mem[iseg:ioff+(view_angle*6)],temp,6);
       xi := temp * (y_bound - y) + x;
       next_y_cell := -1;
    ENd;
   if (view_angle < ANGLE_90) OR (view_angle >= ANGLE_270)  THEN
   BEGIN
     x_bound := (CELL_X_SIZE + (x AND $ffc0));
     x_delta := CELL_X_SIZE;
     move(mem[tseg:toff+(view_angle*6)],temp,6);
     yi:=temp*(x_bound-x)+y;
     next_x_cell := 0;
   END
   else
   BEGIN
     x_bound := (x AND $ffc0);
     x_delta := -CELL_X_SIZE;
     move(mem[tseg:toff+(view_angle*6)],temp,6);
     yi := temp * (x_bound - x) + y;
     next_x_cell := -1;
   END;
 casting:= 2;
 xray:= 0;
 yray:=0;
 while casting>0 DO
 BEGIN
   if (xray<>INTERSECTION_FOUND) THEN
   BEGIN
   cell_x := ( (x_bound+next_x_cell) SHR CELL_X_SIZE_FP);
     cell_y := trunc(yi);
     cell_y:=cell_y SHR CELL_Y_SIZE_FP;
     x_hit_type:=world[cell_y,cell_x];
     IF not(enmove) AND (x_hit_type=11) THEN move_guy(cell_x,cell_y,x,y);
     IF x_hit_type>10 THEN dg:=true;
     if (x_hit_type>0) AND (x_hit_type<11) THEN
     BEGIN
        move(mem[isseg:isoff+(view_angle*6)],temp,6);
       dist_x  := round((yi - y) * temp);
       yi_save := trunc(yi);
       xb_save := x_bound;
       xray := INTERSECTION_FOUND;
       DEC(casting);
    END
    else
    BEGIN
     move(mem[yseg:yoff+(view_angle*6)],temp,6);
      yi:=yi+temp;
      x_bound:=x_bound+x_delta;
    END;
  END;
  if (yray<>INTERSECTION_FOUND) THEN
  BEGIN
    cell_x :=trunc(xi);
    cell_x:=cell_x SHR CELL_X_SIZE_FP;
    cell_y := ( (y_bound + next_y_cell) SHR CELL_Y_SIZE_FP);
    y_hit_type := world[cell_y,cell_x];
    IF not(enmove) AND (y_hit_type=11) THEN move_guy(cell_x,cell_y,x,y);
    IF y_hit_type>10 THEN dg:=true;
    if (y_hit_type>0) AND (y_hit_type<11) THEN
    BEGIN
      move(mem[icseg:icoff+(view_angle*6)],temp,6);
      dist_y  := round((xi- x) * temp);
      xi_save := trunc(xi);
      yb_save := y_bound;
      yray := INTERSECTION_FOUND;
      DEC(casting);
    END
     else
     BEGIN
        move(mem[xseg:xoff+(view_angle*6)],temp,6);
       xi :=xi+temp;
       y_bound :=y_bound+ y_delta;
     END;
  END;
END;
 if (dist_x < dist_y) THEN
 BEGIN
   move(mem[cseg:coff+(ray*6)],temp,6);
   scale := trunc((temp/dist_x));
   if (scale>(MAX_SCALE)) THEN scale:=(MAX_SCALE);
   scaleoff := ofs(scales[scale]^);
   scaleseg := seg(scales[scale]^);
   if (scale>WINDOW_HEIGHT) THEN
   BEGIN
     sliver_clip := (scale-WINDOW_HEIGHT) SHR 1;
     scale:=WINDOW_HEIGHT;
   END
   else
    sliver_clip := 0;
   sliver_scale   := scale;
   sliver_texture:= sprite.frames[x_hit_type];
   sliver_column  := (yi_save AND $003f);
   sliver_top     := WINDOW_MIDDLE - (scale SHR 1);
   sliver_ray     := ray;
   fast_Render;
  END
    else
    BEGIN
      move(mem[cseg:coff+(ray*6)],temp,6);
      scale := trunc((temp/dist_y));
       if (scale>(MAX_SCALE)) THEN scale:=(MAX_SCALE);
        scaleoff := ofs(scales[scale]^);
        scaleseg := seg(scales[scale]^);
       if (scale>WINDOW_HEIGHT) THEN
       BEGIN
         sliver_clip := (scale-WINDOW_HEIGHT) SHR 1;
          scale:=WINDOW_HEIGHT;
       END
      else
         sliver_clip := 0;
       sliver_scale:= scale;
       sliver_texture:= sprite.frames[y_hit_type+1];
       sliver_column:= (xi_save AND $003f);
       sliver_top:= WINDOW_MIDDLE - (scale SHR 1);
       sliver_ray:= ray;
       fast_Render;
    END;
    view_angle:=view_angle+1;
    if (view_angle>=ANGLE_360) THEN view_angle:=0;
  END;
END;


(*------------------ Procedure Draw_ground -------------------------------*)



PROCEDURE Draw_Ground;
BEGIN
move(mem[seg(floor^):ofs(floor^)],
     mem[seg(double_buffer^):ofs(double_buffer^)],48640);
END;


(*--------------------- Function Get_Input ------------------------------*)

FUNCTION Get_Input:INTEGER;

VAR demo_data:char;

BEGIN
  if (key_table[0]<>0) OR (key_table[1]<>0) OR (key_table[2]<>0)
  OR (key_table[3]<>0) THEN
      get_input:=1
  else
      get_input:=0;
END;



(*------------------ Procedure New_Key_Int -------------------------------*)


PROCEDURE New_Key_Int;interrupt;

VAR temp1,temp2,temp3:word;
    test:string;
BEGIN
 asm
   sti                    {re-enable interrups }
   in al, KEY_BUFFER      {get the key that was pressed}
   xor ah,ah              {zero out upper 8 bits of AX}
   mov raw_key, ax        {store the key in global}
   in al, KEY_CONTROL     {set the control register}
   or al, 82h             {set the proper bits to reset the FF}
   out KEY_CONTROL,al     {send the new data back to the control register}
   and al,7fh
   out KEY_CONTROL,al     {complete the reset}
   mov al,20h
   out INT_CONTROL,al     {re-enable interrupts}
 end;
CASE raw_key OF
 MAKE_UP:key_table[INDEX_UP]:= 1;
 MAKE_DOWN:key_table[INDEX_DOWN]:=1;
 MAKE_RIGHT:key_table[INDEX_RIGHT]:=1;
 MAKE_LEFT:key_table[INDEX_LEFT]:=1;
 BREAK_UP:key_table[INDEX_UP]:=0;
 BREAK_DOWN:key_table[INDEX_DOWN]:=0;
 BREAK_RIGHT:key_table[INDEX_RIGHT]:=0;
 BREAK_LEFT:key_table[INDEX_LEFT]:=0;
 ELSE pressed:=true;
END;
 bloodon:=false;
 if (raw_key=1) THEN
 BEGIN
   done:=1;
 END
 ELSE
 if (raw_key=57)  THEN
 begin
   door_x := trunc(player_x + cos(6.28*player_view_angle/ANGLE_360)*6*15);
   door_y := trunc(player_y + sin(6.28*player_view_angle/ANGLE_360)*6*15);
   x_cell := (door_x DIV CELL_X_SIZE);
   y_cell := (door_y DIV CELL_Y_SIZE);
   IF ((x_cell=49) AND (y_cell=52)) OR ((x_cell=49) AND (y_cell=57)) OR
   ((x_cell=50) AND (y_cell=60)) THEN world[y_cell,x_cell]:=0;
   IF (x_cell=61) AND (y_cell=62) THEN
   BEGIN
     fade;
     cls;
     viewpcxfile('title.pcx');
     setintvec(KEYBOARD_INT, Old_Key_Isr); {Get Normal Keyboard Interrupt}
     blit_string(10,100,4,'YOU HAVE FOUND A WALDO',TRUE);
     blit_string(10,110,4,'BUT NOT THE ONE WITHOUT SHOES',TRUE);
     blit_string(10,120,4,'MAYBE HE''S ON THE NEXT LEVEL!!!',TRUE);
     blit_string(10,130,4,'PRESS ENTER TO CONTINUE',TRUE);
     REPEAT
     UNTIL keypressed;
     done:=1;
   END;
   IF (x_cell=58) AND (y_cell=62) THEN
   BEGIN
     IF gatesdead THEN world[y_cell,x_cell]:=0;
   END
   ELSE
   if (world[y_cell,x_cell] = 9) OR (world[y_cell,x_cell] = 10) THEN
   world[y_cell,x_cell]:=0;
   IF world[y_cell,x_cell]>10 THEN hit_guy(x_cell,y_cell);
   hand.cur_frame:=2;
   hancount:=0;
  end;
  gettime(temp1,temp2,newtime,temp3);
 IF newtime-lasttime>1 THEN BEGIN lasttime:=newtime; code:='' END;
 IF (pressed) AND (raw_key=19) THEN
 IF step_length=50 THEN step_length:=30 ELSE step_length:=50;
 IF pressed AND (raw_char(raw_key)>'0') THEN
 BEGIN
   pressed:=false;
   gettime(temp1,temp2,newtime,temp3);
   lasttime:=newtime;
   insert(raw_char(raw_key),code,length(code)+1);;
 END;
END;



(*----------------- Procedure do_code -------------------------------------*)



Procedure do_code;

VAR temp1,temp2,temp3:word;

BEGIN
  IF code='canttouchthis' THEN
        BEGIN
          code:='';
          touch:=not(touch);
          gettime(temp1,temp2,lasttime,temp3);
        END;
        IF code='pong' THEN
        BEGIN
          code:='';
          pong_main;
          dseg:=seg(double_buffer^);            {Get segment of buffer}
          doff:=ofs(double_buffer^);
          viewpcxfile('panel.pcx');
        END;
        IF code='rambo' THEN
        BEGIN
          code:='';
          rambo:=not(rambo);
          gettime(temp1,temp2,lasttime,temp3);
       END;
         IF code='lizard' THEN
        BEGIN
          code:='';
          lizard:=not(lizard);
          gettime(temp1,temp2,lasttime,temp3);
        END;
        IF code='sniper' THEN
        BEGIN
          code:='';
          sniper:=not(sniper);
          gettime(temp1,temp2,lasttime,temp3);
       END;
       IF rambo THEN blit_string_d(70,10,10,'UNLIMITED AMMO');
       IF touch THEN blit_string_d(70,20,10,'INVINCIBLE');
       IF sniper THEN blit_string_d(70,30,10,'ONE-HIT KILLS');
       IF lizard THEN
       BEGIN
         IF life<100 THEN life:=life+1;
         blit_string_d(70,40,10,'REGENERATION');
       END;
END;


(*-------------------- Proedure do_map ------------------------------------*)


Procedure do_map(VAR x,y:INTEGER);

VAR c1,c2:INTEGER;

BEGIN
  FOR c1:=-20 TO 19 DO
  FOR c2:=-19 TO 20 DO
    IF (c1+y<65) AND (c1+y>0) AND (c2+x>0) AND (c2+x<65) THEN
    BEGIN
    IF world[c1+y,c2+x]>8 THEN plot_pixel_fast(269+c1,175+c2,3)
    ELSE IF world[c1+y,c2+x]>0 THEN plot_pixel_fast(269+c1,175+c2,4)
    ELSE plot_pixel_fast(269+c1,175+c2,0);
    END
    ELSE plot_pixel_fast(269+c1,175+c2,0);
    plot_pixel_fast(269,175,10);
END;



(*---------------------- Procedure Global_Init --------------------------*)



PROCEDURE global_init;

VAR spriteim:pcximage;

BEGIN
check_mem(spriteim,64000);
loadpcxfile('waldo.pcx',spriteim);
Sprite_Init(waldo,0,0,0,0,0,0,64,64);
Get_sprite(spriteim,waldo,1,0,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('gates.pcx',spriteim);
Sprite_Init(gates,0,0,0,0,0,0,64,64);
Get_sprite(spriteim,gates,1,0,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('monster.pcx',spriteim);
Sprite_Init(monster,0,0,0,0,0,0,64,64);
Get_sprite(spriteim,monster,1,0,0);
Get_sprite(spriteim,monster,2,1,0);
Get_sprite(spriteim,monster,3,2,0);
Get_sprite(spriteim,monster,4,3,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('wall3.pcx',spriteim);
Sprite_Init(sprite,0,0,0,0,0,0,64,64);
Get_sprite(spriteim,sprite,1,0,0);
Get_sprite(spriteim,sprite,2,1,0);
Get_sprite(spriteim,sprite,3,2,0);
Get_sprite(spriteim,sprite,4,3,0);
Get_sprite(spriteim,sprite,5,0,1);
Get_sprite(spriteim,sprite,6,1,1);
Get_sprite(spriteim,sprite,7,2,1);
Get_sprite(spriteim,sprite,8,3,1);
Get_sprite(spriteim,sprite,9,0,2);
Get_sprite(spriteim,sprite,10,1,2);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('light.pcx',spriteim);
Sprite_Init(light,0,0,0,0,0,0,50,45);
Get_sprite(spriteim,light,1,0,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('blood.pcx',spriteim);
Sprite_Init(blood,110,40,0,0,0,0,64,64);
Get_sprite(spriteim,blood,1,0,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('dagger.pcx',spriteim);
sprite_init(hand,150,55,0,0,0,0,108,101);
get_sprite(spriteim,hand,1,0,0);
get_sprite(spriteim,hand,2,1,0);
freemem(spriteim,64000);
check_mem(spriteim,64000);
loadpcxfile('arrow.pcx',spriteim);
Sprite_Init(arrow,78,170,0,0,0,0,13,13);
Get_sprite_coord(spriteim,arrow,1,0,0);
Get_sprite_coord(spriteim,arrow,2,14,0);
Get_sprite_coord(spriteim,arrow,3,28,0);
Get_sprite_coord(spriteim,arrow,4,41,0);
freemem(spriteim,64000);
check_mem(floor,64000);
loadpcxfile('back.pcx',floor);
Load_World('level1.dat');
life:=100;
step_length:=30;
pressed:=false;
loadvocfile('light.voc',lights);
loadvocfile('ugh.voc',ugh);
viewpcxfile('panel.pcx');
sprite.cur_frame := 1;
sprite.x          := 0;
sprite.y          := 0;
player_x:=53*64+25;
player_y:=14*64+25;
player_view_angle:=ANGLE_60;
code:='';
rambo:=false;
touch:=false;
lizard:=false;
sniper:=false;
lcounter:=20;
lx:=RANDOM(320);
light.y:=1;
behind_sprite_VB(arrow);
gatesdead:=false;
enmove:=false;
END;


PROCEDURE do_light;
BEGIN
  IF lcounter=0 THEN
  BEGIN
    lx:=RANDOM(320);
    lcounter:=40;
  END;
  IF lcounter=4 THEN
  play_sound(lights);
  IF lcounter<4 THEN
  BEGIN
    light.x:=lx;
    draw_sprite_f(light)
  END;
  lcounter:=lcounter-1;
END;


(*---------------- PROCEDURE MAIN --------------------------------------*)



PROCEDURE main;

VAR x_sub_cell,y_sub_cell:INTEGER;
    holder,dx,dy:real;
    test:string;

BEGIN
global_init;
Draw_Ground;
Ray_Caster(player_x,player_y,player_view_angle);
show_double_buffer_h;
setintvec(KEYBOARD_INT, ADDR(New_Key_Int));
while done<>1 DO
BEGIN
  if Get_Input=1 THEN
  begin
    dx:=0; dy:=0;
    if (key_table[INDEX_RIGHT]=1) THEN
    BEGIN
      player_view_angle:=player_view_angle-ANGLE_6;
      if (player_view_angle<ANGLE_0) THEN
          player_view_angle:=ANGLE_360;
    END
        else
        if (key_table[INDEX_LEFT]=1) THEN
        BEGIN
          player_view_angle:=player_view_angle+angle_6;
           if (player_view_angle>=ANGLE_360) THEN
              player_view_angle:=ANGLE_0;
        END;
        holder:=6.28*player_view_angle/ANGLE_360;
        if (key_table[INDEX_UP]=1) THEN
        BEGIN
           dx:=(cos(holder)*STEP_LENGTH);
           dy:=(sin(holder)*STEP_LENGTH);
        END
        else
        if (key_table[INDEX_DOWN]=1) THEN
        BEGIN
           dx:=(-cos(holder)*STEP_LENGTH);
           dy:=(-sin(holder)*STEP_LENGTH);
        END;
        player_x:= trunc((player_x+dx));
        player_y:= trunc((player_y+dy));
        x_cell := (player_x DIV CELL_X_SIZE);
        y_cell := (player_y DIV CELL_Y_SIZE);
        x_sub_cell := player_x MOD CELL_X_SIZE;
        y_sub_cell := player_y MOD CELL_Y_SIZE;
        if dx>0 THEN
        BEGIN
           if ( (world[y_cell,x_cell+1] <> 0) AND
                (x_sub_cell > (CELL_X_SIZE-OVERBOARD)))
            THEN
            BEGIN
                player_x:=player_x-(x_sub_cell-(CELL_X_SIZE-OVERBOARD ));
            END;
        END
        else
          BEGIN
            if ( (world[y_cell,x_cell-1] <> 0) AND
                (x_sub_cell < (OVERBOARD) ) )  THEN
            BEGIN
              player_x:=player_x+ (OVERBOARD-x_sub_cell) ;
            END;
          END;
        if (dy>0 ) THEN
           BEGIN
           if ( (world[y_cell+1,x_cell] <> 0)  AND
                (y_sub_cell > (CELL_Y_SIZE-OVERBOARD))) THEN
                BEGIN
                player_y:=player_y-(y_sub_cell-(CELL_Y_SIZE-OVERBOARD ));
           END;
        END
        else
          BEGIN
           if ( (world[y_cell-1,x_cell] <> 0) AND
                (y_sub_cell < (OVERBOARD) ) )  THEN
             BEGIN
                player_y:= player_y+(OVERBOARD-y_sub_cell);
            END
         end;
        end;
        Draw_Ground;
        do_light;
        dg:=false;
        Ray_Caster(player_x,player_y,player_view_angle);
        IF dg THEN Guy_CASTER(player_x,player_y,player_view_angle);
        IF bloodon THEN draw_sprite(blood);
        do_code;
        x_cell := (player_x DIV CELL_X_SIZE);
        y_cell := (player_y DIV CELL_Y_SIZE);
       do_map(x_cell,y_cell);
       IF ((player_view_angle<=240) OR (player_view_angle>=1680))
          AND (arrow.cur_frame<>1)  THEN
       BEGIN
         erase_sprite_VB(arrow);
         arrow.cur_frame:=1;
         behind_sprite_VB(arrow);
         draw_sprite_VBF(arrow);
       END;
       IF (player_view_angle>=720) AND (player_view_angle<=1200)
          AND (arrow.cur_frame<>2) THEN
       BEGIN
         erase_sprite_VB(arrow);
         arrow.cur_frame:=2;
         behind_sprite_VB(arrow);
         draw_sprite_VBF(arrow);
       END;
       IF (player_view_angle>240) AND (player_view_angle<720)
          AND (arrow.cur_frame<>3) THEN
       BEGIN
         erase_sprite_VB(arrow);
         arrow.cur_frame:=3;
         behind_sprite_VB(arrow);
         draw_sprite_VBF(arrow);
       END;
       IF (player_view_angle>1200) AND (player_view_angle<1680)
          AND (arrow.cur_frame<>4) THEN
       BEGIN
         erase_sprite_VB(arrow);
         arrow.cur_frame:=4;
         behind_sprite_VB(arrow);
         draw_sprite_VBF(arrow);
       END;
       IF (life<1) OR (life>100) THEN done:=1;
        str(life:3,test);
        test:=test+'%';
       IF step_length=30 THEN  blit_string_d(200,10,10,'Run Mode Off')
       ELSE   blit_string_d(200,10,10,'Run Mode On');
       IF (life>0) AND (life<=100) THEN blit_string(9,173,4,test,false);
       IF hand.cur_frame=2 THEN hancount:=hancount+1;
       IF hancount=3 THEN hand.cur_frame:=1;
       draw_sprite_f(hand);
       show_double_buffer_h;
       enmove:=false;
END;
fade;
free_scale_data;
setintvec(KEYBOARD_INT, Old_Key_Isr);
freemem(tan_table,6*angle_360);
freemem(inv_tan_table,6*angle_360);
freemem(y_step,6*angle_360);
freemem(x_step,6*angle_360);
freemem(cos_table,6*angle_360);
freemem(inv_cos_table,6*angle_360);
freemem(inv_sin_table,6*angle_360);
textmode(3);
END;


(*-------------------- Proceudre Opening --------------------------------*)

PROCEDURE opening;

VAR counter:INTEGER;
    holder:char;

BEGIN
  clrscr;
  Randomize;
  textcolor(white);
  textbackground(blue);
  gotoxy(1,1);
  write('           Cave Dweller-     Beta v',RANDOM(9),'.',RANDOM(9));
  write(RANDOM(9),RANDOM(9),RANDOM(9),RANDOM(9),RANDOM(9),
        RANDOM(9),'                                    ');
  textbackground(black);
  gotoxy(1,4);
  writeln('Memory Required: 320000');
  writeln('Memory Available: ',Memavail);
  IF memavail<320000 THEN errors(1);
  write('Initializing Black Dog Dos Protected Mode Runtime Interface .');
  build_tables;
  counter:=1;
  REPEAT
    delay(300);
    write('.');
    INC(counter);
  UNTIL counter=10;
  writeln;
  writeln('.....Uhh Sorry Can''t Initialize It, It''s Protected.');
  writeln('Initializing Cave Dweller Refresh Daemon [............]');
  writeln('By The Way, What Exactly Is A Refresh Daemon?????');
  writeln;
  writeln;
  write('Press Any Key To Continue.');
  Repeat Until Keypressed;

  holder:=readkey;
  init256graph;
END;


(*------------------ Procedure Blit_Char_DB ------------------------------*)


PROCEDURE Blit_Char_DB(xc,yc:INTEGER; c:char; color:INTEGER);

VAR offset,x,y,doff,dseg:INTEGER;
    work_char:byte;
    bit_mask:byte;

BEGIN
doff:=ofs(double_buffer^);
dseg:=seg(double_buffer^);
work_char:=mem[$f000:$fa6e+ (ord(c) * char_height-1)];
offset := (yc SHL 8) + (yc SHL 6) + xc;
for y:=0 to CHAR_HEIGHT-1 DO
BEGIN
  bit_mask:=$80;
  for x:=0 to CHAR_WIDTH-1 DO
  BEGIN
    if (work_char AND bit_mask)<>0 THEN
    mem[dseg:doff+offset+x]:=color;
    bit_mask:=(bit_mask SHR 1);
  END;
  offset := offset + SCREEN_WIDTH;
  work_char:=mem[$f000:$fa6e+ (ord(c) * char_height)+y];
END;
END;


(*------------------ Procedure Blit_String_DB ------------------------------*)


PROCEDURE Blit_String_DB(x,y,color:INTEGER; word:string);

VAR index:integer;

BEGIN
  FOR index:=1 TO length(word) DO
  BEGIN
    Blit_Char_DB(x+(index SHL 3),y,word[index],color);
  END;
END;


(*----------------------- Procedure Build_Path --------------------------*)


procedure buildpath;
   var
      count     : byte;
      currangle : real;
   begin
      currangle := pi;
      for count := 0 to 199 do
         begin
            path[count] := 320 + round(radius*sin(currangle));

            { the sin path _must_ lie on an even number }
            { otherwise the picture will be garbage     }

            if path[count] mod 2 <> 0 then
               if path[count] > 320 then
                  dec(path[count])            { round down }
               else
                  inc(path[count]);           { round up   }

            { the path is rounded to the closest even number to 320 }

            currangle := currangle + angleinc;
         end;
   end;


(*--------------------- Procedure Main_Menu ----------------------------*)


Procedure main_menu;

VAR choice,color,lchoice:byte;
    get:char;
    temp:rgb_color_typ;
begin
  setintvec(KEYBOARD_INT, Old_Key_Isr); {Get Normal Keyboard Interrupt}
  init_double_buffer;                   {Initialize Off Screen Buffer}
  dseg:=seg(double_buffer^);            {Get segment of buffer}
  doff:=ofs(double_buffer^);            {Get offset of buffer}
  check_mem(pcxim,64000);      {Check Memory, Available: Allocate; Not: Error}
  loadpcxfile('main.pcx',pcxim); {Load pcx file into pcxim}
  Sprite_Init(menu,31,8,0,0,0,0,263,26);{Initialize width and posistion}
  Get_sprite_coord(pcxim,menu,1,32,8);  {Grab sprite from pcxim}
  freemem(pcxim,64000);                 {Give back memory}
  randomize;
  buildpath;
  choice:=1;                            {initialize menu choice to first one}
  asm
     xor   ax,ax               { ; AX := 0                              }
     mov   cx,768              { ; CX := # of palette entries           }
     mov   dx,03C8h            { ; DX := VGA Port                       }
     mov   si,offset palette   { ; SI := palette[0]                     }

     out   dx,al               { ; send zero to index port              }
     inc   dx                  { ; inc to write port                    }

   @l1:

     mov   bl,[si]             { ; set palette entry                    }
     shr   bl,2                { ; divide by 4                          }
     mov   [si],bl             { ; save entry                           }
     outsb                     { ; and write to port                    }
     dec   cx                  { ; CX := CX - 1                         }
     jnz   @l1                 { ; if not done then loop                }

     mov   ax,seg buffer       { ; AX := segment of buffer              }
     mov   es,ax               { ; ES := AX                             }
     mov   di,offset buffer    { ; DI := buffer[0]                      }
     mov   cx,8109             { ; CX := sizeof(buffer) div 2           }
     xor   ax,ax               { ; AX := 0                              }
     rep   stosw               { ; clear every element in buffer to zero}
  end;

  repeat

     asm
        mov   bx,1             { ; BX := 1                              }
        mov   si,offset path   { ; SI := path[0]                        }

        mov   cx,16160         { ; CX := # of elements to change        }
        mov   di,offset buffer { ; DI := buffer[0]                      }
        add   di,320           { ; DI := buffer[320] (0,1)              }

     @l2:

        mov   ax,ds:[di-2]     { ; AX := buffer[DI-2]    (x-1,y)        }
        add   ax,ds:[di]       { ; AX += buffer[DI]      (x  ,y)        }
        add   ax,ds:[di+2]     { ; AX += buffer[DI+2]    (x+1,y)        }
        add   ax,ds:[di+320]   { ; AX += buffer[DI+320]  (x,y+1)        }
        shr   ax,2             { ; AX := AX div 4 (calc average)        }

        jz    @l3              { ; if AX = 0 then skip next line        }
        dec   ax               { ; else AX--                            }

     @l3:

        push  di               { ; save DI                              }
        sub   di,ds:[si]       { ; DI := (x + or - sin,y-1)             }
        mov   word ptr ds:[di],ax { store AX somewhere one line up      }
        pop   di               { ; restore DI                           }

        inc   di               { ; DI++                                 }
        inc   di               { ; DI++ (move to next word)             }

        inc   bx               { ; BX++                                 }
        cmp   bx,320           { ; if bx <> 320                         }
        jle   @l4              { ; then jump to @l4                     }
        mov   bx,1             { ; else BX := 1 (we're on a new line)   }
        inc   si               { ; point SI to next element in path     }
        inc   si               { ;                                      }

     @l4:
        dec   cx               { ; CX--                                 }
        jnz   @l2              { ; if CX <> 0 then loop                 }
     end;

     for count := 0 to 159 do {set new bottom line}
        begin
           if random < 0.4 then
              delta := random(2)*255;
           buffer[101,count] := delta;
           buffer[102,count] := delta;
        end;

     asm
        mov   si,offset buffer { ; SI := buffer[0]                      }
        mov   es,dseg            { ; ES := AX                             }
        mov   di,doff            { ; DI := 0                              }
        mov   dx,100           { ; DX := 100 (# of rows div 2)          }

     @l5:
        mov   bx,2             { ; BX := 2                              }

     @l6:
        mov   cx,160           { ; CX := 160 (# of cols div 2)          }

     @l7:
        mov   al,ds:[si]       { ; AL := buffer[si]                     }
        mov   ah,al            { ; AH := AL (replicate byte)            }
        mov   es:[di],ax       { ; store two bytes into video memory    }
        inc   di               { ; move to next word in VRAM            }
        inc   di               { ;                                      }
        inc   si               { ; move to next word in buffer          }
        inc   si               { ;                                      }
        dec   cx               { ; CX--                                 }
        jnz   @l7              { ; repeat until done with column        }

        sub   si,320           { ; go back to start of line in buffer   }
        dec   bx               { ; BX--                                 }
        jnz   @l6              { ; repeat until two columns filled      }

        add   si,320           { ; restore position in buffer           }
        dec   dx               { ; DX--                                 }
        jnz   @l5              { ; repeat until 100 rows filled         }
     end;
     IF lchoice<>choice THEN   {Did the choice change?}
     BEGIN
     color:=255;               {if so change the palette}
     temp.red   := 25 SHR 2;
     temp.green := 80 SHR 2;
     temp.blue  := 25 SHR 2;
     FOR color:=color DOWNTO 252 DO
        Set_Palette_Register(color,temp);
     temp.red   := 10 SHR 2;
     temp.green := 220 SHR 2;
     temp.blue  :=  25 SHR 2;
     CASE choice OF                    {highlight new choice}
      1: Set_Palette_Register(255,temp);
      2: Set_Palette_Register(254,temp);
      3: Set_Palette_Register(253,temp);
      4: Set_Palette_Register(252,temp);
     END;
     END;
     lchoice:=choice;
     IF keypressed THEN get:=readkey;        {If key was pressed, get it}
     IF get=char($50) THEN INC(choice); {IF up arrow increment choice}
     IF get=char($48) THEN DEC(choice); {IF down arrow decrement choice}
     IF choice<1 THEN choice:=4;        {IF out of limits loop}
     IF choice>4 THEN choice:=1;
     IF get<>chr(13) THEN get:=' ';     {IF input not enter clear it}
     draw_sprite_f(menu);                 {Draw Title on Screen, Over flames}
     blit_string_db(90,60,255,'START GAME');  {Write Menu Choices}
     blit_string_db(90,70,254,'SAVE GAME');
     blit_string_db(90,80,253,'LOAD GAME');
     blit_string_db(90,90,252,'QUIT');
     show_double_buffer_a;                   {Move buffer to Screen}
  until get=chr(13);                  {Until Enter}
  freemem(menu.frames[1],263*26);     {Deallocate Sprite Memory}
  fade;
  cls;
  IF choice=1 THEN main;              {Start Game}
end;

{------------------- MAIN PROGRAM ---------------------}

BEGIN
init_sound;
opening;
main_menu;
{main;}
fade;
END.

