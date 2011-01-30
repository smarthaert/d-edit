Unit LSData;

Interface

Type
  TDataFile = Object
    F : File; { Data File }
    Constructor Open( FileName:String );
    Destructor Close;
    Function Load( ObjName:String; Var Buf ):Byte;
    Function GetSize( ObjName:String; Var Size:LongInt ):Byte;
    Function Save( ObjName:String; Var Buf; Size:LongInt ):Byte;
    Function SaveRLE( ObjName:String; Var Buf; Size:LongInt ):Byte;
    Function SaveLZH( ObjName:String; Var Buf; Size:LongInt ):Byte;
    Function MakeDir( DirName:String ):Byte;
    Function DelDir( DirName:String ):Byte;
    Function Del( ObjName:String ):Byte;
    Function RepackTo( NewDataFileName:String ):Byte;
    Function Create:Byte; 
  End;

{ ���� ������ }
Const erOK = 0; { �� �⫨筮 }
      erFileNotFound = 1; { Data-䠩� �� ������ }
      erPathNotFound = 2; { ���� � ��쥪�� �� �����㦥� }
      erObjNotFound = 3; { ��쥪� �� ������ }
      erObjDeleted = 4; { ��쥪� 㤠��� }
      erUnknownFormat = 5; { ���ࠢ���� ��������� }

Const DataFileHeader : String = 'LSDataHeader';

Implementation

Type
  TDirEntry = Record
    Name  : String[12]; { ��� ��쥪�/��⠫��� }
    Attr  : Byte; { ���ਡ��� ⨯� ��쥪� }
    Start : LongInt; { ���� ���� �� ��砫� 䠩�� }
    Size  : LongInt; { ������ ��쥪� � ����� }
  End;

{ Attr - ��⮢�� ����, �����祭�� �⤥���� ��⮢ }
{ ��� 7 - deleted-0; not_deleted-1 }
{ ��� 6 - object-0; folder-1 }
{ ��� 5 - uncompressed-0; compressed-1 }
{ ��� 4 - (if compressed) compression method RLE-0; LZH-1 }
{ ���� 3,2,1,0 - object type (for universal viewers) 0..15 }
{ For example: 0-BitmapPicture256 1-BitmapPicture64K 3-BitmapPicture16M ... }

Constructor TDataFile.Open( FileName:String );
  Begin
    Assign(F,FileName);
  End;

Destructor TDataFile.Close;
  Begin
    System.Close(F);
  End;

Function TDataFile.Load( ObjName:String; Var Buf ):Byte;
  Begin
  End;

Function TDataFile.GetSize( ObjName:String; Var Size:LongInt ):Byte;
  Begin
  End;

Function TDataFile.Save( ObjName:String; Var Buf; Size:LongInt ):Byte;
  Begin
  End;

Function TDataFile.SaveRLE( ObjName:String; Var Buf; Size:LongInt ):Byte;
  Begin
  End;

Function TDataFile.SaveLZH( ObjName:String; Var Buf; Size:LongInt ):Byte;
  Begin
  End;

Function TDataFile.MakeDir( DirName:String ):Byte;
  Begin
  End;

Function TDataFile.DelDir( DirName:String ):Byte;
  Begin
  End;

Function TDataFile.Del( ObjName:String ):Byte;
  Begin
  End;

Function TDataFile.RepackTo( NewDataFileName:String ):Byte;
  Begin
  End;

Function TDataFile.Create:Byte;
  Begin
  End;

End.