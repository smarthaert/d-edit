Uses DOS,F_DISK,U_LIST;

Const DirCount  : LongInt = 0;
      FileCount : LongInt = 0;
      StartDir  : String  = '';
      Symbol    : String  = '#';
      MakeChanges : Boolean = False; { Делать ли изменения }

Procedure UndelDir( DirName:String );
  Var
    Dir : Array [1..16] of Dir_Type;        { Буфер на 1 сектор каталога }
    Path : DirStr;                { Маршрут поиска }
    NameF: NameStr;               { Имя файла }
    Ext  : ExtStr;                { Расширение файла }
    Disk : Byte;                  { Номер диска }
    Dirs : LongInt;               { Номер сектора }
    DirSize : Word;               { Размер каталога }
    J   : Integer;                { Номер элемента каталога }
    K,I : Integer;                { Счетчики }
    DI : TDisk;                   { Информация о диске }
    Clus : Word;                  { Номер кластера }
    Flag,Changes : Boolean;       { Проверка символов и флаг изменений }
    FileStr : String;             { Состояние файла }
    DirInfo : SearchRec;          { Для поиска подкаталогов }
  Begin
    Writeln('[!] Восстанавливаю каталог: ',DirName);
    ClearAll;
   { Искать каталог }
    GetDirSector(DirName,Disk,Dirs,DirSize);
    If ((Dirs=0) Or Disk_Error) then { Dirs=0 - ошибка в маршруте }
      Begin
        Writeln('[!] Ошибка: Не найден путь!');
        Exit;
      End;
    GetDiskInfo(Disk,DI);         { Получаем длину кластера }
    ReadSector(Disk,Dirs,1,Dir);  { Читаем первый сектор }
    K := 0;               { Количество просмотренных элементов }
    J := 1;               { Текущий элемент каталога }
   { Цикл поиска }
    Changes:=False;
    Repeat
      If Dir[J].Name[1]=#0 then Exit; { Обнаружен конец списка файлов }
     { Пропускаем корневой и над каталог (Hичего не начинается на '.') }
      While Dir[J].NameExt[1] = '.' do Inc(J);
     { Пропускаем не ASCII файлы и каталоги }
      Flag:=True;
      For I:=1 to Length(Dir[j].NameExt) do
        If Not (((Dir[j].NameExt[I] >= #32) And
                 (Dir[j].NameExt[I] <= #128)) Or
                 (Dir[j].NameExt[I] = #229)) then Flag:=False;
      If Flag then { ASCII - файл }
        Begin
         { Удаленный файл (каталог) }
          FileStr:='';
          If Dir[j].NameExt[1] = #229 then
            Begin
              Dir[j].NameExt[1] := Symbol[1];
              While FindStr(Dir[j].NameExt) do
                Dir[j].NameExt[1]:=Chr(Ord(Dir[j].NameExt[1])+1);
              AddStr(Dir[j].NameExt);
              If MakeChanges then 
                FileStr:='<восстановлен>'
              Else
                FileStr:='<можно восстановить>';
             { Статистика. Количество каталогов & Количество файлов }
              If (Dir[j].FAttr and Directory) = 0 then
                Inc(FileCount) Else Inc(DirCount);
             { Вносим изменения }
              Changes:=True;
            End;
         { Текущий элемент каталога }
          Writeln('* ',DirName,'\',Dir[J].NameExt,' ',FileStr);
        End;
      Inc(J);
      If J = 17 then
        Begin
         { Внесение изменений }
          If (Changes And MakeChanges) then WriteSector(Disk,Dirs,1,Dir);
          Changes:=False;
          Inc(K,16);
          if K >= DirSize then Exit; { Дошли до конца каталога }
          J := 1;         { Продолжаем с 1-го элемента следующего сектора }
          If (K div 16) mod DI.ClusSize=0 then
            If Succ(Dirs) < DI.DataLock then
              Inc(Dirs)       { Корневой каталог }
            Else
              Begin   { Конец кластера }
                Clus := GetFATItem(Disk,GetCluster(Disk,Dirs)); { Новый кластер }
                Dirs := GetSector(Disk,Clus) { Новый сектор }
              End
          Else Inc(Dirs); { Очередной сектор - в кластере }
          ReadSector(Disk,Dirs,1,Dir)
        End;
    Until Dir[J].Name[1]=#0;
    If (Changes And MakeChanges) then WriteSector(Disk,Dirs,1,Dir);
    Writeln('[!] Восстановление каталога завершено !');
   { Рекурсивный вызов для подкаталогов }
    FindFirst(DirName+'\*.*',Directory,DirInfo);
    While DosError = 0 do
      Begin
        If ((DirInfo.Attr And Directory) <> 0) And
            (DirInfo.Name[1]<>'.') then
          UndelDir(DirName+'\'+DirInfo.Name);
        FindNext(DirInfo);
      End;
  End;  { UndelDir }

{ - UpCaseStr - }
Function UpCaseStr( S:String ):String;
  Var Res:String; I:Byte;
  Begin
    Res:=S;
    For I:=1 to Length(Res) do Res[I]:=UpCase(Res[I]);
    UpCaseStr:=Res;
  End;

{ - Основная программа - }
Begin
  Writeln('      --=== Программа для восстановления дерева каталогов ===--');
  Writeln('      * Только для FAT12,FAT16 Протестировано под MS-DOS 6.22 *');
  Writeln(' * За поддержкой обращайться: Денис (812)511-31-95,Denis@ipo.spb.ru *');
  If ParamCount >= 1 then
    Begin
      StartDir:=UpCaseStr(ParamStr(1));
      Writeln(' * Восстанавливаемый каталог: ',StartDir);
      If ParamCount >= 2 then
        Begin
          Symbol:=UpCaseStr(ParamStr(2));
          Writeln(' * Hачальный первый символ: ',Symbol[1]);
          MakeChanges:=True;
        End
      Else
        Writeln('Безопасный режим. Файлы не восстанавливаются.');
      Writeln('Протокол восстановления: ');
      UndelDir(StartDir);
      Writeln('Восстановлено (можно восстановить): Файлов ',FileCount,' Каталогов ',DirCount);
    End
  Else
    Begin
      Writeln('Внимание! Ошибка! Hехватает необходимых параметров.');
      Writeln('Для запуска используйте:');
      Writeln('  UNDEL <Имя восстанавливаемого каталога> [<Hачальный первый символ>]');
      Writeln('Пример: UNDEL E:\USERS #  - Восстановления содержимого каталога USERS');
      Writeln('При этом UNDEL восстановит каталог USERS на диске E,');
      Writeln('т.е. отсканирует его содержимое и восстановит файлы и подкаталоги под именами');
      Writeln('начинающимися на #. Если встретятся два файла (каталога) имена которых');
      Writeln('будут отличаться только первой буквой, для восстановления будет выбран');
      Writeln('следующий символ таблицы ASCII (символ $, затем %,...)');
      Writeln('При запуске с одним параметром UNDEL просто покажет список удаленных файлов.');
      Writeln('Перед запуском разрешите прямой доступ к диску и запустите TESTDIR.EXE');
    End;
End.