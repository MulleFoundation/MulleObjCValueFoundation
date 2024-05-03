#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


MULLE_OBJC_GLOBAL
void   MulleObjCHTMLDumpUniverse( void);


int   main( void)
{
   id   value;

   value = [NSData data];
   mulle_printf( "NSData -mulleIsThreadSafe: %btd\n", [value mulleIsThreadSafe]);

   value = [NSMutableData data];
   mulle_printf( "NSMutableData -mulleIsThreadSafe: %btd\n", [value mulleIsThreadSafe]);

   MulleObjCHTMLDumpUniverse();

   return( 0);
}
