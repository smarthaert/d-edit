{===============} UNIT F_Disk; {===============}
{
+------------------------------------------------------------+
| ����� ᮤ�ন� ����ணࠬ�� ��� ������ ࠡ��� � ��᪠��.  |
| �� ��� ����ணࠬ��� ��ࠬ��� DISK �⭮���� � �����᪨� |
| ��᪠�: 0=A, 1=B, 2=C, 3=D � �.�. ��ࠬ��� SEC - �⭮�-   |
| ⥫��  ����� ᥪ��:  0 = ����㧮�� ᥪ��, ����� ��  |
| ᥪ�ࠬ �� ���� ��஦��, �� ��������, �� 樫���ࠬ.      |
+------------------------------------------------------------+
}
                  INTERFACE
type
  {���ଠ�� �� BPB ����㧮筮�� ᥪ��:}
  BPB_Type = record
    SectSiz : Word; {������⢮ ���� � ᥪ��}
    ClustSiz: Byte; {������⢮ ᥪ�஢ � ������}
    ResSecs : Word; {������⢮ ᥪ�஢ ��। FAT}
    FatCnt  : Byte; {������⢮ FAT}
    RootSiz : Word; {������⢮ ����⮢ ��୥���� ��⠫���}
    TotSecs : Word; {������⢮ ᥪ�஢ �� ��᪥}
    Media   : Byte; {���ਯ�� ���⥫�}
    FatSize : Word  {������⢮ ᥪ�஢ � FAT}
  end;  {BPB_Type}
  {�������⥫쭠� ���ଠ�� �� ����㧮筮�� ᥪ��:}
  Add_BPB_Type = record
    TrkSecs : Word;     {������⢮ ᥪ�஢ �� ��஦��}
    HeadCnt : Word;     {������⢮ �������}
    HidnSec : LongInt;  {������⢮ ���⠭��� ᥪ�஢ MS-DOS >= 4.0 }
    BigTotSecs : LongInt; {��饥 �᫮ ᥪ�஢ MS-DOS >= 4.0 }
  end;  {Add_BPB_Type}
  {������� ��᪮���� ��⠫���:}
  Dir_Type = record case Byte of
  1:(
    Name  : array [1..8] of Char;       {��� 䠩�� ��� ��⠫���}
    Ext   : array [1..3] of Char;       {����७��}
    FAttr : Byte;                       {��ਡ��� 䠩��}
    Reserv:array [1..10] of Byte;       {����ࢭ�� ����}
    Time  : Word;                       {�६� ᮧ�����}
    Date  : Word;                       {��� ᮧ�����}
    FirstC: Word;                       {����� ��ࢮ�� ������}
    Size  : LongInt                     {������ 䠩�� � �����});
  2:(NameExt: array [1..11] of Char)
  end;  {Dir_Type}
  {����⥫� �����᪮�� ࠧ����}
  PartType = record
    Act: Boolean;               {���� ��⨢���� ࠧ����}
    BegHead: Byte;              {������� ��砫� ࠧ����}
    BegSC  : Word;              {�����/樫���� ��砫�}
    SysCode: Byte;              {���⥬�� ���}
    EndHead: Byte;              {������� ���� ࠧ����}
    EndSC  : Word;              {�����/樫���� ����}
    RelSect: LongInt;           {�⭮�⥫�� ᥪ�ୠ砫�}
    FoolSiz: LongInt            {��ꥬ � ᥪ���}
  end;  {PartType}
  {����㧮�� ᥪ�� ��᪠}
  PBoot = ^TBoot;
  TBoot = record
  case Byte of
  0:(
    a  : array [1..11] of Byte;
    BPB: BPB_Type;
    Add: Add_BPB_Type;
    c  : array [1..+$1BE-(SizeOf(BPB_Type)+
         SizeOf(Add_BPB_Type)+11)] of Byte;
    Par: array [1..4] of PartType);
  1: (b: array [1..512] of Byte)
  end;
  {����⥫� ��᪠ �� ������� IOCTL}
  IOCTL_Type = record
    BuildBPB: Boolean;          {C�ந�� BPB}
    TypeDrv : Byte;             {��� ��᪠}
    Attrib  : Word;             {��ਡ��� ��᪠}
    Cylindrs: Word;             {��᫮ 樫���஢}
    Media   : Byte;             {��� ���⥫�}
    BPB     : BPB_Type;
    Add     : Add_BPB_Type;
    Reserv  : array [1..10] of Byte;
  end;
  {����⥫� ��᪠}
  TDisk = record
    Number  : Byte;     {����� ��᪠ 0=�,...}
    TypeD   : Byte;     {��� ��᪠}
    AttrD   : Word;     {��ਡ��� ��᪠}
    Cyls    : Word;     {��᫮ 樫���஢ �� ��᪥}
    Media   : Byte;     {���ਯ�� ���⥫�}
    SectSize: Word;     {������⢮ ���� � ᥪ��}
    TrackSiz: Word;     {������⢮ ᥪ�஢ �� ��஦��}
    TotSecs : LongInt;  {������ ����� � ᥪ���}
    Heads   : Byte;     {������⢮ �������}
    Tracks  : Word;     {��᫮ 樫���஢ �� ���⥫�}
    ClusSize: Byte;     {������⢮ ᥪ�஢ � ������}
    MaxClus : Word;     {���ᨬ���� ����� ������}
    FATLock : Word;     {����� 1-�� ᥪ�� FAT}
    FATCnt  : Byte;     {������⢮ FAT}
    FATSize : Word;     {����� FAT � ᥪ���}
    FAT16: Boolean;     {�ਧ��� 16-��⮢��� ����� FAT}
    RootLock: Word;     {��砫� ��୥���� ��⠫���}
    RootSize: Word;     {������⢮ ����⮢ ��⠫���}
    DataLock: Word;     {��砫�� ᥪ�� ������}
  end;
  {���᮪ ����⥫�� ��᪠}
  PListDisk = ^TListDisk;
  TListDisk = record
    DiskInfo: TDisk;
    NextDisk: PListDisk
  end;
  { AbsDiskIORec }
  AbsDiskIORec = Record
    StartSect : LongInt; { logical sector number to start read/write }
    SectCnt   : Word;    { number of sectors to read/write }
    Buffer    : Pointer; { FAR addr of data buffer }
  End;
var
  Disk_Error : Boolean;         {���� �訡��}
  Disk_Status: Word;            {��� �訡��}
const
  Disks: PListDisk = NIL;  {��砫� ᯨ᪠ ����⥫�� ��᪠}

FUNCTION ChangeDiskette(Disk: Byte): Boolean;
  {�����頥� TRUE, �᫨ �����﫮�� ���������
   ����� �� 㪠������ �ਢ��� ������� ��᪠}

PROCEDURE FreeListDisk(var List: PListDisk);
  {������ ᯨ᮪ ����⥫�� ��᪮�}

PROCEDURE GetAbsSector(Disk,Head: Byte;CSec: Word; var Buf);
  {��⠥� ��᮫��� ��᪮�� ᥪ�� � ������� ���뢠��� $13}

FUNCTION GetCluster(Disk: Byte; Sector: LongInt): Word;
  {�����頥� ����� ������ �� ��������� ������ ᥪ��}

FUNCTION GetDefaultDrv: Byte;
  {�����頥� ����� ��᪠ �� 㬮�砭��}

PROCEDURE GetDirItem(FileName: String;var Item: Dir_Type);
  {�����頥� ����� �ࠢ�筨�� ��� 㪠������� 䠩��}

PROCEDURE GetDirSector(Path: String;var Disk: Byte;
                                   var Dirs: LongInt; Var DirSize: Word);
  {�����頥� ���� ᥪ��, � ���஬ ᮤ�ন���
   ��砫� �㦭��� ��⠫���, ��� 0, �᫨ ��⠫�� �� ������.
   �室:
     PATH - ������ ��� ��⠫��� ('', �᫨ ��⠫�� ⥪�騩).
   ��室:
     DISK - ����� ��᪠;
     DIRS - ����� ��ࢮ�� ᥪ�� ��⠫��� ��� 0;
     DIRSIZE - ࠧ��� ��⠫��� (� ������ DIR_TYPE).}

PROCEDURE GetDiskInfo(Disk: Byte;var DiskInfo: TDisk);
  {�����頥� ���ଠ�� � ��᪥ DISK}

FUNCTION GetDiskNumber(c: Char): Byte;
  {�८�ࠧ�� ��� ��᪠ A...Z � ����� 0...26.
   �᫨ 㪠���� ������⢨⥫쭮� ���,�����頥� 255}

FUNCTION GetFATItem(Disk: Byte; Item: Word): Word;
  {�����頥� ᮤ�ন��� 㪠������� ����� FAT}

PROCEDURE GetIOCTLInfo(Disk: Byte;var IO: IOCTL_Type);
  {����砥� ���ଠ�� �� ���ன�⢥
   ᮣ��᭮ ��饬� �맮�� IOCTL}

PROCEDURE GetListDisk(var List: PListDisk);
  {��ନ��� ᯨ᮪ ����⥫�� ��᪮�}

PROCEDURE GetMasterBoot(var Buf);
  {�����頥� � ��६����� Buf ������ ����㧮�� ᥪ��}

FUNCTION GetMaxDrv: Byte;
  {�����頥� ������⢮ �����᪨� ��᪮�}

FUNCTION GetSector( Disk:Byte; Cluster:Word ): LongInt;
  {�८�ࠧ�� ����� ������ � ����� ᥪ��}

FUNCTION PackCylSec(Cyl,Sec: Word): Word;
  {������뢠�� 樫���� � ᥪ�� � ���� ᫮�� ��� ���뢠��� $13}

PROCEDURE SetAbsSector(Disk,Head: Byte; CSec: Word; var Buf);
  {�����뢠�� ��᮫��� ��᪮�� ᥪ��
   � ������� ���뢠��� $13}

PROCEDURE SetDefaultDrv(Disk: Byte);
  {��⠭�������� ��� �� 㬮�砭��}

PROCEDURE SetFATItem(Disk: Byte;Cluster,Item: Word);
  {��⠭�������� ᮤ�ন��� ITEM
   � ����� CLUSTER ⠡���� FAT}

PROCEDURE SetMasterBoot(var Buf);
  {�����뢠�� � ������ ����㧮�� ᥪ�� ᮤ�ন��� Buf}

PROCEDURE UnPackCylSec(CSec: Word;var Cyl,Sec: Word);
  {��������� 樫���� � ᥪ�� ��� ���뢠��� $13}

{ --=== ������஢��� ��� FAT16 ===-- }
PROCEDURE ReadSector( Disk:Byte; Sec:LongInt; NSec:Word; var Buf );
  {��⠥� ᥪ�� (ᥪ���) �� 㪠������ ��᪥}
PROCEDURE WriteSector( Disk:Byte; Sec:LongInt; NSec:Word; var Buf );
  {�����뢠�� ᥪ�� (ᥪ���) �� 㪠����� ���}

                 IMPLEMENTATION

Uses DOS;
var
  Reg: registers;
PROCEDURE Output;
  {��ନ��� ���祭�� Disk_Status � Disk_Error}
BEGIN
  with Reg do
    begin
      Disk_Error := Flags and FCarry = 1;
      Disk_Status:= ax
    end
END;  {Output}
{----------------------}
FUNCTION ChangeDiskette(Disk: Byte): Boolean;
  {�����頥� TRUE, �᫨ �����﫮�� ���������
   ����� �� 㪠������ �ਢ��� ������� ��᪠}
BEGIN
  with Reg do
    begin
      AH := $16;
      DL := Disk;
      Intr($13, Reg);
      Output;
      ChangeDiskette := Disk_Error and (AH=6)
    end
END;  {ChangeDiskett}
{------------------------}
PROCEDURE FreeListDisk(var List: PListDisk);
  {������ ᯨ᮪ ��᪮��� ����⥫��}
var
  P: PListDisk;
BEGIN
  while List <> NIL do
    begin
      P := List^.NextDisk;
      Dispose(List);
      List := P
    end
END;  {FreeListDisk}
{------------------------}
PROCEDURE GetAbsSector(Disk,Head: Byte;CSec: Word; var Buf);
  {��⠥� ��᮫��� ��᪮�� ᥪ�� � ������� ���뢠��� $13}
BEGIN
  with Reg do
    begin
      ah := 2;                  {������ �⥭��}
      dl := Disk;               {����� �ਢ���}
      dh := Head;               {����� �������}
      cx := CSec;               {�������/ᥪ��}
      al := 1;                  {����� ���� ᥪ��}
      es := seg(Buf);
      bx := ofs(Buf);
      Intr($13,Reg);
      Output
    end
END;  {GetAbsSector}
{----------------------}
FUNCTION GetCluster( Disk:Byte; Sector:LongInt ): Word;
  {�����頥� ����� ������ �� ��������� ������ ᥪ��}
var
  DI: TDisk;
BEGIN
  GetDiskInfo(Disk,DI);
  if not Disk_Error then with DI do
    if ((Sector-DataLock) >= 0) and ((TotSecs-Sector) >= 0) then
      GetCluster :=             {��ଠ�쭮� ���饭��}
        (Sector-DataLock) div ClusSize+2
    else
      GetCluster := 0           {������ ����� ᥪ��}
  else
    GetCluster := 0             {������ ����� ��᪠}
END;  {GetCluster}
{----------------------}
FUNCTION GetDefaultDrv: Byte;
  {�����頥� ����� ��᪠ �� 㬮�砭��}
BEGIN
  with Reg do
    begin
      AH := $19;
      MSDOS(Reg);
      GetDefaultDrv := AL
    end
END;  {GetDefaultDrv}
{------------------------}
PROCEDURE GetDirItem(FileName: String;var Item: Dir_Type);
  {�����頥� ����� �ࠢ�筨�� ��� 㪠������� 䠩��}
var
  Dir:array [1..16] of Dir_Type;        {���� �� 1 ᥪ�� ��⠫���}
  Path : DirStr;                {������� ���᪠}
  NameF: NameStr;               {��� 䠩��}
  Ext  : ExtStr;                {����७�� 䠩��}
  Disk : Byte;                  {����� ��᪠}
  Dirs : LongInt;               {����� ᥪ��}
  DirSize: Word;                {������ ��⠫���}
  Find: Boolean;                {���� ���᪠}
  j   : Integer;                {����� ����� ��⠫���}
{-------}
Procedure FindItem;
  {��� �㦭� ����� � ᥪ��� ��⠫���}
var
  k,i: Integer;
  m: array [1..11] of Char;     {���ᨢ �����}
  Clus: Word;                   {����� ������}
  DI: TDisk;
begin
  GetDiskInfo(Disk,DI);         {����砥� ����� ������}
  ReadSector(Disk,Dirs,1,Dir);  {��⠥� ���� ᥪ��}
  k := 0;               {������⢮ ��ᬮ�७��� ����⮢}
  j := 1;               {����騩 ����� ��⠫���}
{��⮢�� ��� � ���७�� ��� ���᪠}
  FillChar(m,11,' ');
  Move(NameF[1],m[1],Length(NameF));
  if ext<>'' then
    Move(Ext[2],m[9],Length(ext)-1);
  Find := False;
{���� ���᪠}
  repeat
    if Dir[j].Name[1]=#0 then
      exit;                     {�����㦥� ����� ᯨ᪠}
    if (Dir[j].FAttr and $18) = 0 then
      begin             {�஢��塞 ��।��� ��� � ��⠫���}
        Find := True;
        i := 1;
        While Find and (i<=11) do
          begin
            Find := m[i]=Dir[j].NameExt[i];
            inc(i)
          end;
      end;
    if not Find then inc(j);
    if j = 17 then
      begin
        inc(k,16);
        if k >= DirSize then
          exit;                 {��諨 �� ���� ��⠫���}
        j := 1;                 {�த������ � 1-�� �����
                                 ᫥���饣� ᥪ��}
        if (k div 16) mod DI.ClusSize=0 then
            if succ(Dirs)<DI.DataLock then
              inc(Dirs)                 {��୥��� ��⠫��}
            else
              begin                     {����� ������}
                {���� ������}
                Clus := GetFATItem(Disk,GetCluster(Disk,Dirs));
                {���� ᥪ��}
                Dirs := GetSector(Disk,Clus)
              end
        else            {��।��� ᥪ�� - � ������}
          inc(Dirs);
        ReadSector(Disk,Dirs,1,Dir)
      end
  until Find
end;  {FindItem}
{-------}
BEGIN  {GetDirItem}
  {��⮢�� ��� 䠩��}
  FileName := FExpand(FileName);
  FSplit(FileName, Path, NameF, Ext);
  {�᪠�� ��⠫��}
  GetDirSector(Path,Disk,Dirs,DirSize);
  Find := Dirs<>0;              {Dirs=0 - �訡�� � �������}
  if Find then
    FindItem;                   {�饬 �㦭� �����}
  if Find then
    begin
      {��७�ᨬ ����� ��⠫��� � Item}
      Move(Dir[j],Item,SizeOf(Dir_Type));
      {������ �訡��}
      Disk_Error := False
    end
  else
    begin                       {���� �� ������}
      Disk_Error := True;
      Disk_Status := $FFFF
    end
END;  {GetDirItem}
{------------------------}
PROCEDURE GetDirSector( Path:String; var Disk:Byte;
                                var Dirs:LongInt; Var DirSize:Word);
  {�����頥� ���� ᥪ��, � ���஬ ᮤ�ন��� ��砫�
   �㦭��� ��⠫���, ��� 0, �᫨ ��⠫�� �� ������.
   �室:
     PATH - ������ ��� ��⠫��� ('', �᫨ ��⠫�� - ⥪�騩).
   ��室:
     DISK - ����� ��᪠;
     DIRS - ����� ��ࢮ�� ᥪ�� ��⠫��� ��� 0;
     DIRSIZE - ࠧ��� ��⠫��� (� ������ DIR_TYPE).}
var
  i,j,k: Integer;               {�ᯮ����⥫�� ��६����}
  Find : Boolean;               {�ਧ��� ���᪠}
  m    : array [1..11] of Char; {���ᨢ ����� ��⠫���}
  s    : String;                {�ᯮ����⥫쭠� ��६�����}
  DI   : TDisk;                 {���ଠ�� � ��᪥}
  Dir  :array [1..16] of Dir_Type;   {����� ��⠫���}
  Clus : Word;                  {����騩 ������ ��⠫���}
label
  err;
BEGIN
{��砫�� �⠯: ��⮢�� ���� � ��⠫��� � ���}
  if Path = '' then             {�᫨ ��⠫�� ⥪�騩,}
    GetDir(0,Path);             {������塞 ������⮬ ���᪠}
  if Path[2] <> ':' then        {�᫨ ��� ��᪠,}
    Disk := GetDefaultDrv       {��६ ⥪�騩}
  else
    begin                       {���� �஢��塞 ��� ��᪠}
      Disk := GetDiskNumber(Path[1]);
      if Disk=255 then
        begin                   {������⢨⥫쭮� ��� ��᪠}
Err:          {��窠 ��室� �� ��㤠筮� ���᪥}
          Dirs := 0;                    {��� ᥪ��}
          Disk_Error := True;           {���� �訡��}
          Disk_Status := $FFFF;         {����� $FFFF}
          exit
        end;
       Delete(Path,1,2){����塞 ��� ��᪠ �� ���}
    end;
{��⮢�� 横� ���᪠}
  if Path[1]='\' then                   {����塞 ᨬ���� \}
    Delete(Path,1,1);                   {� ��砫�}
  if Path[Length(Path)] = '\' then
    Delete(Path,Length(Path),1);        {� ���� �������}
  GetDiskInfo(Disk,DI);
  with DI do
    begin
      Dirs := RootLock;                 {����� � ��⠫����}
      DirSize := RootSize               {����� ��⠫���}
    end;
  ReadSector(Disk,Dirs,1,Dir);          {��⠥� ��୥��� ��⠫��}
  Clus := GetCluster(Disk,Dirs);        {������ ��砫� ��⠫���}
{���� ���᪠ �� ��⠫����}
  Find := Path='';                      {Path='' - ����� �������}
  while not Find do
    begin
      {����砥� � S ��ࢮ� ��� �� ᨬ���� \}
      s := Path;
      if pos('\',Path) <> 0 then
        s[0] := chr(pos('\',Path)-1);
      {����塞 �뤥������ ��� �� �������}
      Delete(Path,1,Length(s));
      if Path[1]='\' then
        Delete(Path,1,1);       {����塞 ࠧ����⥫� \}
      {����� ���ᨢ �����}
      FillChar(m,11,' ');
      move(s[1],m,ord(s[0]));
{��ᬮ�� ��।���� ��⠫���}
      k := 0;  {������⢮ ��ᬮ�७��� ����⮢ ��⠫���}
      j := 1;                   {����騩 ����� � Dir}
      repeat                    {���� ���᪠ � ��⠫���}
        if Dir[j].Name[1]=#0 then {�᫨ ���}
          Goto Err;    {��稭����� c 0 - �� ����� ��⠫���}
        if Dir[j].FAttr=Directory then
          begin
            Find := True;
            i := 1;
            while Find and (i<=11) do
              begin             {�஢��塞 ���}
                Find := m[i]=Dir[j].NameExt[i];
                inc(i)
              end
          end;
        if not Find then inc(j);
        if j = 17 then
          begin         {���௠� ᥪ�� ��⠫���}
            j := 1;     {�த������ � 1-�� �����
                         ᫥���饣� ᥪ��}
            inc(k,16);  {k - ᪮�쪮 ����⮢ ��ᬮ�५�}
            if k >= DirSize then
              goto err;         {��諨 �� ���� ��⠫���}
            if (k div 16) mod DI.ClusSize=0 then
              begin     {���௠� ������ - �饬 ᫥���騩}
                {����砥� ���� ������}
                Clus := GetFATItem(Disk,Clus);
                {����� �� �஢����� �� ����� 楯�窨,
                        �.�. ��⠫�� �� �� ���௠�}
                {����砥� �o�� ᥪ��}
                Dirs := GetSector(Disk,Clus)
              end
            else                                {��।��� ᥪ�� -}
              inc(Dirs);                        {� ⥪�饬 ������}
            ReadSector(Disk,Dirs,1,Dir);
          end
      until Find;
{����� ��⠫�� ��� ��।���� ����� � �������}
      Clus := Dir[j].FirstC;                    {������ ��砫�}
      Dirs := GetSector(Disk,Clus);             {�����}
      ReadSector(Disk,Dirs,1,Dir);
      Find := Path = ''                         {�த������ ����,
                                                 �᫨ �� ���௠� ����}
    end {while not Find}
END;  {GetDirSector}
{------------------------}
PROCEDURE GetDiskInfo(Disk: Byte;var DiskInfo: TDisk);
  {�����頥� ���ଠ�� � ��᪥ DISK}
var
  Boot: TBoot;
  IO  : IOCTL_Type;
  p: PListDisk;
label
  Get;
BEGIN
  Disk_Error := False;
  if (Disk<2) or (Disks=NIL) then
    goto Get; {�� �᪠�� � ᯨ᪥, �᫨ ��᪥� ��� ��� ᯨ᪠}
  {�饬 � ᯨ᪥ ����⥫��}
  p := Disks;
  while (p^.DiskInfo.Number<>Disk) and (p^.NextDisk<>NIL) do
    p := p^.NextDisk;         {�᫨ �� �� ����� ��᪠}
  if p^.DiskInfo.Number=Disk then
    begin                     {������ �㦭� ����� - ��室}
      DiskInfo := p^.DiskInfo;
      exit
    end;
{��ନ�㥬 ����⥫� ��᪠ � ������� �맮�� IOCTL}
Get:
  IO.BuildBPB := True;                  {�ॡ㥬 ����ந�� BPB}
  GetIOCTLInfo(Disk,IO);                {����砥� ���ଠ��}
  if Disk_Error then
    exit;
  with DiskInfo, IO do                  {��ନ�㥬 ����⥫�}
    begin
      Number   := Disk;
      TypeD    := TypeDrv;
      AttrD    := Attrib;
      Cyls     := Cylindrs;
      Media    := BPB.Media;
      SectSize := BPB.SectSiz;
      TrackSiz := Add.TrkSecs;
      If BPB.TotSecs <> 0 then
        TotSecs  := BPB.TotSecs
      Else
        TotSecs  := Add.BigTotSecs;
      Heads    := Add.HeadCnt;
      Tracks := (TotSecs+pred(TrackSiz)) div (TrackSiz*Heads);
      ClusSize := BPB.ClustSiz;
      FATLock  := BPB.ResSecs;
      FATCnt   := BPB.FatCnt;
      FATSize  := BPB.FatSize;
      RootLock := FATLock+FATCnt*FATSize;
      RootSize := BPB.RootSiz;
      DataLock := RootLock+(RootSize*SizeOf(Dir_Type)) div SectSize;
      MaxClus  := (TotSecs-DataLock) div ClusSize+2;
      FAT16    := (MaxClus > 4086) and (TotSecs > 20790)
{      FAT16    := True;}
    end
END;  {GetDiskInfo}
{-----------------------}
FUNCTION GetDiskNumber(c: Char): Byte;
  {�८�ࠧ�� ��� ��᪠ A...Z � ����� 0...26.
   �᫨ 㪠���� ������⢨⥫쭮� ���, �����頥� 255}
var
  DrvNumber: Byte;
BEGIN
  if UpCase(c) in ['A'..'Z'] then
    DrvNumber := ord(UpCase(c))-ord('A')
  else
    DrvNumber := 255;
  if DrvNumber > GetMaxDrv then
    DrvNumber := 255;
  GetDiskNumber := DrvNumber;
END;  {GetDiskNumber}
{-----------------------}
FUNCTION GetFATItem(Disk: Byte;Item: Word): Word;
  {�����頥� ᮤ�ন��� 㪠������� ����� FAT}
var
  DI   : TDisk;
  k,j,n: Integer;
  Fat  : record
    case Byte of
    0: (w: array [0..255] of Word);
    1: (b: array [0..512*3-1] of Byte);
  end;
BEGIN
  GetDiskInfo(Disk,DI);
  if not Disk_Error then with DI do
    begin
      if (Item > MaxClus) or (Item < 2) then
        Item := $FFFF                   {����� �訡��� ����� ������}
      else
        begin
          if FAT16 then
            begin
              k := Item div 256;        {�㦭� ᥪ�� FAT}
              j := Item mod 256;        {���饭�� � ᥪ��}
              n := 1                    {������⢮ �⠥��� ᥪ�஢}
            end
          else
            begin
              k := Item div 1024;       {�㦭�� �ன�� ᥪ�஢ FAT}
              j := (3*Item) shr 1-k*1536; {C��饭�� � ᥪ��}
              n := 3                      {������⢮ �⠥��� ᥪ�஢}
            end;
          {��⠥� 1 ��� 3 ᥪ�� FAT}
          ReadSector(Disk,FATLock+k*n,n,Fat);
          if not Disk_Error then
            begin
              if FAT16 then
                Item := Fat.w[j]
              else
                begin
                  n := Item;      {C�஥ ���祭�� Item ��� �஢�ન �⭮��}
                  Item := Fat.b[j]+Fat.b[j+1] shl 8;
                  if odd(n) then
                    Item := Item shr 4
                  else
                    Item := Item and $FFF;
                  if Item > $FF6 then
                    Item := $F000+Item
                end;
              GetFatItem := Item
            end
        end
    end
END;  {GetFATItem}
{-----------------------}
PROCEDURE GetIOCTLInfo(Disk: Byte;var IO: IOCTL_Type);
  {����砥� ���ଠ�� �� ���ன�⢥
   ᮣ��᭮ ��饬� �맮�� IOCTL}
BEGIN
  with Reg do
    begin
      ah := $44;                {�㭪�� 44}
      al := $0D;                {��騩 �맮� IOCTL}
      cl := $60;                {���� ��ࠬ���� ���ன�⢠}
      ch := $8;                 {���ன�⢮ - ���}
      bl := Disk+1;             {��� 1=�,..}
      bh := 0;
      ds := seg(IO);
      dx := ofs(IO);
      MSDOS(Reg);
      Output
    end
END;  {GetIOCTLInfo}
{-----------------------}
PROCEDURE GetListDisk(var List: PListDisk);
  {��ନ��� ᯨ᮪ ��᪮��� ����⥫��}
var
  Disk: Byte;
  DI  : TDisk;
  P,PP: PListDisk;
BEGIN
  Disk := 2;                    {����� � ��᪠ �:}
  List := NIL;
  repeat
    GetDiskInfo(Disk,DI);
    if not Disk_Error then
      begin
        New(P);
        if List=NIL then
          List := P
        else
          PP^.NextDisk := P;
        with P^ do
          begin
            DiskInfo := DI;
            NextDisk := NIL;
            inc(Disk);
            PP := P
          end
      end
  until Disk_Error;
  Disk_Error := False
END;  {GetListDisk}
{---------------------}
PROCEDURE GetMasterBoot(var Buf);
  {�����頥� � ��६����� Buf ������ ����㧮�� ᥪ��}
BEGIN
  GetAbsSector($80,0,1,Buf)
END;  {GetMasterBoot}
{---------------------}
FUNCTION GetMaxDrv: Byte;
  {�����頥� ������⢮ �����᪨� ��᪮�}
const
  Max: Byte = 0;
BEGIN
  if Max=0 then with Reg do
    begin
      ah := $19;
      MSDOS(Reg);
      ah := $0E;
      dl := al;
      MSDOS(Reg);
      Max := al
    end;
  GetMaxDrv := Max
END;  {GetMaxDrv}
{----------------------}
FUNCTION GetSector(Disk: Byte; Cluster: Word): LongInt;
  {�८�ࠧ�� ����� ������ � ����� ᥪ��}
var
  DI: TDisk;
BEGIN
  GetDiskInfo(Disk,DI);
  if not Disk_Error then with DI do
    begin
      Disk_Error := (Cluster > MaxClus) or(Cluster < 2);
      if not Disk_Error then
        GetSector := (Cluster-2)*LongInt(ClusSize) + LongInt(DataLock)
    end;
  if Disk_Error then
    GetSector := -1;
END;  {GetSector}
{-------------------------}
FUNCTION PackCylSec(Cyl,Sec: Word): Word;
  {������뢠�� 樫���� � ᥪ�� � ���� ᫮�� ��� ���뢠��� $13}
BEGIN
  PackCylSec := Sec+(Cyl and $300) shr 2+(Cyl shl 8)
END;  {CodeCylSec}
{------------------------}
PROCEDURE SetAbsSector(Disk,Head: Byte;CSec: Word; var Buf);
  {�����뢠�� ��᮫��� ��᪮�� ᥪ��
   � ������� ���뢠��� $13}
BEGIN
  with Reg do
    begin
      ah := 3;                  {������ �����}
      dl := Disk;               {����� �ਢ���}
      dh := Head;               {����� �������}
      cx := CSec;               {�������/ᥪ��}
      al := 1;                  {��⠥� ���� ᥪ��}
      es := seg(Buf);
      bx := ofs(Buf);
      Intr($13,Reg);
      Output
    end
END;  {SetAbsSector}
{-----------------------}
PROCEDURE SetDefaultDrv(Disk: Byte);
  {��⠭�������� ��� �� 㬮�砭��}
BEGIN
  if Disk <= GetMaxDrv then with Reg do
    begin
      AH := $E;
      DL := Disk;
      MSDOS(Reg)
    end
END;
{-----------------------}
PROCEDURE SetFATItem(Disk: Byte;Cluster,Item: Word);
  {��⠭�������� ᮤ�ন��� ITEM � ����� CLUSTER ⠡���� FAT}
var
  DI : TDisk;
  k,j,n: Integer;
  Fat: record
    case Byte of
    0: (w: array [0..255] of Word);
    1: (b: array [0..512*3-1] of Byte);
  end;
BEGIN
  GetDiskInfo(Disk,DI);
  if not Disk_Error then with DI do
    begin
      if (Cluster <= MaxClus) and(Cluster >= 2) then
        begin
          if FAT16 then

            begin
              k := Cluster div 256;     {�㦭� ᥪ�� FAT}
              j := Cluster mod 256;     {���饭�� � ᥪ��}
              n := 1
            end
          else
            begin
              k := Cluster div 1024;    {�㦭�� �ன�� ᥪ�஢ FAT}
              j := (3*Cluster) shr 1-k*1536;
              n := 3
            end;
          ReadSector(Disk,FATLock+k*n,n,Fat);
          if not Disk_Error then
            begin
              if FAT16 then
                Fat.w[j] := Item
              else
                begin
                  if odd(Cluster) then
                    Item := Item shl 4 +Fat.b[j] and $F
                  else
                    Item := Item+(Fat.b[j+1] and$F0) shl 12;
                  Fat.b[j] := Lo(Item);
                  Fat.b[j+1] := Hi(Item)
                end;
              if not FAT16 then
                begin           {�஢��塞 "墮��" FAT}
                  k := k*n;     {k - ᬥ饭�� ᥪ��}
                  while k+n > FatSize do dec(n)
                end;
              inc(FATLock,k);  {FATLock - ����� ᥪ�� � FAT}
        {�����뢠�� ��������� � FatCnt ����� FAT}
              for k := 0 to pred(FatCnt) do
                WriteSector(Disk,FATLock+k*FatSize,n,Fat)
            end
        end
    end
END;  {SetFATItem}
{----------------------}
PROCEDURE SetMasterBoot(var Buf);
  {�����뢠�� � ������ ����㧮�� ᥪ�� ᮤ�ন��� Buf}
BEGIN
  with Reg do
    begin
      ah := 3;                  {������ �����}
      al := 1;                  {���-�� ᥪ�஢}
      dl := $80;                {1-� ���⪨� ���}
      dh := 0;                  {������� 0}
      cx := 1;                  {1-� ᥪ�� 0-� ��஦��}
      es := seg(Buf);
      bx := ofs(Buf);
      Intr($13, Reg);
      Disk_Error := (Flags and FCarry <> 0);
      if Disk_Error then
        Disk_Status := ah
      else
        Disk_Status := 0
    end
END;  {SetMasterBoot}
{------------------------}
PROCEDURE UnpackCylSec(CSec: Word; var Cyl,Sec: Word);
 {��������� 樫���� � ᥪ�� ��� ���뢠��� $13}
BEGIN
  Cyl := (CSec and 192) shl 2+CSec shr 8;
  Sec := CSec and 63
END;  {RecodeCylSec}

{ --=== ������஢��� ��� FAT16 ===-- }

PROCEDURE ReadWriteSector( Disk:Byte; Sec:LongInt; NSec:Word; var Buf; Op:Byte );
  {��⠥� ��� �����뢠�� ᥪ�� (ᥪ���): Op = 0 - ����; 1 - �������}
Var IORec : AbsDiskIORec; IORecPtr:Pointer; 
BEGIN
{ Writeln('[! - F_Disk.ReadWriteSector] Disk=',Disk,'  Sec=',Sec,'  NSec=',NSec);}
  With IORec do
    Begin
      StartSect := Sec;  { logical sector number to start read/write }
      SectCnt   := NSec; { number of sectors to read/write }
      Buffer    := @Buf; { FAR addr of data buffer }
    End;
  IORecPtr:=@IORec;
  Asm
    mov    AL,Op        {AL := Op}
    shr    AX,1         {��७�ᨬ����訩 ��� Op � CF}
    mov    AL,Disk      {AL := Disk}
    mov    DX,00000h    {DX := 00000h }
    mov    CX,0FFFFh    {CX := 0FFFFh }
    push   DS           {���࠭塞 DS - �� �㤥� �ᯮ�祭}
    push   BP           {���࠭塞 BP}
    lds    BX,IORecPtr  {DS:BX - ���� IORec }
    jc     @Write       {��३�, �᫨ ����訩 ��� Op<>0}
    int    25H          {��⠥� �����}
    jmp    @Go          {����� ������}
 @WRITE:
    int    26H                          {�����뢠�� �����}
 @GO:
    pop    DX                   {��������� 䫠�� �� �⥪�}
    pop    BP                   {����⠭�������� BP}
    pop    DS                   {����⠭�������� DS}
    mov    BX,1                 {BX := True}
    jc     @Exit                {��३�, �᫨ �뫠 �訡��}
    mov    BX,0                 {BX := False}
    xor    AX,AX                {����塞 ��� �訡��}
 @EXIT:
    mov    Disk_Error,BL        {���� �訡�� ����� �� BX}
    mov    Disk_Status,AX       {��� �訡�� ���� �� AX}
  End
END;  {ReadWriteSector}

PROCEDURE ReadSector( Disk:Byte; Sec:LongInt; NSec:Word; var Buf );
  {��⠥� ᥪ�� (ᥪ���) �� 㪠������ ��᪥}
BEGIN
  ReadWriteSector(Disk,Sec,Nsec,Buf,0);
END;  {ReadSector}

PROCEDURE WriteSector( Disk:Byte; Sec:LongInt; NSec:Word; var Buf );
  {�����뢠�� ᥪ�� (ᥪ���) �� 㪠����� ���}
BEGIN
  ReadWriteSector(Disk,Sec,Nsec,Buf,1);
END;  {WriteSector}

{===========}  END. {Unit F_Disk}  {===========}



