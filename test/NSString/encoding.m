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
      NSData     *data;
      NSUInteger  len;

      // --- fastestEncoding / smallestEncoding ---
      s = @"Hello";
      printf( "fastestEncoding: %lu\n", (unsigned long) [s fastestEncoding]);
      printf( "smallestEncoding: %lu\n", (unsigned long) [s smallestEncoding]);

      // --- canBeConvertedToEncoding ---
      printf( "canBeASCII: %s\n",   [s canBeConvertedToEncoding:NSASCIIStringEncoding] ? "yes" : "no");
      printf( "canBeUTF8: %s\n",    [s canBeConvertedToEncoding:NSUTF8StringEncoding] ? "yes" : "no");
      printf( "canBeUTF16: %s\n",   [s canBeConvertedToEncoding:NSUTF16StringEncoding] ? "yes" : "no");

      // non-ASCII string can not be ASCII
      {
         char         cafe_utf8[] = { 'c', 'a', 'f', (char) 0xc3, (char) 0xa9, '\0' };
         NSString     *cafe;

         cafe = [[[NSString alloc] initWithUTF8String:cafe_utf8] autorelease];
         printf( "cafe canBeASCII: %s\n", [cafe canBeConvertedToEncoding:NSASCIIStringEncoding] ? "yes" : "no");
      }

      // --- dataUsingEncoding: UTF8 ---
      s    = @"Hello";
      data = [s dataUsingEncoding:NSUTF8StringEncoding];
      printf( "utf8 data length: %lu\n", (unsigned long) [data length]);

      // --- dataUsingEncoding: ASCII ---
      data = [s dataUsingEncoding:NSASCIIStringEncoding];
      printf( "ascii data length: %lu\n", (unsigned long) [data length]);

      // --- mulleDataUsingEncoding:encodingOptions: with BOM ---
      data = [s mulleDataUsingEncoding:NSUTF8StringEncoding
                       encodingOptions:MulleStringEncodingOptionBOM];
      // UTF-8 BOM is 3 bytes (EF BB BF) + 5 bytes = 8
      printf( "utf8 bom data length: %lu\n", (unsigned long) [data length]);

      // --- dataUsingEncoding: UTF16 (includes BOM) ---
      s    = @"Hi";
      data = [s dataUsingEncoding:NSUTF16StringEncoding];
      // BOM (2) + 2 chars * 2 = 6
      printf( "utf16 data length: %lu\n", (unsigned long) [data length]);

      // --- lengthOfBytesUsingEncoding ---
      s   = @"Hello";
      len = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
      printf( "utf8 byte length: %lu\n", (unsigned long) len);
      len = [s lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
      printf( "ascii byte length: %lu\n", (unsigned long) len);

      // --- initWithData:encoding: (UTF8 round-trip) ---
      data = [@"RoundTrip" dataUsingEncoding:NSUTF8StringEncoding];
      s    = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
      printf( "roundtrip utf8: %s\n", [s UTF8String]);

      // --- initWithBytes:length:encoding: UTF8 ---
      {
         const char *utf8bytes = "Bytes";
         s = [[[NSString alloc] initWithBytes:(void *)utf8bytes
                                       length:5
                                     encoding:NSUTF8StringEncoding] autorelease];
         printf( "initWithBytes utf8: %s\n", [s UTF8String]);
      }

      // --- initWithBytes:length:encoding: ASCII ---
      {
         const char *ascii = "ASCII";
         s = [[[NSString alloc] initWithBytes:(void *)ascii
                                       length:5
                                     encoding:NSASCIIStringEncoding] autorelease];
         printf( "initWithBytes ascii: %s\n", [s UTF8String]);
      }

      // --- mulleStringWithData:encoding: ---
      data = [@"DataFactory" dataUsingEncoding:NSUTF8StringEncoding];
      s    = [NSString mulleStringWithData:data encoding:NSUTF8StringEncoding];
      printf( "mulleStringWithData: %s\n", [s UTF8String]);

      // --- mulleStringWithUTF8Data: ---
      data = [@"UTF8Data" dataUsingEncoding:NSUTF8StringEncoding];
      s    = [NSString mulleStringWithUTF8Data:data];
      printf( "mulleStringWithUTF8Data: %s\n", [s UTF8String]);

      // --- MulleStringEncodingUTF8String ---
      printf( "encoding name utf8: %s\n",  MulleStringEncodingUTF8String( NSUTF8StringEncoding));
      printf( "encoding name ascii: %s\n", MulleStringEncodingUTF8String( NSASCIIStringEncoding));
      printf( "encoding name utf16: %s\n", MulleStringEncodingUTF8String( NSUTF16StringEncoding));

      // --- MulleStringEncodingParseUTF8String ---
      printf( "parse utf8: %lu\n",  (unsigned long) MulleStringEncodingParseUTF8String( "UTF8"));
      printf( "parse ascii: %lu\n", (unsigned long) MulleStringEncodingParseUTF8String( "ASCII"));

      // --- availableStringEncodings ---
      {
         NSStringEncoding   *enc = [NSString availableStringEncodings];
         int                 count = 0;
         while( *enc)
         {
            count++;
            enc++;
         }
         printf( "encoding count: %d\n", count);
      }

      // --- getBytes:maxLength:usedLength:encoding:options:range:remainingRange: ---
      {
         char       buf[32];
         NSUInteger used = 0;
         NSRange    remaining;

         s = @"Hello";
         [s getBytes:buf
           maxLength:sizeof( buf) - 1
          usedLength:&used
            encoding:NSUTF8StringEncoding
             options:0
               range:NSMakeRange( 0, 5)
      remainingRange:&remaining];
         buf[used] = '\0';
         printf( "getBytes: %s used=%lu\n", buf, (unsigned long) used);
      }
   }
   return( 0);
}
