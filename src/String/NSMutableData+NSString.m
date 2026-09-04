//
//  NSMutableData+NSString.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#import "NSMutableData+NSString.h"

#import "import-private.h"


@implementation NSMutableData( NSString)

- (void) mulleReplaceInvalidCharactersWithASCIICharacter:(char) c
                                                encoding:(NSStringEncoding) encoding
{
   struct mulle_data   data;

   if( (unsigned char) c < ' ' || (unsigned char) c >= 0x7F)
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
         char     *s;
         char     *sentinel;
         size_t   len;

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
               [self setLength:s - (char *) data.bytes];
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
