Unit ctvoice;

Interface

Const
  callok=0;
  carderror=1;
  ioporterror=2;
  dmaerror=3;
  spon=1;
  spoff=0;
  endbl=0;
  nwsamplebl=1;
  samplebl=2;
  silencebl=3;
  markerbl=4;
  textbl=5;
  repeatbl=6;
  repeatendbl=7;
  extrainfobl=8;
  soundblaster=0;
  soundblpro=1;
  soundbl20=2;
  mic=0;
  cd_rom=1;
  line=3;
  mainvl=0;
  voicevl=1;
  micvl=2;
  cd_romvl=3;
  linevl=4;
  both=0;
  left=1;
  right=2;
  lowfilter=0;
  highfilter=1;
  outputfilter=0;
  inputfilter=1;
  stereo=1;
  mono=0;
  on=0;
  off=1;

Type
    intartype=array [0..$fff0] of byte;
    voctp=record
        start:pointer;
        length:longint;
        block:^intartype;
    end;
    proc=procedure;
    proctp=^proc;

Var
   statusword:word;
   blockstart:^intartype;
   blocklength:longint;
   blocktype:byte;
   continue:boolean;
   cardtype:byte;
   sbioresult:word;

Procedure loadctdriver(n:string);
Function checkvocfile(n:string):boolean;
Procedure loadvocfile(n:string; var v:voctp);
Procedure savevocfile(n:string; v:voctp);
Procedure disposevoc(var v:voctp);
Function ctversion:word;
Procedure useport(p:word);
Procedure useirq(i:word);
Procedure usechannel(d:word);
Procedure initializedriver;
Procedure speaker(w:word);
Procedure stopvprocess;
Procedure driveroff;
Procedure userrout(p:proctp);
Procedure askrate(var max,min:word; m,k:word);
Procedure recordmode(b:word);
Procedure input(s:word);
Procedure recordingfilter(b:word);
Procedure volume(s,c,v:word);
Procedure filter(s,v:word);
Procedure resetmixer;
Procedure readallvolumes;
Function returnvolume(s,v:word):word;
Function returnfilter(s:word):word;
Procedure pause;
Procedure continueplaying;
Procedure stoprepetition(i:word);
Procedure playblock(v:voctp);
Procedure playembblock(h:word; s:longint);
Procedure recordsample(l:longint; sr:word; var v:voctp);
Procedure recordembsample(sr:word; h:word; s:longint);
Procedure firstsubblock(var v:voctp);
Procedure nextsubblock(var v:voctp);
Procedure volumetable(v:pointer; s:byte);
Procedure echobuffer(e:pointer; s:word);
Procedure command(s:string);
Function cvolume:byte;

Implementation

Uses Dos;

var
   ctaddress:pointer;
   ctsize:longint;
   r:registers;

{$L CTINTER.OBJ}
{$F+}
Procedure ctvoiceaddress(p:pointer); external;
Procedure callctvoice(var r:registers); external;
Procedure variables(stpt, bspt, blpt, btpt, copt:pointer); external;
Procedure userroutine(p:proctp); external;
{$F-}

procedure loadctdriver(n:string);

Var
  f:file;
  s:string[8];
  off,sg:word;

Begin
  if n='' then n:='ct-voice.drv';
  assign(f,n); reset(f,1);
  seek(f,2); blockread(f,s,9);
  seek(f,0);
  s[0]:=#8;
  If s='CT-VOICE' then begin
    ctsize:=filesize(f);
    getmem(ctaddress,ctsize+16);
    off:=ofs(ctaddress^);
    sg:=seg(ctaddress^);
    sg:=sg+off shr 4;
    off:=off and 15;
    If off<>0 Then Begin
       Inc(sg);
       off:=0;
    end;
    ctaddress:=ptr(sg,off);
    blockread(f,ctaddress^,ctsize);
    close(f);
    ctvoiceaddress(ctaddress);
    sbioresult:=0;
  end
  else begin
         close(F);
         sbioresult:=1;
       end
end;

Function checkvocfile(n:string):boolean;

var
  f:file;
  s:string[19];
  t1,t2:word;
  r:boolean;

begin
  r:=false;
  assign(f,n); reset(f,1);
  blockread(f,s,19);
  s[0]:=#18;
  If s='Creative Voice File' Then Begin
     seek(f,$16);
     blockread(f,t1,2);
     blockread(f,t2,2);
     t1:=(t1 xor $ffff) + $1234;
     r:=t1=t2;
  end;
  close(f);
  checkvocfile:=r;
end;

Procedure loadvocfile(n:string; var v:voctp);

var
  f:file;
  t:word;
  sgh,ofh:word;
  sge,ofe:word;
  hs:longint;

Begin
  Assign(f,n); reset(f,1);
  seek(f,$14);
  blockread(f,t,2);
  seek(f,t);
  v.length:=filesize(f)-T;
  getmem(v.start,v.length);
  blockread(f,v.start^,v.length);
  close(f);
  v.block:=v.start;
End;

Procedure savevocfile(n:string; v:voctp);

var
  f:file;
  s:string;
  t:word;

Begin
  assign(f,n); rewrite(f,1);
  s:='Creative Voice File'+#$1a;
  blockwrite(f,s,20);
  t:=$001a; blockwrite(f,t,2);
  t:=$010a; blockwrite(f,t,2);
  t:=(t-$1234) xor $ffff;
  blockwrite(f,t,2);
  blockwrite(f,v.start^,v.length);
  close(f);
end;

Procedure disposevoc(var v:voctp);
begin
  freemem(v.start,v.length);
  v.start:=nil;
  v.length:=0;
  v.block:=nil;
end;

Function ctversion:word;
begin
  r.bx:=0;
  callctvoice(r);
  ctversion:=r.ax
end;

Procedure useport(p:word);
begin
  r.bx:=1;
  r.ax:=p;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure useirq(i:word);
begin
  r.bx:=2;
  r.ax:=I;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure usechannel(d:word);
Begin
  r.bx:=19;
  r.ax:=d;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure initializedriver;
begin
  r.bx:=3;
  callctvoice(r);
  if r.ax=0 then
    variables(@statusword,@blockstart,@blocklength,@blocktype,@continue);
  sbioresult:=r.ax;
end;

Procedure speaker(w:word);
begin
  r.bx:=4;
  r.ax:=w;
  callctvoice(r);
end;

Procedure stopvprocess;
begin
  r.bx:=8;
  callctvoice(r);
end;

Procedure driveroff;
begin
  r.bx:=9;
  callctvoice(r);
end;

Procedure userrout(p:proctp);
begin
  if p=nil then
     userroutine(ptr(0,0))
  else
    userroutine(p);
end;

Procedure askrate(var max,min:word; m,k:word);
begin
  r.bx:=26;
  r.ax:=k;
  r.dx:=m;
  callctvoice(r);
  max:=r.dx;
  min:=r.ax;
end;

Procedure recordmode(b:word);
begin
  r.ax:=b;
  r.bx:=16;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure input(s:word);
begin
  r.ax:=s;
  r.bx:=17;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure recordingfilter(b:word);
begin
  r.ax:=b;
  r.bx:=18;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure volume(s,c,v:word);
begin
  if c=both then begin
     volume(s,left,v);
     c:=right;
  end;
  r.ax:=2;
  r.bx:=21;
  r.cx:=v;
  r.dx:=c;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure filter(s,v:word);
begin
  r.ax:=s;
  r.bx:=22;
  r.cx:=v;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure resetmixer;
begin
  r.bx:=23;
  callctvoice(r);
end;

Procedure readallvolumes;
begin
  r.bx:=24;
  callctvoice(r);
end;

Function returnvolume(s,v:word):word;
begin
  r.ax:=s;
  r.bx:=25;
  r.dx:=v;
  callctvoice(r);
  returnvolume:=r.ax;
end;

Function returnfilter(s:word):word;
begin
  if ctversion=$20a then
    r.bx:=27
  else
    r.bx:=26;
  r.ax:=s;
  callctvoice(r);
  returnfilter:=r.ax;
end;

Procedure pause;
begin
  r.bx:=10;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure continueplaying;
begin
  r.bx:=11;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure stoprepetition(i:word);
begin
  r.bx:=12;
  r.ax:=i;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure playblock(v:voctp);
begin
  r.bx:=6;
  r.di:=ofs(v.start^);
  r.es:=seg(v.start^);
  callctvoice(R);
end;

Procedure playembblock(h:word; s:longint);
begin
  r.bx:=14;
  r.dx:=h;
  r.di:=s shr 16;
  r.si:=s and $ffff;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure recordsample(l:longint; sr:word; var v:voctp);
begin
  getmem(v.start,l);
  v.length:=l;
  r.bx:=7;
  r.ax:=sr;
  r.dx:=l shr 16;
  r.cx:=l and 65535;
  r.es:=seg(v.start^);
  r.di:=ofs(v.start^);
  callctvoice(r);
end;

Procedure recordembsample(sr:word; h:word; s:longint);
begin
  r.ax:=sr;
  r.bx:=15;
  r.dx:=h;
  r.di:=s shr 16;
  r.si:=s and $ffff;
  callctvoice(r);
  sbioresult:=r.ax;
end;

Procedure firstsubblock(var v:voctp);
begin
  v.block:=v.start;
end;

Procedure nextsubblock(var v:voctp);
Var
  a:longint;

begin
  a:=16*longint(seg(v.block^))+longint(ofs(v.block^));
  a:=a+4+v.block^[1]+256*v.block^[2]+256*256*v.block^[3];
  v.block:=ptr(a shr 4, a and 15);
end;

Procedure volumetable(v:pointer; s:byte);
begin
  r.bx:=128;
  r.ax:=0;
  r.cl:=s;
  r.di:=ofs(v^);
  r.es:=seg(v^);
  callctvoice(r);
end;

Procedure echobuffer(e:pointer; s:word);
Begin
  r.bx:=128;
  r.ax:=1;
  r.cx:=s;
  r.di:=ofs(e^);
  r.es:=seg(e^);
  callctvoice(r);
end;

Procedure command(s:string);
begin
  s:=s+#0;
  r.bx:=129;
  r.di:=ofs(s[1]);
  r.es:=seg(s[1]);
  callctvoice(r);
end;

Function cvolume:byte;
begin
  r.bx:=130;
  callctvoice(r);
  cvolume:=r.al;
end;

end.