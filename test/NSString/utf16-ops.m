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
      NSString    *s1;
      NSString    *s2;
      NSString    *s3;
      NSString    *sub;
      NSData      *data;
      unichar     buf[32];
      char        utf8buf[64];
      NSUInteger  len;
      NSUInteger  utf8len;

      //
      // UTF-16 strings (non-ASCII, fits in 15-bit / UTF-16 range)
      // "über" : ü=U+00FC, b, e, r — forces UTF16 internal representation
      //
      {
         uint8_t bytes[] = { 0xC3, 0xBC, 'b', 'e', 'r' }; // "über"
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s1 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "utf16 UTF8String: %s\n", [s1 UTF8String]);
      mulle_printf( "utf16 length: %lu\n", (unsigned long) [s1 length]);
      mulle_printf( "utf16 mulleUTF8StringLength: %lu\n", (unsigned long) [s1 mulleUTF8StringLength]);
      mulle_printf( "utf16 hash nonzero: %s\n", [s1 hash] != 0 ? "yes" : "no");

      // characterAtIndex:
      mulle_printf( "utf16 char[0]=0x%04x\n", (unsigned) [s1 characterAtIndex:0]); // ü = 0x00FC
      mulle_printf( "utf16 char[1]=%c\n", (char) [s1 characterAtIndex:1]); // b

      //
      // "naïve" : n, a, ï=U+00EF, v, e
      //
      {
         uint8_t bytes[] = { 'n', 'a', 0xC3, 0xAF, 'v', 'e' }; // "naïve"
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s2 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "naïve UTF8String: %s\n", [s2 UTF8String]);
      mulle_printf( "naïve length: %lu\n", (unsigned long) [s2 length]);

      // isEqual: same
      {
         uint8_t bytes[] = { 0xC3, 0xBC, 'b', 'e', 'r' };
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         NSString *copy = [NSString mulleStringWithUTF8Data:d];
         mulle_printf( "isEqual same: %s\n", [s1 isEqual:copy] ? "yes" : "no");
         mulle_printf( "isEqual diff: %s\n", [s1 isEqual:s2] ? "yes" : "no");
         mulle_printf( "isEqualToString same: %s\n", [s1 isEqualToString:copy] ? "yes" : "no");
      }

      // hasPrefix: / hasSuffix:
      mulle_printf( "naïve hasPrefix na: %s\n", [s2 hasPrefix:@"na"] ? "yes" : "no");
      mulle_printf( "naïve hasSuffix ve: %s\n", [s2 hasSuffix:@"ve"] ? "yes" : "no");
      mulle_printf( "naïve hasPrefix ber: %s\n", [s2 hasPrefix:@"ber"] ? "yes" : "no");

      // substringWithRange:
      sub = [s2 substringWithRange:NSMakeRange( 2, 2)]; // ïv
      mulle_printf( "naïve substr[2,2]: %s\n", [sub UTF8String]);

      // substringFromIndex: / substringToIndex:
      sub = [s2 substringFromIndex:3];
      mulle_printf( "naïve substringFrom(3): %s\n", [sub UTF8String]);
      sub = [s2 substringToIndex:2];
      mulle_printf( "naïve substringTo(2): %s\n", [sub UTF8String]);

      // getCharacters:range:
      [s2 getCharacters:buf range:NSMakeRange( 0, 3)];
      mulle_printf( "naïve getCharacters[0..2]: 0x%04x 0x%04x 0x%04x\n",
         (unsigned) buf[0], (unsigned) buf[1], (unsigned) buf[2]);

      // getCharacters: (full)
      len = [s2 length];
      [s2 getCharacters:buf];
      mulle_printf( "naïve getCharacters full len=%lu\n", (unsigned long) len);

      // mulleGetUTF8Characters:maxLength:
      utf8len = [s2 mulleGetUTF8Characters:utf8buf maxLength:sizeof( utf8buf)];
      utf8buf[ utf8len] = '\0';
      mulle_printf( "naïve mulleGetUTF8Characters: %s len=%lu\n", utf8buf, (unsigned long) utf8len);

      // dataUsingEncoding: UTF8
      data = [s2 dataUsingEncoding:NSUTF8StringEncoding];
      mulle_printf( "naïve utf8 data len: %lu\n", (unsigned long) [data length]);

      // dataUsingEncoding: UTF16
      data = [s2 dataUsingEncoding:NSUTF16StringEncoding];
      mulle_printf( "naïve utf16 data len: %lu\n", (unsigned long) [data length]);

      // stringByAppendingString:
      s3 = [s1 stringByAppendingString:s2];
      mulle_printf( "utf16 append: %s\n", [s3 UTF8String]);

      //
      // Longer UTF-16 string: "Grüß" — forces non-trivial path
      //
      {
         uint8_t bytes[] = { 'G', 'r', 0xC3, 0xBC, 0xC3, 0x9F }; // "Grüß"
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s3 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "gruss UTF8String: %s\n", [s3 UTF8String]);
      mulle_printf( "gruss length: %lu\n", (unsigned long) [s3 length]);
      mulle_printf( "gruss char[2]=0x%04x\n", (unsigned) [s3 characterAtIndex:2]); // ü=0x00FC
      mulle_printf( "gruss char[3]=0x%04x\n", (unsigned) [s3 characterAtIndex:3]); // ß=0x00DF

      //
      // UTF-32 strings (characters > U+FFFF — emoji force UTF32)
      //
      {
         uint8_t bytes[] = { 0xF0, 0x9F, 0x98, 0x80 }; // 😀 U+1F600
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s1 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "emoji UTF8String len: %lu\n", (unsigned long) strlen( [s1 UTF8String]));
      mulle_printf( "emoji length: %lu\n", (unsigned long) [s1 length]);
      mulle_printf( "emoji mulleUTF8StringLength: %lu\n", (unsigned long) [s1 mulleUTF8StringLength]);
      mulle_printf( "emoji char[0]=0x%05x\n", (unsigned) [s1 characterAtIndex:0]); // U+1F600
      mulle_printf( "emoji hash nonzero: %s\n", [s1 hash] != 0 ? "yes" : "no");

      // isEqual: on UTF32 string
      {
         uint8_t bytes[] = { 0xF0, 0x9F, 0x98, 0x80 };
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         NSString *copy = [NSString mulleStringWithUTF8Data:d];
         mulle_printf( "emoji isEqual same: %s\n", [s1 isEqual:copy] ? "yes" : "no");
         mulle_printf( "emoji isEqualToString same: %s\n", [s1 isEqualToString:copy] ? "yes" : "no");
      }

      // Mixed ASCII+emoji: "Hi 😀"
      {
         uint8_t bytes[] = { 'H', 'i', ' ', 0xF0, 0x9F, 0x98, 0x80 };
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s2 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "mixed UTF8String: %s\n", [s2 UTF8String]);
      mulle_printf( "mixed length: %lu\n", (unsigned long) [s2 length]);
      mulle_printf( "mixed mulleUTF8StringLength: %lu\n", (unsigned long) [s2 mulleUTF8StringLength]);

      // getCharacters: on UTF32 mixed
      len = [s2 length];
      [s2 getCharacters:buf];
      mulle_printf( "mixed getCharacters[0]=%c\n", (char) buf[0]); // H
      mulle_printf( "mixed getCharacters[3]=0x%05x\n", (unsigned) buf[3]); // U+1F600

      // substringWithRange: on UTF32
      sub = [s2 substringWithRange:NSMakeRange( 0, 2)]; // "Hi"
      mulle_printf( "mixed substr[0,2]: %s\n", [sub UTF8String]);

      sub = [s2 substringFromIndex:3]; // emoji
      mulle_printf( "mixed substringFrom(3): %s\n", [sub UTF8String]);

      // hasPrefix/hasSuffix on UTF32
      mulle_printf( "mixed hasPrefix Hi: %s\n", [s2 hasPrefix:@"Hi"] ? "yes" : "no");

      // dataUsingEncoding: on UTF32
      data = [s2 dataUsingEncoding:NSUTF8StringEncoding];
      mulle_printf( "mixed utf8 data len: %lu\n", (unsigned long) [data length]);

      data = [s2 dataUsingEncoding:NSUTF32StringEncoding];
      mulle_printf( "mixed utf32 data len: %lu\n", (unsigned long) [data length]);

      // mulleGetUTF8Characters:maxLength: on UTF32
      utf8len = [s2 mulleGetUTF8Characters:utf8buf maxLength:sizeof( utf8buf)];
      utf8buf[ utf8len] = '\0';
      mulle_printf( "mixed mulleGetUTF8Chars len=%lu\n", (unsigned long) utf8len);

      // Multiple emojis
      {
         uint8_t bytes[] = {
            0xF0, 0x9F, 0x98, 0x80,  // 😀 U+1F600
            0xF0, 0x9F, 0x98, 0x8E   // 😎 U+1F60E
         };
         NSData *d = [NSData dataWithBytes:bytes length:sizeof( bytes)];
         s3 = [NSString mulleStringWithUTF8Data:d];
      }
      mulle_printf( "two-emoji length: %lu\n", (unsigned long) [s3 length]);
      mulle_printf( "two-emoji char[0]=0x%05x\n", (unsigned) [s3 characterAtIndex:0]);
      mulle_printf( "two-emoji char[1]=0x%05x\n", (unsigned) [s3 characterAtIndex:1]);

      // getCharacters:range: on UTF32
      [s3 getCharacters:buf range:NSMakeRange( 0, 2)];
      mulle_printf( "two-emoji getCharsRange: 0x%05x 0x%05x\n",
         (unsigned) buf[0], (unsigned) buf[1]);

      // UTF32 substringWithRange same length returns self
      sub = [s3 substringWithRange:NSMakeRange( 0, [s3 length])];
      mulle_printf( "two-emoji full range is-same: %s\n", sub == s3 ? "yes" : "no");
   }
   return( 0);
}
