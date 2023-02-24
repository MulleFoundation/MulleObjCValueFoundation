//
//  _MulleObjCASCIIString.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#include "import.h"

#import "NSString.h"
#import "NSString+ClassCluster.h"

#import "_MulleObjCASCIIString.h"
#import "NSString+Substring-Private.h"

// other files in this library

// std-c and dependencies
#import "import-private.h"

#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCASCIIString

static inline char  *MulleObjCSmallStringAddress( _MulleObjCASCIIString *self)
{
   return( (char *) self);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= [self length])
      MulleObjCThrowInvalidIndexException( index);
   return( MulleObjCSmallStringAddress( self)[ index]);
}


- (unichar) :(NSUInteger) index
{
   if( index >= [self length])
      MulleObjCThrowInvalidIndexException( index);
   return( MulleObjCSmallStringAddress( self)[ index]);
}


static void   grab_utf32( id self,
                          SEL sel,
                          struct mulle_asciidata src,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   char   *s;
   char   *sentinel;

   // check both because of overflow range.length == (unsigned) -1 f.e.
   range    = MulleObjCValidateRangeAgainstLength( range, src.length);

   s        = &src.characters[ range.location];
   sentinel = &s[ range.length];

   while( s < sentinel)
      *dst++ = *s++;
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   struct mulle_asciidata   data;
   BOOL                     flag;

   flag = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   grab_utf32( self, _cmd, data, buf, range);
}


static NSUInteger   grab_ascii( id self,
                                char *dst,
                                NSUInteger maxLength)
{
   struct mulle_asciidata   data;
   BOOL                     flag;
   NSUInteger               length;

   flag = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   length = data.length > maxLength ? maxLength : data.length;
   memcpy( dst, data.characters, length);
   return( length);
}


static NSUInteger   grab_ascii_range( id self,
                                      NSUInteger length,
                                      char *dst,
                                      NSRange range)
{
   struct mulle_asciidata   data;
   BOOL                     flag;

   assert( range.length != (NSUInteger) -1); // not cool to guess

   flag  = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   range = MulleObjCValidateRangeAgainstLength( range, length);
   memcpy( dst, &data.characters[ range.location], range.length);
   return( range.length);
}



- (NSUInteger) mulleGetASCIICharacters:(char *) buf
                             maxLength:(NSUInteger) maxLength
{
   return( grab_ascii( self, buf, maxLength));
}



- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
{
   return( grab_ascii( self, buf, maxLength));
}


- (NSUInteger) mulleGetUTF8Characters:(char *) buf
                            maxLength:(NSUInteger) maxLength
                                range:(NSRange) range
{
   if( (NSUInteger) range.length > maxLength)
      range.length = maxLength;
   return( grab_ascii_range( self, [self length], (char *) buf, range));
}



#pragma mark - hash and equality

- (NSUInteger) hash
{
   struct mulle_asciidata   data;
   BOOL                     flag;

   flag = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   return( MulleObjCStringHashASCII( data.characters, data.length));
}


- (char *) UTF8String
{
   return( MulleObjCSmallStringAddress( self));
}


- (NSString *) substringWithRange:(NSRange) range
{
   struct mulle_asciidata   data;
   BOOL                     flag;

   flag  = [self mulleFastGetASCIIData:&data];
   assert( flag);
   MULLE_C_UNUSED( flag);

   range = MulleObjCValidateRangeAgainstLength( range, data.length);
   if( range.length == data.length)
      return( self);

   data.characters = &data.characters[ range.location];
   data.length     = range.length;
   return( [_mulleNewSubstringFromASCIIData( self, data) autorelease]);
}


@end


static void   utf32to8cpy( char *dst, mulle_utf32_t *src, NSUInteger len)
{
   char   *sentinel;

   sentinel = &dst[ len];
   while( dst < sentinel)
   {
      assert( (mulle_utf8_t) *src == *src);
      *dst++ = (mulle_utf8_t) *src++;
   }
}


#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES

@implementation _MulleObjC03LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 3) == 3);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;

   assert( mulle_utf32_strnlen( chars, 3) == 3);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 3); }
- (NSUInteger) length                { return( 3); }

- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 3;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 3;
   return( YES);
}


@end


@implementation _MulleObjC07LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 7) == 7);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;

   assert( mulle_utf32_strnlen( chars, 7) == 7);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}

- (NSUInteger) mulleUTF8StringLength  { return( 7); }
- (NSUInteger) length                 { return( 7); }


- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 7;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 7;
   return( YES);
}

@end


@implementation _MulleObjC11LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 11) == 11);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;

   assert( mulle_utf32_strnlen( chars, 11) == 11);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 11); }
- (NSUInteger) length                { return( 11); }

- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 11;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 11;
   return( YES);
}

@end


@implementation _MulleObjC15LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 15) == 15);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;

   assert( mulle_utf32_strnlen( chars, 15) == 15);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 15); }
- (NSUInteger) length                { return( 15); }

- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 15;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = MulleObjCSmallStringAddress( self);
   space->length     = 15;
   return( YES);
}

@end

#endif


@implementation _MulleObjCTinyASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;

   assert( length >= 1 && length < 0x100 + 1);
   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);

   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;

   assert( length >= 1 && length < 0x100 + 1);
   assert( mulle_utf32_strnlen( chars, length) == length);

   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   utf32to8cpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= _length + 1)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}

- (unichar) :(NSUInteger) index
{
   if( index >= _length + 1)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (char *) UTF8String
{
   return( _storage);
}


- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = _storage;
   space->length     = _length + 1;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = (mulle_utf8_t *) _storage;
   space->length     = _length + 1;
   return( YES);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( _length + 1);
}


- (NSUInteger) length
{
   return( _length + 1);
}


#if 1
- (instancetype) retain
{
   return( [super retain]);
}
#endif


- (void) release
{
   [super release];
}

@end


@implementation _MulleObjCGenericASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);

   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;

   assert( mulle_utf32_strnlen( chars, length) == length);

   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   utf32to8cpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
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

- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( _length);
}


- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = _storage;
   space->length     = _length;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = (mulle_utf8_t *) _storage;
   space->length     = _length;
   return( YES);
}


- (char *) UTF8String
{
   return( self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

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


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( _length);
}


- (BOOL) mulleFastGetASCIIData:(struct mulle_asciidata *) space
{
   space->characters = _storage;
   space->length     = _length;
   return( YES);
}


- (BOOL) mulleFastGetUTF8Data:(struct mulle_utf8data *) space
{
   space->characters = (mulle_utf8_t *) _storage;
   space->length     = _length;
   return( YES);
}


- (char *) UTF8String
{
   struct mulle_buffer   buffer;

   if( ! _shadow)
   {
      mulle_buffer_init_with_capacity( &buffer, _length + 1, MulleObjCInstanceGetAllocator( self));
      mulle_buffer_add_bytes( &buffer, _storage, _length);
      mulle_buffer_add_byte( &buffer, 0);
      _shadow = mulle_buffer_extract_bytes( &buffer);
      mulle_buffer_done( &buffer);
   }
   return( (char *) _shadow);
}


- (void) dealloc
{
   if( _shadow)
      mulle_allocator_free( MulleObjCInstanceGetAllocator( self), _shadow);

   NSDeallocateObject( self);
}

@end



@implementation _MulleObjCSharedASCIIString

+ (instancetype) newWithASCIICharactersNoCopy:(char *) s
                                       length:(NSUInteger) length
                                sharingObject:(id) sharingObject
{
   _MulleObjCSharedASCIIString  *data;

   assert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   data                 = NSAllocateObject( self, 0, NULL);
   data->_storage       = s;
   data->_length        = length;
   data->_sharingObject = [sharingObject retain];

   return( data);
}


- (void) dealloc
{
   [_sharingObject release];
   [super dealloc];
}

@end


@implementation _MulleObjCAllocatorASCIIString

static _MulleObjCAllocatorASCIIString   *
   _MulleObjCAllocatorASCIIStringNew( Class self,
                                      char *s,
                                      NSUInteger length,
                                      struct mulle_allocator *allocator)
{
   _MulleObjCAllocatorASCIIString   *string;

   assert( length);
   assert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   string             = NSAllocateObject( self, 0, NULL);
   string->_storage   = s;
   string->_length    = length;
   string->_allocator = allocator;

   return( string);
}


+ (instancetype) newWithASCIICharactersNoCopy:(char *) s
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator
{
   return( _MulleObjCAllocatorASCIIStringNew( self, s, length, allocator));
}


- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   [super dealloc];
}

@end


@implementation _MulleObjCAllocatorZeroTerminatedASCIIString


+ (instancetype) newWithZeroTerminatedASCIICharactersNoCopy:(char *) s
                                                     length:(NSUInteger) length
                                                  allocator:(struct mulle_allocator *) allocator
{
   if( s[ length])
      MulleObjCThrowInvalidArgumentExceptionUTF8String( "is not zero terminated");

   return( (_MulleObjCAllocatorZeroTerminatedASCIIString *)
               _MulleObjCAllocatorASCIIStringNew( self, s, length, allocator));
}

- (char *) UTF8String
{
   return( self->_storage);
}

@end

