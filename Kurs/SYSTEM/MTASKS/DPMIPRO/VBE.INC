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
  vpMaskColor:      LongInt;     {прозрачный цвет}
  vpAspectRatio:    Real;        {коэффициент сжатия для окружностей по оси Y}
  vpBufferPtr:      Pointer;     {указатель на графический буффер}
  vpWorkMem:        LongInt;     {объем рабочей видеопамяти в байтах}
  vpLineStyle:      Word;        {битовый стиль линии для DrawLine и т.д.}
  vpBkGrColor:      LongInt;     {цвет фона}
  vpShadowX:        Integer;
  vpShadowY:        Integer;
 { ---   переменные инициализируются после выполнения процедуры InitVBE  ---}
  vpVBEModesList:   array [0..99] of TVBEMode;
  vpVBEModes:       Word;        {общее число доступных режимов VBE}
  vpVBEMem:         Word;        {видеопамять VBE в кб}
  vpVBEVersion:     Word;        {версия VBE}
  vpCapabilities:   LongInt;     {параметры видеокарты}
  vpOemString:      String[80];  {название производителя}
 { --- переменные инициализируются после выполнения процедуры SetVBEMode ---}
  vpColorMode:      Byte;        {режим печати пикселя}
  vpMaxColor:       LongInt;     {махимальное значение цвета}
  vpMaxPages:       Byte;        {максимальное число видеостраниц}
  vpBytesPerLine:   LongInt;     {число байтов в строке}
  vpBytesPerPixel:  Byte;        {число байтов на пиксель}
  vpBitsPerPixel:   Byte;        {число битов на пиксель}
  vpXRes:           Word;        {разрешение режима по X, пикселей}
  vpYRes:           Word;        {разрешение режима по Y, пикселей}
  vpMaxY:           Word;        {максимальное число линий сканирования}
  vpBankOffset:     Word;        {приращение банка для начала видеостраницы}
  vpPixOffset:      LongInt;     {приращение адреса пикселя}
  vpCurBank:        Word;        {текущий банк}
  vpWinGran:        Word;        {грануляция окна (банка)}
  vpBankAddr:       Pointer;     {адрес процедуры переключения банка}
  vpRedMask:        Byte;        {битовая маска красной составляющей}
  vpRedAjast:       Byte;        {смещение красной составляющей}
  vpRedPos:         Byte;
  vpGreenMask:      Byte;        {битовая маска зеленой составляющей}
  vpGreenAjast:     Byte;        {смещение зеленой составляющей}
  vpGreenPos:       Byte;
  vpBlueMask:       Byte;        {битовая маска синей составляющей}
  vpBlusAjast:      Byte;        {смещение синей составляющей}
  vpBlusPos:        Byte;

var
  VideoLinearAddress: Longint;  { Linear address of video memory }
 var
  VideoSEG:    Word;            { 16-bit selector to access video memory }
  LFBSEG:      Word;
  Video32:     Word;            { 32-bit selector to access video memory }