; Original from Gabor Nagy
IDEAL

P386
MODEL small,pascal

LOCALS @@

DATASEG

EXTRN vaddr: DWORD,darkness: WORD,v: DWORD,h: DWORD
EXTRN wall: DWORD,x: WORD,hmh: WORD,hph: WORD,_Shade: WORD
EXTRN stp: DWORD,magic: DWORD,sina: DWORD,cosa: DWORD
EXTRN px128: DWORD,py128: DWORD,floor: DWORD,ceiling: DWORD
EXTRN scr_offs: WORD,scr_horizon: WORD,scr_height: WORD

CODESEG

PUBLIC DrawWallFloor

PROC DrawWallFloor
	push bp si di es
	mov ax,ds
	mov bp,[WORD darkness]
	mov fs,ax
	mov ebx,[DWORD v]
	mov si,[WORD h]
	mov di,[WORD vaddr]
	add di,[WORD scr_offs]
	and si,7Fh
	add di,[WORD x]
	add si,[WORD wall]
	mov ax,[WORD hmh]
	mov dx,[WORD hph]
	mov cx,ax
	shl ax,6
	add di,ax
	shl ax,2
	add di,ax
	mov ax,[WORD vaddr+2]
	mov es,ax 
	mov ax,[WORD wall+2]
	mov ds,ax

@@Cycl0:
	cmp cx,dx
	jae @@End0

	push ebx
	shr ebx,16
	shl bx,7
	add si,bx
	xor ax,ax
	mov al,[si]
	sub si,bx
	pop ebx
	rol esi,16
	mov si,[WORD fs: _Shade]
	add si,ax
	add si,bp
	mov al,[fs:si]
	mov [es:di],al
	ror esi,16

	inc cx
	add di,320
	add ebx,[DWORD fs:stp]
	jmp @@Cycl0
@@End0:
	mov ax,fs
	mov ds,ax
	mov ax,[WORD scr_height]
	cmp [WORD hph],ax
	je @@End1
	mov ax,[WORD vaddr+2]
	mov bx,[WORD vaddr]
	add bx,[WORD scr_offs]
	mov es,ax
	add bx,[WORD x]
	mov di,bx
	mov ax,[WORD hph]
	mov dx,ax
	shl ax,6
	add di,ax
	shl ax,2
	add di,ax
	rol edi,16
	mov di,bx
	mov ax,[WORD hmh]
	shl ax,6
	add di,ax
	shl ax,2
	add di,ax
	sub di,320
	ror edi,16
	xor ebx,ebx
	mov bx,dx  
	mov ax,[WORD floor+2]
	sub bx,[WORD scr_horizon] 
	mov fs,ax
	mov ax,[WORD ceiling+2]
	mov gs,ax
@@Cycl1:
	cmp bx, [WORD scr_horizon]
	jae @@End1

	xor edx,edx
	mov eax,[DWORD magic]
	div ebx
	mov ebp,eax
	mov eax,[DWORD sina]
	mul ebp
	shr eax,20
	add eax,[DWORD px128]
	and ax,7Fh
	mov si,ax
	mov eax,[DWORD cosa]
	mul ebp
	shr eax,20
	add eax,[DWORD py128]
	and ax,7Fh
	shl ax,7
	add si,ax
	shr ebp,10 
	cmp bp,0
	jne @@NumberZero
	inc bp
@@NumberZero:
	cmp bp,16
	jbe @@No16
	mov bp,16
@@No16:
	shl bp,8
	mov cx,si
	xor ax,ax
	add si,[WORD floor]
	mov al,[fs:si]
	mov si,[WORD _Shade]
	add si,ax
	add si,bp
	mov al,[si]
	mov [es:di],al
	add di,320
	rol edi,16
	mov si,cx
	xor ax,ax
	add si,[WORD ceiling]
	mov al,[gs:si]
	mov si,[WORD _Shade]
	add si,ax
	add si,bp
	mov al,[si]
	mov [es:di],al
	sub di,320
	ror edi,16
	inc bx
	jmp @@Cycl1
@@End1:
	pop es di si bp
	ret
ENDP

END
