uses crt,graph,drivers,turbo3,base;

type
view=record
tx,ty:byte;
x1,x2,y1,y2:byte;
vp:pointer;
vpi:pointer;
end;

mouse_info=record
x,y:byte;
lc,rc:byte;
bd:boolean;
ac:string;
s:array[1..10] of byte;
end;

var v:view;
    kevent,mevent:tevent;
    proc:string;
    mi:mouse_info;
    nom:byte;
    men:array[1..10] of string[20];
    ok:boolean;
    filen,bgidirec:string;
    work:text;

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

procedure message(s:string);
begin
setcolor(0);
outtextxy(0,455,'ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл');
setcolor(3);
outtextxy(0,455,s);
end;

procedure initbar;
var c:byte;
begin
setcolor(3);
if filen='new' then outtextxy(0,400,'File Open: New Document');
if filen<>'new' then outtextxy(0,400,'File Open: '+filen);
c:=0;
setcolor(8);
repeat
rectangle(c*8,470,(c+1)*8,478);
inc(c);
until c>15;
c:=18;
setfillstyle(1,mi.lc);
bar((c*8)+1,471,((c+1)*8)-1,477);
rectangle(c*8,470,(c+1)*8,478);
c:=19;
setfillstyle(1,mi.rc);
bar((c*8)+1,471,((c+1)*8)-1,477);
rectangle(c*8,470,(c+1)*8,478);

c:=0;
repeat
setfillstyle(1,c);
bar((c*8)+1,471,((c+1)*8)-1,477);
inc(c);
until c>15;
end;

procedure initmenu;
var c:byte;
begin
setcolor(2);
outtextxy(510,248,'Local: ');
outtextxy(510,256,'Global: ');
outtextxy(0,410,'Local view covers: ');
c:=1;
repeat
men[c]:='';
inc(c);
until c>10;
men[1]:='New';
men[2]:='Size';
men[3]:='Save';
men[4]:='Save As';
men[5]:='Load';
men[6]:='Line';
men[7]:='Circle';
men[8]:='Fill';
men[9]:='Exit';
setcolor(7);
c:=1;
repeat
outtextxy(416,248+((c-1)*8),men[c]);
inc(c);
until men[c]='';
nom:=c-1;
end;

procedure get_vpi;
var size:integer;
begin
size:=imagesize(395+v.x1,v.y1,395+v.x2,v.y2);
getmem(v.vpi,size);
getimage(395+v.x1,v.y1,395+v.x2,v.y2,v.vpi^);
end;

procedure show_vpi;
begin
putimage(395+v.x1,v.y1,v.vpi^,normalput);
end;

procedure dispose_vpi;
begin
freemem(v.vpi,imagesize(395+v.x1,v.y1,395+v.x2,v.y2));
end;

procedure show_viewport;
begin
PutImage(394+v.x1,v.y1-1,v.vp^, NormalPut);
end;

procedure get_viewport;
var size:integer;
begin
Size:=ImageSize(394+v.x1,v.y1-1,396+v.x2,1+v.y2);
GetMem(v.vp,Size);
GetImage(394+v.x1,v.y1-1,396+v.x2,1+v.y2,v.vp^);
setcolor(13);
rectangle(394+v.x1,v.y1-1,396+v.x2,1+v.y2);
end;

procedure dispose_viewport;
begin
freemem(v.vp,ImageSize(394+v.x1,v.y1-1,396+v.x2,1+v.y2));
end;

function get_input_string(s:string):string;
var x:integer;
    func:char;
    re:string;
begin
message('');
x:=(length(s)*8)+5;
outtextxy(0,455,s);
re:='';
func:='@';
setcolor(3);
repeat
read(kbd,func);
if (func=#8) and (re<>'') then
begin
setcolor(0);
dec(x,8);
outtextxy(x,455,'л');
delete(re,length(re),1);
setcolor(3);
end;
if (func<>#13) and (func<>#8) then
begin
insert(func,re,length(re)+1);
outtextxy(x,455,func);
inc(x,8);
end;
until func=#13;
get_input_string:=re;
message('');
end;

function get_input_num(s:string):integer;
var x:integer;
    func:char;
    re:string;
    error,num:integer;
begin
repeat
message('');
x:=(length(s)*8)+5;
outtextxy(0,455,s);
re:='';
func:='@';
setcolor(3);
repeat
read(kbd,func);
if (func=#8) and (re<>'') then
begin
setcolor(0);
dec(x,8);
outtextxy(x,455,'л');
delete(re,length(re),1);
setcolor(3);
end;
if (func<>#13) and (func<>#8) then
begin
insert(func,re,length(re)+1);
outtextxy(x,455,func);
inc(x,8);
end;
until func=#13;
message('');
val(re,num,error);
until (error=0);
get_input_num:=num;
end;

procedure plot_thumb_nail(x,y,c:byte);
begin
ok:=false;
putpixel(395+x,0+y,c);
end;

procedure fillbox(x,y,c:byte; plot_t:boolean);
begin
setfillstyle(1,c);
bar(((x-1)*8)+1,((y-1)*8)+1,(x*8)-1,(y*8)-1);
if plot_t=true then plot_thumb_nail(x+(v.x1-1),y+(v.y1-1),c);
end;

procedure update_large;
var x,y:byte;
    s1,s2,s3:string;
begin
hidemouse;
y:=v.y1;
repeat
x:=v.x1;
repeat
fillbox(x-(v.x1-1),y-(v.y1-1),getpixel(395+x,0+y),false);
inc(x);
until x>v.x2;
inc(y);
until y>v.y2;
showmouse;
end;

procedure coords(num:byte);
var s1,s2,s3,s4:string[3];
begin
if (num=1) or (num=255) then
begin
setcolor(0);
outtextxy(566,248,'ллллл');
setcolor(2);
str(mi.x,s1);
str(mi.y,s2);
outtextxy(566,248,s1+','+s2);
end;
if (num=2) or (num=255) then
begin
setcolor(0);
outtextxy(574,256,'ллллллл');
setcolor(2);
str(mi.x+(v.x1-1),s1);
str(mi.y+(v.y1-1),s2);
outtextxy(574,256,s1+','+s2);
end;
if (num=3) or (num=255) then
begin
setcolor(0);
outtextxy(150,410,'ллллллллллллллл');
setcolor(2);
str(v.x1,s1);
str(v.y1,s2);
str(v.x2,s3);
str(v.y2,s4);
outtextxy(150,410,s1+','+s2+','+s3+','+s4);
end;
end;

procedure thumb_nail(x,y:byte);
begin
setcolor(white);
rectangle(395,0,396+x,1+y);
get_viewport;
end;

procedure grid(x,y:byte);
var cx,cy:byte;
begin
ok:=true;
hidemouse;
v.tx:=x;
v.ty:=y;
if x>49 then x:=49;
if y>49 then y:=49;
v.x1:=1; v.y1:=1;
v.x2:=x; v.y2:=y;
setcolor(13);
cy:=1;
repeat
cx:=1;
repeat
rectangle((cx-1)*8,(cy-1)*8,cx*8,cy*8);
inc(cx);
until cx>x;
inc(cy);
until cy>y;
thumb_nail(v.tx,v.ty);
coords(255);
showmouse;
end;

procedure load;
var ex:boolean;
    x,y,tx,ty,n:byte;
begin
repeat
filen:=get_input_string('Enter filename to load (Enter to cancel):');
ex:=false;
if filen<>'' then
begin
assign(work,filen);
ex:=true;
{$i-}
reset(work);
{$i+}
if ioresult<>0 then ex:=false;
end;
until (ex=true) or (filen='');
if filen='' then filen:='new';
if ex=true then
begin
reset(work);
ginit640x480x16(bgidirec);
readln(work,tx);
readln(work,ty);
grid(tx,ty);
show_viewport;
dispose_viewport;
ok:=true;
message('Loading '+filen+'..');
y:=1;
repeat
x:=1;
repeat
readln(work,n);
putpixel(395+x,0+y,n);
inc(x);
until x>tx;
inc(y);
until y>ty;
message('');
close(work);
update_large;
initbar;
initmenu;
ok:=true;
get_viewport;
showmouse;
end;
end;

procedure new_drw;
begin
filen:='new';
hidemouse;
ginit640x480x16(bgidirec);
grid(v.tx,v.ty);
ok:=true;
initbar;
initmenu;
showmouse;
mi.ac:='moving';
end;

procedure save_as;
begin
filen:=get_input_string('Enter filename to save to:');
end;

procedure save(fo:boolean);
var x,y,sav:byte;
    ans:string[1];
begin
if filen<>'new' then
begin
ok:=true;
assign(work,filen);
sav:=0;
{$i-}
reset(work);
{$i+}
if ioresult<>0 then sav:=1;
if sav=0 then
begin
message('');
if fo=false then ans:=get_input_string('File '+filen+' exist, Overwrite? [Y/N]:');
if fo=true then ans:='Y';
ans:=upcase(ans[1]);
if ans='Y' then sav:=1;
end;
if sav=1 then
begin
rewrite(work);
writeln(work,v.tx);
writeln(work,v.ty);
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
message('');
message('Saving: '+filen+'..');
hidemouse;
y:=1;
repeat
x:=1;
repeat
writeln(work,getpixel(395+x,0+y));
inc(x);
until x>v.tx;
inc(y);
until y>v.ty;
end;
showmouse;
close(work);
message('');
initmenu;
get_viewport;
end;
if filen='new' then
begin
save_as;
if filen<>'' then save(false);
if filen='' then filen:='new';
end;
mi.ac:='moving';
end;

procedure fill(x,y,bor,c:byte);
begin
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
setviewport(396,1,395+v.tx,v.ty,true);
setfillstyle(1,c);
hidemouse;
floodfill(x,y,bor);
setviewport(0,0,639,479,true);
get_viewport;
update_large;
showmouse;
mi.ac:='moving';
end;

procedure sizer;
var x,y:byte;
begin

repeat
x:=get_input_num('Enter X Dimension [1-235]:');
until (x>0) and (x<=235);
repeat
y:=get_input_num('Enter Y Dimension [1-235]:');
until (y>0) and (y<=235);

hidemouse;
ginit640x480x16(bgidirec);
grid(x,y);
initbar;
initmenu;
showmouse;
end;

procedure chk_events;
var inbox:boolean;
    c:byte;
    ans:string[1];
    temp:string;
begin
getmouseevent(mevent);
getkeyevent(kevent);

if kevent.what<>evnothing then
begin
if upcase(kevent.charcode)='Q' then
begin
if ok=false then
begin
message('');
ans:=get_input_string('File has not been saved. Are you sure you want to exit? [Y/N]:');
ans:=upcase(ans[1]);
message('');
if ans='Y' then proc:='quit';
end;
if ok=true then
begin
proc:='quit';
end;
mi.ac:='moving';
end;
case kevent.keycode of

kbright:if v.x2<v.tx then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
inc(v.x2);
inc(v.x1);
coords(255);
get_viewport;
update_large;
end;
kbleft:if v.x1>1 then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
dec(v.x2);
dec(v.x1);
coords(255);
get_viewport;
update_large;
end;
kbup:if v.y1>1 then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
dec(v.y2);
dec(v.y1);
coords(255);
get_viewport;
update_large;
end;
kbdown:if v.y2<v.ty then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
inc(v.y2);
inc(v.y1);
coords(255);
get_viewport;
update_large;
end;
end;
end;

if mevent.what<>evnothing then
begin
mi.x:=mevent.where.x+1;
mi.y:=mevent.where.y+1;
coords(1);
coords(2);
mi.bd:=false;
if (mevent.buttons=mbleftbutton) or (mevent.buttons=mbrightbutton) then mi.bd:=true;
inbox:=false;
if (mi.x<=v.x2) and (mi.y<=v.y2) and (mi.y<=49) and (mi.x<=49) then inbox:=true;

if (mi.y=60) and (mi.x<=16) and (mi.bd=true) then
begin
if mevent.buttons=mbleftbutton then
begin
mi.lc:=mi.x-1;
c:=18;
setfillstyle(1,mi.lc);
bar((c*8)+1,471,((c+1)*8)-1,477);
end;
if mevent.buttons=mbrightbutton then
begin
mi.rc:=mi.x-1;
c:=19;
setfillstyle(1,mi.rc);
bar((c*8)+1,471,((c+1)*8)-1,477);
end;
end;

if (inbox=true) and (mi.bd=true) and (mi.ac='moving') then
begin
hidemouse;
if mevent.buttons=mbleftbutton then fillbox(mi.x,mi.y,mi.lc,true);
if mevent.buttons=mbrightbutton then fillbox(mi.x,mi.y,mi.rc,true);
showmouse;
end;

if (inbox=true) and (mi.bd=true) and (mi.ac='line') then
begin
message('');
if mevent.buttons=mbleftbutton then setcolor(mi.lc);
if mevent.buttons=mbrightbutton then setcolor(mi.rc);
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
line(395+mi.s[1],0+mi.s[2],395+mi.x+(v.x1-1),0+mi.y+(v.y1-1));
get_viewport;
update_large;
mi.ac:='moving';
end;

if ((inbox=true) and (mevent.buttons=mbleftbutton) and (mevent.double=true) and (mi.ac='moving')) or ((mi.ac='e_line') and
(mi.bd) and (inbox=true)) then
begin
mi.ac:='line';
mi.s[1]:=mi.x+(v.x1-1);
mi.s[2]:=mi.y+(v.y1-1);
message('');
message('Click the endpoint of the line');
end;

if (mi.x>=52) and (mevent.buttons=mbleftbutton) and (mi.y>=31) and (mi.y<8*(nom+1)) then
begin
if mi.x in [52..52+length(men[(mi.y-31)])] then
begin
message('');
mi.ac:='changing';
mi.s[1]:=mi.y-31;
end;
end;

if (mi.ac='changing') then
begin
if men[mi.s[1]]='Line' then mi.ac:='m_line';
if men[mi.s[1]]='Save' then mi.ac:='save';
if men[mi.s[1]]='Save As' then mi.ac:='savea';
if men[mi.s[1]]='Load' then mi.ac:='load';
if men[mi.s[1]]='Circle' then mi.ac:='circle';
if men[mi.s[1]]='New' then mi.ac:='new';
if men[mi.s[1]]='Size' then mi.ac:='size';
if men[mi.s[1]]='Exit' then mi.ac:='exit';
if men[mi.s[1]]='Fill' then mi.ac:='fill';
end;

if (mi.ac='circle') then
begin
message('');
message('Click the center of the circle');
mi.ac:='circle s1';
end;

if (mi.ac='circle s2') and (mi.bd=true) and (inbox=true) then
begin
message('');
mi.s[3]:=round(sqrt((((mi.x+v.x1-1)-mi.s[1])*((mi.x+v.x1-1)-mi.s[1]))+(((mi.y+v.y1-1)-mi.s[2])*((mi.y+v.y1-1)-mi.s[2]))));
get_vpi;
show_viewport;
show_vpi;
dispose_vpi;
dispose_viewport;
setviewport(396,1,395+v.tx,v.ty,true);
if mevent.buttons=mbleftbutton then setcolor(mi.lc);
if mevent.buttons=mbrightbutton then setcolor(mi.rc);
hidemouse;
circle(mi.s[1]-1,mi.s[2]-1,mi.s[3]);
setviewport(0,0,639,479,true);
get_viewport;
update_large;
showmouse;
mi.ac:='moving';
end;

if (mi.ac='circle s1') and (mi.bd=true) and (inbox=true) then
begin
mi.s[1]:=mi.x+(v.x1-1);
mi.s[2]:=mi.y+(v.y1-1);
mi.ac:='circle s2';
message('');
message('Click a point on the circle');
end;

if (mi.ac='fill') then
begin
message('');
message('Click the starting point of the fill with fill color--');
mi.ac:='fill s1';
end;

if (inbox=true) and (mi.bd=true) and (mi.ac='fill s2') then
begin
message('');
temp:=filen;
filen:='Prefill.drw';
save(true);
fill(mi.s[1],mi.s[2],getpixel(395+mi.x+(v.x1-1),mi.y+(v.y1-1)),mi.s[3]);
fill(mi.s[1],mi.s[2],getpixel(395+mi.x+(v.x1-1),mi.y+(v.y1-1)),mi.s[3]);
filen:=temp;
message('');
message('File before fill was saved to Prefill.drw');
end;

if (inbox=true) and (mi.bd=true) and (mi.ac='fill s1') then
begin
mi.s[1]:=mi.x+(v.x1-1);
mi.s[2]:=mi.y+(v.y1-1);
if mevent.buttons=mbleftbutton then mi.s[3]:=mi.lc;
if mevent.buttons=mbrightbutton then mi.s[3]:=mi.rc;
message('');
message('Click the border color of the fill (inside the drawing)--');
mi.ac:='fill s2';
end;

if (mi.ac='m_line') then
begin
message('');
message('Click starting point of line');
mi.ac:='e_line';
end;

if (mi.ac='save') then save(false);
if (mi.ac='savea') then
begin
filen:='new';
save(false);
end;

if (mi.ac='size') then
begin
if ok=false then
begin
message('');
ans:=get_input_string('File has not been saved. Are you sure you want to lose changes? [Y/N]:');
ans:=upcase(ans[1]);
message('');
if ans='Y' then ok:=true;
end;
if ok=true then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_viewport;
dispose_vpi;
sizer;
end;
mi.ac:='moving';
end;

if (mi.ac='load') or (mi.ac='new') then
begin
if ok=false then
begin
message('');
ans:=get_input_string('File has not been saved. Are you sure you want to lose changes? [Y/N]:');
ans:=upcase(ans[1]);
message('');
if ans='Y' then ok:=true;
end;
if ok=true then
begin
get_vpi;
show_viewport;
show_vpi;
dispose_viewport;
dispose_vpi;
if mi.ac='load' then load;
if mi.ac='new' then new_drw;
end;
mi.ac:='moving';
end;

if (mi.ac='exit') then
begin
if ok=false then
begin
message('');
ans:=get_input_string('File has not been saved. Are you sure you want to exit? [Y/N]:');
ans:=upcase(ans[1]);
message('');
if ans='Y' then ok:=true;
mi.ac:='moving';
end;
if ok=true then
begin
proc:='quit';
end;
end;

end;
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
proc:='start';
bgidirec:=find_ini('[Bgi Directory]');
ginit640x480x16(bgidirec);
grid(200,200);
filen:='new';
initevents;
initbar;
setfillstyle(1,1);
bar(145,471,151,477);
initmenu;
showmouse;
mi.lc:=blue;
mi.rc:=black;
mi.ac:='moving';
ok:=true;
end;

begin
clean;
repeat
chk_events;
until proc='quit';
restorecrtmode;
end.