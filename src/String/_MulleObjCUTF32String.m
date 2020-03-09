//
//  _MulleObjCUTF32String.m
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

#import "_MulleObjCUTF32String.h"

// other files in this library
#import "NSString+NSData.h"

// other libraries of MulleObjCValueFoundation

// std-c and dependencies
#import "import-private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@interface _MulleObjCUTF32String ( Future)

// these are **not** zero terminated
- (mulle_utf32_t *) _fastUTF32Characters;

@end


@implementation _MulleObjCUTF32String

- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) _UTF32StringLength
{
   return( _length);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( mulle_utf32_utf8length( [self _fastUTF32Characters], _length));
}


- (char *) UTF8String
{
   struct mulle_buffer  buf;

   if( ! _shadow)
   {
      mulle_buffer_init( &buf, MulleObjCInstanceGetAllocator( self));
      mulle_utf32_bufferconvert_to_utf8( [self _fastUTF32Characters],
                                         [self _UTF32StringLength],
                                         &buf,
                                         (void (*)()) mulle_buffer_add_bytes);

      mulle_buffer_add_byte( &buf, 0);
      _shadow = mulle_buffer_extract_all( &buf);
      mulle_buffer_done( &buf);
   }
   return( (char *) _shadow);
}


static void   grab_utf32( id self,
                          SEL sel,
                          mulle_utf32_t *storage,
                          NSUInteger length,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, length);

   memcpy( dst, &storage[ range.location], range.length * sizeof( mulle_utf32_t));
}



- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   grab_utf32( self,
               _cmd,
               [self _fastUTF32Characters],
               [self length],
               buf,
               range);
}


- (void) dealloc
{
   if( _shadow)
      MulleObjCObjectDeallocateMemory( self, _shadow);
   [super dealloc];
}


- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf32_t   *s;
   NSUInteger      length;

   length = [self length];
   range = MulleObjCValidateRangeAgainstLength( range, length);

   s = [self _fastUTF32Characters];
   assert( s);

   s = &s[ range.location];

   return( [[_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:s
                                                               length:range.length
                                                        sharingObject:self] autorelease]);
}


- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding
{
   switch( encoding)
   {
   case NSUTF32StringEncoding : return( [self length] * sizeof( mulle_utf32_t));
   }
   return( [super lengthOfBytesUsingEncoding:encoding]);
}

@end


@implementation _MulleObjCGenericUTF32String

+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCGenericUTF32String   *obj;

   assert( mulle_utf32_strnlen( chars, length) == length);

   obj = NSAllocateObject( self, (length * sizeof( mulle_utf32_t)) - sizeof( obj->_storage), NULL);
   memcpy( obj->_storage, chars, length * sizeof( mulle_utf32_t));
   obj->_length = length;
   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32Characters
{
   return( _storage);
}

@end


@implementation _MulleObjCAllocatorUTF32String

+ (instancetype) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                                       length:(NSUInteger) length
                                   allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorUTF32String   *obj;

   assert( mulle_utf32_strnlen( chars, length) == length);

   obj             = NSAllocateObject( self, 0, NULL);
   obj->_storage   = chars;
   obj->_length    = length;
   obj->_allocator = allocator;

   return( obj);
}

- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32Characters
{
   return( _storage);
}


- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   [super dealloc];
}

@end



@implementation _MulleObjCSharedUTF32String

+ (instancetype) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                                      length:(NSUInteger) length
                               sharingObject:(id) sharingObject
{
   _MulleObjCSharedUTF32String  *data;

   assert( mulle_utf32_strnlen( (mulle_utf32_t *) chars, length) == length);

   data                 = NSAllocateObject( self, 0, NULL);
   data->_storage       = chars;
   data->_length        = length;
   data->_sharingObject = [sharingObject retain];

   return( data);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32Characters
{
   return( _storage);
}


- (void) dealloc
{
   [_sharingObject release];

   [super dealloc];
}

@end
