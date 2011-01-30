 {
 ****************************************************************************
 *                            DPMI PRO VERSION 1.1                          *
 *                                                                          *
 *              COPYRIGHT (C) 1995-98 BY VADIM BODROV, RUSSIA               *
 *                           falkoris@hotmail.com                           *
 *                                                                          *
 *            ULTIMATE DPMI ACCESS LIBRARY FOR BORLAND PASCAL 7             *
 *                      ULTIMATE DPMI 16/32 MANAGER UNIT                    *
 *                  GET ACCESS TO 16- AND 32-BIT SELECTORS                  *
 *                          WORKS UNDER DPMI16 ONLY                         *
 ****************************************************************************
 }

 {$G+,N-,D-,L-,B-,R-,O-,F+,S-,A+,E-,P-,Q-,T+,V-,X+,I-}

 {$IFNDEF DPMI}
 ============================================================================
                                  WARNING !!!
    THIS PROGRAM MUST BE COMPILED FOR DOS PROTECTED MODE (DPMI16) ONLY!!!
 ============================================================================
 {$ENDIF}

 UNIT DPMIPRO;

 INTERFACE

 uses WinAPI, i80386;

 type TLong = Record
  Lo,Hi: Word;
 end;

 type
 { 48-bit pointer }
  FarPointer = Real;

 const FarNil: FarPointer = 0;

 { Descriptor structure }
 type
  TDescriptor = record
   SegmentLimit: Word;
   BaseAddressL: Word;
   BaseAddressH: Byte;
   FlagsL:       Byte;
   FlagsH:       Byte;
   BaseAddressU: Byte;
 end;

 { Real Mode registers structure }
 type TRealRegs=Record
  case Word of
   0: (EDI,ESI,EBP,EXX,EBX,EDX,ECX,EAX: Longint;
       FLAGS,ES,DS,FS,GS,IP,CS,SP,SS: Word);
   1: (DI,DIH,SI,SIH,BP,BPH,XX,XXH: Word;
  case Word of
   0: (BX,BXH,DX,DXH,CX,CXH,AX,AXH: Word);
   1: (BL,BH,BLH,BHH,DL,DH,DLH,DHH,CL,CH,
       CLH,CHH,AL,AH,ALH,AHH: Byte));
 end;

 var
  BufferSeg:   Word;
  BufferPtr16: Pointer;
  BufferPtr32: FarPointer;

 {**************************** DPMI SERVER SECTION **************************}

 { Disable and return INTERRUPT STATE }
 function  GetDisableInterruptState: Boolean;

 { Enable and return INTERRUPT STATE }
 function  GetEnableInterruptState: Boolean;

 { Return INTERRUPT STATE }
 function  GetInterruptState: Boolean;

 { Gets Real Mode INTERRUPT VECTOR }
 function  GetRealInterruptVec (IntNo: Byte): Pointer;

 { Sets Real Mode INTERRUPT VECTOR }
 procedure SetRealInterruptVec (IntNo: Byte; Vector: Pointer);

 { Gets 16bit Protected Mode INTERRUPT VECTOR }
 function  GetDPMIInterruptVec16 (IntNo: Byte): Pointer;

 { Sets 16bit Protected Mode INTERRUPT VECTOR }
 procedure SetDPMIInterruptVec16 (IntNo: Byte; Vector: Pointer);

 { Enulate specified Real Mode Interrupt }
 function  RealModeInt (IntNum: Word; var Regs: TRealRegs): Word;

 { Gets CPU type from DPMI server }
 function  DPMIGetCPUType: Byte;

 { Gets version of DPMI server }
 function  GetDPMIVersion: Word;

 { Gets state of DPMI virtual memory }
 function  DPMIVirtualState: Boolean;

 { Allocates new descriptors }
 function  AllocateDescriptor (HowMany: Word): Word;

 { Frees a descriptor originally allocated by the AllocDescriptor }
 procedure FreeDescriptor (Selector: Word);

 { Gets descriptor }
 function  GetDescriptor (Selector: Word; var Descr: TDescriptor): Boolean;

 { Sets descriptor }
 function  SetDescriptor (Selector: Word; var Descr: TDescriptor): Boolean;

 { Creates Alias Descriptor to specified Selector }
 function  CreateAliasDescriptor (Selector: Word): Word;

 { Maps a Phisical address to Linear }
 function  MapPhysicalToLinear (Addr, Size: Longint): Longint;

 { Frees Linear Addres mapped with MapPhysicalToLinear function }
 function  FreePhysicalMap(LinearAddr: Longint): Boolean;

 { Creats 32bit selector with specified base and limit }
 function  CreateSelector32 (Base, Limit: Longint): Word;

 { Creats 16bit selector with specified base and limit }
 function  CreateSelector16 (Base: LongInt; Limit: Word): Word;

 { Sets the base address of a descriptor }
 procedure SetDescriptorBaseAddress (var Descr: TDescriptor; Base: Longint);

 { Sets the limit of a descriptor }
 procedure SetDescriptorLimit (var Descr: TDescriptor; Limit: LongInt);

 { Sets the base address of a selector (segment) }
 function  SetSegmentBaseAddress (Selector: Word; Base: Longint): Boolean;

 { Sets the limit of a selector (segment) }
 function  SetSegmentLimit (Selector: Word; Limit: Longint): Boolean;

 { Returns the access rights of a selector }
 function  GetSegmentAccessRights (Selector: Word): Word;

 { Sets the access rights of a selector }
 function  SetSegmentAccessRights (Selector: Word; Rights: Word): Boolean;

 { Returns the access rights of a descriptor }
 procedure SetDescriptorAccessRights (var Descr: TDescriptor; Rights: Word);

 { Creatse 32-bit alias code selector }
 function  CreateCode32Alias (Selector: Word): Word;

 { Creatse 32-bit alias data selector }
 function  CreateData32Alias (Selector: Word): Word;

 {************************* MEMORY MANAGMENT SECTION ************************}

 { Returns Returns the size of the largest contiguous free 32bit block }
 function  MaxAvail32: Longint;

 { Returns the amount of all free 32bit memory }
 function  MemAvail32: Longint;

 { Allocates the specified number of bytes from the 32bit global heap }
 function  GlobalAlloc32 (Size: Longint): Word;

 { Frees memory block, allocated by GlobalAlloc32 }
 procedure GlobalFree32 (Selector: Word);

 { Allocates the specified number of bytes in the conventional memory }
 function  GlobalDosAlloc16 (var Addr: Pointer; Size: LongInt): Word;

 { Frees memory block, allocated by GlobalDOSAlloc32 }
 function  GlobalDOSFree16 (Addr: Pointer): Word;

 function  FarPtr (Selector: Word; Offset32: LongInt): FarPointer;
  inline  ($58/$5B/$5A);

 function  FarSeg (Addr: FarPointer): Word;
  inline  ($58/$58/$58);

 function  FarOfs (Addr: FarPointer): LongInt;
  inline  ($58/$5A/$5B);

 function  NearToFarPtr (Addr: Pointer): FarPointer;
  inline  ($58/$31/$DB/$5A);

 { Increments 16-bit pointer on Offs bytes }
 procedure IncPointer16 (var Addr: Pointer; Offs: LongInt);
  inline ($5B/$58/$5F/$07/$26/$01/$1D/$15/$00/$00/
          $74/$08/$F7/$26/SelectorInc/$26/$01/$45/$02);

 { Increments 32-bit pointer Offs bytes }
 procedure IncPointer32 (var Addr: FarPointer; Offs: LongInt);
  inline ($66/$5B/$5F/$07/$66/$26/$8B/$05/$66/$03/$C3/
          $66/$26/$89/$05);

 { Increments 16-bit pointer on 1 byte }
 procedure IncPtr16 (var Addr: Pointer);
  inline ($5F/$07/$8C/$C0/$26/$FF/$05/$75/$07/
          $A1/SelectorInc/$26/$01/$45/$02);

 { Increments 32-bit pointer on 1 byte }
 procedure IncPtr32 (var Addr: FarPointer);
  Inline ($5F/$07/$66/$26/$8B/$05/$66/$40/
          $66/$26/$89/$05);

 { Decrements 16-bit pointer on Offs bytes }
 procedure DecPointer16 (var Addr: Pointer; Offs: LongInt);
  inline ($5B/$58/$5F/$07/$26/$29/$1D/
          $1D/$00/$00/$74/$08/$F7/$26/SelectorInc/
          $26/$29/$45/$02);

 { Decrements 32-bit pointer on Offs bytes }
 procedure DecPointer32 (var Addr: FarPointer; Offs: LongInt);
 inline ($66/$5B/$5F/$07/$66/$26/$8B/$05/$66/$2B/$C3/
         $66/$26/$89/$05);

 { Decrements 16-bit pointer on 1 byte }
 procedure DecPtr16 (var Addr: Pointer);
  inline ($5F/$07/$8C/$C0/$26/$FF/$0D/
          $75/$07/$A1/SelectorInc/$26/$29/$45/$02);

 { Decrements 32-bit pointer on 1 byte }
 procedure DecPtr32 (var Addr: FarPointer);
  Inline ($5F/$07/$66/$26/$8B/$05/$66/$48/
          $66/$26/$89/$05);

 function  GetByte16 (Addr: Pointer): Byte;
  inline  ($5F/$07/$26/$8A/$05);

 function  GetByte32 (Addr: FarPointer): Byte;
  inline  ($66/$5E/$07/$26/$67/$8A/$06);

 function  GetWord16 (Addr: Pointer): Word;
  inline  ($5F/$07/$26/$8A/$05/$47/$75/$08/
           $8C/$C3/$03/$1E/SelectorInc/$8E/$C3/
           $26/$8A/$25);

 function  GetWord32 (Addr: FarPointer): Word;
  inline  ($66/$5E/$07/$26/$67/$8B/$06);

 function  GetLong16 (Addr: Pointer): LongInt;

 function  GetLong32 (Addr: FarPointer): Longint;
  inline  ($66/$5E/$07/$66/$26/$67/$8B/$06/
           $8B/$D0/$66/$C1/$E8/$10/$92);

 procedure PutByte16 (Addr: Pointer; Value: Byte);
  inline  ($58/$5F/$07/$26/$88/$05);

 procedure PutByte32 (Addr: FarPointer; Value: Byte);
  inline  ($58/$66/$5F/$07/$26/$67/$88/$07);

 procedure PutWord16 (Addr: Pointer; Value: Word);
  inline  ($58/$5F/$07/$26/$88/$05/$47/$75/$08/
           $8C/$C3/$03/$1E/SelectorInc/$8E/$C3/
           $26/$88/$25);

 procedure PutWord32 (Addr: FarPointer; Value: Word);
  inline  ($58/$66/$5F/$07/$26/$67/$89/$07);

 procedure PutLong16 (Addr: Pointer; Value: LongInt);

 procedure PutLong32 (Addr: FarPointer; Value: Longint);
  inline  ($66/$58/$66/$5F/$07/$66/$26/$67/$89/$07);

 { Copies a specified number bytes from a source to a destination address }
 procedure Move32 (Source, Dest: FarPointer; Count: Longint);

 { Fills a specified number of bytes with a specified byte value }
 procedure FillChar32 (Addr: FarPointer; Count: Longint; Value: Byte);

 function GetPtr16 (Addr: Pointer; Offs: LongInt): Pointer;

 function GetPtr32 (Addr: FarPointer; Offs: LongInt): FarPointer;

 procedure ClearRegs (Regs: TRealRegs);

 IMPLEMENTATION

 var DPMIProExitProc: Pointer;

 function GetDisableInterruptState: Boolean; assembler;
      asm
        mov     ax,$0900
        int     $31
 end;

 function GetEnableInterruptState: Boolean; assembler;
      asm
        mov     ax,$0901
        int     $31
 end;

 function GetInterruptState: Boolean; assembler;
      asm
        mov     ax,$0902
        int     $31
 end;

 function GetRealInterruptVec (IntNo: Byte): Pointer; assembler;
      asm
        mov     ax,$0200
        mov     bl,[IntNo]
        int     $31
        mov     ax,dx
        mov     dx,cx
 end;

 procedure SetRealInterruptVec (IntNo: Byte; Vector: Pointer); assembler;
      asm
        mov     ax,$0201
        mov     bl,[IntNo]
        mov     cx,word ptr [Vector+2]
        mov     dx,word ptr [Vector+0]
        int     $31
 end;

 function GetDPMIInterruptVec16 (IntNo: Byte): Pointer; assembler;
      asm
        mov     ax,$0204
        mov     bl,[IntNo]
        int     $31
        mov     ax,dx
        mov     dx,cx
 end;

 procedure SetDPMIInterruptVec16 (IntNo: Byte; Vector: Pointer); assembler;
      asm
        mov     ax,$0205
        mov     bl,[IntNo]
        mov     cx,word ptr [Vector+2]
        mov     dx,word ptr [Vector+0]
        int     $31
 end;

 function RealModeInt (IntNum: Word; var Regs: TRealRegs): Word; assembler;
      asm
        push    bp
        mov     bx,[IntNum]
        xor     cx,cx
        les     di,Regs
        mov     ax,$300
        int     $31
        jc      @Quit
        xor     ax,ax
@Quit:  pop     bp
 end;

 function DPMIGetCPUType: Byte; assembler;
      asm
        mov     ax,$0400
        int     $31
        mov     al,cl
 end;

 function GetDPMIVersion: Word; assembler;
      asm
        mov     ax,$0400
        int     $31
 end;

 function DPMIVirtualState: Boolean; assembler;
      asm
        mov     ax,$0400
        int     $31
        mov     ax,bx
        shr     ax,2
 end;

 function AllocateDescriptor (HowMany: Word): Word; assembler;
      asm
        mov     ax,$0000
        mov     cx,[HowMany]
        int     $31
        jnc     @Ok
        xor     ax,ax
@Ok:
 end;

 procedure FreeDescriptor (Selector: Word); assembler;
      asm
        mov     ax,$0001
        mov     bx,[Selector]
        int     $31
 end;

 function GetDescriptor (Selector: Word; var Descr: TDescriptor): Boolean; assembler;
      asm
        mov     ax,$000B
        mov     bx,[Selector]
        les     di,[Descr]
        int     $31
        xor     ax,ax
        jc      @Quit
        mov     ax,$0001
@Quit:
 end;

 function SetDescriptor (Selector: Word; var Descr: TDescriptor): Boolean; assembler;
      asm
        mov     ax,$000C
        mov     bx,[Selector]
        or      bx,bx
        je      @Quit
        les     di,[Descr]
        int     $31
        xor     ax,ax
        jc      @Quit
        mov     ax,$0001
@Quit:
 end;

 function CreateAliasDescriptor (Selector: Word): Word; assembler;
      asm
        mov     ax,$000A
        mov     bx,[Selector]
        int     $31
        jnc     @Quit
        xor     ax,ax
@Quit:
 end;

 function MapPhysicalToLinear (Addr, Size: Longint): Longint; assembler;
      asm
        mov     ax,$0800
        mov     cx,word ptr [Addr]
        mov     bx,word ptr [Addr+2]
        mov     di,word ptr [Size]
        mov     si,word ptr [Size+2]
        int     $31
        mov     ax,cx
        mov     dx,bx
        jnc     @Quit
        xor     ax,ax
        xor     dx,dx
@Quit:
 end;

 function FreePhysicalMap (LinearAddr: Longint): Boolean; assembler;
      asm
        mov     ax,$0801
        mov     cx,word ptr [LinearAddr]
        mov     bx,word ptr [LinearAddr+2]
        int     $31
        xor     ax,ax
        jc      @Quit
        mov     ax,$0001
@Quit:
 end;

 function CreateSelector32 (Base, Limit: Longint): Word;
 var Selector: Word;
     Descr: TDescriptor;
 begin
  Selector:=AllocateDescriptor(1);
  if Selector<>0 then begin
    CreateSelector32:=0;
    if not GetDescriptor(Selector,Descr) then exit;
    SetDescriptorBaseAddress(Descr,Base);
    SetDescriptorLimit(Descr,Limit);
    Descr.FlagsH:=Descr.FlagsH and $BF;
    if not SetDescriptor(Selector,Descr) then exit;
  end;
  CreateSelector32:=Selector;
 end;

 function CreateSelector16 (Base: LongInt; Limit: Word): Word;
 var Sel: Word;
 begin
  Sel:=AllocSelector(0);
  If (Sel<>0) and (SetSelectorBase(Sel,Base)=Sel) and (SetSelectorLimit(Sel,
      Limit)=0) then CreateSelector16:=Sel else CreateSelector16:=0;
 end;

 procedure SetDescriptorBaseAddress (var Descr: TDescriptor; Base: Longint);
 begin
  Descr.BaseAddressL:=Word(Base);
  Descr.BaseAddressH:=Byte(Base shr 16);
  Descr.BaseAddressU:=Byte(Base shr 24);
 end;

 procedure SetDescriptorLimit (var Descr: TDescriptor; Limit: LongInt);
 begin
  with Descr do begin
    if Limit>0 then Dec(Limit);
    if Limit>=$100000 then begin
      Limit:=Limit shr 12;
      FlagsH:=FlagsH or $80;
    end;
    SegmentLimit:=Word(Limit);
    FlagsH:=FlagsH or Byte(Limit shr 16);
  end;
 end;

 function SetSegmentBaseAddress (Selector: Word; Base: Longint): Boolean;
 var Descr: TDescriptor;
 begin
  if (Selector=0) or (not GetDescriptor(Selector, Descr)) then begin
   SetSegmentBaseAddress:=false;
   exit;
  end;
  SetDescriptorBaseAddress(Descr,Base);
  SetSegmentBaseAddress:=SetDescriptor(Selector,Descr);
 end;

 function SetSegmentLimit (Selector: Word; Limit: Longint): Boolean;
 var
  Descr: TDescriptor;
 begin
  if (Selector=0) or (not GetDescriptor(Selector, Descr)) then begin
   SetSegmentLimit:=false;
   exit;
  end;
  SetDescriptorLimit(Descr, Limit);
  SetSegmentLimit:=SetDescriptor(Selector, Descr);
 end;

 function GetSegmentAccessRights (Selector: Word): Word;
 var Descr: TDescriptor;
 begin
  if GetDescriptor(Selector,Descr) then
   GetSegmentAccessRights:=(Word(Descr.FlagsH) shl 8) or Descr.FlagsL
  else GetSegmentAccessRights:=0;
 end;

 function SetSegmentAccessRights (Selector: Word; Rights: Word): Boolean;
 var Descr: TDescriptor;
 begin
  if (Selector=0) or (not GetDescriptor(Selector,Descr)) then begin
   SetSegmentAccessRights:=false;
   exit;
  end;
  SetDescriptorAccessRights(Descr,Rights);
  SetSegmentAccessRights:=SetDescriptor(Selector,Descr);
 end;

 procedure SetDescriptorAccessRights (var Descr: TDescriptor; Rights: Word);
 begin
  Descr.FlagsL:=Byte(Rights);
  Descr.FlagsH:=Byte(Rights shr 8);
 end;

 function CreateCode32Alias (Selector: Word): Word;
 var Descr: TDescriptor;
 begin
  Selector:=CreateAliasDescriptor(Selector);
  if Selector<>0 then begin
   GetDescriptor(Selector,Descr);
   Descr.FlagsH:=Descr.FlagsH or $40;
   Descr.FlagsL:=(Descr.FlagsL and $F0) or $0B;
   SetDescriptor(Selector,Descr);
  end;
  CreateCode32Alias:=Selector;
 end;

 function CreateData32Alias (Selector: Word): Word;
 var NewSelector: Word;
     Descr: TDescriptor;
 begin
  NewSelector:=AllocateDescriptor(1);
  if NewSelector<>0 then begin
   GetDescriptor(Selector,Descr);
   Descr.FlagsH:=Descr.FlagsH or $40;
   Descr.FlagsL:=(Descr.FlagsL and $F0) or $03;
   SetDescriptor(NewSelector,Descr);
  end;
  CreateData32Alias:=NewSelector;
 end;

 function MaxAvail32: Longint; assembler;
      asm
        xor       ax,ax
        push      ax
        push      ax
        call      far ptr GlobalCompact
 end;

 function MemAvail32: Longint; assembler;
      asm
        xor       ax,ax
        push      ax
        call      far ptr GetFreeSpace
 end;

 function GlobalAlloc32 (Size: Longint): Word;
 var Dummy:                 Pointer;
     SelectorNo,i,Selector: Word;
     Base:                  Longint;
     Status:                Boolean;
     Descr:                 TDescriptor;
 begin
  Dummy:=GlobalAllocPtr(gmem_Fixed,Size);
  if (Dummy<>nil) and (TLong(Dummy).Lo=0) then begin
   Status:=True;
   Selector:=TLong(Dummy).Hi;
   Base:=GetSelectorBase(Selector);
   SelectorNo:=Size div $10000;
   if (Size mod $10000)<>0 then Inc(SelectorNo);
    for i:=1 to SelectorNo-1 do begin
     Inc(Base,$10000);
     if Base<>GetSelectorBase(Selector+SelectorInc*i) then begin
      Status:=False; Break;
     end;
    end;
    if Status then begin
     GetDescriptor(Selector,Descr);
     SetDescriptorLimit(Descr,Size);
     Descr.FlagsH:=Descr.FlagsH and $BF;
     SetDescriptor(Selector,Descr);
    end;
    if not Status then begin
     GlobalFreePtr(Dummy);
     Selector:=0;
    end;
  end
  else Selector:=0;
  GlobalAlloc32:=Selector;
 end;

 procedure GlobalFree32 (Selector: Word);
 begin
  if Selector<>0 then begin
   GlobalFreePtr(Ptr(Selector,0));
  end;
 end;

 function  GlobalDosAlloc16 (var Addr: Pointer; Size: LongInt): Word;
 var Long: LongInt;
 begin
  Long:=GlobalDosAlloc(Size);
  Addr:=Ptr(Word(Long),0);
  GlobalDosAlloc16:=TLong(Long).Hi;
 end;

 function GlobalDOSFree16 (Addr: Pointer): Word;
 begin
  GlobalDOSFree16:=GlobalDOSFree(TLong(Addr).Hi);
 end;

 function  GetLong16 (Addr: Pointer): LongInt;
 var Value: LongInt;
 begin
  Value:=GetWord16(Addr);
  IncPointer16(Addr,2);
  TLong(Value).Hi:=GetWord16(Addr);
 end;

 procedure PutLong16 (Addr: Pointer; Value: LongInt);
 begin
  PutWord16(Addr,Word(Value));
  IncPointer16(Addr,2);
  PutWord16(Addr,TLong(Value).Hi);
 end;

 procedure Move32 (Source, Dest: FarPointer; Count: Longint); assembler;
      asm
        cld
        push    ds
        db      $66
        lds     si,dword [Source]
        db      $66
        les     di,dword [Dest]
        db      $66
        mov     cx,word [Count]
        push    cx
        db      $66
        shr     cx,2
        db      $66,$67
        rep     movsw
        pop     cx
        and     cx,$0003
        db      $67
        rep     movsb
        pop     ds
 end;

 procedure FillChar32 (Addr: FarPointer; Count: Longint; Value: Byte); assembler;
      asm
        cld
        db      $66
        les     di,dword [Addr]
        db      $66
        mov     cx,word [Count]
        mov     al,[Value]
        mov     ah,al
        mov     bx,ax
        db      $66
        shl     ax,16
        mov     ax,bx
        push    cx
        db      $66
        shr     cx,2
        db      $66,$67
        rep     stosw
        pop     cx
        and     cx,0003h
        db      67h
        rep     stosb
 end;

 function GetPtr16 (Addr: Pointer; Offs: LongInt): Pointer;
 begin
  GetPtr16:=Ptr(LongAdd(TLong(Addr).Hi,LongMul(TLong(Offs).Hi,SelectorInc)),
   LongAdd(TLong(Addr).Lo,TLong(Offs).Lo));
 end;

 function GetPtr32 (Addr: FarPointer; Offs: LongInt): FarPointer;
 begin
  GetPtr32:=FarPtr(FarSeg(Addr),FarOfs(Addr)+Offs);
 end;

 procedure DPMIProExit;
 begin
  ExitProc:=DPMIProExitProc;
  GlobalDOSFree16(BufferPtr16);
 end;

 procedure ClearRegs (Regs: TRealRegs);
 begin
  FillChar(Regs,SizeOf(Regs),0)
 end;

 begin
  BufferSeg:=GlobalDOSAlloc16(BufferPtr16,8*1024);
  BufferPtr32:=FarPtr(Seg(BufferPtr16),0);
  DPMIProExitProc:=ExitProc;
  ExitProc:=@DPMIProExit;
 end.
