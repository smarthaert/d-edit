{ ���� ���ᮢ�� ࠡ��� "����� �� � ����ࠦ���� � �ந����� 
  ������ ᣫ�������� �㬮� ����� ����� �� ���न���" }
program kurs;

uses Graph, CRT;

const
  dy=600; dx=640;
  DirPos = 'images'; { ��⠫�� � ���⨭���� }

type
  Dim    = array [1..dx] of byte;
  DimPtr = ^Dim;
  PoI    = array [1..dy] of DimPtr;

var
  seektiff : longint;
  Wx  : longint; { ������ �� ��ਧ��⠫� }
  Wy  : longint; { ������ �� ���⨪��� }
  ImageFileName : string;
  po  : poi; { ��室��� ����ࠦ���� }
  pon : poi; { ����ࠦ���� � ���������� �㬮� }
  pof : poi; { ����ࠦ���� ��䨫��஢����� }


{ �⥭�� ��������� TIFF 䠩�� }
procedure HeadRead( var f:file );
const
  TH : array [0..3] of byte=(73,73,42,0); { II* - �����, ����� ���� � 
                                   ��砫� 䠩�� � ���������, �� �� ������ TIFF-䠩�  }
var
  NumberOfTag,IFDlength : integer;
  i,TagType,PoinTyp     : integer;
  comp,PoinAdr          : longint;
  head,IFDInd,BegIFD    : longint;
  TiffHead              : longint absolute TH;
begin
  BlockRead(f,head,4);
  if head<>TiffHead then begin
    Writeln('�� �� TIFF - 䠩�');
    Write('����� 䠩�� � ��ࠡ��뢠�� �� 㬥�');
    halt;
  end;

  BlockRead(f,BegIFD,4);
  Seek(f,BegIFD);
  BlockRead(f,NumberOfTag,2);

  IFDInd:=BegIFD+2;
  for i:=1 to NumberOfTag do begin
    BlockRead(f,TagType,2);
    case TagType of
      256: begin {ࠧ��� �� ��ਧ��⠫�}
             Inc(IFDInd,8);
             Seek(f,IFDInd);
             BlockRead(f,Wx,4);
           end;
      257: begin {ࠧ��� �� ���⨪���}
             IFDInd:=IFDInd+8;
             Seek(f,IFDInd);
             BlockRead(f,Wy,4);
           end;
      273: begin {��।������ ��砫� ������ ������}
             IFDInd:=IFDInd+2;
             Seek(f,IFDInd);
             BlockRead(f,PoinTyp,2);
             IFDInd:=IFDInd+2;
             Seek(f,IFDInd);
             BlockRead(f,comp,4);
             IFDInd:=IFDInd+4;
             Seek(f,IFDInd);
             if comp=1 then
               BlockRead(f,seektiff,4)
             else begin
               BlockRead(f,PoinAdr,4);
               Seek(f,PoinAdr);
               BlockRead(f,seektiff,PoinTyp);
             end;
           end;
      else begin
             IFDInd:=IFDInd+8;
           end;
    end; {case}
    Inc(IFDInd,4);
    Seek(f,IFDInd);
  end; {����砭�� �⥭�� Tag'��}
end; {HeadRead}

{ �뢮� ����� ���⨭�� �� ��࠭ }
{ dX,dY - ᬥ饭�� ���⨭�� �⭮�⥫쭮 ���孥�� ������ 㣫� ��࠭� }
procedure Show( Var Image : poi; dX,dY : integer );
var x,y,col : integer;
begin
  for y:=1 to Wy do
    for x:=1 to Wx do begin
      col:=Image[y]^[x];
      col:=col shr 4;
      putpixel(x+dX,y+dY,col);
    end;
end;

{ ��㧠 }
procedure Pause;
begin
  SetColor(15);
  OutTextXY(200,GetMaxY-20,'Press any key to continue...');
  ReadKey;
end;

function IntToStr( N : integer ):string;
var Result : string;
begin
  Str( N, Result );
  IntToStr := Result;
end;

{ �뢮� ����ࠦ���� �� ��࠭ }
procedure Vivod;
var
  y : integer;
begin
  for y:=0 to 15 do begin           {��⠭���� �������}
    SetRGBPalette(y,y*4,y*4,y*4);   {16  �ࠤ�権     }
    SetPalette(y,y);                {�ன 誠��      }
  end;

  if 3*Wx<638 then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Show( pof, 2*Wx+4, 10 );
  end else if 3*Wy<478 then begin
    Show( po, 0, 10 );
    Show( pon, 0, 10+2+Wy );
    Show( pof, 0, 10+2*Wy+4 );
  end else if (2*Wx<638) and (2*Wy<478) then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Show( pof, 0, 10+Wy+2 );
  end else if 2*Wy<478 then begin
    Show( po, 0, 10 );
    Show( pon, 0, 10+Wy+2 );
    Pause;
    Show( pon, 0, 10 );
    Show( pof, 0, 10+Wy+2 );
    Pause;
    Show( po, 0, 10 );
    Show( pof, 0, 10+Wy+2 );
  end else if 2*Wx<638 then begin
    Show( po, 0, 10 );
    Show( pon, Wx+2, 10 );
    Pause;
    Show( pon, 0, 10 );
    Show( pof, Wx+2, 10 );
    Pause;
    Show( po, 0, 10 );
    Show( pof, Wx+2, 10 );
  end else begin
    Show( po, 0, 10 );
    Pause;
    Show( pon, 0, 10 );
    Pause;
    Show( pof, 0, 10 );
  end;

  SetColor(15);
  OutTextXY(10,1,'File: "'+ImageFileName+'"');
  OutTextXY(GetMaxX-220,15,'Picture size: '+IntToStr(Wx)+' x '+IntToStr(Wy));

  Pause;
end;

{ �⢮��� ���������� ������ ��� ���⨭�� }
procedure AllocImage( var Image : PoI );
var y : integer;
begin
  for y:=1 to Wy do
    GetMem(Image[y],Wx);
end;

{ ���������� �㬠: po -> pon }                                           
procedure AddNoise;
var
  a, b, noise, x, y, bn : integer;
  k : byte;
begin
  writeln;
  writeln('= ���������� �㬠 =');
  writeln('������ �᫮ b (�⭮襭�� ᨣ���/��) �� 1 �� 255');
  repeat
    write('b = '); readln(b);
  until (b>=1) and (b<=255);
  a:=255 div b;

  AllocImage(pon);

  for y:=1 to Wy do 
    for x:=1 to Wx do begin
      { ����塞 �� ��� ������� ���ᥫ� ����ࠦ���� }
      noise := 0;
      for k:=0 to 5 do
        noise := noise + random(a) - a div 2;
      { ������塞 �� }
      bn := po[y]^[x] + noise;
      { �᫨ ��室 �� �࠭��� 0..255 => ��ࠢ�塞 }
      if bn<0 then bn:=0;
      if bn>255 then bn:=255;
      pon[y]^[x] := bn;
    end;
end;

{ ��������: pon -> pof }
procedure Filter;
var
  p1,p2,p3 : byte;
  x,y,n : integer;
begin
  writeln;
  writeln('= �������� =');
  writeln('�᫨ ᣫ������� �� y, � n=0, �� x - n=1');
  repeat
    write('������ n= '); readln(n);
  until (n=0) or (n=1);

  AllocImage(pof);

  { ��।�塞 �� y }
  if n=0 then
    for y:=2 to Wy-1 do
      for x:=1 to Wx do begin
        { ����塞 �।��� ���祭�� �� 3-� �ᥤ��� ���ᥫ�� }
        p1 := pon[y-1]^[x];
        p2 := pon[y]^[x];
        p3 := pon[y+1]^[x];
        p2 := (p1+p2+p3) div 3;
        pof[y]^[x] := p2;
      end;
  { ��।�塞 �� x }
  if n=1 then 
    for y:=1 to Wy do
      for x:=2 to Wx-1 do begin
        p1 := pon[y]^[x-1];
        p2 := pon[y]^[x];
        p3 := pon[y]^[x+1];
        p2 := (p1+p2+p3) div 3;
        pof[y]^[x] := p2;
      end;
end;

{ ����㧪� ���⨭�� }
procedure LoadImage;
var
  y,Size : integer;
  f      : file;
begin
  Writeln('����㦠� 䠩� "'+DirPos+'\'+ImageFileName+'"');
  Assign(f,DirPos+'\'+ImageFileName);
  Size:=1;
  Reset(f,Size);
  HeadRead(f); { �⥭�� ��������� TIFF-䠩�� }
  Seek(f,seektiff);

  AllocImage(po);

  for y:=1 to Wy do {��� ������ ��ப�...}
    BlockRead(f,po[y]^,Wx);  {����� ��ப� �� 䠩��}
                  {�⥭�� ������ �� ��⨯���஢������}
                  {䠩�� f � ���������� ������     }
                  {Wx*Wy-�᫮ �⠥��� ����         }
  close(f);     {������� 䠩�}
end;

{ �ᯮ���⥫쭠� ���� }
var Driv,Mode : integer;
Begin
  { �뢮��� ���ᠭ�� �ணࠬ�� � ��� ����⨥ �� ������ }
  clrscr;
  writeln('������ �ணࠬ�� �ந������ ���㬫���� ����ࠦ����');
  writeln('� �ந������ ������ ᣫ�������� �㬮�');
  writeln('����� ����� �� ���न���');
  writeln;
  writeln('����: ���㭮�� �������, ��㯯� 7106');
  writeln;
  writeln('������ ���� ������� ��� �த�������...');
  readkey;

  clrscr;
  If ParamCount > 0 then
    ImageFileName := ParamStr(1)
  else begin
    Write('������ ��� 䠩�� �� ��⠫��� "'+DirPos+'": ');
    Readln(ImageFileName);
  end;
  if ImageFileName='' then begin
    ImageFileName:='mouseb.tif';
    Writeln('�ᯮ������ ���⨭�� "��-㬮�砭��" - "'+ImageFileName+'"');
  end;

  LoadImage;
  Writeln('����� ��⠫���: ',MemAvail);

  AddNoise; { ���������� �㬠 }
  Writeln('����� ��⠫���: ',MemAvail);

  Filter; { �������� }
  Writeln('����� ��⠫���: ',MemAvail);

  { ���室 � ����᪨� ०�� }
  Driv:=9; Mode:=2;
  InitGraph(Driv,Mode,'');
  Vivod;
  Closegraph; { ������� ����᪨� ०�� }
End.

