#import <MulleObjCValueFoundation/MulleObjCValueFoundation.h>

static void test_size(int size)
{
   NSMutableString *original;
   mulle_utf16_t *utf16;
   NSString *roundtrip;
   int i;
   
   original = [NSMutableString string];
   for( i = 0; i < size; i++)
      [original appendString:(i % 2) ? @"\\" : @"X"];
   
   utf16 = [original mulleUTF16String];
   if( utf16)
   {
      roundtrip = [NSString mulleStringWithUTF16String:utf16];
      if( [original isEqualToString:roundtrip])
         mulle_printf("Size %3d: PASS\n", size);
      else
         mulle_printf("Size %3d: FAIL - mismatch (expected '%s', got '%s')\n", 
                     size, [original UTF8String], [roundtrip UTF8String]);
   }
   else
      mulle_printf("Size %3d: FAIL - NULL utf16\n", size);
}

int main()
{
   int sizes[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
                  15, 16, 17,
                  31, 32, 33,
                  63, 64, 65,
                  127, 128, 129,
                  255, 256, 257};
   int i;
   
   for( i = 0; i < sizeof(sizes)/sizeof(sizes[0]); i++)
      test_size(sizes[i]);
   
   return 0;
}
