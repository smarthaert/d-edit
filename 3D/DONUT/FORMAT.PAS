Unit Format;

Interface

Uses NColor,Fade,Filer;

Function LoadPCX(FileName:String; Var P:Pointer; Var Pal:TPal):Boolean;
{Function LoadGIF(FileName:String; Var P:Pointer; Var Pal:TPal):Boolean;}
Function LoadBMP(FileName:String; Var P:Pointer; Var Pal:TPal):Boolean;
Function SavePCX(FileName:String; P:Pointer; Pal:TPal):Boolean;
{Function SaveGIF(FileName:String; P:Pointer; Pal:TPal):Boolean;}
Function SaveBMP(FileName:String; P:Pointer; Pal:TPal):Boolean;

Type PCXHeader=Record
                     ManuFacturer,
                     Version,
                     Encoding,
                     Bits_Per_Pixel:Byte;
                     XMin,YMin,XMax,YMax,
                     HRes,VRes:Word;
                     Palette:Array[0..47] Of Byte;
                     Reserved:Byte;
                     Color_Planes:Byte;
                     Bytes_Per_Line:Word;
                     Palette_Type:Word;
                     Filler:Array[0..57] Of Byte;
               End;

Type BMPHeader=Record
                     Id:Array [0..1] Of Char;
                     Size:LongInt;
                     Reserved:LongInt;
                     ImageStart:LongInt;
                     HeaderSize:LongInt;
                     SizeX:LongInt;
                     SizeY:LongInt;
                     Planes:Word;
                     Bits_Per_Pixel:Word;
                     Encoding:LongInt;
                     ImageSize:LongInt;
                     HRes,VRes:LongInt;
                     UsedColors:LongInt;
                     BlueComp,GreenComp,RedComp:Byte;
                     Filler:Byte;
               End;

Implementation

Function LoadPCX;

Var F:File;
    Header:PCXHeader;
    I:Integer;
    V:Byte;
    GOfs,J:Word;
    K,Loop:Byte;

{    Block:Pointer;
    Blocksize:Word;{}

Begin
     LoadPCX:=False;
     If FileExist(FileName) Then
        Begin
             Assign(F,FileName);
             Reset(F,1);
             BlockRead(F,Header,SizeOf(Header));
             Seek(F,FileSize(F)-769);
             BlockRead(F,V,1);
             If (Header.ManuFacturer=10) And
                (Header.Version=5) And
                (Header.Bits_Per_Pixel=8) And
                (Header.Color_Planes=1) And
                (V=$0c) Then
                Begin
                     LoadPCX:=True;
                     BlockRead(F,Pal,768);
                     For I:=0 To 255 Do
                         For J:=0 To 2 Do
                             Pal[I,J]:=Pal[I,J] ShR 2;
                     Seek(F,128);
                     OpenSprite(P,Header.XMax-Header.XMin+1,Header.YMax-Header.YMin+1);

{                     BlockSize:=FileSize(F)-FilePos(F);
                     GetMem(Block,BlockSize);
                     BlockRead(F,Block^,BlockSize);
                     Asm
                        push ds
                        les di,P
                        add di,4
                        lds si,Block
                        mov cx,Header.YMax
                        sub cx,Header.YMin
                     @yfor:

                        dec cx
                        jnz @yfor

                        pop ds
                     End;
                     FreeMem(Block,BlockSize);}
                     GOfs:=Ofs(P^)+4;
                     For I:=0 To Header.YMax-Header.YMin+1 Do
                         Begin
                              J:=0;
                              While J<Header.Bytes_Per_Line Do
                                    Begin
                                         BlockRead(F,V,1);
                                         If (V And 192)=192 Then
                                            Begin
                                                 Loop:=V And 63;
                                                 Inc(J,Loop);
                                                 Blockread(F,V,1);
                                                 For K:=1 To Loop Do
                                                     Begin
                                                          Mem[Seg(P^):GOfs]:=V;
                                                          Inc(GOfs);
                                                     End;
                                            End
                                         Else
                                             Begin
                                                  Mem[Seg(P^):GOfs]:=V;
                                                  Inc(GOfs);
                                                  Inc(J);
                                             End;
                                    End;
                         End;
                End;
             Close(F);
        End;
End;

{Function LoadGIF;

Type GIFHeader=Record
                     Kennung:String[3];
                     Version:String[3];
                     LogScrDescrBlock:Record
                                            HRes:Word;
                                            VRes:Word;
                                            ResFlag:Byte;
                                            Background:Byte;
                                            PixelAspectRatio:Byte;
                                      End;
               End;
     ExtensionBlock=Record
                    End;
     ImgDescBlock=Record
                         ImgSepHeader:Byte;
                         X:Word;
                         Y:Word;
                         HRes:Word;
                         VRes:Word;
                         Flag:Byte;
                  End;

Begin



End;}

Function LoadBMP;

Var Header:BMPHeader;
    F:File;
    I:Integer;

Begin
     LoadBMP:=False;
     If FileExist(FileName) Then
        Begin
             Assign(F,FileName);
             ReSet(F,1);
             BlockRead(F,Header,SizeOf(Header));
             If (Header.Id='BM') And
                ((Header.Bits_Per_Pixel=8) Or (Header.Bits_Per_Pixel=0))And
                (Header.Encoding=0) And
                ((Header.Planes=1) Or (Header.Planes=0))Then
                Begin
                     LoadBMP:=True;
                     GetMem(P,1024);
                     BlockRead(F,P^,1024);
                     For I:=0 To 255 Do
                         Begin
                              Pal[I,0]:=Byte(Ptr(Seg(P^),
                                        Ofs(P^)+(I ShL 2)+2)^) ShR 2;
                              Pal[I,1]:=Byte(Ptr(Seg(P^),
                                        Ofs(P^)+(I ShL 2)+1)^) ShR 2;
                              Pal[I,2]:=Byte(Ptr(Seg(P^),
                                        Ofs(P^)+(I ShL 2)+0)^) ShR 2;
                         End;
                     FreeMem(P,1024);
                     Seek(F,Header.ImageStart);
                     OpenSprite(P,Header.SizeX,Header.SizeY);
                     For I:=Header.SizeY-1 DownTo 0 Do
                         BlockRead(F,Ptr(Seg(P^),Ofs(P^)+4+I*Header.SizeX)^,Header.SizeX);
                End;
             Close(F);
        End;
End;

Function SavePCX;

Var F:File;

Procedure WriteHeader;

Var Header:PCXHeader;

Begin
     With Header Do
          Begin
               Manufacturer:=10;
               Version:=5;
               Encoding:=1;
               Bits_Per_Pixel:=8;
               XMin:=0;
               YMin:=0;
               XMax:=GetSpriteXL(P)-1;
               YMax:=GetSpriteYL(P)-1;
               HRes:=XMax+1;
               VRes:=YMax+1;
               {Palette:=??? 16 Farbenpalette}
               Reserved:=0;
               Color_Planes:=1;
               Bytes_Per_Line:=HRes;
               Palette_Type:=0;
               FillChar(Filler,58,0);
          End;
     BlockWrite(F,Header,SizeOf(Header));
End;

Procedure WritePalette;

Var I,J:Byte;

Begin
     I:=$0c;
     BlockWrite(F,I,1);
     For I:=0 To 255 Do
         For J:=0 To 2 Do
             Pal[I,J]:=Pal[I,J] ShL 2;
     BlockWrite(F,Pal,SizeOf(Pal));
End;

Procedure EncodeLine(L:Byte);

Var I,T:Word;
    A:Byte;

Begin
     T:=1;
     While T<=GetSpriteXL(P) Do
           Begin
                I:=0;
                While (GetSpritePixel(P,T+I,L)=GetSpritePixel(P,T+I+1,L)) And
                      (T+I<=GetSpriteXL(P)) And
                      (I<63) Do Inc(I);
                If I>0 Then
                   Begin
                        A:=I Or 192;
                        BlockWrite(F,A,1);
                        A:=GetSpritePixel(P,T,L);
                        BlockWrite(F,A,1);
                        Inc(T,I);
                   End
                Else Begin
                          If (((GetSpritePixel(P,T,L)) And 192)=192) Then
                             Begin
                                  A:=193;
                                  BlockWrite(F,A,1);
                             End;
                          A:=GetSpritePixel(P,T,L);
                          BlockWrite(F,A,1);
                          Inc(T);
                     End;
           End;
End;

Var LineNumber:Byte;

Begin
     SavePCX:=True;
     Assign(F,FileName);
     {$I-}
     Rewrite(F,1);
     {$I+}
     If IOResult<>0 Then
        Begin
             SavePCX:=False;
             Exit;
        End;
     WriteHeader;
     For LineNumber:=1 To GetSpriteYL(P) Do
         EncodeLine(LineNumber);
     WritePalette;
     Close(F);
End;

Function SaveBMP;

Var F:File;
    Header:BMPHeader;
    Temp:Pointer;
    I:Integer;

Begin
     SaveBMP:=False;
     Assign(F,FileName);
     {$I-}
     ReWrite(F,1);
     {$I+}
     If IOResult<>0 Then Exit;
     With Header Do
          Begin
               Id:='BM';
               ImageStart:=SizeOf(Header)+1024;
               HeaderSize:=40;                 {?}
               SizeX:=GetSpriteXL(P);
               SizeY:=GetSpriteYL(P);
               Planes:=1;
               Bits_Per_Pixel:=8;
               Encoding:=0;
               ImageSize:=SizeX*SizeY;
               HRes:=SizeX;
               VRes:=SizeY;
               UsedColors:=256;
               BlueComp:=255;
               GreenComp:=255;
               RedComp:=255;
               Size:=ImageStart+ImageSize;
          End;
     BlockWrite(F,Header,SizeOf(Header));
     GetMem(Temp,1024);
     For I:=0 To 255 Do
         Begin
              Byte(Ptr(Seg(Temp^),Ofs(Temp^)+(I ShL 2)+0)^):=Pal[I,2] ShL 2;
              Byte(Ptr(Seg(Temp^),Ofs(Temp^)+(I ShL 2)+1)^):=Pal[I,1] ShL 2;
              Byte(Ptr(Seg(Temp^),Ofs(Temp^)+(I ShL 2)+2)^):=Pal[I,0] ShL 2;
              Byte(Ptr(Seg(Temp^),Ofs(Temp^)+(I ShL 2)+3)^):=0;
         End;
     BlockWrite(F,Temp^,1024);
     FreeMem(Temp,1024);
     For I:=Header.SizeY-1 DownTo 0 Do
         BlockWrite(F,Ptr(Seg(P^),Ofs(P^)+4+I*Header.SizeX)^,Header.SizeX);
     Close(F);
     SaveBMP:=True;
End;

End.
