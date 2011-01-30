(********************************************************************)
(*                         GRAPHIX TOOLBOX 4.0                      *)
(*       Copyright (c) 1985, 87 by  Borland International, Inc.     *)
(*                                                                  *)
(*         Graphics module for IBM Enhanced Graphics Adapter        *)
(********************************************************************)

unit GDriver;

interface

{$I Float.inc}  { Determines what type Float means. }

uses
  Dos, Crt, graph;
{$IFOPT N+}
type
  Float = Double; { 8 byte real, requires 8087 math chip }

{$ELSE}
type
  Float = real;   { 6 byte real, no math chip required }

{$ENDIF}

const
  MaxWorldsGlb = 4;
  MaxWindowsGlb = 16;
  MaxPiesGlb = 10;
  MaxPlotGlb = 100;
  StringSizeGlb = 80;
  HeaderSizeGlb = 10;
  RamScreenGlb : boolean = false;
  CharFile : string[StringSizeGlb] = '4x6.fon';
  MaxProcsGlb = 27;
  MaxErrsGlb = 7;
  AspectFactor   = 0.86;           { Aspect ratio for a true circle }
  ScreenSizeGlb  = 16383;          { Total size -1 of the screen in words }
  HardwareGrafBase : word = $A000; { Location of the hardware screen }
  XMaxGlb        = 79;             { Number of bytes -1 in one screen line }
  XScreenMaxGlb  = 639;            { Number of pixels -1 in one screen line }
  YMaxGlb        = 349;            { Number of lines -1 on the screen }
  IVStepGlb      = 2;              { Initial value of VStepGlb }
  MinForeground : word = 0;        { Lowest allowable foreground color }
  MaxForeground : word = 15;       { Highest allowable foreground color }
  MinBackground : word = 0;        { Lowest allowable background color }
  MaxBackground : word = 15;       { Highest allowable background color }

type
  WrkString = string[StringSizeGlb];
  WrkStringPtr = ^WrkString;
  WorldType = record
                X1, Y1, X2, Y2 : Float;
              end;
  WindowType = record
                 X1, Y1, X2, Y2 : integer;
                 Header : WrkString;
                 Drawn, Top : boolean;
                 Size : word;
               end;
  Worlds = array[1..MaxWorldsGlb] of WorldType;
  Windows = array[1..MaxWindowsGlb] of WindowType;
  PlotArray  = array[1..MaxPlotGlb, 1..2] of Float;

{ variabile aggiunta }
  PlotArray2 = array[1..5, 1..2] of Float;
{                    }


  Character = array[1..3] of byte;
  CharArray = array[32..126] of character;
  PieType = record
              Area : Float;
              Text : WrkString;
            end;
  PieArray = array[1..MaxPiesGlb] of PieType;
  BackgroundArray = array[0..7] of byte;
  LineStyleArray = array[0..7] of boolean;
  ScreenType        = array[0..ScreenSizeGlb] of word;
  ScreenPointer     = ^ScreenType;
  WindowStackRecord = record
                        W : WindowType;
                        Contents : ScreenPointer;
                      end;
  Stacks            = array[1..MaxWindowsGlb] of WindowStackRecord;

var
  X1WldGlb, X2WldGlb, Y1WldGlb, Y2WldGlb, AxGlb, AyGlb, BxGlb, ByGlb : Float;
  X1RefGlb, X2RefGlb, Y1RefGlb, Y2RefGlb : integer;
  LinestyleGlb, MaxWorldGlb, MaxWindowGlb, WindowNdxGlb, WorldNdxGlb : integer;
  X1Glb, X2Glb, Y1Glb, Y2Glb : integer;
  XTextGlb, YTextGlb, VStepGlb : integer;
  PieGlb, DirectModeGlb, ClippingGlb, AxisGlb, HatchGlb : boolean;
  MessageGlb, BrkGlb, HeaderGlb, TopGlb, GrafModeGlb : boolean;
  CntGlb, ColorGlb,COLORTGLB : byte;
  ErrCodeGlb : integer;
  LineStyleArrayGlb : LineStyleArray;
  ErrorProc : array[0..MaxProcsGlb] of WrkStringPtr;
  ErrorCode : array[0..MaxErrsGlb] of WrkStringPtr;
  PcGlb : string[40];
  AspectGlb : Float;
  GrafBase : word;
  World : Worlds;
  GrafWindow : Windows;
  CharSet : CharArray;
  ScreenGlb : ScreenPointer;
  Stack : Stacks;


{ variabili aggiunte per il plotter }
  drawpol : boolean;   { per il plotter , segnala se sta
                         tracciando un poligono, allora non alza la penna
                         da un segmento al successivo }
  plotterglb : boolean; { segnala se il plotter Š attivo o meno }

  com1 : text;          { per la porta seriale }
  AI1,AI2,AI3,AI4 : STRING[4];  { stringhe per l'interfacciamento dati
                                  con il plotter }
  STROUT,strout1 : STRING[30];
{ *********************** fine dichiarazione dati ************************ }



function BaseAddress(Y : word) : word;
{ Calculate address of scanline Y }

procedure Error(ErrProc, ErrCode : integer);

function HardwarePresent : boolean;
{ Test for the presence of a graphics card }

procedure AllocateRAMScreen;
{ Allocates the RAM screen and makes sure that
  ScreenGlb is on a segment (16 byte) boundary }

procedure LeaveGraphic;
{ Exit from graphics mode and clear the screen }

procedure DC(C : byte);
{ Draw the character C at the position XTextGlb, YTextGlb }

procedure SetIBMPalette(PaletteNumber, Color : word);
{ Set up the palette registers on the IBM CGA }

procedure SetForegroundColor(Color : word);
{ Set the foreground color }

procedure SetBackgroundColor(Color : word);
{ Set the background color }

procedure ClearScreen;
{ Clear the displayed screen }

procedure EnterGraphic;
{ Enter graphics mode }

 procedure putpixel1( x, y : word; color : integer);
procedure DP(X, Y : word);
{ Plot a pixel at (X, Y) }

function PD(X, Y : word) : boolean;
{ Return true if the color of the pixel at (X, Y) matches ColorGlb }

procedure SetBackground8(Background : BackgroundArray);
{ Fills the active display with the specified bit pattern }

procedure SetBackground(Byt : byte);
{ Determines the background pattern of the active window }

procedure SaveScreen(FileName : WrkString);
{ Save the current screen on disk using FileName }

procedure LoadScreen(FileName : WrkString);
{ Load screen from file FileName }

procedure SwapScreen;
{ Exchanges the contents of the displayed
  screen with the contents of the RAM screen  }

procedure CopyScreen;
{ Copies the active screen onto the inactive screen }

procedure InvertScreen;
{ Inverts the image on the active screen }

implementation

const
  FontLoaded         : boolean =  false; { Has the font been loaded yet? }

  ForegroundColorGlb : word = 15;

type
  FontChar = array[0..13] of byte;
  GrfFont  = array[0..255] of FontChar;

var
  Font          : GrfFont;
  DisplayType   : (Other, EGAColor, EGAMono);
  SaveStateGlb  : word;
  GrafMode      : word;
  DisplayMem    : byte;

function BaseAddress{(Y : word) : word};
{ Calculate the address of scanline Y }
begin
   BaseAddress := Y * 80;
end; { BaseAddress }

procedure Error{(ErrProc, ErrCode : integer)};
var
  XLoc, YLoc : integer;
  Ch : char;

begin { Error }
  if not (ErrProc in [0..MaxProcsGlb]) then
  begin
    LeaveGraphic;
    WriteLn('FATAL Error 1: illegal procedure number ', ErrProc);
    Halt;
  end;
  if not (ErrCode in [0..MaxErrsGlb]) then
  begin
    LeaveGraphic;
    WriteLn('FATAL Error 2: illegal Error code ', ErrCode);
    Halt;
  end;
  ErrCodeGlb := ErrCode;
  if BrkGlb then
    LeaveGraphic;
  if MessageGlb or BrkGlb then
  begin
    XLoc := XTextGlb;
    YLoc := YTextGlb;
    GotoXY(1, 24);
    ClrEOL;
    WriteLn('Turbo Graphix Error #', ErrCode, ' in procedure #', ErrProc);
    if MessageGlb then
    begin
      ClrEOL;
      Write('(', ErrorCode[ErrCode]^, ' in ', ErrorProc[ErrProc]^, ')');
    end;
  end;
  if BrkGlb then
    Halt
  else if MessageGlb then
    begin
      Write('.  Hit enter: ');
      repeat
        Ch := ReadKey;
      until (Ch = ^M) or (Ch = ^C);
      if Ch = ^C then
      begin
        LeaveGraphic;
        Halt;
      end;
      GotoXY(XLoc, YLoc);
    end;
end; { Error }

function HardwarePresent{ : boolean};
{ Test for the presence of a graphics card }
var
  Regs : Registers;

begin
  with Regs do
  begin
    AH := $12;
    BX := $FF10;
    Intr($10, Regs);
    if BH = $FF then     { EGA not installed }
      DisplayType := Other
    else if CL = 9 then     { EGA present with enhanced color display }
      begin
        GrafMode := $0010;
        MinForeground := 0;
        MaxForeground := 15;
        MinBackground := 0;
        MaxBackground := 15;
        DisplayType := EGAColor;
      end
    else if CL = 11 then { EGA present with monochrome display }
      begin
        GrafMode := $000F;
        MinForeground := 0;
        MaxForeground := 3;
        MinBackground := 0;
        MaxBackground := 3;
        DisplayType := EGAMono;
      end
    else
      DisplayType := Other;
    DisplayMem := BL;
  end;
  HardwarePresent := DisplayType <> Other;
end; { HardwarePresent }

procedure AllocateRAMScreen;
{ Allocates the RAM screen and makes sure that
  ScreenGlb is on a segment (16 byte) boundary }
var
  BytePtr : ^byte;
begin
  New(ScreenGlb);
  while Ofs(ScreenGlb^) <> 0 do
  begin
    Dispose(ScreenGlb);
    New(BytePtr);
    New(ScreenGlb);
  end;
end; { AllocateRAMScreen }


procedure putpixel1(X , Y : word; color : integer);
begin
     PUTPIXEL(X , Y, color);
      IF PLOTTERGLB THEN
      BEGIN
       FILLCHAR(STROUT,30,' ');
       FILLCHAR(AI1,3,' ');
       FILLCHAR(AI2,3,' ');
       STR((TRUNC(X)):4,AI1);
       STR((TRUNC(Y)):4,AI2);
       STROUT:='PA'+AI1+','+AI2+',PD;';
       WRITELN(COM1,STROUT);
      END;
end;

{$L GrafEGA.OBJ}
procedure DC{(C : byte)}; external;

procedure DP{(X, Y : word)}; external;

procedure SwapScreen; external;

procedure InvertScreen; external;

{$F+}
function WriteGrafChars(var F : TextRec) : integer;
{ Used to output graphics characters through the standard output channel. }
const
  BackSpace = #8;
  LineFeed  = #10;
  Return    = #13;
var
  I : integer;
begin
  with F do
    if Mode = fmOutput then
    begin
      if BufPos > BufEnd then
      begin
        for I := BufEnd to Pred(BufPos) do  { Flush the output buffer }
        begin
          case BufPtr^[I] of
            BackSpace : if XTextGlb > 1 then
                          DEC(XTextGlb);

            LineFeed  : if YTextGlb < 25 then
                          INC(YTextGlb);

            Return    : XTextGlb := 1;
          else
            DC(ORD(BufPtr^[I]));
            if XTextGlb < 80 then
              INC(XTextGlb);
          end; { case }
        end; { for }
      end;
      BufPos := BufEnd;
    end; { if }
  WriteGrafChars := 0;
end; { WriteGrafChars }

function GrafCharZero(var F : TextRec) : integer;
{ Called when standard output is opened and closed }
begin
  GrafCharZero := 0;
end; { GrafCharZero }
{$F-}

var
  OldOutput : Text; { Stores output I/O channel }

procedure GrafCharsON;
{ Redirects standard output to the WriteGrafChars function. }
begin
  Move(Output, OldOutput, SizeOf(Output));  { Save old output channel }
  with TextRec(Output) do
  begin
    OpenFunc:=@GrafCharZero;       { no open necessary }
    InOutFunc:=@WriteGrafChars;    { WriteGrafChars gets called for I/O }
    FlushFunc:=@WriteGrafChars;    { WriteGrafChars flushes automatically }
    CloseFunc:=@GrafCharZero;      { no close necessary }
    Name[0]:=#0;
  end;
end; { GrafCharsON }

procedure GrafCharsOFF;
{ Restores original output I/O channel }
begin
  Move(OldOutput, Output, SizeOf(OldOutput));
end; { GrafCharsOFF }

procedure LeaveGraphic;
{ Exit from graphics mode and clear the screen }
var
  Regs : Registers;
begin
  closegraph;
  Regs.AX := SaveStateGlb;
  Intr($10, Regs);
  GrafCharsOFF;
  GrafModeGlb := false;
end; { LeaveGraphic }

procedure SetIBMPalette{(PaletteNumber, Color : word)};
{ Set the palette registers on the IBM EGA }
var
  Regs : Registers;
begin
  with Regs do
  begin
    AX := $1000;
    BH := Color;
    BL := PaletteNumber;
    Intr($10, Regs);
  end;
end; { SetIBMPalette }

procedure SetForegroundColor{(Color : word)};
{ Set the foreground color }
begin
  if DisplayType = EGAMono then
    SetIBMPalette(2, Color)
  else if DisplayMem = 0 then
    SetIBMPalette(5, Color)
  else
    SetIBMPalette(15, Color);
  ForegroundColorGlb := Color;

  setcolor(color);
  colorglb:=color;
end; { SetForegroundColor }

procedure SetBackgroundColor{(Color : word)};
{ Set the background color }
begin
  SetIBMPalette(0, Color);

  setbkcolor(color);
  setcolor(15-color);
  colorglb:=15-color;
end; { SetBackgroundColor }

procedure ClearScreen;
{ Clear the graphics screen }
begin
  FillChar(Mem[GrafBase:0000], ScreenSizeGlb shl 1, 0);
end; { ClearScreen }

procedure EnterGraphic;
{ Enter graphics mode }
var
  Regs     : Registers;
  FontFile : file of GrfFont;
begin
  if not FontLoaded then
  begin
    Assign(FontFile, '14x9.FON');
    {$I-} Reset(FontFile); {$I+}
    if IOresult = 0 then
      begin
        Read(FontFile, Font);
        Close(FontFile);
      end
    else
      FillChar(Font, SizeOf(Font), 0);
    FontLoaded := true;
  end;
  SaveStateGlb := 10;
  Regs.AX := $0F00;
  Intr($10, Regs);
  if (Regs.AL < 4) or (SaveStateGlb = 10) then
    SaveStateGlb := Regs.AL;
  Regs.AX := GrafMode;
  Intr($10, Regs);
  (* SetForegroundColor(MaxForeground); *)
  if not GrafModeGlb then
    GrafCharsON;
  GrafModeGlb := true;
end; { EnterGraphics }

function PD{(X, Y : word) : boolean};
{ Return true if the color of the pixel at (X, Y) matches ColorGlb }
begin
  PD := (ColorGlb = 0) xor (Mem[GrafBase:BaseAddress(Y) + X shr 3]
                       and (128 shr (X and 7)) <> 0);
end; { PD }

procedure SetBackground8{(Background : BackgroundArray)};
{ Fills the active display with the specified bit pattern }
var
  I : word;
begin
  for I := Y1RefGlb to Y2RefGlb do
    FillChar(Mem[GrafBase:BaseAddress(I) + X1RefGlb], X2RefGlb - X1RefGlb + 1,
             Background[I and 7]);
end; { SetBackground8 }

procedure SetBackground{(Byt : byte)};
{ Determines the background pattern of the active window }
var
  Bk : BackgroundArray;
begin
  FillChar(Bk, 8, Byt);
  SetBackground8(Bk);

  if(Byt = 0)   then begin; setcolor(15);colorglb:=15;end;
  if(Byt = 255) then begin; setcolor(0) ;colorglb:=0; end;
end; { SetBackground }



procedure SaveScreen{(FileName : WrkString)};
{ Save the current screen on disk using FileName }
type
  PicFile = file of ScreenType;
var
  Picture : ScreenPointer;
  PictureFile : PicFile;
  IOerr : boolean;

procedure IOCheck;
begin
  IOerr := IOresult <> 0;
  if IOerr then
    Error(27, 5);
end; { IOCheck }

begin { SaveScreen }
  if FileName <> '' then
    begin
      IOerr := false;
      Picture := Ptr(GrafBase, 0);
      Assign(PictureFile, FileName);
      {$I-} Rewrite(PictureFile); {$I+}
      IOCheck;
      if not IOerr then
      begin
        {$I-} Write(PictureFile, Picture^); {$I+}
        IOCheck;
      end;
      if not IOerr then
      begin
        {$I-} Close(PictureFile); {$I+}
        IOCheck;
      end;
    end
  else
    Error(27, 5);
end; { SaveScreen }

procedure LoadScreen{(FileName : WrkString)};
{ Load screen from file FileName }
type
  PicFile = file of ScreenType;
var
  Picture : ScreenPointer;
  PictureFile : PicFile;
begin
  if FileName <> '' then
    begin
      Picture := Ptr(GrafBase, 0);
      Assign(PictureFile, FileName);
      {$I-} Reset(PictureFile); {$I+}
      if IOresult <> 0 then
        Error(11, 5)
      else
        begin
          Read(PictureFile, Picture^);
          Close(PictureFile);
        end;
    end
  else
    Error(11, 5);
end; { LoadScreen }

procedure CopyScreen;
var
  ToBase : word;
begin
  if RamScreenGlb then
  begin
    if GrafBase = HardwareGrafBase then
      ToBase := Seg(ScreenGlb^)
    else
      ToBase := HardwareGrafBase;
    Move(Mem[GrafBase:0000], Mem[ToBase:0000], ScreenSizeGlb shl 1);
  end;
end; { CopyScreen }

end. { GDriver }