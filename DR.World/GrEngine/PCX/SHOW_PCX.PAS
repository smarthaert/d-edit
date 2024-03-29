{$R-}    {Range checking off}
{$B-}    {Boolean complete evaluation off}
{$S-}    {Stack checking off}
{$I+}    {I/O checking on}
{$N-}    {No numeric coprocessor}

program show_pcx;

{****************************************************************************}
{                                                                            }
{ SHOW_PCX is an example program written in Borland's Turbo Pascal(R) 5.0.   }
{ (Turbo Pascal is a registered trademark of Borland International, Inc.)    }
{ SHOW_PCX doesn't use any of the graphics routines built into Turbo Pascal, }
{ since many programmers won't be using Pascal for their final program.      }
{                                                                            }
{                            PERMISSION TO COPY:                             }
{                                                                            }
{          SHOW_PCX -- (C) Copyright 1989 ZSoft, Corporation.                }
{                                                                            }
{ You are licensed to freely copy SHOW_PCX and incorporate it into your      }
{ own programs, provided that:                                               }
{                                                                            }
{  IF YOU COPY SHOW_PCX WITHOUT CHANGING IT:                                 }
{  (1) You must retain this "Permission to Copy" notice, and                 }
{  (2) You must not charge for the SHOW_PCX software or                      }
{      documentation; however, you may charge a service fee for              }
{      disk duplication and distribution, so long as such fee is             }
{      not more than $5.00.                                                  }
{                                                                            }
{  IF YOU MODIFY SHOW_PCX AND/OR INCORPORATE SHOW_PCX INTO YOUR OWN PROGRAMS }
{  (1) You must include the following acknowledgment notice in the           }
{      appropriate places:                                                   }
{                                                                            }
{      Includes portions of SHOW_PCX.                                        }
{      Used by permission of ZSoft Corporation.                              }
{                                                                            }
{                                                                            }
{ ZSoft Corporation reserves all rights to SHOW_PCX except as stated herein. }
{                                                                            }
{                                                                            }
{                  [END OF "PERMISSION TO COPY" NOTICE]                      }
{                                                                            }
{ This program reads a PC Paintbrush PCX file and shows it on the screen.    }
{ The picture must be a 2 color CGA, 4 color CGA, or a 16 color EGA picture. }
{ The picture will be displayed until a key is pressed.                      }
{                                                                            }
{ This program can be run at the DOS prompt - 'SHOW_PCX SAMPLE.PCX'.         }
{                                                                            }
{****************************************************************************}
{                                                                            }
{ Since this program is provided as a service, you are on your own when      }
{ when you modify it to work with your own programs.                         }
{                                                                            }
{ We strive to make every program bug-free. If you find any bugs in this     }
{ program, please contact us on Compuserve (76702,1207)                      }
{ However, this program is provided AS IS and we are not responsible for any }
{ problems you might discover.                                               }
{                                                                            }
{****************************************************************************}
{                                                                            }
{ Remember, some computers and video adapters are NOT 100% compatible, no    }
{ matter what their marketing department may say. This shows up when your    }
{ program runs on everyone's computer EXCEPT a particular clone.             }
{ Unfortunately, there is not much you can do to correct it.                 }
{                                                                            }
{ For example, some early VGA cards do not support the BIOS calls to set up  }
{ a VGA palette - so the PCX image may come up all black, or with the wrong  }
{ colors.                                                                    }
{                                                                            }
{ Also, if you use code that attempts to determine what kind of video card   }
{ is attached to the computer it may lock-up...                              }
{                                                                            }
{****************************************************************************}
{                                                                            }
{ The PCX file format was originally developed in 1982, when there were only }
{ three video addapters: CGA, Hercules, and the Tecmar Graphics Master. Over }
{ the years, as new hardware became available (EGA, VGA, etc.), we had to    }
{ modify the format. Wherever posible, we insure downward compatiblity. This }
{ means, if you follow the suggestions in this program, your own program     }
{ should be able to read 'new' PCX files in the future.                      }
{                                                                            }
{****************************************************************************}

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
{
  NEEDED ADDITIONS:
  CGA palette - read old and new palette - set screen palette
}
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


uses
  Crt, Dos;

const
   MAX_WIDTH = 4000;    { arbitrary - maximum width (in bytes) of a PCX image }
   COMPRESS_NUM = $C0;  { this is the upper two bits that indicate a count }
   MAX_BLOCK = 4096;

   RED = 0;
   GREEN = 1;
   BLUE = 2;

   CGA4 = $04;          { video modes }
   CGA2 = $06;
   EGA  = $10;
   VGA  = $12;
   MCGA = $13;

type
   str80 = string [80];
   file_buffer = array [0..127] of byte;
   block_array = array [0..MAX_BLOCK] of byte;
   pal_array = array [0..255, RED..BLUE] of byte;
   ega_array = array [0..16] of byte;
   line_array = array [0..MAX_WIDTH] of byte;

   pcx_header = record
        Manufacturer: byte;     { Always 10 for PCX file }

        Version: byte;          { 2 - old PCX - no palette (not used anymore),
                                  3 - no palette,
                                  4 - Microsoft Windows - no palette (only in
                                      old files, new Windows version uses 3),
                                  5 - with palette }

        Encoding: byte;         { 1 is PCX, it is possible that we may add
                                  additional encoding methods in the future }

        Bits_per_pixel: byte;   { Number of bits to represent a pixel
                                  (per plane) - 1, 2, 4, or 8 }

        Xmin: integer;          { Image window dimensions (inclusive) }
        Ymin: integer;          { Xmin, Ymin are usually zero (not always) }
        Xmax: integer;
        Ymax: integer;

        Hdpi: integer;          { Resolution of image (dots per inch) }
        Vdpi: integer;          { Set to scanner resolution - 300 is default }

        ColorMap: array [0..15, RED..BLUE] of byte;
                                { RGB palette data (16 colors or less)
                                  256 color palette is appended to end of file }

        Reserved: byte;         { (used to contain video mode)
                                  now it is ignored - just set to zero }

        Nplanes: byte;          { Number of planes }

        Bytes_per_line_per_plane: integer;   { Number of bytes to allocate
                                               for a scanline plane.
                                               MUST be an an EVEN number!
                                               Do NOT calculate from Xmax-Xmin! }

        PaletteInfo: integer;   { 1 = black & white or color image,
                                  2 = grayscale image - ignored in PB4, PB4+
                                  palette must also be set to shades of gray! }

        HscreenSize: integer;   { added for PC Paintbrush IV Plus ver 1.0,  }
        VscreenSize: integer;   { PC Paintbrush IV ver 1.02 (and later)     }
                                { I know it is tempting to use these fields
                                  to determine what video mode should be used
                                  to display the image - but it is NOT
                                  recommended since the fields will probably
                                  just contain garbage. It is better to have
                                  the user install for the graphics mode he
                                  wants to use... }

        Filler: array [74..127] of byte;     { Just set to zeros }
        end;

var
   Name: str80;                        { Name of PCX file to load }
   ImageName: str80;                   { Name of PCX file - used by ReadError }
   BlockFile: file;                    { file for reading block data }
   BlockData: block_array;             { 4k data buffer }

   Header: pcx_header;                 { PCX file header }
   Palette256: pal_array;              { place to put 256 color palette }
   PaletteEGA: ega_array;              { place to put 17 EGA palette values }
   PCXline: line_array;                { place to put uncompressed data }

   Ymax: integer;                      { maximum Y value on screen }
   NextByte: integer;                  { index into file buffer in ReadByte }
   Index: integer;                     { PCXline index - where to put Data }
   Data: byte;                         { PCX compressed data byte }

   PictureMode: integer;               { Graphics mode number }
   Reg: Registers;                     { Register set - used for int 10 calls }


{ ================================= Error ================================== }

procedure Error (s: str80 );

{ Print out the error message and wait, then halt }

var c: char;
    i: integer;

begin
TextMode (C80);
writeln ('ERROR');
writeln (s);
halt;
end;   { Error }


{ =============================== ReadError =============================== }

procedure ReadError (msg: integer);

{ Check for an i/o error }

begin
if IOresult <> 0 then
   case msg of
   1: Error ('Can''t open file - ' + ImageName);
   2: Error ('Error closing file - ' + ImageName + ' - disk may be full');
   3: Error ('Error reading file - ' + ImageName);

   else
      Error ('Error doing file I/O - ' + ImageName);
   end;   { case }
end;   { ReadError }


{ =========================== VideoMode =============================== }

procedure VideoMode (n: integer);

{ Do a BIOS call to set the video mode }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

begin
Reg.ah := $00;
Reg.al := n;                         { mode number }
intr ($10, Reg);                     { call interrupt }
end;  { VideoMode }


{ =========================== EGApalette =============================== }

procedure EGApalette (n, R, G, B: integer);

{ Set a single EGA's palette register.
  n is the index of the palette register.
  R, G, and B are 0..255. }

{ This code is never called - it is here as an example }

{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var i: integer;

begin
R := R shr 6;                        { R, G, and B are now 0..3 }
G := G shr 6;
B := B shr 6;
i := (R shl 4) + (G shl 2) + B;

Reg.ah := $10;
Reg.al := 0;                         { set individual palette register }
Reg.bh := i;                         { value }
Reg.bl := n;                         { palette register number }
intr ($10, Reg);                     { call interrupt }
end;  { EGApalette }


{ =========================== VGApalette =============================== }

procedure VGApalette (n, R, G, B: integer);

{ Set a single VGA palette and DAC register pair.
  n is the index of the palette register.
  R, G, and B are 0..255. }

{ This code is never called - it is here as an example }

{ In Turbo Pascal, a '$' means the number is hexadeximal. }

begin
R := R shr 2;                        { R, G, and B are now 0..63 }
G := G shr 2;
B := B shr 2;

Reg.ah := $10;                       { Set Palette Call }
Reg.al := $0;                        { set individual palette register }
Reg.bl := n;                         { palette register number 0..15, 0..255 }
Reg.bh := n;                         { palette register value }
intr ($10, Reg);                     { call interrupt }

Reg.ah := $10;                       { Set DAC Call }
Reg.al := $10;                       { set individual DAC register }
Reg.bx := n;                         { DAC register number 0..15, 0..255 }
Reg.dh := R;                         { red value 0..63 }
Reg.ch := G;                         { green value 0..63 }
Reg.cl := B;                         { blue value 0..63 }
intr ($10, Reg);                     { call interrupt }
end;  { VGApalette }


{ =========================== EGA16palette =============================== }

procedure EGA16palette;

{ Set the EGA's entire 16 color palette. }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   i, r, g, b: integer;

begin
for i := 0 to 15 do
   begin
   r := Header.ColorMap [i, RED]   shr 6;       { r, g, and b are now 0..3 }
   g := Header.ColorMap [i, GREEN] shr 6;
   b := Header.ColorMap [i, BLUE]  shr 6;
   PaletteEGA [i] := (r shl 4) + (g shl 2) + b;
   end;
PaletteEGA [16] := 0;                { border color }

Reg.ah := $10;                       { Set Palette Call }
Reg.al := $02;                       { set a block of palette registers }
Reg.dx := ofs (PaletteEGA);          { offset of block }
Reg.es := seg (PaletteEGA);          { segment of block }
intr ($10, Reg);                     { call interrupt }

end;  { EGA16palette }


{ =========================== VGA16palette =============================== }

procedure VGA16palette;

{ Set the VGA's entire 16 color palette. }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   i: integer;

begin
for i := 0 to 15 do
   PaletteEGA [i] := i;
PaletteEGA [16] := 0;                { border color }

Reg.ah := $10;                       { Set Palette Call }
Reg.al := $02;                       { set a block of palette registers }
Reg.dx := ofs (PaletteEGA);          { offset of block }
Reg.es := seg (PaletteEGA);          { segment of block }
intr ($10, Reg);                     { call interrupt }

for i := 0 to 15 do
   begin                                          { R, G, and B must be 0..63 }
   Palette256 [i, RED]   := Header.ColorMap [i, RED]   shr 2;
   Palette256 [i, GREEN] := Header.ColorMap [i, GREEN] shr 2;
   Palette256 [i, BLUE]  := Header.ColorMap [i, BLUE]  shr 2;
   end;

Reg.ah := $10;                       { Set DAC Call }
Reg.al := $12;                       { set a block of DAC registers }
Reg.bx := 0;                         { first DAC register number }
Reg.cx := 255;                       { number of registers to update }
Reg.dx := ofs (Palette256);          { offset of block }
Reg.es := seg (Palette256);          { segment of block }
intr ($10, Reg);                     { call interrupt }

end;  { VGA16palette }


{ =========================== EntireVGApalette =============================== }

procedure EntireVGApalette;

{ Set the VGA's entire 256 color palette. }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   i: integer;

begin
for i := 0 to 255 do
   begin                                          { R, G, and B must be 0..63 }
   Palette256 [i, RED]   := Palette256 [i, RED]   shr 2;
   Palette256 [i, GREEN] := Palette256 [i, GREEN] shr 2;
   Palette256 [i, BLUE]  := Palette256 [i, BLUE]  shr 2;
   end;

Reg.ah := $10;                       { Set DAC Call }
Reg.al := $12;                       { set a block of DAC registers }
Reg.bx := 0;                         { first DAC register number }
Reg.cx := 255;                       { number of registers to update }
Reg.dx := ofs (Palette256);          { offset of block }
Reg.es := seg (Palette256);          { segment of block }
intr ($10, Reg);                     { call interrupt }

end;  { EntireVGApalette }


{ =========================== SetPalette =============================== }

procedure SetPalette;

{ Set up the entire graphics palette }

var i: integer;

begin
if PictureMode = MCGA then
   EntireVGApalette
else if PictureMode = VGA then
   VGA16palette
else
   EGA16palette;
end;  { SetPalette }


{ =========================== ShowCGA =============================== }

procedure ShowCGA (Y: integer);

{ Put a line of CGA data on the screen }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   i, j, l, m, t: integer;
   Yoffset: integer;
   CGAScreen: array [0..32000] of byte absolute $B800:$0000;

begin
i := 8 div Header.Bits_per_pixel;        { i is pixels per byte }

if (i = 8) then                          { 1 bit per pixel }
   j := 7
else                                     { 2 bits per pixel }
   j := 3;

t := (Header.Xmax - Header.Xmin + 1);    { width in pixels }
m := t and j;                            { left over bits }

l := (t + j) div i;                      { compute number of bytes to display }
if l > 80 then
   begin
   l := 80;                              { don't overrun screen width }
   m := 0;
   end;

if (m <> 0) then                         { we need to mask unseen pixels }
   begin
   m := $FF shl (8 - (m * Header.Bits_per_pixel));   { m = mask }
   t := l - 1;
   PCXline [t] := PCXline [t] and m;     { mask off unseen pixels }
   end;

Yoffset := 8192 * (Y and 1);
Move (PCXline [0], CGAScreen [((Y shr 1) * 80) + Yoffset], l);

end;   { ShowCGA }


{ =========================== ShowEGA =============================== }

procedure ShowEGA (Y: integer);

{ Put a line of EGA (or VGA) data on the screen }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   i, j, l, m, t: integer;
   EGAplane: integer;
   EGAscreen: array [0..32000] of byte absolute $A000:$0000;

begin
EGAplane := $0100;                       { the first plane to update }
PortW [$3CE] := $0005;                   { use write mode 0 }

{ PortW [$3CE] := $0005;      does port I/O by words. It is the same as:

  Out 03CEh,05h
  Out 03CFh,00h
}

t := (Header.Xmax - Header.Xmin + 1);    { width in pixels }
m := t and 7;                            { left over bits }

l := (t + 7) shr 3;                      { compute number of bytes to display }
if (l >= 80) then
   begin
   l := 80;                              { don't overrun screen width }
   m := 0;
   end;

if (m <> 0) then
   m := $FF shl (8 - m)                  { m = mask for unseen pixels }
else
   m := $FF;

for i := 0 to Header.Nplanes-1 do
   begin
   j := i * Header.Bytes_per_line_per_plane;
   t := j + l - 1;
   PCXline [t] := PCXline [t] and m;           { mask off unseen pixels }

   PortW [$3C4] := EGAplane + 2;               { set plane number }
   Move (PCXline [j], EGAscreen [Y * 80], l);
   EGAplane := EGAplane shl 1;
   end;

PortW [$3C4] := $0F02;                         { default plane mask }
end;   { ShowEGA }


{ =========================== ShowMCGA =============================== }

procedure ShowMCGA (Y: integer);

{ Put a line of MCGA data on the screen }
{ In Turbo Pascal, a '$' means the number is hexadeximal. }

var
   l: integer;
   MCGAscreen: array [0..64000] of byte absolute $A000:$0000;

begin
l := Header.XMax - Header.Xmin;            { compute number of bytes to display }
if l > 320 then
   l := 320;                               { don't overrun screen width }

Move (PCXline [0], MCGAScreen [Y * 320], l);

end;   { ShowMCGA }


{ =========================== Read256palette =============================== }

procedure Read256palette;

{ Read in a 256 color palette at end of PCX file }

var
   i: integer;
   b: byte;

begin
seek (BlockFile, FileSize (BlockFile) - 769);
BlockRead (BlockFile, b, 1);           { read indicator byte }
ReadError (3);

if b <> 12 then                        { no palette here... }
   exit;

BlockRead (BlockFile, Palette256, 3*256);
ReadError (3);

seek (BlockFile, 128);                 { go back to start of PCX data }

end;  { Read256palette }


{ =========================== ReadHeader =============================== }

procedure ReadHeader;

{ Load a picture header from a PC Paintbrush PCX file }

label WrongFormat;

begin
{$I-}
BlockRead (BlockFile, Header, 128);         { read 128 byte PCX header }
ReadError (3);

                                            { Is it a PCX file? }
if (Header.Manufacturer <> 10) or (Header.Encoding <> 1) then
   begin
   close (BlockFile);
   Error ('This is not a valid PCX image file.');
   end;

if (Header.Nplanes = 4) and (Header.Bits_per_pixel = 1) then
   begin
   if (Header.Ymax - Header.Ymin) <= 349 then
      begin
      PictureMode := EGA;
      Ymax := 349;
      end
   else
      begin
      PictureMode := VGA;
      Ymax := 479;
      end;
   end
else if (Header.Nplanes = 1) then
   begin
   Ymax := 199;

   if (Header.Bits_per_pixel = 1) then
      PictureMode := CGA2
   else if (Header.Bits_per_pixel = 2) then
      PictureMode := CGA4
   else if (Header.Bits_per_pixel = 8) then
      begin
      PictureMode := MCGA;
      if Header.Version = 5 then
         Read256palette;
      end
   else
      goto WrongFormat;
   end
else
   begin
WrongFormat:
   close (BlockFile);
   Error ('PCX file is in wrong format - It must be a CGA, EGA, VGA, or MCGA image');
   end;

Index := 0;
NextByte := MAX_BLOCK;          { indicates no data read in yet... }

end;  { ReadHeader }


{ =========================== ReadByte =============================== }

procedure ReadByte;

{ read a single byte of data - use BlockRead because it is FAST! }

var
   NumBlocksRead: integer;

begin
if NextByte = MAX_BLOCK then
   begin
   BlockRead (BlockFile, BlockData, MAX_BLOCK, NumBlocksRead);
   NextByte := 0;
   end;

data := BlockData [NextByte];
inc (NextByte);                         { NextByte++; }
end;  { ReadByte }


{ =========================== Read_PCX_Line =============================== }

procedure Read_PCX_Line;

{ Read a line from a PC Paintbrush PCX file }

var
   count: integer;
   bytes_per_line: integer;

begin
{$I-}

bytes_per_line := Header.Bytes_per_line_per_plane * Header.Nplanes;

                          { bring in any data that wrapped from previous line }
                          { usually none  -  this is just to be safe          }
if Index <> 0 then
   FillChar (PCXline [0], Index, data);    { fills a contiguous block of data }

while (Index < bytes_per_line) do          { read 1 line of data (all planes) }
   begin
   ReadByte;

   if (data and $C0) = compress_num then
      begin
      count := data and $3F;
      ReadByte;
      FillChar (PCXline [Index], count, data);  { fills a contiguous block }
      inc (Index, count);                       { Index += count; }
      end
   else
      begin
      PCXline [Index] := data;
      inc (Index);                              { Index++; }
      end;
   end;

ReadError (3);

Index := Index - bytes_per_line;

{$I+}
end;  { Read_PCX_Line }


{ =========================== Read_PCX =============================== }

procedure Read_PCX (name: str80);

{ Read PC Paintbrush PCX file and put it on the screen }

var
   k, kmax: integer;

begin
{$I-}
ImageName := name;                     { used by ReadError }

assign (BlockFile, name);
reset (BlockFile, 1);                  { use 1 byte blocks }
ReadError (1);

ReadHeader;                            { read the PCX header }

{ >>>>> No checking is done to see if the user has the correct hardware <<<<<
  >>>>> to load the image. Your program sure verify the video mode is   <<<<<
  >>>>> supported. Otherwise, the computer may lock-up.                 <<<<< }

VideoMode (PictureMode);               { switch to graphics mode }
if Header.Version = 5 then
   SetPalette;                         { set the screen palette, if available }

{ >>>>> Note: You should compute the height of the image as follows. <<<<<
  >>>>> Do NOT just read until End-Of-File!                          <<<<< }

kmax := Header.Ymin + Ymax;
if Header.Ymax < kmax then        { don't show more than the screen can display }
   kmax := Header.ymax;

if (PictureMode = EGA) or (PictureMode = VGA) then
   begin
   for k := Header.Ymin to kmax do          { each loop is separate for speed }
      begin
      Read_PCX_Line;
      ShowEGA (k);
      end;
   end
else if (PictureMode = MCGA) then
   begin
   for k := Header.Ymin to kmax do
      begin
      Read_PCX_Line;
      ShowMCGA (k);
      end;
   end
else                                         { it's a CGA picture }
   begin
   for k := Header.Ymin to kmax do
      begin
      Read_PCX_Line;
      ShowCGA (k);
      end;
    end;

close (BlockFile);
ReadError (2);
{$I+}
end;  { Read_PCX }


{ =========================== DISPLAY_PCX =============================== }

procedure display_pcx (name: str80);

{ Display a PCX picture }

var
   c: char;

begin
Read_PCX (name);              { read and display the file }

while (not KeyPressed) do     { wait for any key to be pressed }
   { nothing };

c := ReadKey;                 { now get rid of the key that was pressed }
if c = #0 then                { handle function keys }
   c := ReadKey;

end;   { display_pcx }


{ *************************** MAIN ******************************* }

begin
ClrScr;
writeln ('         SHOW_PCX - read and display a PC Paintbrush (R) picture');
writeln;
writeln ('                            PERMISSION TO COPY:');
writeln ('            SHOW_PCX -- (C) Copyright 1989 ZSoft, Corporation.');
writeln;
writeln ('You are licensed to freely copy SHOW_PCX and incorporate it into your');
writeln ('own programs, provided that:');
writeln ('  IF YOU COPY SHOW_PCX WITHOUT CHANGING IT:');
writeln ('  (1) You must retain this "Permission to Copy" notice, and');
writeln ('  (2) You must not charge for the SHOW_PCX software or documentaion;');
writeln ('      however, you may charge a service fee for disk duplication and');
writeln ('      distribution, so long as such fee is not more than $5.00');
writeln ('  IF YOU MODIFY SHOW_PCX AND/OR INCORPORATE SHOW_PCX INTO YOUR OWN PROGRAMS');
writeln ('  (1) You must include the following notice in the appropriate places:');
writeln ('      Includes portions of SHOW_PCX. Used by permission of ZSoft Corporation.');
writeln;
writeln (' ZSoft Corporation reserves all rights to SHOW_PCX except as stated herein.');
writeln (' ZSoft Corporation,  450 Franklin Road, Suite 100,  Marietta, GA 30067');
writeln (' (404) 428-0008');
writeln ('                  [END OF "PERMISSION TO COPY" NOTICE]');
writeln;

if (ParamCount = 0) then           { no DOS command line parameters }
   begin
   writeln ('The image must be a 2 or 4 color CGA, 16 color EGA or VGA,');
   writeln ('or a 256 color MCGA picture');
   writeln;

   write ('Enter name of picture file to display: ');
   readln (name);
   writeln;
   end
else
   Name := ParamStr (1);           { get filename from DOS command line }

if (Pos ('.', Name) = 0) then      { make sure the filename has PCX extension }
   Name := Concat (Name, '.pcx');

display_pcx (Name);

TextMode (co80);                   { back to text mode }

end.  { Show_PCX }
