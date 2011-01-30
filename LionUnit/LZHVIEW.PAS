
{   This program was edited in Moscow Crack Laboratory
                    by File Sponge                      }

program LZHView;

uses
  Crt, Dos;

type
  FileHeaderType = record
    HeadSize,HeadChk           : Byte;
    HeadID                     : Packed Array [1..5] of Char;
    PackSize,OrigSize,FileTime : LongInt;
    Attr                       : Word;
    FileName                   : PathStr;
  end;


var
  Fh        : FileHeaderType;
  Fha       : Array [1..SizeOf(FileHeaderType)] of Byte Absolute Fh;
  CRC       : Word;   { CRC Value }
  CRCBuf    : Array[1..2] of Byte Absolute CRC;
  CRC_Table : Array[0..255] of Word;
  InFile    : File;

  L1,L2,OldFilePos : Longint;
  Count            : Integer;
  Numread, I       : Word;
  S1               : String[50];
  S2               : String[20];

label
  Done;

procedure  Make_CRC_Table;
  var
    I,Index,AX : Word;
    Carry      : Boolean;
  begin
    Index:=0;
    repeat
      AX:=Index;
      for I:=1 to 8 do
        begin
          Carry:=Odd(AX);
          AX:=AX SHR 1;
          if Carry then
            AX:=AX XOR $A001;
        end;
      CRC_Table[Index]:=AX;
      Inc(Index);
    until Index>255;
  end;

{ Use this procedure to calculate the CRC value of the original
  file : Call it after reading every byte from the file         }

procedure CalcCRC(Data:Byte);
  var
    Index : Integer;
  begin
    CRCBuf[1]:=CRCBuf[1] XOR Data;
    Index:=CRCBuf[1];
    CRC:=CRC SHR 8;
    CRC:=CRC XOR CRC_Table[Index];
  end;


{ Calculate check sum for file header }

function MKSum:Byte;
  var
    I : Integer;
    B : Byte;
  begin
    B:=0;
    for I:=3 to Fh.HeadSize+2 do
      B:=B+Fha[I];
    MKSum:=B;
  end;

{ Format of 'LZH' file }
{

  [fileheader]
  [CRC]  <--crc value(2 bytes)
  [compressed data]    <--- first file

  [fileheader]
  [CRC]
  [compressed data]    <--- second file
      .
      .
      .
  [fileheader]         <--- last file
  [CRC]
  [compressed data]

  0                    <--- a zero indicates end of LZH archive



fileheader:
  Headsize = size of file header in bytes
  Headchk  = check sum of fileheader, obtained using mksum
  HeadID   = 5 characters,
             either '-lh0-  (file is not compressed, simply stored)
             or     '-lh1-' (file is compressed)

  PackSize = compressed size of file

  OrigSize = original size of file
  FileTime = time/date of file;
  Attr     = attribue of file;
  FileName = the filename,a string in PASCAL;



  Use the function 'Make_CRC_Table' to set up the CRC table before
  every compression.
  Use the 'CalcCRC(Byte)' to work out the CRC value.

}

procedure ViewLZH;
  label
    Done;
  var
    L1,L2,OldFilePos : Longint;
    Count            : Integer;
    Numread, I       : Word;
    S1               : String[50];
    S2               : String[20];

  begin
    Assign(InFile,ParamStr(1));
    Reset(infile,1);
    gotoxy(3,wherey);
    writeln('Filename      Original  PackSize  Ratio');

    oldfilepos:=0;
    count:=1;
    repeat
      seek(infile,oldfilepos);
      blockread(infile,fha,sizeof(fileheadertype),numread);
      oldfilepos:=oldfilepos+fh.headsize+2+fh.packsize;
     i:=mksum;
     if fh.headsize<>0 then
       begin
         if i<>fh.headchk then
           begin
             writeln('Checksum error in file');
             goto done;
           end;
         gotoxy(3,wherey);
         write(fh.filename);
         gotoxy(15,wherey);
         write(fh.origsize:10);
         write(fh.packsize:10);
         l1:=fh.packsize;
         l2:=fh.origsize;
         if l2>2147400 then
           begin
             l2:=l2 div 1000;
           end
         else l1:=l1*1000;
         l1:=l1 div l2;
         writeln(l1 div 10:4,'.',l1 mod 10:1,'%');
       end;
    until   (fh.headsize=0);


  done:
    close(infile);
  end;

begin
  WriteLn('   컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  WriteLn('        LZH File Viewer  Version 1.0');
  WriteLn('   컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  if ParamCount<1 then
    begin
      WriteLn('         Usage :  LZHVIEW  filename');
      Halt(1)
    end;
  Assign(InFile,ParamStr(1));
  Reset(InFile,1);
  WriteLn('   Filename     Original  Packsize  Ratio');
  WriteLn('   컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  OldFilePos:=0;
  Count:=1;
  repeat
    Seek(InFile,OldFilePos);
    BlockRead(InFile,Fha,SizeOf(FileHeaderType),NumRead);
    OldFilePos:=OldFilePos+Fh.HeadSize+2+Fh.PackSize;
    I:=MKSum;
    if Fh.HeadSize<>0 then
      begin
        if I<>Fh.HeadChk then
          begin
            WriteLn('           Checksum error in file');
            Goto Done;
          end;
        Write('   ',Fh.FileName);
        GotoXY(15,WhereY);
        Write(Fh.OrigSize:10);
        Write(Fh.PackSize:10);
        L1:=Fh.PackSize;
        L2:=Fh.OrigSize;
        if L2>2147400 then
          begin
            L2:=L2 DIV 1000
          end
        else
          L1:=L1*1000;
        L1:=L1 DIV L2;
        WriteLn(L1 DIV 10:4,'.',L1 MOD 10:1,'%');
      end;
  until (Fh.HeadSize=0);
Done:
  WriteLn('   컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
  Close(InFile);
end.