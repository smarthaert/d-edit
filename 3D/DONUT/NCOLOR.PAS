Unit NColor;

{$Define Windowed}

{****************************************************************************}
{*******************************} Interface {********************************}
{****************************************************************************}

Const AlphaChannel:Byte=0;
{$IfDef Windowed}
      MinX:Word=0;
      MaxX:Word=319;
      MinY:Word=0;
      MaxY:Word=199;
{$EndIf}

Const Ascii_Data:Array [32..93] Of Word=(0,                                  { }
                                         08338,00045,24445,32223,21157,      {!,",#,$,%}
                                         15018,00018,                        {&,'}
                                         08778,10530,                        {(,)}
                                         02728,01488,05120,00448,08192,      {*,+,,,-,.}
                                         05268,                              {/}
                                         11114,18740,29351,31143,18926,      {0,1,2,3,4}
                                         31183,31695,04775,10922,31215,      {5,6,7,8,9}
                                         01040,05136,                        {:,;}
                                         17492,03640,05393,08615,29695,      {<,=,>,?,@}
                                         23535,15083,29263,15211,29391,      {A,B,C,D,E}
                                         04815,31311,23533,09362,11044,      {F,G,H,I,J}
                                         23277,29257,23421,24573,11114,      {K,L,M,N,O}
                                         05103,15215,22511,31183,09367,      {P,Q,R,S,T}
                                         31597,11117,24429,23213,09389,      {U,V,W,X,Y}
                                         29351,                              {Z}
                                         29263,17553,31015);                 {[,\,]}

Var VScreen:Pointer;

Procedure InitGraphMode;                                    {Standard Procs}
Procedure InitTextMode;
Procedure PutPixel(X,Y:Word; Col:Byte);
Function GetPixel(X,Y:Word):Byte;
Procedure HLine(X,Y,L:Word; Col:Byte);
Procedure VLine(X,Y,L:Word; Col:Byte);
Procedure InterpolateHLine(X,Y,L:Integer; C1,C2:Byte);
Procedure Line(X1,Y1,X2,Y2:Integer; Col:Byte);
Procedure Box(X,Y,L,H:Word; Col:Byte);
Procedure FBox(X,Y,L,H:Word; Col:Byte);
Procedure FillTriAngle(X1,Y1,X2,Y2,X3,Y3:Integer; Col:Byte);
Procedure DumpScreen;
Procedure UnDumpScreen;
Procedure WaitRetrace;
Procedure WaitShortRetrace;
Procedure FillScreen(Col:Byte);

Procedure GetSprite(Var P:Pointer; X,Y,Breite,Hohe:Word);   {Sprite Procs}
Procedure PutSprite(P:Pointer; X,Y:Word);
Procedure PutSpriteTrans(P:Pointer; X,Y:Word);
{$IfDef Windowed}
Procedure PutWinSprite(P:Pointer; X,Y:Integer);
Procedure PutWinSpriteTrans(P:Pointer; X,Y:Integer);
{$EndIf}
Procedure PutScaleSprite(P:Pointer;X,Y:Integer;XL,YL:Word);
Procedure PutScaleSpriteTrans(P:Pointer;X,Y:Integer;XL,YL:Word);
Procedure PutSpritePixel(Var P:Pointer; X,Y:Word; Col:Byte);
Function GetSpritePixel(P:Pointer; X,Y:Word):Byte;
Procedure FreeSprite(Var P:Pointer);
Procedure OpenSprite(Var P:Pointer;Hohe,Breite:Word);
Procedure SaveSprite(P:Pointer; FileName:String);
Procedure LoadSprite(Var P:Pointer; FileName:String);
Function SpriteOverLap(P1,P2:Pointer;X1,Y1,X2,Y2:Word):Boolean;
Function GetSpriteXL(P:Pointer):Word;
Function GetSpriteYL(P:Pointer):Word;

Procedure SetPal(PalNum,R,G,B:Byte);                        {Palette Procs}
Function GetPalR(PalNum:Byte):Byte;
Function GetPalG(PalNum:Byte):Byte;
Function GetPalB(PalNum:Byte):Byte;
Procedure SetBorder(Col:Byte);

Function StrLen(Text:String):Word;                          {Font Procs}
Function Int2Str(I:LongInt):String;
Function Str2Int(S:String):LongInt;
Procedure OutText(X,Y:Integer; Text:String; Col:Byte);

Procedure Wait(Time:Word);                                  {Misc Procs}
Function Key:Boolean;
Procedure NoKey;
Function ReadPort:Byte;
Function ReadKey:Char;

{****************************************************************************}
{*****************************} Implementation {*****************************}
{****************************************************************************}

Const GraphModeOpen:Boolean=False;

Var SaveProc:Pointer;

{****************************************************************************}
{*********************************************************** Standard Procs *}
{****************************************************************************}

Procedure InitGraphMode;Assembler;

Asm
   mov GraphModeOpen,True
   mov ax,$0013
   int 10h
End;

Procedure InitTextMode;Assembler;

Asm
   mov GraphModeOpen,False
   mov ax,$0003
   int 10h
End;

Procedure PutPixel;Assembler;

Asm
{$IfDef Windowed}
   mov ax,X
   cmp ax,MinX
   jb @skip
   cmp ax,MaxX
   ja @skip
   mov ax,Y
   cmp ax,MinY
   jb @skip
   cmp ax,MaxY
   ja @skip
{$EndIf}
   les di,VScreen
   mov di,X
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add di,ax
   add di,bx
   mov al,Col
   stosb
@skip:
End;

Function GetPixel;Assembler;

Asm
   push ds
{$IfDef Windowed}
   mov ax,X
   cmp ax,MinX
   jb @skip
   cmp ax,MaxX
   ja @skip
   mov ax,Y
   cmp ax,MinY
   jb @skip
   cmp ax,MaxY
   ja @skip
{$EndIf}
   lds si,VScreen
   mov si,X
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add si,ax
   add si,bx
   lodsb
@skip:
   pop ds
End;

Procedure HLine;Assembler;

Asm
   les di,VScreen
   mov bx,Y
   mov cx,bx
   shl bx,$08
   shl cx,$06
   add bx,cx
   add bx,X
   add di,bx
   mov al,Col
   mov ah,al
   mov cx,L
   shr cx,$01
   jnc @nobyte
   stosb
@nobyte:
   rep stosw
End;

Procedure VLine;Assembler;

Asm
   les di,VScreen
   mov bx,Y
   mov cx,bx
   shl bx,$08
   shl cx,$06
   add bx,cx
   add bx,X
   add di,bx
   mov cx,L
   mov al,Col
@looper1:
   stosb
   add di,319
   loop @looper1
End;

Procedure InterpolateHLine;Assembler;

Asm
   les di,VScreen
   xor bl,bl
   mov ax,Y
   mov bh,al
   shl ax,6
   add di,bx
   add di,ax
   add di,X
   mov cx,L
   mov bh,C1

   mov al,C2
   sub al,bh
   shl ax,8
   cwd
   idiv cx

@loop:
   mov es:[di],bh
   inc di
   add bx,ax
   dec cx
   jnz @loop
End;

Procedure Line;

Function Sign(a:integer):Integer;

Begin
     If a>0 Then Sign:=+1;
     If a<0 Then Sign:=-1;
     If a=0 Then Sign:=0;
End;

Var i,s,d1x,d1y,d2x,d2y,u,v,m,n:Integer;

Begin
     u:=x2-x1;
     v:=y2-y1;
     d1x:=Sign(u);
     d1y:=Sign(v);
     d2x:=Sign(u);
     d2y:=0;
     m:=Abs(u);
     n:=Abs(v);
     If Not(M>N) Then
        Begin
             d2x:=0;
             d2y:=Sign(v);
             m:=Abs(v);
             n:=Abs(u);
        End;
     s:=m ShR 1;
     For i:=0 To M Do
         Begin
              PutPixel(x1,y1,Col);
              Asm
                 mov ax,n
                 add s,ax         {s := s + n;}
                 mov ax,s
                 cmp ax,m
                 jb @elseif       {IF not (s<m) THEN BEGIN}
                 mov ax,m
                 sub s,ax         {s := s - m;}
                 mov ax,d1x
                 add x1,ax         {x1:= x1 + d1x;}
                 mov ax,d1y
                 add y1,ax         {y1 := y1 + d1y;}
                 jmp @endif       {end}
              @elseif:            {ELSE BEGIN}
                 mov ax,d2x
                 add x1,ax         {x1 := x1 + d2x;}
                 mov ax,d2y
                 add y1,ax         {y1 := y1 + d2y;}
              @endif:             {END;}
              End;
         End;
End;

Procedure FBox;Assembler;

Asm
{$IfDef Windowed}
   mov ax,X             {ganz draussen rechts}
   cmp ax,MaxX
   ja @ende
   add ax,L            {ganz draussen links}
   cmp ax,MinX
   jbe @ende
   cmp ax,MaxX          {halb draussen rechts}
   jbe @weiterx1
   mov bx,ax
   sub bx,MaxX
   sub L,bx
   inc L
@weiterx1:
   mov ax,x             {halb draussen links}
   cmp ax,MinX
   ja @weiterx2
   mov bx,MinX
   sub bx,ax
   add X,bx
   sub L,bx
@weiterx2:
   mov ax,Y             {ganz draussen unten}
   cmp ax,MaxY
   ja @ende
   add ax,H            {ganz draussen oben}
   cmp ax,MinY
   jbe @ende
   cmp ax,MaxY          {halb draussen unten}
   jbe @weitery1
   mov bx,ax
   sub bx,MaxY
   sub H,bx
   inc H
@weitery1:
   mov ax,Y             {halb draussen oben}
   cmp ax,MinY
   ja @weitery2
   mov bx,MinY
   sub bx,ax
   add Y,bx
   sub H,bx
@weitery2:
{$EndIf}
   les di,VScreen
   mov bx,Y
   mov cx,bx
   shl bx,$08
   shl cx,$06
   add bx,cx
   add di,bx
   add di,X
   mov bx,H
   mov al,Col
   mov ah,al
   mov si,320
   sub si,L
   mov cx,L
   push cx
@looper1:
   shr cx,$01
   jnc @nobyte
   stosb
@nobyte:
   rep stosw
   add di,si
   pop cx
   push cx
   dec bx
   jnz @looper1
   pop cx
@ende:
End;

Procedure Box;Assembler;

Asm
   les di,VScreen       {Anfangs Adresse berechnen}
   mov bx,y
   mov cx,bx
   shl bx,$08
   shl cx,$06
   add bx,cx
   add di,bx
   add di,X             {AA Ende}
   mov dx,L
   and dx,$01
   mov si,320
   sub si,L
                        {Erste Linie berechnen}
   mov cx,L
   push cx
   mov al,Col
   mov ah,al
                        {Erste Linie Zeichnen}
   shr cx,$01
   jnc @nobyte1
   stosb
@nobyte1:
   rep stosw
                        {vertikalen Linien}
   mov bx,H
   sub bx,$02
@looper1:
   add di,si
   stosb
   add di,L
   sub di,$02
   stosb
   dec bx
   jnz @looper1
                        {Letzte Linie}
   add di,si
   pop cx
   shr cx,$01
   jnc @nobyte2
   stosb
@nobyte2:
   rep stosw
End;

Procedure FillTriAngle;

Const FracBits=16;

Var YMin,YMax,YCurr:Integer;
    XMin,XMax:Integer;
    DX1,DX2,DX3:LongInt;
    XP1,XP2,XP3:LongInt;
    Temp,Dont:Integer;

Begin
     YMin:=Y1;
     YMax:=Y1;
     If (Y2<YMin) Then
        Begin
             YMin:=X2; X2:=X1; X1:=YMin;
             YMin:=Y2; Y2:=Y1; Y1:=YMin;
        End;
     If (Y2>YMax) Then YMax:=Y2;
     If (Y3<YMin) Then
        Begin
             YMin:=X3; X3:=X1; X1:=YMin;
             YMin:=Y3; Y3:=Y1; Y1:=YMin;
        End;
     If (Y3>YMax) Then YMax:=Y3;
     If (Y3<Y2) Then
        Begin
             Temp:=Y3; Y3:=Y2; Y2:=Temp;
             Temp:=X3; X3:=X2; X2:=Temp;
        End;

     XP1:=LongInt(X1) Shl FracBits;                    {Xpos in 9.7 fixed point math }
     XP2:=LongInt(X1) Shl FracBits;
     XP3:=LongInt(X2) Shl FracBits;
     Dont:=0;
     If Y2=Y1 Then Dont:=1
              Else DX1:=(LongInt(X2-X1) Shl FracBits) Div (Y2-Y1);
     If Y3=Y1 Then Dont:=2
              Else DX2:=(LongInt(X3-X1) Shl FracBits) Div (Y3-Y1);
     If Y3=Y2 Then Dont:=3
              Else DX3:=(LongInt(X3-X2) Shl FracBits) Div (Y3-Y2);
     For YCurr:=YMin To YMax Do
         Begin
              XMin:=32000;
              XMax:=-32000;
              If (YCurr<=Y2) And (Dont<>1) Then
                 Begin
                      XMin:=XP1 Shr FracBits;
                      XMax:=XMin;
                      Inc(XP1,DX1);
                 End;
              If (YCurr<=Y3) And (Dont<>2) Then
                 Begin
                      Temp:=XP2 Shr FracBits;
                      If Temp<XMin Then XMin:=Temp;
                      If Temp>XMax Then XMax:=Temp;
                      Inc(XP2,DX2);
                 End;
              If (YCurr>=Y2) And (Dont<>3) Then
                 Begin
                      Temp:=XP3 Shr FracBits;
                      If Temp<XMin Then XMin:=Temp;
                      If Temp>XMax Then XMax:=Temp;
                      Inc(XP3,DX3);
                 End;
              If XMin<MinX Then XMin:=MinX;
              If XMax>MaxX Then XMax:=MaxX;
              If (XMin<=MaxX) And (XMax>=XMin) And
                 (YCurr>=MinY) And (YCurr<=MaxY) Then
                 HLine(XMin,YCurr,XMax-XMin+1,Col);
         End;
End;

Procedure DumpScreen;Assembler;

Asm
   push ds
   lds si,VScreen
   xor di,di
   mov ax,$a000
   mov es,ax
   mov cx,$7d00
   rep movsw
   pop ds
End;

Procedure UnDumpScreen;Assembler;

Asm
   push ds
   les di,VScreen
   xor si,si
   mov ax,$a000
   mov ds,ax
   mov cx,$7d00
   rep movsw
   pop ds
End;

Procedure FillScreen;Assembler;

Asm
   les di,VScreen
   mov al,Col
   mov ah,al
   mov cx,$7d00
   rep stosw
End;

Procedure WaitRetrace;Assembler;

Asm
   mov dx,$03da
@l1:
   in al,dx
   and al,$08
   jnz @l1
@l2:
   in al,dx
   and al,$08
   jz @l2
End;

Procedure WaitShortRetrace;Assembler;

Asm
   mov dx,$03da
@l1:
   in al,dx
   and al,$01
   jnz @l1
@l2:
   in al,dx
   and al,$01
   jz @l2
End;

{****************************************************************************}
{************************************************************* Sprite Procs *}
{****************************************************************************}

Procedure GetSprite;

Begin
     GetMem(P,Breite*Hohe+4);
     Asm
        push ds
        lds si,P
        lodsw
        mov di,ax
        lodsw
        mov es,ax
        pop ds
        mov ax,Breite
        stosw
        mov ax,Hohe
        stosw
        mov cx,Breite
        mov dx,Hohe
        mov ax,Y
        mov bx,ax
        shl ax,$08
        shl bx,$06
        add ax,bx
        add ax,X
        mov bx,320
        sub bx,Breite
        push ds
        lds si,[VScreen]
        add si,ax
     @looper1:
        push cx
        shr cx,$01
        jnc @nobyte
        movsb
     @nobyte:
        rep movsw
        pop cx
        add si,bx
        dec dx
        jnz @looper1
        pop ds
     End;
End;

Procedure PutSprite;Assembler;

Asm
   push ds
   les di,[VScreen]
   lds si,P
   lodsw
   mov cx,ax
   lodsw
   mov dx,ax
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add ax,bx
   add ax,X
   mov bx,320
   sub bx,cx
   add di,ax
@looper1:
   push cx
   shr cx,$01
   jnc @nobyte
   movsb
@nobyte:
   rep movsw
   pop cx
   add di,bx
   dec dx
   jnz @looper1
   pop ds
End;

Procedure PutSpriteTrans;Assembler;

Var A:Byte;

Asm
   mov ah,AlphaChannel
   mov A,ah
   push ds
   les di,[VScreen]
   lds si,P
   lodsw
   mov cx,ax
   lodsw
   mov dx,ax
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add ax,bx
   add ax,X
   mov bx,320
   sub bx,cx
   add di,ax
@looper1:
   push cx
@looper2:
   lodsb
   inc di
   cmp al,A
   je @trans
   dec di
   stosb
@trans:
   loop @looper2
   pop cx
   add di,bx
   dec dx
   jnz @looper1
   pop ds
End;

{$IfDef Windowed}
Procedure PutWinSprite;Assembler;

Var X1,X2,Y1:Word;

Asm
   xor ax,ax
   mov X1,ax
   mov X2,ax
   mov Y1,ax
   push ds
   les di,[VScreen]
   lds si,P
   lodsw
   mov cx,ax
   lodsw
   mov dx,ax
   pop ds
   mov ax,X             {ganz draussen rechts}
   cmp ax,MaxX
   jg @ende
   add ax,cx            {ganz draussen links}
   cmp ax,MinX
   jle @ende
   cmp ax,MaxX          {halb draussen rechts}
   jle @weiterx1
   mov bx,ax
   sub bx,MaxX
   mov X2,bx                    {X2}
   dec X2
   sub cx,bx
   inc cx
@weiterx1:
   mov ax,x             {halb draussen links}
   cmp ax,MinX
   jg @weiterx2
   mov bx,MinX
   sub bx,ax
   add X,bx
   mov X1,bx                    {X1}
   sub cx,bx
@weiterx2:
   mov ax,Y             {ganz draussen unten}
   cmp ax,MaxY
   jg @ende
   add ax,dx            {ganz draussen oben}
   cmp ax,MinY
   jle @ende
   cmp ax,MaxY          {halb draussen unten}
   jle @weitery1
   mov bx,ax
   sub bx,MaxY
   sub dx,bx
   inc dx
@weitery1:
   mov ax,Y             {halb draussen oben}
   cmp ax,MinY
   jg @weitery2
   mov bx,MinY
   sub bx,ax
   add Y,bx
   mov Y1,bx                    {Y1}
   sub dx,bx
@weitery2:
   push ds
   push dx
   lds si,P
   lodsw
   add si,2
   mul Y1
   add si,ax
   pop dx
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add ax,bx
   add ax,X
   mov bx,320
   sub bx,cx
   add di,ax
@looper1:
   add si,X1
   push cx
   shr cx,$01
   jnc @nobyte
   movsb
@nobyte:
   rep movsw
   pop cx
   add di,bx
   add si,X2
   dec dx
   jnz @looper1
   pop ds
@ende:
End;

Procedure PutWinSpriteTrans;Assembler;

Var X1,X2,Y1:Word;
    A:Byte;

Asm
   mov ah,AlphaChannel
   mov A,ah
   xor ax,ax
   mov X1,ax
   mov X2,ax
   mov Y1,ax
   push ds
   les di,[VScreen]
   lds si,P
   lodsw
   mov cx,ax
   lodsw
   mov dx,ax
   pop ds
   mov ax,X             {ganz draussen rechts}
   cmp ax,MaxX
   jg @ende
   add ax,cx            {ganz draussen links}
   cmp ax,MinX
   jle @ende
   cmp ax,MaxX          {halb draussen rechts}
   jle @weiterx1
   mov bx,ax
   sub bx,MaxX
   mov X2,bx                    {X2}
   dec X2
   sub cx,bx
   inc cx
@weiterx1:
   mov ax,x             {halb draussen links}
   cmp ax,MinX
   jg @weiterx2
   mov bx,MinX
   sub bx,ax
   add X,bx
   mov X1,bx                    {X1}
   sub cx,bx
@weiterx2:
   mov ax,Y             {ganz draussen unten}
   cmp ax,MaxY
   jg @ende
   add ax,dx            {ganz draussen oben}
   cmp ax,MinY
   jle @ende
   cmp ax,MaxY          {halb draussen unten}
   jle @weitery1
   mov bx,ax
   sub bx,MaxY
   sub dx,bx
   inc dx
@weitery1:
   mov ax,Y             {halb draussen oben}
   cmp ax,MinY
   jg @weitery2
   mov bx,MinY
   sub bx,ax
   add Y,bx
   mov Y1,bx                    {Y1}
   sub dx,bx
@weitery2:
   push ds
   push dx
   lds si,P
   lodsw
   add si,2
   mul Y1
   add si,ax
   pop dx
   mov ax,Y
   mov bx,ax
   shl ax,$08
   shl bx,$06
   add ax,bx
   add ax,X
   mov bx,320
   sub bx,cx
   add di,ax
@looper1:
   add si,X1
   push cx
@looper2:
   lodsb
   inc di
   cmp al,A
   je @trans
   dec di
   stosb
@trans:
   loop @looper2
   pop cx
   add di,bx
   add si,X2
   dec dx
   jnz @looper1
   pop ds
@ende:
End;
{$EndIf}

Procedure PutScaleSprite;Assembler;

Var I,II:Integer;

Asm
   les di,VScreen          {Berechne Ort in VScreen}
   push ds
   add di,X
   mov ax,Y
   mov bx,ax
   shl ax,8
   shl bx,6
   add di,ax
   add di,bx

   mov ax,320d             {berechne offset zwischen zwei hlines=320-XL}
   sub ax,XL
   push ax                 {speichern an oberster stelle in stack}

   xor ax,ax               {initialisiere schlaufe II=Y z„hler}
   mov II,ax
@for1:
   xor ax,ax               {initialisiere schlaufe I=X z„hler}
   mov I,ax

   lds si,P                {berechne Y position in sprite bezglich YL}
   lodsw
   mov bx,ax               {XL in bx speichern...}
   lodsw
   mul II
   div YL
   mul bx                  {...um damit ypos zu berechnen}
   add ax,2                {wegen lodsw bei xpos von unten}
   mov cx,ax               {ypos in cx speichern}
   mov bx,XL               {bx mit XL Laden 2x fr unten}

@for2:
   lds si,P                {Berechne x position in Sprite bezglich XL}
   lodsw
   mul I
   div bx                  {bx=XL noch von oben initialisiert}

   add si,ax               {xposition addieren}
   add si,cx               {yposition addieren}
   movsb                   {kopieren}

   inc I                   {Schlaufe I=X z„hler}
   cmp I,bx                {bx=XL noch von oben initialisiert}
   jnz @for2

   add di,[bp-8]           {offset zwischen zeilen=pop ax;add di,ax;push ax}

   inc II                  {Schlaufe II=Y z„hler}
   mov ax,YL
   cmp II,ax
   jnz @for1
   pop ax
   pop ds
End;

Procedure PutScaleSpriteTrans;Assembler;

Var I,II:Integer;
    A:Byte;  {eine var mehr als oben-> [bp-10]}

Asm
   mov al,AlphaChannel
   mov A,al
   les di,VScreen          {Berechne Ort in VScreen}
   push ds
   add di,X
   mov ax,Y
   mov bx,ax
   shl ax,8
   shl bx,6
   add di,ax
   add di,bx

   mov ax,320d             {berechne offset zwischen zwei hlines=320-XL}
   sub ax,XL
   push ax                 {speichern an oberster stelle in stack}

   xor ax,ax               {initialisiere schlaufe II=Y z„hler}
   mov II,ax
@for1:
   xor ax,ax               {initialisiere schlaufe I=X z„hler}
   mov I,ax

   lds si,P                {berechne Y position in sprite bezglich YL}
   lodsw
   mov bx,ax               {XL in bx speichern...}
   lodsw
   mul II
   div YL
   mul bx                  {...um damit ypos zu berechnen}
   add ax,2                {wegen lodsw bei xpos von unten}
   mov cx,ax               {ypos in cx speichern}
   mov bx,XL               {bx mit XL Laden 2x fr unten}

@for2:
   lds si,P                {Berechne x position in Sprite bezglich XL}
   lodsw
   mul I
   div bx                  {bx=XL noch von oben initialisiert}

   add si,ax               {xposition addieren}
   add si,cx               {yposition addieren}

   lodsb                   {kopieren}
   inc di
   cmp al,A
   je @nocopy
   dec di
   stosb
@nocopy:

   inc I                   {Schlaufe I=X z„hler}
   cmp I,bx                {bx=XL noch von oben initialisiert}
   jnz @for2

   add di,[bp-10]          {offset zwischen zeilen=pop ax;add di,ax;push ax}
                           {da eine "var a:byte" mehr->10 statt 8}

   inc II                  {Schlaufe II=Y z„hler}
   mov ax,YL
   cmp II,ax
   jnz @for1
   pop ax
   pop ds
End;


Procedure PutSpritePixel;Assembler;

Asm
   push ds
   lds si,P
   lodsw
   mov di,ax
   lodsw
   mov es,ax
   mov ds,ax
   mov si,di
   lodsw
   pop ds

   mov bx,Y        {Berechne pos}
   dec bx
   mul bx
   add di,ax
   add di,X
   add di,$03      {2+2 (Hohe+Breite)=4  -1 (X)}
   mov al,Col
   stosb
End;

Function GetSpritePixel;Assembler;

Asm
   push ds         {Setze lods register}
   lds si,P
   lodsw

   mov bx,Y        {Berechne pos}
   dec bx
   mul bx
   add si,ax
   add si,X
   inc si          {2+2 (Hohe+Breite)=4  -1 (X)=3  -2 (lodsw Breite)=1 -> inc}
   lodsb
   pop ds
End;

Procedure FreeSprite;

Var Size:Word;

Begin
     Asm
        push ds
        lds si,P
        lodsw
        mov bx,ax
        lodsw
        mov ds,ax
        mov si,bx
        lodsw
        mov bx,ax
        lodsw
        mul bx
        add ax,$04
        pop ds
        mov Size,ax
     End;
     FreeMem(P,Size);
End;

Procedure OpenSprite;


Begin
     GetMem(P,Breite*Hohe+4);
     Asm
        push ds
        lds si,P
        lodsw
        mov di,ax
        lodsw
        mov es,ax
        pop ds
        mov ax,Hohe
        stosw
        mov ax,Breite
        stosw
        mov cx,Breite
        mov ax,Hohe
        mul cx
        mov cx,ax
        xor ax,ax
        rep stosb
     End;
End;

Procedure SaveSprite;

Var F:File;
    Breite,Hohe:Word;

Begin
     Asm
        push ds
        lds si,P
        lodsw
        mov bx,ax
        lodsw
        pop ds
        mov Breite,bx
        mov Hohe,ax
     End;
     Assign(F,FileName);
     ReWrite(F,1);
     BlockWrite(F,P^,Breite*Hohe+4);
     Close(F);
End;

Procedure LoadSprite;

Var F:File;
    Breite,Hohe:Word;

Begin
     Assign(F,FileName);
     ReSet(F,1);
     BlockRead(F,Breite,2);
     BlockRead(F,Hohe,2);
     GetMem(P,Breite*Hohe+4);
     Seek(F,0);
     BlockRead(F,P^,Breite*Hohe+4);
     Close(F);
End;

Function SpriteOverLap;

Var O1,S1,O2,S2:Word;

Begin
     O1:=Ofs(P1^);
     S1:=Seg(P1^);
     O2:=Ofs(P2^);
     S2:=Seg(P2^);
     Asm
        mov @result,False
        push ds
        mov ds,S1
        mov si,O1
        lodsw           {Breite}
        mov O1,ax
        lodsw           {Hohe}
        mov S1,ax
        mov ds,S2
        mov si,O2
        lodsw           {Breite}
        mov O2,ax
        lodsw           {Hohe}
        mov S2,ax
        pop ds
        mov ax,X1
        add ax,O1
        cmp ax,X2
        jb @ende
        mov ax,Y1
        add ax,S1
        cmp ax,Y2
        jb @ende
        mov ax,X2
        add ax,O2
        cmp ax,X1
        jb @ende
        mov ax,Y2
        add ax,S2
        cmp ax,Y1
        jb @ende
        mov @result,True
     @ende:
     End;
End;

Function GetSpriteXL;

Var Breite,Hohe:Word;

Begin
     Breite:=Ofs(P^);
     Hohe:=Seg(P^);
     Asm
        push ds
        mov si,Breite
        mov ds,Hohe
        lodsw
        mov Breite,ax
        pop ds
     End;
     GetSpriteXL:=Breite;
End;

Function GetSpriteYL;

Var Breite,Hohe:Word;

Begin
     Breite:=Ofs(P^);
     Hohe:=Seg(P^);
     Asm
        push ds
        mov si,Breite
        mov ds,Hohe
        add si,$02
        lodsw
        mov Hohe,ax
        pop ds
     End;
     GetSpriteYL:=Hohe;
End;

{****************************************************************************}
{************************************************************ Palette Procs *}
{****************************************************************************}

Procedure SetPal;Assembler;

Asm
   mov dx,$03c8
   mov al,Palnum
   out dx,al
   inc dx
   mov al, R
   out dx,al
   mov al,G
   out dx,al
   mov al,B
   out dx,al
End;

Function GetPalR;Assembler;

Asm
   mov dx,$03c7
   mov al,PalNum
   out dx,al
   add dx,2
   in al,dx
End;

Function GetPalG;Assembler;

Asm
   mov dx,$03c7
   mov al,PalNum
   out dx,al
   add dx,2
   in al,dx
   in al,dx
End;

Function GetPalB;Assembler;

Asm
   mov dx,$03c7
   mov al,PalNum
   out dx,al
   add dx,2
   in al,dx
   in al,dx
   in al,dx
End;

Procedure SetBorder;Assembler;

Asm
   mov dx,$3da
   in al,dx
   mov dx,$3c0
   mov al,$11
   or al,$20
   out dx,al
   mov al,Col
   out dx,al
End;

{****************************************************************************}
{*************************************************************** Font Procs *}
{****************************************************************************}

Function StrLen;Assembler;

Asm
   push ds
   lds si,Text
   lodsb
   xor ah,ah
   shl ax,$02
   dec ax
   pop ds
End;

Function ConvertChar(Letter:Byte):Byte;

Begin
     Case Letter Of
          32..93:ConvertChar:=Letter-32;

     Else ConvertChar:=0;
     End;
End;

Procedure OutWinChar(X,Y:Word; Letter,Col:Byte);Assembler;

Asm
   push ds
   mov cx,15
   lea si,Ascii_Data
   mov al,Letter
   xor ah,ah
   shl ax,1
   add si,ax
   lodsw
   mov dx,ax
   shl dx,1
@looper:                {PutPixel(X+((I-1) Mod 3),Y+((I-1) Div 3),Col);}
   shl dx,1
   jnc @nopixel
   mov ax,cx
   dec ax
   mov bx,3
   div bl
   mov bl,ah
   add bx,x
   mov di,bx
{$IfDef Windowed}
   cmp bx,MinX
   jl @nopixel
   cmp bx,MaxX
   jg @nopixel
{$EndIf}
   xor bh,bh
   mov bl,al
   add bx,y
{$IfDef Windowed}
   cmp bx,MinY
   jl @nopixel
   cmp bx,MaxY
   jg @nopixel
{$EndIf}
   push di
   les di,VScreen
   pop di
   mov ax,bx
   shl ax,8
   shl bx,6
   add di,ax
   add di,bx
   mov al,Col
   stosb
@nopixel:
   loop @looper
   pop ds
End;

Procedure OutChar(X,Y:Word; Letter,Col:Byte);Assembler;

Asm
   push ds
   mov cx,15
   lea si,Ascii_Data
   mov al,Letter
   xor ah,ah
   shl ax,1
   add si,ax
   lodsw
   mov dx,ax
   shl dx,1
@looper:                {PutPixel(X+((I-1) Mod 3),Y+((I-1) Div 3),Col);}
   shl dx,1
   jnc @nopixel
   mov ax,cx
   dec ax
   mov bx,3
   div bl
   mov bl,ah
   add bx,x
   mov di,bx
   xor bh,bh
   mov bl,al
   add bx,y
   push di
   les di,VScreen
   pop di
   mov ax,bx
   shl ax,8
   shl bx,6
   add di,ax
   add di,bx
   mov al,Col
   stosb
@nopixel:
   loop @looper
   pop ds
End;

Function Int2Str;

Var S:String;

Begin
     Str(I,S);
     Int2Str:=S;
End;

Function Str2Int;

Var I,Code:Integer;

Begin
     Val(S,I,Code);
     Str2Int:=I;
End;

Procedure OutText;

Var I:Integer;

Begin
     If Length(Text)>0 Then
        For I:=1 To Length(Text) Do
            If (X+(I-1)*4<=MaxX) And
               (X+(I-1)*4+3>=MinX) And
               (Y<=MaxY) And
               (Y+5>=MinY) Then
               Begin
                    If (X+(I-1)*4<MinX) Or
                       (X+(I-1)*4+3>MaxX) Or
                       (Y>MinY) Or
                       (Y+5<MaxY) Then
                       OutWinChar(X+(I-1)*4,Y,ConvertChar(Ord(UpCase(Text[I]))),Col)
                       Else OutChar(X+(I-1)*4,Y,ConvertChar(Ord(UpCase(Text[I]))),Col)
               End;
End;

{****************************************************************************}
{*************************************************************** Misc Procs *}
{****************************************************************************}

Procedure Wait;Assembler;

Asm
   mov ax,$03e8
   mul Time
   mov cx,dx
   mov dx,ax
   mov ah,$86
   int 15h
End;

Function Key;Assembler;

Asm
   mov ah,$01
   int 16h
   mov ax,$01
   jnz @weiter
   xor ax,ax
@weiter:
End;

Procedure NoKey;Assembler;

Asm
@looper:
   mov ah,$01
   int 16h
   jz @nokey
   xor ah,ah
   int 16h
   jmp @looper
@nokey:
End;

Function ReadPort;Assembler;

Asm
   mov dx,$60
   in al,dx
End;

Function ReadKey;Assembler;

Asm
   xor ah,ah
   int 16h
End;

Const Text='Visit http://www.datacomm.ch/asuter';

{$F+}
Procedure NewExitProc;

Begin
     ExitProc:=SaveProc;
     FreeMem(VScreen,64000);
     If GraphModeOpen Then InitTextMode;
     WriteLn('NColor by Peter Suter & Clau Curtins');
     WriteLn(Text);
End;
{$F-}

Begin
     WriteLn('NColor by Peter Suter & Clau Curtins');
     WriteLn(Text);
     SaveProc:=ExitProc;
     ExitProc:=@NewExitProc;
     GetMem(VScreen,64000);
End.