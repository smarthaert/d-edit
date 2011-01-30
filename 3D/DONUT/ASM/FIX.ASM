LOCALS

DATA SEGMENT PUBLIC
  extrn SinTable:Word;
DATA ENDS

CODE SEGMENT PUBLIC

ASSUME cs:CODE,ds:DATA

PUBLIC FixMul
PUBLIC FixSqr
PUBLIC FixDiv
PUBLIC FixSin
PUBLIC FixCos
PUBLIC FixAbs
PUBLIC FixSQRT

.386

FixMul PROC Pascal Far

pop ecx
pop ebx
pop eax
imul ebx
shrd eax,edx,9
rol eax,16d
mov dx,ax
rol eax,16d
push ecx
ret

ENDP

FixSqr PROC Pascal Far

pop ecx
pop eax
imul eax
shrd eax,edx,9
rol eax,16d
mov dx,ax
rol eax,16d
push ecx
ret

ENDP

FixDiv PROC Pascal Far

pop ecx
pop ebx
pop eax
cdq
shld edx,eax,9
shl eax,9
idiv ebx
rol eax,16d
mov dx,ax
rol eax,16d
push ecx
ret

ENDP

FixSin PROC Pascal Far

pop ecx
pop bx
$$Sin:
and bx,7fh
shl bx,1
mov ax,[bx+SinTable]
cwd
push ecx
ret

ENDP

FixCos PROC Pascal Far

pop ecx
pop bx
add bx,32d
jmp $$Sin

ENDP

FixAbs PROC Pascal Far

pop ecx
pop eax
cdq
xor eax,edx
sub eax,edx
rol eax,16d
mov dx,ax
rol eax,16d
push ecx
ret

ENDP

FixSQRT PROC Pascal Far

pop edi
pop esi
xor ecx,ecx
mov ebx,100000h
@@loop:
mov eax,ebx
or eax,ecx
imul eax
shrd eax,edx,9
cmp eax,esi
ja @@notgood
or ecx,ebx
@@notgood:
shr ebx,1
test ebx,ebx
jnz @@loop
mov ax,cx
ror ecx,16d
mov dx,cx
push edi
ret

ENDP

CODE ENDS
END
