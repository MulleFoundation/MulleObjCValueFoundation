#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <limits.h>


int   main( void)
{
   @autoreleasepool
   {
      NSNumber   *parsed;
      NSNumber   *parsedFloat;

      // stringValue / UTF8String for various types
      mulle_printf( "%s\n", [[NSNumber numberWithInt:42] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithInt:-1] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithDouble:3.14] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithFloat:1.5f] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithBool:YES] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithBool:NO] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithUnsignedInt:255] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithLongLong:LLONG_MAX] UTF8String]);
      mulle_printf( "%s\n", [[NSNumber numberWithUnsignedLongLong:ULLONG_MAX] UTF8String]);

      // mulleInitWithString: — NSNumber parsing a string
      parsed = [[[NSNumber alloc] mulleInitWithString:@"42"] autorelease];
      mulle_printf( "parsed int: %d\n", [parsed intValue]);

      parsedFloat = [[[NSNumber alloc] mulleInitWithString:@"3.14"] autorelease];
      mulle_printf( "parsed float: %g\n", [parsedFloat doubleValue]);
   }

   return( 0);
}
