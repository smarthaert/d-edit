{-= Miscellaneous functions and procedures for Alien Blaster =-}

Const C8253ModeControl = $43;
      C8253OperatingFreq = 1193180;
      C8253Channel : Array [0..2] of Byte = ($40, $41, $42);

{*** SPEED HANDLING *** (from SWAG)}

{8253 Timer Programming Routines}
Procedure Set8253Channel(ChannelNumber : Byte; ProgramValue  : Word);
Begin
  Port[C8253ModeControl] := 54 or (ChannelNumber SHL 6); { XX110110 }
  Port[C8253Channel[ChannelNumber]] := Lo(ProgramValue);
  Port[C8253Channel[ChannelNumber]] := Hi(ProgramValue);
End;

{Set Clock Channel 0 (INT 8, IRQ 0) To Input Speed}
Procedure SetSpeed (Speed : LongInt);
  Var ProgramValue : Word;

Begin
  ProgramValue := C8253OperatingFreq Div Speed;
  Set8253Channel(0, ProgramValue);
End;

{-[ Set Clock Channel 0 Back To 18.2 Default Value ]----------------------}
Procedure SetDefaultSpeed;
Begin
  Set8253Channel (0, 0);
End;

{Set typematic rate and delay}
Procedure TypeMatic(Rate, Delay: Byte); Assembler;
Asm
  Mov ah, 3
  Mov al, 5
  Mov bh, rate {00h = 30/sec to 1fh = 2/sec}
  Mov bl, delay {00h = 250ms to 03h = 1000ms}
  Int $16
End;

{Machine independent Delay Function}
Procedure Delay(Ms : Word); Assembler;
Asm
  Mov ax, 1000;
  Mul ms;
  Mov cx, dx;
  Mov dx, ax;
  Mov ah, $86;
  Int $15;
End;

{*** CONVERTING ***}

{Convert integer to string}
Function IntToStr(Value : Longint) : String;
  Var Temp : String;

Begin
  Str(Value, Temp);
  IntToStr:= Temp;
End;

{Convert string to real}
Function StrToReal(Str : String) : Real;
 Var ErrorCode : Integer;
     Result : Real;

Begin
  Val(Str, Result, ErrorCode);
  StrToReal:= Result;
End;

{Convert real to string}
Function RealToStr(Value : Real) : String;
  Var Temp : String;
      Char : Byte;

begin
  Str(Value : 0 : 11, Temp);
  Delete(Temp, Length(Temp) - 3, 4);
  Char:= Length(Temp);
  While Temp[Char] = '0' do
  Begin
    Delete(Temp, Length(Temp), 1);
    Dec(Char);
  End;
  If Temp[Length(Temp)] = '.' then Delete(Temp, Length(Temp), 1);
  RealToStr:= Temp;
End;

{Converts letters of a string to capital}
Function UpperStr(Str : String) : String;
  Var Run : Byte;
      Temp : String;

begin
  Temp:= '';
  for Run:= 1 to Length(Str) do Temp:= Temp + UpCase(Str[Run]);
  UpperStr:= Temp;
end;

{*** OTHER PROCEDURES AND FUNCTIONS ***}

{Open file with (return error code)}
Function OpenFile(Var F : File; Path : String) : Integer;
Begin
  Assign(F, Path);
  {$I-}
  Reset(F, 1);
  {$I+}
  OpenFile:= IOResult;
End;

{*** KEYBOARD HANDLING ***}

{Empty keyboard buffer}
Procedure FlushKbdBuffer;
Begin
  MemW[$0000 : $041C]:= MemW[$0000 : $041A];
End;

{Get key scan code (direct)}
Function GetKey : Byte;
Begin
  GetKey:= Port[$60];
  FlushKbdBuffer;
End;

{Get input (direct)}
Function ReadKbdPort : Byte;
  Var Input : Byte;

Begin
  While Port[$60] < $80 Do; {wait until all keys are released}
  Repeat
    Input:= GetKey;
  Until Input < $80; {until keypress}
  Port[$60]:= 129; {released (clearing)}
  ReadKbdPort:= Input;
End;

{Show the "name" of a key}
Function Key(ScanCode : Byte) : String;
Begin
  Case ScanCode of
    1:Key:='Esc'; 2:Key:='1'; 3:Key:='2'; 4:Key:='3'; 5:Key:='4'; 6:Key:='5'; 7:Key:='6'; 8:Key:='7'; 9:Key:='8'; 10:Key:='9';
    11:Key:='0'; 12:Key:='-'; 13:Key:='='; 14:Key:='Backspace'; 15:Key:='Tab'; 16:Key:='Q'; 17:Key:='W'; 18:Key:='E';
    19:Key:='R'; 20:Key:='T'; 21:Key:='Y'; 22:Key:='U'; 23:Key:='I'; 24:Key:='O'; 25:Key:='P'; 26:Key:='['; 27:Key:=']';
    28:Key:='Enter'; 29:Key:='Ctrl'; 30:Key:='A'; 31:Key:='S'; 32:Key:='D'; 33:Key:='F'; 34:Key:='G'; 35:Key:='H'; 36:Key:='J';
    37:Key:='K'; 38:Key:='L'; 39:Key:=';'; 40:Key:= #39; 41:Key:='`'; 42:Key:='Left Shift'; 43:Key:='\'; 44:Key:='Z';
    45:Key:='X'; 46:Key:='C'; 47:Key:='V'; 48:Key:='B'; 49:Key:='N'; 50:Key:='M'; 51:Key:=','; 52:Key:='.'; 53:Key:='/';
    54:Key:='Right Shift'; 55:Key:='*'; 56:Key:='Alt'; 57:Key:='Space'; 58:Key:='Caps Lock'; 59:Key:='F1'; 60:Key:='F2';
    61:Key:='F3'; 62:Key:='F4'; 63:Key:='F5'; 64:Key:='F6'; 65:Key:='F7'; 66:Key:='F8'; 67:Key:='F9'; 68:Key:='F10';
    69:Key:='Num Lock'; 70:Key:=''; 71:Key:='7'; 72:Key:='Up'; 73:Key:='9'; 74:Key:=''; 75:Key:='Left'; 76:Key:='5';
    77:Key:='Right'; 78:Key:='+'; 79:Key:='1'; 80:Key:='Down'; 81:Key:='3'; 82:Key:='0'; 83:Key:='Del'; 84:Key:='';
    85:Key:=''; 86:Key:=''; 87:Key:='F11'; 88:Key:='F12'; 89:Key:=''; 90:Key:=''; 91:Key:=''; 92:Key:=''; 93:Key:='';
    94:Key:=''; 95:Key:=''; 96:Key:=''; 97:Key:=''; 98:Key:=''; 99:Key:=''; 100:Key:='';
    Else Key:= '';
  End;
End;