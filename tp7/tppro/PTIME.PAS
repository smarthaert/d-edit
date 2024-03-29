{$IFDEF Windows}
  !! ERROR - This program is not compatible with Windows !!
{$ENDIF}

{$IFDEF Dpmi}
  !! ERROR - This program is not compatible with Protected mode !!
{$ENDIF}

{$S-,R-,V-,I-,B-,F-}
{$M 4096,0,200}

{*********************************************************}
{*                   PTIME.PAS 5.21                      *}
{*         Programmer's Time Management Utility          *}
{*       An example program for Turbo Professional       *}
{*     Copyright (c) TurboPower Software 1987, 1992.     *}
{* Portions Copyright (c) Sunny Hill Software 1985, 1986 *}
{*     and used under license to TurboPower Software     *}
{*                 All rights reserved.                  *}
{*********************************************************}

program PTime;
  {-Programmer's Time management utility}

uses
  Dos,                       {standard DOS/BIOS routines}
  TpString,                  {Turbo Professional string handling routines}
  TpCrt,                     {Turbo Professional CRT unit}
  TpDate,                    {Turbo Professional date/time routines}
  TpEdit,                    {Turbo Professional line editor}
  TpInt,                     {Turbo Professional ISR management}
  TpTsr;                     {Turbo Professional TSR management}

type
  SignatureType = string[7];
const
  {** keep the following together to allow easy patching **}
  ModuleName : string[5] = 'PTIME'; {module name for standard interface}

  OurHotKey : Word = $0514;  {Ctrl + RightShift, 'T'}
  ClockHandle : Byte = 15;   {ISR Handle for clock interrupt}

  {signature used in data files}
  Signature : SignatureType = 'PTime50';
  {******************* end of patch area ******************}

type
  String8 = string[8];
  String32 = string[32];
  String80 = string[80];
  VideoWord =
    record
      Ch : Char; Attr : Byte;
    end;
  ScreenBuffer = array[1..6, 1..80] of VideoWord; {6 rows * 80 columns}
  TimeRec =
    record
      Hours, Minutes, Seconds : Byte;
    end;
  BillingRec =
    record
      Starting : DateTimeRec;
      Stopping : DateTimeRec;
      Elapsed : Time;
      AllowUpdate : Boolean;
      Comment : string[76];
    end;

const
  ProgName : string[48] = 'PTIME: Programmer''s Time Management Utility 5.21';
  Copyright : string[41] = 'Copyright (c) 1992 by TurboPower Software';
  CommandLabels : string[96] =
  '[ESC] exit  Alarm  Clock  Disable  Load  Macro  Pause  Timer  Update';
  LoadError : string[23] = 'Unable to install PTIME';
  ClockErrorMsg : string[23] = 'Unable to install clock';
  NullTime : string[5] = '00:00';
  Esc = #27;

  {** Screen coordinates **}
  LeftCol = 1;               {leftmost col on screen}
  RtCol = 80;                {rightmost col on screen}
  TopRow = 1;                {top row of window border}
  BotRow = 6;                {bottom row of window border}

  TimerRow = 2;              {row for timer stuff}
  TogglesRow = 3;            {row for option toggles}
  PromptRow = 4;             {row, col where prompts are displayed}
  PromptCol = 3;
  LabelRow = 5;              {row for command labels}

var
  {** screen stuff **}
  OurScreenPtr : Pointer;
  OurScreenBuffer : ScreenBuffer; {for saving the screen}
  Span : String80;
  SpLen : Byte absolute Span; {its length}
  Reverse,                   {reverse video attribute}
  Bright,                    {bright video attribute}
  Dim : Byte;                {dim video attribute}
  FxAttrs : FlexAttrs;       {attributes for FlexWrite}
  Escaped : Boolean;

  {** date/time stuff **}
  TimingOn,
  PauseOn : Boolean;
  StartedAt,
  ThisPause,
  PauseTotal : LongInt;
  PausedAt, StartTime, StopTime : DateTimeRec;
  ThisBill : BillingRec;
  BillingFile : file of BillingRec;
  BillingName : string[32];
  PCount : Word;

  {on-screen clock stuff}
const
  ClockRow = 1;
  ClockCol = 70;
var
  ClockPopHandle : Byte;
  ClockStack : array[1..2048] of Byte;
  ClockOn,
  SaveClockOn : Boolean;
  ClockTime : Time;
  ClockAttr : Byte;

  {alarm stuff}
const
  AlarmSet : Boolean = False;
  BeepCount : Byte = 0;
  AlarmBeepCount = 3;
  BeepFrequency : Word = 650;
  BeepDuration : Word = 250;
  BeepInterval : Word = 55;
var
  AlarmTime : Time;

  {macro stuff}
const
  MacroScheduled : Boolean = False;
  SmacsName : string[10] = 'SUPER MACS';
  ExecMacroByKey = 1;        {for SMACS function calls}
  GetMacroState = 3;
  SetMacroState = 4;
var
  MacroTime : Time;
  MacroKey : Word;

  procedure Beep;
    {-Ring the alarm}
  begin
    Sound(BeepFrequency);
    Delay(BeepDuration);
    NoSound;
    Delay(BeepInterval);
  end;

  procedure SetAttributes;
    {-Set video attribute variables based on the current video mode}
  var
    MonoColors : Boolean;
  begin
    {set video attributes}
    {set video attributes}
    case CurrentMode of
      2, 7 :
        MonoColors := WhichHerc <> HercInColor;
      else
        MonoColors := False;
    end;

    if MonoColors then begin
      Bright := $F;          {white on black}
      Dim := $7;             {light gray on black}
      Reverse := $70;        {black on light gray}
      ClockAttr := $7;       {light gray on black}
    end
    else begin
      Bright := $2F;         {white on light green}
      Dim := $20;            {black on light green}
      Reverse := $71;        {blue on light gray}
      ClockAttr := $7;       {light gray on black}
    end;

    {set attributes for FlexWrite}
    FxAttrs[0] := Dim;
    FxAttrs[1] := Bright;
  end;

  function Decimal(I, Width : Word; DoZero : Boolean) : String8;
    {-Return a string representing a decimal number}
  var
    S : String8;
    SLen : Byte absolute S;
  begin
    Str(I:Width, S);
    if DoZero then
      for I := 1 to SLen do
        if S[I] = ' ' then
          S[I] := '0';
    Decimal := S;
  end;

  procedure DrawScreen;
    {-Draw initial screen}
  begin
    {draw main box, title, and command labels}
    FrameWindow(LeftCol, TopRow, RtCol, BotRow, Dim, Reverse, ' '+ProgName+' ');

    {draw field labels}
    {         1         2         3         4         5         6         7         8}
    {12345678901234567890123456789012345678901234567890123456789012345678901234567890}
    {  Alarm: 00:00   Macro: 00:00   Start: 00:00   Elapsed: 00:00   Time: 00:00:00  }
    FastWrite('Alarm:         Macro:         Start:         Elapsed:         Time:',
      TimerRow, PromptCol, Dim);
    FastWrite(Pad('File: '+BillingName, 38), TogglesRow, PromptCol, Dim);
    FastWrite('Timer:      Pause:      Clock:', TogglesRow, 45, Dim);

    {draw command labels}
    FlexWrite(CommandLabels, LabelRow, PromptCol, FxAttrs);
  end;

  procedure ClearPromptLine;
    {-Clear the prompt line}
  begin
    SpLen := 78;
    FillChar(Span[1], 78, ' ');
    FastWrite(Span, PromptRow, Pred(PromptCol), Dim);
  end;

  procedure Prompt(Msg : String80);
    {-Display a prompt}
  begin
    HiddenCursor;
    ClearPromptLine;
    FastWrite(Msg, PromptRow, PromptCol, Bright);
  end;

  procedure GetCurrentTime(var TR : TimeRec);
  {-Mystic assembly language routine to calculate current time fast.
    Based on routine by Bob Tolz.}
  begin
    inline(
      $B8/$40/$00/           {mov  ax,$40      ;read time from BIOS data area}
      $8E/$C0/               {mov  es,ax       ;INT $1A clears midnight flag!}
      $26/$8B/$0E/>$6E/      {mov  cx,es:[$6E]}
      $26/$8B/$16/>$6C/      {mov  dx,es:[$6C]}
      $89/$C8/               {mov ax,cx        ;magically calculate the time}
      $89/$D3/               {mov bx,dx}
      $D1/$E2/               {shl dx,1}
      $D1/$D1/               {rcl cx,1}
      $D1/$E2/               {shl dx,1}
      $D1/$D1/               {rcl cx,1}
      $01/$DA/               {add dx,bx}
      $11/$C8/               {adc ax,cx}
      $92/                   {xchg dx,ax}
      $B9/$0B/$E9/           {mov cx,$E90B}
      $F7/$F1/               {div cx}
      $89/$C3/               {mov bx,ax}
      $31/$C0/               {xor ax,ax}
      $F7/$F1/               {div cx}
      $89/$DA/               {mov dx,bx}
      $B9/$C8/$00/           {mov cx,200}
      $F7/$F1/               {div cx}
      $80/$FA/$64/           {cmp dl,100}
      $72/$03/               {jb Under}
      $80/$EA/$64/           {sub dl,100}
      {Under:}
      $F5/                   {cmc}
      $88/$D3/               {mov bl,dl}
      $D1/$D0/               {rcl ax,1}
      $B2/$00/               {mov dl,0}
      $D1/$D2/               {rcl dx,1}
      $B9/$3C/$00/           {mov cx,60}
      $F7/$F1/               {div cx}
      $88/$D7/               {mov bh,dl}
      $F6/$F1/               {div cl}
      $86/$E0/               {xchg al,ah}
      $C4/$7E/<TR/           {les di,[bp+<TR]  ;ES:DI => time rec}
      $26/$88/$25/           {mov es:[di],ah   ;AH has hours}
      $26/$88/$45/$01/       {mov es:[di+1],al ;AL has minutes}
      $26/$88/$7D/$02);      {mov es:[di+2],bh ;BH has seconds (hundredths in BL)}
  end;

  procedure SetBiosClock;
    {-Set BIOS clock to match DOS's.}
  const
    TicsPerHr = 65543.3333;
    TicsPerMin = 1092.3889;
    TicsPerSec = 18.2065;
    TicsPerHun = 0.182065;
  var
    BiosClock : LongInt absolute $40 : $6C;
    Regs : Registers;
  begin
    with Regs do begin
      AH := $2C;
      MsDos(Regs);
      BiosClock :=
      Trunc((Ch*TicsPerHr)+(CL*TicsPerMin)+(DH*TicsPerSec)+(DL*TicsPerHun));
    end;
  end;

  procedure GetElapsedTime(Start, Stop : DateTimeRec; var Elapsed : Time);
    {-Calculate elapsed time based on Start and Stop, returning it in Elapsed.}
  var
    Days : Word;
  begin
    {calculate time difference}
    DateTimeDiff(Start, Stop, Days, Elapsed);
    Dec(Elapsed, PauseTotal);

    {account for current Pause, if appropriate}
    if PauseOn then begin
      DateTimeDiff(PausedAt, Stop, Days, ThisPause);
      Dec(Elapsed, ThisPause);
    end;
  end;

  procedure UpdateTimes;
    {-Update start, current and total time fields}
  const
    OnOff : array[Boolean] of string[3] = ('OFF', 'ON ');
    TimeFormat = 'hh:mm';
  var
    ETime : Time;
    Attr : Byte;
    StopTimeRec : TimeRec;
  begin
    {indicate whether timing is on}
    if TimingOn then
      Attr := Bright
    else
      Attr := Dim;
    FastWrite(OnOff[TimingOn], TogglesRow, 52, Attr);

    {indicate whether pause is on}
    if PauseOn then
      Attr := Bright
    else
      Attr := Dim;
    FastWrite(OnOff[PauseOn], TogglesRow, 64, Attr);

    {indicate whether clock is on}
    if SaveClockOn then
      Attr := Bright
    else
      Attr := Dim;
    FastWrite(OnOff[SaveClockOn], TogglesRow, 76, Attr);

    {show the alarm setting}
    if AlarmSet then
      FastWrite(TimeToAmPmString(TimeFormat, AlarmTime), TimerRow, 10, Dim)
    else
      FastWrite(NullTime, TimerRow, 10, Dim);

    {show the macro setting}
    if MacroScheduled then
      FastWrite(TimeToAmPmString(TimeFormat, MacroTime), TimerRow, 25, Dim)
    else
      FastWrite(NullTime, TimerRow, 25, Dim);

    {show the starting time}
    if StartTime.T = BadTime then
      FastWrite(NullTime, TimerRow, 40, Dim)
    else
      FastWrite(TimeToAmPmString(TimeFormat, StartTime.T), TimerRow, 40, Dim);

    {get the current time}
    GetCurrentTime(StopTimeRec);
    with StopTimeRec do
      StopTime.T := HMStoTime(Hours, Minutes, Seconds);

    {show the elapsed time so far}
    if TimingOn then begin
      GetElapsedTime(StartTime, StopTime, ETime);
      FastWrite(TimeToTimeString(TimeFormat, ETime), TimerRow, 57, Dim);
    end
    else
      FastWrite('00:00', TimerRow, 57, Dim);

    {show the current time}
    FastWrite(TimeToAmPmString('hh:mm:ss', StopTime.T), TimerRow, 71, Dim);
  end;

  {$F+}
  function GetKey : Word;
    {-Update the screen while waiting for a keystroke}
  begin
    while not KeyPressed do begin
      {make sure other TSRs can pop up}
      inline($CD/$28);
      UpdateTimes;
    end;
    GetKey := ReadKeyWord;
  end;
  {$F-}

  procedure PressAnyKey(Msg : String80);
    {-Display a message and wait for a keystroke}
  var
    I : Word;
  begin
    Prompt(Msg+'. Press any key...');
    I := GetKey;
  end;

  function GetTargetTime(var T : Time) : Boolean;
    {-Prompt for a time string; return True if a time setting was stored in TR.}
  const
    St : string[5] = '';
  var
    StTemp : string[5];
    StLen : Byte absolute StTemp;
    PC, H, M, Code, SaveLen : Word;

    procedure Invalid;
    begin
      PressAnyKey('Invalid format: "'+St+'"');
    end;

  begin
    {assume failure}
    GetTargetTime := False;

    {get a time string}
    ReadString('Enter the time in "HH:MM" format (HH = 0-23, MM = 0-59): ',
      PromptRow, PromptCol, 5, Bright, Dim, Dim, Escaped, St);
    StTemp := St;
    ClearPromptLine;

    {exit if string is empty}
    if (StLen = 0) or Escaped then
      Exit;

    {check position of colon}
    PC := Pos(':', StTemp);
    case PC of
      2..4 : {OK} ;
    else
      begin
        Invalid;
        Exit;
      end;
    end;
    SaveLen := StLen;

    {get the hour out of the string}
    H := $0FFFF;
    StLen := Pred(PC);
    Val(StTemp, H, Code);

    {check its validity}
    case H of
      0..23 : {OK} ;
    else Code := 1;
    end;
    if Code <> 0 then begin
      Invalid;
      Exit;
    end;

    {restore end of St}
    StLen := SaveLen;

    {get rid of hour and colon}
    Delete(StTemp, 1, PC);

    {get the minutes out of the string}
    M := $0FFFF;
    Val(StTemp, M, Code);

    {check its validity}
    case M of
      0..59 : {OK} ;
    else Code := 1;
    end;
    if Code = 0 then begin
      GetTargetTime := True;
      T := HMStoTime(H, M, 0);
    end
    else
      Invalid;
  end;

  procedure SetAlarm;
    {-Set or cancel an alarm}
  begin                      {SetAlarm}
    if AlarmSet then
      AlarmSet :=
      not YesOrNo('Alarm is already set. Cancel the alarm?',
        PromptRow, PromptCol, Bright, 'N')
    else
      AlarmSet := GetTargetTime(AlarmTime);
  end;

  procedure WriteToLastRecord(var TB : BillingRec; RecExists : Boolean);
    {-Update the last record in the billing file and close it}
  var
    SeekTo : LongInt;
    IoStatus : Word;
  begin
    SeekTo := FileSize(BillingFile)-Ord(RecExists);
    Seek(BillingFile, SeekTo);
    IoStatus := Int24Result;
    if IoStatus = 0 then begin
      Write(BillingFile, TB);
      IoStatus := Int24Result;
    end;
    Close(BillingFile);
    if (Int24Result <> 0) or (IoStatus <> 0) then
      PressAnyKey('WARNING: Error writing to '+BillingName);
  end;

  procedure SelectFile;
    {-Select a billing file}
  const
    BName : String32 = '';
  var
    BLen : Byte absolute BName;
    BRec : BillingRec;
    BSig : SignatureType absolute BRec;
  begin
    if TimingOn then
      {error message}
      PressAnyKey('Can''t change files while timing is on')
    else begin
      {use filename passed at the command line?}
      if PCount > 0 then begin
        BName := ParamStr(1);
        PCount := 0;         {don't use it again}
        Escaped := False;
      end
      else begin
        {get a filename}
        ReadString('Name of the data file: ', PromptRow, PromptCol, 32,
          Bright, Dim, Dim, Escaped, BName);
        ClearPromptLine;
      end;

      {exit if none is entered}
      if (BLen = 0) or Escaped then
        Exit;

      {convert name to upper case and clean up}
      BName := StUpCase(BName);
      BName := CleanPathName(BName);

      {try to open the file}
      Assign(BillingFile, BName);
      Reset(BillingFile);
      if Int24Result <> 0 then begin
        Rewrite(BillingFile);

        {exit if there's an error}
        if Int24Result <> 0 then begin
          PressAnyKey('Unable to open '+BName);
          Exit;
        end;
      end;
      BName := FullPathName(BName);

      {if the file is empty, put in a signature}
      if FileSize(BillingFile) = 0 then begin
        FillChar(BRec, SizeOf(BRec), 0);
        BSig := Signature;
        Write(BillingFile, BRec);
        if Int24Result <> 0 then
          PressAnyKey('Error writing to '+BName);
      end
      else begin
        {check for a signature}
        Read(BillingFile, BRec);
        if BSig <> Signature then begin
          PressAnyKey(BName+' is not a valid file');
          BName[0] := #0;
        end;
      end;

      {close the file}
      Close(BillingFile);
      BillingName := BName;
      DrawScreen;
    end;
  end;

  function OpenBilling(var BName : String32) : Boolean;
    {-Open the billing file, returning a success flag}
  var
    S : String80;
  begin
    Assign(BillingFile, BName);
    Reset(BillingFile);
    if Int24Result <> 0 then begin
      PressAnyKey('Unable to open '+BName);
      BName[0] := #0;
      OpenBilling := False;
    end
    else begin
      OpenBilling := True;
      S := FullPathName(BName);
      if Length(S) <= 32 then
        BName := S;
    end;
  end;

  procedure UpdateLast;
    {-Update the last record in the currently selected file}
  var
    BRec : BillingRec;
    Recs : Word;
  begin
    {select file if necessary}
    if Length(BillingName) = 0 then
      SelectFile;
    if Length(BillingName) = 0 then
      Exit;

    {try to open the file}
    if not OpenBilling(BillingName) then
      Exit;
    Recs := FileSize(BillingFile);

    {the first record is just the signature}
    if (Recs = 1) then begin
      PressAnyKey('No records to update in '+BillingName);
      Close(BillingFile);
      Exit;
    end;

    {read the last record}
    Seek(BillingFile, Pred(Recs));
    Read(BillingFile, BRec);

    {see if it needs updating}
    if not BRec.AllowUpdate then begin
      PressAnyKey(BillingName+' does not need updating');
      Close(BillingFile);
      Exit;
    end;

    {update the record}
    BRec.Stopping := StopTime; {= current time}
    with BRec do
      GetElapsedTime(Starting, Stopping, Elapsed);

    {write it back to disk}
    WriteToLastRecord(BRec, True);

    PressAnyKey(BillingName+' updated');
  end;

  procedure StartStop;
    {-Turn timing on or off}
  begin
    {make sure the timing records are up to date}
    UpdateTimes;

    if TimingOn then begin   {turn timing off}
      {update billing file}
      if not OpenBilling(BillingName) then
        Exit;

      {timing off}
      ThisBill.Stopping := StopTime;
      with ThisBill do
        GetElapsedTime(Starting, Stopping, Elapsed);
      ThisBill.AllowUpdate := False;

      {get comment}
      ThisBill.Comment := '';
      ReadString('Comment: ', PromptRow, PromptCol, 67, Bright, Dim, Dim,
        Escaped, ThisBill.Comment);
      ClearPromptLine;

      {update and close the file}
      WriteToLastRecord(ThisBill, True);

      {zero out everything}
      StartTime.D := BadDate;
      StartTime.T := BadTime;
      FillChar(ThisBill, SizeOf(ThisBill), 0);
      PauseTotal := 0;

      {toggle the timing switch}
      TimingOn := False;
      PauseOn := False;
      PressAnyKey(BillingName+' updated');
    end
    else begin               {turn timing on}
      {select file if necessary}
      if Length(BillingName) = 0 then
        SelectFile;
      if Length(BillingName) = 0 then
        Exit;

      {open file}
      if not OpenBilling(BillingName) then
        Exit;

      {initialize record and write it}
      StartTime := StopTime;
      ThisBill.Starting := StartTime;
      ThisBill.Stopping := StopTime;
      ThisBill.AllowUpdate := True;
      ThisBill.Comment[0] := #0;
      ThisBill.Elapsed := BadTime;
      WriteToLastRecord(ThisBill, False);

      {toggle the timing switch}
      TimingOn := True;
      PauseOn := False;
      UpdateTimes;
    end;
  end;

  procedure Pause;
    {-Turn the pause toggle on or off}
  begin
    UpdateTimes;
    if PauseOn then begin
      Inc(PauseTotal, ThisPause);
      ThisPause := 0;
      PauseOn := False;
      PausedAt.T := BadTime;
      PausedAt.D := BadDate;
    end
    else if TimingOn then begin
      PauseOn := True;
      PausedAt := StopTime;
    end
    else
      PressAnyKey('Timing is not ON');
  end;

  procedure GetMacro;
    {-Get or cancel a macro}
  var
    Regs : IntRegisters;
    P : IfcPtr;
    SaveMacroState : Boolean;
  begin
    {see if macro is already scheduled}
    if MacroScheduled then
      MacroScheduled :=
      not YesOrNo('Macro is already scheduled. Cancel the macro?',
        PromptRow, PromptCol, Bright, 'N')
    else begin
      {check for presence of SMACS}
      P := ModulePtrByName(SmacsName);
      if P = nil then begin
        PressAnyKey('This service requires that SMACS be resident');
        Exit;
      end;

   {save the current macro state and turn macros off -- we don't want the
    macro played back!}
      Regs.AH := GetMacroState;
      EmulateInt(Regs, P^.CmdEntryPtr);
      SaveMacroState := Boolean(Regs.AL);

      {now we can get the key}
      Prompt('Press the key for the SMACS macro to be played back.');
      MacroKey := GetKey;

      {restore macro state}
      Regs.AH := SetMacroState;
      Regs.AL := Byte(SaveMacroState);
      EmulateInt(Regs, P^.CmdEntryPtr);

      {get the time for the macro}
      MacroScheduled := GetTargetTime(MacroTime);
    end;
  end;

  procedure PBillMenu;
    {-Display menu of command choices}
  var
    ChWord : Word;
    Ch : Char absolute ChWord;
    Redraw : Boolean;
  begin
    {reset the clock using DOS's time}
    SetBiosClock;

    {initialize screen stuff}
    HiddenCursor;
    TextAttr := Dim;

    {draw initial screen}
    Window(LeftCol, TopRow, RtCol, BotRow);
    ClrScr;
    DrawScreen;
    Redraw := True;

    {loop until Escape key pressed}
    repeat
      {get the date each time through the loop}
      StopTime.D := Today;

      {clear the prompt line if necessary}
      if Redraw then
        ClearPromptLine;

      {wait for a keystroke}
      ChWord := GetKey;
      Redraw := True;

      {process the keystroke}
      if (Ch <> #0) then
        case Upcase(Ch) of
          'A' : SetAlarm;    {Alarm}
          'C' :              {Clock on/off}
            SaveClockOn := not SaveClockOn;
          'D' :              {Disable TSR}
            if TimingOn then
              PressAnyKey('Can''t disable PTIME while timer is on')
            else
              if YesOrNo('Are you sure you want to disable PTIME?',
                PromptRow, PromptCol, Bright, 'N') then begin
                {disable the TSR and set flag to exit}
                if not DisableTSR then
                  PressAnyKey('Not safe to disable PTIME right now')
                else
                  Ch := Esc;
              end;
          'L' : SelectFile;  {Load file}
          'M' : GetMacro;    {schedule a Macro}
          'P' : Pause;       {Pause on/off}
          'T' : StartStop;   {Start/Stop timing}
          'U' : UpdateLast;  {Update}
        else Redraw := False;
        end
      else
        Redraw := False;
    until (Ch = Esc);        {Escape}
  end;

  {$F+}
  procedure PopupEntryPoint(var Regs : Registers);
    {-This is the entry point for the popup}
  var
    SaveXY, SaveSL : Word;   {for saving cursor position and shape}
  begin
    {turn off clock while in popup}
    SaveClockOn := ClockOn;
    ClockOn := False;

    {reinitialize CRT}
    ReinitCrt;

    {don't pop up if not in 80-column text mode}
    if InTextMode and (ScreenWidth = 80) then begin
      {initialize screen stuff}
      SetAttributes;
      GetCursorState(SaveXY, SaveSL);
      if SaveWindow(LeftCol, TopRow, RtCol, BotRow, False, OurScreenPtr) then
        {won't fail -- no memory being allocated} ;

      {show the menu}
      PBillMenu;

      {restore cursor and screen}
      RestoreCursorState(SaveXY, SaveSL);
      RestoreWindow(LeftCol, TopRow, RtCol, BotRow, False, OurScreenPtr);
    end
    else
      Beep;

    {turn clock back on if necessary}
    ClockOn := SaveClockOn;
  end;
  {$F-}

  {$F+}
  procedure ShowClock(var Regs : Registers);
    {-On-screen clock}
  var
    I : Word;
  begin
    if ClockOn then
      {reinitialize CRT quickly}
      case GetCrtMode of
        2, 3, 7 :
          begin
            SetAttributes;
      {current time already found in ClockInt -- convert time to string
       and display result in top right corner}
            FastWrite(TimeToTimeString('HH:mm:ss te', ClockTime), ClockRow, ClockCol,
              ClockAttr);
          end;
      end;

    {see if alarm needs to be sounded}
    if BeepCount <> 0 then begin
      AlarmSet := False;
      for I := 1 to BeepCount do
        Beep;
      BeepCount := 0;
    end;
  end;
  {$F-}

  procedure StartMacro;
    {-Start a scheduled macro}
  var
    Regs : IntRegisters;
    P : IfcPtr;
  begin
    {verify that SMACS is still resident}
    P := ModulePtrByName(SmacsName);
    if P = nil then
      Exit;

    {SMACS found, start the macro}
    with Regs do begin
      AH := ExecMacroByKey;  {function code in AH}
      BX := MacroKey;        {macro key in BX}
      EmulateInt(Regs, P^.CmdEntryPtr);
    end;
  end;

  procedure ClockInt(BP : Word); interrupt;
    {-INT $1C handler}
  const
    Counter : Byte = 32;
    NeedTicker : Boolean = False;
  var
    Regs : IntRegisters absolute BP;
    ClockTimeRec : TimeRec;
  begin
    if ClockOn or AlarmSet or MacroScheduled then begin
      {turn interrupts on}
      InterruptsOn;

      {set clock ticker if BeepCount not 0}
      NeedTicker := (BeepCount <> 0);

      {get the time quickly}
      GetCurrentTime(ClockTimeRec);
      with ClockTimeRec do
        ClockTime := HMStoTime(Hours, Minutes, Seconds);

      {display the on-screen clock?}
      if ClockOn then
        if (Counter and $8) = 0 then
          NeedTicker := True;
      Dec(Counter);

      {see if Alarm is due to go off}
      if AlarmSet and (BeepCount = 0) then
        {if time matches target time, set BeepCount and turn off alarm flag}
        if (ClockTime div 60) = (AlarmTime div 60) then begin
          BeepCount := AlarmBeepCount;
          NeedTicker := True;
        end;

      {see if a scheduled macro needs to be played back}
      if MacroScheduled then
        if (ClockTime div 60) = (MacroTime div 60) then begin
          MacroScheduled := False;
          StartMacro;
        end;

      {set the pop ticker if necessary}
      if NeedTicker then
        SetPopTicker(ClockPopHandle, 6);
    end;

    {chain to previous INT $1C handler}
    ChainInt(Regs, ISR_Array[ClockHandle].OrigAddr);
  end;

  procedure Abort(Message : string);
    {-Display message and Halt}
  begin
    WriteLn(Message);
    Halt(1);
  end;

  procedure InitPTime;
    {-Basic initialization stuff}
  begin
    SetBiosClock;
    HideCursorInReadChar := True;
    OurScreenPtr := @OurScreenBuffer;
    BillingName := '';
    PCount := ParamCount;
    TimingOn := False;
    ClockOn := False;
    PauseOn := False;
    PauseTotal := 0;
    FillChar(ThisBill, SizeOf(ThisBill), 0);
    StartTime.D := BadDate;
    StartTime.T := BadTime;
    StopTime.D := BadDate;
    StopTime.T := BadTime;
    AlarmTime := BadTime;
    MacroTime := BadTime;

    {set up alternate GetKey routine for TPEDIT}
    EditKeyPtr := @GetKey;
  end;

begin
  {signon message}
  HighVideo;
  WriteLn(ProgName, ^M^J, Copyright, ^M^J);
  LowVideo;

  {initialize}
  InitPTime;

  {check to see if SideKick is loaded}
  if SideKickLoaded then
    Abort('Can''t be loaded after SideKick!');

  {check to see if we're already installed}
  if ModuleInstalled(ModuleName) then
    Abort('PTIME is already loaded. Aborting...');

  {install the module}
  InstallModule(ModuleName, nil);

  {set up stack}
  if not DefinePopProc(ClockPopHandle, @ShowClock, @ClockStack[SizeOf(ClockStack)]) then
    Abort(ClockErrorMsg);

  {install clock ISR}
  if not InitVector($1C, ClockHandle, @ClockInt) then
    Abort(ClockErrorMsg);

  {go resident}
  if DefinePop(OurHotKey, @PopupEntryPoint, Ptr(SSeg, SPtr), True) then begin
    WriteLn('PTIME loaded, press Ctrl-RightShift-T to activate.');

    {Enable popups}
    PopupsOn;

    {$IFDEF Ver40}
    {restore INT $1B, captured by TPCRT}
    SetIntVec($1B, SaveInt1B);
    {$ENDIF}

    {terminate and stay resident}
    if not TerminateAndStayResident(ParagraphsToKeep, 0) then {} ;
  end;

  {if we get here we failed}
  Abort(LoadError);
end.
