//--------------------------------------------------------//
//  File:  BMP.H                                          //
//  Desc:  Classes for encapsulating the BMP format       //
//  Copr:  Copyright (c) 1994 by Marv Luse                //
//--------------------------------------------------------//

#ifndef _BMP_H_
#define _BMP_H_

//.......Useful types

typedef unsigned char  uchar;
typedef unsigned short ushort;
typedef unsigned long  ulong;

//.......Useful constants

enum FileOrigins
{
   FILEBGN = SEEK_SET,
   FILECUR = SEEK_CUR,
   FILEEND = SEEK_END,
};

enum FileStates
{
   FILEOKAY,
   FILEENDOFFILE,
   FILENOTFOUND,
   FILEINVALID,
   FILENOTBMP,
   FILENOTBMPIMG,
   FILEERROR,
   FILENOMEMORY,
};

enum BmpVersions
{
   BMPWINOLD,
   BMPOS2OLD,
   BMPWINNEW,
   BMPOS2NEW,
};

enum BmpSizes
{
   BMPFILEHDRSIZE   = 14,
   BMPOLDANYHDRSIZE = 12,
   BMPNEWWINHDRSIZE = 40,
   BMPNEWOS2HDRSIZE = 64,
};

enum BmpTypes
{
   BMPARRAY       = 0x4142,    // 'BA'
   BMPBITMAP      = 0x4D42,    // 'BM'
   BMPCLRICON     = 0x4943,    // 'CI'
   BMPCLRPOINTER  = 0x5043,    // 'CP'
   BMPICON        = 0x4349,    // 'IC'
   BMPPOINTER     = 0x5450,    // 'PT'
};

//.......A class for performing binary input

class BinaryInput
{
   private:

   FILE * inp;

   public:

   BinaryInput( char * path );
   ~BinaryInput( );

   //.....read various types
   int  byte( );
   int  word( );
   long dword( );
   int  block( void * blk, int nbytes );

   //.....file management members
   int  ok( );
   int  error( );
   int  seek( long ofs, int org );
   long tell( );
};

//.......A class for a BMP header and bitmap

class BmpImage
{
   private:

   char  *bmBits;              // bitmap data
   ulong  bmNumColors;         // size of palette
   int    fiBmpStatus;         // a status code

   char  *tmpfilehdr;          // temporaries
   char  *tmpbmaphdr;
   char  *tmppalette;

   public:

   ushort fiType;              // type - 'BM' for bitmaps
   ulong  fiSizeFile;          // file size in bytes
   ushort fiXhot;              // 0 or x hotspot
   ushort fiYhot;              // 0 or y hotspot
   ulong  fiOffBits;           // offset to bitmap
   ulong  bmSizeHeader;        // size of this data - 64
   ulong  bmWidth;             // bitmap width in pixels
   ulong  bmHeight;            // bitmap height in pixels
   ushort bmPlanes;            // num planes - always 1
   ushort bmBitCount;          // bits per pixel
   ulong  bmCompression;       // compression flag
   ulong  bmSizeImage;         // image size in bytes
   long   bmXPelsPerMeter;     // horz resolution
   long   bmYPelsPerMeter;     // vert resolution
   ulong  bmClrUsed;           // 0 -> color table size
   ulong  bmClrImportant;      // important color count
   ushort bmUnits;             // units of measure
   ushort bmReserved;          // reserved
   ushort bmRecording;         // recording algorithm
   ushort bmRendering;         // halftoning algorithm
   ulong  bmSize1;             // size value 1
   ulong  bmSize2;             // size value 2
   ulong  bmColorEncoding;     // color encoding
   ulong  bmIdentifier;        // for application use
   ulong  bmPalette[256];      // image palette

   BmpImage( char * path );
   ~BmpImage( );

   //.....member functions - query
   long   width( );            // bitmap width in pixels
   long   height( );           // bitmap height in pixels
   long   depth( );            // bitmap depth in bits
   long   rowbytes( );         // scan line width in bytes
   long   size( );             // bitmap size in bytes
   int    planes( );           // number of planes
   int    bits( );             // bits per plane
   int    compression( );      // compression type
   int    xres( );             // x res as pels/meter
   int    xdpi( );             // x res dots/inch
   int    yres( );             // y res as pels/meter
   int    ydpi( );             // y res dots/inch
   void * filehdr( int vers ); // ptr to bmp file header
   void * bmaphdr( int vers ); // ptr to bmp info header
   void * palhdr( int vers );  // ptr to bmp rgb array
   void * bitmap( int vers );  // ptr to bmp bitmap data
   int    status( );           // image/file status code
};

#endif
