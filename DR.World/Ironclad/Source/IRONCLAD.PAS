uses crt,dos,graph,drivers,base,turbo3;

const
num_of_pictures=50;
num_of_patterns=10;
num_of_stars=20;
num_of_movers=10;
max_num_of_lasers=50;
max_num_of_enemy_lasers=100;
max_num_of_enemies=15;
max_num_of_explosions=16;
max_types_of_lasers=20;
max_types_of_enemies=100;
max_parts_of_map=10;
initial_money=10000;
initial_shields=40;
type

s10=string[10];

pictures=record
name:string[10];
xdim,ydim:byte;
pic:pointer;
end;

laser_types=record
picn:byte;
jump:byte;
del:integer;
link:byte;
link_space:byte;
num:byte;
price:longint;
possess:boolean;
damage:byte;
xdim,ydim:byte;
range:integer;
limit:byte;
orrientation:byte;
name:string[30];
cdel:integer;
des:string;
end;

laser=record
x,y:integer;
end;

enemy_laser=record
x,y:integer;
ltype:integer;
et:byte;
end;

enemies=record
strength:integer;
x,y:integer;
et:byte;
stage,cdel:byte;
end;

animation=record
bpic,lpic:byte;
name:string[10];
end;

movers=record
bpic,lpic:byte;
name:string[10];
patname:string[10];
cdel,del,x,y:integer;
repeater:boolean;
onpic:byte;
end;

stars=record
x,y:integer;
stype:byte;
picn:byte;
end;

map_position=record
filen:string;
del:longint;
on_part:byte;
on_level:byte;
lastline:integer;
name:string;
end;

enemy_types=record
point_value:longint;
strength,weap_pow:integer;
jump:byte;
picn:byte;
del:integer;
damage_by_ram:byte;
wnum:byte; {weapon type}
chance_of_shot:integer; {higher the number lower the chance}
orrientation:byte;
midx,midy:byte;
end;

explosions=record
x,y:integer;
dim,on,last:byte;
end;

var pics:array[1..num_of_pictures] of pictures;
    ani:array[1..num_of_patterns] of animation;
    mov:array[1..num_of_movers] of movers;
    ltype:array[1..max_types_of_lasers] of laser_types;
    las:array[1..max_num_of_lasers] of laser;
    elas:array[1..max_num_of_enemy_lasers] of enemy_laser;
    e:array[1..max_num_of_enemies] of enemies;
    s:array[1..num_of_stars] of stars;
    et:array[1..max_types_of_enemies] of enemy_types;
    exp:array[1..max_num_of_explosions] of explosions;
    mp:map_position;
    part:array[1..max_parts_of_map] of string;
    bgidirec,picdirec,workdirec,pp:string;
    kevent,moevent:tevent;
    proc:s10;
    direct,burn_num,onweapon,onlaser,eonlaser,onenemy,onexp,eweap,s_cdel,b10,b20,b30,b40,b50,lmx,lmy,cont,flamex,warp:byte;
    sx,sy,fy,error:integer;
    global_del,money,gship_strength,gship_strength_total,total:longint;
    map:text;
    clear_d,nostar:boolean;
    x,y:integer;
    slowdown:byte;

{Please E-mail me (victor@intrex.net) if you have any questions about the code
I'll be happy to explain any of the procedures to you}

procedure fatal(fcall:string);
begin
textmode(CO80);
clrscr;
writeln('A fatal error has occured');
writeln('Error: ',fcall);
writeln;
write('Hit enter to halt program--');
readln;
halt;
end;

procedure ginit640x480x16(direc:string);
var grd,grmode,errcode:integer;
begin
closegraph;
grd:=9;
grmode:=2;
initgraph(grd,grmode,direc);
ErrCode := GraphResult;
if ErrCode <> grOk then fatal('PROC[GINIT640X480X16]- CANNOT INITIALIZE 640x480x16 GRAPHICS MODE');
setgraphmode(2);
end;

procedure mouse_chk;
var lk:tevent;
    func:char;
    name:string[12];
begin
cleardevice;
outtextxy(110,0,'This game requires a mouse, to enter left click now');
gotoxy(1,15);
setcolor(7);
outtextxy(0,460,'If you do not have a mouse driver installed hit "Q" to exit to your Operating');
outtextxy(0,470,'System so you can install a mouse driver');
setcolor(red);
outtextxy(0,290,'Read Before Continuing:');
outtextxy(0,300,'It is not suggested that this game be run under any other operating system');
outtextxy(0,310,'than higher versions MS or PC DOS. It is recommended that you do not use Windows.');
outtextxy(0,320,'The author of this software is not responsible for any damage this software');
outtextxy(0,330,'causes to anything. Though I hardly see how it could.');
settextstyle(0,0,8);
name:='IronClad';
setcolor(4);
outtextxy(((640-(length(name)*8*8))div 2)-6,26,name);
setcolor(7);
outtextxy(((640-(length(name)*8*8))div 2)-5,25,name);
setcolor(8);
outtextxy((640-(length(name)*8*8))div 2,20,name);
settextstyle(0,0,1);
showmouse;
repeat
getmouseevent(lk);
func:='@';
if keypressed then
begin
read(kbd,func);
func:=upcase(func);
end;
until (func='Q') or (lk.buttons=mbleftbutton);
if func='Q' then
begin
textmode(co80);
clrscr;
halt;
end;
hidemouse;
cleardevice;
end;

function find_next_pic:byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (pics[c].name='') or (c>num_of_pictures);
if c>num_of_pictures then fatal('FUNC[FIND_NEXT_PIC]- MAXIMUM NUMBER OF PICTURES USED');
find_next_pic:=c;
end;

function find_next_ani:byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (ani[c].name='') or (c>num_of_patterns);
if c>num_of_patterns then fatal('FUNC[FIND_NEXT_ANI]- MAXIMUM NUMBER OF PATTERNS USED');
find_next_ani:=c;
end;

function find_next_mover:byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (mov[c].name='') or (c>num_of_movers);
if c>num_of_movers then fatal('FUNC[FIND_NEXT_MOVER]- MAXIMUM NUMBER OF ANIMATIONS USED');
find_next_mover:=c;
end;

function find_pic(name:s10):byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (pics[c].name=name) or (c>num_of_pictures);
if c>num_of_pictures then fatal(CONCAT('FUNC[FIND_PIC]- PICTURE NAME: ',NAME,' NOT FOUND'));
find_pic:=c;
end;

function find_pattern(name:s10):byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (ani[c].name=name) or (c>num_of_patterns);
if c>num_of_patterns then fatal(CONCAT('FUNC[FIND_PATTERN]- PATTERN NAME: ',NAME,' NOT FOUND'));
find_pattern:=c;
end;

function find_mover(name:s10):byte;
var c:byte;
begin
c:=0;
repeat
inc(c);
until (mov[c].name=name) or (c>num_of_movers);
if c>num_of_movers then fatal(CONCAT('FUNC[FIND_MOVER]- MOVER NAME: ',NAME,' NOT FOUND'));
find_mover:=c;
end;

procedure loadpic(filen:string; name:s10);
var work:text;
    s,x,y,o:byte;
begin
assign(work,filen);
{$i-}
reset(work);
{$i+}
if ioresult<>0 then fatal(CONCAT('PROC[LOADPIC]- DRW FILE: ',FILEN,' DOES NOT EXIST!'));
s:=find_next_pic;
pics[s].name:=name;
readln(work,pics[s].xdim);
readln(work,pics[s].ydim);
getmem(pics[s].pic,imagesize(0,0,pics[s].xdim,pics[s].ydim));
total:=total+imagesize(0,0,pics[s].xdim,pics[s].ydim);
cleardevice;
y:=1;
repeat
x:=1;
repeat
readln(work,o);
putpixel(x-1,y-1,o);
inc(x);
until (x>pics[s].xdim) or (eof(work));
inc(y);
until (y>pics[s].ydim) or (eof(work));
if (x<=pics[s].xdim) or (y<=pics[s].ydim) then
begin
fatal(CONCAT('PROC[LOADPIC]- DRW FILE: ',FILEN,' DOES NOT APPEAR TO BE A VALID DWG FILE'));
end;
getimage(0,0,pics[s].xdim,pics[s].ydim,pics[s].pic^);
close(work);
end;

procedure loadani(name:s10; bp,lp:s10);
var s:byte;
begin
s:=find_next_ani;
ani[s].bpic:=find_pic(bp);
ani[s].lpic:=find_pic(lp);
ani[s].name:=name;
end;

procedure draw_drw_file(xd,yd:integer; n:string);
var w:text;
    x,y,c,cx,cy:integer;
begin
assign(w,n);
{$i-}
reset(w);
{$i+}
if ioresult<>0 then fatal(CONCAT('PROC[LOADPIC]- DRW FILE: ',n,' DOES NOT EXIST!'));
readln(w,x);
readln(w,y);
cy:=0;
repeat
cx:=0;
repeat
readln(w,c);
putpixel(xd+cx,yd+cy,c);
inc(cx);
until (cx>=x) or (eof(w));
inc(cy);
until (cy>=y) or (eof(w));
if not(cy>=y) then fatal(CONCAT('PROC[LOADPIC]- DRW FILE: ',n,' DOES NOT APPEAR TO BE A VALID DWG FILE'));
close(w);
end;

procedure showpic_by_name(name:s10; x,y:integer);
var c:byte;
begin
c:=find_pic(name);
putimage(x,y,pics[c].pic^,normalput);
end;

procedure showpic_by_num(n:byte; x,y:integer);
begin
putimage(x,y,pics[n].pic^,normalput);
end;

procedure update_board(n:byte);
var per:real;
    s:string;
begin
if (n=1) or (n=255) then
begin
per:=(gship_strength / gship_strength_total) * 100;
str(per:0:0,s);
setcolor(white);
outtextxy(66,5,'ллллл');
setcolor(0);
outtextxy(66,5,s+'%');
end;
if (n=2) or (n=255) then
begin
per:=(onlaser / ltype[onweapon].limit) * 100;
str(per:0:0,s);
setcolor(white);
outtextxy(186,5,'ллллл');
setcolor(0);
outtextxy(186,5,s+'%');
end;
if (n=3) or (n=255) then
begin
setcolor(white);
outtextxy(253,5,'лллллллллл');
setcolor(0);
str(money,s);
outtextxy(253,5,s);
end;
if (n=4) or (n=255) then
begin
setcolor(7);
outtextxy(360,5,'ллллллллллллллллллллллллллл');
setcolor(black);
if not(onweapon in [11..16]) then outtextxy(360,5,ltype[onweapon].name);
if onweapon in [11..16] then
begin
str(ltype[onweapon].num,s);
outtextxy(360,5,concat(ltype[onweapon].name,'[',s,']'));
end;
end;
end;

procedure fire_laser;
begin
if not(onweapon in [11..16]) then
begin
if (onlaser<=ltype[onweapon].limit) and (onlaser<=max_num_of_lasers) then
begin
inc(onlaser);
las[onlaser].x:=sx+ltype[onweapon].orrientation;
las[onlaser].y:=sy-pics[ltype[onweapon].picn].ydim;
update_board(2);
end;
end;
if onweapon in [11..16] then
begin
if (onlaser<=ltype[onweapon].limit) and (onlaser<=max_num_of_lasers) and (ltype[onweapon].num>0)then
begin
inc(onlaser);
las[onlaser].x:=sx+ltype[onweapon].orrientation;
las[onlaser].y:=sy-pics[ltype[onweapon].picn].ydim;
dec(ltype[onweapon].num);
update_board(2);
update_board(4);
end;
end;
end;

procedure fire_enemy_laser(c:byte);
begin
if (eonlaser+1<max_num_of_enemy_lasers) then
begin
inc (eonlaser);
elas[eonlaser].x:=e[c].x+et[e[c].et].orrientation;
elas[eonlaser].y:=e[c].y+pics[et[e[c].et].picn].ydim;
elas[eonlaser].ltype:=et[e[c].et].wnum;
elas[eonlaser].et:=e[c].et;
end;
end;

procedure make_enemy(n:byte);
begin
if onenemy+1<max_num_of_enemies then
begin
inc(onenemy);
e[onenemy].x:=random(639-(pics[et[n].picn].xdim))+pics[et[n].picn].xdim;
e[onenemy].y:=50;
e[onenemy].et:=n;
e[onenemy].strength:=et[e[onenemy].et].strength;
e[onenemy].stage:=0;
end;
end;

procedure make_enemy_fixed(n:byte;x:integer);
begin
if onenemy+1<max_num_of_enemies then
begin
inc(onenemy);
e[onenemy].x:=x;
e[onenemy].y:=50;
e[onenemy].et:=n;
e[onenemy].strength:=et[e[onenemy].et].strength;
end;
end;

procedure prep_board;
begin
setfillstyle(1,7);
bar(0,0,639,19);
setfillstyle(1,0);
draw_drw_file(0,0,concat(picdirec,'\board1.drw'));
draw_drw_file(55,0,concat(picdirec,'\board2.drw'));
setcolor(0);
outtextxy(5,5,'Shields ');
draw_drw_file(120,0,concat(picdirec,'\board1.drw'));
draw_drw_file(175,0,concat(picdirec,'\board2.drw'));
outtextxy(125,5,'Coolant');
draw_drw_file(240,0,concat(picdirec,'\board1.drw'));
draw_drw_file(295,0,concat(picdirec,'\board2.drw'));
setcolor(0);
outtextxy(245,5,'$');
end;

procedure clean_pics;
var c,x,y:byte;
begin
c:=1;
repeat
pics[c].name:='';
inc(c);
until c>num_of_pictures;
end;

procedure clean_animations;
var c:byte;
begin
c:=1;
repeat
ani[c].name:='';
inc(c);
until c>num_of_patterns;
end;

procedure clean_movers;
var c:byte;
begin
c:=1;
repeat
mov[c].name:='';
inc(c);
until c>num_of_movers;
end;

procedure clean_weapon_types;
var c:byte;
begin
clear_d:=false;
warp:=0;
c:=1;
repeat
ltype[c].name:='';
ltype[c].cdel:=0;
ltype[c].num:=0;
inc(c);
until c>max_types_of_lasers;
end;

procedure clean_lasers;
var c:byte;
begin
c:=1;
onlaser:=0;
repeat
las[c].x:=-1;
las[c].y:=-1;
inc(c);
until c>max_num_of_lasers;
eonlaser:=0;
c:=1;
repeat
elas[c].x:=-1;
elas[c].y:=-1;
elas[c].ltype:=0;
inc(c);
until c>max_num_of_enemy_lasers;
end;

procedure clean_enemies;
var c:byte;
begin
c:=1;
onenemy:=0;
repeat
e[c].x:=-1;
e[c].y:=-1;
e[c].et:=0;
e[c].cdel:=0;
inc(c)
until c>max_num_of_enemies;
end;

procedure clean_stars;
var c:byte;
begin
c:=1;
randomize;
repeat
s[c].x:=-1;
s[c].y:=-1;
s[c].stype:=random(3)+1;
if s[c].stype=1 then s[c].picn:=find_pic('star1');
if s[c].stype=2 then s[c].picn:=find_pic('star2');
if s[c].stype=3 then s[c].picn:=find_pic('star3');
inc(c);
until c>num_of_stars;
end;

procedure end_level;
var x1,y1,x2,y2,x3,y3:integer;
begin
ginit640x480x16(bgidirec);
cleardevice;

x1:=(640 div 2)-(pics[1].xdim div 2);
y1:=490;
x2:=(x1-100);
y2:=520;
x3:=((x1+pics[1].xdim)+(100-(pics[1].xdim)));
y3:=520;

repeat
delay(3);
showpic_by_num(1,x1,y1);
showpic_by_num(1,x2,y2);
showpic_by_num(1,x3,y3);
setcolor(0);
line(x1,y1+pics[1].ydim,x1+pics[1].xdim,y1+pics[1].ydim);
line(x2,y2+pics[1].ydim,x2+pics[1].xdim,y2+pics[1].ydim);
line(x3,y3+pics[1].ydim,x3+pics[1].xdim,y3+pics[1].ydim);
putpixel((x1+(pics[1].xdim div 2)-1)+random(3),y1+pics[1].ydim,4);
putpixel((x2+(pics[1].xdim div 2)-1)+random(3),y2+pics[1].ydim,4);
putpixel((x3+(pics[1].xdim div 2)-1)+random(3),y3+pics[1].ydim,4);
putpixel(((x1-1)+random(3))+3,y1+pics[1].ydim,white);
putpixel(((x2-1)+random(3))+3,y2+pics[1].ydim,white);
putpixel(((x3-1)+random(3))+3,y3+pics[1].ydim,white);
putpixel((((x1+pics[1].xdim)-1)+random(3))-3,y1+pics[1].ydim,blue);
putpixel((((x2+pics[1].xdim)-1)+random(3))-3,y2+pics[1].ydim,blue);
putpixel((((x3+pics[1].xdim)-1)+random(3))-3,y3+pics[1].ydim,blue);
dec(y3);
dec(y2);
dec(y1);
until y1=0;
settextstyle(defaultfont,0,10);
setcolor(white);
outtextxy((640 div 2) - ((8*8*10) div 2),300,'You Win!');
readln;
settextstyle(defaultfont,0,1);
cleardevice;
proc:='finish';
cont:=0;
setfillstyle(1,0);
end;

procedure load_next;
var c:byte;
    s:string;
begin
mp.del:=0;
global_del:=1;
mp.on_part:=1;
inc(mp.on_level);
{$i-}
reset(map);
{$i+}
if ioresult<>0 then fatal(concat('PROC[LOAD_NEXT]- CANNOT FIND MAP: ',mp.filen));
c:=1;
repeat
readln(map,s);
inc(c);
until c>mp.lastline;
readln(map,s);
inc(mp.lastline);
if s='[End Level]' then end_level;
if s<>'[End Level]' then
begin
mp.name:=s;
if upc(s)<>'[NEW PART]' then
begin
fatal('PROC[LOAD_NEXT]- MAP CORRUPTED (2)');
end;
c:=1;
repeat
if upc(s)<>'[END PART]' then readln(map,part[c]);
s:=part[c];
inc(mp.lastline);
inc(c);
until (upc(s)='[END PART]') or (eof(map)) or (c>max_parts_of_map);
if eof(map) then fatal('PROC[LOAD_NEXT]- MAP CORRUPTED (3)');
if c>max_parts_of_map then fatal('PROC[LOAD_NEXT]- MAP CORRUPTED, PART TOO LONG');;
end;
end;

procedure clean_map;
var s:string;
begin
{$i-}
close(map);
{$i+}
if ioresult<>0 then s:='';
mp.del:=0;
global_del:=1;
mp.on_part:=1;
mp.on_level:=1;
mp.lastline:=0;
assign(map,mp.filen);
{$i-}
reset(map);
{$i+}
if ioresult<>0 then fatal(concat('PROC[CLEAN_MAP]- CANNOT FIND MAP: ',mp.filen));
readln(map,mp.name);
if pos('LEVEL NAME:',upc(mp.name))=0 then fatal('PROC[CLEAN_MAP]- MAP CORRUPTED (1)');
delete(mp.name,1,11);
readln(map,s);
if upc(s)<>'[NEW PART]' then fatal('PROC[CLEAN_MAP]- MAP CORRUPTED (2)');
mp.lastline:=2;
repeat
if upc(s)<>'[END PART]' then readln(map,part[mp.lastline-1]);
s:=part[mp.lastline-1];
inc(mp.lastline);
until (upc(s)='[END PART]') or (eof(map)) or (mp.lastline-1>max_parts_of_map);
if eof(map) then fatal('PROC[CLEAN_MAP]- MAP CORRUPTED (3)');
if mp.lastline-1>max_parts_of_map then fatal('PROC[CLEAN_MAP]- MAP CORRUPTED, PART TOO LONG (4)');;
end;

procedure clean_explosions;
var c:byte;
begin
onexp:=0;
c:=1;
repeat
exp[c].x:=-1;
exp[c].on:=0;
exp[c].dim:=0;
inc(c);
until c>max_num_of_explosions;
end;

procedure load_game_pictures;
var w:text;
    s,s2:string;
    s1:s10;
begin
assign(w,concat(workdirec,'\assign.pic'));
{$i-}
reset(w);
{$i+}
if ioresult<>0 then fatal('PROC[LOAD_GAME_PICTURES]- CANNOT FIND CRUCIAL FILE: ASSIGN.PIC');
repeat
readln(w,s);
until (s='[Picture assignments]') or (eof(w));
if (s<>'[Picture assignments]') then fatal('PROC[LOAD_GAME_PICTURES(1)]- CORRUPTED GAME FILE: ASSIGN.PIC');
repeat
readln(w,s);
if pos(':',s)>0 then
begin
s1:=copy(s,1,pos(':',s)-1);
delete(s,1,pos(':',s));
s2:=s;
loadpic(concat(picdirec,s2),s1);
end;
until (s='[End. Picture assignments]') or (eof(w));
if (s<>'[End. Picture assignments]') then fatal('PROC[LOAD_GAME_PICTURES(2)]- CORRUPTED GAME FILE: ASSIGN.PIC');
close(w);
end;

procedure load_game_ani;
var w:text;
    s,s2,check:string;
    s1:s10;
begin
assign(w,concat(workdirec,'\assign.pic'));
{$i-}
reset(w);
{$i+}
if ioresult<>0 then fatal('PROC[LOAD_GAME_ANI]- CANNOT FIND CRUCIAL FILE: ASSIGN.PIC');
repeat
readln(w,s);
until (s='[Animation assignments]') or (eof(w));
if (s<>'[Animation assignments]') then fatal('PROC[LOAD_GAME_ANI(1)]- CORRUPTED GAME FILE: ASSIGN.PIC');
repeat
readln(w,check);
s1:='';
if check='[New]' then
begin
readln(w,s1);
readln(w,s);
readln(w,s2);
end;
if s1[1]=':' then
begin
delete(s1,1,1);
loadani(s1,s,s2);
end;
until (check='[End. Animation assignments]') or (eof(w));
if (check<>'[End. Animation assignments]') then fatal('PROC[LOAD_GAME_ANI(2)]- CORRUPTED GAME FILE: ASSIGN.PIC');
close(w);
end;

procedure load_game_weapons;
var w:text;
    s,f:string;
    n:byte;

procedure fatal_call(n:char);
begin
fatal(concat('PROC[LOAD_GAME_WEAPONS] (',n,')- CORRUPTED CRUCIAL FILE: WEAPON.INF'));
end;

begin
assign(w,concat(workdirec,'\weapon.inf'));
{$i-}
reset(w);
{$i+}
onweapon:=1;
if ioresult<>0 then fatal('PROC[LOAD_GAME_WEAPONS]- CANNOT FIND CRUCIAL FILE: WEAPON.INF');
n:=1;
readln(w,s);
repeat
readln(w,s);
if s[1]<>'[' then fatal_call('1');
if s[length(s)]<>']' then fatal_call('2');
delete(s,1,1);
if pos('//',s)=0 then ltype[n].name:=copy(s,1,pos(']',s)-1);
if pos('//',s)>0 then
begin
ltype[n].des:='';
ltype[n].name:=copy(s,1,pos('//',s)-1);
delete(s,1,pos('//',s)+1);
ltype[n].des:=copy(s,1,pos(']',s)-1);
end;

readln(w,s);
f:='picture name=';
if pos(upc(f),upc(s))=0 then fatal_call('3');
delete(s,1,length(f));
ltype[n].picn:=find_pic(s);

readln(w,s);
f:='jump=';
if pos(upc(f),upc(s))=0 then fatal_call('4');
delete(s,1,length(f));
val(s,ltype[n].jump,error);
if error<>0 then fatal_call('J');

readln(w,s);
f:='delay=';
if pos(upc(f),upc(s))=0 then fatal_call('5');
delete(s,1,length(f));
val(s,ltype[n].del,error);
if error<>0 then fatal_call('D');

readln(w,s);
f:='link=';
if pos(upc(f),upc(s))=0 then fatal_call('6');
delete(s,1,length(f));
val(s,ltype[n].link,error);
if error<>0 then fatal_call('L');

readln(w,s);
f:='link space=';
if pos(upc(f),upc(s))=0 then fatal_call('7');
delete(s,1,length(f));
val(s,ltype[n].link_space,error);
if error<>0 then fatal_call('S');

readln(w,s);
f:='price=';
if pos(upc(f),upc(s))=0 then fatal_call('8');
delete(s,1,length(f));
val(s,ltype[n].price,error);
if error<>0 then fatal_call('P');

readln(w,s);
f:='possess=';
if pos(upc(f),upc(s))=0 then fatal_call('9');
delete(s,1,length(f));
if (upc(s)<>'TRUE') and (upc(s)<>'FALSE') then fatal_call('H');
if upc(s)='TRUE' then ltype[n].possess:=true;
if upc(s)='FALSE' then ltype[n].possess:=false;

readln(w,s);
f:='damage=';
if pos(upc(f),upc(s))=0 then fatal_call('Z');
delete(s,1,length(f));
val(s,ltype[n].damage,error);
if error<>0 then fatal_call('D');

readln(w,s);
f:='range=';
if pos(upc(f),upc(s))=0 then fatal_call('Y');
delete(s,1,length(f));
val(s,ltype[n].range,error);
if error<>0 then fatal_call('R');

readln(w,s);
f:='limit=';
if pos(upc(f),upc(s))=0 then fatal_call('X');
delete(s,1,length(f));
val(s,ltype[n].limit,error);
if error<>0 then fatal_call('T');

readln(w,s);
f:='orrientation=';
if pos(upc(f),upc(s))=0 then fatal_call('W');
delete(s,1,length(f));
val(s,ltype[n].orrientation,error);
if error<>0 then fatal_call('O');

ltype[n].num:=0;

inc(n);
until eof(w);
close(w);
end;

procedure load_game_enemies;
var w:text;
    s,f:string;
    n:byte;

procedure fatal_call(n:char);
begin
fatal(concat('PROC[LOAD_GAME_ENEMIES] (',n,')- CORRUPTED CRUCIAL FILE: ENEMY.INF'));
end;

begin
assign(w,concat(workdirec,'\enemy.inf'));
{$i-}
reset(w);
{$i+}
if ioresult<>0 then fatal('PROC[LOAD_GAME_ENEMIES]- CANNOT FIND CRUCIAL FILE: ENEMY.INF');
readln(w,s);
n:=1;
repeat

readln(w,s);
if s<>'[New]' then fatal_call('1');

readln(w,s);
f:='picture name=';
if pos(upc(f),upc(s))=0 then fatal_call('2');
delete(s,1,length(f));
et[n].picn:=find_pic(s);
et[n].midx:=pics[et[n].picn].xdim div 2;
et[n].midy:=pics[et[n].picn].ydim div 2;
readln(w,s);

f:='point value=';
if pos(upc(f),upc(s))=0 then fatal_call('3');
delete(s,1,length(f));
val(s,et[n].point_value,error);
if error<>0 then fatal_call('A');

readln(w,s);
f:='strength=';
if pos(upc(f),upc(s))=0 then fatal_call('4');
delete(s,1,length(f));
val(s,et[n].strength,error);
if error<>0 then fatal_call('B');

readln(w,s);
f:='jump=';
if pos(upc(f),upc(s))=0 then fatal_call('5');
delete(s,1,length(f));
val(s,et[n].jump,error);
if error<>0 then fatal_call('C');

readln(w,s);
f:='delay=';
if pos(upc(f),upc(s))=0 then fatal_call('6');
delete(s,1,length(f));
val(s,et[n].del,error);
if error<>0 then fatal_call('D');


readln(w,s);
f:='ram damage=';
if pos(upc(f),upc(s))=0 then fatal_call('7');
delete(s,1,length(f));
val(s,et[n].damage_by_ram,error);
if error<>0 then fatal_call('E');


readln(w,s);
f:='weapon type=';
if pos(upc(f),upc(s))=0 then fatal_call('8');
delete(s,1,length(f));
val(s,et[n].wnum,error);
if error<>0 then fatal_call('F');


readln(w,s);
f:='chance of shot=';
if pos(upc(f),upc(s))=0 then fatal_call('9');
delete(s,1,length(f));
val(s,et[n].chance_of_shot,error);
if error<>0 then fatal_call('G');

readln(w,s);
f:='weapon power=';
if pos(upc(f),upc(s))=0 then fatal_call('Z');
delete(s,1,length(f));
val(s,et[n].weap_pow,error);
if error<>0 then fatal_call('H');

readln(w,s);
f:='orrientation=';
if pos(upc(f),upc(s))=0 then fatal_call('Z');
delete(s,1,length(f));
val(s,et[n].orrientation,error);
if error<>0 then fatal_call('H');

inc(n);
until (eof(w)) or (n>max_types_of_enemies);
if n>max_types_of_enemies then fatal('PROC[LOAD_GAME_ENEMIES]- MAX. NUM OF ENEMIES USED');
close(w);
{[New]
picture name=bship1
point value=50
strength=2
jump=3
delay=20
ram damage=20
weapon type=Class I Lasers
chance of shot=30
orrientation=24}
end;

procedure load_initial_star_pattern;
var c:byte;
begin
c:=1;
repeat
s[c].x:=random(639);
s[c].y:=random(458)+20;
inc(c);
until c>num_of_stars;
end;


procedure new_animation(name,patname:s10; del:integer; repeater:boolean; x,y:integer);
var p,n:byte;
begin
p:=find_pattern(patname);
n:=find_next_mover;
mov[n].bpic:=ani[p].bpic;
mov[n].lpic:=ani[p].lpic;
mov[n].name:=name;
mov[n].patname:=patname;
mov[n].cdel:=0;
mov[n].repeater:=repeater;
mov[n].onpic:=ani[p].bpic;
mov[n].del:=del;
mov[n].x:=x;
mov[n].y:=y;
end;

procedure delete_mov_by_num(n:byte);
begin
bar(mov[n].x,mov[n].y,mov[n].x+pics[mov[n].onpic].xdim,mov[n].y+pics[mov[n].onpic].ydim);
if mov[n+1].name='' then mov[n].name:='';
if mov[n+1].name<>'' then
begin
repeat
mov[n]:=mov[n+1];
inc(n);
until mov[n+1].name='';
end;
end;

procedure delete_mov_by_name(name:s10);
var n:byte;
begin
n:=find_mover(name);
bar(mov[n].x,mov[n].y,mov[n].x+pics[mov[n].onpic].xdim,mov[n].y+pics[mov[n].onpic].ydim);
if mov[n+1].name='' then mov[n].name:='';
if mov[n+1].name<>'' then
begin
repeat
mov[n]:=mov[n+1];
mov[n+1].name:='';
inc(n);
until mov[n+1].name='';
end;
end;

procedure change_mov_xy_by_name(name:s10; x,y:integer; clear:boolean);
var n:byte;
begin
n:=find_mover(name);
if clear=true then
begin
bar(mov[n].x,mov[n].y,mov[n].x+pics[mov[n].onpic].xdim,mov[n].y+pics[mov[n].onpic].ydim);
end;
mov[n].x:=x;
mov[n].y:=y;
end;

procedure force_mover_frame(n:byte);
begin
putimage(mov[n].x,mov[n].y,pics[mov[n].onpic].pic^,normalput);
end;

procedure change_mov_xy_by_num(n:byte; x,y:integer; clear:boolean);
begin
if clear=true then
begin
bar(mov[n].x,mov[n].y,mov[n].x+pics[mov[n].onpic].xdim,mov[n].y+pics[mov[n].onpic].ydim);
end;
mov[n].x:=x;
mov[n].y:=y;
force_mover_frame(n);
end;

procedure show_animation_frame(n:byte);
begin
putimage(mov[n].x,mov[n].y,pics[mov[n].onpic].pic^,normalput);
inc(mov[n].onpic);
mov[n].cdel:=0;

if mov[n].onpic>mov[n].lpic then
begin
mov[n].onpic:=mov[n].bpic;
if mov[n].repeater=false then
begin
delete_mov_by_num(n);
end;
end;
end;

procedure change_ini(s:string; val:string);
var t,w:text;
    s1,s2:string;
begin
assign(w,workdirec+'\ship.ini');
assign(t,workdirec+'\ini.%mp');
rewrite(t);
{$i-}
reset(w);
{$i+}
if ioresult<>0 then fatal('PROC[CHANGE_INI]- CANNOT FIND CRUCIAL FILE: SHIP.INI');
repeat
readln(w,s1);
readln(w,s2);
if s1<>s then
begin
writeln(t,s1);
writeln(t,s2);
end;
until eof(w);
writeln(t,s);
writeln(t,val);
reset(t);
rewrite(w);
repeat
readln(t,s1);
writeln(w,s1);
until eof(t);
close(t);
close(w);
end;

function find_ini(s:string):string;
var t:text;
    f:string;
begin
assign(t,'ship.ini');
{$i-}
reset(t);
{$i+}
if ioresult<>0 then fatal('PROC[FIND_INI]- CANNOT FIND CRUCIAL FILE: SHIP.INI');
repeat
readln(t,f);
until (eof(t)) or (upc(s)=upc(f));
if upc(s)<>upc(f) then fatal('PROC[FIND_INI]- CANNOT FIND INI ENTRY: '+S);
readln(t,f);
find_ini:=f;
close(t);
end;

procedure clean;
begin
total:=0;
slowdown:=1;
nostar:=false;
if find_ini('[Stars]')='OFF' then nostar:=true;
val(find_ini('[Slow down]'),slowdown,error);
bgidirec:=find_ini('[Bgi Directory]');
picdirec:=find_ini('[Picture Directory]');
workdirec:=find_ini('[Work Directory]');
mp.filen:=workdirec+'\mainmap.jjm';
ginit640x480x16(bgidirec);
initevents;
mouse_chk;
hidemouse;
onweapon:=1;
clean_pics;
clean_animations;
clean_movers;
clean_weapon_types;
clean_lasers;
clean_enemies;
clean_map;
clean_explosions;
setvisualpage(0);
setactivepage(0);
cleardevice;
setcolor(3);
outtextxy(0,0,'Loading graphics...');
setactivepage(1);
load_game_pictures;
load_game_ani;
load_game_weapons;
load_game_enemies;
clean_stars;
load_initial_star_pattern;
setactivepage(0);
hidemouse;
proc:='start';
sx:=(639 div 2) - (pics[1].xdim div 2);
fy:=(479-(pics[find_pic('burn1')].ydim));
sy:=(fy-(pics[1].ydim));
flamex:=(pics[1].xdim div 2)-(pics[find_pic('burn1')].xdim div 2);
gship_strength_total:=initial_shields;
gship_strength:=initial_shields;
lmy:=0;
lmx:=0;
money:=initial_money;
cleardevice;
setfillstyle(1,0);
cont:=0;
end;

procedure remove_laser(c:byte);
begin
if las[c].y<0 then las[c].y:=0;
bar(las[c].x,las[c].y,las[c].x+(pics[ltype[onweapon].picn].xdim-1),las[c].y+(pics[ltype[onweapon].picn].ydim-1));
repeat
las[c]:=las[c+1];
las[c+1].x:=-1;
inc(c);
until (las[c+1].x=-1) or (c>max_num_of_lasers);
if onlaser>0 then dec(onlaser);
update_board(2);
end;

procedure remove_exp(c:byte);
var l,m:byte;
begin
l:=exp[c].dim div 2;
bar(exp[c].x-l,exp[c].y-l,exp[c].x+l,exp[c].y+l);
bar(exp[c].x-25,exp[c].y-25,exp[c].x+25,exp[c].y+25);
repeat
exp[c]:=exp[c+1];
exp[c+1].x:=-1;
inc(c);
until (exp[c+1].x=-1) or (c>max_num_of_explosions);
dec(onexp);
end;

procedure remove_elaser(c:byte);
begin
bar(elas[c].x,elas[c].y,elas[c].x+(pics[ltype[elas[c].ltype].picn].xdim-1),elas[c].y+(pics[ltype[elas[c].ltype].picn].ydim-1));
repeat
elas[c]:=elas[c+1];
elas[c+1].x:=-1;
inc(c);
until (elas[c+1].x=-1) or (c>max_num_of_enemy_lasers);
if eonlaser>0 then dec(eonlaser);
end;

procedure remove_enemy(c:byte; remove:boolean);
begin
e[c].stage:=0;
if remove=true then bar(e[c].x,e[c].y,e[c].x+(pics[et[e[c].et].picn].xdim-1),e[c].y+(pics[et[e[c].et].picn].ydim-1));
repeat
e[c]:=e[c+1];
e[c+1].x:=-1;
inc(c);
until (e[c+1].x=-1) or (c>max_num_of_enemies);
dec(onenemy);
end;

procedure mess(mes:char; col:byte; on:boolean);
begin
if on=false then
begin
setfillstyle(1,7);
bar(620,1,640,19);
clear_d:=false;
setfillstyle(1,0);
end;
if on=true then
begin
setfillstyle(1,col);
bar(620,1,640,19);
setcolor(white);
outtextxy(627,9,mes);
setfillstyle(1,0);
clear_d:=true;
end;
end;

procedure explode(x,y:integer;dim:byte);
begin
if onexp+1<max_num_of_explosions then
begin
inc(onexp);
exp[onexp].x:=x;
exp[onexp].y:=y;
exp[onexp].dim:=dim;
exp[onexp].on:=0;
exp[onexp+1].x:=-1;
exp[onexp+1].y:=-1;
exp[onexp+1].dim:=0;
exp[onexp+1].on:=0;
end;
end;

procedure damage_gship(c:integer);
var ch:byte;
begin
if ltype[19].possess=true then
begin
ch:=random(2);
if ch=0 then dec(gship_strength,(c div 2));
if ch=1 then dec(gship_strength,c);
end;
if ltype[19].possess=false then dec(gship_strength,c);
update_board(1);
if ltype[17].possess=true then mess('D',red,true);
if gship_strength<=0 then proc:='kill';
end;

procedure destroy_enemy(ec:byte);
begin
explode(e[ec].x+(pics[et[e[ec].et].picn].xdim div 2),
e[ec].y+(pics[et[e[ec].et].picn].ydim div 2),pics[et[e[ec].et].picn].xdim);
inc(money,et[e[ec].et].point_value);
update_board(3);
remove_enemy(ec,false);
end;

procedure chk_laser_position;
var n,ec,lc:byte;
begin
ec:=1;
repeat
lc:=1;
repeat
if (las[lc].x>(e[ec].x-ltype[onweapon].range)) and (las[lc].x<(e[ec].x+pics[et[e[ec].et].picn].xdim+ltype[onweapon].range))then
begin
if (las[lc].y+ltype[onweapon].jump>e[ec].y) and (las[lc].y<(e[ec].y+pics[et[e[ec].et].picn].ydim)+ltype[onweapon].jump) then
begin
remove_laser(lc);
dec(e[ec].strength,ltype[onweapon].damage);
end;
end;

inc(lc);
until lc>onlaser;
inc(ec);
until ec>onenemy;

ec:=1;
repeat
if e[ec].strength<=0 then
begin
e[ec].cdel:=0;
destroy_enemy(ec);
end;
inc(ec);
until ec>onenemy;

end;

procedure chk_enemy_laser_position;
var lc:byte;
begin
lc:=1;
repeat
if (elas[lc].x>sx-ltype[elas[lc].ltype].range) and (elas[lc].x<sx+pics[1].xdim+ltype[elas[lc].ltype].xdim) then
begin
if elas[lc].y>sy-pics[ltype[elas[lc].ltype].picn].ydim then
begin
damage_gship(et[elas[lc].et].weap_pow);
remove_elaser(lc);
end;
end;
inc(lc);
until lc>eonlaser;
end;

procedure chk_enemy_position;
var ec:byte;
    w:integer;
begin
ec:=1;
repeat
w:=e[ec].x+pics[et[e[ec].et].picn].xdim;
if e[ec].y+pics[et[e[ec].et].picn].ydim>sy then
begin
if ((e[ec].x<sx+pics[1].xdim) and (e[ec].x>sx)) or ((w<sx+pics[1].xdim) and (w>sx)) then
begin
damage_gship(et[e[ec].et].damage_by_ram);
destroy_enemy(ec);
end;
end;
inc(ec);
until ec>onenemy;
end;

procedure update_exp;
var c,d:byte;
begin
if onexp>0 then
begin
c:=1;
repeat
if exp[c].on=255 then remove_exp(c);
inc(c);
until c>onexp;

c:=1;
repeat
inc(exp[c].on);
exp[c].last:=exp[c].on;
if (exp[c].on=5) then showpic_by_num(b50,exp[c].x-25,exp[c].y-25);
if (exp[c].dim>40) and (exp[c].on=5) then exp[c].on:=255;
if (exp[c].on=4) then showpic_by_num(b40,exp[c].x-20,exp[c].y-20);
if (exp[c].dim<=40) and (exp[c].on=4) then exp[c].on:=255;
if (exp[c].on=3) then showpic_by_num(b30,exp[c].x-15,exp[c].y-15);
if (exp[c].dim<=30) and (exp[c].on=3) then exp[c].on:=255;
if (exp[c].on=2) then showpic_by_num(b20,exp[c].x-10,exp[c].y-10);
if (exp[c].dim<=20) and (exp[c].on=2) then exp[c].on:=255;
if (exp[c].on=1) then showpic_by_num(b10,exp[c].x-5,exp[c].y-5);
if (exp[c].dim<=10) and (exp[c].on=1) then exp[c].on:=255;
inc(c);
until c>onexp;
end;

end;

procedure update_stars;
var c:byte;
    ly:integer;
begin
s_cdel:=0;
c:=1;
repeat
bar(s[c].x,s[c].y,s[c].x+(pics[s[c].picn].xdim-1),s[c].y+(pics[s[c].picn].ydim-1));
ly:=s[c].y;
if s[c].stype=1 then inc(s[c].y,6+warp);
if s[c].stype=2 then inc(s[c].y,10+warp);
if s[c].stype=3 then inc(s[c].y,3+warp);
if s[c].y>479 then
begin
s[c].y:=ly;
bar(s[c].x,s[c].y,s[c].x+(pics[s[c].picn].xdim-1),s[c].y+(pics[s[c].picn].ydim-1));
s[c].y:=20;
s[c].x:=random(638)+1;
end;
showpic_by_num(s[c].picn,s[c].x,s[c].y);
inc(c);
until c>num_of_stars;
end;

procedure update_lasers;
var c:byte;
    ly:integer;
begin
ltype[onweapon].cdel:=0;
c:=1;
if onlaser>0 then
begin
repeat
bar(las[c].x,las[c].y-ltype[onweapon].jump,
las[c].x+(pics[ltype[onweapon].picn].xdim-1),las[c].y+(pics[ltype[onweapon].picn].ydim-1));
ly:=las[c].y;
dec(las[c].y,ltype[onweapon].jump);
if (las[c].y<23) then
begin
las[c].y:=ly;
remove_laser(c);
end;
inc(c);
until (las[c].x=-1) or (c>max_num_of_lasers);
c:=1;
while las[c].x<>-1 do
begin
showpic_by_num(ltype[onweapon].picn,las[c].x,las[c].y);
inc(c);
end;
end;
end;

procedure update_enemy_lasers;
var c:byte;
    ly:integer;
begin
c:=1;
repeat
bar(elas[c].x,(elas[c].y-(ltype[elas[c].ltype].jump+warp)),elas[c].x+(pics[ltype[elas[c].ltype].picn].xdim-1),
elas[c].y+(pics[ltype[elas[c].ltype].picn].ydim-1));
ly:=elas[c].y;
inc(elas[c].y,ltype[elas[c].ltype].jump+warp);
if elas[c].y>470 then
begin
elas[c].y:=ly;
remove_elaser(c);
end;
inc(c);
until (elas[c].x=-1) or (c>max_num_of_enemy_lasers);
c:=1;
while elas[c].x<>-1 do
begin
showpic_by_num(ltype[elas[c].ltype].picn,elas[c].x,elas[c].y);
inc(c);
end;
end;

procedure enemy_inteligence;
var c,ok_f:byte;
begin
c:=1;
if onenemy>0 then
begin
repeat
ok_f:=0;
if (sx<e[c].x+pics[et[e[c].et].picn].xdim) and (sx>e[c].x-pics[et[e[c].et].picn].xdim) then ok_f:=1;
if (random(et[e[c].et].chance_of_shot)=0) and (ok_f=1) and (et[e[c].et].wnum<>0) then fire_enemy_laser(c);
inc(c);
until c>onenemy;
end;
end;

procedure cant_save;
begin
restorecrtmode;
textcolor(white);
writeln('You cannot save the game while enemies are present');
writeln;
write('Hit enter to return to combat--');
readln;
ginit640x480x16(bgidirec);
setfillstyle(1,0);
prep_board;
update_board(255);
end;

procedure save_game;
var sg:text;
    name,t,s:string;
    c,cc:byte;
    func:char;
begin
restorecrtmode;
repeat
write('Enter a filename (or enter to cancel) [ex. mygame]: ');
readln(name);
if name<>'' then
begin
assign(sg,workdirec+'\'+name+'.sav');
func:='@';
{$i-}
reset(sg);
{$i+}
if ioresult<>0 then func:='Y';
if func='@' then
begin
writeln;
write('This file already exist! Overwrite [Y/N]?');
read(kbd,func);
func:=upcase(func);
if func='N' then close(sg);
end;
end;
until (func='Y') or (name='');
if name<>'' then
begin
rewrite(sg);
writeln(sg,mp.filen);
writeln(sg,mp.lastline);
c:=0;
repeat
writeln(sg,part[mp.on_part+c]);
inc(c);
until (part[mp.on_part+(c-1)]='') or (c=max_parts_of_map);
writeln(sg,'[End Parts]');
writeln(sg,onweapon);
writeln(sg,gship_strength-540);
writeln(sg,gship_strength_total-383);
str(money,t);
s:='';
repeat
val(t[1],c,error);
s:=s+char(c+65);
delete(t,1,1);
until t='';
writeln(sg,s);
c:=1;
s:='';
repeat
cc:=0;
if ltype[c].possess=true then s:=s+char(c+65);
inc(c);
until c>20;
writeln(sg,s);

close(sg);
end;
ginit640x480x16(bgidirec);
setfillstyle(1,0);
prep_board;
update_board(255);
end;

procedure load_game;
var sg:text;
    c,l,cc,db:byte;
    dirinfo:searchrec;
    s,name,t,d:string;
    func:char;
begin
restorecrtmode;
textmode(co80+font8x8);
textcolor(white);
write('Do you wish to load a new map or a saved ["N" new map/"S" saved game]: ');
read(kbd,func);
func:=upcase(func);

if func='N' then
begin
chdir(workdirec);
FindFirst('*.JJM', Archive, DirInfo);
c:=1;
db:=1;
while DosError = 0 do
begin
gotoxy(((c-1)*8)+1,5+(db-1));
if pos('.JJM',dirinfo.name)>0 then delete(dirinfo.name,pos('.JJM',dirinfo.name),4);
Writeln(DirInfo.Name);
inc(db);
if db>35 then
begin
db:=1;
inc(c);
end;
FindNext(DirInfo);
end;
gotoxy(1,1);
writeln('Enter the name of the map to setup (nothing to cancel)');
writeln('[ex. mymap]: ');
writeln('Any maps found are listed below--');
gotoxy(15,2);
readln(name);
if name<>'' then
begin
assign(map,workdirec+'\'+name+'.jjm');
l:=1;
{$i-}
reset(map);
{$i+}
if ioresult<>0 then l:=2;
if l=2 then
begin
clrscr;
writeln;
writeln('This file does not exist (remember it must be contained in :',workdirec,')');
writeln('Hit enter to continue--');
readln;
assign(map,concat(workdirec,'\mainmap.jjm'));
reset(map);
end;
if l=1 then
begin
close(map);
mp.lastline:=0;
mp.filen:=name+'.jjm';
clean_map;
clrscr;
writeln('Map successfully loaded-');
writeln('Start new game to play!');
writeln;
write('Hit enter to continue--');
readln;
ginit640x480x16(bgidirec);
end;
end;
end;

if func='S' then
begin
chdir(workdirec);
FindFirst('*.SAV', Archive, DirInfo);
c:=1;
db:=1;
while DosError = 0 do
begin
gotoxy(((c-1)*8)+1,5+(db-1));
if pos('.SAV',dirinfo.name)>0 then delete(dirinfo.name,pos('.SAV',dirinfo.name),4);
Writeln(DirInfo.Name);
inc(db);
if db>35 then
begin
db:=1;
inc(c);
end;
FindNext(DirInfo);
end;
gotoxy(1,1);
writeln('Enter the name of the file to restore (nothing to cancel)');
writeln('[ex. mygame]: ');
writeln('Any games found are listed below--');
gotoxy(15,2);
readln(name);
if name<>'' then
begin
assign(sg,workdirec+'\'+name+'.sav');
l:=1;
{$i-}
reset(sg);
{$i+}
if ioresult<>0 then l:=2;
if l=2 then
begin
clrscr;
writeln;
writeln('This file does not exist (remember it must be contained in :',workdirec,')');
writeln('Hit enter to continue--');
readln;
end;
if l=1 then
begin
reset(sg);
readln(sg,mp.filen);
readln(sg,mp.lastline);
c:=1;
repeat
readln(sg,s);
if s<>'[End Parts]' then part[c]:=s;
inc(c);
until s='[End Parts]';
mp.on_part:=1;
readln(sg,onweapon);
readln(sg,gship_strength);
inc(gship_strength,540);
readln(sg,gship_strength_total);
inc(gship_strength_total,383);
readln(sg,s);
t:='';
repeat
str(ord(s[1])-65,d);
t:=t+d;
clrscr;
delete(s,1,1);
until s='';
val(t,money,error);
if error<>0 then fatal('PROC[LOAD_GAME]- LOADING SAVED GAME!');
readln(sg,s);
repeat
ltype[ord(s[1])-65].possess:=true;
delete(s,1,1);
until s='';
close(sg);
{$i-}
close(map);
{$i+}
if ioresult<>0 then l:=1;
assign(map,mp.filen);
reset(map);
proc:='game';
clean_lasers;
clean_enemies;
end;
end;
end;
ginit640x480x16(bgidirec);
setfillstyle(1,0);
end;

procedure update_enemies;
var ly:integer;
    c:byte;
    p:string[2];
begin
c:=1;
if onenemy>0 then
begin
repeat
bar(e[c].x,e[c].y,e[c].x+(pics[et[e[c].et].picn].xdim-1),e[c].y+et[e[c].et].jump);
ly:=e[c].y;
inc(e[c].y,et[e[c].et].jump);
if (e[c].y+pics[et[e[c].et].picn].ydim-1)>479 then
begin
e[c].y:=ly;
remove_enemy(c,true);
end;
inc(c);
until (e[c].x=-1) or (c>max_num_of_enemies);
c:=1;
while e[c].x<>-1 do
begin
if e[c].stage=0 then showpic_by_num(et[e[c].et].picn,e[c].x,e[c].y);
inc(c);
end;
end;
end;

procedure kill_gship;
var x,y:integer;
begin
ginit640x480x16(bgidirec);
setfillstyle(1,0);
setcolor(4);
x:=(640 div 2) - (pics[1].xdim div 2);
y:=490;
repeat
delay(1);
showpic_by_num(1,x,y);
if random(10)+1=1 then
begin
explode(x+(pics[1].xdim div 2),y+(pics[1].ydim div 2),52);
end;
if y mod 20=0 then update_exp;
dec(y);
until y=1;
bar(x,y,x+pics[1].xdim,y+pics[1].ydim);
settextstyle(defaultfont,0,10);
outtextxy(0,300,'You Died');
readln;
proc:='finish';
cont:=0;
settextstyle(defaultfont,0,1);
cleardevice;
end;

procedure change_weapon(c:byte);
var n:byte;
begin
if ltype[c].possess=true then
begin
if onlaser>0 then
begin
repeat
remove_laser(1);
until onlaser=0;
end;
onweapon:=c;
update_board(4);
end;
end;

procedure station;
var men:array[1..13] of string[12];
    hit:string[12];
    mevent:tevent;
    ll,button,button_p:byte;
    mon:array[1..10] of byte;
    del:byte;

procedure prep;
var c:byte;
begin
c:=1;
repeat
men[c]:='@';
inc(c);
until c>13;
end;

procedure menu;
var c:byte;
begin
hidemouse;
c:=1;
repeat
showpic_by_num(button,0,(c-1)*24);
inc(c);
until men[c]='@';
c:=1;
repeat
setcolor(3);
outtextxy(((100-(length(men[c])*8)) div 2)+2,((c-1)*24)+5,men[c]);
inc(c);
until men[c]='@';
showmouse;
end;

procedure un_highlight(c:byte);
begin
if men[c]<>'@' then
begin
hidemouse;
showpic_by_num(button,0,(c-1)*24);
setcolor(3);
outtextxy(((100-(length(men[c])*8)) div 2)+2,((c-1)*24)+5,men[c]);
showmouse;
end;
end;

procedure highlight(c:byte);
begin
if men[c]<>'@' then
begin
hidemouse;
if ll<>255 then un_highlight(ll);
ll:=c;
showpic_by_num(button_p,0,(c-1)*24);
setcolor(0);
outtextxy(((100-(length(men[c])*8)) div 2)+2,((c-1)*24)+5,men[c]);
showmouse;
end;
end;

procedure stats;
var frx:byte;
    nn,nn2,nn3:string;

procedure wri_s(li:string; n:byte);
begin
outtextxy(225,75+(n*10),li);
end;


begin
setlinestyle(1,1,3);
setcolor(7);
bar(220,70,620,300);
rectangle(220,70,620,300);
setcolor(8);
setlinestyle(0,0,3);
rectangle(217,67,623,303);
rectangle(220,320,300,340);
if onweapon<=16 then showpic_by_num(ltype[onweapon].picn,ltype[onweapon].orrientation+617-(pics[1].xdim+5),75);
frx:=75+pics[ltype[onweapon].picn].ydim;
showpic_by_num(1,617-(pics[1].xdim+5),frx+10);
setcolor(white);
outtextxy(350,74,'Ship statistics');

setcolor(2);

str(money,nn);
wri_s(concat('Money: $',nn),2);

str((gship_strength*1000),nn);
str((gship_strength_total*1000),nn2);
wri_s(concat('Shields status: ',nn,char(234),' of ',nn2,char(234)),3);

wri_s(concat('Weapon type: ',ltype[onweapon].name),4);

if onweapon<=16 then
begin
wri_s('Weapon Diagnostic-',5);

str(ltype[onweapon].jump,nn);
wri_s(concat('Speed: ',nn),6);
str(ltype[onweapon].damage,nn);
wri_s(concat('Damage: ',nn),7);
str(ltype[onweapon].range,nn);
wri_s(concat('Range: ',nn),8);
str(ltype[onweapon].limit,nn);
wri_s(concat('Cooling rate: ',nn),9);
if onweapon<=9 then
begin
str(onweapon,nn);
wri_s(concat('Quick Call Key: ',nn),10);
end;
if onweapon>9 then
begin
if onweapon=10 then nn:='0';
if onweapon=11 then nn:='Q';
if onweapon=12 then nn:='W';
if onweapon=13 then nn:='E';
if onweapon=14 then nn:='R';
if onweapon=15 then nn:='T';
if onweapon=16 then nn:='Y';
wri_s(concat('Quick Call Key: ',nn),10);
end;
end;
if onweapon in [11..16] then
begin
str(ltype[onweapon].num,nn);
str(ltype[onweapon].link_space,nn2);
wri_s(concat('Missle Track contains: ',nn,' of ',nn2,'max'),11);
end;
end;

procedure monitor;
var c:byte;
begin
hidemouse;
floodfill(225,325,8);
setcolor(3);
c:=1;
repeat
line(223+((c-1)*8),337,223+((c-1)*8),323+(mon[c]));
inc(c);
until c>10;
c:=1;
repeat
mon[c]:=mon[c+1];
inc(c);
until c=10;
mon[10]:=random(10)+1;
showmouse;
end;

procedure chk_buttons;
var num:byte;
begin
num:=0;
repeat
inc(num);
until men[num]='@';
dec(num);
if not(mevent.where.x in [0..11]) then
begin
if ll<>255 then un_highlight(ll);
ll:=255;
end;
if mevent.where.x in [0..11] then
begin
if mevent.where.y in [0..num*3] then
begin

if mevent.what<>evnothing then
begin
if mevent.where.y in [0..1] then highlight(1);
if mevent.where.y in [3..4] then highlight(2);
if mevent.where.y in [6..7] then highlight(3);
if mevent.where.y in [9..10] then highlight(4);
if mevent.where.y in [12..13] then highlight(5);
if mevent.where.y in [15..16] then highlight(6);
if mevent.where.y in [18..19] then highlight(7);
if mevent.where.y in [21..22] then highlight(8);
if mevent.where.y in [24..25] then highlight(9);
if mevent.where.y in [27..28] then highlight(10);
if mevent.where.y in [30..31] then highlight(11);
if mevent.where.y in [33..34] then highlight(12);
if mevent.where.y in [36..37] then highlight(13);
end;

if mevent.buttons=mbleftbutton then
begin
hit:=men[ll];
end;

end;
end;
end;

procedure clean_monitor;
var c:byte;
begin
c:=1;
repeat
mon[c]:=random(10)+1;
inc(c);
until c>10;
end;

procedure repair;
begin
cleardevice;
prep;
men[1]:='Repair $100';
men[2]:='Repair $300';
men[3]:='Repair $500';
men[4]:='Main menu';
menu;
stats;
showmouse;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
if del=255 then monitor;

if hit='Repair $100' then
begin
if (gship_strength+1<=gship_strength_total) and (money>=100) then
begin
dec(money,100);
inc(gship_strength);
stats;
hit:='';
end;
end;

if hit='Repair $300' then
begin
if (gship_strength+3<=gship_strength_total) and (money>=300) then
begin
dec(money,300);
inc(gship_strength,3);
stats;
hit:='';
end;
end;

if hit='Repair $500' then
begin
if (gship_strength+5<=gship_strength_total) and (money>=500) then
begin
dec(money,500);
inc(gship_strength,5);
stats;
hit:='';
end;
end;

until hit='Main menu';
end;

procedure buy_weap;
var c,num_w:byte;

procedure buy(n:byte);
var bef:byte;
begin
hidemouse;
cleardevice;
bef:=onweapon;
onweapon:=n;
dec(money,ltype[n].price);
stats;
prep;
men[1]:='Buy';
men[2]:='Back';
menu;
hit:='';
showmouse;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
if del=255 then monitor;
until hit<>'';
if hit='Buy' then
begin
ltype[onweapon].possess:=true;
if onweapon in [11..16] then
begin
inc(ltype[onweapon].num,ltype[onweapon].link);
if ltype[onweapon].num>ltype[onweapon].link_space then ltype[onweapon].num:=ltype[onweapon].link_space;
end;
hit:='Main menu';
end;
if hit='Back' then
begin
inc(money,ltype[onweapon].price);
onweapon:=bef;
end;
end;

procedure section1;

procedure again;
var sp:string;
begin
hidemouse;
cleardevice;
str(money,sp);
setcolor(white);
outtextxy(500,0,'Money: $'+sp);
prep;
c:=1;
setcolor(3);
repeat
str(c,men[c]);
men[c]:=concat(men[c],'.');
str(ltype[c].price,sp);
setcolor(3);
if (money<ltype[c].price) or (ltype[c].possess=true) then setcolor(4);
if ltype[c].des<>'' then outtextxy(115,(c-1)*24,ltype[c].name+' '+ltype[c].des+' $'+sp);
if ltype[c].des='' then outtextxy(115,(c-1)*24,ltype[c].name+' $'+sp);
inc(c);
until c>10;
men[11]:='Section ][';
men[12]:='Main menu';
menu;
{stats;}
showmouse;
hit:='';
end;

begin
again;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
{if del=255 then monitor;}
if hit<>'' then
begin
c:=1;
if pos('.',hit)<>0 then delete(hit,pos('.',hit),1);
val(hit,c,error);
if (error=0) and (money>=ltype[c].price) and (ltype[c].possess=false) then buy(c);
if hit='Back' then again;
end;
until (hit='Main menu') or (hit='Section ][');
end;

procedure section2;

procedure again;
var sp:string;
begin
hidemouse;
cleardevice;
prep;
str(money,sp);
setcolor(white);
outtextxy(500,0,'Money: $'+sp);
c:=1;
setcolor(3);
repeat
str(c,men[c]);
str(ltype[c+10].price,sp);
men[c]:=concat(men[c],'.');
setcolor(3);
if not(c+10 in [11..16]) then if (money<ltype[c+10].price) or (ltype[c+10].possess=true) then setcolor(4);
if (c+10 in [11..16]) then if (ltype[c+10].link>ltype[c+10].link_space) or (money<ltype[c+10].price) then setcolor(4);
if ltype[c+10].des<>'' then outtextxy(115,(c-1)*24,ltype[c+10].name+' '+ltype[c+10].des+' $'+sp);
if ltype[c+10].des='' then outtextxy(115,(c-1)*24,ltype[c+10].name+' $'+sp);
inc(c);
until c>10;
men[11]:='Section I';
men[12]:='Main menu';
menu;
{stats;}
showmouse;
hit:='';
end;

begin
again;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
{if del=255 then monitor;}
if hit<>'' then
begin
c:=1;
if pos('.',hit)<>0 then delete(hit,pos('.',hit),1);
val(hit,c,error);
if not(c+10 in [11..16]) then if (error=0) and (money>=ltype[c+10].price) and (ltype[c+10].possess=false) then buy(c+10);
if (c+10 in [11..16]) then if (ltype[c+10].link<ltype[c+10].link_space) and (error=0) and (money>=ltype[c+10].price)
then buy(c+10);
if hit='Back' then again;
end;
until (hit='Main menu') or (hit='Section I');
end;

begin
num_w:=0;
repeat
inc(num_w);
until ltype[num_w].name='';
dec(num_w);
cleardevice;
hit:='Section I';
showmouse;
repeat
if hit='Section ][' then section2;
if hit='Section I' then section1;
until hit='Main menu';
end;

procedure upgrade_shields;
var price:longint;
    s:string;
begin
hidemouse;
cleardevice;
stats;
prep;
price:=(((gship_strength_total-40) div 10)*5000)+5000;;
str(price,s);
men[1]:='1000'+char(234)+'-$'+s;
men[2]:='Done';
menu;
showmouse;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
if del=255 then monitor;
if hit='1000'+char(234)+'-$'+s then
begin
if money>=price then
begin
dec(money,price);
inc(gship_strength_total);
gship_strength:=gship_strength_total;
stats;
hit:='';
end;
end;
until hit='Done';
end;

procedure main;
begin
hidemouse;
cleardevice;
prep;
men[1]:='Items';
men[2]:='Repair';
men[3]:='Shields';
men[4]:='View Weapons';
men[5]:='Leave';
menu;
stats;
hit:='';
showmouse;
end;

procedure dock;
var x:integer;
    nn:byte;
begin
change_weapon(onweapon);
x:=0;
nn:=find_pic('dock');
if sx-3>pics[nn].xdim then
begin
repeat
delay(4);
showpic_by_num(nn,x,sy);
inc(x);
if x mod (6*slowdown)=0 then
begin
if nostar=false then update_stars;
showpic_by_num(1,sx,sy);
end;
until (x+(pics[nn].xdim)>=sx-3);
end;
delay(2000);
end;

begin
dock;
ginit640x480x16(bgidirec);
setfillstyle(1,0);
cleardevice;
ll:=255;
button:=find_pic('button');
button_p:=find_pic('button_p');
clean_monitor;

main;
del:=0;
hit:='';
showmouse;
repeat
delay(1);
inc(del);
getmouseevent(mevent);
chk_buttons;
if del=255 then monitor;

if hit='Repair' then
begin
repair;
main;
end;
if hit='Items' then
begin
buy_weap;
main;
end;
if hit='View Weapons' then
begin
repeat
inc(onweapon);
if onweapon>20 then onweapon:=1;
until ltype[onweapon].possess=true;
main;
end;
if hit='Shields' then
begin
upgrade_shields;
main;
end;
until hit='Leave';
if onweapon>16 then onweapon:=1;
hidemouse;
cleardevice;
prep_board;
update_board(255);
change_weapon(onweapon);
end;

procedure move;
var chk:byte;
begin
getkeyevent(kevent);
getmouseevent(moevent);

if kevent.what=evkeydown then
begin
case kevent.keycode of
kbright:direct:=1;
kbleft:direct:=2;
kbup,kbdown:direct:=0;
end;
case upcase(kevent.charcode) of
'M':proc:='menu';
' ':if ltype[20].link_space=0 then fire_laser;
'S':
begin
if onenemy=0 then save_game;
if onenemy<>0 then cant_save;
end;
'`':
begin
chk:=0;
if (ltype[20].possess=true) and (ltype[20].link_space=0) then
begin
chk:=1;
ltype[20].link_space:=1;
warp:=10;
end;
if (ltype[20].possess=true) and (ltype[20].link_space=1) and (chk=0) then
begin
warp:=0;
ltype[20].link_space:=0;
end;
end;
'1':change_weapon(1);
'2':change_weapon(2);
'3':change_weapon(3);
'4':change_weapon(4);
'5':change_weapon(5);
'6':change_weapon(6);
'7':change_weapon(7);
'8':change_weapon(8);
'9':change_weapon(9);
'0':change_weapon(10);
'Q':change_weapon(11);
'W':change_weapon(12);
'E':change_weapon(13);
'R':change_weapon(14);
'T':change_weapon(15);
'Y':change_weapon(16);
end;
end;

if moevent.what<>evnothing then
begin
if (moevent.buttons=mbleftbutton) and (ltype[20].link_space=0) then fire_laser;
if moevent.where.x>lmx then direct:=1;
if moevent.where.x<lmx then direct:=2;
if moevent.buttons=mbrightbutton then direct:=0;
lmx:=moevent.where.x;
end;

if direct=1 then inc(sx,2);
if direct=2 then dec(sx,2);
if (sx+pics[1].xdim)>638 then sx:=638-pics[1].xdim;
if sx<2 then sx:=2;
showpic_by_num(1,sx,sy);
if direct<>0 then change_mov_xy_by_num(burn_num,sx+flamex,fy,false);

end;

procedure read_map;
var s:string;
    n:longint;
    o:byte;
    x,y:integer;

procedure fatal_call(nt:char);
begin
fatal(concat('PROC[READ_MAP]- CORRUPTED MAP: ',mp.filen));
end;

begin
mp.del:=0;
global_del:=1;
o:=mp.on_part;

if part[o][1]='E' then
begin
delete(part[o],1,2);
s:=copy(part[o],1,pos('.',part[o])-1);
delete(part[o],1,pos('.',part[o]));
val(s,n,error);
if error<>0 then fatal_call('D');
make_enemy(n);
end;

if part[o][1]='F' then
begin
delete(part[o],1,2);
s:=copy(part[o],1,pos('.',part[o])-1);
delete(part[o],1,pos('.',part[o]));
val(s,n,error);
if error<>0 then fatal_call('D');
x:=n;
s:=copy(part[o],1,pos('.',part[o])-1);
delete(part[o],1,pos('.',part[o]));
val(s,n,error);
if error<>0 then fatal_call('D');
make_enemy_fixed(n,x);
end;

if part[o][1]='D' then
begin
delete(part[o],1,2);
s:=copy(part[o],1,pos('.',part[o])-1);
delete(part[o],1,pos('.',part[o]));
val(s,n,error);
if error<>0 then fatal_call('D');
mp.del:=n;
end;

if ((part[o][1]='S') and (onenemy>0)) or ((length(part[o])<15) and (part[o][length(part[o])]='S')) then
begin
if ltype[18].possess=true then mess('S',blue,true);
end;

if (part[o][1]='S') and (onenemy=0) and (onexp=0) and (eonlaser=0) then
begin
station;
load_next;
end;

if part[o]='' then
begin
inc(mp.on_part);
if mp.on_part>max_parts_of_map then fatal('PROC[READ_MAP]-CORRUPTED PATTERN');
end;

end;

procedure multitasker;
var c:byte;
begin

if ltype[20].link_space=0 then delay(1);

{inc global timer}
inc(global_del);
{End. inc global timer}

{inc enemy weapon delay}
inc(eweap);
{End.inc enemy weapon delay}

{inc star delay}
inc(s_cdel);
{End. inc star delay}

{inc mover delays}
c:=1;
while mov[c].name<>'' do
begin
inc(mov[c].cdel);
inc(c);
end;
{End. inc mover delays}
{inc weapon delay}
inc(ltype[onweapon].cdel);
{End. inc weapon delay}

{check mover timers}
c:=1;
while mov[c].name<>'' do
begin
if mov[c].cdel>=mov[c].del*slowdown then show_animation_frame(c);
inc(c);
end;
{End. check mover timers}

{check weapon timer}
if (ltype[onweapon].cdel>=ltype[onweapon].del*slowdown) then
begin
update_lasers;
{check lasers}
if (onlaser>0) and (onenemy>0) then chk_laser_position;
{End. check lasers}
end;
{End. check weapon timer}

{check enemy weapon timer}
if eweap>3*slowdown then
begin
eweap:=0;
if eonlaser>0 then update_enemy_lasers;
{check enemy lasers}
if (eonlaser>0) then chk_enemy_laser_position;
{End. check enemy lasers}
move;
end;
{End. check enemy weapon timer}

{check default timer}
{if s_cdel mod 15=0 then
begin
update_exp;
end;}
if s_cdel>=20*slowdown then
begin
update_exp;
if nostar=false then update_stars;
if nostar=true then s_cdel:=0;
update_enemies;
if ltype[20].link_space=0 then enemy_inteligence;
if clear_d=true then mess('D',red,false);
if onenemy>0 then chk_enemy_position;
end;
{End. check star timer}

if proc='kill' then kill_gship;

{check for next action}
if global_del>mp.del*slowdown then read_map;
{End. check for next action}

end;

function menu:string;
var name:string;
    men:array[1..10] of string;
    nom,on,l_on,open_num:byte;
    func:char;

procedure clean_men;
var n:byte;
begin
n:=1;
nom:=0;
on:=1;
repeat
men[n]:='';
inc(n);
until n>10;
end;

procedure show_men;
var n:byte;
begin
cleardevice;
settextstyle(0,0,8);
cleardevice;
name:='IronClad';
setcolor(4);
outtextxy(((640-(length(name)*8*8))div 2)-6,26,name);
setcolor(7);
outtextxy(((640-(length(name)*8*8))div 2)-5,25,name);
setcolor(8);
outtextxy((640-(length(name)*8*8))div 2,20,name);
n:=1;
setcolor(red);
settextstyle(0,0,4);
repeat
outtextxy((640-(length(men[n])*8*4)) div 2,100+(n-1)*60,men[n]);
inc(nom);
inc(n);
until men[n]='';
end;

begin
clean_men;
if cont=0 then
begin
men[1]:='New Game';
men[2]:='Load Game/Map';
men[3]:='Options';
men[4]:='Help';
men[5]:='Quit';
end;
if cont=1 then
begin
men[1]:='New Game';
men[2]:='Continue';
men[3]:='Load Game/Map';
men[4]:='Options';
men[5]:='Help';
men[6]:='Quit';
end;
show_men;
func:='@';
new_animation('opener','opener',150,true,((640-(length(men[on])*8*4)) div 2)-60,100);
open_num:=find_mover('opener');
repeat
delay(1);
l_on:=on;
if keypressed then read(kbd,func);
if keypressed then read(kbd,func);
if func='P' then inc(on);
if func='H' then dec(on);
if on>nom then on:=1;
if on<1 then on:=nom;
if l_on<>on then
begin
change_mov_xy_by_num(open_num,((640-(length(men[on])*8*4)) div 2)-60,100+(on-1)*60,true);
end;
inc(mov[open_num].cdel);
if mov[open_num].cdel>=mov[open_num].del then show_animation_frame(open_num);
if func<>#13 then func:='@';
until func=#13;
menu:=men[on];
settextstyle(0,0,1);
delete_mov_by_num(open_num);
cleardevice;
end;

procedure help;
begin
restorecrtmode;
textmode(co80+font8x8);
textcolor(white);
writeln('Help file:');
writeln;
textcolor(blue);
writeln('Operating Systems:');
textcolor(white);
writeln('Not compatible with Windows 95 or Windows NT 4.0');
writeln('Not tested with Windows 3.x');
writeln('Works in all higher versions of PC-MS DOS');
writeln;
textcolor(blue);
writeln('Keys:');
textcolor(white);
writeln('Use the space bar (or left mouse button) to fire your selected weapon');
writeln('Use the right/left arrow keys to move respectively right/left');
writeln('You can also use the mouse to move the ship');
writeln('Use the up/down arrow keys to stop right/left motion');
writeln('You can also use the right mouse button to stop motion');
writeln('Use "S" to save the game (NOTE: no enemies can be present on screen)');
writeln('Hit "M" to return to main menu, select "Continue" to resume play');
writeln('Hit 1..0 to change weapons (NOTE you must have purchased the weapon already');
writeln('Hit Q..Y to change to upper level weapons');
writeln;
textcolor(blue);
writeln('Docking stations:');
textcolor(white);
writeln('To do anything inside a docking station you MUST have a mouse driver installed');
writeln;
writeln('Good Luck!');
writeln;
write('Hit enter to continue--');
readln;
textmode(bw40);
ginit640x480x16(bgidirec);
setfillstyle(1,0);
end;

procedure options;
var func:char;
begin
textmode(co80+font8x8);
clrscr;
writeln('1. Change star configuration');
writeln('2. Change game speed');
writeln;
write('Enter your choice: ');
read(kbd,func);
if func='1' then
begin
clrscr;
write('Do you want the stars on or off [N=On/F=Off]: ');
read(kbd,func);
if upcase(func)='F' then nostar:=true;
if upcase(func)='N' then nostar:=false;
if upcase(func)='F' then change_ini('[Stars]','OFF');
if upcase(func)='N' then change_ini('[Stars]','ON');
func:='@';
end;
if func='2' then
begin
repeat
clrscr;
writeln('Enter the factor to slow down by [1..9] ');
write('(ex. 1=normal speed 2=twice as slow etc.): ');
read(kbd,func);
until func in ['1'..'9'];
change_ini('[Slow down]',func);
val(func,slowdown,error);
end;
ginit640x480x16(bgidirec);
setfillstyle(1,0);
end;

begin
clean;

b10:=find_pic('blow10');
b20:=find_pic('blow20');
b30:=find_pic('blow30');
b40:=find_pic('blow40');
b50:=find_pic('blow50');

repeat
if proc<>'quit' then
begin
pp:=menu;
if pp='Load Game/Map' then load_game;
if pp='Help' then help;
if pp='Quit' then proc:='quit';
if pp='Options' then options;
end;
if (pp='New Game') or (proc='game') or (pp='Continue') then
begin
if proc<>'quit' then
begin;
if (pp='New Game') and (cont=1) then
begin
clean_lasers;
clean_enemies;
clean_map;
clean_explosions;
load_game_weapons;
gship_strength_total:=initial_shields;
gship_strength:=initial_shields;
money:=initial_money;
end;
new_animation('burn','burner',100,true,sx+flamex,fy);
burn_num:=find_mover('burn');
prep_board;
update_board(255);
proc:='';
repeat
multitasker;
until (proc='menu') or (proc='finish');
delete_mov_by_num(burn_num);
if proc='menu' then cont:=1;
if proc='finish' then
begin
clean_lasers;
clean_enemies;
clean_map;
clean_explosions;
load_game_weapons;
gship_strength_total:=initial_shields;
gship_strength:=initial_shields;
money:=initial_money;
end;
proc:='';
end;
end;
until proc='quit';
{$i-}
close(map);
{$i+}
if ioresult<>0 then pp:='';
textmode(co80);
clrscr;
textbackground(red);
textcolor(white);
clreol;
gotoxy(1,1);
writeln('Programmers: Justin Pierce and Jarrad Giles');
clreol;
gotoxy(1,2);
writeln('Graphics: Whitney Pierce and Jarrad Giles (Justin drew the asteroid!)');
clreol;
gotoxy(1,3);
writeln('to contact author E-mail- victor@intrex.net');
textbackground(blue);
gotoxy(1,4);
clreol;
gotoxy(1,5);
clreol;
gotoxy(1,6);
clreol;
gotoxy(1,7);
clreol;
gotoxy(1,8);
clreol;
gotoxy(1,9);
clreol;
gotoxy(1,10);
clreol;
gotoxy(1,4);
textcolor(white);
writeln('About the game: IronClad (1997)');
writeln('This version of IronClad was programmed in about one month and was made');
writeln('solely by Justin Pierce. The first versions were programmed by Justin Pierce');
writeln('and Jarrad Giles in their programming class.');
writeln('Justin Pierce is a senior in Apex High School, NC');
writeln('Jarrad Giles is a freshman at NC State College, NC');
writeln('To Jarrad from Justin: I told you we needed to remake the dang thing! E-mail me!');
textbackground(0);
textcolor(white);
writeln('To make your own maps for IronClad use Mapper.exe then use Load Game/Map from');
writeln('the IronClad Main Menu! Learn how to do more enhancements in readme.txt.');
writeln('Make this game your OWN!');
textcolor(blue);
textbackground(0);
writeln('Thanks for playing IronClad!');
writeln;
textcolor(white);
nosound;
end.