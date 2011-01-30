{$g+}
unit keyboard;
interface

VAR   key             : array[1..127] of boolean; { to store the key-presses }
      AnyPressed      : Boolean;
      KeyDelay        : Word;

Const KeyName : array[1..83] of string[10] = (
           'Esc','1','2','3','4','','6','7','8','9','0','_','=','BckSpace',
           'Tab','Q','W','E','R','T','Y','U','I','O','P','[',']','Return',
           'Ctrl','A','S','D','F','','H','J','K','L',';','"','`','Left Shift',
           '\','Z','X','C','V','B','N','M',',','.','/','Right Shift','*',
           'AlT','Space','Caps Lock','F1','F2','F3','F4','F5','F6','F7','F8',
           'F9','F10','Num Lock','Scroll Lock','Home','Up','Pg Up','-','Left',
           '5','Right','+','End','Down','Pg Down','Ins','Del');

       EscKey = 1;      { these are just some constants... }
       Down   = 80;     { the most important keys in games }
       Up     = 72;     { are the arrow keys, and the }
       Left   = 75;     { control+alt keys... }
       Right  = 77;
       CTRL   = 29;
       ALT    = 56;
       RETURN = 28;

PROCEDURE InitInt09;
PROCEDURE RestoreInt09 ;
Function KeyRetrace:Boolean;

implementation
uses dos;

VAR OldInt09        : pointer;        { old keyboard interupt             }

Const KeyWait:Integer=0;

PROCEDURE RestoreInt09 ;
BEGIN
  SetIntVec( $09, OldInt09 ) ;
END;

{$f+}
PROCEDURE NewInt09; INTERRUPT;
Begin
ASM
  STI

  xor ch,ch             { set CH to 0, we're using bytes here! }

  mov dx,$60            { set DX to port $60 (keyboard port) }
  in al,dx              { get byte from keyboard }
  mov cl,al             { put it in CL for usage }
  and cl,$7f            { and CL with 127 (MOD 128) }

  mov bx,offset key     { get offset of the KEY array of booleans }
  dec bx
  add bx,cx             { add keyfound to BX }
  mov si,bx             { put calculated offset in DS:[SI] }

  shr al,7              { divide AL with 128 }
  xor al,1
  mov [si],al           { put TRUE or FALSE in array position of keyfound }
  mov anypressed,al     { set ANYPRESSED to TRUE or FALSE }
  mov dx,$61
  in al,dx              { get byte from the port }
  mov cl,al
  or al,$80
  out dx,al
  mov al,cl
  out dx,al
  cli

  mov ax,$20
  mov dx,$20
  out dx,ax
END;
End;
{$f-}

PROCEDURE InitInt09;
VAR n : byte;
BEGIN
  AnyPressed:=False;
  ExitProc := addr( RestoreInt09 ) ;
  GetIntVec( $09, OldInt09 ) ;
  SetIntVec( $09, addr( NewInt09 ) ) ;
  For N := 1 to 127 do Key[ N ] := False ;
END;

Function KeyRetrace:Boolean;
begin
 KeyRetrace:=False;
 if keywait>0 then begin dec(keydelay);exit; End;
 keywait:=KeyDelay;
 KeyRetrace:=True;
end;

begin
 KeyDelay:=1;FillChar(key,sizeof(key),0);
END.

uses keyboard;
var i: integer;
begin
 InitInt09;
 repeat
 until anypressed;
 for i:=1 to 127 do if key[i]=true then writeln(i);
 Restoreint09;
end.