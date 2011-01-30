{Copyright by Leonid Youriev CCTsoft 1993}
{$I VERSION}

unit    Dark;

interface

{$I VERSION}

procedure InitDark;
function  fork (StackSize, StackFrames : Word) : Boolean;
procedure killSELF;
procedure killPID (PID : Word);
procedure tothePID (PID : Word);
function  ISroot : Boolean;
function  testPID (PID : Word): Boolean;

Const Seg0000 : Word = 0;

procedure _;
{$IFDEF useINT0}
inline ($CD/$00);
{$ENDIF}
{$IFDEF useINT3}
inline ($CC);
{$ENDIF}

var
        DarkStatus      : Shortint;

implementation

uses    Memory;

type

        PDarkitem       = ^TDarkItem;
        TDarkItem       = record
                Pred    : Word;
                Next    : Word;
                _BP,
                _SP             : Word;
                Size    : Word;
                Range   : Byte;
                Info    : Byte;
        end;

const
        RootRange               = 128;
        MinimalStack    = $200 + $100;

        Root            : Word = 0;
        Takt            : Byte = 0;

{$IFDEF useINT0}
var
        OLD0            : Pointer;
{$ENDIF}

procedure UpLoad; near; assembler;
asm
        POP             SI
        POP             DI
        POP             ES
        POP             AX
        PUSH    ES
        PUSH    DI
        JMP             SI
end;

function ISroot : Boolean; assembler;
asm
        MOV             AX, 1
        MOV             CX, Root
        JCXZ    @1
        MOV             BX, SS
        CMP             CX, BX
        JE              @1
        DEC             AX
@1:
end;

{$IFDEF useINT0}
procedure __; far; assembler;
asm
        PUSH    BP
        MOV             BP, SP
        LES             DI, [BP + 2]
        CMP             BYTE PTR ES:[DI - 2], 0CDH
        POP             BP
        JE              @0
        MOV             DI, SEG @DATA
        MOV             DS, DI
        JMP             OLD0
@0:     STI
        ADD             SP, 6
        PUSH    ES
        PUSH    DI
{$ELSE}
{$IFDEF useINT3}
procedure __; far; assembler;
asm
        POP             DI
        POP             ES
        POPF
        PUSH    ES
        PUSH    DI
{$ELSE}
procedure _; assembler;
asm
{$ENDIF}
{$ENDIF}
        MOV             CX, Root
        JCXZ    @4
        MOV             SS:TDarkItem._SP, SP
        MOV             SS:TDarkItem._BP, BP
@1:     MOV             CX, SS:TDarkItem.Next
@2:     TEST    CX, CX
        JNE             @3
        MOV             CX, Root
        INC             Takt
@3:     MOV             AL, Takt
        CLI
        MOV             SS, CX
        MOV             SP, SS:TDarkItem._SP
        STI
        CMP             SS:TDarkItem.Range, AL
        JAE             @1              {учет приоритетов}
        MOV             BP, SS:TDarkItem._BP
        MOV             AL, 1
@4:
end;

procedure killPID (PID : Word);
label
        No;
var
        Size    : Word;
begin
        asm
                CLI
                MOV             CX, Root
                JCXZ    No
                MOV             SI, PID
                TEST    SI, SI
                JE              No
                MOV             ES, SI
                MOV             BX, ES:TDarkItem.Size
                MOV             CX, ES:TDarkItem.Next
                MOV             AX, ES:TDarkItem.Pred
                JCXZ    @1
                MOV             ES, CX
                MOV             ES:TDarkItem.Pred, AX
        @1:     TEST    AX, AX
                JE              @2
                MOV             ES, AX
                MOV             ES:TDarkItem.Next, CX
        @2:     MOV             AX, SS
                CMP             AX, SI
                JNE             @4
                TEST    CX, CX
                JNE             @3
                MOV             CX, Root
        @3:     MOV             SS, CX
                MOV             SP, SS:TDarkItem._SP
                MOV             BP, SS:TDarkItem._BP
                POP             DI
                POP             ES
                PUSH    SI
                PUSH    ES
                PUSH    DI
                PUSH    BP
                MOV             BP, SP
                PUSHF
        @4:     STI
                MOV             Size, BX
        end;
        FreeMem (Ptr (PID, 0), Size);
        No:
        asm
                STI
        end;
end;

function fork (StackSize, StackFrames : Word) : Boolean; assembler;
var
        NewDark         : Word;
asm
        MOV             AX, StackSize
        CMP             AX, MinimalStack
        JA              @1
        MOV             AX, MinimalStack
@1:     CMP             AX, 0F000H
        JBE             @2
        MOV             AX, 0F000H
@2:     ADD             AX, TYPE TDarkItem + 15
        AND             AL, 0F0H
        MOV             StackSize, AX
        PUSH    AX
        CALL    MemAllocSeg
        MOV             DarkStatus, AL
        TEST    DX, DX
        JNE             @3
        INC             DarkStatus
        JMP             @D
@3:     MOV             NewDark, DX
{$IFDEF useINT3}
        MOV             ES, Seg0000
        MOV             DX, OFFSET __
        MOV             WORD PTR ES:[000CH], DX
        MOV             DX, SEG __
        MOV             WORD PTR ES:[000EH], DX
{$ENDIF}
        CMP             Root, AX
        JNE             @4
        MOV             Root, SS
        MOV             CX, TYPE TDarkItem / 2
        XOR             DI, DI
        CLD
        PUSH    SS
        POP             ES
        REP             STOSW
        MOV             BYTE PTR ES:[DI - 2], RootRange
{$IFDEF useINT0}
        MOV             ES, Seg0000
        MOV             AX, OFFSET __
        XCHG    WORD PTR ES:[0000], AX
        MOV             WORD PTR OLD0, AX
        MOV             AX, SEG __
        XCHG    WORD PTR ES:[0002], AX
        MOV             WORD PTR OLD0 [2], AX
{$ENDIF}
        MOV             AX, TYPE TDarkItem + 6
        CMP             AX, StackLimit
        JB              @4
        MOV             StackLimit, AX
@4:     MOV             SI, BP
        MOV             CX, StackFrames
        JCXZ    @6
@5:     MOV             AX, SS:[SI]
        AND             AL, 0FEH
        CMP             AX, SI
        JBE             @6
        XCHG    SI, AX
        LOOP    @5
@6:     MOV             ES, NewDark
        MOV             DI, StackSize
        STD
        SCASW
        MOV             AX, SEG killSELF
        STOSW
        MOV             AX, OFFSET killSELF
        STOSW
        MOV             CX, SI
        SUB             CX, 8
        SUB             CX, BP
        JC              @7
        SHR             CX, 1
        SEGSS   REP             MOVSW
        LODSW
        LODSW
        SEGSS   MOVSW
        SEGSS   MOVSW
@7:     LEA             SI, DI [-4]
        SUB             SI, BP
        MOV             CX, StackFrames
        JCXZ    @9
        MOV             BX, [BP]
@8:     AND             BL, 0FEH
        MOV             AX, ES:[BX + SI]
        ADD             AX, SI
        JNC             @9
        XCHG    AX, ES:[BX + SI]
        XCHG    BX, AX
        LOOP    @8
@9:     MOV             BX, [BP]
        AND             BL, 0FEH
        ADD             BX, SI
        LEA             DX, DI [2]
        MOV             ES, NewDark
        XOR             DI, DI
        CLD
        MOV             AX, SS
        STOSW
        PUSH    ES
@B:     MOV             AX, NewDark
        MOV             CX, AX
        XCHG    CX, SS:TDarkItem.Next
        JCXZ    @C
        MOV             ES, CX
        MOV             ES:TDarkItem.Pred, AX
@C:     POP             ES
        XCHG    AX, CX
        STOSW
        XCHG    AX, BX
        STOSW
        XCHG    AX, DX
        STOSW
        MOV             AX, StackSize
        STOSW
        XOR             AX, AX
        MOV             AL, SS:TDarkItem.Range
        STOSW
@D:     XOR             AX, AX
end;

procedure InitDark;
begin
        if not fork (0, 0) then _;
end;

procedure killSELF; assembler;
asm
        PUSH    SS
        CALL    killPID
end;

procedure tothePID (PID : Word); assembler;
asm
        MOV             SP, BP
        POP             BP
        CALL    UpLoad
        MOV             CX, Root
        JCXZ    @2
        MOV             SS:TDarkItem._SP, SP
        MOV             SS:TDarkItem._BP, BP
        TEST    AX, AX
        JNE             @1
        MOV             AX, Root
@1:     CLI
        MOV             SS, AX
        MOV             SP, SS:TDarkItem._SP
        STI
        MOV             BP, SS:TDarkItem._BP
        MOV             AL, 1
@2:     RETF
end;

function testPID (PID : Word) : Boolean; assembler;
asm
        XOR             AX, AX
        MOV             CX, Root
        JMP             @2
@1:     MOV             ES, CX
        MOV             CX, ES:TDarkItem.Next
@2:     JCXZ    @3
        CMP             CX, PID
        JNE             @1
        INC             AX
@3:
end;

end.

