#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   @autoreleasepool
   {
      NSData          *d;
      NSData          *empty;
      NSMutableData   *md;
      NSMutableData   *textData;
      unsigned char   *bytes;
      unsigned char   bad;

      // stringValue produces hex dump like "<deadbeef >"
      d = [NSData dataWithBytes:"\xde\xad\xbe\xef" length:4];
      mulle_printf( "data stringValue: %s\n", [[d stringValue] UTF8String]);
      mulle_printf( "data description: %s\n", [[d description] UTF8String]);

      // empty data
      empty = [NSData data];
      mulle_printf( "empty: %s\n", [[empty stringValue] UTF8String]);

      // NSMutableData stringValue
      md    = [NSMutableData dataWithLength:4];
      bytes = [md mutableBytes];
      bytes[0] = 0xca;
      bytes[1] = 0xfe;
      bytes[2] = 0xba;
      bytes[3] = 0xbe;
      mulle_printf( "mutable: %s\n", [[md stringValue] UTF8String]);

      // mulleReplaceInvalidCharactersWithASCIICharacter:encoding:
      textData = [NSMutableData data];
      [textData appendData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
      bad = 0xff;
      [textData appendBytes:&bad length:1];
      [textData appendData:[@"World" dataUsingEncoding:NSUTF8StringEncoding]];
      [textData mulleReplaceInvalidCharactersWithASCIICharacter:'?'
                                                        encoding:NSUTF8StringEncoding];
      mulle_printf( "replaced: %s\n", [[textData stringValue] UTF8String]);
   }

   return( 0);
}
