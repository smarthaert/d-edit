{ ---=== Работа с файлом ресурсов ===--- }

{ ---=== Имя обьекта ===--- }
 Const DataEntryNameLen = 10;

 Type TDataEntryName = String[DataEntryNameLen];

{ ---=== Тип обьекта ===--- }
 Type TDataObjectType = (etObject,etCompressed,etDir);

{ ---=== Заголовок ===--- }
 Const DataHeaderStr : TDataEntryName = 'Root Entry';

{ ---=== Описание обьекта ===--- }
 Type
   TDataDiskEntry = Record
     Name  : String[DataEntryNameLen];
     _Type : TDataObjectType;
     Start : LongInt;
     Size  : LongInt;
   End;
   PDataMemEntry = ^TDataMemEntry;
   TDataMemEntry = Record
     Name      : String[DataEntryNameLen];
     FileName  : String[12];
     ObjectPtr : Pointer;
     Next      : PDataMemEntry;
     Case _Type:TDataObjectType of
       etDir: (OwnerPtr : PDataMemEntry);
       etObject,etCompressed:
              (Size : LongInt);
   End;

{ ---=== Data Manager ===--- }
 Type
   TDataManager = Object
     RootDir,UpDir,CurDir,CurEntry : PDataMemEntry;
 {+} Constructor Init;
 {+} Destructor Done;
 {+} Function ChDir( DirName:TDataEntryName ):Boolean;
 {-} Function FindFirst:TDataEntryName;
 {-} Function FindNext:TDataEntryName;
 {+} Function Check( FileName:String ):Boolean;
 {-} Function LoadDir( FileName:String ):Boolean;
 {-} Function InitObject( ObjectName:TDataEntryName; P:Pointer ):Boolean;
 {-} Function LoadObjects:Boolean;
 {-} Procedure NewObject( ObjectName:TDataEntryName; P:Pointer; Size:Word );
 {-} Procedure MkDir( DirName:TDataEntryName );
 {-} Function SaveObjects( FileName:String ):Boolean;
   End;

 Constructor TDataManager.Init;
   Begin
     New(RootDir);
     With RootDir^ do
       Begin
         Name      := DataHeaderStr;
         _Type     := etDir;
         FileName  := '';
         OwnerPtr  := nil;
         ObjectPtr := nil;
         Next      := nil;
       End;
     CurDir   := RootDir;
     CurEntry := RootDir;
   End;

 Procedure _DisposeDataDir( P:PDataMemEntry );
   Var Cur,Temp:PDataMemEntry;
   Begin
     Cur:=P;
     While Cur<>nil do
       Begin
         If Cur^._Type = etDir then
           _DisposeDataDir(Cur^.ObjectPtr);
         Temp:=Cur;
         Cur:=Cur^.Next;
         Dispose(Temp);
       End;
   End;
   
 Destructor TDataManager.Done;
   Begin
     _DisposeDataDir(RootDir);
   End;

 Function TDataManager.Check( FileName:String ):Boolean;
   Var F:File; HeaderStr:TDataEntryName;
   Begin
     Check:=False;
     Assign(F,FileName);
     Reset(F,1);
     If IOResult<>0 then Exit;
     BlockRead(F,HeaderStr,SizeOf(HeaderStr));
     If IOResult<>0 then Exit;
     Check:=(HeaderStr=DataHeaderStr);
   End;

 Function TDataManager.ChDir( DirName:TDataEntryName ):Boolean;
   Var Entry:PDataMemEntry;
   Begin
     ChDir:=False;
     If DirName = '.' then
       Begin
         CurDir:=RootDir;
         ChDir:=True;
         Exit;
       End;
     If ((DirName = '..') And (CurDir^.OwnerPtr<>nil)) then
       Begin
         CurDir:=CurDir^.OwnerPtr;
         ChDir:=True;
         Exit;
       End;
     Entry:=CurDir^.ObjectPtr;
     While Entry<>nil do
       Begin
         If ((Entry^._Type = etDir) And
             (Entry^.Name = DirName)) then
           Begin
             CurDir:=Entry;
             Exit;
           End;
         Entry:=Entry^.Next;
       End;
   End;

 Function TDataManager.FindFirst:TDataEntryName;
   Begin
   End;

 Function TDataManager.FindNext:TDataEntryName;
   Begin
   End;

 Function TDataManager.LoadDir( FileName:String ):Boolean;
   Begin
   End;

 Function TDataManager.InitObject( ObjectName:TDataEntryName; P:Pointer ):Boolean;
   Begin
   End;

 Function TDataManager.LoadObjects:Boolean;
   Begin
   End;

 Procedure TDataManager.NewObject( ObjectName:TDataEntryName; P:Pointer; Size:Word );
   Begin
   End;

 Procedure TDataManager.MkDir( DirName:TDataEntryName );
   Begin
   End;

 Function TDataManager.SaveObjects( FileName:String ):Boolean;
   Var F:File;
   Procedure SaveDir( P:PDataMemEntry );
     Var T:PDataMemEntry; Temp:TDataDiskEntry; L:LongInt;
     Begin
      { Заполнение каталога }
       With Temp do
         Begin
           Name  := P^.Name;
           _Type := P^._Type;
           Start := FilePos(F)+SizeOf(Temp);
           Size  := 0;
         End;
      { Подсчет количества вложений }
       T:=P^.ObjectPtr;
       While T<>nil do Begin Inc(Temp.Size); T:=T^.Next; End;
      { Запись каталога }
       BlockWrite(F,Temp,SizeOf(Temp));
       L:=FilePos(F)+Temp.Size*SizeOf(Temp);
       T:=P^.ObjectPtr;
       While T<>nil do
         Begin
           Case P^._Type of
             etDir :
           Else
             Begin
               With Temp do
                 Begin
                   Name  := P^.Name;
                   _Type := P^._Type;
                   Start := L;
                   Size  := P^.Size;
                 End;
               L:=L+Temp.Size;
             End;
           BlockWrite(F,Temp,SizeOf(Temp));
           T:=T^.Next;
         End;
      { Запись обьектов }
       T:=P^.ObjectPtr;
       While T<>nil do
         Begin
           Case P^._Type of
             etDir: SaveDir();
           BlockWrite(F,P^.ObjectPtr);
           T:=T^.Next;
         End;
     End;
   Begin
     Assign(F,FileName);
     Rewrite(F,1);
     If IOResult<>0 then
       Begin
         SaveObjects:=False;
         Exit;
       End;
     SaveDir(RootDir);
     Close(F);
     SaveObjects:=False;
   End;

Var DataManager : TDataManager;
Begin
  DataManager.Init;
  DataManager.SaveObjects('TEST.DAT');
  DataManager.Done;
End.