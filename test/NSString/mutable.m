#ifdef __MULLE_OBJC__
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#else
# import <Foundation/Foundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSMutableString   *ms;
      NSString          *s;
      unichar            buf[4];

      // initWithCapacity / stringWithCapacity
      ms = [[[NSMutableString alloc] initWithCapacity:32] autorelease];
      printf( "empty length: %lu\n", (unsigned long) [ms length]);

      // appendString
      [ms appendString:@"Hello"];
      [ms appendString:@", "];
      [ms appendString:@"World"];
      printf( "after appends: %s\n", [ms UTF8String]);
      printf( "length: %lu\n", (unsigned long) [ms length]);

      // characterAtIndex
      printf( "char[0]: %c\n", (char) [ms characterAtIndex:0]);
      printf( "char[7]: %c\n", (char) [ms characterAtIndex:7]);

      // substringWithRange
      s = [ms substringWithRange:NSMakeRange( 0, 5)];
      printf( "substr: %s\n", [s UTF8String]);

      // appendFormat
      ms = [NSMutableString stringWithCapacity:16];
      [ms appendFormat:@"val=%d", 42];
      printf( "appendFormat: %s\n", [ms UTF8String]);

      // replaceCharactersInRange:withString:
      ms = [[[NSMutableString alloc] initWithString:@"Hello World"] autorelease];
      [ms replaceCharactersInRange:NSMakeRange( 6, 5) withString:@"Mulle"];
      printf( "after replace: %s\n", [ms UTF8String]);

      // deleteCharactersInRange
      ms = [[[NSMutableString alloc] initWithString:@"Hello World"] autorelease];
      [ms deleteCharactersInRange:NSMakeRange( 5, 6)];
      printf( "after delete: %s\n", [ms UTF8String]);

      // setString
      ms = [[[NSMutableString alloc] initWithString:@"original"] autorelease];
      [ms setString:@"replaced"];
      printf( "after setString: %s\n", [ms UTF8String]);

      // mulleAppendCharacters:length:
      ms = [[[NSMutableString alloc] initWithCapacity:8] autorelease];
      buf[0] = 'A'; buf[1] = 'B'; buf[2] = 'C'; buf[3] = 0;
      [ms mulleAppendCharacters:buf length:3];
      printf( "mulleAppendCharacters: %s\n", [ms UTF8String]);

      // initWithStrings:count:
      {
         NSString   *parts[3];
         parts[0] = @"foo";
         parts[1] = @"bar";
         parts[2] = @"baz";
         ms = [[[NSMutableString alloc] initWithStrings:parts count:3] autorelease];
         printf( "initWithStrings: %s\n", [ms UTF8String]);
      }

      // copy / immutableCopy
      ms = [[[NSMutableString alloc] initWithString:@"test"] autorelease];
      s  = [[ms copy] autorelease];
      printf( "copy is NSString: %s\n", [s isKindOfClass:[NSString class]] ? "yes" : "no");
      s  = [[ms immutableCopy] autorelease];
      printf( "immutableCopy length: %lu\n", (unsigned long) [s length]);
   }
   return( 0);
}
