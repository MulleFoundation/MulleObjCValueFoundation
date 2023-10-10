//
//  _MulleObjCTaggedPointerChar7String.m
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
#import "NSMutableData.h"
#import "_MulleObjCTaggedPointerChar7String.h"

// std-c and dependencies
#import "import-private.h"
#include <assert.h>


#ifdef __MULLE_OBJC_TPS__

@implementation _MulleObjCTaggedPointerChar7String

+ (void) load
{
   if( MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x3))
   {
      perror( "Need tag pointer aware runtime for _MulleObjCTaggedPointerChar7String with empty slot #3\n");
      abort();
   }
}


NSString  *MulleObjCTaggedPointerChar7StringWithASCIICharacters( char *s, NSUInteger length)
{
   uintptr_t   value;

   assert( [_MulleObjCTaggedPointerChar7String isTaggedPointerEnabled]);

   value = mulle_char7_encode( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}


NSString  *MulleObjCTaggedPointerChar7StringWithUTF16Characters( mulle_utf16_t *s, NSUInteger length)
{
   uintptr_t   value;

   assert( [_MulleObjCTaggedPointerChar7String isTaggedPointerEnabled]);

   value = mulle_char7_encode_utf16( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}


NSString  *MulleObjCTaggedPointerChar7StringWithCharacters( unichar *s, NSUInteger length)
{
   uintptr_t   value;

   assert( [_MulleObjCTaggedPointerChar7String isTaggedPointerEnabled]);

   value = mulle_char7_encode_utf32( s, (size_t) length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}


static inline NSUInteger  MulleObjCTaggedPointerChar7StringGetLength( _MulleObjCTaggedPointerChar7String *self)
{
   uintptr_t    value;
   NSUInteger   length;

   value  = _MulleObjCTaggedPointerChar7ValueFromString( self);
   length = (NSUInteger) mulle_char7_fstrlen( value);
   return( length);
}


- (NSUInteger) length
{
   return( MulleObjCTaggedPointerChar7StringGetLength( self));
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   uintptr_t    value;
   NSUInteger   length;

   value  = _MulleObjCTaggedPointerChar7ValueFromString( self);
   length = (NSUInteger) mulle_char7_strlen( value);

   if( index >= length)
      MulleObjCThrowInvalidIndexException( index);

   return( (unichar) mulle_char7_get( value, (unsigned int) index));
}


static NSUInteger
   grab_ascii_char7_range( id self, NSUInteger length, char *dst, NSRange range)
{
   char        tmp[ mulle_char7_maxlength64];
   uintptr_t   value;

   assert( length <= mulle_char7_maxlength64);
   assert( range.length != (NSUInteger) -1); // not cool to guess

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, length);
   value = _MulleObjCTaggedPointerChar7ValueFromString( self);
   if( range.location)
   {
      mulle_char7_decode( value, tmp, length);
      memcpy( dst, &tmp[ range.location], range.length);
      return( range.length);
   }

   mulle_char7_decode( value, dst, range.length);
   return( range.length);
}


static NSUInteger   grab_ascii_char7( _MulleObjCTaggedPointerChar7String *self,
                                      char *buf,
                                      NSUInteger maxLength)
{
   NSUInteger   length;

   length = MulleObjCTaggedPointerChar7StringGetLength( self);
   if( length > maxLength)
      length = maxLength;
   length = grab_ascii_char7_range( self, length, buf, NSMakeRange( 0, length));
   return( length);
}


- (NSUInteger) mulleGetASCIICharacters:(char *) buf
                             maxLength:(NSUInteger) maxLength
{
   return( grab_ascii_char7( self, buf, maxLength));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
{
   return( grab_ascii_char7( self, (char *) buf, maxLength));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
                                range:(NSRange) range
{
   NSUInteger   length;

   if( (NSUInteger) range.length > maxLength)
      range.length = maxLength;

   length = MulleObjCTaggedPointerChar7StringGetLength( self);
   return( grab_ascii_char7_range( self, length, (char *) buf, range));
}



- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   NSUInteger   length;
   char         tmp[ mulle_char7_maxlength64];  // known ascii max 8

   length = MulleObjCTaggedPointerChar7StringGetLength( self);
   length = grab_ascii_char7_range( self, length, tmp, range);
   _mulle_ascii_convert_to_utf32( tmp, length, buf);
}



#pragma mark - hash and equality

- (NSUInteger) hash
{
   uintptr_t   value;
   uintptr_t   hash;

   value = _MulleObjCTaggedPointerChar7ValueFromString( self);
   hash  = _mulle_char7_hash_nsstring( value);
//   hash  = (hash << 4) | (hash >> (sizeof( uintptr_t) * 8  - 4));
   return( (NSUInteger) hash);
}


- (BOOL) isEqualToString:(NSString *) other
{
   NSUInteger     length;
   NSUInteger     otherLength;
   uintptr_t      value;
   unsigned int   i;
   char           c;
   char           buf[ mulle_char7_maxlength64 * 4];

   value       = _MulleObjCTaggedPointerChar7ValueFromString( self);
   length      = (NSUInteger) mulle_char7_strlen( value);
   otherLength = [other length];
   if( length != otherLength)
      return( NO);

   // other is known to have same length
   // and each unichar canexpand into 4 chars max
   [other mulleGetUTF8Characters:buf
                       maxLength:sizeof( buf)];

   for( i = 0; i < length; i++)
   {
      c = mulle_char7_next( &value);
      if( c != buf[ i])
         return( NO);
   }
   return( YES);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( MulleObjCTaggedPointerChar7StringGetLength( self));
}


- (char *) UTF8String
{
   NSUInteger  length;
   char        *s;

   length = MulleObjCTaggedPointerChar7StringGetLength( self);
   s      = MulleObjCCallocAutoreleased( length + 1, sizeof( char));
   grab_ascii_char7_range( self, length, s, NSMakeRange( 0, length));
   // final byte already zero by calloc
   return( (char *) s);
}


// can be done easier just with shifting and masking!
- (NSString *) substringWithRange:(NSRange) range
{
   NSUInteger   length;
   NSUInteger   value;

   length = MulleObjCTaggedPointerChar7StringGetLength( self);

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, length);

   value = _MulleObjCTaggedPointerChar7ValueFromString( self);
   value = mulle_char7_substring( value,
                                  (unsigned int) range.location,
                                  (unsigned int) range.length);
   return( _MulleObjCTaggedPointerChar7StringFromValue( value));
}

@end

#endif
