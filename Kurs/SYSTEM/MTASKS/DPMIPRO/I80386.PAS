unit i80386; {ADVANCED i80386 FUNCTIONS/i80386 and higher, Real Mode, DPMI16/}

{                  BEST GAME SDK FOR TURBO/BORLAND PASCAL
                  …ÕÕªÀ  À  À…ÕÕ  …ÕÕ À  À…ÕÕÕÕŒÕÕÀÕÕª ÀÕÀÕª
                  ∫ÕÕº∫  ∫  ∫»ÕÕª »ÕÕª∫  ∫»ÕÕª ∫  ÃÕÕº ∫ ∫ ∫
                      »Õº»ÕÕ  ÕÕº  ÕÕº»ÕÕπ ÕÕº »Õ »ÕÕÕÕº   ∫
                 ≥         …ÀÕÕÕª   ÕÕÕÕÕº                 ≥
                 √ ƒƒƒƒƒ : ∫∫   ∫∫ Õπ…ÕÕÀª …ÀÕÕÕª  .ƒƒƒƒƒƒƒ¥
                 | |  .    ÃŒÕÕÕºº  ∫∫     ∫∫   ∫∫    *    ≥
                 ≥-+-    .  º        º       ÕÕÕ º   .  +  ≥
                 ≥ |   .        version 2.0       .      :
                 ≥  BY VADIM BODROV, RUSSIA  (c) 1996,97   |                }

{$g+,n-,d-,l-,b-,r-,o+,f+,s-,a+,e-,p-,q-,t+,v-,x+,i-}

{$IFDEF WINDOWS}
 THIS PROGRAM CAN`T BE COMPILED FOR MS WINDOWS
{$ENDIF}

 interface

 const
  CPU086=  0;  { 8086/88 }
  CPU186=  1;  { 80186   }
  CPU286=  2;  { 80286   }
  CPU386=  3;  { 80386   }
  CPU486=  4;  { 80486   }
  CPU586=  5;  { Pentium }

 type TLong=Record
      Lo,Hi: Word;
 end;

 function LongAdd(A,B: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$5B/               { pop ebx }
           $66/$03/$C3/           { add eax,ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongSub(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$2B/$C3/           { sub eax,ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongMul(A,B: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$5B/               { pop ebx }
           $66/$F7/$E3/           { mul ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongIMul(A,B: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$5B/               { pop ebx }
           $66/$F7/$EB/           { imul ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongDiv(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$33/$D2/           { xor edx,edx }
           $66/$F7/$F3/           { div ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongIDiv(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$33/$D2/           { xor edx,edx }
           $66/$F7/$FB/           { idiv ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongShl(A: LongInt; B: Byte): LongInt;
  inline  ($59/                   { pop cx }
           $66/$58/               { pop eax }
           $66/$D3/$E0/           { shl eax,cl }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16 }

 function LongShr(A: LongInt; B: Byte): LongInt;
  inline  ($59/                   { pop cx }
           $66/$58/               { pop eax }
           $66/$D3/$E8/           { shr eax,cl }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16 }

 function LongAnd(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$23/$C3/           { and eax,ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongOr(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$0B/$C3/           { or  eax,ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongXor(A,B: LongInt): LongInt;
  inline  ($66/$5B/               { pop ebx }
           $66/$58/               { pop eax }
           $66/$33/$C3/           { xor eax,ebx }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongNot(A: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$F7/$D0/           { not eax }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongInc(A: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$40/               { inc eax }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function LongDec(A: LongInt): LongInt;
  inline  ($66/$58/               { pop eax }
           $66/$48/               { inc eax }
           $66/$8B/$D0/           { mov edx,eax }
           $66/$C1/$EA/$10);      { shr edx,16  }

 function SwapHL(Value: Word): Word;
  inline  ($58/                   { pop  ax }
           $86/$E0);              { xchg ah,al }

 function HiWord(A: LongInt): Word;
  inline  ($66/$58/               { pop eax }
           $66/$C1/$E8/$10);      { shr  eax,16       }

 procedure Cli;
  inline  ($FA);                  { cli }

 procedure Sti;
  inline  ($FB);                  { sti }

 function  WhatCPU: Byte;
 function  FarCall(Addr: Pointer): LongInt;

 implementation

 var N: Byte;

 function WhatCPU: Byte; assembler;
      asm
        push    bx
        push    bp
        mov     [N],CPU086
        push    sp
        pop     bx
        cmp     bx,sp
        je      @Check286
        mov     cl,32
        shl     bx,cl
        jz      @Done
        mov     [N],CPU186
        jz      @Done
@Check286:
        pushf
        mov     bx,sp
        popf
        inc     bx
        inc     bx
        cmp     bx,sp
        jnz     @Check386
        sub     sp,6
        mov     bp,sp
        db      $0F,$01,$46,$00  {<- sgdt [QWORD ptr bp] }
        add     sp,4
        pop     bx
        inc     bh
        jnz     @Check486
        mov     [N],CPU286
        jmp     @Done
@Check386:
        db      $66
        mov     dx,sp
        db      $66
        and     sp,not 3
        db      $66
        pushf
        db      $66
        pop     ax
        db      $66
        mov     cx,ax
        db      $66,$35,$00,$00,$04,$00 {<- xor eax,$40000}
        db      $66
        push    ax
        db      $66
        popf
        db      $66
        pushf
        db      $66
        pop     ax
        db      $66
        xor     ax,cx
        db      $66
        shr     ax,18
        db      $66
        and     ax,1
        db      $66
        push    cx
        db      $66
        popf
        db      $66
        mov     sp,dx
        mov     bx,ax
        test    bx,bx
        jnz     @Check486
        mov     [N],CPU386
        jnz     @Done
@Check486:
        db      $66
        pushf
        db      $66
        pop     ax
        db      $66
        mov     cx,ax
        db      $66,$0D,$00,$00,$20,$00 {<- or eax,$200000}
        db      $66
        push    ax
        db      $66
        popf
        db      $66
        pushf
        db      $66
        pop     ax
        db      $66
        xor     ax,cx
        mov     [N],CPU486
        jz      @Done
        db      $66
        xor     ax,ax
        inc     ax
        db      $0F,$A2
        and     ax,$0F00
        shr     ax,8
        cmp     al,5
        mov     [N],CPU486
        jl      @Done
        mov     [N],al                      {CPU586 or higher?..}
@Done:  pop     bp
        pop     bx
        mov     al,[N]
 end;

 function FarCall(Addr: Pointer): LongInt; assembler;
      asm
        call    dword ptr [Addr]
 end;

 end.