{ VESA code}
{$G+,S-}
var
    VesaBankShift, CurrentBank: word;
    VesaBankProc: procedure;            { far pointer to a procedure }
 
function InitVesa: boolean; assembler;
var
    VesaBuffer: array [0..255] of byte;
asm
        push    ss
        pop     es
        mov     ax,4F00h
        lea     di,[VesaBuffer]
        int     10h
        cmp     ax,004Fh                { is vesa supported? }
        jne     @bad
        mov     ax,4F01h
        mov     cx,101h
        int     10h
        cmp     ax,004Fh                { is 640x480x256 supported? }
        jne     @bad
        mov     ax,es:[di+4]
        mov     bx,es:[di+12]
        mov     dx,es:[di+14]
        xor     cx,cx
    @FindVesaBankShift:
        cmp     ax,64
        jae     @FoundVesaBankShift
        add     ax,ax
        inc     cx
        jmp     @FindVesaBankShift
    @FoundVesaBankShift:
        mov     [VesaBankShift],cx
        mov     [offset VesaBankProc+0],bx
        mov     [offset VesaBankProc+2],dx
        mov     al,TRUE
        jmp     @exit
    @bad:
        mov     al,FALSE
    @exit:
end;
 
procedure InitGraph; assembler;         { sets 640x480x256 mode }
asm
        mov     ax,4F02h
        mov     bx,101h
        int     10h
        xor     bx,bx
        xor     dx,dx
        mov     [CurrentBank],bx
        call    [VesaBankProc]
end;
 
procedure SetBank(num: word); assembler;
asm
        mov     dx,[num]
        mov     cx,[VesaBankShift]
        mov     [CurrentBank],dx
        xor     bx,bx
        shl     dx,cl
        call    [VesaBankProc]
end;
 
procedure CloseGraph; assembler;        { sets text mode }
asm
        mov     ax,3
        int     10h
end;
 
 
procedure PutPixel(x,y: word; color: byte); assembler;
asm
        mov     ax,0A000h
        mov     es,ax
 
        mov     ax,640
        mov     di,[x]
        mul     [y]
        add     di,ax
        adc     dx,0
 
        cmp     dx,[CurrentBank]
        jz      @SameBank
        mov     cx,[VesaBankShift]  { set bank procedure inline }
        mov     [CurrentBank],dx
        xor     bx,bx
        shl     dx,cl
        call    [VesaBankProc]
    @SameBank:
        mov     al,[color]
        mov     es:[di],al
end;
 
procedure SlowPixel(x,y: word; color: byte); assembler;
asm
        mov     ah,0Ch
        mov     al,[color]
        mov     cx,[x]
        mov     dx,[y]
        xor     bx,bx
        int     10h
end;
 
var
    x,y: word;
    count: longint;
begin
    if not InitVesa then begin
        writeln('Can''t use VESA 640x480x256 mode');
        halt;
    end;
    InitGraph;
    for count := 0 to 65535 do begin
        x := random(640);
        y := random(480);
        PutPixel(x, y, random(256));
    end;
    CloseGraph;
end.