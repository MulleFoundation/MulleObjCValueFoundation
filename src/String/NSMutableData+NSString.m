#import "NSMutableData+NSString.h"

#import "import-private.h"


@implementation NSMutableData( NSString)

- (void) mulleReplaceInvalidCharactersWithASCIICharacter:(char) c
                                                encoding:(NSStringEncoding) encoding
{
   struct mulle_data   data;

   if( c < ' ' || c >= 0x7F)
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "character must be printable ascii");

   data = [self mulleMutableData];
   switch( encoding)
   {
   default :
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "encoding not supported for replacement");

   case NSASCIIStringEncoding :
      {
         char   *s;
         char   *sentinel;

         s        = data.bytes;
         sentinel = &s[ data.length];
         while( s < sentinel)
         {
            if( ! *s)
            {
               [self setLength:s - (char *) data.bytes];
               return;
            }
            if( *(unsigned char *) s >= 0x80)
               *s = c;
            ++s;
         }
         return;
      }

   case NSUTF8StringEncoding :
      {
         mulle_utf8_t   *s;
         mulle_utf8_t   *sentinel;
         size_t         len;

         s        = data.bytes;
         sentinel = &s[ data.length];
         len      = data.length;

         for(;;)
         {
            s = mulle_utf8_validate( s, len);
            if( ! s)
               return;
            if( ! *s)
            {
               [self setLength:s - (mulle_utf8_t *) data.bytes];
               return;
            }
            *s  = c;
            len = sentinel - s;
         }
      }
      break;

   case NSUTF16StringEncoding :
      {
         mulle_utf16_t   *s;
         mulle_utf16_t   *sentinel;
         size_t         len;

         s        = data.bytes;
         sentinel = &s[ data.length];
         len      = data.length;

         for(;;)
         {
            s = mulle_utf16_validate( s, len);
            if( ! s)
               return;
            if( ! *s)
            {
               [self setLength:(char *) s - (char *) data.bytes];
               return;
            }
            *s  = c;
            len = sentinel - s;
         }
      }
      break;

   case NSUTF32StringEncoding :
      {
         mulle_utf32_t   *s;
         mulle_utf32_t   *sentinel;
         size_t          len;

         s        = data.bytes;
         sentinel = &s[ data.length];
         len      = data.length;

         for(;;)
         {
            s = mulle_utf32_validate( s, len);
            if( ! s)
               return;
            if( ! *s)
            {
               [self setLength:(char *) s - (char *) data.bytes];
               return;
            }
            *s  = c;
            len = sentinel - s;
         }
      }
      break;
   }
}

@end