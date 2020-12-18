#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSNumber   *value;
   NSString   *s;

   value = [NSNumber numberWithInteger:-200000000L];
   s     = [value stringValue];
   printf( "%s\n", [s UTF8String]);

   return( 0);
}
