#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSString   *long1;
      NSString   *long2;
      NSString   *long3;
      NSString   *utf16str;
      NSData     *utf16data;
      NSUInteger  h;

      // Long ASCII strings (force non-tagged-pointer path)
      long1 = @"abcdefghijklmnopqrstuvwxyz01234567890";
      long2 = @"abcdefghijklmnopqrstuvwxyz01234567890";
      long3 = @"abcdefghijklmnopqrstuvwxyz012345678901";

      mulle_printf( "hash1==%s\n", [long1 hash] == [long2 hash] ? "YES" : "NO");
      mulle_printf( "hash2==%s\n", [long1 hash] == [long3 hash] ? "YES" : "NO");

      mulle_printf( "equal1==%s\n", [long1 isEqual:long2] ? "YES" : "NO");
      mulle_printf( "equal2==%s\n", [long1 isEqual:long3] ? "YES" : "NO");

      // UTF16 string via initWithData:encoding:
      {
         uint16_t   utf16_chars[] = {
            'H','e','l','l','o',' ','W','o','r','l','d',
            '!','!','!','!','!','!','!','!','!'
         };
         utf16data = [NSData dataWithBytes:utf16_chars
                                    length:sizeof( utf16_chars)];
         utf16str  = [NSString mulleStringWithData:utf16data
                                          encoding:NSUTF16LittleEndianStringEncoding];
         h = [utf16str hash];
         mulle_printf( "utf16 hash nonzero==%s\n", h != 0 ? "YES" : "NO");
      }
   }

   return( 0);
}
