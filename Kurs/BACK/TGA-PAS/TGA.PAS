Type
  TGAFile = Record
    idLength          : Byte;       { length of ID string }
    mapType           : Byte;       { color map type }
    imageType         : Byte;       { image type code }
    mapOrigin         : Word;       { starting index of map }
    mapLength         : Word;       { length of map }
    mapWidth          : Byte;       { width of map in bits }
    xOrigin           : Word;       { x-origin of image }
    yOrigin           : Word;       { y-origin of image }
    imageWidth        : Word;       { width of image }
    imageHeight       : Word;       { height of image }
    pixelDepth        : Byte;       { bits per pixel }
    imageDesc         : Byte;       { image descriptor }
    idString : Array [0..255] of Char; { image ID string }
    devTags : Word;                { number of developer tags in directory }
    DevDir  *devDirs;               { pointer to developer directory entries }
    extSize : Word;                { extension area size }
    author : Array [0..40] of Char;             { name of the author of the image }
    authorCom : Array [0..3,0..80] of Char;     { author's comments }
    month  : Word;                  { date-time stamp }
    day    : Word;
    year   : Word;
    hour   : Word;
    minute : Word;
    second : Word;
    jobID  : Array [0..40] of Char;  { job identifier }
    jobHours   : Word;               { job elapsed time }
    jobMinutes : Word;
    jobSeconds : Word;
    softID : Array [0..40] of Char; { software identifier/program name }
    versionNum : Word;              { software version designation }
    versionLet : Byte;
    keyColor   : Array [0..3] of Byte; { key color value as A:R:G:B }
    pixNumerator     : Word;   { pixel aspect ratio }
    pixDenominator   : Word;
    gammaNumerator   : Word; { gamma correction factor }
    gammaDenominator : Word;
    colorCorrectOffset : LongInt;    { offset to color correction table }
    stampOffset        : LongInt;    { offset to postage stamp data }
    scanLineOffset     : LongInt;    { offset to scan line table }
    alphaAttribute: Byte;   { alpha attribute description }
    UINT32  *scanLineTable; { address of scan line offset table }
    stampWidth;   : Byte;   { width of postage stamp }
    stampHeight;  : Byte;   { height of postage stamp }
    void    *postStamp;             { address of postage stamp data }
    UINT16  *colorCorrectTable;
    extAreaOffset : LongInt;   { extension area offset }
    devDirOffset  : LongInt;   { developer directory offset }
    signature : Array [0..17] of Char; { signature string     }
  End;

Begin
End.