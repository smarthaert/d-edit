{Use calls to int 10 to set the grafix mode then write to the video mem

A Simple, Untested graf unit by Nowhere Man:
}
{$G+}
unit mcga;

interface

const
  graphmode = $13;
  textmode = $3;

procedure setmode(mode : word);

procedure putpixel(x,y : word; col : byte);

function  getpixel(x,y : word) : byte;

procedure fputpixel(x,y : word; col : byte);

function  fgetpixel(x,y : word) : byte;

procedure setdaccolor(colornum,r,g,b : byte);

implementation


{Simple procedure to get into and out of grafx mode
 call as setmode(graphmode) or setmode(textmode)
 (or setmode($13) and setmode(3) if you're feeling rebelious}
procedure setmode;assembler;
asm
  mov ax,mode
  int 10h
end;


{Slow procedure to set a pixel on the screen}
procedure putpixel;
begin
  mem[$a000:y*320+x] := col;
end;

{Slow procedure to grab a pixel from the screen}
function getpixel;
begin
  getpixel := mem[$a000:y*320+x];
end;

{Fast procedure to set a pixel on the screen}
procedure fputpixel;assembler;
asm
  mov es,sega000
  mov bx,x
  mov ax,y
  shl ax,6
  add bx,ax
  shl ax,2
{
Now, I know that there are a few of you out there that are looking at those
shls and saying "Why tha hell'd he do that instead of a MUL???

Well, let me tell you.

The formula to set a pixel to the screen is (y*[numberofcolumns]+x) = color.

In 320x200 mode numberofcolumns is 320

Now note that (y*320) = (y*256+y*64)

When you do a MUL, the processor repetedly adds numbers instead of
  actually multiplying them.  For instance, a built in program in the chip
  interprets

  mov ax,5
  mov bx,7
  mul bx

  more or less as....

  mov cx,5
  mov ax,7
  xor bx,bx
@loop1:
    add bx,ax
    loop loop1

This might not be exactally what the chip does, but you get the idea.

The repeted series of adds can take HUNDREDS of cycles to complete

A SHL takes 3 cycles on a 386 and 2 cycles on a 486

So say you store x in bx and y in ax...

Then you shl ax by 6, effectively MUL'ing it by 64

Now suppose you were to add that value to what's in... let's say BX

Now suppose you were to shl ax yet another 2 bits, getting the origional y
  value * 64 * 4, or the origional y value times.... 256!

Then add what's in ax to bx and if you've been following along you find that
  bx now equals x + y*64 + y*256, which I have already established is equal to
  y*320+x.  And there you go.
}
  add bx,ax
  mov al,col
  mov es:[bx],al
end;

{Fast procedure to grab a pixel from the screen}
function fgetpixel;assembler;
asm
  mov es,sega000
  mov bx,x
  mov ax,y
  shl ax,6
  add bx,ax
  shl ax,2
  add bx,ax
  mov al,es:[bx]
end;

{
Sets colors in the DAC. usage: setdaccolor(colornum,redval,blueval,greenval)
  where redval, blueval, and greenval represent the red,green.&blue part of
  that color

For Instance, if you wanted to change color #0, which in normally black, to
red, you would just do setdaccolor(0,63,0,0);
}
procedure setdaccolor; assembler;
asm
  mov dx,3c8h
  mov al,colornum
  cli
  out dx,al
  inc dx
  mov al,r
  out dx,al
  mov al,g
  out dx,al
  mov al,b
  out dx,al
  sti
end;

end.

--*-*-*- Next Section -*-*-*--
