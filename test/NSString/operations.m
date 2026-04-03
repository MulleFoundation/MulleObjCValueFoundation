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
      NSString   *s2;

      // --- isEqual: / isEqualToString: ---
      s  = @"Hello";
      s2 = @"Hello";
      printf( "isEqual same: %s\n",        [s isEqual:s2] ? "yes" : "no");
      printf( "isEqual diff: %s\n",        [s isEqual:@"World"] ? "yes" : "no");
      printf( "isEqualToString: %s\n",     [s isEqualToString:@"Hello"] ? "yes" : "no");
      printf( "isEqualToString diff: %s\n",[s isEqualToString:@"hello"] ? "yes" : "no");

      // --- hash ---
      printf( "hash nonzero: %s\n", [s hash] != 0 ? "yes" : "no");
      printf( "same hash: %s\n",    [s hash] == [s2 hash] ? "yes" : "no");

      // --- hasPrefix: / hasSuffix: ---
      s = @"Hello World";
      printf( "hasPrefix: %s\n",  [s hasPrefix:@"Hello"] ? "yes" : "no");
      printf( "noPrefix: %s\n",   [s hasPrefix:@"World"] ? "yes" : "no");
      printf( "hasSuffix: %s\n",  [s hasSuffix:@"World"] ? "yes" : "no");
      printf( "noSuffix: %s\n",   [s hasSuffix:@"Hello"] ? "yes" : "no");

      // --- substringFromIndex: / substringToIndex: ---
      s = @"Hello World";
      s2 = [s substringFromIndex:6];
      printf( "substringFrom: %s\n", [s2 UTF8String]);
      s2 = [s substringToIndex:5];
      printf( "substringTo: %s\n",  [s2 UTF8String]);

      // --- substringWithRange: ---
      s2 = [s substringWithRange:NSMakeRange( 3, 5)];
      printf( "substringRange: %s\n", [s2 UTF8String]);

      // --- stringByAppendingString: ---
      s  = @"Hello";
      s2 = [s stringByAppendingString:@" World"];
      printf( "append: %s\n", [s2 UTF8String]);

      // --- UTF8String / length / characterAtIndex: ---
      s = @"ABC";
      printf( "UTF8String: %s\n", [s UTF8String]);
      printf( "length: %lu\n", (unsigned long) [s length]);
      printf( "char0: %c\n",   (char) [s characterAtIndex:0]);
      printf( "char2: %c\n",   (char) [s characterAtIndex:2]);

      // --- getCharacters: ---
      {
         unichar   buf[4];
         [s getCharacters:buf];
         printf( "getChars: %c%c%c\n", (char) buf[0], (char) buf[1], (char) buf[2]);
      }

      // --- mulleGetUTF8Characters:maxLength: ---
      {
         char   buf[8];
         NSUInteger used;
         used = [s mulleGetUTF8Characters:buf maxLength:sizeof( buf)];
         buf[used] = '\0';
         printf( "getUTF8Chars: %s len=%lu\n", buf, (unsigned long) used);
      }

      // --- initWithCharacters:length: ---
      {
         unichar   chars[3] = { 'X', 'Y', 'Z' };
         s = [[[NSString alloc] initWithCharacters:chars length:3] autorelease];
         printf( "initWithChars: %s\n", [s UTF8String]);
      }

      // --- mulleInitWithUTF8Characters:length: ---
      {
         char  utf8[] = "mulle";
         s = [[[NSString alloc] mulleInitWithUTF8Characters:utf8 length:5] autorelease];
         printf( "mulleInitUTF8: %s\n", [s UTF8String]);
      }

      // --- mulleInitOrNilWithUTF8Characters:length: valid ---
      {
         char  utf8[] = "valid";
         s = [[[NSString alloc] mulleInitOrNilWithUTF8Characters:utf8 length:5] autorelease];
         printf( "mulleInitOrNil valid: %s\n", s ? [s UTF8String] : "nil");
      }

      // --- mulleStringByRemoving (on NSMutableString) ---
      {
         NSMutableString   *ms = [[[NSMutableString alloc] initWithString:@"Hello World"] autorelease];
         s2 = [ms mulleStringByRemovingPrefix:@"Hello "];
         printf( "removePrefix: %s\n", [s2 UTF8String]);
         s2 = [ms mulleStringByRemovingSuffix:@" World"];
         printf( "removeSuffix: %s\n", [s2 UTF8String]);
      }
   }
   return( 0);
}
