{ * GameKayb * }
{ Обработка одновременного нажатия нескольких клавиш }
Unit GameKeyb;

{$G+} { Инструкции 286/287 }

Interface

Var Keys : Array [1..127] of Boolean; { Какие клавиши нажаты }
    AnyPressed : Boolean; { Нажаты ли какие-нибудь клавиши? }
{ Названия клавиш }
Const KeyNames : Array [1..83] of String[10] = (
  'Esc','1','2','3','4','5','6','7','8','9','0','_','=','BckSpace',
  'Tab','Q','W','E','R','T','Y','U','I','O','P','[',']','Enter',
  'Ctrl','A','S','D','F','G','H','J','K','L',';','"','`','LeftShift',
  '\','Z','X','C','V','B','N','M',',','.','/','RightShift','*',
  'Alt','Space','CapsLock','F1','F2','F3','F4','F5','F6','F7','F8',
  'F9','F10','NumLock','ScrollLock','Home','Up','PgUp','-','Left',
  '5','Right','+','End','Down','PgDn','Ins','Del');
  { these are just some constants... the most important keys in games }
  { are the arrow keys, and the control+alt keys... }
{ -= WRITEKEY.PAS =- }
{Uses GameKeyb; }
{ Begin WriteAllKeys('Test.pas'); End. }
  cEsc        = 1;
  c1          = 2;
  c2          = 3;
  c3          = 4;
  c4          = 5;
  c5          = 6;
  c6          = 7;
  c7          = 8;
  c8          = 9;
  c9          = 10;
  c0          = 11;
  c_          = 12;
  cEQ         = 13;
  cBckSpace   = 14;
  cTab        = 15;
  cQ          = 16;
  cW          = 17;
  cE          = 18;
  cR          = 19;
  cT          = 20;
  cY          = 21;
  cU          = 22;
  cI          = 23;
  cO          = 24;
  cP          = 25;
  cSq1        = 26;
  cSq2        = 27;
  cEnter      = 28;
  cCtrl       = 29;
  cA          = 30;
  cS          = 31;
  cD          = 32;
  cF          = 33;
  cG          = 34;
  cH          = 35;
  cJ          = 36;
  cK          = 37;
  cL          = 38;
  cTz         = 39;
  cKavich     = 40;
  cApost      = 41;
  cLeftShift  = 42;
  cBackSlash  = 43;
  cZ          = 44;
  cX          = 45;
  cC          = 46;
  cV          = 47;
  cB          = 48;
  cN          = 49;
  cM          = 50;
  cZapet      = 51;
  cPoint      = 52;
  cSlash      = 53;
  cRightShift = 54;
  cMul        = 55;
  cAlt        = 56;
  cSpace      = 57;
  cCapsLock   = 58;
  cF1         = 59;
  cF2         = 60;
  cF3         = 61;
  cF4         = 62;
  cF5         = 63;
  cF6         = 64;
  cF7         = 65;
  cF8         = 66;
  cF9         = 67;
  cF10        = 68;
  cNumLock    = 69;
  cScrollLock = 70;
  cHome       = 71;
  cUp         = 72;
  cPgUp       = 73;
  cMunis      = 74;
  cLeft       = 75;
  cCenter5    = 76;
  cRight      = 77;
  cPlus       = 78;
  cEnd        = 79;
  cDown       = 80;
  cPgDn       = 81;
  cIns        = 82;
  cDel        = 83;

{ - Установка нового обработчика прерывания 09h - }
Procedure InitInt09; 
{ - Восстановление старого обработчика прерывания 09h - }
Procedure RestoreInt09;
{ - Запись констант клавиш в текстовой файл - }
Procedure WriteAllKeys( FileName:String );

{    KeyDelay   : Word; ??? }
{Function KeyRetrace:Boolean; ???}

Implementation

Uses DOS,StrUtils;

{$F+} { Обработчик прерываний должен быть FAR }
Procedure NewInt09; Interrupt; Assembler;
  Asm
    Sti
    XOR CH,CH             { set CH to 0, we're using bytes here! }
    mov dx,$60            { set DX to port $60 (keyboard port) }
    in al,dx              { get byte from keyboard }
    mov cl,al             { put it in CL for usage }
    and cl,$7f            { and CL with 127 (MOD 128) }
    mov bx,Offset Keys    { get offset of the KEY array of booleans }
    dec bx
    add bx,cx             { add keyfound to BX }
    mov si,bx             { put calculated offset in DS:[SI] }
    shr al,7              { divide AL with 128 }
    xor al,1
    mov [si],al           { put TRUE or FALSE in array position of keyfound }
    mov AnyPressed,al     { set ANYPRESSED to TRUE or FALSE }
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
  End;
{$F-}

Var OldInt09 : Pointer; { Old keyboard interupt }

{ - Установка нового обработчика прерывания 09h - }
Procedure InitInt09;
  Var N:Byte;
  Begin
    ExitProc := Addr(RestoreInt09);
    GetIntVec($09,OldInt09);
    SetIntVec($09,Addr(NewInt09));
    AnyPressed := False;
    For N:=1 to 127 do Keys[N] := False;
  End;

{ - Восстановление старого обработчика прерывания 09h - }
Procedure RestoreInt09 ;
  Begin
    SetIntVec($09,OldInt09);
  End;

(*Const KeyWait:Integer=0; Зачем это надо???
                               
Function KeyRetrace:Boolean;
  Begin
    KeyRetrace:=False;
    If KeyWait > 0 then 
      Begin Dec(KeyDelay); Exit; End;
    KeyWait:=KeyDelay;
    KeyRetrace:=True;
  End; *)

{ - Запись констант клавиш в текстовой файл - }
Procedure WriteAllKeys( FileName:String );
  Var T:Text; I:Byte;
  Begin
    Assign(T,FileName);
    Rewrite(T);
    Writeln(T,'Const');
    For I:=1 to 83 do 
      Writeln(T,'  c',AddSym(KeyNames[I],' ',11),'= ',I,';');
    Close(T);
  End;

End.
(* Тест
uses keyboard;
var i: integer;
begin
 InitInt09;
 repeat
 until anypressed;
 for i:=1 to 127 do if key[i]=true then writeln(i);
 Restoreint09;
end.*)