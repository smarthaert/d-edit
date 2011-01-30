UNIT thegraph;

INTERFACE

USES pcx,crt;

CONST    ROM_CHAR_SET_SEG=$F000;
         ROM_CHAR_SET_OFF=$FA6E;
         VGA_INPUT_STATUS_1=$3DA;
         VGA_VSYNC_MASK=$08;
         VGA256=$13;
         TEXT_MODE=$03;
         PALETTE_MASK=$3c6;
         PALETTE_REGISTER_RD=$3c7;
         PALETTE_REGISTER_WR=$3c8;
         PALETTE_DATA=$3c9;
         SCREEN_WIDTH=320;
         SCREEN_HEIGHT=200;
         CHAR_WIDTH=8;
         CHAR_HEIGHT=8;
         SPRITE_WIDTH=64;
         SPRITE_HEIGHT=64;
         MAX_SPRITE_FRAMES=24;
         SPRITE_DEAD=0;
         SPRITE_ALIVE=1;
         SPRITE_DYING=2;

TYPE RGB_color_typ=RECORD
        red:byte;
        green:byte;
        blue:byte;
       END;

     worm_typ=RECORD
        y,color,speed,counter:INTEGER;
      END;

      sprite_typ=RECORD
        x,y:integer;
        x_old,y_old:integer;
        width,height:integer;
        anim_clock:integer;
        anim_speed:integer;
        motion_speed:integer;
        motion_clock:integer;
        frames:array[1..MAX_SPRITE_FRAMES] OF pcximage;
        cur_frame:integer;
        num_frames:integer;
        state:integer;
        background:pcximage;
       END;

VAR double_buffer:pcximage;

PROCEDURE Blit_Char(xc,yc:INTEGER; c:CHAR; color:byte; trans_flag:BOOLEAN);
PROCEDURE Blit_String(x,y,color:INTEGER; word:string; trans_flag:boolean);
PROCEDURE Set_Palette_Register(index:integer; color:RGB_color_typ);
PROCEDURE Get_Palette_Register(index:integer; color:RGB_color_typ);
PROCEDURE Plot_Pixel_Fast(x,y:integer; color:byte);
PROCEDURE Plot_Pixel_Fast_D(x,y:integer; color:byte);
FUNCTION Get_Pixel(x,y:integer):byte;
FUNCTION Get_Pixel_D(x,y:INTEGER):byte;
PROCEDURE Show_Double_Buffer_h;
procedure show_double_buffer_a;
PROCEDURE Init_Double_Buffer;
PROCEDURE Sprite_Init(VAR sprite:sprite_typ; x,y,ac,as,mc,ms,w,h:INTEGER);
PROCEDURE Sprite_Delete(VAR sprite:sprite_typ);
PROCEDURE Get_sprite_coord(image:pcximage;
                          VAR sprite:sprite_typ;
                          sprite_frame:integer;
                          grab_x,grab_y:integer);
PROCEDURE Get_sprite(image:pcximage;
                          VAR sprite:sprite_typ;
                          sprite_frame:integer;
                          grab_x,grab_y:integer);
PROCEDURE Behind_Sprite(VAR sprite:sprite_typ);
PROCEDURE Erase_Sprite(VAR sprite:sprite_typ);
PROCEDURE Draw_Sprite(VAR sprite:sprite_typ);
PROCEDURE Behind_Sprite_VB(VAR sprite:sprite_typ);
PROCEDURE Erase_Sprite_VB(VAR sprite:sprite_typ);
PROCEDURE Draw_Sprite_VB(VAR sprite:sprite_typ);
PROCEDURE Melt;
FUNCTION raw_char(code:INTEGER):char;
PROCEDURE do_box(x1,y1,x2,y2,color:INTEGER);
PROCEDURE Draw_Sprite_F(VAR sprite:sprite_typ);
PROCEDURE Draw_sprite_VBF(VAR sprite:sprite_typ);
PROCEDURE Blit_String_D(x,y,color:INTEGER; word:string);
PROCEDURE Blit_Char_D(xc,yc:INTEGER; c:char; color:INTEGER);
PROCEDURE cls;

IMPLEMENTATION
(*------------------ Procedure Blit_Char _D -----------------------------*)

PROCEDURE cls;
BEGIN
ASM
 mov bx,0a000h
 mov es,bx
 mov di,0
 mov cx,320/2*200
 mov ax,0
 rep stosw
END;
END;

PROCEDURE Blit_Char_D(xc,yc:INTEGER; c:char; color:INTEGER);

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
  if (y=(CHAR_HEIGHT/2)) THEN color:=color-8;
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


(*------------------ Procedure Blit_String_D ------------------------------*)


PROCEDURE Blit_String_D(x,y,color:INTEGER; word:string);

VAR index:integer;

BEGIN
  FOR index:=1 TO length(word) DO
  BEGIN
    Blit_Char_D(x+(index SHL 3),y,word[index],color);
  END;
END;
PROCEDURE do_box(x1,y1,x2,y2,color:INTEGER);

VAR row,column:integer;

BEGIN
  FOR row:=y1 TO y2 DO
  FOR column:=x1 TO x2 DO
    mem[$a000:(row SHL 8) + (row SHL 6) + column]:=color;
END;

FUNCTION raw_char(code:INTEGER):char;
BEGIN
 CASE code OF
  30:raw_char:='a';
  48:raw_char:='b';
  46:raw_char:='c';
  32:raw_char:='d';
  18:raw_char:='e';
  33:raw_char:='f';
  34:raw_char:='g';
  35:raw_char:='h';
  23:raw_char:='i';
  36:raw_char:='j';
  37:raw_char:='k';
  38:raw_char:='l';
  50:raw_char:='m';
  49:raw_char:='n';
  24:raw_char:='o';
  25:raw_char:='p';
  16:raw_char:='q';
  19:raw_char:='r';
  31:raw_char:='s';
  20:raw_char:='t';
  22:raw_char:='u';
  47:raw_char:='v';
  17:raw_char:='w';
  45:raw_char:='x';
  21:raw_char:='y';
  44:raw_char:='z';
  ELSE raw_char:='0';
 END;
END;

PROCEDURE Blit_Char(xc,yc:INTEGER; c:CHAR; color:byte; trans_flag:BOOLEAN);

VAR offset,x,y:INTEGER;
    work_char:byte;
    bit_mask:byte;

BEGIN
work_char:=mem[$f000:$fa6e+ (ord(c) * char_height-1)];
offset := (yc SHL 8) + (yc SHL 6) + xc;
for y:=0 to CHAR_HEIGHT-1 DO
BEGIN
  bit_mask:=$80;
  for x:=0 to CHAR_WIDTH-1 DO
  BEGIN
    if (work_char AND bit_mask)<>0 THEN
    mem[$a000:offset+x]:=color
    ELSE IF (NOT trans_flag) THEN
          mem[$a000:offset+x]:=0;
    bit_mask:=(bit_mask SHR 1);
  END;
  offset := offset + SCREEN_WIDTH;
  work_char:=mem[$f000:$fa6e+ (ord(c) * char_height)+y];
END;
END;

PROCEDURE Blit_String(x,y,color:INTEGER; word:string; trans_flag:boolean);

VAR index:integer;

BEGIN
  FOR index:=1 TO length(word) DO
  BEGIN
    Blit_Char(x+(index SHL 3),y,word[index],color,trans_flag);
  END;
END;


PROCEDURE Set_Palette_Register(index:integer; color:RGB_color_typ);
BEGIN
  port[PALETTE_MASK]:=$ff;
 port[PALETTE_REGISTER_WR]:=index;
  port[PALETTE_DATA]:=color.red;
  port[PALETTE_DATA]:=color.green;
  port[PALETTE_DATA]:=color.blue;
END;

PROCEDURE Get_Palette_Register(index:integer; color:RGB_color_typ);
BEGIN
  port[PALETTE_MASK]:=$ff;
  port[PALETTE_REGISTER_RD]:=index;
  color.red   := port[PALETTE_DATA];
  color.green := port[PALETTE_DATA];
  color.blue  := port[PALETTE_DATA];
END;


PROCEDURE Plot_Pixel_Fast(x,y:integer; color:byte);
BEGIN
   mem[$a000:((y SHL 8) + (y SHL 6)) + x]:= color;
END;

PROCEDURE Plot_Pixel_Fast_D(x,y:integer; color:byte);
BEGIN
  mem[seg(double_buffer^):
      ofs(double_buffer^)+((y SHL 8) + (y SHL 6)) + x] := color;
END;

FUNCTION Get_Pixel(x,y:integer):byte;
BEGIN
  get_pixel:=mem[$A000:((y SHL 8) + (y SHL 6)) + x];
END;

FUNCTION Get_Pixel_D(x,y:INTEGER):byte;
BEGIN
  get_pixel_d:= mem[seg(double_buffer^):
                    ofs(double_buffer^)+((y SHL 8) + (y SHL 6)) + x]
END;

PROCEDURE Wait_For_Vsync;
BEGIN
{while(port[VGA_INPUT_STATUS_1] AND VGA_VSYNC_MASK=0) DO;}
while(port[VGA_INPUT_STATUS_1] AND VGA_VSYNC_MASK=1) DO;
END;


PROCEDURE Melt;

VAR index,ticks:integer;
    worms:ARRAY[1..320] of worm_typ;

BEGIN
  ticks:=0;
for index:=1 TO 160 DO
BEGIN
  worms[index].color   := Get_Pixel(index,0);
  worms[index].speed   := 3 + random(9)+1;
  worms[index].y       := 0;
  worms[index].counter := 0;
  Plot_Pixel_Fast((index SHL 1),0,worms[index].color);
  Plot_Pixel_Fast((index SHL 1),1,worms[index].color);
  Plot_Pixel_Fast((index SHL 1),2,worms[index].color);
  Plot_Pixel_Fast((index SHL 1)+1,0,worms[index].color);
  Plot_Pixel_Fast((index SHL 1)+1,1,worms[index].color);
  Plot_Pixel_Fast((index SHL 1)+1,2,worms[index].color);
END;

while ticks<1800 DO
BEGIN
  for index:=1 TO 320 DO
  BEGIN
    INC(worms[index].counter);
    if (worms[index].counter = worms[index].speed) THEN
    BEGIN
      worms[index].counter := 0;
      worms[index].color := Get_Pixel(index,worms[index].y+4);
      if (worms[index].y < 194) THEN
      BEGIN
        Plot_Pixel_Fast((index SHL 1),worms[index].y,0);
        Plot_Pixel_Fast((index SHL 1),worms[index].y+1,worms[index].color);
        Plot_Pixel_Fast((index SHL 1),worms[index].y+2,worms[index].color);
        Plot_Pixel_Fast((index SHL 1),worms[index].y+3,worms[index].color);
        Plot_Pixel_Fast((index SHL 1)+1,worms[index].y,0);
        Plot_Pixel_Fast((index SHL 1)+1,worms[index].y+1,worms[index].color);
        Plot_Pixel_Fast((index SHL 1)+1,worms[index].y+2,worms[index].color);
        Plot_Pixel_Fast((index SHL 1)+1,worms[index].y+3,worms[index].color);
        INC(worms[index].y);
       END;
    END;
  END;
  if ticks MOD 500=0 THEN
  BEGIN
    for  index:=1 TO 160 DO
            DEC(worms[index].speed);
  END;
    Wait_For_Vsync;
    ticks:=ticks+1;
  END;
END;

PROCEDURE Show_Double_Buffer_h;
BEGIN
  move(mem[seg(double_buffer^):ofs(double_buffer^)],mem[$a000:$0000],320*152);
END;
PROCEDURE Show_Double_Buffer_a;
BEGIN
  move(mem[seg(double_buffer^):ofs(double_buffer^)],mem[$a000:$0000],320*200);
END;
PROCEDURE Init_Double_Buffer;
BEGIN
  check_mem(double_buffer,screen_width*screen_height)
END;

PROCEDURE Sprite_Init(VAR sprite:sprite_typ; x,y,ac,as,mc,ms,w,h:INTEGER);

VAR index:INTEGER;

BEGIN
sprite.x            := x;
sprite.y            := y;
sprite.x_old        := x;
sprite.y_old        := y;
sprite.width        := w;
sprite.height       := h;
sprite.anim_clock   := ac;
sprite.anim_speed   := as;
sprite.motion_clock := mc;
sprite.motion_speed := ms;
sprite.cur_frame   := 1;
sprite.state        := SPRITE_DEAD;
sprite.num_frames   := 0;
for index:=1 TO MAX_SPRITE_FRAMES DO
    sprite.frames[index] := NIL;
END;

PROCEDURE Sprite_Delete(VAR sprite:sprite_typ);

VAR index:integer;

BEGIN
for index:=1 TO sprite.num_frames DO
        freemem(sprite.frames[index],sprite.width*sprite.height)
END;

PROCEDURE Get_sprite(image:pcximage;
                          VAR sprite:sprite_typ;
                          sprite_frame:integer;
                          grab_x,grab_y:integer);

VAR x_off,y_off, x,y, index,sseg,soff,iseg,ioff:INTEGER;

BEGIN
check_mem(sprite.frames[sprite_frame],sprite.width * sprite.height);
x_off := (sprite.width+1)  * grab_x+1;
y_off := (sprite.height+1) * grab_y+1;
y_off := y_off * 320;
soff:=ofs(sprite.frames[sprite_frame]^);
sseg:=seg(sprite.frames[sprite_frame]^);
iseg:=seg(image^);
ioff:=ofs(image^);
for y:=0 TO sprite.height-1 DO
BEGIN
  for x:=0 TO sprite.width-1 DO
  BEGIN
    mem[sseg:soff+y*sprite.width + x] :=mem[iseg:ioff+y_off+x_off+x];
   END;
  y_off:=y_off+320;
END;
 sprite.num_frames:=sprite.num_frames+1;
END;

PROCEDURE Get_sprite_coord(image:pcximage;
                          VAR sprite:sprite_typ;
                          sprite_frame:integer;
                          grab_x,grab_y:integer);

VAR y_off, x,y, index,sseg,soff,iseg,ioff:INTEGER;

BEGIN
check_mem(sprite.frames[sprite_frame],sprite.width * sprite.height);
y_off := grab_y*320+grab_x;
soff:=ofs(sprite.frames[sprite_frame]^);
sseg:=seg(sprite.frames[sprite_frame]^);
iseg:=seg(image^);
ioff:=ofs(image^);
for y:=0 TO sprite.height-1 DO
BEGIN
  for x:=0 TO sprite.width-1 DO
  BEGIN
    mem[sseg:soff+y*sprite.width + x] :=mem[iseg:ioff+y_off+x];
   END;
  y_off:=y_off+320;
END;
 sprite.num_frames:=sprite.num_frames+1;
END;


PROCEDURE Behind_Sprite(VAR sprite:sprite_typ);

VAR work_offset,offset,y,sseg,soff,dseg,doff:integer;

BEGIN
check_mem(sprite.background,sprite.height*sprite.width);
sseg:=seg(sprite.background^);
soff:=ofs(sprite.background^);
dseg:=seg(double_buffer^);
doff:=ofs(double_buffer^);
work_offset:=0;
offset := (sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
for y:=0 TO sprite.height-1 DO
BEGIN
  move(mem[dseg:doff+offset],mem[sseg:soff+work_offset],sprite.width);
  offset:=offset+SCREEN_WIDTH;
  work_offset:=work_offset+sprite.width;
END;
END;

PROCEDURE Erase_Sprite(VAR sprite:sprite_typ);

VAR work_offset,offset,y,sseg,soff,dseg,doff:integer;

BEGIN
  sseg:=seg(sprite.background^);
  soff:=ofs(sprite.background^);
  dseg:=seg(double_buffer^);
  doff:=ofs(double_buffer^);
  work_offset:=0;
  offset := (sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
  for y:=0 TO sprite.height-1 DO
  BEGIN
    move(mem[sseg:soff+work_offset],mem[dseg:doff+offset],sprite.width);
    offset:=offset+SCREEN_WIDTH;
    work_offset:=work_offset+sprite.width;
  END;
  freemem(sprite.background,sprite.width*sprite.height);
END;

PROCEDURE Draw_Sprite_F(VAR sprite:sprite_typ);

VAR x,y,soff,sseg,dseg,doff:word;
    height,width:word;

BEGIN
width:=sprite.width;
height:=sprite.height;
x:=sprite.x; y:=sprite.y;
soff:=ofs(sprite.frames[sprite.cur_frame]^);
sseg:=seg(sprite.frames[sprite.cur_frame]^);
dseg:=seg(double_buffer^);
doff:=ofs(double_buffer^);
ASM
jmp @begin
@plot:
 mov es,dseg
 mov bx,x
 add bx,dx
 mov es:[di+bx],cl
jmp @back
@begin:
  mov di,doff
   mov si,soff
   mov dx,y
   shl dx,8
   mov ax,dx
   shr dx,2
   add dx,ax
   add dx,x
   mov ax,0
   mov y,0
   mov x,0
@yloop:
@xloop:
 mov es,sseg
 mov bx,x
 add bx,ax
 mov cl,byte ptr es:[si+bx]
 cmp cl,0
 jne @plot
 @back:
 inc x
 mov bx,x
 cmp bx,width
 jne @xloop
 inc y
 add dx,screen_width
 add ax,width
 mov x,0
 mov bx,y
cmp bx,height
jne @yloop
END;
END;

PROCEDURE Draw_Sprite_VBF(VAR sprite:sprite_typ);

VAR x,y,soff,sseg,dseg,doff:word;
    height,width:word;

BEGIN
width:=sprite.width;
height:=sprite.height;
x:=sprite.x; y:=sprite.y;
soff:=ofs(sprite.frames[sprite.cur_frame]^);
sseg:=seg(sprite.frames[sprite.cur_frame]^);
dseg:=seg(double_buffer^);
doff:=ofs(double_buffer^);
ASM
jmp @begin
@plot:
mov di,0a000h
 mov es,di
 mov bx,x
 add bx,dx
 mov es:[bx],cl
jmp @back
@begin:
   mov si,soff
   mov dx,y
   shl dx,8
   mov ax,dx
   shr dx,2
   add dx,ax
   add dx,x
   mov ax,0
   mov y,0
   mov x,0
@yloop:
@xloop:
 mov es,sseg
 mov bx,x
 add bx,ax
 mov cl,byte ptr es:[si+bx]
 cmp cl,0
 jne @plot
 @back:
 inc x
 mov bx,x
 cmp bx,width
 jne @xloop
 inc y
 add dx,screen_width
 add ax,width
 mov x,0
 mov bx,y
cmp bx,height
jne @yloop
END;
END;


PROCEDURE Draw_Sprite(VAR sprite:sprite_typ);

VAR work_offset,offset,x,y,soff,sseg,dseg,doff:INTEGER;
    data:byte;

BEGIN
soff:=ofs(sprite.frames[sprite.cur_frame]^);
sseg:=seg(sprite.frames[sprite.cur_frame]^);
dseg:=seg(double_buffer^);
doff:=ofs(double_buffer^);
work_offset:=0;
offset:=(sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
for y:=0 TO sprite.height-1 DO
BEGIN
for x:=0  TO sprite.width-1 DO
BEGIN
 data:=mem[sseg:soff+work_offset+x];
 IF data<>0 THEN mem[dseg:doff+offset+x]:=data;
END;
 offset:=offset+SCREEN_WIDTH;
 work_offset:=work_offset+sprite.width;
END;
END;

PROCEDURE Behind_Sprite_VB(VAR sprite:sprite_typ);

VAR work_offset,offset,y,sseg,soff:integer;

BEGIN
check_mem(sprite.background,sprite.width*sprite.height);
sseg:=seg(sprite.background^);
soff:=ofs(sprite.background^);
work_offset:=0;
offset := (sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
for y:=0 TO sprite.height-1 DO
BEGIN
  move(mem[$a000:offset],mem[sseg:soff+work_offset],sprite.width);
  offset:=offset+SCREEN_WIDTH;
  work_offset:=work_offset+sprite.width;
END;
END;

PROCEDURE Erase_Sprite_VB(VAR sprite:sprite_typ);

VAR work_offset,offset,y,sseg,soff:integer;

BEGIN
  sseg:=seg(sprite.background^);
  soff:=ofs(sprite.background^);
  work_offset:=0;
  offset := (sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
  for y:=0 TO sprite.height-1 DO
  BEGIN
    move(mem[sseg:soff+work_offset],mem[$a000:offset],sprite.width);
    offset:=offset+SCREEN_WIDTH;
    work_offset:=work_offset+sprite.width;
  END;
  freemem(sprite.background,sprite.width*sprite.height)
END;

PROCEDURE Draw_Sprite_VB(VAR sprite:sprite_typ);

VAR work_offset,offset,x,y,soff,sseg:INTEGER;
    data:byte;

BEGIN
soff:=ofs(sprite.frames[sprite.cur_frame]^);
sseg:=seg(sprite.frames[sprite.cur_frame]^);
work_offset:=0;
offset:=(sprite.y SHL 8) + (sprite.y SHL 6) + sprite.x;
for y:=0 TO sprite.height-1 DO
BEGIN
for x:=0  TO sprite.width-1 DO
BEGIN
 data:=mem[sseg:soff+work_offset+x];
 IF data<>0 THEN mem[$a000:offset+x]:=data;
END;
 offset:=offset+SCREEN_WIDTH;
 work_offset:=work_offset+sprite.width;
END;
END;

BEGIN
END.








