{$M 26384,0,655360}

unit GVision;

interface

 Uses App,Menus,Objects,Drivers;

 const sm640x350 = $0010;
        NoCursor = $0000;
 Type PGraphApplication = ^TGraphAPPlication;
      TGraphApplication = object ( TProgram )
                          Constructor Init;
                          Destructor Done;Virtual;
                          Procedure GetEvent(Var Event:TEvent);virtual;
                          Procedure PutEvent(var Event:TEvent);Virtual;
                          Procedure Idle;virtual;
                          Procedure ScreenMode(Mode:word);
                         end;
     PGrMenuBar = ^TGrMenuBar ;
     TGrMenuBar = object (TMenubar)
       function NewSubView(var Bounds: TRect; AMenu: PMenu;
           AParentMenu: PMenuView): PMenuView; virtual;
     end;
     PGrMenuBox = ^TGrMenuBox ;
     TGrMenuBox = object (TMenubox)
         function Execute: Word; virtual;
         function NewSubView(var Bounds: TRect; AMenu: PMenu;
           AParentMenu: PMenuView): PMenuView; virtual;
     end;
    TScreenBuffer = Array[1..4096] of word;
    PScreenBuffer = ^TScreenBuffer;
    TMouseShape = record
                   HotX,HotY:Integer;
                   CursorMask,ScreenMask:Array[1..16]of Word;
                  end;
var GraphStringHeight:Integer;
    GraphicEnabled:Boolean;
   EventMask:Word;
    GraphDriver,GraphMode:Integer;
    FirstBuffer,SecondBuffer:PScreenBuffer;
    GraphMouseWhere:TPoint;
Procedure ReFreshDisplay;
Procedure SetMouseShape( var Shape :TMouseShape );

implementation

uses Views,Memory,Graph,HistList;

const GCursor :Record X,Y:Byte;size:Word; end =(X:0;Y:0;Size:0);
  {Menus }
    function TGrMenuBox.Execute: Word;
     begin
      Execute:=TMenuBox.Execute;
      Hide;
      Desktop^.Redraw;
     end;
  function TGrMenuBar.NewSubView(var Bounds: TRect; AMenu: PMenu;
  AParentMenu: PMenuView): PMenuView;
begin
  NewSubView := New(PGrMenuBox, Init(Bounds, AMenu, AParentMenu));
end;

function TGrMenuBox.NewSubView(var Bounds: TRect; AMenu: PMenu;
  AParentMenu: PMenuView): PMenuView;
begin
  NewSubView := New(PGrMenuBox, Init(Bounds, AMenu, AParentMenu));
end;

{$F+}
Procedure Font8x14;far;external;
{$L font8x14}

{$F-}
{$S-}
Procedure Show;near;assembler;
{DI = Смещение в vбуфере}
{DX = Символ с атрибутом}
var fgd,
    bgd:byte;
asm
 Push cx
 Push bx
 Push dx
 Push Di
 Push SI
 Push ds
 Push es
 mov ax,dx
{ Bgd:=Hi(Sym) shr 4;}
 mov al,ah
 mov cl,4
 Shr al,cl
 mov bgd,al
 {Fgd:=(Hi(Sym) and $F)xor bgd+128;}
 Xchg ah,al
 and al,0fh
 mov fgd,al
 {Calculating offset of symbol in font}
 Mov al,dl
 Mov bl,14
 Mul bl
 Mov SI,offset Font8x14
 Push cs
 Pop ds
 add si,ax
 Mov ax,0A000h
 Mov es,ax
 mov cx,14
 Mov dx,3ceh
 Mov al,5
 Out dx,al
 Mov al,2
 Inc dx
 Out dx,al
@Loop:
 {Output of one scanLine}
 Dec dx
 Mov al,8
 Out dx,al
 Inc dx
 Mov al,0ffh
 Out dx,al
 Mov al,bgd
 Mov es:[di],al
 dec dx
 mov al,8
 out dx,al
 inc dx
 Lodsb
{ not al}
 out dx,al
 and al,al
 jz @2
 Mov al,es:[di]
 Mov al,fgd
 mov es:[di],al
@2: Add di,80
 Loop @Loop
 Pop es
 Pop ds
 Pop si
 Pop di
 Pop dx
 Pop bx
 Pop cx
end;
{$S+}

function TextOffset:Word;near;assembler;
{Calculates offset in text buffer}
{DH:row,DL:Column}
asm
 Push bx
 Mov al,dh
 mov bl,80
 mul bl
 mov bl,dl
 xor bh,bh
 add ax,bx
 shl ax,1
 Pop bx
end;

function VideoOffset:word;Near;Assembler;
{Calculates offset in EGA video buffer}
{DH:row,DL:Column}
asm
 Push bx
 Push cx
 Push ds
 Mov ax, seg @Data
 Mov ds,ax
 Mov bl,GraphStringHeight.byte[0]
 Mov bh,bl
 mov cl,2
 shl bl,cl
 add bl,bh
 Mov al,dh
 mul bl
 mov cl,4
 shl ax,cl
 Mov bl,dl
 xor bh,bh
 add ax,bx
 pop ds
 pop cx
 pop bx
end;

Procedure ReFreshDisplay;assembler;
var HMouse:Boolean;
    VideoShift:Word;
asm
       Mov al,GraphicEnabled
       cmp al,True
       jz @@@0
       jmp @X
{Set ega writeMode 2}
@@@0:  Mov dx,3ceh
       Mov al,8
       out dx,al
       inc dx
       mov al,2
       out dx,al
       mov al,false
       Mov hmouse,al
       {Testing for Mouse  cursor overlaying overriding symbol}
       mov al, ButtonCount
       cmp al,0
       jz @Curs;{No mouse - no testing}
       Push ds
       Mov dh,MouseWhere.byte[2]
       Mov dl,MouseWhere.Byte[0]
       {Compare Mouse coordinates with text cursor position}
       Mov ax,GCursor.Size
       cmp ah,20h
       jz @@@2;{No cursor - no compare}
       cmp Ah,Al
       jz @@@2
       Mov ax,GCursor.Word[0]
       cmp ax,dx
       jz @Hide
       cmp al,0
       jz @@@1
       dec al
       cmp ax,dx
       jz @Hide
       inc al
@@@1:  cmp ah,0
       jz @@@2
       dec ah
       cmp ax,dx
       jz @Hide
       cmp al,0
       jz @@@2
       dec al
       cmp ax,dx
       jz @Hide
{Test for changing symbols,overlayed by mouse cursor}
@@@2:  call TextOffset
       Les Di,SecondBuffer
       Mov bx,si
       Lds si,FirstBuffer
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       jnz @Hide
       add bx,2
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       jnz @Hide
       add bx,2
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       jnz @Hide
       add bx,156
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       jnz @Hide
       add bx,2
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       JNZ @hIDE
       add bx,2
       Mov al,[si+bx]
       Cmp al,es:[di+bx]
       jz @Cont1
@Hide: Mov al,True
       Mov hmouse,al
       Mov ax,2
       Int 33h
@Cont1:Pop ds
@Curs:
{Hiding text cursor}
       Mov ax,GCursor.Size
       Cmp ah,20h
       jz @Cont2
       cmp ah,al
       jz @Cont2
       Mov dx,GCursor.Word[0]
       call VideoOffset
       Mov di,ax
       call TextOffset
       Push ds
       Lds si,FirstBuffer
       add si,ax
       Lodsw
       Mov dx,ax
       Pop ds
       call show
@Cont2:
{Main Loop}
       Push ds
       Mov cl,ScreenHeight
       xor ch,ch
       Xor bx,bx {Video buffer offset}
       Mov al,GraphStringHeight.Byte[0]
       Dec al
       Mov dl,80
       Mul dl
       Mov VideoShift,ax
       Les di,SecondBuffer
       Lds si,FirstBuffer
@Loop1:Push cx
       Mov cx,80
@Loop2:Lodsw
       cmp ax,es:[di]
       Jz @1
       Push di
       Mov di,bx
       Mov dx,ax
       call show
       Mov ax,dx
       Pop di
@1:    StoSw
       Inc bx
       Loop @Loop2
       add bx,VideoShift
       Pop cx
       Loop @Loop1
       Pop ds
{Show text cursor}
       Mov ah,3
       xor bh,bh
       Int 10h
       Mov GCursor.Word[0],DX
       Mov GCursor.Size,CX
       cmp cx,0
       jz @Cont3
       Cmp ch,20h
       jz @Cont3
       CMP CL,CH
       JL  @Cont3
       Shl ch,1
       Mov cl,GraphStringHeight.Byte[0]
       Sub cl,ch
       Mov al,ch
       mov ch,80
       mul ch
       xor ch,ch
       mov di,ax
       call VideoOffset
       add di,ax
       mov ax,0A000h
       mov es,ax
       mov dx,3c5h
       mov al,2
       out dx,al
       Mov al,0fh
       out dx,al
       mov dx,3ceh
       mov al,5
       Out dx,al
       inc dx
       mov al,2
       Out dx,ax
       dec dx
       mov al,8
       out dx,al
       Mov al,0ffh
       inc dx
       Out dx,al
       mov al,0fh
@cl:   Mov es:[di],al
       add di,80
       Loop @cl
{Show mouse,if Hidden}

@Cont3:xor bx,bx
       Push bx
       Push bx
       call getPixel
       Push bx
       Push bx
       push ax
       call putpixel
       mov al,HMouse
       cmp al,True
       jnz @X
       Mov ax,1
       int 33h
@X:
end;

Procedure InitGraphicVideo;
Begin
 GetMem(FirstBuffer,4000);
 GetMem(SecondBuffer,4000);
 Asm
  Push es
  Mov Cx,2000
  Mov bx, Offset FirstBuffer;
  Mov aX,0;
  Les di,[bx]
  Rep StoSw
  Mov Cx,2000
  Mov bx,Offset SecondBuffer;
  Les di,[bx]
  Rep StoSw
  Pop es
  Mov Ax,0
  Int 33h;
  Mov ax,4
  Xor cx,cx
  Mov dx,cx
  Int 33h
  Mov ax,1
  int 33h
 end;
 GraphicEnabled:= True;
 ScreenBuffer:=FirstBuffer;
 GraphStringHeight :=14;
 ScreenHeight:=25;
end;

Procedure DoneGraphicVideo;
Begin
 if not GraphicEnabled then exit;
 GraphicEnabled:=False;
 FreeMem(FirstBuffer,4000);
 FreeMem(SecondBuffer,4000);
 ScreenBuffer:=Ptr($B800,0);
 GraphStringHeight:=8;
end;

Procedure EgaVga;External;
{$L EGA.OBJ}

Procedure InitGraph;
var i:integer;
Begin
 i:= RegisterBgiDriver(@EgaVga);
 GraphDriver:=Detect;
 Graph.InitGraph(GraphDriver,GraphMode,'');
 if GraphDriver<0 then Begin
  Writeln('EGA or VGA required for GVision');
  halt
 end;
 InitGraphicVideo;
 if GraphDriver=Vga then
  Begin
   SetGraphMode(VgaMed)
{   ScreenHeight:=34;
   HiResScreen := True;}
  end;
end;

Procedure DoneGraph;
begin
 CloseGraph;
 DoneGraphicVideo;
end;

var
   MouseButtons:Byte;
   OldMouseInt:Pointer;

Procedure GraphMouseInt;far;assembler;
asm
 Mov si, seg @DATA
 Mov DS,Si
 Mov GraphMouseWhere.X,CX
 Mov GraphMouseWhere.Y,DX
 Call DWORD PTR OldMouseInt;
end;

Procedure GetMouseEvents(Var Event:TEvent);
begin
 Drivers.GetMouseEvent(Event);
 if Event.What<>evNothing then
  begin
   MouseWhere.X:=GraphMouseWhere.X shr 3;
   MouseWhere.Y:=GraphMouseWhere.Y div GraphStringHeight;
   Event.Where:=MouseWhere;
  end;
end;

Procedure InitGraphicMouse;Assembler;
asm
    Mov Al,ButtonCount
    cmp Al,0
    Jz @X
   Mov OldMouseInt.Word[0],DX
   Mov OldMouseInt.Word[2],ES
     Push es
    Mov CX,0FFFFh
    Mov dx,offset CS:GraphMouseInt
    Push cs
    Pop es
    Mov AX,0cH
    Int 33h
    XOR cx,cx
    Mov dx,cx
    Mov ax,4
    Int 33h
    Call GetMaxY
    Mov Dx,Ax
    Xor cx,CX
    Mov ax,8
    Int 33H
    Mov ax,1
    Int 33h
    Pop ES
@X:
end;

constructor TGraphApplication.Init;
begin
  InitMemory;
  InitVideo;
  InitGraph;
  InitEvents;
  InitGraphicMouse;
  InitSysError;
  InitHistory;
  TProgram.Init;
end;

destructor TGraphApplication.Done;
begin
  TProgram.Done;
  DoneHistory;
  DoneSysError;
  DoneEvents;
  DoneGraph;
  DoneVideo;
  DoneMemory;
end;

Procedure TGraphApplication.Idle;
begin
 TProgram.Idle;
 if GraphicEnabled then RefreshDisplay;
end;

Procedure TGraphApplication.ScreenMode(Mode:Word);
var R:TRect;
begin
 if Mode<>sm640x350 then
  begin
   If GraphicEnabled then
    begin
     RestoreCrtMode;
     DoneGraphicVideo;
    end;
   SetScreenMode(Mode)
  end
 else
  if not GraphicEnabled then
   begin
    SetGraphMode(EgaHi) ;
    InitGraphicVideo;
    R.Assign(0,0,ScreenWidth,ScreenHeight);
    ChangeBounds(R);
   end;

end;

Const Pending:TEvent=(What:evNothing);

procedure TGraphApplication.PutEvent(var Event: TEvent);
begin
  Pending := Event;
end;

procedure TGraphApplication.GetEvent(var Event: TEvent);
var
  R: TRect;

function ContainsMouse(P: PView): Boolean; far;
begin
  ContainsMouse := (P^.State and sfVisible <> 0) and
    P^.MouseInView(Event.Where);
end;

begin
  if Pending.What <> evNothing then
  begin
    Event := Pending;
    Pending.What := evNothing;
  end else
  begin
    GetMouseEvents(Event);
    if Event.What = evNothing then
    begin
      GetKeyEvent(Event);
      if Event.What = evNothing then Idle;
    end;
  end;
  if StatusLine <> nil then
    if (Event.What and evKeyDown <> 0) or
      (Event.What and evMouseDown <> 0) and
      (FirstThat(@ContainsMouse) = PView(StatusLine)) then
      StatusLine^.HandleEvent(Event);
end;

Procedure SetMouseShape(var Shape:TMouseShape);Assembler;
asm
 Mov Al,ButtonCount
 Test Al,Al
 jz @@X
 Lea BX,Shape
 Mov Cx,ES:[BX+2]
 Mov DX,BX
 Add DX,4
 Mov BX,ES:[BX]
 Mov AX,9
 Int 33h
@@X:
end;

end.

