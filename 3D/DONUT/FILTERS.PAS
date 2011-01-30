Unit Filters;

Interface

Const MinCol:Byte=4;
      Antilevel:Word=1;

Procedure FireBlaze(FireMinX,FireMinY,FireMaxX,FireMaxY:Word);
Procedure FireSmooth(FireMinX,FireMinY,FireMaxX,FireMaxY:Word);
Procedure AntiAlias(AntiMinX,AntiMinY,AntiMaxX,AntiMaxY:Word);

Procedure SetFilterPal(Mode:Byte);

Implementation

Uses NColor,Fade;

Procedure FireBlaze;Assembler;

Asm
   push ds
   les si,VScreen
   lds di,VScreen

   mov ax,FireMinY              {Oberer Rand + 1. linker Rand}
   mov bx,ax
   shl ax,8
   shl bx,6
   add ax,bx
   add ax,FireMinX
   add di,ax
   add si,ax

   mov cx,FireMaxY              {push (bp-4): Y Counter}
   sub cx,FireMinY
   inc cx
   push cx

   mov bx,320                   {bx: Rechter + Linker Rand}
   mov dx,FireMaxX
   sub bx,dx
   add bx,FireMinX
   dec bx

   sub dx,FireMinX              {push (bp-6): X Counter}
   inc dx
   push dx

@loopY:
   mov dx,[bp-6]                {X Counter Neu Laden}
@loopX:
{***** FILTER *****}
   mov cl,ds:[si+320]           { If (GetPixel(X,Y+1)>=MinCol) }
   cmp cl,MinCol
   jnae @ZuKlein

   in al,$50                    { Randomwert }
   mov ch,al
   and ch,MinCol                { Random MinCol }
   sub cl,ch

   and al,00000011b             { Random 4 }
   mov ah,al
   shr ah,1
   or ah,00000010b
   xor ah,00000001b
   and al,ah
   and al,ah
   xor ah,ah
   dec ax                       { -1,0 oder 1 }

   add di,ax
   mov es:[di],cl               { Then PutPixel(X-(Random(3)-1),Y,GetPixel(X,Y+1)-Random(MinCol))}
   sub di,ax
   jmp @Weiter
@ZuKlein:
   mov al,MinCol                { Else PutPixel(X,Y,MinCol);}
   mov es:[di],al
{***** FILTER *****}
@Weiter:
   inc si                       { 1 Pixel nach Rechts }
   inc di{}
{   dec si
   dec di{}

   dec dx                       { X Counter }
   jnz @loopX
   add si,bx                    { Rechter + Linker Rand dazuz„hlen}
   add di,bx{}
{   sub si,bx
   sub di,bx{}

   mov cx,[bp-4]                { Y Counter }
   dec cx
   mov [bp-4],cx
   jnz @loopY

   pop dx                       {pop (bp-6)}
   pop bx                       {pop (bp-4)}
   pop ds
End;

Procedure FireSmooth;Assembler;

Asm
   push ds
   les si,VScreen
   lds di,VScreen

   mov ax,FireMaxY              {Oberer Rand + 1. linker Rand}
   mov bx,ax
   shl ax,8
   shl bx,6
   add ax,bx
   add ax,FireMaxX
   add di,ax
   add si,ax

   mov cx,FireMaxY              {push (bp-4): Y Counter}
   sub cx,FireMinY
   inc cx
   push cx

   mov bx,320                   {bx: Rechter + Linker Rand}
   mov dx,FireMaxX
   sub bx,dx
   add bx,FireMinX
   dec bx

   sub dx,FireMinX              {push (bp-6): X Counter}
   inc dx
   push dx

@loopY:
   mov dx,[bp-6]                {X Counter Neu Laden}
@loopX:
{***** FILTER *****}
   mov cl,ds:[si+320]           { If (GetPixel(X,Y+1)>=MinCol) }
   cmp cl,MinCol
   jnae @ZuKlein

   xor ch,ch
   xor ah,ah
   mov al,ds:[si]
   add cx,ax
   mov al,ds:[si-1]
   add cx,ax
   mov al,ds:[si+1]
   add cx,ax

   shr cx,2

   mov es:[di],cl               { Then PutPixel(X,Y,((GetPixel(X  ,Y)+GetPixel(X  ,Y+1)+
                                                      GetPixel(X+1,Y)+GetPixel(X-1,Y)) ShR 2))}
   jmp @Weiter
@ZuKlein:
   mov al,MinCol                { Else PutPixel(X,Y,MinCol);}
   mov es:[di],al
{***** FILTER *****}
@Weiter:
{   inc si                       { 1 Pixel nach Rechts }
{   inc di{}
   dec si
   dec di{}

   dec dx                       { X Counter }
   jnz @loopX
{   add si,bx                    { Rechter + Linker Rand dazuz„hlen}
{   add di,bx{}
   sub si,bx
   sub di,bx{}

   mov cx,[bp-4]                { Y Counter }
   dec cx
   mov [bp-4],cx
   jnz @loopY

   pop dx                       {pop (bp-6)}
   pop bx                       {pop (bp-4)}
   pop ds
End;

Procedure AntiAlias;Assembler;

Asm
   mov ax,AntiLevel             {das ganze vier mal (bp-2)}
   push ax
@allfourtimes:
   push ds
   les si,VScreen
   lds di,VScreen

   mov ax,AntiMinY              {Oberer Rand + 1. linker Rand}
   mov bx,ax
   shl ax,8
   shl bx,6
   add ax,bx
   add ax,AntiMinX
   add di,ax
   add si,ax

   mov cx,AntiMaxY              {push (bp-6): Y Counter}
   sub cx,AntiMinY
   inc cx
   push cx

   mov bx,320                   {bx: Rechter + Linker Rand}
   mov dx,AntiMaxX
   sub bx,dx
   add bx,AntiMinX
   dec bx

   sub dx,AntiMinX              {push (bp-8): X Counter}
   inc dx
   push dx

@loopY:
   mov dx,[bp-8]                {X Counter Neu Laden}
@loopX:
{***** FILTER *****}
   mov cl,ds:[si]
   cmp cl,MinCol
   jnae @ZuKlein


   xor cx,cx
   xor ah,ah
   mov al,ds:[si]
   add cx,ax
   add cx,ax
   add cx,ax
   add cx,ax
   mov al,ds:[si-320]
   add cx,ax
   mov al,ds:[si-320]
   add cx,ax
   mov al,ds:[si-1]
   add cx,ax
   mov al,ds:[si+1]
   add cx,ax
   shr cx,3
   mov es:[di],cl
   jmp @weiter
@ZuKlein:
   mov cl,MinCol
   mov es:[di],cl
{***** FILTER *****}
@Weiter:
   inc si                       { 1 Pixel nach Rechts }
   inc di{}
{   dec si
   dec di{}

   dec dx                       { X Counter }
   jnz @loopX
   add si,bx                    { Rechter + Linker Rand dazuz„hlen}
   add di,bx{}
{   sub si,bx
   sub di,bx{}

   mov cx,[bp-6]                { Y Counter }
   dec cx
   mov [bp-6],cx
   jnz @loopY

   pop dx                       {pop (bp-8)}
   pop bx                       {pop (bp-6)}
   pop ds
                                { Und jetz aufw„rts!!!!!! }
   push ds
   les si,VScreen
   lds di,VScreen

   mov ax,AntiMaxY              {Oberer Rand + 1. linker Rand}
   mov bx,ax
   shl ax,8
   shl bx,6
   add ax,bx
   add ax,AntiMaxX
   add di,ax
   add si,ax

   mov cx,AntiMaxY              {push (bp-6): Y Counter}
   sub cx,AntiMinY
   inc cx
   push cx

   mov bx,320                   {bx: Rechter + Linker Rand}
   mov dx,AntiMaxX
   sub bx,dx
   add bx,AntiMinX
   dec bx

   sub dx,AntiMinX              {push (bp-8): X Counter}
   inc dx
   push dx

@loopY_A:
   mov dx,[bp-8]                {X Counter Neu Laden}
@loopX_A:
{***** FILTER *****}
   mov cl,ds:[si]
   cmp cl,MinCol
   jnae @ZuKlein_A


   xor cx,cx
   xor ah,ah
   mov al,ds:[si]
   add cx,ax
   add cx,ax
   add cx,ax
   add cx,ax
   mov al,ds:[si-320]
   add cx,ax
   mov al,ds:[si-320]
   add cx,ax
   mov al,ds:[si-1]
   add cx,ax
   mov al,ds:[si+1]
   add cx,ax
   shr cx,3
   mov es:[di],cl
   jmp @weiter_A
@ZuKlein_A:
   mov cl,MinCol
   mov es:[di],cl
{***** FILTER *****}
@Weiter_A:
{   inc si                       { 1 Pixel nach Rechts }
{   inc di{}
   dec si
   dec di{}

   dec dx                       { X Counter }
   jnz @loopX_A
{   add si,bx                    { Rechter + Linker Rand dazuz„hlen}
{   add di,bx{}
   sub si,bx
   sub di,bx{}

   mov cx,[bp-6]                { Y Counter }
   dec cx
   mov [bp-6],cx
   jnz @loopY_A

   pop dx                       {pop (bp-8)}
   pop bx                       {pop (bp-6)}
   pop ds

   mov ax,[bp-2]
   dec ax
   mov [bp-2],ax
   jnz @allfourtimes
   pop ax
End;

Procedure SetFilterPal;

Var C:Byte;

Begin
     Case Mode Of
          1:For C:=0 To 127 Do
                Begin
                     SetPal(C,C ShR 1,0,0);
                     SetPal(C+128,63,C ShR 1,0);
                End;
          2:Begin
                 Ramp(  0, 0, 0, 0, 31,26, 3,38);
                 Ramp( 32,26, 3,38, 63,15,39,63);
                 Ramp( 64,15,39,63, 95,63,63,63);
                 Ramp( 96,63,63,63,111,63,63, 3);
                 Ramp(112,63,63, 3,130,63, 3,27);
            End;
     End;
End;

End.