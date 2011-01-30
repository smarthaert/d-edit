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
price:longint;
possess:boolean;
damage:byte;
xdim,ydim:byte;
range:byte;
limit:byte;
orrientation:byte;
name:string[20];
cdel:integer;
end;

laser=record
x,y:integer;
end;

enemy_laser=record
x,y:integer;
ltype:integer;
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
strength:integer;
jump:byte;
picn:byte;
del:integer;
damage_by_ram:byte;
wnum:byte; {weapon type}
chance_of_shot:integer; {higher the number lower the chance}
orrientation:byte;
midx,midy:byte;
weap_pow:integer;
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
    bgidirec,picdirec,workdirec,name,pp:string;
    kevent:tevent;
    proc:s10;
    direct,burn_num,onweapon,onlaser,eonlaser,onenemy,onexp,eweap,s_cdel,b10,b20,b30,b40,b50,flamex:byte;
    sx,sy,fy,error:integer;
    global_del,money,gship_strength,gship_strength_total:longint;
    map,temp:text;
    func:char;

{variable significance

global_del=This gives timing to the the map_reader procedure telling it when
to make enemies, etc.

End. variable significance}

procedure ginit640x480x16(direc:string);
var grd,grmode:integer;
begin
closegraph;
grd:=9;
grmode:=2;
initgraph(grd,grmode,direc);
setgraphmode(2);
end;

procedure fatal(fcall:string);
begin
textmode(CO80);
clrscr;
writeln('A fatal error has occured!');
writeln('Error: ',fcall);
writeln;
write('Hit enter to halt program--');
readln;
halt;
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
{i-}
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

procedure make_enemy(n:byte);
begin
if onenemy+1<max_num_of_enemies then
begin
inc(onenemy);
e[onenemy].x:=random(639-(pics[et[n].picn].xdim))+pics[et[n].picn].xdim;
e[onenemy].y:=25;
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
e[onenemy].y:=25;
e[onenemy].et:=n;
e[onenemy].strength:=et[e[onenemy].et].strength;
end;
end;

procedure prep_board;
begin
setcolor(3);
outtextxy(0,3,'Hit space bar to add to map ("Q" to end pattern [ship goes to station])-');
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
c:=1;
repeat
ltype[c].name:='';
ltype[c].cdel:=0;
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

procedure clean_map;
var s:string;
    c:byte;
begin
mp.del:=0;
global_del:=1;
mp.on_part:=1;
mp.on_level:=1;
mp.lastline:=0;
c:=1;
repeat
part[c]:='';
inc(c);
until c>max_parts_of_map;
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
if ioresult<>0 then fatal('PROC[LOAD_GAME_WEAPONS]- CANNOT FIND CRUCIAL FILE: WEAPON.INF');
n:=1;
readln(w,s);
repeat
readln(w,s);
if s[1]<>'[' then fatal_call('1');
if s[length(s)]<>']' then fatal_call('2');
delete(s,1,1);
ltype[n].name:=copy(s,1,pos(']',s)-1);

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
if pos(upc(f),upc(s))=0 then fatal_call('2');  {HERE HERE HERE}
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
if n>max_types_of_enemies then fatal('PROC[LOAD_GAME_ITEMS]- MAX. NUM OF ENEMIES USED');
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

procedure clean;
begin
bgidirec:=find_ini('[Bgi Directory]');
picdirec:=find_ini('[Picture Directory]');
workdirec:=find_ini('[Work Directory]');
ginit640x480x16(bgidirec);
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
initevents;
hidemouse;
proc:='start';
sx:=(639 div 2) - (pics[1].xdim div 2);
fy:=(479-(pics[find_pic('burn1')].ydim));
sy:=(fy-(pics[1].ydim));
flamex:=(pics[1].xdim div 2)-(pics[find_pic('burn1')].xdim div 2);
gship_strength_total:=40;
gship_strength:=40;
money:=40000;
cleardevice;
setfillstyle(1,0);
prep_board;
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
dec(onlaser);
end;

procedure remove_exp(c:byte);
var l,m:byte;
begin
{str(c,pp);
fatal(pp);}
l:=exp[c].dim div 2;
bar(exp[c].x-l,exp[c].y-l,exp[c].x+l,exp[c].y+l);
bar(exp[c].x-25,exp[c].y-25,exp[c].x+25,exp[c].y+25);
repeat
exp[c]:=exp[c+1];
exp[c+1].x:=-1;
inc(c);
until (exp[c].x=-1) or (c>max_num_of_explosions);
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


procedure explode(x,y:integer;dim:byte);
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

procedure destroy_enemy(ec:byte);
begin
explode(e[ec].x+(pics[et[e[ec].et].picn].xdim div 2),
e[ec].y+(pics[et[e[ec].et].picn].ydim div 2),pics[et[e[ec].et].picn].xdim);
inc(money,et[e[ec].et].point_value);
remove_enemy(ec,false);
end;

procedure update_exp;
var c,d:byte;
begin
c:=1;
if onexp>0 then
begin
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

c:=1;
repeat
if exp[c].on=255 then remove_exp(c);
inc(c);
until c>onexp;
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
if s[c].stype=1 then inc(s[c].y,6);
if s[c].stype=2 then inc(s[c].y,10);
if s[c].stype=3 then inc(s[c].y,3);
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
bar(elas[c].x,(elas[c].y-(ltype[elas[c].ltype].jump)),elas[c].x+(pics[ltype[elas[c].ltype].picn].xdim-1),
elas[c].y+(pics[ltype[elas[c].ltype].picn].ydim-1));
ly:=elas[c].y;
inc(elas[c].y,ltype[elas[c].ltype].jump);
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
{if (random(et[e[c].et].chance_of_shot)=0) and (ok_f=1) then fire_enemy_laser(c);}
inc(c);
until c>onenemy;
end;
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
showpic_by_num(ltype[onweapon].picn,ltype[onweapon].orrientation+617-(pics[1].xdim+5),75);
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

wri_s('Weapon Diagnostic-',5);

str(ltype[onweapon].jump,nn);
wri_s(concat('Speed: ',nn),6);
str(ltype[onweapon].damage,nn);
wri_s(concat('Damage: ',nn),7);
str(ltype[onweapon].range,nn);
wri_s(concat('Range: ',nn),8);
str(ltype[onweapon].limit,nn);
wri_s(concat('Cooling rate: ',nn),9);

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
begin
hidemouse;
cleardevice;
prep;
c:=1;
setcolor(3);
repeat
str(c,men[c]);
men[c]:=concat(men[c],'.');
outtextxy(115,(c-1)*24,ltype[c].name);
inc(c);
until c>10;
men[11]:='Section ][';
men[12]:='Main menu';
menu;
stats;
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
if del=255 then monitor;
if hit<>'' then
begin
c:=1;
if pos('.',hit)<>0 then delete(hit,pos('.',hit),1);
val(hit,c,error);
if error=0 then buy(c);
if hit='Back' then again;
end;
until (hit='Main menu') or (hit='Section ][');
end;

procedure section2;

procedure again;
begin
hidemouse;
cleardevice;
prep;
c:=1;
setcolor(3);
repeat
str(c,men[c]);
men[c]:=concat(men[c],'.');
outtextxy(115,(c-1)*24,ltype[c+10].name);
inc(c);
until c>10;
men[11]:='Section I';
men[12]:='Main menu';
menu;
stats;
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
if del=255 then monitor;
if hit<>'' then
begin
c:=1;
if pos('.',hit)<>0 then delete(hit,pos('.',hit),1);
val(hit,c,error);
if error=0 then buy(c+10);
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
men[1]:='Weapons';
men[2]:='Repair';
men[3]:='Shields';
men[4]:='View Weapons';
men[5]:='Leave';
menu;
stats;
hit:='';
showmouse;
end;

begin
cleardevice;
ll:=255;
button:=find_pic('button');
button_p:=find_pic('button_p');
clean_monitor;

main;
showmouse;
del:=0;
hit:='';

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
if hit='Weapons' then
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
hidemouse;
cleardevice;
prep_board;
change_weapon(onweapon);
end;

procedure add_to_map;
var n,tn,onpage,c:integer;
    slide:array[1..10,1..10] of byte;
    x,y,lzx,lzy,tx:integer;
    ts,np:string;

procedure showpage;
var sp,page:byte;
    zx,zy:integer;
begin
cleardevice;
setcolor(3);
outtextxy(0,0,'Use arrow keys to move, and enter to select enemy (0 to cancel)');
if n in [1..70] then
begin
page:=1;
onpage:=1;
end;
if n in [71..140] then
begin
page:=71;
onpage:=2;
end;
if n in [141..210] then
begin
page:=141;
onpage:=3;
end;
sp:=page;
zx:=0;
zy:=20;
repeat
showpic_by_num(et[page].picn,zx+1,zy+1);
inc (zx,60);
if zx>=600 then
begin
inc(zy,60);
zx:=0;
end;
inc(page);
until (page>tn) or (page>sp+69);
setcolor(3);
if (onpage=1) and (tn>70) then outtextxy(0,470,'Down');
if (onpage=2) and (tn>140) then outtextxy(0,470,'Up     Down');
if (onpage=2) and (tn<=140) then outtextxy(0,470,'Up');
if (onpage=3) then outtextxy(0,470,'Up');
end;

procedure unhighlight;
begin
setcolor(0);
rectangle(lzx,lzy,lzx+59,lzy+59);
end;

procedure highlight(num:byte);
var zx,zy:integer;
    st:string;
begin

if num in [1..70] then
begin
zx:=num mod 10;
if zx=0 then zx:=10;
str(num,st);
if length(st)=1 then zy:=0;
if length(st)>1 then
begin
val(st[1],zy,error);
if st[2]='0' then dec(zy);
end;
zx:=(zx-1)*60;
zy:=(zy*60)+20;
if onpage<>1 then
begin
n:=num;
showpage;
end;
end;
if num in [71..140] then
begin
dec(num,70);
zx:=num mod 10;
if zx=0 then zx:=10;
str(num,st);
if length(st)=1 then zy:=0;
if length(st)>1 then
begin
val(st[1],zy,error);
if st[2]='0' then dec(zy);
end;
zx:=(zx-1)*60;
zy:=(zy*60)+20;
inc(num,70);
if onpage<>2 then
begin
n:=num;
showpage;
end;
end;
if num in [141..210] then
begin
dec(num,140);
zx:=num mod 10;
if zx=0 then zx:=10;
str(num,st);
if length(st)=1 then zy:=0;
if length(st)>1 then
begin
val(st[1],zy,error);
if st[2]='0' then dec(zy);
end;
zx:=(zx-1)*60;
zy:=(zy*60)+20;
inc(num,140);
if onpage<>3 then
begin
n:=num;
showpage;
end;
end;
setcolor(4);
rectangle(zx,zy,zx+59,zy+59);
lzx:=zx;
lzy:=zy;
end;

procedure update_stats;
var s:array[1..10] of string;
begin
setcolor(0);
outtextxy(0,10,'ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл');
setcolor(3);
str(et[n].strength,s[1]);
str(et[n].chance_of_shot,s[2]);
str(et[n].jump,s[3]);
str(et[n].wnum,s[4]);
str(et[n].weap_pow,s[5]);
s[10]:=concat('Ship Stats: Strength=',s[1],' Shot Class=',s[2],' Speed=',s[3],' Weapon Num=',s[4],' Weapon Dam.= ',s[5]);
outtextxy(0,10,s[10]);
end;

begin
cleardevice;
setcolor(3);
tn:=0;
repeat
inc(tn);
until (et[tn].picn=0) or (tn>max_types_of_enemies);
dec(tn);
y:=1;

lzx:=-1;
lzy:=-1;
n:=1;
showpage;
highlight(n);
update_stats;

repeat
getkeyevent(kevent);
if kevent.what=evkeydown then
begin
if lzx<>-1 then unhighlight;
if kevent.keycode=kbright then inc(n);
if kevent.keycode=kbleft then dec(n);
if kevent.keycode=kbup then dec(n,10);
if kevent.keycode=kbdown then inc(n,10);
if n<1 then n:=tn;
if n>tn then n:=1;
highlight(n);
update_stats;
end;
until (kevent.charcode=#13) or (kevent.charcode='0');

c:=n;

if kevent.charcode=#13 then
begin
x:=0;
y:=25;
cleardevice;
update_enemies;
outtextxy(0,300,'Use the arrow keys to specify the area the enemy ship to arrive');
outtextxy(0,310,'Hit enter when complete or "0" to cancel');
outtextxy(0,320,'{Use "Z" and "X" to box faster}');
setcolor(red);
rectangle(x,y,x+pics[et[c].picn].xdim,y+pics[et[c].picn].ydim);
repeat
read(kbd,func);
if keypressed then read(kbd,func);
func:=upcase(func);
tx:=x;
if func='K' then dec(x);
if func='M' then inc(x);
if func='Z' then dec(x,10);
if func='X' then inc(x,10);
setcolor(0);
rectangle(tx,y,tx+pics[et[c].picn].xdim,y+pics[et[c].picn].ydim);
if x<0 then x:=639-(pics[et[c].picn].xdim);
if x+pics[et[c].picn].xdim>639 then x:=0;
setcolor(red);
rectangle(x,y,x+pics[et[c].picn].xdim,y+pics[et[c].picn].ydim);
until (func=#13) or (func='0');

if func=#13 then
begin
np:='';
ts:='';
str(global_del,ts);
np:='D:'+ts+'.';
str(x,ts);
np:=np+'F:'+ts+'.';
str(c,ts);
np:=np+ts+'.';
if length(part[mp.on_part])>=230 then inc(mp.on_part);
part[mp.on_part]:=part[mp.on_part]+np;
if mp.on_part+1>max_parts_of_map then
begin
cleardevice;
setcolor(4);
outtextxy(0,0,'Danger: You are approaching the maximum length of a level. It is suggested you');
outtextxy(0,10,'you finish this pattern soon (with a station)');
outtextxy(0,20,'{If you overflow the pattern buffer your pattern will be lost}');
outtextxy(0,30,'Hit enter to continue--');
readln;
end;
if mp.on_part>max_parts_of_map then
begin
fatal('Level too large! Ending mapper.exe');
end;
make_enemy_fixed(c,x);
global_del:=0;
end;

func:='@';
end;

cleardevice;
prep_board;
end;

procedure move;
begin
getkeyevent(kevent);

if kevent.what=evkeydown then
begin
case upcase(kevent.charcode) of
'Q':proc:='quit';
' ':add_to_map;
end;

end;
showpic_by_num(1,sx,sy);
if direct=1 then inc(sx);
if direct=2 then dec(sx);
if direct<>0 then change_mov_xy_by_num(burn_num,sx,fy,false);
if (sx+pics[1].xdim)>639 then sx:=639-pics[1].xdim;
if sx<1 then sx:=1;

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

end;

procedure multitasker;
var c:byte;
begin
delay(1);

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
if mov[c].cdel>=mov[c].del then show_animation_frame(c);
inc(c);
end;
{End. check mover timers}

{check weapon timer}
if (ltype[onweapon].cdel>=ltype[onweapon].del) then update_lasers;
{End. check weapon timer}

{check enemy weapon timer}
if eweap>2 then
begin
eweap:=0;
update_enemy_lasers;
end;
{End. check enemy weapon timer}

{check default timer}
{if s_cdel mod 15=0 then
begin
update_exp;
end;}
if s_cdel>=20 then
begin
update_exp;
update_stars;
update_enemies;
end;
{End. check star timer}

{check for next action}
{if global_del>mp.del then read_map;}
{End. check for next action}

{setcolor(0);
outtextxy(0,0,concat(char(219),char(219)));
setcolor(3);
str(onexp,pp);
outtextxy(0,0,pp);}

move;
end;

begin
clean;
new_animation('burn','burner',100,true,sx+flamex,fy);
burn_num:=find_mover('burn'); {"burn" is a frequently used mover, so instead
of the program searching through the list everytime this variable is used as
to accelerate the animating}
b10:=find_pic('blow10');
b20:=find_pic('blow20');
b30:=find_pic('blow30');
b40:=find_pic('blow40');
b50:=find_pic('blow50');
part[1]:='D:2000.';

repeat
multitasker;
until proc='quit';

insert('S',part[mp.on_part],length(part[mp.on_part])+1);

restorecrtmode;
clrscr;
repeat
write('Do you wish to save this pattern [Y/N]?');
read(kbd,func);
func:=upcase(func);
until func in ['Y','N'];
if func='Y' then
begin
global_del:=22;
repeat
clrscr;
write('Enter the filename to save to [ex. MYMAP]: ');
readln(name);
if name='' then name:='notsaved';
name:=workdirec+'\'+name+'.jjm';
assign(map,name);
{$i-}
reset(map);
{$i+}
if ioresult<>0 then
begin
global_del:=10;
rewrite(map);
end;
if (ioresult=0) and (global_del<>10) then
begin
writeln;
write('This file already exist, add to level? [Y/N]?');
read(kbd,func);
if upcase(func)='Y' then global_del:=11;
end;
until (global_del=11) or (global_del=10);

if global_del=10 then
begin
clrscr;
write('Enter the name/description of the level: ');
readln(name);
writeln(map,'Level name:'+name);
writeln(map,'[New Part]');
global_del:=1;
repeat
writeln(map,part[global_del]);
inc(global_del);
until (part[global_del]='') or (global_del>max_parts_of_map);
writeln(map,'[End Part]');
writeln(map,'[End Level]');
global_del:=5;
close(map);
end;

if global_del=11 then
begin
assign(temp,concat(picdirec,'\temp.^&^'));
rewrite(temp);
reset(map);
repeat
readln(map,pp);
if pp<>'[End Level]' then writeln(temp,pp);
until (pp='[End Level]') or (eof(map));
if pp<>'[End Level]' then fatal('Trying to add to an invalid map file!');
rewrite(map);
reset(temp);
repeat
readln(temp,pp);
writeln(map,pp);
until eof(temp);
global_del:=1;
writeln(map,'[New Part]');
repeat
writeln(map,part[global_del]);
inc(global_del);
until (part[global_del]='') or (global_del>max_parts_of_map);
writeln(map,'[End Part]');
writeln(map,'[End Level]');
close(map);
erase(temp);
end;
end;

end.