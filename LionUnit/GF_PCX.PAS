{ * GF_PCX - Графический формат PCX * }
Unit GF_PCX;

Interface

Uses Gr_MCGA,Run_Error;

Type { Заголовок PCX файла }
  PCXHeader = Record 
    Manufacturer,Version,Encoding,BitsPerPixel : Byte;
    xMin,yMin,xMax,yMax : Word;
    Other : Array [0..115] of Byte;
  End;
{ Загрузка PCX файла }
Procedure LoadPCX( FileName:String; Var Header:PCXHeader;
                     Var Pal:RGBPalette; Where:Pointer; Offset,_Width:Word );

Implementation

{ Загрузка PCX файла }
Procedure LoadPCX( FileName:String; Var Header:PCXHeader;
                     Var Pal:RGBPalette; Where:Pointer; Offset,_Width:Word );
  Var F:File;
      DataByte,HowMany:Byte;
      Pos,anz:Word;
      X,Y,C,Width:Word;
      Temp:pointer;
  Begin
    OpenFileRE(F,'PCX',FileName);
    BlockRead(F,Header,128);
    If (Header.Version<>5) or 
       (Header.xMax>319) or (Header.xMin<0) or
       (Header.yMax>200) or (Header.yMin<0) then 
      Begin Close(F); RuntimeError('Error in "'+FileName+'"'); End;
   { Load palette }
    Seek(F,FileSize(F)-SizeOf(Pal));
    BlockRead(F,Pal,SizeOf(Pal));
   { Load image }
    Seek(F,128);
    Y:=Header.yMin; X:=Header.xMin;
    If _Width = 0 then 
      Width:=Header.xMax-Header.xMin+1 Else Width:=_Width;
    GetMem(Temp,64000);
    Repeat
      Pos:=0; BlockRead(F,Temp^,64000,Anz);
      While (Y<=Header.yMax) and (Pos<anz) do
        Begin
          HowMany:=1;
          DataByte := Mem[Seg(Temp^):Ofs(Temp^)+Pos]; Inc(Pos);
          If ((DataByte and $C0) = $C0) then
            Begin
              HowMany := DataByte And $3F;
              DataByte := Mem[Seg(Temp^):Ofs(Temp^)+Pos]; Inc(Pos);
            End;
          For C:=1 to HowMany do
            Begin
              Mem[Seg(Where^):Ofs(Where^)+Offset+X+Y*Width] := DataByte;
              Inc(X);
              If X>Header.xMax then Begin Inc(Y); X:=Header.xMin; End;
            End;
        End;
    Until (Y<=Header.yMax) OR (Anz=0);
    FreeMem(Temp,64000);
    Close(F);
  End;

End.