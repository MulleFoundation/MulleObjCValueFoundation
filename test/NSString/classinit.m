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
      NSString  *s;

      //
      // initWithCharacters:length: with non-ASCII unichar buffer
      // ü=0x00FC, ß=0x00DF — exercises UTF-16/32 path in ClassCluster
      //
      {
         unichar chars[] = { 'H', 0x00FC, 'r', 0x00DF }; // "Hürf" — ü and ß
         s = [[[NSString alloc] initWithCharacters:chars length:4] autorelease];
         mulle_printf( "initWithCharacters UTF8: %s\n", [s UTF8String]);
         mulle_printf( "initWithCharacters length: %lu\n", (unsigned long) [s length]);
      }

      //
      // initWithCharacters:length: with emoji (UTF-32 range)
      //
      {
         unichar chars[] = { 0x1F600 }; // U+1F600 😀 — only fits in UTF-32
         s = [[[NSString alloc] initWithCharacters:chars length:1] autorelease];
         mulle_printf( "initWithCharacters emoji char[0]=0x%05x\n",
            (unsigned) [s characterAtIndex:0]);
      }

      //
      // initWithCharactersNoCopy:length:freeWhenDone:NO
      // The buffer is static — freeWhenDone:NO means allocator is NULL
      //
      {
         static unichar  shared_chars[] = { 'M', 'u', 'l', 'l', 'e' };
         s = [[[NSString alloc] initWithCharactersNoCopy:shared_chars
                                                  length:5
                                            freeWhenDone:NO] autorelease];
         mulle_printf( "noCopy:NO UTF8: %s\n", [s UTF8String]);
         mulle_printf( "noCopy:NO length: %lu\n", (unsigned long) [s length]);
      }

      //
      // initWithCharactersNoCopy:length:freeWhenDone:YES
      // The runtime will free the buffer with free()
      //
      {
         unichar   *heap_chars;
         heap_chars = malloc( 3 * sizeof( unichar));
         heap_chars[0] = 'f';
         heap_chars[1] = 'o';
         heap_chars[2] = 'o';
         s = [[[NSString alloc] initWithCharactersNoCopy:heap_chars
                                                  length:3
                                            freeWhenDone:YES] autorelease];
         mulle_printf( "noCopy:YES UTF8: %s\n", [s UTF8String]);
      }

      //
      // mulleInitOrNilWithUTF8Characters:length: — valid UTF-8
      //
      {
         char  utf8[] = { 'h', 'e', 'l', 'l', 'o' };
         s = [[[NSString alloc] mulleInitOrNilWithUTF8Characters:utf8
                                                          length:5] autorelease];
         mulle_printf( "mulleInitOrNil valid: %s\n", s ? [s UTF8String] : "nil");
      }

      //
      // mulleInitOrNilWithUTF8Characters:length: — invalid UTF-8 (0xFF is not valid)
      //
      {
         char  bad[] = { 'h', 'i', (char) 0xFF, 'l', 'o' };
         s = [[[NSString alloc] mulleInitOrNilWithUTF8Characters:bad
                                                          length:5] autorelease];
         mulle_printf( "mulleInitOrNil bad: %s\n", s == nil ? "nil" : "not-nil");
      }

      //
      // mulleInitWithCharactersNoCopy:length:allocator: with NULL allocator (shared/borrowed)
      //
      {
         static unichar  static_chars[] = { 'A', 'B', 'C', 'D', 'E', 'F', 'G' };
         s = [[[NSString alloc] mulleInitWithCharactersNoCopy:static_chars
                                                       length:7
                                                    allocator:NULL] autorelease];
         mulle_printf( "noCopy allocator NULL: %s\n", [s UTF8String]);
         mulle_printf( "noCopy allocator NULL length: %lu\n", (unsigned long) [s length]);
      }

      //
      // Various length classes to hit tagged-pointer/concrete paths
      //

      // 1-char string
      {
         char   c[] = { 'x' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:1] autorelease];
         mulle_printf( "1-char: %s\n", [s UTF8String]);
      }

      // 5-char string (char5 TPS boundary)
      {
         char   c[] = { 'a', 'b', 'c', 'd', 'e' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:5] autorelease];
         mulle_printf( "5-char: %s\n", [s UTF8String]);
      }

      // 7-char string (char7 TPS boundary)
      {
         char   c[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:7] autorelease];
         mulle_printf( "7-char: %s\n", [s UTF8String]);
      }

      // 8-char string (just past char7)
      {
         char   c[] = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:8] autorelease];
         mulle_printf( "8-char: %s\n", [s UTF8String]);
      }

      // 11-char string
      {
         char   c[] = { 'h','e','l','l','o',' ','w','o','r','l','d' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:11] autorelease];
         mulle_printf( "11-char: %s\n", [s UTF8String]);
      }

      // 15-char string
      {
         char   c[] = { 'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o' };
         s = [[[NSString alloc] mulleInitWithUTF8Characters:c length:15] autorelease];
         mulle_printf( "15-char: %s\n", [s UTF8String]);
      }

      // Long string (>= 256 bytes goes to generic class)
      {
         char  longbuf[300];
         memset( longbuf, 'x', 300);
         s = [[[NSString alloc] mulleInitWithUTF8Characters:longbuf length:300] autorelease];
         mulle_printf( "300-char length: %lu\n", (unsigned long) [s length]);
      }

      //
      // initWithString: exercises ClassCluster path
      //
      {
         s = [[[NSString alloc] initWithString:@"copy me"] autorelease];
         mulle_printf( "initWithString: %s\n", [s UTF8String]);
      }

      //
      // init exercises generic ClassCluster path
      //
      {
         s = [[[NSString alloc] init] autorelease];
         mulle_printf( "init empty length: %lu\n", (unsigned long) [s length]);
      }

      //
      // mulleStringWithCharactersNoCopy:length:allocator: class method
      //
      {
         unichar  *heap = malloc( 4 * sizeof( unichar));
         heap[0] = 'M'; heap[1] = 'u'; heap[2] = 'l'; heap[3] = 'l';
         s = [NSString mulleStringWithCharactersNoCopy:heap
                                                length:4
                                             allocator:&mulle_stdlib_allocator];
         mulle_printf( "classNoCopy: %s\n", [s UTF8String]);
      }

      //
      // mulleStringWithUTF16String:
      //
      {
         mulle_utf16_t  u16[] = { 'A', 'B', 'C', 0 };
         s = [NSString mulleStringWithUTF16String:u16];
         mulle_printf( "mulleStringWithUTF16: %s\n", [s UTF8String]);
      }

      //
      // mulleAreValidUTF8Characters:length:
      //
      {
         char  good[] = { 'h', 'e', 'l', 'l', 'o' };
         char  bad[]  = { 'h', 'i', (char) 0xFF };
         mulle_printf( "validUTF8 good: %s\n",
            [NSString mulleAreValidUTF8Characters:good length:5] ? "yes" : "no");
         mulle_printf( "validUTF8 bad: %s\n",
            [NSString mulleAreValidUTF8Characters:bad length:3] ? "yes" : "no");
      }

      //
      // stringWithCharacters:length: class method
      //
      {
         unichar chars[] = { 'Z', 'A', 'P' };
         s = [NSString stringWithCharacters:chars length:3];
         mulle_printf( "stringWithCharacters: %s\n", [s UTF8String]);
      }

      //
      // mulleStringWithUTF8CharactersNoCopy:length:allocator:
      //
      {
         char  *heap = malloc( 5);
         memcpy( heap, "hello", 5);
         s = [NSString mulleStringWithUTF8CharactersNoCopy:heap
                                                    length:5
                                                 allocator:&mulle_stdlib_allocator];
         mulle_printf( "mulleUTF8NoCopy: %s\n", [s UTF8String]);
      }
   }
   return( 0);
}
