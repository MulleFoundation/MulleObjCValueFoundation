#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
# import <MulleObjC/NSDebug.h>
#endif


int   main( void)
{
   mulle_printf( "%@\n", @">>😳<<");
   return( 0);
}
