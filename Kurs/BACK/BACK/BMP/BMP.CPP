//--------------------------------------------------------//
//  File:  BMP.CPP                                        //
//  Desc:  Classes for encapsulating the BMP format       //
//  Copr:  Copyright (c) 1994 by Marv Luse                //
//--------------------------------------------------------//

// Notes...
//
// (1) For the sake of brevity only BMP input is illustrated
//     here, and in general, the code is intended as a model
//     only.
//
// (2) No size typing is performed on pointers or the objects
//     to which they point (i.e., near, far, huge, etc).
//     This is normal for OS/2, but since Windows is 16-bit,
//     the code will need to be modified slightly for that
//     environment.  In particular, if the entire bitmap
//     is to be accessible through a single pointer, that
//     pointer should be declared huge.
//
// (3) The code was tested under OS/2 2.1 using the Borland
//     1.0 OS/2 compiler.  Tweaking may be necessary with
//     other environment mixes.

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "bmp.h"

//.......A class for performing binary input

BinaryInput::BinaryInput( char * path )
{
   inp = fopen( path, "rb" );
}

BinaryInput::~BinaryInput( )
{
   if( inp ) fclose( inp );
}

int BinaryInput::byte( )
{
   return fgetc( inp );
}

int BinaryInput::word( )
{
   short s;
   fread( &s, sizeof(short), 1, inp );
   return s;
}

long BinaryInput::dword( )
{
   long l;
   fread( &l, sizeof(long), 1, inp );
   return l;
}

int BinaryInput::block( void * blk, int nbytes )
{
   return fread( blk, nbytes, 1, inp );
}

int BinaryInput::ok( )
{
   return ((inp==0) || ferror(inp) || feof(inp)) ? 0 : 1;
}

int BinaryInput::error( )
{
   if( inp == 0 )    return FILENOTFOUND;
   if( feof(inp) )   return FILEENDOFFILE;
   if( ferror(inp) ) return FILEERROR;
   return FILEOKAY;
}

int BinaryInput::seek( long ofs, int org )
{
   return inp ? fseek( inp, ofs, org ) : FILEERROR;
}

long BinaryInput::tell( )
{
   return inp ? ftell( inp ) : -1;
}

//.......A class for a BMP header and bitmap

BmpImage::BmpImage( char * path )
{
   //.....initialize nonformat items
   bmBits = 0;
   bmNumColors = 0;
   tmpfilehdr = tmpbmaphdr = tmppalette = 0;

   //.....the remaining items constitute a valid
   //     OS/2 2.x BMP header set
   memset( &fiType, 0, BMPFILEHDRSIZE + BMPNEWOS2HDRSIZE +
                       sizeof(long) * 256 );

   //.....instantiate the input stream
   BinaryInput inB( path );
   if( ! inB.ok() )
   {
      fiBmpStatus = inB.error( );
      return;
   }

   //.....get the file header type field and verify
   fiType = (ushort) inB.word( );
   switch( fiType )
   {
      case BMPBITMAP:
           break;
      case BMPARRAY:
      case BMPCLRICON:
      case BMPCLRPOINTER:
      case BMPICON:
      case BMPPOINTER:
           fiBmpStatus = FILENOTBMPIMG;
           return;
      default:
           fiBmpStatus = FILENOTBMP;
           return;
   }

   //.....read rest of file hdr, which isn't versn dependent
   fiSizeFile = inB.dword( );
   fiXhot     = (ushort) inB.word( );
   fiYhot     = (ushort) inB.word( );
   fiOffBits  = inB.dword( );

   //.....get the bitmap header size field and verify
   bmSizeHeader = inB.dword( );
   switch( bmSizeHeader )
   {
      case BMPOLDANYHDRSIZE:
      case BMPNEWWINHDRSIZE:
      case BMPNEWOS2HDRSIZE:
           break;
      default:
           if( (bmSizeHeader < BMPOLDANYHDRSIZE) ||
               (bmSizeHeader > BMPNEWOS2HDRSIZE) )
           {
               fiBmpStatus = FILENOTBMP;
               return;
           }
           break;
   }

   //.....read the rest of the bitmap header and palette
   if( bmSizeHeader == BMPOLDANYHDRSIZE )
   {
      bmWidth     = inB.word( );
      bmHeight    = inB.word( );
      bmPlanes    = (ushort) inB.word( );
      bmBitCount  = (ushort) inB.word( );
      bmNumColors = (fiOffBits - bmSizeHeader - BMPFILEHDRSIZE) / 3;
      bmSizeImage = rowbytes( ) * bmHeight;
      for( int i=0; i<bmNumColors; i++ )
      {
         long blu = inB.byte( );
         long grn = inB.byte( );
         long red = inB.byte( );
         bmPalette[i] = (red << 16) | (grn << 8) | blu;
      }
   }
   else
   {
      long nbytes = bmSizeHeader - 4;
      inB.block( &bmWidth, nbytes );
      bmNumColors = (fiOffBits - bmSizeHeader - BMPFILEHDRSIZE) / 4;
      if( bmNumColors > 0 )
         inB.block( bmPalette, bmNumColors * 4 );
   }

   //.....read the bitmap - this part works only for bitmaps
   //     64K or smaller under Windows.
   bmBits = new char [ rowbytes() * bmHeight ];
   if( bmBits )
   {
      inB.block( bmBits, rowbytes() * bmHeight );
      fiBmpStatus = inB.ok( ) ? FILEOKAY : inB.error( );
   }
   else
      fiBmpStatus = FILENOMEMORY;
}

BmpImage::~BmpImage( )
{
   delete [] tmpfilehdr;
   delete [] tmpbmaphdr;
   delete [] tmppalette;
   delete [] bmBits;
}

long BmpImage::width( )
{
   return bmWidth;
}

long BmpImage::height( )
{
   return bmHeight;
}

long BmpImage::depth( )
{
   return bmPlanes * bmBitCount;
}

long BmpImage::rowbytes( )
{
   return (((bmPlanes*bmBitCount*bmWidth) + 31) / 32) * 4;
}

long BmpImage::size( )
{
   return bmSizeImage ? bmSizeImage : rowbytes() * bmHeight;
}

int BmpImage::planes( )
{
   return bmPlanes;
}

int BmpImage::bits( )
{
   return bmBitCount;
}

int BmpImage::compression( )
{
   return bmCompression;
}

int BmpImage::xres( )
{
   return bmXPelsPerMeter;
}

int BmpImage::xdpi( )
{
   return (int) ((bmXPelsPerMeter * 100) / 3937);
}

int BmpImage::yres( )
{
   return bmYPelsPerMeter;
}

int BmpImage::ydpi( )
{
   return (int) ((bmYPelsPerMeter * 100) / 3937);
}

void * BmpImage::filehdr( int vers )
{
   // file header is not version dependent
   return (void *) &fiType;
}

void * BmpImage::bmaphdr( int vers )
{
   // the first 40 bytes of the new OS/2 header
   // is the same as the new Windows header, except
   // for the length value (40 versus 64); the old
   // header, however, requires reformatting
   if( vers == BMPOS2NEW )
      return &bmSizeHeader;

   // allocate space for worst case - 40 bytes
   if( tmpfilehdr == 0 )
      tmpfilehdr = new char [ BMPNEWWINHDRSIZE ];

   if( (vers == BMPWINNEW) && (tmpfilehdr != 0) )
   {
      memcpy( tmpfilehdr, &bmSizeHeader, BMPNEWWINHDRSIZE );
      *((ulong *) tmpfilehdr) = BMPNEWWINHDRSIZE;
   }
   else if( ((vers == BMPWINOLD) || (vers == BMPOS2OLD)) &&
            (tmpfilehdr != 0) )
   {
      // this is ugly, but safe and functional!
      *((ulong *) tmpfilehdr) = BMPOLDANYHDRSIZE;
      short * hdr = (short *) tmpfilehdr;
      hdr[2] = (short) bmWidth;
      hdr[3] = (short) bmHeight;
      hdr[4] = bmPlanes;
      hdr[5] = bmBitCount;
   }

   return (void *) tmpfilehdr;
}

void * BmpImage::palhdr( int vers )
{
   // The palette format is the same for both new
   // format versions, but the old format requires
   // reformatting.
   if( (vers == BMPOS2NEW) || (vers == BMPWINNEW) )
      return (bmNumColors > 0) ? (void *) &bmPalette[0] : 0;

   // allocate space for old palette
   if( (tmppalette == 0) && (bmNumColors > 0) )
   {
      tmppalette = new char [ bmNumColors * 3 ];
      if( tmppalette != 0 )
      {
         char * s = (char *) &bmPalette[0];
         char * d = (char *) tmppalette;
         for( int i=0; i<bmNumColors; i++ )
         {
            *d++ = *s++;
            *d++ = *s++;
            *d++ = *s++;
            s++;
         }
      }
   }

   return tmppalette;
}

void * BmpImage::bitmap( int vers )
{
   // bitmap is not version dependent
   return (void *) bmBits;
}

int BmpImage::status( )
{
   return fiBmpStatus;
}
