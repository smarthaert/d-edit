unit setsprites;

interface

Uses RunError;

type sprite=array[0..9,0..9] of byte;
{     spritefile=record
                  sprites:array[0..255] of sprite;
                  numendsprite:byte;
end;}
procedure clearsprite(n:byte;var spr:sprite);
procedure putsprite(x,y:byte;spr:sprite);
procedure savespritefile(filename:string;spr:sprite);
procedure loadspritefile(filename:string;var spr:sprite);
procedure mirrorsprite(var spr1,spr2:sprite;mirr:boolean);
procedure rotaresprite(var spr1,spr2:sprite;mirr:boolean);
implementation
procedure clearsprite(n:byte;var spr:sprite);
var i,j:byte;
begin
     for i:=0 to 9 do
         for j:=0 to 9 do
             spr[i,j]:=n;
end;
procedure putsprite(x,y:byte;spr:sprite);
var i,j:byte;
begin
     for i:=0 to 9 do
         for j:=0 to 9 do
             MEM[40960+(j+y*10)*20:x*10+i]:=spr[i,j];
end;
procedure savespritefile(filename:string;spr:sprite);
var spritefilevr:file of byte;
    i,j,k:byte;
    n:char;
const formatname:array[1..25]of char='SPREDITOR 10X10 ONESPRITE';
{const formatname:array[1..25]of char='SPREDITOR 10X10 MANYSPRIT';}
begin
     assign(spritefilevr,filename);
     rewrite(spritefilevr);
     for i:=1 to 25 do
     begin
          n:=formatname[i];
          asm
             Mov al,n
             mov j,al
          end;
          write(spritefilevr,j);
     end;
     {write(spritefilevr,spr.numendsprite);}
     {for k:=0 to spr.numendsprite do}
     for i:=0 to 9 do
         for j:=0 to 9 do
             write(spritefilevr,spr[i,j]);
     close(spritefilevr);
end;
procedure loadspritefile(filename:string;var spr:sprite);
var spritefilevr:File;
    i,j,k:byte;
    n:char;
    formatname:array[1..25]of char;
const formatonesprite:array[1..25]of char='SPREDITOR 10X10 ONESPRITE';
const formatmanysprites:array[1..25]of char='SPREDITOR 10X10 MANYSPRIT';
begin
     OpenFileRE(spritefilevr,'Sprite',filename);
{     assign(spritefilevr,filename);
     reset(spritefilevr);}
     BlockRead(SpriteFileVr,FormatName,25);
{     for i:=1 to 25 do
     begin
          read(spritefilevr,j);
          formatname[i]:=chr(j);
     end;}
     if formatname = formatonesprite then
     begin
        BlockRead(SpriteFileVr,Spr,SizeOf(Spr));
{          for i:=0 to 9 do
              for j:=0 to 9 do
                  read(spritefilevr,spr[i,j]);}
          {spr.numendsprite:=0;}
     end;
{     if formatname = formatmanysprites then
     begin
          read(spritefilevr,spr.numendsprite);
          for k:=0 to spr.numendsprite do
              for i:=0 to 9 do
                  for j:=0 to 9 do
                      read(spritefilevr,spr.sprites[k][i,j]);
     end;}
     close(spritefilevr);
end;
procedure mirrorsprite(var spr1,spr2:sprite;mirr:boolean);
var i,j:byte;
begin
     if mirr then
        for i:=0 to 9 do
            for j:=0 to 9 do
                spr1[i,j]:=spr2[9-i,j]
     else
        for i:=0 to 9 do
            for j:=0 to 9 do
                spr1[i,j]:=spr2[i,9-j];
end;
procedure rotaresprite(var spr1,spr2:sprite;mirr:boolean);
var i,j:byte;
begin
     if mirr then
        for i:=0 to 9 do
            for j:=0 to 9 do
                spr1[i,j]:=spr2[9-j,i]
     else
        for i:=0 to 9 do
            for j:=0 to 9 do
                spr1[i,j]:=spr2[j,9-i];
end;
begin
end.