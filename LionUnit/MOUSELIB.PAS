Unit MouseLib;

Interface

Type
  CursorShape = Record
		HotX,HotY:Integer;
		Cursor:Array[1..2,1..16] Of Word;
	      End;
Const
  _Cur_Clock:CursorShape= (HotX:$0D;HotY:$03;
			   Cursor:(
			   ($0000,$0000,$8001,$C003,$E007,$F00F,$F81F,$F81F,
			    $F81F,$F81F,$F00F,$E007,$C003,$8001,$0000,$0000),
			   ($0000,$7FFE,$0000,$1FF8,$0FF0,$03C0,$0000,$03C0,
			    $0000,$03C0,$07E0,$0FF0,$1FF8,$0000,$7FFE,$0000)));
  _Cur_Finger:CursorShape=(HotX:$2;HotY:$1;
			   Cursor:(
			   ($8FFF,$27FF,$77FF,$77FF,$77FF,$77FF,$7FFF,$7124,
			    $7492,$76DA,$76DA,$76D6,$7FFE,$3FFC,$9FF9,$C003),
			   ($0000,$2000,$7000,$7000,$7000,$7000,$7000,$7000,
			    $7492,$76DA,$76DA,$76D6,$7FFE,$3FFC,$1FF8,$0000)));
Function DetectMouse:Boolean;
Procedure CursorVisible(Visible:Boolean);
Function GetCursorX:Integer;
Function GetCursorY:Integer;
Function LeftPressed:Boolean;
Function MidlePressed:Boolean;
Function RightPressed:Boolean;
Procedure SetCursor(X,Y:Integer);
Procedure SetRange(MinX,MinY,MaxX,MaxY:Integer);
Procedure SetForm(CenterX,CenterY:Integer;Var Cursor);
Procedure SetCursorForm(C:CursorShape);
Function GetIncrX:Integer;
Function GetIncrY:Integer;
Function CursorMoved:Boolean;

Implementation

Uses Dos;

Function DetectMouse:Boolean;
  Var _:Registers;
  Begin
    _.AX:=0;
    Intr($33,_);
    DetectMouse:=(_.AL=0);
  End;

Procedure CursorVisible(Visible:Boolean);Assembler;
  Asm
    Mov al,Visible
    Or al,al
    jnz @True
    Mov al,2
   @True:
    Xor ah,ah
    Int 33h
  End;

Function GetCursorX:Integer;Assembler;
  Asm
    Mov ax,3
    Int 33h
    Mov ax,cx
  End;

Function GetCursorY:Integer;Assembler;
  Asm
    Mov ax,3
    Int 33h
    Mov ax,dx
  End;

Function LeftPressed:Boolean;Assembler;
  Asm
    Mov ax,3
    Int 33h
    Test bx,1
    Mov al,1
    Jnz @Exit
    Xor al,al
   @Exit:
  End;

Function MidlePressed:Boolean;Assembler;
  Asm
    Mov ax,3
    Int 33h
    Test bx,4
    Mov al,1
    Jnz @Exit
    Xor al,al
   @Exit:
  End;

Function RightPressed:Boolean;Assembler;
  Asm
    Mov ax,3
    Int 33h
    Test bx,2
    Mov al,1
    Jnz @Exit
    Xor al,al
   @Exit:
  End;

Procedure SetCursor(X,Y:Integer);Assembler;
  Asm
    Mov ax,4
    Mov cx,X
    Mov dx,Y
    Int 33h
  End;

Procedure SetRange(MinX,MinY,MaxX,MaxY:Integer);Assembler;
  Asm
    Mov ax,7
    Mov cx,MinX
    Mov dx,MaxX
    Int 33h
    Mov ax,8
    Mov cx,MinY
    Mov dx,MaxY
    Int 33h
  End;

Procedure SetForm(CenterX,CenterY:Integer;Var Cursor);Assembler;
  Asm
    Mov ax,9
    Mov bx,CenterX
    Mov cx,CenterY
    Les dx,Cursor
    Int 33h
  End;

Procedure SetCursorForm(C:CursorShape);
  Begin
    SetForm(Integer(Ptr(Seg(C),Ofs(C))^),
	    Integer(Ptr(Seg(C),Ofs(C)+2)^),Ptr(Seg(C),Ofs(C)+4)^);
  End;

Function GetIncrX:Integer;Assembler;
  Asm
    Mov ax,0bh
    Int 33h
    Mov ax,cx
  End;

Function GetIncrY:Integer;Assembler;
  Asm
    Mov ax,0bh
    Int 33h
    Mov ax,dx
  End;

Function CursorMoved:Boolean;
  Begin
    CursorMoved:=(GetIncrX<>0)Or(GetIncrY<>0);
  End;

End.