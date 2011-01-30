unit EGM24; // Enhanced Graphics Module (24bit) v1.06@debug
            // Copyright © 1999 by Alexx

interface

uses Windows, Graphics, Classes;

procedure FadeBitmap24(bmIn1,bmIn2:TBitmap;var bmResult:TBitmap;iAlpha:integer);
procedure DropShadow24(iX,iY,iWidth,iHeight:integer;var bmResult:TBitmap;iAlpha:integer);
procedure DrawBitmap24(iX,iY:integer;bmBitmap,bmAlpha:TBitmap;var bmResult:TBitmap);
function TestBitmap24(bm:TBitmap):boolean;
procedure ReadBitmap24(var bm:TBitmap;sResName:string);

var
 bmImage:TBitmap;

implementation

procedure ReadBitmap24(var bm:TBitmap;sResName:string);
begin
 bmImage.Handle:=LoadBitmap(hInstance,PChar(sResName));
 bm.Width:=bmImage.Width;
 bm.Height:=bmImage.Height;
 bm.Canvas.Draw(0,0,bmImage)
end;

function TestBitmap24(bm:TBitmap):boolean;
begin
 TestBitmap24:=bm.PixelFormat=pf24bit
end;

procedure FadeBitmap24(bmIn1,bmIn2:TBitmap;var bmResult:TBitmap;iAlpha:integer);
 var
  pInBits,pOutBits:pointer;
  iSizeBits:integer;
begin
 If (NOT TestBitmap24(bmIn1)) OR (NOT TestBitmap24(bmIn2)) OR
    (NOT TestBitmap24(bmResult)) OR
    (bmIn1.Width<>bmIn2.Width) OR
    (bmIn1.Height<>bmIn2.Height) Then Exit;
 iSizeBits:=bmIn1.Width*bmIn1.Height*3;
 GetMem(pInBits,iSizeBits);
 GetMem(pOutBits,iSizeBits);
 GetBitmapBits(bmIn1.Handle,iSizeBits,pInBits);
 GetBitmapBits(bmIn2.Handle,iSizeBits,pOutBits);
  asm
   PUSHAD
   MOV ESI,pInBits
   MOV EDI,pOutBits
   MOV ECX,iSizeBits
   MOV EBX,iAlpha
@Met:
   MOV AL,[ESI]
   MOV AH,AL
   MOV DL,[EDI]
   CMP AL,DL
   JZ @Met2
   JAE @Met1
   PUSH DX
   SUB DL,AL
   MOV AL,DL
   MUL BL
   POP DX
   SUB DL,AH
   MOV AH,DL
   JMP @Met2
@Met1:
   SUB AL,DL
   MUL BL
   ADD AH,DL
@Met2:
   MOV [EDI],AH
   INC ESI
   INC EDI
   LOOP @Met
   POPAD
  end;
 SetBitmapBits(bmResult.Handle,iSizeBits,pOutBits);
 FreeMem(pInBits);
 FreeMem(pOutBits)
end;

procedure DropShadow24(iX,iY,iWidth,iHeight:integer;var bmResult:TBitmap;iAlpha:integer);
 var
  pBits:pointer;
  i,j,k,iSize:integer;
begin
 If NOT TestBitmap24(bmResult) Then Exit;
 iSize:=bmResult.Width*bmResult.Height*3;
 GetMem(pBits,iSize);
 GetBitmapBits(bmResult.Handle,iSize,pBits);
 For j:=iY to iY+iHeight-1 do
  For i:=iX to iX+iWidth-1 do
   Begin
    k:=j*bmResult.Width*3+i*3;
    asm
     PUSHAD
     MOV ECX,pBits
     ADD ECX,k
     MOV EBX,iAlpha
     MOV AL,[ECX]
     MUL BL
     MOV [ECX],AH
     INC ECX
     MOV AL,[ECX]
     MUL BL
     MOV [ECX],AH
     INC ECX
     MOV AL,[ECX]
     MUL BL
     MOV [ECX],AH
     POPAD
    end
   End;
 SetBitmapBits(bmResult.Handle,iSize,pBits);
 FreeMem(pBits)
end;

procedure DrawBitmap24(iX,iY:integer;bmBitmap,bmAlpha:TBitmap;var bmResult:TBitmap);
 var
  pBitmap,pAlpha,pResult:pointer;
  iBitmapSize:integer;
  bmRes:TBitmap;
begin
 If (NOT TestBitmap24(bmBitmap)) OR (NOT TestBitmap24(bmAlpha)) OR
    (NOT TestBitmap24(bmResult)) OR
    (bmBitmap.Width<>bmAlpha.Width) OR
    (bmBitmap.Height<>bmAlpha.Height) Then Exit;
 bmRes:=TBitmap.Create;
 With bmRes, Canvas do
  Begin
   PixelFormat:=pf24bit;
   Width:=bmBitmap.Width;
   Height:=bmBitmap.Height;
   CopyRect(Rect(0,0,Width,Height),bmResult.Canvas,Rect(iX,iY,iX+Width,iY+Height))
  End;
 iBitmapSize:=bmBitmap.Width*bmBitmap.Height*3;
 GetMem(pBitmap,iBitmapSize);
 GetMem(pAlpha,iBitmapSize);
 GetMem(pResult,iBitmapSize);
 GetBitmapBits(bmBitmap.Handle,iBitmapSize,pBitmap);
 GetBitmapBits(bmAlpha.Handle,iBitmapSize,pAlpha);
 GetBitmapBits(bmRes.Handle,iBitmapSize,pResult);
 asm
  PUSHAD
  MOV ESI,pBitmap
  MOV EDI,pResult
  MOV EDX,pAlpha
  MOV ECX,iBitmapSize
  XOR EBX,EBX
@Met:
  MOV BL,[EDX]
  CMP BL,$00
  JZ @Empty
  PUSH EDX
  MOV AL,[ESI]
  MOV AH,AL
  CMP BL,$FF
  JZ @Met2
  XOR AL,AL
  XOR DX,DX
  DIV BX
  MOV DL,[EDI]
  CMP AL,DL
  JAE @Met1
  PUSH DX
  SUB DL,AL
  MOV AL,DL
  MUL BL
  POP DX
  SUB DL,AH
  MOV AH,DL
  JMP @Met2
@Met1:
  SUB AL,DL
  MUL BL
  ADD AH,DL
@Met2:
  MOV [EDI],AH
  POP EDX
@Empty:
  INC ESI
  INC EDI
  INC EDX
  LOOP @Met
  POPAD
 end;
 SetBitmapBits(bmRes.Handle,iBitmapSize,pResult);
 bmResult.Canvas.Draw(iX,iY,bmRes);
 FreeMem(pBitmap);
 FreeMem(pAlpha);
 FreeMem(pResult);
 bmRes.Free
end;

initialization
begin
 bmImage:=TBitmap.Create;
 Randomize
end;

finalization
begin
 bmImage.Free
end;

end.
