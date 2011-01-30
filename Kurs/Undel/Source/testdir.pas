{ It's WORK !!!! }
Uses F_Disk;

Var CurDir : String;
    Disk : Byte;
    Dirs : LongInt;
    DirSize : Word;
    Dir : Array [1..16] of Dir_Type;   {Сектор каталога}
    I : Byte;
    DiskInfo : TDisk;
Begin
  Writeln('--=== TestDir build 001 (FAT12,FAT16) ===---');
  Disk_Error:=False;
  GetDir(0,CurDir);
  Writeln('Текущий каталог = ',CurDir);
  GetDirSector(CurDir,Disk,Dirs,DirSize);
 { Для моего домашнего диска C: Disk:=2; Dirs:=407; DirSize:=1; }
  GetDiskInfo(Disk,DiskInfo);
  If DiskInfo.Fat16 then Write('FAT16') Else Write('FAT12');
  Write('  Disk=',Disk,'  Dirs=',Dirs,'  DirSize=',DirSize);
  ReadSector(Disk,Dirs,1,Dir);
  Writeln('  Disk_Error=',Disk_Error,'  Error_Code=',Disk_Status);
  Writeln('Начало каталога:');
  Writeln('* ','Имя      ':13,'Attr':5,'FirstC':9,'Size':9);
  For I:=3 to 16 do
    With Dir[I] do
      Writeln('* ',NameExt:13,FAttr:5,FirstC:9,Size:9);
  Writeln('Если Disk_Error=FALSE и вы видите начало каталога корректно,');
  Writeln('то утилита Undel применима. В противном случае лучше не рисковать.');
End.

{ Тестирование процедур чтения/записи }
(*Begin
  Disk:=3;
{  Dirs:=409;}
  Dirs:=97689;
  DirSize:=1;
  ReadSector(Disk,Dirs,1,Dir);
  Writeln('  Disk_Error=',Disk_Error,'  Error_Code=',Disk_Status);
  Writeln('Начало каталога:');
  Writeln('* ','Имя      ':13,'Attr':5,'FirstC':9,'Size':9);
  For I:=3 to 16 do
    With Dir[I] do
      Writeln('* ',NameExt:13,FAttr:5,FirstC:9,Size:9);
End.*)

