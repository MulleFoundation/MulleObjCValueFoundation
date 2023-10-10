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
#import "NSString+Substring-Private.h"

// other libraries of MulleObjCValueFoundation

// std-c and dependencies
#import "import-private.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCUTF32String


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) mulleUTF8StringLength
{
   struct mulle_utf32data   data;
   BOOL                      flag;

   flag = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   return( mulle_utf32_utf8length( data.characters, data.length));
}


- (char *) UTF8String
{
   struct mulle_buffer      buf;
   struct mulle_utf32data   data;
   BOOL                     flag;

   if( ! _shadow)
   {
      flag = [self mulleFastGetUTF32Data:&data];
      assert( flag);
      MULLE_C_UNUSED( flag);

      mulle_buffer_init_with_capacity( &buf, data.length * 4, MulleObjCInstanceGetAllocator( self));
      mulle_utf32_bufferconvert_to_utf8( data.characters,
                                         data.length,
                                         &buf,
                                         (mulle_utf_add_bytes_function_t) mulle_buffer_add_bytes);

      mulle_buffer_add_byte( &buf, 0);
      mulle_buffer_size_to_fit( &buf);
      _shadow = mulle_buffer_extract_bytes( &buf);
      mulle_buffer_done( &buf);
   }
   return( (char *) _shadow);
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   struct mulle_utf32data   data;
   BOOL                     flag;

   flag = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range = MulleObjCValidateRangeAgainstLength( range, data.length);
   memcpy( buf, &data.characters[ range.location], range.length * sizeof( mulle_utf32_t));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
{
   struct mulle_utf8_conversion_context   ctxt;
   struct mulle_utf32data                 data;
   BOOL                                   flag;
   NSUInteger                             length;

   flag = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   ctxt.buf      = buf;
   ctxt.sentinel = &buf[ maxLength];

   //
   // mulle_utf32_bufferconvert_to_utf8 will not create incomplete emojis,
   // if the length runs out. But sometimes emojis are composed from multiple
   // emojis, and this routine doesn't know about it.
   // If you fix this, also fix MulleStringUTF8Data.
   //
   mulle_utf32_bufferconvert_to_utf8( data.characters,
                                      data.length,
                                      &ctxt,
                                      mulle_utf8_conversion_context_add_bytes);
   assert( ! memchr( buf, 0, ctxt.buf - buf));

   length = (NSUInteger) (ctxt.buf - buf);
   return( length);
}



- (void) dealloc
{
   if( _shadow)
      MulleObjCInstanceDeallocateMemory( self, _shadow);
   [super dealloc];
}


- (NSString *) substringWithRange:(NSRange) range
{
   struct mulle_utf32data   data;
   BOOL                     flag;

   flag   = [self mulleFastGetUTF32Data:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   range  = MulleObjCValidateRangeAgainstLength( range, data.length);
   if( range.length == data.length)
      return( self);

   data.characters = &data.characters[ range.location];
   data.length     = range.length;
   return( [_mulleNewSubstringFromUTF32Data( self, data) autorelease]);
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

- (unichar) :(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) data
{
   data->characters = _storage;
   data->length     = _length;
   return( YES);
}


- (NSUInteger) hash
{
   return( MulleObjCStringHashUTF32( _storage, _length));
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


- (unichar) :(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) data
{
   data->characters = _storage;
   data->length     = _length;
   return( YES);
}


- (NSUInteger) hash
{
   return( MulleObjCStringHashUTF32( _storage, _length));
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


- (BOOL) mulleFastGetUTF32Data:(struct mulle_utf32data *) data
{
   data->characters = _storage;
   data->length     = _length;
   return( YES);
}


- (NSUInteger) hash
{
   return( MulleObjCStringHashUTF32( _storage, _length));
}


- (void) dealloc
{
   [_sharingObject release];

   [super dealloc];
}

@end
