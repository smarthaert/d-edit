Unit ATTools;

Interface

Uses Dos,Tasten;

Const Text1='Visit http://www.datacomm.ch/asuter';

Procedure CursorOff;
Procedure CursorOn;
Procedure SetChar(X,Y:Word; C:Char);
Function GetChar(X,Y:Word):Char;
Procedure Input(Message:String;Var s:String;MaxLength:Integer);
Procedure SetCursor(x,y:Byte);
Procedure Wait(Time:Word);
Function Dez2Hex(i:LongInt):String;
Function GetCursorX:Byte;
Function GetCursorY:Byte;
Function Hex2Dez(s:String):LongInt;
Function Hoch(Faktor:Word; Exponent:Byte):LongInt;
Function Int2Str(i:LongInt):String;
Function Str2Int(s:String):LongInt;
Function Timer:LongInt;
Function UpString(s:String):String;

Implementation

Var CursorTop,CursorBottom:Byte;

Procedure CursorOff;Assembler;

Asm
   mov ah,$03
   mov bh,$00
   int 10h
   mov CursorTop,ch
   mov CursorBottom,cl
   mov ah,$01
   mov cx,$2000
   int 10h
End;

Procedure CursorOn;Assembler;

Asm
   mov ah,$01
   mov ch,CursorTop
   mov cl,CursorBottom
   int 10h
End;

Procedure SetChar;Assembler;

Asm
   mov ax,$b800
   mov es,ax
   mov di,X
   sub di,81
   mov ax,80
   mul y
   add di,ax
   shl di,1
   mov al,C
   stosb
End;

Function GetChar;Assembler;

Asm
   push ds
   mov ax,$b800
   mov ds,ax
   mov si,X
   sub si,81
   mov ax,80
   mul y
   add si,ax
   shl si,1
   lodsb
   pop ds
End;

Procedure Input;

Var Ch:Char;
    ss:String;

Begin
     ss:=s;
     Write(Message);
     Write(ss);
     Repeat
           Ch:=Chr(ReadByte);
           If Ch=#8 Then
              If Length(ss)>0 Then
                 Begin
                      Delete(ss,Length(ss),1);
                      Write(#8,' ',#8);
                 End;
           If Ch=#32 Then
              If (Length(ss)<MaxLength) {And
                 (GetChar(WhereX+1,WhereY)=' ') }Then
                 Begin
                      ss:=ss+' ';
                      Write(' ');
                 End;
           If Ord(Ch)>32 Then          {Irgendwie Funktioniert das nicht}
              If (Length(ss)<MaxLength){ And
                 (GetChar(WhereX+1,WhereY)=' ')} Then
                 Begin
                      ss:=ss+Ch;
                      Write(Ch);
                 End;
     Until (Ch=#13) Or
           (Ch=#27);
     If Ch=#13 Then s:=ss
               Else s:='';
End;

Procedure SetCursor;Assembler;

Asm
   mov dl,x
   dec dl
   mov dh,y
   dec dh
   mov ah,$02
   mov bh,$00
   int 10h
End;

Procedure Wait;Assembler;

Asm
   mov ax,$03e8
   mul Time
   mov cx,dx
   mov dx,ax
   mov ah,$86
   int 15h
End;

Function Dez2Hex;

Var s:String;
    h:Integer;

Begin
     s:='';
     Repeat
           h:=i Mod 16;
           Case h Of
                10..15:s:=Concat(Chr(65+(h-10)),s);
           Else
               s:=Concat(Int2Str(h),s);
           End;
           i:=i Div 16;
     Until i=0;
     Dez2Hex:=s;
End;

Function GetCursorX;Assembler;

Asm
   mov ah,$03
   mov bh,$00
   int 10h
   mov al,dl
   inc al
End;

Function GetCursorY;Assembler;

Asm
   mov ah,$03
   mov bh,$00
   int 10h
   mov al,dh
   inc al
End;

Function Hex2Dez;

Var i,d,h,c:Integer;

Begin
     d:=0;
     s:=UpString(s);
     If Length(s)>=1 Then
        For i:=Length(s) DownTo 1 Do
            Begin
                 Case s[i] Of
                      '0'..'9':Val(s[i],h,c);
                 Else
                     h:=Ord(s[i])-55;
                 End;
                 d:=d+(h*Hoch(16,Length(s)-i));
            End;
     Hex2Dez:=d;
End;

Function Hoch;Assembler;

Asm
   mov ax,1
   xor dx,dx
   mov cl,Exponent
   xor ch,ch
   cmp cx,0
   jz @Ende
@repeat:
   mul Faktor
   loop @repeat
@Ende:
End;

Function Int2Str;

Var s:String;

Begin
     Str(i,s);
     Int2Str:=s;
End;

Function Str2Int;

Var i,Code:Integer;

Begin
     Val(s,i,Code);
     Str2Int:=i;
End;

Function Timer;

Var h,m,s,hs:Word;
    t:LongInt;

Begin
     t:=0;
     GetTime(h,m,s,hs);
     Inc(t,60*60*100*h);
     Inc(t,60*100*m);
     Inc(t,100*s);
     Inc(t,hs);
     Timer:=t;
End;

Function UpString(S:String):String;Assembler;

Asm
   les di,[bp+8]
   mov dx,ds
   lds si,S
   lodsb
   stosb
@rep:
   lodsb
   mov ah,al
   sub ah,97
   cmp ah,26
   jae @noup
   sub al,97-65
@noup:
   stosb
   dec al
   jnz @rep
   mov ds,dx
End;

begin
     writeln(text1);
End.
