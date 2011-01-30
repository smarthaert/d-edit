Unit Fade;

Interface

Const JASCId:Array [1..8] Of Char='JASC-PAL';

Type TCol=Array [0..2] Of Byte;
     TPal=Array [0..255] Of TCol;

Procedure LoadPal(Var Pal:TPal; FileName:String);
Procedure SavePal(Pal:TPal; FileName:String);
Function LoadJASC(Var Pal:TPal; FileName:String):Boolean;
Function SaveJASC(Pal:TPal; FileName:String):Boolean;
Procedure GetPalette(Var Pal:TPal);
Procedure SetPalette(Pal:TPal);
Procedure FadeOut;
Procedure FadeOutPal(Pal:TPal);
Procedure FadeTo(ToPal:TPal);
Procedure FadeToPal(Pal,ToPal:TPal);
Procedure FadeOutColor(Col:Byte);
Procedure FadeOutPalColor(Var Col:TCol);
Procedure FadeToColor(Col,ToR,ToG,ToB:Byte);
Procedure FadeToPalColor(Var Col:TCol; ToR,ToG,ToB:Byte);
Procedure CycleLeft(First,Last:Byte);
Procedure CyclePalLeft(Var Pal:TPal; First,Last:Byte);
Procedure CycleRight(First,Last:Byte);
Procedure CyclePalRight(Var Pal:TPal; First,Last:Byte);
Procedure Ramp(StartColor,RStart,GStart,BStart,EndColor,REnd,GEnd,BEnd:Byte);
Procedure RampPal(Var Pal:TPal; StartColor,RStart,GStart,BStart,EndColor,REnd,GEnd,BEnd:Byte);

Implementation

Uses NColor,ATTools;

Procedure LoadPal;

Var F:File Of TPal;

Begin
     Assign(F,FileName);
     ReSet(F);
     Read(F,Pal);
     Close(F);
End;

Procedure SavePal;

Var F:File Of TPal;

Begin
     Assign(F,FileName);
     ReWrite(F);
     Write(F,Pal);
     Close(F);
End;

Function LoadJASC;

Var F:Text;
    T:String;
    Anz,I:Word;

Begin
     LoadJASC:=False;
     Assign(F,FileName);
     {$I-}
     ReSet(F);
     {$I+}
     If IOResult<>0 Then Exit;
     ReadLn(F,T);
     If T<>JASCId Then Exit;
     ReadLn(F,T);
     Anz:=Hex2Dez(T);
     ReadLn(F,T);
     If (Anz<>Str2Int(T)) Or (Anz>256) Then Exit;
     For I:=0 To Anz-1 Do
         Begin
              ReadLn(F,T);
              Pal[I,0]:=Str2Int(Copy(T,1,Pos(' ',T)-1)) Shr 2;Delete(T,1,Pos(' ',T));
              Pal[I,1]:=Str2Int(Copy(T,1,Pos(' ',T)-1)) Shr 2;Delete(T,1,Pos(' ',T));
              Pal[I,2]:=Str2Int(T) Shr 2;
         End;
     Close(F);
     LoadJASC:=True;
End;

Function SaveJASC;

Var F:Text;
    I:Word;

Begin
     SaveJASC:=False;
     Assign(F,FileName);
     {$I-}
     ReWrite(F);
     {$I+}
     If IOResult<>0 Then Exit;
     WriteLn(F,JASCId);
     WriteLn(F,'0100');
     WriteLn(F,'256');
     For I:=0 To 255 Do
         WriteLn(F,Int2Str(Pal[I,0] ShL 2)+' '+
                   Int2Str(Pal[I,1] ShL 2)+' '+
                   Int2Str(Pal[I,2] ShL 2));
     Close(F);
     SaveJASC:=True;
End;

Procedure GetPalette;Assembler;

Asm
   mov dx,$03c7
   xor al,al
   out dx,al
   les di,Pal
   add dx,2
   mov cx,256*3
   rep insb
End;

Procedure SetPalette;Assembler;

Asm
   mov dx,$03c8
   xor al,al
   out dx,al
   mov bx,ds
   lds si,Pal
   inc dx
   mov cx,256*3
   rep outsb
   mov ds,bx
End;

Procedure FadeOut;

Var I:Integer;

Begin
     For I:=0 To 255 Do
         FadeOutColor(I);
End;

Procedure FadeOutPal;

Var I:Integer;

Begin
     For I:=0 To 255 Do
         FadeOutPalColor(Pal[I]);
End;

Procedure FadeTo;

Var I:Integer;

Begin
     For I:=0 To 255 Do
         FadeToColor(I,ToPal[I,0],ToPal[I,1],ToPal[I,2]);
End;

Procedure FadeToPal;

Var I:Integer;

Begin
     For I:=0 To 255 Do
         FadeToPalColor(Pal[I],ToPal[I,0],ToPal[I,1],ToPal[I,2]);
End;

Procedure FadeOutColor;

Var I:Integer;
    R,G,B:Byte;

Begin
     R:=GetPalR(Col);
     G:=GetPalG(Col);
     B:=GetPalB(Col);
     If R>0 Then Dec(R);
     If G>0 Then Dec(G);
     If B>0 Then Dec(B);
     SetPal(Col,R,G,B);
End;

Procedure FadeOutPalColor;

Begin
     If Col[0]>0 Then Dec(Col[0]);
     If Col[1]>0 Then Dec(Col[1]);
     If Col[2]>0 Then Dec(Col[2]);
End;

Procedure FadeToColor;

Var I:Integer;
    R,G,B:Byte;

Begin
     R:=GetPalR(Col);
     G:=GetPalG(Col);
     B:=GetPalB(Col);
     If R<ToR Then Inc(R);
     If G<ToG Then Inc(G);
     If B<ToB Then Inc(B);
     If R>ToR Then Dec(R);
     If G>ToG Then Dec(G);
     If B>ToB Then Dec(B);
     SetPal(Col,R,G,B);
End;

Procedure FadeToPalColor;

Begin
     If Col[0]<ToR Then Inc(Col[0]);
     If Col[1]<ToG Then Inc(Col[1]);
     If Col[2]<ToB Then Inc(Col[2]);
     If Col[0]>ToR Then Dec(Col[0]);
     If Col[1]>ToG Then Dec(Col[1]);
     If Col[2]>ToB Then Dec(Col[2]);
End;

Procedure CycleLeft;

Var I:Byte;
    C:TCol;

Begin
     C[0]:=GetPalR(First);
     C[1]:=GetPalG(First);
     C[2]:=GetPalB(First);
     For I:=First To Last-1 Do
         SetPal(I,GetPalR(I+1),GetPalG(I+1),GetPalB(I+1));
     SetPal(Last,C[0],C[1],C[2]);
End;

Procedure CyclePalLeft;

Var I:Byte;
    C:TCol;

Begin
     C:=Pal[First];
     For I:=First To Last-1 Do
         Pal[I]:=Pal[I+1];
     Pal[Last]:=C;
End;

Procedure CycleRight;

Var I:Byte;
    C:TCol;

Begin
     C[0]:=GetPalR(Last);
     C[1]:=GetPalG(Last);
     C[2]:=GetPalB(Last);
     For I:=Last DownTo First+1 Do
         SetPal(I,GetPalR(I-1),GetPalG(I-1),GetPalB(I-1));
     SetPal(First,C[0],C[1],C[2]);
End;

Procedure CyclePalRight;

Var I:Byte;
    C:TCol;

Begin
     C:=Pal[Last];
     For I:=Last DownTo First+1 Do
         Pal[I]:=Pal[I-1];
     Pal[First]:=C;
End;

Procedure Ramp;

Var C:Byte;
    R,G,B:Real;

Begin
     If EndColor=StartColor Then
        Begin
             R:=0;
             G:=0;
             B:=0;
        End
     Else Begin
               R:=(REnd-RStart)/(EndColor-StartColor);
               G:=(GEnd-GStart)/(EndColor-StartColor);
               B:=(BEnd-BStart)/(EndColor-StartColor);
          End;
     For C:=StartColor To EndColor Do
         Begin
              SetPal(C,RStart+Round(R*(C-StartColor)),
                       GStart+Round(G*(C-StartColor)),
                       BStart+Round(B*(C-StartColor)));
         End;
End;

Procedure RampPal;

Var I:Word;
    R,G,B:Real;

Begin
     If EndColor=StartColor Then
        Begin
             R:=0;
             G:=0;
             B:=0;
        End
     Else Begin
               R:=(REnd-RStart)/(EndColor-StartColor);
               G:=(GEnd-GStart)/(EndColor-StartColor);
               B:=(BEnd-BStart)/(EndColor-StartColor);
          End;
     For I:=StartColor To EndColor Do
         Begin
              Pal[I,0]:=RStart+Round(R*(I-StartColor));
              Pal[I,1]:=GStart+Round(G*(I-StartColor));
              Pal[I,2]:=BStart+Round(B*(I-StartColor));
         End;
End;

End.