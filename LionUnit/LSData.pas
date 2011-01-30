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

{ Коды возврата }
Const erOK = 0; { Все отлично }
      erFileNotFound = 1; { Data-файл не найден }
      erPathNotFound = 2; { Путь к обьекту не обнаружен }
      erObjNotFound = 3; { Обьект не найден }
      erObjDeleted = 4; { Обьект удален }
      erUnknownFormat = 5; { Неправильный заголовок }

Const DataFileHeader : String = 'LSDataHeader';

Implementation

Type
  TDirEntry = Record
    Name  : String[12]; { Имя обьекта/каталога }
    Attr  : Byte; { Аттрибуты типа обьекта }
    Start : LongInt; { Адрес обькта от начала файла }
    Size  : LongInt; { Размер обьекта в байтах }
  End;

{ Attr - битовое поле, назначение отдельных битов }
{ Бит 7 - deleted-0; not_deleted-1 }
{ Бит 6 - object-0; folder-1 }
{ Бит 5 - uncompressed-0; compressed-1 }
{ Бит 4 - (if compressed) compression method RLE-0; LZH-1 }
{ Биты 3,2,1,0 - object type (for universal viewers) 0..15 }
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