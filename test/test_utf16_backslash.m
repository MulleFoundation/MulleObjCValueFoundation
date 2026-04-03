#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

int main()
{
   NSString *original = @"Z:\\home\\test";
   mulle_utf16_t *utf16;
   NSString *roundtrip;
   
   mulle_printf("Original: '%s'\n", [original UTF8String]);
   
   utf16 = [original mulleUTF16String];
   if( utf16)
   {
      mulle_printf("UTF16 conversion OK\n");
      roundtrip = [NSString mulleStringWithUTF16String:utf16];
      mulle_printf("Roundtrip: '%s'\n", roundtrip ? [roundtrip UTF8String] : "(nil)");
   }
   
   return 0;
}
