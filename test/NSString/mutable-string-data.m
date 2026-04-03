#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <string.h>
#include <stdlib.h>

int   main( void)
{
   @autoreleasepool
   {
      NSMutableString  *ms;
      char             *utf8 = "Hello, World!";
      NSUInteger       len   = 13;

      // initWithBytes:length:encoding: (NSMutableString+NSData)
      ms = [[[NSMutableString alloc] initWithBytes:utf8
                                            length:len
                                          encoding:NSUTF8StringEncoding] autorelease];
      mulle_printf( "initWithBytes UTF8: %s\n", [ms UTF8String]);
      mulle_printf( "initWithBytes length: %lu\n", (unsigned long)[ms length]);

      // nil/empty path — zero length
      ms = [[[NSMutableString alloc] initWithBytes:utf8
                                            length:0
                                          encoding:NSUTF8StringEncoding] autorelease];
      mulle_printf( "initWithBytes zero length: %lu\n", (unsigned long)[ms length]);

      // initWithBytesNoCopy:length:encoding:freeWhenDone:NO
      {
         static char  staticBuf[] = "NoCopy";
         ms = [[[NSMutableString alloc] initWithBytesNoCopy:staticBuf
                                                     length:6
                                                   encoding:NSUTF8StringEncoding
                                               freeWhenDone:NO] autorelease];
         mulle_printf( "initWithBytesNoCopy NO: %s\n", [ms UTF8String]);
      }

      // initWithBytesNoCopy:length:encoding:freeWhenDone:YES (heap buffer)
      {
         char  *heap = malloc( 5);
         memcpy( heap, "Heap!", 5);
         ms = [[[NSMutableString alloc] initWithBytesNoCopy:heap
                                                     length:5
                                                   encoding:NSUTF8StringEncoding
                                               freeWhenDone:YES] autorelease];
         mulle_printf( "initWithBytesNoCopy YES: %s\n", [ms UTF8String]);
      }
   }
   return( 0);
}
