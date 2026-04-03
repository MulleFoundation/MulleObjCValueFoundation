#ifndef __MULLE_OBJC__
# import <Foundation/Foundation.h>
#else
# import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>
#endif


int   main( void)
{
   NSString       *original;
   mulle_utf16_t  *utf16;
   size_t         utf16_len;

   // Test 1: Long path (original test case)
   original = @"Z:\\home\\src\\srcO\\MulleFoundation\\MulleObjCOSFoundation\\test\\NSBundle";

   utf16 = [original mulleUTF16String];
   if( ! utf16)
   {
      mulle_fprintf( stderr, "FAIL: mulleUTF16String returned NULL for long string\n");
      return( 1);
   }

   utf16_len = mulle_utf16_strlen( utf16);
   if( utf16_len != [original length])
   {
      mulle_fprintf( stderr, "FAIL: UTF16 length %lu != original length %lu (long string)\n",
                     (unsigned long) utf16_len,
                     (unsigned long) [original length]);
      return( 1);
   }

   // Test 2: Empty string
   original = @"";
   utf16 = [original mulleUTF16String];
   if( ! utf16 || mulle_utf16_strlen( utf16) != 0)
   {
      mulle_fprintf( stderr, "FAIL: empty string\n");
      return( 1);
   }

   // Test 3: Single char (tagged pointer)
   original = @"A";
   utf16 = [original mulleUTF16String];
   if( ! utf16 || mulle_utf16_strlen( utf16) != 1)
   {
      mulle_fprintf( stderr, "FAIL: single char\n");
      return( 1);
   }

   // Test 4: Small ASCII (char7 tagged pointer range)
   original = @"Hello";
   utf16 = [original mulleUTF16String];
   if( ! utf16 || mulle_utf16_strlen( utf16) != 5)
   {
      mulle_fprintf( stderr, "FAIL: small ASCII\n");
      return( 1);
   }

   // Test 5: Medium ASCII (tiny string)
   original = @"HelloWorld";
   utf16 = [original mulleUTF16String];
   if( ! utf16 || mulle_utf16_strlen( utf16) != 10)
   {
      mulle_fprintf( stderr, "FAIL: medium ASCII\n");
      return( 1);
   }

   mulle_fprintf( stdout, "PASS\n");
   return( 0);
}
