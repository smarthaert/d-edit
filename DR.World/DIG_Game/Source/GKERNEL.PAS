{ MODIFICATO DRAWLINEDIRECT CHE USA PUTPIXEL1 AL POSTO DI PUTPIXEL
             E
             DRAWLINE                                              }




(********************************************************************)
(*                         GRAPHIX TOOLBOX 4.0                      *)
(*       Copyright (c) 1985, 87 by  Borland International, Inc.     *)
(********************************************************************)
unit GKernel;

interface

{$I Float.inc}  { Determines what type Float means. }

uses
  Dos, Crt, GDriver, graph;

procedure GotoXY(X, Y : integer);
{ Set the text position }

procedure ClrEOL;
{ Clear from the current text position to the end of the line }

procedure SetBreakOff;

procedure SetBreakOn;

function GetErrorCode : integer;

procedure SetWindowModeOff;

procedure SetWindowModeOn;

procedure SetClippingOn;

procedure SetClippingOff;

procedure SetMessageOn;

procedure SetMessageOff;

procedure SetHeaderOn;

procedure SetHeaderOff;

procedure SetHeaderToTop;

procedure SetHeaderToBottom;

procedure RemoveHeader(I : integer);

procedure SetColorWhite;

procedure SetColorBlack;

function GetWindow : integer;

function GetColor : word;

function Clipping : boolean;

function WindowMode : boolean;

procedure SetScreenAspect(Aspect : Float);

function GetScreenAspect : Float;

procedure SetAspect(Aspect : Float);

function GetAspect : Float;

{procedure SetLinestyle(Ls : word);}


{ funzioni cambiate visto che esiste gi… in Graph.tpu la
  setlinestyle :- setlinestyle in setgline style
                - setgcolor aggiunta anche per plotter }


procedure SetgLinestyle(Ls : word);

procedure Setgcolor(Ls : word);

{ ******************************* }


function GetLinestyle : word;

procedure SetVStep(Vs : word);

function GetVStep : word;

procedure DefineHeader(I : integer; Hdr : WrkString);

procedure SelectScreen(I : word);

function GetScreen : byte;

procedure DefineWorld(I : integer; X_1, Y_1, X_2, Y_2 : Float);

procedure SelectWorld(I : integer);

procedure ReDefineWindow(I, X_1, Y_1, X_2, Y_2 : integer);

procedure DefineWindow(I, X_1, Y_1, X_2, Y_2 : integer);

function TextLeft(TX, Boundary : integer) : integer;

function TextRight(TX, Boundary : integer) : integer;

function TextUp(TY, Boundary : integer) : integer;

function TextDown(TY, Boundary : integer) : integer;

procedure DefineTextWindow(I, X1, Y1, X2, Y2, B : integer);

procedure SelectWindow(I : integer);

function WindowX(X : Float) : integer;

function WindowY(Y : Float) : integer;

procedure InitGraphic;

procedure ResetWindows;

procedure ResetWorlds;

function Clip(var X1, Y1, X2, Y2 : integer) : boolean;

procedure DrawPoint(Xr, Yr : Float);

function PointDrawn(Xr, Yr : Float) : boolean;

procedure DrawLine(X1, Y1, X2, Y2 : Float);

procedure DrawLineClipped(X1, Y1, X2, Y2 : integer);

procedure DrawCrossDiag(X, Y, Scale : integer);

procedure DrawWye(X, Y, Scale : integer);

procedure DrawDiamond(X, Y, Scale : integer);

procedure DrawCircleDirect(Xr, Yr, R : integer; DirectModeLoc : boolean);

procedure DrawCircle(X_R, Y_R, Xradius : Float);

procedure DrawCross(X1, Y1, Scale : integer);

procedure DrawStar(X, Y, Scale : integer);

procedure DrawStraight(X1, X2, Y : word);

procedure DrawSquareC(X1, Y1, X2, Y2 : integer; Fill : boolean);

procedure DrawSquare(X1, Y1, X2, Y2 : Float; Fill : boolean);

procedure DrawAscii(var X, Y : integer; Size, Ch : byte);

procedure DrawText(X, Y, Scale : integer; Txt : WrkString);

procedure DrawTextW(X, Y : Float; Scale : integer; Txt : WrkString);

procedure DrawBorder;

procedure HardCopy(Inverse : boolean; Mode : byte);  { EPSON }

implementation

procedure GotoXY{(X, Y : integer)};
{ Set the text position }
begin
  if (X >= 1) and (X <= 80) and    { Ignore illegal values }
     (Y >= 1) and (Y <= 25) then
  begin
    if GrafModeGlb then
      begin
        XTextGlb := X;      { Set text postion in graphics mode }
        YTextGlb := Y;
      end
    else
      Crt.GotoXY(X, Y);     { Set cursor position in text mode }
  end;
end; { GotoXY }

procedure ClrEOL;
{ Clear from the current text position to the end of the line }
var
  TempX : integer;
begin
  if GrafModeGlb then
    begin
      TempX := XTextGlb;
      for XTextGlb := TempX to 79 do
        DC(32);
      XTextGlb := TempX;
    end
  else
    Crt.ClrEOL;
end; { ClrEOL }

procedure SetBreakOff;
begin
  BrkGlb := false;
end; { SetBreakOff }

procedure SetBreakOn;
begin
  BrkGlb := true;
end; { SetBreakOn }

function GetErrorCode{ : integer};
begin
  GetErrorCode := ErrCodeGlb;
  ErrCodeGlb := -1; { Reset to No error }
end; { GetErrorCode }

procedure SetWindowModeOff;
begin
  DirectModeGlb := true;
end; { SetWindowModeOff }

procedure SetWindowModeOn;
begin
  DirectModeGlb := false;
end; { SetWindowModeOn }

procedure SetClippingOn;
begin
  ClippingGlb := true;
end; { SetClippingOn }

procedure SetClippingOff;
begin
  ClippingGlb := false;
end; { SetClippingOff }

procedure SetMessageOn;
begin
  MessageGlb := true;
end; { SetMessageOn }

procedure SetMessageOff;
begin
  MessageGlb := false;
end; { SetMessageOff }

procedure SetHeaderOn;
begin
  HeaderGlb := true;
end; { SetHeaderOn }

procedure SetHeaderOff;
begin
  HeaderGlb := false;
end; { SetHeaderOff }

procedure SetHeaderToTop;
begin
  TopGlb := true;
end; { SetHeaderToTop }

procedure SetHeaderToBottom;
begin
  TopGlb := false;
end; { SetHeaderToBottom }

procedure RemoveHeader{(I : integer)};
begin
  if I in [1..MaxWindowsGlb] then
    with GrafWindow[I] do
    begin
      if HeaderGlb then
      begin
        if Top then
          begin
            Dec(Y1, HeaderSizeGlb);
            if Y1 < 0 then
              Y1 := 0;
            RedefineWindow(I, X1, Y1, X2, Y2);
          end
        else
          begin
            Inc(Y2, HeaderSizeGlb);
            if Y2 > YMaxGlb then
              Y2 := YMaxGlb;
            RedefineWindow(I, X1, Y1, X2, Y2);
          end;
        if I = WindowNdxGlb then
          SelectWindow(I);
      end;
      Drawn := false;
      Top := true;
      Header := '';
    end
  else
    Error(22, 2);
end; { RemoveHeader }

procedure SetColorWhite;
begin
{  ColorGlb := 15;
  setcolor(15); }
  setgcolor(15);
end; { SetColorWhite }

procedure SetColorBlack;
begin
{ ColorGlb := 0;
 setcolor(0); }
 setgcolor(253);
end; { SetColorBlack }

function GetWindow{ : integer};
begin
  GetWindow := WindowNdxGlb;
end; { GetWindow }

function GetColor{ : word};
begin
  GetColor := ColorGlb;
end; { GetColor }

function Clipping{ : boolean};
begin
  Clipping := ClippingGlb;
end; { Clipping }

function WindowMode{ : boolean};
begin
  WindowMode := not DirectModeGlb;
end; { WindowMode }

procedure SetScreenAspect{(Aspect : Float)};
begin
  if Aspect <> 0.0 then
    AspectGlb := abs(Aspect);
end; { SetScreenAspect }

function GetScreenAspect{ : Float};
begin
  GetScreenAspect := AspectGlb;
end; { GetScreenAspect }

procedure SetAspect{(Aspect : Float)};
begin
  if Aspect <> 0.0 then
    AspectGlb := abs(Aspect) * AspectFactor;
end; { SetAspect }

function GetAspect{ : Float};
begin
  GetAspect := AspectGlb / AspectFactor;
end; { GetAspect }


procedure SetgLinestyle{(Ls : word)};
var
  I : integer;
const
  Lsa : array[0..4] of byte = ($FF,$88,$F8,$E4,$EE);

begin
  if (Ls < 0) or (Ls > 5) then
    Ls := Ls and $FF + $100;
  LineStyleGlb := Ls;
  if Ls < 5 then
    Ls := Lsa[Ls];
  for I := 0 to 7 do
    LineStyleArrayGlb[7 - I] := ((Ls shr I) and 1) <> 0;
  CntGlb := 7;
end; { SetgLinestyle }


procedure SetgColor{(Ls : word)};
 var ls1 : word;
begin
  IF (PLOTTERGLB AND (COLORGLB <> LS)) THEN BEGIN (* PER IL PLOTTER *)
     { se la penna non e' quella selezionata }
     Ls1:=(Ls mod 8);   {get a valid pen color}
     FILLCHAR(STROUT,30,' ');
     FILLCHAR(AI1,3,' ');
     STR(LS1+1:4,AI1);
     STROUT:='SP'+AI1+';';
     WRITELN(COM1,STROUT);
  END;
{  setcolor((Ls+3) mod 16);}
  setcolor((Ls) mod 16);
  COLORGLB:=LS;
end; { SetgColor }


function GetLinestyle{ : word};
begin
  GetLinestyle := LinestyleGlb;
end; { GetLinestyle }

procedure SetVStep{(Vs : word)};
begin
  if Vs > 0 then
    VStepGlb := Vs;
end; { SetVStep }

function GetVStep{ : word};
begin
  GetVStep := VStepGlb;
end; { GetVStep }

procedure DefineHeader{(I : integer; Hdr : WrkString)};
begin
  if (I in [1..MaxWindowsGlb]) then
    GrafWindow[I].Header := Hdr
  else
    Error(3, 2);
end; { DefineHeader }

procedure SelectScreen{(I : word)};
begin
  if RamScreenGlb and (I = 2) then
    GrafBase := Seg(ScreenGlb^)
  else
    GrafBase := HardwareGrafBase;
end; { SelectScreen }

function GetScreen{ : byte};
begin
  if GrafBase = HardwareGrafBase then
    GetScreen := 1
  else
    GetScreen := 2;
end; { GetScreen }

procedure DefineWorld{(I : integer; X_1, Y_1, X_2, Y_2 : Float)};
begin
  if ((X_1 <> X_2) and (Y_1 <> Y_2)) and (I in [1..MaxWorldsGlb]) then
    with World[I] do
    begin
      X1 := X_1; Y1 := Y_1; X2 := X_2; Y2 := Y_2;
      if I > MaxWorldGlb then
        MaxWorldGlb := I;
    end
  else if I in [1..MaxWorldsGlb] then
    Error(1, 3)
  else
    Error(1, 2);
end; { DefineWorld }

procedure SelectWorld{(I : integer)};
begin
  if (I in [1..MaxWorldGlb]) then
    with World[I] do
    begin
      WorldNdxGlb := I;
      X1WldGlb := X1;
      Y1WldGlb := Y1;
      X2WldGlb := X2;
      Y2WldGlb := Y2;
    end
  else
    Error(2, 2);
end; { SelectWorld }

procedure ReDefineWindow{(I, X_1, Y_1, X_2, Y_2 : integer)};
begin
  if (I in [1..MaxWindowsGlb]) and (X_1 <= X_2) and (Y_1 <= Y_2) and (X_1 >= 0)
     and (X_2 <= XMaxGlb) and (Y_1 >= 0) and (Y_2 <= YMaxGlb) then
    with GrafWindow[I] do
    begin
      Drawn := false;
      X1 := X_1;
      Y1 := Y_1;
      X2 := X_2;
      Y2 := Y_2;
      if I > MaxWindowGlb then
        MaxWindowGlb := I;
    end
  else if I in [1..MaxWindowsGlb] then
    Error(3, 3)
  else
    Error(3, 2);
end; { ReDefineWindow }

procedure DefineWindow{(I, X_1, Y_1, X_2, Y_2 : integer)};
begin
  ReDefineWindow(I, X_1, Y_1, X_2, Y_2);
  if ErrCodeGlb = -1 then
  begin
    with GrafWindow[I] do
    begin
      Header := '';
      Top := true;
      Drawn := false;
    end;
  end;
end; { DefineWindow }

function TextLeft{(TX, Boundary : integer) : integer};
var
  TL : integer;
begin
  TL := ((TX - 1) * ((XScreenMaxGlb + 1) div 80) - Boundary) div 8;
  if TL < 0 then
    TL := 0
  else if TL > XMaxGlb then
    TL := XMaxGlb;
  TextLeft := TL;
end; { TextLeft }

function TextRight{(TX, Boundary : integer) : integer};
var
  TR : integer;
begin
  TR := (XScreenMaxGlb + 1) div 80;
  TR := (TX * TR + Boundary - 1) div 8;
  if TR < 0 then
    TR := 0
  else if TR > XMaxGlb then
    TR := XMaxGlb;
  TextRight := TR;
end; { TextRight }

function TextUp{(TY, Boundary : integer) : integer};
var
  TU : integer;
begin
  TU := (TY - 1) * ((YMaxGlb + 1) div 25) - Boundary;
  if TU < 0 then
    TU := 0
  else if TU > YMaxGlb then
    TU := YMaxGlb;
  TextUp := TU;
end; { TextUp }

function TextDown{(TY, Boundary : integer) : integer};
var
  TD : integer;
begin
  TD := TY * ((YMaxGlb + 1) div 25) + Boundary - 1;
  if TD < 0 then
    TD := 0
  else if TD > YMaxGlb then
    TD := YMaxGlb;
  TextDown := TD;
end; { TextDown }

procedure DefineTextWindow{(I, X1, Y1, X2, Y2, B : integer)};
begin
  DefineWindow(I, TextLeft(X1, B), TextUp(Y1, B),
               TextRight(X2, B), TextDown(Y2, B));
end; { DefineTextWindow }

procedure SelectWindow{(I : integer)};
begin
  if (I in [1..MaxWindowGlb]) then
    with GrafWindow[I] do
    begin
      WindowNdxGlb := I;
      X1RefGlb := X1;
      Y1RefGlb := Y1;
      X2RefGlb := X2;
      Y2RefGlb := Y2;
      BxGlb := ((X2 - X1) shl 3 + 7) / (X2WldGlb - X1WldGlb);
      ByGlb := (Y2 - Y1) / (Y2WldGlb - Y1WldGlb);
      AxGlb := (X1 shl 3) - X1WldGlb * BxGlb;
      AyGlb := Y1 - Y1WldGlb * ByGlb;
      if AxisGlb then
      begin
        AxisGlb := false;
        X1Glb := 0;
        Y1Glb := 0;
        X2Glb := 0;
        Y2Glb := 0;
      end;
    end
  else
    Error(4, 2);
end; { SelectWindow }

function WindowX{(X : Float) : integer};
var
  Temp : Float;
begin
  Temp := AxGlb + BxGlb * X;
  if Temp > MaxInt then
    WindowX := MaxInt
  else if Temp < -32767 then
    WindowX := -32767
  else
    WindowX := trunc(Temp);
end; { WindowX }

function WindowY{(Y : Float) : integer};
var
  Temp : Float;
begin
  Temp := AyGlb + ByGlb * Y;
  if Temp > MaxInt then
    WindowY := MaxInt
  else if Temp < -32767 then
    WindowY := -32767
  else
    WindowY := trunc(Temp);
end; { WindowY }

procedure InitGraphic;
var
  Fil : file of CharArray;
  Tfile : text;
  Test : ^integer;
  Temp : WrkString;
  I : word;
  grdriver,grmode : integer;

begin
  MessageGlb := true;
  BrkGlb := false;
  GrafModeGlb := false;
  GotoXY(1, 1);
  if not HardwarePresent then
  begin
    ClrScr;
    GotoXY(1, 2);
    WriteLn('Fatal Error: graphics hardware not found or not properly activated');
    Halt;
  end;
  GetMem(ErrorProc[0], 16);
  GetMem(ErrorCode[0], 24);
  ErrorProc[0]^ := 'InitGraphic';
  ErrorCode[0]^ := 'Error.MSG missing';
  Assign(Tfile, 'Error.msg');
  {$I-} Reset(Tfile); {$I+}
  if IOresult = 0 then
    begin
      for I := 0 to MaxProcsGlb do
      begin
        ReadLn(Tfile, Temp);
        if I <> 0 then
          GetMem(ErrorProc[I], Length(Temp) + 1);
        ErrorProc[I]^ := Temp;
      end;
      for I := 0 to MaxErrsGlb do
      begin
        ReadLn(Tfile, Temp);
        if I <> 0 then
          GetMem(ErrorCode[I], Length(Temp) + 1);
        ErrorCode[I]^ := Temp;
      end;
      ReadLn(Tfile, PcGlb);
      Close(Tfile);
    end
  else
    begin
      GetMem(ErrorProc[1], 14);
      ErrorProc[1]^ := '** UNKNOWN **';
      for I := 2 to MaxProcsGlb do
        ErrorProc[I] := ErrorProc[1];
      for I := 1 to MaxErrsGlb do
        ErrorCode[I] := ErrorProc[1];
      Error(0, 0);
    end;
  for I := 1 to MaxWorldsGlb do
    DefineWorld(I, 0, 0, XScreenMaxGlb, YMaxGlb);
  MaxWorldGlb := 1;
  for I := 1 to MaxWindowsGlb do
  begin
    DefineWindow(I, 0, 0, XMaxGlb, YMaxGlb);
    with Stack[I] do
    begin
      W.Size := 0;
      Contents := nil;
    end;
  end;
  MaxWindowGlb := 1;
  if CharFile <> '' then
  begin
    Assign(Fil, CharFile);
    {$I-} Reset(Fil); {$I+}
    if IOresult = 0 then
      begin
        Read(Fil, CharSet);
        Close(Fil);
      end
    else
      Error(0, 1);
  end;
  BrkGlb := true;
(*  if RamScreenGlb then
  begin
    AllocateRAMScreen;
    SelectScreen(2);
    ClearScreen;
  end;                 *)
  SelectScreen(1);
  WindowNdxGlb := 1;
  SelectWorld(1);
  SelectWindow(1);


  SetClippingOn;
  SetAspect(AspectFactor);
  DirectModeGlb := false;
  PieGlb := false;
  SetMessageOn;
  SetHeaderOff;
  SetHeaderToTop;
  ErrCodeGlb := -1;

  VStepGlb := IVStepGlb;

  EnterGraphic;
  X1Glb := 0;
  X2Glb := 0;
  Y1Glb := 0;
  Y2Glb := 0;
  AxisGlb := false;
  HatchGlb := false;


  grdriver:=3;
  grmode:=1;
  initgraph(grdriver,grmode,'');
  setglinestyle(0);
  SetColorWhite;
  if RamScreenGlb then
  begin
    AllocateRAMScreen;
    SelectScreen(2);
    ClearScreen;
  end;
  SelectScreen(1);
end; { InitGraphic }

procedure ResetWindows;
var
  I : word;
begin
  for I := 1 to MaxWindowsGlb do
  begin
    DefineWindow(I, 0, 0, XMaxGlb, YMaxGlb);
    RemoveHeader(I);
  end;
  SelectWindow(1);
end; { ResetWindows }

procedure ResetWorlds;
var
  I : word;
begin
  for I := 1 to MaxWorldsGlb do
    DefineWorld(I, 0, 0, XScreenMaxGlb, YMaxGlb);
  SelectWorld(1);
  SelectWindow(WindowNdxGlb);
end; { ResetWorlds }

function Clip{(var X1, Y1, X2, Y2 : integer) : boolean};
var
  Ix1, Iy1, Ix2, Iy2, Dummy, X1Loc, X2Loc : integer;
  ClipLoc : boolean;
  Temp : Float;

function Inside(X, Xx1, Xx2 : integer) : integer;
begin
  Inside := 0;
  if X < Xx1 then
    Inside := -1
  else if X > Xx2 then
    Inside := 1;
end; { Inside }

begin  { Clip }
  Clip := true;
  ClipLoc := true;
  if ClippingGlb then
    begin
      if HatchGlb then
        begin
          X1Loc := X1RefGlb;
          X2Loc := X2RefGlb;
        end
      else
        begin
          X1Loc := X1RefGlb shl 3;
          X2Loc := X2RefGlb shl 3 + 7;
        end;
      Ix1 := Inside(X1, X1Loc, X2Loc);
      Iy1 := Inside(Y1, Y1RefGlb, Y2RefGlb);
      Ix2 := Inside(X2, X1Loc, X2Loc);
      Iy2 := Inside(Y2, Y1RefGlb, Y2RefGlb);
      if (Ix1 or Ix2 or Iy1 or Iy2) <> 0 then
      begin
        if X1 <> X2 then
        begin
          if Ix1 <>0 then
          begin
            if Ix1 < 0 then
              Dummy := X1Loc
            else
              Dummy := X2Loc;
            if Y2 <> Y1 then
            begin
              Temp := (Y2 - Y1) / (X2 - X1) * (Dummy - X1);
              if Temp > MaxInt then
                Temp := MaxInt
              else if Temp < -32767 then
                Temp := -32767;
              Y1 := Y1 + trunc(Temp);
            end;
            X1 := Dummy;
          end;
          if (Ix2 <> 0) and (X1 <> X2) then
          begin
            if Ix2 < 0 then
              Dummy := X1Loc
            else
              Dummy := X2Loc;
            if Y2 <> Y1 then
            begin
              Temp := (Y2 - Y1) / (X2 - X1) * (Dummy - X1);
              if Temp > MaxInt then
                Temp := MaxInt
              else if Temp < -32767 then
                Temp := -32767;
              Y2 := Y1 + trunc(Temp);
            end;
            X2 := Dummy;
          end;
          Iy1 := Inside(Y1, Y1RefGlb, Y2RefGlb);
          Iy2 := Inside(Y2, Y1RefGlb, Y2RefGlb);
        end;
        if Y1 <> Y2 then
        begin
          if Iy1 <> 0 then
          begin
            if Iy1 < 0 then
              Dummy := Y1RefGlb
            else
              Dummy := Y2RefGlb;
            if X1 <> X2 then
            begin
              Temp := (X2 - X1) / (Y2 - Y1) * (Dummy - Y1);
              if Temp > MaxInt then
                Temp := MaxInt
              else if Temp < -32767 then
                Temp := -32767;
              X1 := X1 + trunc(Temp);
            end;
            Y1 := Dummy;
          end;
          if Iy2 <> 0 then
          begin
            if Iy2 < 0 then
              Dummy := Y1RefGlb
            else
              Dummy := Y2RefGlb;
            if X1 <> X2 then
            begin
              Temp := (X2 - X1) / (Y2 - Y1) * (Dummy - Y1);
              if Temp > MaxInt then
                Temp := MaxInt
              else if Temp < -32767 then
                Temp := -32767;
              X2 := X1 + trunc(Temp);
            end;
            Y2 := Dummy;
          end;
        end;
        Iy1 := Inside(Y1, Y1RefGlb, Y2RefGlb);
        Iy2 := Inside(Y2, Y1RefGlb, Y2RefGlb);
        if (Iy1 <> 0) or (Iy2 <> 0) then
          ClipLoc := false;
        if ClipLoc then
        begin
          Ix1 := Inside(X1, X1Loc, X2Loc);
          Ix2 := Inside(X2, X1Loc, X2Loc);
          if (Ix2 <> 0) or (Ix1 <> 0) then
            ClipLoc := false;
        end;
        Clip := ClipLoc;
      end;
    end;
end; { Clip }

procedure DrawPoint{(Xr, Yr : Float)};
var
  X, Y : integer;
begin
  if DirectModeGlb then
    putpixel(trunc(Xr), trunc(Yr), colorglb)
  else
    begin
      X := WindowX(Xr);
      Y := WindowY(Yr);
      if ClippingGlb then
        begin
          if (X >= X1RefGlb shl 3) and (X <= X2RefGlb shl 3 + 7) then
            if (Y >= Y1RefGlb) and (Y <= Y2RefGlb) then
              putpixel(X, Y, colorglb);
        end
      else
        putpixel(X, Y, colorglb);
    end;
end; { DrawPoint }

function PointDrawn{(Xr, Yr : Float) : boolean};
begin
  if DirectModeGlb then
    PointDrawn := PD(trunc(Xr), trunc(Yr))
  else
    PointDrawn := PD(WindowX(Xr), WindowY(Yr));
end; { PointDrawn }

procedure DrawLine{(X1, Y1, X2, Y2 : Float)};
var
  X1Loc, Y1Loc, X2Loc, Y2Loc : integer;

procedure DrawLineDirect(X1, Y1, X2, Y2 : integer);
var
  X, Y, DeltaX, DeltaY, XStep, YStep, Direction : integer;
begin
  X := X1;
  Y := Y1;
  XStep := 1;
  YStep := 1;
  if X1 > X2 then
    XStep := -1;
  if Y1 > Y2 then
    YStep := -1;
  DeltaX := abs(X2 - X1);
  DeltaY := abs(Y2 - Y1);
  if DeltaX = 0 then
    Direction := -1
  else
    Direction := 0;
  while not ((X = X2) and (Y = Y2)) do
  begin
    if LinestyleGlb = 0 then
      putpixel1(X, Y, colorglb)
{TOLTO      putpixel(X, Y, colorglb)}
    else
      begin
        CntGlb := (CntGlb + 1) and 7;
        if LineStyleArrayGlb[CntGlb] then
          putpixel1(X, Y, colorglb);
{TOLTO          putpixel(X, Y, colorglb);  }
      end;
    if Direction < 0 then
      begin
        Y := Y + YStep;
        Direction := Direction + DeltaX;
      end
    else
      begin
        X := X + XStep;
        Direction := Direction - DeltaY;
      end;
  end;
end; { DrawLineDirect }

begin { DrawLine }
  if DirectModeGlb then
    (*DrawLineDirect(trunc(X1), trunc(Y1), trunc(X2), trunc(Y2))*)
    begin
      IF PLOTTERGLB THEN BEGIN (* PER IL PLOTTER *)
         FILLCHAR(STROUT,30,' ');
         FILLCHAR(AI1,3,' ');
         FILLCHAR(AI2,3,' ');
         FILLCHAR(AI3,3,' ');
         FILLCHAR(AI4,3,' ');
         STR((TRUNC(X1)):4,AI1);
         STR((TRUNC(Y1)):4,AI2);
         STR((TRUNC(X2)):4,AI3);
         STR((TRUNC(Y2)):4,AI4);
         IF DRAWPOL THEN
            STROUT:='PA'+AI1+','+AI2+',PD,'+AI3+','+AI4+';'
         ELSE
            STROUT:='PA'+AI1+','+AI2+',PD,'+AI3+','+AI4+',PU;';
         WRITELN(COM1,STROUT);
      END;
      Line(trunc(X1), trunc(Y1), trunc(X2), trunc(Y2));
  END
  else
    begin
      X1Loc := WindowX(X1);
      Y1Loc := WindowY(Y1);
      X2Loc := WindowX(X2);
      Y2Loc := WindowY(Y2);
      if Clip(X1Loc, Y1Loc, X2Loc, Y2Loc) then
       BEGIN
       if(clippingGlb) then
            DrawLineDirect(X1Loc, Y1Loc, X2Loc, Y2Loc)
        else

        { AL POSTO DI DRAWLINEDIRECT}
        begin
            Line(X1Loc, Y1Loc, X2Loc, Y2Loc);

         IF PLOTTERGLB THEN
            BEGIN (* PER IL PLOTTER *)
            FILLCHAR(STROUT,30,' ');
            FILLCHAR(AI1,3,' ');
            FILLCHAR(AI2,3,' ');
            FILLCHAR(AI3,3,' ');
            FILLCHAR(AI4,3,' ');
            str(X1Loc:4,AI1);
            STR(Y1Loc:4,AI2);
            STR(X2Loc:4,AI3);
            STR(Y2Loc:4,AI4);
            IF DRAWPOL THEN
               STROUT:='PA'+AI1+','+AI2+',PD,'+AI3+','+AI4+';'
             ELSE
               STROUT:='PA'+AI1+','+AI2+',PD,'+AI3+','+AI4+';'{PU;'};
            WRITELN(COM1,STROUT);
            END;
       end;
      END;
    end;
end; { DrawLine }

procedure DrawLineClipped{(X1, Y1, X2, Y2 : integer)};
var
  Temp : boolean;
begin
  if Clip(X1, Y1, X2, Y2) then
  begin
    Temp := DirectModeGlb;
    DirectModeGlb := true;
    DrawLine(X1, Y1, X2, Y2);
    DirectModeGlb := Temp;
  end;
end; { DrawLineClipped }

procedure DrawCrossDiag{(X, Y, Scale : integer)};
begin
  DrawLineClipped(X - Scale, Y + Scale, X + Scale + 1, Y - Scale - 1);
  DrawLineClipped(X - Scale, Y - Scale, X + Scale + 1, Y + Scale + 1);
end; { DrawCrossDiag }

procedure DrawWye{(X, Y, Scale : integer)};
begin
  DrawLineClipped(X - Scale, Y - Scale, X, Y);
  DrawLineClipped(X + Scale, Y - Scale, X, Y);
  DrawLineClipped(X, Y, X, Y + Scale);
end; { DrawWye }

procedure DrawDiamond{(X, Y, Scale : integer)};
begin
  DrawLineClipped(X - Scale, Y, X, Y - Scale - 1);
  DrawLineClipped(X, Y - Scale + 1, X + Scale, Y + 1);
  DrawLineClipped(X + Scale, Y + 1, X, Y + Scale);
  DrawLineClipped(X, Y + Scale, X - Scale, Y);
end; { DrawDiamond }

procedure DrawCircleDirect{(Xr, Yr, R : integer; DirectModeLoc : boolean)};
const
  N = 14;
type
  Circ = array[1..N] of integer;
const
  X : Circ = (0,121,239,355,465,568,663,749,823,885,935,971,993,1000);
var
  Xk1, Xk2, Yk1, Yk2, Xp1, Yp1, Xp2, Yp2 : integer;
  Xfact, Yfact : Float;
  I : integer;

procedure DrawLinW(X1, Y1, X2, Y2 : integer);
var
  DrawIt     : boolean;
  DirectSave : boolean;
begin
  DrawIt := DirectModeLoc;
  if DrawIt then
    begin
      DrawIt := Clip(X1, Y1, X2, Y2);
      if DrawIt then
      begin
        DirectSave := DirectModeGlb;
        DirectModeGlb := true;
        DrawLine(X1, Y1, X2, Y2);
        DirectModeGlb := DirectSave;
      end;
    end
  else
    begin
      DirectSave := DirectModeGlb;
      DirectModeGlb := true;
      DrawLine(X1, Y1, X2, Y2);
      DirectModeGlb := DirectSave;
    end;
end; { DrawLinW }

begin { DrawCircleDirect }
  Xfact := abs(R * 0.001);
  Yfact := Xfact * AspectGlb;
  if Xfact > 0.0 then
    begin
      Xk1 := trunc(X[1] * Xfact + 0.5);
      Yk1 := trunc(X[N] * Yfact + 0.5);
      for I := 2 to N do
      begin
        Xk2 := trunc(X[I] * Xfact + 0.5);
        Yk2 := trunc(X[N - I + 1] * Yfact + 0.5);
        Xp1 := Xr - Xk1;
        Yp1 := Yr + Yk1;
        Xp2 := Xr - Xk2;
        Yp2 := Yr + Yk2;
        DrawLinW(Xp1, Yp1, Xp2, Yp2);
        Xp1 := Xr + Xk1;
        Xp2 := Xr + Xk2;
        DrawLinW(Xp1, Yp1, Xp2, Yp2);
        Yp1 := Yr - Yk1;
        Yp2 := Yr - Yk2;
        DrawLinW(Xp1, Yp1 + 1, Xp2, Yp2 + 1);
        Xp1 := Xr - Xk1;
        Xp2 := Xr - Xk2;
        DrawLinW(Xp1, Yp1 + 1, Xp2, Yp2 + 1);
        Xk1 := Xk2;
        Yk1 := Yk2;
      end;
    end
  else
    putpixel(Xr, Yr, colorglb);
end; { DrawCircleDirect }

procedure DrawCircle{(X_R, Y_R, Xradius : Float)};
var
  DirectModeLoc : boolean;
begin
  DirectModeLoc := DirectModeGlb;
  DirectModeGlb := true;
  if DirectModeLoc then
    DrawCircleDirect(trunc(X_R), trunc(Y_R), trunc(Xradius), true)
  else
    DrawCircleDirect(WindowX(X_R), WindowY(Y_R), trunc(Xradius * 100.0), true);
  DirectModeGlb := DirectModeLoc;
end; { DrawCircle }

procedure DrawCross{(X1, Y1, Scale : integer)};
begin
  DrawLineClipped(X1 - Scale, Y1, X1 + Scale + 2, Y1);
  DrawLineClipped(X1, Y1 - Scale, X1, Y1 + Scale + 1);
end; { DrawCross }

procedure DrawStar{(X, Y, Scale : integer)};
begin
  DrawLineClipped(X - Scale, Y + Scale, X + Scale + 1, Y - Scale - 1);
  DrawLineClipped(X - Scale, Y - Scale, X + Scale + 1, Y + Scale + 1);
  DrawLineClipped(X - Scale - 2, Y, X + Scale + 4, Y);
end; { DrawStar }

procedure DrawStraight{(X1, X2, Y : word)};
{ Draw a horizontal line from X1,Y to X2,Y }
var
  I, X : word;
  DirectModeLoc : boolean;
begin
  if (not ((X1 < 0) or (X1 > XMaxGlb shl 3 + 7)) and not ((X2 < 0) or
     (X2 > XMaxGlb shl 3 + 7)) and ((Y >= 0) and (Y <= YMaxGlb))) then
    begin
      DirectModeLoc := DirectModeGlb;
      DirectModeGlb := true;
      if X1 > X2 then
      begin
        X := X1;
        X1 := X2;
        X2 := X;
      end;
      if X2 - X1 < 16 then
        (*for X := X1 to X2 do
          putpixel(X, Y, colorglb)*)
      BEGIN
          IF PLOTTERGLB THEN DRAWLINE(X1,Y,X2,Y); (* PER IL PLOTTER *)
          line(X1, Y, X2, Y);
      END
      else
        begin
        IF PLOTTERGLB THEN DRAWLINE(X1,Y,X2,Y); (* PER IL PLOTTER *)
          X1 := X1 + 8;
          (*for I := (X1 - 8) to (X1 and -8) do
            putpixel(I, Y, colorglb); *)
            line(X1 - 8, Y, (X1 and -8), Y);

           (* for I:= (X2 and -8) to X2 do  putpixel(I, Y, colorglb); *)
           line((X2 and -8), Y, X2, Y);

          FillChar(Mem[GrafBase:BaseAddress(Y) + (X1 shr 3)],
                  (X2 shr 3) - (X1 shr 3), colorglb);
        end;
      DirectModeGlb := DirectModeLoc;
    end;
end; { DrawStraight }

procedure DrawSquareC{(X1, Y1, X2, Y2 : integer; Fill : boolean)};
var
  I : integer;

procedure DSC(X1, X2, Y : integer);
var
  DirectSave : boolean;
begin
  if Clip(X1, Y, X2, Y) then
    if LineStyleGlb = 0 then
      DrawStraight(X1, X2, Y)
    else
      begin
        DirectSave := DirectModeGlb;
        DirectModeGlb := true;
        DrawLine(X1, Y, X2, Y);
        DirectModeGlb := DirectSave;
      end;
end; { DSC }

begin { DrawSquareC }
  if not Fill then

    begin
      DSC(X1, X2, Y1);
      DrawLineClipped(X2, Y1, X2, Y2);
      DSC(X1, X2, Y2);
      DrawLineClipped(X1, Y2, X1, Y1);
    end
  else
    begin
    setfillstyle(solidfill,ColorGlb);
    if Y2 > Y1 then
      (*
      for I := Y1 to Y2 do
        DSC(X1, X2, I) *)
        BAR(X1,Y1,X2,Y2)
    else
      (*
      for I := Y2 to Y1 do
        DSC(X1, X2, I); *)
        BAR(X1,Y2,X2,Y1);
    end;
end; { DrawSquareC }

procedure DrawSquare{(X1, Y1, X2, Y2 : Float; Fill : boolean)};
var
  I, X1Loc, Y1Loc, X2Loc, Y2Loc : integer;
  DirectModeLoc : boolean;

procedure DS(X1, X2, Y : integer);
begin
(*  if LineStyleGlb = 0 then
    DrawStraight(X1, X2, Y)
  else   *)
    DrawLine(X1, Y, X2, Y);
end; { DS }

procedure DSC(X1, X2, Y : integer);
begin
  if Clip(X1, Y, X2, Y) then
    DS(X1, X2, Y);
end; { DSC }

procedure DrawSqr(X1, Y1, X2, Y2 : integer; Fill : boolean);
var
  I : integer;
begin
  if not Fill then
    begin
      DS(X1, X2, Y1);
      DrawLine(X2, Y1, X2, Y2);
      DS(X1, X2, Y2);
      DrawLine(X1, Y2, X1, Y1);
    end
  else
    for I := Y1 to Y2 do
      DS(X1, X2, I);
end; { DrawSqr }

begin { DrawSquare }
  if DirectModeGlb then
    DrawSqr(trunc(X1), trunc(Y1), trunc(X2), trunc(Y2), Fill)
  else
    begin
      DirectModeLoc := DirectModeGlb;
      DirectModeGlb := true;
      X1Loc := WindowX(X1);
      Y1Loc := WindowY(Y1);
      X2Loc := WindowX(X2);
      Y2Loc := WindowY(Y2);
      if not Fill then
        begin
          DSC(X1Loc, X2Loc, Y1Loc);
          DrawLineClipped(X2Loc, Y1Loc, X2Loc, Y2Loc);
          DSC(X1Loc, X2Loc, Y2Loc);
          DrawLineClipped(X1Loc, Y2Loc, X1Loc, Y1Loc);
        end
      else
        for I := Y1Loc to Y2Loc do
          DSC(X1Loc, X2Loc, I);
      DirectModeGlb := DirectModeLoc;
    end;
end; { DrawSquare }

procedure DrawAscii{(var X, Y : integer; Size, Ch : byte)};
var
  X1Ref, X2Ref, Xpos, Ypos, Xstart, Ystart, Xend, Yend, Xx, Yy : integer;
  CharByte : byte;
begin
    IF PLOTTERGLB THEN BEGIN (* PER IL PLOTTER *)
       FILLCHAR(STROUT,30,' ');
       FILLCHAR(AI1,3,' ');
       FILLCHAR(AI2,3,' ');
       FILLCHAR(AI3,3,' ');
       FILLCHAR(AI4,3,' ');
       STR((TRUNC(X)):4,AI1);
       STR((TRUNC(Y+4)):4,AI2);
       STROUT:='PA'+AI1+','+AI2+';CS1;LB'+CHR(CH)+chr(3);
       WRITELN(COM1,STROUT);
    END;
  X1Ref := X1RefGlb shl 3;
  X2Ref := X2RefGlb shl 3 + 7;
  for Ypos := 0 to 5 do
  begin
    CharByte := (CharSet[Ch, (7 - Ypos) shr 1] shr ((Ypos and 1) shl 2)) and $0F;
    for Xpos := 0 to 3 do
      if (CharByte shr (3 - Xpos)) and 1 <> 0 then
      begin
        Xstart := X + Xpos * Size;
        Xend := Xstart + Size - 1;
        Ystart := Y + 1 + (Ypos - 2) * Size;
        Yend := Ystart + Size - 1;
        if ClippingGlb then
        begin
          if Xstart < X1Ref then
            Xstart := X1Ref;
          if Xend > X2Ref then
            Xend := X2Ref;
          if Ystart < Y1RefGlb then
            Ystart := Y1RefGlb;
          if Yend > Y2RefGlb then
            Yend := Y2RefGlb;
        end;
        for Yy := Ystart to Yend do
          for Xx := Xstart to Xend do
           (* putpixel(Xx, Yy, colorglb);*)
            putpixel(Xx, Yy, colorglb{+3});
      end;
  end;
  X := X + Size * 6;
end; { DrawAscii }

procedure DrawText{(X, Y, Scale : integer; Txt : WrkString)};
var
  LineStyleLoc, Code, AsciiValue, StringLen,
  I, SymbolScale, SymbolCode : integer;
  DirectModeLoc : boolean;
begin
  DirectModeLoc := DirectModeGlb;
  DirectModeGlb := true;
  LineStyleLoc := LinestyleGlb;
  setglinestyle(0);
  StringLen := Length(Txt);
  I := 1;
  while I <= StringLen do
  begin
    AsciiValue := Ord(Txt[I]);
    if AsciiValue = 27 then
      begin
        SymbolScale := Scale;
        I := I + 1;
        if I <= StringLen then
        begin
          Val(Txt[I], SymbolCode, Code);
          if (I + 2 <= StringLen) and (Ord(Txt[I + 1]) = 64) then
          begin
            Val(Txt[I + 2], SymbolScale, Code);
            I := I + 2;
          end;
          case SymbolCode of
            1   : DrawCross(X + SymbolScale, Y + Scale, SymbolScale);
            2   : DrawCrossDiag(X + SymbolScale, Y + Scale, SymbolScale);
            3,4 : DrawSquareC(X, Y + (SymbolScale shl 1) - 1,
                              X + (SymbolScale shl 1), Y - 1, (SymbolCode = 4));
            5   : begin
                    DrawDiamond(X + trunc(1.5 * SymbolScale),
                                Y + SymbolScale - 1, SymbolScale + 1);
                    X := X + SymbolScale;
                  end;
            6   : DrawWye(X + SymbolScale, Y + SymbolScale - 1, SymbolScale);
            7   : begin
                    DrawStar(X + SymbolScale shl 1, Y + SymbolScale - 1, SymbolScale);
                    X := X + SymbolScale shl 1;
                  end;
            8   : DrawCircleDirect(X + SymbolScale, Y + (SymbolScale shr 1),
                                   SymbolScale + 1, true);
          end;
          X := X + 3 * SymbolScale;
          SymbolScale := Scale;
        end;
      end
    else
      DrawAscii(X, Y, Scale, AsciiValue);
    I := I + 1;
  end;
  DirectModeGlb := DirectModeLoc;
  setglinestyle(LineStyleLoc);
end; { DrawText }

procedure DrawTextW{(X, Y : Float; Scale : integer; Txt : WrkString)};
begin
  if DirectModeGlb then
    DrawText(trunc(X), trunc(Y), Scale, Txt)
  else
    DrawText(WindowX(X), WindowY(Y), Scale, Txt);
end; { DrawTextW }

procedure DrawBorder;
var
  ClipLoc, DirectModeLoc : boolean;
  Xl1, Xl2 : integer;
  colorglb1 : byte;

procedure DrawHeaderBackground(Y1, Y2 : integer);
var
  I : integer;
  
begin
  for I := Y1 to Y2 do
    DrawStraight(Xl1, Xl2, I);
end; { DrawHeaderBackground }



procedure DrawHeader;
var
  Y1Hdr, Y2Hdr, Yl1, Yl2 : integer;
begin
  with GrafWindow[WindowNdxGlb] do
  begin
    if Drawn then
      if Top then
        begin
          ReDefineWindow(WindowNdxGlb, X1RefGlb, Y1RefGlb - HeaderSizeGlb,
                         X2RefGlb, Y2RefGlb);
          SelectWindow(WindowNdxGlb);
        end
      else
        begin
          ReDefineWindow(WindowNdxGlb, X1RefGlb, Y1RefGlb, X2RefGlb,
                         Y2RefGlb + HeaderSizeGlb);
          SelectWindow(WindowNdxGlb);
        end;
    if TopGlb then
      begin
        Yl1 := Y1RefGlb + HeaderSizeGlb;
        Yl2 := Y2RefGlb;
        Y1Hdr := Y1RefGlb;
        Y2Hdr := Y1RefGlb + HeaderSizeGlb - 1;
      end
    else
      begin
        Yl1 := Y1RefGlb;
        Yl2 := Y2RefGlb - HeaderSizeGlb;
        Y1Hdr := Y2RefGlb - HeaderSizeGlb + 1;
        Y2Hdr := Y2RefGlb;
      end;
    Top := TopGlb;
    ReDefineWindow(WindowNdxGlb, X1RefGlb, Yl1, X2RefGlb, Yl2);
    SelectWindow(WindowNdxGlb);

(*    DrawHeaderBackground(Y1Hdr, Y2Hdr); *)
    Setcolor(ColorGlb);
    DrawSquare(Xl1, Y1Hdr, Xl2, Y2Hdr, true);
    ColorGlb :=15-ColorGlb;
    Setcolor(ColorGlb);
    DrawText(Xl1 + 2 + (Xl2 - Xl1 - Length(Header) * 6) shr 1,
             Y1Hdr + 3, 1, Header);
    DrawSquare(Xl1, Y1Hdr, Xl2, Y2Hdr, false);
    ColorGlb := 15 - ColorGlb;
    SetColor(ColorGlb);
    DrawSquare(Xl1, Y1RefGlb, Xl2, Y2RefGlb, false);
    Drawn := true;
  end;
end; { DrawHeader }

(*    ColorGlb1:=getcolor;
    setcolor(15-getbkcolor);
    colorGlb:=15-getbkcolor;
    DrawSquare(Xl1, Y1Hdr, Xl2, Y2Hdr, false);
    DrawSquare(Xl1, Y1RefGlb, Xl2, Y2RefGlb, false);
    setcolor(getbkcolor);
    colorGlb:=getbkcolor;
    DrawSquare(Xl1, Y1Hdr, Xl2, Y2Hdr, true);
    setcolor(15-ColorGlb1);
    Colorglb:=15-ColorGlb1;
    DrawText(Xl1 + 2 + (Xl2 - Xl1 - Length(Header) * 6) shr 1,
             Y1Hdr + 3, 1, Header);
    Drawn := true;
  end;
end; { DrawHeader }
*)
begin { DrawBorder }
  DirectModeLoc := DirectModeGlb;
  DirectModeGlb := true;
  ClipLoc := ClippingGlb;
  ClippingGlb := false;
  Xl1 := X1RefGlb shl 3;
  Xl2 := X2RefGlb shl 3 + 7;
  with GrafWindow[WindowNdxGlb] do
    if ((HeaderGlb) and (Length(Header) > 0)) and (Y2 - Y1 > HeaderSizeGlb) and
       ((Length(Header) * 6) < abs(Xl2 - Xl1) - 4) then
      DrawHeader
    else
      begin
        Drawn := false;
        DrawSquare(Xl1, Y1RefGlb, Xl2, Y2RefGlb, false);
      end;
    DirectModeGlb := DirectModeLoc;
    ClippingGlb := ClipLoc;
end; { DrawBorder }

{ Modulo da sostituire alle librerie GKERNEL.PAS se si vuole       }
{ adottare la stampa ruotata per IBM pro-printer oltre alla media  }
{ risoluzione sempre per pro-printer.                              }
{ Il discorso rimane inalterato per EPSON a cui si aggiunge in     }
{ ogni caso il modo 8 per stampe ruotate                           }


procedure HardCopy(Inverse: boolean; Mode : byte);
{ Graphics screen dump routine for EPSON compatible    }
{ printers. Pre-FX series of EPSON printers should     }
{ only use Mode 1.				       }
{						       }
{ Mode: 1	= Double-Density 120 dots per inch     per EPSON }
{	2	= High-Speed D-D 120 dots per inch     per EPSON }
{	3	= Quadruple-Density 240 dots per inch  per EPSON }
{	0, 4, 5 = 80 dots per inch		       per EPSON }
{	6	= 90 dots per inch		       per EPSON }
{       7       = rotated and expanded          per IBM ed EPSON }
{                 in quest'ultimo caso assicurarsi che il LF sia }
{                 abilitato per salto riga sugli Switch hardware }
const
  Esc	= 27;
var
  ScanLine : integer; { The current scan line }
  ScanCol,Scan : integer;
  n1, n2   : byte;    { 2 byte printer control code }
  pb : byte;

procedure SendByte(B : byte);
{ Send one byte to the printer }
const
  LPTPortNum = 1; { Defaults to LPT1. 2 = LPT2 }
var
  Regs : Registers;
begin
  Regs.AH := 0;
  Regs.AL := B;
  Regs.DX := Pred(LPTPortNum);
  Intr($17, Regs);
end; { SendByte }

{$B+}  { Turn off short circuit boolean evaluation }

function ConstructByte(X, Y : integer) : byte;
{ Construct a print byte by reading bits from the graphics screen buffer }
const
  Bits : array[0..7] of byte = (128,64,32,16,8,4,2,1);
var
  CByte, Bit : byte;
begin
  Y := Y shl 3;  { Y := Y * 8 }
  CByte := 0;
  for Bit := 0 to 7 do
  if ((Mem[GrafBase:BaseAddress(Y+Bit) + X shr 3] and Bits[X and 7]) <> 0) then
    CByte := CByte + Bits[Bit];
  ConstructByte := CByte;
end; { ConstructByte }

{$B-}  { Turn on short circuit boolean evaluation }

procedure DoLine;
{ Dumps one print line to the printer }
var
  XPixel    : integer;
  PrintByte : byte;
begin
  if Mode = 1 then
    begin
      SendByte(Esc);	    { Select double-density graphics print mode }
      SendByte(Ord('L'));
    end
  else
    begin		    { Select 8-Pin graphics print mode }
      SendByte(Esc);
      SendByte(Ord('*'));
      SendByte(Mode);
    end;
  SendByte(n1); 	    { Send 2 byte control code }
  SendByte(n2);
  for XPixel := 0 to XScreenMaxGlb do
  begin
    PrintByte := ConstructByte(XPixel, ScanLine);
    if Inverse then
      PrintByte := not PrintByte;
    SendByte(PrintByte);    { Send print byte }
  end;
  SendByte(10); 	    { Send line feed }
end; { DoLine }

procedure DoCol;
var
  YPixel,XPixel : integer;
  pb : byte;
begin
  SendByte(Esc);	    { Select single-density graphics print mode }
  SendByte(Ord('K'));
  SendByte(n1); 	    { Send 2 byte control code }
  SendByte(n2);
  for YPixel := YMaxGlb downto 0 do
    begin
    pb := Mem[GrafBase:BaseAddress(YPixel) + ScanLine];
    if Inverse then
      pb := not pb;
    SendByte(pb);    { Send print byte }
    end;
  SendByte(10); 	    { Send line feed }
end; { DoCol }

begin { HardCopy }
  Mode := Mode mod 8;		   { Modes 0 through 7 supported }
  if (Mode = 0) or (Mode = 5) then
    Mode := 4;			   { Modes 0 and 5 use Mode 4 }

  SendByte(Esc);		   { Select 24/216-inch line spacing }
  SendByte(Ord('3'));
  SendByte(24);

  if (mode = 7) then
    begin
    n1 := Lo(Succ(YMaxGlb));   { Determine 2 byte control code for }
    n2 := Hi(Succ(YMaxGlb));   { the number of dots per print line }
    for ScanLine := 0 to (XScreenMaxGlb div 8) do
      DoCol;
    end
  else
    begin
    n1 := Lo(Succ(XScreenMaxGlb));   { Determine 2 byte control code for }
    n2 := Hi(Succ(XScreenMaxGlb));   { the number of dots per print line }
    for ScanLine := 0 to (YMaxGlb div 8) do
      DoLine;			     { Do a print line }
    end;

  SendByte(Esc); SendByte(2);	   { Select 1/6-inch line spacing }
end; { HardCopy }

begin
  GrafModeGlb := false;
end. { GKernel }
