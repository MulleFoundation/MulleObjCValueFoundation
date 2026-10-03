#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif

#include <stdint.h>
#include <string.h>


//
// String literals are NSConstantString and never tagged pointers. Only
// strings created at runtime can become tagged pointers. So create them with
// mulleInitWithUTF8Characters:length: to hit the char5/char7 tagged pointer
// subclasses (when the platform supports them).
//
static NSString   *runtimeString( char *s)
{
   return( [[[NSString alloc] mulleInitWithUTF8Characters:s
                                                   length:strlen( s)] autorelease]);
}


//
// exercise the "subclass needs": the primitive methods that every concrete
// NSString subclass must provide, and the methods that are built on top of
// them (like substringWithRange:)
//
static void   check( char *s)
{
   NSString   *string;
   NSString   *sub;
   unichar    chars[ 32];
   char       buf[ 32];

   string = runtimeString( s);

   mulle_printf( "\"%s\" length: %lu\n", s, (unsigned long) [string length]);
   mulle_printf( "\"%s\" characterAtIndex(1): %c\n", s, (int) [string characterAtIndex:1]);
   mulle_printf( "\"%s\" UTF8String: %s\n", s, [string UTF8String]);
   mulle_printf( "\"%s\" mulleUTF8StringLength: %lu\n",
      s, (unsigned long) [string mulleUTF8StringLength]);

   sub = [string substringWithRange:NSMakeRange( 2, 3)];
   mulle_printf( "\"%s\" substringWithRange(2,3): %s\n", s, [sub UTF8String]);

   sub = [string substringFromIndex:2];
   mulle_printf( "\"%s\" substringFromIndex(2): %s\n", s, [sub UTF8String]);

   sub = [string substringToIndex:3];
   mulle_printf( "\"%s\" substringToIndex(3): %s\n", s, [sub UTF8String]);

   memset( chars, 0, sizeof( chars));
   [string getCharacters:chars
                   range:NSMakeRange( 2, 3)];
   mulle_printf( "\"%s\" getCharacters range: %c%c%c\n",
      s, (int) chars[ 0], (int) chars[ 1], (int) chars[ 2]);

   memset( buf, 0, sizeof( buf));
   [string mulleGetUTF8Characters:buf
                        maxLength:sizeof( buf)
                            range:NSMakeRange( 1, 2)];
   mulle_printf( "\"%s\" mulleGetUTF8Characters range: %s\n", s, buf);
}


int   main( void)
{
   @autoreleasepool
   {
      NSString   *string;
      NSString   *other;

      // 7 chars: char7 on 64 bit, generic ASCII on 32 bit
      check( "abcdefg");

      // 12 chars: char5 on 64 bit, generic ASCII otherwise
      check( "abcdabcdabcd");

      // exactly the char7 boundary
      string = runtimeString( "abcdefgh");
      mulle_printf( "8-char length: %lu\n", (unsigned long) [string length]);

      // equality and hash are also implemented per subclass
      string = runtimeString( "abc");
      other  = runtimeString( "abc");
      mulle_printf( "isEqualToString: %s\n",
         [string isEqualToString:other] ? "yes" : "no");
      mulle_printf( "hash: %s\n",
         [string hash] == [other hash] ? "yes" : "no");
   }

   return( 0);
}
