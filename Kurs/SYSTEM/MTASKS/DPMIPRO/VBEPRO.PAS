(***************************************************************************
 *
 *                      VBEPro v1.0 (revision 0.01)
 *                   Copyright (C) 1996-98 by Vadim Bodrov
 *
 *               32-bit (i80386) VESA VBE 1.2/2.0/3.0 library
 *                 for Borland Pascal 16-bit protected mode
 * 256 colored, HiColor (15,16 bpp) and TrueColor (24,32 bpp) modes supported
 *
 *                 !LINEAR FLAT FRAMEBUFFER (LFB) SUPPORTED!
 *
 ***************************************************************************)

 {$g+,n-,d-,l-,b-,r-,o-,f+,s-,a+,e-,p-,q-,t+,v-,x+,i-}

 {$IFNDEF DPMI}
  THIS PROGRAM MUST BE COMPILED FOR DOS PROTECTED MODE (DPMI16) ONLY!!!
 {$ENDIF}

 unit VBEPro;

 interface

 {$I VBE.inc}

 function  GetVBEInfo(var VBEInfo: TVBEInfo): Boolean;
 function  InitVBE: Boolean;
 function  SetVBEMode(Mode: Word): Boolean;
 procedure SetTextMode;

 function  RGBColor(R,G,B: Byte): LongInt;
 procedure PutPix256Lin(X,Y: Word; Color: LongInt);
 procedure PutPix32KLin(X,Y: Word; Color: LongInt);
 procedure PutPix16MLin(X,Y: Word; Color: LongInt);
 procedure PutPix4GLin(X,Y: Word; Color: LongInt);

 procedure ClearPage256Lin(Color: LongInt);
 procedure ClearPage32kLin(Color: LongInt);
 procedure ClearPage16mLin(Color: LongInt);
 procedure ClearPage4gLin(Color: LongInt);

 procedure Line256Lin(X1,Y1,X2,Y2: Word; Color: LongInt);
 procedure Line32kLin(X1,Y1,X2,Y2: Word; Color: LongInt);
 procedure Line16mLin(X1,Y1,X2,Y2: Word; Color: LongInt);
 procedure Line4gLin(X1,Y1,X2,Y2: Word; Color: LongInt);

 implementation

 uses DPMIPro,i80386,WinAPI;

 var
  VBEExit: Pointer;
 var
  SetStartAddrWR: Pointer;
  SetStartAddrNW: Pointer;
 var
  PageSize:      LongInt;
 var
  BankTable:     array [0..255] of Word;
 var
  UseLFB:        Boolean;
  LFBMapped:     Boolean;
 var
   ScrX,ScrY:    Word;

 procedure FarNop; assembler;
      asm
 end;

 procedure NearNop; near; assembler;
      asm
 end;

 function  RGBColor(R,G,B: Byte): LongInt; assembler;
      asm
        db      $66
        xor     ax,ax
        db      $66
        xor     bx,bx
        db      $66
        xor     dx,dx
        mov     al,[R]
        and     al,[vpRedMask]
        mov     cl,[vpRedPos]
        db      $66
        shl     ax,cl
        mov     bl,[G]
        and     bl,[vpGreenMask]
        mov     cl,[vpGreenPos]
        db      $66
        shl     bx,cl
        mov     dl,[B]
        and     dl,[vpBlueMask]
        mov     cl,[vpBlusPos]
        db      $66
        shl     dx,cl
        db      $66
        or      ax,bx
        db      $66
        or      ax,dx
        db      $66
        push    ax
        pop     ax
        pop     dx
 end;

 {
 ----------------------------------------------------------------------------
  SetBankA  - Установка банка A через прерывание 13h BIOS
 ----------------------------------------------------------------------------
  Вход:                 AX         -     номер банка без учета смещения
  Выход:                нет
  Регистры:             все сохраняются
  Примечание:           в переменную mgCurBank заносится адрес текущего банка
 ----------------------------------------------------------------------------
 }
 procedure SetBankA; assembler;
      asm
        pusha
        and     ax,$00FF
        mov     [vpCurBank],ax
        mov     bx,offset BankTable
        add     ax,ax
        add     bx,ax
        mov     dx,ds:[bx]
        mov     ax,$4F05
        xor     bx,bx
        int     $10
        popa
 end;

 {
 ----------------------------------------------------------------------------
  SetBankAB - Установка банков A и B через прерывание 13h BIOS
 ----------------------------------------------------------------------------
  Вход:                 AX         -     номер банка без учета смещения
  Выход:                нет
  Регистры:             все сохраняются
  Примечание:           в переменную mgCurBank заносится адрес текущего банка
 ----------------------------------------------------------------------------
 }
 procedure SetBankAB; assembler;
      asm
        pusha
        and     ax,$00FF
        mov     [vpCurBank],ax
        mov     bx,offset BankTable
        add     ax,ax
        add     bx,ax
        mov     dx,ds:[bx]
        mov     ax,$4F05
        xor     bx,bx
        push    dx
        int     $10
        pop     dx
        mov     bx,1
        int     $10
        popa
 end;

 {
 ----------------------------------------------------------------------------
  VBEFunc07 - Установка Screen Start для VESA 1.2/2.0, WaitForRetrace=FALSE
 ----------------------------------------------------------------------------
  Вход:                 CX     -       X
                        DX     -       Y
  Выход:                AX     -       return VBE ststus
  Регистры:             BX
 ----------------------------------------------------------------------------
 }
 procedure VBEFunc07NW; assembler;
      asm
        mov     ax,$4F07
        xor     bx,bx
        int     $10
 end;

 {
 ----------------------------------------------------------------------------
  VBEFunc07 - Установка Screen Start для VESA 1.2, WaitForRetrace=TRUE
 ----------------------------------------------------------------------------
  Вход:                 CX     -       X
                        DX     -       Y
  Выход:                AX     -       return VBE ststus
  Регистры:             BX
 ----------------------------------------------------------------------------
 }
 procedure VBEFunc07W1; assembler;
      asm
        push    dx
        mov     dx,STAT_ADDR
@WaitVS:
        in      al,dx
        test    al,$08
        jz      @WaitVS
        pop     dx

        mov     ax,$4F07
        xor     bx,bx
        int     $10

        push    ax
        mov     dx,STAT_ADDR
@WaitDE:
        in      al,dx
        test    al,$01
        jnz     @WaitDE
        pop     ax
 end;

 {
 ----------------------------------------------------------------------------
  VBEFunc07 - Установка Screen Start для VESA 2.0, WaitForRetrace=TRUE
 ----------------------------------------------------------------------------
  Вход:                 CX     -       X
                        DX     -       Y
  Выход:                AX     -       return VBE ststus
  Регистры:             BX
 ----------------------------------------------------------------------------
 }
 procedure VBEFunc07W2; assembler;
      asm
        mov     ax,$4F07
        mov     bx,$80
        int     $10
 end;

 procedure PutPix256Lin(X,Y: Word; Color: LongInt); assembler;
      asm
        mov     es,[LFBSEG]
        db      $66,$0F,$B7,$46,$0A   {<- movzx  eax,word ptr [bp+0A]:=Y}
        db      $66,$0F,$B7,$7E,$0C   {<- movzx  edi,word ptr [bp+0C]:=X}
        db      $66
        mov     bx,word ptr [vpBytesPerLine]
        db      $66
        mul     bx
        db      $66
        add     di,ax
        db      $66
        add     di,word ptr [vpPixOffset]
        mov     al,byte ptr [Color]
        db      $26,$67,$88,$07       {<- mov  es:[edi],al}
 end;

 procedure PutPix32KLin(X,Y: Word; Color: LongInt); assembler;
      asm
        mov     es,[LFBSEG]
        db      $66,$0F,$B7,$46,$0A   {<- movzx  eax,word ptr [bp+0A]:=Y}
        db      $66,$0F,$B7,$7E,$0C   {<- movzx  edi,word ptr [bp+0C]:=X}
        shl     di,1
        db      $66
        mov     bx,word ptr [vpBytesPerLine]
        db      $66
        mul     bx
        db      $66
        add     di,ax
        db      $66
        add     di,word ptr [vpPixOffset]
        mov     ax,word ptr [Color]
        db      $26,$67,$89,$07       {<- mov  es:[edi],ax}
 end;

 procedure PutPix16MLin(X,Y: Word; Color: LongInt); assembler;
      asm
        mov     es,[LFBSEG]
        db      $66,$0F,$B7,$46,$0A   {<- movzx  eax,word ptr [bp+0A]:=Y}
        db      $66,$0F,$B7,$7E,$0C   {<- movzx  edi,word ptr [bp+0C]:=X}
        mov     bx,di
        shl     di,1
        add     di,bx
        db      $66
        mov     bx,word ptr [vpBytesPerLine]
        db      $66
        mul     bx
        db      $66
        add     di,ax
        db      $66
        add     di,word ptr [vpPixOffset]
        db      $66
        mov     ax,word ptr [Color]
        db      $26,$67,$89,$07       {<- mov  es:[edi],ax}
        db      $66
        shr     ax,16
        db      $26,$67,$88,$47,$02   {<- mov  es:[edi+02],al}
 end;

 procedure PutPix4GLin(X,Y: Word; Color: LongInt); assembler;
      asm
        mov     es,[LFBSEG]
        db      $66,$0F,$B7,$46,$0A   {<- movzx  eax,word ptr [bp+0A]:=Y}
        db      $66,$0F,$B7,$7E,$0C   {<- movzx  edi,word ptr [bp+0C]:=X}
        shl     di,2
        db      $66
        mov     bx,word ptr [vpBytesPerLine]
        db      $66
        mul     bx
        db      $66
        add     di,ax
        db      $66
        add     di,word ptr [vpPixOffset]
        db      $66
        mov     ax,word ptr [Color]
        db      $66,$26,$67,$89,$07       {<- mov  es:[edi],eax}
 end;

 procedure ClearLinear; near; assembler;
      asm
        db      $66
        push    ax
        db      $66
        xor     ax,ax
        db      $66
        xor     bx,bx
        mov     ax,[ScrY]
        db      $66
        mov     bx,word ptr [vpBytesPerLine]
        db      $66
        mul     bx
        db      $66
        mov     cx,ax
        db      $66
        mov     di,word ptr [vpPixOffset]
        cld
        db      $66
        pop     ax
        db      $66
        shr     cx,2
        mov     es,[LFBSEG]
        db      $66,$67
        rep     stosw
 end;

 procedure ClearPage256Lin(Color: LongInt); assembler;
      asm
        mov     al,byte ptr [Color]
        mov     ah,al
        mov     bx,ax
        db      $66
        shl     ax,16
        mov     ax,bx
        call    near ptr ClearLinear
 end;

 procedure ClearPage32kLin(Color: LongInt); assembler;
      asm
        mov     ax,word ptr [Color]
        mov     bx,ax
        db      $66
        shl     ax,16
        mov     ax,bx
        call    near ptr ClearLinear
 end;

 procedure ClearPage16mLin(Color: LongInt); assembler;
      asm
        db      $66
        mov     ax,word ptr [Color]
        db      $66
        or      ax,ax
        jnz     @SlowClear
        call    ClearLinear
        leave
        retf    4
@SlowClear:
        mov     es,[LFBSEG]
        db      $66
        mov     di,word ptr [vpPixOffset]
        db      $66
        xor     bx,bx
        mov     bx,[ScrX]
        db      $66
        xor     si,si
        mov     si,[ScrY]
        mov     ax,word ptr [Color]
        mov     dh,byte ptr [Color+2]
        db      $66
        mov     bp,bx
        db      $66
        shl     bp,1
        db      $66
        add     bp,bx
        db      $66
        sub     bp,word ptr [vpBytesPerLine]
        db      $66
        neg     bp
@NextScanLine:
        db      $66
        mov     cx,bx
@LoopSolid:
        db      $67
        mov     es:[di],al
        db      $67
        mov     es:[di+1],ah
        db      $66
        mov     es:[di+2],dh
        db      $66
        add     di,3
        dw      $0000
        loop    @LoopSolid
@AfterPlot:
        db      $66
        add     di,bp
        db      $66
        dec     si
        jnz     @NextScanLine
 end;

 procedure ClearPage4gLin(Color: LongInt); assembler;
      asm
        db      $66
        mov     ax,word ptr [Color]
        call    near ptr ClearLinear
 end;

 procedure Line256Lin(X1,Y1,X2,Y2: Word; Color: LongInt); assembler;
 var  LoSlope: Word; VertInc,EIncr,NEIncr: LongInt;
      asm
        mov     si,word ptr [vpBytesPerLine]
        mov     ax,[X2]
        sub     ax,[X1]
        jns     @X2Greater
        neg     ax
        mov     bx,[X2]
        xchg    bx,[X1]
        mov     [x2],bx
        mov     bx,[Y2]
        xchg    bx,[Y1]
        mov     [Y2],bx
@X2Greater:
        mov     bx,[Y2]
        sub     bx,[Y1]
        jns     @Y2Greater
        neg     bx
        db      $66
        neg     si
@Y2Greater:
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        db      $66
        mov     word ptr [VertInc],si
        mov     [LoSlope],1
        db      $66
        cmp     bx,ax
        jle     @LoSlope
        mov     [LoSlope],0
        db      $66
        xchg    bx,ax
@LoSlope:
        db      $66
        shl     bx,1
        db      $66
        mov     word ptr [EIncr],bx
        db      $66
        sub     bx,ax
        db      $66
        mov     di,bx
        db      $66
        sub     bx,ax
        db      $66
        mov     word ptr [NEIncr],bx
        db      $66
        push    ax
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        mov     ax,[Y1]
        mov     bx,[X1]
        db      $66
        mov     cx,word ptr [vpBytesPerLine]
        db      $66
        mul     cx
        db      $66
        add     bx,ax
        mov     es,[LFBSEG]
        db      $66
        pop     cx
        db      $66
        inc     cx
        test    [LoSlope],1
        jz      @HiSlopeLine
@LoSlopeLine:
        mov     al,byte ptr [Color]
@LoopLo:
        db      $26,$67,$88,$03  {<- mov es:[ebx],al}
        db      $66
        inc     bx
        db      $66
        or      di,di
        jns     @LoPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopLo
        jmp     @Exit
@LoPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        add     bx,word ptr [VertInc]
        loop    @LoopLo
        jmp     @Exit
@HiSlopeLine:
        mov     al,byte ptr [Color]
@LoopHi:
        db      $26,$67,$88,$03  {<- mov es:[ebx],al}
        db      $66
        add     bx,word ptr [VertInc]
        db      $66
        or      di,di
        jns     @HiPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopHi
        jmp     @Exit
@HiPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        inc     bx
        loop    @LoopHi
@Exit:
 end;

 procedure Line32kLin(X1,Y1,X2,Y2: Word; Color: LongInt); assembler;
 var  LoSlope: Word; VertInc,EIncr,NEIncr: LongInt;
      asm
        cld
        db      $66
        mov     si,word ptr [vpBytesPerLine]
        mov     ax,[X2]
        sub     ax,[X1]
        jns     @X2Greater
        neg     ax
        mov     bx,[X2]
        xchg    bx,[X1]
        mov     [X2],bx
        mov     bx,[Y2]
        xchg    bx,[Y1]
        mov     [Y2],bx
@X2Greater:
        mov     bx,[Y2]
        sub     bx,[Y1]
        jns     @Y2Greater
        neg     bx
        db      $66
        neg     si
@Y2Greater:
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        db      $66
        mov     word ptr [VertInc],si
        mov     [LoSlope],1
        db      $66
        cmp     bx,ax
        jle     @LoSlope
        mov     [LoSlope],0
        db      $66
        xchg    bx,ax
@LoSlope:
        db      $66
        shl     bx,1
        db      $66
        mov     word ptr [EIncr],bx
        db      $66
        sub     bx,ax
        db      $66
        mov     di,bx
        db      $66
        sub     bx,ax
        db      $66
        mov     word ptr [NEIncr],bx
        db      $66
        push    ax
        mov     ax,[Y1]
        mov     bx,[X1]
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        mov     ax,[Y1]
        mov     bx,[X1]
        shl     bx,1
        db      $66
        mov     cx,word ptr [vpBytesPerLine]
        db      $66
        mul     cx
        db      $66
        add     bx,ax
        mov     es,[LFBSEG]
        db      $66
        pop     cx
        db      $66
        inc     cx
        test    [LoSlope],1
        jz      @HiSlopeLine
@LoSlopeLine:
        mov     ax,word ptr [Color]
@LoopLo:
        db      $26,$67,$89,$03  {<- mov es:[ebx],ax}
        db      $66
        inc     bx
        db      $66
        inc     bx
        db      $66
        or      di,di
        jns     @LoPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopLo
        jmp     @Exit
@LoPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        add     bx,word ptr [VertInc]
        loop    @LoopLo
        jmp     @Exit
@HiSlopeLine:
        mov     ax,word ptr [Color]
@LoopHi:
        db      $26,$67,$89,$03  {<- mov es:[ebx],ax}
        db      $66
        add     bx,word ptr [VertInc]
        db      $66
        or      di,di
        jns     @HiPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopHi
        jmp     @Exit
@HiPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        inc     bx
        db      $66
        inc     bx
        loop    @LoopHi
@Exit:
 end;

 procedure Line16mLin(X1,Y1,X2,Y2: Word; Color: LongInt); assembler;
 var  LoSlope: Word; VertInc,EIncr,NEIncr: LongInt;
      asm
        cld
        db      $66
        mov     si,word ptr [vpBytesPerLine]
        mov     ax,[X2]
        sub     ax,[X1]
        jns     @X2Greater
        neg     ax
        mov     bx,[X2]
        xchg    bx,[X1]
        mov     [X2],bx
        mov     bx,[Y2]
        xchg    bx,[Y1]
        mov     [Y2],bx
@X2Greater:
        mov     bx,[Y2]
        sub     bx,[Y1]
        jns     @Y2Greater
        neg     bx
        db      $66
        neg     si
@Y2Greater:
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        db      $66
        mov     word ptr [VertInc],si
        mov     [LoSlope],1
        db      $66
        cmp     bx,ax
        jle     @LoSlope
        mov     [LoSlope],0
        xchg    bx,ax
@LoSlope:
        db      $66
        shl     bx,1
        db      $66
        mov     word ptr [EIncr],bx
        db      $66
        sub     bx,ax
        db      $66
        mov     di,bx
        db      $66
        sub     bx,ax
        mov     word ptr [NEIncr],bx
        db      $66
        push    ax
        mov     ax,[Y1]
        mov     bx,[X1]
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        mov     ax,[Y1]
        mov     bx,[X1]
        shl     bx,1
        add     bx,[X1]
        db      $66
        mov     cx,word ptr [vpBytesPerLine]
        db      $66
        mul     cx
        db      $66
        add     bx,ax
        mov     es,[LFBSEG]
        db      $66
        pop     cx
        db      $66
        inc     cx
        test    [LoSlope],1
        jz      @HiSlopeLine
@LoSlopeLine:
        mov     ax,word ptr [Color]
        mov     dh,byte ptr [Color+2]
@LoopLo:
        db      $26,$67,$88,$03     {<- mov es:[ebx],al}
        db      $26,$67,$88,$63,$01 {<- mov es:[ebx+1],ah}
        db      $26,$67,$88,$73,$02 {<- mov es:[ebx+2],dh}
        db      $66
        add     bx,$0003
        dw      $0000
@@DonePixelLo:
        db      $66
        or      di,di
        jns     @LoPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopLo
        jmp     @Exit
@LoPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        add     bx,word ptr [VertInc]
        loop    @LoopLo
        jmp     @Exit
@HiSlopeLine:
        mov     ax,word ptr [Color]
        mov     dh,byte ptr [Color+2]
@LoopHi:
        db      $26,$67,$88,$03     {<- mov es:[ebx],al}
        db      $26,$67,$88,$63,$01 {<- mov es:[ebx+1],ah}
        db      $26,$67,$88,$73,$02 {<- mov es:[ebx+2],dh}
@DonePixelHi:
        db      $66
        add     bx,word ptr [VertInc]
        db      $66
        or      di,di
        jns     @HiPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopHi
        jmp     @Exit
@HiPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        inc     bx
        db      $66
        inc     bx
        db      $66
        inc     bx
        loop    @LoopHi
@Exit:
 end;

 procedure Line4gLin(X1,Y1,X2,Y2: Word; Color: LongInt); assembler;
 var  LoSlope: Word; VertInc,EIncr,NEIncr: LongInt;
      asm
        cld
        db      $66
        mov     si,word ptr [vpBytesPerLine]
        mov     ax,[X2]
        sub     ax,[X1]
        jns     @X2Greater
        neg     ax
        mov     bx,[X2]
        xchg    bx,[X1]
        mov     [X2],bx
        mov     bx,[Y2]
        xchg    bx,[Y1]
        mov     [Y2],bx
@X2Greater:
        mov     bx,[Y2]
        sub     bx,[Y1]
        jns     @Y2Greater
        neg     bx
        db      $66
        neg     si
@Y2Greater:
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        db      $66
        mov     word ptr [VertInc],si
        mov     [LoSlope],1
        db      $66
        cmp     bx,ax
        jle     @LoSlope
        mov     [LoSlope],0
        db      $66
        xchg    bx,ax
@LoSlope:
        db      $66
        shl     bx,1
        db      $66
        mov     word ptr [EIncr],bx
        db      $66
        sub     bx,ax
        db      $66
        mov     di,bx
        db      $66
        sub     bx,ax
        db      $66
        mov     word ptr [NEIncr],bx
        db      $66
        push    ax
        mov     ax,[Y1]
        mov     bx,[X1]
        db      $66,$0F,$B7,$DB  {<- mozx ebx,bx}
        db      $66,$0F,$B7,$C0  {<- mozx eax,ax}
        mov     ax,[Y1]
        mov     bx,[X1]
        shl     bx,2
        db      $66
        mov     cx,word ptr [vpBytesPerLine]
        db      $66
        mul     cx
        db      $66
        add     bx,ax
        mov     es,[LFBSEG]
        db      $66
        pop     cx
        db      $66
        inc     cx
        test    [LoSlope],1
        jz      @HiSlopeLine
@LoSlopeLine:
        mov     ax,word ptr [Color]
@LoopLo:
        db      $26,$67,$89,$03  {<- mov es:[ebx],ax}
        db      $66
        add     bx,$0004
{        dw      $0000}
        db      $66
        or      di,di
        jns     @LoPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopLo
        jmp     @Exit
@LoPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        add     bx,word ptr [VertInc]
        loop    @LoopLo
        jmp     @Exit
@HiSlopeLine:
        mov     ax,word ptr [Color]
@LoopHi:
        db      $26,$67,$89,$03  {<- mov es:[ebx],ax}
        db      $66
        add     bx,word ptr [VertInc]
        db      $66
        or      di,di
        jns     @HiPosDi
        db      $66
        add     di,word ptr [EIncr]
        loop    @LoopHi
        jmp     @Exit
@HiPosDi:
        db      $66
        add     di,word ptr [NEIncr]
        db      $66
        inc     bx
        db      $66
        inc     bx
        loop    @LoopHi
@Exit:
 end;

 procedure SVGAPutHTextel; near; assembler;
      asm
        pusha
        mov     ax,word ptr [vpBytesPerLine]
        mul     dx
        add     bx,ax
        adc     dx,[vpBankOffset]
        add     bx,word ptr [vpPixOffset]
        adc     dx,0
        cmp     dx,[vpCurBank]
        jz      @Pass
        mov     ax,dx
        call    dword ptr vpBankAddr
@Pass:  cld
        mov     es,[VideoSEG]
        mov     di,bx
        add     bx,cx
        jnc     @Novf
        push    cx
        mov     cx,di
        not     cx
        inc     cx
        mov     bx,cx
        push    cx
        and     cx,3
        db      $64
        rep     movsb
        pop     cx
        shr     cx,2
        db      $66
        db      $64
        rep     movsw
        pop     cx
        sub     cx,bx
        mov     ax,word ptr [vpCurBank]
        inc     ax
        call    dword ptr vpBankAddr
        push    cx
        and     cx,3
        db      $64
        rep     movsb
        pop     cx
        shr     cx,2
        db      $66
        db      $64
        rep     movsw
        popa
        ret
@Novf:  push    cx
        and     cx,3
        db      $64
        rep     movsb
        pop     cx
        shr     cx,2
        db      $64
        db      $66
        rep     movsw
@Quit:  popa
 end;

 procedure MapLFB(RealAddress: LongInt);
 var SRights: Word;
 begin
  if not LFBMapped then begin
   VideoLinearAddress:=MapPhysicalToLinear(RealAddress,$400000);
   LFBSEG:=CreateSelector32(VideoLinearAddress,$400000);
   SRights:=GetSegmentAccessRights(LFBSEG);
   SRights:=(SRights and $FF70) or $0093;
   SetSegmentAccessRights(LFBSEG,SRights);
   Video32:=CreateData32Alias(LFBSEG);
   LFBMapped:=true;
  end;
  VideoSEG:=LFBSEG;
 end;

 function  GetVBEInfo(var VBEInfo: TVBEInfo): Boolean;
 var
  VBEStatus: Word;
  Reg:       TRealRegs;
  RealPtr:   Pointer;
 begin
  FillChar(Reg,SizeOf(Reg),0);
  Reg.ES:=GlobalDOSAlloc16(RealPtr,256);
  Reg.SI:=$01;
  Reg.AX:=$4F00;
  PutLong16(RealPtr,$32454256); {< VBE2}
  RealModeInt($10,Reg);
  VBEStatus:=Reg.AX;
  if VBEStatus<>VBEStatusOK then GetVBEInfo:=false
  else begin
   Move(RealPtr^,VBEInfo,256);
   GetVBEInfo:=true;
  end;
   GlobalDOSFree(SEG(RealPtr^));
 end;

 function GetVBEModeInfo(Mode: Word; var VBEModeInfo: TVBEModeInfo): Boolean;
 var
  Reg:   TRealRegs;
  RealPtr: Pointer;
 begin
  ClearRegs(Reg);
  Reg.ES:=GlobalDOSAlloc16(RealPtr,256);
  Reg.AX:=$4F01;
  Reg.CX:=Mode;
  RealModeInt($10,Reg);
  if (Reg.AX<>VBEStatusOK) then GetVBEModeInfo:=false
  else begin
   Move(RealPtr^,VBEModeInfo,256);
   GetVBEModeInfo:=true;
  end;
  GlobalDOSFree(SEG(RealPtr^));
  if (VBEModeInfo.BitsPerPixel=16) and (VBEModeInfo.RsvdMaskSize=1) then
     VBEModeInfo.BitsPerPixel:=15;
 end;

 procedure CreateModeTable(VideoModePtr: Pointer); near;
 var VMode,i: Word;
     VBEModeInfo: TVBEModeInfo;
     ModesTmp: array [0..MaxVbeModes] of Word;
     Addr: Pointer;
 begin
  i:=0;
  Addr := VideoModePtr;
  repeat
   if Word((Pointer(Addr)^))>=$100 then ModesTmp[i]:=GetWord16(Addr);
   IncPointer16(Addr,2);
   Inc(i);
  until (i>MaxVbeModes) or (ModesTmp[i]=$FFFF);
  ModesTmp[i]:=$FFFF;
  i:=0;
  vpVBEModes := 0;
  repeat
   VMode:=ModesTmp[i];
   inc(i);
   if VMode>$FF then begin
    GetVBEModeInfo(VMode,VBEModeInfo);
    if (VBEModeInfo.BitsPerPixel>0) and (VBEModeInfo.XResolution>0) and
       (VBEModeInfo.YResolution>0) and
       ((VBEModeInfo.ModeAttributes and $18)=$18) then begin
     vpVBEModesList[i].VideoMode:=VMode;
     vpVBEModesList[i].BitsPerPix:=VBEModeInfo.BitsPerPixel;
     vpVBEModesList[i].LFB:=(VBEModeInfo.ModeAttributes and 128)=128;
     vpVBEModesList[i].XRes:=VBEModeInfo.XResolution;
     vpVBEModesList[i].YRes:=VBEModeInfo.YResolution;
     inc(vpVBEModes);
    end;
   end;
  until VMode=$FFFF;
 end;

 function  InitVBE: Boolean;
 var VBEInfo: TVBEInfo;
     I: Byte;
     PMSeg,PMOfs:  Word;
 begin
  if (not GetVBEInfo(VBEInfo)) or (VBEInfo.VBEVersion<258) or
  (VBEInfo.VBESignature<>$41534556) then begin
   InitVBE:=false; exit;
  end;
  InitVBE:=true;
  vpVBEMem:=VBEInfo.TotalMemory shl 6;
  vpVBEVersion:=VBEInfo.VBEVersion;
  vpCapabilities:=VBEInfo.Capabilities;
  vpOemString:='';
  PMSEG:=HiWord(LongInt(VBEInfo.OEMStringPtr));
  PMOFS:=LongInt(VBEInfo.OEMStringPtr);
  PMSEG:=CreateSelector16(LongAdd(LongShl(PMSEG,4),PMOFS),81);
  I:=0;
  repeat
   vpOemString:=vpOemString+chr(Byte(ptr(PMSEG,I)^));
   inc(I);
  until (I=80) or (Byte(ptr(PMSEG,I)^)=0);
  FreeSelector(PMSEG);
  PMSEG:=HiWord(LongInt(VBEInfo.VideoModePtr));
  PMOFS:=LongInt(VBEInfo.VideoModePtr);
  PMSEG:=CreateSelector16(LongAdd(LongShl(PMSEG,4),PMOFS),256);
  CreateModeTable(ptr(PMSEG,0));
  FreeSelector(PMSEG);
  VideoSEG:=SEGA000;
 end;

 {
 ----------------------------------------------------------------------------
  VBESetMode - Sets VBE mode
 ----------------------------------------------------------------------------
  Entry:                BX     -       desired VBE mode
  Exit:                 AX     -       return VBE ststus
  Registers:            None
 ----------------------------------------------------------------------------
 }
 function VBESetMode(Mode: Word): Boolean; near; assembler;
      asm
        mov     ax,$4F02
        mov     bx,[Mode]
        int     $10
        cmp     ax,VBEStatusOk
        jz      @Ok
        xor     ax,ax
        leave
        retn    2
@Ok:    mov     ax,1
 end;

 {
 ----------------------------------------------------------------------------
  PrepareBankTable
 ----------------------------------------------------------------------------
 }
 procedure PrepareBankTable; near; assembler;
      asm
        mov     di,offset BankTable
        xor     bx,bx
@BankLoop:
        mov     ax,bx
        mov     cx,64
        mul     cx
        mov     cx,[vpWinGran]
        jcxz    @be
        div     cx
@be:    mov     [di],ax
        inc     di
        inc     di
        inc     bx
        cmp     bx,$FF
        jb      @BankLoop
        mov     ax,SEGA000
        mov     [VideoSEG],ax
 end;

 function SetVBEMode(Mode: Word): Boolean;
 var ModeInfo: TVBEModeInfo;
 begin
  if not vpVBEVersion<102 then begin
   SetVBEMode:=false; exit;
  end;
  if (not GetVBEModeInfo(Mode,ModeInfo)) or (Mode<$100) then begin
   SetVBEMode:=false; exit;
  end;
  if not VBESetMode(Mode) then begin
   SetVBEMode:=false; exit;
  end;
  if (ModeInfo.BitsPerPixel<=4) or (ModeInfo.XResolution=0) or
     (ModeInfo.BytesPerScanLine=0) or (ModeInfo.YResolution=0) or
     ((ModeInfo.ModeAttributes and $1B)<>$1B) then begin
     SetVBEMode:=false; exit;
  end;
  Writeln(ModeInfo.PhisBasePtr);
  UseLFB:=((Mode and $4000)=$4000) and
          (ModeInfo.PhisBasePtr<>0);
  vpWinGran:=ModeInfo.WinGranularity;
  vpBitsPerPixel:=ModeInfo.BitsPerPixel;
  vpBytesPerLine:=ModeInfo.BytesPerScanLine;
  vpXRes:=ModeInfo.XResolution;
  vpYRes:=ModeInfo.YResolution;
  case vpBitsPerPixel of
   4 : begin
        vpBytesPerPixel:=0;
        vpMaxColor:=15;
       end;
   8 : begin
        vpBytesPerPixel:=1;
        vpMaxColor:=255;
       end;
   15: begin
        vpBytesPerPixel:=2;
        vpMaxColor:=32767;
       end;
   16: begin
        vpBytesPerPixel:=2;
        vpMaxColor:=65535;
       end;
   24: begin
        vpBytesPerPixel:=3;
        vpMaxColor:=16777215;
       end;
   32: begin
        vpBytesPerPixel:=4;
        vpMaxColor:=16777215;
       end;
  end;
  if vpVBEVersion>=$200 then begin
   SetStartAddrWR:=@VBEFunc07W2;
   SetStartAddrNW:=@VBEFunc07NW;
  end else begin
   SetStartAddrWR:=@VBEFunc07W1;
   SetStartAddrNW:=@VBEFunc07NW;
  end;
  vpWorkMem:=LongShl(vpVBEMem,10);
  vpMaxY:=LongDiv(vpWorkMem,vpBytesPerLine);
  vpMaxPages:=LongDiv(vpWorkMem,LongMul(vpBytesPerLine,vpYRes));
  PageSize:=LongMul(vpBytesPerLine,vpYRes);
  vpRedAjast:=8-ModeInfo.RedMaskSize;
  vpRedMask:=$FF shr vpRedAjast;
  vpRedPos:=ModeInfo.RedFieldPosition;
  vpGreenAjast:=8-ModeInfo.GreenMaskSize;
  vpGreenMask:=$FF shr vpGreenAjast;
  vpGreenPos:=ModeInfo.GreenFieldPosition;
  vpBlusAjast:=8-ModeInfo.BlueMaskSize;
  vpBlueMask:=$FF shr vpBlusAjast;
  vpBlusPos:=ModeInfo.BlueFieldPosition;
  vpCurBank:=$FFFF;
  if (ModeInfo.WinAAttributes and $07)<>$07 then begin
   vpBankAddr:=@SetBankAB;
  end else begin
   vpBankAddr:=@SetBankA;
  end;
  if UseLFB then MapLFB(ModeInfo.PhisBasePtr) else PrepareBankTable;
  SetVBEMode:=true;
  ScrX:=vpXRes;
  ScrY:=vpYRes;
 end;

 procedure SetTextMode; assembler;
      asm
        mov     ax,3
        int     $10
 end;

 procedure VBEProExit;
 begin
  ExitProc:=VBEExit;
  if LFBMapped then begin
   FreePhysicalMap(VideoLinearAddress);
  end;
 end;

 begin
  VBEExit:=ExitProc;
  ExitProc:=@VBEProExit;
 end.