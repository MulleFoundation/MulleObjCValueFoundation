#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <stdint.h>
#include <string.h>


int   main( void)
{
   @autoreleasepool
   {
      NSString    *s;
      NSString    *s2;
      NSString    *s3;
      NSUInteger  len;
      NSUInteger  utf8len;

      //
      // NSString.m coverage: numerical value methods from strings
      //
      s = @"42";
      mulle_printf( "intValue: %d\n", [s intValue]);
      mulle_printf( "integerValue: %ld\n", (long) [s integerValue]);
      mulle_printf( "longLongValue: %lld\n", [s longLongValue]);
      mulle_printf( "doubleValue: %g\n", [s doubleValue]);
      mulle_printf( "floatValue: %g\n", (double) [s floatValue]);

      s = @"  -99";
      mulle_printf( "leading-space intValue: %d\n", [s intValue]);

      s = @"YES";
      mulle_printf( "YES boolValue: %d\n", (int) [s boolValue]);
      s = @"true";
      mulle_printf( "true boolValue: %d\n", (int) [s boolValue]);
      s = @"0";
      mulle_printf( "0 boolValue: %d\n", (int) [s boolValue]);
      s = @"1";
      mulle_printf( "1 boolValue: %d\n", (int) [s boolValue]);

      //
      // stringByAppendingString: chaining
      //
      s = @"foo";
      s2 = [s stringByAppendingString:@"bar"];
      mulle_printf( "append foobar: %s\n", [s2 UTF8String]);
      s3 = [s2 stringByAppendingString:@"baz"];
      mulle_printf( "append foobarbaz: %s\n", [s3 UTF8String]);

      //
      // isEqualToString: various cases
      //
      mulle_printf( "isEqualToString same: %s\n",
         [@"hello" isEqualToString:@"hello"] ? "yes" : "no");
      mulle_printf( "isEqualToString diff: %s\n",
         [@"hello" isEqualToString:@"world"] ? "yes" : "no");
      mulle_printf( "isEqualToString empty: %s\n",
         [@"" isEqualToString:@""] ? "yes" : "no");
      mulle_printf( "isEqualToString prefix-only: %s\n",
         [@"hel" isEqualToString:@"hello"] ? "yes" : "no");

      //
      // hasPrefix: / hasSuffix: on longer strings
      //
      s = @"Hello, World!";
      mulle_printf( "hasPrefix Hello: %s\n", [s hasPrefix:@"Hello"] ? "yes" : "no");
      mulle_printf( "hasPrefix World: %s\n", [s hasPrefix:@"World"] ? "yes" : "no");
      mulle_printf( "hasPrefix empty: %s\n", [s hasPrefix:@""] ? "yes" : "no");
      mulle_printf( "hasSuffix !: %s\n", [s hasSuffix:@"!"] ? "yes" : "no");
      mulle_printf( "hasSuffix World!: %s\n", [s hasSuffix:@"World!"] ? "yes" : "no");
      mulle_printf( "hasSuffix Hello: %s\n", [s hasSuffix:@"Hello"] ? "yes" : "no");

      //
      // substringWithRange: edge cases
      //
      s = @"abcdefg";
      s2 = [s substringWithRange:NSMakeRange( 0, 0)]; // empty range
      mulle_printf( "substr empty range len: %lu\n", (unsigned long) [s2 length]);

      s2 = [s substringWithRange:NSMakeRange( 0, [s length])]; // full range
      mulle_printf( "substr full range: %s\n", [s2 UTF8String]);

      s2 = [s substringWithRange:NSMakeRange( 2, 3)]; // "cde"
      mulle_printf( "substr [2,3]: %s\n", [s2 UTF8String]);

      //
      // substringFromIndex: and substringToIndex:
      //
      s = @"0123456789";
      s2 = [s substringFromIndex:0];
      mulle_printf( "substringFrom(0): %s\n", [s2 UTF8String]);
      s2 = [s substringFromIndex:9];
      mulle_printf( "substringFrom(9): %s\n", [s2 UTF8String]);
      s2 = [s substringToIndex:0];
      mulle_printf( "substringTo(0) len: %lu\n", (unsigned long) [s2 length]);
      s2 = [s substringToIndex:5];
      mulle_printf( "substringTo(5): %s\n", [s2 UTF8String]);

      //
      // mulleUTF8StringLength vs length (ASCII, should be equal)
      //
      s = @"hello";
      mulle_printf( "ascii length: %lu\n", (unsigned long) [s length]);
      mulle_printf( "ascii mulleUTF8StringLength: %lu\n", (unsigned long) [s mulleUTF8StringLength]);

      //
      // mulleGetUTF8String:bufferSize:
      //
      {
         char buf[32];
         len = [s mulleGetUTF8String:buf bufferSize:sizeof( buf)];
         mulle_printf( "mulleGetUTF8String: %s len=%lu\n", buf, (unsigned long) len);
      }

      //
      // mulleGetUTF8Characters:maxLength:range:
      //
      {
         char buf[16];
         s = @"Hello World";
         utf8len = [s mulleGetUTF8Characters:buf
                                   maxLength:sizeof( buf)
                                       range:NSMakeRange( 6, 5)];
         buf[ utf8len] = '\0';
         mulle_printf( "mulleGetUTF8CharactersRange: %s len=%lu\n", buf, (unsigned long) utf8len);
      }

      //
      // description returns self
      //
      s = @"test";
      mulle_printf( "description: %s\n", [[s description] UTF8String]);

      //
      // NSString.m UTF8String fallback (generic Unicode conversion)
      // Use a string created via unichar buffer — exercises the UTF8String generic code
      //
      {
         unichar  chars[] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H' };
         s = [[[NSString alloc] initWithCharacters:chars length:8] autorelease];
         mulle_printf( "8-char unichar UTF8String: %s\n", [s UTF8String]);
         mulle_printf( "8-char unichar length: %lu\n", (unsigned long) [s length]);
      }

      //
      // mulleUTF16String
      //
      {
         s = @"ABC";
         mulle_utf16_t  *u16 = [s mulleUTF16String];
         mulle_printf( "mulleUTF16String[0]=%d [1]=%d [2]=%d\n",
            (int) u16[0], (int) u16[1], (int) u16[2]);
      }

      //
      // mulleStringByRemovingPrefix: / mulleStringByRemovingSuffix:
      //
      s = @"foobar";
      s2 = [s mulleStringByRemovingPrefix:@"foo"];
      mulle_printf( "removePrefix: %s\n", [s2 UTF8String]);
      s2 = [s mulleStringByRemovingSuffix:@"bar"];
      mulle_printf( "removeSuffix: %s\n", [s2 UTF8String]);
      s2 = [s mulleStringByRemovingPrefix:@"baz"]; // no match -> self
      mulle_printf( "removePrefix no-match: %s\n", [s2 UTF8String]);

      //
      // stringByPaddingToLength:withString:startingAtIndex:
      //
      // stringValue on NSString
      //
      s = @"hello";
      mulle_printf( "stringValue: %s\n", [[s stringValue] UTF8String]);

      //
      // mulleGetUTF8Characters: (no length limit)
      //
      {
         char buf[32];
         s = @"test";
         [s mulleGetUTF8Characters:buf];
         buf[4] = '\0';
         mulle_printf( "mulleGetUTF8Characters no-limit: %s\n", buf);
      }

      //
      // string + init
      //
      s = [NSString string];
      mulle_printf( "empty string length: %lu\n", (unsigned long) [s length]);
   }
   return( 0);
}
