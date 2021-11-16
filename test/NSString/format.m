#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSString   *value;

   value = [NSString stringWithFormat:@"%d %@ %s %lu %tu %lld", 1, @2, "3", 4L, (NSUInteger) 5, 6LL];
   printf( "%s\n", [value UTF8String]);
   return( 0);
}
