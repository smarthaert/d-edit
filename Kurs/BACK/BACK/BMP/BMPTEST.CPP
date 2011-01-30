//--------------------------------------------------------//
//  File: BMPTEST.CPP                                     //
//  Desc: Sample PM program to display a BMP file         //
//--------------------------------------------------------//

#include "stdlib.h"
#include "stdio.h"
#include "string.h"

#include "bmp.h"

#define INCL_PM
#define INCL_BASE
#define INCL_NLS
#define INCL_DOSPROCESS
#include "os2.h"

HWND hFrame, hClient;      // PM hooks and handles
HMQ  hmq;
HAB  hab;
HPS  hps;
QMSG qmsg;

int wndW=600;              // initial window size
int wndH=450;

BmpImage * img = 0;        // BMP file content

//--------------------------------------------------------//
//   draw in the client window                            //
//--------------------------------------------------------//

void drawclient( HPS hps, HWND hwnd )
{
   // we don't bother with creating a bitmap and
   // getting a handle, etc.  PM provides an on-the-fly
   // BMP drawing function.

   int xo = 100;
   int yo = 10;

   POINTL pts[4];

   // dest area
   pts[0].x = xo;                 pts[0].y = yo;
   pts[1].x = xo + img->width();  pts[1].y = yo + img->height();

   // source area
   pts[2].x = 0;                  pts[2].y = 0;
   pts[3].x = img->width();       pts[3].y = img->height();

   GpiDrawBits( hps, img->bitmap( BMPOS2NEW ),
                (PBITMAPINFO2) img->bmaphdr( BMPOS2NEW ),
                4, pts, ROP_SRCCOPY, BBO_IGNORE );
}

//--------------------------------------------------------//
//  process WM_PAINT messages                             //
//--------------------------------------------------------//

void dopaint( HWND hwnd )
{
   HPS    hps;
   RECTL  rectl;
   hps = WinBeginPaint( hwnd, 0, &rectl );
   drawclient( hps, hwnd );
   WinEndPaint( hps );
}

//--------------------------------------------------------//
//  client window procedure                               //
//--------------------------------------------------------//

MRESULT EXPENTRY ClientWndProc( HWND hwnd, ULONG imsg,
                             MPARAM param1, MPARAM param2 )
{
   switch( imsg )
   {
      case WM_CREATE :
           // initialization stuff here
           break;

      case WM_ERASEBACKGROUND :
           // Force PM to paint window bg
           return (MRESULT) TRUE;

      case WM_PAINT :
           dopaint( hwnd );
           break;

      case WM_CLOSE :
           // termination stuff here
           WinPostMsg( hwnd, WM_QUIT, 0, 0 );
           break;
   }

   return WinDefWindowProc(hwnd,imsg,param1,param2);
}

//--------------------------------------------------------//
//                        M A I N                         //
//--------------------------------------------------------//

static unsigned char
       szClassName[14] = "BmpTest",
       szTitle[80] = "BMP Test Pgm - ";

void cdecl main( int argc, char *argv[] )
{
   char bmpname[80]; // path to a bmp file
   // file name passed as arg 1
   if( argc > 1 ) strcpy( bmpname, argv[1] );
   else           strcpy( bmpname, "JUPITER.BMP" );
   img = new BmpImage( bmpname );
   if( img->status() == FILEOKAY )
      strcat( (char *) szTitle, bmpname );
   else
      strcat( (char *) szTitle, "Error On Input!" );

   // Frame window creation flags
   ULONG FrameFlags = FCF_TITLEBAR | FCF_SIZEBORDER |
                      FCF_MINMAX | FCF_SYSMENU |
                      FCF_TASKLIST;

   // Initialize PM App
   hab = WinInitialize( 0 );
   hmq = WinCreateMsgQueue( 0L, 0 );

   // Register client window class
   WinRegisterClass( hab,
                     szClassName,
                     ClientWndProc,
                     CS_SIZEREDRAW,
                     0 );

   // Create the frame/client window pair
   hFrame = WinCreateStdWindow( HWND_DESKTOP,
                             0,
                             &FrameFlags,
                             szClassName,
                             szTitle,
                             0,
                             0,
                             1,
                             &hClient );
   WinSetWindowText( hFrame, szTitle );
   WinSetWindowPos( hFrame, HWND_TOP, 10, 10, wndW, wndH,
                    SWP_SIZE|SWP_MOVE|SWP_ACTIVATE|SWP_SHOW );

   // main message loop
   while( WinGetMsg( hab, &qmsg, 0, 0, 0 ) )
      WinDispatchMsg( hab, &qmsg );

   // app is done - clean up
   WinDestroyWindow( hFrame );
   WinDestroyMsgQueue( hmq );
   WinTerminate( hab );
   delete img;
}
