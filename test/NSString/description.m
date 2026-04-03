#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
# import <MulleObjC/NSDebug.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
#ifdef __MULLE_OBJC__
      MulleObjCDebugElideAddressOutput = YES;
#endif

      // NSNull description
      mulle_printf( "%s\n", [[NSNull null] UTF8String]);

      // NSString class description
      mulle_printf( "%s\n", [[NSString class] UTF8String]);

      // string instance description
      mulle_printf( "%s\n", [@"hello" UTF8String]);

      // debugDescription (address elided for deterministic output)
      mulle_printf( "%s\n", [[@"hello" debugDescription] UTF8String]);

      // NSNumber via NSObject+NSString
      mulle_printf( "%s\n", [[NSNumber numberWithInt:42] UTF8String]);
   }

   return( 0);
}
