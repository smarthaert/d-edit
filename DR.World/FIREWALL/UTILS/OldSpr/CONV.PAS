Uses Dos;



Procedure ConvFile(FileName:PathStr;Dark,Normal,Light,Mask:Byte);
  Var
    FS,FD:File;
    S:PathStr;
    Header:Array[1..3]of Word;
    FSize,NFSize,Count,I:Word;
    Buf:Array[1..100]of Byte;
Begin
   S:=FSearch('Old\'+FileName,'');
   If S='' then Exit;
   Write('Converting File ',Filename,' : ');
   Assign(FS,S);
   Assign(FD,FileName);
   Reset(FS,1);
   Rewrite(FD,1);
   BlockRead(FS,Header,6);
   BlockWrite(FD,Header,6);
   FSize:=Header[2]*Header[3];
   NFSize:=FSize;
   While NFSize>0 do
     Begin
        Count:=NFSize;
        If Count>100 then Count:=100;
        BlockRead(FS,Buf,Count);
        Dec(NFSize,Count);
        For I:=1 to 100 do
          Begin
             If Buf[I]=Dark   then Buf[I]:=252;
             If Buf[I]=Normal then Buf[I]:=253;
             If Buf[I]=Light  then Buf[I]:=254;
             If Buf[I]=Mask   then Buf[I]:=255;
          End;
        BlockWrite(FD,Buf,Count);
        Write('*');
     End;
   Close(FD);
   Close(FS);
   WriteLn(' Done');
End;

Procedure ConvAll;
  Var
    DirInfo:SearchRec;
Begin
  FindFirst('Old\*.SPR',Archive,DirInfo);
  While DosError=0 do
    Begin
       ConvFile(DirInfo.Name,1,32,9,255);
       FindNext(DirInfo);
    End;
End;

Begin
   WriteLn('SpriteFile Convertor');
   WriteLn;
   WriteLn('Begin');
   WriteLn;
   ConvAll;
   WriteLn;
   WriteLn('End');
   WriteLn;
End.