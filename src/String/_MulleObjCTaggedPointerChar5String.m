//
//  _MulleObjCTaggedPointerChar5String.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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
#import "NSString.h"

// other files in this library
#import "_MulleObjCTaggedPointerChar5String.h"
//#import "NSMutableData.h"

// std-c and dependencies
#import "import-private.h"
#include <assert.h>



#ifdef __MULLE_OBJC_TPS__

@implementation _MulleObjCTaggedPointerChar5String

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x1))
   {
      perror( "Need tag pointer aware runtime for _MulleObjCTaggedPointerChar5String with empty slot #1\n");
      abort();
   }
}


NSString  *MulleObjCTaggedPointerChar5StringWithASCIICharacters( char *s, NSUInteger length)
{
   uintptr_t   value;

   assert( length);
   assert( [_MulleObjCTaggedPointerChar5String isTaggedPointerEnabled]);

   value = mulle_char5_encode( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}


NSString  *MulleObjCTaggedPointerChar5StringWithUTF16Characters( mulle_utf16_t *s, NSUInteger length)
{
   uintptr_t   value;

   assert( length);
   assert( [_MulleObjCTaggedPointerChar5String isTaggedPointerEnabled]);

   value = mulle_char5_encode_utf16( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}


NSString  *MulleObjCTaggedPointerChar5StringWithCharacters( unichar *s, NSUInteger length)
{
   uintptr_t   value;

   assert( length);
   assert( [_MulleObjCTaggedPointerChar5String isTaggedPointerEnabled]);

   value = mulle_char5_encode_utf32( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}


static inline NSUInteger
   MulleObjCTaggedPointerChar5StringGetLength( _MulleObjCTaggedPointerChar5String *self)
{
   uintptr_t    value;
   NSUInteger   length;

   value  = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_fstrlen( value);
   return( length);
}


- (NSUInteger) length
{
   return( MulleObjCTaggedPointerChar5StringGetLength( self));
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;

   value  = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);

   return( (unichar) mulle_char5_get( value, (unsigned int) index));
}

- (unichar) :(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;

   value  = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length = (NSUInteger) mulle_char5_strlen( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);

   return( (unichar) mulle_char5_get( value, (unsigned int) index));
}


static NSUInteger   grab_ascii_char5_range( id self, NSUInteger length, char *dst, NSRange range)
{
   uintptr_t   value;
   char        tmp[ mulle_char5_maxlength64];

   assert( length <= mulle_char5_maxlength64);
   assert( range.length != (NSUInteger) -1); // not cool to guess

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, length);
   value = _MulleObjCTaggedPointerChar5ValueFromString( self);
   if( range.location)
   {
      mulle_char5_decode( value, tmp, length);
      memcpy( dst, &tmp[ range.location], range.length);
      return( range.length);
   }

   mulle_char5_decode( value, dst, range.length);
   return( range.length);
}


static NSUInteger   grab_ascii_char5( _MulleObjCTaggedPointerChar5String *self,
                                      char *buf,
                                      NSUInteger maxLength)
{
   NSUInteger   length;

   length = MulleObjCTaggedPointerChar5StringGetLength( self);
   if( length > maxLength)
      length = maxLength;
   length = grab_ascii_char5_range( self, length, buf, NSMakeRange( 0, length));
   return( length);
}


- (NSUInteger) mulleGetASCIICharacters:(char *) buf
                             maxLength:(NSUInteger) maxLength
{
   return( grab_ascii_char5( self, buf, maxLength));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
{
   return( grab_ascii_char5( self, (char *) buf, maxLength));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
                                range:(NSRange) range
{
   NSUInteger   length;

   if( (NSUInteger) range.length > maxLength)
      range.length = maxLength;

   length = MulleObjCTaggedPointerChar5StringGetLength( self);
   return( grab_ascii_char5_range( self, length, (char *) buf, range));
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   NSUInteger   length;
   char         tmp[ mulle_char5_maxlength64];

   length = MulleObjCTaggedPointerChar5StringGetLength( self);
   length = grab_ascii_char5_range( self, length, tmp, range);
   _mulle_ascii_convert_to_utf32( tmp, length, buf);
}




#pragma mark - hash and equality

- (NSUInteger) hash
{
   uintptr_t   value;
   uintptr_t   hash;

   value = _MulleObjCTaggedPointerChar5ValueFromString( self);
   hash  = _mulle_char5_hash_nsstring( value);
   // hash  = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8 - 4));
   return( (NSUInteger) hash);
}


- (BOOL) isEqualToString:(NSString *) other
{
   NSUInteger     length;
   NSUInteger     otherLength;
   uintptr_t      value;
   unsigned int   i;
   char           c;
   char           buf[ mulle_char5_maxlength64 * 4];

   //
   // Out main concern is isEqual: and we don't want to duplicate the == other
   // test here
   //
   value       = _MulleObjCTaggedPointerChar5ValueFromString( self);
   length      = (NSUInteger) mulle_char5_strlen( value);
   otherLength = [other length];

   if( length != otherLength)
      return( NO);

  // other is known to have same length
  // and each unichar can expand into 4 chars max

   [other mulleGetUTF8Characters:(char *) buf
                       maxLength:sizeof( buf)];
   for( i = 0; i < length; i++)
   {
      c = mulle_char5_next( &value);
      if( c != buf[ i])
         return( NO);
   }
   return( YES);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( MulleObjCTaggedPointerChar5StringGetLength( self));
}


- (char *) UTF8String
{
   NSUInteger   length;
   char         *s;

   length  = MulleObjCTaggedPointerChar5StringGetLength( self);
   s       = MulleObjCCallocAutoreleased( length + 1, sizeof( char));
   grab_ascii_char5_range( self, length, s, NSMakeRange( 0, length));
   // final byte already zero by calloc
   return( (char *) s);
}


- (NSString *) substringWithRange:(NSRange) range
{
   NSUInteger   length;
   uintptr_t    value;

   length = MulleObjCTaggedPointerChar5StringGetLength( self);

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, length);

   value = _MulleObjCTaggedPointerChar5ValueFromString( self);
   value = mulle_char5_substring( value,
                                 (unsigned int) range.location,
                                 (unsigned int) range.length);
   return( _MulleObjCTaggedPointerChar5StringFromValue( value));
}

@end

#endif
