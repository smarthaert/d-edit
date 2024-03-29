 const
  VBEStatusOk: Word= $004F;

 const
  MaxVbeModes        = 70;

 const
  GRAC_ADDR= $3CE;
  SEQU_ADDR= $3C4;
  CRTC_ADDR= $3D4;
  ATTR_ADDR= $3C0;
  MISC_ADDR= $3C2;
  STAT_ADDR= $3DA;
  VGAE_ADDR= $3C3;

 type
 TVBEInfo = record
  VBESignature       : LongInt;
  VBEVersion         : Word;
  OemStringPtr       : Pointer;
  Capabilities       : LongInt;
  VideoModePtr       : Pointer;
  TotalMemory        : Word;
  OEMSoftwareRev     : Word;
  OEMVendorNamePtr   : Pointer;
  OEMProductNamePtr  : Pointer;
  OEMProductRevPtr   : Pointer;
  Reserved           : array[0..221] of Byte;
  OEMData            : array[0..255] of Byte;
 end;

 TVBEModeInfo = record
  ModeAttributes     : Word;
  WinAAttributes     : Byte;
  WinBAttributes     : Byte;
  WinGranularity     : Word;
  WinSize            : Word;
  WinASegment        : Word;
  WinBSegment        : Word;
  WinFuncPtr         : Pointer;
  BytesPerScanLine   : Word;
  XResolution        : Word;
  YResolution        : Word;
  XCharSize          : Byte;
  YCharSize          : Byte;
  NumberOfPlanes     : Byte;
  BitsPerPixel       : Byte;
  NumberOfBanks      : Byte;
  MemoryModel        : Byte;
  BankSize           : Byte;
  NumberOfImagePages : Byte;
  Reserved           : Byte;
  RedMaskSize        : Byte;
  RedFieldPosition   : Byte;
  GreenMaskSize      : Byte;
  GreenFieldPosition : Byte;
  BlueMaskSize       : Byte;
  BlueFieldPosition  : Byte;
  RsvdMaskSize       : Byte;
  RsvdFieldPosition  : Byte;
  DirectColorModeInfo: Byte;
  PhisBasePtr        : LongInt;
  OffScreenMemOffset : LongInt;
  OffScreenMemSize   : Word;
  Reserved2          : array[0..205] of Byte;
 end;

 TVBEMode= record
  VideoMode : Word;
  BitsPerPix: Byte;
  LFB:        Boolean;
  XRes:       Word;
  YRes:       Word;
 end;

 var
  vpMaskColor:      LongInt;     {�஧��� 梥�}
  vpAspectRatio:    Real;        {�����樥�� ᦠ�� ��� ���㦭��⥩ �� �� Y}
  vpBufferPtr:      Pointer;     {㪠��⥫� �� ����᪨� �����}
  vpWorkMem:        LongInt;     {��ꥬ ࠡ�祩 ���������� � �����}
  vpLineStyle:      Word;        {��⮢� �⨫� ����� ��� DrawLine � �.�.}
  vpBkGrColor:      LongInt;     {梥� 䮭�}
  vpShadowX:        Integer;
  vpShadowY:        Integer;
 { ---   ��६���� ���樠���������� ��᫥ �믮������ ��楤��� InitVBE  ---}
  vpVBEModesList:   array [0..99] of TVBEMode;
  vpVBEModes:       Word;        {��饥 �᫮ ����㯭�� ०���� VBE}
  vpVBEMem:         Word;        {����������� VBE � ��}
  vpVBEVersion:     Word;        {����� VBE}
  vpCapabilities:   LongInt;     {��ࠬ���� ����������}
  vpOemString:      String[80];  {�������� �ந�����⥫�}
 { --- ��६���� ���樠���������� ��᫥ �믮������ ��楤��� SetVBEMode ---}
  vpColorMode:      Byte;        {०�� ���� ���ᥫ�}
  vpMaxColor:       LongInt;     {��娬��쭮� ���祭�� 梥�}
  vpMaxPages:       Byte;        {���ᨬ��쭮� �᫮ �������࠭��}
  vpBytesPerLine:   LongInt;     {�᫮ ���⮢ � ��ப�}
  vpBytesPerPixel:  Byte;        {�᫮ ���⮢ �� ���ᥫ�}
  vpBitsPerPixel:   Byte;        {�᫮ ��⮢ �� ���ᥫ�}
  vpXRes:           Word;        {ࠧ�襭�� ०��� �� X, ���ᥫ��}
  vpYRes:           Word;        {ࠧ�襭�� ०��� �� Y, ���ᥫ��}
  vpMaxY:           Word;        {���ᨬ��쭮� �᫮ ����� ᪠��஢����}
  vpBankOffset:     Word;        {���饭�� ����� ��� ��砫� �������࠭���}
  vpPixOffset:      LongInt;     {���饭�� ���� ���ᥫ�}
  vpCurBank:        Word;        {⥪�騩 ����}
  vpWinGran:        Word;        {�࠭���� ���� (�����)}
  vpBankAddr:       Pointer;     {���� ��楤��� ��४��祭�� �����}
  vpRedMask:        Byte;        {��⮢�� ��᪠ ��᭮� ��⠢���饩}
  vpRedAjast:       Byte;        {ᬥ饭�� ��᭮� ��⠢���饩}
  vpRedPos:         Byte;
  vpGreenMask:      Byte;        {��⮢�� ��᪠ ������� ��⠢���饩}
  vpGreenAjast:     Byte;        {ᬥ饭�� ������� ��⠢���饩}
  vpGreenPos:       Byte;
  vpBlueMask:       Byte;        {��⮢�� ��᪠ ᨭ�� ��⠢���饩}
  vpBlusAjast:      Byte;        {ᬥ饭�� ᨭ�� ��⠢���饩}
  vpBlusPos:        Byte;

var
  VideoLinearAddress: Longint;  { Linear address of video memory }
 var
  VideoSEG:    Word;            { 16-bit selector to access video memory }
  LFBSEG:      Word;
  Video32:     Word;            { 32-bit selector to access video memory }