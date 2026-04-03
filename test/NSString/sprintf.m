#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSString   *s;

      // --- stringWithFormat ---
      s = [NSString stringWithFormat:@"%d", 42];
      printf( "format int: %s\n", [s UTF8String]);

      s = [NSString stringWithFormat:@"hello %@", @"world"];
      printf( "format string: %s\n", [s UTF8String]);

      s = [NSString stringWithFormat:@"%s %lu", "test", (unsigned long) 99UL];
      printf( "format cs ul: %s\n", [s UTF8String]);

      // --- initWithFormat: ---
      s = [[[NSString alloc] initWithFormat:@"x=%d y=%d", 3, 7] autorelease];
      printf( "initWithFormat: %s\n", [s UTF8String]);

      // --- stringByAppendingFormat: ---
      s = [@"base" stringByAppendingFormat:@"-%d", 5];
      printf( "appendFormat: %s\n", [s UTF8String]);
   }
   return( 0);
}
