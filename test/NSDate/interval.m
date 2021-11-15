#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSDate   *value;

   value = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0] autorelease];
   printf( "2001: %.1f\n", [value timeIntervalSinceReferenceDate]);
   printf( "1970: %.1f\n", [value timeIntervalSince1970]);

   value = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:1.5] autorelease];

   printf( "2001: %.1f\n", [value timeIntervalSinceReferenceDate]);
   printf( "1970: %.1f\n", [value timeIntervalSince1970]);

   return( 0);
}
