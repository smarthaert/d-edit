Unit Clr_Nat;

Interface

 Uses Video;

 Const
   MaxNumNation=6;
   NumDefNation=0;
   MinNumNation=NumDefNation;

 Type
   NumNation=MinNumNation..MaxNumNation;
   PNationColor=^TNationColor;
   TNationColor=
     Record
       Light,
       Normal,
       Dark:Byte;
     End;
   PNationSprite=^TNationSprite;
   TNationSprite=
     Object(TStdSprite)
       Procedure PutNatXY(X,Y:Word;Nation:NumNation);
       Procedure PutNatCenter(X,Y:Word;Nation:NumNation);
     End;

 Const
   NationColors:Array[NumNation]of TNationColor=
     ((Light:27;Normal:23;Dark:19)
     ,(Light:9;Normal:32;Dark:1)
     ,(Light:14;Normal:43;Dark:6)
     ,(Light:13;Normal:5;Dark:108)
     ,(Light:11;Normal:3;Dark:124)
     ,(Light:10;Normal:2;Dark:120)
     ,(Light:12;Normal:40;Dark:4));

Implementation

 Procedure TNationSprite.PutNatXY;
   Var
     P,PS:Pointer;
     XS,YS,Light,Normal,Dark:Byte;
 Begin
    If Pic=Nil then Exit;
    P:=Pic;
    PS:=CurScr;
    XS:=XSize;
    YS:=YSize;
    Light :=NationColors[Nation].Light ;
    Normal:=NationColors[Nation].Normal;
    Dark  :=NationColors[Nation].Dark  ;
    Asm
      Mov  DX,Y
      Mov  CX,X
      Mov  AX,DX
      Shl  DX,8
      Shl  AX,6
      Add  DX,AX
      Add  DX,CX
      Mov  CH,YS
      Mov  CL,XS
      Mov  AH,Light
      Mov  BH,Normal
      Mov  BL,Dark
      Push DS
      Push AX
      LES  AX,PS
      LDS  SI,P
      Add  DX,AX
      Pop  AX
     @@Line:
      Mov  DI,DX
      Push CX
     @@Pix:
      Mov AL,DS:[SI]
      Mov CH,AL
      And CH,0FFh-3
      Cmp CH,0FFh-3
      JNE @@Put
      And AL,03h
      Cmp AL,2
      JZ @@PutL
      JNC @@NoPut
      JP @@PutN
      Mov AL,BL
      JMP @@Put
     @@PutL:
      Mov AL,AH
      JMP @@Put
     @@PutN:
      Mov AL,BH
     @@Put:
      Mov ES:[DI],AL
     @@NoPut:
      Inc SI
      Inc DI
      Xor CH,CH
      Loop @@Pix
      Pop  CX
      Add  DX,320
      Dec  CH
      JNZ  @@Line
      Pop  DS
    End;
 End;

 Procedure TNationSprite.PutNatCenter;
 Begin
    PutNatXY(X-(XSize Div 2),Y-(YSize Div 2),Nation);
 End;

End.