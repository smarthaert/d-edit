program WolfDoom;
{$n+,e+}
USES dos,crt,keyboard;
type real=double;

CONST DEG2RAD:Real= PI/180;

const   scr_horizon:WORD= 100;
        scr_width:WORD= 320;
        scr_height:WORD= 200;
        scr_MagicConst:REAL= 128;
        scr_cast_angle:REAL= 0.2;
        scr_offs:WORD= 0;

CONST vaddr: Pointer= NIL;
      wall : pointer = NIL;
      Floor : pointer=NIL;
      Ceiling : Pointer=NIL;

      heading:Real=0;
      turn:Real=0;
      step:Real=0;
      frames:Longint=0;

VAR   _Shade: Pointer;
      Palette:ARRAY[0..255] of record r,g,b:byte;end;

      hmh, hph : integer;
      x, darkness : Word;
      v,h, stp, px128, py128, sina, cosa, magic:longint;

      map:ARRAY[0..32*32-1] OF byte;

      px, py:Real;
      destx, desty:Real;

PROCEDURE DrawWallFloor; EXTERNAL;
{$l _3d.obj}

PROCEDURE Retrace;
BEGIN
   WHILE ((Port[$3DA] AND 8) > 0) DO;
   WHILE ((Port[$3DA] AND 8) = 0) DO;
END;

PROCEDURE Pal(C,R,G,B:Byte);
BEGIN
   port[$3c8]:=C;
   port[$3c9]:=r;
   port[$3c9]:=g;
   port[$3c9]:=b;
END;

TYPE PCXHeader=RECORD
                  Manufacturer,
                  Version,
                  Encoding,
                  BitsPerPixel:Byte;
                  xMin,
                  yMin,
                  xMax,
                  yMax:Word;
                  Other:ARRAY[0..115] OF byte;
               END;
VAR Header:PCXHeader;

PROCEDURE LoadPCX (FileName:STRING; Where:Pointer; offset,width:Word);
VAR pcxFile:FILE;
    DataByte, HowMany:Byte;
    Pos,anz:Word;
    x, y, c:Word;
    temp:pointer;
BEGIN
   {$i-}
   Assign(PCXFile,filename);
   Reset(PCXFile,1); 
   {$i+}
   IF IOResult<>0 THEN
      BEGIN
         asm mov ax,3; Int 10h;
      END;
   writeln ('ERROR: Picture File Missing');
   writeln('Couldn''t open ', FileName );
   Halt(1);
END;


        BlockRead (pcxfile,Header, 128);
        IF (Header.Version <> 5) THEN
           BEGIN
              asm mov ax,3; Int 10h;
           END;
         Close (PCXFile);
         writeln ('Error in ', FileName );
         Halt(1);
        END; 
        IF (Header.xMax>319) OR (Header.xMin<0) OR
           (Header.yMax>200) OR (Header.yMin<0) 
        THEN
           BEGIN
              asm mov ax,3; Int 10h;
           END;
              writeln('Error in ', FileName );
            Close (PCXFile);
            Halt(1);
           END;

        Seek (PCXFile, FileSize(PCXFile)-769);
        BlockRead (pcxfile,DataByte, 1);

        BlockRead (pcxfile, Palette, 768);
        FOR c:=0 TO 255 DO
           Pal(c,Palette[c].r SHR 2, Palette[c].g SHR 2, Palette[c].b SHR 2);

        Seek (PCXFile, 128);
        y:=Header.yMin; 
        x:=Header.xMin;
        inc(Header.xMax);
        inc(Header.yMax);

        GetMem(temp,64000);
        REPEAT
           Pos:=0; BlockRead(pcxfile,temp^,$FFFF,anz);
           WHILE (y<Header.yMax) AND (Pos<anz) DO
              BEGIN
                 databyte:=mem[Seg(temp^):Ofs(temp^)+Pos]; inc(Pos);
                 HowMany:=1;
                 IF ((DataByte AND $C0)=$C0) THEN
                    BEGIN
                       HowMany:= (DataByte AND $3F);
                       databyte:=mem[Seg(temp^):Ofs(temp^)+Pos]; inc(Pos);
                    END;

                 FOR c:=1 TO howmany DO
                    BEGIN
                       mem[Seg(where^):Ofs(where^)+offset+x+y*width]:= DataByte; 
                       inc(x);
                       IF (x>=Header.xMax) THEN
                          BEGIN
                             inc(y); x:=Header.xMin;
                          END;
                    END;
              END;
        UNTIL (y<header.ymax) OR (anz=0);
        FreeMem(temp,64000);
        Close (PCXFile);
END;

const start:Byte=1;
      ende:Byte=2;
      Mauer:Byte=3;

PROCEDURE loadmap(filename:STRING);
VAR f:file;
    x,y: Word;
begin
 assign(f,filename);reset(f,1);blockread(f,map,sizeof(map));close(f);
 for x:=0 to 31 do for y:=0 to 31 do
  if map[x+y*32]=start then begin px:= x+0.5;py:=y+0.5;map[x+y*32]:= 0;end else
  if map[x+y*32]=ende then Begin destx:= x;desty:= y;map[x+y*32]:=mauer;end;
end;

VAR shade:ARRAY[0..17*256-1] OF byte;

procedure Set_Shade;
var  color, st, diff, tc, tdiff:integer;
     red, green, blue:integer;
begin
	for color:= 0 to 255 do shade[color]:= color;

	for st:= 1 to 16 do
	begin
		for color:= 0 to 255 do
		begin
			red:= (integer(Palette[color].r) shr 4 ) * (16-st);
		      green:= (integer(Palette[color].g) shr 4 ) * (16-st);
		       blue:= (integer(Palette[color].b) shr 4 ) * (16-st);

			diff:= 1000;
			for tc:= 0 to 255 do
			begin
				tdiff:= abs(integer(Palette[tc].r - red)) +
                                        abs(integer(Palette[tc].g - green)) +
                                        abs(integer(Palette[tc].b - blue));
				if( tdiff < diff ) then
				begin
					diff:= tdiff;
					shade[color+(st shl 8)]:= tc;
				end;
			end;
		end;
	end;
end;

FUNCTION tan(x:Real):Real;
BEGIN
   tan:=Sin(x)/Cos(X);
END;

Function InRange(X,Y:Real):Boolean;
var px,py: Real;
begin
 px:=int(x);py:=int(y);
 if (px< 00) or (py < 00) or (px > 27) or (py>27) OR
    (map[round(px)+round(py) shl 5]>0) then inrange:=true else inrange:=false;
end;

procedure compute_view;
var a, x1, x2, y1, y2, dist1, dist2, step:Real;
    height:Longint;
    dist:Longint;
Label Break1,Break2,break3,break4;
begin
	px128:= round(px*128);py128:=round(py*128);

        a:= heading + 32;
	for x:= 0 to scr_width-1 do
	begin
         a:=a - scr_cast_angle;
		(* Tabellen w„hren besser *)
		magic:= round(int(scr_MagicConst*1024/cos((a - heading)*DEG2RAD)));
		sina:= round(int(sin(a*DEG2RAD) * 128 * 1024));
		cosa:= round(int(cos(a*DEG2RAD) * 128 * 1024));

                (* Bewegung auf der Y-achse *)
		if ( a <> 180) and (a <> 0 ) then
		begin
			if ( sina > 0 ) then
			begin
				step:= tan( (90-a) * DEG2RAD );
				x1:= int(px)+1;
				y1:= py + (x1-px) * step;
                                while true do
				begin
					if inrange(x1,y1) then goto break1;
					x1 :=x1+ 1;
					y1 := y1+step;
				end;
                                break1:
			end
			else
			begin
				step:= tan( (a-270) * DEG2RAD );
				x1:= int(px)-0.0000001;
				y1:= py + (px-x1) * step;
				while true do
				begin
                                        if inrange(x1,y1) then goto break2;
					x1:=x1- 1;
					y1:=y1+step;
				end;
                                break2:
			end
		end;
		(* Bewegung auf der Y-achse *)
		if( a <> 270) and (a<>90 ) then
		begin
			if( cosa > 0 ) then {nach vorne}
			begin
                                step:= tan( a * DEG2RAD );
				y2:= int(py)+1;
				x2:= px + (y2-py) * step;
                                while true do
				begin
                                        if inrange(x2,y2) then goto break3;
					y2 :=y2+ 1;
					x2 := x2+step;
				end;
                                break3:

			end
			else
			begin
				step:= tan( (a-180) * DEG2RAD );
				y2:= int(py)-0.000001;
				x2:= px - (py-y2) * step;
				while true do {Hinten}
				begin
                                       if inrange(x2,y2) then goto break4;
					y2 :=y2- 1;
					x2 :=x2-step;
				end;
                                break4:
			end;
		end;

		dist1:= sqr(px-x1)+sqr(py - y1);
		dist2:= sqr(px-x2)+sqr(py - y2);
		if( dist1 > dist2 ) then
		begin
			dist:= round(int(sqrt(dist2) * 1024));
                        h:= Abs(128 - round(128 * x2));
		end
		else
		begin
			dist:= round(int(sqrt(dist1) * 1024));
                        h:= abs(128 - round(128 * y1));
		end;

		height:= magic div dist;
		stp:= 64*65536 div height;
		hmh:= scr_horizon - height; hph:= scr_horizon + height;

		darkness:= dist shr 10;
		if( darkness > 16 ) then darkness:= 16
		else if darkness > 0  then dec(darkness);
		darkness:= (darkness shl 8);

		if( hmh < 0 ) then
		begin
			v:= (0 - hmh) * stp;
			hmh:= 0;
			hph:= scr_height;
		end
		else v:= 0;

		DrawWallFloor;
	end;
end;

procedure flip(src,dst:word); assembler;
asm
  push ds
  mov ax,[dst]
  mov es,ax
  mov ax,[src]
  mov ds,ax
  xor si,si
  xor di,di
  mov cx,320*200/4
  rep;db 66h; movsw
  pop ds
end;

procedure cls(lvseg:word); assembler;
asm
  mov es,[lvseg]
  xor di,di
  db 66h; xor ax,ax
  mov cx,320*200/4
  rep;db 66h;stosw
end;

PROCEDURE draw_map;
VAR i, j, offset, color:Word;
BEGIN
   color:= 100;
   FOR i:= 0 TO 31 DO
      FOR j:= 0 TO 31 DO
         BEGIN
            IF map[i+(j SHL  5)] > 0 THEN
               BEGIN
                  offset:= 62*320+228+(i*3)+(j*3)*320;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+1]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+2]:= color;

                  offset:=offset+ 320;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+1]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+2]:= color;

                  offset:=offset+320;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+1]:= color;
                  mem[Seg(Vaddr^):Ofs(Vaddr^)+offset+2]:= color;
               END;
         END;
END;

PROCEDURE evalkeys;
BEGIN
   IF key[left] THEN
      BEGIN
         IF turn < 1 THEN turn:= 1
         ELSE IF  turn < 8 THEN turn:=turn*2;
      END
   ELSE IF key[right] THEN
      BEGIN
         IF( turn > -1 ) THEN turn:= -1
         ELSE IF( turn > -8 ) THEN turn:=turn*2;
      END
   ELSE
      BEGIN
         turn:=turn * 0.6;
      END;

   IF key[down] THEN {down}
      BEGIN
         IF( step > -0.1 ) THEN step:= -0.1
         ELSE IF( step > -0.25 ) THEN step:=Step * 1.1;
      END
   ELSE IF key[up] THEN {Up}
      BEGIN
         IF( step < 0.1 ) THEN step:= 0.1
         ELSE IF( step < 0.25 ) THEN step:=step* 1.1;
      END
   ELSE
      step:= step*0.8;
END;

var Timer : LongInt Absolute $0040:$006c;
    first,FPS : Longint;

VAR	newpx, newpy, sinh, cosh:Real;
        t:Word;
BEGIN
   _Shade:=@shade;
   GetMem(Vaddr,64000);
   GetMem(Floor,16384);
   GetMem(Ceiling,16384);
   GetMEM(Wall,16384);
   cls(seg(vaddr^));
   loadmap('karte.map');

   initint09;
   asm mov ax,13h; Int 10h; END;

   LoadPCX('boden.pcx', floor, 0, 128 ); (* Lade Texturen *)
   LoadPCX('decke.pcx', ceiling, 0, 128 );
   LoadPCX('brick1.pcx', wall,0, 128 );

   Set_Shade;
   draw_map;
   {!!!}
   flip(seg(vaddr^),$a000);
   While Not Key[Up] do ;

   {!!!}
        first:= timer;frames:=0;fps:=15;
        WHILE not key[EscKey] DO
           BEGIN
              evalkeys;
              heading:=heading + turn;
              IF heading>= 360 THEN heading:= 0
              ELSE IF heading<= 0  THEN heading:= 360;

              (* Bewegen *)
              IF( step > 0 ) THEN
                 BEGIN
                    sinh:=Sin(heading*DEG2RAD);
                    newpx:= px + ( (sinh) * (step+0.5));
                    cosh:=Cos(heading*DEG2RAD);
                    newpy:= py + ( (cosh) * (step+0.5));
                 END
              ELSE IF( step < 0 ) THEN
                 BEGIN
                    sinh:=Sin(heading*DEG2RAD);
                    newpx:= px + ( sinh) * (step-0.5);
                    cosh:=Cos(heading*DEG2RAD);
                    newpy:= py + ( (cosh)) * (step-0.5);
                 END;
              IF (map[round(int(newpx))+round(int(py+0.1)) SHL 5] <= 0) AND
                 (map[round(int(newpx))+round(int(py-0.1)) SHL 5] <= 0)
              THEN
                 px :=px + sinh * step;
              IF (map[round(int(px+0.1))+round(int(newpy)) SHL 5] <= 0) AND
                 (map[round(int(px-0.1))+round(int(newpy)) SHL 5] <= 0 )
              THEN
                 py := py + cosh * step;

              compute_view;

              inc(frames);
              if frames>=100 then
               begin
                fps:=frames div ((timer-first) div 18);
                frames:=0;
                first:=timer;
               end;
              if(fps>25) then Retrace;

              flip(seg(vaddr^),$a000);
           END;

        restoreint09;
        asm mov ax,3h; Int 10h; END;
        FreeMem(vaddr,64000);
        FreeMem(floor,16384);
        FreeMem(ceiling,16384);
        Freemem(Wall,16374);
        writeln('Speed: ',fps,' Frames/Second');
END.